program MinimizeAnimation;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  TrayAnimation in 'TrayAnimation.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Animation effects';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
