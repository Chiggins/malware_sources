unit UnitAbout;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, AdvSmoothPanel, AdvSmoothLabel, jpeg, ExtCtrls, WallPaper, StdCtrls,
  AdvReflectionLabel, pngimage, sLabel;

type
  TFormAbout = class(TForm)
    Timer1: TTimer;
    Image1: TImage;
    Label1: TsWebLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure AdvSmoothPanel1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormAbout: TFormAbout;

implementation

{$R *.dfm}

uses
  UnitCryptString,
  UnitConstantes,
  Registry,
  ShellApi,
  Base64;

procedure TFormAbout.AdvSmoothPanel1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then close;
end;

procedure TFormAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Timer1.Enabled := False;
end;

procedure TFormAbout.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Label1.URL := Base64DecodeW('aAB0AHQAcAA6AC8ALwBzAGkAdABlAHMALgBnAG8AbwBnAGwAZQAuAGMAbwBtAC8AcwBpAHQAZQAvAG4AeAB0AHIAZQBtAGUAcgBhAHQALwA=');

  DoubleBuffered := True;
  Timer1.Enabled := False;

  ClientHeight := Image1.Height;
  ClientWidth := Image1.Width;
  Caption := NomeDoPrograma + ' ' + VersaoDoPrograma;

  Label1.Caption := Base64DecodeW(
  'QgBlAHQAYQAgAFQAZQBzAHQAZQByADoAIAANAAoALQAgAEgAaQBnAG8AcgAoAGMAYQBiAGU'+
  'A5wDjAG8AKQANAAoALQAgAGwAdQBiAHkAZABqAA0ACgANAAoATwBmAGYAaQBjAGkAYQBsAC'+
  'AAcABhAGcAZQA6AA0ACgBoAHQAdABwADoALwAvAHMAaQB0AGUAcwAuAGcAbwBvAGcAbABlA'+
  'C4AYwBvAG0ALwBzAGkAdABlAC8AbgB4AHQAcgBlAG0AZQByAGEAdAAvAA0ACgANAAoATQBv'+
  'AHIAZQAgAGkAbgBmAG8AOgANAAoALQAgAGgAdAB0AHAAOgAvAC8AcwBpAHQAZQBzAC4AZwB'+
  'vAG8AZwBsAGUALgBjAG8AbQAvAHMAaQB0AGUALwBuAHgAdAByAGUAbQBlAHIAYQB0AC8ADQ'+
  'AKAC0AIABPAHAAZQBuAFMAQwAgAGYAbwByAHUAbQANAAoALQAgAEkAbgBkAGUAdABlAGMAd'+
  'ABhAGIAbABlAHMAIABmAG8AcgB1AG0ADQAKAA0ACgBDAG8AbgB0AGEAYwB0ADoADQAKAC0A'+
  'IABuAGUAdwB4AHQAcgBlAG0AZQByAGEAdABAAGcAbQBhAGkAbAAuAGMAbwBtAA0ACgAtACA'+
  'AeAB0AHIAZQBtAGUAcgBhAHQAQABoAG8AdABtAGEAaQBsAC4AYwBvAG0A');
end;

procedure TFormAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = vk_escape then close;
end;

procedure TFormAbout.FormShow(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TFormAbout.Label1MouseEnter(Sender: TObject);
begin
  Timer1.Enabled := False;
end;

procedure TFormAbout.Label1MouseLeave(Sender: TObject);
begin
  Timer1.Enabled := True;
end;

procedure TFormAbout.Timer1Timer(Sender: TObject);
begin
  if Label1.Top >= - Label1.Height then
  Label1.Top := Label1.Top - 1 else Label1.Top := (Label1.Top + Height) + Label1.Height;
end;

end.
