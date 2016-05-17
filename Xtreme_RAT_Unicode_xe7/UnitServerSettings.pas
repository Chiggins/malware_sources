unit UnitServerSettings;

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, ComCtrls, ExtCtrls, UnitConexao;

type
  TFormServerSettings = class(TForm)
    StatusBar1: TStatusBar;
    bsSkinPanel1: TPanel;
    AdvListView1: TListView;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    LiberarForm: boolean;
    procedure AtualizarIdioma;
    procedure InserirSettings(Settings: string);
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormServerSettings: TFormServerSettings;

implementation

{$R *.dfm}

uses
  UnitConstantes,
  UnitStrings,
  UnitConfigs,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormServerSettings.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormServerSettings.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormServerSettings.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormServerSettings.AtualizarIdioma;
begin
  AdvListView1.Groups.Items[0].Header := Traduzidos[24];
  AdvListView1.Groups.Items[1].Header := Traduzidos[89];
  AdvListView1.Groups.Items[2].Header := Traduzidos[252];

  AdvListView1.Column[0].Caption := Traduzidos[20];
  AdvListView1.Column[1].Caption := Traduzidos[526];
end;

constructor TFormServerSettings.Create(aOwner: TComponent; ConAux: TConexaoNew);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

type
  SArray = array of string;

function Split(const Source, Delimiter: String): SArray;
var
  iCount,iPos,iLength: Integer;
  sTemp: String;
  aSplit:SArray;
begin
  sTemp := Source;
  iCount := 0;
  iLength := Length(Delimiter) - 1;
  repeat
    iPos := posex(Delimiter, sTemp);
    if iPos = 0 then break else
    begin
      Inc(iCount);
      SetLength(aSplit, iCount);
      aSplit[iCount - 1] := Copy(sTemp, 1, iPos - 1);
      Delete(sTemp, 1, iPos + iLength);
    end;
  until False;

  if Length(sTemp) > 0 then
  begin
    Inc(iCount);
    SetLength(aSplit, iCount);
    aSplit[iCount - 1] := sTemp;
  end;
  Result := aSplit;
end;

function BoolToStr(Bool: boolean): string;
begin
  Result := Traduzidos[95];
  if Bool = false then Result := Traduzidos[96];
end;

function StrToBool(Str: string): boolean;
begin
  if Str = 'TRUE' then result := true else result := false;
end;

