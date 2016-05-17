program XtremeRAT;

uses
  VCLFixPack,
  uDEP,
  Windows,
  SysUtils,
  UnitFuncoesDiversas,
  MD5,
  UnitConstantes,
  Forms,
  UnitUser,
  UnitStrings,
  UnitMain in 'UnitMain.pas' {FormMain},
  UnitDesktopPreview in 'UnitDesktopPreview.pas' {FormDesktopPreview},
  UnitPasswords in 'UnitPasswords.pas' {FormPasswords},
  UnitAbout in 'UnitAbout.pas' {FormAbout},
  UnitKeySearch in 'UnitKeySearch.pas' {FormKeySearch},
  UnitFileSearch in 'UnitFileSearch.pas' {FormFileSearch},
  UnitConnectionsLog in 'UnitConnectionsLog.pas' {FormConnectionsLog},
  UnitDISCLAIMER in 'UnitDISCLAIMER.pas' {FormDISCLAIMER};

{$R *.res}
{$R 'resources.res' 'resources.rc'}

var
  Pass, TempStr: string;
  i: integer;
  p: pointer;
begin
  CreateMutex(nil, False, pchar(NomeDoPrograma + ' ' + VersaoDoPrograma));
  if GetLastError = ERROR_ALREADY_EXISTS then ExitProcess(0);

  if LerReg(HKEY_CURRENT_USER, 'Software\XtremeRAT-DISCLAIMER', 'Accept', '') <> 'OK' then
  begin
    FormDISCLAIMER := TFormDISCLAIMER.Create(nil);
    if FormDISCLAIMER.ShowModal <> IdOK then ExitProcess(0);
    if FormDISCLAIMER.CheckBox1.Checked then
    Write2Reg(HKEY_CURRENT_USER, 'Software\XtremeRAT-DISCLAIMER', 'Accept', 'OK');

    FormDISCLAIMER.sSkinManager1.UnInstallHook;
    FormDISCLAIMER.sSkinManager1.Active := False;
    FormDISCLAIMER.sSkinManager1.Free;

    FormDISCLAIMER.Release;
    FormDISCLAIMER := nil;
  end;

  FormUser := TFormUser.Create(nil);

  FormUser.PrimeiraVez := not FileExists('user.info');
  if FormUser.ShowModal <> idOk then ExitProcess(0);
  Pass := FormUser.Edit1.Text;

  IniFilePassword := Pass;

  if FileExists('user.info') = True then
  begin
    i := LerArquivo('user.info', p);
    TempStr := pWideChar(p);
    if MD5Print(MD5String(Pass)) <> TempStr then
    begin
      MessageBox(0,
                 'You typed an incorrect password.' + #13#10 + 'Please, try again.',
                 pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                 MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      exitProcess(0);
    end;
  end else
  begin
    TempStr := MD5Print(MD5String(Pass));
    CriarArquivo('user.info', pWideChar(TempStr), Length(TempStr) * 2);
  end;

  FormUser.sSkinManager1.UnInstallHook;
  FormUser.sSkinManager1.Active := False;
  FormUser.sSkinManager1.Free;

  FormUser.Release;
  FormUser := nil;

  Application.Initialize;
  Application.MainFormOnTaskBar := True;
  Application.Title := 'Xtreme RAT';
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormDesktopPreview, FormDesktopPreview);
  Application.CreateForm(TFormPasswords, FormPasswords);
  Application.CreateForm(TFormAbout, FormAbout);
  Application.CreateForm(TFormKeySearch, FormKeySearch);
  Application.CreateForm(TFormFileSearch, FormFileSearch);
  Application.CreateForm(TFormConnectionsLog, FormConnectionsLog);
  Application.Run;
end.
