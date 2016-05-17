// ***************************************************************
//  madBasic.pas              version:  1.6f  ·  date: 2006-01-25
//  -------------------------------------------------------------
//  basic interfaces and tool functions
//  -------------------------------------------------------------
//  Copyright (C) 1999 - 2006 www.madshi.net, All Rights Reserved
// ***************************************************************

// 2006-01-25 1.6f refcount bug in TICustomBasicList.AddItem/InsertItem fixed
// 2005-03-09 1.6e bug in handling with multiple lists fixed
// 2002-01-09 1.6d TIBasic.AfterConstruction added to ease reference counting
// 2000-10-31 1.6c little bug in TICustomBasicList.AddItem fixed
// 2000-09-14 1.6b TBasic.Checked converted from boolean to TExtBool
// 2000-07-25 1.6a minor changes in order to get rid of SysUtils

unit madBasic;

{$I mad.inc}

interface

uses madTypes;

// ***************************************************************

type
  // forward
  ICustomBasicList = interface;

  // *******************************************************************

  // for IBasic.Data/SetData/SetDataObject
  TDataDestroyProc   = procedure (var data: pointer);
  TDataDestroyProcOO = procedure (var data: pointer) of object;

  // types for IBasic.LastChangeType
  TChangeType = (lctUnchanged, lctChanged, lctNew, lctDeleted);

  // base interface for all madInterfaces...
  IBasic = interface ['{53F8CE42-2C8A-11D3-A52D-00005A180D69}']
    // tests whether "IID" is supported by this object
    function Supports (const IID: TGuid) : boolean;

    // returns the interface "IID", if this object supports it
    function GetInterface (const IID: TGuid; out obj) : boolean;

    // returns the object, that implements this IBasic interface
    function SelfAsTObject : TObject;

    // no madFunctions return "nil" when an error occurs
    // instead they return a "dummy" interface with "IsValid = false"
    function IsValid : boolean;

    // did the last command/call succeed?
    function Success : boolean;

    // check the last error when Success or IsValid returns false...
    function  GetLastErrorNo  : cardinal;
    function  GetLastErrorStr : string;
    procedure SetLastErrorNo  (no  : cardinal   );
    procedure SetLastErrorStr (str : string     );
    procedure SetLastError    (no  : cardinal;
                               str : string = '');
    property  LastErrorNo     : cardinal read GetLastErrorNo  write SetLastErrorNo;
    property  LastErrorStr    : string   read GetLastErrorStr write SetLastErrorStr;

    // multi purpose string
    function  GetStrBuf : string;
    procedure SetStrBuf (buf: string);
    property  StrBuf    : string read GetStrBuf write SetStrBuf;

    // you can attach a "data" pointer to each IBasic interface
    function  GetData : pointer;
    procedure SetData (data: pointer); overload;
    property  Data    : pointer read GetData write SetData;

    // if you want, tell the IBasic interface how to destroy "data"
    procedure SetData (data            : pointer;
                       dataDestroyProc : TDataDestroyProc  ); overload;
    procedure SetData (data            : pointer;
                       dataDestroyProc : TDataDestroyProcOO); overload;

    // if our interface is an item of any ICustomBasicList, you can use this stuff
    function  GetIndex          (const parent: ICustomBasicList) : integer;
    function  GetOldIndex       (const parent: ICustomBasicList) : integer;
    function  GetLastChangeType (const parent: ICustomBasicList) : TChangeType;
    function  GetSelected       (const parent: ICustomBasicList) : boolean;
    function  GetFocused        (const parent: ICustomBasicList) : boolean;
    function  GetChecked        (const parent: ICustomBasicList) : TExtBool;
    procedure SetSelected       (const parent: ICustomBasicList; value: boolean );
    procedure SetFocused        (const parent: ICustomBasicList; value: boolean );
    procedure SetChecked        (const parent: ICustomBasicList; value: TExtBool);
    property  Index             [const parent: ICustomBasicList] : integer     read GetIndex;
    property  OldIndex          [const parent: ICustomBasicList] : integer     read GetOldIndex;
    property  LastChangeType    [const parent: ICustomBasicList] : TChangeType read GetLastChangeType;
    property  Selected          [const parent: ICustomBasicList] : boolean     read GetSelected write SetSelected;
    property  Focused           [const parent: ICustomBasicList] : boolean     read GetFocused  write SetFocused;
    property  Checked           [const parent: ICustomBasicList] : TExtBool    read GetChecked  write SetChecked;
  end;

  // extension to the types unit
  TDABasic = array of IBasic;

  // *******************************************************************

  // the very base class of all lists, only read access, only some properties
  IList = interface (IBasic) ['{F6B8D483-40DB-11D3-A52D-00005A180D69}']
    // how many items does this list have right now?
    function GetItemCount : integer;
    property ItemCount    : integer read GetItemCount;

    // how many items could this list hold without being forced to reallocate?
    function GetCapacity : integer;
    property Capacity    : integer read GetCapacity;

    // remove all "nil" items
    procedure Pack;

    // sort stuff...
    function  GetSortDown : boolean;
    function  GetSortInfo : integer;
    procedure SetSortDown (value: boolean);
    procedure SetSortInfo (value: integer);
    property  SortDown    : boolean read GetSortDown write SetSortDown;
    property  SortInfo    : integer read GetSortInfo write SetSortInfo;

    // critical section stuff
    procedure Lock;
    function  Unlock : boolean;

    // counts the number of selected items
    function GetSelectedCount : integer;
    property SelectedCount    : integer read GetSelectedCount;

    // which item is focused?
    function GetFocusedItem : IBasic;
    property FocusedItem    : IBasic read GetFocusedItem;

    // which was the last focused item?
    function  GetLastFocusedItem : IBasic;
    procedure SetLastFocusedItem (value: IBasic);
    property  LastFocusedItem    : IBasic read GetLastFocusedItem write SetLastFocusedItem;
  end;

  // *******************************************************************

  // function type that compares (sorts) two IBasic interfaces; needed for ICustomBasicList
  TCompareBasic = function (const list: IList; const item1, item2: IBasic; info: integer) : integer;

  // function types for the change events
  TIListChangeEvent   = procedure (const list: ICustomBasicList; const item: IBasic;
                                   beforeChange: boolean;
                                   changeType: TChangeType; oldIndex, index: integer);
  TIListChangeEventOO = procedure (const list: ICustomBasicList; const item: IBasic;
                                   beforeChange: boolean;
                                   changeType: TChangeType; oldIndex, index: integer) of object;

  // base interface for a lot of list like interface, e.g. IProcesses, ITrayIcons...
  ICustomBasicList = interface (IList) ['{EE6D35A0-5F85-11D3-A52D-00005A180D69}']
    // read access to the items of the list
    function BasicItem (index: integer) : IBasic;
    property Items     [index: integer] : IBasic read BasicItem; default;

    // sort stuff...
    function  GetSortProc   : TCompareBasic;
    procedure SetSortProc   (value: TCompareBasic);
    property  SortProc      : TCompareBasic read GetSortProc write SetSortProc;
    function  GetSortParams (var func: TCompareBasic;
                             var down: boolean;
                             var info: integer) : boolean;
    function  SetSortParams (    func: TCompareBasic;
                                 down: boolean = true;
                                 info: integer = 0   ) : boolean; 

    // change events...
    procedure  RegisterChangeEvent (changeEvent: TIListChangeEvent  ); overload;
    procedure  RegisterChangeEvent (changeEvent: TIListChangeEventOO); overload;
    function UnregisterChangeEvent (changeEvent: TIListChangeEvent  ) : boolean; overload;
    function UnregisterChangeEvent (changeEvent: TIListChangeEventOO) : boolean; overload;
  end;

  // *******************************************************************

  // this list holds some specific items of its parent list
  IBasicListSelection = interface (ICustomBasicList) ['{AB8893E0-8A39-11D3-A52E-00005A180D69}']
    // get the parent list
    function GetParentList : ICustomBasicList;
    property ParentList    : ICustomBasicList read GetParentList;
  end;

