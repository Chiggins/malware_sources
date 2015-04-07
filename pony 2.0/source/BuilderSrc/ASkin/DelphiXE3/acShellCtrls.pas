unit acShellCtrls;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, SyncObjs, acAlphaImageList,
  ComCtrls, CommCtrl, ShlObj, ActiveX, StdCtrls, ImgList, sComboBoxes, sTreeView, {$IFDEF LOGGED}sDebugMsgs, {$ENDIF}
  sConst, {$IFNDEF DELPHI6UP}acD5Ctrls, {$ENDIF}sListView{$IFNDEF DELPHI6UP}, acD5ShlObj{$ENDIF}{$IFDEF TNTUNICODE}, TntComCtrls{$ENDIF};

{$IFNDEF NOTFORHELP}
const
  WM_DEFFERED_REFRESH = WM_USER + 1;
{$ENDIF}

type
  TacRootFolder = (rfDesktop, rfMyComputer, rfNetwork, rfRecycleBin, rfAppData, rfCommonDesktopDirectory, rfCommonPrograms,
                   rfCommonStartMenu, rfCommonStartup, rfControlPanel, rfDesktopDirectory, rfFavorites, rfFonts, rfInternet,
                   rfPersonal, rfPrinters, rfPrintHood, rfPrograms, rfRecent, rfSendTo, rfStartMenu, rfStartup, rfTemplates);

{$IFNDEF NOTFORHELP}
  TacShellFolderCapability = (fcCanCopy, fcCanDelete, fcCanLink, fcCanMove, fcCanRename, fcDropTarget, fcHasPropSheet);
  TacShellFolderCapabilities = set of TacShellFolderCapability;

  TacShellFolderProperty = (fpCut, fpIsLink, fpReadOnly, fpShared, fpFileSystem, fpFileSystemAncestor, fpRemovable, fpValidate);
  TacShellFolderProperties = set of TacShellFolderProperty;

  TacShellObjectType = (otFolders, otNonFolders, otHidden);
  TacShellObjectTypes = set of TacShellObjectType;

  //Lexa
  TacShowExtension = (seSystem, seShow, seHide);

  IacShellCommandVerb = interface
    ['{7D2A7245-2376-4D33-8008-A130935A2E8B}']
    procedure ExecuteCommand(Verb: string; var Handled: boolean);
    procedure CommandCompleted(Verb: string; Succeeded: boolean);
  end;

  IShellDetails = interface(IUnknown)
    [SID_IShellDetails]
    function GetDetailsOf(pidl: PItemIDList; iColumn: UINT; var pDetails: TShellDetails): HResult; stdcall;
    function ColumnClick(iColumn: UINT): HResult; stdcall;
  end;

  IDetInterface = interface
    ['{00000000-0000-0000-C000-000000000046}']
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

  TacShellFolder = class
  private
    FPIDL, FFullPIDL: PItemIDList;
    FParent: TacShellFolder;
    FIShellFolder: IShellFolder;

    FIShellFolder2: IShellFolder2;
    FIShellDetails: IShellDetails;
    FDetailInterface: IDetInterface;

    FLevel: Integer;
    FViewHandle: THandle;
    FDetails: TStrings;
    function GetDetailInterface: IDetInterface;
    function GetShellDetails: IShellDetails;
    function GeTacShellFolder2: IShellFolder2;
    function GetDetails(Index: integer): string;
    procedure SetDetails(Index: integer; const Value: string);
    procedure LoadColumnDetails(RootFolder: TacShellFolder; Handle: THandle; ColumnCount: integer);
  public
    constructor Create(AParent: TacShellFolder; ID: PItemIDList; SF: IShellFolder); virtual;
    destructor Destroy; override;
    function Capabilities: TacShellFolderCapabilities;
    function DisplayName(ShowExt: TacShowExtension): acString;
    function ExecuteDefault: Integer;
    function ImageIndex(LargeIcon: Boolean): Integer;
    function IsFolder(const Name : string = ''; OpenZipFiles : Boolean = True): Boolean;
    function IsFileFolder: Boolean;
    function IsFile(const Name : string = ''; OpenZipFiles : Boolean = True): Boolean;
    function IsReadOnly: Boolean;
    function ParenTacShellFolder: IShellFolder;
    function PathName: string;
    function Properties: TacShellFolderProperties;
    function Rename(const NewName: WideString): boolean;
    function SubFolders: Boolean;
    property AbsoluteID: PItemIDLIst read FFullPIDL;
    property Details[Index: integer] : string read GetDetails write SetDetails;
    property Level: Integer read FLevel;
    property Parent: TacShellFolder read FParent;
    property RelativeID: PItemIDList read FPIDL;
    property ShellFolder: IShellFolder read FIShellFolder;
    property ShellFolder2: IShellFolder2 read GeTacShellFolder2;
    property ShellDetails: IShellDetails read GetShellDetails;
    property ViewHandle: THandle read FViewHandle write FViewHandle;
  end;

  TacNotifyFilter = (nfFileNameChange, nfDirNameChange, nfAttributeChange, nfSizeChange, nfWriteChange, nfSecurityChange);
  TacNotifyFilters = set of TacNotifyFilter;

  TacShellChangeThread = class(TThread)
  private
    FMutex,
    FWaitHandle: Integer;
    FChangeEvent: TThreadMethod;
    FDirectory: string;
    FWatchSubTree: Boolean;
    FWaitChanged : Boolean;
    FNotifyOptionFlags: DWORD;
    FStopEvent: TEvent;
    FActive: TEvent;
  protected
    procedure Execute; override;
  public
    constructor Create(ChangeEvent: TThreadMethod); virtual;
    destructor Destroy; override;
    procedure SetDirectoryOptions(const Directory : String; WatchSubTree : Boolean; NotifyOptionFlags : DWORD);
    property ChangeEvent : TThreadMethod read FChangeEvent write FChangeEvent;
  end;

  TacCustomShellChangeNotifier = class(TComponent)
  private
    FFilters: TacNotifyFilters;
    FWatchSubTree: Boolean;
    FRoot : TacRoot;
    FThread: TacShellChangeThread;
    FOnChange: TThreadMethod;
    procedure SetRoot(const Value: TacRoot);
    procedure SetWatchSubTree(const Value: Boolean);
    procedure SetFilters(const Value: TacNotifyFilters);
    procedure SetOnChange(const Value: TThreadMethod);
  protected
    procedure Change;
    procedure Start;
  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    property NotifyFilters: TacNotifyFilters read FFilters write SetFilters;
    property Root: TacRoot read FRoot write SetRoot;
    property WatchSubTree: Boolean read FWatchSubTree write SetWatchSubTree;
    property OnChange: TThreadMethod read FOnChange write SetOnChange;
  end;

  TacShellChangeNotifier = class(TacCustomShellChangeNotifier)
  published
    property NotifyFilters;
    property Root;
    property WatchSubTree;
    property OnChange;
  end;

  TacCustomShellComboBox = class;
  TacCustomShellListView = class;
{$ENDIF} // NOTFORHELP

  TacAddFolderEvent = procedure (Sender: TObject; AFolder: TacShellFolder; var CanAdd: Boolean) of object;
  TacGetImageIndexEvent = procedure (Sender: TObject; Index: Integer; var ImageIndex: Integer) of object;

{ TacCustomShellTreeView }

{$IFNDEF NOTFORHELP}
  TacCustomShellTreeView = class(TsTreeView, IacShellCommandVerb)
  private
    FRoot, FOldRoot : TacRoot;
    FRootFolder: TacShellFolder;
    FObjectTypes: TacShellObjectTypes;
//    FSmallImages: Integer;
    FLoadingRoot, FAutoContext, FUpdating: Boolean;
    FComboBox: TacCustomShellComboBox;
    FListView: TacCustomShellListView;
    FAutoRefresh, FImageListChanging, FUseShellImages: Boolean;
    FNotifier: TacShellChangeNotifier;
    FOnAddFolder: TacAddFolderEvent;
    FSavePath: string;
    FNodeToMonitor: TTreeNode;
    FShowExtension: TacShowExtension;
    function FolderExists(FindID: PItemIDList; InNode: TTreeNode): TTreeNode;
    function GetFolder(Index: Integer): TacShellFolder;
    function GetPath: string;
    procedure SetComboBox(Value: TacCustomShellComboBox);
    procedure SetListView(const Value: TacCustomShellListView);
    procedure SetPath(const Value: string);
    procedure SetPathFromID(ID: PItemIDList);
    procedure SetRoot(const Value: TacRoot);
    procedure SetUseShellImages(const Value: Boolean);
    procedure SetAutoRefresh(const Value: boolean);
    function GetUpdating: boolean;
    procedure DefferedRefreshEvent;
    procedure OnDefferedRefreshEvent(var Message: TMessage); message WM_DEFFERED_REFRESH;
  protected
    procedure CreateRoot;
    procedure CreateWnd; override;
    procedure DestroyWnd; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure Edit(const Item: TTVItem); override;
    procedure GetImageIndex(Node: TTreeNode); override;
    procedure GetSelectedIndex(Node: TTreeNode); override;
    procedure InitNode(NewNode: TTreeNode; ID: PItemIDList; ParentNode: TTreeNode);
    procedure Loaded; override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer); override;
    procedure Delete(Node: TTreeNode); override;
    //! procedure NodeDeleted(Sender: TObject; Node: TTreeNode);
    function NodeFromAbsoluteID(StartNode: TTreeNode; ID: PItemIDList): TTreeNode;
    function NodeFromRelativeID(ParentNode: TTreeNode; ID: PItemIDList): TTreeNode;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function CanChange(Node: TTreeNode): Boolean; override;
    function CanExpand(Node: TTreeNode): Boolean; override;
{$IFDEF TNTUNICODE}
    procedure PopulateNode(Node: TTntTreeNode);
{$ELSE}
    procedure PopulateNode(Node: TTreeNode);
{$ENDIF}
    procedure RootChanged;
    procedure SetObjectTypes(Value: TacShellObjectTypes); virtual;
    procedure WMDestroy(var Message: TWMDestroy); virtual;
    procedure WndProc(var Message: TMessage); override;
    procedure ClearItems;
    procedure RefreshEvent;
    procedure WMNCPaint (var Message: TMessage); message WM_NCPAINT;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Refresh(Node: TTreeNode);
    function SelectedFolder: TacShellFolder;
    property AutoRefresh: boolean read FAutoRefresh write SetAutoRefresh;
    property Folders[Index: Integer]: TacShellFolder read GetFolder; default;
    property Items;
    property Path: TsDirectory read GetPath write SetPath;
    property AutoContextMenus: Boolean read FAutoContext write FAutoContext default True;
    property ObjectTypes: TacShellObjectTypes read FObjectTypes write SetObjectTypes;
    property Root: TacRoot read FRoot write SetRoot;
    property ShellComboBox: TacCustomShellComboBox read FComboBox write SetComboBox;
    property ShellListView: TacCustomShellListView read FListView write SetListView;
    property UseShellImages: Boolean read FUseShellImages write SetUseShellImages;
    property Updating : boolean read GetUpdating;
    //Lexa
    property ShowExt: TacShowExtension read FShowExtension write FShowExtension;
    property OnAddFolder: TacAddFolderEvent read FOnAddFolder write FOnAddFolder;
    procedure CommandCompleted(Verb: String; Succeeded: Boolean);
    procedure ExecuteCommand(Verb: String; var Handled: Boolean);
  end;
{$ENDIF} // NOTFORHELP

{ TsShellTreeView }

  TsShellTreeView = class(TacCustomShellTreeView)
  published
{$IFNDEF NOTFORHELP}
    {:@event}
    property OnAddFolder;
    property OnGetImageIndex;
    property OnGetSelectedIndex;
    property OnClick;
    property OnEnter;
    property OnExit;
    property OnDragDrop;
    property OnDragOver;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnDblClick;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnChanging;
    property OnChange;
    property OnExpanding;
    property OnCollapsing;
    property OnCollapsed;
    property OnExpanded;
    property OnEditing;
    property OnEdited;

    property Align;
    property Anchors;
    property BorderStyle;
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property Images;
    property Indent;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property RightClickSelect default True;
    property ShowButtons;
    property ShowHint;
    property ShowLines;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property ChangeDelay;
    property ShowRoot;
    property StateImages;
{$ENDIF} // NOTFORHELP
    property AutoContextMenus;
    property ObjectTypes;
    property Root;
    property ShellComboBox;
    property ShellListView;
    property UseShellImages;
    property AutoRefresh;
    property ShowExt;
  end;

{ TacCustomShellComboBox }

{$IFNDEF NOTFORHELP}
  TacCustomShellComboBox = class(TsCustomComboBoxEx)
  private
//    FImagesHandle,
    FImageHeight, FImageWidth: Integer;
    FImageList: TCustomImageList;
    FOldRoot : TacRoot;
    FRoot: TacRoot;
    FRootFolder: TacShellFolder;
    FTreeView: TacCustomShellTreeView;
    FListView: TacCustomShellListView;
    FObjectTypes: TacShellObjectTypes;
    FUseShellImages, FUpdating: Boolean;
    FOnGetImageIndex: TacGetImageIndexEvent;
    procedure ClearItems;
    function GetFolder(Index: Integer): TacShellFolder;
    function GetPath: string;
    procedure SetPath(const Value: string);
    procedure SetPathFromID(ID: PItemIDList);
    procedure SetRoot(const Value: TacRoot);
    procedure SetTreeView(Value: TacCustomShellTreeView);
    procedure SetListView(Value: TacCustomShellListView);
    procedure SetUseShellImages(const Value: Boolean);
    function GetShellImageIndex(AFolder: TacShellFolder): integer;
    function GetUpdating: boolean;
  protected
    procedure AddItems(Index: Integer; ParentFolder: TacShellFolder);
    procedure Click; override;
    procedure CreateRoot;
    procedure DestroyWnd; override;
    procedure Init; virtual;
    function InitItem(ParentFolder: TacShellFolder; ID: PItemIDList): TacShellFolder;
    procedure RootChanged;
    procedure TreeUpdate(NewPath: PItemIDList);
    procedure SetObjectTypes(Value: TacShellObjectTypes); virtual;
  public
    ExtUpdating : boolean;
    constructor Create(AOwner: TComponent); override;
    procedure Change; override;
{$IFNDEF DELPHI6UP}
    procedure WndProc(var Message: TMessage); override;
{$ENDIF}
    procedure CreateWnd; override;
    function IndexFromID(AbsoluteID: PItemIDList): Integer;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    destructor Destroy; override;
    procedure Loaded; override;
    property Items;
    property Path: string read GetPath write SetPath;
    property Folders[Index: Integer]: TacShellFolder read GetFolder;
    property Root: TacRoot read FRoot write SetRoot;
    property ObjectTypes: TacShellObjectTypes read FObjectTypes write SetObjectTypes;
    property ShellTreeView: TacCustomShellTreeView read FTreeView write SetTreeView;
    property ShellListView: TacCustomShellListView read FListView write SetListView;
    property Updating : boolean read GetUpdating;
    property UseShellImages: Boolean read FUseShellImages write SetUseShellImages default True;
    property OnGetImageIndex: TacGetImageIndexEvent read FOnGetImageIndex write FOnGetImageIndex;
  end;
{$ENDIF} // NOTFORHELP

{ TsShellComboBox }

  TsShellComboBox = class(TacCustomShellComboBox)
  public
    property Path;
  published
{$IFNDEF NOTFORHELP}
    {:@event}
    property OnGetImageIndex;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;

    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property Images;
{$ENDIF} // NOTFORHELP
    property Root;
    property ShellTreeView;
    property ShellListView;
    property UseShellImages;
  end;

{ TacCustomShellListView }

