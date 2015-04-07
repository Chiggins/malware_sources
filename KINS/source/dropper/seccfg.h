#ifndef _SECCFG_H_
#define _SECCFG_H_

namespace SecCfg
{
	#define SECCFG_SECTION_NAME	".idata"

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

	BOOLEAN InsertSectionConfig(PSECTION_CONFIG SectionConfig, PVOID Image, DWORD ImageSize, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN VA);
	BOOLEAN GetSectionConfig(PSECTION_CONFIG SectionConfig, PVOID Image);
	BOOLEAN GetImageFromImage(PVOID ImageBase, PVOID *ResultImageBase, DWORD *ResultImageSize, BOOLEAN Load64);
	BOOLEAN ConvertImageToImage(PVOID ImageBase, SecCfg::PSECTION_CONFIG SectionConfig, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN Load64);
	PVOID LoadImageSections(PVOID ImageBaseRaw, DWORD *ImageSize);
};

#endif
