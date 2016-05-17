program CoolService;

uses
  SvcMgr,
  Service in 'Service.pas' {CoolTrayService: TService};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TCoolTrayService, CoolTrayService);
  Application.Run;
end.
