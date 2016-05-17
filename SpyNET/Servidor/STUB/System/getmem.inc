{ *********************************************************************** }
{                                                                         }
{ Delphi Runtime Library                                                  }
{                                                                         }
{ Copyright (c) 1996,2001 Borland Software Corporation                    }
{                                                                         }
{ *********************************************************************** }

// Three layers:
// - Address space administration
// - Committed space administration
// - Suballocator
//
// Helper module: administrating block descriptors
//


//
// Operating system interface
//
const
  LMEM_FIXED = 0;
  LMEM_ZEROINIT = $40;

  MEM_COMMIT   = $1000;
  MEM_RESERVE  = $2000;
  MEM_DECOMMIT = $4000;
  MEM_RELEASE  = $8000;

  PAGE_NOACCESS  = 1;
  PAGE_READWRITE = 4;

type
  DWORD = Integer;
  BOOL  = LongBool;

  TRTLCriticalSection = packed record
    DebugInfo: Pointer;
    LockCount: Longint;
    RecursionCount: Longint;
    OwningThread: Integer;
    LockSemaphore: Integer;
    Reserved: DWORD;
  end;

{function LocalAlloc(flags, size: Integer): Pointer; stdcall;
  external kernel name 'LocalAlloc';
function LocalFree(addr: Pointer): Pointer; stdcall;
  external kernel name 'LocalFree';}

function VirtualAlloc(lpAddress: Pointer;
  dwSize, flAllocationType, flProtect: DWORD): Pointer; stdcall;
  external kernel name 'VirtualAlloc';
function VirtualFree(lpAddress: Pointer; dwSize, dwFreeType: DWORD): BOOL; stdcall;
  external kernel name 'VirtualFree';

procedure InitializeCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
  external kernel name 'InitializeCriticalSection';
procedure EnterCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
  external kernel name 'EnterCriticalSection';
procedure LeaveCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
  external kernel name 'LeaveCriticalSection';
procedure DeleteCriticalSection(var lpCriticalSection: TRTLCriticalSection); stdcall;
  external kernel name 'DeleteCriticalSection';

// Common Data structure:

type
  TBlock = packed record
    addr: PChar;
    size: Integer;
  end;

// Heap error codes

const
  cHeapOk           = 0;          // everything's fine
  cReleaseErr       = 1;          // operating system returned an error when we released
  cDecommitErr      = 2;          // operating system returned an error when we decommited
  cBadCommittedList = 3;          // list of committed blocks looks bad
  cBadFiller1       = 4;          // filler block is bad
  cBadFiller2       = 5;          // filler block is bad
  cBadFiller3       = 6;          // filler block is bad
  cBadCurAlloc      = 7;          // current allocation zone is bad
  cCantInit         = 8;          // couldn't initialize
  cBadUsedBlock     = 9;          // used block looks bad
  cBadPrevBlock     = 10;         // prev block before a used block is bad
  cBadNextBlock     = 11;         // next block after a used block is bad
  cBadFreeList      = 12;         // free list is bad
  cBadFreeBlock     = 13;         // free block is bad
  cBadBalance       = 14;         // free list doesn't correspond to blocks marked free

var
  initialized   : Boolean;
  heapErrorCode : Integer;
  heapLock      : TRTLCriticalSection;
  {X} // Handler to set it to UninitAllocator, if Delphi memory manager used:
  {X} UninitMemoryManager : procedure = DummyProc;

//
// Helper module: administrating block descriptors.
//
type
  PBlockDesc = ^TBlockDesc;
  TBlockDesc = packed record
    next: PBlockDesc;
    prev: PBlockDesc;
    addr: PChar;
    size: Integer;
  end;

type
  PBlockDescBlock = ^TBlockDescBlock;
  TBlockDescBlock = packed record
    next: PBlockDescBlock;
    data: array [0..99] of TBlockDesc;
  end;

var
  blockDescBlockList: PBlockDescBlock;
  blockDescFreeList : PBlockDesc;


function GetBlockDesc: PBlockDesc;
// Get a block descriptor.
// Will return nil for failure.
var
  bd:  PBlockDesc;
  bdb: PBlockDescBlock;
  i:   Integer;
begin
  if blockDescFreeList = nil then begin
    bdb := LocalAlloc(LMEM_FIXED, sizeof(bdb^));
    if bdb = nil then begin
      result := nil;
      exit;
    end;
    bdb.next := blockDescBlockList;
    blockDescBlockList := bdb;
    for i := low(bdb.data) to high(bdb.data) do begin
      bd := @bdb.data[i];
      bd.next := blockDescFreeList;
      blockDescFreeList := bd;
    end;
  end;
  bd := blockDescFreeList;
  blockDescFreeList := bd.next;
  result := bd;
end;


procedure MakeEmpty(bd: PBlockDesc);
begin
  bd.next := bd;
  bd.prev := bd;
end;


function AddBlockAfter(prev: PBlockDesc; const b: TBlock): Boolean;
var
  next, bd: PBlockDesc;
begin
  bd := GetBlockDesc;
  if bd = nil then
    result := False
  else begin
    bd.addr := b.addr;
    bd.size := b.size;

    next := prev.next;
    bd.next := next;
    bd.prev := prev;
    next.prev := bd;
    prev.next := bd;

    result := True;
  end;
end;


procedure DeleteBlock(bd: PBlockDesc);
var
  prev, next: PBlockDesc;
begin
  prev := bd.prev;
  next := bd.next;
  prev.next := next;
  next.prev := prev;
  bd.next := blockDescFreeList;
  blockDescFreeList := bd;
end;


function MergeBlockAfter(prev: PBlockDesc; const b: TBlock) : TBlock;
var
  bd, bdNext: PBlockDesc;
