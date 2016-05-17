unit UnitServiceInstall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UnitMain, AdvOfficeButtons, Mask;

type
  TFormServiceInstall = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    ComboBox1: TComboBox;
    CheckBox1: TCheckBox;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
    procedure Edit4KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormServiceInstall: TFormServiceInstall;

implementation

{$R *.dfm}

uses
  UnitCommonProcedures;

procedure TFormServiceInstall.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormServiceInstall.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFormServiceInstall.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit2.SetFocus;
end;

procedure TFormServiceInstall.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit3.SetFocus;
end;

procedure TFormServiceInstall.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Edit4.SetFocus;
end;

procedure TFormServiceInstall.Edit4KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then BitBtn1Click(BitBtn1);
end;

end.
