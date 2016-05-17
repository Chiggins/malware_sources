unit UtilClass;

interface

uses
  windows,
  messages,
  UtilFunc,
  ShellAPI,
  CommDlg;

//------------------------------------------------------------
//             Global Types, Constants and Variables
//------------------------------------------------------------
type
TOpenSave = record
  FullName:string;
  FileName:string;
  Path:string;
  Ext:string;
end;

//------------------------------------------------------------
//                    Classes
//------------------------------------------------------------

//-----------------  TIntegerList ------------------------------
const
  MaxItem = 200000;

type
TIntegerArray = array[0..MaxItem] of Integer;
PIntegerArray = ^TIntegerArray;

TIntegerList = class(TObject)
private
  FPointer: PIntegerArray;
  FCount: integer;
  FSize: integer;
  FReAllocSize: integer;
  FInitialSize: integer;
  function GetItem(index: integer):Integer;
  procedure SetItem(index: integer; value: Integer);
  function GetCount: integer;
  function GetRealSize: integer;
protected
public
  constructor Create(InitialSize,ReAllocSize:integer);virtual;
  destructor Destroy; override;
  procedure Clear;
  procedure Add(value:Integer);
  procedure Delete(index: integer);
  procedure Insert(index: integer; value: Integer);
  function Search(value: Integer): integer;
  procedure CopyTo(var IL: TIntegerList);
  property Item[i:integer]:Integer read GetItem write SetItem;default;
  property Count: integer read GetCount;
  property Size: integer read FSize;
  property RealSize: integer read GetRealSize;
end;

//------------------ TMessageDispatcher ----------------------

TSubClass = class; // forward

TMessageDispatcher = class(TObject)
private
  FSList: TIntegerList;
  FParentList: TIntegerList;
  FParentProc: TIntegerList;
  FMessageList: TIntegerList;
  FMessageObject: TIntegerList;
  FCopyList: TIntegerList;
  FCopyList2: TIntegerList;
  FNeedCopy: Boolean;
  function GetCount:integer;
protected
  function IsNewParent(hWindow:HWND):Boolean;
  function IsParent(hWindow:HWND):Boolean;
  function GetParentProc(hWindow:HWND):TFNWndProc;
public
  constructor Create;
  destructor Destroy; override;
  procedure DefaultHandler(var Message);override;
  procedure Add(Obj:TSubClass);
  procedure Delete(Obj:TSubClass);
  procedure TrapMessage(Msg: UINT; Obj: TSubClass);
  property Count: integer read GetCount;
end;

//------------------ TSubClass -------------------------------
TSubClass = class(TObject)
private
  FParent: HWND;
  FData: integer;
protected
public
  constructor Create(hParent:HWND); virtual;
  destructor Destroy; override;
  property Parent: HWND read FParent;
  property Data : integer read FData write FData;
end;

//-----------------  TAPITimer -------------------------------------------
TAPITimer = class(TSubClass)
private
  FInterval : integer;
  FOnTimer: TNotifyMessage;
  FIsOn : Boolean;
public
  constructor Create(hParent: HWND); override;
  destructor Destroy; override;
  procedure DefaultHandler(var AMessage); override;
  procedure On;
  procedure Off;
  property IsOn: Boolean read FIsOn;
  property Interval: integer read FInterval write FInterval;
  property OnTimer: TNotifyMessage read FOnTimer write FOnTimer;
end;

//----------------- TStringArray -------------------------------------
TStringArray = class(TObject)
private
  PCharArray : TIntegerList;
  FCount: integer;
  function GetItems(index:integer): string;
  procedure SetItem(index: integer;value:string);
  function GetCount: integer;
protected
public
  constructor Create; virtual;
  destructor Destroy; override;
  property Items[i:integer]:string read GetItems write SetItem;default;
  property Count: integer read GetCount;
  procedure Add(value:string);
  procedure Clear;
  procedure Delete(index: integer);
  procedure Insert(index: integer; value: string);
  function Search(s:string):integer;
  procedure Exchange(i,j: integer);
  procedure Sort;
end;

function APICompareString(S1,S2: string): integer;
procedure StringQuickSort(SS: TStringArray;l,r: Integer);

//------------- TAPIDragDrop ----------------------------------------------
type
TAPIDragDrop = class(TSubClass)
private
  FFiles: TStringArray;
  FFileCount : integer;
  FOnDrop: TNotifyMessage;
  function GetFiles(i: integer): string;
public
  constructor Create(hParent:HWND); override;
  destructor Destroy; override;
  procedure DefaultHandler(var Message);override;
  procedure SetFocus(hWnd: HWND);
  property FileCount: integer read FFileCount;
  property Files[i: integer]: string read GetFiles;
  property OnDrop: TNotifyMessage read FOnDrop write FOnDrop;
end;

//------------- TGridArranger ----------------------------------------------
TGridArranger = class(TSubClass)
private
  FNumCol: integer;
  FNumRow: integer;
  FXMargin: integer;
  FYMargin: integer;
  FXSep: integer;
  FYSep: integer;
  FOnSize: TNotifyMessage;
public
  constructor Create(hParent: HWND); override;
  procedure DefaultHandler(var Message);override;
  function Arrange(Row,Col: integer): TRect;
  function CenterArrange(Row,Col:integer;Dim: TRect): TRect;
  property NumCol: integer read FNumCol write FNumCol;
  property NumRow: integer read FNumRow write FNumRow;
  property XMargin: integer read FXMargin write FXMargin;
  property YMargin: integer read FYMargin write FYMargin;
  property XSep: integer read FXSep write FXSep;
  property YSep: integer read FYSep write FYSep;
  property OnSize: TNotifyMessage read FOnSize write FOnSize;
end;

//------------- TBorderArranger ----------------------------------------------
TBorderPos = (bpUpper,bpLower,bpLeft,bpRight,bpCenter);

TBorderArranger = class(TSubClass)
private
  FUpperHeight: integer;
  FLowerHeight: integer;
  FLeftWidth: integer;
  FRightWidth: integer;
  FXMargin: integer;
  FYMargin: integer;
  FXSep: integer;
  FYSep: integer;
  FOnSize: TNotifyMessage;
public
  constructor Create(hParent: HWND); override;
  procedure DefaultHandler(var Message);override;
  function Arrange(BorderPos:TBorderPos): TRect;
  property UpperHeight: integer read FUpperHeight write FUpperHeight;
  property LowerHeight: integer read FLowerHeight write FLowerHeight;
  property LeftWidth: integer read FLeftWidth write FLeftWidth;
  property RightWidth: integer read FRightWidth write FRightWidth;
  property XMargin: integer read FXMargin write FXMargin;
  property YMargin: integer read FYMargin write FYMargin;
  property XSep: integer read FXSep write FXSep;
  property YSep: integer read FYSep write FYSep;
  property OnSize: TNotifyMessage read FOnSize write FOnSize;
end;

