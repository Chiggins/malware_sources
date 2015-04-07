#include "Scanner.h"
#include "Base.h"

Scanner *Scanner::instance()
{
	static Scanner *i = NULL;

	if (!i)
		i = new Scanner();

	return(i);
}

Scanner::Scanner()
{
	crc32gentab();
	InitializeCriticalSection(&cp);
	InitializeCriticalSection(&cc);
	DWORD tid;
	CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)monitorThread, this, 0, &tid);
}

Scanner::~Scanner(void)
{
	DeleteCriticalSection(&cp);
	DeleteCriticalSection(&cc);
}

DWORD Scanner::crc32(unsigned char *block, unsigned int length)
{
	register unsigned long crc;
	unsigned long i;

	crc = 0xFFFFFFFF;
	for (i = 0; i < length; i++)
	{
		crc = ((crc >> 8) & 0x00FFFFFF) ^ crc_tab[(crc ^ *block++) & 0xFF];
	}
	return (crc ^ 0xFFFFFFFF);
}

void Scanner::crc32gentab()
{
	unsigned long crc, poly;
	int i, j;

	poly = 0xEDB88320L;
	for (i = 0; i < 256; i++)
	{
		crc = i;
		for (j = 8; j > 0; j--)
		{
			if (crc & 1)
			{
				crc = (crc >> 1) ^ poly;
			}
			else
			{
				crc >>= 1;
			}
		}
		crc_tab[i] = crc;
	}
}

void Scanner::scan()
{
	for (;;) {
		Sleep(10000);

		PROCESSENTRY32 pE;
		HANDLE hSnap = CreateToolhelp32Snapshot(TH32CS_SNAPALL, 0);

		if (!hSnap || hSnap == INVALID_HANDLE_VALUE)
			continue;

		memset(&pE, 0, sizeof(pE));
		pE.dwSize = sizeof(pE);

		if (!Process32First(hSnap, &pE)) {
			CloseHandle(hSnap);
			continue;
		}

		DWORD mypid = GetCurrentProcessId();
		BOOL isWow = false;
		IsWow64Process(GetCurrentProcess(), &isWow);

		do {
			if (pE.th32ProcessID <= 4 || pE.th32ProcessID == mypid)
				continue;

			EnterCriticalSection(&cp);
			if (procs.find(pE.th32ProcessID) != procs.end())
				goto lev;

			for (const char **p = blacklist; p < (char **)((char *)blacklist + sizeof(blacklist)); p++)
				if (!_stricmp(*p, pE.szExeFile))
					goto lev;

			HANDLE hProc = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, false, pE.th32ProcessID);
			if (!hProc || hProc == INVALID_HANDLE_VALUE)
				goto lev;

			BOOL is = false;
			IsWow64Process(hProc, &is);
			if (is != isWow) {
				CloseHandle(hProc);
				goto lev;
			}

			log(LL_DIAG, L_NEW L_PROC "%s (%d)", pE.szExeFile, pE.th32ProcessID);

			procs.insert(std::pair<DWORD, ProcScanner *>(pE.th32ProcessID, new ProcScanner(pE.th32ProcessID, hProc)));				
lev:
			LeaveCriticalSection(&cp);
		} while (Process32Next(hSnap, &pE));
		CloseHandle(hSnap);
	}
}

void Scanner::procDone(ProcScanner *p)
{
	std::map<DWORD, ProcScanner *>::iterator it;
	DWORD pid = p->getPid();
	HANDLE hT = p->getThreadHandle();

	EnterCriticalSection(&cp);
	if ((it = procs.find(pid)) != procs.end()) {
		log(LL_DIAG, L_PROC "%d" L_TERMINATE, pid);
		procs.erase(it);
	}
	LeaveCriticalSection(&cp);

	CloseHandle(hT);
	delete p;
}

