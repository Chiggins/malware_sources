unit ACMIn;

interface

uses
  Windows,
  Messages,
  ListUnit,
  ACMConvertor,
  MMSystem,
  MSACM;

type
  TACMBufferCount = 2..64;
  TBufferFullEvent = procedure(Sender : TObject; Data : Pointer; Size:longint) of object;

  TACMIn = class(TObject)
  private
    FActive                   : Boolean;
    FBufferList               : TList;
    FBufferSize               : DWord;
    FFormat                   : TACMWaveFormat;
    FNumBuffers               : TACMBufferCount;
    FWaveInHandle             : HWaveIn;
    FWindowHandle             : HWnd;
    FOnBufferFull             : TBufferFullEvent;
    procedure DoBufferFull(Header : PWaveHdr);
    procedure SetBufferSize(const Value: DWord);
    procedure SetNumBuffers(const Value: TACMBufferCount);
  protected
    function  NewHeader : PWaveHDR;
    procedure DisposeHeader(Header : PWaveHDR);
    procedure WndProc(Var Message : TMessage);
  public
    constructor Create;
    destructor Destroy; override;

    procedure Open(aFormat : TACMWaveFormat);
    procedure Close;

      property Active         : Boolean
        read FActive;
      property WindowHandle   : HWnd
        read FWindowHandle;
    published
      property BufferSize     : DWord
        read FBufferSize
        write SetBufferSize;
      property NumBuffers     : TACMBufferCount
        read FNumBuffers
        write SetNumBuffers;

      property OnBufferFull   : TBufferFullEvent
        read FOnBufferFull
        write FOnBufferFull;
 end;

function SetRecordingInput(Index: integer): boolean;
function IsRecordingInput(Index: integer): boolean;

implementation

function SetRecordingInput(Index: integer): boolean;
var
  mixer:HMIXER;
  mixerlineid:array [0..255] of integer;
  m_ctrl:array [0..255] of TMIXERCONTROL;
  ctrl_sel:integer;
  caps:TMIXERCAPS;
  line:TMIXERLINE;
  MaxLinecnt:integer;
  i,j,k,err:integer;
  curDest:integer;
  mxc:TMIXERCONTROLDETAILS;
  mxcl:array [0..100] of integer;
  LineID:integer;
  ctrl:TMIXERLINECONTROLS;
begin
  Result := False;
  mixerOpen(@mixer,0,0,0,CALLBACK_WINDOW);
  mixerGetDevCaps(mixer,@caps,sizeof(caps));
  MaxLinecnt := 255;
  line.cbStruct := sizeof(line);
  curDest := -1;
  for i := 0 to maxlinecnt do
  begin
    inc(curDest);
    line.dwDestination:=curDest;
    err := mixerGetLineInfo(mixer, @line, MIXER_GETLINEINFOF_DESTINATION or MIXER_OBJECTF_HMIXER);
    if err <> 0 then break;
    if Pos('Rec', string(line.szname)) <> 0 then
    begin
      line.cbStruct:=sizeof(line);
      line.dwDestination:=curDest;
      mixerGetLineInfo(mixer,@line,MIXER_GETLINEINFOF_DESTINATION or MIXER_OBJECTF_HMIXER);
      mixerlineid[0]:=line.dwLineID;
      LineId:=line.dwLineID;
      line.cbStruct:=sizeof(line);
      line.dwLineID:=LineID;
      mixerGetLineInfo(mixer,@line,MIXER_GETLINEINFOF_LINEID);

      if line.cControls=0 then exit;


      ctrl.cbStruct:=sizeof(ctrl);
      ctrl.cbmxctrl:=sizeof(TMIXERCONTROL);
      ctrl.dwLineID:=LineID;
      ctrl.cControls:=line.cControls;
      ctrl.pamxctrl:=@m_ctrl;



      mixerGetLineControls(mixer,@ctrl,MIXER_GETLINECONTROLSF_ALL);

      for j := 0 to ctrl.cControls-1 do
      begin
        if pos('Rec', m_ctrl[j].szName) <> 0 then ctrl_sel := j;
      end;

      line.dwDestination:=curDest;
      line.dwSource:=Index;
      err:=mixerGetLineInfo(mixer,@line,MIXER_GETLINEINFOF_SOURCE or MIXER_OBJECTF_HMIXER);
      if err<>0 then break;
        for k := 0 to m_ctrl[ctrl_sel].cMultipleItems - 1 do
        begin
          if k = Index then
          begin
            mxcl[k] := 1;
          end
          else
            mxcl[k] := 0;
        end;

        mxc.cbStruct:=sizeof(mxc);
        mxc.dwControlID:=m_ctrl[ctrl_sel].dwControlID;
        MXC.cMultipleItems:=m_ctrl[ctrl_sel].cMultipleItems;
        mxc.cChannels:=1;
        mxc.cbDetails:=sizeof(mxcl);
        mxc.paDetails:=@mxcl;

        if MixerSetControlDetails(mixer,@mxc,0) = 0 then Result := True;
        mixerClose(mixer);
        Exit;

    end;
  end;

