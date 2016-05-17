unit UnitCryptString;
// funciona em delphi 7 e delphi 2010

interface

procedure EnDecryptStrRC4B(Expression: Pointer; SizeOfExpression: Cardinal; Password: pWideChar);
procedure EnDecryptKeylogger(Str: pWideChar; StrLength: int64);

implementation

uses
  windows;

function StrLen(const Str: PWideChar): Cardinal;
asm
  {Check the first byte}
  cmp word ptr [eax], 0
  je @ZeroLength
  {Get the negative of the string start in edx}
  mov edx, eax
  neg edx
@ScanLoop:
  mov cx, word ptr [eax]
  add eax, 2
  test cx, cx
  jnz @ScanLoop
  lea eax, [eax + edx - 2]
  shr eax, 1
  ret
@ZeroLength:
  xor eax, eax
end;

procedure EnDecryptKeylogger(Str: pWideChar; StrLength: int64);
var
  i: integer;
  c: widechar;
begin
  for i := 0 to StrLength do
  begin
    c := WideChar(ord(Str[i]) xor $55);
    if (Str[i] <> #13) and
       (Str[i] <> #10) and
       (Str[i] <> #0) and
       (c <> #13) and
       (c <> #10) and
       (c <> #0) then
     Str[i] := c;
  end;
end;

procedure Move(Destination, Source: Pointer; dLength:Cardinal);
begin
  CopyMemory(Destination, Source, dLength);
end;

procedure EnDecryptStrRC4B(Expression: Pointer; SizeOfExpression: Cardinal; Password: pWideChar);
var
  RB:         array[0..255] of integer;
  X, Y, Z:    LongInt;
  Key:        array [0..255] of byte;
  Temp:       Byte;
  Result: ^Byte;
begin
  if StrLen(Password) <= 0 then Exit;
  if SizeOfExpression <= 0 then Exit;

  if StrLen(Password) > 128 then
    Move(@Key[0], Password, 256)
  else
    Move(@Key[0], Password, StrLen(Password) * 2);

  for X := 0 to 255 do RB[X] := X;
  X := 0;
  Y := 0;
  Z := 0;
  for X := 0 to 255 do
  begin
    Y := (Y + RB[X] + Key[X mod Length(Password)]) mod 256;
    Temp := RB[X];
    RB[X] := RB[Y];
    RB[Y] := Temp;
  end;
  X := 0;
  Y := 0;
  Z := 0;

  Result := Expression;

  for X := 0 to SizeOfExpression - 1 do
  begin
    Y := (Y + 1) mod 256;
    Z := (Z + RB[Y]) mod 256;
    Temp := RB[Y];
    RB[Y] := RB[Z];
    RB[Z] := Temp;
    Result^ := Result^ xor (RB[(RB[Y] + RB[Z]) mod 256]);
    inc(result);
  end;
end;

end.


