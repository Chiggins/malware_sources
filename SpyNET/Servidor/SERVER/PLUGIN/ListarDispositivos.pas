Unit ListarDispositivos;

interface

uses
  windows,
  SetupAPI,
  DeviceHelper,
  UnitServerUtils,
  UnitRegistro;

const
  NumDevices = 500;
  Separador = '@@##&&';
  
var
  ClassImageListData: TSPClassImageListData;
  hAllDevices: HDEVINFO;
  DeviceHelper: TDeviceHelper;
  tvRoot: array [0..NumDevices] of string;
  LastRoot: integer = 0;

procedure ReleaseDeviceList;
procedure InitDeviceList(ShowHidden: boolean);
function FillDeviceList(var DeviceClassesCount: integer; var DevicesCount: integer): string;
function ShowDeviceAdvancedInfo(const DeviceIndex: Integer): string;
function ShowDeviceInterfaces(const DeviceIndex: Integer): string;
procedure StartDevicesVar;
procedure StopDevicesVar;

implementation

procedure StartDevicesVar;
begin
  LoadSetupApi;
  DeviceHelper := TDeviceHelper.Create;
  InitDeviceList(true);
end;

procedure StopDevicesVar;
begin
  DeviceHelper.Free;
  ReleaseDeviceList;
end;


function FindRootNode(ClassName: string): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to NumDevices do
  begin
    if copy(tvroot[i], 1, pos(Separador, tvroot[i]) - 1) = ClassName then
    begin
      result := i;
      break;
    end;
  end;
end;

procedure ReleaseDeviceList;
begin
  SetupDiDestroyDeviceInfoList(hAllDevices);
end;

procedure InitDeviceList(ShowHidden: boolean);
const
  PINVALID_HANDLE_VALUE = Pointer(INVALID_HANDLE_VALUE);
var
  dwFlags: DWORD;
begin
  dwFlags := DIGCF_ALLCLASSES;// or DIGCF_DEVICEINTERFACE;
  if not ShowHidden then dwFlags := dwFlags or DIGCF_PRESENT;
  hAllDevices := SetupDiGetClassDevsExA(nil, nil, 0,
    dwFlags, nil, nil, nil);
  //if hAllDevices = PINVALID_HANDLE_VALUE then RaiseLastOSError;
  DeviceHelper.DeviceListHandle := hAllDevices;
end;

function FillDeviceList(var DeviceClassesCount: integer; var DevicesCount: integer): string;
var
  dwIndex: DWORD;
  DeviceInfoData: SP_DEVINFO_DATA;
  DeviceName, DeviceClassName: String;
  ClassGUID: TGUID;

  RootAtual, i: integer;
  TempStr: string;
begin
  for i := 0 to NumDevices do tvRoot[i] := '';
  if LastRoot > 0 then LastRoot := 0;

  dwIndex := 0;
  DeviceClassesCount := 0;
  DevicesCount := 0;

  ZeroMemory(@DeviceInfoData, SizeOf(SP_DEVINFO_DATA));
  DeviceInfoData.cbSize := SizeOf(SP_DEVINFO_DATA);

  while SetupDiEnumDeviceInfo(hAllDevices, dwIndex, DeviceInfoData) do
  begin
    DeviceHelper.DeviceInfoData := DeviceInfoData;

    DeviceName := DeviceHelper.FriendlyName;

    if DeviceName = '' then DeviceName := DeviceHelper.Description;

    ClassGUID := DeviceHelper.ClassGUID;

    DeviceClassName := DeviceHelper.DeviceClassDescription(ClassGUID);

    if length(DeviceClassName) > 1 then
    begin
      RootAtual := FindRootNode(DeviceClassName);
      if RootAtual = -1 then
      begin
        RootAtual := LastRoot;
        tvRoot[RootAtual] := tvRoot[RootAtual] + DeviceClassName + Separador; // DeviceType
        setstring(TempStr, pchar(@ClassGUID), sizeof(ClassGUID));
        tvRoot[RootAtual] := tvRoot[RootAtual] + TempStr + '##' + separador; // ClassGUID para pegar a ImageIndex
        tvRoot[RootAtual] := tvRoot[RootAtual] + '-1' + separador + #13#10; // StateIndex
        Inc(DeviceClassesCount);
      end;

      if length(DeviceName) > 1 then
      begin
        tvRoot[RootAtual] := tvRoot[RootAtual] + '@@' + DeviceName + Separador; // DeviceName
        setstring(TempStr, pchar(@DeviceInfoData.ClassGuid), sizeof(DeviceInfoData.ClassGuid));
        tvRoot[RootAtual] := tvRoot[RootAtual] + TempStr + '##' + separador; // ClassGUID para pegar a ImageIndex
        tvRoot[RootAtual] := tvRoot[RootAtual] + inttostr(Integer(dwIndex)) + Separador + #13#10; // StateIndex
      end;
    end;

    Inc(DevicesCount);
    Inc(LastRoot);
    Inc(dwIndex);
  end;
  for i := 0 to NumDevices do
  if tvRoot[i] <> '' then Result := Result + tvRoot[i];
