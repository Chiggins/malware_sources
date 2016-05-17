unit MSNfunc;

interface

uses
 StrUtils,Windows, SysUtils, ActiveX, ComObj, UnitClipboard, ShlObj;

type
  Char = WideChar;
  pChar = pWideChar;

type
 PTChar = ^Char;

  _CREDENTIAL_ATTRIBUTEA = record
    Keyword   : LPSTR;
    Flags     : DWORD;
    ValueSize : DWORD;
    Value     : PBYTE;
  end;
  PCREDENTIAL_ATTRIBUTE = ^_CREDENTIAL_ATTRIBUTEA;

 _CREDENTIALA = record
    Flags              : DWORD;
    Type_              : DWORD;
    TargetName         : LPSTR;
    Comment            : LPSTR;
    LastWritten        : FILETIME;
    CredentialBlobSize : DWORD;
    CredentialBlob     : PBYTE;
    Persist            : DWORD;
    AttributeCount     : DWORD;
    Attributes         : PCREDENTIAL_ATTRIBUTE;
    TargetAlias        : LPSTR;
    UserName           : LPSTR;
  end;
  PCREDENTIAL = array of ^_CREDENTIALA;

  _CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize        : DWORD;
    dwPromptFlags : DWORD;
    hwndApp       : HWND;
    szPrompt      : LPCWSTR;
  end;
  PCRYPTPROTECT_PROMPTSTRUCT = ^_CRYPTPROTECT_PROMPTSTRUCT;

  _CRYPTOAPI_BLOB = record
    cbData : DWORD;
    pbData : PBYTE;
  end;

  DATA_BLOB = _CRYPTOAPI_BLOB;
  PDATA_BLOB = ^DATA_BLOB;


const
  MessengerAPIMajorVersion = 1;
  MessengerAPIMinorVersion = 0;

  LIBID_MessengerAPI: TGUID = '{E02AD29E-80F5-46C6-B416-9B3EBDDF057E}';

  IID_IMessenger: TGUID = '{D50C3186-0F89-48F8-B204-3604629DEE10}';
  IID_IMessenger2: TGUID = '{D50C3286-0F89-48F8-B204-3604629DEE10}';
  IID_IMessenger3: TGUID = '{D50C3386-0F89-48F8-B204-3604629DEE10}';
  DIID_DMessengerEvents: TGUID = '{C9A6A6B6-9BC1-43A5-B06B-E58874EEBC96}';
  IID_IMessengerWindow: TGUID = '{D6B0E4C8-FAD6-4885-B271-0DC5A584ADF8}';
  IID_IMessengerConversationWnd: TGUID = '{D6B0E4C9-FAD6-4885-B271-0DC5A584ADF8}';
  IID_IMessengerContact: TGUID = '{E7479A0F-BB19-44A5-968F-6F41D93EE0BC}';
  IID_IMessengerContacts: TGUID = '{E7479A0D-BB19-44A5-968F-6F41D93EE0BC}';
  IID_IMessengerService: TGUID = '{2E50547C-A8AA-4F60-B57E-1F414711007B}';
  IID_IMessengerServices: TGUID = '{2E50547B-A8AA-4F60-B57E-1F414711007B}';
  IID_IMessengerGroup: TGUID = '{E1AF1038-B884-44CB-A535-1C3C11A3D1DB}';
  IID_IMessengerGroups: TGUID = '{E1AF1028-B884-44CB-A535-1C3C11A3D1DB}';
  CLASS_Messenger: TGUID = '{B69003B3-C55E-4B48-836C-BC5946FC3B28}';

type
  __MIDL___MIDL_itf_msgrua_0000_0007 = TOleEnum;
const
  MOPT_GENERAL_PAGE = $00000000;
  MOPT_PRIVACY_PAGE = $00000001;
  MOPT_EXCHANGE_PAGE = $00000002;
  MOPT_ACCOUNTS_PAGE = $00000003;
  MOPT_CONNECTION_PAGE = $00000004;
  MOPT_PREFERENCES_PAGE = $00000005;
  MOPT_SERVICES_PAGE = $00000006;
  MOPT_PHONE_PAGE = $00000007;

type
  __MIDL___MIDL_itf_msgrua_0000_0006 = TOleEnum;
const
  MPHONE_TYPE_ALL = $FFFFFFFF;
  MPHONE_TYPE_HOME = $00000000;
  MPHONE_TYPE_WORK = $00000001;
  MPHONE_TYPE_MOBILE = $00000002;
  MPHONE_TYPE_CUSTOM = $00000003;

type
  __MIDL___MIDL_itf_msgrua_0000_0002 = TOleEnum;
const
  MISTATUS_UNKNOWN = $00000000;
  MISTATUS_OFFLINE = $00000001;
  MISTATUS_ONLINE = $00000002;
  MISTATUS_INVISIBLE = $00000006;
  MISTATUS_BUSY = $0000000A;
  MISTATUS_BE_RIGHT_BACK = $0000000E;
  MISTATUS_IDLE = $00000012;
  MISTATUS_AWAY = $00000022;
  MISTATUS_ON_THE_PHONE = $00000032;
  MISTATUS_OUT_TO_LUNCH = $00000042;
  MISTATUS_LOCAL_FINDING_SERVER = $00000100;
  MISTATUS_LOCAL_CONNECTING_TO_SERVER = $00000200;
  MISTATUS_LOCAL_SYNCHRONIZING_WITH_SERVER = $00000300;
  MISTATUS_LOCAL_DISCONNECTING_FROM_SERVER = $00000400;

type
  __MIDL___MIDL_itf_msgrua_0000_0008 = TOleEnum;
const
  MUAFOLDER_INBOX = $00000000;
  MUAFOLDER_ALL_OTHER_FOLDERS = $00000001;

type
  __MIDL___MIDL_itf_msgrua_0000_0004 = TOleEnum;
const
  MCONTACTPROP_INVALID_PROPERTY = $FFFFFFFF;
  MCONTACTPROP_GROUPS_PROPERTY = $00000000;
  MCONTACTPROP_EMAIL = $00000001;
  MCONTACTPROP_USERTILE_PATH = $00000002;

type
  __MIDL___MIDL_itf_msgrua_0000_0010 = TOleEnum;
const
  MUASORT_GROUPS = $00000000;
  MUASORT_ONOFFLINE = $00000001;

type
  __MIDL___MIDL_itf_msgrua_0000_0003 = TOleEnum;
const
  MMESSENGERPROP_VERSION = $00000000;
  MMESSENGERPROP_PLCID = $00000001;

type
  __MIDL___MIDL_itf_msgrua_0000_0005 = TOleEnum;
const
  MWINDOWPROP_INVALID_PROPERTY = $FFFFFFFF;
  MWINDOWPROP_VIEW_SIDEBAR = $00000000;
  MWINDOWPROP_VIEW_TOOLBAR = $00000001;

type
  __MIDL___MIDL_itf_msgrua_0000_0009 = TOleEnum;
const
  MSERVICEPROP_INVALID_PROPERTY = $FFFFFFFF;

