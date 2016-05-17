unit
  xStreamUnit;

interface

{$WARNINGS OFF}

uses
  Windows;

const
  soFromBeginning = 0;
  soFromCurrent = 1;
  soFromEnd = 2;

type
  Int64Rec = packed record
    case Integer of
      0: (Lo, Hi: Cardinal);
      1: (Cardinals: array [0..1] of Cardinal);
      2: (Words: array [0..3] of Word);
      3: (Bytes: array [0..7] of Byte);
  end;

  TNotifyEvent = procedure(Sender: TObject) of object;

  TSeekOrigin = (soBeginning, soCurrent, soEnd);

  TStream = class(TObject)
  private
    function GetPosition: Int64;
    procedure SetPosition(const Pos: Int64);
    procedure SetSize64(const NewSize: Int64);
  protected
    function GetSize: Int64; virtual;
    procedure SetSize(NewSize: Longint); overload; virtual;
    procedure SetSize(const NewSize: Int64); overload; virtual;
  public
    function Read(var Buffer; Count: Longint): Longint; virtual; abstract;
    function Write(const Buffer; Count: Longint): Longint; virtual; abstract;
    function Seek(Offset: Longint; Origin: Word): Longint; overload; virtual;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; overload; virtual;
    procedure ReadBuffer(var Buffer; Count: Longint);
    procedure WriteBuffer(const Buffer; Count: Longint);
    function CopyFrom(Source: TStream; Count: Int64): Int64;
    property Position: Int64 read GetPosition write SetPosition;
    property Size: Int64 read GetSize write SetSize64;
  end;

  IStreamPersist = interface
    ['{B8CD12A3-267A-11D4-83DA-00C04F60B2DD}']
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToStream(Stream: TStream);
  end;

{ THandleStream class }

  THandleStream = class(TStream)
  protected
    FHandle: Integer;
    procedure SetSize(NewSize: Longint); override;
    procedure SetSize(const NewSize: Int64); override;
  public
    constructor Create(AHandle: Integer);
    function Read(var Buffer; Count: Longint): Longint; override;
    function Write(const Buffer; Count: Longint): Longint; override;
    function Seek(const Offset: Int64; Origin: TSeekOrigin): Int64; override;
    property Handle: Integer read FHandle;
  end;

{ TFileStream class }

  TFileStream = class(THandleStream)
  public
    constructor Create(const FileName: widestring; Mode: Word); overload;
    constructor Create(const FileName: widestring; Mode: Word; Rights: Cardinal); overload;
    destructor Destroy; override;
  end;

{ TCustomMemoryStream abstract class }

  TCustomMemoryStream = class(TStream)
  private
    FMemory: Pointer;
    FSize, FPosition: Longint;
  protected
    procedure SetPointer(Ptr: Pointer; Size: Longint);
  public
    function Read(var Buffer; Count: Longint): Longint; override;
    function Seek(Offset: Longint; Origin: Word): Longint; override;
    procedure SaveToStream(Stream: TStream);
    procedure SaveToFile(const FileName: widestring);
    property Memory: Pointer read FMemory;
  end;

{ TMemoryStream }

  TMemoryStream = class(TCustomMemoryStream)
  private
    FCapacity: Longint;
    procedure SetCapacity(NewCapacity: Longint);
  protected
    function Realloc(var NewCapacity: Longint): Pointer; virtual;
    property Capacity: Longint read FCapacity write SetCapacity;
  public
    destructor Destroy; override;
    procedure Clear;
    procedure LoadFromStream(Stream: TStream);
    procedure LoadFromFile(const FileName: widestring);
    procedure SetSize(NewSize: Longint); override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

function FileSeek(Handle, Offset, Origin: Integer): Integer; overload;
function FileSeek(Handle: Integer; const Offset: Int64; Origin: Integer): Int64; overload;
function FileCreate(const FileName: widestring): Integer; overload;
function FileCreate(const FileName: widestring; Rights: Integer): Integer; overload;

procedure StrToStream(S: TStream; const SS: WideString);
function StreamToStr(S: TStream): WideString;

implementation

const
  fmCreate = $FFFF;
  fmOpenRead = $0000;
  fmOpenWrite = $0001;
  fmOpenReadWrite = $0002;
  fmShareCompat = $0000;
  fmShareExclusive = $0010;
  fmShareDenyWrite = $0020;
  fmShareDenyRead = $0030;
  fmShareDenyNone = $0040;

function StreamToStr(S: TStream): WideString;
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := S.Size;
  SetLength(Result, SizeStr div 2);
  S.Read(Result[1], SizeStr);
end;

procedure StrToStream(S: TStream; const SS: WideString);
var
  SizeStr: integer;
begin
  S.Position := 0;
  SizeStr := Length(SS);
  S.Write(SS[1], SizeStr * 2);
end;

function TStream.GetPosition: Int64;
begin
  Result := Seek(0, soCurrent);
end;

procedure TStream.SetPosition(const Pos: Int64);
begin
  Seek(Pos, soBeginning);
