// ***************************************************************
//  madTools.pas              version:  1.2v  ·  date: 2009-07-14
//  -------------------------------------------------------------
//  several basic tool functions
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2009 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2009-07-14 1.2v added osWin2008, osWin7, osWin2008r2
// 2009-02-09 1.2u (1) Delphi 2009 support
//                 (2) added some unicode function overloads
// 2006-11-28 1.2t (1) limited support for 64bit modules added
//                 (2) "OS" detects Vista, Media Center, x64, etc
// 2005-06-11 1.2s "ResToStr" returns a resource as binary data in a string 
// 2005-02-05 1.2r GetImageNtHeaders avoids inconvenient debugger exceptions
// 2004-03-12 1.2q AMD64 NX: New -> VirtualAlloc (in MethodToProcedure)
// 2003-10-05 1.2p (1) support for Windows 2003 added
//                 (2) OS.enum renamed to OS.Enum -> BCB support
// 2003-06-09 1.2o (1) GetImageProcAddress now handles forwarded APIs correctly
//                 (2) minor bug in GetImageNtHeaders fixed
//                 (3) some other minor bug fixes / improvements
// 2002-12-27 1.2m FindModule + GetImageProcName added
// 2002-11-20 1.2l make OS.description work even after madTools.finalization
// 2002-10-25 1.2k some low level module image parsing functions added
// 2002-09-05 1.2j GetFreeSystemResources now simply returns 0 in NT family
// 2002-06-04 1.2i little NT4 bug workaround, see MsgHandlerWindow
// 2002-04-24 1.2h mutex and window class name now process+module dependent
// 2002-02-24 1.2g MsgHandler is now using mutex instead of critical section
// 2002-02-16 1.2f MsgHandler stuff rewritten, thread safe etc.
// 2001-07-23 1.2e Add/DelMsgHandler now can also work with other threads
// 2001-07-22 1.2d fix for wrong OS information ("setup.exe" on ME)
// 2001-07-15 1.2c new functions added (1) GetFreeSystemResources
//                                     (2) GetFileVersion / FileVersionToStr
// 2001-05-19 1.2b osWinXP added
// 2001-04-10 1.2a TOS.description added
// 2000-11-22 1.2  MsgHandlerWindow (and related) functionality added
// 2000-07-25 1.1a minor changes in order to get rid of SysUtils

unit madTools;

{$I mad.inc}

interface

uses Windows, madTypes;

// ***************************************************************

type
  // types for the "OS" function
  TOsEnum = (osNone, osWin95, osWin95osr2, osWin98, osWin98se, osWinME, osWin9xNew,
                     osWinNtOld, osWinNt4, osWin2k, osWinXP, osWin2003, osWinVista, osWin2008, osWin7, osWin2008r2, osWinNtNew);
  TOS = record
    major       : cardinal;
    minor       : cardinal;
    build       : cardinal;
    spStr       : AnsiString;
    win9x       : boolean;
    win9xEnum   : TOsEnum;//osNone..osWin9xNew;   BCB doesn't like this
    winNt       : boolean;
    winNtEnum   : TOsEnum;
    Enum        : TOsEnum;
    x64         : boolean;
    spNo        : cardinal;
    description : AnsiString;
  end;

const
  // operating system strings
  COsDescr : array [TOsEnum] of PAnsiChar =
             ('None', 'Windows 95', 'Windows 95 OSR-2', 'Windows 98', 'Windows 98 SE',
                         'Windows ME', 'Windows 9x New',
                      'Windows NT 3', 'Windows NT 4', 'Windows 2000', 'Windows XP',
                         'Windows 2003', 'Windows Vista', 'Windows 2008', 'Windows 7', 'Windows 2008 R2', 'Windows NT New');

// Tests which system is running...
function OS : TOS;

// ***************************************************************

// returns the 9x resource usage; 0: System; 1: GDI; 2: User
function GetFreeSystemResources (resource: word) : word;

// ***************************************************************

// returns the short respectively the long variant of the filename
function GetShortFileName (fileName:    AnsiString) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function GetShortFileName (fileName: UnicodeString) : UnicodeString; overload; {$endif}
function GetLongFileName  (fileName:    AnsiString) :    AnsiString; {$ifdef UnicodeOverloads} overload;
function GetLongFileName  (fileName: UnicodeString) : UnicodeString; overload; {$endif}

// ***************************************************************

// returns the version number of a file, can be used on e.g. system dlls
function GetFileVersion   (const file_ :    AnsiString) : int64; {$ifdef UnicodeOverloads} overload;
function GetFileVersion   (const file_ : UnicodeString) : int64; overload; {$endif}
function FileVersionToStr (version : int64 ) : AnsiString;

// ***************************************************************

// converts a procedure/function to a method
function ProcedureToMethod (self     : TObject;
                            procAddr : pointer) : TMethod;

// converts a method to a procedure/function
// CAUTION: this works only for stdcall methods!!
// you should free the procedure pointer (FreeMem), when you don't need it anymore
function MethodToProcedure (self       : TObject;
                            methodAddr : pointer) : pointer; overload;
function MethodToProcedure (method     : TMethod) : pointer; overload;

// ***************************************************************

type
  // types for AddMsgHandler/DelMsgHandler
  TMsgHandler   = procedure (window, msg: cardinal; wParam, lParam: integer; var result: integer);
  TMsgHandlerOO = procedure (window, msg: cardinal; wParam, lParam: integer; var result: integer) of object;

// returns the message handler window handle of the specified thread
// if no such window exists yet (and if threadID = 0) then the window is created
function MsgHandlerWindow (threadID: cardinal = 0) : cardinal;

// add/delete a message handler for the message handler window of the specified thread
function AddMsgHandler (handler: TMsgHandler;   msg: cardinal = 0; threadID: cardinal = 0) : cardinal; overload;
function AddMsgHandler (handler: TMsgHandlerOO; msg: cardinal = 0; threadID: cardinal = 0) : cardinal; overload;
function DelMsgHandler (handler: TMsgHandler;   msg: cardinal = 0; threadID: cardinal = 0) : boolean;  overload;
function DelMsgHandler (handler: TMsgHandlerOO; msg: cardinal = 0; threadID: cardinal = 0) : boolean;  overload;

// ***************************************************************

const
  // PE header constants
  CENEWHDR = $003C;  // offset of new EXE header
  CEMAGIC  = $5A4D;  // old EXE magic id:  'MZ'
  CPEMAGIC = $4550;  // NT portable executable
  {$externalsym IMAGE_NT_OPTIONAL_HDR32_MAGIC}
  {$externalsym IMAGE_NT_OPTIONAL_HDR64_MAGIC}
  IMAGE_NT_OPTIONAL_HDR32_MAGIC = $10b;  // 32bit PE file
  IMAGE_NT_OPTIONAL_HDR64_MAGIC = $20b;  // 64bit PE file

