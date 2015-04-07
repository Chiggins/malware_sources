#include <stdio.h>
#include <windows.h>
#include <shlwapi.h>

#include "utils.h"
#include "cfgini.h"

#define CFGI_MAX_NAME		24
#define CFGI_MAX_SECTIONS	8
#define CFGI_MAX_VARIABLES	12

typedef struct _CFGI_VAR
{
	CHAR chVariable[CFGI_MAX_NAME];
	PCHAR pcValue;
	DWORD dwValue;
}
CFGI_VAR, *PCFGI_VAR;

typedef struct _CFGI_SEC
{
	CHAR chSection[CFGI_MAX_NAME];
	DWORD_PTR dwVariables;
	CFGI_VAR pvVariables[CFGI_MAX_VARIABLES];
}
CFGI_SEC, *PCFGI_SEC;

typedef struct _CFGI_INI
{
	DWORD_PTR dwSections;
	CFGI_SEC psSections[CFGI_MAX_SECTIONS];
}
CFGI_INI, *PCFGI_INI;

BOOLEAN CfgsCheckSection(PCFGI_INI pCfgiIni, PCHAR pcPointer, DWORD dwPointer)
{
	DWORD dwLen;
	PCFGI_SEC pCfgSec;

	if (*pcPointer == '[')
	{
		if (pcPointer[dwPointer - 1] == ']')
		{
			dwLen = dwPointer - 2;
			if (dwLen > 0 && dwLen < CFGI_MAX_NAME)
			{
				pCfgSec = &pCfgiIni->psSections[pCfgiIni->dwSections];

				UtiStrNCpy(pCfgSec->chSection, pcPointer + 1, dwLen);
				pCfgiIni->dwSections++;

				return TRUE;
			}
		}
	}

	return FALSE;
}

BOOLEAN CfgsCheckVariable(PCFGI_INI pCfgiIni, PCHAR pcPointer, DWORD dwPointer)
{
	PCHAR pcVariable = pcPointer;
	DWORD dwLen;
	PCFGI_SEC pCfgSec;
	PCFGI_VAR pCfgVar;

	pcPointer = strchr(pcPointer, '=');
	if (pcPointer)
	{
		dwLen = (DWORD)(pcPointer - pcVariable);
		if (dwLen > 0 && dwLen < CFGI_MAX_NAME)
		{
			pCfgSec = &pCfgiIni->psSections[pCfgiIni->dwSections - 1];

			if (pCfgSec->dwVariables < CFGI_MAX_VARIABLES)
			{
				pCfgVar = &pCfgSec->pvVariables[pCfgSec->dwVariables];

				UtiStrNCpy(pCfgVar->chVariable, pcVariable, dwLen);

				dwLen = dwPointer - dwLen - 1;
				if (dwLen > 0)
				{
					pCfgVar->pcValue = UtiStrNCpyM(pcPointer + 1, dwLen);
					if (pCfgVar->pcValue)
					{
						pCfgVar->dwValue = dwLen;
						pCfgSec->dwVariables++;

						return TRUE;
					}
				}
			}
		}
	}

	return FALSE;
}

PCFGI_INI CfgsIniFromMem(PCHAR pcBuffer)
{
	PCFGI_INI pCfgiIni = NULL;
	PCHAR pcPointer;
	DWORD dwPointer;
	BOOLEAN bBreak = FALSE;

	pCfgiIni = (PCFGI_INI)malloc(sizeof(CFGI_INI));
	if (pCfgiIni)
	{
		while (Utils::StringTokenBreak(&pcBuffer, "\r\n", &pcPointer))
		{
			dwPointer = (DWORD)strlen(pcPointer);
			if (!CfgsCheckSection(pCfgiIni, pcPointer, dwPointer))
			{
				if (pCfgiIni->dwSections)
				{
					if (!CfgsCheckVariable(pCfgiIni, pcPointer, dwPointer)) bBreak = TRUE;
				}
			}
			else
			{
				if (pCfgiIni->dwSections >= CFGI_MAX_SECTIONS) bBreak = TRUE;
			}

			free(pcPointer);
			if (bBreak) break;
		}
	}

	return pCfgiIni;
}

