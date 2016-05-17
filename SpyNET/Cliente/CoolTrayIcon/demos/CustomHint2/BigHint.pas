unit BigHint;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, CoolTrayIcon, TextTrayIcon, Menus, ExtCtrls, StdCtrls;

type
  TTiledHintWindow = class(THintWindow)
  private
    Bmp: TBitmap;
    procedure TileImage(Bitmap: TBitmap; R: TRect);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

  TForm1 = class(TForm)
    TextTrayIcon1: TTextTrayIcon;
    PopupMenu1: TPopupMenu;
    Regular1: TMenuItem;
    Custom1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Timer1: TTimer;
    Timer2: TTimer;
    Label1: TLabel;
    Button1: TButton;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure TextTrayIcon1MouseExit(Sender: TObject);
    procedure TextTrayIcon1MouseEnter(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure TextTrayIcon1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Regular1Click(Sender: TObject);
    procedure Custom1Click(Sender: TObject);
  private
    HintWindow1: THintWindow;
    HintWindow2: TTiledHintWindow;
    CurrentHintWindow: THintWindow;
    LastMouse, LastHint: TPoint;
    Hint: string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
{$R 'images.res'}

{------------------------ TForm1 ----------------------}

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  HintWindow1 := THintWindow.Create(Self);
  HintWindow1.Color := clAqua;
  HintWindow1.Canvas.Font.Style := [fsBold];
  HintWindow1.Canvas.Font.Size := 10;

  HintWindow2 := TTiledHintWindow.Create(Self);
  HintWindow2.Canvas.Font.Color := clWhite;

  Timer1.Interval := Application.HintPause;
  Timer2.Interval := Application.HintHidePause;

  Hint := Hint + 'This is a BIG hint!'+#13;
  for I := 1 to 30 do
  begin
    Hint := Hint + 'abc - 0123456789 - 0123456789 - 0123456789 - 0123456789 - def';
    if I <> 30 then
      Hint := Hint + #13;
  end;

  Regular1Click(Self);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  HintWindow1.Free;
  HintWindow2.Free;
end;

procedure TForm1.TextTrayIcon1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  LastMouse.X := X;
  LastMouse.Y := Y;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  HintRect: TRect;
begin
  Timer1.Enabled := False;
  if (LastHint.X <> LastMouse.X) or (LastHint.Y <> LastMouse.Y) then
  begin
    if not Timer2.Enabled then
    begin
      HintRect := CurrentHintWindow.CalcHintRect(Screen.Width, Hint, nil);
      CurrentHintWindow.ActivateHint(Rect(LastMouse.X - HintRect.Right,
               LastMouse.Y - HintRect.Bottom, LastMouse.X, LastMouse.Y), Hint);
    end;
    LastHint.X := LastMouse.X;
    LastHint.Y := LastMouse.Y;
  end;
  Timer2.Enabled := true;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
begin
  CurrentHintWindow.ReleaseHandle;
  Timer2.Enabled := False;
end;

procedure TForm1.Regular1Click(Sender: TObject);
begin
  Regular1.Checked := True;
  CurrentHintWindow := HintWindow1;
end;

procedure TForm1.Custom1Click(Sender: TObject);
begin
  Custom1.Checked := True;
  CurrentHintWindow := HintWindow2;
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.TextTrayIcon1MouseExit(Sender: TObject);
begin
  CurrentHintWindow.ReleaseHandle;
  Timer1.Enabled := False;
  Timer2.Enabled := False;
  Timer1.Interval := Application.HintPause;
  Timer2.Interval := 5000;        // Seems to be the time a tooltip is open
end;

procedure TForm1.TextTrayIcon1MouseEnter(Sender: TObject);
begin
  if not Timer1.Enabled then
    Timer1.Enabled := True;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Exit1Click(Self);
end;

{------------------ TTiledHintWindow ------------------}

constructor TTiledHintWindow.Create(AOwner: TComponent);
var
  H: HBITMAP;
begin
  inherited Create(AOwner);
  Bmp := TBitmap.Create;
  H := LoadBitmap(HINSTANCE, 'BACKGROUND');
  Bmp.Handle := H;
end;

destructor TTiledHintWindow.Destroy;
begin
  Bmp.Free;
  inherited Destroy;
end;

procedure TTiledHintWindow.Paint;
var
  R: TRect;
begin
  R := ClientRect;
  Inc(R.Left, 2);
  Inc(R.Top, 2);
  TileImage(Bmp, R);
  DrawText(Canvas.Handle, PChar(Caption), -1, R, DT_LEFT or DT_NOPREFIX or
           DT_WORDBREAK or DrawTextBiDiModeFlagsReadingOnly);
end;

procedure TTiledHintWindow.TileImage(Bitmap: TBitmap; R: TRect);
var
  X, Y: Integer;
begin
  try
    for X := 0 to (R.Right-R.Left) div Bitmap.Width do
      for Y := 0 to (R.Bottom-R.Top) div Bitmap.Height do
        Canvas.Draw(X * Bitmap.Width, Y * Bitmap.Height, Bitmap);
  finally
  end;
end;

end.

