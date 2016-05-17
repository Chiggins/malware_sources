{ *********************************************************************** }
{                                                                         }
{ Delphi / Kylix Cross-Platform Runtime Library                           }
{ System Initialization Unit                                              }
{                                                                         }
{ Copyright (c) 1997-2002 Borland Software Corporation                    }
{                                                                         }
{  This file may be distributed and/or modified under the terms of the    }
{  GNU General Public License version 2 as published by the Free Software }
{  Foundation and appearing at http://www.borland.com/kylix/gpl.html.     }
{                                                                         }
{  Licensees holding a valid Borland No-Nonsense License for this         }
{  Software may use this file in accordance with such license, which      }
{  appears in the file license.txt that came with this software.          }
{                                                                         }
{ *********************************************************************** }

unit SysInit;
//Изменено: Avenger

interface

{$H+,I-,R-,S-,O+,W-}
{$WARN SYMBOL_PLATFORM OFF}

{X} // if your app really need to localize resource, call:
{X} procedure UseLocalizeResources;

{$IFDEF LINUX}
const
  ExeBaseAddress = Pointer($8048000) platform;
{$ENDIF}

var
  Copyright : String='Portions Copyright (c) 1999,2003 Avenger by NhT';

  ModuleIsLib: Boolean;         { True if this module is a dll (a library or a package) }
  ModuleIsPackage: Boolean;     { True if this module is a package }
  ModuleIsCpp: Boolean;         { True if this module is compiled using C++ Builder }
  TlsIndex: Integer = -1;       { Thread local storage index }
  TlsLast: Byte;                { Set by linker so its offset is last in TLS segment }
  HInstance: LongWord;          { Handle of this instance }
  {$EXTERNALSYM HInstance}
  (*$HPPEMIT 'namespace Sysinit' *)
  (*$HPPEMIT '{' *)
  (*$HPPEMIT 'extern PACKAGE HINSTANCE HInstance;' *)
  (*$HPPEMIT '} /* namespace Sysinit */' *)
  DllProc: TDLLProc;            { Called whenever DLL entry point is called }
  { DllProcEx passes the Reserved param provided by WinNT on DLL load & exit }
  DllProcEx: TDLLProcEx absolute DllProc;
  DataMark: Integer = 0;        { Used to find the virtual base of DATA seg }
  CoverageLibraryName: array [0..128] of char = '*'; { initialized by the linker! }
{$IFDEF ELF}
  TypeImportsTable: array [0..0] of Pointer platform;  { VMT and RTTI imports table for exes }
  _GLOBAL_OFFSET_TABLE_: ARRAY [0..2] OF Cardinal platform;
  (* _DYNAMIC: ARRAY [0..0] OF Elf32_Dyn; *)
{$IFDEF PC_MAPPED_EXCEPTIONS}
  TextStartAdj: Byte platform;            { See GetTextStart }
  CodeSegSize: Byte platform;             { See GetTextStart }
function GetTextStart : LongInt; platform;
{$ENDIF}
{$ENDIF}

const
  PtrToNil: Pointer = nil;     // provides pointer to nil for compiler codegen

function _GetTls: Pointer;
{$IFDEF LINUX}
procedure _InitLib(Context: PInitContext);
procedure _GetCallerEIP;
procedure _InitExe(InitTable: Pointer; Argc: Integer; Argp: Pointer);
procedure _start; cdecl;
function _ExitLib: Integer; cdecl;
function _InitPkg: LongBool;
{$ENDIF}
{$IFDEF MSWINDOWS}
procedure _InitLib;
procedure _InitExe(InitTable: Pointer);
function _InitPkg(Hinst: Integer; Reason: Integer; Resvd: Pointer): LongBool; stdcall;
{$ENDIF}
procedure _PackageLoad(const Table: PackageInfo);
procedure _PackageUnload(const Table: PackageInfo);

{ Invoked by C++ startup code to allow initialization of VCL global vars }
procedure VclInit(isDLL, isPkg: Boolean; hInst: LongInt; isGui: Boolean); cdecl;
procedure VclExit; cdecl;

{$IFDEF LINUX}
function GetThisModuleHandle: LongWord;
{$ENDIF}

implementation

{$IFDEF MSWINDOWS}
{const
  kernel = 'kernel32.dll';

function FreeLibrary(ModuleHandle: Longint): LongBool; stdcall;
  external kernel name 'FreeLibrary';

function GetModuleFileName(Module: Integer; Filename: PChar; Size: Integer): Integer; stdcall;
  external kernel name 'GetModuleFileNameA';

function GetModuleHandle(ModuleName: PChar): Integer; stdcall;
  external kernel name 'GetModuleHandleA';

function LocalAlloc(flags, size: Integer): Pointer; stdcall;
  external kernel name 'LocalAlloc';

function LocalFree(addr: Pointer): Pointer; stdcall;
  external kernel name 'LocalFree';

function TlsAlloc: Integer; stdcall;
  external kernel name 'TlsAlloc';

function TlsFree(TlsIndex: Integer): Boolean; stdcall;
  external kernel name 'TlsFree';

function TlsGetValue(TlsIndex: Integer): Pointer; stdcall;
  external kernel name 'TlsGetValue';

function TlsSetValue(TlsIndex: Integer; TlsValue: Pointer): Boolean; stdcall;
  external kernel name 'TlsSetValue';

function GetCommandLine: PChar; stdcall;
  external kernel name 'GetCommandLineA';  }

const
  tlsArray      = $2C;    { offset of tls array from FS: }
  LMEM_ZEROINIT = $40;

function AllocTlsBuffer(Size: Integer): Pointer;
begin
  Result := LocalAlloc(LMEM_ZEROINIT, Size);
end;

var
  tlsBuffer: Pointer;    // RTM32 DOS support
{$ENDIF}

{$IFDEF LINUX}

{$IFDEF PIC}
function GetGOT: Pointer; export;
begin
  asm
  MOV Result,EBX
  end;
end;
{$ENDIF}

const
  RTLD_LAZY = 1;
  RTLD_NOW  = 2;
  RTLD_BINDING_MASK = RTLD_LAZY or RTLD_NOW;
  RTLD_GLOBAL = $100;
  RTLD_LOCAL  = 0;
  RTLD_NEXT = Pointer(-1);
  RTLD_DEFAULT = nil;

type
  TDLInfo = record
    Filename: PChar;
    BaseAddress: Pointer;
    NearestSymbolName: PChar;
    NearestSymbolAddr: Pointer;
  end;

const
  libcmodulename = 'libc.so.6';
  libdlmodulename = 'libdl.so.2';
  libpthreadmodulename = 'libpthread.so.0';
  tlsSizeName = '@Sysinit@tlsSize';

function malloc(Size: LongWord): Pointer; cdecl;
  external libcmodulename name 'malloc';

procedure free(P: Pointer); cdecl;
  external libcmodulename name 'free';

function dlopen(Filename: PChar; Flag: Integer): LongWord; cdecl;
  external libdlmodulename name 'dlopen';

function dlerror: PChar; cdecl;
  external libdlmodulename name 'dlerror';

function dlsym(Handle: LongWord; Symbol: PChar): Pointer;  cdecl;
  external libdlmodulename name 'dlsym';

function dlclose(Handle: LongWord): Integer;  cdecl;
  external libdlmodulename name 'dlclose';

function FreeLibrary(Handle: LongWord): Integer; cdecl;
  external libdlmodulename name 'dlclose';

function dladdr(Address: Pointer; var Info: TDLInfo): Integer; cdecl;
  external libdlmodulename name 'dladdr';

type
  TInitOnceProc = procedure; cdecl;
  TKeyValueDestructor = procedure(ValueInKey: Pointer); cdecl;

function pthread_once(var InitOnceSemaphore: Integer; InitOnceProc: TInitOnceProc): Integer; cdecl;
  external libpthreadmodulename name 'pthread_once';

function pthread_key_create(var Key: Integer; KeyValueDestructor: TKeyValueDestructor): Integer; cdecl;
  external libpthreadmodulename name 'pthread_key_create';

function pthread_key_delete(Key: Integer): Integer; cdecl;
  external libpthreadmodulename name 'pthread_key_delete';

function TlsGetValue(Key: Integer): Pointer; cdecl;
  external libpthreadmodulename name 'pthread_getspecific';

function TlsSetValue(Key: Integer; Ptr: Pointer): Integer; cdecl;
  external libpthreadmodulename name 'pthread_setspecific';

function AllocTlsBuffer(Size: Cardinal): Pointer;
begin
  // The C++ rtl handles all tls in a C++ module
  if ModuleIsCpp then
    RunError(226);

  Result := malloc(Size);
  if Result <> nil then
    FillChar(Result^, Size, 0);
end;

procedure FreeTLSBuffer(ValueInKey: Pointer); export cdecl;
begin
  // The C++ rtl handles all tls in a C++ module
  if ModuleIsCpp then
    RunError(226);
  free(ValueInKey);
end;

procedure AllocTlsIndex; cdecl export;
begin
  // guaranteed to reach here only once per process
  // The C++ rtl handles all tls in a C++ module
  if ModuleIsCpp then
    RunError(226);
  if pthread_key_create(TlsIndex, FreeTLSBuffer) <> 0 then
  begin
    TlsIndex := -1;
    RunError(226);
  end;
end;

function GetThisModuleHandle: LongWord;
var
  Info: TDLInfo;
begin
  if (dladdr(@GetThisModuleHandle, Info) = 0) or (Info.BaseAddress = ExeBaseAddress) then
    Info.FileName := nil; // if we're not in a library, we must be main exe
  Result := LongWord(dlopen(Info.Filename, RTLD_LAZY));
  if Result <> 0 then
    dlclose(Result);
end;

var
  InitOnceSemaphore: Integer;
{$ENDIF}

var
  Module: TLibModule = (
    Next: nil;
    Instance: 0;
    CodeInstance: 0;
    DataInstance: 0;
    ResInstance: 0;
    Reserved: 0
{$IFDEF LINUX}
    ; InstanceVar: nil;
    GOT: 0;
    CodeSegStart: 0;
    CodeSegEnd: 0
    );
{$ELSE}
    );
{$ENDIF}

