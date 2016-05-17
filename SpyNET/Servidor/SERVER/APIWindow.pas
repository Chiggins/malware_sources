unit APIWindow;

interface

uses
  Windows,
  Messages,
  UtilFunc,
  UtilClass;

type
TCreateParamsEx = record
  dwExStyle: DWORD;
  lpClassName: PChar;
  lpWindowName: PChar;
  dwStyle: DWORD;
  X, Y, nWidth, nHeight: Integer;
  hWndParent: HWND;
  hMenu: HMENU;
  hInstance: HINST;
  lpParam: Pointer;
end;

//-------------- TAPIWindow -----------------------------------
TOnClassParams = procedure (var WC:TWndClass);
TOnWindowParams = procedure (var CP:TCreateParamsEx; dwStyle: cardinal = WS_VISIBLE or WS_OVERLAPPEDWINDOW);

TAPIWindow = class(TObject)
private
  FHandle: HWND;
  FParent: HWND;
  FClassName: string;
  FColor: COLORREF;
  FOnClassParams: TOnClassParams;
  FOnWindowparams: TOnWindowParams;
  FOnCreate: TNotifyMessage;
  FOnDestroy: TNotifyMessage;
  FOnCommand: TNotifyMessage;
  procedure SetColor(value:COLORREF);
protected
  procedure APIClassParams(var WC:TWndClass); virtual;
  procedure APICreateParams(var CP: TCreateParamsEx; dwStyle: cardinal = WS_VISIBLE or WS_OVERLAPPEDWINDOW); virtual;
public
  constructor Create(hParent:HWND;ClassName:string);virtual;
  destructor Destroy; override;
  procedure DefaultHandler(var Message);override;
  procedure DoCreate(dwStyle: cardinal = WS_VISIBLE or WS_OVERLAPPEDWINDOW); virtual;
  property Handle: HWND read FHandle;
  property Parent: HWND read FParent;
  property Color: COLORREF read FColor write SetColor;
  property OnClassParams: TOnClassParams read FOnClassParams
                                         write FOnClassParams;
  property OnWindowParams: TOnWindowParams read FOnWindowParams
                                           write FOnWindowparams;
  property OnCreate: TNotifyMessage read FOnCreate write FOnCreate;
  property OnDestroy: TNotifyMessage read FOnDestroy write FOnDestroy;
  property OnCommand: TNotifyMessage read FOnCommand write FOnCommand;
end;

//-------------- TAPIWindow2 ----------------------------------
TAPIWindow2 = class(TAPIWindow)
private
  FTrapMessage: TIntegerList;
  FTrapHandler: TIntegerList;
  FNumHandler: integer;
public
  constructor Create(hParent:HWND;ClassName:string);override;
  destructor Destroy; override;
  procedure DefaultHandler(var Message); override;
  procedure Trap(Msg: UINT; Hndlr: TNotifyMessage);
  property NumHandler: integer read FNumHandler;
end;

//-------------- TAPIWindow3 ----------------------------------
TAPIWindow3 = class(TAPIWindow2)
private
  FCursor: HCURSOR;
  function GetWidth: integer;
  procedure SetWidth(value: integer);
  function GetHeight: integer;
  procedure SetHeight(value: integer);
  function GetVisible: Boolean;
  procedure SetVisible(value: Boolean);
  function GetEnable: Boolean;
  procedure SetEnable(value:Boolean);
public
  procedure DefaultHandler(var Message);override;
  property Width: integer read GetWidth write SetWidth;
  property Height: integer read GetHeight write SetHeight;
  property Visible: Boolean  read GetVisible write SetVisible;
  property Enable: Boolean read GetEnable write SetEnable;
  property Cursor: HCURSOR read FCursor write FCursor;
end;

//-------------- TSDIMainWindow ----------------------------------
TMaxMinRestore = (Max,Min,Restore);

