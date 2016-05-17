unit APIControl;

interface

uses
  Windows,
  Messages,
  UtilFunc,
  UTilClass;

type

TAPICreateParams = record
  Caption: string;
  Style: Longint;
  ExStyle: Longint;
  X, Y: Integer;
  Width, Height: Integer;
  WinClassName: array[0..63] of Char;
end;

//----------- TSelfSubClass -----------------------------------------
TSelfSubClass = class(TSubClass)
private
  FHandle: HWND;
  FID: HMenu;
protected
  procedure APICreateParams(var Params: TAPICreateParams); virtual; abstract;
  procedure Initialize; virtual; abstract;
public
  constructor Create(hParent: HWND); override;
  destructor Destroy; override;
  procedure DestroyObject;
  property Handle: HWND read FHandle;
  property ID: HMenu read FID;
end;

//----------- TAPIContol -------------------------------------------
TAPIControl = class(TSelfSubClass)
private
  function GetCaption: string;
  procedure SetCaption(value: string);
  function GetDimension: TRect;
  procedure SetDimension(value: TRect);
  function GetXPos: integer;
  procedure SetXPos(value: integer);
  function GetYPos: integer;
  procedure SetYPos(value: integer);
  function GetWidth: integer;
  procedure SetWidth(value: integer);
  function GetHeight: integer;
  procedure SetHeight(value: integer);
  function GetEnable: Boolean;
  procedure SetEnable(value:Boolean);
  function GetVisible: Boolean;
  procedure SetVisible(value: Boolean);
protected
  procedure Initialize; override;
public
  destructor Destroy; override;
  property Caption: string read GetCaption write SetCaption;
  property Dimension : TRect read GetDimension write SetDimension;
  property XPos: integer read GetXPos write SetXPos;
  property YPos: integer read GetYPos write SetYPos;
  property Width: integer read GetWidth write SetWidth;
  property Height: integer read GetHeight write SetHeight;
  property Enable: Boolean read GetEnable write SetEnable;
  property Visible: Boolean read GetVisible write SetVisible;
end;

//---------- TAPIButton ----------------------------------------------
TAPIButton = class(TAPIControl)
private
  FOnClick: TNotifyMessage;
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  procedure DefaultHandler(var Message); override;
  property OnClick: TNotifyMessage read FOnClick write FOnClick;
end;

//---------- TAPICheckBox ----------------------------------------------
TCBTextStyle = (cbtRight,cbtLeft);

TAPICheckBox = class(TAPIControl)
private
  FChecked: Boolean;
  FTextStyle: TCBTextStyle;
  FReadOnly: Boolean;
  FIndeterminate: Boolean;
  FOnClick: TNotifyMessage;
  procedure SetChecked(value:Boolean);
  procedure SetTextStyle(value:TCBTextStyle);
  procedure SetIndeterminate(value: Boolean);
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
  procedure Initialize; override;
public
  procedure DefaultHandler(var Message); override;
  property Checked: Boolean read FChecked write SetChecked;
  property TextStyle: TCBTextStyle read FTextStyle write SetTextStyle;
  property DoIndeterminate: Boolean read FIndeterminate write SetIndeterminate;
  property ReadOnly: Boolean read FReadOnly write FReadOnly;
  property OnClick: TNotifyMessage read FOnClick write FOnClick;
end;

//---------- TAPIRadioButton --------------------------------------------
TAPIRadioButton = class(TAPIControl)
private
  FTextStyle: TCBTextStyle;
  FGroupIndex: Integer;
  FOnClick: TNotifyMessage;
  function GetChecked:Boolean;
  procedure SetChecked(value:Boolean);
  procedure SetTextStyle(value:TCBTextStyle);
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
  procedure Initialize; override;
public
  procedure DefaultHandler(var Message); override;
  property Checked: Boolean read GetChecked write SetChecked;
  property TextStyle: TCBTextStyle read FTextStyle write SetTextStyle;
  property GroupIndex: integer read FGroupIndex write FGroupIndex;
  property OnClick: TNotifyMessage read FOnClick write FOnClick;
end;

//---------- APIPushRadio --------------------------------------------
TAPIPushRadio = class(TAPIRadioButton)
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
end;

//---------- APIGroupBox ---------------------------------------------
TGBTextAlign = (gbtLeft, gbtCenter, gbtRight);// TextAlign of APIGroupBox

TAPIGroupBox = class(TAPIControl)
private
  FTextAlign: TGBTextAlign;
  procedure SetTextAlign(value:TGBTextAlign);
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
  procedure Initialize; override;
public
  property TextAlign: TGBTextAlign read FTextAlign write SetTextAlign;
end;

//---------- APIListBoxBase ----------------------------------------------
TAPIListBoxBase = class(TAPIControl)
private
  FColor: COLORREF;
  FTxtColor: COLORREF;
  FRedraw: Boolean;
  FOnDoubleClick: TNotifyMessage;
  FOnSelChange: TNotifyMessage;
  function GetString(index:integer): string;
  procedure SetString(index: integer; value: string);
  function GetCount: integer;
  function GetTopIndex: integer;
  procedure SetTopIndex(value: integer);
  function GetItemData(index: integer):integer;
  procedure SetItemData(index,value: integer);
  procedure SetColor(value: COLORREF);
  procedure SetTxtColor(value: COLORREF);
  procedure SetRedraw(value: Boolean);
protected
  procedure Initialize; override;
public
  procedure DefaultHandler(var Message); override;
  function AddString(value: string):integer;
  function DeleteString(index: integer):integer;
  function InsertString(index: integer; value:string):integer;
  procedure Clear;
  function FindString(StartIndex:integer; s: string):integer;
  procedure DoSort;
  property ItemString[index:integer]: string read GetString write SetString;default;
  property Count: integer read GetCount;
  property TopIndex: integer read GetTopIndex write SetTopIndex;
  property ItemData[index:integer]: integer read GetItemData write SetItemData;
  property Color: COLORREF read FColor write SetColor;
  property TextColor: COLORREF read FTxtColor write SetTxtColor;
  property Redraw: Boolean read FRedraw write SetRedraw;
  property OnDoubleClick: TNotifyMessage read FOnDoubleClick write FOnDoubleClick;
  property OnSelChange: TNotifyMessage read FOnSelChange write FOnSelChange;
end;

//---------- APIListBox ----------------------------------------------
TAPIListBox = class(TAPIListBoxBase)
private
  procedure SetSelIndex(value: Integer);
  function GetSelIndex: integer;
  function GetSelString: string;
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  property SelIndex: integer read GetSelIndex write SetSelIndex;
  property SelText: string read GetSelString;
end;

//---------- APIMSListBox ----------------------------------------------
TAPIMSListBox = class(TAPIListBoxBase)
private
  function GetSelected(index: integer):Boolean;
  procedure SetSelected(index: integer; value: Boolean);
  function GetSelCount: integer;
  function GetCaretIndex: integer;
  procedure SetCaretIndex(index:integer);
  function GetCaretText: string;
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  property Selected[index:integer]: Boolean read GetSelected write SetSelected;
  property SelCount: integer read GetSelCount;
  property CaretIndex: integer read GetCaretIndex write SetCaretIndex;
  property CaretText: string read GetCaretText;
end;

//---------- TEnumFontListBox --------------------------------------------
TEnumFontListBox = class(TAPIListBox)
private
  FFontType: integer;
  function GetSelLogFont: TLogFont;
  procedure SetFontType(value: integer);
protected
  procedure Initialize; override;
public
  property SelLogFont: TLogFont read GetSelLogFont;
  property FontType: integer read FFontType write SetFontType;
end;

//---------- TAPIEditBase -------------------------------------
TAPIEditBase = class(TAPIControl)
private
  FColor: COLORREF;
  FTxtColor: COLORREF;
  FOnSetFocus: TNotifyMessage;
  FOnKillFocus: TNotifyMessage;
  FOnChange: TNotifyMessage;
  FOnUpdate: TNotifyMessage;
  FOnNotice: TNotifyMessage;
  function GetTextLength: integer;
  function GetText: string;
  procedure SetText(value: string);
  function GetCaretPos:integer;
  procedure SetCaretPos(value: integer);
  function GetSelTextLength: integer;
  function GetSelText:string;
  function GetReadOnly: Boolean;
  procedure SetReadOnly(value: Boolean);
  function GetLeftMargin: integer;
  procedure SetLeftMargin(value: integer);
  procedure SetColor(value: COLORREF);
  procedure SetTxtColor(value: COLORREF);
