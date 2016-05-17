unit BTMemoryModule;

{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  * Memory DLL loading code (32bit)                                         *
  *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
  * Delphi BTMemoryModule 0.0.4                                             *
  * Copyright (c) 2005-2010 by Martin Offenwanger / coder@dsplayer.de       *
  * http://www.dsplayer.de                                                  *
  *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
  * BTMemoryModule originally is a plain pascal port from c code            *
  *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
  * Original C Code Copyright (c) 2004- 2005 by Joachim Bauch               *
  * mail@joachim-bauch.de                                                   *
  * http://www.joachim-bauch.de/tutorials/loading-a-dll-from-memory/        *
  *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
  * Mozilla Public License Version 1.1:                                     *
  *- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*
  * The contents of this file are used with permission, subject to the      *
  * Mozilla Public License Version 1.1 (the "License"); you may             *
  * not use this file except in compliance with the License. You may        *
  * obtain a copy of the License at                                         *
  * http://www.mozilla.org/MPL/MPL-1.1.html                                 *
  *                                                                         +
  * Software distributed under the License is distributed on an             *
  * "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or          *
  * implied. See the License for the specific language governing            *
  * rights and limitations under the License.                               *
  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
{
  @author(Martin Offenwanger: coder@dsplayer.de)
  @created(Mar 20, 2005)
  @lastmod(Jul 16, 2010)
  @supported operationg systems(Windows 98 up to Windows 7)
  ==============================================================================
  => this version should work for all Delphi versions from 7 up to 2010      <=
  => including on most of Lazaru Free Pascal 32bit releases                  <=
  ==============================================================================
  @tested Delphi compilers(Delphi 7, Delphi 2007 , Delphi 2010)
  @tested Free Pascal compilers(Lazarus 0.9.28.2 & Free Pascal 2.2.4)
}
{$WARN UNSAFE_CODE OFF}
{$WARN UNSAFE_TYPE OFF}
{$WARN UNSAFE_CAST OFF}

interface

uses
  // Borland Run-time Library
  Windows;

{ ++++++++++++++++++++++++++++++++++++++
  ***  MemoryModule Type Definition  ***
  -------------------------------------- }
type
  PBTMemoryModule = ^TBTMemoryModule;

  _BT_MEMORY_MODULE = packed record
    headers: PImageNtHeaders;
    codeBase: Pointer;
    modules: Pointer;
    numModules: Integer;
    initialized: boolean;
  end;
{$EXTERNALSYM _BT_MEMORY_MODULE}

  TBTMemoryModule = _BT_MEMORY_MODULE;
  BT_MEMORY_MODULE = _BT_MEMORY_MODULE;
{$EXTERNALSYM BT_MEMORY_MODULE}
  PUInt64 = ^UInt64;

  { ++++++++++++++++++++++++++++++++++++++++++++++++++
    ***  Memory DLL loading functions Declaration  ***
    -------------------------------------------------- }

  // return value is nil if function fails
function BTMemoryLoadLibary(fp_data: Pointer): PBTMemoryModule;
// return value is nil if function fails
function BTMemoryGetProcAddress(fp_module: PBTMemoryModule;
  const fp_name: PChar): Pointer;
// free module
procedure BTMemoryFreeLibrary(fp_module: PBTMemoryModule);
// returns last error
function BTMemoryGetLastError: string;

implementation

uses
  // Borland Run-time Library
  SysUtils;

{ +++++++++++++++++++++++++++++++++++
  ***  Dll EntryPoint Definition  ***
  ----------------------------------- }
type
  TDllEntryProc = function(hinstdll: THandle; fdwReason: DWORD;
    lpReserved: Pointer): BOOL; stdcall;
  PDllEntryProc = ^TDllEntryProc;

  { ++++++++++++++++++++++++++++++++++++++++
    ***  Missing Windows API Definitions ***
    ---------------------------------------- }

const
  IMAGE_SIZEOF_SHORT_NAME = 8;

type

  PImageExportDirectory = ^TImageExportDirectory;

  _IMAGE_EXPORT_DIRECTORY = packed record
    Characteristics: DWORD;
    TimeDateStamp: DWORD;
    MajorVersion: Word;
    MinorVersion: Word;
    Name: DWORD;
    Base: DWORD;
    NumberOfFunctions: DWORD;
    NumberOfNames: DWORD;
    AddressOfFunctions: ^PDWORD;
    AddressOfNames: ^PDWORD;
    ADDressOfNameOrdinals: ^PWord;
  end;
{$EXTERNALSYM _IMAGE_EXPORT_DIRECTORY}

  TImageExportDirectory = _IMAGE_EXPORT_DIRECTORY;
  IMAGE_EXPORT_DIRECTORY = _IMAGE_EXPORT_DIRECTORY;
{$EXTERNALSYM IMAGE_EXPORT_DIRECTORY}
  PImageDosHeader = ^TImageDosHeader;

  _IMAGE_DOS_HEADER = packed record
    e_magic: Word;
    e_cblp: Word;
    e_cp: Word;
    e_crlc: Word;
    e_cparhdr: Word;
    e_minalloc: Word;
    e_maxalloc: Word;
    e_ss: Word;
    e_sp: Word;
    e_csum: Word;
    e_ip: Word;
    e_cs: Word;
    e_lfarlc: Word;
    e_ovno: Word;
    e_res: array [0 .. 3] of Word;
    e_oemid: Word;
    e_oeninfo: Word;
    e_res2: array [0 .. 9] of Word;
    _lfanew: LongInt;
  end;
{$EXTERNALSYM _IMAGE_DOS_HEADER}

  TImageDosHeader = _IMAGE_DOS_HEADER;
  IMAGE_DOS_HEADER = _IMAGE_DOS_HEADER;
{$EXTERNALSYM IMAGE_DOS_HEADER}

  TISHMisc = packed record
    case Integer of
      0:
        (PhysicalAddress: DWORD);
      1:
        (VirtualSize: DWORD);
  end;

  PImageSectionHeader = ^TImageSectionHeader;

  _IMAGE_SECTION_HEADER = packed record
    Name: packed array [0 .. IMAGE_SIZEOF_SHORT_NAME - 1] of Byte;
    Misc: TISHMisc;
    VirtualAddress: DWORD;
    SizeOfRawData: DWORD;
    PointerToRawData: DWORD;
    PointerToRelocations: DWORD;
    PointerToLinenumbers: DWORD;
    NumberOfRelocations: Word;
    NuberOfLinenumbers: Word;
    Characteristics: DWORD;
  end;
{$EXTERNALSYM _IMAGE_SECTION_HEADER}

  TImageSectionHeader = _IMAGE_SECTION_HEADER;
  IMAGE_SECTION_HEADER = _IMAGE_SECTION_HEADER;
{$EXTERNALSYM IMAGE_SECTION_HEADER}
  PImageBaseRelocation = ^TImageBaseRelocation;

  _IMAGE_BASE_RELOCATION = packed record
    VirtualAddress: DWORD;
    SizeOfBlock: DWORD;
  end;
{$EXTERNALSYM _IMAGE_BASE_RELOCATION}

  TImageBaseRelocation = _IMAGE_BASE_RELOCATION;
  IMAGE_BASE_RELOCATION = _IMAGE_BASE_RELOCATION;
{$EXTERNALSYM IMAGE_BASE_RELOCATION}
  PImageImportDescriptor = ^TImageImportDescriptor;

  _IMAGE_IMPORT_DESCRIPTOR = packed record
    OriginalFirstThunk: DWORD;
    TimeDateStamp: DWORD;
    ForwarderChain: DWORD;
    Name: DWORD;
    FirstThunk: DWORD;
  end;
{$EXTERNALSYM _IMAGE_IMPORT_DESCRIPTOR}

  TImageImportDescriptor = _IMAGE_IMPORT_DESCRIPTOR;
  IMAGE_IMPORT_DESCRIPTOR = _IMAGE_IMPORT_DESCRIPTOR;
{$EXTERNALSYM IMAGE_IMPORT_DESCRIPTOR}
  PImageImportByName = ^TImageImportByName;

  _IMAGE_IMPORT_BY_NAME = packed record
    Hint: Word;
    Name: array [0 .. 255] of Byte; // original: "Name: array [0..0] of Byte;"
  end;
{$EXTERNALSYM _IMAGE_IMPORT_BY_NAME}

  TImageImportByName = _IMAGE_IMPORT_BY_NAME;
  IMAGE_IMPORT_BY_NAME = _IMAGE_IMPORT_BY_NAME;
{$EXTERNALSYM IMAGE_IMPORT_BY_NAME}

const
  IMAGE_SIZEOF_BASE_RELOCATION = 8;
{$EXTERNALSYM IMAGE_SIZEOF_BASE_RELOCATION}
  IMAGE_REL_BASED_HIGHLOW = 3;
{$EXTERNALSYM IMAGE_REL_BASED_HIGHLOW}
  IMAGE_ORDINAL_FLAG32 = DWORD($80000000);
{$EXTERNALSYM IMAGE_ORDINAL_FLAG32}
  IMAGE_DIRECTORY_ENTRY_IMPORT = 1;
{$EXTERNALSYM IMAGE_DIRECTORY_ENTRY_IMPORT}
  IMAGE_DIRECTORY_ENTRY_BASERELOC = 5;
{$EXTERNALSYM IMAGE_DIRECTORY_ENTRY_BASERELOC}
  IMAGE_SCN_LNK_NRELOC_CVFL = $01000000;
{$EXTERNALSYM IMAGE_SCN_LNK_NRELOC_CVFL}
  IMAGE_SCN_MEM_DISCARDABLE = $02000000;
{$EXTERNALSYM IMAGE_SCN_MEM_DISCARDABLE}
  IMAGE_SCN_MEM_NOT_CACHED = $04000000;
{$EXTERNALSYM IMAGE_SCN_MEM_NOT_CACHED}
  IMAGE_SCN_MEM_NOT_PAGED = $08000000;
{$EXTERNALSYM IMAGE_SCN_MEM_NOT_PAGED}
  IMAGE_SCN_MEM_NOT_SHARED = $10000000;
{$EXTERNALSYM IMAGE_SCN_MEM_NOT_SHARED}
  IMAGE_SCN_MEM_EXECUTE = $20000000;
{$EXTERNALSYM IMAGE_SCN_MEM_EXECUTE}
  IMAGE_SCN_MEM_READ = $40000000;
{$EXTERNALSYM IMAGE_SCN_MEM_READ}
  IMAGE_SCN_MEM_WRITE = DWORD($80000000);
{$EXTERNALSYM IMAGE_SCN_MEM_WRITE}
  IMAGE_SCN_CNT_INITIALIZED_DATA = $00000040;
{$EXTERNALSYM IMAGE_SCN_CNT_INITIALIZED_DATA}
  IMAGE_SCN_CNT_UNINITIALIZED_DATA = $00000080;
{$EXTERNALSYM IMAGE_SCN_CNT_UNINITIALIZED_DATA}
  IMAGE_DIRECTORY_ENTRY_EXPORT = 0;
{$EXTERNALSYM IMAGE_DIRECTORY_ENTRY_EXPORT}

var
  lastErrStr: string;

  { +++++++++++++++++++++++++++++++++++++++++++++++++++++
    ***  Memory DLL loading functions Implementation  ***
    ----------------------------------------------------- }

function BTMemoryGetLastError: string;
begin
  Result := lastErrStr;
end;

procedure IncP(var f_X; f_N: UInt64);
begin
  Pointer(f_X) := Pointer(UInt64(f_X) + f_N);
end;

procedure DecP(var f_X; f_N: UInt64);
begin
  Pointer(f_X) := Pointer(UInt64(f_X) - f_N);
end;

function IncF(f_X: Pointer; f_N: UInt64): Pointer; overload;
begin
  try
    Result := Pointer(UInt64(f_X) + f_N);
  except
    Result := nil;
  end;
end;

function IncF(f_X: Pointer; f_N: Pointer): Pointer; overload;
begin
  try
    Result := Pointer(UInt64(f_X) + UInt64(f_N));
  except
    Result := nil;
  end;
end;

function DecF(f_X: Pointer; f_N: UInt64): Pointer;
begin
  try
    Result := Pointer(UInt64(f_X) - f_N);
  except
    Result := nil;
  end;
end;

function PAnsiCharToPChar(f_X: Pointer): PChar;
begin
{$IFDEF UNICODE}
  Result := StringToOleStr(PAnsiChar(f_X));
{$ELSE}
  Result := PAnsiChar(f_X);
{$ENDIF}
end;

function GetFieldOffset(const Struc; const Field): Cardinal;
begin
  Result := UInt64(@Field) - UInt64(@Struc);
end;

function GetImageFirstSection(NtHeader: PImageNtHeaders): PImageSectionHeader;
  stdcall;
begin
  Result := PImageSectionHeader(UInt64(NtHeader) + GetFieldOffset(NtHeader^,
      NtHeader^.OptionalHeader) + NtHeader^.FileHeader.SizeOfOptionalHeader);
end;

function GetHeaderDictionary(f_module: PBTMemoryModule;
  f_idx: Integer): PImageDataDirectory;
begin
  Result := PImageDataDirectory
    (@(f_module^.headers^.OptionalHeader.DataDirectory[f_idx]));
end;

function GetImageOrdinal(Ordinal: DWORD): Word;
begin
  Result := Ordinal and $FFFF;
end;

function GetImageSnapByOrdinal(Ordinal: DWORD): boolean;
begin
  Result := ((Ordinal and IMAGE_ORDINAL_FLAG32) <> 0);
end;

procedure CopySections(fp_data: Pointer; f_old_headers: TImageNtHeaders;
  fp_module: PBTMemoryModule);
var
  lp_dest: Pointer;
  l_size, l_i: Integer;
  lp_section: PImageSectionHeader;
begin
  lp_section := GetImageFirstSection(fp_module^.headers);
  for l_i := 0 to fp_module^.headers^.FileHeader.NumberOfSections - 1 do
  begin
    // section doesn't contain data in the dll itself, but may define
    // uninitialized data
    if (lp_section^.SizeOfRawData = 0) then
    begin
      l_size := f_old_headers.OptionalHeader.SectionAlignment;
      if l_size > 0 then
      begin
        lp_dest := VirtualAlloc(IncF(fp_module^.codeBase,
            lp_section^.VirtualAddress), l_size, MEM_COMMIT, PAGE_READWRITE);
        lp_section^.Misc.PhysicalAddress := UInt64(lp_dest);
        ZeroMemory(lp_dest, l_size);
      end;
      IncP(lp_section, SizeOf(TImageSectionHeader));
      // Continue with the nex loop
      Continue;
    end;
    // commit memory block and copy data from dll
    lp_dest := VirtualAlloc(IncF(fp_module^.codeBase,
        lp_section^.VirtualAddress), lp_section^.SizeOfRawData,
      MEM_COMMIT, PAGE_READWRITE);
    CopyMemory(lp_dest, IncF(fp_data, lp_section^.PointerToRawData),
      lp_section^.SizeOfRawData);
    lp_section^.Misc.PhysicalAddress := UInt64(lp_dest);
    IncP(lp_section, SizeOf(TImageSectionHeader));
  end;
end;

// xy this procedure still contains 32 bit code..
procedure PerformBaseRelocation(f_module: PBTMemoryModule; f_delta: Cardinal);
  stdcall;
var
  l_i: Cardinal;
  lp_directory: PImageDataDirectory;
  lp_relocation: PImageBaseRelocation;
  lp_dest: Pointer;
  lp_relInfo: PWord;
  l_type, l_offset: Integer;
begin
  lp_directory := GetHeaderDictionary(f_module,
    IMAGE_DIRECTORY_ENTRY_BASERELOC);
  if lp_directory^.Size > 0 then
  begin
    lp_relocation := IncF(f_module^.codeBase, lp_directory^.VirtualAddress);
    while lp_relocation^.VirtualAddress > 0 do
    begin
      lp_dest := IncF(f_module^.codeBase, lp_relocation^.VirtualAddress);
      lp_relInfo := IncF(lp_relocation, IMAGE_SIZEOF_BASE_RELOCATION);
      for l_i := 0 to (trunc(((lp_relocation^.SizeOfBlock -
                IMAGE_SIZEOF_BASE_RELOCATION) / 2)) - 1) do
      begin
        // the upper 4 bits define the type of relocation
        l_type := (lp_relInfo^ shr 12);
        // the lower 12 bits define the offset
        l_offset := lp_relInfo^ and $FFF;
        if l_type = IMAGE_REL_BASED_HIGHLOW then
        begin
          // change complete 32 bit address
          IncP(PUInt64(IncF(lp_dest, l_offset))^, f_delta);
        end;
        Inc(lp_relInfo);
      end;
      IncP(lp_relocation, lp_relocation^.SizeOfBlock);
    end;
  end;
end;

function BuildImportTable(fp_module: PBTMemoryModule): boolean; stdcall;
var
  lp_directory: PImageDataDirectory;
  lp_importDesc: PImageImportDescriptor;
  lp_thunkRef, lp_funcRef: PCardinal;
  l_handle: HMODULE;
  l_temp: Integer;
  l_thunkData: TImageImportByName;
begin
  Result := true;
  lp_directory := GetHeaderDictionary(fp_module, IMAGE_DIRECTORY_ENTRY_IMPORT);
  if (lp_directory^.Size > 0) then
  begin
    lp_importDesc := IncF(fp_module^.codeBase, lp_directory^.VirtualAddress);
    while (not IsBadReadPtr(lp_importDesc, SizeOf(TImageImportDescriptor))) and
      (lp_importDesc^.Name <> 0) do
    begin
      l_handle := LoadLibrary(PAnsiCharToPChar(IncF(fp_module^.codeBase,
            lp_importDesc^.Name)));
      if (l_handle = INVALID_HANDLE_VALUE) then
      begin
        lastErrStr :=
          'BuildImportTable: can''t load library: ' + PAnsiCharToPChar
          (IncF(fp_module^.codeBase, lp_importDesc^.Name));
        Result := false;
        exit;
      end;
      // ReallocMemory crashes if "f_module.modules = nil"
      if fp_module^.modules = nil then
        fp_module^.modules := AllocMem(1);
      fp_module^.modules := ReallocMemory(fp_module^.modules,
        ((fp_module^.numModules + 1) * (SizeOf(HMODULE))));
      if fp_module^.modules = nil then
      begin
        lastErrStr := 'BuildImportTable: ReallocMemory failed';
        Result := false;
        exit;
      end;
      // module->modules[module->numModules++] = handle;
      l_temp := (SizeOf(Cardinal) * (fp_module^.numModules));
      IncP(fp_module^.modules, l_temp);
      UInt64(fp_module^.modules^) := l_handle;
      DecP(fp_module^.modules, l_temp);
      fp_module^.numModules := fp_module^.numModules + 1;
      if lp_importDesc^.OriginalFirstThunk <> 0 then
        lp_thunkRef := IncF(fp_module^.codeBase,
          lp_importDesc^.OriginalFirstThunk)
      else
        lp_thunkRef := IncF(fp_module^.codeBase, lp_importDesc^.FirstThunk);
      lp_funcRef := IncF(fp_module^.codeBase, lp_importDesc^.FirstThunk);
      while lp_thunkRef^ <> 0 do
      begin
        if GetImageSnapByOrdinal(lp_thunkRef^) then
          lp_funcRef^ := UInt64(GetProcAddress(l_handle,
              PAnsiChar(GetImageOrdinal(lp_thunkRef^))))
        else
        begin
          CopyMemory(@l_thunkData, IncF(fp_module^.codeBase, lp_thunkRef^),
            SizeOf(TImageImportByName));
          lp_funcRef^ := UInt64(GetProcAddress(l_handle,
              PAnsiChar(@(l_thunkData.Name))));
        end;
        if lp_funcRef^ = 0 then
        begin
          lastErrStr := 'BuildImportTable: GetProcAddress failed';
          Result := false;
          break;
        end;
        Inc(lp_funcRef);
        Inc(lp_thunkRef);
      end;
      IncP(lp_importDesc, SizeOf(TImageImportDescriptor));
    end;
  end;
end;

function GetSectionProtection(f_SC: Cardinal): Cardinal; stdcall;
// SC – ImageSectionHeader.Characteristics
begin
  Result := 0;
  if (f_SC and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
    Result := Result or PAGE_NOCACHE;
  // E - Execute, R – Read , W – Write
  if (f_SC and IMAGE_SCN_MEM_EXECUTE) <> 0 // E ?
    then
    if (f_SC and IMAGE_SCN_MEM_READ) <> 0 // ER ?
      then
      if (f_SC and IMAGE_SCN_MEM_WRITE) <> 0 // ERW ?
        then
        Result := Result or PAGE_EXECUTE_READWRITE
      else
        Result := Result or PAGE_EXECUTE_READ
      else if (f_SC and IMAGE_SCN_MEM_WRITE) <> 0 // EW?
        then
        Result := Result or PAGE_EXECUTE_WRITECOPY
      else
        Result := Result or PAGE_EXECUTE
      else if (f_SC and IMAGE_SCN_MEM_READ) <> 0 // R?
        then
        if (f_SC and IMAGE_SCN_MEM_WRITE) <> 0 // RW?
          then
          Result := Result or PAGE_READWRITE
        else
          Result := Result or PAGE_READONLY
        else if (f_SC and IMAGE_SCN_MEM_WRITE) <> 0 // W?
          then
          Result := Result or PAGE_WRITECOPY
        else
          Result := Result or PAGE_NOACCESS;
end;

procedure FinalizeSections(fp_module: PBTMemoryModule); stdcall;
var
  l_i: Integer;
  lp_section: PImageSectionHeader;
  l_protect, l_oldProtect, l_size: Cardinal;
begin
  lp_section := GetImageFirstSection(fp_module^.headers);
  for l_i := 0 to fp_module^.headers^.FileHeader.NumberOfSections - 1 do
  begin

    if (lp_section^.Characteristics and IMAGE_SCN_MEM_DISCARDABLE) <> 0 then
    begin
      // section is not needed any more and can safely be freed
      VirtualFree(Pointer(lp_section^.Misc.PhysicalAddress),
        lp_section^.SizeOfRawData, MEM_DECOMMIT);
      DecP(lp_section, SizeOf(TImageSectionHeader));
      // run next for loop interation...
      Continue;
    end;

    l_protect := GetSectionProtection(lp_section^.Characteristics);
    if (lp_section^.Characteristics and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
      l_protect := (l_protect or PAGE_NOCACHE);

    // determine size of region
    l_size := lp_section^.SizeOfRawData;
    if l_size = 0 then
    begin
      if (lp_section^.Characteristics and IMAGE_SCN_CNT_INITIALIZED_DATA)
        <> 0 then
      begin
        l_size := fp_module^.headers^.OptionalHeader.SizeOfInitializedData;
      end
      else
      begin
        if (lp_section^.Characteristics and IMAGE_SCN_CNT_UNINITIALIZED_DATA)
          <> 0 then
          l_size := fp_module^.headers^.OptionalHeader.SizeOfUninitializedData;
      end;
      if l_size > 0 then
      begin
        if not VirtualProtect(Pointer(lp_section^.Misc.PhysicalAddress),
          lp_section^.SizeOfRawData, l_protect, @l_oldProtect) then
        begin
          lastErrStr := 'FinalizeSections: VirtualProtect failed';
          exit;
        end;
      end;
    end;
    IncP(lp_section, SizeOf(TImageSectionHeader));
  end;
end;

function BTMemoryLoadLibary(fp_data: Pointer): PBTMemoryModule;
var
  lp_result: PBTMemoryModule;
  l_dos_header: TImageDosHeader;
  l_old_header: TImageNtHeaders;
  l_code, l_headers: Pointer;
  l_locationdelta: Cardinal;
  lp_DllEntry: PDllEntryProc;
  l_successfull: boolean;
begin
  lp_result := nil;
  Result := nil;
  try
    CopyMemory(@l_dos_header, fp_data, SizeOf(_IMAGE_DOS_HEADER));
    if (l_dos_header.e_magic <> IMAGE_DOS_SIGNATURE) then
    begin
      lastErrStr := 'BTMemoryLoadLibary: dll dos header is not valid';
      exit;
    end;
    CopyMemory(@l_old_header, IncF(fp_data, l_dos_header._lfanew),
      SizeOf(_IMAGE_NT_HEADERS));
    if l_old_header.Signature <> IMAGE_NT_SIGNATURE then
    begin
      lastErrStr := 'BTMemoryLoadLibary: IMAGE_NT_SIGNATURE is not valid';
      exit;
    end;
    // reserve memory for image of library
    l_code := VirtualAlloc(Pointer(l_old_header.OptionalHeader.ImageBase),
      l_old_header.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_READWRITE);
    if l_code = nil then
      // try to allocate memory at arbitrary position
      l_code := VirtualAlloc(nil, l_old_header.OptionalHeader.SizeOfImage,
        MEM_RESERVE, PAGE_READWRITE);
    if l_code = nil then
    begin
      lastErrStr := 'BTMemoryLoadLibary: VirtualAlloc failed';
      exit;
    end;
    // alloc space for the result record
    lp_result := PBTMemoryModule(HeapAlloc(GetProcessHeap(), 0,
        SizeOf(TBTMemoryModule)));
    lp_result^.codeBase := l_code;
    lp_result^.numModules := 0;
    lp_result^.modules := nil;
    lp_result^.initialized := false;
    // xy: is it correct to commit the complete memory region at once?
    // calling DllEntry raises an exception if we don't...
    VirtualAlloc(l_code, l_old_header.OptionalHeader.SizeOfImage, MEM_COMMIT,
      PAGE_READWRITE);
    // commit memory for headers
    l_headers := VirtualAlloc(l_code,
      l_old_header.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_READWRITE);
    // copy PE header to code
    CopyMemory(l_headers, fp_data,
      (UInt64(l_dos_header._lfanew)
          + l_old_header.OptionalHeader.SizeOfHeaders));
    lp_result^.headers := PImageNtHeaders
      (UInt64(l_headers) + l_dos_header._lfanew);
    // update position
    lp_result^.headers^.OptionalHeader.ImageBase := UInt64(l_code);
    // copy sections from DLL file block to new memory location
    CopySections(fp_data, l_old_header, lp_result);
    // adjust base address of imported data
    l_locationdelta := Cardinal
      (UInt64(l_code) - l_old_header.OptionalHeader.ImageBase);
    if l_locationdelta <> 0 then
      PerformBaseRelocation(lp_result, l_locationdelta);
    // load required dlls and adjust function table of imports
    if not BuildImportTable(lp_result) then
    begin
      lastErrStr := lastErrStr + ' BTMemoryLoadLibary: BuildImportTable failed';
      Abort;
    end;
    // mark memory pages depending on section headers and release
    // sections that are marked as "discardable"
    FinalizeSections(lp_result);
    // get entry point of loaded library
    if (lp_result^.headers^.OptionalHeader.AddressOfEntryPoint) <> 0 then
    begin
      lp_DllEntry := Pointer
        (UInt64(l_code)
          + lp_result^.headers^.OptionalHeader.AddressOfEntryPoint);
      if lp_DllEntry = nil then
      begin
        lastErrStr := 'BTMemoryLoadLibary: Get DLLEntyPoint failed';
        Abort;
      end;
      l_successfull := TDllEntryProc(lp_DllEntry)(UInt64(l_code),
        DLL_PROCESS_ATTACH, nil);
      if not l_successfull then
      begin
        lastErrStr := 'BTMemoryLoadLibary: Can''t attach library';
        Abort;
      end;
      lp_result^.initialized := true;
    end;
  except
    BTMemoryFreeLibrary(lp_result);
    exit;
  end;
  Result := lp_result;
end;

function BTMemoryGetProcAddress(fp_module: PBTMemoryModule;
  const fp_name: PChar): Pointer;
var
  l_idx: Integer;
  l_i: DWORD;
  l_nameRef: PDWORD;
  l_ordinal: PWord;
  l_exports: PImageExportDirectory;
  l_directory: PImageDataDirectory;
begin
  Result := nil;
  l_idx := -1;
  l_directory := GetHeaderDictionary(fp_module, IMAGE_DIRECTORY_ENTRY_EXPORT);
  if l_directory^.Size = 0 then
  begin
    lastErrStr := 'BTMemoryGetProcAddress: no export table found';
    exit;
  end;
  l_exports := IncF(fp_module^.codeBase, l_directory^.VirtualAddress);
  if ((l_exports^.NumberOfNames = 0) or (l_exports^.NumberOfFunctions = 0)) then
  begin
    lastErrStr := 'BTMemoryGetProcAddress: DLL doesn''t export anything';
    exit;
  end;
  // search function name in list of exported names
  l_nameRef := IncF(fp_module^.codeBase, l_exports^.AddressOfNames);
  l_ordinal := IncF(fp_module^.codeBase, l_exports^.ADDressOfNameOrdinals);
  for l_i := 0 to l_exports^.NumberOfNames - 1 do
  begin
    if StrComp(fp_name, PAnsiCharToPChar(IncF(fp_module^.codeBase, l_nameRef^))
      ) = 0 then
    begin
      l_idx := l_ordinal^;
      break;
    end;
    Inc(l_nameRef);
    Inc(l_ordinal);
  end;
  if (l_idx = -1) then
  begin
    lastErrStr := 'BTMemoryGetProcAddress: exported symbol not found';
    exit;
  end;
  if (UInt64(l_idx) > l_exports^.NumberOfFunctions - 1) then
  begin
    lastErrStr :=
      'BTMemoryGetProcAddress: name <-> ordinal number don''t match';
    exit;
  end;
  // AddressOfFunctions contains the RVAs to the "real" functions
  Result := IncF(fp_module^.codeBase,
    PUInt64(IncF(fp_module^.codeBase, IncF(l_exports^.AddressOfFunctions,
          l_idx * 4)))^);
end;

procedure BTMemoryFreeLibrary(fp_module: PBTMemoryModule);
var
  lp_module: PBTMemoryModule;
  l_i: Integer;
  l_temp: Integer;
  lp_DllEntry: PDllEntryProc;
begin
  lp_module := fp_module;
  if lp_module <> nil then
  begin
    if lp_module^.initialized then
    begin
      lp_DllEntry := IncF(lp_module^.codeBase,
        lp_module^.headers^.OptionalHeader.AddressOfEntryPoint);
      TDllEntryProc(lp_DllEntry)(UInt64(lp_module^.codeBase),
        DLL_PROCESS_DETACH, nil);
      lp_module^.initialized := false;
      // free previously opened libraries
      for l_i := 0 to lp_module^.numModules - 1 do
      begin
        l_temp := (SizeOf(Cardinal) * (l_i));
        IncP(lp_module^.modules, l_temp);
        if UInt64(fp_module^.modules^) <> INVALID_HANDLE_VALUE then
          FreeLibrary(UInt64(fp_module^.modules^));
        DecP(lp_module^.modules, l_temp);
      end;
      FreeMemory(lp_module^.modules);
      if lp_module^.codeBase <> nil then
        // release memory of library
        VirtualFree(lp_module^.codeBase, 0, MEM_RELEASE);
      HeapFree(GetProcessHeap(), 0, fp_module);
      Pointer(fp_module) := nil;
    end;
  end;
end;

end.