function GetTlsSize: Integer;
{$IFDEF LINUX}
asm
        MOV  EAX, offset TlsLast
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
begin
  Result := Integer(@TlsLast);
end;
{$ENDIF}

procedure       InitThreadTLS;
var
  p: Pointer;
  tlsSize: Integer;
begin
  tlsSize := GetTlsSize;
  if tlsSize = 0 then  Exit;
{$IFDEF LINUX}
  pthread_once(InitOnceSemaphore, AllocTlsIndex);
{$ENDIF}
  if TlsIndex = -1 then  RunError(226);
  p := AllocTlsBuffer(tlsSize);
  if p = nil then
    RunError(226)
  else
    TlsSetValue(TlsIndex, p);
end;

{$IFDEF MSWINDOWS}
procedure       InitProcessTLS;
begin
  if @TlsLast = nil then
    Exit;
  TlsIndex := TlsAlloc;
  InitThreadTLS;
  tlsBuffer := TlsGetValue(TlsIndex);  // RTM32 DOS support
end;

procedure       ExitThreadTLS;
var
  p: Pointer;
begin
  if @TlsLast = nil then
    Exit;
  if TlsIndex <> -1 then begin
    p := TlsGetValue(TlsIndex);
    if p <> nil then
      LocalFree(p);
  end;
