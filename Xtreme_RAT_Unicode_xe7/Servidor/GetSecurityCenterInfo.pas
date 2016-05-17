unit GetSecurityCenterInfo;

interface

uses
  SysUtils,
  Windows,
  ActiveX,
  ComObj,
  Variants;

type
  TSecurityCenterInfo = Class
    companyName: string;
    displayName: string;
    enableOnAccessUIMd5Hash: String; //Uint8;
    enableOnAccessUIParameters: String;
    instanceGuid: String;
    pathToEnableOnAccessUI: String;
    pathToSignedProductExe: String;
    pathToSignedReportingExe: String;
    pathToUpdateUI: String;
    enableUIMd5Hash: string;
    enableUIParameters: string;
    productState: String;
    pathToEnableUI: string;
    updateUIMd5Hash: String; //Uint8;
    updateUIParameters: String;
    versionNumber: String;
end;

type
  TSecurityCenterProduct = (AntiVirusProduct, AntiSpywareProduct, FirewallProduct);

procedure GetSecInfo(SecurityCenterProduct: TSecurityCenterProduct; var SecurityCenterInfo: TSecurityCenterInfo);

implementation

type
OSVERSIONINFOEX = packed record
  dwOSVersionInfoSize: DWORD;
  dwMajorVersion: DWORD;
  dwMinorVersion: DWORD;
  dwBuildNumber: DWORD;
  dwPlatformId: DWORD;
  szCSDVersion: array[0..127] of Char;
  wServicePackMajor: WORD;
  wServicePackMinor: WORD;
  wSuiteMask: WORD;
  wProductType: BYTE;
  wReserved: BYTE;
end;

DWORDLONG = UInt64;

const
  VER_MINORVERSION = $0000001;
  VER_MAJORVERSION = $0000002;
  VER_SERVICEPACKMINOR = $0000010;
  VER_SERVICEPACKMAJOR = $0000020;
  VER_PRODUCT_TYPE = $0000080;

const
  WmiRoot='root';
  WmiClassSCProduct     : array [TSecurityCenterProduct] of string = ('AntiVirusProduct','AntiSpywareProduct','FirewallProduct');
  WmiNamespaceSCProduct : array [Boolean] of string = ('SecurityCenter','SecurityCenter2');

function VerSetConditionMask(dwlConditionMask: int64;dwTypeBitMask: DWORD; dwConditionMask: Byte): int64; stdcall; external kernel32;

{$IFDEF UNICODE}
function VerifyVersionInfo(var LPOSVERSIONINFOEX : OSVERSIONINFOEX;dwTypeMask: DWORD;dwlConditionMask: int64): BOOL; stdcall; external kernel32 name 'VerifyVersionInfoW';
{$ELSE}
function VerifyVersionInfo(var LPOSVERSIONINFOEX : OSVERSIONINFOEX;dwTypeMask: DWORD;dwlConditionMask: int64): BOOL; stdcall; external kernel32 name 'VerifyVersionInfoA';
{$ENDIF}

//verifies that the application is running on Windows 2000 Server or a later server, such as Windows Server 2003 or Windows Server 2008.
function Is_Win_Server : Boolean;
const
   VER_NT_SERVER      = $0000003;
   VER_EQUAL          = 1;
   VER_GREATER_EQUAL  = 3;
var
   osvi             : OSVERSIONINFOEX;
   dwlConditionMask : DWORDLONG;
   op               : Integer;
begin
   dwlConditionMask := 0;
   op:=VER_GREATER_EQUAL;

   ZeroMemory(@osvi, sizeof(OSVERSIONINFOEX));
   osvi.dwOSVersionInfoSize := sizeof(OSVERSIONINFOEX);
   osvi.dwMajorVersion := 5;
   osvi.dwMinorVersion := 0;
   osvi.wServicePackMajor := 0;
   osvi.wServicePackMinor := 0;
   osvi.wProductType := VER_NT_SERVER;

   dwlConditionMask:=VerSetConditionMask( dwlConditionMask, VER_MAJORVERSION, op );
   dwlConditionMask:=VerSetConditionMask( dwlConditionMask, VER_MINORVERSION, op );
   dwlConditionMask:=VerSetConditionMask( dwlConditionMask, VER_SERVICEPACKMAJOR, op );
   dwlConditionMask:=VerSetConditionMask( dwlConditionMask, VER_SERVICEPACKMINOR, op );
   dwlConditionMask:=VerSetConditionMask( dwlConditionMask, VER_PRODUCT_TYPE, VER_EQUAL );

   Result:=VerifyVersionInfo(osvi,VER_MAJORVERSION OR VER_MINORVERSION OR
      VER_SERVICEPACKMAJOR OR VER_SERVICEPACKMINOR OR VER_PRODUCT_TYPE, dwlConditionMask);