begin
  bd := prev.next;
  result := b;
  repeat
    bdNext := bd.next;
    if bd.addr + bd.size = result.addr then begin
      DeleteBlock(bd);
      result.addr := bd.addr;
      inc(result.size, bd.size);
    end else if result.addr + result.size = bd.addr then begin
      DeleteBlock(bd);
      inc(result.size, bd.size);
    end;
    bd := bdNext;
  until bd = prev;
  if not AddBlockAfter(prev, result) then
    result.addr := nil;
end;


function RemoveBlock(bd: PBlockDesc; const b: TBlock): Boolean;
var
  n: TBlock;
  start: PBlockDesc;
begin
  start := bd;
  repeat
    if (bd.addr <= b.addr) and (bd.addr + bd.size >= b.addr + b.size) then begin
      if bd.addr = b.addr then begin
        Inc(bd.addr, b.size);
        Dec(bd.size, b.size);
        if bd.size = 0 then
          DeleteBlock(bd);
      end else if bd.addr + bd.size = b.addr + b.size then
        Dec(bd.size, b.size)
      else begin
        n.addr := b.addr + b.size;
        n.size := bd.addr + bd.size - n.addr;
        bd.size := b.addr - bd.addr;
        if not AddBlockAfter(bd, n) then begin
          result := False;
          exit;
        end;
      end;
      result := True;
      exit;
    end;
    bd := bd.next;
  until bd = start;
  result := False;
end;



//
// Address space administration:
//

const
  cSpaceAlign = 64*1024;
  cSpaceMin   = 1024*1024;
  cPageAlign  = 4*1024;

var
  spaceRoot: TBlockDesc;


function GetSpace(minSize: Integer): TBlock;
// Get at least minSize bytes address space.
// Success: returns a block, possibly much bigger than requested.
// Will not fail - will raise an exception or terminate program.
begin
  if minSize < cSpaceMin then
    minSize := cSpaceMin
  else
    minSize := (minSize + (cSpaceAlign-1)) and not (cSpaceAlign-1);

  result.size := minSize;
  result.addr := VirtualAlloc(nil, minSize, MEM_RESERVE, PAGE_NOACCESS);
  if result.addr = nil then
    exit;

  if not AddBlockAfter(@spaceRoot, result) then begin
    VirtualFree(result.addr, 0, MEM_RELEASE);
    result.addr := nil;
    exit;
  end;
end;


function GetSpaceAt(addr: PChar; minSize: Integer): TBlock;
// Get at least minSize bytes address space at addr.
// Return values as above.
// Failure: returns block with addr = nil.
begin
  result.size := cSpaceMin;
  result.addr := VirtualAlloc(addr, cSpaceMin, MEM_RESERVE, PAGE_READWRITE);
  if result.addr = nil then begin
    minSize := (minSize + (cSpaceAlign-1)) and not (cSpaceAlign-1);
    result.size := minSize;
    result.addr := VirtualAlloc(addr, minSize, MEM_RESERVE, PAGE_READWRITE);
  end;
  if result.addr <> nil then begin
    if not AddBlockAfter(@spaceRoot, result) then begin
      VirtualFree(result.addr, 0, MEM_RELEASE);
      result.addr := nil;
    end;
  end;
end;


function FreeSpace(addr: Pointer; maxSize: Integer): TBlock;
// Free at most maxSize bytes of address space at addr.
// Returns the block that was actually freed.
var
  bd, bdNext: PBlockDesc;
  minAddr, maxAddr, startAddr, endAddr: PChar;
begin
  minAddr := PChar($FFFFFFFF);
  maxAddr := nil;
  startAddr := addr;
  endAddr   := startAddr + maxSize;
  bd := spaceRoot.next;
  while bd <> @spaceRoot do begin
    bdNext := bd.next;
    if (bd.addr >= startAddr) and (bd.addr + bd.size <= endAddr) then begin
      if minAddr > bd.addr then
        minAddr := bd.addr;
      if maxAddr < bd.addr + bd.size then
        maxAddr := bd.addr + bd.size;
      if not VirtualFree(bd.addr, 0, MEM_RELEASE) then
        heapErrorCode := cReleaseErr;
      DeleteBlock(bd);
    end;
    bd := bdNext;
  end;
  result.addr := nil;
  if maxAddr <> nil then begin
    result.addr := minAddr;
    result.size := maxAddr - minAddr;
  end;
end;


function Commit(addr: Pointer; minSize: Integer): TBlock;
// Commits memory.
// Returns the block that was actually committed.
// Will return a block with addr = nil on failure.
var
  bd: PBlockDesc;
  loAddr, hiAddr, startAddr, endAddr: PChar;
begin
  startAddr := PChar(Integer(addr) and not (cPageAlign-1));
  endAddr := PChar(((Integer(addr) + minSize) + (cPageAlign-1)) and not (cPageAlign-1));
  result.addr := startAddr;
  result.size := endAddr - startAddr;
  bd := spaceRoot.next;
  while bd <> @spaceRoot do begin
    // Commit the intersection of the block described by bd and [startAddr..endAddr)
    loAddr := bd.addr;
    hiAddr := loAddr + bd.size;
    if loAddr < startAddr then
      loAddr := startAddr;
    if hiAddr > endAddr then
      hiAddr := endAddr;
    if loAddr < hiAddr then begin
      if VirtualAlloc(loAddr, hiAddr - loAddr, MEM_COMMIT, PAGE_READWRITE) = nil then begin
        result.addr := nil;
        exit;
      end;
    end;
    bd := bd.next;
  end;
end;