{$IFNDEF NOTFORHELP}
  TacCustomShellListView = class(TsCustomListView, IacShellCommandVerb)
  private
    FOldRoot: TacRoot;
    FRoot: TacRoot;
    FRootFolder: TacShellFolder;
    FAutoContext, FAutoRefresh, FAutoNavigate, FSorted: Boolean;
    FObjectTypes: TacShellObjectTypes;
    FLargeImages, FSmallImages: Integer;
    FOnAddFolder: TacAddFolderEvent;
    FTreeView: TacCustomShellTreeView;
    FComboBox: TacCustomShellComboBox;
    FNotifier: TacShellChangeNotifier;
    FOnEditing: TLVEditingEvent;
    FSettingRoot: boolean;
    FSavePath: string;
    FMask: string;
    FShowExtension: TacShowExtension;
    procedure EnumColumns;
    function GetFolder(Index: Integer): TacShellFolder;
    procedure SetAutoRefresh(const Value: Boolean);
    procedure SetSorted(const Value: Boolean);
    procedure SetTreeView(Value: TacCustomShellTreeView);
    procedure SetComboBox(Value: TacCustomShellComboBox);
    procedure SynchPaths;
    procedure SetMask(const Value: string);
    function GetUpdating: boolean;
  protected
    FFolders: TList;
    procedure ClearItems;
    procedure CreateRoot;
    procedure DestroyWnd; override;
    procedure DblClick; override;
    procedure DoContextPopup(MousePos: TPoint; var Handled: Boolean); override;
    procedure EditText;
    procedure Edit(const Item: TLVItem); override;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function OwnerDataFetch(Item: TListItem; Request: TItemRequest): Boolean; override;
    function OwnerDataFind(Find: TItemFind; const FindString: acString;
      const FindPosition: TPoint; FindData: Pointer; StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean): Integer; override;
    procedure Populate; virtual;
    procedure SetObjectTypes(Value: TacShellObjectTypes);
    procedure SetRoot(const Value: TacRoot);
    procedure WndProc(var Message: TMessage); override;
  public
    FUpdating: Boolean;
    procedure RootChanged;
    procedure SetPathFromID(ID: PItemIDList);
    procedure TreeUpdate(NewRoot: PItemIDList);
    constructor Create(AOwner: TComponent); override;
    procedure InitControl(const Skinned : boolean); override;
    destructor Destroy; override;
    procedure CreateWnd; override;
    procedure Loaded; override;
    procedure Back;
    procedure Refresh;
    procedure MakeNewFolder;
    function SelectedFolder: TacShellFolder;
    procedure CommandCompleted(Verb: String; Succeeded: Boolean);
    procedure ExecuteCommand(Verb: String; var Handled: Boolean);
    property Folders[Index: Integer]: TacShellFolder read GetFolder;
    property RootFolder: TacShellFolder read FRootFolder;
    property Items;
    property Columns;
    property Mask: string read FMask write SetMask;
    property AutoContextMenus: Boolean read FAutoContext write FAutoContext default True;
    property AutoRefresh: Boolean read FAutoRefresh write SetAutoRefresh default False;
    property AutoNavigate: Boolean read FAutoNavigate write FAutoNavigate default True;
    property ObjectTypes: TacShellObjectTypes read FObjectTypes write SetObjectTypes;
    property Root: TacRoot read FRoot write SetRoot;
    property ShellTreeView: TacCustomShellTreeView read FTreeView write SetTreeView;
    property ShellComboBox: TacCustomShellComboBox read FComboBox write SetComboBox;
    property Sorted: Boolean read FSorted write SetSorted;
    property Updating : boolean read GetUpdating;
    //Lexa
    property ShowExt: TacShowExtension read FShowExtension write FShowExtension;
    property OnAddFolder: TacAddFolderEvent read FOnAddFolder write FOnAddFolder;
    property OnEditing: TLVEditingEvent read FOnEditing write FOnEditing;
  end;
{$ENDIF} // NOTFORHELP

{ TShellListView }

  TsShellListView = class(TacCustomShellListView)
  published
{$IFNDEF NOTFORHELP}
    property OnChange;
    property OnChanging;
    property OnColumnClick;
    property OnContextPopup;
    property OnEnter;
    property OnExit;
    property OnInsert;
    property OnDragDrop;
    property OnDragOver;
    property DragCursor;
    property OnStartDrag;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;

    property Align;
    property Anchors;
    property BorderStyle;
    property Color;
    property ColumnClick;
    property OnClick;
    property OnDblClick;
    property Ctl3D;
    property DragMode;
    property ReadOnly default True;
    property Enabled;
    property Font;
    property GridLines;
    property Sorted;
    property HideSelection;
    property HotTrack;
    property IconOptions;
    property AllocBy;
    property MultiSelect;
    property RowSelect;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property ShowHint;
    property PopupMenu;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property ViewStyle;
    {:@event}
    property OnEditing;
    {:@event}
    property OnAddFolder;
{$ENDIF} // NOTFORHELP
    property AutoContextMenus;
    property AutoRefresh;
    property AutoNavigate;
    property ObjectTypes;
    property Root;
    property ShellTreeView;
    property ShellComboBox;
    property ShowExt;
    property Mask;
    property ShowColumnHeaders;
  end;

{$IFNDEF NOTFORHELP}
  TsDlgShellListView = class(TsShellListView)
  protected
    procedure DblClick; override;
  end;

function G_ValidateWildText(const S, Mask: string; MaskChar: Char = '?'; WildCard: Char = '*'): Boolean;
function G_CharPos(C: Char; const S: string; StartPos: Integer = 1): Integer; overload;
procedure DisposePIDL(PIDL: PItemIDList);

function DesktopShellFolder: IShellFolder;
function GetDisplayName(Parentfolder: IShellFolder; PIDL: PItemIDList; Flags: DWORD; ShowExt: TacShowExtension): acString;
function CreateRootFromPIDL(Value: PItemIDList): TacShellFolder;
function GetShellImage(PIDL: PItemIDList; Large, Open: Boolean): Integer;
//function GetIShellFolder(IFolder: IShellFolder; PIDL: PItemIDList; Handle: THandle = 0): IShellFolder;

procedure InvokeContextMenu(Owner: TWinControl; AFolder: TacShellFolder; X, Y: Integer);

var
  DontFoldersGenerate : boolean = False;
  UseAllFolderAttributes : boolean = True;

  SysSmallImages : THandle = 0;
  SysSmallImageList : TsAlphaImageList = nil;

const
  SRFDesktop = 'rfDesktop'; { Do not localize }
  SCmdVerbOpen = 'open'; { Do not localize }
  SCmdVerbRename = 'rename'; { Do not localize }
  SCmdVerbDelete = 'delete'; { Do not localize }
  SCmdVerbPaste = 'paste'; { Do not localize }
  SShellNoDetails = 'Unable to retrieve folder details for "%s". Error code $%x';

  NTFolders = [rfCommonDesktopDirectory, rfCommonPrograms, rfCommonStartMenu, rfCommonStartup];

  nFolder: array[TacRootFolder] of Integer = (CSIDL_DESKTOP, CSIDL_DRIVES,
    CSIDL_NETWORK, CSIDL_BITBUCKET, CSIDL_APPDATA, CSIDL_COMMON_DESKTOPDIRECTORY,
    CSIDL_COMMON_PROGRAMS, CSIDL_COMMON_STARTMENU, CSIDL_COMMON_STARTUP,
    CSIDL_CONTROLS, CSIDL_DESKTOPDIRECTORY, CSIDL_FAVORITES, CSIDL_FONTS,
    CSIDL_INTERNET, CSIDL_PERSONAL, CSIDL_PRINTERS, CSIDL_PRINTHOOD, CSIDL_PROGRAMS,
    CSIDL_RECENT, CSIDL_SENDTO, CSIDL_STARTMENU, CSIDL_STARTUP, CSIDL_TEMPLATES);


{$ENDIF} // NOTFORHELP

implementation

uses ShellAPI, ComObj, TypInfo, Menus, Consts, Math, sMessages, sVclUtils,
  acntUtils, FileCtrl, acSBUtils{$IFDEF TNTUNICODE}, TntClasses{$ENDIF} {$IFDEF DELPHI7UP}, StrUtils{$ENDIF};

{$I sDefs.inc}

var
  cmvProperties: POldChar = 'properties';  { Do not localize }
  ICM: IContextMenu = nil;
  ICM2: IContextMenu2 = nil;
  DesktopFolder: TacShellFolder = nil;
  CS : TRTLCriticalSection;
//  SmallImages : TImageList;

{ PIDL manipulation }

function CreatePIDL(Size: Integer): PItemIDList;
var
  Malloc: IMalloc;
begin
  OleCheck(SHGetMalloc(Malloc));
  Result := Malloc.Alloc(Size);
  if Assigned(Result) then FillChar(Result^, Size, 0);
end;

function NextPIDL(IDList: PItemIDList): PItemIDList;
begin
  Result := IDList;
  Inc(POldChar(Result), IDList^.mkid.cb);
end;

procedure StripLastID(IDList: PItemIDList);
var
  MarkerID: PItemIDList;
begin
  MarkerID := IDList;
  if Assigned(IDList) then begin
    while IDList.mkid.cb <> 0 do begin
      MarkerID := IDList;
      IDList := NextPIDL(IDList);
    end;
    MarkerID.mkid.cb := 0;
  end;
end;

function GetItemCount(IDList: PItemIDList): Integer;
begin
  Result := 0;
  while IDList^.mkid.cb <> 0 do begin
    Inc(Result);
    IDList := NextPIDL(IDList);
  end;
end;

function GetPIDLSize(IDList: PItemIDList): Integer;
begin
  Result := 0;
  if Assigned(IDList) then begin
    Result := SizeOf(IDList^.mkid.cb);
    while IDList^.mkid.cb <> 0 do begin
      Result := Result + IDList^.mkid.cb;
      IDList := NextPIDL(IDList);
    end;
  end;
end;

function CopyPIDL(IDList: PItemIDList): PItemIDList;
var
  Size: Integer;
begin
  Size := GetPIDLSize(IDList);
  Result := CreatePIDL(Size);
  if Assigned(Result) then CopyMemory(Result, IDList, Size);
end;

function ConcatPIDLs(IDList1, IDList2: PItemIDList): PItemIDList;
var
  cb1, cb2: Integer;
begin
  if Assigned(IDList1) then cb1 := GetPIDLSize(IDList1) - SizeOf(IDList1^.mkid.cb) else cb1 := 0;

  cb2 := GetPIDLSize(IDList2);

  Result := CreatePIDL(cb1 + cb2);
  if Assigned(Result) then begin
    if Assigned(IDList1) then CopyMemory(Result, IDList1, cb1);
    CopyMemory(POldChar(Result) + cb1, IDList2, cb2);
  end;
end;

procedure DisposePIDL(PIDL: PItemIDList);
var
  MAlloc: IMAlloc;
begin
  OLECheck(SHGetMAlloc(MAlloc));
  MAlloc.Free(PIDL);
end;

function RelativeFromAbsolute(AbsoluteID: PItemIDList): PItemIDList;
begin
  Result := AbsoluteID;
  while GetItemCount(Result) > 1 do Result := NextPIDL(Result);
  Result := CopyPIDL(Result);
end;

function CreatePIDLList(ID: PItemIDList): TList;
var
  TempID: PItemIDList;
begin
  Result := TList.Create;
  TempID := ID;
  while TempID.mkid.cb <> 0 do begin
    TempID := CopyPIDL(TempID);
    Result.Insert(0, TempID); //0 = lowest level PIDL.
    StripLastID(TempID);
  end;
end;

procedure DestroyPIDLList(List: TList);
var
  I: Integer;
begin
  If List = nil then Exit;
  for I := 0 to List.Count-1 do DisposePIDL(List[I]);
  FreeAndNil(List);
end;

{ Miscellaneous }

procedure NoFolderDetails(AFolder: TacShellFolder; HR: HResult; ShowExt: TacShowExtension);
begin
  Raise Exception.CreateFmt(SShellNoDetails, [AFolder.DisplayName(ShowExt), HR]);
end;

function DesktopShellFolder: IShellFolder;
begin
  OleCheck(SHGetDesktopFolder(Result));
end;

procedure CreateDesktopFolder;
var
  DesktopPIDL: PItemIDList;
begin
  SHGetSpecialFolderLocation(0, nFolder[rfDesktop], DesktopPIDL);
  if DesktopPIDL <> nil then begin
    DesktopFolder := TacShellFolder.Create(nil, DesktopPIDL, DesktopShellFolder);
    DisposePIDL(DesktopPIDL);
  end;
end;

function SamePIDL(ID1, ID2: PItemIDList): boolean;
begin
  Result := DesktopShellFolder.CompareIDs(0, ID1, ID2) = 0;
end;

function DesktopPIDL: PItemIDList;
begin
  OleCheck(SHGetSpecialFolderLocation(0, nFolder[rfDesktop], Result));
end;

function GetCSIDLType(const Value: string): TacRootFolder;
begin
{$R+}
  Result := TacRootFolder(GetEnumValue(TypeInfo(TacRootFolder), Value))
{$R-}
end;

function IsElement(Element, Flag: Integer): Boolean;
begin
  Result := Element and Flag <> 0;
end;

function GetShellImage(PIDL: PItemIDList; Large, Open: Boolean): Integer;
var
  FileInfo: TSHFileInfo;
  Flags: Integer;
begin
  Flags := SHGFI_PIDL or SHGFI_SYSICONINDEX;
  if Open then Flags := Flags or SHGFI_OPENICON;
  if Large then Flags := Flags or SHGFI_LARGEICON else Flags := Flags or SHGFI_SMALLICON;
  SHGetFileInfo(PChar(PIDL), 0, FileInfo, SizeOf(FileInfo), Flags);
  Result := FileInfo.iIcon;
end;

function GetCaps(ParentFolder: IShellFolder; PIDL: PItemIDList): TacShellFolderCapabilities;
var
  Flags: LongWord;
begin
  Result := [];
  Flags := SFGAO_CAPABILITYMASK;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  if IsElement(SFGAO_CANCOPY, Flags) then Include(Result, fcCanCopy);
  if IsElement(SFGAO_CANDELETE, Flags) then Include(Result, fcCanDelete);
  if IsElement(SFGAO_CANLINK, Flags) then Include(Result, fcCanLink);
  if IsElement(SFGAO_CANMOVE, Flags) then Include(Result, fcCanMove);
  if IsElement(SFGAO_CANRENAME, Flags) then Include(Result, fcCanRename);
  if IsElement(SFGAO_DROPTARGET, Flags) then Include(Result, fcDropTarget);
  if IsElement(SFGAO_HASPROPSHEET, Flags) then Include(Result, fcHasPropSheet);
end;

function GetProperties(ParentFolder: IShellFolder; PIDL: PItemIDList): TacShellFolderProperties;
var
  Flags: LongWord;
begin
  Result := [];
  if ParentFolder = nil then Exit;
  if UseAllFolderAttributes
    then Flags := SFGAO_DISPLAYATTRMASK
    else Flags := SFGAO_LINK + SFGAO_SHARE + SFGAO_GHOSTED;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  if IsElement(SFGAO_GHOSTED, Flags) then Include(Result, fpCut);
  if IsElement(SFGAO_LINK, Flags) then Include(Result, fpIsLink);
  if IsElement(SFGAO_READONLY, Flags) then Include(Result, fpReadOnly);
  if IsElement(SFGAO_SHARE, Flags) then Include(Result, fpShared);

  Flags := 0;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  if IsElement(SFGAO_FILESYSTEM, Flags) then Include(Result, fpFileSystem);
  if IsElement(SFGAO_FILESYSANCESTOR, Flags) then Include(Result, fpFileSystemAncestor);
  if IsElement(SFGAO_REMOVABLE, Flags) then Include(Result, fpRemovable);
  if IsElement(SFGAO_VALIDATE, Flags) then Include(Result, fpValidate);
end;

