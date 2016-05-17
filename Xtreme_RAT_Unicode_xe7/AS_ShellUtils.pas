unit AS_ShellUtils;

{
  Arisesoft Shell Pack
  Copyright (c) 1996-2001 Arisesoft
  For conditions of distribution and use, see LICENSE.

  Shell Utilities
}

{$I AS_Ver.inc}

interface

uses
  Windows, ShlObj, ActiveX, CommCtrl;

{ Additional registry entries available in shell version at least 4.7 for
  special paths are kept in: }

{$IFNDEF AS_VCL4}
const
{$IFDEF VER110}
{$EXTERNALSYM CSIDL_INTERNET}
  CSIDL_INTERNET = $0001;
{$EXTERNALSYM CSIDL_ALTSTARTUP}
  CSIDL_ALTSTARTUP = $001D;
{$EXTERNALSYM CSIDL_COMMON_ALTSTARTUP}
  CSIDL_COMMON_ALTSTARTUP = $001E;
{$EXTERNALSYM CSIDL_COMMON_FAVORITES}
  CSIDL_COMMON_FAVORITES = $001F;
{$EXTERNALSYM CSIDL_INTERNET_CACHE}
  CSIDL_INTERNET_CACHE = $0020;
{$EXTERNALSYM CSIDL_COOKIES}
  CSIDL_COOKIES = $0021;
{$EXTERNALSYM CSIDL_HISTORY}
  CSIDL_HISTORY = $0022;
{$ELSE}
  CSIDL_INTERNET = $0001;
  CSIDL_ALTSTARTUP = $001D;
  CSIDL_COMMON_ALTSTARTUP = $001E;
  CSIDL_COMMON_FAVORITES = $001F;
  CSIDL_INTERNET_CACHE = $0020;
  CSIDL_COOKIES = $0021;
  CSIDL_HISTORY = $0022;
{$ENDIF}
{$ENDIF}

const
{$EXTERNALSYM SHGFI_ATTR_SPECIFIED}
  SHGFI_ATTR_SPECIFIED = $000020000;

  { Initialized interfaces variables }

var
  ShellMalloc: IMalloc;
  DesktopFolder: IShellFolder;

  { Low level manipulation by PIDLs }

type
  TRootSpecial = (
    rsDesktop,
    rsInternet,
    rsPrograms,
    rsControls,
    rsPrinters,
    rsPersonal,
    rsFavorites,
    rsStartUp,
    rsRecent,
    rsSendTo,
    rsBitBucket,
    rsStartMenu,
    rsMusic,
    rsVideo,
    rsDesktopDirectory,
    rsNetHood,
    rsFonts,
    rsCommonStartMenu,
    rsCommonPrograms,
    rsCommonStartUp,
    rsCommonDesktopDirectory,
    rsAppData,
    rsPrintHood,
    rsLocalAppData,
    rsCommonAppdata,
    rsWindows,
    rsSystem,
    rsProgramFiles,
    rsCommonDocuments,
    rsCommonMusic,
    rsCommonPictures,
    rsCommonVideos,
    rsCommonFavorites,
    rsInternetCache,
    rsCookies,
    rsHistory);

