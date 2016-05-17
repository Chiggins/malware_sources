//[START OF KOL.pas]
{****************************************************************
                                                                    d       d
        KKKKK    KKKKK    OOOOOOOOO    LLLLL                        d       d
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLL                        d       d
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL          aaaa          d       d
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL              a         d       d
        KKKKKKKKKK      OOOOO   OOOOO  LLLLL              a         d       d
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL          aaaaa    dddddd  dddddd
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL         a     a  d     d d     d
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLLLLLLLLLL a     a  d     d d     d
        KKKKK    KKKKK    OOOOOOOOO    LLLLLLLLLLLLL  aaaaa aa dddddd  dddddd

  Key Objects Library (C) 2000 by Kladov Vladimir.

//[VERSION]
****************************************************************
* VERSION 3.05+
****************************************************************
//[END OF VERSION]

The only reason why this part of KOL separated into another unit is that
Delphi has a restriction to DCU size exceeding which it is failed to debug
it normally and in attempt to execute code step by step an internal error
is occur which stops Delphi from working at all.

Version indicated above is a version of KOL, having place when KOLadd.pas was
modified last time, this is not a version of KOLadd itself.
}

//[UNIT DEFINES]
{$I KOLDEF.inc}
{$IFDEF EXTERNAL_KOLDEFS}
  {$INCLUDE PROJECT_KOL_DEFS.INC}
{$ENDIF}
{$IFDEF EXTERNAL_DEFINES}
        {$INCLUDE EXTERNAL_DEFINES.INC}
{$ENDIF EXTERNAL_DEFINES}
{$IFDEF INPACKAGE}
  {$IFDEF _D2009orHigher}
      {$DEFINE UNICODE_CTRLS}
  {$ENDIF}
{$ENDIF}

unit KOLadd;

{
  Define symbol TREE_NONAME to disallow using Name in TTree object.
  Define symbol TREE_WIDE to use WideString for Name in TTree object.
}

interface

{$I KOLDEF.INC}

uses Windows, Messages, KOL;

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T L i s t E x                               |
|                                                                              |
(------------------------------------------------------------------------------}
type
  PListEx = ^TListEx;
  TListEx = object( TObj )
  {* Extended list, with Objects[ ] property. Created calling NewListEx function. }
  protected
    fList: PList;
    fObjects: PList;
    function GetEx(Idx: Integer): Pointer;
    procedure PutEx(Idx: Integer; const Value: Pointer);
    function GetCount: Integer;
    function GetAddBy: Integer;
    procedure Set_AddBy(const Value: Integer);
  public
    destructor Destroy; virtual;
    {* }
    property AddBy: Integer read GetAddBy write Set_AddBy;
    {* }
    property Items[ Idx: Integer ]: Pointer read GetEx write PutEx;
    {* }
    property Count: Integer read GetCount;
    {* }
    procedure Clear;
    {* }
    procedure Add( Value: Pointer );
    {* }
    procedure AddObj( Value, Obj: Pointer );
    {* }
    procedure Insert( Idx: Integer; Value: Pointer );
    {* }
    procedure InsertObj( Idx: Integer; Value, Obj: Pointer );
    {* }
    procedure Delete( Idx: Integer );
    {* }
    procedure DeleteRange( Idx, Len: Integer );
    {* }
    function IndexOf( Value: Pointer ): Integer;
    {* }
    function IndexOfObj( Obj: Pointer ): Integer;
    {* }
    procedure Swap( Idx1, Idx2: Integer );
    {* }
    procedure MoveItem( OldIdx, NewIdx: Integer );
    {* }
    property ItemsList: PList read fList;
    {* }
    property ObjList: PList read fObjects;
    {* }
    function Last: Pointer;
    {* }
    function LastObj: Pointer;
    {* }
  end;
//[END OF TListEx DEFINITION]

//[NewListEx DECLARATION]
function NewListEx: PListEx;
{* Creates extended list. }

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T B i t s                                   |
|                                                                              |
(------------------------------------------------------------------------------}
type
  PBits = ^TBits;
  TBits = object( TObj )
  {* Variable-length bits array object. Created using function NewBits. See also
     |<a href="kol_pas.htm#Small bit arrays (max 32 bits in array)">
     Small bit arrays (max 32 bits in array)
     |</a>. }
  protected
    fList: PList;
    fCount: Integer;
    function GetBit(Idx: Integer): Boolean;
    procedure SetBit(Idx: Integer; const Value: Boolean);
    function GetCapacity: Integer;
    function GetSize: Integer;
    procedure SetCapacity(const Value: Integer);
  public
    destructor Destroy; virtual;
    {* }
    property Bits[ Idx: Integer ]: Boolean read GetBit write SetBit;
    {* }
    property Size: Integer read GetSize;
    {* Size in bytes of the array. To get know number of bits, use property Count. }
    property Count: Integer read fCount;
    {* Number of bits an the array. }
    property Capacity: Integer read GetCapacity write SetCapacity;
    {* Number of bytes allocated. Can be set before assigning bit values
       to improve performance (minimizing amount of memory allocation
       operations).  }
    function Copy( From, BitsCount: Integer ): PBits;
    {* Use this property to get a sub-range of bits starting from given bit
       and of BitsCount bits count. }
    function IndexOf( Value: Boolean ): Integer;
    {* Returns index of first bit with given value (True or False). }
    function OpenBit: Integer;
    {* Returns index of the first bit not set to true. }
    procedure Clear;
    {* Clears bits array. Count, Size and Capacity become 0. }
    function LoadFromStream( strm: PStream ): Integer;
    {* Loads bits from the stream. Data should be stored in the stream
       earlier using SaveToStream method. While loading, previous bits
       data are discarded and replaced with new one totally. In part,
       Count of bits also is changed. Count of bytes read from the stream
       while loading data is returned. }
    function SaveToStream( strm: PStream ): Integer;
    {* Saves entire array of bits to the stream. First, Count of bits
       in the array is saved, then all bytes containing bits data. }
    function Range( Idx, N: Integer ): PBits;
    {* Creates and returns new TBits object instance containing N bits
       starting from index Idx. If you call this method, you are responsible
       for destroying returned object when it become not neccessary. }
    procedure AssignBits( ToIdx: Integer; FromBits: PBits; FromIdx, N: Integer );
    {* Assigns bits from another bits array object. N bits are assigned
       starting at index ToIdx. }
    procedure InstallBits( FromIdx, N: Integer; Value: Boolean );
    {* Sets new Value for all bits in range [ FromIdx, FromIdx+Count-1 ]. }
    function CountTrueBits: Integer;
    {* Returns count of bits equal to TRUE. }
  end;
//[END OF TBits DEFINITION]

//[NewBits DECLARATION]
function NewBits: PBits;
{* Creates variable-length bits array object. }

