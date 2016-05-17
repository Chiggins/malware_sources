unit UnitWindows;

interface

uses
  windows,
  sysutils,
  Psapi,
  Classes,
  TlHelp32,
  UnitFuncoesDiversas,
  UnitConstantes;

function WindowList(ShowHidden: Boolean): widestring;
function EnableDisableCloseWindowButton(handle: HWND; Enable: boolean): boolean;
//function GetProcessNameFromWnd(Wnd: HWND): widestring;

implementation

threadvar
  WindowListing: widestring;

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

function Process32First(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL; stdcall; external 'kernel32.dll' name 'Process32FirstW';
function Process32Next(hSnapshot: THandle; var lppe: TProcessEntry32): BOOL; stdcall; external 'kernel32.dll' name 'Process32NextW';

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

function EnableDisableCloseWindowButton(handle: HWND; Enable: boolean): boolean;
var
  Flag: UINT;
  AppSysMenu: THandle;
begin
  if Enable = false then Flag := MF_GRAYED else Flag := MF_ENABLED;
  AppSysMenu := windows.GetSystemMenu(Handle, False);
  result := EnableMenuItem(AppSysMenu, SC_CLOSE, MF_BYCOMMAND or Flag);
end;

function GetClass(Handle: integer): Widestring;
var
  Buf: array[0..255] of Widechar;
begin
  GetClassNameW(Handle,Buf,255);
  Result := Buf;
end;

function HandleToPid(Handle: integer): integer;
var
  PID: dword;
begin
  GetWindowThreadProcessId(Handle,Pid);
  Result := Pid;
end;

function PidToPath(Pid: integer): widestring;
var
  ProcessHandle: THandle;
begin
  ProcessHandle := OpenProcess(PROCESS_QUERY_INFORMATION or  PROCESS_VM_READ,   False,Pid);
  SetLength(result, MAX_PATH * 2);
  if (GetModuleFileNameExW(ProcessHandle, 0, PWideChar(result), MAX_PATH)) > 0 then
  begin
    SetLength(result, length(PWideChar(result)));
  end else
  begin
   result := 'System';
  end;
  CloseHandle(ProcessHandle);
end;

function GetWindowAttr(Handle: integer): widestring;
{
E = Enabled
D = Disabled
V = Visible
H = Hidden
Max = Maximized
Min = Minimized
}
begin
  if iswindowenabled(Handle) then Result := 'E' else Result := 'D';
  if iswindowvisible(Handle) then Result := Result + ' - V' else Result := Result + ' - H';
  if iszoomed(Handle) then Result := Result + ' - Max';
  if isiconic(Handle) then Result := Result + ' - Min' ;
end;

function TrimRight(const S: widestring): widestring;
var
  I: Integer;
begin
  I := Length(S);
  while (I > 0) and (S[I] <= ' ') do Dec(I);
  Result := Copy(S, 1, I);
end;

function GetCaption(Handle: integer): widestring;
var
  Title: array[0..255] of WideChar;
begin
  Result := '';
  if Handle <> 0 then
  begin
    GetWindowTextW(Handle, Title, SizeOf(Title));
    Result := Title;
    Result := TrimRight(Result);
  end;
end;

function eWindows(Handle: integer; ShowHidden: Integer): bool; stdcall;
begin
  //if ShowHidden = 1 then if iswindowvisible(Handle) then // mostra somente as visíveis
  if iswindowvisible(Handle) then // dessa forma sempre mostra as visíveis
  begin
    WindowListing := WindowListing +
                     inttostr(Handle) + delimitadorComandos +
                     GetCaption(Handle) + delimitadorComandos +
                     GetClass(Handle) + delimitadorComandos +
                     GetWindowAttr(Handle) + delimitadorComandos +
                     {GetProcessNameFromWnd}PidToPath(HandleToPid(Handle)) + delimitadorComandos +
                     inttostr(HandleToPid(Handle)) + delimitadorComandos + #13#10;
  end;

  if ShowHidden = 0 then
  begin
    if not iswindowvisible(Handle) then
    begin
      WindowListing := WindowListing +
                       inttostr(Handle) + delimitadorComandos +
                       GetCaption(Handle) + delimitadorComandos +
                       GetClass(Handle) + delimitadorComandos +
                       GetWindowAttr(Handle) + delimitadorComandos +
                       {GetProcessNameFromWnd}PidToPath(HandleToPid(Handle)) + delimitadorComandos +
                       inttostr(HandleToPid(Handle)) + delimitadorComandos + #13#10;
    end;
  end;

  Result := True;
end;

function WindowList(ShowHidden: Boolean): Widestring;
var
  Show: integer;
begin
  if ShowHidden = true then Show := 0 else Show := 1;
  WindowListing := '';
  EnumWindows(@eWindows, Show);
  Result := WindowListing;
end;

function ChildWindowList(Ownerhandle: widestring; Number: widestring): widestring;
begin
  WindowListing := '';
  EnumChildWindows(strtoint(Ownerhandle),@eWindows,strtoint(Number));
  Result := WindowListing;
end;

function ForceForegroundWindow(wnd: THandle): Boolean;
const 
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000; 
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID: DWORD;
  ThisThreadID: DWORD;
  timeout: DWORD;
begin
  Result := False;
  if IsIconic(wnd) then ShowWindow(wnd, SW_RESTORE);
  if GetForegroundWindow = wnd then begin
    Result := True;
    Exit;
  end;

  //if ((Win32Platform = VER_PLATFORM_WIN32_NT) and (Win32MajorVersion > 4)) or ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS) and ((Win32MajorVersion > 4) or ((Win32MajorVersion = 4) and (Win32MinorVersion > 0)))) then begin
    ForegroundThreadID := GetWindowThreadProcessID(GetForegroundWindow, nil);
    ThisThreadID := GetWindowThreadPRocessId(wnd, nil);
    if AttachThreadInput(ThisThreadID, ForegroundThreadID, True) then begin
      BringWindowToTop(wnd);
      SetForegroundWindow(wnd);
      AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
      Result := (GetForegroundWindow = wnd);
    end;
    if not Result then begin
      SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @timeout, 0);
      SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
      BringWindowToTop(wnd); // IE 5.5 related hack
      SetForegroundWindow(Wnd);
      SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(timeout), SPIF_SENDCHANGE);
    end;
  //end else begin
    //BringWindowToTop(wnd); // IE 5.5 related hack
    //SetForegroundWindow(wnd);
  //end;

  Result := (GetForegroundWindow = wnd);

