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
#include "peldr.h"
#include "modules.h"

// PeLdr
//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOL PeLdr::SetFileDllFlag(LPVOID module, DWORD moduleSize)
{

	BOOL bRet = FALSE;
	PIMAGE_NT_HEADERS pNtHdr;
	
	if((pNtHdr = RtlImageNtHeader(module)))
	{
		DWORD HeaderSum, CheckSum;

		pNtHdr->FileHeader.Characteristics |= IMAGE_FILE_DLL;

		if (CheckSumMappedFile(module,moduleSize,&HeaderSum,&CheckSum))
		{
			pNtHdr->OptionalHeader.CheckSum = CheckSum;

			bRet = TRUE;
		}
	}

	return bRet;
}

PIMAGE_NT_HEADERS PeLdr::PeImageNtHeader(PVOID ImageBase)
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

//----------------------------------------------------------------------------------------------------------------------------------------------------

PIMAGE_SECTION_HEADER PeLdr::PeSearchSection(PVOID ImageBase, PCHAR SectionName)
{
	PIMAGE_SECTION_HEADER ImageSectionHeader;
	PIMAGE_NT_HEADERS ImageNtHeaders;

	ImageNtHeaders = PeImageNtHeader(ImageBase);
	if (ImageNtHeaders)
	{
		ImageSectionHeader = IMAGE_FIRST_SECTION(ImageNtHeaders);

		for (WORD i = 0; i < ImageNtHeaders->FileHeader.NumberOfSections; i++)
		{
			if (!xstrcmp(SectionName, (PCHAR)&ImageSectionHeader->Name))
			{
				return ImageSectionHeader;
			}

			ImageSectionHeader++;
		}
	}

	return NULL;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID PeLdr::PeImageDirectoryEntryToData(PVOID ImageBase, BOOLEAN ImageLoaded, ULONG Directory, PULONG Size, BOOLEAN RVA)
{
	PIMAGE_NT_HEADERS32 pPE32;
	PIMAGE_NT_HEADERS64 pPE64;
	DWORD Va = 0;

	pPE32 = (PIMAGE_NT_HEADERS32)PeImageNtHeader(ImageBase);
	if (pPE32)
	{
		if (pPE32->FileHeader.Machine == IMAGE_FILE_MACHINE_I386)
		{
			if (pPE32->OptionalHeader.DataDirectory[Directory].VirtualAddress)
			{
				if (Directory >= pPE32->OptionalHeader.NumberOfRvaAndSizes) return NULL;

				Va = pPE32->OptionalHeader.DataDirectory[Directory].VirtualAddress;
				if (Va == NULL) return NULL;

				if (Size) *Size = pPE32->OptionalHeader.DataDirectory[Directory].Size;

				if (ImageLoaded) return RtlOffsetToPointer(ImageBase, Va);
			}
		}
		else if (pPE32->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64)
		{
			pPE64 = (PIMAGE_NT_HEADERS64)pPE32;
			if (pPE64->OptionalHeader.DataDirectory[Directory].VirtualAddress)
			{
				if (Directory >= pPE64->OptionalHeader.NumberOfRvaAndSizes) return NULL;

				Va = pPE64->OptionalHeader.DataDirectory[Directory].VirtualAddress;
				if (Va == NULL) return NULL;

				if (Size) *Size = pPE64->OptionalHeader.DataDirectory[Directory].Size;

				if (ImageLoaded) return RVA ? (PVOID)Va : RtlOffsetToPointer(ImageBase, Va);
			}
		}
	}

	if (Va)
	{
		PIMAGE_SECTION_HEADER Section = IMAGE_FIRST_SECTION(pPE32);
		DWORD Count = pPE32->FileHeader.NumberOfSections;

		while (Count--)
		{
			if (Section->VirtualAddress == Va) return RtlOffsetToPointer(ImageBase, Section->PointerToRawData);

			Section++;
		}
	}

	return NULL;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID PeLdr::PeGetNtdllImageBase()
{
#ifdef _WIN64
	PPEB Peb = (PPEB)__readgsqword(0x60);
#else
	PPEB Peb = (PPEB)__readfsdword(0x30);
#endif

	PLDR_DATA_TABLE_ENTRY Entry;
	PLIST_ENTRY Next;

	Next = Peb->Ldr->InMemoryOrderModuleList.Flink;
	while (Next != &Peb->Ldr->InMemoryOrderModuleList) 
	{
		Entry = CONTAINING_RECORD(Next, LDR_DATA_TABLE_ENTRY, InMemoryOrderLinks);

		if (!xwcsicmp(Entry->BaseDllName.Buffer, L"ntdll.dll")) 
		{
			return Entry->DllBase;
		}

		Next = Next->Flink;
	}

	return NULL;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID PeLdr::PeGetProcAddress(PVOID ModuleBase, PCHAR lpProcName, BOOLEAN RVA)
{
	PIMAGE_EXPORT_DIRECTORY pImageExport;
	DWORD dwExportSize;

	if (pImageExport = (PIMAGE_EXPORT_DIRECTORY)PeImageDirectoryEntryToData(ModuleBase, TRUE, IMAGE_DIRECTORY_ENTRY_EXPORT, &dwExportSize))
	{
		PDWORD pAddrOfNames = MAKE_PTR(ModuleBase, pImageExport->AddressOfNames, PDWORD);
		for (DWORD i = 0; i < pImageExport->NumberOfNames; i++)
		{
			if (!xstrcmp(RtlOffsetToPointer(ModuleBase, pAddrOfNames[i]), lpProcName))
			{
				PDWORD pAddrOfFunctions = MAKE_PTR(ModuleBase, pImageExport->AddressOfFunctions, PDWORD);
				PWORD pAddrOfOrdinals = MAKE_PTR(ModuleBase, pImageExport->AddressOfNameOrdinals, PWORD);

				return RVA ? (PVOID)pAddrOfFunctions[pAddrOfOrdinals[i]] : (PVOID)RtlOffsetToPointer(ModuleBase, pAddrOfFunctions[pAddrOfOrdinals[i]]);
			}
		}
	}

	return NULL;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN PeLdr::PeProcessImport(PVOID pMZ, BOOLEAN Ntdll64)
{
	typedef NTSTATUS (NTAPI *_LdrLoadDll)(PWCHAR PathToFile, ULONG Flags, PUNICODE_STRING ModuleFileName, PHANDLE ModuleHandle);
	typedef BOOLEAN (NTAPI *_RtlCreateUnicodeStringFromAsciiz)(PUNICODE_STRING Destination, PCHAR Source);
	typedef NTSTATUS (NTAPI *_LdrGetProcedureAddress)(PVOID BaseAddress, PANSI_STRING Name, ULONG Ordinal, PVOID *ProcedureAddress);

	_LdrLoadDll MyLdrLoadDll = (_LdrLoadDll)PeGetProcAddress(PeGetNtdllImageBase(), "LdrLoadDll");
	_RtlCreateUnicodeStringFromAsciiz MyRtlCreateUnicodeStringFromAsciiz = (_RtlCreateUnicodeStringFromAsciiz)PeGetProcAddress(PeGetNtdllImageBase(), "RtlCreateUnicodeStringFromAsciiz");
	_LdrGetProcedureAddress MyLdrGetProcedureAddress = (_LdrGetProcedureAddress)PeGetProcAddress(PeGetNtdllImageBase(), "LdrGetProcedureAddress");

	PIMAGE_IMPORT_DESCRIPTOR pImport = (PIMAGE_IMPORT_DESCRIPTOR)PeImageDirectoryEntryToData(pMZ, TRUE, IMAGE_DIRECTORY_ENTRY_IMPORT, NULL);
	if (pImport)
	{
		for (; pImport->Name; pImport++)
		{
			ANSI_STRING Name;
			UNICODE_STRING Destination;
			PVOID pvProcAddress;
			PDWORD_PTR thunkRef, funcRef;
			PCHAR szDllName = RtlOffsetToPointer(pMZ, pImport->Name);
			HMODULE hDll = NULL;

			if (Ntdll64)
			{
				if (!xstrcmp(szDllName, "ntdll.dll")) hDll = (HMODULE)PeGetNtdllImageBase(); else continue;
			}
			else
			{
				MyRtlCreateUnicodeStringFromAsciiz(&Destination, szDllName);
				if (!NT_SUCCESS(MyLdrLoadDll(NULL, 0, &Destination, (PHANDLE)&hDll))) return FALSE;
			}

			if (!hDll) return FALSE;

			if (pImport->OriginalFirstThunk)
			{
				thunkRef = MAKE_PTR(pMZ, pImport->OriginalFirstThunk, PDWORD_PTR); 
				funcRef = MAKE_PTR(pMZ, pImport->FirstThunk, PDWORD_PTR);
			}
			else
			{
				thunkRef = MAKE_PTR(pMZ, pImport->FirstThunk, PDWORD_PTR); 
				funcRef = MAKE_PTR(pMZ, pImport->FirstThunk , PDWORD_PTR);      
			}

			for (; *thunkRef; thunkRef++, funcRef++)
			{
				if (IMAGE_SNAP_BY_ORDINAL(*thunkRef))
				{
					if (!NT_SUCCESS(MyLdrGetProcedureAddress(hDll, NULL, IMAGE_ORDINAL(*thunkRef), &pvProcAddress))) return FALSE;
				}
				else
				{
					xRtlInitAnsiString(&Name, (PCHAR)&((PIMAGE_IMPORT_BY_NAME)RtlOffsetToPointer(pMZ, *thunkRef))->Name);
					if (!NT_SUCCESS(MyLdrGetProcedureAddress(hDll, &Name, 0, &pvProcAddress))) return FALSE;
				}

				if (!pvProcAddress) return FALSE;

				*(PVOID*)funcRef = pvProcAddress;
			}
		}
	}

	return TRUE;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

#ifdef _WIN64

#define LDRP_RELOCATION_FINAL	0x2   
#define IMAGE_REL_BASED_SECTION	6
#define IMAGE_REL_BASED_REL32	7

PIMAGE_BASE_RELOCATION PeLdr::PeProcessRelocationBlock(ULONG_PTR VA, ULONG SizeOfBlock, PUSHORT NextOffset, LONGLONG Diff)   
{   
	PUCHAR FixupVA;   
	USHORT Offset;   
	LONG Temp;    
	ULONGLONG Value64; 

	while (SizeOfBlock--) 
	{   

		Offset = *NextOffset & (USHORT)0xfff;   
		FixupVA = (PUCHAR)(VA + Offset);   

		switch ((*NextOffset) >> 12) 
		{   

		case IMAGE_REL_BASED_HIGHLOW :   
			*(LONG UNALIGNED *)FixupVA += (ULONG) Diff;   
			break;   

		case IMAGE_REL_BASED_HIGH :   
			Temp = *(PUSHORT)FixupVA < 16;   
			Temp += (ULONG) Diff;   
			*(PUSHORT)FixupVA = (USHORT)(Temp >> 16);   
			break;   

		case IMAGE_REL_BASED_HIGHADJ :
			if (Offset & LDRP_RELOCATION_FINAL) {   
				++NextOffset;   
				--SizeOfBlock;   
				break;   
			}   

			Temp = *(PUSHORT)FixupVA < 16;   
			++NextOffset;   
			--SizeOfBlock;   
			Temp += (LONG)(*(PSHORT)NextOffset);   
			Temp += (ULONG) Diff;   
			Temp += 0x8000;   
			*(PUSHORT)FixupVA = (USHORT)(Temp >> 16);   

			break;   

		case IMAGE_REL_BASED_LOW :    
			Temp = *(PSHORT)FixupVA;   
			Temp += (ULONG) Diff;   
			*(PUSHORT)FixupVA = (USHORT)Temp;   
			break;   

		case IMAGE_REL_BASED_IA64_IMM64:   
			FixupVA = (PUCHAR)((ULONG_PTR)FixupVA & ~(15));   
			Value64 = (ULONGLONG)0;   

			EXT_IMM64(Value64,   
				(PULONG)FixupVA + EMARCH_ENC_I17_IMM7B_INST_WORD_X,   
				EMARCH_ENC_I17_IMM7B_SIZE_X,   
				EMARCH_ENC_I17_IMM7B_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM7B_VAL_POS_X);   
			EXT_IMM64(Value64,   
				(PULONG)FixupVA + EMARCH_ENC_I17_IMM9D_INST_WORD_X,   
				EMARCH_ENC_I17_IMM9D_SIZE_X,   
				EMARCH_ENC_I17_IMM9D_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM9D_VAL_POS_X);   
			EXT_IMM64(Value64,   
				(PULONG)FixupVA + EMARCH_ENC_I17_IMM5C_INST_WORD_X,   
				EMARCH_ENC_I17_IMM5C_SIZE_X,   
				EMARCH_ENC_I17_IMM5C_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM5C_VAL_POS_X);   
			EXT_IMM64(Value64,   
				(PULONG)FixupVA + EMARCH_ENC_I17_IC_INST_WORD_X,   
				EMARCH_ENC_I17_IC_SIZE_X,   
				EMARCH_ENC_I17_IC_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IC_VAL_POS_X);   
			EXT_IMM64(Value64,   
				(PULONG)FixupVA + EMARCH_ENC_I17_IMM41a_INST_WORD_X,   
				EMARCH_ENC_I17_IMM41a_SIZE_X,   
				EMARCH_ENC_I17_IMM41a_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM41a_VAL_POS_X);   

			EXT_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM41b_INST_WORD_X),   
				EMARCH_ENC_I17_IMM41b_SIZE_X,   
				EMARCH_ENC_I17_IMM41b_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM41b_VAL_POS_X);   
			EXT_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM41c_INST_WORD_X),   
				EMARCH_ENC_I17_IMM41c_SIZE_X,   
				EMARCH_ENC_I17_IMM41c_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM41c_VAL_POS_X);   
			EXT_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_SIGN_INST_WORD_X),   
				EMARCH_ENC_I17_SIGN_SIZE_X,   
				EMARCH_ENC_I17_SIGN_INST_WORD_POS_X,   
				EMARCH_ENC_I17_SIGN_VAL_POS_X);   

			Value64+=Diff;   

			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM7B_INST_WORD_X),   
				EMARCH_ENC_I17_IMM7B_SIZE_X,   
				EMARCH_ENC_I17_IMM7B_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM7B_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM9D_INST_WORD_X),   
				EMARCH_ENC_I17_IMM9D_SIZE_X,   
				EMARCH_ENC_I17_IMM9D_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM9D_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM5C_INST_WORD_X),   
				EMARCH_ENC_I17_IMM5C_SIZE_X,   
				EMARCH_ENC_I17_IMM5C_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM5C_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IC_INST_WORD_X),   
				EMARCH_ENC_I17_IC_SIZE_X,   
				EMARCH_ENC_I17_IC_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IC_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM41a_INST_WORD_X),   
				EMARCH_ENC_I17_IMM41a_SIZE_X,   
				EMARCH_ENC_I17_IMM41a_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM41a_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM41b_INST_WORD_X),   
				EMARCH_ENC_I17_IMM41b_SIZE_X,   
				EMARCH_ENC_I17_IMM41b_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM41b_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_IMM41c_INST_WORD_X),   
				EMARCH_ENC_I17_IMM41c_SIZE_X,   
				EMARCH_ENC_I17_IMM41c_INST_WORD_POS_X,   
				EMARCH_ENC_I17_IMM41c_VAL_POS_X);   
			INS_IMM64(Value64,   
				((PULONG)FixupVA + EMARCH_ENC_I17_SIGN_INST_WORD_X),   
				EMARCH_ENC_I17_SIGN_SIZE_X,   
				EMARCH_ENC_I17_SIGN_INST_WORD_POS_X,   
				EMARCH_ENC_I17_SIGN_VAL_POS_X);   
			break;   

		case IMAGE_REL_BASED_DIR64:   

			*(ULONGLONG UNALIGNED *)FixupVA += Diff;   

			break;   

		case IMAGE_REL_BASED_MIPS_JMPADDR :    
			Temp = (*(PULONG)FixupVA & 0x3ffffff) < 2;   
			Temp += (ULONG) Diff;   
			*(PULONG)FixupVA = (*(PULONG)FixupVA & ~0x3ffffff) |   
				((Temp >> 2) & 0x3ffffff);   

			break;   

		case IMAGE_REL_BASED_ABSOLUTE :    
			break;     

		case IMAGE_REL_BASED_SECTION :   
			break;   

		case IMAGE_REL_BASED_REL32 :   
			break;  

		default :   
			return (PIMAGE_BASE_RELOCATION)NULL;   
		}   

		++NextOffset;   
	}   

	return (PIMAGE_BASE_RELOCATION)NextOffset;   
}

