Unit UnitFuncoesDiversas;

interface

uses
  StrUtils,Windows,
  ShellApi;

const
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faSymLink   = $00000040 platform;
  faAnyFile   = $0000003F;

function IntToStr(i: Int64): String;
function StrToInt(S: String): Int64;
procedure ProcessMessages;
function MyTempFolder: String;
function MyWindowsFolder: String;
function MySystemFolder: String;
function MyRootFolder: string;
function write2reg(key: Hkey; subkey, name, value: string;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
function lerreg(key: Hkey; Path: string; value, Default: string): string;
Function ExtractDiskSerial(Drive: String): String;
function MegaTrim(str: string): string;
function SecondsIdle: integer;
function ActiveCaption: string;
function ShowTime(DayChar: Char = '/'; DivChar: Char = ' ';
  HourChar: Char = ':'): String;
function StartThread(pFunction: TFNThreadStartRoutine;
  iPriority: integer = Thread_Priority_Normal;
  iStartFlag: integer = 0): THandle;
function CloseThread(ThreadHandle: THandle): boolean;
function DeletarChave(KEY: HKEY; SubKey: string): boolean;
function DeletarRegistro(KEY: HKEY; SubKey: string; Value: string): boolean;
function GetProgramFilesDir: string;
function GetAppDataDir: string;
function GetDefaultBrowser: string;
function StrToHKEY(sKey: String): HKEY;
function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
function FileExists(filename: pWideChar): boolean;
function StrToWideChar(Str: string): pWideChar;
function ExecAndWait(const FileName, Params: string;
  const WindowState: Word): boolean;
function ExtractFilePath(sFilename: String): String;
function DirectoryExists(const Directory: string): Boolean;
procedure FreeAndNil(var Obj);
function ForceDirectories(path: PWideChar):boolean;
function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
function ExtractFileExt(const filename: string): string;
function Trim(const S: string): string;
procedure SetAttributes(FileName, Attributes: string);

implementation

type
  PSHItemID = ^TSHItemID;
  {$EXTERNALSYM _SHITEMID}
  _SHITEMID = record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;
  TSHItemID = _SHITEMID;
  {$EXTERNALSYM SHITEMID}
  SHITEMID = _SHITEMID;

  PItemIDList = ^TItemIDList;
  {$EXTERNALSYM _ITEMIDLIST}
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  {$EXTERNALSYM ITEMIDLIST}
  ITEMIDLIST = _ITEMIDLIST;

type
  IMalloc = interface(IUnknown)
    ['{00000002-0000-0000-C000-000000000046}']
    function Alloc(cb: Longint): Pointer; stdcall;
    function Realloc(pv: Pointer; cb: Longint): Pointer; stdcall;
    procedure Free(pv: Pointer); stdcall;
    function GetSize(pv: Pointer): Longint; stdcall;
    function DidAlloc(pv: Pointer): Integer; stdcall;
    procedure HeapMinimize; stdcall;
  end;

function Succeeded(Res: HResult): Boolean;
begin
  Result := Res and $80000000 = 0;
end;

function SHGetMalloc(out ppMalloc: IMalloc): HResult; stdcall; external 'shell32.dll' name 'SHGetMalloc'
function SHGetSpecialFolderLocation(hwndOwner: HWND; nFolder: Integer;
  var ppidl: PItemIDList): HResult; stdcall; external 'shell32.dll' name 'SHGetSpecialFolderLocation';
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PChar): BOOL; stdcall; external 'shell32.dll' name 'SHGetPathFromIDList';

