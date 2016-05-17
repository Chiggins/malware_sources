// ***************************************************************
//  madLists.pas              version:  1.1d  ·  date: 2005-01-05
//  -------------------------------------------------------------
//  several list interfaces
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2005 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2005-03-09 1.1e bug in handling with multiple lists fixed
// 2001-01-05 1.1d changed parameter in IPointerList.AddItems to "const"
// 2000-11-13 1.1c minor changes in order to get rid of SysUtils
// 2000-10-31 1.1b little bug in TIInterfaceList.AddItem / TIPointerList.AddItem fixed

unit madLists;

{$I mad.inc}

interface

uses madBasic;

// ***************************************************************

type
  // full IBasic list
  IBasicList = interface (ICustomBasicList) ['{0DDE44C0-71EB-11D3-A52D-00005A180D69}']
    // access to the items of the list
//    function  BasicItem (index: integer) : IBasic; 
    procedure SetItem   (index: integer; const item: IBasic);
    property  Items     [index: integer] : IBasic read BasicItem write SetItem; default;

    // access to the capacity of the list
//    function  GetCapacity : integer;
    procedure SetCapacity (capacity: integer);
    property  Capacity    : integer read GetCapacity write SetCapacity;

    // add one or more items to the list
    // return value is the new index of the (first) added item
    function AddItem  (const item  :          IBasic) : integer;
    function AddItems (const items : array of IBasic) : integer;

    // insert one item to the list
    function InsertItem (const item : IBasic;
                         index      : integer = 0) : integer;

    // swap two items
    function Swap (index1, index2: integer) : boolean;

    // delete an item (via index or via content)
    function DeleteItem (      index : integer) : boolean; overload;
    function DeleteItem (const item  : IBasic ) : boolean; overload;

    // remove all items
    procedure Clear;
  end;

// create a new IBasicList
function NewBasicList : IBasicList; overload;
function NewBasicList (const items: array of IBasic) : IBasicList; overload;

// ***************************************************************

type
  // function type that compares (sorts) two interfaces; needed for IInterfaceList
  TCompareInterface = function (const list: IList; const item1, item2: IUnknown; info: integer) : integer;

  // interface list
  IInterfaceList = interface (IList) ['{8C780300-4E4D-11D3-A52D-00005A180D69}']
    // access to the items of the list
    function  GetItem   (index: integer) : IUnknown;
    procedure SetItem   (index: integer; const item: IUnknown);
    property  Items     [index: integer] : IUnknown read GetItem write SetItem; default;

    // access to the capacity of the list
//    function  GetCapacity : integer;
    procedure SetCapacity (capacity: integer);
    property  Capacity    : integer read GetCapacity write SetCapacity;

    // add one or more items to the list
    // return value is the new index of the (first) added item
    function AddItem  (const item  :          IUnknown) : integer;
    function AddItems (const items : array of IUnknown) : integer;

    // insert one item to the list
    function InsertItem (const item : IUnknown;
                         index      : integer = 0) : integer;

    // looks through all items and returns the index of "item"
    function FindItem (const item: IUnknown) : integer;

    // swap two items
    function Swap (index1, index2: integer) : boolean;

    // delete an item (via index or via content)
    function DeleteItem (      index : integer ) : boolean; overload;
    function DeleteItem (const item  : IUnknown) : boolean; overload;

    // remove all items
    procedure Clear;

    // sort stuff...
    function  GetSortProc   : TCompareInterface;
    procedure SetSortProc   (value: TCompareInterface);
    property  SortProc      : TCompareInterface read GetSortProc write SetSortProc;
    function  GetSortParams (var func: TCompareInterface;
                             var down: boolean;
                             var info: integer) : boolean;
    procedure SetSortParams (    func: TCompareInterface;
                                 down: boolean = true;
                                 info: integer = 0   );
  end;

// create a new IInterfaceList
function NewInterfaceList : IInterfaceList; overload;
function NewInterfaceList (const items: array of IUnknown) : IInterfaceList; overload;

// ***************************************************************

type
  // function type that compares (sorts) two pointers; needed for IPointerList
  TComparePointer = function (const list: IList; item1, item2: pointer; info: integer) : integer;

  // some function types that simulate basic interface functions for pointers
  TDestroyPointerProc = procedure (var item: pointer);

  // pointer list
  IPointerList = interface (IList) ['{F6B8D485-40DB-11D3-A52D-00005A180D69}']
    // access to the items of the list
    function  GetItem   (index: integer) : pointer;
    procedure SetItem   (index: integer; item: pointer);
    property  Items     [index: integer] : pointer read GetItem write SetItem; default;

    // access to the capacity of the list