TSDIMainWindow = class(TAPIWindow3)
private
  function GetXPos: integer;
  procedure SetXPos(value: integer);
  function GetYPos: integer;
  procedure SetYPos(value: integer);
  function GetTitle: string;
  procedure SetTitle(s: string);
  function GetIcon: HICON;
  procedure SetIcon(value: HICON);
  function GetClientWidth: integer;
  procedure SetClientWidth(value: integer);
  function GetClientHeight: integer;
  procedure SetClientHeight(value: integer);
  function GetState: TMaxMinRestore;
  procedure SetState(value: TMaxMinRestore);
public
  constructor Create(hParent:HWND;ClassName:string);override;
  procedure Center;
  procedure Close;
  property XPos: integer read GetXPos write SetXPos;
  property YPos: integer read GetYPos write SetYPos;
  property Title: string read GetTitle write SetTitle;
  property Icon: HICON read GetIcon write SetIcon;
  property ClientWidth: integer read GetClientWidth write SetClientWidth;
  property ClientHeight: integer read GetClientHeight write SetClientHeight;
  property State: TMaxMinRestore read GetState write SetState;
end;

//---------- TAPIPanel ----------------------------------------------
TEdgeStyle = (esNone,esRaised,esSunken);

TAPIPanel = class(TAPIWindow3)
private
  FOuterEdge: TEdgeStyle;
  FInnerEdge: TEdgeStyle;
  FEdgeWidth: integer;
  function GetDimension: TRect;
  procedure SetDimension(value: TRect);
  function GetXPos: integer;
  procedure SetXPos(value: integer);
  function GetYPos: integer;
  procedure SetYPos(value: integer);
  procedure SetOuterEdge(value: TEdgeStyle);
  procedure SetInnerEdge(value: TEdgeStyle);
  procedure SetEdgeWidth(value: integer);
protected
  procedure APIClassParams(var WC:TWndClass); override;
  procedure APICreateParams(var CP:TCreateParamsEx; dwStyle: cardinal = WS_VISIBLE or WS_OVERLAPPEDWINDOW); override;
public
  procedure DefaultHandler(var Message); override;
  property Dimension : TRect read GetDimension write SetDimension;
  property XPos: integer read GetXPos write SetXPos;
  property YPos: integer read GetYPos write SetYPos;
  property OuterEdge: TEdgeStyle read FOuterEdge write SetOuterEdge;
  property InnerEdge: TEdgeStyle read FInnerEdge write SetInnerEdge;
  property EdgeWidth: integer read FEdgeWidth write SetEdgeWidth;
end;

function CreatePanel(hParent:HWND;x,y,cx,cy:integer):TAPIPanel;

implementation

{---------------------------------------------------------------------
             Custom Window Procedure
----------------------------------------------------------------------}
function CustomWndProc(hWindow: HWND; Msg: UINT; WParam: WPARAM;
                            LParam: LPARAM): LRESULT; stdcall;
var
  WPMsg: TMessage;
  Wnd: TAPIWindow;
  pCS: PCreateStruct;
begin

   Result := 0;

   if Msg = WM_NCCREATE then begin
     pCS := Pointer(LParam);
     SetProp(hWindow,'OBJECT',integer(pCS^.lpCreateParams));
     TAPIWindow(pCS^.lpCreateParams).FHandle := hWindow;
   end;

   WPMsg.Msg := Msg;
   WPMsg.WParam := WParam;
   WPMsg.LParam := LParam;
   WPMsg.Result := 0;

   Wnd := TAPIWindow(GetProp(hWindow,'OBJECT'));

   case Msg of

{------------------  WM_DESTROY  --------------------------------}

     WM_DESTROY: begin
       if Assigned(Wnd) then begin
         Wnd.Dispatch(WPMsg);
         Wnd.Free;
       end;
     end;

{---------  他のメッセージをオブジェクトに Dispatch する ----}
   else begin
       if Assigned(Wnd) then Wnd.Dispatch(WPMsg);
       if WPMsg.Result = 0 then
         Result := DefWindowProc( hWindow, Msg, wParam, lParam )
       else Result := WPMsg.Result;
     end;

   end; // case

end;

//-------------------- TAPIWindow ---------------------------
constructor TAPIWindow.Create(hParent:HWND;ClassName:string);
begin
  FParent := hParent;
  FClassName := ClassName;
  FColor := clrBtnFace;
