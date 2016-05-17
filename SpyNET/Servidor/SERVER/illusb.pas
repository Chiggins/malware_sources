unit illUsb;

interface

uses
  Windows,
  Messages,
  UnitDiversos;

type
  { Event Types }
  TOnUsbChangeEvent = procedure(AObject : TObject; ADriverName: string) of object;

  { USB Class }
  TUsbClass = class(TObject)
  private
    FHandle : HWND;
    FOnUsbRemoval,
    FOnUsbInsertion : TOnUsbChangeEvent;
    procedure WinMethod(var AMessage : TMessage);
    procedure WMDeviceChange(var Msg : TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    property OnUsbInsertion : TOnUsbChangeEvent read FOnUsbInsertion
                                           write FOnUsbInsertion;
    property OnUsbRemoval : TOnUsbChangeEvent read FOnUsbRemoval
                                         write FOnUsbRemoval;
  end;



// -----------------------------------------------------------------------------
implementation

// Device constants
const
  DBT_DEVICEARRIVAL          =  $00008000;
  DBT_DEVICEREMOVECOMPLETE   =  $00008004;
  DBT_DEVTYP_VOLUME          =  $00000002;
 
// Device structs
type
  _DEV_BROADCAST_HDR         =  packed record
     dbch_size:              DWORD;
     dbch_devicetype:        DWORD;
     dbch_reserved:          DWORD;
  end;
  DEV_BROADCAST_HDR          =  _DEV_BROADCAST_HDR;
  TDevBroadcastHeader        =  DEV_BROADCAST_HDR;
  PDevBroadcastHeader        =  ^TDevBroadcastHeader;
 
type
  _DEV_BROADCAST_VOLUME      =  packed record
     dbch_size:              DWORD;
     dbch_devicetype:        DWORD;
     dbch_reserved:          DWORD;
     dbcv_unitmask:          DWORD;
     dbcv_flags:             WORD;
  end;
  DEV_BROADCAST_VOLUME       =  _DEV_BROADCAST_VOLUME;
  TDevBroadcastVolume        =  DEV_BROADCAST_VOLUME;
  PDevBroadcastVolume        =  ^TDevBroadcastVolume;

type
  TWndMethod = procedure(var Message: TMessage) of object;

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

{ Object instance management }

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

function CalcJmpOffset(Src, Dest: Pointer): Longint;
begin
  Result := Longint(Dest) - (Longint(Src) + 5);
end;

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

procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
  if ObjectInstance <> nil then
  begin
    PObjectInstance(ObjectInstance)^.Next := InstFreeList;
    InstFreeList := ObjectInstance;
  end;
end;

procedure DeallocateHWnd(Wnd: HWND);
var
  Instance: Pointer;
begin
  Instance := Pointer(GetWindowLong(Wnd, GWL_WNDPROC));
  DestroyWindow(Wnd);
  if Instance <> @DefWindowProc then FreeObjectInstance(Instance);
end;

constructor TUsbClass.Create;
begin
  inherited Create;
  FHandle := AllocateHWnd(WinMethod);
end;


destructor TUsbClass.Destroy;
begin
  DeallocateHWnd(FHandle);
  inherited Destroy;
end;

procedure TUsbClass.WMDeviceChange(var Msg : TMessage);
var  lpdbhHeader:   PDevBroadcastHeader;
     lpdbvData:     PDevBroadcastVolume;
     dwIndex:       Integer;
     lpszDrive:      String;
begin
  // Get the device notification header
  lpdbhHeader:=PDevBroadcastHeader(Msg.lParam);

  case Msg.WParam of
     DBT_DEVICEARRIVAL       :    {a USB drive was connected}
     begin
        if (lpdbhHeader^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
        begin
           lpdbvData:=PDevBroadcastVolume(Msg.lParam);
           for dwIndex :=0 to 25 do
           begin
              if ((lpdbvData^.dbcv_unitmask shr dwIndex) = 1) then
              begin
                 lpszDrive := Chr(65 + dwIndex) + ':\';
                 break;
              end;
           end;
          if Assigned(FOnUsbInsertion) then FOnUsbInsertion(self, lpszDrive);
        end;
     end;
     DBT_DEVICEREMOVECOMPLETE:    {a USB drive was removed}
     begin
        if (lpdbhHeader^.dbch_devicetype = DBT_DEVTYP_VOLUME) then
        begin
           lpdbvData:=PDevBroadcastVolume(Msg.lParam);
           for dwIndex:=0 to 25 do
           begin
              if ((lpdbvData^.dbcv_unitmask shr dwIndex) = 1) then
              begin
                 lpszDrive := Chr(65 + dwIndex) + ':\';
                 break;
              end;
           end;
           if Assigned(FOnUsbRemoval) then FOnUsbRemoval(self, lpszDrive);
        end;
     end;
  end;
end;

procedure TUsbClass.WinMethod(var AMessage : TMessage);
begin
  if (AMessage.Msg = WM_DEVICECHANGE) then
    WMDeviceChange(AMessage)
  else
    AMessage.Result := DefWindowProc(FHandle,AMessage.Msg,
                                     AMessage.wParam,AMessage.lParam);
end;

end.
