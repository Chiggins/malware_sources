unit UnitExecParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, StdCtrls, Mask, ExtCtrls, sLabel;

type
  TFormExecParam = class(TForm)
    Button2: TButton;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TsLabel;
    bsSkinRadioGroup1: TRadioGroup;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormExecParam: TFormExecParam;

implementation

{$R *.dfm}

uses
  UnitStrings;

procedure TFormExecParam.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TFormExecParam.Button2Click(Sender: TObject);
begin
  Modalresult := mrCancel;
end;

procedure TFormExecParam.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then Button1Click(self);
end;

procedure TFormExecParam.FormShow(Sender: TObject);
begin
  bsSkinRadioGroup1.Caption := Traduzidos[315];
  Button2.Caption := Traduzidos[120];
  Label1.Caption := Traduzidos[338];
  bsSkinRadioGroup1.Items.Strings[0] := traduzidos[317];
  bsSkinRadioGroup1.Items.Strings[1] := traduzidos[318];

  Label2.Transparent := False;
  Label2.Color := $000D8A77;
end;

end.
