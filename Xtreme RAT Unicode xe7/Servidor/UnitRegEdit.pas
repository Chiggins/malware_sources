unit UnitRegEdit;

interface

uses
  StrUtils,windows,
  MiniReg,
  UnitFuncoesDiversas;

function ListarChaves(Str: widestring): widestring;
function ListarDados(Str: widestring): widestring;
function AdicionarDados(Str: widestring): boolean;
function AdicionarChave(Str: widestring): boolean;
function DeletarRegistro(Str: widestring): boolean;
function DeletarChave(Str: widestring): boolean;
function StrToHKEY(sKey: wideString): HKEY;
function RenameRegistryItem(AKey: HKEY; Old, New: wideString): boolean;
function RenameRegistryValue(AKey,
                             SubKey,
                             KeyType,
                             OldName,
                             ValueData,
                             NewName: widestring): boolean;
function RegWriteString(Key: HKey; SubKey: widestring; DataType: integer; Data: widestring; Value: widestring): boolean;

implementation

uses
  UnitConstantes;

function StrToHKEY(sKey: wideString): HKEY;
begin
  if sKey = 'HKEY_CLASSES_ROOT' then Result := HKEY_CLASSES_ROOT;
  if sKey = 'HKEY_CURRENT_USER' then Result := HKEY_CURRENT_USER;
  if sKey = 'HKEY_LOCAL_MACHINE' then Result := HKEY_LOCAL_MACHINE;
  if sKey = 'HKEY_USERS' then Result := HKEY_USERS;
  if sKey = 'HKEY_CURRENT_CONFIG' then Result := HKEY_CURRENT_CONFIG;
end;

function StrToKeyType(sKey: wideString): integer;
begin
  if sKey = 'REG_DWORD' then Result := REG_DWORD;
  if sKey = 'REG_BINARY' then Result := REG_BINARY;
  if sKey = 'REG_EXPAND_SZ' then Result := REG_EXPAND_SZ;
  if sKey = 'REG_MULTI_SZ' then Result := REG_MULTI_SZ;
  if sKey = 'REG_SZ' then Result := REG_SZ;
end;

function RegWriteString(Key: HKey; SubKey: widestring; DataType: integer; Data: widestring; Value: widestring): boolean;
var
  RegKey: HKey;
  Arr: array of Byte;
  i: integer;
begin
  if DataType = REG_BINARY then
  begin
    setlength(arr, length(value));
    for I := 0 to length(value) - 1 do
    arr[i] := byte(value[i + 1]);

    RegCreateKeyW(Key, pwidechar(SubKey), RegKey);
    result := RegSetValueExW(RegKey, pwidechar(Data), 0, DataType, arr, Length(Value)) = 0;
    RegCloseKey(RegKey);
  end else
  begin
    RegCreateKeyW(Key, pwidechar(SubKey), RegKey);
    result := RegSetValueExW(RegKey, pwidechar(Data), 0, DataType, pWideChar(Value), Length(Value) * 2) = 0;
    RegCloseKey(RegKey);
  end;
end;

function ListarChaves(Str: widestring): widestring;
var
  Hkey, SubKey: widestring;