protected
  procedure Initialize; override;
public
  procedure DefaultHandler(var Message); override;
  procedure Cut;
  procedure Copy;
  procedure Paste;
  procedure Clear;
  procedure SelectAll;
  procedure ClearAll;
  property TextLength: integer read GetTextLength;
  property Text: string read GetText write SetText;
  property CaretPos: integer read GetCaretPos write SetCaretPos;
  property SelTextLength: integer read GetSelTextLength;
  property SelText: string read GetSelText;
  property ReadOnly: Boolean read GetReadOnly write SetReadOnly;
  property LeftMargin: integer read GetLeftMargin write SetLeftMargin;
  property Color: COLORREF read FColor write SetColor;
  property TextColor: COLORREF read FTxtColor write SetTxtColor;
  property OnSetFocus: TNotifyMessage read FOnSetFocus write FOnSetFocus;
  property OnKillFocus: TNotifyMessage read FOnKillFocus write FOnKillFocus;
  property OnChange: TNotifyMessage read FOnChange write FOnChange;
  property OnUpdate: TNotifyMessage read FOnUpdate write FOnUpdate;
  property OnNotice: TNotifyMessage read FOnNotice write FOnNotice;
end;

//---------- TAPIEdit ----------------------------------------------
TAPIEdit = class(TAPIEditBase)
private
  function GetNumEdit:Boolean;
  procedure SetNumEdit(value:Boolean);
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  property NumEdit: Boolean read GetNumEdit write SetNumEdit;
end;

//---------- TAPIPasswordEdit ----------------------------------------------
TAPIPasswordEdit = class(TAPIEdit)
private
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
end;

//---------- TAPIMemo -----------------------------------------------
TAPIMemo = class(TAPIEditBase)
private
  function GetLineCount: integer;
  function GetCanUndo: Boolean;
  procedure SetModified(value: Boolean);
  function GetModified: Boolean;
  function GetLineNo: integer;
  function GetColNo: integer;
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
  procedure Initialize; override;
public
  procedure Undo;
  procedure Add(s: string);
  procedure LoadText(filename:string);
  procedure SaveText(filename:string);
  procedure SetSelRange(StartPos,EndPos:integer);
  procedure GetSelRange(var StartPos,EndPos: integer);
  procedure ReplaceSel(s:string);
  procedure ScrollCaret;
  procedure Scroll(line:integer);
  procedure SetTabStop(value: integer);
  function FindString(s: string; StartPos:integer):integer;
  function GetLineLength(line: integer):integer;
  function GetLineFromChar(CharPos: integer):integer;
  function GetLine(line: integer): string;
  property LineCount: integer read GetLineCount;
  property CanUndo: Boolean read GetCanUndo;
  property LineNo: Integer read GetLineNo;
  property ColNo: integer read GetColNo;
  property Modified: Boolean read GetModified write SetModified;
end;

//--------- TAPIComboBoxBase --------------------------------------------
TAPIComboBoxBase = class(TAPIControl)
private
  FResultText: string;
  FOnSelChange: TNotifyMessage;
  function GetSelText:string;
  function GetSelIndex:integer;
  procedure SetSelIndex(index:integer);
  function GetCount: integer;
  function GetItemData(index:integer):integer;
  procedure SetItemData(index,value: integer);
protected
public
  function AddString(value: string):integer;
  procedure DeleteString(index:integer);
  function InsertString(value:string;index:integer):integer;
  function GetText(index: integer):string;
  procedure Clear;
  property SelText: string read GetSelText;
  property ResultText: string read FResultText;
  property SelIndex: integer read GetSelIndex write SetSelIndex;
  property Count: integer read GetCount;
  property ItemData[index:integer]:integer read GetItemData write SetItemData;
  property OnSelChange: TNotifyMessage read FOnSelChange write FOnSelChange;
end;

//--------- TAPIDDLCombo --------------------------------------------
TAPIDDLCombo = class(TAPIComboBoxBase)
private
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  procedure DefaultHandler(var Message); override;
  procedure ShowDropDown(value:Boolean);
end;

//--------- TAPISMPCombo --------------------------------------------
TAPISMPCombo = class(TAPIComboBoxBase)
private
  FOnEditChange: TNotifyMessage;
  function GetEditText:string;
  procedure SetEditText(value:string);
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  procedure DefaultHandler(var Message); override;
  property EditText: string read GetEditText write SetEditText;
  property OnEditChange: TNotifyMessage read FOnEditChange write FOnEditChange;
end;

//---------- TAPIDDCombo --------------------------------------------
TAPIDDCombo = class(TAPISMPCombo)
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
public
  procedure ShowDropDown(value:Boolean);
end;

//---------- TAPIDriveCombo -----------------------------------------
TAPIDriveCombo = class(TAPIDDLCombo)
private
  FRootDir: string;
  FVolumeName: string;
  FFileSystem: string;
  FSerialNumber: integer;
  FDiskSpace: integer;
  FUsedSpace: integer;
  FFreeSpace: integer;
protected
  procedure Initialize; override;
  function GetVolumeName(Root: string):string;
public
  procedure DefaultHandler(var Message); override;
  procedure GetVolumeInfo(Root: string);
  property RootDir: string read FRootDir;
  property VolumeName: string read FVolumeName;
  property FileSystem: string read FFileSystem;
  property SerialNumber: integer read FSerialNumber;
  property DiskSpace: integer read FDiskSpace;
  property UsedSpace: integer read FUsedSpace;
  property FreeSpace: integer read FFreeSpace;
end;

//---------- TEnumFontComboBox --------------------------------------------
TEnumFontComboBox = class(TAPIDDLCombo)
private
  FFontType: integer;
  function GetSelLogFont: TLogFont;
  procedure SetFontType(value: integer);
protected
  procedure Initialize; override;
public
  property SelLogFont: TLogFont read GetSelLogFont;
  property FontType: integer read FFontType write SetFontType;
end;

//--------- APIHScroll --------------------------------------------
TAPIHScroll = class(TAPIControl)
private
  FLargeChange: integer;
  FSmallChange: integer;
  FColor: COLORREF;
  FOnChange: TNotifyMessage;
  FOnTrack: TNotifyMessage;
  function GetMin:integer;
  procedure SetMin(value:integer);
  function GetMax:integer;
  procedure SetMax(value:integer);
  function GetPosition: integer;
  procedure SetPosition(value: integer);
  function GetThumbSize: integer;
  procedure SetThumbSize(ASize: integer);
  procedure SetColor(value: COLORREF);
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
  procedure Initialize; override;
public
  procedure DefaultHandler(var Message); override;
  property Min: integer read GetMin write SetMin;
  property Max: integer read GetMax write SetMax;
  property Position: integer read GetPosition write SetPosition;
  property LargeChange: integer read FLargeChange write FLargeChange;
  property SmallChange: integer read FSmallChange write FSmallChange;
  property ThumbSize: integer read GetThumbSize write SetThumbSize;
  property Color: COLORREF read FColor write SetColor;
  property OnChange: TNotifyMessage read FOnChange write FOnChange;
  property OnTrack: TNotifyMessage read FOnTrack write FOnTrack;
end;

//--------- APIVScroll --------------------------------------------
TAPIVScroll = class(TAPIHScroll)
protected
  procedure APICreateParams(var Params: TAPICreateParams); override;
end;


//
//---------- Create Functions ---------------------------------------
//
function CreateButton(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
                      sOnClick:TNotifyMessage): TAPIButton;
function CreateCheckBox(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
                      sOnClick:TNotifyMessage): TAPICheckBox;
function CreateRadioButton(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
            Group: integer; sOnClick:TNotifyMessage): TAPIRadioButton;

function CreatePushRadio(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
            Group: integer; sOnClick:TNotifyMessage): TAPIPushRadio;
function CreateGroupBox(hParent: HWND; x,y,cx,cy: integer;
                       sCaption: string): TAPIGroupBox;