function CreateSpecialPIDL(RootSpecial: TRootSpecial): PItemIDList;
function GetSpecialFolderPath(RootSpecial: TRootSpecial): string;
function GetSpecialIcon(RootSpecial: TRootSpecial; Large: Boolean): HICON;
function CreatePIDL(Size: Integer): PItemIDList;
function PathToPIDL(const Path: WideString): PItemIDList;
procedure FreePIDL(PIDL: PItemIDList);
function NextPIDL(PIDL: PItemIDList): PItemIDList;
function LastPIDL(PIDL: PItemIDList): PItemIDList;
function GetPIDLSize(PIDL: PItemIDList): Integer;
function GetPIDLCount(PIDL: PItemIDList): Integer;
function SamePIDL(PIDL1, PIDL2: PItemIDList): Boolean;
function CopyPIDL(PIDL: PItemIDList): PItemIDList;
function CopyFirstPIDL(PIDL: PItemIDList): PItemIDList;
function ConcatPIDLs(PIDL1, PIDL2: PItemIDList): PItemIDList;
function PIDLToString(PIDL: PItemIDList): string;
function StringToPIDL(const Value: string): PItemIDList;
function GetPIDLNameForAddressBar(PIDL: PItemIDList): string;
function GetPIDLDisplayName(PIDL: PItemIDList): string;
function GetPIDLPath(PIDL: PItemIDList): string;
function GetPIDLTypeName(PIDL: PItemIDList): string;
function GetPIDLImage(PIDL: PItemIDList; Large, Open: Boolean): Integer;
function GetPIDLIcon(PIDL: PItemIDList; Large: Boolean): HICON;
function GetPIDLAttributes(PIDL: PItemIDList; Specified: Cardinal = 0): Cardinal;
function HasPIDLAttributes(PIDL: PItemIDList; Attributes: Cardinal): Boolean;
procedure StripPIDL(PIDL: PItemIDList; NewCount: Integer);
procedure StripLastPIDL(PIDL: PItemIDList);
procedure ReducePIDLToFolder(PIDL: PItemIDList);
function IsChildPIDL(RootPIDL, PIDL: PItemIDList): Boolean;
function IsDesktopPIDL(PIDL: PItemIDList): Boolean;
function IsFileSystemPIDL(PIDL: PItemIDList): Boolean;

function GetSystemImageListHandle(Large: Boolean): HIMAGELIST;

function ShellExecuteCommand(const Operation: string; const FileName: string): Boolean;
function ShellExecutePIDL(PIDL: PItemIDList): Boolean;

{ Other stuff }

procedure CreateShellLink(const FileName, ShortcutTo,
  WorkingDir, Parameters, IconFileName: string; IconIndex: Integer);
function GetAssociatedIcon(const FileName: string): HICON;
function ExtractShellIcon(Index: Integer; Large: Boolean): HICON;
function PathAddBackSlash(const Path: string): string;
function PathRemoveBackSlash(const Path: string): string;
function GetFileTypeName(const Ext: string): string;
function StrRetToString(PIDL: PItemIDList; const StrRet: TStrRet): string;
function ValueInFlags(Value, Flags: Cardinal): Boolean;
function GetModule(const Name: string): THandle;
function GetStrFromModule(Module: THandle; ResIdentifier: LongInt): string;

{$IFDEF AS_VCL35}
{$EXTERNALSYM StrFormatByteSizeA}
function StrFormatByteSizeA(dw: DWORD; pszBuf: PAnsiChar; cchBuf: UINT): PAnsiChar; stdcall;
{$EXTERNALSYM StrFormatByteSizeW}
function StrFormatByteSizeW(qdw: LONGLONG; szBuf: PWideChar; uiBufSize: UINT): PWideChar; stdcall;
{$EXTERNALSYM StrFormatByteSize}
function StrFormatByteSize(dw: DWORD; pszBuf: PChar; cchBuf: UINT): PChar; stdcall;
{$ELSE}
function StrFormatByteSizeA(dw: DWORD; pszBuf: PAnsiChar; cchBuf: UINT): PAnsiChar; stdcall;
function StrFormatByteSizeW(qdw: LONGLONG; szBuf: PWideChar; uiBufSize: UINT): PWideChar; stdcall;
function StrFormatByteSize(dw: DWORD; pszBuf: PChar; cchBuf: UINT): PChar; stdcall;
{$ENDIF}

function ByteSizeToFormatStr(ByteSize: LongInt): string;
function ShortPathToLongPath(const FileName: string): string;

type
  SHQUERYRBINFO = record
    cbSize: DWORD;
    i64Size: Int64;
    i64NumItems: Int64;
  end;
  LPSHQUERYRBINFO = ^SHQUERYRBINFO;
  TSHQueryRBInfo = SHQUERYRBINFO;

