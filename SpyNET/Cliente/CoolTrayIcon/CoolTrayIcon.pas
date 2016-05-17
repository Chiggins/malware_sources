{*****************************************************************}
{ This is a component for placing icons in the notification area  }
{ of the Windows taskbar (aka. the traybar).                      }
{                                                                 }
{ The component is freeware. Feel free to use and improve it.     }
{ I would be pleased to hear what you think.                      }
{                                                                 }
{ Troels Jakobsen - troels.jakobsen@gmail.com                     }
{ Copyright (c) 2006                                              }
{                                                                 }
{ Portions by Jouni Airaksinen - mintus@codefield.com             }
{*****************************************************************}

unit CoolTrayIcon;

{$T-}  // Use untyped pointers as we override TNotifyIconData with TNotifyIconDataEx

{$IFDEF VER80}  {$DEFINE DELPHI_1} {$ENDIF}
{$IFDEF VER90}  {$DEFINE DELPHI_2} {$ENDIF}
{$IFDEF VER100} {$DEFINE DELPHI_3} {$ENDIF}
{$IFDEF VER120} {$DEFINE DELPHI_4} {$ENDIF}
{$IFDEF VER130} {$DEFINE DELPHI_5} {$ENDIF}
{$IFDEF VER93}  {$DEFINE BCB_1}    {$ENDIF}
{$IFDEF VER110} {$DEFINE BCB_3}    {$ENDIF}
{$IFDEF VER125} {$DEFINE BCB_4}    {$ENDIF}
{$IFDEF VER135} {$DEFINE BCB_5}    {$ENDIF}

{ Some methods have moved to the Classes unit in D6 and are thus deprecated.
  Using the following compiler directives we handle that situation. }
{$DEFINE DELPHI_6_UP}
{$IFDEF DELPHI_1} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_2} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_3} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_4} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF DELPHI_5} {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_1}    {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_3}    {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_4}    {$UNDEF DELPHI_6_UP} {$ENDIF}
{$IFDEF BCB_5}    {$UNDEF DELPHI_6_UP} {$ENDIF}

{ The TCustomImageList class only exists from D4, so we need special handling
  for D2 and D3. We define another compiler directive for this. }
{$DEFINE DELPHI_4_UP}
{$IFDEF DELPHI_1} {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF DELPHI_2} {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF DELPHI_3} {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF BCB_1}    {$UNDEF DELPHI_4_UP} {$ENDIF}
{$IFDEF BCB_3}    {$UNDEF DELPHI_4_UP} {$ENDIF}

{ I tried to hack around the problem that in some versions of NT4 the tray icon
  will not display properly upon logging off, then logging on. It appears to be
  a VCL problem. The solution is probably to substitute Delphi's AllocateHWnd
  method, but I haven't gotten around to experimenting with that.
  For now, leave WINNT_SERVICE_HACK undefined (no special NT handling). }
{$UNDEF WINNT_SERVICE_HACK}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Menus, ShellApi, ExtCtrls, SimpleTimer {$IFDEF DELPHI_4_UP}, ImgList{$ENDIF};

const
  // User-defined message sent by the trayicon
  WM_TRAYNOTIFY = WM_USER + 1024;

type
  TTimeoutOrVersion = record
    case Integer of          // 0: Before Win2000; 1: Win2000 and up
      0: (uTimeout: UINT);
      1: (uVersion: UINT);   // Only used when sending a NIM_SETVERSION message
  end;

  { You can use the TNotifyIconData record structure defined in shellapi.pas.
    However, WinME, Win2000, and WinXP have expanded this structure, so in
    order to implement their new features we define a similar structure,
    TNotifyIconDataEx. }
  { The old TNotifyIconData record contains a field called Wnd in Delphi
    and hWnd in C++ Builder. The compiler directive DFS_CPPB_3_UP was used
    to distinguish between the two situations, but is no longer necessary
    when we define our own record, TNotifyIconDataEx. }
  TNotifyIconDataEx = record
    cbSize: DWORD;
    hWnd: HWND;
    uID: UINT;
    uFlags: UINT;
    uCallbackMessage: UINT;
    hIcon: HICON;
    szTip: array[0..127] of AnsiChar;  // Previously 64 chars, now 128
    dwState: DWORD;
    dwStateMask: DWORD;
    szInfo: array[0..255] of AnsiChar;
    TimeoutOrVersion: TTimeoutOrVersion;
    szInfoTitle: array[0..63] of AnsiChar;
    dwInfoFlags: DWORD;
{$IFDEF _WIN32_IE_600}
    guidItem: TGUID;  // Reserved for WinXP; define _WIN32_IE_600 if needed
{$ENDIF}
  end;

  TBalloonHintIcon = (bitNone, bitInfo, bitWarning, bitError, bitCustom);
  TBalloonHintTimeOut = 10..60;   // Windows defines 10-60 secs. as min-max
  TBehavior = (bhWin95, bhWin2000);
  THintString = AnsiString;       // 128 bytes, last char should be #0

  TCycleEvent = procedure(Sender: TObject; NextIndex: Integer) of object;
  TStartupEvent = procedure(Sender: TObject; var ShowMainForm: Boolean) of object;

  TCoolTrayIcon = class(TComponent)
  private
    FEnabled: Boolean;
    FIcon: TIcon;
    FIconID: Cardinal;
    FIconVisible: Boolean;
    FHint: THintString;
    FShowHint: Boolean;
    FPopupMenu: TPopupMenu;
    FLeftPopup: Boolean;
    FOnClick,
    FOnDblClick: TNotifyEvent;
    FOnCycle: TCycleEvent;
    FOnStartup: TStartupEvent;
    FOnMouseDown,
    FOnMouseUp: TMouseEvent;
    FOnMouseMove: TMouseMoveEvent;
    FOnMouseEnter: TNotifyEvent;
    FOnMouseExit: TNotifyEvent;
    FOnMinimizeToTray: TNotifyEvent;
    FOnBalloonHintShow,
    FOnBalloonHintHide,
    FOnBalloonHintTimeout,
    FOnBalloonHintClick: TNotifyEvent;
    FMinimizeToTray: Boolean;
    FClickStart: Boolean;
    FClickReady: Boolean;
    CycleTimer: TSimpleTimer;          // For icon cycling
    ClickTimer: TSimpleTimer;          // For distinguishing click and dbl.click
    ExitTimer: TSimpleTimer;           // For OnMouseExit event
    LastMoveX, LastMoveY: Integer;
    FDidExit: Boolean;
    FWantEnterExitEvents: Boolean;
    FBehavior: TBehavior;
    IsDblClick: Boolean;
    FIconIndex: Integer;               // Current index in imagelist
    FDesignPreview: Boolean;
    SettingPreview: Boolean;           // Internal status flag
    SettingMDIForm: Boolean;           // Internal status flag
{$IFDEF DELPHI_4_UP}
    FIconList: TCustomImageList;
{$ELSE}
    FIconList: TImageList;
{$ENDIF}
    FCycleIcons: Boolean;
    FCycleInterval: Cardinal;
