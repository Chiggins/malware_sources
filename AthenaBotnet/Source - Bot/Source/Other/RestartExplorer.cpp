#include "../Includes/includes.h"

DWORD WINAPI RestartExplorer(LPVOID)
{
    char cShellFile[MAX_PATH];
    memset(cShellFile, 0, sizeof(cShellFile));
    strcpy(cShellFile, "explorer.exe");

    char cShellFilePath[MAX_PATH];
    strcpy(cShellFilePath, cWindowsDirectory);
    strcat(cShellFilePath, "\\");
    strcat(cShellFilePath, cShellFile);

    //Sleep(10000);

    DWORD dwPid = GetPidFromFilename(cShellFile);
    if(dwPid > 0)
        if(KillProcessByPid(dwPid, FALSE))
            StartProcessFromPath(cShellFilePath, TRUE);
        else
            StartProcessFromPath(cShellFilePath, TRUE);

    return 1;
}

bool CreateRestartExplorer()
{
    bool bReturn = FALSE;

    HANDLE hThread = CreateThread(NULL, NULL, RestartExplorer, NULL, NULL, NULL);
    if(hThread)
        bReturn = TRUE;

    CloseHandle(hThread);

    return bReturn;
}
