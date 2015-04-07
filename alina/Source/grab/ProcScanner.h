#pragma once
#include <Windows.h>
#include <set>

class Scanner;
class ProcScanner
{
public:
	ProcScanner(DWORD pid, HANDLE hProc);
	~ProcScanner(void);

	void setsleep(unsigned int sleep);
	unsigned int getsleep();
	unsigned int getfound();
	DWORD getticks();

	void lock();
	void unlock();

	HANDLE getThreadHandle();
	void setThreadPriority(int p);
	DWORD getPid();
private:
	HANDLE hProc, hThread;
	DWORD pid;
	static void __stdcall procThread(ProcScanner *p);
	void handleregion();
	std::set<DWORD> hashes;
	void scan(const unsigned char *buf, unsigned int size);

	unsigned int sleep;
	unsigned int found, nticks;
	CRITICAL_SECTION csl;

	DWORD ticks;
};

