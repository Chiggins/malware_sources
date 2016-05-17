#include "../Includes/includes.h"

#ifdef USE_ENCRYPTED_IP
char cIpReturn[20];
char *DecryptIp(char *pcIp, unsigned short usChecksum)
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
#endif