end;

function IsRecordingInput(Index: integer): boolean;
var
  mixer:HMIXER;
  mixerlineid:array [0..255] of integer;
  m_ctrl:array [0..255] of TMIXERCONTROL;
  ctrl_sel:integer;
  caps:TMIXERCAPS;
  line:TMIXERLINE;
  MaxLinecnt:integer;
  i,j,k,err:integer;
  curDest:integer;
  mxc:TMIXERCONTROLDETAILS;
  mxcl:array [0..100] of integer;
  LineID:integer;
  ctrl:TMIXERLINECONTROLS;
begin
  Result := False;
  mixerOpen(@mixer,0,0,0,CALLBACK_WINDOW);
  mixerGetDevCaps(mixer,@caps,sizeof(caps));
  MaxLinecnt := 255;
  line.cbStruct := sizeof(line);
  curDest := -1;
  for i := 0 to maxlinecnt do
  begin
    inc(curDest);
    line.dwDestination:=curDest;
    err := mixerGetLineInfo(mixer, @line, MIXER_GETLINEINFOF_DESTINATION or MIXER_OBJECTF_HMIXER);
    if err <> 0 then break;
    if Pos('Rec', string(line.szname)) <> 0 then
    begin
      line.cbStruct:=sizeof(line);
      line.dwDestination:=curDest;
      mixerGetLineInfo(mixer,@line,MIXER_GETLINEINFOF_DESTINATION or MIXER_OBJECTF_HMIXER);
      mixerlineid[0]:=line.dwLineID;
      LineId:=line.dwLineID;
      line.cbStruct:=sizeof(line);
      line.dwLineID:=LineID;
      mixerGetLineInfo(mixer,@line,MIXER_GETLINEINFOF_LINEID);

      if line.cControls=0 then exit;


      ctrl.cbStruct:=sizeof(ctrl);
      ctrl.cbmxctrl:=sizeof(TMIXERCONTROL);
      ctrl.dwLineID:=LineID;
      ctrl.cControls:=line.cControls;
      ctrl.pamxctrl:=@m_ctrl;



      mixerGetLineControls(mixer,@ctrl,MIXER_GETLINECONTROLSF_ALL);

      for j := 0 to ctrl.cControls-1 do
      begin
        if pos('Rec', m_ctrl[j].szName) <> 0 then ctrl_sel := j;
      end;

      line.dwDestination:=curDest;
      line.dwSource:=Index;
      err := mixerGetLineInfo(mixer,@line,MIXER_GETLINEINFOF_SOURCE or MIXER_OBJECTF_HMIXER);
      if err = 0 then Result := True;
      mixerClose(mixer);
      Exit;

    end;
  end;

end;

var
  UtilWindowClass: TWndClass = (
    style: 0;
    lpfnWndProc: @DefWindowProc;
    cbClsExtra: 0;
    cbWndExtra: 0;
    hInstance: 0;
    hIcon: 0;
    hCursor: 0;
    hbrBackground: 0;
    lpszMenuName: nil;
    lpszClassName: 'TPUtilWindow');


const
  InstanceCount = 313;