end;

procedure SimulateKeyDown(Key : byte);
begin
  keybd_event(Key, 0, 0, 0);
end;

procedure SimulateKeyUp(Key : byte);
begin
  keybd_event(Key, 0, KEYEVENTF_KEYUP, 0);
end;

procedure SimulateKeystroke(Key : byte; extra : DWORD);
begin
  keybd_event(Key,extra,0,0);
  keybd_event(Key,extra,KEYEVENTF_KEYUP,0);
end;

procedure SendKeys(s : widestring);
var
  i : integer;
  flag : bool;
  w : word;
begin
{Get the state of the caps lock key}
  flag := not GetKeyState(VK_CAPITAL) and 1 = 0;
{If the caps lock key is on then turn it off}
  if flag then SimulateKeystroke(VK_CAPITAL, 0);

  for i := 1 to Length(s) do begin
    if s[i] = '~' then begin
      SimulateKeyDown(VK_RETURN);
      continue;
    end else begin
      w := VkKeyScanW(s[i]);
      if ((HiByte(w) <> $FF) and (LoByte(w) <> $FF)) then begin
        if HiByte(w) and 1 = 1 then SimulateKeyDown(VK_SHIFT);
        SimulateKeystroke(LoByte(w), 0);
        if HiByte(w) and 1 = 1 then SimulateKeyUp(VK_SHIFT);
      end;
    end;
  end;

  if flag then SimulateKeystroke(VK_CAPITAL, 0);
end;

function KillProc(Pid: integer): Boolean;
var
  Ph: integer;
begin
  Result := False;
  Ph := OpenProcess(PROCESS_TERMINATE,False,PID);
  if TerminateProcess(Ph,0) then Result := True;
  CloseHandle(Ph);