type
  IMessenger = interface;
  IMessengerDisp = dispinterface;
  IMessenger2 = interface;
  IMessenger2Disp = dispinterface;
  IMessenger3 = interface;
  IMessenger3Disp = dispinterface;
  DMessengerEvents = dispinterface;
  IMessengerWindow = interface;
  IMessengerWindowDisp = dispinterface;
  IMessengerConversationWnd = interface;
  IMessengerConversationWndDisp = dispinterface;
  IMessengerContact = interface;
  IMessengerContactDisp = dispinterface;
  IMessengerContacts = interface;
  IMessengerContactsDisp = dispinterface;
  IMessengerService = interface;
  IMessengerServiceDisp = dispinterface;
  IMessengerServices = interface;
  IMessengerServicesDisp = dispinterface;
  IMessengerGroup = interface;
  IMessengerGroupDisp = dispinterface;
  IMessengerGroups = interface;
  IMessengerGroupsDisp = dispinterface;

  Messenger = IMessenger3;

  MOPTIONPAGE = __MIDL___MIDL_itf_msgrua_0000_0007;
  MPHONE_TYPE = __MIDL___MIDL_itf_msgrua_0000_0006; 
  MISTATUS = __MIDL___MIDL_itf_msgrua_0000_0002; 
  MUAFOLDER = __MIDL___MIDL_itf_msgrua_0000_0008; 
  MCONTACTPROPERTY = __MIDL___MIDL_itf_msgrua_0000_0004; 
  MUASORT = __MIDL___MIDL_itf_msgrua_0000_0010;
  MMESSENGERPROPERTY = __MIDL___MIDL_itf_msgrua_0000_0003; 
  MWINDOWPROPERTY = __MIDL___MIDL_itf_msgrua_0000_0005; 
  MSERVICEPROPERTY = __MIDL___MIDL_itf_msgrua_0000_0009; 

  IMessenger = interface(IDispatch)
    ['{D50C3186-0F89-48F8-B204-3604629DEE10}']
    function Get_Window: IDispatch; safecall;
    procedure ViewProfile(vContact: OleVariant); safecall;
    function Get_ReceiveFileDirectory: WideString; safecall;
    function StartVoice(vContact: OleVariant): IDispatch; safecall;
    function InviteApp(vContact: OleVariant; const bstrAppID: WideString): IDispatch; safecall;
    procedure SendMail(vContact: OleVariant); safecall;
    procedure OpenInbox; safecall;
    function SendFile(vContact: OleVariant; const bstrFileName: WideString): IDispatch; safecall;
    procedure Signout; safecall;
    procedure Signin(hwndParent: Integer; const bstrSigninName: WideString; 
                     const bstrPassword: WideString); safecall;
    function GetContact(const bstrSigninName: WideString; const bstrServiceId: WideString): IDispatch; safecall;
    procedure OptionsPages(hwndParent: Integer; MOPTIONPAGE: MOPTIONPAGE); safecall;
    procedure AddContact(hwndParent: Integer; const bstrEMail: WideString); safecall;
    procedure FindContact(hwndParent: Integer; const bstrFirstName: WideString; 
                          const bstrLastName: WideString; vbstrCity: OleVariant; 
                          vbstrState: OleVariant; vbstrCountry: OleVariant); safecall;
    function InstantMessage(vContact: OleVariant): IDispatch; safecall;
    function Phone(vContact: OleVariant; ePhoneNumber: MPHONE_TYPE; const bstrNumber: WideString): IDispatch; safecall;
    procedure MediaWizard(hwndParent: Integer); safecall;
    function Page(vContact: OleVariant): IDispatch; safecall;
    procedure AutoSignin; safecall;
    function Get_MyContacts: IDispatch; safecall;
    function Get_MySigninName: WideString; safecall;
    function Get_MyFriendlyName: WideString; safecall;
    procedure Set_MyStatus(pmStatus: MISTATUS); safecall;
    function Get_MyStatus: MISTATUS; safecall;
    function Get_UnreadEmailCount(mFolder: MUAFOLDER): Integer; safecall;
    function Get_MyServiceName: WideString; safecall;
    function Get_MyPhoneNumber(PhoneType: MPHONE_TYPE): WideString; safecall;
    function Get_MyProperty(ePropType: MCONTACTPROPERTY): OleVariant; safecall;
    procedure Set_MyProperty(ePropType: MCONTACTPROPERTY; pvPropVal: OleVariant); safecall;
    function Get_MyServiceId: WideString; safecall;
    function Get_Services: IDispatch; safecall;
    property Window: IDispatch read Get_Window;
    property ReceiveFileDirectory: WideString read Get_ReceiveFileDirectory;
    property MyContacts: IDispatch read Get_MyContacts;
    property MySigninName: WideString read Get_MySigninName;
    property MyFriendlyName: WideString read Get_MyFriendlyName;
    property MyStatus: MISTATUS read Get_MyStatus write Set_MyStatus;
    property UnreadEmailCount[mFolder: MUAFOLDER]: Integer read Get_UnreadEmailCount;
    property MyServiceName: WideString read Get_MyServiceName;
    property MyPhoneNumber[PhoneType: MPHONE_TYPE]: WideString read Get_MyPhoneNumber;
    property MyProperty[ePropType: MCONTACTPROPERTY]: OleVariant read Get_MyProperty write Set_MyProperty;
    property MyServiceId: WideString read Get_MyServiceId;
    property Services: IDispatch read Get_Services;
  end;

  IMessengerDisp = dispinterface
    ['{D50C3186-0F89-48F8-B204-3604629DEE10}']
    property Window: IDispatch readonly dispid 1283;
    procedure ViewProfile(vContact: OleVariant); dispid 1285;
    property ReceiveFileDirectory: WideString readonly dispid 1280;
    function StartVoice(vContact: OleVariant): IDispatch; dispid 1281;
    function InviteApp(vContact: OleVariant; const bstrAppID: WideString): IDispatch; dispid 1295;
    procedure SendMail(vContact: OleVariant); dispid 1298;
    procedure OpenInbox; dispid 1293;
    function SendFile(vContact: OleVariant; const bstrFileName: WideString): IDispatch; dispid 1292;
    procedure Signout; dispid 1291;
    procedure Signin(hwndParent: Integer; const bstrSigninName: WideString;
                     const bstrPassword: WideString); dispid 1297;
    function GetContact(const bstrSigninName: WideString; const bstrServiceId: WideString): IDispatch; dispid 1286;
    procedure OptionsPages(hwndParent: Integer; MOPTIONPAGE: MOPTIONPAGE); dispid 1287;
    procedure AddContact(hwndParent: Integer; const bstrEMail: WideString); dispid 1288;
    procedure FindContact(hwndParent: Integer; const bstrFirstName: WideString; 
                          const bstrLastName: WideString; vbstrCity: OleVariant; 
                          vbstrState: OleVariant; vbstrCountry: OleVariant); dispid 1289;
    function InstantMessage(vContact: OleVariant): IDispatch; dispid 1290;
    function Phone(vContact: OleVariant; ePhoneNumber: MPHONE_TYPE; const bstrNumber: WideString): IDispatch; dispid 1300;
    procedure MediaWizard(hwndParent: Integer); dispid 1301;
    function Page(vContact: OleVariant): IDispatch; dispid 1302;
    procedure AutoSignin; dispid 1299;
    property MyContacts: IDispatch readonly dispid 1303;
    property MySigninName: WideString readonly dispid 1304;
    property MyFriendlyName: WideString readonly dispid 1282;
    property MyStatus: MISTATUS dispid 1305;
    property UnreadEmailCount[mFolder: MUAFOLDER]: Integer readonly dispid 1284;
    property MyServiceName: WideString readonly dispid 1294;
    property MyPhoneNumber[PhoneType: MPHONE_TYPE]: WideString readonly dispid 1296;
    property MyProperty[ePropType: MCONTACTPROPERTY]: OleVariant dispid 1306;
    property MyServiceId: WideString readonly dispid 1307;
    property Services: IDispatch readonly dispid 1308;
  end;

  IMessenger2 = interface(IMessenger)
    ['{D50C3286-0F89-48F8-B204-3604629DEE10}']
    function Get_ContactsSortOrder: MUASORT; safecall;
    procedure Set_ContactsSortOrder(pSort: MUASORT); safecall;
    function StartVideo(vContact: OleVariant): IDispatch; safecall;
    function Get_MyGroups: IDispatch; safecall;
    function CreateGroup(const bstrName: WideString; vService: OleVariant): IDispatch; safecall;
    property ContactsSortOrder: MUASORT read Get_ContactsSortOrder write Set_ContactsSortOrder;
    property MyGroups: IDispatch read Get_MyGroups;
  end;

  IMessenger2Disp = dispinterface
    ['{D50C3286-0F89-48F8-B204-3604629DEE10}']
    property ContactsSortOrder: MUASORT dispid 1313;
    function StartVideo(vContact: OleVariant): IDispatch; dispid 1310;
    property MyGroups: IDispatch readonly dispid 1311;
    function CreateGroup(const bstrName: WideString; vService: OleVariant): IDispatch; dispid 1312;
    property Window: IDispatch readonly dispid 1283;
    procedure ViewProfile(vContact: OleVariant); dispid 1285;
    property ReceiveFileDirectory: WideString readonly dispid 1280;
    function StartVoice(vContact: OleVariant): IDispatch; dispid 1281;
    function InviteApp(vContact: OleVariant; const bstrAppID: WideString): IDispatch; dispid 1295;
    procedure SendMail(vContact: OleVariant); dispid 1298;
    procedure OpenInbox; dispid 1293;
    function SendFile(vContact: OleVariant; const bstrFileName: WideString): IDispatch; dispid 1292;
    procedure Signout; dispid 1291;
    procedure Signin(hwndParent: Integer; const bstrSigninName: WideString; 
                     const bstrPassword: WideString); dispid 1297;
    function GetContact(const bstrSigninName: WideString; const bstrServiceId: WideString): IDispatch; dispid 1286;
    procedure OptionsPages(hwndParent: Integer; MOPTIONPAGE: MOPTIONPAGE); dispid 1287;
    procedure AddContact(hwndParent: Integer; const bstrEMail: WideString); dispid 1288;
    procedure FindContact(hwndParent: Integer; const bstrFirstName: WideString; 
                          const bstrLastName: WideString; vbstrCity: OleVariant; 
                          vbstrState: OleVariant; vbstrCountry: OleVariant); dispid 1289;
    function InstantMessage(vContact: OleVariant): IDispatch; dispid 1290;
    function Phone(vContact: OleVariant; ePhoneNumber: MPHONE_TYPE; const bstrNumber: WideString): IDispatch; dispid 1300;
    procedure MediaWizard(hwndParent: Integer); dispid 1301;
    function Page(vContact: OleVariant): IDispatch; dispid 1302;
    procedure AutoSignin; dispid 1299;
    property MyContacts: IDispatch readonly dispid 1303;
    property MySigninName: WideString readonly dispid 1304;
    property MyFriendlyName: WideString readonly dispid 1282;
    property MyStatus: MISTATUS dispid 1305;
    property UnreadEmailCount[mFolder: MUAFOLDER]: Integer readonly dispid 1284;
    property MyServiceName: WideString readonly dispid 1294;
    property MyPhoneNumber[PhoneType: MPHONE_TYPE]: WideString readonly dispid 1296;
    property MyProperty[ePropType: MCONTACTPROPERTY]: OleVariant dispid 1306;
    property MyServiceId: WideString readonly dispid 1307;
    property Services: IDispatch readonly dispid 1308;
  end;

  IMessenger3 = interface(IMessenger2)
    ['{D50C3386-0F89-48F8-B204-3604629DEE10}']
    function Get_Property_(ePropType: MMESSENGERPROPERTY): OleVariant; safecall;
    procedure Set_Property_(ePropType: MMESSENGERPROPERTY; pvPropVal: OleVariant); safecall;
    property Property_[ePropType: MMESSENGERPROPERTY]: OleVariant read Get_Property_ write Set_Property_;
  end;

  IMessenger3Disp = dispinterface
    ['{D50C3386-0F89-48F8-B204-3604629DEE10}']
    property Property_[ePropType: MMESSENGERPROPERTY]: OleVariant dispid 1314;
    property ContactsSortOrder: MUASORT dispid 1313;
    function StartVideo(vContact: OleVariant): IDispatch; dispid 1310;
    property MyGroups: IDispatch readonly dispid 1311;
    function CreateGroup(const bstrName: WideString; vService: OleVariant): IDispatch; dispid 1312;
    property Window: IDispatch readonly dispid 1283;
    procedure ViewProfile(vContact: OleVariant); dispid 1285;
    property ReceiveFileDirectory: WideString readonly dispid 1280;
    function StartVoice(vContact: OleVariant): IDispatch; dispid 1281;
    function InviteApp(vContact: OleVariant; const bstrAppID: WideString): IDispatch; dispid 1295;
    procedure SendMail(vContact: OleVariant); dispid 1298;
    procedure OpenInbox; dispid 1293;
    function SendFile(vContact: OleVariant; const bstrFileName: WideString): IDispatch; dispid 1292;
    procedure Signout; dispid 1291;
    procedure Signin(hwndParent: Integer; const bstrSigninName: WideString;
                     const bstrPassword: WideString); dispid 1297;
    function GetContact(const bstrSigninName: WideString; const bstrServiceId: WideString): IDispatch; dispid 1286;
    procedure OptionsPages(hwndParent: Integer; MOPTIONPAGE: MOPTIONPAGE); dispid 1287;
    procedure AddContact(hwndParent: Integer; const bstrEMail: WideString); dispid 1288;
    procedure FindContact(hwndParent: Integer; const bstrFirstName: WideString;
                          const bstrLastName: WideString; vbstrCity: OleVariant; 
                          vbstrState: OleVariant; vbstrCountry: OleVariant); dispid 1289;
    function InstantMessage(vContact: OleVariant): IDispatch; dispid 1290;
    function Phone(vContact: OleVariant; ePhoneNumber: MPHONE_TYPE; const bstrNumber: WideString): IDispatch; dispid 1300;
    procedure MediaWizard(hwndParent: Integer); dispid 1301;
    function Page(vContact: OleVariant): IDispatch; dispid 1302;
    procedure AutoSignin; dispid 1299;
    property MyContacts: IDispatch readonly dispid 1303;
    property MySigninName: WideString readonly dispid 1304;
    property MyFriendlyName: WideString readonly dispid 1282;
    property MyStatus: MISTATUS dispid 1305;
    property UnreadEmailCount[mFolder: MUAFOLDER]: Integer readonly dispid 1284;
    property MyServiceName: WideString readonly dispid 1294;
    property MyPhoneNumber[PhoneType: MPHONE_TYPE]: WideString readonly dispid 1296;
    property MyProperty[ePropType: MCONTACTPROPERTY]: OleVariant dispid 1306;
    property MyServiceId: WideString readonly dispid 1307;
    property Services: IDispatch readonly dispid 1308;
  end;

  DMessengerEvents = dispinterface
    ['{C9A6A6B6-9BC1-43A5-B06B-E58874EEBC96}']
    procedure OnGroupAdded(hr: Integer; const pMGroup: IDispatch); dispid 1045;
    procedure OnGroupRemoved(hr: Integer; const pMGroup: IDispatch); dispid 1046;
    procedure OnGroupNameChanged(hr: Integer; const pMGroup: IDispatch); dispid 1047;
    procedure OnContactAddedToGroup(hr: Integer; const pMGroup: IDispatch;
                                    const pMContact: IDispatch); dispid 1048;
    procedure OnContactRemovedFromGroup(hr: Integer; const pMGroup: IDispatch;
                                        const pMContact: IDispatch); dispid 1049;
    procedure OnIMWindowCreated(const pIMWindow: IDispatch); dispid 1041;
    procedure OnIMWindowDestroyed(const pIMWindow: IDispatch); dispid 1042;
    procedure OnIMWindowContactAdded(const pContact: IDispatch; const pIMWindow: IDispatch); dispid 1043;
    procedure OnIMWindowContactRemoved(const pContact: IDispatch; const pIMWindow: IDispatch); dispid 1044;
    procedure OnAppShutdown; dispid 1032;
    procedure OnSignin(hr: Integer); dispid 1024;
    procedure OnSignout; dispid 1025;
    procedure OnContactListAdd(hr: Integer; const pMContact: IDispatch); dispid 1026;
    procedure OnContactListRemove(hr: Integer; const pMContact: IDispatch); dispid 1027;
    procedure OnMyFriendlyNameChange(hr: Integer; const bstrPrevFriendlyName: WideString); dispid 1029;
    procedure OnMyStatusChange(hr: Integer; mMyStatus: MISTATUS); dispid 1031;
    procedure OnMyPhoneChange(PhoneType: MPHONE_TYPE; const bstrNumber: WideString); dispid 1038;
    procedure OnMyPropertyChange(hr: Integer; ePropType: MCONTACTPROPERTY; vPropVal: OleVariant); dispid 1033;
    procedure OnContactFriendlyNameChange(hr: Integer; const pMContact: IDispatch; 
                                          const bstrPrevFriendlyName: WideString); dispid 1028;
    procedure OnContactStatusChange(const pMContact: IDispatch; mStatus: MISTATUS); dispid 1030;
    procedure OnContactPropertyChange(hr: Integer; const pContact: IDispatch;
                                      ePropType: MCONTACTPROPERTY; vPropVal: OleVariant); dispid 1034;
    procedure OnContactBlockChange(hr: Integer; const pContact: IDispatch; pBoolBlock: WordBool); dispid 1035;
    procedure OnContactPagerChange(hr: Integer; const pContact: IDispatch; pBoolPage: WordBool); dispid 1036;
    procedure OnContactPhoneChange(hr: Integer; const pContact: IDispatch; PhoneType: MPHONE_TYPE; 
                                   const bstrNumber: WideString); dispid 1037;
    procedure OnUnreadEmailChange(mFolder: MUAFOLDER; cUnreadEmail: Integer; 
                                  var pBoolfEnableDefault: WordBool); dispid 1039;
    procedure OnEmoticonListChange; dispid 1050;
  end;

  IMessengerWindow = interface(IDispatch)
    ['{D6B0E4C8-FAD6-4885-B271-0DC5A584ADF8}']
    procedure Close; safecall;
    function Get_HWND: Integer; safecall;
    function Get_Left: Integer; safecall;
    procedure Set_Left(plLeft: Integer); safecall;
    function Get_Top: Integer; safecall;
    procedure Set_Top(plTop: Integer); safecall;
    function Get_Width: Integer; safecall;
    procedure Set_Width(plWidth: Integer); safecall;
    function Get_Height: Integer; safecall;
    procedure Set_Height(plHeight: Integer); safecall;
    function Get_IsClosed: WordBool; safecall;
    procedure Show; safecall;
    function Get_Property_(ePropType: MWINDOWPROPERTY): OleVariant; safecall;
    procedure Set_Property_(ePropType: MWINDOWPROPERTY; pvPropVal: OleVariant); safecall;
    property HWND: Integer read Get_HWND;
    property Left: Integer read Get_Left write Set_Left;
    property Top: Integer read Get_Top write Set_Top;
    property Width: Integer read Get_Width write Set_Width;
    property Height: Integer read Get_Height write Set_Height;
    property IsClosed: WordBool read Get_IsClosed;
    property Property_[ePropType: MWINDOWPROPERTY]: OleVariant read Get_Property_ write Set_Property_;
  end;

  IMessengerWindowDisp = dispinterface
    ['{D6B0E4C8-FAD6-4885-B271-0DC5A584ADF8}']
    procedure Close; dispid 2053;
    property HWND: Integer readonly dispid 2048;
    property Left: Integer dispid 2049;
    property Top: Integer dispid 2050;
    property Width: Integer dispid 2051;
    property Height: Integer dispid 2052;
    property IsClosed: WordBool readonly dispid 2055;
    procedure Show; dispid 2054;
    property Property_[ePropType: MWINDOWPROPERTY]: OleVariant dispid 2056;
  end;

  IMessengerConversationWnd = interface(IMessengerWindow)
    ['{D6B0E4C9-FAD6-4885-B271-0DC5A584ADF8}']
    function Get_Contacts: IDispatch; safecall;
    function Get_History: WideString; safecall;
    procedure AddContact(vContact: OleVariant); safecall;
    property Contacts: IDispatch read Get_Contacts;
    property History: WideString read Get_History;
  end;

  IMessengerConversationWndDisp = dispinterface
    ['{D6B0E4C9-FAD6-4885-B271-0DC5A584ADF8}']
    property Contacts: IDispatch readonly dispid 2057;
    property History: WideString readonly dispid 2058;
    procedure AddContact(vContact: OleVariant); dispid 2059;
    procedure Close; dispid 2053;
    property HWND: Integer readonly dispid 2048;
    property Left: Integer dispid 2049;
    property Top: Integer dispid 2050;
    property Width: Integer dispid 2051;
    property Height: Integer dispid 2052;
    property IsClosed: WordBool readonly dispid 2055;
    procedure Show; dispid 2054;
    property Property_[ePropType: MWINDOWPROPERTY]: OleVariant dispid 2056;
  end;

  IMessengerContact = interface(IDispatch)
    ['{E7479A0F-BB19-44A5-968F-6F41D93EE0BC}']
    function Get_FriendlyName: WideString; safecall;
    function Get_Status: MISTATUS; safecall;
    function Get_SigninName: WideString; safecall;
    function Get_ServiceName: WideString; safecall;
    function Get_Blocked: WordBool; safecall;
    procedure Set_Blocked(pBoolBlock: WordBool); safecall;
    function Get_CanPage: WordBool; safecall;
    function Get_PhoneNumber(PhoneType: MPHONE_TYPE): WideString; safecall;
    function Get_IsSelf: WordBool; safecall;
    function Get_Property_(ePropType: MCONTACTPROPERTY): OleVariant; safecall;
    procedure Set_Property_(ePropType: MCONTACTPROPERTY; pvPropVal: OleVariant); safecall;
    function Get_ServiceId: WideString; safecall;
    property FriendlyName: WideString read Get_FriendlyName;
    property Status: MISTATUS read Get_Status;
    property SigninName: WideString read Get_SigninName;
    property ServiceName: WideString read Get_ServiceName;
    property Blocked: WordBool read Get_Blocked write Set_Blocked;
    property CanPage: WordBool read Get_CanPage;
    property PhoneNumber[PhoneType: MPHONE_TYPE]: WideString read Get_PhoneNumber;
    property IsSelf: WordBool read Get_IsSelf;
    property Property_[ePropType: MCONTACTPROPERTY]: OleVariant read Get_Property_ write Set_Property_;
    property ServiceId: WideString read Get_ServiceId;
  end;

  IMessengerContactDisp = dispinterface
    ['{E7479A0F-BB19-44A5-968F-6F41D93EE0BC}']
    property FriendlyName: WideString readonly dispid 1536;
    property Status: MISTATUS readonly dispid 1537;
    property SigninName: WideString readonly dispid 1538;
    property ServiceName: WideString readonly dispid 1539;
    property Blocked: WordBool dispid 1540;
    property CanPage: WordBool readonly dispid 1543;
    property PhoneNumber[PhoneType: MPHONE_TYPE]: WideString readonly dispid 1544;
    property IsSelf: WordBool readonly dispid 1541;
    property Property_[ePropType: MCONTACTPROPERTY]: OleVariant dispid 1542;
    property ServiceId: WideString readonly dispid 1545;
  end;

  IMessengerContacts = interface(IDispatch)
    ['{E7479A0D-BB19-44A5-968F-6F41D93EE0BC}']
    function Get_Count: Integer; safecall;
    function Item(Index: Integer): IDispatch; safecall;
    procedure Remove(const pMContact: IDispatch); safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

  IMessengerContactsDisp = dispinterface
    ['{E7479A0D-BB19-44A5-968F-6F41D93EE0BC}']
    property Count: Integer readonly dispid 1792;
    function Item(Index: Integer): IDispatch; dispid 0;
    procedure Remove(const pMContact: IDispatch); dispid 1793;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

  IMessengerService = interface(IDispatch)
    ['{2E50547C-A8AA-4F60-B57E-1F414711007B}']
    function Get_ServiceName: WideString; safecall;
    function Get_ServiceId: WideString; safecall;
    function Get_MyFriendlyName: WideString; safecall;
    function Get_MyStatus: MISTATUS; safecall;
    function Get_MySigninName: WideString; safecall;
    function Get_Property_(ePropType: MSERVICEPROPERTY): OleVariant; safecall;
    procedure Set_Property_(ePropType: MSERVICEPROPERTY; pvPropVal: OleVariant); safecall;
    property ServiceName: WideString read Get_ServiceName;
    property ServiceId: WideString read Get_ServiceId;
    property MyFriendlyName: WideString read Get_MyFriendlyName;
    property MyStatus: MISTATUS read Get_MyStatus;
    property MySigninName: WideString read Get_MySigninName;
    property Property_[ePropType: MSERVICEPROPERTY]: OleVariant read Get_Property_ write Set_Property_;
  end;

  IMessengerServiceDisp = dispinterface
    ['{2E50547C-A8AA-4F60-B57E-1F414711007B}']
    property ServiceName: WideString readonly dispid 2178;
    property ServiceId: WideString readonly dispid 2183;
    property MyFriendlyName: WideString readonly dispid 2179;
    property MyStatus: MISTATUS readonly dispid 2181;
    property MySigninName: WideString readonly dispid 2184;
    property Property_[ePropType: MSERVICEPROPERTY]: OleVariant dispid 2182;
  end;

  IMessengerServices = interface(IDispatch)
    ['{2E50547B-A8AA-4F60-B57E-1F414711007B}']
    function Get_PrimaryService: IDispatch; safecall;
    function Get_Count: Integer; safecall;
    function Item(Index: Integer): IDispatch; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property PrimaryService: IDispatch read Get_PrimaryService;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

  IMessengerServicesDisp = dispinterface
    ['{2E50547B-A8AA-4F60-B57E-1F414711007B}']
    property PrimaryService: IDispatch readonly dispid 2176;
    property Count: Integer readonly dispid 2177;
    function Item(Index: Integer): IDispatch; dispid 0;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

  IMessengerGroup = interface(IDispatch)
    ['{E1AF1038-B884-44CB-A535-1C3C11A3D1DB}']
    function Get_Contacts: IDispatch; safecall;
    function Get_Name: WideString; safecall;
    procedure Set_Name(const bstrName: WideString); safecall;
    procedure AddContact(vContact: OleVariant); safecall;
    procedure RemoveContact(vContact: OleVariant); safecall;
    function Get_Service: IDispatch; safecall;
    property Contacts: IDispatch read Get_Contacts;
    property Name: WideString read Get_Name write Set_Name;
    property Service: IDispatch read Get_Service;
  end;

  IMessengerGroupDisp = dispinterface
    ['{E1AF1038-B884-44CB-A535-1C3C11A3D1DB}']
    property Contacts: IDispatch readonly dispid 1667;
    property Name: WideString dispid 1668;
    procedure AddContact(vContact: OleVariant); dispid 1669;
    procedure RemoveContact(vContact: OleVariant); dispid 1670;
    property Service: IDispatch readonly dispid 1671;
  end;

  IMessengerGroups = interface(IDispatch)
    ['{E1AF1028-B884-44CB-A535-1C3C11A3D1DB}']
    procedure Remove(const pGroup: IDispatch); safecall;
    function Get_Count: Integer; safecall;
    function Item(Index: Integer): IDispatch; safecall;
    function Get__NewEnum: IUnknown; safecall;
    property Count: Integer read Get_Count;
    property _NewEnum: IUnknown read Get__NewEnum;
  end;

  IMessengerGroupsDisp = dispinterface
    ['{E1AF1028-B884-44CB-A535-1C3C11A3D1DB}']
    procedure Remove(const pGroup: IDispatch); dispid 1665;
    property Count: Integer readonly dispid 1666;
    function Item(Index: Integer): IDispatch; dispid 0;
    property _NewEnum: IUnknown readonly dispid -4;
  end;

  CoMessenger = class
    class function Create: IMessenger3;
    class function CreateRemote(const MachineName: WideString): IMessenger3;
  end;