function Decommit(addr: Pointer; maxSize: Integer): TBlock;
// Decommits address space.
// Returns the block that was actually decommitted.
var
  bd: PBlockDesc;
  loAddr, hiAddr, startAddr, endAddr: PChar;
begin
  startAddr := PChar((Integer(addr) + + (cPageAlign-1)) and not (cPageAlign-1));
  endAddr := PChar((Integer(addr) + maxSize) and not (cPageAlign-1));
  result.addr := startAddr;
  result.size := endAddr - startAddr;
  bd := spaceRoot.next;
  while bd <> @spaceRoot do begin
    // Decommit the intersection of the block described by bd and [startAddr..endAddr)
    loAddr := bd.addr;
    hiAddr := loAddr + bd.size;
    if loAddr < startAddr then
      loAddr := startAddr;
    if hiAddr > endAddr then
      hiAddr := endAddr;
    if loAddr < hiAddr then begin
      if not VirtualFree(loAddr, hiAddr - loAddr, MEM_DECOMMIT) then
        heapErrorCode := cDecommitErr;
    end;
    bd := bd.next;
  end;
end;


//
// Committed space administration
//
const
  cCommitAlign = 16*1024;

var
  decommittedRoot: TBlockDesc;


function GetCommitted(minSize: Integer): TBlock;
// Get a block of committed memory.
// Returns a committed memory block, possibly much bigger than requested.
// Will return a block with a nil addr on failure.
var
  bd: PBlockDesc;
begin
  minSize := (minSize + (cCommitAlign-1)) and not (cCommitAlign-1);
  repeat
    bd := decommittedRoot.next;
    while bd <> @decommittedRoot do begin
      if bd.size >= minSize then begin
        result := Commit(bd.addr, minSize);
        if result.addr = nil then
          exit;
        Inc(bd.addr, result.size);
        Dec(bd.size, result.size);
        if bd.size = 0 then
          DeleteBlock(bd);
        exit;
      end;
      bd := bd.next;
    end;
    result := GetSpace(minSize);
    if result.addr = nil then
      exit;
    if MergeBlockAfter(@decommittedRoot, result).addr = nil then begin
      FreeSpace(result.addr, result.size);
      result.addr := nil;
      exit;
    end;
  until False;
end;


function GetCommittedAt(addr: PChar; minSize: Integer): TBlock;
// Get at least minSize bytes committed space at addr.
// Success: returns a block, possibly much bigger than requested.
// Failure: returns a block with addr = nil.
var
  bd: PBlockDesc;
  b: TBlock;
begin
  minSize := (minSize + (cCommitAlign-1)) and not (cCommitAlign-1);
  repeat

    bd := decommittedRoot.next;
    while (bd <> @decommittedRoot) and (bd.addr <> addr) do
      bd := bd.next;

    if bd.addr = addr then begin
      if bd.size >= minSize then
        break;
      b := GetSpaceAt(bd.addr + bd.size, minSize - bd.size);
      if b.addr <> nil then begin
        if MergeBlockAfter(@decommittedRoot, b).addr <> nil then
          continue
        else begin
          FreeSpace(b.addr, b.size);
          result.addr := nil;
          exit;
        end;
      end;
    end;

    b := GetSpaceAt(addr, minSize);
    if b.addr = nil then
      break;

    if MergeBlockAfter(@decommittedRoot, b).addr = nil then begin
      FreeSpace(b.addr, b.size);
      result.addr := nil;
      exit;
    end;
  until false;

  if (bd.addr = addr) and (bd.size >= minSize) then begin
    result := Commit(bd.addr, minSize);
    if result.addr = nil then
      exit;
    Inc(bd.addr, result.size);
    Dec(bd.size, result.size);
    if bd.size = 0 then
      DeleteBlock(bd);
  end else
    result.addr := nil;
end;


function FreeCommitted(addr: PChar; maxSize: Integer): TBlock;
// Free at most maxSize bytes of address space at addr.
// Returns the block that was actually freed.
var
  startAddr, endAddr: PChar;
  b: TBlock;
begin
  startAddr := PChar(Integer(addr + (cCommitAlign-1)) and not (cCommitAlign-1));
  endAddr := PChar(Integer(addr + maxSize) and not (cCommitAlign-1));
  if endAddr > startAddr then begin
    result := Decommit(startAddr, endAddr - startAddr);
    b := MergeBlockAfter(@decommittedRoot, result);
    if b.addr <> nil then
      b := FreeSpace(b.addr, b.size);
    if b.addr <> nil then
      RemoveBlock(@decommittedRoot, b);
  end else
    result.addr := nil;
end;


//
// Suballocator (what the user program actually calls)
//

type
  PFree = ^TFree;
  TFree = packed record
    prev: PFree;
    next: PFree;
    size: Integer;
  end;
  PUsed = ^TUsed;
  TUsed = packed record
    sizeFlags: Integer;
  end;

const
  cAlign        = 4;
  cThisUsedFlag = 2;
  cPrevFreeFlag = 1;
  cFillerFlag   = Integer($80000000);
  cFlags        = cThisUsedFlag or cPrevFreeFlag or cFillerFlag;
  cSmallSize    = 4*1024;
  cDecommitMin  = 15*1024;

type
  TSmallTab    = array [sizeof(TFree) div cAlign .. cSmallSize div cAlign] of PFree;

VAR
  avail        : TFree;
  rover        : PFree;
  remBytes     : Integer;
  curAlloc     : PChar;
  smallTab     : ^TSmallTab;
  committedRoot: TBlockDesc;


{X} // UninitAllocator - placed before InitAllocator to refer to.
procedure UninitAllocator;
// Shutdown.
var
  bdb: PBlockDescBlock;
  bd : PBlockDesc;
