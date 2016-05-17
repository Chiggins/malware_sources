unit acSkinPreview;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, sBitBtn, ComCtrls, sStatusBar, sEdit,
  ExtCtrls, sPanel, sSkinProvider, sSkinManager, sCheckBox, sGroupBox;

type
  TFormSkinPreview = class(TForm)
    sEdit1: TsEdit;
    sStatusBar1: TsStatusBar;
    sPanel1: TsPanel;
    sSkinProvider1: TsSkinProvider;
    sGroupBox1: TsGroupBox;
    sCheckBox1: TsCheckBox;
    sCheckBox2: TsCheckBox;
    sPanel2: TsPanel;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    PreviewManager: TsSkinManager;
    procedure FormShow(Sender: TObject);
  end;

var
  FormSkinPreview: TFormSkinPreview;

implementation

{$R *.dfm}

uses
  UnitStrings;

procedure TFormSkinPreview.FormShow(Sender: TObject);
begin
  sEdit1.Text := Traduzidos[143];
  sGroupBox1.Caption := Traduzidos[144];
  sCheckBox1.Caption := Traduzidos[145] + ' ' + inttostr(1);
  sCheckBox2.Caption := Traduzidos[145] + ' ' + inttostr(2);
  sBitBtn1.Caption := Traduzidos[146] + ' ' + inttostr(1);
  sBitBtn2.Caption := Traduzidos[146] + ' ' + inttostr(2);
  Caption := Traduzidos[147];
end;

end.
