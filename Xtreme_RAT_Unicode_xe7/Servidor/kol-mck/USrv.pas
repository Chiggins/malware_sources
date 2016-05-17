Unit USrv;

interface
uses Windows, Classes, Graphics, Controls, Messages, Dialogs,
     SysUtils;

const WM_GETIMAGE = WM_USER + $0429;

function  BitmapToRegion(Bitmap: TBitmap): HRGN;
function  CopyToBitmap(Control: TControl; Bitmap: TBitmap; Anyway: boolean): boolean;
procedure CopyParentImage(Control: TControl; Dest: TCanvas);
procedure RestoreImage(DestDC: HDC; SrcBitmap: TBitmap; r: TRect;
                       dwROP: dword); overload;
procedure RestoreImage(DestDC: HDC; SrcBitmap: TBitmap; l, t, w, h: integer;
                       dwROP: dword); overload;
procedure AjustBitmap(const M: TBitmap; S, C: TColor);
procedure FadeBitmap(const M: TBitmap; C: TColor; D: byte);
function  IncColor(C: TColor; D: integer): TColor;

implementation

function BitmapToRegion(Bitmap: TBitmap): HRGN;
var
   X, Y: Integer;
 XStart: Integer;
 TransC: TColor;
      R: HRGN;
begin
   Result := 0;
   with Bitmap do begin
      TransC := Canvas.Pixels[0, 0];
      for Y := 0 to Height - 1 do begin
         X := 0;
         while X < Width do begin
            while (X < Width) and (Canvas.Pixels[X, Y]  = TransC) do Inc(X);
            if X >= Width then Break;
            XStart := X;
            while (X < Width) and (Canvas.Pixels[X, Y] <> TransC) do Inc(X);
            R := CreateRectRgn(XStart, Y, X, Y + 1);
            if Result = 0 then Result := R
                          else begin
               CombineRgn(Result, Result, R, RGN_OR);
               DeleteObject(R);
            end;
         end;
      end;
   end;
end;

function CopyToBitmap;
var x, y: integer;
begin
   Result := False;
   if Control = nil then exit;
   x := BitMap.Width  - 2;
   y := BitMap.Height - 2;
   if (Anyway) or
      (x + 2 <> Control.Width) or
      (y + 2 <> Control.Height) or
      (BitMap.Canvas.Pixels[x, y] = $FFFFFF) or
      (BitMap.Canvas.Pixels[x, y] = $000000) then begin
       BitMap.Width  := Control.Width;
       BitMap.Height := Control.Height;
       CopyParentImage(Control, BitMap.Canvas);
       Result := True;
   end;
end;

type
  TParentControl = class(TWinControl);

procedure CopyParentImage(Control: TControl; Dest: TCanvas);
var
  I, Count, X, Y, SaveIndex: Integer;
  DC: HDC;
  R, SelfR, CtlR: TRect;
begin
  if (Control = nil) or (Control.Parent = nil) then Exit;
  Count := Control.Parent.ControlCount;
  DC := Dest.Handle;
  with Control.Parent do ControlState := ControlState + [csPaintCopy];
  try
    with Control do begin
      SelfR := Bounds(Left, Top, Width, Height);
      X := -Left; Y := -Top;
    end;
    { Copy parent control image }
    SaveIndex := SaveDC(DC);
    try
       if TParentControl(Control.Parent).Perform(
          WM_GETIMAGE, DC, integer(@SelfR)) <> $29041961 then begin
          SetViewportOrgEx(DC, X, Y, nil);
          IntersectClipRect(DC, 0, 0, Control.Parent.ClientWidth,
                            Control.Parent.ClientHeight);
          with TParentControl(Control.Parent) do begin
             Perform(WM_ERASEBKGND, DC, 0);
             PaintWindow(DC);
          end;
       end;
    finally
      RestoreDC(DC, SaveIndex);
    end;
    { Copy images of graphic controls }
    for I := 0 to Count - 1 do begin
      if Control.Parent.Controls[I] = Control then continue
      else if (Control.Parent.Controls[I] <> nil) and
        (Control.Parent.Controls[I] is TGraphicControl) then
      begin
        with TGraphicControl(Control.Parent.Controls[I]) do begin
          CtlR := Bounds(Left, Top, Width, Height);
          if Bool(IntersectRect(R, SelfR, CtlR)) and Visible then begin
            ControlState := ControlState + [csPaintCopy];
            SaveIndex := SaveDC(DC);
            try
              if Perform(
                 WM_GETIMAGE, DC, integer(@SelfR)) <> $29041961 then begin
{                 SaveIndex := SaveDC(DC);}
                 SetViewportOrgEx(DC, Left + X, Top + Y, nil);
                 IntersectClipRect(DC, 0, 0, Width, Height);
                 Perform(WM_PAINT, DC, 0);
              end;
            finally
              RestoreDC(DC, SaveIndex);
              ControlState := ControlState - [csPaintCopy];
            end;
          end;
        end;
      end;
    end;
  finally
    with Control.Parent do ControlState := ControlState - [csPaintCopy];
  end;
end;

procedure RestoreImage(DestDC: HDC; SrcBitmap: TBitmap; r: TRect;
                       dwROP: dword); overload;
begin
   RestoreImage(DestDC, SrcBitmap, r.Left, r.Top,
                r.Right - r.Left, r.Bottom - r.Top, dwROP);
end;

