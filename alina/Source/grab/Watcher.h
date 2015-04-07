#pragma once
class Base;
#include <Windows.h>
#include <string>
#include <UrlMon.h>

class Watcher
{
public:
	Watcher();
	~Watcher(void);

	void initInstall();
	bool dlex(std::string &url, unsigned short chksum, bool term = false);

	static bool download(std::string &url, std::string &file, unsigned short chksum = 0);
	static unsigned short calcchk(const unsigned char *data, unsigned int len);
	void restart();

	static Watcher *instance();
private:
	bool getPipe();
	void terminate();
	void leavePipe();

	bool install();
	void forceInstall();

	HANDLE pipe;
	std::string pipename;
	static void __stdcall pipeThread(Watcher *w);
	static void __stdcall watcherThread(Watcher *w);

	HANDLE hPipeThread;
};