end;

destructor TAPIWindow.Destroy;
begin
  RemoveProp(FHandle,'OBJECT');
  inherited Destroy;
end;

procedure TAPIWindow.APIClassParams(var WC:TWndClass);
begin
  WC.lpszClassName   := PChar(FClassName);
  WC.lpfnWndProc     := @CustomWndProc;
  WC.style           := CS_VREDRAW or CS_HREDRAW or CS_NOCLOSE; //CS_NOCLOSE block close window
  WC.hInstance       := hInstance;
  WC.hIcon           := LoadIcon(0,IDI_APPLICATION);
  WC.hCursor         := LoadCursor(0,IDC_ARROW);
  WC.hbrBackground   := ( COLOR_WINDOW+1 );
  WC.lpszMenuName    := nil;
  WC.cbClsExtra      := 0;
  WC.cbWndExtra      := 0;
  If Assigned(FOnClassParams) then FOnClassParams(WC);
end;

procedure TAPIWindow.APICreateParams(var CP: TCreateParamsEx; dwStyle: cardinal = WS_VISIBLE or WS_OVERLAPPEDWINDOW);
begin
  CP.dwExStyle           := 0;
  CP.lpClassName         := PChar(FClassName);
  CP.lpWindowName        := PChar(FClassName);
  CP.dwStyle             := dwStyle;
  CP.X                   := 200;
  CP.Y                   := 100;
  CP.nWidth              := 300;
  CP.nHeight             := 200;
  CP.hWndParent          := FParent;
  CP.hMenu               := 0;
  CP.hInstance           := hInstance;
  CP.lpParam             := self;
  If Assigned(FOnWindowParams) then FOnWindowParams(CP);
end;

procedure TAPIWindow.DefaultHandler(var Message);
var
  AMsg:TMessage;
begin

  AMsg := TMessage(Message);

  case AMsg.Msg of

    WM_CREATE: if Assigned(FOnCreate) then OnCreate(AMsg);

    WM_DESTROY: if Assigned(FOnDestroy) then OnDestroy(AMsg);

    WM_COMMAND: if Assigned(FOnCommand) then OnCommand(AMsg);

    WM_ERASEBKGND: AMsg.result := EraseBkGnd(FHandle,FColor,AMsg.WParam);
 
  end; // case

  TMessage(Message).result := AMsg.result;

end;

procedure TAPIWindow.DoCreate(dwStyle: cardinal);
var
  WC: TWndClass;
  CP: TCreateParamsEx;
begin

  APIClassParams(WC);
  RegisterClass(WC);

  APICreateParams(CP, dwStyle);

  CreateWindowEx(CP.dwExStyle,
                 CP.lpClassName,
                 CP.lpWindowName,
                 CP.dwStyle,
                 CP.X,
                 CP.Y,
                 CP.nWidth,
                 CP.nHeight,
                 CP.hWndParent,
                 CP.hMenu,
                 CP.hInstance,
                 CP.lpParam);

  ShowWindow( FHandle, CmdShow );
  UpDateWindow(FHandle);
end;

procedure TAPIWindow.SetColor(value: COLORREF);
begin
  if  FColor = value then Exit;
  FColor := value;
  InvalidateRect(FHandle,nil,true);
end;

//-------------- TAPIWindow2 ----------------------------------
constructor TAPIWindow2.Create(hParent:HWND;ClassName:string);
begin
  inherited Create(hParent,ClassName);
  FTrapMessage := TIntegerList.Create($10,$10);
  FTrapHandler := TIntegerList.Create($10,$10);
end;

destructor TAPIWindow2.Destroy;
begin
  FTrapMessage.Free;
  FTrapHandler.Free;
  inherited Destroy;
end;

procedure TAPIWindow2.DefaultHandler(var Message);
var
  AMsg:TMessage;
  i: integer;