function GetIsFolder(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_FOLDER;// and SFGAO_FILESYSTEM;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := SFGAO_FOLDER and Flags <> 0;
end;

function GetIsLink(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_LINK;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := (SFGAO_LINK and Flags <> 0);
end;

function GetIsReadOnly(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_READONLY;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := (SFGAO_READONLY and Flags <> 0);
end;

function GetIsFileFolder(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_FILESYSTEM;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := (SFGAO_FILESYSTEM and Flags <> 0) and GetIsFolder(Parentfolder, PIDL) and not GetIsLink(Parentfolder, PIDL);
end;

function GetIsFile(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_FILESYSTEM;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := (SFGAO_FILESYSTEM and Flags <> 0) and not GetIsFolder(Parentfolder, PIDL) and not GetIsLink(Parentfolder, PIDL);
end;

function GetHasSubFolders(Parentfolder: IShellFolder; PIDL: PItemIDList): Boolean;
var
  Flags: LongWord;
begin
  Flags := SFGAO_CONTENTSMASK;
  ParentFolder.GetAttributesOf(1, PIDL, Flags);
  Result := SFGAO_HASSUBFOLDER and Flags <> 0;
end;

function GetHasSubItems(ShellFolder: IShellFolder; Flags: Integer): Boolean;
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NumIDs: LongWord;
  HR: HResult;
  ErrMode: Integer;
begin
  Result := False;
  if ShellFolder = nil then Exit;
  ErrMode := SetErrorMode(SEM_FAILCRITICALERRORS);
  try
    HR := ShellFolder.EnumObjects(0, Flags, EnumList);
    if HR <> S_OK then Exit;
    Result := EnumList.Next(1, ID, NumIDs) = S_OK;
  finally
    SetErrorMode(ErrMode);
  end;
end;

function StrRetToString(PIDL: PItemIDList; StrRet: TStrRet; Flag: string = ''): acString;
var
  P: PChar;
begin
  case StrRet.uType of
{$IFNDEF UNICODE}
    STRRET_CSTR : SetString(Result, StrRet.cStr, lStrLen(StrRet.cStr));
{$ENDIF}
    STRRET_OFFSET : begin
      P := PChar(@PIDL.mkid.abID[StrRet.uOffset - SizeOf(PIDL.mkid.cb)]);
      SetString(Result, P, PIDL.mkid.cb - StrRet.uOffset);
    end;
    STRRET_WSTR : if Assigned(StrRet.pOleStr) then Result := acString(StrRet.pOleStr) else Result := '';
  end;
{$IFNDEF TNTUNICODE}
  { This is a hack bug fix to get around Windows Shell Controls returning
    spurious "?"s in date/time detail fields }
  if (Length(Result) > 1) and (Result[1] = '?') and (Result[2] in ['0'..'9'])
    then Result := StringReplace(Result, '?', '', [rfReplaceAll]);
{$ENDIF}    
end;

function GetDisplayName(Parentfolder: IShellFolder; PIDL: PItemIDList; Flags: DWORD; ShowExt: TacShowExtension): acString;
var
  StrRet: TStrRet;
  NewFilename, ExtOld, ExtNew : acString;
begin
  Result := '';
  if ParentFolder = nil then begin
    Result := 'parentfolder = nil'; { Do not localize }
    exit;
  end;
  FillChar(StrRet, SizeOf(StrRet), 0);
  ParentFolder.GetDisplayNameOf(PIDL, Flags, StrRet);
  Result := StrRetToString(PIDL, StrRet);

  if ShowExt <> (seSystem) then begin // Lexa
    ExtOld := ExtractFileExt(Result);

    FillChar(StrRet, SizeOf(StrRet), 0);
    ParentFolder.GetDisplayNameOf(PIDL, SHGDN_FORPARSING, StrRet);
    NewFilename := StrRetToString(PIDL, StrRet);

    if FileExists(NewFilename) then begin
      ExtNew := ExtractFileExt(NewFilename);

      if ShowExt = (seShow) then begin
        if ExtOld <> ExtNew then Result := Result + ExtNew;
      end
      else if ShowExt = (seHide) then if ExtOld <> '' then Result := Copy(Result, 1, Length(Result) - Length(ExtOld));
    end;
  end;

  { TODO 2 -oMGD -cShell Controls : Remove this hack (on Win2k, GUIDs are returned for the PathName of standard folders)}
  if (Pos('::{', Result) = 1) then Result := GetDisplayName(ParentFolder, PIDL, SHGDN_NORMAL, ShowExt);
end;

function ObjectFlags(ObjectTypes: TacShellObjectTypes): Integer;
begin
  Result := 0;
  if otFolders in ObjectTypes then Inc(Result, SHCONTF_FOLDERS);
  if otNonFolders in ObjectTypes then Inc(Result, SHCONTF_NONFOLDERS);
  if otHidden in ObjectTypes then Inc(Result, SHCONTF_INCLUDEHIDDEN);
end;

procedure InvokeContextMenu(Owner: TWinControl; AFolder: TacShellFolder; X, Y: Integer);
var
  PIDL: PItemIDList;
  CM: IContextMenu;
  Menu: HMenu;
  ICI: TCMInvokeCommandInfo;
  P: TPoint;
  Command: LongBool;
  ICmd: integer;
  ZVerb: array[0..255] of OldChar;
  Verb: string;
  Handled: boolean;
  SCV: IacShellCommandVerb;
  HR: HResult;
begin
  if AFolder = nil then Exit;
  PIDL := AFolder.RelativeID;
  AFolder.ParenTacShellFolder.GetUIObjectOf(Owner.Handle, 1, PIDL, IID_IContextMenu, nil, CM);
  if CM = nil then Exit;
  P.X := X;
  P.Y := Y;

  Windows.ClientToScreen(Owner.Handle, P);
  Menu := CreatePopupMenu;
  try
    CM.QueryContextMenu(Menu, 0, 1, $7FFF, CMF_EXPLORE or CMF_CANRENAME);
    CM.QueryInterface(IID_IContextMenu2, ICM2); //To handle submenus.
    try
      Command := TrackPopupMenu(Menu, TPM_LEFTALIGN or TPM_LEFTBUTTON or TPM_RIGHTBUTTON or
        TPM_RETURNCMD, P.X, P.Y, 0, Owner.Handle, nil);
    finally
      ICM2 := nil;
    end;

    if Command then begin
      ICmd := LongInt(Command) - 1;
      HR := CM.GetCommandString(ICmd, GCS_VERBA, nil, ZVerb, SizeOf(ZVerb));
      Verb := StrPas(ZVerb);
      Handled := False;
      if Supports(Owner, IacShellCommandVerb, SCV) then begin
        HR := 0;
        SCV.ExecuteCommand(Verb, Handled);
      end;

      if not Handled then begin
        FillChar(ICI, SizeOf(ICI), #0);
        with ICI do begin
          cbSize := SizeOf(ICI);
          hWND := Owner.Handle;
          lpVerb := MakeIntResourceA(ICmd);
          nShow := SW_SHOWNORMAL;
        end;
        HR := CM.InvokeCommand(ICI);
      end;

      if Assigned(SCV) then SCV.CommandCompleted(Verb, HR = S_OK);
    end;
  finally
    DestroyMenu(Menu);
  end;
end;

procedure DoContextMenuVerb(AFolder: TacShellFolder; Verb: POldChar);
var
  ICI: TCMInvokeCommandInfo;
  CM: IContextMenu;
  PIDL: PItemIDList;
begin
  if AFolder = nil then Exit;
  FillChar(ICI, SizeOf(ICI), #0);
  with ICI do begin
    cbSize := SizeOf(ICI);
    fMask := CMIC_MASK_ASYNCOK;
    hWND := 0;
    lpVerb := Verb;
    nShow := SW_SHOWNORMAL;
  end;
  PIDL := AFolder.RelativeID;
  AFolder.ParenTacShellFolder.GetUIObjectOf(0, 1, PIDL, IID_IContextMenu, nil, CM);
  CM.InvokeCommand(ICI);
end;

function GetIShellFolder(IFolder: IShellFolder; PIDL: PItemIDList; Handle: THandle = 0): IShellFolder;
var
  HR : HResult;
begin
  if Assigned(IFolder) then begin
    HR := IFolder.BindToObject(PIDL, nil, IID_IShellFolder, Pointer(Result));
    if HR <> S_OK then IFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IShellFolder, nil, Pointer(Result));
    if HR <> S_OK then IFolder.CreateViewObject(Handle, IID_IShellFolder, Pointer(Result));
  end;
  if not Assigned(Result) then DesktopShellFolder.BindToObject(PIDL, nil, IID_IShellFolder, Pointer(Result));
end;

function GetIShellDetails(IFolder: IShellFolder; PIDL: PItemIDList; Handle: THandle = 0): IShellDetails;
var
  HR : HResult;
begin
  if Assigned(IFolder) then begin
    HR := IFolder.BindToObject(PIDL, nil, IID_IShellDetails, Pointer(Result));
    if HR <> S_OK then IFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IShellDetails, nil, Pointer(Result));
    if HR <> S_OK then IFolder.CreateViewObject(Handle, IID_IShellDetails, Pointer(Result));
  end;
  if not Assigned(Result) then DesktopShellFolder.BindToObject(PIDL, nil, IID_IShellDetails, Pointer(Result));
end;

function GetIShellFolder2(IFolder: IShellFolder; PIDL: PItemIDList; Handle: THandle = 0): IShellFolder2;
var
  HR : HResult;
begin
  if (Win32MajorVersion >= 5) then begin
    HR := DesktopShellFolder.BindToObject(PIDL, nil, IID_IShellFolder2, Pointer(Result));
    if HR <> S_OK then IFolder.GetUIObjectOf(Handle, 1, PIDL, IID_IShellFolder2, nil, Pointer(Result));
    if (HR <> S_OK) and (IFolder <> nil) then IFolder.BindToObject(PIDL, nil, IID_IShellFolder2, Pointer(Result));
  end
  else Result := nil;
end;

function CreateRootFromPIDL(Value: PItemIDList): TacShellFolder;
var
  SF: IShellFolder;
begin
  SF := GetIShellFolder(DesktopShellFolder, Value);
  if SF = NIL then SF := DesktopShellFolder;
  //special case - Desktop folder can't bind to itself.
  Result := TacShellFolder.Create(DesktopFolder, Value, SF);
end;

function CreateRootFolder(RootFolder: TacShellFolder; OldRoot : TacRoot; var NewRoot: TacRoot): TacShellFolder;
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  NumChars,
  Flags,
  HR: LongWord;
  ErrorMsg : string;
begin
  HR := S_FALSE;
  if GetEnumValue(TypeInfo(TacRootFolder), NewRoot) >= 0 then begin
    HR := SHGetSpecialFolderLocation(0, nFolder[GetCSIDLType(NewRoot)], NewPIDL);
  end
  else if Length(NewRoot) > 0 then begin
    NewRoot := NormalDir(NewRoot);
    if NewRoot[Length(NewRoot)] = ':' then NewRoot := NewRoot + '\';
    NumChars := Length(NewRoot);
    Flags := 0;
    P := StringToOleStr(ExpandFilename(NewRoot));
    HR := DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags);
  end;

  if HR <> S_OK then begin
    ErrorMsg := Format('Error Setting Path : %s', [ NewRoot ] );
    NewRoot := OldRoot;

    if GetEnumValue(TypeInfo(TacRootFolder), NewRoot) >= 0 then begin
      HR := SHGetSpecialFolderLocation(0, nFolder[GetCSIDLType(NewRoot)], NewPIDL);
    end
    else if Length(NewRoot) > 0 then begin
      NewRoot := NormalDir(NewRoot);
      if NewRoot[Length(NewRoot)] = ':' then NewRoot := NewRoot + '\';
      NumChars := Length(NewRoot);
      Flags := 0;
      P := StringToOleStr(ExpandFilename(NewRoot));
      HR := DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags);
    end;
    if HR <> S_OK then Raise Exception.Create(ErrorMsg) else ShowError(ErrorMsg);
  end;
  Result := CreateRootFromPIDL(NewPIDL);
  if Assigned(RootFolder) then FreeAndNil(RootFolder);
end;

{ TacShellFolder }

constructor TacShellFolder.Create(AParent: TacShellFolder; ID: PItemIDList; SF: IShellFolder);
var
  DesktopID: PItemIDList;
begin
  inherited Create;
  FLevel := 0;
  FDetails := TStringList.Create;
  FIShellFolder := SF;

  FIShellFolder2 := nil;
  FIShellDetails := nil;

  FParent := AParent;
  FPIDL := CopyPIDL(ID);
  if FParent <> nil then FFullPIDL := ConcatPIDLs(AParent.FFullPIDL, ID) else begin
    DesktopID := DesktopPIDL;
    try
      FFullPIDL := ConcatPIDLs(DesktopID, ID);
    finally
      DisposePIDL(DesktopID);
    end;
  end;
  if FParent = nil then FParent := DesktopFolder;
  while AParent <> nil do begin
    AParent := AParent.Parent;
    if AParent <> nil then Inc(FLevel);
  end;
end;

destructor TacShellFolder.Destroy;
begin
  if Assigned(FDetails) then FreeAndNil(FDetails);
  if Assigned(FPIDL) then DisposePIDL(FPIDL);
  if Assigned(FFullPIDL) then DisposePIDL(FFullPIDL);
  inherited Destroy;
end;

function TacShellFolder.GetDetailInterface: IDetInterface;
begin
  if (not Assigned(FDetailInterface)) and Assigned(FIShellFolder) then begin
    FIShellDetails := GetIShellDetails(FIShellFolder, FFullPIDL, FViewHandle);
    if (not Assigned(FIShellDetails)) and (Win32MajorVersion >= 5) then begin
      FIShellFolder2 := GetIShellFolder2(FIShellFolder, FFullPIDL, FViewHandle);
      if not Assigned(FIShellFolder2) then // Hack!
       { Note: Although QueryInterface will not work in this instance,
         IShellFolder2 is indeed supported for this Folder if IShellDetails
         is not. In all tested cases, hard-casting the interface to
         IShellFolder2 has worked. Hopefully, Microsoft will fix this bug in
         a future release of ShellControls }
        FIShellFolder2 := IShellFolder2(FIShellFolder);
    end;
    if Assigned(FIShellFolder2) then Result := IDetInterface(FIShellFolder2) else Result := IDetInterface(FIShellDetails); // Casting is correct ?
    FDetailInterface := Result;
  end
  else Result := FDetailInterface;
end;

function TacShellFolder.GetShellDetails: IShellDetails;
begin
  if not Assigned(FDetailInterface) then GetDetailInterface;
  Result := FIShellDetails;
end;

function TacShellFolder.GeTacShellFolder2: IShellFolder2;
begin
  if not Assigned(FDetailInterface) then GetDetailInterface;
  Result := FIShellFolder2;
end;

procedure TacShellFolder.LoadColumnDetails(RootFolder: TacShellFolder; Handle: THandle; ColumnCount: integer);
  procedure GetDetailsOf(AFolder: TacShellFolder; var Details: TWin32FindData);
  var
    szPath: array[ 0 .. MAX_PATH] of char;
    Path: string;
    Handle: THandle;
  begin
    FillChar(Details, SizeOf(Details), 0);
    FillChar(szPath, MAX_PATH, 0);
    Path := AFolder.PathName;
    Handle := Windows.FindFirstFile(PChar(Path), Details);
    try
      if Handle = INVALID_HANDLE_VALUE then NoFolderDetails(AFolder, Windows.GetLastError, seSystem);
    finally
      Windows.FindClose(Handle);
    end;
  end;
  function CalcFileSize(FindData: TWin32FindData): int64;
  begin
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0
      then Result := FindData.nFileSizeHigh * MAXDWORD + FindData.nFileSizeLow
      else Result := -1;
  end;
  function CalcModifiedDate(FindData: TWin32FindData): TDateTime;
  var
    LocalFileTime: TFileTime;
    Age : integer;
  begin
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then begin
      FileTimeToLocalFileTime(FindData.ftLastWriteTime, LocalFileTime);
      if FileTimeToDosDateTime(LocalFileTime, LongRec(Age).Hi, LongRec(Age).Lo) then begin
        Result := FileDateToDateTime(Age);
        Exit;
      end;
    end;
    Result := -1;
  end;
  function DefaultDetailColumn(FindData: TWin32FindData; Col: integer): string;
  begin
    case Col of
      //1 : Result := FindData.cFileName; // Name
      1 : Result := IntToStr(CalcFileSize(FindData)); // Size
      2 : Result := ExtractFileExt(FindData.cFileName); // Type
      3 : Result := DateTimeToStr(CalcModifiedDate(FindData)); // Modified
      4 : Result := IntToStr(FindData.dwFileAttributes);
    end;
  end;
  procedure AddDetail(HR: HResult; PIDL: PItemIDList; SD: TShellDetails);
  begin
    if HR = S_OK then FDetails.Add(StrRetToString(PIDL, SD.str)) else FDetails.Add('');
  end;
var
  SF2: IShellFolder2;
  ISD: IShellDetails;
  SD: TShellDetails;
  J: Integer;
  HR: HResult;
  FindData: TWin32FindData;
begin
  if not Assigned(FDetails) or (FDetails.Count >= ColumnCount) then Exit; // Details are loaded
  FDetails.Clear;
  FViewHandle := Handle;
  SF2 := RootFolder.ShellFolder2;
  if Assigned(SF2) then begin
    // Already have name and icon, so see if we can provide details
    for J := 1 to ColumnCount do begin
      HR := SF2.GetDetailsOf(FPIDL, J, SD);
      AddDetail(HR, FPIDL, SD);
    end;
  end
  else begin
    ISD := RootFolder.ShellDetails;
    if Assigned(ISD) then begin
      for J := 1 to ColumnCount do begin
        HR := ISD.GetDetailsOf(FPIDL, J, SD);
        AddDetail(HR, FPIDL, SD);
      end;
    end
    else if (fpFileSystem in RootFolder.Properties) then begin
      GetDetailsOf(Self, FindData);
      for J := 1 to ColumnCount do FDetails.Add(DefaultDetailColumn(FindData, J));
    end;
  end;
end;

function TacShellFolder.GetDetails(Index: integer): string;
begin
  if FDetails.Count > 0 then
    Result := FDetails[Index-1] // Index is 1-based
  else
    Raise Exception.CreateFmt('%s: Missing call to LoadColumnDetails', [ Self.DisplayName(seSystem) ] );
end;

procedure TacShellFolder.SetDetails(Index: integer; const Value: string);
begin
  if Index < FDetails.Count
    then FDetails[Index - 1] := Value // Index is 1-based
    else FDetails.Insert(Index - 1, Value); // Index is 1-based
end;

function TacShellFolder.ParenTacShellFolder: IShellFolder;
begin
  if FParent <> nil then Result := FParent.ShellFolder else OLECheck(SHGetDesktopFolder(Result));
end;

function TacShellFolder.Properties: TacShellFolderProperties;
begin
  Result := GetProperties(ParenTacShellFolder, FPIDL);
end;

function TacShellFolder.Capabilities: TacShellFolderCapabilities;
begin
  Result := GetCaps(ParenTacShellFolder, FPIDL);
end;

function TacShellFolder.SubFolders: Boolean;
begin
  Result := GetHasSubFolders(ParenTacShellFolder, FPIDL);
end;

function TacShellFolder.IsFolder(const Name : string = ''; OpenZipFiles : Boolean = True): Boolean;
begin
  if not OpenZipFiles and (Name <> '') and (LowerCase(ExtractFileExt(Name)) = '.zip')
    then Result := False
    else Result := GetIsFolder(ParenTacShellFolder, FPIDL);
end;

function TacShellFolder.PathName: string;
begin
  Result := GetDisplayName(DesktopShellFolder, FFullPIDL, SHGDN_FORPARSING, seSystem);
end;

function TacShellFolder.DisplayName(ShowExt: TacShowExtension): acString;
var
  ParentFolder: IShellFolder;
begin
  if Parent <> nil then ParentFolder := ParentacShellFolder else ParentFolder := DesktopShellFolder;
  if ParentFolder <> nil
    then Result := GetDisplayName(ParentFolder, FPIDL, SHGDN_INFOLDER, ShowExt)
    else Result := '?';
end;

function TacShellFolder.Rename(const NewName: Widestring): boolean;
var
  NewPIDL: PItemIDList;
begin
  Result := False;
  if not (fcCanRename in Capabilities) then Exit;

  Result := ParenTacShellFolder.SetNameOf(0, FPIDL, PWideChar(NewName), SHGDN_NORMAL, NewPIDL) = S_OK;
  if Result then begin
    DisposePIDL(FPIDL);
    DisposePIDL(FFullPIDL);
    FPIDL := NewPIDL;
    if (FParent <> nil) then FFullPIDL := ConcatPIDLs(FParent.FPIDL, NewPIDL) else FFullPIDL := CopyPIDL(NewPIDL);
  end
  else Raise Exception.Create(Format('Rename to %s failed',[NewName]));
end;

function TacShellFolder.ImageIndex(LargeIcon: Boolean): Integer;
begin
  Result := GetShellImage(AbsoluteID, LargeIcon, False);
end;

function TacShellFolder.ExecuteDefault: Integer;
var
  SEI: TShellExecuteInfo;
begin
  FillChar(SEI, SizeOf(SEI), 0);
  with SEI do begin
    cbSize := SizeOf(SEI);
    wnd := Application.Handle;
    fMask := SEE_MASK_INVOKEIDLIST;
    lpIDList := AbsoluteID;
    nShow := SW_SHOW;
  end;
  Result := Integer(ShellExecuteEx(@SEI));
end;

function TacShellFolder.IsFile(const Name : string = ''; OpenZipFiles : Boolean = True): Boolean;
begin
  if not OpenZipFiles and (Name <> '') and (LowerCase(ExtractFileExt(Name)) = '.zip')
    then Result := True
    else Result := GetIsFile(ParenTacShellFolder, FPIDL);
end;

function TacShellFolder.IsFileFolder: Boolean;
begin
  Result := GetIsFileFolder(ParenTacShellFolder, FPIDL);
end;

function TacShellFolder.IsReadOnly: Boolean;
begin
  Result := GetIsReadOnly(ParenTacShellFolder, FPIDL);
end;

{ TacCustomShellChangeNotifier }

procedure TacCustomShellChangeNotifier.Change;
  function NotifyOptionFlags: DWORD;
  begin
    Result := 0;
    if nfFileNameChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
    if nfDirNameChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
    if nfSizeChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_SIZE;
    if nfAttributeChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
    if nfWriteChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;
    if nfSecurityChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
  end;
begin
  if Assigned(FThread) then begin
    FThread.SetDirectoryOptions(Root, LongBool(FWatchSubTree), NotifyOptionFlags);
  end;
end;

constructor TacCustomShellChangeNotifier.Create(AOwner : TComponent);
begin
  inherited;
  FRoot := 'C:\';      { Do not localize }
  FWatchSubTree := True;
  FFilters := [nfFilenameChange, nfDirNameChange];
  Start;
end;

destructor TacCustomShellChangeNotifier.Destroy;
var
  Temp : TacShellChangeThread;
begin
  if Assigned(FThread) then begin
    OnChange := nil;
    Temp := FThread;
    FThread := nil;
    Temp.Free; // .Terminate;
    ReleaseMutex(Temp.FMutex);
  end;
  inherited;
end;

procedure TacCustomShellChangeNotifier.SetRoot(const Value: TacRoot);
begin
  if not SameText(FRoot, Value) then begin
    FRoot := Value;
    Change;
  end;
end;

procedure TacCustomShellChangeNotifier.SetFilters(const Value: TacNotifyFilters);
begin
  FFilters := Value;
  Change;
end;

procedure TacCustomShellChangeNotifier.SetOnChange(const Value: TThreadMethod);
begin
  FOnChange := Value;
  if Assigned(FThread) then FThread.ChangeEvent := FOnChange else Start;
end;

procedure TacCustomShellChangeNotifier.SetWatchSubTree(const Value: Boolean);
begin
  FWatchSubTree := Value;
  Change;
end;

procedure TacCustomShellChangeNotifier.Start;
  function NotifyOptionFlags: DWORD;
  begin
    Result := 0;
    if nfFileNameChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_FILE_NAME;
    if nfDirNameChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_DIR_NAME;
    if nfSizeChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_SIZE;
    if nfAttributeChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_ATTRIBUTES;
    if nfWriteChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_LAST_WRITE;
    if nfSecurityChange in FFilters then Result := Result or FILE_NOTIFY_CHANGE_SECURITY;
  end;
begin
  if Assigned(FOnChange) then begin
    FThread := TacShellChangeThread.Create(FOnChange);
    FThread.SetDirectoryOptions(FRoot, LongBool(FWatchSubTree), NotifyOptionFlags);
    FThread.Resume;
  end;
end;

{ TacShellChangeThread }

constructor TacShellChangeThread.Create(ChangeEvent: TThreadMethod);
begin
  FreeOnTerminate := FALSE;
  FChangeEvent := ChangeEvent;
  FMutex := CreateMutex(nil, True, nil);
  //Mutex is used to wake up the thread as it waits for any change notifications.
  WaitForSingleObject(FMutex, INFINITE); //Grab the mutex.
  FWaitChanged := false;
{$IFDEF D2005}
  FStopEvent := TEvent.Create(nil, true, false, '', false);
  FActive := TEvent.Create(nil, true, false, '', false);
{$ELSE}
  FStopEvent := TEvent.Create(nil, true, false, '');
  FActive := TEvent.Create(nil, true, false, '');
{$ENDIF}
  inherited Create(True);
end;

destructor TacShellChangeThread.Destroy;
begin
  FStopEvent.SetEvent;
  if FActive.WaitFor(0) = wrSignaled then
  begin
    Terminate;
    WaitFor;
  end;
  if FWaitHandle <> ERROR_INVALID_HANDLE then
    FindCloseChangeNotification(FWaitHandle);
  CloseHandle(FMutex);
  inherited Destroy;
  FActive.Free;
  FStopEvent.Free;
end;

procedure TacShellChangeThread.Execute;
var
  Obj: DWORD;
  Handles: array[0..2] of DWORD;
begin
  FActive.SetEvent;
  try
    EnterCriticalSection(CS);
    FWaitHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FNotifyOptionFlags);
    LeaveCriticalSection(CS);
    if FWaitHandle = ERROR_INVALID_HANDLE then Exit;
    Handles[1] := FMutex;
    Handles[2] := FStopEvent.Handle;
    while not Terminated do begin
      Handles[0] := FWaitHandle;
 //    Handles[1] := FMutex;
      Obj := WaitForMultipleObjects(3, PWOHandleArray(@Handles), False, INFINITE);
      case Obj of
        WAIT_OBJECT_0:  begin
                          Synchronize(FChangeEvent);
                          if FStopEvent.WaitFor(0) = wrTimeout then
                            FindNextChangeNotification(FWaitHandle);
                        end;

        WAIT_OBJECT_0 + 1:  ReleaseMutex(FMutex);
        WAIT_OBJECT_0 + 2:  begin
                              Terminate;
                              break;
                            end;
        WAIT_FAILED : Exit;
      end;
      EnterCriticalSection(CS);
      if FWaitChanged then
      begin
        FindCloseChangeNotification(FWaitHandle);
        FWaitHandle := ERROR_INVALID_HANDLE;
        FWaitHandle := FindFirstChangeNotification(PChar(FDirectory), LongBool(FWatchSubTree), FNotifyOptionFlags);
        FWaitChanged := false;
      end;
      LeaveCriticalSection(CS);
    end;
  finally
    FActive.ResetEvent;
  end;
end;

procedure TacShellChangeThread.SetDirectoryOptions(const Directory: String; WatchSubTree: Boolean; NotifyOptionFlags: DWORD);
begin
  EnterCriticalSection(CS);
  FDirectory := Directory;
  FWatchSubTree := WatchSubTree;
  FNotifyOptionFlags := NotifyOptionFlags;

  // Release the current notification handle
  FindCloseChangeNotification(FWaitHandle);
  FWaitChanged := true;
  LeaveCriticalSection(CS);
end;

{ TacCustomShellTreeView }

constructor TacCustomShellTreeView.Create(AOwner: TComponent);
//var
//  FileInfo: TSHFileInfo;
begin
  inherited Create(AOwner);
  FRootFolder := nil;
//  ShowRoot := False;
  FObjectTypes := [otFolders];
  RightClickSelect := True;
  FAutoContext := True;
  //! OnDeletion := NodeDeleted;
  FUpdating := False;
  FComboBox := nil;
  FListView := nil;
  FImageListChanging := False;
  FUseShellImages := True;
  FShowExtension := (seSystem);
  FNotifier := nil;
//  Images := SysSmallImageList;
//  FImage := SHGetFileInfo('C:\', { Do not localize } 0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);

//  FNotifier := TacShellChangeNotifier.Create(Self);
{$IFDEF DELPHI6UP}
//  FNotifier.FComponentStyle := FNotifier.FComponentStyle + [ csSubComponent ];
{$ENDIF}
  FRoot := SRFDesktop;
  FLoadingRoot := False;
end;

procedure TacCustomShellTreeView.ClearItems;
var
  I: Integer;
begin
  Items.BeginUpdate;
  SkinData.BeginUpdate;
  try
    for I := 0 to Items.Count - 1 do begin
      if Assigned(Folders[i]) then Folders[I].Free;
      Items[I].Data := nil;
    end;
    Items.Clear;
  finally
  end;
  skinData.EndUpdate;
  Items.EndUpdate;
end;

procedure TacCustomShellTreeView.CreateWnd;
begin
  inherited CreateWnd;
  if (Items.Count > 0) then ClearItems;
//  if not Assigned(Images) then
  SetUseShellImages(FUseShellImages);
  { TODO : What is the Items.Count test for here? }
  if (not FLoadingRoot) {and (Items.Count = 0)} then
    CreateRoot;
end;

procedure TacCustomShellTreeView.DestroyWnd;
begin
  ClearItems;
  inherited DestroyWnd;
end;

procedure TacCustomShellTreeView.CommandCompleted(Verb: String; Succeeded: Boolean);
var
  Fldr : TacShellFolder;
begin
  if not Succeeded then Exit;
  if Assigned(Selected) then begin
    if SameText(Verb, SCmdVerbDelete) then begin
      Fldr := TacShellFolder(Selected.Data);
      if not FileExists(Fldr.PathName) then begin
        Selected.Data := nil;
        Selected.Delete;
        FreeAndNil(Fldr);
      end;
    end
    else if SameText(Verb, SCmdVerbPaste) then Refresh(Selected)
    else if SameText(Verb, SCmdVerbOpen) then SetCurrentDirectory(PChar(FSavePath));
  end;
end;

procedure TacCustomShellTreeView.ExecuteCommand(Verb: String; var Handled: Boolean);
var
  szPath: array[0..MAX_PATH] of char;
begin
  if SameText(Verb, SCmdVerbRename) and Assigned(Selected) then begin
    Selected.EditText;
    Handled := True;
  end
  else if SameText(Verb, SCmdVerbOpen) then begin
    GetCurrentDirectory(MAX_PATH, szPath);
    FSavePath := StrPas(szPath);
    StrPCopy(szPath, ExtractFilePath(TacShellFolder(Selected.Data).PathName));
    SetCurrentDirectory(szPath);
  end;
end;

function TreeSortFunc(Node1, Node2: TTreeNode; lParam: Integer): Integer; stdcall;
begin
  Result := SmallInt(TacShellFolder(Node1.Data).ParenTacShellFolder.CompareIDs(
       0, TacShellFolder(Node1.Data).RelativeID, TacShellFolder(Node2.Data).RelativeID));
end;

procedure TacCustomShellTreeView.InitNode(NewNode: TTreeNode; ID: PItemIDList; ParentNode: TTreeNode);
var
  CanAdd: Boolean;
  NewFolder: IShellFolder;
  AFolder: TacShellFolder;
begin
  AFolder := TacShellFolder(ParentNode.Data);
  NewFolder := GetIShellFolder(AFolder.ShellFolder, ID);
  NewNode.Data := TacShellFolder.Create(AFolder, ID, NewFolder);
  with TacShellFolder(NewNode.Data) do begin
{$IFDEF TNTUNICODE}
    TTntTreeNode(NewNode).Text := DisplayName(FShowExtension);
{$ELSE}
    NewNode.Text := DisplayName(FShowExtension);
{$ENDIF}    
    if FUseShellImages then begin
      NewNode.ImageIndex := GetShellImage(AbsoluteID, False, False);
      NewNode.SelectedIndex := GetShellImage(AbsoluteID, False, True);
    end;
    if NewNode.SelectedIndex = 0 then NewNode.SelectedIndex := NewNode.ImageIndex;
    NewNode.HasChildren := SubFolders;
    if fpShared in Properties then NewNode.OverlayIndex := 0;
    if (otNonFolders in ObjectTypes) and (ShellFolder <> nil) then
      NewNode.HasChildren := GetHasSubItems(ShellFolder, ObjectFlags(FObjectTypes));
  end;

  CanAdd := True;
  if Assigned(FOnAddFolder) then FOnAddFolder(Self, TacShellFolder(NewNode.Data), CanAdd);
  if not CanAdd then NewNode.Delete;
end;

{$IFDEF TNTUNICODE}
procedure TacCustomShellTreeView.PopulateNode(Node: TTntTreeNode);
{$ELSE}
procedure TacCustomShellTreeView.PopulateNode(Node: TTreeNode);
{$ENDIF}
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NewNode: TTreeNode;
  NumIDs: LongWord;
  SaveCursor: TCursor;
  HR: HResult;
begin
  SaveCursor := Screen.Cursor;
  Screen.Cursor := crHourglass;
  Items.BeginUpdate;
  try
    try
      HR := TacShellFolder(Node.Data).ShellFolder.EnumObjects(Application.Handle, ObjectFlags(FObjectTypes), EnumList);
      if HR <> 0 then Exit;
    except on E:Exception do end;

    while EnumList.Next(1, ID, NumIDs) = S_OK do begin
      NewNode := Items.AddChild(Node, '');
      InitNode(NewNode, ID, Node);
    end;

    Node.CustomSort(PFNTVCompare(@TreeSortFunc), 0);
  finally
    Items.EndUpdate;
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TacCustomShellTreeView.SetObjectTypes(Value: TacShellObjectTypes);
begin
  FObjectTypes := Value;
  RootChanged;
end;

procedure TacCustomShellTreeView.CreateRoot;
var
{$IFDEF TNTUNICODE}
  RootNode: TTntTreeNode;
{$ELSE}
  RootNode: TTreeNode;
{$ENDIF}
  ErrorMsg: string;
{$IFDEF DELPHI7UP}
  s: string;
{$ENDIF}
  function PathIsCSIDL(Value: string): Boolean;
  begin
    Result := GetEnumValue(TypeInfo(TacRootFolder), Value) >= 0;
  end;
begin
  if (csLoading in ComponentState) or (csDesigning in ComponentState) or DontFoldersGenerate then Exit;
  try
    FRootFolder := CreateRootFolder(FRootFolder, FOldRoot, FRoot);
    ErrorMsg := '';
  except
    on E : Exception do ErrorMsg := E.Message;
  end;

  if Assigned(FRootFolder) then begin
    FLoadingRoot := true;
    try
      if Items.Count > 0 then ClearItems;
      RootNode := Items.Add(nil, '');
      RootNode.Data := TacShellFolder.Create(nil, FRootFolder.AbsoluteID, FRootFolder.ShellFolder);

{$IFDEF DELPHI7UP}
      if PathIsCSIDL(fRoot) then RootNode.Text := GetDisplayName(DesktopShellFolder, TacShellFolder(RootNode.Data).AbsoluteID, SHGDN_NORMAL, FShowExtension) else begin
        s := AnsiReverseString(ExcludeTrailingPathDelimiter(FRoot));
        if Pos('\', s) > 0 then s := Copy(s, 1, Pos('\', s) - 1);
        s := AnsiReverseString(s);
        RootNode.Text := s;
      end;
{$ELSE}
      RootNode.Text := GetDisplayName(DesktopShellFolder, TacShellFolder(RootNode.Data).AbsoluteID, SHGDN_NORMAL, FShowExtension);
{$ENDIF}


      if FUseShellImages {and not Assigned(Images)} then begin
        RootNode.ImageIndex := GetShellImage(TacShellFolder(RootNode.Data).AbsoluteID, False, False);
        RootNode.SelectedIndex := GetShellImage(TacShellFolder(RootNode.Data).AbsoluteID, False, True);
      end;
      RootNode.HasChildren := TacShellFolder(RootNode.Data).SubFolders;

      RootNode.Expand(False);
      Selected := RootNode;

      if FNotifier <> nil then FNotifier.Change;
    finally
      FLoadingRoot := False;
    end;
  end;
  if ErrorMsg <> '' then Raise Exception.Create( ErrorMsg );
end;

function TacCustomShellTreeView.CanExpand(Node: TTreeNode): Boolean;
var
  Fldr: TacShellFolder;
begin
  Result := True;
  Fldr := TacShellFolder(Node.Data);
  if (csDesigning in ComponentState) and (Node.Level > 0) then Exit;
  if Assigned(OnExpanding) then OnExpanding(Self, Node, Result);
  if Result then
    if Fldr.IsFolder and (Node.HasChildren) and (Node.Count = 0) then
{$IFDEF TNTUNICODE}
      PopulateNode(TTntTreeNode(Node))
{$ELSE}
      PopulateNode(Node)
{$ENDIF}
    else if not Fldr.IsFolder then
    begin
      ShellExecute(Handle, nil, PChar(Fldr.PathName), nil,
        PChar(ExtractFilePath(Fldr.PathName)), 0);
    end;
  Node.HasChildren := Node.Count > 0;
end;

procedure TacCustomShellTreeView.Edit(const Item: TTVItem);
var
  S: acString;
{$IFDEF TNTUNICODE}
  Node: TTntTreeNode;
{$ELSE}
  Node: TTreeNode;
{$ENDIF}
begin
  with Item do if pszText <> nil then begin
{$IFDEF TNTUNICODE}
    s := TTVItemW(Item).pszText;
{$ELSE}
    s := Item.pszText;
{$ENDIF}
    Node := Items.GetNode(Item.hItem);
    if Assigned(OnEdited) then OnEdited(Self, Node, S);
    if ( Node <> nil ) and TacShellFolder(Node.Data).Rename(S) then begin
      Node.Text := S;
      if Node.Parent <> nil then Refresh(Node.Parent);
    end;
  end;
end;

procedure TacCustomShellTreeView.MouseUp(Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  //! Commenting this out fixes #107480, #109250
  (*
  if (Button = mbRight) and FAutoContext and (Selected <> nil) and (Selected.Data <> nil) then
    InvokeContextMenu(Self, SelectedFolder, X, Y)
  else
  (**)
  inherited MouseUp(Button, Shift, X, Y);
end;

function TacCustomShellTreeView.NodeFromRelativeID(ParentNode: TTreeNode; ID: PItemIDList): TTreeNode;
var
  HR: HResult;
begin
  Result := ParentNode.GetFirstChild;
  while (Result <> nil) do
  begin
    HR := TacShellFolder(ParentNode.Data).ShellFolder.CompareIDs(0, ID, TacShellFolder(Result.Data).RelativeID);
    if HR = 0 then Exit;
    Result := ParentNode.GetNextChild(Result);
  end;
end;

function TacCustomShellTreeView.NodeFromAbsoluteID(StartNode: TTreeNode; ID: PItemIDList): TTreeNode;
var
  HR: HResult;
begin
  Result := StartNode;
  while Result <> nil do
  begin
    HR := DesktopShellFolder.CompareIDs(0, ID, TacShellFolder(Result.Data).AbsoluteID);
    if HR = 0 then Exit;
    Result := Result.GetNext;
  end;
end;

procedure TacCustomShellTreeView.DefferedRefreshEvent;
begin
  PostMessage(Handle, WM_DEFFERED_REFRESH, 0, 0);
end;

procedure TacCustomShellTreeView.Delete(Node: TTreeNode);
begin
  if Assigned(Node.Data) then
  begin
    TacShellFolder(Node.Data).Free;
    Node.Data := nil;
  end;
  inherited Delete(Node);
end;

(*
procedure TacCustomShellTreeView.NodeDeleted(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) then
  begin
    TacShellFolder(Node.Data).Free;
    Node.Data := nil;
  end;
end;
(**)

procedure TacCustomShellTreeView.RootChanged;
begin
  if Updating then Exit;
  FUpdating := True;
  try
    CreateRoot;
    if Assigned(FComboBox) then FComboBox.SetRoot(FRoot);
    if Assigned(FListView) then FListView.SetRoot(FRoot);
  finally
    FUpdating := False;
  end;
end;

function TacCustomShellTreeView.FolderExists(FindID: PItemIDList; InNode: TTreeNode): TTreeNode;
var
  ALevel: Integer;
begin
  Result := nil;
  ALevel := InNode.Level;
  repeat
    if DesktopShellFolder.CompareIDs(
      0,
      FindID,
      TacShellFolder(InNode.Data).AbsoluteID) = 0 then
    begin
      Result := InNode;
      Exit;
    end else
      InNode := InNode.GetNext;
  until (InNode = nil) or (InNode.Level <= ALevel);
end;

procedure TacCustomShellTreeView.RefreshEvent;
begin
  if Assigned(Selected) then Refresh(Selected);
end;

procedure TacCustomShellTreeView.Refresh(Node: TTreeNode);
var
  NewNode, OldNode, Temp: TTreeNode;
  OldFolder, NewFolder: TacShellFolder;
  ThisLevel: Integer;
  SaveCursor: TCursor;
  TopID, SelID: PItemIDList;
  ParentFolder: TacShellFolder;
begin
  if TacShellFolder(Node.Data).ShellFolder = nil then Exit;
  SaveCursor := Screen.Cursor;
  ParentFolder := nil;
  //Need absolute PIDL to search for top item once tree is rebuilt.
  TopID := CopyPIDL(TacShellFolder(TopItem.Data).RelativeID);
  if TacShellFolder(TopItem.Data).Parent <> nil then TopID := ConcatPIDLs(TacShellFolder(TopItem.Data).Parent.AbsoluteID, TopID);
  //Same thing for SelID
  SelID := nil;
  if (Selected <> nil) and (Selected.Data <> nil) then begin
    SelID := CopyPIDL(TacShellFolder(Selected.Data).RelativeID);
    if TacShellFolder(Selected.Data).Parent <> nil then SelID := ConcatPIDLs(TacShellFolder(Selected.Data).Parent.AbsoluteID, SelID);
  end;

  Items.BeginUpdate;
  SkinData.BeginUpdate;
  try
    Screen.Cursor := crHourglass;
    OldFolder := Node.Data;
{$IFDEF TNTUNICODE}
    NewNode := Items.Insert(TTntTreeNode(Node), '');
{$ELSE}
    NewNode := Items.Insert(Node, '');
{$ENDIF}
    if Node.Parent <> nil then ParentFolder := TacShellFolder(Node.Parent.Data);
    NewNode.Data := TacShellFolder.Create(ParentFolder,
                                   OldFolder.RelativeID,
                                   OldFolder.ShellFolder);
{$IFDEF TNTUNICODE}
    PopulateNode(TTntTreeNode(NewNode));
{$ELSE}
    PopulateNode(NewNode);
{$ENDIF}
    with NewNode do begin
      NewFolder := Data;
      ImageIndex := GetShellImage(NewFolder.AbsoluteID, False, False);
      SelectedIndex := GetShellImage(NewFolder.AbsoluteID, False, True);
      HasChildren := NewFolder.SubFolders;
      Text := NewFolder.DisplayName(FShowExtension);
    end;

    ThisLevel := Node.Level;
    OldNode := Node;
    repeat
      Temp := FolderExists(TacShellFolder(OldNode.Data).AbsoluteID, NewNode);
      if (Temp <> nil) and OldNode.Expanded then Temp.Expand(False);
      OldNode := OldNode.GetNext;
    until (OldNode = nil) or (OldNode.Level = ThisLevel);

    if Assigned(Node.Data) then begin
      TacShellFolder(Node.Data).Free;
      Node.Data := nil;
    end;
    Node.Delete;
    if SelID <> nil then begin
      Temp := FolderExists(SelID, Items[0]);
{$IFDEF TNTUNICODE}
      Selected := TTntTreeNode(Temp);
{$ELSE}
      Selected := Temp;
{$ENDIF}
    end;
    Temp := FolderExists(TopID, Items[0]);
{$IFDEF TNTUNICODE}
    TopItem := TTntTreeNode(Temp);
{$ELSE}
    TopItem := Temp;
{$ENDIF}
  finally
    SkinData.EndUpdate;
    Items.EndUpdate;
    DisposePIDL(TopID);
    if SelID <> nil then DisposePIDL(SelID);
    Screen.Cursor := SaveCursor;
  end;
end;

procedure TacCustomShellTreeView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (AComponent = FComboBox) then FComboBox := nil else if (AComponent = FListView) then FListView := nil;
  end;
end;

procedure TacCustomShellTreeView.OnDefferedRefreshEvent(var Message: TMessage);
begin
  RefreshEvent;
end;

function TacCustomShellTreeView.CanChange(Node: TTreeNode): Boolean;
var
  Fldr: TacShellFolder;
  StayFresh: boolean;
begin
  Result := inherited CanChange(Node);
  if Result and (not Updating) and Assigned(Node) then
  begin
    Fldr := TacShellFolder(Node.Data);
    StayFresh := FAutoRefresh;
    AutoRefresh := False;
    if not Fldr.IsFolder then
      Fldr := Fldr.Parent;
    FUpdating := True;
    try
      if Assigned(FComboBox) then
        FComboBox.TreeUpdate(Fldr.AbsoluteID);
      if Assigned(FListView) then
        FListView.TreeUpdate(Fldr.AbsoluteID);
    finally
      FUpdating := False;
    end;
    FNodeToMonitor := Node;
    try
      AutoRefresh := StayFresh;
    finally
      FNodeToMonitor := nil;
    end;
  end;
end;

function TacCustomShellTreeView.GetFolder(Index: Integer): TacShellFolder;
begin
  Result := TacShellFolder(Items[Index].Data);
end;

function TacCustomShellTreeView.SelectedFolder: TacShellFolder;
begin
  Result := nil;
  if Selected <> nil then Result := TacShellFolder(Selected.Data);
end;

function TacCustomShellTreeView.GetPath: String;
begin
  if SelectedFolder <> nil then Result := SelectedFolder.PathName else Result := '';
end;

procedure TacCustomShellTreeView.SetPath(const Value: string);
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  Flags,
  NumChars: LongWord;
begin
  NumChars := Length(Value);
  Flags := 0;
  P := StringToOleStr(ExpandFilename(Value));
  try
    OLECheck(DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags));
    if not Updating then SetPathFromID(NewPIDL);
  except
    on EOleSysError do raise Exception.CreateFmt('Error Setting Path', [Value]);
  end;
end;

procedure TacCustomShellTreeView.SetPathFromID(ID: PItemIDList);
var
  I: Integer;
  Pidls: TList;
  Temp, Node: TTreeNode;
begin
  if Updating or (csLoading in ComponentState) or
       ((SelectedFolder <> nil) and SamePIDL(SelectedFolder.AbsoluteID, ID)) or
         (Items.Count < 1) then Exit;
  FUpdating := True;
  Items.BeginUpdate;
  SkinData.BeginUpdate;
  try
    Pidls := CreatePIDLList(ID);
    try
      Node := Items[0];
      for I := 0 to Pidls.Count - 1 do begin
        Temp := FolderExists(Pidls[I], Node);
        if Temp <> nil then begin
          Node := Temp;
          Node.Expand(False);
        end;
      end;
      Node := FolderExists(ID, Node);
{$IFDEF TNTUNICODE}
      Selected := TTntTreeNode(Node);
{$ELSE}
      Selected := Node;
{$ENDIF}
      if Assigned(Node) then begin
        if Assigned(FListView)
          then FListView.TreeUpdate(TacShellFolder(Node.Data).AbsoluteID);
        if Assigned(FComboBox)
          then FComboBox.TreeUpdate(TacShellFolder(Node.Data).AbsoluteID);
      end;
    finally
      DestroyPIDLList(Pidls);
    end;
  finally
    SkinData.EndUpdate;
    Items.EndUpdate;
    FUpdating := False;
  end;
end;

procedure TacCustomShellTreeView.SetRoot(const Value: TacRoot);
begin
  if not SameText(FRoot, Value) then begin
    FOldRoot := FRoot;
    FRoot := Value;
    if not Updating then RootChanged;
  end;
end;

procedure TacCustomShellTreeView.GetImageIndex(Node: TTreeNode);
begin
  if Assigned(Images) then inherited GetImageIndex(Node);
end;

procedure TacCustomShellTreeView.GetSelectedIndex(Node: TTreeNode);
begin
  if Assigned(Images) then inherited GetSelectedIndex(Node);
end;

procedure TacCustomShellTreeView.WndProc(var Message: TMessage);
var
  ImageListHandle: THandle;
begin
  case Message.Msg of
    WM_INITMENUPOPUP,
    WM_MENUCHAR,
    WM_MEASUREITEM:
      if Assigned(ICM2) then begin
        ICM2.HandleMenuMsg(Message.Msg, Message.wParam, Message.lParam);
        Message.Result := 0;
      end;

    TVM_SETIMAGELIST:
      if not FImageListChanging then begin
        FImageListChanging := True;
        try
         if not Assigned(Images) then
           if FUseShellImages then
             ImageListHandle := SysSmallImages
           else
             ImageListHandle := 0
         else
           ImageListHandle := Images.Handle;

           SendMessage(Self.Handle, TVM_SETIMAGELIST, TVSIL_NORMAL, ImageListHandle);
        finally
          FImageListChanging := False;
        end;
      end
      else inherited;
  else
    inherited WndProc(Message);
  end;
end;

procedure TacCustomShellTreeView.SetUseShellImages(const Value: Boolean);
var
  FSmallImages: Integer;
begin
  FUseShellImages := Value;
  if not Assigned(Images) then begin
    if FUseShellImages then begin
      FSmallImages := SysSmallImages;
      Images := SysSmallImageList;
    end
    else FSmallImages := 0
  end
  else FSmallImages := Images.Handle;
  SendMessage(Handle, TVM_SETIMAGELIST, TVSIL_NORMAL, FSmallImages);
end;

procedure TacCustomShellTreeView.WMDestroy(var Message: TWMDestroy);
begin
  if FRootFolder <> nil then FreeAndNil(FRootFolder);
  ClearItems;
  if UseShellImages and (SysSmallImageList <> nil) then Images := nil;
  inherited;
end;

procedure TacCustomShellTreeView.Loaded;
begin
  inherited Loaded;
  CreateRoot;
end;

procedure TacCustomShellTreeView.DoContextPopup(MousePos: TPoint;
  var Handled: Boolean);
begin
  if AutoContextMenus and not (Assigned(PopupMenu) and PopupMenu.AutoPopup) then
    InvokeContextMenu(Self, SelectedFolder, MousePos.X, MousePos.Y)
  else inherited;
end;

procedure TacCustomShellTreeView.SetComboBox(Value: TacCustomShellComboBox);
begin
  if Value = FComboBox then Exit;
  if Value <> nil then begin
    Value.Root := Root;
    Value.FTreeView := Self;
  end
  else if FComboBox <> nil then FComboBox.FTreeView := nil;

  if FComboBox <> nil then FComboBox.FreeNotification(Self);
  FComboBox := Value;
end;

procedure TacCustomShellTreeView.SetListView(const Value: TacCustomShellListView);
begin
  if Value = FListView then Exit;
  if Value <> nil then begin
    Value.Root := Root;
    Value.FTreeView := Self;
  end else
    if FListView <> nil then FListView.FTreeView := nil;

  if FListView <> nil then FListView.FreeNotification(Self);
  FListView := Value;
end;

procedure TacCustomShellTreeView.SetAutoRefresh(const Value: boolean);
begin
  FAutoRefresh := Value;
  if not (csLoading in ComponentState) and not (csDesigning in ComponentState) then begin
    if FAutoRefresh then begin
      if Assigned(FNotifier) then FreeAndNil(FNotifier);
      FNotifier := TacShellChangeNotifier.Create(Self);
{$IFDEF DELPHI6UP}
      FNotifier.FComponentStyle := FNotifier.FComponentStyle + [csSubComponent];
{$ENDIF}
      FNotifier.WatchSubTree := False;
      if Assigned(FNodeToMonitor)
        then FNotifier.Root := TacShellFolder(FNodeToMonitor.Data).PathName
        else FNotifier.Root := FRootFolder.PathName;
      FNotifier.OnChange := Self.DefferedRefreshEvent;
    end
    else if Assigned(FNotifier) then FreeAndNil(FNotifier);
  end;
end;

procedure TacCustomShellTreeView.WMNCPaint(var Message: TMessage);
begin
  if InAnimationProcess then Exit;
  inherited;
end;

function TacCustomShellTreeView.GetUpdating: boolean;
begin
  Result := FUpdating
end;

destructor TacCustomShellTreeView.Destroy;
begin
  if FRootFolder <> nil then FreeAndNil(FRootFolder);
  if Assigned(FNotifier) then FreeAndNil(FNotifier);
  inherited Destroy;
end;

{ TacCustomShellComboBox }

constructor TacCustomShellComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ExtUpdating := True;//False;
  FRootFolder := nil;
  FUpdating := False;
{$IFDEF DELPHI6UP}
  Style := csExDropDownList;
{$ENDIF}
  FObjectTypes := [otFolders];
  FRoot := SRFDesktop;
  FUseShellImages := True;
end;

procedure TacCustomShellComboBox.ClearItems;
var
  i: Integer;
begin
  ItemsEx.BeginUpdate;
  try
    for i := 0 to ItemsEx.Count - 1 do begin
{     if Assigned(Folders[i]) then begin
        Folders[i].Free;
        ItemsEx[i].Data := nil;
      end }
      if ItemsEx[i].Data <> nil then begin
        TacShellFolder(ItemsEx[i].Data).Free;
        ItemsEx[i].Data := nil
      end;
    end;
{$IFNDEF DELPHI6UP}
    Items.Clear;
{$ENDIF}
    ItemsEx.Clear;
  finally
    ItemsEx.EndUpdate;
  end;
end;

procedure TacCustomShellComboBox.CreateRoot;
var
  AFolder: TacShellFolder;
  Text: string;
  ImageIndex: integer;
begin
  if (csLoading in ComponentState) or (csDesigning in ComponentState) then Exit;
  ClearItems;
{$IFDEF DELPHI6UP}
  ItemsEx.BeginUpdate;
{$ENDIF}
  try
    if FRootFolder <> nil then FreeAndNil(FRootFolder);
    FRootFolder := CreateRootFolder(FRootFolder, FOldRoot, FRoot);
    AFolder := TacShellFolder.Create(nil, FRootFolder.AbsoluteID, FRootFolder.ShellFolder);

    Text := AFolder.DisplayName(seSystem); //! PathName;

    ImageIndex := GetShellImageIndex(AFolder);
    ItemsEx.AddItem(Text, ImageIndex, ImageIndex, -1, 0, AFolder);
{$IFNDEF DELPHI6UP}
    Items.Add(Text);
{$ENDIF}
    Init;
    ItemIndex := 0;
    if FUseShellImages then begin // Force image update
      SetUseShellImages(False);
      SetUseShellImages(True);
    end;
  finally
{$IFDEF DELPHI6UP}
    ItemsEx.EndUpdate;
{$ENDIF}
  end;
end;

procedure TacCustomShellComboBox.CreateWnd;
begin
  inherited CreateWnd;
  SetUseShellImages(FUseShellImages);
  if (ItemsEx.Count = 0) and not Updating then CreateRoot;
end;

procedure TacCustomShellComboBox.DestroyWnd;
begin
  ClearItems;
  inherited DestroyWnd;
end;

procedure TacCustomShellComboBox.SetObjectTypes(Value: TacShellObjectTypes);
begin
  FObjectTypes := Value;
  RootChanged;
end;

procedure TacCustomShellComboBox.TreeUpdate(NewPath: PItemIDList);
begin
  if Updating or ((ItemIndex > -1) and SamePIDL(Folders[ItemIndex].AbsoluteID, NewPath)) then Exit;
  FUpdating := True;
  try
    SetPathFromID(NewPath);
    if Assigned(OnChange) then OnChange(Self);
  finally
    FUpdating := False;
  end;
end;

procedure TacCustomShellComboBox.SetTreeView(Value: TacCustomShellTreeView);
begin
  if Value = FTreeView then Exit;
  if Value <> nil then begin
    Value.Root := Root;
    Value.FComboBox := Self;
  end
  else if FTreeView <> nil then FTreeView.FComboBox := nil;

  if FTreeView <> nil then FTreeView.FreeNotification(Self);
  FTreeView := Value;
end;

procedure TacCustomShellComboBox.SetListView(Value: TacCustomShellListView);
begin
  if Value = FListView then Exit;
  if Value <> nil then begin
    Value.Root := Root;
    Value.FComboBox := Self;
  end
  else if FListView <> nil then FListView.FComboBox := nil;

  if FListView <> nil then FListView.FreeNotification(Self);
  FListView := Value;
end;

procedure TacCustomShellComboBox.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (AComponent = FTreeView)
      then FTreeView := nil
      else if (AComponent = FListView)
        then FListView := nil
        else if (AComponent = FImageList) then FImageList := nil;
  end;
end;

function TacCustomShellComboBox.GetFolder(Index: Integer): TacShellFolder;
begin
  if Index > ItemsEx.Count - 1 then Index := ItemsEx.Count - 1;
  Result := TacShellFolder(ItemsEx[Index].Data);
end;

function TacCustomShellComboBox.InitItem(ParentFolder: TacShellFolder; ID: PItemIDList): TacShellFolder;
var
  SF: IShellFolder;
begin
  SF := GetIShellFolder(ParentFolder.ShellFolder, ID);
  Result := TacShellFolder.Create(ParentFolder, ID, SF);
end;

var
  CompareFolder: TacShellFolder = nil;

function ListSortFunc(Item1, Item2: Pointer): Integer;
const
  R: array[Boolean] of Byte = (0, 1);
begin
  Result := 0;
  if (Item1 = nil) or (Item2 = nil) then Exit;
  Result := R[TacShellFolder(Item2).IsFolder] - R[TacShellFolder(Item1).IsFolder];
  if (Result = 0) and (TacShellFolder(Item1).ParenTacShellFolder <> nil)
    then Result := Smallint(TacShellFolder(Item1).ParenTacShellFolder.CompareIDs(0, TacShellFolder(Item1).RelativeID, TacShellFolder(Item2).RelativeID));
end;

function ComboSortFunc(Item1, Item2: Pointer): Integer;
begin
  Result := 0;
  if CompareFolder = nil then Exit;
  Result := SmallInt(CompareFolder.ShellFolder.CompareIDs(0, PItemIDList(Item1), PItemIDList(Item2)));
end;

procedure TacCustomShellComboBox.AddItems(Index: Integer; ParentFolder: TacShellFolder);
var
  EnumList: IEnumIDList;
  ID: PItemIDList;
  ImageIndex : integer;
{$IFDEF DELPHI6UP}
  Item: TComboExItem;
{$ELSE}
  Item: TsComboItem;
{$ENDIF}
  NumIDs: integer;
  List: TList;
  ItemText: string;
  AFolder: TacShellFolder;
begin
  OLECheck(ParentFolder.ShellFolder.EnumObjects(0, ObjectFlags(FObjectTypes), EnumList));
  CompareFolder := ParentFolder;
  List := nil;
  ItemsEx.BeginUpdate;
  try
    List := TList.Create;
    while EnumList.Next(1, ID, LongWord(NumIDs)) = S_OK do
      List.Add(ID);
    List.Sort(ComboSortFunc);

    for NumIDs := 0 to List.Count - 1 do
    begin
      AFolder := InitItem(ParentFolder, List[NumIDs]);
      ItemText := AFolder.DisplayName(seSystem);
{$IFDEF DELPHI6UP}
      Item := ItemsEx.Insert(NumIDs + 1);
{$ELSE}
      Item := TsComboItem(ItemsEx.Insert(NumIDs + 1));
{$ENDIF}
      Item.Caption := ItemText;
      Item.Data := AFolder;
      Item.ImageIndex := GetShellImageIndex(AFolder);
      Item.SelectedImageIndex := Item.ImageIndex;
{$IFNDEF DELPHI6UP}
      Item.Indend := AFolder.Level;
      Items.Insert(Item.Index {+ Index!!}, Item.Caption);
{$ELSE}
      Item.Indent := AFolder.Level;
{$ENDIF}

      if Assigned(FOnGetImageIndex) and (Assigned(FImageList) or FUseShellImages) then begin
        ImageIndex := ItemsEx[NumIDs + 1].ImageIndex;
        FOnGetImageIndex(Self, NumIDs + 1, ImageIndex);
        ItemsEx[NumIDs + 1].ImageIndex := ImageIndex;
      end;
    end;
  finally
    CompareFolder := nil;
    List.Free;
    ItemsEx.EndUpdate;
  end;
end;

procedure TacCustomShellComboBox.Init;
var
  MyComputer: PItemIDList;
  Index: Integer;
begin
  //show desktop contents, expand My Computer if at desktop.
  //!!!otherwise expand the root.
  ItemsEx.BeginUpdate;
  try
    AddItems(0, FRootFolder);
    if Root = SRFDesktop then begin
      SHGetSpecialFolderLocation(0, CSIDL_DRIVES, MyComputer);
      Index := IndexFromID(MyComputer);
      if Index <> -1 then AddItems(Index, Folders[Index]);
    end;
  finally
    ItemsEx.EndUpdate;
  end;
end;

function TacCustomShellComboBox.IndexFromID(AbsoluteID: PItemIDList): Integer;
begin
  Result := ItemsEx.Count - 1;
  while Result >= 0 do begin
    if DesktopShellFolder.CompareIDs(0, AbsoluteID, Folders[Result].AbsoluteID) = 0 then Break;
    Dec(Result);
  end;
end;

procedure TacCustomShellComboBox.SetRoot(const Value: TacRoot);
begin
  if not SameText(FRoot, Value) then begin
    FOldRoot := FRoot;
    FRoot := Value;
    RootChanged;
  end;
end;

procedure TacCustomShellComboBox.RootChanged;
begin
  FUpdating := True;
  try
    ClearItems;
    CreateRoot;
    if Assigned(FTreeView) then FTreeView.SetRoot(FRoot);
    if Assigned(FListView) then FListView.SetRoot(FRoot);
  finally
    FUpdating := False;
  end;
end;

function TacCustomShellComboBox.GetPath: string;
var
  Folder : TacShellFolder;
begin
  Result := '';
  if ItemIndex > -1 then begin
    Folder := Folders[ItemIndex];
    if Assigned(Folder) then Result := NormalDir(Folder.PathName) else Result := '';  
  end;
end;

procedure TacCustomShellComboBox.SetPath(const Value: string);
var
  P: PWideChar;
  NewPIDL: PItemIDList;
  Flags,
  NumChars: LongWord;
  s : string;
begin
  NumChars := Length(Value);
  if NumChars = 1 then begin
    case Value[1] of
      '.' : s := GetAppPath
      else s := Value;
    end;
  end else s := Value;
  Flags := 0;
  P := StringToOleStr(ExpandFilename(s));
  try
    OLECheck(DesktopShellFolder.ParseDisplayName(0, nil, P, NumChars, NewPIDL, Flags));
    SetPathFromID(NewPIDL);
  except on EOleSysError do
    raise Exception.CreateFmt('Error setting path: "%s"', [s]);
  end;
end;

procedure TacCustomShellComboBox.SetPathFromID(ID: PItemIDList);
var
  Pidls: TList;
  I, Item, Temp: Integer;
  AFolder: TacShellFolder;
  RelID: PItemIDList;

  procedure InsertItemObject(Position: integer; Text: string; AFolder: TacShellFolder);
  var
{$IFDEF DELPHI6UP}
    Item : TComboExItem;
  begin
    Item := ItemsEx.Insert(Position);
    Item.Caption := Text;
    Item.Indent := AFolder.Level;
    Item.Data := AFolder;
    Item.ImageIndex := GetShellImageIndex(AFolder);
{$ELSE}
    Item : TsComboItem;
  begin
    Item := TsComboItem(ItemsEx.Insert(Position));
    Item.Caption := Text;
    Item.Indend := AFolder.Level;
    Item.Data := AFolder;
    if AFolder = nil then Item.Data := AFolder;
    Item.ImageIndex := GetShellImageIndex(AFolder);
    Items.Insert(Item.Index, Item.Caption);
{$ENDIF}
  end;


begin
  Item := -1;
  CreateRoot;

  ItemsEx.BeginUpdate;
  try
    Pidls := CreatePIDLList(ID);
    try
      I := Pidls.Count-1;
      while I >= 0 do
      begin
        Item := IndexFromID(Pidls[I]);
        if Item <> -1 then Break;
        Dec(I);
      end;

      if I < 0 then Exit;

      while I < Pidls.Count-1 do
      begin
        Inc(I);
        RelID := RelativeFromAbsolute(Pidls[I]);
        AFolder := InitItem(Folders[Item], RelID);
        InsertItemObject(Item+1, AFolder.DisplayName(seSystem), AFolder);
        Inc(Item);
      end;

      Temp := IndexFromID(ID);
      if Temp < 0 then
      begin
        RelID := RelativeFromAbsolute(ID);
        AFolder := InitItem(Folders[Item], RelID);
        Temp := Item + 1;
        InsertItemObject(Item+1, AFolder.DisplayName(seSystem), AFolder);
      end;
      ItemIndex := Temp;
    finally
      DestroyPIDLList(Pidls);
    end;
  finally
    ItemsEx.EndUpdate;
  end;
end;

function TacCustomShellComboBox.GetShellImageIndex(AFolder: TacShellFolder): integer;
begin
  if FUseShellImages then Result := GetShellImage(AFolder.AbsoluteID, False, False) else Result := -1;
end;

procedure TacCustomShellComboBox.SetUseShellImages(const Value: Boolean);
var
  ImageListHandle: THandle;
begin
  FUseShellImages := Value;
  if not Assigned(Images) then begin
    if FUseShellImages then begin
      ImageListHandle := SysSmallImages;
      Images := SysSmallImageList;
//      ImageList_GetIconSize(ImageListHandle, FImageWidth, FImageHeight);
    end
    else ImageListHandle := 0
  end
  else ImageListHandle := Images.Handle;
  SendMessage(Handle, CBEM_SETIMAGELIST, 0, ImageListHandle);

  if FUseShellImages and not Assigned(FImageList)
    then ImageList_GetIconSize(ImageListHandle, FImageWidth, FImageHeight)
    else
      if not Assigned(FImageList) then begin
        FImageWidth := 16;
        FImageHeight := 16;
      end
      else begin
        FImageWidth := FImageList.Width;
        FImageHeight := FImageList.Height;
      end;
end;

destructor TacCustomShellComboBox.Destroy;
var
  i : integer;
begin
  for i := 0 to ItemsEx.Count - 1 do begin
    if ItemsEx[i].Data <> nil then begin
      TacShellFolder(ItemsEx[i].Data).Free;
{$IFNDEF DELPHI6UP}
      ItemsEx[i].Data := nil
{$ENDIF}
    end;
  end;

//  ClearItems;

  if Assigned(FRootFolder) then FreeAndNil(FRootFolder);
  if UseShellImages and (SysSmallImageList <> nil) then Images := nil;
  inherited Destroy;
  if Assigned(FImageList) then FreeAndNil(FImageList);
end;

procedure TacCustomShellComboBox.Loaded;
begin
  inherited Loaded;
  if not Updating then CreateRoot;
  ExtUpdating := False;
end;

{$IFNDEF DELPHI6UP}
procedure TacCustomShellComboBox.WndProc(var Message: TMessage);
begin
  inherited WndProc(Message);
{  case Message.Msg of
    CM_SHOWINGCHANGED : begin
      if FImagesHandle <> 0 then ImageList_SetBkColor(FImagesHandle, ColorToRGB(Color));
    end;
  end;}
{  if Message.Msg = SM_ALPHACMD then case Message.WParamHi of
    AC_REFRESH : if FImagesHandle <> 0 then ImageList_SetBkColor(FImagesHandle, Color);
  end;}
end;

type
  TAccessItemUpdateCount = class(TsComboItems);
{$ENDIF}

procedure TacCustomShellComboBox.Change;
var
  Node : TacShellFolder;
begin
{$IFNDEF DELPHI6UP}
  if TAccessItemUpdateCount(ItemsEx).UpdateCount > 0 then Exit;
{$ENDIF}
  inherited Change;
  if (ItemIndex > -1) and (not Updating) and (not DroppedDown) then begin
    FUpdating := True;
    try
      Node := Folders[ItemIndex];
      if Assigned(Node) then begin
        if Assigned(FTreeView) then FTreeView.SetPathFromID(Node.AbsoluteID);
        if Assigned(FListView) then FListView.TreeUpdate(Node.AbsoluteID);
      end;
    finally
      FUpdating := False;
    end;
  end;
end;

procedure TacCustomShellComboBox.Click;
var
  Temp: PItemIDList;
begin
  FUpdating := True;
  try
    Temp := CopyPIDL(Folders[ItemIndex].AbsoluteID);
    //Folder will be destroyed when removing the lower level ShellFolders.
    try
      SetPathFromID(Temp);
      inherited;
    finally
     DisposePIDL(Temp);
    end;
  finally
    FUpdating := False;
  end;
end;

function TacCustomShellComboBox.GetUpdating: boolean;
begin
  Result := FUpdating or ExtUpdating
end;

{ TacCustomShellListView }

constructor TacCustomShellListView.Create(AOwner: TComponent);
var
  FileInfo: TSHFileInfo;
begin
  inherited Create(AOwner);
  FRootFolder := nil;
  Self.NewStyleItems := True;
  OwnerData := True;
  FSorted := True;
  FObjectTypes := [otFolders, otNonFolders];
  FAutoContext := True;
  FAutoNavigate := True;
  FAutoRefresh := False;
  FFolders := TList.Create;
  FTreeView := nil;
  FUpdating := False;
  FSettingRoot := False;
  FSmallImages := SHGetFileInfo('C:\', { Do not localize } 0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
  FLargeImages := SHGetFileInfo('C:\', { Do not localize } 0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_LARGEICON);
  FNotifier := nil;
  FShowExtension := (seSystem);
  FRoot := SRFDesktop;
  HideSelection := False;
end;

destructor TacCustomShellListView.Destroy;
begin
  if Assigned(FNotifier) then FreeAndNil(FNotifier);
  if FRootFolder <> nil then FreeAndNil(FRootFolder);
  ClearItems;
  FFolders.Free;
  inherited;
end;

procedure TacCustomShellListView.ClearItems;
var
  I: Integer;
begin
  if not (csDestroying in ComponentState) then Items.Clear;
  for I := 0 to FFolders.Count-1 do if Assigned(Folders[i]) then Folders[I].Free;
  FFolders.Clear;
end;

procedure TacCustomShellListView.CommandCompleted(Verb: String; Succeeded: Boolean);
begin
  if not Succeeded then Exit;
  if SameText(Verb, SCmdVerbDelete) or SameText(Verb, SCmdVerbPaste) then
    Refresh
  else if SameText(Verb, SCmdVerbOpen) then SetCurrentDirectory(PChar(FSavePath));
end;

procedure TacCustomShellListView.ExecuteCommand(Verb: String; var Handled: Boolean);
var
  szPath: array[0..MAX_PATH] of char;
begin
  if SameText(Verb, SCmdVerbRename) then begin
    EditText;
    Handled := True;
  end
  else if SameText(Verb, SCmdVerbOpen) then begin
    GetCurrentDirectory(MAX_PATH, szPath);
    FSavePath := StrPas(szPath);
    StrPCopy(szPath, ExtractFilePath(Folders[Selected.Index].PathName));
    SetCurrentDirectory(szPath);
  end;
end;

procedure TacCustomShellListView.CreateWnd;
begin
  inherited CreateWnd;
  if HandleAllocated then begin
    if FSmallImages <> 0 then SendMessage(Handle, LVM_SETIMAGELIST, LVSIL_SMALL, FSmallImages);
    if FLargeImages <> 0 then SendMessage(Handle, LVM_SETIMAGELIST, LVSIL_NORMAL, FLargeImages);
  end;
  CreateRoot;
  RootChanged;
end;

procedure TacCustomShellListView.DestroyWnd;
begin
  ClearItems;
  inherited DestroyWnd;
end;

procedure TacCustomShellListView.SetObjectTypes(Value: TacShellObjectTypes);
begin
  FObjectTypes := Value;
  if not (csLoading in ComponentState) then RootChanged;
end;

procedure TacCustomShellListView.RootChanged;
var
  StayFresh: boolean;
begin
  if Updating or (csLoading in ComponentState) then Exit;
  FUpdating := True;
  try
    StayFresh := FAutoRefresh;
    AutoRefresh := False;
    SynchPaths;
    Populate;
    if ViewStyle = vsReport then EnumColumns;
    AutoRefresh := StayFresh;
  finally
    FUpdating := False;
  end;
end;

procedure TacCustomShellListView.Populate;
var
  ID: PItemIDList;
  EnumList: IEnumIDList;
  NumIDs: LongWord;
  SaveCursor: TCursor;
  HR: HResult;
  CanAdd: Boolean;
  NewFolder: IShellFolder;
  Count: Integer;
  AFolder: TacShellFolder;
  s, sm : string;
  i, w : integer;
begin
  if (csLoading in ComponentState) and not HandleAllocated or DontFoldersGenerate then Exit;

  SkinData.BeginUpdate;
  Items.BeginUpdate;
  try
    ClearItems;
    Count := 0;
    SaveCursor := Screen.Cursor;
    try
      Screen.Cursor := crHourglass;
      HR := FRootFolder.ShellFolder.EnumObjects(Application.Handle, ObjectFlags(FObjectTypes), EnumList);
      if HR <> 0 then Exit;

      while EnumList.Next(1, ID, NumIDs) = S_OK do begin
        NewFolder := GetIShellFolder(FRootFolder.ShellFolder, ID);
        AFolder := TacShellFolder.Create(FRootFolder, ID, NewFolder);
        w := WordCount(FMask, [';']);
        if AFolder.IsFolder or (w = 0) then CanAdd := True else begin
          CanAdd := False;
          s := AFolder.DisplayName(seShow);
          for i := 1 to w do begin
            sm := ExtractWord(i, FMask, [';']);
            if G_ValidateWildText(s, sm) then begin
              CanAdd := True;
              Break
            end;
          end;
        end;
        if Assigned(FOnAddFolder) then FOnAddFolder(Self, AFolder, CanAdd);

        if CanAdd then begin
          Inc(Count);
          FFolders.Add(AFolder);
        end
        else AFolder.Free;
      end;
      Items.Count := Count;
      if FSorted then begin
        CompareFolder := FRootFolder;
        try
          FFolders.Sort(TListSortCompare(@ListSortFunc));
        finally
          CompareFolder := nil;
        end;
      end;
    finally
      Screen.Cursor := SaveCursor;
    end;
  finally
    SkinData.EndUpdate;
    Items.EndUpdate;
  end;
end;

procedure TacCustomShellListView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) then begin
    if (AComponent = FTreeView) then FTreeView := nil else if (AComponent = FComboBox) then FComboBox := nil;
  end;
end;

procedure TacCustomShellListView.DblClick;
begin
  if FAutoNavigate and (Selected <> nil) then
    with Folders[Selected.Index] do if IsFolder
      then SetPathFromID(AbsoluteID)
      else ShellExecute(Handle, nil, PChar(PathName), nil, PChar(ExtractFilePath(PathName)), SW_SHOW);
  inherited DblClick;
end;

procedure TacCustomShellListView.EditText;
begin
  if Selected <> nil then ListView_EditLabel(Handle, Selected.Index);
end;

procedure TacCustomShellListView.Edit(const Item: TLVItem);
var
  S: string;
begin
  with Item do begin
    if iItem >= FFolders.Count then Exit;
    if pszText <> nil then begin
      S := pszText;
      TacShellFolder(FFolders[iItem]).Rename(S);
      ListView_RedrawItems(Handle, iItem, iItem);
    end;
  end;
end;

procedure TacCustomShellListView.SetAutoRefresh(const Value: Boolean);
begin
  FAutoRefresh := Value;
  if not (csLoading in ComponentState) and Assigned(FRootFolder) and not (csDesigning in ComponentState) then begin
    if FAutoRefresh then begin
      if Assigned(FNotifier) then FreeAndNil(FNotifier);
      FNotifier := TacShellChangeNotifier.Create(Self);
{$IFDEF DELPHI6UP}
      FNotifier.FComponentStyle := FNotifier.FComponentStyle + [csSubComponent];
{$ENDIF}
      FNotifier.WatchSubTree := False;
      FNotifier.Root := FRootFolder.PathName;
      FNotifier.OnChange := Self.Refresh;
    end
    else if Assigned(FNotifier) then FreeAndNil(FNotifier);
  end;
end;

procedure TacCustomShellListView.SetRoot(const Value: TacRoot);
begin
  if not SameText(Value, FRoot) then begin
    FOldRoot := FRoot;
    FRoot := Value;
    CreateRoot;
    FSettingRoot := True;
    if Root <> FOldRoot // If root is really changed
      then RootChanged;
  end;
end;

function TacCustomShellListView.SelectedFolder: TacShellFolder;
begin
  Result := nil;
  if Selected <> nil then Result := Folders[Selected.Index];
end;

function TacCustomShellListView.OwnerDataFetch(Item: TListItem; Request: TItemRequest): Boolean;
var
  AFolder: TacShellFolder;
  J: integer;
begin
  Result := True;
  AFolder := Folders[Item.Index];
  if not Assigned(AFolder) then exit;

  if (Item.Index > FFolders.Count - 1) or (Item.Index < 0) then Exit;
//  if irText in Request then // Items may be empty if not commented
  Item.Caption := AFolder.DisplayName(FShowExtension);
  if irImage in Request then Item.ImageIndex := AFolder.ImageIndex(ViewStyle = vsIcon);

  if ViewStyle <> vsReport then Exit;

  //PIDL := AFolder.FPIDL;
  AFolder.LoadColumnDetails(FRootFolder, Self.Handle, Columns.Count);
  for J := 1 to Columns.Count - 1 do Item.SubItems.Add(AFolder.Details[J]);
end;

function TacCustomShellListView.GetFolder(Index: Integer): TacShellFolder;
begin
  Result := TacShellFolder(FFolders[Index]);
end;

function TacCustomShellListView.OwnerDataFind(Find: TItemFind;
  const FindString: acString; const FindPosition: TPoint; FindData: Pointer;
  StartIndex: Integer; Direction: TSearchDirection; Wrap: Boolean): Integer;
var
  I: Integer;
  Found: Boolean;
//OnDataFind gets called in response to calls to FindCaption, FindData,
//GetNearestItem, etc. It also gets called for each keystroke sent to the
//ListView (for incremental searching)
begin
  Result := -1;
  I := StartIndex;
  if (Find = ifExactString) or (Find = ifPartialString) then begin
    repeat
      if (I = FFolders.Count-1) then if Wrap then I := 0 else Exit;
      Found := Pos(UpperCase(FindString), UpperCase(Folders[I].DisplayName(FShowExtension))) = 1;
      Inc(I);
    until Found or (I = StartIndex);
    if Found then Result := I-1;
  end;
end;

procedure TacCustomShellListView.SetSorted(const Value: Boolean);
begin
  if FSorted <> Value then begin
    FSorted := Value;
    Populate;
  end;
end;

procedure TacCustomShellListView.Loaded;
begin
  inherited Loaded;
  if csLoading in ComponentState then inherited Loaded;
  SetAutoRefresh(FAutoRefresh);
end;

procedure TacCustomShellListView.DoContextPopup(MousePos: TPoint; var Handled: Boolean);
begin
  if FAutoContext and (SelectedFolder <> nil) then begin
    InvokeContextMenu(Self, SelectedFolder, MousePos.X, MousePos.Y);
    Handled := True;
  end
  else inherited;
end;

procedure TacCustomShellListView.Back;
var
  RootPIDL: PItemIDList;
begin
  RootPIDL := CopyPIDL(FRootFolder.AbsoluteID);
  try
    StripLastID(RootPIDL);
    SetPathFromID(RootPIDL);
  finally
    DisposePIDL(RootPIDL);
  end;
end;

procedure TacCustomShellListView.EnumColumns;
var
  ColNames: TacStringList;
  Col: Integer;

  function AddColumn(SD: TShellDetails) : boolean;
  var
    PIDL: PItemIDList;
    ColName: acString;
    function ColumnIsUnique(const Name: string): boolean;
    var
      i : integer;
    begin
      for i := 0 to ColNames.Count - 1 do
        if SameText(ColNames[i], Name) then begin
          Result := False;
          exit;
        end;
      Result := True;
    end;
  begin
    PIDL := nil;
    ColName := StrRetToString(PIDL, SD.Str);
    if ColName <> '' then begin
      Result := ColumnIsUnique(ColName);
      if Result then
        with Columns.Add do begin
          Caption := ColName;
          case SD.fmt of
            LVCFMT_CENTER: Alignment := taCenter;
            LVCFMT_LEFT: Alignment := taLeftJustify;
            LVCFMT_RIGHT: Alignment := taRightJustify;
          end;
          Width := SD.cxChar * Canvas.TextWidth('X');
          ColNames.Add(ColName);
        end;
    end
    else Result := True;
  end;

  procedure AddDefaultColumn(const ACaption: string; const AAlignment: TAlignment; AWidth: integer);
  begin
    with Columns.Add do begin
      Caption := ACaption;
      Alignment := AAlignment;
      Width := AWidth * Canvas.TextWidth('X');
    end;
  end;

  procedure AddDefaultColumns(const ColCount: integer = 1);
  begin
    if ColCount > 0 then AddDefaultColumn('Name', taLeftJustify, 25);
    if ColCount > 1 then AddDefaultColumn('Size', taRightJustify, 10);
    if ColCount > 2 then AddDefaultColumn('Type', taLeftJustify, 10);
    if ColCount > 3 then AddDefaultColumn('Modified', taLeftJustify, 14);
  end;

var
  SD: TShellDetails;
  PIDL: PItemIDList;
  SF2: IShellFolder2;
  ISD: IShellDetails;
  ColFlags: LongWord;
  Default: Boolean;
begin
  if (not Assigned(FRootFolder)) or (not Assigned(FRootFolder.ShellFolder)) then Exit;
  ColNames := TacStringList.Create;
  try
    Columns.BeginUpdate;
    SendMessage(Handle, WM_SETREDRAW, 0, 0);
    try
      Columns.Clear;
      Col := 0;
      PIDL := nil;
      Default := False;
      FillChar(SD, SizeOf(SD), 0);

      FRootFolder.ViewHandle := Self.Handle;
      SF2 := FRootFolder.ShellFolder2;
      if Assigned(SF2) then { Have IShellFolder2 interface } begin
        while SF2.GetDetailsOf(PIDL, Col, SD) = S_OK do begin
          SF2.GetDefaultColumnState(Col, ColFlags);
          Default := Default or Boolean(ColFlags and $00000010);
          if Default and not Boolean(ColFlags and $00000010) then Exit;
          AddColumn(SD);
          Inc(Col);
        end;
      end
      else begin
        ISD := FRootFolder.ShellDetails;
        if Assigned(ISD) then begin
          while (ISD.GetDetailsOf(nil, Col, SD) = S_OK) do begin
            if (AddColumn(SD)) then Inc(Col) else Break;
          end;
        end
        else begin
          if (fpFileSystem in FRootFolder.Properties) then AddDefaultColumns(4) else AddDefaultColumns(1);
        end;
      end;

    finally
      SendMessage(Handle, WM_SETREDRAW, 1, 0);
      Columns.EndUpdate;
    end;
  finally
    ColNames.Free;
    if SkinData.Skinned then UpdateScrolls(ListSW, True);
  end;
end;

procedure TacCustomShellListView.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if FAutoNavigate then case Key of
    VK_RETURN: if ssAlt in Shift then begin
      DoContextMenuVerb(SelectedFolder, cmvProperties);
      Key := 0;
    end
    else if (SelectedFolder <> nil) then
      if SelectedFolder.IsFolder then SetPathFromID(SelectedFolder.AbsoluteID) else SelectedFolder.ExecuteDefault;
    VK_BACK: if not IsEditing then Back;
    VK_F5: Refresh;
  end;
  inherited;
end;

procedure TacCustomShellListView.SetTreeView(Value: TacCustomShellTreeView);
begin
  if Value = FTreeView then Exit;
  if Value <> nil then begin
    Value.Root := Root;
    Value.FListView := Self;
  end
  else if FTreeView <> nil then FTreeView.FListView := nil;

  if FTreeView <> nil then FTreeView.FreeNotification(Self);
  FTreeView := Value;
end;

procedure TacCustomShellListView.SetComboBox(Value: TacCustomShellComboBox);
begin
  if Value = FComboBox then Exit;
  if Value <> nil then begin
    Value.Root := Root;
    Value.FListView := Self;
  end
  else if FComboBox <> nil then FComboBox.FListView := nil;

  if FComboBox <> nil then FComboBox.FreeNotification(Self);
  FComboBox := Value;
end;

procedure TacCustomShellListView.TreeUpdate(NewRoot: PItemIDList);
begin
  if Updating or (Assigned(FRootFolder) and SamePIDL(FRootFolder.AbsoluteID, NewRoot)) then Exit;
  SetPathFromID(NewRoot);
end;

procedure TacCustomShellListView.WndProc(var Message: TMessage);
begin
{$IFDEF LOGGED}
//  AddToLog(Message);
{$ENDIF}
  //to handle submenus of context menus.
  with Message do
    if ((Msg = WM_INITMENUPOPUP) or (Msg = WM_DRAWITEM) or (Msg = WM_MENUCHAR) or (Msg = WM_MEASUREITEM)) and Assigned(ICM2) then begin
      ICM2.HandleMenuMsg(Msg, wParam, lParam);
      Result := 0;
    end;
  case Message.Msg of
    WM_DRAWITEM : if Updating then Exit;
  end;
  inherited;
  case Message.Msg of
    WM_STYLECHANGED : if not (csReadingState in ControlState) then begin
      if (ViewStyle = vsReport) and not (csLoading in ComponentState) then EnumColumns;
    end;
  end;
end;

procedure TacCustomShellListView.Refresh;
var
  SelectedIndex: Integer;
  RootPIDL: PItemIDList;
begin
  SelectedIndex := -1;
  if Selected <> nil then SelectedIndex := Selected.Index;
  Selected := nil;
  RootPIDL := CopyPIDL(FRootFolder.AbsoluteID);
  try
    FreeAndNil(FRootFolder);
    SetPathFromID(RootPIDL);
  finally
    DisposePIDL(RootPIDL);
  end;
  if (SelectedIndex > -1) and (SelectedIndex < Items.Count - 1) then Selected := Items[SelectedIndex];
end;

procedure TacCustomShellListView.SetPathFromID(ID: PItemIDList);
begin
  if Updating then Exit;
  if Assigned(FRootFolder) then begin
    if SamePIDL(FRootFolder.AbsoluteID, ID) then Exit else FRootFolder.Free;
  end;

  FSettingRoot := False;
  FRootFolder := CreateRootFromPIDL(ID);
  RootChanged;
end;

procedure TacCustomShellListView.CreateRoot;
begin
  FRootFolder := CreateRootFolder(FRootFolder, FOldRoot, FRoot);
end;

procedure TacCustomShellListView.SynchPaths;
begin
  try
    if FSettingRoot then begin
      if Assigned(FTreeView) then FTreeView.SetRoot(FRoot);
      if Assigned(FComboBox) then FComboBox.SetRoot(FRoot);
    end
    else begin
      if Assigned(FTreeView) then FTreeView.SetPathFromID(FRootFolder.AbsoluteID);
      if Assigned(FComboBox) then begin
        FComboBox.TreeUpdate(FRootFolder.AbsoluteID);
      end;
    end;
  finally
    FSettingRoot := False;
  end;
end;

procedure TacCustomShellListView.SetMask(const Value: string);
begin
  if FMask <> Value then begin
    FMask := Value;
    if not (csLoading in ComponentState) then Populate
  end;
end;

function TacCustomShellListView.GetUpdating: boolean;
begin
  Result := FUpdating
end;

procedure TacCustomShellListView.MakeNewFolder;
var
  NewDir, DispName, CurDir: string;
  i: integer;
  OldRefresh : boolean;
begin
  OldRefresh := AutoRefresh;
  AutoRefresh := False;
  Perform(WM_SETREDRAW, 0, 0);
  CurDir := NormalDir(RootFolder.PathName);

  DispName := 'New Folder';
  NewDir := CurDir + DispName;
  if DirectoryExists(NewDir) then begin
    i := 1;
    Repeat inc(i);
    until not DirectoryExists(CurDir + DispName + '(' + IntToStr(i) + ')');
    DispName := DispName + '(' + IntToStr(i) + ')';
    NewDir := CurDir + DispName;
  end;
  CreateDir(NewDir);
  Refresh;
  SetFocus;
  for i := 0 to Items.Count - 1 do if Folders[i].DisplayName(seShow) = DispName then begin
    Selected := Items[i];
    Break;
  end;
  Perform(WM_SETREDRAW, 1, 0);
  if CanEdit(Selected) then Selected.EditCaption;

  AutoRefresh := OldRefresh;
end;

procedure TacCustomShellListView.InitControl(const Skinned: boolean);
begin
//  No events changing
end;

{ TsDlgShellListView }

procedure TsDlgShellListView.DblClick;
begin
  OnDblClick(Self);
end;

function G_ValidateWildText(const S, Mask: string; MaskChar, WildCard: Char): Boolean;
const
  ToUpperChars: array[0..255] of Char =
    (#$00,#$01,#$02,#$03,#$04,#$05,#$06,#$07,#$08,#$09,#$0A,#$0B,#$0C,#$0D,#$0E,#$0F,
     #$10,#$11,#$12,#$13,#$14,#$15,#$16,#$17,#$18,#$19,#$1A,#$1B,#$1C,#$1D,#$1E,#$1F,
     #$20,#$21,#$22,#$23,#$24,#$25,#$26,#$27,#$28,#$29,#$2A,#$2B,#$2C,#$2D,#$2E,#$2F,
     #$30,#$31,#$32,#$33,#$34,#$35,#$36,#$37,#$38,#$39,#$3A,#$3B,#$3C,#$3D,#$3E,#$3F,
     #$40,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$5B,#$5C,#$5D,#$5E,#$5F,
     #$60,#$41,#$42,#$43,#$44,#$45,#$46,#$47,#$48,#$49,#$4A,#$4B,#$4C,#$4D,#$4E,#$4F,
     #$50,#$51,#$52,#$53,#$54,#$55,#$56,#$57,#$58,#$59,#$5A,#$7B,#$7C,#$7D,#$7E,#$7F,
     #$80,#$81,#$82,#$81,#$84,#$85,#$86,#$87,#$88,#$89,#$8A,#$8B,#$8C,#$8D,#$8E,#$8F,
     #$80,#$91,#$92,#$93,#$94,#$95,#$96,#$97,#$98,#$99,#$8A,#$9B,#$8C,#$8D,#$8E,#$8F,
     #$A0,#$A1,#$A1,#$A3,#$A4,#$A5,#$A6,#$A7,#$A8,#$A9,#$AA,#$AB,#$AC,#$AD,#$AE,#$AF,
     #$B0,#$B1,#$B2,#$B2,#$A5,#$B5,#$B6,#$B7,#$A8,#$B9,#$AA,#$BB,#$A3,#$BD,#$BD,#$AF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF,
     #$C0,#$C1,#$C2,#$C3,#$C4,#$C5,#$C6,#$C7,#$C8,#$C9,#$CA,#$CB,#$CC,#$CD,#$CE,#$CF,
     #$D0,#$D1,#$D2,#$D3,#$D4,#$D5,#$D6,#$D7,#$D8,#$D9,#$DA,#$DB,#$DC,#$DD,#$DE,#$DF);
label
  99;
var
  L, X, X0, Q: Integer;
  P, P1, B: PChar;
  C: Char;
begin
  X := G_CharPos(WildCard, Mask);
  Result := False;
  if X = 0 then begin
    L := Length(Mask);
    if (L > 0) and (L = Length(S)) then begin
      P := Pointer(S);
      B := Pointer(Mask);
      repeat
        C := B^;
        if (C <> MaskChar) and (C <> P^) and (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then Exit;
        Dec(L);
        Inc(B);
        Inc(P);
      until L = 0;
      Result := True;
    end;
    Exit;
  end;
  L := Length(S);
  P := Pointer(S);
  B := Pointer(Mask);
  Q := X - 1;
  if L < Q then
    Exit;
  while Q > 0 do begin
    C := B^;
    if (C <> MaskChar) and (C <> P^) and (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then Exit;
    Dec(Q);
    Inc(B);
    Inc(P);
  end;
  Dec(L, X - 1);
  repeat
    X0 := X;
    P1 := P;
    while Mask[X0] = WildCard do Inc(X0);
    X := G_CharPos(WildCard, Mask, X0);
    if X = 0 then Break;
  99:
    P := P1;
    B := @Mask[X0];
    Q := X - X0;
    if L < Q then Exit;
    while Q > 0 do begin
      C := B^;
      if (C <> MaskChar) and (C <> P^) and (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then begin
        Inc(P1);
        Dec(L);
        goto 99;
      end;
      Dec(Q);
      Inc(B);
      Inc(P);
    end;
    Dec(L, X - X0);
  until False;
  X := Length(Mask);
  if L >= X - X0 + 1 then begin
    P := Pointer(S);
    Inc(P, Length(S) - 1);
    while X >= X0 do begin
      C := Mask[X];
      if (C <> MaskChar) and (C <> P^) and (ToUpperChars[Byte(C)] <> ToUpperChars[Byte(P^)]) then Exit;
      Dec(X);
      Dec(P);
    end;
    Result := True;
  end;
end;

function G_CharPos(C: Char; const S: string; StartPos: Integer): Integer;
asm
        TEST    EDX,EDX
        JE      @@qt
{$IFDEF WIN64}
        PUSH    RDI
{$ELSE}
        PUSH    EDI
{$ENDIF}
        MOV     EDI,EDX
        LEA     EDX,[ECX-1]
        MOV     ECX,[EDI-4]
        SUB     ECX,EDX
        JLE     @@m1
{$IFDEF WIN64}
        PUSH    RDI
{$ELSE}
        PUSH    EDI
{$ENDIF}
        ADD     EDI,EDX
{$IFDEF WIN64}
        POP     RDX
{$ELSE}
        POP     EDX
{$ENDIF}
        REPNE   SCASB
        JNE     @@m1
        MOV     EAX,EDI
        SUB     EAX,EDX
{$IFDEF WIN64}
        POP     RDI
{$ELSE}
        POP     EDI
{$ENDIF}
        RET
{$IFDEF WIN64}
@@m1:   POP     RDI
{$ELSE}
@@m1:   POP     EDI
{$ENDIF}
@@qt:   XOR     EAX,EAX
end;

procedure InitSystemImageList;
var
  FileInfo: TSHFileInfo;
begin
  FillChar(FileInfo, SizeOf(FileInfo), 0);
  SysSmallImages := SHGetFileInfo('C:\', 0, FileInfo, SizeOf(FileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
//  if not (csDesigning in .ComponentState) then begin
    if (SysSmallImages <> 0) and (SysSmallImageList = nil) then begin
      SysSmallImageList := TsAlphaImageList.Create(nil);
      SysSmallImageList.Handle := SysSmallImages;
      SysSmallImageList.ShareImages := True;
      SysSmallImageList.AcEndUpdate(True);
      ImageList_SetBkColor(SysSmallImageList.Handle, CLR_NONE);
//      ImageList_SetBkColor(SysSmallImages, clNone);
    end;
//  end;
//  if Result <> 0 then SendMessage(Control.Handle, CBEM_SETIMAGELIST, 0, Result);
end;


initialization
  InitSystemImageList;
  CreateDesktopFolder;
  InitializeCriticalSection(CS);
  OleInitialize(nil);
//  with TacCustomShellComboBox.Create(Application) do SendMessage(Handle, CBEM_SETIMAGELIST, 0, SysSmallImages);

finalization
  if Assigned(DesktopFolder) then FreeAndNil(DesktopFolder);
  DeleteCriticalSection(CS);
  OleUninitialize;
  if Assigned(SysSmallImageList) then FreeAndNil(SysSmallImageList);

end.
