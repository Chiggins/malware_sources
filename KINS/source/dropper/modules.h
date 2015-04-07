#ifndef _MODULES_H_
#define _MODULES_H_

typedef void (*MOD_PRE_PROCESS)(PVOID, LPSTR, LPSTR);

namespace Modules
{
	typedef DWORD (__cdecl *IMAGE_LOAD_NOTIFY_ROUTINE)(void* image_base, LPSTR module_name, LPSTR params);
	typedef DWORD (__cdecl *IMAGE_UNLOAD_NOTIFY_ROUTINE)(void* image_base, LPSTR module_name);

	typedef struct _DCT_MODULE
	{
		CHAR ModuleName[50];
		CHAR ModulePath[MAX_PATH];
		PVOID ModuleHandle;
		DWORD Version;
		IMAGE_LOAD_NOTIFY_ROUTINE load_notify_routine;
		IMAGE_UNLOAD_NOTIFY_ROUTINE unload_notify_routine;
	}DCT_MODULE, *PDCT_MODULE;

	typedef struct
	{
		BOOLEAN Waiting;
		CHAR WhenLoadsThis[50];
		CHAR LoadMe[50];
	}DCT_DELAYEDLOAD, *PDCT_DELAYEDLOAD;

	enum
	{
		MODULE_NOT_PERSISTENT,
		MODULE_IS_PERSISTENT,
		MODULE_NOT_FOUND,
		MODULE_INVALID_ARGUMENTS,
	};

#define DCT_MAX_MODULES	12
#define CAN_RUN(a) (a != 0)
	extern DCT_MODULE DctModules[DCT_MAX_MODULES];
	extern DCT_DELAYEDLOAD DctDelayedLoadModules[DCT_MAX_MODULES];

	PDCT_MODULE GetModuleByName(PCHAR ModuleName);
	PDCT_MODULE GetModuleByHandle(PVOID Handle);

	BOOLEAN WriteModuleAndLoad(PVOID Buffer, DWORD Size, PCHAR ModuleName, DWORD ModuleVersion, PCHAR Inject, PCHAR ConnectedWithModuleName, DWORD RunMode, PCHAR Args);
	PVOID ModuleLoad(PCHAR ModuleName);
	BOOLEAN ModuleUnload(PCHAR ModuleName);
	VOID LoadModulesToProcess(PCHAR Process);
	BOOLEAN InjectorAdd(PCHAR InjectOrProcess, PCHAR ModuleName);
	VOID LoadInjectModules(PCHAR Process);
	BOOLEAN RegisterDelayedModuleLoad(PCHAR WhenLoadsThis, PCHAR LoadMe);
	void ModuleLoadNotify(PCHAR WhosLoaded, PVOID module_base);
	void ModulePreprocess(PVOID pe_image_base, LPSTR module_name, LPSTR params);
};

#endif