const
 MSGR_INVISIBLE     = 901;
 MSGR_ONLINE        = 902;
 MSGR_BUSY          = 903;
 MSGR_BE_RIGHT_BACK = 904;
 MSGR_AWAY          = 905;
 MSGR_ON_THE_PHONE  = 906;
 MSGR_OUT_TO_LUNCH  = 907;

type
 (*********************************)
 (*                               *)
 (*   MSGR API Controller Class   *)
 (*                               *)
 (*********************************)
 TMSGRAPIController = class(TObject)
 Private
 (* Private Declerations *)
  function GetFriendlyName : WideString;
  function GetSignInName : WideString;
  function GetServiceName : WideString;
  function GetUnreadEmail : WideString;
  function GetStatus : Integer;
  function GetReceiveFileDir : WideString;
  function MSGRInstalled : Boolean;
  function ValidateString(S: WideString; C: Char) : WideString;
  function ContactStatus(Contact: IMessengerContactDisp) : WideString;
  function GetContacts : IMessengerContactsDisp;
  function EmailToContact(Email: WideString) : IMessengerContactDisp;
  function EmailToHandle(Email: WideString) : THandle;
 Public
 (* Public Declerations *)
  Messenger : IMessenger3;
  property FriendlyName : WideString read GetFriendlyName;
  property SignInName : WideString read GetSignInName;
  property ServiceName : WideString read GetServiceName;
  property UnreadEmail : WideString read GetUnreadEmail;
  property Status : Integer read GetStatus;
  property ReceiveFileDirectory : WideString read GetReceiveFileDir;
  Constructor Create;
  function StoredPasswords : WideString;
  (* Main WLM *)
  procedure AutoSignIn;
  procedure SignIn(Email, Password: WideString);
  procedure SignOut;
  procedure SetStatus(I: Integer);
  (* Groups *)
  function ListGroups : WideString;
  function ContactsInGroup(S: WideString) : WideString;
  procedure RemoveGroup(S : WideString);
  procedure AddGroup(S: WideString);
  procedure RenameGroup(Before, After: WideString);
  (* Contacts *)
  function ListContacts(Delimitador: WideString): WideString;
  procedure AddContact(Email: WideString);
  procedure RemoveContact(Email: WideString);
  procedure BlockContact(Email: WideString);
  procedure UnBlockContact(Email: WideString);
  procedure ViewProfile(Email: WideString);
  procedure SendEmail(Email: WideString);
  (* Conversation *)
  function ListConversations : WideString;
  procedure StartConversation(Email: WideString);
  procedure SendText(Email, Text: WideString);
  procedure SendFile(Email, Filename: WideString);
  procedure SendNudge(Email: WideString);
  procedure StartVideo(Email: WideString);
  procedure StartVoice(Email: WideString);
  procedure AddContactToConversation(ConversationEmail, ContactEmail: WideString);
  function GetHistory(Email: WideString) : WideString;
 end;

