unit UnitConnectionSettings;
{$I Compilar.inc}

interface

uses
  StrUtils,Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, ImgList, Buttons, Menus, ExtCtrls, sPanel, unitMain;

type
  TFormConnectionSettings = class(TForm)
    MainPanel: TsPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    ListView1: TListView;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    Edit3: TEdit;
    ImageList32: TImageList;
    ImageList16: TImageList;
    PopupMenu1: TPopupMenu;
    AdicionarDNS1: TMenuItem;
    ExcluirDNS1: TMenuItem;
    N1: TMenuItem;
    EditarDNS1: TMenuItem;
    CheckBox2: TCheckBox;
    Edit4: TEdit;
    Label4: TLabel;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure FormDestroy(Sender: TObject);
    procedure AdicionarDNS1Click(Sender: TObject);
    procedure ExcluirDNS1Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EditarDNS1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox2Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
  private
    { Private declarations }
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
    procedure AtualizarIdiomas;
  end;

var
  FormConnectionSettings: TFormConnectionSettings;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures,
  UnitConfigs;
  
//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormConnectionSettings.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;  

function GetAveCharSize(Canvas: TCanvas): TPoint;
var
  I: Integer;
  Buffer: array[0..51] of Char;
begin
  for I := 0 to 25 do Buffer[I] := Chr(I + Ord('A'));
  for I := 0 to 25 do Buffer[I + 26] := Chr(I + Ord('a'));
  GetTextExtentPoint(Canvas.Handle, Buffer, 52, TSize(Result));
  Result.X := Result.X div 52;
end;

function InputQuery(const ACaption, APrompt: string;
  var Value: string; EditMaxLength: integer = 0): Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TEdit;
  DialogUnits: TPoint;
  ButtonTop, ButtonWidth, ButtonHeight: Integer;
  WasStayOnTop: boolean;
begin
  Result := False;
  Form := TForm.Create(Application);
  with Form do
    try
      FormStyle := fsStayOnTop;
      Canvas.Font := Font;
      DialogUnits := GetAveCharSize(Canvas);
      BorderStyle := bsDialog;
      Caption := ACaption;
      ClientWidth := MulDiv(180, DialogUnits.X, 4);
      PopupMode := pmAuto;
      Position := poScreenCenter;
      Prompt := TLabel.Create(Form);
      with Prompt do
      begin
        Parent := Form;
        Caption := APrompt;
        Left := MulDiv(8, DialogUnits.X, 4);
        Top := MulDiv(8, DialogUnits.Y, 8);
        Constraints.MaxWidth := MulDiv(164, DialogUnits.X, 4);
        WordWrap := True;
      end;
      Edit := TEdit.Create(Form);
      with Edit do
      begin
        Parent := Form;
        Left := Prompt.Left;
        Top := Prompt.Top + Prompt.Height + 5;
        Width := MulDiv(164, DialogUnits.X, 4);
        if (EditMaxLength = 0) or (EditMaxLength > 255) then MaxLength := 255 else MaxLength := EditMaxLength;
        Text := Value;
        SelectAll;
      end;
      ButtonTop := Edit.Top + Edit.Height + 15;
      ButtonWidth := MulDiv(50, DialogUnits.X, 4);
      ButtonHeight := MulDiv(14, DialogUnits.Y, 8);
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'OK';
        ModalResult := mrOk;
        Default := True;
        SetBounds(MulDiv(38, DialogUnits.X, 4), ButtonTop, ButtonWidth,
          ButtonHeight);
      end;
      with TButton.Create(Form) do
      begin
        Parent := Form;
        Caption := 'Cancel';
        ModalResult := mrCancel;
        Cancel := True;
        SetBounds(MulDiv(92, DialogUnits.X, 4), Edit.Top + Edit.Height + 15,
          ButtonWidth, ButtonHeight);
        Form.ClientHeight := Top + Height + 13;
      end;
      WasStayOnTop := Assigned(Application.MainForm) and (Application.MainForm.FormStyle = fsStayOnTop);
      if WasStayOnTop then Application.MainForm.FormStyle := fsNormal;
      try
        if ShowModal = mrOk then
        begin
          Value := Edit.Text;
          Result := True;
        end;
        finally if WasStayOnTop then Application.MainForm.FormStyle := fsStayOnTop;
      end;
    finally
      Form.Free;
    end;