//    function  GetCapacity : integer;
    procedure SetCapacity (capacity: integer);
    property  Capacity    : integer read GetCapacity write SetCapacity;

    // add one or more items to the list
    // return value is the new index of the (first) added item
    function AddItem  (item        :          pointer) : integer;
    function AddItems (const items : array of pointer) : integer;

    // insert one item to the list
    function InsertItem (item  : pointer;
                         index : integer = 0) : integer;

    // looks through all items and returns the index of "item"
    function FindItem (item: pointer) : integer;

    // swap two items
    function Swap (index1, index2: integer) : boolean;

    // delete an item (via index or via content)
    function DeleteItem (index : integer) : boolean; overload;
    function DeleteItem (item  : pointer) : boolean; overload;

    // remove all items
    procedure Clear;

    // sort stuff...
    function  GetSortProc   : TComparePointer;
    procedure SetSortProc   (value: TComparePointer);
    property  SortProc      : TComparePointer read GetSortProc write SetSortProc;
    function  GetSortParams (var func: TComparePointer;
                             var down: boolean;
                             var info: integer) : boolean;
    procedure SetSortParams (    func: TComparePointer;
                                 down: boolean = true;
                                 info: integer = 0   );
  end;

// create a new IPointerList
function NewPointerList : IPointerList; overload;
function NewPointerList (const items : array of pointer;
                         destroyProc : TDestroyPointerProc = nil) : IPointerList; overload;

// ***************************************************************

implementation

uses Windows, madTypes;

// ***************************************************************

type
  // implements the final IBasicList interface
  TIBasicList = class (TICustomBasicList, IBasicList)
  public
    procedure SetItem (index: integer; const item: IBasic);

    function Swap (index1, index2: integer) : boolean;

    function DeleteItem (const item : IBasic) : boolean; overload;

    function GetMaxInterface : IBasic; override;
  end;

procedure TIBasicList.SetItem(index: integer; const item: IBasic);
var index_ : integer absolute index;
    ib     : IBasic;
begin
  FSection.Enter;
  try
    if CheckValid then
      if (index >= 0) and (index < FCount) then begin
        if item <> nil then begin
          if item.Index[self] = -1 then begin
            if FItemInfos[index] <> nil then begin
              Change(FItems[index], true, lctDeleted, index, -1);
              item.Selected[self] := false;
              item.Focused [self] := false;
              item.Checked [self] := no;
              with FItemInfos[index]^ do begin
                LastChangeType := lctDeleted;
                OldIndex       := Index;
                Index          := -1;
              end;
              ib := FItems[index];
              FItems[index] := nil;
              Change(ib, false, lctDeleted, index, -1);
              TIBasic(ib.SelfAsTObject).DelParent(self);
            end;
            FItems[index] := item;
            FItemInfos[index] := nil;
            if item <> nil then begin
              Change(item, true, lctNew, -1, index);
              FItemInfos[index] := TIBasic(item.SelfAsTObject).AddParent(self);
              with FItemInfos[index]^ do begin
                LastChangeType := lctNew;
                OldIndex       := -1;
                Index          := index_;
                Selected       := false;
                Focused        := false;
                Checked        := no;
              end;
              Change(item, false, lctNew, -1, index);
            end;
          end;
        end else SetLastError(ERROR_INVALID_PARAMETER);
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

function TIBasicList.Swap(index1, index2: integer) : boolean;
var i1 : integer;
    p1 : pointer;
begin
  FSection.Enter;
  try
    result := CheckValid;
    if result then begin
      result := (index1 >= 0) and (index2 >= 0) and (index1 < FCount) and (index2 < FCount);
      if result then begin
        if index1 <> index2 then begin
          if index1 > index2 then begin
            i1     := index1;
            index1 := index2;
            index2 := i1;
          end;
          Change(FItems[index1], true, lctChanged, index1, index2);
          Change(FItems[index2], true, lctChanged, index2, index1);
          p1                      := pointer(FItems[index1]);
          pointer(FItems[index1]) := pointer(FItems[index2]);
          pointer(FItems[index2]) := p1;
          p1                      := pointer(FItemInfos[index1]);
          pointer(FItemInfos[index1]) := pointer(FItemInfos[index2]);
          pointer(FItemInfos[index2]) := p1;
          if FItemInfos[index1] <> nil then
            with FItemInfos[index1]^ do begin
              LastChangeType := lctChanged;
              OldIndex       := index2;
              Index          := index1;
            end;
          if FItemInfos[index2] <> nil then
            with FItemInfos[index2]^ do begin
              LastChangeType := lctChanged;
              OldIndex       := index1;
              Index          := index2;
            end;
          Change(FItems[index1], false, lctChanged, index2, index1);
          Change(FItems[index2], false, lctChanged, index1, index2);
        end;
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
    end;
  finally FSection.Leave end;
