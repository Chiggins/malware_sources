Unit UnitServerUtils;

interface

uses
  windows;

function IntToStr(i: Int64): String;
function StrToInt(S: String): Int64;
function UpperString(S: String): String;
function LowerString(S: String): String;
function ExtractFilename(const path: string): string;
function GetShellFolder(CSIDL: integer): string;
Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
function MyTempFolder: String;
function GetProgramFilesDir: string;
function GetAppDataDir: string;
function FileExists(FileName: String): Boolean;

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

function FileExists(FileName: String): Boolean;
var
  dwAttr: LongWord;
begin
  dwAttr := GetFileAttributes(PChar(FileName));
  result := ((dwAttr and FILE_ATTRIBUTE_DIRECTORY) = 0) and (dwAttr <> $FFFFFFFF);
end;

function GetAppDataDir: string;
begin
  result := GetShellFolder(CSIDL_APPDATA);
end;

function GetProgramFilesDir: string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  valor := 'ProgramFilesDir';
  result := lerreg(HKEY_LOCAL_MACHINE, chave, valor, '');
end;

function MyGetTemp(nBufferLength: DWORD; lpBuffer: PChar): DWORD;
var
  xGetTemp: function(nBufferLength: DWORD; lpBuffer: PChar): DWORD; stdcall;
begin
  xGetTemp := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetTempPathA'));
  Result := xGetTemp(nBufferLength, lpBuffer);
end;

function MyTempFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetTemp(sizeof(lpBuffer), lpBuffer);
  Result := String(lpBuffer);
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

function ExtractFilename(const path: string): string;
var
i, l: integer;
ch: char;

begin
  l := length(path);
  for i := l downto 1 do
  begin
    ch := path[i];
    if (ch = '\') or (ch = '/') then
    begin
      result := copy(path, i + 1, l - i);
      break;
    end;
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

function UpperString(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharUpper(PChar(S[i])));
  Result := S;
end;

function LowerString(S: String): String;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := char(CharLower(PChar(S[i])));
  Result := S;
end;

end.