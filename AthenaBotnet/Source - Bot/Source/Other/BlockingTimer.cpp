#include "../Includes/includes.h"

unsigned int BlockingTimer(unsigned int uiSeconds) //A timer that is blocking, will wait a specified amount of seconds to unblock
{
    for(unsigned int ui = 0; ui < uiSeconds; ui++)
        Sleep(1000);

    return uiSeconds;
}