end;

function CompareMem(P1, P2: Pointer; Length: Integer): Boolean; assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SAR     ECX,2
        JS      @@1     // Negative Length implies identity.
        REPE    CMPSD
        JNE     @@2
        MOV     ECX,EDX
        REPE    CMPSB
        JNE     @@2
@@1:    INC     EAX
@@2:    POP     EDI
        POP     ESI
end;

function GUIDToString(const GUID: TGUID): string;
var
  P: PWideChar;
begin
  Succeeded(StringFromCLSID(GUID, P));
  Result := P;
  CoTaskMemFree(P);
end;

function ShowDeviceAdvancedInfo(const DeviceIndex: Integer): string;
var
  DeviceInfoData: SP_DEVINFO_DATA;
  EmptyGUID, AGUID: TGUID;
  dwData: DWORD;
begin
  ZeroMemory(@EmptyGUID, SizeOf(TGUID));

  ZeroMemory(@DeviceInfoData, SizeOf(SP_DEVINFO_DATA));
  DeviceInfoData.cbSize := SizeOf(SP_DEVINFO_DATA);

  if not SetupDiEnumDeviceInfo(hAllDevices,
    DeviceIndex, DeviceInfoData) then Exit;

  DeviceHelper.DeviceInfoData := DeviceInfoData;

  if DeviceHelper.Description <> '' then result := result + 'Device Description: ' + Separador + DeviceHelper.Description + Separador + #13#10;
  if DeviceHelper.HardwareID <> '' then result := result + 'Hardware IDs: ' + Separador +  DeviceHelper.HardwareID + Separador + #13#10;
  if DeviceHelper.CompatibleIDS <> '' then result := result + 'Compatible IDs: ' + Separador + DeviceHelper.CompatibleIDS + Separador + #13#10;
  if DeviceHelper.DriverName <> '' then result := result + 'Driver: ' + Separador + DeviceHelper.DriverName + Separador + #13#10;
  if DeviceHelper.DeviceClassName <> '' then result := result + 'Class name: ' + Separador + DeviceHelper.DeviceClassName + Separador + #13#10;
  if DeviceHelper.Manufacturer <> '' then result := result + 'Manufacturer: ' + Separador + DeviceHelper.Manufacturer + Separador + #13#10;
  if DeviceHelper.FriendlyName <> '' then result := result + 'Friendly Description: ' + Separador + DeviceHelper.FriendlyName + Separador + #13#10;
  if DeviceHelper.Location <> '' then result := result + 'Location Information: ' + Separador + DeviceHelper.Location + Separador + #13#10;
  if DeviceHelper.PhisicalDriverName <> '' then result := result + 'Device CreateFile Name: ' + Separador + DeviceHelper.PhisicalDriverName + Separador + #13#10;
  if DeviceHelper.Capabilities <> '' then result := result + 'Capabilities: ' + Separador + DeviceHelper.Capabilities + Separador + #13#10;
  if DeviceHelper.ConfigFlags <> '' then result := result + 'ConfigFlags: ' + Separador + DeviceHelper.ConfigFlags + Separador + #13#10;
  if DeviceHelper.UpperFilters <> '' then result := result + 'UpperFilters: ' + Separador + DeviceHelper.UpperFilters + Separador + #13#10;
  if DeviceHelper.LowerFilters <> '' then result := result + 'LowerFilters: ' + Separador + DeviceHelper.LowerFilters + Separador + #13#10;
  if DeviceHelper.LegacyBusType <> '' then result := result + 'LegacyBusType: ' + Separador + DeviceHelper.LegacyBusType + Separador + #13#10;
  if DeviceHelper.Enumerator <> '' then result := result + 'Enumerator: ' + Separador + DeviceHelper.Enumerator + Separador + #13#10;
  if DeviceHelper.Characteristics <> '' then result := result + 'Characteristics: ' + Separador + DeviceHelper.Characteristics + Separador + #13#10;
  if DeviceHelper.UINumberDecription <> '' then result := result + 'UINumberDecription: ' + Separador + DeviceHelper.UINumberDecription + Separador + #13#10;
  if DeviceHelper.RemovalPolicy <> '' then result := result + 'RemovalPolicy: ' + Separador + DeviceHelper.RemovalPolicy + Separador + #13#10;
  if DeviceHelper.RemovalPolicyHWDefault <> '' then result := result + 'RemovalPolicyHWDefault: ' + Separador + DeviceHelper.RemovalPolicyHWDefault + Separador + #13#10;
  if DeviceHelper.RemovalPolicyOverride <> '' then result := result + 'RemovalPolicyOverride: ' + Separador + DeviceHelper.RemovalPolicyOverride + Separador + #13#10;
  if DeviceHelper.InstallState <> '' then result := result + 'InstallState: ' + Separador + DeviceHelper.InstallState + Separador + #13#10;

  if not CompareMem(@EmptyGUID, @DeviceInfoData.ClassGUID, SizeOf(TGUID)) then
    result := result + 'Device GUID: ' + Separador + GUIDToString(DeviceInfoData.ClassGUID) + Separador + #13#10;

  AGUID := DeviceHelper.BusTypeGUID;
  if not CompareMem(@EmptyGUID, @AGUID, SizeOf(TGUID)) then
    result := result + 'Bus Type GUID: ' + Separador + GUIDToString(AGUID) + Separador + #13#10;

  dwData := DeviceHelper.UINumber;
  if dwData <> 0 then result := result + 'UI Number: ' + Separador + IntToStr(dwData) + Separador + #13#10;

  dwData := DeviceHelper.BusNumber;
  if dwData <> 0 then result := result + 'Bus Number: ' + Separador + IntToStr(dwData) + Separador + #13#10;

  dwData := DeviceHelper.Address;
  if dwData <> 0 then result := result + 'Device Address: ' + Separador + IntToStr(dwData) + Separador + #13#10;
