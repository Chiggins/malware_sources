unit UnitUser;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Buttons, StdCtrls, ImgList, sSkinManager;

type
  TFormUser = class(TForm)
    Image1: TImage;
    ImageList1: TImageList;
    sSkinManager1: TsSkinManager;
    Panel1: TPanel;
    Edit1: TEdit;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    PrimeiraVez: boolean;
  end;

var
  FormUser: TFormUser;

implementation

{$R *.dfm}

uses
  UnitConstantes;

var
  TempPass: string = '';

procedure TFormUser.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then SpeedButton1.Click else
  if key = #27 then Close;
end;

procedure TFormUser.FormCreate(Sender: TObject);
begin
  Edit1.Clear;
  TempPass := '';
  Caption := NomeDoPrograma + ' ' + VersaoDoPrograma;
  ImageList1.GetBitmap(0, SpeedButton1.Glyph);
end;

procedure TFormUser.SpeedButton1Click(Sender: TObject);
begin
  if Edit1.Text = '' then
  begin
    MessageBox(Handle,
               'Please, type your password.',
               pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONWARNING or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Edit1.SetFocus;
    exit;
  end;

  if PrimeiraVez then
  begin
    TempPass := Edit1.Text;
    PrimeiraVez := False;
    MessageBox(Handle,
               'Please, retype your new password.',
               pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
               MB_OK or MB_ICONINFORMATION or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
    Edit1.SetFocus;
    Edit1.Clear;
    exit;
  end else
  begin
    if (TempPass <> '') and (TempPass <> Edit1.Text) then
    begin
      MessageBox(Handle,
                 'Please, retype your new password.',
                 pChar(NomeDoPrograma + ' ' + VersaoDoPrograma),
                 MB_OK or MB_ICONERROR or MB_SYSTEMMODAL or MB_SETFOREGROUND or MB_TOPMOST);
      Edit1.SetFocus;
      Edit1.Clear;
      exit;
    end;
  end;

  ModalResult := mrOK;
end;

end.