{------------------------------------------------------------------------------)
|                                                                              |
|                         T F a s t S t r L i s t                              |
|                                                                              |
(------------------------------------------------------------------------------}
type
  PFastStrListEx = ^TFastStrListEx;
  TFastStrListEx = object( TObj )
  private
    function GetItemLen(Idx: Integer): Integer;
    function GetObject(Idx: Integer): DWORD;
    procedure SetObject(Idx: Integer; const Value: DWORD);
    function GetValues(AName: PAnsiChar): PAnsiChar;
  protected
    procedure Init; virtual;
  protected
    fList: PList;
    fCount: Integer;
    fCaseSensitiveSort: Boolean;
    fTextBuf: PAnsiChar;
    fTextSiz: DWORD;
    fUsedSiz: DWORD;
  protected
    procedure ProvideSpace( AddSize: DWORD );
    function Get(Idx: integer): AnsiString;
    function GetTextStr: AnsiString;
    procedure Put(Idx: integer; const Value: AnsiString);
    procedure SetTextStr(const Value: AnsiString);
    function GetPChars( Idx: Integer ): PAnsiChar;
    destructor Destroy; virtual;
  public
    function AddAnsi( const S: AnsiString ): Integer;
    {* Adds Ansi AnsiString to a list. }
    function AddAnsiObject( const S: AnsiString; Obj: DWORD ): Integer;
    {* Adds Ansi AnsiString and correspondent object to a list. }
    function Add(S: PAnsiChar): integer;
    {* Adds an AnsiString to list. }
    function AddLen(S: PAnsiChar; Len: Integer): integer;
    {* Adds an AnsiString to list. The AnsiString can contain #0 characters. }
  public
    FastClear: Boolean;
    {* }
    procedure Clear;
    {* Makes AnsiString list empty. }
    procedure Delete(Idx: integer);
    {* Deletes AnsiString with given index (it *must* exist). }
    function IndexOf(const S: AnsiString): integer;
    {* Returns index of first AnsiString, equal to given one. }
    function IndexOf_NoCase(const S: AnsiString): integer;
    {* Returns index of first AnsiString, equal to given one (while comparing it
       without case sensitivity). }
    function IndexOfStrL_NoCase( Str: PAnsiChar; L: Integer ): integer;
    {* Returns index of the first AnsiString, equal to given one (while comparing it
       without case sensitivity). }
    function Find(const S: AnsiString; var Index: Integer): Boolean;
    {* Returns Index of the first AnsiString, equal or greater to given pattern, but
       works only for sorted TFastStrListEx object. Returns TRUE if exact AnsiString found,
       otherwise nearest (greater then a pattern) AnsiString index is returned,
       and the result is FALSE. }
    procedure InsertAnsi(Idx: integer; const S: AnsiString);
    {* Inserts ANSI AnsiString before one with given index. }
    procedure InsertAnsiObject(Idx: integer; const S: AnsiString; Obj: DWORD);
    {* Inserts ANSI AnsiString before one with given index. }
    procedure Insert(Idx: integer; S: PAnsiChar);
    {* Inserts AnsiString before one with given index. }
    procedure InsertLen( Idx: Integer; S: PAnsiChar; Len: Integer );
    {* Inserts AnsiString from given PChar. It can contain #0 characters. }
    function LoadFromFile(const FileName: AnsiString): Boolean;
    {* Loads AnsiString list from a file. (If file does not exist, nothing
       happens). Very fast even for huge text files. }
    procedure LoadFromStream(Stream: PStream; Append2List: boolean);
    {* Loads AnsiString list from a stream (from current position to the end of
       a stream). Very fast even for huge text. }
    procedure MergeFromFile(const FileName: AnsiString);
    {* Merges AnsiString list with strings in a file. Fast. }
    procedure Move(CurIndex, NewIndex: integer);
    {* Moves AnsiString to another location. }
    procedure SetText(const S: AnsiString; Append2List: boolean);
    {* Allows to set strings of AnsiString list from given AnsiString (in which
       strings are separated by $0D,$0A or $0D characters). Text can
       contain #0 characters. Works very fast. This method is used in
       all others, working with text arrays (LoadFromFile, MergeFromFile,
       Assign, AddStrings). }
    function SaveToFile(const FileName: AnsiString): Boolean;
    {* Stores AnsiString list to a file. }
    procedure SaveToStream(Stream: PStream);
    {* Saves AnsiString list to a stream (from current position). }
    function AppendToFile(const FileName: AnsiString): Boolean;
    {* Appends strings of AnsiString list to the end of a file. }
    property Count: integer read fCount;
    {* Number of strings in a AnsiString list. }
    property Items[Idx: integer]: AnsiString read Get write Put; default;
    {* Strings array items. If item does not exist, empty AnsiString is returned.
       But for assign to property, AnsiString with given index *must* exist. }
    property ItemPtrs[ Idx: Integer ]: PAnsiChar read GetPChars;
    {* Fast access to item strings as PChars. }
    property ItemLen[ Idx: Integer ]: Integer read GetItemLen;
    {* Length of AnsiString item. }
    function Last: AnsiString;
    {* Last item (or '', if AnsiString list is empty). }
    property Text: AnsiString read GetTextStr write SetTextStr;
    {* Content of AnsiString list as a single AnsiString (where strings are separated
       by characters $0D,$0A). }
    procedure Swap( Idx1, Idx2 : Integer );
    {* Swaps to strings with given indeces. }
    procedure Sort( CaseSensitive: Boolean );
    {* Call it to sort AnsiString list. }
  public
    function AddObject( S: PAnsiChar; Obj: DWORD ): Integer;
    {* Adds AnsiString S (null-terminated) with associated object Obj. }
    function AddObjectLen( S: PAnsiChar; Len: Integer; Obj: DWORD ): Integer;
    {* Adds AnsiString S of length Len with associated object Obj. }
    procedure InsertObject( Idx: Integer; S: PAnsiChar; Obj: DWORD );
    {* Inserts AnsiString S (null-terminated) at position Idx in the list,
       associating it with object Obj. }
    procedure InsertObjectLen( Idx: Integer; S: PAnsiChar; Len: Integer; Obj: DWORD );
    {* Inserts AnsiString S of length Len at position Idx in the list,
       associating it with object Obj. }
    property Objects[ Idx: Integer ]: DWORD read GetObject write SetObject;
    {* Access to objects associated with strings in the list. }
  public
    procedure Append( S: PAnsiChar );
    {* Appends S (null-terminated) to the last AnsiString in FastStrListEx object, very fast. }
    procedure AppendLen( S: PAnsiChar; Len: Integer );
    {* Appends S of length Len to the last AnsiString in FastStrListEx object, very fast. }
    procedure AppendInt2Hex( N: DWORD; MinDigits: Integer );
    {* Converts N to hexadecimal and appends resulting AnsiString to the last
       AnsiString, very fast. }
  public
    property Values[ Name: PAnsiChar ]: PAnsiChar read GetValues;
    {* Returns a value correspondent to the Name an ini-file-like AnsiString list
       (having Name1=Value1 Name2=Value2 etc. in each AnsiString). }
    function IndexOfName( AName: PAnsiChar ): Integer;
    {* Searches AnsiString starting from 'AName=' in AnsiString list like ini-file. }
  end;

function NewFastStrListEx: PFastStrListEx;
         {* Creates FastStrListEx object. }

var Upper: array[ Char ] of AnsiChar;
    {* An table to convert char to uppercase very fast. First call InitUpper. }

    Upper_Initialized: Boolean;
procedure InitUpper;
          {* Call this fuction ones to fill Upper[ ] table before using it. }

type
  PCABFile = ^TCABFile;

  TOnNextCAB = function( Sender: PCABFile ): KOLString of object;
  TOnCABFile = function( Sender: PCABFile; var FileName: KOLString ): Boolean of object;

{ ----------------------------------------------------------------------

                TCabFile - windows cabinet files

----------------------------------------------------------------------- }
//[TCabFile DEFINITION]
  TCABFile = object( TObj )
  {* An object to simplify extracting files from a cabinet (.CAB) files.
     The only what need to use this object, setupapi.dll. It is provided
     with all latest versions of Windows. }
  protected
    FPaths: PKOLStrList;
    FNames: PKOLStrList;
    FOnNextCAB: TOnNextCAB;
    FOnFile: TOnCABFile;
    FTargetPath: KOLString;
    FSetupapi: THandle;
    function GetNames(Idx: Integer): KOLString;
    function GetCount: Integer;
    function GetPaths(Idx: Integer): KOLString;
    function GetTargetPath: KOLString;
  protected
    FGettingNames: Boolean;
    FCurCAB: Integer;
  public
    destructor Destroy; virtual;
    {* }
    property Paths[ Idx: Integer ]: KOLString read GetPaths;
    {* A list of CAB-files. It is stored, when constructing function
       OpenCABFile called. }
    property Names[ Idx: Integer ]: KOLString read GetNames;
    {* A list of file names, stored in a sequence of CAB files. To get know,
       how many files are there, check Count property. }
    property Count: Integer read GetCount;
    {* Number of files stored in a sequence of CAB files. }
    function Execute: Boolean;
    {* Call this method to extract or enumerate files in CAB. For every
       file, found during executing, event OnFile is alled (if assigned).
       If the event handler (if any) does not provide full target path for
       a file to extract to, property TargetPath is applyed (also if it
       is assigned), or file is extracted to the default directory (usually
       the same directory there CAB file is located, or current directory
       - by a decision of the system).
       |<br>
       If a sequence of CAB files is used, and not all names for CAB files
       are provided (absent or represented by a AnsiString '?' ), an event
       OnNextCAB is called to obtain the name of the next CAB file.}
    property CurCAB: Integer read FCurCAB;
    {* Index of current CAB file in a sequence of CAB files. When OnNextCAB
       event is called (if any), CurCAB property is already set to the
       index of path, what should be provided. }
    property OnNextCAB: TOnNextCAB read FOnNextCAB write FOnNextCAB;
    {* This event is called, when a series of CAB files is needed and not
       all CAB file names are provided (absent or represented by '?' AnsiString).
       If this event is not assigned, the user is prompted to browse file. }
    property OnFile: TOnCABFile read FOnFile write FOnFile;
    {* This event is called for every file found during Execute method.
       In an event handler (if any assigned), it is possible to return
       False to skip file, or to provide another full target path for
       file to extract it to, then default. If the event is not assigned,
       all files are extracted either to default directory, or to the
       directory TargetPath, if it is provided. }
    property TargetPath: KOLString read GetTargetPath write FTargetPath;
    {* Optional target directory to place there extracted files. }
  end;
//[END OF TCABFile DEFINITION]

//[OpenCABFile DECLARATION]
function OpenCABFile( const APaths: array of AnsiString ): PCABFile;
{* This function creates TCABFile object, passing a sequence of CAB file names
   (fully qualified). It is possible not to provide all names here, or pass '?'
   AnsiString in place of some of those. For such files, either an event OnNextCAB
   will be called, or (and) user will be prompted to browse file during
   executing (i.e. Extracting). }

type
  PDirChange = ^TDirChange;
  {* }

  TOnDirChange = procedure (Sender: PDirChange; const Path: KOLString) of object;
  {* Event type to define OnChange event for folder monitoring objects. }

  TFileChangeFilters = (fncFileName, fncDirName, fncAttributes, fncSize,
      fncLastWrite, fncLastAccess, fncCreation, fncSecurity);
  {* Possible change monitor filters. }
  TFileChangeFilter = set of TFileChangeFilters;
  {* Set of filters to pass to a constructor of TDirChange object. }

{ ----------------------------------------------------------------------

                          TDirChange object

----------------------------------------------------------------------- }
  TDirChange = object(TObj)
  {* Object type to monitor changes in certain folder. }
  protected
    {$IFDEF DIRCHG_ONEXECUTE}
    FOnExecute: TOnEvent;
    {$ENDIF}
    FOnChange: TOnDirChange;
    FHandle, FinEvent: THandle;
    FPath: KOLString;
    FMonitor: PThread;
    FWatchSubtree: Boolean;
    FDestroying: Boolean;
    FFlags: DWORD;
    function Execute( Sender: PThread ): Integer;
    procedure Changed;
  protected
    destructor Destroy; virtual;
    {*}
  public
    property Handle: THandle read FHandle;
    {* Handle of file change notification object. *}
    property Path: KOLString read FPath; //write SetPath;
    {* Path to monitored folder (to a root, if tree of folders
       is under monitoring). }
    property OnChange: TOnDirChange read FOnChange write FOnChange;
    {$IFDEF DIRCHG_ONEXECUTE}
    property OnExecute: TOnEvent read FOnExecute write FOnExecute;
    {$ENDIF}
  end;

function NewDirChangeNotifier( const Path: KOLString; Filter: TFileChangeFilter;
                               WatchSubtree: Boolean; ChangeProc: TOnDirChange
                               {$IFDEF DIRCHG_ONEXECUTE} ; OnExecuteProc: TOnEvent
                               {$ENDIF} )
                               : PDirChange;
{* Creates notification object TDirChange. If something wrong (e.g.,
   passed directory does not exist), nil is returned as a result. When change
   is notified, ChangeProc is called always in main thread context.
   (Please note, that ChangeProc can not be nil).
   If empty filter is passed, default filter is used:
   [fncFileName..fncLastWrite]. }

type
  PMetafile = ^TMetafile;
{ ----------------------------------------------------------------------

      TMetafile - Windows metafile and Enchanced Metafile image

----------------------------------------------------------------------- }
  TMetafile = object( TObj )
  {* Object type to incapsulate metafile image. }
  protected
    function GetHeight: Integer;
    function GetWidth: Integer;
    procedure SetHandle(const Value: THandle);
  protected
    fHandle: THandle;
    fHeader: PEnhMetaHeader;
    procedure RetrieveHeader;
  public
    destructor Destroy; virtual;
    {* }
    procedure Clear;
    {* }
    function Empty: Boolean;
    {* Returns TRUE if empty}
    property Handle: THandle read fHandle write SetHandle;
    {* Returns handle of enchanced metafile. }
    function LoadFromStream( Strm: PStream ): Boolean;
    {* Loads emf or wmf file format from stream. }
    function LoadFromFile( const Filename: AnsiString ): Boolean;
    {* Loads emf or wmf from stream. }
    procedure Draw( DC: HDC; X, Y: Integer );
    {* Draws enchanced metafile on DC. }
    procedure StretchDraw( DC: HDC; const R: TRect );
    {* Draws enchanced metafile stretched. }
    property Width: Integer read GetWidth;
    {* Native width of the metafile. }
    property Height: Integer read GetHeight;
    {* Native height of the metafile. }
  end;
//[END OF TMetafile DEFINITION]

//[NewMetafile DECLARATION]
function NewMetafile: PMetafile;
{* Creates metafile object. }

//[Metafile CONSTANTS, STRUCTURES, ETC.]
const
  WMFKey = Integer($9AC6CDD7);
  WMFWord = $CDD7;
type
  TMetafileHeader = packed record
    Key: Longint;
    Handle: SmallInt;
    Box: TSmallRect;
    Inch: Word;
    Reserved: Longint;
    CheckSum: Word;
  end;

function ComputeAldusChecksum(var WMF: TMetafileHeader): Word;

{++}(*
function SetEnhMetaFileBits(p1: UINT; p2: PAnsiChar): HENHMETAFILE; stdcall;
function PlayEnhMetaFile(DC: HDC; p2: HENHMETAFILE; const p3: TRect): BOOL; stdcall;
*){--}

// NewActionList, TAction - by Yury Sidorov
//[ACTIONS OBJECT]
{ ----------------------------------------------------------------------

                TAction and TActionList

----------------------------------------------------------------------- }
type
  PControlRec = ^TControlRec;
  TOnUpdateCtrlEvent = procedure(Sender: PControlRec) of object;

  TCtrlKind = (ckControl, ckMenu, ckToolbar);
  TControlRec = record
    Ctrl: PObj;
    CtrlKind: TCtrlKind;
    ItemID: integer;
    UpdateProc: TOnUpdateCtrlEvent;
  end;

  PAction = ^TAction;

  PActionList = ^TActionList;

  TAction = object( TObj )
  {*! Use action objects, in conjunction with action lists, to centralize the response
      to user commands (actions).
      Use AddControl, AddMenuItem, AddToolbarButton methods to link controls to an action.
      See also TActionList.
      }
  protected
    FControls: PList;
    FCaption: KOLString;
    FChecked: boolean;
    FVisible: boolean;
    FEnabled: boolean;
    FHelpContext: integer;
    FHint: KOLString;
    FOnExecute: TOnEvent;
    FAccelerator: TMenuAccelerator;
    FShortCut: KOLString;
    procedure DoOnMenuItem(Sender: PMenu; Item: Integer);
    procedure DoOnToolbarButtonClick(Sender: PControl; BtnID: Integer);
    procedure DoOnControlClick(Sender: PObj);

    procedure SetCaption(const Value: KOLString);
    procedure SetChecked(const Value: boolean);
    procedure SetEnabled(const Value: boolean);
    procedure SetHelpContext(const Value: integer);
    procedure SetHint(const Value: KOLString);
    procedure SetVisible(const Value: boolean);
    procedure SetAccelerator(const Value: TMenuAccelerator);
    procedure UpdateControls;

    procedure LinkCtrl(ACtrl: PObj; ACtrlKind: TCtrlKind; AItemID: integer; AUpdateProc: TOnUpdateCtrlEvent);
    procedure SetOnExecute(const Value: TOnEvent);

    procedure UpdateCtrl(Sender: PControlRec);
    procedure UpdateMenu(Sender: PControlRec);
    procedure UpdateToolbar(Sender: PControlRec);

  public
    destructor Destroy; virtual;
    procedure LinkControl(Ctrl: PControl);
    {* Add a link to a TControl or descendant control. }
    procedure LinkMenuItem(Menu: PMenu; MenuItemIdx: integer);
    {* Add a link to a menu item. }
    procedure LinkToolbarButton(Toolbar: PControl; ButtonIdx: integer);
    {* Add a link to a toolbar button. }
    procedure Execute;
    {* Executes a OnExecute event handler. }
    property Caption: KOLString read FCaption write SetCaption;
    {* Text caption. }
    property Hint: KOLString read FHint write SetHint;
    {* Hint (tooltip). Currently used for toolbar buttons only. }
    property Checked: boolean read FChecked write SetChecked;
    {* Checked state. }
    property Enabled: boolean read FEnabled write SetEnabled;
    {* Enabled state. }
    property Visible: boolean read FVisible write SetVisible;
    {* Visible state. }
    property HelpContext: integer read FHelpContext write SetHelpContext;
    {* Help context. }
    property Accelerator: TMenuAccelerator read FAccelerator write SetAccelerator;
    {* Accelerator for menu items. }
    property OnExecute: TOnEvent read FOnExecute write SetOnExecute;
    {* This event is executed when user clicks on a linked object or Execute method was called. }
  end;

  TActionList = object( TObj )
  {*! TActionList maintains a list of actions used with components and controls,
     such as menu items and buttons.
     Action lists are used, in conjunction with actions, to centralize the response
     to user commands (actions).
     Write an OnUpdateActions handler to update actions state.
     Created using function NewActionList.
     See also TAction.
  }
  protected
    FOwner: PControl;
    FActions: PList;
    FOnUpdateActions: TOnEvent;
    function GetActions(Idx: integer): PAction;
    function GetCount: integer;
  protected
    procedure DoUpdateActions(Sender: PObj);
  public
    destructor Destroy; virtual;
    function Add(const ACaption, AHint: KOLString; OnExecute: TOnEvent): PAction;
    {* Add a new action to the list. Returns pointer to action object. }
    procedure Delete(Idx: integer);
    {* Delete action by index from list. }
    procedure Clear;
    {* Clear all actions in the list. }
    property Actions[Idx: integer]: PAction read GetActions;
    {* Access to actions in the list. }
    property Count: integer read GetCount;
    {* Number of actions in the list.. }
    property OnUpdateActions: TOnEvent read FOnUpdateActions write FOnUpdateActions;
    {* Event handler to update actions state. This event is called each time when application
      goes in the idle state (no messages in the queue). }
  end;

function NewActionList(AOwner: PControl): PActionList;
{* Action list constructor. AOwner - owner form. }

{ -- tree (non-visual) -- }

type
  PTree = ^TTree;
  TTree = object( TObj )
  {* Object to store tree-like data in memory (non-visual). }
  protected
    fParent: PTree;
    fChildren: PList;
    fPrev: PTree;
    fNext: PTree;
    {$IFDEF TREE_NONAME}
    {$ELSE}
    {$IFDEF TREE_WIDE}
    fNodeName: WideString;
    {$ELSE}
    fNodeName: AnsiString;
    {$ENDIF}
    {$ENDIF}
    fData: Pointer;
    function GetCount: Integer;
    function GetItems(Idx: Integer): PTree;
    procedure Unlink;
    function GetRoot: PTree;
    function GetLevel: Integer;
    function GetTotal: Integer;
    function GetIndexAmongSiblings: Integer;
  protected
    {$IFDEF USE_CONSTRUCTORS}
    constructor CreateTree( AParent: PTree; const AName: AnsiString );
    {* }
    {$ENDIF}
    destructor Destroy; virtual;
    {* }
    procedure Init; virtual;
  public
    procedure Clear;
    {* Destoyes all child nodes. }
    {$IFDEF TREE_NONAME}
    {$ELSE}
    {$IFDEF TREE_WIDE}
    property Name: WideString read fNodeName write fNodeName;
    {$ELSE}
    property Name: AnsiString read fNodeName write fNodeName;
    {$ENDIF}
    {$ENDIF}
    {* Optional node name. }
    property Data: Pointer read fData write fData;
    {* Optional user-defined pointer. }
    property Count: Integer read GetCount;
    {* Number of child nodes of given node. }
    property Items[ Idx: Integer ]: PTree read GetItems;
    {* Child nodes list items. }
    procedure Add( Node: PTree );
    {* Adds another node as a child of given tree node. This operation
       as well as Insert can be used to move node together with its children
       to another location of the same tree or even from another tree.
       Anyway, added Node first correctly removed from old place (if it is
       defined for it). But for simplest task, such as filling of tree with
       nodes, code should looking as follows:
       !  Node := NewTree( nil, 'test of creating node without parent' );
       !  RootOfMyTree.Add( Node );
       Though, this code gives the same result as:
       !  Node := NewTree( RootOfMyTree, 'test of creatign node as a child' ); }
    procedure Insert( Before, Node: PTree );
    {* Inserts earlier created 'Node' just before given child node 'Before'
       as a child of given tree node. See also Add method. }
    property Parent: PTree read fParent;
    {* Returns parent node (or nil, if there is no parent). }
    property Index: Integer read GetIndexAmongSiblings;
    {* Returns an index of the node in a list of nodes of the same parent
       (or -1, if Parent is not defined). }
    property PrevSibling: PTree read fPrev;
    {* Returns previous node in a list of children of the Parent. Nil is
       returned, if given node is the first child of the Parent or has
       no Parent. }
    property NextSibling: PTree read fNext;
    {* Returns next node in a list of children of the Parent. Nil is returned,
       if given node is the last child of the Parent or has no Parent at all. }
    property Root: PTree read GetRoot;
    {* Returns root node (i.e. the last Parent, enumerating parents recursively). }
    property Level: Integer read GetLevel;
    {* Returns level of the node, i.e. integer value, equal to 0 for root
       of a tree, 1 for its children, etc. }
    property Total: Integer read GetTotal;
    {* Returns total number of children of the node and all its children
       counting its recursively (but node itself is not considered, i.e.
       Total for node without children is equal to 0). }
    procedure SortByName;
    {* Sorts children of the node in ascending order. Sorting is not
       recursive, i.e. only immediate children are sorted. }
    procedure SwapNodes( i1, i2: Integer );
    {* Swaps two child nodes. }
    function IsParentOfNode( Node: PTree ): Boolean;
    {* Returns true, if Node is the tree itself or is a parent of the given node
       on any level. }
    function IndexOf( Node: PTree ): Integer;
    {* Total index of the child node (on any level under this node). }

  end;
//[END OF TTree DEFINITION]

//[NewTree DECLARATION]
{$IFDEF TREE_NONAME}
function NewTree( AParent: PTree ): PTree;
{* Nameless version (for case when TREE_NONAME symbol is defined).
   Constructs tree node, adding it to the end of children list of
   the AParent. If AParent is nil, new root tree node is created. }
{$ELSE}
{$IFDEF TREE_WIDE}
function NewTree( AParent: PTree; const AName: WideString ): PTree;
{* WideString version (for case when TREE_WIDE symbol is defined).
   Constructs tree node, adding it to the end of children list of
   the AParent. If AParent is nil, new root tree node is created. }
{$ELSE}
function NewTree( AParent: PTree; const AName: AnsiString ): PTree;
{* Constructs tree node, adding it to the end of children list of
   the AParent. If AParent is nil, new root tree node is created. }
{$ENDIF}
{$ENDIF}

{-------------------------------------------------------------------------------
  ADDITIONAL UTILITIES
}

function MapFileRead( const Filename: AnsiString; var hFile, hMap: THandle ): Pointer;
{* Opens file for read only (with share deny none attribute) and maps its
   entire content using memory mapped files technique. The address of the
   first byte of file mapped into the application address space is returned.
   When mapping no more needed, it must be closed calling UnmapFile (see below).
   Maximum file size which can be mapped at a time is 1/4 Gigabytes. If file size
   exceeding this value only 1/4 Gigabytes starting from the beginning of the
   file is mapped therefore. }

function MapFile( const Filename: AnsiString; var hFile, hMap: THandle ): Pointer;
{* Opens file for read/write (in exlusive mode) and maps its
   entire content using memory mapped files technique. The address of the
   first byte of file mapped into the application address space is returned.
   When mapping no more needed, it must be closed calling UnmapFile (see below). }

procedure UnmapFile( BasePtr: Pointer; hFile, hMap: THandle );
{* Closes mapping opened via MapFile or MapFileRead call. }

//------------------------ for MCK projects:
{$IFDEF KOL_MCK}
type
  TKOLAction = PAction;
  TKOLActionList = PActionList;
{$ENDIF}

function ShowQuestion( const S: KOLString; Answers: KOLString ): Integer;
{* Modal dialog like ShowMsgModal. It is based on KOL form, so it can
   be called also out of message loop, e.g. after finishing the
   application. Also, this function *must* be used in MDI applications
   in place of any dialog functions, based on MessageBox.
   |<br>
   The the second parameter should be empty AnsiString or several possible
   answers separated by '/', e.g.: 'Yes/No/Cancel'. Result is
   a number answered, starting from 1. For example, if  'Cancel'
   was pressed, 3 will be returned.
   |<br>
   User can also press ESCAPE key, or close modal dialog. In such case
   -1 is returned. }
function ShowQuestionEx( S: KOLString; Answers: KOLString; CallBack: TOnEvent ): Integer;
{* Like ShowQuestion, but with CallBack function, called just before showing
   the dialog. }
procedure ShowMsgModal( const S: KOLString );
{* This message function can be used out of a message loop (e.g., after
   finishing the application). It is always modal.
      Actually, a form with word-wrap label (decorated as borderless edit
   box with btnFace color) and with OK button is created and shown modal.
   When a dialog is called from outside message loop, caption 'Information'
   is always displayed.
   Dialog form is automatically resized vertically to fit message text
   (but until screen height is achieved) and shown always centered on
   screen. The width is fixed (400 pixels).
   |<br>
   Do not use this function outside the message loop for case, when the
   Applet variable is not used in an application. }

implementation

//uses
  //ShellAPI,
  //shlobj,
  //{$IFNDEF _D2}ActiveX,{$ENDIF}
//  CommDlg
{$IFDEF USE_GRUSH}uses ToGrush; {$ENDIF}

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T L i s t E x                               |
|                                                                              |
(------------------------------------------------------------------------------}
{ TListEx }

function NewListEx: PListEx;
begin
  new( Result, Create );
  Result.fList := NewList;
  Result.fObjects := NewList;
end;

procedure TListEx.Add(Value: Pointer);
begin
  AddObj( Value, nil );
end;

procedure TListEx.AddObj(Value, Obj: Pointer);
var C: Integer;
begin
  C := Count;
  fList.Add( Value );
  fObjects.Insert( C, Obj );
end;

procedure TListEx.Clear;
begin
  fList.Clear;
  fObjects.Clear;
end;

//[procedure TListEx.Delete]
procedure TListEx.Delete(Idx: Integer);
begin
  DeleteRange( Idx, 1 );
end;

//[procedure TListEx.DeleteRange]
procedure TListEx.DeleteRange(Idx, Len: Integer);
begin
  fList.DeleteRange( Idx, Len );
  fObjects.DeleteRange( Idx, Len );
end;

//[destructor TListEx.Destroy]
destructor TListEx.Destroy;
begin
  fList.Free;
  fObjects.Free;
  inherited;
end;

//[function TListEx.GetAddBy]
function TListEx.GetAddBy: Integer;
begin
  Result := fList.AddBy;
end;

//[function TListEx.GetCount]
function TListEx.GetCount: Integer;
begin
  Result := fList.Count;
end;

//[function TListEx.GetEx]
function TListEx.GetEx(Idx: Integer): Pointer;
begin
  Result := fList.Items[ Idx ];
end;

//[function TListEx.IndexOf]
function TListEx.IndexOf(Value: Pointer): Integer;
begin
  Result := fList.IndexOf( Value );
end;

//[function TListEx.IndexOfObj]
function TListEx.IndexOfObj(Obj: Pointer): Integer;
begin
  Result := fObjects.IndexOf( Obj );
end;

//[procedure TListEx.Insert]
procedure TListEx.Insert(Idx: Integer; Value: Pointer);
begin
  InsertObj( Idx, Value, nil );
end;

//[procedure TListEx.InsertObj]
procedure TListEx.InsertObj(Idx: Integer; Value, Obj: Pointer);
begin
  fList.Insert( Idx, Value );
  fObjects.Insert( Idx, Obj );
end;

//[function TListEx.Last]
function TListEx.Last: Pointer;
begin
  Result := fList.Last;
end;

//[function TListEx.LastObj]
function TListEx.LastObj: Pointer;
begin
  Result := fObjects.Last;
end;

//[procedure TListEx.MoveItem]
procedure TListEx.MoveItem(OldIdx, NewIdx: Integer);
begin
  fList.MoveItem( OldIdx, NewIdx );
  fObjects.MoveItem( OldIdx, NewIdx );
end;

//[procedure TListEx.PutEx]
procedure TListEx.PutEx(Idx: Integer; const Value: Pointer);
begin
  fList.Items[ Idx ] := Value;
end;

//[procedure TListEx.Set_AddBy]
procedure TListEx.Set_AddBy(const Value: Integer);
begin
  fList.AddBy := Value;
  fObjects.AddBy := Value;
end;

//[procedure TListEx.Swap]
procedure TListEx.Swap(Idx1, Idx2: Integer);
begin
  fList.Swap( Idx1, Idx2 );
  fObjects.Swap( Idx1, Idx2 );
end;

{------------------------------------------------------------------------------)
|                                                                              |
|                                  T B i t s                                   |
|                                                                              |
(------------------------------------------------------------------------------}
{ TBits }

type
  PBitsList = ^TBitsList;
  TBitsList = object( TList )
  end;

function NewBits: PBits;
begin
  new( Result, Create );
  Result.fList := NewList;
  {$IFDEF TLIST_FAST} Result.fList.UseBlocks:= False; {$ENDIF}
end;

procedure TBits.AssignBits(ToIdx: Integer; FromBits: PBits; FromIdx,
  N: Integer);
var i: Integer;
    NewCount: Integer;
begin
  if FromIdx >= FromBits.Count then Exit;
  if FromIdx + N > FromBits.Count then
    N := FromBits.Count - FromIdx;
  Capacity := (ToIdx + N + 8) div 8;
  NewCount := Max( Count, ToIdx + N );
  fCount := Max( NewCount, fCount );
  PBitsList( fList ).fCount := (Capacity + 3) div 4;
  while ToIdx and $1F <> 0 do
  begin
    Bits[ ToIdx ] := FromBits.Bits[ FromIdx ];
    Inc( ToIdx );
    Inc( FromIdx );
    Dec( N );
    if N = 0 then Exit;
  end;
  Move( PByte( Integer( PBitsList( FromBits.fList ).fItems ) + (FromIdx + 31) div 32 )^,
        PByte( Integer( PBitsList( fList ).fItems ) + ToIdx div 32 )^, (N + 31) div 32 );
  FromIdx := FromIdx and $1F;
  if FromIdx <> 0 then
  begin // shift data by (Idx and $1F) bits right
    for i := ToIdx div 32 to fList.Count-2 do
      fList.Items[ i ] := Pointer(
        (DWORD( fList.Items[ i ] ) shr FromIdx) or
        (DWORD( fList.Items[ i+1 ] ) shl (32 - FromIdx))
        );
    fList.Items[ fList.Count-1 ] := Pointer(
      DWORD( fList.Items[ fList.Count-1 ] ) shr FromIdx
      );
  end;
end;

//[function TBits.Copy]
procedure TBits.Clear;
begin
  fCount := 0;
  fList.Clear;
end;

function TBits.Copy(From, BitsCount: Integer): PBits;
var Shift, N: Integer;
    FirstItemPtr: Pointer;
begin
  Result := NewBits;
  if BitsCount = 0 then Exit;
  Result.Capacity := BitsCount + 32;
  Result.fCount := BitsCount;
  Move( PBitsList( fList ).fItems[ From shr 5 ],
        PBitsList( Result.fList ).fItems[ 0 ], (Count + 31) div 32 );
  Shift := From and $1F;
  if Shift <> 1 then
  begin
    N := (BitsCount + 31) div 32;
    FirstItemPtr := @ PBitsList( Result.fList ).fItems[ N - 1 ];
    asm
          PUSH  ESI
          PUSH  EDI
          MOV   ESI, FirstItemPtr
          MOV   EDI, ESI
          STD
          MOV   ECX, N
          XOR   EAX, EAX
          CDQ
    @@1:
          PUSH  ECX
          LODSD
          MOV   ECX, Shift
          SHRD  EAX, EDX, CL
          STOSD
          SUB   ECX, 32
          NEG   ECX
          SHR   EDX, CL
          POP   ECX

          LOOP  @@1

          CLD
          POP   EDI
          POP   ESI
    end {$IFDEF F_P} ['EAX','EDX','ECX'] {$ENDIF};
  end;
end;

//[destructor TBits.Destroy]
var Counts: array[ 0..255 ] of Integer;
function TBits.CountTrueBits: Integer;
var I, j, N: Integer;
    D: DWORD;
begin
  Result := 0;
  if  Counts[255] = 0 then
  begin
      for I := 0 to 255 do
      begin
          N := I;
          j := 0;
          while N <> 0 do
          begin
              if  N and 1 <> 0 then
                  inc( j );
              N := N shr 1;
          end;
          Counts[I] := j;
      end;
  end;
  for I := 0 to PBitsList( fList ).fCount-1 do
  begin
      D := DWORD( PBitsList( fList ).fItems[ I ] );
      if  D = $FFFFFFFF then
          inc( Result, 32 )
      else
      begin
          inc( Result, Counts[ D and $FF ] );
          D := D shr 8;
          inc( Result, Counts[ D and $FF ] );
          D := D shr 8;
          inc( Result, Counts[ D and $FF ] );
          D := D shr 8;
          inc( Result, Counts[ D ] );
      end;
  end;
end;

destructor TBits.Destroy;
begin
  fList.Free;
  inherited;
end;

//[function TBits.GetBit]
{$IFDEF ASM_VERSION}
function TBits.GetBit(Idx: Integer): Boolean;
asm
  CMP  EDX, [EAX].FCount
  JL   @@1
  XOR  EAX, EAX
  RET
@@1:
  MOV  EAX, [EAX].fList
  {TEST EAX, EAX
  JZ   @@exit}
  MOV  EAX, [EAX].TBitsList.fItems
  BT   [EAX], EDX
  SETC AL
@@exit:
end;
{$ELSE}
function TBits.GetBit(Idx: Integer): Boolean;
begin
  if (Idx >= Count) {or (PCrackList( fList ).fItems = nil)} then Result := FALSE else
  Result := ( ( DWORD( PBitsList( fList ).fItems[ Idx shr 5 ] ) shr (Idx and $1F)) and 1 ) <> 0;
end;
{$ENDIF}

//[function TBits.GetCapacity]
function TBits.GetCapacity: Integer;
begin
  Result := fList.Capacity * 32;
end;

//[function TBits.GetSize]
function TBits.GetSize: Integer;
begin
  Result := ( PBitsList( fList ).fCount + 3) div 4;
end;

{$IFDEF ASM_noVERSION}
//[function TBits.IndexOf]
function TBits.IndexOf(Value: Boolean): Integer;
asm     //cmd    //opd
        PUSH     EDI
        MOV      EDI, [EAX].fList
        MOV      ECX, [EDI].TList.fCount
@@ret_1:
        OR       EAX, -1
        JECXZ    @@ret_EAX
        MOV      EDI, [EDI].TList.fItems
        TEST     DL, DL
        MOV      EDX, EDI
        JE       @@of_false
        INC      EAX
        REPZ     SCASD
        JE       @@ret_1
        MOV      EAX, [EDI-4]
        NOT      EAX
        JMP      @@calc_offset
        BSF      EAX, EAX
        SUB      EDI, EDX
        SHR      EDI, 2
        ADD      EAX, EDI
        JMP      @@ret_EAX
@@of_false:
        REPE     SCASD
        JE       @@ret_1
        MOV      EAX, [EDI-4]
@@calc_offset:
        BSF      EAX, EAX
        DEC      EAX
        SUB      EDI, 4
        SUB      EDI, EDX
        SHL      EDI, 3
        ADD      EAX, EDI
@@ret_EAX:
        POP      EDI
end;
{$ELSE ASM_VERSION} //Pascal
function TBits.IndexOf(Value: Boolean): Integer;
var I: Integer;
    D: DWORD;
begin
  Result := -1;
  if Value then
  begin
    for I := 0 to fList.Count-1 do
    begin
      D := DWORD( PBitsList( fList ).fItems[ I ] );
      if D <> 0 then
      begin
        asm
          MOV  EAX, D
          BSF  EAX, EAX
          MOV  D, EAX
        end {$IFDEF F_P} [ 'EAX' ] {$ENDIF};
        Result := I * 32 + Integer( D );
        if  Result >= fCount then
            Result := -1;
        break;
      end;
    end;
  end
    else
  begin
    Result := PBitsList( fList ).fCount * 32;
    for I := 0 to PBitsList( fList ).fCount-1 do
    begin
      D := DWORD( PBitsList( fList ).fItems[ I ] );
      if D <> $FFFFFFFF then
      begin
        asm
          MOV  EAX, D
          NOT  EAX
          BSF  EAX, EAX
          MOV  D, EAX
        end {$IFDEF F_P} [ 'EAX' ] {$ENDIF};
        Result := I * 32 + Integer( D );
        break;
      end;
    end;
  end;
end;
{$ENDIF ASM_VERSION}

//[function TBits.LoadFromStream]
procedure TBits.InstallBits(FromIdx, N: Integer; Value: Boolean);
var NewCount: Integer;
begin
  if FromIdx + N > fCount then
  begin
    Capacity := (FromIdx + N + 8) div 8;
    fCount := FromIdx + N - 1;
  end;
  NewCount := Max( Count, FromIdx + N - 1 );
  fCount := Max( NewCount, fCount );
  PBitsList( fList ).fCount := (Capacity + 3) div 4;
  while FromIdx and $1F <> 0 do
  begin
    Bits[ FromIdx ] := Value;
    Inc( FromIdx );
    Dec( N );
    if N = 0 then Exit;
  end;
  FillChar( PByte( Integer( PBitsList( fList ).fItems ) + FromIdx div 32 )^,
            (N + 7) div 8, Char( -Integer( Value ) ) );
end;

function TBits.LoadFromStream(strm: PStream): Integer;
var
 i: Integer;
begin
 Result := strm.Read( i, 4 );
 if Result < 4 then Exit;
 
 bits[ i]:= false; //by miek
 fcount:= i;

 i := (i + 7) div 8;
 Inc( Result, strm.Read( PBitsList( fList ).fItems^, i ) );
end;

//[function TBits.OpenBit]
function TBits.OpenBit: Integer;
begin
  Result := IndexOf( FALSE );
  if Result < 0 then Result := Count;
end;

//[function TBits.Range]
function TBits.Range(Idx, N: Integer): PBits;
begin
  Result := NewBits;
  Result.AssignBits( 0, @ Self, Idx, N );
end;

//[function TBits.SaveToStream]
function TBits.SaveToStream(strm: PStream): Integer;
begin
  Result := strm.Write( fCount, 4 );
  if fCount = 0 then Exit;
  Inc( Result, strm.Write( PBitsList( fList ).fItems^, (fCount + 7) div 8 ) );
end;

//[procedure TBits.SetBit]
{$IFDEF ASM_noVERSION}
procedure TBits.SetBit(Idx: Integer; const Value: Boolean);
asm
  PUSH EBX
  XCHG EBX, EAX
  CMP  EDX, [EBX].fCount
  JL   @@2

  LEA  EAX, [EDX+32]
  SHR  EAX, 5

  PUSH ECX
  MOV  ECX, [EBX].fList
  CMP  [ECX].TBitsList.fCount, EAX
  JGE  @@1

  MOV  [ECX].TBitsList.fCount, EAX
  MOV  ECX, [ECX].TBitsList.fCapacity
  SHL  ECX, 5
  CMP  EDX, ECX
  JLE  @@1

  PUSH EDX
  INC  EDX
  PUSH EAX
  MOV  EAX, EBX
  CALL SetCapacity
  POP  EAX
  POP  EDX

@@1:
  POP  ECX
@@2:
  MOV  EAX, [EBX].fList
  MOV  EAX, [EAX].TBitsList.fItems
  SHR  ECX, 1
  JC   @@2set
  BTR  [EAX], EDX
  JMP  @@exit
@@2set:
  BTS  [EAX], EDX
@@exit:
  POP  EBX
end;
{$ELSE}
procedure TBits.SetBit(Idx: Integer; const Value: Boolean);
var Msk: DWORD;
    MinListCount: Integer;
begin
  MinListCount := //(Idx + 31) shr 5 + 1;
                  (Idx + 32) shr 5;
  if  PBitsList( fList ).fCount < MinListCount then
  begin
      PBitsList( fList ).fCount := MinListCount;
      if  Idx >= Capacity then
          Capacity := //Idx + 1;
                      MinListCount shl 5;
  end;
  Msk := 1 shl (Idx and $1F);
  if  Value then
      PBitsList( fList ).fItems[ Idx shr 5 ] := Pointer(
                 DWORD(PBitsList( fList ).Items[ Idx shr 5 ]) or Msk)
  else
      PBitsList( fList ).fItems[ Idx shr 5 ] := Pointer(
                 DWORD(PBitsList( fList ).Items[ Idx shr 5 ]) and not Msk);
  if  Idx >= fCount then
      fCount := Idx + 1;
end;
{$ENDIF}

//[procedure TBits.SetCapacity]
procedure TBits.SetCapacity(const Value: Integer);
var OldCap: Integer;
begin
  OldCap := fList.Capacity;
  fList.Capacity := (Value + 31) div 32;
  if OldCap < fList.Capacity then
    FillChar( PAnsiChar( Integer( PBitsList( fList ).fItems ) + OldCap * Sizeof( Pointer ) )^,
              (fList.Capacity - OldCap) * sizeof( Pointer ), #0 );
end;

{------------------------------------------------------------------------------)
|                                                                              |
|                         T F a s t S t r L i s t                              |
|                                                                              |
(------------------------------------------------------------------------------}

function NewFastStrListEx: PFastStrListEx;
begin
  new( Result, Create );
end;

procedure InitUpper;
var c: AnsiChar;
begin
  for c := #0 to #255 do
    Upper[ c ] := AnsiUpperCase( {$IFDEF _D3orHigher}AnsiString{$ENDIF}(c + #0) )[ 1 ];
  Upper_Initialized := TRUE;
end;

{ TFastStrListEx }

function TFastStrListEx.AddAnsi(const S: AnsiString): Integer;
begin
  Result := AddObjectLen( PAnsiChar( S ), Length( S ), 0 );
end;

function TFastStrListEx.AddAnsiObject(const S: AnsiString; Obj: DWORD): Integer;
begin
  Result := AddObjectLen( PAnsiChar( S ), Length( S ), Obj );
end;

function TFastStrListEx.Add(S: PAnsiChar): integer;
begin
  Result := AddObjectLen( S, StrLen( S ), 0 )
end;

function TFastStrListEx.AddLen(S: PAnsiChar; Len: Integer): integer;
begin
  Result := AddObjectLen( S, Len, 0 )
end;

function TFastStrListEx.AddObject(S: PAnsiChar; Obj: DWORD): Integer;
begin
  Result := AddObjectLen( S, StrLen( S ), Obj )
end;

function TFastStrListEx.AddObjectLen(S: PAnsiChar; Len: Integer; Obj: DWORD): Integer;
var Dest: PAnsiChar;
begin
  ProvideSpace( Len + 9 );
  Dest := PAnsiChar( DWORD( fTextBuf ) + fUsedSiz );
  Result := fCount;
  Inc( fCount );
  fList.Add( Pointer( DWORD(Dest)-DWORD(fTextBuf) ) );
  PDWORD( Dest )^ := Obj;
  Inc( Dest, 4 );
  PDWORD( Dest )^ := Len;
  Inc( Dest, 4 );
  if S <> nil then
    System.Move( S^, Dest^, Len );
  Inc( Dest, Len );
  Dest^ := #0;
  Inc( fUsedSiz, Len+9 );
end;

function TFastStrListEx.AppendToFile(const FileName: AnsiString): Boolean;
var F: HFile;
    Txt: AnsiString;
begin
  Txt := Text;
  F := FileCreate( KOLString(FileName), ofOpenAlways or ofOpenReadWrite or ofShareDenyWrite );
  if F = INVALID_HANDLE_VALUE then Result := FALSE
  else begin
         FileSeek( F, 0, spEnd );
         Result := FileWrite( F, PAnsiChar( Txt )^, Length( Txt ) ) = DWORD( Length( Txt ) );
         FileClose( F );
       end;
end;

procedure TFastStrListEx.Clear;
begin
  if FastClear then
  begin
    if fList.Count > 0 then
      fList.Count := 0;
  end
    else
  begin
    fList.Clear;
    if fTextBuf <> nil then
      FreeMem( fTextBuf );
    fTextBuf := nil;
  end;
  fTextSiz := 0;
  fUsedSiz := 0;
  fCount := 0;
end;

procedure TFastStrListEx.Delete(Idx: integer);
begin
  if (Idx < 0) or (Idx >= Count) then Exit;
  if Idx = Count-1 then
    Dec( fUsedSiz, ItemLen[ Idx ]+9 );
  fList.Delete( Idx );
  Dec( fCount );
end;

destructor TFastStrListEx.Destroy;
begin
  FastClear := FALSE;
  Clear;
  fList.Free;
  inherited;
end;

function TFastStrListEx.Find(const S: AnsiString; var Index: Integer): Boolean;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if (ItemLen[ i ] = Length( S )) and
       ((S = '') or CompareMem( ItemPtrs[ i ], @ S[ 1 ], Length( S ) )) then
       begin
         Index := i;
         Result := TRUE;
         Exit;
       end;
  Result := FALSE;
end;

function TFastStrListEx.Get(Idx: integer): AnsiString;
begin
  if (Idx >= 0) and (Idx <= Count) then
    SetString( Result, PAnsiChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 8 ),
               ItemLen[ Idx ] )
  else
    Result := '';
end;

function TFastStrListEx.GetItemLen(Idx: Integer): Integer;
var Src: PDWORD;
begin
  if (Idx >= 0) and (Idx <= Count) then
  begin
    Src := PDWORD( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 4 );
    Result := Src^
  end
    else Result := 0;
end;

function TFastStrListEx.GetObject(Idx: Integer): DWORD;
var Src: PDWORD;
begin
  if (Idx >= 0) and (Idx <= Count) then
  begin
    Src := PDWORD( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) );
    Result := Src^
  end
    else Result := 0;
end;

function TFastStrListEx.GetPChars(Idx: Integer): PAnsiChar;
begin
  if (Idx >= 0) and (Idx <= Count) then
    Result := PAnsiChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 8 )
  else Result := nil;
end;

function TFastStrListEx.GetTextStr: AnsiString;
var L, i: Integer;
    p: PAnsiChar;
begin
  L := 0;
  for i := 0 to Count-1 do
    Inc( L, ItemLen[ i ] + 2 );
  SetLength( Result, L );
  p := PAnsiChar( Result );
  for i := 0 to Count-1 do
  begin
    L := ItemLen[ i ];
    if L > 0 then
    begin
      System.Move( ItemPtrs[ i ]^, p^, L );
      Inc( p, L );
    end;
    p^ := #13; Inc( p );
    p^ := #10; Inc( p );
  end;
end;

function TFastStrListEx.IndexOf(const S: AnsiString): integer;
begin
  if not Find( S, Result ) then Result := -1;
end;

function TFastStrListEx.IndexOf_NoCase(const S: AnsiString): integer;
begin
  Result := IndexOfStrL_NoCase( PAnsiChar( S ), Length( S ) );
end;

function TFastStrListEx.IndexOfStrL_NoCase(Str: PAnsiChar;
  L: Integer): integer;
var i: Integer;
begin
  for i := 0 to Count-1 do
    if (ItemLen[ i ] = L) and
       ((L = 0) or (StrLComp_NoCase( ItemPtrs[ i ], Str, L ) = 0)) then
       begin
         Result := i;
         Exit;
       end;
  Result := -1;
end;

procedure TFastStrListEx.Init;
begin
  fList := NewList;
  FastClear := TRUE;
end;

procedure TFastStrListEx.InsertAnsi(Idx: integer; const S: AnsiString);
begin
  InsertObjectLen( Idx, PAnsiChar( S ), Length( S ), 0 );
end;

procedure TFastStrListEx.InsertAnsiObject(Idx: integer; const S: AnsiString;
  Obj: DWORD);
begin
  InsertObjectLen( Idx, PAnsiChar( S ), Length( S ), Obj );
end;

procedure TFastStrListEx.Insert(Idx: integer; S: PAnsiChar);
begin
  InsertObjectLen( Idx, S, StrLen( S ), 0 )
end;

procedure TFastStrListEx.InsertLen(Idx: Integer; S: PAnsiChar; Len: Integer);
begin
  InsertObjectLen( Idx, S, Len, 0 )
end;

procedure TFastStrListEx.InsertObject(Idx: Integer; S: PAnsiChar; Obj: DWORD);
begin
  InsertObjectLen( Idx, S, StrLen( S ), Obj );
end;

procedure TFastStrListEx.InsertObjectLen(Idx: Integer; S: PAnsiChar;
  Len: Integer; Obj: DWORD);
var Dest: PAnsiChar;
begin
  ProvideSpace( Len+9 );
  Dest := PAnsiChar( DWORD( fTextBuf ) + fUsedSiz );
  fList.Insert( Idx, Pointer( DWORD(Dest)-DWORD(fTextBuf) ) );
  PDWORD( Dest )^ := Obj;
  Inc( Dest, 4 );
  PDWORD( Dest )^ := Len;
  Inc( Dest, 4 );
  if S <> nil then
    System.Move( S^, Dest^, Len );
  Inc( Dest, Len );
  Dest^ := #0;
  Inc( fUsedSiz, Len+9 );
  Inc( fCount );
end;

function TFastStrListEx.Last: AnsiString;
begin
  if Count > 0 then
    Result := Items[ Count-1 ]
  else
    Result := '';
end;

function TFastStrListEx.LoadFromFile(const FileName: AnsiString): Boolean;
var Strm: PStream;
begin
  Strm := NewReadFileStream( KOLString(FileName) );
  TRY
    Result := Strm.Handle <> INVALID_HANDLE_VALUE;
    if Result then
      LoadFromStream( Strm, FALSE )
    else
      Clear;
  FINALLY
    Strm.Free;
  END;
end;

procedure TFastStrListEx.LoadFromStream(Stream: PStream;
  Append2List: boolean);
var Txt: AnsiString;
begin
  SetLength( Txt, Stream.Size - Stream.Position );
  Stream.Read( Txt[ 1 ], Stream.Size - Stream.Position );
  SetText( Txt, Append2List );
end;

procedure TFastStrListEx.MergeFromFile(const FileName: AnsiString);
var Strm: PStream;
begin
  Strm := NewReadFileStream( KOLString(FileName) );
  TRY
    LoadFromStream( Strm, TRUE );
  FINALLY
    Strm.Free;
  END;
end;

procedure TFastStrListEx.Move(CurIndex, NewIndex: integer);
begin
  Assert( (CurIndex >= 0) and (CurIndex < Count) and (NewIndex >= 0) and
          (NewIndex < Count), 'Item indexes violates TFastStrListEx range' );
  fList.MoveItem( CurIndex, NewIndex );
end;

procedure TFastStrListEx.ProvideSpace(AddSize: DWORD);
var OldTextBuf: PAnsiChar;
begin
  Inc( AddSize, 9 );
  if AddSize > fTextSiz - fUsedSiz then
  begin // увеличение размер?буфера
    fTextSiz := Max( 1024, (fUsedSiz + AddSize) * 2 );
    OldTextBuf := fTextBuf;
    GetMem( fTextBuf, fTextSiz );
    if OldTextBuf <> nil then
    begin
      System.Move( OldTextBuf^, fTextBuf^, fUsedSiz );
      FreeMem( OldTextBuf );
    end;
  end;
  if fList.Count >= fList.Capacity then
    fList.Capacity := Max( 100, fList.Count * 2 );
end;

procedure TFastStrListEx.Put(Idx: integer; const Value: AnsiString);
var Dest: PAnsiChar;
    OldLen: Integer;
    OldObj: DWORD;
begin
  OldLen := ItemLen[ Idx ];
  if Length( Value ) <= OldLen then
  begin
    Dest := PAnsiChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) + 4 );
    PDWORD( Dest )^ := Length( Value );
    Inc( Dest, 4 );
    if Value <> '' then
      System.Move( Value[ 1 ], Dest^, Length( Value ) );
    Inc( Dest, Length( Value ) );
    Dest^ := #0;
    if Idx = Count-1 then
      Dec( fUsedSiz, OldLen - Length( Value ) );
  end
    else
  begin
    OldObj := 0;
    while Idx > Count do
      AddObjectLen( nil, 0, 0 );
    if Idx = Count-1 then
    begin
      OldObj := Objects[ Idx ];
      Delete( Idx );
    end;
    if Idx = Count then
      AddObjectLen( PAnsiChar( Value ), Length( Value ), OldObj )
    else
    begin
      ProvideSpace( Length( Value ) + 9 );
      Dest := PAnsiChar( DWORD( fTextBuf ) + fUsedSiz );
      fList.Items[ Idx ] := Pointer( DWORD(Dest)-DWORD(fTextBuf) );
      Inc( Dest, 4 );
      PDWORD( Dest )^ := Length( Value );
      Inc( Dest, 4 );
      if Value <> '' then
        System.Move( Value[ 1 ], Dest^, Length( Value ) );
      Inc( Dest, Length( Value ) );
      Dest^ := #0;
      Inc( fUsedSiz, Length( Value )+9 );
    end;
  end;
