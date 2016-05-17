Unit UnitFuncoesDiversas;

interface

uses
  StrUtils,Windows,
  Classes;

type
  xString = array [0..MAX_PATH] of WideChar;

function PossoMexer(FileName: widestring): boolean;
function GetShellFolder(CSIDL: integer): widestring;
function SecondsIdle: integer;
function MyTempFolder: WideString;
function MyWindowsFolder: WideString;
function MySystemFolder: WideString;
function MyRootFolder: WideString;
function GetDefaultBrowser: xString;
function GetProgramFilesDir: WideString;
function GetAppDataDir: WideString;
Function lerreg(key: Hkey; Path: WideString; value, Default: WideString): WideString;
function FileExists(filename: pWideChar): boolean;
function ExtractFilePath(sFilename: WideString): WideString;
function ExecAndWait(const FileName, Params: WideString;
  const WindowState: Word): boolean;
function ActiveCaption: WideString;
function write2reg(key: Hkey; subkey, name, value: WideString;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
function MegaTrim(str: widestring): widestring;
function ShowTime(DayChar: WideChar = '/'; DivChar: WideChar = ' ';
  HourChar: WideChar = ':'): WideString;
function ExtractDiskSerial(Drive: WideString): WideString;
function IntToStr(i: Int64): WideString;
procedure FreeAndNil(var Obj);
procedure ProcessMessages;
function ParamStr(Index: Integer): WideString;
function DeletarRegistro(KEY: HKEY; SubKey: widestring; Value: widestring): boolean;
function DeletarChave(KEY: HKEY; SubKey: widestring): boolean;
function StrToHKEY(sKey: WideString): HKEY;
function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PWideChar; ShowCmd: Integer): HINST; stdcall;
function ExecuteCommand(command, params: widestring; ShowCmd: dword): boolean;
function URLDownloadToFile(Caller: IUnknown; URL: PWideChar; FileName: PWideChar; Reserved: DWORD; StatusCB: pointer): HResult; stdcall;
function ExtractFileName(const Path: widestring): widestring;
function Trim(const S: widestring): widestring;
function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
function ExtractFileExt(const filename: widestring): widestring;
procedure SetAttributes(FileName, Attributes: widestring);
function ForceDirectories(path: PWideChar): boolean;
Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
procedure HideFileName(FileName: widestring);
Function ReplaceString(ToBeReplaced, ReplaceWith: widestring; TheString: widestring): widestring;
function customStringReplace(OriginalString, Pattern, Replace: widestring): widestring;
function ValidarString(s: WideString): WideString;
Function StartThread(pFunction: TFNThreadStartRoutine; Param: pointer;
  iPriority: integer = Thread_Priority_Normal;
  iStartFlag: integer = 0): THandle;
Function CloseThread(ThreadHandle: THandle): boolean;
function LowerString(S: WideString): WideString;

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
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PWideChar): BOOL; stdcall; external 'shell32.dll' name 'SHGetPathFromIDListW';

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

function PossoMexer(FileName: widestring): boolean;
var
  FS: TFileStream;
begin
  result := true;
  try
    FS := TFileStream.Create(Filename, $0000);
    except
    result := false;
  end;
  FreeAndNil(FS);
end;

function GetShellFolder(CSIDL: integer): widestring;
var
  pidl                   : PItemIdList;
  FolderPath             : widestring;
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
      if SHGetPathFromIDList(pidl, PWideChar(FolderPath)) then
      begin
        SetLength(FolderPath, length(PWideChar(FolderPath)));
      end else FolderPath := '';
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;

const
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faSymLink   = $00000040 platform;
  faAnyFile   = $0000003F;

const
  DriveDelim = {$IFDEF MSWINDOWS} ':'; {$ELSE} '';  {$ENDIF}
  PathDelim  = {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF}
var
  FileBrowser: WideString = 'x.html';

function SecondsIdle: integer;
var
  liInfo: TLastInputInfo;
