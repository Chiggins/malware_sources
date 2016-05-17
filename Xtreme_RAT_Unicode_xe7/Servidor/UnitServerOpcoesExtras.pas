Unit UnitServerOpcoesExtras;

interface

uses
  windows,
  mmSystem,
  PSAPI,
  UnitFuncoesDiversas,
  messages,
  SysUtils;

function setsuspendstate(Hibernate, ForceCritical, NoWakeEvent:boolean): integer; stdcall; external 'powrprof.dll' name 'SetSuspendState';
function WindowsExit(RebootParam: Longword): Boolean;
function Hibernar(Hibernate, ForceCritical, NoWakeEvent: boolean): integer;
procedure ShowDesktop(const YesNo : boolean) ;
procedure ShowStartButton(bValue: Boolean);
procedure TaskBarHIDE(bool: boolean);
procedure TraySHOW;
procedure TrayHIDE;
procedure AbrirCD;
procedure FecharCD;
procedure SwapMouseButtons(bValue: Boolean);

implementation

procedure SwapMouseButtons(bValue: Boolean);
begin
  if bValue then
    SystemParametersInfo(SPI_SETMOUSEBUTTONSWAP, 1, nil, 0)
  else
    SystemParametersInfo(SPI_SETMOUSEBUTTONSWAP, 0, nil, 0);
end;

procedure AbrirCD;
begin
  mciSendString('Set cdaudio door open wait', nil, 0, 0);
end;

procedure FecharCD;
begin
  mciSendString('Set cdaudio door closed wait', nil, 0, 0);
end;

procedure TraySHOW;
var
  TopWindow : HWND;
begin
  TopWindow:= FindWindow('Shell_TrayWnd', nil) ;
  TopWindow:= FindWindowEx(TopWindow,0, 'TrayNotifyWnd', nil) ;
  TopWindow:= FindWindowEx(TopWindow,0, 'SysPager', nil) ;
  ShowWindow( TopWindow,Sw_Show) ;
end;

procedure TrayHIDE;
var
  TopWindow : HWND;
begin
  TopWindow:= FindWindow('Shell_TrayWnd', nil) ;
  TopWindow:= FindWindowEx(TopWindow,0, 'TrayNotifyWnd', nil) ;
  TopWindow:= FindWindowEx(TopWindow,0, 'SysPager', nil) ;
  ShowWindow( TopWindow,Sw_Hide) ;
end;

procedure TaskBarHIDE(bool: boolean);
var
  TopWindow : HWND;
begin
  TopWindow:= FindWindow('Shell_TrayWnd', nil);
  if bool = false then ShowWindow(TopWindow, Sw_Hide) else
  ShowWindow(TopWindow, Sw_show);
end;

function StrPas(const Str: PChar): ansistring;
begin
  Result := Str;
end;

procedure ShowStartButton(bValue: Boolean);
var
  Tray, Child: hWnd;
  C:           array[0..127] of char;
  S:           ansiString;
begin
  Tray  := FindWindow('Shell_TrayWnd', nil);
  Child := GetWindow(Tray, GW_CHILD);
  while Child <> 0 do
  begin
    if GetClassName(Child, C, SizeOf(C)) > 0 then
    begin
      S := StrPAS(C);
      if UpperCase(S) = 'BUTTON' then
      begin
        if bValue = True then ShowWindow(Child, 1)
        else
          ShowWindow(Child, 0);
      end;
    end;
    Child := GetWindow(Child, GW_HWNDNEXT);
  end;
end;

procedure ShowDesktop(const YesNo : boolean) ;
var h : THandle;
begin
  h := FindWindow('ProgMan', nil) ;
  h := GetWindow(h, GW_CHILD) ;
  if YesNo = True then
    ShowWindow(h, SW_SHOW)
  else
    ShowWindow(h, SW_HIDE) ;
end;

function WindowsExit(RebootParam: Longword): Boolean;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  tpResult := OpenProcessToken(GetCurrentProcess(),
                               TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
                               TTokenHd) ;
  if tpResult then
  begin
    tpResult := LookupPrivilegeValue(nil,
                                     SE_SHUTDOWN_NAME,
                                     TTokenPvg.Privileges[0].Luid) ;
    TTokenPvg.PrivilegeCount := 1;
    TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    cbtpPrevious := SizeOf(rTTokenPvg) ;
    pcbtpPreviousRequired := 0;
    if tpResult then
    Windows.AdjustTokenPrivileges(TTokenHd,
                                  False,
                                  TTokenPvg,
                                  cbtpPrevious,
                                  rTTokenPvg,
                                  pcbtpPreviousRequired) ;
  end;
  Result := ExitWindowsEx(RebootParam, 0) ;
end;

function Hibernar(Hibernate, ForceCritical, NoWakeEvent: boolean): integer;
var
  TTokenHd: THandle;
  TTokenPvg: TTokenPrivileges;
  cbtpPrevious: DWORD;
  rTTokenPvg: TTokenPrivileges;
  pcbtpPreviousRequired: DWORD;
  tpResult: Boolean;
const
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
begin
  tpResult := OpenProcessToken(GetCurrentProcess(),
                               TOKEN_ADJUST_PRIVILEGES or TOKEN_QUERY,
                               TTokenHd) ;
  if tpResult then
  begin
    tpResult := LookupPrivilegeValue(nil,
                                     SE_SHUTDOWN_NAME,
                                     TTokenPvg.Privileges[0].Luid) ;
    TTokenPvg.PrivilegeCount := 1;
    TTokenPvg.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    cbtpPrevious := SizeOf(rTTokenPvg) ;
    pcbtpPreviousRequired := 0;
    if tpResult then
    Windows.AdjustTokenPrivileges(TTokenHd,
                                  False,
                                  TTokenPvg,
                                  cbtpPrevious,
                                  rTTokenPvg,
                                  pcbtpPreviousRequired) ;
  end;
  Result := SetSuspendState(Hibernate, ForceCritical, NoWakeEvent);
end;


end.