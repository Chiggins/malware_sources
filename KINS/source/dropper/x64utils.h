#ifndef _X64UTILS_H_
#define _X64UTILS_H_

#include "os_structs.h"

namespace x64Utils
{
	WOW64::TEB64* getTEB64();
	DWORD getNTDLL64();
	DWORD64 X64Call(DWORD func, int argC, ...);

	NTSTATUS x64RtlCreateUserThread(HANDLE ProcessHandle, DWORD64 StartAddress, DWORD64 Context, PHANDLE ThreadHandle);
	NTSTATUS x64NtAllocateVirtualMemory(HANDLE ProcessHandle, DWORD64 *BaseAddress, DWORD64 ImageSize, ULONG AllocationType, ULONG Protect);
	NTSTATUS x64NtWriteVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 Buffer, DWORD64 ImageSize);
	NTSTATUS x64NtReadVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 Buffer, DWORD64 ImageSize);
	NTSTATUS x64NtQueueApcThread(HANDLE ThreadHandle, DWORD64 ApcRoutine, DWORD64 ApcRoutineContext);
	NTSTATUS x64NtQueryVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, MEMORY_INFORMATION_CLASS Class, PVOID Buffer, ULONG Length);
	NTSTATUS x64NtFreeVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 FreeSize, ULONG FreeType);
	NTSTATUS x64NtQueryInformationProcess(HANDLE ProcessHandle, PROCESSINFOCLASS Class, PVOID Information, ULONG Length);

	DWORD64 x64RtlCompareMemory(DWORD64 Pointer, DWORD64 Bytes, DWORD64 Length);
	DWORD64 x64SearchBytesInMemory(DWORD64 RegionCopy, DWORD64 RegionSize, PVOID Bytes, DWORD Length);
	DWORD64 SearchBytesInReadedMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 Size, PVOID Bytes, DWORD Length);
	DWORD64 SearchBytesInProcessMemory(HANDLE ProcessHandle, PVOID Bytes, DWORD Length);
	DWORD64 SearchCodeInProcessModules(HANDLE ProcessHandle, PVOID Bytes, DWORD Length);

	typedef struct _PROC_MOD
	{
		WCHAR ModName[260];
		DWORD64 ModBase;
	}
	PROC_MOD, *PPROC_MOD;
	DWORD EnumProcessModules64(HANDLE ProcessHandle, PPROC_MOD *Modules);

	DWORD64 GetRemoteProcAddress(HANDLE ProcessHandle, PWCHAR ModuleName, PCHAR ProcedureName);
};

#endif