unit base64;

interface

// encode 8-bit string
function Base64Encode(const S: AnsiString): AnsiString;
function Base64Decode(const S: AnsiString): AnsiString;

// encode 16-bit string
function Base64EncodeW(const S: WideString): AnsiString;
function Base64DecodeW(const S: AnsiString): WideString;


//low level worker functions.
//WARNING: incorect usage will effect in Acces Violation!

{------------------------------------------------------------------------------------------------------------------------
  contract:
    Src: Pointer - Pointer to begn of buffer of
      Encoder: binary data to encode
      Decoder: Base64 encoded string of 8-bit characters to decode
    SrcLength: integer - length of source data buffer, in bytes.
    Dst: Pointer - pointer to putput buffer.
      if nil, then no conversion is made, and function will return length of buffer to allocate, to pass it as Dst.
    Result - return length of output, in bytes
    NOTE: if nil is passed as Dst to DecodeBuffer, then retured number of bytes is maximum required buffer size.
          it is possible number of really returned bytes will be lower, an this exact number will be returned in second
          call, with Dst set to output buffer.
------------------------------------------------------------------------------------------------------------------------}
function EncodeBuffer(Src: Pointer; SrcLength: integer; Dst: Pointer): integer; forward;
function DecodeBuffer(Src: Pointer; SrcLength: integer; Dst: Pointer): integer; forward;


implementation

{$IFOPT C+} //if compiled with assertions enabled
uses Windows, sysutils;
{$ENDIF}

type
  PInteger = ^Integer;
  PByte = ^Byte;

{ Base64 encode and decode a string }
const
  Base64AlphabetLookup: array [0..63] of AnsiChar = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  Base64PadingCharacter: AnsiChar = '=';

  Base64AlphabetRevLookup: array [0..$ff] of Byte = (
    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,
    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$3E,$0,$0,$0,$3F,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$0,$0,$0,$0,$0,$0,
    $0,$0,$1,$2,$3,$4,$5,$6,$7,$8,$9,$A,$B,$C,$D,$E,$F,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$0,$0,$0,$0,$0,
    $0,$1A,$1B,$1C,$1D,$1E,$1F,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$0,$0,$0,$0,$0,
    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,
    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,
    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,
    $0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0,$0
  );





function EncodeBuffer(Src: Pointer; SrcLength: integer; Dst: Pointer): integer;
var
  i, tripletsCount: integer;
  InputPoint: PAnsiChar;
  OutputPoint: PInteger;
begin
  if SrcLength = 0 then
  begin
    Result := 0;
    Exit;
  end;

  tripletsCount := SrcLength div 3;

  Result := tripletsCount * 4;
  if SrcLength mod 3 <> 0 then //partial triplet at end, output will be padded
    inc(Result, 4);

  if Dst = nil then Exit;

  InputPoint := Src;
  OutputPoint := PInteger(Dst);

  //process full triplets
  for i:= 1 to tripletsCount do
  begin
    OutputPoint^ :=
      (Byte(Base64AlphabetLookup[(PByte(InputPoint)^ and $FC) shr 2])) +
      (Byte(Base64AlphabetLookup[((PByte(InputPoint)^ and $03) shl 4) + ((PByte(InputPoint + 1)^ and $F0) shr 4)]) shl 8) +
      (Byte(Base64AlphabetLookup[((PByte(InputPoint + 1)^ and $0F) shl 2) + ((PByte(InputPoint + 2)^ and $C0) shr 6)]) shl 16) +
      (Byte(Base64AlphabetLookup[PByte(InputPoint + 2)^ and $3F]) shl 24);
    Inc(OutputPoint);
    Inc(InputPoint, 3);
  end;

  //deal with last, partial triplet
  if SrcLength mod 3 = 1 then //one character reminder
    OutputPoint^ :=
      (Byte(Base64AlphabetLookup[(PByte(InputPoint)^ and $FC) shr 2])) +
      (Byte(Base64AlphabetLookup[(PByte(InputPoint)^ and $03) shl 4]) shl 8) +
      (Byte(Base64PadingCharacter) shl 16) or
      (Byte(Base64PadingCharacter) shl 24);

  if SrcLength mod 3 = 2 then //two characters reminder
    OutputPoint^ :=
      (Byte(Base64AlphabetLookup[(PByte(InputPoint)^ and $FC) shr 2])) +
      (Byte(Base64AlphabetLookup[((PByte(InputPoint)^ and $03) shl 4) + ((PByte(InputPoint + 1)^ and $F0) shr 4)]) shl 8) +
      (Byte(Base64AlphabetLookup[(PByte(InputPoint + 1)^ and $0F) shl 2]) shl 16) +
      (Byte(Base64PadingCharacter) shl 24);



