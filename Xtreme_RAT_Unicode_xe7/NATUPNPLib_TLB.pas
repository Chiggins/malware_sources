unit NATUPNPLib_TLB;

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

// $Rev: 16059 $
// File generated on 16-11-2008 13:11:46 from Type Library described below.

// ************************************************************************  //
// Type Lib: C:\Windows\SysWOW64\hnetcfg.dll\2 (1)
// LIBID: {1C565858-F302-471E-B409-F180AA4ABEC6}
// LCID: 0
// Helpfile: 
// HelpString: NATUPnP 1.0 Type Library
// DepndLst: 
//   (1) v2.0 stdole, (C:\Windows\SysWOW64\stdole2.tlb)
// ************************************************************************ //
{$TYPEDADDRESS OFF} // Unit must be compiled without type-checked pointers. 
{$WARN SYMBOL_PLATFORM OFF}
{$WRITEABLECONST ON}
{$VARPROPSETTER ON}
{$ALIGN 4}
interface

uses Windows, ActiveX, Classes, Graphics, OleServer, StdVCL, Variants;
  

// *********************************************************************//
// GUIDS declared in the TypeLibrary. Following prefixes are used:        
//   Type Libraries     : LIBID_xxxx                                      
//   CoClasses          : CLASS_xxxx                                      
//   DISPInterfaces     : DIID_xxxx                                       
//   Non-DISP interfaces: IID_xxxx                                        
// *********************************************************************//
const
  // TypeLibrary Major and minor versions
  NATUPNPLibMajorVersion = 1;
  NATUPNPLibMinorVersion = 0;

  LIBID_NATUPNPLib: TGUID = '{1C565858-F302-471E-B409-F180AA4ABEC6}';

  IID_IUPnPNAT: TGUID = '{B171C812-CC76-485A-94D8-B6B3A2794E99}';
  CLASS_UPnPNAT: TGUID = '{AE1E00AA-3FD5-403C-8A27-2BBDC30CD0E1}';
  IID_IStaticPortMappingCollection: TGUID = '{CD1F3E77-66D6-4664-82C7-36DBB641D0F1}';
  IID_IStaticPortMapping: TGUID = '{6F10711F-729B-41E5-93B8-F21D0F818DF1}';
  IID_IDynamicPortMappingCollection: TGUID = '{B60DE00F-156E-4E8D-9EC1-3A2342C10899}';
  IID_IDynamicPortMapping: TGUID = '{4FC80282-23B6-4378-9A27-CD8F17C9400C}';
  IID_INATEventManager: TGUID = '{624BD588-9060-4109-B0B0-1ADBBCAC32DF}';
type

// *********************************************************************//
// Forward declaration of types defined in TypeLibrary                    
// *********************************************************************//
  IUPnPNAT = interface;
  IUPnPNATDisp = dispinterface;
  IStaticPortMappingCollection = interface;
  IStaticPortMappingCollectionDisp = dispinterface;
  IStaticPortMapping = interface;
  IStaticPortMappingDisp = dispinterface;
  IDynamicPortMappingCollection = interface;
  IDynamicPortMappingCollectionDisp = dispinterface;
  IDynamicPortMapping = interface;
  IDynamicPortMappingDisp = dispinterface;
  INATEventManager = interface;
  INATEventManagerDisp = dispinterface;

// *********************************************************************//
// Declaration of CoClasses defined in Type Library                       
// (NOTE: Here we map each CoClass to its Default Interface)              
// *********************************************************************//
  UPnPNAT = IUPnPNAT;


// *********************************************************************//
// Interface: IUPnPNAT
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B171C812-CC76-485A-94D8-B6B3A2794E99}
// *********************************************************************//
  IUPnPNAT = interface(IDispatch)
    ['{B171C812-CC76-485A-94D8-B6B3A2794E99}']
    function Get_StaticPortMappingCollection: IStaticPortMappingCollection; safecall;
    function Get_DynamicPortMappingCollection: IDynamicPortMappingCollection; safecall;
    function Get_NATEventManager: INATEventManager; safecall;
    property StaticPortMappingCollection: IStaticPortMappingCollection read Get_StaticPortMappingCollection;
    property DynamicPortMappingCollection: IDynamicPortMappingCollection read Get_DynamicPortMappingCollection;
    property NATEventManager: INATEventManager read Get_NATEventManager;
  end;