begin
  if initialized then begin
    try
      if IsMultiThread then EnterCriticalSection(heapLock);

      initialized := False;

      LocalFree(smallTab);
      smallTab := nil;

      bd := spaceRoot.next;
      while bd <> @spaceRoot do begin
        VirtualFree(bd.addr, 0, MEM_RELEASE);
        bd := bd.next;
      end;

      MakeEmpty(@spaceRoot);
      MakeEmpty(@decommittedRoot);
      MakeEmpty(@committedRoot);

      bdb := blockDescBlockList;
      while bdb <> nil do begin
        blockDescBlockList := bdb^.next;
        LocalFree(bdb);
        bdb := blockDescBlockList;
      end;
    finally
      if IsMultiThread then LeaveCriticalSection(heapLock);
      DeleteCriticalSection(heapLock);
    end;
  end;
end;

function InitAllocator: Boolean;
// Initialize. No other calls legal before that.
var
  i: Integer;
  a: PFree;
begin
  try
    InitializeCriticalSection(heapLock);
    if IsMultiThread then EnterCriticalSection(heapLock);

    MakeEmpty(@spaceRoot);
    MakeEmpty(@decommittedRoot);
    MakeEmpty(@committedRoot);

    smallTab := LocalAlloc(LMEM_FIXED, sizeof(smallTab^));
    if smallTab <> nil then begin
      for i:= low(smallTab^) to high(smallTab^) do
        smallTab[i] := nil;

      a := @avail;
      a.next := a;
      a.prev := a;
      rover := a;

      initialized := True;
      {X} // set here handler UninitMemoryManager to UninitAllocator }
      {X} UninitMemoryManager := UninitAllocator;
    end;
  finally
    if IsMultiThread then LeaveCriticalSection(heapLock);
  end;
  result := initialized;
end;



procedure DeleteFree(f: PFree);
var
  n, p: PFree;
  size: Integer;
begin
  if rover = f then
    rover := f.next;
  n := f.next;
  size := f.size;
  if size <= cSmallSize then begin
    if n = f then
      smallTab[size div cAlign] := nil
    else begin
      smallTab[size div cAlign] := n;
      p := f.prev;
      n.prev := p;
      p.next := n;
    end;
  end else begin
    p := f.prev;
    n.prev := p;
    p.next := n;
  end;
end;


procedure InsertFree(a: Pointer; size: Integer); forward;


function FindCommitted(addr: PChar): PBlockDesc;
begin
  result := committedRoot.next;
  while result <> @committedRoot do begin
    if (addr >= result.addr) and (addr < result.addr + result.size) then
      exit;
    result := result.next;
  end;
  heapErrorCode := cBadCommittedList;
  result := nil;
end;


procedure FillBeforeGap(a: PChar; size: Integer);
var
  rest: Integer;
  e: PUsed;
begin
  rest := size - sizeof(TUsed);
  e := PUsed(a + rest);
  if size >= sizeof(TFree) + sizeof(TUsed) then begin
    e.sizeFlags := sizeof(TUsed) or cThisUsedFlag or cPrevFreeFlag or cFillerFlag;
    InsertFree(a, rest);
  end else if size >= sizeof(TUsed) then begin
    PUsed(a).sizeFlags := size or (cThisUsedFlag or cFillerFlag);
    e.sizeFlags := size or (cThisUsedFlag or cFillerFlag);
  end;
end;


procedure InternalFreeMem(a: PChar);
begin
  Inc(AllocMemCount);
  Inc(AllocMemSize,PUsed(a-sizeof(TUsed)).sizeFlags and not cFlags - sizeof(TUsed));
  SysFreeMem(a);
end;


procedure FillAfterGap(a: PChar; size: Integer);
begin
  if size >= sizeof(TFree) then begin
    PUsed(a).sizeFlags := size or cThisUsedFlag;
    InternalFreeMem(a + sizeof(TUsed));
  end else begin
    if size >= sizeof(TUsed) then
      PUsed(a).sizeFlags := size or (cThisUsedFlag or cFillerFlag);
    Inc(a,size);
    PUsed(a).sizeFlags := PUsed(a).sizeFlags and not cPrevFreeFlag;
  end;
end;


function FillerSizeBeforeGap(a: PChar): Integer;
var
  sizeFlags : Integer;
  freeSize  : Integer;
  f : PFree;
begin
  sizeFlags := PUsed(a - sizeof(TUsed)).sizeFlags;
  if (sizeFlags and (cThisUsedFlag or cFillerFlag)) <> (cThisUsedFlag or cFillerFlag) then
    heapErrorCode := cBadFiller1;
  result := sizeFlags and not cFlags;
  Dec(a, result);
  if ((PUsed(a).sizeFlags xor sizeFlags) and not cPrevFreeFlag) <> 0 then
    HeapErrorCode := cBadFiller2;
  if (PUsed(a).sizeFlags and cPrevFreeFlag) <> 0 then begin
    freeSize := PFree(a - sizeof(TFree)).size;
    f := PFree(a - freeSize);
    if f.size <> freeSize then
      heapErrorCode := cBadFiller3;
    DeleteFree(f);
    Inc(result, freeSize);
  end;
end;


function FillerSizeAfterGap(a: PChar): Integer;
var
  sizeFlags: Integer;
  f : PFree;
begin
  result := 0;
  sizeFlags := PUsed(a).sizeFlags;
  if (sizeFlags and cFillerFlag) <> 0 then begin
    sizeFlags := sizeFlags and not cFlags;
    Inc(result,sizeFlags);
    Inc(a, sizeFlags);
    sizeFlags := PUsed(a).sizeFlags;
  end;
  if (sizeFlags and cThisUsedFlag) = 0 then begin
    f := PFree(a);
    DeleteFree(f);
    Inc(result, f.size);
    Inc(a, f.size);
    PUsed(a).sizeFlags := PUsed(a).sizeFlags and not cPrevFreeFlag;
  end;
