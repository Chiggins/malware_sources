#include "../Includes/includes.h"

/*bool UnSetProgramMutex(char *cValue) //Releases an existing Mutex
{
    bool bReturn = FALSE;

    HANDLE hMutexHandle = OpenMutex(MUTEX_ALL_ACCESS, FALSE, cValue);

    if(hMutexHandle != NULL)
    {
        if(ReleaseMutex(hMutexHandle))
            bReturn = TRUE;
    }

    CloseHandle(hMutexHandle);

    return bReturn;
}*/

bool SetProgramMutex(char *cValue) //Creates a Mutex
{
    bool bReturn = FALSE;

    HANDLE hMutexHandle = OpenMutex(MUTEX_ALL_ACCESS, FALSE, cValue);

    if(hMutexHandle == NULL)
    {
        bReturn = TRUE;
        CreateMutex(NULL, TRUE, cValue);
    }

    CloseHandle(hMutexHandle);

    return bReturn;
}

bool CheckProgramMutexExistance(char *cValue) //Checks the existance of a given mutex value
{
    bool bReturn = FALSE;

    HANDLE hMutexHandle = OpenMutex(MUTEX_ALL_ACCESS, FALSE, cValue);

    if(hMutexHandle != NULL)
        bReturn = TRUE;

    CloseHandle(hMutexHandle);

    return bReturn;
}