{$IFDEF AS_VCL35}
{$EXTERNALSYM SHQueryRecycleBinA}
function SHQueryRecycleBinA(pszRootPath: PAnsiChar;
  var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
{$EXTERNALSYM SHQueryRecycleBinW}
function SHQueryRecycleBinW(pszRootPath: PWideChar;
  var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
{$EXTERNALSYM SHQueryRecycleBin}
function SHQueryRecycleBin(pszRootPath: PChar;
  var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
{$ELSE}
function SHQueryRecycleBinA(pszRootPath: PAnsiChar;
  var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
function SHQueryRecycleBinW(pszRootPath: PWideChar;
  var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
function SHQueryRecycleBin(pszRootPath: PChar;
  var pSHQueryRBInfo: TSHQueryRBInfo): HResult; stdcall;
{$ENDIF}

{$IFDEF AS_VCL35}
{$EXTERNALSYM SHEmptyRecycleBinA}
function SHEmptyRecycleBinA(hWnd: HWND;
  pszRootPath: PAnsiChar; dwFlags: DWORD): HResult; stdcall;
{$EXTERNALSYM SHEmptyRecycleBinW}
function SHEmptyRecycleBinW(hWnd: HWND;
  pszRootPath: PWideChar; dwFlags: DWORD): HResult; stdcall;
{$EXTERNALSYM SHEmptyRecycleBin}
function SHEmptyRecycleBin(hWnd: HWND;
  pszRootPath: PChar; dwFlags: DWORD): HResult; stdcall;
{$ELSE}
function SHEmptyRecycleBinA(hWnd: HWND;
  pszRootPath: PAnsiChar; dwFlags: DWORD): HResult; stdcall;
function SHEmptyRecycleBinW(hWnd: HWND;
  pszRootPath: PWideChar; dwFlags: DWORD): HResult; stdcall;
function SHEmptyRecycleBin(hWnd: HWND;
  pszRootPath: PChar; dwFlags: DWORD): HResult; stdcall;
{$ENDIF}

{ Hints from library Shell32 }

function GetShellString(ResIdentifier: LongInt): string;

implementation

uses
  Forms, ShellAPI, SysUtils, ComObj, Consts;

var
  DesktopPIDL: PItemIDList;

function GetDesktopPIDL: PItemIDList;
begin
  if DesktopPIDL = nil then
    DesktopPIDL := CreateSpecialPIDL(rsDesktop);
  Result := DesktopPIDL;
end;

function CreateSpecialPIDL(RootSpecial: TRootSpecial): PItemIDList;
const
  RootSpecials: array[TRootSpecial] of Integer = (
    CSIDL_DESKTOP,
    CSIDL_INTERNET,
    CSIDL_PROGRAMS,
    CSIDL_CONTROLS,
    CSIDL_PRINTERS,
    CSIDL_PERSONAL,
    CSIDL_FAVORITES,
    CSIDL_STARTUP,
    CSIDL_RECENT,
    CSIDL_SENDTO,
    CSIDL_BITBUCKET,
    CSIDL_STARTMENU,
    CSIDL_MYMUSIC,
    CSIDL_MYVIDEO,  // <--- problema no XP (cliente)
    CSIDL_DESKTOPDIRECTORY,
    CSIDL_NETHOOD,
    CSIDL_FONTS,
    CSIDL_COMMON_STARTMENU,
    CSIDL_COMMON_PROGRAMS,
    CSIDL_COMMON_STARTUP,
    CSIDL_COMMON_DESKTOPDIRECTORY,
    CSIDL_APPDATA,
    CSIDL_PRINTHOOD,
    CSIDL_LOCAL_APPDATA,
    CSIDL_COMMON_APPDATA,
    CSIDL_WINDOWS,
    CSIDL_SYSTEM,
    CSIDL_PROGRAM_FILES,
    CSIDL_COMMON_DOCUMENTS,  // <--- problema no XP (cliente)
    CSIDL_COMMON_MUSIC,
    CSIDL_COMMON_PICTURES,
    CSIDL_COMMON_VIDEO,
    CSIDL_COMMON_FAVORITES,
    CSIDL_INTERNET_CACHE,
    CSIDL_COOKIES,
    CSIDL_HISTORY);
begin
  OLECheck(SHGetSpecialFolderLocation(0, RootSpecials[RootSpecial], Result));
end;

function GetSpecialFolderPath(RootSpecial: TRootSpecial): string;
var
  PIDL: PItemIDList;
begin
  PIDL := CreateSpecialPIDL(RootSpecial);
  Result := GetPIDLPath(PIDL);
  FreePIDL(PIDL);
end;

function GetSpecialIcon(RootSpecial: TRootSpecial; Large: Boolean): HICON;
var
  PIDL: PItemIDList;
begin
  PIDL := CreateSpecialPIDL(RootSpecial);
  Result := GetPIDLIcon(PIDL, Large);
  FreePIDL(PIDL);
end;

function PathToPIDL(const Path: WideString): PItemIDList;
var
  Eaten, Attributes: Cardinal;
begin
  Attributes := 0;
  OLECheck(DesktopFolder.ParseDisplayName(0, nil,
    POleStr(Path), Eaten, Result, Attributes));
end;

function CreatePIDL(Size: Integer): PItemIDList;
begin
  try
    Result := nil;
    Result := ShellMalloc.Alloc(Size);
    if Assigned(Result) then
      FillChar(Result^, Size, 0);
  finally
  end;
end;

procedure FreePIDL(PIDL: PItemIDList);
begin
  if PIDL <> nil then
    ShellMalloc.Free(PIDL);
end;

function NextPIDL(PIDL: PItemIDList): PItemIDList;
begin
  Result := PIDL;
  Inc(PChar(Result), PIDL^.mkid.cb);
end;

function LastPIDL(PIDL: PItemIDList): PItemIDList;
begin
  repeat
    Result := PIDL;
    PIDL := NextPIDL(Result);
  until PIDL^.mkid.cb = 0;
end;

function GetPIDLSize(PIDL: PItemIDList): Integer;
begin
  Result := 0;
  if Assigned(PIDL) then
  begin
    Result := SizeOf(PIDL^.mkid.cb);
    while PIDL^.mkid.cb <> 0 do
    begin
      Result := Result + PIDL^.mkid.cb;
      PIDL := NextPIDL(PIDL);
    end;
  end;
end;

function GetPIDLCount(PIDL: PItemIDList): Integer;
begin
  Result := 0;
  if Assigned(PIDL) then
    while PIDL^.mkid.cb <> 0 do
    begin
      Inc(Result);
      PIDL := NextPIDL(PIDL);
    end;
end;

function SamePIDL(PIDL1, PIDL2: PItemIDList): Boolean;
begin
  if Assigned(PIDL1) and Assigned(PIDL2) then
    Result := DesktopFolder.CompareIDs(0, PIDL1, PIDL2) = 0
  else
    Result := (PIDL1 = nil) and (PIDL2 = nil);
end;

function CopyPIDL(PIDL: PItemIDList): PItemIDList;
var
  cb: Integer;
begin
  if Assigned(PIDL) then
  begin
    cb := GetPIDLSize(PIDL);
    Result := CreatePIDL(cb);
    CopyMemory(PChar(Result), PIDL, cb);
  end
  else
    Result := nil;
end;

function CopyFirstPIDL(PIDL: PItemIDList): PItemIDList;
var
  cb: Integer;
begin
  if Assigned(PIDL) then
  begin
    cb := PIDL^.mkid.cb;
    Result := CreatePIDL(cb + SizeOf(PIDL^.mkid.cb));
    CopyMemory(PChar(Result), PIDL, cb);
  end
  else
    Result := nil;
end;

function ConcatPIDLs(PIDL1, PIDL2: PItemIDList): PItemIDList;
var
  cb1, cb2: Integer;
begin
  if Assigned(PIDL1) then
    cb1 := GetPIDLSize(PIDL1) - SizeOf(PIDL1^.mkid.cb)
  else
    cb1 := 0;

  cb2 := GetPIDLSize(PIDL2);

  Result := CreatePIDL(cb1 + cb2);
  if Assigned(Result) then
  begin
    if Assigned(PIDL1) then
      CopyMemory(PChar(Result), PIDL1, cb1);
    CopyMemory(PChar(Result) + cb1, PIDL2, cb2);
  end;
end;

function PIDLToString(PIDL: PItemIDList): string;
var
  Len, I: Integer;
  S: string;
begin
  Result := '';
  if PIDL^.mkid.cb = 0 then
    Exit;
  Len := GetPIDLSize(PIDL);
  SetLength(S, Len);
  Move(PIDL^, PChar(S)^, Len);
  for I := 1 to Len do
    Result := Result + '#' + IntToStr(Ord(S[I]));
end;

function StringToPIDL(const Value: string): PItemIDList;
var
  I, Start, Count: Integer;
  S: string;
begin
  if Value = '' then
    Result := CreateSpecialPIDL(rsDesktop)
  else
  begin
    Start := 0;
    Count := 0;
    for I := 1 to Length(Value) do
      if (Value[I] = '#') then
        Inc(Count);
    SetLength(S, Count);
    Count := 1;
    for I := 1 to Length(Value) do
      if (Value[I] = '#') then
      begin
        if Start > 0 then
        begin
          S[Count] := Chr(StrToInt(Copy(Value, Start + 1, I - Start - 1)));
          Inc(Count);
        end;
        Start := I;
      end;
    S[Length(S)] := Chr(StrToInt(Copy(Value, Start + 1, Length(Value) - Start)));
    try
      Result := nil;
      Result := ShellMalloc.Alloc(Length(S));
      if Assigned(Result) then
        Move(PChar(S)^, Result^, Length(S));
    finally
    end;
  end;
end;

function GetPIDLNameForAddressBar(PIDL: PItemIDList): string;
var
  Flags: Cardinal;
  StrRet: TStrRet;
begin
  Flags := SHGDN_FORPARSING or SHGDN_FORADDRESSBAR;
  OLECheck(DesktopFolder.GetDisplayNameOf(PIDL, Flags, StrRet));
  Result := StrRetToString(PIDL, StrRet);
end;

function GetPIDLDisplayName(PIDL: PItemIDList): string;
var
  FileInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_PIDL or SHGFI_DISPLAYNAME);
  Result := FileInfo.szDisplayName;
end;

function GetPIDLPath(PIDL: PItemIDList): string;
var
  Buffer: array[0..MAX_PATH - 1] of Char;
begin
  if SHGetPathFromIDList(PIDL, Buffer) then
    Result := Buffer
  else
    Result := '';
end;

function GetPIDLTypeName(PIDL: PItemIDList): string;
var
  FileInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_PIDL or SHGFI_TYPENAME);
  Result := FileInfo.szTypeName;
end;

function GetPIDLImage(PIDL: PItemIDList; Large, Open: Boolean): Integer;
const
  IOpen: array[Boolean] of Integer = (0, SHGFI_OPENICON);
  ILarge: array[Boolean] of Integer = (SHGFI_SMALLICON, SHGFI_LARGEICON);
var
  FileInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo), SHGFI_PIDL or
    SHGFI_SYSICONINDEX or ILarge[Large] or IOpen[Open]);
  Result := FileInfo.iIcon;
end;

function GetPIDLIcon(PIDL: PItemIDList; Large: Boolean): HICON;
const
  ILarge: array[Boolean] of Integer = (SHGFI_SMALLICON, SHGFI_LARGEICON);
var
  FileInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_PIDL or SHGFI_ICON or ILarge[Large]);
  Result := FileInfo.hIcon;
