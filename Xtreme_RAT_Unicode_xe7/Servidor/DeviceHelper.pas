unit DeviceHelper;

interface

uses
  Windows,
  SetupApi,
  Common;

type
  TDeviceHelper = class
  private
    FDeviceInfoData: SP_DEVINFO_DATA;
    FDeviceListHandle: HDEVINFO;
  protected
    function GetBinary(PropertyCode: Integer;
      pData: Pointer; dwSize: DWORD): Boolean; virtual;
    function GetDWORD(PropertyCode: Integer): DWORD; virtual;
    function GetGuid(PropertyCode: Integer): TGUID; virtual;
    function GetString(PropertyCode: Integer): widestring; virtual;
    function GetPolicy(PropertyCode: Integer): widestring; virtual;
  public
    function Capabilities: widestring;
    function Characteristics: widestring;
    function ConfigFlags: widestring;
    function DeviceClassDescription: widestring; overload;
    function DeviceClassDescription(DeviceTypeGUID: TGUID): widestring; overload;
    function InstallState: widestring;
    function PowerData: widestring;
    function LegacyBusType: widestring;
  public
    property Address: DWORD index SPDRP_ADDRESS read GetDWORD;
    property BusTypeGUID: TGUID index SPDRP_BUSTYPEGUID read GetGuid;
    property BusNumber: DWORD index SPDRP_BUSNUMBER read GetDWORD;
    property ClassGUID: TGUID index SPDRP_CLASSGUID read GetGuid;
    property CompatibleIDS: WideString index SPDRP_COMPATIBLEIDS read GetString;

    property DeviceClassName: WideString index SPDRP_CLASS read GetString;
    //property DeviceType: xxx index SPDRP_DEVTYPE read xxx;
    property DriverName: WideString index SPDRP_DRIVER read GetString;
    property Description: WideString index SPDRP_DEVICEDESC read GetString;

    property Enumerator: WideString index SPDRP_ENUMERATOR_NAME read GetString;
    //property Exclusive: xxx index SPDRP_EXCLUSIVE read xxx;

    property FriendlyName: WideString index SPDRP_FRIENDLYNAME read GetString;
    property HardwareID: WideString index SPDRP_HARDWAREID read GetString;

    property Service: WideString index SPDRP_SERVICE read GetString;
    //property Security: xxx index SPDRP_SECURITY read xxx;
    //property SecuritySDS: xxx index SPDRP_SECURITY_SDS read xxx;

    property Location: WideString index SPDRP_LOCATION_INFORMATION read GetString;
    property LowerFilters: WideString index SPDRP_LOWERFILTERS read GetString;
    property Manufacturer: WideString index SPDRP_MFG read GetString;
    property PhisicalDriverName: WideString
      index SPDRP_PHYSICAL_DEVICE_OBJECT_NAME read GetString;

    property RemovalPolicy: WideString index SPDRP_REMOVAL_POLICY
      read GetPolicy;
    property RemovalPolicyHWDefault: WideString
      index SPDRP_REMOVAL_POLICY_HW_DEFAULT read GetPolicy;
    property RemovalPolicyOverride: WideString index SPDRP_REMOVAL_POLICY_OVERRIDE
      read GetPolicy;

    property UINumber: DWORD index SPDRP_UI_NUMBER read GetDWORD;
    property UINumberDecription: WideString index SPDRP_UI_NUMBER_DESC_FORMAT
      read GetString;
    property UpperFilters: WideString index SPDRP_UPPERFILTERS read GetString;
  public
    property DeviceInfoData: SP_DEVINFO_DATA read FDeviceInfoData
      write FDeviceInfoData;
    property DeviceListHandle: HDEVINFO read FDeviceListHandle
      write FDeviceListHandle;
  end;

procedure CoTaskMemFree(pv: Pointer); stdcall; external 'ole32.dll' name 'CoTaskMemFree';
function StringFromCLSID(const clsid: TGUID; out psz: PWideChar): HResult; stdcall; external 'ole32.dll' name 'StringFromCLSID';
function CLSIDFromString(psz: PWideChar; out clsid: TGUID): HResult; stdcall; external 'ole32.dll' name 'CLSIDFromString';

implementation

uses
  ListarDispositivos;

{ TDeviceHelper }

function HasFlag(const Value, dwFlag: DWORD): Boolean;
begin
  Result := (Value and dwFlag) = dwFlag;
end;

procedure AddToResult(var AResult: widestring; const Value: widestring);
begin
  if AResult = '' then
    AResult := Value
  else
    AResult := AResult + ', ' + Value;
