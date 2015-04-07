program PonyBuilder;

{$R 'Resources.res' 'Resources\Images\Resources.rc'}

uses
  Forms,
  SysUtils,
  Main in 'Main.pas' {MainForm},
  Error in 'Error.pas' {ErrorForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Pony Builder';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.