end;

function GetPIDLAttributes(PIDL: PItemIDList; Specified: Cardinal): Cardinal;
const
  ISpecified: array[Boolean] of Integer = (0, SHGFI_ATTR_SPECIFIED);
var
  FileInfo: TSHFileInfo;
begin
  FileInfo.dwAttributes := Specified;
  SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_PIDL or SHGFI_ATTRIBUTES or ISpecified[Specified <> 0]);
  Result := FileInfo.dwAttributes;
end;

function HasPIDLAttributes(PIDL: PItemIDList; Attributes: Cardinal): Boolean;
begin
  Result := ValueInFlags(Attributes, GetPIDLAttributes(PIDL, Attributes));
end;

procedure StripPIDL(PIDL: PItemIDList; NewCount: Integer);
var
  Result: PItemIDList;
begin
  if Assigned(PIDL) then
  begin
    repeat
      Result := PIDL;
      PIDL := NextPIDL(Result);
      Dec(NewCount);
    until (NewCount < 0) or (PIDL^.mkid.cb = 0);
    if NewCount < 0 then
      Result^.mkid.cb := 0;
  end;
end;

procedure StripLastPIDL(PIDL: PItemIDList);
begin
  if Assigned(PIDL) then
    LastPIDL(PIDL)^.mkid.cb := 0;