end;

function ExtractMultiString(const Value: widestring): widestring;
var
  P: PwideChar;
begin
  P := @Value[1];
  while P^ <> #0 do
  begin
    if Result <> '' then
      Result := Result + ', ';
    Result := Result + P;
    Inc(P, lstrlenw(P) + 1);
  end;
end;

function TDeviceHelper.Capabilities: widestring;
var
  I: Integer;
  dwCapabilities: DWORD;
begin
  Result := '';
  dwCapabilities := GetDWORD(SPDRP_CAPABILITIES);
  for I := 0 to 9 do
    if HasFlag(dwCapabilities, CapabilitiesRelationships[I].Flag) then
      AddToResult(Result, CapabilitiesRelationships[I].Desc);
end;

function TDeviceHelper.Characteristics: widestring;
var
  dwCharacteristics: DWORD;
begin
  dwCharacteristics := GetDWORD(SPDRP_CHARACTERISTICS);
  //if dwCharacteristics <> 0 then Beep;
end;

function TDeviceHelper.ConfigFlags: widestring;
var
  I: Integer;
  dwConfigFlags: DWORD;
begin
  Result := '';
  dwConfigFlags := GetDWORD(SPDRP_CONFIGFLAGS);
  for I := 0 to 15 do
    if HasFlag(dwConfigFlags, ConfigFlagRelationships[I].Flag) then
      AddToResult(Result, ConfigFlagRelationships[I].Desc);    
end;

function TDeviceHelper.DeviceClassDescription(DeviceTypeGUID: TGUID): widestring;
var
  dwRequiredSize: DWORD;
begin
  Result := '';
  dwRequiredSize := 0;
  SetupDiGetClassDescriptionW(DeviceTypeGUID, nil, 0, dwRequiredSize);
  if GetLastError = ERROR_INSUFFICIENT_BUFFER then
  begin
    SetLength(Result, dwRequiredSize * 2);
    SetupDiGetClassDescriptionW(DeviceTypeGUID, @Result[1], dwRequiredSize, dwRequiredSize);
  end;
  Result := PwideChar(Result);
end;

function TDeviceHelper.DeviceClassDescription: widestring;
var
  AGUID: TGUID;
begin
  AGUID := ClassGUID;
  Result := DeviceClassDescription(AGUID);
end;

function TDeviceHelper.GetBinary(PropertyCode: Integer; pData: Pointer;
  dwSize: DWORD): Boolean;
var
  dwPropertyRegDataType, dwRequiredSize: DWORD;
begin
  dwRequiredSize := 0;
  dwPropertyRegDataType := REG_BINARY;
  Result := SetupDiGetDeviceRegistryPropertyW(DeviceListHandle, DeviceInfoData,
    PropertyCode, dwPropertyRegDataType, pData,
    dwSize, dwRequiredSize);
end;

function TDeviceHelper.GetDWORD(PropertyCode: Integer): DWORD;
var
  dwPropertyRegDataType, dwRequiredSize: DWORD;
begin
  Result := 0;
  dwRequiredSize := 4;
  dwPropertyRegDataType := REG_DWORD;
  SetupDiGetDeviceRegistryPropertyW(DeviceListHandle, DeviceInfoData,
    PropertyCode, dwPropertyRegDataType, @Result,
    dwRequiredSize, dwRequiredSize);
end;

function StringToGUID(const S: widestring): TGUID;
begin
  Succeeded(CLSIDFromString(PWideChar(WideString(S)), Result))
end;

function TDeviceHelper.GetGuid(PropertyCode: Integer): TGUID;
var
  dwPropertyRegDataType, dwRequiredSize: DWORD;
  StringGUID: widestring;
begin
  ZeroMemory(@Result, SizeOf(TGUID));
  StringGUID := GetString(PropertyCode);
  if StringGUID = '' then
  begin
    dwRequiredSize := 0;
    dwPropertyRegDataType := REG_BINARY;
    SetupDiGetDeviceRegistryPropertyW(DeviceListHandle, DeviceInfoData,
      PropertyCode, dwPropertyRegDataType, nil, 0, dwRequiredSize);
    if GetLastError = ERROR_INSUFFICIENT_BUFFER then
    begin
      SetupDiGetDeviceRegistryPropertyW(DeviceListHandle, DeviceInfoData,
        PropertyCode, dwPropertyRegDataType, @Result,
        dwRequiredSize, dwRequiredSize);
    end;
  end
  else
    Result := StringToGUID(StringGUID);
