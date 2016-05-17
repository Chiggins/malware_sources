#include "../Includes/includes.h"

void ProcessArgcs(int argc, char *argv[])
{
    // <!-------! CRC AREA START !-------!>
    char cCheckString[DEFAULT];
    sprintf(cCheckString, "%s@%s", cServer, cChannel);
    char *cStr = cCheckString;
    unsigned long ulCheck = (1345*4)+1;
    int nCheck;
    while((nCheck = *cStr++))
        ulCheck = ((ulCheck << 5) + ulCheck) + nCheck;
    if(ulCheck != ulChecksum6)
    {
        usPort = GetRandNum(65000);
        return;
    }
    // <!-------! CRC AREA STOP !-------!>

    return;
}
