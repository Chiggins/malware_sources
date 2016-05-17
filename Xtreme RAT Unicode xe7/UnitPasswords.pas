unit UnitPasswords;

interface

uses
  UnitFuncoesDiversas, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvProgressBar, UnitMain, Menus, ExtCtrls;

type
  TFormPasswords = class(TForm)
    AdvProgressBar1: TAdvProgressBar;
    bsSkinPanel1: TPanel;
    AdvListView1: TListView;
    PopupMenu1: TPopupMenu;
    Copyusername1: TMenuItem;
    Copypassword1: TMenuItem;
    Openwebsite1: TMenuItem;
    N2: TMenuItem;
    Savepasswordstxt1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure AdvListView1ColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure PopupMenu1Popup(Sender: TObject);
    procedure Copyusername1Click(Sender: TObject);
    procedure Copypassword1Click(Sender: TObject);
    procedure Openwebsite1Click(Sender: TObject);
    procedure Savepasswordstxt1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure ClickTheColumn;
    procedure CreateParams(var Params : TCreateParams); override;
  public
    { Public declarations }
  end;

var
  FormPasswords: TFormPasswords;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  StrUtils,
  ShellApi;

//Here's the implementation of CreateParams
procedure TFormPasswords.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params); //Don't ever forget to do this!!!
  Params.WndParent := GetDesktopWindow;
end;

procedure SetClipboardText(Const S: widestring);
var
  Data: THandle;
  DataPtr: Pointer;
  Size: integer;
begin
  Size := length(S);
  OpenClipboard(0);
  try
    Data := GlobalAlloc(GMEM_MOVEABLE + GMEM_DDESHARE, (Size * 2) + 2);
    try
      DataPtr := GlobalLock(Data);
      try
        Move(S[1], DataPtr^, Size * 2);
        SetClipboardData(CF_UNICODETEXT{CF_TEXT}, Data);
      finally
        GlobalUnlock(Data);
      end;
    except
      GlobalFree(Data);
      raise;
    end;
  finally
    CloseClipboard;
  end;
end;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  s1,s2: string;
  ex1,ex2: extended;
  num: integer;
begin
  Result := 0;
  if Data = 0 then Result := AnsiCompareText(Item1.Caption, Item2.Caption)
  else Result := AnsiCompareText(Item1.SubItems[Data-1],Item2.SubItems[Data-1]);

  if not Ascending then Result := -Result;
end;

procedure TFormPasswords.ClickTheColumn;
begin
  if LastSortedColumn = nil then exit;
  AdvListview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormPasswords.AdvListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to AdvListview1.Columns.Count -1 do AdvListview1.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  AdvListview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormPasswords.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  if AdvListView1.Items.Count > 0 then AdvListView1.Items.Clear;
end;

procedure TFormPasswords.FormShow(Sender: TObject);
begin
  Caption := traduzidos[512];
  AdvListView1.Column[0].Caption := traduzidos[513];
  AdvListView1.Column[1].Caption := traduzidos[514];
  AdvListView1.Column[2].Caption := traduzidos[519];
  AdvListView1.Column[3].Caption := traduzidos[512];
  Copypassword1.Caption := traduzidos[515];
  Copyusername1.Caption := traduzidos[516];
  Openwebsite1.Caption := traduzidos[517];
  Savepasswordstxt1.Caption := traduzidos[518];
end;

procedure TFormPasswords.Openwebsite1Click(Sender: TObject);
begin
  shellExecute(0, 'open', pchar(GetDefaultBrowser), pchar(Advlistview1.Selected.Caption), '', SW_SHOWMAXIMIZED);
end;

procedure TFormPasswords.Copypassword1Click(Sender: TObject);
begin
  SetClipboardText(Advlistview1.Selected.SubItems.Strings[2]);
end;

procedure TFormPasswords.Copyusername1Click(Sender: TObject);
begin
  SetClipboardText(Advlistview1.Selected.SubItems.Strings[1]);
end;

procedure TFormPasswords.PopupMenu1Popup(Sender: TObject);
var
  i: integer;
begin
  if Advlistview1.Selected = nil then
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items.Items[i].Visible := false;
    if Advlistview1.Items <> nil then Savepasswordstxt1.Visible := true;
    exit;
  end else
  begin
    for i := 0 to PopupMenu1.Items.Count - 1 do
    PopupMenu1.Items.Items[i].Visible := true;
  end;
  if (Advlistview1.Selected.ImageIndex = 71) or
     (Advlistview1.Selected.ImageIndex = 72) or
     (Advlistview1.Selected.ImageIndex = 107) or
     (Advlistview1.Selected.ImageIndex = 117) or
     (Advlistview1.Selected.ImageIndex = 120) then
      Openwebsite1.Visible := true else Openwebsite1.Visible := false;
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

procedure TFormPasswords.Savepasswordstxt1Click(Sender: TObject);
var
  Filename: string;
  I: Integer;
  buffer: string;
  Distancia: integer;
begin
  if savedialog1 <> nil then savedialog1.Free;
  savedialog1 := TSaveDialog.Create(nil);

  savedialog1.Filter := 'Text Files (*.txt)' + '|*.txt';
  savedialog1.InitialDir := extractfilepath(paramstr(0));
  savedialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.FileName := ShowTime('-', ' ', '-') + '.txt';

  if savedialog1.Execute = false then exit;

  Filename := savedialog1.FileName;
  if Filename = '' then exit;

  Distancia := length(AdvListView1.Column[0].Caption);
  if length(AdvListView1.Column[1].Caption) > Distancia then Distancia := length(AdvListView1.Column[1].Caption);
  if length(AdvListView1.Column[2].Caption) > Distancia then Distancia := length(AdvListView1.Column[2].Caption);
  if length(AdvListView1.Column[3].Caption) > Distancia then Distancia := length(AdvListView1.Column[3].Caption);

  buffer := '';
  for I := 0 to AdvListView1.Items.Count - 1 do
  begin
    buffer := buffer + justl(AdvListView1.Column[1].Caption, Distancia) + justl(': ' + AdvListView1.Items[I].SubItems[0], 0) + #13#10;
    buffer := buffer + justl(AdvListView1.Column[0].Caption, Distancia) + justl(': ' + AdvListView1.Items[I].Caption, 0) + #13#10;
    buffer := buffer + justl(AdvListView1.Column[2].Caption, Distancia) + justl(': ' + AdvListView1.Items[I].SubItems[1], 0) + #13#10;
    buffer := buffer + justl(AdvListView1.Column[3].Caption, Distancia) + justl(': ' + AdvListView1.Items[I].SubItems[2], 0) + #13#10;
    buffer := buffer + #13#10;
  end;
  criararquivo(pwidechar(filename), pwidechar(buffer), length(buffer) * 2);
end;

end.