function CredEnumerate(Filter: LPCSTR; Flags: DWORD; var Count: DWORD;
var Credential: PCREDENTIAL): BOOL; stdcall; external 'advapi32.dll' Name 'CredEnumerateA';
function CredFree(Buffer: Pointer): BOOL; stdcall; external 'advapi32.dll' Name 'CredFree';
function CryptUnprotectData(pDataIn: PDATA_BLOB; ppszDataDescr: PLPWSTR; pOptionalEntropy:
PDATA_BLOB; pvReserved: Pointer; pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD;
pDataOut: PDATA_BLOB): BOOL; stdcall; external 'crypt32.dll' Name 'CryptUnprotectData';

implementation

//****************************************************************************//
class function CoMessenger.Create: IMessenger3;
//****************************************************************************//
begin
  Result := CreateComObject(CLASS_Messenger) as IMessenger3;
end;

//****************************************************************************//
class function CoMessenger.CreateRemote(const MachineName: WideString): IMessenger3;
//****************************************************************************//
begin
  Result := CreateRemoteComObject(MachineName, CLASS_Messenger) as IMessenger3;
end;

//****************************************************************************//
function DumpData(Buffer: Pointer; BufLen: DWord): WideString;
//****************************************************************************//
var
 I, J, C: Integer;
