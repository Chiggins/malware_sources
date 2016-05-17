#include "includes.h"
#include "externs.h"


//If multiple parts of the bot needs it then stick it here..
//Nick and Thread stuff currently in here -null

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

char *GenerateNickA(void)
{
	static char nick[MAX_NICKLEN];
	ZeroMemory(nick,MAX_NICKLEN);
	char locale[MAX_NICKLEN];
	GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));
		if(IsNew()) {
			strcat(nick,"{NEW}");
		}
		strcat(nick, "[");
		strcat(nick, locale);
		strcat(nick, "]");
		strcat(nick, "[");
		//strcat(nick, GenerateOS());
		strcat(nick, "]");
	int i=1;
	char strbuf[2];
	for (i;i<REQ_NICKLEN;i++)
	{
		sprintf(strbuf,"%i",rand()%10);
		strcat(nick,strbuf);
	}
	return nick;
}

/*
Detect operating system
*/

char *GenerateOS(void)
{
	OSVERSIONINFOEX OSVi;
	OSVi.dwOSVersionInfoSize=sizeof(OSVERSIONINFOEX);
	if (GetVersionEx((OSVERSIONINFO *) &OSVi) ) {
		if(OSVi.dwMajorVersion==5 && OSVi.dwMinorVersion==0) {
			return "2K";
		} else if(OSVi.dwMajorVersion==5 && OSVi.dwMinorVersion==1 && OSVi.wServicePackMajor == 3) {
			return "XP-SP3";
		} else if(OSVi.dwMajorVersion==5 && OSVi.dwMinorVersion==1 && OSVi.wServicePackMajor == 2) {
			return "XP-SP2";
		} else if(OSVi.dwMajorVersion==5 && OSVi.dwMinorVersion==1 && OSVi.wServicePackMajor == 1) {
			return "XP-SP1";
		} else if(OSVi.dwMajorVersion==5 && OSVi.dwMinorVersion==1) {
			return "XP-SP0";
		} else if (OSVi.dwMajorVersion==5 && OSVi.dwMinorVersion==2) {
			return "2K3";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==0 && OSVi.wProductType == VER_NT_WORKSTATION && OSVi.wServicePackMajor == 2) {
			return "VS-SP2";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==0 && OSVi.wProductType == VER_NT_WORKSTATION && OSVi.wServicePackMajor == 1) {
			return "VS-SP1";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==0 && OSVi.wProductType == VER_NT_WORKSTATION) {
			return "VS-SP0";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==0 && OSVi.wProductType != VER_NT_WORKSTATION && OSVi.wServicePackMajor == 2) {
			return "2K8-SP2";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==0 && OSVi.wProductType != VER_NT_WORKSTATION && OSVi.wServicePackMajor == 1) {
			return "2K8-SP1";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==0 && OSVi.wProductType != VER_NT_WORKSTATION) {
			return "2K8-SP0";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==1 && OSVi.wProductType == VER_NT_WORKSTATION && OSVi.wServicePackMajor == 1) {
			return "W7-SP1";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==1 && OSVi.wProductType == VER_NT_WORKSTATION) {
			return "W7-SP0";
		} else if(OSVi.dwMajorVersion==6 && OSVi.dwMinorVersion==1 && OSVi.wProductType != VER_NT_WORKSTATION) {
			return "2K8";
		} else {
			return "UNK";
		}
	}
	return "UNK";
}
//////////////////////////////////////////////////////

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