//    OldAppProc, NewAppProc: Pointer;   // Procedure variables
    OldWndProc, NewWndProc: Pointer;   // Procedure variables
//    HasCheckedShowMainFormOnStartup, ShowMainFormOnStartup: Boolean;
    procedure SetDesignPreview(Value: Boolean);
    procedure SetCycleIcons(Value: Boolean);
    procedure SetCycleInterval(Value: Cardinal);
    function InitIcon: Boolean;
    procedure SetIcon(Value: TIcon);
    procedure SetIconVisible(Value: Boolean);
{$IFDEF DELPHI_4_UP}
    procedure SetIconList(Value: TCustomImageList);
{$ELSE}
    procedure SetIconList(Value: TImageList);
{$ENDIF}
    procedure SetIconIndex(Value: Integer);
    procedure SetHint(Value: THintString);
    procedure SetShowHint(Value: Boolean);
    procedure SetWantEnterExitEvents(Value: Boolean);
    procedure SetBehavior(Value: TBehavior);
    procedure IconChanged(Sender: TObject);
{$IFDEF WINNT_SERVICE_HACK}
    function IsWinNT: Boolean;
{$ENDIF}
    // Hook methods
    function HookAppProc(var Msg: TMessage): Boolean;
    procedure HookForm;
    procedure UnhookForm;
    procedure HookFormProc(var Msg: TMessage);
    // SimpleTimer event methods
    procedure ClickTimerProc(Sender: TObject);
    procedure CycleTimerProc(Sender: TObject);
    procedure MouseExitTimerProc(Sender: TObject);
  protected
    IconData: TNotifyIconDataEx;       // Data of the tray icon wnd.
    procedure Loaded; override;
    function LoadDefaultIcon: Boolean; virtual;
    function ShowIcon: Boolean; virtual;
    function HideIcon: Boolean; virtual;
    function ModifyIcon: Boolean; virtual;
    procedure Click; dynamic;
    procedure DblClick; dynamic;
    procedure CycleIcon; dynamic;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); dynamic;
    procedure MouseEnter; dynamic;
    procedure MouseExit; dynamic;
    procedure DoMinimizeToTray; dynamic;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property Handle: HWND read IconData.hWnd;
    property Behavior: TBehavior read FBehavior write SetBehavior default bhWin95;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Refresh: Boolean;
    function ShowBalloonHint(Title, Text: String; IconType: TBalloonHintIcon;
      TimeoutSecs: TBalloonHintTimeOut): Boolean;
    function ShowBalloonHintUnicode(Title, Text: WideString; IconType: TBalloonHintIcon;
      TimeoutSecs: TBalloonHintTimeOut): Boolean;
    function HideBalloonHint: Boolean;
    procedure Popup(X, Y: Integer);
    procedure PopupAtCursor;
    function BitmapToIcon(const Bitmap: TBitmap; const Icon: TIcon;
      MaskColor: TColor): Boolean;
    function GetClientIconPos(X, Y: Integer): TPoint;
    function GetTooltipHandle: HWND;
    function GetBalloonHintHandle: HWND;
    function SetFocus: Boolean;
    //----- SPECIAL: methods that only apply when owner is a form -----
    procedure HideTaskbarIcon;
    procedure ShowTaskbarIcon;
    procedure ShowMainForm;
    procedure HideMainForm;
    //----- END SPECIAL -----
  published
    // Properties:
    property DesignPreview: Boolean read FDesignPreview write SetDesignPreview
      default False;
{$IFDEF DELPHI_4_UP}
    property IconList: TCustomImageList read FIconList write SetIconList;
{$ELSE}
    property IconList: TImageList read FIconList write SetIconList;
{$ENDIF}
    property CycleIcons: Boolean read FCycleIcons write SetCycleIcons
      default False;
    property CycleInterval: Cardinal read FCycleInterval write SetCycleInterval;
    property Enabled: Boolean read FEnabled write FEnabled default True;
    property Hint: THintString read FHint write SetHint;
    property ShowHint: Boolean read FShowHint write SetShowHint default True;
    property Icon: TIcon read FIcon write SetIcon;
    property IconVisible: Boolean read FIconVisible write SetIconVisible
      default False;
    property IconIndex: Integer read FIconIndex write SetIconIndex;
    property PopupMenu: TPopupMenu read FPopupMenu write FPopupMenu;
    property LeftPopup: Boolean read FLeftPopup write FLeftPopup default False;
    property WantEnterExitEvents: Boolean read FWantEnterExitEvents
      write SetWantEnterExitEvents default False;
    //----- SPECIAL: properties that only apply when owner is a form -----
    property MinimizeToTray: Boolean read FMinimizeToTray write FMinimizeToTray
      default False;             // Minimize main form to tray when minimizing?
    //----- END SPECIAL -----
    // Events:
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    property OnDblClick: TNotifyEvent read FOnDblClick write FOnDblClick;
    property OnMouseDown: TMouseEvent read FOnMouseDown write FOnMouseDown;
    property OnMouseUp: TMouseEvent read FOnMouseUp write FOnMouseUp;
    property OnMouseMove: TMouseMoveEvent read FOnMouseMove write FOnMouseMove;
    property OnMouseEnter: TNotifyEvent read FOnMouseEnter write FOnMouseEnter;
    property OnMouseExit: TNotifyEvent read FOnMouseExit write FOnMouseExit;
    property OnCycle: TCycleEvent read FOnCycle write FOnCycle;
    property OnBalloonHintShow: TNotifyEvent read FOnBalloonHintShow
      write FOnBalloonHintShow;
    property OnBalloonHintHide: TNotifyEvent read FOnBalloonHintHide
      write FOnBalloonHintHide;
    property OnBalloonHintTimeout: TNotifyEvent read FOnBalloonHintTimeout
      write FOnBalloonHintTimeout;
    property OnBalloonHintClick: TNotifyEvent read FOnBalloonHintClick
      write FOnBalloonHintClick;
    //----- SPECIAL: events that only apply when owner is a form -----
    property OnMinimizeToTray: TNotifyEvent read FOnMinimizeToTray
      write FOnMinimizeToTray;
    property OnStartup: TStartupEvent read FOnStartup write FOnStartup;
    //----- END SPECIAL -----
  end;


implementation

{$IFDEF DELPHI_4_UP}
uses
  ComCtrls;
{$ENDIF}

