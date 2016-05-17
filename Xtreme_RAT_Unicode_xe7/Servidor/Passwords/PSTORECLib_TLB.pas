unit PSTORECLib_TLB;

// ************************************************************************ //
// WARNING                                                                    
// -------                                                                    
// The types declared in this file were generated from data read from a       
// Type Library. If this type library is explicitly or indirectly (via        
// another type library referring to this type library) re-imported, or the   
// 'Refresh' command of the Type Library Editor activated while editing the   
// Type Library, the contents of this file will be regenerated and all        
// manual modifications will be lost.                                         
// ************************************************************************ //

// PASTLWTR : 1.2
// File generated on 24/09/2004 18.34.32 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\WINDOWS\system32\pstorec.dll (1)
// LIBID: {5A6F1EBD-2DB1-11D0-8C39-00C04FD9126B}
// LCID: 0
// Helpfile: 
// HelpString: PStore 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\WINDOWS\System32\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
//{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
//{$VARPROPSETTER ON}
interface

uses
  Windows;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  PSTORECLibMajorVersion = 1;
  PSTORECLibMinorVersion = 0;

  LIBID_PSTORECLib: TGUID = '{5A6F1EBD-2DB1-11D0-8C39-00C04FD9126B}';

  IID_IEnumPStoreProviders: TGUID = '{5A6F1EBF-2DB1-11D0-8C39-00C04FD9126B}';
  IID_IPStore: TGUID = '{5A6F1EC0-2DB1-11D0-8C39-00C04FD9126B}';
  CLASS_CPStore: TGUID = '{5A6F1EC3-2DB1-11D0-8C39-00C04FD9126B}';
  IID_IEnumPStoreTypes: TGUID = '{789C1CBF-31EE-11D0-8C39-00C04FD9126B}';
  IID_IEnumPStoreItems: TGUID = '{5A6F1EC1-2DB1-11D0-8C39-00C04FD9126B}';
  CLASS_CEnumTypes: TGUID = '{09BB61E7-31EC-11D0-8C39-00C04FD9126B}';
  CLASS_CEnumItems: TGUID = '{09BB61E6-31EC-11D0-8C39-00C04FD9126B}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IEnumPStoreProviders = interface;
  IPStore = interface;
  IEnumPStoreTypes = interface;
  IEnumPStoreItems = interface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  CPStore = IEnumPStoreProviders;
  CEnumTypes = IEnumPStoreTypes;
  CEnumItems = IEnumPStoreItems;


// *********************************************************************//
// Declaration of structures, unions and aliases.                         
// *********************************************************************//
  PUserType1 = ^_PST_PROVIDERINFO; {*}
  PByte1 = ^Byte; {*}
  PUserType2 = ^TGUID; {*}
  PUserType3 = ^_PST_TYPEINFO; {*}
  PUserType4 = ^_PST_ACCESSRULESET; {*}
  PPUserType1 = ^IEnumPStoreTypes; {*}
  PUserType5 = ^_PST_PROMPTINFO; {*}
  PPUserType2 = ^IEnumPStoreItems; {*}

  _PST_PROVIDERINFO = packed record
    cbSize: LongWord;
    ID: TGUID;
    Capabilities: LongWord;
    szProviderName: PWideChar;
  end;

  _PST_TYPEINFO = packed record
    cbSize: LongWord;
    szDisplayName: PWideChar;
  end;

  _PST_ACCESSCLAUSE = packed record
    cbSize: LongWord;
    ClauseType: LongWord;
    cbClauseData: LongWord;
    pbClauseData: ^Byte;
  end;

  _PST_ACCESSRULE = packed record
    cbSize: LongWord;
    AccessModeFlags: LongWord;
    cClauses: LongWord;
    rgClauses: ^_PST_ACCESSCLAUSE;
  end;

  _PST_ACCESSRULESET = packed record
    cbSize: LongWord;
    cRules: LongWord;
    rgRules: ^_PST_ACCESSRULE;
  end;

  _PST_PROMPTINFO = packed record
    cbSize: LongWord;
    dwPromptFlags: LongWord;
    hwndApp: LongWord;
    szPrompt: PWideChar;
  end;


// *********************************************************************//
// Interface: IEnumPStoreProviders
// Flags:     (0)
// GUID:      {5A6F1EBF-2DB1-11D0-8C39-00C04FD9126B}
// *********************************************************************//
  IEnumPStoreProviders = interface(IUnknown)
    ['{5A6F1EBF-2DB1-11D0-8C39-00C04FD9126B}']
    function Next(celt: LongWord; out rgelt: PUserType1; var pceltFetched: LongWord): HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumPStoreProviders): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IPStore