// ***************************************************************

type
  // encapsulation of the criticalSection APIs
  ICriticalSection  = interface (IBasic) ['{82546200-8D73-11D3-A52E-00005A180D69}']
    // EnterCriticalSection
    procedure Enter;

    // TryEnterCriticalSection  (not available under win95)
    function TryEnter : boolean;

    // LeaveCriticalSection, extended by a valid return value
    function Leave : boolean;

    // returns the ID of the thread that owns this critical section
    // and how often this thread entered the critical section successfully
    // if the critical section is not owned by the current thread these
    // informations can change at any time, namely in that moment when another
    // thread enters or leaves the critical section
    function OwnerThread : cardinal;
    function LockCount   : integer;

    // is this section owned by the current thread?
    // this information cannot be influenced by another thread
    // if the result is true, "OwnerThread" and "LockCount" cannot be changed
    // by another thread, either
    function IsOwnedByCurrentThread : boolean;
  end;

// create a new critical section
function NewCriticalSection : ICriticalSection;

// ***************************************************************

const
  // error bases for all units
  CErrorBase_Basic    = $10000;
  CErrorBase_Except   = $20000;
  CErrorBase_Kernel   = $30000;
  CErrorBase_Lists    = $40000;
  CErrorBase_Security = $50000;
  CErrorBase_Shell    = $60000;

  // error codes
  CErrorNo_InvalidClass           = CErrorBase_Basic + 0;
  CErrorNo_AmInvalid              = CErrorBase_Basic + 1;
  CErrorNo_InvalidIndex           = CErrorBase_Basic + 2;
  CErrorNo_SectionBlocked         = CErrorBase_Basic + 3;
  CErrorNo_SectionLeaveError      = CErrorBase_Basic + 4;
  CErrorNo_Unknown                = CErrorBase_Basic + 5;
  CErrorNo_IndexOutOfRange        = CErrorBase_Basic + 6;
  CErrorStr_InvalidClass          = 'Invalid class.';
  CErrorStr_AmInvalid             = 'This object is invalid.';
  CErrorStr_InvalidIndex          = 'Invalid index.';
  CErrorStr_SectionBlocked        = 'The critical section is already owned by another thread.';
  CErrorStr_SectionLeaveError     = 'The critical section is owned by another thread.';
  CErrorStr_Unknown               = 'Unknown error.';
  CErrorStr_IndexOutOfRange       = 'Index out of range.';

// ***************************************************************