const
  // Key select events (Space and Enter)
  NIN_SELECT           = WM_USER + 0;
  NINF_KEY             = 1;
  NIN_KEYSELECT        = NINF_KEY or NIN_SELECT;
  // Events returned by balloon hint
  NIN_BALLOONSHOW      = WM_USER + 2;
  NIN_BALLOONHIDE      = WM_USER + 3;
  NIN_BALLOONTIMEOUT   = WM_USER + 4;
  NIN_BALLOONUSERCLICK = WM_USER + 5;
  // Constants used for balloon hint feature
  NIIF_NONE            = $00000000;
  NIIF_INFO            = $00000001;
  NIIF_WARNING         = $00000002;
  NIIF_ERROR           = $00000003;
  NIIF_USER            = $00000004;
  NIIF_ICON_MASK       = $0000000F;    // Reserved for WinXP
  NIIF_NOSOUND         = $00000010;    // Reserved for WinXP
  // uFlags constants for TNotifyIconDataEx
  NIF_STATE            = $00000008;
  NIF_INFO             = $00000010;
  NIF_GUID             = $00000020;
  // dwMessage constants for Shell_NotifyIcon
  NIM_SETFOCUS         = $00000003;
  NIM_SETVERSION       = $00000004;
  NOTIFYICON_VERSION   = 3;            // Used with the NIM_SETVERSION message
  // Tooltip constants
  TOOLTIPS_CLASS       = 'tooltips_class32';
  TTS_NOPREFIX         = 2;

type
  TTrayIconHandler = class(TObject)
  private
    RefCount: Cardinal;
    FHandle: HWND;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add;
    procedure Remove;
    procedure HandleIconMessage(var Msg: TMessage);
  end;

var
  TrayIconHandler: TTrayIconHandler = nil;
{$IFDEF WINNT_SERVICE_HACK}
  WinNT: Boolean = False;              // For Win NT
  HComCtl32: Cardinal = $7FFFFFFF;     // For Win NT
{$ENDIF}
  WM_TASKBARCREATED: Cardinal;
{$IFDEF DELPHI_4_UP}
  SHELL_VERSION: Integer;
{$ENDIF}

{------------------ TTrayIconHandler ------------------}

constructor TTrayIconHandler.Create;
begin
  inherited Create;
  RefCount := 0;
{$IFDEF DELPHI_6_UP}
  FHandle := Classes.AllocateHWnd(HandleIconMessage);
{$ELSE}
  FHandle := AllocateHWnd(HandleIconMessage);
{$ENDIF}
end;


destructor TTrayIconHandler.Destroy;
begin
{$IFDEF DELPHI_6_UP}
  Classes.DeallocateHWnd(FHandle);     // Free the tray window
{$ELSE}
  DeallocateHWnd(FHandle);             // Free the tray window
{$ENDIF}
  inherited Destroy;
end;


procedure TTrayIconHandler.Add;
begin
  Inc(RefCount);
end;


procedure TTrayIconHandler.Remove;
begin
  if RefCount > 0 then
    Dec(RefCount);
end;


{ HandleIconMessage handles messages that go to the shell notification
  window (tray icon) itself. Most messages are passed through WM_TRAYNOTIFY.
  In these cases we use lParam to get the actual message, eg. WM_MOUSEMOVE.
  The method fires the appropriate event methods like OnClick and OnMouseMove. }

{ The message always goes through the container, TrayIconHandler.
  Msg.wParam contains the ID of the TCoolTrayIcon instance, which we stored
  as the object pointer Self in the TCoolTrayIcon constructor. We therefore
  cast wParam to a TCoolTrayIcon instance. }

procedure TTrayIconHandler.HandleIconMessage(var Msg: TMessage);

  function ShiftState: TShiftState;
  // Return the state of the shift, ctrl, and alt keys
  begin
    Result := [];
    if GetAsyncKeyState(VK_SHIFT) < 0 then
      Include(Result, ssShift);
    if GetAsyncKeyState(VK_CONTROL) < 0 then
      Include(Result, ssCtrl);
    if GetAsyncKeyState(VK_MENU) < 0 then
      Include(Result, ssAlt);
  end;

var
  Pt: TPoint;
  Shift: TShiftState;
  I: Integer;
  M: TMenuItem;
{$IFDEF WINNT_SERVICE_HACK}
  InitComCtl32: procedure;
{$ENDIF}
begin
  if Msg.Msg = WM_TRAYNOTIFY then
  // Take action if a message from the tray icon comes through
  begin
{$WARNINGS OFF}
    with TCoolTrayIcon(Msg.wParam) do  // Cast to a TCoolTrayIcon instance
{$WARNINGS ON}
    begin
      case Msg.lParam of

        WM_MOUSEMOVE:
          if FEnabled then
          begin
            // MouseEnter event
            if FWantEnterExitEvents then
              if FDidExit then
              begin
                MouseEnter;
                FDidExit := False;
              end;
            // MouseMove event
            Shift := ShiftState;
            GetCursorPos(Pt);
            MouseMove(Shift, Pt.x, Pt.y);
            LastMoveX := Pt.x;
            LastMoveY := Pt.y;
          end;

        WM_LBUTTONDOWN:
          if FEnabled then
          begin
            { If we have no OnDblClick event, fire the Click event immediately.
              Otherwise start a timer and wait for a short while to see if user
              clicks again. If he does click again inside this period we have
              a double click in stead of a click. }
            if Assigned(FOnDblClick) then
            begin
              ClickTimer.Interval := GetDoubleClickTime;
              ClickTimer.Enabled := True;
            end;
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Pt);
            MouseDown(mbLeft, Shift, Pt.x, Pt.y);
            FClickStart := True;
            if FLeftPopup then
              if (Assigned(FPopupMenu)) and (FPopupMenu.AutoPopup) then
              begin
                SetForegroundWindow(TrayIconHandler.FHandle);  // So menu closes when used in a DLL
                PopupAtCursor;
              end;
          end;

        WM_RBUTTONDOWN:
          if FEnabled then
          begin
            Shift := ShiftState + [ssRight];
            GetCursorPos(Pt);
            MouseDown(mbRight, Shift, Pt.x, Pt.y);
            if (Assigned(FPopupMenu)) and (FPopupMenu.AutoPopup) then
            begin
              SetForegroundWindow(TrayIconHandler.FHandle);    // So menu closes when used in a DLL
              PopupAtCursor;
            end;
          end;

        WM_MBUTTONDOWN:
          if FEnabled then
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Pt);
            MouseDown(mbMiddle, Shift, Pt.x, Pt.y);
          end;

        WM_LBUTTONUP:
          if FEnabled then
          begin
            Shift := ShiftState + [ssLeft];
            GetCursorPos(Pt);

            if FClickStart then   // Then WM_LBUTTONDOWN was called before
              FClickReady := True;

            if FClickStart and (not ClickTimer.Enabled) then
            begin
              { At this point we know a mousedown occured, and the dblclick timer
                timed out. We have a delayed click. }
              FClickStart := False;
              FClickReady := False;
              Click;              // We have a click
            end;

            FClickStart := False;

            MouseUp(mbLeft, Shift, Pt.x, Pt.y);
          end;

        WM_RBUTTONUP:
          if FBehavior = bhWin95 then
            if FEnabled then
            begin
              Shift := ShiftState + [ssRight];
              GetCursorPos(Pt);
              MouseUp(mbRight, Shift, Pt.x, Pt.y);
            end;

        WM_CONTEXTMENU, NIN_SELECT, NIN_KEYSELECT:
          if FBehavior = bhWin2000 then
            if FEnabled then
            begin
              Shift := ShiftState + [ssRight];
              GetCursorPos(Pt);
              MouseUp(mbRight, Shift, Pt.x, Pt.y);
            end;

        WM_MBUTTONUP:
          if FEnabled then
          begin
            Shift := ShiftState + [ssMiddle];
            GetCursorPos(Pt);
            MouseUp(mbMiddle, Shift, Pt.x, Pt.y);
          end;

        WM_LBUTTONDBLCLK:
          if FEnabled then
          begin
            FClickReady := False;
            IsDblClick := True;
            DblClick;
            { Handle default menu items. But only if LeftPopup is false, or it
              will conflict with the popupmenu when it is called by a click event. }
            M := nil;
            if Assigned(FPopupMenu) then
              if (FPopupMenu.AutoPopup) and (not FLeftPopup) then
                for I := PopupMenu.Items.Count -1 downto 0 do
                begin
                  if PopupMenu.Items[I].Default then
                    M := PopupMenu.Items[I];
                end;
            if M <> nil then
              M.Click;
          end;

        { The tray icon never receives WM_MOUSEWHEEL messages.
        WM_MOUSEWHEEL: ;
        }

        NIN_BALLOONSHOW: begin
          if Assigned(FOnBalloonHintShow) then
            FOnBalloonHintShow(Self);
        end;

        NIN_BALLOONHIDE:
          if Assigned(FOnBalloonHintHide) then
            FOnBalloonHintHide(Self);

        NIN_BALLOONTIMEOUT:
          if Assigned(FOnBalloonHintTimeout) then
            FOnBalloonHintTimeout(Self);

        NIN_BALLOONUSERCLICK:
          if Assigned(FOnBalloonHintClick) then
            FOnBalloonHintClick(Self);

      end;
    end;
  end

  else             // Messages that didn't go through the tray icon
    case Msg.Msg of
      { Windows sends us a WM_QUERYENDSESSION message when it prepares for
        shutdown. Msg.Result must not return 0, or the system will be unable
        to shut down. The same goes for other specific system messages. }
      WM_CLOSE, WM_QUIT, WM_DESTROY, WM_NCDESTROY: begin
        Msg.Result := 1;
      end;
{
      WM_DESTROY:
        if not (csDesigning in ComponentState) then
        begin
          Msg.Result := 0;
          PostQuitMessage(0);
        end;
}
      WM_QUERYENDSESSION, WM_ENDSESSION: begin
        Msg.Result := 1;
      end;

