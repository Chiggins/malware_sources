unit UnitKeySearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, ComCtrls, AdvProgressBar, ExtCtrls, unitConexao;

type
  TFormKeySearch = class(TForm)
    AdvProgressBar1: TAdvProgressBar;
    bsSkinPanel1: TPanel;
    AdvListView1: TListView;
    procedure AdvListView1DblClick(Sender: TObject);
    procedure AdvListView1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FormKeySearch: TFormKeySearch;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitKeylogger,
  UnitAll;

//Here's the implementation of CreateParams
procedure TFormKeySearch.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormKeySearch.AdvListView1DblClick(Sender: TObject);
var
  NovaJanelaKeylogger: TFormKeylogger;
  ConAux: TConexaoNew;
  pConAux: pConexaoNew;
  i: integer;
begin
  if AdvListView1.Selected = nil then exit;

  application.ProcessMessages;
  ConAux := TConexaoNew(AdvListView1.Selected.Data);
  pConAux := FormMain.MainList.GetNodeData(ConAux.Node);

  FormMain.AbrirKeylogger(TConexaoNew(pConAux^));
  TFormAll(ConAux.FormAll).Width := TFormAll(ConAux.FormAll).Width + 1;
  TFormAll(ConAux.FormAll).Width := TFormAll(ConAux.FormAll).Width - 1;
end;

procedure TFormKeySearch.AdvListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
  begin
    AdvListView1DblClick(nil);
  end;
end;

procedure TFormKeySearch.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormKeySearch.FormShow(Sender: TObject);
begin
  Caption := Traduzidos[522];
  AdvListView1.Column[0].Caption := FormMain.MainList.Header.Columns.Items[0].Text;
  AdvListView1.Column[1].Caption := FormMain.MainList.Header.Columns.Items[1].Text;
end;

end.