type
  // forward
  TICustomBasicList = class;

  // types for TIBasic.FParentInfos and TICustomBasicList.FItemInfos
  TBasicItemInfo = record
    Parent         : TICustomBasicList;
    Index          : integer;
    OldIndex       : integer;
    LastChangeType : TChangeType;
    Selected       : boolean;
    Focused        : boolean;
    Checked        : TExtBool;
  end;
  TPBasicItemInfo = ^TBasicItemInfo;

  // TIBasic implements already some functions of IBasic, but not all
  TIBasic = class (TObject, IUnknown, IBasic)
  public
    FRefCount          : integer;
    FValid             : boolean;
    FSuccess           : boolean;
    FLastErrorNo       : cardinal;
    FLastErrorStr      : string;
    FStrBuf            : string;
    FData              : pointer;
    FDataDestroyProc   : TDataDestroyProc;
    FDataDestroyProcOO : TDataDestroyProcOO;
    FParentInfos       : array of TPBasicItemInfo;

    constructor Create (valid: boolean; lastErrorNo: cardinal; lastErrorStr: string);
    destructor Destroy; override;
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    class function NewInstance : TObject; override;

    function QueryInterface (const iid: TGUID; out obj) : HResult; stdcall;
    function _AddRef        : integer; virtual; stdcall;
    function _Release       : integer; virtual; stdcall;

    function Supports (const IID: TGUID) : boolean;

    function SelfAsTObject : TObject;

    function IsValid : boolean;

    function Success : boolean;

    function  GetLastErrorNo  : cardinal;
    function  GetLastErrorStr : string;
    procedure SetLastErrorNo  (no  : cardinal   );
    procedure SetLastErrorStr (str : string     );
    procedure SetLastError    (no  : cardinal;
                               str : string = '');

    function  GetStrBuf : string;
    procedure SetStrBuf (buf: string);

    function  GetData : pointer;
    procedure SetData (data: pointer); overload;
    property  Data    : pointer read GetData write SetData;

    procedure SetData (data            : pointer;
                       dataDestroyProc : TDataDestroyProc  ); overload;
    procedure SetData (data            : pointer;
                       dataDestroyProc : TDataDestroyProcOO); overload;

    function  GetIndex          (const parent: ICustomBasicList) : integer;
    function  GetOldIndex       (const parent: ICustomBasicList) : integer;
    function  GetLastChangeType (const parent: ICustomBasicList) : TChangeType;
    function  GetSelected       (const parent: ICustomBasicList) : boolean;
    function  GetFocused        (const parent: ICustomBasicList) : boolean;
    function  GetChecked        (const parent: ICustomBasicList) : TExtBool;
    procedure SetLastChangeType (const parent: ICustomBasicList; value: TChangeType);
    procedure SetSelected       (const parent: ICustomBasicList; value: boolean );
    procedure SetFocused        (const parent: ICustomBasicList; value: boolean );
    procedure SetChecked        (const parent: ICustomBasicList; value: TExtBool);

    // does all that is needed to add this object to yet another list
    function  AddParent (parent: TICustomBasicList) : TPBasicItemInfo;

    // removes this object from a list
    procedure DelParent (parent: TICustomBasicList);

    // same as IsValid
    // but if the result is false, LastError is being set to CError_AmInvalid
    function CheckValid : boolean;

    // returns our instance in the form of the highest possible interface
    function GetMaxInterface : IBasic; virtual; abstract;
  end;

  // *******************************************************************

  // TIList implements a part of IList
  TIList = class (TIBasic, IList)
  public
    FCount           : integer;
    FCapacity        : integer;
    FSection         : ICriticalSection;
    FSelectedCount   : integer;
    FFocusedItem     : IBasic;
    FLastFocusedItem : IBasic;

    constructor Create (valid: boolean; lastErrorNo: cardinal; lastErrorStr: string);
    destructor Destroy; override;

    function GetItemCount : integer; virtual;

    function GetCapacity : integer;

    procedure Pack; virtual; abstract;

    function  GetSortDown : boolean; virtual; abstract;
    function  GetSortInfo : integer; virtual; abstract;
    procedure SetSortDown (value: boolean); virtual; abstract;
    procedure SetSortInfo (value: integer); virtual; abstract;

    procedure Lock;             virtual;
    function  Unlock : boolean; virtual;

    function GetSelectedCount : integer;

    function GetFocusedItem : IBasic;

    function  GetLastFocusedItem : IBasic;
    procedure SetLastFocusedItem (value: IBasic);

    // not visible in IList, but in descendants
    procedure SetCapacity (capacity: integer); virtual; abstract;
    function  DeleteItem  (index   : integer) : boolean; overload; virtual; abstract;
    procedure Clear;      virtual;

    // increase the capacity to the next sensible level
    procedure Grow;

    // sorts the items
    function QuickSort (var items1, items2;
                        l, r        : integer;
                        compareProc : pointer;
                        down        : boolean;
                        info        : integer        ) : boolean;
  end;

  // *******************************************************************

  // implements most of ICustomBasicList and some parts of IBasicList already
  TICustomBasicList = class (TIList, ICustomBasicList)
  public
    FOnChange   : array of TIListChangeEvent;
    FOnChangeOO : array of TIListChangeEventOO;
    FItems      : array of IBasic;
    FItemInfos  : array of TPBasicItemInfo;
    FSortProc   : TCompareBasic;
    FSortDown   : boolean;
    FSortInfo   : integer;

    destructor Destroy; override;

    function BasicItem (index: integer) : IBasic; virtual;

    procedure Pack; override;

    function  GetSortProc   : TCompareBasic; virtual;
    function  GetSortDown   : boolean; override;
    function  GetSortInfo   : integer; override;
    procedure SetSortProc   (value: TCompareBasic); virtual;
    procedure SetSortDown   (value: boolean); override;
    procedure SetSortInfo   (value: integer); override;
    function  GetSortParams (var func: TCompareBasic;
                             var down: boolean;
                             var info: integer) : boolean; virtual;
    function  SetSortParams (    func: TCompareBasic;
                                 down: boolean = true;
                                 info: integer = 0   ) : boolean; virtual;

    procedure  RegisterChangeEvent (changeEvent: TIListChangeEvent  ); overload;
    procedure  RegisterChangeEvent (changeEvent: TIListChangeEventOO); overload;
    function UnregisterChangeEvent (changeEvent: TIListChangeEvent  ) : boolean; overload;
    function UnregisterChangeEvent (changeEvent: TIListChangeEventOO) : boolean; overload;

    procedure SetCapacity (capacity: integer); override;

    function AddItem  (const item  :          IBasic) : integer; virtual;
    function AddItems (const items : array of IBasic) : integer;

    function InsertItem (const item : IBasic;
                         index      : integer = 0) : integer; virtual;

    function DeleteItem (index: integer) : boolean; overload; override;

    // sends a changeEvent to all registered event handlers
    procedure Change (const item   : IBasic;
                      beforeChange : boolean;
                      changeType   : TChangeType;
                      oldIndex     : integer;
                      index        : integer    );

    // during a refresh all items are again added to the list
    // after the refresh all items that were not added again, are deleted automatically
    procedure BeginRefresh; virtual;
    procedure EndRefresh;   virtual;

    // moves the item with the "index" to the right place within the list
    function SortItem (index: integer) : integer;
  end;

  // *******************************************************************

  // implements a part of IBasicListSelection
  TIBasicListSelection = class (TICustomBasicList, IBasicListSelection)
  public
    FParentList : ICustomBasicList;

    constructor Create (valid: boolean; lastErrorNo: cardinal; lastErrorStr: string;
                        const parentList: ICustomBasicList; copyParentList: boolean);
    destructor Destroy; override;

    function GetParentList : ICustomBasicList;

    // this function tests, whether the "item" fits the selection conditions
    function CheckItem (const item: IBasic) : boolean; virtual; abstract;

    // handles change events of the parent list
    procedure ParentListChanged (const list: ICustomBasicList; const item: IBasic;
                                 beforeChange: boolean; changeType: TChangeType; oldIndex, index: integer);
  end;