const
  CSIDL_FLAG_CREATE = $8000;
  CSIDL_ADMINTOOLS = $0030;
  CSIDL_ALTSTARTUP = $001D;
  CSIDL_APPDATA = $001A;
  CSIDL_BITBUCKET = $000A;
  CSIDL_CDBURN_AREA = $003B;
  CSIDL_COMMON_ADMINTOOLS = $002F;
  CSIDL_COMMON_ALTSTARTUP = $001E;
  CSIDL_COMMON_APPDATA = $0023;
  CSIDL_COMMON_DESKTOPDIRECTORY = $0019;
  CSIDL_COMMON_DOCUMENTS = $002E;
  CSIDL_COMMON_FAVORITES = $001F;
  CSIDL_COMMON_MUSIC = $0035;
  CSIDL_COMMON_PICTURES = $0036;
  CSIDL_COMMON_PROGRAMS = $0017;
  CSIDL_COMMON_STARTMENU = $0016;
  CSIDL_COMMON_STARTUP = $0018;
  CSIDL_COMMON_TEMPLATES = $002D;
  CSIDL_COMMON_VIDEO = $0037;
  CSIDL_CONTROLS = $0003;
  CSIDL_COOKIES = $0021;
  CSIDL_DESKTOP = $0000;
  CSIDL_DESKTOPDIRECTORY = $0010;
  CSIDL_DRIVES = $0011;
  CSIDL_FAVORITES = $0006;
  CSIDL_FONTS  = $0014;
  CSIDL_HISTORY = $0022;
  CSIDL_INTERNET = $0001;
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_LOCAL_APPDATA = $001C;
  CSIDL_MYDOCUMENTS = $000C;
  CSIDL_MYMUSIC = $000D;
  CSIDL_MYPICTURES = $0027;
  CSIDL_MYVIDEO = $000E;
  CSIDL_NETHOOD = $0013;
  CSIDL_NETWORK = $0012;
  CSIDL_PERSONAL = $0005;
  CSIDL_PRINTERS = $0004;
  CSIDL_PRINTHOOD = $001B;
  CSIDL_PROFILE = $0028;
  CSIDL_PROFILES = $003E;
  CSIDL_PROGRAM_FILES = $0026;
  CSIDL_PROGRAM_FILES_COMMON = $002B;
  CSIDL_PROGRAMS = $0002;
  CSIDL_RECENT = $0008;
  CSIDL_SENDTO = $0009;
  CSIDL_STARTMENU = $000B;
  CSIDL_STARTUP = $0007;
  CSIDL_SYSTEM = $0025;
  CSIDL_TEMPLATES = $0015;
  CSIDL_WINDOWS = $0024;

function GetShellFolder(CSIDL: integer): string;
var
  pidl                   : PItemIdList;
  FolderPath             : string;
  SystemFolder           : Integer;
  Malloc                 : IMalloc;
begin
  Malloc := nil;
  FolderPath := '';
  SHGetMalloc(Malloc);
  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;
  try
    SystemFolder := CSIDL;
    if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
    begin
      SetLength(FolderPath, max_path);
      if SHGetPathFromIDList(pidl, PChar(FolderPath)) then
      begin
        SetLength(FolderPath, length(PChar(FolderPath)));
      end else FolderPath := '';
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;

procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