end;

function TIBasicList.DeleteItem(const item: IBasic) : boolean;
var i1 : integer;
begin
  FSection.Enter;
  try
    i1 := item.Index[self];
    result := (i1 <> -1) and DeleteItem(i1);
  finally FSection.Leave end;
end;

function TIBasicList.GetMaxInterface : IBasic;
begin
  result := IBasicList(self);
end;

function NewBasicList : IBasicList;
begin
  result := TIBasicList.Create(true, 0, '');
end;

function NewBasicList(const items: array of IBasic) : IBasicList;
begin
  result := TIBasicList.Create(true, 0, '');
  result.AddItems(items);
end;

// ***************************************************************

type
  // implements IInterfaceList
  TIInterfaceList = class (TIList, IInterfaceList)
  public
    FItems    : TDAIUnknown;
    FSortProc : TCompareInterface;
    FSortDown : boolean;
    FSortInfo : integer;

    function  GetItem (index: integer) : IUnknown;
    procedure SetItem (index: integer; const item: IUnknown);

    procedure SetCapacity (capacity: integer); override;

    procedure Pack; override;

    function AddItem  (const item  :          IUnknown) : integer;
    function AddItems (const items : array of IUnknown) : integer;

    function InsertItem (const item : IUnknown;
                         index      : integer = 0) : integer;

    function FindItem (const item: IUnknown) : integer;

    function Swap (index1, index2: integer) : boolean;

    function DeleteItem (      index : integer ) : boolean; override;
    function DeleteItem (const item  : IUnknown) : boolean; overload;

    function  GetSortProc   : TCompareInterface;
    function  GetSortDown   : boolean; override;
    function  GetSortInfo   : integer; override;
    procedure SetSortProc   (value: TCompareInterface);
    procedure SetSortDown   (value: boolean); override;
    procedure SetSortInfo   (value: integer); override;
    function  GetSortParams (var func: TCompareInterface;
                             var down: boolean;
                             var info: integer) : boolean;
    procedure SetSortParams (    func: TCompareInterface;
                                 down: boolean = true;
                                 info: integer = 0   );

    function GetMaxInterface : IBasic; override;
  end;

function TIInterfaceList.GetItem(index: integer) : IUnknown;
begin
  FSection.Enter;
  try
    if (index < 0) or (index >= FCount) then
      raise MadException.Create(CErrorStr_IndexOutOfRange);
    result := FItems[index];
  finally FSection.Leave end;
end;

procedure TIInterfaceList.SetItem(index: integer; const item: IUnknown);
begin
  FSection.Enter;
  try
    if CheckValid then
      if (index >= 0) and (index < FCount) then
           FItems[index] := item
      else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

procedure TIInterfaceList.SetCapacity(capacity: integer);
var i1 : integer;
begin
  FSection.Enter;
  try
    if capacity <> FCapacity then begin
      for i1 := FCount - 1 downto capacity do
        DeleteItem(i1);
      SetLength(FItems, capacity);
      FCapacity := capacity;
      if FCount > FCapacity then FCount := FCapacity;
    end;
    FSuccess := true;
  finally FSection.Leave end;
end;

procedure TIInterfaceList.Pack;
var i1 : integer;
begin
  FSection.Enter;
  try
    for i1 := FCount-1 downto 0 do
      if FItems[i1] = nil then
        DeleteItem(i1);
    SetCapacity(FCount);
  finally FSection.Leave end;
end;

function TIInterfaceList.AddItem(const item: IUnknown) : integer;
var i1 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      if item <> nil then begin
        if (@FSortProc <> nil) and (FCount > 0) then begin
          if FSortDown then begin
            for i1 := 0 to FCount - 1 do
              if (FItems[i1] <> nil) and (FSortProc(IList(GetMaxInterface), FItems[i1], item, FSortInfo) >= 0) then
                break;
          end else
            for i1 := 0 to FCount - 1 do
              if (FItems[i1] = nil) or (FSortProc(IList(GetMaxInterface), item, FItems[i1], FSortInfo) >= 0) then
                break;
          result := InsertItem(item, i1);
        end else begin
          if FCount = FCapacity then Grow;
          result := FCount;
          FItems[result] := item;
          inc(FCount);
        end;
      end else SetLastError(ERROR_INVALID_PARAMETER);
  finally FSection.Leave end;