end;

function TDeviceHelper.GetPolicy(PropertyCode: Integer): widestring;
var
  dwPolicy: DWORD;
begin
  dwPolicy := GetDWORD(PropertyCode);
  if dwPolicy > 0 then  
    case dwPolicy of
      CM_REMOVAL_POLICY_EXPECT_NO_REMOVAL:
        Result := 'CM_REMOVAL_POLICY_EXPECT_NO_REMOVAL';
      CM_REMOVAL_POLICY_EXPECT_ORDERLY_REMOVAL:
        Result := 'CM_REMOVAL_POLICY_EXPECT_ORDERLY_REMOVAL';
      CM_REMOVAL_POLICY_EXPECT_SURPRISE_REMOVAL:
        Result := 'CM_REMOVAL_POLICY_EXPECT_SURPRISE_REMOVAL';
    else
      Result := 'unknown 0x' + IntToHex(dwPolicy, 8);
    end;
end;

function TDeviceHelper.GetString(PropertyCode: Integer): widestring;
var
  dwPropertyRegDataType, dwRequiredSize: DWORD;
begin
  Result := '';
  dwRequiredSize := 0;
  dwPropertyRegDataType := REG_SZ;
  SetupDiGetDeviceRegistryPropertyW(DeviceListHandle, DeviceInfoData,
    PropertyCode, dwPropertyRegDataType, nil, 0, dwRequiredSize);
  if not (dwPropertyRegDataType in [REG_SZ, REG_MULTI_SZ]) then Exit;
  if GetLastError = ERROR_INSUFFICIENT_BUFFER then
  begin
    SetLength(Result, dwRequiredSize * 2);
    SetupDiGetDeviceRegistryPropertyW(DeviceListHandle, DeviceInfoData,
      PropertyCode, dwPropertyRegDataType, @Result[1],
      dwRequiredSize, dwRequiredSize);
  end;
  case dwPropertyRegDataType of
    REG_SZ: Result := PWideChar(Result);
    REG_MULTI_SZ: Result := ExtractMultiString(Result);
  end;
end;

function TDeviceHelper.InstallState: widestring;
var
  dwInstallState: DWORD;
begin
  dwInstallState := GetDWORD(SDRP_INSTALL_STATE);
  case dwInstallState of
    CM_INSTALL_STATE_INSTALLED:
      Result := 'CM_INSTALL_STATE_INSTALLED';
    CM_INSTALL_STATE_NEEDS_REINSTALL:
      Result := 'CM_INSTALL_STATE_NEEDS_REINSTALL';
    CM_INSTALL_STATE_FAILED_INSTALL:
      Result := 'CM_INSTALL_STATE_FAILED_INSTALL';
    CM_INSTALL_STATE_FINISH_INSTALL:
      Result := 'CM_INSTALL_STATE_FINISH_INSTALL';
  else
    Result := 'unknown 0x' + IntToHex(dwInstallState, 8);
  end;
end;

function TDeviceHelper.LegacyBusType: widestring;
var
  BusType: Integer;
begin
  BusType := Integer(GetDWORD(SPDRP_LEGACYBUSTYPE));
  case BusType of
    -1: Result := 'InterfaceTypeUndefined';
    00: Result := 'Internal';
    01: Result := 'Isa';
    02: Result := 'Eisa';
    03: Result := 'MicroChannel';
    04: Result := 'TurboChannel';
    05: Result := 'PCIBus';
    06: Result := 'VMEBus';
    07: Result := 'NuBus';
    08: Result := 'PCMCIABus';
    09: Result := 'CBus';
    10: Result := 'MPIBus';
    11: Result := 'MPSABus';
    12: Result := 'ProcessorInternal';
    13: Result := 'InternalPowerBus';
    14: Result := 'PNPISABus';
    15: Result := 'PNPBus';
    16: Result := 'MaximumInterfaceType';
  else
    Result := 'unknown 0x' + IntToHex(BusType, 8);
  end;
end;

function TDeviceHelper.PowerData: widestring;
var
  I: Integer;
  pPowerData: TCM_Power_Data;
begin
  Result := '';
  if GetBinary(SPDRP_DEVICE_POWER_DATA, @pPowerData,
    SizeOf(TCM_Power_Data)) then
  begin
    for I := 0 to 8 do
      if HasFlag(pPowerData.PD_Capabilities, PDCAPRelationships[I].Flag) then
        AddToResult(Result, PDCAPRelationships[I].Desc);
  end;
end;

end.
