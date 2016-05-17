unit UnitSettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sCheckBox, ImgList, Buttons, sSpeedButton, ExtCtrls, sPanel,
  ComCtrls, sLabel, VirtualTrees, sComboBoxes;

type
  TFormSettings = class(TForm)
    sPanel1: TsPanel;
    sSpeedButton1: TSpeedButton;
    sSpeedButton2: TSpeedButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    CheckBox3: TCheckBox;
    CheckBox4: TCheckBox;
    ImageList24: TImageList;
    OpenDialog1: TOpenDialog;
    CheckBox5: TCheckBox;
    sStickyLabel1: TsStickyLabel;
    sStickyLabel2: TsStickyLabel;
    Edit2: TEdit;
    Edit3: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    RadioGroup1: TRadioGroup;
    CheckBox6: TCheckBox;
    CheckBox7: TCheckBox;
    CheckBox8: TCheckBox;
    ColorBox1: TsColorBox;
    ColorBox2: TsColorBox;
    sStickyLabel3: TsStickyLabel;
    sStickyLabel4: TsStickyLabel;
    RadioGroup2: TRadioGroup;
    CheckBox9: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure sSpeedButton1Click(Sender: TObject);
    procedure sSpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;

implementation

uses
  UnitMain,
  UnitConexao;

{$R *.dfm}

procedure TFormSettings.FormCreate(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  ImageList24.GetBitmap(0, sSpeedButton1.Glyph);
  ImageList24.GetBitmap(1, sSpeedButton2.Glyph);
end;

procedure TFormSettings.FormShow(Sender: TObject);
begin
  UpDown2.Associate := nil;
  UpDown2.Associate := Edit3;
end;

procedure TFormSettings.sSpeedButton1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Edit1.Text := OpenDialog1.FileName;
end;

procedure TFormSettings.sSpeedButton2Click(Sender: TObject);
var
  i: integer;
  Node: pVirtualNode;
begin
  FormMain.PingColor := ColorBox1.Selected;
  FormMain.MainColor := ColorBox2.Selected;
  FormMain.ListView1.Canvas.Font.Color := FormMain.MainColor;

  Node := FormMain.MainList.GetFirst;
  while Assigned(Node) do
  begin
    pConexaoNew(FormMain.MainList.GetNodeData(Node))^.FontColor := FormMain.MainColor;
    Node := FormMain.MainList.GetNext(Node);
  end;

  FormMain.MainList.Update;
  ModalResult := mrOK;
end;

end.