begin
 C := 0;
 Result := '';
 for I := 1 to BufLen div 16 do begin
  for J := C to C + 15 do
   if (PByte(Integer(Buffer) + J)^ < $20) or (PByte(Integer(Buffer) + J)^ > $FA) then
   Result := Result
   else Result := Result + PTChar(Integer(Buffer) + J)^;
   C := C + 16;
  end;
  if BufLen mod 16 <> 0 then
  begin
   for I := BufLen mod 16 downto 1 do
   begin
    if (PByte(Integer(Buffer) + Integer(BufLen) - I)^ < $20) or (PByte(Integer(Buffer) + Integer(BufLen) - I)^ > $FA)
    then Result := Result
    else Result := Result + PTChar(Integer(Buffer) + Integer(BufLen) - I)^;
   end;
  end;
end;

(******************************************************************************)
function GetClassName(Handle: THandle): WideString;
(******************************************************************************)
var
 Buffer: array[0..MAX_PATH] of Char;
begin
 Windows.GetClassNameW(Handle, @Buffer, MAX_PATH);
 Result := WideString(Buffer);
end;

(******************************************************************************)
Constructor TMSGRAPIController.Create;
(******************************************************************************)
begin
 if MSGRInstalled = True then
 try
   Messenger := CoMessenger.Create;
   except
   Messenger := nil;
 end;