type
  // PE header types
  TImageImportDirectory = packed record
    HintNameArray  : dword;
    TimeDateStamp  : dword;
    ForwarderChain : dword;
    Name_          : dword;
    ThunkArray     : dword;
  end;
  PImageImportDirectory = ^TImageImportDirectory;
  TImageExportDirectory = packed record
    Characteristics       : dword;
    TimeDateStamp         : dword;
    MajorVersion          : word;
    MinorVersion          : word;
    Name_                 : dword;
    Base                  : dword;
    NumberOfFunctions     : integer;
    NumberOfNames         : integer;
    AddressOfFunctions    : dword;
    AddressOfNames        : dword;
    AddressOfNameOrdinals : dword;
  end;
  PImageExportDirectory = ^TImageExportDirectory;

  TImageOptionalHeader64 = packed record
    Magic                       : WORD;
    MajorLinkerVersion          : BYTE;
    MinorLinkerVersion          : BYTE;
    SizeOfCode                  : DWORD;
    SizeOfInitializedData       : DWORD;
    SizeOfUninitializedData     : DWORD;
    AddressOfEntryPoint         : DWORD;
    BaseOfCode                  : DWORD;
    ImageBase                   : int64;
    SectionAlignment            : DWORD;
    FileAlignment               : DWORD;
    MajorOperatingSystemVersion : WORD;
    MinorOperatingSystemVersion : WORD;
    MajorImageVersion           : WORD;
    MinorImageVersion           : WORD;
    MajorSubsystemVersion       : WORD;
    MinorSubsystemVersion       : WORD;
    Win32VersionValue           : DWORD;
    SizeOfImage                 : DWORD;
    SizeOfHeaders               : DWORD;
    CheckSum                    : DWORD;
    Subsystem                   : WORD;
    DllCharacteristics          : WORD;
    SizeOfStackReserve          : int64;
    SizeOfStackCommit           : int64;
    SizeOfHeapReserve           : int64;
    SizeOfHeapCommit            : int64;
    LoaderFlags                 : DWORD;
    NumberOfRvaAndSizes         : DWORD;
    DataDirectory               : array [0..IMAGE_NUMBEROF_DIRECTORY_ENTRIES - 1] of IMAGE_DATA_DIRECTORY;
  end;
  PImageOptionalHeader64 = ^TImageOptionalHeader64;

// find out and return whether the dll file is a 64bit dll
function Is64bitModule (fileName: PWideChar) : bool; stdcall;

// find into which module the specified address belongs (if any)
function FindModule (addr             : pointer;
                     var moduleHandle : dword;
                     var moduleName   : AnsiString) : boolean; {$ifdef UnicodeOverloads} overload;
function FindModule (addr             : pointer;
                     var moduleHandle : dword;
                     var moduleName   : UnicodeString) : boolean; overload; {$endif}

// some low level module image parsing functions
function GetImageNtHeaders       (module: dword) : PImageNtHeaders;
function GetImageImportDirectory (module: dword) : PImageImportDirectory;
function GetImageExportDirectory (module: dword) : PImageExportDirectory;

// most of the time GetImageProcAddress is equal to GetProcAddress, except:
// (1) IAT hooking often hooks GetProcAddress, too, and fakes the result
// (2) in win9x GetProcAddress refuses to work for ordinal kernel32 APIs
function GetImageProcAddress (module: dword; const name : AnsiString; doubleCheck: boolean = false) : pointer; overload;
function GetImageProcAddress (module: dword; index      : integer                                 ) : pointer; overload;

// this is the opposite of Get(Image)ProcAddress
function GetImageProcName (module: dword; proc: pointer; unmangle: boolean) : AnsiString;

// returns a resource as binary data in a string
function ResToStr (module: dword; resType, resName: PAnsiChar) : AnsiString;

// ***************************************************************

// try..except/finally works only if you have SysUtils in your uses clause
// call this function and it works without SysUtils, too
procedure InitTryExceptFinally;

// ***************************************************************

// internal functions, please ignore
function NeedModuleFileMap(module: dword) : pointer;
function Unmangle(var publicName, unitName: AnsiString) : boolean;
function VirtualToRaw(nh: PImageNtHeaders; addr: dword) : dword;
function GetSizeOfImage(nh: PImageNtHeaders) : dword;
function TickDif(tick: dword) : dword;
var CheckProcAddress : function (var addr: pointer) : boolean = nil;
    NeedModuleFileMapEx : function (module: dword) : pointer = nil;

implementation

uses Messages, madStrings;

// ***************************************************************

var os_     : TOS;
    osReady : boolean = false;
function OS : TOS;
const PROCESSOR_ARCHITECTURE_AMD64 = 9;
      VER_NT_WORKSTATION           = 1;
      SM_TABLEPC                   = 86;
      SM_MEDIACENTER               = 87;
      SM_STARTER                   = 88;
      SM_SERVERR2                  = 89;
type TOsVersionInfoExW = packed record
                           dwOSVersionInfoSize : dword;
                           dwMajorVersion      : dword;
                           dwMinorVersion      : dword;
                           dwBuildNumber       : dword;
                           dwPlatformId        : dword;
                           szCSDVersion        : array [0..127] of WideChar;
                           wServicePackMajor   : word;
                           wServicePackMinor   : word;
                           wSuiteMask          : word;
                           wProductType        : byte;
                           wReserved           : byte;
                         end;
var vi   : TOsVersionInfoA;
    viW  : TOsVersionInfoExW;
    i1   : integer;
    gnsi : procedure (var si: TSystemInfo) stdcall;
    si   : TSystemInfo;