begin

  AMsg := TMessage(Message);

  case AMsg.Msg of

    WM_CREATE:if Assigned(FOnCreate) then OnCreate(AMsg);

    WM_COMMAND:if Assigned(FOnCreate) then OnCommand(AMsg);

    WM_DESTROY:if Assigned(FOnDestroy) then OnDestroy(AMsg);

    WM_ERASEBKGND:AMsg.result := EraseBkGnd(FHandle,FColor,AMsg.WParam);

  else if FNumHandler > 0 then begin
    i := FTrapMessage.Search(integer(AMsg.Msg));
    if i <> -1 then TNotifyMessage(FTrapHandler[i])(AMsg);
    end;

  end; // case

  TMessage(Message).result := AMsg.result;

end;

procedure TAPIWindow2.Trap(Msg: UINT; Hndlr: TNotifyMessage);
begin
  Inc(FNumHandler);
  FTrapMessage[FNumHandler-1] := integer(Msg);
  FTrapHandler[FNumHandler-1] := integer(@Hndlr);
end;

//-------------- TAPIWindow3 ----------------------------------
procedure TAPIWindow3.DefaultHandler(var Message);
var
  AMsg:TMessage;
  i: integer;
begin

  AMsg := TMessage(Message);

  case AMsg.Msg of

    WM_CREATE: if Assigned(FOnCreate) then OnCreate(AMsg);

    WM_DESTROY: if Assigned(FOnDestroy) then OnDestroy(AMsg);

    WM_COMMAND: if Assigned(FOnCommand) then OnCommand(AMsg);

    WM_ERASEBKGND: AMsg.result := EraseBkGnd(FHandle,FColor,AMsg.WParam);

    WM_SETCURSOR : if AMsg.LParamLo = HTCLIENT then begin
        SetCursor(FCursor);
        AMsg.Result := 1;
      end;

  else if FNumHandler > 0 then begin
    i := FTrapMessage.Search(integer(AMsg.Msg));
    if i <> -1 then TNotifyMessage(FTrapHandler[i])(AMsg);
    end;

  end; // case

  TMessage(Message).result := AMsg.result;

end;
function TAPIWindow3.GetWidth: integer;
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  result := r.Right-r.Left+1;
end;

procedure TAPIWindow3.SetWidth(value: integer);
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  ChangeWindowSize(FHandle,value,(r.Bottom-r.Top+1));
end;

function TAPIWindow3.GetHeight: integer;
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  result := r.Bottom-r.Top+1;
end;

procedure TAPIWindow3.SetHeight(value: integer);
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  ChangeWindowSize(FHandle,(r.Right-r.Left+1),value);
end;

function TAPIWindow3.GetVisible: Boolean;
begin
  result := IsWindowVisible(FHandle);
end;

procedure TAPIWindow3.SetVisible(value: Boolean);
begin
  if value then
    ShowWindow(FHandle,SW_SHOW)
  else
    ShowWindow(FHandle,SW_HIDE);
end;

function TAPIWindow3.GetEnable: Boolean;
begin
  result := Boolean(IsWindowEnabled(FHandle));
end;

procedure TAPIWindow3.SetEnable(value: Boolean);
begin
  EnableWindow(FHandle,value);
end;

//-------------- TSDIMainWindow ----------------------------------
constructor TSDIMainWindow.Create(hParent:HWND;ClassName:string);
begin
  inherited Create(hParent,ClassName);
  FCursor := LoadCursor(0,IDC_ARROW);
end;

procedure TSDIMainWindow.Center;
begin
  CenterWindow(FHandle);
end;

procedure TSDIMainWindow.Close;
begin
  DestroyWindow(FHandle);
end;

function TSDIMainWindow.GetXPos: integer;
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  result := r.Left;
end;

procedure TSDIMainWindow.SetXPos(value: integer);
begin
  ChangeWindowPos(FHandle,value,YPos);
end;

function TSDIMainWindow.GetYPos: integer;
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  result := r.Top;
end;

procedure TSDIMainWindow.SetYPos(value: integer);
begin
  ChangeWindowPos(FHandle,XPos,value);
end;

function TSDIMainWindow.GetTitle: string;
var
  s: string;
  len: integer;
