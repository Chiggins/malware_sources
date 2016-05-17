unit UtilFunc;

interface

uses
  windows,
  messages,
  CommDlg;

//
//--------------- Global Types, Constants and Variables ----------
//
const
  IDM_EXIT = 200;
  IDM_TEST = 201;
  IDM_ABOUT = 202;

type
  TTestProc = procedure(hWnd:HWND);
  TNotifyMessage = procedure (var Msg:TMessage);

const
  clrBlack = $000000;
  clrMaroon = $000080;
  clrGreen = $008000;
  clrOlive = $008080;
  clrNavy = $800000;
  clrPurple = $800080;
  clrTeal = $808000;
  clrGray = $808080;
  clrSilver = $C0C0C0;
  clrRed = $0000FF;
  clrLime = $00FF00;
  clrYellow = $00FFFF;
  clrBlue = $FF0000;
  clrFuchsia = $FF00FF;
  clrAqua = $FFFF00;
  clrLtGray = $C0C0C0;
  clrDkGray = $808080;
  clrWhite = $FFFFFF;


//
//--------------- window support functions ------------------------
//
function GetExeName: string;
function MakeMainWindow(WndProc:TFNWndProc): HWND;
function MessageLoopNormal: integer;

function ChangeWindowPos(hWindow: HWND; x,y: integer):Boolean;
function ChangeWindowSize(hWindow: HWND; cx,cy: integer):Boolean;
function ChangeWindowZOrder(hWindow: HWND; hWndInsertAfter: HWND):Boolean;

function CenterWindow(hWindow: HWND): Boolean;
function EraseBkGnd(hWindow: HWND;Clr:COLORREF;DC: HDC):LRESULT;

procedure MakeInitMenu(hWindow: HWND);
procedure InitMenuCommand(var Msg: TMessage;OnTest:TTestProc);

function WindowInfo(sobject: string;hWindow: HWND): string;
function ClassInfo(hWindow:HWND):string;

procedure FindOtherInstance(classname: string);

//
//--------------- utility functions -------------------------------
//
function wsprintf1(Output,Format: PChar;pr1: integer): Integer; cdecl;
function wsprintf2(Output,Format: PChar;pr1,pr2: integer): Integer; cdecl;
function wsprintf3(Output,Format: PChar;pr1,pr2,pr3: integer): Integer; cdecl;
function wsprintf4(Output,Format: PChar;pr1,pr2,pr3,pr4: integer): Integer; cdecl;

function AIntToStr(value: integer):string;
function AIntToHex(value: Integer; digits: Integer): string;

function clrBtnFace: COLORREF;
function clrWindow: COLORREF;
function clrGrayText: COLORREF;

function SetDim(x,y,width,height: Integer):TRect;

function DoChooseFont(hOwner: HWND;var ALogFont: TLogFont; Flag: DWORD;
                      var Color: COLORREF): Boolean;

procedure DrawBitmap(DC:HDC;hBit:HBITMAP;x,y:integer);

implementation                                       

//
//--------------- window support functions ------------------------
//
function GetLowDir(var Path: string): Boolean;
var
  p,Len: integer;