#else

PIMAGE_BASE_RELOCATION PeLdr::PeProcessRelocationBlock(ULONG_PTR uVA, ULONG uSizeOfBlock, PUSHORT puNextOffset, ULONGLONG lDelta)
{
#define IMAGE_REL_BASED_HIGHADJ          4
#define IMAGE_REL_BASED_SECTION          6
#define IMAGE_REL_BASED_REL32            7
#define	IMAGE_REL_BASED_HIGH3ADJ		11
#define LDRP_RELOCATION_INCREMENT		0x1
#define LDRP_RELOCATION_FINAL			0x2

	PBYTE pFixupVA = NULL;
	USHORT uOffset = 0;
	LONG lTemp = 0;
	LONG lTempOrig = 0;
	LONGLONG l64Temp64 = 0;
	LONG_PTR lActualDiff = 0;
	SHORT dwNextOffset;

	while (uSizeOfBlock --)
	{
		uOffset = *puNextOffset & ((USHORT) 0xFFF);
		pFixupVA = (PBYTE) (uVA + uOffset);

		dwNextOffset = (*puNextOffset) >> 12;

		if ( dwNextOffset == IMAGE_REL_BASED_HIGHLOW )
		{
			*(LONG UNALIGNED*) pFixupVA += (ULONG) lDelta;
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_HIGH )
		{
			lTemp = *(PUSHORT) pFixupVA << 16;
			lTemp += (ULONG) lDelta;
			*(PUSHORT) pFixupVA = (USHORT) (lTemp >> 16);
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_HIGHADJ )
		{
			if (uOffset & LDRP_RELOCATION_FINAL)
			{
				puNextOffset ++;
				uSizeOfBlock --;
			}
			else
			{
				lTemp = *(PUSHORT) pFixupVA << 16;
				lTempOrig = lTemp;

				puNextOffset ++;
				uSizeOfBlock --;

				lTemp += (LONG) (*(PSHORT) puNextOffset);
				lTemp += (ULONG) lDelta;
				lTemp += 0x8000;

				*(PUSHORT) pFixupVA = (USHORT) (lTemp >> 16);

				lActualDiff = ((((ULONG_PTR) (lTemp - lTempOrig)) >> 16) -
					(((ULONG_PTR) lDelta) >> 16));

				if (lActualDiff == 1)
				{
					*(puNextOffset - 1) |= LDRP_RELOCATION_INCREMENT;
				}
				else if (lActualDiff != 0)
				{
					*(puNextOffset - 1) |= LDRP_RELOCATION_FINAL;
				}
			}
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_LOW )
		{
			lTemp = *((PSHORT) pFixupVA);
			lTemp += (ULONG) lDelta;
			*((PUSHORT) pFixupVA) = (USHORT) lTemp;
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_ABSOLUTE )
		{
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_SECTION )
		{
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_REL32 )
		{
		}
		else if ( dwNextOffset == IMAGE_REL_BASED_HIGH3ADJ )
		{
			puNextOffset ++;
			uSizeOfBlock --;

			l64Temp64 = *(PUSHORT) pFixupVA << 16;
			l64Temp64 += (LONG) ((SHORT) puNextOffset [1]);
			l64Temp64 <<= 16;
			l64Temp64 += (LONG) ((USHORT) puNextOffset [0]);
			l64Temp64 += lDelta;
			l64Temp64 += 0x8000;
			l64Temp64 >>= 16;
			l64Temp64 += 0x8000;

			*(PUSHORT) pFixupVA = (USHORT) (l64Temp64 >> 16);

			puNextOffset ++;
			uSizeOfBlock --;
		}
		else
		{
			return (PIMAGE_BASE_RELOCATION) NULL;
		}

		puNextOffset ++;
	}

	return (PIMAGE_BASE_RELOCATION) puNextOffset;
}

