#include <windows.h>
#include <iostream>
#include <time.h>

#define TYPE_ENCRYPT_COMMAND 1
#define TYPE_ENCRYPT_IP 2
#define TYPE_QUIT 3

using namespace std;

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

char cCharacterPoolOne[99] = "~!@#$%^&*()_+`1234567890-=qwertyuiop[]\\QWERTYUIOP{}|asdfghjkl;\'ASDFGHJKL:\"zxcvbnm,./ZXCVBNM<> ?";
char cCharacterPoolTwo[99] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890,./<>?;:\'\"[]\\{}|=-+_)(*&^%$#@!~` ";
char *EncryptCommand(char *pcCommand)
{
    for(unsigned int ui = 0; ui <= strlen(pcCommand); ui++)
    {
        for(unsigned short us = 0; us <= strlen(cCharacterPoolOne); us++)
        {
            if(pcCommand[ui] == cCharacterPoolOne[us])
            {
                pcCommand[ui] = cCharacterPoolTwo[us];
                break;
            }
        }
    }

    return pcCommand;
}

bool IsValidCommandString(char *pcCommand)
{
    bool bReturn = true;

    for(unsigned int ui = 0; ui < strlen(pcCommand); ui++)
    {
        for(unsigned short us = 0; us < strlen(cCharacterPoolOne); us++)
        {
            if(pcCommand[ui] == cCharacterPoolOne[us])
                break;

            if(us == strlen(cCharacterPoolOne) - 1)
            {
                bReturn = false;
                break;
            }
        }

        if(!bReturn)
            break;
    }

    return bReturn;
}

char cIpReturn[20];
char *EncryptIp(char *pcIp, unsigned short usChecksum)
{
    memset(cIpReturn, 0, sizeof(cIpReturn));
    unsigned short usAppliedValue = usChecksum * 5;

    char *pcBreakString = strtok(pcIp, ".");
    while(pcBreakString != NULL)
    {
        unsigned short usIpSegment = atoi(pcBreakString);
        if(usIpSegment > 122)
            usIpSegment -= usAppliedValue;
        else
            usIpSegment += usAppliedValue;

        char cIpSegment[5];
        itoa(usIpSegment, cIpSegment, 10);

        if(cIpReturn[0] == '\0')
            strcpy(cIpReturn, cIpSegment);
        else
        {
            strcat(cIpReturn, ".");
            strcat(cIpReturn, cIpSegment);
        }

        pcBreakString = strtok(NULL, ".");
    }

    return (char*)cIpReturn;
}

unsigned long GetRandNum(unsigned long range)
{
    srand(time(0));
    return rand() % range;
}

void OutputInvalidInput()
{
    cout << "ERROR: Invalid Input!" << endl << endl;
}

unsigned short TypeQuery()
{
    unsigned short usInput = 0;

    cout << "Enter Command Number:\t\t";
    cin >> usInput;

    if(usInput != 1 && usInput != 2 && usInput != 3)
        OutputInvalidInput();

    return usInput;
}

int main()
{
    cout << "Athena Tool" << endl << "-----------" << endl << endl;
    cout << "Type 1 for IRC Command Encryption" << endl;
    cout << "Type 2 for IP Encryption" << endl;
    cout << "Type 3 to exit this client" << endl << endl;

    unsigned short usType;

    while(true)
    {
        usType = TypeQuery();

        if(usType == TYPE_ENCRYPT_COMMAND)
        {
            char cProcessCommand[510];
            strcpy(cProcessCommand, "@*@");

            cout << "Enter AthenaIRC Command:\t";

            char cCommand[510];
            cin.ignore();
            cin.getline(cCommand, sizeof(cCommand));

            strcat(cProcessCommand, cCommand);

            if(cProcessCommand[3] != '!')
            {
                cout << "Missing exclamation point(!) prefix..." << endl;
                OutputInvalidInput();
            }
            else
            {
                if(!IsValidCommandString((char*)cProcessCommand))
                    OutputInvalidInput();
                else
                {
                    unsigned short usChecksum = GetRandNum(500);
                    for(unsigned short us = 0; us < usChecksum; us++)
                        strcpy(cProcessCommand, EncryptCommand(cProcessCommand));

                    cout << "Encrypted Command:\t\t" << cProcessCommand << endl ;

                    char cFullCommand[510];
                    strcpy(cFullCommand, "!decrypt ");
                    strcat(cFullCommand, cProcessCommand);

                    if(CopyToClipboard(cFullCommand))
                        cout << "Full command copied to clipboard." << endl;
                    else
                        cout << "Failed to copy command to clipboard." << endl;

                    cout << endl;
                }

            }
        }
        else if(usType == TYPE_ENCRYPT_IP)
        {
            cout << "Enter the unencrypted IP:\t";

            char cIp[16];
            cin >> cIp;

            if(strlen(cIp) > 15 || strlen(cIp) < 7)
                OutputInvalidInput();
            else
            {
                char *pcEncryptedIp = EncryptIp((char*)cIp, 24); //Max value of 24!
                cout << "Encrypted IP:\t\t\t" << pcEncryptedIp << endl;

                if(CopyToClipboard(pcEncryptedIp))
                    cout << "IP copied to clipboard." << endl;
                else
                    cout << "Failed to copy IP to clipboard." << endl;

                cout << endl;
            }
        }
        else if(usType == TYPE_QUIT)
            return 0;
        else
            Sleep(10);
    }
}
