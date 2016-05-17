unit UnitPortas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, Buttons;

type
  TFormPortas = class(TForm)
    ListView1: TListView;
    Edit1: TEdit;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Edit2: TEdit;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Edit3: TEdit;
    UpDown1: TUpDown;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure UpDown1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure UpDown1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
    Timer: integer;
    procedure AtualizarStringsTraduzidas;
  public
    { Public declarations }
  end;

var
  FormPortas: TFormPortas;

implementation

{$R *.dfm}

uses
  UnitPrincipal,
  UnitConexao,
  UnitStrings,
  UnitCryptString;

procedure TFormPortas.AtualizarStringsTraduzidas;
begin
  listview1.Column[0].Caption := traduzidos[31];
  BitBtn2.Caption := traduzidos[32];
  Label1.Caption := traduzidos[114];
  BitBtn3.Caption := traduzidos[115];
  Label2.Caption := traduzidos[520];

  UpDown1.Position := FormPrincipal.LimiteDeConexao;
  Edit3.Text := inttostr(UpDown1.Position);
  UpDown1.Increment := 1;
end;

procedure TFormPortas.FormCreate(Sender: TObject);
begin
  FormPrincipal.ImageListIcons.GetBitmap(253, BitBtn1.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(283, BitBtn2.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(261, BitBtn3.Glyph);
end;

procedure TFormPortas.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Bitbtn1.Click else
  If not(key in['0'..'9', #08]) then
  begin
    beep;
    key := #0;
  end;
end;

procedure TFormPortas.Edit1Enter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clSkyBlue;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clSkyBlue;
end;

procedure TFormPortas.Edit1Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clwindow;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clwindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clwindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clwindow;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clwindow;
end;

procedure TFormPortas.BitBtn1Click(Sender: TObject);
var
  i: integer;
  Item: TListItem;
begin
  if edit1.Text = '' then
  begin
    MessageDlg(pchar(traduzidos[30]), mtWarning, [mbOK], 0);
    exit;
  end;

  i := strtoint(edit1.Text);
  if (i < 1) or (i > 65535) then
  begin
    MessageDlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
    exit;
  end;

  if PossoUsarPorta(strtoint(edit1.Text)) = false then
  MessageDlg(pchar(traduzidos[27] + ' ' + edit1.Text + ' ' + traduzidos[28]), mtWarning, [mbOK], 0) else
  if AtivarPorta(strtoint(edit1.Text)) = false then
  MessageDlg(pchar(traduzidos[27] + ' ' + edit1.Text + ' ' + traduzidos[28]), mtWarning, [mbOK], 0) else
  begin
    FormPrincipal.TempPorts := '';
    for i := 1 to 65535 do
    if PortasAtivas[i] <> 0 then FormPrincipal.TempPorts := FormPrincipal.TempPorts + '(' + inttostr(i) + ')' + ' ';
    FormPrincipal.StatusBar1.Panels.Items[1].Text := traduzidos[19] + ': ' + FormPrincipal.TempPorts;
    Item := Listview1.Items.Add;
    Item.Caption := Edit1.Text;
    Item.ImageIndex := 261;
    edit1.Clear;
    edit1.setfocus;
  end;
end;

procedure TFormPortas.FormShow(Sender: TObject);
var
  item: TListItem;
  i: integer;
begin
  AtualizarStringsTraduzidas;
  Edit1.Clear;
  ListView1.Clear;
  for i := 1 to 65535 do
  if PortasAtivas[i] <> 0 then
  begin
    Item := Listview1.Items.add;
    Item.Caption := inttostr(i);
    Item.ImageIndex := 261;
  end;
  Caption := traduzidos[29];
  Edit1.SetFocus;
  Edit2.Text := SenhaConexao;
end;

procedure TFormPortas.BitBtn2Click(Sender: TObject);
var
  i: integer;
begin
  if Listview1.Items.Count = 0 then exit else
  if ListView1.Selected = nil then MessageDlg(pchar(traduzidos[33]), mtWarning, [mbOK], 0) else
  begin
    desativarporta(strtoint(listview1.Selected.Caption));
    listview1.Selected.Delete;
  end;
  FormPrincipal.TempPorts := '';
  for i := 1 to 65535 do
  if PortasAtivas[i] <> 0 then FormPrincipal.TempPorts := FormPrincipal.TempPorts + '(' + inttostr(i) + ')' + ' ';
  FormPrincipal.StatusBar1.Panels.Items[1].Text := traduzidos[19] + ': ' + FormPrincipal.TempPorts;
end;

procedure TFormPortas.BitBtn3Click(Sender: TObject);
begin
  SenhaConexao := Edit2.Text;
  FormPrincipal.LimiteDeConexao := UpDown1.Position;
  Close;
end;

procedure TFormPortas.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then BitBtn3.Click;
end;

procedure TFormPortas.UpDown1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  if gettickcount > timer + 1000 then UpDown1.Increment := 10;
  if gettickcount > timer + 2000 then UpDown1.Increment := 20;
  if gettickcount > timer + 3000 then UpDown1.Increment := 50;
  if gettickcount > timer + 4000 then UpDown1.Increment := 100;
  if gettickcount > timer + 5000 then UpDown1.Increment := 500;
end;

procedure TFormPortas.UpDown1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Timer := gettickcount;
  UpDown1.Increment := 1;
end;

procedure TFormPortas.UpDown1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Timer := gettickcount;
  UpDown1.Increment := 1;
end;

end.