end;


function DecommitFree(a: PChar; size: Integer): Boolean;
var
  b: TBlock;
  bd: PBlockDesc;
begin
  Result := False;
  bd := FindCommitted(a);
  if bd = nil then Exit;
  if bd.addr + bd.size - (a + size) <= sizeof(TFree) then
    size := bd.addr + bd.size - a;

  if a - bd.addr < sizeof(TFree) then
    b := FreeCommitted(bd.addr, size + (a - bd.addr))
  else
    b := FreeCommitted(a + sizeof(TUsed), size - sizeof(TUsed));

  if b.addr <> nil then
  begin
    FillBeforeGap(a, b.addr - a);
    if bd.addr + bd.size > b.addr + b.size then
      FillAfterGap(b.addr + b.size, a + size - (b.addr + b.size));
    RemoveBlock(bd,b);
    result := True;
  end;
end;


procedure InsertFree(a: Pointer; size: Integer);
var
  f, n, p: PFree;
begin
  f := PFree(a);
  f.size := size;
  PFree(PChar(f) + size - sizeof(TFree)).size := size;
  if size <= cSmallSize then begin
    n := smallTab[size div cAlign];
    if n = nil then begin
      smallTab[size div cAlign] := f;
      f.next := f;
      f.prev := f;
    end else begin
      p := n.prev;
      f.next := n;
      f.prev := p;
      n.prev := f;
      p.next := f;
    end;
  end else if (size < cDecommitMin) or not DecommitFree(a, size) then begin
    n := rover;
    rover := f;
    p := n.prev;
    f.next := n;
    f.prev := p;
    n.prev := f;
    p.next := f;
  end;
end;


procedure FreeCurAlloc;
begin
  if remBytes > 0 then begin
    if remBytes < sizeof(TFree) then
      heapErrorCode := cBadCurAlloc
    else begin
      PUsed(curAlloc).sizeFlags := remBytes or cThisUsedFlag;
      InternalFreeMem(curAlloc + sizeof(TUsed));
      curAlloc := nil;
      remBytes := 0;
    end;
  end;
end;


function MergeCommit(b: TBlock): Boolean;
var
  merged: TBlock;
  fSize: Integer;
begin
  FreeCurAlloc;
  merged := MergeBlockAfter(@committedRoot, b);
  if merged.addr = nil then begin
    result := False;
    exit;
  end;

  if merged.addr < b.addr then begin
    fSize := FillerSizeBeforeGap(b.addr);
    Dec(b.addr, fSize);
    Inc(b.size, fSize);
  end;

  if merged.addr + merged.size > b.addr + b.size then begin
    fSize := FillerSizeAfterGap(b.addr + b.size);
    Inc(b.size, fSize);
  end;

  if merged.addr + merged.size = b.addr + b.size then begin
    FillBeforeGap(b.addr + b.size - sizeof(TUsed), sizeof(TUsed));
    Dec(b.size, sizeof(TUsed));
  end;

  curAlloc := b.addr;
  remBytes := b.size;

  result := True;
end;


function NewCommit(minSize: Integer): Boolean;
var
  b: TBlock;
begin
  b := GetCommitted(minSize+sizeof(TUsed));
  result := (b.addr <> nil) and MergeCommit(b);
end;


function NewCommitAt(addr: Pointer; minSize: Integer): Boolean;
var
  b: TBlock;
begin
  b := GetCommittedAt(addr, minSize+sizeof(TUsed));
  result := (b.addr <> nil) and MergeCommit(b);
end;


function SearchSmallBlocks(size: Integer): PFree;
var
  i: Integer;
begin
  result := nil;
  for i := size div cAlign to High(smallTab^) do begin
    result := smallTab[i];
    if result <> nil then
      exit;
  end;
end;


function TryHarder(size: Integer): Pointer;
var
  u: PUsed; f:PFree; saveSize, rest: Integer;
begin

  repeat

    f := avail.next;
    if (size <= f.size) then
      break;

    f := rover;
    if f.size >= size then
      break;

    saveSize := f.size;
    f.size := size;
    repeat
      f := f.next
    until f.size >= size;
    rover.size := saveSize;
    if f <> rover then begin
      rover := f;
      break;
    end;

    if size <= cSmallSize then begin
      f := SearchSmallBlocks(size);
      if f <> nil then
        break;
    end;

    if not NewCommit(size) then begin
      result := nil;
      exit;
    end;

    if remBytes >= size then begin
      Dec(remBytes, size);
      if remBytes < sizeof(TFree) then begin
        Inc(size, remBytes);
        remBytes := 0;
      end;
      u := PUsed(curAlloc);
      Inc(curAlloc, size);
      u.sizeFlags := size or cThisUsedFlag;
      result := PChar(u) + sizeof(TUsed);
      Inc(AllocMemCount);
      Inc(AllocMemSize,size - sizeof(TUsed));
      exit;
    end;

  until False;

  DeleteFree(f);

  rest := f.size - size;
  if rest >= sizeof(TFree) then begin
    InsertFree(PChar(f) + size, rest);
  end else begin
    size := f.size;
    if f = rover then
      rover := f.next;
    u := PUsed(PChar(f) + size);
    u.sizeFlags := u.sizeFlags and not cPrevFreeFlag;
  end;

  u := PUsed(f);
  u.sizeFlags := size or cThisUsedFlag;

  result := PChar(u) + sizeof(TUsed);
  Inc(AllocMemCount);
  Inc(AllocMemSize,size - sizeof(TUsed));

end;


