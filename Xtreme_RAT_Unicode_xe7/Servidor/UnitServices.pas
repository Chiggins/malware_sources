unit UnitServices;

interface

uses
  winsvc,
  windows,
  UnitConstantes,
  UnitFuncoesDiversas;

function ServiceList: widestring;
function InstallService(ServiceName: widestring; DisplayName: widestring; FileName: widestring; Desc: widestring; StartType: integer; StartNow: integer): boolean;
function EditService(ServiceName: widestring; DisplayName: widestring; FileName: widestring; Desc: widestring; StartType: integer): boolean;
function StopService(ServiceName: widestring): boolean;
function StartService(ServiceName: widestring): boolean;
function RemoveService(ServiceName: widestring): boolean;

implementation

function IntToStr(i: Int64): wideString;
begin
  Str(i, Result);
end;

function StrToInt(S: wideString): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function RegReadString(Key: HKey; SubKey: widestring; DataType: integer; Data: widestring): widestring;
var
  RegKey: HKey;
  Buffer: array[0..9999] of wideChar;
  BufSize: Integer;
begin
  BufSize := SizeOf(Buffer);
  Result := '';
  if RegOpenKeyW(Key,pWideChar(SubKey),RegKey) = ERROR_SUCCESS then begin;
    if RegQueryValueExW(RegKey, pWideChar(Data), nil,  @DataType, @Buffer, @BufSize) = ERROR_SUCCESS then begin;
      RegCloseKey(RegKey);
      Result := widestring(Buffer);
    end;
  end;
end;

function StopService(ServiceName: widestring): boolean;
var
  SCManager: SC_Handle;
  Service: SC_Handle;
  ServiceStatus: TServiceStatus;