{$IFDEF WINNT_SERVICE_HACK}
      WM_USERCHANGED:
        if WinNT then
        begin
          // Special handling for Win NT: Load/unload common controls library
          if HComCtl32 = 0 then
          begin
            // Load and initialize common controls library
            HComCtl32 := LoadLibrary('comctl32.dll');
            { We load the entire dll. This is probably unnecessary.
              The InitCommonControlsEx method may be more appropriate. }
            InitComCtl32 := GetProcAddress(HComCtl32, 'InitCommonControls');
            InitComCtl32;
          end
          else
          begin
            // Unload common controls library (if it is loaded)
            if HComCtl32 <> $7FFFFFFF then
              FreeLibrary(HComCtl32);
            HComCtl32 := 0;
          end;
          Msg.Result := 1;
        end;
{$ENDIF}

    else      // Handle all other messages with the default handler
      Msg.Result := DefWindowProc(FHandle, Msg.Msg, Msg.wParam, Msg.lParam);
    end;
end;

{---------------- Container management ----------------}

procedure AddTrayIcon;
begin
  if not Assigned(TrayIconHandler) then
    // Create new handler
    TrayIconHandler := TTrayIconHandler.Create;
  TrayIconHandler.Add;
end;


procedure RemoveTrayIcon;
begin
  if Assigned(TrayIconHandler) then
  begin
    TrayIconHandler.Remove;
    if TrayIconHandler.RefCount = 0 then
    begin
      // Destroy handler
      TrayIconHandler.Free;
      TrayIconHandler := nil;
    end;
  end;
end;

{------------- SimpleTimer event methods --------------}

procedure TCoolTrayIcon.ClickTimerProc(Sender: TObject);
begin
  ClickTimer.Enabled := False;
  if (not IsDblClick) then
    if FClickReady then
    begin
      FClickReady := False;
      Click;
    end;
  IsDblClick := False;
end;


procedure TCoolTrayIcon.CycleTimerProc(Sender: TObject);
begin
  if Assigned(FIconList) then
  begin
    FIconList.GetIcon(FIconIndex, FIcon);
//    IconChanged(AOwner);
    CycleIcon;             // Call event method

    if FIconIndex < FIconList.Count-1 then
      SetIconIndex(FIconIndex+1)
    else
      SetIconIndex(0);
  end;
end;


procedure TCoolTrayIcon.MouseExitTimerProc(Sender: TObject);
var
  Pt: TPoint;
begin
  if FDidExit then
    Exit;
  GetCursorPos(Pt);
  if (Pt.x < LastMoveX) or (Pt.y < LastMoveY) or
     (Pt.x > LastMoveX) or (Pt.y > LastMoveY) then
  begin
    FDidExit := True;
    MouseExit;
  end;
end;

{------------------- TCoolTrayIcon --------------------}

constructor TCoolTrayIcon.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  AddTrayIcon;               // Container management
{$WARNINGS OFF}
  FIconID := Cardinal(Self); // Use Self object pointer as ID
{$WARNINGS ON}

  SettingMDIForm := True;
  FEnabled := True;          // Enabled by default
  FShowHint := True;         // Show hint by default
  SettingPreview := False;

  FIcon := TIcon.Create;
  FIcon.OnChange := IconChanged;
  FillChar(IconData, SizeOf(IconData), 0);
  IconData.cbSize := SizeOf(TNotifyIconDataEx);
  { IconData.hWnd points to procedure to receive callback messages from the icon.
    We set it to our TrayIconHandler instance. }
  IconData.hWnd := TrayIconHandler.FHandle;
  // Add an id for the tray icon
  IconData.uId := FIconID;
  // We want icon, message handling, and tooltips by default
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
  // Message to send to IconData.hWnd when event occurs
  IconData.uCallbackMessage := WM_TRAYNOTIFY;

  // Create SimpleTimers for later use
  CycleTimer := TSimpleTimer.Create;
  CycleTimer.OnTimer := CycleTimerProc;
  ClickTimer := TSimpleTimer.Create;
  ClickTimer.OnTimer := ClickTimerProc;
  ExitTimer := TSimpleTimer.CreateEx(20, MouseExitTimerProc);

  FDidExit := True;          // Prevents MouseExit from firing at startup

  SetDesignPreview(FDesignPreview);

  // Set hook(s)
  if not (csDesigning in ComponentState) then
  begin
    { For MinimizeToTray to work, we need to know when the form is minimized
      (happens when either the application or the main form minimizes).
      The straight-forward way is to make TCoolTrayIcon trap the
      Application.OnMinimize event. However, if you also make use of this
      event in the application, the OnMinimize code used by TCoolTrayIcon
      is discarded.
      The solution is to hook into the app.'s message handling (via HookAppProc).
      You can then catch any message that goes through the app. and still use
      the OnMinimize event. }
    Application.HookMainWindow(HookAppProc);
    { You can hook into the main form (or any other window), allowing you to handle
      any message that window processes. This is necessary in order to properly
      handle when the user minimizes the form using the TASKBAR icon. }
    if Owner is TWinControl then
      HookForm;
  end;
