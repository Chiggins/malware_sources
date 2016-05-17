{*****************************************************************}
{ SimpleTimer is a timer class. It has the same timer resolution  }
{ as TTimer, but it is more lightweight because it's derived from }
{ TObject in stead of TComponent. Furthermore, the same handle is }
{ shared between multiple instances of SimpleTimer.               }
{ This makes it ideal for developers who need a timer in their    }
{ own components or applications, but want to keep the resource   }
{ usage minimal.                                                  }
{                                                                 }
{ The unit is freeware. Feel free to use and improve it.          }
{ I would be pleased to hear what you think.                      }
{                                                                 }
{ Troels Jakobsen - troels.jakobsen@gmail.com                     }
{ Copyright (c) 2006                                              }
{*****************************************************************}

unit SimpleTimer;

{ Some methods have moved to the Classes unit in D6 and are thus deprecated.
  Using the following compiler directives we handle that situation. }
{$DEFINE DELPHI_6_UP}
{$IFDEF VER80}  {$UNDEF DELPHI_6_UP} {$ENDIF}    // D1
{$IFDEF VER90}  {$UNDEF DELPHI_6_UP} {$ENDIF}    // D2
{$IFDEF VER100} {$UNDEF DELPHI_6_UP} {$ENDIF}    // D3
{$IFDEF VER120} {$UNDEF DELPHI_6_UP} {$ENDIF}    // D4
{$IFDEF VER130} {$UNDEF DELPHI_6_UP} {$ENDIF}    // D5
{$IFDEF VER93}  {$UNDEF DELPHI_6_UP} {$ENDIF}    // BCB1
{$IFDEF VER110} {$UNDEF DELPHI_6_UP} {$ENDIF}    // BCB3
{$IFDEF VER125} {$UNDEF DELPHI_6_UP} {$ENDIF}    // BCB4
{$IFDEF VER135} {$UNDEF DELPHI_6_UP} {$ENDIF}    // BCB5

interface

uses
  Windows, Classes;

type
  TSimpleTimer = class(TObject)
  private
    FId: UINT;
    FEnabled: Boolean;
    FInterval: Cardinal;
    FAutoDisable: Boolean;
    FTag: Integer;
    FOnTimer: TNotifyEvent;
    procedure SetEnabled(Value: Boolean);
    procedure SetInterval(Value: Cardinal);
    procedure SetOnTimer(Value: TNotifyEvent);
    procedure Initialize(AInterval: Cardinal; AOnTimer: TNotifyEvent);
  protected
    function Start: Boolean;
    function Stop(Disable: Boolean): Boolean;
  public
    constructor Create;
    constructor CreateEx(AInterval: Cardinal; AOnTimer: TNotifyEvent);
    destructor Destroy; override;
    property Enabled: Boolean read FEnabled write SetEnabled;
    property Interval: Cardinal read FInterval write SetInterval default 1000;
    property AutoDisable: Boolean read FAutoDisable write FAutoDisable;
    property Tag: Integer read Ftag write Ftag default 0;
    property OnTimer: TNotifyEvent read FOnTimer write SetOnTimer;
  end;

function GetSimpleTimerCount: Cardinal;
function GetSimpleTimerActiveCount: Cardinal;


implementation

uses
  Messages{$IFNDEF DELPHI_6_UP}, Forms {$ENDIF};

type
  TSimpleTimerHandler = class(TObject)
  private
    RefCount: Cardinal;
    ActiveCount: Cardinal;
    FWindowHandle: HWND;
    procedure WndProc(var Msg: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    procedure AddTimer;
    procedure RemoveTimer;
  end;

var
  SimpleTimerHandler: TSimpleTimerHandler = nil;


function GetSimpleTimerCount: Cardinal;
begin
  if Assigned(SimpleTimerHandler) then
    Result := SimpleTimerHandler.RefCount
  else
    Result := 0;
end;


function GetSimpleTimerActiveCount: Cardinal;
begin
  if Assigned(SimpleTimerHandler) then
    Result := SimpleTimerHandler.ActiveCount
  else
    Result := 0;
end;

{--------------- TSimpleTimerHandler ------------------}

constructor TSimpleTimerHandler.Create;
begin
  inherited Create;
{$IFDEF DELPHI_6_UP}
  FWindowHandle := Classes.AllocateHWnd(WndProc);
{$ELSE}
  FWindowHandle := AllocateHWnd(WndProc);
{$ENDIF}
end;


destructor TSimpleTimerHandler.Destroy;
begin
{$IFDEF DELPHI_6_UP}
  Classes.DeallocateHWnd(FWindowHandle);
{$ELSE}
  DeallocateHWnd(FWindowHandle);
{$ENDIF}
  inherited Destroy;
end;


procedure TSimpleTimerHandler.AddTimer;
begin
  Inc(RefCount);
end;


procedure TSimpleTimerHandler.RemoveTimer;
begin
  if RefCount > 0 then
    Dec(RefCount);
end;


procedure TSimpleTimerHandler.WndProc(var Msg: TMessage);
var
  Timer: TSimpleTimer;
begin
  if Msg.Msg = WM_TIMER then
  begin
{$WARNINGS OFF}
    Timer := TSimpleTimer(Msg.wParam);
{$WARNINGS ON}
    if Timer.FAutoDisable then
      Timer.Stop(True);
    // Call OnTimer event method if assigned
    if Assigned(Timer.FOnTimer) then
      Timer.FOnTimer(Timer);
  end
  else
    Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

{---------------- Container management ----------------}

procedure AddTimer;
begin
  if not Assigned(SimpleTimerHandler) then
    // Create new handler
    SimpleTimerHandler := TSimpleTimerHandler.Create;
  SimpleTimerHandler.AddTimer;
end;


procedure RemoveTimer;
begin
  if Assigned(SimpleTimerHandler) then
  begin
    SimpleTimerHandler.RemoveTimer;
    if SimpleTimerHandler.RefCount = 0 then
    begin
      // Destroy handler
      SimpleTimerHandler.Free;
      SimpleTimerHandler := nil;
    end;
  end;
end;

{------------------- TSimpleTimer ---------------------}

constructor TSimpleTimer.Create;
begin
  inherited Create;
  Initialize(1000, nil);
end;


constructor TSimpleTimer.CreateEx(AInterval: Cardinal; AOnTimer: TNotifyEvent);
begin
  inherited Create;
  Initialize(AInterval, AOnTimer);
end;


destructor TSimpleTimer.Destroy;
begin
  if FEnabled then
    Stop(True);
  RemoveTimer;               // Container management
  inherited Destroy;
end;


procedure TSimpleTimer.Initialize(AInterval: Cardinal; AOnTimer: TNotifyEvent);
begin
{$WARNINGS OFF}
  FId := UINT(Self);         // Use Self as id in call to SetTimer and callback method
{$WARNINGS ON}
  FAutoDisable := False;
  FEnabled := False;
  FInterval := AInterval;
  SetOnTimer(AOnTimer);
  AddTimer;                  // Container management
end;


procedure TSimpleTimer.SetEnabled(Value: Boolean);
begin
  if Value then
    Start
  else
    Stop(True);
end;


procedure TSimpleTimer.SetInterval(Value: Cardinal);
begin
  if Value <> FInterval then
  begin
    FInterval := Value;
    if FEnabled then
      if FInterval <> 0 then
        Start
      else
        Stop(False);
  end;
end;


procedure TSimpleTimer.SetOnTimer(Value: TNotifyEvent);
begin
  FOnTimer := Value;
  if (not Assigned(Value)) and (FEnabled) then
    Stop(False);
end;


function TSimpleTimer.Start: Boolean;
begin
  if FInterval = 0 then
  begin
    Result := False;
    Exit;
  end;
  if FEnabled then
    Stop(True);
//  Result := (SetTimer(SimpleTimerHandler.FWindowHandle, FId, FInterval, @TimerProc) <> 0);
  Result := (SetTimer(SimpleTimerHandler.FWindowHandle, FId, FInterval, nil) <> 0);
  if Result then
  begin
    FEnabled := True;
    Inc(SimpleTimerHandler.ActiveCount);
  end
{  else
    raise EOutOfResources.Create(SNoTimers); }
end;


function TSimpleTimer.Stop(Disable: Boolean): Boolean;
begin
  if Disable then
    FEnabled := False;
  Result := KillTimer(SimpleTimerHandler.FWindowHandle, FId);
  if Result and (SimpleTimerHandler.ActiveCount > 0) then
    Dec(SimpleTimerHandler.ActiveCount);
end;


initialization

finalization
  if Assigned(SimpleTimerHandler) then
  begin
    SimpleTimerHandler.Free;
    SimpleTimerHandler := nil;
  end;

end.