// ***************************************************************

implementation

uses Windows, madStrings;

// ***************************************************************

constructor TIBasic.Create(valid: boolean; lastErrorNo: cardinal; lastErrorStr: string);
begin
  inherited Create;
  FValid := valid;
  FSuccess := FValid;
  if not FValid then begin
    FLastErrorNo  := lastErrorNo;
    FLastErrorStr := lastErrorStr;
  end;
end;

destructor TIBasic.Destroy;
begin
  SetData(nil, nil);
  inherited;
end;

procedure TIBasic.AfterConstruction;
begin
  InterlockedDecrement(FRefCount);
end;

procedure TIBasic.BeforeDestruction;
begin
  if FRefCount <> 0 then
    raise MadException.Create('Interface with reference count >0 destroyed.');
end;

class function TIBasic.NewInstance : TObject;
begin
  result := inherited NewInstance;
  TIBasic(result).FRefCount := 1;
end;

function TIBasic.QueryInterface(const iid: TGUID; out obj) : HResult;
begin
  if not GetInterface(iid, obj) then begin
    result := E_NOINTERFACE;
    SetLastError(cardinal(E_NOINTERFACE));
  end else begin
    result := 0;
    FSuccess := true;
  end;
end;

function TIBasic._AddRef : integer;
begin
  result := InterlockedIncrement(FRefCount);
end;

function TIBasic._Release : integer;
begin
  result := InterlockedDecrement(FRefCount);
  if result = 0 then Destroy;
end;

function TIBasic.Supports(const IID: TGUID) : boolean;
var iu1 : IUnknown;
begin
  result := GetInterface(IID, iu1);
  if result then FSuccess := true
  else           SetLastError(cardinal(E_NOINTERFACE));
end;

function TIBasic.SelfAsTObject : TObject;
begin
  result := self;
end;

function TIBasic.IsValid : boolean;
begin
  result := (self <> nil) and FValid;
end;

function TIBasic.Success : boolean;
begin
  result := FSuccess;
end;

function TIBasic.GetLastErrorNo : cardinal;
begin
  result := FLastErrorNo;
end;

function TIBasic.GetLastErrorStr : string;
begin
  if (FLastErrorStr = '') and (FLastErrorNo <> 0) then
    FLastErrorStr := ErrorCodeToStr(FLastErrorNo);
  result := FLastErrorStr;
end;

procedure TIBasic.SetLastErrorNo(no: cardinal);
begin
  FLastErrorNo := no;
  if FLastErrorNo = 0 then FLastErrorStr := '';
  FSuccess := FLastErrorNo = 0;
end;

procedure TIBasic.SetLastErrorStr(str: string);
begin
  FLastErrorStr := str;
  if FLastErrorStr = '' then FLastErrorNo := 0;
  FSuccess := FLastErrorNo = 0;
end;

procedure TIBasic.SetLastError(no: cardinal; str: string = '');
begin
  FLastErrorNo  := no;
  FLastErrorStr := str;
  FSuccess := FLastErrorNo = 0;
end;

function TIBasic.GetStrBuf : string;
begin
  result := FStrBuf;
end;

procedure TIBasic.SetStrBuf(buf: string);
begin
  FStrBuf := buf;
end;

function TIBasic.GetData : pointer;
begin
  result := FData;
end;

procedure TIBasic.SetData(data: pointer);
begin
  if CheckValid then begin
    if FData <> nil then
      if      @FDataDestroyProc   <> nil then FDataDestroyProc  (FData)
      else if @FDataDestroyProcOO <> nil then FDataDestroyProcOO(FData);
    FData := data;
  end;
end;

procedure TIBasic.SetData(data            : pointer;
                          dataDestroyProc : TDataDestroyProc);
begin
  if CheckValid then begin
    if FData <> nil then
      if      @FDataDestroyProc   <> nil then FDataDestroyProc  (FData)
      else if @FDataDestroyProcOO <> nil then FDataDestroyProcOO(FData);
    FData              := data;
    FDataDestroyProc   := dataDestroyProc;
    FDataDestroyProcOO := nil;
  end;
end;

procedure TIBasic.SetData(data            : pointer;
                          dataDestroyProc : TDataDestroyProcOO);
begin
  if CheckValid then begin
    if FData <> nil then
      if      @FDataDestroyProc   <> nil then FDataDestroyProc  (FData)
      else if @FDataDestroyProcOO <> nil then FDataDestroyProcOO(FData);
    FData              := data;
    FDataDestroyProcOO := dataDestroyProc;
    FDataDestroyProc   := nil;
  end;
end;

function TIBasic.GetIndex(const parent: ICustomBasicList) : integer;
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        result := FParentInfos[i1].Index;
        exit;
      end;
  end;
  result := -1;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

function TIBasic.GetOldIndex(const parent: ICustomBasicList) : integer;
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        result := FParentInfos[i1].OldIndex;
        exit;
      end;
  end;
  result := -1;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

function TIBasic.GetLastChangeType(const parent: ICustomBasicList) : TChangeType;
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        result := FParentInfos[i1].LastChangeType;
        exit;
      end;
  end;
  result := lctUnchanged;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

function TIBasic.GetSelected(const parent: ICustomBasicList) : boolean;
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        result := FParentInfos[i1].Selected;
        exit;
      end;
  end;
  result := false;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

function TIBasic.GetFocused(const parent: ICustomBasicList) : boolean;
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        result := FParentInfos[i1].Focused;
        exit;
      end;
  end;
  result := false;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

function TIBasic.GetChecked(const parent: ICustomBasicList) : TExtBool;
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        result := FParentInfos[i1].Checked;
        exit;
      end;
  end;
  result := no;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

procedure TIBasic.SetLastChangeType(const parent: ICustomBasicList; value: TChangeType);
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        FParentInfos[i1].LastChangeType := value;
        exit;
      end;
  end;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

procedure TIBasic.SetSelected(const parent: ICustomBasicList; value: boolean);
var list : TIList;
    i1   : integer;
