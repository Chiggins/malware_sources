program StartHidden;

uses
  Forms,
  Main in 'Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Start Hidden?';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