begin
  result := false;
  p := Pos('\',Path);
  if p <> 0 then begin
    result := true;
    Len := Length(Path)-p;
    Path := Copy(Path,p+1,Len);
    SetLength(Path,Len);
  end;
end;

function GetExeName: string;
var
  s,t: string;
  buf: array[0..MAX_PATH] of Char;
  Len: integer;
begin
  Len := GetModuleFileName(0,buf,SizeOf(buf));
  SetString(s,buf,Len);
  t := s;
  while GetLowDir(t) do s := t;
  Len := Pos('.',s);
  result := Copy(s,0,Len-1);
end;

function MakeMainWindow(WndProc:TFNWndProc): HWND;
var
  wc: TWndClass;
  hWindow: HWND;
  s: string;
begin
  s := GetExeName;

  wc.lpszClassName   := PChar(s);
  wc.lpfnWndProc     := WndProc;
  wc.style           := CS_VREDRAW or CS_HREDRAW;
  wc.hInstance       := hInstance;
  wc.hIcon           := LoadIcon(0,IDI_APPLICATION);
  wc.hCursor         := LoadCursor(0,IDC_ARROW);
  wc.hbrBackground   := (COLOR_WINDOW+1);
  wc.lpszMenuName    := nil;
  wc.cbClsExtra      := 0;
  wc.cbWndExtra      := 0;

  RegisterClass( wc );

  hWindow := CreateWindowEx(WS_EX_CONTROLPARENT or WS_EX_WINDOWEDGE,
                          PChar(s),
                          PChar(s),
                          WS_VISIBLE or WS_OVERLAPPEDWINDOW,
                          200,100,
                          300,200,
                          0,
                          0,
                          hInstance,
                          nil);

  ShowWindow(hWindow,CmdShow);
  UpDateWindow(hWindow);
  result := hWindow;
end;

function MessageLoopNormal: integer;
var
  Msg: TMsg;
begin
  while GetMessage(Msg, 0, 0, 0) do begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
  result := Msg.wParam;
end;

function ChangeWindowPos(hWindow: HWND; x,y: integer):Boolean;
begin
  result := SetWindowPos(hWindow,0,x,y,0,0,SWP_NOSIZE or SWP_NOZORDER);
end;

function ChangeWindowSize(hWindow: HWND; cx,cy: integer):Boolean;
begin
  result := SetWindowPos(hWindow,0,0,0,cx,cy,SWP_NOMOVE or SWP_NOZORDER);
end;

function ChangeWindowZOrder(hWindow: HWND; hWndInsertAfter: HWND):Boolean;
begin
  result := SetWindowPos(hWindow,hWndInsertAfter,0,0,0,0,SWP_NOSIZE or SWP_NOMOVE);
end;

function CenterWindow(hWindow: HWND): Boolean;
var
  r:TRect;
  CSX,CSY,w,h: integer;
begin
  CSX := GetSystemMetrics(SM_CXSCREEN);
  CSY := GetSystemMetrics(SM_CYSCREEN);
  GetWindowRect(hWindow,r);
  w := r.Right-r.Left;
  h := r.Bottom-r.Top;
  result := ChangeWindowPos(hWindow,(CSX-w) div 2, (CSY-h) div 2);
end;

function EraseBkGnd(hWindow: HWND;Clr:COLORREF;DC: HDC):LRESULT;
var
  hBr: hBrush;
  r: TRect;
begin
  hBr := CreateSolidBrush(Clr);
  GetClientRect(hWindow,r);
  FillRect(DC,r,hBr);
  DeleteObject(hBr);
  result := 1;
end;

procedure MakeInitMenu(hWindow: HWND);
var
  hM, hMp: HMENU;
begin
  hM := CreateMenu;

  hMp := CreateMenu;
  AppendMenu(hMp,MF_STRING,IDM_EXIT, 'E&xit');
  AppendMenu(hM,MF_POPUP,hMp,'&File');

  AppendMenu(hM, MF_STRING, IDM_TEST, '&Test!');

  hMp := CreateMenu;
  AppendMenu(hMp,MF_STRING,IDM_ABOUT, '&About..');
  AppendMenu(hM,MF_POPUP,hMp,'&Help');

  SetMenu(hWindow,hM);
end;

procedure InitMenuCommand(var Msg: TMessage;OnTest:TTestProc);
var
  hWindow: HWND;
  s: string;
begin
  hWindow := Msg.Msg;
  if Msg.WParamHi=0 then // Menu=0,Accel=1,NotifyCode=Control
    case Msg.WParamLo of
      IDM_EXIT: DestroyWindow(hWindow);
      IDM_TEST: OnTest(hWindow);
      IDM_ABOUT:begin
        s := 'OBJECT PASCAL API PROGRAM '+#13#13+
             '          By  Delphian Inc.,'+#13#13+
             '         Created by Delphi 3    '+#13#13;
        MessageBox(hWindow,PChar(s),'About ...',MB_OK);
        end;
    end;
end;

function WindowInfo(sobject: string;hWindow: HWND): string;
var
  s: string;
  c: array[0..50] of Char;
begin
  GetWindowText(hWindow,c,50);
  s := 'WindowInfo of '+sobject+#13#13;
  s := s+'TEXT = '+ string(c)+#13;
  s := s+'HANDLE = $'+ AIntToHex(hWindow,8)+#13;
  s := s+'EXSTYLE = $'+ AIntToHex(GetWindowLong(hWindow,GWL_EXSTYLE),8)+#13;
  s := s+'STYLE = $' + AIntToHex(GetWindowLong(hWindow,GWL_STYLE),8)+#13;
  s := s+'WNDPROC = $' + AIntToHex(GetWindowLong(hWindow,GWL_WNDPROC),8)+#13;
  s := s+'HINSTANCE = $'+ AIntToHex(GetWindowLong(hWindow,GWL_HINSTANCE),8)+#13;
  s := s+'HWNDPARENT = $'+ AIntToHex(GetWindowLong(hWindow,GWL_HWNDPARENT),8)+#13;
  s := s+'ID = '+ AIntToStr(GetWindowLong(hWindow,GWL_ID));
  result := s;
end;

function ClassInfo(hWindow:HWND):string;
var
  WC: TWndClass;
  c: array[0..50] of Char;
  s: string;
  i: integer;
  w: word;
begin
  GetClassName(hWindow,c,50);
  GetClassInfo(hInstance,c,WC);
  s := 'ClassInfo of '+ string(c)+#13#13+
       'Style = $'+ AIntToHex(WC.Style,8)+#13+
       'WndProc = $' + AIntToHex(integer(WC.lpfnWndProc),8)+#13+
       'hInstance = $' + AIntToHex(WC.hInstance,8)+#13+
       'ClsExtra = ' + AIntToStr(WC.cbClsExtra)+' byte'#13;
  if WC.cbClsExtra > 0 then begin
    s := s+'  ClsExtraData = ';
    for i := 0 to (WC.cbClsExtra div 2) -1 do begin
      w := GetClassWord(hWindow,i);
      s := s+AIntToHex(LOBYTE(w),1)+AIntToHex(HIBYTE(w),1);
    end;
    s := s+#13;
  end;
  s := s+'WndExtra = ' + AIntToStr(WC.cbWndExtra)+' byte'#13;
  if WC.cbWndExtra > 0 then begin
    s := s+'  WndExtraData = ';
    for i := 0 to (WC.cbWndExtra div 2) -1 do begin
      w := GetWindowWord(hWindow,i);
      s := s+AIntToHex(LOBYTE(w),1)+AIntToHex(HIBYTE(w),1);
    end;
    s := s+#13;
  end;
  s := s+ 'hIcon = $' + AIntToHex(WC.hIcon,8)+#13+
       'hBrush = $' + AIntToHex(WC.hbrBackground,8)+#13+
       'MenuName = ' + string(WC.lpszMenuName);
  result := s;
end;

var
  cn: string = '';

function FindOtherWndProc(hWindow: HWND; lData: LPARAM):BOOL; stdcall;
var
  c: array[0..100] of Char;
begin
  GetClassName(hWindow,c,100);
  if string(c) = cn then begin
    PInteger(LData)^ := hWindow;
    result := false;
  end else begin
    PInteger(LData)^ := 0;
    result := true;
  end;
end;

procedure FindOtherInstance(classname: string);
var
  FindWnd: HWND;
begin
  cn := classname;
  EnumWindows(@FindOtherWndProc,LPARAM(@FindWnd));
  if FindWnd <> 0 then begin
    MessageBox(0, 'このアプリケーションは既に起動されています',
                 'おしらせ',MB_ICONINFORMATION or MB_OK);
    ShowWindow(FindWnd,SW_RESTORE); 
    SetForegroundWindow(FindWnd);
    Halt(0);
  end;
end;

//
//--------------- utility functions -------------------------------
//
function wsprintf1; external 'user32.dll' name 'wsprintfA';
function wsprintf2; external 'user32.dll' name 'wsprintfA';
function wsprintf3; external 'user32.dll' name 'wsprintfA';
function wsprintf4; external 'user32.dll' name 'wsprintfA';

function AIntToStr(value: integer):string;
var
  i: integer;
  pBuf: PChar;
begin
  GetMem(pBuf,20);
  i := wsprintf1(pBuf,'%d',value);
  SetString(result,pBuf,i);
  FreeMem(pBuf);
end;

function AIntToHex(value: Integer; digits: Integer): string;
var
  i: integer;
  s: string;
  pBuf: PChar;
begin
  GetMem(pBuf,20);
  i := wsprintf1(pBuf,'%d',digits);
  SetString(s,pBuf,i);
  s := '%.'+s+'X';
  i := wsprintf1(pBuf,PChar(s),value);
  SetString(result,pBuf,i);
  FreeMem(pBuf);
end;

function clrBtnFace: COLORREF;
begin
  result := GetSysColor(COLOR_BTNFACE);
end;

function clrWindow: COLORREF;
begin
  result := GetSysColor(COLOR_WINDOW);
end;

function clrGrayText: COLORREF;
begin
  result := GetSysColor(COLOR_GRAYTEXT);
end;

function SetDim(x,y,width,height: Integer):TRect;
begin
  SetRect(result,x,y,width,height);
end;

function DoChooseFont(hOwner: HWND;var ALogFont: TLogFont; Flag: DWORD;
                      var Color: COLORREF): Boolean;
var
  cf: TChooseFont;
begin
  FillChar(cf,SizeOf(cf),0);
  with cf do begin
    lStructSize := SizeOf(cf);
    hWndOwner := hOwner;
    lpLogFont := @ALogFont;
    if Flag = 0 then
      Flags := CF_BOTH or CF_EFFECTS
    else
      Flags := Flag;
    rgbColors := Color;
    if ALogFont.lfFaceName[0]<>#0 then Flags := Flags or CF_INITTOLOGFONTSTRUCT;
  end;
  if ChooseFont(cf) then begin
    result := true;
    Color := cf.rgbColors;
  end else result := false;
end;

procedure DrawBitmap(DC:HDC;hBit:HBITMAP;x,y:integer);
var
  memDC: HDC;
  bm: TBitmap;
begin
  GetObject(hBit,SizeOf(bm),@bm);
  memDC := CreateCompatibleDC(DC);
  SelectObject(memDC, hBit);
  BitBlt(DC,x,y,bm.bmWidth,bm.bmHeight,memDC,0,0,SRCCOPY);
  DeleteDC(memDC);
end;

end.