begin
  if FParentInfos <> nil then begin
    list := TIList(parent.SelfAsTObject);
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = list then begin
        if FParentInfos[i1].Selected <> value then begin
          FParentInfos[i1].Selected := value;
          if value then inc(list.FSelectedCount)
          else          dec(list.FSelectedCount);
        end;
        exit;
      end;
  end;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

procedure TIBasic.SetFocused(const parent: ICustomBasicList; value: boolean);
var list : TIList;
    i1   : integer;
begin
  if FParentInfos <> nil then begin
    list := TIList(parent.SelfAsTObject);
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = list then begin
        if FParentInfos[i1].Focused <> value then begin
          FParentInfos[i1].Focused := value;
          if not value then begin
            if (list.FFocusedItem <> nil) and (list.FFocusedItem.SelfAsTObject = self) then
              list.FFocusedItem := nil;
          end else list.FFocusedItem := GetMaxInterface;
        end;
        exit;
      end;
  end;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

procedure TIBasic.SetChecked(const parent: ICustomBasicList; value: TExtBool);
var obj : TObject;
    i1  : integer;
begin
  if FParentInfos <> nil then begin
    obj := parent.SelfAsTObject;
    for i1 := 0 to high(FParentInfos) do
      if FParentInfos[i1].parent = obj then begin
        FParentInfos[i1].Checked := value;
        exit;
      end;
  end;
  SetLastError(ERROR_FILE_NOT_FOUND);
end;

function TIBasic.AddParent(parent: TICustomBasicList) : TPBasicItemInfo;
var i1 : integer;
begin
  i1 := Length(FParentInfos);
  SetLength(FParentInfos, i1 + 1);
  New(result);
  FParentInfos[i1] := result;
  FParentInfos[i1].parent := parent;
  with FParentInfos[i1]^ do begin
    Index          := -1;
    OldIndex       := -1;
    LastChangeType := lctNew;
    Selected       := false;
    Focused        := false;
    Checked        := no;
  end;
end;

procedure TIBasic.DelParent(parent: TICustomBasicList);
var i1, i2 : integer;
    b1     : boolean;
begin
  for i1 := 0 to high(FParentInfos) do
    if FParentInfos[i1].Parent = parent then begin
      b1 := true;
      for i2 := 0 to high(parent.FItemInfos) do
        if parent.FItemInfos[i2] = FParentInfos[i1] then begin
          b1 := false;
          break;
        end;
      if b1 then begin
        Dispose(FParentInfos[i1]);
        FParentInfos[i1] := FParentInfos[high(FParentInfos)];
        SetLength(FParentInfos, Length(FParentInfos) - 1);
        break;
      end;
    end;
end;

function TIBasic.CheckValid : boolean;
begin
  result := FValid;
  if result then FSuccess := true
  else           SetLastError(CErrorNo_AmInvalid, CErrorStr_AmInvalid);
end;

// ***************************************************************

constructor TIList.Create(valid: boolean; lastErrorNo: cardinal; lastErrorStr: string);
begin
  inherited Create(valid, lastErrorNo, lastErrorStr);
  FSection := NewCriticalSection;
end;

destructor TIList.Destroy;
begin
  FSection.Enter;
  try
    SetCapacity(0);
    inherited;
  finally FSection.Leave end;
end;

function TIList.GetItemCount : integer;
begin
  result := FCount;
end;

function TIList.GetCapacity : integer;
begin
  result := FCapacity;
end;

procedure TIList.Lock;
begin
  FSection.Enter;
end;

function TIList.Unlock : boolean;
begin
  result := FSection.Leave;
end;

function TIList.GetSelectedCount : integer;
begin
  result := FSelectedCount;
end;

function TIList.GetFocusedItem : IBasic;
begin
  result := FFocusedItem;
end;

function TIList.GetLastFocusedItem : IBasic;
begin
  result := FLastFocusedItem;
end;

procedure TIList.SetLastFocusedItem(value: IBasic);
begin
  FLastFocusedItem := value;
end;

procedure TIList.Clear;
begin
  SetCapacity(0);
end;

procedure TIList.Grow;
begin
  FSection.Enter;
  try
    if FValid then
      if FCapacity < 8 then SetCapacity(16                         )
      else                  SetCapacity(FCapacity + FCapacity div 2);
  finally FSection.Leave end;
end;

function TIList.QuickSort(var items1, items2;
                          l, r        : integer;
                          compareProc : pointer;
                          down        : boolean;
                          info        : integer) : boolean;
type TComparePointer = function (const list: IList; item1, item2: pointer; info: integer) : integer;
var ap1  : TAPointer       absolute items1;
    ap2  : TAPointer       absolute items2;
    cp   : TComparePointer absolute compareProc;
    list : IList;

  procedure InternalQuickSort(r: integer);
  var i1, i2, i3 : integer;
      p2         : pointer;
  begin
    result := false;
    repeat
      i1 := l;
      i2 := r;
      i3 := (l + r) shr 1;
      repeat
        if down then begin
          while cp(list, ap1[i1], ap1[i3], info) < 0 do inc(i1);
          while cp(list, ap1[i2], ap1[i3], info) > 0 do dec(i2);
        end else begin
          while cp(list, ap1[i3], ap1[i1], info) < 0 do inc(i1);
          while cp(list, ap1[i3], ap1[i2], info) > 0 do dec(i2);
        end;
        if i1 <= i2 then begin
          result  := true;
          p2      := ap1[i1];
          ap1[i1] := ap1[i2];
          ap1[i2] := p2;
          if @ap2 <> nil then begin
            p2      := ap2[i1];
            ap2[i1] := ap2[i2];
            ap2[i2] := p2;
          end;
          if      i3 = i1 then i3 := i2
          else if i3 = i2 then i3 := i1;
          inc(i1);
          dec(i2);
        end;
      until i1 > i2;
      if l < i2 then InternalQuickSort(i2);
      l := i1;
    until i1 >= r;
  end;

begin
  result := false;
  list := IList(GetMaxInterface);
  InternalQuickSort(r);
end;

// ***************************************************************

destructor TICustomBasicList.Destroy;
begin
  FOnChange := nil; FOnChangeOO := nil;
  inherited;
end;

function TICustomBasicList.BasicItem(index: integer) : IBasic;
begin
  FSection.Enter;
  try
    if (index < 0) or (index >= FCount) then
      raise MadException.Create(CErrorStr_IndexOutOfRange);
    result := FItems[index];
  finally FSection.Leave end;