// *********************************************************************//
// DispIntf:  IUPnPNATDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B171C812-CC76-485A-94D8-B6B3A2794E99}
// *********************************************************************//
  IUPnPNATDisp = dispinterface
    ['{B171C812-CC76-485A-94D8-B6B3A2794E99}']
    property StaticPortMappingCollection: IStaticPortMappingCollection readonly dispid 1;
    property DynamicPortMappingCollection: IDynamicPortMappingCollection readonly dispid 2;
    property NATEventManager: INATEventManager readonly dispid 3;
  end;

// *********************************************************************//
// Interface: IStaticPortMappingCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CD1F3E77-66D6-4664-82C7-36DBB641D0F1}
// *********************************************************************//
  IStaticPortMappingCollection = interface(IDispatch)
    ['{CD1F3E77-66D6-4664-82C7-36DBB641D0F1}']
    function Get__NewEnum: IUnknown; safecall;
    function Get_Item(lExternalPort: Integer; const bstrProtocol: WideString): IStaticPortMapping; safecall;
    function Get_Count: Integer; safecall;
    procedure Remove(lExternalPort: Integer; const bstrProtocol: WideString); safecall;
    function Add(lExternalPort: Integer; const bstrProtocol: WideString; lInternalPort: Integer; 
                 const bstrInternalClient: WideString; bEnabled: WordBool; 
                 const bstrDescription: WideString): IStaticPortMapping; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Item[lExternalPort: Integer; const bstrProtocol: WideString]: IStaticPortMapping read Get_Item;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IStaticPortMappingCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {CD1F3E77-66D6-4664-82C7-36DBB641D0F1}
// *********************************************************************//
  IStaticPortMappingCollectionDisp = dispinterface
    ['{CD1F3E77-66D6-4664-82C7-36DBB641D0F1}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Item[lExternalPort: Integer; const bstrProtocol: WideString]: IStaticPortMapping readonly dispid 0;
    property Count: Integer readonly dispid 1;
    procedure Remove(lExternalPort: Integer; const bstrProtocol: WideString); dispid 2;
    function Add(lExternalPort: Integer; const bstrProtocol: WideString; lInternalPort: Integer; 
                 const bstrInternalClient: WideString; bEnabled: WordBool; 
                 const bstrDescription: WideString): IStaticPortMapping; dispid 3;
  end;

// *********************************************************************//
// Interface: IStaticPortMapping
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F10711F-729B-41E5-93B8-F21D0F818DF1}
// *********************************************************************//
  IStaticPortMapping = interface(IDispatch)
    ['{6F10711F-729B-41E5-93B8-F21D0F818DF1}']
    function Get_ExternalIPAddress: WideString; safecall;
    function Get_ExternalPort: Integer; safecall;
    function Get_InternalPort: Integer; safecall;
    function Get_Protocol: WideString; safecall;
    function Get_InternalClient: WideString; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Description: WideString; safecall;
    procedure EditInternalClient(const bstrInternalClient: WideString); safecall;
    procedure Enable(vb: WordBool); safecall;
    procedure EditDescription(const bstrDescription: WideString); safecall;
    procedure EditInternalPort(lInternalPort: Integer); safecall;
    property ExternalIPAddress: WideString read Get_ExternalIPAddress;
    property ExternalPort: Integer read Get_ExternalPort;
    property InternalPort: Integer read Get_InternalPort;
    property Protocol: WideString read Get_Protocol;
    property InternalClient: WideString read Get_InternalClient;
    property Enabled: WordBool read Get_Enabled;
    property Description: WideString read Get_Description;
  end;

