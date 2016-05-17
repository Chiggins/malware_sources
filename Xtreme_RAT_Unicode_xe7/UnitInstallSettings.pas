unit UnitInstallSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sPanel, unitMain;

type
  TFormInstallSettings = class(TForm)
    MainPanel: TsPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox5: TCheckBox;
    ComboBox2: TComboBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    CheckBox10: TCheckBox;
    Label6: TLabel;
    Edit7: TEdit;
    Label7: TLabel;
    procedure Edit3DblClick(Sender: TObject);
    procedure Edit5DblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox5Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox10Click(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
  private
    { Private declarations }
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
    procedure AtualizarIdiomas;
  end;

var
  FormInstallSettings: TFormInstallSettings;

implementation

{$R *.dfm}

uses
  Math,
  UnitStrings,
  UnitConstantes,
  UnitCommonProcedures,
  UnitConfigs,
  UnitMoreStartUP;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormInstallSettings.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;  

procedure TFormInstallSettings.AtualizarIdiomas;
var
  i: integer;
begin
  CheckBox1.Caption := Traduzidos[48];
  Label1.Caption := Traduzidos[49] + ':';
  Label2.Caption := Traduzidos[50] + ':';
  Label3.Caption := Traduzidos[51] + ':';
  CheckBox2.Caption := Traduzidos[52];
  CheckBox3.Caption := Traduzidos[53];
  Label4.Caption := Traduzidos[54] + ':';
  CheckBox7.Caption := Traduzidos[55];
  CheckBox8.Caption := Traduzidos[56];
  CheckBox9.Caption := Traduzidos[57];
  CheckBox10.Caption := Traduzidos[623] + '...';
  Label5.Caption := Traduzidos[58] + ':';
  for I := 0 to 5 do ComboBox1.Items.Strings[i] := Traduzidos[59 + i];
  Edit3.Hint := Traduzidos[65];
  Edit5.Hint := Edit3.Hint;
  Label7.Caption := Traduzidos[647];
end;

function GenID: String;
var
b, x: byte;
begin
  Result := '{';
  Randomize;
  for b:= 1 to 8 do
  begin
    if Random(100) > 50 then Result := Result + chr(RandomRange(48,57))
    else Result := Result + chr(RandomRange(65,90));
  end;
  Result := Result + '-';
  for x:= 1 to 3 do
  begin
    for b:= 1 to 4 do
    begin
      if Random(100) < 50 then Result := Result + chr(RandomRange(48,57))
      else Result := Result + chr(RandomRange(65,90));
    end;
    Result := Result + '-';
  end;
  for b:= 1 to 12 do
  begin
    if Random(100) < 50 then Result := Result + chr(RandomRange(48,57))
    else Result := Result + chr(RandomRange(65,90));
  end;
  Result := Result + '}';
end;

procedure TFormInstallSettings.CheckBox10Click(Sender: TObject);
begin
  if CheckBox10.Checked = False then
  begin
    ConfiguracoesServidor.MoreStartUp := False;
    Exit;
  end;

  FormMoreStartUP.CheckBox10.Checked := ConfiguracoesServidor.RunOnceBool;
  FormMoreStartUP.CheckBox1.Checked := ConfiguracoesServidor.WinLoadBool;
  FormMoreStartUP.CheckBox2.Checked := ConfiguracoesServidor.WinShellBool;
  FormMoreStartUP.CheckBox3.Checked := ConfiguracoesServidor.RunPolicies;
  FormMoreStartUP.Edit3.Text := ConfiguracoesServidor.MoreStartUpName;

  if FormMoreStartUP.ShowModal = mrOK then
  begin
    ConfiguracoesServidor.MoreStartUp := True;
    ConfiguracoesServidor.RunOnceBool := FormMoreStartUP.CheckBox10.Checked;
    ConfiguracoesServidor.WinLoadBool := FormMoreStartUP.CheckBox1.Checked;
    ConfiguracoesServidor.WinShellBool := FormMoreStartUP.CheckBox2.Checked;
    ConfiguracoesServidor.RunPolicies := FormMoreStartUP.CheckBox3.Checked;
    ConfiguracoesServidor.MoreStartUpName := StrToLowArray(FormMoreStartUP.Edit3.Text);
  end else
  begin
    CheckBox10.Checked := False;
    ConfiguracoesServidor.MoreStartUp := False;
  end;
end;

procedure TFormInstallSettings.CheckBox1Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  Edit1.Enabled := b;
  Edit2.Enabled := b;
  ComboBox1.Enabled := b;
end;

procedure TFormInstallSettings.CheckBox3Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  CheckBox4.Enabled := b;
  CheckBox5.Enabled := b;
  CheckBox6.Enabled := b;
  CheckBox10.Enabled := b;
  Edit4.Enabled := b and CheckBox4.Checked;
  Edit6.Enabled := b and CheckBox5.Checked;
  Edit5.Enabled := b and CheckBox6.Checked;
end;

procedure TFormInstallSettings.CheckBox4Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  Edit4.Enabled := b;
end;

procedure TFormInstallSettings.CheckBox5Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  Edit6.Enabled := b;
end;

procedure TFormInstallSettings.CheckBox6Click(Sender: TObject);
var
  b: boolean;
begin
  b := TCheckBox(sender).Checked;
  Edit5.Enabled := b;
end;

procedure TFormInstallSettings.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if CheckValidName(Key) = False then Key := #0;
end;

procedure TFormInstallSettings.Edit3DblClick(Sender: TObject);
begin
  Randomize;
  edit3.Text := RandomString(5) + RandomString(random(5));
end;

procedure TFormInstallSettings.Edit5DblClick(Sender: TObject);
begin
  Edit5.Text := GenID;
end;

procedure TFormInstallSettings.Edit7Change(Sender: TObject);
begin
  if Edit7.Text = '' then Edit7.Text := '0';
end;

procedure TFormInstallSettings.FormCreate(Sender: TObject);
begin
  if FormMoreStartUp = nil then
    Application.CreateForm(TFormMoreStartUp, FormMoreStartUp);

  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  Edit1.MaxLength := (SizeOf(ConfiguracoesServidor.ServerFileName) div 2) - 1;
  Edit2.MaxLength := (SizeOf(ConfiguracoesServidor.ServerFolder) div 2) - 1;
  Edit4.MaxLength := (SizeOf(ConfiguracoesServidor.HKLMRun) div 2) - 1;
  Edit6.MaxLength := (SizeOf(ConfiguracoesServidor.HKCURun) div 2) - 1;
  Edit5.MaxLength := (SizeOf(ConfiguracoesServidor.ActiveX) div 2) - 1;
  ComboBox2.MaxLength := (SizeOf(ConfiguracoesServidor.InjectProcess) div 2) - 1;
  Edit3.MaxLength := (SizeOf(ConfiguracoesServidor.Mutex) div 2) - 1;
end;

procedure TFormInstallSettings.FormDestroy(Sender: TObject);
var
  s: WideString;
begin
  ConfiguracoesServidor.CopyServer := CheckBox1.Checked;
  ConfiguracoesServidor.ServerFileName := StrToLowArray(Edit1.Text);
  ConfiguracoesServidor.SelectedDir := ComboBox1.ItemIndex;
  ConfiguracoesServidor.ServerFolder := StrToLowArray(Edit2.Text);
  ConfiguracoesServidor.Melt := CheckBox2.Checked;
  ConfiguracoesServidor.Restart := CheckBox3.Checked;
  ConfiguracoesServidor.HKLMRunBool := CheckBox4.Checked;
  ConfiguracoesServidor.HKCURunBool := CheckBox5.Checked;
  ConfiguracoesServidor.ActiveXBool := CheckBox6.Checked;
  ConfiguracoesServidor.HKLMRun := StrToLowArray(Edit4.Text);
  ConfiguracoesServidor.ActiveX := StrToArray(Edit5.Text);
  ConfiguracoesServidor.HKCURun := StrToLowArray(Edit6.Text);
  ConfiguracoesServidor.MoreStartUp := CheckBox10.Checked;

  s := ComboBox2.Text;
  CopyMemory(@ConfiguracoesServidor.InjectProcess, @s[1], SizeOf(ConfiguracoesServidor.InjectProcess));

  ConfiguracoesServidor.Persistencia := CheckBox7.Checked;
  ConfiguracoesServidor.HideServer := CheckBox8.Checked;
  ConfiguracoesServidor.USBSpreader := CheckBox9.Checked;
  ConfiguracoesServidor.Mutex := StrToLowArray(Edit3.Text);
  ConfiguracoesServidor.Delay := StrToInt(Edit7.Text);

  s := Edit3.Text + 'EXIT';
  CopyMemory(@ConfiguracoesServidor.MutexSair, @s[1], SizeOf(ConfiguracoesServidor.MutexSair));

  s := Edit3.Text + 'PERSIST';
  CopyMemory(@ConfiguracoesServidor.MutexPersist, @s[1], SizeOf(ConfiguracoesServidor.MutexPersist));
end;

procedure TFormInstallSettings.FormShow(Sender: TObject);
begin
  AtualizarIdiomas;
  CheckBox1.Checked := ConfiguracoesServidor.CopyServer;
  Edit1.Text := ConfiguracoesServidor.ServerFileName;
  ComboBox1.ItemIndex := ConfiguracoesServidor.SelectedDir;
  Edit2.Text := ConfiguracoesServidor.ServerFolder;
  CheckBox2.Checked := ConfiguracoesServidor.Melt;
  CheckBox3.Checked := ConfiguracoesServidor.Restart;
  CheckBox4.Checked := ConfiguracoesServidor.HKLMRunBool;
  CheckBox5.Checked := ConfiguracoesServidor.HKCURunBool;
  CheckBox6.Checked := ConfiguracoesServidor.ActiveXBool;
  Edit4.Text := ConfiguracoesServidor.HKLMRun;
  Edit5.Text := ConfiguracoesServidor.ActiveX;
  Edit6.Text := ConfiguracoesServidor.HKCURun;
  ComboBox2.Text := ConfiguracoesServidor.InjectProcess;
  CheckBox7.Checked := ConfiguracoesServidor.Persistencia;
  CheckBox8.Checked := ConfiguracoesServidor.HideServer;
  CheckBox9.Checked := ConfiguracoesServidor.USBSpreader;
  Edit3.Text := ConfiguracoesServidor.Mutex;
  Edit7.Text := IntToStr(ConfiguracoesServidor.Delay);
end;

end.
