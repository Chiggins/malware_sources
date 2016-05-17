unit UnitEditarRegistro;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UnitMain, Mask, ExtCtrls;

type
  TFormEditarRegistro = class(TForm)
    Label1: TLabel;
    Edit1: TEdit;
    AdvOfficeRadioGroup1: TRadioGroup;
    Memo1: TMemo;
    BitBtn1: TBitBtn;
    Label2: TLabel;
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditarRegistro: TFormEditarRegistro;

implementation

{$R *.dfm}

uses
  UnitCommonProcedures;

procedure TFormEditarRegistro.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then BitBtn1Click(BitBtn1);
end;

procedure TFormEditarRegistro.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
end;

procedure TFormEditarRegistro.FormShow(Sender: TObject);
begin
 //
end;

procedure TFormEditarRegistro.Memo1KeyPress(Sender: TObject;
  var Key: Char);
var
  Tipo: integer;
begin
  Tipo := AdvOfficeRadioGroup1.ItemIndex;

  if (Tipo = 0) or (Tipo = 4) then
    if (key = #10) or (key = #13) then
    begin
      Key := #0;
      MessageBeep($FFFFFFFF);
    end;

  if Tipo = 2 then  //Si es un valor binario solo deja introducir números
    if not (key in ['0'..'9', #8]) then
    begin
      key := #0;
      MessageBeep($FFFFFFFF);
    end;
end;

procedure TFormEditarRegistro.BitBtn1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;


end.