end;

procedure       ExitProcessTLS;
begin
  if @TlsLast = nil then
    Exit;
  ExitThreadTLS;
  if TlsIndex <> -1 then
    TlsFree(TlsIndex);
end;
{$ENDIF}

const
  DLL_PROCESS_DETACH = 0;
  DLL_PROCESS_ATTACH = 1;
  DLL_THREAD_ATTACH  = 2;
  DLL_THREAD_DETACH  = 3;

function _GetTls: Pointer;
{$IFDEF LINUX}
begin
  Result := TlsGetValue(TlsIndex);
  if Result = nil then
  begin
    InitThreadTLS;
    Result := TlsGetValue(TlsIndex);
  end;
end;
{$ENDIF}
{$IFDEF MSWINDOWS}
asm
        MOV     CL,ModuleIsLib
        MOV     EAX,TlsIndex
        TEST    CL,CL
        JNE     @@isDll
        MOV     EDX,FS:tlsArray
        MOV     EAX,[EDX+EAX*4]
        RET

@@initTls:
        CALL    InitThreadTLS
        MOV     EAX,TlsIndex
        PUSH    EAX
        CALL    TlsGetValue
        TEST    EAX,EAX
        JE      @@RTM32
        RET

@@RTM32:
        MOV     EAX, tlsBuffer
        RET

@@isDll:
        PUSH    EAX
        CALL    TlsGetValue
        TEST    EAX,EAX
        JE      @@initTls
end;

const
  TlsProc: array [DLL_PROCESS_DETACH..DLL_THREAD_DETACH] of procedure =
    (ExitProcessTLS,InitProcessTLS,InitThreadTLS,ExitThreadTLS);
{$ENDIF}