end;

function TIInterfaceList.AddItems(const items: array of IUnknown) : integer;
var i1, i2 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      for i1 := 0 to high(items) do begin
        i2 := AddItem(items[i1]);
        if (i2 < result) or (result = -1) then
          result := i2;
      end;
  finally FSection.Leave end;
end;

function TIInterfaceList.InsertItem(const item : IUnknown;
                                    index      : integer = 0) : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      if index >= 0 then begin
        if FCount = FCapacity then Grow;
        if index < FCount then begin
          Move(FItems[index], FItems[index + 1], (FCount - index) * 4);
          result := index;
          pointer(FItems[result]) := nil;
        end else result := FCount;
        FItems[result] := item;
        inc(FCount);
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

function TIInterfaceList.FindItem(const item: IUnknown) : integer;
begin
  FSuccess := true;
  FSection.Enter;
  try
    for result := 0 to FCount - 1 do
      if item = FItems[result] then
        exit;
    result := -1;
    SetLastError(ERROR_FILE_NOT_FOUND);
  finally FSection.Leave end;
end;

function TIInterfaceList.Swap(index1, index2: integer) : boolean;
var p1 : pointer;
begin
  FSection.Enter;
  try
    result := CheckValid;
    if result then begin
      result := (index1 >= 0) and (index2 >= 0) and (index1 < FCount) and (index2 < FCount);
      if result then begin
        if index1 <> index2 then begin
          p1                      := pointer(FItems[index1]);
          pointer(FItems[index1]) := pointer(FItems[index2]);
          pointer(FItems[index2]) := p1;
        end;
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
    end;
  finally FSection.Leave end;
end;

function TIInterfaceList.DeleteItem(index: integer) : boolean;
begin
  FSection.Enter;
  try
    result := (index >= 0) and (index < FCount);
    if result then begin
      FSuccess := true;
      FItems[index] := nil;
      dec(FCount);
      if index < FCount then begin
        Move(FItems[index+1], FItems[index], (FCount - index) * 4);
        pointer(FItems[FCount]) := nil;
      end;
    end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

function TIInterfaceList.DeleteItem(const item: IUnknown) : boolean;
var i1 : integer;
begin
  FSection.Enter;
  try
    i1 := FindItem(item);
    result := (i1 <> -1) and DeleteItem(i1);
  finally FSection.Leave end;
end;

function TIInterfaceList.GetSortProc : TCompareInterface;
begin
  result := FSortProc;
end;

function TIInterfaceList.GetSortDown : boolean;
begin
  result := FSortDown;
end;

function TIInterfaceList.GetSortInfo : integer;
begin
  result := FSortInfo;
end;

procedure TIInterfaceList.SetSortProc(value: TCompareInterface);
begin
  SetSortParams(value, true, FSortInfo);
end;

procedure TIInterfaceList.SetSortDown(value: boolean);
begin
  SetSortParams(FSortProc, value, FSortInfo);
end;

procedure TIInterfaceList.SetSortInfo(value: integer);
begin
  SetSortParams(FSortProc, FSortDown, value);
end;

function TIInterfaceList.GetSortParams(var func: TCompareInterface;
                                       var down: boolean;
                                       var info: integer) : boolean;
begin
  FSection.Enter;
  try
    func := FSortProc;
    down := FSortDown;
    info := FSortInfo;
    result := @FSortProc <> nil;
  finally FSection.Leave end;
end;

procedure TIInterfaceList.SetSortParams(func: TCompareInterface;
                                        down: boolean = true;
                                        info: integer = 0   );
begin
  FSection.Enter;
  try
    if CheckValid then
      if (@func <> @FSortProc) or (down <> FSortDown) or (info <> FSortInfo) then begin
        FSortProc := func;
        FSortDown := down;
        FSortInfo := info;
        if (@FSortProc <> nil) and (FCount > 0) then
          QuickSort(FItems[0], pointer(nil^), 0, FCount - 1, @FSortProc, FSortDown, FSortInfo);
      end;
  finally FSection.Leave end;
end;