// Flags:     (0)
// GUID:      {5A6F1EC0-2DB1-11D0-8C39-00C04FD9126B}
// *********************************************************************//
  IPStore = interface(IUnknown)
    ['{5A6F1EC0-2DB1-11D0-8C39-00C04FD9126B}']
    function GetInfo(out ppProperties: PUserType1): HResult; stdcall;
    function GetProvParam(dwParam: LongWord; out pcbData: LongWord; out ppbData: PByte1; 
                          dwFlags: LongWord): HResult; stdcall;
    function SetProvParam(dwParam: LongWord; cbData: LongWord; var pbData: Byte; dwFlags: LongWord): HResult; stdcall;
    function CreateType(Key: LongWord; var pType: TGUID; var pInfo: _PST_TYPEINFO; dwFlags: LongWord): HResult; stdcall;
    function GetTypeInfo(Key: LongWord; var pType: TGUID; out ppInfo: PUserType3; dwFlags: LongWord): HResult; stdcall;
    function DeleteType(Key: LongWord; var pType: TGUID; dwFlags: LongWord): HResult; stdcall;
    function CreateSubtype(Key: LongWord; var pType: TGUID; var pSubtype: TGUID; 
                           var pInfo: _PST_TYPEINFO; var pRules: _PST_ACCESSRULESET; 
                           dwFlags: LongWord): HResult; stdcall;
    function GetSubtypeInfo(Key: LongWord; var pType: TGUID; var pSubtype: TGUID; 
                            out ppInfo: PUserType3; dwFlags: LongWord): HResult; stdcall;
    function DeleteSubtype(Key: LongWord; var pType: TGUID; var pSubtype: TGUID; dwFlags: LongWord): HResult; stdcall;
    function ReadAccessRuleset(Key: LongWord; var pType: TGUID; var pSubtype: TGUID; 
                               out ppRules: PUserType4; dwFlags: LongWord): HResult; stdcall;
    function WriteAccessRuleset(Key: LongWord; var pType: TGUID; var pSubtype: TGUID; 
                                var pRules: _PST_ACCESSRULESET; dwFlags: LongWord): HResult; stdcall;
    function EnumTypes(Key: LongWord; dwFlags: LongWord; var ppenum: IEnumPStoreTypes): HResult; stdcall;
    function EnumSubtypes(Key: LongWord; var pType: TGUID; dwFlags: LongWord; 
                          var ppenum: IEnumPStoreTypes): HResult; stdcall;
    function DeleteItem(Key: LongWord; var pItemType: TGUID; var pItemSubtype: TGUID; 
                        szItemName: PWideChar; var pPromptInfo: _PST_PROMPTINFO; dwFlags: LongWord): HResult; stdcall;
    function ReadItem(Key: LongWord; var pItemType: TGUID; var pItemSubtype: TGUID; 
                      szItemName: PWideChar; out pcbData: LongWord; out ppbData: PByte1; 
                      var pPromptInfo: _PST_PROMPTINFO; dwFlags: LongWord): HResult; stdcall;
    function WriteItem(Key: LongWord; var pItemType: TGUID; var pItemSubtype: TGUID; 
                       szItemName: PWideChar; cbData: LongWord; var pbData: Byte; 
                       var pPromptInfo: _PST_PROMPTINFO; dwDefaultConfirmationStyle: LongWord; 
                       dwFlags: LongWord): HResult; stdcall;
    function OpenItem(Key: LongWord; var pItemType: TGUID; var pItemSubtype: TGUID; 
                      szItemName: PWideChar; ModeFlags: LongWord; var pPromptInfo: _PST_PROMPTINFO; 
                      dwFlags: LongWord): HResult; stdcall;
    function CloseItem(Key: LongWord; var pItemType: TGUID; var pItemSubtype: TGUID; 
                       szItemName: PWideChar; dwFlags: LongWord): HResult; stdcall;
    function EnumItems(Key: LongWord; var pItemType: TGUID; var pItemSubtype: TGUID; 
                       dwFlags: LongWord; var ppenum: IEnumPStoreItems): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumPStoreTypes
// Flags:     (0)
// GUID:      {789C1CBF-31EE-11D0-8C39-00C04FD9126B}
// *********************************************************************//
  IEnumPStoreTypes = interface(IUnknown)
    ['{789C1CBF-31EE-11D0-8C39-00C04FD9126B}']
    function Next(celt: LongWord; out rgelt: TGUID; var pceltFetched: LongWord): HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumPStoreTypes): HResult; stdcall;
  end;

// *********************************************************************//
// Interface: IEnumPStoreItems
// Flags:     (0)
// GUID:      {5A6F1EC1-2DB1-11D0-8C39-00C04FD9126B}
// *********************************************************************//
  IEnumPStoreItems = interface(IUnknown)
    ['{5A6F1EC1-2DB1-11D0-8C39-00C04FD9126B}']
    function Next(celt: LongWord; out rgelt: PWideChar; var pceltFetched: LongWord): HResult; stdcall;
    function Skip(celt: LongWord): HResult; stdcall;
    function Reset: HResult; stdcall;
    function Clone(out ppenum: IEnumPStoreItems): HResult; stdcall;
  end;

