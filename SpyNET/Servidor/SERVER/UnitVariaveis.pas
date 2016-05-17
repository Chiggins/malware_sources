unit UnitVariaveis;

interface

uses
  windows,
  EditSvr;

procedure lerconfigs;
procedure LerConfigsFromFile(StringSettings: string);

var
  variaveis: array [0..100] of string;

implementation

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

procedure LerConfigsFromFile(StringSettings: string);
var
  MySettings: SArray;
  i: integer;
  c: cardinal;
begin
  MySettings := Split(StringSettings, EditSvrID);
  for i := 0 to High(variaveis) do
  begin
    if (MySettings[i] <> '') and (MySettings[i] <> ' ') then
      variaveis[i] := Encrypt(MySettings[i]) else variaveis[i] := '';
  end;
end;

end.