//------------- MessageTrapper ---------------------------------
TMessageTrapper = class(TSubClass)
private
  FTrapMessage: TIntegerList;
  FHandler: TIntegerList;
  FNumTrap: integer;
public
  constructor Create(hParent: HWND); override;
  destructor Destroy; override;
  procedure DefaultHandler(var Message);override;
  procedure TrapMessage(TrapMsg: UINT; Handler: TNotifyMessage);
end;

//-------------  TAPIGFont  -----------------------------------------------
TAPIGFont = class(TObject)
private
  FLogFont: TLogFont;
  FHandle: HFONT;
  FPrevHandle: HFONT;
  FName: string;
  FSize: integer;
  FEscapement: integer;
  FBold: Boolean;
  FItalic: Boolean;
  FUnderline: Boolean;
  FStrikeOut: Boolean;
  FColor: COLORREF;
  procedure SetLogFont(value: TLogFont);
  function GetLogFont: TLogFont;
public
  constructor Create;
  procedure SelectHandle(DC: HDC);
  procedure DeleteHandle(DC: HDC);
  property LogFont: TLogFont read GetLogFont write SetLogFont;
  property Name: string read FName write FName;
  property Size: integer read FSize write FSize;
  property Escapement: integer read FEscapement write FEscapement;
  property Bold: Boolean read FBold write FBold;
  property Italic: Boolean read FItalic write FItalic;
  property Underline: Boolean read FUnderline write FUnderline;
  property StrikeOut: Boolean read FStrikeOut write FStrikeOut;
  property Color: COLORREF read FColor write FColor;
end;

//-------------  TAPICFont  -----------------------------------------------
TAPICFont = class(TAPIGFont)
public
  destructor Destroy; override;
  procedure GetHandle;
  procedure SetHandle(ctlHandle: HWND);
  procedure ResetHandle(ctlHandle: HWND);
  property Handle: HFONT read FHandle;
end;

//------------- File Function -----------------------------------------
function AExtractFileName(s: string):string;
function AExtractDir(s: string): string;
function AExtractExt(s: string): string;

procedure FindAllFilesWithExt(dir,ext:string;SL:TStringArray);
procedure FindAllFiles(dir:string;SL:TStringArray);

function GetFileSize(FullPath: string): integer;
function GetFileCreationTime(FullPath: string): TSystemTime;
function GetFileLastAccessTime(FullPath: string): TSystemTime;
function GetFileLastWriteTime(FullPath: string): TSystemTime;

function GetFileAttributes(FullPath: string): DWORD;

procedure DisplayLogFont(lf: TLogFont; SA: TStringArray);

function GetOpenFile(hOwner:HWND;defName,Filter,initDir:string;
                     var FLN:TOpenSave):Boolean;

function GetSaveFile(hOwner:HWND;defName,Filter,initDir:string;
                     var FLN:TOpenSave):Boolean;

function GetOpenFileMult(hOwner:HWND;defName,Filter,initDir:string;
                         STL:TStringArray;var NumFile:integer):Boolean;

function SHCopyFile(hParent:HWND;NameFrom,NameTo:string):Boolean;
function SHMoveFile(hParent:HWND;NameFrom,NameTo:string):Boolean;
function SHRenameFile(hParent:HWND;NameFrom,NameTo:string):Boolean;
function SHDeleteFile(hParent:HWND;Name:string):Boolean;

procedure FindAllDirInDir(dir:string;SL:TStringArray);
function IsFileExist(FN: string):Boolean;
function CreateDir(DN:string):Boolean;
function RemoveDirAll(DN:string):Boolean;
procedure FindAllFilesWithSubdir(DN:string;SL:TStringArray);

function SHCopyDir(hParent:HWND;NameFrom,NameTo:string):Boolean;
function SHDeleteDir(hParent:HWND;Name:string):Boolean;


//------------------------------------------------------------
//        Create Functions
//------------------------------------------------------------
function CreateTimer(hParent:HWND; Intrvl: integer;
                     OnTimerFunc: TNotifyMessage):TAPITimer;

function CreateGridArranger(hParent:HWND;iRow,iCol,XMrgn,YMrgn,
            XSp,YSp:integer; sOnSize:TNotifyMessage): TGridArranger;

function CreateBorderArranger(hParent:HWND;UH,LH,LW,RW,XMrgn,YMrgn,
            XSp,YSp:integer; sOnSize:TNotifyMessage): TBorderArranger;

                     
var
  Dispatcher: TMessageDispatcher;

implementation


//------------------------------------------------------------
//                    Classes
//------------------------------------------------------------

//-----------------  TIntegerList ------------------------------
constructor TIntegerList.Create(InitialSize,ReAllocSize:integer);
begin
  if ReAllocSize = 0 then FReAllocSize := $10 else FReAllocSize := ReAllocSize;
  if InitialSize = 0 then FInitialSize := $10 else FInitialSize := InitialSize;
  FSize := FInitialSize;
  GetMem(FPointer,SizeOf(Integer)*FSize);
  FCount := -1;
end;

destructor TIntegerList.Destroy;
begin
  FreeMem(FPointer);
  inherited Destroy;
end;

procedure TIntegerList.Clear;
begin
  FreeMem(FPointer);
  FSize := FInitialSize;
  GetMem(FPointer,SizeOf(Integer)*FSize);
  FCount := -1;
end;

procedure TIntegerList.Add(value:Integer);
begin
  Inc(FCount);
  if FCount > FSize-1 then begin
    Inc(FSize,FReAllocSize);
    ReAllocMem(FPointer,SizeOf(Integer)*FSize);
  end;
  FPointer^[FCount] := value;
end;

procedure TIntegerList.Delete(index: integer);
begin
  if (index > FCount) or (index < 0) then Exit;
  if index = FCount then begin
    Dec(FCount);
    Exit;
  end;
  Move(FPointer^[index+1],FPointer^[index],
             SizeOf(Integer)*(FCount-index));
  Dec(FCount);
end;

procedure TIntegerList.Insert(index: integer; value: Integer);
begin
  if (index > FCount) or (index < 0) then Exit;
  if FCount+1 > FSize-1 then begin
    Inc(FSize,FReAllocSize);
    ReAllocMem(FPointer,SizeOf(Integer)*FSize);
  end;
  Move(FPointer^[index],FPointer^[index+1],
             SizeOf(Integer)*(FCount-index+1));
  FPointer^[index] := value;
  Inc(FCount);
end;

function TIntegerList.GetItem(index: integer):Integer;
begin
  if (index > FCount) or (index < 0) then
    result := 0
  else
    result := FPointer^[index];
end;

procedure TIntegerList.SetItem(index: integer; value: Integer);
begin
  if index > FSize-1 then begin
    repeat
      Inc(FSize,FReAllocSize);
    until  index < FSize-1;
    ReAllocMem(FPointer,SizeOf(Integer)*FSize);
  end;
  FPointer^[index] := value;
  if FCount < index then FCount := index;
