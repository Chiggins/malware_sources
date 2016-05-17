unit UnitFMEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, UnitMain, Mask;

type
  TFormFMEdit = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    bsSkinStdLabel2: TLabel;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure bsSkinStdLabel2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFMEdit: TFormFMEdit;

implementation

{$R *.dfm}

uses
  UnitCommonProcedures;

procedure TFormFMEdit.bsSkinStdLabel2Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormFMEdit.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then bsSkinStdLabel2Click(nil) else
  if key = #27 then Close;
end;

procedure TFormFMEdit.FormCreate(Sender: TObject);
var
  i: integer;
begin  
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormFMEdit.FormShow(Sender: TObject);
begin
  ModalResult := mrNo;
end;

end.