end;


destructor TCoolTrayIcon.Destroy;
begin
  try
    SetIconVisible(False);        // Remove the icon from the tray
    SetDesignPreview(False);      // Remove any DesignPreview icon
    CycleTimer.Free;
    ClickTimer.Free;
    ExitTimer.Free;
    try
      if FIcon <> nil then
        FIcon.Free;
    except
      on Exception do
        // Do nothing; the icon seems to be invalid
    end;
  finally
    // It is important to unhook any hooked processes
    if not (csDesigning in ComponentState) then
    begin
      Application.UnhookMainWindow(HookAppProc);
      if Owner is TWinControl then
        UnhookForm;
    end;
    RemoveTrayIcon;               // Container management
    inherited Destroy;
  end
end;


procedure TCoolTrayIcon.Loaded;
{ This method is called when all properties of the component have been
  initialized. The method SetIconVisible must be called here, after the
  tray icon (FIcon) has loaded itself. Otherwise, the tray icon will
  be blank (no icon image).
  Other boolean values must also be set here. }
var
  Show: Boolean;
begin
  inherited Loaded;          // Always call inherited Loaded first

  if Owner is TWinControl then
    if not (csDesigning in ComponentState) then
    begin
      Show := True;
      if Assigned(FOnStartup) then
        FOnStartup(Self, Show);

      if not Show then
      begin
        Application.ShowMainForm := False;
        HideMainForm;
      end;

//      ShowMainFormOnStartup := Show;
    end;

  ModifyIcon;
  SetIconVisible(FIconVisible);
  SetCycleIcons(FCycleIcons);
  SetWantEnterExitEvents(FWantEnterExitEvents);
  SetBehavior(FBehavior);
{$IFDEF WINNT_SERVICE_HACK}
  WinNT := IsWinNT;
{$ENDIF}
end;


function TCoolTrayIcon.LoadDefaultIcon: Boolean;
{ This method is called to determine whether to assign a default icon to
  the component. Descendant classes (like TextTrayIcon) can override the
  method to change this behavior. }
begin
  Result := True;
end;


procedure TCoolTrayIcon.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  // Check if either the imagelist or the popup menu is about to be deleted
  if (AComponent = IconList) and (Operation = opRemove) then
  begin
    FIconList := nil;
    IconList := nil;
  end;
  if (AComponent = PopupMenu) and (Operation = opRemove) then
  begin
    FPopupMenu := nil;
    PopupMenu := nil;
  end;
end;


procedure TCoolTrayIcon.IconChanged(Sender: TObject);
begin
  ModifyIcon;
end;


{ All app. messages pass through HookAppProc. You can override the messages
  by not passing them along to Windows (set Result=True). }

function TCoolTrayIcon.HookAppProc(var Msg: TMessage): Boolean;
var
  Show: Boolean;
//  HideForm: Boolean;
begin
  Result := False;  // Should always be False unless we don't want the default message handling

  case Msg.Msg of

    WM_SIZE:
      // Handle MinimizeToTray by capturing minimize event of application
      if Msg.wParam = SIZE_MINIMIZED then
      begin
        if FMinimizeToTray then
          DoMinimizeToTray;
        { You could insert a call to a custom minimize event here, but it would
          behave exactly like Application.OnMinimize, so I see no need for it. }
      end;

    WM_WINDOWPOSCHANGED: begin
      { Handle MDI forms: MDI children cause the app. to be redisplayed on the
        taskbar. We hide it again. This may cause a quick flicker. }
      if SettingMDIForm then
        if Application.MainForm <> nil then
        begin

          if Application.MainForm.FormStyle = fsMDIForm then
          begin
            Show := True;
            if Assigned(FOnStartup) then
              FOnStartup(Self, Show);
            if not Show then
              HideTaskbarIcon;
          end;

          SettingMDIForm := False;     // So we only do this once
        end;
    end;

    WM_SYSCOMMAND:
      // Handle MinimizeToTray by capturing minimize event of application
      if Msg.wParam = SC_RESTORE then
      begin
        if Application.MainForm.WindowState = wsMinimized then
          Application.MainForm.WindowState := wsNormal;
        Application.MainForm.Visible := True;
      end;

  end;

  // Show the tray icon if the taskbar has been re-created after an Explorer crash
  if Msg.Msg = WM_TASKBARCREATED then
    if FIconVisible then
      ShowIcon;
end;


procedure TCoolTrayIcon.HookForm;
begin
  if (Owner as TWinControl) <> nil then
  begin
    // Hook the parent window
    OldWndProc := Pointer(GetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC));
{$IFDEF DELPHI_6_UP}
    NewWndProc := Classes.MakeObjectInstance(HookFormProc);
{$ELSE}
    NewWndProc := MakeObjectInstance(HookFormProc);
{$ENDIF}
    SetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC, LongInt(NewWndProc));
  end;
end;


procedure TCoolTrayIcon.UnhookForm;
begin
  if ((Owner as TWinControl) <> nil) and (Assigned(OldWndProc)) then
    SetWindowLong((Owner as TWinControl).Handle, GWL_WNDPROC, LongInt(OldWndProc));
  if Assigned(NewWndProc) then
{$IFDEF DELPHI_6_UP}
    Classes.FreeObjectInstance(NewWndProc);
{$ELSE}
    FreeObjectInstance(NewWndProc);
{$ENDIF}
  NewWndProc := nil;
  OldWndProc := nil;
end;

{ All main form messages pass through HookFormProc. You can override the
  messages by not passing them along to Windows (via CallWindowProc).
  You should be careful with the graphical messages, though. }

procedure TCoolTrayIcon.HookFormProc(var Msg: TMessage);

  function DoMinimizeEvents: Boolean;
  begin
    Result := False;
    if FMinimizeToTray then
      if Assigned(FOnMinimizeToTray) then
      begin
        FOnMinimizeToTray(Self);
        DoMinimizeToTray;
        Msg.Result := 1;
        Result := True;
      end;
  end;

begin
  case Msg.Msg of
(*
    WM_PARENTNOTIFY: begin
      if Msg.WParamLo = WM_CREATE then
        if not HasCheckedShowMainFormOnStartup then
        begin
          HasCheckedShowMainFormOnStartup := True;
          if not ShowMainFormOnStartup then
            if Application.MainForm <> nil then
            begin
              Application.ShowMainForm := False;
              HideMainForm;
            end;
        end;
    end;
*)
    WM_SHOWWINDOW: begin
      if (Msg.wParam = 1) and (Msg.lParam = 0) then
      begin
        // Show the taskbar icon (Windows may have shown it already)
