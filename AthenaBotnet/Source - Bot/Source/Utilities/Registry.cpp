#include "../Includes/includes.h"

bool CheckIfRegistryKeyExists(HKEY hKeyClass, char *cSubKey, char *cKeyName)
{
    HKEY hKey = NULL;
    bool bReturn = FALSE;

    if(RegOpenKeyExA(hKeyClass, cSubKey, 0, KEY_QUERY_VALUE, &hKey) == ERROR_SUCCESS)
    {
        if(RegQueryValueExA(hKey, cKeyName, NULL, NULL, NULL, NULL) == ERROR_SUCCESS)
            bReturn = TRUE;

        RegCloseKey(hKey);
    }

    return bReturn;
}

bool DeleteRegistryKey(HKEY hKeyClass, char *cSubKey, char *cKeyName)
{
    HKEY hKey = NULL;
    bool bReturn = FALSE;

    if(RegOpenKeyExA(hKeyClass, cSubKey, 0, KEY_SET_VALUE, &hKey) == ERROR_SUCCESS)
    {
        if(RegDeleteValueA(hKey, cKeyName) == ERROR_SUCCESS)
            bReturn = TRUE;

        RegFlushKey(hKey);
        RegCloseKey(hKey);
    }

    return bReturn;
}

bool CreateRegistryKey(HKEY hKeyClass, char *cSubKey, char *cKeyName, char *cKeyValue)
{
    bool bReturn = FALSE;

    char cValue[DEFAULT];
    sprintf(cValue, "\"%s\"", cKeyValue);

    HKEY hKey = NULL;
    DWORD dwSizeOfValue = strlen(cValue);

    if(RegCreateKeyExA(hKeyClass, cSubKey, 0, NULL, REG_OPTION_NON_VOLATILE, KEY_QUERY_VALUE | KEY_READ | KEY_WRITE, NULL, &hKey, NULL) == ERROR_SUCCESS)
    {
        if(RegSetValueExA(hKey, cKeyName, 0, REG_SZ, (BYTE*)cValue, dwSizeOfValue) == ERROR_SUCCESS)
            bReturn = TRUE;

        RegFlushKey(hKey);
        RegCloseKey(hKey);
    }

    return bReturn;
}

char *ReadRegistryKey(HKEY hKeyClass, char *cSubKey, char *cKeyName)
{
	HKEY hKey;
	DWORD lpType = REG_SZ;
	DWORD lpcbData = MAX_PATH;

	static char cReadKeyBuffer[DEFAULT];

	if(RegOpenKeyEx(hKeyClass, cSubKey, 0, KEY_READ, &hKey) == ERROR_SUCCESS)
	{
	    DWORD dwQueryReturn = 0;

		dwQueryReturn = RegQueryValueEx(hKey, cKeyName, 0, &lpType, (unsigned char*)cReadKeyBuffer, &lpcbData);

        if(dwQueryReturn == ERROR_FILE_NOT_FOUND)
		    strcpy(cReadKeyBuffer, "EFNF");
        else if(dwQueryReturn != ERROR_SUCCESS)
            strcpy(cReadKeyBuffer, "NOERRSUC");

		RegCloseKey(hKey);

		return (char*)cReadKeyBuffer;
	}
	else
        return (char*)"ERROPFA";
}
