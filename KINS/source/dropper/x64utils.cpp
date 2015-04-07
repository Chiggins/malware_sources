#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <TlHelp32.h>

#include "utils.h"
#include "x64utils.h"
#include "os_structs.h"
#include "peldr.h"
#include "seccfg.h"

#pragma warning ( disable : 4409 )

//----------------------------------------------------------------------------------------------------------------------------------------------------
#ifndef _WIN64
//----------------------------------------------------------------------------------------------------------------------------------------------------

#define EMIT(a) __asm __emit (a)

#define X64_Start_with_CS(_cs) \
	{ \
	EMIT(0x6A) EMIT(_cs)                         /*  push   _cs             */ \
	EMIT(0xE8) EMIT(0) EMIT(0) EMIT(0) EMIT(0)   /*  call   $+5             */ \
	EMIT(0x83) EMIT(4) EMIT(0x24) EMIT(5)        /*  add    dword [esp], 5  */ \
	EMIT(0xCB)                                   /*  retf                   */ \
	}

#define X64_End_with_CS(_cs) \
	{ \
	EMIT(0xE8) EMIT(0) EMIT(0) EMIT(0) EMIT(0)                                 /*  call   $+5                   */ \
	EMIT(0xC7) EMIT(0x44) EMIT(0x24) EMIT(4) EMIT(_cs) EMIT(0) EMIT(0) EMIT(0) /*  mov    dword [rsp + 4], _cs  */ \
	EMIT(0x83) EMIT(4) EMIT(0x24) EMIT(0xD)                                    /*  add    dword [rsp], 0xD      */ \
	EMIT(0xCB)                                                                 /*  retf                         */ \
	}

#define X64_Start() X64_Start_with_CS(0x33)
#define X64_End() X64_End_with_CS(0x23)

#define _RAX  0
#define _RCX  1
#define _RDX  2
#define _RBX  3
#define _RSP  4
#define _RBP  5
#define _RSI  6
#define _RDI  7
#define _R8   8
#define _R9   9
#define _R10 10
#define _R11 11
#define _R12 12
#define _R13 13
#define _R14 14
#define _R15 15

#define X64_Push(r) EMIT(0x48 | ((r) >> 3)) EMIT(0x50 | ((r) & 7))
#define X64_Pop(r) EMIT(0x48 | ((r) >> 3)) EMIT(0x58 | ((r) & 7))

union reg64
{
	DWORD dw[2];
	DWORD64 v;
};

//----------------------------------------------------------------------------------------------------------------------------------------------------