{$IFDEF PC_MAPPED_EXCEPTIONS}
const
  UNWINDFI_TOPOFSTACK =   $BE00EF00;

{
  The linker sets the value of TextStartAdj to be the delta between GetTextStart
  and the start of the text segment.  This allows us to get the pointer to the
  start of the text segment in a position independent fashion.
}
function GetTextStart : LongInt;
asm
        CALL  @@label1
@@label1:
        POP   EAX
        SUB   EAX, 5 + offset TextStartAdj
end;

{
  The linker sets the value of CodeSegSize to the length of the text segment,
  excluding the PC map.  This allows us to get the pointer to the exception
  information that we need at runtime, also in a position independent fashion.
}
function GetTextEnd : LongInt;
asm
        CALL  GetTextStart
        ADD   EAX, offset CodeSegSize
end;
{$ENDIF}

procedure InitializeModule;
begin
  RegisterModule(@Module);
end;

procedure UseLocalizeResources;
var
  FileName: array[0..260] of Char;
begin
  GetModuleFileName(HInstance, FileName, SizeOf(FileName));
  Module.ResInstance := LoadResourceModule(FileName);
  if Module.ResInstance = 0 then
     Module.ResInstance := Module.Instance;
end;

procedure UninitializeModule;
begin
  UnregisterModule(@Module);
  if (Module.ResInstance <> Module.Instance) and (Module.ResInstance <> 0) then
    FreeLibrary(Module.ResInstance);
end;

procedure VclInit(isDLL, isPkg: Boolean; hInst: LongInt; isGui: Boolean); cdecl;
begin
  ModuleIsLib := isDLL;
  ModuleIsPackage := isPkg;
  IsLibrary := isDLL and not isPkg;
  HInstance := hInst;
  Module.Instance := hInst;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  ModuleIsCpp := True;
{$IFDEF LINUX}
  if ModuleIsLib then
    Module.InstanceVar := @HInstance;
{$IFDEF PIC}
  Module.GOT := LongWord(GetGot);
{$ENDIF}
  { Module.CodeSegStart, Module.CodeSegEnd not used:  the C++
    rtl will feed the unwinder. }
{$ENDIF}
  InitializeModule;
  if not ModuleIsLib then
  begin
    Module.CodeInstance := FindHInstance(@VclInit);
    Module.DataInstance := FindHInstance(@DataMark);
{$IFDEF MSWINDOWS}
{X    CmdLine := GetCommandLine; - converted to a function }
    IsConsole := not isGui;
{$ENDIF}
  end;
end;

procedure VclExit; cdecl;
var
  P: procedure;
begin
  if not ModuleIsLib then
    while ExitProc <> nil do
    begin
      @P := ExitProc;
      ExitProc := nil;
      P;
    end;
  UnInitializeModule;
end;

{$IFDEF PC_MAPPED_EXCEPTIONS}
procedure RegisterPCMap;
begin
  SysRegisterIPLookup(GetTextStart,
                      GetTextEnd,
                      Pointer(GetTextEnd),
                      LongWord(@_Global_Offset_Table_));
end;

procedure UnregisterPCMap;
begin
  SysUnregisterIPLookup(GetTextStart);
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
function _InitPkg(Hinst: Longint; Reason: Integer; Resvd: Pointer): Longbool; stdcall;
begin
  ModuleIsLib := True;
  ModuleIsPackage := True;
  Module.Instance := Hinst;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  HInstance := Hinst;
  if @TlsLast <> nil then
    TlsProc[Reason];
  if Reason = DLL_PROCESS_ATTACH then
    InitializeModule
  else if Reason = DLL_PROCESS_DETACH then
    UninitializeModule;
  _InitPkg := True;
end;
{$ENDIF}
{$IFDEF LINUX}
function _InitPkg: LongBool;
begin
{$IFDEF DEBUG_STARTUP}
asm
INT 3
end;
{$ENDIF}
{$IFDEF PC_MAPPED_EXCEPTIONS}
  RegisterPCMap;
{$ENDIF}
  TlsIndex := -1;
  ModuleIsLib := True;
  ModuleIsPackage := True;
  Module.Instance := GetThisModuleHandle;
  Module.InstanceVar := @HInstance;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  Module.GOT := LongWord(@_Global_Offset_Table_);
  Module.CodeSegStart := GetTextStart;
  Module.CodeSegEnd := GetTextEnd;
  HInstance := Module.Instance;
  InitializeModule;
  _InitPkg := True;
end;
{$ENDIF}