procedure TFormServerSettings.InserirSettings(Settings: string);
var
  Ports: array [0..high(ConfiguracoesServidor.Ports)] of integer;
  DNS: array [0..high(ConfiguracoesServidor.Ports)] of string;
  Password: int64;
  ServerID: string;
  GroupID: string;

  CopyServer: boolean;
  ServerFileName: string;
  ServerFolder: string;
  SelectedDir: integer;
  Melt: boolean;
  InjectProcess: string;
  HideServer: boolean;
  Restart: boolean;
  HKLMRun: string;
  HKCURun: string;
  ActiveX: string;

  HKLMRunBool: boolean;
  HKCURunBool: boolean;
  ActiveXBool: boolean;

  Persistencia: boolean;
  Mutex: string;

  ActiveKeylogger: boolean;
  USBSpreader: boolean;
  KeyDelBackspace: boolean;
  SendFTPLogs: boolean;
  RecordWords: xArray;
  FTPAddress: xArray;
  FTPFolder: xArray;
  FTPUser: xArray;
  FTPPass: xArray;
  FTPFreq: integer;
  FTPDelLogs: boolean;

  I: Integer;
  InstalledServer: string;
  ProcessoAtual: string;
  VersaoDoPrograma: string;
  Item: TListItem;
  TempStr: string;
  ServerStarted: string;

  Config: TConfiguracoes;
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;

  CopyMemory(@Config, @Settings[1], SizeOf(TConfiguracoes));
  Delete(Settings, 1, SizeOf(TConfiguracoes));

  for i := 0 to NUMMAXCONNECTION - 1 do
  begin
    DNS[i] := Config.DNS[i];
    Ports[i] := Config.Ports[i];
  end;

  Password := Config.Password;
  ServerID := Config.ServerID;
  GroupID := Config.GroupID;
  CopyServer := Config.CopyServer;
  ServerFileName := Config.ServerFileName;
  ServerFolder := Config.ServerFolder;
  SelectedDir := Config.SelectedDir;
  Melt := Config.Melt;
  HideServer := Config.HideServer;
  InjectProcess := Config.InjectProcess;
  Restart := Config.Restart;
  HKLMRun := Config.HKLMRun;
  HKCURun := Config.HKCURun;
  ActiveX := Config.ActiveX;
  HKLMRunBool := Config.HKLMRunBool;
  HKCURunBool := Config.HKCURunBool;
  ActiveXBool := Config.ActiveXBool;
  VersaoDoPrograma := Config.Versao;
  Persistencia := Config.Persistencia;
  Mutex := Config.Mutex;

  ActiveKeylogger := Config.ActiveKeylogger;
  USBSpreader := Config.USBSpreader;
  KeyDelBackspace := Config.KeyDelBackspace;
  RecordWords := Config.RecordWords;
  SendFTPLogs := Config.SendFTPLogs;
  FTPAddress := Config.FTPAddress;
  FTPFolder := Config.FTPFolder;
  FTPUser := Config.FTPUser;
  FTPPass := Config.FTPPass;
  FTPFreq := Config.FTPFreq;
  FTPDelLogs := Config.FTPDelLogs;

  InstalledServer := Copy(Settings, 1, posex(DelimitadorComandos, Settings) - 1);
  Delete(Settings, 1, posex(DelimitadorComandos, Settings) - 1);
  Delete(Settings, 1, length(DelimitadorComandos));

  ProcessoAtual := Copy(Settings, 1, posex(DelimitadorComandos, Settings) - 1);
  Delete(Settings, 1, posex(DelimitadorComandos, Settings) - 1);
  Delete(Settings, 1, length(DelimitadorComandos));

  ServerStarted := Copy(Settings, 1, posex(DelimitadorComandos, Settings) - 1);
  Delete(Settings, 1, posex(DelimitadorComandos, Settings) - 1);
  Delete(Settings, 1, length(DelimitadorComandos));

  AdvListView1.Items.BeginUpdate;

  for i := 0 to high(ConfiguracoesServidor.Ports) do
  if (DNS[i] <> '') and (Ports[i] <> 0) then
  begin
    Item := AdvListView1.Items.Add;
    Item.GroupID := 0;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[527] + '[' + inttostr(i) + ']';
    Item.SubItems.Add(DNS[i] + ':' + IntToStr(Ports[i]));
  end;

  Item := AdvListView1.Items.Add;
  Item.GroupID := 0;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[45];
  Item.SubItems.Add({ServerID} Servidor.NomeDoServidor);

  Item := AdvListView1.Items.Add;
  Item.GroupID := 0;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[46];
  Item.SubItems.Add({GroupID} Servidor.GroupName);

  if CopyServer = True then
  begin
    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[48];
    Item.SubItems.Add(BoolToStr(CopyServer));

    if SelectedDir = 0 then TempStr := '%Windows%\' else
    if SelectedDir = 1 then TempStr := '%System%\' else
    if SelectedDir = 2 then TempStr := '%Root%\' else
    if SelectedDir = 3 then TempStr := Traduzidos[91] + '\' else
    if SelectedDir = 4 then TempStr := '%AppData%\' else
    if SelectedDir = 5 then TempStr := '%Temp%\';

    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[51];
    Item.SubItems.Add(TempStr + ServerFolder);

    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[49];
    Item.SubItems.Add(ServerFileName);
  end else
  begin
    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[48];
    Item.SubItems.Add(BoolToStr(CopyServer));
  end;

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[52];
  Item.SubItems.Add(BoolToStr(Melt));

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[56];
  Item.SubItems.Add(BoolToStr(HideServer));

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[66];
  Item.SubItems.Add(BoolToStr(ActiveKeylogger));
  if ActiveKeylogger then
  begin
    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[91];
    Item.SubItems.Add(RecordWords);

    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[67];
    Item.SubItems.Add(BoolToStr(KeyDelBackspace));

    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[68];
    Item.SubItems.Add(BoolToStr(SendFTPLogs));

    if SendFTPLogs then
    begin
      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := Traduzidos[69];
      Item.SubItems.Add(FTPAddress);

      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := Traduzidos[71];
      Item.SubItems.Add(FTPFolder);

      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := Traduzidos[70];
      Item.SubItems.Add(FTPUser);

      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := Traduzidos[73];
      Item.SubItems.Add(IntToStr((FTPFreq * 5) + 5) + ' ' + Traduzidos[74]);

      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := Traduzidos[92];
      Item.SubItems.Add(BoolToStr(FTPDelLogs));
    end;
  end;

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[54];
  Item.SubItems.Add(InjectProcess);

  if Restart = True then
  begin
    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[94];
    Item.SubItems.Add(BoolToStr(Restart));

    if HKLMRunBool = true then
    begin
      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := 'HKLM\Run';
      Item.SubItems.Add(HKLMRun);
    end;

    if HKCURunBool = true then
    begin
      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := 'HKCU\Run';
      Item.SubItems.Add(HKCURun);
    end;

    if ActiveXBool = true then
    begin
      Item := AdvListView1.Items.Add;
      Item.GroupID := 1;
      Item.ImageIndex := -1;
      Item.Caption := 'ActiveX';
      Item.SubItems.Add(ActiveX);
    end;
  end else
  begin
    Item := AdvListView1.Items.Add;
    Item.GroupID := 1;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[94];
    Item.SubItems.Add(BoolToStr(Restart));
  end;

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[13];
  Item.SubItems.Add(VersaoDoPrograma);

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[55];
  Item.SubItems.Add(BoolToStr(Persistencia));

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := Traduzidos[57];
  Item.SubItems.Add(BoolToStr(USBSpreader));

  Item := AdvListView1.Items.Add;
  Item.GroupID := 1;
  Item.ImageIndex := -1;
  Item.Caption := 'Mutex';
  Item.SubItems.Add(Mutex);

  Item := AdvListView1.Items.Add;
  Item.GroupID := 2;
  Item.ImageIndex := -1;
  Item.Caption := traduzidos[528];
  Item.SubItems.Add(InstalledServer);

  Item := AdvListView1.Items.Add;
  Item.GroupID := 2;
  Item.ImageIndex := -1;
  Item.Caption := traduzidos[529];
  Item.SubItems.Add(ProcessoAtual);

  Item := AdvListView1.Items.Add;
  Item.GroupID := 2;
  Item.ImageIndex := -1;
  Item.Caption := traduzidos[530];
  Item.SubItems.Add(ServerStarted);

  AdvListView1.Items.EndUpdate;
  StatusBar1.Panels.Items[0].Text := Traduzidos[373];
