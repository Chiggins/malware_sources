unit UnitServicos;

interface

uses
  Windows,
  winsvc;

function ServiceStatus(sService: string; Change:bool; StartStop: bool): string;
function ServiceList: string;
function InstallService(ServiceName, DisplayName: pchar; FileName: string): bool;
function UninstallService(sService: string): bool;
function ServiceStringCode(nID : integer): string;

implementation

uses
  UnitDiversos,
  UnitServerUtils,
  UnitListarProcessos;

function GetServiceDescription(ServiceName: String): String;
begin
  result := lerreg(HKEY_LOCAL_MACHINE, pchar('System\CurrentControlSet\Services\' + ServiceName), 'Description', '');
end;

function ServiceStringCode(nID: integer): string;
begin
  result := '0';
  case nID of
    SERVICE_STOPPED: Result := inttostr(SERVICE_STOPPED);
    SERVICE_RUNNING: Result := inttostr(SERVICE_RUNNING);
    SERVICE_PAUSED: Result := inttostr(SERVICE_PAUSED);
    SERVICE_START_PENDING: Result := inttostr(SERVICE_START_PENDING);
    SERVICE_STOP_PENDING: Result := inttostr(SERVICE_STOP_PENDING);
    SERVICE_CONTINUE_PENDING: Result := inttostr(SERVICE_CONTINUE_PENDING);
    SERVICE_PAUSE_PENDING: Result := inttostr(SERVICE_PAUSE_PENDING);
  end;
end;

function ServiceStatus(sService: string; Change: bool; StartStop: bool): string;
var
  schm, schs: SC_Handle;
  ss: TServiceStatus;
  psTemp: PChar;
  s_s: dword;
begin
  Result := '';

  ss.dwCurrentState := 0;
  psTemp := nil;                  
  schm := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if (schm > 0) then
  begin
    if StartStop = true then s_s := SERVICE_START else s_s := SERVICE_STOP;
    schs:= OpenService(schm, pchar(sService), s_s or SERVICE_QUERY_STATUS);
    if (schs > 0) then
    begin
      if change = true
      then if StartStop = true
      then StartService(schs, 0, psTemp)
      else ControlService(schs, SERVICE_CONTROL_STOP, ss);
      QueryServiceStatus(schs, ss);
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
  Result := ServiceStringCode(ss.dwCurrentState);
end;

function UninstallService(sService: string): bool;
var
  schm, schs : SC_Handle;
begin
  result := false;

  schm := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if (schm > 0) then
  begin
    schs := OpenService(schm, pchar(sService), $10000);
    if (schs > 0) then
    begin
      if DeleteService(schs) then result := true;
      CloseServiceHandle(schs);
    end;
    CloseServiceHandle(schm);
  end;
end;

function ServiceList: string;
var
  j, i: integer;
  schm: SC_Handle;
  nBytesNeeded, nServices, nResumeHandle: DWord;
  ServiceStatusRecs: array[0..511] of TEnumServiceStatus;
begin
  Result := '';
                                  //SC_MANAGER_ALL_ACCESS
  schm := OpenSCManager(nil, Nil, SC_MANAGER_CONNECT or SC_MANAGER_ENUMERATE_SERVICE);
  if (schm = 0) then Exit;
  nResumeHandle := 0;
  while True do
  begin
    EnumServicesStatus(schm, SERVICE_TYPE_ALL, SERVICE_STATE_ALL, ServiceStatusRecs[0], sizeof(ServiceStatusRecs), nBytesNeeded, nServices, nResumeHandle);
    for j:=0 to nServices-1 do
    begin
      if ServiceStatusRecs[j].lpServiceName = '' then Result := result + ' ®' else
        Result := result + ServiceStatusRecs[j].lpServiceName + '®'; // Nome verdadeiro

      if ServiceStatusRecs[j].lpDisplayName = '' then result := result + ' ®' else
        Result := result + ServiceStatusRecs[j].lpDisplayName + '®'; // Nome do serviço (o que aparece no msconfig)

      Result := result + GetServiceDescription(ServiceStatusRecs[j].lpServiceName) + ' ®'; // Nome do serviço (o que aparece no msconfig)
      result := result + ServiceStatus(ServiceStatusRecs[j].lpServiceName, false, false) + ' ®';
    end;
    if (nBytesNeeded = 0) then Break;
  end;
  if (schm > 0) then CloseServiceHandle(schm);
end;

function InstallService(ServiceName, DisplayName: pchar; FileName: string): bool;
var
  SCManager: SC_HANDLE;
  Service: SC_HANDLE;
  Args: pchar;
begin
  result := false;
  SetTokenPrivileges;
  SCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    Service := CreateService(SCManager,
                             ServiceName,
                             ServiceName,
                             SERVICE_ALL_ACCESS,
                             SERVICE_WIN32_OWN_PROCESS or SERVICE_INTERACTIVE_PROCESS,
                             SERVICE_AUTO_START,
                             SERVICE_ERROR_IGNORE,
                             pchar(FileName),
                             nil,
                             nil,
                             nil,
                             nil,
                             nil);
    write2reg(HKEY_LOCAL_MACHINE, pchar('System\CurrentControlSet\Services\' + ServiceName), 'Description', pchar(DisplayName));
    Args := nil;
    CloseServiceHandle(Service);
    CloseServiceHandle(SCManager);
    except
    exit;
  end;
  result := true;
end;

end.
