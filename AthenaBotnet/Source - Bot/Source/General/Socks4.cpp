#include "../Includes/includes.h"

#ifdef INCLUDE_SOCKS4
void transmit(SOCKET lSock, SOCKET rSock)
{
    char cBuff[1024];

    fd_set fd;

    int iRecvLen;

    while(true)
    {
        FD_ZERO(&fd);
        memset(cBuff, 0, sizeof(cBuff));

        FD_SET(rSock, &fd);
        FD_SET(lSock, &fd);

        select(0, &fd, 0, 0, 0);

        if(FD_ISSET(lSock,&fd))
        {
            iRecvLen = recv(lSock, cBuff, sizeof(cBuff), 0);
            if (iRecvLen < 1)
                break;
            if (send(rSock, cBuff, iRecvLen, 0) < 1)
                break;
        }

        if(FD_ISSET(rSock, &fd))
        {
            iRecvLen = recv(rSock, cBuff, sizeof(cBuff), 0);
            if(iRecvLen < 1)
                break;
            if(send(lSock, cBuff, iRecvLen, 0) < 1)
                break;
        }
    }
    closesocket(lSock);
    closesocket(rSock);
    return;
}

void Socks4Bind(SOCKET lSock, LPSOCKS4 packet)
{
    sockaddr_in local;
    SOCKET rSock = socket(2, 1, 6);

    local.sin_addr.S_un.S_addr = INADDR_ANY;
    local.sin_family = 2;
    local.sin_port = 0;

    bind(rSock, (sockaddr *)&local, sizeof(local));

    int iSize = sizeof(local);
    getsockname(rSock, (sockaddr *)&local, &iSize);

    packet->cmd = 90;
    packet->ulAddr = local.sin_addr.S_un.S_addr;
    packet->usPort = local.sin_port;

    send(lSock, (char *)packet, 8, 0);

    listen(rSock, 1);

    SOCKET cSock = accept(rSock, 0, 0);
    transmit(cSock, lSock);
    return;
}

void Socks4Connect(SOCKET lSock, LPSOCKS4 packet)
{
    SOCKET rSock = socket(2, 1, 6);
    sockaddr_in remote;

    remote.sin_addr.S_un.S_addr = packet->ulAddr;
    remote.sin_family = AF_INET;
    remote.sin_port = packet->usPort;

    packet->version = 0;
    packet->cmd = 91;
    if(connect(rSock, (sockaddr *)&remote, sizeof(remote)))
    {
        send(lSock, (char *)packet, 8, 0);
        closesocket(lSock);
        closesocket(rSock);
        return;
    }

    int iSize = sizeof(remote);
    getsockname(rSock, (sockaddr *)&remote, &iSize);
    packet->ulAddr = remote.sin_addr.S_un.S_addr;
    packet->usPort = remote.sin_port;

    packet->cmd = 90;
    send(lSock, (char *)packet, 8, 0);

    transmit(lSock, rSock);
    return;
}

DWORD WINAPI fSocksClientThread(PVOID pInfo)
{
    SOCKET lSock = (SOCKET)pInfo;

    SOCKS4 packet;

    memset(&packet, 0, sizeof(packet));
    if(recv(lSock, (char *)(&packet), sizeof(packet), 0) < 1)
        return 0;

    char cID[256];

    int i = 0;
    char c;
    do
    {
        recv(lSock, &c, sizeof(c), 0);
        cID[i++] = c;
    }
    while (c != '\0');

    if((packet.version != 4))
    {
        packet.version = 0;
        packet.cmd = 91;
        send(lSock,(char *)&packet,8,0);
        return closesocket(lSock);
    }

    if(packet.cmd == 1)
    {
        Socks4Connect(lSock,&packet);
    }
    else if(packet.cmd == 2)
    {
        Socks4Bind(lSock,&packet);
    }

    return 0;
}

DWORD WINAPI fServerThread(PVOID pParams)
{
    SOCKS4 socks;
    memcpy(&socks,pParams,sizeof(socks));

    SOCKET ssock;
    ssock = socket(2, 1, 6);

    socks.remote->sin_addr.S_un.S_addr = INADDR_ANY;
    socks.remote->sin_family = 2;
    socks.remote->sin_port = htons(socks.uPort);

    if(bind(ssock,(sockaddr *)socks.ulAddr,sizeof(sockaddr_in)))
        return 0;
    if(listen(ssock,10))
        return 0;

    int iSize = sizeof(sockaddr_in);
    getsockname(ssock, (sockaddr *)socks.ulAddr, &iSize);

    DWORD dwThreadID;

    SOCKET cssock;
    while(true)
    {
        cssock = accept(ssock, 0, 0);

        if(cssock == INVALID_SOCKET)
            break;

        CreateThread(0, 0, fSocksClientThread, (void *)cssock, 0, &dwThreadID);
    }

    return closesocket(ssock);
}
#endif