function SysGetMem(size: Integer): Pointer;
// Allocate memory block.
var
  f, prev, next: PFree;
  u: PUsed;
begin

  if (not initialized and not InitAllocator) or
    (size > (High(size) - (sizeof(TUsed) + (cAlign-1)))) then
  begin
    result := nil;
    exit;
  end;


  try
    if IsMultiThread then EnterCriticalSection(heapLock);

    Inc(size, sizeof(TUsed) + (cAlign-1));
    size := size and not (cAlign-1);
    if size < sizeof(TFree) then
      size := sizeof(TFree);

    if size <= cSmallSize then begin
      f := smallTab[size div cAlign];
      if f <> nil then begin
        u := PUsed(PChar(f) + size);
        u.sizeFlags := u.sizeFlags and not cPrevFreeFlag;
        next := f.next;
        if next = f then
          smallTab[size div cAlign] := nil
        else begin
          smallTab[size div cAlign] := next;
          prev := f.prev;
          prev.next := next;
          next.prev := prev;
        end;
        u := PUsed(f);
        u.sizeFlags := f.size or cThisUsedFlag;
        result := PChar(u) + sizeof(TUsed);
        Inc(AllocMemCount);
        Inc(AllocMemSize,size - sizeof(TUsed));
        exit;
      end;
    end;

    if size <= remBytes then begin
      Dec(remBytes, size);
      if remBytes < sizeof(TFree) then begin
        Inc(size, remBytes);
        remBytes := 0;
      end;
      u := PUsed(curAlloc);
      Inc(curAlloc, size);
      u.sizeFlags := size or cThisUsedFlag;
      result := PChar(u) + sizeof(TUsed);
      Inc(AllocMemCount);
      Inc(AllocMemSize,size - sizeof(TUsed));
      exit;
    end;

    result := TryHarder(size);

  finally
    if IsMultiThread then LeaveCriticalSection(heapLock);
  end;

end;


function SysFreeMem(p: Pointer): Integer;
// Deallocate memory block.
label
  abort;
var
  u, n : PUsed;
  f : PFree;
  prevSize, nextSize, size : Integer;
begin
  heapErrorCode := cHeapOk;

  if not initialized and not InitAllocator then begin
    heapErrorCode := cCantInit;
    result := cCantInit;
    exit;
  end;

  try
    if IsMultiThread then EnterCriticalSection(heapLock);

    u := p;
    u := PUsed(PChar(u) - sizeof(TUsed)); { inv: u = address of allocated block being freed }
    size := u.sizeFlags;
    { inv: size = SET(block size) + [block flags] }

    { validate that the interpretation of this block as a used block is correct }
    if (size and cThisUsedFlag) = 0 then begin
      heapErrorCode := cBadUsedBlock;
      goto abort;
    end;

    { inv: the memory block addressed by 'u' and 'p' is an allocated block }

    Dec(AllocMemCount);
    Dec(AllocMemSize,size and not cFlags - sizeof(TUsed));

    if (size and cPrevFreeFlag) <> 0 then begin
      { previous block is free, coalesce }
      prevSize := PFree(PChar(u)-sizeof(TFree)).size;
      if (prevSize < sizeof(TFree)) or ((prevSize and cFlags) <> 0) then begin
        heapErrorCode := cBadPrevBlock;
        goto abort;
      end;

      f := PFree(PChar(u) - prevSize);
      if f^.size <> prevSize then begin
        heapErrorCode := cBadPrevBlock;
        goto abort;
      end;

      inc(size, prevSize);
      u := PUsed(f);
      DeleteFree(f);
    end;

    size := size and not cFlags;
    { inv: size = block size }

    n := PUsed(PChar(u) + size);
    { inv: n = block following the block to free }

    if PChar(n) = curAlloc then begin
      { inv: u = last block allocated }
      dec(curAlloc, size);
      inc(remBytes, size);
      if remBytes > cDecommitMin then
        FreeCurAlloc;
      result := cHeapOk;
      exit;
    end;

    if (n.sizeFlags and cThisUsedFlag) <> 0 then begin
      { inv: n is a used block }
      if (n.sizeFlags and not cFlags) < sizeof(TUsed) then begin
        heapErrorCode := cBadNextBlock;
        goto abort;
      end;
      n.sizeFlags := n.sizeFlags or cPrevFreeFlag
    end else begin
      { inv: block u & n are both free; coalesce }
      f := PFree(n);
      if (f.next = nil) or (f.prev = nil) or (f.size < sizeof(TFree)) then begin
        heapErrorCode := cBadNextBlock;
        goto abort;
      end;
      nextSize := f.size;
      inc(size, nextSize);
      DeleteFree(f);
      { inv: last block (which was free) is not on free list }
    end;

    InsertFree(u, size);
abort:
    result := heapErrorCode;
  finally
    if IsMultiThread then LeaveCriticalSection(heapLock);
  end;
end;


