#include "Updater.h"
#include "PanelRequest.h"

Updater::Updater()
{
	DWORD tid;
	InitializeCriticalSection(&csdiag);
	

	force = false;
	CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)updateThread, this, NULL, &tid);
}

Updater *Updater::instance()
{
	static Updater *i = NULL;
	if (!i)
		i = new Updater();

	return(i);
}

Updater::~Updater(void)
{
	DeleteCriticalSection(&csdiag);
}

void Updater::forceSubmit()
{
	force = true;
	while (force)
		Sleep(500);
}

void __stdcall Updater::updateThread(Updater *u)
{
	static unsigned int lastUpdateReq = 0;

	for (;;) {
		Settings *s = Settings::instance();
		s->lock();
		unsigned int sleep = s->updateinterval;
		s->unlock();
		for (unsigned int i = 0; i < sleep; i++) {
			if (u->force)
				break;

			Sleep(1000);
		}

		PanelRequest pr;
		pr.setAction(std::string("update"));
		EnterCriticalSection(&u->csdiag);
		pr.addParameter(std::string("diag"), u->diag);
		u->diag.clear();
		LeaveCriticalSection(&u->csdiag);

		std::string response;
		if (!pr.execute(response)) {
			u->force = false;
			continue;
		}
		u->force = false;

		size_t f = response.find("updateinterval=");
		if (f != std::string::npos)
			s->setUpdateInterval(atoi(&response.c_str()[f + 15]));
		
		f = response.find("cardinterval=");
		if (f != std::string::npos)
			s->setCardInterval(atoi(&response.c_str()[f + 13]));

		f = response.find("log=1");
		if (f != std::string::npos) {
			log(LL_DIAG, L_LOGGING L_ON);
			s->setLogging(true);
		}

		f = response.find("log=0");
		if (f != std::string::npos) {
			log(LL_ERROR, L_LOGGING L_OFF);
			s->setLogging(false);
		}

		unsigned short chk = 0;
		f = response.find("chk=");
		if (f != std::string::npos)
			chk = atoi(&response.c_str()[f + 4]);

		f = response.find("update=");
		if (f != std::string::npos) {
			f += 7;
			size_t e = response.find('|', f);
			if (e != std::string::npos) {
				std::string update(response, f);
				update.resize(e - f);

				if (!lastUpdateReq || GetTickCount() - lastUpdateReq > 300000) {
					lastUpdateReq = GetTickCount();
					Watcher::instance()->dlex(update, chk, true);
				} else
					log(LL_DIAG, L_NO L_DLEX ", " L_LREQUEST L_FAIL "%d" L_SECAGO, GetTickCount() - lastUpdateReq);
			}
		}

		f = response.find("dlex=");
		if (f != std::string::npos) {
			f += 5;
			size_t e = response.find('|', f);
			if (e != std::string::npos) {
				std::string dlex(response, f);
				dlex.resize(e - f);

				if (Watcher::instance()->dlex(dlex, chk))
					log(LL_DIAG, L_DLEX "%s" L_SUCCESS, dlex.c_str());
			}
		}
	}
}

void Updater::addDiag(std::string &diag)
{
	EnterCriticalSection(&csdiag);
	this->diag += diag;
	this->diag += "\n";
	LeaveCriticalSection(&csdiag);
}