#endif

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN PeLdr::PeProcessRelocs(PVOID ImageBase, ULONGLONG Diff)
{
	BOOLEAN Status = FALSE;
	ULONG TotalCountBytes = 0;   
	ULONG_PTR VA;   
	ULONG SizeOfBlock;   
	PUSHORT NextOffset = NULL;   
	PIMAGE_BASE_RELOCATION NextBlock;
	PIMAGE_NT_HEADERS NtHeaders = PeImageNtHeader(ImageBase);

	if (!NtHeaders)
	{
		Status = FALSE;

		goto Exit;
	}

	NextBlock = (PIMAGE_BASE_RELOCATION)PeImageDirectoryEntryToData(ImageBase, TRUE, IMAGE_DIRECTORY_ENTRY_BASERELOC, &TotalCountBytes);   
	if (!NextBlock || !TotalCountBytes)    
	{
		if (NtHeaders->FileHeader.Characteristics & IMAGE_FILE_RELOCS_STRIPPED) Status = FALSE; else Status = TRUE;

		goto Exit;   
	}   

	while (TotalCountBytes)    
	{   
		SizeOfBlock = NextBlock->SizeOfBlock;   
		TotalCountBytes -= SizeOfBlock;   
		SizeOfBlock -= sizeof(IMAGE_BASE_RELOCATION);   
		SizeOfBlock /= sizeof(USHORT);   
		NextOffset = (PUSHORT)((PCHAR)NextBlock + sizeof(IMAGE_BASE_RELOCATION));   

		VA = (ULONG_PTR)ImageBase + NextBlock->VirtualAddress;
		NextBlock = PeProcessRelocationBlock(VA, SizeOfBlock, NextOffset, Diff);
		if (!NextBlock)    
		{   
			Status = FALSE;   

			break;
		}   
	}   

	Status = TRUE;

Exit:
	return Status;
}
//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD_PTR PeLdr::FreeSpaceInHeader(PVOID ImageBase, PIMAGE_NT_HEADERS NtHeaders)
{
	PIMAGE_SECTION_HEADER FirstSection = IMAGE_FIRST_SECTION(NtHeaders);

	return (FirstSection->PointerToRawData - ((DWORD_PTR)FirstSection - (DWORD_PTR)ImageBase) - (NtHeaders->FileHeader.NumberOfSections * IMAGE_SIZEOF_SECTION_HEADER));
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PIMAGE_SECTION_HEADER PeLdr::GetVirtualyLastSectionHeader(PIMAGE_NT_HEADERS NtHeaders)
{
	PIMAGE_SECTION_HEADER pFirstSection = IMAGE_FIRST_SECTION(NtHeaders);

	return &pFirstSection[NtHeaders->FileHeader.NumberOfSections - 1];
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PIMAGE_SECTION_HEADER PeLdr::GetPhysicalyLastSectionHeader(PIMAGE_NT_HEADERS NtHeaders)
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

//----------------------------------------------------------------------------------------------------------------------------------------------------

BOOLEAN PeLdr::InsertSection(PCHAR SectionName, PVOID Data, DWORD DataSize, PVOID Image, DWORD ImageSize, PVOID *ResultImage, DWORD *ResultImageSize, BOOLEAN VA)
{
	BOOLEAN Result = FALSE;

	do 
	{
		if (strlen(SectionName) >= IMAGE_SIZEOF_SHORT_NAME) break;

		PIMAGE_NT_HEADERS NtHeaders = PeImageNtHeader(Image);
		if (!NtHeaders) break;

		DWORD FileAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) FileAlignment = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.FileAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) FileAlignment = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.FileAlignment;

		DWORD SectionAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) SectionAlignment = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SectionAlignment;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) SectionAlignment = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SectionAlignment;

		if (FreeSpaceInHeader(Image, NtHeaders) < IMAGE_SIZEOF_SECTION_HEADER) break;

		IMAGE_SECTION_HEADER NewSectionHeader = {0}; 

		strcpy((PCHAR)NewSectionHeader.Name, SectionName);
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

		CopyMemory(*ResultImage, Image, ImageSize);

		NtHeaders = PeImageNtHeader(*ResultImage);
		SectionHeader = GetVirtualyLastSectionHeader(NtHeaders);
		*(&SectionHeader[1]) = NewSectionHeader;
		++(NtHeaders->FileHeader.NumberOfSections);

		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.SizeOfImage += NewSectionHeader.Misc.VirtualSize;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.SizeOfImage += NewSectionHeader.Misc.VirtualSize;

		if (VA)
		{
			CopyMemory(RtlOffsetToPointer(*ResultImage, NewSectionHeader.VirtualAddress), Data, DataSize);
		}
		else
		{
			CopyMemory(RtlOffsetToPointer(*ResultImage, NewSectionHeader.PointerToRawData), Data, DataSize);
		}

		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.CheckSum = 0;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.CheckSum = 0;

		Result = TRUE;
	}
	while (FALSE);

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