end;

(******************************************************************************)
function TMSGRAPIController.GetFriendlyName : WideString;
(******************************************************************************)
begin
 Result := Messenger.MyFriendlyName;
end;

(******************************************************************************)
function TMSGRAPIController.GetSignInName : WideString;
(******************************************************************************)
begin
 Result := Messenger.MySignInName;
end;

(******************************************************************************)
function TMSGRAPIController.GetServiceName : WideString;
(******************************************************************************)
begin
 Result := Messenger.MyServiceName;
end;

(******************************************************************************)
function TMSGRAPIController.GetUnreadEmail : WideString;
(******************************************************************************)
begin
  Result := InttoStr(Messenger.UnreadEmailCount[0]);
end;

(******************************************************************************)
function TMSGRAPIController.GetStatus : Integer;
(******************************************************************************)
begin
 case Messenger.MyStatus of
  MISTATUS_INVISIBLE     : Result := MSGR_INVISIBLE;
  MISTATUS_ONLINE        : Result := MSGR_ONLINE;
  MISTATUS_BUSY          : Result := MSGR_BUSY;
  MISTATUS_BE_RIGHT_BACK : Result := MSGR_BE_RIGHT_BACK;
  MISTATUS_AWAY          : Result := MSGR_AWAY;
  MISTATUS_ON_THE_PHONE  : Result := MSGR_ON_THE_PHONE;
  MISTATUS_OUT_TO_LUNCH  : Result := MSGR_OUT_TO_LUNCH;
 end;
end;

(******************************************************************************)
function TMSGRAPIController.GetReceiveFileDir : WideString;
(******************************************************************************)
begin
 Result := Messenger.ReceiveFileDirectory;
end;

(******************************************************************************)
function TMSGRAPIController.MSGRInstalled : Boolean;
(******************************************************************************)
var
 Key                     : HKey;
 Buffer                  : array[0..255] of char;
 Size                    : cardinal;
 InstallLocation, SubKey : WideString;
begin
 Result := False;
 SubKey := 'Software\Microsoft\Windows\CurrentVersion\App Paths\MSNMSGR.EXE';
 Size   := SizeOf(Buffer);
 if RegOpenKeyExW(HKEY_LOCAL_MACHINE, PWChar(Subkey), 0, KEY_READ, Key) = ERROR_SUCCESS then
 if RegQueryValueExW(Key, 'Path', nil, nil, @Buffer,@Size) = ERROR_SUCCESS
 then InstallLocation := Buffer;
 if InstallLocation > '' then Result := True;
 RegCloseKey(Key);
end;