begin
  if (not osReady) or (os_.description = '') then begin
    osReady := true;
    if GetVersion and $80000000 = 0 then begin
      ZeroMemory(@viW, sizeOf(viW));
      viW.dwOSVersionInfoSize := sizeOf(TOsVersionInfoExW);
      if not GetVersionExW(POsVersionInfo(@viW)^) then begin
        viW.dwOSVersionInfoSize := sizeOf(TOsVersionInfoW);
        GetVersionExW(POsVersionInfo(@viW)^);
      end;
      Move(viW, vi, sizeOf(vi));
      for i1 := low(vi.szCSDVersion) to high(vi.szCSDVersion) do
        vi.szCSDVersion[i1] := AnsiChar(viW.szCSDVersion[i1]);
    end else begin
      ZeroMemory(@vi, sizeOf(vi));
      vi.dwOSVersionInfoSize := sizeOf(vi);
      GetVersionExA(vi);
    end;
    with os_ do begin
      major := vi.dwMajorVersion;
      minor := vi.dwMinorVersion;
      spStr := vi.szCSDVersion;
      win9x := vi.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS;
      winNt := vi.dwPlatformId = VER_PLATFORM_WIN32_NT;
      if win9x then build := word(vi.dwBuildNumber)
      else          build := vi.dwBuildNumber;
      enum := osNone;
      spNo := 0;
      if win9x then begin
        case major of
          0..3 : ;
          4    : case minor of
                   00..09 : if      build > 1000 then enum := osWin95osr2
                            else                      enum := osWin95;
                   10     : if      build > 2700 then enum := osWinME
                            else if build > 2000 then enum := osWin98se
                            else                      enum := osWin98;
                   11..90 : enum := osWinME;
                   else     enum := osWin9xNew;
                 end;
          else   enum := osWin9xNew;
        end;
        win9xEnum := enum;
        winNtEnum := osNone;
      end else if winNt then begin
        case major of
          0..3 : enum := osWinNtOld;
          4    : enum := osWinNt4;
          5    : case minor of
                   0  : enum := osWin2k;
                   1  : enum := osWinXP;
                   else begin
                          if viW.wProductType = VER_NT_WORKSTATION then
                               enum := osWinXP
                          else enum := osWin2003;
                        end;
                 end;
          6    : case minor of
                   0  : if viW.wProductType = VER_NT_WORKSTATION then
                             enum := osWinVista
                        else enum := osWin2008;
                   1  : if viW.wProductType = VER_NT_WORKSTATION then
                             enum := osWin7
                        else enum := osWin2008r2;
                   else enum := osWinNtNew;
                 end;
          else   enum := osWinNtNew;
        end;
        win9xEnum := osNone;
        winNtEnum := enum;
        if viW.dwOSVersionInfoSize >= sizeOf(TOsVersionInfoExW) then
          spNo := viW.wServicePackMajor
        else
          if Length(spStr) >= 14 then
            spNo := StrToIntEx(false, @spStr[14], Length(spStr) - 13);
        gnsi := GetProcAddress(GetModuleHandle(kernel32), 'GetNativeSystemInfo');
        if @gnsi <> nil then begin
          ZeroMemory(@si, sizeOf(si));
          gnsi(si);
          x64 := si.wProcessorArchitecture = PROCESSOR_ARCHITECTURE_AMD64;
        end;
      end;
      description := COsDescr[enum];
      if winNt then begin
        if GetSystemMetrics(SM_SERVERR2) <> 0 then
          description := description + ' R2';
        if GetSystemMetrics(SM_TABLEPC) <> 0 then
          description := description + ' Tablet PC';
        if GetSystemMetrics(SM_STARTER) <> 0 then
          description := description + ' Starter';
        if (enum < osWinVista) and (GetSystemMetrics(SM_MEDIACENTER) <> 0) then
          description := description + ' Media Center';
        if x64 then
          description := description + ' x64';
        if spStr <> '' then
          description := description + ' ' + spStr;
      end;
    end;
  end;
  result := os_;
end;

// ***************************************************************

//this was nice, but unfortunately doesn't work in BCB:

//function LoadLibrary16    (libraryName : PAnsiChar                 ) : dword;   stdcall; external kernel32 index 35;
//function FreeLibrary16    (hInstance   : dword                     ) : integer; stdcall; external kernel32 index 36;
//function GetProcAddress16 (hinstance   : dword; procName: PAnsiChar) : pointer; stdcall; external kernel32 index 37;

// so we have to do it the hard way:

var LoadLibrary16    : function (libraryName : PAnsiChar                 ) : dword   stdcall = nil;
    FreeLibrary16    : function (hInstance   : dword                     ) : integer stdcall = nil;
    GetProcAddress16 : function (hinstance   : dword; procName: PAnsiChar) : pointer stdcall = nil;

function GetFreeSystemResources(resource: word) : word;
var thunkTrash : string[$3C];
    user16     : dword;
    gfsr       : pointer;
    qtt        : pointer;
    dll        : dword;
begin
  result := 0;
  if GetVersion and $80000000 <> 0 then begin
    if @LoadLibrary16 = nil then begin
      dll := GetModuleHandle(kernel32);
      LoadLibrary16    := GetImageProcAddress(dll, 35);
      FreeLibrary16    := GetImageProcAddress(dll, 36);
      GetProcAddress16 := GetImageProcAddress(dll, 37);
    end;
    if @LoadLibrary16 <> nil then begin
      user16 := LoadLibrary16('user.exe');
      if user16 <> 0 then begin
        thunkTrash := '';
        gfsr := GetProcAddress16(user16, 'GetFreeSystemResources');
        qtt  := GetProcAddress(GetModuleHandle(kernel32), 'QT_Thunk');
        if (gfsr <> nil) and (qtt <> nil) then
          asm
            push resource
            mov edx, gfsr
            call qtt
            mov result, ax
          end;
        FreeLibrary16(user16);
      end;
    end;
  end;
end;

// ***************************************************************

