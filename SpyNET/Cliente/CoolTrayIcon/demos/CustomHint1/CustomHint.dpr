program CustomHint;

uses
  Forms,
  Main in 'Main.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Custom Tooltip';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

