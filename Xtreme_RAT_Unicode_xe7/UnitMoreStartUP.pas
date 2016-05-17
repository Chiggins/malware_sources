unit UnitMoreStartUP;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TFormMoreStartUP = class(TForm)
    Label5: TLabel;
    Edit3: TEdit;
    CheckBox10: TCheckBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMoreStartUP: TFormMoreStartUP;

implementation

{$R *.dfm}

uses
  UnitStrings,
  Unitmain;

procedure TFormMoreStartUP.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormMoreStartUP.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormMoreStartUP.FormCreate(Sender: TObject);
begin
  FormMain.ImageListDiversos.GetBitmap(18, BitBtn1.Glyph);
  FormMain.ImageListDiversos.GetBitmap(40, BitBtn2.Glyph);
end;

procedure TFormMoreStartUP.FormShow(Sender: TObject);
begin
  Caption := Traduzidos[623] + '...';
  Label5.Caption := Traduzidos[185] + ':';
  BitBtn2.Caption := Traduzidos[464];
end;

end.