function ExtractFileDrive(const fileName: AnsiString) : AnsiString; {$ifdef UnicodeOverloads} overload; {$endif}
var i1 : integer;
begin
  result := '';
  if Length(fileName) >= 2 then
    if (fileName[1] = '\') and (fileName[2] = '\') then begin
      i1 := PosStr(AnsiString('\'), fileName, 3);
      if (i1 > 0) and (i1 < Length(fileName)) then begin
        i1 := PosStr(AnsiString('\'), fileName, i1 + 1);
        if i1 > 0 then
          result := Copy(fileName, 1, i1)
        else
          result := fileName;
      end;
    end else
      if fileName[2] = ':' then
        result := Copy(fileName, 1, 3);
end;

{$ifdef UnicodeOverloads}
function ExtractFileDrive(const fileName: UnicodeString) : UnicodeString; overload;
var i1 : integer;
begin
  result := '';
  if Length(fileName) >= 2 then
    if (fileName[1] = '\') and (fileName[2] = '\') then begin
      i1 := PosStr('\', fileName, 3);
      if (i1 > 0) and (i1 < Length(fileName)) then begin
        i1 := PosStr('\', fileName, i1 + 1);
        if i1 > 0 then
          result := Copy(fileName, 1, i1)
        else
          result := fileName;
      end;
    end else
      if fileName[2] = ':' then
        result := Copy(fileName, 1, 3);
end;
{$endif}

function GetShortFileName(fileName: AnsiString) : AnsiString;
var c1, c2, c3 : cardinal;
    wfd        : TWin32FindDataA;
begin
  result := '';
  if (fileName <> '') and (fileName[Length(fileName)] = '\') then
    Delete(fileName, Length(fileName), 1);
  c3 := Length(ExtractFileDrive(fileName));
  repeat
    c1 := PosStr(AnsiString('\'), fileName, maxInt, 1);
    if (c3 = 0) or (c1 < c3) then begin
      result := fileName + '\' + result;
      break;
    end;
    if (PosStr(AnsiString('*'), fileName, c1 + 1) = 0) and (PosStr(AnsiString('?'), fileName, c1 + 1) = 0) then begin
      c2 := FindFirstFileA(PAnsiChar(fileName), wfd);
      if c2 <> INVALID_HANDLE_VALUE then begin
        windows.FindClose(c2);
        if wfd.cAlternateFileName[0] <> #0 then
          result := AnsiString(wfd.cAlternateFileName) + '\' + result
        else
          result := AnsiString(wfd.cFileName         ) + '\' + result;
      end else
        result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    end else
      result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    Delete(fileName, c1, maxInt);
  until (c1 = 0) or (fileName = '');
  if (result <> '') and (result[Length(result)] = '\') then
    Delete(result, Length(result), 1);
end;

{$ifdef UnicodeOverloads}
function GetShortFileName(fileName: UnicodeString) : UnicodeString;
var c1, c2, c3 : cardinal;
    wfd        : TWin32FindDataW;
begin
  result := '';
  if GetVersion and $80000000 <> 0 then begin
    result := UnicodeString(GetShortFileName(AnsiString(fileName)));
    exit;
  end;
  if (fileName <> '') and (fileName[Length(fileName)] = '\') then
    Delete(fileName, Length(fileName), 1);
  c3 := Length(ExtractFileDrive(fileName));
  repeat
    c1 := PosStr('\', fileName, maxInt, 1);
    if (c3 = 0) or (c1 < c3) then begin
      result := fileName + '\' + result;
      break;
    end;
    if (PosStr('*', fileName, c1 + 1) = 0) and (PosStr('?', fileName, c1 + 1) = 0) then begin
      c2 := FindFirstFileW(PWideChar(fileName), wfd);
      if c2 <> INVALID_HANDLE_VALUE then begin
        windows.FindClose(c2);
        if wfd.cAlternateFileName[0] <> #0 then
          result := UnicodeString(wfd.cAlternateFileName) + '\' + result
        else
          result := UnicodeString(wfd.cFileName         ) + '\' + result;
      end else
        result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    end else
      result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    Delete(fileName, c1, maxInt);
  until (c1 = 0) or (fileName = '');
  if (result <> '') and (result[Length(result)] = '\') then
    Delete(result, Length(result), 1);
end;
{$endif}

function GetLongFileName(fileName: AnsiString) : AnsiString;
var c1, c2, c3 : cardinal;
    wfd        : TWin32FindDataA;
begin
  result := '';
  if (fileName <> '') and (fileName[Length(fileName)] = '\') then
    Delete(fileName, Length(fileName), 1);
  c3 := Length(ExtractFileDrive(fileName));
  repeat
    c1 := PosStr(AnsiString('\'), fileName, maxInt, 1);
    if (c3 = 0) or (c1 < c3) then begin
      result := fileName + '\' + result;
      break;
    end;
    if (PosStr(AnsiString('~'), fileName, c1 + 1) > 0) and (PosStr(AnsiString('*'), fileName, c1 + 1) = 0) and
       (PosStr(AnsiString('?'), fileName, c1 + 1) = 0) then begin
      c2 := FindFirstFileA(PAnsiChar(fileName), wfd);
      if c2 <> INVALID_HANDLE_VALUE then begin
        windows.FindClose(c2);
        result := AnsiString(wfd.cfileName) + '\' + result;
      end else
        result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    end else
      result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    Delete(fileName, c1, maxInt);
  until (c1 = 0) or (fileName = '');
  if (result <> '') and (result[Length(result)] = '\') then
    Delete(result, Length(result), 1);
end;

{$ifdef UnicodeOverloads}
function GetLongFileName(fileName: UnicodeString) : UnicodeString;
var c1, c2, c3 : cardinal;
    wfd        : TWin32FindDataW;
begin
  result := '';
  if GetVersion and $80000000 <> 0 then begin
    result := UnicodeString(GetLongFileName(AnsiString(fileName)));
    exit;
  end;
  if (fileName <> '') and (fileName[Length(fileName)] = '\') then
    Delete(fileName, Length(fileName), 1);
  c3 := Length(ExtractFileDrive(fileName));
  repeat
    c1 := PosStr('\', fileName, maxInt, 1);
    if (c3 = 0) or (c1 < c3) then begin
      result := fileName + '\' + result;
      break;
    end;
    if (PosStr('~', fileName, c1 + 1) > 0) and (PosStr('*', fileName, c1 + 1) = 0) and
       (PosStr('?', fileName, c1 + 1) = 0) then begin
      c2 := FindFirstFileW(PWideChar(fileName), wfd);
      if c2 <> INVALID_HANDLE_VALUE then begin
        windows.FindClose(c2);
        result := UnicodeString(wfd.cfileName) + '\' + result;
      end else
        result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    end else
      result := Copy(fileName, c1 + 1, maxInt) + '\' + result;
    Delete(fileName, c1, maxInt);
  until (c1 = 0) or (fileName = '');
  if (result <> '') and (result[Length(result)] = '\') then
    Delete(result, Length(result), 1);
end;
{$endif}

// ***************************************************************

function GetFileVersion(const file_: AnsiString) : int64;
var len, hnd : dword;
    buf      : AnsiString;
    pfi      : PVsFixedFileInfo;
begin
  result := 0;
  len := GetFileVersionInfoSizeA(PAnsiChar(file_), hnd);
  if len <> 0 then begin
    SetLength(buf, len);
    if GetFileVersionInfoA(PAnsiChar(file_), hnd, len, pointer(buf)) and
       VerQueryValueA(pointer(buf), '\', pointer(pfi), len) then
      result := int64(pfi^.dwFileVersionMS) shl 32 + int64(pfi^.dwFileVersionLS);
  end;
end;

{$ifdef UnicodeOverloads}
function GetFileVersion(const file_: UnicodeString) : int64;
var len, hnd : dword;
    buf      : AnsiString;
    pfi      : PVsFixedFileInfo;
begin
  result := 0;
  if GetVersion and $80000000 <> 0 then begin
    result := GetFileVersion(AnsiString(file_));
    exit;
  end;
  len := GetFileVersionInfoSizeW(PWideChar(file_), hnd);
  if len <> 0 then begin
    SetLength(buf, len);
    if GetFileVersionInfoW(PWideChar(file_), hnd, len, pointer(buf)) and
       VerQueryValueA(pointer(buf), '\', pointer(pfi), len) then
      result := int64(pfi^.dwFileVersionMS) shl 32 + int64(pfi^.dwFileVersionLS);
  end;
end;
{$endif}

function FileVersionToStr(version: int64) : AnsiString;
begin
  result := IntToStrEx( version shr 48           ) + '.' +
            IntToStrEx((version shr 32) and $FFFF) + '.' +
            IntToStrEx((version shr 16) and $FFFF) + '.' +
            IntToStrEx( version         and $FFFF);
end;

// ***************************************************************

function MethodToProcedure(self: TObject; methodAddr: pointer) : pointer;
type
  TMethodToProc = packed record
    popEax   : byte;                  // $58      pop EAX
    pushSelf : record                 //          push self
                 opcode  : byte;      // $B8
                 self    : pointer;   // self
               end;
    pushEax  : byte;                  // $50      push EAX
    jump     : record                 //          jmp [target]
                 opcode  : byte;      // $FF
                 modRm   : byte;      // $25
                 pTarget : ^pointer;  // @target
                 target  : pointer;   //          @MethodAddr
               end;
  end;
var mtp : ^TMethodToProc absolute result;
begin
  mtp := VirtualAlloc(nil, sizeOf(mtp^), MEM_COMMIT, PAGE_EXECUTE_READWRITE);
  with mtp^ do begin
    popEax          := $58;
    pushSelf.opcode := $68;
    pushSelf.self   := self;
    pushEax         := $50;
    jump.opcode     := $FF;
    jump.modRm      := $25;
    jump.pTarget    := @jump.target;
    jump.target     := methodAddr;
  end;
end;

function MethodToProcedure(method: TMethod) : pointer;
begin
  result := MethodToProcedure(TObject(method.data), method.code);
end;

function ProcedureToMethod(self: TObject; procAddr: pointer) : TMethod;
begin
  result.Data := self;
  result.Code := procAddr;
end;

// ***************************************************************

type
  TMsgHandlers = array of record
    message   : cardinal;
    handler   : TMsgHandler;
    handlerOO : TMsgHandlerOO;
  end;

var
  MsgHandlerMutex : dword = 0;
  MsgHandlerWindows : array of record
    threadID : cardinal;
    window   : cardinal;
    handlers : TMsgHandlers;
  end;

function MsgHandlerWindowProc(window, msg: cardinal; wParam, lParam: integer) : integer; stdcall;
var i1 : integer;
    mh : TMsgHandlers;
begin
  mh := nil;
  if IsWindowUnicode(window) then
    result := DefWindowProcW(window, msg, wParam, lParam)
  else
    result := DefWindowProcA(window, msg, wParam, lParam);
  if (msg in [WM_QUERYENDSESSION, WM_QUIT, WM_SYSCOLORCHANGE, WM_ENDSESSION, WM_SYSTEMERROR,
              WM_WININICHANGE, WM_DEVMODECHANGE, WM_ACTIVATEAPP, WM_FONTCHANGE, WM_TIMECHANGE,
              WM_SPOOLERSTATUS, WM_COMPACTING, WM_POWER, WM_INPUTLANGCHANGEREQUEST, WM_INPUTLANGCHANGE,
              WM_USERCHANGED, WM_DISPLAYCHANGE]) or (msg >= WM_POWERBROADCAST) then begin
    WaitForSingleObject(MsgHandlerMutex, INFINITE);
    try
      for i1 := 0 to high(MsgHandlerWindows) do
        if MsgHandlerWindows[i1].window = window then begin
          mh := Copy(MsgHandlerWindows[i1].handlers);
          break;
        end;
    finally ReleaseMutex(MsgHandlerMutex) end;
    for i1 := 0 to high(mh) do
      if mh[i1].message = msg then
        if @mh[i1].handler <> nil then
             mh[i1].handler  (window, msg, wParam, lParam, result)
        else mh[i1].handlerOO(window, msg, wParam, lParam, result);
  end;
end;

function MsgHandlerWindow(threadID: cardinal = 0) : cardinal;
const CMadToolsMsgHandlerWindow : PAnsiChar = 'madToolsMsgHandlerWindow';
var wndClass : TWndClassA;
    mutex    : dword;
    i1       : integer;
    s1       : AnsiString;
begin
  result := 0;
  if threadID = 0 then threadID := GetCurrentThreadID;
  s1 := IntToHexEx(GetCurrentThreadID) + IntToHexEx(dword(@MsgHandlerWindow));
  if MsgHandlerMutex = 0 then begin
    mutex := CreateMutexA(nil, false, PAnsiChar('madToolsMsgHandlerMutex' + s1));
    if mutex <> 0 then begin
      WaitForSingleObject(mutex, INFINITE);
      if MsgHandlerMutex = 0 then
           MsgHandlerMutex := mutex
      else CloseHandle(mutex);
    end;
  end else
    WaitForSingleObject(MsgHandlerMutex, INFINITE);
  try
    for i1 := 0 to high(MsgHandlerWindows) do
      if MsgHandlerWindows[i1].threadID = threadID then begin
        result := MsgHandlerWindows[i1].window;
        break;
      end;
  finally ReleaseMutex(MsgHandlerMutex) end;
  if (result = 0) and (threadID = GetCurrentThreadID) then begin
    ZeroMemory(@wndClass, sizeOf(wndClass));
    wndClass.lpfnWndProc   := @MsgHandlerWindowProc;
    wndClass.hInstance     := GetModuleHandle(nil);
    wndClass.lpszClassName := PAnsiChar(CMadToolsMsgHandlerWindow + s1);
    windows.RegisterClassA(wndClass);
    // in NT4 you sometimes have to give exactly the same *pointer*
    // which you used in RegisterClass, the same *string* sometimes fails
    result := CreateWindowExA(WS_EX_TOOLWINDOW, wndClass.lpszClassName, '', WS_POPUP,
                              0, 0, 0, 0, 0, 0, wndClass.hInstance, nil);
    if result <> 0 then begin
      WaitForSingleObject(MsgHandlerMutex, INFINITE);
      try
        i1 := Length(MsgHandlerWindows);
        SetLength(MsgHandlerWindows, i1 + 1);
        MsgHandlerWindows[i1].threadID := threadID;
        MsgHandlerWindows[i1].window   := result;
      finally ReleaseMutex(MsgHandlerMutex) end;
    end;
  end;
end;

function AddMsgHandler_(handler: TMsgHandler; handlerOO: TMsgHandlerOO; msg, threadID: cardinal) : cardinal;
var i1, i2 : integer;
    b1     : boolean;
    window : cardinal;
begin
  result := 0;
  window := MsgHandlerWindow(threadID);
  if window <> 0 then begin
    WaitForSingleObject(MsgHandlerMutex, INFINITE);
    try
      for i1 := 0 to high(MsgHandlerWindows) do
        if MsgHandlerWindows[i1].window = window then
          with MsgHandlerWindows[i1] do begin
            if msg = 0 then begin
              msg := WM_USER;
              repeat
                b1 := true;
                for i2 := 0 to high(handlers) do
                  if handlers[i2].message = msg then begin
                    b1 := false;
                    inc(msg);
                    break;
                  end;
              until b1;
            end else
              for i2 := 0 to high(handlers) do
                if (handlers[i2].message = msg) and
                   (             @handlers[i2].handler     =              @handler    ) and
                   (int64(TMethod(handlers[i2].handlerOO)) = int64(TMethod(handlerOO))) then
                  exit;
            i2 := Length(handlers);
            SetLength(handlers, i2 + 1);
            handlers[i2].message   := msg;
            handlers[i2].handler   := handler;
            handlers[i2].handlerOO := handlerOO;
            result := msg;
            break;
          end;
    finally ReleaseMutex(MsgHandlerMutex) end;
  end;
end;

function AddMsgHandler(handler: TMsgHandler; msg: cardinal = 0; threadID: cardinal = 0) : cardinal;
begin
  result := AddMsgHandler_(handler, nil, msg, threadID);
end;

function AddMsgHandler(handler: TMsgHandlerOO; msg: cardinal = 0; threadID: cardinal = 0) : cardinal;
begin
  result := AddMsgHandler_(nil, handler, msg, threadID);
end;

function DelMsgHandler_(handler: TMsgHandler; handlerOO: TMsgHandlerOO; msg, threadID: cardinal) : boolean;
var i1, i2 : integer;
    c1     : cardinal;
begin
  result := false;
  if MsgHandlerMutex <> 0 then begin
    if threadID = 0 then threadID := GetCurrentThreadID;
    WaitForSingleObject(MsgHandlerMutex, INFINITE);
    try
      c1 := 0;
      for i1 := 0 to high(MsgHandlerWindows) do
        if MsgHandlerWindows[i1].threadID = threadID then
          with MsgHandlerWindows[i1] do begin
            for i2 := high(handlers) downto 0 do
              if ( (msg = 0) or (handlers[i2].message = msg) ) and
                 (             @handlers[i2].handler     =              @handler    ) and
                 (int64(TMethod(handlers[i2].handlerOO)) = int64(TMethod(handlerOO))) then begin
                handlers[i2] := handlers[high(handlers)];
                SetLength(handlers, high(handlers));
              end;
            if (handlers = nil) and IsWindow(window) then begin
              c1 := window;
              MsgHandlerWindows[i1] := MsgHandlerWindows[high(MsgHandlerWindows)];
              SetLength(MsgHandlerWindows, high(MsgHandlerWindows));
            end;
            break;
          end;
    finally ReleaseMutex(MsgHandlerMutex) end;
    if c1 <> 0 then
      if threadID = GetCurrentThreadID then
           DestroyWindow(c1)
      else PostMessage(c1, WM_CLOSE, 0, 0);
  end;
end;

function DelMsgHandler(handler: TMsgHandler; msg: cardinal = 0; threadID: cardinal = 0) : boolean;
begin
  result := DelMsgHandler_(handler, nil, msg, threadID);
end;

function DelMsgHandler(handler: TMsgHandlerOO; msg: cardinal = 0; threadID: cardinal = 0) : boolean;
begin
  result := DelMsgHandler_(nil, handler, msg, threadID);
end;

procedure FinalMsgHandler;
var mutex : dword;
begin
  mutex := MsgHandlerMutex;
  MsgHandlerMutex := 0;
  if mutex <> 0 then
    CloseHandle(mutex);
end;

// ***************************************************************

function FindModule(addr: pointer; var moduleHandle: dword; var moduleName: AnsiString) : boolean;
var mbi    : TMemoryBasicInformation;
    arrChA : array [0..MAX_PATH] of AnsiChar;
    arrChW : array [0..MAX_PATH] of WideChar;
begin
  result := (VirtualQuery(addr, mbi, sizeOf(mbi)) = sizeOf(mbi)) and
            (mbi.State = MEM_COMMIT) and (mbi.AllocationBase <> nil);
  if result then begin
    if GetVersion and $80000000 <> 0 then
      result := GetModuleFileNameA(dword(mbi.AllocationBase), arrChA, MAX_PATH) <> 0
    else
      result := GetModuleFileNameW(dword(mbi.AllocationBase), arrChW, MAX_PATH) <> 0;
    if result then begin
      moduleHandle := dword(mbi.AllocationBase);
      if GetVersion and $80000000 = 0 then
        moduleName := WideToAnsiEx(arrChW)
      else
        moduleName := arrChA;
    end;
  end;
end;

{$ifdef UnicodeOverloads}
function FindModule(addr: pointer; var moduleHandle: dword; var moduleName: UnicodeString) : boolean;
var mbi    : TMemoryBasicInformation;
    arrChA : array [0..MAX_PATH] of AnsiChar;
    arrChW : array [0..MAX_PATH] of WideChar;
begin
  result := (VirtualQuery(addr, mbi, sizeOf(mbi)) = sizeOf(mbi)) and
            (mbi.State = MEM_COMMIT) and (mbi.AllocationBase <> nil);
  if result then begin
    if GetVersion and $80000000 <> 0 then
      result := GetModuleFileNameA(dword(mbi.AllocationBase), arrChA, MAX_PATH) <> 0
    else
      result := GetModuleFileNameW(dword(mbi.AllocationBase), arrChW, MAX_PATH) <> 0;
    if result then begin
      moduleHandle := dword(mbi.AllocationBase);
      if GetVersion and $80000000 = 0 then
        moduleName := arrChW
      else
        moduleName := UnicodeString(arrChA);
    end;
  end;
end;
{$endif}

function GetImageNtHeaders(module: dword) : PImageNtHeaders;
begin
  result := nil;
  try
    if (not IsBadReadPtr(pointer(module), 2)) and (TPWord(module)^ = CEMAGIC) then begin
      result := pointer(module + dword(pointer(module + CENEWHDR)^));
      if result^.signature <> CPEMAGIC then
        result := nil;
    end;
  except result := nil end;
end;

function GetImageDataDirectory(module, directory: dword) : pointer;
var nh : PImageNtHeaders;
begin
  nh := GetImageNtHeaders(module);
  if nh <> nil then begin
    if nh^.OptionalHeader.Magic = IMAGE_NT_OPTIONAL_HDR64_MAGIC then
         dword(result) := module + PImageOptionalHeader64(@nh^.OptionalHeader).DataDirectory[directory].VirtualAddress
    else dword(result) := module +                         nh^.OptionalHeader .DataDirectory[directory].VirtualAddress;
  end else
    result := nil;
end;

function GetImageImportDirectory(module: dword) : PImageImportDirectory;
begin
  result := GetImageDataDirectory(module, IMAGE_DIRECTORY_ENTRY_IMPORT);
end;

function GetImageExportDirectory(module: dword) : PImageExportDirectory;
begin
  result := GetImageDataDirectory(module, IMAGE_DIRECTORY_ENTRY_EXPORT);
end;

function ExportToFunc(module, addr: dword) : pointer;
var nh       : PImageNtHeaders;
    ed       : TImageDataDirectory;
    s1       : AnsiString;
    pc1, pc2 : PAnsiChar;
begin
  nh := GetImageNtHeaders(module);
  if nh^.OptionalHeader.Magic = IMAGE_NT_OPTIONAL_HDR64_MAGIC then
       ed := PImageOptionalHeader64(@nh^.OptionalHeader).DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT]
  else ed :=                         nh^.OptionalHeader .DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT];
  if (addr >= ed.VirtualAddress) and (addr < ed.VirtualAddress + ed.Size) then begin
    s1 := PAnsiChar(module + addr);
    pc1 := PAnsiChar(s1);
    pc2 := pc1;
    repeat
      inc(pc2);
    until pc2^ = '.';
    pc2^ := #0;
    inc(pc2);
    result := GetImageProcAddress(GetModuleHandleA(pc1), pc2);
  end else
    result := pointer(module + addr);
end;

function VirtualToRaw(nh: PImageNtHeaders; addr: dword) : dword;
type TAImageSectionHeader = packed array [0..maxInt shr 6] of TImageSectionHeader;
var i1 : integer;
    sh : ^TAImageSectionHeader;
begin
  result := addr;
  if nh^.OptionalHeader.Magic = IMAGE_NT_OPTIONAL_HDR64_MAGIC then
       dword(sh) := dword(@nh^.OptionalHeader) + sizeOf(TImageOptionalHeader64)
  else dword(sh) := dword(@nh^.OptionalHeader) + sizeOf(TImageOptionalHeader  );
  for i1 := 0 to nh^.FileHeader.NumberOfSections - 1 do
    if (addr >= sh[i1].VirtualAddress) and
       ((i1 = nh^.FileHeader.NumberOfSections - 1) or (addr < sh[i1 + 1].VirtualAddress)) then begin
      result := addr - sh[i1].VirtualAddress + sh[i1].PointerToRawData;
      break;
    end;
end;

function GetSizeOfImage(nh: PImageNtHeaders) : dword;
begin
  if nh^.OptionalHeader.Magic = IMAGE_NT_OPTIONAL_HDR64_MAGIC then
       result := PImageOptionalHeader64(@nh.OptionalHeader).SizeOfImage
  else result :=                         nh.OptionalHeader .SizeOfImage;
end;

function NeedModuleFileMap(module: dword) : pointer;
var arrCh : pointer;
    fh    : dword;
    map   : dword;
begin
  result := nil;
  if GetVersion and $80000000 = 0 then begin
    arrCh := pointer(LocalAlloc(LPTR, 32 * 1024 * 2));
    GetModuleFileNameW(module, arrCh, 32 * 1024);
    fh := CreateFileW(arrCh, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  end else begin
    arrCh := pointer(LocalAlloc(LPTR, MAX_PATH + 1));
    GetModuleFileNameA(module, arrCh, MAX_PATH);
    fh := CreateFileA(arrCh, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  end;
  LocalFree(dword(arrCh));
  if fh <> INVALID_HANDLE_VALUE then begin
    if GetVersion and $80000000 = 0 then
         map := CreateFileMappingW(fh, nil, PAGE_READONLY, 0, 0, nil)
    else map := CreateFileMappingA(fh, nil, PAGE_READONLY, 0, 0, nil);
    if map <> 0 then begin
      result := MapViewOfFile(map, FILE_MAP_READ, 0, 0, 0);
      CloseHandle(map);
    end;
    CloseHandle(fh);
  end;
end;

function GetImageProcAddress(module: dword; const name: AnsiString; doubleCheck: boolean = false) : pointer;
var ed         : PImageExportDirectory;
    nh         : PImageNtHeaders;
    i1         : integer;
    c1, c2, c3 : dword;
    w1         : word;
    va         : dword;
    buf        : pointer;
    p1         : pointer;
    freeBuf    : boolean;
    soi        : dword;
begin
  result := nil;
  if module <> 0 then begin
    nh := GetImageNtHeaders(module);
    if nh <> nil then begin
      soi := GetSizeOfImage(nh);
      if nh^.OptionalHeader.Magic = IMAGE_NT_OPTIONAL_HDR64_MAGIC then
           va := PImageOptionalHeader64(@nh^.OptionalHeader).DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress
      else va :=                         nh^.OptionalHeader .DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress;
      dword(ed) := module + va;
      if ed <> nil then
        for i1 := 0 to ed^.NumberOfNames - 1 do
          if lstrcmpA(pointer(module + TPACardinal(module + ed^.AddressOfNames)^[i1]), pointer(name)) = 0 then begin
            w1 := TPAWord(module + ed^.AddressOfNameOrdinals)^[i1];
            c1 := TPACardinal(module + ed^.AddressOfFunctions)^[w1];
            if doubleCheck or (c1 > soi) then begin
              dword(p1) := module + c1;
              if (@CheckProcAddress <> nil) and CheckProcAddress(p1) then begin
                result := p1;
                break;
              end;
              if @NeedModuleFileMapEx <> nil then
                buf := NeedModuleFileMapEx(module)
              else
                buf := nil;
              freeBuf := buf = nil;
              if buf = nil then
                buf := NeedModuleFileMap(module);
              if buf <> nil then begin
                try
                  c2 := ed^.AddressOfNames;
                  c3 := ed^.AddressOfFunctions;
                  dword(ed) := dword(buf) + VirtualToRaw(nh, va);
                  if (c2 = ed^.AddressOfNames) and (c3 = ed^.AddressOfFunctions) then
                    c1 := TPACardinal(dword(buf) + VirtualToRaw(nh, ed^.AddressOfFunctions))^[w1];
                except end;
                if freeBuf then
                  UnmapViewOfFile(buf);
              end;
            end;
            result := ExportToFunc(module, c1);
            break;
          end;
    end;
    if result = nil then begin
      nh := GetImageNtHeaders(module);
      if (nh <> nil) and (nh^.OptionalHeader.Magic <> IMAGE_NT_OPTIONAL_HDR64_MAGIC) then
        result := GetProcAddress(module, PAnsiChar(name));
    end;
  end;
end;

function Is64bitModule(fileName: PWideChar) : bool; stdcall;
// find out and return whether the dll file is a 64bit dll
var fh, map : dword;
    buf     : pointer;
    nh      : PImageNtHeaders;
begin
  result := false;
  fh := CreateFileW(fileName, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  if fh <> INVALID_HANDLE_VALUE then begin
    map := CreateFileMapping(fh, nil, PAGE_READONLY, 0, 0, nil);
    if map <> 0 then begin
      buf := MapViewOfFile(map, FILE_MAP_READ, 0, 0, 0);
      if buf <> nil then begin
        nh := GetImageNtHeaders(dword(buf));
        result := (nh <> nil) and (nh.OptionalHeader.Magic = IMAGE_NT_OPTIONAL_HDR64_MAGIC);
        UnmapViewOfFile(buf);
      end;
      CloseHandle(map);
    end;
    CloseHandle(fh);
  end;
end;

function GetImageProcAddress(module: dword; index: integer) : pointer; overload;
var oi : integer;
    nh : PImageNtHeaders;
    ed : PImageExportDirectory;
    c1 : dword;
begin
  result := nil;
  oi := index;
  ed := GetImageExportDirectory(module);
  if ed <> nil then
    with ed^ do begin
      dec(index, Base);
      if (index >= 0) and (index < NumberOfFunctions) then begin
        c1 := TPACardinal(module + AddressOfFunctions)^[index];
        if c1 > 0 then
          result := ExportToFunc(module, c1);
      end;
    end;
  if result = nil then begin
    nh := GetImageNtHeaders(module);
    if (nh <> nil) and (nh^.OptionalHeader.Magic <> IMAGE_NT_OPTIONAL_HDR64_MAGIC) then
      result := GetProcAddress(module, PAnsiChar(oi));
  end;
end;

function GetImageProcName(module: dword; proc: pointer; unmangle: boolean) : AnsiString;
var ed     : PImageExportDirectory;
    i1, i2 : integer;
    s1     : AnsiString;
begin
  result := '';
  ed := GetImageExportDirectory(module);
  if ed <> nil then
    with ed^ do
      for i1 := 0 to NumberOfFunctions - 1 do
        if module + TPACardinal(module + AddressOfFunctions)^[i1] = dword(proc) then begin
          for i2 := 0 to NumberOfNames - 1 do
            if TPAWord(module + AddressOfNameOrdinals)^[i2] = i1 then begin
              result := PAnsiChar(module + TPACardinal(module + AddressOfNames)^[i2]);
              break;
            end;
          if result = '' then
            result := '#' + IntToStrEx(Base + dword(i1));
          break;
        end;
  if unmangle and madTools.Unmangle(result, s1) then
    result := s1 + '.' + result;
end;

function ResToStr(module: dword; resType, resName: PAnsiChar) : AnsiString;
var c1, c2 : dword;
begin
  result := '';
  c1 := FindResourceA(module, resName, resType);
  if c1 <> 0 then begin
    c2 := LoadResource(module, c1);
    if c2 <> 0 then begin
      SetString(result, PAnsiChar(LockResource(c2)), SizeOfResource(module, c1));
      UnlockResource(c2);
      FreeResource(c2);
    end;
  end;
end;

function Unmangle(var publicName, unitName: AnsiString) : boolean;
var i1, i2 : integer;
    b1, b2 : boolean;
    s2     : AnsiString;
begin
  result := false;
  unitName := '';
  ReplaceStr(publicName, '::', '.');
  if (publicName <> '') and (publicName[1] = '@') then begin
    // might be a mangled bpl export, so let's try to unmangle it
    s2 := '';
    if (Length(publicName) > 1) and (publicName[2] = '%') then begin
      for i1 := Length(publicName) - 1 downto 3 do
        if (publicName[i1] = '%') and (publicName[i1 + 1] = '@') then begin
          s2 := '.' + Copy(publicName, i1 + 2, maxInt);
          break;
        end;
    end;
    i2 := 3;
    if (Length(publicName) > 6) and (publicName[2] = '_') and (publicName[3] = '$') then
      for i1 := 5 to Length(publicName) - 1 do
        if publicName[i1] = '$' then begin
          if publicName[i1 + 1] = '@' then
            i2 := i1 + 1;
          break;
        end;
    b1 := false;
    b2 := false;
    for i1 := i2 to Length(publicName) do
      case publicName[i1] of
        '$' : begin
                b1 := (Length(publicName) > i1 + 1) and
                      (publicName[i1 + 2] = 'd');
                Delete(publicName, i1, maxInt);
                publicName := publicName + s2;
                b2 := true;
                break;
              end;
        '@' : begin
                publicName[i1] := '.';
                if unitName = '' then
                  unitName := Copy(publicName, 2, i1 - 2)
              end;
      end;
    if unitName <> '' then
      if length(unitName) + 2 < length(publicName) then begin
        Delete(publicName, 1, Length(unitName) + 2);
        b2 := false;
      end else
        unitName := '';
    if b2 then
      Delete(publicName, 1, 1);
    if publicName <> '' then
      if      publicName[1] = '%' then Delete(publicName, 1, 1)
      else if publicName[1] = '.' then publicName[1] := '@';
    if (publicName <> '') and (publicName[Length(publicName)] = '.') then
      if b1 then
           publicName := publicName + 'Destroy'
      else publicName := publicName + 'Create';
    TrimStr(publicName);
    if (publicName <> '') and (publicName[Length(publicName)] = '.') then
      publicName := publicName + '?';
    result := true;
  end;
end;

// ***************************************************************

function TickDif(tick: dword) : dword;
var dw : dword;
begin
  dw := GetTickCount;
  if dw >= tick then
       result := dw - tick
  else result := maxCard - tick + dw;
end;

// ***************************************************************

function GetExceptionObject(er: pointer) : MadException;
begin
  result := MadException.Create('Unknown exception. If you want to know more, ' +
                                'you have to add SysUtils to your project.');
end;

procedure InitTryExceptFinally;
begin
  if ExceptionClass = nil then begin
    ExceptionClass := MadException;
    ExceptObjProc := @GetExceptionObject;
  end;
end;

// ***************************************************************

initialization
finalization
  FinalMsgHandler;
end.