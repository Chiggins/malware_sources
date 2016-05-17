unit TrayAnimation;

{ D5 and below don't support alpha-blending (transparent forms). }
{$DEFINE DELPHI_6_UP}
{$IFDEF VER80}  {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER90}  {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER100} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER120} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF VER130} {$UNDEF DELPHI_6_UP} {$ENDIF}

interface

uses
  Windows, Classes, Graphics, Forms;

type
  TWindowFader = class(TThread)
  private
    BlendValue: Integer;
    procedure Fade;
  public
    FadeOut: Boolean;
    procedure Execute; override;
  end;

  TWindowImploder = class(TThread)
  private
    X, Y, W, H: Integer;
    procedure Implode;
  public
    Imploding: Boolean;
    procedure Execute; override;
  end;

  TWindowOutlineImploder = class(TThread)
  private
    X, Y, W, H: Integer;
    DesktopCanvas: TCanvas;
    procedure Implode;
  public
    Imploding: Boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Execute; override;
  end;


  procedure FloatingRectangles(Minimizing, OverrideUserSettings: Boolean);

implementation

uses
  Math, ShellApi, Messages, Main;

{----------------- Stand-alone methods ----------------}

procedure FloatingRectangles(Minimizing, OverrideUserSettings: Boolean);
var
  RectFrom, RectTo: TRect;
  GotRectTo: Boolean;
  abd: TAppBarData;
  HTaskbar, HTrayWnd: HWND;
  ResetRegistry: Boolean;
  ai: TAnimationInfo;

  procedure SetAnimation(Animation: Boolean);
  begin
    FillChar(ai, SizeOf(ai), 0);
    ai.cbSize := SizeOf(ai);
    if Animation then
      ai.iMinAnimate := 1
    else
      ai.iMinAnimate := 0;
    SystemParametersInfo(SPI_SETANIMATION, 0, @ai, SPIF_SENDCHANGE);
  end;

begin
  // Check if user wants window animation
  ResetRegistry := False;
  if OverrideUserSettings then
  begin
    FillChar(ai, SizeOf(ai), 0);
    ai.cbSize := SizeOf(ai);
    SystemParametersInfo(SPI_GETANIMATION, 0, @ai, SPIF_SENDCHANGE);
    if ai.iMinAnimate = 0 then
    begin
      // Temporarily enable window animation
      ResetRegistry := True;
      SetAnimation(True);
    end;
  end;

  RectFrom := MainForm.BoundsRect;
  GotRectTo := False;

  // Get the traybar's bounding rectangle
  HTaskbar := FindWindow('Shell_TrayWnd', nil);
  if HTaskbar <> 0 then
  begin
    HTrayWnd := FindWindowEx(HTaskbar, 0, 'TrayNotifyWnd', nil);
    if HTrayWnd <> 0 then
      if GetWindowRect(HTrayWnd, RectTo) then
        GotRectTo := True;
  end;

  // If that fails, invent a rectangle in the corner where the traybar is
  if not GotRectTo then
  begin
    FillChar(abd, SizeOf(abd), 0);
    abd.cbSize := SizeOf(abd);
    if SHAppBarMessage(ABM_GETTASKBARPOS, abd) = 0 then Exit;
    with Screen, abd.rc do
      if (Top > 0) or (Left > 0) then
        RectTo := Rect(Width-32, Height-32, Width, Height)
      else if (Bottom < Height) then
        RectTo := Rect(Width-32, 0, Width, 32)
      else if (Right < Width) then
        RectTo := Rect(0, Height-32, 32, Height);
  end;

  if Minimizing then
    DrawAnimatedRects(MainForm.Handle, IDANI_CAPTION, RectFrom, RectTo)
  else
    DrawAnimatedRects(MainForm.Handle, IDANI_CAPTION, RectTo, RectFrom);

  if ResetRegistry then
    SetAnimation(False);               // Disable window animation
end;

{-------------------- TWindowFader --------------------}

procedure TWindowFader.Execute;
begin
{$IFDEF DELPHI_6_UP}
  BlendValue := MainForm.AlphaBlendValue;
{$ENDIF}
  while not Terminated do
  begin
    if FadeOut then
      Dec(BlendValue, 25)
    else
      Inc(BlendValue, 25);
    Sleep(10);
//    Application.ProcessMessages;
    Synchronize(Fade);
    if (BlendValue <= 0) or (BlendValue >= 255) then
      Terminate;
  end;
end;


procedure TWindowFader.Fade;
begin
{$IFDEF DELPHI_6_UP}
  if (BlendValue >= 0) and (BlendValue <= 255) then
    MainForm.AlphaBlendValue := BlendValue;
{$ENDIF}
end;

{------------------ TWindowImploder -------------------}

procedure TWindowImploder.Execute;
const
  minW = 120;
  minH = 25;
  deltaGrowth = 0.2;
var
  maxW, maxH: Integer;
  deltaW, deltaH: Integer;
