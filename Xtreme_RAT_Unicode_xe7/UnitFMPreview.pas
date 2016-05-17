unit UnitFMPreview;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UnitMain, Menus, ExtCtrls;

type
  TFormFMPreview = class(TForm)
    Image1: TImage;
    PopupMenu1: TPopupMenu;
    Salvar1: TMenuItem;
    SaveDialog1: TSaveDialog;
    procedure FormShow(Sender: TObject);
    procedure Salvar1Click(Sender: TObject);
    procedure PopupMenu1Popup(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormFMPreview: TFormFMPreview;

implementation

uses
  UnitStrings,
  Jpeg;

{$R *.dfm}

procedure TFormFMPreview.PopupMenu1Popup(Sender: TObject);
begin
  Salvar1.Enabled := Image1.Picture <> nil;
end;

procedure TFormFMPreview.FormShow(Sender: TObject);
begin
  Salvar1.Caption := Traduzidos[387];
  SaveDialog1.Title := Traduzidos[387];
end;

procedure TFormFMPreview.Salvar1Click(Sender: TObject);
var
  b: TBitmap;
  j: TJpegImage;
begin
  if SaveDialog1.Execute = False then Exit;
  try
    b := TBitmap.Create;
    b.Assign(Image1.Picture);
    j := TJpegImage.Create;
    j.Assign(b);
    j.SaveToFile(SaveDialog1.FileName);
    finally
    j.Free;
    b.Free;
  end;
end;

end.
