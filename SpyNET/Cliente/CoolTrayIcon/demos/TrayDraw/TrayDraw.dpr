program TrayDraw;

uses
  Forms,
  CtDraw in 'CtDraw.pas' {DrawForm};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'CoolTrayIcon Drawing Demo';
  Application.CreateForm(TDrawForm, DrawForm);
  Application.Run;
end.