PVOID CfgsIniToMem(PCFGI_INI pCfgiIni, PDWORD pdwBuffer)
{
	PVOID pvResult = NULL;
	PCFGI_SEC pCfgSec;
	PCFGI_VAR pCfgVar;
	DWORD dwSize = 0;
	DWORD_PTR dwLen;

	for (DWORD dwSec = 0; dwSec < pCfgiIni->dwSections; dwSec++)
	{
		pCfgSec = &pCfgiIni->psSections[dwSec];

		dwLen = CFGI_MAX_NAME + 10;
		if (!pvResult) pvResult = malloc(dwLen); else pvResult = realloc(pvResult, dwSize + dwLen);
		if (pvResult)
		{
			dwSize += _snprintf(RtlOffsetToPointer(pvResult, dwSize), dwLen-1, "[%s]\r\n", pCfgSec->chSection);

			for (DWORD dwVar = 0; dwVar < pCfgSec->dwVariables; dwVar++)
			{
				pCfgVar = &pCfgSec->pvVariables[dwVar];

				dwLen = pCfgVar->dwValue + CFGI_MAX_NAME + 10;
				pvResult = realloc(pvResult, dwSize + dwLen);
				if (pvResult)
				{
					dwSize += _snprintf(RtlOffsetToPointer(pvResult, dwSize), dwLen-1, "%s=%.*s\r\n", pCfgVar->chVariable, pCfgVar->dwValue, pCfgVar->pcValue);
				}
			}
		}
	}

	if (pvResult) *pdwBuffer = dwSize;
	return pvResult;
}

PCFGI_SEC CfgsFindSection(PCFGI_INI pCfgiIni, PCHAR pcSection)
{
	PCFGI_SEC pCfgSec = NULL;

	for (DWORD_PTR i = 0; i < pCfgiIni->dwSections; i++)
	{
		if (!_stricmp(pCfgiIni->psSections[i].chSection, pcSection))
		{
			pCfgSec = &pCfgiIni->psSections[i];

			break;
		}
	}

	return pCfgSec;
}

PCFGI_VAR CfgsFindVariable(PCFGI_SEC pCfgSec, PCHAR pcVariable)
{
	PCFGI_VAR pCfgVar = NULL;

	for (DWORD i = 0; i < pCfgSec->dwVariables; i++)
	{
		if (!_stricmp(pCfgSec->pvVariables[i].chVariable, pcVariable))
		{
			pCfgVar = &pCfgSec->pvVariables[i];

			break;
		}
	}

	return pCfgVar;
}

PVOID CfgsWriteString(PVOID pvBuffer, PDWORD pdwBuffer, PCHAR pcSection, PCHAR pcVariable, PCHAR pcValue)
{
	PVOID pvResult = NULL;
	PCFGI_INI pCfgiIni;
	PCFGI_SEC pCfgSec;
	PCFGI_VAR pCfgVar;
	DWORD dwLen;

	pCfgiIni = CfgsIniFromMem((PCHAR)pvBuffer);
	if (pCfgiIni)
	{
		pCfgSec = CfgsFindSection(pCfgiIni, pcSection);
		if (!pCfgSec)
		{
			dwLen = (DWORD)strlen(pcSection);
			if (dwLen < CFGI_MAX_NAME)
			{	
				pCfgSec = &pCfgiIni->psSections[pCfgiIni->dwSections];

				UtiStrNCpy(pCfgSec->chSection, pcSection, dwLen);
				pCfgiIni->dwSections++;
			}
		}

		pCfgVar = CfgsFindVariable(pCfgSec, pcVariable);
		if (!pCfgVar)
		{
			dwLen = (DWORD)strlen(pcVariable);
			if (dwLen < CFGI_MAX_NAME)
			{
				pCfgVar = &pCfgSec->pvVariables[pCfgSec->dwVariables];

				UtiStrNCpy(pCfgVar->chVariable, pcVariable, dwLen);
				pCfgSec->dwVariables++;
			}
		}

		if (pCfgVar)
		{
			if (pCfgVar->pcValue) free(pCfgVar->pcValue);

			dwLen = (DWORD)strlen(pcValue);
			if (pCfgVar->pcValue = UtiStrNCpyM(pcValue, dwLen))
			{
				pCfgVar->dwValue = dwLen;

				pvResult = CfgsIniToMem(pCfgiIni, pdwBuffer);
			}
		}

		free(pCfgiIni);
	}

	return pvResult;
}