end;

function TIntegerList.GetCount: integer;
begin
  result := FCount+1;
end;

function TIntegerList.GetRealSize: integer;
begin
  result := FSize;
end;

function TIntegerList.Search(value: Integer): integer;
var
  i: integer;
begin
  for i := 0 to FCount do
    if FPointer^[i] = value then begin
      result := i;
      Exit;
    end;
  result := -1;
end;

procedure TIntegerList.CopyTo(var IL: TIntegerList);
var
  i: integer;
begin
  IL.Clear;
  for i := 0 to FCount do
    IL[i] := FPointer^[i];
end;

//------------------ TMessageDispatcher ----------------------
function SubClassProc(hParent: HWND; Msg: UINT;
                       wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  AMsg: TMessage;
  OriginalProc: TFNWndProc;
begin

  result := 0;
  if not Dispatcher.IsParent(hParent) then Exit;

  OriginalProc := Dispatcher.GetParentProc(hParent);

  result := CallWindowProc(OriginalProc,hParent,Msg,wParam,lParam);

  AMsg.Msg := Msg;
  AMsg.WParam := wParam;
  AMsg.LParam := lParam;
  AMsg.Result := hParent;

  case Msg of

    WM_DESTROY: begin
      SetWindowLong(hParent,GWL_WNDPROC,integer(OriginalProc));
      Dispatcher.Dispatch(AMsg);
    end;

  else
    Dispatcher.Dispatch(AMsg);

  end; // case

  if AMsg.Result <> 0 then result := AMsg.Result;

end;

constructor TMessageDispatcher.Create;
begin
  FSList := TIntegerList.Create($10,$10);
  FParentList := TIntegerList.Create($10,$10);
  FParentProc := TIntegerList.Create($10,$10);
  FMessageList := TIntegerList.Create($10,$10);
  FMessageObject := TIntegerList.Create($10,$10);
  FCopyList := TIntegerList.Create($10,$10);
  FCopyList2 := TIntegerList.Create($10,$10);
  FNeedCopy := false;
end;

destructor TMessageDispatcher.Destroy;
begin
  FNeedCopy := false;
  FSList.Free;
  FParentList.Free;
  FParentProc.Free;
  FMessageList.Free;
  FMessageObject.Free;
  FCopyList.Free;
  FCopyList2.Free;
  inherited Destroy;
end;

procedure TMessageDispatcher.DefaultHandler(var Message);
var
  AMsg: TMessage;
  hParent: HWND;
  i: integer;
  SO: TSubClass;
begin
  AMsg := TMessage(Message);

  hParent := AMsg.Result;
  TMessage(Message).result := 0; // default return result
  AMsg.Result := 0;              // default object return

  if AMsg.Msg = WM_DESTROY then begin
    for i := FSList.Count-1 downto 0 do begin
      SO := TSubClass(FSList[i]);
      if Assigned(SO) then
        if (SO.Parent = hParent) then begin
          FSList.Delete(i);
          SO.Free;  //SO := nil;
        end;
    end;
    FParentProc.Delete(FParentList.Search(hParent));    
    FParentList.Delete(FParentList.Search(hParent));
    exit;
  end;

  if FMessageList.Search(AMsg.Msg) = -1 then
    exit
  else begin
    if FNeedCopy then begin
      FMessageList.CopyTo(FCopyList);
      FMessageObject.CopyTo(FCopyList2);
      FNeedCopy := false;
    end;
    for i := 0 to FCopyList.Count-1 do
      if DWORD(FCopyList[i]) = AMsg.Msg then begin
        SO := TSubClass(FCopyList2[i]);
        if Assigned(SO) then
          if (SO.Parent = hParent) then begin
            SO.Dispatch(AMsg);
            if AMsg.Result <> 0 then begin
              TMessage(Message).result := AMsg.Result;
             exit;
            end;
          end;
      end;
  end;
end;

procedure TMessageDispatcher.TrapMessage(Msg: UINT; Obj: TSubClass);
begin
  FMessageList.Add(Msg);
  FMessageObject.Add(integer(Obj));
  FNeedCopy := true;
end;

function TMessageDispatcher.IsNewParent(hWindow:HWND):Boolean;
begin
  result := true;
  if FParentList.Count < 1 then Exit;
  if FParentList.Search(hWindow) > -1 then result := false;
end;

function TMessageDispatcher.IsParent(hWindow:HWND):Boolean;
begin
  result := false;
  if FParentList.Count < 1 then Exit;
  if FParentList.Search(hWindow) = -1 then
    result := false
  else
    result := true;
end;

function TMessageDispatcher.GetParentProc(hWindow:HWND):TFNWndProc;
begin
  result := TFNWndProc(FParentProc[FParentList.Search(hWindow)]);
end;

procedure TMessageDispatcher.Add(Obj:TSubClass);
var
  OriginalProc: integer;
begin
  FSList.Add(Integer(Obj));

  if IsNewParent(Obj.Parent) then begin
    FParentList.Add(Obj.Parent);
    OriginalProc := GetWindowLong(Obj.Parent,GWL_WNDPROC);
    FParentProc.Add(OriginalProc);
    SetWindowLong(Obj.Parent,GWL_WNDPROC,integer(@SubClassProc));
  end;
end;

procedure TMessageDispatcher.Delete(Obj:TSubClass);
var
  i: integer;
begin
  FSList.Delete(FSList.Search(Integer(Obj)));
  for i := FMessageObject.Count-1 downto 0 do
    if FMessageObject[i] = integer(Obj) then begin
      FMessageObject.Delete(i);  // UnTrap Message
      FMessageList.Delete(i);
    end;
  FNeedCopy := true;
end;

function TMessageDispatcher.GetCount:integer;
begin
  result := FSList.Count;
end;

//------------------ TSubClass -------------------------------
constructor TSubClass.Create(hParent:HWND);
begin
  if not Assigned(Dispatcher) then Dispatcher := TMessageDispatcher.Create;
  FParent := hParent;
  Dispatcher.Add(self);
end;

destructor TSubClass.Destroy;
begin
  Dispatcher.Delete(self);
  inherited Destroy;
end;

//-----------------  TAPITimer -------------------------------------------
constructor TAPITimer.Create(hParent: HWND);
begin
  inherited Create(hParent);
  Dispatcher.TrapMessage(WM_TIMER,self);

  FInterval := 1000;
  FIsOn := false;
end;

destructor TAPITimer.Destroy;
begin
  Off;
  inherited Destroy;
end;

procedure TAPITimer.On;
begin
  if FIsOn = true then exit;
  FIsOn := true;
   // TimerID に 自分のオブジェクト参照を渡す！！
  SetTimer(Parent,integer(self),FInterval,nil);
end;

procedure TAPITimer.Off;
begin
  if FIsOn = false then exit;
  FIsOn := false;
  KillTimer(Parent,integer(self));
end;

procedure TAPITimer.DefaultHandler(var AMessage);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(AMessage);
  if AMsg.Msg = WM_TIMER then
    if AMsg.WParam = integer(self) then begin
      AMsg.Msg := UINT(self);  // sender
      if Assigned(FOnTimer) then OnTimer(AMsg);
    end;
end;

//----------------- TStringArray -------------------------------------
constructor TStringArray.Create;
begin
  PCharArray := TIntegerList.Create($10,$10);
  FCount := -1;
end;

destructor TStringArray.Destroy;
var
  i: integer;
begin
  if FCount <> -1 then
    for i := 0 to FCount do FreeMem(PChar(PCharArray[i]));
  PCharArray.Free;
end;

procedure TStringArray.Add(value:string);
var
  PC: PChar;
begin
  Inc(FCount);
  GetMem(PC,Length(value)+1);
  lstrcpy(PC,PChar(value));
  PCharArray.Add(integer(PC));
end;

function TStringArray.GetItems(index:integer): string;
var
  PC: PChar;
begin
  if (index > FCount) or (index < 0) then begin
    result := 'index error';
    exit;
  end;
  PC := PChar(PCharArray[index]);
  SetString(result,PC,lstrlen(PC));
end;

procedure TStringArray.SetItem(index: integer;value:string);
var
  PC: PChar;
begin
  if (index > FCount) or (index < 0) then exit;
  GetMem(PC,Length(value)+1);
  lstrcpy(PC,PChar(value));
  FreeMem(PChar(PCharArray[index]));
  PCharArray[index] := integer(PC);
end;

procedure TStringArray.Clear;
var
  i: integer;
begin
  if FCount = -1 then exit;
  for i := 0 to FCount do FreeMem(PChar(PCharArray[i]));
  PCharArray.Clear;
  FCount := -1;
end;

procedure TStringArray.Delete(index: integer);
begin
  if (index > FCount) or (index < 0) then Exit;
  FreeMem(PChar(PCharArray[index]));
  PCharArray.Delete(index);
  Dec(FCount);
end;

procedure TStringArray.Insert(index: integer; value: string);
var
 PC: PChar;
begin
  if (index > FCount) or (index < 0) then Exit;
  GetMem(PC,Length(value)+1);
  lstrcpy(PC,PChar(value));
  PCharArray.Insert(index,integer(PC));
  Inc(FCount);
end;

function TStringArray.Search(s:string):integer;
var
  i: integer;
begin
  i := -1;
  Repeat
    Inc(i);
  Until (Items[i] = s) or ( i>FCount );
  if i > FCount then
    Result := -1
  else
    Result := i;
end;

function TStringArray.GetCount: integer;
begin
  result := FCount+1;
end;

procedure TStringArray.Exchange(i,j: integer);
var
  s: string;
begin
  s := Items[i];
  Items[i] := Items[j];
  Items[j] := s;
end;

procedure TStringArray.Sort;
begin
  StringQuickSort(self,0,Count-1);
end;

function APICompareString(S1,S2: string): integer;
begin
  result := CompareString(LOCALE_SYSTEM_DEFAULT,0,
                          PChar(S1),-1,PChar(S2),-1) - 2;
end;

procedure StringQuickSort(SS: TStringArray;l,r: integer);
var
  i,j: integer;
  sP: string;
begin
  repeat
    i := l;
    j := r;
    sP := SS[(l+r) div 2];
    repeat
      while APICompareString(SS[i],sP) < 0 do inc(i);
      while APICompareString(SS[j],sP) > 0 do dec(j);
      if i <= j then begin
        SS.Exchange(i,j);
        inc(i);
        dec(j);
      end;
    until i > j;
    if l < j then StringQuickSort(SS,l,j);
    l := i;
  until i >= r;
end;

//------------- TAPIDragDrop ----------------------------------------------
constructor TAPIDragDrop.Create(hParent:HWND);
begin
  inherited Create(hParent);

  Dispatcher.TrapMessage(WM_DROPFILES,self);
  FFiles := TStringArray.Create;
  DragAcceptFiles(hParent, true);
end;

destructor TAPIDragDrop.Destroy;
begin
  FFiles.Free;
  DragAcceptFiles(FParent, false);
  inherited Destroy;
end;

procedure TAPIDragDrop.DefaultHandler(var Message);
var
  AMsg: TMessage;
  hD: HDROP;
  i: integer;
  PC: PChar;
begin
  AMsg := TMessage(Message);
  case AMsg.Msg of
    WM_DROPFILES:begin
      FFiles.Clear;
      hD := AMsg.wParam;
      GetMem(PC,MAX_PATH+1);
      FFileCount := DragQueryFile(hD,$FFFFFFFF,nil,0);
      for i := 0 to FFileCount-1 do begin
        DragQueryFile(hD,i,PC,MAX_PATH+1);
        FFiles.Add(string(PC));
      end;
      FreeMem(PC);
      DragFinish(hD);
      if Assigned(FOnDrop) then begin
        AMsg.Msg := UINT(self); // sender
        OnDrop(AMsg);
      end;
    end;
  end; // case
end;

procedure TAPIDragDrop.SetFocus(hWnd: HWND);
begin
  SetForeGroundWindow(FParent);
  Windows.SetFocus(hWnd);
end;

function TAPIDragDrop.GetFiles(i: integer): string;
begin
  result := FFiles[i];
end;

//------------- TGridArranger ----------------------------------------------
constructor TGridArranger.Create(hParent: HWND);
begin
  inherited Create(hParent);

  Dispatcher.TrapMessage(WM_SIZE,self);
  FNumCol := 2;
  FNumRow := 2;
  FXMargin := 0;
  FYMargin := 0;
  FXSep := 1;
  FYSep := 1;
end;

procedure TGridArranger.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(Message);
  case AMsg.Msg of
    WM_SIZE:begin
      if Assigned(FOnSize) then begin
        AMsg.Msg := UINT(self); // sender
        OnSize(AMsg);
      end;
    end;
  end; // case
end;

function TGridArranger.Arrange(Row,Col: integer): TRect;
var
  CR: TRect;
begin
  GetClientRect(FParent,CR);
  result.Right := (CR.Right-2*FXMargin-FXSep*(FNumCol-1)) div FNumCol;
  result.Bottom := (CR.Bottom-2*FYMargin-FYSep*(FNumRow-1)) div FNumRow;
  result.Left := FXMargin+(result.Right+FXSep)*Row;
  result.Top := FYMargin+(result.Bottom+FYSep)*Col;
end;

function TGridArranger.CenterArrange(Row,Col:integer;Dim: TRect): TRect;
var
  CR: TRect;
begin
  CR := Arrange(Row,Col);
  result := Dim;
  if CR.Right < Dim.Right then
    result.Left := CR.Left
  else
    result.Left := (CR.Right-Dim.Right) div 2 + CR.Left;

  if CR.Bottom < Dim.Bottom then
    result.Top := CR.Top
  else
    result.Top := (CR.Bottom-Dim.Bottom) div 2 + CR.Top;
end;

//------------- TBorderArranger ----------------------------------------------
constructor TBorderArranger.Create(hParent: HWND);
begin
  inherited Create(hParent);

  Dispatcher.TrapMessage(WM_SIZE,self);
  FUpperHeight := 0;
  FLowerHeight := 0;
  FLeftWidth := 0;
  FRightWidth  := 0;
  FXMargin := 0;
  FYMargin := 0;
  FXSep := 1;
  FYSep := 1;
end;

procedure TBorderArranger.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(Message);
  case AMsg.Msg of
    WM_SIZE:begin
      if Assigned(FOnSize) then begin
        AMsg.Msg := UINT(self); // sender
        OnSize(AMsg);
      end;
    end;
  end; // case
end;

function TBorderArranger.Arrange(BorderPos:TBorderPos): TRect;
var
  CR: TRect;
begin
  GetClientRect(FParent,CR);
  case BorderPos of
    bpUpper: begin
      result.Left := FXMargin;
      result.Top := FYMargin;
      result.Right := CR.Right-FXMargin*2;
      result.Bottom := FUpperHeight;
    end;
    bpLower: begin
      result.Left := FXMargin;
      result.Top := CR.Bottom-FYMargin-FLowerHeight;
      result.Right := CR.Right-FXMargin*2;
      result.Bottom := FLowerHeight;
    end;
    bpLeft: begin
      result.Left := FXMargin;
      result.Top := FYMargin+FUpperHeight+FYSep;
      result.Right := FLeftWidth;
      result.Bottom := CR.Bottom-FUpperHeight-FLowerHeight-FYMargin*2-FYSep*2;
    end;
    bpRight: begin
      result.Left := CR.Right-FXMargin-FRightWidth;
      result.Top := FYMargin+FUpperHeight+FYSep;
      result.Right := FRightWidth;
      result.Bottom := CR.Bottom-FUpperHeight-FLowerHeight-FYMargin*2-FYSep*2;
    end;
    bpCenter: begin
      result.Left := FXMargin+FLeftWidth+XSep;
      result.Top := FYMargin+FUpperHeight+YSep;
      result.Right := CR.Right-FLeftWidth-FRightWidth-FXSep*2-FXMargin*2;
      result.Bottom := CR.Bottom-FUpperHeight-FLowerHeight-FYMargin*2-FYSep*2;
    end;
  end;
end;

//------------- MessageTrapper ---------------------------------
constructor TMessageTrapper.Create(hParent: HWND);
begin
  inherited Create(hParent);
  FTrapMessage := TIntegerList.Create(1,1);
  FHandler := TIntegerList.Create(1,1);
end;

destructor TMessageTrapper.Destroy;
begin
  FTrapMessage.Free;
  FHandler.Free;
  inherited Destroy;
end;

procedure TMessageTrapper.DefaultHandler(var Message);
var
  AMsg: TMessage;
  i: integer;
begin
  AMsg := TMessage(Message);
  for i := 0 to FNumTrap-1 do
    if AMsg.Msg = DWORD(FTrapMessage[i]) then
      if FHandler[i] <> 0 then begin
        TNotifyMessage(FHandler[i])(AMsg);
        if AMsg.Result <> 0 then
          TMessage(Message).result := AMsg.Result;
      end;
end;

procedure TMessageTrapper.TrapMessage(TrapMsg: UINT;Handler: TNotifyMessage);
begin
  FTrapMessage.Add(TrapMsg);
  FHandler.Add(integer(@Handler));
  Dispatcher.TrapMessage(TrapMsg,self);
  inc(FNumTrap);
end;

//-------------  TAPIGFont  -----------------------------------------------
function FindFontProc(lpelf: PEnumLogFont;
                      lpntm: PNewTextMetric;
                      nFontType: integer;
                      lParam: LParam):integer; stdcall; export;
begin
  PLogFont(lParam)^ := lpelf^.elfLogFont;
  Result := 1;
end;

constructor TAPIGFont.Create;
var
  hF: HFONT;
begin
  hf := GetStockObject(SYSTEM_FONT);
  GetObject(hF,SizeOf(FLogFont),@FLogFont);
  FName := FLogFont.lfFacename;
  FSize := 12;
  FEscapement := FLogFont.lfEscapement;
  FBold := (FLogFont.lfWeight > 300);
  FItalic := (FLogFont.lfItalic <> 0);
  FUnderline := (FLogFont.lfUnderline <> 0);
  FStrikeOut := (FLogFont.lfStrikeOut <> 0);
end;

procedure TAPIGFont.SelectHandle(DC: HDC);
begin
  If FName = 'System' then Exit;
  EnumFontFamilies(DC,PChar(FName),@FindFontProc,integer(@FLogFont));
  with FLogFont do begin
    lfHeight := -MulDiv(FSize,GetDeviceCaps(DC,LOGPIXELSY),72);
    lfWidth := 0;
    lfEscapement := FEscapement;
    if FBold then lfWeight := FW_BOLD else lfWeight := FW_NORMAL;
    if FItalic then lfItalic := 1 else lfItalic := 0;
    if FUnderline then lfUnderline := 1 else lfUnderline := 0;
    if FStrikeOut then lfStrikeOut := 1 else lfStrikeOut := 0;
  end;
  FHandle := CreateFontIndirect(FLogFont);
  FPrevHandle := SelectObject(DC,FHandle);
  SetTextColor(DC,FColor);
end;

procedure TAPIGFont.DeleteHandle(DC: HDC);
begin
  If FName = 'System' then Exit;
  if FHandle<>0 then begin
    SelectObject(DC,FPrevHandle);
    DeleteObject(FHandle);
    FHandle := 0;
    SetTextColor(DC,0);
  end;
end;

procedure TAPIGFont.SetLogFont(value: TLogFont);
var
  IC: HDC;
begin
  FLogFont := value;
  FName := value.lfFaceName;
  IC := CreateIC('DISPLAY',nil,nil,nil);
  FSize := ((value.lfHeight)*72) div GetDeviceCaps(IC,LOGPIXELSY);
  DeleteDC(IC);
  FEscapement := value.lfEscapement;
  FBold := (value.lfWeight > 500);
  FItalic := (value.lfItalic <> 0);
  FUnderline := (value.lfUnderline <> 0);
  FStrikeOut := (value.lfStrikeOut <> 0);
end;

function TAPIGFont.GetLogFont: TLogFont;
var
  IC: HDC;
begin
  IC := CreateIC('DISPLAY',nil,nil,nil);
  EnumFontFamilies(IC,PChar(FName),@FindFontProc,integer(@FLogFont));
  with FLogFont do begin
    lfHeight := -MulDiv(FSize,GetDeviceCaps(IC,LOGPIXELSY),72);
    DeleteDC(IC);
    lfWidth := 0;
    lfEscapement := FEscapement;
    if FBold then lfWeight := FW_BOLD else lfWeight := FW_NORMAL;
    if FItalic then lfItalic := 1 else lfItalic := 0;
    if FUnderline then lfUnderline := 1 else lfUnderline := 0;
    if FStrikeOut then lfStrikeOut := 1 else lfStrikeOut := 0;
  end;
  result := FLogFont;
end;

//-------------  TAPICFont  -----------------------------------------------
destructor TAPICFont.Destroy;
begin
  DeleteObject(FHandle);
  inherited Destroy;
end;

procedure TAPICFont.GetHandle;
begin
  DeleteObject(FHandle);
  FHandle := CreateFontIndirect(LogFont);
end;

procedure TAPICFont.SetHandle(ctlHandle: HWND);
begin
  SendMessage(ctlHandle,WM_SETFONT,FHandle,1);
end;

procedure TAPICFont.ResetHandle(ctlHandle: HWND);
begin
  SendMessage(ctlHandle,WM_SETFONT,0,1);
end;

//------------- File Function -----------------------------------------
function GetLowDir(var Path: string): Boolean;
var
  p,Len: integer;
begin
  result := false;
  p := Pos('\',Path);
  if p <> 0 then begin
    result := true;
    Len := Length(Path)-p;
    Path := Copy(Path,p+1,Len);
    SetLength(Path,Len);
  end;
end;

function AExtractFileName(s: string):string;
var
  Path: string;
begin
  Path := s;
  while GetLowDir(Path) do result := Path;
end;

function AExtractDir(s: string): string;
var
  fn: string;
begin
  fn := AExtractFileName(s);
  result := Copy(s,0,Length(s)-Length(fn)-1);
end;

function AExtractExt(s: string): string;
var
  fn: string;
  i: integer;
begin
  fn := AExtractFileName(s);
  i := Pos('.',fn);
  if i <> 0 then
    result := Copy(fn,i+1,Length(fn))
  else
    result := '';
end;

procedure FindAllFilesWithExt(dir,ext:string;SL:TStringArray);
var
  s: string;
  hFind: THandle;
  fd: TWin32FindData;
  Ret: Boolean;
begin
  s := dir + '\*.'+ext;
  hFind := FindFirstFile(PChar(s),fd);

  Ret := true;
  while ( (hFind <> INVALID_HANDLE_VALUE) and Ret ) do begin
    if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
      SL.Add(string(fd.cFileName));
    Ret := FindNextFile(hFind,fd);
  end;
  Windows.FindClose(hFind);
end;

procedure FindAllFiles(dir:string;SL:TStringArray);
begin
  FindAllFilesWithExt(dir,'*',SL);
end;

function GetFileSize(FullPath: string): integer;
var
  fd: TWin32FindData;
begin
  FindClose(FindFirstFile(PChar(FullPath),fd));
  result := fd.nFileSizeLow;
end;

function GetFileCreationTime(FullPath: string): TSystemTime;
var
  fd: TWin32FindData;
  ft: TFileTime;
begin
  FindClose(FindFirstFile(PChar(FullPath),fd));
  FileTimeToLocalFileTime(fd.ftCreationTime,ft);
  FileTimeToSystemTime(ft,result);
end;

function GetFileLastAccessTime(FullPath: string): TSystemTime;
var
  fd: TWin32FindData;
  ft: TFileTime;
begin
  FindClose(FindFirstFile(PChar(FullPath),fd));
  FileTimeToLocalFileTime(fd.ftLastAccessTime,ft);
  FileTimeToSystemTime(ft,result);
end;

function GetFileLastWriteTime(FullPath: string): TSystemTime;
var
  fd: TWin32FindData;
  ft: TFileTime;
begin
  FindClose(FindFirstFile(PChar(FullPath),fd));
  FileTimeToLocalFileTime(fd.ftLastWriteTime,ft);
  FileTimeToSystemTime(ft,result);
end;

function GetFileAttributes(FullPath: string): DWORD;
var
  fd: TWin32FindData;
begin
  FindClose(FindFirstFile(PChar(FullPath),fd));
  result := fd.dwFileAttributes;
end;

procedure DisplayLogFont(lf: TLogFont; SA: TStringArray);
var
  s: string;
begin
  SA.Clear;
  SA.Add(' FontName :'#9+ string(lf.lfFaceName));
  SA.Add(' Height :'#9+ AIntToStr(lf.lfHeight));
  SA.Add(' Width :  '#9+ AIntToStr(lf.lfWidth));
  SA.Add(' Escapement :'#9+ AIntToStr(lf.lfEscapement));
  SA.Add(' Orientation :'#9+ AIntToStr(lf.lfOrientation));
  case lf.lfWeight of
    0: s := 'DONTCARE';
    100: s := 'THIN';
    200: s := 'EXTRALIGHT';
    300: s := 'LIGHT';
    400: s := 'NORMAL';
    500: s := 'MEDIUM';
    600: s := 'SEMIBOLD';
    700: s := 'BOLD';
    800: s := 'EXTRABOLD';
    900: s := 'HEAVY';
  else
    s :=  AIntToStr(lf.lfWeight);
  end;
  SA.Add(' Weight :'#9+s);
  if lf.lfItalic = 0 then s := 'No' else s := 'Yes';
  SA.Add(' Italic :   '#9+ s);
  if lf.lfUnderline = 0 then s := 'No' else s := 'Yes';
  SA.Add(' Underline :   '#9+ s);
  if lf.lfStrikeOut = 0 then s := 'No' else s := 'Yes';
  SA.Add(' StrikeOut :   '#9+ s);
  case lf.lfCharSet of
    0: s := 'ANSI_CHARSET';
    1: s := 'DEFAULT_CHARSET';
    2: s := 'SYMBOL_CHARSET';
    128: s := 'SHIFTJIS_CHARSET';
    255: s := 'OEM_CHARSET';
    161: s := 'GREEK_CHARSET';
  else
    s := AIntToStr(lf.lfCharSet);
  end;
  SA.Add(' CharSet :   '#9+ s);
  case lf.lfOutPrecision of
    0: s := 'OUT_DEFAULT_PRECIS';
    1: s := 'OUT_STRING_PRECIS';
    2: s := 'OUT_CHARACTER_PRECIS';
    3: s := 'OUT_STROKE_PRECIS';
    4: s := 'OUT_TT_PRECIS';
    5: s := 'OUT_DEVICE_PRECIS';
    6: s := 'OUT_RASTER_PRECIS';
    7: s := 'OUT_TT_ONLY_PRECIS';
    8: s := 'OUT_OUTLINE_PRECIS';
    9: s := 'OUT_SCREEN_OUTLINE_PRECIS';
  else
    s := AIntToStr(lf.lfOutPrecision);
  end;
  SA.Add(' OutPrecision :   '#9+ s);
  case lf.lfClipPrecision of
    0: s := 'CLIP_DEFAULT_PRECIS';
    1: s := 'CLIP_CHARACTER_PRECIS';
    2: s := 'CLIP_STROKE_PRECIS';
  else
    s := AIntToStr(lf.lfClipPrecision);
  end;
  SA.Add(' ClipPrecision : '#9+ s);
  case lf.lfQuality of
    0: s := 'DEFAULT_QUALITY';
    1: s := 'DRAFT_QUALITY';
    2: s := 'PROOF_QUALITY';
    3: s := 'NONANTIALIASED_QUALITY';
    4: s := 'ANTIALIASED_QUALITY';
  else
    s := AIntToStr(lf.lfQuality);
  end;
  SA.Add(' Quality : '#9+ s);
  case (lf.lfPitchAndFamily and $F) of
    0: s := 'DEFAULT_PITCH';
    1: s := 'FIXED_PITCH';
    2: s := 'VARIABLE_PITCH';
    8: s := 'MONO_FONT';
  else
    s := AIntToStr(lf.lfPitchAndFamily and $F);
  end;
  SA.Add(' Pitch :    '#9+ s);
  case (lf.lfPitchAndFamily shr 4) of
    0: s := 'FF_DONTCARE';
    1: s := 'FF_ROMAN';
    2: s := 'FF_SWISS';
    3: s := 'FF_MODERN';
    4: s := 'FF_SCRIPT';
    5: s := 'FF_DECORATIVE';
  else
    s := AIntToStr(lf.lfPitchAndFamily shr 4);
  end;
  SA.Add(' Family :    '#9+ s);
end;

function GetOpenFile(hOwner:HWND;defName,Filter,initDir:string;
                     var FLN:TOpenSave):Boolean;
var
  OFN: TOpenFileName;
  PATH: string;
begin
  PATH := defName+#0;
  SetLength(PATH,MAX_PATH+5);
  FillChar(OFN,SizeOf(OFN),0);
  with OFN do begin
    lStructSize := 76; // for Delphi6
    hWndOwner := hOwner;
    lpstrFilter := PChar(Filter);
    nFilterIndex := 1;
    lpstrFile := PChar(PATH);
    nMaxFile:= MAX_PATH+5;
    lpstrInitialDir := PChar(initDir);
    Flags := OFN_FILEMUSTEXIST or OFN_HIDEREADONLY;
  end;

  result := Boolean(GetOpenFileName(OFN));
  if result then begin
    FLN.FullName := (OFN.lpstrFile);
    FLN.Path := Copy(PATH,0,OFN.nFileOffset);
    FLN.FileName := Copy(PATH,OFN.nFileOffset+1,Length(PATH));
    FLN.Ext := Copy(PATH,OFN.nFileExtension+1,Length(PATH));
  end;
end;

function GetSaveFile(hOwner:HWND;defName,Filter,initDir:string;
                     var FLN:TOpenSave):Boolean;
var
  OFN: TOpenFileName;
  PATH: string;
begin
  PATH := defName+#0;
  SetLength(PATH,MAX_PATH+5);
  FillChar(OFN,SizeOf(OFN),0);
  with OFN do begin
    lStructSize := 76; // for Delphi6
    hWndOwner := hOwner;
    lpstrFilter := PChar(Filter);
    nFilterIndex := 1;
    lpstrFile := PChar(PATH);
    nMaxFile:= MAX_PATH+5;
    lpstrInitialDir := PChar(initDir);
    Flags := OFN_OVERWRITEPROMPT or OFN_HIDEREADONLY;
  end;

  result := Boolean(GetSaveFileName(OFN));
  if result then begin
    FLN.FullName := (OFN.lpstrFile);
    FLN.Path := Copy(PATH,0,OFN.nFileOffset);
    FLN.FileName := Copy(PATH,OFN.nFileOffset+1,Length(PATH));
    FLN.Ext := Copy(PATH,OFN.nFileExtension+1,Length(PATH));
  end;
end;

function CountSpace(s: string):integer;
var
  i: integer;
begin
  result := 0;
  for i := 1 to Length(s) do
    if s[i] = ' ' then inc(result);
end;

function GetMultFileName(s:string;SL:TStringArray):integer;
var
  IC,i: integer;
  IL: TIntegerList;
begin
  SL.Clear;
  IC := CountSpace(s);
  if IC = 0 then begin
    SL.Add(AExtractDir(s)+'\');
    SL.Add(AExtractFileName(s));
    result := 1;
  end else begin
    IL := TIntegerList.Create(IC*SizeOf(integer),SizeOf(integer));
    for i := 1 to Length(s) do
      if s[i] = ' ' then IL.Add(i);
    SL.Add(Copy(s,1,IL[0]-1));
    if Copy(SL[0],Length(SL[0]),1)<>'\' then
      SL[0]:=SL[0]+'\';
    for i := 1 to IC-1 do
      SL.Add(Copy(s,IL[i-1]+1,IL[i]-IL[i-1]-1));
    SL.Add(Copy(s,IL[IC-1]+1,100));
    IL.Free;
    result := IC;
  end;
end;

function GetOpenFileMult(hOwner:HWND;defName,Filter,initDir:string;
                         STL:TStringArray;var NumFile:integer):Boolean;
var
  OFN: TOpenFileName;
  s: string;
  PATH: array[0..8000] of Char;
  i: integer;
  flag: Boolean;
begin
  FillChar(PATH,8001,0);
  for i := 0 to Length(defName)-1 do PATH[i] := defName[i+1];
  FillChar(OFN,SizeOf(OFN),0);
  with OFN do begin
    lStructSize := 76; // for Delphi6
    hWndOwner := hOwner;
    lpstrFilter := PChar(Filter);
    nFilterIndex := 1;
    lpstrFile := @PATH;
    nMaxFile:= 8000;
    lpstrInitialDir := PChar(initDir);
    Flags := OFN_FILEMUSTEXIST or OFN_HIDEREADONLY or
             OFN_ALLOWMULTISELECT or OFN_EXPLORER;
  end;

  result := Boolean(GetOpenFileName(OFN));
  if result then begin
    flag := true;
    i := 0;
    while flag do begin
      if PATH[i] = #0 then
        if PATH[i+1] = #0 then flag := false else PATH[i] := ' ';
      inc(i);
    end;
    SetString(s,PChar(@PATH),lstrlen(@PATH));
    NumFile := GetMultFileName(s,STL);
  end;
end;

function SHCopyFile(hParent:HWND;NameFrom,NameTo:string):Boolean;
var
  SFO: TSHFileOpStruct;
begin
  NameFrom := NameFrom+#0#0;
  NameTo := NameTo+#0#0;
  with SFO do begin
    Wnd := hParent;
    wFunc := FO_COPY;
    pFrom := PChar(NameFrom);
    pTo := PChar(NameTo);
    fFlags := FOF_ALLOWUNDO;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := not Boolean(SHFileOperation(SFO));
end;

function SHMoveFile(hParent:HWND;NameFrom,NameTo:string):Boolean;
var
  SFO: TSHFileOpStruct;
begin
  NameFrom := NameFrom+#0#0;
  NameTo := NameTo+#0#0;
  with SFO do begin
    Wnd := hParent;
    wFunc := FO_MOVE;
    pFrom := PChar(NameFrom);
    pTo := PChar(NameTo);
    fFlags := FOF_ALLOWUNDO;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := not Boolean(SHFileOperation(SFO));
end;

function SHRenameFile(hParent:HWND;NameFrom,NameTo:string):Boolean;
var
  SFO: TSHFileOpStruct;
begin
  NameFrom := NameFrom+#0#0;
  NameTo := NameTo+#0#0;
  with SFO do begin
    Wnd := hParent;
    wFunc := FO_RENAME;
    pFrom := PChar(NameFrom);
    pTo := PChar(NameTo);
    fFlags := FOF_ALLOWUNDO;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := not Boolean(SHFileOperation(SFO));
end;

function SHDeleteFile(hParent:HWND;Name:string):Boolean;
var
  SFO: TSHFileOpStruct;
begin
  Name := Name+#0#0;
  with SFO do begin
    Wnd := hParent;
    wFunc := FO_DELETE;
    pFrom := PChar(Name);
    pTo := nil;
    fFlags := FOF_ALLOWUNDO + FOF_NOCONFIRMATION;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := not Boolean(SHFileOperation(SFO));
end;

procedure FindAllDirInDir(dir:string;SL:TStringArray);
var
  s: string;
  hFind: LongInt;
  fd: TWin32FindData;
  Ret: Boolean;
begin
  s := dir + '\*.*';
  hFind := FindFirstFile(PChar(s),fd);

  Ret := true;
  while ( (hFind <> LongInt(INVALID_HANDLE_VALUE)) and Ret ) do begin
    if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) <> 0 then begin
      SetString(s,fd.cFileName,1);
      if s <> '.' then
        SL.Add(string(fd.cFileName));
    end;
    Ret := FindNextFile(hFind,fd);
  end;
  Windows.FindClose(hFind);
end;

function IsFileExist(FN: string):Boolean;
var
  fd: TWin32FindData;
  hH: THandle;
  ret: integer;
begin
  hH := FindFirstFile(PChar(FN),fd);
  if hH = INVALID_HANDLE_VALUE then begin
    ret := GetDriveType(PChar(FN+'\'));
    if (ret = DRIVE_FIXED) or (ret = DRIVE_REMOVABLE) then
      result := true
    else
      result := false;
  end else begin
    result := true;
    FindClose(hH);
  end;
end;

function CreateDir(DN:string):Boolean;
var
  s:string;
begin
  s := AExtractDir(DN);
  if IsFileExist(s) then
    result := Boolean(CreateDirectory(PChar(DN),nil))
  else
    if CreateDir(s) then
      result := Boolean(CreateDirectory(PChar(DN),nil))
    else
      result := false;
end;

function RemoveDirAll(DN:string):Boolean;
var
  i: integer;
  SA: TStringArray;
begin
  SA := TStringArray.Create;
  FindAllFiles(DN+'\',SA);
  if SA.Count > 0 then
    for i := 0 to SA.Count-1 do SHDeleteFile(0,DN+'\'+SA[i]);
  SA.Clear;

  FindAllDirInDir(DN,SA);
  if SA.Count > 0 then
    for i := 0 to SA.Count-1 do RemoveDirAll(DN+'\'+SA[i]);
  result := Boolean(RemoveDirectory(PChar(DN)));
  SA.Free;
end;

procedure FindAllFilesWithSubdir(DN:string;SL:TStringArray);
var
  i,j: integer;
  SA,SB: TStringArray;
begin
  SA := TStringArray.Create;
  FindAllFiles(DN+'\',SA);
  if SA.Count > 0 then
    for i := 0 to SA.Count-1 do SL.Add(DN+'\'+SA[i]);

  SA.Clear;
  SB := TStringArray.Create;
  FindAllDirInDir(DN,SA);
  if SA.Count > 0 then
    for i := 0 to SA.Count-1 do begin
      FindAllFilesWithSubdir(DN+'\'+SA[i],SB);
      if SB.Count > 0 then
        for j := 0 to SB.Count-1 do SL.Add(SB[j]);
      SB.Clear;
    end;
  SA.Free;
  SB.Free;
end;

function SHCopyDir(hParent:HWND;NameFrom,NameTo:string):Boolean;
var
  SFO: TSHFileOpStruct;
begin
  NameFrom := NameFrom+#0#0;
  NameTo := NameTo+#0#0;
  with SFO do begin
    Wnd := hParent;
    wFunc := FO_COPY;
    pFrom := PChar(NameFrom);
    pTo := PChar(NameTo);
    fFlags := FOF_ALLOWUNDO or FOF_NOCONFIRMMKDIR;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := not Boolean(SHFileOperation(SFO));
end;

function SHDeleteDir(hParent:HWND;Name:string):Boolean;
var
  SFO: TSHFileOpStruct;
begin
  Name := Name+#0#0;
  with SFO do begin
    Wnd := hParent;
    wFunc := FO_DELETE;
    pFrom := PChar(Name);
    pTo := nil;
    fFlags := FOF_ALLOWUNDO + FOF_NOCONFIRMATION;
    fAnyOperationsAborted := false;
    hNameMappings := nil;
  end;
  Result := not Boolean(SHFileOperation(SFO));
end;

//------------------------------------------------------------
//        Create Functions
//------------------------------------------------------------
function CreateTimer(hParent:HWND; Intrvl: integer;
                     OnTimerFunc: TNotifyMessage):TAPITimer;
begin
  result := TAPITimer.Create(hParent);
  with result do begin
    Interval := Intrvl;
    OnTimer := OnTimerFunc;
  end;
end;

function CreateGridArranger(hParent:HWND;iRow,iCol,XMrgn,YMrgn,
            XSp,YSp:integer; sOnSize:TNotifyMessage): TGridArranger;
begin
  result := TGridArranger.Create(hParent);
  with result do begin
    NumRow := iRow;
    NumCol := iCol;
    XMargin := XMrgn;
    YMargin := YMrgn;
    XSep := XSp;
    YSep := YSp;
    OnSize := sOnSize;
  end;
end;

function CreateBorderArranger(hParent:HWND;UH,LH,LW,RW,XMrgn,YMrgn,
            XSp,YSp:integer; sOnSize:TNotifyMessage): TBorderArranger;
begin
  result := TBorderArranger.Create(hParent);
  with result do begin
    UpperHeight := UH;
    LowerHeight := LH;
    LeftWidth := LW;
    RightWidth := RW;
    XMargin := XMrgn;
    YMargin := YMrgn;
    XSep := XSp;
    YSep := YSp;
    OnSize := sOnSize;
  end;
end;


initialization

finalization
  Dispatcher.Free;

end.