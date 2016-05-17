{******************************************************

        KKKKK    KKKKK    OOOOOOOOO    LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLL
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL
        KKKKKKKKKK      OOOOO   OOOOO  LLLLL
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLLLLLLLLLL     kkkkk
        KKKKK    KKKKK    OOOOOOOOO    LLLLLLLLLLLLL    kkkkk
                                                       kkkkk
    mmmmm  mmmmm   mmmmmm          cccccccccccc       kkkkk   kkkkk
   mmmmmmmm   mmmmm     mmmmm   cccccc       ccccc   kkkkk kkkkk
  mmmmmmmm   mmmmm     mmmmm   cccccc               kkkkkkkk
 mmmmm      mmmmm     mmmmm   cccccc      ccccc    kkkkk  kkkkk
mmmmm      mmmmm     mmmmm     cccccccccccc       kkkkk     kkkkk

  Key Objects Library (C) 1999 by Kladov Vladimir.
  KOL Mirror Classes Kit (C) 2000 by Kladov Vladimir.
********************************************************
* VERSION 3.1415926535897
********************************************************
}                     
unit mirror;
{
  This unit contains definitions of mirror classes reflecting to objects of
  KOL. Aim is to create kit for programming in KOL visually.
                  by Vladimir Kladov, 27.11.2000, 13.10.2006

  В данном модуле определяются зеркальные классы для объектов библиотеки KOL.
  Цель - создать средство для визуального конструирования форм в проектах KOL.
                  Кладов Владимир, 27.11.2000, 13.10.2006
}

interface

{$I KOLDEF.INC}
{$IFDEF _D3}
    //{$DEFINE MCKLOG}
{$ENDIF}
{$IFNDEF USE_KOLCTRLWRAPPER}
  {$DEFINE NOT_USE_KOLCTRLWRAPPER}
{$ENDIF}

{$IFDEF _D2orD3}
  {$DEFINE NOT_USE_KOLCTRLWRAPPER}
{$ENDIF}

{$IFDEF NOT_USE_KOLCTRLWRAPPER}
  {$IFDEF _KOLCTRLWRAPPER_}
    {$UNDEF _KOLCTRLWRAPPER_}
  {$ENDIF}
{$ENDIF}

{$IFNDEF NO_NEWIF}
  {$IFDEF _D6orHigher} //{$IFDEF _D2005orHigher}
    { directive $IF appears at least in Delphi6 }
    {$DEFINE NEWIF}
  {$ENDIF}
{$ENDIF}

uses olectrls, KOL, KOLadd, Classes, Forms, Controls, Dialogs, Windows, Messages, extctrls,
     stdctrls, comctrls, SysUtils, Graphics,
//////////////////////////////////////////////////
     ExptIntf, ToolIntf, EditIntf, // DsgnIntf
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants                                   //
     {$ELSE}                                    //
     DsgnIntf                                   //
     {$ENDIF}                                   //
//////////////////////////////////////////////////
     {$IFNDEF _D2}{$IFNDEF _D3}, ToolsAPI{$ENDIF}{$ENDIF},
     TypInfo, Consts,
     mckMenuEditor, mckAccEditor, mckActionListEditor;

{$IFDEF _D4}
{$O-}
{$ENDIF}

{$IFDEF _D2}
type TCustomForm = TForm;
const
{ Browsing for directory. }

  BIF_RETURNONLYFSDIRS   = $0001;  { For finding a folder to start document searching }
  BIF_DONTGOBELOWDOMAIN  = $0002;  { For starting the Find Computer }
  BIF_STATUSTEXT         = $0004;
  BIF_RETURNFSANCESTORS  = $0008;
  BIF_EDITBOX            = $0010;
  BIF_VALIDATE           = $0020;  { insist on valid result (or CANCEL) }

  BIF_BROWSEFORCOMPUTER  = $1000;  { Browsing for Computers. }
  BIF_BROWSEFORPRINTER   = $2000;  { Browsing for Printers }
  BIF_BROWSEINCLUDEFILES = $4000;  { Browsing for Everything }

{ message from browser }

  BFFM_INITIALIZED       = 1;
  BFFM_SELCHANGED        = 2;
  BFFM_VALIDATEFAILEDA   = 3;   { lParam:szPath ret:1(cont),0(EndDialog) }
  BFFM_VALIDATEFAILEDW   = 4;   { lParam:wzPath ret:1(cont),0(EndDialog) }

{ messages to browser }

  BFFM_SETSTATUSTEXTA         = WM_USER + 100;
  BFFM_ENABLEOK               = WM_USER + 101;
  BFFM_SETSELECTIONA          = WM_USER + 102;
  BFFM_SETSELECTIONW          = WM_USER + 103;
  BFFM_SETSTATUSTEXTW         = WM_USER + 104;

type
  PSHItemID = ^TSHItemID;
  _SHITEMID = record
    cb: Word;                         { Size of the ID (including cb itself) }
    abID: array[0..0] of Byte;        { The item ID (variable length) }
  end;
  TSHItemID = _SHITEMID;
  SHITEMID = _SHITEMID;

  PItemIDList = ^TItemIDList;
  _ITEMIDLIST = record
     mkid: TSHItemID;
   end;
  TItemIDList = _ITEMIDLIST;
  ITEMIDLIST = _ITEMIDLIST;

  BFFCALLBACK = function(Wnd: HWND; uMsg: UINT; lParam, lpData:
LPARAM): Integer stdcall;
  TFNBFFCallBack = type BFFCALLBACK;

  PBrowseInfo = ^TBrowseInfo;
  _browseinfo = record
    hwndOwner: HWND;
    pidlRoot: PItemIDList;
    pszDisplayName: PAnsiChar;  { Return display name of item selected. }
    lpszTitle: PAnsiChar;      { text to go in the banner over the tree. }
    ulFlags: UINT;           { Flags that control the return stuff }
    lpfn: TFNBFFCallBack;
    lParam: LPARAM;          { extra info that's passed back in callbacks }
    iImage: Integer;         { output var: where to return the Image index. }
  end;
  TBrowseInfo = _browseinfo;
  BROWSEINFOA = _browseinfo;
{$ENDIF}

const
  WM_USER_ALIGNCHILDREN = WM_USER + 1;
  cKOLTag = -999;

const
  LIGHT = FOREGROUND_INTENSITY;
  WHITE =  FOREGROUND_RED or FOREGROUND_BLUE or FOREGROUND_GREEN;
  RED   =  FOREGROUND_INTENSITY or FOREGROUND_RED;
  GREEN =  FOREGROUND_INTENSITY or FOREGROUND_GREEN;
  BLUE  =  FOREGROUND_BLUE;
  CYAN  =  FOREGROUND_BLUE or FOREGROUND_GREEN;
  YELLOW = FOREGROUND_INTENSITY or FOREGROUND_GREEN or FOREGROUND_RED;




type

    {$IFDEF _D2009orHigher}
    TDelphiString = WideString;
    {$ELSE}
    TDelphiString = String;
    {$ENDIF}

//////////////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                               //
      TDesignerSelectionList = TDesignerSelections;     //
     {$ENDIF}                                           //
//////////////////////////////////////////////////////////




  TFormStringList = class( TStringList )
  private
    FCallingOnAdd: Boolean;
    FOnAdd: TNotifyEvent;
    procedure SetOnAdd(const Value: TNotifyEvent);
  public
      property OnAdd: TNotifyEvent read FOnAdd write SetOnAdd;
      function Add( const s: String ): Integer; override;
  end;









  TKOLActionList = class;
  TKOLAction = class;



  TPaintType = ( ptWYSIWIG, ptWYSIWIGFrames, ptSchematic, ptWYSIWIGCustom ); {YS}

  TKOLForm = class;
  TKOLFont = class;
  //============================================================================
  // TKOLProject component corresponds to the KOL project. It must be present
  // once in a project. It is responding for code generation and contains
  // properties available from Object Inspector, common for entire project
  // (used for maintainig project and in generating of code).
  //
  // Проекту KOL соответствует компонент TKOLProject (должен присутствовать
  // один раз в проекте). Он отвечает за генерацию кода и содержит доступные
  // из ObjectInspector-а настройки (общие для всего проекта), используемые
  // при генерации кода dpr-файла.
  TKOLProject = class( TComponent )
  private
    fProjectName: String;
    FProjectDest: String;
    fSourcePath: TFileName;
    fDprResource: Boolean;
    fProtect: Boolean;
    fShowReport: Boolean;
    fBuild: Boolean;
    fIsKOL: Integer;
    fOutdcuPath: String;
    fAutoBuild: Boolean;
    fTimer: TTimer;
    fAutoBuilding: Boolean;
    FAutoBuildDelay: Integer;
    fGettingSourcePath: Boolean;
    FConsoleOut: Boolean;
    FIn, FOut: THandle;
    FBuilding: Boolean;
    fChangingNow: Boolean;
    FSupportAnsiMnemonics: LCID;
    FPaintType: TPaintType;
    FHelpFile: String;
    FLocalizy: Boolean;
    FShowHint: Boolean;
    FIsDestroying: Boolean;
    FCallPCompiler: String;
    FReportDetailed: Boolean;
    FGeneratePCode: Boolean;
    FDefaultFont: TKOLFont;
    FFormCompactDisabled: Boolean;
    function GetProjectName: String;
    procedure SetProjectDest(const Value: String);

    function ConvertVCL2KOL( ConfirmOK: Boolean; ForceAllForms: Boolean ): Boolean;
    function OwnerKOLForm: TKOLForm;

{$IFDEF _D2007orHigher}
    function MakeupConfig: Boolean;
{$ENDIF}
    function UpdateConfig: Boolean;
    function GetSourcePath: TFileName;
    function GetProjectDest: String;
    function GetBuild: Boolean;
    procedure SetBuild(const Value: Boolean);
    function GetIsKOLProject: Boolean;
    procedure SetIsKOLProject(const Value: Boolean);
    function GetOutdcuPath: TFileName;
    procedure SetOutdcuPath(const Value: TFileName);
    procedure SetAutoBuild(const Value: Boolean);
    function GetShowReport: Boolean;
    procedure SetAutoBuildDelay(const Value: Integer);
    procedure SetConsoleOut(const Value: Boolean);
    procedure SetLocked(const Value: Boolean);
    procedure SetSupportAnsiMnemonics(const Value: LCID);
    procedure SetPaintType(const Value: TPaintType);
    procedure SetHelpFile(const Value: String);
    procedure SetLocalizy(const Value: Boolean);
    procedure SetShowHint(const Value: Boolean);
    procedure SetCallPCompiler(const Value: String);
    procedure SetReportDetailed(const Value: Boolean);
    procedure SetGeneratePCode(const Value: Boolean);
    function getNewIf: Boolean;
    procedure setNewIf(const Value: Boolean);
    procedure SetDefaultFont(const Value: TKOLFont);
    procedure SetFormCompactDisabled(const Value: Boolean);
  protected
    FLocked: Boolean;
    FNewIF: Boolean;
    function GenerateDPR( const Path: String ): Boolean; virtual;
    procedure BeforeGenerateDPR( const SL: TStringList; var Updated: Boolean ); virtual;
    procedure AfterGenerateDPR( const SL: TStringList; var Updated: Boolean ); virtual;
    procedure TimerTick( Sender: TObject );
    property AutoBuilding: Boolean read fAutoBuilding write fAutoBuilding;
    procedure BroadCastPaintTypeToAllForms;
    procedure Loaded; override;
    procedure SetName(const NewName: TComponentName); override;
  protected
    ResStrings: TStringList;
    function StringConstant( const Propname, Value: String ): String;
    function P_StringConstant( const Propname, Value: String ): String;
    procedure MakeResourceString( const ResourceConstName, Value: String );
  public
    procedure Change;
    procedure ChangeAllForms;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure Report(const Txt: String; Color: Integer );
    property Building: Boolean read FBuilding;
  published
    property Locked: Boolean read FLocked write SetLocked;

    property Localizy: Boolean read FLocalizy write SetLocalizy;

    // Name of source, i.e. mirror project. Detected by reading text of
    // Delphi IDE window. Can be corrected in Object Inspector.
    //
    // Имя проекта (зеркального, т.е. исходного). Определяется просто - по
    // заголовку окна Delphi IDE. Можно изменить руками.
    property projectName: String read GetProjectName write fProjectName;

    // Project name for converted (KOL) project. Must be entered manually,
    // and it must not much project name.
    // Имя проекта после конверсии в KOL. Требуется ввести руками.
    // Ни в коем случае не должен совпадать с именем самого проекта.
    property projectDest: String read GetProjectDest write SetProjectDest;

    // Path to source (=mirror) project. When TKOLProject component is
    // dropped onto form, a dialog is appear to select path to a directory
    // with source files of the project. Resulting project is store in
    // \KOL subdirectory of the path. Path to a source is necessary to
    // generate KOL project on base of mirror one.
    //
    // Путь к исходному проекту. При бросании компонента TKOLProject на
    // форму вываливается диалог с предложением указать путь к исходному
    // проекту. Результирующий проект (после конвертации в KOL) будет лежать
    // в поддиректории \KOL исходной папки. Без знания данного пути зеркала
    // форм не смогут найти свои исходные файлы.
    property sourcePath: TFileName read GetSourcePath write fSourcePath;

    property outdcuPath: TFileName read GetOutdcuPath write SetOutdcuPath;

    // True, if to include {$R *.RES} while generating dpr-file.
    // Истина, если включать ресурс проекта (иконка 'MAINICON' в файле
    // имя-проекта.res).
    property dprResource: Boolean read fDprResource write fDprResource;

    // True, if all generated files to be marked Read-Only (by default,
    // since it is suggested to correct only source (=mirror) files.
    // === no more used ===
    //
    // Истина, если делать результирующие файлы READ-ONLY (по умолчанию,
    // т.к. предполагается, что эти файлы не надо можифицировать вручную)
    // === более не используется ===
    property protectFiles: Boolean read fProtect write fProtect;

    property showReport: Boolean read GetShowReport write fShowReport;

    // True, if project is converted already to KOL. Since this,
    // it can be adjusted at design-time using visual capabilities
    // of Delphi IDE and when compiled only non-VCL features are
    // included into executable, so it is ten times smaller.
    property isKOLProject: Boolean read GetIsKOLProject write SetIsKOLProject;

    property autoBuild: Boolean read fAutoBuild write SetAutoBuild;
    property autoBuildDelay: Integer read FAutoBuildDelay write SetAutoBuildDelay;
    property BUILD: Boolean read GetBuild write SetBuild;
    property consoleOut: Boolean read FConsoleOut write SetConsoleOut;

    property SupportAnsiMnemonics: LCID read FSupportAnsiMnemonics write SetSupportAnsiMnemonics;
    {* Change this value to provide supporting of ANSI (localized) mnemonics.
       To have effect for a form, property SupportMnemonics should be set to
       TRUE for such form too. This value should be set to a number, correspondent
       to locale which is desired to be supported. Or, set it to value 1, to
       support default user locale of the system where the project is built.  }

    property PaintType: TPaintType read FPaintType write SetPaintType;

    property HelpFile: String read FHelpFile write SetHelpFile;
    property ShowHint: Boolean read FShowHint write SetShowHint;
    {* To provide tooltip (hint) showing, it is necessary to define conditional
       symbol USE_MHTOOLTIP in
       Project|Options|Directories/Conditionals|Conditional Defines. }
    property CallPCompiler: String read FCallPCompiler write SetCallPCompiler;
    property ReportDetailed: Boolean read FReportDetailed write SetReportDetailed;
    property GeneratePCode: Boolean read FGeneratePCode write SetGeneratePCode;
    property NewIF: Boolean read getNewIf write setNewIf;
    property DefaultFont: TKOLFont read FDefaultFont write SetDefaultFont;
    property FormCompactDisabled: Boolean read FFormCompactDisabled write SetFormCompactDisabled;
  end;

  TKOLProjectBuilder = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

























  TKOLFont = class( TPersistent )
  private
    fOwner: TComponent;
    FFontCharset: Byte;
    FFontOrientation: Integer;
    FFontWidth: Integer;
    FFontHeight: Integer;
    FFontWeight: Integer;
    FFontName: String;
    FColor: TColor;
    FFontPitch: TFontPitch;
    FFontStyle: TFontStyles;
    fChangingNow: Boolean;
    FFontQuality: TFontQuality;
    procedure SetColor(const Value: TColor);
    procedure SetFontCharset(const Value: Byte);
    procedure SetFontHeight(const Value: Integer);
    procedure SetFontName(const Value: String);
    procedure SetFontOrientation(Value: Integer);
    procedure SetFontPitch(const Value: TFontPitch);
    procedure SetFontStyle(const Value: TFontStyles);
    procedure SetFontWeight(Value: Integer);
    procedure SetFontWidth(const Value: Integer);
    procedure SetFontQuality(const Value: TFontQuality);
  protected
    procedure Changing;
  public
    procedure Change;
    constructor Create( AOwner: TComponent );
    function Equal2( AFont: TKOLFont ): Boolean;
    procedure GenerateCode( SL: TStrings; const AName: String; AFont: TKOLFont );
    procedure P_GenerateCode( SL: TStrings; const AName: String; AFont: TKOLFont );
    procedure Assign( Value: TPersistent ); override;
    property Owner: TComponent read fOwner;
  published
    property Color: TColor read FColor write SetColor;
    property FontStyle: TFontStyles read FFontStyle write SetFontStyle;
    property FontHeight: Integer read FFontHeight write SetFontHeight;
    property FontWidth: Integer read FFontWidth write SetFontWidth;
    property FontWeight: Integer read FFontWeight write SetFontWeight;
    property FontName: String read FFontName write SetFontName;
    property FontOrientation: Integer read FFontOrientation write SetFontOrientation;
    property FontCharset: Byte read FFontCharset write SetFontCharset;
    property FontPitch: TFontPitch read FFontPitch write SetFontPitch;
    property FontQuality: TFontQuality read FFontQuality write SetFontQuality;
  end;

  TKOLBrush = class( TPersistent )
  private
    fOwner: TComponent;
    FBrushStyle: TBrushStyle;
    FColor: TColor;
    FBitmap: TBitmap;
    fChangingNow: Boolean;
    FAllowBitmapCompression: Boolean;
    procedure SetBitmap(const Value: TBitmap);
    procedure SetBrushStyle(const Value: TBrushStyle);
    procedure SetColor(const Value: TColor);
    procedure SetAllowBitmapCompression(const Value: Boolean);
  protected
    procedure GenerateCode( SL: TStrings; const AName: String );
    procedure P_GenerateCode( SL: TStrings; const AName: String );
  public
    procedure Change;
    constructor Create( AOwner: TComponent );
    destructor Destroy; override;
    procedure Assign( Value: TPersistent ); override;
  published
    property Color: TColor read FColor write SetColor;
    property BrushStyle: TBrushStyle read FBrushStyle write SetBrushStyle;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property AllowBitmapCompression: Boolean read FAllowBitmapCompression write SetAllowBitmapCompression
             default TRUE;
  end;
















  //============================================================================
  // Mirror class, corresponding to unnecessary in KOL application
  // taskbar button (variable Applet).
  //
  // Зеркальный класс, соответствующий необязательному в KOL
  // приложению (окну, представляющему кнопку приложения на панели
  // задач)
  TKOLApplet = class( TComponent )
  private
    FLastWarnTimeAbtMainForm: Integer;
    FShowingWarnAbtMainForm: Boolean;
    FOnMessage: TOnMessage;
    FOnDestroy: TOnEvent;
    FOnClose: TOnEventAccept;
    FIcon: String;
    fChangingNow: Boolean;
    FOnQueryEndSession: TOnEventAccept;
    FOnMinimize: TOnEvent;
    FOnRestore: TOnEvent;
    FAllBtnReturnClick: Boolean;
    FTag: Integer;
    FForceIcon16x16: Boolean;
    FTabulate: Boolean;
    FTabulateEx: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetVisible(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetOnMessage(const Value: TOnMessage);
    procedure SetOnDestroy(const Value: TOnEvent);
    procedure SetOnClose(const Value: TOnEventAccept);
    procedure SetIcon(const Value: String);
    procedure SetOnQueryEndSession(const Value: TOnEventAccept);
    procedure SetOnMinimize(const Value: TOnEvent);
    procedure SetOnRestore(const Value: TOnEvent);
    procedure SetAllBtnReturnClick(const Value: Boolean);
    procedure SetTag(const Value: Integer);
    procedure SetForceIcon16x16(const Value: Boolean);
    procedure SetTabulate(const Value: Boolean);
    procedure SetTabulateEx(const Value: Boolean);
  protected
    fCaption: String;
    fVisible, fEnabled: Boolean;
    FChanged: Boolean;
    fSourcePath: String;
    fIsDestroying: Boolean;
    //Creating_DoNotGenerateCode: Boolean;
    procedure GenerateRun( SL: TStringList; const AName: String ); virtual;
    function AutoCaption: Boolean; virtual;
    procedure ChangeDPR; virtual;

    // Method to assign values to assigned events. Is called in SetupFirst
    // and actually should call DoAssignEvents, passing a list of (additional)
    // events to it.
    //
    // Процедура присваивания значений назначенным событиям. Вызывается из
    // SetupFirst и фактически должна (после вызова inherited) передать
    // в процедуру DoAssignEvents список (дополнительных) событий.
    procedure AssignEvents( SL: TStringList; const AName: String ); virtual;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; virtual;

  protected
    FEventDefs: TStringList;
    FAssignOnlyUserEvents: Boolean;
    FAssignOnlyWinEvents: Boolean;
  public
    procedure DefineFormEvents( const EventNamesAndDefs: array of String );
    procedure DoAssignEvents( SL: TStringList; const AName: String;
              EventNames: array of PChar; EventHandlers: array of Pointer );
    function P_DoAssignEvents( SL: TStringList; const AName: String;
              EventNames: array of PAnsiChar; EventHandlers: array of Pointer;
              EventAssignProc: array of Boolean; CheckOnly: Boolean ): Boolean;
    function BestEventName: String; virtual;
  public
    procedure Change( Sender: TComponent ); virtual;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    property Enabled: Boolean read fEnabled write SetEnabled;
    function Pcode_Generate: Boolean; virtual;
  published
    property Icon: String read FIcon write SetIcon;
    property ForceIcon16x16: Boolean read FForceIcon16x16 write SetForceIcon16x16;
    property Caption: String read fCaption write SetCaption;
    property Visible: Boolean read fVisible write SetVisible;
    property OnMessage: TOnMessage read FOnMessage write SetOnMessage;
    property OnDestroy: TOnEvent read FOnDestroy write SetOnDestroy;
    property OnClose: TOnEventAccept read FOnClose write SetOnClose;
    property OnQueryEndSession: TOnEventAccept read FOnQueryEndSession write SetOnQueryEndSession;
    property OnMinimize: TOnEvent read FOnMinimize write SetOnMinimize;
    property OnRestore: TOnEvent read FOnRestore write SetOnRestore;
    property AllBtnReturnClick: Boolean read FAllBtnReturnClick write SetAllBtnReturnClick;
    property Tag: Integer read FTag write SetTag;
    property Tabulate: Boolean read FTabulate write SetTabulate;
    property TabulateEx: Boolean read FTabulateEx write SetTabulateEx;
    property UnitSourcePath: String read fSourcePath write fSourcePath;
  end;

  // Special class to avoid conflict with Left and Top properties of
  // component in VCL and component TKOLForm correspondent properties.
  //
  // Специальный класс, чтобы обойти конфликт со свойствами Left / Top
  // в Bounds формы (в компоненте TKOLForm).
  TFormBounds = class( TPersistent )
  private
    fOwner: TComponent;
    fTimer: TTimer;
    fL, fT, fW, fH: Integer;
    function GetHeight: Integer;
    function GetLeft: Integer;
    function GetTop: Integer;
    function GetWidth: Integer;
    procedure SetHeight(const Value: Integer);
    procedure SetLeft(const Value: Integer);
    procedure SetTop(const Value: Integer);
    procedure SetWidth(const Value: Integer);
    procedure CheckFormSize( Sender: TObject );
    procedure SetOwner(const Value: TComponent);
  protected
  public
    procedure Change;
    constructor Create;
    destructor Destroy; override;
    property Owner: TComponent read fOwner write SetOwner;
    procedure EnableTimer(Value: Boolean);
  published
    property Left: Integer read GetLeft write SetLeft stored False;
    property Top: Integer read GetTop write SetTop stored False;
    property Width: Integer read GetWidth write SetWidth stored False;
    property Height: Integer read GetHeight write SetHeight stored False;
  end;


























  //============================================================================
  // Mirror component, corresponding to KOL's form. It must be present
  // on each of mirror project's form to provide generating of corresponding
  // unit in resulting KOL project.
  //
  // Форме из KOL соответствует зеркальный компонент TKOLForm. Он должен
  // присутствовать на форме зеркального проекта для того, чтобы при запуске
  // его сгенерировался код соответствующего модуля для компиляции с
  // использованием KOL. Кроме того, модифицируя его свойства в Инспекторе,
  // возможно настроить свойства формы KOL "визуально".
  TKOLCustomControl = class;
  TKOLPopupMenu = class;

  TLocalizyOptions = ( loForm, loNo, loYes  );

  TKOLFormBorderStyle = ( fbsNone, fbsSingle, fbsDialog, fbsToolWindow );  {YS}

  TKOLForm = class( TKOLApplet )
  private
    fFormMain: Boolean;
    fFormUnit: String;
    fBounds: TFormBounds;
    fDefaultSize: Boolean;
    fMargin: Integer;
    fDefaultPos: Boolean;
    fCanResize: Boolean;
    fCenterOnScr: Boolean;
    FPreventResizeFlicks: Boolean;
    FDoubleBuffered: Boolean;
    FTransparent: Boolean;
    FAlphaBlend: Integer;
    FHasBorder: Boolean;
    FStayOnTop: Boolean;
    FHasCaption: Boolean;
    FCtl3D: Boolean;
    FModalResult: Integer;
    FWindowState: KOL.TWindowState;
    FOnChar: TOnChar;
    fOnClick: TOnEvent;
    FOnLeave: TOnEvent;
    FOnMouseEnter: TOnEvent;
    FOnEnter: TOnEvent;
    FOnMouseLeave: TOnEvent;
    FOnKeyUp: TOnKey;
    FOnKeyDown: TOnKey;
    FOnMouseMove: TOnMouse;
    FOnMouseWheel: TOnMouse;
    FOnMouseDown: TOnMouse;
    FOnMouseUp: TOnMouse;
    FOnResize: TOnEvent;
    FMaximizeIcon: Boolean;
    FMinimizeIcon: Boolean;
    FCloseIcon: Boolean;
    FIcon: String;
    FCursor: String;
    fFont: TKOLFont;
    fBrush: TKOLBrush;
    FOnFormCreate: TOnEvent;
    FParentLikeFontControls: TList;
    FParentLikeColorControls: TList;
    FMinimizeNormalAnimated: Boolean;
    FRestoreNormalMaximized: Boolean;
    FOnShow: TOnEvent;
    FOnHide: TOnEvent;
    FzOrderChildren: Boolean;
    FSimpleStatusText: TDelphiString;
    FStatusText: TStringList;
    fOnMouseDblClk: TOnMouse;
    FMarginLeft: Integer;
    FMarginTop: Integer;
    FMarginBottom: Integer;
    FMarginRight: Integer;
    FOnEraseBkgnd: TOnPaint;
    FOnPaint: TOnPaint;
    FEraseBackground: Boolean;
    FOnMove: TOnEvent;
    FOnMoving: TOnEventMoving;
    FSupportMnemonics: Boolean;
    FStatusSizeGrip: Boolean;
    FPaintType: TPaintType;
    FRealignTimer: TTimer;
    FChangeTimer: TTimer;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FMinHeight: Integer;
    FMaxHeight: Integer;
    FOnDropFiles: TOnDropFiles;
    FpopupMenu: TKOLPopupMenu;
    FOnMaximize: TOnEvent;
    FLocalizy: Boolean;
    FHelpContext: Integer;
    FhelpContextIcon: Boolean;
    FOnHelp: TOnHelp;
    fDefaultBtnCtl, fCancelBtnCtl: TKOLCustomControl;
    FborderStyle: TKOLFormBorderStyle;  {YS}
    FGetShowHint: Boolean;
    FOnBeforeCreateWindow: TOnEvent; {YS}
    FKeyPreview: Boolean;
    FFontDefault: Boolean;
    FFormCompact: Boolean;
    FGenerateCtlNames: Boolean;
    FUnicode: Boolean;
    FOverrideScrollbars: Boolean;
    fAssignTextToControls: Boolean;
    FAssignTabOrders: Boolean;
    fFormCurrentParent: String;
    function GetFormUnit: KOLString;
    procedure SetFormMain(const Value: Boolean);
    procedure SetFormUnit(const Value: KOLString);
    function GetFormMain: Boolean;

    function GetSelf: TKOLForm;
    procedure SetDefaultSize(const Value: Boolean);
    procedure SetMargin(const Value: Integer);
    procedure SetDefaultPos(const Value: Boolean);
    procedure SetCanResize(const Value: Boolean);
    procedure SetCenterOnScr(const Value: Boolean);
    procedure SetAlphaBlend(Value: Integer);
    procedure SetDoubleBuffered(const Value: Boolean);
    procedure SetPreventResizeFlicks(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetHasBorder(const Value: Boolean);
    procedure SetStayOnTop(const Value: Boolean);
    procedure SetHasCaption(const Value: Boolean);
    procedure SetCtl3D(const Value: Boolean);
    procedure SetModalResult(const Value: Integer);
    procedure SetWindowState(const Value: KOL.TWindowState);
    procedure SetOnChar(const Value: TOnChar);
    procedure SetOnClick(const Value: TOnEvent);
    procedure SetOnEnter(const Value: TOnEvent);
    procedure SetOnKeyDown(const Value: TOnKey);
    procedure SetOnKeyUp(const Value: TOnKey);
    procedure SetOnLeave(const Value: TOnEvent);
    procedure SetOnMouseDown(const Value: TOnMouse);
    procedure SetOnMouseEnter(const Value: TOnEvent);
    procedure SetOnMouseLeave(const Value: TOnEvent);
    procedure SetOnMouseMove(const Value: TOnMouse);
    procedure SetOnMouseUp(const Value: TOnMouse);
    procedure SetOnMouseWheel(const Value: TOnMouse);
    procedure SetOnResize(const Value: TOnEvent);
    procedure SetMaximizeIcon(const Value: Boolean);
    procedure SetMinimizeIcon(const Value: Boolean);
    procedure SetCloseIcon(const Value: Boolean);
    procedure SetCursor(const Value: String);
    procedure SetIcon(const Value: String);
    function Get_Color: TColor;
    procedure Set_Color(const Value: TColor);
    procedure SetFont(const Value: TKOLFont);
    procedure SetBrush(const Value: TKOLBrush);
    procedure SetOnFormCreate(const Value: TOnEvent);
    procedure CollectChildrenWithParentFont;
    procedure ApplyFontToChildren;
    procedure CollectChildrenWithParentColor;
    procedure ApplyColorToChildren;
    procedure SetMinimizeNormalAnimated(const Value: Boolean);
    procedure SetRestoreNormalMaximized(const Value: Boolean);
    procedure SetLocked(const Value: Boolean);
    procedure SetOnShow(const Value: TOnEvent);
    procedure SetOnHide(const Value: TOnEvent);
    procedure SetzOrderChildren(const Value: Boolean);
    procedure SetSimpleStatusText(const Value: TDelphiString);
    function GetStatusText: TStrings;
    procedure SetStatusText(const Value: TStrings);
    procedure SetOnMouseDblClk(const Value: TOnMouse);
    procedure SetMarginBottom(const Value: Integer);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetMarginRight(const Value: Integer);
    procedure SetMarginTop(const Value: Integer);
    procedure SetOnEraseBkgnd(const Value: TOnPaint);
    procedure SetOnPaint(const Value: TOnPaint);
    procedure SetEraseBackground(const Value: Boolean);
    procedure SetOnMove(const Value: TOnEvent);
    procedure SetOnMoving(const Value: TOnEventMoving);
    procedure SetSupportMnemonics(const Value: Boolean);
    procedure SetStatusSizeGrip(const Value: Boolean);
    procedure SetPaintType(const Value: TPaintType);
    procedure SetMaxHeight(const Value: Integer);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMinHeight(const Value: Integer);
    procedure SetMinWidth(const Value: Integer);
    procedure SetOnDropFiles(const Value: TOnDropFiles);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    procedure SetOnMaximize(const Value: TOnEvent);
    procedure SetLocalizy(const Value: Boolean);
    procedure SetHelpContext(const Value: Integer);
    procedure SethelpContextIcon(const Value: Boolean);
    procedure SetOnHelp(const Value: TOnHelp);
    procedure SetborderStyle(const Value: TKOLFormBorderStyle); {YS}
    procedure SetShowHint(const Value: Boolean);
    function GetShowHint: Boolean;
    procedure SetOnBeforeCreateWindow(const Value: TOnEvent); {YS}
    procedure SetKeyPreview(const Value: Boolean);
    procedure SetFontDefault(const Value: Boolean);
    procedure SetFormCompact(const Value: Boolean);
    procedure SetGenerateCtlNames(const Value: Boolean);
    procedure SetUnicode(const Value: Boolean);
    procedure SetOverrideScrollbars(const Value: Boolean);
    procedure Set_Bounds(const Value: TFormBounds);
    procedure SetAssignTextToControls(const Value: Boolean);
    procedure SetAssignTabOrders(const Value: Boolean);
    function GetFormCompact: Boolean;
    procedure SetFormCurrentParent(const Value: String);
  protected
    fUniqueID: Integer;
    FLocked: Boolean;
    function AdditionalUnits: String; virtual;
    function FormTypeName: String; virtual;
    function AppletOnForm: Boolean;
    function GetCaption: TDelphiString; virtual;
    procedure SetFormCaption(const Value: TDelphiString); virtual;

    function GetFormName: KOLString;
    procedure SetFormName(const Value: KOLString);
    function GenerateTransparentInits: String; virtual;
    function P_GenerateTransparentInits: String; virtual;
    function Result_Form: String; virtual;

    function StringConstant( const Propname, Value: String ): String;
    function P_StringConstant( const Propname, Value: String ): String;
  public
    procedure Change( Sender: TComponent ); override;
    // Methods to generate code of unit, containing form definition.
    // Методы, в которых генерится код модуля, содержащего форму
    procedure DoChangeNow;

    function GenerateUnit( const Path: String ): Boolean; virtual;
    function Pcode_Generate: Boolean; override;
  protected
    FNameSetuped: Boolean;
    fP_NameSetuped: Boolean;

    function GeneratePAS( const Path: String; var Updated: Boolean ): Boolean; virtual;
    function AfterGeneratePas( SL: TStringList ): Boolean; virtual;
    function GenerateINC( const Path: String; var Updated: Boolean ): Boolean; virtual;
    procedure GenerateChildren( SL: TStringList; OfParent: TComponent;
              const OfParentName: String; const Prefix: String;
              var Updated: Boolean );
    procedure P_GenerateChildren( SL: TStringList; OfParent: TComponent;
              const OfParentName: String; const Prefix: String;
              var Updated: Boolean );
    procedure GenerateCreateForm( SL: TStringList ); virtual;
    procedure ClearBeforeGenerateForm( SL: TStringList );
    procedure P_GenerateCreateForm( SL: TStringList ); virtual;
    procedure GenerateDestroyAfterRun( SL: TStringList ); virtual;
    procedure GenerateAdd2AutoFree( SL: TStringList; const AName: String; AControl: Boolean;
              Add2AutoFreeProc: String; Obj: TObject ); virtual;
    procedure P_GenerateAdd2AutoFree( SL: TStringList; const AName: String; AControl: Boolean;
              Add2AutoFreeProc: String; Obj: TObject ); virtual;

    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    procedure SetupName( SL: TStringList; const AName, AParent, Prefix: String );
    procedure P_SetupName( SL: TStringList );

    // Is called after constructing of all child controls and objects
    // to generate final initialization if needed (only for form object
    // itself). Now, CanResize property assignment to False is placed
    // here.
    //
    // Вызывается уже после генерации конструирования всех
    // дочерних контролов и объектов формы - для генерации какой-либо
    // завершающей инициализации (самой формы):
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    // Method to assign values to assigned events. Is called in SetupFirst
    // and actually should call DoAssignEvents, passing a list of (additional)
    // events to it.
    //
    // Процедура присваивания значений назначенным событиям. Вызывается из
    // SetupFirst и фактически должна (после вызова inherited) передать
    // в процедуру DoAssignEvents список (дополнительных) событий.
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; override;

    property PaintType: TPaintType read FPaintType write SetPaintType;
    procedure InvalidateControls;
    procedure Loaded; override;
    procedure GetPaintTypeFromProjectOrOtherForms;
    function DoNotGenerateSetPosition: Boolean; virtual;
    procedure RealignTimerTick( Sender: TObject );
    procedure ChangeTimerTick( Sender: TObject );

  public
    function BestEventName: String; override;
  protected
    fCreating: Boolean;
    fOrderControl: Integer;
    ResStrings: TStringList;
    procedure MakeResourceString( const ResourceConstName, Value: String );
  public
    AllowRealign: Boolean;
    FRealigning: Integer;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    function NextUniqueID: Integer;

    // Attention! This is very important definition. While designing
    // mirror form, and writing code in event handlers, such wizard
    // word must be used everywhere instead default (usually skipped)
    // word 'Self'. For instance, do not write in your handler
    //   Left := 100; Such code will be correct only while compiling
    // mirror project itself, but after converting to KOL an error
    // will be detected by the compiler. Write instead:
    //   Form.Left := 100; And this will be correct both in mirror
    // project and in resulting KOL project.
    //
    // Внимание! Здесь определяется важное слово. В проектировании
    // зеркальных форм это волшебное слово должно быть использовано
    // везде, где ранее можно было опустить подразумеваемое слово
    // Self. Например, в обработчике нельзя написать Left := 100;
    // Такой код будет правильным при компиляции зеркала, но после
    // конверсии в KOL при попытке оттранслировать проект транслятор
    // выдаст ошибку. Следует писать Form.Left := 100; И тогда это
    // будет правильно в обоих проектах.
    property Form: TKOLForm read GetSelf;
    property ModalResult: Integer read FModalResult write SetModalResult;
    property Margin: Integer read fMargin write SetMargin;
    procedure AlignChildren( PrntCtrl: TKOLCustomControl; Recursive: Boolean );
    function HasMainMenu: Boolean;
  published
    property Locked: Boolean read FLocked write SetLocked;

    //property AutoCreate: Boolean read GetAutoCreate write fAutoCreate;

    // Property FormName - just shows name of VCL form (it is possible to change
    // it in Object Inspaector). This name will be used as a name of correspondent
    // variable of type P<FormName> in generated unit (which actually is not
    // form, but contains Form: PControl as a field).
    //
    // Свойство FormName - просто показывает имя формы VCL (еще его можно здесь
    // же изменить). Это имя будет использовано как имя соответствующей
    // переменной формы типа P<FormName> в сгенерированном модуле для KOL-проекта.
    // Эта переменная не есть точное соответствие форме, но содержит переменую
    // Form: PControl, в действительности соответствующую ей.
    property formName: KOLString read GetFormName write SetFormName stored False;

    // Unit name, containing form definition.
    // Имя модуля, в котором содержится форма.
    property formUnit: KOLString read GetFormUnit write SetFormUnit;

    // Form is marked 'main', if it contain also TKOLProject component.
    // (Main form in KOL playes special role, and can even replace
    // Applet object if this last is not needed in KOL project - to make
    // application taskbar button ivisible, for instance).
    //
    // Форма считается главной, если именно на нее положен компонент
    // TKOLProject. Соответственно здесь возвращается True, только если
    // TKOLForm лежит на той же форме, что и TKOLProject. (В KOL главная
    // форма выполняет особую роль, и даже может замещать собой объект
    // Applet при его отсутствии).
    property formMain: Boolean read GetFormMain write SetFormMain;
    property Caption: TDelphiString read GetCaption write SetFormCaption;
    property Visible;
    property Enabled;

    property bounds: TFormBounds read fBounds write Set_Bounds;
    property defaultSize: Boolean read fDefaultSize write SetDefaultSize;
    property defaultPosition: Boolean read fDefaultPos write SetDefaultPos;
    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property MinHeight: Integer read FMinHeight write SetMinHeight;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property MaxHeight: Integer read FMaxHeight write SetMaxHeight;

    property HasBorder: Boolean read FHasBorder write SetHasBorder;
    property HasCaption: Boolean read FHasCaption write SetHasCaption;
    property StayOnTop: Boolean read FStayOnTop write SetStayOnTop;
    property CanResize: Boolean read fCanResize write SetCanResize;
    property CenterOnScreen: Boolean read fCenterOnScr write SetCenterOnScr;
    property Ctl3D: Boolean read FCtl3D write SetCtl3D;
    property WindowState: KOL.TWindowState read FWindowState write SetWindowState;

    // These three properties are for design time only:
    property minimizeIcon: Boolean read FMinimizeIcon write SetMinimizeIcon;
    property maximizeIcon: Boolean read FMaximizeIcon write SetMaximizeIcon;
    property closeIcon: Boolean read FCloseIcon write SetCloseIcon;
    property helpContextIcon: Boolean read FhelpContextIcon write SethelpContextIcon;
    property borderStyle: TKOLFormBorderStyle read FborderStyle write SetborderStyle; {YS}
    property HelpContext: Integer read FHelpContext write SetHelpContext;

    // Properties Icon and Cursor at design time are represented as strings.
    // These allow to autoload real Icon: HIcon and Cursor: HCursor from
    // resource with given name. Type here name of resource and use $R directive
    // to include correspondent res-file into executable.
    //
    // В дизайнере свойства Icon и Cursor являются строками, представляющими
    // собой имена соответствующих ресурсов. Для подключения файлов, содержащих
    // эти ресурсы, используйте в своем проекте директиву $R.
    property Icon: String read FIcon write SetIcon;
    property Cursor: String read FCursor write SetCursor;

    property Color: TColor read Get_Color write Set_Color;
    property Font: TKOLFont read fFont write SetFont;
    property FontDefault: Boolean read FFontDefault write SetFontDefault;
    property Brush: TKOLBrush read FBrush write SetBrush;

    property DoubleBuffered: Boolean read FDoubleBuffered write SetDoubleBuffered;
    property PreventResizeFlicks: Boolean read FPreventResizeFlicks write SetPreventResizeFlicks;
    property Transparent: Boolean read FTransparent write SetTransparent;
    property AlphaBlend: Integer read FAlphaBlend write SetAlphaBlend;

    property Border: Integer read fMargin write SetMargin;
    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property MarginRight: Integer read FMarginRight write SetMarginRight;
    property MarginTop: Integer read FMarginTop write SetMarginTop;
    property MarginBottom: Integer read FMarginBottom write SetMarginBottom;

    property MinimizeNormalAnimated: Boolean read FMinimizeNormalAnimated write SetMinimizeNormalAnimated;
    property RestoreNormalMaximized: Boolean read FRestoreNormalMaximized write SetRestoreNormalMaximized;
    property zOrderChildren: Boolean read FzOrderChildren write SetzOrderChildren;

    property SimpleStatusText: TDelphiString read FSimpleStatusText write SetSimpleStatusText;
    property StatusText: TStrings read GetStatusText write SetStatusText;
    property statusSizeGrip: Boolean read FStatusSizeGrip write SetStatusSizeGrip;

    property Localizy: Boolean read FLocalizy write SetLocalizy;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
    {* To provide tooltip (hint) showing, it is necessary to define conditional
       symbol USE_MHTOOLTIP in
       Project|Options|Directories/Conditionals|Conditional Defines. }

    property KeyPreview: Boolean read FKeyPreview write SetKeyPreview;

    property OnClick: TOnEvent read fOnClick write SetOnClick;
    property OnMouseDblClk: TOnMouse read fOnMouseDblClk write SetOnMouseDblClk;
    property OnMouseDown: TOnMouse read FOnMouseDown write SetOnMouseDown;
    property OnMouseMove: TOnMouse read FOnMouseMove write SetOnMouseMove;
    property OnMouseUp: TOnMouse read FOnMouseUp write SetOnMouseUp;
    property OnMouseWheel: TOnMouse read FOnMouseWheel write SetOnMouseWheel;
    property OnMouseEnter: TOnEvent read FOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read FOnMouseLeave write SetOnMouseLeave;
    property OnEnter: TOnEvent read FOnEnter write SetOnEnter;
    property OnLeave: TOnEvent read FOnLeave write SetOnLeave;
    property OnKeyDown: TOnKey read FOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TOnKey read FOnKeyUp write SetOnKeyUp;
    property OnChar: TOnChar read FOnChar write SetOnChar;
    property OnKeyChar: TOnChar read FOnChar write SetOnChar;
    property OnResize: TOnEvent read FOnResize write SetOnResize;
    property OnMove: TOnEvent read FOnMove write SetOnMove;
    property OnMoving: TOnEventMoving read FOnMoving write SetOnMoving;
    property OnDestroy;
    property OnShow: TOnEvent read FOnShow write SetOnShow;
    property OnHide: TOnEvent read FOnHide write SetOnHide;
    property OnDropFiles: TOnDropFiles read FOnDropFiles write SetOnDropFiles;

    property OnFormCreate: TOnEvent read FOnFormCreate write SetOnFormCreate;
    property OnPaint: TOnPaint read FOnPaint write SetOnPaint;
    property OnEraseBkgnd: TOnPaint read FOnEraseBkgnd write SetOnEraseBkgnd;
    property EraseBackground: Boolean read FEraseBackground write SetEraseBackground;
    property supportMnemonics: Boolean read FSupportMnemonics write SetSupportMnemonics;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property OnMaximize: TOnEvent read FOnMaximize write SetOnMaximize;
    property OnHelp: TOnHelp read FOnHelp write SetOnHelp;

    property OnBeforeCreateWindow: TOnEvent read FOnBeforeCreateWindow write SetOnBeforeCreateWindow;
  protected
    FFormAlphabet: TStringList;
    FFormCommandsAndParams: String;
    FFormCtlParams: TStringList;
  public
    FormCurrentCtlForTransparentCalls: String;
    FormCurrentParentCtl: TKOLCustomControl;
    FormIndexFlush: Integer;
    FormFlushedUntil: Integer;
    FormFunArrayIdx: Integer;
    FormControlsList: TStringList;
    IsFormFlushing: Boolean;
    property FormCurrentParent: String read fFormCurrentParent write SetFormCurrentParent;
    function FormIndexOfControl( const CtlName: String ): Integer;
    function EncodeFormNumParameter( I: Integer ): String;
    function FormAddAlphabet( const funname: String; creates_ctrl, add_call: Boolean;
             const Comment: String ): Integer;
    procedure FormAddCtlCommand( const CtlName, FunName, Comment: String );
    procedure FormAddNumParameter( N: Integer );
    procedure FormAddStrParameter( const S: String );
    procedure FormAddCtlParameter( const S: String );
    procedure FormFlushCompact( SL: TFormStringList );
    function FormFlushedCompact: Boolean;
    procedure DoFlushFormCompact( Sender: TObject );
    procedure GenerateTransparentInits_Compact; virtual;
  published
    property FormCompact: Boolean read GetFormCompact write SetFormCompact;
    property GenerateCtlNames: Boolean read FGenerateCtlNames write SetGenerateCtlNames;
    property Unicode: Boolean read FUnicode write SetUnicode;
    property OverrideScrollbars: Boolean read FOverrideScrollbars write SetOverrideScrollbars;
    property AssignTextToControls: Boolean read fAssignTextToControls
             write SetAssignTextToControls default TRUE;
    property AssignTabOrders: Boolean read FAssignTabOrders write SetAssignTabOrders;
  end;



























  TNotifyOperation = ( noRenamed, noRemoved, noChanged );


  //============================================================================
  // Mirror class TKOLObj approximately corresponds to TObj type in
  // KOL objects hierarchy. Here we use it as a base to produce mirror
  // classes, correspondent to non-visual objects in KOL.
  //
  // Зеркальный класс TKOLObj приблизительно соответствует типу TObj
  // в иерархии объектов KOL. От него производятся классы, зеркальные
  // невизуальным объектам KOL.
  TKOLObj = class( TComponent )
  private
    FOnDestroy: TOnEvent;
    F_Tag: Integer;
    FLocalizy: TLocalizyOptions;
    function Get_Tag:Integer ;
    procedure SetOnDestroy(const Value: TOnEvent);
    procedure Set_Tag(const Value: Integer);
    procedure SetLocalizy(const Value: TLocalizyOptions);
  protected
    FNameSetuped: Boolean;
    fP_NameSetuped: Boolean;

    fUpdated: Boolean;

    // A list of components which are linked to the TKOLObj component
    // and must be notifyed when the TKOLObj component is renamed or
    // removed from a form at design time.
    fNotifyList: TList;

    // This priority is used to determine objects of which types should be
    // created before others
    fCreationPriority: Integer;

    // NeedFree is used during code generation to determine if to
    // generate code to destroy the object together with destroying of
    // owning form (Usually True, but some objects, like ImageList
    // can be self-destructing).
    //
    // Поле NeedFree используется в конвертере для определения того,
    // подлежит ли объект принудительному уничтожению методом Free
    // вместе с экземпляром его формы (обычно да, но могут быть объекты
    // вроде ImageList'а, которые разрушают себя сами).
    NeedFree: Boolean;

    procedure SetName( const NewName: TComponentName ); override;
    procedure FirstCreate; virtual;
    function AdditionalUnits: String; virtual;
    procedure GenerateTag( SL: TStringList; const AName, APrefix: String );
    procedure P_GenerateTag( SL: TStringList; const AName, APrefix: String );

    // This method adds operators of creation of object to the end of SL
    // and following ones for adjusting object properties and events.
    //
    // Процедура, которая добавляет в конец SL (:TStringList) операторы
    // создания объекта и те операторы настройки его свойств, которые
    // должны исполняться немедленно вслед за конструированием объекта:
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;
    procedure SetupName( SL: TStringList; const AName, AParent,
                         Prefix: String ); virtual;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;
    procedure P_SetupName( SL: TStringList ); virtual;
    procedure P_SetupFirstFinalizy( SL: TStringList ); virtual;

    procedure P_ProvideFakeType( SL: TStrings; const Declaration: String );

  public
    ObjInStack: Boolean;
    procedure ProvideObjInStack( SL: TStrings );
  protected
    // The same as above, but is called after generating of code to
    // create all child controls and objects - to insert final initialization
    // code (if needed).
    //
    // Аналогично, но вызывается уже после генерации конструирования всех
    // дочерних контролов и объектов формы - для генерации какой-либо
    // завершающей инициализации:
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    procedure DoGenerateConstants( SL: TStringList ); virtual;

    procedure AssignEvents( SL: TStringList; const AName: String ); virtual;
    function P_AssignEvents( SL: TStringList; const AName: String; CheckOnly: Boolean ): Boolean; virtual;

    procedure DoAssignEvents( SL: TStringList; const AName: String;
              const EventNames: array of PAnsiChar; const EventHandlers: array of Pointer );
    function P_DoAssignEvents( SL: TStringList; const AName: String;
              const EventNames: array of PAnsiChar; const EventHandlers: array of Pointer;
              const EventAssignProc: array of Boolean; CheckOnly: Boolean ): Boolean;
    function BestEventName: String; virtual;
    function NotAutoFree: Boolean; virtual;
    function CompareFirst(c, n: string): boolean; virtual;
    function StringConstant( const Propname, Value: String ): String;
    function P_StringConstant( const Propname, Value: String ): String;
  public
    procedure Change; virtual;
    function ParentKOLForm: TKOLForm;
    function OwnerKOLForm( AOwner: TComponent ): TKOLForm;
    function ParentForm: TForm;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;

    procedure AddToNotifyList( Sender: TComponent );

    // procedure which is called by linked components, when those are
    // renamed or removed at design time.
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation );
              virtual;
    procedure DoNotifyLinkedComponents( Operation: TNotifyOperation );

    // Returns type name without <TKol> prefix. (TKOLTimer -> Timer).
    //
    // Данная функция возвращает имя типа объекта KOL (например,
    // зеркальный класс TKOLImageList соответствует типу TImageList в
    // KOL, возвращается 'ImageList').
    function TypeName: String; virtual;
    property Localizy: TLocalizyOptions read FLocalizy write SetLocalizy;

    property CreationPriority: Integer read fCreationPriority;

    function Pcode_Generate: Boolean; virtual;
    procedure P_DoProvideFakeType( SL: TStringList ); virtual;

  published
    property Tag: Integer read Get_Tag write Set_Tag default 0;
    property OnDestroy: TOnEvent read FOnDestroy write SetOnDestroy;
  protected
    CacheLines_SetupFirst: TStringList;
  end;

  TKOLObjectCompEditor = class( TDefaultEditor )
  private
  protected
    FContinue: Boolean;
    FCount: Integer;
    BestEventName: String;
//////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                    //
    FFirst: IProperty;
    FBest: IProperty;
    procedure CountEvents(const PropertyEditor: IProperty );
    procedure CheckEdit(const PropertyEditor: IProperty);
    procedure EditProperty(const PropertyEditor: IProperty;
              var Continue: Boolean); override;
////////////
{$ELSE}                                                 //
//////////////////////////////////////////////////////////
    FFirst: TPropertyEditor;
    FBest: TPropertyEditor;
    procedure CountEvents( PropertyEditor: TPropertyEditor );
    procedure CheckEdit(PropertyEditor: TPropertyEditor);
    procedure EditProperty(PropertyEditor: TPropertyEditor;
      var Continue, FreeEditor: Boolean); override;
//////////////////////////////////////////////////////////
{$ENDIF}                                                //
//////////////////////////////////////////////////////////
  public
    procedure Edit; override;
  end;

  TKOLOnEventPropEditor = class( TMethodProperty )
  private
  protected
    {$IFDEF _D2}
    function GetTrimmedEventName: String;
    function GetFormMethodName: String; virtual;
    {$ENDIF _D2}
  public
    procedure Edit; override;
  end;







  //============================================================================
  //---- MIRROR FOR A MENU ----
  //---- ЗЕРКАЛО ДЛЯ МЕНЮ ----
  TKOLMenu = class;
  TKOLMenuItem = class;

  TKOLAccPrefixes = ( kapShift, kapControl, kapAlt, kapNoinvert );
  TKOLAccPrefix = set of TKOLAccPrefixes;
  TVirtualKey = ( vkNotPresent, vkBACK, vkTAB, vkCLEAR, vkENTER, vkPAUSE, vkCAPITAL,
                  vkESCAPE, vkSPACE, vkPGUP, vkPGDN, vkEND, vkHOME, vkLEFT,
                  vkUP, vkRIGHT, vkDOWN, vkSELECT, vkEXECUTE, vkPRINTSCREEN,
                  vkINSERT, vkDELETE, vkHELP, vk0, vk1, vk2, vk3, vk4, vk5,
                  vk6, vk7, vk8, vk9, vkA, vkB, vkC, vkD, vkE, vkF, vkG, vkH,
                  vkI, vkJ, vkK, vkL, vkM, vkN, vkO, vkP, vkQ, vkR, vkS, vkT,
                  vkU, vkV, vkW, vkX, vkY, vkZ, vkLWIN, vkRWIN, vkAPPS,
                  vkNUM0, vkNUM1, vkNUM2, vkNUM3, vkNUM4, vkNUM5, vkNUM6,
                  vkNUM7, vkNUM8, vkNUM9, vkMULTIPLY, vkADD, vkSEPARATOR,
                  vkSUBTRACT, vkDECIMAL, vkDIVIDE, vkF1, vkF2, vkF3, vkF4,
                  vkF5, vkF6, vkF7, vkF8, vkF9, vkF10, vkF11, vkF12, vkF13,
                  vkF14, vkF15, vkF16, vkF17, vkF18, vkF19, vkF20, vkF21,
                  vkF22, vkF23, vkF24, vkNUMLOCK, vkSCROLL, vkATTN, vkCRSEL,
                  vkEXSEL, vkEREOF, vkPLAY, vkZOOM, vkPA1, vkOEMCLEAR );

  TKOLAccelerator = class(TPersistent)
  private
    FOwner: TComponent;
    FPrefix: TKOLAccPrefix;
    FKey: TVirtualKey;
    procedure SetKey(const Value: TVirtualKey);
    procedure SetPrefix(const Value: TKOLAccPrefix);
  protected
  public
    procedure Change;
    function AsText: String;
  published
    property Prefix: TKOLAccPrefix read FPrefix write SetPrefix;
    property Key: TVirtualKey read FKey write SetKey;
  end;

  TKOLAcceleratorPropEditor = class( TPropertyEditor )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
    procedure Edit; override;
  end;

  {$IFDEF _D2orD3}
    {$WARNINGS OFF}
  {$ENDIF}
  TKOLMenuItem = class(TComponent)
  private
    FCaption: TDelphiString;
    FBitmap: TBitmap;
    FSubitems: TList;
    FChecked: Boolean;
    //FRadioItem: Boolean;
    FEnabled: Boolean;
    FVisible: Boolean;
    FOnMenu: TOnMenuItem;
    FOnMenuMethodName: String;
    FSeparator: Boolean;
    FAccelerator: TKOLAccelerator;
    FParent: TComponent;
    FWindowMenu: Boolean;
    FHelpContext: Integer;
    Fdefault: Boolean;
    FRadioGroup: Integer;
    FbitmapItem: TBitmap;
    FbitmapChecked: TBitmap;
    FownerDraw: Boolean;
    FMenuBreak: TMenuBreak;
    FTag: Integer;
    Faction: TKOLAction;
    FAllowBitmapCompression: Boolean;
    procedure SetBitmap(Value: TBitmap);
    procedure SetCaption(const Value: TDelphiString);
    function GetCount: Integer;
    function GetSubItems(Idx: Integer): TKOLMenuItem;
    procedure SetChecked(const Value: Boolean);
    procedure SetEnabled(const Value: Boolean);
    procedure SetOnMenu(const Value: TOnMenuItem);
    //procedure SetRadioItem(const Value: Boolean);
    procedure SetVisible(const Value: Boolean);
    function GetMenuComponent: TKOLMenu;
    function GetUplevel: TKOLMenuItem;
    procedure SetSeparator(const Value: Boolean);
    function GetItemIndex: Integer;
    procedure SetItemIndex_Dummy(const Value: Integer);
    procedure SetAccelerator(const Value: TKOLAccelerator);
    procedure SetWindowMenu(Value: Boolean);
    procedure SetHelpContext(const Value: Integer);
    //procedure LoadRadioItem(R: TReader);
    //procedure SaveRadioItem(W: TWriter);
    procedure SetbitmapChecked(const Value: TBitmap);
    procedure SetbitmapItem(const Value: TBitmap);
    procedure Setdefault(const Value: Boolean);
    procedure SetRadioGroup(const Value: Integer);
    procedure SetownerDraw(const Value: Boolean);
    procedure SetMenuBreak(const Value: TMenuBreak);
    procedure SetTag(const Value: Integer);
    procedure Setaction(const Value: TKOLAction);
    procedure SetAllowBitmapCompression(const Value: Boolean);
  protected
    FDestroying: Boolean;
    FSubItemCount: Integer;
    procedure SetName( const NewName: TComponentName ); override;
    procedure DefProps( const Prefix: String; Filer: TFiler );
    procedure LoadName( R: TReader );
    procedure SaveName( W: TWriter );
    procedure LoadCaption( R: TReader );
    procedure SaveCaption( W: TWriter );
    procedure LoadEnabled( R: TReader );
    procedure SaveEnabled( W: TWriter );
    procedure LoadVisible( R: TReader );
    procedure SaveVisible( W: TWriter );
    procedure LoadChecked( R: TReader );
    procedure SaveChecked( W: TWriter );
    procedure LoadRadioGroup( R: TReader );
    procedure SaveRadioGroup( W: TWriter );
    procedure LoadOnMenu( R: TReader );
    procedure SaveOnMenu( W: TWriter );
    procedure LoadSubItemCount( R: TReader );
    procedure SaveSubItemCount( W: TWriter );
    procedure LoadBitmap( R: TReader );
    procedure SaveBitmap( W: TWriter );
    procedure LoadSeparator( R: TReader );
    procedure SaveSeparator( W: TWriter );
    procedure LoadAccel( R: TReader );
    procedure SaveAccel( W: TWriter );
    procedure LoadWindowMenu( R: TReader );
    procedure SaveWindowMenu( W: TWriter );
    procedure LoadHelpContext( R: TReader );
    procedure SaveHelpContext( W: TWriter );
    procedure LoadOwnerDraw( R: TReader );
    procedure SaveOwnerDraw( W: TWriter );
    procedure LoadMenuBreak( R: TReader );
    procedure SaveMenuBreak( W: TWriter );
    procedure LoadTag( R: TReader );
    procedure SaveTag( W: TWriter );
    procedure LoadDefault( R: TReader );
    procedure SaveDefault( W: TWriter );
    procedure LoadAction( R: TReader );
    procedure SaveAction( W: TWriter );
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
//    procedure Loaded; override;
  public
    procedure Change;
    property Parent: TComponent read FParent;
    constructor Create( AOwner: TComponent; AParent, Before: TKOLMenuItem );
    {$IFDEF _D4orHigher} reintroduce; {$ENDIF}
    destructor Destroy; override;
    property MenuComponent: TKOLMenu read GetMenuComponent;
    property UplevelMenuItem: TKOLMenuItem read GetUplevel;
    property Count: Integer read GetCount;
    property SubItems[ Idx: Integer ]: TKOLMenuItem read GetSubItems;
    procedure MoveUp;
    procedure MoveDown;
    procedure SetupTemplate( SL: TStringList; FirstItem: Boolean; KF: TKOLForm );
    function P_SetupTemplate( SL: TStringList; DoAdd: Boolean ): Integer;
    procedure SetupAttributes( SL: TStringList; const MenuName: String );
    procedure P_SetupAttributes( SL: TStringList; const MenuName: String );
    procedure SetupAttributesLast( SL: TStringList; const MenuName: String );
    procedure P_SetupAttributesLast( SL: TStringList; const MenuName: String );
    procedure DesignTimeClick;
    function CheckOnMenuMethodExists: Boolean;
  published
    property Tag: Integer read FTag write SetTag;
    property Caption: TDelphiString read FCaption write SetCaption;
    property bitmap: TBitmap read FBitmap write SetBitmap;
    property bitmapChecked: TBitmap read FbitmapChecked write SetbitmapChecked;
    property bitmapItem: TBitmap read FbitmapItem write SetbitmapItem;
    property default: Boolean read Fdefault write Setdefault;
    property enabled: Boolean read FEnabled write SetEnabled;
    property visible: Boolean read FVisible write SetVisible;
    property checked: Boolean read FChecked write SetChecked;
    property radioGroup: Integer read FRadioGroup write SetRadioGroup;
    property separator: Boolean read FSeparator write SetSeparator;
    property accelerator: TKOLAccelerator read FAccelerator write SetAccelerator;
    property MenuBreak: TMenuBreak read FMenuBreak write SetMenuBreak;
    property ownerDraw: Boolean read FownerDraw write SetownerDraw;
    property OnMenu: TOnMenuItem read FOnMenu write SetOnMenu;

    // property ItemIndex is to show only in ObjectInspector index of the
    // item (i.e. integer number, identifying menu item in OnMenu and
    // OnMenuItem events, and also in utility methods to access item
    // properties at run time).
    property itemindex: Integer read GetItemIndex write SetItemIndex_Dummy
             stored False;
    property WindowMenu: Boolean read FWindowMenu write SetWindowMenu;
    property HelpContext: Integer read FHelpContext write SetHelpContext;
    property action: TKOLAction read Faction write Setaction;
    property AllowBitmapCompression: Boolean read FAllowBitmapCompression write SetAllowBitmapCompression
             default TRUE;
  end;
  {$IFDEF _D2orD3}
    {$WARNINGS ON}
  {$ENDIF}

  TKOLMenu = class(TKOLObj)
  private
    FItems: TList;
    FOnMenuItem: TOnMenuItem;
    Fshowshortcuts: Boolean;
    FOnUncheckRadioItem: TOnMenuItem;
    FgenerateConstants: Boolean;
    FgenerateSeparatorConstants: Boolean;
    FOnMeasureItem: TOnMeasureItem;
    FOnDrawItem: TOnDrawItem;
    FOwnerDraw: Boolean;
    function GetCount: Integer;
    function GetItems(Idx: Integer): TKOLMenuItem;
    procedure SetOnMenuItem(const Value: TOnMenuItem);
    procedure Setshowshortcuts(const Value: Boolean);
    procedure SetOnUncheckRadioItem(const Value: TOnMenuItem);
    procedure SetgenerateConstants(const Value: Boolean);
    procedure SetgenerateSeparatorConstants(const Value: Boolean);
    procedure SetOnMeasureItem(const Value: TOnMeasureItem);
    procedure SetOnDrawItem(const Value: TOnDrawItem);
    procedure SetOwnerDraw(const Value: Boolean);
    function AllItemsAreOwnerDraw: Boolean;
  protected
    FItemCount: Integer;
    FUpdateDisabled: Boolean;
    FUpdateNeeded: Boolean;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadItemCount( R: TReader );
    procedure SaveItemCount( W: TWriter );
    procedure SetName( const NewName: TComponentName ); override;
    function OnMenuItemMethodName( for_pcode: Boolean ): String;
  public
    ItemsInStack: Integer;
    // Methods to generate code for creating menu:
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirstFinalizy( SL: TStringList ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    function NotAutoFree: Boolean; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;

    procedure UpdateDisable;
    procedure UpdateEnable;
    procedure UpdateMenu; virtual;
  public
    ActiveDesign: TKOLMenuDesign;
    procedure Change; override;
    procedure UpdateDesign;
    property Items[ Idx: Integer ]: TKOLMenuItem read GetItems;
    property Count: Integer read GetCount;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function NameAlreadyUsed( const ItemName: String ): Boolean;
    procedure SaveTo( WR: TWriter );
    procedure DoGenerateConstants( SL: TStringList ); override;
    function Pcode_Generate: Boolean; override;
  published
    property OnMenuItem: TOnMenuItem read FOnMenuItem write SetOnMenuItem;
    property OnUncheckRadioItem: TOnMenuItem read FOnUncheckRadioItem write SetOnUncheckRadioItem;
    property showShortcuts: Boolean read Fshowshortcuts write Setshowshortcuts;
    property generateConstants: Boolean read FgenerateConstants write SetgenerateConstants;
    property generateSeparatorConstants: Boolean read FgenerateSeparatorConstants write SetgenerateSeparatorConstants;
    property OnMeasureItem: TOnMeasureItem read FOnMeasureItem write SetOnMeasureItem;
    property OnDrawItem: TOnDrawItem read FOnDrawItem write SetOnDrawItem;
    property OwnerDraw: Boolean read FOwnerDraw write SetOwnerDraw;
  end;

  TKOLMainMenu = class(TKOLMenu)
  private
  public
    FOldWndProc: Pointer;
    procedure Loaded; override;
    procedure UpdateMenu; override;
    procedure RestoreWndProc( Wnd: HWnd );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure Change; override;
    procedure RebuildMenubar;
  published
    property Localizy;
  end;

  TPopupMenuFlag = ( tpmVertical, tpmRightButton, tpmCenterAlign, tpmRightAlign,
                  tpmVCenterAlign, tpmBottomAlign, tpmHorPosAnimation,
                  tpmHorNegAnimation, tpmVerPosAnimation, tpmVerNegAnimation,
                  tpmNoAnimation, {+ecm} tpmReturnCmd {/+ecm} );
  TPopupMenuFlags = Set of TPopupMenuFlag;

  TKOLPopupMenu = class(TKOLMenu)
  protected
    FOnPopup: TOnEvent;
    FFlags: TPopupMenuFlags;
    procedure SetOnPopup(const Value: TOnEvent);
    procedure SetFlags(const Value: TPopupMenuFlags);
  public
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    procedure P_DoProvideFakeType( SL: TStringList ); override;
  published
    property Flags: TPopupMenuFlags read FFlags write SetFlags;
    property OnPopup: TOnEvent read FOnPopup write SetOnPopup;
    property Localizy;
  end;

  TKOLMenuEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TKOLOnItemPropEditor = class( TMethodProperty )
  private
  protected
  public
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
  end;























  // Align property (names are another then in VCL).
  // Свойство выравнивания контрола относительно клиентской части родителького
  // контрола.
  TKOLAlign = ( caNone, caLeft, caTop, caRight, caBottom, caClient );

  // Text alignment property.
  // Свойство выравнивания текста по горизонтали. Хотя и определено для всех
  // контролов, актуально только для кнопок и меток.
  TTextAlign = ( taLeft, taRight, taCenter );

  // Text vertical alignment property.
  // Свойство выравнивания текста по вертикали. Хотя и определено в KOL для
  // всех контролов, актуально только для кнопок и меток.
  TVerticalAlign = ( vaTop, vaCenter, vaBottom );









{YS}//--------------------------------------------------------------
// TKOLVCLParent is KOL control that represents VCL parent control.

  PKOLVCLParent = ^TKOLVCLParent;
  TKOLVCLParent = object(kol.TControl)
  public
    OldVCLWndProc: TWndMethod;
    procedure AttachHandle(AHandle: HWND);
    procedure AssignDynHandlers(Src: PKOLVCLParent);
  end;

  TKOLCtrlWrapper = class(TCustomControl)
  protected
    FAllowSelfPaint: boolean;
    FAllowCustomPaint: boolean;
    FAllowPostPaint: boolean;
    procedure Change; virtual;
  protected
{$IFNDEF NOT_USE_KOLCtrlWrapper}
    FKOLParentCtrl: PKOLVCLParent;
    FRealParent: boolean;
    FKOLCtrlNeeded: boolean;

    procedure RemoveParentAttach;
    procedure CallKOLCtrlWndProc(var Message: TMessage);
    function GetKOLParentCtrl: PControl;
  protected
    FKOLCtrl: PControl;

    procedure SetParent( Value: TWinControl ); override;
    procedure WndProc(var Message: TMessage); override;
    procedure DestroyWindowHandle; override;
    procedure DestroyWnd; override;
    procedure CreateWnd; override;
    procedure PaintWindow(DC: HDC); override;
    procedure SetAllowSelfPaint(const Value: boolean); virtual;
    // Override method CreateKOLControl and create instance of real KOL control within it.
    // Example: FKOLCtrl := NewGroupBox(KOLParentCtrl, '');
    procedure CreateKOLControl(Recreating: boolean); virtual;
    // if False control does not paint itself
    property AllowSelfPaint: boolean read FAllowSelfPaint write SetAllowSelfPaint;
    // Update control state according to AllowSelfPaint property
    procedure UpdateAllowSelfPaint;
    // if False and assigned FKOLCtrl then Paint method is not called for control
    property AllowCustomPaint: boolean read FAllowCustomPaint write FAllowCustomPaint;
    // if True and assigned FKOLCtrl then Paint method is called for control
    property AllowPostPaint: boolean read FAllowPostPaint write FAllowPostPaint;
    // Called when KOL control has been recreated. You must set all visual properties
    // of KOL control within this method.
    procedure KOLControlRecreated; virtual;
    // Parent of real KOL control
    property KOLParentCtrl: PControl read GetKOLParentCtrl;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure DefaultHandler(var Message); override;
    procedure Invalidate; override;
{$ENDIF NOT_USE_KOLCtrlWrapper}
  end;
{YS}//--------------------------------------------------------------














  TOnSetBounds = procedure( Sender: TObject; var NewBounds: TRect ) of object;



  //============================================================================
  // BASE CLASS FOR ALL MIRROR CONTROLS.
  // All controls in KOL are determined in a single object type
  // TControl. But in Mirror Classes Kit, we are free to have its own
  // class for every Windows GUI control.
  //
  // БАЗОВЫЙ КЛАСС ДЛЯ ВСЕХ ЗЕРКАЛЬНЫХ КОНТРОЛОВ
  // Все контролы в KOL представлены в едином объекотном типе TControl.
  // Нам никто не мешает тем не менее в визуальном варианте иметь свой
  // собственный зеркальный класс, соответствующий каждому контролу.
  TKOLCustomControl = class( TKOLCtrlWrapper )
  private
    FLikeSpeedButton: Boolean;
    procedure SetLikeSpeedButton(const Value: Boolean);
  public
    function Generate_SetSize: String; virtual;
    function P_Generate_SetSize: String; virtual;
  protected
    fClsStyle: DWORD;
    fExStyle: DWORD;
    fStyle: DWORD;
    fCaption: TDelphiString;
    FTextAlign: TTextAlign;
    fMargin: Integer;
    fOnClick: TOnEvent;
    fCenterOnParent: Boolean;
    fPlaceDown: Boolean;
    fPlaceUnder: Boolean;
    fPlaceRight: Boolean;
    FCtl3D: Boolean;
    FOnDropDown: TOnEvent;
    FOnCloseUp: TOnEvent;
    FOnBitBtnDraw: TOnBitBtnDraw;
    FOnMessage: TOnMessage;
    FTabOrder: Integer;
    FShadowDeep: Integer;
    FOnMouseEnter: TOnEvent;
    FOnMouseLeave: TOnEvent;
    FOnMouseUp: TOnMouse;
    FOnMouseMove: TOnMouse;
    FOnMouseWheel: TOnMouse;
    FOnMouseDown: TOnMouse;
    FOnEnter: TOnEvent;
    FOnLeave: TOnEvent;
    FOnChar: TOnChar;
    FOnDeadChar: TOnChar;
    FOnKeyUp: TOnKey;
    FOnKeyDown: TOnKey;
    FFont: TKOLFont;
    FBrush: TKOLBrush;
    FTransparent: Boolean;
    FOnChange: TOnEvent;
    FDoubleBuffered: Boolean;
    FAdjustingTabOrder: Boolean;
    FOnSelChange: TOnEvent;
    FOnPaint: TOnPaint;
    FOnResize: TOnEvent;
    FOnProgress: TOnEvent;
    FOnDeleteLVItem: TOnDeleteLVItem;
    FOnDeleteAllLVItems: TOnEvent;
    FOnLVData: TOnLVData;
    FOnCompareLVItems: TOnCompareLVItems;
    FOnColumnClick: TOnLVColumnClick;
    FOnDrawItem: TOnDrawItem;
    FOnMeasureItem: TOnMeasureItem;
    FOnDestroy: TOnEvent;
    FParentLikeFontControls: TList;
    FParentLikeColorControls: TList;
    FOnTBDropDown: TOnEvent;
    FParentColor: Boolean;
    FParentFont: Boolean;
    FOnDropFiles: TOnDropFiles;
    FOnHide: TOnEvent;
    FOnShow: TOnEvent;
    FOnRE_URLClick: TOnEvent;
    fOnMouseDblClk: TOnMouse;
    FOnRE_InsOvrMode_Change: TOnEvent;
    FOnRE_OverURL: TOnEvent;
    FCursor: String;
    FFalse: Boolean;
    FMarginTop: Integer;
    FMarginLeft: Integer;
    FMarginRight: Integer;
    FMarginBottom: Integer;
    {$IFDEF KOL_MCK}
    //FParent: PControl;
    {$ENDIF}
    FOnEraseBkgnd: TOnPaint;
    FEraseBackground: Boolean;
    FOnTVSelChanging: TOnTVSelChanging;
    FOnTVBeginDrag: TOnTVBeginDrag;
    FOnTVBeginEdit: TOnTVBeginEdit;
    FOnTVDelete: TOnTVDelete;
    FOnTVEndEdit: TOnTVEndEdit;
    FOnTVExpanded: TOnTVExpanded;
    FOnTVExpanding: TOnTVExpanding;
    FOnLVStateChange: TOnLVStateChange;
    FOnMove: TOnEvent;
    FOnMoving: TOnEventMoving;
    FOnSplit: TOnSplit;
    FOnEndEditLVItem: TOnEditLVItem;
    fChangingNow: Boolean;
    FTag: Integer;
    FOnScroll: TOnScroll;
    FEditTabChar: Boolean;
    FMinWidth: Integer;
    FMaxWidth: Integer;
    FMinHeight: Integer;
    FMaxHeight: Integer;
    FLocalizy: TLocalizyOptions;
    FHelpContext1: Integer;
    FDefaultBtn: Boolean;
    FCancelBtn: Boolean;
    FIsGenerateSize: Boolean;
    FIsGeneratePosition: Boolean;
    Faction: TKOLAction;
    FWindowed: Boolean;
    FAnchorTop: Boolean; //+Sormart
    FAnchorLeft: Boolean;//+Sormart
    FAnchorRight: Boolean;
    FAnchorBottom: Boolean;
    FpopupMenu: TKOLPopupMenu;
    procedure SetAlign(const Value: TKOLAlign); virtual;

    procedure SetClsStyle(const Value: DWORD);
    procedure SetExStyle(const Value: DWORD);
    procedure SetStyle(const Value: DWORD);
    function Get_Color: TColor;
    procedure Set_Color(const Value: TColor);
    procedure SetOnClick(const Value: TOnEvent);
    procedure SetCenterOnParent(const Value: Boolean);
    procedure SetPlaceDown(const Value: Boolean);
    procedure SetPlaceRight(const Value: Boolean);
    procedure SetPlaceUnder(const Value: Boolean);
    procedure SetCtl3D(const Value: Boolean);
    procedure SetOnDropDown(const Value: TOnEvent);
    procedure SetOnCloseUp(const Value: TOnEvent);
    procedure SetOnBitBtnDraw(const Value: TOnBitBtnDraw);
    procedure SetOnMessage(const Value: TOnMessage);
    procedure SetTabStop(const Value: Boolean);
    procedure SetTabOrder(const Value: Integer);
    procedure SetShadowDeep(const Value: Integer);
    procedure SetOnMouseDown(const Value: TOnMouse);
    procedure SetOnMouseEnter(const Value: TOnEvent);
    procedure SetOnMouseLeave(const Value: TOnEvent);
    procedure SetOnMouseMove(const Value: TOnMouse);
    procedure SetOnMouseUp(const Value: TOnMouse);
    procedure SetOnMouseWheel(const Value: TOnMouse);
    procedure SetOnEnter(const Value: TOnEvent);
    procedure SetOnLeave(const Value: TOnEvent);
    procedure SetOnChar(const Value: TOnChar);
    procedure SetOnDeadChar(const Value: TOnChar);
    procedure SetOnKeyDown(const Value: TOnKey);
    procedure SetOnKeyUp(const Value: TOnKey);
    procedure SetFont(const Value: TKOLFont);
    function GetParentFont: Boolean;
    procedure SetParentFont(const Value: Boolean);
    function Get_Visible: Boolean;
    procedure Set_Visible(const Value: Boolean);
    function Get_Enabled: Boolean;
    procedure Set_Enabled(const Value: Boolean);
    procedure SetTransparent(const Value: Boolean);
    procedure SetOnChange(const Value: TOnEvent);
    //function GetHint: String;
    procedure SetDoubleBuffered(const Value: Boolean);
    procedure SetOnSelChange(const Value: TOnEvent);
    procedure SetOnPaint(const Value: TOnPaint);
    procedure SetOnResize(const Value: TOnEvent);
    procedure SetOnProgress(const Value: TOnEvent);
    function GetActualLeft: Integer;
    function GetActualTop: Integer;
    procedure SetActualLeft(Value: Integer);
    procedure SetActualTop(Value: Integer);
    procedure SetOnDeleteAllLVItems(const Value: TOnEvent);
    procedure SetOnDeleteLVItem(const Value: TOnDeleteLVItem);
    procedure SetOnLVData(const Value: TOnLVData);
    procedure SetOnCompareLVItems(const Value: TOnCompareLVItems);
    procedure SetOnColumnClick(const Value: TOnLVColumnClick);
    procedure SetOnDrawItem(const Value: TOnDrawItem);
    procedure SetOnMeasureItem(const Value: TOnMeasureItem);
    procedure SetOnDestroy(const Value: TOnEvent);
    procedure CollectChildrenWithParentFont;
    procedure ApplyFontToChildren;
    procedure SetparentColor(const Value: Boolean);
    function GetParentColor: Boolean;
    procedure CollectChildrenWithParentColor;
    procedure ApplyColorToChildren;
    procedure SetOnTBDropDown(const Value: TOnEvent);
    procedure SetOnDropFiles(const Value: TOnDropFiles);
    procedure SetOnHide(const Value: TOnEvent);
    procedure SetOnShow(const Value: TOnEvent);
    procedure SetOnRE_URLClick(const Value: TOnEvent);
    procedure SetOnMouseDblClk(const Value: TOnMouse);
    procedure SetOnRE_InsOvrMode_Change(const Value: TOnEvent);
    procedure SetOnRE_OverURL(const Value: TOnEvent);
    procedure SetCursor(const Value: String);
    procedure SetMarginBottom(const Value: Integer);
    procedure SetMarginLeft(const Value: Integer);
    procedure SetMarginRight(const Value: Integer);
    procedure SetMarginTop(const Value: Integer);
    procedure SetOnEraseBkgnd(const Value: TOnPaint);
    procedure SetEraseBackground(const Value: Boolean);
    procedure SetOnTVBeginDrag(const Value: TOnTVBeginDrag);
    procedure SetOnTVBeginEdit(const Value: TOnTVBeginEdit);
    procedure SetOnTVDelete(const Value: TOnTVDelete);
    procedure SetOnTVEndEdit(const Value: TOnTVEndEdit);
    procedure SetOnTVExpanded(const Value: TOnTVExpanded);
    procedure SetOnTVExpanding(const Value: TOnTVExpanding);
    procedure SetOnTVSelChanging(const Value: TOnTVSelChanging);
    procedure SetOnLVStateChange(const Value: TOnLVStateChange);
    procedure SetOnMove(const Value: TOnEvent);
    procedure SetOnMoving(const Value: TOnEventMoving);
    procedure SetOnSplit(const Value: TOnSplit);
    procedure SetOnEndEditLVItem(const Value: TOnEditLVItem);
    procedure Set_autoSize(const Value: Boolean);
    procedure SetTag(const Value: Integer);
    procedure SetOnScroll(const Value: TOnScroll);
    procedure SetEditTabChar(const Value: Boolean);
    procedure SetMaxHeight(const Value: Integer);
    procedure SetMaxWidth(const Value: Integer);
    procedure SetMinHeight(const Value: Integer);
    procedure SetMinWidth(const Value: Integer);
    procedure SetLocalizy(const Value: TLocalizyOptions);
    procedure SetHelpContext(const Value: Integer);
    procedure SetCancelBtn(const Value: Boolean);
    procedure SetDefaultBtn(const Value: Boolean);
    procedure SetIgnoreDefault(const Value: Boolean);
    procedure SetBrush(const Value: TKOLBrush);
    procedure SetIsGenerateSize(const Value: Boolean);
    procedure SetIsGeneratePosition(const Value: Boolean);
    procedure Setaction(const Value: TKOLAction);
    procedure SetAnchorLeft(const Value: Boolean); //+Sormart
    procedure SetAnchorTop(const Value: Boolean);  //+Sormart
    procedure SetAnchorBottom(const Value: Boolean);
    procedure SetAnchorRight(const Value: Boolean);
    procedure SetpopupMenu(const Value: TKOLPopupMenu);
    function GetWindowed: Boolean;
  protected
    procedure SetWindowed(const Value: Boolean); virtual;
  protected
    FHint: String;
    FAcceptChildren: Boolean;
    FMouseTransparent: Boolean;
    FHasScrollbarsToOverride: Boolean;
    FOverrideScrollbars: Boolean;
    procedure SetHint(const Value: String);
    procedure SetAcceptChildren(const Value: Boolean);
    procedure SetMouseTransparent(const Value: Boolean);
    procedure SetOverrideScrollbars(const Value: Boolean);
  protected
    FNameSetuped: Boolean;
    fP_NameSetuped: Boolean;

    FVerticalAlign: TVerticalAlign;
    FTabStop: Boolean;
    FautoSize: Boolean;
    fAlign: TKOLAlign;
    DefaultWidth: Integer;
    DefaultHeight: Integer;
    FOnSetBounds: TOnSetBounds;
    DefaultMarginLeft, DefaultMarginTop, DefaultMarginRight,
    DefaultMarginBottom: Integer;
    DefaultAutoSize: Boolean;

    fUpdated: Boolean;
    fNoAutoSizeX: Boolean;
    fAutoSizingNow: Boolean;
    fAutoSzX, fAutoSzY: Integer;
    FHasBorder: Boolean;
    FDefHasBorder: Boolean;

    FDefIgnoreDefault: Boolean;

    // A list of components which are linked to the TKOLObj component
    // and must be notifyed when the TKOLObj component is renamed or
    // removed from a form at design time.
    fNotifyList: TList;

    FIgnoreDefault: Boolean;
    FResetTabStopByStyle: Boolean;
    FWordWrap: Boolean;
    fOrderChild: Integer;
    procedure SetWordWrap(const Value: Boolean);

    procedure SetVerticalAlign(const Value: TVerticalAlign); virtual;
    procedure SetHasBorder(const Value: Boolean); virtual;
    procedure AutoSizeNow; virtual;
    function AutoSizeRunTime: Boolean; virtual;
    function AutoWidth( Canvas: graphics.TCanvas ): Integer; virtual;
    function AutoHeight( Canvas: graphics.TCanvas ): Integer; virtual;
    function ControlIndex: Integer;
    function AdditionalUnits: String; virtual;
    function TabStopByDefault: Boolean; virtual;

    procedure SetMargin(const Value: Integer); virtual;
    procedure SetCaption(const Value: TDelphiString); virtual;
    procedure SetTextAlign(const Value: TTextAlign); virtual;

    // This function returns margins between control edges and edges of client
    // area. These are used to draw border with dark grey at design time.
    function ClientMargins: TRect; virtual;
    function DrawMargins: TRect; virtual;

    function GetTabOrder: Integer; virtual;

    function ParentControlUseAlign: Boolean;

    function ParentKOLControl: TComponent;
    function OwnerKOLForm( AOwner: TComponent ): TKOLForm;
    function ParentKOLForm: TKOLForm;
    function ParentForm: TForm;
    function ParentBounds: TRect;
    function PrevKOLControl: TKOLCustomControl;
    function PrevBounds: TRect;
    function ParentMargin: Integer;

    function TypeName: String; virtual;
    procedure BeforeFontChange( SL: TStrings; const AName, Prefix: String ); virtual;
    procedure P_BeforeFontChange( SL: TStrings; const AName, Prefix: String ); virtual;
    function FontPropName: String; virtual;
    procedure AfterFontChange( SL: TStrings; const AName, Prefix: String ); virtual;
    procedure P_AfterFontChange( SL: TStrings; const AName, Prefix: String ); virtual;

    // Overriden to exclude prefix 'KOL' from names of all controls, dropped
    // onto form at design time. (E.g., when TKOLButton is dropped, its name
    // becomes 'Button1', not 'KOLButton1' as it could be done by default).
    //
    // Процедура SetName переопределена для того, чтобы выбрасывать префикс
    // KOL, присутствующий в названиях зеркальных классов, из вновь созданных
    // имен контролов. Например, TKOLButton -> Button1, а не KOLButton1.
    procedure SetName( const NewName: TComponentName ); override;

    procedure SetParent( Value: TWinControl ); override;

    // This method is created only when control is just dropped onto form.
    // For mirror classes, reflecting to controls, which should display
    // its Caption (like buttons, labels, etc.), it is possible in
    // overriden method to assign name of control itself to Caption property
    // (for instance).
    //
    // Данный метод будет вызываться только в момент "бросания" контрола
    // на форму. Для зеркал кнопок, меток и др. контролов с заголовком,
    // имеет смысл переопределить этот метод, чтобы инициализировать его
    // Caption именем создаваемого объекта.
    procedure FirstCreate; virtual;

    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property VerticalAlign: TVerticalAlign read FVerticalAlign write SetVerticalAlign;
    function VerticalAlignAsKOLVerticalAlign: Integer;

    function RefName: String; virtual;
    function IsCursorDefault: Boolean; virtual;

    // Is called to generate constructor of control and operators to
    // adjust its properties first time.
    //
    // Процедура, которая добавляет в конец SL (:TStringList) операторы
    // создания объекта и те операторы настройки его свойств, которые
    // должны исполняться немедленно вслед за конструированием объекта:
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); virtual;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); virtual;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); virtual;
    procedure SetupSetUnicode( SL: TStringList; const AName: String ); virtual;
    procedure P_SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); virtual;
    procedure SetupName( SL: TStringList; const AName, AParent,
              Prefix: String );
    procedure P_SetupName( SL: TStringList );
    procedure DoGenerateConstants( SL: TStringList ); virtual;

    procedure SetupTabStop( SL: TStringList; const AName: String ); virtual;
    procedure SetupTabOrder( SL: TStringList; const AName: String );
    procedure P_SetupTabStop( SL: TStringList; const AName: String ); virtual;
    function DefaultColor: TColor; virtual;
    {* by default, clBtnFace. Override it for controls, having another
       Color as default. Usually these are controls, which main purpose is
       input (edit controls, list box, list view, tree view, etc.) }
    function DefaultInitialColor: TColor; virtual;
    {* by default, DefaultColor is returned. For some controls this
       value can be overriden to force setting desired Color when the
       control is created first time (just dropped onto form in designer).
       E.g., this value is overriden for TKOLCombobox, which DefaultColor
       is clWindow. }
    function DefaultParentColor: Boolean; virtual;
    {* TRUE, if parentColor should be set to TRUE when the control is
       create (first dropped on form at design time). By default, this
       property is TRUE for controls with DefaultColor=clBtnFace and
       FALSE for all other controls. }
    function DefaultKOLParentColor: Boolean; virtual;
    {* TRUE, if the control is using Color of parent at run time
       by default. At least combo box control is using clWhite
       instead, so this function is overriden for it. This method
       is introduced to optimise code generated. }
    function CanChangeColor: Boolean; virtual;
    {* TRUE, if the Color can be changed (default). This function is
       overriden for TKOLButton, which represents standard GDI button
       and can not have other color then clBtnFace.  }
    procedure SetupColor( SL: TStrings; const AName: String ); virtual;
    function SetupColorFirst: Boolean; virtual;
    procedure P_SetupColor( SL: TStrings; const AName: String; var ControlInStack: Boolean ); virtual;
    //function RunTimeFont: TKOLFont;
    function Get_ParentFont: TKOLFont;
    procedure SetupFont( SL: TStrings; const AName: String ); virtual;
    procedure P_SetupFont( SL: TStrings; const AName: String ); virtual;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); virtual;
    procedure P_SetupTextAlign( SL: TStrings; const AName: String ); virtual;

    procedure P_ProvideFakeType( SL: TStrings; const Declaration: String );
  public
    ControlInStack: Boolean;
  protected
    fCreationOrder: Integer;
    // Is called after generating of constructors of all child controls and
    // objects - to generate final initialization of object (if necessary).
    //
    // Вызывается уже после генерации конструирования всех
    // дочерних контролов и объектов формы - для генерации какой-либо
    // завершающей инициализации:
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
              virtual;

    // Method, which should return string with parameters for constructor
    // call. I.e. braces content in operator
    //     Result.Button1 := NewButton( ... )...;
    //
    // Функция, которая формирует правильные параметры для оператора
    // конструирования объекта (т.е. то, что будет в круглых скобках
    // в операторе: Result.Button1 := NewButton( ... )...;
    function SetupParams( const AName, AParent: TDelphiString ): TDelphiString; virtual;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; virtual;

    // Method to assign values to assigned events. Is called in SetupFirst
    // and actually should call DoAssignEvents, passing a list of (additional)
    // events to it.
    //
    // Процедура присваивания значений назначенным событиям. Вызывается из
    // SetupFirst и фактически должна (после вызова inherited) передать
    // в процедуру DoAssignEvents список (дополнительных) событий.
    procedure AssignEvents( SL: TStringList; const AName: String ); virtual;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; virtual;
  protected
    FEventDefs: TStringList;
    FAssignOnlyUserEvents: Boolean;
    FAssignOnlyWinEvents: Boolean;
  public
    procedure DefineFormEvents( const EventNamesAndDefs: array of String );
    procedure DoAssignEvents( SL: TStringList; const AName: String;
              const EventNames: array of PChar; const EventHandlers: array of Pointer );
    function P_DoAssignEvents( SL: TStringList; const AName: String;
              const EventNames: array of PChar; const EventHandlers: array of Pointer;
              const EventAssignProc: array of Boolean; CheckOnly: Boolean ): Boolean;

    // This method allows to initializy part of properties as a sequence
    // of "transparent" methods calls (see KOL documentation).
    //
    // Функция, которая инициализацию части свойств выполняет в виде
    // последовательности вызовов "прозрачных" методов (см. описание KOL)
    function GenerateTransparentInits: String; virtual;
    function P_GenerateTransparentInits: String; virtual;

    property ShadowDeep: Integer read FShadowDeep write SetShadowDeep;

    property OnDropDown: TOnEvent read FOnDropDown write SetOnDropDown;
    property OnCloseUp: TOnEvent read FOnCloseUp write SetOnCloseUp;
    property OnBitBtnDraw: TOnBitBtnDraw read FOnBitBtnDraw write SetOnBitBtnDraw;
    property OnChange: TOnEvent read FOnChange write SetOnChange;
    property OnSelChange: TOnEvent read FOnSelChange write SetOnSelChange;
    property OnProgress: TOnEvent read FOnProgress write SetOnProgress;
    property OnDeleteLVItem: TOnDeleteLVItem read FOnDeleteLVItem write SetOnDeleteLVItem;
    property OnDeleteAllLVItems: TOnEvent read FOnDeleteAllLVItems write SetOnDeleteAllLVItems;
    property OnLVData: TOnLVData read FOnLVData write SetOnLVData;
    property OnCompareLVItems: TOnCompareLVItems read FOnCompareLVItems write SetOnCompareLVItems;
    property OnColumnClick: TOnLVColumnClick read FOnColumnClick write SetOnColumnClick;
    property OnLVStateChange: TOnLVStateChange read FOnLVStateChange write SetOnLVStateChange;
    property OnEndEditLVItem: TOnEditLVItem read FOnEndEditLVItem write SetOnEndEditLVItem;
    property OnDrawItem: TOnDrawItem read FOnDrawItem write SetOnDrawItem;
    property OnMeasureItem: TOnMeasureItem read FOnMeasureItem write SetOnMeasureItem;
    property OnTBDropDown: TOnEvent read FOnTBDropDown write SetOnTBDropDown;
    property OnSplit: TOnSplit read FOnSplit write SetOnSplit;
    property OnScroll: TOnScroll read FOnScroll write SetOnScroll;

    // Following two properties are to manipulate with Left and Top, corrected
    // to parent's client origin, which can be another than (0,0).
    //
    // Следующие 2 свойства - для работы с Left и Top, подправленными
    // в соответствии с координатами начала клиентской области родителя,
    // которое может быть иное, чем просто (0,0)
    property actualLeft: Integer read GetActualLeft write SetActualLeft;
    property actualTop: Integer read GetActualTop write SetActualTop;

    procedure WantTabs( Want: Boolean ); virtual;
    function CanNotChangeFontColor: Boolean; virtual;

    // Painting of mirror class object by default. It is possible to override it
    // in derived class to make its image lookin like reflecting object as much
    // as possible.
    // To implement WYSIWIG painting, it is necessary to override Paint method,
    // and call inherited Paint one at the end of execution of the overriden
    // method (to provide additional painting, controlled by TKOLProject.PaintType
    // property and TKOLForm.PaintAdditionally property). Also, override method
    // WYSIWIGPaintImplemented function to return TRUE, this is also necessary
    // to provide correct additional painting in inherited Paint method.
    //
    // Отрисовка зеркального объекта по умолчанию. Можно заменить в наследуемом
    // классе конкретного зеркального класса на процедуру, в которой объект
    // изображается максимально похожим на оригинал.
    // Для реализации отрисовки контрола в режиме "как он должен выглядеть",
    // следует переопределить метод Paint, и вызвать унаследованный метод Paint
    // на конце исполнения переопределенного (для обеспечиния дополнительных функций
    // отрисовки, в соответствии со свойствами TKOLProject.PaintType и
    // TKOLForm.PaintAdditionally). Также, следует переопределить функцию
    // WYSIWIGPaintImplemented, чтобы она возвращала TRUE - это так же необходимо
    // для обеспечения правильной дополнительной отрисовки в унаследованном
    // методе Paint.
    procedure Paint; override;

    function PaintType: TPaintType;
    function WYSIWIGPaintImplemented: Boolean; virtual;
    procedure PrepareCanvasFontForWYSIWIGPaint( ACanvas: TCanvas );
    function NoDrawFrame: Boolean; virtual;

    //-- by Alexander Shakhaylo - to allow sort objects
    function CompareFirst(c, n: string): boolean; virtual;

    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    function StringConstant( const Propname, Value: TDelphiString ): TDelphiString;
    function P_StringConstant( const Propname, Value: String ): String;
    function BestEventName: String; virtual;
    function GetDefaultControlFont: HFONT; virtual;
    procedure KOLControlRecreated;
    {$IFNDEF NOT_USE_KOLCTRLWRAPPER}
     override;
    {$ELSE NOT_USE_KOLCTRLWRAPPER}
     virtual;
    procedure CreateKOLControl(Recreating: boolean); virtual;
    procedure UpdateAllowSelfPaint;
  protected
    FKOLCtrl: PControl;
    FKOLParentCtrl: PControl;
    property KOLParentCtrl: PControl read FKOLParentCtrl;
    {$ENDIF NOT_USE_KOLCTRLWRAPPER}
    property AllowPostPaint: boolean read FAllowPostPaint write FAllowPostPaint;
    property AllowSelfPaint: boolean read FAllowSelfPaint write FAllowSelfPaint;
    property AllowCustomPaint: boolean read FAllowCustomPaint write FAllowCustomPaint;
    property WordWrap: Boolean read FWordWrap write SetWordWrap; // only for graphic button (Windowed = FALSE)
    property LikeSpeedButton: Boolean read FLikeSpeedButton write SetLikeSpeedButton;
  public
    function Pcode_Generate: Boolean; virtual;
    property IsGenerateSize: Boolean read FIsGenerateSize write SetIsGenerateSize;
    property IsGeneratePosition: Boolean read FIsGeneratePosition write SetIsGeneratePosition;
    procedure Change; override;

    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure AddToNotifyList( Sender: TComponent );

    // procedure which is called by linked components, when those are
    // renamed or removed at design time.
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation );
              virtual;
    procedure DoNotifyLinkedComponents( Operation: TNotifyOperation );

    property Style: DWORD read fStyle write SetStyle;
    property ExStyle: DWORD read fExStyle write SetExStyle;
    property ClsStyle: DWORD read fClsStyle write SetClsStyle;
    procedure Click; override;
    procedure SetBounds( aLeft, aTop, aWidth, aHeight: Integer ); override;
    procedure ReAlign( ParentOnly: Boolean );
    property Transparent: Boolean read FTransparent write SetTransparent;

    property TabStop: Boolean read FTabStop write SetTabStop;

    property OnEnter: TOnEvent read FOnEnter write SetOnEnter;
    property OnLeave: TOnEvent read FOnLeave write SetOnLeave;
    property OnKeyDown: TOnKey read FOnKeyDown write SetOnKeyDown;
    property OnKeyUp: TOnKey read FOnKeyUp write SetOnKeyUp;
    property OnChar: TOnChar read FOnChar write SetOnChar;
    property OnKeyChar: TOnChar read FOnChar write SetOnChar;
    property OnKeyDeadChar: TOnChar read FOnDeadChar write SetOnDeadChar;
    property Margin: Integer read fMargin write SetMargin;
    property Border: Integer read fMargin write SetMargin;
    function BorderNeeded: Boolean; virtual;
    property MarginLeft: Integer read FMarginLeft write SetMarginLeft;
    property MarginRight: Integer read FMarginRight write SetMarginRight;
    property MarginTop: Integer read FMarginTop write SetMarginTop;
    property MarginBottom: Integer read FMarginBottom write SetMarginBottom;
    property OnRE_URLClick: TOnEvent read FOnRE_URLClick write SetOnRE_URLClick;
    property OnRE_OverURL: TOnEvent read FOnRE_OverURL write SetOnRE_OverURL;
    property OnRE_InsOvrMode_Change: TOnEvent read FOnRE_InsOvrMode_Change write SetOnRE_InsOvrMode_Change;
    property OnTVBeginDrag: TOnTVBeginDrag read FOnTVBeginDrag write SetOnTVBeginDrag;
    property OnTVBeginEdit: TOnTVBeginEdit read FOnTVBeginEdit write SetOnTVBeginEdit;
    property OnTVEndEdit: TOnTVEndEdit read FOnTVEndEdit write SetOnTVEndEdit;
    property OnTVExpanding: TOnTVExpanding read FOnTVExpanding write SetOnTVExpanding;
    property OnTVExpanded: TOnTVExpanded read FOnTVExpanded write SetOnTVExpanded;
    property OnTVDelete: TOnTVDelete read FOnTVDelete write SetOnTVDelete;
    property OnTVSelChanging: TOnTVSelChanging read FOnTVSelChanging write SetOnTVSelChanging;
    property autoSize: Boolean read FautoSize write Set_autoSize;
    property HasBorder: Boolean read FHasBorder write SetHasBorder;
    property EditTabChar: Boolean read FEditTabChar write SetEditTabChar;
  //published
    property TabOrder: Integer read GetTabOrder write SetTabOrder;
    // This section contains published properties, available in Object
    // Inspector at design time.
    //
    // В раздел published попадают свойства, которые могут изменяться из
    // Инспектора Объектов в design time. Воспользуемся этим, и разместим
    // здесь такие свойства визуальных объектов KOL, которые удобно
    // было бы настроить визуально.

    // Bound properties can be not overriden, Change is called therefore
    // when these are changed (because SetBounds is overriden)
    property Left;
    property Top;
    property Width;
    property Height;

    property MinWidth: Integer read FMinWidth write SetMinWidth;
    property MinHeight: Integer read FMinHeight write SetMinHeight;
    property MaxWidth: Integer read FMaxWidth write SetMaxWidth;
    property MaxHeight: Integer read FMaxHeight write SetMaxHeight;

    property Cursor_: String read FCursor write SetCursor;
    property Cursor: Boolean read FFalse;

    property PlaceDown: Boolean read fPlaceDown write SetPlaceDown;
    property PlaceRight: Boolean read fPlaceRight write SetPlaceRight;
    property PlaceUnder: Boolean read fPlaceUnder write SetPlaceUnder;

    property Visible: Boolean read Get_Visible write Set_Visible;
    property Enabled: Boolean read Get_Enabled write Set_Enabled;

    property DoubleBuffered: Boolean read FDoubleBuffered write SetDoubleBuffered;

    // Property Align is redeclared to provide type correspondence
    // (to avoid conflict between VCL.Align and KOL.Align).
    //
    // Свойство Align переопределено, чтобы обеспечить соответствие
    // наименований типов выравнивания между VCL.Align и KOL.Align.
    property Align: TKOLAlign read fAlign write SetAlign;

    property CenterOnParent: Boolean read fCenterOnParent write SetCenterOnParent;

    property Caption: TDelphiString read fCaption write SetCaption;
    property Ctl3D: Boolean read FCtl3D write SetCtl3D;

    property Color: TColor read Get_Color write Set_Color;
    property parentColor: Boolean read GetParentColor write SetparentColor;
    property Font: TKOLFont read FFont write SetFont;
    property Brush: TKOLBrush read FBrush write SetBrush;
    property parentFont: Boolean read GetParentFont write SetParentFont;

    property OnClick: TOnEvent read fOnClick write SetOnClick;
    property OnMouseDblClk: TOnMouse read fOnMouseDblClk write SetOnMouseDblClk;
    property OnDestroy: TOnEvent read FOnDestroy write SetOnDestroy;
    property OnMessage: TOnMessage read FOnMessage write SetOnMessage;
    property OnMouseDown: TOnMouse read FOnMouseDown write SetOnMouseDown;
    property OnMouseMove: TOnMouse read FOnMouseMove write SetOnMouseMove;
    property OnMouseUp: TOnMouse read FOnMouseUp write SetOnMouseUp;
    property OnMouseWheel: TOnMouse read FOnMouseWheel write SetOnMouseWheel;
    property OnMouseEnter: TOnEvent read FOnMouseEnter write SetOnMouseEnter;
    property OnMouseLeave: TOnEvent read FOnMouseLeave write SetOnMouseLeave;
    property OnResize: TOnEvent read FOnResize write SetOnResize;
    property OnMove: TOnEvent read FOnMove write SetOnMove;
    property OnMoving: TOnEventMoving read FOnMoving write SetOnMoving;
    property OnDropFiles: TOnDropFiles read FOnDropFiles write SetOnDropFiles;
    property OnShow: TOnEvent read FOnShow write SetOnShow;
    property OnHide: TOnEvent read FOnHide write SetOnHide;
    property OnPaint: TOnPaint read FOnPaint write SetOnPaint;
    property OnEraseBkgnd: TOnPaint read FOnEraseBkgnd write SetOnEraseBkgnd;
    property EraseBackground: Boolean read FEraseBackground write SetEraseBackground;

    property Tag: Integer read FTag write SetTag;
    property Hint: String read FHint write SetHint;

    property HelpContext: Integer read FHelpContext1 write SetHelpContext;
    property Localizy: TLocalizyOptions read FLocalizy write SetLocalizy;
    property DefaultBtn: Boolean read FDefaultBtn write SetDefaultBtn;
    property CancelBtn: Boolean read FCancelBtn write SetCancelBtn;
    property action: TKOLAction read Faction write Setaction stored False;
    property Windowed: Boolean read GetWindowed write SetWindowed;
    property popupMenu: TKOLPopupMenu read FpopupMenu write SetpopupMenu;
    property OverrideScrollbars: Boolean read FOverrideScrollbars write SetOverrideScrollbars;
  protected
    fOldWidth, fOldHeight: Integer;
  published
    property IgnoreDefault: Boolean read FIgnoreDefault write SetIgnoreDefault;
    property AnchorLeft: Boolean read FAnchorLeft write SetAnchorLeft; //+Sormart
    property AnchorTop: Boolean read FAnchorTop write SetAnchorTop;    //+Sormart
    property AnchorRight: Boolean read FAnchorRight write SetAnchorRight;
    property AnchorBottom: Boolean read FAnchorBottom write SetAnchorBottom;
    property AcceptChildren: Boolean read FAcceptChildren write SetAcceptChildren;
    property MouseTransparent: Boolean read FMouseTransparent write SetMouseTransparent;
  protected
    function SupportsFormCompact: Boolean; virtual;
    function HasCompactConstructor: Boolean; virtual;
    procedure SetupConstruct_Compact; virtual;
    procedure GenerateTransparentInits_Compact; virtual;
    procedure Generate_SetSize_Compact; virtual;
    procedure GenerateVerticalAlign( SL: TStrings; const AName: String );
    procedure GenerateTextAlign( SL: TStrings; const AName: String );
    function DefaultBorder: Integer; virtual;
  end;

  TKOLControl = class( TKOLCustomControl )
  public
    function Generate_SetSize: String; override;
    procedure Change; override;
  published
    property TabOrder;
    property Left;
    property Top;
    property Width;
    property Height;

    property MinWidth;
    property MinHeight;
    property MaxWidth;
    property MaxHeight;
    property Cursor_;
    property PlaceDown;
    property PlaceRight;
    property PlaceUnder;
    property Visible;
    property Enabled;
    property DoubleBuffered;
    property Align;
    property CenterOnParent;
    property Caption;
    property Ctl3D;
    property Color;
    property parentColor;
    property Font;
    property parentFont;
    property OnClick;
    property OnMouseDblClk;
    property OnDestroy;
    property OnMessage;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnResize;
    property OnMove;
    property OnMoving;
    property OnDropFiles;
    property OnShow;
    property OnHide;
    property OnPaint;
    property OnEraseBkgnd;
    property EraseBackground;
    property Tag;
    property HelpContext;
    property Localizy;
    property Hint;
  end;


  {$IFDEF _D5}
  TLeftPropEditor = class( TIntegerProperty )
  private
    function VisualValue: string;
  protected
  public
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
  end;

  TTopPropEditor = class( TIntegerProperty )
  private
    function VisualValue: string;
  protected
  public
    procedure PropDrawValue(ACanvas: TCanvas; const ARect: TRect;
      ASelected: Boolean); override;
  end;
  {$ENDIF}

  TCursorPropEditor = class( TPropertyEditor )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;











  //============================================================================
  // Special component, intended to use it instead TKOLForm and to implement a
  // unit, which contains MDI child form.
  TKOLMDIChild = class( TKOLForm )
  private
    FParentForm: String;
    fNotAvailable: Boolean;
    procedure SetParentForm(const Value: String);
  protected
    procedure GenerateCreateForm( SL: TStringList ); override;
    function DoNotGenerateSetPosition: Boolean; override;
  public
  published
    property ParentMDIForm: String read FParentForm write SetParentForm;
    property OnQueryEndSession: Boolean read fNotAvailable;
  end;

  TParentMDIFormPropEditor = class( TPropertyEditor )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure GetValues(Proc: TGetStrProc); override;
    function GetValue: string; override;
    procedure SetValue(const Value: string); override;
  end;


  //============================================================================
  // Special component, intended to use it instead TKOLForm and to implement a
  // unit, which does not contain a form, but non-visual KOL objects only.
  TDataModuleHowToDestroy = ( ddAfterRun, ddOnAppletDestroy, ddManually );

  TKOLDataModule = class( TKOLForm )
  private
    FOnCreate: TOnEvent;
    FhowToDestroy: TDataModuleHowToDestroy;
    procedure SetOnCreate(const Value: TOnEvent);
    procedure SethowToDestroy(const Value: TDataModuleHowToDestroy);
  protected
    fNotAvailable: Boolean;
    function GenerateTransparentInits: String; override;
    function GenerateINC( const Path: String; var Updated: Boolean ): Boolean; override;
    procedure GenerateCreateForm( SL: TStringList ); override;
    function Result_Form: String; override;
    procedure GenerateDestroyAfterRun( SL: TStringList ); override;
    procedure GenerateAdd2AutoFree( SL: TStringList; const AName: String;
              AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject ); override;
    procedure P_GenerateAdd2AutoFree( SL: TStringList; const AName: String;
              AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
      override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String );
      override;
  public
  published
    property Locked;
    property formName: Boolean read fNotAvailable;
    property formUnit;
    property formMain;
    property defaultPosition: Boolean read fNotAvailable;
    property Caption: Boolean read fNotAvailable;
    property Visible: Boolean read fNotAvailable;
    property Enabled: Boolean read fNotAvailable;
    property Tabulate: Boolean read fNotAvailable;
    property TabulateEx: Boolean read fNotAvailable;
    property bounds: Boolean read fNotAvailable;
    property defaultSize: Boolean read fNotAvailable;
    property HasBorder: Boolean read fNotAvailable;
    property HasCaption: Boolean read fNotAvailable;
    property MarginLeft: Boolean read fNotAvailable;
    property MarginTop: Boolean read fNotAvailable;
    property MarginRight: Boolean read fNotAvailable;
    property MarginBottom: Boolean read fNotAvailable;
    property Tag: Boolean read fNotAvailable;
    property StayOnTop: Boolean read fNotAvailable;
    property CanResize: Boolean read fNotAvailable;
    property CenterOnScreen: Boolean read fNotAvailable;
    property Ctl3D: Boolean read fNotAvailable;
    property WindowState: Boolean read fNotAvailable;
    property minimizeIcon: Boolean read fNotAvailable;
    property maximizeIcon: Boolean read fNotAvailable;
    property closeIcon: Boolean read fNotAvailable;
    property Icon: Boolean read fNotAvailable;
    property Cursor: Boolean read fNotAvailable;
    property Color: Boolean read fNotAvailable;
    property Font: Boolean read fNotAvailable;
    property DoubleBuffered: Boolean read fNotAvailable;
    property PreventResizeFlicks: Boolean read fNotAvailable;
    property Transparent: Boolean read fNotAvailable;
    property AlphaBlend: Boolean read fNotAvailable;
    property Margin: Boolean read fNotAvailable;
    property Border: Boolean read fNotAvailable;
    property MinimizeNormalAnimated: Boolean read fNotAvailable;
    property RestoreNormalMaximized: Boolean read fNotAvailable;
    property zOrderChildren: Boolean read fNotAvailable;
    property SimpleStatusText: Boolean read fNotAvailable;
    property StatusText: Boolean read fNotAvailable;
    property OnClick: Boolean read fNotAvailable;
    property OnMouseDown: Boolean read fNotAvailable;
    property OnMouseMove: Boolean read fNotAvailable;
    property OnMouseUp: Boolean read fNotAvailable;
    property OnMouseWheel: Boolean read fNotAvailable;
    property OnMouseEnter: Boolean read fNotAvailable;
    property OnMouseLeave: Boolean read fNotAvailable;
    property OnMouseDblClk: Boolean read fNotAvailable;
    property OnEnter: Boolean read fNotAvailable;
    property OnLeave: Boolean read fNotAvailable;
    property OnKeyDown: Boolean read fNotAvailable;
    property OnKeyUp: Boolean read fNotAvailable;
    property OnChar: Boolean read fNotAvailable;
    property OnResize: Boolean read fNotAvailable;
    property OnShow: Boolean read fNotAvailable;
    property OnHide: Boolean read fNotAvailable;
    property OnMessage: Boolean read fNotAvailable;
    property OnClose: Boolean read fNotAvailable;
    property OnMinimize: Boolean read fNotAvailable;
    property OnMaximize: Boolean read fNotAvailable;
    property OnRestore: Boolean read fNotAvailable;
    property OnPaint: Boolean read fNotAvailable;
    property OnEraseBkgnd: Boolean read fNotAvailable;

    property OnFormCreate: Boolean read fNotAvailable;
    property OnCreate: TOnEvent read FOnCreate write SetOnCreate;
    property OnDestroy;
    property howToDestroy: TDataModuleHowToDestroy read FhowToDestroy write SethowToDestroy;

    property MinWidth: Boolean read fNotAvailable;
    property MinHeight: Boolean read fNotAvailable;
    property MaxWidth: Boolean read fNotAvailable;
    property MaxHeight: Boolean read fNotAvailable;
    property OnQueryEndSession: Boolean read fNotAvailable;

    property HelpContext: Boolean read fNotAvailable;
    property OnHelp: Boolean read fNotAvailable;
  end;








  //============================================================================
  // Special component, intended to use it instead TKOLForm and to implement a
  // unit, which can contain several visual and non-visual MCK components, which
  // can be adjusted at design time on a standalone designer form, and created
  // on KOL form at run time, like a panel with such controls.
  TKOLFrame = class( TKOLForm )
  private
    FEdgeStyle: TEdgeStyle;
    fNotAvailable: Boolean;
    FAlign: TKOLAlign;
    FCenterOnParent: Boolean;
    FzOrderTopmost: Boolean;
    fFrameCaption: String;
    FParentFont: Boolean;
    FParentColor: Boolean;
    procedure SetEdgeStyle(const Value: TEdgeStyle);
    procedure SetAlign(const Value: TKOLAlign);
    procedure SetCenterOnParent(const Value: Boolean);
    procedure SetzOrderTopmost(const Value: Boolean);
    function GetFrameHeight: Integer;
    function GetFrameWidth: Integer;
    procedure SetFrameHeight(const Value: Integer);
    procedure SetFrameWidth(const Value: Integer);
    procedure SetFrameCaption(const Value: String);
    procedure SetParentColor(const Value: Boolean);
    procedure SetParentFont(const Value: Boolean);
  protected
    function AutoCaption: Boolean; override;
    function GetCaption: TDelphiString; override;
    function GenerateTransparentInits: String; override;
    function P_GenerateTransparentInits: String; override;
    procedure GenerateCreateForm( SL: TStringList ); override;
    procedure P_GenerateCreateForm( SL: TStringList ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure GenerateAdd2AutoFree( SL: TStringList; const AName: String;
              AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject ); override;
    procedure P_GenerateAdd2AutoFree( SL: TStringList; const AName: String;
              AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject ); override;
  public
    constructor Create( AOwner: TComponent ); override;
  published
    property EdgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property FormMain: Boolean read fNotAvailable;
    property AlphaBlend: Boolean read fNotAvailable;
    property bounds: Boolean read fNotAvailable;
    property Width: Integer read GetFrameWidth write SetFrameWidth;
    property Height: Integer read GetFrameHeight write SetFrameHeight;
    property Align: TKOLAlign read FAlign write SetAlign;
    property CenterOnParent: Boolean read FCenterOnParent write SetCenterOnParent;
    property zOrderTopmost: Boolean read FzOrderTopmost write SetzOrderTopmost;
    property CanResize: Boolean read fNotAvailable;
    property defaultPosition: Boolean read fNotAvailable;
    property defaultSize: Boolean read fNotAvailable;
    property HasBorder: Boolean read fNotAvailable;
    property HasCaption: Boolean read fNotAvailable;
    property Icon: Boolean read fNotAvailable;
    property maximizeIcon: Boolean read fNotAvailable;
    property minimizeIcon: Boolean read fNotAvailable;
    property MinimizeNormalAnimated: Boolean read fNotAvailable;
    property RestoreNormalMaximized: Boolean read fNotAvailable;
    property PreventResizeFlicks: Boolean read fNotAvailable;
    property SimpleStatusText: Boolean read fNotAvailable;
    property StatusText: Boolean read fNotAvailable;
    property StayOnTop: Boolean read fNotAvailable;
    property Tabulate: Boolean read fNotAvailable;
    property TabulateEx: Boolean read fNotAvailable;
    property WindowState: Boolean read fNotAvailable;
    property Caption: String read fFrameCaption write SetFrameCaption;
    property ParentColor: Boolean read FParentColor write SetParentColor;
    property ParentFont: Boolean read FParentFont write SetParentFont;
    property OnQueryEndSession: Boolean read fNotAvailable;
    property OnClose: Boolean read fNotAvailable;
    property OnMinimize: Boolean read fNotAvailable;
    property OnMaximize: Boolean read fNotAvailable;
    property OnRestore: Boolean read fNotAvailable;
    property OnHelp: Boolean read fNotAvailable;
  end;


  TKOLAction = class(TKOLObj)
  private
    FLinked: TStringList;
    FActionList: TKOLActionList;
    FVisible: boolean;
    FChecked: boolean;
    FEnabled: boolean;
    FHelpContext: integer;
    FHint: string;
    FCaption: string;
    FOnExecute: TOnEvent;
    FAccelerator: TKOLAccelerator;
    procedure SetCaption(const Value: string);
    procedure SetChecked(const Value: boolean);
    procedure SetEnabled(const Value: boolean);
    procedure SetHelpContext(const Value: integer);
    procedure SetHint(const Value: string);
    procedure SetOnExecute(const Value: TOnEvent);
    procedure SetVisible(const Value: boolean);
    procedure SetAccelerator(const Value: TKOLAccelerator);
    procedure SetActionList(const Value: TKOLActionList);
    function GetIndex: Integer;
    procedure SetIndex(Value: Integer);
    procedure ResolveLinks;
    function FindComponentByPath(const Path: string): TComponent;
    function GetComponentFullPath(AComponent: TComponent): string;
    procedure UpdateLinkedComponent(AComponent: TComponent);
    procedure UpdateLinkedComponents;
  protected
    procedure ReadState(Reader: TReader); override;
    procedure SetParentComponent(AParent: TComponent); override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadLinks(R: TReader);
    procedure SaveLinks(W: TWriter);
    procedure Loaded; override;
    procedure SetName(const NewName: TComponentName); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  protected
    FNameSetuppingInParent: Boolean;
    procedure SetupName( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupName( SL: TStringList ); override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function GetParentComponent: TComponent; override;
    function HasParent: Boolean; override;
    procedure Assign(Source: TPersistent); override;
    property ActionList: TKOLActionList read FActionList write SetActionList stored False;
    property Index: Integer read GetIndex write SetIndex stored False;
    procedure LinkComponent(const AComponent: TComponent);
    procedure UnLinkComponent(const AComponent: TComponent);
    function AdditionalUnits: String; override;
  published
    property Caption: string read FCaption write SetCaption;
    property Hint: string read FHint write SetHint;
    property Checked: boolean read FChecked write SetChecked default False;
    property Enabled: boolean read FEnabled write SetEnabled default True;
    property Visible: boolean read FVisible write SetVisible default True;
    property HelpContext: integer read FHelpContext write SetHelpContext default 0;
    property Accelerator: TKOLAccelerator read FAccelerator write SetAccelerator;
    property OnExecute: TOnEvent read FOnExecute write SetOnExecute;
  end;

  TKOLActionList = class(TKOLObj)
  protected
    FActions: TList;
    FOnUpdateActions: TOnEvent;
    function GetKOLAction(Index: Integer): TKOLAction;
    procedure SetKOLAction(Index: Integer; const Value: TKOLAction);
    function GetCount: integer;
    procedure SetOnUpdateActions(const Value: TOnEvent);
  public
    procedure GetChildren(Proc: TGetChildProc {$IFDEF _D3orHigher} ; Root: TComponent {$ENDIF} ); override;
    procedure SetChildOrder(Component: TComponent; Order: Integer); override;

    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    ActiveDesign: TfmActionListEditor;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Actions[Index: Integer]: TKOLAction read GetKOLAction write SetKOLAction; default;
    property Count: integer read GetCount;
    property List: TList read FActions;
    function AdditionalUnits: String; override;
  published
    property OnUpdateActions: TOnEvent read FOnUpdateActions write SetOnUpdateActions;
  end;

  TKOLActionListEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;








var
  // Variable KOLProject refers to a TKOLProject instance (must be
  // single in a project).
  //
  // Переменная KOLProject содержит указатель на представитель класса
  // TKOLProject (который должен быть единственным)
  KOLProject: TKOLProject;
  GlobalNewIF: Boolean = {$IFDEF _D6orHigher} TRUE {$ELSE} FALSE {$ENDIF};

function BuildKOLProject: Boolean;

var
  // Applet variable refers to (unnecessary) instance of TKOLApplet
  // class instance.
  //
  // Переменная Applet содержит ссылку на (неоябязательный) представитель
  // класса TKOLApplet (соответствующий объекту APPLET в KOL).
  Applet: TKOLApplet;

  // List of all TKOLForm objects created - provides access to all of them
  // (e.g. from TKOLProject) at design time and at run time.
  //
  // Список FormsList содержит ссылки на все объекты класса TKOLForm
  // проекта, обеспечивая доступ к ним из объект KOLProject (он должен
  // суметь перечислить все формы, чтобы сгенерировать код для них).
  FormsList: TList;

function Color2Str( Color: TColor ): String;

procedure Log( const S: String );
procedure LogOK ;
procedure Rpt( const S: String; Color: Integer );
procedure RptDetailed( const S: String; Color: Integer );
procedure Rpt_Stack;

function ProjectSourcePath: String;
function Get_ProjectName: String;
//dufa
{$IFDEF _D2005orHigher}
function Get_ProjectGroup: IOTAProjectGroup;
{$ENDIF}

procedure AddLongTextField( var SL: TStringList; const Prefix:String;
 const Text:TDelphiString; const Suffix:String; const LinePrefix: String );

//*///////////////////////////////////////
  {$IFDEF _D6orHigher}                  //
type
  IFormDesigner = IDesigner;            //
  {$ENDIF}                              //
//*///////////////////////////////////////

  {$IFDEF _D2orD3}
type
  IDesigner = TDesigner;
  IFormDesigner = TFormDesigner;
  {$ENDIF}


function QueryFormDesigner( D: IDesigner; var FD: IFormDesigner ): Boolean;



function PCharStringConstant( Sender: TObject; const Propname, Value: String ): String;
function P_PCharStringConstant( Sender: TObject; const Propname, Value: String ): String;

procedure LoadSource( SL: TStrings; const Path: String );
procedure SaveStrings( SL: TStrings; const Path: String; var Updated: Boolean );
procedure SaveStringToFile(const Path, Str: String );
procedure MarkModified( const Path: String );

//procedure OutSortedListOfComponents( const path: String; L: TList; ii: Integer );

const
  Signature = '{ KOL MCK } // Do not remove this line!';

const TextAligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );
      VertAligns: array[ TVerticalAlign ] of String = ( 'vaTop', 'vaCenter', 'vaBottom' );



procedure Register;

{$R KOLmirrors.dcr}

function Remove_Result_dot( const s: String ): String;

implementation

uses ShellAPI {$IFNDEF _D2}, shlobj, ActiveX {$ENDIF},
     mckCtrls, mckObjs;

  procedure Register;
  begin
    RegisterComponents( 'KOL', [ TKOLProject, TKOLApplet, TKOLForm, TKOLMDIChild,
                                 TKOLDataModule, TKOLFrame, TKOLActionList ] );
    RegisterComponentEditor( TKOLProject, TKOLProjectBuilder );
    {$IFDEF _D5}
    RegisterPropertyEditor( TypeInfo( Integer ), TKOLCustomControl, 'Left', TLeftPropEditor );
    RegisterPropertyEditor( TypeInfo( Integer ), TKOLCustomControl, 'Top', TTopPropEditor );
    {$ENDIF}
    RegisterComponentEditor( TKOLObj, TKOLObjectCompEditor );
    RegisterComponentEditor( TKOLApplet, TKOLObjectCompEditor );
    RegisterComponentEditor( TKOLCustomControl, TKOLObjectCompEditor );
    RegisterPropertyEditor( TypeInfo( TOnEvent ), nil, '', TKOLOnEventPropEditor );
    RegisterPropertyEditor( TypeInfo( TOnMessage ), nil, '', TKOLOnEventPropEditor );
    RegisterPropertyEditor( TypeInfo( String ), TKOLCustomControl, 'Cursor_', TCursorPropEditor  );
    RegisterPropertyEditor( TypeInfo( String ), TKOLForm, 'Cursor', TCursorPropEditor );
    RegisterPropertyEditor( TypeInfo( String ), TKOLMDIChild, 'ParentMDIForm', TParentMDIFormPropEditor );
    RegisterComponentEditor( TKOLMenu, TKOLMenuEditor );
    RegisterPropertyEditor( TypeInfo( TOnMenuItem ), TKOLMenuItem, 'OnMenu',
                            TKOLOnItemPropEditor );
    RegisterPropertyEditor( TypeInfo( TKOLAccelerator ), TKOLMenuItem, 'Accelerator',
                            TKOLAcceleratorPropEditor );
    RegisterNoIcon([TKOLAction]);
    RegisterClasses([TKOLAction]);
    RegisterComponentEditor( TKOLActionList, TKOLActionListEditor );
    RegisterPropertyEditor( TypeInfo( TKOLAccelerator ), TKOLAction, 'Accelerator',
                            TKOLAcceleratorPropEditor );
  end;

{$IFNDEF _D5orHigher} // code is grabbed here from SysUtils.pas of newer compiler
procedure FreeAndNil( var Obj ); // (since it is not existing for Delphi4 and older)
var
  Temp: TObject;
begin
  Temp := TObject(Obj);
  Pointer(Obj) := nil;
  Temp.Free;
end;
{$ENDIF}

const BoolVals: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );

function Remove_Result_dot( const s: String ): String;
begin
  Result := s;
  if Copy( LowerCase( s ), 1, 7 ) = 'result.' then
    Result := Copy( s, 8, Length( s ) - 7 );
end;

function IDI2Number( const IDIName: String ): Integer;
const
  IDINames: array[ 1..9 ] of String = (
    'IDI_APPLICATION', 'IDI_HAND', 'IDI_QUESTION', 'IDI_EXCLAMATION',
    'IDI_ASTERISK', 'IDI_WINLOGO', 'IDI_WARNING', 'IDI_ERROR',
    'IDI_INFORMATION' );
  IDIValues: array[ 1..9 ] of Integer = ( 32512, 32513, 32514, 32515,
    32516, 32517,
    32515, 32513, 32516 );
var i: Integer;
begin
  for i := 1 to High( IDINames ) do
    if UpperCase( IDIName ) = IDINames[ i ] then
    begin
      Result := IDIValues[ i ];
      Exit;
    end;
  Result := 0;
end;

function IDC2Number( const IDCName: String ): Integer;
const
  IDCNames: array[ 1..16 ] of String = (
    'IDC_ARROW', 'IDC_IBEAM', 'IDC_WAIT', 'IDC_CROSS', 'IDC_UPARROW', 'IDC_SIZE',
    'IDC_ICON', 'IDC_SIZENWSE', 'IDC_SIZENESW', 'IDC_SIZEWE', 'IDC_SIZENS',
    'IDC_SIZEALL', 'IDC_NO', 'IDC_HAND', 'IDC_APPSTARTING', 'IDC_HELP' );
  IDCValues: array[ 1..16 ] of Integer = ( 32512, 32513, 32514, 32515, 32516,
    32640, 32641, 32642, 32643, 32644, 32645, 32646, 32648, 32649, 32650, 32651 );
var i: Integer;
begin
  for i := 1 to High( IDCNames ) do
    if UpperCase( IDCName ) = IDCNames[ i ] then
    begin
      Result := IDCValues[ i ];
      Exit;
    end;
  Result := 0;
end;

{$STACKFRAMES ON}
function GetCallStack: TStringList;
var RegEBP: PDWORD;
    RetAddr, MinSearchAddr, SrchPtr: PChar;
    Found: Boolean;
begin
  Result := TStringList.Create;
  //Exit; // TODO: check Memory runaway
  asm
    MOV RegEBP, EBP
  end;
  while TRUE do
  begin
    Inc( RegEBP );
    try
      RetAddr := Pointer( RegEBP^ );
    except
      RetAddr := nil;
    end;
    if RetAddr = nil then Exit;

    MinSearchAddr := RetAddr - 4000;
    if Integer( MinSearchAddr ) > Integer( RetAddr ) then
      break;
    Found := FALSE;
    SrchPtr := RetAddr - Length( '#$signature$#' ) - 1;
    while SrchPtr >= MinSearchAddr do
    begin
      try
        if SrchPtr = '#$signature$#' then
        begin
          Found := TRUE;
          break;
        end;
      except
        SrchPtr := nil;
      end;
      if SrchPtr = nil then break;
      Dec( SrchPtr );
    end;
    if not Found then break;
    Inc( SrchPtr, Length( '#$signature$#' ) + 1 );
    Result.Add( String(SrchPtr) ); // TODO: cast
    Dec( RegEBP );
    try
      RegEBP := Pointer( RegEBP^ );
    except
      RegEBP := nil;
    end;
    if RegEBP = nil then break;
  end;
end;

function CmpInts( X, Y: Integer ): Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CmpInts', 0
  @@e_signature:
  end;
  if X < Y then
    Result := -1
  else
  if X > Y then
    Result := 1
  else
    Result := 0;
end;

function IsVCLControl( C: TComponent ): Boolean;
var temp: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'IsVCLControl', 0
  @@e_signature:
  end;
  //----------------------- old
  {Result := C is controls.TControl;
  if Result then
  if (C is TKOLApplet) or (C is TKOLCustomControl) or (C is TOleControl) then
    Result := FALSE;}
  //----------------------- new - by Alexander Rabotyagov
  Result := C is controls.TControl;
  if Result then
  if (C is TKOLApplet) or (C is TKOLCustomControl) or (C is TOleControl)
  then result:=false
  else begin
    result:=false;
    if c.tag<>cKolTag
    then begin
      {KOL.ShowQuestion - более удобно, поэтому так:}
      temp:=ShowQuestion('Form contain VCL control!!!'+#13+#10+
        'Name this VCL control is '+c.name+'.'+#13+#10+
        'You have choise:'+#13+#10+
        '1) replace this VCL control - click "Replace"'+#13+#10+
        '2) ignore this VCL control - click "Ignore"'+#13+#10+
        '   (it change tag property to '+IntToStr(cKolTag)+','+#13+#10+
        '   remove it to Private'+#13+#10+
        '   and change source code to:'+#13+#10+
        '   {$IFNDEF KOL_MCK}'+c.Name+': '+c.ClassName+';{$ENDIF} {<-- It is a VCL control}'+#13+#10+
        '3) lock Your project - click "Lock"'
        ,'Replace/Ignore/Lock');
      try
        if temp=1 then c.free;
        if temp=2 then c.tag:=cKolTag;
        if temp=3 then result:=true;
      except
        Showmessage('Sorry, but can not do it! Your project will be locked!');
        result:=true;
      end;
    end;
  end;
end;

{$IFDEF MCKLOG}
var EnterLevel: array[ 0..7 ] of Integer;
    LevelOKStack: array[ 0..7, -1000..+1000 ] of Boolean;
    Threads: array[ 0..7 ] of DWORD;
function GetThreadIndex: Integer;
var i: Integer;
    CTI: DWORD;
begin
  CTI := GetCurrentThreadId;
  for i := 0 to 6 do
  begin
    if Threads[ i ] = CTI then
    begin
      Result := i;
      Exit;
    end;
  end;
  for i := 0 to 6 do
  begin
    if Threads[ i ] = 0 then
    begin
      Threads[ i ] := CTI;
      Result := i;
      Exit;
    end;
  end;
  Result := 7;
end;
{$ENDIF MCKLOG}

{$IFDEF MCKLOGBUFFERED}
var LogBuffer: TStringList;
{$ENDIF}

procedure Log( const S: String );
{$IFDEF MCKLOG}
var S1: String;
    L: Integer;
{$ENDIF}
begin
  {$IFDEF MCKLOG}
  L := EnterLevel[ GetThreadIndex ];
  if Copy( S, 1, 2 ) = '->' then
  begin
    Inc( EnterLevel[ GetThreadIndex ] );
    if (EnterLevel[ GetThreadIndex ] >= -1000) and (EnterLevel[ GetThreadIndex ] <= 1000) then
      LevelOKStack[ GetThreadIndex, EnterLevel[ GetThreadIndex ] ] := FALSE;
  end
  else
  if Copy( S, 1, 2 ) = '<-' then
  begin
    dec( L );
    if (EnterLevel[ GetThreadIndex ] >= -1000) and (EnterLevel[ GetThreadIndex ] <= 1000) then
      if not LevelOKStack[ GetThreadIndex, EnterLevel[ GetThreadIndex ] ] then
        LogFileOutput( 'C:\MCK.log', DateTime2StrShort( Now ) +
                       ' <' + IntToStr( GetCurrentThreadId ) + '> ' +
                       IntToStr( EnterLevel[ GetThreadIndex ] ) + ' *** Leave not OK *** ' + S );
    Dec( EnterLevel[ GetThreadIndex ] );
  end;
  {$IFDEF MCKLOGwoRPT}
  if Copy( S, 1, 4 ) = 'Rpt:' then
    Exit;
  {$ENDIF MCKLOGwoRPT}
  {$IFDEF MCKLOGwoTKOLProject}
  if StrEq( Copy( S, 3, 11 ), 'TKOLProject' ) then
    Exit;
  {$ENDIF MCKLOGwoTKOLProject}

  S1 := DateTime2StrShort( Now ) +
       ' <' + IntToStr( GetCurrentThreadId ) + '> '
       + IntToStr( EnterLevel[ GetThreadIndex ] ) + ' '
       + StrRepeat( '  ', L ) + S;
  {$IFDEF MCKLOGBUFFERED}
  if LogBuffer = nil then
    LogBuffer := TStringList.Create;
  LogBuffer.Add( S1 );
  if LogBuffer.Count >= 100 then
  begin
    LogFileOutput( 'C:\MCK.log', TrimRight(LogBuffer.Text) );
    LogBuffer.Clear;
  end;
  {$ELSE}
  LogFileOutput( 'C:\MCK.log', S1 );
  {$ENDIF}
  {$ELSE}
  Sleep( 0 );
  {$ENDIF MCKLOG}
end;

procedure LogOK ;
begin
  {$IFDEF MCKLOG}
    if (EnterLevel[ GetThreadIndex ] >= -1000) and (EnterLevel[ GetThreadIndex ] <= 1000) then
      LevelOKStack[ GetThreadIndex, EnterLevel[ GetThreadIndex ] ] := TRUE;
  {$ENDIF}
end;

procedure Rpt( const S: String; Color: Integer );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Rpt', 0
  @@e_signature:
  end;
  Log( 'Rpt: ' + S );
  if KOLProject <> nil then
    KOLProject.Report( S, Color );
end;

procedure RptDetailed( const S: String; Color: Integer );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'RptDetailed', 0
  @@e_signature:
  end;
  Log( 'Rpt: ' + S );
  if (KOLProject <> nil) and KOLProject.ReportDetailed then
    KOLProject.Report( S, Color );
end;

procedure Rpt_Stack;
var StrList: TStringList;
    I: Integer;
begin
  Rpt( 'Stack:', LIGHT + BLUE );
  TRY
  StrList := GetCallStack;
    TRY
      for I := 0 to StrList.Count-1 do
        Rpt( StrList[ I ], LIGHT + BLUE );
    FINALLY
  StrList.Free;
end;
  EXCEPT
    RptDetailed( 'Exception while Rpt_Stack', YELLOW );
  END;
end;

function ProjectSourcePath: String;
{$IFDEF _D2005orHigher}
var
  IProjectGroup: IOTAProjectGroup;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ProjectSourcePath', 0
  @@e_signature:
  end;
  Result := '';
  if KOLProject <> nil then
    Result := KOLProject.SourcePath
  else
  begin
    if ToolServices <> nil then
      Result := ExtractFilePath( ToolServices.GetProjectName )
    {$IFDEF _D2005orHigher}
    else
    begin
      IProjectGroup := Get_ProjectGroup();
      if Assigned(IProjectGroup) then
      begin
        // if IProjectGroup.ActiveProject.ProjectType = 'Library'
        Result := ExtractFilePath( IProjectGroup.ActiveProject.ProjectOptions.TargetName );
      end;
    end;
    {$ENDIF}
  end;

end;

function Get_ProjectName: String;
{$IFDEF _D2005orHigher}
var
  IProjectGroup: IOTAProjectGroup;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Get_ProjectName', 0
  @@e_signature:
  end;
  Result := '';
  if KOLProject <> nil then
    Result := KOLProject.ProjectName
  else
    if ToolServices <> nil then
      Result := ExtractFileNameWOExt( ToolServices.GetProjectName )
    {$IFDEF _D2005orHigher}
    else
    begin
      IProjectGroup := Get_ProjectGroup;
      if Assigned(IProjectGroup) then
        Result := ExtractFileNameWOExt( IProjectGroup.ActiveProject.ProjectOptions.TargetName ); // instead ActiveProject.GetFilename
    end;
    {$ENDIF}
end;

function ReadTextFromIDE( Reader: TIEditReader ): PChar;
var Buf: PChar; // ANSI_CTRLS?
    Len, Pos: Integer;
    MS: TMemoryStream;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ReadTextFromIDE', 0
  @@e_signature:
  end;
  Result := nil;
  GetMem( Buf, 10000 );
  MS := TMemoryStream.Create;
  Pos := 0;
  try

    Len := Reader.GetText( 0, Buf, 10000 );
    while Len > 0 do
    begin
      MS.Write( Buf[ 0 ], Len );
      Pos := Pos + Len;
      Len := Reader.GetText( Pos, Buf, 10000 );
    end;

    if MS.Size > 0 then
    begin
      GetMem( Result, MS.Size + 1 );
      Move( MS.Memory^, Result^, MS.Size );
      Result[ MS.Size ] := #0;
    end;

    //Rpt( IntToStr( MS.Size ) + ' bytes are read from IDE' );

  except
    on E: Exception do
    begin
      ShowMessage( 'Cannot read text from IDE, exception: ' + E.Message );
    end;
  end;
  FreeMem( Buf );
  MS.Free;
end;

{$IFNDEF VER90}
{$IFNDEF VER100}
function ReadTextFromIDE_0( Reader: IOTAEditReader ): PChar;
var Buf: PAnsiChar;
    Len, Pos: Integer;
    MS: TMemoryStream;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ReadTextFromIDE_0', 0
  @@e_signature:
  end;
  Result := nil;
  GetMem( Buf, 10000 );
  MS := TMemoryStream.Create;
  Pos := 0;
  try

    Len := Reader.GetText( 0, Buf, 10000 );
    while Len > 0 do
    begin
      MS.Write( Buf[ 0 ], Len );
      Pos := Pos + Len;
      Len := Reader.GetText( Pos, Buf, 10000 );
    end;

    if MS.Size > 0 then
    begin
      GetMem( Result, MS.Size + 1 );
      Move( MS.Memory^, Result^, MS.Size );
      Result[ MS.Size ] := #0;
    end;

    //Rpt( IntToStr( MS.Size ) + ' bytes are read from IDE' );

  except
    on E: Exception do
    begin
      ShowMessage( 'Cannot read text from IDE, exception(0): ' + E.Message );
    end;
  end;
  FreeMem( Buf );
  MS.Free;
end;
{$ENDIF}
{$ENDIF}

procedure LoadSource( SL: TStrings; const Path: String );
var N, I: Integer;
    S: String;
    Loaded: Boolean;
    Module: TIModuleInterface;
    Editor: TIEditorInterface;
    Reader: TIEditReader;
    Buffer: PChar;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    MS: IOTAModuleServices;
    M: IOTAModule;
    E: IOTAEditor;
    SE: IOTASourceEditor;
    ER: IOTAEditReader;
    {$ENDIF}
    {$ENDIF}

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'LoadSource', 0
  @@e_signature:
  end;
  Loaded := False;
  SL.Clear;
  if ToolServices <> nil then
  try
    //Rpt( 'trying to load from IDE Editor: ' + Path );

    N := ToolServices.GetUnitCount;
    for I := 0 to N - 1 do
    begin
      S := ToolServices.GetUnitName( I );
      if AnsiLowerCase( S ) = AnsiLowerCase( Path ) then
      begin
        // unit is loaded into IDE editor - make an attempt to get it from there
        Module := ToolServices.GetModuleInterface( S );
        if Module <> nil then
        try
          Editor := Module.GetEditorInterface;
          if Editor <> nil then
          try
            Reader := Editor.CreateReader;
            Buffer := nil;
            if Reader <> nil then
            try
              //Rpt( 'Loading source from IDE Editor: ' + Path );
              Buffer := ReadTextFromIDE( Reader );
              if Buffer <> nil then
              begin
                SL.Text := String(Buffer); // TODO: KOL_ANSI
                Loaded := True;
                //Rpt( 'Loaded: ' + Path );
              end;
            finally
              Reader.Free;
              if Buffer <> nil then
                FreeMem( Buffer );
            end;
          finally
            Editor.Free;
          end;
        finally
          Module.Free;
        end;
        break;
      end;
    end;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    if not Loaded and (BorlandIDEServices <> nil) then
    begin
      if BorlandIDEServices.QueryInterface( IOTAModuleServices, MS ) = 0 then
      begin
        M := MS.FindModule( Path );
        if M <> nil then
        begin
          N := M.GetModuleFileCount;
          for I := 0 to N-1 do
          begin
            E := M.GetModuleFileEditor( I );
            if E.QueryInterface( IOTASourceEditor, SE ) = 0 then
            begin
              ER := SE.CreateReader;
              if ER <> nil then
              begin
                Buffer := ReadTextFromIDE_0( ER );
                if Buffer <> nil then
                begin
                  SL.Text := String(Buffer); // TODO: KOL_ANSI
                  Loaded := True;
                  //Rpt( 'Loaded_0: ' + Path );
                end;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
    {$ENDIF}
    {$ENDIF}

  except
    on E: Exception do
    begin
      ShowMessage( 'Can not load source of ' + Path + ', exception: ' + E.Message );
    end;
  end;

  if not Loaded then
    if FileExists( Path ) then
      SL.LoadFromFile( Path );

end;

function UpdateSource( SL: TStrings; const Path: String ): Boolean;
var N, I: Integer;
    S: String;
    Module: TIModuleInterface;
    Editor: TIEditorInterface;
    Writer: TIEditWriter;
    Buffer: String;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    MS: IOTAModuleServices;
    M: IOTAModule;
    E: IOTAEditor;
    SE: IOTASourceEditor;
    {$IFNDEF VER120}
    EB: IOTAEditBuffer;
    RO: Boolean;
    {$ENDIF}
    EW: IOTAEditWriter;
    {$ENDIF}
    {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'UpdateSource', 0
  @@e_signature:
  end;
  Rpt( 'Updating source for ' + Path, WHITE );
  //Rpt_Stack;
  Result := False;
  if ToolServices <> nil then
  try
    //Rpt( 'trying to save to IDE Editor: ' + Path );

    N := ToolServices.GetUnitCount;
    for I := 0 to N - 1 do
    begin
      S := ToolServices.GetUnitName( I );
      if AnsiLowerCase( S ) = AnsiLowerCase( Path ) then
      begin
        //Rpt( 'Updating in IDE: ' + Path );
        // unit is loaded into IDE editor - make an attempt to update it from there
        Module := ToolServices.GetModuleInterface( S );
        if Module <> nil then
        try
          Editor := Module.GetEditorInterface;
          if Editor <> nil then
          try
            Writer := Editor.CreateWriter;
            Buffer := SL.Text;
            if Writer <> nil then
            try
              //Rpt( 'Updating source in IDE Editor: ' + Path );
              if Writer.DeleteTo( $3FFFFFFF ) and Writer.Insert( PChar( Buffer ) ) then
                Result := True;
              //else Rpt( 'Can not update ' + S );
            finally
              Writer.Free;
            end;
          finally
            Editor.Free;
          end;
        finally
          Module.Free;
        end;
        break;
      end;
    end;

    {$IFNDEF VER90}
    {$IFNDEF VER100}
    if not Result and (BorlandIDEServices <> nil) then
    begin
      if BorlandIDEServices.QueryInterface( IOTAModuleServices, MS ) = 0 then
      begin
        M := MS.FindModule( Path );
        if M <> nil then
        begin
          N := M.GetModuleFileCount;
          for I := 0 to N-1 do
          begin
            E := M.GetModuleFileEditor( I );
            if E.QueryInterface( IOTASourceEditor, SE ) = 0 then
            begin
              {$IFNDEF VER120}
              if E.QueryInterface( IOTAEditBuffer, EB ) = 0 then
              begin
                RO := EB.IsReadOnly;
                if RO then
                  EB.IsReadOnly := FALSE;
              end;
              {$ENDIF}
              EW := SE.CreateWriter;
              if EW <> nil then
              begin
                Buffer := SL.Text;
                EW.DeleteTo( $3FFFFFFF );
                EW.Insert( PAnsiChar( AnsiString(Buffer) ) ); // TODO: dangerous
                Result := True;
                break;
              end;
            end;
          end;
        end;
      end;
    end;
    {$ENDIF}
    {$ENDIF}

  except
    on E: Exception do
    begin
      ShowMessage( 'Can not update source, exception: ' + E.Message );
    end;
  end;

end;

//var SameCmpCount: Integer;
procedure SaveStrings( SL: TStrings; const Path: String; var Updated: Boolean );
var S1, s: String;
    Old: TStringList;
    I: Integer;
    TheSame: Boolean;
    OldCount, NewCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SaveStrings', 0
  @@e_signature:
  end;
  //Rpt( 'SaveStrings: ' + Path );
  SL.Text := SL.Text;
  Old := TStringList.Create;
  LoadSource( Old, Path );

  TheSame := FALSE;
  if Old.Count > 0 then
  begin
    NewCount := SL.Count;
    while (NewCount > 1) and (Trim(SL[ NewCount - 1]) = '') do
      Dec( NewCount );
    I := 0;
    while I < Old.Count do
    begin
      s := Old[ I ];
      if StrIsStartingFrom( PChar( s ), ' PROC(2) //--by PCompiler:line#' ) then // TODO: dangerous
        Old[ I ] := ' PROC(2)'
      else
      if AnsiCompareText( s, '{$ENDIF Psource}' ) = 0 then
      begin
        Inc( I );
        while I < Old.Count do
        begin
          s := Old[ I ];
          if AnsiCompareText( s, '{$ELSE OldCode}' ) = 0 then break;
          Old.Delete( I );
        end;
      end;
      inc( I );
    end;
    OldCount := Old.Count;
    while (OldCount > 1) and (Trim(Old[ OldCount - 1 ]) = '') do
      Dec( OldCount );
    TheSame := OldCount = NewCount;
    if TheSame then
    for I := 0 to OldCount - 1 do
      if Old[ I ] <> SL[ I ] then
      begin
        TheSame := False;
        break;
      end;
    {if not TheSame then
    begin
      Inc( SameCmpCount );
      Old.SaveToFile( Path + '_' + IntToStr( SameCmpCount ) + '.1' );
      SL.SaveToFile( Path +  '_' + IntToStr( SameCmpCount ) + '.2' );
      Rpt( 'SaveStrings: '
           + ' oldC=' + IntToStr( Old.Count ) + ':' + IntToStr( OldCount )
           + ' newC=' + IntToStr( SL.Count ) + ':' + IntToStr( NewCount )
           + ' (' + Path + '):' + IntToStr( SameCmpCount )
           , CYAN ); //Rpt_Stack;
    end;}
    Old.Free;
  end;
  if not TheSame then
  begin
    Rpt( 'SaveStrings: found that strings are different', LIGHT + BLUE ); //Rpt_Stack;

    if UpdateSource( SL, Path ) then
    begin
      //Rpt( 'updated (in IDE Editor): ' + Path );
      if FileExists( Path ) then
        SetFileAttributes( PChar( Path ), FILE_ATTRIBUTE_NORMAL );
      Updated := TRUE;
      Exit;
    end;

    //Rpt( 'writing to ' + Path );
    S1 := Copy( Path, 1, Length( Path ) - 3 ) + '$$$';
    if FileExists( S1 ) then
      DeleteFile( S1 );
    SetFileAttributes( PChar( Path ), FILE_ATTRIBUTE_NORMAL );
    MoveFile( PChar( Path ), PChar( S1 ) );
    if KOLProject <> nil then
    begin
      S1 := KOLProject.OutdcuPath + ExtractFileName( Path );
      if LowerCase( Copy( S1, Length( S1 ) - 3, 4 ) ) = '.inc' then
        S1 := Copy( S1, 1, Length( S1 ) - 6 ) + '.dcu'
      else
        S1 := Copy( S1, 1, Length( S1 ) - 3 ) + 'dcu';
      if FileExists( S1 ) then
      begin
        //Rpt( 'Remove: ' + S1 );
        DeleteFile( S1 );
      end;
    end;
    SL.SaveToFile( Path );
    Updated := TRUE;
    {if Protect then
      SetFileAttributes( PAnsiChar( Path ), FILE_ATTRIBUTE_READONLY );}
  end
     else
  begin
    //Rpt( 'file ' + Path + ' is the same.' );
    Exit;
  end;
end;

procedure SaveStringToFile(const Path, Str: String );
var SL: TStringList;
begin
  SL := TStringList.Create;
  TRY
  SL.Text := Str;
  SL.SaveToFile( Path );
  FINALLY
  SL.Free;
  END;
end;

procedure MarkModified( const Path: String );
{$IFNDEF VER90}
{$IFNDEF VER100}
var MS: IOTAModuleServices;
    M: IOTAModule;
    E: IOTAEditor;
    I, N: Integer;
{$ENDIF}
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'MarkModified', 0
  @@e_signature:
  end;
  Rpt( 'MarkModified: ' + Path, WHITE ); //Rpt_Stack;
{$IFNDEF VER90}
{$IFNDEF VER100}
  if (BorlandIDEServices <> nil) and
     (BorlandIDEServices.QueryInterface( IOTAModuleServices, MS ) = 0) then
  begin
    M := MS.FindModule( Path );
    if M <> nil then
    begin
      N := M.GetModuleFileCount;
      for I := 0 to N-1 do
      begin
        E := M.GetModuleFileEditor( I );
        if E <> nil then
        begin
          E.MarkModified;
          break;
        end;
      end;
    end;
  end;
{$ENDIF}
{$ENDIF}
end;

procedure UpdateUnit( const Path: String );
var MI: TIModuleInterface;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'UpdateUnit', 0
  @@e_signature:
  end;
  if ToolServices = nil then Exit;
  MI := ToolServices.GetModuleInterface( Path );
  if MI <> nil then
  TRY
    Rpt( 'Update Unit: ' + Path, WHITE ); //Rpt_Stack;
    MI.Save( TRUE );
  FINALLY
    MI.Free;
  END;
end;

procedure AddLongTextField( var SL: TStringList; const Prefix:String;
 const Text:TDelphiString; const Suffix:String; const LinePrefix: String );
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
  j : integer;
{$ENDIF}

    i,k,n:Integer;
const LIMIT = 80;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'AddLongTextField', 0
  @@e_signature:
  end;
     if ( Length( Text ) > LIMIT ) then
     begin
          SL.Add( Prefix + '''''' );

          k := Length( Text );
          i := 0;
          while ( i <> k ) do
          begin
               inc(i);
               n := ( i mod LIMIT );
               if ( ( n = LIMIT - 1 ) or ( i = k ) ) then
               begin
                 if pos( '+', LinePrefix ) > 0 then
                  begin
                   {$IFDEF _D2009orHigher}
                    C := Text;
                    C2 := '';
                    for j := i + 1 - n to i + 1 do C2 := C2 + '#'+int2str(ord(C[j]));
                    SL.Add( LinePrefix + C2);
                   {$ELSE}
                    SL.Add( LinePrefix + String2Pascal(
                      Copy( Text, i + 1 - n, n + 1 ), '+' ) );
                   {$ENDIF}
                  end
                 else
                  begin
                   {$IFDEF _D2009orHigher}
                    Msgok('');
                    C := Text;
                    C2 := '';
                    for j := i + 1 - n to i + 1 do C2 := C2 + '#'+int2str(ord(C[j]));
                    SL.Add( LinePrefix + C2 );
                   {$ELSE}
                    SL.Add( LinePrefix + String2Pascal(
                      Copy( Text, i + 1 - n, n + 1 ), ',' ) )
                   {$ENDIF}
                  end;
               end;
          end;

          SL.Add( Suffix );
     end
     else
     begin
       if pos( '+', LinePrefix ) > 0 then
        begin
         {$IFDEF _D2009orHigher}
          C := Text;
          C2 := '';
          for j := 1 to Length(C) do C2 := C2 + '#'+int2str(ord(C[j]));
          SL.Add( Prefix + C2 + Suffix )
         {$ELSE}
          SL.Add( Prefix + String2Pascal(Text, '+') + Suffix )
         {$ENDIF}
        end
       else
        begin
         {$IFDEF _D2009orHigher}
          C := Text;
          C2 := '';
          for j := 1 to Length(C) do C2 := C2 + '#'+int2str(ord(C[j]));
          SL.Add( Prefix + C2 + Suffix )
         {$ELSE}
          SL.Add( Prefix + String2Pascal(Text, ',') + Suffix )
         {$ENDIF}
        end;
     end;
end;

{procedure OutSortedListOfComponents(  const path: String; L: TList; ii: Integer );
var SL: TStringList;
    i, n: Integer;
    C: TComponent;
begin
  if L.Count = 0 then Exit;
  SL := TStringList.Create;
  TRY
    if FileExists( 'c:\nnn.txt' ) then
      SL.LoadFromFile( 'c:\nnn.txt' );
    if SL.Count > 0 then
      n := Str2Int( SL[ 0 ] )
    else
      n := 0;
    inc( n );
    SL.Clear;
    SL.Add( IntToStr( n ) );
    SL.SaveToFile( 'c:\nnn.txt' );
    SL.Clear;
    for i := 0 to L.Count-1 do
    begin
      C := L[ i ];
      SL.Add( C.Name );
    end;
    SL.SaveToFile( path + Format( '_%.05d', [ n ] ) + '-' + IntToStr( ii ) + '.txt' );
  FINALLY
    SL.Free;
  END;
end;}




{YS}//--------------------------------------------------------------

{$IFNDEF NOT_USE_KOLCTRLWRAPPER}
function InterceptWndProc( W: HWnd; Msg: Cardinal; wParam, lParam: Integer ): Integer; stdcall;
var
  KOLParentCtrl: PControl;
  _Msg: TMsg;
  OldWndProc: pointer;

begin
  KOLParentCtrl:=PControl(GetProp(W, 'KOLParentCtrl'));
  OldWndProc:=pointer(GetProp(W, 'OldWndProc'));

  if Assigned(KOLParentCtrl) and KOLParentCtrl.HandleAllocated then
      if (Msg in [WM_DRAWITEM, WM_NOTIFY, WM_SIZE, WM_MEASUREITEM]) then begin
        _Msg.hwnd:=KOLParentCtrl.Handle;
        _Msg.message:=Msg;
        _Msg.wParam:=WParam;
        _Msg.lParam:=LParam;
        KOLParentCtrl.WndProc(_Msg);
      end;

  Result:=CallWindowProc(OldWndProc, W, Msg, wParam, lParam);
end;

function EnumChildProc(wnd: HWND; lParam: integer): BOOL; stdcall;
begin
  ShowWindow(wnd, lParam);
  Result:=True;
end;

{ TKOLVCLParent }

function NewKOLVCLParent: PKOLVCLParent;
begin
  Log( '->NewKOLVCLParent' );
  TRY
    New( Result, CreateParented( nil ) );
    Result.fControlClassName := 'KOLVCLParent';
    Result.Visible:=False;
    LogOK;
  FINALLY
    Log( '<-NewKOLVCLParent' );
  END;
end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}

procedure TKOLVCLParent.AttachHandle(AHandle: HWND);
begin
  fHandle:=AHandle;
end;

procedure TKOLVCLParent.AssignDynHandlers(Src: PKOLVCLParent);
var i: integer;
begin
  i:=0;
  while i < Src.fDynHandlers.Count do
  begin
    if fDynHandlers = nil then
      fDynHandlers := NewList
    else
      fDynHandlers.Clear;
    begin
      //AttachProcEx(Src.fDynHandlers.Items[i], boolean(Src.fDynHandlers.Items[i + 1]));
      //Inc(i, 2);
      fDynHandlers.Add( Src.fDynHandlers.Items[ i ] );
      inc( i );
    end;
  end;
end;

{$IFNDEF NOT_USE_KOLCTRLWRAPPER}
{ TKOLCtrlWrapper }

constructor TKOLCtrlWrapper.Create(AOwner: TComponent);
begin
  Log( '->TKOLCtrlWrapper.Create' );
  TRY
    Log( '//// inherited starting' );
    inherited;
    Log( '//// inherited called' );
    FAllowSelfPaint:=True;
  {$IFDEF _KOLCtrlWrapper_}
    CreateKOLControl(False);
  {$ENDIF}
    LogOK;
  FINALLY
    Log( '<-TKOLCtrlWrapper.Create' );
  END;
end;

destructor TKOLCtrlWrapper.Destroy;
var FRP: Boolean;
    FKPC: PKOLVCLParent;
begin
  if Assigned(FKOLCtrl) then begin
    Parent:=nil;
    if Assigned(FKOLCtrl) and (FKOLCtrl.Parent <> nil) and not FRealParent then begin
      FKOLParentCtrl.RefDec;
      RemoveParentAttach;
    end;
  end;
  FRP := FRealParent;
  FKPC := FKOLParentCtrl;
  inherited;
  if not FRP and Assigned(FKPC) and (FKPC.RefCount = 0) then
    FKOLParentCtrl.Free;
end;

procedure TKOLCtrlWrapper.RemoveParentAttach;
var
  wp: integer;
begin
  if not FRealParent and (FKOLParentCtrl.RefCount <= 1) and FKOLParentCtrl.HandleAllocated then begin
    wp:=GetProp(FKOLParentCtrl.Handle, 'OldWndProc');
    if wp <> 0 then
      SetWindowLong(FKOLParentCtrl.Handle, GWL_WNDPROC, wp);
    RemoveProp(FKOLParentCtrl.Handle, 'KOLParentCtrl');
    RemoveProp(FKOLParentCtrl.Handle, 'OldWndProc');
    FKOLParentCtrl.AttachHandle(0);
  end;
end;

procedure TKOLCtrlWrapper.SetParent(Value: TWinControl);
var
  KP: PKOLVCLParent;

  procedure AssignNewParent;
  begin
    KP.AssignDynHandlers(FKOLParentCtrl);
    FKOLCtrl.Parent:=KP;
    Windows.SetParent(FKOLCtrl.Handle, Value.Handle);
    if not FRealParent then
      FKOLParentCtrl.Free;
    FKOLParentCtrl:=KP;
  end;

var
  F: TCustomForm;

begin
  Log( '->TKOLCtrlWrapper.SetParent Self:' + Int2Hex( DWORD( Self ), 6 ) );
  TRY

  Log( 'A' );
  if Assigned(FKOLCtrl) and (Parent <> Value) then
  begin
    Log( 'B' );
    if Assigned(Parent) then begin
      FKOLCtrl.Parent:=nil;
      if not FRealParent then begin
        FKOLParentCtrl.RefDec;
        RemoveParentAttach;
      end;
    end;
    Log( 'C' );
    if Assigned(Value) then
    begin
      Log( 'D' );
      if (Value is TKOLCtrlWrapper) and Assigned(TKOLCtrlWrapper(Value).FKOLCtrl) then
        KP:=PKOLVCLParent(TKOLCtrlWrapper(Value).FKOLCtrl)
      else
        KP:=PKOLVCLParent(GetProp(Value.Handle, 'KOLParentCtrl'));
      if Assigned(KP) then begin
        AssignNewParent;
        FRealParent:=(Value is TKOLCtrlWrapper) and Assigned(TKOLCtrlWrapper(Value).FKOLCtrl);
      end
      else
      begin
        Log( 'E' );
        FRealParent:=False;
        if FKOLParentCtrl.HandleAllocated then
        begin
          KP:=NewKOLVCLParent;
          AssignNewParent;
        end;
        Log( 'F' );
        FKOLParentCtrl.AttachHandle(Value.Handle);
        SetProp(Value.Handle, 'KOLParentCtrl', integer(FKOLParentCtrl));
        SetProp(Value.Handle, 'OldWndProc', GetWindowLong(Value.Handle, GWL_WNDPROC));
        SetWindowLong(Value.Handle, GWL_WNDPROC, integer(@InterceptWndProc));
      end;
      Log( 'G' );
      if not FRealParent then
        FKOLParentCtrl.RefInc;
      FKOLCtrl.Style:=FKOLCtrl.Style or WS_CLIPSIBLINGS;
    end;
    Log( 'H' );
  end;
  Log( 'I' );
  inherited;
  Log( 'J' );
  if Assigned(FKOLCtrl) and Assigned(Value) and not(csLoading in ComponentState) then
  begin
    Log( 'K' );
    HandleNeeded;
    Log( 'L' );
    F:=GetParentForm(Self);
    Log( 'M' );
    if Assigned(F) then
      Windows.SetFocus(F.Handle);
    Log( 'N' );
    UpdateAllowSelfPaint;
  end;
  Log( 'O' );
  LogOK;
  FINALLY
  Log( '<-TKOLCtrlWrapper.SetParent' );
  END;
end;

procedure TKOLCtrlWrapper.WndProc(var Message: TMessage);
var
  DeniedMessage: boolean;
  DC: HDC;
  PS: TPaintStruct;
begin
  Log( '->TKOLCtrlWrapper.WndProc: ' + Int2Hex( Message.Msg, 2 ) + '(' +
    Int2Str( Message.Msg ) + ')' );
  TRY

    if Assigned(FKOLCtrl) then
    begin
      DeniedMessage:=(((Message.Msg >= WM_MOUSEFIRST) and (Message.Msg <= WM_MOUSELAST)) or
         ((Message.Msg >= WM_KEYFIRST) and (Message.Msg <= WM_KEYLAST)) or
         (Message.Msg in [WM_NCHITTEST, WM_SETCURSOR]) or
         (Message.Msg = CM_DESIGNHITTEST)
         {$IFDEF _D3orHigher} or (Message.Msg = CM_RECREATEWND) {$ENDIF}
         );

      if not FAllowSelfPaint and (Message.Msg in [WM_NCCALCSIZE, WM_ERASEBKGND]) then
      begin
        LogOK; exit;
      end;

      if FAllowSelfPaint or (Message.Msg <> WM_PAINT) then
        if not DeniedMessage then
        CallKOLCtrlWndProc(Message);

      if (FKOLCtrl.Parent = nil) and (Message.Msg = WM_NCDESTROY) then begin
        FKOLCtrl:=nil;
        if not FRealParent and Assigned(FKOLParentCtrl) and (FKOLParentCtrl.RefCount = 0) then begin
          FKOLParentCtrl.Free;
          FKOLParentCtrl:=nil;
        end;
        LogOK;
        exit;
      end;

      if not (DeniedMessage or
              (Message.Msg in [WM_PAINT, WM_SIZE, WM_MOVE, WM_WINDOWPOSCHANGED, WM_WINDOWPOSCHANGING, WM_DESTROY]))
      then
      begin
        LogOK; exit;
      end;

      if (Message.Msg = WM_PAINT) then begin
        if FAllowSelfPaint then
          DC:=GetDC(WindowHandle)
        else
          DC:=BeginPaint(WindowHandle, PS);
        try
          Message.WParam:=DC;
          inherited;
        finally
          if FAllowSelfPaint then
            ReleaseDC( WindowHandle, DC )
          else
            EndPaint(WindowHandle, PS);
        end;
        LogOK; exit;
      end;

    end;
    inherited;
    if {$IFDEF _D3orHigher} (Message.Msg = CM_RECREATEWND) and {$ENDIF}
       FKOLCtrlNeeded then
      HandleNeeded;
    LogOK;
  FINALLY
    Log( '<-TKOLCtrlWrapper.WndProc: ' + Int2Hex( Message.Msg, 2 ) + '(' +
      Int2Str( Message.Msg ) + ')' );
  END;
end;

procedure TKOLCtrlWrapper.SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
var R: TRect;
begin
  Log( '->TKOLCtrlWrapper.SetBounds' );
  try
    TRY
    //Log( 'TKOLCtrlWrapper.SetBounds-1' );
    //if not( csLoading in ComponentState ) then
    begin
      //Log( 'TKOLCtrlWrapper.SetBounds-1A - very often crashed here on loading project' );
      //Rpt_Stack;
      inherited SetBounds( ALeft, ATop, AWidth, AHeight );
      //Log( 'TKOLCtrlWrapper.SetBounds-1B' );
      R := BoundsRect;
      //Log( 'TKOLCtrlWrapper.SetBounds-1C' );
    end
      {else
    begin
      //Log( 'TKOLCtrlWrapper.SetBounds-1D' );
      R := Rect( ALeft, ATop, ALeft+AWidth, ATop+AHeight  );
      //Log( 'TKOLCtrlWrapper.SetBounds-1E' );
    end};
    //Log( 'TKOLCtrlWrapper.SetBounds-2' );
    if Assigned(FKOLCtrl) then
    begin
      //Log( 'TKOLCtrlWrapper.SetBounds-3' );
      if FKOLCtrl <> nil then
      begin
        //Log( 'TKOLCtrlWrapper.SetBounds-3A' );
        //Log( 'FKOLCtrl.Handle = ' + IntToStr( FKOLCtrl.Handle ) );
        //Log( 'FKOLCtrl.Parent = ' + IntToStr( DWORD( FKOLCtrl.Parent ) ) );
        FKOLCtrl.BoundsRect := R;
        //Log( 'TKOLCtrlWrapper.SetBounds-3B' );
      end;
      //Log( 'TKOLCtrlWrapper.SetBounds-4' );
      if not FAllowSelfPaint and HandleAllocated then
      begin
        //Log( 'TKOLCtrlWrapper.SetBounds-5' );
        UpdateAllowSelfPaint;
        //Log( 'TKOLCtrlWrapper.SetBounds-6' );
      end;
      //Log( 'TKOLCtrlWrapper.SetBounds-7' );
    end;
    EXCEPT
      on E: EXception do
        Rpt( 'Exception in TKOLCtrlWrapper.SetBounds: ' + E.Message, RED );
    END;
  LogOK;
  finally
  Log( '<-TKOLCtrlWrapper.SetBounds' );
  end;
end;

procedure TKOLCtrlWrapper.CreateWnd;
begin
  Log( '->TKOLCtrlWrapper.CreateWnd(' + Name + ')' );
  TRY

  if not Assigned(FKOLCtrl) and FKOLCtrlNeeded then
  begin
    CreateKOLControl(True);
    if Assigned(FKOLCtrl) then
      FKOLCtrl.BoundsRect:=BoundsRect;
  end;
  if Assigned(FKOLCtrl) then begin
    WindowHandle:=FKOLCtrl.GetWindowHandle;
    CreationControl:=Self;
    InitWndProc(WindowHandle, 0, 0, 0);
    if FKOLCtrlNeeded then
      KOLControlRecreated;
    FKOLCtrlNeeded:=False;
    UpdateAllowSelfPaint;
    FKOLCtrl.Visible:=True;
  end
  else
    inherited;

  LogOK;
  FINALLY
  Log( '<-TKOLCtrlWrapper.CreateWnd(' + Name + ')' );
  END;
end;

procedure TKOLCtrlWrapper.DestroyWindowHandle;
var
  i: integer;
begin
  Log( '->TKOLCtrlWrapper.DestroyWindowHandle(' + Name + ')' );
  TRY
  Log( 'A' );
  if Assigned(FKOLCtrl) then
  begin
    Log( 'B' );
    while FKOLCtrl.ChildCount > 0 do
      FKOLCtrl.Children[0].Parent:=nil;
    Log( 'C' );
    WindowHandle:=0;
    {$IFDEF _D4orHigher}
    ControlState:=ControlState + [csDestroyingHandle];
    {$ENDIF}
    Log( 'D' );
    try
      FKOLCtrl.Free;
    finally
      {$IFDEF _D4orHigher}
      ControlState:=ControlState - [csDestroyingHandle];
      {$ENDIF}
    end;
    Log( 'E' );
    FKOLCtrl:=nil;
    if not (csDestroying in ComponentState) then
    begin
      Log( 'F' );
      for i:=0 to ControlCount - 1 do
        if Controls[i] is TKOLCtrlWrapper then
          with TKOLCtrlWrapper(Controls[i]) do begin
            FKOLParentCtrl:=nil;
          end;
    end;
    Log( 'G' );
    FKOLCtrlNeeded:=True;
  end
  else
    inherited;
  LogOK;
  FINALLY
  Log( '<-TKOLCtrlWrapper.DestroyWindowHandle(' + Name + ')' );
  END;
end;

procedure TKOLCtrlWrapper.DefaultHandler(var Message);
begin
  if Assigned(FKOLCtrl) then begin
    if AllowSelfPaint and not (TMessage(Message).Msg in [WM_PAINT, WM_SETCURSOR, WM_DESTROY]) then
      CallKOLCtrlWndProc(TMessage(Message));
  end
  else
    inherited;
end;

procedure TKOLCtrlWrapper.CallKOLCtrlWndProc(var Message: TMessage);
var
  _Msg: TMsg;
begin
  Log( '->TKOLCtrlWrapper.CallKOLCtrlWndProc' );
  try
    if csLoading in ComponentState then
    else
    begin
      _Msg.hwnd:=FKOLCtrl.GetWindowHandle;
      Log( 'hwnd: ' + Int2Str( _Msg.hwnd ) );
      _Msg.message:=Message.Msg;
      _Msg.wParam:=Message.wParam;
      _Msg.lParam:=Message.lParam;
      Log('msg:'+Int2Str( Message.Msg ) + ' FKOLCtrl:' + Int2Hex( DWORD( FKOLCtrl ), 6 ) );
      TRY
        Message.Result:=FKOLCtrl.WndProc(_Msg);
        Log('result:' + Int2Str( Message.Result ));
      EXCEPT on E: Exception do
             begin
               Log( '*** Exception ' + E.Message );
             end;
      END;
    end;
    LogOK;
  finally
    Log( '<-TKOLCtrlWrapper.CallKOLCtrlWndProc' );
  end;
end;

procedure TKOLCtrlWrapper.Invalidate;
begin
  if not Assigned(FKOLCtrl) then
    inherited
  else
  begin
    if HandleAllocated then
    begin
      InvalidateRect(WindowHandle, nil, not (csOpaque in ControlStyle))
    end;
    FKOLCtrl.Invalidate;
  end;
end;

procedure TKOLCtrlWrapper.SetAllowSelfPaint(const Value: boolean);
begin
  if FAllowSelfPaint = Value then exit;
  FAllowSelfPaint := Value;
  UpdateAllowSelfPaint;
end;

procedure TKOLCtrlWrapper.UpdateAllowSelfPaint;
var
  i: integer;

begin
  if Assigned(FKOLCtrl) and HandleAllocated then begin
    if not (csAcceptsControls in ControlStyle) then begin
      if FAllowSelfPaint then
        i:=SW_SHOW
      else
        i:=SW_HIDE;
      EnumChildWindows(WindowHandle, @EnumChildProc, i);
    end;
    SetWindowPos(Handle, 0, 0, 0, 0, 0, SWP_DRAWFRAME or SWP_FRAMECHANGED or SWP_NOACTIVATE or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);
    Invalidate;
  end;
end;

function TKOLCtrlWrapper.GetKOLParentCtrl: PControl;
begin
  Log( '->TKOLCtrlWrapper.GetKOLParentCtrl' );
  TRY
    if (FKOLParentCtrl = nil) and (FKOLCtrl = nil) then begin
      if Assigned(Parent) and (Parent is TKOLCtrlWrapper) and Assigned(TKOLCtrlWrapper(Parent).FKOLCtrl) then
        FKOLParentCtrl:=PKOLVCLParent(TKOLCtrlWrapper(Parent).FKOLCtrl)
      else
        FKOLParentCtrl:=NewKOLVCLParent;
    end;
    Result:=FKOLParentCtrl;
    LogOK;
  FINALLY
    Log( '<-TKOLCtrlWrapper.GetKOLParentCtrl Result:' + Int2Hex( DWORD( Result ),6 ) );
  END;
end;

procedure TKOLCtrlWrapper.PaintWindow(DC: HDC);
begin
  if Assigned(FKOLCtrl) and not FAllowCustomPaint and not FAllowPostPaint then
    exit;
  inherited;
end;

procedure TKOLCtrlWrapper.CreateKOLControl(Recreating: boolean);
begin
  Log( 'TKOLCtrlWrapper.CreateKOLControl(' +
    IntToStr( Integer( Recreating ) ) + ') for ' + ClassName );
end;

procedure TKOLCtrlWrapper.KOLControlRecreated;
begin
end;

procedure TKOLCtrlWrapper.DestroyWnd;
begin
  inherited;
  if FKOLCtrlNeeded then
  begin
    StrDispose(WindowText);
    WindowText:=nil;
  end;
end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}

procedure TKOLCtrlWrapper.Change;
begin
  Log( '->TKOLCtrlWrapper.Change' );
  TRY
  LogOK;
  FINALLY
  Log( '<-TKOLCtrlWrapper.Change' );
  END;
end;

{ TKOLCustomControl }

function TKOLCustomControl.AdditionalUnits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AdditionalUnits', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLCustomControl.ApplyColorToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ApplyFontToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ApplyColorToChildren' );
  try
  for I := 0 to FParentLikeColorControls.Count - 1 do
  begin
    C := FParentLikeColorControls[ I ];
    if C.ParentColor and (C.Color <> Color) then
      C.Color := Color;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.ApplyColorToChildren' );
  end;
end;

procedure TKOLCustomControl.ApplyFontToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ApplyFontToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ApplyFontToChildren' );
  try
  if AutoSize then
    AutoSizeNow;
  for I := 0 to FParentLikeFontControls.Count - 1 do
  begin
    C := FParentLikeFontControls[ I ];
    C.Font.Assign( Font );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.ApplyFontToChildren' );
  end;
end;

procedure TKOLCustomControl.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AssignEvents' );
  try
  RptDetailed( 'Calling DefineFormEvents', WHITE );
  DefineFormEvents(
  // events marked with '^' can be set immediately following control creation:
  // in case of FormCompact = TRUE this gives smaller code since there are less
  // calls of FormSetCurCtl.
  // ---------------------------------------------------------------------------
  [ 'OnClick:^TControl.SetOnClick',
    'OnMouseDblClk:^TControl.SetOnMouseEvent,' + IntToStr(idx_fOnMouseDblClk),
    'OnMessage: TControl.Set_OnMessage',
    'OnMouseDown:^TControl.SetOnMouseEvent,' + IntToStr(idx_fOnMouseDown),
    'OnMouseMove:^TControl.SetOnMouseEvent,' + IntToStr(idx_fOnMouseMove),
    'OnMouseUp:^TControl.SetOnMouseEvent,' + IntToStr(idx_fOnMouseUp),
    'OnMouseWheel:^TControl.SetOnMouseEvent,' + IntToStr(idx_fOnMouseWheel),
    'OnMouseEnter:^TControl.SetOnMouseEnter',
    'OnMouseLeave:^TControl.SetOnMouseLeave',

    'OnDestroy:^TObj.SetOnDestroy',
    'OnEnter:^TControl.Set_TOnEvent,' + IntToStr(idx_fOnEnter),
    'OnLeave:^TControl.Set_TOnEvent,' + IntToStr(idx_fOnLeave),
    'OnKeyDown:^TControl.SetOnKeyDown',
    'OnKeyUp:^TControl.SetOnKeyUp',
    'OnKeyChar:^TControl.SetOnChar',
    'OnKeyDeadChar:^TControl.SetOnDeadChar',

    'OnChange: TControl.Set_TOnEvent,' + IntToStr(idx_fOnChangeCtl),
    'OnSelChange: TControl.Set_TOnEvent,' + IntToStr(idx_fOnSelChange),
    'OnPaint:^TControl.SetOnPaint',
    'OnEraseBkgnd:^TControl.SetOnEraseBkgnd',
    'OnResize: TControl.SetOnResize',
    'OnMove: TControl.SetOnMove',
    'OnMoving: TControl.SetOnMoving',
    'OnBitBtnDraw:^TControl.Set_OnBitBtnDraw',
    'OnDropDown:^TControl.Set_TOnEvent,' + IntToStr(idx_fOnDropDown),
    'OnCloseUp:^TControl.Set_TOnEvent,' + IntToStr(idx_FOnCloseUp),
    'OnProgress:^TControl.Set_TOnEvent,' + IntToStr(idx_FOnProgress),

    'OnDeleteAllLVItems:^TControl.SetOnDeleteAllLVItems',
    'OnDeleteLVItem:^TControl.SetOnDeleteLVItem',
    'OnLVData:^TControl.SetOnLVData',
    'OnCompareLVItems:^TControl.Set_OnCompareLVItems',
    'OnColumnClick:^TControl.SetOnColumnClick',
    'OnLVStateChange:^TControl.SetOnLVStateChange',
    'OnEndEditLVItem:^TControl.SetOnEndEditLVItem',

    'OnDrawItem:^TControl.SetOnDrawItem',
    'OnMeasureItem:^TControl.SetOnMeasureItem',
    'OnTBDropDown:^TControl.Set_TOnEvent,' + IntToStr(idx_FOnDropDown),
    'OnDropFiles:^TControl.SetOnDropFiles',
    'OnShow:^TControl.SetOnShow',
    'OnHide:^TControl.SetOnHide',
    'OnSplit:^TControl.Set_OnSplit',
    'OnScroll:^TControl.SetOnScroll',

    'OnRE_OverURL:^TControl.RESetOnURL,0',
    'OnRE_URLClick:^TControl.RESetOnURL,8',
    'OnRE_InsOvrMode_Change:^TControl.Set_TOnEvent,' + IntToStr(idx_FOnREInsModeChg),

    'OnTVBeginDrag:^TControl.Set_OnTVBeginDrag',
    'OnTVBeginEdit:^TControl.Set_OnTVBeginEdit',
    'OnTVEndEdit:^TControl.Set_OnTVEndEdit',
    'OnTVExpanded:^TControl.Set_OnTVExpanded',
    'OnTVExpanding:^TControl.Set_OnTVExpanding',
    'OnTVSelChanging:^TControl.Set_OnTVSelChanging',
    'OnTVDelete:^TControl.SetOnTVDelete'
  ] );
  RptDetailed( 'Called DefineFormEvents ---', WHITE );
  DoAssignEvents( SL, AName,
  [ 'OnClick', 'OnMouseDblClk', 'OnMessage', 'OnMouseDown', 'OnMouseMove', 'OnMouseUp', 'OnMouseWheel', 'OnMouseEnter', 'OnMouseLeave' ],
  [ @OnClick, @ OnMouseDblClk,  @OnMessage,  @OnMouseDown,  @OnMouseMove,  @OnMouseUp,  @OnMouseWheel,  @OnMouseEnter,  @OnMouseLeave  ] );
  DoAssignEvents( SL, AName,
  [ 'OnDestroy', 'OnEnter', 'OnLeave', 'OnKeyDown', 'OnKeyUp', 'OnKeyChar', 'OnKeyDeadChar' ],
  [ @ OnDestroy, @OnEnter,  @OnLeave,  @OnKeyDown,  @OnKeyUp,  @OnKeyChar , @OnKeyDeadChar ] );
  DoAssignEvents( SL, AName,
  [ 'OnChange', 'OnSelChange', 'OnPaint', 'OnEraseBkgnd', 'OnResize', 'OnMove', 'OnMoving', 'OnBitBtnDraw', 'OnDropDown', 'OnCloseUp', 'OnProgress' ],
  [ @OnChange,  @OnSelChange,  @OnPaint , @ OnEraseBkgnd, @OnResize,  @ OnMove, @ OnMoving, @OnBitBtnDraw,  @OnDropDown, @ OnCloseUp,  @ OnProgress  ] );
  DoAssignEvents( SL, AName,
  [ 'OnDeleteAllLVItems', 'OnDeleteLVItem', 'OnLVData', 'OnCompareLVItems', 'OnColumnClick', 'OnLVStateChange', 'OnEndEditLVItem' ],
  [ @ OnDeleteAllLVItems, @ OnDeleteLVItem, @ OnLVData, @ OnCompareLVItems, @ OnColumnClick, @ OnLVStateChange, @ OnEndEditLVItem ] );
  DoAssignEvents( SL, AName,
  [ 'OnDrawItem', 'OnMeasureItem', 'OnTBDropDown', 'OnDropFiles', 'OnShow', 'OnHide', 'OnSplit', 'OnScroll' ],
  [ @ OnDrawItem, @ OnMeasureItem, @ OnTBDropDown, @ OnDropFiles, @ OnShow, @ OnHide, @ OnSplit, @ OnScroll ] );
  DoAssignEvents( SL, AName,
  [ 'OnRE_URLClick', 'OnRE_InsOvrMode_Change', 'OnRE_OverURL' ],
  [ @ OnRE_URLClick, @ OnRE_InsOvrMode_Change, @ OnRE_OverURL ] );
  DoAssignEvents( SL, AName,
  [ 'OnTVBeginDrag', 'OnTVBeginEdit', 'OnTVEndEdit', 'OnTVExpanded', 'OnTVExpanding', 'OnTVSelChanging', 'OnTVDelete' ],
  [ @ OnTVBeginDrag, @ OnTVBeginEdit, @ OnTVEndEdit, @ OnTVExpanded, @ OnTVExpanding, @ OnTVSelChanging, @ OnTVDelete ] );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AssignEvents' );
  end;
end;

function TKOLCustomControl.AutoHeight(Canvas: TCanvas): Integer;
var Txt: String;
    Sz: TSize;
    R: TRect;
    Flags: DWORD;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AutoHeight', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AutoHeight' );
  try
  if not AutoSize then
    Result := Height
  else
  begin
    if Caption <> '' then
      Txt := Caption
    else
      Txt := 'Ap^_/|';
    Windows.GetTextExtentPoint32( Canvas.Handle, PChar( Txt ), Length( Txt ),
                                  Sz ); // TODO: dangerous
    Result := Sz.cy;
    if WordWrap and (Align <> caClient) then
    begin
      R := ClientRect;
      Flags := DT_CALCRECT or DT_EXPANDTABS or DT_WORDBREAK;
      CASE TextAlign OF
      taCenter: Flags := Flags or DT_CENTER;
      taRight : Flags := Flags or DT_RIGHT;
      END;
      CASE VerticalAlign OF
      vaCenter: Flags := Flags or DT_VCENTER;
      vaBottom: Flags := Flags or DT_BOTTOM;
      END;
      DrawText( Canvas.Handle, PChar( Txt ), Length( Txt ), R, Flags ); // TODO: dangerous
      Result := R.Bottom - R.Top;
    end;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AutoHeight' );
  end;
end;

procedure TKOLCustomControl.AutoSizeNow;
var TmpBmp: graphics.TBitmap;
    W, H: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'AutoSizeNow', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AutoSizeNow' );
  try

  if not AutoSize then Exit;
  if fAutoSizingNow or (csLoading in ComponentState) then
  begin
    LogOK; Exit;
  end;
  fAutoSizingNow := TRUE;
  //Rpt( 'Autosize, Name: ' + Name, RED );
  TmpBmp := graphics.TBitmap.Create;
  try
    TmpBmp.Width := 10;
    TmpBmp.Height := 10;
    //Rpt( 'Autosize, Prepare Font for WYSIWIG Paint', RED );
    PrepareCanvasFontForWYSIWIGPaint( TmpBmp.Canvas );
    //Rpt( 'Name=' + Name + ': Canvas.Handle := ' +
    //  Int2Hex( TmpBmp.Canvas.Handle, 8 ), WHITE );
    if WordWrap then
      W := Width
    else
      W := AutoWidth( TmpBmp.Canvas );
    H := AutoHeight( TmpBmp.Canvas );
    //Rpt( 'Name=' + Name + ': Canvas.Handle := ' +
    //  Int2Hex( TmpBmp.Canvas.Handle, 8 ), WHITE );
    //Rpt( 'Name=' + Name + ': W=' + IntToStr( W ) + ' H=' + IntToStr( H ), WHITE );
    if Align in [ caNone, caLeft, caRight ] then
    if not fNoAutoSizeX and not WordWrap then
      Width := W + fAutoSzX;
    if Align in [ caNone, caTop, caBottom ] then
      Height := H + fAutoSzY;
  finally
    TmpBmp.Free;
    fAutoSizingNow := FALSE;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.AutoSizeNow' );
  end;
end;

function TKOLCustomControl.AutoWidth(Canvas: TCanvas): Integer;
var Txt: String;
    Sz: TSize;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AutoWidth', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AutoWidth' );
  try
  if WordWrap or not AutoSize then
    Result := Width
  else
  begin
    Txt := Caption;
    if fsItalic in Font.FontStyle then
      Txt := Txt + ' ';
    Windows.GetTextExtentPoint32( Canvas.Handle, PChar( Txt ), Length( Txt ),
                                  Sz ); // TODO: Dangerous
    Result := Sz.cx;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AutoWidth' );
  end;
end;

procedure TKOLCustomControl.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Change', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.Change' );
  try
  if not fChangingNow then
  begin
    fChangingNow := TRUE;
    try
      if not (csLoading in ComponentState) then
      if ParentKOLForm <> nil then
        ParentKOLForm.Change( Self );
    finally
      fChangingNow := FALSE;
    end;
  end;
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.Change' );
  end;
end;

procedure TKOLCustomControl.Click;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Click', 0
  @@e_signature:
  end;
  //
end;

function TKOLCustomControl.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ClientMargins', 0
  @@e_signature:
  end;
  Result :=  Rect( 0, 0, 0, 0 );
end;

procedure TKOLCustomControl.CollectChildrenWithParentColor;
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.CollectChildrenWithParentColor' );
  try
  FParentLikeColorControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = Self) then
    if (C as TKOLCustomControl).parentColor then
      FParentLikeColorControls.Add( C );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.CollectChildrenWithParentColor' );
  end;
end;

procedure TKOLCustomControl.CollectChildrenWithParentFont;
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.CollectChildrenWithParentFont' );
  try
  FParentLikeFontControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = Self) then
    if (C as TKOLCustomControl).ParentFont then
      FParentLikeFontControls.Add( C );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.CollectChildrenWithParentFont' );
  end;
end;

function TKOLCustomControl.ControlIndex: Integer;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ControlIndex', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ControlIndex' );
  try
  Result := -1;
  for I := 0 to Parent.ControlCount-1 do
    if Parent.Controls[ I ] = Self then
    begin
      Result := I;
      break;
    end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.ControlIndex' );
  end;
end;

constructor TKOLCustomControl.Create(AOwner: TComponent);
var F: TKOLForm;
    K: TComponent;
    ColorOfParent: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Create' );
  try

  fWindowed := TRUE;
  FTabOrder := -2;
  fNotifyList := TList.Create;
  {$IFDEF NOT_USE_KOLCTRLWRAPPER}
  FAllowSelfPaint := TRUE;
  {$ENDIF NOT_USE_KOLCTRLWRAPPER}
  Log( '//// inherited starting' );
  inherited;
  Log( '//// inherited called' );

  {if not(csLoading in ComponentState) then
  if OwnerKOLForm( AOwner ) = nil then
  begin
    raise Exception.Create( 'You forget to place TKOLForm or descendant component onto the form!'#13#10 +
          'Check also if TKOLProject already dropped onto the main form.' +
          #13#10'classname = ' + ClassName );
  end;}

  FIsGenerateSize := TRUE;
  FIsGeneratePosition := TRUE;
  fAutoSzX := 4;
  fAutoSzY := 4;
  FParentFont := TRUE;
  FParentColor := TRUE;
  FParentLikeFontControls := TList.Create;
  FParentLikeColorControls := TList.Create;
  FFont := TKOLFont.Create( Self );
  FBrush := TKOLBrush.Create( Self );
  Width := 64;  DefaultWidth := Width;
  Height := 64; DefaultHeight := Height;

  fMargin := 2;
  K := ParentKOLControl;

  if K <> nil then
  if not( K is TKOLCustomControl ) then
    K := nil;

  F := ParentKOLForm;

  ColorOfParent := clBtnFace;
  if K <> nil then
  begin
    fCtl3D := (K as TKOLCustomControl).Ctl3D;
    ColorOfParent := (K as TKOLCustomControl).Color;
  end
    else
  if F <> nil then
  begin
    fCtl3D := F.Ctl3D;
    ColorOfParent := F.Color;
  end
  else
    fCtl3D := True;

  if DefaultParentColor then
  begin
    //Color := DefaultColor;
    //Color := ColorOfParent;
    FParentColor := FALSE;
    ParentColor := TRUE;
  end
    else
  begin
    Color := ColorOfParent;
    parentColor := FALSE;
    Color := DefaultInitialColor;
  end;

  //FparentColor := Color = ColorOfParent;

  //inherited Color := Color;

  FHasBorder := TRUE;
  FDefHasBorder := TRUE;
  //Change;

  if  F <> nil then
      FOverrideScrollbars := F.OverrideScrollbars;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Create' );
  end;
end;

destructor TKOLCustomControl.Destroy;
var F: TKOLForm;
    SaveAlign: TKOLAlign;
    I: Integer;
    C: TComponent;
    Cname: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Destroy', 0
  @@e_signature:
  end;
  Cname := Name;
  Log( '->TKOLCustomControl.Destroy(' + Cname + ')' );
  try

  if Assigned( Owner ) and not (csDestroying in Owner.ComponentState) then
  begin
    if Assigned( fNotifyList ) then
      for I := fNotifyList.Count-1 downto 0 do
      begin
        C := fNotifyList[ I ];
        if C is TKOLObj then
          (C as TKOLObj).NotifyLinkedComponent( Self, noRemoved )
        else
        if C is TKOLCustomControl then
          (C as TKOLCustomControl).NotifyLinkedComponent( Self, noRemoved );
      end;
    TRY
      if OwnerKOLForm( Owner ) <> nil then
        OwnerKOLForm( Owner ).Change( nil );
    EXCEPT
      Rpt( 'Exception (destroying control)', RED );
    END;
  end;
  F := nil;
  if Owner <> nil then
  begin
    F := ParentKOLForm;
    if F <> nil then
    begin
      if F.fDefaultBtnCtl = Self then
        F.fDefaultBtnCtl := nil;
      if F.fCancelBtnCtl = Self then
        F.fCancelBtnCtl := nil;
      SaveAlign := FAlign;
      FAlign := caNone;
      ReAlign( TRUE ); //-- realign only parent
      FAlign := SaveAlign;
    end;
  end;
  FFont.Free;
  FParentLikeFontControls.Free;
  FParentLikeColorControls.Free;
  fNotifyList.Free;
  fNotifyList := nil;
  FBrush.Free;  {YS}//! Memory leak fix
  if  FEventDefs <> nil then
      for I := 0 to FEventDefs.Count-1 do
      begin
          FreeMem( Pointer( FEventDefs.Objects[I] ) );
      end;
  FreeAndNil( FEventDefs );
  inherited;
  if (F <> nil) and not F.FIsDestroying and
     (Owner <> nil) and not(csDestroying in Owner.ComponentState) then
    F.Change( F );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Destroy(' + Cname + ')' );
  end;
end;

procedure TKOLCustomControl.DoAssignEvents(SL: TStringList; const AName: String;
  const EventNames: array of PChar; const EventHandlers: array of Pointer);
var I: Integer;
    KF: TKOLForm;
    add_SL: Boolean;
    j: Integer;
    s: KOLString;
    ev_setter, ev_handler: String;
    N_ev_setter, N_ev_handler: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DoAssignEvents', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.DoAssignEvents' );
  try

  KF := ParentKOLForm;

  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    begin
        add_SL := TRUE;
        if  (KF <> nil) and KF.FormCompact and
            (FEventDefs <> nil) then
        begin
            j := FEventDefs.IndexOf( EventNames[I] );
            if  j >= 0 then
            begin
                s := PChar( FEventDefs.Objects[j] );
                if  s = '' then continue;
                if  FAssignOnlyWinEvents and (s[1] = '^') then
                    continue;
                if  FAssignOnlyUserEvents and (s[1] <> '^') then
                    continue;
                if  s[1] = '^' then
                    Delete( s, 1, 1 );
                ev_setter := Trim( Parse( s, ',' ) );
                ev_handler := 'T' + KF.formName + '.' +
                    ParentForm.MethodName( EventHandlers[ I ] );
                N_ev_setter := KF.FormAddAlphabet( ev_setter, FALSE, FALSE, ' ' + ev_setter + ':' + EventNames[I] );
                N_ev_handler := KF.FormAddAlphabet( ev_handler, FALSE, FALSE, ' ' + ev_handler + ':' + EventNames[I] );
                s := Trim( s );
                if  s = '' then
                begin
                    KF.FormAddCtlCommand( Name, 'FormSetEvent', ' ' + EventNames[I] );
                    KF.FormAddNumParameter( N_ev_handler );
                    KF.FormAddNumParameter( N_ev_setter );
                end
                  else
                begin
                    KF.FormAddCtlCommand( Name, 'FormSetIndexedEvent', ' ' + EventNames[I] );
                    KF.FormAddNumParameter( N_ev_handler );
                    KF.FormAddNumParameter( StrToInt( s ) );
                    KF.FormAddNumParameter( N_ev_setter );
                end;
                add_SL := FALSE;
            end;
        end;
        if  add_SL then
            SL.Add( '      ' + AName + '.' + String( EventNames[ I ] ) +
                    ' := Result.' +
                    ParentForm.MethodName( EventHandlers[ I ] ) + ';' );
    end;
  end;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.DoAssignEvents' );
  end;
end;

function TKOLCustomControl.DrawMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DrawMargins', 0
  @@e_signature:
  end;
  Result := ClientMargins;
end;

procedure TKOLCustomControl.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.FirstCreate', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.FirstCreate' );
  try
  if Owner <> nil then
  if Owner is TKOLCustomControl then
  begin
    Transparent := (Owner as TKOLCustomControl).Transparent;
    {ShowMessage( 'First create of ' + Name + ' and owner Transparent = ' +
                 IntToStr( Integer( (Owner as TKOLCustomControl).Transparent ) ) );}
    if (Owner as TKOLCustomControl).Transparent then
    begin
    end;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.FirstCreate' );
  end;
end;

const
  AlignValues: array[ TKOLAlign ] of String = ( 'caNone', 'caLeft', 'caTop',
               'caRight', 'caBottom', 'caClient' );

function TKOLCustomControl.GenerateTransparentInits: String;
var KF: TKOLForm;
    S, S1, S2: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GenerateTransparentInits' );
  try

  S := ''; // пока ничего не надо
  if Align = caNone then
  begin
    if IsGenerateSize then
    begin
      if PlaceRight then
        S := '.PlaceRight'
      else
      if PlaceDown then
        S := '.PlaceDown'
      else
      if PlaceUnder then
        S := '.PlaceUnder'
      else
      if not CenterOnParent then
      if (actualLeft <> ParentMargin) or (actualTop <> ParentMargin) then
      begin
        S1 := IntToStr( actualLeft );
        S2 := IntToStr( actualTop );
        S := '.SetPosition( ' + S1 + ', ' + S2 + ' )';
      end;
    end;
  end;
  if Align <> caNone then
    S := S + '.SetAlign ( ' + AlignValues[ Align ] + ' )';
  S := S + Generate_SetSize;
  if CenterOnParent and (Align = caNone) then
    S := S + '.CenterOnParent';
  KF := ParentKOLForm;
  if KF <> nil then
  if KF.zOrderChildren then
    S := S + '.BringToFront';
  if EditTabChar then
    S := S + '.EditTabChar';
  if (HelpContext <> 0) and (Faction = nil) then
    S := S + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )' ;
  if MouseTransparent then
    S := S + '.MouseTransparent';
  if LikeSpeedButton then
    S := S + '.LikeSpeedButton';
  if  Border <> DefaultBorder then
      S := S + '.SetBorder( ' + IntToStr( Border ) + ')';
  Result := Trim( S );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GenerateTransparentInits' );
  end;
end;

function TKOLCustomControl.GetActualLeft: Integer;
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetActualLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetActualLeft' );
  try
  Result := Left;
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Dec( Result, R.Left );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetActualLeft' );
  end;
end;

function TKOLCustomControl.GetActualTop: Integer;
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetActualTop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetActualTop' );
  try
  Result := Top;
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Dec( Result, R.Top );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetActualTop' );
  end;
end;

function TKOLCustomControl.GetParentColor: Boolean;
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetParentColor', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetParentColor' );
  try

  Result := FParentColor;
  if Result then
  begin
    C := ParentKOLControl;
    if C = nil then
    begin
      LogOK;
      Exit;
    end;
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if Color <> KF.Color then
        Color := KF.Color;
    end
      else
    begin
      KC := C as TKOLCustomControl;
      if Color <> KC.Color then
        Color := KC.Color;
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetParentColor' );
  end;
end;

function TKOLCustomControl.GetParentFont: Boolean;
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GetParentFont' );
  try

  Result := FParentFont;
  if Result then
  begin
    C := ParentKOLControl;
    if C = nil then
    begin
      LogOK;
      Exit;
    end;
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if not Font.Equal2( KF.Font ) then
        Font.Assign( KF.Font );
    end
      else
    begin
      KC := C as TKOLCustomControl;
      if not Font.Equal2( KC.Font ) then
        Font.Assign( KC.Font );
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GetParentFont' );
  end;
end;

function TKOLCustomControl.GetTabOrder: Integer;
var I, J, N: Integer;
    K, C: TComponent;
    kC: TKOLCustomControl;
    Found: Boolean;
    L: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GetTabOrder', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.GetTabOrder' );
  try

  //Old := FTabOrder;
  Result := FTabOrder;
  {if Old <> Result then
    ShowMessage( Name + '.TabOrder := ' + IntToStr( Result ) );}
  if Result = -2 then
  begin
    if (csLoading in ComponentState) or FAdjustingTabOrder then
    begin
      //LogOK;
      Exit;
    end;
    FAdjustingTabOrder := TRUE;
    L := TList.Create;
    try
      K := ParentForm;
      if K <> nil then
      begin
        for I := 0 to K.ComponentCount - 1 do
        begin
          C := K.Components[ I ];
          //if C = Self then continue;
          if not( C is TKOLCustomControl ) then continue;
          kC := C as TKOLCustomControl;
          if kC.Parent <> Parent then continue;
          L.Add( kC );
        end;
        for I := 0 to L.Count - 1 do
        begin
          kC := L[ I ];
          //ShowMessage( 'Check ' + kC.Name + ' with TabOrder = ' + IntToStr( kC.FTabOrder ) );
          if (kC.FTabOrder = Result) or (Result <= -2) then
          begin
            //ShowMessage( '! ' + kC.Name + '.TabOrder also = ' + IntToStr( Result ) );
            for N := 0 to MaxInt do
            begin
              Found := FALSE;
              for J := 0 to L.Count - 1 do
              begin
                kC := L[ J ];
                if kC.FTabOrder = N then
                begin
                  Found := TRUE;
                  break;
                end;
              end;
              if not Found then
              begin
                //ShowMessage( 'TabOrder ' + IntToStr( N ) + ' is not yet used. ( ). Assign to ' + Name );
                FTabOrder := N;
                break;
              end;
            end;
            break;
          end;
        end;
      end;
    finally
      FAdjustingTabOrder := FALSE;
      L.Free;
    end;
  end;
  if FTabOrder < 0 then
    FTabOrder := -1;
  if FTabOrder > 100000 then
    FTabOrder := 100000;
  Result := FTabOrder;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.GetTabOrder' );
  end;
end;

function TKOLCustomControl.Get_Color: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Get_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Get_Color' );
  try
  Result := inherited Color;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_Color' );
  end;
end;

function TKOLCustomControl.Get_Enabled: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Get_Enabled', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Get_Enabled' );
  try
  Result := inherited Enabled;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_Enabled' );
  end;
end;

function TKOLCustomControl.Get_Visible: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Get_Visible', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Get_Visible' );
  //Rpt( 'where from Get_Visible called?' );
  //Rpt_Stack;
  try
  Result := inherited Visible;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_Visible' );
  end;
end;

function TKOLCustomControl.IsCursorDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.IsCursorDefault', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.IsCursorDefault' );
  try
  Result := TRUE;
  if Trim( Cursor_ ) <> '' then
  if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm.Cursor <> Cursor_)
  or (ParentKOLControl <> ParentKOLForm) and ((ParentKOLControl as TKOLCustomControl).Cursor_ <> Cursor_) then
    Result := FALSE;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.IsCursorDefault' );
  end;
end;

procedure TKOLCustomControl.Paint;
var R, MR: TRect;
    P: TPoint;
    F: TKOLForm;

    procedure PaintAdditional;
    begin

    end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Paint', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Paint ' + Name );
  try

  F := ParentKOLForm;
  if F = nil then
  begin
    LogOK;
    Exit;
  end;
  if F.FIsDestroying or (Owner = nil) or
     (csDestroying in Owner.ComponentState) then
  begin
    LogOK;
    Exit;
  end;

  R := ClientRect;
  case PaintType of
  {$IFDEF _KOLCtrlWrapper_}
  ptWYSIWIG:
      if WYSIWIGPaintImplemented or Assigned(FKOLCtrl) then {YS}
      begin
        PaintAdditional;
        LogOK;
        Exit;
      end;
{YS}
  {$ELSE}
  ptWYSIWIG,
  {$ENDIF}
  ptWYSIWIGCustom:
      if WYSIWIGPaintImplemented then
      begin
        PaintAdditional;
        LogOK;
        Exit;
      end;
{YS}
  ptWYSIWIGFrames:
      if WYSIWIGPaintImplemented
         {$IFDEF _KOLCtrlWrapper_} or Assigned(FKOLCtrl) {YS} {$ENDIF}
         then
      begin
        PaintAdditional;
        if not NoDrawFrame then
        begin
          Canvas.Pen.Color := clBtnShadow;
          Canvas.Brush.Style := bsClear;
          Canvas.RoundRect( R.Left, R.Top, R.Right, R.Bottom, 3, 3 );
        end;
        LogOK;
        Exit;
      end;
  end;
  inherited;
  Canvas.Brush.Style := bsSolid;
  Canvas.Brush.Color := clBtnFace; // Color;
  Canvas.FillRect( R );
  Canvas.Pen.Color := clWindowText;
  Canvas.Brush.Color := clDkGray;
  Canvas.RoundRect( R.Left, R.Top, R.Right, R.Bottom, 3, 3 );
  InflateRect( R, -1, -1 );
  MR := DrawMargins;
  if MR.Left > 1 then
    Inc( R.Left, MR.Left-1 );
  if MR.Top > 1 then
    Inc( R.Top, MR.Top-1 );
  if MR.Right > 1 then
    Dec( R.Right, MR.Right-1 );
  if MR.Bottom > 1 then
    Dec( R.Bottom, MR.Bottom-1 );
  P := Point( 0, 0 );
  P.x := (Width - Canvas.TextWidth( Name )) div 2;
  if P.x < R.Left then P.x := R.Left;
  P.y := (Height - Canvas.TextHeight( Name )) div 2;
  if P.y < R.Top then P.y := R.Top;
  Canvas.Brush.Color := clBtnFace;
  //Canvas.Brush.Style := bsClear;
  Canvas.TextRect( R, P.x, P.y, Name );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Paint' );
  end;
end;

function TKOLCustomControl.ParentBounds: TRect;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentBounds', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ParentBounds' );
  try

  Result := Rect( 0, 0, 0, 0 );
  C := ParentKOLControl;
  if C<> nil then
  if C is TKOLCustomControl then
    Result := (C as TKOLCustomControl).BoundsRect
  else
    Result := ParentForm.ClientRect;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ParentBounds' );
  end;
end;

function TKOLCustomControl.ParentControlUseAlign: Boolean;
var C: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentControlUseAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ParentControlUseAlign' );
  try

  Result := False;
  C := Parent;
  if not(C is TForm) and (C is TKOLCustomControl) then
  begin
    Result := (C as TKOLCustomControl).Align <> caNone;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ParentControlUseAlign' );
  end;
end;

function TKOLCustomControl.ParentForm: TForm;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentForm', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.ParentForm' );
  try

  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
    Result := C as TForm;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.ParentForm' );
  end;
end;

function TKOLCustomControl.ParentKOLControl: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentKOLControl', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.ParentKOLControl' );
  try

  Result := Parent;
  while (Result <> nil) and
        not (Result is TKOLCustomControl) and
        not (Result is TForm) do
    Result := (Result as TControl).Parent;
  if Result <> nil then
  if (Result is TForm) then
    Result := ParentKOLForm;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.ParentKOLControl' );
  end;
end;

function TKOLCustomControl.ParentKOLForm: TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentKOLForm', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.ParentKOLForm' );
  try

  C := Parent;
  {if C = nil then
    C := Owner;}
  while (C <> nil) and not(C is TForm) do
    if C is TControl then
      C := (C as TControl).Parent
    else
      C := nil;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.ParentKOLForm' );
  end;
end;

function TKOLCustomControl.ParentMargin: Integer;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ParentMargin', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ParentMargin' );
  try

  C := ParentKOLControl;
  Result := 0;
  if C <> nil then
  if C is TKOLForm then
    Result := (C as TKOLForm).Margin
  else
    Result := (C as TKOLCustomControl).Margin;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ParentMargin' );
  end;
end;

function TKOLCustomControl.PrevBounds: TRect;
var K: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PrevBounds', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PrevBounds' );
  try

  Result := Rect( 0, 0, 0, 0 );
  K := PrevKOLControl;
  if K <> nil then
    Result := K.BoundsRect;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.PrevBounds' );
  end;
end;

function TKOLCustomControl.PrevKOLControl: TKOLCustomControl;
var F: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PrevKOLControl', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PrevKOLControl' );
  try

  Result := nil;
  if ParentKOLForm <> nil then
  begin
    F := (ParentKOLForm.Owner as TForm);
    for I := 0 to F.ComponentCount - 1 do
    begin
      C := F.Components[ I ];
      if C = Self then break;
      if C is TKOLCustomControl then
      if (C as TKOLCustomControl).Parent = Parent then
        Result := C as TKOLCustomControl;
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.PrevKOLControl' );
  end;
end;

function TKOLCustomControl.RefName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.RefName', 0
  @@e_signature:
  end;
  Result := 'Result.' + Name;
end;

procedure TKOLCustomControl.SetActualLeft(Value: Integer);
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetActualLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetActualLeft' );
  try
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Inc( Value, R.Left );
  end;
  Left := Value;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetActualLeft' );
  end;
end;

procedure TKOLCustomControl.SetActualTop(Value: Integer);
var P: TControl;
    R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetActualTop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetActualTop' );
  try
  P := Parent;
  if P is TKOLCustomControl then
  begin
    R := (P as TKOLCustomControl).ClientMargins;
    Inc( Value, R.Top );
  end;
  Top := Value;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetActualTop' );
  end;
end;

procedure TKOLCustomControl.SetAlign(const Value: TKOLAlign);
var
  DoSwap: boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetAlign' );
  try
  if fAlign <> Value then
  begin
    DoSwap:=not (csLoading in ComponentState) and (
            ((Value in [caLeft, caRight]) and (fAlign in [caTop, caBottom])) or
            ((fAlign in [caLeft, caRight]) and (Value in [caTop, caBottom])));
    fAlign := Value;
    if fAlign <> caNone then
    begin
      PlaceRight := False;
      PlaceDown := False;
      PlaceUnder := False;
      CenterOnParent := False;
    end;
    //inherited Align := alNone;
    {case Value of
    caNone:   inherited Align := alNone;
    caLeft:   inherited Align := alLeft;
    caTop:    inherited Align := alTop;
    caRight:  inherited Align := alRight;
    caBottom: inherited Align := alBottom;
    caClient: inherited Align := alClient;
    end;}
    if DoSwap then
      SetBounds(Left, Top, Height, Width)
    else
      ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetAlign' );
  end;
end;

procedure TKOLCustomControl.Set_autoSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_autoSize', 0
  @@e_signature:
  end;
  if FautoSize = Value then Exit;
  Log( '->TKOLCustomControl.Set_autoSize' );
  try
  FautoSize := Value;
  if Value and not (csLoading in ComponentState) then
    AutoSizeNow;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_autoSize' );
  end;
end;

procedure TKOLCustomControl.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
var R, OldBounds: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetBounds', 0
  @@e_signature:
  end;
  R := Rect( aLeft, aTop, aLeft + aWidth, aTop + aHeight );
  OldBounds := BoundsRect;
  if (R.Left = OldBounds.Left) and (R.Top = OldBounds.Top) and
     (R.Right = OldBounds.Right) and (R.Bottom = OldBounds.Bottom) then
    Exit;
  Log( '->TKOLCustomControl.SetBounds ' );
  try
  TRY
    //Rpt( 'TKOLCustomControl.SetBounds0 old Height=' + IntToStr( Height ) + ', newH=' + IntToStr( aHeight ), YELLOW );
    //Log( 'TKOLCustomControl.SetBounds1' );
    if Assigned( FOnSetBounds ) then
    begin
      //Rpt( 'TKOLCustomControl.SetBounds1A', YELLOW );
      FOnSetBounds( Self, R );
      //Log( 'TKOLCustomControl.SetBounds1B' );
      aLeft := R.Left;
      aTop := R.Top;
      aWidth := R.Right - R.Left;
      aHeight := R.Bottom - R.Top;
    end;
    //Rpt( 'TKOLCustomControl.SetBounds2 old Height=' + IntToStr( Height ) + ', newH=' + IntToStr( aHeight ), YELLOW );
    R := Rect( Left, Top, Left + Width, Top + Height );
    //Log( 'TKOLCustomControl.SetBounds3' );
    //Rpt( 'inherited SetBounds: aHeight=' + IntToStr( aHeight ), YELLOW );
    inherited SetBounds( aLeft, aTop, aWidth, aHeight );
    //Rpt( 'inherited SetBounds called: Height=' + IntToStr( Height ), YELLOW );
    //Log( 'TKOLCustomControl.SetBounds4' );
    //Rpt( 'H before AutoSize: ' + IntToStr( Height ) + ',aHeight' + IntToStr( aHeight ), RED );
    if AutoSize then AutoSizeNow;
    //Rpt( 'H after AutoSize: ' + IntToStr( Height ), RED );
    //Log( 'TKOLCustomControl.SetBounds5' );
    if (Left <> R.Left) or (Top <> R.Top) or
       (Width <> R.Right - R.Left) or (Height <> R.Bottom - R.Top) then
    begin
      //Rpt( 'Call realign, h=' + IntToStr( Height ) + ', R.H=' + IntToStr( R.Bottom - R.Top ), RED );
      //Height := R.Bottom - R.Top;
      ReAlign( FALSE );
      //Rpt( 'Realigned, h=' + IntToStr( Height ) + ', R.H=' + IntToStr( R.Bottom - R.Top ), RED );
    end;
    R := BoundsRect;
    if (R.Left <> OldBounds.Left) or (R.Right <> OldBounds.Right) or
       (R.Top <> OldBounds.Top) or (R.Bottom <> OldBounds.Bottom) then
    begin
      //Rpt( 'Set bounds: h=' + IntToStr( R.Bottom - R.Top ), RED );
      Change;
    end;
    //Log( 'TKOLCustomControl.SetBounds6 (after Change)' );
  EXCEPT
    on E: Exception do
    begin
      Rpt( 'Exception in TKOLCustomControl.SetBounds: ' + E.Message, RED );
      Rpt_Stack;
    end;
  END;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetBounds' );
  end;
end;

procedure TKOLCustomControl.SetCaption(const Value: TDelphiString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetCaption' );
  try

  if Faction = nil then
  begin
    if fCaption = Value then
    begin
      LogOK;
      Exit;
    end;
    fCaption := Value;
  end
  else
    fCaption := Faction.Caption;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Caption:=fCaption;
  {$ENDIF}
{YS}
  if AutoSize then
    AutoSizeNow;
  Invalidate;
  Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCaption' );
  end;
end;

procedure TKOLCustomControl.SetCenterOnParent(const Value: Boolean);
var R: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCenterOnParent', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetCenterOnParent' );
  try

  if (fAlign <> caNone) and Value or (Value = fCenterOnParent) then
  begin
    LogOK;
    Exit;
  end;
  fCenterOnParent := Value;
  if Value then
  begin
    PlaceRight := False;
    PlaceDown := False;
    PlaceUnder := False;
    if not (csLoading in ComponentState) then
    begin
      R := ParentBounds;
      Left := (R.Right - R.Left - Width) div 2;
      Top := (R.Bottom - R.Top - Height) div 2;
    end;
  end;
  Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCenterOnParent' );
  end;
end;

procedure TKOLCustomControl.SetClsStyle(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetClsStyle', 0
  @@e_signature:
  end;
  if fClsStyle = Value then Exit;
  Log( '->TKOLCustomControl.SetClsStyle' );
  try
  fClsStyle := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetClsStyle' );
  end;
end;

procedure TKOLCustomControl.SetCtl3D(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCtl3D', 0
  @@e_signature:
  end;
  if FCtl3D = Value then Exit;
  Log( '->TKOLCustomControl.SetCtl3D' );
  try
  FCtl3D := Value;
  if Assigned(FKOLCtrl) and not (csLoading in ComponentState) then
    FKOLCtrl.Ctl3D:=FCtl3D
  else
    Invalidate;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCtl3D' );
  end;
end;

procedure TKOLCustomControl.SetCursor(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetCursor', 0
  @@e_signature:
  end;
  if FCursor = Value then Exit;
  Log( '->TKOLCustomControl.SetCursor' );
  try
  FCursor := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCursor' );
  end;
end;

procedure TKOLCustomControl.SetDoubleBuffered(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetDoubleBuffered', 0
  @@e_signature:
  end;
  if FDoubleBuffered = Value then Exit;
  Log( '->TKOLCustomControl.SetDoubleBuffered' );
  try
  FDoubleBuffered := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetDoubleBuffered' );
  end;
end;

procedure TKOLCustomControl.SetEraseBackground(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetEraseBackground', 0
  @@e_signature:
  end;
  if FEraseBackground = Value then Exit;
  Log( '->TKOLCustomControl.SetEraseBackground' );
  try
  FEraseBackground := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetEraseBackground' );
  end;
end;

procedure TKOLCustomControl.SetExStyle(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetExStyle', 0
  @@e_signature:
  end;
  if fExStyle = Value then Exit;
  Log( '->TKOLCustomControl.SetExStyle' );
  try
  fExStyle := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetExStyle' );
  end;
end;

procedure TKOLCustomControl.SetFont(const Value: TKOLFont);
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetFont' );
  try
  if not (csLoading in ComponentState) then
  begin
    C := ParentKOLControl;
    if C <> nil then
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if not Value.Equal2( KF.Font ) then
        parentFont := FALSE;
    end
      else
    if C is TKOLCustomControl then
    begin
      KC := C as TKOLCustomControl;
      if not Value.Equal2( KC.Font ) then
        parentFont := FALSE;
    end;
  end;
  if not fFont.Equal2( Value ) then
  begin
    CollectChildrenWithParentFont;
    fFont.Assign( Value );
    ApplyFontToChildren;
    //if csLoading in ComponentState then
    //  FParentFont := DetectParentFont;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetFont' );
  end;
end;

procedure TKOLCustomControl.SetMargin(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMargin', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMargin' );
  try
  if fMargin <> Value then
  begin
    fMargin := Value;
    ReAlign( FALSE );
    Change;
    Invalidate;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMargin' );
  end;
end;

procedure TKOLCustomControl.SetMarginBottom(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginBottom', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginBottom' );
  try
  if FMarginBottom <> Value then
  begin
    FMarginBottom := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginBottom' );
  end;
end;

procedure TKOLCustomControl.SetMarginLeft(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginLeft' );
  try
  if FMarginLeft <> Value then
  begin
    FMarginLeft := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginLeft' );
  end;
end;

procedure TKOLCustomControl.SetMarginRight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginRight', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginRight' );
  try
  if FMarginRight <> Value then
  begin
    FMarginRight := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginRight' );
  end;
end;

procedure TKOLCustomControl.SetMarginTop(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetMarginTop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetMarginTop' );
  try
  if FMarginTop <> Value then
  begin
    FMarginTop := Value;
    ReAlign( FALSE );
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetMarginTop' );
  end;
end;

procedure TKOLCustomControl.SetName(const NewName: TComponentName);
var OldName, NameNew: String;
    I, N: Integer;
    Success: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetName', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetName' );
  try

  OldName := Name;
  inherited SetName( NewName );
  if OldName = NewName then
  begin
    LogOK;
    Exit;
  end;
  if (Copy( NewName, 1, 3 ) = 'KOL') and (OldName = '') then
  begin
    NameNew := Copy( NewName, 4, Length( NewName ) - 3 );
    Success := True;
    if Owner <> nil then
    while Owner.FindComponent( NameNew ) <> nil do
    begin
      Success := False;
      for I := 1 to Length( NameNew ) do
      begin
        if AnsiChar(NameNew[ I ]) in [ '0'..'9' ] then
        begin
          Success := True;
          N := StrToInt( Copy( NameNew, I, Length( NameNew ) - I + 1 ) );
          Inc( N );
          NameNew := Copy( NameNew, 1, I - 1 ) + IntToStr( N );
          break;
        end;
      end;
      if not Success then break;
    end;
    if Success then
      Name := NameNew;
    if not (csLoading in ComponentState) then
      FirstCreate;
  end;
  Invalidate;
  Change;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetName' );
  end;
end;

procedure TKOLCustomControl.SetOnBitBtnDraw(const Value: TOnBitBtnDraw);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnBitBtnDraw', 0
  @@e_signature:
  end;
  if @ FOnBitBtnDraw = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnBitBtnDraw' );
  try
  FOnBitBtnDraw := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnBitBtnDraw' );
  end;
end;

procedure TKOLCustomControl.SetOnChange(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnChange', 0
  @@e_signature:
  end;
  if @ FOnChange = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnChange' );
  try
  FOnChange := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnChange' );
  end;
end;

procedure TKOLCustomControl.SetOnChar(const Value: TOnChar);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnChar', 0
  @@e_signature:
  end;
  if @ FOnChar = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnChar' );
  try
  FOnChar := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnChar' );
  end;
end;

procedure TKOLCustomControl.SetOnClick(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnClick', 0
  @@e_signature:
  end;
  if @ fOnClick = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnClick' );
  try
  fOnClick := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnClick' );
  end;
end;

procedure TKOLCustomControl.SetOnCloseUp(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnCloseUp', 0
  @@e_signature:
  end;
  if @ FOnCloseUp = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnCloseUp' );
  try
  FOnCloseUp := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnCloseUp' );
  end;
end;

procedure TKOLCustomControl.SetOnColumnClick(const Value: TOnLVColumnClick);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnColumnClick', 0
  @@e_signature:
  end;
  if @ FOnColumnClick = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnColumnClick' );
  try
  FOnColumnClick := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnColumnClick' );
  end;
end;

procedure TKOLCustomControl.SetOnCompareLVItems(const Value: TOnCompareLVItems);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnCompareLVItems', 0
  @@e_signature:
  end;
  if @ FOnCompareLVItems = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnCompareLVItems' );
  try
  FOnCompareLVItems := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnCompareLVItems' );
  end;
end;

procedure TKOLCustomControl.SetOnDeleteAllLVItems(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDeleteAllLVItems', 0
  @@e_signature:
  end;
  if @ FOnDeleteAllLVItems = @ Value then Exit;
  FOnDeleteAllLVItems := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDeleteLVItem(const Value: TOnDeleteLVItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDeleteLVItem', 0
  @@e_signature:
  end;
  if @ FOnDeleteLVItem = @ Value then Exit;
  FOnDeleteLVItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDestroy(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDestroy', 0
  @@e_signature:
  end;
  if @ FOnDestroy = @ Value then Exit;
  FOnDestroy := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDrawItem(const Value: TOnDrawItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDrawItem', 0
  @@e_signature:
  end;
  if @ FOnDrawItem = @ Value then Exit;
  FOnDrawItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDropDown(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDropDown', 0
  @@e_signature:
  end;
  if @ FOnDropDown = @ Value then Exit;
  FOnDropDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnDropFiles(const Value: TOnDropFiles);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnDropFiles', 0
  @@e_signature:
  end;
  if @ FOnDropFiles = @ Value then Exit;
  FOnDropFiles := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnEndEditLVItem(const Value: TOnEditLVItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnEndEditLVItem', 0
  @@e_signature:
  end;
  if @ FOnEndEditLVItem = @ Value then Exit;
  FOnEndEditLVItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnEnter', 0
  @@e_signature:
  end;
  if @ FOnEnter = @ Value then Exit;
  FOnEnter := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnEraseBkgnd(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnEraseBkgnd', 0
  @@e_signature:
  end;
  if @ FOnEraseBkgnd = @ Value then Exit;
  FOnEraseBkgnd := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnHide(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnHide', 0
  @@e_signature:
  end;
  if @ FOnHide = @ Value then Exit;
  FOnHide := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnKeyDown(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnKeyDown', 0
  @@e_signature:
  end;
  if @ FOnKeyDown = @ Value then Exit;
  FOnKeyDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnKeyUp(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnKeyUp', 0
  @@e_signature:
  end;
  if @ FOnKeyUp = @ Value then Exit;
  FOnKeyUp := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnLeave', 0
  @@e_signature:
  end;
  if @ FOnLeave = @ Value then Exit;
  FOnLeave := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnLVData(const Value: TOnLVData);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnLVData', 0
  @@e_signature:
  end;
  if @ FOnLVData = @ Value then Exit;
  FOnLVData := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnLVStateChange(const Value: TOnLVStateChange);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnLVStateChange', 0
  @@e_signature:
  end;
  if @ FOnLVStateChange = @ Value then Exit;
  FOnLVStateChange := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMeasureItem(const Value: TOnMeasureItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMeasureItem', 0
  @@e_signature:
  end;
  if @ FOnMeasureItem = @ Value then Exit;
  FOnMeasureItem := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMessage(const Value: TOnMessage);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMessage', 0
  @@e_signature:
  end;
  if @ FOnMessage = @ Value then Exit;
  FOnMessage := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseDblClk(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseDblClk', 0
  @@e_signature:
  end;
  if @ fOnMouseDblClk = @ Value then Exit;
  fOnMouseDblClk := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseDown(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseDown', 0
  @@e_signature:
  end;
  if @ FOnMouseDown = @ Value then Exit;
  FOnMouseDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseEnter', 0
  @@e_signature:
  end;
  if @ FOnMouseEnter = @ Value then Exit;
  FOnMouseEnter := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseLeave', 0
  @@e_signature:
  end;
  if @ FOnMouseLeave = @ Value then Exit;
  FOnMouseLeave := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseMove(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseMove', 0
  @@e_signature:
  end;
  if @ FOnMouseMove = @ Value then Exit;
  FOnMouseMove := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseUp(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseUp', 0
  @@e_signature:
  end;
  if @ FOnMouseUp = @ Value then Exit;
  FOnMouseUp := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMouseWheel(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMouseWheel', 0
  @@e_signature:
  end;
  if @ FOnMouseWheel = @ Value then Exit;
  FOnMouseWheel := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnMove(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMove', 0
  @@e_signature:
  end;
  if @ FOnMove = @ Value then Exit;
  FOnMove := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnPaint(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnPaint', 0
  @@e_signature:
  end;
  if @ FOnPaint = @ Value then Exit;
  FOnPaint := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnProgress(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnProgress', 0
  @@e_signature:
  end;
  if @ FOnProgress = @ Value then Exit;
  FOnProgress := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnResize(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnResize', 0
  @@e_signature:
  end;
  if @ FOnResize = @ Value then Exit;
  FOnResize := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnRE_InsOvrMode_Change(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnRE_InsOvrMode_Change', 0
  @@e_signature:
  end;
  if @ FOnRE_InsOvrMode_Change = @ Value then Exit;
  FOnRE_InsOvrMode_Change := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnRE_OverURL(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnRE_OverURL', 0
  @@e_signature:
  end;
  if @ FOnRE_OverURL = @ Value then Exit;
  FOnRE_OverURL := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnRE_URLClick(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnRE_URLClick', 0
  @@e_signature:
  end;
  if @ FOnRE_URLClick = @ Value then Exit;
  FOnRE_URLClick := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnSelChange(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnSelChange', 0
  @@e_signature:
  end;
  if @ FOnSelChange = @ Value then Exit;
  FOnSelChange := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnShow(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnShow', 0
  @@e_signature:
  end;
  if @ FOnShow = @ Value then Exit;
  FOnShow := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnSplit(const Value: TOnSplit);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnSplit', 0
  @@e_signature:
  end;
  if @ FOnSplit = @ Value then Exit;
  FOnSplit := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTBDropDown(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTBDropDown', 0
  @@e_signature:
  end;
  if @ FOnTBDropDown = @ Value then Exit;
  FOnTBDropDown := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVBeginDrag(const Value: TOnTVBeginDrag);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVBeginDrag', 0
  @@e_signature:
  end;
  if @ FOnTVBeginDrag = @ Value then Exit;
  FOnTVBeginDrag := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVBeginEdit(const Value: TOnTVBeginEdit);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVBeginEdit', 0
  @@e_signature:
  end;
  if @ FOnTVBeginEdit = @ Value then Exit;
  FOnTVBeginEdit := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVDelete(const Value: TOnTVDelete);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVDelete', 0
  @@e_signature:
  end;
  if @ FOnTVDelete = @ Value then Exit;
  FOnTVDelete := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVEndEdit(const Value: TOnTVEndEdit);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVEndEdit', 0
  @@e_signature:
  end;
  if @ FOnTVEndEdit = @ Value then Exit;
  FOnTVEndEdit := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVExpanded(const Value: TOnTVExpanded);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVExpanded', 0
  @@e_signature:
  end;
  if @ FOnTVExpanded = @ Value then Exit;
  FOnTVExpanded := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVExpanding(const Value: TOnTVExpanding);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVExpanding', 0
  @@e_signature:
  end;
  if @ FOnTVExpanding = @ Value then Exit;
  FOnTVExpanding := Value;
  Change;
end;

procedure TKOLCustomControl.SetOnTVSelChanging(const Value: TOnTVSelChanging);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnTVSelChanging', 0
  @@e_signature:
  end;
  if @ FOnTVSelChanging = @ Value then Exit;
  FOnTVSelChanging := Value;
  Change;
end;

procedure TKOLCustomControl.SetParent(Value: TWinControl);
var PF: TKOLFont;
    {$IFDEF _KOLCTRLWRAPPER_}
    PT: TPaintType;
    {$ENDIF}
    CodeAddr: procedure of object;
    F: TKOLForm;
    Cname: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetParent', 0
  @@e_signature:
  end;
  Cname := Name;
  Log( '->TKOLCustomControl.SetParent(' + Cname + ')' );
  try

  Log( '1 - inherited' );
  inherited;

  Log( '2 - ParentKOLForm' );
  F := ParentKOLForm;
  if (F <> nil) and not F.FIsDestroying and (Owner <> nil) and
     not( csDestroying in Owner.ComponentState ) then
  begin
    Log( '3 - Value <> nil?' );
    if Value <> nil then
    if (Value is TKOLCustomControl) or (Value is TForm) then
    begin
      Log( '4 - Get_ParentFont' );
      PF := Get_ParentFont;
      Log( '5 - Font(=' + Int2Hex( DWORD( Font), 6 ) + ').Assign( PF(=' +
        Int2Hex( DWORD( PF ), 6 ) + ') )' );
      {$IFDEF _D4orHigher}
      try
        Font.Assign(PF); {YS}
      except
        on E: Exception do
        begin
          Log( 'Exception while assigning a font:' + E.message );
        end;
      end;
      {$ENDIF}
    end;
  {YS}
    {$IFDEF _KOLCtrlWrapper_}
    Log( '6 - PaintType' );
    PT := PaintType;
    FAllowSelfPaint := PT in [ptWYSIWIG, ptWYSIWIGFrames];
    FAllowCustomPaint:=PT <> ptWYSIWIG;
    {$ENDIF}
  {YS}
    Log( '7 - CodeAddr := Change' );
    CodeAddr := Change;
    TRY
      Log( '8 - Change' );
      Change;
    EXCEPT on E: Exception do
           Log( 'Exception in TKOLCustomControl.SetParent: ' + E.Message );
    END;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetParent(' + Cname + ')' );
  end;
end;

procedure TKOLCustomControl.SetparentColor(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetparentColor', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetparentColor' );
  try
  FParentColor := Value;
  if Value then
  begin
    if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm <> nil) then
      Color := ParentKOLForm.Color
    else
    if ParentKOLControl <> nil then
      Color := (ParentKOLControl as TKOLCustomControl).Color;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetparentColor' );
  end;
end;

procedure TKOLCustomControl.SetParentFont(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetParentFont' );
  try
  FParentFont := Value;
  if Value then
  begin
    if FFont = nil then Exit;
    if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm <> nil) then
      Font.Assign( ParentKOLForm.Font )
    else
    if ParentKOLControl <> nil then
      Font.Assign( (ParentKOLControl as TKOLCustomControl).Font );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetParentFont' );
  end;
end;

procedure TKOLCustomControl.SetPlaceDown(const Value: Boolean);
var R: TRect;
    M: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetPlaceDown', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetPlaceDown' );
  try
  if (fAlign <> caNone) and Value or (Value = fPlaceDown) then
  begin
    LogOK;
    Exit;
  end;
  fPlaceDown := Value;
  if Value then
  begin
    fPlaceRight := False;
    fPlaceUnder := False;
    fCenterOnParent := False;
    if not (csLoading in ComponentState) then
    begin
      R := PrevBounds;
      M := ParentMargin;
      Left := M;
      Top := R.Bottom + M;
    end;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetPlaceDown' );
  end;
end;

procedure TKOLCustomControl.SetPlaceRight(const Value: Boolean);
var R: TRect;
    M: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetPlaceRight', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetPlaceRight' );
  try
  if (fAlign <> caNone) and Value or (Value = fPlaceRight) then
  begin
    LogOK;
    Exit;
  end;
  fPlaceRight := Value;
  if Value then
  begin
    fPlaceDown := False;
    fPlaceUnder := False;
    fCenterOnParent := False;
    if not (csLoading in ComponentState) then
    begin
      R := PrevBounds;
      M := ParentMargin;
      Left := R.Right + M;
      Top := R.Top;
    end;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetPlaceRight' );
  end;
end;

procedure TKOLCustomControl.SetPlaceUnder(const Value: Boolean);
var R: TRect;
    M: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetPlaceUnder', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetPlaceUnder' );
  try
  if (fAlign <> caNone) and Value or (Value = fPlaceUnder) then
  begin
    LogOK;
    Exit;
  end;
  fPlaceUnder := Value;
  if Value then
  begin
    fPlaceDown := False;
    fPlaceRight := False;
    fCenterOnParent := False;
    if not (csLoading in ComponentState) then
    begin
      R := PrevBounds;
      M := ParentMargin;
      Left := R.Left;
      Top := R.Bottom + M;
    end;
  end;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetPlaceUnder' );
  end;
end;

procedure TKOLCustomControl.SetShadowDeep(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetShadowDeep', 0
  @@e_signature:
  end;
  if FShadowDeep = Value then Exit;
  Log( '->TKOLCustomControl.SetShadowDeep' );
  try
  FShadowDeep := Value;
  Invalidate;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetShadowDeep' );
  end;
end;

procedure TKOLCustomControl.SetStyle(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetStyle', 0
  @@e_signature:
  end;
  if fStyle = Value then Exit;
  Log( '->TKOLCustomControl.SetStyle' );
  try
  fStyle := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetStyle' );
  end;
end;

procedure TKOLCustomControl.SetTabOrder(const Value: Integer);
var K, C: TComponent;
    I, Old, N, MinIdx: Integer;
    L: TList;
    kC, kMin: TKOLCustomControl;
    Found: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTabOrder', 0
  @@e_signature:
  end;
  if FTabOrder = Value then Exit;
  Log( '->TKOLCustomControl.SetTabOrder' );
  try
  Old := FTabOrder;
  FTabOrder := Value;
  if FTabOrder < -2 then
    FTabOrder := -1;
  if FTabOrder > 100000 then
    FTabOrder := 100000;
  if FTabOrder >= 0 then
  if not(csLoading in ComponentState) and not FAdjustingTabOrder then
  begin
    FAdjustingTabOrder := TRUE;
    TRY

      L := TList.Create;
      K := ParentForm;
      if K <> nil then
      try
        for I := 0 to K.ComponentCount - 1 do
        begin
          C := K.Components[ I ];
          //if C = Self then continue;
          if not( C is TKOLCustomControl ) then continue;
          kC := C as TKOLCustomControl;
          if kC.Parent <> Parent then continue;
          L.Add( kC );
        end;
        // 1. Move TabOrder for all controls with TabOrder >= Value up.
        // 1. Переместить TabOrder для всех, кто имеет такой же и выше, на 1 вверх.
        for I := 0 to L.Count - 1 do
        begin
          kC := L.Items[ I ];
          if kC = Self then continue;
          if kC.FTabOrder >= Value then
            Inc( kC.FTabOrder );
        end;
        // 2. "Squeeze" to prevent holes. (To prevent situation, when N, N+k,
        //    values are present and N+1 is not used).
        for N := 0 to L.Count - 1 do
        begin
          Found := FALSE;
          for I := 0 to L.Count - 1 do
          begin
            kC := L.Items[ I ];
            if kC.FTabOrder = N then
            begin
              Found := TRUE;
              break;
            end;
          end;
          if not Found then
          begin
            // Value N is not used as a TabOrder. Try to find next used TabOrder
            // value and move it to N.
            MinIdx := -1;
            for I := 0 to L.Count - 1 do
            begin
              kC := L.Items[ I ];
              if kC.FTabOrder > MaxInt div 4 - 1 then continue;
              if kC.FTabOrder < -MaxInt div 4 + 1 then continue;
              if (kC.FTabOrder > N) then
              begin
                if (MinIdx >= 0) then
                begin
                  kMin := L.Items[ MinIdx ];
                  if kC.FTabOrder < kMin.FTabOrder then
                    MinIdx := I;
                end
                  else
                  MinIdx := I;
              end;
            end;
            if MinIdx < 0 then break;
            // Such TabOrder value found at control with MinIdx index in a list.
            kMin := L.Items[ MinIdx ];
            MinIdx := kMin.FTabOrder;
            for I := 0 to L.Count - 1 do
            begin
              kC := L.Items[ I ];
              if kC.FTabOrder > N then
              begin
                kC.FTabOrder := kC.FTabOrder - (MinIdx - N);
                //ShowMessage( kC.Name + '.TabOrder := ' + IntToStr( kC.TabOrder ) );
              end;
            end;
          end;
        end;

      finally
        L.Free;
      end;
    FINALLY
      FAdjustingTabOrder := FALSE;
    END;
  end;
  if Old <> FTabOrder then
    ReAlign( TRUE );
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTabOrder' );
  end;
end;

procedure TKOLCustomControl.SetTabStop(const Value: Boolean);
{var K: TComponent;
    I, N: Integer;}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTabStop', 0
  @@e_signature:
  end;
  if FTabStop = Value then Exit;
  Log( '->TKOLCustomControl.SetTabStop' );
  try
  FTabStop := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTabStop' );
  end;
end;

procedure TKOLCustomControl.SetTag(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTag', 0
  @@e_signature:
  end;
  if FTag = Value then Exit;
  Log( '->TKOLCustomControl.SetTag' );
  TRY
  FTag := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTabStop' );
  end;
end;

procedure TKOLCustomControl.SetTextAlign(const Value: TTextAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTextAlign', 0
  @@e_signature:
  end;
  if FTextAlign = Value then Exit;
  Log( '->TKOLCustomControl.SetTextAlign' );
  try
  FTextAlign := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.TextAlign:=kol.TTextAlign(Value);
  {$ENDIF}
{YS}
  Invalidate;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetTextAlign' );
  end;
end;

function Color2Str( Color: TColor ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Color2Str', 0
  @@e_signature:
  end;
  case Color of
  clScrollBar:             Result := 'clScrollBar';
  clBackground:            Result := 'clBackground';
  clActiveCaption:         Result := 'clActiveCaption';
  clInactiveCaption:       Result := 'clInactiveCaption';
  clMenu:                  Result := 'clMenu';
  clWindow:                Result := 'clWindow';
  clWindowFrame:           Result := 'clWindowFrame';
  clMenuText:              Result := 'clMenuText';
  clWindowText:            Result := 'clWindowText';
  clCaptionText:           Result := 'clCaptionText';
  clActiveBorder:          Result := 'clActiveBorder';
  clInactiveBorder:        Result := 'clInactiveBorder';
  clAppWorkSpace:          Result := 'clAppWorkSpace';
  clHighlight:             Result := 'clHighlight';
  clHighlightText:         Result := 'clHighlightText';
  clBtnFace:               Result := 'clBtnFace';
  clBtnShadow:             Result := 'clBtnShadow';
  clGrayText:              Result := 'clGrayText';
  clBtnText:               Result := 'clBtnText';
  clInactiveCaptionText:   Result := 'clInactiveCaptionText';
  clBtnHighlight:          Result := 'clBtnHighlight';
  cl3DDkShadow:            Result := 'cl3DDkShadow';
  cl3DLight:               Result := 'cl3DLight';
  clInfoText:              Result := 'clInfoText';
  clInfoBk:                Result := 'clInfoBk';

  clBlack:                 Result := 'clBlack';
  clMaroon:                Result := 'clMaroon';
  clGreen:                 Result := 'clGreen';
  clOlive:                 Result := 'clOlive';
  clNavy:                  Result := 'clNavy';
  clPurple:                Result := 'clPurple';
  clTeal:                  Result := 'clTeal';
  clGray:                  Result := 'clGray';
  clSilver:                Result := 'clSilver';
  clRed:                   Result := 'clRed';
  clLime:                  Result := 'clLime';
  clYellow:                Result := 'clYellow';
  clBlue:                  Result := 'clBlue';
  clFuchsia:               Result := 'clFuchsia';
  clAqua:                  Result := 'clAqua';
  //clLtGray:                Result := 'clLtGray';
  //clDkGray:                Result := 'clDkGray';
  clWhite:                 Result := 'clWhite';
  clNone:                  Result := 'clNone';
  clDefault:               Result := 'clDefault';

  else
    Result := '$' + Int2Hex( Color, 6 );
  end;
end;

procedure TKOLCustomControl.SetTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetTransparent', 0
  @@e_signature:
  end;
  if FTransparent = Value then Exit;
  FTransparent := Value;
  Invalidate;
  Change;
end;

procedure TKOLCustomControl.SetupColor(SL: TStrings; const AName: String);
var KF: TKOLForm;
    C: DWORD;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupColor', 0
  @@e_signature:
  end;

  KF := ParentKOLForm;

  if (Brush.Bitmap = nil) or Brush.Bitmap.Empty then
  begin
      if  Brush.BrushStyle <> bsSolid then
          Brush.GenerateCode( SL, AName )
      else
      begin
          if  DefaultKOLParentColor and not parentColor or
              not DefaultKOLParentColor and (Color <> DefaultColor) then
              if  (KF <> nil) and KF.FormCompact then
              begin
                  KF.FormAddCtlCommand( Name, 'FormSetColor', '' );
                  C := Color;
                  if  C and $FF000000 = $FF000000 then
                      C := C and $FFFFFF or $80000000;
                  C := (C shl 1) or (C shr 31);
                  RptDetailed( 'Prepare FormSetColor parameter, src color =$' +
                      Int2Hex( Color, 2 ) + ', coded color =$' +
                      Int2Hex( C, 2 ), CYAN );
                  KF.FormAddNumParameter( C );
                  //SL.Add( '//Color = ' + IntToStr( Color ) );
              end else
              SL.Add( '    ' + AName + '.Color := TColor(' + Color2Str( Color ) + ');' );
      end;
  end
  else
      Brush.GenerateCode( SL, AName );
end;

procedure TKOLCustomControl.SetupConstruct(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupConstruct', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupConstruct' );
  try
  if  ParentKOLForm.FormCompact
  and SupportsFormCompact then
  begin
      if  HasCompactConstructor then
          SetupConstruct_Compact
      else
          SL.Add( Prefix + AName + ' := New' + TypeName + '( '
                  + SetupParams( AName, AParent ) + ' );' );
      GenerateTransparentInits_Compact;
  end
    else
  begin
      S := GenerateTransparentInits;
      SL.Add( Prefix + AName + ' := New' + TypeName + '( '
              + SetupParams( AName, AParent ) + ' )' + S + ';' );
  end;
  SetupName( SL, AName, AParent, Prefix );
  SetupSetUnicode( SL, AName );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupConstruct' );
  end;
end;

procedure TKOLCustomControl.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var KF: TKOLForm;
    CompactCode: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupFirst', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupFirst' );
  try

  fOrderChild := 0;
  SetupConstruct( SL, AName, AParent, Prefix );
  SetupName( SL, AName, AParent, Prefix );

  KF := ParentKOLForm;
  CompactCode := (KF <> nil) and KF.FormCompact and SupportsFormCompact;

  if  Tag <> 0 then
  begin
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTag', '' );
          KF.FormAddNumParameter( Tag );
      end
        else
      begin
          if  Tag < 0 then
              SL.Add( Prefix + AName + '.Tag := DWORD(' + IntToStr(Tag) + ');' )
          else
              SL.Add( Prefix + AName + '.Tag := ' + IntToStr(Tag) + ';' );
      end;
  end;

  if  not Ctl3D then
      if  CompactCode then
          KF.FormAddCtlCommand( Name, 'FormResetCtl3D', '' )
      else
          SL.Add( Prefix + AName + '.Ctl3D := False;' );

  if  FHasBorder <> FDefHasBorder then
  begin
      if  CompactCode then
      begin
          if  HasBorder then
              KF.FormAddCtlCommand( Name, 'TControl.SetHasBorder', '' )
              // param = 1
          else
              KF.FormAddCtlCommand( Name, 'FormSetHasBorderFalse', '' );
      end else
      SL.Add( Prefix + AName + '.HasBorder := ' + BoolVals[ FHasBorder ] + ';' );
    //ShowMessage( AName + '.HasBorder := ' + BoolVals[ FHasBorder ] );
  end;

  SetupTabStop( SL, AName );
  SetupFont( SL, AName );
  SetupTextAlign( SL, AName );
  if  (csAcceptsControls in ControlStyle) or BorderNeeded then
  if  (ParentKOLControl = ParentKOLForm) and (ParentKOLForm.Border <> Border)
  or  (ParentKOLControl <> ParentKOLForm) and ((ParentKOLControl as TKOLCustomControl).Border <> Border) then
      if  CompactCode then
      begin
          if  Border = 1 then
          begin
              KF.FormAddCtlCommand( Name, 'TControl.SetBorder', '' );
              // param = 1
          end
            else
          begin
              KF.FormAddCtlCommand( Name, 'FormSetBorder', '' );
              KF.FormAddNumParameter( Border );
          end;
      end else
      begin
          //SL.Add( Prefix + AName + '.Border := ' + IntToStr( Border ) + ';' );
          //--- moved to GenerateTransparentInits
      end;

  if  MarginTop <> DefaultMarginTop then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMarginTop', '' );
          KF.FormAddNumParameter( MarginTop );
      end else
      SL.Add( Prefix + AName + '.MarginTop := ' + IntToStr( MarginTop ) + ';' );

  if  MarginBottom <> DefaultMarginBottom then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMarginBottom', '' );
          KF.FormAddNumParameter( MarginBottom );
      end else
      SL.Add( Prefix + AName + '.MarginBottom := ' + IntToStr( MarginBottom ) + ';' );

  if  MarginLeft <> DefaultMarginLeft then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMarginLeft', '' );
          KF.FormAddNumParameter( MarginLeft );
      end else
      SL.Add( Prefix + AName + '.MarginLeft := ' + IntToStr( MarginLeft ) + ';' );

  if  MarginRight <> DefaultMarginRight then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMarginRight', '' );
          KF.FormAddNumParameter( MarginRight );
      end else
      SL.Add( Prefix + AName + '.MarginRight := ' + IntToStr( MarginRight ) + ';' );

  if  not IsCursorDefault then
      if  Copy( Cursor_, 1, 4 ) = 'IDC_' then
          if  CompactCode then
          begin
              KF.FormAddCtlCommand( Name, 'FormCursorLoad_0', '' );
              KF.FormAddNumParameter( IDC2Number( Cursor_ ) );
          end else
          SL.Add( Prefix + AName + '.Cursor := LoadCursor( 0, ' + Cursor_ + ' );' )
  else
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormCursorLoad_hInstance', '' );
          KF.FormAddStrParameter( Cursor_ );
      end else
      SL.Add( Prefix + AName + '.Cursor := LoadCursor( hInstance, ''' + Trim( Cursor_ ) + ''' );' );

  if  not Visible and (Faction = nil) then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetVisibleFalse', '' );
      end else
      SL.Add( Prefix + AName + '.Visible := False;' );

  if  not Enabled and (Faction = nil) then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetEnabledFalse', '' );
      end else
      SL.Add( Prefix + AName + '.Enabled := False;' );

  if  DoubleBuffered and not Transparent then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetDoubleBuffered', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.DoubleBuffered := True;' );

  if  Owner <> nil then
  if  Transparent and ((Owner is TKOLCustomControl)
  and not (Owner as TKOLCustomControl).Transparent
  or  not(Owner is TKOLCustomControl)
  and not ParentKOLForm.Transparent) then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetTransparent', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.Transparent := True;' );

  if  Owner = nil then
  if  Transparent then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetTransparent', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.Transparent := TRUE;' );

  if  EraseBackground then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetEraseBkgndTrue', '' );
      end else
      SL.Add( Prefix + AName + '.EraseBackground := TRUE;' );

  if  MinWidth > 0 then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMinWidth', '' );
          KF.FormAddNumParameter( MinWidth );
      end else
      SL.Add( Prefix + AName + '.MinWidth := ' + IntToStr( MinWidth ) + ';' );

  if  MinHeight > 0 then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMinHeight', '' );
          KF.FormAddNumParameter( MinHeight );
      end else
      SL.Add( Prefix + AName + '.MinHeight := ' + IntToStr( MinHeight ) + ';' );

  if  MaxWidth > 0 then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMaxWidth', '' );
          KF.FormAddNumParameter( MaxWidth );
      end else
      SL.Add( Prefix + AName + '.MaxWidth := ' + IntToStr( MaxWidth ) + ';' );

  if  MaxHeight > 0 then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMaxHeight', '' );
          KF.FormAddNumParameter( MaxHeight );
      end else
      SL.Add( Prefix + AName + '.MaxHeight := ' + IntToStr( MaxHeight ) + ';' );

  if  IgnoreDefault <> FDefIgnoreDefault then
      if  CompactCode then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetIgnoreDefault', '' );
          KF.FormAddNumParameter( Integer( not IgnoreDefault ) );
      end else
      SL.Add( Prefix + AName + '.IgnoreDefault := ' + BoolVals[ IgnoreDefault ] + ';' );

  //Rpt( '-------- FHint = ' + FHint );
  if  (Trim( FHint ) <> '') and (Faction = nil) and KF.AssignTextToControls then
  begin
      if  (ParentKOLForm <> nil) and ParentKOLForm.ShowHint then
      begin
          if  CompactCode then
          begin
              KF.FormAddCtlCommand( Name, 'FormSetHintText', '' );
              KF.FormAddStrParameter( Hint );
          end
            else
          begin
              SL.Add( Prefix + '{$IFDEF USE_MHTOOLTIP}' );
              SL.Add( Prefix + AName + '.Hint.Text := ' + StringConstant( 'Hint', Hint ) + ';' );
              SL.Add( Prefix + '{$ENDIF USE_MHTOOLTIP}' );
          end;
      end;
  end;

  if  SetupColorFirst then
      SetupColor( SL, AName );

  {-- move to SetupLast:
  if  Assigned( FpopupMenu ) then
      SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
              ' );' );
  }

  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupFirst' );
  end;
end;

procedure TKOLCustomControl.SetupFont(SL: TStrings; const AName: String);
var PFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupFont' );
  try
  PFont := Get_ParentFont;
  if (PFont <> nil) and (not Assigned(Font) or not Font.Equal2( PFont )) then
    Font.GenerateCode( SL, AName, PFont );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupFont' );
  end;
end;

procedure TKOLCustomControl.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
var KF: TKOLForm;
    i: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupLast', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.SetupLast' );
  try

  KF := ParentKOLForm;
  RptDetailed( 'Setuplast for ' + AName + ' entered', WHITE );

  if  not SetupColorFirst then
      SetupColor( SL, AName );

  if  Assigned( FpopupMenu ) then
      SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
              ' );' );

  RptDetailed( 'AssignEvents for control calling', WHITE );
  RptDetailed( Name, YELLOW );
  FAssignOnlyUserEvents := FALSE;
  if  (KF <> nil) and KF.FormCompact then
      FAssignOnlyWinEvents := TRUE;
  AssignEvents( SL, AName );
  FAssignOnlyWinEvents := FALSE;
  RptDetailed( 'AssignEvents for control called', WHITE );
  RptDetailed( Name, YELLOW );

  if  fDefaultBtn then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetDefaultBtn', '' );
          KF.FormAddNumParameter( 13 );
          //KF.FormAddNumParameter( 1 );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.DefaultBtn := TRUE;' );

  if  fCancelBtn then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetDefaultBtn', '' );
          KF.FormAddNumParameter( 27 );
          //KF.FormAddNumParameter( 1 );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.CancelBtn := TRUE;' );

  if  AnchorRight or AnchorBottom then
      if  (KF <> nil) and KF.FormCompact then
      begin
          i := Integer( AnchorLeft ) +
              Integer( AnchorTop ) shl 1 +
              Integer( AnchorRight ) shl 2 +
              Integer( AnchorBottom ) shl 3;
          if  i = 1 then
              KF.FormAddCtlCommand( Name, 'TControl.SetAnchor', '' )
          else
          begin
              KF.FormAddCtlCommand( Name, 'FormSetAnchor', '' );
              KF.FormAddNumParameter( i );
          end;
      end else
      SL.Add( Prefix + AName + '.Anchor(' +
          BoolVals[ AnchorLeft ] + ', ' +
          BoolVals[ AnchorTop ] + ', ' +
          BoolVals[ AnchorRight ] + ', ' +
          BoolVals[ AnchorBottom ] + ');' );

  if  FOverrideScrollbars and FHasScrollbarsToOverride then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormOverrideScrollbars', '' );
      end
        else
      begin
          SL.Add( Prefix + '{$IFDEF OVERRIDE_SCROLLBARS}' );
          SL.Add( Prefix + 'OverrideScrollbars( ' + AName + ');' );
          SL.Add( Prefix + '{$ENDIF OVERRIDE_SCROLLBARS}' );
      end;
  end;

  SetupTabOrder( SL, AName );
  RptDetailed( 'Setuplast for form finished', WHITE );

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.SetupLast' );
  end;
end;

procedure TKOLCustomControl.SetAnchorLeft(const Value: Boolean);
begin
  if FAnchorLeft = Value then Exit;
  FAnchorLeft := Value;
  {$IFDEF _D4orHigher}
  if Value then
    Anchors := Anchors + [ akLeft ]
  else
    Anchors := Anchors - [ akLeft ];
  {$ENDIF}
  Change;
end;

procedure TKOLCustomControl.SetAnchorTop(const Value: Boolean);
begin
  if FAnchorTop = Value then Exit;
  FAnchorTop := Value;
  {$IFDEF _D4orHigher}
  if Value then
    Anchors := Anchors + [ akTop ]
  else
    Anchors := Anchors - [ akTop ];
  {$ENDIF}
  Change;
end;

function TKOLCustomControl.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent;
end;

procedure TKOLCustomControl.SetupTabStop(SL: TStringList; const AName: String);
{var K, C: TComponent;
    I, N: Integer;
    kC: TKOLCustomControl;}
    {
      Instead of assigning a value to TabOrder property, special creation order
      is provided correspondent to an order of tabulating the controls - while
      generating constructors for these.

      Вместо присваивания значения свойству TabOrder, обеспечивается особый
      порядок генерации конструкторов для визуальных объектов, при котором
      TabOrder получается такой, какой нужно.
    }
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupTabStop', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.SetupTabStop' );

  KF := ParentKOLForm;

  try
  if not TabStop and TabStopByDefault then
  begin
    if  FResetTabStopByStyle then
        if  (KF <> nil) and KF.FormCompact then
        begin
            KF.FormAddCtlCommand( Name, 'FormResetStyles', '' );
            KF.FormAddNumParameter( WS_TABSTOP );
        end else
        SL.Add( '    ' + AName + '.Style := ' + AName + '.Style and not WS_TABSTOP;' )
    else
        if  (KF <> nil) and KF.FormCompact then
        begin
            KF.FormAddCtlCommand( Name, 'FormSetTabStopFalse', '' );
        end else
        SL.Add( '    ' + AName + '.TabStop := FALSE;' );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetupTabStop' );
  end;
end;

procedure TKOLCustomControl.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetupTextAlign', 0
  @@e_signature:
  end;
  // nothing here
end;

procedure TKOLCustomControl.SetVerticalAlign(const Value: TVerticalAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetVerticalAlign', 0
  @@e_signature:
  end;
  if FVerticalAlign = Value then Exit;
  FVerticalAlign := Value;
  Invalidate;
  Change;
end;

procedure TKOLCustomControl.Set_Color(const Value: TColor);
var KF: TKOLForm;
    KC: TKOLCustomControl;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_Color' );
  try

  if not CanChangeColor and (Value <> DefaultColor) or (inherited Color = Value) then
  begin
    //ShowMessage( 'This control can not change Color value.' );
    LogOK;
    Exit;
  end;
  if not (csLoading in ComponentState) then
  begin
    C := ParentKOLControl;
    if C <> nil then
    if C is TKOLForm then
    begin
      KF := C as TKOLForm;
      if Value <> KF.Color then
        parentColor := FALSE;
    end
      else
    if C is TKOLCustomControl then
    begin
      KC := C as TKOLCustomControl;
      if Value <> KC.Color then
        parentColor := FALSE;
    end;
  end;
  CollectChildrenWithParentColor;
  if Brush <> nil then
    Brush.Color := Value;
  TRY
  Log( 'inherited Color := Value' );
  inherited Color := Value;
  EXCEPT
  Log( 'failed !!! inherited Color := Value' );
  END;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
  begin
    Log( 'FKOLCtrl.Color := Value' );
    TRY
    FKOLCtrl.Color := Value;
    EXCEPT
    Log( 'exception!!! FKOLCtrl = ' + IntToHex( Integer( FKOLCtrl ), 6 ) );
    END;
  end;
  {$ENDIF}
{YS}
  Log( 'Invalidate' );
  Invalidate;
  Log( 'ApplyColorToChildren' );
  ApplyColorToChildren;
  Log( 'Change' );
  Change;
  //if csLoading in ComponentState then
  //  FParentColor := DetectParentColor;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_Color' );
  end;
end;

procedure TKOLCustomControl.Set_Enabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_Enabled', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_Enabled' );
  try
  if inherited Enabled <> Value then
  begin
    if Faction = nil then
      inherited Enabled := Value
    else
      inherited Enabled := Faction.Enabled;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_Enabled' );
  end;
end;

procedure TKOLCustomControl.Set_Visible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.Set_Visible', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.Set_Visible' );
  try
  if inherited Visible <> Value then
  begin
    if Faction = nil then
      inherited Visible := Value
    else
      inherited Visible := Faction.Visible;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Set_Visible' );
  end;
end;

function TKOLCustomControl.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.TypeName', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.TypeName' );
  try
  Result := ClassName;
  if UpperCase( Copy( Result, 1, 4 ) ) = 'TKOL' then
    Result := Copy( Result, 5, Length( Result ) - 4 );
  if not Windowed then
    Result := 'Graph' + Result;
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.TypeName' );
  end;
end;

function TKOLCustomControl.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLCustomControl.FontPropName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.FontPropName', 0
  @@e_signature:
  end;
  Result := 'Font';
end;

procedure TKOLCustomControl.AfterFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AfterFontChange', 0
  @@e_signature:
  end;
  //
end;

procedure TKOLCustomControl.BeforeFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.BeforeFontChange', 0
  @@e_signature:
  end;
  //
end;

procedure TKOLCustomControl.SetHasBorder(const Value: Boolean);
var CodeAddr: procedure of object;
    CodeAddr1: procedure( const V: Boolean ) of object;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetHasBorder', 0
  @@e_signature:
  end;
  if FHasBorder = Value then Exit;
  Log( '->TKOLCustomControl.SetHasBorder' );
  try
  FHasBorder := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.HasBorder:=Value;
  {$ENDIF}
{YS}
  //Log( 'SetHasBorder - Change, Self=$' + Int2Hex( DWORD( Self ), 6 ) );
  CodeAddr := Change;
  //Log( 'SetHasBorder - Change Addr: $' + Int2Hex( DWORD( TMethod( CodeAddr ).Code ), 6 ) );
  CodeAddr1 := SetHasBorder;
  //Log( 'SetHasBorder = own Addr: $' + Int2Hex( DWORD( TMethod( CodeAddr1 ).code ), 6 ) );
  Change;
  Invalidate;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetHasBorder' );
  end;
end;

procedure TKOLCustomControl.SetOnScroll(const Value: TOnScroll);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnScroll', 0
  @@e_signature:
  end;
  if @ FOnScroll = @ Value then Exit;
  FOnScroll := Value;
  Change;
end;

procedure TKOLCustomControl.SetEditTabChar(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetEditTabChar', 0
  @@e_signature:
  end;
  if FEditTabChar = Value then Exit;
  FEditTabChar := Value;
  WantTabs( Value );
  Change;
end;

procedure TKOLCustomControl.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.WantTabs', 0
  @@e_signature:
  end;
end;

function TKOLCustomControl.CanNotChangeFontColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CanNotChangeFontColor', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLCustomControl.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultColor', 0
  @@e_signature:
  end;
  Result := clBtnFace;
end;

function TKOLCustomControl.DefaultParentColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultParentColor', 0
  @@e_signature:
  end;
  Result := DefaultColor = clBtnFace;
end;

function TKOLCustomControl.DefaultInitialColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultInitialColor', 0
  @@e_signature:
  end;
  Result := DefaultColor;
end;

function TKOLCustomControl.DefaultKOLParentColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.DefaultKOLParentColor', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLCustomControl.CanChangeColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CanChangeColor', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLCustomControl.PaintType: TPaintType;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PaintType', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PaintType' );
  try
  Result := ptWYSIWIG;
  if ParentKOLForm <> nil then
    Result := ParentKOLForm.PaintType;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.PaintType' );
  end;
end;

function TKOLCustomControl.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLCustomControl.CompareFirst(c, n: string): boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.CompareFirst', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint( ACanvas: TCanvas );
//var RFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint ' + Name );
  try

  TRY

    //Rpt( 'Call RunTimeFont', WHITE ); //Rpt_Stack;
    if not Font.Equal2(nil) then
    begin
      //Rpt( 'Font different ! Color=' + Int2Hex( Color2RGB( Font.Color ), 8 ),
      //  WHITE );
      ACanvas.Font.Name:= Font.FontName;
      ACanvas.Font.Height:= Font.FontHeight;
      //ACanvas.Font.Color:= Font.Color;
      ACanvas.Font.Style:= TFontStyles( Font.FontStyle );
      {$IFNDEF _D2}
      ACanvas.Font.Charset:= Font.FontCharset;
      {$ENDIF}
      ACanvas.Font.Pitch:= Font.FontPitch;
    end
    else
      ACanvas.Font.Handle:=GetDefaultControlFont;

    ACanvas.Font.Color:= Font.Color;    // !!!!!!
    ACanvas.Brush.Color := Color;

  EXCEPT
    on E: Exception do
    begin
      ShowMessage( 'Can not prepare WYSIWIG font, exception: ' + E.Message );
    end;

  END;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.PrepareCanvasFontForWYSIWIGPaint' );
  end;
end;

function TKOLCustomControl.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLCustomControl.ReAlign( ParentOnly: Boolean );
var ParentK: TComponent;
    ParentF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.ReAlign', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.ReAlign' );
  try

  if not (csLoading in ComponentState) then
  begin
    ParentF := ParentKOLForm;
    ParentK := ParentKOLControl;
    if (ParentK <> nil) and (ParentF <> nil) then
    begin
      if ParentK is TKOLForm then
        (ParentK as TKOLForm).AlignChildren( nil, FALSE )
      else
      if ParentK is TKOLCustomControl then
        if ParentF <> nil then
          ParentF.AlignChildren( ParentK as TKOLCustomControl, FALSE );
      if not ParentOnly then
        ParentF.AlignChildren( Self, FALSE );
    end
      else
      //Rpt( 'TKOLCustomControl.ReAlign -- did nothing' )
      ;
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.ReAlign' );
  end;
end;

procedure TKOLCustomControl.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.NotifyLinkedComponent' );
  try
  if Operation = noRemoved then
  if Assigned( fNotifyList ) then
    fNotifyList.Remove( Sender );
  Invalidate;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.NotifyLinkedComponent' );
  end;
end;

procedure TKOLCustomControl.AddToNotifyList(Sender: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.AddToNotifyList', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.AddToNotifyList' );
  try
  if Assigned( fNotifyList ) then
  if fNotifyList.IndexOf( Sender ) < 0 then
    fNotifyList.Add( Sender );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.AddToNotifyList' );
  end;
end;

procedure TKOLCustomControl.SetMaxHeight(const Value: Integer);
begin
  if FMaxHeight = Value then Exit;
  FMaxHeight := Value;
  Change;
end;

procedure TKOLCustomControl.SetMaxWidth(const Value: Integer);
begin
  if FMaxWidth = Value then Exit;
  FMaxWidth := Value;
  Change;
end;

procedure TKOLCustomControl.SetMinHeight(const Value: Integer);
begin
  if FMinHeight = Value then Exit;
  FMinHeight := Value;
  Change;
end;

procedure TKOLCustomControl.SetMinWidth(const Value: Integer);
begin
  if FMinWidth = Value then Exit;
  FMinWidth := Value;
  Change;
end;

procedure TKOLCustomControl.Loaded;
begin
  Log( '->TKOLCustomControl.Loaded' );
  try
  inherited;
  CollectChildrenWithParentFont;
  Font.Change;
  if AutoSize then
    AutoSizeNow;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Loaded' );
  end;
end;

procedure TKOLCustomControl.DoGenerateConstants(SL: TStringList);
begin
  //
end;

function TKOLCustomControl.AutoSizeRunTime: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLCustomControl.SetLocalizy(const Value: TLocalizyOptions);
begin
  if FLocalizy = Value then Exit;
  FLocalizy := Value;
  Change;
end;

function TKOLCustomControl.StringConstant( const Propname, Value: TDelphiString ): TDelphiString;
begin
  Log( '->TKOLCustomControl.StringConstant' );
  try
  if (Value <> '') AND
     ((Localizy = loForm) and (ParentKOLForm <> nil) and
     (ParentKOLForm.Localizy) or (Localizy = loYes)) then
  begin
    Result := ParentKOLForm.Name + '_' + Name + '_' + Propname;
    ParentKOLForm.MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value, '+' );
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.StringConstant' );
  end;
end;

function PCharStringConstant(Sender: TObject; const Propname,
  Value: String): String;
begin
  if Sender is TKOLCustomControl then
    Result := (Sender as TKOLCustomControl).StringConstant( Propname, Value )
  else
  if Sender is TKOLObj then
    Result := (Sender as TKOLObj).StringConstant( Propname, Value )
  else
  if Sender is TKOLForm then
    Result := (Sender as TKOLForm).StringConstant( PropName, Value )
  else
  begin
    Result := 'error';
    Exit;
  end;
  if Result <> '' then
    if Result[ 1 ] <> '''' then
      Result := 'PKOLChar( ' + Result + ' )';
end;

function P_PCharStringConstant( Sender: TObject; const Propname, Value: String ): String;
begin
  if Sender is TKOLCustomControl then
    Result := (Sender as TKOLCustomControl).P_StringConstant( Propname, Value )
  else
  if Sender is TKOLObj then
    Result := (Sender as TKOLObj).P_StringConstant( Propname, Value )
  else
  if Sender is TKOLForm then
    Result := (Sender as TKOLForm).P_StringConstant( PropName, Value )
  else
  begin
    Result := 'error';
    Exit;
  end;
  {if Result <> '' then
    if not (Result[ 1 ] in ['''']) then
      Result := 'PChar( ' + Result + ' )';}
end;

procedure TKOLCustomControl.SetHelpContext(const Value: Integer);
begin
  if Faction = nil then
  begin
    if FHelpContext1 = Value then Exit;
    FHelpContext1 := Value;
  end
  else
    FHelpContext1 := Faction.HelpContext;
  Change;
end;

procedure TKOLCustomControl.SetCancelBtn(const Value: Boolean);
var F: TKOLForm;
begin
  Log( '->TKOLCustomControl.SetCancelBtn' );
  try
  if FCancelBtn <> Value then
  begin
    FCancelBtn := Value;
    if Value then
    begin
      //DefaultBtn := FALSE;
      F := ParentKOLForm;
      if F <> nil then
      begin
        if (F.fCancelBtnCtl <> nil) and (F.fCancelBtnCtl <> Self) then
          F.fCancelBtnCtl.CancelBtn := FALSE;
        F.fCancelBtnCtl := Self;
      end;
    end;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetCancelBtn' );
  end;
end;

procedure TKOLCustomControl.SetDefaultBtn(const Value: Boolean);
var F: TKOLForm;
begin
  Log( '->TKOLCustomControl.SetDefaultBtn' );
  try
  if FDefaultBtn <> Value then
  begin
    FDefaultBtn := Value;
    if Value then
    begin
      //CancelBtn := FALSE;
      F := ParentKOLForm;
      if F <> nil then
      begin
        if (F.fDefaultBtnCtl <> nil) and (F.FDefaultBtnCtl <> Self) then
          F.fDefaultBtnCtl.DefaultBtn := FALSE;
        F.fDefaultBtnCtl := Self;
      end;
    end;
    if Assigned(FKOLCtrl) then
      with FKOLCtrl^ do
        if FDefaultBtn then
          Style := Style or BS_DEFPUSHBUTTON
        else
          Style := Style and not BS_DEFPUSHBUTTON;
    Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetDefaultBtn' );
  end;
end;

function TKOLCustomControl.Generate_SetSize: String;
const BoolVals: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
var W, H: Integer;
    SizeWasSet: Boolean;
begin
  Log( '->TKOLCustomControl.Generate_SetSize' );
  try

  SizeWasSet := FALSE;
  W := 0;
  H := 0;
  if Align <> caClient then
  if (Width <> DefaultWidth) or (Height <> DefaultHeight) or not Windowed then
  begin
    if ((Width <> DefaultWidth) or not Windowed) and not (Align in [ caTop, caBottom ]) then
      W := Width;
    if ((Height <> DefaultHeight) or not Windowed) and not (Align in [ caLeft, caRight ]) then
      H := Height;
  end;

  if IsGenerateSize or not Windowed then
  if not (autoSize and AutoSizeRunTime) or WordWrap or fNoAutoSizeX then
  begin
    if autoSize and AutoSizeRunTime then
      H := 0;
    if (W <> 0) or (H <> 0) then
    begin
      Result := Result + '.SetSize( ' + IntToStr( W ) + ', ' + IntToStr( H ) + ' )';
      SizeWasSet := TRUE;
    end;
  end;
  if WordWrap then
    Result := Result + '.MakeWordWrap';
  if (AutoSize and AutoSizeRunTime) xor DefaultAutoSize then
    Result := Result + '.AutoSize( ' + BoolVals[ AutoSize ] + ' )';

  if not SizeWasSet then
    //Result := Result + '{Generate_SetSize W' + IntToStr(W) + 'H' + IntToStr(H) + '} '
    ;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Generate_SetSize' );
  end;
end;

procedure TKOLCustomControl.SetIgnoreDefault(const Value: Boolean);
begin
  if FIgnoreDefault = Value then Exit; 
  FIgnoreDefault := Value;
  Change;
end;

procedure TKOLCustomControl.SetBrush(const Value: TKOLBrush);
begin
  FBrush.Assign( Value );
  Change;
end;

function TKOLCustomControl.BorderNeeded: Boolean;
begin
  Result := FALSE;
end;

procedure TKOLCustomControl.SetIsGenerateSize(const Value: Boolean);
begin
  FIsGenerateSize := Value;
  Invalidate;
end;

procedure TKOLCustomControl.SetIsGeneratePosition(const Value: Boolean);
begin
  if FIsGeneratePosition = Value then Exit;
  FIsGeneratePosition := Value;
  Change;
end;

function TKOLCustomControl.BestEventName: String;
begin
  Result := 'OnClick';
end;

procedure TKOLCustomControl.KOLControlRecreated;
begin
{$IFNDEF NOT_USE_KOLCTRLWRAPPER}
  Log( '->TKOLCustomControl.KOLControlRecreated' );
  try
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.Color:=Color;
    FKOLCtrl.Caption:=Caption;
    Font.Change;
    Brush.Change;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.KOLControlRecreated' );
  end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}
end;

function TKOLCustomControl.GetDefaultControlFont: HFONT;
begin
  Result:=GetStockObject(SYSTEM_FONT);
end;

procedure TKOLCustomControl.SetHint(const Value: String);
begin
  if Faction = nil then
  begin
    if FHint = Value then exit;
    FHint := Value;
  end
  else
    FHint := Faction.Hint;
  Change;
end;

function TKOLCustomControl.OwnerKOLForm(AOwner: TComponent): TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.OwnerKOLForm', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.OwnerKOLForm' );
  try
  //Rpt( 'Where from TKOLCustomControl.OwnerKOLForm called?' );
  //Rpt_Stack;

  C := AOwner;
  Log( '*1 TKOLCustomControl.OwnerKOLForm' );
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Log( '*2 TKOLCustomControl.OwnerKOLForm' );
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
  Log( '*3 TKOLCustomControl.OwnerKOLForm' );
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  Log( '*4 TKOLCustomControl.OwnerKOLForm' );
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.OwnerKOLForm' );
  end;
end;

procedure TKOLCustomControl.DoNotifyLinkedComponents(
  Operation: TNotifyOperation);
var I: Integer;
    C: TComponent;
begin
  Log( '->TKOLCustomControl.DoNotifyLinkedComponents' );
  try

  if Assigned( fNotifyList ) then
    for I := fNotifyList.Count-1 downto 0 do
    begin
      C := fNotifyList[ I ];
      if C is TKOLObj then
        (C as TKOLObj).NotifyLinkedComponent( Self, Operation )
      else
      if C is TKOLCustomControl then
        (C as TKOLCustomControl).NotifyLinkedComponent( Self, Operation );
    end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.DoNotifyLinkedComponents' );
  end;
end;

function TKOLCustomControl.Get_ParentFont: TKOLFont;
begin
  Log( '->TKOLCustomControl.Get_ParentFont' );
  try
  if (ParentKOLControl <> nil) then
  begin
    if ParentKOLControl = ParentKOLForm then
      Result := ParentKOLForm.Font
    else
      Result := (ParentKOLControl as TKOLCustomControl).Font;
  end
  else
    Result := nil;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.Get_ParentFont' );
  end;
end;

{$IFDEF NOT_USE_KOLCTRLWRAPPER}
procedure TKOLCustomControl.CreateKOLControl(Recreating: boolean);
begin
  Log( 'TKOLCustomControl.CreateKOLControl(' + IntToStr( Integer( Recreating ) ) + ')' );
end;

procedure TKOLCustomControl.UpdateAllowSelfPaint;
begin
  Log( 'TKOLCustomControl.UpdateAllowSelfPaint' );
end;
{$ENDIF NOT_USE_KOLCTRLWRAPPER}

procedure TKOLCustomControl.Setaction(const Value: TKOLAction);
begin
  Log( '->TKOLCustomControl.Setaction' );
  try
    if Faction <> Value then
    begin
      if Faction <> nil then
        Faction.UnLinkComponent(Self);
      Faction := Value;
      if Faction <> nil then
        Faction.LinkComponent(Self);
      Change;
    end;
    LogOK;
  finally
  Log( '<-TKOLCustomControl.Setaction' );
  end;
end;

procedure TKOLCustomControl.Notification(AComponent: TComponent; Operation: TOperation);
begin
  //Log( '->TKOLCustomControl.Notification' );
  try
    //Rpt( 'Where from TKOLCustomControl.Notification called:' );
    //Rpt_Stack;
  inherited;
  if Operation = opRemove then
    if AComponent = Faction then
    begin
      //Rpt( 'Faction.UnLinkComponent(Self);' );
      Faction.UnLinkComponent(Self);
      Faction := nil;
      //Rpt( 'eeeeeeeeeeeeeeeeeeeeeeeee' );
    end;
  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.Notification' );
  end;
end;

procedure TKOLCustomControl.SetWindowed(const Value: Boolean);
begin
  if FWindowed = Value then Exit;
  FWindowed := Value;
  Change;
end;

procedure TKOLCustomControl.SetWordWrap(const Value: Boolean);
begin
  if fWordWrap = Value then Exit;
  fWordWrap := Value;
  Change;
end;

function TKOLCustomControl.Pcode_Generate: Boolean;
begin
  Result := FALSE;
end;

procedure TKOLCustomControl.P_BeforeFontChange(SL: TStrings; const AName,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_BeforeFontChange', 0
  @@e_signature:
  end;
  //
end;

procedure TKOLCustomControl.P_SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupLast', 0
  @@e_signature:
  end;
  //Log( '->TKOLCustomControl.SetupLast' );
  try
  //P_SetupColor( SL, AName, ControlInStack );
  if P_AssignEvents( SL, AName, TRUE ) then
  begin
    {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' +
      Name );
    P_AssignEvents( SL, AName, FALSE );
    {P}SL.Add( ' DEL //' + Name );
  end;
  if fDefaultBtn then
    //SL.Add( Prefix + AName + '.DefaultBtn := TRUE;' )
    begin
      {P}SL.Add( ' L(1) L(13) ' +
         'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name +
         ' TControl_.SetDefaultBtn<3>' );
    end;
  if fCancelBtn then
    //SL.Add( Prefix + AName + '.CancelBtn := TRUE;' );
    begin
      {P}SL.Add( ' L(1) L(27) ' +
         'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name +
         ' TControl_.SetDefaultBtn<3>' );
    end;

  //LogOK;
  finally
  //Log( '<-TKOLCustomControl.SetupLast' );
  end;
end;

procedure TKOLCustomControl.P_SetupColor(SL: TStrings;
  const AName: String; var ControlInStack: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupColor', 0
  @@e_signature:
  end;
  if (Brush.Bitmap = nil) or Brush.Bitmap.Empty then
  begin
    if Brush.BrushStyle <> bsSolid then
    begin
      Brush.P_GenerateCode( SL, AName );
    end
    else
    begin
      if DefaultKOLParentColor and not parentColor or
         not DefaultKOLParentColor and (Color <> DefaultColor) then
        //SL.Add( '    ' + AName + '.Color := ' + Color2Str( Color ) + ';' );
        begin
          {P}SL.Add( ' L($' + Int2Hex( Color, 6 ) + ')' );
          {P}SL.Add( ' C1 TControl_.SetCtlColor<2>' );
        end;
    end;
  end
    else
    begin
      Brush.P_GenerateCode( SL, AName );
    end;
end;

function TKOLCustomControl.P_AssignEvents(SL: TStringList;
  const AName: String; CheckOnly: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.P_AssignEvents' );
  Result := TRUE;
  try
  if P_DoAssignEvents( SL, AName,
  [ 'OnClick', 'OnMouseDblClk', 'OnMessage', 'OnMouseDown', 'OnMouseMove', 'OnMouseUp', 'OnMouseWheel', 'OnMouseEnter', 'OnMouseLeave' ],
  [ @OnClick, @ OnMouseDblClk,  @OnMessage,  @OnMouseDown,  @OnMouseMove,  @OnMouseUp,  @OnMouseWheel,  @OnMouseEnter,  @OnMouseLeave  ],
  [ FALSE,    TRUE,             FALSE,       TRUE,          TRUE,          TRUE,        TRUE,           TRUE,           TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  if P_DoAssignEvents( SL, AName,
  [ 'OnDestroy', 'OnEnter', 'OnLeave', 'OnKeyDown', 'OnKeyUp', 'OnKeyChar', 'OnKeyDeadChar'  ],
  [ @ OnDestroy, @OnEnter,  @OnLeave,  @OnKeyDown,  @OnKeyUp,  @OnKeyChar , @OnKeyDeadChar ],
  [ FALSE,       FALSE,     FALSE,     TRUE,        TRUE,      TRUE       , TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  if P_DoAssignEvents( SL, AName,
  [ 'OnChange', 'OnSelChange', 'OnPaint', 'OnEraseBkgnd', 'OnResize', 'OnMove', 'OnMoving', 'OnBitBtnDraw', 'OnDropDown', 'OnCloseUp', 'OnProgress' ],
  [ @OnChange,  @OnSelChange,  @OnPaint,  @ OnEraseBkgnd, @OnResize,  @ OnMove, @ OnMoving, @OnBitBtnDraw,  @OnDropDown, @ OnCloseUp,  @ OnProgress  ],
  [ FALSE,      FALSE,         TRUE,      TRUE,           TRUE,       TRUE,     FALSE,          FALSE,       FALSE,        FALSE ],
  CheckOnly ) and CheckOnly then Exit;
  if P_DoAssignEvents( SL, AName,
  [ 'OnDeleteAllLVItems', 'OnDeleteLVItem', 'OnLVData', 'OnCompareLVItems', 'OnColumnClick', 'OnLVStateChange', 'OnEndEditLVItem' ],
  [ @ OnDeleteAllLVItems, @ OnDeleteLVItem, @ OnLVData, @ OnCompareLVItems, @ OnColumnClick, @ OnLVStateChange, @ OnEndEditLVItem ],
  [ TRUE,                 TRUE,             TRUE,       FALSE,              TRUE,            TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  if P_DoAssignEvents( SL, AName,
  [ 'OnDrawItem', 'OnMeasureItem', 'OnTBDropDown|OnDropDown', 'OnDropFiles', 'OnShow', 'OnHide', 'OnSplit', 'OnScroll' ],
  [ @ OnDrawItem, @ OnMeasureItem, @ OnTBDropDown, @ OnDropFiles, @ OnShow, @ OnHide, @ OnSplit, @ OnScroll ],
  [ TRUE,         TRUE,            FALSE,           TRUE,          TRUE,     TRUE,     FALSE,     TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  if P_DoAssignEvents( SL, AName,
  [ 'OnRE_URLClick', 'OnRE_InsOvrMode_Change|fOnREInsModeChg', 'OnRE_OverURL' ],
  [ @ OnRE_URLClick, @ OnRE_InsOvrMode_Change, @ OnRE_OverURL ],
  [ TRUE,            FALSE,                    TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  if P_DoAssignEvents( SL, AName,
  [ 'OnTVBeginDrag', 'OnTVBeginEdit', 'OnTVEndEdit', 'OnTVExpanded', 'OnTVExpanding', 'OnTVSelChanging', 'OnTVDelete' ],
  [ @ OnTVBeginDrag, @ OnTVBeginEdit, @ OnTVEndEdit, @ OnTVExpanded, @ OnTVExpanding, @ OnTVSelChanging, @ OnTVDelete ],
  [ FALSE,           FALSE,           FALSE,         FALSE,          FALSE,           FALSE,             TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  Result := FALSE;
  LogOK;
  finally
  if Result and CheckOnly then LogOK;
  Log( '<-TKOLCustomControl.AssignEvents' );
  end;
end;

function TKOLCustomControl.P_DoAssignEvents(SL: TStringList;
  const AName: String; const EventNames: array of PChar;
  const EventHandlers: array of Pointer;
  const EventAssignProc: array of Boolean; CheckOnly: Boolean): Boolean;
var I: Integer;
    s, p: KOLString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_DoAssignEvents', 0
  @@e_signature:
  end;
  Result := TRUE;
  //Log( '->TKOLCustomControl.P_DoAssignEvents' );
  try

  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    begin
      if CheckOnly then Exit;
      p := EventNames[ I ];
      s := Trim( Parse( p, '|' ) );
      p := Trim( p );
      //SL.Add( '      ' + AName + '.' + EventNames[ I ] + ' := Result.' +
      //        ParentForm.MethodName( EventHandlers[ I ] ) + ';' );
      if EventAssignProc[ I ] then
      begin
        if p = '' then p := 'Set' + s
        else p := s;
        {P}SL.Add( ' LoadSELF Load4 ####T' + ParentKOLForm.FormName + '.' +
          ParentForm.MethodName( EventHandlers[ I ] ) );
        {P}SL.Add( ' C2 TControl_.' + p + '<1>'
                   );
      end
        else
      begin
        if p = '' then p := s;
        {P}SL.Add( ' Load4 ####T' + ParentKOLForm.formName + '.' +
          (Owner as TForm).MethodName( EventHandlers[ I ] ) );
        {P}SL.Add( ' C1 AddWord_Store ##TControl_.f' + p );
        {P}SL.Add( ' LoadSELF C1 AddWord_Store ##(4+TControl_.f' + p + ')' );
      end;
    end;
  end;
  if CheckOnly then
    Result := FALSE;

  //LogOK;
  finally
  //if CheckOnly and Result then LogOK;
  //Log( '<-TKOLCustomControl.P_DoAssignEvents' );
  end;
end;

procedure TKOLCustomControl.P_SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupFirst', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.P_SetupFirst' );
  try

  P_SetupConstruct( SL, AName, AParent, Prefix );
  if Tag <> 0 then
  begin
    {if Tag < 0 then
      SL.Add( Prefix + AName + '.Tag := DWORD(' + IntToStr(Tag) + ');' )
    else
      SL.Add( Prefix + AName + '.Tag := ' + IntToStr(Tag) + ';' );}
    {P}SL.Add( ' L(' + IntToStr( Tag ) + ')' );
    {P}SL.Add( ' C1 AddByte_Store #TObj_.fTag' );
  end;
  if not Ctl3D then
    //SL.Add( Prefix + AName + '.Ctl3D := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetCtl3D<2>' );
    end;
  if FHasBorder <> FDefHasBorder then
  begin
    //SL.Add( Prefix + AName + '.HasBorder := ' + BoolVals[ FHasBorder ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( FHasBorder ) ) + ')' );
    {P}SL.Add( ' C1 TControl_.SetHasBorder<2>' );
  end;
  P_SetupTabStop( SL, AName );
  P_SetupFont( SL, AName );
  P_SetupTextAlign( SL, AName );
  //SetupColor( SL, AName );
  if (csAcceptsControls in ControlStyle) or BorderNeeded then
  if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm.Border <> Border)
  or (ParentKOLControl <> ParentKOLForm) and ((ParentKOLControl as TKOLCustomControl).Border <> Border) then
    //SL.Add( Prefix + AName + '.Border := ' + IntToStr( Border ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( Border ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fMargin' );
    end;
  if MarginTop <> DefaultMarginTop then
    //SL.Add( Prefix + AName + '.MarginTop := ' + IntToStr( MarginTop ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MarginTop ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientTop' );
    end;
  if MarginBottom <> DefaultMarginBottom then
    //SL.Add( Prefix + AName + '.MarginBottom := ' + IntToStr( MarginBottom ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MarginBottom ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientBottom' );
    end;
  if MarginLeft <> DefaultMarginLeft then
    //SL.Add( Prefix + AName + '.MarginLeft := ' + IntToStr( MarginLeft ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MarginLeft ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientLeft' );
    end;
  if MarginRight <> DefaultMarginRight then
    //SL.Add( Prefix + AName + '.MarginRight := ' + IntToStr( MarginRight ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MarginRight ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientRight' );
    end;
  if not IsCursorDefault then
    if Copy( Cursor_, 1, 4 ) = 'IDC_' then
      //SL.Add( Prefix + AName + '.Cursor := LoadCursor( 0, ' + Cursor_ + ' );' )
      begin
        {P}SL.Add( ' L(' + IntToStr( IDC2Number( Cursor_ ) ) + ') //' + Cursor_ );
        {P}SL.Add( ' L(0) LoadCursor RESULT C1 TControl_.SetCursor<2>' );
      end
    else
      //SL.Add( Prefix + AName + '.Cursor := LoadCursor( hInstance, ''' + Trim( Cursor_ ) + ''' );' );
      begin
        {P}SL.Add( ' LoadStr ' + P_String2Pascal( Cursor_ ) );
        {P}SL.Add( ' Load_hInstance LoadCursor RESULT C1 TControl_.SetCursor<2>' );
      end;
  if not Visible and (Faction = nil) then
    //SL.Add( Prefix + AName + '.Visible := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetVisible<2>' );
    end;
  if not Enabled and (Faction = nil) then
    //SL.Add( Prefix + AName + '.Enabled := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetEnabled<2>' );
    end;
  if DoubleBuffered and not Transparent then
    //SL.Add( Prefix + AName + '.DoubleBuffered := True;' );
    begin
      {P}SL.Add( ' L(1) C1 TControl_.SetDoubleBuffered<2>' );
    end;
  if Owner <> nil then
  if Transparent and ((Owner is TKOLCustomControl) and not (Owner as TKOLCustomControl).Transparent or
     not(Owner is TKOLCustomControl) and not ParentKOLForm.Transparent) then
    //SL.Add( Prefix + AName + '.Transparent := True;' );
    begin
      {P}SL.Add( ' L(1) C1 TControl_.SetTransparent<2>' );
    end;
  if Owner = nil then
  if Transparent then
    //SL.Add( Prefix + AName + '.Transparent := TRUE;' );
    begin
      {P}SL.Add( ' L(1) C1 TControl_.SetTransparent<2>' );
    end;
  //AssignEvents( SL, AName );
  if EraseBackground then
    //SL.Add( Prefix + AName + '.EraseBackground := TRUE;' );
    begin
      {P}SL.Add( ' L(1) C1 AddWord_StoreB ##TControl_.fEraseUpdRgn' );
    end;
  if MinWidth > 0 then
    //SL.Add( Prefix + AName + '.MinWidth := ' + IntToStr( MinWidth ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MinWidth ) + ')' );
      {P}SL.Add( ' L(0) C2 TControl_.SetConstraint<3>' );
    end;
  if MinHeight > 0 then
    //SL.Add( Prefix + AName + '.MinHeight := ' + IntToStr( MinHeight ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MinHeight ) + ')' );
      {P}SL.Add( ' L(1) C2 TControl_.SetConstraint<3>' );
    end;
  if MaxWidth > 0 then
    //SL.Add( Prefix + AName + '.MaxWidth := ' + IntToStr( MaxWidth ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MaxWidth ) + ')' );
      {P}SL.Add( ' L(2) C2 TControl_.SetConstraint<3>' );
    end;
  if MaxHeight > 0 then
    //SL.Add( Prefix + AName + '.MaxHeight := ' + IntToStr( MaxHeight ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MaxHeight ) + ')' );
      {P}SL.Add( ' L(3) C2 TControl_.SetConstraint<3>' );
    end;
  if IgnoreDefault <> FDefIgnoreDefault then
    //SL.Add( Prefix + AName + '.IgnoreDefault := ' + BoolVals[ IgnoreDefault ] + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( Integer( IgnoreDefault ) ) + ')' );
      {P}SL.Add( ' C1 AddWord_StoreB ##TControl_.FIgnoreDefault' );
    end;
  //Rpt( '-------- FHint = ' + FHint );
  if (Trim( FHint ) <> '') and (Faction = nil)  then
  begin
    if (ParentKOLForm <> nil) and ParentKOLForm.ShowHint then
    begin
      SL.Add( Prefix + '{$IFDEF USE_MHTOOLTIP}' );
      SL.Add( Prefix + AName + '.Hint.Text := ' + StringConstant( 'Hint', Hint ) + ';' );
      SL.Add( Prefix + '{$ENDIF USE_MHTOOLTIP}' );
    end;
  end;
  P_SetupColor( SL, AName, ControlInStack );
  if Assigned( FpopupMenu ) then
    //SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name + ' );' );
    begin
      {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' +
        ParentKOLForm.FormName + '.' + FpopupMenu.Name );
      {P}SL.Add( ' C1 TControl.SetAutoPopupMenu<2>' );
    end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.P_SetupFirst' );
  end;
end;

procedure TKOLCustomControl.P_SetupConstruct(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
    nparams: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupConstruct', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.P_SetupConstruct' );
  try
  S := P_GenerateTransparentInits;
  //SL.Add( Prefix + AName + ' := New' + TypeName + '( '
  //        + SetupParams( AName, AParent ) + ' )' + S + ';' );
  {P}SL.Add( P_SetupParams( AName, AParent, nparams ) );
  if nparams > 0 then
    {P}SL.Add( ' New' + TypeName + '<' + IntToStr( Min( 3, nparams ) ) + '>' )
  else
    {P}SL.Add( ' New' + TypeName );
  {P}SL.Add( ' RESULT' );
  if S <> '' then
    SL.Add( S );
  {P}SL.Add( ' DUP LoadSELF AddWord_Store ##T' + ParentKOLForm.FormName + '.' + AName ); // SELF = form owner object
  P_SetupName( SL );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.P_SetupConstruct' );
  end;
end;

procedure TKOLCustomControl.P_SetupTabStop(SL: TStringList;
  const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupTabOrder', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.P_SetupTabOrder' );
  try
  if not TabStop and TabStopByDefault then
  begin
    if FResetTabStopByStyle then
      //SL.Add( '    ' + AName + '.Style := ' + AName + '.Style and not WS_TABSTOP;' )
      begin
        {P}SL.Add( ' DUP AddWord_LoadRef ##TControl_.fStyle' );
        {P}SL.Add( ' L(' + IntToStr( WS_TABSTOP ) + ')' );
        {P}SL.Add( ' ~ & C1 TControl_.SetStyle<2>' );
      end
    else
      //SL.Add( '    ' + AName + '.TabStop := FALSE;' );
      begin
        {P}SL.Add( ' L(0) C1 AddWord_Store ##TControl_.fTabStop' );
      end;
  end;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.P_SetupTabOrder' );
  end;
end;

procedure TKOLCustomControl.P_SetupFont(SL: TStrings; const AName: String);
var PFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupFont', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.P_SetupFont' );
  try
  PFont := Get_ParentFont;
  if (PFont <> nil) and (not Assigned(Font) or not Font.Equal2( PFont )) then
    Font.P_GenerateCode( SL, AName, PFont );
  LogOK;
  finally
  Log( '<-TKOLCustomControl.P_SetupFont' );
  end;
end;

procedure TKOLCustomControl.P_SetupTextAlign(SL: TStrings;
  const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupTextAlign', 0
  @@e_signature:
  end;
  // nothing here
end;

function TKOLCustomControl.P_GenerateTransparentInits: String;
var KF: TKOLForm;
    S, S1, S2: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_GenerateTransparentInits', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.P_GenerateTransparentInits' );
  try

  S := ''; // пока ничего не надо
  if Align = caNone then
  begin
    if IsGenerateSize then
    begin
      if PlaceRight then
        //S := '.PlaceRight'
        {P}S := S + ' DUP TControl.PlaceRight<1>'
      else
      if PlaceDown then
        //S := '.PlaceDown'
        {P}S := S + ' DUP TControl.PlaceDown<1>'
      else
      if PlaceUnder then
        //S := '.PlaceUnder'
        {P}S := S + ' DUP TControl.PlaceUnder<1>'
      else
      if not CenterOnParent then
      if (actualLeft <> ParentMargin) or (actualTop <> ParentMargin) then
      begin
        S1 := IntToStr( actualLeft );
        S2 := IntToStr( actualTop );
        //S := '.SetPosition( ' + S1 + ', ' + S2 + ' )';
        {P}S := S + ' L(' + S2 + ') L(' + S1 + ') C2 TControl.SetPosition<3>';
      end;
    end;
  end;
  if Align <> caNone then
    //S := S + '.SetAlign ( ' + AlignValues[ Align ] + ' )';
    {P}S := S + ' L(' + IntToStr( Integer( Align ) ) + ') C1 TControl_.SetAlign<2>';
  S := S + P_Generate_SetSize;
  if CenterOnParent and (Align = caNone) then
    //S := S + '.CenterOnParent';
    {P}S := S + ' DUP TControl.CenterOnParent<1>';
  KF := ParentKOLForm;
  if KF <> nil then
  if KF.zOrderChildren then
    //S := S + '.BringToFront';
    {P}S := S + ' DUP TControl.BringToFront<1>';
  if EditTabChar then
    //S := S + '.EditTabChar';
    {P}S := S + ' DUP TControl.EditTabChar<1>';
  if (HelpContext <> 0) and (Faction = nil) then
    //S := S + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )' ;
    {P}S := S + ' L(' + IntToStr( HelpContext ) + ') C1 TControl.AssignHelpContext<2>';
  if (KF <> nil) and KF.Unicode then
    //S := S + '.SetUnicode( TRUE )';
    {P}S := S + #13#10' IFNDEF(UNICODE_CTRLS)'#13#10' L(1) C1 TControl.SetUnicode<2>'+
                #13#10' ENDIF';
  if MouseTransparent then
    //S := S + '.MouseTransparent';
    {P}S := S + #13#10' DUP TControl.MouseTransparent<1>';
  if LikeSpeedButton then
    //S := S + '.LikeSpeedButton';
    {P}S := S + #13#10' DUP TControl.LikeSpeedButton<1>';
  Result := Trim( S );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.P_GenerateTransparentInits' );
  end;
end;

function TKOLCustomControl.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 1;
  {P}Result := //AParent;
               ' DUP';
end;

function TKOLCustomControl.P_Generate_SetSize: String;
var W, H: Integer;
begin
  Log( '->TKOLCustomControl.P_Generate_SetSize' );
  try

  W := 0;
  H := 0;
  if Align <> caClient then
  if (Width <> DefaultWidth) or (Height <> DefaultHeight) or not Windowed then
  begin
    if ((Width <> DefaultWidth) or not Windowed) and not (Align in [ caTop, caBottom ]) then
      W := Width;
    if ((Height <> DefaultHeight) or not Windowed) and not (Align in [ caLeft, caRight ]) then
      H := Height;
  end;

  if IsGenerateSize or not Windowed then
  if not (autoSize and AutoSizeRunTime) or WordWrap or fNoAutoSizeX then
  begin
    if autoSize and AutoSizeRunTime then
      H := 0;
    if (W <> 0) or (H <> 0) then
      //Result := Result + '.SetSize( ' + IntToStr( W ) + ', ' + IntToStr( H ) + ' )';
      begin
        {P}Result := Result + ' L(' + IntToStr( H ) + ') L(' + IntToStr( W ) + ')';
        {P}Result := Result + ' C2 TControl.SetSize<3>';
      end;
  end;
  if WordWrap then
    //Result := Result + '.MakeWordWrap';
    {P}Result := Result + ' DUP TControl.MakeWordWrap<1>';
  if (AutoSize and AutoSizeRunTime) xor DefaultAutoSize then
    //Result := Result + '.AutoSize( ' + BoolVals[ AutoSize ] + ' )';
    {P}Result := Result + ' L(' + IntToStr( Integer( AutoSize ) ) + ') C1 ' +
              'TControl.AutoSize<2>';


  LogOK;
  finally
  Log( '<-TKOLCustomControl.P_Generate_SetSize' );
  end;
end;

function TKOLCustomControl.P_StringConstant(const Propname,
  Value: String): String;
begin
  Log( '->TKOLCustomControl.StringConstant' );
  try

  if (Value <> '') AND
     ((Localizy = loForm) and (ParentKOLForm <> nil) and
     (ParentKOLForm.Localizy) or (Localizy = loYes)) then
  begin
    //Result := ParentKOLForm.Name + '_' + Name + '_' + Propname;
    {P}Result := ' ResourceString(' + Name + '_' + PropName + ')';
    ParentKOLForm.MakeResourceString( Result, Value );
  end
    else
  begin
    //Result := String2Pascal( Value );
    {P}Result := ' LoadAnsiStr ' + P_String2Pascal( Value );
  end;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.StringConstant' );
  end;
end;

function TKOLCustomControl.SetupColorFirst: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLCustomControl.P_ProvideFakeType(SL: TStrings;
  const Declaration: String);
var i: Integer;
begin
  for i := 0 to SL.Count-1 do
      if  AnsiCompareText( SL[ i ], Declaration ) = 0 then Exit;
  SL.Insert( 1, Declaration );
end;

function TKOLCustomControl.VerticalAlignAsKOLVerticalAlign: Integer;
begin
  CASE VerticalAlign OF
  vaCenter: Result := 0;
  vaTop: Result := 1;
  vaBottom: Result := 2;
  else Result := 0;
  END;
end;

procedure TKOLCustomControl.SetAnchorBottom(const Value: Boolean);
begin
  if FAnchorBottom = Value then Exit;
  FAnchorBottom := Value;
  if Value then
  begin
    {$IFDEF _D4orHigher}
    if Value then
    begin
      Anchors := Anchors + [ akBottom ];
      if FAnchorTop then
        Anchors := AnChors + [ akTop ]
      else
        Anchors := AnChors - [ akTop ];
    end else
      Anchors := Anchors - [ akBottom ];
    {$ELSE}
    // Owners/users of Delphi2,3! Please develop this code for you (and send it
    // me) if you need anchors. Otherwise do not forget check size of parent
    // each time before compiling/building the project.
    {$ENDIF}
  end;
  Change;
end;

procedure TKOLCustomControl.SetAnchorRight(const Value: Boolean);
begin
  if FAnchorRight = Value then Exit;
  FAnchorRight := Value;
  if Value then
  begin
    {$IFDEF _D4orHigher}
    if Value then
    begin
      Anchors := Anchors + [ akRight ];
      if FAnchorLeft then
        Anchors := Anchors + [ akLeft ]
      else
        Anchors := Anchors - [ akLeft ];
    end else
      Anchors := Anchors - [ akRight ];
    {$ENDIF}
  end;
  Change;
end;

procedure TKOLCustomControl.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  if FpopupMenu = Value then Exit;
  FpopupMenu := Value;
  Change;
end;

procedure TKOLCustomControl.P_AfterFontChange(SL: TStrings; const AName,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.P_AfterFontChange', 0
  @@e_signature:
  end;
  //
end;

function TKOLCustomControl.GetWindowed: Boolean;
begin
  {$IFDEF DISABLE_GRAPHIC_CTRLS}
  Result := TRUE;
  {$ELSE}
  Result := FWindowed;
  {$ENDIF}
end;

procedure TKOLCustomControl.SetupName(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  if FNameSetuped then Exit;
  KF := ParentKOLForm;
  if  KF = nil then Exit;
  if  (Name <> '') and KF.GenerateCtlNames then
  begin
      if  KF.FormCompact and SupportsFormCompact then
      begin
          if  AParent <> 'nil' then
          begin
              KF.FormAddCtlCommand( Name, 'FormSetName', '' );
              KF.FormAddStrParameter( Name );
          end
            else
              SL.Add(Format( '%s%s.SetName( Result, ''%s'' ); ', [Prefix, AName, Name]));
      end
        else
      begin
          if  AParent <> 'nil' then // this control placed NOT on datamodule
              SL.Add(Format( '%s%s.SetName( Result.Form, ''%s'' ); ', [Prefix, AName, Name]))
          else  // not on form
              SL.Add(Format( '%s%s.SetName( Result, ''%s'' ); ', [Prefix, AName, Name]));
      end;
      FNameSetuped := TRUE;
  end;
end;

procedure TKOLCustomControl.P_SetupName(SL: TStringList);
begin
  if fP_NameSetuped then Exit;
  if Name <> '' then
  begin
    //SL.Add( '   {$IFDEF USE_NAMES}' );
    //SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    //SL.Add( '   {$ENDIF}' );
    {
    if AParent <> 'nil' then // this control placed NOT on datamodule
      Sl.Add(Format( '%s%s.SetName( Result.Form, ''%s'' ); ', [Prefix, AName, Name]))
    else  // not on form
      Sl.Add(Format( '%s%s.SetName( Result, ''%s'' ); ', [Prefix, AName, Name]));
    }
    {P}SL.Add( ' IFDEF(USE_NAMES)' );
    {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Name ) );
    {P}SL.Add( ' LoadSELF' ); // второй фактический (1-й формальный параметр) -
                              // объект-хозяин, держатель списка именованных объектов
    {P}SL.Add( ' C3 TObj_.SetName<3>' );
    {P}SL.Add( ' DelAnsiStr' );
    {P}SL.Add( ' ENDIF' );
    fP_NameSetuped := TRUE;
  end;
end;

procedure TKOLCustomControl.SetOnDeadChar(const Value: TOnChar);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnChar', 0
  @@e_signature:
  end;
  if @ FOnDeadChar = @ Value then Exit;
  Log( '->TKOLCustomControl.SetOnChar' );
  try
  FOnDeadChar := Value;
  Change;
  LogOK;
  finally
  Log( '<-TKOLCustomControl.SetOnChar' );
  end;
end;

procedure TKOLCustomControl.SetOnMoving(const Value: TOnEventMoving);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetOnMove', 0
  @@e_signature:
  end;
  if @ FOnMoving = @ Value then Exit;
  FOnMoving := Value;
  Change;
end;

procedure TKOLCustomControl.SetupSetUnicode(SL: TStringList; const AName: String);
var KF: TKOLForm;
begin
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    if  KF.Unicode then
    begin
        if  KF.FormCompact and SupportsFormCompact then
            KF.FormAddCtlCommand( Name, 'FormSetUnicode', '' )
        else
            SL.Add( '   ' + AName + '.SetUnicode(TRUE);' );
    end;
end;

procedure TKOLCustomControl.SetAcceptChildren(const Value: Boolean);
begin
  FAcceptChildren := Value;
  if Value then
    ControlStyle := ControlStyle + [ csAcceptsControls ]
  else
    ControlStyle := ControlStyle - [ csAcceptsControls ];
end;

procedure TKOLCustomControl.SetMouseTransparent(const Value: Boolean);
begin
  if FMouseTransparent = Value then Exit;
  FMouseTransparent := Value;
  Change;
end;

procedure TKOLCustomControl.SetOverrideScrollbars(const Value: Boolean);
begin
  if fOverrideScrollbars = Value then Exit;
  FOverrideScrollbars := Value;
  Change;
end;

procedure TKOLCustomControl.SetLikeSpeedButton(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.SetLikeSpeedButton', 0
  @@e_signature:
  end;
  FLikeSpeedButton := Value;
  Change;
end;

function TKOLCustomControl.SupportsFormCompact: Boolean;
begin
    Result := FALSE;
end;

procedure TKOLCustomControl.GenerateTransparentInits_Compact;
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCustomControl.GenerateTransparentInits_Compact', 0
  @@e_signature:
  end;
  Log( '->TKOLCustomControl.GenerateTransparentInits_Compact' );
  try

  KF := ParentKOLForm;
  if  KF = nil then Exit;

  if  Align = caNone then
  begin
      if  IsGenerateSize then
      begin
          if  PlaceRight then
              KF.FormAddCtlCommand( Name, 'TControl.PlaceRight', '' )
          else
          if  PlaceDown then
              KF.FormAddCtlCommand( Name, 'TControl.PlaceDown', '' )
          else
          if  PlaceUnder then
              KF.FormAddCtlCommand( Name, 'TControl.PlaceUnder', '' )
          else
          if not CenterOnParent then
          if (actualLeft <> ParentMargin) or (actualTop <> ParentMargin) then
          begin
              KF.FormAddCtlCommand( Name, 'FormSetPosition', '' );
              KF.FormAddNumParameter( actualLeft );
              KF.FormAddNumParameter( actualTop );
          end;
      end;
  end;
  if  Align <> caNone then
  begin
      if  Integer( Align ) = 1 then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.Set_Align', '' );
          // param = 1
      end
        else
      begin
          KF.FormAddCtlCommand( Name, 'FormSetAlign', '' );
          KF.FormAddNumParameter( Integer( Align ) );
      end;
  end;
  Generate_SetSize_Compact;
  if  CenterOnParent and (Align = caNone) then
      KF.FormAddCtlCommand( Name, 'TControl.CenterOnParent', '' );
  if  KF.zOrderChildren then
      KF.FormAddCtlCommand( Name, 'TControl.BringToFront', '' );
  if  EditTabChar then
      KF.FormAddCtlCommand( Name, 'TControl.EditTabChar', '' );
  if  (HelpContext <> 0) and (Faction = nil) then
  begin
      KF.FormAddCtlCommand( Name, 'FormAssignHelpContext', '' );
      KF.FormAddNumParameter( HelpContext );
  end;
  if  MouseTransparent then
      KF.FormAddCtlCommand( Name, 'TControl.MouseTransparent', '' );
  if  LikeSpeedButton then
      KF.FormAddCtlCommand( Name, 'TControl.LikeSpeedButton', '' );

  LogOK;
  finally
  Log( '<-TKOLCustomControl.GenerateTransparentInits_Compact' );
  end;
end;

procedure TKOLCustomControl.SetupConstruct_Compact;
begin
    // must be overriden when SupportsFormCompact returns TRUE
    ParentKOLForm.FormAddCtlParameter( Name );
    ParentKOLForm.FormCurrentCtlForTransparentCalls := Name;
end;

procedure TKOLCustomControl.Generate_SetSize_Compact;
const BoolVals: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
var W, H: Integer;
    SizeWasSet: Boolean;
    KF: TKOLForm;
begin
  Log( '->TKOLCustomControl.Generate_SetSize_Compact' );
  try

  KF := ParentKOLForm;
  if  KF = nil then Exit;

  SizeWasSet := FALSE;
  W := 0;
  H := 0;
  if  Align <> caClient then
  if  (Width <> DefaultWidth) or (Height <> DefaultHeight) or not Windowed then
  begin
      if  ((Width <> DefaultWidth) or not Windowed)
      and not (Align in [ caTop, caBottom ]) then
          W := Width;
      if  ((Height <> DefaultHeight) or not Windowed)
      and not (Align in [ caLeft, caRight ]) then
          H := Height;
  end;

  if  IsGenerateSize or not Windowed then
  if  not (autoSize and AutoSizeRunTime) or WordWrap or fNoAutoSizeX then
  begin
      if  autoSize and AutoSizeRunTime then
          H := 0;
      if  (W <> 0) or (H <> 0) then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetSize', '' );
          KF.FormAddNumParameter( W );
          KF.FormAddNumParameter( H );
          SizeWasSet := TRUE;
      end;
  end;
  if  WordWrap then
      KF.FormAddCtlCommand( Name, 'TControl.MakeWordWrap', '' ); // param = 1
  if  (AutoSize and AutoSizeRunTime) xor DefaultAutoSize then
      KF.FormAddCtlCommand( Name, 'TControl.AutoSize', '' ); // param = 1

  if not SizeWasSet then
    //Result := Result + '{Generate_SetSize W' + IntToStr(W) + 'H' + IntToStr(H) + '} '
    ;

  LogOK;
  finally
  Log( '<-TKOLCustomControl.Generate_SetSize_Compact' );
  end;
end;

procedure TKOLCustomControl.GenerateVerticalAlign( SL: TStrings; const AName: String );
var KF: TKOLForm;
begin
    KF := ParentKOLForm;
    if  (KF <> nil) and KF.FormCompact then
    begin
        if  Integer( VerticalAlign ) = 1 then
        begin
            KF.FormAddCtlCommand( Name, 'TControl.SetVerticalAlign', '' );
            // param = 1
        end
          else
        begin
            KF.FormAddCtlCommand( Name, 'FormSetVTextVAlign', '' );
            KF.FormAddNumParameter( Integer( VerticalAlign ) );
        end;
    end else
    SL.Add( '    ' + AName + '.VerticalAlign := KOL.' + VertAligns[ VerticalAlign ] + ';' );
end;

procedure TKOLCustomControl.GenerateTextAlign(SL: TStrings;
  const AName: String);
var KF: TKOLForm;
begin
    KF := ParentKOLForm;
    if  (KF <> nil) and KF.FormCompact then
    begin
        if  Integer( TextAlign ) = 1 then
        begin
            KF.FormAddCtlCommand( Name, 'TControl.SetTextAlign', '' );
            // param = 1
        end
          else
        begin
            KF.FormAddCtlCommand( Name, 'FormSetTextAlign', '' );
            KF.FormAddNumParameter( Integer( TextAlign ) );
        end;
    end else
    SL.Add( '    ' + AName + '.TextAlign := KOL.' + TextAligns[ TextAlign ] + ';' );
end;

function TKOLCustomControl.HasCompactConstructor: Boolean;
begin
    Result := SupportsFormCompact;
end;

procedure TKOLCustomControl.DefineFormEvents(
    const EventNamesAndDefs: array of String);
var i: Integer;
    s: KOLString;
    ev_name: String;
    StoreDef: PChar;
begin
    if  FEventDefs = nil then
        FEventDefs := TStringList.Create;
    for i := 0 to High(EventNamesAndDefs) do
    begin
        s := EventNamesAndDefs[i];
        ev_name := {$IFDEF UNICODE_CTRLS} ParseW {$ELSE} Parse {$ENDIF} ( s, ':' );
        if  FEventDefs.IndexOf( ev_name ) >= 0 then
            continue;
        s := Trim(s);
        GetMem( StoreDef, Length( s )+1 );
        Move( s[1], StoreDef^, Length(s)+1 );
        FEventDefs.AddObject( ev_name, Pointer( StoreDef ) );
    end;
end;

procedure TKOLCustomControl.SetupTabOrder(SL: TStringList;
  const AName: String);
begin
    RptDetailed( 'SetupLast for ' + AName + ', TabStop = ' + IntToStr( Integer( TabStop ) ),
         YELLOW );
    if  not TabStop then Exit;
    Rpt( 'TabOrder = ' + IntToStr( FTabOrder ) +
         ', Creation order = ' + IntToStr( Integer( fCreationOrder ) ),
         YELLOW );
    if  (TabOrder <> fCreationOrder) and ParentKOLForm.AssignTabOrders then
        SL.Add( '    ' + AName + '.TabOrder := ' + IntToStr( TabOrder ) + ';' );
end;

function TKOLCustomControl.DefaultBorder: Integer;
begin
    Result := 2;
end;

{ TKOLApplet }

procedure TKOLApplet.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.AssignEvents' );
  TRY

  DoAssignEvents( SL, AName,
  [ 'OnMessage', 'OnDestroy', 'OnClose', 'OnQueryEndSession', 'OnMinimize', 'OnRestore' ],
  [ @OnMessage, @ OnDestroy, @ OnClose, @ OnQueryEndSession, @ OnMinimize, @ OnRestore  ] );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.AssignEvents' );
  END;
end;

function TKOLApplet.AutoCaption: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.AutoCaption', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLApplet.BestEventName: String;
begin
  Result := 'OnMessage';
end;

procedure TKOLApplet.Change( Sender : TComponent );
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.Change', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.Change' );
  TRY

  RptDetailed( 'Sender class: ' + Sender.ClassName, YELLOW );
  Rpt_Stack;

  if fChangingNow or ( csLoading in ComponentState ) or (Name = '') or fIsDestroying or
     (Owner = nil) or (csDestroying in Owner.ComponentState) then
  begin
    LogOK; Exit;
  end;
  //if Creating_DoNotGenerateCode then Exit;
  fChangingNow := TRUE;
  try
    FChanged := TRUE;

    if KOLProject <> nil then
    begin
      try
      S := KOLProject.SourcePath;
      except
        on E: Exception do
        begin
          ShowMessage( 'Can not obtain KOLProject.SourcePath, exception: ' +
                       E.Message );
          S := fSourcePath;
        end;
      end;
      fSourcePath := S;
      if (csLoading in ComponentState) then
      begin
        LogOK; Exit;
      end;
      if Sender <> nil then
      begin
        if (Self is TKOLForm) and ((Sender as TKOLForm).FormName <> '') then
        Rpt( Sender.Name + '(' + (Sender as TKOLForm).FormName + '): ' +
          Sender.ClassName + ' changed.', WHITE )
        else
        Rpt( Sender.Name + ': ' + Sender.ClassName + ' changed.', WHITE );
        //Rpt_Stack;
      end;
      //if (Sender <> nil) and (Sender.Name <> '') then
        KOLProject.Change;
    end
      else
    if (fSourcePath = '') or not DirectoryExists( fSourcePath ) or
       (ToolServices = nil) or not(Self is TKOLForm) then
    begin
      if FShowingWarnAbtMainForm then
      begin
        LogOK; Exit;
      end;
      if Abs( Integer( GetTickCount ) - FLastWarnTimeAbtMainForm ) > 3000 then
      begin
        FLastWarnTimeAbtMainForm := GetTickCount;
        if (csLoading in ComponentState) then
        begin
          LogOK; Exit;
        end;
        S := Name;
        if (Sender <> nil) and (Sender.Name <> '') then
          S := Sender.Name;
        if S = '' then
        begin
          LogOK; Exit;
        end;
        FShowingWarnAbtMainForm := True;
        ShowMessage( S + ' is changed, but changes can not ' +
                     'be applied because TKOLProject component is not found. ' +
                     'Be sure that your main form is opened in designer and ' +
                     'TKOLProject component present on it to provide automatic ' +
                     'or manual code generation for all changes made at design ' +
                     'time.' );
        FLastWarnTimeAbtMainForm := GetTickCount;
        FShowingWarnAbtMainForm := False;
      end;
    end
      else
    begin
      try
        if (csLoading in ComponentState) then
        begin
          LogOK; Exit;
        end;
        if Sender <> nil then
        begin
          if (Self is TKOLForm) and ((Sender as TKOLForm).FormName <> '') then
            Rpt( Sender.Name + '(' + (Sender as TKOLForm).FormName + '): ' +
              Sender.ClassName + ' changed.', WHITE )
          else
          Rpt( Sender.Name + ': ' + Sender.ClassName + ' changed.', WHITE );
        end;
        //S := ToolServices.GetCurrentFile;
        S := (Self as TKOLForm).formUnit; // by Speller
        //S := IncludeTrailingPathDelimiter( fSourcePath ) + ExtractFileName( S );
        S := IncludeTrailingPathDelimiter(fSourcePath) + S; // by Speller
        RptDetailed( 'Call GenerateUnit from AppletChanged for ' + Name, LIGHT+ CYAN );
        (Self as TKOLForm).GenerateUnit( S );
        //ShowMessage( S + ' is changed and is regenerated!' );
      except
        on E: Exception do
        begin
          ShowMessage( 'Can not handle Applet.Change, exception: ' + E.Message );
        end;
      end;
    end;

  finally
    fChangingNow := FALSE;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.Change' );
  END;
end;

procedure TKOLApplet.ChangeDPR;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.ChangeDPR', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.ChangeDPR' );
  TRY

  //BuildKOLProject;
  if (KOLProject <> nil) and not (KOLProject.FBuilding) then
    KOLProject.ConvertVCL2KOL( TRUE, FALSE );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.ChangeDPR' );
  END;
end;

constructor TKOLApplet.Create(AOwner: TComponent);
//var WasCreating: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.Create' );
  //WasCreating := Creating_DoNotGenerateCode;
  //Creating_DoNotGenerateCode := TRUE;
  TRY

  inherited;
  Visible := True;
  Enabled := True;
  if ClassName = 'TKOLApplet' then
  begin
    if KOLProject <> nil then
    begin
      if KOLProject.ProjectDest = '' then
        Caption := KOLProject.ProjectName
      else
        Caption := KOLProject.ProjectDest;
    end;
    if Applet <> nil then
    begin
      ShowMessage( 'You have already TKOLApplet component defined in your project. ' +
                   'It must be a single (and it is necessary in project only in ' +
                   'case, when the project contains several forms, or feature of ' +
                   'hiding application button on taskbar is desireable.'#13 +
                   'It is recommended to place TKOLApplet on main form of your ' +
                   'project, together with TKOLProject component.' );
    end
       else
      Applet := Self;
  end
     else
  begin
    if (Owner <> nil) and (Owner is TForm) then
    if AutoCaption then
      Caption := (Owner as TForm).Caption
    else
    begin
      if Caption <> '' then
        Caption := '';
      (Owner as TForm).Caption := '';
    end;
  end;
  FLastWarnTimeAbtMainForm := GetTickCount;

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.Create' );
    //Creating_DoNotGenerateCode := WasCreating;
  END;
end;

procedure TKOLApplet.DefineFormEvents(
  const EventNamesAndDefs: array of String);
var i: Integer;
    s: KOLString;
    ev_name: String;
    StoreDef: PAnsiChar;
begin
    if  FEventDefs = nil then
        FEventDefs := TStringList.Create;
    for i := 0 to High(EventNamesAndDefs) do
    begin
        s := EventNamesAndDefs[i];
        ev_name := Parse( s, ':' );
        if  FEventDefs.IndexOf( ev_name ) >= 0 then
            continue;
        s := Trim(s);
        GetMem( StoreDef, Length( s )+1 );
        Move( s[1], StoreDef^, Length(s)+1 );
        FEventDefs.AddObject( ev_name, Pointer( StoreDef ) );
    end;
end;

destructor TKOLApplet.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.Destroy', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.Destroy' );
  TRY

  if Applet = Self then
    Applet := nil;
  inherited;

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.Destroy' );
  END;
end;

procedure TKOLApplet.DoAssignEvents(SL: TStringList; const AName: String;
  EventNames: array of PChar; EventHandlers: array of Pointer);
var I, j: Integer;
    add_SL: Boolean;
    s: KOLString;
    ev_setter, ev_handler: String;
    N_ev_setter, N_ev_handler: Integer;
    FF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.DoAssignEvents', 0
  @@e_signature:
  end;
  //Log( '->TKOLApplet.DoAssignEvents' );
  TRY

  RptDetailed( 'DoAssignEvents begin', WHITE );

  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    begin
        add_SL := TRUE;
        if  (Self is TKOLForm) and (Owner <> nil) and (Owner is TCustomForm)
        and (Self as TKOLForm).FormCompact and (FEventDefs <> nil) then
        begin
            FF := Self as TKOLForm;
            j := FEventDefs.IndexOf( EventNames[I] );
            if  j >= 0 then
            begin
                s := PChar( FEventDefs.Objects[j] );
                if  s = '' then continue;
                if  FAssignOnlyWinEvents and (s[1] = '^') then
                    continue;
                if  FAssignOnlyUserEvents and (s[1] <> '^') then
                    continue;
                if  s[1] = '^' then
                    Delete( s, 1, 1 );
                ev_setter := Trim( Parse( s, ',' ) );
                ev_handler := 'T' + FF.formName + '.' +
                    (Owner as TCustomForm).MethodName( EventHandlers[ I ] );
                N_ev_setter := FF.FormAddAlphabet( ev_setter, FALSE, FALSE, ' ' + ev_setter + ':' + EventNames[I] );
                N_ev_handler := FF.FormAddAlphabet( ev_handler, FALSE, FALSE, ' ' + ev_handler + ':' + EventNames[I] );
                s := Trim( s );
                if  s = '' then
                begin
                    FF.FormAddCtlCommand( Name, 'FormSetEvent', ' ' + EventNames[I] );
                    FF.FormAddNumParameter( N_ev_handler );
                    FF.FormAddNumParameter( N_ev_setter );
                end
                  else
                begin
                    FF.FormAddCtlCommand( Name, 'FormSetIndexedEvent', ' ' + EventNames[I] );
                    FF.FormAddNumParameter( N_ev_handler );
                    FF.FormAddNumParameter( StrToInt( s ) );
                    FF.FormAddNumParameter( N_ev_setter );
                end;
                add_SL := FALSE;
            end;
        end;
        if  add_SL then
            SL.Add( '      ' + AName + '.' + String(EventNames[ I ]) +
                  ' := Result.' +
                  (Owner as TForm).MethodName( EventHandlers[ I ] ) + ';' );
                  // TODO: KOL_ANSI ???
      end;
  end;

  RptDetailed( 'DoAssignEvents end', WHITE );
  //LogOK;
  FINALLY
    //Log( '<-TKOLApplet.DoAssignEvents' );
  END;
end;

procedure TKOLApplet.GenerateRun(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.GenerateRun', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.GenerateRun' );
  TRY

  if Tag <> 0 then
  begin
    if Tag < 0 then
      SL.Add( '  Applet.Tag := DWORD(' + IntToStr( Tag ) + ');' )
    else
      SL.Add( '  Applet.Tag := ' + IntToStr( Tag ) + ';' );
  end;
  if not(Self is TKOLForm) then
  begin
    if AllBtnReturnClick then
      SL.Add( '  Applet.AllBtnReturnClick;' );
    if Tabulate then
      SL.Add( '  Applet.Tabulate;' )
    else
    if TabulateEx then
      SL.Add( '  Applet.TabulateEx;' );
  end;
  SL.Add( '  Run( ' + AName + ' );' );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.GenerateRun' );
  END;
end;

function TKOLApplet.Pcode_Generate: Boolean;
begin
  Result := ClassName = 'TKOLApplet';
end;

function TKOLApplet.P_AssignEvents(SL: TStringList; const AName: String;
  CheckOnly: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.P_AssignEvents', 0
  @@e_signature:
  end;
  Result := TRUE;
  Log( '->TKOLApplet.P_AssignEvents' );
  TRY

  if P_DoAssignEvents( SL, AName,
  [ 'OnMessage', 'OnDestroy', 'OnClose', 'OnQueryEndSession', 'OnMinimize', 'OnRestore' ],
  [ @OnMessage, @ OnDestroy, @ OnClose, @ OnQueryEndSession, @ OnMinimize, @ OnRestore  ],
  [ FALSE,      FALSE,       TRUE,     TRUE,                TRUE,         TRUE ],
  CheckOnly ) and CheckOnly then Exit;
  Result := FALSE;

  LogOK;
  FINALLY
    if Result and CheckOnly then LogOK;
    Log( '<-TKOLApplet.P_AssignEvents' );
  END;
end;

function TKOLApplet.P_DoAssignEvents(SL: TStringList; const AName: String;
  EventNames: array of PAnsiChar; EventHandlers: array of Pointer;
  EventAssignProc: array of Boolean;
  CheckOnly: Boolean): Boolean;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.P_DoAssignEvents', 0
  @@e_signature:
  end;
  Result := TRUE;
  //Log( '->TKOLApplet.P_DoAssignEvents' );
  TRY

  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    //SL.Add( '      ' + AName + '.' + EventNames[ I ] + ' := Result.' +
    //        (Owner as TForm).MethodName( EventHandlers[ I ] ) + ';' );
    begin
      if CheckOnly then Exit;
      if EventAssignProc[ I ] then
      begin
        {P}SL.Add( ' LoadSELF Load4 ####T' + (Owner as TForm).Name + '.' +
          (Owner as TForm).MethodName( EventHandlers[ I ] ) );
        {P}SL.Add( ' C2 TControl_.Set' + EventNames[ I ] + '<1>'
                   // похоже, что для всех процедур типа
                   // SetOnEvent( const event: TMethod )
                   // второй параметр передается через стек!
                   );
      end
        else
      begin
        {P}SL.Add( ' Load4 ####T' + (Owner as TForm).Name + '.' +
          (Owner as TForm).MethodName( EventHandlers[ I ] ) );
        {P}SL.Add( ' C1 AddWord_Store ##TControl_.f' + EventNames[ I ] );
        {P}SL.Add( ' LoadSELF C1 AddWord_Store ##(4+TControl_.f' +
          EventNames[ I ] + ')' );
      end;
    end;
  end;
  if CheckOnly then
    Result := FALSE;

  //LogOK;
  FINALLY
    //if Result and CheckOnly then LogOK;
    //Log( '<-TKOLApplet.P_DoAssignEvents' );
  END;
end;

procedure TKOLApplet.SetAllBtnReturnClick(const Value: Boolean);
begin
  Log( '->TKOLApplet.SetAllBtnReturnClick' );
  TRY
  FAllBtnReturnClick := Value;
  Change( Self );
  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetAllBtnReturnClick' );
  END;
end;


procedure TKOLApplet.SetCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetCaption' );
  TRY
    if fCaption <> Value then
    begin
      fCaption := Value;
      Change( Self );
    end;
    LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetCaption' );
  END;
end;

procedure TKOLApplet.SetEnabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetEnabled', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetEnabled' );
  TRY
  if fEnabled <> Value then
  begin
    fEnabled := Value;
    Change( Self );
  end;
  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetEnabled' );
  END;
end;

procedure TKOLApplet.SetForceIcon16x16(const Value: Boolean);
begin
  Log('->TKOLApplet.SetForceIcon16x16');
  TRY

  FForceIcon16x16 := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetForceIcon16x16' );
  END;
end;

procedure TKOLApplet.SetIcon(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetIcon' );
  TRY

  FIcon := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetIcon' );
  END;
end;

procedure TKOLApplet.SetOnClose(const Value: TOnEventAccept);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetOnClose', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetOnClose' );
  TRY

  FOnClose := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnClose' );
  END;
end;

procedure TKOLApplet.SetOnDestroy(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetOnDestroy', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetOnDestroy' );
  TRY

  FOnDestroy := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnDestroy' );
  END;
end;

procedure TKOLApplet.SetOnMessage(const Value: TOnMessage);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetOnMessage', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetOnMessage' );
  TRY

  FOnMessage := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnMessage' );
  END;
end;

procedure TKOLApplet.SetOnMinimize(const Value: TOnEvent);
begin
  Log( '->TKOLApplet.SetOnMinimize' );
  TRY

  FOnMinimize := Value;
  Change( Self );

  LogOK;
  FINALLY
    Log( '<-TKOLApplet.SetOnMinimize' );
  END;
end;

procedure TKOLApplet.SetOnQueryEndSession(const Value: TOnEventAccept);
begin
  Log( '->TKOLApplet.SetOnQueryEndSession' );
  try
  FOnQueryEndSession := Value;
  Change( Self );
  LogOK;
  finally
    Log( '<-TKOLApplet.SetOnQueryEndSession' );
  end;
end;

procedure TKOLApplet.SetOnRestore(const Value: TOnEvent);
begin
  Log( '->TKOLApplet.SetOnRestore' );
  try
  FOnRestore := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetOnRestore' );
  end;
end;

procedure TKOLApplet.SetTabulate(const Value: Boolean);
begin
  Log( '->TKOLApplet.SetTabulate' );
  try
  FTabulate := Value;
  if Value then
    FTabulateEx := False;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetTabulate' );
  end;
end;

procedure TKOLApplet.SetTabulateEx(const Value: Boolean);
begin
  Log( '->TKOLApplet.SetTabulateEx' );
  try
  FTabulateEx := Value;
  if Value then
    FTabulate := False;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetTabulateEx' );
  end;
end;

procedure TKOLApplet.SetTag(const Value: Integer);
begin
  Log( '->TKOLApplet.SetTag' );
  try
  FTag := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLApplet.SetTag' );
  end;
end;

procedure TKOLApplet.SetVisible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLApplet.SetVisible', 0
  @@e_signature:
  end;
  Log( '->TKOLApplet.SetVisible' );
  try
  if fVisible <> Value then
  begin
    fVisible := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLApplet.SetVisible' );
  end;
end;

{ TKOLForm }

procedure TKOLForm.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AssignEvents' );
  try
  if not FLocked then
  begin
    RptDetailed( 'Enter to TKOLForm.AssignEvents', WHITE );

    if  (Applet <> nil) and (Applet.Owner = Owner) then
        Applet.AssignEvents( SL, 'Applet' );
    //inherited;

    DefineFormEvents(
    // events marked with '^' can be set immediately following control creation:
    // in case of FormCompact = TRUE this gives smaller code since there are less
    // calls of FormSetCurCtl.
    // ---------------------------------------------------------------------------
    [ 'OnMessage: TControl.Set_OnMessage',
      'OnClose:^TControl.SetOnClose,' + IntToStr(idx_fOnMouseDown),
      'OnQueryEndSession:^TControl.SetOnQueryEndSession,' + IntToStr(idx_fOnMouseMove),

      'OnMinimize:^TControl.SetOnMinMaxRestore,0',
      'OnMaximize:^TControl.SetOnMinMaxRestore,8',
      'OnRestore:^TControl.SetOnMinMaxRestore,16',

      'OnFormClick:^TControl.SetFormOnClick',
      'OnMouseDblClk:^TControl.SetOnMouseEvent,' + IntToStr( idx_fOnMouseDblClk ),
      'OnMouseDown:^TControl.SetOnMouseEvent,' + IntToStr( idx_fOnMouseDown ),
      'OnMouseMove:^TControl.SetOnMouseEvent,' + IntToStr( idx_fOnMouseMove ),
      'OnMouseUp:^TControl.SetOnMouseEvent,' + IntToStr( idx_fOnMouseUp ),
      'OnMouseWheel:^TControl.SetOnMouseEvent,' + IntToStr( idx_fOnMouseWheel ),
      'OnMouseEnter:^TControl.SetOnMouseEnter',
      'OnMouseLeave:^TControl.SetOnMouseLeave',

      'OnEnter:^TControl.Set_TOnEvent,' + IntToStr( idx_fOnEnter ),
      'OnLeave:^TControl.Set_TOnEvent,' + IntToStr( idx_fOnLeave ),
      'OnKeyDown:^TControl.SetOnKeyDown',
      'OnKeyUp:^TControl.SetOnKeyUp',
      'OnKeyChar:^TControl.SetOnKeyChar',
      'OnResize:^TControl.SetOnResize',
      'OnMove:^TControl.SetOnMove',
      'OnMoving:^TControl.SetOnMoving',
      'OnShow:^TControl.SetOnShow',
      'OnHide:^TControl.SetOnHide',

      'OnPaint:^TControl.SetOnPaint',
      'OnEraseBkgnd:^TControl.SetOnEraseBkgnd',
      'OnDropFiles:^TControl.SetOnDropFiles'
    ] );

    DoAssignEvents( SL, AName, [ 'OnMessage', 'OnClose', 'OnQueryEndSession' ],
                               [ @OnMessage, @ OnClose, @ OnQueryEndSession  ] );
    DoAssignEvents( SL, AName, [ 'OnMinimize', 'OnMaximize', 'OnRestore' ],
                               [ @ OnMinimize, @ OnMaximize, @ OnRestore  ] );
    DoAssignEvents( SL, AName,
    [ 'OnFormClick', 'OnMouseDblClk', 'OnMouseDown', 'OnMouseMove', 'OnMouseUp', 'OnMouseWheel', 'OnMouseEnter', 'OnMouseLeave' ],
    [ @OnClick,  @ OnMouseDblClk, @OnMouseDown,  @OnMouseMove,  @OnMouseUp,  @OnMouseWheel,  @OnMouseEnter,  @OnMouseLeave  ] );
    DoAssignEvents( SL, AName,
    [ 'OnEnter', 'OnLeave', 'OnKeyDown', 'OnKeyUp', 'OnKeyChar', 'OnResize', 'OnMove', 'OnMoving', 'OnShow', 'OnHide' ],
    [ @OnEnter,  @OnLeave,  @OnKeyDown,  @OnKeyUp,  @OnKeyChar,   @OnResize, @ OnMove, @ OnMoving, @ OnShow, @ OnHide ] );
    DoAssignEvents( SL, AName,
    [ 'OnPaint', 'OnEraseBkgnd', 'OnDropFiles' ],
    [ @ OnPaint, @ OnEraseBkgnd, @ OnDropFiles ] );
    // This event must be called at last! (and not assigned!) - so do this in SetupLast method.
    {DoAssignEvents( SL, AName,
    [ 'OnFormCreate' ],
    [ @ OnFormCreate ] );}

    DoAssignEvents( SL, AName,
    [ 'OnDestroy', 'OnHelp' ],
    [ @ OnDestroy, @ OnHelp ] );
    {if Assigned( OnDestroy ) then
      SL.Add( '      ' + AName + '.OnDestroy := Result.' +
              (Owner as TForm).MethodName( OnFormDestroy ) + ';' );}
    RptDetailed( 'Leave TKOLForm.AssignEvents', WHITE );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.AssignEvents' );
  end;
end;

procedure TKOLForm.Change(Sender: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Change', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Change' );
  try
  if Sender=nil then
  begin
    RptDetailed( 'Sender = nil!', YELLOW );
  end
  else
    RptDetailed( 'Sender class=' + Sender.ClassName + ' name=' + Sender.Name, YELLOW );
  try
    Rpt_Stack;
  except on E: exception do
    RptDetailed( 'exception while reporting stack: ' + E.Message, YELLOW );
  end;

  if not FLocked and not ( csLoading in ComponentState ) and not FIsDestroying and
     (Owner <> nil) and not(csDestroying in Owner.ComponentState) then
  begin
    //if Creating_DoNotGenerateCode then Exit;
    if AllowRealign then
    if FRealigning = 0 then
    if FRealignTimer <> nil then
    begin
      FRealignTimer.Enabled := FALSE;
      FRealignTimer.Enabled := TRUE;
    end;
    if FChangeTimer <> nil then
    begin
      FChangeTimer.Enabled := FALSE;
      FChangeTimer.Enabled := TRUE;
    end
      else
    if not (csLoading in Sender.ComponentState) then
      DoChangeNow;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.Change' );
  end;
end;

constructor TKOLForm.Create(AOwner: TComponent);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Create' );
  fCreating := TRUE;
  try

  Log( '?01 TKOLForm.Create' );

  FFontDefault := TRUE;
  TRY
      FFont := TKOLFont.Create(Self);
  EXCEPT
      ShowMessage( 'exc create 1' );
  END;
  if KOLProject <> nil then
  begin
    if KOLProject.ProjectDest = '' then
    begin
      raise Exception.Create( 'You forget to change projectDest property ' +
            'of TKOLProject component!' );
    end;
    if KOLProject.DefaultFont <> nil then
    TRY
        FFont.Assign(KOLProject.DefaultFont);
    EXCEPT
        ShowMessage( 'exc create 2' );
    END;
  end;

  Log( '?02 TKOLForm.Create' );
  inherited;

  Log( '?03 TKOLForm.Create' );

  //Creating_DoNotGenerateCode := TRUE;
  AllowRealign := TRUE;

  Log( '?03.A TKOLForm.Create' );

  FStatusText := TStringList.Create;

  Log( '?03.B TKOLForm.Create' );

  FStatusSizeGrip := TRUE;

  Log( '?03.C TKOLForm.Create' );

  FParentLikeFontControls := TList.Create;

  Log( '?03.D TKOLForm.Create' );

  FParentLikeColorControls := TList.Create;
  //fDefaultPos := True;
  //fDefaultSize := True;

  Log( '?03.E TKOLForm.Create' );

  fCanResize := True;

  Log( '?03.F TKOLForm.Create' );

  fVisible := True;

  Log( '?03.G TKOLForm.Create' );

  fAlphaBlend := 255;

  Log( '?03.H TKOLForm.Create' );

  fEnabled := True;

  Log( '?03.I TKOLForm.Create' );

  fMinimizeIcon := True;

  Log( '?03.J TKOLForm.Create' );

  fMaximizeIcon := True;

  Log( '?03.K TKOLForm.Create' );

  fCloseIcon := True;

  Log( '?03.L TKOLForm.Create' );

  FborderStyle := fbsSingle; {YS}

  Log( '?03.M TKOLForm.Create' );

  fHasBorder := True;

  Log( '?03.N TKOLForm.Create' );

  fHasCaption := True;

  Log( '?03.o TKOLForm.Create' );

  fCtl3D := True;

  Log( '?03.P TKOLForm.Create' );

  //AutoCreate := True;
  fMargin := 2;

  Log( '?03.Q TKOLForm.Create' );

  fBounds := TFormBounds.Create;

  Log( '?03.R TKOLForm.Create' );

  fBounds.Owner := Self;
  {fBounds.fL := (Owner as TForm).Left;
  fBounds.fT := (Owner as TForm).Top;
  fBounds.fW := (Owner as TForm).Width;
  fBounds.fH := (Owner as TForm).Height;}
  //fBrush := TBrush.Create;

  Log( '?04 TKOLForm.Create' );
  //fFont := TKOLFont.Create( Self );
  fBrush := TKOLBrush.Create( Self );

  Log( '?05 TKOLForm.Create' );

  if AOwner <> nil then
  begin
    Log( '?06 TKOLForm.Create' );
    for I := 0 to AOwner.ComponentCount - 1 do
    begin
      C := AOwner.Components[ I ];
      if C = Self then Continue;
      if IsVCLControl( C ) then
      begin
        FLocked := TRUE;
        ShowMessage( 'The form ' + FormName + ' contains already VCL controls.'#13 +
        'The TKOLForm component is locked now and will not functioning.'#13 +
        'Just delete it and never drop onto forms, beloning to VCL projects.' );
        break;
      end;
    end;
    Log( '?07 TKOLForm.Create' );
    if not FLocked then
    for I := 0 to AOwner.ComponentCount - 1 do
    begin
      C := AOwner.Components[ I ];
      if C = Self then Continue;
      if C is TKOLForm then
      begin
        ShowMessage( 'The form ' + FormName + ' contains more then one instance of ' +
                     'TKOLForm component. '#13 +
                     'This will cause unpredictable results. It is recommended to ' +
                     'remove all ambigous instances of TKOLForm component before ' +
                     'You launch the project.' );
        break;
      end;
    end;
    Log( '?08 TKOLForm.Create' );
  end;
  if FormsList = nil then
    FormsList := TList.Create;
  Log( '?09 TKOLForm.Create' );
  FormsList.Add( Self );
  if not (csLoading in ComponentState) then
    if Caption = '' then
      Caption := FormName;
  Log( '?10 TKOLForm.Create' );
  (Owner as TForm).Scaled := FALSE;
  (Owner as TForm).HorzScrollBar.Visible := FALSE;
  (Owner as TForm).VertScrollBar.Visible := FALSE;
  Log( '?11 TKOLForm.Create' );
  FRealignTimer := TTimer.Create( Self );
  FRealignTimer.Interval := 50;
  FRealignTimer.OnTimer := RealignTimerTick;
  Log( '?12 TKOLForm.Create' );
  FChangeTimer := TTimer.Create( Self );
  FChangeTimer.OnTimer := ChangeTimerTick;
  FChangeTimer.Enabled := FALSE;
  FChangeTimer.Interval := 100;
  Log( '?13 TKOLForm.Create' );
  if not (csLoading in ComponentState) then
    FRealignTimer.Enabled := TRUE;
  fAssignTextToControls := TRUE;
  Log( '?14 TKOLForm.Create' );
  LogOK;
  finally
  Log( '<-TKOLForm.Create' );
  //Creating_DoNotGenerateCode := FALSE;
  FChanged := FALSE;
  fCreating := FALSE;
  end;
end;

destructor TKOLForm.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Destroy', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Destroy' );
  FIsDestroying := TRUE;
  try
  if bounds <> nil then
    bounds.EnableTimer( FALSE );
  AllowRealign := FALSE;
  fBounds.Free;
  if FormsList <> nil then
  begin
    I := FormsList.IndexOf( Self );
    if I >= 0 then
    begin
      FormsList.Delete( I );
      if FormsList.Count = 0 then
      begin
        FormsList.Free;
        FormsList := nil;
      end;
    end;
  end;
  fFont.Free;
  FParentLikeFontControls.Free;
  FParentLikeColorControls.Free;
  FStatusText.Free;
  ResStrings.Free;
  FreeAndNil( FFormAlphabet );
  FreeAndNil( FFormCtlParams );
  inherited;
  LogOK;
  finally
  Log( '<-TKOLForm.Destroy' );
  end;
end;

procedure SwapItems( Data: Pointer; const e1, e2: DWORD );
var Tmp: Pointer;
    L: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SwapItems', 0
  @@e_signature:
  end;
  L := Data;
  Tmp := L.Items[ e1 ];
  L.Items[ e1 ] := L.Items[ e2 ];
  L.Items[ e2 ] := Tmp;
  //Rpt( IntToStr( e1 ) + '<-->' + IntToStr( e2 ) );
end;

function CompareControls( Data: Pointer; const e1, e2: DWORD ): Integer;
const Signs: array[ -1..1 ] of AnsiChar = ( '<', '=', '>' );
var K1, K2: TKOLCustomControl;
    L: TList;
    function CompareInt( X, Y: Integer ): Integer;
    begin
      if X < Y then Result := -1
      else
      if X > Y then Result := 1
      else
      Result := 0;
    end;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CompareControls', 0
  @@e_signature:
  end;
  L := Data;
  K1 := L.Items[ e1 ];
  K2 := L.Items[ e2 ];
  Result := 0;
  if K1.Align = K2.Align then
  case K1.Align of
  caLeft: Result := CompareInt( K1.Left, K2.Left );
  caTop:  Result := CompareInt( K1.Top, K2.Top );
  caRight:Result := CompareInt( K2.Left, K1.Left );
  caBottom: Result := CompareInt( K2.Top, K1.Top );
  caClient: Result := CompareInt( K1.ControlIndex,
                                  K1.ControlIndex );
  end;
  if Result = 0 then
    Result := CompareInt( K1.TabOrder, K2.TabOrder );
  if Result = 0 then
    Result := AnsiCompareStr( K1.Name, K2.Name );
  //Rpt( 'Compare ' + K1.Name + '.' + IntToStr( K1.TabOrder ) + ' ' + Signs[ Result ] + ' ' +
  //                  K2.Name + '.' + IntToStr( K2.TabOrder ) );
end;

const
{$IFDEF VER90}
  {$DEFINE offDefined}
  offCreate = $24;
{$ENDIF}
{$IFDEF VER100}
  {$DEFINE offDefined}
  offCreate = $24;
{$ENDIF}
{$IFNDEF offDefined}
  offCreate = $2C;
{$ENDIF}

// Данная функция конструирует и возвращает компонент того же класса, что
// и компонент, переданный в качестве параметра. Для конструирования вызывается
// виртуальный коструктор компонента (смещение точки входа в vmt зависит от
// версии Delphi).
function ComponentLike( C: TComponent ): TComponent;
asm
  xor ecx, ecx
  mov dl,1
  mov eax, [eax]
  call dword ptr [eax+offCreate]
end;

function Comma2Pt( const S: String ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Comma2Pt', 0
  @@e_signature:
  end;
  Result := S;
  while pos( ',', Result ) > 0 do
    Result[ pos( ',', Result ) ] := '.';
end;

function Bool2Str( const S: String ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Bool2Str', 0
  @@e_signature:
  end;
  if S = '0' then Result := 'FALSE'
  else            Result := 'TRUE';
end;

{$IFDEF _D2}
function GetEnumProp(Instance: TObject; PropInfo: PPropInfo): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetEnumProp', 0
  @@e_signature:
  end;
  Result := GetEnumName(PropInfo^.PropType, GetOrdProp(Instance, PropInfo));
end;
{$ENDIF}
{$IFDEF _D3orD4}
function GetEnumProp(Instance: TObject; PropInfo: PPropInfo): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetEnumProp', 0
  @@e_signature:
  end;
  Result := GetEnumName(PropInfo^.PropType^, GetOrdProp(Instance, PropInfo));
end;
{$ENDIF}

{$IFDEF _D2}
type
  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;

function GetSetProp(Instance: TObject; PropInfo: PPropInfo;
  Brackets: Boolean): string;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetSetProp', 0
  @@e_signature:
  end;
  Integer(S) := GetOrdProp(Instance, PropInfo);
  TypeInfo := GetTypeData(PropInfo.PropType).CompType;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;
{$ENDIF}
{$IFDEF _D3orD4}
type
  TIntegerSet = set of 0..SizeOf(Integer) * 8 - 1;

function GetSetProp(Instance: TObject; PropInfo: PPropInfo;
  Brackets: Boolean): string;
var
  S: TIntegerSet;
  TypeInfo: PTypeInfo;
  I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'GetSetProp', 0
  @@e_signature:
  end;
  Integer(S) := GetOrdProp(Instance, PropInfo);
  TypeInfo := GetTypeData(PropInfo.PropType^).CompType^;
  for I := 0 to SizeOf(Integer) * 8 - 1 do
    if I in S then
    begin
      if Result <> '' then
        Result := Result + ',';
      Result := Result + GetEnumName(TypeInfo, I);
    end;
  if Brackets then
    Result := '[' + Result + ']';
end;
{$ENDIF}

// Данная функция возвращает значение публикуемого свойства компонента в виде
// строки, которую можно вставить в текст программы в правую часть присваивания
// значения этому свойству.
function PropValueAsStr( C: TComponent; const PropName: String; PI: PPropInfo; SL: TStringList ): String;

  function StringConstant( const Propname, Value: String ): String;
  begin
    if C is TKOLForm then
      Result := (C as TKOLForm).StringConstant( Propname, Value )
    else if C is TKOLObj then
      Result := (C as TKOLObj).StringConstant( Propname, Value )
    else if C is TKOLCustomControl then
      Result := (C as TKOLCustomControl).StringConstant( Propname, Value )
    else
      Result := String2Pascal( Value, '+' );
  end;

var PropValue: String;
    V: Variant;
    Method: TMethod;
    Ch: AnsiChar;
    Wc: WChar;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'PropValueAsStr', 0
  @@e_signature:
  end;
  PropValue := '';
  Result := '';
  case PI.PropType^.Kind of
    tkVariant:
    begin
    try
      V := //GetPropValue( C, PropName, TRUE );
           GetVariantProp( C, PI );
      case VarType( V ) of
      varEmpty:     PropValue := 'UnAssigned';
      varNull:      PropValue := 'NULL';
      varSmallInt:  PropValue := 'VarAsType( ' + VarToStr( V ) + ', varSmallInt )';
      varInteger:   PropValue := IntToStr( V.AsInteger );
      varSingle:    PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( V ) ) + ', varSingle )';
      varDouble:    PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( V ) ) + ', varDouble )';
      varCurrency:  PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( V ) ) + ', varCurrency )';
      varDate:      PropValue := 'VarAsType( ' + Comma2Pt( VarToStr( VarAsType( V, varDouble ) ) ) + ', varDate )';
      varByte:      PropValue := 'VarAsByte( ' + VarToStr( V ) + ' )';
      //varOLEStr:    PropValue := 'VarAsType( ' + String2Pascal( VarToStr( V ) ) + ', varOLEStr )';
      varOLEStr:    PropValue := 'VarAsType( ' + PCharStringConstant( C, Propname, VarToStr( V ) ) + ', varOLEStr )';
      //varString:    PropValue := String2Pascal( VarToStr( V ) );
      varString:    PropValue := StringConstant( Propname, VarToStr( V ) );
      varBoolean:   PropValue := Bool2Str( VarToStr( V ) );
      else
                   begin
       SL.Add( '    //----!!!---- Can not assign variant property ----!!!----' );
       Exit;
                   end;
      end;
    except
     SL.Add( '    //-----^----- Error getting variant value' )
    end;
    end;
    tkString, tkLString,
    {$IFDEF _D2} tkLWString {$ELSE} tkWString {$ENDIF}:
     try
       //PropValue := String2Pascal( GetStrProp( C,
       PropValue := StringConstant( Propname, GetStrProp( C,
                    {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
     except
       PropValue := '';
       SL.Add( '    //----^---- Cannot obtain string property ' + PropName +
               '. May be, it is write-only.' );
       raise;
     end;
    tkChar:
     begin
       Ch := AnsiChar( GetOrdProp( C, {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
       if Ch in [ ' '..#127 ] then
         PropValue := '''' + Ch + ''''
       else
         PropValue := '#' + IntToStr( Ord( Ch ) );
     end;
    tkWChar:
     begin
       Wc := WChar( GetOrdProp( C, {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
       if  (Wc >= WChar(' ')) and (Wc <= WChar(#127)) then
           PropValue := '''' + AnsiChar( Wc ) + ''''
       else
           PropValue := 'WChar( ' + IntToStr( Ord( Wc ) ) + ' )';
     end;
    tkMethod:
    begin
      Method := GetMethodProp( C, {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} );
      if not Assigned( Method.Code ) then
        Exit;
      if C.Owner <> nil then
      if C.Owner is TForm then
        PropValue := 'Result.' + C.Owner.MethodName( Method.Code );
    end;
    tkInteger:     PropValue := IntToStr( GetOrdProp( C,
                                {$IFDEF _D2orD3orD4} PI {$ELSE} PropName {$ENDIF} ) );
    tkEnumeration: PropValue := GetEnumProp( C, PI );
    tkFloat:       begin
                    S := FloatToStr( GetFloatProp( C, PI ) );
                    while pos( ',', S ) > 0 do
                      S[ pos( ',', S ) ] := '.';
                    PropValue := S;
                  end;
    tkSet:         PropValue := GetSetProp( C, PI, TRUE );
    {$IFNDEF _D2orD3}
    tkInt64:       PropValue := IntToStr( GetInt64Prop( C, PI ) );
    {$ENDIF}
    tkUnknown: begin
                SL.Add( '    //-----?----- property type tkUnknown' );
                Exit;
              end;
    else      Exit;
  end;
  Result := PropValue;
end;

// Конструирование кода для компонента, унаследованного от TComponent.
// Вообще-то, в KOL-MCK-проектах желательно использовать только компоненты,
// специально разработанные для MCK. Но если компонент слабо связан с VCL и
// не тянет на себя много дополнительного кода, использование его в проектах
// KOL вполне возможно. А иногда желательно.
// Здесь генерируется код, конструирующий такой компонент, созданный и
// настроенный в design-time на форме MCK-проекта. Устанавливаются все публичные
// свойства, отличающиеся своим значением от тех, которые назначаются по умолчанию
// в конструкторе объекта.
procedure ConstructComponent( SL: TStringList; C: TComponent );
var Props, PropsD: PPropList;
    NProps, NPropsD, I, J: Integer;
    PropName, PropValue, PropValueD: String;
    PI, DPI: PPropInfo;
    D: TComponent;
    WasError: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ConstructComponent', 0
  @@e_signature:
  end;
  //SL.Add( '    Result.' + C.Name + ' := ' + C.ClassName + '.Create( nil );' );
  if C is TOleControl then
    SL.Add( '    Result.' + C.Name +
            '.ParentWindow := Result.Form.GetWindowHandle;' );
  D := nil;
  GetMem( Props, Sizeof( TPropList ) );
  GetMem( PropsD, Sizeof( TPropList ) );
  try
  try
    NProps := GetPropList( C.ClassInfo, tkAny, Props );
    SL.Add( '    //-- found ' + IntToStr( NProps ) + ' published props' );
    if NProps > 0 then
    BEGIN
      D := ComponentLike( C );
      NPropsD :=  GetPropList( C.ClassInfo, tkAny, PropsD );
      for I := 0 to NProps-1 do
      begin
         PI := Props[ I ];
         PropName := String( PI.Name );
         DPI := nil;
         for J := 0 to NPropsD-1 do
         begin
           DPI := PropsD[ J ];
           if PropName = String( DPI.Name ) then break;
           DPI := nil;
         end;

         SL.Add( '    // ' + IntToStr( I ) + ': ' + PropName );
         //if not IsStoredProp( C, PropName ) then continue;
         PropValueD := '';
         WasError := FALSE;
         try
           if DPI <> nil then
           if DPI.PropType^.Kind = PI.PropType^.Kind then
             PropValueD := PropValueAsStr( D, PropName, DPI, SL );
           PropValue := PropValueAsStr( C, PropName, PI, SL );
           if (DPI = nil) or (PropValue <> PropValueD) then
           SL.Add( '    Result.' + C.Name + '.' + PropName + ' := ' +
                   PropValue + ';' );
         except
           WasError := TRUE;
         end;
         if WasError then
         try
           if DPI <> nil then
           if DPI.PropType^.Kind = PI.PropType^.Kind then
           begin
             PropValueD := PropValueAsStr( D, PropName, DPI, SL );
             SL.Add( '    //Default: ' + PropName + '=' + PropValueD );
           end;
           PropValue := PropValueAsStr( C, PropName, PI, SL );
           SL.Add(   '    //Actual : ' + PropName + '=' + PropValue );
           if (DPI = nil) or (PropValue <> PropValueD) then
           SL.Add( '    Result.' + C.Name + '.' + PropName + ' := ' +
                   PropValue + ';' );
         except
           SL.Add( '    //-----^------Exception while getting propery ' +
                   PropName + ' of ' + C.Name );
         end;
      end;
    END;
  finally
    FreeMem( Props );
    D.Free;
  end;
  except
    SL.Add( '    //-----^------Exception while getting properties of ' + C.Name );
  end;
end;

procedure TKOLForm.GenerateChildren( SL: TStringList; OfParent: TComponent; const OfParentName: String; const Prefix: String;
          var Updated: Boolean );
var I, J: Integer;
    L: TList;
    S: String;
    KC: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateChildren' );
  try
  L := TList.Create;
  try
    for I := 0 to Owner.ComponentCount - 1 do
    begin
      if Owner.Components[ I ] is TKOLCustomControl then
      if (Owner.Components[ I ] as TKOLCustomControl).ParentKOLControl = OfParent then
      begin
        KC := Owner.Components[ I ] as TKOLCustomControl;
        L.Add( KC );
      end;
    end;
    SortData( L, L.Count, @CompareControls, @SwapItems );
    for I := 0 to L.Count - 1 do
    begin
      KC := L.Items[ I ];
      KC.fUpdated := FALSE;
      KC.FNameSetuped := FALSE;
    end;
    for I := 0 to L.Count - 1 do
    begin
      KC := L.Items[ I ];
      RptDetailed( 'generating code for ' + KC.Name, WHITE );
      //SL.Add( '    // ' + KC.RefName + '.TabOrder = ' + IntToStr( KC.TabOrder ) );
      // обеспечить правильный родительский контрол, если он изменился
      if  FormCompact then
      begin
          if  KC.Parent is TCustomForm then
          begin
              if  (FormCurrentParentCtl <> nil) and
                  ((FormCurrentParentCtl.Parent <> nil)
                   and not (FormCurrentParentCtl.Parent is TCustomForm))
              or  FormFlushedCompact then
              begin
                  FormAddCtlCommand( '', 'FormSetCurCtl', '' );
                  FormAddNumParameter( 0 );
                  FormAddCtlCommand( '', 'FormLastCreatedChildAsNewCurrentParent', '' );
                  FormCurrentParentCtl := nil;
                  FormCurrentParent := '';
              end else
              begin
                  RptDetailed( 'searching parent form to set as FormCurrentParent', WHITE );
                  while FormCurrentParentCtl <> nil do
                  begin
                      FormAddCtlCommand( '', 'FormSetUpperParent', '' );
                      if  (FormCurrentParentCtl.Parent is TCustomForm) then
                      begin
                          FormCurrentParentCtl := nil;
                          FormCurrentParent := '';
                      end
                        else
                      begin
                          FormCurrentParentCtl := (FormCurrentParentCtl.Parent as TKOLControl);
                          FormCurrentParent := FormCurrentParentCtl.Name;
                      end;
                  end;
              end;
          end else
          if  (KC.Parent is TKOLTabPage) and (KC.Parent.Parent is TKOLTabControl) then
          begin
              if  FormCurrentParent <> KC.Parent.Name then
              begin
                  RptDetailed( 'searching parent tab page to set as FormCurrentParent', WHITE );
                  RptDetailed( 'Current parent name: ' + FormCurrentParent +
                       ', wanted: ' + KC.Parent.Name, WHITE );
                  if  FormCurrentCtlForTransparentCalls <> KC.Parent.Parent.Name then
                  begin
                      RptDetailed( 'setting up ' + KC.Parent.Parent.Name +
                          ' as current control', WHITE );
                      FormAddCtlCommand( '', 'FormSetCurCtl', '' );
                      FormAddNumParameter( FormIndexOfControl( KC.Parent.Parent.Name ) );
                      FormCurrentCtlForTransparentCalls := KC.Parent.Parent.Name;
                      RptDetailed( 'successfully set up ' + KC.Parent.Parent.Name +
                          ' as current control', WHITE );
                  end;
                  FormAddCtlCommand( '', 'FormSetTabpageAsParent', '' );
                  J := (KC.Parent.Parent as TKOLTabControl).IndexOfPage(
                       KC.Parent.Name );
                  FormAddNumParameter( J );
                  FormCurrentParent := KC.Parent.Name;
                  FormCurrentParentCtl := KC.Parent as TKOLCustomControl;
              end;
          end else
          if  (KC.Parent <> FormCurrentParentCtl) or FormFlushedCompact then
          begin
              RptDetailed( 'searching parent control to set as FormCurrentParent', WHITE );
              RptDetailed( KC.Parent.Name, WHITE );
              if  FormFlushedCompact then
              begin
                  FormAddCtlCommand( '', 'FormSetCurCtl', '' );
                  FormAddNumParameter( FormIndexOfControl( KC.Parent.Name ) );
                  FormAddCtlCommand( '', 'FormLastCreatedChildAsNewCurrentParent', '' );
                  FormCurrentParentCtl := KC.Parent as TKOLCustomControl;
                  FormCurrentParent := KC.Parent.Name;
              end else
              while (KC.Parent <> FormCurrentParentCtl) and
                    (FormCurrentParentCtl <> nil) do
              begin
                  FormAddCtlCommand( '', 'FormSetUpperParent', '' );
                  if  (FormCurrentParentCtl.Parent is TCustomForm) then
                  begin
                      FormCurrentParentCtl := nil;
                      FormCurrentParent := '';
                  end
                    else
                  begin
                      FormCurrentParentCtl := (FormCurrentParentCtl.Parent as TKOLControl);
                      FormCurrentParent := FormCurrentParentCtl.Name;
                  end;
              end;
          end;
      end;
      if  OfParent is TKOLCustomControl then
          KC.fCreationOrder := (OfParent as TKOLCustomControl).fOrderChild
      else
          KC.fCreationOrder := fOrderControl;
      KC.SetupFirst( SL, KC.RefName, OfParentName, Prefix );
      if  KC.TabStop then
      begin
          if  OfParent is TKOLCustomControl then
              inc( (OfParent as TKOLCustomControl).fOrderChild )
          else
              inc( fOrderControl );
      end;
      KC.SetupName( SL, KC.RefName, OfParentName, Prefix ); // на случай, если
        // SetupFirst переопределена, и SetupName не вызвана
      if  FormCompact then
      begin
          KC.FAssignOnlyUserEvents := TRUE;
          KC.AssignEvents( SL, KC.RefName );
          KC.FAssignOnlyUserEvents := FALSE;
      end;
      if  FormCompact and KC.SupportsFormCompact then
          //--//
      else
          GenerateAdd2AutoFree( SL, KC.RefName, TRUE, '', KC );
      S := KC.RefName;
      if  (KC.ControlCount > 0) then
      begin
          if  FormCompact then
          begin
              if  not (KC is TKOLTabPage)
              and not (KC is TKOLTabControl) then
              begin
                  FormAddAlphabet( 'FormLastCreatedChildAsNewCurrentParent', FALSE, TRUE, '' );
                  FormCurrentParent := KC.Name;
                  FormCurrentParentCtl := KC;
              end;
          end;
          GenerateChildren( SL, KC, S, Prefix + '  ', Updated );
          RptDetailed( 'children generated for ' + KC.Name, WHITE );
      end;
      if  KC.fUpdated then
      begin
          Updated := TRUE;
          Rpt( 'updated TKOLForm', WHITE );
      end;
    end;
  finally
    L.Free;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateChildren' );
  end;
end;

function TKOLForm.AppletOnForm: Boolean;
var I: Integer;
    F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AppletOnForm', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AppletOnForm' );
  try
  Result := FALSE;
  if Owner <> nil then
  begin
    F := Owner as TForm;
    for I := 0 to F.ComponentCount - 1 do
      if F.Components[ I ].ClassNameIs( 'TKOLApplet' ) then
      begin
        Result := TRUE;
        break;
      end;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.AppletOnForm' );
  end;
end;

function CompareComponentOrder( const AList : Pointer; const e1, e2 : DWORD ) : Integer;
var OC: TList;
    C1, C2: TComponent;
    S: String;
    B: Boolean;
    K1, K2: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CompareComponentOrder', 0
  @@e_signature:
  end;
  OC := AList;
  C1 := OC[ e1 ];
  C2 := OC[ e2 ];
  Result := 0;
  if (C1 is TKOLObj) and (C2 is TKOLObj) then
  begin
    if (C1 as TKOLObj).CreationPriority <> (C2 as TKOLObj).CreationPriority then
      Result := CmpInts( (C1 as TKOLObj).CreationPriority,
                         (C2 as TKOLObj).CreationPriority );
  end;
  if Result = 0 then
  if ((C1 is TKOLObj) or (C1 is TKOLCustomControl)) and
     ((C2 is TKOLObj) or (C2 is TKOLCustomControl)) then
  begin
    if C2 is TKOLObj then
      S := (C2 as TKOLObj).TypeName
    else
      S := (C2 as TKOLCustomControl).TypeName;
    if C1 is TKOLObj then
      B := (C1 as TKOLObj).CompareFirst( S, C2.Name )
    else
      B := (C1 as TKOLCustomControl).CompareFirst( S, C2.Name );
    if B then Result := 1;
  end;
  if Result = 0 then
  begin
    if (C1 is TKOLCustomControl) and (C2 is TKOLCustomControl) then
    begin
      K1 := C1 as TKOLCustomControl;
      K2 := C2 as TKOLCustomControl;
      Result := CmpInts( K1.TabOrder, K2.TabOrder );
      if Result = 0 then
      begin
        if (K1.Align in [caLeft, caRight]) and (K2.Align in [caLeft, caRight]) then
          Result := CmpInts( K1.Left, K2.Left )
        else
        if (K1.Align in [caTop, caBottom]) and (K2.Align in [caTop, caBottom]) then
          Result := CmpInts( K1.Top, K2.Top );
      end;
      if Result = 0 then
        Result := AnsiCompareStr( K1.Name, K2.Name );
    end;
  end;
end;

procedure SwapComponents( const AList : Pointer; const e1, e2 : DWORD );
var OC: TList;
    Tmp: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SwapComponents', 0
  @@e_signature:
  end;
  OC := AList;
  Tmp := OC[ e1 ];
  OC[ e1 ] := OC[ e2 ];
  OC[ e2 ] := Tmp;
end;

  // В результирующем проекте:
  // Тип TMyForm - содержит обработчики событий формы и ее объектов,
  // а так же описания дочерних визуальных и невизуальных объектов.
  // (MyForm заменяется настоящим именем формы). Фактически не является
  // формой, как это происходит в VCL, где каждая визуально разрабатываемая
  // форма становится наследником от TForm. Нам просто удобно здесь
  // сделать так, потому, что появляется возможность вписывать код
  // прямо в зеркальный VCL-проект, и при этом объекты формы имеют ту же
  // область видимости в результирующем KOL-проекте. Более того, нет нужды
  // анализировать синтаксис Паскаля - достаточно скопировать исходный
  // модуль начиная со слова 'implementation' и добавить к нему только
  // пару генерируемых процедур.
  //
  // Как минимум, в нем содержится указатель на саму форму, имеющий
  // имя Form. Здесь мы выставим требование: так как в KOL переменная
  // Self будет недоступна (и будет означать указатель вот этого псевдо-
  // объекта, который сейчас описывается), то при написании кода
  // (в обработчиках событий) требуется явно указывать слово Form.
  // При таком подходе код сможет быть скомпилирован в обеих средах
  // (хотя это и будет разный код).
function TKOLForm.GenerateINC(const Path: String; var Updated: Boolean): Boolean;
  function RemoveExt( const s: String ): String;
  begin
    result := ExtractFilePath( s ) + ExtractFileNameWOExt( s );
  end;

var SL: TFormStringList;
    I, i1, i2: Integer;
var
    MainMenuPresent: boolean;
    PopupMenuPresent: boolean;
    KO: TKOLObj;
    KC: TKOLCustomControl;
    KM: TComponent;
    NeedOleInit: Boolean;

    //-- by Alexander Shakhaylo
    OC: TList;
    //--------------------------

    Generate_Pcode: Boolean;
    s: String;
    J, K: Integer;
    ch: String;
    FA: TStringList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateINC', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateINC' );
  try
  Result := FALSE;
  Updated := FALSE;
  if csLoading in ComponentState then
  begin // не будем пытаться генерировать код, пока форма не загрузилась в дизайнер!
    LogOK; Exit;
  end;

  Rpt( 'Generating INC for ' + Path, WHITE ); //Rpt_Stack;

  ResStrings.Free;
  ResStrings := nil;

  if KOLProject <> nil
    then Generate_Pcode := KOLProject.GeneratePCode
    else Generate_Pcode := FALSE;

  Rpt( 'Start generate INC for ' + Path, WHITE );
  //-- by Alexander Shakhaylo
  oc := TList.Create;
  TRY

    for i := 0 to Owner.ComponentCount - 1 do
    begin
      if csLoading in Owner.Components[ i ].ComponentState then
      begin
        LogOK; Exit;
      end;
      oc.Add(Owner.Components[ i ]);
    end;
    Rpt( 'End generating components', WHITE );

    SortData( oc, oc.Count, @CompareComponentOrder, @SwapComponents );
    //OutSortedListOfComponents( UnitSourcePath + FormName, oc, 2 );

    if Generate_Pcode then
    for i := 0 to oc.Count - 1 do
    begin
      km := oc[ i ];
      if km is TKOLObj then
        Generate_Pcode := (km as TKOLObj).Pcode_Generate
      else
      if km is TKOLCustomControl then
        Generate_Pcode := (km as TKOLCustomControl).Pcode_Generate
      else
      if km is TKOLApplet then
        Generate_Pcode := (km as TKOLApplet).Pcode_Generate
      else
      if km is TKOLProject then
      else
      begin
        Generate_Pcode := FALSE;
        Rpt( 'Found that component ' + km.Name +
             ' is not support Pcode, so Pcode will not be generated', YELLOW );
      end;
    end;

  //--------------------------

    SL := TFormStringList.Create;
    SL.OnAdd := DoFlushFormCompact;
    Result := False;
    TRY

      if FLocked then
      begin
        Rpt( 'Form ' + Name + ' is LOCKED.', YELLOW );
        LogOK; Exit;
      end;

      try

        // Step 3. Generate <FormUnit_1.inc>, containing constructor of
        // form holder object.
        //
        Rpt( 'add signature', WHITE );
        SL.Add( Signature );
        if Generate_Pcode then
        begin
          {P}SL.Add( 'const Sizeof_T' + FormName + ' = Sizeof(T' + FormName + ');' );
          {P}SL.Add( 'type TControl_ = object( TControl ) end;' );
          {P}SL.Add( 'type TObj_ = object( TObj ) end;' );
          {P}SL.Add( 'type _TObj_ = object( _TObj ) end;' );
        end;

        // Generating constants for menu items, toolbar buttons, list view columns, etc.
        for I := 0 to oc.Count - 1 do
        begin
          if TComponent( oc[ I ] ) is TKOLObj then
            TKOLObj( oc[ I ] ).DoGenerateConstants( SL )
          else
          if TComponent( oc[ I ] ) is TKOLCustomControl then
            TKOLToolbar( oc[ I ] ).DoGenerateConstants( SL );
        end;

        // Процедура создания объекта, сопоставленного форме. Вызывается
        // автоматически для автоматически создаваемых форм (и для главной
        // формы в первую очередь):
        Rpt( 'add space', WHITE );
        SL.Add( '' );

        NeedOleInit := FALSE;
        for I := 0 to oc.Count-1 do
        begin
          if TComponent( oc[ I ] ) is TOleControl then
          begin
            NeedOleInit := TRUE;
            break;
          end;
        end;


        if Generate_Pcode then
        BEGIN
        RptDetailed( 'start generating P-code', CYAN );
        {P}SL.Add( '{$IFDEF Pcode}' );
        {P}SL.Add( 'procedure New' + FormName + '( var Result: P' + FormName +
                '; AParent: PControl );' );
        {P}SL.Add( '{$IFDEF Psource}' );
           {P}SL.Add( ' PROC(2)' );
           //0. Отладочный код
           //{P}SL.Add( ' {Debug Line ' + String2Pascal( Path + '_1.inc' ) + ' #0}' );
           //1. Код создания объекта-держателя формы
           {P}SL.Add( ' Load4 ####@@formvmt L(0)' );
           {P}SL.Add( ' TObj.Create<2> RESULT' ); //ESP->Result,@Result,AParent
           {P}SL.Add( ' SetSELF' ); // SELF = Result - для быстрого доступа
           {P}SL.Add( ' DUP C2 Store' ); //ESP->Result,@Result,AParent
           {P}P_GenerateCreateForm( SL ); //ESP->Form,Result,@Result,AParent
           {P}P_GenerateAdd2AutoFree( SL, 'Result', FALSE, '', nil );
           fP_NameSetuped := FALSE;
           {P}P_SetupFirst( SL, Result_Form, 'AParent', '    ' );
           P_SetupName( SL ); // на всякий случай
           if NeedOleInit then
           begin
            {P} SL.Add( '  OleInit' );
            // SL.Add( '  Result.Add2AutoFreeEx( TObjectMethod( ' +
            //            'MakeMethod( nil, @OleUninit ) ) );' );
            {P} SL.Add( ' LoadDword_OleUninit' );
            {P} SL.Add( ' L(0) C2 TObj.Add2AutoFreeEx<3>' );
           end;
            // Здесь выполняется конструирование дочерних объектов - в первую очередь
            // тех, которые не имеют формального родителя, т.е. наследников KOL.TObj
            // (в зеркале - TKOLObj). Сначала конструируется главное меню, если оно
            // есть на форме.
            // Если главное меню отсутствует, но есть хотя бы одно контекстное меню,
            // генерируется пустой объект главной формы - с тем, чтобы прочие меню
            // автоматом были контекстными.
            MainMenuPresent := False;
            PopupMenuPresent := False;
            for I := 0 to oc.Count - 1 do
            begin
              if (TComponent( oc[ I ] ) is TKOLMainMenu) and
                 ((TComponent( oc[ I ] ) as TKOLMainMenu).FItems.Count > 0) then
              begin
                MainMenuPresent := True;
                KO := TComponent( oc[ I ] ) as TKOLObj;
                KO.fP_NameSetuped := FALSE;
                KO.P_SetupFirst( SL, KO.Name, Result_Form, '    ' );
                KO.P_SetupName( SL ); // на случай, если P_SetupFirst переопределена
                                      // и inherited или P_SetupName не вызвана
                P_GenerateAdd2AutoFree( SL, 'Result.' + KO.Name, TRUE, '', KO );
                KO.P_AssignEvents( SL, 'Result.' + KO.Name, FALSE );
                {P}SL.Add( ' DEL //' + KO.Name );
                KO.P_SetupFirstFinalizy( SL );
              end
                else
              if TComponent( oc[ I ] ) is TKOLPopupMenu then
                PopupMenuPresent := True;
            end;

            if PopupMenuPresent and not MainMenuPresent and
               (ClassNameIs( 'TKOLForm' ) or ClassNameIs( 'TKOLMDIChild' )) then
            begin
              //SL.Add( '    NewMenu( ' + Result_Form + ', 0, [ '''' ], nil );' );
              {P}SL.Add( ' LoadStr #0 L(0) L(0) LoadStack L(8) xyAdd L(0) xySwap L(0) C6 NewMenu<3>' +
                         ' DEL' );
            end;

            for I := 0 to oc.Count - 1 do
            begin
              if TComponent( oc[ I ] ) is TKOLMainMenu then continue;
              if TComponent( oc[ I ] ) is TKOLObj then
              begin
                KO := TComponent( oc[ I ] ) as TKOLObj;
                if not(KO is TKOLMenu) or (KO is TKOLMenu) and ((KO as TKOLMenu).FItems.Count > 0) then
                begin
                  KO.fUpdated := FALSE;
                  KO.fP_NameSetuped := FALSE;
                  KO.P_SetupFirst( SL, KO.Name, Result_Form, '    ' );
                  if not(KO is TKOLAction) then
                  KO.P_SetupName( SL ); //
                  P_GenerateAdd2AutoFree( SL, 'Result.' + KO.Name, FALSE, '', KO );
                  {P}SL.Add( ' //P_AssignEvents for ' + KO.Name );
                  KO.P_AssignEvents( SL, 'Result.' + KO.Name, FALSE );
                  if KO.fUpdated then
                    Updated := TRUE;
                  {P}SL.Add( ' DEL //' + KO.Name );
                  KO.P_SetupFirstFinalizy( SL );
                end;
              end;
            end;

            // Далее выполняется рекурсивный обход по дереву дочерних контролов и
            // генерация кода для них:
            P_GenerateChildren( SL, Self, Result_Form, '    ', Updated );

            // По завершении первоначальной генерации выполняется еще один просмотр
            // всех контролов и объектов формы, и для них выполняется SetupLast -
            // генерация кода, который должен выполниться на последнем этапе
            // инициализации (например, свойство CanResize присваивается False только
            // на этом этапе. Если это сделать раньше, то могут возникнуть проблемы
            // с изменением размеров окна в процессе настройки формы).
            for I := 0 to oc.Count - 1 do
            begin
              if TComponent( oc[ I ] ) is TKOLCustomControl then
              begin
                KC := TComponent( oc[ I ] ) as TKOLCustomControl;
                KC.ControlInStack := FALSE;
                KC.P_SetupLast( SL, KC.RefName, Result_Form, '    ' );
                if KC.ControlInStack then
                begin
                  KC.ControlInStack := FALSE;
                  {P}SL.Add( ' DEL //' + KC.Name );
                end;
              end
                 else
              if TComponent( oc[ I ] ) is TKOLObj then
              begin
                KO := TComponent( oc[ I ] ) as TKOLObj;
                KO.ObjInStack := FALSE;
                KO.P_SetupLast( SL, 'Result.' + KO.Name, Result_Form, '    ' );
                if KO.ObjInStack then
                begin
                  KO.ObjInStack := FALSE;
                  {P}SL.Add( ' DEL //' + KO.Name );
                end;
              end;
            end;
            // Не забудем так же вызвать SetupLast для самой формы (можно было бы
            // всунуть код прямо сюда, но так будет легче потом сопровождать):
            P_SetupLast( SL, Result_Form, 'AParent', '    ' );
            //{P} ESP->Form,Result,@Result,AParent
           {P}SL.Add( '           ####Sizeof_T' + FormName );
           {P}SL.Add( '           ####0' );
           {P}SL.Add( '@@formvmt: ####_TObj_.Init' );
           {P}SL.Add( '           ####TObj.Destroy' );
           {P}SL.Add( ' ENDP' );
        {P}SL.Add( '{$ENDIF Psource}' );
        {P}SL.Add( '{$ELSE OldCode}' );
        RptDetailed( 'endof generating P-code', CYAN );
        END;

        Rpt( 'start generating code', CYAN );
        SL.Add( 'procedure New' + FormName + '( var Result: P' + FormName +
                '; AParent: PControl );' );
        SL.Add( 'begin' );
        SL.Add( '' );
        SL.Add( '  {$IFDEF KOLCLASSES}' );
        SL.Add( '  Result := P' + FormName + '.Create;' );
        SL.Add( '  {$ELSE OBJECTS}' );
        SL.Add( '  New( Result, Create );' );
        SL.Add( '  {$ENDIF KOL CLASSES/OBJECTS}' );
        // "Держатель формы" готов. Теперь конструируем саму форму.

        Rpt( 'call GenerateCreateForm', CYAN + LIGHT );
        GenerateCreateForm( SL );
        Rpt( 'after call GenerateCreateForm', CYAN + LIGHT );

        Log( 'after GenerateCreateForm, next: GenerateAdd2AutoFree' );
        //-- moved to GenerateCreateForm: GenerateAdd2AutoFree( SL, 'Result', FALSE, '', nil );
        Log( 'after GenerateAdd2AutoFree, next: SetupFirst' );
        //SL.Add( '  Result.Form.Add2AutoFree( Result );' );

        if  FormCompact then
        begin
            //-------- move this code to GenerateCreateForm
            {
            SL.Add( '  //--< place to call FormCreateParameters >--//' );
            FreeAndNil( FFormAlphabet );
            FreeAndNil( FFormCtlParams );
            FFormAlphabet := TStringList.Create;
            FFormCtlParams := TStringList.Create;
            FFormCommandsAndParams := '';
            FormCurrentParent := '';
            FormCurrentCtlForTransparentCalls := '';
            }
            FormFunArrayIdx := 0;
        end;

        FNameSetuped := FALSE;
        SetupFirst( SL, Result_Form, 'AParent', '    ' );
        SetupName( SL, Result_Form, 'AParent', '    ' ); //
        RptDetailed( 'SetupFirst called for a form', CYAN );

        //////////////////////////////////////////////////////
        //  SUPPORT ACTIVE-X CONTROLS
        {}
        {}if NeedOleInit then
        {}begin
        {}  SL.Add( '  OleInit;' );
        {}  SL.Add( '  Result.Add2AutoFreeEx( TObjectMethod( ' +
        {}            'MakeMethod( nil, @OleUninit ) ) );' );
        {}end;
        {}
        /////////////////////////////////////////////////////////


        // Конструируем компоненты VCL. Нехорошо использовать в проекта компоненты
        // завязанные на VCL, но не все они сильно завязаны с самим VCL.
        for I := 0 to oc.Count-1 do
        begin
          if not( (TComponent( oc[ I ] ) is TKOLObj) or
                  (TComponent( oc[ I ] ) is TControl) or
                  (TComponent( oc[ I ] ) is TKOLApplet or
                  (TComponent( oc[ I ] ) is TKOLProject)))
             or (TComponent( oc[ I ] ) is TOlecontrol) then
          if TComponent( oc[ I ] ) is TComponent then // ай-я-яй!
          begin
            SL.Add( '' );
            ConstructComponent( SL, oc[ I ] );
            GenerateAdd2AutoFree( SL, 'Result.' + TComponent( oc[ I ] ).Name + '.Free',
              FALSE, 'Add2AutoFreeEx', nil );
          end;
        end;

        // Здесь выполняется конструирование дочерних объектов - в первую очередь тех,
        // которые не имеют формального родителя, т.е. наследников KOL.TObj (в зеркале
        // - TKOLObj). Сначала конструируется главное меню, если оно есть на форме.
        // Если главное меню отсутствует, но есть хотя бы одно контекстное меню,
        // генерируется пустой объект главной формы - с тем, чтобы прочие меню автоматом
        // были контекстными.
        MainMenuPresent := False;
        PopupMenuPresent := False;
        for I := 0 to oc.Count - 1 do
        begin
          if TComponent( oc[ I ] ) is TKOLMainMenu then
          begin
            MainMenuPresent := True;
            KO := TComponent( oc[ I ] ) as TKOLObj;
            i1 := SL.Count;
            SL.Add( '' );
            //-----------
            KO.FNameSetuped := FALSE;
            KO.SetupFirst( SL, 'Result.' + KO.Name, Result_Form, '    ' );
            if not(KO is TKOLAction) then
            KO.SetupName( SL, 'Result.' + KO.Name, Result_Form, '    ' );
            GenerateAdd2AutoFree( SL, 'Result.' + KO.Name, TRUE, '', KO );
            KO.AssignEvents( SL, 'Result.' + KO.Name );
            //-----------
            if  not FormCompact then
            TRY
              KO.CacheLines_SetupFirst := TStringList.Create;
              for i2 := i1 to SL.Count-1 do
                  KO.CacheLines_SetupFirst.Add( SL[ i2 ] );
            EXCEPT
              FreeAndNil( KO.CacheLines_SetupFirst );
            END;
            RptDetailed( 'SetupFirst & AssignEvents called for main menu', CYAN );
          end
            else
          if TComponent( oc[ I ] ) is TKOLPopupMenu then
            PopupMenuPresent := True;
        end;

        if PopupMenuPresent and not MainMenuPresent and
           (ClassNameIs( 'TKOLForm' ) or ClassNameIs( 'TKOLMDIChild' )) then
        begin
          SL.Add( '    NewMenu( ' + Result_Form + ', 0, [ '''' ], nil );' );
        end;

        for I := 0 to oc.Count - 1 do
        begin
          if TComponent( oc[ I ] ) is TKOLMainMenu then continue;
          if TComponent( oc[ I ] ) is TKOLObj then
          begin
            KO := TComponent( oc[ I ] ) as TKOLObj;
            KO.fUpdated := FALSE;
            KO.FNameSetuped := FALSE;
          end;
        end;

        for I := 0 to oc.Count - 1 do
        begin
          if TComponent( oc[ I ] ) is TKOLMainMenu then continue;
          if TComponent( oc[ I ] ) is TKOLObj then
          begin
            KO := TComponent( oc[ I ] ) as TKOLObj;
            KO.fUpdated := FALSE;
            if  (KO.CacheLines_SetupFirst <> nil)
            and not ( KO is TKOLMenu )
            and not ( FormCompact ) then
            begin
                for i2 := 0 to KO.CacheLines_SetupFirst.Count-1 do
                    SL.Add( KO.CacheLines_SetupFirst[ i2 ] );
            end
            else
            begin
              i1 := SL.Count;
              //---
              SL.Add( '' );
              KO.FNameSetuped := FALSE;
              KO.SetupFirst( SL, 'Result.' + KO.Name, Result_Form, '    ' );
              KO.SetupName( SL, 'Result.' + KO.Name, Result_Form, '    ' );
              GenerateAdd2AutoFree( SL, 'Result.' + KO.Name, FALSE, '', KO );
              KO.AssignEvents( SL, 'Result.' + KO.Name );
              //---
              if  not FormCompact then
              TRY
                  KO.CacheLines_SetupFirst := TStringList.Create;
                  for i2 := i1 to SL.Count-1 do
                      KO.CacheLines_SetupFirst.Add( SL[ i2 ] );
              EXCEPT
                  FreeAndNil( KO.CacheLines_SetupFirst );
              END;
            end;
            if KO.fUpdated then
              Updated := TRUE;
          end;
        end;
        RptDetailed( 'SetupFirst & AssignEvents called for all components (' + IntToStr( oc.Count ) + ')', CYAN );

        // Далее выполняется рекурсивный обход по дереву дочерних контролов и
        // генерация кода для них:
        RptDetailed( 'start generating children', CYAN );
        GenerateChildren( SL, Self, Result_Form, '    ', Updated );
        RptDetailed( 'endof generating children', CYAN );
        RptDetailed( 'children generated for form', WHITE );
        //FormFlushCompact( SL );
        Rpt( 'form flushed compact', WHITE );

        // По завершении первоначальной генерации выполняется еще один просмотр
        // всех контролов и объектов формы, и для них выполняется SetupLast -
        // генерация кода, который должен выполниться на последнем этапе
        // инициализации (например, свойство CanResize присваивается False только
        // на этом этапе. Если это сделать раньше, то могут возникнуть проблемы
        // с изменением размеров окна в процессе настройки формы).
        for I := 0 to oc.Count - 1 do
        begin
          if TComponent( oc[ I ] ) is TKOLCustomControl then
          begin
            KC := TComponent( oc[ I ] ) as TKOLCustomControl;
            KC.SetupLast( SL, KC.RefName, Result_Form, '    ' );
          end
             else
          if TComponent( oc[ I ] ) is TKOLObj then
          begin
            KO := TComponent( oc[ I ] ) as TKOLObj;
            KO.SetupLast( SL, 'Result.' + KO.Name, Result_Form, '    ' );
          end;
        end;
        RptDetailed( 'endof generating SetupLast for children', CYAN );
        RptDetailed( 'setuplast generated for form', WHITE );
        // Не забудем так же вызвать SetupLast для самой формы (можно было бы
        // всунуть код прямо сюда, но так будет легче потом сопровождать):
        SetupLast( SL, Result_Form, 'AParent', '    ' );
        RptDetailed( 'endof generating SetupLast for a form', CYAN );

        //--- Если имелись контролы, создаваемые и настраиваемые компактным кодом
        //    то следует в заранее подготовленную позицию вставить вызов
        //    FormCreateParameters( alphabet, commands&parameters );
        //    где: alphabet - массив указателей на использованные функции,
        //         commands&parameters - строка с командами и параметрами
        //             для интерпретации в вызовах FormExecuteCommands( ... )
        if  FFormAlphabet <> nil then
            RptDetailed( 'FormCompact = ' + Int2Str( Integer( FormCompact ) ) +
                         ' FormAlphabet.Count = ' + Int2Str( FFormAlphabet.Count ),
                         WHITE or LIGHT );
        if  FormCompact and (FFormAlphabet.Count > 0) then
        begin
            FA := TStringList.Create;
            TRY
                FA.Add( 'const FormFunctionsAlphabet: array[0..' +
                    //IntToStr( FFormAlphabet.Count-1 ) + '] of TFormInitFunc = (' );
                    IntToStr( FFormAlphabet.Count-1 ) + '] of Pointer = (' );
                for J := 0 to FFormAlphabet.Count-1 do
                begin
                    ch := '.';
                    if  FFormAlphabet.Objects[J] <> nil then
                        ch := '#';
                    s := '    {' + Int2Hex( J+1, 1 ) + ch + '} @  ' +
                         FFormAlphabet[J];
                    if  J = FFormAlphabet.Count-1 then
                        s := s + ');'
                    else
                        s := s + ',';
                    FA.Add( s );
                end;
                for J := SL.Count-1 downto 0 do
                begin
                    if  SL[J] = 'begin' then
                    begin
                        for K := FA.Count-1 downto 0 do
                            SL.Insert( J, FA[K] );
                        break;
                    end;
                end;
            FINALLY
                FA.Free;
            END;
            for I := 0 to SL.Count-1 do
            begin
                if  SL[I] = '  //--< place to call FormCreateParameters >--//' then
                begin
                    s := '  Result.Form.FormCreateParameters( ' +
                         '@ FormFunctionsAlphabet, ''''' +
                         FFormCommandsAndParams + ' );';
                    //SL.SaveToFile( 'C:\test_SL_before.txt' );
                    SL[ I ] := s;
                    //SL.SaveToFile( 'C:\test_SL.txt' );
                    break;
                end;
            end;
        end;

        SL.Add( '' );
        SL.Add( 'end;' );
        if Generate_Pcode then
          {P}SL.Add( '{$ENDIF OldCode}' );
        SL.Add( '' );

        FormFlushCompact( SL );

        if ResStrings <> nil then
        begin
          for I := ResStrings.Count-1 downto 0 do
            SL.Insert( 1, ResStrings[ I ] );
        end;
        RptDetailed( 'start saving code', CYAN );

        SaveStrings( SL, RemoveExt( Path ) + '_1.inc', Updated );
        Result := True;
        RptDetailed( 'saved -- generated code', CYAN )

      except
        //++++++++++ { Maxim Pushkar } +++++++++
        on E: Exception do
        begin
          Rpt( 'EXCEPTION FOUND 10989: ' + E.Message, RED );
          Rpt_Stack;
        end;
        //++++++++++++++++++++++++++++++++++++++
      end;

    FINALLY
      SL.Free;
      //RptDetailed( 'SL.Free executed', CYAN )
    END;

  FINALLY
    oc.Free;
    RptDetailed( 'END of generating INC for ' + Path, WHITE )
  END;

  Sleep( 0 ); //**** THIS IS MUST ****
  { added in v0.84 to fix TKOLFrame, when TKOLCustomControl descendant component
    is dropped on TKOLFrame. }
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateINC' );
  end;
end;

function TrimAll( const S: String ): String;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TrimAll', 0
  @@e_signature:
  end;
  Result := S;
  for I := Length( Result ) downto 1 do
    if Result[ I ] <= ' ' then
      Delete( Result, I, 1 );
end;

function EqualWithoutSpaces( S1, S2: String ): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'EqualWithoutSpaces', 0
  @@e_signature:
  end;
  S1 := TrimAll( LowerCase( S1 ) );
  S2 := TrimAll( LowerCase( S2 ) );
  Result := S1 = S2;
end;

function LongStringSeparate( s: String ): String;
var i: Integer;
    LineWidth: Integer;
begin
  Result := '';
  LineWidth := 0;
  while s <> '' do
  begin
    i := pos( ',', s );
    if i <= 0 then i := Length( s );
    if i > 0 then
    begin
      if LineWidth + i > 63 then
      begin
        Result := Result + #13#10;
        LineWidth := i;
      end;
      Result := Result + Copy( s, 1, i );
      Delete( s, 1, i );
    end;
  end;
end;

function FirstSpaces( const s: String ): String;
var i: Integer;
begin
  Result := '';
  for i := 1 to Length( s ) do
    if s[ i ] = ' ' then Result := Result + ' '
    else break;
end;

procedure ReplaceCorresponding( const FromDir, ToDir: String; Src: TStrings; FromLine: Integer );
var i, Level: Integer;
    s: String;
begin
  Level := 0;
  for i := FromLine to Src.Count-1 do
  begin
    s := Trim( Src[ i ] );
    if (pos( FromDir, s ) = 1) and (Level = 0) then
    begin
      Src[i] := FirstSpaces( Src[ i ] ) + ToDir;
      Exit;
    end
    else
    if (pos( '{$IF', s ) = 1) then
      inc( Level )
    else
    if (pos( '{$ENDIF', s ) = 1) or (pos( '{$IFEND', s ) = 1) then
      dec( Level );
  end;
end;

function TKOLForm.GeneratePAS(const Path: String; var Updated: Boolean): Boolean;
const DefString = '{$DEFINE KOL_MCK}';
      IfNotKolMck: array[ Boolean ] of String = (
        '{$IFNDEF KOL_MCK}',
        '{$IF Defined(KOL_MCK)}{$ELSE}'
      );
      EndIfKolMck: array[ Boolean ] of String = (
        '{$ENDIF (place your units here->)};',
        '{$IFEND (place your units here->)};'
      );
var SL: TStringList;        // строки результирующего PAS-файла
    Source: TStringList;    // исходный файл
    I, J, K: Integer;
    UsesFound, FormDefFound, ImplementationFound: Boolean;
    S: KOLString;
    S1, S2, S_FormClass, S_IFDEF_KOL_MCK, S_PROCEDURE_NEW, S_FUNCTION_NEW, S_Upper,
    S_1, S_1_Lower, S_FormDef: String;
    chg_src: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GeneratePAS', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GeneratePAS' );
  try
  Rpt( 'Generating PAS for ' + Path, WHITE ); //Rpt_Stack;
  Result := False;
  // +++ by Alexander Shakhaylo:
  if not fileexists(Path + '.pas') or FLocked then
  begin
     Rpt( 'File not exists: ' + Path + '.pas', YELLOW );
     LogOK; exit;
  end;
  // ---
  SL := TStringList.Create;
  Source := TStringList.Create;

  chg_src := FALSE;
  try

  if not FileExists( ExtractFilePath( Path ) + 'uses.inc' ) then
  begin
  SL.Add( Signature );
  SL.Add( '{ uses.inc' );
  SL.Add( '  This file is generated automatically - do not modify it manually.' );
  SL.Add( '  It is included to be recognized by compiler, but replacing word ' );
  SL.Add( '  <uses> with compiler directive <$I uses.inc> fakes auto-completion' );
  SL.Add( '  preventing it from automatic references adding to VCL units into' );
  SL.Add( '  uses clause aimed for KOL environment only. }' );
  SL.Add( '' );
  SL.Add( 'uses' );
  {P := True;
  if KOLProject <> nil then
    P := KOLProject.ProtectFiles;}
  SaveStrings( SL, ExtractFilePath( Path ) + 'uses.inc', Updated );
  SL.Clear;
    RptDetailed( 'uses.inc prepared', CYAN );
  end;

  RptDetailed( 'Loading source for ' + Path + '.pas', BLUE );
  LoadSource( Source, Path + '.pas' );
  RptDetailed( 'Source loaded for ' + Name, CYAN );
  for I := 0 to Source.Count- 1 do
  begin
      if RemoveSpaces( Source[ I ] ) = RemoveSpaces( Signature ) then
      begin
        Result := True;
        if (I < Source.Count - 1) and (Source[ I + 1 ] <> DefString) and
           (KOLProject <> nil) and KOLProject.IsKOLProject then
        begin
          chg_src := TRUE;
          Source.Insert( I + 1, DefString );
          //SaveStrings( Source, Path + '.pas', Updated );
        end;
        break;
      end;
  end;
  {$IFnDEF NOT_CONVERT_TMSG}
  Rpt( 'Converting tagmsg', RED );
  for I := 0 to Source.Count- 1 do
  begin
      //--------------- from KOL/MCK 3.04, convert tagMSG -> TMsg:
      S := Source[I];
      if  pos( 'tagmsg', LowerCase( S ) ) > 0 then
      begin
          RptDetailed( 'tagmsg found in line ' + Int2Str(I+1), CYAN );
          for J := Length(S)-5 downto 1 do
          begin
              if  AnsiCompareText( Copy(S, J, 6), 'tagmsg' ) = 0 then
              begin
                  {$IFDEF _D2009orHigher}
                  if  ( (J = 1) or not CharInSet(S[J-1], ['A'..'Z','a'..'z','_']) )
                  and ( (J = Length(S)-5) or not CharInSet(S[J+6],
                      ['0'..'9','A'..'Z','a'..'z','_']) ) then
                  {$ELSE}
                  if  ( (J = 1) or not(S[J-1] in ['A'..'Z','a'..'z','_']) )
                  and ( (J = Length(S)-5) or not(S[J+6] in
                      ['0'..'9','A'..'Z','a'..'z','_']) ) then
                  {$ENDIF}
                  begin
                       RptDetailed( 'tagmsg replaced with TMsg in line ' + Int2Str(I+1), CYAN );
                       S := Copy( S, 1, J-1 ) + 'TMsg' + Copy( S, J+6, MaxInt );
                       Source[I] := S;
                       chg_src := TRUE;
                  end;
              end;
          end;
      end;
  end;
  {$ENDIF}

  if Result then
  begin
    // Test the Source - may be form is renamed...

    for I := 0 to Source.Count-2 do
    begin
      S := Trim( Source[ I ] );
      if  (S <> '') and (S[ 1 ] = '{') and
          (AnsiCompareText( S, '{$I MCKfakeClasses.inc}' ) = 0) then
      if I < Source.Count - 5 then
      begin
        chg_src := TRUE;
        Source[ I + 1 ] :=
          '  {$IFDEF KOLCLASSES} {$I T' + FormName + 'class.inc}' +
          ' {$ELSE OBJECTS}' +
          ' P' + FormName + ' = ^T' + FormName + ';' +
          ' {$ENDIF CLASSES/OBJECTS}';
        Source[ I + 2 ] :=
          '  {$IFDEF KOLCLASSES}{$I T' + FormName +
          '.inc}{$ELSE} T' + FormName +
          ' = object(TObj) {$ENDIF}';
        S := ExtractFilePath( Path ) + 'T' + FormName + '.inc';
        if not FileExists( S ) then
        begin
          SaveStringToFile( S, 'T' + FormName + ' = class(TObj)' );
        end;
        S := ExtractFilePath( Path ) + 'T' + FormName + 'class.inc';
        if not FileExists( S ) then
        begin
          SaveStringToFile( S, 'T' + FormName + ' = class; P' + FormName + ' = T' + FormName + ';' );
        end;

        Source[ I + 5 ] := '  T' + FormName + ' = class(TForm)';
        //////////////////////// by Alexander Shakhaylo //////////////////
        /// D[u]fa
        /// а вот это я б ваще убрал. по моему не прально генерит код, добавляя
        ///  лишний ENDIF // VK: ну и уберём, значит. Вернуть всегда можно, если что.
        {$IFnDEF _D2005orHigher}                                        //
        (*if pos('{$ENDIF', UpperCase( Source[ I + 6 ] ) ) <= 0 then    //
        begin                                                           //
           Source.Insert( I + 6, '{$ENDIF}' );                          //
        end;*)                                                          //
        {$ENDIF}
        //////////////////////////////////////////////////////////////////
        BREAK;
      end;
    end;
    RptDetailed( '{$I MCKFAKECLASSES.inc} handled', CYAN );

    S_FormClass := UpperCase( 'T' + FormName + ' = class(TForm)' );
    ///Rpt( '~~~~~~~~~~~~~~~~~~~~', RED );
    for I := 0 to Source.Count-2 do
    begin
      ///Rpt( Source[I], YELLOW );
      if not GlobalNewIF then
      begin
        //Rpt( 'check src' + IntToStr( I ) + ':' + Source[ I ], YELLOW );
        if (Pos( '{$IFEND KOL_MCK', Trim( Source[ I ] ) ) = 1) then
        begin
          Source[ I ] := FirstSpaces( Source[ I ] ) + '{$ENDIF KOL_MCK}';
          chg_src := TRUE;
        end
          else
        if Trim( Source[ I ] ) = '{$IF Defined(KOL_MCK)}' then
        begin
          Source[ I ] := FirstSpaces( Source[ I ] ) + '{$IFDEF KOL_MCK}';
          ReplaceCorresponding( '{$IFEND', '{$ENDIF}', Source, I+1 );
          chg_src := TRUE;
        end
          else
        begin
          if pos( '{$IF Defined(KOL_MCK)}{$ELSE}', Source[I] ) > 0 then
          begin
            S := Source[I];
            //S := StringReplace( S, '{$IF Defined(KOL_MCK)}{$ELSE}', '{$IFNDEF KOL_MCK}', [] );
            KOLStrReplace( S, '{$IF Defined(KOL_MCK)}{$ELSE}', '{$IFNDEF KOL_MCK}' );
            Source[I] := S;
            chg_src := TRUE;
          end;
          if pos( '{$IFEND (place your units here->)}', Source[I] ) > 0 then
          begin
            S := Source[I];
            //S := StringReplace( S, '{$IFEND (place your units here->)}',
            //                       '{$ENDIF (place your units here->)}', [] );
            KOLStrReplace( S, '{$IFEND (place your units here->)}',
                           '{$ENDIF (place your units here->)}' );
            Source[I] := S;
            chg_src := TRUE;
          end;
        end;
      end;
      if GlobalNewIF then
      begin
        if (Pos( '{$ENDIF KOL_MCK', Source[ I ] ) > 0) then
        begin
          //Rpt( 'replace to IFEND', RED );
          Source[ I ] := '  {$IFEND KOL_MCK}';
          chg_src := TRUE;
        end
          else
        if (Trim( Source[ i ] ) = '{$IFDEF KOL_MCK}') and
           ((Source[ I ][1] = ' ')) then
        begin
          Source[ I ] := FirstSpaces( Source[I] ) + '{$IF Defined(KOL_MCK)}';
          ReplaceCorresponding( '{$ENDIF', '{$IFEND}', Source, I+1 );
          chg_src := TRUE;
        end
          else
        begin
          if pos( '{$IFNDEF KOL_MCK}', Source[I] ) > 0 then
          begin
            S := Source[I];
            //S := StringReplace( S, '{$IFNDEF KOL_MCK}', '{$IF Defined(KOL_MCK)}{$ELSE}', [ ] );
            KOLStrReplace( S, '{$IFNDEF KOL_MCK}', '{$IF Defined(KOL_MCK)}{$ELSE}' );
            Source[I] := S;
            chg_src := TRUE;
          end;
          if pos( '{$ENDIF (place your units here->)}', Source[I] ) > 0 then
          begin
            S := Source[I];
            //S := StringReplace( S, '{$ENDIF (place your units here->)}',
            //                       '{$IFEND (place your units here->)}', [] );
            KOLStrReplace( S, '{$ENDIF (place your units here->)}',
                           '{$IFEND (place your units here->)}' );
            Source[I] := S;
            chg_src := TRUE;
          end;
        end;
      end;
      S := Trim( Source[ I ] );
      S_Upper := UpperCase( S );
      ////////////////////////////////////////////////////////////////////
      //S := UpperCase( 'T' + FormName + ' = class(TForm)' );             //
      if pos( S_FormClass, UpperCase( Source[ I ] ) ) > 0 then                    //
      begin                                                             //
        /// D[u]fa
        if (Pos( '{$IFEND', Source[ I + 1 ] ) <= 0)
           and
           (Pos( '{$ENDIF', Source[ I+1 ] ) <= 0) then
        begin
          chg_src := TRUE;
          /// D[u]fa
          if GlobalNewIF then
            Source.Insert( I + 1, '  {$IFEND KOL_MCK}' )
          else
            Source.Insert( I + 1, '  {$ENDIF KOL_MCK}' );
        end;
        break;
      end;                                                              //
      ////////////////////////////////////////////////////////////////////
    end;
    RptDetailed( 'Check for T' + FormName + ' = class(TForm) done.', CYAN );

    S_IFDEF_KOL_MCK := ' {$IFDEF KOL_MCK} : ';
    S_procedure_new := 'procedure new';
    S_function_new := 'function new';
    S_FormDef := '  ' + FormName + ' {$IFDEF KOL_MCK} : P' + FormName +
                         ' {$ELSE} : T' + FormName + ' {$ENDIF} ;';
    for I := Source.Count - 2 downto 0 do
    begin
      S := Trim( Source[ I ] );
      S_Upper := UpperCase( S );
      if GlobalNewIF then
      begin
        if Trim( S_Upper ) = '{$IFNDEF KOL_MCK}{$R *.DFM}{$ENDIF}' then
        begin
          Source[I] := '{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}';
          chg_src := TRUE;
        end;
      end
        else
      if not GlobalNewIF then
      begin
        if Trim( S_Upper ) = '{$IF DEFINED(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}' then
        begin
          Source[I] := '{$IFNDEF KOL_MCK}{$R *.DFM}{$ENDIF}';
          ////Rpt( '{$IF Defined Rsc Found and replaced!', RED );
          chg_src := TRUE;
        end;
      end
        else
      begin
        if pos( S_IFDEF_KOL_MCK, UpperCase( Trim( Source[ I ] ) ) ) > 0 then
        begin
          if Source[ I ] <> S_FormDef then
          begin
              chg_src := TRUE;
              Source[ I ] := S_FormDef;
          end;
        end;
        if (S_Upper = '{$IFDEF KOL_MCK}') then
        begin
          S_1 := Trim( Source[ I + 1 ] );
          S_1_Lower := LowerCase( S_1 );
          if (
             (Copy( S_1_Lower, 1, Length( S_procedure_new ) ) = S_procedure_new)
           or
             (Copy( S_1_Lower, 1, Length( S_function_new ) ) = S_function_new)
           ) then
            begin
               chg_src := TRUE;
               Source[ I + 1 ] := 'procedure New' + FormName + '( var Result: P' +
               FormName + '; AParent: PControl );';
               ///////////////////////////// by Alexander Shakhaylo /////////
               if pos( '{$ENDIF', UpperCase( Source[ I + 2 ] ) ) <= 0 then //
                 Source.Insert( I + 2, '{$ENDIF}');                        //
               //////////////////////////////////////////////////////////////
            end;
        end;
        if S_Upper = '{$IFDEF KOL_MCK}' then
          if StrIsStartingFrom( PChar(UpperCase( Trim( Source[ I + 2 ] ) )),
             'PROCEDURE FREEOBJECTS_') then
          begin
            // remove artefact
            chg_src := TRUE;
            Source.Delete( I + 2 );
          end;
      end;
    end;
    RptDetailed( 'Loop2 handled', CYAN );

    // Convert old definitions to the new ones
    K := -1;
    for I := 0 to Source.Count-3 do
    begin
      S := Trim( Source[ I ] );
      if S = '{$ELSE not_KOL_MCK}' then
      begin
        K := I;
        break;
      end;
    end;
    RptDetailed( 'Search for {$ELSE not_KOL_MCK} done, K=' + IntToStr( K ), CYAN );

    if K < 0 then
    begin
      for I := 0 to Source.Count-3 do
      begin
        S := UpperCase( Trim( Source[ I ] ) );
        if StrIsStartingFrom( PChar( S ), '{$I MCKFAKECLASSES.INC}' ) then
        begin
          for J := I+1 to Source.Count-3 do
          begin
            S := UpperCase( Trim( Source[ J ] ) );
            if Copy( S, 1, 6 )  = '{$ELSE' then
            begin
              chg_src := TRUE;
              Source[ J ] := '  {$ELSE not_KOL_MCK}';
              break;
            end;
          end;
          break;
        end;
      end;
      RptDetailed( '{$ELSE not_KOL_MCK} provided', CYAN );
    end;

    // Make corrections when Delphi inserts declarations not at the good place:
    for I := 0 to Source.Count-3 do
    begin
      S := Trim( Source[ I ] );
      if S = '{$ELSE not_KOL_MCK}' then
      begin
        S := Trim( Source[ I + 2 ] );
        if GlobalNewIF then
        begin
          if S = '{$ENDIF KOL_MCK}' then
          begin
            S := FirstSpaces( Source[ I ] ) + '{$IFEND KOL_MCK}';
            Source[ I+2 ] := S;
          end;
        end;
        if not GlobalNewIF then
        begin
          if S = '{$IFEND KOL_MCK}' then
          begin
            S := FirstSpaces( Source[ I ] ) + '{$ENDIF KOL_MCK}';
            Source[ I+2 ] := S;
          end;
        end;
        /// D[u]fa
        //if (S <> {$IFDEF NEWIF}'{$IFEND KOL_MCK}'{$ELSE}'{$ENDIF KOL_MCK}'{$ENDIF}) then
        if GlobalNewIF and (S <> '{$IFEND KOL_MCK}') or
           not GlobalNewIF and (S <> '{$ENDIF KOL_MCK}') then
        begin
          for J := I+1 to Source.Count-1 do
          begin
            S := UpperCase( Trim( Source[ J ] ) );
            //if (Copy( S, 1, 7 ) = {$IFDEF NEWIF}'{$IFEND'{$ELSE}'{$ENDIF'{$ENDIF}) then
            if GlobalNewIF and (Copy( S, 1, 7 ) = '{$IFEND') or
               not GlobalNewIF and (Copy( S, 1, 7 ) = '{$ENDIF') then
            begin
              chg_src := TRUE;
              Source.Delete( J );
              if GlobalNewIF then
                Source.Insert( I+2, '  {$IFEND KOL_MCK}')
              else
                Source.Insert( I+2, '  {$ENDIF KOL_MCK}');
              break;
            end;
          end;
        end;
        break;
      end;
    end;
    RptDetailed( 'Corrections done.', CYAN );

    //Check for changes in 'uses' clause:
    I := -1;
    while I < Source.Count - 1 do
    begin
      Inc( I );

      if  AnsiCompareText( Trim( Source[ I ] ), 'implementation' ) = 0 then
          break;

      if (pos( 'uses ', LowerCase( Trim( Source[ I ] ) + ' ' ) ) = 1) then
      begin
        S := '';
        for J := I to Source.Count - 1 do
        begin
          S := S + Source[ J ];
          if pos( ';', Source[ J ] ) > 0 then
            break;
        end;

        //S1 := 'uses Windows, Messages, ShellAPI, KOL' + AdditionalUnits;
        S1 := 'uses Windows, Messages, KOL' + AdditionalUnits;
        S2 := {$IFDEF UNICODE_CTRLS} ParseW {$ELSE} Parse {$ENDIF}
              ( S, '{' ); S := '{' + S;
        if not EqualWithoutSpaces( S1, S2 ) then
        begin

          (*
          ShowMessage( 'Not equal:'#13#10 +
                       TrimAll( S1 ) + #13#10 +
                       TrimAll( S2 ) );
          *)

          repeat
            S1 := Source[ I ];
            Source.Delete( I );
          until pos( ';', S1 ) > 0;

          chg_src := TRUE;
          Source.Insert( I,
           //'uses Windows, Messages, ShellAPI, KOL' + AdditionalUnits + ' ' +
           LongStringSeparate( 'uses Windows, Messages, KOL' +
             AdditionalUnits + ' ' + S ) );
        end;

        break;
      end;
    end;
    RptDetailed( 'Checks for changes in USES done.', CYAN );

    if AfterGeneratePas( Source ) or chg_src then
    begin
      SaveStrings( Source, Path + '.pas', Updated );
      RptDetailed( 'Strings saved to ' + Path + '.pas', CYAN );
    end
      else
      RptDetailed( 'Strings not changed', CYAN );

    SL.Free;
    Source.Free;
    LogOK;
    Exit;
  end;

  // Step 1. If unit is not yet prepared for working both
  // in KOL and VCL, then prepare it now.
  RptDetailed( 'Step 1', CYAN );
  K := 0;
  for I := 0 to Source.Count - 1 do
    if pos( RemoveSpaces( Signature ), RemoveSpaces( Source[ I ] ) ) > 0 then
    begin
      Inc( K );
      break;
    end;
  if K = 0 then
  begin
    UsesFound := False;
    FormDefFound := False;
    ImplementationFound := False;
    try
      SL.Add( Signature );
      for I := 0 to Source.Count - 1 do
      begin
        if pos( '{$r *.dfm}', LowerCase( Source[ I ] ) ) > 0 then
        begin
          /// D[u]fa
          if GlobalNewIF then
            Source[ I ] := '{$IF Defined(KOL_MCK)}{$ELSE}{$R *.DFM}{$IFEND}'   //надо именно через else, а не через {$if not}, иначе не работает
          else
            Source[ I ] := '{$IFNDEF KOL_MCK} {$R *.DFM} {$ENDIF}';
          break;
        end;
      end;
      I := -1;
      while I < Source.Count - 1 do
      begin
        Inc( I );
        if not ImplementationFound then
        if not UsesFound and
           (pos( 'uses ', LowerCase( Trim( Source[ I ] ) + ' ' ) ) = 1) then
        begin
          UsesFound := True;
          SL.Add( '{$IFDEF KOL_MCK}' );
          //SL.Add( 'uses Windows, Messages, ShellAPI, KOL' + AdditionalUnits + ' ' +
          /// D[u]fa
          /// в новых версиях можно юзать конструцию:
          /// uses
          ///{$IF Defined(KOL_MCK)}
          ///  Windows, Messages, KOL;
          ///{$ELSE}  // наивный компиляор будет пихать свои VCL мудули сюда
          ///  Windows, Messages, KOL, mirror, Classes, Controls, mckCtrls;
          ///{$IFEND}
          /// но для совместимости меняю только директиву
          SL.Add( LongStringSeparate(
                  'uses Windows, Messages, KOL' + AdditionalUnits + ' ' +
                    IfNotKolMck[ GlobalNewIF ]
                  + ', mirror, Classes, Controls, mckCtrls, mckObjs, Graphics ' +
                    EndIfKolMck[ GlobalNewIF ] ) );
          SL.Add( '{$ELSE}' );
          SL.Add( '{$I uses.inc}' + Copy( Source[ I ], 5, Length( Source[ I ] ) - 4 ) );
          Inc( I );
          if pos( ';', Source[ I - 1 ] ) < 1 then
          repeat
            SL.Add( Source[ I ] );
            Inc( I );
          until pos( ';', Source[ I - 1 ] ) > 0;
          SL.Add( '{$ENDIF}' );
          Dec( I );
          Continue;
        end;
        if not FormDefFound and
           (pos( LowerCase( 'T' + FormName + ' = class(TForm)' ),
                LowerCase( Source[ I ] ) ) > 0) then
        begin
          FormDefFound := True;
          /// D[u]fa
          if GlobalNewIF then
            SL.Add( '  {$IF Defined(KOL_MCK)}' )
          else
            SL.Add( '  {$IFDEF KOL_MCK}' );
          S := '  {$I MCKfakeClasses.inc}';
          SL.Add( S );
          SL.Add( '  {$IFDEF KOLCLASSES} T' + FormName +
          ' = class; P' + FormName + ' = T' + FormName + ';' +
          ' {$ELSE OBJECTS}' +
          ' P' + FormName + ' = ^T' + FormName + ';' +
          ' {$ENDIF CLASSES/OBJECTS}' );
          SL.Add( '  {$IFDEF KOLCLASSES}{$I T' + FormName +
          '.inc}{$ELSE} T' + FormName +
          ' = object(TObj) {$ENDIF}' );
          SL.Add( '    Form: ' + FormTypeName + ';' );
          SL.Add( '  {$ELSE not_KOL_MCK}' );
          SL.Add( Source[ I ] );
          /// D[u]fa
          if GlobalNewIF then
            SL.Add( '  {$IFEND KOL_MCK}' )
          else
            SL.Add( '  {$ENDIF KOL_MCK}' );
          Continue;
        end;
        if not ImplementationFound then
        begin
          if LowerCase( Trim( Source[ I ] ) ) =
             LowerCase( FormName + ': T' + FormName + ';' ) then
          begin
            SL.Add( '  ' + FormName + ' {$IFDEF KOL_MCK} : P' + FormName +
                    ' {$ELSE} : T' + FormName + ' {$ENDIF} ;' );
            Continue;
          end;
        end;
        if not ImplementationFound and
           (pos( 'implementation', LowerCase( Source[ I ] ) ) > 0 ) then
        begin
          SL.Add( '{$IFDEF KOL_MCK}' );
          SL.Add( 'procedure New' + FormName + '( var Result: P' + FormName +
                  '; AParent: PControl );' );
          SL.Add( '{$ENDIF}' );
          SL.Add( '' );

          ImplementationFound := True;
          SL.Add( Source[ I ] );
          while True do
          begin
            Inc( I );
            if pos( 'uses ', LowerCase( Source[ I ] + ' ' ) ) > 0 then
            begin
              SL.Add( Source[ I ] );
              if pos( ';', Source[ I ] ) < 1 then
              begin
                repeat
                  Inc( I );
                  SL.Add( Source[ I ] );
                until pos( ';', Source[ I ] ) > 0;
              end;
              ImplementationFound := False;
              break;
            end
               else
            if (Trim( Source[ I ] ) <> '') and (Trim( Source[ I ] )[ 1 ] <> '{') then
              break;
            SL.Add( Source[ I ] );
          end;
          if not ImplementationFound then
            SL.Add( '' );
          SL.Add( '{$IFDEF KOL_MCK}' );
          SL.Add( '{$I ' + FormUnit + '_1.inc}' );
          SL.Add( '{$ENDIF}' );
          if ImplementationFound then
          begin
            SL.Add( '' );
            SL.Add( Source[ I ] );
          end;
          ImplementationFound := True;
          Continue;
        end;
        SL.Add( Source[ I ] );
      end;
    except
      ImplementationFound := False;
    end;
    if not UsesFound or not FormDefFound or not ImplementationFound then
    begin
      SL.Free;
      Source.Free;
      S := '';
      if not UsesFound then
        S := 'Uses not found'#13;
      if not FormDefFound then
        S := S + 'Form definition not found'#13;
      if not ImplementationFound then
        S := S + 'Implementation section not found'#13;
      ShowMessage( 'Error converting ' + FormUnit + ' unit to KOL:'#13 + S );
      LogOK;
      Exit;
    end;

    AfterGeneratePas( SL );
    SaveStrings( SL, Path + '.pas', Updated );
  end;

  Result := True;
  except
    Rpt( '**************** Unknown Exception - supressed', RED );
  end;

  SL.Free;
  Source.Free;
  LogOK;
  finally
  Log( '<-TKOLForm.GeneratePAS' );
  end;
end;

function TKOLForm.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateTransparentInits' );
  try
  Result := '';
  if not FLocked then
  begin

    //Log( '#1 TKOLForm.GenerateTransparentInits' );

    if not DefaultPosition then
    begin
      //Log( '#1.A TKOLForm.GenerateTransparentInits' );

      if not DoNotGenerateSetPosition then
      begin
        //Log( '#1.B TKOLForm.GenerateTransparentInits' );
        {$IFDEF _D2009orHigher}
        Result := '.SetPosition( ' + IntToStr( (Owner as TForm).Left ) + ', ' +
            IntToStr( (Owner as TForm).Top ) + ' )';
        {$ELSE}
        if FBounds <> nil then
          Result := '.SetPosition( ' + IntToStr( Bounds.Left ) + ', ' +
                    IntToStr( Bounds.Top ) + ' )';
        {$ENDIF}
        //Log( '#1.C TKOLForm.GenerateTransparentInits' );
      end;

      //Log( '#1.D TKOLForm.GenerateTransparentInits' );
    end;

    //Log( '#2 TKOLForm.GenerateTransparentInits' );

    if not DefaultSize then
    begin
      if {CanResize or} (Owner = nil) or not(Owner is TForm) then
        if HasCaption then
          {$IFDEF _D2009orHigher}
          Result := Result + '.SetSize( ' + IntToStr( (Owner as TForm).Width ) + ', ' +
                  IntToStr( (Owner as TForm).Height ) + ' )'
          {$ELSE}
          Result := Result + '.SetSize( ' + IntToStr( Bounds.Width ) + ', ' +
                  IntToStr( Bounds.Height ) + ' )'
          {$ENDIF}
        else
          {$IFDEF _D209orHigher}
          Result := Result + '.SetSize( ' + IntToStr( Width ) + ', ' +
                  IntToStr( Height-GetSystemMetrics(SM_CYCAPTION) ) + ' )';
          {$ELSE}
          Result := Result + '.SetSize( ' + IntToStr( Bounds.Width ) + ', ' +
                  IntToStr( Bounds.Height-GetSystemMetrics(SM_CYCAPTION) ) + ' )';
          {$ENDIF}
    end;

    //Log( '#3 TKOLForm.GenerateTransparentInits' );

    if Tabulate then
      Result := Result + '.Tabulate'
    else
    if TabulateEx then
      Result := Result + '.TabulateEx';

    //Log( '#4 TKOLForm.GenerateTransparentInits' );

    if  AllBtnReturnClick then
    begin
        if FormMain and not AppletOnForm then
        else
            Result := Result + '.AllBtnReturnClick';
    end;

    if PreventResizeFlicks then
      Result := Result + '.PreventResizeFlicks';

    //Log( '#5 TKOLForm.GenerateTransparentInits' );

    if supportMnemonics then
      Result := Result + '.SupportMnemonics';

    //Log( '#6 TKOLForm.GenerateTransparentInits' );

    if HelpContext <> 0 then
      Result := Result + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )';
  end;

  //Log( '#7 TKOLForm.GenerateTransparentInits' );

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateTransparentInits' );
  end;
end;

function TKOLForm.GenerateUnit(const Path: String): Boolean;
var PAS, INC: Boolean;
    Updated, PasUpdated, IncUpdated: Boolean;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateUnit', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateUnit' );
  try
  Result := False;
  if not FChanged then Exit;
  FChanged := FALSE;

  //Rpt_Stack;

  if not FLocked then
  begin
    for I := 0 to Owner.ComponentCount-1 do
    begin
      C := Owner.Components[ I ];
      if IsVCLControl( C ) then
      begin
        FLocked := TRUE;
        ShowMessage( 'Form ' + Owner.Name + ' contains VCL controls and can not ' +
                     'be converted to KOL form properly. TKOLForm component is locked. ' +
                     'Remove VCL controls first, then unlock TKOLForm component.' );
        LogOK;
        Exit;
      end;
    end;

    fUniqueID := 5000;
    Rpt( '----------- UNIQUE ID = ' + IntToStr( fUniqueID ), WHITE );
    if FormUnit = '' then
    begin
      Rpt( 'Error: FormUnit = ''''', RED );
      LogOK;
      Exit;
    end;

    PasUpdated := FALSE;
    IncUpdated := FALSE;
    PAS := GeneratePAS( Path, PasUpdated );
    INC := GenerateINC( Path, IncUpdated );
    Updated := PasUpdated or IncUpdated;
    Result := PAS and INC;
    if Result and Updated then
    begin
      // force mark modified here
      if PasUpdated then
        MarkModified( Path + '.pas' );
      if IncUpdated then
      begin
        MarkModified( Path + '_1.inc' );
        UpdateUnit( Path + '_1.inc' );
      end;
    end;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateUnit' );
  end;
end;

function TKOLForm.GetCaption: TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GetCaption' );
  try
  Result := FCaption;
  if (Owner <> nil) and (Owner is TForm) then
    Result := (Owner as TForm).Caption;
  LogOK;
  finally
  Log( '<-TKOLForm.GetCaption' );
  end;
end;

function TKOLForm.GetFormMain: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetFormMain', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GetFormMain' );
  try
  Result := fFormMain;
  if KOLProject <> nil then
    Result := KOLProject.Owner = Owner;
  LogOK;
  finally
  Log( '<-TKOLForm.GetFormMain' );
  end;
end;

function TKOLForm.GetFormName: KOLString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetFormName', 0
  @@e_signature:
  end;
  //Log( '->TKOLForm.GetFormName' );
  try
  Result := '';
  if Owner <> nil then
    Result := Owner.Name;
  LogOK;
  finally
  //Log( '<-TKOLForm.GetFormName' );
  end;
end;

var LastSrcLocatedWarningTime: Integer;

function TKOLForm.GetFormUnit: KOLString;
var
    I, J: Integer;
    S, S1, S2: KOLString;
    Dpr: TStringList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetFormUnit', 0
  @@e_signature:
  end;
  //Log( '->TKOLForm.GetFormUnit' );
  try
  Result := fFormUnit;
  if Result = '' then
  if ProjectSourcePath <> '' then
  begin
    S := ProjectSourcePath;
    if S[ Length( S ) ] <> '\' then
      S := S + '\';
    S1 := S;
    S := S + Get_ProjectName + '.dpr';
    if FileExists( S ) then
    begin
      Dpr := TStringList.Create;
      LoadSource( Dpr, S );
      for I := 0 to Dpr.Count - 1 do
      begin
        S := Trim( Dpr[ I ] );
        J := pos( '{' + LowerCase( FormName ) + '}', LowerCase( S ) );
        if (J > 0) and (pos( '''', S ) > 0) then
        begin
          J := pos( '''', S );
          S := Copy( S, J + 1, Length( S ) - J );
          J := pos( '''', S );
          if J > 0 then
          begin
            S := Copy( S, 1, J - 1 );
            if pos( ':', S ) < 1 then
              S := S1 + S;
            S2 := ExtractFilePath( S );
            S := ExtractFileName( S );
            if (S2 <> '') and (LowerCase( S2 ) <> LowerCase( S1 )) then
            begin
              if Abs( Integer( GetTickCount ) - LastSrcLocatedWarningTime ) > 60000 then
              begin
                LastSrcLocatedWarningTime := GetTickCount;
                ShowMessage( 'Source unit ' + S + ' is located not in the same ' +
                             'directory as SourcePath of TKOLProject component. ' +
                             'This can cause problems with converting project.' );
              end;
              //LogOK;
              Exit;
            end;
            J := pos( '.', S );
            if J > 0 then S := Copy( S, 1, J - 1 );
            Result := S;
            fFormUnit := S;
            //LogOK;
            Exit;
          end;
        end;
      end;
      Dpr.Free;
    end;
  end;
  //LogOK;
  finally
  //Log( '<-TKOLForm.GetFormUnit' );
  end;
end;

function TKOLForm.GetSelf: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetSelf', 0
  @@e_signature:
  end;
  Result := Self;
end;

function TKOLForm.Get_Color: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Get_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Get_Color' );
  try
  Result := (Owner as TForm).Color;
  LogOK;
  finally
  Log( '<-TKOLForm.Get_Color' );
  end;
end;

procedure TKOLForm.SetAlphaBlend(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetAlphaBlend', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetAlphaBlend' );
  try
  if not FLocked then
  begin
    if not (csLoading in ComponentState) then
      if Value = 0 then Value := 256;
    if Value < 0 then Value := 255;
    if Value > 256 then Value := 256;
    FAlphaBlend := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetAlphaBlend' );
  end;
end;

procedure TKOLForm.SetCanResize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCanResize', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCanResize' );
  try
  if not FLocked then
  begin
    fCanResize := Value;
  {YS}
    if (FborderStyle = fbsDialog) and Value then
      FborderStyle := fbsSingle;
  {YS}
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCanResize' );
  end;
end;

procedure TKOLForm.SetCenterOnScr(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCenterOnScr', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCenterOnScr' );
  try
  if not FLocked then
  begin
    fCenterOnScr := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCenterOnScr' );
  end;
end;

procedure TKOLForm.SetCloseIcon(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCloseIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCloseIcon' );
  try
  if not FLocked then
  begin
    FCloseIcon := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCloseIcon' );
  end;
end;

procedure TKOLForm.SetCtl3D(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCtl3D', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCtl3D' );
  try
  if not FLocked then
  begin
    FCtl3D := Value;
    (Owner as TForm).Ctl3D := Value;
    (Owner as TForm).Invalidate;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCtl3D' );
  end;
end;

procedure TKOLForm.SetCursor(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetCursor', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetCursor' );
  try
  if not FLocked then
  begin
    FCursor := UpperCase( Value );
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetCursor' );
  end;
end;

procedure TKOLForm.SetDefaultPos(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetDefaultPos', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetDefaultPos' );
  try
  if not FLocked then
  begin
    fDefaultPos := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetDefaultPos' );
  end;
end;

procedure TKOLForm.SetDefaultSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetDefaultSize', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetDefaultSize' );
  try
  if not FLocked then
  begin
    fDefaultSize := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetDefaultSize' );
  end;
end;

procedure TKOLForm.SetDoubleBuffered(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetDoubleBuffered', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetDoubleBuffered' );
  try

  if not FLocked then
  begin
    FDoubleBuffered := Value;
    Change( Self );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetDoubleBuffered' );
  end;
end;

procedure TKOLForm.SetFont(const Value: TKOLFont);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFont' );
  try

  if not FLocked and not fFont.Equal2( Value ) then
  begin
    CollectChildrenWithParentFont;
    fFont.Assign( Value );
    if KOLProject <> nil then
    begin
        FontDefault := fFont.Equal2(KOLProject.DefaultFont);
        Change(Self);
    end;
    ApplyFontToChildren;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFont' );
  end;
end;


procedure TKOLForm.SetFormCaption(const Value: TDelphiString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormCaption' );
  try

  if not FLocked then
  begin
    inherited Caption := Value;
    if (Owner <> nil) and (Owner is TForm) then
      (Owner as TForm).Caption := Value;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetFormCaption' );
  end;
end;

procedure TKOLForm.SetFormMain(const Value: Boolean);
var I: Integer;
    F: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormMain', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormMain' );
  try

  if not FLocked then
  begin

    if fFormMain <> Value then
    begin
      if Value then
      begin
        for I := 0 to FormsList.Count - 1 do
        begin
          F := FormsList[ I ];
          if F <> Self then
            F.FormMain := False;
        end;
      end;
      fFormMain := Value;
      Change( Self );
    end;

  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFormMain' );
  end;
end;

procedure TKOLForm.SetFormName(const Value: KOLString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormName', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormName' );
  try

  if not FLocked then
  begin

    if KOLProject = nil then
    if (Value <> FormName) and (Value <> '') and (FormName <> '') then
    begin
      ShowMessage( 'Form name can not be changed properly, if main form (form with ' +
                   'TKOLProject component on it) is not opened in designer.'#13 +
                   'Operation failed.' );
      LogOK;
      Exit;
    end;
    if Owner <> nil then
    try
      Owner.Name := Value;
      Change( Self );
    except
      ShowMessage( 'Name "' + Value + '" can not be used as a name for form '+
                   'variable. Use another one, please.' );
      LogOK;
      exit;
    end;

  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFormName' );
  end;
end;


procedure TKOLForm.SetFormUnit(const Value: KOLString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFormUnit', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetFormUnit' );
  try

  if not FLocked then
  begin
    fFormUnit := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetFormUnit' );
  end;
end;

procedure TKOLForm.SetHasBorder(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetHasBorder', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetHasBorder' );
  try

  if not FLocked then
  begin
    FHasBorder := Value;
  {YS}
    if not Value then
      FborderStyle := fbsNone
    else
      if FborderStyle = fbsNone then
        FborderStyle := fbsSingle;
  {YS}
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetHasBorder' );
  end;
end;

procedure TKOLForm.SetHasCaption(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetHasCaption', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetHasCaption' );
  try

  if not FLocked then
  begin
    FHasCaption := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetHasCaption' );
  end;
end;

procedure TKOLForm.SetIcon(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetIcon' );
  try

  if not FLocked then
  begin
    FIcon := UpperCase( Value );
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetIcon' );
  end;
end;

procedure TKOLForm.SetMargin(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMargin', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMargin' );
  try

  if not FLocked then
  begin
    if fMargin <> Value then
    begin
      fMargin := Value;
      AlignChildren( nil, FALSE );
      Change( Self );
    end;
    // Invalidate;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMargin' );
  end;
end;

procedure TKOLForm.SetMaximizeIcon(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMaximizeIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMaximizeIcon' );
  try

  if not FLocked then
  begin
    FMaximizeIcon := Value;
    if Value then
      helpContextIcon := FALSE;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMaximizeIcon' );
  end;
end;

procedure TKOLForm.SetMinimizeIcon(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMinimizeIcon', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMinimizeIcon' );
  try

  if not FLocked then
  begin
    FMinimizeIcon := Value;
    if Value then
      helpContextIcon := FALSE;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMinimizeIcon' );
  end;
end;

procedure TKOLForm.SetModalResult(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetModalResult', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetModalResult' );
  try

  if not FLocked then
    FModalResult := Value;

  LogOK;
  finally
  Log( '<-TKOLForm.SetModalResult' );
  end;
end;

procedure TKOLForm.SetOnChar(const Value: TOnChar);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnChar', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnChar' );
  try

  if not FLocked then
  begin
    FOnChar := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnChar' );
  end;
end;

procedure TKOLForm.SetOnClick(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnClick', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnClick' );
  try

  if not FLocked then
  begin
    fOnClick := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnClick' );
  end;
end;

procedure TKOLForm.SetOnFormCreate(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnFormCreate', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnFormCreate' );
  try

  if not FLocked then
  begin
    FOnFormCreate := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnFormCreate' );
  end;
end;

procedure TKOLForm.SetOnEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnEnter', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnEnter' );
  try

  if not FLocked then
  begin
    FOnEnter := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnEnter' );
  end;
end;

procedure TKOLForm.SetOnKeyDown(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnKeyDown', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnKeyDown' );
  try

  if not FLocked then
  begin
    FOnKeyDown := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnKeyDown' );
  end;
end;

procedure TKOLForm.SetOnKeyUp(const Value: TOnKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnKeyUp', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnKeyUp' );
  try

  if not FLocked then
  begin
    FOnKeyUp := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnKeyUp' );
  end;
end;

procedure TKOLForm.SetOnLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnLeave', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnLeave' );
  try

  if not FLocked then
  begin
    FOnLeave := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnLeave' );
  end;
end;

procedure TKOLForm.SetOnMouseDown(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseDown', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseDown' );
  try

  if not FLocked then
  begin
    FOnMouseDown := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseDown' );
  end;
end;

procedure TKOLForm.SetOnMouseEnter(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseEnter', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseEnter' );
  try

  if not FLocked then
  begin
    FOnMouseEnter := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseEnter' );
  end;
end;

procedure TKOLForm.SetOnMouseLeave(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseLeave', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseLeave' );
  try

  if not FLocked then
  begin
    FOnMouseLeave := Value;
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseLeave' );
  end;
end;

procedure TKOLForm.SetOnMouseMove(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseMove', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseMove' );
  try

  if not FLocked then
  begin
  FOnMouseMove := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseMove' );
  end;
end;

procedure TKOLForm.SetOnMouseUp(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseUp', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseUp' );
  try

  if not FLocked then
  begin
  FOnMouseUp := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseUp' );
  end;
end;

procedure TKOLForm.SetOnMouseWheel(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseWheel', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseWheel' );
  try

  if not FLocked then
  begin
  FOnMouseWheel := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseWheel' );
  end;
end;

procedure TKOLForm.SetOnResize(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnResize', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnResize' );
  try

  if not FLocked then
  begin
  FOnResize := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnResize' );
  end;
end;

procedure TKOLForm.SetPreventResizeFlicks(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetPreventResizeFlicks', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.PreventResizeFlicks' );
  try

  if not FLocked then
  begin
  FPreventResizeFlicks := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.PreventResizeFlicks' );
  end;
end;

procedure TKOLForm.SetStayOnTop(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetStayOnTop', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetStayOnTop' );
  try

  if not FLocked then
  begin
  FStayOnTop := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetStayOnTop' );
  end;
end;

procedure TKOLForm.SetTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetTransparent', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetTransparent' );
  try

  if not FLocked then
  begin
  FTransparent := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetTransparent' );
  end;
end;

const BrushStyles: array[ TBrushStyle ] of String = ( 'bsSolid', 'bsClear',
      'bsHorizontal', 'bsVertical', 'bsFDiagonal', 'bsBDiagonal', 'bsCross',
      'bsDiagCross' );
procedure TKOLForm.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
const WindowStates: array[ KOL.TWindowState ] of String = ( 'wsNormal',
      'wsMinimized', 'wsMaximized' );
var I: Integer;
    S: string; {YS}
    MainMenuHeight: Integer;
    C: String;
{$IFDEF _D2009orHigher}
    C2: WideString;
    j : integer;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetupFirst', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetupFirst' );
  try

  if FLocked then
  begin
    Rpt( 'Form ' + Name + ' is LOCKED.', YELLOW );
    LogOK; Exit;
  end;

  // Установка каких-либо свойств формы - тех, которые выполняются
  // сразу после конструирования объекта формы:
  if  Unicode then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSetUnicode', '' )
      else
          SL.Add( '     Result.Form.SetUnicode(TRUE);' );
  SetupName( SL, AName, AParent, Prefix );
  if  Tag <> 0 then
  begin
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetTag', '' );
          FormAddNumParameter( Tag );
      end
      else
      if  Tag < 0 then
          SL.Add( Prefix + AName + '.Tag := DWORD(' + IntToStr( Tag ) + ');' )
      else
          SL.Add( Prefix + AName + '.Tag := ' + IntToStr( Tag ) + ';' );
  end;

  //Log( '&2 TKOLForm.SetupFirst' );

  if  not statusSizeGrip then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSizeGripFalse', '' )
      else
          SL.Add( Prefix + AName + '.SizeGrip := FALSE;' );

  //Log( '&3 TKOLForm.SetupFirst' );

{YS}
  if  FormCompact then
  begin
      I := 0;
      case FborderStyle of
      fbsDialog: I := I or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE;
      fbsToolWindow:  I := I or WS_EX_TOOLWINDOW;
      end;
      if  helpContextIcon then
          I := I or WS_EX_CONTEXTHELP;
      if  I <> 0 then
      begin
          FormAddCtlCommand( 'Form', 'FormSetExStyle', '' );
          FormAddNumParameter( I );
      end;
  end
    else
  begin
      S := '';
      case FborderStyle of
      fbsDialog:
          S := S + ' or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE';
      fbsToolWindow:
          S := S + ' or WS_EX_TOOLWINDOW';
      end;

      //Log( '&4 TKOLForm.SetupFirst' );

      if  helpContextIcon then
          S := S + ' or WS_EX_CONTEXTHELP';
      if  S <> '' then
          SL.Add( Prefix + AName + '.ExStyle := ' + AName + '.ExStyle' + S + ';' );
  end;
  //Log( '&5 TKOLForm.SetupFirst' );

{YS}
  if  not Visible then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSetVisibleFalse', '' )
      else
          SL.Add( Prefix + AName + '.Visible := False;' );

  if  not Enabled then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSetEnabledFalse', '' )
      else
          SL.Add( Prefix + AName + '.Enabled := False;' );

  if  DoubleBuffered and not Transparent then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSetDoubleBufferedTrue', '' )
      else
          SL.Add( Prefix + AName + '.DoubleBuffered := True;' );
{YS}

  //Log( '&6 TKOLForm.SetupFirst' );

  if  FormCompact then
  begin
      I := 0;
      CASE FborderStyle OF
      fbsDialog: I := I or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
      fbsToolWindow, fbsNone: ;
      else
          if  not MinimizeIcon and not MaximizeIcon then
              I := I or WS_MINIMIZEBOX or WS_MAXIMIZEBOX
          else
          begin
              if  not MinimizeIcon then
                  I := I or WS_MINIMIZEBOX;
              if  not MaximizeIcon then
                  I := I or WS_MAXIMIZEBOX;
          end;
      END;
      if  I <> 0 then
      begin
          FormAddCtlCommand( 'Form', 'FormResetStyles', '' );
          FormAddNumParameter( I );
      end;
  end
    else
  begin
      S := '';
      case FborderStyle of
        fbsDialog:
          S := S + ' and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX)';
        fbsToolWindow, fbsNone:
          ;
        else
          begin
            if not MinimizeIcon and not MaximizeIcon then
              S := S + ' and not (WS_MINIMIZEBOX or WS_MAXIMIZEBOX)'
            else
            begin
              if not MinimizeIcon then
                S := S + ' and not WS_MINIMIZEBOX';
              if not MaximizeIcon then
                S := S + ' and not WS_MAXIMIZEBOX';
            end;
          end;
      end;

      //Log( '&7 TKOLForm.SetupFirst' );
      //if not CanResize then
      //  S := S + ' and not WS_THICKFRAME';

      if S <> '' then
        SL.Add( Prefix + AName + '.Style := ' + AName + '.Style' + S + ';' );
  end;

  if  not DefaultSize then
  begin
      if  HasCaption then
      begin
          if  HasMainMenu then
              MainMenuHeight := GetSystemMetrics( SM_CYMENU )
          else
              MainMenuHeight := 0;
          if  HasBorder then
              if  FormCompact then
              begin
                  FormAddCtlCommand( 'Form', 'FormSetClientSize', '' );
                  FormAddNumParameter( (Owner as TForm).ClientWidth );
                  FormAddNumParameter( (Owner as TForm).ClientHeight + MainMenuHeight );
              end
              else
                  SL.Add( Prefix + AName + '.SetClientSize( ' +
                     IntToStr( (Owner as TForm).ClientWidth ) +
                     ', ' + IntToStr( (Owner as TForm).ClientHeight + MainMenuHeight ) + ' );' );
      end
      //+++++++ UaFM
      else
        if  HasBorder then
            if  FormCompact then
            begin
                Form.FormAddCtlCommand( 'Form', 'FormSetClientSize', '' );
                Form.FormAddNumParameter( (Owner as TForm).ClientWidth );
                Form.FormAddNumParameter( (Owner as TForm).ClientHeight-GetSystemMetrics(SM_CYCAPTION) );
            end
              else
            SL.Add( Prefix + AName +  '.SetClientSize( ' +
                    IntToStr( (Owner as TForm).ClientWidth ) +
                    ', ' +
                    IntToStr( (Owner as TForm).ClientHeight-GetSystemMetrics(SM_CYCAPTION) )
                    + ');' );
  end;

   //Log( '&8 TKOLForm.SetupFirst' );

{YS}

  if  Transparent then
      if  FormCompact then
          FormAddCtlCommand( Name, 'TControl.SetTransparent', '' ) // param = 1
      else
          SL.Add( Prefix + AName + '.Transparent := True;' );

  if  (AlphaBlend <> 255) and (AlphaBlend > 0) then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetAlphaBlend', '' );
          FormAddNumParameter( AlphaBlend and $FF );
      end
        else
      SL.Add( Prefix + AName + '.AlphaBlend := ' + IntToStr( AlphaBlend and $FF ) + ';' );

  if  not HasBorder then
  begin
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetHasBorderFalse', '' );
          FormAddCtlCommand( 'Form', 'FormSetClientSize', '' );
          FormAddNumParameter( (Owner as TForm).ClientWidth );
          FormAddNumParameter( (Owner as TForm).ClientHeight );
      end
        else
      begin
          SL.Add( Prefix + AName + '.HasBorder := False;' );
          SL.Add( Prefix + AName + '.SetClientSize( ' +
                     IntToStr( (Owner as TForm).ClientWidth ) +
                     ', ' + IntToStr( (Owner as TForm).ClientHeight )
                     + ');' );
      end;
  end;

  if  not HasCaption and HasBorder then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSetHasCaptionFalse', '' )
      else
          SL.Add( Prefix + AName + '.HasCaption := False;' );

  if  StayOnTop then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'TControl.SetStayOnTop', '' )
      else
          SL.Add( Prefix + AName + '.StayOnTop := True;' );

  if  not Ctl3D then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormResetCtl3D', '' )
      else
          SL.Add( Prefix + AName + '.Ctl3D := False;' );

  if  Icon <> '' then
  begin
      if  Copy( Icon, 1, 1 ) = '#' then // +Alexander Pravdin
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormIconLoad_hInstance', '' );
              FormAddNumParameter( StrToInt( Copy( Icon, 2, Length( Icon ) - 1 ) ) )
          end
          else
          SL.Add( Prefix + AName + '.IconLoad( hInstance, MAKEINTRESOURCE( ' +
            Copy( Icon, 2, Length( Icon ) - 1 ) + ' ) );' )
      else
      if  Copy( Icon, 1, 4 ) = 'IDC_' then
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormIconLoadCursor_0', '' );
              FormAddNumParameter( IDC2Number( Icon ) );
          end
          else
          SL.Add( Prefix + AName + '.IconLoadCursor( 0, MAKEINTRESOURCE(' + Icon + ') );' )
      else
      if  Copy( Icon, 1, 4 ) = 'IDI_' then
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormIconLoadCursor_0', '' );
              FormAddNumParameter( IDI2Number( Icon ) );
          end
          else
          SL.Add( Prefix + AName + '.IconLoadCursor( 0, MAKEINTRESOURCE(' + Icon + ') );' )
      else
      if  Icon = '-1' then
          if  FormCompact then
              FormAddCtlCommand( 'Form', 'FormSetIconNeg1', '' )
          else
              SL.Add( Prefix + AName + '.Icon := THandle(-1);' )
      else
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormIconLoad_hInstance_str', '' );
              FormAddStrParameter( Icon )
          end
          else
          SL.Add( Prefix + AName + '.IconLoad( hInstance, ''' + Icon + ''' );' );
  end;

  if  WindowState <> KOL.wsNormal then
      if  FormCompact then
      begin
          if  Integer( WindowState ) = 1 then
          begin
              FormAddCtlCommand( 'Form', 'TControl.SetWindowState', '' );
              // param = 1
          end
            else
          begin
              FormAddCtlCommand( 'Form', 'FormSetWindowState', '' );
              FormAddNumParameter( Integer( WindowState ) );
          end;
      end
      else
      SL.Add( Prefix + AName + '.WindowState := ' + WindowStates[ WindowState ] +
            ';' );

  if  Trim( Cursor ) <> '' then
  begin
      if  Copy( Cursor, 1, 4 ) = 'IDC_' then
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormCursorLoad_0', '' );
              FormAddNumParameter( IDC2Number( Cursor ) );
          end
          else
          SL.Add( Prefix + AName + '.CursorLoad( 0, ' + Cursor + ' );' )
      else
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormCursorLoad_hInstance', '' );
              FormAddStrParameter( Trim( Cursor ) );
          end
          else
          SL.Add( Prefix + AName + '.CursorLoad( hInstance, ''' + Trim( Cursor ) + ''' );' );
  end;

  if  Brush <> nil then
      Brush.GenerateCode( SL, AName );

  if  (Font <> nil) then
  begin
      if  FontDefault and (KOLProject <> nil)
      and Assigned(KOLProject.DefaultFont)
      and not KOLProject.DefaultFont.Equal2(nil)
      and not KOLProject.DefaultFont.Equal2(Font) then
      begin
          Rpt( 'KOLProject font is assigned to form.Font', WHITE );
          Font.Assign(KOLProject.DefaultFont);
          Rpt( 'KOLProject font was assigned to form.Font', WHITE );
      end;
      if  not Font.Equal2( nil ) then
      begin
          Font.GenerateCode( SL, AName, nil );
          Rpt( 'form font code generated', WHITE );
      end;
  end;

  if  Border <> 2 then
      if  FormCompact then
      begin
          if  Border = 1 then
          begin
              FormAddCtlCommand( 'Form', 'TControl.SetBorder', '' );
              // param = 1
          end
            else
          begin
              FormAddCtlCommand( 'Form', 'FormSetBorder', '' );
              FormAddNumParameter( Border );
          end;
      end else
      SL.Add( Prefix + AName + '.Border := ' + IntToStr( Border ) + ';' );

  if  MarginTop <> 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMarginTop', '' );
          FormAddNumParameter( MarginTop );
      end else
      SL.Add( Prefix + AName + '.MarginTop := ' + IntToStr( MarginTop ) + ';' );

  if  MarginBottom <> 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMarginBottom', '' );
          FormAddNumParameter( MarginBottom );
      end else
      SL.Add( Prefix + AName + '.MarginBottom := ' + IntToStr( MarginBottom ) + ';' );

  if  MarginLeft <> 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMarginLeft', '' );
          FormAddNumParameter( MarginLeft );
      end else
      SL.Add( Prefix + AName + '.MarginLeft := ' + IntToStr( MarginLeft ) + ';' );

  if  MarginRight <> 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMarginRight', '' );
          FormAddNumParameter( MarginRight );
      end else
      SL.Add( Prefix + AName + '.MarginRight := ' + IntToStr( MarginRight ) + ';' );

  RptDetailed( 'margins ready', WHITE );

  if (FStatusText <> nil) and (FStatusText.Text <> '') then
  begin
    if  FStatusText.Count = 1 then
    begin
        if  FormCompact then
        begin
            FormAddCtlCommand( 'Form', 'FormSetSimpleStatusText', '' );
            FormAddStrParameter( FStatusText[ 0 ] );
        end else
        begin
            {$IFDEF _D2009orHigher}
            C := FStatusText[ 0 ];
            C2 := '';
            for j := 1 to Length(C) do C2 := C2 + '#'+int2str(ord(C[j]));
            C := C2;
            {$ELSE}
            C := PCharStringConstant( Self, 'SimpleStatusText', FStatusText[ 0 ] );
            {$ENDIF}
            SL.Add( Prefix + AName + '.SimpleStatusText := ' + C + ';' );
        end;
    end
    else
    begin
        for I := 0 to FStatusText.Count-1 do
        begin
            if  FormCompact then
            begin
                FormAddCtlCommand( 'Form', 'FormSetStatusText', '' );
                FormAddNumParameter( I );
                FormAddStrParameter( FStatusText[ I ] );
            end else
            begin
                {$IFDEF _D2009orHigher}
                C := FStatusText[ I ];
                C2 := '';
                for j := 1 to Length(C) do
                    C2 := C2 + '#'+int2str(ord(C[j]));
                C := C2;
                {$ELSE}
                C := PCharStringConstant( Self, 'StatusText' + IntToStr( I ), FStatusText[ I ] );
                {$ENDIF}
                SL.Add( Prefix + AName + '.StatusText[ ' + IntToStr( I ) + ' ] := ' + C + ';' );
            end;
        end;
      end;
  end;

  if  not CloseIcon then
  begin
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormRemoveCloseIcon', '' )
      else
          SL.Add( Prefix + 'DeleteMenu( GetSystemMenu( Result.Form.GetWindowHandle, ' +
            'False ), SC_CLOSE, MF_BYCOMMAND );' );
  end;

  if  EraseBackground then
      if  FormCompact then
          FormAddCtlCommand( 'Form', 'FormSetEraseBkgndTrue', '' )
      else
          SL.Add( Prefix + AName + '.EraseBackground := TRUE;' );

  if  MinWidth > 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMinWidth', '' );
          FormAddNumParameter( MinWidth );
      end else
      SL.Add( Prefix + AName + '.MinWidth := ' + IntToStr( MinWidth ) + ';' );

  if  MinHeight > 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMinHeight', '' );
          FormAddNumParameter( MinHeight );
      end else
      SL.Add( Prefix + AName + '.MinHeight := ' + IntToStr( MinHeight ) + ';' );

  if  MaxWidth > 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMaxWidth', '' );
          FormAddNumParameter( MaxWidth );
      end else
      SL.Add( Prefix + AName + '.MaxWidth := ' + IntToStr( MaxWidth ) + ';' );

  if  MaxHeight > 0 then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetMaxHeight', '' );
          FormAddNumParameter( MaxHeight );
      end else
      SL.Add( Prefix + AName + '.MaxHeight := ' + IntToStr( MaxHeight ) + ';' );

  if  KeyPreview then
      if  FormCompact then
      begin
          FormAddCtlCommand( 'Form', 'FormSetKeyPreviewTrue', '' );
      end else
      SL.Add( Prefix + AName + '.KeyPreview := TRUE;' );

  if  AllBtnReturnClick then
  begin
      if  FormMain and not AppletOnForm then
      begin
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'TControl.AllBtnReturnClick', '' );
          end else
          SL.Add( Prefix + AName + '.AllBtnReturnClick;' );
      end;
  end;
  RptDetailed( 'Before AssignEvents for form', WHITE );

  FAssignOnlyUserEvents := FALSE;
  FAssignOnlyWinEvents := FALSE;
  AssignEvents( SL, AName );

  RptDetailed( 'After AssignEvents for form', WHITE );

  LogOK;
  finally
  Log( '<-TKOLForm.SetupFirst' );
  end;
end;

procedure TKOLForm.SetupLast(SL: TStringList; const AName,
  AParent, Prefix: String);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetupLast', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetupLast' );
  try

  if not FLocked then
  begin
      S := '';
      if  CenterOnScreen then
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'TControl.CenterOnParent', '' );
          end else
          S := Prefix + AName + '.CenterOnParent';

      if  not CanResize then
      begin
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormSetCanResizeFalse', '' );
          end
            else
          begin
              if  S = '' then
                  S := Prefix + AName;
              S := S + '.CanResize := False'
          end;
      end;
      if  (S <> '') and not FormCompact then
          SL.Add( S + ';' );

      if  not CanResize or not MinimizeIcon or not MaximizeIcon then
          if  FormCompact then
          begin
              FormAddCtlCommand( 'Form', 'FormInitMenu', '' );
          end else
          SL.Add( Prefix + AName + '.Perform( WM_INITMENU, 0, 0 );' );

      if  MinimizeNormalAnimated then
          if  FormCompact then
              FormAddCtlCommand( 'Form', 'TControl.MinimizeNormalAnimated', '' )
          else
              SL.Add( Prefix + AName + '.MinimizeNormalAnimated;' )
      else
      if  RestoreNormalMaximized then
          if  FormCompact then
              FormAddCtlCommand( 'Form', 'TControl.RestoreNormalMaximized', '' )
          else
              SL.Add( Prefix + AName + '.RestoreNormalMaximized;' );

      if  Assigned( FpopupMenu ) then
          SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
                ' );' );

      if  @ OnFormCreate <> nil then
      begin
          SL.Add( Prefix + 'Result.' + (Owner as TForm).MethodName( @ OnFormCreate ) + '( Result );' );
      end;
    {YS}
      if  FborderStyle = fbsDialog then
          if  FormCompact then
              FormAddCtlCommand( 'Form', 'FormSetIconNeg1', '' )
          else
              SL.Add( Prefix + AName + '.Icon := THandle(-1);' );
    {YS}
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetupLast' );
  end;
end;

procedure TKOLForm.SetWindowState(const Value: KOL.TWindowState);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetWindowState', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetWindowState' );
  try

  if not FLocked then
  begin
  FWindowState := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetWindowState' );
  end;
end;

procedure TKOLForm.Set_Bounds(const Value: TFormBounds);
begin
  if  (fBounds.Left=Value.Left)
  and (fBounds.Top =Value.Top )
  and (fBounds.Width = Value.Width)
  and (fBounds.Height= Value.Height) then
      Exit;
  fBounds := Value;
  if  Owner is TCustomForm then
  begin
      (Owner as TCustomForm).Left := Value.Left;
      (Owner as TCustomForm).Top  := Value.Top;
      (Owner as TCustomForm).Width:= Value.Width;
      (Owner as TCustomForm).Height := Value.Height;
  end;
end;

procedure TKOLForm.Set_Color(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Set_Color', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Set_Color' );
  try

  if not FLocked then
  begin
    if Color <> Value then
    begin
    CollectChildrenWithParentColor;
    (Owner as TForm).Color := Value;
    FBrush.FColor := Value;
    ApplyColorToChildren;
    Change( Self );
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.Set_Color' );
  end;
end;

procedure TKOLForm.ApplyFontToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.ApplyFontToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.ApplyFontToChildren' );
  try

  if not FLocked then
  begin
  for I := 0 to FParentLikeFontControls.Count - 1 do
  begin
    C := FParentLikeFontControls[ I ];
    //if C.parentFont then
      C.Font.Assign( Font );
  end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.ApplyFontToChildren' );
  end;
end;

procedure TKOLForm.CollectChildrenWithParentFont;
var ParentForm: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.CollectChildrenWithParentFont' );
  try

  if not (Owner is TForm) then
  begin
    LogOK;
    Exit;
  end;
  ParentForm := Owner as TForm;
  FParentLikeFontControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = ParentForm) then
    if (C as TKOLCustomControl).parentFont then
      FParentLikeFontControls.Add( C );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.CollectChildrenWithParentFont' );
  end;
end;

procedure TKOLForm.ApplyColorToChildren;
var I: Integer;
    C: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.ApplyColorToChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.ApplyColorToChildren' );
  try

  if not FLocked then
  begin
    for I := 0 to FParentLikeColorControls.Count - 1 do
    begin
      C := FParentLikeColorControls[ I ];
      if C.parentColor and (C.Color <> Color) then
        C.Color := Color;
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.ApplyColorToChildren' );
  end;
end;

procedure TKOLForm.CollectChildrenWithParentColor;
var ParentForm: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.CollectChildrenWithParentFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.CollectChildrenWithParentColor' );
  try

  if not (Owner is TForm) then
  begin
    LogOK;
    Exit;
  end;
  ParentForm := Owner as TForm;
  FParentLikeColorControls.Clear;
  for I := 0 to ParentForm.ComponentCount - 1 do
  begin
    C := ParentForm.Components[ I ];
    if (C is TKOLCustomControl) and ((C as TKOLCustomControl).Parent = ParentForm) then
    if (C as TKOLCustomControl).parentColor then
      FParentLikeColorControls.Add( C );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.CollectChildrenWithParentColor' );
  end;
end;

function TKOLForm.NextUniqueID: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.NextUniqueID', 0
  @@e_signature:
  end;
  //Log( '->TKOLForm.NextUniqueID' );
  try

  Result := fUniqueID;
  Inc( fUniqueID );

  LogOK;
  finally
  //Log( '<-TKOLForm.NextUniqueID' );
  end;
end;

procedure TKOLForm.SetMinimizeNormalAnimated(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMinimizeNormalAnimated', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMinimizeNormalAnimated' );
  try

  if not FLocked then
  begin
  FMinimizeNormalAnimated := Value;
  Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetMinimizeNormalAnimated' );
  end;
end;

procedure TKOLForm.SetLocked(const Value: Boolean);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetLocked', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetLocked' );
  try

  if FLocked = Value then
  begin
    Rpt( 'Form ' + Name + ' made LOCKED.', RED );
    LogOK; Exit;
  end;
  if not Value then
  begin
    for I := 0 to Owner.ComponentCount-1 do
      if IsVCLControl( Owner.Components[ I ] ) then
      begin
        ShowMessage( 'Form ' + Owner.Name + ' contains VCL controls. TKOLForm ' +
                     'component can not be unlocked.' );
        LogOK;
        Exit;
      end;
    I := MessageBox( 0, 'TKOLForm component was locked because the form had ' +
         'VCL controls placed on it. Are You sure You want to unlock TKOLForm?'#13 +
         '(Note: if the form is beloning to VCL-based project, unlocking TKOLForm ' +
         'component can damage the form).', 'CAUTION!', MB_YESNO or MB_SETFOREGROUND );
    if I = ID_NO then
    begin
      LogOK;
      Exit;
    end;
  end;
  FLocked := Value;

  LogOK;
  finally
  Log( '<-TKOLForm.SetLocked' );
  end;
end;

procedure TKOLForm.SetOnShow(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnShow', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnShow' );
  try

  FOnShow := Value;
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnShow' );
  end;
end;

procedure TKOLForm.SetOnHide(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnHide', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnHide' );
  try
  FOnHide := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnHide' );
  end;
end;

procedure TKOLForm.SetzOrderChildren(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetzOrderChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetzOrderChildren' );
  try
  FzOrderChildren := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetzOrderChildren' );
  end;
end;

procedure TKOLForm.SetSimpleStatusText(const Value: TDelphiString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetSimpleStatusText', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetSimpleStatusText' );
  try
  FSimpleStatusText := Value;
  FStatusText.Text := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetSimpleStatusText' );
  end;
end;

function TKOLForm.GetStatusText: TStrings;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetStatusText', 0
  @@e_signature:
  end;
  Result := FStatusText;
end;

procedure TKOLForm.SetStatusText(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetStatusText', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetStatusText' );
  try
  if Value = nil then
    FStatusText.Text := ''
  else
    FStatusText.Text := Value.Text;
  if FStatusText.Count = 1 then
    FSimpleStatusText := FStatusText.Text
  else
    FSimpleStatusText := '';
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetStatusText' );
  end;
end;

procedure TKOLForm.SetOnMouseDblClk(const Value: TOnMouse);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMouseDblClk', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMouseDblClk' );
  try
  fOnMouseDblClk := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMouseDblClk' );
  end;
end;

procedure TKOLForm.GenerateCreateForm(SL: TStringList);
var
  C: String;
{$IFDEF _D2009orHigher}
  C2: WideString;
 i : integer;
{$ENDIF}
S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateCreateForm', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateCreateForm' );
  try

  Rpt( 'GenerateCreateForm ' + FormName, CYAN + LIGHT );

{$IFDEF _D2009orHigher}
  if  AssignTextToControls then
      C := StringConstant( 'Caption', Caption )
  else
      C := '''''';
  if C <> '''''' then
   begin
    C2 := '';
    for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
    C := C2;
   end;
{$ELSE}
  if  AssignTextToControls then
      C := StringConstant( 'Caption', Caption )
  else
      C := '''''';
{$ENDIF}
  S := '';
  if  FormCompact then
  begin
      SL.Add( '  Result.Form := NewForm( AParent, ' + C +
              ' )' + S + ';' );
      // Если форма главная, и Applet не используется, инициализировать здесь
      // переменную Applet:
      if FormMain and not AppletOnForm then
         SL.Add( '  Applet :=  Result.Form;' );
      SL.Add( '  Result.Form.DF.FormAddress := @ Result.Form;' );
      SL.Add( '  Result.Form.DF.FormObj := Result;' );
      GenerateAdd2AutoFree( SL, 'Result', FALSE, '', nil );

      if  FormMain and AppletOnForm and (Applet <> nil) then
          Applet.AssignEvents( SL, 'Applet' );

      ClearBeforeGenerateForm( SL );
  end
    else
  begin
      S := GenerateTransparentInits;
      SL.Add( '  Result.Form := NewForm( AParent, ' + C +
              ' )' + S + ';' );
      // Если форма главная, и Applet не используется, инициализировать здесь
      // переменную Applet:
      if FormMain and not AppletOnForm then
         SL.Add( '  Applet :=  Result.Form;' );
      GenerateAdd2AutoFree( SL, 'Result', FALSE, '', nil );
  end;

  if @ OnBeforeCreateWindow <> nil then
    SL.Add( '      Result.' +
          (Owner as TForm).MethodName( @ OnBeforeCreateWindow ) + '( Result );' );
  LogOK;
  finally
  Log( '<-TKOLForm.GenerateCreateForm' );
  end;
end;

function TKOLForm.Result_Form: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Result_Form', 0
  @@e_signature:
  end;
  Result := 'Result.Form';
end;

procedure TKOLForm.GenerateDestroyAfterRun(SL: TStringList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateDestroyAfterRun', 0
  @@e_signature:
  end;
  // nothing
end;

procedure TKOLForm.SetMarginBottom(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginBottom', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginBottom' );
  try

  if FMarginBottom = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginBottom := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginBottom' );
  end;
end;

procedure TKOLForm.SetMarginLeft(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginLeft', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginLeft' );
  try

  if FMarginLeft = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginLeft := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginLeft' );
  end;
end;

procedure TKOLForm.SetMarginRight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginRight', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginRight' );
  try

  if FMarginRight = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginRight := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginRight' );
  end;
end;

procedure TKOLForm.SetMarginTop(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetMarginTop', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetMarginTop' );
  try

  if FMarginTop = Value then
  begin
    LogOK;
    Exit;
  end;
  FMarginTop := Value;
  AlignChildren( nil, FALSE );
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetMarginTop' );
  end;
end;

procedure TKOLForm.SetOnEraseBkgnd(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnEraseBkgnd', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnEraseBkgnd' );
  try

  FOnEraseBkgnd := Value;
  Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.SetOnEraseBkgnd' );
  end;
end;

procedure TKOLForm.SetOnPaint(const Value: TOnPaint);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnPaint', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnPaint' );
  try
  FOnPaint := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnPaint' );
  end;
end;

procedure TKOLForm.SetEraseBackground(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetEraseBackground', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetEraseBackground' );
  try
  FEraseBackground := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetEraseBackground' );
  end;
end;

procedure TKOLForm.GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateAdd2AutoFree' );
  try

  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
  begin
    LogOK;
    Exit;
  end;
  if  Add2AutoFreeProc = '' then
      Add2AutoFreeProc := 'Add2AutoFree';
  if  not AControl then
      SL.Add( '  Result.Form.' + Add2AutoFreeProc + '( ' + AName + ' );' );

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateAdd2AutoFree' );
  end;
end;

function TKOLForm.AdditionalUnits: String;
var I: Integer;
    C: TComponent;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AdditionalUnits', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AdditionalUnits' );
  try

  Result := '';
  for I := 0 to (Owner as TForm).ComponentCount-1 do
  begin
    C := (Owner as TForm).Components[ I ];
    S := '';
    if C is TKOLCustomControl then
      S := (C as TKOLCustomControl).AdditionalUnits
    else
    if C is TKOLObj then
      S := (C as TKOLObj).AdditionalUnits;
    if S <> '' then
      if pos(S, Result) = 0 then
      begin
        {if Result <> '' then
          Result := Result + ', ';}
        Result := Result + S;
      end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.AdditionalUnits' );
  end;
end;

function TKOLForm.FormTypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.FormTypeName', 0
  @@e_signature:
  end;
  Result := 'PControl';
end;

function TKOLForm.AfterGeneratePas(SL: TStringList): Boolean;
var s0, s: String;
    NomPrivate, NomC: Integer;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AfterGeneratePas', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AfterGeneratePas' );
  Result := FALSE;
  try

  // to change generated Pas after GeneratePas procedure - in descendants.
  //-------------------- added by Alexander Rabotyagov:
  s0:='private{$ENDIF} {<-- It is a VCL control}';
    s:='';
  repeat
    NomPrivate:=SL.IndexOf(s+s0);
  s:=s+' ';
  until not((NomPrivate<0)and(length(s)<15));
  if NomPrivate>=0 then SL[NomPrivate]:='  private';

  if not FLocked then
  for I := 0 to Owner.ComponentCount - 1 do
  begin
    C := Owner.Components[ I ];
    if C = Self then Continue;
    if (C is controls.TControl)and(not((C is TKOLApplet) or (C is TKOLCustomControl) or (C is TOleControl)))and(c.tag=cKolTag)
    then begin

       s0:=c.Name+': '+c.ClassName+';';
       s:='';
       repeat
         NomC:=SL.IndexOf(s+s0);
         s:=s+' ';
       until not((NomC<0)and(length(s)<15));

       s0:='private';
       s:='';
       repeat
         NomPrivate:=SL.IndexOf(s+s0);
         s:=s+' ';
       until not((NomPrivate<0)and(length(s)<15));

       if (NomC>=0)and(NomPrivate>=0)
       then begin
         Result := TRUE;
         SL.Insert(NomPrivate+1,'    {$IFNDEF KOL_MCK}'+c.Name+': '+c.ClassName+';{$ENDIF} {<-- It is a VCL control}');
         SL.Delete(NomC);
       end;

    end;
  end;//i

  LogOK;
  finally
  Log( '<-TKOLForm.AfterGeneratePas' );
  end;
end;

procedure TKOLForm.SetOnMove(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMove', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMove' );
  try
  FOnMove := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMove' );
  end;
end;

procedure TKOLForm.SetSupportMnemonics(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetSupportMnemonics', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetSupportAnsiMnemonics' );
  try
  FSupportMnemonics := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetSupportAnsiMnemonics' );
  end;
end;

procedure TKOLForm.SetStatusSizeGrip(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetStatusSizeGrip', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetStatusSizeGrip' );
  try
  FStatusSizeGrip := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetStatusSizeGrip' );
  end;
end;

procedure TKOLForm.SetPaintType(const Value: TPaintType);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetPaintType', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetPaintType' );
  try
  if FPaintType = Value then
  begin
    LogOK;
    Exit;
  end;
  FPaintType := Value;
  InvalidateControls;
  LogOK;
  finally
  Log( '<-TKOLForm.SetPaintType' );
  end;
end;

procedure TKOLForm.InvalidateControls;
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.InvalidateControls', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.InvalidateControls' );
  try

  if Owner = nil then
  begin
    LogOK;
    Exit;
  end;
  if not( Owner is TForm ) then
  begin
    LogOK;
    Exit;
  end;
  for I := 0 to (Owner as TForm).ComponentCount - 1 do
  begin
    C := (Owner as TForm).Components[ I ];
    if C is TKOLCustomControl then
{YS}
      with  C as TKOLCustomControl do begin
  {$IFDEF _KOLCtrlWrapper_}
        AllowSelfPaint := PaintType in [ptWYSIWIG, ptWYSIWIGFrames];
        AllowCustomPaint := PaintType <> ptWYSIWIG;  {<<<<<<<}
  {$ENDIF}
        Invalidate;
      end;
{YS}
  end;
  (Owner as TForm).Invalidate;

  LogOK;
  finally
  Log( '<-TKOLForm.InvalidateControls' );
  end;
end;

procedure TKOLForm.Loaded;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.Loaded', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.Loaded' );
  try

  inherited;
  GetPaintTypeFromProjectOrOtherForms;
  Font.Change;
  FChangeTimer.Enabled := FALSE;
  FChangeTimer.Enabled := TRUE;
  bounds.EnableTimer( TRUE );

  LogOK;
  finally
  Log( '<-TKOLForm.Loaded' );
  end;
end;

procedure TKOLForm.GetPaintTypeFromProjectOrOtherForms;
var I, J: Integer;
    F: TForm;
    C: TComponent;
    NewPaintType: TPaintType;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GetPaintTypeFromProjectOrOtherForms', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GetPaintTypeFromProjectOrOtherForms' );
  try

  NewPaintType := PaintType;
  if Screen = nil then
  begin
    LogOK;
    Exit;
  end;
  for I := 0 to Screen.FormCount-1 do
  begin
    F := Screen.Forms[ I ];
    for J := 0 to F.ComponentCount-1 do
    begin
      C := F.Components[ J ];
      if C is TKOLProject then
      begin
        NewPaintType := (C as TKOLProject).PaintType;
        break;
      end;
      if C is TKOLForm then
      if C <> Self then
        NewPaintType := (C as TKOLForm).PaintType;
    end;
  end;
  PaintType := NewPaintType;

  LogOK;
  finally
  Log( '<-TKOLForm.GetPaintTypeFromProjectOrOtherForms' );
  end;
end;

function SortControls( Item1, Item2: Pointer ): Integer;
var K1, K2: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SortControls', 0
  @@e_signature:
  end;
  K1 := Item1;
  K2 := Item2;
  Result := CmpInts( K1.TabOrder, K2.TabOrder );
  if (Result = 0) and (K1.Align = K2.Align) then
  begin
    case K1.Align of
    caTop: Result := CmpInts( K1.Top, K2.Top );
    caBottom: Result := CmpInts( K2.Top, K1.Top );
    caLeft: Result := CmpInts( K1.Left, K2.Left );
    caRight: Result := CmpInts( K2.Left, K1.Left );
    else
      Result := 0;
    end;
  end;
end;

procedure TKOLForm.AlignChildren(PrntCtrl: TKOLCustomControl; Recursive: Boolean);
type
  TAligns = set of TKOLAlign;
var Controls: TList;
    I: Integer;
    P: TComponent;
    CR, CM: TRect;
    PrntBorder: Integer;
    //NewW, NewH: Integer;
  procedure DoAlign( Allowed: TAligns );
  var I: Integer;
      C: TKOLCustomControl;
      R, R1: TRect;
      W, H: Integer;
      ChgPos, ChgSiz: Boolean;
  begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AlignChildren.DoAlign', 0
  @@e_signature:
  end;
    for I := 0 to Controls.Count - 1 do
    begin
      C := Controls[ I ];
      //if not C.ToBeVisible then continue;
      // important: not fVisible, and even not Visible, but ToBeVisible!
      //if C.UseAlign then continue;
      if C.Align in Allowed then
      begin
        R := C.BoundsRect;
        R1 := R;
        W := R.Right - R.Left;
        H := R.Bottom - R.Top;
        case C.Align of
        caTop:
          begin
            OffsetRect( R, 0, -R.Top + CR.Top + PrntBorder );
            Inc( CR.Top, H + PrntBorder );
            R.Left := CR.Left + PrntBorder;
            R.Right := CR.Right - PrntBorder;
          end;
        caBottom:
          begin
            OffsetRect( R, 0, -R.Bottom + CR.Bottom - PrntBorder );
            Dec( CR.Bottom, H + PrntBorder );
            R.Left := CR.Left + PrntBorder;
            R.Right := CR.Right - PrntBorder;
          end;
        caLeft:
          begin
            OffsetRect( R, -R.Left + CR.Left + PrntBorder, 0 );
            Inc( CR.Left, W + PrntBorder );
            R.Top := CR.Top + PrntBorder;
            R.Bottom := CR.Bottom - PrntBorder;
          end;
        caRight:
          begin
            OffsetRect( R, -R.Right + CR.Right - PrntBorder, 0 );
            Dec( CR.Right, W + PrntBorder );
            R.Top := CR.Top + PrntBorder;
            R.Bottom := CR.Bottom - PrntBorder;
          end;
        caClient:
          begin
            R := CR;
            InflateRect( R, -PrntBorder, -PrntBorder );
          end;
        end;
        if R.Right < R.Left then R.Right := R.Left;
        if R.Bottom < R.Top then R.Bottom := R.Top;
        ChgPos := (R.Left <> R1.Left) or (R.Top <> R1.Top);
        ChgSiz := (R.Right - R.Left <> W) or (R.Bottom - R.Top <> H);
        if ChgPos or ChgSiz then
        begin
          C.BoundsRect := R;
          {if ChgSiz then
            AlignChildrenProc( C );}
        end;
      end;
    end;
  end;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.AlignChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.AlignChildren' );
  try

  if csLoading in ComponentState then
  begin
    LogOK;
    Exit;
  end;
  if not AllowRealign then
  begin
    LogOK;
    Exit;
  end;
  Controls := TList.Create;
  if PrntCtrl = nil then
    AllowRealign := FALSE;
  Inc( FRealigning );
  {NewW := 0;
  NewH := 0;
  if PrntCtrl <> nil then
  begin
    NewW := PrntCtrl.ClientWidth;
    NewH := PrntCtrl.ClientHeight;
  end;}
  TRY
    //-- collect controls, which are children of PrntCtrl
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      if (Owner as TForm).Components[ I ] is TKOLCustomControl then
      begin
        P := ((Owner as TForm).Components[ I ] as TKOLCustomControl).Parent;
        if (P = PrntCtrl) or (PrntCtrl = nil) and (P is TForm) then
        begin
          Controls.Add( (Owner as TForm).Components[ I ] );
          {if (PrntCtrl <> nil) and
             (PrntCtrl.fOldWidth <> 0) and
             (PrntCtrl.fOldHeight <> 0) then
          begin
            if ((Owner as TForm).Components[ I ] as TKOLCustomControl).AnchorRight then
            begin
              ((Owner as TForm).Components[ I ] as TKOLCustomControl).Left :=
              ((Owner as TForm).Components[ I ] as TKOLCustomControl).Left +
              NewW - PrntCtrl.fOldWidth;
            end;
            if ((Owner as TForm).Components[ I ] as TKOLCustomControl).AnchorBottom then
            begin
              ((Owner as TForm).Components[ I ] as TKOLCustomControl).Top :=
              ((Owner as TForm).Components[ I ] as TKOLCustomControl).Top +
              NewW - PrntCtrl.fOldHeight;
            end;
          end;}
        end;
      end;
    end;
    //-- order controls by TabOrder
    Controls.Sort( SortControls );
    //-- initialize client rectangle
    if PrntCtrl = nil then
    begin
      CR := //Rect( 0, 0, bounds.Width, bounds.Height );
           (Owner as TForm).ClientRect;
      CR.Left := CR.Left + MarginLeft;
      CR.Top  := CR.Top + MarginTop;
      CR.Right := CR.Right - MarginRight;
      CR.Bottom := CR.Bottom - MarginBottom;
      PrntBorder := Border;
    end
      else
    begin
      CR := PrntCtrl.ClientRect;
      CM := PrntCtrl.ClientMargins;
      CR.Left := CR.Left + PrntCtrl.MarginLeft + CM.Left;
      CR.Top := CR.Top + PrntCtrl.MarginTop + CM.Top;
      CR.Right := CR.Right - PrntCtrl.MarginRight - CM.Right;
      CR.Bottom := CR.Bottom - PrntCtrl.MarginBottom - CM.Bottom;
      PrntBorder := PrntCtrl.Border;
    end;
    DoAlign( [ caTop, caBottom ] );
    DoAlign( [ caLeft, caRight ] );
    DoAlign( [ caClient ] );
    if PrntCtrl = nil then
      AllowRealign := TRUE;
    if Recursive then
      for I := 0 to Controls.Count-1 do
        AlignChildren( TKOLCustomControl( Controls[ I ] ), TRUE );
  FINALLY
    Controls.Free;
    if PrntCtrl = nil then
      AllowRealign := TRUE;
    Dec( FRealigning );
    {if PrntCtrl <> nil then
    begin
      PrntCtrl.fOldWidth := NewW;
      PrntCtrl.fOldHeight := NewH;
    end;}
  END;

  LogOK;
  finally
  Log( '<-TKOLForm.AlignChildren' );
  end;
end;

function TKOLForm.DoNotGenerateSetPosition: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.DoNotGenerateSetPosition', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLForm.RealignTimerTick(Sender: TObject);
begin
  FRealignTimer.Enabled := FALSE;
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFileFilter.RealignTimerTick', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.RealignTimerTick' );
  try

  if not AllowRealign then
  begin
    LogOK;
    Exit;
  end;
  if FRealigning > 0 then
  begin
    LogOK;
    Exit;
  end;
  FRealignTimer.Enabled := FALSE;
  Rpt( 'RealignTimerTick', WHITE );
  AlignChildren( nil, TRUE );

  LogOK;
  finally
  Log( '<-TKOLForm.RealignTimerTick' );
  FRealignTimer.Enabled := FALSE;
  end;
end;

procedure TKOLForm.SetMaxHeight(const Value: Integer);
begin
  Log( '->TKOLForm.SetMaxHeight' );
  try
  FMaxHeight := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMaxHeight' );
  end;
end;

procedure TKOLForm.SetMaxWidth(const Value: Integer);
begin
  Log( '->TKOLForm.SetMaxWidth' );
  try
  FMaxWidth := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMaxWidth' );
  end;
end;

procedure TKOLForm.SetMinHeight(const Value: Integer);
begin
  Log( '->TKOLForm.SetMinHeight' );
  try
  FMinHeight := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMinHeight' );
  end;
end;

procedure TKOLForm.SetMinWidth(const Value: Integer);
begin
  Log( '->TKOLForm.SetMinWidth' );
  try
  FMinWidth := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetMinWidth' );
  end;
end;

procedure TKOLForm.SetOnDropFiles(const Value: TOnDropFiles);
begin
  Log( '->SetOnDropFiles' );
  try
  FOnDropFiles := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-SetOnDropFiles' );
  end;
end;

procedure TKOLForm.SetpopupMenu(const Value: TKOLPopupMenu);
begin
  Log( '->TKOLForm.SetpopupMenu' );
  try
  FpopupMenu := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetpopupMenu' );
  end;
end;

procedure TKOLForm.SetOnMaximize(const Value: TOnEvent);
begin
  Log( '->TKOLForm.SetOnMaximize' );
  try
  FOnMaximize := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMaximize' );
  end;
end;

procedure TKOLForm.SetLocalizy(const Value: Boolean);
begin
  Log( '->TKOLForm.SetLocalizy' );
  try
  FLocalizy := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetLocalizy' );
  end;
end;

procedure TKOLForm.MakeResourceString(const ResourceConstName,
  Value: String);
begin
  Log( '->TKOLForm.MakeResourceString' );
  try
  if ResStrings = nil then
    ResStrings := TStringList.Create;
  ResStrings.Add( 'resourcestring ' + ResourceConstName + ' = ' +
    String2Pascal( Value, '+' ) + ';' );
  LogOK;
  finally
  Log( '<-TKOLForm.MakeResourceString' );
  end;
end;

function TKOLForm.StringConstant(const Propname, Value: String): String;
begin
  Log( '->TKOLForm.StringConstant' );
  try
  if Localizy and (Value <> '') then
  begin
    Result := Name + '_' + Propname;
    MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value, '+' );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.StringConstant' );
  end;
end;

procedure TKOLForm.SetHelpContext(const Value: Integer);
begin
  Log( '->TKOLForm.SetHelpContext' );
  try
  FHelpContext := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetHelpContext' );
  end;
end;

procedure TKOLForm.SethelpContextIcon(const Value: Boolean);
begin
  Log( '->TKOLForm.SethelpContextIcon' );
  try
  FhelpContextIcon := Value;
  if Value then
  begin
    maximizeIcon := FALSE;
    minimizeIcon := FALSE;
  end;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SethelpContextIcon' );
  end;
end;

procedure TKOLForm.SetOnHelp(const Value: TOnHelp);
begin
  Log( '->TKOLForm.SetOnHelp' );
  try
  FOnHelp := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnHelp' );
  end;
end;

procedure TKOLForm.SetBrush(const Value: TKOLBrush);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetFont', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetBrush' );
  try

  if not FLocked then
  begin
    FBrush.Assign( Value );
    Change( Self );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetBrush' );
  end;
end;

{YS}
procedure TKOLForm.SetborderStyle(const Value: TKOLFormBorderStyle);
const BorderStyleNames: array[ TKOLFormBorderStyle ] of String =
  ( 'fbsNone', 'fbsSingle', 'fbsDialog', 'fbsToolWindow' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetborderStyle', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetborderStyle' );
  try
  if FborderStyle <> Value then
  begin
    RptDetailed( 'SetBorderStyle:' + BorderStyleNames[ Value ], YELLOW );

    if not FLocked then
    begin
      FborderStyle := Value;
      if not( csLoading in ComponentState ) then //+VK
      begin                                      //+VK
        FHasBorder := Value <> fbsNone;
        fCanResize := Value <> fbsDialog;
      end;                                       //+VK
      Change( Self );
    end;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.SetborderStyle' );
  end;
end;
{YS}

function TKOLForm.BestEventName: String;
begin
  Result := 'OnFormCreate';
end;

procedure TKOLForm.SetShowHint(const Value: Boolean);
begin
  Log( '->TKOLForm.SetShowHint' );
  try
  FGetShowHint := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetShowHint' );
  end;
end;

function TKOLForm.GetShowHint: Boolean;
begin
  Log( '->TKOLForm.GetShowHint' );
  try
  if KOLProject <> nil then
    FGetShowHint := KOLProject.ShowHint;
  Result := FGetShowHint;
  LogOK;
  finally
  Log( '<-TKOLForm.GetShowHint' );
  end;
end;

procedure TKOLForm.SetOnBeforeCreateWindow(const Value: TOnEvent);
begin
  Log( '->TKOLForm.SetOnBeforeCreateWindow' );
  try
  FOnBeforeCreateWindow := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnBeforeCreateWindow' );
  end;
end;

procedure TKOLForm.ChangeTimerTick(Sender: TObject);
begin
  FChangeTimer.Enabled := FALSE;
  Log( '->TKOLForm.ChangeTimerTick' );
  try
  FChangeTimer.Enabled := FALSE;
  DoChangeNow;
  FChangeTimer.Enabled := FALSE;
  LogOK;
  finally
  Log( '<-TKOLForm.ChangeTimerTick' );
  end;
end;

procedure TKOLForm.DoChangeNow;
var I: Integer;
    Success: Boolean;
    S: String;
begin
  Log( '->TKOLForm.DoChangeNow' );
  try

  if Name='' then
  begin
    LogOk;
    Exit;
  end;
  Success:=false;

  RptDetailed( 'DoChangeNow called for ' + Name, LIGHT + CYAN );
  try
    Success := FALSE;
    if not Assigned( KOLProject ) then
    begin
      RptDetailed( 'KOLProject=nil', YELLOW );
      if ToolServices=nil then
      begin
        RptDetailed( 'ToolServices = nil, will create', YELLOW );
        //ToolServices := TIToolServices.Create;
      end;
      if ToolServices <> nil then
      begin
        RptDetailed( 'ToolServices <> nil', YELLOW );
        for I := 0 to ToolServices.GetUnitCount - 1 do
        begin
          S := ToolServices.GetUnitName( I );
          if LowerCase( ExtractFileName( S ) ) = LowerCase( FormUnit + '.pas' ) then
          begin
            S := Copy( ExtractFileName( S ), 1, Length( S ) - 4 );
            if fSourcePath <> '' then
              S := IncludeTrailingPathDelimiter( fSourcePath ) + S;
            //ShowMessage( 'Generating w/o KOLProject: ' + S {+#13#10 +
            //  'csLoading:' + IntToStr( Integer( csLoading in ComponentState ) )} );
            RptDetailed( 'BeforeGenerateUnit1' + S, YELLOW );
            Success := GenerateUnit( S );
            RptDetailed( 'AfterGenerateUnit1' + S, YELLOW );
          end;
          if Success then break;
        end;
        if not Success then
        begin
          S := ToolServices.GetCurrentFile;
          if S <> '' then
          begin
            RptDetailed( 'DoChangeNow: S=' + S, YELLOW );
            if LowerCase( ExtractFileName( S ) ) = LowerCase( FormUnit + '.pas' ) then
            begin
              S := Copy( ExtractFileName( S ), 1, Length( S ) - 4 );
              if fSourcePath <> '' then
                S := IncludeTrailingPathDelimiter( fSourcePath ) + S;
              RptDetailed( 'BeforeGenerateUnit2' + S, YELLOW );
              //ShowMessage( 'Generating w/o KOLProject: ' + S );
              Success := GenerateUnit( S );
              RptDetailed( 'AfterGenerateUnit2' + S, YELLOW );
            end;
          end;
        end;
      end;
    end;
  except on E: Exception do
         begin
           RptDetailed( 'Exception ' + E.Message, RED );
         end;
  end;
  if not Success then
    inherited Change( Self );

  LogOK;
  finally
  Log( '<-TKOLForm.DoChangeNow' );
  end;
end;

procedure TKOLForm.P_GenerateCreateForm(SL: TStringList);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_GenerateCreateForm', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_GenerateCreateForm' );
  try
    //{P} ESP->Result,@Result,AParent

  S := P_GenerateTransparentInits;

  //SL.Add( '  Result.Form := NewForm( AParent, ' + StringConstant( 'Caption', Caption ) +
  //        ' )' + S + ';' );
  {P}SL.Add( P_StringConstant( 'Caption', Caption ) );
    //{P} ESP->Caption,Result,@Result,AParent
  {P}SL.Add( ' C4 ' );
    //{P} ESP->AParent,Caption,Result,@Result,AParent
  {P}SL.Add( ' NewForm<2> RESULT' );
    //{P} ESP->form,Result,@Result,AParent
  {P}SL.Add( ' DUP C3 AddByte_Store #T' + FormName + '.Form' );
  {P}SL.Add( S );
    //{P} ESP->Result,@Result,AParent
  //if @ OnBeforeCreateWindow <> nil then
  //  SL.Add( '      Result.' +
  //        (Owner as TForm).MethodName( @ OnBeforeCreateWindow ) + '( Result );' );
  if @ OnBeforeCreateWindow <> nil then
  begin
    {P}SL.Add( ' DUP LoadSELF' );
    {P}SL.Add( ' T' + FormName + '.' +
               (Owner as TForm).MethodName( @ OnBeforeCreateWindow ) + '<2>' );
  end;

  // Если форма главная, и Applet не используется, инициализировать здесь
  // переменную Applet:
  if FormMain and not AppletOnForm then
    //SL.Add( '  Applet :=  Result.Form;' );
    begin
      {P}SL.Add( ' DUP StoreVar ####Applet' );
    end;

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateCreateForm' );
  end;
end;

function TKOLForm.P_GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_GenerateTransparentInits', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_GenerateTransparentInits' );
  try
  Result := '';
  if not FLocked then
  begin
    //{P} ESP->Result.Form,... ( Result = New<formname>(...) )

    //Log( '#1 TKOLForm.GenerateTransparentInits' );

    if not DefaultPosition then
    begin
      //Log( '#1.A TKOLForm.GenerateTransparentInits' );

      if not DoNotGenerateSetPosition then
      begin
        //Log( '#1.B TKOLForm.GenerateTransparentInits' );
        if FBounds <> nil then
          //Result := '.SetPosition( ' + IntToStr( Bounds.Left ) + ', ' +
          //          IntToStr( Bounds.Top ) + ' )';
          begin
            {P}Result := Result + ' L(' + IntToStr( Bounds.Top ) + ')';
            {P}Result := Result + ' L(' + IntToStr( Bounds.Left ) + ')';
            {P}Result := Result + ' C2 TControl.SetPosition<3>';
          end;
        //Log( '#1.C TKOLForm.GenerateTransparentInits' );
      end;

      //Log( '#1.D TKOLForm.GenerateTransparentInits' );
    end;

    //Log( '#2 TKOLForm.GenerateTransparentInits' );

    if not DefaultSize then
    begin
      if (Owner = nil) or not(Owner is TForm) then
        if HasCaption then
          //Result := Result + '.SetSize( ' + IntToStr( Bounds.Width ) + ', ' +
          //        IntToStr( Bounds.Height ) + ' )'
          begin
            {P}Result := Result + ' L(' + IntToStr( Bounds.Height ) + ')';
            {P}Result := Result + ' L(' + IntToStr( Bounds.Width ) + ')';
            {P}Result := Result + ' C2 TControl.SetSize<3>';
          end
        else
          //Result := Result + '.SetSize( ' + IntToStr( Bounds.Width ) + ', ' +
          //        IntToStr( Bounds.Height-GetSystemMetrics(SM_CYCAPTION) ) + ' )'
          begin
            {P}Result := Result + ' L(' + IntToStr( Bounds.Height-GetSystemMetrics(SM_CYCAPTION) ) + ')';
            {P}Result := Result + ' L(' + IntToStr( Bounds.Width ) + ')';
            {P}Result := Result + ' C2 TControl.SetSize<3>';
          end
      else
        if HasCaption then
          //Result := Result + '.SetClientSize( ' + IntToStr( (Owner as TForm).ClientWidth ) +
          //       ', ' + IntToStr( (Owner as TForm).ClientHeight ) + ' )'
          begin
            {P}Result := Result + ' L(' + IntToStr( (Owner as TForm).ClientHeight ) + ')';
            {P}Result := Result + ' L(' + IntToStr( (Owner as TForm).ClientWidth ) + ')';
            {P}Result := Result + ' C2 TControl.SetClientSize<3>';
          end
        //+++++++ UaFM
        else
          //Result := Result + '.SetClientSize( ' + IntToStr( (Owner as TForm).ClientWidth ) +
          //       ', ' + IntToStr( (Owner as TForm).ClientHeight-GetSystemMetrics(SM_CYCAPTION) )
          //       + ')'
          if HasBorder then
          begin
            {P}Result := Result + ' L(' + IntToStr( (Owner as TForm).ClientHeight-GetSystemMetrics(SM_CYCAPTION) ) + ')';
            {P}Result := Result + ' L(' + IntToStr( (Owner as TForm).ClientWidth ) + ')';
            {P}Result := Result + ' C2 TControl.SetClientSize<3>';
          end;
    end;

    //Log( '#3 TKOLForm.GenerateTransparentInits' );

    if Tabulate then
      //Result := Result + '.Tabulate'
      {P}Result := Result + ' DUP TControl.Tabulate<1>'
    else
    if TabulateEx then
      //Result := Result + '.TabulateEx';
      {P}Result := Result + ' DUP TControl.TabulateEx<1>';

    //Log( '#4 TKOLForm.GenerateTransparentInits' );

    if PreventResizeFlicks then
      //Result := Result + '.PreventResizeFlicks';
      {P}Result := Result + ' DUP TControl.PreventResizeFlicks<1>';

    //Log( '#5 TKOLForm.GenerateTransparentInits' );

    if supportMnemonics then
      //Result := Result + '.SupportMnemonics';
      {P}Result := Result + ' DUP TControl.SupportMnemonics<1>';

    //Log( '#6 TKOLForm.GenerateTransparentInits' );

    if HelpContext <> 0 then
      //Result := Result + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )';
      begin
        {P}Result := Result + ' L(' + IntToStr( HelpContext ) + ')';
        {P}Result := Result + ' C1 TControl.AssignHelpContext<2>';
      end;
  end;

  //Log( '#7 TKOLForm.GenerateTransparentInits' );

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateTransparentInits' );
  end;
end;

function TKOLForm.P_StringConstant(const Propname, Value: String): String;
begin
  Log( '->TKOLForm.P_StringConstant' );
  try
  if Localizy and (Value <> '') then
  begin
    //Result := Name + '_' + Propname;
    {P}Result := ' ResourceString ####' + Name + '_' + PropName;
      //todo: implement ResourceString in P-machine!
    MakeResourceString( Result, Value );
  end
    else
  begin
    //Result := String2Pascal( Value );
    {P}Result := ' LoadAnsiStr ' + P_String2Pascal( Value );
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.P_StringConstant' );
  end;
end;

procedure TKOLForm.P_GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String;
  Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_GenerateAdd2AutoFree' );
  try

  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
  begin
    LogOK;
    Exit;
  end;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if not AControl then
    //SL.Add( '  Result.Form.' + Add2AutoFreeProc + '( ' + AName + ' );' );
    begin
      //{P} ESP -> Result,@Result
      {P}SL.Add( ' LoadSELF C1 '
        //+ 'AddByte_LoadRef #T' + FormName + '.Form'
        );
      {P}SL.Add( ' TControl.' + Add2AutoFreeProc + '<2>' );
      ////?{P}SL.Add( ' xySwap DEL' );
    end;

  LogOK;
  finally
  Log( '<-TKOLForm.P_GenerateAdd2AutoFree' );
  end;
end;

procedure TKOLForm.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
const WindowStates: array[ KOL.TWindowState ] of String = ( 'wsNormal',
      'wsMinimized', 'wsMaximized' );
var I: Integer;
    S: string; {YS}
    FormInStack: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_SetupFirst', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_SetupFirst' );
  try

  if FLocked then
  begin
    Rpt( 'Form ' + Name + ' LOCKED', RED );
    LogOK; Exit;
  end;

  FormInStack := FALSE;

  // Установка каких-либо свойств формы - тех, которые выполняются
  // сразу после конструирования объекта формы:
  SL.Add( 'IFDEF(UNICODE_CTRLS)' );
  SL.Add( '  L(1) C1  TControl.SetUnicode<2> DEL' );
  SL.Add( 'ENDIF' );
  P_SetupName( SL );
  if Tag <> 0 then
  begin
    {if Tag < 0 then
      SL.Add( Prefix + AName + '.Tag := DWORD(' + IntToStr( Tag ) + ');' )
    else
      SL.Add( Prefix + AName + '.Tag := ' + IntToStr( Tag ) + ';' );}
    {P}SL.Add( ' L(' + IntToStr( Tag ) + ')' );
    {P}SL.Add( ' C1 AddWord_Store ##TControl_.fTag' );
  end;

  //Log( '&2 TKOLForm.SetupFirst' );

  if not statusSizeGrip then
  //if (StatusText.Count > 0) or (SimpleStatusText <> '') then
    //SL.Add( Prefix + AName + '.SizeGrip := FALSE;' );
    begin
      {P}SL.Add( ' L(0) C1 AddWord_StoreB ##TControl_.fSizeGrip' )
    end;

  //Log( '&3 TKOLForm.SetupFirst' );

{YS}
  S := '';
  case FborderStyle of
    fbsDialog:
      S := S + ' or WS_EX_DLGMODALFRAME or WS_EX_WINDOWEDGE';
    fbsToolWindow:
      S := S + ' or WS_EX_TOOLWINDOW';
  end;

  //Log( '&4 TKOLForm.SetupFirst' );

  if helpContextIcon then
    S := S + ' or WS_EX_CONTEXTHELP';
  if S <> '' then
    //SL.Add( Prefix + AName + '.ExStyle := ' + AName + '.ExStyle' + S + ';' );
    begin
      Delete( S, 1, 4 ); // remove ' or ' prefix
      {P}SL.Add( ' LoadWord ##(' + S + ')' );
      {P}SL.Add( ' C1 AddWord_LoadRef ##TControl_.fExStyle' );
      {P}SL.Add( ' | C1 TControl_.SetExStyle<2>' );
    end;

  //Log( '&5 TKOLForm.SetupFirst' );

{YS}
  if not Visible then
    //SL.Add( Prefix + AName + '.Visible := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetVisible<2>' );
    end;
  if not Enabled then
    //SL.Add( Prefix + AName + '.Enabled := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetEnabled<2>' );
    end;
  if DoubleBuffered and not Transparent then
    //SL.Add( Prefix + AName + '.DoubleBuffered := True;' );
    begin
      {P}SL.Add( 'L(1) C1 TControl_.SetDoubleBuffered<2>' )
    end;
{YS}

  //Log( '&6 TKOLForm.SetupFirst' );

  I := 0;
  case FborderStyle of
    fbsDialog:
      I := I or WS_MINIMIZEBOX or WS_MAXIMIZEBOX;
    fbsToolWindow, fbsNone:
      ;
    else
      begin
        if not MinimizeIcon and not MaximizeIcon then
          I := I or WS_MINIMIZEBOX or WS_MAXIMIZEBOX
        else
        begin
          if not MinimizeIcon then
            I := I or WS_MINIMIZEBOX;
          if not MaximizeIcon then
            I := I or WS_MAXIMIZEBOX;
        end;
      end;
  end;

  //Log( '&7 TKOLForm.SetupFirst' );

  if I <> 0 then
    //SL.Add( Prefix + AName + '.Style := ' + AName + '.Style' + S + ';' );
    begin
      Delete( S, 1, 4 );
      {P}SL.Add( ' L(' + IntToStr( I shr 16 ) + ') L(16) <<' );
      {P}SL.Add( ' ~ C1 AddWord_LoadRef ##TControl_.fStyle & ' );
      {P}SL.Add( ' C1 TControl_.SetStyle<2>' );
    end;

  //Log( '&8 TKOLForm.SetupFirst' );

{YS}

  if Transparent then
    //SL.Add( Prefix + AName + '.Transparent := True;' );
    begin
      {P}SL.Add( ' L(1) C1 TControl_.SetTransparent<2>' );
    end;

  if (AlphaBlend <> 255) and (AlphaBlend > 0) then
    //SL.Add( Prefix + AName + '.AlphaBlend := ' + IntToStr( AlphaBlend and $FF ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( AlphaBlend ) + ')' );
      {P}SL.Add( ' C1 TControl_.SetAlphaBlend<2>' );
    end;

  if not HasBorder then
    //SL.Add( Prefix + AName + '.HasBorder := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetHasBorder<2>' );
      {P}SL.Add( ' L(' + IntToStr( (Owner as TForm).ClientHeight ) + ')' );
      {P}SL.Add( ' L(' + IntToStr( (Owner as TForm).ClientWidth ) + ')' );
      {P}SL.Add( ' C2 TControl.SetClientSize<3>' );
    end;

  if not HasCaption and HasBorder then
    //SL.Add( Prefix + AName + '.HasCaption := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl.SetHasCaption<2>' );
    end;

  if StayOnTop then
    //SL.Add( Prefix + AName + '.StayOnTop := True;' );
    begin
      {P}SL.Add( ' L(1) C1 TControl_.SetStayOnTop<2>' );
    end;

  if not Ctl3D then
    //SL.Add( Prefix + AName + '.Ctl3D := False;' );
    begin
      {P}SL.Add( ' L(0) C1 TControl_.SetCtl3D<2>' );
    end;

  if Icon <> '' then
  begin
    if Copy( Icon, 1, 1 ) = '#' then // +Alexander Pravdin
      //SL.Add( Prefix + AName + '.IconLoad( hInstance, MAKEINTRESOURCE( ' +
      //  Copy( Icon, 2, Length( Icon ) - 1 ) + ' ) );' )
      begin
        {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( CopyEnd( Icon, 2 ) ) );
        {P}SL.Add( ' Load_hInstance' );
        {P}SL.Add( ' C3 TControl.IconLoad<3>' );
        {P}SL.Add( ' DelAnsiStr' );
      end
    else
    if Copy( Icon, 1, 4 ) = 'IDI_' then
      //SL.Add( Prefix + AName + '.IconLoad( 0, ' + Icon + ' );' )
      begin
        {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Icon ) );
        {P}SL.Add( ' L(0) C3 TControl.IconLoad<3>' );
        {P}SL.Add( ' DelAnsiStr' );
      end
    else
    if Copy( Icon, 1, 4 ) = 'IDC_' then
      //SL.Add( Prefix + AName + '.IconLoadCursor( 0, ' + Icon + ' );' )
      begin
        {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Icon ) );
        {P}SL.Add( ' L(0) C3 TControl.IconLoad<3>' );
        {P}SL.Add( ' DelAnsiStr' );
      end
    else
    if Icon = '-1' then
      //SL.Add( Prefix + AName + '.Icon := THandle(-1);' )
      begin
        {P}SL.Add( ' L(-1) C1 TControl_.SetIcon<2>' );
      end
    else
      //SL.Add( Prefix + AName + '.IconLoad( hInstance, ''' + Icon + ''' );' );
      begin
        {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Icon ) );
        {P}SL.Add( ' Load_hInstance' );
        {P}SL.Add( ' C3 TControl.IconLoad<3>' );
        {P}SL.Add( ' DelAnsiStr' );
      end;
  end;

  if WindowState <> KOL.wsNormal then
    //SL.Add( Prefix + AName + '.WindowState := ' + WindowStates[ WindowState ] +
    //        ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( Integer( WindowState ) ) + ')' );
      {P}SL.Add( ' C1 TControl_.SetWindowState<2>' );
    end;

  if Trim( Cursor ) <> '' then
  begin
    if Copy( Cursor, 1, 4 ) = 'IDC_' then
      //SL.Add( Prefix + AName + '.CursorLoad( 0, ' + Cursor + ' );' )
      begin
        {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Cursor ) );
        {P}SL.Add( ' L(0) C3 TControl.CursorLoad<3>' );
        {P}SL.Add( ' DelAnsiStr' );
      end
    else
      //SL.Add( Prefix + AName + '.CursorLoad( hInstance, ''' + Trim( Cursor ) + ''' );' );
      begin
        {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Cursor ) );
        {P}SL.Add( ' Load_hInstance C3 TControl.CursorLoad<3>' );
        {P}SL.Add( ' DelAnsiStr' );
      end;
  end;

  if Brush <> nil then
    //Brush.GenerateCode( SL, AName );
    begin
      {P}Brush.P_GenerateCode( SL, AName );
    end;

  if (Font <> nil) AND not FontDefault and not Font.Equal2( nil ) then
    //Font.GenerateCode( SL, AName, nil );
    begin
      {P}Font.P_GenerateCode( SL, AName, nil );
    end;

  if Border <> 2 then
    //SL.Add( Prefix + AName + '.Border := ' + IntToStr( Border ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( Border ) + ')' );
      {P}SL.Add( ' C1 TControl.SetBorder<2>' );
    end;

  if MarginTop <> 0 then
    //SL.Add( Prefix + AName + '.MarginTop := ' + IntToStr( MarginTop ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MarginTop ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientTop' );
    end;

  if MarginBottom <> 0 then
    //SL.Add( Prefix + AName + '.MarginBottom := ' + IntToStr( MarginBottom ) + ';' );
    begin
      {P}SL.Add( 'L(' + IntToStr( MarginBottom ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientBottom' );
    end;

  if MarginLeft <> 0 then
    //SL.Add( Prefix + AName + '.MarginLeft := ' + IntToStr( MarginLeft ) + ';' );
    begin
      {P}SL.Add( 'L(' + IntToStr( MarginLeft ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientLeft' );
    end;

  if MarginRight <> 0 then
    //SL.Add( Prefix + AName + '.MarginRight := ' + IntToStr( MarginRight ) + ';' );
    begin
      {P}SL.Add( 'L(' + IntToStr( MarginRight ) + ')' );
      {P}SL.Add( ' C1 AddWord_Store ##TControl_.fClientRight' );
    end;

  if (FStatusText <> nil) and (FStatusText.Text <> '') then
  begin
    if FStatusText.Count = 1 then
      //SL.Add( Prefix + AName + '.SimpleStatusText := ' + PCharStringConstant( Self, 'SimpleStatusText', FStatusText[ 0 ] ) + ';' )
      begin
        {P}SL.Add( P_StringConstant( 'SimpleStatusText', FStatusText[ 0 ] ) );
        {P}SL.Add( ' L(255) C3 TControl_.SetStatusText<3> DelAnsiStr' );
      end
    else
    begin
      for I := 0 to FStatusText.Count-1 do
        //SL.Add( Prefix + AName + '.StatusText[ ' + IntToStr( I ) + ' ] := ' +
        //        PCharStringConstant( Self, 'StatusText' + IntToStr( I ), FStatusText[ I ] ) + ';' );
        begin
          {P}SL.Add( P_StringConstant( 'StatusText' + IntToStr( I ), FStatusText[ I ] ) );
          {P}SL.Add( ' L(' + IntToStr( I ) + ') C3 TControl_.SetStatusText<3> DelAnsiStr' );
        end;
    end;
  end;

  if not CloseIcon then
  begin
    //SL.Add( Prefix + 'DeleteMenu( GetSystemMenu( Result.Form.GetWindowHandle, ' +
    //        'False ), SC_CLOSE, MF_BYCOMMAND );' );
    {P}SL.Add( ' L(0) LoadWord ##SC_CLOSE ' );
    {P}SL.Add( ' L(0) C3 TControl.GetWindowHandle<1> RESULT' );
    {P}SL.Add( ' GetSystemMenu RESULT' );
    {P}SL.Add( ' DeleteMenu' );
  end;

  //AssignEvents( SL, AName );
  {P}P_AssignEvents( SL, AName, FALSE );

  if EraseBackground then
    //SL.Add( Prefix + AName + '.EraseBackground := TRUE;' );
    begin
      {P}SL.Add( ' L(1) C1 AddWord_StoreB ##TControl_.fEraseUpdRgn' );
    end;

  if MinWidth > 0 then
    //SL.Add( Prefix + AName + '.MinWidth := ' + IntToStr( MinWidth ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MinWidth ) + ') L(0)' );
      {P}SL.Add( ' C2 TControl_.SetConstraint<3>' );
    end;

  if MinHeight > 0 then
    //SL.Add( Prefix + AName + '.MinHeight := ' + IntToStr( MinHeight ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MinHeight ) + ') L(1)' );
      {P}SL.Add( ' C2 TControl_.SetConstraint<3>' );
    end;

  if MaxWidth > 0 then
    //SL.Add( Prefix + AName + '.MaxWidth := ' + IntToStr( MaxWidth ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MaxWidth ) + ') L(2)' );
      {P}SL.Add( ' C2 TControl_.SetsContraint<3>' );
    end;

  if MaxHeight > 0 then
    //SL.Add( Prefix + AName + '.MaxHeight := ' + IntToStr( MaxHeight ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( MaxHeight ) + ') L(3)' );
      {P}SL.Add( ' C2 TControl_.SetConstraint<3>' );
    end;

  if KeyPreview then
    begin
      {P}SL.Add( ' DUP L(1) AddWord_StoreB ##TControl_.FKeyPreview' );
    end;

  if FormInStack then
    SL.Add( ' DEL // Form ' );

  LogOK;
  finally
  Log( '<-TKOLForm.P_SetupFirst' );
  end;
end;

function TKOLForm.P_AssignEvents(SL: TStringList; const AName: String; CheckOnly: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_AssignEvents', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_AssignEvents' );
  Result := TRUE;
  try
  if not FLocked then
  begin
    if (Applet <> nil) and (Applet.Owner = Owner) and not CheckOnly then
    begin
      if Applet.P_AssignEvents( SL, 'Applet', TRUE ) then
      begin
        SL.Add( ' Load_Applet ' );
        Applet.P_AssignEvents( SL, 'Applet', FALSE );
        SL.Add( ' DEL // Applet' );
      end;
    end;
    if P_DoAssignEvents( SL, AName, [ 'OnMessage', 'OnClose', 'OnQueryEndSession' ],
                               [ @OnMessage, @ OnClose, @ OnQueryEndSession  ],
                               [ FALSE,      TRUE,     TRUE ],
                               CheckOnly ) and CheckOnly then
                               begin
                                 LogOK; Exit;
                               end;
    if P_DoAssignEvents( SL, AName, [ 'OnMinimize', 'OnMaximize', 'OnRestore' ],
                               [ @ OnMinimize, @ OnMaximize, @ OnRestore  ],
                               [ TRUE,         TRUE,         TRUE ],
                               CheckOnly ) and CheckOnly then
                               begin
                                 LogOK; Exit;
                               end;
    if P_DoAssignEvents( SL, AName,
    [ 'OnClick', 'OnMouseDblClk', 'OnMouseDown', 'OnMouseMove', 'OnMouseUp', 'OnMouseWheel', 'OnMouseEnter', 'OnMouseLeave' ],
    [ @OnClick,  @ OnMouseDblClk, @OnMouseDown,  @OnMouseMove,  @OnMouseUp,  @OnMouseWheel,  @OnMouseEnter,  @OnMouseLeave  ],
    [ FALSE,     TRUE,            TRUE,          TRUE,          TRUE,        TRUE,           TRUE,           TRUE ],
    CheckOnly ) and CheckOnly then
                               begin
                                 LogOK; Exit;
                               end;

    if P_DoAssignEvents( SL, AName,
    [ 'OnEnter', 'OnLeave', 'OnKeyDown', 'OnKeyUp', 'OnKeyChar', 'OnResize', 'OnMove', 'OnMoving', 'OnShow', 'OnHide' ],
    [ @OnEnter,  @OnLeave,  @OnKeyDown,  @OnKeyUp,  @OnKeyChar,  @OnResize,  @OnMove, @ OnMoving, @ OnShow, @ OnHide  ],
    [ FALSE,     FALSE,     TRUE,        TRUE,      TRUE,     TRUE,       TRUE,     TRUE, TRUE,     TRUE     ],
    CheckOnly ) and CheckOnly then
                               begin
                                 LogOK; Exit;
                               end;

    if P_DoAssignEvents( SL, AName,
    [ 'OnPaint', 'OnEraseBkgnd', 'OnDropFiles' ],
    [ @ OnPaint, @ OnEraseBkgnd, @ OnDropFiles ],
    [ TRUE,      TRUE,           TRUE ],
    CheckOnly )
    and CheckOnly then
                               begin
                                 LogOK; Exit;
                               end;

    if P_DoAssignEvents( SL, AName,
    [ 'OnDestroy', 'OnHelp' ],
    [ @ OnDestroy, @ OnHelp ],
    [ FALSE,       FALSE ],
    CheckOnly ) and CheckOnly then
                               begin
                                 LogOK; Exit;
                               end;
  end;
  LogOK;
  Result := FALSE;
  finally
  if Result and CheckOnly then LogOK;
  Log( '<-TKOLForm.P_AssignEvents' );
  end;
end;

procedure TKOLForm.P_GenerateChildren(SL: TStringList;
  OfParent: TComponent; const OfParentName, Prefix: String;
  var Updated: Boolean);
var I: Integer;
    L: TList;
    S: String;
    KC: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_GenerateChildren', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_GenerateChildren' );
  try
  L := TList.Create;
  try
    for I := 0 to Owner.ComponentCount - 1 do
    begin
      if Owner.Components[ I ] is TKOLCustomControl then
      if (Owner.Components[ I ] as TKOLCustomControl).ParentKOLControl = OfParent then
      begin
        //Rpt( 'Look for ' + OfParent.Name + ': ' + Owner.Components[ I ].Name );
        //Rpt( '.ParentKOLControl = ' + (Owner.Components[ I ] as TKOLCustomControl).ParentKOLControl.Name );
        KC := Owner.Components[ I ] as TKOLCustomControl;
        L.Add( KC );
      end;
    end;
    SortData( L, L.Count, @CompareControls, @SwapItems );
    //OutSortedListOfComponents( UnitSourcePath + FormName + '_' + OfParent.Name, L, 3 );
    for I := 0 to L.Count - 1 do
    begin
      KC := L.Items[ I ];
      KC.fUpdated := FALSE;
      //SL.Add( '    // ' + KC.RefName + '.TabOrder = ' + IntToStr( KC.TabOrder ) );
      KC.fP_NameSetuped := FALSE;
      KC.P_SetupFirst( SL, KC.Name, OfParentName, Prefix );
      KC.P_SetupName( SL ); // на случай, если P_SetupFirst переопределена
                            // и P_SetupName не вызвана
      P_GenerateAdd2AutoFree( SL, KC.RefName, TRUE, '', KC );
      S := KC.RefName;
      P_GenerateChildren( SL, KC, S, Prefix + '  ', Updated );
      if KC.fUpdated then
        Updated := TRUE;
      {P}SL.Add( ' DEL //' + KC.Name );
    end;
  finally
    L.Free;
  end;
  LogOK;
  finally
  Log( '<-TKOLForm.P_GenerateChildren' );
  end;
end;

procedure TKOLForm.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.P_SetupLast', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.P_SetupLast' );
  try

  if not FLocked then
  begin
    S := '';
    if CenterOnScreen then
      //S := Prefix + AName + '.CenterOnParent';
      begin
        {P}S := S + ' DUP TControl.CenterOnParent<1>';
      end;
    if not CanResize then
    begin
      {if S = '' then
        S := Prefix + AName;
      S := S + '.CanResize := False';}
      {P}S := S + ' L(0) C1 TControl_.SetCanResize<2>';
    end;
    if S <> '' then
      //SL.Add( S + ';' );
      {P}SL.Add( S );
    if MinimizeNormalAnimated then
      //SL.Add( Prefix + AName + '.MinimizeNormalAnimated;' );
      begin
        {P}SL.Add( ' DUP TControl.MinimizeNormalAnimated<1>' )
      end
    else if RestoreNormalMaximized then
      begin
        SL.Add( ' DUP TControl.RestoreNormalMaximized<1>')
      end;
    if Assigned( FpopupMenu ) then
      //SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
      //        ' );' );
      begin
        {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + FormName + '.' + FpopupMenu.Name );
        {P}SL.Add( ' C1 TControl.SetAutoPopupMenu<2>' );
      end;
    if @ OnFormCreate <> nil then
    begin
      //SL.Add( Prefix + 'Result.' + (Owner as TForm).MethodName( @ OnFormCreate ) + '( Result );' );
      {P}SL.Add( ' LoadSELF DUP T' + FormName + '.' +
                 (Owner as TForm).MethodName( @ OnFormCreate ) + '<2>' );
    end;
  {YS}
    if FborderStyle = fbsDialog then
      //SL.Add( Prefix + AName + '.Icon := THandle(-1);' );
      {P}SL.Add( ' L(-1) C1 TControl_.SetIcon<2>' );
  {YS}

    {P}SL.Add( ' DEL DelAnsiStr DEL(3) EXIT' );
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.P_SetupLast' );
  end;
end;

function TKOLForm.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLForm.HasMainMenu: Boolean;
var i: Integer;
    C: TComponent;
begin
  Result := FALSE;
  if (Owner = nil) or not(Owner is TForm) then Exit;
  for i := 0 to (Owner as TForm).ComponentCount-1 do
  begin
    C := (Owner as TForm).Components[ i ];
    if C is TKOLMainMenu then
    begin
      Result := TRUE;
      Exit;
    end;
  end;
end;

procedure TKOLForm.P_SetupName(SL: TStringList);
begin
  if fP_NameSetuped then Exit;
  if Name <> '' then
  begin
    //SL.Add( '   {$IFDEF USE_NAMES}' );
    //SL.Add( Prefix + AName + '.Name := ''' + Owner.Name + ''';' );
    //SL.Add( '   {$ENDIF}' );
    {P}SL.Add( ' IFDEF(USE_NAMES)' ); // Pcode not yet correctly implemented for DataModule!
    {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Owner.Name ) );
    {P}SL.Add( ' LoadSELF' );
    {P}SL.Add( ' C3 TObj.SetName<3>' );
    {P}SL.Add( ' DelAnsiStr' );
    {P}SL.Add( ' ENDIF' );
    fP_NameSetuped := TRUE;
  end;
end;

procedure TKOLForm.SetupName(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  if FNameSetuped then Exit;
  if (Name <> '') and GenerateCtlNames then
  begin
      if  FormCompact and (AName <> 'nil') then
      begin
          FormAddCtlCommand( 'Form', 'FormSetName', '' );
          FormAddStrParameter( Owner.Name );
      end
      else
      if  AName <> 'nil' {can be 'Result.Form'} then // this control placed NOT on datamodule
          SL.Add( Prefix + AName + '.SetName( ' + {'Result.Form'} 'Applet' + ', ''' + Owner.Name + ''' );')
          // Applet используется для хранения имен форм!
      else  // not on form
          SL.Add(Format( '%sResult.SetName( Result, ''%s'' ); ', [Prefix, Owner.Name]));
      FNameSetuped := TRUE;
  end;
end;

procedure TKOLForm.SetKeyPreview(const Value: Boolean);
begin
  if FKeyPreview = Value then Exit;
  FKeyPreview := Value;
  Change( Self );
end;

procedure TKOLForm.SetOnMoving(const Value: TOnEventMoving);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetOnMoving', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetOnMoving' );
  try
  FOnMoving := Value;
  Change( Self );
  LogOK;
  finally
  Log( '<-TKOLForm.SetOnMoving' );
  end;
end;

procedure TKOLForm.SetRestoreNormalMaximized(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.SetRestoreNormalMaximized', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.SetRestoreNormalMaximized' );
  try

  if not FLocked then
  begin
      if  FRestoreNormalMaximized <> Value then
      begin
          FRestoreNormalMaximized := Value;
          Change( Self );
      end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.SetRestoreNormalMaximized' );
  end;
end;

procedure TKOLForm.SetFontDefault(const Value: Boolean);
begin
    if FFontDefault = Value then Exit;
    FFontDefault := Value;
    TRY
        if Value and (KOLProject <> nil) then
        begin
            TRY
                if Font = nil then
                    Font := TKOLFont.Create(Self);
                TRY
                    Font := KOLProject.DefaultFont;
                EXCEPT
                    ShowMessage( 'exception 3' );
                END;
            EXCEPT
                ShowMessage( 'exception 2' );
            END;
        end;
    EXCEPT
        ShowMessage( 'exception 1' );
    END;
    Change( Self );
end;

procedure TKOLForm.SetFormCompact(const Value: Boolean);
begin
  FFormCompact := Value;
  Change( Self );
end;

function TKOLForm.FormAddAlphabet(const funname: String; creates_ctrl, add_call: Boolean;
         const Comment: String): Integer;
begin
    if  FFormAlphabet = nil then
        FFormAlphabet := TStringList.Create;
    Result := FFormAlphabet.IndexOf( funname );
    if  Result < 0 then
    begin
        Result := FFormAlphabet.Count;
        FFormAlphabet.AddObject( funname, Pointer(Integer( creates_ctrl )) );
    end;
    if  add_call then
    begin
        if  creates_ctrl then
        begin
            FFormCommandsAndParams := FFormCommandsAndParams + #13#10 +
                '    +{' + funname + Comment + '}'#9 + EncodeFormNumParameter( -Result-1 );
        end
          else
        begin
            FFormCommandsAndParams := FFormCommandsAndParams + #13#10 +
                '    +{' + funname + Comment + '}'#9 + EncodeFormNumParameter( Result+1 );
        end;
    end;
end;

procedure TKOLForm.FormAddCtlParameter(const S: String);
begin
    if  FFormCtlParams = nil then
        FFormCtlParams := TStringList.Create;
    FFormCtlParams.Add( S );
end;

procedure TKOLForm.FormAddNumParameter(N: Integer);
begin
    FFormCommandsAndParams := FFormCommandsAndParams + EncodeFormNumParameter( N );
end;

procedure TKOLForm.FormAddStrParameter(const S: String);
var i: Integer;
    in_q: Boolean;
    special: Boolean;
begin
    FFormCommandsAndParams := FFormCommandsAndParams +
        EncodeFormNumParameter( Length( S ) ) + '''';
    in_q := TRUE;
    for i := 1 to Length( S ) do
    begin
        special := S[I] < ' ';
        {$IFDEF _D2009orHigher}
            if  Byte(S[I]) >= 128 then
                special := TRUE;
        {$ELSE}
            if  (Byte(S[I]) >= 128) and not(S[I] in ['А'..'Я', 'а'..'я', 'Ё', 'ё']) then
                special := TRUE;
        {$ENDIF}
        if  special then
        begin
            if  in_q then
                FFormCommandsAndParams := FFormCommandsAndParams + '''';
            in_q := FALSE;
            FFormCommandsAndParams := FFormCommandsAndParams + '#' + Int2Str(Byte(S[I]));
        end
          else
        begin
            if  not in_q then
                FFormCommandsAndParams := FFormCommandsAndParams + '''';
            in_q := TRUE;
            FFormCommandsAndParams := FFormCommandsAndParams + S[I];
        end;
    end;
    if  in_q then
        FFormCommandsAndParams := FFormCommandsAndParams + '''';
end;

procedure TKOLForm.FormAddCtlCommand(const CtlName, FunName, Comment: String);
var i: Integer;
    C: TComponent;
begin
    if  (CtlName <> '')
    and (FormCurrentCtlForTransparentCalls <> CtlName) then
    begin
        //FormAddCtlParameter( CtlName );
        //FormCurrentCtlForTransparentCalls := CtlName;
        C := Owner.FindComponent( CtlName );
        if  (C <> nil) and (C is TKOLTabPage)
        and ((C as TKOLTabPage).Parent is TKOLTabControl) then
        begin
            FormAddAlphabet( 'FormSetCurCtl', FALSE, TRUE, ' ' + CtlName );
            i := FormIndexOfControl( (C as TKOLTabPage).Parent.Name );
            FormAddNumParameter( i );
            FormCurrentCtlForTransparentCalls := (C as TKOLTabPage).Parent.Name;
            FormAddAlphabet( 'FormSetTabpageAsParent', FALSE, TRUE, ' ' + CtlName );
            i := ((C as TKOLTabPage).Parent as TKOLTabControl).IndexOfPage( CtlName );
            FormAddNumParameter( i );
            FormCurrentParent := CtlName;
            FormCurrentParentCtl := C as TKOLControl;
        end
          else
        begin
            FormAddAlphabet( 'FormSetCurCtl', FALSE, TRUE, ' ' + CtlName );
            i := FormIndexOfControl( CtlName );
            FormAddNumParameter( i );
            FormCurrentCtlForTransparentCalls := CtlName;
        end;
    end;
    FormAddAlphabet( FunName, FALSE, TRUE, Comment );
end;

procedure TKOLForm.FormFlushCompact(SL: TFormStringList);
var i, j: Integer;
    s: String;
    //UL: TStringList;
    //CL: TStringList;
    AL: TStringList;
begin
    if  not FormCompact then Exit;
    if  FormFlushedCompact then
        Exit;
    if  IsFormFlushing then Exit;
    IsFormFlushing := TRUE;
    TRY
        SL.OnAdd := nil;
        inc( FormIndexFlush );

        Rpt( 'FormFlushCompact ' + IntToStr( FormIndexFlush ), YELLOW );
        RptDetailed( CopyTail( FFormCommandsAndParams, 100 ), CYAN );
        Rpt_Stack;

        {LogFileOutput( 'C:\BuggMCK+cp.txt', '--------------------- flush ' +
            IntToStr( FormIndexFlush ) + #13#10 + SL.Text + #13#10 +
            '-------------------- cmds&params on flush ' + IntToStr( FormIndexFlush ) +
            ': ' + FFormCommandsAndParams);}
        FFormCommandsAndParams := FFormCommandsAndParams + #13#10'    +#0 {' +
            'flush:' + IntToStr( FormIndexFlush ) + '}';

        {LogFileOutput( 'C:\BuggMCK.txt', '--------------------- flush ' +
            IntToStr( FormIndexFlush ) + #13#10 + SL.Text );}

        if  (FFormCtlParams = nil) or (FFormCtlParams.Count = 0) then
            SL.Add( '    Result.Form.FormExecuteCommands( nil, nil ); ' +
                    '// flush: ' + IntToStr( FormIndexFlush ) )
        else
        begin
            {UL := TStringList.Create;
            CL := TStringList.Create;
            TRY}
                s := UnitSourcePath + FormUnit + '.pas';
                //SL.Add( '// Loading from ' + s );
                //UL.LoadFromFile( s );
                //if  UL.Count > 0 then
                if  FileExists( s ) then
                begin
                    {for i := 0 to UL.Count-1 do
                    begin
                        if  Trim( UL[i] ) = 'Form: PControl;' then
                        begin
                            //SL.Add( '// Form: PControl was found in line ' + IntToStr(i) );
                            CL.Add( 'Form' );
                            for j := i+4 to UL.Count-1 do
                            begin
                                s := Trim( UL[j] );
                                if  pos( ':', s ) <= 0 then break;
                                CL.Add( Trim( Parse( s, ':' ) ) );
                            end;
                            break;
                        end;
                    end;}

                    inc( FormFunArrayIdx );
                    Rpt( 'Adding Result.Form.FormExecuteCommands( @ Result.Form, ' +
                        '@ FormControlsArray' + IntToStr( FormFunArrayIdx ) + '[0]);' +
                        '// flush: ' + IntToStr( FormIndexFlush ), RED );
                    SL.Add( '    Result.Form.FormExecuteCommands( @ Result.Form, ' +
                        '@ FormControlsArray' + IntToStr( FormFunArrayIdx ) + '[0]);' +
                        '// flush: ' + IntToStr( FormIndexFlush ) );
                    AL := TStringList.Create;
                    TRY
                        AL.Add( 'const FormControlsArray' + IntToStr( FormFunArrayIdx ) +
                            ': array[0..' +
                            IntToStr( FFormCtlParams.Count-1 ) +
                            '] of SmallInt = (' );
                        for i := 0 to FFormCtlParams.Count-1 do
                        begin
                            j := //CL.IndexOf( FFormCtlParams[i] );
                                 FormIndexOfControl( FFormCtlParams[i] );
                            s := Int2Str(j) + ' {' + FFormCtlParams[i] + '}';
                            if  i < FFormCtlParams.Count-1 then
                                s := s + ','
                            else
                                s := s + ' );';
                            AL.Add( '        ' + s );
                        end;
                        for i := SL.Count-1 downto 0 do
                        begin
                            s := SL[i];
                            if  s = 'begin' then
                            begin
                                for j := AL.Count-1 downto 0 do
                                    SL.Insert( i, AL[j] + ' // -- ' + IntToStr(j) );
                                break;
                            end;
                        end;
                    FINALLY
                        AL.Free;
                    END;

                end else
                begin
                    Rpt( 'not FileExists: ' + s, RED );
                end;

                {if  CL.Count = 0 then
                begin
                    SL.Add( '// Source Unit not found!!!' );
                    SL.Add( '    Result.Form.FormExecuteCommands( @ Result.Form, [ ' );
                    for i := 0 to FFormCtlParams.Count-1 do
                    begin
                        s := '(Integer(@ Result.' + FFormCtlParams[i] +
                             ') - Integer(@ Result.Form) ) div 4';
                        if  i < FFormCtlParams.Count-1 then
                            s := s + ','
                        else
                            s := s + ' ] );';
                        SL.Add( '        ' + s );
                    end;
                end;}
            {FINALLY
                UL.Free;
                CL.Free;
            END;}

            FFormCtlParams.Clear;
        end;
        //SL.Add( '// flush: ' + IntToStr( FormIndexFlush ) );
        FormFlushedUntil := Length( FFormCommandsAndParams );

        {LogFileOutput( 'C:\BuggMCKafter.txt', '--------------------- flushed ' +
            IntToStr( FormIndexFlush ) + #13#10 + SL.Text );}

        SL.OnAdd := DoFlushFormCompact;
    FINALLY
        IsFormFlushing := FALSE;
    END;
end;

procedure TKOLForm.SetGenerateCtlNames(const Value: Boolean);
begin
  if  FGenerateCtlNames = Value then Exit;
  FGenerateCtlNames := Value;
  Change( Self );
end;

function TKOLForm.FormFlushedCompact: Boolean;
begin
    Result := Length( FFormCommandsAndParams ) <= FormFlushedUntil;
end;

procedure TKOLForm.SetUnicode(const Value: Boolean);
begin
  FUnicode := Value;
  Change( Self );
end;

procedure TKOLForm.DoFlushFormCompact(Sender: TObject);
begin
    FormFlushCompact( Sender as TFormStringList );
end;

procedure TKOLForm.GenerateTransparentInits_Compact;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLForm.GenerateTransparentInits_Compact', 0
  @@e_signature:
  end;
  Log( '->TKOLForm.GenerateTransparentInits_Compact' );
  try
  if not FLocked then
  begin

    if not DefaultPosition then
    begin
      if not DoNotGenerateSetPosition then
      begin
        if  FBounds <> nil then
        begin
            FormAddCtlCommand( 'Form', 'FormSetPosition', '' );
            FormAddNumParameter( Bounds.Left );
            FormAddNumParameter( Bounds.Top );
        end;
      end;

    end;

    if not DefaultSize then
    begin
      if (Owner = nil) or not(Owner is TForm) then
        if HasCaption then
        begin
             FormAddCtlCommand( 'Form', 'FormSetSize', '' );
             FormAddNumParameter( Bounds.Width );
             FormAddNumParameter( Bounds.Height );
        end
        else
        begin
             FormAddCtlCommand( 'Form', 'FormSetSize', '' );
             FormAddNumParameter( Bounds.Width );
             FormAddNumParameter( Bounds.Height - GetSystemMetrics(SM_CYCAPTION) );
        end;
    end;

    if  Tabulate then
        FormAddCtlCommand( 'Form', 'TControl.Tabulate', '' )
    else
    if  TabulateEx then
        FormAddCtlCommand( 'Form', 'TControl.TabulateEx', '' );

    if  PreventResizeFlicks then
        FormAddCtlCommand( 'Form', 'TControl.PreventResizeFlicks', '' );

    if  supportMnemonics then
        FormAddCtlCommand( 'Form', 'TControl.SupportMnemonics' , '');

    if  HelpContext <> 0 then
    begin
        FormAddCtlCommand( 'Form', 'FormAssignHelpContext', '' );
        FormAddNumParameter( HelpContext );
    end;
  end;

  LogOK;
  finally
  Log( '<-TKOLForm.GenerateTransparentInits_Compact' );
  end;
end;

function TKOLForm.EncodeFormNumParameter(I: Integer): String;
var b: Byte;
    Buffer: array[ 0..7 ] of Byte;
    k, j, II: Integer;
    Sign: Boolean;
begin
    II := I;
    TRY
        k := 0;
        if  I = 0 then
        begin
            k := 1;
            Buffer[0] := 0;
        end
          else
        begin
            Sign := FALSE;
            if  I < 0 then
            begin
                I := -I;
                Sign := TRUE;
            end;
            while TRUE do
            begin
                if  k = 0 then
                begin
                    b := I shl 2;
                    if  Sign then
                        b := b or 2;
                    I := I shr 6;
                    Buffer[k] := b;
                    inc( k );
                    if  I = 0 then break;
                end else
                if  I and not $7F = 0 then
                begin
                    b := I shl 1;
                    //I := DWORD( I ) shr 7;
                    Buffer[k] := b;
                    inc( k );
                    break;
                end else
                begin
                    b := I shl 1;
                    I := DWORD( I ) shr 7;
                    Buffer[k] := b;
                    inc( k );
                    continue;
                end;
            end;
        end;

        Result := '';
        for j := k-1 downto 0 do
        begin
            b := Buffer[j];
            if  j > 0 then
                b := b or 1;
            Result := Result + '#$' + Int2Hex( b, 2 );
        end;
    EXCEPT on E: Exception do
           begin
               RptDetailed( 'exception ' + E.Message + #13#10 +
               '(in EncodeFormNumParameter I = ' + IntToStr( II ) + ')',
               RED );
           end;
    END;
end;

function TKOLForm.FormIndexOfControl(const CtlName: String): Integer;
var s: KOLString;
    UL: TStringList;
    i, j: Integer;
begin
    if  FormControlsList = nil then
    begin
        RptDetailed( 'Loading source of ' + FormUnit, WHITE );
        FormControlsList := TStringList.Create;
        s := UnitSourcePath + FormUnit + '.pas';
        UL := TStringList.Create;
        TRY
            LoadSource( UL, s );
            RptDetailed( 'source loaded, searching Form: PControl', WHITE );
            for i := 0 to UL.Count-1 do
            begin
                if  Trim( UL[i] ) = 'Form: PControl;' then
                begin
                    FormControlsList.Add( 'Form' );
                    for j := i+4 to UL.Count-1 do
                    begin
                        s := Trim( UL[j] );
                        if  pos( ':', s ) <= 0 then break;
                        FormControlsList.Add( Trim( Parse( s, ':' ) ) );
                    end;
                    break;
                end;
            end;
        FINALLY
            UL.Free;
        END;
    end;
    RptDetailed( 'searching ' + CtlName, WHITE );
    Result := FormControlsList.IndexOf( CtlName );
end;

procedure TKOLForm.SetOverrideScrollbars(const Value: Boolean);
begin
  FOverrideScrollbars := Value;
end;

procedure TKOLForm.SetAssignTextToControls(const Value: Boolean);
begin
  if  fAssignTextToControls = Value then Exit;
  fAssignTextToControls := Value;
  Change( Self );
end;

procedure TKOLForm.SetAssignTabOrders(const Value: Boolean);
begin
  if  FAssignTabOrders = Value then Exit;
  FAssignTabOrders := Value;
  Change( Self );
end;

function TKOLForm.GetFormCompact: Boolean;
begin
    Result := FFormCompact;
    if  (KOLProject <> nil) and KOLProject.FormCompactDisabled then
        Result := FALSE;
end;

procedure TKOLForm.SetFormCurrentParent(const Value: String);
begin
  RptDetailed( 'FormCurrentParent set to ' + Value + ' (was: ' + fFormCurrentParent + ')',
      CYAN );
  fFormCurrentParent := Value;
end;

procedure TKOLForm.ClearBeforeGenerateForm(SL: TStringList);
begin
    if  not FormCompact then Exit;
    SL.Add( '  //--< place to call FormCreateParameters >--//' );
    FreeAndNil( FFormAlphabet );
    FreeAndNil( FFormCtlParams );
    FFormAlphabet := TStringList.Create;
    FFormCtlParams := TStringList.Create;
    Rpt( 'Clear before GenerateCreateForm (FormCompact', WHITE + LIGHT );
    FFormCommandsAndParams := '';
    FormCurrentParent := '';
    FormCurrentParentCtl := nil;
    FormCurrentCtlForTransparentCalls := 'Form';
    GenerateTransparentInits_Compact;
    FormFlushedUntil := 0;
    FormIndexFlush := 0;
    FreeAndNil( FormControlsList );
end;

{ TKOLProject }

procedure TKOLProject.AfterGenerateDPR(const SL: TStringList; var Updated: Boolean);
begin
  Log( 'TKOLProject.AfterGenerateDPR' );
end;

procedure TKOLProject.BeforeGenerateDPR(const SL: TStringList; var Updated: Boolean);
begin
  Log( 'TKOLProject.BeforeGenerateDPR' );
end;

procedure TKOLProject.BroadCastPaintTypeToAllForms;
var I, J: Integer;
    F: TForm;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.BroadCastPaintTypeToAllForms', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.BroadCastPaintTypeToAllForms' );
  TRY

    if Screen <> nil then
    for I := 0 to Screen.FormCount-1 do
    begin
      F := Screen.Forms[ I ];
      for J := 0 to F.ComponentCount-1 do
      begin
        C := F.Components[ J ];
        if C is TKOLForm then
          (C as TKOLForm).PaintType := PaintType;
      end;
    end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.BroadCastPaintTypeToAllForms' );
  END;
end;

procedure TKOLProject.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Change', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Change' );
  TRY

  if fChangingNow or FLocked or (csLoading in ComponentState) then
  begin
    LogOK;
    Exit;
  end;
  fChangingNow := TRUE;
  try

    if AutoBuild then
    begin
      if fTimer <> nil then
      begin
        if FAutoBuildDelay > 0 then
        begin
          Rpt( 'Autobuild timer off/on', WHITE );
          //Rpt_Stack;
          fTimer.Enabled := False;
          fTimer.Enabled := True;
        end
           else
        begin
          RptDetailed( 'Calling TimerTick directly', WHITE );
          //Rpt_Stack;
          fTimer.Enabled := FALSE;
          TimerTick( fTimer );
          fTimer.Enabled := FALSE;
        end;
      end;
    end;

  finally
    fChangingNow := FALSE;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.Change' );
  END;
end;

procedure TKOLProject.ChangeAllForms;
var I: Integer;
    F: TKolForm;
begin
  if FormsList <> nil then
  for I := 0 to FormsList.Count - 1 do
  begin
    F := FormsList[ I ];
    F.Change( F );
  end;
end;

function TKOLProject.ConvertVCL2KOL( ConfirmOK: Boolean; ForceAllForms: Boolean ): Boolean;
var I, E, N: Integer;
    F: TKolForm;
    S, E_reason: String;
    tmp: String;
    Color: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.ConvertVCL2KOL', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.ConvertVCL2KOL' );
  TRY

  Result := FALSE;
  if not FLocked then
  begin
    if ProjectDest = '' then
    begin
      if not AutoBuilding then
      ShowMessage( 'You have forgot to assign valid name to ProjectDest property ' +
                   'TKOLProject component, which define KOL project name after ' +
                   'converting of your mirror project. It must not much name of any other ' +
                   'form in your project (FormName property of correspondent ' +
                   'TKOLForm component). But if You want, it can much the name of ' +
                   'source project (it will be stored in \KOL subdirectory, created ' +
                   'in directory with source (mirror) project).' );
      LogOK;
      Exit;
    end;
    if FormsList = nil then
    begin
      if not AutoBuilding then
      ShowMessage( 'There are not found TKOLForm component instances. You must create '+
                   'an instance for each form in your mirror project to provide ' +
                   'converting mirror project to KOL.' );
      LogOK;
      Exit;
    end;
    FBuilding := True;
    try

    fOutdcuPath := '';
    S := SourcePath;
    S := S + ProjectDest;
    E := 0;
    E_reason := '';
    if not GenerateDPR( S ) then
    begin
      Inc( E );
      E_reason := 'dpr:' + S;
    end;
    N := 0;
    if FormsList <> nil then
    for I := 0 to FormsList.Count - 1 do
    begin
      F := FormsList[ I ];
      if not ForceAllForms and not F.FChanged then continue;
      S := SourcePath + F.FormUnit;
      if not F.GenerateUnit( S ) then
      begin
        Inc( E );
        E_reason := E_reason + ' unit:' + S;
      end
      else
        Inc( N );
    end;
    if E = 0 then
      if not IsKOLProject then
        UpdateConfig;
    Color := WHITE;
    if E = 0 then
    begin
      S := 'Converting finished successfully.';
      Color := GREEN;
      if not ConfirmOK then S := '';
      Result := N > 0;
      if Trim( CallPCompiler ) <> '' then
      begin
        tmp := '/S "' + IncludeTrailingPathDelimiter( ProjectSourcePath ) +
            ProjectDest + '.exe"';
        I := ShellExecute( 0, nil, PChar( CallPCompiler ),
          PChar(tmp), PChar( ProjectSourcePath ), SW_HIDE );
        RptDetailed( 'Called pcompiler: ' + IntToStr( I ), GREEN );
      end;
    end
    else
    begin
      if N > 0 then
      begin
        S := 'Converting finished.'#13 + IntToStr( E ) + ' errors found( ' +
          E_reason + ')';
        Color := RED;
      end;
    end;
    if S <> '' then
      Report( S, color );

    except
      on E: Exception do
      begin
        ShowMessage( 'Can not convert VCL to KOL, exception: ' + E.Message );
      end;
    end;
  end;

  FBuilding := False;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.ConvertVCL2KOL' );
  END;
end;

constructor TKOLProject.Create(AOwner: TComponent);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Create', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Create' );
  TRY

  inherited;
  {$IFDEF _D6orHigher}
  FNewIF := TRUE;
  {$ELSE}
  FNewIF := FALSE;
  {$ENDIF}

  fAutoBuild := True;
  fAutoBuildDelay := 500;
  fProtect := True;
  fShowReport := FALSE; // True;
  fTimer := TTimer.Create( Self );
  fTimer.Interval := 500;
  fTimer.OnTimer := TimerTick;
  fTimer.Enabled := FALSE;
  FDefaultFont := TKOLFont.Create(Self);
  FDefaultFont.FontName := 'System';

  if AOwner <> nil then
  for I := 0 to AOwner.ComponentCount-1 do
  begin
    C := AOwner.Components[ I ];
    if IsVCLControl( C ) then
    begin
      FLocked := TRUE;
      ShowMessage( 'The form ' + AOwner.Name + ' contains already VCL controls.'#13 +
      'The TKOLProject component is locked now and will not functioning.'#13 +
      'Just delete it and never drop onto forms, beloning to VCL projects.' );
      break;
    end;
  end;
  if not FLocked then
  begin

    if (KOLProject <> nil) and (KOLProject.Owner <> AOwner) then
      ShowMessage( 'You have more then one instance of TKOLProject component in ' +
                   'your mirror project. Please remove all ambigous ones before ' +
                   'running the project to avoid problems with generating code.' +
                   ' Or, may be, you open several projects at a time or open main ' +
                   'form of another KOL&MCK project. This is not allowed.' )
    else
    begin
      KOLProject := Self;
      if not( csDesigning in ComponentState) then
      begin
        ShowMessage( 'You did not finish converting VCL project to MCK. ' +
                     'Do not forget, that you first must drop TKOLProject on ' +
                     'form and change its property projectDest, and then drop ' +
                     'TKOLForm component. Then you can open destination (MCK) project' +
                     ' and work with it.' );
        PostQuitMessage( 0 );
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.Create' );
  END;
end;

destructor TKOLProject.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Destroy', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Destroy' );
  FIsDestroying := TRUE;
  TRY

  if KOLProject = Self then
    KOLProject := nil;
  if FConsoleOut then
    FreeConsole;
  ResStrings.Free;
  DefaultFont.Free;
  inherited;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.Destroy' );
  END;
end;

type
  TFormKind = ( fkNormal, fkMDIParent, fkMDIChild );

function FormKind( const FName: String; var ParentFName: String ): TFormKind;
const Kinds: array[ TFormKind ] of String = ( 'fkNormal', 'fkMDIParent', 'fkMDIChild' );
var I, J: Integer;
    UN: String;
    MI: TIModuleInterface;
    FI: TIFormInterface;
    FCI, CI: TIComponentInterface;
    KindDefined: Boolean;
    S, ObjName, ObjType: KOLString;
    SL: TStringList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'FormKind', 0
  @@e_signature:
  end;
  Log( '->FormKind' );
  TRY

  Rpt( 'Analizing form: ' + FName, WHITE );
  //Rpt_Stack;
  Result := fkNormal;
  TRY

  KindDefined := FALSE;
  //-- 1. Try to search a form among loaded into the designer.
  for I := 0 to ToolServices.GetUnitCount-1 do
  begin
    UN := ToolServices.GetUnitName( I );
    MI := ToolServices.GetModuleInterface( UN );
    if MI <> nil then
    TRY
      FI := MI.GetFormInterface;
      if FI <> nil then
      TRY
        FCI := FI.GetFormComponent;
        if FCI <> nil then
        TRY
          S := '';
          FCI.GetPropValueByName( 'Name', S );
          //Rpt( 'Form component interface obtained for ' + FName +
          //     ', Name=' + S + ' (Unit=' + UN + ')', WHITE );
          if  AnsiCompareText( S, FName ) = 0 then
          for J := 0 to FCI.GetComponentCount-1 do
          begin
            CI := FCI.GetComponent( J );
            if CI.GetComponentType = 'TKOLMDIClient' then
            begin
              Rpt( 'TKOLMDIClient found in ' + FName, WHITE );
              Result := fkMDIParent;
              KindDefined := TRUE;
            end
              else
            if CI.GetComponentType = 'TKOLMDIChild' then
            begin
              Rpt( 'TKOLMDIChild found in ' + FName, WHITE );
              Result := fkMDIChild;
              CI.GetPropValueByName( 'ParentMDIForm', ParentFName );
              KindDefined := TRUE;
            end;
            if KindDefined then
            begin
              LogOK;
              Exit;
            end;
          end
            else
          if S = '' then
          begin
            if CompareText( ExtractFileExt( UN ), '.pas' ) = 0 then
            begin
              SL := TStringList.Create;
              TRY
                SL.LoadFromFile( ChangeFileExt( UN, '.dfm' ) );
                Rpt( 'Loaded dfm for ' + UN, WHITE );
                ObjName := '';
                ObjType := '';
                KindDefined := FALSE;
                for J := 0 to SL.Count-1 do
                begin
                  S := Trim( SL[ J ] );
                  if StrIsStartingFrom( PKOLChar( S ), 'object ' ) then
                  begin
                    Parse( S, AnsiString(' ') );
                    ObjName := Trim( Parse( S, ':' ) );
                    ObjType := Trim( S );
                    if J = 0 then
                    begin
                      if  AnsiCompareText( ObjName, FName ) <> 0 then
                      begin
                          Rpt( 'Another form - - continue', WHITE );
                          break;
                      end;
                    end;
                    if (ObjType = 'TKOLMDIClient') then
                    begin
                      Rpt( 'TKOLMDIClient found for ' + FName + ' in dfm', WHITE );
                      Result := fkMDIParent;
                      KindDefined := TRUE;
                    end;
                  end
                    else
                  begin
                    if not KindDefined and
                       (ObjType = 'TKOLMDIChild') and
                       StrIsStartingFrom( PKOLChar( S ), 'ParentMDIForm = ' ) then
                    begin
                      Rpt( 'TKOLMDIChild found for ' + FName + ' in dfm', WHITE );
                      Result := fkMDIChild;
                      KindDefined := TRUE;
                      Parse( S, '=' );
                      S := Trim( S );
                      if Length( S ) > 2 then
                        S := Copy( S, 2, Length( S ) - 2 );
                      ParentFName := S;
                    end;
                  end;
                  if KindDefined then
                  begin
                    LogOK;
                    Exit;
                  end;
                end;
              FINALLY
                SL.Free;
              END;
            end;
          end;
        FINALLY
          FCI.Free;
        END;
      FINALLY
        FI.Free;
      END;
    FINALLY
      MI.Free;
    END;
  end;
  Result := fkNormal;
  FINALLY
    Rpt( 'Analized form ' + FName + 'Kind: ' + Kinds[ Result ], WHITE );
  END;

  LogOK;
  FINALLY
    Log( '<-FormKind' );
  END;
end;

procedure ReorderForms( Prj: TKOLProject; Forms: TStringList );
var Rslt: TStringList;
    I, J: Integer;
    FormName, Name2, ParentFormName: String;
    S: KOLString;
    Kind: TFormKind;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ReorderForms', 0
  @@e_signature:
  end;
  Log( '->ReorderForms' );
  TRY

  Rslt := TStringList.Create;
  TRY
    /// D[u]fa
    ///  без проверки на 0 падала генерация кода
    ///  после добавления все работает (по идее эта проврка исключает вызов
    ///  FormKind в котором скорее всего ошибка)
    ///  дальше копать не стал
    for I := 0 to Forms.Count-1 do
    if Assigned(Forms.Objects[I]) then
    begin
      Kind := FormKind( Forms.Strings[ I ], ParentFormName );
//rpt('->ReorderForms2', YELLOW);
      Forms.Objects[ I ] := Pointer( Kind );
      if Kind = fkMDIChild then
        Forms[ I ] := Forms[ I ] + ',' + ParentFormName;
    end;
    for I := 0 to Forms.Count-1 do
    begin
      FormName := Forms[ I ];
      if FormName = '' then continue;
      Kind := TFormKind( Forms.Objects[ I ] );
      if Kind in [ fkNormal, fkMDIParent ] then
      begin
        Rslt.Add( FormName );
        Forms[ I ] := '';
      end;
      if Kind = fkMDIParent then
      for J := 0 to Forms.Count - 1 do
      begin
        Name2 := Forms[ J ];
        if Name2 = '' then continue;
        if TFormKind( Forms.Objects[ J ] ) = fkMDIChild then
        begin
          S := Name2;
          {$IFDEF UNICODE_CTRLS} ParseW {$ELSE} Parse {$ENDIF} ( S, ',' );
          if CompareText( S, FormName ) = 0 then
          begin
            Rslt.Add( Name2 );
            Forms[ J ] := '';
          end;
        end;
      end;
    end;
    Forms.Assign( Rslt );
  FINALLY
    Rslt.Free;
  END;

  LogOK;
  FINALLY
    Log( '<-ReorderForms' );
  END;
end;

function TKOLProject.GenerateDPR(const Path: String): Boolean;
const BeginMark = 'begin // PROGRAM START HERE -- Please do not remove this comment';
      BeginResourceStringsMark = '// RESOURCE STRINGS START HERE -- Please do not change this section';
var SL, Source, AForms: TStringList;
    A, S, S1, FM: KOLString;
    I, J: Integer;
    F: TKOLForm;
    Found: Boolean;
    Updated: Boolean;
    Object2Run: TObject;
    IsDLL: Boolean;
    /////////////////////////////////////////////////////////////////////////
    procedure Prepare_0inc;
    var SL: TStringList;
        I, J: Integer;
        S: String;
        {$IFDEF _D2009orHigher}
         C, C2: WideString;
        {$ELSE}
         C: string;
        {$ENDIF}
    begin
      // prepare <ProjectDest>_0.inc, which is to replace
      // begin .. end. of a project.

      SL := TStringList.Create;
      TRY

      SL.Add( Signature );
      SL.Add( '{ ' + ProjectDest + '_0.inc' );
      SL.Add( '  Do not edit this file manually - it is generated automatically.' );
      SL.Add( '  You can only modify ' + ProjectDest + '_1.inc and ' + ProjectDest + '_3.inc' );
      SL.Add( '  files. }' );
      SL.Add( '' );

      SL.Add( '{$IFDEF Pcode}' );
      SL.Add( ' InstallCollapse;' );
      SL.Add( '{$ENDIF Pcode}' );

      if SupportAnsiMnemonics <> 0 then
      begin
        if SupportAnsiMnemonics = 1 then
          I := GetUserDefaultLCID
        else
          I := SupportAnsiMnemonics;
        SL.Add( '  SupportAnsiMnemonics( $' + IntToHex( I, 8 ) + ' );' );
      end;

      if Applet <> nil then
      begin
        C := Applet.Caption;
        {$IFDEF _D2009orHigher}
         C2 := '';
         for i := 1 to Length(C) do C2 := C2 + '#'+int2str(ord(C[i]));
         C := C2;
         SL.Add( '  Applet := NewApplet( ' + C + ' );' );
        {$ELSE}
         SL.Add( '  Applet := NewApplet( ''' + C + ''' );' );
        {$ENDIF}
        if not Applet.Visible then
        begin
          SL.Add( '  Applet.GetWindowHandle;' );
          SL.Add( '  Applet.Visible := False;' );
        end;
        if (Applet.Icon <> '') or Applet.ForceIcon16x16 then
        begin
          if Copy( Applet.Icon, 1, 4 ) = 'IDI_' then
            SL.Add( '  Applet.IconLoad( 0, ' + Applet.Icon + ' );' )
          else
          if Applet.Icon = '-1' then
            SL.Add( '  Applet.Icon := THandle(-1);' )
          else
          begin
            if (Applet.Icon <> '-1') and Applet.ForceIcon16x16 then
            begin
              S := Applet.Icon;
              if S = '' then
                S := 'MAINICON';
              SL.Add( '  Applet.Icon := LoadImgIcon( ' + String2Pascal( S, '+' ) + ', 16 );' );
            end
              else
            SL.Add( '  Applet.IconLoad( hInstance, ''' + Applet.Icon + ''' );' );
          end;
        end;
      end
        else
      if not IsDLL then
      begin
        for I := 0 to FormsList.Count - 1 do
        begin
          F := FormsList[ I ];
          if F is TKOLFrame then continue;
          if F.FormMain then
          begin
            SL.Add( '  New' + F.FormName + '( ' + F.FormName + ', ' +
                    A + ' );' );
            //SL.Add( '  Applet := ' + F.FormName + '.Form;' );
            A := F.FormName + '.Form';
            Object2Run := F;

          end;
        end;
      end;

      SL.Add( '{$I ' + ProjectDest + '_1.inc}' );

      SL.Add( '' );
      SL.Add( '{$I ' + ProjectDest + '_2.inc}' );

      SL.Add( '' );
      SL.Add( '{$I ' + ProjectDest + '_3.inc}' );

      SL.Add( '' );

      FM := '';
      if FormsList <> nil then
      for I := 0 to FormsList.Count - 1 do
      begin
        F := FormsList[ I ];
        if F is TKOLFrame then continue;
        if F.FormMain then
        begin
          FM := F.FormName + '.Form';
          if Object2Run = nil then
            Object2Run := F;
        end;
      end;

      if A <> 'nil' then
        FM := A;

      if (HelpFile <> '') and not IsDLL then
      begin
        if  AnsiCompareText( ExtractFileExt( HelpFile ), '.chm' ) = 0 then
            SL.Add( '  AssignHtmlHelp( ' + StringConstant( 'HelpFile', HelpFile ) + ' );' )
        else
            SL.Add( '  Applet.HelpPath := ' + StringConstant( 'HelpFile', HelpFile ) + ';' );
      end;
      if not IsDLL then
      begin
        TKOLApplet( Object2Run ).GenerateRun( SL, FM );
        //SL.Add( '  Run( ' + FM + ' );' );

        if FormsList <> nil then
        for I := 0 to FormsList.Count - 1 do
        begin
          F := FormsList[ I ];
          if F is TKOLFrame then continue;
          Found := FALSE;
          for J := 0 to AForms.Count-1 do
          begin
            if CompareText( AForms[ J ], F.FormName ) = 0 then
            begin
              Found := TRUE;
              break;
            end;
          end;
          if Found then
            F.GenerateDestroyAfterRun( SL );
        end;
      end;

      SL.Add( '' );
      SL.Add( '{$I ' + ProjectDest + '_4.inc}' );

      SL.Add( '' );
      SaveStrings( SL, Path + '_0.inc', Updated );

      FINALLY
        SL.Free;
      END;
    end;

    /////////////////////////////////////////////////////////////////////////
    procedure Prepare_134inc;
    var SL: TStringList;
    begin

      SL := TStringList.Create;
      TRY

      // if files _1.inc and _3.inc do not exist, create it (empty).

      if not FileExists( Path + '_1.inc' ) then
      begin
        SL.Add( '{ ' + ProjectDest + '_1.inc' );
        SL.Add( '  This file is for you. Place here any code to run it' );
        SL.Add( '  just following Applet creation (if it present) but ' );
        SL.Add( '  before creating other forms. E.g., You can place here' );
        SL.Add( '  <IF> statement, which prevents running of application' );
        SL.Add( '  in some cases. TIP: always use Applet for such checks' );
        SL.Add( '  and make it invisible until final decision if to run' );
        SL.Add( '  application or not. }' );
        SL.Add( '' );
        SaveStrings( SL, Path + '_1.inc', Updated );
        SL.Clear;
      end;

      if not FileExists( Path + '_3.inc' ) then
      begin
        SL.Add( '{ ' + ProjectDest + '_3.inc' );
        SL.Add( '  This file is for you. Place here any code to run it' );
        SL.Add( '  after forms creating, but before Run call, if necessary. }' );
        SL.Add( '' );
        SaveStrings( SL, Path + '_3.inc', Updated );
        SL.Clear;
      end;

      if not FileExists( Path + '_4.inc' ) then
      begin
        SL.Add( '{ ' + ProjectDest + '_4.inc' );
        SL.Add( '  This file is for you. Place here any code to be inserted' );
        SL.Add( '  after Run call, if necessary. }' );
        SL.Add( '' );
        SaveStrings( SL, Path + '_4.inc', Updated );
        SL.Clear;
      end;

      FINALLY
        SL.Free;
      END;
    end;

    ////////////////////////////////////////////////////////////////////////
    procedure Prepare_2inc;
    var SL: TStringList;
        I, J: Integer;
    begin
      SL := TStringList.Create;
      TRY
      // for now, generate <ProjectName>_2.inc
      SL.Add( Signature );
      SL.Add( '{ ' + ProjectDest + '_2.inc' );
      SL.Add( '  Do not modify this file manually - it is generated automatically. }' );
      SL.Add( '' );

      if not IsDLL then
      begin
        for I := 0 to AForms.Count - 1 do
        begin
          S := AForms[ I ];
          S := Trim( {$IFDEF UNICODE_CTRLS} ParseW {$ELSE} Parse {$ENDIF} ( S, ',' ) );
          F := nil;
          for J := 0 to FormsList.Count - 1 do
          begin
            F := FormsList[ J ];
            if CompareText( AForms[ I ], F.formName ) = 0 then
              break
            else
              F := nil;
              // Это недостаточно, чтобы решить, что перед нами frame, а не form.
              // Фрейм должен быть исключен из списка авто-create.
          end;
          if (F <> nil) and (F is TKOLFrame) then continue;
          //Rpt( 'AutoForm: ' + S );
          if LowerCase( A ) = LowerCase( S + '.Form' ) then Continue;
          if pos( ',', AForms[ I ] ) > 0 then
          begin
            // MDI child form
            S1 := AForms[ I ];
            Parse( S1, ',' );
            SL.Add( '  New' + Trim( S ) + '( ' + Trim( S ) + ', ' +
                    Trim( S1 ) + '.Form );' );
          end
            else
          begin
            // normal or MDI parent form
            SL.Add( '  New' + S + '( ' + S + ', Pointer( ' + A + ' ) );' );
          end;
        end;
      end;

      SaveStrings( SL, Path + '_2.inc', Updated );

      FINALLY
        SL.Free;
      END;
    end;

    /////////////////////////////////////////////////////////////////////////

var Kol_added, DontChangeUses: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GenerateDPR', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GenerateDPR' );
  TRY

  Rpt( 'Generating DPR for ' + Path, WHITE ); //Rpt_Stack;
  Result := False;
  if FLocked then
  begin
    Rpt( 'TKOLProject LOCKED.', RED );
    LogOK; Exit;
  end;
  Updated := FALSE;
  SL := TStringList.Create;
  Source := TStringList.Create;
  AForms := TStringList.Create;

  try

  ResStrings.Free;
  ResStrings := nil;

  // First, generate <ProjectName>.dpr
  // TODO: dll in B.dpr of A.dproj start from MSBuild to 2009
  // TODO: may output inc files into old folders if MCK projects moved or KOLProject/KOLForm properties out of date
  S := ExtractFilePath( Path ) + ProjectName + '.dpr';
  LoadSource( Source, S );
  if Source.Count = 0 then
  begin
    S := ExtractFilePath( Path ) + ExtractFileNameWOExt( Path ) + '.dpr';
    LoadSource( Source, S );
  end;
  IsDLL := FALSE;
  for I := 0 to Source.Count-1 do
  begin
    if pos( 'library', LowerCase( Source[ I ] ) ) > 0 then
    begin
      IsDLL := TRUE;
      break;
    end
      else
    if pos( 'program', LowerCase( Source[ I ] ) ) > 0 then
      break;
  end;
  if Source.Count = 0 then
  begin
    Rpt( 'Could not get source from ' + S, WHITE );
    SL.Free;
    Source.Free;
    LogOK;
    Exit;
  end;

  BeforeGenerateDPR( SL, Updated );

  Object2Run := nil;
  A := 'nil';
  if Applet <> nil then  // TODO: TKOLApplet must be on main form
  begin                  // (to be always available for TKOLProject)
    A := 'Applet';
    Object2Run := Applet;
  end;

  SL.Clear;

  J := -1;
  for I := 0 to Source.Count - 1 do
  begin
    if Source[ I ] = 'begin' then
    begin
      if J = -1 then J := I else J := -2;
    end;
    if Source[ I ] = BeginMark then
    begin
      J := I; break;
    end;
  end;
  if J >= 0 then
    Source[ J ] := BeginMark
  else
  begin
    ShowMessage( 'Error while converting dpr: begin markup could not be found. ' +
                 'Dpr-file of the project must either have a single line having only ' +
                 '''begin'' reserved word at the beginning or such line must be marked ' +
                 'with special comment:'#13 +
                 BeginMark );
    LogOK;
    Exit;
  end;
  RptDetailed( 'generate dpr -- A', WHITE );
  // copy lines from the first to 'begin', making
  // some changes:
  SL.Add( Signature ); // insert signature
  S := '';
  I := -1;
  Kol_added := FALSE;
  DontChangeUses := FALSE;
  while I < Source.Count - 1 do
  begin
    Inc( I );
    S := Source[ I ];
    RptDetailed( 'generate dpr -- A1 - ' + IntToStr(I) + ': ' + S, WHITE );
    if RemoveSpaces( S ) = RemoveSpaces( Signature ) then continue; // skip signature if present
    if LowerCase( Trim( S ) ) = LowerCase( 'program ' + ProjectName + ';' ) then
    begin
      SL.Add( 'program ' + ProjectDest + ';' );
      continue;
    end;
    if (LowerCase( Trim( S ) ) = LowerCase( 'library ' + ProjectName + ';' ))
    then
    begin
      SL.Add( 'library ' + ProjectDest + ';' );
      continue;
    end;
    if S = BeginMark then
      break;
    RptDetailed( 'generate dpr -- A2', WHITE );
    if S = '//don''t change uses' then
      DontChangeUses := TRUE;
    if not DontChangeUses then
    begin
      RptDetailed( 'generate dpr -- A3', WHITE );
      if LowerCase( Trim( S ) ) = 'uses' then
      begin
        SL.Add( S );
        SL.Add( 'KOL,' );
        Kol_added := TRUE;
        continue;
      end;
      RptDetailed( 'generate dpr -- A4', WHITE );
      if Kol_added then
      begin
        J := IndexOfStr( S, 'KOL,' ); //pos( 'KOL,', S );
        if J > 0 then
        begin
          S := Copy( S, 1, J-1 ) + Copy( S, J+4, Length( S )-J-3 );
          if Trim( S ) = '' then continue;
        end;
      end;
      RptDetailed( 'generate dpr -- A5: <' + S + '>', WHITE );
      J := IndexOfStr( S, 'Forms,' ); // pos( 'Forms,', S );
      RptDetailed( 'generate dpr -- A5-a', WHITE );
      if J > 0 then // remove reference to Forms.pas
      begin
        S := Copy( S, 1, J-1 ) + Copy( S, J+6, Length( S )-J-5 );
        if Trim( S ) = '' then continue;
      end;
    end;
    RptDetailed( 'generate dpr -- A6', WHITE );
    J := pos( '{$r *.res}', LowerCase( S ) );
    if J > 0 then // remove/insert reference to project resource file
      if DprResource then
        S := '{$R *.res}'
      else
        S := '//{$R *.res}';
    SL.Add( S );
  end;
  RptDetailed( 'generate dpr -- B', WHITE );
  SL.Add( BeginMark );
  SL.Add( '' );
 if GlobalNewIf then // D[u]fa теперь форма видна сразу на версиях выше 7
  SL.Add( '{$IF Defined(KOL_MCK)} {$I ' + ProjectDest + '_0.inc} {$ELSE}' )
 else
  SL.Add( '{$IFDEF KOL_MCK} {$I ' + ProjectDest + '_0.inc} {$ELSE}' );
  SL.Add( '' );

  // copy the rest of source dpr - between begin .. end.
  // and store all autocreated forms in AForms string list
  while I < Source.Count - 1 do
  begin
    Inc( I );
    S := Source[ I ];
    if Trim( S ) = '' then continue;

  if GlobalNewIf then begin // D[u]fa теперь форма видна сразу на версиях выше 7
     if UpperCase( S ) = UpperCase( '{$IF Defined(KOL_MCK)} {$I ' + ProjectDest + '_0.INC} {$ELSE}' ) then
       continue;
    
   if UpperCase( S ) = '{$IFEND}' then
    continue; 
  end else begin
     if UpperCase( S ) = UpperCase( '{$IFDEF KOL_MCK} {$I ' + ProjectDest + '_0.INC} {$ELSE}' ) then
       continue;
    
   if UpperCase( S ) = '{$ENDIF}' then
    continue;
  end;

    if LowerCase( S ) = 'end.' then
    begin
      SL.Add( '' );
   if GlobalNewIf then // D[u]fa теперь форма видна сразу на версиях выше 7
    SL.Add( '{$IFEND}' )
   else
    SL.Add( '{$ENDIF}' );
      SL.Add( '' );
    end;
   SL.Add( S );

    J := pos( 'application.createform(', LowerCase( S ) );
    if J > 0 then
    begin
      S := Copy( S, J + 23, Length( S ) - J - 22 );
      J := pos( ',', S );
      if J > 0 then
        S := Copy( S, J + 1, Length( S ) - J );
      J := pos( ')', S );
      if J > 0 then
        S := Copy( S, 1, J - 1 );
      AForms.Add( Trim( S ) );
    end;
  end;
  RptDetailed( 'generate dpr -- C', WHITE );
  ReorderForms( Self, AForms );

  Prepare_0inc;
  Prepare_134inc;
  Prepare_2inc;

  RptDetailed( 'generate dpr -- D', WHITE );
  if (ResStrings <> nil) and (ResStrings.Count > 0) then
  begin
    for I := 0 to SL.Count-1 do
    begin
      S := SL[ I ];
      if S = BeginResourceStringsMark then
      begin
        while S <> BeginMark do
        begin
          SL.Delete( I );
          if I >= SL.Count then
          begin
            Rpt( 'Error: begin mark not found', RED );
            break;
          end;
          S := SL[ I ];
        end;
      end;
      if S = BeginMark then
      begin
        SL.Insert( I, BeginResourceStringsMark );
        for J := ResStrings.Count-1 downto 0 do
          SL.Insert( I + 1, ResStrings[ J ] );
        //Updated := TRUE;
        break;
      end;
    end;
  end;

  RptDetailed( 'generate dpr -- E', WHITE );
  AfterGenerateDPR( SL, Updated );
  // store SL as <ProjectDest>.dpr
  SaveStrings( SL, Path + '.dpr', Updated );


  // at last, generate code for all (opened in designer) forms

  if FormsList <> nil then
  for I := 0 to FormsList.Count - 1 do
  begin
    F := FormsList[ I ];
    F.GenerateUnit( ExtractFilePath( Path ) + F.FormUnit );
  end;

  RptDetailed( 'generate dpr -- F', WHITE );
  if Updated then
  begin
    // mark modified here
    MarkModified( Path + '.dpr' );
    MarkModified( Path + '_1.inc' );
    MarkModified( Path + '_2.inc' );
    MarkModified( Path + '_3.inc' );
  end;

  RptDetailed( 'generate dpr -- G', WHITE );
  Result := True;

  except on E: Exception do
         begin
           SL := TStringList.Create;
           TRY
             SL := GetCallStack;
             ShowMessage( 'Exception 11873: ' + E.Message + #13#10 + SL.Text );
           FINALLY
             SL.Free;
           END;
         end;
  end;

  SL.Free;
  Source.Free;
  AForms.Free;

  LogOK;
  FINALLY
    RptDetailed( 'ENDOF Generating dpr', LIGHT + BLUE );
    Log( '<-TKOLProject.GenerateDPR' );
  END;
end;

function TKOLProject.GetBuild: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetBuild', 0
  @@e_signature:
  end;
  Result := fBuild;
end;

function TKOLProject.GetIsKOLProject: Boolean;
var SL: TStringList;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetIsKOLProject', 0
  @@e_signature:
  end;
  Log( '->GetIsKOLProject' );
  TRY

  Result := FALSE;
  if not FLocked then
  begin
    if fIsKOL = 0 then
    begin
      //ShowMessage( 'find if project Is KOL...' );
      if (SourcePath <> '') and DirectoryExists( SourcePath ) and
         (ProjectName <> '') and FileExists( SourcePath + ProjectName + '.dpr' ) then
      begin
        //ShowMessage( 'find if project Is KOL in ' + SourcePath + ProjectName + '.dpr' );
        SL := TStringList.Create;
        try
          LoadSource( SL, SourcePath + ProjectName + '.dpr' );
          for I := 0 to SL.Count - 1 do
            if RemoveSpaces( SL[ I ] ) = RemoveSpaces( Signature ) then
            begin
              fIsKOL := 1;
              break;
            end;
          //if fIsKOL = 0 then
          //  fIsKOL := -1;
        finally
          SL.Free;
        end;
        //ShowMessage( IntToStr( fIsKOL ) );
      end;
    end;
    Result := fIsKOL > 0;
  end;

  LogOK;
  FINALLY
    Log( '<-GetIsKOLProject' );
  END;
end;

function TKOLProject.getNewIf: Boolean;
begin
  Result := FNewIF;
end;

function TKOLProject.GetOutdcuPath: TFileName;
var S: String;
    L: TStringList;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetOutdcuPath', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetOutdcuPath' );
  TRY

  Result := '';
  if not FLocked then
  begin
    Result := SourcePath;
    S := SourcePath + ProjectName + '.cfg';
    if FileExists( S ) then
    begin
      L := TStringList.Create;
      L.LoadFromFile( S );
      for I := 0 to L.Count - 1 do
      begin
        if Length( L[ I ] ) < 2 then continue;
        if L[ I ][ 2 ] = 'N' then
        begin
          S := Trim( Copy( L[ I ], 3, Length( L[ I ] ) - 2 ) );
          if S[ 1 ] = '"' then
            S := Copy( S, 2, Length( S ) - 1 );
          if S[ Length( S ) ] = '"' then
            S := Copy( S, 1, Length( S ) - 1 );
          Result := S;
          break;
        end;
      end;
      L.Free;
    end;

    if Result = '' then
      Result := fOutdcuPath;
    if Result <> '' then
    if Result[ Length( Result ) ] <> '\' then
      Result := Result + '\';
    fOutdcuPath := Result;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetOutdcuPath' );
  END;
end;

function TKOLProject.GetProjectDest: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetProjectDest', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetProjectDest' );
  TRY

  Result := '';
  if not FLocked then
  begin
    //Result := ProjectName;
    if IsKOLProject then
      Result := ProjectName
    else
    begin
      Result := FProjectDest;
      if (ProjectName <> '') and (LowerCase(Result) = LowerCase(ProjectName)) then
        Result := '';
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetProjectDest' );
  END;
end;

function TKOLProject.GetProjectName: String;
var
  I: Integer;
{$IFDEF _D2005orHigher}
  IProjectGroup: IOTAProjectGroup;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetProjectName', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetProjectName' );
  TRY

    Result := fProjectName;
    if csDesigning in ComponentState then
    begin
      (*Result := Get_ProjectName(False);
      if Length(Result) > 0 then
      begin
        LogOK;
        Exit;
      end;*)
      // TODO: It's maybe an goodiear to use Get_ProjectName instead (with DontGetFromKOLProject option)?

      if ToolServices <> nil then
      begin
        Result := ExtractFileNameWOExt( ToolServices.GetProjectName );
        LogOK;
        exit;
      end;
      // TODO: use new OTAPI instead workaroud
      // TODO: fix AAA_D12.dpoj copy from AAA.dproj that link to AAA.dpr (only AAA.dll affect)
      {$IFDEF _D2005orHigher}
      IProjectGroup := Get_ProjectGroup;
      if Assigned(IProjectGroup) then
      begin
        Result := ExtractFileNameWOExt( IProjectGroup.ActiveProject.ProjectOptions.TargetName );
        // More Effective than dproj name by ActiveProject.GetFilename
        LogOK;
        Exit;
      end;
      {$ENDIF}

      Result := Application.MainForm.Caption;
      if Length(Result) <> 0 then
      begin
        I := pos( '-', Result );
        /// D[u]fa
        ///  вот тут загвоздка такая что вместо имени юнита
        ///  попадает чушь типа "Codegear Delphi for win32......"
        ///  для совместимости ставлю директиву начиная c 2005 делфи
        ///  хотя проверял только на 2007 и Турбе!
        ///  конечно лучше заменить на универсальный метод
        if (I > 0) then
        {$IFDEF _D2005orHigher} // VK: это наверное так только в новых версиях
          SetLength(Result, Pos(' ', Result) - 1);
        {$ELSE}
          Result := Trim( Copy( Result, I + 1, Length( Result ) - I ) );
        {$ENDIF}
        //rpt('Len'+Result, YELLOW);
        if pos( '[', Result ) > 0 then
          Result := Trim( Copy( Result, 1, pos( '[', Result ) - 1 ) );
        if pos( '(', Result ) > 0 then
          Result := Trim( Copy( Result, 1, pos( '(', Result ) - 1 ) );
      end;
    end;

    LogOK;
  FINALLY
    Log( '<-TKOLProject.GetProjectName' )
  END;
end;

function TKOLProject.GetShowReport: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetShowReport', 0
  @@e_signature:
  end;
  //Log( '->TKOLProject.GetShowReport' );
  TRY

  Result := fShowReport;
  if AutoBuilding then
    Result := False;

  LogOK;
  FINALLY
    //Log( '<-TKOLProject.GetShowReport' );
  END;
end;

{$IFDEF _D2}
function SHBrowseForFolder(var lpbi: TBrowseInfo): PItemIDList; stdcall;
  external 'shell32.dll' name 'SHBrowseForFolderA';
function SHGetPathFromIDList(pidl: PItemIDList; pszPath: PAnsiChar): BOOL; stdcall;
  external 'shell32.dll' name 'SHGetPathFromIDListA';
procedure CoTaskMemFree(pv: Pointer); stdcall;
  external 'ole32.dll' name 'CoTaskMemFree';
{$ENDIF}

// From D3, Get Interface for bpg n groupproj
// like Get_ProjectName?
{$IFDEF _D2005orHigher}
function Get_ProjectGroup: IOTAProjectGroup;
var
  IModuleServices: IOTAModuleServices;
  IModule: IOTAModule;
  I: Integer;
begin
  // from Mike Shkolnik's post
  IModuleServices := BorlandIDEServices as IOTAModuleServices;
  Result := nil;
  for i := 0 to IModuleServices.ModuleCount - 1 do
  begin
    IModule := IModuleServices.Modules[i];
    if IModule.QueryInterface(IOTAProjectGroup, Result) = S_OK then
      Break;
  end;
end;
{$ENDIF}

function TKOLProject.GetSourcePath: TFileName;
var
  BI: TBrowseInfo;
  IIL: PItemIdList;
  Buf: Array[ 0..MAX_PATH ] of Char; // TODO: dangerous, if D2 have treat Char as D2009?
  SL: TStringList;
{$IFDEF _D2005orHigher}
  IProjectGroup: IOTAProjectGroup;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.GetSourcePath', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.GetSourcePath' );
  TRY

  Result := '';
  TRY
    if FLocked then
    begin
      Rpt( 'TKOLProject LOCKED.', RED );
      LogOK; Exit;
    end;
    Result := fSourcePath;
    if Result <> '' then
      if Result[ Length( Result ) ] <> '\' then
        Result := Result + '\';
    if (Result <> '') and DirectoryExists( Result ) {and (FprojectDest <> '') and
       FileExists( Result + FprojectDest + '.dpr' )} then
    begin
      LogOK; Exit;
    end;
    if fGettingSourcePath then
    begin
      LogOK; Exit;
    end;
    fGettingSourcePath := True;
    TRY
      try
        if Result <> '' then
        if Result[ Length( Result ) ] <> '\' then
          Result := Result + '\';
        if Result <> '' then
        if not DirectoryExists( Result ) or
           not FileExists( Result + fprojectDest + '.dpr' ) or
           not IsKOLProject then
           Result := '';
        if Result = '' then
        if csDesigning in ComponentState then
        //if not (csLoading in ComponentState) then
        begin
          try
            if ToolServices <> nil then
            begin
              Result := ToolServices.GetProjectName; // AAA.dpr
              Result := ExtractFilePath( Result );
            end
            {$IFDEF _D2005orHigher}
            else
            begin
              IProjectGroup := Get_ProjectGroup();
              if Assigned(IProjectGroup) then
              begin
                // TODO: check if current project is not active(startup) Project
                //Result := IProjectGroup.ActiveProject.GetFileName; // AAA_D12.dproj
                Result := IProjectGroup.ActiveProject.ProjectOptions.TargetName; // ProjPath(output folder discard)AAA.exe (AAA_D12.dll havn't fix by CodeGear)
                //Result := IProjectGroup.GetFileName;} // Tests.bdsgroup
                Result := ExtractFilePath( Result );
              end;
            end;
            {$ENDIF}
          except on E: Exception do
             begin
               SL := TStringList.Create;
               TRY
                 SL := GetCallStack;
                 ShowMessage( 'Exception 12108: ' + E.Message + #13#10 + SL.Text );
               FINALLY
                 SL.Free;
               END;
             end;
          end;

          if Result <> '' then
          begin
            if Result[ Length( Result ) ] <> '\' then
              Result := Result + '\';
            fGettingSourcePath := False;
            LogOK;
            Exit;
          end;

          FillChar( BI, Sizeof( BI ), 0 ); // byte behavor havn't change in D2009
          BI.lpszTitle := 'Define mirror project source (directory ' +
                          'where your source project is located before '+
                          'converting it to KOL).';
          BI.ulFlags := BIF_RETURNONLYFSDIRS;
          BI.pszDisplayName := @Buf[ 0 ];
          IIL := SHBrowseForFolder( BI );
          if IIL <> nil then
          begin
            SHGetPathFromIDList( IIL, @Buf[ 0 ] );
            CoTaskMemFree( IIL );
            Result := String(Buf);
            fSourcePath := Result;
          end;
        end;
        if Result <> '' then
        if Result[ Length( Result ) ] <> '\' then
          Result := Result + '\';
      except on E: Exception do
             begin
               SL := TStringList.Create;
               TRY
                 SL := GetCallStack;
                 ShowMessage( 'Exception 12146: ' + E.Message + #13#10 + SL.Text );
               FINALLY
                 SL.Free;
               END;
             end;
      end;
    FINALLY
      fGettingSourcePath := False;
    END;
  EXCEPT
    on E: Exception do
    begin
      ShowMessage( 'Can not obtain project source path, exception: ' + E.Message );
      Result := '';
    end;
  END;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.GetSourcePath' );
  END;
end;

procedure TKOLProject.Loaded;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Loaded', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.Loaded' );
  TRY
    inherited;
    //fTimer.Enabled := TRUE;
    BroadCastPaintTypeToAllForms;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.Loaded' );
  END;
end;

procedure TKOLProject.MakeResourceString(const ResourceConstName,
  Value: String);
begin
  Log( '->TKOLProject.MakeResourceString' );
  TRY

  if ResStrings = nil then
    ResStrings := TStringList.Create;
  ResStrings.Add( 'resourcestring ' + ResourceConstName + ' = ' +
    String2Pascal( Value, '+' ) + ';' );

  LogOK;
  FINALLY
    Log( '<-TKOLProject.MakeResourceString' );
  END;
end;

function TKOLProject.OwnerKOLForm: TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.ParentKOLForm', 0
  @@e_signature:
  end;
  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;
end;

function TKOLProject.P_StringConstant(const Propname,
  Value: String): String;
begin
  Log( '->TKOLProject.P_StringConstant' );
  TRY

  if Localizy and (Value <> '') then
  begin
    //Result := Name + '_' + Propname;
    {P}Result := ' ResourceString(' + Name + '_' + PropName + ')';
      //todo: implement ResourceString in P-machine!
    MakeResourceString( Result, Value );
  end
    else
  begin
    //Result := String2Pascal( Value );
    if Value <> '' then
      {P}Result := ' LoadAnsiStr ' + P_String2Pascal( Value )
    else
      {P}Result := ' LoadAnsiStr #0';
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.P_StringConstant' );
  END;
end;

var LastColor: Integer = 0;

procedure TKOLProject.Report(const Txt: String; Color: Integer );
var w: DWORD;
    {$IFDEF REPORT_TIME}
    s: String;
    {$ENDIF}
    tmp: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.Report', 0
  @@e_signature:
  end;
  //if FLocked then Exit;
  if FConsoleOut and (FOut <> 0) then
  begin
    //Writeln( FOut, Txt );
    //Write( FOut, Txt + #10 );
    {$IFDEF REPORT_TIME}
    TRY
      SetConsoleTextAttribute( FOut, CYAN );
      s := FormatDateTime( 'hh:nn:ss:zzz ', Now );
      WriteConsole( FOut, PAnsiChar( s ), Length( s ), w, nil );
    EXCEPT
    END;
    {$ELSE}
    if LastColor <> Color then
    {$ENDIF}
    begin
      SetConsoleTextAttribute( FOut, Color );
      LastColor := Color;
    end;
    tmp := Txt + #10;
    WriteConsole( FOut, PChar(tmp), Length( Txt ) + 1, w, nil );
  end;
  if ShowReport and Building then
    ShowMessage( Txt );
end;

procedure TKOLProject.SetAutoBuild(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetAutoBuild', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetAutoBuild' );
  TRY

  if not FLocked then
  begin
    if fAutoBuild <> Value then
    begin
      fAutoBuild := Value;
      if Value then
      begin
        // Setup timer
        if fTimer = nil then
          fTimer := TTimer.Create( Self );
        fTimer.Interval := FAutoBuildDelay;
        fTimer.OnTimer := TimerTick;
      end
         else
      begin
        // Stop timer
        if fTimer <> nil then
          fTimer.Enabled := False;
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetAutoBuild' );
  END;
end;

procedure TKOLProject.SetAutoBuildDelay(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetAutoBuildDelay', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetAutoBuildDelay' );
  TRY

  if not FLocked then
  begin
    FAutoBuildDelay := Value;
    if fAutoBuildDelay < 0 then
      fAutoBuildDelay := 0;
    if AutoBuildDelay > 3000 then
      fAutoBuildDelay := 3000;
    if fTimer <> nil then
    if fAutoBuildDelay > 50 then
      fTimer.Interval := Value
    else
      fTimer.Interval := 50;
  end;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetAutoBuildDelay' );
  END;
end;

procedure TKOLProject.SetBuild(const Value: Boolean);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetBuild', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetBuild' );
  TRY

  if not (csLoading in ComponentState) and not FLocked then
  begin
    if not IsKOLProject then
    begin
      S := 'Option <Build> is not available at design time ' +
           'unless project is already converted to KOL-MCK.';
      if projectDest = '' then
        S := S + #13#10'To convert a project to KOL-MCK, change property ' +
             'projectDest of TKOLProject component!';
      ShowMessage( S );
      LogOK;
      Exit;
    end;
    if Value = False then
    begin
      LogOK;
      Exit;
    end;
    fBuild := TRUE;
    try
      if not ConvertVCL2KOL( TRUE, FALSE ) then
        if (OwnerKOLForm <> nil) then
          OwnerKOLForm.Change( OwnerKOLForm );
    except
      on E: Exception do
      begin
        ShowMessage( 'ConvertVCL2KOL failed, exception: ' + E.Message );
      end;
    end;
    fBuild := False;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetBuild' );
  END;
end;

procedure TKOLProject.SetCallPCompiler(const Value: String);
begin
  FCallPCompiler := Value;
end;

function ConsoleHandler( dwCtrlType: DWORD ): Bool; stdcall;
begin
  Result := FALSE;
  if dwCtrlType = CTRL_CLOSE_EVENT then
  begin
    Result := TRUE;
    Rpt( 'Do not close console window, instead change property consoleOut of ' +
         'TKOLProject component to FALSE!', YELLOW );
  end;
end;

procedure TKOLProject.SetConsoleOut(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetConsoleOut', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetConsoloeOut' );
  TRY

  if not FLocked and (FConsoleOut <> Value) then
  begin
    FConsoleOut := Value;
    if Value then
    begin
      AllocConsole;
      FOut := GetStdHandle( STD_OUTPUT_HANDLE );
      if FOut <> 0 then
      begin
        FIn := GetStdHandle( STD_INPUT_HANDLE );
        SetConsoleTitle( 'KOL MCK console. Do not close! (use prop. ConsoleOut)' );
        SetConsoleMode( FIn, ENABLE_PROCESSED_OUTPUT or ENABLE_WRAP_AT_EOL_OUTPUT	);
        SetConsoleCtrlHandler( @ ConsoleHandler, TRUE );
      end
         else FConsoleOut := False;
    end
       else
      FreeConsole;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetConsoleOut' );
  END;
end;

procedure TKOLProject.SetGeneratePCode(const Value: Boolean);
begin
  FGeneratePCode := Value;
  Change;
  ChangeAllForms;
end;

procedure TKOLProject.SetHelpFile(const Value: String);
begin
  if FHelpFile = Value then Exit;
  Log( '->TKOLProject.SetHelpFile' );
  TRY

  FHelpFile := Value;
  Change;
  ChangeAllForms;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetHelpFile' );
  END;
end;

procedure TKOLProject.SetIsKOLProject(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetIsKOLProject', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetIsKOLProject' );
  TRY

  if not FLocked and not (csLoading in ComponentState) then
  begin
    if Value then
    begin
      GetIsKOLProject;
      if fIsKOL < 1 then
      begin
        ShowMessage( 'Your project is not yet converted to KOL-MCK. '+
                     'To convert it, change property projectDest of TKOLProject first, ' +
                     'and then drop TKOLForm (or change any TKOLForm property, if ' +
                     'it is already dropped). Then, open destination project and work ' +
                     'with it.' );
        LogOK;
        Exit;
      end;
    end
      else
    begin
      fIsKOL := 0;
      GetIsKOLProject;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetIsKOLProject' );
  END;
end;

procedure TKOLProject.SetLocalizy(const Value: Boolean);
begin
  if FLocalizy = Value then Exit;
  Log( '->TKOLProject.SetLocalizy' );
  TRY
  FLocalizy := Value;
  Change;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetLocalizy' );
  END;
end;

procedure TKOLProject.SetLocked(const Value: Boolean);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetLocked', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetLocked' );
  TRY

  if FLocked = Value then
  begin
    Rpt( 'TKOLProject made LOCKED.', RED );
    LogOK; Exit;
  end;
  if not Value then
  begin
    for I := 0 to Owner.ComponentCount-1 do
      if IsVCLControl( Owner.Components[ I ] ) then
      begin
        ShowMessage( 'Form ' + Owner.Name + ' contains VCL controls. TKOLProject ' +
                     'component can not be unlocked.' );
        LogOK;
        Exit;
      end;
    I := MessageBox( 0, 'TKOLProject component was locked because one of project''s form had ' +
         'VCL controls placed on it. Are You sure You want to unlock TKOLProject?'#13 +
         '(Note: if the the project is VCL-based, unlocking TKOLProject ' +
         'component can damage it).', 'CAUTION!', MB_YESNO or MB_SETFOREGROUND );
    if I = ID_NO then
    begin
      LogOK;
      Exit;
    end;
  end;
  FLocked := Value;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetLocked' );
  END;
end;

procedure TKOLProject.SetName(const NewName: TComponentName);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetName', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetName' );
  TRY

  inherited;
  if not (csLoading in ComponentState) then
  if Owner <> nil then
  if Owner is TForm then
  if IsKOLProject then
  begin
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      C := (Owner as TForm).Components[ I ];
      if C is TKOLForm then
      begin
        Build := TRUE;
        break;
      end;
    end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetName' );
  END;
end;

procedure TKOLProject.setNewIf(const Value: Boolean);
begin
  if FNewIF = Value then Exit;
  {$IFNDEF _D6orHigher}
  if Value and not(csLoading in ComponentState) then
  begin
    CASE MessageBox( 0, 'Are you sure? ' +
         'Directives {$IF...} and {$IFEND} are not supported in this version of Delphi.',
         nil, MB_YESNO or MB_DEFBUTTON2 ) OF
    ID_YES: ;
    ID_NO : Exit;
    END;
  end;
  {$ENDIF}
  {$IFDEF _D2005orHigher}
  if Value and not(csLoading in ComponentState) then
  begin
    CASE MessageBox( 0, 'Are you sure? ' +
         'Directives {$IF...} and {$IFEND} must be used in this version of Delphi.',
         nil, MB_YESNO or MB_DEFBUTTON2 ) OF
    ID_YES: ;
    ID_NO : Exit;
    END;
  end;
  {$ENDIF}
  FNewIF := Value;
  GlobalNewIF := Value;
//  FNewIF := true;
//  GlobalNewIF := true;
  Change;
  ChangeAllForms;
end;

procedure TKOLProject.SetOutdcuPath(const Value: TFileName);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetOutdcuPath', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetOutdcuPath' );
  TRY
    fOutdcuPath := ''; //TODO: understand what is it...
    //if FLocked then Exit;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetOutdcuPath' );
  END;
end;

procedure TKOLProject.SetPaintType(const Value: TPaintType);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetPaintType', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetPaintType' );
  TRY

  if FPaintType = Value then
  begin
    LogOK; Exit;
  end;
  FPaintType := Value;
  BroadCastPaintTypeToAllForms;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetPaintType' );
  END;
end;

procedure TKOLProject.SetProjectDest(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetProjectDest', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.SetProjectDest' );
  TRY

  if not FLocked then
  begin
    if not IsValidIdent( Value ) then
      ShowMessage( 'Destination project name must be valid identifier.' )
    else
    if (ProjectName = '') or (LowerCase( Value ) <> LowerCase( ProjectName )) then
      FProjectDest := Value;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetProjectDest' );
  END;
end;

procedure TKOLProject.SetReportDetailed(const Value: Boolean);
begin
  FReportDetailed := Value;
end;

procedure TKOLProject.SetShowHint(const Value: Boolean);
begin
  if FShowHint = Value then Exit;
  Log( '->TKOLProject.SetShowHint' );
  TRY
  FShowHint := Value;
  Change;
  ChangeAllForms;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetShowHint' );
  END;
end;

procedure TKOLProject.SetSupportAnsiMnemonics(const Value: LCID);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.SetSupportAnsiMnemonics', 0
  @@e_signature:
  end;
  if FSupportAnsiMnemonics = Value then Exit;
  Log( '->TKOLProject.SetSupportAnsiMnemonics' );
  TRY
    FSupportAnsiMnemonics := Value;
    Change;
    ChangeAllForms;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.SetSupportAnsiMnemonics' );
  END;
end;

function TKOLProject.StringConstant(const Propname, Value: String): String;
begin
  Log( '->TKOLProject.StringConstant' );
  TRY

  if Localizy and (Value <> '') then
  begin
    Result := Name + '_' + Propname;
    MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value, '+' );
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.StringConstant' );
  END;
end;

procedure TKOLProject.TimerTick( Sender: TObject );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.TimerTick', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.TimerTick' );
  TRY

  if not FBuilding and not AutoBuilding then
  begin
  fTimer.Enabled := False;
  if not FLocked then
  begin
    if AutoBuild then
    begin
      AutoBuilding := True;
      ConvertVCL2KOL( FALSE, FALSE );
      AutoBuilding := False;
    end;
  end;
  end;

  LogOK;
  FINALLY
    Log( '<-TKOLProject.TimerTick' );
  END;
end;

{$IFDEF _D2007orHigher}
function TKOLProject.MakeupConfig: Boolean;
var
  DestConf: String;
  DummyList: TStringList;
  Updated: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.MakeupConfig', 0
  @@e_signature:
  end;

  Result := False;
  if not FLocked then
  begin
    DummyList := TStringList.Create;

    DestConf := SourcePath + ProjectDest + '.cfg'; // TODO: change ProjectDest to (Unicode)String
    if not(FileExists(DestConf)) then
    begin
      DummyList.Add('-AClasses=;mirror=');
      DummyList.Add('-DKOL_MCK');
      SaveStrings(DummyList, DestConf, Updated);
      Result := Updated;
    end;

    DestConf := SourcePath + ProjectDest + '.dof';
    DummyList.Clear;
    if not(FileExists(DestConf)) then
    begin
      DummyList.Add('[Compiler]');
      DummyList.Add('UnitAliases=Classes=;mirror=');
      DummyList.Add('[Directories]');
      DummyList.Add('Conditionals=KOL_MCK');
      SaveStrings(DummyList, DestConf, Updated);
      Result := Result and Updated;
    end;

    DummyList.Free;
  end;
end;
{$ENDIF}

function TKOLProject.UpdateConfig: Boolean;
var S, R: String;
    L: TStringList;
    I: Integer;
    AFound, DFound {, DWere}: Boolean;
    Updated: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProject.UpdateConfig', 0
  @@e_signature:
  end;
  Log( '->TKOLProject.UpdateConfig' );
  TRY

  Result := False;
  if not FLocked then
  begin
{$IFDEF _D2007orHigher} // TODO: 2005?
    MakeupConfig(); // TODO: move to ConvertVCL2KOL, or genreate both source/dest cfg
{$ENDIF}
    S := SourcePath + ProjectName + '.cfg';
    R := SourcePath + ProjectDest + '.cfg';
    L := TStringList.Create;
    //DWere := FALSE;
    if FileExists( S ) then
    begin
      LoadSource( L, S );
      AFound := False;
      DFound := False;
      for I := 0 to L.Count - 1 do
      begin
        if Length( L[ I ] ) < 2 then continue;
        if L[ I ][ 2 ] = 'A' then
        begin
          L[ I ] := '-AClasses=;Controls=;mirror=';
          AFound := True;
        end;
        if L[ I ][ 2 ] = 'D' then
        begin
          {if pos( 'KOL_MCK', UpperCase( L[ I ] ) ) then
            DWere := TRUE;}
          if pos( 'KOL_MCK', UpperCase( L[ I ] ) ) <= 0 then
            L[ I ] := //'-DKOL_MCK';
                      IncludeTrailingChar( L[ I ], ';' ) + 'KOL_MCK';
          DFound := True;
        end;
      end;
      if not AFound then
        L.Add( '-AClasses=;Controls=;StdCtrls=;ExtCtrls=;mirror=' );
      if not DFound then
        L.Add( '-DKOL_MCK' );
      SaveStrings( L, R, Updated );
    end;
    L.Clear;
    S := SourcePath + ProjectName + '.dof';
    R := SourcePath + ProjectDest + '.dof';
    if FileExists( S ) then
    begin
      LoadSource( L, S );
      for I := 0 to L.Count - 1 do
      begin
        if Copy( L[ I ], 1, Length( 'UnitAliases=' ) ) = 'UnitAliases=' then
          L[ I ] := 'UnitAliases=Classes=;mirror=';
        if Copy( L[ I ], 1, Length( 'Conditionals=' ) ) = 'Conditionals=' then
        if pos( 'KOL_MCK', UpperCase( L[ I ] ) ) <= 0 then
          L[ I ] := 'Conditionals=KOL_MCK';
      end;
      SaveStrings( L, R, Updated );
    end;
    L.Free;
  end;
  LogOK;
  FINALLY
    Log( '<-TKOLProject.UpdateConfig' );
  END;
end;

procedure TKOLProject.SetDefaultFont(const Value: TKOLFont);
begin
  if FDefaultFont.Equal2( Value ) then Exit;
  FDefaultFont.Assign( Value );
  Change;
  ChangeAllForms;
end;

procedure TKOLProject.SetFormCompactDisabled(const Value: Boolean);
begin
  if  FFormCompactDisabled = Value then Exit;
  FFormCompactDisabled := Value;
  Change;
  ChangeAllForms;
end;

{ TFormBounds }

procedure TFormBounds.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.Change', 0
  @@e_signature:
  end;
  if (fL = Left) and (fT = Top) and (fH = Height) and (fW = Width) then
    Exit;
  fL := Left;
  fT := Top;
  fH := Height;
  fW := Width;
  (Owner as TKOLForm).Change( nil );
  if not (csLoading in (Owner as TKOLForm).ComponentState) then
    (Owner as TKOLForm).AlignChildren( nil, FALSE );
end;

procedure TFormBounds.CheckFormSize(Sender: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.CheckFormSize', 0
  @@e_signature:
  end;
  if Owner = nil then Exit;
  //if Owner.Name = '' then Exit;
  if Owner.Owner = nil then Exit;
  //if Owner.Owner.Name = '' then Exit;
  if csLoading in (Owner as TComponent).ComponentState then Exit;
  if csLoading in (Owner.Owner as TComponent).ComponentState then Exit;
  if fL = (Owner.Owner as TForm).Left then
  if fT = (Owner.Owner as TForm).Top then
  if fW = (Owner.Owner as TForm).Width then
  if fH = (Owner.Owner as TForm).Height then Exit;
  {Rpt( 'L=' + IntToStr( fL ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Left ) + #13#10 +
       'T=' + IntToStr( fT ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Top ) + #13#10 +
       'W=' + IntToStr( fW ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Width ) + #13#10 +
       'H=' + IntToStr( fH ) + ' <> ' + IntToStr( (Owner.Owner as TForm).Height ) + #13#10 );}
  Change;
end;

constructor TFormBounds.Create;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.Create', 0
  @@e_signature:
  end;
  inherited;
  fTimer := TTimer.Create( Owner );
  fTimer.Interval := 300;
  fTimer.OnTimer := CheckFormSize;
  fTimer.Enabled := FALSE;
end;

destructor TFormBounds.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.Destroy', 0
  @@e_signature:
  end;
  if Assigned( fTimer ) then
  begin
    fTimer.Enabled := False;
    fTimer.Free;
    fTimer := nil;
  end;
  inherited;
end;

procedure TFormBounds.EnableTimer(Value: Boolean);
begin
  fTimer.Enabled := Value;
end;

function TFormBounds.GetHeight: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetHeight', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Height;
end;

function TFormBounds.GetLeft: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetLeft', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Left;
end;

function TFormBounds.GetTop: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetTop', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Top;
end;

function TFormBounds.GetWidth: Integer;
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.GetWidth', 0
  @@e_signature:
  end;
  F := Owner.Owner as TControl;
  Result := F.Width;
end;

procedure TFormBounds.SetHeight(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetHeight', 0
  @@e_signature:
  end;
  fH := Value;
  F := Owner.Owner as TControl;
  if F.Height = Value then Exit;
  F.Height := Value;
  Change;
end;

procedure TFormBounds.SetLeft(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetLeft', 0
  @@e_signature:
  end;
  fL := Value;
  F := Owner.Owner as TControl;
  if F.Left = Value then Exit;
  F.Left := Value;
  Change;
end;

procedure TFormBounds.SetOwner(const Value: TComponent);
begin
  fOwner := Value;
  if fOwner <> nil then
  if not(csLoading in fOwner.ComponentState) then
    fTimer.Enabled := True;
end;

procedure TFormBounds.SetTop(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetTop', 0
  @@e_signature:
  end;
  fT := Value;
  F := Owner.Owner as TControl;
  if F.Top = Value then Exit;
  F.Top := Value;
  Change;
end;

procedure TFormBounds.SetWidth(const Value: Integer);
var F: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TFormBounds.SetWidth', 0
  @@e_signature:
  end;
  fW := Value;
  F := Owner.Owner as TControl;
  if F.Width = Value then Exit;
  F.Width := Value;
  Change;
end;

{ TKOLObj }

function TKOLObj.AdditionalUnits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.AdditionalUnits', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLObj.AddToNotifyList(Sender: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.AddToNotifyList', 0
  @@e_signature:
  end;
  if Assigned( fNotifyList ) then
  if fNotifyList.IndexOf( Sender ) < 0 then
    fNotifyList.Add( Sender );
end;

procedure TKOLObj.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.AssignEvents', 0
  @@e_signature:
  end;
  DoAssignEvents( SL, AName,
  [ 'OnDestroy' ],
  [ @ OnDestroy ] );
end;

function TKOLObj.BestEventName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.BestEventName', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLObj.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Change', 0
  @@e_signature:
  end;
  FreeAndNil( CacheLines_SetupFirst );
  if (csLoading in ComponentState) then Exit;
  if ParentKOLForm = nil then Exit;
  ParentKOLForm.Change( Self );
end;

function TKOLObj.CompareFirst(c, n: string): boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.CompareFirst', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

constructor TKOLObj.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Create', 0
  @@e_signature:
  end;
  fNotifyList := TList.Create;
  inherited;
  NeedFree := True;
end;

destructor TKOLObj.Destroy;
var F: TKOLForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Destroy', 0
  @@e_signature:
  end;
  FreeAndNil( CacheLines_SetupFirst );
  if Assigned( Owner ) and not (csDestroying in Owner.ComponentState) then
  begin
    if Assigned( fNotifyList ) then
      for I := fNotifyList.Count-1 downto 0 do
      begin
        C := fNotifyList[ I ];
        if C is TKOLObj then
          (C as TKOLObj).NotifyLinkedComponent( Self, noRemoved )
        else
        if C is TKOLCustomControl then
          (C as TKOLCustomControl).NotifyLinkedComponent( Self, noRemoved );
      end;
    TRY
      if OwnerKOLForm( Owner ) <> nil then
        OwnerKOLForm( Owner ).Change( nil );
    FINALLY
      Rpt( 'Exception (destroying TKOLObj)', RED );
    END;
  end;
  fNotifyList.Free;
  fNotifyList := nil;
  F := ParentKOLForm;
  inherited;
  if (F <> nil) and not F.FIsDestroying and (Owner <> nil) and
     not(csDestroying in Owner.ComponentState) then
    F.Change( F );
end;

procedure TKOLObj.DoAssignEvents(SL: TStringList; const AName: String;
  const EventNames: array of PAnsiChar; const EventHandlers: array of Pointer);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.DoAssignEvents', 0
  @@e_signature:
  end;
  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    begin
      SL.Add( '      ' + AName + '.' + String(EventNames[ I ]) + ' := Result.' +
              ParentForm.MethodName( EventHandlers[ I ] ) + ';' ); // TODO: KOL_ANSI
    end;
  end;
end;

procedure TKOLObj.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.FirstCreate', 0
  @@e_signature:
  end;
end;

procedure TKOLObj.DoGenerateConstants( SL: TStringList );
begin
  //
end;

function TKOLObj.Get_Tag: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.Get_Tag', 0
  @@e_signature:
  end;
  Result := F_Tag;
end;

function TKOLObj.NotAutoFree: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.NotAutoFree', 0
  @@e_signature:
  end;
  Result := not NeedFree;
end;

procedure TKOLObj.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  if Operation = noRemoved then
  if Assigned( fNotifyList ) then
    fNotifyList.Remove( Sender );
end;

function TKOLObj.ParentForm: TForm;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.ParentForm', 0
  @@e_signature:
  end;
  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
    Result := C as TForm;
end;

function TKOLObj.ParentKOLForm: TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.ParentKOLForm', 0
  @@e_signature:
  end;
  C := Owner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;
end;

procedure TKOLObj.SetName(const NewName: TComponentName);
var OldName, NameNew: String;
    I, N: Integer;
    Success: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetName', 0
  @@e_signature:
  end;
  OldName := Name;
  inherited SetName( NewName );
  if (Copy( NewName, 1, 3 ) = 'KOL') and (OldName = '') then
  begin
    NameNew := Copy( NewName, 4, Length( NewName ) - 3 );
    Success := True;
    if Owner <> nil then
    while Owner.FindComponent( NameNew ) <> nil do
    begin
      Success := False;
      for I := 1 to Length( NameNew ) do
      begin
          if  (NameNew[ I ] >= '0') and (NameNew[ I ] <= '9') then
          begin
              Success := True;
              N := StrToInt( Copy( NameNew, I, Length( NameNew ) - I + 1 ) );
              Inc( N );
              NameNew := Copy( NameNew, 1, I - 1 ) + IntToStr( N );
              break;
          end;
      end;
      if not Success then break;
    end;
    if Success then
      Name := NameNew;
    if not (csLoading in ComponentState) then
      FirstCreate;
  end;
  Change;
end;

procedure TKOLObj.SetOnDestroy(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetOnDestroy', 0
  @@e_signature:
  end;
  if @ FOnDestroy = @ Value then Exit;
  FOnDestroy := Value;
  Change;
end;

procedure TKOLObj.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetupFirst', 0
  @@e_signature:
  end;
  SL.Add( Prefix + AName + ' := New' + TypeName + ';' );
  SetupName( SL, AName, AParent, Prefix );
  GenerateTag( SL, AName, Prefix );
end;

procedure TKOLObj.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.SetupLast', 0
  @@e_signature:
  end;
  // по умолчанию ничего не надо... Разве только в наследниках.
end;

function TKOLObj.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.TypeName', 0
  @@e_signature:
  end;
  Result := ClassName;
  if UpperCase( Copy( Result, 1, 4 ) ) = 'TKOL' then
    Result := Copy( Result, 5, Length( Result ) - 4 );
end;

procedure TKOLObj.Set_Tag(const Value: Integer);
begin
  if F_Tag = Value then Exit;
  F_Tag := Value;
  Change;
end;

procedure TKOLObj.GenerateTag(SL: TStringList; const AName,
  APrefix: String);
var S: String;
begin
  if F_Tag <> 0 then
  begin
    S := IntToStr( F_Tag );
    if Integer( F_Tag ) < 0 then
      S := 'DWORD( ' + S + ' )';
    SL.Add( APrefix + AName + '.Tag := ' + S + ';' )
  end;
end;

function TKOLObj.StringConstant(const Propname, Value: String): String;
begin
  if (Value <> '') AND
     ((Localizy = loForm) and (ParentKOLForm <> nil) and
     (ParentKOLForm.Localizy) or (Localizy = loYes)) then
  begin
    Result := ParentKOLForm.Name + '_' + Name + '_' + Propname;
    ParentKOLForm.MakeResourceString( Result, Value );
  end
    else
  begin
    Result := String2Pascal( Value, '+' );
  end;
end;

procedure TKOLObj.SetLocalizy(const Value: TLocalizyOptions);
begin
  if FLocalizy = Value then Exit;
  FLocalizy := Value;
  Change;
end;

function TKOLObj.OwnerKOLForm( AOwner: TComponent ): TKOLForm;
var C, D: TComponent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.ParentKOLForm', 0
  @@e_signature:
  end;
  C := AOwner;
  while (C <> nil) and not(C is TForm) do
    C := C.Owner;
  Result := nil;
  if C <> nil then
  if C is TForm then
  begin
    for I := 0 to (C as TForm).ComponentCount - 1 do
    begin
      D := (C as TForm).Components[ I ];
      if D is TKOLForm then
      begin
        Result := D as TKOLForm;
        break;
      end;
    end;
  end;
end;

procedure TKOLObj.DoNotifyLinkedComponents(Operation: TNotifyOperation);
var I: Integer;
    C: TComponent;
begin
  if Assigned( fNotifyList ) then
    for I := fNotifyList.Count-1 downto 0 do
    begin
      C := fNotifyList[ I ];
      if C is TKOLObj then
        (C as TKOLObj).NotifyLinkedComponent( Self, Operation )
      else
      if C is TKOLCustomControl then
        (C as TKOLCustomControl).NotifyLinkedComponent( Self, Operation );
    end;
end;

function TKOLObj.Pcode_Generate: Boolean;
begin
  Result := FALSE;
end;

procedure TKOLObj.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.P_SetupFirst', 0
  @@e_signature:
  end;
  //SL.Add( Prefix + AName + ' := New' + TypeName + ';' );
  {P}SL.Add( ' New' + TypeName + ' RESULT' );
  P_SetupName( SL );
  P_GenerateTag( SL, AName, Prefix );
  {P}SL.Add( ' DUP C2 AddWord_Store ##T' + ParentKOLForm.FormName + '.' + AName );
end;

function TKOLObj.P_AssignEvents(SL: TStringList; const AName: String; CheckOnly: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.P_AssignEvents', 0
  @@e_signature:
  end;
  Result := P_DoAssignEvents( SL, AName,
  [ 'OnDestroy' ],
  [ @ OnDestroy ],
  [ FALSE ], CheckOnly );
end;

function TKOLObj.P_DoAssignEvents(SL: TStringList; const AName: String;
  const EventNames: array of PAnsiChar; const EventHandlers: array of Pointer;
  const EventAssignProc: array of Boolean; CheckOnly: Boolean): Boolean;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.P_DoAssignEvents', 0
  @@e_signature:
  end;
  Result := TRUE;
  for I := 0 to High( EventHandlers ) do
  begin
    if EventHandlers[ I ] <> nil then
    begin
      if CheckOnly then Exit;
      //SL.Add( '      ' + AName + '.' + EventNames[ I ] + ' := Result.' +
      //        ParentForm.MethodName( EventHandlers[ I ] ) + ';' );
      P_DoProvideFakeType( SL );
      if EventAssignProc[ I ] then
      begin
        {P}SL.Add( ' LoadSELF Load4 ####T' + (Owner as TForm).Name + '.' +
          (Owner as TForm).MethodName( EventHandlers[ I ] ) );
        {P}SL.Add( ' C2 T' + TypeName + '_.Set' + String(EventNames[ I ]) + '<1>'
                   ); // TODO: KOL_ANSI
      end
        else
      begin
        {P}SL.Add( ' Load4 ####T' + (Owner as TForm).Name + '.' +
          (Owner as TForm).MethodName( EventHandlers[ I ] ) );
        {P}SL.Add( ' C1 AddWord_Store ##T' + TypeName + '_.f' + String(EventNames[ I ]) ); // TODO: KOL_ANSI
        {P}SL.Add( ' LoadSELF C1 AddWord_Store ##(4+T' + TypeName + '_.f' +
          String(EventNames[ I ]) + ')' ); // TODO: KOL_ANSI
      end;
    end;
  end;
  if CheckOnly then
    Result := FALSE;
end;

procedure TKOLObj.P_GenerateTag(SL: TStringList; const AName,
  APrefix: String);
begin
  if F_Tag <> 0 then
  begin
    {S := IntToStr( F_Tag );
    if Integer( F_Tag ) < 0 then
      S := 'DWORD( ' + S + ' )';
    SL.Add( APrefix + AName + '.Tag := ' + S + ';' )}
    {P}SL.Add( ' L(' + IntToStr( F_Tag ) + ')' );
    {P}SL.Add( ' C1 AddByte_Store #TObj_.fTag' );
  end;
end;

procedure TKOLObj.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObj.P_SetupLast', 0
  @@e_signature:
  end;
  // по умолчанию ничего не надо... Разве только в наследниках.
end;

procedure TKOLObj.ProvideObjInStack(SL: TStrings);
begin
  if not ObjInStack then
  begin
    {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name );
    ObjInStack := TRUE;
  end;
end;

function TKOLObj.P_StringConstant(const Propname, Value: String): String;
begin
  if (Value <> '') AND
     ((Localizy = loForm) and (ParentKOLForm <> nil) and
     (ParentKOLForm.Localizy) or (Localizy = loYes)) then
  begin
    //Result := ParentKOLForm.Name + '_' + Name + '_' + Propname;
    {P}Result := ' ResourceString(' + Name + '_' + PropName + ')';
    ParentKOLForm.MakeResourceString( Result, Value );
  end
    else
  begin
    //Result := String2Pascal( Value );
    {P}Result := ' LoadAnsiStr ' + P_String2Pascal( Value );
  end;
end;

procedure TKOLObj.P_ProvideFakeType(SL: TStrings;
  const Declaration: String);
var i: Integer;
begin
  for i := 0 to SL.Count-1 do
      if AnsiCompareText( SL[ i ], Declaration ) = 0 then Exit;
  SL.Insert( 1, Declaration );
end;

procedure TKOLObj.P_SetupFirstFinalizy(SL: TStringList);
begin
  //
end;

procedure TKOLObj.P_DoProvideFakeType( SL: TStringList );
begin
  P_ProvideFakeType( SL, 'type T' + TypeName + '_ = object(T' + TypeName + ') end;' );
end;

procedure TKOLObj.SetupName(SL: TStringList; const AName, AParent,
  Prefix: String );
var KF: TKOLForm;
begin
  if FNameSetuped then Exit;
  KF := ParentKOLForm;
  if  KF = nil then Exit;
  if  (Name <> '') and KF.GenerateCtlNames then
  begin
      RptDetailed( 'KF=' + KF.Name + ' ----- GenerateCtlNames = TRUE', WHITE or LIGHT );
      if  AParent <> 'nil' then
          SL.Add(Format( '%s%s.SetName( Result.Form, ''%s'' ); ', [Prefix, AName, Name]))
      else
          SL.Add(Format( '%s%s.SetName( Result, ''%s'' ); ', [Prefix, AName, Name]));
      FNameSetuped := TRUE;
  end;
end;

procedure TKOLObj.P_SetupName(SL: TStringList);
begin
  if fP_NameSetuped then Exit;
  if Name <> '' then
  begin
    //SL.Add( '   {$IFDEF USE_NAMES}' );
    //SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    //SL.Add( '   {$ENDIF}' );
    {P}SL.Add( ' IFDEF(USE_NAMES)' );
    {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( Name ) );
    {P}SL.Add( ' LoadSELF' );
    {P}SL.Add( ' C3 TObj.SetName<3> DelAnsiStr' );
    {P}SL.Add( ' ENDIF' );
    fP_NameSetuped := TRUE;
  end;
end;

{ TKOLFont }

procedure TKOLFont.Assign(Value: TPersistent);
var F: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Assign', 0
  @@e_signature:
  end;
  //inherited;
  if Value = nil then
  begin
    FColor := clWindowText;
    FFontStyle := [];
    FFontHeight := 0;
    FFontWidth := 0;
    FFontWeight := 0;
    FFontName := 'System';
    FFontOrientation := 0;
    FFontCharset := DEFAULT_CHARSET;
    FFontPitch := fpDefault;
  end
    else
  if Value is TKOLFont then
  begin
    F := Value as TKOLFont;
    FColor := F.Color;
    //Rpt( '-------------------------------Assigned font color:' + Int2Hex( Color2RGB( F.Color ), 8 ) );
    FFontStyle := F.FontStyle;
    FFontHeight := F.FontHeight;
    FFontWidth := F.FontWidth;
    FFontWeight := F.FontWeight;
    FFontName := F.FontName;
    FFontOrientation := F.FontOrientation;
    FFontCharset := F.FontCharset;
    FFontPitch := F.FontPitch;
  end;
  Change;
end;

procedure TKOLFont.Change;
var ParentOfOwner: TComponent;
    {$IFDEF _KOLCtrlWrapper_}
    _FKOLCtrl: PControl;
    {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Change', 0
  @@e_signature:
  end;
  if fOwner = nil then Exit;
  if (fOwner is TKOLForm) and (fOwner as TKOLForm).fCreating then Exit;
  if csLoading in fOwner.ComponentState then Exit;
  if fChangingNow then Exit;
  try

    if fOwner is TKOLForm then
    begin
      (fOwner as TKOLForm).ApplyFontToChildren;
      if KOLProject <> nil then
          (fOwner as TKOLForm).fFontDefault := Equal2(KOLProject.DefaultFont);
      (fOwner as TKOLForm).Change( fOwner );
    end
    else
    {if (fOwner is TKOLCustomControl) then
    begin
      if not (csLoading in fOwner.ComponentState) then
      begin
        ParentOfOwner := (fOwner as TKOLCustomControl).ParentKOLControl;
        if ParentOfOwner <> nil then
          if ParentOfOwner is TKolForm then
          begin
            if not Equal2( (ParentOfOwner as TKOLForm).Font ) then
              (fOwner as TKOLCustomControl).ParentFont := FALSE;
          end
            else
          if ParentOfOwner is TKOLCustomControl then
          begin
            if not Equal2( (ParentOfOwner as TKOLCustomControl).Font ) then
              (fOwner as TKOLCustomControl).ParentFont := FALSE;
          end;
      end;}
    ////////////////////////////////////////// changed by YS 11-Dec-2003
    if (fOwner is TKOLCustomControl) then
    begin
      ParentOfOwner := (fOwner as TKOLCustomControl).ParentKOLControl;
      if (ParentOfOwner <> nil) and not (csLoading in ParentOfOwner.ComponentState) then
        if ParentOfOwner is TKolForm then
        begin
          if not Equal2( (ParentOfOwner as TKOLForm).Font ) then
            (fOwner as TKOLCustomControl).ParentFont := FALSE;
        end
          else
        if ParentOfOwner is TKOLCustomControl then
        begin
          if not Equal2( (ParentOfOwner as TKOLCustomControl).Font ) then
            (fOwner as TKOLCustomControl).ParentFont := FALSE;
        end;
  //////////////////////////////////////////////////////////////////////////////
  {YS}
  {$IFDEF _KOLCtrlWrapper_}
      if Assigned((fOwner as TKOLCustomControl).FKOLCtrl) then
      begin
          _FKOLCtrl := (fOwner as TKOLCustomControl).FKOLCtrl;
          if not Equal2(nil) then
          begin
            _FKOLCtrl.Font.FontName:=FontName;
            _FKOLCtrl.Font.FontHeight:=FontHeight;
            _FKOLCtrl.Font.FontWidth:=FontWidth;
            _FKOLCtrl.Font.Color:=Self.Color;
            _FKOLCtrl.Font.FontStyle:= KOL.TFontStyle( FontStyle );
            {$IFNDEF _D2}
            _FKOLCtrl.Font.FontCharset:=FontCharset;
            {$ENDIF}
          end
          else
            _FKOLCtrl.Font.AssignHandle((fOwner as TKOLCustomControl).GetDefaultControlFont);
          (fOwner as TKOLCustomControl).Invalidate;
      end;
  {$ENDIF}
{YS}
      (fOwner as TKOLCustomControl).ApplyFontToChildren;
      (fOwner as TKOLCustomControl).Change;
      (fOwner as TKOLCustomControl).Invalidate;
    end                               // correct by Gendalf
      else                            // +
        if (fOwner is TKOLObj) then   // +
          (fOwner as TKOLObj).Change; // +

  finally
    fChangingNow := FALSE;
  end;
end;

procedure TKOLFont.Changing;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Changing', 0
  @@e_signature:
  end;
  if fOwner is TKOLForm then
    (fOwner as TKOLForm).CollectChildrenWithParentFont
  else
  if fOwner is TKOLCustomControl then
    (fOwner as TKOLCustomControl).CollectChildrenWithParentFont;
end;

constructor TKOLFont.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Create', 0
  @@e_signature:
  end;
  inherited Create;
  fOwner := AOwner;
  fColor := clWindowText;
  fFontName := 'Tahoma';
  fFontWidth := 0;
  fFontHeight := 0;
  fFontCharset := DEFAULT_CHARSET;
  fFontPitch := fpDefault;
  FFontOrientation := 0;
  FFontWeight := 0;
  FFontStyle := [ ];
end;

function TKOLFont.Equal2(AFont: TKOLFont): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.Equal2', 0
  @@e_signature:
  end;
  Result := False;
  if AFont = nil then
  begin
    if Color <> clWindowText then Exit;
    if FontStyle <> [ ] then Exit;
    if FontHeight <> 0 then Exit;
    if FontWidth <> 0 then Exit;
    if FontWeight <> 0 then Exit;
    if FontOrientation <> 0 then Exit;
    if FontCharset <> DEFAULT_CHARSET then Exit;
    if FontPitch <> fpDefault then Exit;
    if FontQuality <> fqDefault then Exit;
    if FontName <> 'System' then Exit;
    Result := True;
    Exit;
  end;
  if Color <> AFont.Color then Exit;
  if FontStyle <> AFont.FontStyle then Exit;
  if FontHeight <> AFont.FontHeight then Exit;
  if FontWidth <> AFont.FontWidth then Exit;
  if FontWeight <> AFont.FontWeight then Exit;
  if FontName <> AFont.FontName then Exit;
  if FontOrientation <> AFont.FontOrientation then Exit;
  if FontCharset <> AFont.FontCharset then Exit;
  if FontPitch <> AFont.FontPitch then Exit;
  if FontQuality <> AFont.FontQuality then Exit;
  Result := True;
end;

procedure TKOLFont.GenerateCode(SL: TStrings; const AName: String;
  AFont: TKOLFont);
const
  FontPitches: array[ TFontPitch ] of String = ( 'fpDefault', 'fpVariable', 'fpFixed' );
var BFont: TKOLFont;
    S: String;
    FontPname: String;
    Lines: Integer;
    KF: TKOLForm;
    Ctl_Name: String;
    fs: TFontStyles;

    procedure AddLine( const S: String );
    begin
      if Lines = 0 then
        if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
          (fOwner as TKOLCustomControl).BeforeFontChange( SL, AName, '    ' );
      Inc( Lines );
      //Rpt( AName + '.' + FontPname + '.' + S + ';' );
      SL.Add( '    ' + AName + '.' + FontPname + '.' + S + ';' );
    end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.GenerateCode', 0
  @@e_signature:
  end;
  //Rpt( fOwner.Name );
  BFont := AFont;
  if AFont = nil then
    BFont := TKOLFont.Create( nil );

  KF := nil;
  Ctl_Name := '';
  if  fOwner <> nil then
      if  fOwner is TKOLForm then
      begin
          KF := fOwner as TKOLForm;
          Ctl_Name := 'Form';
      end
      else if  fOwner is TKOLCustomControl then
      begin
          KF := (fOwner as TKOLCustomControl).ParentKOLForm;
          if  KF <> nil then
              Ctl_Name := (fOwner as TKOLCustomControl).Name;
      end;

  FontPname := 'Font';
  Lines := 0;
  if  (fOwner <> nil) and (fOwner is TKOLCustomControl) then
      FontPname := (fOwner as TKOLCustomControl).FontPropName;

  if  Color <> BFont.Color then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontColor', '' );
          KF.FormAddNumParameter( (Color shl 1) or (Color shr 31) );
      end
      else
      AddLine( 'Color := TColor(' + Color2Str( Color ) + ')' );

  if FontStyle <> BFont.FontStyle then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          fs := FontStyle;
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontStyles', '' );
          KF.FormAddNumParameter( PByte( @fs )^ );
      end
        else
      begin
          S := '';
          if fsBold in TFontStyles( FontStyle ) then
            S := ' fsBold,';
          if fsItalic in TFontStyles( FontStyle ) then
            S := S + ' fsItalic,';
          if fsStrikeout in TFontStyles( FontStyle ) then
            S := S + ' fsStrikeOut,';
          if fsUnderline in TFontStyles( FontStyle ) then
            S := S + ' fsUnderline,';
          if S <> '' then
            S := Trim( Copy( S, 1, Length( S ) - 1 ) );
          AddLine( 'FontStyle := [ ' + S + ' ]' );
      end;
  end;

  if  FontHeight <> BFont.FontHeight then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontHeight', '' );
          KF.FormAddNumParameter( FontHeight );
      end else
      AddLine( 'FontHeight := ' + IntToStr( FontHeight ) );

  if  FontWidth <> BFont.FontWidth then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontWidth', '' );
          KF.FormAddNumParameter( FontWidth );
      end else
      AddLine( 'FontWidth := ' + IntToStr( FontWidth ) );

  if  FontName <> BFont.FontName then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontName', '' );
          KF.FormAddStrParameter( FontName );
      end else
      AddLine( 'FontName := ''' + FontName + '''' );

  if  FontOrientation <> BFont.FontOrientation then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontOrientation', '' );
          KF.FormAddNumParameter( FontOrientation );
      end else
      AddLine( 'FontOrientation := ' + IntToStr( FontOrientation ) );

  if  FontCharset <> BFont.FontCharset then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontCharset', '' );
          KF.FormAddNumParameter( FontCharset );
      end else
      AddLine( 'FontCharset := ' + IntToStr( FontCharset ) );

  if  FontPitch <> BFont.FontPitch then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Ctl_Name, 'FormSetFontPitch', '' );
          KF.FormAddNumParameter( Integer( FontPitch ) );
      end else
      AddLine( 'FontPitch := ' + FontPitches[ FontPitch ] );

  if  AFont = nil then
      BFont.Free;

  if  Lines > 0 then
  if  (fOwner <> nil) and (fOwner is TKOLCustomControl) then
      (fOwner as TKOLCustomControl).AfterFontChange( SL, AName, '    ' );
end;

procedure TKOLFont.P_GenerateCode(SL: TStrings; const AName: String; AFont: TKOLFont);
const
  FontPitches: array[ TFontPitch ] of String = ( 'fpDefault', 'fpVariable', 'fpFixed' );
var BFont: TKOLFont;
    FontPname: String;

var FontInStack: Boolean;
    procedure ProvideFontInStack;
    begin
      if not FontInStack then
      begin
        {P}SL.Add( ' DUP TControl_.GetFont<1> RESULT' );
        FontInStack := TRUE;
      end;
    end;

var Lines: Integer;

    procedure AddLine( const S: String );
    begin
      if Lines = 0 then
        if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
          (fOwner as TKOLCustomControl).P_BeforeFontChange( SL, AName, '    ' );
      Inc( Lines );
      //Rpt( AName + '.' + FontPname + '.' + S + ';' );
      //SL.Add( '    ' + AName + '.' + FontPname + '.' + S + ';' );
      ProvideFontInStack;
      {P}SL.Add( S );
    end;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.P_GenerateCode', 0
  @@e_signature:
  end;
  FontInStack := FALSE;
  //Rpt( fOwner.Name );
  BFont := AFont;
  if AFont = nil then
    BFont := TKOLFont.Create( nil );

  FontPname := 'Font';
  Lines := 0;
  if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
    FontPname := (fOwner as TKOLCustomControl).FontPropName;

  if Color <> BFont.Color then
    //AddLine( 'Color := ' + Color2Str( Color ) );
    begin
      {P}AddLine( ' L($' + IntToHex( Color, 6 ) +')' );
      {P}AddLine( ' C1 TGraphTool.SetColor<2>' );
    end;

  if FontStyle <> BFont.FontStyle then
  begin
    {P}AddLine( ' L(' + IntToStr( PByte( @ FontStyle )^ ) + ')' );
    {P}AddLine( ' C1 TGraphTool.SetFontStyle<2>' );
  end;
  if FontHeight <> BFont.FontHeight then
    //AddLine( 'FontHeight := ' + IntToStr( FontHeight ) );
    begin
      {P}AddLine( ' L(' + IntToStr( FontHeight ) + ')' );
      {P}AddLine( ' L(' + IntToStr( go_FontHeight ) + ')' );
      {P}AddLine( ' C2 TGraphTool.SetInt<3>' );
    end;
  if FontWidth <> BFont.FontWidth then
    //AddLine( 'FontWidth := ' + IntToStr( FontWidth ) );
    begin
      {P}AddLine( ' L(' + IntToStr( FontWidth ) + ')' );
      {P}AddLine( ' L(' + IntToStr( go_FontWidth ) + ')' );
      {P}AddLine( ' C2 TGraphTool.SetInt<3>' );
    end;
  if FontName <> BFont.FontName then
    //AddLine( 'FontName := ''' + FontName + '''' );
    begin
      {P}AddLine( ' LoadAnsiStr ' + P_String2Pascal( FontName ) );
      {P}AddLine( ' C2 TGraphTool.SetFontName<2>' );
      {P}AddLine( ' DelAnsiStr' );
    end;
  if FontOrientation <> BFont.FontOrientation then
    //AddLine( 'FontOrientation := ' + IntToStr( FontOrientation ) );
    begin
      {P}AddLine( ' L(' + IntToStr( FontOrientation ) + ')' );
      {P}AddLine( ' C1 TGraphTool.SetFontOrientation<2>' );
    end;
  if FontCharset <> BFont.FontCharset then
    //AddLine( 'FontCharset := ' + IntToStr( FontCharset ) );
    begin
      {P}AddLine( ' L(' + IntToStr( FontCharset ) + ')' );
      {P}AddLine( ' C1 TGraphTool.SetFontCharset<2>' );
    end;
  if FontPitch <> BFont.FontPitch then
    //AddLine( 'FontPitch := ' + FontPitches[ FontPitch ] );
    begin
      {P}AddLine( ' L(' + IntToStr( Integer( FontPitch ) ) + ')' );
      {P}AddLine( ' C1 TGraphTool.SetFontPitch<2>' );
    end;
  if FontInStack then
    SL.Add( ' DEL // Font' );

  if AFont = nil then
    BFont.Free;

  if Lines > 0 then
  if (fOwner <> nil) and (fOwner is TKOLCustomControl) then
    (fOwner as TKOLCustomControl).P_AfterFontChange( SL, AName, '    ' );
end;

procedure TKOLFont.SetColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetColor', 0
  @@e_signature:
  end;
  if FColor = Value then Exit;
  if Value <> clWindowText then
  begin
    if Assigned( fOwner ) then
    if fOwner is TKOLCustomControl then
    if (fOwner as TKOLCustomControl).CanNotChangeFontColor then
    begin
      ShowMessage( 'Can not change font color for some of controls, such as button.' );
      Exit;
    end;
  end;
  Changing;
  FColor := Value;
  Change;
end;

procedure TKOLFont.SetFontCharset(const Value: Byte);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontCharset', 0
  @@e_signature:
  end;
  if FFontCharset = Value then Exit;
  Changing;
  FFontCharset := Value;
  Change;
end;

procedure TKOLFont.SetFontHeight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontHeight', 0
  @@e_signature:
  end;
  if FFontHeight = Value then Exit;
  Changing;
  FFontHeight := Value;
  Change;
end;

procedure TKOLFont.SetFontName(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontName', 0
  @@e_signature:
  end;
  if FFontName = Value then Exit;
  Changing;
  FFontName := Value;
  Change;
end;

procedure TKOLFont.SetFontOrientation(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontOrientation', 0
  @@e_signature:
  end;
  if FFontOrientation = Value then Exit;
  Changing;
  if Value > 3600 then Value := 3600;
  if Value < -3600 then Value := -3600;
  FFontOrientation := Value;
  Change;
end;

procedure TKOLFont.SetFontPitch(const Value: TFontPitch);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontPitch', 0
  @@e_signature:
  end;
  if FFontPitch = Value then Exit;
  Changing;
  FFontPitch := Value;
  Change;
end;

procedure TKOLFont.SetFontQuality(const Value: TFontQuality);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontQuality', 0
  @@e_signature:
  end;
  if FFontQuality = Value then Exit;
  Changing;
  FFontQuality := Value;
  Change;
end;

procedure TKOLFont.SetFontStyle(const Value: TFontStyles);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontStyle', 0
  @@e_signature:
  end;
  if FFontStyle = Value then Exit;
  Changing;
  FFontStyle := Value;
  Change;
end;

procedure TKOLFont.SetFontWeight(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontWeight', 0
  @@e_signature:
  end;
  if Value < 0 then Value := 0;
  if Value > 1000 then Value := 1000;
  if FFontWeight = Value then Exit;
  Changing;
  FFontWeight := Value;
  if Value > 0 then
    FFontStyle := FFontStyle + [ fsBold ]
  else
    FFontStyle := FFontStyle - [ fsBold ];
  Change;
end;

procedure TKOLFont.SetFontWidth(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFont.SetFontWidth', 0
  @@e_signature:
  end;
  if FFontWidth = Value then Exit;
  Changing;
  FFontWidth := Value;
  Change;
end;

{ TKOLProjectBuilder }

procedure TKOLProjectBuilder.Edit;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.Edit', 0
  @@e_signature:
  end;
  if Component = nil then Exit;
  if not(Component is TKOLProject) then Exit;
  (Component as TKOLProject).SetBuild( True );
end;

procedure TKOLProjectBuilder.ExecuteVerb(Index: Integer);
var SL: TStringList;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.ExecuteVerb', 0
  @@e_signature:
  end;
  case Index of
  0: Edit;
  1: if Component <> nil then
     if Component is TKOLProject then
     TRY
       S := (Component as TKOLProject).sourcePath;
       ShellExecute( 0, nil, PChar( S ), nil, nil, SW_SHOW );
     EXCEPT on E: Exception do
         begin
           SL := TStringList.Create;
           TRY
             SL := GetCallStack;
             ShowMessage( 'Exception 13611: ' + E.Message + ' (' + S + ')' +
                          #13#10 + SL.Text );
           FINALLY
             SL.Free;
           END;
         end;
     END;
  end;
end;

function TKOLProjectBuilder.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.GetVerb', 0
  @@e_signature:
  end;
  case Index of
  0: Result := 'Convert to KOL';
  1: Result := 'Open project folder';
  end;
end;

function TKOLProjectBuilder.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProjectBuilder.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 2;
end;

{$IFDEF _D5}
{ TLeftPropEditor }

function TLeftPropEditor.VisualValue: string;
var Comp: TPersistent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TLeftPropEditor.VisualValue', 0
  @@e_signature:
  end;
  Result := Value;
  Comp := GetComponent( 0 );
  if Comp is TKOLCustomControl then
    Result := IntToStr( (Comp as TKOLCustomControl).actualLeft );
end;

procedure TLeftPropEditor.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TLeftPropEditor.PropDrawValue', 0
  @@e_signature:
  end;
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.Font.Color := clWindowText;
  if ASelected then
  begin
    ACanvas.Brush.Color := clHighLight;
    ACanvas.Font.Color := clHighlightText;
  end;
  ACanvas.TextRect( ARect, ARect.Left, ARect.Top, VisualValue );
end;

{ TTopPropEditor }

procedure TTopPropEditor.PropDrawValue(ACanvas: TCanvas;
  const ARect: TRect; ASelected: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TTopPropEditor.PropDrawValue', 0
  @@e_signature:
  end;
  ACanvas.Brush.Color := clBtnFace;
  ACanvas.Font.Color := clWindowText;
  if ASelected then
  begin
    ACanvas.Brush.Color := clHighLight;
    ACanvas.Font.Color := clHighlightText;
  end;
  ACanvas.TextRect( ARect, ARect.Left, ARect.Top, VisualValue );
end;

function TTopPropEditor.VisualValue: string;
var Comp: TPersistent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TTopPropEditor.VisualValue', 0
  @@e_signature:
  end;
  Result := Value;
  Comp := GetComponent( 0 );
  if Comp is TKOLCustomControl then
    Result := IntToStr( (Comp as TKOLCustomControl).actualTop );
end;
{$ENDIF}

{ TKOLDataModule }

procedure TKOLDataModule.GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
    Exit;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if AName <> 'Result' then
    SL.Add( '  Result.' + Add2AutoFreeProc + '( ' + AName + ' );' );
end;

procedure TKOLDataModule.GenerateCreateForm(SL: TStringList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateCreateForm', 0
  @@e_signature:
  end;
  // do not generate - there are no form
end;

procedure TKOLDataModule.GenerateDestroyAfterRun(SL: TStringList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateDestroyAfterRun', 0
  @@e_signature:
  end;
  if howToDestroy = ddAfterRun then
    SL.Add( '  ' + inherited FormName + '.Free;' );
end;

function TKOLDataModule.GenerateINC(const Path: String;
  var Updated: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateINC', 0
  @@e_signature:
  end;
  Result := inherited GenerateINC( Path, Updated );
end;

function TKOLDataModule.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := '';
end;

procedure TKOLDataModule.P_GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String;
  Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.P_GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
    Exit;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if AName <> 'Result' then
    //SL.Add( '  Result.' + Add2AutoFreeProc + '( ' + AName + ' );' );
    begin
      {P}SL.Add( ' C1 C1 TControl.' + Add2AutoFreeProc + '<2>' );
    end;
end;

function TKOLDataModule.Result_Form: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.Result_Form', 0
  @@e_signature:
  end;
  Result := 'nil';
end;

procedure TKOLDataModule.SethowToDestroy(
  const Value: TDataModuleHowToDestroy);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SethowToDestroy', 0
  @@e_signature:
  end;
  if Value = FhowToDestroy then Exit;
  FhowToDestroy := Value;
  Change( Self );
  if not (csLoading in ComponentState) then
    ChangeDPR;
end;

procedure TKOLDataModule.SetOnCreate(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SetOnCreate', 0
  @@e_signature:
  end;
  FOnCreate := Value;
  Change( Self );
end;

procedure TKOLDataModule.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SetupFirst', 0
  @@e_signature:
  end;
  SetupName( SL, AName, AParent, Prefix );
  if howToDestroy = ddOnAppletDestroy then
    SL.Add( Prefix + 'Applet.Add2AutoFree( ' + inherited FormName + ' );' );
end;

procedure TKOLDataModule.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLDataModule.SetupLast', 0
  @@e_signature:
  end;
  // nothing
end;

{ TKOLObjectCompEditor }

//////////////////////////////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                                            //
procedure TKOLObjectCompEditor.CheckEdit(const PropertyEditor: IProperty);      //
{$ELSE}                                                                         //
//////////////////////////////////////////////////////////////////////////////////
procedure TKOLObjectCompEditor.CheckEdit(PropertyEditor: TPropertyEditor);
var
  FreeEditor: Boolean;
//////////////////////////////////////////////////////////////////////////////////
{$ENDIF}                                                                        //
//////////////////////////////////////////////////////////////////////////////////
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.CheckEdit', 0
  @@e_signature:
  end;
{$IFNDEF _D6orHigher}
  FreeEditor := True;
{$ENDIF}
  try
//*///////////////////////////////////////////////////////////////////////////////////////////////
//    if FContinue then EditProperty(PropertyEditor, FContinue, FreeEditor);
//*///////////////////////////////////////////////////////////////////////////////////////////////
    if FContinue then EditProperty(PropertyEditor, FContinue{$IFNDEF _D6orHigher}, FreeEditor{$ENDIF}); //
//*///////////////////////////////////////////////////////////////////////////////////////////////
  finally
//*///////////////////////////////////////////////
{$IFNDEF _D6orHigher}                           //
//*///////////////////////////////////////////////
    if FreeEditor then PropertyEditor.Free;
//*///////////////////////////////////////////////
{$ENDIF}                                        //
//*///////////////////////////////////////////////
  end;
end;

//////////////////////////////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                                            //
procedure TKOLObjectCompEditor.CountEvents(const PropertyEditor: IProperty );   //
{$ELSE}                                                                         //
//////////////////////////////////////////////////////////////////////////////////
procedure TKOLObjectCompEditor.CountEvents( PropertyEditor: TPropertyEditor);
//////////////////////////////////////////////////////////////////////////////////
{$ENDIF}                                                                        //
//////////////////////////////////////////////////////////////////////////////////
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.CountEvents', 0
  @@e_signature:
  end;
  {$IFDEF _D6orHigher}
  if Supports( PropertyEditor, IMethodProperty ) then
  {$ELSE}
  if PropertyEditor is TMethodProperty then
  {$ENDIF}
    Inc( FCount );
  {$IFNDEF _D6orHigher}
  PropertyEditor.Free;
  {$ENDIF}              
end;

procedure TKOLObjectCompEditor.Edit;
var
  {$IFDEF _D5orHigher}
  {$IFDEF _D6orHigher}
  Components: IDesignerSelections;
  {$ELSE}
  Components: TDesignerSelectionList;
  {$ENDIF}
  {$ELSE}
  Components: TComponentList;
  {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.Edit', 0
  @@e_signature:
  end;
  {if Component.ClassNameIs( 'TKOLForm' ) then
  begin
    inherited;
    Exit;
  end;}
  {$IFDEF _D2orD3orD4}
  Components := TComponentList.Create;
  {$ELSE}
  {$IFDEF _D6orHigher}
  Components := CreateSelectionList;
  {$ELSE}
  Components := TDesignerSelectionList.Create;
  {$ENDIF}
  {$ENDIF}

  try
    BestEventName := '';
    if Component is TKOLObj then
      BestEventName := (Component as TKOLObj).BestEventName
    else
    if Component is TKOLApplet then
      BestEventName := (Component as TKOLApplet).BestEventName
    else
    if Component is TKOLCustomControl then
      BestEventName := (Component as TKOLCustomControl).BestEventName;
    FContinue := True;
//////////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
    Components.Add(Component);
  {$ELSE}                                               //
//////////////////////////////////////////////////////////
    Components.Add(Component);
//////////////////////////////////////////////////////////
  {$ENDIF}                                              //
//////////////////////////////////////////////////////////
    FFirst := nil;
    FBest := nil;
    try
      GetComponentProperties(Components, tkAny, Designer, CountEvents);
      //ShowMessage( 'Found ' + IntToStr( FCount ) + ' events' );
      GetComponentProperties(Components, tkAny, Designer, CheckEdit);
      if FContinue then
        if Assigned(FBest) then
        begin
          FBest.Edit;
          //ShowMessage( 'Best found ' + FBest.GetName );
        end
          else
        if Assigned(FFirst) then
        begin
          FFirst.Edit;
          //ShowMessage( 'First found ' + FFirst.GetName );
        end;
    finally
      {$IFDEF _D6orHigher}
      FFirst := nil;
      FBest := nil;
      {$ELSE}
      FFirst.Free;
      FBest.Free;
      {$ENDIF}
    end;
  finally
    {$IFDEF _D6orHigher}
    Components := nil;
    {$ELSE}
    Components.Free;
    {$ENDIF}
    //ShowMessage( 'FREE' );
  end;
end;

//////////////////////////////////////////////////////////////////////////////////////////////////////////
{$IFDEF _D6orHigher}                                                                                   //
procedure TKOLObjectCompEditor.EditProperty(const PropertyEditor: IProperty; var Continue: Boolean);    //
{$ELSE}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
procedure TKOLObjectCompEditor.EditProperty(
  PropertyEditor: TPropertyEditor; var Continue, FreeEditor: Boolean);
//////////////////////////
{$ENDIF}                //
//////////////////////////
var
  PropName: string;
  BestName: string;

  procedure ReplaceBest;
  begin
    {$IFDEF _D6orHigher}
    FBest := nil;
    {$ELSE}
    FBest.Free;
    {$ENDIF}
    FBest := PropertyEditor;
    if FFirst = FBest then FFirst := nil;
    {$IFNDEF _D6orHigher}
    FreeEditor := False;
    {$ENDIF}
  end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLObjectCompEditor.EditProperty', 0
  @@e_signature:
  end;
  {if Component.ClassNameIs( 'TKOLForm' ) then
  begin
    inherited;
    Exit;
  end;}
  {$IFDEF _D6orHigher}
  if not Assigned(FFirst) and Supports(PropertyEditor, IMethodProperty) then
  {$ELSE}
  if not Assigned(FFirst) and (PropertyEditor is TMethodProperty) then
  {$ENDIF}
  begin
    {$IFNDEF _D6orHigher}
    FreeEditor := False;
    {$ENDIF}
    FFirst := PropertyEditor;
  end;
  PropName := PropertyEditor.GetName;
  BestName := BestEventName;
  {$IFDEF _D6orHigher}
  if Supports( PropertyEditor, IMethodProperty ) then
  {$ELSE}
  if PropertyEditor is TMethodProperty then
  {$ENDIF}
  if (CompareText(PropName, BestName ) = 0) or (FCount = 1) then
    ReplaceBest
  else
    if (BestName = '') and
       (CompareText( PropName, 'ONDESTROY' ) <> 0) then
      ReplaceBest;
end;

{ TKOLOnEventPropEditor }

procedure TKOLOnEventPropEditor.Edit;
var
  FormMethodName: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnEventPropEditor.Edit', 0
  @@e_signature:
  end;
  FormMethodName := GetValue;
  if (FormMethodName = '') or
    Designer.MethodFromAncestor(GetMethodValue) then
  begin
    if FormMethodName = '' then
      FormMethodName := GetFormMethodName;
    if FormMethodName = '' then
      {$IFDEF _D3orD4}
      raise EPropertyError.Create(SCannotCreateName);
      {$ELSE}
      raise EPropertyError.CreateRes( {$IFNDEF _D2}@{$ENDIF} SCannotCreateName);
      {$ENDIF}
    SetValue(FormMethodName);
  end;
  Designer.ShowMethod(FormMethodName);
end;

{$IFDEF _D2}
function TKOLOnEventPropEditor.GetFormMethodName: String;
var
  I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnEventPropEditor.GetFormMethodName', 0
  @@e_signature:
  end;
  if GetComponent(0) = Designer.GetRoot then
  begin
    Result := Designer.GetRoot.ClassName;
    if (Result <> '') and (Result[1] = 'T') then
      Delete(Result, 1, 1);
  end
  else
  begin
    {$IFDEF _D2}
    Result := GetComponent(0).Name;
    {$ELSE _D3orHigher}
    Result := Designer.GetObjectName(GetComponent(0));
    {$ENDIF}
    for I := Length(Result) downto 1 do
      if Result[I] in ['.','[',']'] then
        Delete(Result, I, 1);
  end;
  if Result = '' then
    raise EPropertyError.CreateRes( SCannotCreateName );
  Result := Result + GetTrimmedEventName;
end;

function TKOLOnEventPropEditor.GetTrimmedEventName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnEventPropEditor.GetTrimmedEventName', 0
  @@e_signature:
  end;
  Result := GetName;
  if (Length(Result) >= 2) and
    (Result[1] in ['O','o']) and (Result[2] in ['N','n']) then
    Delete(Result,1,2);
end;
{$ENDIF _D2}

{function SearchKOLProject( KOLPrj: Pointer; Child: TIComponentInterface ): Boolean;
         stdcall;
type PIComponentInterface = ^TIComponentInterface;
begin
  if CompareText( Child.GetComponentType, 'TKOLProject' ) = 0 then
  begin
    PIComponentInterface( KOLPrj )^ := Child;
    Result := FALSE;
  end
    else
  begin
    Child.Free;
    Result := TRUE;
  end;
end;}

function BuildKOLProject: Boolean;
{var N, I: Integer;
    S: String;}
    //ModIntf: TIModuleInterface;
    //FrmIntf: TIFormInterface;
    //CompIntf: TIComponentInterface;
    //PrjIntf: TIComponentInterface;
    //Value: LongBool;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'BuildKOLProject', 0
  @@e_signature:
  end;
  Result := FALSE;
  if KOLProject <> nil then
    Result := KOLProject.ConvertVCL2KOL( FALSE, TRUE );
  if not Result then
  begin
    ShowMessage( 'Main form is not opened, and changing of the project dpr file ' +
                 'is not finished. To apply changes, open and show main form.' );
  end;
end;

{ TCursorPropEditor }

function TCursorPropEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paValueList, paSortList ];
end;

function TCursorPropEditor.GetValue: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.GetValue', 0
  @@e_signature:
  end;
  Result := GetStrValue;
end;

procedure TCursorPropEditor.GetValues(Proc: TGetStrProc);
const
  Cursors: array[ 0..16 ] of String = ( ' ', 'IDC_ARROW', 'IDC_IBEAM', 'IDC_WAIT',
  'IDC_CROSS', 'IDC_UPARROW', 'IDC_SIZE', 'IDC_ICON', 'IDC_SIZENWSE', 'IDC_SIZENESW',
  'IDC_SIZEWE', 'IDC_SIZENS', 'IDC_SIZEALL', 'IDC_NO', 'IDC_HAND', 'IDC_APPSTARTING',
  'IDC_HELP' );
var I: Integer;
    Found: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.GetValues', 0
  @@e_signature:
  end;
  Found := FALSE;
  for I := 0 to High( Cursors ) do
    if Trim( Value ) = Trim( Cursors[ I ] ) then
    begin
      Found := TRUE;
      break;
    end;
  if not Found then
    Proc( Value );
  for I := 0 to High( Cursors ) do
    Proc( Cursors[ I ] );
end;

procedure TCursorPropEditor.SetValue(const Value: string);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TCursorPropEditor.SetValue', 0
  @@e_signature:
  end;
  SetStrValue( Trim( Value ) );
end;

{ TKOLFrame }

function TKOLFrame.AutoCaption: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.AutoCaption', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

constructor TKOLFrame.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.Create', 0
  @@e_signature:
  end;
  inherited;
  edgeStyle := esNone;
  FParentFont := TRUE;
  FParentColor := TRUE;
end;

procedure TKOLFrame.GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String; Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
    Exit;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if not AControl then
    SL.Add( '  Result.Form.' + Add2AutoFreeProc + '( ' + AName + ' );' );
end;

procedure TKOLFrame.GenerateCreateForm(SL: TStringList);
const EdgeStyles: array[ TEdgeStyle ] of String = (
      'esRaised', 'esLowered', 'esNone', 'esTransparent', 'esSolid' );
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GenerateCreateForm', 0
  @@e_signature:
  end;
  S := GenerateTransparentInits;
  SL.Add( '  Result.Form := NewPanel( AParent, ' + EdgeStyles[ edgeStyle ] + ' )' +
          '.MarkPanelAsForm' +
          S + ';' );
  SL.Add( '  Result.Form.DF.FormAddress := @ Result.Form;' );
  SL.Add( '  Result.Form.DF.FormObj := Result;' );
  if Caption <> '' then
     if  AssignTextToControls then
         SL.Add( '  Result.Form.Caption := ' + StringConstant( 'Caption', Caption ) + ';' );
  if  FormCompact then
      SL.Add( '  //--< place to call FormCreateParameters >--//' );
  if  FormCompact then
      ClearBeforeGenerateForm( SL );
end;

function TKOLFrame.GenerateTransparentInits: String;
var W, H: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := '';
  if FLocked then Exit;

  if Align <> caNone then
    Result := '.SetAlign( ' + AlignValues[ Align ] + ')';

  if Align <> caNone then
  begin
    W := Width;
    H := Height;
    if Align in [ caLeft, caRight ] then H := 0;
    if Align in [ caTop, caBottom ] then W := 0;
    Result := Result + '.SetSize( ' + IntToStr( W ) + ', ' +
              IntToStr( H ) + ' )';
  end;

  if CenterOnParent and (Align = caNone) then
    Result := Result + '.CenterOnParent';

  if zOrderTopmost then
    Result := Result + '.BringToFront';

  if HelpContext <> 0 then
    Result := Result + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )';

end;

function TKOLFrame.GetCaption: TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GetCaption', 0
  @@e_signature:
  end;
  Result := fFrameCaption;
  if Owner is TForm then
  if (Owner as TForm).Caption <> Result then
    (Owner as TForm).Caption := Result;
end;

function TKOLFrame.GetFrameHeight: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GetFrameHeight', 0
  @@e_signature:
  end;
  Result := inherited Bounds.Height;
end;

function TKOLFrame.GetFrameWidth: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.GetFrameHeight', 0
  @@e_signature:
  end;
  Result := inherited Bounds.Width;
end;

procedure TKOLFrame.P_GenerateAdd2AutoFree(SL: TStringList;
  const AName: String; AControl: Boolean; Add2AutoFreeProc: String;
  Obj: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.P_GenerateAdd2AutoFree', 0
  @@e_signature:
  end;
  if Obj <> nil then
  if Obj is TKOLObj then
  if (Obj as TKOLObj).NotAutoFree then
    Exit;
  if Add2AutoFreeProc = '' then
    Add2AutoFreeProc := 'Add2AutoFree';
  if not AControl then
    //SL.Add( '  Result.Form.' + Add2AutoFreeProc + '( ' + AName + ' );' );
    {P}SL.Add( ' LoadSELF C1 TObj.Add2AutoFree<2>' );
end;

procedure TKOLFrame.P_GenerateCreateForm(SL: TStringList);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.P_GenerateCreateForm', 0
  @@e_signature:
  end;
  S := P_GenerateTransparentInits;

  //SL.Add( '  Result.Form := NewPanel( AParent, ' + EdgeStyles[ edgeStyle ] + ' )' +
  //        S + ';' );
  {P}SL.Add( ' L(' + IntToStr( Integer( edgeStyle ) ) + ')' +
             ' C3 NewPanel<2> RESULT DUP LoadSELF AddByte_Store #T' +
             FormName + '.Form' +
             #13#10 + S );
  if Caption <> '' then
    //SL.Add( '  Result.Form.Caption := ' + StringConstant( 'Caption', Caption ) + ';' );
    {P}SL.Add( P_StringConstant( 'Caption', Caption ) +
      ' C2 TControl_.SetCaption<2> DelAnsiStr' );
end;

function TKOLFrame.P_GenerateTransparentInits: String;
var W, H: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.P_GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := '';
  if FLocked then Exit;

  if Align <> caNone then
    //Result := '.SetAlign( ' + AlignValues[ Align ] + ')';
    {P}Result := Result + #13#10' L(' + IntToStr( Integer( Align ) ) + ')' +
                 ' C1 TControl_.SetAlign<2>';

  if Align <> caNone then
  begin
    W := Width;
    H := Height;
    if Align in [ caLeft, caRight ] then H := 0;
    if Align in [ caTop, caBottom ] then W := 0;
    //Result := Result + '.SetSize( ' + IntToStr( W ) + ', ' + IntToStr( H ) + ' )';
    {P}Result := Result + #13#10' L(' + IntToStr( H ) + ')' +
              ' L(' + IntToStr( W ) + ')' +
              ' C2 TControl_.SetSize<3>';
  end;

  if CenterOnParent and (Align = caNone) then
    //Result := Result + '.CenterOnParent';
    {P}Result := Result + #13#10' DUP TControl_.CenterOnParent<1>';

  if zOrderTopmost then
    //Result := Result + '.BringToFront';
    {P}Result := Result + #13#10' DUP TControl_.BringToFront<1>';

  if HelpContext <> 0 then
    //Result := Result + '.AssignHelpContext( ' + IntToStr( HelpContext ) + ' )';
    {P}Result := Result + #13#10' L(' + IntToStr( HelpContext ) + ')' +
              ' C1 TControl_.AssignHelpContext<2>';

end;

procedure TKOLFrame.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if not ParentFont then
    Font.P_GenerateCode( SL, AName, nil );
  if not ParentColor then
    //SL.Add( Prefix + AName + '.Color := ' + ColorToString( Color ) + ';' );
    {P}SL.Add( ' L($' + Int2Hex( Color, 6 ) + ') C1 TControl_.SetCtlColor<2>' );
end;

procedure TKOLFrame.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.P_SetupLast', 0
  @@e_signature:
  end;
  if not FLocked then
  begin
    S := '';
    if CenterOnScreen then
      //S := Prefix + AName + '.CenterOnParent';
      begin
        {P}S := S + ' DUP TControl.CenterOnParent<1>';
      end;
    if not CanResize then
    begin
      {if S = '' then
        S := Prefix + AName;
      S := S + '.CanResize := False';}
      {P}S := S + ' L(0) C1 TControl_.SetCanResize<2>';
    end;
    if S <> '' then
      //SL.Add( S + ';' );
      {P}SL.Add( S );
    if Assigned( FpopupMenu ) then
      //SL.Add( Prefix + AName + '.SetAutoPopupMenu( Result.' + FpopupMenu.Name +
      //        ' );' );
      begin
        {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + FormName + '.' + FpopupMenu.Name );
        {P}SL.Add( ' C1 TControl.SetAutoPopupMenu<2>' );
      end;
    if @ OnFormCreate <> nil then
    begin
      //SL.Add( Prefix + 'Result.' + (Owner as TForm).MethodName( @ OnFormCreate ) + '( Result );' );
      {P}SL.Add( ' LoadSELF DUP T' + FormName + '.' +
                 (Owner as TForm).MethodName( @ OnFormCreate ) + '<2>' );
    end;
  {YS}
    if FborderStyle = fbsDialog then
      //SL.Add( Prefix + AName + '.Icon := THandle(-1);' );
      {P}SL.Add( ' L(-1) C1 TControl_.SetIcon<2>' );
  {YS}

    //SL.Add( '    Result.Form.CreateWindow;' );
    {P}SL.Add( ' LoadSELF AddByte_LoadRef #T' + FormName +
               '.Form TControl_.CreateWindow<1>' );

    {P}SL.Add( ' DEL(4) EXIT' );
  end;
end;

procedure TKOLFrame.SetAlign(const Value: TKOLAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetAlign', 0
  @@e_signature:
  end;
  FAlign := Value;
  Change( Self );
end;

procedure TKOLFrame.SetCenterOnParent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetCenterOnParent', 0
  @@e_signature:
  end;
  FCenterOnParent := Value;
  Change( Self );
end;

procedure TKOLFrame.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetEdgeStyle', 0
  @@e_signature:
  end;
  FEdgeStyle := Value;
  Change( Self );
end;

procedure TKOLFrame.SetFrameCaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetFrameCaption', 0
  @@e_signature:
  end;
  fFrameCaption := Value;
  Change( Self );
end;

procedure TKOLFrame.SetFrameHeight(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetFrameHeight', 0
  @@e_signature:
  end;
  inherited Bounds.Height := Value;
end;

procedure TKOLFrame.SetFrameWidth(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetFrameWidth', 0
  @@e_signature:
  end;
  inherited Bounds.Width := Value;
end;

procedure TKOLFrame.SetParentColor(const Value: Boolean);
begin
  FParentColor := Value;
  Change( Self );
end;

procedure TKOLFrame.SetParentFont(const Value: Boolean);
begin
  FParentFont := Value;
  Change( Self );
end;

procedure TKOLFrame.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if not ParentFont then
    Font.GenerateCode( SL, AName, nil );
  if not ParentColor then
    SL.Add( Prefix + AName + '.Color := TColor(' + ColorToString( Color ) + ');' );
end;

procedure TKOLFrame.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  SL.Add( '    Result.Form.CreateWindow;' );
end;

procedure TKOLFrame.SetzOrderTopmost(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLFrame.SetzOrderTopmost', 0
  @@e_signature:
  end;
  FzOrderTopmost := Value;
  Change( Self );
end;

{ TKOLMDIChild }

function TKOLMDIChild.DoNotGenerateSetPosition: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIChild.DoNotGenerateSetPosition', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLMDIChild.GenerateCreateForm(SL: TStringList);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIChild.GenerateCreateForm', 0
  @@e_signature:
  end;
  S := GenerateTransparentInits;
  SL.Add( '  Result.Form := NewMDIChild( AParent, ' + StringConstant( 'Caption', Caption ) +
          ' )' + S + ';' );
end;

procedure TKOLMDIChild.SetParentForm(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIChild.SetParentForm', 0
  @@e_signature:
  end;
  if FParentForm = Value then Exit;
  FParentForm := Value;
  Change( Self );
end;

{ TParentMDIFormPropEditor }

function TParentMDIFormPropEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIFormPropEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paValueList, paSortList ];
end;

function TParentMDIFormPropEditor.GetValue: string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIFormPropEditor.GetValue', 0
  @@e_signature:
  end;
  Result := GetStrValue;
end;

procedure TParentMDIFormPropEditor.GetValues(Proc: TGetStrProc);
var I, J: Integer;
    UN, FormName: String;
    MI: TIModuleInterface;
    FI: TIFormInterface;
    CI, ChI: TIComponentInterface;
    IsMDIForm: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIFormPropEditor.GetValues', 0
  @@e_signature:
  end;
  for I := 0 to ToolServices.GetUnitCount-1 do
  begin
      UN := ToolServices.GetUnitName( I );
      MI := ToolServices.GetModuleInterface( UN );
      if MI <> nil then
      TRY
        FI := MI.GetFormInterface;
        if FI <> nil then
        TRY
          CI := FI.GetFormComponent;
          if CI <> nil then
          TRY
            IsMDIForm := FALSE;
            FormName := '';
            for J := 0 to CI.GetComponentCount-1 do
            begin
              ChI := CI.GetComponent( J );
              if ChI.GetComponentType = 'TKOLForm' then
                CI.GetPropValueByName( 'Name', FormName )
              else
              if ChI.GetComponentType = 'TKOLMDIClient' then
                IsMDIForm := TRUE;
              if IsMDIForm and (FormName <> '') then
                break;
            end;
            if IsMDIForm and (FormName <> '') then
              Proc( FormName );
          FINALLY
            CI.Free;
          END;
        FINALLY
          FI.Free;
        END;
      FINALLY
        MI.Free;
      END;
  end;
end;

procedure TParentMDIFormPropEditor.SetValue(const Value: string);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TParentMDIFormPropEditor.SetValue', 0
  @@e_signature:
  end;
  SetStrValue( Trim( Value ) );
end;

{ TKOLMenu }

procedure TKOLMenu.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnUncheckRadioItem', 'OnMeasureItem', 'OnDrawItem' ],
                             [ @ OnUncheckRadioItem, @ OnMeasureItem, @ OnDrawItem ] );
end;

procedure TKOLMenu.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Change', 0
  @@e_signature:
  end;
  inherited;
  UpdateDesign;
  if (Owner <> nil) and (Owner is TKOLForm) then
    (Owner as TKOLForm).Change( Owner );
end;

constructor TKOLMenu.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Create', 0
  @@e_signature:
  end;
  inherited;
  FgenerateConstants := TRUE;
  FItems := TList.Create;
  NeedFree := False;
  Fshowshortcuts := True;
  fCreationPriority := 5;
end;

procedure TKOLMenu.DefineProperties(Filer: TFiler);
var I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.DefineProperties', 0
  @@e_signature:
  end;
  inherited;
  //--Filer.DefineProperty( 'Items', LoadItems, SaveItems, Count > 0 );
  Filer.DefineProperty( 'ItemCount', LoadItemCount, SaveItemCount, True );
  UpdateDisable;
  for I := 0 to FItemCount - 1 do
  begin
    if FItems.Count <= I then
      MI := TKOLMenuItem.Create( Self, nil, nil )
    else
      MI := FItems[ I ];
    MI.DefProps( 'Item' + IntToStr( I ), Filer );
  end;
  if not (csDestroying in ComponentState) then
    UpdateEnable;
end;

destructor TKOLMenu.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Destroy', 0
  @@e_signature:
  end;
  //ShowMessage( 'enter: KOLMenu.Destroy' );
  //!!!//OnMenuItem := nil;
  ActiveDesign.Free;
  //ShowMessage( 'AD freed' );
  for I := FItems.Count - 1 downto 0 do
  begin
    TObject( FItems[ I ] ).Free;
  end;
  //ShowMessage( 'Items freed' );
  FItems.Free;
  //ShowMessage( 'FItems freed' );
  inherited;
  //ShowMessage( 'leave: KOLMenu.Destroy' );
end;

procedure TKOLMenu.DoGenerateConstants(SL: TStringList);
var N: Integer;

  procedure GenItemConst( MI: TKOLMenuItem );
  var J: Integer;
  begin
    if MI.Name <> '' then
    if MI.itemindex >= 0 then
    begin
      if not MI.separator or generateSeparatorConstants then
        //SL.Add( 'const ' + MI.Name + ': Integer = ' + IntToStr( MI.itemindex ) + ';' );
        SL.Add( 'const ' + MI.Name + ' = ' + IntToStr( MI.itemindex ) + ';' );
      Inc( N );
    end;
    for J := 0 to MI.Count-1 do
      GenItemConst( MI.SubItems[ J ] );
  end;

var I: Integer;
begin
  if not generateConstants then Exit;
  N := 0;
  for I := 0 to Count-1 do
    GenItemConst( Items[ I ] );
  if N > 0 then
    SL.Add( '' );
end;

function TKOLMenu.GetCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.GetCount', 0
  @@e_signature:
  end;
  Result := FItems.Count;
end;

function TKOLMenu.GetItems(Idx: Integer): TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.GetItems', 0
  @@e_signature:
  end;
  Result := nil;
  if (FItems <> nil) and (Idx >= 0) and (Idx < FItems.Count) then
    Result := FItems[ Idx ];
end;

procedure TKOLMenu.LoadItemCount(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.LoadItemCount', 0
  @@e_signature:
  end;
  FItemCount := R.ReadInteger;
end;

function TKOLMenu.NameAlreadyUsed(const ItemName: String): Boolean;
  function NameUsed1( MI: TKOLMenuItem ): Boolean;
  var I: Integer;
      SI: TKOLMenuItem;
  begin
    Result := MI.Name = ItemName;
    if Result then Exit;
    for I := 0 to MI.Count - 1 do
    begin
      SI := MI.FSubItems[ I ];
      Result := NameUsed1( SI );
      if Result then Exit;
    end;
  end;
var I, J: Integer;
    MI: TKOLMenuItem;
    F: TForm;
    C: TComponent;
    MC: TKOLMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.NameAlreadyUsed', 0
  @@e_signature:
  end;
  F := ParentForm;
  if F = nil then
  begin
    for I := 0 to FItems.Count - 1 do
    begin
      MI := FItems[ I ];
      Result := NameUsed1( MI );
      if Result then Exit;
    end;
    Result := False;
    Exit;
  end;
  Result := F.FindComponent( ItemName ) <> nil;
  if Result then Exit;
  for I := 0 to F.ComponentCount - 1 do
  begin
    C := F.Components[ I ];
    if C is TKOLMenu then
    begin
      MC := C as TKOLMenu;
      for J := 0 to MC.Count - 1 do
      begin
        MI := MC.FItems[ J ];
        Result := NameUsed1( MI );
        if Result then Exit;
      end;
    end;
  end;
  Result := False;
end;

function TKOLMenu.NotAutoFree: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.NotAutoFree', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLMenu.OnMenuItemMethodName( for_pcode: Boolean ): String;
var F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.OnMenuItemMethodName', 0
  @@e_signature:
  end;
  Result := '';
  if TMethod( OnMenuItem ).Code <> nil then
  begin
    F := ParentForm;
    if F <> nil then
      Result := F.MethodName( TMethod( OnMenuItem ).Code );
  end;
  if Result = '' then
    Result := 'nil'
  else
  if not for_pcode then
    Result := 'Result.' + Result;
  RptDetailed( 'MenuItem ' + Name + ' OnMenuItemName = ' + Result, YELLOW );
end;

procedure TKOLMenu.SaveItemCount(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SaveItemCount', 0
  @@e_signature:
  end;
  FItemCount := FItems.Count;
  W.WriteInteger( FItemCount );
end;

procedure TKOLMenu.SaveTo(WR: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SaveTo', 0
  @@e_signature:
  end;
  Writestate( WR );
end;

procedure TKOLMenu.SetgenerateSeparatorConstants(const Value: Boolean);
begin
  if FgenerateSeparatorConstants = Value then Exit;
  FgenerateSeparatorConstants := Value;
  Change;
end;

procedure TKOLMenu.SetgenerateConstants(const Value: Boolean);
begin
  if FgenerateConstants = Value then Exit;
  FgenerateConstants := Value;
  Change;
end;

procedure TKOLMenu.SetName(const NewName: TComponentName);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetName', 0
  @@e_signature:
  end;
  inherited;
  if ActiveDesign <> nil then
  begin
    S := NewName;
    if ParentForm <> nil then
      S := ParentForm.Name + '.' + S;
    ActiveDesign.Caption := S;
  end;
end;

procedure TKOLMenu.SetOnDrawItem(const Value: TOnDrawItem);
begin
  if @ FOnDrawItem = @ Value then Exit;
  FOnDrawItem := Value;
  Change;
end;

procedure TKOLMenu.SetOnMeasureItem(const Value: TOnMeasureItem);
begin
  if @ FOnMeasureItem = @ Value then Exit;
  FOnMeasureItem := Value;
  Change;
end;

procedure TKOLMenu.SetOnMenuItem(const Value: TOnMenuItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetOnMenuItem', 0
  @@e_signature:
  end;
  if @ FOnMenuItem = @ Value then Exit;
  FOnMenuItem := Value;
  Change;
end;

procedure TKOLMenu.SetOnUncheckRadioItem(const Value: TOnMenuItem);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetOnUncheckRadioItem', 0
  @@e_signature:
  end;
  if @ FOnUncheckRadioItem = @ Value then Exit;
  FOnUncheckRadioItem := Value;
  Change;
end;

procedure TKOLMenu.Setshowshortcuts(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.Setshowshortcuts', 0
  @@e_signature:
  end;
  if @ Fshowshortcuts = @ Value then Exit;
  Fshowshortcuts := Value;
  Change;
end;

procedure TKOLMenu.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var I: Integer;
    S: String;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetupFirst', 0
  @@e_signature:
  end;
  RptDetailed( '-> ' + Name + ':TKOLMenu.SetupFirst', RED );
  if Count = 0 then Exit;
  SL.Add( Prefix + AName + ' := NewMenu( ' + AParent + ', 0, [ ' );
  for I := 0 to FItems.Count - 1 do
   begin
    MI := FItems[ I ];
    MI.SetupTemplate( SL, I = 0, ParentKOLForm );
   end;
  S := ''''' ], ' + OnMenuItemMethodName( FALSE ) + ' );';
  if FItems.Count <> 0 then
    S := ', ' + S;
  if Length( S ) + Length( SL[ SL.Count - 1 ] ) > 64 then
    SL.Add( Prefix + '  ' + S )
  else
    SL[ SL.Count - 1 ] := SL[ SL.Count - 1 ] + S;
  SetupName( SL, AName, AParent, Prefix );
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.SetupAttributes( SL, AName );
  end;
  GenerateTag( SL, AName, Prefix );
end;

procedure TKOLMenu.UpdateDisable;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.UpdateDisable', 0
  @@e_signature:
  end;
  FUpdateDisabled := TRUE;
end;

procedure TKOLMenu.UpdateEnable;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.UpdateEnable', 0
  @@e_signature:
  end;
  if not FUpdateDisabled then Exit;
  FUpdateDisabled := FALSE;
  if FUpdateNeeded then
  begin
    FUpdateNeeded := FALSE;
    UpdateMenu;
  end;
end;

procedure TKOLMenu.UpdateMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.UpdateMenu', 0
  @@e_signature:
  end;
  //
end;

procedure TKOLMenu.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I, N: Integer;
    //S: String;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenu.SetupFirst', 0
  @@e_signature:
  end;
  if Count = 0 then Exit;
  (*SL.Add( Prefix + AName + ' := NewMenu( ' + AParent + ', 0, [ ' );
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.SetupTemplate( SL, I = 0 );
  end;
  S := ''''' ], ' + OnMenuItemMethodName + ' );';
  if FItems.Count <> 0 then
    S := ', ' + S;
  if Length( S ) + Length( SL[ SL.Count - 1 ] ) > 64 then
    SL.Add( Prefix + '  ' + S )
  else
    SL[ SL.Count - 1 ] := SL[ SL.Count - 1 ] + S;
  if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.SetupAttributes( SL, AName );
  end;
  GenerateTag( SL, AName, Prefix );*)
  //----------------------------------------------------------------------------
  N := 1;
  for I := FItems.Count - 1 downto 0 do
  begin
    MI := FItems[ I ];
    N := N + MI.P_SetupTemplate( SL, FALSE );
  end;
  ItemsInStack := N;
  {P}SL.Add( ' L(' + IntToStr( N ) + ') LoadPCharArray #0' );
  for I := FItems.Count - 1 downto 0 do
  begin
    MI := FItems[ I ];
    MI.P_SetupTemplate( SL, TRUE );
  end;
  {P}SL.Add( ' L(' + IntToStr( N-1 ) + ')' );
  {P}if TMethod( OnMenuItem ).Code <> nil then
     begin
       SL.Add( ' LoadSELF Load4 ####T' +
               ParentKOLForm.FormName + '.' + OnMenuItemMethodName( TRUE ) );
     end else SL.Add( ' L(0) L(0)' );
  {P}SL.Add( ' LoadStack L(12) xyAdd' );
  {P}SL.Add( ' L(0) LoadSELF AddByte_LoadRef #T' + ParentKOLForm.FormName + '.Form' +
             ' NewMenu<3> RESULT DUP LoadSELF AddWord_Store ##T' +
    ParentKOLForm.FormName + '.' + Name );
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.P_SetupAttributes( SL, AName );
  end;
  P_GenerateTag( SL, AName, Prefix );
end;

procedure TKOLMenu.P_SetupFirstFinalizy(SL: TStringList);
begin
  if ItemsInStack > 1 then
    {P}SL.Add( ' L(' + IntToStr( ItemsInStack ) + ') DELN' ) // удаляется массив PChar-указателей на строки Template
  else
  if ItemsInStack = 1 then
    {P}SL.Add( ' DEL // 1 item in stack' );
end;

function TKOLMenu.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLMenu.UpdateDesign;
begin
  {if ActiveDesign = nil then
    ActiveDesign := TKOLMenuDesign.Create( Application );}
  if ActiveDesign <> nil then
     ActiveDesign.RefreshItems;
  //if not FReading then
  //begin
    if ParentForm <> nil then
////////////////////////////////////////////
      if ParentForm.Designer <> nil then  //    иногда может быть NIL ...
////////////////////////////////////////////
      ParentForm.Designer.Modified;
  //end;
end;

procedure TKOLMenu.SetOwnerDraw(const Value: Boolean);
var i: Integer;
    procedure SetOwnerDrawForAllItems( Item: TKOLMenuItem; od: Boolean );
    var j: Integer;
    begin
      Item.OwnerDraw := od;
      for j := 0 to Item.Count-1 do
        SetOwnerDrawForAllItems( Item.SubItems[ j ], od );
    end;
begin
  FOwnerDraw := Value;
  if Value and not AllItemsAreOwnerDraw or
     not Value and AllItemsAreOwnerDraw then
    for i := 0 to Count-1 do
      SetOwnerDrawForAllItems( Items[ i ], Value );
end;

function TKOLMenu.AllItemsAreOwnerDraw: Boolean;
var i: Integer;
    function AllSubitemsAreOwnerDraw( Item: TKOLMenuItem ): Boolean;
    var j: Integer;
    begin
      Result := FALSE;
      for j := 0 to Item.Count-1 do
        if not Item.SubItems[ j ].FownerDraw or
           not AllSubitemsAreOwnerDraw( Item.SubItems[ j ] ) then Exit;
      Result := TRUE;
    end;
begin
  Result := FALSE;
  for i := 0 to Count-1 do
    if not Items[ i ].FownerDraw or
       not AllSubitemsAreOwnerDraw( Items[ i ] ) then Exit;
  Result := TRUE;
end;

procedure TKOLMenu.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
    MI: TKOLMenuItem;
begin
  inherited;
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.SetupAttributesLast( SL, AName );
  end;
end;

procedure TKOLMenu.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
    MI: TKOLMenuItem;
begin
  inherited;
  for I := 0 to FItems.Count - 1 do
  begin
    MI := FItems[ I ];
    MI.P_SetupAttributesLast( SL, AName );
  end;
end;

{ TKOLMenuItem }

procedure TKOLMenuItem.Change;
var Menu: TKOLMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.Change', 0
  @@e_signature:
  end;
  RptDetailed( Name + ': TKOLMenuItem CHANGED', RED );
  if csLoading in ComponentState then Exit;
  Menu := MenuComponent;
  if Menu <> nil then
    Menu.Change;
end;

constructor TKOLMenuItem.Create(AOwner: TComponent; AParent, Before: TKOLMenuItem);
var Items: TList;
    I: Integer;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.Create', 0
  @@e_signature:
  end;
  S := '';
  if Before <> nil then
    S := Before.Name
  else
    S := 'nil';
  if AOwner <> nil then
    S := AOwner.Name + ', ' + S
  else
    S := 'nil, ' + S;
  //Rpt( 'TKOLMenuItem.Create( ' + S + ' );', WHITE );
  inherited Create( AOwner );
  FParent := AParent;
  if FParent = nil then
    FParent := AOwner;
  FAccelerator := TKOLAccelerator.Create;
  FAccelerator.FOwner := Self;
  FBitmap := TBitmap.Create;
  FSubitems := TList.Create;
  FEnabled := True;
  FVisible := True;
  if AOwner = nil then Exit;
  if AParent = nil then
    Items := (AOwner as TKOLMenu).FItems
  else
    Items := AParent.FSubItems;
  if Before = nil then
    Items.Add( Self )
  else
  begin
    I := Items.IndexOf( Before );
    if I < 0 then
      Items.Add( Self )
    else
      Items.Insert( I, Self );
  end;
  FAllowBitmapCompression := TRUE;
end;

destructor TKOLMenuItem.Destroy;
var I: Integer;
    Sub: TKOLMenuItem;
    Items: TList;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.Destroy', 0
  @@e_signature:
  end;
  Rpt( 'Destroying: ' + Name, WHITE );
  FDestroying := True;
  //!!!///OnMenu := nil;
  for I := FSubitems.Count - 1 downto 0 do
  begin
    Sub := FSubitems[ I ];
    Sub.Free;
  end;
  FSubitems.Free;
  Rpt( 'destoying ' + Name + ': subitems freeed', WHITE );
  FBitmap.Free;
  if Parent <> nil then
  begin
    Items := nil;
    if Parent is TKOLMenu then
      Items := MenuComponent.FItems
    else
    if Parent is TKOLMenuItem then
      Items := (Parent as TKOLMenuItem).FSubItems;
    if Items <> nil then
    begin
      I := Items.IndexOf( Self );
      if I >= 0 then
        Items.Delete( I );
    end;
  end;
  S := Name;
  FAccelerator.Free;
  inherited;
  Rpt( 'Desroyed ' + S, WHITE );
end;

function TKOLMenuItem.GetCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetCount', 0
  @@e_signature:
  end;
  Result := FSubitems.Count;
end;

function TKOLMenuItem.GetMenuComponent: TKOLMenu;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetMenuComponent', 0
  @@e_signature:
  end;
  C := Owner;
  if C is TKOLMenuItem then
    Result := (C as TKOLMenuItem).GetMenuComponent
  else
  if C is TKOLMenu then
    Result := C as TKOLMenu
  else
    Result := nil;
end;

function TKOLMenuItem.GetSubItems(Idx: Integer): TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetSubItems', 0
  @@e_signature:
  end;
  Result := FSubitems[ Idx ];
end;

function TKOLMenuItem.GetUplevel: TKOLMenuItem;
var C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetUplevel', 0
  @@e_signature:
  end;
  C := Parent;
  if C is TKOLMenuItem then
    Result := C as TKOLMenuItem
  else
    Result := nil;
end;

procedure StrList2Binary( SL: TStringList; Data: TStream );
var I: Integer;
    S: String;
    J: Integer;
    C: Byte;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'StrList2Binary', 0
  @@e_signature:
  end;
  for I := 0 to SL.Count - 1 do
  begin
    S := SL[ I ];
    J := 1;
    while J < Length( S ) do
    begin
      C := Hex2Int( Copy( S, J, 2 ) );
      Data.Write( C, 1 );
      Inc( J, 2 );
    end;
  end;
end;

procedure Binary2StrList( Data: TStream; SL: TStringList );
var S: String;
    C: Byte;
    V: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'Binary2StrList', 0
  @@e_signature:
  end;
  while Data.Position < Data.Size do
  begin
    S := '';
    while (Data.Position < Data.Size) and (Length( S ) < 56) do
    begin
      Data.Read( C, 1 );
      V := Copy( Int2Hex( C, 2 ), 1, 2 );
      while Length( V ) < 2 do
        V := '0' + V;
      S := S + V;
    end;
    SL.Add( S );
  end;
end;

procedure TKOLMenuItem.SetBitmap(Value: TBitmap);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetBitmap', 0
  @@e_signature:
  end;
  if Value <> nil then
    if Value.Width * Value.Height = 0 then
      Value := nil;
  if Value <> nil then
  begin
    if Parent is TKOLMainMenu then
    begin
      ShowMessage( 'Menu item in the menu bar can not be checked, so it is ' +
                   'not possible to assign bitmap to upper level items in ' +
                   'the main menu.' );
      Value := nil;
    end;
  end;
  if Value = nil then
  begin
    FBitmap.Width := 0;
    FBitmap.Height := 0;
  end
    else
  begin
    FBitmap.Assign( Value );
    FSeparator := False;
  end;
  Change;
end;

procedure TKOLMenuItem.SetCaption(const Value: TDelphiString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetCaption', 0
  @@e_signature:
  end;

  if (Value <> '') and (AnsiChar(Value[ 1 ]) in ['-','+']) then
  begin
    if not( (Length( Value ) > 1) and (Value[ 1 ] = '-') and (AnsiChar(Value[ 2 ]) in ['-','+']) ) then
    ShowMessage( 'Please do not start menu caption with ''-'' or ''+'' characters, ' +
                 'such prefixes are reserved for internal use only. Or, at least ' +
                 'insert once more leading ''-'' character. This is by design ' +
                 'reasons, sorry.' );
  end;
  if Faction = nil then
  begin
    if FCaption = Value then Exit;
    FCaption := Value;
  end
  else
    FCaption:=Faction.Caption;

  if FCaption <> '' then
    FSeparator := False;

  Change;
end;

procedure TKOLMenuItem.SetChecked(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetChecked', 0
  @@e_signature:
  end;
  if Faction = nil then
  begin
    if FChecked = Value then Exit;
    FChecked := Value;
  end
  else
    FChecked := Faction.Checked;
  if FChecked then
    FSeparator := False;
  Change;
end;

procedure TKOLMenuItem.SetEnabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetEnabled', 0
  @@e_signature:
  end;
  if Faction = nil then
  begin
    if FEnabled = Value then Exit;
    FEnabled := Value;
  end
  else
    FEnabled := Faction.Enabled;
  if FEnabled then
    FSeparator := False;
  Change;
end;

function QueryFormDesigner( D: IDesigner; var FD: IFormDesigner ): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'QueryFormDesigner', 0
  @@e_signature:
  end;
  {$IFDEF _D4orHigher}
    Result := D.QueryInterface( IFormDesigner, FD ) = 0;
  {$ELSE}
    Result := False;
    if D is TFormDesigner then
    begin
      FD := D as TFormDesigner;
      Result := True;
    end;
  {$ENDIF}
end;

procedure TKOLMenuItem.SetName(const NewName: TComponentName);
var OldName, NewMethodName: String;
    L: Integer;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetName', 0
  @@e_signature:
  end;
  OldName := Name;
  if OldName = NewName then Exit;
  //Rpt( 'Renaming ' + OldName + ' to ' + NewName, WHITE );
  if (MenuComponent <> nil) and (OldName <> '') and
     MenuComponent.NameAlreadyUsed( NewName ) then
  begin
    ShowMessage( 'Can not rename to ' + NewName + ' - such name is already used.' );
    Exit;
  end;
  if (OldName <> '') and (NewName = '') then
  begin
    ShowMessage( 'Can not rename to '''' - name must not be empty.' );
    Exit;
  end;
  inherited;
  if OldName = '' then Exit;
  if FOnMenuMethodName <> '' then
  if MenuComponent <> nil then
  begin
    L := Length( OldName ) + 4;
    if LowerCase( Copy( FOnMenuMethodName, Length( FOnMenuMethodName ) - L + 1, L ) )
     = LowerCase( OldName + 'Menu' ) then
    begin
      // rename event handler also here:
      F := MenuComponent.ParentForm;
      NewMethodName := MenuComponent.Name + NewName + 'Menu';
      if F <> nil then
      begin
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orhigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
        if D <> nil then
        if QueryFormDesigner( D, FD ) then
        //if D.QueryInterface( IFormDesigner, FD ) = 0 then
        begin
          if not FD.MethodExists( NewMethodName ) then
          begin
            FD.RenameMethod( FOnMenuMethodName, NewMethodName );
            if FD.MethodExists( NewMethodName ) then
              FOnMenuMethodName := NewMethodName;
          end;
        end;
      end;
    end;
  end;
  Change;
end;

procedure TKOLMenuItem.SetOnMenu(const Value: TOnMenuItem);
var F: TForm;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetOnMenu', 0
  @@e_signature:
  end;
  if @ FOnMenu = @ Value then Exit;
  FOnMenu := Value;
  if TMethod( Value ).Code <> nil then
  begin
    if MenuComponent <> nil then
    begin
      F := (MenuComponent as TKOLMenu).ParentForm;
      S := F.MethodName( TMethod( Value ).Code );
      //Rpt( 'Assigned method: ' + S + ' (' +
      //     IntToStr( Integer( TMethod( Value ).Code ) ) + ')' );
      FOnMenuMethodName := S;
      //FOnMenuMethodNum := Integer( TMethod( Value ).Code );
      //if TMethod( Value ).Data = F then
      //  Rpt( 'Assigned method is of form object!' );
    end;
  end
    else
    FOnMenuMethodName := '';
  Change;
end;

procedure TKOLMenuItem.SetVisible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetVisible', 0
  @@e_signature:
  end;
  if Faction = nil then
  begin
    if FVisible = Value then Exit;
    FVisible := Value;
  end
  else
    FVisible := Faction.Visible;
  Change;
end;

procedure TKOLMenuItem.MoveUp;
var ParentItems: TList;
    I: Integer;
    Tmp: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.MoveUp', 0
  @@e_signature:
  end;
  if Parent = MenuComponent then
    ParentItems := MenuComponent.FItems
  else
    ParentItems := (Parent as TKOLMenuItem).FSubitems;
  I := ParentItems.IndexOf( Self );
  if I > 0 then
  begin
    Tmp := ParentItems[ I - 1 ];
    ParentItems[ I - 1 ] := Self;
    ParentItems[ I ] := Tmp;
    Change;
  end;
end;

procedure TKOLMenuItem.MoveDown;
var ParentItems: TList;
    I: Integer;
    Tmp: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.MoveDown', 0
  @@e_signature:
  end;
  if Parent = MenuComponent then
    ParentItems := MenuComponent.FItems
  else
    ParentItems := (Parent as TKOLMenuItem).FSubitems;
  I := ParentItems.IndexOf( Self );
  if I < ParentItems.Count - 1 then
  begin
    Tmp := ParentItems[ I + 1 ];
    ParentItems[ I + 1 ] := Self;
    ParentItems[ I ] := Tmp;
    Change;
  end;
end;

procedure TKOLMenuItem.DefProps(const Prefix: String; Filer: TFiler);
var I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.DefProps', 0
  @@e_signature:
  end;
  Filer.DefineProperty( Prefix + 'Name', LoadName, SaveName, True );
  Filer.DefineProperty( Prefix + 'Caption', LoadCaption, SaveCaption,  Caption <> '' );
  Filer.DefineProperty( Prefix + 'Enabled', LoadEnabled, SaveEnabled, True );
  Filer.DefineProperty( Prefix + 'Visible', LoadVisible, SaveVisible, True );
  Filer.DefineProperty( Prefix + 'Checked', LoadChecked, SaveChecked, True );
  Filer.DefineProperty( Prefix + 'RadioGroup', LoadRadioGroup, SaveRadioGroup, True );
  Filer.DefineProperty( Prefix + 'Separator', LoadSeparator, SaveSeparator, True );
  Filer.DefineProperty( Prefix + 'Accelerator', LoadAccel, SaveAccel, True );
  Filer.DefineProperty( Prefix + 'Bitmap', LoadBitmap, SaveBitmap, True );
  Filer.DefineProperty( Prefix + 'OnMenu', LoadOnMenu, SaveOnMenu, FOnMenuMethodName <> '' );
  Filer.DefineProperty( Prefix + 'SubItemCount', LoadSubItemCount, SaveSubItemCount, True );
  Filer.DefineProperty( Prefix + 'WindowMenu', LoadWindowMenu, SaveWindowMenu, True );
  Filer.DefineProperty( Prefix + 'HelpContext', LoadHelpContext, SaveHelpContext, HelpContext <> 0 );
  Filer.DefineProperty( Prefix + 'OwnerDraw', LoadOwnerDraw, SaveOwnerDraw, ownerDraw );
  Filer.DefineProperty( Prefix + 'MenuBreak', LoadMenuBreak, SaveMenuBreak, MenuBreak <> mbrNone );
  for I := 0 to FSubItemCount - 1 do
  begin
    if FSubItems.Count <= I then
      MI := TKOLMenuItem.Create( MenuComponent, Self, nil )
    else
      MI := FSubItems[ I ];
    MI.DefProps( Prefix + 'SubItem' + IntToStr( I ), Filer );
  end;
  Filer.DefineProperty( Prefix + 'Tag', LoadTag, SaveTag, Tag <> 0 );
  Filer.DefineProperty( Prefix + 'Default', LoadDefault, SaveDefault, Default );
//  Filer.DefineProperty( Prefix + 'Action', LoadAction, SaveAction, FActionComponentName <> '');
end;

procedure TKOLMenuItem.LoadCaption(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadCaption', 0
  @@e_signature:
  end;
  FCaption := R.ReadString;
end;

procedure TKOLMenuItem.LoadChecked(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadChecked', 0
  @@e_signature:
  end;
  FChecked := R.ReadBoolean;
end;

procedure TKOLMenuItem.LoadEnabled(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadEnabled', 0
  @@e_signature:
  end;
  FEnabled := R.ReadBoolean;
end;

procedure TKOLMenuItem.LoadName(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadName', 0
  @@e_signature:
  end;
  Name := R.ReadString;
end;

procedure TKOLMenuItem.LoadOnMenu(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadOnMenu', 0
  @@e_signature:
  end;
  FOnMenuMethodName := R.ReadString;
end;

{procedure TKOLMenuItem.LoadRadioItem(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadRadioItem', 0
  @@e_signature:
  end;
  FRadioItem := R.ReadBoolean;
end;}

procedure TKOLMenuItem.LoadSubItemCount(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadSubItemCount', 0
  @@e_signature:
  end;
  FSubItemCount := R.ReadInteger;
end;

procedure TKOLMenuItem.LoadVisible(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadVisible', 0
  @@e_signature:
  end;
  FVisible := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveCaption(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveCaption', 0
  @@e_signature:
  end;
  W.WriteString( Caption );
end;

procedure TKOLMenuItem.SaveChecked(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveChecked', 0
  @@e_signature:
  end;
  W.WriteBoolean( Checked );
end;

procedure TKOLMenuItem.SaveEnabled(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveEnabled', 0
  @@e_signature:
  end;
  W.WriteBoolean( Enabled );
end;

procedure TKOLMenuItem.SaveName(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveName', 0
  @@e_signature:
  end;
  W.WriteString( Name );
end;

procedure TKOLMenuItem.SaveOnMenu(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveOnMenu', 0
  @@e_signature:
  end;
  W.WriteString( FOnMenuMethodName );
end;

{procedure TKOLMenuItem.SaveRadioItem(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveRadioItem', 0
  @@e_signature:
  end;
  W.WriteBoolean( FradioItem );
end;}

procedure TKOLMenuItem.SaveSubItemCount(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveSubItemCount', 0
  @@e_signature:
  end;
  FSubItemCount := FSubItems.Count;
  W.WriteInteger( FSubItemCount );
end;

procedure TKOLMenuItem.SaveVisible(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveVisible', 0
  @@e_signature:
  end;
  W.WriteBoolean( Visible );
end;

procedure TKOLMenuItem.LoadBitmap(R: TReader);
var MS: TMemoryStream;
    SL: TStringList;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadBitmap', 0
  @@e_signature:
  end;
  MS := TMemoryStream.Create;
  SL := TStringList.Create;
  try
    R.ReadListBegin;
    while not R.EndOfList do
    begin
      S := R.ReadString;
      if Trim( S ) <> '' then
        SL.Add( Trim( S ) );
    end;
    R.ReadListEnd;
    if SL.Count = 0 then
    begin
      FBitmap.Width := 0;
      FBitmap.Height := 0;
    end
      else
    begin
      StrList2Binary( SL, MS );
      MS.Position := 0;
      FBitmap.LoadFromStream( MS );
    end;
  finally
    MS.Free;
    SL.Free;
  end;
end;

procedure TKOLMenuItem.SaveBitmap(W: TWriter);
var MS: TMemoryStream;
    SL: TStringList;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveBitmap', 0
  @@e_signature:
  end;
  MS := TMemoryStream.Create;
  SL := TStringList.Create;
  try
    Bitmap.SaveToStream( MS );
    MS.Position := 0;
    if Bitmap.Width * Bitmap.Height > 0 then
      Binary2StrList( MS, SL );
    W.WriteListBegin;
    for I := 0 to SL.Count - 1 do
      W.WriteString( SL[ I ] );
    W.WriteListEnd;
  finally
    MS.Free;
    SL.Free;
  end;
end;

procedure TKOLMenuItem.SetupTemplate(SL: TStringList; FirstItem: Boolean; KF: TKOLForm);
    procedure Add2SL( const S: TDelphiString );
    begin
      if Length( SL[ SL.Count - 1 ] + S ) > 64 then
        SL.Add( '      ' + S )
      else
        SL[ SL.Count - 1 ] := SL[ SL.Count - 1 ] + S;
    end;
var
{$IFDEF _D2009orHigher}
    C2: WideString;
    S, U: WideString;
 J : integer;
{$ELSE}
    S, U: String;
{$ENDIF}
    I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetupTemplate', 0
  @@e_signature:
  end;
  if Separator then
    S := '-'
  else
  begin
    U := Caption;
    if  (KF <> nil) and not KF.AssignTextToControls then
        U := '';
    {$IFDEF _D2009orHigher}
     C2 := '';
     for j := 1 to Length(U) do C2 := C2 + '#'+IntToStr(ord(U[j]));
     U := C2;
   {$ENDIF}
    if (U = '') or (Faction <> nil) then
      U := ' ';
    S := '';
    if FradioGroup <> 0 then
    begin
      S := '!' + S;
      if (FParent <> nil) and (FParent is TKOLMenuItem) then
      begin
        I := (FParent as TKOLMenuItem).FSubitems.IndexOf( Self );
        if I > 0 then
        begin
          MI := (FParent as TKOLMenuItem).FSubItems[ I - 1 ];
          if (MI.FradioGroup <> 0) and (MI.FradioGroup <> FradioGroup) then
            S := '!' + S;
        end;
      end;
      if not Checked then
        S := '-' + S;
    end;
    if Checked and (Faction = nil) then
      S := '+' + S;
  end;
  if Accelerator.Key <> vkNotPresent then
  if  MenuComponent.showshortcuts and (Faction = nil)
  and (KF <> nil) and KF.AssignTextToControls then
  {$IFDEF _D2009orHigher}
    U := U + '''' + #9 + Accelerator.AsText + '''';
  {$ELSE}
    U := U + #9 + Accelerator.AsText;
  {$ENDIF}
  if S = '' then
  begin
    if Faction = nil then
    {$IFDEF _D2009orHigher}
      S := U
    {$ELSE}
      S := PCharStringConstant( MenuComponent, Name, U )
    {$ENDIF}
  else
    {$IFDEF _D2009orHigher}
      S := U;
    {$ELSE}
      S := '''' + U + '''';
    {$ENDIF}
  end
  else
  begin
  {$IFDEF _D2009orHigher}
    if S = '-' then
     S := '''' + S + ''''
      else
       S := '''' + S + ''' + ';
    if (U <> '') and (U[ 1 ] <> '''') then
      S := 'PWideChar( ' + S + U + ')'
    else
      S := S + U;
  {$ELSE}
    S := '''' + S + ''' + ';
    U := MenuComponent.StringConstant( Name, U );
    if (U <> '') and (U[ 1 ] <> '''') then
      S := 'PChar( ' + S + U + ')'
    else
      S := S + U;
  {$ENDIF}
  end;
  if not FirstItem then
    S := ', ' + S;
  Add2SL( S );
  if Count > 0 then
  begin
    Add2SL( ', ''(''' );
    for I := 0 to Count - 1 do
    begin
      MI := FSubItems[ I ];
      MI.SetupTemplate( SL, False, KF );
    end;
    Add2SL( ', '')''' );
  end;
end;

procedure TKOLMenuItem.SetSeparator(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetSeparator', 0
  @@e_signature:
  end;
  if FSeparator = Value then Exit;
  FSeparator := Value;
  Change;
end;

procedure TKOLMenuItem.LoadSeparator(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadSeparator', 0
  @@e_signature:
  end;
  FSeparator := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveSeparator(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveSeparator', 0
  @@e_signature:
  end;
  W.WriteBoolean( Separator );
end;

function TKOLMenuItem.GetItemIndex: Integer;
var N: Integer;
  procedure IterateThroughSubItems( MI: TKOLMenuItem );
  var I: Integer;
  begin
    if MI = Self then
    begin
      Result := N;
      Exit;
    end;
    Inc( N );
    for I := 0 to MI.Count - 1 do
    begin
      IterateThroughSubItems( MI.FSubItems[ I ] );
      if Result >= 0 then break;
    end;
  end;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.GetItemIndex', 0
  @@e_signature:
  end;
  Result := -1;
  N := 0;
  if MenuComponent <> nil then
  for I := 0 to MenuComponent.Count - 1 do
  begin
    IterateThroughSubItems( MenuComponent.FItems[ I ] );
    if Result >= 0 then break;
  end;
end;

procedure TKOLMenuItem.SetItemIndex_Dummy(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetItemIndex_Dummy', 0
  @@e_signature:
  end;
  // dummy method - nothing to set
end;

const VirtKeys: array[ TVirtualKey ] of String = (
  '0', 'VK_BACK', 'VK_TAB', 'VK_CLEAR', 'VK_RETURN', 'VK_PAUSE', 'VK_CAPITAL',
  'VK_ESCAPE', 'VK_SPACE', 'VK_PRIOR', 'VK_NEXT', 'VK_END', 'VK_HOME', 'VK_LEFT',
  'VK_UP', 'VK_RIGHT', 'VK_DOWN', 'VK_SELECT', 'VK_EXECUTE', 'VK_SNAPSHOT',
  'VK_INSERT', 'VK_DELETE', 'VK_HELP', '$30', '$31', '$32', '$33', '$34', '$35',
  '$36', '$37', '$38', '$39', '$41', '$42', '$43', '$44', '$45', '$46', '$47',
  '$48', '$49', '$4A', '$4B', '$4C', '$4D', '$4E', '$4F', '$50', '$51', '$52',
  '$53', '$54', '$55', '$56', '$57', '$58', '$59', '$5A', 'VK_LWIN', 'VK_RWIN', 'VK_APPS',
  'VK_NUMPAD0', 'VK_NUMPAD1', 'VK_NUMPAD2', 'VK_NUMPAD3', 'VK_NUMPAD4', 'VK_NUMPAD5',
  'VK_NUMPAD6', 'VK_NUMPAD7', 'VK_NUMPAD8', 'VK_NUMPAD9',  'VK_MULTIPLY', 'VK_ADD',
  'VK_SEPARATOR', 'VK_SUBTRACT', 'VK_DECIMAL', 'VK_DIVIDE', 'VK_F1', 'VK_F2', 'VK_F3',
  'VK_F4', 'VK_F5', 'VK_F6', 'VK_F7', 'VK_F8', 'VK_F9', 'VK_F10', 'VK_F11', 'VK_F12',
  'VK_F13', 'VK_F14', 'VK_F15', 'VK_F16', 'VK_F17', 'VK_F18', 'VK_F19', 'VK_F20',
  'VK_F21', 'VK_F22', 'VK_F23', 'VK_F24', 'VK_NUMLOCK', 'VK_SCROLL', 'VK_ATTN',
  'VK_CRSEL', 'VK_EXSEL', 'VK_EREOF', 'VK_PLAY', 'VK_ZOOM', 'VK_PA1', 'VK_OEM_CLEAR' );

const VrtKeyVals: array[ TVirtualKey ] of DWORD = (
  0, VK_BACK, VK_TAB, VK_CLEAR, VK_RETURN, VK_PAUSE, VK_CAPITAL,
  VK_ESCAPE, VK_SPACE, VK_PRIOR, VK_NEXT, VK_END, VK_HOME, VK_LEFT,
  VK_UP, VK_RIGHT, VK_DOWN, VK_SELECT, VK_EXECUTE, VK_SNAPSHOT,
  VK_INSERT, VK_DELETE, VK_HELP, $30, $31, $32, $33, $34, $35,
  $36, $37, $38, $39, $41, $42, $43, $44, $45, $46, $47,
  $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $50, $51, $52,
  $53, $54, $55, $56, $57, $58, $59, $5A, VK_LWIN, VK_RWIN, VK_APPS,
  VK_NUMPAD0, VK_NUMPAD1, VK_NUMPAD2, VK_NUMPAD3, VK_NUMPAD4, VK_NUMPAD5,
  VK_NUMPAD6, VK_NUMPAD7, VK_NUMPAD8, VK_NUMPAD9,  VK_MULTIPLY, VK_ADD,
  VK_SEPARATOR, VK_SUBTRACT, VK_DECIMAL, VK_DIVIDE, VK_F1, VK_F2, VK_F3,
  VK_F4, VK_F5, VK_F6, VK_F7, VK_F8, VK_F9, VK_F10, VK_F11, VK_F12,
  VK_F13, VK_F14, VK_F15, VK_F16, VK_F17, VK_F18, VK_F19, VK_F20,
  VK_F21, VK_F22, VK_F23, VK_F24, VK_NUMLOCK, VK_SCROLL, VK_ATTN,
  VK_CRSEL, VK_EXSEL, VK_EREOF, VK_PLAY, VK_ZOOM, VK_PA1, VK_OEM_CLEAR );

// Maxim Pushkar:
const VirtualKeyNames: array [TVirtualKey] of string =
             ( '', 'Back'{'BackSpace'}, 'Tab', 'CLEAR', 'Enter', 'Pause', 'CapsLock',
                 'Escape'{'Esc'}, 'Space', 'PageUp', 'PageDown', 'End', 'Home', 'Left',
                 'Up', 'Right', 'Down', 'SELECT', 'EXECUTE', 'PrintScreen',
                 'Ins', 'Delete'{'Del'}, 'Help'{'?'}, '0', '1', '2', '3', '4', '5',
                 '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T',
                 'U', 'V', 'W', 'X', 'Y', 'Z', 'LWin', 'RWin', 'APPS',
                 'Numpad0', 'Numpad1', 'Numpad2', 'Numpad3', 'Numpad4',
                 'Numpad5', 'Numpad6', 'Numpad7', 'Numpad8', 'Numpad9',
                 '*', '+', '|', '-', '.', '/', 'F1', 'F2', 'F3', 'F4',
                 'F5', 'F6', 'F7', 'F8', 'F9', 'F10', 'F11', 'F12', 'F13',
                 'F14', 'F15', 'F16', 'F17', 'F18', 'F19', 'F20', 'F21',
                 'F22', 'F23', 'F24', 'NumLock', 'ScrollLock', 'ATTN', 'CRSEL',
                 'EXSEL', 'EREOF', 'PLAY', 'ZOOM', 'PA1', 'OEMCLEAR');


procedure TKOLMenuItem.SetupAttributes(SL: TStringList;
  const MenuName: String);
const Breaks: array[ TMenuBreak ] of String = ( 'mbrNone', 'mbrBreak', 'mbrBarBreak' );
var I: Integer;
    SI: TKOLMenuItem;
    RsrcName: String;
    S: String;
    //F: TForm;
    //FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetupAttributes', 0
  @@e_signature:
  end;
  RptDetailed( '->' + Name + ':TKOLMenuItem.SetupAttributes', RED );
  if not Enabled and (Faction = nil) then
    SL.Add( '    ' + MenuName + '.ItemEnabled[ ' + IntToStr( ItemIndex ) + ' ] := False;' );
  if not Visible and (Faction = nil) then
    SL.Add( '    ' + MenuName + '.ItemVisible[ ' + IntToStr( ItemIndex ) + ' ] := False;' );
  if (HelpContext <> 0) and (Faction = nil) then
    SL.Add( '    ' + MenuName + '.ItemHelpContext[ ' + IntToStr( ItemIndex ) + ' ] := ' +
            IntToStr( HelpContext ) + ';' );
  if (Bitmap <> nil) and (Bitmap.Width <> 0) and (Bitmap.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMP';
    SL.Add( '    ' + MenuName + '.ItemBitmap[ ' + IntToStr( ItemIndex ) +
            ' ] := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
            MenuName + ' );' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName + '_BITMAP' ), RsrcName,
        MenuComponent.fUpdated, AllowBitmapCompression );
  end;
  if (BitmapChecked <> nil) and (bitmapChecked.Width <> 0) and (bitmapChecked.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMPCHECKED';
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].BitmapChecked := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
            MenuName + ' );' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( bitmapChecked, UPPERCASE( RsrcName ), RsrcName,
        MenuComponent.fUpdated, AllowBitmapCompression );
  end;
  if (BitmapItem <> nil) and (bitmapItem.Width <> 0) and (bitmapItem.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMPITEM';
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].BitmapItem := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
            MenuName + ' );' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( bitmapItem, UPPERCASE( RsrcName ), RsrcName,
        MenuComponent.fUpdated, AllowBitmapCompression );
  end;
  //-if FownerDraw then
  //-  SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
  //-          ' ].OwnerDraw := TRUE;' );
  if Fdefault then
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].DefaultItem := TRUE;' );
  if FmenuBreak <> mbrNone then
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].MenuBreak := ' + Breaks[ FmenuBreak ] + ';' );
  //if FOnMenuMethodName <> '' then
  begin
    if CheckOnMenuMethodExists then
    begin
      RptDetailed( 'Menu ' + MenuName + '.AssignEvents: ' +
        FOnMenuMethodName, RED );
      SL.Add( '    ' + MenuName + '.AssignEvents( ' + IntToStr( ItemIndex ) +   //
              ', [ Result.' + FOnMenuMethodName + ' ] );' );                    //
    end
      else
    begin
      RptDetailed( 'Menu ' + Name + ' has no event attached', RED );
    end;
  end;
  if (Accelerator.Key <> vkNotPresent) and (Faction = nil) then
  begin
    S := 'FVIRTKEY';
    if kapShift in Accelerator.Prefix then
      S := S + ' or FSHIFT';
    if kapControl in Accelerator.Prefix then
      S := S + ' or FCONTROL';
    if kapAlt in Accelerator.Prefix then
      S := S + ' or FALT';
    if kapNoinvert in Accelerator.Prefix then
      S := S + ' or FNOINVERT';
    SL.Add( '    ' + MenuName + '.ItemAccelerator[ ' + IntToStr( ItemIndex ) +
            ' ] := MakeAccelerator( ' + S + ', ' + VirtKeys[ Accelerator.Key ] +
            ' );' );

  end;
  if Tag <> 0 then
    SL.Add( '    ' + MenuName + '.Items[' + IntToStr( ItemIndex ) +
            '].Tag := DWORD(' + IntToStr( Tag ) + ');' );
  for I := 0 to Count - 1 do
  begin
    SI := FSubItems[ I ];
    SI.SetupAttributes( SL, MenuName );
  end;
end;

procedure TKOLMenuItem.SetAccelerator(const Value: TKOLAccelerator);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetAccelerator', 0
  @@e_signature:
  end;
  if FAccelerator = Value then Exit;
  FAccelerator := Value;
  Change;
end;

procedure TKOLMenuItem.LoadAccel(R: TReader);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadAccel', 0
  @@e_signature:
  end;
  I := R.ReadInteger;
  FAccelerator.Prefix := [ ];
  if LongBool(I and $100) then
    FAccelerator.Prefix := [ kapShift ];
  if LongBool(I and $200) then
    FAccelerator.Prefix := FAccelerator.Prefix + [ kapControl ];
  if LongBool(I and $400) then
    FAccelerator.Prefix := FAccelerator.Prefix + [ kapAlt ];
  if LongBool(I and $800) then
    Faccelerator.Prefix := FAccelerator.Prefix + [ kapNoinvert ];
  FAccelerator.Key := TVirtualKey( I and $FF );
end;

procedure TKOLMenuItem.LoadWindowMenu(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.LoadWindowMenu', 0
  @@e_signature:
  end;
  FWindowMenu := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveWindowMenu(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveWindowMenu', 0
  @@e_signature:
  end;
  W.WriteBoolean( FWindowMenu );
end;

procedure TKOLMenuItem.SaveAccel(W: TWriter);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SaveAccel', 0
  @@e_signature:
  end;
  I := Ord( Accelerator.Key );
  if kapShift in Accelerator.Prefix then
    I := I or $100;
  if kapControl in Accelerator.Prefix then
    I := I or $200;
  if kapAlt in Accelerator.Prefix then
    I := I or $400;
  if kapNoinvert in Accelerator.Prefix then
    I := I or $800;
  W.WriteInteger( I );
end;

procedure TKOLMenuItem.DesignTimeClick;
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    EvntName: String;
    TI: TTypeInfo;
    TD: TTypeData;
    Meth: TMethod;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.DesignTimeClick', 0
  @@e_signature:
  end;
  Rpt( 'DesignTimeClick: ' + Caption, WHITE );
  if Count > 0 then Exit;
  F := MenuComponent.ParentForm;
  if F = nil then Exit;
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
  if D = nil then Exit;
  if not QueryFormDesigner( D, FD ) then Exit;
  //if D.QueryInterface( IFormDesigner, FD ) <> 0 then Exit;
  EvntName := FOnMenuMethodName;
  if EvntName = '' then
    EvntName := MenuComponent.ParentKOLForm.Name + Name + 'Menu';
  if FD.MethodExists( EvntName ) then
  begin
    FOnMenuMethodName := EvntName;
    FD.ShowMethod( EvntName );
    Change;
    Exit;
  end;
  TI.Kind := tkMethod;
  TI.Name := 'TOnMenuItem';
  TD.MethodKind := mkProcedure;
  TD.ParamCount := 2;
  TD.ParamList := 'Sender: PMenu; Item: Integer'#0#0;
  Meth := FD.CreateMethod( EvntName, {@TD} GetTypeData( TypeInfo( TOnMenuItem ) ) );
  if Meth.Code <> nil then
  begin
    FOnMenuMethodName := EvntName;
    FD.ShowMethod( EvntName );
    Change;
  end;
end;

procedure TKOLMenuItem.SetWindowMenu(Value: Boolean);
  procedure ClearWindowMenuForSubMenus( MI: TKOLMenuItem );
  var I: Integer;
      SMI: TKOLMenuItem;
  begin
    for I := 0 to MI.Count-1 do
    begin
      SMI := MI.SubItems[ I ];
      if SMI = Self then continue;
      SMI.WindowMenu := FALSE;
      ClearWindowMenuForSubMenus( SMI );
    end;
  end;
var I: Integer;
    Menu: TKOLMenu;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.SetWindowMenu', 0
  @@e_signature:
  end;
  if csLoading in ComponentState then
    FWindowMenu := Value
  else
  begin
    Menu := MenuComponent;
    if (Menu = nil) or not(Menu is TKOLMainMenu) then
      Value := FALSE;
    if FWindowMenu = Value then Exit;
    FWindowMenu := Value;
    for I := 0 to Menu.Count-1 do
    begin
      MI := Menu.Items[ I ];
      if MI = Self then continue;
      MI.WindowMenu := FALSE;
      ClearWindowMenuForSubMenus( MI );
    end;
    Change;
  end;
end;

procedure TKOLMenuItem.SetHelpContext(const Value: Integer);
begin
  if Faction = nil then
  begin
    if FHelpContext = Value then Exit;
    FHelpContext := Value;
  end
  else
    FHelpContext := Faction.HelpContext;
  Change;
end;

procedure TKOLMenuItem.LoadHelpContext(R: TReader);
begin
  FHelpContext := R.ReadInteger;
end;

procedure TKOLMenuItem.SaveHelpContext(W: TWriter);
begin
  W.WriteInteger( FHelpContext );
end;

procedure TKOLMenuItem.LoadRadioGroup(R: TReader);
begin
  FradioGroup := R.ReadInteger;
end;

procedure TKOLMenuItem.SaveRadioGroup(W: TWriter);
begin
  W.WriteInteger( FradioGroup );
end;

procedure TKOLMenuItem.SetbitmapChecked(const Value: TBitmap);
begin
  FbitmapChecked := Value;
  Change;
end;

procedure TKOLMenuItem.SetbitmapItem(const Value: TBitmap);
begin
  FbitmapItem := Value;
  Change;
end;

procedure TKOLMenuItem.Setdefault(const Value: Boolean);
begin
  if Fdefault = Value then Exit;
  Fdefault := Value;
  Change;
end;

procedure TKOLMenuItem.SetRadioGroup(const Value: Integer);
begin
  if FRadioGroup = Value then Exit;
  FRadioGroup := Value;
  Change;
end;

procedure TKOLMenuItem.SetownerDraw(const Value: Boolean);
begin
  if FownerDraw = Value then Exit;
  FownerDraw := Value;
  Change;
end;

procedure TKOLMenuItem.LoadOwnerDraw(R: TReader);
begin
  FownerDraw := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveOwnerDraw(W: TWriter);
begin
  W.WriteBoolean( FownerDraw );
end;

procedure TKOLMenuItem.SetMenuBreak(const Value: TMenuBreak);
begin
  if FMenuBreak = Value then Exit;
  FMenuBreak := Value;
  Change;
end;

procedure TKOLMenuItem.LoadMenuBreak(R: TReader);
begin
  FmenuBreak := TMenuBreak( R.ReadInteger );
end;

procedure TKOLMenuItem.SaveMenuBreak(W: TWriter);
begin
  W.WriteInteger( Integer( FmenuBreak ) );
end;

procedure TKOLMenuItem.SetTag(const Value: Integer);
begin
  if Ftag = Value then Exit;
  FTag := Value;
  Change;
end;

procedure TKOLMenuItem.LoadTag(R: TReader);
begin
  FTag := R.ReadInteger;
end;

procedure TKOLMenuItem.SaveTag(W: TWriter);
begin
  W.WriteInteger( FTag );
end;

procedure TKOLMenuItem.LoadDefault(R: TReader);
begin
  Default := R.ReadBoolean;
end;

procedure TKOLMenuItem.SaveDefault(W: TWriter);
begin
  W.WriteBoolean( Default );
end;

procedure TKOLMenuItem.Setaction(const Value: TKOLAction);
begin
  if Faction = Value then exit;
  if Faction <> nil then
    Faction.UnLinkComponent(Self);
  Faction := Value;
  if Faction <> nil then
    Faction.LinkComponent(Self);
  Change;
end;

procedure TKOLMenuItem.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent = Faction then begin
      Faction.UnLinkComponent(Self);
      Faction := nil;
    end;
end;

procedure TKOLMenuItem.LoadAction(R: TReader);
begin
//  FActionComponentName:=R.ReadString;
end;

procedure TKOLMenuItem.SaveAction(W: TWriter);
begin
{
  if Faction <> nil then
    W.WriteString(Faction.GetNamePath)
  else
    W.WriteString('');
}
end;

function TKOLMenuItem.P_SetupTemplate(SL: TStringList; DoAdd: Boolean): Integer;
    procedure Add2SL( const S: String );
    begin
      if DoAdd then SL.Add( S );
      // иначе только посчитать число строк, но не добавлять - на первом просмотре
    end;
var S, U: String;
    I: Integer;
    MI: TKOLMenuItem;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.P_SetupTemplate', 0
  @@e_signature:
  end;
  if Separator then
    S := '-'
  else
  begin
    U := Caption;
    if (U = '') or (Faction <> nil) then
      U := ' ';
    S := '';
    if FradioGroup <> 0 then
    begin
      S := '!' + S;
      if (FParent <> nil) and (FParent is TKOLMenuItem) then
      begin
        I := (FParent as TKOLMenuItem).FSubitems.IndexOf( Self );
        if I > 0 then
        begin
          MI := (FParent as TKOLMenuItem).FSubItems[ I - 1 ];
          if (MI.FradioGroup <> 0) and (MI.FradioGroup <> FradioGroup) then
            S := '!' + S;
        end;
      end;
      if not Checked then
        S := '-' + S;
    end;
    if Checked and (Faction = nil) then
      S := '+' + S;
  end;
  if Accelerator.Key <> vkNotPresent then
  if MenuComponent.showshortcuts and (Faction = nil) then
    U := U + #9 + Accelerator.AsText;
  if S = '' then
  begin
    //if Faction = nil then
      S := //P_PCharStringConstant( MenuComponent, Name, U )
           P_String2Pascal( U )
    //else
      //S := '''' + U + ''''
    ;
    //Rpt( 'string item:' + S, RED );
  end
  else
  begin
    //S := '''' + S + ''' + ';
    //U := MenuComponent.P_StringConstant( Name, U );
    //if (U <> '') and (U[ 1 ] <> '''') then
      //S := 'PChar( ' + S + U + ')'
      S := P_String2Pascal( S + U );
    //else
    //  S := S + U;
  end;
  {if not FirstItem then
    S := ', ' + S;}
  if Count > 0 then
  begin
    Result := 3;
    Add2SL( ''')'' #0' );
    for I := Count - 1 downto 0 do
    begin
      MI := FSubItems[ I ];
      Result := Result + MI.P_SetupTemplate( SL, DoAdd );
    end;
    Add2SL( '''('' #0' );
  end
    else Result := 1;
  Add2SL( S );
end;

procedure TKOLMenuItem.P_SetupAttributes(SL: TStringList;
  const MenuName: String);
  procedure CallAssignEvents( const EventProcName: String );
  begin
    {P}SL.Add( ' LoadSELF Load4 ####T' + EventProcName );
    {P}SL.Add( ' LoadStack L(0) xySwap L(' + IntToStr( ItemIndex ) + ')' );
    {P}SL.Add( ' C5 TMenu_.AssignEvents<3> DEL DEL' );
  end;
//const Breaks: array[ TMenuBreak ] of String = ( 'mbrNone', 'mbrBreak', 'mbrBarBreak' );
var I: Integer;
    SI: TKOLMenuItem;
    RsrcName: String;
    F: TForm;
    FD: IFormDesigner;
    Flg: DWORD;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuItem.P_SetupAttributes', 0
  @@e_signature:
  end;
  if not Enabled and (Faction = nil) then
    //SL.Add( '    ' + MenuName + '.ItemEnabled[ ' + IntToStr( ItemIndex ) + ' ] := False;' );
    {P}SL.Add( ' L(0) L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.SetItemEnabled<3>'  );
  if not Visible and (Faction = nil) then
    //SL.Add( '    ' + MenuName + '.ItemVisible[ ' + IntToStr( ItemIndex ) + ' ] := False;' );
    {P}SL.Add( ' L(0) L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.SetItemVisible<3>' );
  if (HelpContext <> 0) and (Faction = nil) then
    //SL.Add( '    ' + MenuName + '.ItemHelpContext[ ' + IntToStr( ItemIndex ) + ' ] := ' +
    //        IntToStr( HelpContext ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( HelpContext ) + ') L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.SetItemHelpContext<3>' );
  if (Bitmap <> nil) and (Bitmap.Width <> 0) and (Bitmap.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMP';
    //SL.Add( '    ' + MenuName + '.ItemBitmap[ ' + IntToStr( ItemIndex ) +
    //        ' ] := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
    //        MenuName + ' );' );
    {P}SL.Add( ' DUP LoadStr ''' + UpperCase( RsrcName + '_BITMAP' ) + ''' #0' );
    {P}SL.Add( ' LoadHInstance' +
               ' LoadBmp<3> RESULT ' +
               ' L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.SetItemBitmap<3>' );
    SL.Add( '    {$R ' + RsrcName + '.res}' ); //todo: в П-компиляторе перенести все
    // такие строки в компилируемую часть кода!!!!!!
    GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName + '_BITMAP' ), RsrcName,
        MenuComponent.fUpdated, AllowBitmapCompression );
  end;
  if (BitmapChecked <> nil) and (bitmapChecked.Width <> 0) and (bitmapChecked.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMPCHECKED';
    //SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
    //        ' ].BitmapChecked := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
    //        MenuName + ' );' );
    {P}SL.Add( ' DUP LoadStr ''' + UpperCase( RsrcName + '_BITMAP' ) + ''' #0' );
    {P}SL.Add( ' LoadHInstance ' +
               ' LoadBmp<3> RESULT' +
               ' L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' TMenu_.SetbitmapChecked<2>' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( bitmapChecked, UPPERCASE( RsrcName ), RsrcName,
        MenuComponent.fUpdated, AllowBitmapCompression );
  end;
  if (BitmapItem <> nil) and (bitmapItem.Width <> 0) and (bitmapItem.Height <> 0) then
  begin
    RsrcName := MenuComponent.ParentForm.Name + '_' + Name + '_BMPITEM';
    //SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
    //        ' ].BitmapChecked := LoadBmp( hInstance, ''' + UpperCase( RsrcName + '_BITMAP' ) + ''', ' +
    //        MenuName + ' );' );
    {P}SL.Add( ' DUP LoadStr ''' + UpperCase( RsrcName + '_BITMAP' ) + ''' #0' );
    {P}SL.Add( ' LoadHInstance ' +
               ' LoadBmp<3> RESULT' +
               ' L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' TMenu_.SetbitmapItem<2>' );
    SL.Add( '    {$R ' + RsrcName + '.res}' );
    GenerateBitmapResource( bitmapItem, UPPERCASE( RsrcName ), RsrcName,
        MenuComponent.fUpdated, AllowBitmapCompression );
  end;
  (**************** -> P_SetupAttributesLast
  if FownerDraw then
    //SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
    //        ' ].OwnerDraw := TRUE;' );
    {P}SL.Add( ' L(1) L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' TMenu_.SetownerDraw<2>' ); *****************)
  if Fdefault then
    //SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
    //        ' ].DefaultItem := TRUE;' );
    {P}SL.Add( ' L(1) L(' + IntToStr( MFS_DEFAULT ) + ')' +
               ' L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' TMenu_.SetItemState<3>' );
  if FmenuBreak <> mbrNone then
    //SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
    //        ' ].MenuBreak := ' + Breaks[ FmenuBreak ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( FmenuBreak ) ) + ')' +
               ' L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' TMenu_.SetMenuBreak<2>' );
  if FOnMenuMethodName <> '' then
  begin
    F := MenuComponent.ParentForm;
//////////////////////////////////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                                          //
    if (F <> nil) and (F.Designer <> nil) then                                  //
    begin                                                                       //
    F.Designer.QueryInterface( IDesigner, FD );                                 //
    if FD <>nil then                                                            //
    //if F.Designer.QueryInterface( IFormDesigner, FD ) = 0 then                //
    if FD.MethodExists( FOnMenuMethodName ) then
      CallAssignEvents( MenuComponent.ParentKOLForm.FormName + '.' + FOnMenuMethodName );
      //SL.Add( '    ' + MenuName + '.AssignEvents( ' + IntToStr( ItemIndex ) +   //
      //        ', [ Result.' + FOnMenuMethodName + ' ] );' );                    //
    end;                                                                        //
  {$ELSE}                                                                       //
//////////////////////////////////////////////////////////////////////////////////
    if (F <> nil) and (F.Designer <> nil) then
    if QueryFormDesigner( F.Designer, FD ) then
    //if F.Designer.QueryInterface( IFormDesigner, FD ) = 0 then
    if FD.MethodExists( FOnMenuMethodName ) then
      CallAssignEvents( MenuComponent.ParentKOLForm.FormName + '.' + FOnMenuMethodName );
      //SL.Add( '    ' + MenuName + '.AssignEvents( ' + IntToStr( ItemIndex ) +
      //        ', [ Result.' + FOnMenuMethodName + ' ] );' );
//////////////////////////////////////////////////////////////////////////////////
  {$ENDIF}                                                                      //
//////////////////////////////////////////////////////////////////////////////////
  end;
  if (Accelerator.Key <> vkNotPresent) and (Faction = nil) then
  begin
    Flg := FVIRTKEY;
    if kapShift    in Accelerator.Prefix then Flg := Flg or FSHIFT;
    if kapControl  in Accelerator.Prefix then Flg := Flg or FCONTROL;
    if kapAlt      in Accelerator.Prefix then Flg := Flg or FALT;
    if kapNoinvert in Accelerator.Prefix then Flg := Flg or FNOINVERT;
    //SL.Add( '    ' + MenuName + '.ItemAccelerator[ ' + IntToStr( ItemIndex ) +
    //        ' ] := MakeAccelerator( ' + S + ', ' + VirtKeys[ Accelerator.Key ] +
    //        ' );' );
    {P}SL.Add( ' L(' + IntToStr( VrtKeyVals[ Accelerator.Key ] ) + ') L(' + IntToStr( Flg ) + ')' +
               ' MakeAccelerator<2> RESULT' +
               ' L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.SetItemAccelerator<3>' );
  end;
  if Tag <> 0 then
    //SL.Add( '    ' + MenuName + '.Items[' + IntToStr( ItemIndex ) +
    //        '].Tag := DWORD(' + IntToStr( Tag ) + ');' );
    {P}SL.Add( ' L(' + IntToStr( Tag ) + ') L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' AddByte_Store #TObj_.FTag' );
  for I := 0 to Count - 1 do
  begin
    SI := FSubItems[ I ];
    SI.P_SetupAttributes( SL, MenuName );
  end;
end;

function TKOLMenuItem.CheckOnMenuMethodExists: Boolean;
var F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    EvntName: String;
begin
  RptDetailed( '-> CheckOnMenuMethodExists for ' + Name, BLUE );
  Result := FALSE;
  TRY
    EvntName := FOnMenuMethodName;
    if (EvntName = 'nil') then Exit;
    RptDetailed( 'EvntName = ' + EvntName, BLUE );
    F := MenuComponent.ParentForm;
    if F = nil then Exit;
    RptDetailed( 'ParentForm obtained OK', BLUE );
  //*///////////////////////////////////////////////////////
    {$IFDEF _D6orHigher}                                  //
          F.Designer.QueryInterface(IFormDesigner,D);     //
    {$ELSE}                                               //
  //*///////////////////////////////////////////////////////
          D := F.Designer;
  //*///////////////////////////////////////////////////////
    {$ENDIF}                                              //
  //*///////////////////////////////////////////////////////
    if D = nil then Exit;
    RptDetailed( 'Designer for form obtained OK', BLUE );
    if not QueryFormDesigner( D, FD ) then Exit;
    //if D.QueryInterface( IFormDesigner, FD ) <> 0 then Exit;
    if not FD.MethodExists(EvntName) then
      EvntName := MenuComponent.ParentKOLForm.Name + Name + 'Menu';
    RptDetailed( 'EvntName = ' + EvntName, BLUE );
    if FD.MethodExists( EvntName ) then
    begin
      //RptDetailed( 'Method ' + EvntName +
      //  ' exists: generate AssignEvents', RED );
      FOnMenuMethodName := EvntName;
      Result := TRUE;
    end
      else
    begin
      RptDetailed( 'Method ' + EvntName + ' not exists', BLUE );
    end;
  FINALLY
    if not Result then
      FOnMenuMethodName := '';
  END;
end;

procedure TKOLMenuItem.SetupAttributesLast(SL: TStringList;
  const MenuName: String);
begin
  if FownerDraw then
    SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
            ' ].OwnerDraw := TRUE;' );
end;

procedure TKOLMenuItem.P_SetupAttributesLast(SL: TStringList;
  const MenuName: String);
begin
  if FownerDraw then
    //SL.Add( '    ' + MenuName + '.Items[ ' + IntToStr( ItemIndex ) +
    //        ' ].OwnerDraw := TRUE;' );
    {P}SL.Add( ' L(1) L(' + IntToStr( ItemIndex ) + ')' +
               ' C2 TMenu_.GetItems<2> RESULT' +
               ' TMenu_.SetownerDraw<2>' );
end;

procedure TKOLMenuItem.SetAllowBitmapCompression(const Value: Boolean);
begin
  if  FAllowBitmapCompression = Value then Exit;
  FAllowBitmapCompression := Value;
  Change;
end;

{ TKOLMenuEditor }

procedure TKOLMenuEditor.Edit;
var M: TKOLMenu;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.Edit', 0
  @@e_signature:
  end;
  if Component = nil then Exit;
  if not(Component is TKOLMenu) then Exit;
  M := Component as TKOLMenu;
  if M.ActiveDesign <> nil then
  begin
    M.ActiveDesign.MenuComponent := M;
    //M.ActiveDesign.Designer := Designer;
    M.ActiveDesign.Visible := True;
    SetForegroundWindow( M.ActiveDesign.Handle );
    M.ActiveDesign.MakeActive;
  end
     else
  begin
    M.ActiveDesign := TKOLMenuDesign.Create( Application );
    S := M.Name;
    if M.ParentKOLForm <> nil then
      S := M.ParentKOLForm.FormName + '.' + S;
    M.ActiveDesign.Caption := S;
    M.ActiveDesign.MenuComponent := M;
  end;
  if M.ParentForm <> nil then
    M.ParentForm.Invalidate;
end;

procedure TKOLMenuEditor.ExecuteVerb(Index: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.ExecuteVerb', 0
  @@e_signature:
  end;
  Edit;
end;

function TKOLMenuEditor.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.GetVerb', 0
  @@e_signature:
  end;
  Result := '&Edit menu';
end;

function TKOLMenuEditor.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMenuEditor.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 1;
end;

{ TKOLMainMenu }

procedure TKOLMainMenu.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Change', 0
  @@e_signature:
  end;
  inherited;
  RebuildMenubar;
end;

constructor TKOLMainMenu.Create(AOwner: TComponent);
var F: TForm;
    I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Create', 0
  @@e_signature:
  end;
  inherited;
  F := ParentForm;
  if F = nil then Exit;
  for I := 0 to F.ComponentCount - 1 do
  begin
    C := F.Components[ I ];
    if C = Self then continue;
    if C is TKOLMainMenu then
    begin
      ShowMessage(  'Another TKOLMainMenu component is already found on form ' +
                    F.Name + ' ( ' + C.Name + ' ). ' +
                    'Remember, please, that only one instance of TKOLMainMenu ' +
                    'should be placed on a form. Otherwise, code will be ' +
                    'generated only for one of those.' );
      Exit;
    end;
  end;
end;

var CommonOldWndProc: Pointer;
function WndProcDesignMenu( Wnd: HWnd; uMsg: DWORD; wParam, lParam: Integer ): Integer;
         stdcall;
var Id: Integer;
    M: HMenu;
    MII: TMenuItemInfo;
    KMI: TKOLMenuItem;
    C: TControl;
    F: TForm;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'WndProcDesignMenu', 0
  @@e_signature:
  end;
  if (uMsg = WM_COMMAND)  then
  begin
    if (lParam = 0) and (HIWORD( wParam ) <= 1) then
    begin
      Id := LoWord( wParam );
      M := GetMenu( Wnd );
      if M <> 0 then
      begin
        Fillchar( MII, 44, 0 );
        MII.cbsize := 44;
        MII.fMask := MIIM_DATA;
        if GetMenuItemInfo( M, Id, False, MII ) then
        begin
          KMI := Pointer( MII.dwItemData );
          if KMI <> nil then
          begin
            try
              if KMI is TKOLMenuItem then
              begin
                //Rpt( 'Click on ' + KMI.Caption );
                KMI.DesignTimeClick;
                Result := 0;
                Exit;
              end;
            except
              on E: Exception do
              begin
                ShowMessage( 'Design-time click failed, exception: ' + E.Message );
              end;
            end;
          end;
        end;
      end;
    end;
  end
    else
  if (uMsg = WM_DESTROY) then
  begin
    M := GetMenu( Wnd );
    SetMenu( Wnd, 0 );
    if M <> 0 then
    begin
      C := FindControl( Wnd );
      if (C <> nil) and (C is TForm) then
      begin
        F := C as TForm;
        for I := 0 to F.ComponentCount-1 do
          if F.Components[ I ] is TKOLMainMenu then
          begin
            DestroyMenu( M );
            (F.Components[ I ] as TKOLMainMenu).RestoreWndProc( Wnd );
            break;
          end;
      end
        else
      DestroyMenu( M );
    end;
  end;
  Result := CallWindowProc( CommonOldWndProc, Wnd, uMsg, wParam, lParam );
end;

destructor TKOLMainMenu.Destroy;
var F: TForm;
    KF: TKOLForm;
    M: HMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Destroy', 0
  @@e_signature:
  end;
  F := ParentForm;
  KF := nil;
  if F <> nil then
  begin
    KF := ParentKOLForm;
  end;
  if F <> nil then
  begin
    M := 0;
    if F.HandleAllocated then
    if F.Handle <> 0 then
    begin
      M := GetMenu( F.Handle );
      RestoreWndProc( F.Handle );
      SetMenu( F.Handle, 0 );
    end;
    if M <> 0 then
      DestroyMenu( M );
  end;
  inherited;
  if KF <> nil then
    KF.AlignChildren( nil, FALSE );
end;

procedure TKOLMainMenu.Loaded;
//var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.Loaded', 0
  @@e_signature:
  end;
  inherited;
  {KF := ParentKOLForm;
  if KF <> nil then
  begin
    KF.AllowRealign := TRUE;
    if not (csLoading in KF.ComponentState) then
      KF.AlignChildren( nil );
  end;}
  //UpdateDesign;
  RebuildMenubar;
end;

procedure TKOLMainMenu.RebuildMenubar;
var F: TForm;
    M: HMenu;
    KMI: TKOLMenuItem;
    I: Integer;

    procedure BuildMenuItem( ParentMenu: HMenu; KMI: TKOLMenuItem );
    var MII: TMenuItemInfo;
        S: String;
        J: Integer;
    begin
      asm
        jmp @@e_signature
        DB '#$signature$#', 0
        DB 'TKOLMainMenu.RebuildMenubar.BuildMenuItem', 0
      @@e_signature:
      end;
      FillChar( MII, 44, 0 );

      if KMI.Separator then
        S := '-'
      else
      begin
        S := KMI.Caption;
        if S = '' then S := ' ';
        if showshortcuts and (KMI.Accelerator.Key <> vkNotPresent) then
          S := S + #9 + KMI.Accelerator.AsText;
      end;

      MII.cbSize := 44;
      MII.fMask := MIIM_DATA or MIIM_ID or MIIM_STATE or MIIM_SUBMENU or MIIM_TYPE
                   or MIIM_CHECKMARKS;
      MII.dwItemData := Integer(KMI);
      if KMI.Separator then
      begin
        MII.fType := MFT_SEPARATOR;
        MII.fState := MFS_GRAYED;
      end
        else
      begin
        MII.fType := MFT_STRING;
        MII.dwTypeData := PChar( S );
        MII.cch := StrLen( PAnsiChar( AnsiString(S) ) ); // TODO: KOL_ANSI
        if KMI.FradioGroup <> 0 then
        begin
          MII.fType := MII.fType or MFT_RADIOCHECK;
          //MII.dwItemData := MII.dwItemData or MIDATA_RADIOITEM;
        end;
        if KMI.Checked then
        begin
          //if not KMI.RadioItem then
          //  MII.dwItemData := MII.dwItemData or MIDATA_CHECKITEM;
          MII.fState := MII.fState or MFS_CHECKED;
        end;
        if not KMI.Enabled then
          MII.fState := MFS_GRAYED;
        if (KMI.Bitmap <> nil) and (KMI.Bitmap.Width * KMI.Bitmap.Height > 0) then
          MII.hBmpUnchecked := KMI.Bitmap.Handle;
        MII.wID := 100 + KMI.itemIndex;
        if KMI.Count > 0 then
        begin
          MII.hSubmenu := CreatePopupMenu;
          for J := 0 to KMI.Count - 1 do
            BuildMenuItem( MII.hSubMenu, KMI.FSubItems[ J ] );
        end;
      end;
      InsertMenuItem( ParentMenu, Cardinal(-1), True, MII );
    end;

var oldM: HMenu;
    oldWndProc: Pointer;
    KF: TKOLForm;
var bott: Integer;
    C: TComponent;
    K: TKOLCustomControl;
    ListAnchoredBottomControls: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.RebuildMenubar', 0
  @@e_signature:
  end;
  if (csDestroying in ComponentState) then Exit;
  if FUpdateDisabled then
  begin
    FUpdateNeeded := TRUE;
    Exit;
  end;
  ListAnchoredBottomControls := nil;
  if (Owner <> nil) and (Owner is TForm) then
  begin
    for i := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      C := (Owner as TForm).Components[ i ];
      if C is TKOLCustomControl then
      begin
        K := C as TKOLCustomControl;
        if K.FAnchorBottom and (K.Parent = Owner) then
        begin
          if ListAnchoredBottomControls = nil then
            ListAnchoredBottomControls := TList.Create;
          ListAnchoredBottomControls.Add( K );
          ListAnchoredBottomControls.Add( Pointer( K.Top + K.Height ) );
        end;
      end;
    end;
  end;
  TRY

    F := ParentForm;
    if F = nil then Exit;
    oldM := GetMenu( F.Handle );
    F.Menu := nil;

    M := CreateMenu;
    for I := 0 to Count - 1 do
    begin
      KMI := FItems[ I ];
      BuildMenuItem( M, KMI );
    end;
    //F.Menu := M;
    SetMenu( F.Handle, M );
    if oldM <> 0 then
      DestroyMenu( oldM );
    Integer(oldWndProc) := GetWindowLong( F.Handle, GWL_WNDPROC );
    if oldWndProc <> @WndProcDesignMenu then
    begin
      Rpt( 'Reset WndProc (old: ' + IntToStr( Integer(oldWndProc) ) + ' )',
        WHITE );
      CommonOldWndProc := oldWndProc;
      FoldWndProc := oldWndProc;
      SetWindowLong( F.Handle, GWL_WNDPROC, Integer( @WndProcDesignMenu ) );
    end;

  FINALLY
    KF := ParentKOLForm;
    if KF <> nil then
    begin
      KF.AllowRealign := TRUE;
      if not (csLoading in KF.ComponentState) then
        KF.AlignChildren( nil, FALSE );
    end;
    if ListAnchoredBottomControls <> nil then
    begin
      for i := 0 to ListAnchoredBottomControls.Count-2 do
      if i mod 2 = 0 then
      begin
        K := ListAnchoredBottomControls[ i ];
        bott := Integer( ListAnchoredBottomControls[ i+1 ] );
        TRY
          if K.FAnchorTop then
            K.Height := bott - K.Top
          else
            K.Top := bott - K.Height;
        EXCEPT
        END;
      end;
      ListAnchoredBottomControls.Free;
      //ListAnchoredBottomControls := nil;
    end;
  END;
end;

procedure TKOLMainMenu.RestoreWndProc( Wnd: HWnd );
var CurwndProc: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.RestoreWndProc', 0
  @@e_signature:
  end;
  Integer(CurWndProc) := GetWindowLong( Wnd, GWL_WNDPROC );
  if CurWndProc = @WndProcDesignMenu then
  begin
    SetWindowLong( Wnd, GWL_WNDPROC, Integer( CommonOldWndProc ) );
  end;
end;

procedure TKOLMainMenu.UpdateMenu;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMainMenu.UpdateMenu', 0
  @@e_signature:
  end;
  inherited;
  RebuildMenubar;
end;

{ TKOLPopupMenu }

procedure TKOLPopupMenu.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPopupMenu.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnPopup' ],
                             [ @ OnPopup ] );
end;

function TKOLPopupMenu.P_AssignEvents(SL: TStringList; const AName: String;
  CheckOnly: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPopupMenu.P_AssignEvents', 0
  @@e_signature:
  end;
  Result := TRUE;

  if P_DoAssignEvents( SL, AName, [ 'OnPopup' ],
                             [ @ OnPopup ], [ FALSE ],
  CheckOnly ) and CheckOnly then Exit;
  Result := FALSE;

end;

procedure TKOLPopupMenu.P_DoProvideFakeType(SL: TStringList);
begin
  // prevent adding: TPopupMenu = object( KOL.TPopupMenu ) end;
  P_ProvideFakeType( SL, 'type TPopupMenu_ = object(KOL.TMenu) end;' );
end;

procedure TKOLPopupMenu.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var Flg: DWORD;
begin
  inherited;
  if Count = 0 then Exit;  {+ecm}
  if Flags <> [ ] then
  begin
    Flg := 0;
    if tpmVertical     in Flags then Flg := TPM_VERTICAL;
    if tpmRightButton  in Flags then Flg := Flg or TPM_RIGHTBUTTON;
    if tpmCenterAlign  in Flags then Flg := Flg or TPM_CENTERALIGN;
    if tpmRightAlign   in Flags then Flg := Flg or TPM_RIGHTALIGN;
    if tpmVCenterAlign in Flags then Flg := Flg or TPM_VCENTERALIGN;
    if tpmBottomAlign  in Flags then Flg := Flg or TPM_BOTTOMALIGN;
    if tpmHorPosAnimation in Flags then Flg := Flg or TPM_HORPOSANIMATION;
    if tpmHorNegAnimation in Flags then Flg := Flg or TPM_HORNEGANIMATION;
    if tpmVerPosAnimation in Flags then Flg := Flg or TPM_VERPOSANIMATION;
    if tpmVerNegAnimation in Flags then Flg := Flg or TPM_VERNEGANIMATION;
    if tpmNoAnimation in Flags then Flg := Flg or TPM_NOANIMATION;
    if tpmReturnCmd in Flags then Flg := Flg or TPM_RETURNCMD; {+ecm}
    {P}SL.Add( ' L(' + IntToStr( Flg ) + ') C1 AddByte_Store #TMenu_.FPopupFlags' );
  end;
end;

procedure TKOLPopupMenu.SetFlags(const Value: TPopupMenuFlags);
begin
  if FFlags = Value then Exit;
  FFlags := Value;
  Change;
end;

procedure TKOLPopupMenu.SetOnPopup(const Value: TOnEvent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPopupMenu.SetOnPopup', 0
  @@e_signature:
  end;
  if @ FOnPopup = @ Value then Exit;
  FOnPopup := Value;
  Change;
end;

procedure TKOLPopupMenu.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var S: String;
begin
  inherited;
  if Count = 0 then Exit;  {+ecm}
  if Flags <> [ ] then
  begin
    if tpmVertical     in Flags then S := S + 'TPM_VERTICAL or ';
    if tpmRightButton  in Flags then S := S + 'TPM_RIGHTBUTTON or ';
    if tpmCenterAlign  in Flags then S := S + 'TPM_CENTERALIGN or ';
    if tpmRightAlign   in Flags then S := S + 'TPM_RIGHTALIGN or ';
    if tpmVCenterAlign in Flags then S := S + 'TPM_VCENTERALIGN or ';
    if tpmBottomAlign  in Flags then S := S + 'TPM_BOTTOMALIGN or ';
    if tpmHorPosAnimation in Flags then S := S + 'TPM_HORPOSANIMATION or ';
    if tpmHorNegAnimation in Flags then S := S + 'TPM_HORNEGANIMATION or ';
    if tpmVerPosAnimation in Flags then S := S + 'TPM_VERPOSANIMATION or ';
    if tpmVerNegAnimation in Flags then S := S + 'TPM_VERNEGANIMATION or ';
    if tpmNoAnimation in Flags then S := S + 'TPM_NOANIMATION or ';
    if tpmReturnCmd in Flags then S := S + 'TPM_RETURNCMD or '; {+ecm}
    S := Copy(S,1,Length(S)-4);
    SL.Add( Prefix + AName + '.Flags := ' + S + ';' );
  end;
end;

{ TKOLOnItemPropEditor }

function TKOLOnItemPropEditor.GetValue: string;
var Comp: TPersistent;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnItemPropEditor.GetValue', 0
  @@e_signature:
  end;
  Result := inherited GetValue;
  if Result = '' then
  begin
    Comp := GetComponent( 0 );
    if Comp <> nil then
    if Comp is TKOLMenuItem then
    begin
      Result := (Comp as TKOLMenuItem).FOnMenuMethodName;
      {
      if Result <> '' then
      begin
        Rpt( 'inherited OnMenu=NULL, but name is ' + Result + ', trying to restore correct value' );
        SetValue( Result );
        Result := inherited GetValue;
        Rpt( '--------- OnMenu=' + Result );
      end;
      }
    end;
  end;
  TRY

  Comp := GetComponent( 0 );
  if (Comp <> nil) and
     (Comp is TKOLMenuItem) and
     ((Comp as TKOLMenuItem).MenuComponent <> nil) then
  begin
    F := ((Comp as TKOLMenuItem).MenuComponent as TKOLMenu).ParentForm;
    if (F = nil) or (F.Designer = nil) then
    begin
      Result := ''; Exit;
    end;
//*///////////////////////////////////////////////////////
  {$IFDEF _D6orHigher}                                  //
        F.Designer.QueryInterface(IFormDesigner,D);     //
  {$ELSE}                                               //
//*///////////////////////////////////////////////////////
        D := F.Designer;
//*///////////////////////////////////////////////////////
  {$ENDIF}                                              //
//*///////////////////////////////////////////////////////
    if QueryFormDesigner( D, FD ) then
    //if D.QueryInterface( IFormDesigner, FD ) = 0 then
    begin
      if not FD.MethodExists( Result ) then Result := '';
    end
      else Result := '';
  end
    else Result := '';

  EXCEPT
    on E: Exception do
    begin
      Rpt( 'Exception while retrieving property OnMenu of TKOLMenuItem', RED );
      ShowMessage( 'Could not retrieve TKOLMenuItem.OnMenu, exception: ' + E.Message );
    end;
  END;
end;

procedure TKOLOnItemPropEditor.SetValue(const AValue: string);
var Comp: TPersistent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLOnItemPropEditor.SetValue', 0
  @@e_signature:
  end;
  inherited;
  for I := 0 to PropCount - 1 do
  begin
    Comp := GetComponent( I );
    if Comp <> nil then
    if Comp is TKOLMenuItem then
    begin
      (Comp as TKOLMenuItem).FOnMenuMethodName := AValue;
      (Comp as TKOLMenuItem).Change;
    end;
  end;
end;

{ TKOLAccelerator }

function TKOLAccelerator.AsText: String;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.AsText', 0
  @@e_signature:
  end;
  Result:='';// {RA}
  if kapControl in Prefix then
    Result := 'Ctrl+';
  if kapAlt in Prefix then
    Result := Result + 'Alt+';
  if kapShift in Prefix then
    Result := Result + 'Shift+';
  {case Key of
  vkA..vkZ: S := AnsiChar(Ord(Key)-Ord(vkA)+Integer('A'));
  vk0..vk9: S := AnsiChar(Ord(Key)-Ord(vk0)+Integer('0'));
  vkF1..vkF24: S := 'F' + IntToStr( Ord(Key)-Ord(vkF1)+1 );
  vkDivide:   S := '/';
  vkMultiply: S := '*';
  vkSubtract: S := '-';
  vkAdd:      S := '+';
  vkNUM0..vkNUM9: S := 'Numpad' + IntToStr( Ord(Key)-Ord(vkNUM0) );
  vkNotPresent: S := '';
  else begin
         S := VirtKeys[ Key ];
         if Copy( S, 1, 3 ) = 'VK_' then
           S := CopyEnd( S, 4 );
       end;
  end;}
  S := VirtualKeyNames[Key]; // Maxim Pushkar
  if S = '' then Result := '' else Result := Result + S;
end;

procedure TKOLAccelerator.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.Change', 0
  @@e_signature:
  end;
  if FOwner is TKOLMenuItem then
    TKOLMenuItem(FOwner).Change
  else
  if FOwner is TKOLAction then
    TKOLAction(FOwner).Change;
end;

procedure TKOLAccelerator.SetKey(const Value: TVirtualKey);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.SetKey', 0
  @@e_signature:
  end;
  if FKey = Value then Exit;
  FKey := Value;
  Change;
end;

procedure TKOLAccelerator.SetPrefix(const Value: TKOLAccPrefix);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelerator.SetPrefix', 0
  @@e_signature:
  end;
  if FPrefix = Value then Exit;
  FPrefix := Value;
  Change;
end;

{ TKOLAccelearatorPropEditor }

procedure TKOLAcceleratorPropEditor.Edit;
var CAE: TKOLAccEdit;
    Comp: TPersistent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAccelearatorPropEditor.Edit', 0
  @@e_signature:
  end;
  Comp := Getcomponent( 0 );
  if Comp = nil then Exit;
  if not ( Comp is TKOLMenuItem ) and not ( Comp is TKOLAction ) then Exit;
  CAE := TKOLAccEdit.Create( Application );
  try
    if Comp is TKOLMenuItem then
      with TKOLMenuItem(Comp) do
        CAE.Caption := CAE.Caption + MenuComponent.Name + '.' + Name
    else
    if Comp is TKOLAction then
      with TKOLAction(Comp) do
        CAE.Caption := CAE.Caption + ActionList.Name + '.' + Name;
        
    CAE.edAcc.Text := GetValue;
    CAE.ShowModal;
    if CAE.ModalResult = mrOK then
      SetValue( CAE.edAcc.Text );
  finally
    CAE.Free;
  end;
end;

function TKOLAcceleratorPropEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAcceleratorPropEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paDialog {, pasubProperties} ];
end;

function TKOLAcceleratorPropEditor.GetValue: string;
var Comp: TPersistent;
    MA: TKOLAccelerator;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAcceleratorPropEditor.GetValue', 0
  @@e_signature:
  end;
  Comp := GetComponent( 0 );
  if Comp is TKOLMenuItem then
    MA := (Comp as TKOLMenuItem).Accelerator
  else
  if Comp is TKOLAction then
    MA := (Comp as TKOLAction).Accelerator
  else
    MA := nil;
  if MA <> nil then
    Result := MA.AsText
  else
    Result := '';
end;

procedure TKOLAcceleratorPropEditor.SetValue(const Value: string);
var Comp: TPersistent;
    MA: TKOLAccelerator;
    _Prefix: TKOLAccPrefix;
    _Key, K: TVirtualKey;
    S: String;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLAcceleratorPropEditor.SetValue', 0
  @@e_signature:
  end;
  Comp := GetComponent( 0 );
  if Comp is TKOLMenuItem then
    MA := (Comp as TKOLMenuItem).Accelerator
  else
  if Comp is TKOLAction then
    MA := (Comp as TKOLAction).Accelerator
  else
    MA := nil;
  if MA <> nil then
  begin
    _Prefix := [ ];
    _Key := vkNotPresent;
    S := Value;
    for I := Length( S ) downto 1 do
      if S[ I ] <= ' ' then
        S := Copy( S, 1, I - 1 ) + Copy( S, I + 1, Length( S ) - I );
    while S <> '' do
    begin
      if UPPERCASE(Copy( S, 1, 6 )) = 'SHIFT+' then
      begin
        S := Copy( S, 7, Length(S)-6 );
        _Prefix := _Prefix + [ kapShift ];
        continue;
      end;
      if UPPERCASE(Copy( S, 1, 5 )) = 'CTRL+' then
      begin
        S := Copy( S, 6, Length(S)-5 );
        _Prefix := _Prefix + [ kapControl ];
        continue;
      end;
      if UPPERCASE(Copy( S, 1, 4 )) = 'ALT+' then
      begin
        S := Copy( S, 5, Length(S)-4 );
        _Prefix := _Prefix + [ kapAlt ];
        continue;
      end;
      _Key := vkNotPresent;
      //---------------------- { Maxim Pushkar } ----------------------\
      {if Length( S ) = 1 then                                          |
      case S[ 1 ] of                                                    |
      'A'..'Z': _Key := TVirtualKey( Ord(S[1])-Ord('A')+Ord(vkA) );     |
      '0'..'9': _Key := TVirtualKey( Ord(S[1])-Ord('0')+Ord(vk0) );     |
      '-': _Key := vkSubtract;                                          |
      '+': _Key := vkAdd;                                               |
      '/': _Key := vkDivide;                                            |
      '*': _Key := vkMultiply;                                          |
      ',': _Key := vkDecimal;                                           |
      else _Key := vkNotPresent;                                        |
      end                                                               |
        else                                                            |
      if Length( S ) > 1 then                                           |
      begin                                                             |
        if (S[ 1 ] = 'F') and (Str2Int(CopyEnd(S,2)) <> 0) then         |
          _Key := TVirtualKey( Ord(vkF1) - 1 + Str2Int(CopyEnd(S,2) ) ) |
        else                                                            |
        begin                                                           |
          for K := Low(TVirtualKey) to High(TVirtualKey) do             |
            if 'VK_' + UPPERCASE(S) = UPPERCASE(VirtKeys[ K ]) then     |
            begin                                                       |
              _Key := K;                                                |
              break;                                                   /|
            end;                                                      //
        end;                                                         //
      end;}                                                         //
      //++++++++++++++++++++++ Maxim Pushkar ++++++++++++++++++++++//
      for K := Low(TVirtualKey) to High(TVirtualKey) do           //
        if UpperCase(S) = UpperCase(VirtualKeyNames[K]) then     //
          _Key := K;                                            //
      //-------------------------------------------------------//
      break;
    end;
    if _Key = vkNotPresent then
    begin
      MA.Key := _Key;
      MA.Prefix := [ ];
    end
      else
    begin
      MA.Key := _Key;
      MA.Prefix := _Prefix;
    end;
  end
    else
    Beep;
end;

{ TKOLBrush }

procedure TKOLBrush.Assign(Value: TPersistent);
var B: TKOLBrush;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBrush.Assign', 0
  @@e_signature:
  end;
  //inherited;
  if Value is TKOLBrush then
  begin
    B := Value as TKOLBrush;
    FColor := B.Color;
    FBrushStyle := B.BrushStyle;
    if B.FBitmap <> nil then
    begin
      if FBitmap = nil then
        FBitmap := TBitmap.Create;
      FBitmap.Assign( B.FBitmap )
    end
    else
    begin
      FBitmap.Free; FBitmap := nil;
    end;
    Change;
  end;
end;

procedure TKOLBrush.Change;
var Form: TCustomForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBrush.Change', 0
  @@e_signature:
  end;
  if fOwner = nil then Exit;
  if fChangingNow then Exit;
  try

    if fOwner is TKOLForm then
    begin
      (fOwner as TKOLForm).Change( fOwner );
      if (fOwner as TKOLForm).Owner <> nil then
      begin
        Form := (fOwner as TKOLForm).Owner as TCustomForm;
        Form.Invalidate;
      end;
    end
    else
    if (fOwner is TKOLCustomControl) then
    begin
{YS}
  {$IFDEF _KOLCtrlWrapper_}
      with (fOwner as TKOLCustomControl) do
        if Assigned(FKOLCtrl) then
          with FKOLCtrl^ do begin
            Brush.Color:=Self.Color;
            Brush.BrushStyle:=kol.TBrushStyle(BrushStyle);
//            Brush.BrushBitmap:=Bitmap.Handle;
          end;
  {$ENDIF}
{YS}
      (fOwner as TKOLCustomControl).Change;
      (fOwner as TKOLCustomControl).Invalidate;
     end
     else
       if (fOwner is TKOLObj) then
         (fOwner as TKOLObj).Change;

  finally
    fChangingNow := FALSE;
  end;
end;

constructor TKOLBrush.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
  FBitmap := TBitmap.Create;
  FColor := clBtnFace;
  FAllowBitmapCompression := TRUE;
end;

destructor TKOLBrush.Destroy;
begin
  FBitmap.Free;
  inherited;
end;

procedure TKOLBrush.GenerateCode(SL: TStrings; const AName: String);
const
  BrushStyles: array[ TBrushStyle ] of String = ( 'bsSolid', 'bsClear', 'bsHorizontal', 'bsVertical',
    'bsFDiagonal', 'bsBDiagonal', 'bsCross', 'bsDiagCross' );
var RsrcName: String;
    Updated: Boolean;
    KF: TKOLForm;
    i: Integer;
    C: DWORD;
begin
  if FOwner = nil then Exit;
  if FOwner is TKOLForm then
  begin
      KF := FOwner as TKOLForm;
      if Bitmap.Empty then
      begin
        case BrushStyle of
        bsSolid: if  KF.Color <> clBtnFace then
                     if  KF.FormCompact then
                     begin
                         KF.FormAddCtlCommand( 'Form', 'FormSetColor', '' );
                         C := KF.Color;
                         if  C and $FF000000 = $FF000000 then
                             C := C and $FFFFFF or $80000000;
                         C := (C shl 1) or (C shr 31);
                         RptDetailed( 'Prepare FormSetColor parameter, src color =$' +
                              Int2Hex( KF.Color, 2 ) + ', coded color =$' +
                              Int2Hex( C, 2 ), CYAN );
                         KF.FormAddNumParameter( C );
                     end
                     else
                     SL.Add( '    ' + AName + '.Color := TColor(' + Color2Str( KF.Color ) + ');' );
        else  if  KF.FormCompact then
              begin
                  KF.FormAddCtlCommand( 'Form', 'FormSetBrushStyle', '' );
                  KF.FormAddNumParameter( Integer( BrushStyle ) );
              end
              else
              SL.Add( '    ' + AName + '.Brush.BrushStyle := ' + BrushStyles[ BrushStyle ] + ';' );
        end;
      end
        else
      begin
        RsrcName := (FOwner as TKOLForm).Owner.Name + '_' +
                    (FOwner as TKOLForm).Name + '_BRUSH_BMP';
        GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName ), RsrcName, Updated,
            AllowBitmapCompression );
        if  KF.FormCompact then
        begin
            (SL as TFormStringList).OnAdd := nil;
            SL.Add( '    {$R ' + RsrcName + '.res}' );
            (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
            KF.FormAddCtlCommand( 'Form', 'FormSetBrushBitmap', '' );
            KF.FormAddStrParameter( UpperCase( RsrcName ) );
        end
          else
        begin
            SL.Add( '    {$R ' + RsrcName + '.res}' );
            SL.Add( '    ' + AName + '.Brush.BrushBitmap := ' +
                    'LoadBmp( hInstance, ''' + UpperCase( RsrcName )
                    + ''', Result );' );
        end;
      end;
  end
    else
  if FOwner is TKOLCustomControl then
  begin
    KF := (FOwner as TKOLCustomControl).ParentKOLForm;
    if Bitmap.Empty then
    begin
      case BrushStyle of
      bsSolid: if  not (FOwner as TKOLCustomControl).ParentColor then
                   if  (KF <> nil) and KF.FormCompact then
                   begin
                       KF.FormAddCtlCommand( (FOwner as TKOLCustomControl).Name, 'FormSetColor', '' );
                       i := (FOwner as TKOLCustomControl).Color;
                       C := i;
                       if  C and $FF000000 = $FF000000 then
                           C := C and $FFFFFF or $80000000;
                       C := (C shl 1) or (C shr 31);
                       RptDetailed( 'Prepare FormSetColor parameter, src color =$' +
                            Int2Hex( i, 2 ) + ', coded color =$' +
                            Int2Hex( C, 2 ), CYAN );
                       KF.FormAddNumParameter( C );
                   end
                   else
                   SL.Add( '    ' + AName + '.Color := TColor(' + Color2Str( (FOwner as TKOLCustomControl).Color ) + ');' );
      else  if  (KF <> nil) and KF.FormCompact then
            begin
                KF.FormAddCtlCommand( (FOwner as TKOLCustomControl).Name, 'FormSetBrushStyle', '' );
                KF.FormAddNumParameter( Integer( BrushStyle ) );
            end
            else
            SL.Add( '    ' + AName + '.Brush.BrushStyle := ' + BrushStyles[ BrushStyle ] + ';' );
      end;
    end
      else
    begin
      RsrcName := (FOwner as TKOLCustomControl).ParentForm.Name + '_' +
                  (FOwner as TKOLCustomControl).Name + '_BRUSH_BMP';
      GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName ), RsrcName, Updated,
                              AllowBitmapCompression );
      if  (KF <> nil) and KF.FormCompact then
      begin
          (SL as TFormStringList).OnAdd := nil;
          SL.Add( '    {$R ' + RsrcName + '.res}' );
          (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
          KF.FormAddCtlCommand( (FOwner as TKOLCustomControl).Name, 'FormSetBrushBitmap', '' );
          KF.FormAddStrParameter( UpperCase( RsrcName ) );
      end
        else
      begin
          SL.Add( '    {$R ' + RsrcName + '.res}' );
          SL.Add( '    ' + AName + '.Brush.BrushBitmap := LoadBmp( hInstance, ''' +
                  UpperCase( RsrcName ) + ''', Result );' );
      end;
    end;
  end;
end;

procedure TKOLBrush.P_GenerateCode(SL: TStrings; const AName: String);
const
  BrushStyles: array[ TBrushStyle ] of String = ( 'bsSolid', 'bsClear', 'bsHorizontal', 'bsVertical',
    'bsFDiagonal', 'bsBDiagonal', 'bsCross', 'bsDiagCross' );
var RsrcName: String;
    Updated: Boolean;
    BrushInStack: Boolean;
    procedure ProvideBrushInStack;
    begin
      if not BrushInStack then
      begin
        {P}SL.Add( ' DUP TControl.GetBrush<1> RESULT' );
        BrushInStack := TRUE;
      end;
    end;
begin
  if FOwner = nil then Exit;
  BrushInStack := FALSE;
  if FOwner is TKOLForm then
  begin
    if Bitmap.Empty then
    begin
      case BrushStyle of
      bsSolid: if (FOwner as TKOLForm).Color <> clBtnFace then
                 //SL.Add( '    ' + AName + '.Color := ' + Color2Str( (FOwner as TKOLForm).Color ) + ';' );
                 begin
                   {P}SL.Add( ' L($' +
                     Int2Hex( (FOwner as TKOLForm).Color, 6 ) + ')' );
                   {P}SL.Add( ' C1 TControl_.SetCtlColor<2>' );
                 end;
      else //SL.Add( '    ' + AName + '.Brush.BrushStyle := ' + BrushStyles[ BrushStyle ] + ';' );
           begin
             ProvideBrushInStack;
             {P}SL.Add( ' L(' + IntToStr( Integer( BrushStyle ) ) + ')' );
             {P}SL.Add( ' C1 TGraphTool_.SetBrushStyle<2>' );
           end;
      end;
    end
      else
    begin
      RsrcName := (FOwner as TKOLForm).Owner.Name + '_' +
                  (FOwner as TKOLForm).Name + '_BRUSH_BMP';
      SL.Add( '    {$R ' + RsrcName + '.res}' );
      //todo: (PCompiler) copy {$R ...} from Pcode to asm as is!
      GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName ), RsrcName, Updated,
                              AllowBitmapCompression );
      //SL.Add( '    ' + AName + '.Brush.BrushBitmap := LoadBmp( hInstance, ''' + UpperCase( RsrcName )
      //        + ''', Result );' );
      ProvideBrushInStack;
      {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( UpperCase( RsrcName ) ) );
      {P}SL.Add( ' C3 SWAP' );
      {P}SL.Add( ' Load_hInstance LoadBmp<3> RESULT' );
      {P}SL.Add( ' C2 TGraphTool.SetBrushBitmap<2>' );
      {P}SL.Add( ' DelAnsiStr' );
    end;
  end
    else
  if FOwner is TKOLCustomControl then
  begin
    if Bitmap.Empty then
    begin
      case BrushStyle of
      bsSolid: if not (FOwner as TKOLCustomControl).ParentColor then
                 //SL.Add( '    ' + AName + '.Color := ' + Color2Str( (FOwner as TKOLForm).Color ) + ';' );
                 begin
                   {P}SL.Add( ' L($' + Int2Hex( (FOwner as TKOLCustomControl).Color, 6 ) + ')' );
                   {P}SL.Add( ' C1 TControl_.SetCtlColor<2>' );
                 end
      else //SL.Add( '    ' + AName + '.Brush.BrushStyle := ' + BrushStyles[ BrushStyle ] + ';' );
           begin
             ProvideBrushInStack;
             {P}SL.Add( ' L(' + IntToStr( Integer( BrushStyle ) ) + ')' );
             {P}SL.Add( ' C1 TGraphTool_.SetBrushStyle<2>' );
           end;
      end;
    end
      else
    begin
      RsrcName := (FOwner as TKOLCustomControl).ParentForm.Name + '_' +
                  (FOwner as TKOLCustomControl).Name + '_BRUSH_BMP';
      SL.Add( '    {$R ' + RsrcName + '.res}' );
      GenerateBitmapResource( Bitmap, UPPERCASE( RsrcName ), RsrcName, Updated,
                              AllowBitmapCompression );
      //SL.Add( '    ' + AName + '.Brush.BrushBitmap := LoadBmp( hInstance, ''' + UpperCase( RsrcName )
      //        + ''', Result );' );
      {P}SL.Add( ' LoadAnsiStr ' + P_String2Pascal( UpperCase( RsrcName ) ) );
      {P}SL.Add( ' C3 SWAP' );
      {P}SL.Add( ' Load_hInstance LoadBmp<3> RESULT' );
      {P}SL.Add( ' C1 TGraphTool.SetBrushBitmap<2>' );
      {P}SL.Add( ' DelAnsiStr' );
    end;
  end;
  if BrushInStack then
    {P}SL.Add( ' DEL // Brush ' );
end;

procedure TKOLBrush.SetAllowBitmapCompression(const Value: Boolean);
begin
  if  FAllowBitmapCompression = Value then Exit;
  FAllowBitmapCompression := Value;
  Change;
end;

procedure TKOLBrush.SetBitmap(const Value: TBitmap);
begin
  FBitmap.Assign(Value);
  if FOwner <> nil then
    if FOwner is TKOLForm then
    begin
      {if (FOwner as TKOLForm).Owner <> nil then
        ((FOwner as TKOLForm).Owner as TCustomForm).Brush.Bitmap.Assign( Value );}
    end;
  Change;
end;

procedure TKOLBrush.SetBrushStyle(const Value: TBrushStyle);
begin
  if FBrushStyle = Value then Exit;
  FBrushStyle := Value;
  if FOwner <> nil then
    if FOwner is TKOLForm then
    begin
      if (FOwner as TKOLForm).Owner <> nil then
        ((Fowner as TKOLForm).Owner as TCustomForm).Brush.Style :=
        Graphics.TBrushStyle( Value );
    end;
  Change;
end;

procedure TKOLBrush.SetColor(const Value: TColor);
begin
  if FColor = Value then Exit;
  FColor := Value;
  if FOwner <> nil then
    if FOwner is TKOLForm then
      (FOwner as TKOLForm).Color := Value
    else
    if FOwner is TKOLCustomControl then
      (FOwner as TKOLCustomControl).Color := Value;
  Change;
end;

{ TKOLAction }

procedure TKOLAction.Assign(Source: TPersistent);
begin
  if Source is TKOLAction then
  begin
    FCaption := TKOLAction(Source).FCaption;
    FHint := TKOLAction(Source).FHint;
    FChecked := TKOLAction(Source).FChecked;
    FEnabled := TKOLAction(Source).FEnabled;
    FVisible := TKOLAction(Source).FVisible;
    FHelpContext := TKOLAction(Source).FHelpContext;
    FOnExecute := TKOLAction(Source).FOnExecute;

  end
  else
    inherited Assign(Source);
end;

constructor TKOLAction.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLinked:=TStringList.Create;
  FAccelerator:=TKOLAccelerator.Create;
  FAccelerator.FOwner:=Self;
  FVisible:=True;
  FEnabled:=True;
  NeedFree:=False;
end;

procedure TKOLAction.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty('Links', LoadLinks, SaveLinks, FLinked.Count > 0);
end;

destructor TKOLAction.Destroy;
begin
  inherited;
  if FActionList <> nil then
    FActionList.List.Remove(Self);
  FLinked.Free;
  FAccelerator.Free;
end;

function TKOLAction.GetIndex: Integer;
begin
  if ActionList <> nil then
    Result := ActionList.List.IndexOf(Self)
  else
    Result := -1;
end;

function TKOLAction.GetParentComponent: TComponent;
begin
  if FActionList <> nil then
    Result := FActionList
  else
    Result := inherited GetParentComponent;
end;

function TKOLAction.HasParent: Boolean;
begin
  if FActionList <> nil then
    Result := True
  else
    Result := inherited HasParent;
end;

procedure TKOLAction.LinkComponent(const AComponent: TComponent);
begin
  ResolveLinks;
  if (FLinked.IndexOfObject(AComponent) = -1) and
     (FLinked.IndexOf(GetComponentFullPath(AComponent)) = -1) then
  begin
    FLinked.AddObject('', AComponent);
    AComponent.FreeNotification(Self); // 1.87 +YS
    UpdateLinkedComponent(AComponent);
  end;
end;

procedure TKOLAction.Loaded;
begin
  inherited;
  ResolveLinks;
end;

procedure TKOLAction.LoadLinks(R: TReader);
begin
  R.ReadListBegin;
  while not R.EndOfList do
    FLinked.Add(R.ReadString);
  R.ReadListEnd;
end;

procedure TKOLAction.ReadState(Reader: TReader);
begin
  inherited ReadState(Reader);
  if Reader.Parent is TKOLActionList then begin
    ActionList := TKOLActionList(Reader.Parent);
  end;
end;

procedure TKOLAction.ResolveLinks;
var
  i: integer;
  s: string;
  c: TComponent;
begin
  for i:=0 to FLinked.Count - 1 do begin
    s:=FLinked[i];
    if s <> '' then begin
      c:=FindComponentByPath(s);
      if c <> nil then begin
        FLinked[i]:='';
        FLinked.Objects[i]:=c;
        if c is TKOLMenuItem then
          TKOLMenuItem(c).action:=Self
        else
        if c is TKOLCustomControl then
          TKOLCustomControl(c).action:=Self
        else
        if c is TKOLToolbarButton then
          TKOLToolbarButton(c).action:=Self;
        c.FreeNotification(Self); // v1.87 YS
        UpdateLinkedComponent(c);
      end;
    end;
  end;
end;

procedure TKOLAction.SaveLinks(W: TWriter);
var
  i: integer;
  s: string;
begin
  W.WriteListBegin;
  for i:=0 to FLinked.Count - 1 do begin
    s:=FLinked[i];
    if (s = '') and (FLinked.Objects[i] <> nil) then
      s:=GetComponentFullPath(TComponent(FLinked.Objects[i]));
    if s <> '' then
      W.WriteString(s);
  end;
  W.WriteListEnd;
end;

procedure TKOLAction.SetActionList(const Value: TKOLActionList);
begin
  if FActionList = Value then exit;
  FActionList := Value;
  if FActionList <> nil then
    FActionList.List.Add(Self);
end;

procedure TKOLAction.SetCaption(const Value: string);
begin
  if FCaption = Value then exit;
  FCaption := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetChecked(const Value: boolean);
begin
  if FChecked = Value then exit;
  FChecked := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetEnabled(const Value: boolean);
begin
  if Enabled = Value then exit;
  FEnabled := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetHelpContext(const Value: integer);
begin
  if FHelpContext = Value then exit;
  FHelpContext := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetHint(const Value: string);
begin
  if FHint = Value then exit;
  FHint := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.SetIndex(Value: Integer);
var
  CurIndex, Count: Integer;
begin
  CurIndex := GetIndex;
  if CurIndex >= 0 then
  begin
    Count := ActionList.FActions.Count;
    if Value < 0 then Value := 0;
    if Value >= Count then Value := Count - 1;
    if Value <> CurIndex then
    begin
      ActionList.FActions.Delete(CurIndex);
      ActionList.FActions.Insert(Value, Self);
    end;
  end;
end;

procedure TKOLAction.SetName(const NewName: TComponentName);
begin
  inherited;
  if Assigned(ActionList) and Assigned(ActionList.ActiveDesign) then
    ActionList.ActiveDesign.NameChanged(Self);
end;

procedure TKOLAction.SetOnExecute(const Value: TOnEvent);
begin
  if @FOnExecute = @Value then exit;
  FOnExecute := Value;
  Change;
end;

procedure TKOLAction.SetParentComponent(AParent: TComponent);
begin
  if not (csLoading in ComponentState) and (AParent is TKOLActionList) then
    ActionList := TKOLActionList(AParent);
end;

procedure TKOLAction.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  (*if Name <> '' then
  begin
    SL.Add( '   {$IFDEF USE_NAMES}' );
    SL.Add( Prefix + AName + '.Name := ''' + Name + ''';' );
    SL.Add( '   {$ENDIF}' );
  end;*)
end;

procedure TKOLAction.SetVisible(const Value: boolean);
begin
  if FVisible = Value then exit;
  FVisible := Value;
  UpdateLinkedComponents;
  Change;
end;

procedure TKOLAction.UnLinkComponent(const AComponent: TComponent);
var
  i: integer;
begin
  ResolveLinks;
  while True do begin
    i:=FLinked.IndexOfObject(AComponent);
    if i <> -1 then
      FLinked.Delete(i)
    else
      break;  
  end;
end;

function TKOLAction.FindComponentByPath(const Path: string): TComponent;
var
  i, j: integer;
  p, n: string;
begin
  p:=Path;
  Result:=nil;
  repeat
    i:=Pos('.', p);
    if i = 0 then
      i:=Length(p) + 1;
    n:=Copy(p, 1, i - 1);
    p:=Copy(p, i + 1, MaxInt);
    if Result = nil then begin
      for j:=0 to Screen.FormCount - 1 do
        if AnsiCompareText(Screen.Forms[j].Name, n) = 0 then begin
          Result:=Screen.Forms[j];
          break;
        end;
    end
    else
      Result:=Result.FindComponent(n);

//    if Result <> nil then
//      Rpt('Found: ' + Result.Name);
  until (p = '') or (Result = nil);
end;

function TKOLAction.GetComponentFullPath(AComponent: TComponent): string;
begin
  Result:='';
  while AComponent <> nil do begin
    if Result <> '' then
      Result:='.' + Result;
    Result:=AComponent.Name + Result;
    AComponent:=AComponent.Owner;
  end;
end;

procedure TKOLAction.UpdateLinkedComponents;
var
  i: integer;
begin
  for i:=0 to FLinked.Count - 1 do
    UpdateLinkedComponent(TComponent(FLinked.Objects[i]));
end;

procedure TKOLAction.UpdateLinkedComponent(AComponent: TComponent);
begin
  if AComponent is TKOLMenuItem then
    with TKOLMenuItem(AComponent) do begin
      if Self.FAccelerator.Key <> vkNotPresent then
        FCaption:=Self.FCaption + #9 + Self.FAccelerator.AsText
      else
        FCaption:=Self.FCaption;
      FVisible:=Self.FVisible;
      FEnabled:=Self.FEnabled;
      FChecked:=Self.FChecked;
      FHelpContext:=Self.FHelpContext;
      Change;
    end
  else
  if AComponent is TKOLCustomControl then begin
    with TKOLCustomControl(AComponent) do begin
      Caption:=Self.FCaption;
      Visible:=Self.FVisible;
      Enabled:=Self.FEnabled;
      HelpContext:=Self.FHelpContext;
      Change;
    end;
    if AComponent is TKOLCheckBox then
      with TKOLCheckBox(AComponent) do begin
        Checked:=Self.FChecked;
      end
    else
    if AComponent is TKOLRadioBox then
      with TKOLRadioBox(AComponent) do begin
        Checked:=Self.FChecked;
      end;
  end
  else
  if AComponent is TKOLToolbarButton then
    with TKOLToolbarButton(AComponent) do begin
      Caption:=Self.FCaption;
      Visible:=Self.FVisible;
      Enabled:=Self.FEnabled;
      Checked:=Self.FChecked;
      HelpContext:=Self.FHelpContext;
      tooltip:=Self.FHint;
      Change;
    end
  else
end;

procedure TKOLAction.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    UnLinkComponent(AComponent);
end;

procedure TKOLAction.SetAccelerator(const Value: TKOLAccelerator);
begin
  if (FAccelerator.Prefix = Value.Prefix) and (FAccelerator.Key = Value.Key) then exit;
  FAccelerator := Value;
  UpdateLinkedComponents;
  Change;
end;

function TKOLAction.AdditionalUnits: String;
begin
  Result := ', KOLadd';
end;

procedure TKOLAction.P_SetupName(SL: TStringList);
begin
  if ActionList.FP_NameSetuped then
    inherited;
end;

procedure TKOLAction.SetupName(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  RptDetailed( 'SetupName for ' + AName, YELLOW );
  if FNameSetuppingInParent then
  begin
    RptDetailed( 'SetupName for ' + AName + ': call inherited', YELLOW );
    inherited;
  end;
end;

{ TKOLActionList }

function TKOLActionList.AdditionalUnits: String;
begin
  Result := ', KOLadd';
end;

procedure TKOLActionList.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents(SL, AName, ['OnUpdateActions'], [@OnUpdateActions]);
end;

constructor TKOLActionList.Create(AOwner: TComponent);
begin
  inherited;
  FActions:=TList.Create;
end;

destructor TKOLActionList.Destroy;
begin
  ActiveDesign.Free;
  FActions.Free;
  inherited;
end;

procedure TKOLActionList.GetChildren(Proc: TGetChildProc {$IFDEF _D3orHigher} ; Root: TComponent {$ENDIF});
var
  I: Integer;
  Action: TKOLAction;
begin
  for I := 0 to FActions.Count - 1 do
  begin
    Action := FActions[I];
    {if Action.Owner = Root then }Proc(Action);
  end;
end;

function TKOLActionList.GetCount: integer;
begin
  Result:=FActions.Count;
end;

function TKOLActionList.GetKOLAction(Index: Integer): TKOLAction;
begin
  Result:=FActions[Index];
end;

procedure TKOLActionList.SetChildOrder(Component: TComponent;
  Order: Integer);
begin
  if FActions.IndexOf(Component) >= 0 then
    (Component as TKOLAction).Index := Order;
end;

procedure TKOLActionList.SetKOLAction(Index: Integer; const Value: TKOLAction);
begin
  TKOLAction(FActions[Index]).Assign(Value);
end;

procedure TKOLActionList.SetOnUpdateActions(const Value: TOnEvent);
begin
  if @FOnUpdateActions = @Value then exit;
  FOnUpdateActions:=Value;
  Change;
end;

procedure TKOLActionList.SetupFirst(SL: TStringList; const AName, AParent, Prefix: String);
begin
  SL.Add( Prefix + AName + ' := NewActionList( ' + AParent + ' );' );
  SetupName( SL, AName, AParent, Prefix );
  GenerateTag( SL, AName, Prefix );
end;

procedure TKOLActionList.SetupLast(SL: TStringList; const AName, AParent, Prefix: String);
var
  i, j: integer;
  s, ss, n, p, pf: string;
  c: TComponent;
begin
  SL.Add('');
  n:=Prefix + AName;
  p:=AName;
  i:=Pos('.', AName);
  if i <> 0 then
    pf:=Copy(AName, 1, i - 1)
  else
    pf:=AName;
  p:=Prefix + pf;

  for i:=0 to FActions.Count - 1 do
    //with Actions[i] do
    begin
      Actions[i].ResolveLinks;
      if @Actions[i].FOnExecute <> nil then
        s:=pf + '.' + ParentForm.MethodName(@Actions[i].FOnExecute)
      else
        s:='nil';

      ss:=Actions[i].Caption;
      //---------------------------------------- remove by YS 7 Aug 2004 -|
      //if Accelerator.Key <> vkNotPresent then                           |
      //  ss:=ss + #9 + Accelerator.AsText;                               |
      //------------------------------------------------------------------|
      SL.Add(Format('%s.%s := %s.Add( %s, %s, %s );',
                    [p, Actions[i].Name, AName, Actions[i].StringConstant('Caption', ss),
                     Actions[i].StringConstant('Hint', Actions[i].Hint), s]));
      SL.Add( '//---->' );
      Actions[i].FNameSetuppingInParent := TRUE;
      RptDetailed( 'Before calling SetupName for ' + Actions[i].Name, YELLOW );
      Actions[i].SetupName( SL, AName, AParent, Prefix );
      Actions[i].FNameSetuppingInParent := FALSE;
      SL.Add( '//<----' );

      for j:=0 to Actions[i].FLinked.Count - 1 do begin
        c:=TComponent(Actions[i].FLinked.Objects[j]);
        if c = nil then
          SL.Add(  Format('%s// WARNING: Linked component %s can not be found. ' +
                   'Possibly it is located at form that not currently loaded.',
                   [Prefix, Actions[i].FLinked[j]]))
        else
          if c is TKOLMenuItem then begin
            with TKOLMenuItem(c) do
              SL.Add( Format('%s.%s.LinkMenuItem( %s.%s, %d );',
                      [p, Actions[i].Name, pf, MenuComponent.Name, itemindex]))
          end
          else
          if c is TKOLCustomControl then
            with TKOLCustomControl(c) do
              SL.Add( Format('%s.%s.LinkControl( %s.%s );',
                      [p, Actions[i].Name, pf, Name]))
          else
          if c is TKOLToolbarButton then
            with TKOLToolbarButton(c) do
              SL.Add( Format('%s.%s.LinkToolbarButton( %s.%s, %d );',
                      [p, Actions[i].Name, pf, ToolbarComponent.Name,
                      ToolbarComponent.Items.IndexOf(c)]))
      end;

      if Actions[i].Checked then
        SL.Add( Format('%s.%s.Checked := True;',
                [p, Actions[i].Name]));
      if not Actions[i].Visible then
        SL.Add( Format('%s.%s.Visible := False;',
                [p, Actions[i].Name]));
      if not Actions[i].Enabled then
        SL.Add( Format('%s.%s.Enabled := False;',
                [p, Actions[i].Name]));
      if Actions[i].HelpContext <> 0 then
        SL.Add( Format('%s.%s.HelpContext := %d;',
                [p, Actions[i].Name, Actions[i].HelpContext]));
      if Actions[i].Tag <> 0 then
        SL.Add(Format('%s.%s.Tag := %d;', [p, Actions[i].Name,Actions[i].Tag]));

      if Actions[i].Accelerator.Key <> vkNotPresent then
      begin
        S := 'FVIRTKEY';
        if kapShift in Actions[i].Accelerator.Prefix then
          S := S + ' or FSHIFT';
        if kapControl in Actions[i].Accelerator.Prefix then
          S := S + ' or FCONTROL';
        if kapAlt in Actions[i].Accelerator.Prefix then
          S := S + ' or FALT';
        if kapNoinvert in Actions[i].Accelerator.Prefix then
          S := S + ' or FNOINVERT';
        SL.Add( Format('%s.%s.Accelerator := MakeAccelerator(%s, %s);',
                [p, Actions[i].Name, S, VirtKeys[ Actions[i].Accelerator.Key ]]));
      end;


      SL.Add('');
    end;
end;

{ TKOLActionListEditor }

procedure TKOLActionListEditor.Edit;
var AL: TKOLActionList;
begin
  if Component = nil then Exit;
  if not(Component is TKOLActionList) then Exit;
  AL := Component as TKOLActionList;
  if AL.ActiveDesign = nil then
    AL.ActiveDesign := TfmActionListEditor.Create( Application );
  AL.ActiveDesign.ActionList := AL;
  AL.ActiveDesign.Visible := True;
  SetForegroundWindow( AL.ActiveDesign.Handle );
  AL.ActiveDesign.MakeActive( TRUE );
{
  if AL.ParentForm <> nil then
    AL.ParentForm.Invalidate;
}
end;

procedure TKOLActionListEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TKOLActionListEditor.GetVerb(Index: Integer): string;
begin
  Result := '&Edit actions';
end;

function TKOLActionListEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TKOLControl }

procedure TKOLControl.Change;
begin
  //Log( '->TKOLControl.Change' );
  TRY
    inherited;
  //LogOK;
  FINALLY
    //Log( '<-TKOLControl.Change' );
  END;
end;

function TKOLControl.Generate_SetSize: String;
begin
  Result := inherited Generate_SetSize;
end;


{ TFormStringList }

function TFormStringList.Add(const s: String): Integer;
begin
  if  not FCallingOnAdd and Assigned( OnAdd ) then
  begin
      FCallingOnAdd := TRUE;
      OnAdd( Self );
      FCallingOnAdd := FALSE;
  end;
  Result := inherited Add(s);
end;

procedure TFormStringList.SetOnAdd(const Value: TNotifyEvent);
begin
  FOnAdd := Value;
end;

initialization
  Log( 'I n i t i a l i z a t i o n' );
  {$IFDEF DEBUG_MCK}
  mck_Log := Log;
  mck_Log( 'mck_Log assigned' );
  {$ENDIF}

finalization
  {$IFDEF MCKLOG}
    Log( '->F i n a l i z a t i o n' );
    FormsList.Free;
    FormsList := nil;
    LogOK;
    Log( '<-F i n a l i z a t i o n' );
    {$IFDEF MCKLOGBUFFERED}
      if (LogBuffer <> nil) and (LogBuffer.Count > 0) then
        LogFileOutput( 'C:\MCK.log', LogBuffer.Text );
      FreeAndNil( LogBuffer );
    {$ENDIF}
  {$ENDIF}

end.