procedure RestoreImage(DestDC: HDC; SrcBitmap: TBitmap; l, t, w, h: integer;
                       dwROP: dword); overload;
var x, y: integer;
begin
   x := l + w div 2;
   y := t + h div 2;
   if (SrcBitmap.Canvas.Pixels[x, y] <> $FFFFFF) and
      (SrcBitMap.Canvas.Pixels[x, y] <> $000000) then begin
      x := l;
      y := t;
      if y + h > SrcBitMap.Height then begin
         y := SrcBitMap.Height - h;
      end;
      bitblt(DestDC, l, t, w, h,
             SrcBitMap.Canvas.Handle, x, y, dwROP);
   end;
end;

 procedure SplitColor(C: TColor; var r, g, b: integer);
 begin
    b := (c and $FF0000) shr 16;
    g := (c and $00FF00) shr 08;
    r := (c and $0000FF) shr 00;
 end;

procedure AjustBitmap;
var i, j: integer;
       t: TBitmap;
       r,
       g,
       b,
      r2,
      g2,
      b2: integer;
       p: PRGBTriple;

 function CalcColor(c1, c2, c3: integer): integer;
 begin
   if c1 = c3 then begin
      Result := c2;
      exit;
   end;

   if c1 = 0 then begin
      Result := 0;
      exit;
   end;

{   Result := 255 * c1 div c3 - c1 * (255 - c1) * (255 - c2) div c3 div (255 - c3);
   exit;}

   Result := c1 * c2 div c3;
   if c2 = 0 then Result := c1 * 150 div 255;
   if Result > 255 then Result := 255;
   if Result <  50 then Result :=  Result + 50;
{   exit;
   a  := trunc(x1 * 3);
   a := c1 * (255 - c1) * c2 * (255 - c2) div c3 div (255 - c3);
   a := 255 * 255 - 4 * a;
   try
      x1 := Trunc((255 - sqrt(a)) / 2);
      x2 := Trunc((255 + sqrt(a)) / 2);
      if x1 > x2 then Result := Trunc(x1)
                 else Result := Trunc(x2);
   except
      Result := 0;
   end;}
 end;

begin
   if s         = c then exit;
   if m.Width   = 0 then exit;
   if m.Height  = 0 then exit;
   t := TBitmap.Create;
   m.PixelFormat := pf24bit;
   t.Assign(m);
   SplitColor(ColorToRGB(s), r, g, b);
   if r = 0 then r := 1;
   if g = 0 then g := 1;
   if b = 0 then b := 1;
   SplitColor(ColorToRGB(c), r2, g2, b2);
   for j := 0 to t.Height - 1 do begin
      p := t.scanline[j];
      for i := 0 to t.Width - 1 do begin
         p.rgbtRed   := CalcColor(p.rgbtRed,   r2, r);
         p.rgbtGreen := CalcColor(p.rgbtGreen, g2, g);
         p.rgbtBlue  := CalcColor(p.rgbtBlue,  b2, b);
         inc(p);
      end;
   end;
   m.Assign(t);
   t.Free;
end;

procedure FadeBitmap;
var i, j: integer;
       t: TBitmap;
       r,
       g,
       b: integer;
       p: PRGBTriple;

 function CalcColor(o: byte; c: byte; b: byte): byte;
 var d: byte;
 begin
    Result := c;
    if o > c then begin
       d := $FF - c;
       if d > b then d := b;
       Result := c + c * d div 255;
    end else
    if o < c then begin
       d := c;
       if d > b then d := b;
       Result := c - c * d div 255;
    end;
 end;

begin
   if m.Width   = 0 then exit;
   if m.Height  = 0 then exit;
   t := TBitmap.Create;
   m.PixelFormat := pf24bit;
   t.Assign(m);
   SplitColor(ColorToRGB(c), r, g, b);
   if r = 0 then r := 1;
   if g = 0 then g := 1;
   if b = 0 then b := 1;
   for j := 0 to t.Height - 1 do begin
      p := t.scanline[j];
      for i := 0 to t.Width - 1 do begin
         p.rgbtRed   := CalcColor(p.rgbtRed,   r, d);
         p.rgbtGreen := CalcColor(p.rgbtGreen, g, d);
         p.rgbtBlue  := CalcColor(p.rgbtBlue,  b, d);
         inc(p);
      end;
   end;
   m.Assign(t);
   t.Free;
end;

function IncColor;
var T: TColor;
    P: PRGBTriple;
begin
   T := ColorToRGB(C);
   p := @T;
   if D > 0 then begin
      if p.rgbtBlue  < 255 - D then p.rgbtBlue  := p.rgbtBlue  + D else p.rgbtBlue  := 255;
      if p.rgbtRed   < 255 - D then p.rgbtRed   := p.rgbtRed   + D else p.rgbtRed   := 255;
      if p.rgbtGreen < 255 - D then p.rgbtGreen := p.rgbtGreen + D else p.rgbtGreen := 255;
   end else begin
      if p.rgbtBlue  >       D then p.rgbtBlue  := p.rgbtBlue  - D else p.rgbtBlue  := 000;
      if p.rgbtRed   >       D then p.rgbtRed   := p.rgbtRed   - D else p.rgbtRed   := 000;
      if p.rgbtGreen >       D then p.rgbtGreen := p.rgbtGreen - D else p.rgbtGreen := 000;
   end;
   Result := T;
end;

end.