DWORD64 PeLdr::PeGetImageBase(PVOID ImageBase)
{
	DWORD64 Result = 0;
	PIMAGE_NT_HEADERS NtHeaders = PeImageNtHeader(ImageBase);

	if (NtHeaders)
	{
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64) Result = ((PIMAGE_NT_HEADERS64)NtHeaders)->OptionalHeader.ImageBase;
		if (NtHeaders->FileHeader.Machine == IMAGE_FILE_MACHINE_I386) Result = ((PIMAGE_NT_HEADERS32)NtHeaders)->OptionalHeader.ImageBase;
	}

	return Result;
}

//----------------------------------------------------------------------------------------------------------------------------------------------------

PVOID PeLdr::LoadPEImage(PVOID ImageBaseRaw, MOD_PRE_PROCESS ModulePreProcess, LPSTR module_name, LPSTR params)
{
	PIMAGE_NT_HEADERS NtHeaders = PeImageNtHeader(ImageBaseRaw);

	if (NtHeaders)
	{
		PVOID Result = VirtualAlloc(NULL, NtHeaders->OptionalHeader.SizeOfImage, MEM_COMMIT|MEM_RESERVE, PAGE_EXECUTE_READWRITE);
		if (Result)
		{
			PIMAGE_SECTION_HEADER Section = IMAGE_FIRST_SECTION(NtHeaders);

			CopyMemory(Result, ImageBaseRaw, Section->PointerToRawData);

			for (WORD i = 0; i < NtHeaders->FileHeader.NumberOfSections; i++)
			{
				ZeroMemory(RtlOffsetToPointer(Result, Section[i].VirtualAddress), Section[i].Misc.VirtualSize);
				CopyMemory(RtlOffsetToPointer(Result, Section[i].VirtualAddress), RtlOffsetToPointer(ImageBaseRaw, Section[i].PointerToRawData), Section[i].SizeOfRawData);
			}

			if (PeProcessRelocs(Result, (DWORD64)Result - PeLdr::PeGetImageBase(Result)))
			{
				if (PeProcessImport(Result, FALSE))
				{
					typedef DWORD (WINAPI *DLLE)(PVOID, DWORD, DWORD);
					DLLE Entry = (DLLE)RtlOffsetToPointer(Result, NtHeaders->OptionalHeader.AddressOfEntryPoint);

					if(ModulePreProcess) ModulePreProcess(Result, module_name, params);

					DWORD r = Entry(Result, DLL_PROCESS_ATTACH, 0xDEADBEEF);

					DbgMsg(__FUNCTION__"(): DllEntry: %x\r\n", r);	

					return Result;
				}
				else
				{
					DbgMsg(__FUNCTION__"(): PeProcessImport error\r\n");
				}
			}
			else
			{
				DbgMsg(__FUNCTION__"(): PeProcessRelocs error\r\n");
			}
		}
	}

	return NULL;
}

DWORD PeLdr::RvaToOffset(PIMAGE_NT_HEADERS pPE,DWORD dwRva)
{
	PIMAGE_SECTION_HEADER pSEC = IMAGE_FIRST_SECTION(pPE);

	for (WORD i = 0; i < pPE->FileHeader.NumberOfSections; i++)
	{
		if (dwRva >= pSEC->VirtualAddress && dwRva < (pSEC->VirtualAddress + pSEC->Misc.VirtualSize))
		{
			return dwRva + ALIGN_DOWN(pSEC->PointerToRawData,pPE->OptionalHeader.FileAlignment) - pSEC->VirtualAddress;
		}

		pSEC++;
	}

	return 0;
}