end;

procedure TICustomBasicList.Pack;
var i1 : integer;
begin
  FSection.Enter;
  try
    for i1 := FCount - 1 downto 0 do
      if FItems[i1] = nil then
        DeleteItem(i1);
    SetCapacity(FCount);
  finally FSection.Leave end;
end;

function TICustomBasicList.GetSortProc : TCompareBasic;
begin
  result := FSortProc;
end;

function TICustomBasicList.GetSortDown : boolean;
begin
  result := FSortDown;
end;

function TICustomBasicList.GetSortInfo : integer;
begin
  result := FSortInfo;
end;

procedure TICustomBasicList.SetSortProc(value: TCompareBasic);
begin
  SetSortParams(value, true, FSortInfo);
end;

procedure TICustomBasicList.SetSortDown(value: boolean);
begin
  SetSortParams(FSortProc, value, FSortInfo);
end;

procedure TICustomBasicList.SetSortInfo(value: integer);
begin
  SetSortParams(FSortProc, FSortDown, value);
end;

function TICustomBasicList.GetSortParams(var func: TCompareBasic;
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

function TICustomBasicList.SetSortParams(func: TCompareBasic;
                                         down: boolean = true;
                                         info: integer = 0   ) : boolean;
var i1 : integer;
begin
  FSection.Enter;
  try
    result := CheckValid;
    if result then
      if (@func <> @FSortProc) or (down <> FSortDown) or (info <> FSortInfo) then begin
        FSortProc := func;
        FSortDown := down;
        FSortInfo := info;
        if (@FSortProc <> nil) and (FCount > 0) then
          if QuickSort(FItems[0], FItemInfos[0], 0, FCount - 1, @FSortProc, FSortDown, FSortInfo) then
            for i1 := 0 to FCount - 1 do
              with FItemInfos[i1]^ do begin
                OldIndex := Index;
                Index    := i1;
              end;
      end;
  finally FSection.Leave end;
end;

procedure TICustomBasicList.RegisterChangeEvent(changeEvent: TIListChangeEvent);
var i1 : integer;
begin
  FSection.Enter;
  try
    if CheckValid then begin
      for i1 := 0 to high(FOnChange) do
        if @FOnChange[i1] = @changeEvent then
          exit;
      i1 := Length(FOnChange);
      SetLength(FOnChange, i1 + 1);
      FOnChange[i1] := changeEvent;
    end;
  finally FSection.Leave end;
end;

procedure TICustomBasicList.RegisterChangeEvent(changeEvent: TIListChangeEventOO);
var i1 : integer;
begin
  FSection.Enter;
  try
    if CheckValid then begin
      for i1 := 0 to high(FOnChangeOO) do
        if int64(TMethod(FOnChangeOO[i1])) = int64(TMethod(changeEvent)) then
          exit;
      i1 := Length(FOnChangeOO);
      SetLength(FOnChangeOO, i1 + 1);
      FOnChangeOO[i1] := changeEvent;
    end;
  finally FSection.Leave end;
end;

function TICustomBasicList.UnregisterChangeEvent(changeEvent: TIListChangeEvent) : boolean;
var i1, i2 : integer;
begin
  result := false;
  FSection.Enter;
  try
    i2 := high(FOnChange);
    for i1 := i2 downto 0 do
      if @FOnChange[i1] = @changeEvent then begin
        FOnChange[i1] := FOnChange[i2];
        dec(i2);
        result := true;
        FSuccess := true;
      end;
    if result then SetLength(FOnChange, i2 + 1)
    else           SetLastError(ERROR_FILE_NOT_FOUND);
  finally FSection.Leave end;
end;

function TICustomBasicList.UnregisterChangeEvent(changeEvent: TIListChangeEventOO) : boolean;
var i1, i2 : integer;
begin
  result := false;
  FSection.Enter;
  try
    i2 := high(FOnChangeOO);
    for i1 := i2 downto 0 do
      if int64(TMethod(FOnChangeOO[i1])) = int64(TMethod(changeEvent)) then begin
        FOnChangeOO[i1] := FOnChangeOO[i2];
        dec(i2);
        result := true;
        FSuccess := true;
      end;
    if result then SetLength(FOnChangeOO, i2 + 1)
    else           SetLastError(ERROR_FILE_NOT_FOUND);
  finally FSection.Leave end;
end;

procedure TICustomBasicList.SetCapacity(capacity: integer);
var i1 : integer;
begin
  FSection.Enter;
  try
    if capacity <> FCapacity then begin
      for i1 := FCount - 1 downto capacity do DeleteItem(i1);
      SetLength(FItems,     capacity);
      SetLength(FItemInfos, capacity);
      FCapacity := capacity;
      if FCount > FCapacity then FCount := FCapacity;
    end;
    FSuccess := true;
  finally FSection.Leave end;
end;

function TICustomBasicList.AddItem(const item: IBasic) : integer;
var i1 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      if item <> nil then begin
        result := item.Index[Self];
        if result = -1 then
          if (@FSortProc <> nil) and (FCount > 0) then begin
            if FSortDown then begin
              for i1 := 0 to FCount - 1 do
                if (FItems[i1] <> nil) and (FSortProc(ICustomBasicList(GetMaxInterface), FItems[i1], item, FSortInfo) >= 0) then
                  break;
            end else
              for i1 := 0 to FCount - 1 do
                if (FItems[i1] = nil) or (FSortProc(ICustomBasicList(GetMaxInterface), item, FItems[i1], FSortInfo) >= 0) then
                  break;
            result := InsertItem(item, i1);
          end else begin
            inc(TIBasic(item.SelfAsTObject).FRefCount);
            Change(item, true, lctNew, -1, FCount);
            dec(TIBasic(item.SelfAsTObject).FRefCount);
            if FCount = FCapacity then Grow;
            result := FCount;
            FItems[result] := item;
            FItemInfos[result] := TIBasic(item.SelfAsTObject).AddParent(self);
            with FItemInfos[result]^ do begin
              LastChangeType := lctNew;
              OldIndex       := -1;
              Index          := result;
              Selected       := false;
              Focused        := false;
              Checked        := no;
            end;
            inc(FCount);
            Change(item, false, lctNew, -1, result);
          end;
      end else SetLastError(ERROR_INVALID_PARAMETER);
  finally FSection.Leave end;
end;

function TICustomBasicList.AddItems(const items: array of IBasic) : integer;
var i1, i2 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      for i1 := 0 to high(items) do begin
        i2 := AddItem(items[i1]);
        if (i2 < result) or (result = -1) then result := i2;
      end;
  finally FSection.Leave end;
end;

function TICustomBasicList.InsertItem(const item : IBasic;
                                      index      : integer = 0) : integer;
var i1 : integer;
begin
  result := -1;
  FSection.Enter;
  try
    if CheckValid then
      if item <> nil then begin
        if index >= 0 then begin
          result := item.Index[Self];
          if result = -1 then begin
            if index > FCount then index := FCount;
            inc(TIBasic(item.SelfAsTObject).FRefCount);
            Change(item, true, lctNew, -1, index);
            dec(TIBasic(item.SelfAsTObject).FRefCount);
            result := index;
            if FCount = FCapacity then Grow;
            if result < FCount then begin
              Move(FItems    [index], FItems    [index + 1], (FCount - index) * 4);
              Move(FItemInfos[index], FItemInfos[index + 1], (FCount - index) * 4);
              for i1 := index + 1 to FCount do
                if FItemInfos[i1] <> nil then
                  with FItemInfos[i1]^ do begin
                    OldIndex := Index;
                    Index    := i1;
                  end;
              pointer(FItems[result]) := nil;
              FItemInfos[result] := nil;
            end;
            FItems[result] := item;
            FItemInfos[result] := TIBasic(FItems[result].SelfAsTObject).AddParent(self);
            with FItemInfos[result]^ do begin
              LastChangeType := lctNew;
              OldIndex       := -1;
              Index          := result;
              Selected       := false;
              Focused        := false;
              Checked        := no;
            end;
            inc(FCount);
            Change(item, false, lctNew, -1, result);
          end;
        end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
      end else SetLastError(ERROR_INVALID_PARAMETER);
  finally FSection.Leave end;
end;

function TICustomBasicList.DeleteItem(index: integer) : boolean;
var i1 : integer;
    ib : IBasic;
begin
  FSection.Enter;
  try
    result := (index >= 0) and (index < FCount);
    if result then begin
      FSuccess := true;
      if FItems[index] <> nil then begin
        Change(FItems[index], true, lctDeleted, index, -1);
        FItems[index].Selected[self] := false;
        FItems[index].Focused [self] := false;
        FItems[index].Checked [self] := no;
        if FItemInfos[index] <> nil then
          with FItemInfos[index]^ do begin
            LastChangeType := lctDeleted;
            OldIndex       := Index;
            Index          := -1;
          end;
        ib := FItems[index];
        FItems[index] := nil;
        FItemInfos[index] := nil;
      end else
        ib := nil;
      dec(FCount);
      if index < FCount then begin
        Move(FItems    [index + 1], FItems    [index], (FCount - index) * 4);
        Move(FItemInfos[index + 1], FItemInfos[index], (FCount - index) * 4);
        for i1 := index to FCount - 1 do
          if FItemInfos[i1] <> nil then
            with FItemInfos[i1]^ do begin
              OldIndex := Index;
              Index    := i1;
            end;
        pointer(FItems[FCount]) := nil;
        FItemInfos[FCount] := nil;
      end;
      if ib <> nil then begin
        Change(ib, false, lctDeleted, index, -1);
        TIBasic(ib.SelfAsTObject).DelParent(self);
      end;
    end else SetLastError(CErrorNo_InvalidIndex, CErrorStr_InvalidIndex);
  finally FSection.Leave end;
end;

procedure TICustomBasicList.Change(const item: IBasic;
                                   beforeChange : boolean;
                                   changeType   : TChangeType;
                                   oldIndex     : integer;
                                   index        : integer    );
var i1 : integer;
begin
  for i1 := 0 to high(FOnChange) do
    FOnChange[i1](ICustomBasicList(GetMaxInterface), item, beforeChange, changeType, oldIndex, index);
  for i1 := 0 to high(FOnChangeOO) do
    FOnChangeOO[i1](ICustomBasicList(GetMaxInterface), item, beforeChange, changeType, oldIndex, index);
end;

procedure TICustomBasicList.BeginRefresh;
var i1 : integer;
begin
  for i1 := 0 to FCount - 1 do
    if FItemInfos[i1] <> nil then
      FItemInfos[i1].LastChangeType := lctDeleted;
end;

procedure TICustomBasicList.EndRefresh;
var i1 : integer;
begin
  for i1 := FCount - 1 downto 0 do
    if (FItemInfos[i1] = nil) or (FItemInfos[i1].LastChangeType = lctDeleted) then
      DeleteItem(i1);
end;

function TICustomBasicList.SortItem(index: integer) : integer;
var p1, p2 : pointer;
    i1     : integer;
begin
  result := index;
  if @FSortProc <> nil then begin
    if FSortDown then begin
      if FItems[index] <> nil then begin
        while (result + 1 < FCount) and
              ((FItems[result + 1] = nil) or
               (FSortProc(ICustomBasicList(GetMaxInterface), FItems[index], FItems[result + 1], FSortInfo) > 0)) do
          inc(result);
        if result = index then
          while (result - 1 >= 0) and (FItems[result - 1] <> nil) and
                (FSortProc(ICustomBasicList(GetMaxInterface), FItems[index], FItems[result - 1], FSortInfo) < 0) do
            dec(result);
      end else result := 0;
    end else
      if FItems[index] <> nil then begin
        while (result + 1 < FCount) and (FItems[result + 1] <> nil) and
              (FSortProc(ICustomBasicList(GetMaxInterface), FItems[result + 1], FItems[index], FSortInfo) > 0) do
          inc(result);
        if result = index then
          while (result - 1 >= 0) and
                ((FItems[result - 1] = nil) or
                 (FSortProc(ICustomBasicList(GetMaxInterface), FItems[result - 1], FItems[index], FSortInfo) < 0)) do
            dec(result);
      end else result := FCount-1;
    if result <> index then begin
      p1 := pointer(FItems[index]);
      p2 := FItemInfos[index];
      if result < index then begin
        Move(FItems    [result   ], FItems    [result + 1], (index - result) * 4);
        Move(FItemInfos[result   ], FItemInfos[result + 1], (index - result) * 4);
      end else begin
        Move(FItems    [index + 1], FItems    [index     ], (result - index) * 4);
        Move(FItemInfos[index + 1], FItemInfos[index     ], (result - index) * 4);
      end;
      pointer(FItems[result]) := p1;
      FItemInfos[result] := p2;
      if result < index then begin
        for i1 := result to index do
          if FItemInfos[i1] <> nil then
            with FItemInfos[i1]^ do begin
              OldIndex := Index;
              Index    := i1;
            end;
      end else
        for i1 := index to result do
          if FItemInfos[i1] <> nil then
            with FItemInfos[i1]^ do begin
              OldIndex := Index;
              Index    := i1;
            end;
    end else
      if FItemInfos[result] <> nil then
        FItemInfos[result].OldIndex := index;
  end else
    if FItemInfos[result] <> nil then
      FItemInfos[result].OldIndex := index;
end;

// ***************************************************************

constructor TIBasicListSelection.Create(valid: boolean; lastErrorNo: cardinal; lastErrorStr: string;
                                        const parentList: ICustomBasicList; copyParentList: boolean);
var i1 : integer;
begin
  inherited Create(valid, lastErrorNo, lastErrorStr);
  if FValid then begin
    FValid := parentList <> nil;
    if FValid then begin
      FParentList := parentList;
      if copyParentList then begin
        FParentList.Lock;
        try
          for i1 := 0 to FParentList.ItemCount - 1 do
            if CheckItem(FParentList[i1]) then
              AddItem(FParentList[i1]);
          FParentList.RegisterChangeEvent(ParentListChanged);
        finally FParentList.Unlock end;
      end;
    end else SetLastError(ERROR_INVALID_PARAMETER);
  end;
end;

destructor TIBasicListSelection.Destroy;
begin
  if FValid then
    FParentList.UnregisterChangeEvent(ParentListChanged);
  inherited;
end;

function TIBasicListSelection.GetParentList : ICustomBasicList;
begin
  result := FParentList;
end;

procedure TIBasicListSelection.ParentListChanged(const list: ICustomBasicList; const item: IBasic;
                                                 beforeChange: boolean; changeType: TChangeType;
                                                 oldIndex, index: integer);
var idx : integer;
begin
  FSection.Enter;
  try
    idx := item.Index[self];
    case changeType of
      lctChanged   : if idx <> -1 then begin
                       if beforeChange then begin
                         if CheckItem(item) then Change(item, true, lctChanged, idx, idx)
                         else                    DeleteItem(idx);
                       end else begin
                         FItemInfos[idx].LastChangeType := lctChanged;
                         Change(item, false, lctChanged, idx, SortItem(idx));
                       end;
                     end else
                       if (not beforeChange) and CheckItem(item) then
                         AddItem(item);
      lctNew       : if (not beforeChange) and (idx = -1) and CheckItem(item) then
                       AddItem(item);
      lctDeleted   : if (not beforeChange) and (idx <> -1) then
                       DeleteItem(idx);
    end;
  finally FSection.Leave end;
end;

// ***************************************************************

type
  // implements ICriticalSection
  TICriticalSection = class (TIBasic, ICriticalSection)
  public
    FSection     : TRTLCriticalSection;
    FOwnerThread : cardinal;
    FLockCount   : integer;

    constructor Create;
    destructor Destroy; override;

    procedure Enter;

    function TryEnter : boolean;

    function Leave : boolean;

    function OwnerThread : cardinal;
    function LockCount   : integer;

    function IsOwnedByCurrentThread : boolean;

    function GetMaxInterface : IBasic; override;
  end;

var
  TryEnterCriticalSection : function (const lpCriticalSection: TRTLCriticalSection) : longBool stdcall = nil;
  TryEnterReady           : boolean = false;

constructor TICriticalSection.Create;
begin
  inherited Create(true, 0, '');
  InitializeCriticalSection(FSection);
end;

destructor TICriticalSection.Destroy;
begin
  DeleteCriticalSection(FSection);
  inherited;
end;

procedure TICriticalSection.Enter;
begin
  EnterCriticalSection(FSection);
  FSuccess := true;
  FOwnerThread := GetCurrentThreadID;
  inc(FLockCount);
end;

function TICriticalSection.TryEnter : boolean;
begin
  if not TryEnterReady then begin
    TryEnterReady := true;
    TryEnterCriticalSection := GetProcAddress(GetModuleHandle(kernel32), 'TryEnterCriticalSection');
  end;
  if @TryEnterCriticalSection = nil then begin
    result := false;
    SetLastError(ERROR_CALL_NOT_IMPLEMENTED);
  end else begin
    result := TryEnterCriticalSection(FSection);
    if result then begin
      FSuccess := true;
      FOwnerThread := GetCurrentThreadID;
      inc(FLockCount);
    end else SetLastError(CErrorNo_SectionBlocked, CErrorStr_SectionBlocked);
  end;
end;

function TICriticalSection.Leave : boolean;
begin
  result := FOwnerThread = GetCurrentThreadID;
  FSuccess := result;
  if result then begin
    dec(FLockCount);
    if FLockCount = 0 then FOwnerThread := 0;
    LeaveCriticalSection(FSection);
  end else SetLastError(CErrorNo_SectionLeaveError, CErrorStr_SectionLeaveError);
end;

function TICriticalSection.OwnerThread : cardinal;
begin
  result := FOwnerThread;
end;

function TICriticalSection.LockCount : integer;
begin
  result := FLockCount;
end;

function TICriticalSection.IsOwnedByCurrentThread : boolean;
begin
  result := FOwnerThread = GetCurrentThreadID;
end;

function TICriticalSection.GetMaxInterface : IBasic;
begin
  result := ICriticalSection(self);
end;

function NewCriticalSection : ICriticalSection;
begin
  result := TICriticalSection.Create;
end;

// ***************************************************************

end.
