#include <windows.h>

#include "defines.h"
#include "activation.h"
#include "main.h"

#include "..\common\str.h"
#include "..\common\mem.h"
#include "..\common\config.h"

#if BO_DEBUG <= 0
bool Activation::activate()
{

	WCHAR activationKey[50];
	char* serial = (char*)Mem::alloc(5000);
	LPSTR activationKeyA;
	if(GetPrivateProfileStringW(VMProtectDecryptStringW(L"settings"), VMProtectDecryptStringW(L"activation"), L"", activationKey, 50, settingsFile) == NULL) return false;
	activationKeyA = Str::_unicodeToAnsiEx(activationKey, -1);
	DWORD result = 0;

	if((result = VMProtectActivateLicense(activationKeyA, serial, 5000)) != 0)
	{
		LPWSTR errorCode;
		Str::_sprintfExW(&errorCode, VMProtectDecryptStringW(L"Error number: %u"), result);
		MessageBoxW(0, errorCode, VMProtectDecryptStringW(L"Error"), MB_OK | MB_ICONERROR);
		return false;
	}
	if((result = VMProtectSetSerialNumber(serial)) != 0)
	{
		if(result == SERIAL_STATE_FLAG_BLACKLISTED)
		{
			MessageBoxW(0, VMProtectDecryptStringW(L"Congratulations! You have been blacklisted."), VMProtectDecryptStringW(L"Hey!"), MB_OK | MB_ICONERROR);
		}
		else
			MessageBoxW(0, VMProtectDecryptStringW(L"Failed to start."), VMProtectDecryptStringW(L"Fail"), MB_OK | MB_ICONERROR);
		return false;
	}

	return true;

}
#endif