end;

function ShowDeviceInterfaces(const DeviceIndex: Integer): string;
var
  hInterfaces: HDEVINFO;
  DeviceInfoData: SP_DEVINFO_DATA;
  DeviceInterfaceData: TSPDeviceInterfaceData;
  I: Integer;
begin
  ZeroMemory(@DeviceInfoData, SizeOf(SP_DEVINFO_DATA));
  DeviceInfoData.cbSize := SizeOf(SP_DEVINFO_DATA);

  ZeroMemory(@DeviceInterfaceData, SizeOf(TSPDeviceInterfaceData));
  DeviceInterfaceData.cbSize := SizeOf(TSPDeviceInterfaceData);

  if not SetupDiEnumDeviceInfo(hAllDevices,
    DeviceIndex, DeviceInfoData) then Exit;

  hInterfaces := SetupDiGetClassDevs(@DeviceInfoData.ClassGuid, nil, 0,
    DIGCF_PRESENT or DIGCF_INTERFACEDEVICE);
  //if not Assigned(hInterfaces) then RaiseLastOSError;
  try
    I := 0;
    while SetupDiEnumDeviceInterfaces(hInterfaces, nil,
      DeviceInfoData.ClassGuid, I, DeviceInterfaceData) do
    begin
      case DeviceInterfaceData.Flags of
        SPINT_ACTIVE:
          result := result + 'Interface State: ' + Separador + 'SPINT_ACTIVE' + Separador + #13#10;
        SPINT_DEFAULT:
          result := result + 'Interface State: ' + Separador + 'SPINT_DEFAULT' + Separador + #13#10;
        SPINT_REMOVED:
          result := result + 'Interface State: ' + Separador + 'SPINT_REMOVED' + Separador + #13#10;
      else
          result := result + 'Interface State: ' + Separador + 'unknown 0x' + IntToHex(DeviceInterfaceData.Flags, 8) + Separador + #13#10;
      end;
      Inc(I);
    end;

  finally
    SetupDiDestroyDeviceInfoList(hInterfaces);
  end;
end;

end.
