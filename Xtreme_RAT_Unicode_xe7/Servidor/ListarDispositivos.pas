Unit ListarDispositivos;

interface

uses
  StrUtils,windows,
  SetupAPI,
  DeviceHelper;

const
  NumDevices = 500;

procedure ReleaseDeviceList;
procedure InitDeviceList(ShowHidden: boolean);
function FillDeviceList(var DeviceClassesCount: integer; var DevicesCount: integer): widestring;
function ShowDeviceAdvancedInfo(const DeviceIndex: Integer): widestring;
function ShowDeviceInterfaces(const DeviceIndex: Integer): widestring;
procedure StartDevicesVar;
procedure StopDevicesVar;
function IntToHex(Value: Integer; Digits: Integer): widestring; overload;
function IntToHex(Value: Int64; Digits: Integer): widestring; overload;

implementation

const
  Separador = '@@##&&';
var
  ClassImageListData: TSPClassImageListData;
  hAllDevices: HDEVINFO;
  DeviceHelper: TDeviceHelper;
  tvRoot: array [0..NumDevices] of widestring;
  LastRoot: integer = 0;

procedure CvtInt;
{ IN:
    EAX:  The integer value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[16]
    ECX:  Base for conversion: 0 for signed decimal, 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Length of converted text
}
asm
        OR      CL,CL
        JNZ     @CvtLoop
@C1:    OR      EAX,EAX
        JNS     @C2
        NEG     EAX
        CALL    @C2
        MOV     AL,'-'
        INC     ECX
        DEC     ESI
        MOV     [ESI],AL
        RET
@C2:    MOV     ECX,10

@CvtLoop:
        PUSH    EDX
        PUSH    ESI
@D1:    XOR     EDX,EDX
        DIV     ECX
        DEC     ESI
        ADD     DL,'0'
        CMP     DL,'0'+10
        JB      @D2
        ADD     DL,('A'-'0')-10
@D2:    MOV     [ESI],DL
        OR      EAX,EAX
        JNE     @D1
        POP     ECX
        POP     EDX
        SUB     ECX,ESI
        SUB     EDX,ECX
        JBE     @D5
        ADD     ECX,EDX
        MOV     AL,'0'
        SUB     ESI,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX],AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI],AL
@D5:
end;

function IntToHex(Value: Integer; Digits: Integer): widestring;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
        CMP     EDX, 32        // Digits < buffer length?
        JBE     @A1
        XOR     EDX, EDX
@A1:    PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 32
        PUSH    ECX            // result ptr
        MOV     ECX, 16        // base 16     EDX = Digits = field width
        CALL    CvtInt
        MOV     EDX, ESI
        POP     EAX            // result ptr
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 32
        POP     ESI
end;

procedure CvtInt64;
{ IN:
    EAX:  Address of the int64 value to be converted to text
    ESI:  Ptr to the right-hand side of the output buffer:  LEA ESI, StrBuf[32]
    ECX:  Base for conversion: 0 for signed decimal, or 10 or 16 for unsigned
    EDX:  Precision: zero padded minimum field width
  OUT:
    ESI:  Ptr to start of converted text (not start of buffer)
    ECX:  Byte length of converted text
}
asm
        OR      CL, CL
        JNZ     @start             // CL = 0  => signed integer conversion
        MOV     ECX, 10
        TEST    [EAX + 4], $80000000
        JZ      @start
        PUSH    [EAX + 4]
        PUSH    [EAX]
        MOV     EAX, ESP
        NEG     [ESP]              // negate the value
        ADC     [ESP + 4],0
        NEG     [ESP + 4]
        CALL    @start             // perform unsigned conversion
        MOV     [ESI-1].Byte, '-'  // tack on the negative sign
        DEC     ESI
        INC     ECX
        ADD     ESP, 8
        RET

@start:   // perform unsigned conversion
        PUSH    ESI
        SUB     ESP, 4
        FNSTCW  [ESP+2].Word     // save
        FNSTCW  [ESP].Word       // scratch
        OR      [ESP].Word, $0F00  // trunc toward zero, full precision
        FLDCW   [ESP].Word

        MOV     [ESP].Word, CX
        FLD1
        TEST    [EAX + 4], $80000000 // test for negative
        JZ      @ld1                 // FPU doesn't understand unsigned ints
        PUSH    [EAX + 4]            // copy value before modifying
        PUSH    [EAX]
        AND     [ESP + 4], $7FFFFFFF // clear the sign bit
        PUSH    $7FFFFFFF
        PUSH    $FFFFFFFF
        FILD    [ESP + 8].QWord     // load value
        FILD    [ESP].QWord
        FADD    ST(0), ST(2)        // Add 1.  Produces unsigned $80000000 in ST(0)
        FADDP   ST(1), ST(0)        // Add $80000000 to value to replace the sign bit
        ADD     ESP, 16
        JMP     @ld2