// *********************************************************************//
// DispIntf:  IStaticPortMappingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {6F10711F-729B-41E5-93B8-F21D0F818DF1}
// *********************************************************************//
  IStaticPortMappingDisp = dispinterface
    ['{6F10711F-729B-41E5-93B8-F21D0F818DF1}']
    property ExternalIPAddress: WideString readonly dispid 1;
    property ExternalPort: Integer readonly dispid 2;
    property InternalPort: Integer readonly dispid 3;
    property Protocol: WideString readonly dispid 4;
    property InternalClient: WideString readonly dispid 5;
    property Enabled: WordBool readonly dispid 6;
    property Description: WideString readonly dispid 7;
    procedure EditInternalClient(const bstrInternalClient: WideString); dispid 8;
    procedure Enable(vb: WordBool); dispid 9;
    procedure EditDescription(const bstrDescription: WideString); dispid 10;
    procedure EditInternalPort(lInternalPort: Integer); dispid 11;
  end;

// *********************************************************************//
// Interface: IDynamicPortMappingCollection
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B60DE00F-156E-4E8D-9EC1-3A2342C10899}
// *********************************************************************//
  IDynamicPortMappingCollection = interface(IDispatch)
    ['{B60DE00F-156E-4E8D-9EC1-3A2342C10899}']
    function Get__NewEnum: IUnknown; safecall;
    function Get_Item(const bstrRemoteHost: WideString; lExternalPort: Integer; 
                      const bstrProtocol: WideString): IDynamicPortMapping; safecall;
    function Get_Count: Integer; safecall;
    procedure Remove(const bstrRemoteHost: WideString; lExternalPort: Integer; 
                     const bstrProtocol: WideString); safecall;
    function Add(const bstrRemoteHost: WideString; lExternalPort: Integer; 
                 const bstrProtocol: WideString; lInternalPort: Integer; 
                 const bstrInternalClient: WideString; bEnabled: WordBool; 
                 const bstrDescription: WideString; lLeaseDuration: Integer): IDynamicPortMapping; safecall;
    property _NewEnum: IUnknown read Get__NewEnum;
    property Item[const bstrRemoteHost: WideString; lExternalPort: Integer; 
                  const bstrProtocol: WideString]: IDynamicPortMapping read Get_Item;
    property Count: Integer read Get_Count;
  end;

// *********************************************************************//
// DispIntf:  IDynamicPortMappingCollectionDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {B60DE00F-156E-4E8D-9EC1-3A2342C10899}
// *********************************************************************//
  IDynamicPortMappingCollectionDisp = dispinterface
    ['{B60DE00F-156E-4E8D-9EC1-3A2342C10899}']
    property _NewEnum: IUnknown readonly dispid -4;
    property Item[const bstrRemoteHost: WideString; lExternalPort: Integer; 
                  const bstrProtocol: WideString]: IDynamicPortMapping readonly dispid 0;
    property Count: Integer readonly dispid 1;
    procedure Remove(const bstrRemoteHost: WideString; lExternalPort: Integer; 
                     const bstrProtocol: WideString); dispid 2;
    function Add(const bstrRemoteHost: WideString; lExternalPort: Integer; 
                 const bstrProtocol: WideString; lInternalPort: Integer; 
                 const bstrInternalClient: WideString; bEnabled: WordBool; 
                 const bstrDescription: WideString; lLeaseDuration: Integer): IDynamicPortMapping; dispid 3;
  end;

// *********************************************************************//
// Interface: IDynamicPortMapping
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4FC80282-23B6-4378-9A27-CD8F17C9400C}
// *********************************************************************//
  IDynamicPortMapping = interface(IDispatch)
    ['{4FC80282-23B6-4378-9A27-CD8F17C9400C}']
    function Get_ExternalIPAddress: WideString; safecall;
    function Get_RemoteHost: WideString; safecall;
    function Get_ExternalPort: Integer; safecall;
    function Get_Protocol: WideString; safecall;
    function Get_InternalPort: Integer; safecall;
    function Get_InternalClient: WideString; safecall;
    function Get_Enabled: WordBool; safecall;
    function Get_Description: WideString; safecall;
    function Get_LeaseDuration: Integer; safecall;
    function RenewLease(lLeaseDurationDesired: Integer): Integer; safecall;
    procedure EditInternalClient(const bstrInternalClient: WideString); safecall;
    procedure Enable(vb: WordBool); safecall;
    procedure EditDescription(const bstrDescription: WideString); safecall;
    procedure EditInternalPort(lInternalPort: Integer); safecall;
    property ExternalIPAddress: WideString read Get_ExternalIPAddress;
    property RemoteHost: WideString read Get_RemoteHost;
    property ExternalPort: Integer read Get_ExternalPort;
    property Protocol: WideString read Get_Protocol;
    property InternalPort: Integer read Get_InternalPort;
    property InternalClient: WideString read Get_InternalClient;
    property Enabled: WordBool read Get_Enabled;
    property Description: WideString read Get_Description;
    property LeaseDuration: Integer read Get_LeaseDuration;
  end;

