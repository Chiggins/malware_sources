unit UnitStrings;

interface

uses
  Windows;

var
  Traduzidos: array [0..1000] of string;
  IniFilePassword: string;

function UnicodeToAnsi(const Str: UnicodeString; ACodePage: Cardinal;
  SetCodePage: Boolean = False): RawByteString;

implementation

function UnicodeToAnsi(const Str: UnicodeString; ACodePage: Cardinal;
  SetCodePage: Boolean = False): RawByteString;
var
  Len: integer;
begin
  Len := Length(Str);
  if Len > 0 then
  begin
    Len := WideCharToMultiByte(ACodePage, 0, Pointer(Str), Len, nil, 0, nil,
      nil);
    SetLength(Result, Len);
    if Len > 0 then
    begin
      WideCharToMultiByte(ACodePage, 0, Pointer(Str), Length(Str),
        Pointer(Result), Len, nil, nil);
      if SetCodePage and (ACodePage <> CP_ACP) then
        PWord(integer(Result) - 12)^ := ACodePage;
    end;
  end
  else
    Result := '';
end;

end.