end;

procedure ReducePIDLToFolder(PIDL: PItemIDList);
begin
  if Assigned(PIDL) then
    while (PIDL^.mkid.cb <> 0) and
      not HasPIDLAttributes(PIDL, SFGAO_FOLDER) do
      StripLastPIDL(PIDL);
end;

function IsChildPIDL(RootPIDL, PIDL: PItemIDList): Boolean;
var
  TestPIDL: PItemIDList;
begin
  if Assigned(RootPIDL) and Assigned(PIDL) then
  begin
    TestPIDL := CopyPIDL(PIDL);
    try
      StripPIDL(TestPIDL, GetPIDLCount(RootPIDL));
      Result := SamePIDL(TestPIDL, RootPIDL);
    finally
      FreePIDL(TestPIDL);
    end;
  end
  else
    Result := False;
end;

function IsDesktopPIDL(PIDL: PItemIDList): Boolean;
begin
  Result := SamePIDL(GetDesktopPIDL, PIDL);
end;

function IsFileSystemPIDL(PIDL: PItemIDList): Boolean;
var
  Attributes: Cardinal;
begin
  Attributes := SFGAO_FILESYSTEM;
  if Win32MajorVersion > 4 then
    Attributes := Attributes or SFGAO_FILESYSANCESTOR;
  Result := HasPIDLAttributes(PIDL, Attributes);
