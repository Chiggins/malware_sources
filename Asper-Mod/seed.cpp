#include "includes.h"
#include "externs.h"

	bool checkForTorrents() { // Torrent Seeding, Custom -- by JynX

		const char* subkey = ".torrent";
		HKEY hKey;
		if( RegOpenKey(HKEY_CLASSES_ROOT,subkey,&hKey) == ERROR_SUCCESS) {
			return true;
		}
		
		return false;
	}