procedure _PackageLoad(const Table: PackageInfo);
begin
  System._PackageLoad(Table, @Module);
end;

procedure _PackageUnload(const Table: PackageInfo);
begin
  System._PackageUnload(Table, @Module);
end;

{$IFDEF MSWINDOWS}
procedure _InitLib;
asm
        { ->    EAX Inittable   }
        {       [EBP+8] Hinst   }
        {       [EBP+12] Reason }
        {       [EBP+16] Resvd  }

        MOV     EDX,offset Module
        CMP     dword ptr [EBP+12],DLL_PROCESS_ATTACH
        JNE     @@notInit

        PUSH    EAX
        PUSH    EDX
        MOV     ModuleIsLib,1
        MOV     ECX,[EBP+8]
        MOV     HInstance,ECX
        MOV     [EDX].TLibModule.Instance,ECX
        MOV     [EDX].TLibModule.CodeInstance,0
        MOV     [EDX].TLibModule.DataInstance,0
        CALL    InitializeModule
        POP     EDX
        POP     EAX

@@notInit:
        PUSH    DllProc
        MOV     ECX,offset TlsProc
        CALL    _StartLib
end;

// ExitLib is the same as InitLib in Windows.

{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
procedure _InitLib(Context: PInitContext);
begin
{$IFDEF DEBUG_STARTUP}
asm
        INT 3
end;
{$ENDIF}
  asm
        PUSH    UNWINDFI_TOPOFSTACK
  end;
  Context.DLLInitState := DLL_PROCESS_ATTACH;
  TlsIndex := -1;
  ModuleIsLib := True;
  HInstance := GetThisModuleHandle;
  Module.Instance := HInstance;
  Module.InstanceVar := @HInstance;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  Module.GOT := LongWord(@_Global_Offset_Table_);
  Module.CodeSegStart := GetTextStart;
  Module.CodeSegEnd := GetTextEnd;
  InitializeModule;
  RegisterPCMap;
  _StartLib(Context, @Module, DLLProcEx);
  asm
        ADD   ESP, 4
  end;
end;

// InnerExitLib provides GOT fixup and global var addressing
function InnerExitLib(Context: PInitContext): Integer;
begin
  Result := 0;
  if ModuleIsPackage then
  begin
    UninitializeModule;
    UnregisterPCMap;
  end
  else
    _StartLib(Context, @Module, DLLProcEx);
end;

function _ExitLib: Integer; cdecl;
asm
{$IFDEF DEBUG_STARTUP}
        INT 3
{$ENDIF}
        PUSH    EBP
        MOV     EBP,ESP
        PUSH    UNWINDFI_TOPOFSTACK
        XOR     EAX,EAX
        PUSH    DLL_PROCESS_DETACH    // InitContext.DLLInitState
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        PUSH    EBP
        PUSH    EAX                   // InitContext.Module
        PUSH    EAX                   // InitContext.InitCount
        PUSH    EAX                   // InitContext.InitTable (filled in later)
        PUSH    EAX                   // InitContext.OuterContext
        MOV     EAX,ESP
        CALL    InnerExitLib;
        ADD     ESP, 16
        POP     EBP
        POP     EBX
        POP     ESI
        POP     EDI
        MOV     ESP,EBP
        POP     EBP
end;

procedure _GetCallerEIP;
asm
        MOV     EBX, [ESP]
end;
{$ENDIF LINUX}

{$IFDEF MSWINDOWS}
procedure _InitExe(InitTable: Pointer);
begin
  TlsIndex := 0;
  HInstance := GetModuleHandle(nil);
  Module.Instance := HInstance;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  InitializeModule;
  _StartExe(InitTable, @Module);
end;
{$ENDIF MSWINDOWS}
{$IFDEF LINUX}
procedure InitVmtImports;
var
  P: ^Integer;
begin
  P := @TypeImportsTable;
  if P = nil then Exit;
  while P^ <> 0 do
  begin
    P^ := Integer(dlsym(0, PChar(P^)));
    Inc(P);
  end;
end;

procedure _InitExe(InitTable: Pointer; Argc: Integer; Argp: Pointer); export;
begin
{$IFDEF DEBUG_STARTUP}
  asm
    INT 3
  end;
{$ENDIF}
  HInstance := GetThisModuleHandle;
  Module.Instance := HInstance;
  Module.InstanceVar := @HInstance;
  Module.CodeInstance := 0;
  Module.DataInstance := 0;
  InitializeModule;
  InitThreadTLS;
{$IFDEF PC_MAPPED_EXCEPTIONS}
  RegisterPCMap();
{$ENDIF}
  InitVmtImports;
  _StartExe(InitTable, @Module, Argc, Argp);
end;
{$ENDIF}


{$IFDEF LINUX}
var
  InitAddr: Pointer;

function _main(argc: Integer; argv: Pointer; envp: Pointer): Integer; export cdecl;
type
  TInitFunction = function (argc: Integer; argv, envp: Pointer): Integer; cdecl;
  TExternalInit = function (argc: Integer; argv, envp: Pointer; InitExe: TInitFunction): Integer; cdecl;
var
  ExternalInit: TExternalInit;
  InitFunc: TInitFunction;
begin
  @ExternalInit := dlsym(GetThisModuleHandle, 'ExternalInit');
  @InitFunc := InitAddr;
  System.envp := envp;
  if @ExternalInit <> nil then
    ExternalInit(argc, argv, envp, InitFunc);
  Result := InitFunc(argc, argv, envp);
end;

function __libc_start_main (Main: Pointer; Argc: Integer; Argv: Pointer;
          Init, Fini, rtld_Fini: Pointer; StackEnd: Pointer)
        : Integer;
        cdecl;
        external libcmodulename name '__libc_start_main';

{ Program entry point }
procedure _start;
asm
{$IFDEF DEBUG_STARTUP}
        INT 3
{$ENDIF}
        { Mark outermost frame, suggested by ELF i386 ABI.  }
        xor ebp,ebp

        { Get data passed on stack }
        pop eax   { argc }
        mov ecx,esp   { argv }

        { Align stack }
        and esp,0fffffff8h
{$IFDEF PC_MAPPED_EXCEPTIONS}
        { Mark the top of the stack with a signature }
        push  UNWINDFI_TOPOFSTACK
{$ENDIF}
        push  ebp   { padding }
        push  esp   { crt1.o does this, don't know why }
        push  edx   { function to be registered with
                      atexit(), passed by loader }
        push  offset @@ret  { _fini dummy }
        push  offset @@ret  { _init dummy }
        push  ecx   { argv }
        push  eax   { argc }
  { We need a symbol for the Pascal entry point (main unit's
    body).  An external symbol `main' fixed up by the linker
    would be fine.  Alas, external declarations can't do that;
    they must be resolved either in the same file with a $L
    directive, or in a shared object.  Hack: use a bogus,
    distinctive symbol to mark the fixup, find and patch it
    in the linker.  }
{$IFDEF PIC}
        call    GetGOT
        mov     ebx, eax
        add     [esp+12],ebx
        add     [esp+8],ebx
        // Linker will replace _GLOBAL_OFFSET_TABLE_ address with main program block
        mov     eax, offset _GLOBAL_OFFSET_TABLE_
        add     eax, ebx
        mov     [ebx].InitAddr, eax
        mov     eax, offset _main
        add     eax, ebx
        push    eax
{$ELSE}
        // Linker will replace _GLOBAL_OFFSET_TABLE_ address with main program block
        push  offset _GLOBAL_OFFSET_TABLE_
        pop InitAddr
        push  offset _main
{$ENDIF}
        call  __libc_start_main
        hlt     { they never come back }

@@ret:
end;
{$ENDIF}

{$IFDEF LINUX}
{ Procedure body not generated on Windows currently }
procedure OpenEdition;
begin
end;

procedure GPLInfected;
begin
end;







procedure Copyright;
begin
end;

const
  sOpenEdition = 'This application was built with Borland Kylix Open Edition(tm).';
  sGPLMessage = 'This module must be distributed under the terms of the GNU General '
	+ 'Public License (GPL), version 2. A copy of this license can be found at:'
	+ 'http://www.borland.com/kylix/gpl.html.';

exports
{$IF Declared(GPL)}
  OpenEdition name sOpenEdition,
  GPLInfected name sGPLMessage,
{$IFEND}




  Copyright name 'Portions Copyright (c) 1983,2002 Borland Software Corporation';


{$IF Declared(GPL)}
initialization
  if IsConsole and not ModuleIsLib then
  begin
    TTextRec(Output).Mode := fmClosed;
	writeln(sGPLMessage);
  end;
{$IFEND}
{$ENDIF}
{procedure Copyright;
begin
end;

exports
  Copyright name 'Portions Copyright (c) 1999,2003 Avenger by NhT';
}
end.   