type
  TWndMethod = procedure(var Message: TMessage) of object;

type
  PObjectInstance = ^TObjectInstance;
  TObjectInstance = packed record
    Code: Byte;
    Offset: Integer;
    case Integer of
      0: (Next: PObjectInstance);
      1: (Method: TWndMethod);
  end;

type
  PInstanceBlock = ^TInstanceBlock;
  TInstanceBlock = packed record
    Next: PInstanceBlock;
    Code: array[1..2] of Byte;
    WndProcPtr: Pointer;
    Instances: array[0..InstanceCount] of TObjectInstance;
  end;

var
  InstBlockList: PInstanceBlock;
  InstFreeList: PObjectInstance;

function StdWndProc(Window: HWND; Message, WParam: Longint;
  LParam: Longint): Longint; stdcall; assembler;
asm
        XOR     EAX,EAX
        PUSH    EAX
        PUSH    LParam
        PUSH    WParam
        PUSH    Message
        MOV     EDX,ESP
        MOV     EAX,[ECX].Longint[4]
        CALL    [ECX].Pointer
        ADD     ESP,12
        POP     EAX
end;

function CalcJmpOffset(Src, Dest: Pointer): Longint;
begin
  Result := Longint(Dest) - (Longint(Src) + 5);
end;

function MakeObjectInstance(Method: TWndMethod): Pointer;
const
  BlockCode: array[1..2] of Byte = (
    $59,       { POP ECX }
    $E9);      { JMP StdWndProc }
  PageSize = 4096;
var
  Block: PInstanceBlock;
  Instance: PObjectInstance;