end;

function TStream.GetSize: Int64;
var
  Pos: Int64;
begin
  Pos := Seek(0, soCurrent);
  Result := Seek(0, soEnd);
  Seek(Pos, soBeginning);
end;

procedure TStream.SetSize(NewSize: Longint);
begin
  // default = do nothing  (read-only streams, etc)
  // descendents should implement this method to call the Int64 sibling
end;

procedure TStream.SetSize64(const NewSize: Int64);
begin
  SetSize(NewSize);
end;

procedure TStream.SetSize(const NewSize: Int64);
begin
  SetSize(Longint(NewSize));
end;

function TStream.Seek(Offset: Longint; Origin: Word): Longint;
type
  TSeek64 = function (const Offset: Int64; Origin: TSeekOrigin): Int64 of object;
var
  Impl: TSeek64;
  Base: TSeek64;
  ClassTStream: TClass;
begin
  Impl := Seek;
  ClassTStream := Self.ClassType;
  while (ClassTStream <> nil) and (ClassTStream <> TStream) do
    ClassTStream := ClassTStream.ClassParent;
  Base := TStream(@ClassTStream).Seek;
  Result := Seek(Int64(Offset), TSeekOrigin(Origin));
end;

function TStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := Seek(Longint(Offset), Ord(Origin));
end;

procedure TStream.ReadBuffer(var Buffer; Count: Longint);
begin
  Read(Buffer, Count);
end;

procedure TStream.WriteBuffer(const Buffer; Count: Longint);
begin
  Write(Buffer, Count);
end;

function TStream.CopyFrom(Source: TStream; Count: Int64): Int64;
const
  MaxBufSize = $F000;
var
  BufSize, N: Integer;
  Buffer: PChar;
begin
  if Count = 0 then
  begin
    Source.Position := 0;
    Count := Source.Size;
  end;
  Result := Count;
  if Count > MaxBufSize then BufSize := MaxBufSize else BufSize := Count;
  GetMem(Buffer, BufSize);
  try
    while Count <> 0 do
    begin
      if Count > BufSize then N := BufSize else N := Count;
      Source.ReadBuffer(Buffer^, N);
      WriteBuffer(Buffer^, N);
      Dec(Count, N);
    end;
  finally
    FreeMem(Buffer, BufSize);
  end;
end;

{ THandleStream }

function FileRead(Handle: Integer; var Buffer; Count: LongWord): Integer;
begin
  if not ReadFile(THandle(Handle), Buffer, Count, LongWord(Result), nil) then
    Result := -1;
end;

function FileWrite(Handle: Integer; const Buffer; Count: LongWord): Integer;
begin
  if not WriteFile(THandle(Handle), Buffer, Count, LongWord(Result), nil) then
    Result := -1;
end;

constructor THandleStream.Create(AHandle: Integer);
begin
  inherited Create;
  FHandle := AHandle;
end;

function THandleStream.Read(var Buffer; Count: Longint): Longint;
begin
  Result := FileRead(FHandle, Buffer, Count);
  if Result = -1 then Result := 0;
end;

function THandleStream.Write(const Buffer; Count: Longint): Longint;
begin
  Result := FileWrite(FHandle, Buffer, Count);
  if Result = -1 then Result := 0;
end;

function FileSeek(Handle, Offset, Origin: Integer): Integer;
begin
  Result := SetFilePointer(THandle(Handle), Offset, nil, Origin);
end;

function FileSeek(Handle: Integer; const Offset: Int64; Origin: Integer): Int64;
begin
  Result := Offset;
  Int64Rec(Result).Lo := SetFilePointer(THandle(Handle), Int64Rec(Result).Lo,
    @Int64Rec(Result).Hi, Origin);
end;

function THandleStream.Seek(const Offset: Int64; Origin: TSeekOrigin): Int64;
begin
  Result := FileSeek(FHandle, Offset, Ord(Origin));
end;

procedure THandleStream.SetSize(NewSize: Longint);
begin
  SetSize(Int64(NewSize));
end;

function Win32Check(RetVal: BOOL): BOOL;
begin
  Result := RetVal;
end;

procedure THandleStream.SetSize(const NewSize: Int64);
begin
  Seek(NewSize, soBeginning);
  Win32Check(SetEndOfFile(FHandle));
end;

{ TFileStream }

constructor TFileStream.Create(const FileName: widestring; Mode: Word);
begin
  Create(Filename, Mode, 0);
end;

function FileCreate(const FileName: widestring): Integer;
begin
  Result := Integer(CreateFileW(PWChar(FileName), GENERIC_READ or GENERIC_WRITE,
    0, nil, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0));
end;

function FileCreate(const FileName: widestring; Rights: Integer): Integer;
begin
  Result := FileCreate(FileName);
end;

function FileOpen(const FileName: widestring; Mode: LongWord): Integer;
const
  AccessMode: array[0..2] of LongWord = (
    GENERIC_READ,
    GENERIC_WRITE,
    GENERIC_READ or GENERIC_WRITE);
  ShareMode: array[0..4] of LongWord = (
    0,
    0,
    FILE_SHARE_READ,
    FILE_SHARE_WRITE,
    FILE_SHARE_READ or FILE_SHARE_WRITE);
