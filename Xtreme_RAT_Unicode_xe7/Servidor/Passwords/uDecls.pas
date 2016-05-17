//*****************************************//
// Carlo Pasolini                          //
// http://pasotech.altervista.org          //
// email: cdpasop@hotmail.it               //
//*****************************************//
unit uDecls;

interface

type
  PANSI_STRING = ^ANSI_STRING;
  ANSI_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: PAnsiChar;
  end;

  PUNICODE_STRING = ^UNICODE_STRING;
  UNICODE_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
  end;

  PLSA_UNICODE_STRING = ^LSA_UNICODE_STRING;
  LSA_UNICODE_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
  end;

  PLSA_OBJECT_ATTRIBUTES = ^LSA_OBJECT_ATTRIBUTES;
  LSA_OBJECT_ATTRIBUTES = record
    Length: Cardinal;
    RootDirectory: Cardinal;
    ObjectName: PLSA_UNICODE_STRING;
    Attributes: Cardinal;
    //puntatore a  SECURITY_DESCRIPTOR
    SecurityDescriptor: Pointer;
    //puntatore a SECURITY_QUALITY_OF_SERVICE
    SecurityQualityOfService: Pointer;
  end;

  PLIST_ENTRY = ^LIST_ENTRY;
  LIST_ENTRY = record
    Flink: PLIST_ENTRY;
    Blink: PLIST_ENTRY;
  end;

  LDR_MODULE = record // not packed!
    InLoadOrderLinks: LIST_ENTRY;
    InMemoryOrderLinks: LIST_ENTRY;
    InInitializationOrderLinks: LIST_ENTRY;
    DllBase: Cardinal;
    EntryPoint: Cardinal;
    SizeOfImage: Cardinal;
    FullDllName: UNICODE_STRING;
    BaseDllName: UNICODE_STRING;
    Flags: Cardinal;
    LoadCount: SmallInt;
    TlsIndex: SmallInt;
    HashLinks: LIST_ENTRY;
    TimeDateStamp: Cardinal;
    LoadedImports: Pointer;
    EntryPointActivationContext: Pointer; // PACTIVATION_CONTEXT
    PatchInformation: Pointer;
  end;

  PPEB_LDR_DATA = ^PEB_LDR_DATA;
  PPPEB_LDR_DATA = ^PPEB_LDR_DATA;
  PEB_LDR_DATA = record // not packed!
  (*000*)Length: Cardinal;
  (*004*)Initialized: BOOLEAN;
  (*008*)SsHandle: Pointer;
  (*00c*)InLoadOrderModuleList: LIST_ENTRY;
  (*014*)InMemoryOrderModuleList: LIST_ENTRY;
  (*01c*)InInitializationOrderModuleList: LIST_ENTRY;
  (*024*)EntryInProgress: Pointer;
  end;

function  RtlAnsiStringToUnicodeString(
    DestinationString : PUNICODE_STRING;
    SourceString : PANSI_STRING;
    AllocateDestinationString : Boolean
  ): Integer; stdcall; external 'ntdll.dll';

function  RtlUnicodeStringToAnsiString(
    DestinationString : PANSI_STRING;
    SourceString : PUNICODE_STRING;
    AllocateDestinationString : Boolean
  ): Integer; stdcall; external 'ntdll.dll';

procedure RtlFreeAnsiString(
    AnsiString : PANSI_STRING
  ); stdcall; external 'ntdll.dll';

procedure RtlFreeUnicodeString(
    UnicodeString : PUNICODE_STRING
     ); stdcall; external 'ntdll.dll';

function RtlNtStatusToDosError(const Status : Integer
  ): Cardinal; stdcall; external 'ntdll.dll';

function  NtQueryInformationProcess(
    ProcessHandle : Cardinal;
    ProcessInformationClass : Byte;
    ProcessInformation : Pointer;
    ProcessInformationLength : Cardinal;
    ReturnLength : PCardinal
  ): Integer; stdcall; external 'ntdll.dll';

function LsaOpenPolicy(
            SystemName: PUNICODE_STRING;
            var ObjectAttributes: LSA_OBJECT_ATTRIBUTES;
            DesiredAccess: Cardinal;
            var PolicyHandle: Pointer
            ): Integer; stdcall; external 'advapi32.dll';

function LsaClose(
            ObjectHandle: Pointer
            ): Integer; stdcall; external 'advapi32.dll';

function LsaRetrievePrivateData(
            PolicyHandle: Pointer;
            const KeyName: UNICODE_STRING;
            var PrivateData: PUNICODE_STRING
            ): Integer; stdcall; external 'advapi32.dll';

function LsaNtStatusToWinError(
            Status: Integer
            ): Cardinal; stdcall; external 'advapi32.dll';

function LsaFreeMemory(
            Buffer: Pointer
            ): Integer; stdcall; external 'advapi32.dll';


implementation


end.