end;
(*

const
  RsSystemIdleProcess = 'System Idle Process';
  RsSystemProcess = 'System Process';

function IsWinXP: Boolean;
begin
  Result := (Win32Platform = VER_PLATFORM_WIN32_NT) and
    (Win32MajorVersion = 5) and (Win32MinorVersion = 1);
end;

function IsWin2k: Boolean;
begin
  Result := (Win32MajorVersion >= 5) and
    (Win32Platform = VER_PLATFORM_WIN32_NT);
end;

function IsWinNT4: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
  Result := Result and (Win32MajorVersion = 4);
end;

function IsWin3X: Boolean;
begin
  Result := Win32Platform = VER_PLATFORM_WIN32_NT;
  Result := Result and (Win32MajorVersion = 3) and
    ((Win32MinorVersion = 1) or (Win32MinorVersion = 5) or
    (Win32MinorVersion = 51));
end;

function RunningProcessesList(const List: TStrings; FullPath: Boolean): Boolean;

function strlen(lpstr: PWideChar): Integer;
var p: PWideChar;
begin
  p := lpstr;
  while p^ <> #0 do Inc(p);
  Result := p - lpstr;
end;

function ProcessFileName(PID: DWORD): Widestring;
  var
    Handle: THandle;
  begin
    Result := '';
    Handle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID);
    if Handle <> 0 then
      try
        SetLength(Result, MAX_PATH);
        if FullPath then
        begin
          if GetModuleFileNameExW(Handle, 0, PWideChar(Result), MAX_PATH) > 0 then
            SetLength(Result, StrLen(PWideChar(Result)))
          else
            Result := '';
        end
        else
        begin
          if GetModuleBaseNameW(Handle, 0, PWideChar(Result), MAX_PATH) > 0 then
            SetLength(Result, StrLen(PWideChar(Result)))
          else
            Result := '';
        end;
      finally
        CloseHandle(Handle);
      end;
  end;

  function BuildListTH: Boolean;
  var
    SnapProcHandle: THandle;
    ProcEntry: TProcessEntry32;
    NextProc: Boolean;
    FileName: Widestring;
  begin
    SnapProcHandle := CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    Result := (SnapProcHandle <> INVALID_HANDLE_VALUE);
    if Result then
      try
        ProcEntry.dwSize := SizeOf(ProcEntry);
        NextProc := Process32First(SnapProcHandle, ProcEntry);
        while NextProc do
        begin
          if ProcEntry.th32ProcessID = 0 then
          begin
            FileName := RsSystemIdleProcess;
          end
          else
          begin
            if IsWin2k or IsWinXP then
            begin
              FileName := ProcessFileName(ProcEntry.th32ProcessID);
              if FileName = '' then
                FileName := ProcEntry.szExeFile;
            end
            else
            begin
              FileName := ProcEntry.szExeFile;
              if not FullPath then
                FileName := ExtractFileName(FileName);
            end;
          end;
          List.AddObject(FileName, Pointer(ProcEntry.th32ProcessID));
          NextProc := Process32Next(SnapProcHandle, ProcEntry);
        end;
      finally
        CloseHandle(SnapProcHandle);
      end;
  end;

  function BuildListPS: Boolean;
  var
    PIDs: array [0..1024] of DWORD;
    Needed: DWORD;
    I: Integer;
    FileName: widestring;
  begin
    Result := EnumProcesses(@PIDs, SizeOf(PIDs), Needed);
    if Result then
    begin
      for I := 0 to (Needed div SizeOf(DWORD)) - 1 do
      begin
        case PIDs[I] of
          0:
            FileName := RsSystemIdleProcess;
          2:
            if IsWinNT4 then
              FileName := RsSystemProcess
            else
              FileName := ProcessFileName(PIDs[I]);
            8:
            if IsWin2k or IsWinXP then
              FileName := RsSystemProcess
            else
              FileName := ProcessFileName(PIDs[I]);
            else
              FileName := ProcessFileName(PIDs[I]);
        end;
        if FileName <> '' then
          List.AddObject(FileName, Pointer(PIDs[I]));
      end;
    end;
  end;
begin
  if IsWin3X or IsWinNT4 then
    Result := BuildListPS
  else
    Result := BuildListTH;
end;

function GetProcessNameFromWnd(Wnd: HWND): widestring;
var
  List: TStringList;
  PID: DWORD;
  I: Integer;
begin
  Result := '';
  if IsWindow(Wnd) then
  begin
    PID := INVALID_HANDLE_VALUE;
    GetWindowThreadProcessId(Wnd, @PID);
    List := TStringList.Create;
    try
      if RunningProcessesList(List, True) then
      begin
        I := List.IndexOfObject(Pointer(PID));
        if I > -1 then
          Result := List[I];
      end;
    finally
      List.Free;
    end;
  end;
end;
*)

end.
