Unit UnitInjectProcess;

interface

uses
  windows,
  functions;
function InjectIntoProces(hProc : Cardinal; pFunctionToInject, RemoteStructAddr: Pointer): Pointer;
function CreateAndGetProcessHandle(ProcName: pWideChar; var ProcInfo: TProcessInformation): Cardinal;
function InjectIntoProcess(hProc : Cardinal; pFunctionToInject, RemoteStructAddr: Pointer): Pointer;
procedure Init_IsWow64Process;
implementation

function InjectIntoProcess(hProc : Cardinal; pFunctionToInject, RemoteStructAddr: Pointer): Pointer;
  {$if CompilerVersion<=28}
type
  NativeÚInt = Cardinal;
{$ifend}
var
  pdosheader   : PIMAGEDOSHEADER;
  pntheader    : PIMAGENTHEADERS;
  dwsize       : DWORD;
  dwimagebase  : DWORD;
  bw : Nativeuint;
  ThreadId : Cardinal;
  pRemoteBase : Pointer;
begin
  result := nil;
  pdosheader  := Pointer(GetModuleHandle(nil));
  pntheader   := Pointer(Cardinal(pdosheader) + pdosheader^._lfanew);
  dwsize      := pntheader^.OptionalHeader.SizeOfImage;
  dwimagebase := pntheader^.OptionalHeader.ImageBase;

  VirtualFreeEx(hProc, Pointer(dwimagebase),0,MEM_RELEASE);
  pRemoteBase := VirtualAllocEx(hProc,Pointer(dwimagebase),dwsize,MEM_COMMIT OR MEM_RESERVE,PAGE_EXECUTE_READWRITE);
  if (Cardinal(pRemoteBase) = 0) Then  exit; //imagebase schon belegt, relocation nötig ;)
  WriteProcessMemory(hProc,Pointer(dwimagebase),Pointer(GetModuleHandle(nil)),dwsize,bw);
  if bw < dwsize Then exit;
  CreateRemoteThread(hProc,nil,0,pFunctionToInject,RemoteStructAddr,0,ThreadId);
  CloseHandle(hProc);
  result := pRemoteBase;
end;

function InjectIntoProces(hProc : Cardinal; pFunctionToInject, RemoteStructAddr: Pointer): Pointer;
  {$if CompilerVersion<=28}
type
  NativeÚInt = Cardinal;
{$ifend}
var
  pdosheader   : PIMAGEDOSHEADER;
  pntheader    : PIMAGENTHEADERS;
  dwsize       : DWORD;
  dwimagebase  : DWORD;
  bw : Nativeuint;
  ThreadId : Cardinal;
  pRemoteBase : Pointer;
begin
  result := nil;
  pdosheader  := Pointer(GetModuleHandle(nil));
  pntheader   := Pointer(Cardinal(pdosheader) + pdosheader^._lfanew);
  dwsize      := pntheader^.OptionalHeader.SizeOfImage;
  dwimagebase := pntheader^.OptionalHeader.ImageBase;

  VirtualFreeEx(hProc, Pointer(dwimagebase),0,MEM_RELEASE);
  pRemoteBase := VirtualAllocEx(hProc,Pointer(dwimagebase),dwsize,MEM_COMMIT OR MEM_RESERVE,PAGE_EXECUTE_READWRITE);
  if (Cardinal(pRemoteBase) = 0) Then  exit; //imagebase schon belegt, relocation nötig ;)
  WriteProcessMemory(hProc,nil,Pointer(GetModuleHandle(nil)),dwsize,bw);
  if bw < dwsize Then exit;
  CreateRemoteThread(hProc,nil,0,pFunctionToInject,RemoteStructAddr,0,ThreadId);
  CloseHandle(hProc);
  result := pRemoteBase;
end;

type
  TIsWow64Process = function(Handle:THandle; var IsWow64 : BOOL) : BOOL; stdcall;
var
  IsWow64Process  : TIsWow64Process;

procedure Init_IsWow64Process;
var
  hKernel32      : Integer;
begin
  hKernel32 := LoadLibrary(kernel32);
  try
    IsWow64Process := GetProcAddress(hkernel32, 'IsWow64Process');
  finally
    FreeLibrary(hKernel32);
  end;
end;

function PidIs64BitsProcess(dwProcessId: DWORD): Boolean;
var
  IsWow64        : BOOL;
  PidHandle      : THandle;
begin
  Result := False;
  if Assigned(IsWow64Process) then
  begin
    //check if the current app is running under WOW
    if IsWow64Process(GetCurrentProcess(), IsWow64) then Result := IsWow64;

    //the current delphi App is not running under wow64, so the current Window OS is 32 bit
    //and obviously all the apps are 32 bits.
    if not Result then Exit;

    PidHandle := OpenProcess(PROCESS_QUERY_INFORMATION,False,dwProcessId);
    if PidHandle > 0 then
    try
      if (IsWow64Process(PidHandle, IsWow64)) then Result := not IsWow64
    finally
      CloseHandle(PidHandle);
    end;
  end;
end;

function CreateAndGetProcessHandle(ProcName: pWideChar; var ProcInfo: TProcessInformation): Cardinal;
var
  StartInfo: TStartupInfo;
begin
  Result := 0;
  ZeroMemory(@StartInfo, SizeOf(StartupInfo));
  if CreateProcessW(nil, ProcName, nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo) then
  begin
    Result := ProcInfo.hProcess;

    Init_IsWow64Process;
    if PidIs64BitsProcess(ProcInfo.dwProcessId) = True then
    begin
      Result := 0;
      TerminateProcess(ProcInfo.hProcess, 0);
      ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
      ZeroMemory(@StartInfo, SizeOf(StartupInfo));

      if CreateProcessW(nil, SomarPWideChar('explorer.exe',''), nil, nil, False, CREATE_SUSPENDED, nil, nil, StartInfo, ProcInfo) then
      begin
        Result := ProcInfo.hProcess;
      end else
      begin
        ZeroMemory(@ProcInfo, SizeOf(ProcInfo));
        ZeroMemory(@StartInfo, SizeOf(StartupInfo));
        Result := 0;
      end;
    end;
    sleep(100);
  end;
end;

end.