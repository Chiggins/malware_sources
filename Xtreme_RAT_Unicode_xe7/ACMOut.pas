unit ACMOut;

interface

uses
  Windows, Messages, Classes, Sysutils, ACMConvertor, MMSystem, MSACM;

type
  EACMOut = class(Exception);
  TACMOut = class(TComponent)
  private
    { Private declarations }
    FActive                   : Boolean;
    FNumBuffersLeft           : Byte;
    FBackBufferList           : TList;
    FNumBuffers               : Byte;
    FBufferList               : TList;
    FFormat                   : TACMWaveFormat;
    FOnBufferPlayed           : TNotifyEvent;
    FWaveOutHandle            : HWaveOut;
    FWindowHandle             : HWnd;
  protected
    { Protected declarations }
    function  NewHeader : PWaveHDR;
    procedure DisposeHeader(Header : PWaveHDR);
    procedure DoWaveDone(Header : PWaveHdr);
    procedure WndProc(var Message : TMessage);
  public
    { Public declarations }
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;

    procedure Close;
    procedure Open(aFormat : TACMWaveFormat);
    procedure Play(var Buffer; Size : Integer);
    procedure RaiseException(const aMessage : String; Result : Integer);

    property Active           : Boolean
      read FActive;
    property Format           : TACMWaveFormat
      read FFormat;
    property WindowHandle     : HWnd
      read FWindowHandle;

  published
    { Published declarations }
    property NumBuffers      : Byte
      read FNumBuffers
      write FNumBuffers;
    property OnBufferPlayed   : TNotifyEvent
      read FOnBufferPlayed
      write FOnBufferPlayed;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Sound', [TACMOut]);
end;

{ TACMOut }

procedure TACMOut.Close;
var
  X                           : Integer;
begin
  if not Active then exit;
  FActive := False;
  WaveOutReset(FWaveOutHandle);
  WaveOutClose(FWaveOutHandle);
  FBackBufferList.Clear;
  FWaveOutHandle := 0;
  For X:=FBufferList.Count-1 downto 0 do DisposeHeader(PWaveHDR(FBufferList[X]));
end;

constructor TACMOut.Create(AOwner: TComponent);
begin
  inherited;
  FBufferList := TList.Create;
  FBackBufferList := TList.Create;
  FActive := False;
  FWindowHandle := AllocateHWND(WndProc);
  FWaveOutHandle := 0;
  FNumBuffers := 4;

end;

destructor TACMOut.Destroy;
begin
  if Active then Close;
  FBufferList.Free;
  DeAllocateHWND(FWindowHandle);
  FBackBufferList.Free;
  inherited;
end;

procedure TACMOut.DisposeHeader(Header: PWaveHDR);
var
  X                           : Integer;
begin
  X := FBufferList.IndexOf(Header);
  if X < 0 then exit;
  Freemem(header.lpData);
  Freemem(header);
  FBufferList.Delete(X);
end;

procedure TACMOut.DoWaveDone(Header : PWaveHdr);
var
  Res                         : Integer;
begin
  if not Active then exit;
  Res := WaveOutUnPrepareHeader(FWaveOutHandle, Header, SizeOf(TWaveHDR));
  if Res <> 0 then RaiseException('WaveOut-UnprepareHeader',Res);
  DisposeHeader(Header);
  if Assigned(FOnBufferPlayed) then FOnBufferPlayed(Self);
end;

function TACMOut.NewHeader: PWaveHDR;
begin
  GetMem(Result, SizeOf(TWaveHDR));
  FBufferList.Add(Result);
end;

procedure TACMOut.Open(aFormat: TACMWaveFormat);
var
  Res                         : Integer;
begin
  if Active then exit;
  FNumBuffersLeft := FNumBuffers;
  FFormat := aFormat;
  Res := WaveOutOpen(@FWaveOutHandle,0,@FFormat.Format,WindowHandle,0,CALLBACK_WINDOW or WAVE_MAPPED);
  if Res <> 0 then RaiseException('WaveOutOpen',Res);
  FActive := True;
end;

procedure TACMOut.Play(var Buffer; Size: Integer);
var
  TempHeader                  : PWaveHdr;
  Data                        : Pointer;
  Res                         : Integer;
  X                           : Integer;

  procedure PlayHeader(Header : PWaveHDR);
  begin
    Res := WaveOutPrepareHeader(FWaveOutHandle,Header,SizeOf(TWaveHDR));
    if Res <> 0 then RaiseException('WaveOut-PrepareHeader',Res);

    Res := WaveOutWrite(FWaveOutHandle, Header, SizeOf(TWaveHDR));
    if Res <> 0 then RaiseException('WaveOut-Write',Res);
  end;

begin
  if Size = 0 then exit;
  if not active then exit;
  TempHeader := NewHeader;
  GetMem(Data, Size);
  Move(Buffer,Data^,Size);
  with TempHeader^ do begin
    lpData := Data;
    dwBufferLength := Size;
    dwBytesRecorded := Size;
    dwUser := 0;
    dwFlags := 0;
    dwLoops := 0;
  end;

  if FNumBuffersLeft > 0 then begin
    FBackBufferList.Add(TempHeader);
    Dec(FNumBuffersLeft);
  end else begin
    for X:=0 to FBackBufferList.Count-1 do
      PlayHeader(PWaveHDR(FBackBufferList[X]));
    FBackBufferList.Clear;
    PlayHeader(TempHeader);
  end;
end;

procedure TACMOut.RaiseException(const aMessage: String; Result: Integer);
begin
end;

procedure TACMOut.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    MM_WOM_DONE : DoWaveDone(PWaveHDR(Message.LParam));
  end;
end;

end.
