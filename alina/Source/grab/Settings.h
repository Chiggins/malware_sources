#pragma once
#include <Windows.h>

#include <string>
#include <vector>


#include "Watcher.h"

class Base;
class Settings
{
public:
	Settings();
	~Settings();

	void lock();
	void unlock();

	std::vector<std::pair<std::string, std::string>> cnc;
	unsigned int successcode, updateinterval, cardinterval;
	bool log;

	void setUpdateInterval(unsigned int i);
	void setCardInterval(unsigned int i);
	void setLogging(bool log);

	static Settings *instance();
private:
	CRITICAL_SECTION s;
};