function ResizeInPlace(p: Pointer; newSize: Integer): Boolean;
var u, n: PUsed; f: PFree; oldSize, blkSize, neededSize: Integer;
begin
  Inc(newSize, sizeof(TUsed)+cAlign-1);
  newSize := newSize and not (cAlign-1);
  if newSize < sizeof(TFree) then
    newSize := sizeof(TFree);
  u := PUsed(PChar(p) - sizeof(TUsed));
  oldSize := u.sizeFlags and not cFlags;
  n := PUsed( PChar(u) + oldSize );
  if newSize <= oldSize then begin
    blkSize := oldSize - newSize;
    if PChar(n) = curAlloc then begin
      Dec(curAlloc, blkSize);
      Inc(remBytes, blkSize);
      if remBytes < sizeof(TFree) then begin
        Inc(curAlloc, blkSize);
        Dec(remBytes, blkSize);
        newSize := oldSize;
      end;
    end else begin
      n := PUsed(PChar(u) + oldSize);
      if n.sizeFlags and cThisUsedFlag = 0 then begin
        f := PFree(n);
        Inc(blkSize, f.size);
        DeleteFree(f);
      end;
      if blkSize >= sizeof(TFree) then begin
        n := PUsed(PChar(u) + newSize);
        n.sizeFlags := blkSize or cThisUsedFlag;
        InternalFreeMem(PChar(n) + sizeof(TUsed));
      end else
        newSize := oldSize;
    end;
  end else begin
    repeat
      neededSize := newSize - oldSize;
      if PChar(n) = curAlloc then begin
        if remBytes >= neededSize then begin
          Dec(remBytes, neededSize);
          Inc(curAlloc, neededSize);
          if remBytes < sizeof(TFree) then begin
            Inc(curAlloc, remBytes);
            Inc(newSize, remBytes);
            remBytes := 0;
          end;
          Inc(AllocMemSize, newSize - oldSize);
          u.sizeFlags := newSize or u.sizeFlags and cFlags;
          result := true;
          exit;
        end else begin
          FreeCurAlloc;
          n := PUsed( PChar(u) + oldSize );
        end;
      end;

      if n.sizeFlags and cThisUsedFlag = 0 then begin
        f := PFree(n);
        blkSize := f.size;
        if blkSize < neededSize then begin
          n := PUsed(PChar(n) + blkSize);
          Dec(neededSize, blkSize);
        end else begin
          DeleteFree(f);
          Dec(blkSize, neededSize);
          if blkSize >= sizeof(TFree) then
            InsertFree(PChar(u) + newSize, blkSize)
          else begin
            Inc(newSize, blkSize);
            n := PUsed(PChar(u) + newSize);
            n.sizeFlags := n.sizeFlags and not cPrevFreeFlag;
          end;
          break;
        end;
      end;

      if n.sizeFlags and cFillerFlag <> 0 then begin
        n := PUsed(PChar(n) + n.sizeFlags and not cFlags);
        if NewCommitAt(n, neededSize) then begin
          n := PUsed( PChar(u) + oldSize );
          continue;
        end;
      end;

      result := False;
      exit;

    until False;

  end;

  Inc(AllocMemSize, newSize - oldSize);
  u.sizeFlags := newSize or u.sizeFlags and cFlags;
  result := True;

end;


function SysReallocMem(p: Pointer; size: Integer): Pointer;
// Resize memory block.
var
  n: Pointer; oldSize: Integer;
begin

  if not initialized and not InitAllocator then begin
    result := nil;
    exit;
  end;

  try
    if IsMultiThread then EnterCriticalSection(heapLock);

    if ResizeInPlace(p, size) then
      result := p
    else begin
      n := SysGetMem(size);
      oldSize := (PUsed(PChar(p)-sizeof(PUsed)).sizeFlags and not cFlags) - sizeof(TUsed);
      if oldSize > size then
        oldSize := size;
      if n <> nil then begin
        Move(p^, n^, oldSize);
        SysFreeMem(p);
      end;
      result := n;
    end;
  finally
    if IsMultiThread then LeaveCriticalSection(heapLock);
  end;

end;


function BlockSum(root: PBlockDesc): Integer;
var
  b : PBlockDesc;
begin
  result := 0;
  b := root.next;
  while b <> root do begin
    Inc(result, b.size);
    b := b.next;
  end;
end;


function GetHeapStatus: THeapStatus;
var
  size, freeSize, userSize: Cardinal;
  f: PFree;
  a, e: PChar;
  i: Integer;
  b: PBlockDesc;
  prevFree: Boolean;
begin

  result.TotalAddrSpace   := 0;
  result.TotalUncommitted := 0;
  result.TotalCommitted   := 0;
  result.TotalAllocated   := 0;
  result.TotalFree        := 0;
  result.FreeSmall        := 0;
  result.FreeBig          := 0;
  result.Unused           := 0;
  result.Overhead         := 0;
  result.HeapErrorCode    := cHeapOk;

  if not initialized then exit;

  try
    if IsMultiThread then EnterCriticalSection(heapLock);

    result.totalAddrSpace   := BlockSum(@spaceRoot);
    result.totalUncommitted := BlockSum(@decommittedRoot);
    result.totalCommitted   := BlockSum(@committedRoot);

    size := 0;
    for i := Low(smallTab^) to High(smallTab^) do begin
      f := smallTab[i];
      if f <> nil then begin
        repeat
          Inc(size, f.size);
          if (f.prev.next <> f) or (f.next.prev <> f) or (f.size < sizeof(TFree)) then begin
            heapErrorCode := cBadFreeList;
            break;
          end;
          f := f.next;
        until f = smallTab[i];
      end;
    end;
    result.freeSmall := size;

    size := 0;
    f := avail.next;
    while f <> @avail do begin
      if (f.prev.next <> f) or (f.next.prev <> f) or (f.size < sizeof(TFree)) then begin
        heapErrorCode := cBadFreeList;
        break;
      end;
      Inc(size, f.size);
      f := f.next;
    end;
    result.freeBig := size;

    result.unused := remBytes;
    result.totalFree := result.freeSmall + result.freeBig + result.unused;

    freeSize := 0;
    userSize := 0;
    result.overhead := 0;

    b := committedRoot.next;
    prevFree := False;
    while b <> @committedRoot do begin
      a := b.addr;
      e := a + b.size;
      while a < e do begin
        if (a = curAlloc) and (remBytes > 0) then begin
          size := remBytes;
          Inc(freeSize, size);
          if prevFree then
            heapErrorCode := cBadCurAlloc;
          prevFree := False;
        end else begin
          if prevFree <> ((PUsed(a).sizeFlags and cPrevFreeFlag) <> 0) then
            heapErrorCode := cBadNextBlock;
          if (PUsed(a).sizeFlags and cThisUsedFlag) = 0 then begin
            f := PFree(a);
            if (f.prev.next <> f) or (f.next.prev <> f) or (f.size < sizeof(TFree)) then
              heapErrorCode := cBadFreeBlock;
            size := f.size;
            Inc(freeSize, size);
            prevFree := True;
          end else begin
            size := PUsed(a).sizeFlags and not cFlags;
            if (PUsed(a).sizeFlags and cFillerFlag) <> 0 then begin
              Inc(result.overhead, size);
              if (a > b.addr) and (a + size < e) then
                heapErrorCode := cBadUsedBlock;
          end else begin
            Inc(userSize, size-sizeof(TUsed));
            Inc(result.overhead, sizeof(TUsed));
          end;
          prevFree := False;
        end;
      end;
      Inc(a, size);
      end;
      b := b.next;
    end;
    if result.totalFree <> freeSize then
      heapErrorCode := cBadBalance;

    result.totalAllocated := userSize;
    result.heapErrorCode := heapErrorCode;
  finally
    if IsMultiThread then LeaveCriticalSection(heapLock);
  end;
