unit BTMemoryModule;

 {* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
  * Memory DLL loading code                                                 *
  * ------------------------                                                *
  *                                                                         *
  * MemoryModule "Conversion to Delphi"                                     *
  * Copyright (c) 2005 - 2006 by Martin Offenwanger / coder@dsplayer.de     *
  * http://www.dsplayer.de                                                  *
  *                                                                         *
  * Original C++ Code "MemoryModule Version 0.0.1"                          *
  * Copyright (c) 2004- 2006 by Joachim Bauch / mail@joachim-bauch.de       *
  * http://www.joachim-bauch.de                                             *
  *                                                                         *
  * This library is free software; you can redistribute it and/or           *
  * modify it under the terms of the GNU Lesser General Public              *
  * License as published by the Free Software Foundation; either            *
  * version 2.1 of the License, or (at your option) any later version.      *
  *                                                                         *
  * This library is distributed in the hope that it will be useful,         *
  * but WITHOUT ANY WARRANTY; without even the implied warranty of          *
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU       *
  * Lesser General Public License for more details.                         *
  *                                                                         *
  * You should have received a copy of the GNU Lesser General Public        *
  * License along with this library; if not, write to the Free Software     *
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA *
  *                                                                         *
  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *}
{
@author(Martin Offenwanger: coder@dsplayer.de)
@created(Mar 20, 2005)
@lastmod(Sep 27, 2005)
}

interface

uses
  // Borland Run-time Library
  Windows;

   {++++++++++++++++++++++++++++++++++++++
    ***  MemoryModule Type Definition  ***
    --------------------------------------}
type
  PBTMemoryModule = ^TBTMemoryModule;
  _BT_MEMORY_MODULE = packed record
    headers: PImageNtHeaders;
    codeBase: Pointer;
    modules: Pointer;
    numModules: integer;
    initialized: boolean;
  end;
{$EXTERNALSYM _BT_MEMORY_MODULE}
  TBTMemoryModule = _BT_MEMORY_MODULE;
  BT_MEMORY_MODULE = _BT_MEMORY_MODULE;
{$EXTERNALSYM BT_MEMORY_MODULE}


   {++++++++++++++++++++++++++++++++++++++++++++++++++
    ***  Memory DLL loading functions Declaration  ***
    --------------------------------------------------}

// return value is nil if function fails
function BTMemoryLoadLibary(var f_data: Pointer; const f_size: int64): PBTMemoryModule; stdcall;
// return value is nil if function fails
function BTMemoryGetProcAddress(var f_module: PBTMemoryModule; const f_name: PChar): Pointer; stdcall;
// free module
procedure BTMemoryFreeLibrary(var f_module: PBTMemoryModule); stdcall;
// returns last error
function BTMemoryGetLastError: string; stdcall;


implementation

//uses
  // Borland Run-time Library
//  SysUtils;

   {+++++++++++++++++++++++++++++++++++
    ***  Dll EntryPoint Definition  ***
    -----------------------------------}
type
  TDllEntryProc = function(hinstdll: THandle; fdwReason: DWORD; lpReserved: Pointer): BOOL; stdcall;


   {++++++++++++++++++++++++++++++++++++++++
    ***  Missing Windows API Definitions ***
    ----------------------------------------}

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
    Name: array[0..255] of Byte; // original: "Name: array [0..0] of Byte;"
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

var
  lastErrStr: string;


   {+++++++++++++++++++++++++++++++++++++++++++++++++++++
    ***  Memory DLL loading functions Implementation  ***
    -----------------------------------------------------}

function BTMemoryGetLastError: string; stdcall;
begin
  Result := lastErrStr;
end;

function GetFieldOffset(const Struc; const Field): Cardinal; stdcall;
begin
  Result := Cardinal(@Field) - Cardinal(@Struc);
end;