function CreateListBox(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIListBox;
function CreateMSListBox(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIMSListBox;
function CreateEdit(hParent: HWND; x,y,cx,cy: integer; txt: string;
                      sOnChange:TNotifyMessage): TAPIEdit;

function CreatePasswordEdit(hParent: HWND; x,y,cx,cy: integer; txt: string;
                      sOnChange:TNotifyMessage): TAPIPasswordEdit;
function CreateMemo(hParent: HWND; x,y,cx,cy: integer): TAPIMemo;
function CreateDDLCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIDDLCombo;

function CreateSMPCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPISMPCombo;

function CreateDDCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIDDCombo;
function CreateDriveCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIDriveCombo;
function CreateHScroll(hParent: HWND; x,y,cx,cy: integer;
                      sOnTrackChange:TNotifyMessage): TAPIHScroll;
                      
function CreateVScroll(hParent: HWND; x,y,cx,cy: integer;
                      sOnTrackChange:TNotifyMessage): TAPIVScroll;


implementation


var
  ID_CONT: integer = 400;

//----------- TSelfSubClass -----------------------------------------
function SelfSubClassProc(hWnd: HWND; Msg: UINT;
                       wParam: WPARAM; lParam: LPARAM): LRESULT; stdcall;
var
  PascalObject: TSelfSubClass;
  OriginalProc: TFNWndProc;
  SBMsg: TMessage;
begin
  OriginalProc := TFNWndProc(GetProp(hWnd,'WNDPROC'));
  result := CallWindowProc(OriginalProc,hWnd,Msg,wParam,lParam);
  PascalObject := TSelfSubClass(GetProp(hWnd,'OBJECT'));

  case Msg of

    WM_DESTROY: if Assigned(PascalObject) then PascalObject.Free;

  else
    if Assigned(PascalObject) then begin
      SBMsg.Msg := Msg;
      SBMsg.WParam := wParam;
      SBMsg.LParam := lParam;
      SBMsg.Result := 0;
      PascalObject.Dispatch(SBMsg);
      if SBMsg.Result <> 0 then result := SBMsg.Result;
    end;
  end; // case

end;

constructor TSelfSubClass.Create(hParent: HWnd);
var
  Params: TAPICreateParams;
  DefWndProc: TFNWndProc;
begin
  inherited Create(hParent);
  APICreateParams(Params);
  with Params do begin
    FHandle := CreateWindowEx(ExStyle,WinClassName,PChar(Caption),
                Style,X, Y, Width, Height,
                hParent,
                ID_CONT,
                hInstance,
                nil);
  end;

  if IsWindow(FHandle) then begin
    SetProp(FHandle,'OBJECT',Integer(self));
    DefWndProc := TFNWndProc(SetWindowLong(FHandle,
                            GWL_WNDPROC,Integer(@SelfSubClassProc)));
    SetProp(FHandle,'WNDPROC',integer(DefWndProc));
  end;

  FID := ID_CONT; Inc(ID_CONT);

  Initialize;
end;

destructor TSelfSubClass.Destroy;
begin
  SetWindowLong(FHandle,GWL_WNDPROC,GetProp(FHandle,'WNDPROC'));
  RemoveProp(FHandle,'OBJECT');
  RemoveProp(FHandle,'WNDPROC');
  inherited Destroy;
end;

procedure TSelfSubClass.DestroyObject;
begin
  DestroyWindow(FHandle);
end;

//----------- TAPIControl -----------------------------------------
destructor TAPIControl.Destroy;
begin
                        
  inherited Destroy;
end;

procedure TAPIControl.Initialize;
begin
  Dispatcher.TrapMessage(WM_COMMAND,self);
end;

function TAPIControl.GetCaption: string;
var
  s: string;
begin
  SetLength(s,50);
  SetString(result,PChar(s),GetWindowText(FHandle,PChar(s),50));
end;

procedure TAPIControl.SetCaption(value: string);
begin
  SetWindowText(FHandle, PChar(Value));
end;

function TAPIControl.GetDimension: TRect;
begin
  result := SetDim(XPos,YPos,Width,Height);
end;

procedure TAPIControl.SetDimension(value: TRect);
begin
  MoveWindow(FHandle,value.left, value.top,
                   value.right, value.bottom, true);
end;

function TAPIControl.GetXPos: integer;
var
  r: TRect;
  p: TPoint;
begin
  GetWindowRect(FHandle,r);
  p.x := r.Left; p.y := r.Top;
  ScreenToClient(Parent,p);
  result := p.x;
end;

procedure TAPIControl.SetXPos(value: integer);
begin
  ChangeWindowPos(FHandle,value,YPos);
end;

function TAPIControl.GetYPos: integer;
var
  r: TRect;
  p: TPoint;
begin
  GetWindowRect(FHandle,r);
  p.x := r.Left; p.y := r.Top;
  ScreenToClient(Parent,p);
  result := p.y;
end;

procedure TAPIControl.SetYPos(value: integer);
begin
  ChangeWindowPos(FHandle,XPos,value);
end;

function TAPIControl.GetWidth: integer;
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  result := r.Right-r.Left;
end;

procedure TAPIControl.SetWidth(value: integer);
begin
  ChangeWindowSize(FHandle,value,Height);
end;

function TAPIControl.GetHeight: integer;
var
  r: TRect;
begin
  GetWindowRect(FHandle,r);
  result := r.Bottom-r.Top;
end;

procedure TAPIControl.SetHeight(value: integer);
begin
  ChangeWindowSize(FHandle,Width,value);
end;

function TAPIControl.GetEnable: Boolean;
begin
  result := Boolean(IsWindowEnabled(FHandle));
end;

procedure TAPIControl.SetEnable(value: Boolean);
begin
  EnableWindow(FHandle,value);
end;

function TAPIControl.GetVisible: Boolean;
begin
  result := Boolean(IsWindowVisible(FHandle));
end;

procedure TAPIControl.SetVisible(value:Boolean);
begin
  if value then
    ShowWindow(FHandle,SW_SHOWNORMAL)
  else
    ShowWindow(FHandle,SW_HIDE);
end;

//--------------- TAPIButton ----------------------------------------------
procedure TAPIButton.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := 'APIButton';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or BS_PUSHBUTTON;
    ExStyle := 0;
    X := 0;
    Y := 0;
    Width := 0;
    Height := 0;
    WinClassName := 'BUTTON';
  end;
end;

procedure TAPIButton.DefaultHandler(var Message);
var
  AMsg:TMessage;
begin
  AMsg := TMessage(message);
  case AMsg.Msg of
    WM_COMMAND:
      if (AMsg.LParam = LongInt(FHandle)) and (AMsg.WParamHi = BN_CLICKED) then
         if Assigned(FOnClick) then begin
           AMsg.Msg := UINT(self); // Sender
           OnClick(AMsg);
         end;
  end; // case
end;

//
//---------- Create Functions ---------------------------------------
//
function CreateButton(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
                      sOnClick:TNotifyMessage): TAPIButton;
begin
  result := TAPIButton.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Caption := sCaption;
    OnClick := sOnClick;
  end;
end;

//---------- TAPICheckBox ----------------------------------------------
procedure TAPICheckBox.Initialize;
begin
  inherited Initialize;

  FChecked := false;
  FTextStyle := cbtRight;
  FReadOnly := false;
  FIndeterminate := false;
end;

procedure TAPICheckBox.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := 'APICheckBox';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or BS_3STATE;
    ExStyle := 0;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'BUTTON';
  end;
end;

procedure TAPICheckBox.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  if FReadOnly then Exit;
  AMsg := TMessage(message);
  case AMsg.Msg of
    WM_COMMAND:
      if (AMsg.LParam = LPARAM(FHandle)) and (AMsg.WParamHi = BN_CLICKED) then begin
        Checked := not Checked;
        AMsg.Msg := UINT(self); // Sender
        if Assigned(FOnClick)then OnClick(AMsg);
      end;
  end; // case
end;

procedure TAPICheckBox.SetChecked(value:Boolean);
begin
  FChecked := value;
  if value then
    SendMessage(FHandle,BM_SETCHECK,BST_CHECKED,0)
  else
    SendMessage(FHandle,BM_SETCHECK,BST_UNCHECKED,0);
end;

procedure TAPICheckBox.SetTextStyle(value:TCBTextStyle);
var
  Style: LongInt;
begin
  if FTextStyle = value then exit;
  FTextStyle := value;
  Style := GetWindowLong(FHandle,GWL_STYLE);
  if value = cbtLeft then
    SetWindowLong(FHandle,GWL_STYLE,(Style or BS_LEFTTEXT))
  else
    SetWindowLong(FHandle,GWL_STYLE,(Style and (not BS_LEFTTEXT)));
  InvalidateRect(FHandle,nil,true);
end;

procedure TAPICheckBox.SetIndeterminate(value: Boolean);
begin
  if value then
    SendMessage(FHandle,BM_SETCHECK,BST_INDETERMINATE,0)
  else
    if FChecked then Checked := true else Checked := false;
  FIndeterminate := value;
end;

function CreateCheckBox(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
                      sOnClick:TNotifyMessage): TAPICheckBox;
begin
  result := TAPICheckBox.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Caption := sCaption;
    OnClick := sOnClick;
  end;
end;

//---------- TAPIRadioButton --------------------------------------------
procedure TAPIRadioButton.Initialize;
begin
  inherited Initialize;

  FTextStyle := cbtRight;
  FGroupIndex := 0;
end;

procedure TAPIRadioButton.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := 'APIRadioButton';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or BS_RADIOBUTTON;
    ExStyle := 0;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'BUTTON';
  end;
end;

function UnCheckSameRadioGroup(hWindow: HWND; Data:LParam): Boolean; stdcall;
var
  sobject: TObject;
begin
  result := true;
  if GetProp(hWindow,'OBJECT') <> 0 then begin
    sobject := TObject(GetProp(hWindow,'OBJECT'));
    if (sobject is TAPIRadioButton) and
          (TAPIRadioButton(sobject).GroupIndex = Data) then
       TAPIRadioButton(sobject).Checked := false;
  end;
end;

procedure UnCheckSameGroup(hParent: HWND; GroupIndex:Integer);
begin
  EnumChildWindows(hParent,@UnCheckSameRadioGroup,GroupIndex);
end;

procedure TAPIRadioButton.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(message);
  case AMsg.Msg of
    WM_COMMAND:
      if (AMsg.LParam = LPARAM(FHandle)) and (AMsg.WParamHi = BN_CLICKED) then begin
        if FGroupIndex = 0 then begin
          Checked := not Checked;
        end else begin // ÉOÉãÅ[ÉvâªÇ≥ÇÍÇƒÇ¢ÇÈ
          UnCheckSameGroup(Parent,FGroupIndex);
          Checked := true;
        end;
        AMsg.Msg := UINT(self);
        if Assigned(FOnClick)then OnClick(AMsg);
      end;
  end; // case
end;

function TAPIRadioButton.GetChecked:Boolean;
begin
  result := Boolean(SendMessage(FHandle,BM_GETCHECK,0,0));
end;

procedure TAPIRadioButton.SetChecked(value:Boolean);
begin
  if value then
    SendMessage(FHandle,BM_SETCHECK,1,0)
  else
    SendMessage(FHandle,BM_SETCHECK,0,0);
end;

procedure TAPIRadioButton.SetTextStyle(value:TCBTextStyle);
var
  Style: LongInt;
begin
  if FTextStyle = value then exit;
  FTextStyle := value;
  Style := GetWindowLong(FHandle,GWL_STYLE);
  if value = cbtLeft then
    SetWindowLong(FHandle,GWL_STYLE,(Style or BS_LEFTTEXT))
  else
    SetWindowLong(FHandle,GWL_STYLE,(Style and (not BS_LEFTTEXT)));
  InvalidateRect(FHandle,nil,true);
end;

//---------- TAPIPushRadio --------------------------------------------
procedure TAPIPushRadio.APICreateParams(var Params: TAPICreateParams);
begin
  inherited APICreateParams(Params);
  with Params do begin
    Caption := 'APIPushRadio';
    Style := Style or BS_PUSHLIKE;
  end;
end;

function CreateRadioButton(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
            Group: integer; sOnClick:TNotifyMessage): TAPIRadioButton;
begin
  result := TAPIRadioButton.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Caption := sCaption;
    GroupIndex := Group;
    OnClick := sOnClick;
  end;
end;

function CreatePushRadio(hParent: HWND; x,y,cx,cy: integer;sCaption: string;
            Group: integer; sOnClick:TNotifyMessage): TAPIPushRadio;
begin
  result := TAPIPushRadio.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Caption := sCaption;
    GroupIndex := Group;
    OnClick := sOnClick;
  end;
end;

//---------- APIGroupBox ---------------------------------------------
procedure TAPIGroupBox.Initialize;
begin
  inherited Initialize;
  FTextAlign := gbtLeft;
end;

procedure TAPIGroupBox.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := 'APIGroupBox';
    Style := WS_CHILD or WS_VISIBLE or  WS_CLIPSIBLINGS or
             BS_GROUPBOX or BS_LEFT;
    ExStyle := 0;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'BUTTON';
  end;
end;

procedure TAPIGroupBox.SetTextAlign(value:TGBTextAlign);
var
  Style,SetStyle: LongInt;
  r: TRect;
begin
  if FTextAlign = value then Exit;
  FTextAlign := value;
  Style := GetWindowLong(FHandle,GWL_STYLE);
  SetStyle := Style and (not BS_CENTER);
  case value of
    gbtLeft: SetStyle := SetStyle or BS_LEFT;
    gbtCenter: SetStyle := SetStyle or BS_CENTER;
    gbtRight: SetStyle := SetStyle or BS_RIGHT;
  end;
  SetWindowLong(FHandle,GWL_STYLE,SetStyle);
  r := SetDim(XPos,YPos,XPos+Width,YPos+Height);
  InvalidateRect(Parent,@r,true);
end;

function CreateGroupBox(hParent: HWND; x,y,cx,cy: integer;
                       sCaption: string): TAPIGroupBox;
begin
  result := TAPIGroupBox.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Caption := sCaption;
  end;
end;

//---------- APIListBoxBase ----------------------------------------------
procedure TAPIListBoxBase.Initialize;
begin
  inherited Initialize;
  FColor := clrWhite;
  FTxtColor := clrBlack;
  FRedraw := true;
  Dispatcher.TrapMessage(WM_CTLCOLORLISTBOX,self);
end;

procedure TAPIListBoxBase.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(Message);
  case AMsg.Msg of
    WM_COMMAND: begin
      if (AMsg.LParam <> LPARAM(FHandle)) then exit;
      if AMsg.WParamHi = WORD(LBN_ERRSPACE) then
        MessageBox(Parent,'ListBox Error Space','Warning',MB_OK);
      AMsg.Msg := UINT(self); // Sender
      case AMsg.WParamHi of
        LBN_SELCHANGE: if Assigned(FOnSelChange) then OnSelChange(AMsg);
        LBN_DBLCLK: if Assigned(FOnDoubleClick) then OnDoubleClick(AMsg);
      end; // case
    end;
    WM_CTLCOLORLISTBOX: if AMsg.LParam = LPARAM(FHandle) then begin
      SetBkColor(AMsg.WParam,FColor);
      SetTextColor(AMsg.WParam,FTxtColor);
      TMessage(Message).Result := CreateSolidBrush(FColor);
    end;
  end; // case
end;

function TAPIListBoxBase.AddString(value: string):integer;
begin
  Result := SendMessage(FHandle,LB_ADDSTRING, 0, Integer(PChar(value)));
end;

function TAPIListBoxBase.DeleteString(index: integer):integer;
begin
  Result := SendMessage(FHandle,LB_DELETESTRING,WParam(index),0);
end;

function TAPIListBoxBase.InsertString(index: integer; value:string):integer;
begin
  Result := SendMessage(FHandle,LB_INSERTSTRING,WParam(index),
                        lParam(PChar(value)));
end;

procedure TAPIListBoxBase.Clear;
begin
  SendMessage(FHandle,LB_RESETCONTENT, 0, 0);
end;

function TAPIListBoxBase.GetString(index:integer): string;
var
  len: integer;
  PC:PChar;
begin
  if (index > Count-1) or (index < 0) then Exit;
  len := SendMessage(FHandle,LB_GETTEXTLEN,WPARAM(index),0);
  GetMem(PC,len+1);  // +1 for null-terminator
  SendMessage(FHandle,LB_GETTEXT,WParam(index),LParam(PC));
  System.SetString(result,PC,len);
  FreeMem(PC);
end;

procedure TAPIListBoxBase.SetString(index: integer; value: string);
begin
  if (index > Count-1) or (index < 0) then Exit;
  DeleteString(index);
  InsertString(index,value);
end;

function TAPIListBoxBase.FindString(StartIndex:integer; s: string):integer;
begin
  Result := SendMessage(FHandle,LB_FINDSTRING,StartIndex,LPARAM(PChar(s)))
end;

procedure TAPIListBoxBase.DoSort;
var
  SA: TStringArray;
  i,IC: integer;
begin
  SA := TStringArray.Create;
  IC := Count;
  for i := 0 to IC-1 do SA.Add(ItemString[i]);
  Clear;
  SA.Sort;
  Redraw := false;
  for i := 0 to IC-1 do AddString(SA[i]);
  SA.Free;
  Redraw := true;
end;

function TAPIListBoxBase.GetCount: integer;
begin
  result := SendMessage(FHandle,LB_GETCOUNT,0,0);
end;

function TAPIListBoxBase.GetTopIndex: integer;
begin
  result := SendMessage(FHandle,LB_GETTOPINDEX,0,0);
end;

procedure TAPIListBoxBase.SetTopIndex(value: integer);
begin
  SendMessage(FHandle,LB_SETTOPINDEX,WParam(value),0);
end;

function TAPIListBoxBase.GetItemData(index: integer):integer;
begin
  Result := SendMessage(FHandle,LB_GETITEMDATA,index,0);
end;

procedure TAPIListBoxBase.SetItemData(index,value: integer);
begin
  SendMessage(FHandle,LB_SETITEMDATA,index,value);
end;

procedure TAPIListBoxBase.SetColor(value: COLORREF);
begin
  FColor := value;
  InvalidateRect(FHandle,nil,true);
end;

procedure TAPIListBoxBase.SetTxtColor(value: COLORREF);
begin
  FTxtColor := value;
  InvalidateRect(FHandle,nil,true);
end;

procedure TAPIListBoxBase.SetRedraw(value: Boolean);
begin
  if value then begin
    SendMessage(FHandle,WM_SETREDRAW,1,0);
    InvalidateRect(FHandle,nil,true);
  end else
    SendMessage(FHandle,WM_SETREDRAW,0,0);
  FRedraw := value;
end;

//---------- APIListBox ----------------------------------------------
procedure TAPIListBox.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := 'APIListBox';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or WS_VSCROLL or LBS_NOINTEGRALHEIGHT or
             LBS_USETABSTOPS or LBS_HASSTRINGS or LBS_NOTIFY;
    ExStyle := WS_EX_CLIENTEDGE;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'LISTBOX';
  end;
end;

procedure TAPIListBox.SetSelIndex(value: Integer);
begin
  SendMessage(FHandle,LB_SETCURSEL,WParam(value),0);
end;

function TAPIListBox.GetSelIndex: integer;
begin
  Result := Integer(SendMessage(FHandle,LB_GETCURSEL,0,0));
end;

function TAPIListBox.GetSelString: string;
begin
  Result := ItemString[SelIndex];
end;

function CreateListBox(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIListBox;
begin
  result := TAPIListBox.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnSelChange := sOnSelChange;
  end;
end;

//---------- APIMSListBox ----------------------------------------------
procedure TAPIMSListBox.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := 'APIMSListBox';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or WS_VSCROLL or LBS_NOINTEGRALHEIGHT or
             LBS_USETABSTOPS or LBS_HASSTRINGS or LBS_NOTIFY or
             LBS_EXTENDEDSEL;
    ExStyle := WS_EX_CLIENTEDGE;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'LISTBOX';
  end;
end;

function TAPIMSListBox.GetSelCount: integer;
begin
  result := SendMessage(FHandle,LB_GETSELCOUNT,0,0);
end;

function TAPIMSListBox.GetSelected(index: integer):Boolean;
begin
  if SendMessage(FHandle,LB_GETSEL,wParam(index),0) > 0 then
    result := true
  else
    result := false;
end;

procedure TAPIMSListBox.SetSelected(index: integer; value: Boolean);
begin
  SendMessage(FHandle,LB_SETSEL,WPARAM(value),LPARAM(index));
end;

function TAPIMSListBox.GetCaretIndex: integer;
begin
  result := SendMessage(FHandle,LB_GETCARETINDEX,0,0);
end;

procedure TAPIMSListBox.SetCaretIndex(index:integer);
begin
  SendMessage(FHandle,LB_GETCARETINDEX,WPARAM(index),1);
end;

function TAPIMSListBox.GetCaretText: string;
begin
  Result := ItemString[CaretIndex];
end;

function CreateMSListBox(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIMSListBox;
begin
  result := TAPIMSListBox.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnSelChange := sOnSelChange;
  end;
end;

//---------- TAPIEditBase -------------------------------------
procedure TAPIEditBase.Initialize;
begin
  inherited Initialize;
  FColor := clrWhite;
  FTxtColor := clrBlack;
  Dispatcher.TrapMessage(WM_CTLCOLOREDIT,self);
end;

procedure TAPIEditBase.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(Message);

  case AMsg.Msg of

    WM_COMMAND: begin
      if (AMsg.LParam <> LPARAM(FHandle)) then exit;

      case AMsg.WParamHi of

        EN_SETFOCUS: if Assigned(FOnSetFocus) then begin
          AMsg.Msg := UINT(self); // sender
          OnSetFocus(AMsg);
        end;

        EN_KILLFOCUS: if Assigned(FOnKillFocus) then begin
          AMsg.Msg := UINT(self); // sender
          OnKillFocus(AMsg);
        end;

        EN_CHANGE: if Assigned(FOnChange) then begin
          AMsg.Msg := UINT(self); // sender
          OnChange(AMsg);
        end;

        EN_UPDATE: if Assigned(FOnUpdate) then begin
          AMsg.Msg := UINT(self); // sender
          OnUpdate(AMsg);
        end;

        EN_ERRSPACE,EN_MAXTEXT:MessageBox(Parent,'Edit Control Buffer Full!',
                                              'Warning',MB_OK);
      end;// case
    end;

    WM_CTLCOLOREDIT:if AMsg.LParam = LPARAM(FHandle) then begin
                      SetBkColor(AMsg.WParam,FColor);
                      SetTextColor(AMsg.WParam,FTxtColor);
                      TMessage(Message).Result := CreateSolidBrush(FColor);
                    end;

    WM_KEYUP, WM_LBUTTONUP:if Assigned(FOnNotice) then OnNotice(AMsg);

  end;//case
end;

function TAPIEditBase.GetTextLength: integer;
begin
  result := SendMessage(FHandle,WM_GETTEXTLENGTH,0,0);
end;

function TAPIEditBase.GetText: string;
var
  Len: integer;
  PC: PChar;
begin
  Len := GetTextLength + 1;
  GetMem(PC,Len);
  FillChar(PC^,Len,0);
  Len := SendMessage(FHandle,WM_GETTEXT,Len,integer(PC));
  SetString(result,PC,Len);
  FreeMem(PC);
end;

procedure TAPIEditBase.SetText(value: string);
begin
  SendMessage(FHandle,WM_SETTEXT,0,integer(PChar(value)));
end;

function TAPIEditBase.GetCaretPos:integer;
var
  st, ed: integer;
begin
  SendMessage(FHandle,EM_GETSEL,integer(@st),integer(@ed));
  if ed < st then result := st else result := ed;
end;

procedure TAPIEditBase.SetCaretPos(value:integer);
begin
  SendMessage(FHandle,EM_SETSEL,value,value);
end;

function TAPIEditBase.GetSelTextLength: integer;
var
  st,ed: integer;
begin
  SendMessage(FHandle,EM_GETSEL,integer(@st),integer(@ed));
  result := ed-st;
end;

function TAPIEditBase.GetSelText:string;
var
  st,ed: integer;
  s: string;
  PCS: PChar;
begin
  SendMessage(FHandle,EM_GETSEL,integer(@st),integer(@ed));
  if (ed-st) <> 0 then begin
    s := GetText;
    PCS := PChar(integer(PChar(s))+st);
    SetString(result,PCS,ed-st);
  end else
    result := '';
end;

procedure TAPIEditBase.Cut;
begin
  SendMessage(FHandle,WM_CUT,0,0);
end;

procedure TAPIEditBase.Copy;
begin
  SendMessage(FHandle,WM_COPY,0,0);
end;

procedure TAPIEditBase.Paste;
begin
  SendMessage(FHandle,WM_PASTE,0,0);
end;

procedure TAPIEditBase.Clear;
begin
  SendMessage(FHandle,WM_CLEAR,0,0);
end;

procedure TAPIEditBase.SelectAll;
begin
  SendMessage(FHandle,EM_SETSEL,0,-1);
end;

procedure TAPIEditBase.ClearAll;
begin
  SelectAll;
  Clear;
end;

function TAPIEditBase.GetReadOnly: Boolean;
var
  i: integer;
begin
  i := GetWindowLong(FHandle,GWL_STYLE);
  i := ( i and ES_READONLY);
  result := ( i <> 0 );
end;

procedure TAPIEditBase.SetReadOnly(value: Boolean);
begin
  SendMessage(FHandle,EM_SETREADONLY,integer(value),0);
end;

function TAPIEditBase.GetLeftMargin: integer;
begin
  result := LOWORD(SendMessage(FHandle,EM_SETMARGINS,0,0));
end;

procedure TAPIEditBase.SetLeftMargin(value: integer);
begin
  SendMessage(FHandle,EM_SETMARGINS,EC_LEFTMARGIN,MakeLong(value,0));
end;

procedure TAPIEditBase.SetColor(value: COLORREF);
begin
  FColor := value;
  InvalidateRect(FHandle,nil,true);
end;

procedure TAPIEditBase.SetTxtColor(value: COLORREF);
begin
  FTxtColor := value;
  InvalidateRect(FHandle,nil,true);
end;

//---------- TAPIEdit ----------------------------------------------
procedure TAPIEdit.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := '';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or ES_AUTOHSCROLL or ES_LEFT;
    ExStyle := WS_EX_CLIENTEDGE;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'EDIT';
  end;
end;

function TAPIEdit.GetNumEdit:Boolean;
var
  i: integer;
begin
  i := GetWindowLong(FHandle,GWL_STYLE);
  i := ( i and ES_NUMBER);
  result := ( i <> 0 );
end;

procedure TAPIEdit.SetNumEdit(value:Boolean);
var
  i: integer;
begin
  i := GetWindowLong(FHandle,GWL_STYLE);
  if value then
    i := i or ES_NUMBER
  else
    i := i and ( not ES_NUMBER);
  SetWindowLong(FHandle,GWL_STYLE,i);
end;

//---------- TAPIPasswordEdit ----------------------------------------------
procedure TAPIPasswordEdit.APICreateParams(var Params: TAPICreateParams);
begin
  inherited APICreateParams(Params);
  Params.Style := Params.Style or ES_PASSWORD;
end;

function CreateEdit(hParent: HWND; x,y,cx,cy: integer; txt: string;
                      sOnChange:TNotifyMessage): TAPIEdit;
begin
  result := TAPIEdit.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Text := txt;
    OnChange := sOnChange;
  end;
end;

function CreatePasswordEdit(hParent: HWND; x,y,cx,cy: integer; txt: string;
                      sOnChange:TNotifyMessage): TAPIPasswordEdit;
begin
  result := TAPIPasswordEdit.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    Text := txt;
    OnChange := sOnChange;
  end;
end;

//---------- TAPIMemo ----------------------------------------------
procedure TAPIMemo.Initialize;
begin
  inherited Initialize;
  SendMessage(FHandle,EM_SETLIMITTEXT,0,0)
end;

procedure TAPIMemo.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := '';
    Style := WS_CHILD or WS_VISIBLE or WS_TABSTOP or
             WS_CLIPSIBLINGS or WS_VSCROLL or ES_NOHIDESEL or
             ES_AUTOVSCROLL or ES_MULTILINE or ES_LEFT or ES_WANTRETURN;
    ExStyle := WS_EX_CLIENTEDGE;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'EDIT';
  end;
end;

procedure TAPIMemo.Undo;
begin
  SendMessage(FHandle,EM_UNDO,0,0);
end;

procedure TAPIMemo.Add(s: string);
begin
  Text := Text+#13#10+s;
  Scroll(LineCount);
end;

function TAPIMemo.FindString(s: string; StartPos:integer):integer;
var
  st,ed: integer;
  Txt: string;
  PCS: PChar;
begin
  Txt := Text;
  PCS := PChar(integer(PChar(Txt))+StartPos);
  st := Pos(s,string(PCS));
  if st <> 0 then begin
    st := st-1+StartPos;
    ed := st+Length(s);
    SetSelRange(st,ed);
    ScrollCaret;
  end;
  result := st;
end;

procedure TAPIMemo.ScrollCaret;
begin
  SendMessage(FHandle,EM_SCROLLCARET,0,0);
end;

procedure TAPIMemo.Scroll(line:integer);
begin
  SendMessage(FHandle,EM_LINESCROLL,0,line);
end;

procedure TAPIMemo.SetTabStop(value: integer);
begin
  SendMessage(FHandle,EM_SETTABSTOPS,1,integer(@value));;
end;

function TAPIMemo.GetLine(line: integer): string;
var
  PC: PChar;
  PCLen: Word;
  Len: integer;
begin
  PCLen := GetLineLength(line);
  PCLen := PCLen+1;
  GetMem(PC,PCLen);
  Move(PCLen,PC^,SizeOf(Word));
  Len := SendMessage(FHandle,EM_GETLINE,line,integer(PC));
  SetString(result,PC,Len);
  FreeMem(PC);
end;

function TAPIMemo.GetLineCount: integer;
begin
  result := SendMessage(FHandle,EM_GETLINECOUNT,0,0);
end;

procedure TAPIMemo.LoadText(filename:string);
var
  F: file;
  Size,NumRead: Integer;
  P: PChar;
  s:string;
begin
  AssignFile(F,filename);
  Reset(F,1);
  try
    Size := FileSize(F);
    GetMem(P, Size);
    try
      BlockRead(F, P^, Size,NumRead);
    finally
      s := string(p);
      SetLength(s,NumRead);
      Text := s;
      FreeMem(P);
    end;
  finally
    CloseFile(F);
  end;
end;

procedure TAPIMemo.SaveText(filename:string);
var
  f: TextFile;
  Buf: array[0..$1FFF] of Char;
begin
  AssignFile(f,filename);
    SetTextBuf(f,Buf);
    ReWrite(f);
    write(f,Text);
    Flush(f);
  CloseFile(f);
end;

procedure TAPIMemo.SetSelRange(StartPos,EndPos:integer);
begin
  SendMessage(FHandle,EM_SETSEL,StartPos,EndPos);
end;

procedure TAPIMemo.GetSelRange(var StartPos,EndPos: integer);
begin
  SendMessage(FHandle,EM_GETSEL,integer(@StartPos),integer(@EndPos));
end;

procedure TAPIMemo.ReplaceSel(s:string);
begin
  SendMessage(FHandle,EM_REPLACESEL,1,integer(PChar(s)));
end;

function TAPIMemo.GetCanUndo: Boolean;
begin
  result := Boolean(SendMessage(FHandle,EM_CANUNDO,0,0));
end;

function TAPIMemo.GetLineLength(line:integer): integer;
var
  CharPos: integer;
begin
  CharPos := SendMessage(FHandle,EM_LINEINDEX,line,0);
  result := SendMessage(FHandle,EM_LINELENGTH,CharPos,0);
end;

function TAPIMemo.GetLineFromChar(CharPos: integer):integer;
begin
  result := SendMessage(FHandle,EM_LINEFROMCHAR,CharPos,0);
end;

procedure TAPIMemo.SetModified(value: Boolean);
begin
  SendMessage(FHandle,EM_SETMODIFY,UINT(value),0);
end;

function TAPIMemo.GetModified: Boolean;
begin
  result := Boolean(SendMessage(FHandle,EM_GETMODIFY,0,0));
end;

function TAPIMemo.GetLineNo: integer;
begin
  result := SendMessage(FHandle,EM_LINEFROMCHAR,-1,0);
end;

function TAPIMemo.GetColNo: integer;
begin
  result := CaretPos-SendMessage(FHandle,EM_LINEINDEX,LineNo,0);
end;

function CreateMemo(hParent: HWND; x,y,cx,cy: integer): TAPIMemo;
begin
  result := TAPIMemo.Create(hParent);
  result.Dimension := SetDim(x,y,cx,cy);
end;

//--------- TAPIComboBoxBase --------------------------------------------
function TAPIComboBoxBase.AddString(value: string):integer;
begin
  result := SendMessage(FHandle,CB_ADDSTRING,0,integer(PChar(value)));
end;

procedure TAPIComboBoxBase.DeleteString(index:integer);
begin
  SendMessage(FHandle,CB_DELETESTRING,index,0);
end;

function TAPIComboBoxBase.InsertString(value:string;index:integer):integer;
begin
  result := SendMessage(FHandle,CB_INSERTSTRING,index,integer(PChar(value)));
end;

function TAPIComboBoxBase.GetSelText:string;
begin
  Result := GetText(SelIndex);
end;

function TAPIComboBoxBase.GetSelIndex:integer;
begin
  result := SendMessage(FHandle,CB_GETCURSEL,0,0);
end;

procedure TAPIComboBoxBase.SetSelIndex(index:integer);
var
  AMsg: TMessage;
begin
  if index = SelIndex then exit;
  SendMessage(FHandle,CB_SETCURSEL,index,0);
  AMsg.Msg := WM_COMMAND;
  AMsg.WParamHi := CBN_SELCHANGE;
  AMsg.WParamLo :=  FID;
  AMsg.LParam := FHandle;
  Dispatch(AMsg);
end;

function TAPIComboBoxBase.GetText(index: integer):string;
var
  s:string;
  Len: integer;
begin
  Len := SendMessage(FHandle,CB_GETLBTEXTLEN,index,0);
  SetLength(s,Len);
  SendMessage(FHandle,CB_GETLBTEXT,index,integer(PChar(s)));
  result := s;
end;

procedure TAPIComboBoxBase.Clear;
begin
  SendMessage(FHandle,CB_RESETCONTENT,0,0);
end;

function TAPIComboBoxBase.GetCount:integer;
begin
  result := SendMessage(FHandle,CB_GETCOUNT,0,0);
end;

function TAPIComboBoxBase.GetItemData(index:integer):integer;
begin
  result := SendMessage(FHandle,CB_GETITEMDATA,index,0);
end;

procedure TAPIComboBoxBase.SetItemData(index,value: integer);
begin
  SendMessage(FHandle,CB_SETITEMDATA,index,value);
end;

//--------- TAPIDDLCombo --------------------------------------------
procedure TAPIDDLCombo.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := '';
    Style := $54010240 or WS_VSCROLL or CBS_DROPDOWNLIST;
    ExStyle := WS_EX_CLIENTEDGE;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'COMBOBOX';
  end;
end;

procedure TAPIDDLCombo.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(message);

  case AMsg.Msg of

    WM_COMMAND:begin
      if (AMsg.LParam <> LPARAM(FHandle)) then exit;
      case AMsg.WParamHi of
        CBN_SELCHANGE: begin
          AMsg.Msg := UINT(self);
          FResultText := SelText;
          if Assigned(FOnSelChange) then OnSelChange(AMsg);
        end;
      end;
      if AMsg.WParamHi = WORD(CBN_ERRSPACE) then
        MessageBox(Parent,'ComboBox Control Buffer Full!','Warning',MB_OK);
    end;

  end; // case

end;

procedure TAPIDDLCombo.ShowDropDown(value:Boolean);
begin
  if value then
    SendMessage(FHandle,CB_SHOWDROPDOWN,1,0)
  else
    SendMessage(FHandle,CB_SHOWDROPDOWN,0,0);
end;

//--------- TAPISMPCombo --------------------------------------------
procedure TAPISMPCombo.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := '';
    Style := $54010240 or WS_VSCROLL or CBS_SIMPLE;
    ExStyle := WS_EX_CLIENTEDGE;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'COMBOBOX';
  end;
end;

procedure TAPISMPCombo.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(message);

  case AMsg.Msg of

    WM_COMMAND:begin
      if (AMsg.LParam <> LPARAM(FHandle)) then exit;
      case AMsg.WParamHi of
        CBN_EDITCHANGE: begin
          AMsg.Msg := UINT(self);
          FResultText := EditText;
          if Assigned(FOnEditChange) then OnEditChange(AMsg);
        end;
        CBN_SELCHANGE: begin
          AMsg.Msg := UINT(self);
          FResultText := SelText;
          if Assigned(FOnSelChange) then OnSelChange(AMsg);
        end;
      end;
      if AMsg.WParamHi = WORD(CBN_ERRSPACE) then
        MessageBox(Parent,'ComboBox Control Buffer Full!','Warning',MB_OK);
    end;

  end; // case

end;

function TAPISMPCombo.GetEditText:string;
var
  s:string;
  Len: integer;
begin
  SetLength(s,256);
  Len := SendMessage(FHandle,WM_GETTEXT,256,integer(PChar(s)));
  SetLength(s,Len);
  result := s;
end;

procedure TAPISMPCombo.SetEditText(value:string);
var
  AMsg: TMessage;
begin
  SetWindowText(FHandle,PChar(value));
  AMsg.Msg := WM_COMMAND;
  AMsg.WParamHi := CBN_EDITCHANGE;
  AMsg.WParamLo :=  FID;
  AMsg.LParam := FHandle;
  Dispatch(AMsg);
end;

//---------- TAPIDDCombo --------------------------------------------
procedure TAPIDDCombo.APICreateParams(var Params: TAPICreateParams);
begin
  inherited APICreateParams(Params);
  Params.Style := $54010240 or WS_VSCROLL or CBS_DROPDOWN;
end;

procedure TAPIDDCombo.ShowDropDown(value:Boolean);
begin
  if value then
    SendMessage(FHandle,CB_SHOWDROPDOWN,1,0)
  else
    SendMessage(FHandle,CB_SHOWDROPDOWN,0,0);
end;

function CreateDDLCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIDDLCombo;
begin
  result := TAPIDDLCombo.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnSelChange := sOnSelChange;
  end;
end;

function CreateSMPCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPISMPCombo;
begin
  result := TAPISMPCombo.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnSelChange := sOnSelChange;
  end;
end;

function CreateDDCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIDDCombo;
begin
  result := TAPIDDCombo.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnSelChange := sOnSelChange;
  end;
end;

//---------- TAPIDriveCombo -----------------------------------------
procedure TAPIDriveCombo.Initialize;
var
  i,r: integer;
  s,t: string;
begin
  inherited Initialize;

  for i := byte('A') to byte('Z') do begin
    s := Char(i)+':\';
    r := GetDriveType(PChar(s));
    case r of
      DRIVE_UNKNOWN:     t := 'Unknown';
      DRIVE_NO_ROOT_DIR: t := 'No Root';
      DRIVE_REMOVABLE:   t := 'Removable';
      DRIVE_FIXED:       t := GetVolumeName(s);
      DRIVE_REMOTE:      t := 'Network';
      DRIVE_CDROM:       t := 'CD_ROM';
      DRIVE_RAMDISK:     t := 'RamDisk';
    end;
    if r >1 then begin
      t := s+' '+t;
      AddString(t);
    end;
  end;
end;

procedure TAPIDriveCombo.DefaultHandler(var Message);
var
  AMsg: TMessage;
begin
  AMsg := TMessage(message);

  case AMsg.Msg of

    WM_COMMAND:begin
      if (AMsg.LParam <> LPARAM(FHandle)) then exit;
      case AMsg.WParamHi of
        CBN_SELCHANGE: begin
          FRootDir := Copy(SelText,1,3);
          GetVolumeInfo(FRootDir);
          AMsg.Msg := UINT(self);
          FResultText := SelText;
          if Assigned(FOnSelChange) then OnSelChange(AMsg);
        end;
      end;
      if AMsg.WParamHi = WORD(CBN_ERRSPACE) then
        MessageBox(Parent,'ComboBox Control Buffer Full!','Warning',MB_OK);
    end;

  end; // case

end;

function TAPIDriveCombo.GetVolumeName(Root: string):string;
var
  Vol,FileSys: array[0..100] of Char;
  SN,MaxN,FSF: DWORD;
begin
  GetVolumeInformation(PChar(Root),Vol,100,@SN,MaxN,FSF,FileSys,100);
  result := '['+Vol+']';
end;

procedure TAPIDriveCombo.GetVolumeInfo(Root: string);
var
  Vol,FileSys: array[0..100] of Char;
  SN,MaxN,FSF: DWORD;
  SectPerClstr,BytePerSect,FreeClstr,Clstr: DWORD;
begin
  GetVolumeInformation(PChar(Root),Vol,100,@SN,MaxN,FSF,FileSys,100);
  GetDiskFreeSpace(PChar(Root),SectPerClstr,BytePerSect,FreeClstr,Clstr);
  FRootDir := Root;
  FVolumeName := '['+Vol+']';
  FFileSystem := FileSys;
  FSerialNumber := SN;
  FDiskSpace := Clstr*BytePerSect*SectPerClstr;
  FFreeSpace := FreeClstr*BytePerSect*SectPerClstr;
  FUsedSpace := DiskSpace-FreeSpace;
end;

function CreateDriveCombo(hParent: HWND; x,y,cx,cy: integer;
                      sOnSelChange:TNotifyMessage): TAPIDriveCombo;
begin
  result := TAPIDriveCombo.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnSelChange := sOnSelChange;
  end;
end;

//--------- APIHScroll --------------------------------------------
procedure TAPIHScroll.Initialize;
begin
  inherited Initialize;
  SetScrollrange(FHandle,SB_CTL,0,100,true);;// default range 0-100
  FLargeChange := 10;
  FSmallChange := 1;
  Dispatcher.TrapMessage(WM_HSCROLL,self);
  Dispatcher.TrapMessage(WM_VSCROLL,self);
  Dispatcher.TrapMessage(WM_CTLCOLORSCROLLBAR,self);
end;

procedure TAPIHScroll.APICreateParams(var Params: TAPICreateParams);
begin
  with Params do begin
    Caption := '';
    Style := $54010000;
    ExStyle := 0;
    X := 50;
    Y := 50;
    Width := 150;
    Height := 32;
    WinClassName := 'SCROLLBAR';
  end;
end;

procedure TAPIHScroll.DefaultHandler(var Message);
var
  AMsg: TMessage;
  ScrPos: integer;
begin
  AMsg := TMessage(Message);

  case AMsg.Msg of
    WM_HSCROLL,WM_VSCROLL: begin
      if (AMsg.LParam <> LPARAM(FHandle)) then exit;
      ScrPos := GetScrollPos(FHandle,SB_CTL);
      case AMsg.WParamLo of
        SB_THUMBPOSITION: begin
          SetScrollPos(FHandle,SB_CTL,AMsg.WParamHi,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_LINERIGHT: begin
          SetScrollPos(FHandle,SB_CTL,ScrPos+FSmallChange,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_LINELEFT: begin
          SetScrollPos(FHandle,SB_CTL,ScrPos-FSmallChange,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_PAGERIGHT: begin
          SetScrollPos(FHandle,SB_CTL,ScrPos+FLargeChange,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_PAGELEFT: begin
          SetScrollPos(FHandle,SB_CTL,ScrPos-FLargeChange,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_THUMBTRACK: begin
          SetScrollPos(FHandle,SB_CTL,AMsg.WParamHi,true);
          if Assigned(FOnTrack) then OnTrack(AMsg);
        end;
        SB_LEFT: begin
          SetScrollPos(FHandle,SB_CTL,Min,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_RIGHT: begin
          SetScrollPos(FHandle,SB_CTL,Max,true);
          if Assigned(FOnChange) then OnChange(AMsg);
        end;
        SB_ENDSCROLL: if Assigned(FOnChange) then OnChange(AMsg);
      end; // case
    end;
    WM_CTLCOLORSCROLLBAR: if AMsg.LParam = LPARAM(FHandle) then
      if FColor <> 0 then TMessage(Message).Result := CreateSolidBrush(FColor);
  end;
end;

function TAPIHScroll.GetMin:integer;
var
  AMax:integer;
begin
  GetScrollRange(FHandle,SB_CTL,result,AMax);
end;

procedure TAPIHScroll.SetMin(value:integer);
begin
  SetScrollrange(FHandle,SB_CTL,value,Max,true);
end;

function TAPIHScroll.GetMax:integer;
var
  AMin:integer;
begin
  GetScrollRange(FHandle,SB_CTL,AMin,result);
end;

procedure TAPIHScroll.SetMax(value:integer);
begin
  SetScrollrange(FHandle,SB_CTL,Min,value,true);
end;

function TAPIHScroll.GetPosition: integer;
begin
  result := GetScrollPos(FHandle,SB_CTL);
end;

procedure TAPIHScroll.SetPosition(value: integer);
var
  AMsg: TMessage;
begin
  with AMsg do begin
    Msg := WM_HSCROLL;
    WParamHi := value;
    Result := 0;
    LParam := FHandle;
    WParamLo := SB_THUMBPOSITION;
  end;

  Dispatch(AMsg);
end;

function TAPIHScroll.GetThumbSize: integer;
var
  si: TScrollInfo;
begin
  si.cbSize := SizeOf(si);
  si.fMask:= SIF_PAGE;
  GetScrollInfo(FHandle,SB_CTL,si);
  result := si.nPage;
end;

procedure TAPIHScroll.SetThumbSize(ASize: integer);
var
  si: TScrollInfo;
begin
  si.cbSize := SizeOf(si);
  si.fMask:= SIF_PAGE;
  si.nPage := ASize;
  SetScrollInfo(FHandle,SB_CTL,si,true);
end;

procedure TAPIHScroll.SetColor(value: COLORREF);
begin
  if FColor <> value then begin
    FColor := value;
    InvalidateRect(FHandle,nil,true);
  end;
end;

//--------- APIVScroll --------------------------------------------
procedure TAPIVScroll.APICreateParams(var Params: TAPICreateParams);
begin
  inherited APICreateParams(Params);
  with Params do begin
    Style := $54010001;
  end;
end;

function CreateHScroll(hParent: HWND; x,y,cx,cy: integer;
                      sOnTrackChange:TNotifyMessage): TAPIHScroll;
begin
  result := TAPIHScroll.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnChange := sOnTrackChange;
    OnTrack := sOnTrackChange;
  end;
end;

function CreateVScroll(hParent: HWND; x,y,cx,cy: integer;
                      sOnTrackChange:TNotifyMessage): TAPIVScroll;
begin
  result := TAPIVScroll.Create(hParent);
  with result do begin
    Dimension := SetDim(x,y,cx,cy);
    OnChange := sOnTrackChange;
    OnTrack := sOnTrackChange;
  end;
end;

//---------- TEnumFontComboBox --------------------------------------------
function EnumFontProcB(lpelf: PEnumLogFont;
                      lpntm: PNewTextMetric;
                      nFontType: integer;
                      lParam: LParam):integer; stdcall;
begin
  result := 1;
  if TEnumFontComboBox(lParam).FontType <> 0 then
    if (nFontType and TEnumFontComboBox(lParam).FontType) = 0 then exit;
  TEnumFontComboBox(lParam).AddString(string(lpelf^.elfLogFont.lfFaceName));
end;

function FindFontProcB(lpelf: PEnumLogFont;
                      lpntm: PNewTextMetric;
                      nFontType: integer;
                      lParam: LParam):integer; stdcall;
begin
  PLogFont(lParam)^ := lpelf^.elfLogFont;
  Result := 1;
end;

procedure TEnumFontComboBox.Initialize;
var
  DC: HDC;
begin
  inherited Initialize;
  Clear;
  DC := GetDC(Parent);
    EnumFontFamilies(DC, nil, @EnumFontProcB,integer(self));
  ReleaseDC(Parent,DC);
end;

function TEnumFontComboBox.GetSelLogFont: TLogFont;
var
  DC: HDC;
begin
  DC := GetDC(Parent);
    EnumFontFamilies(DC,PChar(SelText),@FindFontProcB,integer(@result));
  ReleaseDC(Parent,DC);
end;

procedure TEnumFontComboBox.SetFontType(value: integer);
var
  DC: HDC;
begin
  if FFontType = value then Exit;
  FFontType := value;
  Clear;
  DC := GetDC(Parent);
    EnumFontFamilies(DC, nil, @EnumFontProcB,integer(self));
  ReleaseDC(Parent,DC);
end;

//---------- TEnumFontListBox --------------------------------------------
function EnumFontProc(lpelf: PEnumLogFont;
                      lpntm: PNewTextMetric;
                      nFontType: integer;
                      lParam: LParam):integer; stdcall;
begin
  result := 1;
  if TEnumFontListBox(lParam).FontType <> 0 then
    if (nFontType and TEnumFontListBox(lParam).FontType) = 0 then exit;
  TEnumFontListBox(lParam).AddString(string(lpelf^.elfLogFont.lfFaceName));
end;

function FindFontProc(lpelf: PEnumLogFont;
                      lpntm: PNewTextMetric;
                      nFontType: integer;
                      lParam: LParam):integer; stdcall;
begin
  PLogFont(lParam)^ := lpelf^.elfLogFont;
  Result := 1;
end;

procedure TEnumFontListBox.Initialize;
var
  DC: HDC;
begin
  inherited Initialize;
  Clear;
  DC := GetDC(Parent);
    EnumFontFamilies(DC, nil, @EnumFontProc,integer(self));
  ReleaseDC(Parent,DC);
end;

function TEnumFontListBox.GetSelLogFont: TLogFont;
var
  DC: HDC;
begin
  DC := GetDC(Parent);
    EnumFontFamilies(DC,PChar(SelText),@FindFontProc,integer(@result));
  ReleaseDC(Parent,DC);
end;

procedure TEnumFontListBox.SetFontType(value: integer);
var
  DC: HDC;
begin
  if FFontType = value then Exit;
  FFontType := value;
  Clear;
  DC := GetDC(Parent);
    EnumFontFamilies(DC, nil, @EnumFontProc,integer(self));
  ReleaseDC(Parent,DC);
end;

end.