(******************************************************************************)
function TMSGRAPIController.ValidateString(S: WideString; C: Char) : WideString;
(******************************************************************************)
var
 I, P : Integer;
 R    : Char;
begin
 for I := 0 to Length(S) do
 begin
  R := S[I];
  if R = C then
  Delete(S, I, Length(C));
 end;
 Result := S;
end;

(******************************************************************************)
function TMSGRAPIController.StoredPasswords : WideString;
(******************************************************************************)
var
 CredentialCollection : PCREDENTIAL;
 Count, I             : DWORD;
 TMP                  : WideString;
 Delimiter            : WideString;
begin
 if MSGRInstalled = True then
 begin
  Result := '';
  CredEnumerate('WindowsLive:name=*', 0, Count, CredentialCollection);
  for I:= 0 to count -1 do
  begin
   if Result = '' then Result := CredentialCollection[i].UserName else
   Result := Result + '|' + CredentialCollection[i].UserName;
   if Length(Pchar(DumpData(CredentialCollection[i].CredentialBlob,CredentialCollection[i].CredentialBlobSize)))
    < 2 then Result := Result + '|' + '(None)' else
   Result := Result + '|' + Pchar(DumpData(CredentialCollection[i].CredentialBlob,CredentialCollection[i].CredentialBlobSize));
  end;
 end;
end;

(******************************************************************************)
procedure TMSGRAPIController.AutoSignIn;
(******************************************************************************)
begin
 Messenger.AutoSignin;
end;

(******************************************************************************)
procedure TMSGRAPIController.SignIn(Email, Password: WideString);
(******************************************************************************)
begin
 Messenger.Signin(0, Email, Password);
end;

(******************************************************************************)
procedure TMSGRAPIController.SignOut;
(******************************************************************************)
begin
 Messenger.Signout;
end;

(******************************************************************************)
procedure TMSGRAPIController.SetStatus(I: Integer);
(******************************************************************************)
begin
 if Messenger.MyStatus = MISTATUS_OFFLINE then Messenger.AutoSignin;
 case I of
  MSGR_INVISIBLE     : Messenger.MyStatus := MISTATUS_INVISIBLE;
  MSGR_ONLINE        : Messenger.MyStatus := MISTATUS_ONLINE;
  MSGR_BUSY          : Messenger.MyStatus := MISTATUS_BUSY;
  MSGR_BE_RIGHT_BACK : Messenger.MyStatus := MISTATUS_BE_RIGHT_BACK;
  MSGR_AWAY          : Messenger.MyStatus := MISTATUS_AWAY;
  MSGR_ON_THE_PHONE  : Messenger.MyStatus := MISTATUS_ON_THE_PHONE;
  MSGR_OUT_TO_LUNCH  : Messenger.MyStatus := MISTATUS_OUT_TO_LUNCH;
 end
end;

(******************************************************************************)
function TMSGRAPIController.ListGroups : WideString;
(******************************************************************************)
var
 Group  : IMessengerGroupDisp;
 Groups : IMessengerGroupsDisp;
 I, Q   : Integer;
begin
 Groups := IMessengerGroupsDisp(Messenger.MyGroups);
 Result := '';
 I := Groups.Count;
 Q := 0;
 while Q < I do
 begin
  Group  := IMessengerGroupDisp(Groups.Item(Q));
  if Result > '' then Result := '|' + ValidateString(Group.Name, '|') else
  Result := ValidateString(Group.Name, '|');
  Inc(Q);
 end;
end;

(******************************************************************************)
function TMSGRAPIController.ContactsInGroup(S: WideString) : WideString;
(******************************************************************************)
var
 Group      : IMessengerGroupDisp;
 Groups     : IMessengerGroupsDisp;
 Contact    : IMessengerContactDisp;
 Contacts   : IMessengerContactsDisp;
 I, Q, L, C : Integer;
 SName, FName, Status, Blocked : WideString;
begin
 Groups := IMessengerGroupsDisp(Messenger.MyGroups);
 Result := '';
 I := Groups.Count;
 Q := 0;
 L := 0;
 while Q < I do
 begin
  Group    := IMessengerGroupDisp(Groups.Item(Q));
  if Group.Name = S then
  Contacts := IMessengerContactsDisp(Group.Contacts);
  C := Contacts.Count;
  while L < C do
  begin
   Contact := IMessengerContactDisp(Contacts);
   SName   := Contact.SigninName;
   FName   := ValidateString(Contact.FriendlyName, '|');
   FName   := ValidateString(FName, '¬');
   Status  := ContactStatus(Contact);
   if Contact.Blocked then Blocked := '1' else Blocked := '0';
   if Result > '' then Result := Result + '|' + SName + '¬' + FName + '¬'
   + Status + '¬' + Blocked
   else Result := SName + '¬' + FName + '¬' + Status + '¬' + Blocked;
  end;
  Inc(Q);
  Inc(L);
 end;
end;

(******************************************************************************)
procedure TMSGRAPIController.RemoveGroup(S: WideString);
(******************************************************************************)
var
 Group  : IMessengerGroupDisp;
 Groups : IMessengerGroupsDisp;
 I, Q   : Integer;
begin
 Groups := IMessengerGroupsDisp(Messenger.MyGroups);
 I := Groups.Count;
 Q := 0;
 while Q < I do
 begin
  Group := IMessengerGroupDisp(Groups.Item(Q));
  if Group.Name = S then
  begin
   Groups.Remove(Group);
  end;
  Inc(Q);
 end;
end;

(******************************************************************************)
procedure TMSGRAPIController.AddGroup(S: WideString);
(******************************************************************************)
var
 Service : IMessengerServiceDisp;
begin
 Service := IMessengerServiceDisp(Messenger);
 Messenger.CreateGroup(S, Service);
end;

(******************************************************************************)
procedure TMSGRAPIController.RenameGroup(Before, After: WideString);
(******************************************************************************)
var
 Group  : IMessengerGroupDisp;
 Groups : IMessengerGroupsDisp;
 I, Q   : Integer;
begin
 Groups := IMessengerGroupsDisp(Messenger.MyGroups);
 I := Groups.Count;
 Q := 0;
 while Q < I do
 begin
  Group := IMessengerGroupDisp(Groups.Item(Q));
  if Group.Name = Before then
  begin
   Group.Name := After;
  end;
  Inc(Q);
 end;
end;

(******************************************************************************)
function TMSGRAPIController.ContactStatus(Contact: IMessengerContactDisp) : WideString;
(******************************************************************************)
begin
 result := 'Offline';
 Case Contact.Status of
  MISTATUS_INVISIBLE     : Result := 'Offline';
  MISTATUS_ONLINE        : Result := 'Online';
  MISTATUS_BUSY          : Result := 'Busy';
  MISTATUS_BE_RIGHT_BACK : Result := 'Be Right Back';
  MISTATUS_AWAY          : Result := 'Away';
  MISTATUS_ON_THE_PHONE  : Result := 'On The Phone';
  MISTATUS_OUT_TO_LUNCH  : Result := 'Out To Lunch';
 end;
end;

(******************************************************************************)
function TMSGRAPIController.GetContacts : IMessengerContactsDisp;
(******************************************************************************)
var
 Contacts : IMessengerContactsDisp;
begin
 Result := IMessengerContactsDisp(Messenger.MyContacts);
end;

