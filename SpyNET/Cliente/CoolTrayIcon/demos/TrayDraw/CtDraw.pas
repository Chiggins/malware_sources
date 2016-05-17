unit CtDraw;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, CoolTrayIcon;

type
  TDrawForm = class(TForm)
    PaintBox1: TPaintBox;
    Button2: TButton;
    CoolTrayIcon1: TCoolTrayIcon;
    Button3: TButton;
    Button4: TButton;
    OpenPictureDialog1: TOpenPictureDialog;
    Shape1: TShape;
    CheckBox1: TCheckBox;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  private
    StartX, StartY: Integer;
    CurrentX, CurrentY: Integer;
    Drawing: Boolean;
    DrawBitmap: TBitmap;
    procedure UpdateIcon;
    procedure CopyToBitmap(const Bmp: TBitmap);
    procedure SetSolidPen;
    procedure SetFeatherPen;
    procedure Clear;
  end;

var
  DrawForm: TDrawForm;

implementation

{$R *.DFM}

procedure TDrawForm.FormCreate(Sender: TObject);
begin
  DrawBitmap := TBitmap.Create;
  DrawBitmap.Width := 16;
  DrawBitmap.Height := 16;
//  Clear;
end;


procedure TDrawForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DrawBitmap.Free;
end;


procedure TDrawForm.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  StartX := X;
  StartY := Y;
  Drawing := True;
end;


procedure TDrawForm.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  SetSolidPen;
  PaintBox1.Canvas.MoveTo(StartX, StartY);
  PaintBox1.Canvas.LineTo(X, Y);
  CurrentX := 0;
  CurrentY := 0;
  Drawing := False;
  CopyToBitmap(DrawBitmap);
  UpdateIcon;
end;


procedure TDrawForm.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  if Drawing then
    with PaintBox1.Canvas do
    begin
      // Erase old line
      if (CurrentX <> 0) and (CurrentY <> 0) then
      begin
        SetFeatherPen;
        MoveTo(StartX, StartY);
        LineTo(CurrentX, CurrentY);
      end;
      // Draw new line
      SetFeatherPen;
      MoveTo(StartX, StartY);
      LineTo(X, Y);
      CurrentX := X;
      CurrentY := Y;
    end;
end;


procedure TDrawForm.Clear;
begin
  PaintBox1.Canvas.Brush.Color := clWhite;
  PaintBox1.Canvas.FillRect(Rect(0, 0, PaintBox1.Width, PaintBox1.Height));
  if not DrawBitmap.Empty then
  begin
    CopyToBitmap(DrawBitmap);
    UpdateIcon;
  end;
end;


procedure TDrawForm.SetSolidPen;
begin
  with PaintBox1.Canvas do
  begin
    Pen.Mode := pmCopy;
    Pen.Style := psSolid;
    Pen.Width := 8;
    Pen.Color := clBlack;
  end;
end;


procedure TDrawForm.SetFeatherPen;
begin
  with PaintBox1.Canvas do
  begin
    Pen.Mode := pmNotXor;
    Pen.Style := psDot;
    Pen.Width := 1;
    Pen.Color := clBlack;
  end;
end;


procedure TDrawForm.CopyToBitmap(const Bmp: TBitmap);
var
  DrawCanvas: TCanvas;
begin
  DrawCanvas := TCanvas.Create;
  try
    DrawCanvas.Handle := PaintBox1.Canvas.Handle;
    Bmp.Width := PaintBox1.Width;
    Bmp.Height := PaintBox1.Height;
    Bmp.Canvas.CopyRect(PaintBox1.ClientRect, DrawCanvas, PaintBox1.ClientRect);
    // Resize to 16x16
    Bmp.Canvas.StretchDraw(Rect(0, 0, 16, 16), Bmp);
  finally
    DrawCanvas.Free;
  end;
end;


procedure TDrawForm.UpdateIcon;
var
  Ico: TIcon;
  MaskColor: TColor;
begin
  Ico := TIcon.Create;
  try
    if CheckBox1.Checked then
      // Find transparent color (bottom left pixel)
      MaskColor := DrawBitmap.Canvas.Pixels[0, DrawBitmap.Height-1]
    else
      // Not transparent
      MaskColor := clNone;

    if CoolTrayIcon1.BitmapToIcon(DrawBitmap, Ico, MaskColor) then
    begin
      // OK, let's assign the icon
      CoolTrayIcon1.Icon.Assign(Ico);
      CoolTrayIcon1.Refresh;
    end;
  finally
    Ico.Free;
  end;
end;


procedure TDrawForm.Button1Click(Sender: TObject);
begin
  MessageDlg('This is just a silly demo of how CoolTrayIcon can render ' +
             'a tray icon from a bitmap.' + #13#13 +
             'Use the mouse to draw some lines or load a bitmap. ' +
             'Watch how the tray icon changes.',
             mtInformation, [mbOK], 0);
end;


procedure TDrawForm.Button2Click(Sender: TObject);
begin
  Clear;
end;


procedure TDrawForm.Button3Click(Sender: TObject);
var
  Bmp: TBitmap;
begin
  if OpenPictureDialog1.Execute then
  begin
    Bmp := TBitmap.Create;
    try
      Bmp.LoadFromFile(OpenPictureDialog1.Filename);
      PaintBox1.Canvas.StretchDraw(PaintBox1.ClientRect, Bmp);
      CopyToBitmap(DrawBitmap);
      UpdateIcon;
    finally
      Bmp.Free;
    end;
  end;
end;


procedure TDrawForm.Button4Click(Sender: TObject);
begin
  Close;
end;


procedure TDrawForm.PaintBox1Paint(Sender: TObject);
begin
  with PaintBox1 do
    Canvas.CopyRect(ClientRect, DrawBitmap.Canvas, ClientRect);
end;


procedure TDrawForm.CheckBox1Click(Sender: TObject);
begin
  UpdateIcon;
end;

end.