end;

procedure GetSCProductInfo(SCProduct: TSecurityCenterProduct; var SecurityCenterInfo: TSecurityCenterInfo);
var
  FSWbemLocator : OLEVariant;
  FWMIService   : OLEVariant;
  FWbemObjectSet: OLEVariant;
  FWbemObject   : OLEVariant;
  oEnum         : IEnumvariant;
  iValue        : LongWord;
  osVerInfo     : TOSVersionInfo;
begin
  osVerInfo.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(osVerInfo);
  if (SCProduct=AntiSpywareProduct) and (osVerInfo.dwMajorVersion<6)  then exit;
  FSWbemLocator := CreateOleObject('WbemScripting.SWbemLocator');
  FWMIService   := FSWbemLocator.ConnectServer('localhost',Format('%s\%s',[WmiRoot,WmiNamespaceSCProduct[osVerInfo.dwMajorVersion>=6]]), '', '');
  FWbemObjectSet:= FWMIService.ExecQuery(Format('SELECT * FROM %s',[WmiClassSCProduct[SCProduct]]),'WQL',0);
  oEnum         := IUnknown(FWbemObjectSet._NewEnum) as IEnumVariant;
  while oEnum.Next(1, FWbemObject, iValue) = 0 do
  begin
    if osVerInfo.dwMajorVersion >= 6 then  //windows vista or newer
    begin
      SecurityCenterInfo.displayName := SecurityCenterInfo.displayName + Format('%s',[FWbemObject.displayName]) + '|';// String
      SecurityCenterInfo.instanceGuid := SecurityCenterInfo.instanceGuid + Format('%s',[FWbemObject.instanceGuid]) + '|';// String
      SecurityCenterInfo.pathToSignedProductExe := SecurityCenterInfo.pathToSignedProductExe + Format('%s',[FWbemObject.pathToSignedProductExe]) + '|';// String
      SecurityCenterInfo.pathToSignedReportingExe := SecurityCenterInfo.pathToSignedReportingExe + Format('%s',[FWbemObject.pathToSignedReportingExe]) + '|';// String
      SecurityCenterInfo.productState := SecurityCenterInfo.productState + Format('%s',[FWbemObject.productState]) + '|';// Uint32
    end else
    begin
     case SCProduct of

        AntiVirusProduct :
         begin
            SecurityCenterInfo.companyName := SecurityCenterInfo.companyName + Format('%s',[FWbemObject.companyName]) + '|';// String
            SecurityCenterInfo.displayName := SecurityCenterInfo.displayName + Format('%s',[FWbemObject.displayName]) + '|';// String
            SecurityCenterInfo.enableOnAccessUIMd5Hash := SecurityCenterInfo.enableOnAccessUIMd5Hash + Format('%s',[FWbemObject.enableOnAccessUIMd5Hash]) + '|';// Uint8
            SecurityCenterInfo.enableOnAccessUIParameters := SecurityCenterInfo.enableOnAccessUIParameters + Format('%s',[FWbemObject.enableOnAccessUIParameters]) + '|';// String
            SecurityCenterInfo.instanceGuid := SecurityCenterInfo.instanceGuid + Format('%s',[FWbemObject.instanceGuid]) + '|';// String
            SecurityCenterInfo.pathToEnableOnAccessUI := SecurityCenterInfo.pathToEnableOnAccessUI + Format('%s',[FWbemObject.pathToEnableOnAccessUI]) + '|';// String
            //SecurityCenterInfo.pathToSignedProductExe := SecurityCenterInfo.pathToSignedProductExe + Format('%s',[FWbemObject.pathToSignedProductExe]) + '|';// String
            //SecurityCenterInfo.pathToSignedReportingExe := SecurityCenterInfo.pathToSignedReportingExe + Format('%s',[FWbemObject.pathToSignedReportingExe]) + '|';// String
            SecurityCenterInfo.pathToUpdateUI := SecurityCenterInfo.pathToUpdateUI + Format('%s',[FWbemObject.pathToUpdateUI]) + '|';// String
            //SecurityCenterInfo.updateUIMd5Hash := SecurityCenterInfo.updateUIMd5Hash + Format('%s',[FWbemObject.updateUIMd5Hash]) + '|';// Uint8
            //SecurityCenterInfo.updateUIParameters := SecurityCenterInfo.updateUIParameters + Format('%s',[FWbemObject.updateUIParameters]) + '|';// String
            //SecurityCenterInfo.productState := SecurityCenterInfo.productState + Format('%s',[FWbemObject.productState]) + '|';// String
            //SecurityCenterInfo.pathToEnableUI := SecurityCenterInfo.pathToEnableUI + Format('%s',[FWbemObject.pathToEnableUI]) + '|';// String
            SecurityCenterInfo.updateUIMd5Hash := SecurityCenterInfo.updateUIMd5Hash + Format('%s',[FWbemObject.updateUIMd5Hash]) + '|';// String
            SecurityCenterInfo.updateUIParameters := SecurityCenterInfo.updateUIParameters + Format('%s',[FWbemObject.updateUIParameters]) + '|';// String
            SecurityCenterInfo.versionNumber := SecurityCenterInfo.versionNumber + Format('%s',[FWbemObject.versionNumber]) + '|';// String
            SecurityCenterInfo.enableUIParameters := SecurityCenterInfo.enableUIParameters + Format('%s',[FWbemObject.enableUIParameters]) + '|';// String
            SecurityCenterInfo.enableUIMd5Hash := SecurityCenterInfo.enableUIMd5Hash + Format('%s',[FWbemObject.enableUIMd5Hash]) + '|';// String
         end;

       FirewallProduct  :
         begin
            SecurityCenterInfo.companyName := SecurityCenterInfo.companyName + Format('%s',[FWbemObject.companyName]) + '|';// String
            SecurityCenterInfo.displayName := SecurityCenterInfo.displayName + Format('%s',[FWbemObject.displayName]) + '|';// String
            //SecurityCenterInfo.enableOnAccessUIMd5Hash := SecurityCenterInfo.enableOnAccessUIMd5Hash + Format('%s',[FWbemObject.enableOnAccessUIMd5Hash]) + '|';// Uint8
            //SecurityCenterInfo.enableOnAccessUIParameters := SecurityCenterInfo.enableOnAccessUIParameters + Format('%s',[FWbemObject.enableOnAccessUIParameters]) + '|';// String
            SecurityCenterInfo.instanceGuid := SecurityCenterInfo.instanceGuid + Format('%s',[FWbemObject.instanceGuid]) + '|';// String
            //SecurityCenterInfo.pathToEnableOnAccessUI := SecurityCenterInfo.pathToEnableOnAccessUI + Format('%s',[FWbemObject.pathToEnableOnAccessUI]) + '|';// String
            //SecurityCenterInfo.pathToSignedProductExe := SecurityCenterInfo.pathToSignedProductExe + Format('%s',[FWbemObject.pathToSignedProductExe]) + '|';// String
            //SecurityCenterInfo.pathToSignedReportingExe := SecurityCenterInfo.pathToSignedReportingExe + Format('%s',[FWbemObject.pathToSignedReportingExe]) + '|';// String
            //SecurityCenterInfo.pathToUpdateUI := SecurityCenterInfo.pathToUpdateUI + Format('%s',[FWbemObject.pathToUpdateUI]) + '|';// String
            //SecurityCenterInfo.updateUIMd5Hash := SecurityCenterInfo.updateUIMd5Hash + Format('%s',[FWbemObject.updateUIMd5Hash]) + '|';// Uint8
            //SecurityCenterInfo.updateUIParameters := SecurityCenterInfo.updateUIParameters + Format('%s',[FWbemObject.updateUIParameters]) + '|';// String
            //SecurityCenterInfo.productState := SecurityCenterInfo.productState + Format('%s',[FWbemObject.productState]) + '|';// String
            SecurityCenterInfo.pathToEnableUI := SecurityCenterInfo.pathToEnableUI + Format('%s',[FWbemObject.pathToEnableUI]) + '|';// String
            //SecurityCenterInfo.updateUIMd5Hash := SecurityCenterInfo.updateUIMd5Hash + Format('%s',[FWbemObject.updateUIMd5Hash]) + '|';// String
            //SecurityCenterInfo.updateUIParameters := SecurityCenterInfo.updateUIParameters + Format('%s',[FWbemObject.updateUIParameters]) + '|';// String
            SecurityCenterInfo.versionNumber := SecurityCenterInfo.versionNumber + Format('%s',[FWbemObject.versionNumber]) + '|';// String
            SecurityCenterInfo.enableUIParameters := SecurityCenterInfo.enableUIParameters + Format('%s',[FWbemObject.enableUIParameters]) + '|';// String
            SecurityCenterInfo.enableUIMd5Hash := SecurityCenterInfo.enableUIMd5Hash + Format('%s',[FWbemObject.enableUIMd5Hash]) + '|';// String
         end;

     end;
    end;
    FWbemObject:=Unassigned;
  end;
end;

procedure GetSecInfo(SecurityCenterProduct: TSecurityCenterProduct; var SecurityCenterInfo: TSecurityCenterInfo);
var
  TempStr: string;
begin
 try
    if Is_Win_Server then Exit;
    CoInitialize(nil);
    try
      GetSCProductInfo(SecurityCenterProduct, SecurityCenterInfo);
      finally
      CoUninitialize;
    end;
    except
  end;
end;

end.