begin
  SetLength(s,100);
  len := GetWindowText(FHandle,PChar(s),100);
  SetLength(s,len);
  result := s;
end;

procedure TSDIMainWindow.SetTitle(s: string);
begin
  SetWindowText(FHandle, PChar(s));
end;

function TSDIMainWindow.GetIcon: HICON;
begin
  result := GetClassLong(FHandle,GCL_HICON);
end;

procedure TSDIMainWindow.SetIcon(value: HICON);
begin
  SetClassLong(FHandle,GCL_HICON,value);
end;

function TSDIMainWindow.GetClientWidth: integer;
var
  r: TRect;
begin
  GetClientRect(FHandle,r);
  result := r.Right+1;
end;

procedure TSDIMainWindow.SetClientWidth(value: integer);
begin
  ChangeWindowSize(FHandle,(value+Width-ClientWidth-1),Height);
end;

function TSDIMainWindow.GetClientHeight: integer;
var
  r: TRect;
begin
  GetClientRect(FHandle,r);
  result := r.Bottom+1;
end;

procedure TSDIMainWindow.SetClientHeight(value: integer);
begin
  ChangeWindowSize(FHandle,Width,(value+Height-ClientHeight));
end;

procedure TSDIMainWindow.SetState(value: TMaxMinRestore);
begin
  case value of
    Max: ShowWindow(FHandle,SW_SHOWMAXIMIZED);
    Min: ShowWindow(FHandle,SW_SHOWMINIMIZED);
    Restore: ShowWindow(FHandle,SW_RESTORE);
  end;
end;

function TSDIMainWindow.GetState: TMaxMinRestore;
begin
  if IsZoomed(FHandle) then
    result := Max
  else
    if IsIconic(FHandle) then
      result := Min
    else
      result := Restore;
end;

//--------------- TAPIPanel ----------------------------------------------
function PanelWndProc(hWindow: HWND; Msg: UINT; WParam: WPARAM;
                            LParam: LPARAM): LRESULT; stdcall;
var
  WPMsg: TMessage;
  Wnd: TAPIPanel;
  pCS: PCreateStruct;
begin
   Result := 0;
   
   if Msg = WM_CREATE then begin
     pCS := Pointer(LParam);
     SetProp(hWindow,'OBJECT',integer(pCS^.lpCreateParams));
     TAPIPanel(pCS^.lpCreateParams).FHandle := hWindow;
   end;

   Wnd := TAPIPanel(GetProp(hWindow,'OBJECT'));

   case Msg of

{------------------  WM_PAINT,WMERASEBKGND  ---------------------}

     WM_PAINT,WM_ERASEBKGND: begin
       WPMsg.Msg := Msg;
       WPMsg.WParam := WParam;
       WPMsg.LParam := LParam;
       WPMsg.Result := Result;
       if Assigned(Wnd) then begin
         Wnd.Dispatch(WPMsg);
         if WPMsg.result <> 0 then Result := WPMsg.result;
       end;
     end;

{------------------  WM_DESTROY  --------------------------------}

     WM_DESTROY: begin
       if Assigned(Wnd) then begin
         Wnd.Free;
       end;
     end;

   else Result := DefWindowProc( hWindow, Msg, wParam, lParam );

   end; //case

end;

procedure TAPIPanel.APIClassParams(var WC:TWndClass);
begin
  WC.lpszClassName   := 'APIPanel';
  WC.lpfnWndProc     := @PanelWndProc;
  WC.style           := CS_VREDRAW or CS_HREDRAW or CS_NOCLOSE; //CS_NOCLOSE block close window
  WC.hInstance       := hInstance;
  WC.hIcon           := 0;
  WC.hCursor         := LoadCursor(0,IDC_ARROW);
  WC.hbrBackground   := ( COLOR_BTNFACE+1 );
  WC.lpszMenuName    := nil;
  WC.cbClsExtra      := 0;
  WC.cbWndExtra      := 0;

  FOuterEdge := esRaised;
  FInnerEdge := esNone;
  FEdgeWidth := 2;

  If Assigned(FOnClassParams) then FOnClassParams(WC);