end;

procedure TFormServerSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if LiberarForm then Action := caFree;
end;

procedure TFormServerSettings.FormCreate(Sender: TObject);
var
  LG: TListGroup;
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;

  LiberarForm := False;
  AdvListView1.GroupView := True;

  LG := AdvListView1.Groups.Add;
  LG.Header := 'Conexão';
  LG.TitleImage := 101;
  LG.State := [lgsNormal];
  LG.HeaderAlign := taLeftJustify;
  LG.FooterAlign := taLeftJustify;

  LG := AdvListView1.Groups.Add;
  LG.Header := 'Instalação';
  LG.TitleImage := 69;
  LG.State := [lgsNormal];
  LG.HeaderAlign := taLeftJustify;
  LG.FooterAlign := taLeftJustify;

  LG := AdvListView1.Groups.Add;
  LG.Header := 'Estado atual';
  LG.TitleImage := 77;
  LG.State := [lgsNormal];
  LG.HeaderAlign := taLeftJustify;
  LG.FooterAlign := taLeftJustify;

  AdvListView1.GroupHeaderImages := FormMain.ImageListDiversos;
end;

procedure TFormServerSettings.FormShow(Sender: TObject);
var
  i: integer;
  Item: TListItem;
begin
  AtualizarIdioma;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  Servidor.EnviarString(GETSERVERSETTINGS + '|');
  StatusBar1.Panels.Items[0].Text := Traduzidos[205];
end;

procedure TFormServerSettings.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  i: integer;
  Tempstr: string;
  Item: TListItem;
begin
  if Copy(Recebido, 1, posex('|', Recebido) - 1) = GETSERVERSETTINGS then
  begin
    delete(Recebido, 1, posex('|', Recebido));
    InserirSettings(Recebido);
  end else

end;

end.