//        ShowWindow(Application.Handle, SW_RESTORE);
        // Bring the taskbar icon and the main form to the foreground
        SetForegroundWindow(Application.Handle);
        SetForegroundWindow((Owner as TWinControl).Handle);
      end

      else if (Msg.wParam = 0) and (Msg.lParam = SW_PARENTCLOSING) then
      begin
        // Application is minimizing (or closing), handle MinimizeToTray
        if not Application.Terminated then
          if DoMinimizeEvents then
            Exit;            // Don't pass the message on
      end;

    end;
(*
    WM_WINDOWPOSCHANGING: begin
              HideMainForm;
//      Exit;
    end;
*)
    WM_SYSCOMMAND:
      // Handle MinimizeToTray by capturing minimize event of form
      if Msg.wParam = SC_MINIMIZE then
        if DoMinimizeEvents then
          Exit;              // Don't pass the message on
{
    This condition was intended to solve the "Windows can't shut down" issue.
    Unfortunately, setting FormStyle or BorderStyle recreates the form, which
    means it receives a WM_DESTROY and WM_NCDESTROY message. Since these are
    not passed on the form simply disappears when setting either property.
    Anyway, if these messages need to be handled (?) they should probably
    be handled at application level, rather than form level.

    WM_DESTROY, WM_NCDESTROY: begin
      Msg.Result := 1;
      Exit;
    end;
}
  end;
{
  case Msg.Msg of
    WM_QUERYENDSESSION: begin
      Msg.Result := 1;
    end;
  else
}
    // Pass the message on
    Msg.Result := CallWindowProc(OldWndProc, (Owner as TWinControl).Handle,
                  Msg.Msg, Msg.wParam, Msg.lParam);
{
  end;
}
end;


procedure TCoolTrayIcon.SetIcon(Value: TIcon);
begin
  FIcon.OnChange := nil;
//  FIcon := Value;
  FIcon.Assign(Value);      
  FIcon.OnChange := IconChanged;
  ModifyIcon;
end;


procedure TCoolTrayIcon.SetIconVisible(Value: Boolean);
begin
  if Value then
    ShowIcon
  else
    HideIcon;
end;


