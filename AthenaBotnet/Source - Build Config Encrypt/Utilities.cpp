#include "includes.h"

char cPoolOfCharacters[77] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789# _.-~`'+@&|()";
char cMixedPoolOfCharacters[77] = "() &@+'|ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789#_.-~`";

char *EncryptConfig(char *cConfig)
{
    unsigned short usConfigLen = strlen(cConfig);
    for(unsigned short us = 0; us <= usConfigLen; us++)
    {
        for(unsigned short usP = 0; usP <= strlen(cPoolOfCharacters); usP++)
        {
            if(cConfig[us] == cPoolOfCharacters[usP])
            {
                cConfig[us] = cMixedPoolOfCharacters[usP];
                break;
            }
        }
    }
    return cConfig;
}

char *DecryptConfig(char *cConfig)
{
    unsigned short usConfigLen = strlen(cConfig);
    for(unsigned short us = 0; us <= usConfigLen; us++)
    {
        for(unsigned short usP = 0; usP <= strlen(cPoolOfCharacters); usP++)
        {
            if(cConfig[us] == cMixedPoolOfCharacters[usP])
            {
                cConfig[us] = cPoolOfCharacters[usP];
                break;
            }
        }
    }
    return cConfig;
}

unsigned long GetHash(unsigned char *str)
{
    unsigned long hash = 5381;
    int c;

    while((c = *str++))
        hash = ((hash << 5) + hash) + c;

    return hash;
}

char *SimpleDynamicXor(char *pcString, DWORD dwKey)
{
    for(unsigned short us = 0; us < strlen(pcString); us++)
        pcString[us] = (pcString[us] ^ dwKey);

    return pcString;
}

/*DWORD StartProcessFromPath(char *cPath, bool bHidden)
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

bool KillProcess(DWORD dwPID)
{
    if(GetCurrentProcessId() == dwPID)
        return FALSE;

    HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, FALSE, dwPID);
    if(!hProcess)
        return FALSE;

    if(TerminateProcess(hProcess, NULL))
    {
        CloseHandle(hProcess);
        return TRUE;
    }

    CloseHandle(hProcess);
    return FALSE;
}*/

unsigned long GetRandNum(unsigned long range) //Returns a random number within a given range
{
    return rand() % range;
}

char *GenRandLCText() //Generates random lowercase text
{
    //char cLCAlphabet[27];
    //strcpy(cLCAlphabet, "abcdefghijklmnopqrstuvwxyz");

    static char cRandomText[11];

    unsigned short usLength = GetRandNum(8) + 2;
    for(unsigned short us = 0; us < usLength; us++)
        cRandomText[us] = (char)(GetRandNum(26) + 65 + 32);

    //for(unsigned short us = 0; us < 8; us++)
    //cRandomText[us] = cLCAlphabet[GetRandNum(strlen(cLCAlphabet))];
//printf("InLC:%s\n", cRandomText);system("pause");
    return (char*)cRandomText;
}

bool CopyToClipboard(const char *cData)
{
    bool bReturn = false;

    const size_t len = strlen(cData) + 1;

    HGLOBAL hMem = GlobalAlloc(GMEM_MOVEABLE, len);
    if(hMem == NULL)
        return bReturn;

    memcpy(GlobalLock(hMem), cData, len);
    GlobalUnlock(hMem);

    if(!OpenClipboard(NULL))
        return bReturn;

    EmptyClipboard();
    SetClipboardData(CF_TEXT, hMem);
    CloseClipboard();

    bReturn = TRUE;

    return bReturn;
}

void SwapBase64ToNonBase64(char *cSource)
{
    for(int i = 0; i < strlen(cSource); i++)
    {
        if(cSource[i] == '/')
            cSource[i] = '`';
        else if(cSource[i] == '=')
            cSource[i] = '~';
        else if(cSource[i] == '+')
            cSource[i] = '-';
    }
}

void SwapNonBase64ToBase64(char *cSource)
{
    for(int i = 0; i < strlen(cSource); i++)
    {
        if(cSource[i] == '`')
            cSource[i] = '/';
        else if(cSource[i] == '~')
            cSource[i] = '=';
        else if(cSource[i] == '-')
            cSource[i] = '+';
    }
}