WOW64::TEB64* x64Utils::getTEB64()
{
	reg64 reg;
	reg.v = 0;
	X64_Start();
	
	X64_Push(_R12);
	
	__asm pop reg.dw[0]
	X64_End();
	
	if (reg.dw[1] != 0) return 0;

	return (WOW64::TEB64*)reg.dw[0];
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD x64Utils::getNTDLL64()
{
	static DWORD ntdll64 = 0;
	if (ntdll64 != 0) return ntdll64;

	WOW64::TEB64* teb64 = getTEB64();
	WOW64::PEB64* peb64 = teb64->ProcessEnvironmentBlock;
	WOW64::PEB_LDR_DATA64* ldr = peb64->Ldr;

	WOW64::LDR_DATA_TABLE_ENTRY64* head = (WOW64::LDR_DATA_TABLE_ENTRY64*)ldr->InLoadOrderModuleList.Flink;
	do
	{
		if (!memcmp(head->BaseDllName.Buffer, L"ntdll.dll", head->BaseDllName.Length))
		{
			ntdll64 = (DWORD)head->DllBase;
		}

		head = (WOW64::LDR_DATA_TABLE_ENTRY64*)head->InLoadOrderLinks.Flink;
	}
	while (head != (WOW64::LDR_DATA_TABLE_ENTRY64*)&ldr->InLoadOrderModuleList);

	return ntdll64;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 x64Utils::X64Call(DWORD func, int argC, ...)
{
	va_list args;
	va_start(args, argC);
	DWORD64 _rcx = (argC > 0) ? argC--, va_arg(args, DWORD64) : 0;
	DWORD64 _rdx = (argC > 0) ? argC--, va_arg(args, DWORD64) : 0;
	DWORD64 _r8 = (argC > 0) ? argC--, va_arg(args, DWORD64) : 0;
	DWORD64 _r9 = (argC > 0) ? argC--, va_arg(args, DWORD64) : 0;
	reg64 _rax;
	_rax.v = 0;

	DWORD64 restArgs = (DWORD64)&va_arg(args, DWORD64);

	DWORD64 _argC = argC;
	DWORD64 _func = func;

	DWORD back_esp = 0;

	__asm
	{
		mov    back_esp, esp

		and    esp, 0xFFFFFFF8

		X64_Start();

		push   _rcx
		X64_Pop(_RCX);

		push   _rdx
		X64_Pop(_RDX);

		push   _r8
		X64_Pop(_R8);

		push   _r9
		X64_Pop(_R9);

		push   edi

		push   restArgs
		X64_Pop(_RDI);

		push   _argC
		X64_Pop(_RAX);

		test   eax, eax
		jz     _ls_e
		lea    edi, dword ptr [edi + 8*eax - 8]

_ls:
		test   eax, eax
		jz     _ls_e
		push   dword ptr [edi]
		sub    edi, 8
		sub    eax, 1
		jmp    _ls
_ls_e:

		sub    esp, 0x20

		call   _func

		push   _argC
		X64_Pop(_RCX);
		lea    esp, dword ptr [esp + 8*ecx + 0x20]

		pop    edi

		X64_Push(_RAX);
		pop    _rax.dw[0]

		X64_End();

		mov    esp, back_esp
	}

	return _rax.v;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64RtlCreateUserThread(HANDLE ProcessHandle, DWORD64 StartAddress, DWORD64 Context, PHANDLE ThreadHandle)
{
	static DWORD _RtlCreateUserThread = 0;
	if (!_RtlCreateUserThread)
	{
		_RtlCreateUserThread = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "RtlCreateUserThread");
		if (!_RtlCreateUserThread) return 0;
	}

	WOW64::CLIENT_ID64 Cid;
	return (NTSTATUS)X64Call(_RtlCreateUserThread, 10, (DWORD64)ProcessHandle, (DWORD64)NULL, (DWORD64)FALSE, (DWORD64)0, (DWORD64)0, (DWORD64)0, StartAddress, Context, (DWORD64)ThreadHandle, (DWORD64)&Cid);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtAllocateVirtualMemory(HANDLE ProcessHandle, DWORD64 *BaseAddress, DWORD64 ImageSize, ULONG AllocationType, ULONG Protect)
{
	static DWORD _ZwAllocateVirtualMemory = 0;
	if (!_ZwAllocateVirtualMemory)
	{
		_ZwAllocateVirtualMemory = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwAllocateVirtualMemory");
		if (!_ZwAllocateVirtualMemory) return 0;
	}

	return (NTSTATUS)X64Call(_ZwAllocateVirtualMemory, 6, (DWORD64)ProcessHandle, (DWORD64)BaseAddress, (DWORD64)0, (DWORD64)&ImageSize, (DWORD64)AllocationType, (DWORD64)Protect);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtWriteVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 Buffer, DWORD64 ImageSize)
{
	static DWORD _ZwWriteVirtualMemory = 0;
	if (!_ZwWriteVirtualMemory)
	{
		_ZwWriteVirtualMemory = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwWriteVirtualMemory");
		if (!_ZwWriteVirtualMemory) return 0;
	}

	DWORD64 Bytes;
	return (NTSTATUS)X64Call(_ZwWriteVirtualMemory, 5, (DWORD64)ProcessHandle, (DWORD64)BaseAddress, (DWORD64)Buffer, (DWORD64)ImageSize, (DWORD64)&Bytes);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtReadVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 Buffer, DWORD64 ImageSize)
{
	static DWORD _ZwReadVirtualMemory = 0;
	if (!_ZwReadVirtualMemory)
	{
		_ZwReadVirtualMemory = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwReadVirtualMemory");
		if (!_ZwReadVirtualMemory) return 0;
	}

	DWORD64 Bytes;
	return (NTSTATUS)X64Call(_ZwReadVirtualMemory, 5, (DWORD64)ProcessHandle, (DWORD64)BaseAddress, (DWORD64)Buffer, (DWORD64)ImageSize, (DWORD64)&Bytes);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtFreeVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 FreeSize, ULONG FreeType)
{
	static DWORD _ZwFreeVirtualMemory = 0;
	if (!_ZwFreeVirtualMemory)
	{
		_ZwFreeVirtualMemory = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwFreeVirtualMemory");
		if (!_ZwFreeVirtualMemory) return 0;
	}

	return (NTSTATUS)X64Call(_ZwFreeVirtualMemory, 4, (DWORD64)ProcessHandle, (DWORD64)&BaseAddress, (DWORD64)&FreeSize, (DWORD64)FreeType);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtQueueApcThread(HANDLE ThreadHandle, DWORD64 ApcRoutine, DWORD64 ApcRoutineContext)
{
	static DWORD _ZwNtQueueApcThread = 0;
	if (!_ZwNtQueueApcThread)
	{
		_ZwNtQueueApcThread = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwQueueApcThread");
		if (!_ZwNtQueueApcThread) return 0;
	}

	return (NTSTATUS)X64Call(_ZwNtQueueApcThread, 5, (DWORD64)ThreadHandle, (DWORD64)ApcRoutine, (DWORD64)ApcRoutineContext, (DWORD64)NULL, (DWORD64)NULL);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtQueryVirtualMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, MEMORY_INFORMATION_CLASS Class, PVOID Buffer, ULONG Length)
{
	static DWORD _ZwQueryVirtualMemory = 0;
	if (!_ZwQueryVirtualMemory)
	{
		_ZwQueryVirtualMemory = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwQueryVirtualMemory");
		if (!_ZwQueryVirtualMemory) return 0;
	}

	DWORD64 Bytes;
	return (NTSTATUS)X64Call(_ZwQueryVirtualMemory, 6, (DWORD64)ProcessHandle, (DWORD64)BaseAddress, (DWORD64)Class, (DWORD64)Buffer, (DWORD64)Length, (DWORD64)&Bytes);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 x64Utils::x64RtlCompareMemory(DWORD64 Pointer, DWORD64 Bytes, DWORD64 Length)
{
	static DWORD _RtlCompareMemory = 0;
	if (!_RtlCompareMemory)
	{
		_RtlCompareMemory = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "RtlCompareMemory");
		if (!_RtlCompareMemory) return 0;
	}

	return (DWORD64)X64Call(_RtlCompareMemory, 3, Pointer, Bytes, Length);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS x64Utils::x64NtQueryInformationProcess(HANDLE ProcessHandle, PROCESSINFOCLASS Class, PVOID Information, ULONG Length)
{
	static DWORD _ZwQueryInformationProcess = 0;
	if (!_ZwQueryInformationProcess)
	{
		_ZwQueryInformationProcess = (DWORD)PeLdr::PeGetProcAddress((PVOID)getNTDLL64(), "ZwQueryInformationProcess");
		if (!_ZwQueryInformationProcess) return 0;
	}

	DWORD64 Bytes;
	return (NTSTATUS)X64Call(_ZwQueryInformationProcess, 5, (DWORD64)ProcessHandle, (DWORD64)Class, (DWORD64)Information, (DWORD64)Length, (DWORD64)&Bytes);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 x64Utils::x64SearchBytesInMemory(DWORD64 RegionCopy, DWORD64 RegionSize, PVOID Bytes, DWORD Length)
{
	DWORD64 Result = 0;
	DWORD64 i = 0;

	if (RegionSize >= Length)
	{
		for (;;)
		{
			DWORD64 Pointer = RegionCopy + i;
			if (x64RtlCompareMemory(Pointer, (DWORD64)Bytes, (DWORD64)Length) == (DWORD64)Length)
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

DWORD64 x64Utils::SearchBytesInReadedMemory(HANDLE ProcessHandle, DWORD64 BaseAddress, DWORD64 Size, PVOID Bytes, DWORD Length)
{
	DWORD64 Result = 0;
	DWORD64 RegionCopy = NULL;
	NTSTATUS St;

	St = x64Utils::x64NtAllocateVirtualMemory(NtCurrentProcess(), &RegionCopy, Size, MEM_COMMIT|MEM_RESERVE, PAGE_READWRITE);
	if (NT_SUCCESS(St))
	{
		St = x64Utils::x64NtReadVirtualMemory(ProcessHandle, BaseAddress, RegionCopy, Size);
		if (NT_SUCCESS(St))
		{
			Result = x64Utils::x64SearchBytesInMemory(RegionCopy, Size, Bytes, Length);
		}

		x64Utils::x64NtFreeVirtualMemory(NtCurrentProcess(), RegionCopy, 0, MEM_RELEASE);
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 x64Utils::SearchBytesInProcessMemory(HANDLE ProcessHandle, PVOID Bytes, DWORD Length)
{
	DWORD64 Result = 0;
	DWORD64 BaseAddress = 0;
	MEMORY_BASIC_INFORMATION64 Mbi;
	NTSTATUS St;
	DWORD64 Index;

	for (;;)
	{
		St = x64Utils::x64NtQueryVirtualMemory(ProcessHandle, BaseAddress, MemoryBasicInformation, &Mbi, sizeof(Mbi));
		if (NT_SUCCESS(St))
		{
			if (Index = SearchBytesInReadedMemory(ProcessHandle, BaseAddress, Mbi.RegionSize, Bytes, Length))
			{
				Result = Mbi.AllocationBase + Index;
			}
		}
		else break;

		if (Result) break;

		BaseAddress = BaseAddress + Mbi.RegionSize;
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD x64Utils::EnumProcessModules64(HANDLE ProcessHandle, PPROC_MOD *Modules)
{
	DWORD Count = 0;
	NTSTATUS St;
	WOW64::PROCESS_BASIC_INFORMATION64 Pbi;

	*Modules = NULL;

	St = x64Utils::x64NtQueryInformationProcess(ProcessHandle, ProcessBasicInformation, &Pbi, sizeof(Pbi));
	if (NT_SUCCESS(St))
	{
		DWORD64 Ldr = (DWORD64)Pbi.PebBaseAddress + FIELD_OFFSET(WOW64::PEB64, Ldr);

		St = x64Utils::x64NtReadVirtualMemory(ProcessHandle, Ldr, (DWORD64)&Ldr, sizeof(DWORD64));
		if (NT_SUCCESS(St))
		{
			DWORD64 Head = Ldr + FIELD_OFFSET(WOW64::PEB_LDR_DATA64, InLoadOrderModuleList.Flink);

			do
			{
				St = x64Utils::x64NtReadVirtualMemory(ProcessHandle, Head, (DWORD64)&Head, sizeof(DWORD64));
				if (NT_SUCCESS(St))
				{
					WOW64::LDR_DATA_TABLE_ENTRY64 Entry = {0};

					St = x64Utils::x64NtReadVirtualMemory(ProcessHandle, Head, (DWORD64)&Entry, sizeof(Entry));
					if (NT_SUCCESS(St))
					{
						if (!*Modules) *Modules = (PPROC_MOD)malloc(sizeof(PROC_MOD)); else *Modules = (PPROC_MOD)realloc(*Modules, sizeof(PROC_MOD) * (Count+1));

						St = x64Utils::x64NtReadVirtualMemory(ProcessHandle, Entry.BaseDllName._Buffer, (DWORD64)&(*Modules)[Count].ModName, (DWORD64)Entry.BaseDllName.Length);
						if (NT_SUCCESS(St))
						{
							(*Modules)[Count].ModBase = Entry.DllBase;

							Count++;
						}
						else break;
					}
					else break;
				}
				else break;

				Head = Head + FIELD_OFFSET(WOW64::LDR_DATA_TABLE_ENTRY64, InLoadOrderLinks.Flink);
			}
			while (Head != (Ldr + FIELD_OFFSET(WOW64::PEB_LDR_DATA64, InLoadOrderModuleList)));
		}
	}

	return Count;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 x64Utils::SearchCodeInProcessModules(HANDLE ProcessHandle, PVOID Bytes, DWORD Length)
{
	DWORD64 Result = 0;
	PROC_MOD *Modules;

	DWORD Count = EnumProcessModules64(ProcessHandle, &Modules);
	if (Count)
	{
		PUCHAR ModuleHeader = (PUCHAR)malloc(0x400);
		if (ModuleHeader)
		{
			for (DWORD i = 0; i < Count; i++)
			{
				NTSTATUS St = x64Utils::x64NtReadVirtualMemory(ProcessHandle, Modules[i].ModBase, (DWORD64)ModuleHeader, 0x400);
				if (NT_SUCCESS(St))
				{
					PIMAGE_NT_HEADERS64 NtHeaders = (PIMAGE_NT_HEADERS64)PeLdr::PeImageNtHeader(ModuleHeader);
					if (NtHeaders)
					{
						PIMAGE_SECTION_HEADER SectionHeader = IMAGE_FIRST_SECTION(NtHeaders);

						for (WORD j = 0; j < NtHeaders->FileHeader.NumberOfSections; j++)
						{
							if (!lstrcmp((PCHAR)SectionHeader[j].Name, ".text") && FlagOn(SectionHeader[j].Characteristics, IMAGE_SCN_MEM_EXECUTE))
							{
								DWORD64 BaseAddress = Modules[i].ModBase + SectionHeader[j].VirtualAddress;
								DWORD64 Index = SearchBytesInReadedMemory(ProcessHandle, BaseAddress, (DWORD64)SectionHeader[j].Misc.VirtualSize, Bytes, Length);
								if (Index)
								{
									Result = BaseAddress + Index;

									//DbgMsg(__FUNCTION__"(): Addr - "IFMT64"\r\n", Result);
									//Result = 0;

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

		free(Modules);
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 x64Utils::GetRemoteProcAddress(HANDLE ProcessHandle, PWCHAR ModuleName, PCHAR ProcedureName)
{
	DWORD64 Result = 0;
	PPROC_MOD Modules;
	DWORD64 ModBase = 0;

	DWORD Count = EnumProcessModules64(ProcessHandle, &Modules);
	if (Count)
	{
		for (DWORD i = 0; i < Count; i++)
		{
			if (!lstrcmpiW(ModuleName, Modules[i].ModName))
			{
				ModBase = Modules[i].ModBase;
				break;
			}
		}

		free(Modules);
	}

	if (ModBase)
	{
		PUCHAR ModuleHeader = (PUCHAR)malloc(0x400);
		if (ModuleHeader)
		{
			NTSTATUS St = x64NtReadVirtualMemory(ProcessHandle, ModBase, (DWORD64)ModuleHeader, 0x400);
			if (NT_SUCCESS(St))
			{
				DWORD dwExportSize;
				PVOID VA = (PIMAGE_EXPORT_DIRECTORY)PeLdr::PeImageDirectoryEntryToData(ModuleHeader, TRUE, IMAGE_DIRECTORY_ENTRY_EXPORT, &dwExportSize, TRUE);
				if (VA)
				{
					PIMAGE_EXPORT_DIRECTORY pImageExport = (PIMAGE_EXPORT_DIRECTORY)VirtualAlloc(NULL, dwExportSize, MEM_COMMIT|MEM_RESERVE, PAGE_READWRITE);
					if (pImageExport)
					{
						St = x64NtReadVirtualMemory(ProcessHandle, ModBase + (DWORD64)VA, (DWORD64)pImageExport, dwExportSize);
						if (NT_SUCCESS(St))
						{
							DWORD NewBase = (DWORD)pImageExport - (DWORD)VA;
							PDWORD pAddrOfNames = MAKE_PTR(NewBase, pImageExport->AddressOfNames, PDWORD);
							for (DWORD i = 0; i < pImageExport->NumberOfNames; i++)
							{
								if (!lstrcmp(RtlOffsetToPointer(NewBase, pAddrOfNames[i]), ProcedureName))
								{
									PDWORD pAddrOfFunctions = MAKE_PTR(NewBase, pImageExport->AddressOfFunctions, PDWORD);
									PWORD pAddrOfOrdinals = MAKE_PTR(NewBase, pImageExport->AddressOfNameOrdinals, PWORD);

									Result = ModBase + (DWORD64)pAddrOfFunctions[pAddrOfOrdinals[i]];
									break;
								}
							}
						}

						VirtualFree(pImageExport, 0, MEM_RELEASE);
					}
				}
			}

			free(ModuleHeader);
		}
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
#endif
//----------------------------------------------------------------------------------------------------------------------------------------------------