function TIInterfaceList.GetMaxInterface : IBasic;
begin
  result := IInterfaceList(self);
end;

function NewInterfaceList : IInterfaceList;
begin
  result := TIInterfaceList.Create(true, 0, '');
end;

function NewInterfaceList(const items: array of IUnknown) : IInterfaceList;
begin
  result := TIInterfaceList.Create(true, 0, '');
  result.AddItems(items);
end;

// ***************************************************************

type
  // pointer list
  TIPointerList = class (TIList, IPointerList)
  public
    FItems       : TDAPointer;
    FDestroyProc : TDestroyPointerProc;
    FSortProc    : TComparePointer;
    FSortDown    : boolean;
    FSortInfo    : integer; 

    constructor Create (valid: boolean; lastErrorNo: cardinal; lastErrorStr: string;
                        destroyProc : TDestroyPointerProc);

    function  GetItem (index: integer) : pointer;
    procedure SetItem (index: integer; item: pointer);

    procedure SetCapacity (capacity: integer); override;

    procedure Pack; override;

    function AddItem  (item        :          pointer) : integer;
    function AddItems (const items : array of pointer) : integer;

    function InsertItem (item  : pointer;
                         index : integer = 0) : integer;

    function FindItem (item: pointer) : integer;

    function Swap (index1, index2: integer) : boolean;

    function DeleteItem (index : integer) : boolean; override;
    function DeleteItem (item  : pointer) : boolean; overload;

    function  GetSortProc : TComparePointer;
    function  GetSortDown : boolean; override;
    function  GetSortInfo : integer; override;
    procedure SetSortProc (value: TComparePointer);
    procedure SetSortDown (value: boolean); override;
    procedure SetSortInfo (value: integer); override;
    function  GetSortParams (var func: TComparePointer;
                             var down: boolean;
                             var info: integer) : boolean;
    procedure SetSortParams (    func: TComparePointer;
                                 down: boolean = true;
                                 info: integer = 0   );

    function GetMaxInterface : IBasic; override;
  end;

constructor TIPointerList.Create(valid: boolean; lastErrorNo: cardinal; lastErrorStr: string;
                                 destroyProc : TDestroyPointerProc);
begin
  inherited Create(valid, lastErrorNo, lastErrorStr);
  if FValid then
    FDestroyProc := destroyProc;
end;

function TIPointerList.GetItem(index: integer) : pointer;
begin
  FSection.Enter;
  try
    if (index < 0) or (index >= FCount) then begin
      result := nil;
      raise MadException.Create(CErrorStr_IndexOutOfRange);
    end;
    result := FItems[index];
  finally FSection.Leave end; 
end;

procedure TIPointerList.SetItem(index: integer; item: pointer);
begin
  FSection.Enter;
  try
    if CheckValid then
      if (index >= 0) and (index < FCount) then begin
        if (FItems[index] <> nil) and (@FDestroyProc <> nil) then
          FDestroyProc(FItems[index]);
        FItems[index] := item;
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

procedure TIPointerList.SetCapacity(capacity: integer);
var i1 : integer;
begin
  FSection.Enter;
  try
    if capacity <> FCapacity then begin
      for i1 := FCount - 1 downto capacity do
        DeleteItem(i1);
      SetLength(FItems, capacity);
      FCapacity := capacity;
      if FCount > FCapacity then FCount := FCapacity;
    end;
    FSuccess := true;
  finally FSection.Leave end;
end;

procedure TIPointerList.Pack;
var i1 : integer;
begin
  FSection.Enter;
  try
    for i1 := FCount-1 downto 0 do
      if FItems[i1] = nil then
        DeleteItem(i1);
    SetCapacity(FCount);
  finally FSection.Leave end;
end;

function TIPointerList.AddItem(item: pointer) : integer;
var i1 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      if item <> nil then begin
        if (@FSortProc <> nil) and (FCount > 0) then begin
          if FSortDown then begin
            for i1 := 0 to FCount - 1 do
              if (FItems[i1] <> nil) and (FSortProc(IList(GetMaxInterface), FItems[i1], item, FSortInfo) >= 0) then
                break;
          end else
            for i1 := 0 to FCount - 1 do
              if (FItems[i1] = nil) or (FSortProc(IList(GetMaxInterface), item, FItems[i1], FSortInfo) >= 0) then
                break;
          result := InsertItem(item, i1);
        end else begin
          if FCount = FCapacity then Grow;
          result := FCount;
          FItems[result] := item;
          inc(FCount);
        end;
      end else SetLastError(ERROR_INVALID_PARAMETER);
  finally FSection.Leave end;