procedure TCoolTrayIcon.SetDesignPreview(Value: Boolean);
begin
  FDesignPreview := Value;
  SettingPreview := True;         // Raise flag
  { Assign a default icon if Icon property is empty. This will assign an icon
    to the component when it is created for the very first time. When the user
    assigns another icon it will not be overwritten next time the project loads.
    HOWEVER, if the user has decided explicitly to have no icon a default icon
    will be inserted regardless. I figured this was a tolerable price to pay. }
  if (csDesigning in ComponentState) then
  begin
    if FIcon.Handle = 0 then
      if LoadDefaultIcon then
        FIcon.Handle := LoadIcon(0, IDI_WINLOGO);
    { It is tempting to assign the application's icon (Application.Icon) as a
      default icon. The problem is there's no Application instance at design time.
      Or is there? Yes there is: the Delphi editor! Application.Icon is the icon
      found in delphi32.exe. How to use:
        FIcon.Assign(Application.Icon);
      Seems to work, but I don't recommend it. Why would you want to, anyway? }
    SetIconVisible(Value);
  end;
  SettingPreview := False;        // Clear flag
end;


procedure TCoolTrayIcon.SetCycleIcons(Value: Boolean);
begin
  FCycleIcons := Value;
  if Value then
  begin
    SetIconIndex(0);
    CycleTimer.Interval := FCycleInterval;
    CycleTimer.Enabled := True;
  end
  else
    CycleTimer.Enabled := False;
end;


procedure TCoolTrayIcon.SetCycleInterval(Value: Cardinal);
begin
  if Value <> FCycleInterval then
  begin
    FCycleInterval := Value;
    SetCycleIcons(FCycleIcons);
  end;
end;


{$IFDEF DELPHI_4_UP}
procedure TCoolTrayIcon.SetIconList(Value: TCustomImageList);
{$ELSE}
procedure TCoolTrayIcon.SetIconList(Value: TImageList);
{$ENDIF}
begin
  FIconList := Value;
{
  // Set CycleIcons = false if IconList is nil
  if Value = nil then
    SetCycleIcons(False);
}
  SetIconIndex(0);
end;


procedure TCoolTrayIcon.SetIconIndex(Value: Integer);
begin
  if FIconList <> nil then
  begin
    FIconIndex := Value;
    if Value >= FIconList.Count then
      FIconIndex := FIconList.Count -1;
    FIconList.GetIcon(FIconIndex, FIcon);
  end
  else
    FIconIndex := 0;

  ModifyIcon;
end;


procedure TCoolTrayIcon.SetHint(Value: THintString);
begin
  FHint := Value;
  ModifyIcon;
end;


procedure TCoolTrayIcon.SetShowHint(Value: Boolean);
begin
  FShowHint := Value;
  ModifyIcon;
end;


procedure TCoolTrayIcon.SetWantEnterExitEvents(Value: Boolean);
begin
  FWantEnterExitEvents := Value;
  ExitTimer.Enabled := Value;
end;


procedure TCoolTrayIcon.SetBehavior(Value: TBehavior);
begin
  FBehavior := Value;
  case FBehavior of
    bhWin95:   IconData.TimeoutOrVersion.uVersion := 0;
    bhWin2000: IconData.TimeoutOrVersion.uVersion := NOTIFYICON_VERSION;
  end;
  Shell_NotifyIcon(NIM_SETVERSION, @IconData);
end;


function TCoolTrayIcon.InitIcon: Boolean;
// Set icon and tooltip
var
  ok: Boolean;
begin
  Result := False;
  ok := True;
  if (csDesigning in ComponentState) then
    ok := (SettingPreview or FDesignPreview);

  if ok then
  begin
    try
      IconData.hIcon := FIcon.Handle;
    except
      on EReadError do   // Seems the icon was destroyed
      begin
        IconData.hIcon := 0;
//        Exit;
      end;
    end;
    if (FHint <> '') and (FShowHint) then
    begin
      StrLCopy(IconData.szTip, PChar(String(FHint)), SizeOf(IconData.szTip)-1);
      { StrLCopy must be used since szTip is only 128 bytes. }
      { From IE ver. 5 szTip is 128 chars, before that only 64 chars. I suppose
        I could use GetComCtlVersion to check the version and then truncate
        the string accordingly, but Windows seems to handle this ok by itself. }
      IconData.szTip[SizeOf(IconData.szTip)-1] := #0;
    end
    else
      IconData.szTip := '';
    Result := True;
  end;
end;


function TCoolTrayIcon.ShowIcon: Boolean;
// Add/show the icon on the tray
begin
  Result := False;
  if not SettingPreview then
    FIconVisible := True;
  begin
    if (csDesigning in ComponentState) then
    begin
      if SettingPreview then
        if InitIcon then
          Result := Shell_NotifyIcon(NIM_ADD, @IconData);
    end
    else
      if InitIcon then
        Result := Shell_NotifyIcon(NIM_ADD, @IconData);
  end;
end;


function TCoolTrayIcon.HideIcon: Boolean;
// Remove/hide the icon from the tray
begin
  Result := False;
  if not SettingPreview then
    FIconVisible := False;
  begin
    if (csDesigning in ComponentState) then
    begin
      if SettingPreview then
        if InitIcon then
          Result := Shell_NotifyIcon(NIM_DELETE, @IconData);
    end
    else
    if InitIcon then
      Result := Shell_NotifyIcon(NIM_DELETE, @IconData);
  end;
end;


function TCoolTrayIcon.ModifyIcon: Boolean;
// Change icon or tooltip if icon already placed
begin
  Result := False;
  if InitIcon then
    Result := Shell_NotifyIcon(NIM_MODIFY, @IconData);
end;


function TCoolTrayIcon.ShowBalloonHint(Title, Text: String;
  IconType: TBalloonHintIcon; TimeoutSecs: TBalloonHintTimeOut): Boolean;
// Show balloon hint. Return false if error.
const
  aBalloonIconTypes: array[TBalloonHintIcon] of Byte =
    (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR, NIIF_USER);
begin
  // Remove old balloon hint
  HideBalloonHint;
  // Display new balloon hint
  with IconData do
  begin
    uFlags := uFlags or NIF_INFO;
    StrLCopy(szInfo, PChar(Text), SizeOf(szInfo)-1);
    StrLCopy(szInfoTitle, PChar(Title), SizeOf(szInfoTitle)-1);
    TimeoutOrVersion.uTimeout := TimeoutSecs * 1000;
    dwInfoFlags := aBalloonIconTypes[IconType];
  end;
  Result := ModifyIcon;
  // Remove NIF_INFO before next call to ModifyIcon (or the balloon hint will redisplay itself)
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
end;


function TCoolTrayIcon.ShowBalloonHintUnicode(Title, Text: WideString;
  IconType: TBalloonHintIcon; TimeoutSecs: TBalloonHintTimeOut): Boolean;
// Show balloon hint. Return false if error.
const
  aBalloonIconTypes: array[TBalloonHintIcon] of Byte =
    (NIIF_NONE, NIIF_INFO, NIIF_WARNING, NIIF_ERROR, NIIF_USER);
var
  I: Integer;
begin
  // Remove old balloon hint
  HideBalloonHint;
  // Display new balloon hint
  with IconData do
  begin
    uFlags := uFlags or NIF_INFO;
    FillChar(szInfo, 0, SizeOf(szInfo));
    for I := 0 to SizeOf(szInfo)-1 do
      szInfo[I] := Char(Text[I]);
    szInfo[0] := #1;
    FillChar(szInfoTitle, 0, SizeOf(szInfoTitle));
    for I := 0 to SizeOf(szInfoTitle)-1 do
      szInfoTitle[I] := Char(Title[I]);
    szInfoTitle[0] := #1;
    TimeoutOrVersion.uTimeout := TimeoutSecs * 1000;
    dwInfoFlags := aBalloonIconTypes[IconType];
  end;
  Result := ModifyIcon;
  // Remove NIF_INFO before next call to ModifyIcon (or the balloon hint will redisplay itself)
  IconData.uFlags := NIF_ICON or NIF_MESSAGE or NIF_TIP;
end;


function TCoolTrayIcon.HideBalloonHint: Boolean;
// Hide balloon hint. Return false if error.
begin
  with IconData do
  begin
    uFlags := uFlags or NIF_INFO;
    StrPCopy(szInfo, '');
  end;
  Result := ModifyIcon;
end;


function TCoolTrayIcon.BitmapToIcon(const Bitmap: TBitmap;
  const Icon: TIcon; MaskColor: TColor): Boolean;
{ Render an icon from a 16x16 bitmap. Return false if error.
  MaskColor is a color that will be rendered transparently. Use clNone for
  no transparency. }
var
  BitmapImageList: TImageList;
begin
  BitmapImageList := TImageList.CreateSize(16, 16);
  try
    Result := False;
    BitmapImageList.AddMasked(Bitmap, MaskColor);
    BitmapImageList.GetIcon(0, Icon);
    Result := True;
  finally
    BitmapImageList.Free;
  end;
end;


function TCoolTrayIcon.GetClientIconPos(X, Y: Integer): TPoint;
// Return the cursor position inside the tray icon
const
  IconBorder = 1;
//  IconSize = 16;
var
  H: HWND;
  P: TPoint;
  IconSize: Integer;
begin
{ The CoolTrayIcon.Handle property is not the window handle of the tray icon.
  We can find the window handle via WindowFromPoint when the mouse is over
  the tray icon. (It can probably be found via GetWindowLong as well).

  BTW: The parent of the tray icon is the TASKBAR - not the traybar, which
  contains the tray icons and the clock. The traybar seems to be a canvas,
  not a real window (?). }

  // Get the icon size
  IconSize := GetSystemMetrics(SM_CYCAPTION) - 3;

  P.X := X;
  P.Y := Y;
  H := WindowFromPoint(P);
  { Convert current cursor X,Y coordinates to tray client coordinates.
    Add borders to tray icon size in the calculations. }
  Windows.ScreenToClient(H, P);
  P.X := (P.X mod ((IconBorder*2)+IconSize)) -1;
  P.Y := (P.Y mod ((IconBorder*2)+IconSize)) -1;
  Result := P;
end;


function TCoolTrayIcon.GetTooltipHandle: HWND;
{ All tray icons (but not the clock) share the same tooltip.
  Return the tooltip handle or 0 if error. }
var
  wnd, lTaskBar: HWND;
  pidTaskBar, pidWnd: DWORD;
begin
  // Get the TaskBar handle
  lTaskBar := FindWindowEx(0, 0, 'Shell_TrayWnd', nil);
  // Get the TaskBar Process ID
  GetWindowThreadProcessId(lTaskBar, @pidTaskBar);

  // Enumerate all tooltip windows
  wnd := FindWindowEx(0, 0, TOOLTIPS_CLASS, nil);
  while wnd <> 0 do
  begin
    // Get the tooltip process ID
    GetWindowThreadProcessId(wnd, @pidWnd);
    { Compare the process ID of the taskbar and the tooltip.
      If they are the same we have one of the taskbar tooltips. }
    if pidTaskBar = pidWnd then
      { Get the tooltip style. The tooltip for tray icons does not have the
        TTS_NOPREFIX style. }
      if (GetWindowLong(wnd, GWL_STYLE) and TTS_NOPREFIX) = 0 then
        Break;

    wnd := FindWindowEx(0, wnd, TOOLTIPS_CLASS, nil);
  end;
  Result := wnd;
end;


function TCoolTrayIcon.GetBalloonHintHandle: HWND;
{ All applications share the same balloon hint.
  Return the balloon hint handle or 0 if error. }
var
  wnd, lTaskBar: HWND;
  pidTaskBar, pidWnd: DWORD;
begin
  // Get the TaskBar handle
  lTaskBar := FindWindowEx(0, 0, 'Shell_TrayWnd', nil);
  // Get the TaskBar Process ID
  GetWindowThreadProcessId(lTaskBar, @pidTaskBar);

  // Enumerate all tooltip windows
  wnd := FindWindowEx(0, 0, TOOLTIPS_CLASS, nil);
  while wnd <> 0 do
  begin
    // Get the tooltip process ID
    GetWindowThreadProcessId(wnd, @pidWnd);
    { Compare the process ID of the taskbar and the tooltip.
      If they are the same we have one of the taskbar tooltips. }
    if pidTaskBar = pidWnd then
      // We don't want windows with the TTS_NOPREFIX style. That's the simple tooltip.
      if (GetWindowLong(wnd, GWL_STYLE) and TTS_NOPREFIX) <> 0 then
        Break;
        
    wnd := FindWindowEx(0, wnd, TOOLTIPS_CLASS, nil);
  end;
  Result := wnd;
end;


function TCoolTrayIcon.SetFocus: Boolean;
begin
  Result := Shell_NotifyIcon(NIM_SETFOCUS, @IconData);
end;


function TCoolTrayIcon.Refresh: Boolean;
// Refresh the icon
begin
  Result := ModifyIcon;
end;


procedure TCoolTrayIcon.Popup(X, Y: Integer);
begin
  if Assigned(FPopupMenu) then
  begin
    { Bring the main form (or its modal dialog) to the foreground.
      Do this by calling SetForegroundWindow(Handle);
      We don't use Application.Handle as it will make the taskbar button 
      visible in case the form/application is hidden. }
    SetForegroundWindow(Handle);
    { Win98 (unlike other Windows versions) empties a popup menu before
      closing it. This is a problem when the menu is about to display
      while it already is active (two click-events in succession). The
      menu will flicker annoyingly. Calling ProcessMessages fixes this. }
    Application.ProcessMessages;
    // Now make the menu pop up
    FPopupMenu.PopupComponent := Self;
    FPopupMenu.Popup(X, Y);
    // Remove the popup again in case user deselects it
    if Owner is TWinControl then   // Owner might be of type TService
      // Post an empty message to the owner form so popup menu disappears
      PostMessage((Owner as TWinControl).Handle, WM_NULL, 0, 0)
{
    else
      // Owner is not a form; send the empty message to the app.
      PostMessage(Application.Handle, WM_NULL, 0, 0);
}
  end;
end;


procedure TCoolTrayIcon.PopupAtCursor;
var
  CursorPos: TPoint;
begin
  if GetCursorPos(CursorPos) then
  begin
    Popup(CursorPos.X, CursorPos.Y);
  end;
end;


procedure TCoolTrayIcon.Click;
begin
  if Assigned(FOnClick) then
    FOnClick(Self);
end;


procedure TCoolTrayIcon.DblClick;
begin
  if Assigned(FOnDblClick) then
    FOnDblClick(Self);
end;


procedure TCoolTrayIcon.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseDown) then
    FOnMouseDown(Self, Button, Shift, X, Y);
