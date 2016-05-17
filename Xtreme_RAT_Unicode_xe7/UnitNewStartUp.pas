unit UnitNewStartUp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, Buttons, StdCtrls, Mask;

type
  TFormNewStartUp = class(TForm)
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormNewStartUp: TFormNewStartUp;

implementation

{$R *.dfm}

Uses
  UnitCommonProcedures;

procedure TFormNewStartUp.FormCreate(Sender: TObject);
var
  i: integer;
begin  
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  FormMain.ImageListDiversos.GetBitmap(18, SpeedButton1.Glyph);
end;

procedure TFormNewStartUp.FormShow(Sender: TObject);
begin
  //
end;

procedure TFormNewStartUp.SpeedButton1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

end.
