unit UnitChatSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ComCtrls, ColorBtn;

type
  TFormChatSettings = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Memo1: TMemo;
    Edit1: TEdit;
    Button1: TButton;
    ColorDialog1: TColorDialog;
    Panel2: TPanel;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Button2: TButton;
    Label5: TLabel;
    Edit3: TEdit;
    Label6: TLabel;
    Edit4: TEdit;
    ColorBtn1: TColorBtn;
    ColorBtn2: TColorBtn;
    procedure Edit2Change(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Edit2Enter(Sender: TObject);
    procedure Edit2Exit(Sender: TObject);
    procedure ColorBtn1Click(Sender: TObject);
    procedure ColorBtn2Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormChatSettings: TFormChatSettings;
  PodeIniciarCHAT: boolean = false;
  DadosEnviar: string;
implementation

{$R *.dfm}

uses
  UnitPrincipal,
  UnitStrings,
  UnitConexao,
  UnitComandos;

procedure TFormChatSettings.Edit2Change(Sender: TObject);
begin
  label1.Caption := edit2.Text;
end;

procedure TFormChatSettings.FormShow(Sender: TObject);
begin
  PodeIniciarCHAT := false;
  Label2.Caption := traduzidos[473];
  label3.Font.Color := memo1.Font.Color;
  label4.Font.Color := Edit1.Font.Color;
  Label5.Caption := traduzidos[474];
  Label6.Caption := traduzidos[475];
  Button1.Caption := traduzidos[438];
  Caption := traduzidos[478];
  ColorBtn1.ButtonColor := memo1.Color;
  ColorBtn2.ButtonColor := Edit1.Color;
end;

procedure TFormChatSettings.Label3Click(Sender: TObject);
begin
  if colordialog1.Execute then
  begin
    Memo1.Font.Color := colordialog1.Color;
    Label3.Font.Color := colordialog1.Color;
  end;
end;

procedure TFormChatSettings.Label4Click(Sender: TObject);
begin
  if colordialog1.Execute then
  begin
    Edit1.Font.Color := colordialog1.Color;
    Label4.Font.Color := colordialog1.Color;
  end;
end;

procedure TFormChatSettings.Edit2Enter(Sender: TObject);
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

procedure TFormChatSettings.Edit2Exit(Sender: TObject);
var
  Ctrl: TWinControl;
begin
  if (Ctrl is TEdit) then
  TEdit(Ctrl).Color := ClWindow;
  if (Ctrl is TMemo) then
  TMemo(Ctrl).Color := ClWindow;
  if (Ctrl is TListView) then
  TListView(Ctrl).Color := ClWindow;
  if (Ctrl is TRichEdit) then
  TRichEdit(Ctrl).Color := ClWindow;
  if (Ctrl is TComboBox) then
  TComboBox(Ctrl).Color := ClWindow;
  if (Ctrl is TListBox) then
  TListBox(Ctrl).Color := ClWindow;
end;

procedure TFormChatSettings.ColorBtn1Click(Sender: TObject);
begin
  if colordialog1.Execute then
  begin
    memo1.Color := colordialog1.Color;
    ColorBtn1.ButtonColor := colordialog1.Color;
  end;
end;

procedure TFormChatSettings.ColorBtn2Click(Sender: TObject);
begin
  if colordialog1.Execute then
  begin
    Edit1.Color := colordialog1.Color;
    ColorBtn2.ButtonColor := colordialog1.Color;
  end;
end;

procedure TFormChatSettings.Button2Click(Sender: TObject);
var
  FormCaption, ServerName, ClientName, ButtonCaption, Envia, Enviou: string;
  MemoColor,
  MemoTextColor,
  EditColor,
  EditTextColor: cardinal;
begin
  if edit2.Text = '' then
  begin
    edit2.SetFocus;
    exit;
  end else
  if edit3.Text = '' then
  begin
    edit3.SetFocus;
    exit;
  end else
  if edit4.Text = '' then
  begin
    edit4.SetFocus;
    exit;
  end;

  FormCaption := Edit2.Text;
  ServerName := Edit3.Text;
  ClientName := Edit4.Text;
  MemoColor := cardinal(Memo1.Color);
  MemoTextColor := cardinal(Memo1.Font.Color);
  EditColor := cardinal(Edit1.Color);
  EditTextColor := cardinal(Edit1.Font.Color);
  ButtonCaption := Button1.Caption;
  Envia := traduzidos[476];
  Enviou := traduzidos[477];

  DadosEnviar := CHAT + '|' +
                 FormCaption + '|' +
                 ServerName + '|' +
                 ClientName + '|' +
                 inttostr(MemoColor) + '|' +
                 inttostr(MemoTextColor) + '|' +
                 inttostr(EditColor) + '|' +
                 inttostr(EditTextColor) + '|' +
                 ButtonCaption + '|' +
                 Envia + '|' +
                 Enviou + '|';
  PodeIniciarCHAT := true;
  close;
end;


end.