end;

procedure TAPIPanel.APICreateParams(var CP: TCreateParamsEx; dwStyle: cardinal = WS_VISIBLE or WS_OVERLAPPEDWINDOW);
begin
  dwStyle := WS_CHILD or WS_VISIBLE or WS_CLIPSIBLINGS;

  CP.dwExStyle           := WS_EX_CONTROLPARENT;
  CP.lpClassName         := 'APIPanel';
  CP.lpWindowName        := 'APIPanel';
  CP.dwStyle             := dwStyle;
  CP.X                   := 0;
  CP.Y                   := 0;
  CP.nWidth              := 0;
  CP.nHeight             := 0;
  CP.hWndParent          := FParent;
  CP.hMenu               := 0;
  CP.hInstance           := hInstance;
  CP.lpParam             := self;
  If Assigned(FOnWindowParams) then FOnWindowParams(CP);
end;

procedure TAPIPanel.DefaultHandler(var Message);
var
  AMsg:TMessage;
  r: TRect;
  DC: HDC;
  ps: TPaintStruct;
begin
  AMsg := TMessage(message);
  case AMsg.Msg of
    WM_PAINT:begin
      DC := BeginPaint(FHandle,ps);
        GetClientRect(FHandle,r);
        case FOuterEdge of
          esRaised:DrawEdge(DC,r,BDR_RAISEDOUTER or BDR_RAISEDINNER,
                 BF_RECT);
          esSunken:DrawEdge(DC,r,BDR_SUNKENOUTER or BDR_SUNKENINNER,
                 BF_RECT);
        end;
        InflateRect(r,-FEdgeWidth,-FEdgeWidth);
        case FInnerEdge of
          esRaised:DrawEdge(DC,r,BDR_RAISEDOUTER or BDR_RAISEDINNER,
                 BF_RECT);
          esSunken:DrawEdge(DC,r,BDR_SUNKENOUTER or BDR_SUNKENINNER,
                 BF_RECT);
        end;
      EndPaint(FHandle,ps);
    end;
    WM_ERASEBKGND:TMessage(message).Result := EraseBkgnd(FHandle,
                   FColor,AMsg.WParam);
  end; // case
end;

function TAPIPanel.GetDimension: TRect;
begin
  result := SetDim(XPos,YPos,Width,Height);
end;

procedure TAPIPanel.SetDimension(value: TRect);
begin
  MoveWindow(FHandle,value.left, value.top,
                   value.right, value.bottom, true);
end;

function TAPIPanel.GetXPos: integer;
var
  r: TRect;
  p: TPoint;
begin
  GetWindowRect(FHandle,r);
  p.x := r.Left; p.y := r.Top;
  ScreenToClient(FParent,p);
  result := p.x;
end;

procedure TAPIPanel.SetXPos(value: integer);
begin
  ChangeWindowPos(FHandle,value,YPos);
end;

function TAPIPanel.GetYPos: integer;
var
  r: TRect;
  p: TPoint;
begin
  GetWindowRect(FHandle,r);
  p.x := r.Left; p.y := r.Top;
  ScreenToClient(FParent,p);
  result := p.y;
end;

procedure TAPIPanel.SetYPos(value: integer);
begin
  ChangeWindowPos(FHandle,XPos,value);
end;
        
procedure TAPIPanel.SetOuterEdge(value: TEdgeStyle);
begin
  FOuterEdge := value;
  InvalidateRect(FHandle,nil,true);
end;

procedure TAPIPanel.SetInnerEdge(value: TEdgeStyle);
begin
  FInnerEdge := value;
  InvalidateRect(FHandle,nil,true);
end;

procedure TAPIPanel.SetEdgeWidth(value: integer);
begin
  FEdgeWidth := value;
  InvalidateRect(FHandle,nil,true);
end;

function CreatePanel(hParent:HWND;x,y,cx,cy:integer):TAPIPanel;
begin
  result := TAPIPanel.Create(hParent,'');
  result.DoCreate;
  result.Dimension := SetDim(x,y,cx,cy);
end;

end.