end;


//  this section goes into GetMem.Inc

{$IFDEF DEBUG_FUNCTIONS}
type
  THeapReportProc = procedure(HeapBlock: Pointer; AllocatedSize: Integer) of object;


procedure WalkHeap(HeapReportProc: THeapReportProc);
var
  size : Cardinal;
  f: PFree;
  a, e: PChar;
  b: PBlockDesc;
begin

  if not initialized then exit;

  try
    if IsMultiThread then EnterCriticalSection(heapLock);

    b := committedRoot.next;
    while b <> @committedRoot do begin
      a := b.addr;
      e := a + b.size;
      while a < e do begin
        if (a = curAlloc) and (remBytes > 0) then begin
          size := remBytes;
        end else begin
          if (PUsed(a).sizeFlags and cThisUsedFlag) = 0 then begin
            f := PFree(a);
            size := f.size;
          end else begin
            size := PUsed(a).sizeFlags and not cFlags;
            if (PUsed(a).sizeFlags and cFillerFlag) = 0 then begin
              HeapReportProc(a + sizeof(TUsed), size - sizeof(TUsed));
            end;
          end;
        end;
        Inc(a, size);
      end;
      b := b.next;
    end;
  finally
    if IsMultiThread then LeaveCriticalSection(heapLock);
  end;
end;

type
  THeapBlockCollector = class(TObject)
    FCount: Integer;
    FObjectTable: TObjectArray;
    FHeapBlockTable: THeapBlockArray;
    FClass: TClass;
    FFindDerived: Boolean;
    procedure CollectBlocks(HeapBlock: Pointer; AllocatedSize: Integer);
    procedure CollectObjects(HeapBlock: Pointer; AllocatedSize: Integer);
  end;


procedure THeapBlockCollector.CollectBlocks(HeapBlock: Pointer; AllocatedSize: Integer);
begin
  if FCount < Length(FHeapBlockTable) then
  begin
    FHeapBlockTable[FCount].Start := HeapBlock;
    FHeapBlockTable[FCount].Size  := AllocatedSize;
  end;
  Inc(FCount);
end;


procedure THeapBlockCollector.CollectObjects(HeapBlock: Pointer; AllocatedSize: Integer);
var
  AObject: TObject;
  AClass: TClass;
type
  PPointer = ^Pointer;
begin
  try
    if AllocatedSize < 4 then
      Exit;
    AObject := TObject(HeapBlock);
    AClass := AObject.ClassType;
    if (AClass = FClass)
      or (FFindDerived
        and (Integer(AClass) >= 64*1024)
        and (PPointer(PChar(AClass) + vmtSelfPtr)^ = Pointer(AClass))
        and (AObject is FClass)) then
    begin
      if FCount < Length(FObjectTable) then
        FObjectTable[FCount] := AObject;
      Inc(FCount);
    end;
  except
  //  Let's not worry about this block - it's obviously not a valid object
  end;
end;

var
  HeapBlockCollector: THeapBlockCollector;

function GetHeapBlocks: THeapBlockArray;
begin
  if not Assigned(HeapBlockCollector) then
    HeapBlockCollector := THeapBlockCollector.Create;

  Walkheap(HeapBlockCollector.CollectBlocks);
  SetLength(HeapBlockCollector.FHeapBlockTable, HeapBlockCollector.FCount);
  HeapBlockCollector.FCount := 0;
  Walkheap(HeapBlockCollector.CollectBlocks);
  Result := HeapBlockCollector.FHeapBlockTable;
  HeapBlockCollector.FCount := 0;
  HeapBlockCollector.FHeapBlockTable := nil;
end;


function FindObjects(AClass: TClass; FindDerived: Boolean): TObjectArray;
begin
  if not Assigned(HeapBlockCollector) then
    HeapBlockCollector := THeapBlockCollector.Create;
  HeapBlockCollector.FClass := AClass;
  HeapBlockCollector.FFindDerived := FindDerived;

  Walkheap(HeapBlockCollector.CollectObjects);
  SetLength(HeapBlockCollector.FObjectTable, HeapBlockCollector.FCount);
  HeapBlockCollector.FCount := 0;
  Walkheap(HeapBlockCollector.CollectObjects);
  Result := HeapBlockCollector.FObjectTable;
  HeapBlockCollector.FCount := 0;
  HeapBlockCollector.FObjectTable := nil;
end;
{$ENDIF}


