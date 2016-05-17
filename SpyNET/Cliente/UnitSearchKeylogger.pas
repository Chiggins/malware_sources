unit UnitSearchKeylogger;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitPrincipal, ComCtrls, Menus;

type
  TFormSearchKeylogger = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Keylogger: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure KeyloggerClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSearchKeylogger: TFormSearchKeylogger;
  PodeReceber: boolean;

implementation

{$R *.dfm}

uses
  UnitKeylogger,
  UnitStrings;

procedure TFormSearchKeylogger.FormShow(Sender: TObject);
begin
  PodeReceber := true;
end;

procedure TFormSearchKeylogger.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PodeReceber := false;
end;

procedure TFormSearchKeylogger.KeyloggerClick(Sender: TObject);
var
  Server: integer;
  NovaJanelaKeylogger: TFormKeylogger;
  ConAux: PConexao;
begin
  ConAux := PConexao(Listview1.Selected.Data);
  ConAux.AThread.Connection.CheckForDisconnect(False, true);
  ConAux.AThread.Connection.CheckForGracefulDisconnect(False);
  if ConAux.AThread.Connection.ClosedGracefully = true then
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Athread.Connection.Connected = false then
  begin
    messagedlg(pchar(traduzidos[119]), mtWarning, [mbOK], 0);
    exit;
  end;
  if ConAux.Forms[4] <> nil then
  begin
    TFormKeylogger(ConAux.Forms[4]).Show;
    TFormKeylogger(ConAux.Forms[4]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[39];
  end
  else
  begin
    NovaJanelaKeylogger := TFormKeylogger.Create(self, ConAux);
    NovaJanelaKeylogger.FormStyle := fsStayOnTop;
    ConAux.Forms[4] := NovaJanelaKeylogger;
    NovaJanelaKeylogger.NomePC := ConAux.Item.SubItems.Strings[0];
    NovaJanelaKeylogger.Show;
    NovaJanelaKeylogger.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[39];
  end;
end;


procedure TFormSearchKeylogger.PopupMenu1Popup(Sender: TObject);
begin
  Keylogger.Enabled := Listview1.Selected <> nil;
end;

end.