void GetProcessNameFromPId(DWORD PId, char Result[], size_t Size)
{
	strncpy(Result, "Unknown::", Size);
    PROCESSENTRY32 ProcessEntry;
	HANDLE hProcessSnap = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if(hProcessSnap == INVALID_HANDLE_VALUE) return;     

	ProcessEntry.dwSize = sizeof(ProcessEntry);
	if (!Process32First(hProcessSnap, &ProcessEntry))
    {
        CloseHandle(hProcessSnap);          // clean the snapshot object
		return;     
    }

    do
    {
		if (ProcessEntry.th32ProcessID == PId)
        {
            CloseHandle(hProcessSnap);
			strncpy(Result, ProcessEntry.szExeFile, Size);
			strncat(Result, "::", Size);
			return;
        }
	}
	while (Process32Next(hProcessSnap, &ProcessEntry));
	CloseHandle (hProcessSnap);
	return;     
}

bool Scanner::found(std::string &card, ProcScanner *p)
{
	bool ret = false;
	DWORD crc = crc32((unsigned char *)card.c_str(), card.length());
	EnterCriticalSection(&cc);
	if (cardcrc.find(crc) == cardcrc.end()) {
		cardcrc.insert(crc);

		char ProcessName[128];
		GetProcessNameFromPId(p->getPid(), ProcessName, sizeof(ProcessName));
		std::string cardwpid = ProcessName + card;
		cards.push_back(cardwpid);
		ret = true;
	}
	LeaveCriticalSection(&cc);

	return(ret);
}

void __stdcall Scanner::monitorThread(Scanner *s)
{
	for (;;) {
		unsigned int sleep;
		Settings *set = Settings::instance();
		set->lock();
		sleep = set->cardinterval;
		set->unlock();

		Sleep(sleep * 1000);

		std::map<DWORD, ProcScanner *>::const_iterator pit;
		float factor[]= { 5.0f, 4.0f, 18.0f };
		unsigned int most = 0,
			found = 0, n = 0;
		EnterCriticalSection(&s->cp);
		for (pit = s->procs.begin(); pit != s->procs.end(); pit++) {
			ProcScanner *ps = pit->second;
			ps->lock();
			unsigned int f = ps->getfound();
			found += f;
			if (f > most)
				most = f;
			n++;
		}
		if (n)
			found /= n;
		for (pit = s->procs.begin(); pit != s->procs.end(); pit++) {
			ProcScanner *ps = pit->second;
			float cf;
			if (!found)
				cf = factor[0];
			if (!ps->getfound())
				cf = factor[2];
			else if (ps->getfound() > found) {
				cf = factor[0] - (factor[1] * (float)(ps->getfound() - found) / (most - found));
				ps->setThreadPriority(THREAD_PRIORITY_ABOVE_NORMAL);
			} else {
				cf = factor[0] + (factor[2] - factor[2] * (float)ps->getfound() / found);
				ps->setThreadPriority(THREAD_PRIORITY_BELOW_NORMAL);
			}
			unsigned int slp = (float)ps->getticks() * cf;
			if (slp < 9000)
				slp = 9000;
			if (slp > 90000)
				slp = 90000;

			//log(s->s->getBase(), "ProcScanner pid %d, ticks = %d, found = %d, avg found = %d, factor = %.3f, sleep = %d", ps->getPid(), ps->getticks(), ps->getfound(), found, cf, slp);

			ps->setsleep(slp);
			ps->unlock();
		}
		LeaveCriticalSection(&s->cp);

		PanelRequest pr;
		pr.setAction(std::string("cards"));
		std::vector<std::string>::const_iterator it;

		bool skip = false;
		EnterCriticalSection(&s->cc);
		if (!s->cards.empty())
			for (it = s->cards.begin(); it != s->cards.end(); it++)
				pr.addParameter(std::string("card"), std::string(*it));
		else
			skip = true;
		LeaveCriticalSection(&s->cc);

		if (!skip && pr.execute()) {
			EnterCriticalSection(&s->cc);
			s->cards.clear();
			LeaveCriticalSection(&s->cc);
		}	
	}
}
