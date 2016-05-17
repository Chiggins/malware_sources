{
  Delphi Thread Unit by Aphex
  http://iamaphex.cjb.net
  unremote@knology.net
}

unit ThreadUnit;

interface

uses
  Windows;

type
  TThread = class
  private
    FHandle: THandle;
    FThreadID: Cardinal;
    FCreateSuspended: Boolean;
    FTerminated: Boolean;
    FSuspended: Boolean;
    FFreeOnTerminate: Boolean;
    FFinished: Boolean;
    FReturnValue: Integer;
    procedure SetSuspended(Value: Boolean);
  protected
    procedure Execute; virtual; abstract;
    property Terminated: Boolean read FTerminated;
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy; override;
    procedure Resume;
    procedure Suspend;
    procedure Terminate;
    property Handle: THandle read FHandle;
    property Suspended: Boolean read FSuspended write SetSuspended;
    property ThreadID: Cardinal read FThreadID;
  end;

implementation

var
  ThreadCount: integer;
  SyncEvent: THandle;
  ThreadLock: TRTLCriticalSection;

procedure InitThreadSynchronization;
begin
  InitializeCriticalSection(ThreadLock);
  SyncEvent := CreateEvent(nil, True, False, '');
end;

procedure DoneThreadSynchronization;
begin
  DeleteCriticalSection(ThreadLock);
  CloseHandle(SyncEvent);
end;

procedure SignalSyncEvent;
begin
  SetEvent(SyncEvent);
end;

procedure AddThread;
begin
  InterlockedIncrement(ThreadCount);
end;

procedure RemoveThread;
begin
  InterlockedDecrement(ThreadCount);
end;

function ThreadProc(Thread: TThread): Integer;
var
  FreeThread: Boolean;
begin
{$IFDEF LINUX}
  if Thread.FSuspended then sem_wait(Thread.FCreateSuspendedSem);
{$ENDIF}
  try
    if not Thread.Terminated then
    try
      Thread.Execute;
    except
    end;
  finally
    FreeThread := Thread.FFreeOnTerminate;
    Result := Thread.FReturnValue;
    Thread.FFinished := True;
    SignalSyncEvent;
    if FreeThread then Thread.Free;
{$IFDEF MSWINDOWS}
    EndThread(Result);
{$ENDIF}
{$IFDEF LINUX}
    // Directly call pthread_exit since EndThread will detach the thread causing
    // the pthread_join in TThread.WaitFor to fail.  Also, make sure the EndThreadProc
    // is called just like EndThread would do. EndThreadProc should not return
    // and call pthread_exit itself.
    if Assigned(EndThreadProc) then
      EndThreadProc(Result);
    pthread_exit(Pointer(Result));
{$ENDIF}
  end;
end;

constructor TThread.Create(CreateSuspended: Boolean);
begin
  inherited Create;
  AddThread;
  FSuspended := CreateSuspended;
  FCreateSuspended := CreateSuspended;
  FHandle := BeginThread(nil, 0, @ThreadProc, Pointer(Self), CREATE_SUSPENDED, FThreadID);
end;

destructor TThread.Destroy;
begin
  if (FThreadID <> 0) and not FFinished then
  begin
    Terminate;
    if FCreateSuspended then Resume;
  end;
  if FHandle <> 0 then CloseHandle(FHandle);
  inherited Destroy;
  RemoveThread;
end;

procedure TThread.SetSuspended(Value: Boolean);
begin
  if Value <> FSuspended then
    if Value then
      Suspend
    else
      Resume;
end;

procedure TThread.Suspend;
var
  OldSuspend: Boolean;
begin
  OldSuspend := FSuspended;
  try
    FSuspended := True;
    SuspendThread(FHandle);
  except
    FSuspended := OldSuspend;
    raise;
  end;
end;

procedure TThread.Resume;
var
  SuspendCount: Integer;
begin
  SuspendCount := ResumeThread(FHandle);
  if SuspendCount = 1 then FSuspended := False;
end;

procedure TThread.Terminate;
begin
  FTerminated := True;
end;

initialization
  InitThreadSynchronization;

finalization
  DoneThreadSynchronization;

end.