end;

function TFastStrListEx.SaveToFile(const FileName: AnsiString): Boolean;
var Strm: PStream;
begin
  Strm := NewWriteFileStream( KOLString(FileName) );
  TRY
    if Strm.Handle <> INVALID_HANDLE_VALUE then
    SaveToStream( Strm );
    Result := TRUE;
  FINALLY
    Strm.Free;
  END;
end;

procedure TFastStrListEx.SaveToStream(Stream: PStream);
var Txt: AnsiString;
begin
  Txt := Text;
  Stream.Write( PAnsiChar( Txt )^, Length( Txt ) );
end;

procedure TFastStrListEx.SetObject(Idx: Integer; const Value: DWORD);
var Dest: PDWORD;
begin
  if Idx < 0 then Exit;
  while Idx >= Count do
    AddObjectLen( nil, 0, 0 );
  Dest := PDWORD( DWORD( fTextBuf ) + DWORD( fList.Items[ Idx ] ) );
  Dest^ := Value;
end;

procedure TFastStrListEx.SetText(const S: AnsiString; Append2List: boolean);
var Len2Add, NLines, L: Integer;
    p0, p: PAnsiChar;
begin
  if not Append2List then Clear;
  // подсче?требуемого пространства
  Len2Add := 0;
  NLines := 0;
  p := PAnsichar( S );
  p0 := p;
  L := Length( S );
  while L > 0 do
  begin
    if p^ = #13 then
    begin
      Inc( NLines );
      Inc( Len2Add, 9 + DWORD(p)-DWORD(p0) );
      REPEAT Inc( p ); Dec( L );
      UNTIL  (p^ <> #10) or (L = 0);
      p0 := p;
    end
      else
    begin
      Inc( p ); Dec( L );
    end;
  end;
  if DWORD(p) > DWORD(p0) then
  begin
    Inc( NLines );
    Inc( Len2Add, 9 + DWORD(p)-DWORD(p0) );
  end;
  if Len2Add = 0 then Exit;
  // добавление
  ProvideSpace( Len2Add - 9 );
  if fList.Capacity <= fList.Count + NLines then
    fList.Capacity := Max( (fList.Count + NLines) * 2, 100 );
  p := PAnsiChar( S );
  p0 := p;
  L := Length( S );
  while L > 0 do
  begin
    if p^ = #13 then
    begin
      AddObjectLen( p0, DWORD(p)-DWORD(p0), 0 );
      REPEAT Inc( p ); Dec( L );
      UNTIL  (p^ <> #10) or (L = 0);
      p0 := p;
    end
      else
    begin
      Inc( p ); Dec( L );
    end;
  end;
  if DWORD(p) > DWORD(p0) then
    AddObjectLen( p0, DWORD(p)-DWORD(p0), 0 );
end;

procedure TFastStrListEx.SetTextStr(const Value: AnsiString);
begin
  SetText( Value, FALSE );
end;

function CompareFast(const Data: Pointer; const e1,e2 : Dword) : Integer;
var FSL: PFastStrListEx;
    L1, L2: Integer;
    S1, S2: PAnsiChar;
begin
  FSL := Data;
  S1 := FSL.ItemPtrs[ e1 ];
  S2 := FSL.ItemPtrs[ e2 ];
  L1 := FSL.ItemLen[ e1 ];
  L2 := FSL.ItemLen[ e2 ];
  if FSL.fCaseSensitiveSort then
    Result := StrLComp( S1, S2, Min( L1, L2 ) )
  else
    Result := StrLComp_NoCase( S1, S2, Min( L1, L2 ) );
  if Result = 0 then
    Result := L1 - L2;
  if Result = 0 then
    Result := e1 - e2;
end;

procedure SwapFast(const Data : Pointer; const e1,e2 : Dword);
var FSL: PFastStrListEx;
begin
  FSL := Data;
  FSL.Swap( e1, e2 );
end;

procedure TFastStrListEx.Sort(CaseSensitive: Boolean);
begin
  fCaseSensitiveSort := CaseSensitive;
  SortData( @ Self, Count, CompareFast, SwapFast );
end;

procedure TFastStrListEx.Swap(Idx1, Idx2: Integer);
begin
  Assert( (Idx1 >= 0) and (Idx1 <= Count-1) and (Idx2 >= 0) and (Idx2 <= Count-1),
          'Item indexes violates TFastStrListEx range' );
  fList.Swap( Idx1, Idx2 );
end;

function TFastStrListEx.GetValues(AName: PAnsiChar): PAnsiChar;
var i: Integer;
    s, n: PAnsiChar;
begin
  if not Upper_Initialized then
    InitUpper;
  for i := 0 to Count-1 do
  begin
    s := ItemPtrs[ i ];
    n := AName;
    while (Upper[ s^ ] = Upper[ n^ ]) and (s^ <> '=') and (s^ <> #0) and (n^ <> #0) do
    begin
      Inc( s );
      Inc( n );
    end;
    if (s^ = '=') and (n^ = #0) then
    begin
      Result := s;
      Inc( Result );
      Exit;
    end;
  end;
  Result := nil;
end;

function TFastStrListEx.IndexOfName(AName: PAnsiChar): Integer;
var i: Integer;
    s, n: PAnsiChar;
begin
  if not Upper_Initialized then
    InitUpper;
  for i := 0 to Count-1 do
  begin
    s := ItemPtrs[ i ];
    n := AName;
    while (Upper[ s^ ] = Upper[ n^ ]) and (s^ <> '=') and (s^ <> #0) and (n^ <> #0) do
    begin
      Inc( s );
      Inc( n );
    end;
    if (s^ = '=') and (n^ = #0) then
    begin
      Result := i;
      Exit;
    end;
  end;
  Result := -1;
end;

procedure TFastStrListEx.Append(S: PAnsiChar);
begin
  AppendLen( S, StrLen( S ) );
end;

procedure TFastStrListEx.AppendInt2Hex(N: DWORD; MinDigits: Integer);
var Buffer: array[ 0..9 ] of Char;
    Mask: DWORD;
    i, Len: Integer;
    B: Byte;
begin
  if MinDigits > 8 then
    MinDigits := 8;
  if MinDigits <= 0 then
    MinDigits := 1;
  Mask := $F0000000;
  for i := 8 downto MinDigits do
  begin
    if Mask and N <> 0 then
    begin
      MinDigits := i;
      break;
    end;
    Mask := Mask shr 4;
  end;
  i := 0;
  Len := MinDigits;
  Mask := $F shl ((Len - 1)*4);
  while MinDigits > 0 do
  begin
    Dec( MinDigits );
    B := (N and Mask) shr (MinDigits * 4);
    Mask := Mask shr 4;
    if B <= 9 then
      Buffer[ i ] := Char( B + Ord( '0' ) )
    else
      Buffer[ i ] := Char( B + Ord( 'A' ) - 10 );
    Inc( i );
  end;
  Buffer[ i ] := #0;
  AppendLen( @ Buffer[ 0 ], Len );
end;

procedure TFastStrListEx.AppendLen(S: PAnsiChar; Len: Integer);
var Dest: PAnsiChar;
begin
  if Count = 0 then
    AddLen( S, Len )
  else
  begin
    ProvideSpace( Len );
    Dest := PAnsiChar( DWORD( fTextBuf ) + fUsedSiz - 1 );
    System.Move( S^, Dest^, Len );
    Inc( Dest, Len );
    Dest^ := #0;
    Inc( fUsedSiz, Len );
    Dest := PAnsiChar( DWORD( fTextBuf ) + DWORD( fList.Items[ Count-1 ] ) );
    Inc( Dest, 4 );
    PDWORD( Dest )^ := PDWORD( Dest )^ + DWORD( Len );
  end;
end;


{ TCABFile }

//[function OpenCABFile]
function OpenCABFile( const APaths: array of AnsiString ): PCABFile;
var I: Integer;
begin
  New( Result, Create );
  Result.FSetupapi := LoadLibrary( 'setupapi.dll' );
  Result.FNames := NewKOLStrList;
  Result.FPaths := NewKOLStrList;
  for I := 0 to High( APaths ) do
      Result.FPaths.Add( KOLString(APaths[ I ]) );
end;

destructor TCABFile.Destroy;
begin
  FNames.Free;
  FPaths.Free;
  FTargetPath := '';
  if  FSetupapi <> 0 then
      FreeLibrary( FSetupapi );
  inherited;
end;

const
  SPFILENOTIFY_FILEINCABINET  = $11;
  SPFILENOTIFY_NEEDNEWCABINET = $12;

type
  PSP_FILE_CALLBACK = function( Context: Pointer; Notification, Param1, Param2: DWORD ): DWORD;
  stdcall;

  TSetupIterateCabinet = function ( CabinetFile: PKOLChar; Reserved: DWORD;
         MsgHandler: PSP_FILE_CALLBACK; Context: Pointer ): Boolean; stdcall;
         //external 'setupapi.dll' name 'SetupIterateCabinetA';

  TSetupPromptDisk = function (
    hwndParent: HWND; 	// parent window of the dialog box
    DialogTitle: PKOLChar;	// optional, title of the dialog box
    DiskName: PKOLChar;	// optional, name of disk to insert
    PathToSource: PKOLChar;// optional, expected source path
    FileSought: PKOLChar;	// name of file needed
    TagFile: PKOLChar;	// optional, source media tag file
    DiskPromptStyle: DWORD;	// specifies dialog box behavior
    PathBuffer: PKOLChar;	// receives the source location
    PathBufferSize: DWORD;	// size of the supplied buffer
    PathRequiredSize: PDWORD	// optional, buffer size needed
   ): DWORD; stdcall;
   //external 'setupapi.dll' name 'SetupPromptForDiskA';

type
  TCabinetInfo = packed record
    CabinetPath: PKOLChar;
    CabinetFile: PKOLChar;
    DiskName: PKOLChar;
    SetId: WORD;
    CabinetNumber: WORD;
  end;
  PCabinetInfo = ^TCabinetInfo;

  TFileInCabinetInfo = packed record
    NameInCabinet: PKOLChar;
    FileSize: DWORD;
    Win32Error: DWORD;
    DosDate: WORD;
    DosTime: WORD;
    DosAttribs: WORD;
    FullTargetName: array[0..MAX_PATH-1] of KOLChar;
  end;
  PFileInCabinetInfo = ^TFileInCabinetInfo;

//[function CABCallback]
function CABCallback( Context: Pointer; Notification, Param1, Param2: DWORD ): DWORD;
stdcall;
var CAB: PCABFile;
    CABPath, OldPath: KOLString;
    CABInfo: PCabinetInfo;
    CABFileInfo: PFileInCabinetInfo;
    hr: Integer;
    SetupPromptProc: TSetupPromptDisk;
begin
  Result := 0;
  CAB := Context;
  case Notification of
  SPFILENOTIFY_NEEDNEWCABINET:
    begin
      OldPath := CAB.FPaths.Items[ CAB.FCurCAB ];
      Inc( CAB.FCurCAB );
      if CAB.FCurCAB = CAB.FPaths.Count then
        CAB.FPaths.Add( '?' );
      CABPath := CAB.FPaths.Items[ CAB.FCurCAB ];
      if CABPath = '?' then
      begin
        if Assigned( CAB.FOnNextCAB ) then
          CAB.FPaths.Items[CAB.FCurCAB ] := CAB.FOnNextCAB( CAB );
        CABPath := CAB.FPaths.Items[ CAB.FCurCAB ];
        if CABPath = '?' then
        begin
          SetLength( CABPath, MAX_PATH );
          CABInfo := Pointer( Param1 );
          if CAB.FSetupapi <> 0 then
            SetupPromptProc := GetProcAddress( CAB.FSetupapi, 'SetupPromptForDiskA' )
          else
            SetupPromptProc := nil;
          if Assigned( SetupPromptProc ) then
          begin
            hr := SetupPromptProc( 0, nil, nil, PKOLChar( ExtractFilePath( OldPath ) ),
                 CABInfo.CabinetFile, nil, 2 {IDF_NOSKIP}, @CabPath[ 1 ], MAX_PATH, nil );
            case hr of
            0: // success
              begin
                {$IFDEF UNICODE_CTRLS} WStrCopy {$ELSE} StrCopy {$ENDIF}
                  ( PKOLChar( Param2 ), PKOLChar( CABPath ) );
                Result := 0;
              end;
            2: // skip file
              Result := 0;
            else // cancel
              Result := ERROR_FILE_NOT_FOUND;
            end;
          end;
        end
          else
        begin
          {$IFDEF UNICODE_CTRLS} WStrCopy {$ELSE} StrCopy {$ENDIF}
            ( PKOLChar( Param2 ), PKOLChar( CABPath ) );
          Result := 0;
        end;
      end;
    end;
  SPFILENOTIFY_FILEINCABINET:
    begin
      CABFileInfo := Pointer( Param1 );
      if CAB.FGettingNames then
      begin
        CAB.FNames.Add( CABFileInfo.NameInCabinet );
        Result := 2; // FILEOP_SKIP
      end
        else
      begin
        CABPath := CABFileInfo.NameInCabinet;
        if Assigned( CAB.FOnFile ) then
        begin
          if CAB.FOnFile( CAB, CABPath ) then
          begin
            if ExtractFilePath( CABPath ) = '' then
            if CAB.FTargetPath <> '' then
              CABPath := CAB.TargetPath + CABPath;
            {$IFDEF UNICODE_CTRLS} WStrCopy {$ELSE} StrCopy {$ENDIF}
              ( @CABFileInfo.FullTargetName[ 0 ], PKOLChar( CABPath ) );
            Result := 1; // FILEOP_DOIT
          end
          else
            Result := 2
        end
        else
        begin
          if CAB.FTargetPath <> '' then
            {$IFDEF UNICODE_CTRLS} WStrCopy {$ELSE} StrCopy {$ENDIF}
              ( @CABFileInfo.FullTargetName[ 0 ],
              PKOLChar( CAB.TargetPath + CABPath ) );
          Result := 1;
        end;
      end;
    end;
  end;
end;

//[function TCABFile.Execute]
function TCABFile.Execute: Boolean;
var SetupIterateProc: TSetupIterateCabinet;
begin
  FCurCAB := 0;
  Result := FALSE;
  if FSetupapi = 0 then Exit;
  SetupIterateProc := GetProcAddress( FSetupapi, 'SetupIterateCabinetA' );
  if not Assigned( SetupIterateProc ) then Exit;
  Result := SetupIterateProc( PKOLChar( KOLString( FPaths.Items[ 0 ] ) ),
    0, CABCallback, @Self );
end;

//[function TCABFile.GetCount]
function TCABFile.GetCount: Integer;
begin
  GetNames( 0 );
  Result := FNames.Count;
end;

//[function TCABFile.GetNames]
function TCABFile.GetNames(Idx: Integer): KOLString;
begin
  if FNames.Count = 0 then
  begin
    FGettingNames := TRUE;
    Execute;
    FGettingNames := FALSE;
  end;
  Result := '';
  if Idx < FNames.Count then
    Result := FNames.Items[ Idx ];
end;

//[function TCABFile.GetPaths]
function TCABFile.GetPaths(Idx: Integer): KOLString;
begin
  Result := FPaths.Items[ Idx ];
end;

//[function TCABFile.GetTargetPath]
function TCABFile.GetTargetPath: KOLString;
begin
  Result := FTargetPath;
  if Result <> '' then
  if Result[ Length( Result ) ] <> '\' then
    Result := Result + '\';
end;

{ -- TDirChange -- }

const FilterFlags: array[ TFileChangeFilters ] of Integer = (
      FILE_NOTIFY_CHANGE_FILE_NAME, FILE_NOTIFY_CHANGE_DIR_NAME,
      FILE_NOTIFY_CHANGE_ATTRIBUTES, FILE_NOTIFY_CHANGE_SIZE,
      FILE_NOTIFY_CHANGE_LAST_WRITE, $20 {FILE_NOTIFY_CHANGE_LAST_ACCESS},
      $40 {FILE_NOTIFY_CHANGE_CREATION}, FILE_NOTIFY_CHANGE_SECURITY );

//[FUNCTION _NewDirChgNotifier]
{$IFDEF ASM_UNICODE}
function _NewDirChgNotifier: PDirChange;
begin
  New( Result, Create );
end;
//[function NewDirChangeNotifier]
function NewDirChangeNotifier( const Path: KOLString; Filter: TFileChangeFilter;
                               WatchSubtree: Boolean; ChangeProc: TOnDirChange )
                               : PDirChange;
const Dflt_Flags = FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or
      FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or
      FILE_NOTIFY_CHANGE_LAST_WRITE;
asm
        PUSH     EBX
        PUSH     ECX // [EBP-8] = WatchSubtree
        PUSH     EDX // [EBP-12] = Filter
        PUSH     EAX // [EBP-16] = Path
        CALL     _NewDirChgNotifier
        XCHG     EBX, EAX
        LEA      EAX, [EBX].TDirChange.FPath
        POP      EDX
        CALL     System.@LStrAsg
        MOV      EAX, [ChangeProc].TMethod.Code
        MOV      [EBX].TDirChange.FOnChange.TMethod.Code, EAX
        MOV      EAX, [ChangeProc].TMethod.Data
        MOV      [EBX].TDirChange.FOnChange.TMethod.Data, EAX
        POP      ECX
        MOV      EAX, Dflt_Flags
        MOVZX    ECX, CL
        JECXZ    @@flags_ready
        PUSH     ECX
        MOV      EAX, ESP
        MOV      EDX, offset[FilterFlags]
        XOR      ECX, ECX
        MOV      CL, 7
        CALL     MakeFlags
        POP      ECX
@@flags_ready:           // EAX = Flags
        POP      EDX
        MOVZX    EDX, DL // EDX = WatchSubtree
        PUSH     EAX
        PUSH     EDX
        PUSH     [EBX].TDirChange.FPath
        CALL     FindFirstChangeNotification
        MOV      [EBX].TDirChange.FHandle, EAX
        INC      EAX
        JZ       @@fault
        PUSH     EBX
        PUSH     offset[TDirChange.Execute]
        CALL     NewThreadEx
        MOV      [EBX].TDirChange.FMonitor, EAX
        JMP      @@exit
@@fault:
        XCHG     EAX, EBX
        CALL     TObj.Destroy
@@exit:
        XCHG     EAX, EBX
        POP      EBX
end;
{$ELSE ASM_VERSION} //Pascal
function NewDirChangeNotifier( const Path: KOLString; Filter: TFileChangeFilter;
                               WatchSubtree: Boolean; ChangeProc: TOnDirChange
                               {$IFDEF DIRCHG_ONEXECUTE}; OnExecuteProc: TOnEvent
                               {$ENDIF} )
                               : PDirChange;
begin
  New( Result, Create );
  {$IFDEF DIRCHG_ONEXECUTE}
  Result.OnExecute := OnExecuteProc;
  {$ENDIF}

  Result.FPath := Path;
  Result.FWatchSubtree := WatchSubtree;
  Result.FOnChange := ChangeProc;
  if  Filter = [ ] then
      Result.FFlags := FILE_NOTIFY_CHANGE_FILE_NAME or FILE_NOTIFY_CHANGE_DIR_NAME or
      FILE_NOTIFY_CHANGE_ATTRIBUTES or FILE_NOTIFY_CHANGE_SIZE or
      FILE_NOTIFY_CHANGE_LAST_WRITE
  else
      Result.FFlags := MakeFlags( @Filter, FilterFlags );
  Result.FMonitor := NewThreadEx( Result.Execute )
end;
{$ENDIF ASM_VERSION}
//[END _NewDirChgNotifier]

{ TDirChange }

{$IFDEF ASM_VERSION}
//[procedure TDirChange.Changed]
procedure TDirChange.Changed;
asm
        MOV      ECX, [EAX].FOnChange.TMethod.Code
        JECXZ    @@exit
        MOV      ECX, [EAX].FPath
        XCHG     EDX, EAX
        MOV      EAX, [EDX].FOnChange.TMethod.Data
        CALL     [EDX].FOnChange.TMethod.Code
@@exit:
end;
{$ELSE ASM_VERSION} //Pascal
procedure TDirChange.Changed;
begin
  if Assigned( FOnChange ) then
    FOnChange(@Self, FPath);
end;
{$ENDIF ASM_VERSION}

{$IFDEF noASM_VERSION}
//[destructor TDirChange.Destroy]
destructor TDirChange.Destroy;
asm
        PUSH     EBX
        XCHG     EBX, EAX
        MOV      [EBX].FDestroying, 1
        MOV      ECX, [EBX].FMonitor
        JECXZ    @@no_monitor
        XCHG     EAX, ECX
        CALL     TObj.Destroy // TObj.Free //
@@no_monitor:
        MOV      ECX, [EBX].FHandle
        JECXZ    @@exit
        PUSH     ECX
        CALL     FindCloseChangeNotification
@@exit:
        LEA      EAX, [EBX].FPath
        CALL     System.@LStrClr
        XCHG     EAX, EBX
        CALL     TObj.Destroy
        POP      EBX
end;
{$ELSE ASM_VERSION} //Pascal
destructor TDirChange.Destroy;
begin
  FDestroying := TRUE;
  if FHandle > 0 then // FHandle <> INVALID_HANDLE_VALUE AND FHandle <> 0
  begin
    OnChange := nil;
    SetEvent( FinEvent );
  end;
  while FinEvent <> 0 do
  begin
      if  Applet <> nil then
          Applet.ProcessMessages; // otherwise deadlock is possible !!!
      Sleep( 1 );                 // otherwise processor load can be too high !!!
      if  AppletTerminated then
          break;
  end;
  FMonitor.Free;
  FPath := '';
  inherited;
end;
{$ENDIF ASM_VERSION}

{$IFDEF ASM_noVERSION}
//[function TDirChange.Execute]
function TDirChange.Execute(Sender: PThread): Integer;
asm
        PUSH     EBX
        PUSH     ESI
        XCHG     EBX, EAX
        MOV      ESI, EDX
@@loo:
        MOVZX    ECX, [ESI].TThread.FTerminated
        INC      ECX
        LOOP     @@e_loop

        MOV      ECX, [EBX].FHandle
        INC      ECX
        JZ       @@e_loop

        PUSH     INFINITE
        PUSH     ECX
        CALL     WaitForSingleObject
        OR       EAX, EAX
        JNZ      @@loo

        PUSH     [EBX].FHandle
        MOV      EAX, [EBX].FMonitor
        PUSH     EBX
        PUSH     offset[TDirChange.Changed]
        CALL     TThread.Synchronize
        CALL     FindNextChangeNotification
        JMP      @@loo
@@e_loop:

        POP      ESI
        POP      EBX
        XOR      EAX, EAX
end;
{$ELSE ASM_VERSION} //Pascal
function TDirChange.Execute(Sender: PThread): Integer;
var Handles: array[ 0..1 ] of THandle;
    //i: Integer;
begin
  {$IFDEF DIRCHG_ONEXECUTE}
  if  Assigned( OnExecute ) then
      OnExecute( @ Self );
  {$ENDIF}
  FinEvent := CreateEvent( nil, TRUE, FALSE, nil );
  FHandle := FindFirstChangeNotification(PKOLChar(FPath),
          Bool( Integer( FWatchSubtree ) ), FFlags);
  Handles[ 0 ] := FHandle;
  Handles[ 1 ] := FinEvent;
  while not AppletTerminated do
    case WaitForMultipleObjects(2, @ Handles[ 0 ], FALSE, INFINITE) of
    WAIT_OBJECT_0:
      begin
        if AppletTerminated or FDestroying then break;
        Sender.Synchronize( Changed );
        FindNextChangeNotification(Handles[ 0 ]);
      end;
    else break;
    end;
  {$IFDEF SAFE_CODE}
  TRY
  {$ENDIF}
  FindCloseChangeNotification( Handles[ 0 ] );
  FHandle := 0;
  CloseHandle( FinEvent );
  FinEvent := 0;
  {$IFDEF SAFE_CODE}
  EXCEPT
  END;
  {$ENDIF}
  Result := 0;
end;
{$ENDIF ASM_VERSION}

////////////////////////////////////////////////////////////////////////
//
//
//                         M  E T A F I L E
//
//
////////////////////////////////////////////////////////////////////////

function NewMetafile: PMetafile;
begin
  new( Result, Create );
end;

{ TMetafile }

procedure TMetafile.Clear;
begin
  if fHandle <> 0 then
    DeleteEnhMetaFile( fHandle );
  fHandle := 0;
end;

destructor TMetafile.Destroy;
begin
  if fHeader <> nil then
    FreeMem( fHeader );
  Clear;
  inherited;
end;

procedure TMetafile.Draw(DC: HDC; X, Y: Integer);
begin
  StretchDraw( DC, MakeRect( X, Y, X + Width, Y + Height ) );
end;

function TMetafile.Empty: Boolean;
begin
  Result := fHandle = 0;
end;

function TMetafile.GetHeight: Integer;
begin
  Result := 0;
  if Empty then Exit;
  RetrieveHeader;
  Result := fHeader.rclBounds.Bottom - fHeader.rclBounds.Top;
end;

function TMetafile.GetWidth: Integer;
begin
  Result := 0;
  if Empty then Exit;
  RetrieveHeader;
  Result := fHeader.rclBounds.Right - fHeader.rclBounds.Left;
end;

function TMetafile.LoadFromFile(const Filename: AnsiString): Boolean;
var Strm: PStream;
begin
  Strm := NewReadFileStream( KOLString(FileName ));
  Result := LoadFromStream( Strm );
  Strm.Free;
end;

function ComputeAldusChecksum(var WMF: TMetafileHeader): Word;
type
  PWord = ^Word;
var
  pW: PWord;
  pEnd: PWord;
begin
  Result := 0;
  pW := @WMF;
  pEnd := @WMF.CheckSum;
  while Longint(pW) < Longint(pEnd) do
  begin
    Result := Result xor pW^;
    Inc(Longint(pW), SizeOf(Word));
  end;
end;

function TMetafile.LoadFromStream(Strm: PStream): Boolean;
var WMF: TMetaFileHeader;
    WmfHdr: TMetaHeader;
    EnhHdr: TEnhMetaHeader;
    Pos, Pos1: Integer;
    Sz: Integer;
    MemStrm: PStream;
    MFP: TMetafilePict;
begin
  Result := FALSE;
  Pos := Strm.Position;

  if Strm.Read( WMF, Sizeof( WMF ) ) <> Sizeof( WMF ) then
  begin
    Strm.Position := Pos;
    Exit;
  end;

  MemStrm := NewMemoryStream;

  if WMF.Key = WMFKey then
  begin // Windows metafile

    if WMF.CheckSum <> ComputeAldusChecksum( WMF ) then
    begin
      Strm.Position := Pos;
      Exit;
    end;

    Pos1 := Strm.Position;
    if Strm.Read( WmfHdr, Sizeof( WmfHdr ) ) <> Sizeof( WmfHdr ) then
    begin
      Strm.Position := Pos;
      Exit;
    end;

    Strm.Position := Pos1;
    Sz := WMFHdr.mtSize * 2;
    Stream2Stream( MemStrm, Strm, Sz );
    FillChar( MFP, Sizeof( MFP ), #0 );
    MFP.mm := MM_ANISOTROPIC;
    fHandle := SetWinMetafileBits( Sz, MemStrm.Memory, 0, MFP );

  end
    else
  begin // may be enchanced?

    Strm.Position := Pos;
    if Strm.Read( EnhHdr, Sizeof( EnhHdr ) ) < 8 then
    begin
      Strm.Position := Pos;
      Exit;
    end;
    // yes, enchanced
    Strm.Position := Pos;
    Sz := EnhHdr.nBytes;
    Stream2Stream( MemStrm, Strm, Sz );
    fHandle := SetEnhMetaFileBits( Sz, MemStrm.Memory );

  end;

  MemStrm.Free;
  Result := fHandle <> 0;
  if not Result then
    Strm.Position := Pos;

end;

//[procedure TMetafile.RetrieveHeader]
procedure TMetafile.RetrieveHeader;
var SzHdr: Integer;
begin
  if fHeader = nil then
  begin
    SzHdr := GetEnhMetaFileHeader( fHandle, 0, nil );
    fHeader := AllocMem( { SzHeader } Sizeof( fHeader^ ) );
    fHeader.iType := EMR_HEADER;
    fHeader.nSize := Sizeof( fHeader^ ) { SzHdr };
    GetEnhMetaFileHeader( fHandle, SzHdr, fHeader );
  end;
end;

//[procedure TMetafile.SetHandle]
procedure TMetafile.SetHandle(const Value: THandle);
begin
  Clear;
  fHandle := Value;
end;

//[procedure TMetafile.StretchDraw]
procedure TMetafile.StretchDraw(DC: HDC; const R: TRect);
begin
  if Empty then Exit;
  PlayEnhMetaFile( DC, fHandle, R );
  {if not PlayEnhMetaFile( DC, fHandle, R ) then
  begin
    ShowMessage( SysErrorMessage( GetLastError ) );
  end;}
end;

{ ----------------------------------------------------------------------

                TAction and TActionList

----------------------------------------------------------------------- }
//[function NewActionList]
function NewActionList(AOwner: PControl): PActionList;
begin
  {-}
  New( Result, Create );
  {+} {++}(* Result := PActionList.Create; *){--}
  with Result{-}^{+} do begin
    FActions:=NewList;
    FOwner:=AOwner;
    RegisterIdleHandler(DoUpdateActions);
  end;
end;
//[END NewActionList]

//[function NewAction]
function NewAction(const ACaption, AHint: KOLString; AOnExecute: TOnEvent): PAction;
begin
  {-}
  New( Result, Create );
  {+} {++}(* Result := PAction.Create; *){--}
  with Result{-}^{+} do begin
    FControls:=NewList;
    Enabled:=True;
    Visible:=True;
    Caption:=ACaption;
    Hint:=AHint;
    OnExecute:=AOnExecute;
  end;
end;
//[END NewAction]

{ TAction }

//[procedure TAction.LinkCtrl]
procedure TAction.LinkCtrl(ACtrl: PObj; ACtrlKind: TCtrlKind; AItemID: integer; AUpdateProc: TOnUpdateCtrlEvent);
var
  cr: PControlRec;
begin
  New(cr);
  with cr^ do begin
    Ctrl:=ACtrl;
    CtrlKind:=ACtrlKind;
    ItemID:=AItemID;
    UpdateProc:=AUpdateProc;
  end;
  FControls.Add(cr);
  AUpdateProc(cr);
end;

//[procedure TAction.LinkControl]
procedure TAction.LinkControl(Ctrl: PControl);
begin
  LinkCtrl(Ctrl, ckControl, 0, UpdateCtrl);
  Ctrl.OnClick:=DoOnControlClick;
end;

//[procedure TAction.LinkMenuItem]
procedure TAction.LinkMenuItem(Menu: PMenu; MenuItemIdx: integer);
{$IFDEF _FPC}
var
  arr1_DoOnMenuItem: array[ 0..0 ] of TOnMenuItem;
{$ENDIF _FPC}
begin
  //LinkCtrl(Menu, ckMenu, MenuItemIdx, UpdateMenu); -- replaced by mdw to:
  LinkCtrl(Menu, ckMenu, Menu.Items[MenuItemIdx].MenuId, UpdateMenu);

  {$IFDEF _FPC}
  arr1_DoOnMenuItem[ 0 ] := DoOnMenuItem;
  Menu.AssignEvents(MenuItemIdx, arr1_DoOnMenuItem);
  {$ELSE}
  Menu.AssignEvents(MenuItemIdx, [ DoOnMenuItem ]);
  {$ENDIF}
end;

//[procedure TAction.LinkToolbarButton]
procedure TAction.LinkToolbarButton(Toolbar: PControl; ButtonIdx: integer);
{$IFDEF _FPC}
var
  arr1_DoOnToolbarButtonClick: array[ 0..0 ] of TOnToolbarButtonClick;
{$ENDIF _FPC}
begin
  LinkCtrl(Toolbar, ckToolbar, ButtonIdx, UpdateToolbar);
  {$IFDEF _FPC}
  arr1_DoOnToolbarButtonClick[ 0 ] := DoOnToolbarButtonClick;
  Toolbar.TBAssignEvents(ButtonIdx, arr1_DoOnToolbarButtonClick);
  {$ELSE}
  Toolbar.TBAssignEvents(ButtonIdx, [DoOnToolbarButtonClick]);
  {$ENDIF}
end;

//[destructor TAction.Destroy]
destructor TAction.Destroy;
begin
  FControls.Release;
  FCaption:='';
  FShortCut:='';
  FHint:='';
  inherited;
end;

//[procedure TAction.DoOnControlClick]
procedure TAction.DoOnControlClick(Sender: PObj);
begin
  Execute;
end;

//[procedure TAction.DoOnMenuItem]
procedure TAction.DoOnMenuItem(Sender: PMenu; Item: Integer);
begin
  Execute;
end;

//[procedure TAction.DoOnToolbarButtonClick]
procedure TAction.DoOnToolbarButtonClick(Sender: PControl; BtnID: Integer);
begin
  Execute;
end;

//[procedure TAction.Execute]
procedure TAction.Execute;
begin
  if Assigned(FOnExecute) and FEnabled then
    FOnExecute(PObj( @Self ));
end;

//[procedure TAction.SetCaption]
procedure TAction.SetCaption(const Value: KOLstring);
var
  i: integer;
  c, ss: KOLstring;

begin
  i:= IndexOfChar(Value, #9); //Pos(#9, Value);
  if i > 0 then begin
    c:=Copy(Value, 1, i - 1);
    ss:=Copy(Value, i + 1, MaxInt);
  end
  else begin
    c:=Value;
    ss:='';
  end;
  if (FCaption = c) and (FShortCut = ss) then exit;
  FCaption:=c;
  FShortCut:=ss;
  UpdateControls;
end;

//[procedure TAction.SetChecked]
procedure TAction.SetChecked(const Value: boolean);
begin
  if FChecked = Value then exit;
  FChecked := Value;
  UpdateControls;
end;

//[procedure TAction.SetEnabled]
procedure TAction.SetEnabled(const Value: boolean);
begin
  if FEnabled = Value then exit;
  FEnabled := Value;
  UpdateControls;
end;

//[procedure TAction.SetHelpContext]
procedure TAction.SetHelpContext(const Value: integer);
begin
  if FHelpContext = Value then exit;
  FHelpContext := Value;
  UpdateControls;
end;

//[procedure TAction.SetHint]
procedure TAction.SetHint(const Value: KOLString);
begin
  if FHint = Value then exit;
  FHint := Value;
  UpdateControls;
end;

//[procedure TAction.SetOnExecute]
procedure TAction.SetOnExecute(const Value: TOnEvent);
begin
  if @FOnExecute = @Value then exit;
  FOnExecute:=Value;
  UpdateControls;
end;

//[procedure TAction.SetVisible]
procedure TAction.SetVisible(const Value: boolean);
begin
  if FVisible = Value then exit;
  FVisible := Value;
  UpdateControls;
end;

//[procedure TAction.UpdateControls]
procedure TAction.UpdateControls;
var
  i: integer;
begin
  with FControls{-}^{+} do
    for i:=0 to Count - 1 do
      PControlRec(Items[i]).UpdateProc(Items[i]);
end;

//[procedure TAction.UpdateCtrl]
procedure TAction.UpdateCtrl(Sender: PControlRec);
begin
  with Sender^, PControl(Ctrl){-}^{+} do begin
    if Caption <> Self.FCaption then
      Caption:=Self.FCaption;
    if Enabled <> Self.FEnabled then
      Enabled:=Self.FEnabled;
    if Checked <> Self.FChecked then
      Checked:=Self.FChecked;
    if Visible <> Self.FVisible then
      Visible:=Self.FVisible;
  end;
end;

//[procedure TAction.UpdateMenu]
procedure TAction.UpdateMenu(Sender: PControlRec);
var
  s: KOLstring;
begin
  with Sender^, PMenu(Ctrl).Items[ItemID]{-}^{+} do begin
    s:=Self.FCaption;
    if Self.FShortCut <> '' then
      s:=s + #9 + Self.FShortCut;
    if Caption <> s then
      Caption:=s;
    if Enabled <> Self.FEnabled then
      Enabled:=Self.FEnabled;
    if Checked <> Self.FChecked then
      Checked:=Self.FChecked;
    if Visible <> Self.FVisible then
      Visible:=Self.FVisible;
    if HelpContext <> Self.FHelpContext then
      HelpContext:=Self.FHelpContext;
    if Self.FAccelerator.Key <> 0 then {YS}  // ƒобавить
      Accelerator:=Self.FAccelerator;
  end;
end;

//[procedure TAction.UpdateToolbar]
procedure TAction.UpdateToolbar(Sender: PControlRec);
var
  i: integer;
  s: KOLString;
begin
  with Sender^, PControl(Ctrl){-}^{+} do begin
    i:=TBIndex2Item(ItemID);
    s:=TBButtonText[i];
    if (s <> '') and (s <> Self.FCaption) then
      TBButtonText[i]:=Self.FCaption;
    TBSetTooltips(i, [PKOLChar(Self.FHint)]);
    if TBButtonEnabled[ItemID] <> Self.FEnabled then
      TBButtonEnabled[ItemID]:=Self.FEnabled;
    if TBButtonVisible[ItemID] <> Self.FVisible then
      TBButtonVisible[ItemID]:=Self.FVisible;
    if TBButtonChecked[ItemID] <> Self.FChecked then
      TBButtonChecked[ItemID]:=Self.FChecked;
  end;
end;

//[procedure TAction.SetAccelerator]
procedure TAction.SetAccelerator(const Value: TMenuAccelerator);
begin
  if (FAccelerator.fVirt = Value.fVirt) and (FAccelerator.Key = Value.Key) then exit;
  FAccelerator := Value;
  FShortCut:=GetAcceleratorText(FAccelerator);  // {YS}
  UpdateControls;
end;

{ TActionList }

//[function TActionList.Add]
function TActionList.Add(const ACaption, AHint: KOLstring; OnExecute: TOnEvent): PAction;
begin
  Result:=NewAction(ACaption, AHint, OnExecute);
  FActions.Add(Result);
end;

//[procedure TActionList.Clear]
procedure TActionList.Clear;
begin
  while FActions.Count > 0 do
    Delete(0);
  FActions.Clear;  
end;

//[procedure TActionList.Delete]
procedure TActionList.Delete(Idx: integer);
begin
  Actions[Idx].Free;
  FActions.Delete(Idx);
end;

//[destructor TActionList.Destroy]
destructor TActionList.Destroy;
begin
  UnRegisterIdleHandler(DoUpdateActions);
  Clear;
  FActions.Free;
  inherited;
end;

//[procedure TActionList.DoUpdateActions]
procedure TActionList.DoUpdateActions(Sender: PObj);
begin
  if Assigned(FOnUpdateActions) and (GetActiveWindow = FOwner.Handle) then
    FOnUpdateActions(PObj( @Self ));
end;

//[function TActionList.GetActions]
function TActionList.GetActions(Idx: integer): PAction;
begin
  Result:=FActions.Items[Idx];
end;

//[function TActionList.GetCount]
function TActionList.GetCount: integer;
begin
  Result:=FActions.Count;
end;

{ -- TTree -- }

{$IFDEF USE_CONSTRUCTORS}
//[function NewTree]
function NewTree( AParent: PTree; const AName: AnsiString ): PTree;
begin
  New( Result, CreateTree(  AParent, AName ) );
end;
//[END NewTree]
{$ELSE not_USE_CONSTRUCTORS}
//[function NewTree]
{$IFDEF TREE_NONAME}
function NewTree( AParent: PTree ): PTree;
begin
  {-}
  New( Result, Create );
  {+}{++}(*Result := PTree.Create;*){--}
  if AParent <> nil then
    AParent.Add( Result );
  Result.fParent := AParent;
end;
{$ELSE}
{$IFDEF TREE_WIDE}
function NewTree( AParent: PTree; const AName: WideString ): PTree;
begin
  {-}
  New( Result, Create );
  {+}{++}(*Result := PTree.Create;*){--}
  if AParent <> nil then
    AParent.Add( Result );
  Result.fParent := AParent;
  Result.fNodeName := AName;
end;
{$ELSE}
function NewTree( AParent: PTree; const AName: AnsiString ): PTree;
begin
  {-}
  New( Result, Create );
  {+}{++}(*Result := PTree.Create;*){--}
  if AParent <> nil then
    AParent.Add( Result );
  Result.fParent := AParent;
  Result.fNodeName := AName;
end;
{$ENDIF}
{$ENDIF}
//[END NewTree]
{$ENDIF USE_CONSTRUCTORS}

{ TTree }

//[procedure TTree.Add]
procedure TTree.Add(Node: PTree);
var Previous: PTree;
begin
  Node.Unlink;
  if fChildren = nil then begin
    fChildren := NewList;
  end;
  Previous := nil;
  if fChildren.Count > 0 then
    Previous := fChildren.Items[ fChildren.Count - 1 ];
  if Previous <> nil then
  begin
    Previous.fNext := Node;
    Node.fPrev := Previous;
  end;
  fChildren.Add( Node );
  Node.fParent := @Self;
end;

//[procedure TTree.Clear]
procedure TTree.Clear;
var I: Integer;
begin
  if fChildren = nil then Exit;
  for I := fChildren.Count - 1 downto 0 do
    PTree( fChildren.Items[ I ] ).Free;
end;

{$IFDEF USE_CONSTRUCTORS}
//[constructor TTree.CreateTree]
constructor TTree.CreateTree(AParent: PTree; const AName: AnsiString);
begin
  inherited Create;
  if AParent <> nil then
    AParent.Add( @Self );
  fParent := AParent;
  fName := AName;
end;
{$ENDIF}

//[destructor TTree.Destroy]
destructor TTree.Destroy;
begin
  Unlink;
  Clear;
  {$IFDEF TREE_NONAME}
  {$ELSE}
  fNodeName := '';
  {$ENDIF}
  inherited;
end;

//[function TTree.GetCount]
function TTree.GetCount: Integer;
begin
  Result := 0;
  if fChildren = nil then Exit;
  Result := fChildren.Count;
end;

//[function TTree.GetIndexAmongSiblings]
function TTree.GetIndexAmongSiblings: Integer;
begin
  Result := -1;
  if fParent = nil then Exit;
  Result := fParent.fChildren.IndexOf( @Self );
end;

//[function TTree.GetItems]
function TTree.GetItems(Idx: Integer): PTree;
begin
  Result := nil;
  if fChildren = nil then Exit;
  Result := fChildren.Items[ Idx ];
end;

//[function TTree.GetLevel]
function TTree.GetLevel: Integer;
var Node: PTree;
begin
  Result := 0;
  Node := fParent;
  while Node <> nil do
  begin
    Inc( Result );
    Node := Node.fParent;
  end;
end;

//[function TTree.GetRoot]
function TTree.GetRoot: PTree;
begin
  Result := @Self;
  while Result.fParent <> nil do
    Result := Result.fParent;
end;

//[function TTree.GetTotal]
function TTree.GetTotal: Integer;
var I: Integer;
begin
  Result := Count;
  if Result <> 0 then
  begin
    for I := 0 to Count - 1 do
      Result := Result + Items[ I ].Total;
  end;
end;

//[procedure TTree.Init]
procedure TTree.Init;
begin
  if FParent <> nil then
    FParent.Add( @Self );
end;

//[procedure TTree.Insert]
procedure TTree.Insert(Before, Node: PTree);
var Previous: PTree;
begin
  Node.Unlink;
  if fChildren = nil then begin
    fChildren := NewList;
  end;
  Previous := nil;
  if Before <> nil then
    Previous := Before.fPrev;
  if Previous <> nil then
  begin
    Previous.fNext := Node;
    Node.fPrev := Previous;
  end;
  if Before <> nil then
  begin
    Node.fNext := Before;
    Before.fPrev := Node;
    fChildren.Insert( fChildren.IndexOf( Before ), Node );
  end
    else
  fChildren.Add( Node );
  Node.fParent := @Self;
end;

//[function CompareTreeNodes]
function CompareTreeNodes( const Data: Pointer; const e1, e2: DWORD ): Integer;
var List: PList;
begin
  List := Data;
  {$IFDEF TREE_NONAME}
  Result := DWORD( PTree( List.Items[ e1 ] ).fData ) -
            DWORD( PTree( List.Items[ e2 ] ).fData );
  {$ELSE}
  Result := AnsiCompareStr( KOLString(PTree( List.Items[ e1 ] ).fNodeName),
                            KOLString(PTree( List.Items[ e2 ] ).fNodeName) );
  {$ENDIF}
end;

//[procedure SwapTreeNodes]
procedure SwapTreeNodes( const Data: Pointer; const e1, e2: DWORD );
var List: PList;
begin
  List := Data;
  List.Swap( e1, e2 );
end;

//[procedure TTree.SwapNodes]
procedure TTree.SwapNodes( i1, i2: Integer );
begin
  fChildren.Swap( i1, i2 );
end;

//[procedure TTree.SortByName]
procedure TTree.SortByName;
begin
  if Count <= 1 then Exit;
  SortData( fChildren, fChildren.Count, CompareTreeNodes, SwapTreeNodes );
end;

//[procedure TTree.Unlink]
procedure TTree.Unlink;
var I: Integer;
begin
  if fPrev <> nil then
    fPrev.fNext := fNext;
  if fNext <> nil then
    fNext.fPrev := fPrev;
  if (fParent <> nil) then
  begin
    I := fParent.fChildren.IndexOf( @Self );
    fParent.fChildren.Delete( I );
    if fParent.fChildren.Count = 0 then
    begin
      fParent.fChildren.Free;
      fParent.fChildren := nil;
    end;
  end;
  fPrev := nil;
  fNext := nil;
  fParent := nil;
end;

//[function TTree.IsParentOfNode]
function TTree.IsParentOfNode(Node: PTree): Boolean;
begin
  Result := TRUE;
  while Node <> nil do
  begin
    if Node = @ Self then Exit;
    Node := Node.Parent;
  end;
  Result := FALSE;
end;

//[function TTree.IndexOf]
function TTree.IndexOf(Node: PTree): Integer;
begin
  Result := -1;
  if not IsParentOfNode( Node ) then Exit;
  while Node <> @ Self do
  begin
    Inc( Result );
    while Node.PrevSibling <> nil do
    begin
      Node := Node.PrevSibling;
      Inc( Result, 1 + Node.Total );
    end;
    Node := Node.Parent;
  end;
end;

{-------------------------------------------------------------------------------
  ADDITIONAL UTILITIES
}

function MapFileRead( const Filename: AnsiString; var hFile, hMap: THandle ): Pointer;
var Sz, Hi: DWORD;
begin
  Result := nil;
  hFile := FileCreate( KOLString(Filename), ofOpenRead or ofOpenExisting or ofShareDenyNone );
  hMap := 0;
  if hFile = INVALID_HANDLE_VALUE then Exit;
  Sz := GetFileSize( hFile, @ Hi );
  hMap := CreateFileMapping( hFile, nil, PAGE_READONLY, Hi, Sz, nil );
  if hMap = 0 then Exit;
  if (Hi <> 0) or (Sz > $0FFFFFFF) then Sz := $0FFFFFFF;
  Result := MapViewOfFile( hMap, FILE_MAP_READ, 0, 0, Sz );
end;

function MapFile( const Filename: AnsiString; var hFile, hMap: THandle ): Pointer;
var Sz, Hi: DWORD;
begin
  Result := nil;
  hFile := FileCreate( KOLString(Filename), ofOpenRead or ofOpenWrite or ofOpenExisting
        or ofShareExclusive );
  hMap := 0;
  if hFile = INVALID_HANDLE_VALUE then Exit;
  Sz := GetFileSize( hFile, @ Hi );
  hMap := CreateFileMapping( hFile, nil, PAGE_READWRITE, Hi, Sz, nil );
  if hMap = 0 then Exit;
  if (Hi <> 0) or (Sz > $0FFFFFFF) then Sz := $0FFFFFFF;
  Result := MapViewOfFile( hMap, FILE_MAP_READ, 0, 0, Sz );
end;

procedure UnmapFile( BasePtr: Pointer; hFile, hMap: THandle );
begin
  if BasePtr <> nil then
    UnmapViewOfFile( BasePtr );
  if hMap <> 0 then
    CloseHandle( hMap );
  if hFile <> INVALID_HANDLE_VALUE then
    CloseHandle( hFile );
end;

//[procedure CloseMsg]
procedure CloseMsg( Dummy, Dialog: PControl; var Accept: Boolean );
begin
  Accept := FALSE;
  Dialog.ModalResult := -1;
end;
//[END CloseMsg]

//[procedure OKClick]
procedure OKClick( Dialog, Btn: PControl );
var Rslt: Integer;
begin
  Rslt := -1;
  if Btn <> nil then
    Rslt := Btn.Tag;
  Dialog.ModalResult := Rslt;
  Dialog.Close;
end;
//[END OKClick]

//[procedure KeyClick]
procedure KeyClick( Dialog, Btn: PControl; var Key: Longint; Shift: DWORD );
begin
  if (Key = VK_RETURN) or (Key = VK_ESCAPE) then
  begin
    if Key = VK_ESCAPE then
      Btn := nil;
    OKClick( Dialog, Btn );
  end;
end;
//[END KeyClick]

{$IFDEF SNAPMOUSE2DFLTBTN}
function WndProcDlg( Sender: PControl; var Msg: TMsg; var Rslt: Integer ): Boolean;
var F, B: PControl;
    R: TRect;
    P: TPoint;
begin
  Result := FALSE;
  if Msg.message = WM_PAINT then
  begin
    F := Pointer( Sender );
    B := Pointer( F.Tag );
    if B <> nil then
    begin
      R := B.ClientRect;
      P.X := (R.Left + R.Right) div 2;
      P.Y := (R.Top + R.Bottom) div 2;
      P := B.Client2Screen( P );
      SetCursorPos( P.X, P.Y );
    end;
  end;
end;
{$ENDIF}

//[function ShowQuestionEx]
function ShowQuestionEx( S: KOLString; Answers: KOLString; CallBack: TOnEvent ): Integer;
{$IFDEF F_P105ORBELOW}
type POnEvent = ^TOnEvent;
     PONKey = ^TOnKey;
var M: TMethod;
{$ENDIF F_P105ORBELOW}
var Dialog: PControl;
    DlgPrnt: PControl;
    Buttons: PList;
    Btn: PControl;
    AppTermFlag: Boolean;
    Lab: PControl;
    {$IFNDEF USE_GRUSH} Y, {$ELSE} {$IFDEF TOGRUSH_OPTIONAL} Y, {$ENDIF} {$ENDIF} W, X, I: Integer;
    Title: KOLString;
    DlgWnd: HWnd;
    AppCtl: PControl;
    {$IFDEF USE_GRUSH}
    Sz: TSize;
    H: Integer;
    Bmp: PBitmap;
    {$ENDIF}
    {$IFNDEF NO_CHECK_STAYONTOP}
    CurForm: PControl;
    DoStayOnTop: Boolean;
    {$ENDIF}
    {$IFDEF SNAPMOUSE2DFLTBTN}
    SnapMouse: Integer;
    {$ENDIF}
begin
  AppTermFlag := AppletTerminated;
  AppCtl := Applet;
  AppletTerminated := FALSE;
  Title := 'Information';
  //if pos( '/', Answers ) > 0 then
  if  IndexOfChar(Answers, '/') > 0 then
      Title := 'Question';
  {$IFNDEF NO_CHECK_STAYONTOP}
  DoStayOnTop := FALSE;
  {$ENDIF  NO_CHECK_STAYONTOP}
  CurForm := nil;
  if Applet <> nil then
  begin
    Title := Applet.Caption;
    {$IFNDEF NO_CHECK_STAYONTOP}
    CurForm := Applet.ActiveControl;
    DoStayOnTop := CurForm.StayOnTop;
    {$ENDIF  NO_CHECK_STAYONTOP}
  end;
  {$IFNDEF NOT_ALLOW_EXTRACT_TITLE}
  if (Length( S ) > 2) and (S[ 1 ] = '!') then
  begin
    Delete( S, 1, 1 );
    if S[ 1 ] = '!' then Delete( S, 1, 1 )
    else Title := Parse( S, '!' );
  end;
  {$ENDIF}
  Dialog := NewForm( Applet, KOLString(Title) ).SetSize( 300, 40 );
  {$IFNDEF NO_CHECK_STAYONTOP}
  if  DoStayOnTop then
      Dialog.StayOnTop := TRUE;
  {$ENDIF  NO_CHECK_STAYONTOP}
  Dialog.Style := Dialog.Style and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX);
  Dialog.OnClose := TOnEventAccept( MakeMethod( Dialog, @CloseMsg ) );

  {$IFDEF USE_GRUSH}
  Bmp := NewBitmap( 1, 1 );
  {$IFDEF TOGRUSH_OPTIONAL}
  if not NoGrush then
  {$ENDIF TOGRUSH_OPTIONAL}
  begin
    Dialog.Color := clGRushLight;
    Dialog.Font.FontName := 'Arial';
    Dialog.Font.FontHeight := 16;
    DlgPrnt := NewPanel( Dialog, esNone ); //.SetAlign( caClient );
  end
  {$IFDEF TOGRUSH_OPTIONAL}
    else
    DlgPrnt := Dialog;
  {$ENDIF TOGRUSH_OPTIONAL}
  ;
  {$ELSE}
  DlgPrnt := Dialog;
  {$ENDIF USE_GRUSH}

  DlgPrnt.Margin := 8;

  {$IFDEF USE_GRUSH}
  {$IFDEF TOGRUSH_OPTIONAL}
  if not NoGrush then
  {$ENDIF TOGRUSH_OPTIONAL}
  begin
    Lab := NewWordWrapLabel( DlgPrnt, S ).SetSize( 278, 20 );
    Lab.AutoSize( TRUE );
    Lab.Transparent := TRUE;
  end
  {$IFDEF TOGRUSH_OPTIONAL}
    else
  begin
    Lab := NewEditbox( DlgPrnt, [ eoMultiline, eoReadonly, eoNoHScroll, eoNoVScroll ] ).SetSize( 278, 20 );
    Lab.HasBorder := FALSE;
    Lab.Color := clBtnFace;
    Lab.Caption := S;
    Lab.Style := Lab.Style and not WS_TABSTOP;
    Lab.TabStop := FALSE;
    while TRUE do
    begin
      Y := HiWord( Lab.Perform( EM_POSFROMCHAR, Length( S ) - 1, 0 ) );
      if Y < Lab.Height - 20 then break;
      Lab.Height := Lab.Height + 4;
      if Lab.Height + 40 > GetSystemMetrics( SM_CYSCREEN ) then break;
    end;
  end
  {$ENDIF TOGRUSH_OPTIONAL}
  ;
  {$ELSE}
  Lab := NewEditbox( DlgPrnt, [ eoMultiline, eoReadonly, eoNoHScroll, eoNoVScroll ] ).SetSize( 278, 20 );
  Lab.HasBorder := FALSE;
  Lab.Color := clBtnFace;
  Lab.Caption := S;
  Lab.Style := Lab.Style and not WS_TABSTOP;
  Lab.TabStop := FALSE;

  //Lab.CreateWindow; //virtual!!! -- not needed, window created in Perform
  while TRUE do
  begin
    Y := HiWord( Lab.Perform( EM_POSFROMCHAR, Length( S ) - 1, 0 ) );
    if Y < Lab.Height - 20 then break;
    Lab.Height := Lab.Height + 4;
    if Lab.Height + 40 > GetSystemMetrics( SM_CYSCREEN ) then break;
  end;
  //Lab.LikeSpeedButton;

  {$ENDIF USE_GRUSH}

  Buttons := NewList;
  W := 0;

  {$IFDEF USE_GRUSH}
  H := 0;
  {$ENDIF}

  if Answers = '' then
  begin
    Btn := NewButton( DlgPrnt, '  OK  ' ).PlaceUnder;

    {$IFDEF USE_GRUSH}
    {$IFDEF TOGRUSH_OPTIONAL}
    if not NoGrush then
    {$ENDIF TOGRUSH_OPTIONAL}
    begin
      Sz := Bmp.Canvas.TextExtent( Btn.Caption );
      if H = 0 then H := Sz.cy + 8;
      Btn.SetSize( Sz.cx + 16, H );
    end;
    {$ENDIF}

    W := Btn.BoundsRect.Right;
    Buttons.Add( Btn );
  end
    else
  while Answers <> '' do
  begin
    Btn := NewButton( DlgPrnt, '  ' + Parse( Answers, '/' ) + '  ' );
    Buttons.Add( Btn );
    if W = 0 then
      Btn.PlaceUnder
    else
      Btn.PlaceRight;

    {$IFDEF USE_GRUSH}
    {$IFDEF TOGRUSH_OPTIONAL}
    if not NoGrush then
    {$ENDIF TOGRUSH_OPTIONAL}
    begin
      Sz := Bmp.Canvas.TextExtent( Btn.Caption );
      if H = 0 then H := Sz.cy + 8;
      Btn.SetSize( Sz.cx + 16, H );
    end
    {$IFDEF TOGRUSH_OPTIONAL}
      else Btn.AutoSize( TRUE )
    {$ENDIF TOGRUSH_OPTIONAL}
      ;
    {$ELSE}
    Btn.AutoSize( TRUE );
    {$ENDIF USE_GRUSH}

    if W > 0 then
    begin
      //Inc( W, 6 );
      Btn.Left := Btn.Left + 6;
    end;
    W := Btn.BoundsRect.Right;
  end;
  DlgPrnt.ClientWidth := Max(
    Max( DlgPrnt.ClientWidth, Lab.Left + Lab.Width + 4 ), W + 8 );
  X := (DlgPrnt.ClientWidth - W) div 2;
  for I := 0 to Buttons.Count-1 do
  begin
    Btn := Buttons.Items[ I ];
    Btn.Tag := I + 1;
    {$IFDEF F_P105ORBELOW}
    M := MakeMethod( Dialog, @OKClick );
    Btn.OnClick := POnEvent( @ M )^;
    M := MakeMethod( Dialog, @KeyClick );
    Btn.OnKeyDown := POnKey( @ M )^;
    {$ELSE}
    Btn.OnClick := TOnEvent( MakeMethod( Dialog, @OKClick ) );
    Btn.OnKeyDown := TOnKey( MakeMethod( Dialog, @KeyClick ) );
    {$ENDIF}
    Btn.Left := Btn.Left + X;
    if I = 0 then
    begin
      Btn.ResizeParentBottom;
      Dialog.ActiveControl := Btn;
    end;
  end;

  {$IFDEF USE_GRUSH}
  {$IFDEF TOGRUSH_OPTIONAL}
  if not NoGrush then
  {$ENDIF TOGRUSH_OPTIONAL}
  begin
    DlgPrnt.ResizeParent;
    DlgPrnt.ClientWidth := Max( DlgPrnt.ClientWidth, Dialog.Width - 14 );
  end;
  Bmp.Free;
  {$ENDIF USE_GRUSH}

  Dialog.CenterOnForm( CurForm ).Tabulate.CanResize := FALSE;

  if Assigned( CallBack ) then
    CallBack( Dialog );
  Dialog.CreateWindow; // virtual!!!

  if (Applet <> nil) and Applet.IsApplet then
  begin
    {$IFDEF SNAPMOUSE2DFLTBTN}
    SnapMouse := 0;
    if SystemParametersInfo( SPI_GETSNAPTODEFBUTTON, 0, @ SnapMouse, 0 ) then
    if SnapMouse <> 0 then
    begin
      Dialog.Tag := DWORD( Buttons.Items[ 0 ] );
      Dialog.AttachProc( WndProcDlg );
    end;
    {$ENDIF}
    Dialog.ShowModal;
    Result := Dialog.ModalResult;
    Dialog.Free;
  end else
  begin
    DlgWnd := Dialog.Handle;
    while IsWindow( DlgWnd ) and (Dialog.ModalResult = 0) do
      Dialog.ProcessMessage;
    Result := Dialog.ModalResult;
    Dialog.Free;
    CreatingWindow := nil;
    Applet := AppCtl;
  end;
  Buttons.Free;

  AppletTerminated := AppTermFlag;
end;
//[END ShowQuestionEx]

//[function ShowQuestion]
function ShowQuestion( const S: KOLString; Answers: KOLString ): Integer;
begin
  Result := ShowQuestionEx( S, Answers, nil );
end;
//[END ShowQuestion]

//[procedure ShowMsgModal]
procedure ShowMsgModal( const S: KOLString );
begin
  ShowQuestion( S, '' );
end;
//[END ShowMsgModal]

end.