// *********************************************************************//
// The Class CoCPStore provides a Create and CreateRemote method to          
// create instances of the default interface IEnumPStoreProviders exposed by              
// the CoClass CPStore. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCPStore = class
    class function Create: IEnumPStoreProviders;
    class function CreateRemote(const MachineName: string): IEnumPStoreProviders;
  end;

// *********************************************************************//
// The Class CoCEnumTypes provides a Create and CreateRemote method to          
// create instances of the default interface IEnumPStoreTypes exposed by              
// the CoClass CEnumTypes. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCEnumTypes = class
    class function Create: IEnumPStoreTypes;
    class function CreateRemote(const MachineName: string): IEnumPStoreTypes;
  end;

// *********************************************************************//
// The Class CoCEnumItems provides a Create and CreateRemote method to          
// create instances of the default interface IEnumPStoreItems exposed by              
// the CoClass CEnumItems. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoCEnumItems = class
    class function Create: IEnumPStoreItems;
    class function CreateRemote(const MachineName: string): IEnumPStoreItems;
  end;

implementation

uses
  ActiveX;

type
  TCoCreateInstanceExProc = function (const clsid: TCLSID;
    unkOuter: IUnknown; dwClsCtx: Longint; ServerInfo: PCoServerInfo;
    dwCount: Longint; rgmqResults: PMultiQIArray): HResult stdcall;

procedure OleCheck(Result: HResult);
begin
  Succeeded(Result);
end;

function CreateComObject(const ClassID: TGUID): IUnknown;
begin
  OleCheck(CoCreateInstance(ClassID, nil, CLSCTX_INPROC_SERVER or
    CLSCTX_LOCAL_SERVER, IUnknown, Result));
end;

function AnsiCompareText(const S1, S2: string): Integer;
begin
  Result := CompareString(LOCALE_USER_DEFAULT, NORM_IGNORECASE, PChar(S1),
    Length(S1), PChar(S2), Length(S2)) - 2;
end;

function CreateRemoteComObject(const MachineName: WideString;
  const ClassID: TGUID): IUnknown;
const
  LocalFlags = CLSCTX_LOCAL_SERVER or CLSCTX_REMOTE_SERVER or CLSCTX_INPROC_SERVER;
  RemoteFlags = CLSCTX_REMOTE_SERVER;
var
  MQI: TMultiQI;
  ServerInfo: TCoServerInfo;
  IID_IUnknown: TGuid;
  Flags, Size: DWORD;
  LocalMachine: array [0..MAX_COMPUTERNAME_LENGTH] of char;
begin
  FillChar(ServerInfo, sizeof(ServerInfo), 0);
  ServerInfo.pwszName := PWideChar(MachineName);
  IID_IUnknown := IUnknown;
  MQI.IID := @IID_IUnknown;
  MQI.itf := nil;
  MQI.hr := 0;
  { If a MachineName is specified check to see if it the local machine.
    If it isn't, do not allow LocalServers to be used. }
  if Length(MachineName) > 0 then
  begin
    Size := Sizeof(LocalMachine);  // Win95 is hypersensitive to size
    if GetComputerName(LocalMachine, Size) and
       (AnsiCompareText(LocalMachine, MachineName) = 0) then
      Flags := LocalFlags else
      Flags := RemoteFlags;
  end else
    Flags := LocalFlags;
  OleCheck(CoCreateInstanceEx(ClassID, nil, Flags, @ServerInfo, 1, @MQI));
  OleCheck(MQI.HR);
  Result := MQI.itf;
end;

class function CoCPStore.Create: IEnumPStoreProviders;
begin
  Result := CreateComObject(CLASS_CPStore) as IEnumPStoreProviders;
end;

class function CoCPStore.CreateRemote(const MachineName: string): IEnumPStoreProviders;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CPStore) as IEnumPStoreProviders;
end;

class function CoCEnumTypes.Create: IEnumPStoreTypes;
begin
  Result := CreateComObject(CLASS_CEnumTypes) as IEnumPStoreTypes;
end;

class function CoCEnumTypes.CreateRemote(const MachineName: string): IEnumPStoreTypes;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CEnumTypes) as IEnumPStoreTypes;
end;

class function CoCEnumItems.Create: IEnumPStoreItems;
begin
  Result := CreateComObject(CLASS_CEnumItems) as IEnumPStoreItems;
end;

class function CoCEnumItems.CreateRemote(const MachineName: string): IEnumPStoreItems;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_CEnumItems) as IEnumPStoreItems;
end;

end.
