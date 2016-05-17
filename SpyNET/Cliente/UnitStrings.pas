Unit UnitStrings;

interface

uses
  windows;

var
  traduzidos: array [0..999] of string;
  LanguageFile: string;

procedure LerStrings(Arquivo: string);

implementation

uses
  IniFiles,
  Sysutils;

procedure LerStrings(Arquivo: string);
var
  IniFile: TIniFile;
  i: integer;
begin
  IniFile := TIniFile.Create(Arquivo);
  for i := 0 to 999 do
  traduzidos[i] := IniFile.ReadString('traduzidos', inttostr(i), 'Unknow' + inttostr(i));
  IniFile.Free;
end;

end.