DWORD CfgsReadString(PVOID pvBuffer, DWORD dwBuffer, PCHAR pcSection, PCHAR pcVariable, PCHAR *ppcValue)
{
	DWORD dwResult = 0;
	PCFGI_INI pCfgiIni;
	PCFGI_SEC pCfgSec;
	PCFGI_VAR pCfgVar;

	pCfgiIni = CfgsIniFromMem((PCHAR)pvBuffer);
	if (pCfgiIni)
	{
		pCfgSec = CfgsFindSection(pCfgiIni, pcSection);
		if (pCfgSec)
		{
			pCfgVar = CfgsFindVariable(pCfgSec, pcVariable);
			if (pCfgVar)
			{
				if (pCfgVar->dwValue)
				{
					*ppcValue = UtiStrNCpyM(pCfgVar->pcValue, pCfgVar->dwValue);
					if (*ppcValue)
					{
						dwResult = pCfgVar->dwValue;
					}
				}
			}
		}

		free(pCfgiIni);
	}

	return dwResult;
}

BOOLEAN CfgfWriteString(PCHAR pcFile, PCHAR pcSection, PCHAR pcVariable, PCHAR pcValue, PCHAR Key)
{
	BOOLEAN bRet = FALSE;
	HANDLE hFile;
	PVOID pvBuffer;
	DWORD dwBuffer;
	PVOID pvNewBuffer;

	hFile = Utils::FileLock(pcFile, SYNCHRONIZE|DELETE|GENERIC_READ|GENERIC_WRITE, OPEN_ALWAYS);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		pvBuffer = Utils::FileHandleRead(hFile, &dwBuffer);
		if (pvBuffer)
		{
			if (dwBuffer) Utils::UtiCryptRc4(Key, lstrlen(Key), pvBuffer, pvBuffer, dwBuffer);

			pvNewBuffer = CfgsWriteString(pvBuffer, &dwBuffer, pcSection, pcVariable, pcValue);
			if (pvNewBuffer)
			{
				if (dwBuffer) Utils::UtiCryptRc4(Key, lstrlen(Key), pvNewBuffer, pvNewBuffer, dwBuffer);

				bRet = Utils::FileHandleWrite(hFile, pvNewBuffer, dwBuffer, FILE_BEGIN);
			}

			free(pvBuffer);
		}

		Utils::FileUnlock(hFile);
	}

	return bRet;
}

DWORD CfgfReadStringM(PCHAR pcFile, PCHAR pcSection, PCHAR pcVariable, PCHAR *ppcValue, PCHAR Key)
{
	DWORD dwResult = 0;
	HANDLE hFile;
	PVOID pvBuffer;
	DWORD dwBuffer;

	hFile = Utils::FileLock(pcFile, SYNCHRONIZE|GENERIC_READ, OPEN_EXISTING);
	if (hFile != INVALID_HANDLE_VALUE)
	{
		pvBuffer = Utils::FileHandleRead(hFile, &dwBuffer);
		if (pvBuffer)
		{
			if (dwBuffer) Utils::UtiCryptRc4(Key, lstrlen(Key), pvBuffer, pvBuffer, dwBuffer);

			dwResult = CfgsReadString(pvBuffer, dwBuffer, pcSection, pcVariable, ppcValue);

			free(pvBuffer);
		}

		Utils::FileUnlock(hFile);
	}

	return dwResult;
}

DWORD CfgfReadString(PCHAR pcFile, PCHAR pcSection, PCHAR pcVariable, PCHAR lpDefault, PCHAR pcValue, DWORD dwValue, PCHAR Key)
{
	PCHAR lpReaded;
	DWORD dwReaded = 0;

	dwReaded = CfgfReadStringM(pcFile, pcSection, pcVariable, &lpReaded, Key);
	if (dwReaded > 0 && dwReaded <= dwValue)
	{
		UtiStrNCpy(pcValue, lpReaded, dwReaded);

		free(lpReaded);
	}
	else
	{
		if (lpDefault)
		{
			dwReaded = lstrlen(lpDefault);
			UtiStrNCpy(pcValue, lpDefault, dwReaded);
		}
	}

	return dwReaded;
}
