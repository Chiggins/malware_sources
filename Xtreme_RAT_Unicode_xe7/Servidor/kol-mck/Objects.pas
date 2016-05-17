unit objects;

interface
uses KOL, Windows, Messages;

type
  TWndMethod = procedure(var Message: TMessage) of object;

function MakeObjectInstance(Method: TWndMethod): Pointer;
procedure FreeObjectInstance(ObjectInstance: Pointer);
function AllocateHWnd(Method: TWndMethod): HWND;
procedure DeallocateHWnd(Wnd: HWND);
function  IncColor(C: TColor; D: integer): TColor;
procedure AjustBitmap(const M: KOL.PBitmap; S, C: TColor);

implementation

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
    Instances: array[0..100] of TObjectInstance;
  end;

var
  InstBlockList: PInstanceBlock;
  InstBlockCount: integer;
  InstFreeList: PObjectInstance;

{ Standard window procedure }
{ In    ECX = Address of method pointer }
{ Out   EAX = Result }

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

{ Allocate an object instance }

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
  inc(InstBlockCount);
end;

{ Free an object instance }

procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
  if (ObjectInstance <> nil) and (InstBlockCount > 0) then
  begin
    PObjectInstance(ObjectInstance)^.Next := InstFreeList;
    InstFreeList := ObjectInstance;
    Dec(InstBlockCount);
    if InstBlockCount = 0 then begin
       VirtualFree(InstBlockList, 0, MEM_RELEASE);
       InstBlockList := nil;
       ObjectInstance := nil;
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
    lpszClassName: 'KOLFakeUtilWindow');

function AllocateHWnd(Method: TWndMethod): HWND;
var
  TempClass: TWndClass;
  ClassRegistered: Boolean;
begin
  UtilWindowClass.hInstance := HInstance;
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

procedure SplitColor(C: TColor; var r, g, b: integer);
begin
   b := (c and $FF0000) shr 16;
   g := (c and $00FF00) shr 08;
   r := (c and $0000FF) shr 00;
end;

procedure AjustBitmap;
var i, j: integer;
       t: KOL.PBitmap;
       r,
       g,
       b,
      r2,
      g2,
      b2: integer;
       p: PRGBTriple;

 function CalcColor(c1, c2, c3: integer): integer;
 begin
   if c1 = c3 then begin
      Result := c2;
      exit;
   end;

   if c1 = 0 then begin
      Result := 0;
      exit;
   end;

{   Result := 255 * c1 div c3 - c1 * (255 - c1) * (255 - c2) div c3 div (255 - c3);
   exit;}

   Result := c1 * c2 div c3;
   if c2 = 0 then Result := c1 * 150 div 255;
   if Result > 255 then Result := 255;
   if Result <  50 then Result :=  Result + 50;
{   exit;
   a  := trunc(x1 * 3);
   a := c1 * (255 - c1) * c2 * (255 - c2) div c3 div (255 - c3);
   a := 255 * 255 - 4 * a;
   try
      x1 := Trunc((255 - sqrt(a)) / 2);
      x2 := Trunc((255 + sqrt(a)) / 2);
      if x1 > x2 then Result := Trunc(x1)
                 else Result := Trunc(x2);
   except
      Result := 0;
   end;}
 end;

begin
   if s           = c then exit;
   if m.Width   = 0 then exit;
   if m.Height  = 0 then exit;
   t := NewBitmap(m.Width, m.Height);
   m.PixelFormat := pf24bit;
   t.Assign(m);
   SplitColor(Color2RGB(s), r, g, b);
   if r = 0 then r := 1;
   if g = 0 then g := 1;
   if b = 0 then b := 1;
   SplitColor(Color2RGB(c), r2, g2, b2);
   for j := 0 to t.Height - 1 do begin
      p := t.scanline[j];
      for i := 0 to t.Width - 1 do begin
         p.rgbtRed   := CalcColor(p.rgbtRed,   r2, r);
         p.rgbtGreen := CalcColor(p.rgbtGreen, g2, g);
         p.rgbtBlue  := CalcColor(p.rgbtBlue,  b2, b);
         inc(p);
      end;
   end;
   m.Assign(t);
   t.Free;
end;

function IncColor;
var T: TColor;
    P: PRGBTriple;
begin
   T := Color2RGB(C);
   p := @T;
   if D > 0 then begin
      if p.rgbtBlue  < 255 - D then p.rgbtBlue  := p.rgbtBlue  + D else p.rgbtBlue  := 255;
      if p.rgbtRed   < 255 - D then p.rgbtRed   := p.rgbtRed   + D else p.rgbtRed   := 255;
      if p.rgbtGreen < 255 - D then p.rgbtGreen := p.rgbtGreen + D else p.rgbtGreen := 255;
   end else begin
      if p.rgbtBlue  >       D then p.rgbtBlue  := p.rgbtBlue  - D else p.rgbtBlue  := 000;
      if p.rgbtRed   >       D then p.rgbtRed   := p.rgbtRed   - D else p.rgbtRed   := 000;
      if p.rgbtGreen >       D then p.rgbtGreen := p.rgbtGreen - D else p.rgbtGreen := 000;
   end;
   Result := T;
end;

begin
  InstBlockList  := nil;
  InstBlockCount := 0;
  InstFreeList   := nil;
end.
