unit UnitAlwaysOnTop;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, Menus, ComCtrls, StdCtrls, Buttons, sSkinProvider;

type
  TFormAlwaysOnTop = class(TForm)
    ListView1: TListView;
    PopupMenu1: TPopupMenu;
    Check1: TMenuItem;
    UnCheck1: TMenuItem;
    N1: TMenuItem;
    Apply1: TMenuItem;
    sSkinProvider1: TsSkinProvider;
    SpeedButton1: TSpeedButton;
    procedure PopupMenu1Popup(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Check1Click(Sender: TObject);
    procedure UnCheck1Click(Sender: TObject);
    procedure Apply1Click(Sender: TObject);
    procedure ListView1DblClick(Sender: TObject);
    procedure ListView1ColumnClick(Sender: TObject; Column: TListColumn);
    procedure ListView1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAlwaysOnTop: TFormAlwaysOnTop;

implementation

{$R *.dfm}

procedure TFormAlwaysOnTop.Apply1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormAlwaysOnTop.Check1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  ListView1.Selected.Checked := True;
end;

procedure TFormAlwaysOnTop.FormCreate(Sender: TObject);
begin
  FormMain.ImageListDiversos.GetBitmap(18, SpeedButton1.Glyph);
end;

procedure TFormAlwaysOnTop.FormShow(Sender: TObject);
var
  i: integer;
  Item: TListItem;
begin
  ListView1.Items.Clear;

  for i := 0 to Screen.FormCount - 1 do
  begin
    if Screen.Forms[i].Visible = False then Continue;
    if Screen.Forms[i].Handle = Handle then Continue;

    Item := ListView1.Items.Add;
    Item.Caption := IntToStr(Screen.Forms[i].Handle);
    Item.SubItems.Add(Screen.Forms[i].Caption);
    if GetWindowLong(Screen.Forms[i].Handle, GWL_EXSTYLE) and WS_EX_TOPMOST <> 0 then Item.Checked := True else
      Item.Checked := False;
  end;
end;

var
  LastSortedColumn: TListColumn;
  Ascending: boolean;

function SortByColumn(Item1, Item2: TListItem; Data: integer): integer; stdcall;
var
  n1, n2: int64;
  s1, s2: string;
begin
  if LastSortedColumn.Index = 0 then
  begin
    if LastSortedColumn.Index = 0 then
    begin
       n1 := StrToIntDef(Item1.caption, 0);
       n2 := StrToIntDef(Item2.caption, 0);
    end;
    if (n1 = n2) then Result := 0 else if (n1 > n2) then Result := 1 else Result := -1;
  end else
  begin
    Result := 0;
    if Data = 0 then Result := AnsiCompareText(Item1.Caption, Item2.Caption)
    else Result := AnsiCompareText(Item1.SubItems[Data - 1], Item2.SubItems[Data - 1]);
  end;

  if not Ascending then Result := -Result;
end;

procedure TFormAlwaysOnTop.ListView1ColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  Ascending := not Ascending;
  if Column <> LastSortedColumn then Ascending := not Ascending;
  for i := 0 to Listview1.Columns.Count -1 do Listview1.Column[i].ImageIndex := -1;
  LastSortedColumn := Column;
  Listview1.CustomSort(@SortByColumn, LastSortedColumn.Index);
end;

procedure TFormAlwaysOnTop.ListView1DblClick(Sender: TObject);
begin
  if ListView1.Selected = nil then Exit;
  ListView1.Selected.Checked := not ListView1.Selected.Checked;
end;

procedure TFormAlwaysOnTop.ListView1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #27 then Close;
end;

procedure TFormAlwaysOnTop.PopupMenu1Popup(Sender: TObject);
begin
  if ListView1.Selected = nil then
  begin
    Check1.Enabled := False;
    UnCheck1.Enabled := False;
  end else
  if ListView1.Selected.Checked then
  begin
    Check1.Enabled := False;
    UnCheck1.Enabled := True;
  end else
  if ListView1.Selected.Checked = False then
  begin
    Check1.Enabled := True;
    UnCheck1.Enabled := False;
  end;
end;

procedure TFormAlwaysOnTop.SpeedButton1Click(Sender: TObject);
begin
  Apply1.Click;
end;

procedure TFormAlwaysOnTop.UnCheck1Click(Sender: TObject);
begin
  if ListView1.Selected <> nil then
  ListView1.Selected.Checked := False;
end;

end.