end;


procedure TCoolTrayIcon.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if Assigned(FOnMouseUp) then
    FOnMouseUp(Self, Button, Shift, X, Y);
end;


procedure TCoolTrayIcon.MouseMove(Shift: TShiftState; X, Y: Integer);
begin
  if Assigned(FOnMouseMove) then
    FOnMouseMove(Self, Shift, X, Y);
end;


procedure TCoolTrayIcon.MouseEnter;
begin
  if Assigned(FOnMouseEnter) then
    FOnMouseEnter(Self);
end;


procedure TCoolTrayIcon.MouseExit;
begin
  if Assigned(FOnMouseExit) then
    FOnMouseExit(Self);
end;


procedure TCoolTrayIcon.CycleIcon;
var
  NextIconIndex: Integer;
begin
  NextIconIndex := 0;
  if FIconList <> nil then
    if FIconIndex < FIconList.Count then
      NextIconIndex := FIconIndex +1;

  if Assigned(FOnCycle) then
    FOnCycle(Self, NextIconIndex);
end;


procedure TCoolTrayIcon.DoMinimizeToTray;
begin
  // Override this method to change automatic tray minimizing behavior
  HideMainForm;
  IconVisible := True;
end;


{$IFDEF WINNT_SERVICE_HACK}
function TCoolTrayIcon.IsWinNT: Boolean;
var
  ovi: TOSVersionInfo;
  rc: Boolean;
begin
  rc := False;
  ovi.dwOSVersionInfoSize := SizeOf(TOSVersionInfo);
  if GetVersionEx(ovi) then
    rc := (ovi.dwPlatformId = VER_PLATFORM_WIN32_NT) and (ovi.dwMajorVersion <= 4);
  Result := rc;
end;
{$ENDIF}


procedure TCoolTrayIcon.HideTaskbarIcon;
begin
  if IsWindowVisible(Application.Handle) then
    ShowWindow(Application.Handle, SW_HIDE);
end;


procedure TCoolTrayIcon.ShowTaskbarIcon;
begin
  if not IsWindowVisible(Application.Handle) then
    ShowWindow(Application.Handle, SW_SHOW);
end;


procedure TCoolTrayIcon.ShowMainForm;
begin
  if Owner is TWinControl then         // Owner might be of type TService
    if Application.MainForm <> nil then
    begin
      // Restore the app, but don't automatically show its taskbar icon
      // Show application's TASKBAR icon (not the tray icon)
//      ShowWindow(Application.Handle, SW_RESTORE);
      Application.Restore;
      // Show the form itself
      if Application.MainForm.WindowState = wsMinimized then
        Application.MainForm.WindowState := wsNormal;    // Override minimized state
      Application.MainForm.Visible := True;
      // Bring the main form (or its modal dialog) to the foreground
      SetForegroundWindow(Application.Handle);
    end;
end;


procedure TCoolTrayIcon.HideMainForm;
begin
  if Owner is TWinControl then         // Owner might be of type TService
    if Application.MainForm <> nil then
    begin
      // Hide the form itself (and thus any child windows)
      Application.MainForm.Visible := False;
      { Hide application's TASKBAR icon (not the tray icon). Do this AFTER
        the main form is hidden, or any child windows will redisplay the
        taskbar icon if they are visible. }
      HideTaskbarIcon;
    end;
end;


initialization
{$IFDEF DELPHI_4_UP}
  // Get shell version
  SHELL_VERSION := GetComCtlVersion;
  // Use the TaskbarCreated message available from Win98/IE4+
  if SHELL_VERSION >= ComCtlVersionIE4 then
{$ENDIF}
    WM_TASKBARCREATED := RegisterWindowMessage('TaskbarCreated');

finalization
  if Assigned(TrayIconHandler) then
  begin
    // Destroy handler
    TrayIconHandler.Free;
    TrayIconHandler := nil;
  end;

end.

