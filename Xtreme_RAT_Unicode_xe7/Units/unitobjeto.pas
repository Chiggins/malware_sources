Unit UnitObjeto;

interface

uses
  windows;

const
  WM_USER = $0400;

type
  TMyObject = class (TObject)
  private
    FHandle: THandle;
    hInst: Cardinal;
    ClassName: pWideChar;
    function GetHandle: THandle;
  public
    property Handle: THandle read GetHandle;
    constructor Create(NewClassName: pWideChar; FuncPointer: Pointer = nil);
    destructor Destroy; override;
  end;

procedure FreeAndNil(var Obj);

implementation

constructor TMyObject.Create(NewClassName: pWideChar; FuncPointer: Pointer = nil);
  function WindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
  begin
    Result := DefWindowProc(HWND, Msg, wParam, lParam);
  end;
var
  Msg: TMsg;
  Rect: TRect;
  WNDClass: TWndClassW;
begin
  ClassName := NewClassName;
  with WNDClass do
  begin
    style := 0;
    if FuncPointer = nil then lpfnWndProc := @WindowProc else lpfnWndProc := FuncPointer;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := 0;
    hIcon := 0;
    hCursor := 0;
    hbrBackground := 0;
    lpszMenuName := nil;
    lpszClassName := NewClassName;
  end;

  GetWindowRect(GetDesktopWindow, Rect);
  hInst := GetModuleHandle(nil);
  RegisterClassW(WNDClass);
  FHandle := CreateWindowExW(WS_EX_TOOLWINDOW,
                            WNDClass.lpszClassName,
                            '',
                            WS_VISIBLE or WS_DISABLED or WS_POPUP,
                            Rect.Right,
                            Rect.Bottom,
                            0,
                            0,
                            0,
                            0,
                            hInst,
                            nil);
end;

const
  WM_CLOSE = $0010;

destructor TMyObject.Destroy;
begin
  PostMessage(FHandle, WM_CLOSE, 0, 0);
  UnRegisterClassW(ClassName, hInst);
  FHandle := 0;
  Inherited;
end;

function TMyObject.GetHandle;
begin
  result := FHandle;
end;

procedure FreeAndNil(var Obj);
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;

end.
{
var
  MyObject: TMyObject;
begin
  MyObject := TMyObject.Create;
  SendMessage(MyObject.Handle, WM_MY_MESSAGE, 0, 0);
  FreeAndNil(MyObject);
end.
}