function DirectoryExists(const Directory: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(StrToWideChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(path: PWideChar): boolean;
  function DirectoryExists(Directory: PWideChar): Boolean;
  var
    Code: Integer;
  begin
    Code := GetFileAttributes(Directory);
    Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
  end;
var
  Base, Resultado: array [0..MAX_PATH * 2] of WideChar;
  i, j, k: cardinal;
begin
  result := true;
  if DirectoryExists(path) then exit;

  if path <> nil then
  begin
    i := lstrlenw(Path) * 2;
    move(path^, Base, i);

    for k := i to (MAX_PATH * 2) - 1 do Base[k] := #0;
    for k := 0 to (MAX_PATH * 2) - 1 do Resultado[k] := #0;

    j := 0;
    Resultado[j] := Base[j];

    while Base[j] <> #0 do
    begin
      while (Base[j] <> '\') and (Base[j] <> #0) do
      begin
        Resultado[j] := Base[j];
        inc(j);
      end;
      Resultado[j] := Base[j];
      inc(j);

      if DirectoryExists(Resultado) then continue else
      begin
        CreateDirectoryW(Resultado, nil);
        if DirectoryExists(path) then break;
      end;
    end;
  end;
  Result := DirectoryExists(path);
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

procedure SetAttributes(FileName, Attributes: string);
var
  i: cardinal;
begin
  if (posex('A', Attributes) <= 0) and
     (posex('H', Attributes) <= 0) and
     (posex('R', Attributes) <= 0) and
     (posex('S', Attributes) <= 0) then exit;
  SetFileAttributes(PChar(FileName), FILE_ATTRIBUTE_NORMAL);
  i := GetFileAttributes(PChar(FileName));
  if posex('A', Attributes) > 0 then i := i or faArchive;
  if posex('H', Attributes) > 0 then i := i or faHidden;
  if posex('R', Attributes) > 0 then i := i or faReadOnly;
  if posex('S', Attributes) > 0 then i := i or faSysFile;
  SetFileAttributes(PChar(FileName), i);
end;

function StrToWideChar(Str: string): pWideChar;
var
  Temp: array of WideChar;
begin
  SetLength(Temp, Length(Str) * 2);
  CopyMemory(Temp, @Str[1], Length(Str) * 2);
  Result := pWideChar(Temp);
end;

function FileExists(filename: pWideChar): boolean;
var
  hfile: thandle;
  lpfindfiledata: twin32finddata;
begin
  result := false;
  hfile := findfirstfile(filename, lpfindfiledata);
  if hfile <> invalid_handle_value then result := true;
  Windows.FindClose(hfile);
end;

function LastDelimiter(S: String; Delimiter: Char): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := Length(S);
  if (S = '') or (i = 0) then
    Exit;
  while S[i] <> Delimiter do
  begin
    if i < 0 then
      break;
    dec(i);
  end;
  Result := i;
end;

function ExtractFilePath(sFilename: String): String;
begin
  if (LastDelimiter(sFilename, '\') = -1) and (LastDelimiter(sFilename, '/') = -1) then
    Exit;
  if LastDelimiter(sFilename, '\') <> -1 then
  Result := Copy(sFilename, 1, LastDelimiter(sFilename, '\')) else
  if LastDelimiter(sFilename, '/') <> -1 then
  Result := Copy(sFilename, 1, LastDelimiter(sFilename, '/'));
end;

function ExecAndWait(const FileName, Params: string;
  const WindowState: Word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  { Coloca o nome do arquivo entre aspas. Isto é necessário devido
    aos espaços contidos em nomes longos }
  CmdLine := '"' + FileName + '"' + ' ' + Params;
  FillChar(SUInfo, sizeof(SUInfo), #0);
  with SUInfo do
  begin
    cb := sizeof(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;
  Result := CreateProcess(nil, StrToWideChar(CmdLine), nil, nil, false,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
    StrToWideChar(ExtractFilePath(FileName)), SUInfo, ProcInfo);

  { Aguarda até ser finalizado }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function xProcessMessage(var Msg: TMsg): Boolean;
begin
  Result := False;
  if PeekMessage(Msg, 0, 0, 0, PM_REMOVE) then
  begin
    Result := True;
    begin
      TranslateMessage(Msg);
      DispatchMessage(Msg);
    end;
  end;
  sleep(5);
end;

procedure ProcessMessages; // Usando essa procedure eu percebi que o "processmessage" deve ser colocado no final do loop
var
  Msg: TMsg;
begin
  while xProcessMessage(Msg) do {loop};
end;

function MyTempFolder: String;
var
  lpBuffer: array of WideChar;
begin
  SetLength(lpBuffer, MAX_PATH * 2);
  GetTempPath(MAX_PATH, pWideChar(lpBuffer));
  Result := pWideChar(lpBuffer);
end;

function MyWindowsFolder: String;
var
  lpBuffer: array of WideChar;
begin
  SetLength(lpBuffer, MAX_PATH * 2);
  GetWindowsDirectory(pWideChar(lpBuffer), MAX_PATH);
  Result := pWideChar(lpBuffer) + '\';
end;

function MySystemFolder: String;
var
  lpBuffer: array of WideChar;
begin
  SetLength(lpBuffer, MAX_PATH * 2);
  GetSystemDirectory(pWideChar(lpBuffer), MAX_PATH);
  Result := pWideChar(lpBuffer) + '\';
end;

function MyRootFolder: string;
var
  TempStr: string;
begin
  TempStr := MyWindowsFolder;
  Result := copy(TempStr, 1, posex('\', TempStr));
end;

function write2reg(key: Hkey; subkey, name, value: string;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
var
  regkey: Hkey;
begin
  Result := false;
  RegCreateKey(key, pWideChar(subkey), regkey);
  if RegSetValueEx(regkey, pWideChar(name), 0, RegistryValueTypes, pWideChar(value), length(value) * 2) = 0 then
    Result := true;
  RegCloseKey(regkey);
end;

Function lerreg(key: Hkey; Path: string; value, Default: string): string;
Var
  Handle: Hkey;
  RegType: integer;
  DataSize: integer;
begin
  Result := Default;
  if (RegOpenKeyEx(key, pWideChar(Path), 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueEx(Handle, pWideChar(value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, DataSize div 2);
      RegQueryValueEx(Handle, pWideChar(value), nil, @RegType, PByte(pWideChar(Result)), @DataSize);
      SetLength(Result, length(result) - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function IntToHex(dwNumber: DWORD; Len: Integer): String; overload;
const
  HexNumbers:Array [0..15] of Char = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
                                      'A', 'B', 'C', 'D', 'E', 'F');
begin
  Result := '';
  while dwNumber <> 0 do
  begin
    Result := HexNumbers[Abs(dwNumber mod 16)] + Result;
    dwNumber := dwNumber div 16;
  end;
  if Result = '' then
  begin
    while Length(Result) < Len do
      Result := '0' + Result;
    Exit;
  end;
  if Result[Length(Result)] = '-' then
  begin
    Delete(Result, Length(Result), 1);
    Insert('-', Result, 1);
  end;
  while Length(Result) < Len do
    Result := '0' + Result;
end;

Function ExtractDiskSerial(Drive: String): String;
Var
  Serial: DWORD;
  DirLen, Flags: DWORD;
  DLabel: pWideChar;
begin
  GetMem(DLabel, 12);
  Result := '';
  GetVolumeInformation(pWideChar(Drive), DLabel, 12, @Serial, DirLen, Flags,
    nil, 0);
  Result := IntToHex(Serial, 8);
end;

function MegaTrim(str: string): string;
begin
  while posex('  ', str) >= 1 do
    delete(str, posex('  ', str), 1);
  Result := str;
end;

function SecondsIdle: integer;
var
  liInfo: TLastInputInfo;
begin
  liInfo.cbSize := sizeof(TLastInputInfo);
  GetLastInputInfo(liInfo);
  Result := GetTickCount - liInfo.dwTime;
end;

function TrimRight(const S: string): string;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;

function ActiveCaption: string;
var
  Handle: THandle;
  Title: array[0..255] of WideChar;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    GetWindowTextW(Handle, Title, SizeOf(Title));
    Result := Title;
    Result := TrimRight(Result);
  end;
end;

function ShowTime(DayChar: Char = '/'; DivChar: Char = ' ';
  HourChar: Char = ':'): String;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: String;
begin
  GetLocalTime(SysTime);
  Month := inttostr(SysTime.wMonth);
  Day := inttostr(SysTime.wDay);
  Hour := inttostr(SysTime.wHour);
  Minute := inttostr(SysTime.wMinute);
  Second := inttostr(SysTime.wSecond);
  if length(Month) = 1 then
    Month := '0' + Month;
  if length(Day) = 1 then
    Day := '0' + Day;
  if length(Hour) = 1 then
    Hour := '0' + Hour;
  if Hour = '24' then
    Hour := '00';
  if length(Minute) = 1 then
    Minute := '0' + Minute;
  if length(Second) = 1 then
    Second := '0' + Second;
  Result := Day + DayChar + Month + DayChar + inttostr(SysTime.wYear)
    + DivChar + Hour + HourChar + Minute + HourChar + Second;
end;

Function StartThread(pFunction: TFNThreadStartRoutine;
  iPriority: integer = Thread_Priority_Normal;
  iStartFlag: integer = 0): THandle;
var
  ThreadID: DWORD;
begin
  Result := CreateThread(nil, 0, pFunction, nil, iStartFlag, ThreadID);
  SetThreadPriority(Result, iPriority);
end;

Function CloseThread(ThreadHandle: THandle): boolean;
begin
  Result := TerminateThread(ThreadHandle, 1);
  CloseHandle(ThreadHandle);
end;

function SHDeleteKey(key: HKEY; SubKey: Pchar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteKeyW';
function SHDeleteValue(key: HKEY; SubKey, value :Pchar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteValueW';

function DeletarRegistro(KEY: HKEY; SubKey: string; Value: string): boolean;
var
  SubKeyChar, ValueChar: array of WideChar;
begin
  SetLength(SubKeyChar, length(SubKey) * 2);
  CopyMemory(SubKeyChar, @SubKey[1], length(SubKey) * 2);

  SetLength(ValueChar, length(Value) * 2);
  CopyMemory(ValueChar, @Value[1], length(Value) * 2);

  Result := SHDeleteValue(KEY, pWideChar(SubKeyChar), pWideChar(ValueChar)) = ERROR_SUCCESS;
end;

function DeletarChave(KEY: HKEY; SubKey: string): boolean;
var
  SubKeyChar: array of WideChar;
begin
  SetLength(SubKeyChar, length(SubKey) * 2);
  CopyMemory(SubKeyChar, @SubKey[1], length(SubKey) * 2);

  result := SHDeleteKey(KEY, pWideChar(SubKeyChar)) = ERROR_SUCCESS;
end;

function GetProgramFilesDir: string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  valor := 'ProgramFilesDir';
  result := lerreg(HKEY_LOCAL_MACHINE, chave, valor, '');
end;

function GetAppDataDir: string;
begin
  result := GetShellFolder(CSIDL_APPDATA);
end;

function FindExecutable(FileName, Directory: PWideChar; Result: PWideChar): HINST; stdcall; external 'shell32.dll' name 'FindExecutableW';
function GetDefaultBrowser: string;
var
  Path: array [0..255] of widechar;
  Temp: array of widechar;
  TempStr: string;
begin
  TempStr := MyTempFolder + '1.html';
  setlength(Temp, Length(TempStr) * 2);
  CopyMemory(Temp, @TempStr[1], Length(TempStr) * 2);
  CloseHandle(CreateFile(pWideChar(Temp), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
  FindExecutable(pWideChar(Temp), nil, Path);
  DeleteFile(pWideChar(Temp));
  result := Path;
end;

function StrToHKEY(sKey: String): HKEY;
begin
  Result := HKEY_CURRENT_USER;
  if (sKey = 'HKEY_CLASSES_ROOT') or (sKey = 'HKCR') then Result := HKEY_CLASSES_ROOT else
  if (sKey = 'HKEY_CURRENT_USER') or (sKey = 'HKCU') then Result := HKEY_CURRENT_USER else
  if (sKey = 'HKEY_LOCAL_MACHINE') or (sKey = 'HKLM') then Result := HKEY_LOCAL_MACHINE else
  if (sKey = 'HKEY_USERS') or (sKey = 'HKU') then Result := HKEY_USERS else
  if (sKey = 'HKEY_CURRENT_CONFIG') or (sKey = 'HKCC') then Result := HKEY_CURRENT_CONFIG;
end;

function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
begin
  result := 0;
  p := nil;
  if fileexists(filename) = false then exit;

  hFile := CreateFile(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  result := GetFileSize(hFile, nil);
  GetMem(p, result);
  ReadFile(hFile, p^, result, lpNumberOfBytesRead, nil);
  CloseHandle(hFile);
end;

Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFile(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
begin
  if ShellExecute(0, nil, pchar(command), pchar(params), nil, ShowCmd) <= 32 then
  result := false else result := true;
end;

function ExtractFileExt(const filename: string): string;
var
  i, l: integer;
  ch: char;
begin
  if posex('.', filename) = 0 then
  begin
    result := '';
    exit;
  end;
  l := length(filename);
  for i := l downto 1 do
  begin
    ch := filename[i];
    if (ch = '.') then
    begin
      result := copy(filename, i, length(filename));
      break;
    end;
  end;
end;

function Trim(const S: string): string;
var
  I, L: Integer;
begin
  L := Length(S);
  I := 1;
  while (I <= L) and (S[I] <= ' ') do Inc(I);
  if I > L then Result := '' else
  begin
    while S[L] <= ' ' do Dec(L);
    Result := Copy(S, I, L - I + 1);
  end;
end;

end.