begin
  Result := -1;
  if ((Mode and 3) <= fmOpenReadWrite) and
    ((Mode and $F0) <= fmShareDenyNone) then
    Result := Integer(CreateFileW(PWChar(FileName), AccessMode[Mode and 3],
      ShareMode[(Mode and $F0) shr 4], nil, OPEN_EXISTING,
      FILE_ATTRIBUTE_NORMAL, 0));
end;

constructor TFileStream.Create(const FileName: widestring; Mode: Word; Rights: Cardinal);
begin
  if Mode = fmCreate then
  begin
    inherited Create(FileCreate(FileName, Rights));
  end
  else
  begin
    inherited Create(FileOpen(FileName, Mode));
  end;
end;

procedure FileClose(Handle: Integer);
begin
  CloseHandle(THandle(Handle));
end;

destructor TFileStream.Destroy;
begin
  if FHandle >= 0 then FileClose(FHandle);
  inherited Destroy;
end;


{ TCustomMemoryStream }

procedure TCustomMemoryStream.SetPointer(Ptr: Pointer; Size: Longint);
begin
  FMemory := Ptr;
  FSize := Size;
end;

function TCustomMemoryStream.Read(var Buffer; Count: Longint): Longint;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    Result := FSize - FPosition;
    if Result > 0 then
    begin
      if Result > Count then Result := Count;
      Move(Pointer(Longint(FMemory) + FPosition)^, Buffer, Result);
      Inc(FPosition, Result);
      Exit;
    end;
  end;
  Result := 0;
end;

function TCustomMemoryStream.Seek(Offset: Longint; Origin: Word): Longint;
begin
  case Origin of
    soFromBeginning: FPosition := Offset;
    soFromCurrent: Inc(FPosition, Offset);
    soFromEnd: FPosition := FSize + Offset;
  end;
  Result := FPosition;
end;

procedure TCustomMemoryStream.SaveToStream(Stream: TStream);
begin
  if FSize <> 0 then Stream.WriteBuffer(FMemory^, FSize);
end;

procedure TCustomMemoryStream.SaveToFile(const FileName: widestring);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmCreate);
  try
    SaveToStream(Stream);
  finally
    Stream.Free;
  end;
end;

{ TMemoryStream }

const
  MemoryDelta = $2000; { Must be a power of 2 }

destructor TMemoryStream.Destroy;
begin
  Clear;
  inherited Destroy;
end;

procedure TMemoryStream.Clear;
begin
  SetCapacity(0);
  FSize := 0;
  FPosition := 0;
end;

procedure TMemoryStream.LoadFromStream(Stream: TStream);
var
  Count: Longint;
begin
  Stream.Position := 0;
  Count := Stream.Size;
  SetSize(Count);
  if Count <> 0 then Stream.ReadBuffer(FMemory^, Count);
end;

procedure TMemoryStream.LoadFromFile(const FileName: widestring);
var
  Stream: TStream;
begin
  Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
  try
    LoadFromStream(Stream);
  finally
    Stream.Free;
  end;
end;

procedure TMemoryStream.SetCapacity(NewCapacity: Longint);
begin
  SetPointer(Realloc(NewCapacity), FSize);
  FCapacity := NewCapacity;
end;

procedure TMemoryStream.SetSize(NewSize: Longint);
var
  OldPosition: Longint;
begin
  OldPosition := FPosition;
  SetCapacity(NewSize);
  FSize := NewSize;
  if OldPosition > NewSize then Seek(0, soFromEnd);
end;

function TMemoryStream.Realloc(var NewCapacity: Longint): Pointer;
begin
  if (NewCapacity > 0) and (NewCapacity <> FSize) then
    NewCapacity := (NewCapacity + (MemoryDelta - 1)) and not (MemoryDelta - 1);
  Result := Memory;
  if NewCapacity <> FCapacity then
  begin
    if NewCapacity = 0 then
    begin
      GlobalFreePtr(Memory);
      Result := nil;
    end else
    begin
      if Capacity = 0 then
        Result := GlobalAllocPtr(HeapAllocFlags, NewCapacity)
      else
        Result := GlobalReallocPtr(Memory, NewCapacity, HeapAllocFlags);
    end;
  end;
end;

function TMemoryStream.Write(const Buffer; Count: Longint): Longint;
var
  Pos: Longint;
begin
  if (FPosition >= 0) and (Count >= 0) then
  begin
    Pos := FPosition + Count;
    if Pos > 0 then
    begin
      if Pos > FSize then
      begin
        if Pos > FCapacity then
          SetCapacity(Pos);
        FSize := Pos;
      end;
      System.Move(Buffer, Pointer(Longint(FMemory) + FPosition)^, Count);
      FPosition := Pos;
      Result := Count;
      Exit;
    end;
  end;
  Result := 0;
end;

end.