begin
  result := false;
  SCManager := OpenSCManagerW(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    Service := OpenServiceW(SCManager, pWideChar(ServiceName), SERVICE_ALL_ACCESS);
    result := ControlService(Service, SERVICE_CONTROL_STOP, ServiceStatus);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

function StartService(ServiceName: widestring): boolean;
var
  SCManager: SC_Handle;
  Service: SC_Handle;
  ARgs: pwidechar;
begin
  result := false;
  SCManager := OpenSCManagerW(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    Service := OpenServiceW(SCManager, pWideChar(ServiceName), SERVICE_ALL_ACCESS);
    Args := nil;
    result := winsvc.StartServiceW(Service, 0, ARgs);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

function RemoveService(ServiceName: widestring): boolean;
var
  SCManager: SC_Handle;
  Service: SC_Handle;
  Status: TServiceStatus;
begin
  result := false;
  SCManager := OpenSCManagerW(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then
  begin
    CloseServiceHandle(SCManager);
    Exit;
  end;
  try
    Service := OpenServiceW(SCManager, pWideChar(ServiceName), SERVICE_ALL_ACCESS);
    ControlService(Service, SERVICE_CONTROL_STOP, Status);
    result := DeleteService(Service);
    CloseServiceHandle(Service);
  finally
    CloseServiceHandle(SCManager);
    deletarchave(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Services\' + ServiceName);
  end;
end;

function RegWriteString(Key: HKey; SubKey: widestring; DataType: integer; Data: widestring; Value: widestring): widestring;
var
  RegKey: HKey;
begin
  Result := '';
  if RegCreateKeyW(Key,pWideChar(SubKey),RegKey) = ERROR_SUCCESS then begin;
    RegSetValueExW(RegKey,pWideChar(Data),0,DataType,pWideChar(Value),Length(Value) * 2);
    RegCloseKey(RegKey);
  end;
end;

function EditService(ServiceName: widestring; DisplayName: widestring; FileName: widestring; Desc: widestring; StartType: integer): boolean;
var
  SCManager: SC_Handle;
  Service: SC_Handle;
begin
  Result := false;
  if (Trim(ServiceName) = '') and not FileExists(pWideChar(Filename)) then Exit;

  SCManager := OpenSCManagerW(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    Service := OpenServiceW(SCManager,pWideChar(ServiceName),SERVICE_CHANGE_CONFIG);
    Result := ChangeServiceConfigW(Service,SERVICE_NO_CHANGE,StartType,SERVICE_NO_CHANGE,pWideChar(FileName),nil,nil,nil,nil,nil,pWideChar(DisplayName));
    if Result = true then
    RegWriteString(HKEY_LOCAL_MACHINE,'SYSTEM\CurrentControlSet\Services\' + ServiceName + '\',REG_SZ,'Description',Desc);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

function InstallService(ServiceName: widestring; DisplayName: widestring; FileName: widestring; Desc: widestring; StartType: integer; StartNow: integer): boolean;
var
  SCManager: SC_Handle;
begin
  Result := false;
  if (Trim(ServiceName) = '') and not FileExists(pWideChar(Filename)) then Exit;

  SCManager := OpenSCManagerW(nil, nil, SC_MANAGER_ALL_ACCESS);
  if SCManager = 0 then Exit;
  try
    result := CreateServiceW(SCManager, pWideChar(ServiceName), pWideChar(DisplayName), SERVICE_ALL_ACCESS, SERVICE_WIN32_OWN_PROCESS, STartType, SERVICE_ERROR_IGNORE, pWideChar(FileName), nil, nil, nil, nil, nil) <> 0;
    if result = true then result := EditService(ServiceName,DisplayName,FileName,Desc,StartType);
    if (result = true) and (STartNow = 1) then StartService(ServiceName);
  finally
    CloseServiceHandle(SCManager);
  end;
end;

function RegReadDword(Key: HKey; SubKey: widestring; Data: widestring): dword;
var
  RegKey: HKey;
  Value, ValueLen: dword;
begin
  ValueLen := 1024;
  RegOpenKeyW(Key,pWideChar(SubKey),RegKey);
  RegQueryValueExW(RegKey, pWideChar(Data), nil, nil, @Value, @ValueLen);
  RegCloseKey(RegKey);
  Result := Value;
end;

function serviceExists(sService: widestring): boolean;
var
  schm, schs: SC_Handle;
begin
  schm :=0;
  schs := 0;
  schm := OpenSCManagerW(nil, nil, SC_MANAGER_CONNECT);
  if (schm <> 0) then
  schs := OpenServiceW(schm, PWideChar(sService), SERVICE_QUERY_CONFIG)
  else
  result:= (schs <> 0);
end;

function RegKeyExists(RootKey: HKEY; Name: wideString): boolean;
var
  hTemp: HKEY;
begin
  Result := False;
  if RegOpenKeyExW(RootKey, PWideChar(Name), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
  begin
    Result := True;
    RegCloseKey(hTemp);
  end;
end;

function ServiceList: widestring;
var
  ServiceLoop: integer;
  SCManager: SC_Handle;
  nBytesNeeded, nServices, nResumeHandle: dword;
  ServiceStatus: array [0..511] of TEnumServiceStatusW;
begin
                                       //SC_MANAGER_ALL_ACCESS
  SCManager := OpenSCManagerW(nil, Nil, SC_MANAGER_CONNECT or SC_MANAGER_ENUMERATE_SERVICE);
  if SCManager = 0 then Exit;
  //nResumeHandle := 0;
                                //SERVICE_TYPE_ALL
  EnumServicesStatusW(SCManager, SERVICE_WIN32, SERVICE_STATE_ALL, ServiceStatus[0], sizeof(ServiceStatus), nBytesNeeded, nServices, nResumeHandle);
  for ServiceLoop := 0 to nServices - 1 do
  begin
    if serviceExists(ServiceStatus[ServiceLoop].lpServiceName)= false then continue;
    if RegKeyExists(HKEY_LOCAL_MACHINE, 'SYSTEM\CurrentControlSet\Services\' + ServiceStatus[ServiceLoop].lpServiceName) = false then continue;

    result := result + ServiceStatus[ServiceLoop].lpDisplayName + delimitadorComandos;
    result := result + ServiceStatus[ServiceLoop].lpServiceName + delimitadorComandos;
    result := result + inttostr(ServiceStatus[ServiceLoop].ServiceStatus.dwCurrentState) + delimitadorComandos;
    result := result + inttostr(RegReadDword(HKEY_LOCAL_MACHINE,'SYSTEM\CurrentControlSet\Services\' + ServiceStatus[ServiceLoop].lpServiceName,'Start')) + delimitadorComandos;
    result := result + RegReadString(HKEY_LOCAL_MACHINE,'SYSTEM\CurrentControlSet\Services\' + ServiceStatus[ServiceLoop].lpServiceName,REG_SZ,'ImagePath') + delimitadorComandos;
    result := result + RegReadString(HKEY_LOCAL_MACHINE,'SYSTEM\CurrentControlSet\Services\' + ServiceStatus[ServiceLoop].lpServiceName,REG_SZ,'Description') + delimitadorComandos + #13#10;
  end;
  CloseServiceHandle(SCManager);
end;

end.