end;

procedure TFormConnectionSettings.AdicionarDNS1Click(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TFormConnectionSettings.AtualizarIdiomas;
begin
  ListView1.Column[0].Caption := Traduzidos[39];
  ListView1.Column[1].Caption := Traduzidos[40];
  AdicionarDNS1.Caption := Traduzidos[41];
  ExcluirDNS1.Caption := Traduzidos[42];
  EditarDNS1.Caption := Traduzidos[43];
  SpeedButton1.Hint := AdicionarDNS1.Caption;
  SpeedButton2.Hint := ExcluirDNS1.Caption;
  Label1.Caption := Traduzidos[44] + ':';
  Label2.Caption := Traduzidos[45] + ':';
  Label3.Caption := Traduzidos[46] + ':';
  CheckBox1.Caption := Traduzidos[47];

  CheckBox2.Caption := Traduzidos[653];
  Label4.Caption := Traduzidos[654];
end;

procedure TFormConnectionSettings.CheckBox1Click(Sender: TObject);
begin
  if TCheckBox(sender).Checked then
  Edit1.PasswordChar := #0 else Edit1.PasswordChar := '*';
end;

procedure TFormConnectionSettings.CheckBox2Click(Sender: TObject);
begin
  Edit4.Enabled := CheckBox2.Checked;
  Label4.Enabled := Edit4.Enabled;
end;

procedure TFormConnectionSettings.Edit1Change(Sender: TObject);
begin
  if Edit1.Text = '' then Edit1.Text := '0';
end;

procedure TFormConnectionSettings.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if CheckValidName(Key) = False then Key := #0;
end;

procedure TFormConnectionSettings.EditarDNS1Click(Sender: TObject);
var
  TempStr: string;
  TempDNS: string;
  i: integer;
  EditSize: integer;
begin
  if ListView1.Selected = nil then exit;
  EditSize := (SizeOf(ConfiguracoesServidor.DNS[0]) div 2) - 1;

  TempStr := ListView1.Selected.Caption + ':' + ListView1.Selected.SubItems.Strings[0];

  if Inputquery(traduzidos[39], traduzidos[102] + ':', TempStr, EditSize) = false then exit;
  if posex(':', TempStr) <= 0 then
  begin
    MessageBox(Handle,
               pwidechar(traduzidos[103]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    exit;
  end;
  TempDNS := Copy(TempStr, 1, posex(':', TempStr) - 1);
  Delete(TempStr, 1, posex(':', TempStr));

  try
    i := StrToInt(TempStr);
    except
    i := 0;
  end;

  if (i <= 0) or (i > 65535) then
  begin
    MessageBox(Handle,
               pwidechar(traduzidos[104]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    exit;
  end;

  ListView1.Selected.Caption := TempDNS;
  ListView1.Selected.SubItems.Strings[0] := inttostr(i);
end;

procedure TFormConnectionSettings.ExcluirDNS1Click(Sender: TObject);
begin
  SpeedButton2.Click;
end;

procedure TFormConnectionSettings.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;

  ImageList32.GetBitmap(0, SpeedButton1.Glyph);
  ImageList32.GetBitmap(1, SpeedButton2.Glyph);

  Edit1.MaxLength := 10;
  Edit2.MaxLength := (SizeOf(ConfiguracoesServidor.ServerID) div 2) - 1;
  Edit3.MaxLength := (SizeOf(ConfiguracoesServidor.GroupID) div 2) - 1;
  Edit4.MaxLength := 122;
end;

procedure TFormConnectionSettings.FormDestroy(Sender: TObject);
var
  Item: TListItem;
  i: integer;
  TempStr: string;
begin
  {$IFDEF XTREMETRIAL}
  ConfiguracoesServidor.Ports[0] := 81;
  ConfiguracoesServidor.DNS[0] := '127.0.0.1';
  {$ELSE}
  for I := 0 to NUMMAXCONNECTION - 1 do
  if ListView1.Items.Item[i] <> nil then
  begin
    Item := ListView1.Items.Item[i];
    ConfiguracoesServidor.DNS[i] := StrToArray(Item.Caption);
    ConfiguracoesServidor.Ports[i] := StrToInt(Item.SubItems.Strings[0]);
  end else
  begin
    ZeroMemory(@ConfiguracoesServidor.DNS[i], SizeOf(ConfiguracoesServidor.DNS[i]));
    ConfiguracoesServidor.Ports[i] := 0;
  end;
  {$ENDIF}

  ConfiguracoesServidor.Password := StrToInt(Edit1.Text);
  ConfiguracoesServidor.ServerID := StrToLowArray(Edit2.Text);
  ConfiguracoesServidor.GroupID := StrToLowArray(Edit3.Text);
  ConfiguracoesServidor.DownloadPlugin := CheckBox2.Checked;

  ZeroMemory(@ConfiguracoesServidor.PluginLink, SizeOf(ConfiguracoesServidor.PluginLink));
  if CheckBox2.Checked = True then
  begin
    TempStr := Edit4.Text;
    CopyMemory(@ConfiguracoesServidor.PluginLink, @TempStr[1], Length(TempStr) * 2);
  end;
end;

procedure TFormConnectionSettings.FormShow(Sender: TObject);
var
  i: integer;
  Item: TListItem;
begin
  AtualizarIdiomas;
  Edit1.SetFocus;
  ListView1.Items.Clear;
  SpeedButton2.Visible := False;

  for I := 0 to NUMMAXCONNECTION - 1 do
  if (ConfiguracoesServidor.Ports[i] > 0) and
     (ConfiguracoesServidor.DNS[i] <> '') then
  begin
    Item := ListView1.Items.Add;
    Item.Caption := ConfiguracoesServidor.DNS[i];
    Item.SubItems.Add(IntToStr(ConfiguracoesServidor.Ports[i]));
  end;

  Edit1.Text := IntToStr(ConfiguracoesServidor.Password);
  Edit2.Text := ConfiguracoesServidor.ServerID;
  Edit3.Text := ConfiguracoesServidor.GroupID;
  Edit4.Text := ConfiguracoesServidor.PluginLink;
  CheckBox1.Checked := False;
  CheckBox2.Checked := ConfiguracoesServidor.DownloadPlugin;
  CheckBox2Click(CheckBox2);
end;

Procedure CriarArquivo(NomedoArquivo: pWideChar; Buffer: pWideChar; Size: int64);
var
  hFile: THandle;
  lpNumberOfBytesWritten: DWORD;
begin
  hFile := CreateFile(NomedoArquivo, GENERIC_WRITE, FILE_SHARE_WRITE, nil, CREATE_ALWAYS, 0, 0);

  if hFile <> INVALID_HANDLE_VALUE then
  begin
    if Size = INVALID_HANDLE_VALUE then
    SetFilePointer(hFile, 0, nil, FILE_BEGIN);
    WriteFile(hFile, Buffer[0], Size, lpNumberOfBytesWritten, nil);
  end;

  CloseHandle(hFile);
end;

procedure TFormConnectionSettings.Label4Click(Sender: TObject);
var
  PluginFile: string;
  ServerBuffer: string;
  BufferSize: int64;
  resStream: TResourceStream;
begin
  SaveDialog1.Title := NomeDoPrograma + ' ' + VersaoDoPrograma;
  SaveDialog1.InitialDir := ExtractFilePath(Paramstr(0));
  SaveDialog1.FileName := 'plugin.xtr';
  SaveDialog1.Filter := 'Xtreme RAT Plugin(*.xtr)|*.xtr';
  if SaveDialog1.Execute = false then exit;
  PluginFile := SaveDialog1.FileName;

  resStream := TResourceStream.Create(hInstance, 'SERVER', 'serverfile');
  BufferSize := resStream.Size;
  SetLength(ServerBuffer, BufferSize div 2);
  resStream.Position := 0;
  resStream.Read(ServerBuffer[1], BufferSize);
  resStream.Free;

  // Se quiser enviar desencriptado...
  //EnDecryptStrRC4B(@ServerBuffer[1], Length(ServerBuffer) * 2, 'XTREME');
  ServerBuffer := ServerBuffer + 'ENDSERVERBUFFER';
  DeleteFile(PluginFile);
  CriarArquivo(pwChar(PluginFile), pwChar(ServerBuffer), Length(ServerBuffer) * 2);
  if FileExists(PluginFile) then
    MessageBox(Handle,
               pwidechar(traduzidos[655]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST) else
    MessageBox(Handle,
               pwidechar(traduzidos[656]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
end;

procedure TFormConnectionSettings.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if ListView1.Selected = nil then
  begin
    SpeedButton2.Visible := False;
    AdicionarDNS1.Enabled := True;
    ExcluirDNS1.Enabled := False;
    EditarDNS1.Enabled := ExcluirDNS1.Enabled;
    exit;
  end;

  if ListView1.SelCount = 1 then
  begin
    SpeedButton2.Visible := True;
    AdicionarDNS1.Enabled := True;
    ExcluirDNS1.Enabled := True;
    EditarDNS1.Enabled := ExcluirDNS1.Enabled;
  end else
  begin
    SpeedButton2.Visible := True;
    AdicionarDNS1.Enabled := True;
    ExcluirDNS1.Enabled := True;
    EditarDNS1.Enabled := False;
  end;
end;

procedure TFormConnectionSettings.SpeedButton1Click(Sender: TObject);
var
  TempStr: string;
  TempDNS: string;
  i, j: integer;
  Item: TListItem;
  EditSize: integer;
begin
  {$IFDEF XTREMETRIAL}
  if ListView1.Items.Count >= 1 then
  {$ELSE}
  if ListView1.Items.Count >= NUMMAXCONNECTION then
  {$ENDIF}
  begin
    MessageBox(Handle,
  {$IFDEF XTREMETRIAL}
               pwidechar(traduzidos[101] + ' ' + inttostr(1)),
  {$ELSE}
               pwidechar(traduzidos[101] + ' ' + inttostr(NUMMAXCONNECTION)),
  {$ENDIF}
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING);
    exit;
  end;

  EditSize := (SizeOf(ConfiguracoesServidor.DNS[0]) div 2) - 1;

  TempStr := '127.0.0.1:81';
  if Inputquery(traduzidos[39], traduzidos[102] + ':', TempStr, EditSize) = false then exit;
  if posex(':', TempStr) <= 0 then
  begin
    MessageBox(Handle,
               pwidechar(traduzidos[103]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    exit;
  end;
  TempDNS := Copy(TempStr, 1, posex(':', TempStr) - 1);
  Delete(TempStr, 1, posex(':', TempStr));

  try
    i := StrToInt(TempStr);
    except
    i := 0;
  end;

  if (i <= 0) or (i > 65535) then
  begin
    MessageBox(Handle,
               pwidechar(traduzidos[104]),
               pWideChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING);
    exit;
  end;

  for j := 0 to ListView1.Items.Count - 1 do
  begin
    if (ListView1.Items.Item[j].Caption = TempDNS) and
       (ListView1.Items.Item[j].SubItems.Strings[0] = inttostr(i)) then
    begin
      exit;
    end;
  end;

  Item := ListView1.Items.Add;

  {$IFDEF XTREMETRIAL}
  Item.Caption := '127.0.0.1';
  Item.SubItems.Add(inttostr(81));
  {$ELSE}
  Item.Caption := TempDNS;
  Item.SubItems.Add(inttostr(i));
  {$ENDIF}

  Item.ImageIndex := 0;
end;


procedure TFormConnectionSettings.SpeedButton2Click(Sender: TObject);
var
  i: integer;
begin
  if ListView1.Selected = nil then Exit;
  for I := ListView1.Items.Count - 1 downto 0 do
  begin
    if ListView1.Items.Item[i].Selected then
    ListView1.Items.Item[i].Delete;
  end;
end;

end.