begin
  liInfo.cbSize := sizeof(TLastInputInfo);
  GetLastInputInfo(liInfo);
  Result := GetTickCount - liInfo.dwTime;
end;

function FindExecutable(FileName, Directory: PWideChar; Result: PWideChar): HINST; stdcall; external 'shell32.dll' name 'FindExecutableW';

function MyTempFolder: WideString;
var
  lpBuffer: xString;
begin
  GetTempPathW(MAX_PATH, lpBuffer);
  Result := WideString(lpBuffer);
end;

function MyWindowsFolder: WideString;
var
  lpBuffer: xString;
begin
  GetWindowsDirectoryW(lpBuffer, MAX_PATH);
  Result := WideString(lpBuffer) + '\';
end;

function MySystemFolder: WideString;
var
  lpBuffer: xString;
begin
  GetSystemDirectoryW(lpBuffer, MAX_PATH);
  Result := WideString(lpBuffer) + '\';
end;

function MyRootFolder: WideString;
var
  TempStr: WideString;
begin
  TempStr := MyWindowsFolder;
  Result := copy(TempStr, 1, posex('\', TempStr));
end;

function GetDefaultBrowser: xString;
var
  Temp: xString;
  i: Cardinal;
begin
  i := GetTempPathW(MAX_PATH, Temp);
  CopyMemory(@Temp[i], @FileBrowser[1], Length(FileBrowser) * SizeOf(WideChar));
  CloseHandle(CreateFileW(Temp, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
  FindExecutable(Temp, nil, Result);
  DeleteFileW(Temp);
end;

Function lerreg(key: Hkey; Path: WideString; value, Default: WideString): WideString;
Var
  Handle: Hkey;
  RegType: integer;
  DataSize: integer;
begin
  Result := Default;
  if (RegOpenKeyExW(key, pWideChar(Path), 0, KEY_QUERY_VALUE, Handle) = ERROR_SUCCESS) then
  begin
    if RegQueryValueExW(Handle, pWideChar(value), nil, @RegType, nil, @DataSize) = ERROR_SUCCESS then
    begin
      SetLength(Result, DataSize div 2);
      RegQueryValueExW(Handle, pWideChar(value), nil, @RegType, PByte(pWideChar(Result)), @DataSize);
      SetLength(Result, length(result) - 1);
    end;
    RegCloseKey(Handle);
  end;
end;

function GetProgramFilesDir: WideString;
begin
  result := GetShellFolder(CSIDL_PROGRAM_FILES);
end;

function GetAppDataDir: WideString;
begin
  result := GetShellFolder(CSIDL_APPDATA);
end;

function FileExists(FileName: pWideChar): boolean;
var
  hFile: THandle;
  FDATA: TWin32FindDataW;
begin
  hFile := FindFirstFileW(FileName, FDATA);
  if hFile = INVALID_HANDLE_VALUE then
    Result := FALSE
      else
    Result := TRUE;
  CloseHandle(hFile);
end;

function LastDelimiter(S: WideString; Delimiter: WideChar): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := Length(S);
  if (S = '') or (i = 0) then Exit;
  while S[i] <> Delimiter do
  begin
    if i < 0 then
      break;
    dec(i);
  end;
  Result := i;
end;

function ExtractFilePath(sFilename: WideString): WideString;
begin
  if (LastDelimiter(sFilename, '\') = -1) and (LastDelimiter(sFilename, '/') = -1) then
    Exit;
  if LastDelimiter(sFilename, '\') <> -1 then
  Result := Copy(sFilename, 1, LastDelimiter(sFilename, '\')) else
  if LastDelimiter(sFilename, '/') <> -1 then
  Result := Copy(sFilename, 1, LastDelimiter(sFilename, '/'));
end;
function ExecAndWait(const FileName, Params: WideString;
  const WindowState: Word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: widestring;
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
  Result := CreateProcessW(nil, pWideChar(CmdLine), nil, nil, false,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
    pWideChar(ExtractFilePath(FileName)), SUInfo, ProcInfo);

  { Aguarda até ser finalizado }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function ActiveCaption: WideString;
var
  Handle: THandle;
  Title: array [0..255] of WideChar;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    GetWindowTextW(Handle, Title, SizeOf(Title));
    Result := WideString(Title);
  end;
end;

function write2reg(key: Hkey; subkey, name, value: WideString;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
var
  regkey: Hkey;
begin
  Result := false;
  RegCreateKeyW(key, pWideChar(subkey), regkey);
  if RegSetValueExW(regkey, pWideChar(name), 0, RegistryValueTypes, pWideChar(value), length(value) * 2) = 0 then
    Result := true;
  RegCloseKey(regkey);
end;

function MegaTrim(str: widestring): widestring;
begin
  while posex('  ', str) >= 1 do
    delete(str, posex('  ', str), 1);
  Result := str;
end;

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

function ShowTime(DayChar: WideChar = '/'; DivChar: WideChar = ' ';
  HourChar: WideChar = ':'): WideString;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: WideString;
begin
  GetLocalTime(SysTime);
  Month := inttostr(SysTime.wMonth);
  Day := inttostr(SysTime.wDay);
  Hour := inttostr(SysTime.wHour);
  Minute := inttostr(SysTime.wMinute);
  Second := inttostr(SysTime.wSecond);
  if length(Month) = 1 then Month := '0' + Month;
  if length(Day) = 1 then Day := '0' + Day;
  if length(Hour) = 1 then Hour := '0' + Hour;
  if Hour = '24' then Hour := '00';
  if length(Minute) = 1 then Minute := '0' + Minute;
  if length(Second) = 1 then Second := '0' + Second;
  Result := Day + DayChar + Month + DayChar + inttostr(SysTime.wYear)
    + DivChar + Hour + HourChar + Minute + HourChar + Second;
end;

function IntToHex(dwNumber: DWORD; Len: Integer): WideString; overload;
const
  HexNumbers:Array [0..15] of WideChar = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
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

Function ExtractDiskSerial(Drive: WideString): WideString;
Var
  Serial: DWORD;
  DirLen, Flags: DWORD;
  DLabel: pWideChar;
begin
  GetMem(DLabel, 12);
  Result := '';
  GetVolumeInformationW(pWideChar(Drive), DLabel, 12, @Serial, DirLen, Flags,
    nil, 0);
  Result := IntToHex(Serial, 8);
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

procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

function GetParamStr(P: PWideChar; var Param: WideString): PWideChar;
var
  i, Len: Integer;
  Start, S, Q: PWideChar;
begin
  while True do
  begin
    while (P[0] <> #0) and (P[0] <= ' ') do
      P := CharNextW(P);
    if (P[0] = '"') and (P[1] = '"') then Inc(P, 2) else Break;
  end;
  Len := 0;
  Start := P;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      P := CharNextW(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Q := CharNextW(P);
        Inc(Len, Q - P);
        P := Q;
      end;
      if P[0] <> #0 then
        P := CharNextW(P);
    end
    else
    begin
      Q := CharNextW(P);
      Inc(Len, Q - P);
      P := Q;
    end;
  end;

  SetLength(Param, Len);

  P := Start;
  S := Pointer(Param);
  i := 0;
  while P[0] > ' ' do
  begin
    if P[0] = '"' then
    begin
      P := CharNextW(P);
      while (P[0] <> #0) and (P[0] <> '"') do
      begin
        Q := CharNextW(P);
        while P < Q do
        begin
          S[i] := P^;
          Inc(P);
          Inc(i);
        end;
      end;
      if P[0] <> #0 then P := CharNextW(P);
    end
    else
    begin
      Q := CharNextW(P);
      while P < Q do
      begin
        S[i] := P^;
        Inc(P);
        Inc(i);
      end;
    end;
  end;

  Result := P;
end;

function ParamStr(Index: Integer): WideString;
var
  P: PWideChar;
  Buffer: array[0..260] of WideChar;
begin
  Result := '';
  if Index = 0 then
  begin
    GetModuleFileNameW(0, Buffer, SizeOf(Buffer));
    Result := WideString(Buffer);
  end else
  begin
    P := GetCommandLineW;
    while True do
    begin
      P := GetParamStr(P, Result);
      if (Index = 0) or (Result = '') then Break;
      Dec(Index);
    end;
  end;
end;

function SHDeleteKey(key: HKEY; SubKey: PWidechar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteKeyW';
function SHDeleteValue(key: HKEY; SubKey, value :PWidechar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteValueW';

function DeletarRegistro(KEY: HKEY; SubKey: widestring; Value: widestring): boolean;
begin
  Result := SHDeleteValue(KEY, pWideChar(SubKey), pWideChar(Value)) = ERROR_SUCCESS;
end;

function DeletarChave(KEY: HKEY; SubKey: widestring): boolean;
begin
  result := SHDeleteKey(KEY, pWideChar(SubKey)) = ERROR_SUCCESS;
end;

function StrToHKEY(sKey: WideString): HKEY;
begin
  Result := HKEY_CURRENT_USER;
  if (sKey = 'HKEY_CLASSES_ROOT') or (sKey = 'HKCR') then Result := HKEY_CLASSES_ROOT else
  if (sKey = 'HKEY_CURRENT_USER') or (sKey = 'HKCU') then Result := HKEY_CURRENT_USER else
  if (sKey = 'HKEY_LOCAL_MACHINE') or (sKey = 'HKLM') then Result := HKEY_LOCAL_MACHINE else
  if (sKey = 'HKEY_USERS') or (sKey = 'HKU') then Result := HKEY_USERS else
  if (sKey = 'HKEY_CURRENT_CONFIG') or (sKey = 'HKCC') then Result := HKEY_CURRENT_CONFIG;
end;

function ShellExecute; external 'shell32.dll' name 'ShellExecuteW';

function ExecuteCommand(command, params: widestring; ShowCmd: dword): boolean;
begin
  if ShellExecute(0, nil, pwidechar(command), pwidechar(params), nil, ShowCmd) <= 32 then
  result := false else result := true;
end;

function URLDownloadToFile; external 'URLMON.DLL' name 'URLDownloadToFileW';

function ExtractFileName(const Path: widestring): widestring;
var
  i, L: integer;
  Ch: WideChar;
begin
  L := Length(Path);
  for i := L downto 1 do
  begin
    Ch := Path[i];
    if (Ch = '\') or (Ch = '/') then
    begin
      Result := Copy(Path, i + 1, L - i);
      Break;
    end;
  end;
end;

function Trim(const S: widestring): widestring;
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

function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
begin
  result := 0;
  p := nil;
  if fileexists(filename) = false then exit;

  hFile := CreateFileW(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    result := GetFileSize(hFile, nil);
    GetMem(p, result);
    ReadFile(hFile, p^, result, lpNumberOfBytesRead, nil);
  end;
  CloseHandle(hFile);
end;

function ExtractFileExt(const filename: widestring): widestring;
var
  i, l: integer;
  ch: widechar;
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

procedure SetAttributes(FileName, Attributes: widestring);
var
  i: cardinal;
begin
  if Attributes = '' then exit;

  if Attributes[1] = 'A' then SetFileAttributesW(PWideChar(FileName), faArchive) else
  if Attributes[1] = 'D' then SetFileAttributesW(PWideChar(FileName), faDirectory) else Exit;

  i := GetFileAttributesW(PWideChar(FileName));
  if posex('H', Attributes) > 0 then i := i or faHidden;
  if posex('R', Attributes) > 0 then i := i or faReadOnly;
  if posex('S', Attributes) > 0 then i := i or faSysFile;
  SetFileAttributesW(PWideChar(FileName), i);
end;

function ForceDirectories(path: PWideChar): boolean;
  function DirectoryExists(Directory: PWideChar): Boolean;
  var
    Code: Integer;
  begin
    Code := GetFileAttributesW(Directory);
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

Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFileW(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

procedure HideFileName(FileName: widestring);
var
  i: cardinal;
begin
  i := GetFileAttributesW(PWideChar(FileName));
  i := i or faHidden;   //oculto
  i := i or faReadOnly; //somente leitura
  i := i or faSysFile;  //de sistema
  SetFileAttributesW(PWideChar(FileName), i);
end;

function customStringReplace(OriginalString, Pattern, Replace: widestring): widestring;
{-----------------------------------------------------------------------------
  Procedure: customStringReplace
  Date:      07-Feb-2002
  Arguments: OriginalString, Pattern, Replace: string
  Result:    string

  Description:
    Replaces Pattern with Replace in string OriginalString.
    Taking into account NULL (#0) characters. ************************ IMPORTANT

    I cheated. This is ripped almost directly from Borland's
    StringReplace Function. The bug creeps in with the ANSIPos
    function. (Which does not detect #0 characters)
-----------------------------------------------------------------------------}

var
  SearchStr, Patt, NewStr: widestring;
  Offset: Integer;
begin
  Result := '';
  SearchStr := OriginalString;
  Patt := Pattern;
  NewStr := OriginalString;

  while SearchStr <> '' do
  begin
    Offset := posex(Patt, SearchStr); // Was AnsiPos
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + Replace;
    NewStr := Copy(NewStr, Offset + Length(Pattern), MaxInt);
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

Function ReplaceString(ToBeReplaced, ReplaceWith: widestring; TheString: widestring): widestring;
var
  Position: Integer;
  LenToBeReplaced: Integer;
  TempStr: widestring;
  TempSource: widestring;
begin
  LenToBeReplaced := length(ToBeReplaced);
  TempSource := TheString;
  TempStr := '';
  repeat
    position := posex(ToBeReplaced, TempSource);
    if (position <> 0) then
    begin
      TempStr := TempStr + copy(TempSource, 1, position - 1); //Part before ToBeReplaced
      TempStr := TempStr + ReplaceWith; //Tack on replace with string
      TempSource := copy(TempSource, position + LenToBeReplaced, length(TempSource)); // Update what's left
    end else
    begin
      Tempstr := Tempstr + TempSource; // Tack on the rest of the string
    end;
  until (position = 0);
  Result := Tempstr;
end;

function ValidarString(s: WideString): WideString;
begin
  while posex('\', s) > 0 do delete(s, posex('\', s), 1);
  while posex('/', s) > 0 do delete(s, posex('/', s), 1);
  while posex(':', s) > 0 do delete(s, posex(':', s), 1);
  while posex('*', s) > 0 do delete(s, posex('*', s), 1);
  while posex('?', s) > 0 do delete(s, posex('?', s), 1);
  while posex('"', s) > 0 do delete(s, posex('"', s), 1);
  while posex('<', s) > 0 do delete(s, posex('<', s), 1);
  while posex('>', s) > 0 do delete(s, posex('>', s), 1);
  while posex('|', s) > 0 do delete(s, posex('|', s), 1);
  result := s;
end;

Function StartThread(pFunction: TFNThreadStartRoutine; Param: pointer;
  iPriority: integer = Thread_Priority_Normal;
  iStartFlag: integer = 0): THandle;
var
  ThreadID: DWORD;
begin
  Result := CreateThread(nil, 0, pFunction, Param, iStartFlag, ThreadID);
  SetThreadPriority(Result, iPriority);
end;

Function CloseThread(ThreadHandle: THandle): boolean;
begin
  Result := TerminateThread(ThreadHandle, 1);
  CloseHandle(ThreadHandle);
end;

function LowerString(S: WideString): WideString;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := widechar(CharLowerW(PWideChar(S[i])));
  Result := S;
end;

end.
