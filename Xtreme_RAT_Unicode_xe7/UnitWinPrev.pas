unit UnitWinPrev;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  TFormWinPrev = class(TForm)
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormWinPrev: TFormWinPrev;

implementation

{$R *.dfm}

procedure TFormWinPrev.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  FormWinPrev := nil;
end;

procedure TFormWinPrev.FormShow(Sender: TObject);
begin
  Self.Left := (screen.width - Self.width) div 2 ;
  Self.top := (screen.height - Self.height) div 2;
  SetWindowPos(Handle,
               HWND_TOPMOST,
               0, 0, 0, 0,
              SWP_NOMOVE or SWP_NOSIZE or SWP_SHOWWINDOW);
end;

end.