// *********************************************************************//
// DispIntf:  IDynamicPortMappingDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {4FC80282-23B6-4378-9A27-CD8F17C9400C}
// *********************************************************************//
  IDynamicPortMappingDisp = dispinterface
    ['{4FC80282-23B6-4378-9A27-CD8F17C9400C}']
    property ExternalIPAddress: WideString readonly dispid 1;
    property RemoteHost: WideString readonly dispid 2;
    property ExternalPort: Integer readonly dispid 3;
    property Protocol: WideString readonly dispid 4;
    property InternalPort: Integer readonly dispid 5;
    property InternalClient: WideString readonly dispid 6;
    property Enabled: WordBool readonly dispid 7;
    property Description: WideString readonly dispid 8;
    property LeaseDuration: Integer readonly dispid 9;
    function RenewLease(lLeaseDurationDesired: Integer): Integer; dispid 10;
    procedure EditInternalClient(const bstrInternalClient: WideString); dispid 11;
    procedure Enable(vb: WordBool); dispid 12;
    procedure EditDescription(const bstrDescription: WideString); dispid 13;
    procedure EditInternalPort(lInternalPort: Integer); dispid 14;
  end;

// *********************************************************************//
// Interface: INATEventManager
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {624BD588-9060-4109-B0B0-1ADBBCAC32DF}
// *********************************************************************//
  INATEventManager = interface(IDispatch)
    ['{624BD588-9060-4109-B0B0-1ADBBCAC32DF}']
    procedure Set_ExternalIPAddressCallback(const Param1: IUnknown); safecall;
    procedure Set_NumberOfEntriesCallback(const Param1: IUnknown); safecall;
    property ExternalIPAddressCallback: IUnknown write Set_ExternalIPAddressCallback;
    property NumberOfEntriesCallback: IUnknown write Set_NumberOfEntriesCallback;
  end;

// *********************************************************************//
// DispIntf:  INATEventManagerDisp
// Flags:     (4416) Dual OleAutomation Dispatchable
// GUID:      {624BD588-9060-4109-B0B0-1ADBBCAC32DF}
// *********************************************************************//
  INATEventManagerDisp = dispinterface
    ['{624BD588-9060-4109-B0B0-1ADBBCAC32DF}']
    property ExternalIPAddressCallback: IUnknown writeonly dispid 1;
    property NumberOfEntriesCallback: IUnknown writeonly dispid 2;
  end;

// *********************************************************************//
// The Class CoUPnPNAT provides a Create and CreateRemote method to          
// create instances of the default interface IUPnPNAT exposed by              
// the CoClass UPnPNAT. The functions are intended to be used by             
// clients wishing to automate the CoClass objects exposed by the         
// server of this typelibrary.                                            
// *********************************************************************//
  CoUPnPNAT = class
    class function Create: IUPnPNAT;
    class function CreateRemote(const MachineName: string): IUPnPNAT;
  end;

implementation

uses ComObj;

class function CoUPnPNAT.Create: IUPnPNAT;
begin
  Result := CreateComObject(CLASS_UPnPNAT) as IUPnPNAT;
end;

class function CoUPnPNAT.CreateRemote(const MachineName: string): IUPnPNAT;
begin
  Result := CreateRemoteComObject(MachineName, CLASS_UPnPNAT) as IUPnPNAT;
end;

end.