begin
  with MainForm do
  begin
    X := Left;
    Y := Top;
    W := Width;
    H := Height;
    if Imploding then
    begin
      // Store current form size
      StartX := Left;
      StartY := Top;
      StartW := Width;
      StartH := Height;
    end;
    // Remember previous form size
    maxW := StartW;
    maxH := StartH;
  end;

  while not Terminated do
  begin
    deltaW := Round((W-minW) * deltaGrowth);
    deltaH := Round((H-minH) * deltaGrowth);
    if deltaW = 0 then
      Inc(deltaW);
    if Odd(deltaW) then
      Inc(deltaW);
    if deltaH = 0 then
      Inc(deltaH);
    if Odd(deltaH) then
      Inc(deltaH);
    if Imploding then
    begin
      W := W - deltaW;
      H := H - deltaH;
      X := X + (deltaW div 2);
      Y := Y + (deltaH div 2);
    end
    else
    begin
      W := W + deltaW;
      H := H + deltaH;
      X := X - (deltaW div 2);
      Y := Y - (deltaH div 2);
    end;
    Sleep(10);

    if (Imploding and ((W <= minW) or (H <= minH) or (deltaW = 0))) or
       (not Imploding and ((W >= maxW) or (H >= maxH) or (deltaH = 0))) then
      Terminate;

    if not Terminated then
      Synchronize(Implode);
    Application.ProcessMessages;
  end;

  if not Imploding then
  begin
    with MainForm do
      SetWindowPos(Handle, 0, StartX, StartY, StartW, StartH, SWP_NOZORDER);
    Application.ProcessMessages;
  end;
end;


procedure TWindowImploder.Implode;
begin
  SetWindowPos(MainForm.Handle, 0, X, Y, W, H, SWP_NOZORDER);
end;

{--------------- TWindowOutlineImploder ---------------}

constructor TWindowOutlineImploder.Create;
begin
  inherited Create(False);
  DesktopCanvas := TCanvas.Create;
  with DesktopCanvas do
  begin
    Handle := GetDC(0);      // HDC of desktop
//    Handle := GetWindowDC(GetDesktopWindow);
    Pen.Mode := pmNotXor;
    Pen.Style := psDot;
    Pen.Width := 2;
    Pen.Color := clGray;
//    Brush.Color := clGray;
//    Brush.Style := bsDiagCross;
    Brush.Style := bsClear;
  end;
end;


destructor TWindowOutlineImploder.Destroy;
begin
//  ReleaseDC(GetDesktopWindow, DesktopCanvas.Handle);
  ReleaseDC(0, DesktopCanvas.Handle);
  DesktopCanvas.Handle := 0;
  DesktopCanvas.Free;
  DesktopCanvas := nil;
  inherited Destroy;
end;


procedure TWindowOutlineImploder.Execute;
const
  minW = 25;
  minH = 25;
  deltaGrowth = 0.25;
var
  maxW, maxH: Integer;
  deltaW, deltaH: Integer;
begin
  with MainForm do
  begin
    if Imploding then
    begin
      X := Left;
      Y := Top;
      W := Width;
      H := Height;
      // Store current form size
      StartX := Left;
      StartY := Top;
      StartW := Width;
      StartH := Height;
      CoolTrayIcon1.HideMainForm;
    end
    else
    begin
      X := StartX + ((StartW-minW) div 2);
      Y := StartY + ((StartH-minH) div 2);
      W := minW;
      H := minH;
    end;
    // Remember previous form size
    maxW := StartW;
    maxH := StartH;
  end;

  while not Terminated do
  begin
    deltaW := Round((W-minW) * deltaGrowth);
    deltaH := Round((H-minH) * deltaGrowth);
    if deltaW = 0 then
      Inc(deltaW);
    if Odd(deltaW) then
      Inc(deltaW);
    if deltaH = 0 then
      Inc(deltaH);
    if Odd(deltaH) then
      Inc(deltaH);
    if Imploding then
    begin
      W := W - deltaW;
      H := H - deltaH;
      X := X + (deltaW div 2);
      Y := Y + (deltaH div 2);
    end
    else
    begin
      W := W + deltaW;
      H := H + deltaH;
      X := X - (deltaW div 2);
      Y := Y - (deltaH div 2);
    end;
    Synchronize(Implode);

    if (Imploding and ((W <= minW) or (H <= minH) or (deltaW = 0))) or
       (not Imploding and ((W >= maxW) or (H >= maxH) or (deltaH = 0))) then
      Terminate;
  end;
end;


procedure TWindowOutlineImploder.Implode;
{var
  R: TRect;}
begin
  if not Terminated then
    if (DesktopCanvas <> nil) and (DesktopCanvas.Handle <> 0) then
    begin
//      R := Rect(X, Y, X+W, Y+H);
//      InvalidateRect(DesktopCanvas.Handle, @R, True);
//      PostMessage(DesktopCanvas.Handle, WM_SETREDRAW, 1, 0);
//      RedrawWindow(DesktopCanvas.Handle, 0, 0, RDW_ERASE or RDW_INVALIDATE or RDW_ERASENOW);
//      UpdateWindow(DesktopCanvas.Handle);
      DesktopCanvas.Rectangle(X, Y, X+W, Y+H);
      Sleep(10);
      DesktopCanvas.Rectangle(X, Y, X+W, Y+H);
    end;
end;

end.