end;

function GetSystemImageListHandle(Large: Boolean): HIMAGELIST;
const
  ILarge: array[Boolean] of Integer = (SHGFI_SMALLICON, SHGFI_LARGEICON);
var
  FileInfo: TSHFileInfo;
begin
  Result := SHGetFileInfo(PChar(GetDesktopPIDL), 0, FileInfo, SizeOf(FileInfo),
    SHGFI_PIDL or SHGFI_SYSICONINDEX or ILarge[Large]);
end;

procedure CreateShellLink(const FileName, ShortcutTo,
  WorkingDir, Parameters, IconFileName: string; IconIndex: Integer);
var
  Obj: IUnknown;
  SL: IShellLink;
  PF: IPersistFile;
  WS: WideString;
begin
  Obj := CreateComObject(CLSID_ShellLink);
  SL := Obj as IShellLink;
  SL.SetPath(PChar(ShortcutTo));
  if Parameters <> '' then
    SL.SetArguments(PChar(Parameters));
  if IconFilename <> '' then
    SL.SetIconLocation(PChar(IconFilename), IconIndex);
  if WorkingDir <> '' then
    SL.SetWorkingDirectory(PChar(WorkingDir));
  PF := Obj as IPersistFile;
  WS := Filename;
  PF.Save(POleStr(WS), True);
end;

function GetAssociatedIcon(const FileName: string): HICON;
var
  ID: Word;