begin
  result := '';
  Hkey := Copy(Str, 1, posex('\', Str) - 1);
  delete(str, 1, posex('\', Str));
  SubKey := Str;
  if RegEnumKeys(strtohkey(HKEY), SubKey, Result) = false then result := '';
end;

function ListarDados(Str: widestring): widestring;
var
  Hkey, SubKey: widestring;
begin
  result := '';
  Hkey := Copy(Str, 1, posex('\', Str) - 1);
  delete(str, 1, posex('\', Str));
  SubKey := Str;
  if RegEnumValues(strtohkey(HKEY), SubKey, Result) = false then result := '';
end;

function IntToStr(i: Int64): wideString;
begin
  Str(i, Result);
end;

function StrToInt(S: wideString): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function AdicionarDados(Str: widestring): boolean;
var
  TempStr: widestring;
  Hkey, SubKey, Nome, Tipo, Dados: widestring;
begin
  Result := false;
  TempStr := Copy(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, length(delimitadorComandos));

  Hkey := Copy(TempStr, 1, posex('\', TempStr) - 1);
  delete(TempStr, 1, posex('\', TempStr));
  SubKey := TempStr;
  if SubKey[length(subkey)] <> '\' then SubKey := SubKey + '\';

  Nome := Copy(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, length(delimitadorComandos));

  Tipo := Copy(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, length(delimitadorComandos));

  Dados := Str;

  if StrToKeyType(Tipo) = REG_DWORD then
  begin
    result := MiniReg.RegSetDWORD(strtohkey(HKEY), SubKey + Nome, strtoint(Dados));
    Exit;
  end;
  result := RegWriteString(strtohkey(HKEY), SubKey, StrToKeyType(Tipo), Nome, Dados);
  
end;

function AdicionarChave(Str: widestring): boolean;
var
  TempStr: widestring;
  Hkey, SubKey, Nome: widestring;
begin
  Result := false;
  TempStr := Copy(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, length(delimitadorComandos));

  Hkey := Copy(TempStr, 1, posex('\', TempStr) - 1);
  delete(TempStr, 1, posex('\', TempStr));
  SubKey := TempStr;

  Nome := Str;

  Result := MiniReg._regCreateKey(strtohkey(HKEY), pwidechar(SubKey + Nome));
end;

function SHDeleteKey(key: HKEY; SubKey: Pwidechar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteKeyW';
function SHDeleteValue(key: HKEY; SubKey, value :Pwidechar): cardinal; stdcall; external 'shlwapi.dll' name 'SHDeleteValueW';

function DeletarRegistro(Str: widestring): boolean;
var
  TempStr: widestring;
  Hkey, SubKey, Nome: widestring;
begin
  Result := false;
  TempStr := Copy(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, posex(delimitadorComandos, str) - 1);
  Delete(Str, 1, length(delimitadorComandos));

  Hkey := Copy(TempStr, 1, posex('\', TempStr) - 1);
  delete(TempStr, 1, posex('\', TempStr));
  SubKey := TempStr;

  Nome := Str;

  Result := SHDeleteValue(strtohkey(HKEY), pwidechar(SubKey), Pwidechar(Nome)) = ERROR_SUCCESS;
end;

function DeletarChave(Str: widestring): boolean;
var
  Hkey, SubKey: widestring;
begin
  Result := false;

  Hkey := Copy(Str, 1, posex('\', Str) - 1);
  delete(Str, 1, posex('\', Str));
  SubKey := Str;

  result := SHDeleteKey(strtohkey(HKEY), pwidechar(SubKey)) = ERROR_SUCCESS;
end;

function AllocMem(Size: Cardinal): Pointer;
begin
  GetMem(Result, Size);
  FillChar(Result^, Size, 0);
end;

function RegEnumValueW(hKey: HKEY; dwIndex: DWORD; lpValueName: PWideChar;
  var lpcbValueName: DWORD; lpReserved: Pointer; lpType: PDWORD;
  lpData: PByte; lpcbData: PDWORD): Longint; stdcall; external 'advapi32.dll' name 'RegEnumValueW';

procedure CopyRegistryKey(Source, Dest: HKEY);
const
  DefValueSize  = 512;
  DefBufferSize = 8192;
var
  Status: Integer;
  Key: Integer;
  ValueSize,
  BufferSize: Cardinal;
  KeyType: Integer;
  ValueName: wideString;
  Buffer: Pointer;
  NewTo,
  NewFrom: HKEY;
begin
  SetLength(ValueName, DefValueSize);
  Buffer := AllocMem(DefBufferSize);
  try
    Key := 0;
    repeat
      ValueSize := DefValueSize;
      BufferSize := DefBufferSize;
      //  enumerate data values at current key
      Status := RegEnumValueW(Source, Key, PWideChar(ValueName), ValueSize, nil, @KeyType, Buffer, @BufferSize);
      if Status = ERROR_SUCCESS then
      begin
        // move each value to new place
        Status := RegSetValueExW(Dest, PWideChar(ValueName), 0, KeyType, Buffer, BufferSize);
         // delete old value
        RegDeleteValueW(Source, PWideChar(ValueName));
      end;
    until Status <> ERROR_SUCCESS; // Loop until all values found

    // start over,  looking for keys now instead of values
    Key := 0;
    repeat
      ValueSize := DefValueSize;
      BufferSize := DefBufferSize;
      Status := RegEnumKeyExW(Source, Key, PWideChar(ValueName), ValueSize, nil, Buffer, @BufferSize, nil);
      // was a valid key found?
      if Status = ERROR_SUCCESS then
      begin
        // open the key if found
        Status := RegCreateKeyW(Dest, PWideChar(ValueName), NewTo);
        if Status = ERROR_SUCCESS then
        begin                                       //  Create new key of old name
          Status := RegCreateKeyW(Source, PWideChar(ValueName), NewFrom);
          if Status = ERROR_SUCCESS then
          begin
            // if that worked,  recurse back here
            CopyRegistryKey(NewFrom, NewTo);
            RegCloseKey(NewFrom);
            RegDeleteKeyW(Source, PWideChar(ValueName));
          end;
          RegCloseKey(NewTo);
        end;
      end;
    until Status <> ERROR_SUCCESS; // loop until key enum fails
  finally
    FreeMem(Buffer);
  end;
end;

function RenameRegistryItem(AKey: HKEY; Old, New: wideString): boolean;
var
  OldKey,
  NewKey: HKEY;
  Status: Integer;
begin
  Result := false;
  // Open Source key
  Status := RegOpenKeyW(AKey,PwideChar(Old), OldKey);
  if Status = ERROR_SUCCESS then
  begin
    // Create Destination key
    Status := RegCreateKeyW(AKey,PwideChar(New), NewKey);
    if Status = ERROR_SUCCESS then
    begin
      CopyRegistryKey(OldKey, NewKey);
      Result := true;
    end;
    RegCloseKey(OldKey);
    RegCloseKey(NewKey);
    // Delete last top-level key
    RegDeleteKeyW(AKey, PWideChar(Old));
  end;
end;

function RenameRegistryValue(AKey,
                             SubKey,
                             KeyType,
                             OldName,
                             ValueData,
                             NewName: widestring): boolean;
var
  TempStr: widestring;
begin
  result := false;

  if SHDeleteValue(strtohkey(AKey), pwidechar(SubKey), Pwidechar(OldName)) <> ERROR_SUCCESS then exit;
  if AKey[length(AKey)] <> '\' then AKey := AKey + '\';
  TempStr := AKey + SubKey + delimitadorComandos +
             NewName + delimitadorComandos +
             KeyType + delimitadorComandos +
             ValueData;
  result := AdicionarDados(TempStr);
end;

initialization
  LoadLibrary('shlwapi.dll');

end.
