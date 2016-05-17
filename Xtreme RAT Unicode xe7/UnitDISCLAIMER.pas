unit UnitDISCLAIMER;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ExtCtrls, sSkinManager;

type
  TFormDISCLAIMER = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    CheckBox1: TCheckBox;
    sSkinManager1: TsSkinManager;
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDISCLAIMER: TFormDISCLAIMER;

implementation

{$R *.dfm}

procedure TFormDISCLAIMER.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormDISCLAIMER.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure Contagem;
var
  i: integer;
begin
  i := 20;
  for I := 20 downto 1 do
  begin
    FormDISCLAIMER.BitBtn1.Caption := 'I Agree (' + IntToStr(i) + ')';
    sleep(1000);
  end;
  FormDISCLAIMER.BitBtn1.Caption := 'I Agree';
  FormDISCLAIMER.BitBtn1.Enabled := True;
end;

procedure TFormDISCLAIMER.FormShow(Sender: TObject);
var
  c: cardinal;
begin
  BitBtn1.Enabled := False;
  CreateThread(nil, 0, @Contagem, nil, 0, c);
end;

end.