@ld1:
        FILD    [EAX].QWord         // value
@ld2:
        FILD    [ESP].Word          // base
        FLD     ST(1)
@loop:
        DEC     ESI
        FPREM                       // accumulator mod base
        FISTP   [ESP].Word
        FDIV    ST(1), ST(0)        // accumulator := acumulator / base
        MOV     AL, [ESP].Byte      // overlap long FPU division op with int ops
        ADD     AL, '0'
        CMP     AL, '0'+10
        JB      @store
        ADD     AL, ('A'-'0')-10
@store:
        MOV     [ESI].Byte, AL
        FLD     ST(1)           // copy accumulator
        FCOM    ST(3)           // if accumulator >= 1.0 then loop
        FSTSW   AX
        SAHF
        JAE @loop

        FLDCW   [ESP+2].Word
        ADD     ESP,4

        FFREE   ST(3)
        FFREE   ST(2)
        FFREE   ST(1);
        FFREE   ST(0);

        POP     ECX             // original ESI
        SUB     ECX, ESI        // ECX = length of converted string
        SUB     EDX,ECX
        JBE     @done           // output longer than field width = no pad
        SUB     ESI,EDX
        MOV     AL,'0'
        ADD     ECX,EDX
        JMP     @z
@zloop: MOV     [ESI+EDX].Byte,AL
@z:     DEC     EDX
        JNZ     @zloop
        MOV     [ESI].Byte,AL
@done:
end;

function IntToHex(Value: Int64; Digits: Integer): widestring;
//  FmtStr(Result, '%.*x', [Digits, Value]);
asm
        CMP     EAX, 32        // Digits < buffer length?
        JLE     @A1
        XOR     EAX, EAX
@A1:    PUSH    ESI
        MOV     ESI, ESP
        SUB     ESP, 32        // 32 chars
        MOV     ECX, 16        // base 10
        PUSH    EDX            // result ptr
        MOV     EDX, EAX       // zero filled field width: 0 for no leading zeros
        LEA     EAX, Value;
        CALL    CvtInt64

        MOV     EDX, ESI
        POP     EAX            // result ptr
        CALL    System.@LStrFromPCharLen
        ADD     ESP, 32
        POP     ESI
end;

function IntToStr(i: Integer): wideString;
begin
  Str(i, Result);
end;

function StrToInt(S: wideString): Integer;
begin
  Val(S, Result, Result);
end;

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

function FindRootNode(ClassName: widestring): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to NumDevices do
  begin
    if copy(tvroot[i], 1, posex(Separador, tvroot[i]) - 1) = ClassName then
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
  hAllDevices := SetupDiGetClassDevsEx(nil, nil, 0,
    dwFlags, nil, nil, nil);
  //if hAllDevices = PINVALID_HANDLE_VALUE then RaiseLastOSError;
  DeviceHelper.DeviceListHandle := hAllDevices;
end;

function FillDeviceList(var DeviceClassesCount: integer; var DevicesCount: integer): widestring;
var
  dwIndex: DWORD;
  DeviceInfoData: SP_DEVINFO_DATA;
  DeviceName, DeviceClassName: wideString;
  ClassGUID: TGUID;

  RootAtual, i: integer;
  TempStr: widestring;
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



        //setstring(TempStr, pwidechar(@ClassGUID), sizeof(ClassGUID) * 2);
        SetLength(TempStr, sizeof(ClassGUID) * 2);
        CopyMemory(@TempStr[1], @ClassGUID, sizeof(ClassGUID) * 2);



        tvRoot[RootAtual] := tvRoot[RootAtual] + TempStr + '##' + separador; // ClassGUID para pegar a ImageIndex
        tvRoot[RootAtual] := tvRoot[RootAtual] + '-1' + separador + #13#10; // StateIndex
        Inc(DeviceClassesCount);
      end;

      if length(DeviceName) > 1 then
      begin
        tvRoot[RootAtual] := tvRoot[RootAtual] + '@@' + DeviceName + Separador; // DeviceName



        //setstring(TempStr, pwidechar(@DeviceInfoData.ClassGuid), sizeof(DeviceInfoData.ClassGuid));
        SetLength(TempStr, sizeof(DeviceInfoData.ClassGuid));
        CopyMemory(@TempStr[1], @DeviceInfoData.ClassGuid, sizeof(DeviceInfoData.ClassGuid));



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

function GUIDToString(const GUID: TGUID): widestring;
var
  P: PWideChar;
begin
  Succeeded(StringFromCLSID(GUID, P));
  Result := P;
  CoTaskMemFree(P);
end;

function ShowDeviceAdvancedInfo(const DeviceIndex: Integer): widestring;
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

function ShowDeviceInterfaces(const DeviceIndex: Integer): widestring;
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

initialization
  LoadSetupApi;

end.