function GetImageFirstSection(NtHeader: PImageNtHeaders): PImageSectionHeader; stdcall;
begin
  Result := PImageSectionHeader(Cardinal(NtHeader) +
    GetFieldOffset(NtHeader^, NtHeader^.OptionalHeader) +
    NtHeader^.FileHeader.SizeOfOptionalHeader);
end;

function GetHeaderDictionary(f_module: PBTMemoryModule; f_idx: integer): PImageDataDirectory; stdcall;
begin
  Result := PImageDataDirectory(@(f_module.headers.OptionalHeader.DataDirectory[f_idx]));
end;

function GetImageOrdinal(Ordinal: DWORD): Word; stdcall;
begin
  Result := Ordinal and $FFFF;
end;

function GetImageSnapByOrdinal(Ordinal: DWORD): Boolean; stdcall;
begin
  Result := ((Ordinal and IMAGE_ORDINAL_FLAG32) <> 0);
end;

procedure CopySections(const f_data: Pointer; const f_old_headers: TImageNtHeaders; f_module: PBTMemoryModule); stdcall;
var
  l_size, i: integer;
  l_codebase: Pointer;
  l_dest: Pointer;
  l_section: PImageSectionHeader;
begin
  l_codebase := f_module.codeBase;
  l_section := GetImageFirstSection(f_module.headers);
  for i := 0 to f_module.headers.FileHeader.NumberOfSections - 1 do begin
    // section doesn't contain data in the dll itself, but may define
    // uninitialized data
    if (l_section.SizeOfRawData = 0) then begin
      l_size := f_old_headers.OptionalHeader.SectionAlignment;
      if l_size > 0 then begin
        l_dest := VirtualAlloc(Pointer(Cardinal(l_codebase) + l_section.VirtualAddress), l_size, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
        l_section.Misc.PhysicalAddress := cardinal(l_dest);
        ZeroMemory(l_dest, l_size);
      end;
      inc(longword(l_section), sizeof(TImageSectionHeader));
      // Continue with the nex loop
      Continue;
    end;
    // commit memory block and copy data from dll
    l_dest := VirtualAlloc(Pointer(Cardinal(l_codebase) + l_section.VirtualAddress), l_section.SizeOfRawData, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    CopyMemory(l_dest, Pointer(longword(f_data) + l_section.PointerToRawData), l_section.SizeOfRawData);
    l_section.Misc.PhysicalAddress := cardinal(l_dest);
    // IMAGE_SIZEOF_SECTION_HEADER
    inc(longword(l_section), sizeof(TImageSectionHeader));
  end;
end;

procedure PerformBaseRelocation(f_module: PBTMemoryModule; f_delta: Cardinal); stdcall;
var
  l_i: Cardinal;
  l_codebase: Pointer;
  l_directory: PImageDataDirectory;
  l_relocation: PImageBaseRelocation;
  l_dest: Pointer;
  l_relInfo: ^Word;
  l_patchAddrHL: ^DWord;
  l_type, l_offset: integer;
begin
  l_codebase := f_module.codeBase;
  l_directory := GetHeaderDictionary(f_module, IMAGE_DIRECTORY_ENTRY_BASERELOC);
  if l_directory.Size > 0 then begin
    l_relocation := PImageBaseRelocation(Cardinal(l_codebase) + l_directory.VirtualAddress);
    while l_relocation.VirtualAddress > 0 do begin
      l_dest := Pointer((Cardinal(l_codebase) + l_relocation.VirtualAddress));
      l_relInfo := Pointer(Cardinal(l_relocation) + IMAGE_SIZEOF_BASE_RELOCATION);
      for l_i := 0 to (trunc(((l_relocation.SizeOfBlock - IMAGE_SIZEOF_BASE_RELOCATION) / 2)) - 1) do begin
        // the upper 4 bits define the type of relocation
        l_type := (l_relInfo^ shr 12);
        // the lower 12 bits define the offset
        l_offset := l_relInfo^ and $FFF;
        //showmessage(inttostr(l_relInfo^));
        if l_type = IMAGE_REL_BASED_HIGHLOW then begin
          // change complete 32 bit address
          l_patchAddrHL := Pointer(Cardinal(l_dest) + Cardinal(l_offset));
          l_patchAddrHL^ := l_patchAddrHL^ + f_delta;
        end;
        inc(l_relInfo);
      end;
      l_relocation := Pointer(cardinal(l_relocation) + l_relocation.SizeOfBlock);
    end;
  end;
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

function StrComp(const Str1, Str2: PChar): Integer; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        MOV     EDI,EDX
        MOV     ESI,EAX
        MOV     ECX,0FFFFFFFFH
        XOR     EAX,EAX
        REPNE   SCASB
        NOT     ECX
        MOV     EDI,EDX
        XOR     EDX,EDX
        REPE    CMPSB
        MOV     AL,[ESI-1]
        MOV     DL,[EDI-1]
        SUB     EAX,EDX
        POP     ESI
        POP     EDI
end;

function BuildImportTable(f_module: PBTMemoryModule): boolean; stdcall;
var
  l_codeBase: Pointer;
  l_directory: PImageDataDirectory;
  l_importDesc: PImageImportDescriptor;
  l_thunkRef, l_funcRef: ^DWORD;
  l_handle: HMODULE;
  l_temp: integer;
  l_thunkData: TImageImportByName;
begin
  Result := true;
  l_codeBase := f_module.codeBase;
  l_directory := GetHeaderDictionary(f_module, IMAGE_DIRECTORY_ENTRY_IMPORT);
  if (l_directory.Size > 0) then begin
    l_importDesc := PImageImportDescriptor(Cardinal(l_codeBase) + l_directory.VirtualAddress);
    while (not IsBadReadPtr(l_importDesc, sizeof(TImageImportDescriptor))) and (l_importDesc.Name <> 0) do begin
      l_handle := LoadLibrary(PChar(Cardinal(l_codeBase) + l_importDesc.Name));
      if (l_handle = INVALID_HANDLE_VALUE) then begin
        lastErrStr := 'BuildImportTable: can''t load library: ' + PChar(Cardinal(l_codeBase) + l_importDesc.Name);
        Result := false;
        exit;
      end;
      // ReallocMemory crashes if "f_module.modules = nil"
      if f_module.modules = nil then
        f_module.modules := AllocMem(1);
      f_module.modules := ReallocMemory(f_module.modules, ((f_module.numModules + 1) * (sizeof(HMODULE))));
      if f_module.modules = nil then begin
        lastErrStr := 'BuildImportTable: ReallocMemory failed';
        result := false;
        exit;
      end;
      // module->modules[module->numModules++] = handle;
      l_temp := (sizeof(cardinal) * (f_module.numModules));
      inc(Cardinal(f_module.modules), l_temp);
      cardinal(f_module.modules^) := l_handle;
      dec(Cardinal(f_module.modules), l_temp);
      f_module.numModules := f_module.numModules + 1;
      if l_importDesc.OriginalFirstThunk <> 0 then begin
        l_thunkRef := Pointer(Cardinal(l_codeBase) + l_importDesc.OriginalFirstThunk);
        l_funcRef := Pointer(Cardinal(l_codeBase) + l_importDesc.FirstThunk);
      end else begin
        // no hint table
        l_thunkRef := Pointer(Cardinal(l_codeBase) + l_importDesc.FirstThunk);
        l_funcRef := Pointer(Cardinal(l_codeBase) + l_importDesc.FirstThunk);
      end;
      while l_thunkRef^ <> 0 do begin
        if GetImageSnapByOrdinal(l_thunkRef^) then
          l_funcRef^ := Cardinal(GetProcAddress(l_handle, PChar(GetImageOrdinal(l_thunkRef^))))
        else begin
          CopyMemory(@l_thunkData, Pointer(Cardinal(l_codeBase) + l_thunkRef^), sizeof(TImageImportByName));
          l_funcRef^ := Cardinal(GetProcAddress(l_handle, PChar(@(l_thunkData.Name))));
        end;
        if l_funcRef^ = 0 then begin
          lastErrStr := 'BuildImportTable: GetProcAddress failed';
          result := false;
          break;
        end;
        inc(l_funcRef);
        inc(l_thunkRef);
      end;
      inc(longword(l_importDesc), sizeof(TImageImportDescriptor));
    end;
  end;
end;

function GetSectionProtection(SC: cardinal): cardinal; stdcall;
//SC – ImageSectionHeader.Characteristics
begin
  result := 0;
  if (SC and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
    result := result or PAGE_NOCACHE;
  // E - Execute, R – Read , W – Write
  if (SC and IMAGE_SCN_MEM_EXECUTE) <> 0 //E ?
    then if (SC and IMAGE_SCN_MEM_READ) <> 0 //ER ?
    then if (SC and IMAGE_SCN_MEM_WRITE) <> 0 //ERW ?
      then result := result or PAGE_EXECUTE_READWRITE
      else result := result or PAGE_EXECUTE_READ
    else if (SC and IMAGE_SCN_MEM_WRITE) <> 0 //EW?
      then result := result or PAGE_EXECUTE_WRITECOPY
    else result := result or PAGE_EXECUTE
  else if (SC and IMAGE_SCN_MEM_READ) <> 0 // R?
    then if (SC and IMAGE_SCN_MEM_WRITE) <> 0 //RW?
    then result := result or PAGE_READWRITE
    else result := result or PAGE_READONLY
  else if (SC and IMAGE_SCN_MEM_WRITE) <> 0 //W?
    then result := result or PAGE_WRITECOPY
  else result := result or PAGE_NOACCESS;
end;

procedure FinalizeSections(f_module: PBTMemoryModule); stdcall;
var
  l_i: integer;
  l_section: PImageSectionHeader;
  l_protect, l_oldProtect, l_size: Cardinal;
begin
  l_section := GetImageFirstSection(f_module.headers);
  for l_i := 0 to f_module.headers.FileHeader.NumberOfSections - 1 do begin

    if (l_section.Characteristics and IMAGE_SCN_MEM_DISCARDABLE) <> 0 then begin
      // section is not needed any more and can safely be freed
      VirtualFree(Pointer(l_section.Misc.PhysicalAddress), l_section.SizeOfRawData, MEM_DECOMMIT);
      inc(longword(l_section), sizeof(TImageSectionHeader));
      continue;
    end;

    l_protect := GetSectionProtection(l_section.Characteristics);
    if (l_section.Characteristics and IMAGE_SCN_MEM_NOT_CACHED) <> 0 then
      l_protect := (l_protect or PAGE_NOCACHE);

    // determine size of region
    l_size := l_section.SizeOfRawData;
    if l_size = 0 then begin
      if (l_section.Characteristics and IMAGE_SCN_CNT_INITIALIZED_DATA) <> 0 then begin
        l_size := f_module.headers.OptionalHeader.SizeOfInitializedData;
      end else begin
        if (l_section.Characteristics and IMAGE_SCN_CNT_UNINITIALIZED_DATA) <> 0 then
          l_size := f_module.headers.OptionalHeader.SizeOfUninitializedData;
      end;
      if l_size > 0 then begin
        if not VirtualProtect(Pointer(l_section.Misc.PhysicalAddress), l_section.SizeOfRawData, l_protect, @l_oldProtect) then begin
          lastErrStr := 'FinalizeSections: VirtualProtect failed';
          exit;
        end;
      end;
    end;
    inc(longword(l_section), sizeof(TImageSectionHeader));
  end;
end;

function BTMemoryLoadLibary(var f_data: Pointer; const f_size: int64): PBTMemoryModule; stdcall;
var
  l_result: PBTMemoryModule;
  l_dos_header: TImageDosHeader;
  l_old_header: TImageNtHeaders;
  l_code, l_headers: Pointer;
  l_locationdelta: Cardinal;
  l_DllEntry: TDllEntryProc;
  l_successfull: boolean;
begin
  l_result := nil;
  Result := nil;
  try
    CopyMemory(@l_dos_header, f_data, sizeof(_IMAGE_DOS_HEADER));
    if (l_dos_header.e_magic <> IMAGE_DOS_SIGNATURE) then begin
      lastErrStr := 'BTMemoryLoadLibary: dll dos header is not valid';
      exit;
    end;
    CopyMemory(@l_old_header, pointer(longint(f_data) + l_dos_header._lfanew), sizeof(_IMAGE_NT_HEADERS));
    if l_old_header.Signature <> IMAGE_NT_SIGNATURE then begin
      lastErrStr := 'BTMemoryLoadLibary: IMAGE_NT_SIGNATURE is not valid';
      exit;
    end;
    // reserve memory for image of library
    l_code := VirtualAlloc(Pointer(l_old_header.OptionalHeader.ImageBase), l_old_header.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if l_code = nil then
        // try to allocate memory at arbitrary position
      l_code := VirtualAlloc(nil, l_old_header.OptionalHeader.SizeOfImage, MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if l_code = nil then begin
      lastErrStr := 'BTMemoryLoadLibary: VirtualAlloc failed';
      exit;
    end;
    // alloc space for the result record
    l_result := PBTMemoryModule(HeapAlloc(GetProcessHeap(), 0, sizeof(TBTMemoryModule)));
    l_result.codeBase := l_code;
    l_result.numModules := 0;
    l_result.modules := nil;
    l_result.initialized := false;
    // xy: is it correct to commit the complete memory region at once?
    //     calling DllEntry raises an exception if we don't...
    VirtualAlloc(l_code, l_old_header.OptionalHeader.SizeOfImage, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    // commit memory for headers
    l_headers := VirtualAlloc(l_code, l_old_header.OptionalHeader.SizeOfHeaders, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    // copy PE header to code
    CopyMemory(l_headers, f_data, (Cardinal(l_dos_header._lfanew) + l_old_header.OptionalHeader.SizeOfHeaders));
    l_result.headers := PImageNtHeaders(longint(l_headers) + l_dos_header._lfanew);
    // update position
    l_result.headers.OptionalHeader.ImageBase := cardinal(l_code);
    // copy sections from DLL file block to new memory location
    CopySections(f_data, l_old_header, l_result);
    // adjust base address of imported data
    l_locationdelta := Cardinal(Cardinal(l_code) - l_old_header.OptionalHeader.ImageBase);
    if l_locationdelta <> 0 then
      PerformBaseRelocation(l_result, l_locationdelta);
    // load required dlls and adjust function table of imports
    if not BuildImportTable(l_result) then begin
      lastErrStr := lastErrStr + ' BTMemoryLoadLibary: BuildImportTable failed';
      //Abort;
    end;
    // mark memory pages depending on section headers and release
    // sections that are marked as "discardable"
    FinalizeSections(l_result);
    // get entry point of loaded library
    if (l_result.headers.OptionalHeader.AddressOfEntryPoint) <> 0 then begin
      @l_DllEntry := Pointer(Cardinal(l_code) + l_result.headers.OptionalHeader.AddressOfEntryPoint);
      if @l_DllEntry = nil then begin
        lastErrStr := 'BTMemoryLoadLibary: Get DLLEntyPoint failed';
        //Abort;
      end;
      l_successfull := l_DllEntry(Cardinal(l_code), DLL_PROCESS_ATTACH, nil);
      if not l_successfull then begin
        lastErrStr := 'BTMemoryLoadLibary: Can''t attach library';
        //Abort;
      end;
      l_result.initialized := true;
    end;
  except
    BTMemoryFreeLibrary(l_result);
    exit;
  end;
  Result := l_result;
end;

function BTMemoryGetProcAddress(var f_module: PBTMemoryModule; const f_name: PChar): Pointer; stdcall;
var
  l_codeBase: Pointer;
  l_idx: integer;
  l_i: DWORD;
  l_nameRef: ^DWORD;
  l_ordinal: ^WORD;
  l_exports: PImageExportDirectory;
  l_directory: PImageDataDirectory;
  l_temp: ^DWORD;
begin
  Result := nil;
  l_codeBase := f_module.codeBase;
  l_idx := -1;
  l_directory := GetHeaderDictionary(f_module, IMAGE_DIRECTORY_ENTRY_EXPORT);
  if l_directory.Size = 0 then begin
    lastErrStr := 'BTMemoryGetProcAddress: no export table found';
    exit;
  end;
  l_exports := PImageExportDirectory(Cardinal(l_codeBase) + l_directory.VirtualAddress);
  if ((l_exports.NumberOfNames = 0) or (l_exports.NumberOfFunctions = 0)) then begin
    lastErrStr := 'BTMemoryGetProcAddress: DLL doesn''t export anything';
    exit;
  end;
  // search function name in list of exported names
  l_nameRef := Pointer(Cardinal(l_codeBase) + Cardinal(l_exports.AddressOfNames));
  l_ordinal := Pointer(Cardinal(l_codeBase) + Cardinal(l_exports.AddressOfNameOrdinals));
  for l_i := 0 to l_exports.NumberOfNames - 1 do begin
    if StrComp(f_name, PChar(Cardinal(l_codeBase) + l_nameRef^)) = 0 then begin
      l_idx := l_ordinal^;
      break;
    end;
    inc(l_nameRef);
    inc(l_ordinal);
  end;
  if (l_idx = -1) then begin
    lastErrStr := 'BTMemoryGetProcAddress: exported symbol not found';
    exit;
  end;
  if (Cardinal(l_idx) > l_exports.NumberOfFunctions - 1) then begin
    lastErrStr := 'BTMemoryGetProcAddress: name <-> ordinal number don''t match';
    exit;
  end;
  // AddressOfFunctions contains the RVAs to the "real" functions
  l_temp := Pointer(Cardinal(l_codeBase) + Cardinal(l_exports.AddressOfFunctions) + Cardinal((l_idx * 4)));
  Result := Pointer(Cardinal(l_codeBase) + l_temp^);
end;

procedure BTMemoryFreeLibrary(var f_module: PBTMemoryModule); stdcall;
var
  l_module: PBTMemoryModule;
  l_i: integer;
  l_temp: integer;
  l_DllEntry: TDllEntryProc;
begin
  l_module := f_module;
  if l_module <> nil then begin
    if l_module.initialized then begin
      @l_DllEntry := Pointer(Cardinal(l_module.codeBase) + l_module.headers.OptionalHeader.AddressOfEntryPoint);
      l_DllEntry(Cardinal(l_module.codeBase), DLL_PROCESS_DETACH, nil);
      l_module.initialized := false;
      // free previously opened libraries
      for l_i := 0 to l_module.numModules - 1 do begin
        l_temp := (sizeof(cardinal) * (l_i));
        inc(Cardinal(l_module.modules), l_temp);
        if Cardinal(f_module.modules^) <> INVALID_HANDLE_VALUE then
          FreeLibrary(Cardinal(f_module.modules^));
        dec(Cardinal(l_module.modules), l_temp);
      end;
      FreeMemory(l_module.modules);
      if l_module.codeBase <> nil then
        // release memory of library
        VirtualFree(l_module.codeBase, 0, MEM_RELEASE);
      HeapFree(GetProcessHeap(), 0, f_module);
      Pointer(f_module) := nil;
    end;
  end;
end;

end.