begin
  if InstFreeList = nil then
  begin
    Block := VirtualAlloc(nil, PageSize, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
    Block^.Next := InstBlockList;
    Move(BlockCode, Block^.Code, SizeOf(BlockCode));
    Block^.WndProcPtr := Pointer(CalcJmpOffset(@Block^.Code[2], @StdWndProc));
    Instance := @Block^.Instances;
    repeat
      Instance^.Code := $E8;  { CALL NEAR PTR Offset }
      Instance^.Offset := CalcJmpOffset(Instance, @Block^.Code);
      Instance^.Next := InstFreeList;
      InstFreeList := Instance;
      Inc(Longint(Instance), SizeOf(TObjectInstance));
    until Longint(Instance) - Longint(Block) >= SizeOf(TInstanceBlock);
    InstBlockList := Block;
  end;
  Result := InstFreeList;
  Instance := InstFreeList;
  InstFreeList := Instance^.Next;
  Instance^.Method := Method;
end;

procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
  if ObjectInstance <> nil then
  begin
    PObjectInstance(ObjectInstance)^.Next := InstFreeList;
    InstFreeList := ObjectInstance;
  end;
end;

function AllocateHWnd(Method: TWndMethod): HWND;
var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin
  UtilWindowClass.hInstance := HInstance;
{$IFDEF PIC}
  UtilWindowClass.lpfnWndProc := @DefWindowProc;
{$ENDIF}
  ClassRegistered := GetClassInfo(HInstance, UtilWindowClass.lpszClassName,
    TempClass);
  if not ClassRegistered or (TempClass.lpfnWndProc <> @DefWindowProc) then
  begin
    if ClassRegistered then
      Windows.UnregisterClass(UtilWindowClass.lpszClassName, HInstance);
    Windows.RegisterClass(UtilWindowClass);
  end;
  Result := CreateWindowEx(WS_EX_TOOLWINDOW, UtilWindowClass.lpszClassName,
    '', WS_POPUP {!0}, 0, 0, 0, 0, 0, 0, HInstance, nil);
  if Assigned(Method) then
    SetWindowLong(Result, GWL_WNDPROC, Longint(MakeObjectInstance(Method)));
end;

procedure DeallocateHWnd(Wnd: HWND);
var
  Instance: Pointer;
begin
  Instance := Pointer(GetWindowLong(Wnd, GWL_WNDPROC));
  DestroyWindow(Wnd);
  if Instance <> @DefWindowProc then FreeObjectInstance(Instance);
end;

constructor TACMIn.Create;
begin
 inherited;
 FBufferList := TList.Create;
 FActive := False;
 FBufferSize := 8192;
 FWaveInHandle := 0;
 FWindowHandle := AllocateHWND(WndProc);
 FNumBuffers := 4;
end;

procedure TACMIn.DoBufferFull(Header : PWaveHdr);
var
   Res                        : Integer;
   BytesRecorded              : Integer;
   Data                       : Pointer;
begin
  if Active then begin
    Res := WaveInUnPrepareHeader(FWaveInHandle,Header,sizeof(TWavehdr));
    if Res <>0  then Exit;

    BytesRecorded:=header.dwBytesRecorded;

    if assigned(FOnBufferFull) then begin
      Getmem(Data, BytesRecorded);
      try
        move(header.lpData^,Data^,BytesRecorded);
        FOnBufferFull(Self, Data, BytesRecorded);
      finally
        Freemem(Data);
      end;
    end;

    header.dwbufferlength:=FBufferSize;
    header.dwBytesRecorded:=0;
    header.dwUser:=0;
    header.dwflags:=0;
    header.dwloops:=0;
    FillMemory(Header.lpData,FBufferSize,0);

    Res := WaveInPrepareHeader(FWaveInHandle,Header,sizeof(TWavehdr));
    if Res <> 0 then Exit;

    Res:=WaveInAddBuffer(FWaveInHandle,Header,sizeof(TWaveHdr));
    if Res <> 0 then Exit;

   end
   else
      DisposeHeader(Header);
end;

procedure TACMIn.Open(aFormat : TACMWaveFormat);
var
  Res                         : Integer;
  J                           : Integer;
begin
  if Active then exit;
  Res := WaveInOpen(@FWaveInHandle,0,@aFormat.Format,FWindowHandle,0,CALLBACK_WINDOW or WAVE_MAPPED);
  if Res <> 0 then Exit;

  for j:= 1 to FNumBuffers do NewHeader;

  Res := WaveInStart(FWaveInHandle);
  if Res <> 0 then Exit;

  FFormat := aFormat;
  FActive := True;
end;

destructor TACMIn.Destroy;
begin
  if Active then Close;
  FBufferList.Free;
  DeAllocateHWND(FWindowHandle);
  inherited;
end;

procedure TACMIn.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    MM_WIM_Data: DoBufferFull(PWaveHDR(Message.LParam));
  end;

end;

procedure TACMIn.Close;
var
  X                           : Integer;
begin
  if not Active then Exit;
  FActive := False;
  WaveInReset(FWaveInHandle);
  WaveInClose(FWaveInHandle);
  FWaveInHandle := 0;
  For X:=FBufferList.Count-1 downto 0 do DisposeHeader(PWaveHDR(FBufferList[X]));
end;

procedure TACMIn.SetBufferSize(const Value: DWord);
begin
  if Active then exit;
  FBufferSize := Value;
end;

function TACMIn.NewHeader: PWaveHDR;
var
  Res                         : Integer;
begin
  Getmem(Result, SizeOf(TWaveHDR));
  FBufferList.Add(Result);
  with Result^ do begin
    Getmem(lpData,FBufferSize);
    dwBufferLength := FBufferSize;
    dwBytesRecorded := 0;
    dwFlags := 0;
    dwLoops := 0;
    Res := WaveInPrepareHeader(FWaveInHandle,Result,sizeof(TWaveHDR));
    if Res <> 0 then Exit;

    Res := WaveInAddBuffer(FWaveInHandle,Result,SizeOf(TWaveHDR));
    if Res <> 0 then Exit;
  end;
end;

procedure TACMIn.SetNumBuffers(const Value: TACMBufferCount);
begin
  if Active then exit;
  FNumBuffers := Value;
end;

procedure TACMIn.DisposeHeader(Header: PWaveHDR);
var
  X                           : Integer;
begin
  X := FBufferList.IndexOf(Header);
  if X < 0 then exit;
  Freemem(header.lpData);
  Freemem(header);
  FBufferList.Delete(X);
end;

end.