end;

function TIPointerList.AddItems(const items: array of pointer) : integer;
var i1, i2 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      for i1 := 0 to high(items) do begin
        i2 := AddItem(items[i1]);
        if (i2 < result) or (result = -1) then
          result := i2;
      end;
  finally FSection.Leave end;
end;

function TIPointerList.InsertItem(item  : pointer;
                                  index : integer = 0) : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      if index >= 0 then begin
        if FCount = FCapacity then Grow;
        if index < FCount then begin
          Move(FItems[index], FItems[index + 1], (FCount - index) * 4);
          result := index;
          FItems[result] := nil;
        end else result := FCount;
        FItems[result] := item;
        inc(FCount);
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

function TIPointerList.FindItem(item: pointer) : integer;
begin
  FSuccess := true;
  FSection.Enter;
  try
    for result := 0 to FCount - 1 do
      if item = FItems[result] then
        exit;
    result := -1;
    SetLastError(ERROR_FILE_NOT_FOUND);
  finally FSection.Leave end;
end;

function TIPointerList.Swap(index1, index2: integer) : boolean;
var p1 : pointer;
begin
  FSection.Enter;
  try
    result := CheckValid;
    if result then begin
      result := (index1 >= 0) and (index2 >= 0) and (index1 < FCount) and (index2 < FCount);
      if result then begin
        if index1 <> index2 then begin
          p1             := FItems[index1];
          FItems[index1] := FItems[index2];
          FItems[index2] := p1;
        end;
      end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
    end;
  finally FSection.Leave end;
end;

function TIPointerList.DeleteItem(index: integer) : boolean;
begin
  FSection.Enter;
  try
    result := (index >= 0) and (index < FCount);
    if result then begin
      FSuccess := true;
      FItems[index] := nil;
      dec(FCount);
      if index < FCount then begin
        Move(FItems[index+1], FItems[index], (FCount - index) * 4);
        FItems[FCount] := nil;
      end;
    end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

function TIPointerList.DeleteItem(item: pointer) : boolean;
var i1 : integer;
begin
  FSection.Enter;
  try
    i1 := FindItem(item);
    result := (i1 <> -1) and DeleteItem(i1);
  finally FSection.Leave end;
end;

function TIPointerList.GetSortProc : TComparePointer;
begin
  result := FSortProc;
end;

function TIPointerList.GetSortDown : boolean;
begin
  result := FSortDown;
end;

function TIPointerList.GetSortInfo : integer;
begin
  result := FSortInfo;
end;

procedure TIPointerList.SetSortProc(value: TComparePointer);
begin
  SetSortParams(value, true, FSortInfo);
end;

procedure TIPointerList.SetSortDown(value: boolean);
begin
  SetSortParams(FSortProc, value, FSortInfo);
end;

procedure TIPointerList.SetSortInfo(value: integer);
begin
  SetSortParams(FSortProc, FSortDown, value);
end;

function TIPointerList.GetSortParams(var func: TComparePointer;
                                     var down: boolean;
                                     var info: integer) : boolean;
begin
  FSection.Enter;
  try
    func := FSortProc;
    down := FSortDown;
    info := FSortInfo;
    result := @FSortProc <> nil;
  finally FSection.Leave end;
end;

procedure TIPointerList.SetSortParams(func: TComparePointer;
                                      down: boolean = true;
                                      info: integer = 0   );
begin
  FSection.Enter;
  try
    if CheckValid then
      if (@func <> @FSortProc) or (down <> FSortDown) or (info <> FSortInfo) then begin
        FSortProc := func;
        FSortDown := down;
        FSortInfo := info;
        if (@FSortProc <> nil) and (FCount > 0) then
          QuickSort(FItems[0], pointer(nil^), 0, FCount - 1, @FSortProc, FSortDown, FSortInfo);
      end;
  finally FSection.Leave end;
end;

function TIPointerList.GetMaxInterface : IBasic;
begin
  result := IPointerList(self);
end;

function NewPointerList : IPointerList;
begin
  result := TIPointerList.Create(true, 0, '', nil);
end;

function NewPointerList(const items : array of pointer;
                        destroyProc : TDestroyPointerProc = nil) : IPointerList;
begin
  result := TIPointerList.Create(true, 0, '', destroyProc);
  result.AddItems(items);
end;

// ***************************************************************

end.