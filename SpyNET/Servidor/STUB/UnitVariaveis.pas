unit UnitVariaveis;

interface

uses
  windows,
  EditSvr;

procedure lerconfigs;

var
  variaveis: array [0..100] of string;

implementation

var
  MySettings: SArray;

procedure lerconfigs;
var
  i: integer;
  Load: TLoader;
  tamanho: cardinal;
begin
  Load := TLoader.Create;
  Load.LoadSettings;

  for i := 0 to 100 do
  variaveis[i] := Load.Settings[i];

  load.Free;
end;

procedure LerConfigsFromFile(StringSettings, FileName: string);
var
  i: integer;
  c: cardinal;
begin
  MySettings := Split(StringSettings, EditSvrID);
  for i := 0 to High(MySettings) do
  begin
    if (MySettings[i] <> '') and (MySettings[i] <> ' ') then
      variaveis[i] := Encrypt(MySettings[i]) else variaveis[i] := '';
  end;
end;

end.