end;

function DecodeBuffer(Src: Pointer; SrcLength: integer; Dst: Pointer): integer;
var
  partialTripletParts: integer;
  InputPoint, InputEnd: PAnsiChar;
  OutputPoint: PAnsiChar;
  Input6bits1, Input6bits2, Input6bits3, Input6bits4: Byte;


  function GetNextInputTriplet(): Boolean;
  begin
    while (InputPoint < InputEnd) and (InputPoint^ in [' ', #13, #10]) do Inc(InputPoint); //skip white spaces
    if (InputPoint >= InputEnd) or (InputPoint^ = Base64PadingCharacter) then
    begin
      partialTripletParts := 0;
      Result := False;
      Exit;
    end;
    Input6bits1 := Base64AlphabetRevLookup[PByte(InputPoint)^];
    Inc(InputPoint);

    while (InputPoint < InputEnd) and (InputPoint^ in [' ', #13, #10]) do Inc(InputPoint); //skip white spaces
    if (InputPoint >= InputEnd) or (InputPoint^ = Base64PadingCharacter) then
    begin
      partialTripletParts := 1;
      Result := False;
      Exit;
    end;
    Input6bits2 := Base64AlphabetRevLookup[PByte(InputPoint)^];
    Inc(InputPoint);

    while (InputPoint < InputEnd) and (InputPoint^ in [' ', #13, #10]) do Inc(InputPoint); //skip white spaces
    if (InputPoint >= InputEnd) or (InputPoint^ = Base64PadingCharacter) then
    begin
      partialTripletParts := 2;
      Result := False;
      Exit;
    end;
    Input6bits3 := Base64AlphabetRevLookup[PByte(InputPoint)^];
    Inc(InputPoint);

    while (InputPoint < InputEnd) and (InputPoint^ in [' ', #13, #10]) do Inc(InputPoint); //skip white spaces
    if (InputPoint >= InputEnd) or (InputPoint^ = Base64PadingCharacter) then
    begin
      partialTripletParts := 3;
      Result := False;
      Exit;
    end;
    Input6bits4 := Base64AlphabetRevLookup[PByte(InputPoint)^];
    Inc(InputPoint);
    Result := True;
  end;

begin
  if SrcLength = 0 then
  begin
    Result := 0;
    Exit;
  end;

  Result := ((SrcLength + 3) div 4) * 3;

  if Dst = nil then Exit;

  InputPoint := PAnsiChar(Src);
  InputEnd := InputPoint + SrcLength;

  OutputPoint := PAnsiChar(Dst);

  while GetNextInputTriplet() do
  begin
    PInteger(OutputPoint)^ :=
      (Input6bits1 shl 2) +
      ((Input6bits2 and $30) shr 4) +
      ((Input6bits2 and $0F) shl 12) +
      ((Input6bits3 and $3C) shl 6) +
      ((Input6bits3 and $03) shl 22) +
      (Input6bits4 shl 16);
    Inc(OutputPoint, 3);
  end;

  Result := OutputPoint - PAnsiChar(Dst);

  if partialTripletParts = 0 then Exit; //no partially filled triplets, return now.
  //last. not full triplet
  // first output byte
  if partialTripletParts > 1 then
  begin
    PByte(OutputPoint)^ := (Input6bits1 shl 2) + ((Input6bits2 and $30) shr 4);
    Inc(OutputPoint);
    Inc(Result);
  end
  else
  begin
    PByte(OutputPoint)^ := 0;
    Inc(OutputPoint);
  end;

  //second outputbyte
  if partialTripletParts > 2 then
  begin
    PByte(OutputPoint)^ := ((Input6bits2 and $0F) shl 4) + ((Input6bits3 and $3C) shr 2);
    Inc(OutputPoint);
    Inc(Result);
  end
  else
  begin
    PByte(OutputPoint)^ := 0;
    Inc(OutputPoint);
  end;

  //third outputbyte
  if partialTripletParts > 3 then
  begin
    PByte(OutputPoint)^ := ((Input6bits3 and $03) shl 6) + Input6bits4;
    Inc(Result);
  end
  else
    PByte(OutputPoint)^ := 0;
end;


function Base64Encode(const S: AnsiString): AnsiString;
var
  len: integer;
begin
  len := EncodeBuffer(PAnsiChar(s), Length(s), nil);
  if len <= 0 then
    Result := ''
  else
  begin
    SetLength(Result, len);
    EncodeBuffer(PAnsiChar(s), Length(s), PAnsiChar(Result));
  end;
end;

function Base64Decode(const S: AnsiString): AnsiString;
var
  len: integer;
begin
  len := DecodeBuffer(PAnsiChar(s), Length(s), nil);
  if len <= 0 then
    Result := ''
  else
  begin
    SetLength(Result, len);
    len := DecodeBuffer(PAnsiChar(s), Length(s), PAnsiChar(Result));
    if len <> Length(Result) then SetLength(Result, len);
  end;
end;


function Base64EncodeW(const S: WideString): AnsiString;
var
  len: integer;
begin
  len := EncodeBuffer(Pointer(PWideChar(s)), Length(s) * 2, nil);
  if len <= 0 then
    Result := ''
  else
  begin
    SetLength(Result, len);
    EncodeBuffer(Pointer(PWideChar(s)), Length(s) * 2, PChar(Result));
  end;
end;

function Base64DecodeW(const S: AnsiString): WideString;
var
  len: integer;
begin
  len := DecodeBuffer(PChar(s), Length(s), nil);
  if len <= 0 then
    Result := ''
  else
  begin
    SetLength(Result, len div 2);
    len := DecodeBuffer(PChar(s), Length(s), PChar(Result));
    if (len div 2) <> Length(Result) then SetLength(Result, len div 2);
  end;
end;


{$IFOPT C+} //if compiled with assertions enabled

procedure TestsUnit();
begin
  try
  //tests
    Assert(Base64Encode('') = '');
    Assert(Base64Encode('f') = 'Zg==');
    Assert(Base64Encode('fo') = 'Zm8=');
    Assert(Base64Encode('foo') = 'Zm9v');
    Assert(Base64Encode('foob') = 'Zm9vYg==');
    Assert(Base64Encode('fooba') = 'Zm9vYmE=');
    Assert(Base64Encode('foobar') = 'Zm9vYmFy');

    Assert(Base64Decode('') = '');
    Assert(Base64Decode('Zg==') = 'f');
    Assert(Base64Decode('Zm8=') = 'fo');
    Assert(Base64Decode('Zm9v') = 'foo');
    Assert(Base64Decode('Zm9vYg==') = 'foob');
    Assert(Base64Decode('Zm9vYmE=') = 'fooba');
    Assert(Base64Decode('Zm9vYmFy') = 'foobar');

    Assert(Base64Decode('Zm'#13#10'9v YmF y') = 'foobar');
    Assert(Base64Decode('Zm'#13#10'9v YmE') = 'fooba');

    Assert(Base64EncodeW('') = '');
    Assert(Base64EncodeW('f') = 'ZgA=');
    Assert(Base64EncodeW('fo') = 'ZgBvAA==');
    Assert(Base64EncodeW('foo') = 'ZgBvAG8A');
    Assert(Base64EncodeW('foob') = 'ZgBvAG8AYgA=');
    Assert(Base64EncodeW('fooba') = 'ZgBvAG8AYgBhAA==');
    Assert(Base64EncodeW('foobar') = 'ZgBvAG8AYgBhAHIA');

    Assert(Base64DecodeW('') = '');
    Assert(Base64DecodeW('ZgA=') = 'f');
    Assert(Base64DecodeW('ZgBvAA==') = 'fo');
    Assert(Base64DecodeW('ZgBvAG8A') = 'foo');
    Assert(Base64DecodeW('ZgBvAG8AYgA=') = 'foob');
    Assert(Base64DecodeW('ZgBvAG8AYgBhAA=') = 'fooba');
    Assert(Base64DecodeW('ZgBvAG8AYgBhAHIA') = 'foobar');

    Assert(Base64DecodeW('ZgB'#13#10'vAG'#13#10'8AYg Bh AHI A') = 'foobar');
    Assert(Base64DecodeW('Z'#13#10'gB vAG'#13#10'8AY gBhAA==') = 'fooba');
  
  except
    on e: Exception do
    begin
      MessageBox(0, PChar(e.message), 'base64.pas :: Test fails!', MB_ICONERROR);
      Halt(1);
    end;
  end ;
end;
  
initialization  

  TestsUnit();

{$ENDIF}

end.