unit UnitCHAT;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Menus;

type
  TFormCHAT = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    ExcluirdoCHAT1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure ExcluirdoCHAT1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormCHAT: TFormCHAT;
  PodeIniciarCHAT: boolean = true;

implementation

{$R *.dfm}

uses
  UnitPrincipal,
  UnitStrings,
  UnitConexao,
  UnitComandos;

procedure TFormCHAT.FormShow(Sender: TObject);
begin
  memo1.Clear;
  edit1.Clear;
  PodeIniciarCHAT := true;
  ExcluirdoCHAT1.Caption := traduzidos[479];
  ListView1.Clear;
  Caption := Application.Title + ' ' + VersaoPrograma + ' CHAT';
  Button1.Caption := traduzidos[438];
end;

procedure TFormCHAT.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i: integer;
  ConAux: PConexao;
begin
  PodeIniciarCHAT := false;

  if listview1.Items = nil then exit;
  for i := Listview1.Items.Count - 1 downto 0 do
  begin
    if Listview1.Items.Item[i].Data = nil then
    begin
      Listview1.Items.Item[i].Delete;
      continue;
    end;
    try
      ConAux := PConexao(Listview1.Items.Item[i].Data);
      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;
      if ConAux.Item <> nil then
      begin
        EnviarString(ConAux.Athread, CHATCLOSE + '|', true);
        Listview1.Items.Item[i].Delete;
      end;
      except
      Listview1.Items.Item[i].Delete;
    end;
  end;
end;

procedure TFormCHAT.Button1Click(Sender: TObject);
var
  i: integer;
  ConAux: PConexao;
begin
  if listview1.selected = nil then exit;
  if edit1.Text = '' then
  begin
    edit1.SetFocus;
    exit;
  end;

  if Listview1.SelCount = 1 then
  begin
    ConAux := PConexao(Listview1.Selected.Data);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;

    if ConAux.Item <> nil then
    begin
      EnviarString(ConAux.Athread, CHATMSG + '|' + Edit1.Text + '|', true);
      Memo1.Lines.Add(Application.Title + ' ' + traduzidos[476] + ' ---> ' + Listview1.Selected.Caption + #13#10 + edit1.Text + #13#10);
    end else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
  end else
  begin
    for i := Listview1.Items.Count - 1 downto 0 do
    begin
      if Listview1.Items.Item[i].Selected = true then
      ConAux := PConexao(Listview1.Items.Item[i].Data) else continue;

      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      EnviarString(ConAux.Athread, CHATMSG + '|' + Edit1.Text + '|', true);
      Memo1.Lines.Add(Application.Title + ' ' + traduzidos[476] + ' ---> ' + Listview1.Items.Item[i].Caption + #13#10 + edit1.Text + #13#10);
    end;
  end;
  edit1.Clear;
end;

procedure TFormCHAT.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then button1.Click;
end;

procedure TFormCHAT.ExcluirdoCHAT1Click(Sender: TObject);
var
  i, Server: integer;
  ConAux: PConexao;
begin
  if listview1.selected = nil then exit;

  if Listview1.SelCount = 1 then
  begin
    ConAux := PConexao(Listview1.Selected.Data);
    ConAux.AThread.Connection.CheckForDisconnect(False, true);
    ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
    if ConAux.AThread.Connection.ClosedGracefully = true then exit;
    if ConAux.Athread.Connection.Connected = false then exit;

    if ConAux.Item <> nil then
    EnviarString(ConAux.Athread, CHATCLOSE + '|', true) else
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    ListView1.DeleteSelected;
  end else
  begin
    for i := Listview1.Items.Count - 1 downto 0 do
    begin
      if Listview1.Items.Item[i].Selected = true then
      ConAux := PConexao(Listview1.Items.Item[i].Data) else continue;

      ConAux.AThread.Connection.CheckForDisconnect(False, true);
      ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
      if ConAux.AThread.Connection.ClosedGracefully = true then continue;
      if ConAux.Athread.Connection.Connected = false then continue;

      if ConAux.Item <> nil then
      if ConAux.Item.Selected = true then
      EnviarString(ConAux.Athread, CHATCLOSE + '|', true);
      ListView1.Items.Item[i].Delete;
    end;
  end;
end;

procedure TFormCHAT.PopupMenu1Popup(Sender: TObject);
begin
  ExcluirdoChat1.Enabled := Listview1.Selected <> nil;
end;

end.