begin
  ID := 1;
  Result := ExtractAssociatedIcon(HInstance, PChar(FileName), ID);
end;

function ExtractShellIcon(Index: Integer; Large: Boolean): HICON;
var
  LargeIconHandle, SmallIconHandle: HICON;
begin
  LargeIconHandle := 0;
  SmallIconHandle := 0;
  if ExtractIconEx('shell32.dll', Index,
    LargeIconHandle, SmallIconHandle, 1) = 2 then
  begin
    if Large then
    begin
      Result := LargeIconHandle;
      DestroyIcon(SmallIconHandle);
    end
    else
    begin
      DestroyIcon(LargeIconHandle);
      Result := SmallIconHandle;
    end;
  end
  else
  begin
    DestroyIcon(LargeIconHandle);
    DestroyIcon(SmallIconHandle);
    Result := 0;
  end;
end;

function PathAddBackSlash(const Path: string): string;
var
  Len: Integer;
begin
  Result := Path;
  Len := Length(Path);
  if (Len > 1) and
    ((Path[Len] <> '\') or (ByteType(Path, Len) <> mbSingleByte)) then
    Result := Path + '\';
end;

function PathRemoveBackSlash(const Path: string): string;
var
  Len: Integer;
begin
  Result := Path;
  Len := Length(Path);
  if (Len > 1) and (Path[Len] = '\') and
    (ByteType(Path, Len) = mbSingleByte) then
    Delete(Result, Len, 1);
end;

function GetFileTypeName(const Ext: string): string;
var
  FileInfo: TSHFileInfo;
begin
  SHGetFileInfo(PChar('*.' + Ext), FILE_ATTRIBUTE_NORMAL, FileInfo,
    SizeOf(FileInfo), SHGFI_USEFILEATTRIBUTES or SHGFI_TYPENAME);
  Result := FileInfo.szTypeName;
end;

function ShellExecuteCommand(const Operation: string; const FileName: string): Boolean;
begin
  Result := ShellExecute(Application.Handle, PChar(Operation), PChar(FileName),
    nil, nil, SW_SHOW) > 32;
end;

function ShellExecutePIDL(PIDL: PItemIDList): Boolean;
var
  ShellExecuteInfo: TShellExecuteInfo;
begin
  FillChar(ShellExecuteInfo, SizeOf(ShellExecuteInfo), 0);
  with ShellExecuteInfo do
  begin
    cbSize := SizeOf(ShellExecuteInfo);
    wnd := Application.Handle;
    fMask := SEE_MASK_IDLIST or SEE_MASK_INVOKEIDLIST;
    lpIDList := PIDL;
    nShow := SW_SHOW;
  end;
  Result := ShellExecuteEx(@ShellExecuteInfo);
end;

function StrRetToString(PIDL: PItemIDList; const StrRet: TStrRet): string;
{ note: Windows 2000 has StrRetToStr and StrRetToBuf }
begin
  case StrRet.uType of
    STRRET_WSTR:
      begin
        Result := StrRet.pOleStr;
        ShellMalloc.Free(StrRet.pOleStr);
      end;
    STRRET_OFFSET:
      if Assigned(PIDL) then
        Result := PChar(PIDL) + StrRet.uOffset
      else
        Result := '';
    STRRET_CSTR:
      Result := StrRet.cStr;
  end;
end;

function ValueInFlags(Value, Flags: Cardinal): Boolean;
begin
  Result := (Value <> 0) and ((Flags or Value) = Flags)
end;

function GetModule(const Name: string): THandle;
var
  OldError: LongInt;
begin
  OldError := SetErrorMode(SEM_NOOPENFILEERRORBOX);
  Result := GetModuleHandle(PChar(Name));
  if Result < HINSTANCE_ERROR then
    Result := LoadLibrary(PChar(Name));
  if (Result > 0) and (Result < HINSTANCE_ERROR) then
    Result := 0;
  SetErrorMode(OldError);
end;

function GetStrFromModule(Module: THandle; ResIdentifier: LongInt): string;
var
  Buffer: array[0..200] of Char;
begin
  Buffer[0] := #0;
  LoadString(Module, ResIdentifier, Buffer, SizeOf(Buffer));
  Result := Buffer;
end;

const
  shlwapi = 'shlwapi.dll';

{$IFDEF AS_VCL35}
{$EXTERNALSYM StrFormatByteSizeA}
function StrFormatByteSizeA; external shlwapi name 'StrFormatByteSizeA';
{$EXTERNALSYM StrFormatByteSizeW}
function StrFormatByteSizeW; external shlwapi name 'StrFormatByteSizeW';
{$EXTERNALSYM StrFormatByteSize}
function StrFormatByteSize; external shlwapi name 'StrFormatByteSizeW';
{$ELSE}
function StrFormatByteSizeA; external shlwapi name 'StrFormatByteSizeA';
function StrFormatByteSizeW; external shlwapi name 'StrFormatByteSizeW';
function StrFormatByteSize; external shlwapi name 'StrFormatByteSizeW';
{$ENDIF}

function ByteSizeToFormatStr(ByteSize: LongInt): string;
var
  Buffer: array[0..79] of Char;
begin
  Result := StrFormatByteSize(ByteSize, Buffer, SizeOf(Buffer));
end;

function ShortPathToLongPath(const FileName: string): string;
var
  PIDL: PItemIDList;
begin
  PIDL := PathToPIDL(FileName);
  Result := GetPIDLPath(PIDL);
  FreePIDL(PIDL);
end;

var
  ShellModule: THandle;
const
  ShellDllName = 'shell32.dll';

function GetShellModule: THandle;
begin
  if ShellModule = 0 then
    ShellModule := GetModule(ShellDllName);
  Result := ShellModule;
end;

function GetShellString(ResIdentifier: LongInt): string;
begin
  Result := GetStrFromModule(GetShellModule, ResIdentifier);
end;

{$IFDEF AS_VCL35}
{$EXTERNALSYM SHQueryRecycleBinA}
function SHQueryRecycleBinA; external shell32 name 'SHQueryRecycleBinA';
{$EXTERNALSYM SHQueryRecycleBinW}
function SHQueryRecycleBinW; external shell32 name 'SHQueryRecycleBinW';
{$EXTERNALSYM SHQueryRecycleBin}
function SHQueryRecycleBin; external shell32 name 'SHQueryRecycleBinW';
{$ELSE}
function SHQueryRecycleBinA; external shell32 name 'SHQueryRecycleBinA';
function SHQueryRecycleBinW; external shell32 name 'SHQueryRecycleBinW';
function SHQueryRecycleBin; external shell32 name 'SHQueryRecycleBinW';
{$ENDIF}

{$IFDEF AS_VCL35}
{$EXTERNALSYM SHEmptyRecycleBinA}
function SHEmptyRecycleBinA; external shell32 name 'SHEmptyRecycleBinA';
{$EXTERNALSYM SHEmptyRecycleBinW}
function SHEmptyRecycleBinW; external shell32 name 'SHEmptyRecycleBinW';
{$EXTERNALSYM SHEmptyRecycleBin}
function SHEmptyRecycleBin; external shell32 name 'SHEmptyRecycleBinW';
{$ELSE}
function SHEmptyRecycleBinA; external shell32 name 'SHEmptyRecycleBinA';
function SHEmptyRecycleBinW; external shell32 name 'SHEmptyRecycleBinW';
function SHEmptyRecycleBin; external shell32 name 'SHEmptyRecycleBinW';
{$ENDIF}

initialization
  OLECheck(ShGetMalloc(ShellMalloc));
  OLECheck(SHGetDesktopFolder(DesktopFolder));

finalization
  FreePIDL(DesktopPIDL);
  DesktopFolder := nil;
  ShellMalloc := nil;
  if ShellModule <> 0 then
    FreeLibrary(ShellModule);

end.

