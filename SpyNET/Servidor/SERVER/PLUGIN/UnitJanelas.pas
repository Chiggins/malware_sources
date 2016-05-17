unit UnitJanelas;

interface

uses
  Windows,
  Messages,
  TLhelp32,
  PsAPI,
  UnitServerUtils;

procedure FecharJanela(Janela: THandle);
procedure MostrarJanela(Janela: THandle);
procedure OcultarJanela(Janela: THandle);
procedure MaximizarJanela(Janela: THandle);
procedure MinimizarJanela(Janela: THandle);
procedure MinimizarTodas;
function GetProcessNameFromWnd(Wnd: HWND): string;

implementation

uses
  UnitDiversos;
  
var
  Win32Platform: integer;
  Win32MajorVersion: Integer;
  Win32MinorVersion: Integer;
  Win32BuildNumber: Integer;
  Win32CSDVersion: string;

procedure InitPlatformId;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  if GetVersionEx(OSVersionInfo) then
    with OSVersionInfo do
    begin
      Win32Platform := dwPlatformId;
      Win32MajorVersion := dwMajorVersion;
      Win32MinorVersion := dwMinorVersion;
      if Win32Platform = VER_PLATFORM_WIN32_WINDOWS then
        Win32BuildNumber := dwBuildNumber and $FFFF
      else
        Win32BuildNumber := dwBuildNumber;
      Win32CSDVersion := szCSDVersion;
    end;
end;

function RunningProcessesList(var List: String; FullPath: Boolean): Boolean;

function ProcessFileName(PID: DWORD): string; 
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
          if GetModuleFileNameEx(Handle, 0, PChar(Result), MAX_PATH) > 0 then
            SetLength(Result, StrLen(PChar(Result))) 
          else 
            Result := ''; 
        end 
        else 
        begin
          if GetModuleBaseNameA(Handle, 0, PChar(Result), MAX_PATH) > 0 then 
            SetLength(Result, StrLen(PChar(Result))) 
          else 
            Result := ''; 
        end; 
      finally
        CloseHandle(Handle); 
      end; 
  end; 
  
const
  RsSystemIdleProcess = 'Idle';
  RsSystemProcess = 'System';

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

function BuildListTH: Boolean;
  var 
    SnapProcHandle: THandle; 
    ProcEntry: TProcessEntry32; 
    NextProc: Boolean; 
    FileName: string; 
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
          List := List + inttostr(ProcEntry.th32ProcessID) + '#|#' + FileName + '#|#';
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
    FileName: string; 
  begin 
    Result := EnumProcesses(@PIDs, SizeOf(PIDs), Needed); 
    if Result then 
    begin 
      for I := 0 to (Needed div SizeOf(DWORD)) - 1 do 
      begin 
        case PIDs[i] of 
          0: 
            FileName := RsSystemIdleProcess; 
          2:
            if IsWinNT4 then 
              FileName := RsSystemProcess 
            else 
              FileName := ProcessFileName(PIDs[i]); 
            8: 
            if IsWin2k or IsWinXP then 
              FileName := RsSystemProcess 
            else 
              FileName := ProcessFileName(PIDs[i]); 
            else
              FileName := ProcessFileName(PIDs[i]);
        end;
        if FileName <> '' then List := List + inttostr(PIDs[i]) + '#|#' + FileName + '#|#';
      end;
    end; 
  end; 
begin 
  if IsWin3X or IsWinNT4 then 
    Result := BuildListPS 
  else 
    Result := BuildListTH;
end;

function GetProcessNameFromWnd(Wnd: HWND): string;
var
  List: String;
  PID: DWORD; 
  I: Integer; 
begin 
  Result := '';
  if IsWindow(Wnd) then 
  begin
    PID := INVALID_HANDLE_VALUE; 
    GetWindowThreadProcessId(Wnd, @PID); 
    try
      if RunningProcessesList(List, True) then
      begin 
        if pos(inttostr(PID) + '#|#', list) > 0 then
        begin
          delete(List, 1, pos(inttostr(PID) + '#|#', List) - 1);
          delete(List, 1, pos('#|#', List) - 1);
          delete(List, 1, 3);
          result := copy(List, 1, pos('#|#', List) - 1);
        end;
      end;
      except
    end;
  end;
end; 

procedure FecharJanela(Janela: THandle);
begin
  PostMessage(Janela, WM_CLOSE, 0, 0);
//  PostMessage(Janela, WM_DESTROY, 0, 0);
//  PostMessage(Janela, WM_QUIT, 0, 0);
end;

procedure MostrarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_SHOW);
  ShowWindow(janela, SW_NORMAL);
end;

procedure OcultarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_HIDE);
end;

procedure MaximizarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_MAXIMIZE);
end;

procedure MinimizarJanela(Janela: THandle);
begin
  ShowWindow(janela, SW_MINIMIZE);
end;

procedure MinimizarTodas;
begin
  keybd_event(VK_LWIN,MapvirtualKey( VK_LWIN,0),0,0) ;
  keybd_event(Ord('M'),MapvirtualKey(Ord('M'),0),0,0);
  keybd_event(Ord('M'),MapvirtualKey(Ord('M'),0),KEYEVENTF_KEYUP,0);
  keybd_event(VK_LWIN,MapvirtualKey(VK_LWIN,0),KEYEVENTF_KEYUP,0);
end;

initialization
  InitPlatformId;

end.