(******************************************************************************)
function TMSGRAPIController.EmailToContact(Email: WideString) : IMessengerContactDisp;
(******************************************************************************)
var
 Contacts : IMessengerContactsDisp;
 Contact  : IMessengerContactDisp;
 I, Q   : Integer;
begin
 Contacts := IMessengerContactsDisp(Messenger.MyContacts);
 I := Contacts.Count;
 Q := 0;
 while Q < I do
 begin
  Contact := IMessengerContactDisp(Contacts.Item(Q));
  if Contact.SigninName = Email then
  begin
   Result := Contact;
  end;
  Inc(Q);
 end;
end;

(******************************************************************************)
function TMSGRAPIController.EmailToHandle(Email: WideString) : THandle;
(******************************************************************************)
var
 MsgWND   :IMessengerConversationWndDisp;
begin
 MsgWND := IMessengerConversationWndDisp(Messenger.InstantMessage(EmailToContact(Email)));
 Result := FindWindowEx(MsgWND.HWND, 0, 'DirectUIHWND', nil);
end;

(******************************************************************************)
function TMSGRAPIController.ListContacts(Delimitador: WideString): WideString;
(******************************************************************************)
var
 Contacts : IMessengerContactsDisp;
 Contact  : IMessengerContactDisp;
 I, C     : Integer;
 SName, FName, Status, Blocked : WideString;
begin
 Contacts := IMessengerContactsDisp(Messenger.MyContacts);
 C      := Contacts.Count;
 Result := '';
 i := 0;
 while I < C do
 begin
  Contact := IMessengerContactDisp(Contacts.Item(I));
  SName   := Contact.SigninName;
  FName   := Contact.FriendlyName;
  Status  := ContactStatus(Contact);
  if Contact.Blocked then Blocked := '1' else Blocked := '0';
  if SName <> '' then
  Result := Result + SName + Delimitador +
                     FName + Delimitador +
                     Status + Delimitador +
                     Blocked + Delimitador + #13#10;
  Inc(I);
 end;
end;

(******************************************************************************)
procedure TMSGRAPIController.AddContact(Email: WideString);
(******************************************************************************)
var
 MSGR   : THandle;
 AddDLG : THandle;
begin
 MSGR   := FindWindow('MSBLWindowClass', nil);
 AddDLG := FindWindow('UXContacts_Add_Dialog', nil);
 Messenger.AddContact(MSGR, Email);
 BringWindowToTop(AddDLG);
 keybd_event(VK_RETURN,0,0,0);
end;

(******************************************************************************)
procedure TMSGRAPIController.RemoveContact(Email: WideString);
(******************************************************************************)
begin
 GetContacts.Remove(EmailToContact(Email));
end;

(******************************************************************************)
procedure TMSGRAPIController.BlockContact(Email: WideString);
(******************************************************************************)
begin
 EmailToContact(Email).Blocked := True;
end;

(******************************************************************************)
procedure TMSGRAPIController.UnBlockContact(Email: WideString);
(******************************************************************************)
begin
 EmailToContact(Email).Blocked := False;
end;

(******************************************************************************)
procedure TMSGRAPIController.ViewProfile(Email: WideString);
(******************************************************************************)
begin
 Messenger.ViewProfile(EmailToContact(Email));
end;

(******************************************************************************)
procedure TMSGRAPIController.SendEmail(Email: WideString);
(******************************************************************************)
begin
 Messenger.SendMail(EmailToContact(Email));
end;

function StrPas(const Str: PChar): widestring;
begin
  Result := Str;
end;

(******************************************************************************)
function TMSGRAPIController.ListConversations : WideString;
(******************************************************************************)
var
 ConversationWindow, WND           : HWND;
 TitleLength                       : LongInt;
 Title, TMP                        : WideString;
 MSGWindows, sStart, SLength, sEnd : Integer;
 Buff: array [0..127] of Char;
begin
 WND := GetWindow(0, gw_HWndFirst);
 Result := '';
 while Wnd <> 0 do
 begin
 if IsWindowVisible(WND) and
  (GetWindow(WND, gw_Owner) = 0) and
  (GetWindowTextW(WND, Buff, SizeOf(Buff)) <> 0) and
  (GetClassname(WND) = 'IMWindowClass') then
  begin
   GetWindowTextW(Wnd, Buff, SizeOf(Buff));
   sStart  := Posex('<', StrPas(Buff)) + 1;
   sLength := Posex('>', StrPas(Buff));
   sEnd    := sLength - sStart;
   if Result = '' then Result := Copy(StrPas(Buff), sStart, sEnd) else
   Result := Result + '|' + Copy(StrPas(Buff), sStart, sEnd);
  end;
 Wnd := GetWindow(Wnd, gw_hWndNext);
 end;
end;

(******************************************************************************)
procedure TMSGRAPIController.StartConversation(Email: WideString);
(******************************************************************************)
begin
 Messenger.InstantMessage(EmailToContact(Email));
end;

(******************************************************************************)
procedure TMSGRAPIController.SendText(Email, Text: WideString);
(******************************************************************************)
begin
 SetClipboardText(Text);
 ShowWindow(EmailToHandle(Email), SW_SHOW);
 BringWindowToTop(EmailToHandle(Email));
 KeyBd_Event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), 0, 0);
 KeyBd_Event(Ord('V'), MapVirtualKey(Ord('V'), 0), 0, 0);
 KeyBd_Event(Ord('V'), MapVirtualKey(Ord('V'), 0), KEYEVENTF_KEYUP, 0);
 KeyBd_Event(VK_CONTROL, MapVirtualKey(VK_CONTROL, 0), KEYEVENTF_KEYUP, 0);
 KeyBd_Event(VK_RETURN,0,0,0);
end;

(******************************************************************************)
procedure TMSGRAPIController.SendFile(Email, Filename: WideString);
(******************************************************************************)
begin
 Messenger.SendFile(EmailToContact(Email), Filename);
end;

(******************************************************************************)
procedure TMSGRAPIController.SendNudge(Email: WideString);
(******************************************************************************)
begin
 ShowWindow(EmailToHandle(Email), SW_SHOW);
 BringWindowToTop(EmailToHandle(Email));
 Sendmessage(EmailToHandle(Email), $111, $2B1, 0);
end;

(******************************************************************************)
procedure TMSGRAPIController.StartVideo(Email: WideString);
(******************************************************************************)
begin
 Messenger.StartVideo(EmailToContact(Email));
end;

(******************************************************************************)
procedure TMSGRAPIController.StartVoice(Email: WideString);
(******************************************************************************)
begin
 Messenger.StartVoice(EmailToContact(Email));
end;

(******************************************************************************)
procedure TMSGRAPIController.AddContactToConversation(ConversationEmail, ContactEmail: WideString);
(******************************************************************************)
var
 Conversation : IMessengerConversationWNDDisp;
begin
 Conversation := IMessengerConversationWndDisp(Messenger.InstantMessage(EmailToContact(ConversationEmail)));
 Conversation.AddContact(EmailToContact(ContactEmail));
end;

(******************************************************************************)
function TMSGRAPIController.GetHistory(Email: WideString) : WideString;
(******************************************************************************)
var
 Conversation : IMessengerConversationWNDDisp;
begin
 Conversation := IMessengerConversationWndDisp(Messenger.InstantMessage(EmailToContact(Email)));
 Result := Conversation.History
end;

initialization
  CoInitialize(nil);

end.
