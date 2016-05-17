unit UnitBinderSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, StdCtrls, Buttons, ExtCtrls;

type
  TFormBinderSelect = class(TForm)
    RadioGroup1: TRadioGroup;
    RadioGroup2: TRadioGroup;
    RadioGroup3: TRadioGroup;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBinderSelect: TFormBinderSelect;

implementation

{$R *.dfm}

procedure TFormBinderSelect.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFormBinderSelect.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormBinderSelect.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList1.GetBitmap(0, bitbtn1.Glyph);
  ImageList1.GetBitmap(1, bitbtn2.Glyph);
end;

end.
