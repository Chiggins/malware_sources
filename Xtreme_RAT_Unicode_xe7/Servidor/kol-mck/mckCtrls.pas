{=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
                                                                 tt
        KKKKK    KKKKK    OOOOOOOOO    LLLLL         ccc         tt       rr  rr
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLL      ccc   ccc  ttttttttttt  rrrr
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL      ccc            tt       rr
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL      ccc            tt       rr
        KKKKKKKKKK      OOOOO   OOOOO  LLLLL      ccc   ccc      tt       rr
        KKKKK  KKKKK    OOOOO   OOOOO  LLLLL         ccc           ttt    rr
        KKKKK    KKKKK  OOOOO   OOOOO  LLLLL
        KKKKK    KKKKK  OOOOOOOOOOOOO  LLLLLLLLLLLLL     kkkkk
        KKKKK    KKKKK    OOOOOOOOO    LLLLLLLLLLLLL    kkkkk
                                                       kkkkk
    mmmmm  mmmmm   mmmmmm          cccccccccccc       kkkkk   kkkkk
   mmmmmmmm   mmmmm     mmmmm   cccccc       ccccc   kkkkk kkkkk
  mmmmmmmm   mmmmm     mmmmm   cccccc               kkkkkkkk
 mmmmm      mmmmm     mmmmm   cccccc      ccccc    kkkkk  kkkkk
mmmmm      mmmmm     mmmmm     cccccccccccc       kkkkk     kkkkk

  Key Objects Library (C) 1999-2007 by Kladov Vladimir.
  KOL Mirror Classes Kit (C) 2000-2007 by Kladov Vladimir.
}
unit mckCtrls;
{
  This unit contains definitions for mirrors of the most of visual controls,
  defined in KOL. This mirror objects are placed on form at design time and
  behave itselves like usual VCL visual components (controls). But after
  compiling of the project (and at run time) these are transformed to poor KOL
  controls, so all bloats of VCL are removed and executable file become very small.

  Äàííûé ìîäóëü ñîäåðæèò îïðåäåëåíèå çåðêàë äëÿ áîëüøèíñòâà âèçóàëüíûõ îáúåêòîâ,
  îïðåäåëåííûõ â áèáëèîòåêå KOL. Çåðêàëüíûå îáúåêòû ïîìåùàþòñÿ íà ôîðìó âî âðåìÿ
  ïðîåêòèðîâàíèÿ è âåäóò ñåáÿ òàê æå, êàê îáû÷íûå âèçóàëüíûå îáúåêòû VCL. Íî
  ïîñëå êîìïèëÿöèè ïðîåêòà (è âî âðåìÿ èñïîëíåíèÿ) îíè òðàíñôîðìèðóþòñÿ â
  îáúåêòû KOL, òàê ÷òî âñå "íàâîðîòû" VCL óäàëÿþòñÿ è èñïîëíèìûé ôàéë ñòàíîâèòñÿ
  î÷åíü ìàëåíüêèì.        
}

interface

{$I KOLDEF.INC}

uses KOL, Classes, Forms, Controls, Dialogs, Windows, Messages, extctrls,
     stdctrls, comctrls, CommCtrl, SysUtils, Graphics, mirror, ShellAPI,
     mckObjs,
//////////////////////////////////////////////////
     {$IFDEF _D6orHigher}                       //
     DesignIntf, DesignEditors, DesignConst,    //
     Variants,                                  //
     {$ELSE}                                    //
//////////////////////////////////////////////////
     DsgnIntf,
//////////////////////////////////////////////////////////
     {$ENDIF}                                           //
     mckToolbarEditor,  mckLVColumnsEditor
     ;

type

  //============================================================================
  //---- MIRROR FOR A BUTTON ----
  //---- ÇÅÐÊÀËÎ ÄËß ÊÍÎÏÊÈ ----
  TKOLButton = class(TKOLControl)
  private
    FFlat: Boolean;
    FimageBitmap: Graphics.TBitmap;
    FimageIcon: KOL.PIcon;
    Fimage: TPicture;
    FAllowBitmapCompression: Boolean;
    procedure SetFlat(const Value: Boolean);
    procedure Setimage(const Value: TPicture);
    procedure SetAllowBitmapCompression(const Value: Boolean);
  public
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function GenerateTransparentInits: String; override;
    procedure GenerateTransparentInits_Compact; override;
    function P_GenerateTransparentInits: String; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupColor( SL: TStrings; const AName: String ); override;
    procedure P_SetupColor( SL: TStrings; const AName: String; var ControlInStack: Boolean ); override;
    procedure SetupFont( SL: TStrings; const AName: String ); override;
    procedure P_SetupFont( SL: TStrings; const AName: String ); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure P_SetupTextAlign( SL: TStrings; const AName: String ); override;
    function ClientMargins: TRect; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function CanNotChangeFontColor: Boolean; override;
    function DefaultParentColor: Boolean; override;
    function CanChangeColor: Boolean; override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function ImageResourceName: String;
    function TypeName: String; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadImageIcon( Reader: TReader );
    procedure SaveImageIcon( Writer: TWriter );
    procedure LoadImageBitmap( Reader: TReader );
    procedure SaveImageBitmap( Writer: TWriter );
    procedure Loaded; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
  published
    property Border;
    property TextAlign;
    property VerticalAlign;
    property TabStop;
    property TabOrder;
    property OnEnter;
    property OnLeave;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property popupMenu;
    property autoSize;
    property DefaultBtn;
    property CancelBtn;
    property image: TPicture read Fimage write Setimage;
    property action;
    property windowed;
    property Flat: Boolean read FFlat write SetFlat; // only for not windowed ?
    property WordWrap;
    property LikeSpeedButton;
    property AllowBitmapCompression: Boolean read FAllowBitmapCompression write SetAllowBitmapCompression
             default TRUE;
  public
    procedure SetupConstruct_Compact; override;
    function SupportsFormCompact: Boolean; override;
  end;

  //============================================================================
  //---- MIRROR FOR A BIT BUTTON ----
  //---- ÇÅÐÊÀËÎ ÄËß ÐÈÑÎÂÀÍÍÎÉ ÊÍÎÏÊÈ ----
  TKOLBitBtn = class(TKOLControl)
  private
    FOptions: TBitBtnOptions;
    FGlyphBitmap: TBitmap;
    FGlyphCount: Integer;
    FImageList: TKOLImageList;
    FGlyphLayout: TGlyphLayout;
    FImageIndex: Integer;
    FOnTestMouseOver: TOnTestMouseOver;
    FRepeatInterval: Integer;
    FFlat: Boolean;
    FautoAdjustSize: Boolean;
    FBitBtnDrawMnemonic: Boolean;
    FTextShiftY: Integer;
    FTextShiftX: Integer;
    FAllowBitmapCompression: Boolean;
    procedure SetOptions(Value: TBitBtnOptions);
    procedure SetGlyphBitmap(const Value: TBitmap);
    procedure SetGlyphCount(Value: Integer);
    procedure SetImageList(const Value: TKOLImageList);
    procedure SetGlyphLayout(const Value: TGlyphLayout);
    procedure SetImageIndex(const Value: Integer);
    procedure RecalcSize;
    procedure SetOnTestMouseOver(const Value: TOnTestMouseOver);
    procedure SetautoAdjustSize(const Value: Boolean);
    procedure SetRepeatInterval(const Value: Integer);
    procedure SetFlat(const Value: Boolean);
    procedure SetBitBtnDrawMnemonic(const Value: Boolean);
    procedure SetTextShiftX(const Value: Integer);
    procedure SetTextShiftY(const Value: Integer);
    procedure SetAllowBitmapCompression(const Value: Boolean);
  public
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function GenerateTransparentInits: String; override;
    procedure GenerateTransparentInits_Compact; override;
    function P_GenerateTransparentInits: String; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure P_SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; override;
    function ClientMargins: TRect; override;
    procedure AutoSizeNow; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
    function OptionsAsInteger: Integer;
    procedure SetupConstruct_Compact; override;
    function SupportsFormCompact: Boolean; override;
  published
    property options: TBitBtnOptions read FOptions write SetOptions;
    property glyphBitmap: TBitmap read FGlyphBitmap write SetGlyphBitmap;
    property glyphCount: Integer read FGlyphCount write SetGlyphCount;
    property glyphLayout: TGlyphLayout read FGlyphLayout write SetGlyphLayout;
    property imageList: TKOLImageList read FImageList write SetImageList;
    property imageIndex: Integer read FImageIndex write SetImageIndex;
    property TextAlign;
    property VerticalAlign;
    property TabStop;
    property TabOrder;
    property Transparent;
    property OnEnter;
    property OnLeave;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnChange;
    property OnBitBtnDraw;
    property OnTestMouseOver: TOnTestMouseOver read FOnTestMouseOver write SetOnTestMouseOver;
    property autoAdjustSize: Boolean read FautoAdjustSize write SetautoAdjustSize;
    property popupMenu;
    property RepeatInterval: Integer read FRepeatInterval write SetRepeatInterval;
    property Flat: Boolean read FFlat write SetFlat;
    property autoSize;
    property BitBtnDrawMnemonic: Boolean read FBitBtnDrawMnemonic write SetBitBtnDrawMnemonic;
    property TextShiftX: Integer read FTextShiftX write SetTextShiftX;
    property TextShiftY: Integer read FTextShiftY write SetTextShiftY;
    property DefaultBtn;
    property CancelBtn;
    property Brush;
    property action;
    property LikeSpeedButton;
    property AllowBitmapCompression: Boolean read FAllowBitmapCompression write SetAllowBitmapCompression
             default TRUE;
  end;























  //============================================================================
  //---- MIRROR FOR A LABEL ----
  //---- ÇÅÐÊÀËÎ ÄËß ÌÅÒÊÈ ----
  TKOLLabel = class(TKOLControl)
  private
    FShowAccelChar: Boolean;
    function Get_VertAlign: TVerticalAlign;
    procedure Set_VertAlign(const Value: TVerticalAlign);
    procedure SetShowAccelChar(const Value: Boolean);
  public
    function AdjustVerticalAlign( Value: TVerticalAlign ): TVerticalAlign; virtual;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nParams: Integer ): String; override;
    function P_GenerateTransparentInits: String; override;

    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure P_SetupTextAlign( SL: TStrings; const AName: String ); override;
    function GetTabOrder: Integer; override;
    function TypeName: String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String );
              override;
    procedure CallInheritedPaint;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    procedure Loaded; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
    procedure SetupConstruct_Compact; override;
    function SupportsFormCompact: Boolean; override;
  published
    property Transparent;
    property TextAlign;
    property VerticalAlign: TVerticalAlign read Get_VertAlign write Set_VertAlign;
    property wordWrap;
    property popupMenu;
    property autoSize;
    property Brush;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar;
    property windowed;
  end;


  //============================================================================
  //---- MIRROR FOR A LABEL EFFECT ----
  //---- ÇÅÐÊÀËÎ ÄËß ÌÅÒÊÈ Ñ ÝÔÔÅÊÒÀÌÈ ----
  TKOLLabelEffect = class( TKOLLabel )
  private
    FShadowDeep: Integer;
    FColor2: TColor;
    procedure SetShadowDeep(const Value: Integer);
    procedure SetColor2(const Value: TColor);
  public
    function AdjustVerticalAlign( Value: TVerticalAlign ): TVerticalAlign; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure P_SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function AutoWidth( Canvas: graphics.TCanvas ): Integer; override;
    function AutoHeight( Canvas: graphics.TCanvas ): Integer; override;
    procedure Paint; override;
    procedure SetWindowed( const Value: Boolean ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure SetupConstruct_Compact; override;
    function SupportsFormCompact: Boolean; override;
  published
    property ShadowDeep: Integer read FShadowDeep write SetShadowDeep;
    property Color2: TColor read FColor2 write SetColor2;
    property autoSize;
    property Ctl3D;
    property Brush;
    property wordwrap;
    property HasBorder;
  end;

















  //============================================================================
  //---- MIRROR FOR A PANEL ----
  //---- ÇÅÐÊÀËÎ ÄËß ÏÀÍÅËÈ ----
  TKOLPanel = class(TKOLControl)
  private
    FEdgeStyle: TEdgeStyle;
    FShowAccelChar: Boolean;
    procedure SetEdgeStyle(const Value: TEdgeStyle);
    procedure SetShowAccelChar(const Value: Boolean);
  protected
    function Get_VA: TVerticalAlign;
    procedure Set_VA(const Value: TVerticalAlign); virtual;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupConstruct( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    procedure P_SetupTextAlign( SL: TStrings; const AName: String ); override;
    function ClientMargins: TRect; override;
    function RefName: String; override;
  public
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    procedure SetCaption(const Value: TDelphiString); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property TextAlign;
    property edgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property TabOrder;
    property VerticalAlign: TVerticalAlign read Get_VA write Set_VA;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu;
    property Brush;
    property ShowAccelChar: Boolean read FShowAccelChar write SetShowAccelChar;
  end;

  //============================================================================
  //---- MIRROR FOR MDI CLIENT ----
  //---- ÇÅÐÊÀËÎ ÄËß MDI ÊËÈÅÍÒÀ ----
  TKOLMDIClient = class(TKOLControl)
  private
    FTimer: TTimer;
    procedure Tick( Sender: TObject );
  protected
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
  published
    property TabOrder;
    property OverrideScrollbars;
  end;


  //===========================================================================
  //---- MIRROR FOR A GRADIENT PANEL
  //---- ÇÅÐÊÀËÎ ÄËß ÃÐÀÄÈÅÍÒÍÎÉ ÏÀÍÅËÈ
  TKOLGradientPanel = class(TKOLControl)
  private
    FColor1: TColor;
    FColor2: TColor;
    FgradientLayout: KOL.TGradientLayout;
    FgradientStyle: KOL.TGradientStyle;
    procedure SetColor1(const Value: TColor);
    procedure SetColor2(const Value: TColor);
    procedure SetgradientLayout(const Value: KOL.TGradientLayout);
    procedure SetgradientStyle(const Value: KOL.TGradientStyle);
  protected
    function TabStopByDefault: Boolean; override;
    function TypeName: String; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
  published
    property Transparent;
    property Color1: TColor read FColor1 write SetColor1;
    property Color2: TColor read FColor2 write SetColor2;
    property GradientStyle: KOL.TGradientStyle read FgradientStyle write SetgradientStyle;
    property GradientLayout: KOL.TGradientLayout read FgradientLayout write SetgradientLayout;
    property TabOrder;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu;
    property HasBorder;
  end;



  //===========================================================================
  //---- MIRROR FOR A SPLITTER
  //---- ÇÅÐÊÀËÎ ÄËß ÐÀÇÄÅËÈÒÅËß
  TKOLSplitter = class( TKOLControl )
  private
    FMinSizePrev: Integer;
    FMinSizeNext: Integer;
    //FBeveled: Boolean;
    FEdgeStyle: TEdgeStyle;
    fNotAvailable: Boolean;
    procedure SetMinSizeNext(const Value: Integer);
    procedure SetMinSizePrev(const Value: Integer);
    //procedure SetBeveled(const Value: Boolean);
    procedure SetEdgeStyle(const Value: TEdgeStyle);
  protected
    function IsCursorDefault: Boolean; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function TypeName: String; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  public
    function BestEventName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property MinSizePrev: Integer read FMinSizePrev write SetMinSizePrev;
    property MinSizeNext: Integer read FMinSizeNext write SetMinSizeNext;
    property TabOrder;
    //property beveled: Boolean read FBeveled write SetBeveled;
    property edgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property Caption: Boolean read fNotAvailable;
    //property CenterOnParent: Boolean read fNotAvailable;
    property OnSplit;
    property Brush;
  end;



  //===========================================================================
  //---- MIRROR FOR A GROUPBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÃÐÓÏÏÛ
  TKOLGroupBox = class( TKOLControl )
  private
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    function P_GenerateTransparentInits: String; override;
    function ClientMargins: TRect; override;
    function DrawMargins: TRect; override;
    {$IFDEF _KOLCtrlWrapper_} {YS}
    procedure CreateKOLControl(Recreating: boolean); override;
    {$ENDIF}
    procedure SetupTextAlign( SL: TStrings; const AName: String ); override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
  published
    property Transparent;
    property TabOrder;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu;
    property TextAlign;
    property HasBorder;
    property Brush;
  end;


  //===========================================================================
  //---- MIRROR FOR A CHECKBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÔËÀÆÊÀ
  TKOLCheckBox = class( TKOLControl )
  private
    FChecked: Boolean;
    FAuto3State: Boolean;
    procedure SetChecked(const Value: Boolean);
    procedure SetAuto3State(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    function P_GenerateTransparentInits: String; override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    function TypeName: String; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
  published
    property Transparent;
    property Checked: Boolean read FChecked write SetChecked;
    property TabStop;
    property TabOrder;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property autoSize;
    property HasBorder;
    property Brush;
    property Auto3State: Boolean read FAuto3State write SetAuto3State;
    property action;
    property windowed;
    property WordWrap; // only for not windowed
    property Border;   // only for not windowed when WordWrap=TRUE
    property LikeSpeedButton;
  end;


  //===========================================================================
  //---- MIRROR FOR A RADIOBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÐÀÄÈÎ-ÔËÀÆÊÀ
  TKOLRadioBox = class( TKOLControl )
  private
    FChecked: Boolean;
    procedure SetChecked(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
  public
    function P_GenerateTransparentInits: String; override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
  published
    property Transparent;
    property Checked: Boolean read FChecked write SetChecked;
    property TabStop;
    property TabOrder;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property autoSize;
    property HasBorder;
    property Brush;
    property action;
    property windowed;
    property WordWrap; // only for not windowed
    property Border;   // only for not windowed when WordWrap=TRUE
    property LikeSpeedButton;
  end;








  //===========================================================================
  //---- MIRROR FOR AN EDITBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÎÊÍÀ ÂÂÎÄÀ
  TKOLEditOption = ( {eoNoHScroll, eoNoVScroll,} eoLowercase, {eoMultiline,}
                  eoNoHideSel, eoOemConvert, eoPassword, eoReadonly,
                  eoUpperCase, eoWantTab, eoNumber );
  TKOLEditOptions = Set of TKOLEditOption;

  TKOLEditBox = class( TKOLControl )
  private
    FOptions: TKOLEditOptions;
    FEdTransparent: Boolean;
    FUnicode: Boolean;
    procedure SetOptions(const Value: TKOLEditOptions);
    function GetCaption: TDelphiString;
    function GetText: TDelphiString;
    procedure SetText(const Value: TDelphiString);
    procedure SetEdTransparent(const Value: Boolean);
    procedure SetUnicode(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    procedure WantTabs( Want: Boolean ); override;
    function DefaultColor: TColor; override;
    function BestEventName: String; override;
    procedure SetupTextAlign(SL: TStrings; const AName: String); override;
    procedure P_SetupTextAlign(SL: TStrings; const AName: String); override;
    function SetupColorFirst: Boolean; override;
    procedure SetupSetUnicode( SL: TStringList; const AName: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent: Boolean read FEdTransparent write SetEdTransparent;
    property Text: TDelphiString read GetText write SetText;
    property Options: TKOLEditOptions read FOptions write SetOptions;
    property TabStop;
    property TabOrder;
    property OnChange;
    property OnSelChange;
    property Caption: TDelphiString read GetCaption; // redefined as read only to remove from Object Inspector
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property TextAlign;
    property autoSize;
    property HasBorder;
    property EditTabChar;
    property Brush;
    property windowed;
    property Unicode: Boolean read FUnicode write SetUnicode;
  end;


  //===========================================================================
  //---- MIRROR FOR A MEMO
  //---- ÇÅÐÊÀËÎ ÄËß ÌÍÎÃÎÑÒÐÎ×ÍÎÃÎ ÎÊÍÀ ÂÂÎÄÀ
  TKOLMemoOption = ( eo_NoHScroll, eo_NoVScroll, eo_Lowercase, {eoMultiline,}
                  eo_NoHideSel, eo_OemConvert, eo_Password, eo_Readonly,
                  eo_UpperCase, eo_WantReturn, eo_WantTab );
                  // Character '_' is used to prevent conflict of option names
                  // with the same in TKOLEditOption type. Fortunately, we never
                  // should to use these names in run-time code of the project.
                  //
                  // Ñèìâîë '_' èñïîëüçóåòñÿ, ÷òîáû ïðåäîòâðàòèòü êîíôëèêò ñ
                  // èìåíàìè òàêèõ æå îïöèé äëÿ òèïà TKOLEditOption. Ê ñ÷àñòüþ,
                  // íàì ýòè èìåíà íèêîãäà íå ïîíàäîáÿòñÿ ïðè íàïèñàíèè êîíå÷íîãî
                  // êîäà.
  TKOLMemoOptions = Set of TKOLMemoOption;

  TKOLMemo = class( TKOLControl )
  private
    FOptions: TKOLMemoOptions;
    FLines: TStrings;
    FEdTransparent: Boolean;
    FUnicode: Boolean;
    procedure SetOptions(const Value: TKOLMemoOptions);
    function GetCaption: String;
    procedure SetText(const Value: TStrings);
    function GetText: TStrings;
    procedure SetEdTransparent(const Value: Boolean);
    procedure SetUnicode(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
  public
    function BestEventName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
    procedure Loaded; override;
    procedure SetTextAlign(const Value: TTextAlign); override;
    procedure SetupTextAlign(SL: TStrings; const AName: String); override;
    procedure P_SetupTextAlign(SL: TStrings; const AName: String); override;
    function SetupColorFirst: Boolean; override;
    procedure SetupSetUnicode( SL: TStringList; const AName: String ); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function TypeName: String; override;
    procedure WantTabs( Want: Boolean ); override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent: Boolean read FEdTransparent write SetEdTransparent;
    property Text: TStrings read GetText write SetText;
    property TextAlign;
    property TabStop;
    property TabOrder;
    property Options: TKOLMemoOptions read FOptions write SetOptions;
    property OnChange;
    property OnSelChange;
    property Caption: String read GetCaption; // redefined as read only to remove from Object Inspector
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property HasBorder;
    property OnScroll;
    property EditTabChar;
    property Brush;
    property OverrideScrollbars;
    property Unicode: Boolean read FUnicode write SetUnicode;
  end;




  //===========================================================================
  //---- MIRROR FOR A RICHEDIT
  //---- ÇÅÐÊÀËÎ ÄËß ÐÅÄÀÊÒÎÐÀ
  TKOLRichEditVersion = ( ver1, ver3 );

  TKOLRichEdit = class( TKOLControl )
  private
    FOptions: TKOLMemoOptions;
    FLines: TStrings;
    Fversion: TKOLRichEditVersion;
    FMaxTextSize: DWORD;
    FRE_FmtStandard: Boolean;
    FRE_AutoKeyboard: Boolean;
    FRE_AutoKeybdSet: Boolean;
    FRE_DisableOverwriteChange: Boolean;
    FRE_AutoURLDetect: Boolean;
    FRE_Transparent: Boolean;
    FOLESupport: Boolean;
    FRE_IMECancelComplete: Boolean;
    FRE_DualFont: Boolean;
    FRE_IMEAlwaysSendNotify: Boolean;
    FRE_AutoFontSizeAdjust: Boolean;
    FRE_UIFonts: Boolean;
    FRE_AutoFont: Boolean;
    FRE_ZoomDenominator: Integer;
    FRE_ZoomNumerator: Integer;
    function GetText: TStrings;
    procedure SetText(const Value: TStrings);
    procedure SetOptions(const Value: TKOLMemoOptions);
    function GetCaption: String;
    procedure Setversion(const Value: TKOLRichEditVersion);
    procedure SetMaxTextSize(const Value: DWORD);
    procedure SetRE_FmtStandard(const Value: Boolean);
    procedure SetRE_AutoKeyboard(const Value: Boolean);
    procedure SetRE_AutoKeybdSet(const Value: Boolean);
    procedure SetRE_DisableOverwriteChange(const Value: Boolean);
    procedure SetRE_AutoURLDetect(const Value: Boolean);
    procedure SetRE_Transparent(const Value: Boolean);
    procedure SetOLESupport(const Value: Boolean);
    procedure SetRE_AutoFont(const Value: Boolean);
    procedure SetRE_AutoFontSizeAdjust(const Value: Boolean);
    procedure SetRE_DualFont(const Value: Boolean);
    procedure SetRE_IMEAlwaysSendNotify(const Value: Boolean);
    procedure SetRE_IMECancelComplete(const Value: Boolean);
    procedure SetRE_UIFonts(const Value: Boolean);
    procedure SetRE_ZoomDenominator(const Value: Integer);
    procedure SetRE_ZoomNumerator(const Value: Integer);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function TypeName: String; override;
  public
    function GenerateTransparentInits: String; override;
    procedure GenerateTransparentInits_Compact; override;
    function P_GenerateTransparentInits: String; override;
    procedure BeforeFontChange( SL: TStrings; const AName, Prefix: String ); override;
    procedure P_BeforeFontChange( SL: TStrings; const AName, Prefix: String ); override;
    function FontPropName: String; override;
    procedure AfterFontChange( SL: TStrings; const AName, Prefix: String ); override;
    procedure P_AfterFontChange( SL: TStrings; const AName, Prefix: String ); override;
    procedure WantTabs( Want: Boolean ); override;
    function DefaultColor: TColor; override;
    function AdditionalUnits: String; override;
    function BestEventName: String; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    procedure Loaded; override;
    function NoDrawFrame: Boolean; override;
    function SetupColorFirst: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
  published
    property Transparent read FRE_Transparent write SetRE_Transparent;
    property RE_Transparent: Boolean read FRE_Transparent write SetRE_Transparent;
    property Text: TStrings read GetText write SetText;
    property TabStop;
    property TabOrder;
    property Options: TKOLMemoOptions read FOptions write SetOptions;
    property OnChange;
    property OnSelChange;
    property Caption: String read GetCaption; // redefined as read only to remove from Object Inspector
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property version: TKOLRichEditVersion read Fversion write Setversion;
    property OnProgress;
    property OnRE_URLClick;
    property OnRE_OverURL;
    property OnRE_InsOvrMode_Change;
    property RE_DisableOverwriteChange: Boolean read FRE_DisableOverwriteChange write SetRE_DisableOverwriteChange;
    property MaxTextSize: DWORD read FMaxTextSize write SetMaxTextSize;
    property RE_FmtStandard: Boolean read FRE_FmtStandard write SetRE_FmtStandard;
    property RE_AutoKeyboard: Boolean read FRE_AutoKeyboard write SetRE_AutoKeyboard;
    property RE_AutoFont: Boolean read FRE_AutoFont write SetRE_AutoFont;
    property RE_AutoFontSizeAdjust: Boolean read FRE_AutoFontSizeAdjust write SetRE_AutoFontSizeAdjust;
    property RE_DualFont: Boolean read FRE_DualFont write SetRE_DualFont;
    property RE_UIFonts: Boolean read FRE_UIFonts write SetRE_UIFonts;
    property RE_IMECancelComplete: Boolean read FRE_IMECancelComplete write SetRE_IMECancelComplete;
    property RE_IMEAlwaysSendNotify: Boolean read FRE_IMEAlwaysSendNotify write SetRE_IMEAlwaysSendNotify;
    property RE_AutoKeybdSet: Boolean read FRE_AutoKeybdSet write SetRE_AutoKeybdSet;
    property RE_AutoURLDetect: Boolean read FRE_AutoURLDetect write SetRE_AutoURLDetect;
    property RE_ZoomNumerator: Integer read FRE_ZoomNumerator write SetRE_ZoomNumerator;
    property RE_ZoomDenominator: Integer read FRE_ZoomDenominator write SetRE_ZoomDenominator;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property HasBorder;
    property OnScroll;
    property EditTabChar;
    property Brush;
    property OLESupport: Boolean read FOLESupport write SetOLESupport;
    property OverrideScrollbars;
  end;





  //===========================================================================
  //---- MIRROR FOR A LISTBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÑÏÈÑÊÀ
  TKOLListboxOption = ( loNoHideScroll, loNoExtendSel, loMultiColumn, loMultiSelect,
                  loNoIntegralHeight, loNoSel, loSort, loTabstops,
                  loNoStrings, loNoData, loOwnerDrawFixed, loOwnerDrawVariable,
                  loHScroll );
  TKOLListboxOptions = Set of TKOLListboxOption;

  TKOLListBox = class( TKOLControl )
  private
    FOptions: TKOLListboxOptions;
    FItems: TStrings;
    FCurIndex: Integer;
    FCount: Integer;
    fLBItemHeight: Integer;
    FAlwaysAssignItems: Boolean;  {+ecm}
    procedure SetLBItemHeight(const Value: Integer); {+ecm}
    procedure SetOptions(const Value: TKOLListboxOptions);
    procedure SetItems(const Value: TStrings);
    procedure SetCurIndex(const Value: Integer);
    function GetCaption: String;
    procedure SetCount(Value: Integer);
    procedure UpdateItems;
    procedure SetAlwaysAssignItems(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
  public
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
    procedure Loaded; override;
    function GenerateTransparentInits: String; override; {+ecm}
    procedure GenerateTransparentInits_Compact; override; {+ecm}
    function P_GenerateTransparentInits: String; override; {+ecm}
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
  published
    property Transparent;
    property TabStop;
    property TabOrder;
    property Options: TKOLListboxOptions read FOptions write SetOptions;
    property OnSelChange;
    property Items: TStrings read FItems write SetItems;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property Caption: String read GetCaption; // hide Caption in Object Inspector
    property OnDrawItem;
    property OnMeasureItem;
    property Count: Integer read FCount write SetCount;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property HasBorder;
    property OnScroll;
    property Brush;
    property LBItemHeight: Integer read fLBItemHeight write SetLBItemHeight; {+ecm}
    property OverrideScrollbars;
    property AlwaysAssignItems: Boolean read FAlwaysAssignItems write SetAlwaysAssignItems;
  end;






  //===========================================================================
  //---- MIRROR FOR A COMBOBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÂÛÏÀÄÀÞÙÅÃÎ ÑÏÈÑÊÀ
  TKOLComboOption = ( coReadOnly, coNoHScroll, coAlwaysVScroll, coLowerCase,
                   coNoIntegralHeight, coOemConvert, coSort, coUpperCase,
                   coOwnerDrawFixed, coOwnerDrawVariable, coSimple );
  TKOLComboOptions = Set of TKOLComboOption;

  TKOLComboBox = class( TKOLControl )
  private
    FOptions: TKOLComboOptions;
    FItems: TStrings;
    FCurIndex: Integer;
    FDroppedWidth: Integer;
    fCBItemHeight: Integer;
    FAlwaysAssignItems: Boolean;  {+ecm}
    procedure SetCBItemHeight(const Value: Integer); {+ecm}
    procedure SetOptions(const Value: TKOLComboOptions);
    procedure SetCurIndex(const Value: Integer);
    procedure SetItems(const Value: TStrings);
    procedure SetDroppedWidth(const Value: Integer);
    procedure SetAlwaysAssignItems(const Value: Boolean);
  protected
    function TabStopByDefault: Boolean; override;
    procedure FirstCreate; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    function DefaultInitialColor: TColor; override;
    procedure SetAlign(const Value: TKOLAlign); override;
  public
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function AutoHeight( Canvas: graphics.TCanvas ): Integer; override;
    function AutoSizeRunTime: Boolean; override;
    function GenerateTransparentInits: String; override; {+ecm}
    procedure GenerateTransparentInits_Compact; override; {+ecm}
    function P_GenerateTransparentInits: String; override; {+ecm}
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property TabStop;
    property TabOrder;
    property Options: TKOLComboOptions read FOptions write SetOptions;
    property OnChange;
    property OnSelChange;
    property OnDropDown;
    property OnCloseUp;
    property Items: TStrings read FItems write SetItems;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property DroppedWidth: Integer read FDroppedWidth write SetDroppedWidth;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnMeasureItem;
    property OnDrawItem;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property autoSize;
    property Brush;
    property CBItemHeight: Integer read fCBItemHeight write SetCBItemHeight; {+ecm}
    property AlwaysAssignItems: Boolean read FAlwaysAssignItems write SetAlwaysAssignItems;
  end;




  //===========================================================================
  //---- MIRROR FOR A PAINTBOX
  //---- ÇÅÐÊÀËÎ ÄËß ÌÎËÜÁÅÐÒÀ
  TKOLPaintBox = class( TKOLControl )
  private
    fNotAvailable: Boolean;
  protected
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
  public
    function BestEventName: String; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property OnPaint;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu;
    property Caption: Boolean read fNotAvailable;
    property windowed;
  end;



  //===========================================================================
  //---- MIRROR FOR A IMAGESHOW
  //---- ÇÅÐÊÀËÎ ÄËß ÊÀÐÒÈÍÊÈ
  TKOLImageShow = class( TKOLControl )
  private
    FCurIndex: Integer;
    FImageListNormal: TKOLImageList;
    fNotAvailable: Boolean;
    FHasBorder: Boolean;
    fImgShwAutoSize: Boolean;
    procedure SetCurIndex(const Value: Integer);
    procedure SetImageListNormal(const Value: TKOLImageList);
    procedure SetImgShwAutoSize(const Value: Boolean);
  protected
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure DoAutoSize;
    procedure SetHasBorder(const Value: Boolean); override;
  public
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    function Pcode_Generate: Boolean; override;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    procedure SetBounds( aLeft, aTop, aWidth, aHeight: Integer ); override;
  published
    property ImageListNormal: TKOLImageList read FImageListNormal write SetImageListNormal;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property Transparent;
    property popupMenu;
    property Caption: Boolean read fNotAvailable;
    property HasBorder; //: Boolean read FHasBorder write SetHasBorder;
    property autoSize: Boolean read fImgShwAutoSize write SetImgShwAutoSize;
    property Brush;
    property MarginLeft;
    property MarginTop;
  end;

  //===========================================================================
  //---- MIRROR FOR A PROGRESSBAR
  //---- ÇÅÐÊÀËÎ ÄËß ËÈÍÅÉÊÈ ÏÐÎÃÐÅÑÑÀ
  TKOLProgressBar = class( TKOLControl )
  private
    FVertical: Boolean;
    FSmooth: Boolean;
    //FProgressBkColor: TColor;
    FProgressColor: TColor;
    FMaxProgress: Integer;
    FProgress: Integer;
    fNotAvailable: Boolean;
    procedure SetSmooth(const Value: Boolean);
    procedure SetVertical(const Value: Boolean);
    //procedure SetProgressBkColor(const Value: TColor);
    procedure SetProgressColor(const Value: TColor);
    procedure SetMaxProgress(const Value: Integer);
    procedure SetProgress(const Value: Integer);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
  protected
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    function TypeName: String; override;
  public
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property Vertical: Boolean read FVertical write SetVertical;
    property Smooth: Boolean read FSmooth write SetSmooth;
    property ProgressColor: TColor read FProgressColor write SetProgressColor;
    property ProgressBkColor: TColor read GetColor write SetColor;
    property Progress: Integer read FProgress write SetProgress;
    property MaxProgress: Integer read FMaxProgress write SetMaxProgress;
    property Caption: Boolean read fNotAvailable;
    property OnMouseDblClk: Boolean read fNotAvailable;
    property popupMenu;
    property Brush;
  end;


  //===========================================================================
  //---- MIRROR FOR A LISTVIEW
  //---- ÇÅÐÊÀËÎ ÄËß ÏÐÎÑÌÎÒÐÀ ÑÏÈÑÊÀ / ÒÀÁËÈÖÛ
  TKOLListViewStyle = ( lvsIcon, lvsSmallIcon, lvsList, lvsDetail, lvsDetailNoHeader );

  TKOLListViewOption = ( lvoIconLeft, lvoAutoArrange, lvoButton, lvoEditLabel,
    lvoNoLabelWrap, lvoNoScroll, lvoNoSortHeader, lvoHideSel, lvoMultiselect,
    lvoSortAscending, lvoSortDescending, lvoGridLines, lvoSubItemImages,
    lvoCheckBoxes, lvoTrackSelect, lvoHeaderDragDrop, lvoRowSelect, lvoOneClickActivate,
    lvoTwoClickActivate, lvoFlatsb, lvoRegional, lvoInfoTip, lvoUnderlineHot,
    lvoMultiWorkares, lvoOwnerData, lvoOwnerDrawFixed );
  TKOLListViewOptions = Set of TKOLListViewOption;

  TKOLListViewColWidthType = ( lvcwtCustom, lvcwtAutosize, lvcwtAutoSizeCaption );

  TKOLListView = class;

  TKOLListViewColumn = class( TComponent )
  private
    FListView: TKOLListView;
    FLVColImage: Integer;
    FLVColOrder: Integer;
    FWidth: Integer;
    FCaption: String;
    FWidthType: TKOLListViewColWidthType;
    FTextAlign: TTextAlign;
    FLVColRightImg: Boolean;
    procedure SetCaption(const Value: String);
    procedure SetLVColImage(const Value: Integer);
    procedure SetLVColOrder(const Value: Integer);
    procedure SetTextAlign(const Value: TTextAlign);
    procedure SetWidth(const Value: Integer);
    procedure SetWidthType(const Value: TKOLListViewColWidthType);
    procedure Change;
    procedure SetLVColRightImg(const Value: Boolean);
  protected
    procedure SetName( const AName: TComponentName ); override;
    procedure DefProps( const Prefix: String; Filer: TFiler );
    procedure LoadName( Reader: TReader );
    procedure SaveName( Writer: TWriter );
    procedure LoadCaption( Reader: TReader );
    procedure SaveCaption( Writer: TWriter );
    procedure LoadTextAlign( Reader: TReader );
    procedure SaveTextAlign( Writer: TWriter );
    procedure LoadWidth( Reader: TReader );
    procedure SaveWidth( Writer: TWriter );
    procedure LoadWidthType( Reader: TReader );
    procedure SaveWidthType( Writer: TWriter );
    procedure LoadLVColImage( Reader: TReader );
    procedure SaveLVColImage( Writer: TWriter );
    procedure LoadLVColOrder( Reader: TReader );
    procedure SaveLVColOrder( Writer: TWriter );
    procedure LoadLVColRightImg( Reader: TReader );
    procedure SaveLVColRightImg( Writer: TWriter );
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
  published
    property Caption: String read FCaption write SetCaption;
    property TextAlign: TTextAlign read FTextAlign write SetTextAlign;
    property Width: Integer read FWidth write SetWidth;
    property WidthType: TKOLListViewColWidthType read FWidthType write SetWidthType;
    property LVColImage: Integer read FLVColImage write SetLVColImage;
    property LVColRightImg: Boolean read FLVColRightImg write SetLVColRightImg;
    property LVColOrder: Integer read FLVColOrder write SetLVColOrder;
  end;

  TKOLListView = class( TKOLControl )
  private
    FOptions: TKOLListViewOptions;
    FStyle: TKOLListViewStyle;
    FImageListNormal: TKOLImageList;
    FImageListSmall: TKOLImageList;
    FImageListState: TKOLImageList;
    FCurIndex: Integer;
    FLVCount: Integer;
    FLVBkColor: TColor;
    FLVTextBkColor: TColor;
    //FOnDeleteLVItem: TOnDeleteLVItem;
    FGenerateColIdxConst: Boolean;
    FOnLVCustomDraw: TOnLVCustomDraw;
    {$IFNDEF _D2}
    //FOnLVDataW: TOnLVDataW;
    {$ENDIF _D2}
    fLVItemHeight: Integer;
    procedure SetOptions(const Value: TKOLListViewOptions);
    procedure SetStyle(const Value: TKOLListViewStyle);
    procedure SetImageListNormal(const Value: TKOLImageList);
    procedure SetImageListSmall(const Value: TKOLImageList);
    procedure SetImageListState(const Value: TKOLImageList);
    function GetCaption: String;
    procedure SetLVCount(Value: Integer);
    procedure SetLVTextBkColor(const Value: TColor);
    function GetColor: TColor;
    procedure SetColor(const Value: TColor);
    //procedure SetOnLVDelete(const Value: TOnDeleteLVItem);
    function GetColumns: String;
    procedure SetColumns(const Value: String);
    procedure SetGenerateColIdxConst(const Value: Boolean);
    procedure SetOnLVCustomDraw(const Value: TOnLVCustomDraw);
    procedure UpdateColumns;
    {$IFNDEF _D2}
    //procedure SetOnLVDataW(const Value: TOnLVDataW); {YS}
    {$ENDIF _D2}
    procedure SetLVItemHeight(const Value: Integer);
  protected
    FCols: TList;
    FColCount: Integer;
    function TabStopByDefault: Boolean; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; override;
    procedure DefineProperties( Filer: TFiler ); override;
    procedure LoadColCount( Reader: TReader );
    procedure SaveColCount( Writer: TWriter );
    procedure DoGenerateConstants( SL: TStringList ); override;
  public
    procedure Loaded; override; {YS}
    function NoDrawFrame: Boolean; override;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function GetDefaultControlFont: HFONT; override;
    function GenerateTransparentInits: String; override;
    procedure GenerateTransparentInits_Compact; override;
    function P_GenerateTransparentInits: String; override;
  public
    ActiveDesign: TfmLVColumnsEditor;
    constructor Create( AOwner: TComponent ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    destructor Destroy; override;
    property Cols: TList read FCols;
    function HasOrderedColumns: Boolean;
    procedure Invalidate; override; {YS}
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property Style: TKOLListViewStyle read FStyle write SetStyle;
    property Options: TKOLListViewOptions read FOptions write SetOptions;
    property ImageListSmall: TKOLImageList read FImageListSmall write SetImageListSmall;
    property ImageListNormal: TKOLImageList read FImageListNormal write SetImageListNormal;
    property ImageListState: TKOLImageList read FImageListState write SetImageListState;
    property OnChange;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property Caption: String read GetCaption; // hide Caption in Object Inspector
    property OnDeleteLVItem;
    property OnDeleteAllLVItems;
    property OnLVData;
    property LVCount: Integer read FLVCount write SetLVCount;
    property LVTextBkColor: TColor read FLVTextBkColor write SetLVTextBkColor;
    property LVBkColor: TColor read GetColor write SetColor;
    property LVItemHeight: Integer read fLVItemHeight write SetLVItemHeight;
    property OnCompareLVItems;
    property OnEndEditLVItem;
    property OnColumnClick;
    property OnLVStateChange;
    property OnDrawItem;
    property OnLVCustomDraw: TOnLVCustomDraw read FOnLVCustomDraw write SetOnLVCustomDraw;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property OnMeasureItem;
    property HasBorder;
    property OnScroll;
    property TabStop;
    property Columns: String read GetColumns write SetColumns stored FALSE;
    property generateConstants: Boolean read FGenerateColIdxConst write SetGenerateColIdxConst;
    property Brush;
    {$IFNDEF _D2}
    //property OnLVDataW: TOnLVDataW read FOnLVDataW write SetOnLVDataW;
    {$ENDIF _D2}
    property OverrideScrollbars;
  end;

  TKOLLVColumnsEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TKOLLVColumnsPropEditor = class( TStringProperty )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;



  //===========================================================================
  //---- MIRROR FOR A TREEVIEW
  //---- ÇÅÐÊÀËÎ ÄËß ÏÐÎÑÌÎÒÐÀ ÄÅÐÅÂÀ
  TKOLTreeViewOption = ( tvoNoLines, tvoLinesRoot, tvoNoButtons, tvoEditLabels, tvoHideSel,
                  tvoDragDrop, tvoNoTooltips, tvoCheckBoxes, tvoTrackSelect,
                  tvoSingleExpand, tvoInfoTip, tvoFullRowSelect, tvoNoScroll,
                  tvoNonEvenHeight );
  TKOLTreeViewOptions = Set of TKOLTreeViewOption;

  TKOLTreeView = class( TKOLControl )
  private
    FOptions: TKOLTreeViewOptions;
    FCurIndex: Integer;
    FImageListNormal: TKOLImageList;
    FImageListState: TKOLImageList;
    FTVRightClickSelect: Boolean;
    FTVIndent: Integer;
    procedure SetOptions(const Value: TKOLTreeViewOptions);
    procedure SetCurIndex(const Value: Integer);
    procedure SetImageListNormal(const Value: TKOLImageList);
    procedure SetImageListState(const Value: TKOLImageList);
    procedure SetTVRightClickSelect(const Value: Boolean);
    procedure SetTVIndent(const Value: Integer);
  protected
    function TabStopByDefault: Boolean; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function DefaultColor: TColor; override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
  public
    procedure CreateKOLControl(Recreating: boolean); override;
    function NoDrawFrame: Boolean; override;
  public
    constructor Create( AOwner: TComponent ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    destructor Destroy; override;
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property Transparent;
    property Options: TKOLTreeViewOptions read FOptions write SetOptions;
    property ImageListNormal: TKOLImageList read FImageListNormal write SetImageListNormal;
    property ImageListState: TKOLImageList read FImageListState write SetImageListState;
    property CurIndex: Integer read FCurIndex write SetCurIndex;
    property TVRightClickSelect: Boolean read FTVRightClickSelect write SetTVRightClickSelect;
    property OnChange;
    property OnSelChange;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property OnTVBeginDrag;
    property OnTVBeginEdit;
    property OnTVEndEdit;
    property OnTVExpanding;
    property OnTVExpanded;
    property OnTVDelete;
    property OnTVSelChanging;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property TVIndent: Integer read FTVIndent write SetTVIndent;
    property HasBorder;
    property OnScroll;
    property TabStop;
    property Brush;
    property OverrideScrollbars;
  end;

  //===========================================================================
  //---- MIRROR FOR A TOOLBAR
  //---- ÇÅÐÊÀËÎ ÄËß ËÈÍÅÉÊÈ ÊÍÎÏÎÊ
  TKOLToolbar = class;

  TSystemToolbarImage = ( stiCustom, stdCUT, stdCOPY, stdPASTE, stdUNDO,
                      stdREDO, stdDELETE, stdFILENEW, stdFILEOPEN,
                      stdFILESAVE, stdPRINTPRE, stdPROPERTIES,
                      stdHELP, stdFIND, stdREPLACE, stdPRINT,

                      viewLARGEICONS, viewSMALLICONS, viewLIST,
                      viewDETAILS, viewSORTNAME, viewSORTSIZE,
                      viewSORTDATE, viewSORTTYPE, viewPARENTFOLDER,
                      viewNETCONNECT, viewNETDISCONNECT, viewNEWFOLDER,
                      viewVIEWMENU,

                      histBACK, histFORWARD, histFAVORITES,
                      histADDTOFAVORITES, histVIEWTREE );

  TKOLToolbarButton = class( TComponent )
  private
    FToolbar: TKOLToolbar;
    Fenabled: Boolean;
    Fseparator: Boolean;
    Fvisible: Boolean;
    Fdropdown: Boolean;
    Fcaption: String;
    Ftooltip: String;
    FonClick: TOnToolbarButtonClick;
    fOnClickMethodName: String;
    Fpicture: TPicture;
    Fchecked: Boolean;
    fNotAvailable: Boolean;
    Fsysimg: TSystemToolbarImage;
    FradioGroup: Integer;
    FimgIndex: Integer;
    Faction: TKOLAction;
    FCheckable: Boolean;
    procedure Setcaption(const Value: String);
    procedure Setdropdown(const Value: Boolean);
    procedure Setenabled(const Value: Boolean);
    procedure SetonClick(const Value: TOnToolbarButtonClick);
    procedure Setpicture(Value: TPicture);
    procedure Setseparator(const Value: Boolean);
    procedure Settooltip(const Value: String);
    procedure Setvisible(const Value: Boolean);
    procedure Setchecked(const Value: Boolean);
    procedure Setsysimg(const Value: TSystemToolbarImage);
    procedure SetradioGroup(const Value: Integer);
    procedure SetimgIndex(const Value: Integer);
    procedure Setaction(const Value: TKOLAction);
    procedure SetCheckable(const Value: Boolean);
  protected
    procedure Change;
    procedure SetName( const NewName: TComponentName ); override;
    procedure DefProps( const Prefix: String; Filer: Tfiler );
    procedure LoadName( Reader: TReader );
    procedure SaveName( Writer: TWriter );
    procedure LoadProps( Reader: TReader );
    procedure SaveProps( Writer: TWriter );
    procedure LoadCaption( Reader: TReader );
    procedure SaveCaption( Writer: TWriter );
    procedure LoadChecked( Reader: TReader );
    procedure SaveChecked( Writer: TWriter );
    procedure LoadDropDown( Reader: TReader );
    procedure SaveDropDown( Writer: TWriter );
    procedure LoadEnabled( Reader: TReader );
    procedure SaveEnabled( Writer: TWriter );
    procedure LoadSeparator( Reader: TReader );
    procedure SaveSeparator( Writer: TWriter );
    procedure LoadTooltip( Reader: TReader );
    procedure SaveTooltip( Writer: TWriter );
    procedure LoadVisible( Reader: TReader );
    procedure SaveVisible( Writer: TWriter );
    procedure LoadOnClick( Reader: TReader );
    procedure SaveOnClick( Writer: TWriter );
    procedure LoadPicture( Reader: TReader );
    procedure SavePicture( Writer: TWriter );
    procedure LoadSysImg( Reader: TReader );
    procedure SaveSysImg( Writer: TWriter );
    procedure LoadRadioGroup( Reader: TReader );
    procedure SaveRadioGroup( Writer: TWriter );
    procedure LoadImgIndex( Reader: TReader );
    procedure SaveImgIndex( Writer: TWriter );
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    function HasPicture: Boolean;
    property ToolbarComponent: TKOLToolbar read FToolbar;
  published
    property separator: Boolean read Fseparator write Setseparator;
    property dropdown: Boolean read Fdropdown write Setdropdown;
    property checked: Boolean read Fchecked write Setchecked;
    property Checkable: Boolean read FCheckable write SetCheckable;
    property radioGroup: Integer read FradioGroup write SetradioGroup;
    property picture: TPicture read Fpicture write Setpicture;
    property sysimg: TSystemToolbarImage read Fsysimg write Setsysimg;
    property imgIndex: Integer read FimgIndex write SetimgIndex;
    property visible: Boolean read Fvisible write Setvisible;
    property enabled: Boolean read Fenabled write Setenabled;
    property onClick: TOnToolbarButtonClick read FonClick write SetonClick;
    property caption: String read Fcaption write Setcaption;
    property tooltip: String read Ftooltip write Settooltip;
    property Tag: Boolean read fNotAvailable;
    property action: TKOLAction read Faction write Setaction;
  end;

  TKOLToolbar = class( TKOLControl )
  private
    FOptions: TToolbarOptions;
    Fbitmap: TBitmap;
    Fbuttons: String;
    FnoTextLabels: Boolean;
    Ftooltips: TStrings;
    FshowTooltips: Boolean;
    FmapBitmapColors: Boolean;
    fNotAvailable: Boolean;
    FTimer: TTimer;
    FItems: TList; // of TKOLToolbarButton
    FButtonCount: Integer;
    FStandardImagesLarge: Boolean;
    FgenerateConstants: Boolean;
    FbuttonMinWidth: Integer;
    FbuttonMaxWidth: Integer;
    FHeightAuto: Boolean;
    FimageListNormal: TKOLImageList;
    FimageListDisabled: TKOLImageList;
    FimageListHot: TKOLImageList;
    FFixFlatXP: Boolean;
    FTBButtonsWidth: Integer;
    FgenerateVariables: Boolean;
    FOnTBCustomDraw: TOnTBCustomDraw;
    FCompactCode: Boolean;
    FAutosizeButtons: Boolean;
    FNoSpaceForImages: Boolean;
    FAllowBitmapCompression: Boolean;
    procedure SetOptions(const Value: TToolbarOptions);
    procedure Setbitmap(const Value: TBitmap);
    procedure SetnoTextLabels(const Value: Boolean);
    procedure Settooltips(const Value: TStrings);
    procedure SetshowTooltips(const Value: Boolean);
    procedure SetmapBitmapColors(const Value: Boolean);
    procedure SetBtnCount_Dummy(const Value: Integer);
    function MaxBtnImgHeight: Integer;
    function MaxBtnImgWidth: Integer;
    procedure SetStandardImagesLarge(const Value: Boolean);
    procedure SetgenerateConstants(const Value: Boolean);
    procedure SetbuttonMaxWidth(const Value: Integer);
    procedure SetbuttonMinWidth(const Value: Integer);
    function GetButtons: String;
    procedure SetAutoHeight(const Value: Boolean);
    procedure UpdateButtons;
    procedure CMDesignHitTest(var Message: TCMDesignHitTest); message CM_DESIGNHITTEST;
    procedure WMLButtonDown(var Message: TWMLButtonDown); message WM_LBUTTONDOWN;
    procedure WMMouseMove(var Message: TWMMouseMove); message WM_MOUSEMOVE;
    procedure WMLButtonDblClk(var Message: TWMLButtonDblClk); message WM_LBUTTONDBLCLK;
    procedure SetimageList(const Value: TKOLImageList);
    procedure SetDisabledimageList(const Value: TKOLImageList);
    procedure SetHotimageList(const Value: TKOLImageList);
    procedure SetFixFlatXP(const Value: Boolean);
    procedure SetTBButtonsWidth(const Value: Integer);
    procedure SetgenerateVariables(const Value: Boolean);
    procedure SetOnTBCustomDraw(const Value: TOnTBCustomDraw);
    procedure SetCompactCode(const Value: Boolean);
    procedure SetAutosizeButtons(const Value: Boolean);
    procedure SetNoSpaceForImages(const Value: Boolean);
    procedure SetAllowBitmapCompression(const Value: Boolean);
  protected
    FResBmpID: Integer;
    fNewVersion: Boolean;
    FBmpTranColor: TColor;
    FBmpDesign: HBitmap;
    ValuesInStack: Integer;
    procedure SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupFirst( SL: TStringList; const AName, AParent, Prefix: String ); override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure P_SetupLast( SL: TStringList; const AName, AParent, Prefix: String ); override;
    procedure DefineProperties(Filer: TFiler); override;
    procedure ReadNewVersion( Reader: TReader );
    procedure WriteNewVersion( Writer: TWriter );
    procedure LoadButtonCount( R: TReader );
    procedure SaveButtonCount( W: TWriter );
  public
    procedure Loaded; override;
    function StandardImagesUsed: Integer;
    function PicturedButtonsCount: Integer;
    function ImagedButtonsCount: Integer;
    function NoMorePicturedButtonsFrom( Idx: Integer ): Boolean;
    function AllPicturedButtonsAreLeading: Boolean;
    function LastBtnHasPicture: Boolean;
    procedure CreateKOLControl(Recreating: boolean); override;
    procedure KOLControlRecreated; override;
    function NoDrawFrame: Boolean; override;
    procedure SetMargin(const Value: Integer); override;
    procedure Paint; override;
    function GetDefaultControlFont: HFONT; override;
    function ImageListsUsed: Boolean;
    function ButtonCaptionsList( var Cnt: Integer ): String;
    function ButtonImgIndexesList( var Cnt: Integer ): String;
  public
    function Generate_SetSize: String; override;
    function SupportsFormCompact: Boolean; override;
    function HasCompactConstructor: Boolean; override;
    procedure SetupConstruct_Compact; override;
  public
    ActiveDesign: TfmToolbarEditor;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    procedure Change; override;
    procedure Tick( Sender: TObject );
    property Items: TList read FItems;
    procedure Items2buttons;
    procedure DoGenerateConstants( SL: TStringList ); override;
    procedure NotifyLinkedComponent( Sender: TObject; Operation: TNotifyOperation ); override;
    function MaxImgIndex: Integer;
    function Pcode_Generate: Boolean; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
  published
    property Transparent;
    property Options: TToolbarOptions read FOptions write SetOptions;
    property bitmap: TBitmap read Fbitmap write Setbitmap;
    property buttons: String read GetButtons write Fbuttons;
    property OnTBDropDown;
    property OnClick;
    property OnTBCustomDraw: TOnTBCustomDraw read FOnTBCustomDraw write SetOnTBCustomDraw;
    property noTextLabels: Boolean read FnoTextLabels write SetnoTextLabels;
    property tooltips: TStrings read Ftooltips write Settooltips;
    property showTooltips: Boolean read FshowTooltips write SetshowTooltips;
    property mapBitmapColors: Boolean read FmapBitmapColors write SetmapBitmapColors;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property popupMenu;
    property Caption: Boolean read fNotAvailable;
    property HasBorder;

    property ButtonCount: Integer read FButtonCount write SetBtnCount_Dummy
             stored FALSE;
    procedure buttons2Items;
    procedure bitmap2ItemPictures( AnyWay: Boolean );
    procedure AssembleBitmap;
    procedure AssembleTooltips;
    procedure DesembleTooltips;
    property StandardImagesLarge: Boolean read FStandardImagesLarge write SetStandardImagesLarge;
    property generateConstants: Boolean read FgenerateConstants write SetgenerateConstants;
    property generateVariables: Boolean read FgenerateVariables write SetgenerateVariables;
    property TBButtonsMinWidth: Integer read FbuttonMinWidth write SetbuttonMinWidth;
    property TBButtonsMaxWidth: Integer read FbuttonMaxWidth write SetbuttonMaxWidth;
    property TBButtonsWidth: Integer read FTBButtonsWidth write SetTBButtonsWidth;
    property HeightAuto: Boolean read FHeightAuto write SetAutoHeight;
    property Brush;
    property Ctl3D;

    property imageListNormal: TKOLImageList read FimageListNormal write SetimageList;
    property imageListDisabled: TKOLImageList read FimageListDisabled write SetDisabledimageList;
    property imageListHot: TKOLImageList read FimageListHot write SetHotimageList;

    property FixFlatXP: Boolean read FFixFlatXP write SetFixFlatXP;
        // If TRUE (default) then some styles are changed in case of XP on start.
        // This useful (and necessary) only if XP Manifest is used in the application
        // in other case this property can be set to FALSE to make code smaller
        // and to prevent "heavy" property TRUE from usage.
        // This property has effect only for toolbars with tboFlat style though.
    property CompactCode: Boolean read FCompactCode write SetCompactCode;
    property AutosizeButtons: Boolean read FAutosizeButtons write SetAutosizeButtons;
    property NoSpaceForImages: Boolean read FNoSpaceForImages write SetNoSpaceForImages;
    property Autosize;
    property AllowBitmapCompression: Boolean read FAllowBitmapCompression write SetAllowBitmapCompression
             default TRUE;
  end;

  TKOLToolbarButtonsEditor = class( TStringProperty )
  private
  protected
  public
    function GetAttributes: TPropertyAttributes; override;
    procedure Edit; override;
  end;

  TKOLToolbarEditor = class( TComponentEditor )
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;

  TKOLToolButtonOnClickPropEditor = class( TMethodProperty )
  private
    FResetting: Boolean;
  protected
  public
    function GetValue: string; override;
    procedure SetValue(const AValue: string); override;
  end;


  //===========================================================================
  //---- MIRROR FOR A DATE TIME PICKER
  //---- ÇÅÐÊÀËÎ ÄËß ÂÂÎÄÀ ÄÀÒÛ È ÂÐÅÌÅÍÈ
  TKOLDateTimePicker = class( TKOLControl )
  private
    FOnDTPUserString: KOL.TDTParseInputEvent;
    FOptions: TDateTimePickerOptions;
    FFormat: String;
    FMonthBkColor: TColor;
    FMonthTxtColor: TColor;
    procedure SetOnDTPUserString(const Value: KOL.TDTParseInputEvent);
    procedure SetOptions(const Value: TDateTimePickerOptions);
    procedure SetFormat(const Value: String);
    procedure SetMonthBkColor(const Value: TColor);
    procedure SetMonthTxtColor(const Value: TColor);
  protected
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure P_SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; override;
  public
    function Pcode_Generate: Boolean; override;
    constructor Create( AOwner: TComponent ); override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    function TabStopByDefault: Boolean; override;
    property OnDTPUserString: KOL.TDTParseInputEvent read FOnDTPUserString write SetOnDTPUserString;
    property Options: TDateTimePickerOptions read FOptions write SetOptions;
    property Format: String read FFormat write SetFormat;
    property TabStop;
    property OnDropDown;
    property OnCloseUp;
    property OnChange;
    property MonthBkColor: TColor read FMonthBkColor write SetMonthBkColor;
    property MonthTxtColor: TColor read FMonthTxtColor write SetMonthTxtColor;
  end;



  //===========================================================================
  //---- MIRROR FOR A TAB CONTROL
  //---- ÇÅÐÊÀËÎ ÄËß ÒÀÁÓËÈÐÎÂÀÍÍÎÃÎ ÁËÎÊÍÎÒÀ
  TKOLTabPage = class(TKOLPanel)
      function TypeName: String; override;
  end;

  TKOLTabControl = class( TKOLControl )
  private
    FOptions: TTabControlOptions;
    FImageList: TKOLImageList;
  public FTabs: TList;
  protected
    FImageList1stIdx: Integer;
    FedgeType: TEdgeStyle;
    FCurPage: TKOLPanel;
    FgenerateConstants: Boolean;
    procedure SetOptions(const Value: TTabControlOptions);
    procedure SetImageList(const Value: TKOLImageList);
    function GetPages(Idx: Integer): TKOLPanel;
    procedure SetCount(const Value: Integer);
    function GetCount: Integer;
    procedure AdjustPages;
    function GetCurIndex: Integer;
    procedure SetCurIndex(const Value: Integer);
    procedure AttemptToChangePageBounds( Sender: TObject; var NewBounds: TRect );
    procedure SetImageList1stIdx(const Value: Integer);
    procedure SetedgeType(const Value: TEdgeStyle);
    procedure SetgenerateConstants(const Value: Boolean);
  protected
    fDestroyingTabControl: Boolean;
    FAdjustingPages: Boolean;
    function TabStopByDefault: Boolean; override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure P_SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure P_SetupLast(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure SchematicPaint;
  public
    procedure Paint; override;
    function WYSIWIGPaintImplemented: Boolean; override;
    function NoDrawFrame: Boolean; override;
    function GetCurrentPage: TKOLPanel;
    procedure DoGenerateConstants( SL: TStringList ); override;
  public
    function Pcode_Generate: Boolean; override;
    constructor Create( AOwner: TComponent ); override;
    destructor Destroy; override;
    property Pages[ Idx: Integer ]: TKOLPanel read GetPages;
    procedure SetBounds( aLeft, aTop, aWidth, aHeight: Integer ); override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
    function HasCompactConstructor: Boolean; override;
    function IndexOfPage( const page_name: String ): Integer;
  published
    property Transparent;
    property Options: TTabControlOptions read FOptions write SetOptions;
    property ImageList: TKOLImageList read FImageList write SetImageList;
    property ImageList1stIdx: Integer read FImageList1stIdx write SetImageList1stIdx;
    property Count: Integer read GetCount write SetCount;
    property Font;
    property CurIndex: Integer read GetCurIndex write SetCurIndex stored FALSE;
    property OnSelChange;
    property edgeType: TEdgeStyle read FedgeType write SetedgeType;
    property Border;
    property MarginTop;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property OnEnter;
    property OnLeave;
    property popupMenu;
    property OnKeyDown;
    property OnKeyUp;
    property OnChar;
    property OnKeyChar;
    property OnKeyDeadChar;
    property generateConstants: Boolean read FgenerateConstants write SetgenerateConstants;
    property OnDrawItem;
    property Brush;
  protected
    {fNameSetByReader: String;
    fNewTabControl: Boolean;
    procedure WhenReaderSetsName(Reader: TReader; Component: TComponent;
              var AName: string);
    procedure WhenFindComponentClass(Reader: TReader; const CClassName: string;
              var CComponentClass: TComponentClass);
    procedure ReadNewTabControl(Reader: TReader);
    procedure WriteNewTabControl(Writer: TWriter);
    procedure DefineProperties(Filer: TFiler); override;}
  public
    procedure Loaded; override;
  end;

  TKOLTabControlEditor = class( TComponentEditor )
  // This component editor is to provide easy page select on tab control with
  // double click on one of page indicators.
  private
  protected
  public
    procedure Edit; override;
    procedure ExecuteVerb(Index: Integer); override;
    function GetVerb(Index: Integer): string; override;
    function GetVerbCount: Integer; override;
  end;



  //===========================================================================
  //---- MIRROR FOR A SCROLL BOX
  //---- ÇÅÐÊÀËÎ ÄËß ÎÊÍÀ ÏÐÎÊÐÓÒÊÈ
  TScrollBars = ( ssNone, ssHorz, ssVert, ssBoth );

  TKOLScrollBox = class( TKOLControl )
  private
    FScrollBars: TScrollBars;
    FControlContainer: Boolean;
    FEdgeStyle: TEdgeStyle;
    fNotAvailable: Boolean;
    procedure SetScrollBars(const Value: TScrollBars);
    procedure SetControlContainer(const Value: Boolean);
    procedure SetEdgeStyle(const Value: TEdgeStyle);
  protected
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    function IsControlContainer: Boolean; virtual;
    function TypeName: String; override;
  public
    function Pcode_Generate: Boolean; override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    constructor Create( AOwner: TComponent ); override;
    property ScrollBars: TScrollBars read FScrollBars write SetScrollBars;
    property ControlContainer: Boolean read FControlContainer write SetControlContainer;
    property EdgeStyle: TEdgeStyle read FEdgeStyle write SetEdgeStyle;
    property popupMenu;
    property Border;
    property Caption: Boolean read fNotAvailable;
    property Enabled;
    property MarginBottom;
    property MarginLeft;
    property MarginRight;
    property MarginTop;
    property Transparent;
    property OnScroll;
    property Brush;
    property OverrideScrollbars;
  end;

  //===========================================================================
  //---- MIRROR FOR A SCROLL BAR
  //---- ÇÅÐÊÀËÎ ÄËß ÏÎËÎÑÛ ÏÐÎÊÐÓÒÊÈ
  TKOLScrollBar = class( TKOLControl )
  private
    FSBPageSize: Integer;
    FSBMin: Integer;
    FSBMax: Integer;
    FSBPosition: Integer;
    FSBbar: TScrollerBar;
    FOnSBBeforeScroll: TOnSBBeforeScroll;
    FOnSBScroll: TOnSBScroll;
    procedure SetSBMax(const Value: Integer);
    procedure SetSBMin(const Value: Integer);
    procedure SetSBPageSize(const Value: Integer);
    procedure SetSBPosition(const Value: Integer);
    procedure SetSBbar(const Value: TScrollerBar);
    procedure SetOnSBBeforeScroll(const Value: TOnSBBeforeScroll);
    procedure SetOnSBScroll(const Value: TOnSBScroll);
  protected
    procedure SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    procedure P_SetupFirst(SL: TStringList; const AName, AParent, Prefix: String); override;
    function SetupParams( const AName, AParent: TDelphiString): TDelphiString; override;
    function P_SetupParams( const AName, AParent: String; var nparams: Integer ): String; override;
    procedure AssignEvents( SL: TStringList; const AName: String ); override;
    function P_AssignEvents( SL: TStringList; const AName: String;
      CheckOnly: Boolean ): Boolean; override;
  public
    function Pcode_Generate: Boolean; override;
    constructor Create( AOwner: TComponent ); override;
    function SupportsFormCompact: Boolean; override;
    procedure SetupConstruct_Compact; override;
  published
    property popupMenu;
    property SBMin: Integer read FSBMin write SetSBMin;
    property SBMax: Integer read FSBMax write SetSBMax;
    property SBPageSize: Integer read FSBPageSize write SetSBPageSize;
    property SBPosition: Integer read FSBPosition write SetSBPosition;
    property SBbar: TScrollerBar read FSBbar write SetSBbar;
    property OnSBBeforeScroll: TOnSBBeforeScroll read FOnSBBeforeScroll write SetOnSBBeforeScroll;
    property OnSBScroll: TOnSBScroll read FOnSBScroll write SetOnSBScroll;
  end;

procedure Register;


implementation

uses mckCtrlDraw;

procedure Register;
begin
  RegisterComponents( 'KOL', [ TKOLButton, TKOLBitBtn, TKOLLabel, TKOLLabelEffect, TKOLPanel,
    TKOLSplitter, TKOLGradientPanel, TKOLGroupBox, TKOLCheckBox, TKOLRadioBox,
    TKOLEditBox, TKOLMemo, TKOLRichEdit, TKOLListBox, TKOLComboBox, TKOLPaintBox,
    TKOLProgressBar, TKOLListView, TKOLTreeView, TKOLToolbar, TKOLTabControl,
    TKOLTabPage, TKOLDateTimePicker, TKOLImageShow, TKOLScrollBox, TKOLScrollBar,
    TKOLMDIClient ] );
  RegisterPropertyEditor( TypeInfo( string ), TKOLToolbar, 'buttons',
                          TKOLToolbarButtonsEditor );
  RegisterPropertyEditor( TypeInfo( TOnToolbarButtonClick ), TKOLToolbarButton, 'onClick',
                          TKOLToolButtonOnClickPropEditor );
  RegisterPropertyEditor( TypeInfo( string ), TKOLListView, 'Columns',
                          TKOLLVColumnsPropEditor );
  RegisterComponentEditor( TKOLToolbar, TKOLToolbarEditor );
  RegisterComponentEditor( TKOLTabControl, TKOLTabControlEditor );
  RegisterComponentEditor( TKOLListView, TKOLLVColumnsEditor );
end;

{function CanMapBitmap( Bitmap: TBitmap ): Boolean;
var KOLBmp: KOL.PBitmap;
begin
  KOLBmp := NewDIBBitmap( Bitmap.Width, Bitmap.Height, KOL.pf32bit );
  TRY
    BitBlt( KOLBmp.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height,
            Bitmap.Canvas.Handle, 0, 0, SRCCOPY );
    KOLBmp.HandleType := KOL.bmDIB;
    KOLBmp.PixelFormat := KOL.pf32bit;
    case CountSystemColorsUsedInBitmap( KOLBmp ) of
    KOL.pf1bit, KOL.pf4bit, KOL.pf8bit: Result := TRUE;
    else                    Result := FALSE
    end;
    //Rpt( '!!!! CanMapBitmap: ' + IntToStr( Integer( Result ) ) );
  FINALLY
    KOLBmp.Free;
  END;
end;}
(*var BI: TBitmapInfo;
    C: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CanMapBitmap', 0
  @@e_signature:
  end;
  Result := TRUE;
  if Bitmap = nil then Exit;
  if (Bitmap.Width = 0) or (Bitmap.Height = 0) then Exit;
  {$IFNDEF _D2}
  if (Bitmap.HandleType = bmDIB) and not (Bitmap.PixelFormat in [pfCustom, pfDevice]) then
  begin
    //ShowMessage( 'format=' + IntToStr( Integer( Bitmap.PixelFormat ) ) );
    Result := Bitmap.PixelFormat in [ pf1bit, pf4bit, pf8bit ];
  end
    else
  {$ENDIF _D2}
  begin
    if Bitmap.Handle = 0 then
      Result := FALSE
    else
    begin
      if GetObject( Bitmap.Handle, Sizeof( BI ), @BI ) = 0 then
        Result := FALSE
      else
      begin
        C := BI.bmiHeader.biBitCount;
        Result := (C=1) or (C=4) or (C=8);
      end;
    end;
  end;
end;*)

{ TKOLButton }

function TKOLButton.CanChangeColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.CanChangeColor', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

function TKOLButton.CanNotChangeFontColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.CanNotChangeFontColor', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLButton.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.ClientMargins', 0
  @@e_signature:
  end;
  Result := Rect( 2, 2, 2, 2 );
end;

constructor TKOLButton.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.Create', 0
  @@e_signature:
  end;
  inherited;
  Fimage := TPicture.Create;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  fAutoSzX := 14;
  Height := 22; DefaultHeight := 22;
  TextAlign := taCenter;
  VerticalAlign := vaCenter;
  TabStop := True;
  FAllowBitmapCompression := TRUE;
end;

procedure TKOLButton.CreateKOLControl(Recreating: boolean);
begin
  inherited;
  FKOLCtrl:=NewButton(KOLParentCtrl, '');
end;

function TKOLButton.DefaultParentColor: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.DefaultParentColor', 0
  @@e_signature:
  end;
  Result := FALSE;
end;

procedure TKOLButton.DefineProperties(Filer: TFiler);
begin
  inherited;
  Filer.DefineProperty( 'ImageIcon', LoadImageIcon, SaveImageIcon,
                        Assigned( FImageIcon ) and not FImageIcon.Empty );
  Filer.DefineProperty( 'ImageBitmap', LoadImageBitmap, SaveImageBitmap,
                        Assigned( FImageBitmap ) and not FImageBitmap.Empty );
end;

destructor TKOLButton.Destroy;
begin
  FImageBitmap.Free;
  FImageIcon.Free;
  Fimage.Free;
  inherited;
end;

procedure TKOLButton.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLButton.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := inherited GenerateTransparentInits;
  if assigned( FimageIcon ) and not FimageIcon.Empty
    {$IFDEF _D2orD3}
       {$IFDEF ICON_DIFF_WH}
       and (FimageIcon.Width > 0) and (FimageIcon.Height > 0)
       {$ELSE}
       and (FImageIcon.Size > 0)
       {$ENDIF}
    {$ENDIF}
  then
  begin
      Rpt( 'Button has icon, generating code SetButtonIcon:'#13#10 + Result,
           WHITE );
      if
      {$IFDEF ICON_DIFF_WH}
      (FimageIcon.Width = 32) and (FimageIcon.Height = 32)
      {$ELSE}
      FImageIcon.Size = 32
      {$ENDIF}
      then
      Result := Result + '.SetButtonIcon( LoadIcon( hInstance, ''' +
             ImageResourceName + ''' ) )'
      else
      Result := Result + '.SetButtonIcon( LoadImage( hInstance, ''' +
             ImageResourceName + ''', IMAGE_ICON, ' +
             {$IFDEF ICON_DIFF_WH}
             Int2Str( FimageIcon.Width ) + ', ' + Int2Str( FimageIcon.Height ) +
             {$ELSE}
             Int2Str( FimageIcon.Size ) + ', ' + Int2Str( FimageIcon.Size ) +
             {$ENDIF}
             ', LR_SHARED ) )'
  end
    else
  if Assigned( FimageBitmap ) and not FimageBitmap.Empty then
  begin
    Rpt( 'Button has bitmap, generating code SetBittonBitmap', WHITE );
    Result := Result + '.SetButtonBitmap( LoadBitmap( hInstance, ''' +
           ImageResourceName + ''' ) )';
  end;
end;

procedure TKOLButton.GenerateTransparentInits_Compact;
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  KF = nil then Exit;
  if  not KF.FormCompact then Exit;
  if assigned( FimageIcon ) and not FimageIcon.Empty
    {$IFDEF _D2orD3}
       {$IFDEF ICON_DIFF_WH}
       and (FimageIcon.Width > 0) and (FimageIcon.Height > 0)
       {$ELSE}
       and (FImageIcon.Size > 0)
       {$ENDIF}
    {$ENDIF}
  then
  begin
      if
      {$IFDEF ICON_DIFF_WH}
      (FimageIcon.Width = 32) and (FimageIcon.Height = 32)
      {$ELSE}
      FImageIcon.Size = 32
      {$ENDIF}
      then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetButtonIcon', '' );
          KF.FormAddStrParameter( ImageResourceName );
      end
          else
      begin
          KF.FormAddCtlCommand( Name, 'FormSetButtonImage', '' );
          {$IFDEF ICON_DIFF_WH}
          KF.FormAddNumParameter( FImageIcon.Width );
          {$ELSE}
          KF.FormAddNumParameter( FImageIcon.Size );
          {$ENDIF}
          KF.FormAddNumParameter( FImageIcon.Size );
          KF.FormAddStrParameter( ImageResourceName );
      end;
  end
    else
  if Assigned( FimageBitmap ) and not FimageBitmap.Empty then
  begin
      KF.FormAddCtlCommand( Name, 'FormSetButtonBitmap', '' );
      KF.FormAddStrParameter( ImageResourceName );
  end;
end;

function TKOLButton.ImageResourceName: String;
begin
  Result := 'Z' + UpperCase( ParentForm.Name ) + '_' + UpperCase( Name ) + '_IMAGE';
end;

procedure TKOLButton.Loaded;
begin
  inherited;
  {if Assigned( FImageIcon ) and not FImageIcon.Empty and Assigned( Image.Graphic )
     and (Image.Graphic is TIcon) and
     ((Image.Icon.Width <> 32)or(Image.Icon.Height <> 32)) then
  begin
    FImageIcon.Assign( Image.Icon );
    if FImageIcon.Width = 32 then
      ShowMessage( 'wayay Loaded:32' );
  end;}
  {else
  if Assigned( FImageBitmap ) and not FImageBitmap.Empty then
    Image.Graphic.Assign( FImageBitmap );}
end;

procedure TKOLButton.LoadImageBitmap(Reader: TReader);
var Strm: TMemoryStream;
    s: String;
    i: Integer;
    B: Byte;
begin
  FImageBitmap.Free;
  FImageBitmap := TBitmap.Create;
  s := Reader.ReadString;
  Strm := TMemoryStream.Create;
  TRY
    for i := 1 to Length( s ) do
      if i and 1 = 1 then
      begin
        B := Hex2Int( Copy( s, i, 2  ) );
        Strm.Write( B, 1 );
      end;
    TRY
      Strm.Position := 0;
      FImageBitmap.LoadFromStream( Strm );
    EXCEPT
      FImageBitmap.Free;
      FImageBitmap := nil;
    END;
  FINALLY
    Strm.Free;
  END;
end;

procedure TKOLButton.LoadImageIcon(Reader: TReader);
var Strm: KOL.PStream;
    s: String;
    i: Integer;
    B: Byte;
    Sz: Integer;
begin
  FImageIcon.Free;
  FImageIcon := NewIcon;
  s := Reader.ReadString;
  Strm := NewMemoryStream;
  TRY
    Strm.Capacity := Length( s ) div 2;
    for i := 1 to Length( s ) do
      if i and 1 = 1 then
      begin
        B := Hex2Int( Copy( s, i, 2  ) );
        Strm.Write( B, 1 );
      end;
    TRY
      Strm.Position := 0;
      Sz := 0;
      Strm.Read( Sz, 1 );
      FImageIcon.Size := Sz;
      FImageIcon.LoadFromStream( Strm );
      FImageIcon.Size := Sz;
      FImageIcon.Size := Sz;
      {if FImageIcon.Width = 32 then
        ShowMessage( 'wayay LoadImageIcon:32' );}
    EXCEPT
      FImageIcon.Free;
      FImageIcon := nil;
    END;
  FINALLY
    Strm.Free;
  END;
end;

function TKOLButton.NoDrawFrame: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLButton.Paint;
begin
  if not (Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames])) then begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawButton( Self, Canvas );
  end;
  inherited;
end;

function TKOLButton.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLButton.P_GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.P_GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := inherited P_GenerateTransparentInits;
  if assigned( FimageIcon ) and not FImageIcon.Empty
    {$IFDEF _D2orD3}
       {$IFDEF ICON_DIFF_WH}
       and (Fimageicon.Width > 0) and (Fimageicon.Height > 0)
       {$ELSE}
       and (FImageIcon.Size > 0)
       {$ENDIF}
    {$ENDIF}
   then
  begin
      //Result := Result + '.SetButtonIcon( LoadIcon( hInstance, ''' +
      //       ImageResourceName + ''' ) )';
      {P}Result := Result + ' LoadAnsiStr ''' +
             ImageResourceName + ''' #0 Load_hInstance LoadIcon RESULT ' +
             'C2 TControl.SetButtonIcon<2> DelAnsiStr';
      Rpt( 'Button has icon, generating Pcode SetButtonIcon:'#13#10 + Result,
        WHITE );
  end
    else
  if Assigned( FimageBitmap ) and not FimageBitmap.Empty then
  begin
    Rpt( 'Button has bitmap, generating Pcode SetBittonBitmap', WHITE );
    //Result := Result + '.SetButtonBitmap( LoadBitmap( hInstance, ''' +
    //       ImageResourceName + ''' ) )';
    {P}Result := Result + ' LoadAnsiStr ''' +
           ImageResourceName + ''' #0 Load_hInstance LoadBitmap<2>' +
           ' C2 TControl.SetButtonBitmap<2> DelAnsiStr';
  end;
  if LikeSpeedButton then
    //Result := Result + '.LikeSpeedButton';
    {P}Result := Result + ' DUP TControl.LikeSpeedButton<1>';
  {P}Result := Result + ' xySwap DelAnsiStr';
end;

procedure TKOLButton.P_SetupColor(SL: TStrings; const AName: String; var ControlInStack: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.P_SetupColor', 0
  @@e_signature:
  end;
  // there are no setup color for TKOLButton:
  if ClassName = 'TKOLButton' then Exit;
  inherited;
end;

procedure TKOLButton.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var Updated: Boolean;
    TmpIcon: TIcon;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Flat then
    if Windowed then
      //SL.Add( Prefix + AName + '.Style := ' + AName + '.Style or BS_FLAT;' )
      {P}SL.Add( ' DUP AddWord_LoadRef ##TControl_.fStyle L(' + IntToStr( BS_FLAT ) +
                 ') | C1 TControl_.SetStyle<2>' )
    else
      //SL.Add( Prefix + AName + '.Flat := TRUE;' );
      {P}SL.Add( ' L(1) C1 TControl_.SetFlat<2>' );

  if assigned( FimageIcon ) and not Fimageicon.Empty
    {$IFDEF _D2orD3}
       {$IFDEF ICON_DIFF_WH}
       and (Fimageicon.Width > 0) and (Fimageicon.Height > 0)
       {$ELSE}
       and (FImageIcon.Size > 0)
       {$ENDIF}
    {$ENDIF}
  then
  begin
      Rpt( 'Button has icon, generate resource', WHITE );
      SL.Add( '{$R ' + ImageResourceName + '.res}' );
      TmpIcon := TIcon.Create;
      TRY
        TmpIcon.Handle := DuplicateIcon( hInstance, FImageIcon.Handle );
        GenerateIconResource( TmpIcon, ImageResourceName, ImageResourceName,
                             Updated );
        TmpIcon.Handle := 0;
      FINALLY
        TmpIcon.Free;
      END;
  end
    else
  if Assigned( FimageBitmap ) and not FimageBitmap.Empty then
  begin
    Rpt( 'Button has bitmap, generate resource', WHITE );
    GenerateBitmapResource( FimageBitmap, ImageResourceName, ImageResourceName,
                         Updated, AllowBitmapCompression );
  end;
end;

procedure TKOLButton.P_SetupFont(SL: TStrings; const AName: String);
var BFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.P_SetupFont', 0
  @@e_signature:
  end;
  if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm <> nil) then
    BFont := ParentKOLForm.Font
  else
  if (ParentKOLControl <> nil) and (ParentKOLControl is TKOLCustomControl) then
    BFont := (ParentKOLControl as TKOLCustomControl).Font
  else
    BFont := nil;
  if BFont = nil then Exit;
  BFont.Color := Font.Color;
  if not Font.Equal2( BFont ) then
    Font.P_GenerateCode( SL, AName, BFont );
end;

function TKOLButton.P_SetupParams(const AName, AParent: String; var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  if action = nil then
    Result := P_StringConstant('Caption',Caption)
  else
    Result := ' LoadAnsiStr #0 ';
  //Result := AParent + ', ' + C;
  {P}Result := Result +
               #13#10' C2';
end;

procedure TKOLButton.P_SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.P_SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taCenter then
    //SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
    //{P}SL.Add( 'L(' + IntToStr( Integer( TextAlign ) ) + ')' +
    //  ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
    //  Name + ' TControl_.SetTextAlign<2>' );
    {P}SL.Add( 'L(' + IntToStr( Integer( TextAlign ) ) + ')' +
      ' C1 TControl_.SetTextAlign<2>' );
  if VerticalAlign <> vaCenter then
    //SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
    //{P}SL.Add( 'L(' + IntToStr( VerticalAlignAsKOLVerticalAlign ) + ')' +
    //  ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
    //  Name + ' TControl_.SetVerticalAlign<2>' );
    {P}SL.Add( 'L(' + IntToStr( VerticalAlignAsKOLVerticalAlign ) + ')' +
      ' C1 TControl_.SetVerticalAlign<2>' );
end;

procedure TKOLButton.SaveImageBitmap(Writer: TWriter);
var Strm: TMemoryStream;
    s, h: String;
    B: Byte;
begin
  Strm := TMemoryStream.Create;
  TRY
    FImageBitmap.SaveToStream( Strm );
    SetLength( s, Strm.Size * 2 );
    Strm.Position := 0;
    s := '';
    while Strm.Position < Strm.Size do
    begin
      Strm.Read( B, 1 );
      h := Int2Hex( B, 2 );
      s := s + h;
    end;
    Writer.WriteString( s );
  FINALLY
    Strm.Free;
  END;
end;

procedure TKOLButton.SaveImageIcon(Writer: TWriter);
var Strm: KOL.PStream;
    s, h: String;
    B: Byte;
    Sz: Integer;
begin
  Strm := NewMemoryStream;
  TRY
    {$IFDEF ICON_DIFF_WH}
    Sz := FImageIcon.Width;
    {$ELSE}
    Sz := FImageIcon.Size;
    {$ENDIF}
    Strm.Write( Sz, 1 );
    FImageIcon.SaveToStream( Strm );
    {if FImageIcon.Width = 32 then
      ShowMessage( 'wayay SaveImageIcon:32' );}

    SetLength( s, Strm.Size * 2 );
    Strm.Position := 0;
    s := '';
    while Strm.Position < Strm.Size do
    begin
      Strm.Read( B, 1 );
      h := Int2Hex( B, 2 );
      s := s + h;
    end;
    Writer.WriteString( s );
  FINALLY
    Strm.Free;
  END;
end;

procedure TKOLButton.SetAllowBitmapCompression(const Value: Boolean);
begin
  if  FAllowBitmapCompression = Value then Exit;
  FAllowBitmapCompression := Value;
  Change;
end;

procedure TKOLButton.SetFlat(const Value: Boolean);
begin
  FFlat := Value;
  Change;
end;

procedure TKOLButton.Setimage(const Value: TPicture);
begin
  Fimage.Assign( Value );
  if ( csLoading in ComponentState ) then Exit;
  if Assigned( FImage.Graphic ) and (FImage.Graphic is TBitmap) then
  begin
    Free_And_Nil( FimageIcon );
    if FimageBitmap = nil then
      FImageBitmap := TBitmap.Create;
    FimageBitmap.Assign( FImage.Bitmap );
  end
    else
  if Assigned( FImage.Graphic ) and (FImage.Graphic is TIcon) then
  begin
    FImageBitmap.Free;
    FImageBitmap := nil;
    if FimageIcon = nil then
      FImageIcon := NewIcon;
    FImageIcon.Handle := DuplicateIcon( hInstance, FImage.Icon.Handle );
    {if FImageIcon.Size = 32 then
      ShowMessage( 'wayay Setmage:32' );}
  end
    else
  begin
     FImageBitmap.Free;
     FImageBitmap := nil;
     Free_And_Nil( FimageIcon );
  end;
  Change;
end;

procedure TKOLButton.SetupColor(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupColor', 0
  @@e_signature:
  end;
  // there are no setup color for TKOLButton:
  if ClassName = 'TKOLButton' then Exit;
  inherited;
end;

procedure TKOLButton.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewButton', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
end;

procedure TKOLButton.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var Updated: Boolean;
    TmpIcon: TIcon;
    KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  Flat then
      if  Windowed then
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormSetStyle', '' );
              KF.FormAddNumParameter( BS_FLAT );
          end else
          SL.Add( Prefix + AName + '.Style := ' + AName + '.Style or BS_FLAT;' )
  else if  (KF <> nil) and KF.FormCompact then
       begin
           KF.FormAddCtlCommand( Name, 'TControl.SetFlat', '' );
           // param = 1
       end else
       SL.Add( Prefix + AName + '.Flat := TRUE;' );

  if  WordWrap and Windowed then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetStyle', '' );
          KF.FormAddNumParameter( BS_MULTILINE );
      end else
      SL.Add( Prefix + AName + '.Style := ' + AName + '.Style or BS_MULTILINE;' );

  if  assigned( FimageIcon ) and not FimageIcon.Empty
      {$IFDEF _D2orD3}
       {$IFDEF ICON_DIFF_WH}
       and (Fimageicon.Width > 0) and (Fimageicon.Height > 0)
       {$ELSE}
       and (FImageIcon.Size > 0)
       {$ENDIF}
      {$ENDIF}
  then
  begin
      Rpt( 'Button has icon, generate resource', WHITE );
      if  (KF <> nil) and KF.FormCompact then
      begin
          (SL as TFormStringList).OnAdd := nil;
          SL.Add( '{$R ' + ImageResourceName + '.res}' );
          (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
      end
        else
          SL.Add( '{$R ' + ImageResourceName + '.res}' );
      TmpIcon := TIcon.Create;
      TRY
        TmpIcon.Handle := DuplicateIcon( hInstance, FImageIcon.Handle );
        GenerateIconResource( TmpIcon, ImageResourceName, ImageResourceName,
                             Updated );
      FINALLY
        TmpIcon.Free;
      END;
  end
     else
  if  Assigned( FimageBitmap ) and not FimageBitmap.Empty then
  begin
      Rpt( 'Button has bitmap, generate resource', WHITE );
      if  (KF <> nil) and KF.FormCompact then
      begin
          (SL as TFormStringList).OnAdd := nil;
          SL.Add( '{$R ' + ImageResourceName + '.res}' );
          (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
      end
        else
          SL.Add( '{$R ' + ImageResourceName + '.res}' );
      GenerateBitmapResource( FimageBitmap, ImageResourceName, ImageResourceName,
                          Updated, AllowBitmapCompression );
  end;
end;

procedure TKOLButton.SetupFont(SL: TStrings; const AName: String);
var BFont: TKOLFont;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupFont', 0
  @@e_signature:
  end;
  if (ParentKOLControl = ParentKOLForm) and (ParentKOLForm <> nil) then
    BFont := ParentKOLForm.Font
  else
  if (ParentKOLControl <> nil) and (ParentKOLControl is TKOLCustomControl) then
    BFont := (ParentKOLControl as TKOLCustomControl).Font
  else
    BFont := nil;
  if BFont = nil then Exit;
  BFont.Color := Font.Color;
  if not Font.Equal2( BFont ) then
    Font.GenerateCode( SL, AName, BFont );
end;

function TKOLButton.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupParams', 0
  @@e_signature:
  end;
  if (action = nil) and
     (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     C := StringConstant('Caption', Caption)
  else
     C := '''''';
{$IFDEF _D2009orHigher}
 if  C <> '''''' then
 begin
     C2 := '';
     for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
     C := C2;
 end;
{$ENDIF}
  Result := AParent + ', ' + C;
end;

procedure TKOLButton.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.SetupTextAlign', 0
  @@e_signature:
  end;

  if  TextAlign <> taCenter then
      GenerateTextAlign( SL, AName );

  if  VerticalAlign <> vaCenter then
      GenerateVerticalAlign( SL, AName );
end;

function TKOLButton.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLButton.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLButton.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
end;

function TKOLButton.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;  
end;

{ TKOLLabel }

function TKOLLabel.AdjustVerticalAlign(
  Value: TVerticalAlign): TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLButton.AdjustVerticalAlign', 0
  @@e_signature:
  end;
  if (Value = vaBottom) and Windowed and not( csLoading in ComponentState ) then
  begin
    Result := vaCenter;
    if  not (csLoading in ComponentState) then
        ShowMessage( 'Windowed Label can not be aligned bottom !' );
  end
  else
    Result := Value;
end;

procedure TKOLLabel.CallInheritedPaint;
begin
  inherited Paint;
end;

constructor TKOLLabel.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Create', 0
  @@e_signature:
  end;
  inherited;
  fAutoSzX := 1;
  fAutoSzY := 1;
  Height := 22; DefaultHeight := 22;
  fTabOrder := -1;
end;

procedure TKOLLabel.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLLabel.GetTaborder: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.GetTaborder', 0
  @@e_signature:
  end;
  Result := //-1;
            inherited GetTaborder;
end;

function TKOLLabel.Get_VertAlign: TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Get_VertAlign', 0
  @@e_signature:
  end;
  Result := inherited VerticalAlign;
end;

procedure TKOLLabel.Loaded;
begin
  inherited;
  VerticalAlign := VerticalAlign;
end;

procedure TKOLLabel.Paint;
var
  R:TRect;
  Flag:DWord;
  TMPBrushStyle: TBrushStyle;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Paint', 0
  @@e_signature:
  end;

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;
  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end;

  case VerticalAlign of
    vaTop: Flag:=Flag or DT_TOP;
    vaBottom: Flag:=Flag or DT_BOTTOM;
    vaCenter: Flag:=Flag or DT_VCENTER or DT_SINGLELINE;
  end;

  if (WordWrap) and (not AutoSize or (Align in [ caClient, caTop, caBottom ])) then
      Flag:=Flag or DT_WORDBREAK;

  PrepareCanvasFontForWYSIWIGPaint( Canvas );

  TMPBrushStyle := Canvas.Brush.Style;
  Canvas.Brush.Style := bsClear;
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);
  Canvas.Brush.Style :=TMPBrushStyle;

  inherited;

end;

function TKOLLabel.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLLabel.P_GenerateTransparentInits: String;
begin
  Result := ' xySwap DelAnsiStr ' + inherited P_GenerateTransparentInits;
end;

procedure TKOLLabel.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if ShowAccelChar then
    //SL.Add( Prefix + AName + '.Style := ' + AName + '.Style and not SS_NOPREFIX;' );
    begin
      {P}SL.Add( ' DUP AddWord_LoadRef ##TControl_.fStyle' );
      {P}SL.Add( ' L(' + IntToStr( SS_NOPREFIX ) + ') ~ &' );
      {P}SL.Add( ' C1 TControl_.SetStyle<2>' );
    end;
end;

function TKOLLabel.P_SetupParams(const AName, AParent: String; var nParams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.P_SetupParams', 0
  @@e_signature:
  end;
  //Result := AParent + ', ' + StringConstant('Caption', Caption);
  nparams := 2;
  {P}Result := P_StringConstant( 'Caption', Caption ) + ' C2';
end;

procedure TKOLLabel.P_SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.P_SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taLeft then
    //SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') C1 TControl_.SetTextAlign<2>' );
  if VerticalAlign <> vaTop then
    //SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( VerticalAlignAsKOLVerticalAlign ) + ') C1 TControl_.SetVerticalAlign<2>' );
end;

procedure TKOLLabel.SetShowAccelChar(const Value: Boolean);
begin
  FShowAccelChar := Value;
  Change;
end;

procedure TKOLLabel.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
   inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewLabel', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
end;

procedure TKOLLabel.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  ShowAccelChar then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormResetStyles', '' );
          KF.FormAddNumParameter( SS_NOPREFIX );
      end else
      SL.Add( Prefix + AName + '.Style := ' + AName + '.Style and not SS_NOPREFIX;' );
end;

function TKOLLabel.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupParams', 0
  @@e_signature:
  end;
 if  (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     C := StringConstant('Caption', Caption)
 else
     C := '''''';
{$IFDEF _D2009orHigher}
 if  C <> '''''' then
 begin
     C2 := '';
     for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
     C := C2;
 end;
{$ENDIF}
 Result := AParent + ', ' + C;
end;

procedure TKOLLabel.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.SetupTextAlign', 0
  @@e_signature:
  end;
  if  TextAlign <> taLeft then
      GenerateTextAlign( SL, AName );

  if  VerticalAlign <> vaTop then
      GenerateVerticalAlign( SL, AName );
end;

procedure TKOLLabel.Set_VertAlign(const Value: TVerticalAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.Set_VertAlign', 0
  @@e_signature:
  end;
  inherited VerticalAlign := AdjustVerticalAlign( Value );
end;

function TKOLLabel.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLLabel.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
end;

function TKOLLabel.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabel.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLPanel }

function TKOLPanel.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.ClientMargins', 0
  @@e_signature:
  end;
  case edgeStyle of
  esLowered: Result := Rect( 1, 1, 1, 1 );
  esRaised:  Result := Rect( 3, 3, 3, 3 );
  //esNone, esTransparent, esSolid:
  else Result := Rect( 0, 0, 0, 0 );
  end;
end;

constructor TKOLPanel.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 100; DefaultWidth := Width;
  Height := 100; DefaultHeight := 100;
  //ControlStyle := ControlStyle + [ csAcceptsControls ];
  AcceptChildren := TRUE;
end;

destructor TKOLPanel.Destroy;
var P: TKOLTabControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Destroy', 0
  @@e_signature:
  end;
  if Parent <> nil then
  if Parent is TKOLTabControl then
  begin
    P:=Parent as TKOLTabControl;
    if (P.FCurPage=self) and (P.CurIndex>0) then P.CurIndex:=pred(P.CurIndex);
    P.Invalidate;
  end;
  inherited;
end;

function TKOLPanel.Get_VA: TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Get_VA', 0
  @@e_signature:
  end;
  Result := inherited VerticalAlign;
end;

function TKOLPanel.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := not(EdgeStyle in [esNone,esTransparent,esSolid]) or
         (Parent <> nil) and (Parent is TKOLTabControl);
end;

procedure TKOLPanel.Paint;
var
  R:TRect;
  Flag,EdgeFlag:DWord;
  Delta:Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Paint', 0
  @@e_signature:
  end;

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;

  case edgeStyle of
    esRaised:
    begin
      EdgeFlag:=EDGE_RAISED;
      Delta:=3;
    end;

    esLowered:
    begin
      EdgeFlag:=BDR_SUNKENOUTER;
      Delta:=1;
    end;

    //esNone, esTransparent, esSolid:
    else
    begin
      EdgeFlag:=0;
      Delta:=0;
    end;
  end; //case

  if Delta <> 0 then
  begin
    DrawEdge(Canvas.Handle,R,EdgeFlag,BF_RECT or BF_MIDDLE );
    R.Left:=Delta;
    R.Top:=Delta;
    R.Right:=Width-Delta;
    R.Bottom:=Height-Delta;
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );
  end;

  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end; //case

  case VerticalAlign of
    vaTop: Flag:=Flag or DT_TOP or DT_SINGLELINE;
    vaBottom: Flag:=Flag or DT_BOTTOM or DT_SINGLELINE;
    vaCenter: Flag:=Flag or DT_VCENTER or DT_SINGLELINE;
  end; //case

  Flag:=Flag+DT_WORDBREAK;

  if not( (Parent <> nil) and (Parent is TKOLTabControl) ) then
  begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);
  end;

  inherited;
end;

function TKOLPanel.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLPanel.P_SetupConstruct(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.P_SetupConstruct', 0
  @@e_signature:
  end;
  if Parent <> nil then
  if Parent is TKOLTabControl then
    Exit; // this is not a panel, but a tab page on tab control.
  inherited;
end;

procedure TKOLPanel.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Parent <> nil then
  if Parent is TKOLTabControl then
    Exit; // this is not a panel, but a tab page on tab control.
  if Caption <> '' then
    //SL.Add( Prefix + AName + '.Caption := ' + StringConstant('Caption', Caption) + ';' );
    {P}SL.Add( P_StringConstant('Caption', Caption) +
       ' C2 TControl_.SetCaption<2> DelAnsiStr' );
  if ShowAccelChar then
    //SL.Add( Prefix + AName + '.Style := ' + AName + '.Style and not SS_NOPREFIX;' );
    {P}SL.Add( ' L(' + IntToStr( not SS_NOPREFIX ) + ') ' +
      ' C1 AddWord_LoadRef ##TControl_.fStyle & C2 TControl_.SetStyle<2>' );
end;

function TKOLPanel.P_SetupParams(const AName, AParent: String; var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.P_SetupParams', 0
  @@e_signature:
  end;
  //Result := AParent + ', ' + EdgeStyles[ EdgeStyle ];
  {P}Result := ' L(' + IntToStr( Integer( EdgeStyle ) ) + ') ' +
    //' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' + Remove_Result_dot( AParent )
    ' C1';
  nparams := 2;
end;

procedure TKOLPanel.P_SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.P_SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taLeft then
    //SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
      ' C1 TControl_.SetTextAlign<2>' );
  if VerticalAlign <> vaTop then
    //SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( VerticalAlignAsKOLVerticalAlign ) + ') ' +
      ' C1 TControl_.SetVerticalAlign<2>' );
end;

function TKOLPanel.RefName: String;
var J: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.RefName', 0
  @@e_signature:
  end;
  Result := inherited RefName;
  if Parent is TKOLTabControl then
  begin
    for J := 0 to (Parent as TKOLTabControl).Count - 1 do
      if (Parent as TKOLTabControl).Pages[ J ] = Self then
      begin
        Result := (Parent as TKOLTabControl).RefName + '.Pages[ ' + IntToStr( J ) + ' ]';
        break;
      end;
  end;
end;

procedure TKOLPanel.SetCaption(const Value: TDelphiString);
begin
  inherited;
  if (Parent <> nil) and (Parent is TKOLTabControl) then
    Parent.Invalidate;
end;

procedure TKOLPanel.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetEdgeStyle', 0
  @@e_signature:
  end;
  if FEdgeStyle = Value then Exit;
  FEdgeStyle := Value;
  Change;
  ReAlign( FALSE );
  Invalidate;
end;

procedure TKOLPanel.SetShowAccelChar(const Value: Boolean);
begin
  FShowAccelChar := Value;
  Change;
end;

procedure TKOLPanel.SetupConstruct(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupConstruct', 0
  @@e_signature:
  end;
  if Parent <> nil then
  if Parent is TKOLTabControl then
    Exit; // this is not a panel, but a tab page on tab control.
  inherited;
end;

procedure TKOLPanel.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewPanel', TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( EdgeStyle ) );
end;

procedure TKOLPanel.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var KF: TKOLForm;
    C: String;
{$IFDEF _D2009orHigher}
    C2: WideString;
    i : integer;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Parent <> nil then
  if Parent is TKOLTabControl then
    Exit; // this is not a panel, but a tab page on tab control.
  KF := ParentKOLForm;
  if  (Caption <> '') and (KF <> nil) and KF.AssignTextToControls then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetCaption', '' );
          KF.FormAddStrParameter( Caption );
      end
        else
      begin
          C := StringConstant('Caption', Caption);
          {$IFDEF _D2009orHigher}
          C2 := '';
          for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
          C := C2;
          {$ENDIF}
          SL.Add( Prefix + AName + '.Caption := ' + C + ';' );
      end;
  end;

  if  ShowAccelChar then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormResetStyles', '' );
          KF.FormAddNumParameter( SS_NOPREFIX );
      end else
      SL.Add( Prefix + AName + '.Style := ' + AName + '.Style and not SS_NOPREFIX;' );
end;

function TKOLPanel.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
const EdgeStyles: array[ TEdgeStyle ] of String =
  ( 'esRaised', 'esLowered', 'esNone', 'esTransparent', 'esSolid' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + EdgeStyles[ EdgeStyle ];
end;

procedure TKOLPanel.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.SetupTextAlign', 0
  @@e_signature:
  end;
  if  TextAlign <> taLeft then
      GenerateTextAlign( SL, AName );

  if  VerticalAlign <> vaTop then
      GenerateVerticalAlign( SL, AName );
end;

procedure TKOLPanel.Set_VA(const Value: TVerticalAlign);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.Set_VA', 0
  @@e_signature:
  end;
  if  Value = vaBottom then
  begin
      if  not (csLoading in ComponentState) then
          ShowMessage( 'Panel text can not be aligned bottom !' );
      inherited VerticalAlign := vaCenter
  end else
      inherited VerticalAlign := Value;
end;

function TKOLPanel.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLPanel.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPanel.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLBitBtn }

procedure TKOLBitBtn.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnTestMouseOver' ], [ @OnTestMouseOver ] );
end;

procedure TKOLBitBtn.AutoSizeNow;
var TmpBmp: graphics.TBitmap;
    W, H, I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.AutoSizeNow', 0
  @@e_signature:
  end;
  if fAutoSizingNow then Exit;
  fAutoSizingNow := TRUE;
  TmpBmp := graphics.TBitmap.Create;
  try
    TmpBmp.Width := 10;
    TmpBmp.Height := 10;
    //Rpt( 'TmpBmp.Width=' + IntToStr( TmpBmp.Width ) + ' TmpBmp.Height=' + IntToStr( TmpBmp.Height ) );
    TmpBmp.Canvas.Font.Name := Font.FontName;
    TmpBmp.Canvas.Font.Style := TFontStyles(Font.FontStyle);
    if Font.FontHeight > 0 then
      TmpBmp.Canvas.Font.Height := Font.FontHeight
    else
    if Font.FontHeight < 0 then
      TmpBmp.Canvas.Font.Size := - Font.FontHeight
    else
      TmpBmp.Canvas.Font.Size := 0;
    W := TmpBmp.Canvas.TextWidth( Caption );
    if fsItalic in TFontStyles( Font.FontStyle ) then
      Inc( W, TmpBmp.Canvas.TextWidth( ' ' ) );
    H := TmpBmp.Canvas.TextHeight( 'Ap^_' );
    //Rpt( 'W=' + IntToStr( W ) + ' H=' + IntToStr( H ) );
    if Align in [ caNone, caLeft, caRight ] then
    begin
      if (glyphBitmap.Width > 0) and (glyphBitmap.Height > 0) then
      begin
        I := glyphBitmap.Width;
        if glyphCount > 1 then
          I := I div glyphCount;
        if glyphLayout in [ glyphLeft, glyphRight ] then
          W := W + I
        else
          if W < I then
            W := I;
      end;
      if not (bboNoBorder in options) then
        Inc( W, 4 );
      Width := W + fAutoSzX;
    end;
    if Align in [ caNone, caTop, caBottom ] then
    begin
      if (glyphBitmap.Width > 0) and (glyphBitmap.Height > 0) then
      begin
        I := glyphBitmap.Height;
        if glyphLayout in [ glyphTop, glyphBottom ] then
          H := H + I + fAutoSzY
        else
          H := I;
      end;
      if not (bboNoBorder in options) then
        Inc( H, 4 );
      Height := H; // + fAutoSzY;
    end;
  finally
    TmpBmp.Free;
    fAutoSizingNow := FALSE;
  end;
end;

function TKOLBitBtn.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.ClientMargins', 0
  @@e_signature:
  end;
  Result := Rect( 3, 3, 3, 3 );
end;

constructor TKOLBitBtn.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.Create', 0
  @@e_signature:
  end;
  inherited;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  fAutoSzX := 8;
  fAutoSzY := 8;
  FGlyphBitmap := TBitmap.Create;
  Height := 22; DefaultHeight := 22;
  DefaultWidth := Width;
  TextAlign := taCenter;
  VerticalAlign := vaCenter;
  TabStop := True;
  fTextShiftX := 1;
  fTextShiftY := 1;
  FAllowBitmapCompression := TRUE;
end;

procedure TKOLBitBtn.CreateKOLControl(Recreating: boolean);
begin
  inherited;
  FKOLCtrl:=NewBitBtn(KOLParentCtrl, '', [], glyphLeft, 0, 0);
end;

destructor TKOLBitBtn.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.Destroy', 0
  @@e_signature:
  end;
  FGlyphBitmap.Free;
  if ImageList <> nil then
    ImageList.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

procedure TKOLBitBtn.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLBitBtn.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.GenerateTransparentInits', 0
  @@e_signature:
  end;
  if autoAdjustSize then
  begin
    DefaultWidth := Width;
    DefaultHeight := Height;
  end;
  Result := inherited GenerateTransparentInits;
  if LikeSpeedButton then
    Result := Result + '.LikeSpeedButton';
end;

procedure TKOLBitBtn.GenerateTransparentInits_Compact;
var KF: TKOLForm;
begin
  if autoAdjustSize then
  begin
      DefaultWidth := Width;
      DefaultHeight := Height;
  end;
  inherited;
  KF := ParentKOLForm;
  if  (KF = nil) or not KF.FormCompact then Exit;
  if  LikeSpeedButton then
      KF.FormAddCtlCommand( Name, 'TControl.LikeSpeedButton', '' );
end;

function TKOLBitBtn.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLBitBtn.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
    ImageList := nil;
end;

function TKOLBitBtn.OptionsAsInteger: Integer;
begin
  Result := 0;
  if bboImageList in Options then Result := 1;
  if bboNoBorder  in Options then Result := Result + 2;
  if bboNoCaption in Options then Result := Result + 4;
  if bboFixed     in Options then Result := Result + 8;
  if bboFocusRect in Options then Result := Result + 16;
end;

function TKOLBitBtn.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLBitBtn.P_AssignEvents(SL: TStringList; const AName: String; CheckOnly: Boolean): Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.P_AssignEvents', 0
  @@e_signature:
  end;
  Result := inherited P_AssignEvents( SL, AName, CheckOnly );
  if Result and CheckOnly then Exit;
  Result := Result or
  P_DoAssignEvents( SL, AName, [ 'OnTestMouseOver' ], [ @OnTestMouseOver ], [ TRUE ], CheckOnly );
end;

function TKOLBitBtn.P_GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.GenerateTransparentInits', 0
  @@e_signature:
  end;
  if autoAdjustSize then
  begin
    DefaultWidth := Width;
    DefaultHeight := Height;
  end;
  Result := inherited P_GenerateTransparentInits;
  if LikeSpeedButton then
    //Result := Result + '.LikeSpeedButton';
    {P}Result := Result + ' DUP TControl.LikeSpeedButton<1>';
  Result := Result + ' xySwap DelAnsiStr';
end;

procedure TKOLBitBtn.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var RName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.P_SetupFirst', 0
  @@e_signature:
  end;
  if ImageList = nil then
  if Assigned( GlyphBitmap ) and
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    RName := ParentKOLForm.FormName + '_' + Name;
    Rpt( 'Prepare resource ' + RName + ' (' + UpperCase( Name + '_BITMAP' ) + ')',
      WHITE );
    GenerateBitmapResource( GlyphBitmap, UpperCase( Name + '_BITMAP' ), RName,
        fUpdated, AllowBitmapCompression );
    SL.Add( Prefix + '{$R ' + RName + '.res}' );
  end
    else
  begin
    P_ProvideFakeType( SL, 'type TImageList_ = object(TImageList) end;' );
  end;
  inherited;
  if (Height = DefaultHeight) or autoAdjustSize then
  if imageList <> nil then
  if ImageIndex >= 0 then
    //SL.Add( Prefix + AName + '.Height := ' + IntToStr( Height ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( Height ) + ') C1 TControl_.SetHeight<2>' );
  if (Width = DefaultWidth) or autoAdjustSize then
  if imageList <> nil then
  if ImageIndex >= 0 then
    //SL.Add( Prefix + AName + '.Width := ' + IntToStr( Width ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( Width ) + ') C1 TControl_.SetWidth<2>' );
  if RepeatInterval > 0 then
    //SL.Add( Prefix + AName + '.RepeatInterval := ' + IntToStr( RepeatInterval ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( RepeatInterval ) + ') C1 AddWord_Store ##TControl_.fRepeatInterval' );
  if Flat then
    //SL.Add( Prefix + AName + '.Flat := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetFlat<2>' );
  if BitBtnDrawMnemonic then
    //SL.Add( Prefix + AName + '.BitBtnDrawMnemonic := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetBitBtnDrawMnemonic<2>' );
  if TextShiftX <> 0 then
    //SL.Add( Prefix + AName + '.TextShiftX := ' + IntToStr( TextShiftX ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( TextShiftX ) + ') ' +
       'C1 AddWord_Store ##TControl_.fTextShiftX' );
  if TextShiftY <> 0 then
    //SL.Add( Prefix + AName + '.TextShiftY := ' + IntToStr( TextShiftY ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( TextShiftY ) + ') ' +
       'C1 AddWord_Store ##TControl_.fTextShiftY' );
end;

function TKOLBitBtn.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var S, U, C: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.P_SetupParams', 0
  @@e_signature:
  end;
  S := ' L(0)';
  U := ' L(0)';
  if (GlyphBitmap <> nil) and
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    //S := 'LoadBmp( hInstance, ' + String2Pascal(UpperCase( Name + '_BITMAP' )) +
    //     ', Result )';
    {P}S := ' LoadAnsiStr ' + P_String2Pascal( UpperCase( Name + '_BITMAP' ) ) +
            #13#10' LoadSELF xySwap' +
            #13#10' Load_hInstance LoadBmp<3> RESULT xySwap DelAnsiStr' ;
    //U := IntToStr( GlyphCount );
    {P}U := ' L(' + IntToStr( GlyphCount ) + ')';
  end
    else
  if (ImageList <> nil) then
  begin
    if ImageList.ParentFORM.Name = ParentForm.Name then
      //S := 'Result.' + ImageList.Name + '.Handle'
      {P}S := ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
        ImageList.Name + ' TImageList_.GetHandle<1> RESULT'
    else //S := ImageList.ParentFORM.Name +'.'+ ImageList.Name + '.Handle';
      {P}S := ' Load4 ####(' + ImageList.ParentForm.Name + ') ' +
        #13#10'AddWord_LoadRef ##T' + ImageList.ParentForm.Name + '.' + ImageList.Name +
        ' TImageList_.GetHandle<1> RESULT';
    if GlyphCount > 0 then
      //U := '$' + Int2Hex( GlyphCount shl 16, 5 ) + ' + ' + IntToStr( ImageIndex )
      {P}U := ' L($' + Int2Hex( GlyphCount shl 16, 5 ) + ' + ' + IntToStr( ImageIndex ) +
              ')'
    else
      //U := IntToStr( ImageIndex );
      {P}U := ' L(' + IntToStr( ImageIndex ) + ')';
  end;
  if action = nil then
    C := P_StringConstant('Caption',Caption)
  else
    C := ' LoadAnsiStr #0 ';
  //Result := AParent + ', ' + C + ', ' +
  //          BitBtnOptions( Options ) + ', ' +
  //          Layouts[ GlyphLayout ] + ', ' + S + ', ' + U;
  {P}Result :=
    C + ' C2R' +
    #13#10' L(' + IntToStr( Integer( GlyphLayout ) ) + ') ' +
    #13#10 + S +
    #13#10 + U +
    #13#10' L(' + IntToStr( OptionsAsInteger ) + ') R2C' +
    #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
               Remove_Result_dot( AParent );
  nparams := 6;
end;

procedure TKOLBitBtn.P_SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taCenter then
    //SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') C1 ' +
      ' TControl_.SetTextAlign<2>' );
  if VerticalAlign <> vaCenter then
    //SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( VerticalAlignAsKOLVerticalAlign ) + ') C1 ' +
      ' TControl_.SetVerticalAlign<2>' );
end;

procedure TKOLBitBtn.RecalcSize;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.RecalcSize', 0
  @@e_signature:
  end;
  if (ImageList <> nil) or
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    DefaultWidth := 0;
    DefaultHeight := 0;
  end
     else
  begin
    DefaultWidth := 64;
    DefaultHeight := 22;
  end;
end;

procedure TKOLBitBtn.SetAllowBitmapCompression(const Value: Boolean);
begin
  if  FAllowBitmapCompression = Value then Exit;
  FAllowBitmapCompression := Value;
  Change;
end;

procedure TKOLBitBtn.SetautoAdjustSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetautoAdjustSize', 0
  @@e_signature:
  end;
  FautoAdjustSize := Value;
  Change;
end;

procedure TKOLBitBtn.SetBitBtnDrawMnemonic(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetBitBtnDrawMnemonic', 0
  @@e_signature:
  end;
  FBitBtnDrawMnemonic := Value;
  Change;
end;

procedure TKOLBitBtn.SetFlat(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetFlat', 0
  @@e_signature:
  end;
  FFlat := Value;
  Change;
end;

procedure TKOLBitBtn.SetGlyphBitmap(const Value: TBitmap);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetGlyphBitmap', 0
  @@e_signature:
  end;
  if (Value <> nil) and (not Value.Empty) then
  begin
    FGlyphBitmap.Assign( Value );
    FOptions := FOptions - [bboImageList];
    FImageList := nil;
  end
    else
  begin
    {FGlyphBitmap.Width := 0;
    FGlyphBitmap.Height := 0;}
    FGlyphBitmap.Free;
    FGlyphBitmap := TBitmap.Create;
  end;
  FGlyphCount := 0;
  if FGlyphBitmap.Height > 0 then
    FGlyphCount := FGlyphBitmap.Width div FGlyphBitmap.Height;
  RecalcSize;
  if (DefaultWidth <> 0) and (DefaultHeight <> 0) then
  begin
    Width := DefaultWidth;
    Height := DefaultHeight;
  end;
  Change;
end;

procedure TKOLBitBtn.SetGlyphCount(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetGlyphCount', 0
  @@e_signature:
  end;
  if Value < 0 then
    Value := 0;
  if Value > 5 then
    Value := 5;
  if Value = FGlyphCount then Exit;
  FGlyphCount := Value;
  Change;
end;

procedure TKOLBitBtn.SetGlyphLayout(const Value: TGlyphLayout);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetGlyphLayout', 0
  @@e_signature:
  end;
  FGlyphLayout := Value;
  if AutoSize then
    AutoSizeNow;
  Change;
end;

procedure TKOLBitBtn.SetImageIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetImageIndex', 0
  @@e_signature:
  end;
  FImageIndex := Value;
  Change;
end;

procedure TKOLBitBtn.SetImageList(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetImageList', 0
  @@e_signature:
  end;
  if FImageList <> nil then
    FImageList.NotifyLinkedComponent( Self, noRemoved );
  FImageList := Value;
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    FGlyphBitmap.Width := 0;
    FGlyphBitmap.Height := 0;
    FOptions := FOptions + [bboImageList];
    Value.AddToNotifyList( Self );
  end
     else
    FOptions := FOptions - [bboImageList];
  Change;
end;

procedure TKOLBitBtn.SetOnTestMouseOver(const Value: TOnTestMouseOver);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetOnTestMouseOver', 0
  @@e_signature:
  end;
  FOnTestMouseOver := Value;
  Change;
end;

procedure TKOLBitBtn.SetOptions(Value: TBitBtnOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetOptions', 0
  @@e_signature:
  end;
  Value := Value - [ bboImageList ];
  if Assigned( ImageList ) then
    Value := Value + [bboImageList];
  FOptions := Value;
  Change;
end;

function BitBtnOptions( Options: TBitBtnOptions ): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'BitBtnOptions', 0
  @@e_signature:
  end;
  Result := '';
  if bboImageList in Options then
    Result := 'bboImageList, ';
  if bboNoBorder in Options then
    Result := Result + 'bboNoBorder, ';
  if bboNoCaption in Options then
    Result := Result + 'bboNoCaption, ';
  if bboFixed in Options then
    Result := Result + 'bboFixed, ';
  if bboFocusRect in Options then
    Result := Result + 'bboFocusRect, ';
  Result := Trim( Result );
  if Result <> '' then
    Result := Copy( Result, 1, Length( Result ) - 1 );
  Result := '[ ' + Result + ' ]';
end;

procedure TKOLBitBtn.SetRepeatInterval(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetRepeatInterval', 0
  @@e_signature:
  end;
  FRepeatInterval := Value;
  Change;
end;

procedure TKOLBitBtn.SetTextShiftX(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetTextShiftX', 0
  @@e_signature:
  end;
  FTextShiftX := Value;
  Change;
end;

procedure TKOLBitBtn.SetTextShiftY(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetTextShiftY', 0
  @@e_signature:
  end;
  FTextShiftY := Value;
  Change;
end;

procedure TKOLBitBtn.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewBitBtn', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
    KF.FormAddNumParameter( OptionsAsInteger );
    KF.FormAddNumParameter( Integer( GlyphLayout ) );
    if (GlyphBitmap <> nil) and
       (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
    begin
        KF.FormAddStrParameter( Name + '_BITMAP' );
        KF.FormAddNumParameter( GlyphCount );
    end
      else
    begin
        KF.FormAddStrParameter( '' );
        KF.FormAddNumParameter( 0 );
    end;
end;

procedure TKOLBitBtn.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var RName: String;
    KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupFirst', 0
  @@e_signature:
  end;

  KF := ParentKOLForm;

  if ImageList = nil then
  if Assigned( GlyphBitmap ) and
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    RName := ParentKOLForm.FormName + '_' + Name;
    Rpt( 'Prepare resource ' + RName + ' (' + UpperCase( Name + '_BITMAP' ) +
      ')', WHITE );
    GenerateBitmapResource( GlyphBitmap, UpperCase( Name + '_BITMAP' ), RName, fUpdated,
                            AllowBitmapCompression );
    if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
    begin
        (SL as TFormStringList).OnAdd := nil;
        SL.Add( Prefix + '{$R ' + RName + '.res}' );
        (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
    end else
    SL.Add( Prefix + '{$R ' + RName + '.res}' );
  end;

  inherited;
  if  (Height = DefaultHeight) or autoAdjustSize then
  if  imageList <> nil then
  if  ImageIndex >= 0 then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetHeight', '' );
          KF.FormAddNumParameter( Height );
      end else
      SL.Add( Prefix + AName + '.Height := ' + IntToStr( Height ) + ';' );

  if  (Width = DefaultWidth) or autoAdjustSize then
  if  imageList <> nil then
  if  ImageIndex >= 0 then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetWidth', '' );
          KF.FormAddNumParameter( Width );
      end else
      SL.Add( Prefix + AName + '.Width := ' + IntToStr( Width ) + ';' );

  if  RepeatInterval > 0 then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRepeatInterval', '' );
          KF.FormAddNumParameter( RepeatInterval );
      end else
      SL.Add( Prefix + AName + '.RepeatInterval := ' + IntToStr( RepeatInterval ) + ';' );

  if  Flat then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetFlat', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.Flat := TRUE;' );

  if  BitBtnDrawMnemonic then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetBitBtnDrawMnemonic', '' );
      end else
      SL.Add( Prefix + AName + '.BitBtnDrawMnemonic := TRUE;' );

  if  TextShiftX <> 0 then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTextShiftX', '' );
          KF.FormAddNumParameter( TextShiftX );
      end else
      SL.Add( Prefix + AName + '.TextShiftX := ' + IntToStr( TextShiftX ) + ';' );

  if  TextShiftY <> 0 then
      if  (KF <> nil) and KF.FormCompact and SupportsFormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTextShiftY', '' );
          KF.FormAddNumParameter( TextShiftY );
      end else
      SL.Add( Prefix + AName + '.TextShiftY := ' + IntToStr( TextShiftY ) + ';' );

end;

function TKOLBitBtn.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
const Layouts: array[ TGlyphLayout ] of String = ( 'glyphLeft', 'glyphTop',
               'glyphRight', 'glyphBottom', 'glyphOver' );
var
 S, U: String;
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupParams', 0
  @@e_signature:
  end;
  S := '0';
  U := '0';
  if (GlyphBitmap <> nil) and
     (GlyphBitmap.Width <> 0) and (GlyphBitmap.Height <> 0) then
  begin
    S := 'LoadBmp( hInstance, ' + String2Pascal(UpperCase( Name + '_BITMAP' ), '+') +
         ', Result )';
    U := IntToStr( GlyphCount );
  end
    else
  if (ImageList <> nil) then
  begin
    if ImageList.ParentFORM.Name = ParentForm.Name then
      S := 'Result.' + ImageList.Name + '.Handle'
    else S := ImageList.ParentFORM.Name +'.'+ ImageList.Name + '.Handle';
    if GlyphCount > 0 then
      U := '$' + Int2Hex( GlyphCount shl 16, 5 ) + ' + ' + IntToStr( ImageIndex )
    else
      U := IntToStr( ImageIndex );
  end;
  if (action = nil) and
     (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     C := StringConstant('Caption', Caption)
  else
     C := '''''';
  {$IFDEF _D2009orHigher}
   if C <> '''''' then
   begin
      C2 := '';
      for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
      C := C2;
   end;
  {$ENDIF}
  Result := AParent + ', ' + C + ', ' +
            BitBtnOptions( Options ) + ', ' +
            Layouts[ GlyphLayout ] + ', ' + S + ', ' + U;
end;

procedure TKOLBitBtn.SetupTextAlign(SL: TStrings; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.SetupTextAlign', 0
  @@e_signature:
  end;

  if  TextAlign <> taCenter then
      GenerateTextAlign( SL, AName );

  if  VerticalAlign <> vaCenter then
      GenerateVerticalAlign( SL, AName );
end;

function TKOLBitBtn.SupportsFormCompact: Boolean;
begin
    Result := ImageList = nil;
end;

function TKOLBitBtn.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLGradientPanel }

constructor TKOLGradientPanel.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 40; DefaultWidth := Width;
  Height := 40; DefaultHeight := Height;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  FColor1 := clBlue;
  FColor2 := clNavy;
  //Transparent := TRUE;
  gradientLayout := glTop;
  gradientStyle := gsVertical;
end;

function TKOLGradientPanel.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLGradientPanel.Paint;

  function Ceil( X: Double ): Integer;
  begin
    Result := Round( X );
  end;
const
  SQRT2 = 1.4142135623730950488016887242097;
  
var
//  R:TRect;
//  Flag:DWord;
//  Delta: Integer;
  CR:TRect;
  W,H,WH,I:Integer;
  BMP:TBitmap;
  C:TColor;
  R,G,B,R1,G1,B1:Byte;

  RC, RF, R0: TRect;
   C2: TColor;
  R2, G2, B2: Integer;
  DX1, DX2, DY1, DY2, DR, DG, DB, K: Double;
//  PaintStruct: TPaintStruct;
  Br: HBrush;
  Rgn: HRgn;
  Poly: array[ 0..3 ] of TPoint;
//  OldPaintDC: HDC;
//  RRR:TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.Paint', 0
  @@e_signature:
  end;

  PrepareCanvasFontForWYSIWIGPaint( Canvas );
  case fGradientStyle of
    gsHorizontal,gsVertical:
    begin
  CR := ClientRect;
  W := 1;
  H := CR.Bottom;
  WH := H;
  //Bmp := nil;
  if fGradientStyle = gsHorizontal then
  begin
    W := CR.Right;
    H := 1;
    WH := W;
  end;
  Bmp :=TBitmap.Create();
  Bmp.Width:=W;
  Bmp.Height:=H;
  C := Color2RGB( fColor1 );
  R := C shr 16;
  G := (C shr 8) and $FF;
  B := C and $FF;
  C := Color2RGB( fColor2 );
  R1 := C shr 16;
  G1 := (C shr 8) and $FF;
  B1 := C and $FF;
  for I := 0 to WH-1 do
  begin
    C := ((( R + (R1 - R) * I div WH ) and $FF) shl 16) or
         ((( G + (G1 - G) * I div WH ) and $FF) shl 8) or
         ( B + (B1 - B) * I div WH ) and $FF;

    if fGradientStyle = gsVertical then
      Bmp.Canvas.Pixels[0,I]:=C
    else
      Bmp.Canvas.Pixels[I,0]:=C;
  end;
  Canvas.StretchDraw(CR,BMP);
  Bmp.Free; {YS}//! Memory leak fix
  end;

  gsRectangle, gsRombic, gsElliptic:
  begin

    C := Color2RGB( fColor2 );
    R2 := C and $FF;
    G2 := (C shr 8) and $FF;
    B2 := (C shr 16) and $FF;
    C := Color2RGB( fColor1 );
    R1 := C and $FF;
    G1 := (C shr 8) and $FF;
    B1 := (C shr 16) and $FF;
    DR := (R2 - R1) / 256;
    DG := (G2 - G1) / 256;
  DB := (B2 - B1) / 256;
  {OldPaintDC :=} Canvas.handle;//fPaintDC;
//  Self_.fPaintDC := Msg.wParam;
//  if Self_.fPaintDC = 0 then
//    Self_.fPaintDC := BeginPaint( Self_.fHandle, PaintStruct );
  RC := ClientRect;
  case fGradientStyle of
  gsRombic:
    RF := MakeRect( 0, 0, RC.Right div 128, RC.Bottom div 128 );
  gsElliptic:
    RF := MakeRect( 0, 0, Ceil( RC.Right / 256 * SQRT2 ), Ceil( RC.Bottom / 256 * SQRT2 ) );
  else
    RF := MakeRect( 0, 0, RC.Right div 256, RC.Bottom div 256 );
  end;
  case fGradientStyle of
  gsRectangle, gsRombic, gsElliptic:
    begin
      case FGradientLayout of
      glCenter, glTop, glBottom:
        OffsetRect( RF, (RC.Right - RF.Right) div 2, 0 );
      glTopRight, glBottomRight, glRight:
        OffsetRect( RF, RC.Right - RF.Right div 2, 0 );
      glTopLeft, glBottomLeft, glLeft:
        OffsetRect( RF, -RF.Right div 2, 0 );
      end;
      case FGradientLayout of
      glCenter, glLeft, glRight:
        OffsetRect( RF, 0, (RC.Bottom - RF.Bottom) div 2 );
      glBottom, glBottomLeft, glBottomRight:
        OffsetRect( RF, 0, RC.Bottom - RF.Bottom div 2 );
      glTop, glTopLeft, glTopRight:
        OffsetRect( RF, 0, -RF.Bottom div 2 );
      end;
    end;
  end;
  DX1 := (-RF.Left) / 255;
  DY1 := (-RF.Top) / 255;
  DX2 := (RC.Right - RF.Right) / 255;
  DY2 := (RC.Bottom - RF.Bottom) / 255;
  case fGradientStyle of
  gsRombic, gsElliptic:
    begin
      if DX2 < -DX1 then DX2 := -DX1;
      if DY2 < -DY1 then DY2 := -DY1;
      K := 2;
      if fGradientStyle = gsElliptic then K := SQRT2;
      DX2 := DX2 * K;
      DY2 := DY2 * K;
      DX1 := -DX2;
      DY1 := -DY2;
    end;
  end;
  C2 := C;
  for I := 0 to 255 do
  begin
    if (I < 255) then
    begin
      C2 := TColor( (( Ceil( B1 + DB * (I+1) ) and $FF) shl 16) or
          (( Ceil( G1 + DG * (I+1) ) and $FF) shl 8) or
           Ceil( R1 + DR * (I+1) ) and $FF );
      if (fGradientStyle in [gsRombic,gsElliptic,gsRectangle]) and
         (C2 = C) then continue;
    end;
    Br := CreateSolidBrush( C );
    R0 := MakeRect( Ceil( RF.Left + DX1 * I ),
                    Ceil( RF.Top + DY1 * I ),
                    Ceil( RF.Right + DX2 * I ),
                    Ceil( RF.Bottom + DY2 * I ) );
    Rgn := 0;
    case fGradientStyle of
    gsRectangle:
      Rgn := CreateRectRgnIndirect( R0 );
    gsRombic:
      begin
        Poly[ 0 ].x := R0.Left;
        Poly[ 0 ].y := R0.Top + (R0.Bottom - R0.Top) div 2;
        Poly[ 1 ].x := R0.Left + (R0.Right - R0.Left) div 2;
        Poly[ 1 ].y := R0.Top;
        Poly[ 2 ].x := R0.Right;
        Poly[ 2 ].y := Poly[ 0 ].y;
        Poly[ 3 ].x := Poly[ 1 ].x;
        Poly[ 3 ].y := R0.Bottom;
        Rgn := CreatePolygonRgn( Poly[ 0 ].x, 4, ALTERNATE );
      end;
    gsElliptic:
      Rgn := CreateEllipticRgnIndirect( R0 );
    end;
    if Rgn <> 0 then
    begin
      if Rgn <> NULLREGION then
      begin
        Windows.FillRgn({ fPaintDC}Canvas.Handle, Rgn, Br );
        ExtSelectClipRgn( {fPaintDC}Canvas.Handle, Rgn, RGN_DIFF );
      end;
      DeleteObject( Rgn );
    end;
    DeleteObject( Br );
    C := C2;
  end;
//  if Self_.fPaintDC <> HDC( Msg.wParam ) then
//    EndPaint( Self_.fHandle, PaintStruct );
//  Self_.fPaintDC := OldPaintDC;

  end;

  end; //case

  inherited;

end;

function TKOLGradientPanel.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLGradientPanel.P_SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if GradientStyle = gsHorizontal then
    //SL.Add( Prefix + AName + '.GradientStyle := gsHorizontal;' );
    {P}SL.Add( ' L(' + IntToStr( Integer( gsHorizontal ) ) + ') C1 ' +
      'TControl_.SetGradientStyle<2>' );
  if HasBorder then
    //SL.Add( Prefix + AName + '.HasBorder := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetHasBorder<2>' );
end;

const
    GradientLayouts: array[ TGradientLayout ] of String = ( 'glTopLeft',
                      'glTop', 'glTopRight',
                      'glLeft', 'glCenter', 'glRight',
                      'glBottomLeft', 'glBottom', 'glBottomRight' );
    GradientStyles: array[ TGradientStyle ] of String = (
                    'gsVertical', 'gsHorizontal', 'gsRectangle', 'gsElliptic', 'gsRombic',
                    'gsTopToBottom', 'gsBottomToTop' );
function TKOLGradientPanel.P_SetupParams(const AName,
  AParent: String; var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetupParams', 0
  @@e_signature:
  end;
  nparams := 3;
  Result := '';
  //Result := AParent + ', ' + Color2Str( FColor1 ) + ', ' + Color2Str( FColor2 );
  if TypeName <> 'GradientPanel' then
  begin
    {P}Result := ' L(' + IntToStr( Integer( GradientLayout ) ) + ')' +
      ' L(' + IntToStr( Integer( GradientStyle ) ) + ')';
    nparams := 5;
  end;
  Result := Result + ' L($' + IntToHex( FColor2, 6 ) + ')' +
    #13#10' L($' + IntToHex( FColor1, 6 ) + ')' +
    #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
      Remove_Result_dot( AParent );
end;

procedure TKOLGradientPanel.SetColor1(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetColor1', 0
  @@e_signature:
  end;
  FColor1 := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetColor2(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetColor2', 0
  @@e_signature:
  end;
  FColor2 := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetgradientLayout(
  const Value: TGradientLayout);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetgradientLayout', 0
  @@e_signature:
  end;
  FgradientLayout := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetgradientStyle(const Value: TGradientStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetgradientStyle', 0
  @@e_signature:
  end;
  FgradientStyle := Value;
  Invalidate;
  Change;
end;

procedure TKOLGradientPanel.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNew' + TypeName, TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( (Color1 shl 1) or (Color1 shr 31) ) );
    KF.FormAddNumParameter( Integer( (Color2 shl 1) or (Color2 shr 31) ) );
    if  TypeName = 'GradientPanelEx' then
    begin
        KF.FormAddNumParameter( Integer( GradientStyle ) );
        KF.FormAddNumParameter( Integer( GradientLayout ) );
    end;
end;

procedure TKOLGradientPanel.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  TypeName = 'GradientPanel' then
      if  GradientStyle >= gsHorizontal then
          if  (KF <> nil) and KF.FormCompact then
          begin
              if  Integer( GradientStyle ) = 1 then
              begin
                  KF.FormAddCtlCommand( Name, 'TControl.SetGradientStyle', '' );
                  // Param = 1 
              end
                else
              begin
                  KF.FormAddCtlCommand( Name, 'FormSetGradienStyle', '' );
                  KF.FormAddNumParameter( Integer( GradientStyle ) );
              end;
          end else
          SL.Add( Prefix + AName + '.GradientStyle := KOL.' +
                  GradientStyles[ GradientStyle ] + ';' );
  if  HasBorder then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetHasBorder', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.HasBorder := TRUE;' );
end;

function TKOLGradientPanel.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + Color2Str( FColor1 ) + ', ' + Color2Str( FColor2 );
  if TypeName <> 'GradientPanel' then
    //if GradientStyle >= gsHorizontal then
      Result := Result + ', KOL.' + GradientStyles[ gradientStyle ] + ', ' +
             GradientLayouts[ GradientLayout ];
end;

function TKOLGradientPanel.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLGradientPanel.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLGradientPanel.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if (GradientStyle in [ gsRombic, gsElliptic ]) or
     (gradientLayout <> glTop) and
     not(GradientStyle in [ gsTopToBottom, gsBottomToTop ]) then
    Result := 'GradientPanelEx';
end;

function TKOLGradientPanel.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLGroupBox }

function TKOLGroupBox.ClientMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.ClientMargins', 0
  @@e_signature:
  end;
  Result := Rect( 0, 0, 0, 0 );
end;

constructor TKOLGroupBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 100; DefaultWidth := Width;
  Height := 100; DefaultHeight := 100;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  DefaultMarginTop := 22;   MarginTop := 22;
  DefaultMarginLeft := 2;   MarginLeft := 2;
  DefaultMarginRight := 2;  MarginRight := 2;
  DefaultMarginBottom := 2; MarginBottom := 2;
  FHasBorder := FALSE; FDefHasBorder := FALSE;
  AcceptChildren := TRUE;
end;

{$IFDEF _KOLCtrlWrapper_} {YS}
procedure TKOLGroupBox.CreateKOLControl(Recreating: boolean);
begin
  inherited;
  FKOLCtrl := NewGroupbox(KOLParentCtrl, '');
end;
{$ENDIF}

function TKOLGroupBox.DrawMargins: TRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.DrawMargins', 0
  @@e_signature:
  end;
  Result := Rect( 4, 18, 4, 4 );
  if Font <> nil then
  if Font.FontHeight > 0 then
    Result.Top := Font.FontHeight;
end;

procedure TKOLGroupBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLGroupBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLGroupBox.P_GenerateTransparentInits: String;
begin
  Result := ' xySwap DelAnsiStr ' + inherited P_GenerateTransparentInits;
end;

procedure TKOLGroupBox.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if TextAlign <> taLeft then
    //SL.Add( Prefix + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
      ' C1 TControl_.SetTextAlign<2>' );
end;

function TKOLGroupBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.P_SetupParams', 0
  @@e_signature:
  end;
  //Result := AParent + ', ' + StringConstant('Caption',Caption);
  nparams := 2;
  {P}Result := P_StringConstant('Caption',Caption) +
               //'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
               //Remove_Result_dot( AParent )
               ' C2';
end;

procedure TKOLGroupBox.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewGroupBox', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
end;

procedure TKOLGroupBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
{const
  TextAligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  {if TextAlign <> taLeft then
    SL.Add( Prefix + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );}
end;

function TKOLGroupBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.SetupParams', 0
  @@e_signature:
  end;
 if  (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     C := StringConstant('Caption', Caption)
 else
     C := '''''';
{$IFDEF _D2009orHigher}
 if  C <> '''''' then
 begin
     C2 := '';
     for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
     C := C2;
 end;
{$ENDIF}
  Result := AParent + ', ' + C;
end;

procedure TKOLGroupBox.SetupTextAlign(SL: TStrings; const AName: String);
begin
    if  TextAlign <> taLeft then
        GenerateTextAlign( SL, AName );
end;

function TKOLGroupBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLGroupBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGroupBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLCheckBox }

constructor TKOLCheckBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.Create', 0
  @@e_signature:
  end;
  inherited;
  fTabstop := TRUE;
  fAutoSzX := 20;
  Width := 72; DefaultWidth := Width;
  Height := 22; DefaultHeight := 22;
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
end;

procedure TKOLCheckBox.CreateKOLControl(Recreating: boolean);
begin
  inherited;
  if Auto3State then
    FKOLCtrl:=NewCheckBox3State(KOLParentCtrl, '')
  else
    FKOLCtrl:=NewCheckbox(KOLParentCtrl, '');
end;

procedure TKOLCheckBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLCheckBox.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLCheckBox.Paint;
begin
  if not (Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames])) then begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawCheckBox( Self, Canvas );
  end;  
  inherited;
end;

function TKOLCheckBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLCheckBox.P_GenerateTransparentInits: String;
begin
  Result := ' xySwap DelAnsiStr ' + inherited P_GenerateTransparentInits;
end;

procedure TKOLCheckBox.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Checked and (action = nil) then
    //SL.Add( Prefix + AName + '.Checked := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetChecked<2>');
end;

function TKOLCheckBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  {if action = nil then
    C := StringConstant('Caption',Caption)
  else
    C := '''''';}
  if action = nil then
    Result := P_StringConstant('Caption',Caption)
  else
    Result := ' LoadAnsiStr #0 ';
  //Result := AParent + ', ' + C;
  {P} Result := Result +
                 //'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
                 //Remove_Result_dot( AParent );
                 #13#10' C2';
end;

procedure TKOLCheckBox.SetAuto3State(const Value: Boolean);
begin
  FAuto3State := Value;
  Change;
end;

procedure TKOLCheckBox.SetChecked(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetChecked', 0
  @@e_signature:
  end;
  if FChecked = Value then exit;
  if action = nil then
    FChecked := Value
  else
    FChecked := action.Checked;
  Change;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Checked:=FChecked;
  Invalidate;
end;

procedure TKOLCheckBox.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewCheckBox', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
end;

procedure TKOLCheckBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  Checked and (action = nil) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetChecked', '' );
      end else
      SL.Add( Prefix + AName + '.Checked := TRUE;' );
end;

function TKOLCheckBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.SetupParams', 0
  @@e_signature:
  end;
  if (action = nil) and (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     C := StringConstant('Caption', Caption)
  else
     C := '''''';
{$IFDEF _D2009orHigher}
 if  C <> '''''' then
 begin
     C2 := '';
     for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
     C := C2;
 end;
{$ENDIF}
  Result := AParent + ', ' + C;
end;

function TKOLCheckBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLCheckBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLCheckBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLCheckBox.TypeName: String;
begin
  if Auto3State and Windowed
    then Result := 'CheckBox3State'
    else Result := inherited TypeName;
end;

function TKOLCheckBox.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLRadioBox }

constructor TKOLRadioBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.Create', 0
  @@e_signature:
  end;
  inherited;
  fTabstop := TRUE;
  fAutoSzX := 20;
  Width := 72; DefaultWidth := Width;
  Height := 22; DefaultHeight := 22;
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
end;

procedure TKOLRadioBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.FirstCreate', 0
  @@e_signature:
  end;
  Caption := Name;
  inherited;
end;

function TKOLRadioBox.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLRadioBox.Paint;
begin
  PrepareCanvasFontForWYSIWIGPaint( Canvas );
  DrawRadioBox( Self, Canvas );
  inherited;
end;

function TKOLRadioBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLRadioBox.P_GenerateTransparentInits: String;
begin
  Result := ' xySwap DelAnsiStr ' + inherited P_GenerateTransparentInits;
end;

procedure TKOLRadioBox.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  inherited;
  if Checked and (action = nil) then
  begin
    SL.add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' + Name +
            ' DUP TControl.CreateWindow<1>' );
    SL.add( ' TControl.SetRadioChecked<1>' );
  end;
end;

function TKOLRadioBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  if (action = nil) and (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     Result := P_StringConstant('Caption',Caption)
  else
     Result := ' LoadAnsiStr #0 ';
  //Result := AParent + ', ' + C;
  {P} Result := Result +
                 //'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
                 //Remove_Result_dot( AParent );
                 #13#10' C2';
end;

procedure TKOLRadioBox.SetChecked(const Value: Boolean);
var I: Integer;
    C: TComponent;
    K: TKOLCustomControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.SetChecked', 0
  @@e_signature:
  end;
  if FChecked = Value then exit;
  if action = nil then
    FChecked := Value
  else
    FChecked := action.Checked;
  Change;
  if FChecked then
  if Parent <> nil then
  begin
    for I := 0 to ParentForm.ComponentCount - 1 do
    begin
      C := ParentForm.Components[ I ];
      if C <> Self then
      if C is TKOLCustomControl then
      begin
        K := C as TKOLCustomControl;
        if K.Parent = Parent then
        if K is TKOLRadioBox then
          (K as TKOLRadioBox).Checked := FALSE;
      end;
    end;
  end;
end;

procedure TKOLRadioBox.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewRadioBox', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
end;

procedure TKOLRadioBox.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  Checked and (action = nil) then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.CreateWindow', '' ); //'FormCreateWindow' );
          KF.FormAddCtlCommand( Name, 'TControl.SetRadioChecked', '' );
      end
        else
      begin
          SL.add( Prefix + AName + '.CreateWindow;' );
          SL.add( Prefix + AName + '.SetRadioChecked;' );
      end;
  end;
end;

function TKOLRadioBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.SetupParams', 0
  @@e_signature:
  end;
  if (action = nil) and (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
    C := StringConstant('Caption', Caption)
  else
    C := '''''';
{$IFDEF _D2009orHigher}
 if C <> '''''' then
  begin
   C2 := '';
   for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
   C := C2;
  end;
{$ENDIF}
  Result := AParent + ', ' + C;
end;

function TKOLRadioBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLRadioBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRadioBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLRadioBox.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLEditBox }

function TKOLEditBox.BestEventName: String;
begin
  Result := 'OnChange';
end;

constructor TKOLEditBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.Create', 0
  @@e_signature:
  end;
  inherited;
  fNoAutoSizeX := TRUE;
  fAutoSzY := 6;
  Width := 100; DefaultWidth := Width;
  Height := 22; DefaultHeight := 22;
  TabStop := TRUE;
  FResetTabStopByStyle := TRUE;
end;

function TKOLEditBox.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

procedure TKOLEditBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.FirstCreate', 0
  @@e_signature:
  end;
  Text := Name;
  inherited;
end;

function TKOLEditBox.GetCaption: TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

function TKOLEditBox.GetText: TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.GetText', 0
  @@e_signature:
  end;
  Result := Caption;
end;

function TKOLEditBox.NoDrawFrame: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.NoDrawFrame', 0
  @@e_signature:
  end;
  Result := HasBorder;
end;

procedure TKOLEditBox.Paint;
var
  R:TRect;
  Flag:DWord;
  Delta: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.Paint', 0
  @@e_signature:
  end;

  PrepareCanvasFontForWYSIWIGPaint( Canvas );

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;

  if HasBorder then
  begin
    if Ctl3D then
    begin
      DrawEdge(Canvas.Handle,R,EDGE_SUNKEN,BF_RECT);
      Delta := 3;
    end
      else
    begin
      Canvas.Brush.Color := clWindowText;
      Canvas.FrameRect(R);
      Delta := 2;
    end;

    R.Left:=Delta;
    R.Top:=Delta;
    R.Right:=Width-Delta;
    R.Bottom:=Height-Delta;
  end;

  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end;

  Canvas.Brush.Color := Color;
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);

  inherited;

end;

function TKOLEditBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLEditBox.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Text <> '' then
  begin
    {P}SL.Add( 'LoadAnsiStr ' + P_String2Pascal( Text ) );
    {P}SL.Add( ' C2 TControl_.SetCaption<2>' );
    {P}SL.Add( ' DelAnsiStr' );
  end;
  //if TextAlign <> taLeft then
  //  {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
  //          ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' + Name +
  //          ' TControl_.SetTextAlign<2>' );
  if Transparent then
    //SL.Add( Prefix + AName + '.Ed_Transparent := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.EdSetTransparent<2>' );
end;

function TKOLEditBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var EO: KOL.TEditOptions;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  //Result := AParent + ', [ ' + S + ' ]';
  EO := [ ];
  if eoLowercase in Options then EO := EO + [ KOL.eoLowercase ];
  if eoNoHideSel in Options then EO := EO + [ KOL.eoNoHideSel ];
  if eoOemConvert in Options then EO := EO + [ KOL.eoOemConvert ];
  if eoPassword  in Options then EO := EO + [ KOL.eoPassword ];
  if eoReadonly  in Options then EO := EO + [ KOL.eoReadonly ];
  if eoUpperCase in options then EO := EO + [ KOL.eoUpperCase ];
  if eoWantTab   in options then EO := EO + [ KOL.eoWantTab ];
  {P}Result := ' L(' + IntToStr( PWord( @ EO )^ ) + ') ';
  {P} Result := Result +
                 #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
                 Remove_Result_dot( AParent );
                 //' C1';
end;

procedure TKOLEditBox.P_SetupTextAlign(SL: TStrings; const AName: String);
begin
  inherited;
  if TextAlign <> taLeft then
    //SL.Add('    ' + AName + '.TextAlign := ' + TextAligns[TextAlign] + ';');
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
               ' C1 TControl_.SetTextAlign<2>' );
end;

procedure TKOLEditBox.SetEdTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetEdTransparent', 0
  @@e_signature:
  end;
  FEdTransparent := Value;
  Change;
end;

procedure TKOLEditBox.SetOptions(const Value: TKOLEditOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  Change;
end;

procedure TKOLEditBox.SetText(const Value: TDelphiString);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetText', 0
  @@e_signature:
  end;
  SetCaption( Value );
end;

procedure TKOLEditBox.SetUnicode(const Value: Boolean);
begin
  if  FUnicode = Value then Exit;
  FUnicode := Value;
  Change;
end;

function TKOLEditBox.SetupColorFirst: Boolean;
begin
  Result := FALSE;
end;

procedure TKOLEditBox.SetupConstruct_Compact;
var KF: TKOLForm;
    b: PByte;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewEditBox', TRUE, TRUE, '' );
    b := @ Options;
    KF.FormAddNumParameter( b^ );
end;

procedure TKOLEditBox.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
//const
//  Aligns: array[ TTextAlign ] of String = ( 'taLeft', 'taRight', 'taCenter' );
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  (Text <> '') and ((KF = nil) or KF.AssignTextToControls) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetCaption', '' );
          KF.FormAddStrParameter( Text );
      end else
      AddLongTextField( SL, Prefix + AName + '.Text := ', Text, ';', ' + ' );

  if  Transparent then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.EdSetTransparent', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.Ed_Transparent := TRUE;' );
end;

function TKOLEditBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.SetupParams', 0
  @@e_signature:
  end;
  S := '';
  if eoLowercase in Options then
    S := S + ', eoLowercase';
  if eoNoHideSel in Options then
    S := S + ', eoNoHideSel';
  if eoOemConvert in Options then
    S := S + ', eoOemConvert';
  if eoPassword in Options then
    S := S + ', eoPassword';
  if eoReadonly in Options then
    S := S + ', eoReadonly';
  if eoUpperCase in Options then
    S := S + ', eoUpperCase';
  if eoWantTab in Options then
    S := S + ', eoWantTab';
  if eoNumber in Options then
    S := S + ', eoNumber';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

procedure TKOLEditBox.SetupSetUnicode;
begin
  ///
  if  Unicode then
  begin
      SL.Add('    {$IFNDEF UNICODE_CTRLS}' + AName + '.SetUnicode( TRUE );{$ENDIF}' );
  end;
end;

procedure TKOLEditBox.SetupTextAlign(SL: TStrings; const AName: String);
begin
  inherited;
  if  TextAlign <> taLeft then
      GenerateTextAlign( SL, AName );
end;

function TKOLEditBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLEditBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLEditBox.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.WantTabs', 0
  @@e_signature:
  end;
  if Want then
    Options := Options + [ eoWantTab ]
  else
    Options := Options - [ eoWantTab ];
end;

function TKOLEditBox.WYSIWIGPaintImplemented: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.WYSIWIGPaintImplemented', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLMemo }

function TKOLMemo.BestEventName: String;
begin
  Result := 'OnChange';
end;

constructor TKOLMemo.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.Create', 0
  @@e_signature:
  end;
  FLines := TStringList.Create;
  inherited;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  Width := 200; DefaultWidth := Width;
  Height := 222; DefaultHeight := Height;
  TabStop := TRUE;
  FHasScrollbarsToOverride := TRUE;
end;

procedure TKOLMemo.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TEditOptions;
begin
  inherited;
  opts:=[eoMultiline];
  if eo_Lowercase in FOptions then
    Include(opts, kol.eoLowercase);
  if eo_NoHScroll in FOptions then
    Include(opts, kol.eoNoHScroll);
  if eo_NoVScroll in FOptions then
    Include(opts, kol.eoNoVScroll);
  if eo_UpperCase in FOptions then
    Include(opts, kol.eoUpperCase);
  FKOLCtrl:=NewEditbox(KOLParentCtrl, opts);
  if Recreating then 
    FKOLCtrl.TextAlign:=kol.TTextAlign(TextAlign);
end;

function TKOLMemo.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLMemo.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.Destroy', 0
  @@e_signature:
  end;
  FLines.Free;
  inherited;
end;

procedure TKOLMemo.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.FirstCreate', 0
  @@e_signature:
  end;
  FLines.Text := Name;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
  inherited;
end;

function TKOLMemo.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

function TKOLMemo.GetText: TStrings;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.GetText', 0
  @@e_signature:
  end;
  Result := FLines;
end;

procedure TKOLMemo.KOLControlRecreated;
begin
  inherited;
  FKOLCtrl.Text:=FLines.Text;
end;

procedure TKOLMemo.Loaded;
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
end;

function TKOLMemo.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

function TKOLMemo.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLMemo.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLEditBox.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if FLines.Text <> '' then
  begin
    {P}SL.Add( 'LoadAnsiStr ' + P_String2Pascal( FLines.Text ) );
    {P}SL.Add( ' C2 TControl_.SetCaption<2>' );
    {P}SL.Add( ' DelAnsiStr' );
  end;
  //if TextAlign <> taLeft then
  //  {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
  //          ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' + Name +
  //          ' TControl_.SetTextAlign<2>' );
  if Transparent then
    //SL.Add( Prefix + AName + '.Ed_Transparent := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.EdSetTransparent<2>' );
end;

function TKOLMemo.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var EO: KOL.TEditOptions;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  //Result := AParent + ', [ ' + S + ' ]';
  EO := [ KOL.eoMultiline ];
  if eo_NoHScroll in Options then EO := EO + [ KOL.eoNoHScroll ];
  if eo_NoVScroll in Options then EO := EO + [ KOL.eoNoVScroll ];
  if eo_Lowercase in Options then EO := EO + [ KOL.eoLowercase ];
  if eo_NoHideSel in Options then EO := EO + [ KOL.eoNoHideSel ];
  if eo_OemConvert in Options then EO := EO + [ KOL.eoOemConvert ];
  if eo_Password  in Options then EO := EO + [ KOL.eoPassword ];
  if eo_Readonly  in Options then EO := EO + [ KOL.eoReadonly ];
  if eo_UpperCase in options then EO := EO + [ KOL.eoUpperCase ];
  if eo_WantReturn in options then EO := EO + [ KOL.eoWantReturn ];
  if eo_WantTab   in options then EO := EO + [ KOL.eoWantTab ];
  {P}Result := ' L(' + IntToStr( PWord( @ EO )^ ) + ') ';
  {P} Result := Result +
                 #13#10' C1';
end;

procedure TKOLMemo.P_SetupTextAlign(SL: TStrings; const AName: String);
begin
  inherited;
  if TextAlign <> taLeft then
    //SL.Add('    ' + AName + '.TextAlign := ' + TextAligns[TextAlign] + ';');
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
               ' C1 TControl_.SetTextAlign<2>' );
end;

procedure TKOLMemo.SetEdTransparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetEdTransparent', 0
  @@e_signature:
  end;
  FEdTransparent := Value;
  Change;
end;

procedure TKOLMemo.SetOptions(const Value: TKOLMemoOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLMemo.SetText(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetText', 0
  @@e_signature:
  end;
  FLines.Text := Value.Text;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=Value.Text;
  Change;
end;

procedure TKOLMemo.SetTextAlign(const Value: TTextAlign);
begin
  inherited;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
end;

procedure TKOLMemo.SetUnicode(const Value: Boolean);
begin
  if  Funicode = Value then Exit;
  FUnicode := Value;
  Change;
end;

function TKOLMemo.SetupColorFirst: Boolean;
begin
 Result := FALSE;
end;

procedure TKOLMemo.SetupConstruct_Compact;
var KF: TKOLForm;
    O: TEditOptions;
    b: PWord;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewEditBox', TRUE, TRUE, '' );
    O := [eoMultiline];
    if  eo_NoHScroll in Options then
        O := O + [KOL.eoNoHScroll];
    if  eo_NoVScroll in Options then
        O := O + [KOL.eoNoVScroll];
    if  eo_Lowercase in Options then
        O := O + [KOL.eoLowercase];
    if  eo_NoHideSel in Options then
        O := O + [KOL.eoNoHideSel];
    if  eo_OemConvert in Options then
        O := O + [KOL.eoOemConvert];
    if  eo_Password in Options then
        O := O + [KOL.eoPassword];
    if  eo_Readonly in Options then
        O := O + [KOL.eoReadonly];
    if  eo_UpperCase in Options then
        O := O + [KOL.eoUpperCase];
    if  eo_WantReturn in Options then
        O := O + [KOL.eoWantReturn];
    if  eo_WantTab in Options then
        O := O + [KOL.eoWantTab];
    b := @ O;
    KF.FormAddNumParameter( b^ );
end;

procedure TKOLMemo.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  (FLines.Text <> '') and (Kf <> nil) and KF.AssignTextToControls then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetCaption', '' );
          KF.FormAddStrParameter( FLines.Text );
      end else
      AddLongTextField( SL, Prefix + AName + '.Text := ', FLines.Text, ';', ' + ' );
  end;

  if  Transparent then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.EdSetTransparent', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.Ed_Transparent := TRUE;' );
end;

function TKOLMemo.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.SetupParams', 0
  @@e_signature:
  end;
  S := 'eoMultiline';
  if eo_NoHScroll in Options then
    S := S + ', eoNoHScroll';
  if eo_NoVScroll in Options then
    S := S + ', eoNoVScroll';
  if eo_Lowercase in Options then
    S := S + ', eoLowercase';
  if eo_NoHideSel in Options then
    S := S + ', eoNoHideSel';
  if eo_OemConvert in Options then
    S := S + ', eoOemConvert';
  if eo_Password in Options then
    S := S + ', eoPassword';
  if eo_Readonly in Options then
    S := S + ', eoReadonly';
  if eo_UpperCase in Options then
    S := S + ', eoUpperCase';
  if eo_WantReturn in Options then
    S := S + ', eoWantReturn';
  if eo_WantTab in Options then
    S := S + ', eoWantTab';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

procedure TKOLMemo.SetupSetUnicode(SL: TStringList; const AName: String);
begin
  //
  if  Unicode then
      SL.Add( '    {$IFNDEF UNICODE_CTRLS}' + AName +
              '.SetUnicode( TRUE );{$ENDIF}' );
end;

procedure TKOLMemo.SetupTextAlign(SL: TStrings; const AName: String);
begin
  inherited;
  if  TextAlign <> taLeft then
      GenerateTextAlign( SL, AName );
end;

function TKOLMemo.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLMemo.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLMemo.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.TypeName', 0
  @@e_signature:
  end;
  Result := 'EditBox';
end;

procedure TKOLMemo.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.WantTabs', 0
  @@e_signature:
  end;
  if Want then
    Options := Options + [ eo_WantTab ]
  else
    Options := Options - [ eo_WantTab ];
end;

{ TKOLListBox }

constructor TKOLListBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.Create', 0
  @@e_signature:
  end;
  FItems := TStringList.Create;
  inherited;
  Width := 164; DefaultWidth := Width;
  Height := 200; DefaultHeight := Height;
  TabStop := TRUE;
  Options := [ loNoIntegralHeight ];
  FHasScrollbarsToOverride := TRUE;
end;

procedure TKOLListBox.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TListOptions;
begin
  inherited;
  opts:=[];
  if loNoHideScroll in FOptions then
    Include(opts, kol.loNoHideScroll);
  if loMultiColumn in FOptions then
    Include(opts, kol.loMultiColumn);
  FKOLCtrl:=NewListbox(KOLParentCtrl, opts + [kol.loNoIntegralHeight]);
end;

function TKOLListBox.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLListBox.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.Destroy', 0
  @@e_signature:
  end;
  inherited;
  FItems.Free;
end;

procedure TKOLListBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.FirstCreate', 0
  @@e_signature:
  end;
  //FItems.Text := Name;
  FCurIndex := 0;
  inherited;
end;

{ +ecm }
function TKOLListBox.GenerateTransparentInits: String;
begin
  if fLBItemHeight > 0 then Result := '.SetLVItemHeight('+IntToStr(fLBItemHeight)+')'
  else Result := '';
  Result := Result + inherited GenerateTransparentInits();
end;
{ /+ecm }

procedure TKOLListBox.GenerateTransparentInits_Compact;
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  KF = nil then Exit;
  if  fLBItemHeight > 0 then
  begin
      KF.FormAddCtlCommand( Name, 'FormSetLVItemHeight', '' );
      KF.FormAddNumParameter( fLBItemHeight );
  end;
end;

function TKOLListBox.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

procedure TKOLListBox.KOLControlRecreated;
begin
  inherited;
  UpdateItems;
end;

procedure TKOLListBox.Loaded;
begin
  inherited;
  UpdateItems;
end;

function TKOLListBox.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

function TKOLListBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLListBox.P_GenerateTransparentInits: String;
begin
  if fLBItemHeight > 0 then
    //Result := '.SetLVItemHeight('+IntToStr(fLBItemHeight)+')'
    {P}Result := ' L(' + IntToStr( fLBItemHeight ) +
                 ') C1 TControl_.SetLVItemHeight<2>'
  else Result := '';
  Result := Result + inherited P_GenerateTransparentInits();
end;

procedure TKOLListBox.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if FItems.Text <> '' then
  begin
    for I := 0 to FItems.Count - 1 do
    //SL.Add( Prefix + AName + '.Items[ ' + IntToStr( I ) + ' ] := ' +
    //        StringConstant( 'Item' + IntToStr( I ), FItems[ I ] ) + ';' );
    {P}SL.Add( P_StringConstant( 'Item' + IntToStr( I ), FItems[ I ] ) +
               ' L(' + IntToStr( I ) + ') C3 TControl_.SetItems<3>' +
               ' DelAnsiStr' );
  end;
  if FCurIndex >= 0 then
    //SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( FCurIndex ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( FCurIndex ) + ')' +
               ' C1 TControl_.SetCurIndex<2>' );
end;

procedure TKOLListBox.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  if loNoData in Options then
  if Count > 0 then
    //SL.Add( Prefix + AName + '.Count := ' + IntToStr( Count ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( Count ) + ')' );
      {P}SL.Add( 
        ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name +
        ' TControl_.SetItemsCount<2>' );
    end;
end;

function TKOLListBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var O: TKOLListboxOptions;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  O := Options;
  {P}Result := ' L(' + IntToStr( PWord( @ O )^ ) + ')' +
               #13#10' C1';
               //ïðèìå÷àíèå: çäåñü ìîæíî òàê ïîñòóïèòü, ò.ê. TKOLListboxOptions
               // òî÷íî ñîîòâåòñòâóþò KOL.TListOptions
end;

procedure TKOLListBox.SetAlwaysAssignItems(const Value: Boolean);
begin
  if  FAlwaysAssignItems = Value then Exit;
  FAlwaysAssignItems := Value;
  Change;
end;

procedure TKOLListBox.SetCount(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetCount', 0
  @@e_signature:
  end;
  if Value < 0 then
    Value := 0;
  FCount := Value;
  Change;
end;

procedure TKOLListBox.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
end;

procedure TKOLListBox.SetItems(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetItems', 0
  @@e_signature:
  end;
  FItems.Text := Value.Text;
  UpdateItems;
  Change;
end;

{ +ecm }
procedure TKOLListBox.SetLBItemHeight(const Value: Integer);
begin
  if fLBItemHeight <> Value then begin
    fLBItemHeight := Value;
    Change;
  end;
end;
{ /+ecm }

procedure TKOLListBox.SetOptions(const Value: TKOLListboxOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLListBox.SetupConstruct_Compact;
var KF: TKOLForm;
    W: PWord;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewListBox', TRUE, TRUE, '' );
    W := @ Options;
    KF.FormAddNumParameter( W^ );
end;

procedure TKOLListBox.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
  j : integer;
{$ELSE}
  C: String;
{$ENDIF}
  I: Integer;
  KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  FItems.Text <> '' then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetListItems', '' );
          KF.FormAddNumParameter( FItems.Count );
          for I := 0 to FItems.Count-1 do
              if  (KF <> nil) and KF.AssignTextToControls or AlwaysAssignItems then
                  KF.FormAddStrParameter( FItems[I] )
              else
                  KF.FormAddStrParameter( '' );
      end else
      for I := 0 to FItems.Count - 1 do
      begin
          {$IFDEF _D2009orHigher}
          if  (KF <> nil) and KF.AssignTextToControls then
              C := StringConstant( 'Item' + IntToStr( I ), FItems[ I ] )
          else
              C := '''''';
          C2 := '';
          for j := 2 to Length(C)-1 do C2 := C2 + '#'+int2str(ord(C[j]));
          C := C2;
          SL.Add( Prefix + AName + '.Items[ ' + IntToStr( I ) + ' ] := ' + C + ';' );
          {$ELSE}
          if  (KF <> nil) and KF.AssignTextToControls or AlwaysAssignItems then
              C := StringConstant( 'Item' + IntToStr( I ), FItems[ I ] )
          else
              C := '''''';
          SL.Add( Prefix + AName + '.Items[ ' + IntToStr( I ) + ' ] := ' +
                  C + ';' );
          {$ENDIF}
      end;
  end;
  if  (FCurIndex >= 0) and (Items.Count > 0) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          if  FCurIndex = 1 then
          begin
              KF.FormAddCtlCommand( Name, 'TControl.SetCurIdx', '' );
              // param = 1
          end
            else
          begin
              KF.FormAddCtlCommand( Name, 'FormSetCurIdx', '' );
              KF.FormAddNumParameter( FCurIndex );
          end;
      end else
      SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( FCurIndex ) + ';' );
end;

procedure TKOLListBox.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  loNoData in Options then
  if  Count > 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          if  Count = 1 then
          begin
              KF.FormAddCtlCommand( Name, 'TControl.SetItemsCount', '' );
              // param = 1
          end
            else
          begin
              KF.FormAddCtlCommand( Name, 'FormSetCount', '' );
              KF.FormAddNumParameter( Count );
          end;
      end else
      SL.Add( Prefix + AName + '.Count := ' + IntToStr( Count ) + ';' );
end;

function TKOLListBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.SetupParams', 0
  @@e_signature:
  end;
  if loNoHideScroll in Options then
    S := S + 'loNoHideScroll';
  if loNoExtendSel in Options then
    S := S + ', loNoExtendSel';
  if loMultiColumn in Options then
    S := S + ', loMultiColumn';
  if loMultiSelect in Options then
    S := S + ', loMultiSelect';
  if loNoIntegralHeight in Options then
    S := S + ', loNoIntegralHeight';
  if loNoSel in Options then
    S := S + ', loNoSel';
  if loSort in Options then
    S := S + ', loSort';
  if loTabstops in Options then
    S := S + ', loTabstops';
  if loNoStrings in Options then
    S := S + ', loNoStrings';
  if loNoData in Options then
    S := S + ', loNoData';
  if loOwnerDrawFixed in Options then
    S := S + ', loOwnerDrawFixed';
  if loOwnerDrawVariable in Options then
    S := S + ', loOwnerDrawVariable';
  if loHScroll in Options then
    S := S + ', loHScroll';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

function TKOLListBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLListBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

procedure TKOLListBox.UpdateItems;
var
  i: integer;
begin
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.BeginUpdate;
    try
      FKOLCtrl.Clear;
      if [loOwnerDrawFixed, loOwnerDrawVariable] * FOptions = [] then
        for i:=0 to FItems.Count - 1 do
         FKOLCtrl.Items[i]:=FItems[i];
    finally
      FKOLCtrl.EndUpdate;
    end;
  end;
end;

{ TKOLComboBox }

function TKOLComboBox.AutoHeight(Canvas: TCanvas): Integer;
begin
  if coSimple in Options then
    Result := Height
  else
    Result := inherited AutoHeight( Canvas );
end;

function TKOLComboBox.AutoSizeRunTime: Boolean;
begin
  Result := not( coSimple in Options );
end;

constructor TKOLComboBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.Create', 0
  @@e_signature:
  end;
  FItems := TStringList.Create;
  inherited;
  fNoAutoSizeX := TRUE;
  fAutoSzY := 6;
  Width := 100; DefaultWidth := Width;
  Height := 22; DefaultHeight := Height;
  TabStop := TRUE;
  Options := [ coNoIntegralHeight ];
end;

function TKOLComboBox.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWhite; // !!! in Windows, default color for combobox really is clWhite
end;

function TKOLComboBox.DefaultInitialColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.DefaultInitialColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLComboBox.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.Destroy', 0
  @@e_signature:
  end;
  inherited;
  FItems.Free;
end;

procedure TKOLComboBox.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.FirstCreate', 0
  @@e_signature:
  end;
  FItems.Text := Name;
  FCurIndex := 0;
  inherited;
end;

function TKOLComboBox.GenerateTransparentInits: String;
begin
  if fCBItemHeight > 0 then Result := '.SetLVItemHeight('+IntToStr(fCBItemHeight)+')'
  else Result := '';
  Result := Result + inherited GenerateTransparentInits();
end;

procedure TKOLComboBox.GenerateTransparentInits_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    if  not KF.FormCompact then Exit;
    if  fCBItemHeight > 0 then
    begin
        KF.FormAddCtlCommand( Name, 'FormSetLVItemHeight', '' );
        KF.FormAddNumParameter( fCBItemHeight );
    end;
end;

function TKOLComboBox.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLComboBox.Paint;
begin
  if not (Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames])) then begin
    PrepareCanvasFontForWYSIWIGPaint( Canvas );
    DrawCombobox( Self, Canvas );
  end;  
  inherited;
end;

function TKOLComboBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLComboBox.P_GenerateTransparentInits: String;
begin
  if fCBItemHeight > 0 then
    //Result := '.SetLVItemHeight('+IntToStr(fCBItemHeight)+')'
    {P}Result := Result + ' L(' + IntToStr( fCBItemHeight ) + ')' +
      ' C1 TControl_.SetLVItemHeight<2>'
  else Result := '';
  Result := Result + inherited P_GenerateTransparentInits();
end;

procedure TKOLComboBox.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if FItems.Text <> '' then
  begin
    for I := 0 to FItems.Count - 1 do
    //SL.Add( Prefix + AName + '.Items[ ' + IntToStr( I ) + ' ] := ' +
    //        StringConstant( 'Item' + IntToStr( I ), FItems[ I ] ) + ';' );
    {P}SL.Add( P_StringConstant( 'Item' + IntToStr( I ), FItems[ I ] ) +
               ' L(' + IntToStr( I ) + ') C3 TControl_.SetItems<3>' +
               ' DelAnsiStr' );
  end;
  if FCurIndex >= 0 then
    //SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( FCurIndex ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( FCurIndex ) + ') C1 TControl_.SetCurIndex<2>' );
  if (FDroppedWidth <> Width) and (FDroppedWidth <> 0) then
    //SL.Add( Prefix + AName + '.DroppedWidth := ' + IntToStr( FDroppedWidth ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( FDroppedWidth ) + ') ' +
               ' C1 TControl_.SetDroppedWidth<2>' );
end;

function TKOLComboBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListBox.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  {P}Result := ' L(' + IntToStr( PWord( @ Options )^ ) + ')' +
               #13#10' C1';
end;

procedure TKOLComboBox.SetAlign(const Value: TKOLAlign);
begin
  inherited;
  if  Value in [ caLeft, caRight, caClient ] then
  if  not (csLoading in ComponentState) then
      ShowMessage( 'Aligning combobox to left, right or client ' +
                   'can get undesirable results at run time!' );
end;

procedure TKOLComboBox.SetAlwaysAssignItems(const Value: Boolean);
begin
  if  FAlwaysAssignItems = Value then Exit;
  FAlwaysAssignItems := Value;
  Change;
end;

procedure TKOLComboBox.SetCBItemHeight(const Value: Integer);
begin
  if fCBItemHeight <> Value then
  begin
    fCBItemHeight := Value;
    Change;
  end;
end;

procedure TKOLComboBox.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
end;

procedure TKOLComboBox.SetDroppedWidth(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetDroppedWidth', 0
  @@e_signature:
  end;
  FDroppedWidth := Value;
  Change;
end;

procedure TKOLComboBox.SetItems(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetItems', 0
  @@e_signature:
  end;
  FItems.Text := Value.Text;
  Change;
end;

procedure TKOLComboBox.SetOptions(const Value: TKOLComboOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  Change;
  if AutoSize then
    AutoSizeNow;
  Invalidate;
end;

procedure TKOLComboBox.SetupConstruct_Compact;
var KF: TKOLForm;
    W: PWord;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewComboBox', TRUE, TRUE, '' );
    W := @ Options;
    KF.FormAddNumParameter( W^ );
end;

procedure TKOLComboBox.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
  j : integer;
{$ELSE}
  C: String;
{$ENDIF}
 I: Integer;
 KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  FItems.Text <> '' then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetListItems', '' );
          KF.FormAddNumParameter( FItems.Count );
          for I := 0 to FItems.Count-1 do
              if  (KF <> nil) and KF.AssignTextToControls or AlwaysAssignItems then
                  KF.FormAddStrParameter( FItems[I] )
              else
                  KF.FormAddStrParameter( '' );
      end else
      for I := 0 to FItems.Count - 1 do
       begin
           {$IFDEF _D2009orHigher}
           if  (KF <> nil) and KF.AssignTextToControls or AlwaysAssignItems then
               C := StringConstant( 'Item' + IntToStr( I ), FItems[ I ] )
           else
               C := '''''';
           C2 := '';
           for j := 2 to Length(C)-1 do C2 := C2 + '#'+int2str(ord(C[j]));
           C := C2;
           SL.Add( Prefix + AName + '.Items[ ' + IntToStr( I ) + ' ] := ' + C + ';' );
           {$ELSE}
           if  (KF <> nil) and KF.AssignTextToControls then
               C := StringConstant( 'Item' + IntToStr( I ), FItems[ I ] )
           else
               C := '''''';
           SL.Add( Prefix + AName + '.Items[ ' + IntToStr( I ) + ' ] := ' +
                   C + ';' );
           {$ENDIF}
       end;
  end;

  if  (FCurIndex >= 0) and (Items.Count > 0) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          if  FCurIndex = 1 then
          begin
              KF.FormAddCtlCommand( Name, 'TControl.SetCurIdx', '' );
              // param = 1
          end
            else
          begin
              KF.FormAddCtlCommand( Name, 'FormSetCurIdx', '' );
              KF.FormAddNumParameter( FCurIndex );
          end;
      end else
      SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( FCurIndex ) + ';' );

  if  (FDroppedWidth <> Width) and (FDroppedWidth <> 0) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetDroppedWidth', '' );
          KF.FormAddNumParameter( FDroppedWidth );
      end else
      SL.Add( Prefix + AName + '.DroppedWidth := ' + IntToStr( FDroppedWidth ) + ';' );
end;

function TKOLComboBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.SetupParams', 0
  @@e_signature:
  end;
  if coReadOnly in Options then
    S := S + 'coReadOnly';
  if coNoHScroll in Options then
    S := S + ', coNoHScroll';
  if coAlwaysVScroll in Options then
    S := S + ', coAlwaysVScroll';
  if coLowerCase in Options then
    S := S + ', coLowerCase';
  if coNoIntegralHeight in Options then
    S := S + ', coNoIntegralHeight';
  if coOemConvert in Options then
    S := S + ', coOemConvert';
  if coSort in Options then
    S := S + ', coSort';
  if coUpperCase in Options then
    S := S + ', coUpperCase';
  if coOwnerDrawFixed in Options then
    S := S + ', coOwnerDrawFixed';
  if coOwnerDrawVariable in Options then
    S := S + ', coOwnerDrawVariable';
  if coSimple in Options then
    S := S + ', coSimple';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

function TKOLComboBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLComboBox.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLComboBox.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLComboBox.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLSplitter }

procedure TKOLSplitter.AssignEvents(SL: TStringList; const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.AssignEvents', 0
  @@e_signature:
  end;
  inherited;
  DoAssignEvents( SL, AName, [ 'OnSplit' ], [ @OnSplit ] );
end;

function TKOLSplitter.BestEventName: String;
begin
  Result := 'OnSplit';
end;

constructor TKOLSplitter.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.Create', 0
  @@e_signature:
  end;
  inherited;
  Align := caLeft;
  Width := 4; DefaultWidth := Width;
  DefaultHeight := 4;
  MinSizePrev := 0;
  MinSizeNext := 0;
  //FBeveled := TRUE;
  EdgeStyle := esLowered;
end;

procedure TKOLSplitter.CreateKOLControl(Recreating: boolean);
var
  es: TEdgeStyle;
begin
  inherited;
  if Recreating then
    es:=FEdgeStyle
  else
    es:=esLowered;
  FKOLCtrl:=NewSplitterEx(KOLParentCtrl, 0, 0, es);
end;

function TKOLSplitter.IsCursorDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.IsCursorDefault', 0
  @@e_signature:
  end;
  case Align of
  caLeft, caRight:  Result := (Trim(Cursor_)='') or (Trim(Cursor_)='IDC_SIZEWE');
  caTop, caBottom:  Result := (Trim(Cursor_)='') or (Trim(Cursor_)='IDC_SIZENS');
  else Result := inherited IsCursorDefault;
  end;
end;

function TKOLSplitter.NoDrawFrame: Boolean;
begin
  Result:=(FEdgeStyle < esNone);
end;

function TKOLSplitter.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLSplitter.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
end;

function TKOLSplitter.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLGradientPanel.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 3;
  Result := '';
  if EdgeStyle <> esLowered then
    {P}Result := ' L( ' + IntToStr( Integer( EdgeStyle ) ) + ')';
  {P}Result := Result +
    ' L( ' + IntToStr( MinSizeNext ) + ')' +
    #13#10' L( ' + IntToStr( MinSizePrev ) + ') ' +
    #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
    Remove_Result_dot( AParent );
end;

procedure TKOLSplitter.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetEdgeStyle', 0
  @@e_signature:
  end;
  FEdgeStyle := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLSplitter.SetMinSizeNext(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetMinSizeNext', 0
  @@e_signature:
  end;
  FMinSizeNext := Value;
  Change;
end;

procedure TKOLSplitter.SetMinSizePrev(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetMinSizePrev', 0
  @@e_signature:
  end;
  FMinSizePrev := Value;
  Change;
end;

procedure TKOLSplitter.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewSplitter', TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( MinSizePrev ) );
    KF.FormAddNumParameter( Integer( MinSizeNext ) );
end;

procedure TKOLSplitter.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
end;

function TKOLSplitter.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
const Styles: array[ TEdgeStyle ] of String =
  ( 'esRaised', 'esLowered', 'esNone', 'esTransparent', 'esSolid' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + IntToStr( MinSizePrev ) + ', ' + IntToStr( MinSizeNext );
  if EdgeStyle <> esLowered then
    Result := Result + ', ' + Styles[ EdgeStyle ];
end;

function TKOLSplitter.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLSplitter.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLSplitter.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if EdgeStyle <> esLowered then
    Result := 'SplitterEx';
end;

{ TKOLPaintBox }

function TKOLPaintBox.BestEventName: String;
begin
  Result := 'OnPaint';
end;

constructor TKOLPaintBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 64; DefaultWidth := Width;
  Height := 64; DefaultHeight := Height;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
end;

function TKOLPaintBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLPaintBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 1;
  Result := ' DUP';
end;

procedure TKOLPaintBox.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewPaintBox', TRUE, TRUE, '' );
end;

function TKOLPaintBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLPaintBox.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent;
end;

function TKOLPaintBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

{ TKOLListView }

procedure TKOLListView.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnDeleteLVItem', 'OnLVCustomDraw'
                  (*{$IFNDEF _D2}, 'OnLVDataW' {$ENDIF _D2}*) ],
                             [ @ OnDeleteLVItem, @ OnLVCustomDraw
                  (*{$IFNDEF _D2}, @ OnLVDataW {$ENDIF _D2}*) ] );
end;

constructor TKOLListView.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.Create', 0
  @@e_signature:
  end;
  inherited;
  FCols := TList.Create;
  FGenerateColIdxConst := TRUE;
  Width := 200; DefaultWidth := Width;
  Height := 150; DefaultHeight := Height;
  FCurIndex := 0;
  FLVBkColor := clWindow;
  FLVTextBkColor := clWindow;
  TabStop := TRUE;
  FHasScrollbarsToOverride := TRUE;
end;

function TKOLListView.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

procedure TKOLListView.DefineProperties(Filer: TFiler);
var I: Integer;
    Col: TKOLListViewColumn;
begin
  inherited;
  Filer.DefineProperty( 'ColCount', LoadColCount, SaveColCount, TRUE );
  for I := 0 to FColCount-1 do
  begin
    if FCols.Count <= I then
      Col := TKOLListViewColumn.Create( Self )
    else
      Col := FCols[ I ];
    Col.DefProps( 'Column' + IntToStr( I ), Filer );
  end;
end;

destructor TKOLListView.Destroy;
var I: Integer;
begin
  ActiveDesign.Free;
  if ImageListNormal <> nil then
    ImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  if ImageListSmall <> nil then
    ImageListSmall.NotifyLinkedComponent( Self, noRemoved );
  if ImageListState <> nil then
   ImageListState.NotifyLinkedComponent( Self, noRemoved );
  for I := FCols.Count-1 downto 0 do
    TObject( FCols[ I ] ).Free;
  FCols.Free;
  inherited;
end;

procedure TKOLListView.DoGenerateConstants(SL: TStringList);
var I: Integer;
    Col: TKOLListViewColumn;
begin
  if not generateConstants then Exit;
  for I := 0 to Cols.Count-1 do
  begin
    Col := Cols[ I ];
    if Col.Name <> '' then
      SL.Add( 'const ' + Col.Name + ' = ' + IntToStr( I ) + ';' );
  end;
end;

function TKOLListView.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.GetCaption', 0
  @@e_signature:
  end;
  Result := inherited Caption;
end;

function TKOLListView.GetColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.GetColor', 0
  @@e_signature:
  end;
  Result := inherited Color;
end;

function TKOLListView.GetColumns: String;
//var I: Integer;
begin
  Result := '';
  if Cols.Count > 0 then
    Result := IntToStr( Cols.Count ) + ' columns';
  {for I := 0 to Cols.Count-1 do
  begin
    if Result <> '' then Result := Result + ';';
    Result := Result + Trim( TKOLListViewColumn( Cols[ I ] ).Caption );
  end;}
end;

function TKOLListView.HasOrderedColumns: Boolean;
var I: Integer;
    C: TKOLListViewColumn;
begin
  Result := FALSE;
  for I := 0 to Cols.Count-1 do
  begin
    C := Cols[ I ];
    if C.FLVColOrder >= 0 then
    begin
      Result := TRUE;
      break;
    end;
  end;
end;

{YS}
procedure TKOLListView.Invalidate;
begin
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
    FKOLCtrl.InvalidateEx
  else
  {$ENDIF}
    inherited;
end;

procedure TKOLListView.Loaded;
begin
  inherited;
  UpdateColumns;
end;
{YS}
procedure TKOLListView.LoadColCount(Reader: TReader);
begin
  FColCount := Reader.ReadInteger;
end;

procedure TKOLListView.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = FImageListNormal then
      ImageListNormal := nil;
    if Sender = FImageListSmall then
      ImageListSmall := nil;
    if Sender = FImageListState then
      ImageListState := nil;
  end;
end;

procedure TKOLListView.SaveColCount(Writer: TWriter);
begin
  FColCount := FCols.Count;
  Writer.WriteInteger( FColCount );
end;

procedure TKOLListView.SetColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetColor', 0
  @@e_signature:
  end;
  inherited Color := Value;
end;

procedure TKOLListView.SetColumns(const Value: String);
begin
  //
end;

procedure TKOLListView.SetGenerateColIdxConst(const Value: Boolean);
begin
  FGenerateColIdxConst := Value;
  Change;
end;

procedure TKOLListView.SetImageListNormal(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetImageListNormal', 0
  @@e_signature:
  end;
  if FImageListNormal <> nil then
    FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  FImageListNormal := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLListView.SetImageListSmall(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetImageListSmall', 0
  @@e_signature:
  end;
  if FImageListSmall <> nil then
    FImageListSmall.NotifyLinkedComponent( Self, noRemoved );
  FImageListSmall := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLListView.SetImageListState(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetImageListState', 0
  @@e_signature:
  end;
  if FImageListState <> nil then
    FImageListState.NotifyLinkedComponent( Self, noRemoved );
  FImageListState := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLListView.SetLVCount(Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetLVCount', 0
  @@e_signature:
  end;
  if Value < 0 then
    Value := 0;
  FLVCount := Value;
  Change;
end;

procedure TKOLListView.SetLVTextBkColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetLVTextBkColor', 0
  @@e_signature:
  end;
  FLVTextBkColor := Value;
  Change;
end;

procedure TKOLListView.SetOnLVCustomDraw(const Value: TOnLVCustomDraw);
begin
  FOnLVCustomDraw := Value;
  Change;
end;

{procedure TKOLListView.SetOnLVDelete(const Value: TOnDeleteLVItem);
begin
  FOnDeleteLVItem := Value;
  Change;
end;}

procedure TKOLListView.SetOptions(const Value: TKOLListViewOptions);
var
  Opts: kol.TListViewOptions;
  OldOpts: TKOLListViewOptions;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetOptions', 0
  @@e_signature:
  end;
  OldOpts := FOptions;
  FOptions := Value;
  if Assigned(FKOLCtrl) then begin
    if ([lvoNoScroll, lvoNoSortHeader] * OldOpts <> []) or ([lvoNoScroll, lvoNoSortHeader] * Value <> []) then
      RecreateWnd
    else begin
      Opts:=[];
      if lvoGridLines in FOptions then
        Include(Opts, kol.lvoGridLines);
      if lvoFlatsb in FOptions then
        Include(Opts, kol.lvoFlatsb);
      FKOLCtrl.LVOptions:=Opts;
      UpdateAllowSelfPaint;
    end;
  end;
  Change;
end;

procedure TKOLListView.SetStyle(const Value: TKOLListViewStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetStyle', 0
  @@e_signature:
  end;
  FStyle := Value;
{YS}
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned( FKOLCtrl ) then
    FKOLCtrl.LVStyle:=TListViewStyle(Value);
  UpdateAllowSelfPaint;
  {$ENDIF}
{YS}
  Change;
end;

procedure TKOLListView.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
    Col: TKOLListViewColumn;
    KF: TKOLForm;
    W: Integer;
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 j : integer;
{$ELSE}
  C: String;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  (Font.Color <> clWindowText) and (Font.Color <> clNone) and (Font.Color <> clDefault) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetLVTextColor', '' );
          KF.FormAddNumParameter( (Font.Color shl 1) or (Font.Color shr 31) );
      end else
      SL.Add( Prefix + AName + '.LVTextColor := ' + Color2Str( Font.Color ) + ';' );

  if  (LVTextBkColor <> clDefault) and (LVTextBkColor <> clNone) and (LVTextBkColor <> clWindow) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetLVTextBkColor', '' );
          KF.FormAddNumParameter( (LVTextBkColor shl 1) or (LVTextBkColor shr 31) );
      end else
      SL.Add( Prefix + AName + '.LVTextBkColor := ' + Color2Str( LVTextBkColor ) + ';' );

  if  (LVBkColor <> clDefault) and (LVBkColor <> clNone) and (LVBkColor <> clWindow) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetLVBkColor', '' );
          KF.FormAddNumParameter( (LVBkColor shl 1) or (LVBkColor shr 31) );
      end else
      SL.Add( Prefix + AName + '.LVBkColor := ' + Color2Str( LVBkColor ) + ';' );

    if  (KF <> nil) and KF.FormCompact and (Cols.Count > 0) then
    begin
        KF.FormAddCtlCommand( Name, 'FormLVColumsAdd', '' );
        KF.FormAddNumParameter( Cols.Count );
        for I := 0 to Cols.Count-1 do
        begin
            Col := Cols[ I ];
            W := Col.Width;
            if  Col.FLVColRightImg then
                W := -W;
            KF.FormAddNumParameter( W );
            KF.FormAddStrParameter( Col.Caption );
        end;
        for I := 0 to Cols.Count-1 do
        begin
            Col := Cols[ I ];
            if  Col.LVColImage >= 0 then
            begin
                KF.FormAddCtlCommand( Name, 'FormSetLVColImage', '' );
                KF.FormAddNumParameter( I );
                KF.FormAddNumParameter( Col.LVColImage );
            end;
            if  Col.LVColOrder >= 0 then
            if  Col.LVColOrder <> I then
            begin
                KF.FormAddCtlCommand( Name, 'FormSetLVColOrder', '' );
                KF.FormAddNumParameter( I );
                KF.FormAddNumParameter( Col.LVColOrder );
            end;
        end;
    end
      else
    begin
        for I := 0 to Cols.Count-1 do
        begin
            Col := Cols[ I ];
            W := Col.Width;
            if  Col.FLVColRightImg then
                W := -W;
            begin
                {$IFDEF _D2009orHigher}
                if  (KF <> nil) and KF.AssignTextToControls then
                    C := StringConstant( 'Column' + IntToStr( I ) + 'Caption', Col.Caption )
                else
                    C := '''''';
                if C <> '''''' then
                begin
                    C2 := '';
                    for j := 2 to Length(C)-1 do
                        C2 := C2 + '#'+int2str(ord(C[j]));
                    C := C2;
                end;
                SL.Add( Prefix + AName + '.LVColAdd( ' +
                        C + ', ' +
                        TextAligns[ Col.TextAlign ] + ', ' + IntToStr( W ) + ');' );
                {$ELSE}
                if  (KF <> nil) and KF.AssignTextToControls then
                    C := Col.Caption
                else
                    C := '';
                SL.Add( Prefix + AName + '.LVColAdd' + '( ' +
                        StringConstant( 'Column' + IntToStr( I ) + 'Caption',
                        C ) + ', ' +
                        TextAligns[ Col.TextAlign ] + ', ' + IntToStr( W ) + ');' );
                {$ENDIF}
                if  Col.LVColImage >= 0 then
                    SL.Add( Prefix + AName + '.LVColImage[ ' + IntToStr( I ) + ' ] := ' +
                            IntToStr( Col.LVColImage ) + ';' );
            end;
        end;
        for I := 0 to Cols.Count-1 do
        begin
            Col := Cols[ I ];
            if  Col.LVColOrder >= 0 then
            if  Col.LVColOrder <> I then
                SL.Add( Prefix + AName + '.LVColOrder[ ' + IntToStr( I ) + ' ] := ' +
                        IntToStr( Col.LVColOrder ) + ';' );
        end;
        //+++++++++++++++++++++++++++++ 2.93
    end;
    if (lvoEditLabel in Options) and not Assigned( OnEndEditLVItem ) then
    begin
        (SL as TFormStringList).OnAdd := nil;
        SL.Add( Prefix + AName + '.OnEndEditLVItem := nil;' );
        if  KF <> nil then
            (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
    end;
end;

procedure TKOLListView.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  LVCount > 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetCount', '' );
          KF.FormAddNumParameter( LVCount );
      end else
      SL.Add( Prefix + AName + '.LVCount := ' + IntToStr( LVCount ) + ';' );
  if  (KF <> nil) and KF.FormCompact then
  begin
      if  ImageListNormal <> nil then
          SL.Add( '    Result.' + Name + '.ImageListNormal := ' +
                  'Result.' + ImageListNormal.Name + ';' );
      if  ImageListSmall <> nil then
          SL.Add( '    Result.' + Name + '.ImageListSmall := ' +
                  'Result.' + ImageListSmall.Name + ';' );
      if  ImageListState <> nil then
          SL.Add( '    Result.' + Name + '.ImageListState := ' +
                  'Result.' + ImageListState.Name + ';' );
  end;
end;

function TKOLListView.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S, O, ILSm, ILNr, ILSt: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.SetupParams', 0
  @@e_signature:
  end;
  case Style of
  lvsIcon:      S := 'lvsIcon';
  lvsSmallIcon: S := 'lvsSmallIcon';
  lvsList:      S := 'lvsList';
  lvsDetail:    S := 'lvsDetail';
  lvsDetailNoHeader: S := 'lvsDetailNoHeader';
  end;
  O := '';
  if lvoIconLeft in Options then
    O := 'lvoIconLeft';
  if lvoAutoArrange in Options then
    O := O + ', lvoAutoArrange';
  if lvoButton in Options then
    O := O + ', lvoButton';
  if lvoEditLabel in Options then
    O := O + ', lvoEditLabel';
  if lvoNoLabelWrap in Options then
    O := O + ', lvoNoLabelWrap';
  if lvoNoScroll in Options then
    O := O + ', lvoNoScroll';
  if lvoNoSortHeader in Options then
    O := O + ', lvoNoSortHeader';
  if lvoHideSel in Options then
    O := O + ', lvoHideSel';
  if lvoMultiselect in Options then
    O := O + ', lvoMultiselect';
  if lvoSortAscending in Options then
    O := O + ', lvoSortAscending';
  if lvoSortDescending in Options then
    O := O + ', lvoSortDescending';
  if lvoGridLines in Options then
    O := O + ', lvoGridLines';
  if lvoSubItemImages in Options then
    O := O + ', lvoSubItemImages';
  if lvoCheckBoxes in Options then
    O := O + ', lvoCheckBoxes';
  if lvoTrackSelect in Options then
    O := O + ', lvoTrackSelect';
  if lvoHeaderDragDrop in Options then
    O := O + ', lvoHeaderDragDrop';
  if lvoRowSelect in Options then
    O := O + ', lvoRowSelect';
  if lvoOneClickActivate in Options then
    O := O + ', lvoOneClickActivate';
  if lvoTwoClickActivate in Options then
    O := O + ', lvoTwoClickActivate';
  if lvoFlatsb in Options then
    O := O + ', lvoFlatsb';
  if lvoRegional in Options then
    O :=  O + ', lvoRegional';
  if lvoInfoTip in Options then
    O := O + ', lvoInfoTip';
  if lvoUnderlineHot in Options then
    O := O + ', lvoUnderlineHot';
  if lvoMultiWorkares in Options then
    O := O + ', lvoMultiWorkares';
  if lvoOwnerData in Options then
    O := O + ', lvoOwnerData';
  if lvoOwnerDrawFixed in Options then
    O := O + ', lvoOwnerDrawFixed';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  ILSm := 'nil';
  if ImageListSmall <> nil then
  begin
    if ImageListSmall.ParentFORM.Name = ParentForm.Name then
      ILSm := 'Result.' + ImageListSmall.Name
    else
      ILSm := ImageListSmall.ParentFORM.Name +'.'+ ImageListSmall.Name;
  end;
  ILNr := 'nil';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      ILNr := 'Result.' + ImageListNormal.Name
    else
      ILNr := ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end;
  ILSt := 'nil';
  if ImageListState <> nil then
  begin
    if ImageListState.ParentFORM.Name = ParentForm.Name then
      ILSt := 'Result.' + ImageListState.Name
    else
      ILSt := ImageListState.ParentFORM.Name +'.'+ ImageListState.Name;
  end;
  Result := AParent + ', ' + S + ', [ ' + O + ' ], ' + ILSm + ', ' + ILNr
            + ', ' + ILSt;
end;

function TKOLListView.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;
{YS}
procedure TKOLListView.UpdateColumns;
{$IFDEF _KOLCtrlWrapper_}
var
  i: integer;
  col: TKOLListViewColumn;
{$ENDIF}
begin
  {$IFDEF _KOLCtrlWrapper_}
  if Assigned(FKOLCtrl) then
  with FKOLCtrl^ do begin
    BeginUpdate;
    try
      while LVColCount > 0 do
        LVColDelete(0);
      for i:=0 to FCols.Count - 1 do begin
        col:=FCols[i];
        LVColAdd(col.Caption, KOL.TTextAlign(col.TextAlign), col.Width)
      end;
    finally
      EndUpdate;
    end;
    UpdateAllowSelfPaint;
  end;
  {$ENDIF}
end;

procedure TKOLListView.CreateKOLControl(Recreating: boolean);
var
  Opts: kol.TListViewOptions;
begin
  Opts:=[];
  if lvoGridLines in FOptions then
    Include(Opts, kol.lvoGridLines);
  if lvoFlatsb in FOptions then
    Include(Opts, kol.lvoFlatsb);
  if lvoNoScroll in FOptions then
    Include(Opts, kol.lvoNoScroll);
  if lvoNoSortHeader in FOptions then
    Include(Opts, kol.lvoNoSortHeader);
  FKOLCtrl := NewListView(KOLParentCtrl, TListViewStyle(Style), opts, nil, nil, nil);
end;

function TKOLListView.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;
{YS}

procedure TKOLListView.KOLControlRecreated;
begin
  inherited;
  UpdateColumns;
end;

function TKOLListView.GetDefaultControlFont: HFONT;
begin
  Result:=GetStockObject(DEFAULT_GUI_FONT);
end;

(*{$IFNDEF _D2}
procedure TKOLListView.SetOnLVDataW(const Value: TOnLVDataW);
begin
  FOnLVDataW := Value;
  Change;
end;
{$ENDIF _D2}*)

procedure TKOLListView.SetLVItemHeight(const Value: Integer);
begin
  if fLVItemHeight <> Value then begin
    fLVItemHeight := Value;
    Change;
  end;
end;

function TKOLListView.GenerateTransparentInits: String;
begin
  if fLVItemHeight > 0 then Result := '.SetLVItemHeight('+IntToStr(fLVItemHeight)+')'
  else Result := '';
  Result := Result + inherited GenerateTransparentInits();
end;

procedure TKOLListView.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.P_SetupLast', 0
  @@e_signature:
  end;
  inherited;
  if LVCount > 0 then
    //SL.Add( Prefix + AName + '.LVCount := ' + IntToStr( LVCount ) + ';' );
    begin
      {P}SL.Add( ' L(' + IntToStr( LVCount ) + ')' );
      {P}SL.Add( ' ' +
         'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name +
        ' TControl_.SetItemsCount<2>' );
    end;
end;

procedure TKOLListView.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
    Col: TKOLListViewColumn;
    KF: TKOLForm;
    W: Integer;
    WifUnicode: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if (KF <> nil) and KF.Unicode then WifUnicode := 'W' else WifUnicode := '';
  if (Font.Color <> clWindowText) and (Font.Color <> clNone) and (Font.Color <> clDefault) then
    //SL.Add( Prefix + AName + '.LVTextColor := ' + Color2Str( Font.Color ) + ';' );
    {P}SL.Add( ' L($' + IntToHex( Font.Color, 6 ) + ')' +
               ' L(' + IntToStr( LVM_GETTEXTCOLOR ) + ')' +
               ' C2 TControl_.LVSetColorByIdx<3>' );
  if (LVTextBkColor <> clDefault) and (LVTextBkColor <> clNone) and (LVTextBkColor <> clWindow) then
    //SL.Add( Prefix + AName + '.LVTextBkColor := ' + Color2Str( LVTextBkColor ) + ';' );
    {P}SL.Add( ' L($' + IntToHex( LVTextBkColor, 6 ) + ')' +
               ' L(' + IntToStr(LVM_GETTEXTBKCOLOR) + ')' +
               ' C2 TControl_.LVSetColorByIdx<3>' );
  if (LVBkColor <> clDefault) and (LVBkColor <> clNone) and (LVBkColor <> clWindow) then
    //SL.Add( Prefix + AName + '.LVBkColor := ' + Color2Str( LVBkColor ) + ';' );
    {P}SL.Add( ' L($' + IntToHex( LVBkColor, 6 ) + ')' +
               ' C1 TControl_.SetCtlColor<2>' );
  for I := 0 to Cols.Count-1 do
  begin
    Col := Cols[ I ];
    W := Col.Width;
    if Col.FLVColRightImg then
      W := -W;
    {SL.Add( Prefix + AName + '.LVColAdd' + WifUnicode + '( ' +
            StringConstant( 'Column' + IntToStr( I ) + 'Caption',
            Col.Caption ) + ', ' +
            TextAligns[ Col.TextAlign ] + ', ' + IntToStr( W ) + ');' );}
    {P}SL.Add( P_StringConstant( 'Column' + IntToStr( I ) + 'Caption', Col.Caption ) +
               ' L(' + IntToStr( W ) + ')' +
               ' L(' + IntToStr( Integer( Col.TextAlign ) ) + ') ' +
               ' C2 ' +
               ' C5 TControl_.LVColAdd' + WifUnicode + '<3>' +
               ' DEL DelAnsiStr' );
    if Col.LVColImage >= 0 then
      //SL.Add( Prefix + AName + '.LVColImage[ ' + IntToStr( I ) + ' ] := ' +
      //        IntToStr( Col.LVColImage ) + ';' );
      {P}SL.Add( ' L(' + IntToStr( Col.LVColImage ) + ')' +
                 ' L(' + IntToStr( I ) + ')' +
                 ' L(' + IntToStr( LVCF_IMAGE or (24 shl 16) ) + ')' +
                 ' C3 TControl_.SetLVColEx<3>' );
  end;
  for I := 0 to Cols.Count-1 do
  begin
    Col := Cols[ I ];
    if Col.LVColOrder >= 0 then
    if Col.LVColOrder <> I then
      //SL.Add( Prefix + AName + '.LVColOrder[ ' + IntToStr( I ) + ' ] := ' +
      //        IntToStr( Col.LVColOrder ) + ';' );
      {P}SL.Add( ' L(' + IntToStr( Col.LVColOrder ) + ')' +
                 ' L(' + IntToStr( I ) + ')' +
                 ' L(' + IntToStr( LVCF_ORDER or (28 shl 16) ) + ')' +
                 ' C3 TControl_.SetLVColEx<3>' );
  end;
end;

function TKOLListView.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
  function P_LVLoadImageList( IL: TKOLImageList ): String;
  begin
    if IL = nil then Result := ' L(0)'
    else if IL.ParentFORM.Name = ParentForm.Name then
      Result := ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
         IL.Name
    else Result := ' LoadDWORD ####' + IL.ParentFORM.Name +
      ' AddWord_LoadRef ##T' + IL.ParentFORM.Name + '.' + IL.Name;
  end;
//var S, O, ILSm, ILNr, ILSt: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLListView.P_SetupParams', 0
  @@e_signature:
  end;
  {case Style of
  lvsIcon:      S := 'lvsIcon';
  lvsSmallIcon: S := 'lvsSmallIcon';
  lvsList:      S := 'lvsList';
  lvsDetail:    S := 'lvsDetail';
  lvsDetailNoHeader: S := 'lvsDetailNoHeader';
  end;
  O := '';
  if lvoIconLeft in Options then
    O := 'lvoIconLeft';
  if lvoAutoArrange in Options then
    O := O + ', lvoAutoArrange';
  if lvoButton in Options then
    O := O + ', lvoButton';
  if lvoEditLabel in Options then
    O := O + ', lvoEditLabel';
  if lvoNoLabelWrap in Options then
    O := O + ', lvoNoLabelWrap';
  if lvoNoScroll in Options then
    O := O + ', lvoNoScroll';
  if lvoNoSortHeader in Options then
    O := O + ', lvoNoSortHeader';
  if lvoHideSel in Options then
    O := O + ', lvoHideSel';
  if lvoMultiselect in Options then
    O := O + ', lvoMultiselect';
  if lvoSortAscending in Options then
    O := O + ', lvoSortAscending';
  if lvoSortDescending in Options then
    O := O + ', lvoSortDescending';
  if lvoGridLines in Options then
    O := O + ', lvoGridLines';
  if lvoSubItemImages in Options then
    O := O + ', lvoSubItemImages';
  if lvoCheckBoxes in Options then
    O := O + ', lvoCheckBoxes';
  if lvoTrackSelect in Options then
    O := O + ', lvoTrackSelect';
  if lvoHeaderDragDrop in Options then
    O := O + ', lvoHeaderDragDrop';
  if lvoRowSelect in Options then
    O := O + ', lvoRowSelect';
  if lvoOneClickActivate in Options then
    O := O + ', lvoOneClickActivate';
  if lvoTwoClickActivate in Options then
    O := O + ', lvoTwoClickActivate';
  if lvoFlatsb in Options then
    O := O + ', lvoFlatsb';
  if lvoRegional in Options then
    O :=  O + ', lvoRegional';
  if lvoInfoTip in Options then
    O := O + ', lvoInfoTip';
  if lvoUnderlineHot in Options then
    O := O + ', lvoUnderlineHot';
  if lvoMultiWorkares in Options then
    O := O + ', lvoMultiWorkares';
  if lvoOwnerData in Options then
    O := O + ', lvoOwnerData';
  if lvoOwnerDrawFixed in Options then
    O := O + ', lvoOwnerDrawFixed';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  ILSm := 'nil';
  if ImageListSmall <> nil then
  begin
    if ImageListSmall.ParentFORM.Name = ParentForm.Name then
      ILSm := 'Result.' + ImageListSmall.Name
    else
      ILSm := ImageListSmall.ParentFORM.Name +'.'+ ImageListSmall.Name;
  end;
  ILNr := 'nil';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      ILNr := 'Result.' + ImageListNormal.Name
    else
      ILNr := ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end;
  ILSt := 'nil';
  if ImageListState <> nil then
  begin
    if ImageListState.ParentFORM.Name = ParentForm.Name then
      ILSt := 'Result.' + ImageListState.Name
    else
      ILSt := ImageListState.ParentFORM.Name +'.'+ ImageListState.Name;
  end;
  Result := AParent + ', ' + S + ', [ ' + O + ' ], ' + ILSm + ', ' + ILNr
            + ', ' + ILSt;}

  {P}//-----------------------------------------------------------------------//
  nparams := 3;
  Result := P_LVLoadImageList( ImageListSmall ) +
            #13#10 + P_LVLoadImageList( ImageListNormal ) +
            #13#10 + P_LVLoadImageList( ImageListState ) +
            #13#10' L(' + IntToStr( PInteger( @ Options )^ ) + ')' +
            #13#10' L(' + IntToStr( Integer( Style ) ) + ')' +
            #13#10' C5';
end;

function TKOLListView.P_GenerateTransparentInits: String;
begin
  if fLVItemHeight > 0 then
    //Result := '.SetLVItemHeight('+IntToStr(fLVItemHeight)+')'
    {P}Result := ' L(' + IntToStr( fLVItemHeight ) + ')' +
                 ' C1 TControl_.SetLVItemHeight<2>'
  else Result := '';
  Result := Result + inherited P_GenerateTransparentInits();
end;

function TKOLListView.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLListView.P_AssignEvents(SL: TStringList;
  const AName: String; CheckOnly: Boolean): Boolean;
begin
  Result := inherited P_AssignEvents( SL, AName, CheckOnly );
  if Result and CheckOnly then Exit;
  Result := Result or
  P_DoAssignEvents( SL, AName, [ 'OnDeleteLVItem', 'OnLVCustomDraw'
                  (*{$IFNDEF _D2}, 'OnLVDataW' {$ENDIF _D2}*) ],
                             [ @ OnDeleteLVItem, @ OnLVCustomDraw
                  (*{$IFNDEF _D2}, @ OnLVDataW {$ENDIF _D2}*) ],
                  [ TRUE, TRUE ], CheckOnly );
end;

procedure TKOLListView.GenerateTransparentInits_Compact;
begin
  inherited;

end;

procedure TKOLListView.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewListView', TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( Style ) );
    KF.FormAddNumParameter( PInteger( @ Options )^ );
end;

function TKOLListView.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

{ TKOLTreeView }

constructor TKOLTreeView.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 150; DefaultWidth := Width;
  Height := 200; DefaultHeight := Height;
  FCurIndex := 0;
  TabStop := TRUE;
  FHasScrollbarsToOverride := TRUE;
end;

procedure TKOLTreeView.CreateKOLControl(Recreating: boolean);
begin
  FKOLCtrl:=NewTreeView(KOLParentCtrl, [], nil, nil);
end;

function TKOLTreeView.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLTreeView.Destroy;
begin
  if ImageListNormal <> nil then
    ImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  if ImageListState <> nil then
    ImageListState.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

function TKOLTreeView.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLTreeView.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = FImageListNormal then
      ImageListNormal := nil;
    if Sender = FImageListState then
      ImageListState := nil;
  end;
end;

function TKOLTreeView.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLTreeView.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if TVRightClickSelect then
    //SL.Add( Prefix + AName + '.TVRightClickSelect := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetTVRightClickSelect<2>' );
  if TVIndent > 0 then
    //SL.Add( Prefix + AName + '.TVIndent := ' + IntToStr( TVIndent ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( TVIndent ) + ')' +
               ' L(' + IntToStr( TVM_GETINDENT ) + ')' +
               ' C2 TControl_.SetIntVal<3>' );
end;

function TKOLTreeView.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
  function P_TVImageList( IL: TKOLImageList ): String;
  begin
    if IL = nil then Result := ' L(0)'
    else if IL.ParentFORM.Name = ParentForm.Name then
      Result := ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
         IL.Name
    else Result := ' LoadDWORD ####' + IL.ParentFORM.Name +
      ' AddWord_LoadRef ##T' + IL.ParentFORM.Name + '.' + IL.Name;
  end;
//var O, ILNr, ILSt: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.P_SetupParams', 0
  @@e_signature:
  end;
  {
  O := '';
  if tvoNoLines in Options then
    O := 'tvoNoLines';
  if tvoLinesRoot in Options then
    O := O + ', tvoLinesRoot';
  if tvoNoButtons in Options then
    O := O + ', tvoNoButtons';
  if tvoEditLabels in Options then
    O := O + ', tvoEditLabels';
  if tvoHideSel in Options then
    O := O + ', tvoHideSel';
  if tvoDragDrop in Options then
    O := O + ', tvoDragDrop';
  if tvoNoTooltips in Options then
    O := O + ', tvoNoTooltips';
  if tvoCheckBoxes in Options then
    O := O + ', tvoCheckBoxes';
  if tvoTrackSelect in Options then
    O := O + ', tvoTrackSelect';
  if tvoSingleExpand in Options then
    O := O + ', tvoSingleExpand';
  if tvoInfoTip in Options then
    O := O + ', tvoInfoTip';
  if tvoFullRowSelect in Options then
    O := O + ', tvoFullRowSelect';
  if tvoNoScroll in Options then
    O := O + ', tvoNoScroll';
  if tvoNonEvenHeight in Options then
    O := O + ', tvoNonEvenHeight';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  ILNr := 'nil';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      ILNr := 'Result.' + ImageListNormal.Name
    else
      ILNr := ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end;
  ILSt := 'nil';
  if ImageListState <> nil then
  begin
    if ImageListState.ParentFORM.Name = ParentForm.Name then
      ILSt := 'Result.' + ImageListState.Name
    else
      ILSt := ImageListState.ParentFORM.Name +'.'+ ImageListState.Name;
  end;
  Result := AParent + ', [ ' + O + ' ], ' + ILNr + ', ' + ILSt;
  }
  {P}//-------------------------------------------------------------------------
  nparams := 3;
  Result := P_TVImageList( ImageListState ) +
            #13#10 + P_TVImageList( ImageListNormal ) +
            #13#10' L(' + IntToStr( PWord( @ Options )^ ) + ')' +
            #13#10' C3';
end;

procedure TKOLTreeView.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
end;

procedure TKOLTreeView.SetImageListNormal(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetImageListNormal', 0
  @@e_signature:
  end;
  if FImageListNormal <> nil then
    FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  FImageListNormal := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLTreeView.SetImageListState(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetImageListState', 0
  @@e_signature:
  end;
  if FImageListState <> nil then
    FImageListState.NotifyLinkedComponent( Self, noRemoved );
  FImageListState := Value;
  if Value <> nil then
    Value.AddToNotifyList( Self );
  Change;
end;

procedure TKOLTreeView.SetOptions(const Value: TKOLTreeViewOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  Change;
end;

procedure TKOLTreeView.SetTVIndent(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetTVIndent', 0
  @@e_signature:
  end;
  FTVIndent := Value;
  Change;
end;

procedure TKOLTreeView.SetTVRightClickSelect(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView,SetTVRightClickSelect', 0
  @@e_signature:
  end;
  FTVRightClickSelect := Value;
  Change;
end;

procedure TKOLTreeView.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewTreeView', TRUE, TRUE, '' );
    KF.FormAddNumParameter( PInteger( @ Options )^ );
end;

procedure TKOLTreeView.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  TVRightClickSelect then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TKOLControl.SetTVRightClickSelect', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.TVRightClickSelect := TRUE;' );

  if  TVIndent > 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTVIndent', '' );
          KF.FormAddNumParameter( TVIndent );
      end else
      SL.Add( Prefix + AName + '.TVIndent := ' + IntToStr( TVIndent ) + ';' );
end;

procedure TKOLTreeView.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  (KF <> nil) and KF.FormCompact then
  begin
      if  ImageListNormal <> nil then
          SL.Add( '    Result.' + Name + '.ImageListNormal := ' +
                  'Result.' + ImageListNormal.Name + ';' );
      if  ImageListState <> nil then
          SL.Add( '    Result.' + Name + '.ImageListState := ' +
                  'Result.' + ImageListState.Name + ';' );
  end;
end;

function TKOLTreeView.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var O, ILNr, ILSt: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.SetupParams', 0
  @@e_signature:
  end;
  O := '';
  if tvoNoLines in Options then
    O := 'tvoNoLines';
  if tvoLinesRoot in Options then
    O := O + ', tvoLinesRoot';
  if tvoNoButtons in Options then
    O := O + ', tvoNoButtons';
  if tvoEditLabels in Options then
    O := O + ', tvoEditLabels';
  if tvoHideSel in Options then
    O := O + ', tvoHideSel';
  if tvoDragDrop in Options then
    O := O + ', tvoDragDrop';
  if tvoNoTooltips in Options then
    O := O + ', tvoNoTooltips';
  if tvoCheckBoxes in Options then
    O := O + ', tvoCheckBoxes';
  if tvoTrackSelect in Options then
    O := O + ', tvoTrackSelect';
  if tvoSingleExpand in Options then
    O := O + ', tvoSingleExpand';
  if tvoInfoTip in Options then
    O := O + ', tvoInfoTip';
  if tvoFullRowSelect in Options then
    O := O + ', tvoFullRowSelect';
  if tvoNoScroll in Options then
    O := O + ', tvoNoScroll';
  if tvoNonEvenHeight in Options then
    O := O + ', tvoNonEvenHeight';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  ILNr := 'nil';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      ILNr := 'Result.' + ImageListNormal.Name
    else
      ILNr := ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end;
  ILSt := 'nil';
  if ImageListState <> nil then
  begin
    if ImageListState.ParentFORM.Name = ParentForm.Name then
      ILSt := 'Result.' + ImageListState.Name
    else
      ILSt := ImageListState.ParentFORM.Name +'.'+ ImageListState.Name;
  end;
  Result := AParent + ', [ ' + O + ' ], ' + ILNr + ', ' + ILSt;
end;

function TKOLTreeView.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLTreeView.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTreeView.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{ TKOLRichEdit }

function TKOLRichEdit.AdditionalUnits: String;
begin
  Result := inherited AdditionalUnits;
  if OLESupport then
    Result := Result + ', KOLOLERE';
end;

procedure TKOLRichEdit.AfterFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.AfterFontChange', 0
  @@e_signature:
  end;
  SL.Add( Prefix + AName + '.RE_CharFmtArea := raSelection;' );
end;

procedure TKOLRichEdit.BeforeFontChange( SL: TStrings; const AName, Prefix: String );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.BeforeFontChange', 0
  @@e_signature:
  end;
  SL.Add( Prefix + AName + '.RE_CharFmtArea := raAll;' );
end;

function TKOLRichEdit.BestEventName: String;
begin
  Result := 'OnChange';
end;

constructor TKOLRichEdit.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.Create', 0
  @@e_signature:
  end;
  FLines := TStringList.Create;
  inherited;
  FRE_AutoFont := TRUE;
  FRE_AutoFontSizeAdjust := TRUE;
  FDefIgnoreDefault := TRUE;
  FIgnoreDefault := TRUE;
  Width := 164; DefaultWidth := 100;
  Height := 200; DefaultHeight := Height;
  TabStop := TRUE;
  version := ver3;
  FMaxTextSize := 32767;
  FHasScrollbarsToOverride := TRUE;
end;

procedure TKOLRichEdit.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TEditOptions;
begin
  Log( '->TKOLRichEdit.CreateKOLControl' );
  TRY
    inherited;
    opts:=[];
    if eo_Lowercase in FOptions then
      Include(opts, kol.eoLowercase);
    if eo_NoHScroll in FOptions then
      Include(opts, kol.eoNoHScroll);
    if eo_NoVScroll in FOptions then
      Include(opts, kol.eoNoVScroll);
    if eo_UpperCase in FOptions then
      Include(opts, kol.eoUpperCase);
    FKOLCtrl := NewRichEdit(KOLParentCtrl, opts);
    LogOK;
  FINALLY
    Log( '<-TKOLRichEdit.CreateKOLControl' );
  END;
end;

function TKOLRichEdit.DefaultColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.DefaultColor', 0
  @@e_signature:
  end;
  Result := clWindow;
end;

destructor TKOLRichEdit.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.Destroy', 0
  @@e_signature:
  end;
  FLines.Free;
  inherited;
end;

procedure TKOLRichEdit.FirstCreate;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.FirstCreate', 0
  @@e_signature:
  end;
  FLines.Text := Name;
  inherited;
end;

function TKOLRichEdit.FontPropName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.FontPropName', 0
  @@e_signature:
  end;
  Result := 'RE_Font';
end;

function TKOLRichEdit.GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := inherited GenerateTransparentInits;
  if RE_FmtStandard then
    Result := Result + '.RE_FmtStandard';
end;

procedure TKOLRichEdit.GenerateTransparentInits_Compact;
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  KF = nil then Exit;
  if  RE_FmtStandard then
      KF.FormAddCtlCommand( Name, 'TControl.RE_FmtStandard', '' );
end;

function TKOLRichEdit.GetCaption: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.GetCaption', 0
  @@e_signature:
  end;
  Result := FLines.Text;
end;

function TKOLRichEdit.GetText: TStrings;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.GetText', 0
  @@e_signature:
  end;
  Result := FLines;
end;

procedure TKOLRichEdit.KOLControlRecreated;
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
end;

procedure TKOLRichEdit.Loaded;
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=FLines.Text;
end;

function TKOLRichEdit.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

function TKOLRichEdit.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLRichEdit.P_AfterFontChange(SL: TStrings; const AName,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.P_AfterFontChange', 0
  @@e_signature:
  end;
  //SL.Add( Prefix + AName + '.RE_CharFmtArea := raSelection;' );
  {P}SL.Add( ' L(' + IntToStr( Integer( raSelection ) ) +  ') ' +
             ' C1 AddWord_StoreB ##TControl_.fRECharArea' );
end;

procedure TKOLRichEdit.P_BeforeFontChange(SL: TStrings; const AName,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.P_BeforeFontChange', 0
  @@e_signature:
  end;
  //SL.Add( Prefix + AName + '.RE_CharFmtArea := raAll;' );
  {P}SL.Add( ' L(' + IntToStr( Integer( raAll ) ) +  ') ' +
             ' C1 AddWord_StoreB ##TControl_.fRECharArea' );

end;

function TKOLRichEdit.P_GenerateTransparentInits: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.P_GenerateTransparentInits', 0
  @@e_signature:
  end;
  Result := inherited P_GenerateTransparentInits;
  if RE_FmtStandard then
    //Result := Result + '.RE_FmtStandard';
    {P}Result := Result + ' DUP TControl.RE_FmtStandard<1>';
end;

procedure TKOLRichEdit.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if RE_AutoURLDetect then
    //SL.Add( Prefix + AName + '.RE_AutoURLDetect := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetRE_AutoURLDetect<2>' );
  if not RE_AutoFont then
    {P}SL.Add( ' L(0) L(2) C2 TControl_.RESetLangOptions<3>' );
  if not RE_AutoFontSizeAdjust then
    {P}SL.Add( ' L(0) L(16) C2 TControl_.RESetLangOptions<3>' );
  if RE_DualFont then
    {P}SL.Add( ' L(1) L(128) C2 TControl_.RESetLangOptions<3>' );
  if RE_UIFonts then
    {P}SL.Add( ' L(1) L(32) C2 TControl_.RESetLangOptions<3>' );
  if RE_IMECancelComplete then
    {P}SL.Add( ' L(1) L(4) C2 TControl_.RESetLangOptions<3>' );
  if RE_IMEAlwaysSendNotify then
    {P}SL.Add( ' L(1) L(8) C2 TControl_.RESetLangOptions<3>' );
  if MaxTextSize <> 32767 then
    if MaxTextSize > $7FFFffff then
      //SL.Add( Prefix + AName + '.MaxTextSize := $' + IntToHex( MaxTextSize, 8 ) + ';' )
      {P}SL.Add( ' L($' + Int2Hex( MaxTextSize, 8 ) + ')' +
                 ' C1 TControl_.SetMaxTextSize<2>' )
    else
      //SL.Add( Prefix + AName + '.MaxTextSize := ' + IntToStr( MaxTextSize ) + ';' );
      {P}SL.Add( ' L(' + IntToStr( MaxTextSize ) + ')' +
                 ' C1 TControl_.SetMaxTextSize<2>' );
  if (FRE_ZoomNumerator <> 0) and (FRE_ZoomDenominator <> 0) then
    //SL.Add( Prefix + AName + '.RE_Zoom := MakeSmallPoint( ' + IntToStr( FRE_ZoomNumerator ) +
    //  ', ' + IntToStr( FRE_ZoomDenominator ) + ' );' );
    {P}SL.Add( ' L( ' + IntToStr( FRE_ZoomDenominator or (FRE_ZoomNumerator shl 16) ) + ') ' +
               ' C1 TControl_.RESetZoom<2>' );
  if FLines.Text <> '' then
  begin
    {P}SL.Add( 'LoadAnsiStr ' + P_String2Pascal( FLines.Text ) );
    {P}SL.Add( //' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' + Name +
            ' C2' +
            ' TControl_.SetCaption<2>' );
    {P}SL.Add( ' DelAnsiStr' );
  end;
  if RE_AutoKeybdSet then
    //SL.Add( Prefix + AName + '.RE_AutoKeyboard := ' + BoolVal[ RE_AutoKeyboard ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( RE_AutoKeyboard ) ) + ') L(1) ' +
               ' C2 TControl_.RESetLangOptions<3>' );
  if RE_DisableOverwriteChange then
    //SL.Add( Prefix + AName + '.RE_DisableOverwriteChange := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetRE_DisableOverwriteChange<2>' );
  if RE_Transparent then
    //SL.Add( Prefix + AName + '.RE_Transparent := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetRE_Transparent<2>' );
end;

function TKOLRichEdit.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var EO: KOL.TEditOptions;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMemo.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 2;
  EO := [ KOL.eoMultiline ];
  if eo_NoHScroll in Options then EO := EO + [ KOL.eoNoHScroll ];
  if eo_NoVScroll in Options then EO := EO + [ KOL.eoNoVScroll ];
  if eo_Lowercase in Options then EO := EO + [ KOL.eoLowercase ];
  if eo_NoHideSel in Options then EO := EO + [ KOL.eoNoHideSel ];
  if eo_OemConvert in Options then EO := EO + [ KOL.eoOemConvert ];
  if eo_Password  in Options then EO := EO + [ KOL.eoPassword ];
  if eo_Readonly  in Options then EO := EO + [ KOL.eoReadonly ];
  if eo_UpperCase in options then EO := EO + [ KOL.eoUpperCase ];
  if eo_WantReturn in options then EO := EO + [ KOL.eoWantReturn ];
  if eo_WantTab   in options then EO := EO + [ KOL.eoWantTab ];
  {P}Result := ' L(' + IntToStr( PWord( @ EO )^ ) + ') ';
  {P} Result := Result +
                 #13#10' C1';
end;

procedure TKOLRichEdit.SetMaxTextSize(const Value: DWORD);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetMaxTextSize', 0
  @@e_signature:
  end;
  FMaxTextSize := Value;
  Change;
end;

procedure TKOLRichEdit.SetOLESupport(const Value: Boolean);
begin
  FOLESupport := Value;
  Change;
end;

procedure TKOLRichEdit.SetOptions(const Value: TKOLMemoOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetOptions', 0
  @@e_signature:
  end;
  if FOptions = Value then exit;
  FOptions := Value;
  if Assigned(FKOLCtrl) then 
    RecreateWnd;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoFont(const Value: Boolean);
begin
  if FRE_AutoFont = Value then Exit;
  FRE_AutoFont := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoFontSizeAdjust(const Value: Boolean);
begin
  if FRE_AutoFontSizeAdjust = Value then Exit;
  FRE_AutoFontSizeAdjust := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoKeybdSet(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_AutoKeybdSet', 0
  @@e_signature:
  end;
  FRE_AutoKeybdSet := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoKeyboard(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_AutoKeyboard', 0
  @@e_signature:
  end;
  FRE_AutoKeyboard := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_AutoURLDetect(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_AutoURLDetect', 0
  @@e_signature:
  end;
  FRE_AutoURLDetect := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_DisableOverwriteChange(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_DisableOverwriteChange', 0
  @@e_signature:
  end;
  FRE_DisableOverwriteChange := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_DualFont(const Value: Boolean);
begin
  if FRE_DualFont = Value then Exit;
  FRE_DualFont := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_FmtStandard(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_FmtStandard', 0
  @@e_signature:
  end;
  FRE_FmtStandard := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_IMEAlwaysSendNotify(const Value: Boolean);
begin
  if FRE_IMEAlwaysSendNotify = Value then Exit;
  FRE_IMEAlwaysSendNotify := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_IMECancelComplete(const Value: Boolean);
begin
  if FRE_IMECancelComplete = Value then Exit;
  FRE_IMECancelComplete := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_Transparent(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetRE_Transparent', 0
  @@e_signature:
  end;
  FRE_Transparent := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_UIFonts(const Value: Boolean);
begin
  if FRE_UIFonts = Value then Exit;
  FRE_UIFonts := Value;
end;

procedure TKOLRichEdit.SetRE_ZoomDenominator(const Value: Integer);
begin
  if FRE_ZoomDenominator = Value then Exit;
  FRE_ZoomDenominator := Value;
  Change;
end;

procedure TKOLRichEdit.SetRE_ZoomNumerator(const Value: Integer);
begin
  if FRE_ZoomNumerator = Value then Exit;
  FRE_ZoomNumerator := Value;
  Change;
end;

procedure TKOLRichEdit.SetText(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetText', 0
  @@e_signature:
  end;
  FLines.Text := Value.Text;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Text:=Value.Text;
  Change;
end;

function TKOLRichEdit.SetupColorFirst: Boolean;
begin
  Result := FALSE;
end;

procedure TKOLRichEdit.SetupConstruct_Compact;
var KF: TKOLForm;
    O: TEditOptions;
    b: PWord;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewRichEdit', TRUE, TRUE, '' );
    O := [eoMultiline];
    if  eo_NoHScroll in Options then
        O := O + [KOL.eoNoHScroll];
    if  eo_NoVScroll in Options then
        O := O + [KOL.eoNoVScroll];
    if  eo_Lowercase in Options then
        O := O + [KOL.eoLowercase];
    if  eo_NoHideSel in Options then
        O := O + [KOL.eoNoHideSel];
    if  eo_OemConvert in Options then
        O := O + [KOL.eoOemConvert];
    if  eo_Password in Options then
        O := O + [KOL.eoPassword];
    if  eo_Readonly in Options then
        O := O + [KOL.eoReadonly];
    if  eo_UpperCase in Options then
        O := O + [KOL.eoUpperCase];
    if  eo_WantReturn in Options then
        O := O + [KOL.eoWantReturn];
    if  eo_WantTab in Options then
        O := O + [KOL.eoWantTab];
    b := @ O;
    KF.FormAddNumParameter( b^ );
end;

procedure TKOLRichEdit.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
const
  BoolVal: array[ Boolean ] of String = ( 'FALSE', 'TRUE' );
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  RE_AutoURLDetect then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.RESetAutoURLDetect', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.RE_AutoURLDetect := TRUE;' );

  if  not RE_AutoFont then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_AutoFontFalse', '' );
      end else
      SL.Add( Prefix + AName + '.RE_AutoFont := FALSE;' );

  if  not RE_AutoFontSizeAdjust then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_AutoFontSizeAdjustFalse', '' );
      end else
      SL.Add( Prefix + AName + '.RE_AutoFontSizeAdjust := FALSE;' );

  if  RE_DualFont then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_DualFontTrue', '' );
      end else
      SL.Add( Prefix + AName + '.RE_DualFont := TRUE;' );

  if  RE_UIFonts then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_UIFontsTrue', '' );
      end else
      SL.Add( Prefix + AName + '.RE_UIFonts := TRUE;' );

  if  RE_IMECancelComplete then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_IMECancelCompleteTrue', '' );
      end else
      SL.Add( Prefix + AName + '.RE_IMECancelComplete := TRUE;' );

  if  RE_IMEAlwaysSendNotify then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_IMEAlwaysSendNotifyTrue', '' );
      end else
      SL.Add( Prefix + AName + '.RE_IMEAlwaysSendNotify := TRUE;' );

  if  MaxTextSize <> 32767 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMaxTextSize', '' );
          KF.FormAddNumParameter( MaxTextSize );
      end else
      if  MaxTextSize > $7FFFffff then
          SL.Add( Prefix + AName + '.MaxTextSize := $' + Int2Hex( MaxTextSize, 8 ) + ';' )
      else
          SL.Add( Prefix + AName + '.MaxTextSize := ' + IntToStr( MaxTextSize ) + ';' );

  if  (FLines.Text <> '') and (KF <> nil) and KF.AssignTextToControls then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetCaption', '' );
          KF.FormAddStrParameter( FLines.Text );
      end else
      AddLongTextField( SL, Prefix + AName + '.Text := ', FLines.Text, ';', ' + ' );
  end;

  if  RE_AutoKeybdSet then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_AutoKeyboardTrue', '' );
      end else
      SL.Add( Prefix + AName + '.RE_AutoKeyboard := ' + BoolVal[ RE_AutoKeyboard ] + ';' );

  if  RE_DisableOverwriteChange then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRE_DisableOverwriteChangeTrue', '' );
      end else
      SL.Add( Prefix + AName + '.RE_DisableOverwriteChange := TRUE;' );

  if  RE_Transparent then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.ReSetTransparent', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.RE_Transparent := TRUE;' );

  if  (FRE_ZoomNumerator <> 0) and (FRE_ZoomDenominator <> 0) then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetRe_Zoom' , '');
          KF.FormAddNumParameter( FRE_ZoomNumerator );
          KF.FormAddNumParameter( FRE_ZoomDenominator );
      end else
      SL.Add( Prefix + AName + '.RE_Zoom := MakeSmallPoint( ' + IntToStr( FRE_ZoomNumerator ) +
        ', ' + IntToStr( FRE_ZoomDenominator ) + ' );' );
end;

function TKOLRichEdit.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.SetupParams', 0
  @@e_signature:
  end;
  S := 'eoMultiline';
  if eo_NoHScroll in Options then
    S := S + ', eoNoHScroll';
  if eo_NoVScroll in Options then
    S := S + ', eoNoVScroll';
  if eo_Lowercase in Options then
    S := S + ', eoLowercase';
  if eo_NoHideSel in Options then
    S := S + ', eoNoHideSel';
  if eo_OemConvert in Options then
    S := S + ', eoOemConvert';
  if eo_Password in Options then
    S := S + ', eoPassword';
  if eo_Readonly in Options then
    S := S + ', eoReadonly';
  if eo_UpperCase in Options then
    S := S + ', eoUpperCase';
  if eo_WantReturn in Options then
    S := S + ', eoWantReturn';
  if eo_WantTab in Options then
    S := S + ', eoWantTab';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Copy( S, 3, MaxInt );
  Result := AParent + ', [ ' + S + ' ]';
end;

procedure TKOLRichEdit.Setversion(const Value: TKOLRichEditVersion);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.Setversion', 0
  @@e_signature:
  end;
  Fversion := Value;
  Change;
end;

function TKOLRichEdit.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLRichEdit.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

function TKOLRichEdit.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if version = ver1 then
    Result := 'RichEdit1';
  if OLESupport then
    Result := 'OLERichEdit';
end;

procedure TKOLRichEdit.WantTabs( Want: Boolean );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLRichEdit.WantTabs', 0
  @@e_signature:
  end;
  if Want then
    Options := Options + [ eo_WantTab ]
  else
    Options := Options - [ eo_WantTab ];
end;

{ TKOLProgressBar }

constructor TKOLProgressBar.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 300; DefaultWidth := Width;
  Height := 20; DefaultHeight := Height;
  MaxProgress := 100;
  ProgressColor := clHighLight;
  ProgressBkColor := clBtnFace;
end;

procedure TKOLProgressBar.CreateKOLControl(Recreating: boolean);
var
  opts: kol.TProgressbarOptions;
begin
  inherited;
  opts:=[];
  if Smooth then
    Include(opts, kol.pboSmooth);
  if Vertical then
    Include(opts, kol.pboVertical);
  FKOLCtrl:=NewProgressbarEx(KOLParentCtrl, opts);
end;

function TKOLProgressBar.GetColor: TColor;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.GetColor', 0
  @@e_signature:
  end;
  Result := inherited Color;
end;

procedure TKOLProgressBar.KOLControlRecreated;
begin
  inherited;
  FKOLCtrl.Progress:=Progress;
  FKOLCtrl.MaxProgress:=MaxProgress;
  FKOLCtrl.ProgressBkColor:=ProgressBkColor;
end;

function TKOLProgressBar.NoDrawFrame: Boolean;
begin
  Result:=True;
end;

function TKOLProgressBar.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLProgressBar.P_SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  TRY
  if MaxProgress <> 100 then
    //SL.Add( Prefix + AName + '.MaxProgress := ' + IntToStr( MaxProgress ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( MaxProgress ) + ')' +
               ' L(' + IntToStr( ((PBM_SETRANGE32 or $8000) shl 16) or PBM_GETRANGE ) + ')' +
               ' C2 TControl_.SetMaxProgress<3>' );
  if Progress <> 0 then
    //SL.Add( Prefix + AName + '.Progress := ' + IntToStr( Progress ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( Progress ) + ') L($84020000)' +
               ' C2 TControl_.SetIntVal<3>' );
  if ProgressColor <> clHighLight then
    //SL.Add( Prefix + AName + '.ProgressColor := ' + Color2Str( ProgressColor ) + ';' );
    {P}SL.Add( ' L($' + IntToHex( ProgressColor, 6 ) + ')' +
               ' C1 TControl_.SetProgressColor<2>' );
  EXCEPT on E: Exception do
         begin
         Rpt( 'exception in TKOLProgressBar.P_SetupFirst: ' +
                      E.message, RED );
         end;
  END;
end;

function TKOLProgressBar.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var i: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.P_SetupParams', 0
  @@e_signature:
  end;
  TRY
  nparams := 2;
  i := 0;
  if Vertical then i := 1;
  if Smooth then i := i or 2;
  {P}Result := ' L(' + IntToStr( i ) + ') C1 ';
  EXCEPT on E: Exception do
         begin
         Rpt( 'exception in TKOLProgressBar.P_SetupParams: ' +
                      E.message, RED );
         end;
  END;
end;

procedure TKOLProgressBar.SetColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetColor', 0
  @@e_signature:
  end;
  inherited Color := Value;
end;

procedure TKOLProgressBar.SetMaxProgress(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetMaxProgress', 0
  @@e_signature:
  end;
  if Value < 1 then Exit;
  FMaxProgress := Value;
  if Value < Progress then
    FProgress := Value;
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.MaxProgress:=FMaxProgress;
    FKOLCtrl.Progress:=FProgress;
  end;
  Change;
end;

procedure TKOLProgressBar.SetProgress(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetProgress', 0
  @@e_signature:
  end;
  if Value < 0 then Exit;
  FProgress := Value;
  if Value > MaxProgress then
    FMaxProgress := Value;
  if Assigned(FKOLCtrl) then begin
    FKOLCtrl.MaxProgress:=FMaxProgress;
    FKOLCtrl.Progress:=FProgress;
  end;
  Change;
end;

procedure TKOLProgressBar.SetProgressColor(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetProgressColor', 0
  @@e_signature:
  end;
  FProgressColor := Value;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.ProgressColor:=Value;
  Change;
end;

procedure TKOLProgressBar.SetSmooth(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetSmooth', 0
  @@e_signature:
  end;
  FSmooth := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLProgressBar.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    if  Smooth or Vertical then
    begin
        KF.FormAddAlphabet( 'FormNewProgressBarEx', TRUE, TRUE, '' );
        KF.FormAddNumParameter( Integer(Smooth) or Integer(Vertical) shl 1 );
    end else
        KF.FormAddAlphabet( 'FormNewProgressBar', TRUE, TRUE, '' );
end;

procedure TKOLProgressBar.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  MaxProgress <> 100 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetMaxProgress', '' );
          KF.FormAddNumParameter( MaxProgress );
      end else
      SL.Add( Prefix + AName + '.MaxProgress := ' + IntToStr( MaxProgress ) + ';' );

  if  Progress <> 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetProgress', '' );
          KF.FormAddNumParameter( Progress );
      end else
      SL.Add( Prefix + AName + '.Progress := ' + IntToStr( Progress ) + ';' );

  if  ProgressColor <> clHighLight then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetProgressColor', '' );
          KF.FormAddNumParameter( (ProgressColor shl 1) or (ProgressColor shr 31) );
      end else
      SL.Add( Prefix + AName + '.ProgressColor := ' + Color2Str( ProgressColor ) + ';' );
end;

function TKOLProgressBar.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent;
  if Smooth or Vertical then
  begin
    S := '';
    if Smooth then
      S := 'pboSmooth';
    if Vertical then
      S := S + ', pboVertical';
    if S <> '' then
    if S[ 1 ] = ',' then
      S := Copy( S, 3, MaxInt );
    Result := Result + ', [ ' + S + ' ]';
  end;
end;

procedure TKOLProgressBar.SetVertical(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.SetVertical', 0
  @@e_signature:
  end;
  FVertical := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

function TKOLProgressBar.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLProgressBar.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLProgressBar.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if Smooth or Vertical then
    Result := 'ProgressBarEx';
end;

{ TKOLTabControl }

procedure TKOLTabControl.AdjustPages;
var R: TRect;
    Dx, Dy: Integer;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.AdjustPages', 0
  @@e_signature:
  end;
  if Parent = nil then
    Exit;
  R := ClientRect;
  Inc( R.Left, 4 );
  Inc( R.Top, 4 );
  Dec( R.Right, 4 );
  Dec( R.Bottom, 4 );
  Dx := 0;
  Dy := 22;
  if tcoVertical in Options then
  begin
    Dx := 22;
    Dy := 0;
  end;
  if tcoBottom in Options then
  begin
    Dec( R.Right, Dx );
    Dec( R.Bottom, Dy );
  end
    else
  begin
    Inc( R.Left, Dx );
    Inc( R.Top, Dy );
  end;
  FAdjustingPages := TRUE;
  for I := 0 to Count-1 do
  begin
    Pages[ I ].FOnSetBounds := AttemptToChangePageBounds;
    Pages[ I ].BoundsRect := R;
  end;
  FAdjustingPages := FALSE;
end;

procedure TKOLTabControl.AttemptToChangePageBounds(Sender: TObject;
  var NewBounds: TRect);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.AttemptToChangePageBounds', 0
  @@e_signature:
  end;
  if FAdjustingPages then Exit;
  if Count > 0 then
  begin
    AdjustPages;
    NewBounds := Pages[ 0 ].BoundsRect;
  end;
end;

constructor TKOLTabControl.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Create', 0
  @@e_signature:
  end;
  inherited;
  Width := 100;  DefaultWidth := Width;
  Height := 100; DefaultHeight := Height;
  FTabs := TList.Create;
  FedgeType := esNone;
  FgenerateConstants := TRUE;
end;

{procedure TKOLTabControl.DefineProperties(Filer: TFiler);
begin
    Beep;
    inherited;
    ShowMessage( 'TabControl DefineProperties called' );
    LogFileOutput( 'C:\log_TC.txt', 'TabControl DefineProperties called' );
    Filer.DefineProperty( 'NewTabControl', ReadNewTabControl, WriteNewTabControl,
                          fNewTabControl );
    if  Filer is TReader then
    begin
        (Filer as TReader).OnSetName := WhenReaderSetsName;
        (Filer as TReader).OnFindComponentClass := WhenFindComponentClass;
        ShowMessage( 'Filter set for TKOLTabControl!' );
        LogFileOutput( 'C:\log_TC.txt', 'Filter set' );
    end;
    ShowMessage( 'DefineProperties inherited called' );
    LogFileOutput( 'C:\log_TC.txt', 'inherited DefineProperties called' );
end;}

destructor TKOLTabControl.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Destroy', 0
  @@e_signature:
  end;
  fDestroyingTabControl := TRUE;
  for I := FTabs.Count-1 downto 0 do
    FreeMem( FTabs[ I ] );
  FTabs.Free;
  inherited;
end;

function CompareTabPages( L: TList; e1, e2: DWORD ): Integer;
var P1, P2: TKOLPanel;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'CompareTabPages', 0
  @@e_signature:
  end;
  P1 := L[ e1 ];
  P2 := L[ e2 ];
  if P1.TabOrder < P2.TabOrder then Result := -1
  else
  if P1.TabOrder > P2.TabOrder then Result := 1
  else
  Result := 0;
end;

procedure SwapTabPages( L: TList; e1, e2: DWORD );
var P: Pointer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'SwapTabPages', 0
  @@e_signature:
  end;
  P := L[ e1 ];
  L[ e1 ] := L[ e2 ];
  L[ e2 ] := P;
end;

procedure TKOLTabControl.DoGenerateConstants(SL: TStringList);
var I: Integer;
    C: TComponent;
    K: TKOLPanel;
    Pages: TList;
    F: TForm;
begin
  if not generateConstants then Exit;
  if Owner = nil then Exit;
  if not( Owner is TForm ) then Exit;
  F := Owner as TForm;
  Pages := TList.Create;
  TRY
    for I := 0 to F.ComponentCount-1 do
    begin
      C := F.Components[ I ];
      if not ( C is TKOLPanel ) then CONTINUE;
      K := C as TKOLPanel;
      if K.Parent <> Self then CONTINUE;
      Pages.Add( K );
    end;
    SortData( Pages, Pages.Count, @ CompareTabPages, @ SwapTabPages );
    for I := 0 to Pages.Count-1 do
    begin
      K := Pages[ I ];
      SL.Add( 'const _' + K.Name + ' = ' + IntToStr( I ) + ';' );
    end;
  FINALLY
    Pages.Free;
  END;
end;

function TKOLTabControl.GetCount: Integer;
var I: Integer;
    C: TComponent;
    K: TKOLPanel;
    F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetCount', 0
  @@e_signature:
  end;
  Result := 0;
  if Owner = nil then Exit;
  if not( Owner is TForm ) then Exit;
  F := Owner as TForm;
  for I := 0 to F.ComponentCount-1 do
  begin
    C := F.Components[ I ];
    if not ( C is TKOLPanel ) then CONTINUE;
    K := C as TKOLPanel;
    if K.Parent <> Self then CONTINUE;
    Inc( Result );
  end;
end;

function TKOLTabControl.GetCurIndex: Integer;
var I: Integer;
    CurPage: TKOLPanel;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetCurIndex', 0
  @@e_signature:
  end;
  Result := -1;
  CurPage := GetCurrentPage;
  if CurPage = nil then Exit;
  for I := 0 to Count-1 do
    if CurPage = Pages[ I ] then
    begin
      Result := I;
      break;
    end;
end;

function TKOLTabControl.GetCurrentPage: TKOLPanel;
var W: HWnd;
    C: TWinControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetCurrentPage', 0
  @@e_signature:
  end;
  Result := FCurPage;
  if Result = nil then
  begin
    W := GetWindow( Handle, GW_CHILD );
    if W = 0 then Exit;
    C := FindControl( W );
    if C is TKOLPanel then
    begin
      Result := C as TKOLPanel;
      FCurPage:=Result;
    end;
  end;
end;

function TKOLTabControl.GetPages(Idx: Integer): TKOLPanel;
var I: Integer;
    C: TComponent;
    K: TKOLPanel;
    F: TForm;
    L: TList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.GetPages', 0
  @@e_signature:
  end;
  Result := nil;
  L := TList.Create;
  try
    if Owner = nil then Exit;
    if not( Owner is TForm ) then Exit;
    F := Owner as TForm;
    for I := 0 to F.ComponentCount-1 do
    begin
      C := F.Components[ I ];
      if {not ( C is TKOLTabPage ) and} not ( C is TKOLPanel ) then CONTINUE;
      K := C as TKOLPanel;
      if K.Parent <> Self then CONTINUE;
      L.Add( K );
    end;
    SortData( L, L.Count, @CompareTabPages, @SwapTabPages );
    Result := L.Items[ Idx ];
  finally
    L.Free;
  end;
end;

function TKOLTabControl.HasCompactConstructor: Boolean;
begin
    {$IFDEF _D4orHigher}
    Result := TRUE;
    {$ELSE}
    Result := FALSE;
    {$ENDIF} 
end;

function TKOLTabControl.IndexOfPage(const page_name: String): Integer;
var i: Integer;
begin
    for i := 0 to Count-1 do
    begin
        if  Pages[i].Name = page_name then
        begin
            Result := i;
            Exit;
        end;
    end;
    Result := -1;
end;

{procedure TKOLTabControl.Loaded;
begin
  inherited;
  Beep;
end;}

procedure TKOLTabControl.Loaded;
var i, j: Integer;
    P: TKOLPanel;
    P2: TKOLTabPage;
    n: String;
    L0, L, L2: TList;
    C: TControl;
begin
  inherited;
  L := TList.Create;
  L0 := TList.Create;
  //{}ShowMessage( 'KOLTabPage ' + Name + ' loaded!' );
  TRY
      for i := 0 to Count-1 do
      begin
          if  Pages[i] is TKOLPanel then
              L0.Add( Pages[i] );
      end;
      for i := 0 to L0.Count-1 do
      begin
          P := TKOLPanel( L0[i] );
          if  (P is TKOLPanel) and not(P is TKOLTabPage) then
          begin
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' will be converted to TKOLTabPage' );
              P2 := TKOLTabPage.Create( P.Owner );
              P2.Parent := Self;
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' is converting to TKOLTabPage (1) - P2 created ' );
              n := P.Name;
              P.Name := '';
              P2.Name := n; ///////////////////////////////////////
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' is converting to TKOLTabPage (2) - name assigned' );
              P2.BoundsRect := P.BoundsRect; //////////////////////
              P2.TabOrder := P.TabOrder; //////////////////////////
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' is converting to TKOLTabPage (3) - TabOrder assigned' );
              P2.Align := P.Align; ////////////////////////////////
              P2.Tag := P.Tag; ////////////////////////////////////
              P2.IgnoreDefault := P.IgnoreDefault;
              P2.AnchorLeft := P.AnchorLeft;
              P2.AnchorTop := P.AnchorTop;
              P2.AnchorRight := P.AnchorTop;
              P2.AnchorBottom := P.AnchorBottom;
              P2.AcceptChildren := TRUE;
              P2.MouseTransparent := P.MouseTransparent;
              P2.MinWidth := P.MinWidth;
              P2.MinHeight := P.MinHeight;
              P2.MaxWidth := P.MaxWidth;
              P2.MaxHeight := P.MaxHeight;
              P2.Visible := P.Visible;
              P2.Enabled := P.Enabled;
              P2.DoubleBuffered := P.DoubleBuffered;
              P2.CenterOnParent := P.CenterOnParent;
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' is converting to TKOLTabPage (4) - something assigned' );
              P2.Caption := P.Caption; ////////////////////////////
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' is converting to TKOLTabPage (5) - Caption assigned' );
              P2.Ctl3D := P.Ctl3D; ////////////////////////////////
              P2.Color := P.Color; ////////////////////////////////
              P2.parentColor := P.parentColor; ////////////////////
              P2.Font.Assign( P.Font );
              P2.parentFont := P.parentFont;
              P2.EraseBackground := P.EraseBackground;
              P2.Localizy := P.Localizy;
              P2.Transparent := P.Transparent;
              P2.TextAlign := P.TextAlign;
              P2.edgeStyle := P.edgeStyle;
              P2.VerticalAlign := P.VerticalAlign;
              P2.Border := P.Border;
              P2.MarginTop := P.MarginTop;
              P2.MarginBottom := P.MarginBottom;
              P2.MarginLeft := P.MarginLeft;
              P2.MarginRight := P.MarginRight;
              P2.Brush.Assign( P.Brush );
              P2.ShowAccelChar := P.ShowAccelChar;
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' is converting to TKOLTabPage (6) - more props assigned' );
              L2 := TList.Create;
              TRY
                  for j := 0 to P.ControlCount-1 do
                  begin
                      C := P.Controls[j];
                      L2.Add( C );
                  end;
                  for j := 0 to L2.Count-1 do
                  begin
                      C := TControl( L2[j] );
                      C.Parent := P2;
                  end;
              FINALLY
                  L2.Free;
              END;
              //{}ShowMessage( 'Page ' + IntToStr( i ) + ' was converted to TKOLTabPage' );
              L.Add( P );
          end;
      end;
      if  L.Count > 0 then
          ShowMessage( 'Please note that TKOLTabControl component ' + Name +
          ' was created in elder version of MCK so its pages (' + IntToStr( L.Count ) +
          ') was converted from TKOLPanel to TKOLTabPage.' + #13#10#13#10 +
          'To finish converting it remove empty duplicated pages manually ' +
          '(select it clicking by mouse and delete pressing DELETE key, to ' +
          'switch pages use double click on tabs as usual). Then' +
          ' save the form (Ctrl+S) and' +
          ' answer Yes to a request' +
          ' for correcting tabs declaration (this should be safe). ' +
          'Such question will be answered for each tab in the Tab control.' +
          #13#10#13#10 +
          '----- translation to Russian -----'#13#10#13#10 +
          'Îáðàòèòå âíèìàíèå, ÷òî êîìïîíåíò ' + Name + ' êëàññà TKOLTabControl ' +
          'áûë ñîçäàí â ðàííèõ âåðñèÿõ MCK è åãî ñòðàíèöû îòêîíâåðòèðîâàíû ' +
          'èç êëàññà TKOLPanel â TKOLTabPage.' + #13#10#13#10 +
          'Äëÿ çàâåðøåíèÿ êîíâåðòèðîâàíèÿ âðó÷íóþ óäàëèòå ñ òàáóëèðîâàííîãî êîíòðîëà ' +
          'ëèøíèå ïóñòûå ñòðàíèöû (âûäåëÿÿ èõ êëèêîì ìûøè è íàæèìàÿ DELETE, äëÿ ' +
          'ïåðåêëþ÷åíèÿ ñòðàíèö ìñïîëüçóéòå äâîéíîé êëèê ïî çàêëàäêå êàê îáû÷íî). ' +
          'Çàòåì ñîõðàíèòå ôîðìó ' +
          '(Ctrl+S) è îòâåòüòå Yes íà çàïðîñ ñ çàãîëîâêîì Error è ñ òåêñòîì âèäà '#13#10 +
          '"Field Form1.TabControl1_Tab0 should be of type TKOLTabPage but it is ' +
          'declared as TKOLPanel. Correct the declaration?". Òàêîé âîïðîñ áóäåò çàäàí ' +
          'äëÿ êàæäîé ñòðàíèöû òàáóëèðîâàííîãî êîíòðîëà îòäåëüíî.' );
      (*for j := 0 to L0.Count-1 do
      begin
          P := TKOLPanel( L[j] );
          if  not(P is TKOLTabPage) and (P is TKOLPanel) then
          begin
              //{}ShowMessage( 'Old Page ' + IntToStr( j ) + ' will be destroyed' );
              P.Parent := nil;
              //ShowMessage( 'Old Page ' + IntToStr( j ) + ' detached from parent' );
              P.Free;
              //{}ShowMessage( 'Old Page ' + IntToStr( j ) + ' freed' );
          end;
      end;*)
  FINALLY
      L.Free;
      L0.Free;
  END;
end;

function TKOLTabControl.NoDrawFrame: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLTabControl.Paint;
var
  R, CurR: TRect;
  I, Tw, Sx, Sy, W, H: Integer;
  S : String;
  CurPage: TKOLPanel;
  M: PRect;
  DirXX_YY,DirXY_YX:SmallInt;
  O_V, O_B, O_BTN, O_F, O_BRD: Boolean;
  P:TPoint;
  Col: array[0..3] of TColor;
  Fnt: HFont;

 procedure _MoveTo(const x,y:integer);
 begin
   p.x:=x;
   p.y:=y;
   canvas.moveto(x,y);
 end;

 procedure MoveRel(const dx,dy:integer);
 begin
   p.x:=p.x+dirxx_yy*dx+dirxy_yx*dy;
   p.y:=p.y+dirxx_yy*dy+dirxy_yx*dx;
   canvas.moveto(p.x,p.y);
 end;

 procedure LineRel(const dx,dy:integer);
 begin
   p.x:=p.x+dirxx_yy*dx+dirxy_yx*dy;
   p.y:=p.y+dirxx_yy*dy+dirxy_yx*dx;
   canvas.lineto(p.x,p.y);
 end;

 procedure prepare(const r:trect);
 begin
   if o_v xor o_b then
   begin
     sy:=r.top;
     sx:=r.right;
   end else
   begin
     sy:=r.bottom;
     sx:=r.left;
   end;
   if o_v then
   begin
     h:=r.right-r.left;
     w:=r.bottom-r.top;
   end else
   begin
     w:=r.right-r.left;
     h:=r.bottom-r.top;
   end;
   if o_b then
   begin
     dec(sx);
     dec(sy);
   end;
   dec(h,2);
 end;

 procedure DrawTab(r:trect; const cur:boolean);
 begin
   inflaterect(r,2,2);
   if o_btn then
   begin
     if not cur and o_f
       then drawedge(canvas.handle,r,BDR_RAISEDOUTER,BF_RECT or BF_SOFT)
       else drawedge(canvas.handle,r,EDGE_RAISED*succ(ord(cur)),BF_RECT or BF_SOFT);
     if cur then
     begin
       inflaterect(r,-2,-2);
       drawcaption(findwindow('Shell_TrayWnd',nil),canvas.handle,r,
         DC_TEXT or DC_ACTIVE or DC_INBUTTON);
     end;
   end else
   begin
     if cur then
     begin
       inflaterect(r,2,2);
       if o_b
         then if o_v then inc(r.left,2) else inc(r.top,2)
        else if o_v then dec(r.right,2) else dec(r.bottom,2);
     end;
     prepare(r);
     with canvas,r do
     begin
       if cur then
       begin
         _moveto(sx,sy);
         moverel(0,-2);
         pen.color:=clbtnface;
         linerel(w-3,0);
         linerel(0,1);
         linerel(4-w,0);
       end;
       _moveto(sx,sy);
       moverel(0,-2);
       pen.color:=col[0];
       linerel(0,2-h);
       linerel(2,-2);
       linerel(w-4,0);
       moverel(0,1);
       pen.color:=col[1];
       linerel(1,1);
       linerel(0,h-1);
       _moveto(sx,sy);
       moverel(1,-2);
       pen.color:=col[2];
       linerel(0,2-h);
       linerel(1,-1);
       linerel(w-4,0);
       moverel(0,1);
       pen.color:=col[3];
       linerel(0,h-1);
     end;
   end;
 end;

 procedure preparefont;
 var
   a:integer;
 begin
   a:=900*pred(ord(not o_b) shl 1);
   fnt:=createfont(10,0,a,a,0,0,0,0,DEFAULT_CHARSET,OUT_DEFAULT_PRECIS,
     CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,VARIABLE_PITCH,'MS Serif');
 end;

begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Paint', 0
  @@e_signature:
  end;
  if PaintType = ptSchematic then
  begin
    SchematicPaint;
    Exit;
  end;
  o_b:=tcobottom in options;
  o_v:=tcovertical in options;
  o_btn:=tcobuttons in options;
  o_f:=tcoflat in options;
  o_brd:=tcoBorder in options;
  r:=clientrect;
  if o_brd then
  begin
    drawedge(canvas.handle,r,EDGE_SUNKEN,BF_RECT);
    inflaterect(r,-2,-2);
  end;
  inflaterect(r,-4,-4);
  if o_b
    then if o_v then r.left:=r.right-17 else r.top:=r.bottom-17
    else if o_v then r.right:=r.left+17 else r.bottom:=r.top+17;
  dirxx_yy:=ord(not o_v)*pred(ord(not o_b) shl 1);
  dirxy_yx:=ord(o_v)*pred(ord(not o_b) shl 1);
  col[0 xor ord(o_b)]:=clbtnhighlight;
  col[1 xor ord(o_b)]:=cl3ddkshadow;
  col[2 xor ord(o_b)]:=cl3dlight;
  col[3 xor ord(o_b)]:=clbtnshadow;
  if not o_v then PrepareCanvasFontForWYSIWIGPaint(canvas) else
  begin
    preparefont;
    selectobject(canvas.handle,fnt);
  end;
  curpage:=getcurrentpage;
  for i:=0 to pred(ftabs.count) do freemem(ftabs[i]);
  ftabs.clear;
  setbkmode(canvas.handle,windows.TRANSPARENT);
  for i:=0 to pred(count) do
  begin
    getmem(m,sizeof(trect));
    s:=pages[i].caption;
    tw:=canvas.textwidth(s);
    if o_v then r.bottom:=r.top+tw+8 else r.right:=r.left+tw+8;
    m^:=r;
    ftabs.add(m);
    if curpage=pages[i] then curr:=r else
    begin
      drawtab(r,false);
      drawtext(canvas.handle,pchar(s),length(s),r,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    pages[i].fonsetbounds:=attempttochangepagebounds;
    if o_v then r.top:=r.bottom+4 else r.left:=r.right+4;
    if o_btn then
      if o_v then inc(r.top,2) else inc(r.left,2);
  end;
  r:=clientrect;
  if o_brd then inflaterect(r,-2,-2);
  if o_b
    then if o_v then r.right:=r.right-21 else r.bottom:=r.bottom-21
    else if o_v then r.left:=r.left+21 else r.top:=r.top+21;
  if not o_btn then drawedge(canvas.handle,r,EDGE_RAISED,BF_RECT or BF_SOFT);
  if curpage<>nil then
  begin
    drawtab(curr,true);
    s:=curpage.caption;
    if o_btn then offsetrect(curr,2,2) else offsetrect(curr,-2*dirxy_yx,-2*dirxx_yy);
    drawtext(canvas.handle,pchar(s),length(s),curr,DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;
  if o_v then deleteobject(fnt);
  inherited;
end;

function TKOLTabControl.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLTabControl.P_SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var i: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Count > 0 then
  begin
    SL.Add( ' C2R L(' + IntToStr( Count ) + ') DELN R2C DUP C2R' );
    for i := Count-1 downto 0 do
    begin
      SL.Add( ' L(' + IntToStr( i ) + ') R2C DUP C2R ' +
              ' TControl_.GetPages<2> RESULT' );
    end;
    SL.Add( ' R2C DEL' );
  end;
  case edgeType of
  esLowered:;
  esRaised: //SL.Add( Prefix + AName + '.Style := ' + AName + '.Style or WS_THICKFRAME;' );
            {P}SL.Add( ' DUP AddWord_LoadRef ##TControl_.fStyle L(' + IntToStr( WS_THICKFRAME ) + ')' +
               ' C1 TControl_.SetStyle<2>' );
  //esNone, esTransparent, esSolid:   ;
  end;
end;

procedure TKOLTabControl.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.P_SetupLast', 0
  @@e_signature:
  end;
  inherited;
  if CurIndex > 0 then
  begin
    //SL.Add( Prefix + '  ' + AName + '.CurIndex := ' + IntToStr( CurIndex ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( CurIndex ) + ')' );
    {P}SL.Add( ' ' +
      'LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name +
      ' C1 C1 TControl_.SetCurIndex<2>' );
    //SL.Add( Prefix + '  ' + AName + '.Pages[ ' + IntToStr( CurIndex ) + ' ].BringToFront;' );
    {P}SL.Add( ' ' +
      ' TControl_.GetPages<2> RESULT' );
    {P}SL.Add( ' TControl.BringToFront<1>' );
  end;
end;

function TKOLTabControl.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var //O, IL, S: String;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.P_SetupParams', 0
  @@e_signature:
  end;
  {S := '';
  for I := 0 to Count - 1 do
  begin
    if S <> '' then
      S := S + ', ';
    S := S + StringConstant( 'Page' + IntToStr( I ) + 'Caption', Pages[ I ].Caption );
  end;
  O := '';
  if tcoButtons in Options then
    O := 'tcoButtons';
  if tcoFixedWidth in Options then
    O := O + ', tcoFixedWidth';
  if tcoFocusTabs in Options then
    O := O + ', tcoFocusTabs';
  if tcoIconLeft in Options then
    O := O + ', tcoIconLeft';
  if tcoLabelLeft in Options then
    O := O + ', tcoLabelLeft';
  if tcoMultiline in Options then
    O := O + ', tcoMultiline';
  if tcoMultiselect in Options then
    O := O + ', tcoMultiselect';
  if tcoFitRows in Options then
    O := O + ', tcoFitRows';
  if tcoScrollOpposite in Options then
    O := O + ', tcoScrollOpposite';
  if tcoBottom in Options then
    O := O + ', tcoBottom';
  if tcoVertical in Options then
    O := O + ', tcoVertical';
  if tcoFlat in Options then
    O := O + ', tcoFlat';
  if tcoHotTrack in Options then
    O := O + ', tcoHotTrack';
  if tcoBorder in Options then
    O := O + ', tcoBorder';
  if tcoOwnerDrawFixed in Options then
    O := O + ', tcoOwnerDrawFixed';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  IL := 'nil';
  if ImageList <> nil then
    IL := 'Result.' + ImageList.Name;
  Result := AParent + ', [ ' + S + ' ], [ ' + O + ' ], ' + IL
            + ', ' + IntToStr( ImageList1stIdx );}

  if Count > 0 then
  begin
    {P}Result := ' L(' + IntToStr( Count ) + ') LoadPCharArray';
    for i := Count-1 downto 0 do
     begin
       Result := Result + ' ''' + Pages[ i ].Caption + ''' #0';
     end;
  end;
  Result := Result + #13#10' LoadStack C2R';

  {P}Result := Result + ' L(' + IntToStr( PWord( @ Options )^ ) + ')';
  {P}if ImageList=nil then Result := Result + ' L(0)'
     else if ImageList.ParentKOLForm = ParentKOLForm then
          Result := Result + #13#10' LoadSELF AddWord_LoadRef ##T' +
          ParentKOLForm.FormName + '.' + ImageList.Name
     else Result := Result + #13#10' Load4 ####T' + ImageList.ParentKOLForm.FormName +
          #13#10' AddWord_LoadRef ##T' + ImageList.ParentKOLForm.FormName +
          '.' + ImageList.Name;
  {P}Result := Result + #13#10' L(' + IntToStr( ImageList1stIdx ) + ')';

  {P}Result := Result + #13#10' L(' + IntToStr( Count-1 ) + ') R2C';
  {P}Result := Result + #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
               '.';
     if Parent is TForm then Result := Result + 'Form'
     else Result := Result + Parent.Name;

  nparams := 3;
end;

{procedure TKOLTabControl.ReadNewTabControl(Reader: TReader);
begin
    ShowMessage( 'Reader is reading NewTabControl property' );
    LogFileOutput( 'C:\log_TC.txt', 'Reader is reading NewTabControl property' );
    fNewTabControl := Reader.ReadBoolean;
    //if  not fNewTabControl then
    begin
        Reader.OnFindComponentClass := WhenFindComponentClass;
        Reader.OnSetName := WhenReaderSetsName;
    end;
end;}

procedure TKOLTabControl.SchematicPaint;
var R: TRect;
    I, Tw, Th: Integer;
    S: String;
    CurPage: TKOLPanel;
    M: PRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.Paint', 0
  @@e_signature:
  end;
  inherited Paint;
  R := ClientRect;
  Inc( R.Top, 4 );
  Inc( R.Left, 4 );
  Dec( R.Right, 4 );
  Dec( R.Bottom, 4 );
  if tcoBottom in Options then
    if tcoVertical in Options then
      R.Left := R.Right - 18
    else
      R.Top := R.Bottom - 18
  else
    if tcoVertical in Options then
      R.Right := R.Left + 18
    else
      R.Bottom := R.Top + 18;
  R.Right := R.Left + 18;
  R.Bottom := R.Top + 18;
  Canvas.Font.Height := 8;
  Canvas.Brush.Color := clDkGray;
  CurPage := GetCurrentPage;
  for I := 0 to FTabs.Count-1 do
    FreeMem( FTabs[ I ] );
  FTabs.Clear;
  for I := 0 to Count-1 do
  begin
    GetMem( M, SizeOf( TRect ) );
    M^ := R;
    FTabs.Add( M );
    S := IntToStr( I );
    Tw := Canvas.TextWidth( S );
    Th := Canvas.TextHeight( S );
    Canvas.TextRect( R, R.Left + (18 - Tw) div 2, R.Top + (18 - Th) div 2, S );
    Pages[ I ].FOnSetBounds := AttemptToChangePageBounds;
    if CurPage = Pages[ I ] then
    begin
      Canvas.Brush.Color := clBlack;
      Canvas.FrameRect( R );
      Canvas.Brush.Color := clDkGray;
    end;
    if tcoVertical in Options then
    begin
      Inc( R.Top, 22 );
      Inc( R.Bottom, 22 );
    end
      else
    begin
      Inc( R.Left, 22 );
      Inc( R.Right, 22 );
    end;
  end;
end;

procedure TKOLTabControl.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetBounds', 0
  @@e_signature:
  end;
  inherited;
  AdjustPages;
end;

procedure TKOLTabControl.SetCount(const Value: Integer);
var Pg: TKOLPanel;
    I: Integer;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetCount', 0
  @@e_signature:
  end;
  if Value < Count then Exit;
  if csLoading in ComponentState then Exit;
  I := Count;
  while Value > Count do
  begin
    while True do
    begin
      S := Name + '_Tab' + IntToStr( I );
      if (Owner as TForm).FindComponent( S ) = nil then
        break;
      Inc( I );
    end;
    Pg := TKOLTabPage.Create( Owner );
    Pg.Parent := Self;
    Pg.Name := S;
    Pg.Caption := 'Tab' + IntToStr( I );
    Pg.edgeStyle := esNone;
    Inc( I );
  end;
  AdjustPages;
  Invalidate;
  Change;
end;

procedure TKOLTabControl.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetCurIndex', 0
  @@e_signature:
  end;
  if (Value >= Count) or (Value < 0) then
  begin
    FCurPage := nil;
    Exit;
  end;
  FCurPage:=Pages[ Value ];
  if FCurPage <> nil then
  begin
    FCurPage.BringToFront;
    Invalidate;
  end;
  Change;
end;

procedure TKOLTabControl.SetedgeType(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetedgeType', 0
  @@e_signature:
  end;
  FedgeType := Value;
  if Value in [esNone,esTransparent,esSolid] then
    Options := Options - [ tcoBorder ]
  else
    Options := Options + [ tcoBorder ];
  Change;
end;

procedure TKOLTabControl.SetgenerateConstants(const Value: Boolean);
begin
  FgenerateConstants := Value;
  Change;
end;

procedure TKOLTabControl.SetImageList(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetImageList', 0
  @@e_signature:
  end;
  FImageList := Value;
  Change;
end;

procedure TKOLTabControl.SetImageList1stIdx(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetImageList1stIdx', 0
  @@e_signature:
  end;
  FImageList1stIdx := Value;
  Change;
end;

procedure TKOLTabControl.SetOptions(const Value: TTabControlOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  AdjustPages;
  Invalidate;
  Change;
end;

procedure TKOLTabControl.SetupConstruct_Compact;
var KF: TKOLForm;
    i: Integer;
    C: String;
begin
    inherited;
    {$IFDEF _D4orHigher}
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewTabControl', TRUE, TRUE, '' );
    KF.FormAddNumParameter( Count );
    for i := 0 to Count-1 do
    begin
        C := Pages[i].Caption;
        if  not KF.AssignTextToControls then
            C := '';
        KF.FormAddStrParameter( C );
    end;
    KF.FormAddNumParameter( PByte( @ Options )^ );
    KF.FormAddNumParameter( ImageList1stIdx );
    {$ELSE}
    {$ENDIF}
end;

procedure TKOLTabControl.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  case edgeType of
  esLowered:;
  esRaised:
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetStyle', '' );
          KF.FormAddNumParameter( WS_THICKFRAME );
      end else
      SL.Add( Prefix + AName + '.Style := ' + AName +
                     '.Style or WS_THICKFRAME;' );
  //esNone, esTransparent, esSolid:   ;
  end;
end;

procedure TKOLTabControl.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetupLast', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  CurIndex > 0 then
  begin
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetCurrentTab', '' );
          KF.FormAddNumParameter( CurIndex );
      end
        else
      begin
          SL.Add( Prefix + '  ' + AName + '.CurIndex := ' + IntToStr( CurIndex ) + ';' );
          SL.Add( Prefix + '  ' + AName + '.Pages[ ' + IntToStr( CurIndex ) + ' ].BringToFront;' );
      end;
  end;
end;

function TKOLTabControl.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var O, IL: String;
    I: Integer;
    KF: TKOLForm;
{$IFDEF _D2009orHigher}
  C, C2, S: WideString;
 j : integer;
{$ELSE}
  C, S: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.SetupParams', 0
  @@e_signature:
  end;
  S := '';
  KF := ParentKOLForm;
  for I := 0 to Count - 1 do
  begin
    if S <> '' then
      S := S + ', ';
    if  (KF <> nil) and KF.AssignTextToControls then
        C := StringConstant('Page' + IntToStr( I ) + 'Caption', Pages[ I ].Caption)
    else
        C := '''''';
    {$IFDEF _D2009orHigher}
    if C <> '''''' then
    begin
      C2 := '';
      for j := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[j]));
      C := C2;
    end;
    {$ENDIF}

    S := S + C;
  end;
  O := '';
  if tcoButtons in Options then
    O := 'tcoButtons';
  if tcoFixedWidth in Options then
    O := O + ', tcoFixedWidth';
  if tcoFocusTabs in Options then
    O := O + ', tcoFocusTabs';
  if tcoIconLeft in Options then
    O := O + ', tcoIconLeft';
  if tcoLabelLeft in Options then
    O := O + ', tcoLabelLeft';
  if tcoMultiline in Options then
    O := O + ', tcoMultiline';
  if tcoMultiselect in Options then
    O := O + ', tcoMultiselect';
  if tcoFitRows in Options then
    O := O + ', tcoFitRows';
  if tcoScrollOpposite in Options then
    O := O + ', tcoScrollOpposite';
  if tcoBottom in Options then
    O := O + ', tcoBottom';
  if tcoVertical in Options then
    O := O + ', tcoVertical';
  if tcoFlat in Options then
    O := O + ', tcoFlat';
  if tcoHotTrack in Options then
    O := O + ', tcoHotTrack';
  if tcoBorder in Options then
    O := O + ', tcoBorder';
  if tcoOwnerDrawFixed in Options then
    O := O + ', tcoOwnerDrawFixed';
  if O <> '' then
  if O[ 1 ] = ',' then
    O := Copy( O, 3, MaxInt );
  IL := 'nil';
  if ImageList <> nil then
    IL := 'Result.' + ImageList.Name;
  Result := AParent + ', [ ' + S + ' ], [ ' + O + ' ], ' + IL
            + ', ' + IntToStr( ImageList1stIdx );
end;

function TKOLTabControl.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLTabControl.TabStopByDefault: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControl.TabStopByDefault', 0
  @@e_signature:
  end;
  Result := TRUE;
end;

{procedure TKOLTabControl.WhenFindComponentClass(Reader: TReader;
  const CClassName: string; var CComponentClass: TComponentClass);
begin
  if  (pos( '_Tab', fNameSetByReader ) > 0)
  and (CClassName = 'TKOLPanel') then
  begin
      CComponentClass := TKOLTabPage;
      ShowMessage( 'TKOLPanel class replaced with TKOLTabPage for ' + fNameSetByReader );
  end
  else
      inherited;
end;

procedure TKOLTabControl.WhenReaderSetsName(Reader: TReader;
  Component: TComponent; var AName: string);
begin
  inherited;
  fNameSetByReader := AName;
  ShowMessage( 'Reader sets name ' + AName );
  LogFileOutput( 'C:\log_TC.txt', 'Reader sets name ' + AName );
end;

procedure TKOLTabControl.WriteNewTabControl(Writer: TWriter);
begin
    Writer.WriteBoolean( TRUE );
end;
}

function TKOLTabControl.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLToolbar }

function TKOLToolbar.AllPicturedButtonsAreLeading: Boolean;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := FALSE;
  if PicturedButtonsCount = 0 then Exit;
  Bt := Items[ 0 ];
  if not Bt.HasPicture then Exit;
  Result := TRUE;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if not Bt.HasPicture then
    begin
      if NoMorePicturedButtonsFrom( I ) then
        break;
      Result := FALSE;
      break;
    end;
  end;
end;

function TKOLToolbar.LastBtnHasPicture: Boolean;
var Bt: TKOLToolbarButton;
begin
  Result := FALSE;
  if PicturedButtonsCount = 0 then Exit;
  if not Assigned( Items ) then Exit;
  if Items.Count = 0 then Exit;
  Bt := Items[ Items.Count-1 ];
  Result := Bt.HasPicture;
end;

procedure TKOLToolbar.AssembleBitmap;
var MaxWidth, MaxHeight: Integer;
    I: Integer;
    Bt: TKOLToolbarButton;
    TranColor: TColor;
    TmpBmp: TBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.AssembleBitmap', 0
  @@e_signature:
  end;
  MaxWidth := 0;
  MaxHeight := 0;
  TranColor := clNone;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture then
    begin
      if MaxWidth < Bt.picture.Width then
        MaxWidth := Bt.picture.Width;
      if MaxHeight < Bt.picture.Height then
        MaxHeight := Bt.picture.Height;
      if TranColor = clNone then
      begin
        TmpBmp := TBitmap.Create;
        TRY
          TmpBmp.Width := Bt.picture.Width;
          TmpBmp.Height := Bt.picture.Height;
          TmpBmp.Canvas.Draw( 0, 0, Bt.picture.Graphic );
          TranColor := TmpBmp.Canvas.Pixels[ 0, TmpBmp.Height - 1 ];
        FINALLY
          TmpBmp.Free;
        END;
      end;
    end;
  end;
  if (MaxWidth = 0) or (MaxHeight = 0) then
  begin
    Fbitmap.Width := 0;
    Fbitmap.Height := 0;
  end
    else
  begin
    Fbitmap.Width := MaxWidth * Items.Count;
    Fbitmap.Height := MaxHeight;
    if TranColor <> clNone then
    begin
      Fbitmap.Canvas.Brush.Color := TranColor;
      Fbitmap.Canvas.FillRect( Rect( 0, 0, Fbitmap.Width, Fbitmap.Height ) );
    end;
    for I := 0 to Items.Count - 1 do
    begin
      Bt := Items[ I ];
      if Bt.HasPicture then
        Fbitmap.Canvas.Draw( I * MaxWidth, 0, Bt.picture.Graphic );
    end;
  end;
  if ActiveDesign <> nil then
  begin
    ActiveDesign.Bitmap.Assign( Fbitmap );
    ActiveDesign.ApplyImages;
  end;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
end;

function IsBitmapEmpty( Bmp: TBitmap ): Boolean;
var Y, X: Integer;
    Color1: TColor;
    Lin: PDWORD;
    KOLBmp: KOL.PBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'IsBitmapEmpty', 0
  @@e_signature:
  end;
  Result := TRUE;
  if not Assigned( Bmp ) then Exit;
  if Bmp.Width * Bmp.Height = 0 then Exit;
  KOLBmp := NewBitmap( Bmp.Width, Bmp.Height );
  TRY

    KOLBmp.HandleType := KOL.bmDIB;
    KOLBmp.PixelFormat := KOL.pf32bit;
    BitBlt( KOLBmp.Canvas.Handle, 0, 0, Bmp.Width, Bmp.Height,
            Bmp.Canvas.Handle, 0, 0, SrcCopy );
    Lin := KOLBmp.ScanLine[ 0 ];
    if Lin = nil then
    begin
      Result := FALSE;
      Exit;
    end;
    Color1 := Lin^ and $FFFFFF;
    for Y := 0 to KOLBmp.Height-1 do
    begin
      Lin := KOLBmp.ScanLine[ Y ];
      for X := 0 to KOLBmp.Width-1 do
      begin
        if DWORD(Lin^ and $FFFFFF) <> DWORD( Color1 ) then
        begin
          Result := FALSE;
          Exit;
        end;
        Inc( Lin );
      end;
    end;
  FINALLY
    KOLBmp.Free;
  END;
end;

procedure TKOLToolbar.AssembleTooltips;
var SL: TStringList;
    I, N: Integer;
    Bt: TKOLToolbarButton;
    {$IFDEF _D2009orHigher}
    C : WideString;
    J : integer;
    {$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.AssembleTooltips', 0
  @@e_signature:
  end;
  N := 0;
  SL := TStringList.Create;
  TRY
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      if Bt.separator then continue;
      {$IFDEF _D2009orHigher}
       for J := 2 to Length(Bt.Ftooltip) - 1 do C := C + '#'+int2str(ord(Bt.Ftooltip[J]));
       SL.Add( C );
      {$ELSE}
       SL.Add( Bt.Ftooltip );
      {$ENDIF}
      if Length( Bt.Ftooltip ) > 0 then
        Inc( N );
    end;
    if N = 0 then
      SL.Clear;
    tooltips := SL;
    showTooltips := SL.Count > 0;
  FINALLY
    SL.Free;
  END;
end;

procedure TKOLToolbar.bitmap2ItemPictures( AnyWay: Boolean );
var W, I: Integer;
    Bmp: TBitmap;
    Bt: TKOLToolbarButton;
    Format: TPixelFormat;
    KOLBmp: KOL.PBitmap;
    Colors: KOL.PList;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.bitmap2ItemPictures', 0
  @@e_signature:
  end;
  if not Assigned( bitmap ) then Exit;
  if Items.Count = 0 then Exit;
  if bitmap.Width = 0 then Exit;
  if bitmap.Height = 0 then Exit;
  if not AnyWay then
  begin
    for I := 0 to Items.Count - 1 do
    begin
      Bt := Items[ I ];
      if Bt.HasPicture then
        Exit;
    end;
    ShowMessage( 'Restoring toolbar buttons bitmap from then previous version of the KOL&MCK format.' );
  end;
  W := bitmap.Width div Items.Count;
  Bmp := TBitmap.Create;
  KOLBmp := NewDIBBitmap( Bitmap.Width, Bitmap.Height, KOL.pf32bit );
  TRY
    BitBlt( KOLBmp.Canvas.Handle, 0, 0, bitmap.Width, bitmap.Height,
            bitmap.Canvas.Handle, 0, 0, SRCCOPY );
    KOLBmp.HandleType := KOL.bmDIB;
    KOLBmp.PixelFormat := KOL.pf32bit;
    Colors := NewList;
    TRY
        case CountSystemColorsUsedInBitmap( KOLBmp, Colors ) of
        KOL.pf1bit: Format := pf1bit;
        KOL.pf4bit: Format := pf4bit;
        KOL.pf8bit: Format := pf8bit;
        else        Format := pf24bit;
        end;
    FINALLY
        Colors.Free;
    END;
  FINALLY
    KOLBmp.Free;
  END;
  TRY
    Bmp.Width := W;
    Bmp.Height := bitmap.Height;
    {$IFNDEF _D2}
    Bmp.PixelFormat := Format;
    {$ENDIF}
    for I := 0 to Items.Count - 1 do
    begin
      if I >= Items.Count then break;
      if Items[ I ] = nil then break;
      Bmp.Canvas.CopyRect( Rect( 0, 0, Bmp.Width, Bmp.Height ),
                           bitmap.Canvas,
                           Rect( I * Bmp.Width, 0, (I + 1) * Bmp.Width, Bmp.Height ) );
      Bt := Items[ I ];
      if IsBitmapEmpty( Bmp ) then
      begin
        Bt.Fpicture.Free;
        Bt.Fpicture := TPicture.Create;
      end
        else
      begin
        Bt.Fpicture.Assign( Bmp );
      end;
    end;
  FINALLY
    Bmp.Free;
  END;
end;

procedure TKOLToolbar.buttons2Items;
var I, J: Integer;
    S, C: String;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.buttons2Items', 0
  @@e_signature:
  end;
  S := buttons;
  J := 0;
  while S <> '' do
  begin
    I := pos( #1, S );
    if I > 0 then
    begin
      C := Copy( S, 1, I - 1 );
      S := Copy( S, I + 1, MaxInt );
    end
      else
    begin
      C := S;
      S := '';
    end;
    if J >= Items.Count then
      Bt := TKOLToolbarButton.Create( Self )
    else
      Bt := Items[ J ];
    if C <> '' then
    if C[ 1 ] = '^' then
    begin
      C := Copy( C, 2, MaxInt );
      Bt.Fdropdown := TRUE;
    end;
    Bt.Fcaption := C;
    if C <> '-' then
      Bt.Fseparator := FALSE;
    Inc( J );
  end;
  bitmap2ItemPictures( FALSE );
end;

procedure TKOLToolbar.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Change', 0
  @@e_signature:
  end;
  inherited;
  if ActiveDesign <> nil then
    ActiveDesign.RefreshItems;
  if ParentForm <> nil then
    if ParentForm.Designer <> nil then
      ParentForm.Designer.Modified;
end;

constructor TKOLToolbar.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Create', 0
  @@e_signature:
  end;
  Ftooltips := TStringList.Create;
  inherited;
  FFixFlatXP := TRUE;
  FgenerateConstants := TRUE;
  FHeightAuto := TRUE;
  Fitems := TList.Create;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  Height := 22; DefaultHeight := Height;
  Width := 400;
  DefaultWidth := 400;
  Align := caTop;
  FBitmap := TBitmap.Create;
  {$IFNDEF VER90}
  FmapBitmapColors := TRUE;
  {$ENDIF}
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
  FTimer := TTimer.Create( Self );
  FTimer.Interval := 200;
  FTimer.OnTimer := Tick;
  FTimer.Enabled := TRUE;
  AllowPostPaint := True;
  FAllowBitmapCompression := TRUE;
end;

procedure TKOLToolbar.DefineProperties(Filer: TFiler);
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.DefineProperties', 0
  @@e_signature:
  end;
  inherited;
  Filer.DefineProperty( 'Buttons_Count', LoadButtonCount, SaveButtonCount, TRUE );
  for I := 0 to FButtonCount-1 do
  begin
    if FItems.Count <= I then
      Bt := TKOLToolbarButton.Create( Self )
    else
      Bt := FItems[ I ];
    Bt.DefProps( 'Btn' + IntToStr( I + 1 ), Filer );
  end;
  Filer.DefineProperty( 'NewVersion', ReadNewVersion, WriteNewVersion, fNewVersion );
end;

destructor TKOLToolbar.Destroy;
var I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Destroy', 0
  @@e_signature:
  end;
  for I := FItems.Count-1 downto 0 do
    TObject( FItems[ I ] ).Free;
  FItems.Free;
  FTimer.Free;
  ActiveDesign.Free;
  FBitmap.Free;
  FBitmap := nil;
  Ftooltips.Free;
  if FBmpDesign <> 0 then
    DeleteObject( FBmpDesign );
  inherited;
end;

function IsNumber( const S: String ): Boolean;
var I: Integer;
begin
  Result := FALSE;
  if S = '' then Exit;
  for I := 1 to Length( S ) do
      if  (S[ I ] < '0') or (S[ I ] > '9') then
          Exit;
  Result := TRUE;
end;

procedure TKOLToolbar.DoGenerateConstants(SL: TStringList);
var I, N, K: Integer;
    Bt: TKOLToolbarButton;
    W, H: Integer;
begin
  FResBmpID := -1;
  H := MaxBtnImgHeight;
  W := MaxBtnImgWidth;
  if W * H > 0 then
    FResBmpID := ParentKOLForm.NextUniqueID;
  if not (generateConstants or generateVariables) then Exit;
  N := 0;
  K := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.separator and (Copy( Bt.Name, 1, 2 ) = 'TB') and
       IsNumber( Copy( Bt.Name, 3, MaxInt ) ) then
    begin
      Inc( N );
      continue;
    end;
    if Bt.Name <> '' then
    begin
      if generateConstants then
        SL.Add( 'const ' + Bt.Name + ' = ' + IntToStr( N ) + ';' )
      else
        SL.Add( 'var ' + Bt.Name + ': Integer = ' + IntToStr( N ) + ';' );
      Inc( K );
    end;
    Inc( N );
  end;
  if ( K > 0 ) then
    SL.Add( '' );
end;

function TKOLToolbar.GetButtons: String;
begin
  Result := Fbuttons;
  if Items.Count = 0 then Exit;
  Items2buttons;
  Result := FButtons;
end;

procedure TKOLToolbar.Items2buttons;
var I: Integer;
    S: String;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Items2buttons', 0
  @@e_signature:
  end;
  S := '';
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if S <> '' then
      S := S + #1;
    if Bt.dropdown then
      S := S + '^';
    S := S + Bt.caption;
  end;
  buttons := S;
end;

procedure TKOLToolbar.LoadButtonCount(R: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.LoadButtonCount', 0
  @@e_signature:
  end;
  FButtonCount := R.ReadInteger;
end;

procedure TKOLToolbar.Loaded;
var I, J: Integer;
    Bt: TKOLToolbarButton;
    S: String;
    AnyEnabled: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Loaded', 0
  @@e_signature:
  end;
  inherited;
  buttons2Items;
  AnyEnabled := FALSE;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.Name = '' then
    begin
      for J := 1 to MaxInt do
      begin
        S := 'TB' + IntToStr( J );
        if (FindComponent( S ) = nil) and ((Owner as TForm).FindComponent( S ) = nil) then
        begin
          Bt.Name := S;
          break;
        end;
      end;
    end;
    if Bt.enabled then
      AnyEnabled := TRUE;
  end;
  if not AnyEnabled then
  begin
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      Bt.enabled := TRUE;
    end;
  end;
  fNewVersion := TRUE;
  if Assigned(FKOLCtrl) then
    if StandardImagesUsed > 0 then
      RecreateWnd
    else
      UpdateButtons;
end;

function TKOLToolbar.MaxBtnImgHeight: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.MaxBtnImgHeight', 0
  @@e_signature:
  end;
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture and (Bt.picture.Height > Result) then
      Result := Bt.picture.Height;
  end;
end;

function TKOLToolbar.MaxBtnImgWidth: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.MaxBtnImgWidth', 0
  @@e_signature:
  end;
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture and (Bt.picture.Width > Result) then
      Result := Bt.picture.Width;
  end;
end;

function TKOLToolbar.NoMorePicturedButtonsFrom(Idx: Integer): Boolean;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := TRUE;
  for I := Idx to Items.Count - 1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture or (Bt.sysimg <> stiCustom) then
    begin
      Result := FALSE;
      break;
    end;
  end;
end;

function TKOLToolbar.PicturedButtonsCount: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture then
      Inc( Result );
  end;
end;

procedure TKOLToolbar.SaveButtonCount(W: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SaveButtonCount', 0
  @@e_signature:
  end;
  FButtonCount := FItems.Count;
  W.WriteInteger( FButtonCount );
end;

procedure TKOLToolbar.Setbitmap(const Value: TBitmap);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Setbitmap', 0
  @@e_signature:
  end;
  if Value <> nil then
    Fbitmap.Assign( Value )
  else
  begin
    Fbitmap.Width := 0;
    Fbitmap.Height := 0;
  end;
  if not (csLoading in ComponentState) then
    bitmap2ItemPictures( TRUE );
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.SetBtnCount_Dummy(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetBtnCount_Dummy', 0
  @@e_signature:
  end;
  //FButtonCount := Value;
end;

procedure TKOLToolbar.SetbuttonMaxWidth(const Value: Integer);
begin
  FbuttonMaxWidth := Value;
  Change;
end;

procedure TKOLToolbar.SetbuttonMinWidth(const Value: Integer);
begin
  FbuttonMinWidth := Value;
  Change;
end;

procedure TKOLToolbar.SetgenerateConstants(const Value: Boolean);
begin
  FgenerateConstants := Value;
  if Value then
    FgenerateVariables := FALSE;
  Change;
end;

procedure TKOLToolbar.SetmapBitmapColors(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetmapBitmapColors', 0
  @@e_signature:
  end;
  if Value = FmapBitmapColors then Exit;
  FmapBitmapColors := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.SetnoTextLabels(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetnoTextLabels', 0
  @@e_signature:
  end;
  FnoTextLabels := Value;
  UpdateButtons;
  Change;
end;

procedure TKOLToolbar.SetOptions(const Value: TToolbarOptions);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetOptions', 0
  @@e_signature:
  end;
  FOptions := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.SetshowTooltips(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetshowTooltips', 0
  @@e_signature:
  end;
  FshowTooltips := Value;
  Change;
end;

procedure TKOLToolbar.SetStandardImagesLarge(const Value: Boolean);
begin
  FStandardImagesLarge := Value;
  if Assigned(FKOLCtrl) then
    RecreateWnd;
  Change;
end;

procedure TKOLToolbar.Settooltips(const Value: TStrings);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Settooltips', 0
  @@e_signature:
  end;
  Ftooltips.Text := Value.Text;
  DesembleTooltips;
  Change;
end;

procedure TKOLToolbar.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var RsrcFile, RsrcName: String;
    {$IFDEF _D2009orHigher}
     C, C2: WideString;
     S, B: WideString;
     Z : integer;
    {$ELSE}
     S, B: String;
    {$ENDIF}
    I, J, K, W, H, N, I0: Integer;
    Bmp: TBitmap;
    Bt, Bt1: TKOLToolbarButton;
    Btn1st: Integer;
    KF: TKOLForm;
    {$IFDEF not_economy_code_size}
    TipsList: TStringList;
    {$ENDIF}
    Buttons_Count: Integer;
    Images_Count: Integer;
    Buttons_List: String;
    ImageIndexes_List: String;
    ///////////////////////////////////
    function IndexOfBeginLine: Integer;
    var i: Integer;
    begin
        for i := 0 to SL.Count-1 do
        begin
            if  SL[i] = 'begin' then
            begin
                Result := i;
                Exit;
            end;
        end;
        Result := 1;
    end; //////////////////////////////
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetupFirst', 0
  @@e_signature:
  end;
  KF := ParentKOLForm;

  RsrcName := '';
  H := MaxBtnImgHeight;
  W := MaxBtnImgWidth;
  if W * H > 0 then
  begin
      RsrcName := UpperCase( ParentKOLForm.FormName ) + '_TBBMP' +  IntToStr( FResBmpID );
      RsrcFile := ParentKOLForm.FormName + '_' + Name;
      (SL as TFormStringList).OnAdd := nil;
      SL.Add( Prefix + '  {$R ' + RsrcFile + '.res}' );
      if  KF <> nil then
          (SL as TFormStringList).OnAdd := KF.DoFlushFormCompact;
      Bmp := TBitmap.Create;
      TRY
        N := 0;
        FBmpTranColor := clNone;
        for I := 0 to Items.Count-1 do
        begin
          Bt := Items[ I ];
          if Bt.HasPicture then
          begin
            if FBmpTranColor = clNone then
            begin
              Bmp.Assign( Bt.picture );
              FBmpTranColor := Bmp.Canvas.Pixels[ 0, Bmp.Height - 1 ];
            end;
            Inc( N );
          end;
        end;
        Bmp.Width := N * W;
        Bmp.Height := H;
        {$IFNDEF _D2}
        Bmp.PixelFormat := pf24bit;
        {$ENDIF}
        if FBmpTranColor <> clNone then
        begin
          Bmp.Canvas.Brush.Color := FBmpTranColor;
          Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
        end;
        N := 0;
        for I := 0 to Items.Count-1 do
        begin
          Bt := Items[ I ];
          if Bt.HasPicture then
          begin
            Bmp.Canvas.Draw( N * W, 0, Bt.picture.Graphic );
            Inc( N );
          end;
        end;
        GenerateBitmapResource( Bmp, RsrcName, RsrcFile, fUpdated,
                                AllowBitmapCompression );
      FINALLY
        Bmp.Free;
      END;
  end;
  if  HeightAuto then
  begin
      DefaultHeight := Height;
      DefaultWidth := Width;
  end
    else
  begin
      if  Align in [ caTop, caBottom, caNone ] then
      begin
          DefaultHeight := 22;
          DefaultWidth := Width;
      end else
      if  Align in [ caLeft, caRight ] then
      begin
          DefaultHeight := Height;
          DefaultWidth := 44;
      end else
      begin
          DefaultHeight := Height;
          DefaultWidth := Width;
      end;
  end;

  inherited;  //////////////////////////////////////////////////////////////////

  if  AutosizeButtons then
      SL.Add( '  ' + Prefix + AName + '.TBAutoSizeButtons := TRUE;' );

  if  Assigned( bitmap ) and (bitmap.Width * bitmap.Height > 0) then
  begin
      W := MaxBtnImgWidth;
      H := MaxBtnImgHeight;
      if  (W <> H) or (StandardImagesUsed > 0) then
      begin
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormSetTBBtnImgWidth', '' );
              KF.FormAddNumParameter( W );
          end else
          SL.Add( '  ' + Prefix + AName + '.TBBtnImgWidth := ' + IntToStr( W ) + ';' );

          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormTBAddBitmap', '' );
              KF.FormAddNumParameter( Integer(mapBitmapColors) );
              KF.FormAddStrParameter( RsrcName );
              if  mapBitmapColors then
                  KF.FormAddNumParameter( (FBmpTranColor shl 1) or (FBmpTranColor shr 31)  );
          end
            else
          begin
              S := '  ' + Prefix + AName + '.TBAddBitmap( ';
              if  mapBitmapColors then
                  S := S + 'LoadMappedBitmapEx( ' + AName + ', hInstance, ''' + RsrcName + ''', [ ' +
                            Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ) );'
              else
                  S := S + 'LoadBmp( hInstance, ''' + RsrcName + ''', ' +
                           AName + ' ) );';
              SL.Add( S );
          end;
      end;
  end
  else if  NoSpaceForImages then
  begin
      SL.Add( '  ' + Prefix + AName + '.Perform( TB_SETBITMAPSIZE, 0, 16 shl 16 );' );
  end;

  if  ((StandardImagesUsed > 0) and (PicturedButtonsCount > 0)) or
      not IntIn(StandardImagesUsed, [ 1, 2, 4 ]) then
  begin
      if  LongBool( StandardImagesUsed and 1 ) then
      begin
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormTBAddBitmap', '' );
              if  StandardImagesLarge then
                  KF.FormAddNumParameter( -2 )
              else
                  KF.FormAddNumParameter( -1 );
          end else
          begin
              if  StandardImagesLarge then
                  S := '-2'
              else
                  S := '-1';
              SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
          end;
      end;

      if  LongBool( StandardImagesUsed and 2 ) then
      begin
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormTBAddBitmap', '' );
              if  StandardImagesLarge then
                  KF.FormAddNumParameter( -6 )
              else
                  KF.FormAddNumParameter( -5 );
          end else
          begin
              if  StandardImagesLarge then
                  S := '-6'
              else
                  S := '-5';
              SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
          end;
      end;

      if  LongBool( StandardImagesUsed and 4 ) then
      begin
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormTBAddBitmap', '' );
              if  StandardImagesLarge then
                  KF.FormAddNumParameter( -10 )
              else
                  KF.FormAddNumParameter( -9 );
          end else
          begin
              if  StandardImagesLarge then
                  S := '-10'
              else
                  S := '-9';
              SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
          end;
      end;
  end;

  if  (TBButtonsWidth > 0) or AutoSizeButtons then
  begin
      S := '0';
      if  StandardImagesUsed > 0 then
      else
      if (Bitmap.Width > 0) and (Bitmap.Height > 0) and
         (FResBmpID >= 0) and (MaxBtnImgWidth = MaxBtnImgHeight) and
         (StandardImagesUsed=0) then
      begin
        if mapBitmapColors then
          S := 'LoadMappedBitmapEx( Result, hInstance, ''' +
                    UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) + ''', [ ' +
                    Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ) '
        else
          S := 'LoadBmp( hInstance, PChar( ''' +
                    UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) +
                    ''' ), Result ) ';
      end;


      Buttons_List := ButtonCaptionsList( Buttons_Count );
      ImageIndexes_List := ButtonImgIndexesList( Images_Count );
      SL.Insert( IndexOfBeginLine, 'const ToolbarButtonsArray_' + Name + ': array[' +
           '0..' + IntToStr(Buttons_Count-1) + '] of PKOLChar = (' +
           Buttons_List + ');');
      SL.Insert( IndexOfBeginLine, 'const ToolbarImgIndexesArray_' + Name + ': array[' +
           '0..' + IntToStr(Images_Count-1) + '] of Integer = (' +
           ImageIndexes_List + ');' );
      SL.Add( '  ' + Prefix + 'ToolbarAddButtons( ' + AName + ', ' +
              //'['#13#10 +
              //'    ' + ButtonCaptionsList + ' ],'#13#10 +
              '    ToolbarButtonsArray_' + Name + ',' +
              //'    ' + ButtonImgIndexesList + ','#13#10 +
              '    ToolbarImgIndexesArray_' + Name + ',' +
              '    ' + S + ' );' );
      if  AutosizeButtons then
      begin
          SL.Add( '  ' + Prefix + AName + '.Perform( TB_SETBUTTONSIZE, 0, ' +
                  IntToStr( TBButtonsWidth ) + ' or $10000' +
                  //' or $FFFF0000 and (' + AName + '.Perform( TB_GETBUTTONSIZE, 0, 0 ) )' +
                  ' );' );
      end;
  end;

  if  showTooltips or (tooltips.Count > 0) then
  begin
      //{$IFDEF _D4orHigher}
      {$IFDEF not_economy_code_size}
      if  (KF <> nil) and KF.FormCompact then
      begin
          TipsList := TStringList.Create;
          TRY
              J := 0;
              for I := 0 to Items.Count-1 do
              begin
                  Bt := Items[ I ];
                  if (tooltips.Count > 0) and (J >= tooltips.Count) then break;

                  if  Bt.Tooltip <> '' then
                      B := Bt.Tooltip
                  else
                  if  (tooltips.Count > 0) and (tooltips[ J ] <> '') and not Bt.separator then
                      B := tooltips[ J ]
                  else
                  if  showTooltips then
                      B := Bt.Caption
                  else
                      B := '';
                  if  Bt.Faction = nil then                     // {YS} äîáàâèòü
                  begin                                        // {YS} äîáàâèòü
                      if  not Bt.separator then                   // {YS} äîáàâèòü
                          TipsList.Add( B )
                      else
                          TipsList.Add( '' );
                      //------
                  end else                                         // {YS} äîáàâèòü
                      Inc( J );
              end;
              if  TipsList.Count > 0 then
              begin
                  KF.FormAddCtlCommand( Name, 'FormTBSetTooltips' );
                  KF.FormAddNumParameter( TipsList.Count );
                  for I := 0 to TipsList.Count-1 do
                      KF.FormAddStrParameter( TipsList[I] );
              end;
          FINALLY
              TipsList.Free;
          END;
      end
        else
      {$ENDIF}
      begin
          S := '';
          J := 0;
          for I := 0 to Items.Count-1 do
          begin
              Bt := Items[ I ];
              //if Bt.Faction <> nil then continue; // remove by YS 7-Aug-2004
              //if Bt.separator then continue;

              //---------{ Maxim Pushkar }----------------------------------------------
              //if (tooltips.Count > 0) and (J > tooltips.Count) then break;
              //----------------------------------------------------------------------//
              if (tooltips.Count > 0) and (J >= tooltips.Count) then break;          //
              //--------------------------------------------------------------------//

              if  Bt.Tooltip <> '' then
                  B := Bt.Tooltip
              else
              if  (tooltips.Count > 0) and (tooltips[ J ] <> '') and not Bt.separator then
                  B := tooltips[ J ]
              else
              if  showTooltips then
                  B := Bt.Caption
              else
                  B := '';
              if  Bt.Faction = nil then                     // {YS} äîáàâèòü
              begin                                        // {YS} äîáàâèòü
                  if  not Bt.separator then                   // {YS} äîáàâèòü
                  begin
                      if  S <> '' then
                          S := S + ', ';
                      {$IFDEF _D2009orHigher}
                      C2 := '';
                      C := StringConstant( Bt.Name + '_tip', B );
                      for Z := 2 to Length(C) - 1 do
                          C2 := C2 + '#'+int2str(ord(C[Z]));
                      S := S + C2;
                      {$ELSE}
                      S := S + PCharStringConstant( Self, Bt.Name + '_tip', B );
                      {$ENDIF}
                  end else
                  //+++++++ v1.94
                  begin
                      if  S <> '' then
                          S := S + ', '''''
                      else
                          S := S + '''''';
                  end;
                  //------
              end else                                         // {YS} äîáàâèòü
                  Inc( J );
          end;
          // change by Alexander Pravdin (to fix tooltips for case of first separator):
          //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
          Btn1st := 0;
          {for i := 0 to ButtonCount - 1 do
            if not TKOLToolbarButton( FItems.Items[i] ).Fseparator then begin
              Btn1st := i;
              Break;
            end;}
          if  S <> '' then
          begin
              SL.Add( Prefix + '  {$IFDEF USE_GRUSH}' );
              SL.Add( Prefix + '  ToolbarSetTooltips( ' + AName + ', ' +
                 AName + '.TBIndex2Item( ' + IntToStr( Btn1st ) + ' ), [ ' + S + ' ] );'  );
              SL.Add( Prefix + '  {$ELSE}' );
              SL.Add( Prefix + '  ' + AName + '.TBSetTooltips( ' + AName +
                 '.TBIndex2Item( ' + IntToStr( Btn1st ) + ' ), [ ' + S + ' ] );' );
              SL.Add( Prefix + '  {$ENDIF}' );
          end;
          //--------------------------------------------------------------------------
      end;
  end;

  // assign image list if used:
  if  ImageListNormal <> nil then
  begin
      SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETIMAGELIST, 0, Result.' +
              ImageListNormal.Name + '.Handle );' );
  end;
  if  ImageListDisabled <> nil then
  begin
      SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETDISABLEDIMAGELIST, 0, Result.' +
              ImageListDisabled.Name + '.Handle );' );
  end;
  if  ImageListHot <> nil then
  begin
      SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETHOTIMAGELIST, 0, Result.' +
              ImageListHot.Name + '.Handle );' );
  end;

  I0 := -1;
  for I := 0 to Items.Count-1 do
  begin
      Bt := Items[ I ];
      Inc( I0 );
      //if Bt.separator then Continue;
      if  Bt.fOnClickMethodName <> '' then
      begin
          S := '';
          for J := I to Items.Count - 1 do
          begin
              Bt := Items[ J ];
              //if Bt.separator then Continue;
              if  Bt.separator or (Bt.fOnClickMethodName = '') then
              begin
                  N := 0;
                  for K := J to Items.Count-1 do
                  begin
                      Bt1 := Items[ K ];
                      if  Bt1.separator then Continue;
                      if  Bt1.fOnClickMethodName <> '' then
                      begin
                          Inc( N );
                          break;
                      end;
                  end;
                  if N = 0 then break;
              end;
              if  S <> '' then S := S + ', ';
              if  Bt.fOnClickMethodName <> '' then
                  S := S + 'Result.' + Bt.fOnClickMethodName
              else
                  S := S + 'nil';
          end;
          SL.Add( '  ' + Prefix + AName + '.TBAssignEvents( ' + IntToStr( I0 ) +
                  ', [ ' + S + ' ] );' );
          break;
      end;
  end;
  if  TBButtonsMinWidth > 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTBButtonsMinWidth', '' );
          KF.FormAddNumParameter( TBButtonsMinWidth );
      end else
      SL.Add( Prefix + AName + '.TBButtonsMinWidth := ' + IntToStr( TBButtonsMinWidth ) + ';' );

  if  TBButtonsMaxWidth > 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTBButtonsMaxWidth', '' );
          KF.FormAddNumParameter( TBButtonsMaxWidth );
      end else
      SL.Add( Prefix + AName + '.TBButtonsMaxWidth := ' + IntToStr( TBButtonsMaxWidth ) + ';' );

  for I := Items.Count-1 downto 0 do
  begin
      Bt := Items[ I ];
      if  not Bt.visible and (Bt.Faction = nil) then
      begin
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormHideToolbarButton', '' );
              KF.FormAddNumParameter( I );
          end
            else
          begin
              SL.Add( Prefix + '{$IFDEF USE_GRUSH}' );
              SL.Add( Prefix + 'ShowHideToolbarButton( ' + AName + ', ' + IntToStr( I ) + ', FALSE );' );
              SL.Add( Prefix + '{$ELSE}' );
              SL.Add( Prefix + AName + '.TBButtonVisible[ ' + IntToStr( I ) + ' ] := FALSE;' );
              SL.Add( Prefix + '{$ENDIF}' );
          end;
      end;

      if  not Bt.enabled and (Bt.Faction = nil) then
      begin
          if  (KF <> nil) and KF.FormCompact then
          begin
              KF.FormAddCtlCommand( Name, 'FormDisableToolbarButton', '' );
              KF.FormAddNumParameter( I );
          end
            else
          begin
              SL.Add( Prefix + '{$IFDEF USE_GRUSH}' );
              SL.Add( Prefix + 'EnableToolbarButton( ' + AName + ', ' + IntToStr( I ) + ', FALSE );' );
              SL.Add( Prefix + '{$ELSE}' );
              SL.Add( Prefix + AName + '.TBButtonEnabled[ ' + IntToStr( I ) + ' ] := FALSE;' );
              SL.Add( Prefix + '{$ENDIF}' );
          end;
      end;
  end;

  if  not Assigned( OnTBCustomDraw ) and
      (tboCustomErase in Options) OR
      FixFlatXP and (tboFlat in Options) then
      if  (KF <> nil) and KF.FormCompact then
          KF.FormAddCtlCommand( Name, 'FormFixFlatXPToolbar', '' )
      else
          SL.Add( Prefix + AName + '.OnTBCustomDraw := nil;' );
end;

function TKOLToolbar.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
   {$IFDEF _D2009orHigher}
    //C: WideString;
    S, A: WideString;
    //B: WideString;
   {$ELSE}
    S, A: String;
   {$ENDIF}
   Buttons_Count: Integer;
   Images_Count: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.SetupParams', 0
  @@e_signature:
  end;
  // 1. Options parameter
  S := '';
  if (tboTextRight in Options) or
      FixFlatXP and {(Align in [caLeft, caRight]) and} (tboFlat in Options) then
    S := 'tboTextRight';
  if (tboTextBottom in Options) and (S = '') then
    S := S + ', tboTextBottom';
  if tboFlat in Options then
    S := S + ', tboFlat';
  if tboTransparent in Options then
    S := S + ', tboTransparent';
  if (tboWrapable in Options) and not( FixFlatXP and (Align in [caLeft, caRight]) and
     (tboFlat in Options) )
     {or
     ( (tboFlat in Options) and not (Align in [caLeft, caRight] ) and FixFlatXP )} then
    S := S + ', tboWrapable';
  if tboNoDivider in Options then
    S := S + ', tboNoDivider';
  if tbo3DBorder in Options then
    S := S + ', tbo3DBorder';
  if tboCustomErase in Options then
    S := S + ', tboCustomErase';
  if S <> '' then
  if S[ 1 ] = ',' then
    S := Trim( Copy( S, 2, MaxInt ) );

  // 2. Align parameter
  case Align of
    caLeft: A := 'caLeft';
    caRight:A := 'caRight';
    caClient: A := 'caClient';
    caTop: A := 'caTop';
    caBottom: A := 'caBottom';
    else A := 'caNone';
  end;
  Result := AParent + ', ' + A + ', [' + S + '], ';

  // 3. Bitmap from a resource
  if (Bitmap.Width > 0) and (Bitmap.Height > 0) and
     (FResBmpID >= 0) and (MaxBtnImgWidth = MaxBtnImgHeight) and
     (StandardImagesUsed=0) then
  begin
    if mapBitmapColors then
      Result := Result + 'LoadMappedBitmapEx( Result, hInstance, ''' +
                UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) + ''', [ ' +
                Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ), '
    else
      Result := Result + 'LoadBmp( hInstance, PChar( ''' +
                UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) +
                ''' ), Result ), ';
  end
    else // or if standard images are used, type of images here
  if (PicturedButtonsCount = 0) and (IntIn( StandardImagesUsed, [ 1, 2, 4 ] )) then
  begin
    if StandardImagesUsed = 1 then
      if StandardImagesLarge then
        Result := Result + 'THandle( -2 ), '
      else
        Result := Result + 'THandle( -1 ), '
    else
    if StandardImagesUsed = 2 then
      if StandardImagesLarge then
        Result := Result + 'THandle( -6 ), '
      else
        Result := Result + 'THandle( -5 ), '
    else
      if StandardImagesLarge then
        Result := Result + 'THandle( -10 ), '
      else
        Result := Result + 'THandle( -9 ), ';
  end
    else
  begin // or if Bitmap is empty, value 0
    if not ((Bitmap.Width > 0) and (Bitmap.Height > 0) and
     (FResBmpID >= 0)) then
      FResBmpID := 0;
    Result := Result + '0, ';
  end;

  // 4. Button captions
  Result := Result + '[ ';
  if  (TBButtonsWidth = 0) and not AutoSizeButtons then
      Result := Result + ButtonCaptionsList( Buttons_Count );
  Result := Result + ' ], ';

  // 5. Button image indexes used
  if  (TBButtonsWidth = 0) and not AutosizeButtons then
      Result := Result + '[ ' + ButtonImgIndexesList( Images_Count ) + ' ] '
  else
      Result := Result + '[]';
  //Rpt( '$$$$$$$$$$$$$$$ PicturedButtonsCount := ' + IntToStr( PicturedButtonsCount ) );
end;

var LastToolbarWarningtime: Integer;
procedure ToolbarBetterToPlaceOverPanelWarning;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'ToolbarBetterToPlaceOverPanelWarning', 0
  @@e_signature:
  end;
  if Abs( Integer( GetTickCount ) - LastToolbarWarningtime ) > 60000 then
  begin
    LastToolbarWarningtime := GetTickCount;
    {ShowMessage( 'It is better to place toolbar on a panel aligning it caClient.'#13 +
                 'This can improve performance of the application, especially in ' +
                 'Windows 9x/Me.' );}
  end;
end;

function TKOLToolbar.StandardImagesUsed: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.sysimg <> stiCustom then
    begin
      if Bt.sysimg in [ stdCUT..stdPRINT ] then
        Result := Result or 1
      else
      if Bt.sysimg in [ viewLARGEICONS..viewVIEWMENU ] then
        Result := Result or 2
      else
        Result := Result or 4;
      if Result = 7 then break;
    end;
  end;
end;

procedure TKOLToolbar.Tick(Sender: TObject);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.Tick', 0
  @@e_signature:
  end;
  if Parent <> nil then
  begin
    FTimer.Enabled := FALSE;
    if Parent = Owner then
      ToolbarBetterToPlaceOverPanelWarning;
    if Parent is TKOLCustomControl then
      (Parent as TKOLCustomControl).ReAlign( FALSE )
    else
    begin
      KF := ParentKOLForm;
      if KF <> nil then
        KF.AlignChildren( nil, FALSE );
    end;
    FTimer.Free;
    FTimer := nil;
  end;
end;

procedure TKOLToolbar.ReadNewVersion(Reader: TReader);
begin
  fNewVersion := Reader.ReadBoolean;
end;

procedure TKOLToolbar.WriteNewVersion(Writer: TWriter);
begin
  Writer.WriteBoolean( fNewVersion );
end;

function TKOLToolbar.Generate_SetSize: String;
begin
  Result := inherited Generate_SetSize;
end;

procedure TKOLToolbar.SetAutoHeight(const Value: Boolean);
begin
  FHeightAuto := Value;
  Change;
end;

procedure TKOLToolbar.CreateKOLControl(Recreating: boolean);
var
  al: kol.TControlAlign;
  bmp: HBITMAP;
begin
  Log( '->TKOLToolbar.CreateKOLControl' );
  Log( 'recreating: ' + IntToStr( Integer( Recreating ) ) );
  TRY
    inherited;
    if Recreating then begin
      al:=kol.TControlAlign(Align);
      bmp := 0;
    end
    else begin
      al:=kol.caTop;
      bmp:=0;
    end;
    TRY
      FKOLCtrl:=NewToolbar(KOLParentCtrl, al, kol.TToolbarOptions(FOptions), bmp, [nil], [-2]);
      FKOLCtrl.Visible:=False;
    EXCEPT
      on E: Exception do
      begin
        ShowMessage( 'Error: ' + E.Message );
      end;
    END;
    LogOK;
  FINALLY
    Log( '->TKOLToolbar.CreateKOLControl' );
  END;
end;

procedure TKOLToolbar.KOLControlRecreated;
var
  N: integer;
  TmpBmp, TmpBmp2: TBitmap;
begin
  inherited;
  if ImageListsUsed then
  begin
    if ImageListNormal <> nil then
      FKOLCtrl.Perform( TB_SETIMAGELIST, 0, ImageListNormal.Handle );
    if ImageListDisabled <> nil then
      FKOLCtrl.Perform( TB_SETDISABLEDIMAGELIST, 0, ImageListDisabled.Handle );
    if ImageListHot <> nil then
      FKOLCtrl.Perform( TB_SETHOTIMAGELIST, 0, ImageListHot.Handle );
  end
    else
  begin
    if StandardImagesUsed > 0 then begin
      if StandardImagesLarge then
        N:=1
      else
        N:=0;
      FKOLCtrl.TBAddBitmap(HBITMAP(-1-N));
      FKOLCtrl.TBAddBitmap(HBITMAP(-5-N));
      FKOLCtrl.TBAddBitmap(HBITMAP(-9-N));
    end;
    if (Bitmap <> nil) and not Bitmap.Empty then
    begin
      if mapBitmapColors then
      begin
        TmpBmp := TBitmap.Create;
        TRY
          TmpBmp.Canvas.Brush.Color := clBtnFace;
          TmpBmp.Width := Bitmap.Width;
          TmpBmp.Height := Bitmap.Height;
          {$IFDEF _D3orHigher}
          Bitmap.Transparent := TRUE;
          {$ENDIF}
          //Bitmap.TransparentColor := Bitmap.Canvas.Pixels[ 0, Bitmap.Height-1 ];
          TmpBmp.Canvas.Draw( 0, 0, Bitmap );
          {$IFDEF _D3orHigher}
          Bitmap.Transparent := FALSE;
          {$ENDIF}
          FBmpDesign := //CopyImage( TmpBmp.Handle, IMAGE_BITMAP, 0, 0, 0 {LR_CREATEDIBSECTION} );
                     TmpBmp.ReleaseHandle;
        FINALLY
          TmpBmp.Free;
        END;
      end
        else
      begin
        FBmpDesign := CopyImage( Bitmap.Handle, IMAGE_BITMAP, 0, 0, LR_CREATEDIBSECTION );
      end;

      if mapBitmapColors then
      begin
        TmpBmp := TBitmap.Create;
        TmpBmp2 := TBitmap.Create;
        TRY
          TmpBmp.Handle := FBmpDesign;
          TmpBmp2.Canvas.Brush.Color := clBtnFace;
          TmpBmp2.Width := TmpBmp.Width;
          TmpBmp2.Height := TmpBmp.Height;
          {$IFDEF _D3orHigher}
          TmpBmp.Transparent := TRUE;
          {$ENDIF}
          TmpBmp2.Canvas.Draw( 0, 0, TmpBmp );
          FBmpDesign := TmpBmp2.ReleaseHandle;
        FINALLY
          TmpBmp.Free;
          TmpBmp2.Free;
        END;
      end;
      FKOLCtrl.TBAddBitmap( FBmpDesign );
    end;
  end;
  UpdateButtons;
  ReAlign(True);
end;

function TKOLToolbar.NoDrawFrame: Boolean;
begin
  Result:=HasBorder;
end;

procedure TKOLToolbar.UpdateButtons;

  procedure GenerateButtons{(var Captions: array of string; var PCaptions: array of PChar; var ImgIndices: array of integer)};
  var
    i, N, StdImagesStart, ViewImagesStart, HistImagesStart: integer;
    s: string;
    ii: Integer;
    Bt: TKOLToolbarButton;
  begin
    if FItems.Count = 0 then exit;
    {if PicturedButtonsCount > 0 then
      N := FItems.Count
    else
      N:=0;}
    StdImagesStart := 0;
    ViewImagesStart := 15;
    HistImagesStart := 15 + 12;
    N := 0;
    if StandardImagesUsed > 0 then
    N := 15 + 12 + 5;
    for i:=0 to FItems.Count - 1 do
      with TKOLToolbarButton(FItems[i]) do begin
        if noTextLabels then
          s:=' '
        else
          s:=caption;
        if checked then
          S := '+' + S
        else
        if radioGroup <> 0 then
          S := '-' + S;
        if dropdown then
          S := '^' + S;
        {Captions[i]:=s;
        PCaptions[i]:=PChar(Captions[i]);}
        Bt := Items[ i ];
        if ImageListsUsed then
        begin
          ii := Bt.imgIndex;
          if ii < 0 then ii := -2;
        end
        else
        if HasPicture then begin
          ii {ImgIndices[i]} := N + i;
        end
        else
          case sysimg of
            stiCustom:
              ii {ImgIndices[i]} := -2; // I_IMAGENONE
            stdCUT..stdPRINT:
              ii {ImgIndices[i]} := StdImagesStart + Ord( sysimg ) - Ord( stdCUT );
            viewLARGEICONS..viewVIEWMENU:
              ii {ImgIndices[i]} := ViewImagesStart + Ord( sysimg ) - Ord( viewLARGEICONS );
            else
              ii {ImgIndices[i]} := HistImagesStart + Ord( sysimg ) - Ord( histBACK );
          end;
        FKOLCtrl.TBAddButtons( [ PKOLChar( S ) ], [ ii ] );
      end;
  end;

var
  {capts: array of string;
  pcapts: array of PChar;
  imgs: array of integer;}
  i: integer;

begin
  if not Assigned(FKOLCtrl) then exit;
  while FKOLCtrl.TBButtonCount > 0 do
    FKOLCtrl.TBDeleteButton(0);

  if FItems.Count > 0 then begin
    {SetLength(capts, FItems.Count);
    SetLength(pcapts, FItems.Count);
    SetLength(imgs, FItems.Count);}
    GenerateButtons{(capts, pcapts, imgs)};
    //FKOLCtrl.TBAddButtons(pcapts, imgs);
    for i:=0 to FItems.Count - 1 do
      with TKOLToolbarButton(FItems[i]) do begin
        if not enabled then
          FKOLCtrl.TBButtonEnabled[i]:=False;
      end;
  end;
end;

procedure TKOLToolbar.SetMargin(const Value: Integer);
begin
  inherited;
  if Assigned(FKOLCtrl) then
    FKOLCtrl.Perform( TB_SETINDENT, Border, 0 );
end;

procedure TKOLToolbar.CMDesignHitTest(var Message: TCMDesignHitTest);
var
  pt: TPoint;
  res: integer;
begin
  if Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames]) then begin
    Message.Result:=0;
    pt:=SmallPointToPoint(Message.Pos);
    res:=FKOLCtrl.Perform(WM_USER + 69 {TB_HITTEST}, 0, integer(@pt));
    if Abs(res) <= FKOLCtrl.TBButtonCount then
      Message.Result:=1;
  end
  else
    inherited;
end;

procedure TKOLToolbar.WMLButtonDown(var Message: TWMLButtonDown);
var
  pt: TPoint;
  res: integer;
  F: TForm;
  D: IDesigner;
  FD: IFormDesigner;
begin
  if Assigned(FKOLCtrl) then begin
    pt:=SmallPointToPoint(Message.Pos);
    res:=FKOLCtrl.Perform(WM_USER + 69 {TB_HITTEST}, 0, integer(@pt));
    if res < 0 then
      res:=-res - 1;
    if res < FItems.Count then begin
      F := Owner as TForm;
      if F <> nil then begin
  //*///////////////////////////////////////////////////////
    {$IFDEF _D6orHigher}                                  //
          F.Designer.QueryInterface(IFormDesigner,D);     //
    {$ELSE}                                               //
  //*///////////////////////////////////////////////////////
          D := F.Designer;
  //*///////////////////////////////////////////////////////
    {$ENDIF}                                              //
  //*///////////////////////////////////////////////////////
        if (D <> nil) and QueryFormDesigner( D, FD ) then begin
          FD.SelectComponent( {$IFDEF _D5orHigher} TPersistent {$ENDIF} ( FItems[res] ) );
        end;
      end;
    end;
  end
  else
    inherited;
end;

procedure TKOLToolbar.WMMouseMove(var Message: TWMMouseMove);
begin
end;

procedure TKOLToolbar.WMLButtonDblClk(var Message: TWMLButtonDblClk);
begin
end;

procedure TKOLToolbar.Paint;
var
  i: integer;
  R: TRect;
begin
  inherited;
  if Assigned(FKOLCtrl) and (PaintType in [ptWYSIWIG, ptWYSIWIGFrames]) then
    with Canvas do begin
      Brush.Style:=bsClear;
      Pen.Color:=clBtnShadow;
      Pen.Style:=psDot;
      for i:=0 to FItems.Count - 1 do
      with TKOLToolbarButton(FItems[i]) do begin
        if checked or (not separator and not (tboFlat in Options)) then continue;
        FKOLCtrl.Perform( TB_GETITEMRECT, i, Integer( @R ) );
        if separator then
          Windows.Rectangle( Handle, R.Left, R.Top, R.Right, R.Bottom )
        else
          DrawEdge(Handle, R, BDR_RAISEDINNER, BF_RECT);
      end;
      Pen.Style:=psSolid;
      Brush.Style:=bsSolid;
    end;
end;

function TKOLToolbar.GetDefaultControlFont: HFONT;
begin
  Result:=GetStockObject(DEFAULT_GUI_FONT);
end;

procedure TKOLToolbar.SetimageList(const Value: TKOLImageList);
  procedure RemoveOldImageList;
  begin
    if FImageListNormal <> nil then
      FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
    FImageListNormal := nil;
  end;

var I: Integer;
    Bt: TKOLToolbarButton;
begin
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    if ImagedButtonsCount > 0 then
    begin
      I := MessageBox( Application.Handle, 'Some buttons have pictures assigned.'#13#10 +
        'All pictures will be removed. Continue assigning image list to a toolbar?',
        PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
          Bt.picture := nil
        else
        if Bt.sysimg <> stiCustom then
          Bt.sysimg := stiCustom;
        if Bt.Fseparator then
          Bt.FimgIndex := -1;
      end;
    end;
    RemoveOldImageList;
    Value.AddToNotifyList( Self );
  end
    else
    RemoveOldImageList;
  FImageListNormal := Value;
  if Value <> nil then
  if FKOLCtrl <> nil then
  begin
    //ShowMessage( 'ImageListNormal.Handle=' + IntToStr( Value.Handle ) );
    FKOLCtrl.Perform( TB_SETIMAGELIST, 0, FImageListNormal.Handle );
    UpdateButtons;
  end;
  Change;
end;

procedure TKOLToolbar.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLBitBtn.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
  begin
    if Sender = ImageListNormal then
      ImageListNormal := nil
    else
    if Sender = ImageListDisabled then
      ImageListDisabled := nil
    else
    if Sender = ImageListHot then
      ImageListHot := nil
    else
      ShowMessage( 'Could not remove a reference to image list !' );
  end;
end;

function TKOLToolbar.ImagedButtonsCount: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.HasPicture or (Bt.sysimg <> stiCustom) then
      Inc( Result );
  end;
end;

function TKOLToolbar.MaxImgIndex: Integer;
var I: Integer;
    Bt: TKOLToolbarButton;
begin
  Result := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.FimgIndex >= Result then
      Result := Bt.FimgIndex + 1;
  end;
end;

procedure TKOLToolbar.SetDisabledimageList(const Value: TKOLImageList);
  procedure RemoveOldImageList;
  begin
    if FimageListDisabled <> nil then
      FimageListDisabled.NotifyLinkedComponent( Self, noRemoved );
    FimageListDisabled := nil;
  end;

var I: Integer;
    Bt: TKOLToolbarButton;
begin
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    if ImagedButtonsCount > 0 then
    begin
      I := MessageBox( Application.Handle, 'Some buttons have pictures assigned.'#13#10 +
        'All pictures will be removed. Continue assigning image list to a toolbar?',
        PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
          Bt.picture := nil
        else
        if Bt.sysimg <> stiCustom then
          Bt.sysimg := stiCustom;
        if Bt.Fseparator then
          Bt.FimgIndex := -1;
      end;
    end;
    RemoveOldImageList;
    Value.AddToNotifyList( Self );
  end
    else
    RemoveOldImageList;
  FimageListDisabled := Value;
  if Value <> nil then
  if FKOLCtrl <> nil then
  begin
    FKOLCtrl.Perform( TB_SETDISABLEDIMAGELIST, 0, FimageListDisabled.Handle );
    UpdateButtons;
  end;
  Change;
end;

procedure TKOLToolbar.SetHotimageList(const Value: TKOLImageList);
  procedure RemoveOldImageList;
  begin
    if FImageListHot <> nil then
      FImageListHot.NotifyLinkedComponent( Self, noRemoved );
    FImageListHot := nil;
  end;

var I: Integer;
    Bt: TKOLToolbarButton;
begin
  if (Value <> nil) and (Value is TKOLImageList) then
  begin
    if ImagedButtonsCount > 0 then
    begin
      I := MessageBox( Application.Handle, 'Some buttons have pictures assigned.'#13#10 +
        'All pictures will be removed. Continue assigning image list to a toolbar?',
        PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
          Bt.picture := nil
        else
        if Bt.sysimg <> stiCustom then
          Bt.sysimg := stiCustom;
        if Bt.Fseparator then
          Bt.FimgIndex := -1;
      end;
    end;
    RemoveOldImageList;
    Value.AddToNotifyList( Self );
  end
    else
    RemoveOldImageList;
  FImageListHot := Value;
  if Value <> nil then
  if FKOLCtrl <> nil then
  begin
    FKOLCtrl.Perform( TB_SETHOTIMAGELIST, 0, FimageListHot.Handle );
    UpdateButtons;
  end;
  Change;
end;

function TKOLToolbar.ImageListsUsed: Boolean;
begin
  Result := (ImageListNormal <> nil) or (ImageListDisabled <> nil) or
         (ImageListHot <> nil);
end;

procedure TKOLToolbar.SetFixFlatXP(const Value: Boolean);
begin
  FFixFlatXP := Value;
  Change;
end;

procedure TKOLToolbar.SetTBButtonsWidth(const Value: Integer);
begin
  FTBButtonsWidth := Value;
  Change;
end;

procedure TKOLToolbar.SetgenerateVariables(const Value: Boolean);
begin
  FgenerateVariables := Value;
  if Value then
    FgenerateConstants := FALSE;
  Change;
end;

procedure TKOLToolbar.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var I: Integer;
    Bt: TKOLToolbarButton;
    S: String;
begin
  inherited;
  if generateVariables then
  begin
      S := '';
      for I := 0 to Items.Count-1 do
      begin
          Bt := Items[ I ];
          if  Bt.separator and (Copy( Bt.Name, 1, 2 ) = 'TB') and
              IsNumber( Copy( Bt.Name, 3, MaxInt ) ) then
              continue;
          if  Bt.Name <> '' then
          begin
              S := S + ',' + Bt.Name;
          end;
      end;
      if ( S <> '' ) then
      begin
          Delete( S, 1, 1 );
          SL.Add( '  ' + Prefix + AName + '.TBConvertIdxArray2ID( [' + S + '] );' );
      end;
  end;

  if  AutoSize then
      SL.Add( '  ' + Prefix + AName + '.Perform( TB_AUTOSIZE, 0, 0 );' );

end;

procedure TKOLToolbar.P_SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var I, n: Integer;
    Bt: TKOLToolbarButton;
    S: String;
begin
  inherited;
  if generateVariables then
  begin
    S := '';
    n := 0;
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      if Bt.separator and (Copy( Bt.Name, 1, 2 ) = 'TB') and
         IsNumber( Copy( Bt.Name, 3, MaxInt ) ) then
         continue;
      if Bt.Name <> '' then
      begin
        Inc( n );
        //S := S + ',' + Bt.Name;
        {P}S := ' Load4 ####' + BT.Name + S;
      end;
    end;
    if ( S <> '' ) then
    begin
      //Delete( S, 1, 1 );
      //SL.Add( Prefix + AName + '.TBConvertIdxArray2ID( [' + S + '] );' );
      {P}SL.Add( S );
      {P}SL.Add( ' LoadStack L(' + IntToStr( n-1 ) + ') xySwap' );
      {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' + Name );
      {P}SL.Add( ' TControl.TBConvertIdxArray2ID<3>' );
      {P}SL.Add( ' DEL(' + IntToStr( n ) + ')' );
    end;
  end;
end;

function TKOLToolbar.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
var S: String;
    B: String;
    I, N, K: Integer;
    Bt, Bt1: TKOLToolbarButton;
    StdImagesStart, ViewImagesStart, HistImagesStart: Integer;
    TheSameBefore, TheSameAfter: Boolean;
var Op: TToolbarOptions;
    BCaps, BImgs: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.P_SetupParams', 0
  @@e_signature:
  end;
  ValuesInStack := 0;
  Result := '';
  nparams := 3;

  // 5. Bitmap from a resource
  if (Bitmap.Width > 0) and (Bitmap.Height > 0) and
     (FResBmpID >= 0) and (MaxBtnImgWidth = MaxBtnImgHeight) and
     (StandardImagesUsed=0) then
  begin
    if mapBitmapColors then
      {Result := Result + 'LoadMappedBitmapEx( Result, hInstance, ''' +
                UpperCase( ParentKOLForm.FormName ) + '_TBBMP' +
                IntToStr( FResBmpID ) + ''', [ ' +
                Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ), '}
      {P}Result := Result +
                   ' L($' + IntToHex( Color2RGB( clBtnFace ), 6 ) + ')' +
                   #13#10' L(' + IntToStr( FBmpTranColor ) + ')' +
                   #13#10' LoadStack L(1) ' + //'xySwap ' +
                   #13#10' LoadStr ''' + UpperCase( ParentKOLForm.FormName ) + '_TBBMP' +
                     IntToStr( FResBmpID ) + ''' #0' +
                   #13#10' LoadHInstance ' +
                   #13#10' LoadSELF ' +
                   #13#10' LoadMappedBitmapEx<3> RESULT xySwap DEL xySwap DEL'
    else
      {Result := Result + 'LoadBmp( hInstance, PChar( ''' +
                UpperCase( ParentKOLForm.FormName ) + '_TBBMP' + IntToStr( FResBmpID ) +
                ''' ), Result ), ';}
      {P}Result := Result +
                   ' LoadSELF ' +
                   #13#10' LoadStr ''' + UpperCase( ParentKOLForm.FormName ) + '_TBBMP' +
                     IntToStr( FResBmpID ) + ''' #0' +
                   #13#10' LoadHInstance LoadBmp<3> RESULT';
  end
    else // or if standard images are used, type of images here
  if (PicturedButtonsCount = 0) and (IntIn( StandardImagesUsed, [ 1, 2, 4 ] )) then
  begin
    if StandardImagesUsed = 1 then
      if StandardImagesLarge then
        //Result := Result + 'THandle( -2 ), '
        {P}Result := Result + #13#10' L(-2)'
      else
        //Result := Result + 'THandle( -1 ), '
        {P}Result := Result + #13#10' L(-1)'
    else
    if StandardImagesUsed = 2 then
      if StandardImagesLarge then
        //Result := Result + 'THandle( -6 ), '
        {P}Result := Result + #13#10' L(-6)'
      else
        //Result := Result + 'THandle( -5 ), '
        {P}Result := Result + #13#10' L(-5) '
    else
      if StandardImagesLarge then
        //Result := Result + 'THandle( -10 ), '
        {P}Result := Result + #13#10' L(-10)'
      else
        //Result := Result + 'THandle( -9 ), ';
        {P}Result := Result + #13#10' L(-9)';
  end
    else
  begin // or if Bitmap is empty, value 0
    if not ((Bitmap.Width > 0) and (Bitmap.Height > 0) and
     (FResBmpID >= 0)) then
      FResBmpID := 0;
    //Result := Result + '0, ';
    Result := Result + #13#10' L(0) ';
  end;
  Result := Result + #13#10' C2R';

  // 4. Button image indexes used
  //Rpt( '$$$$$$$$$$$$$$$ PicturedButtonsCount := ' + IntToStr( PicturedButtonsCount ) );
  K := 0;
  if (StandardImagesUsed = 0) and (PicturedButtonsCount = 0) and not ImageListsUsed then
    //Result := Result + '[ -2 ]'
    begin
    {P}Result := Result + #13#10' L(-2) LoadStack C2R L(0)';
    Inc( ValuesInStack );
    Inc( K );
    end
  else
  if (StandardImagesUsed = 0) and AllPicturedButtonsAreLeading and
     LastBtnHasPicture and not ImageListsUsed then
    //Result := Result + '[ 0 ]'
    begin
    {P}Result := Result + #13#10' L(0) LoadStack C2R L(0)';
    Inc( ValuesInStack );
    Inc( K );
    end
  else
  begin
    N := PicturedButtonsCount;
    //Result := Result + '[ ';
    StdImagesStart := N;
    ViewImagesStart := N;
    HistImagesStart := N;
    if (StandardImagesUsed > 1) and LongBool(StandardImagesUsed and 1) then
    begin
      ViewImagesStart := N + 15;
      HistImagesStart := N + 15;
    end;
    if LongBool(StandardImagesUsed and 2) then
      HistImagesStart := HistImagesStart + 12;
    N := 0;
    S := '';
    BImgs := '';
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      //Rpt( '%%%%%%%%%% Bt ' + Bt.Name + ' HasPicture := ' + IntToStr( Integer( Bt.HasPicture ) ) );
      if ImageListsUsed then
      begin
        if Bt.imgIndex >= 0 then
          S := IntToStr( Bt.imgIndex )
        else
          S := '-2';
      end
      else
      if Bt.HasPicture then
      begin
        S := IntToStr( N );
        Inc( N );
      end
        else
      case Bt.sysimg of
      stiCustom:
        S := '-2'; // I_IMAGENONE
      stdCUT..stdPRINT:
        S := IntToStr( StdImagesStart + Ord( Bt.sysimg ) - Ord( stdCUT ) );
      viewLARGEICONS..viewVIEWMENU:
        S := IntToStr( ViewImagesStart + Ord( Bt.sysimg ) - Ord( viewLARGEICONS ) );
      else
        S := IntToStr( HistImagesStart + Ord( Bt.sysimg ) - Ord( histBACK ) );
      end;
      //Result := Result + S + ', ';
      {P}BImgs := ' L(' + S + ')' + BImgs;
      Inc( K );
    end;
    {if Items.Count > 0 then
      Result := Copy( Result, 1, Length( Result ) - 2 ) + ' ]'
    else
      Result := Result + ']';}
    {P}Result := Result + BImgs +
                 #13#10' LoadStack C2R L(' + IntToStr( K ) + ')';
    Inc( ValuesInStack, K );
  end;

  // 3. Button captions
  //Result := Result + '[ ';
  BCaps := '';
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if Bt.separator then
      //Result := Result + '''-'''
      {P}BCaps := ' ''-'' #0 ' + BCaps
    else
    begin
      if noTextLabels then
        B := ' '
      else
        B := Bt.Fcaption;
      S := '';
      if Bt.radioGroup <> 0 then
      begin
        TheSameBefore := FALSE;
        TheSameAfter := FALSE;
        if I > 0 then
        begin
          Bt1 := Items[ I - 1 ];
          if not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
            TheSameBefore := TRUE;
        end;
        if I < Items.Count-1 then
        begin
          Bt1 := Items[ I + 1 ];
          if not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
            TheSameAfter := TRUE;
        end;
        if TheSameBefore or TheSameAfter then
          S := '!' + S;
      end;
      if Bt.checked and (Bt.Faction = nil) then
        S := '+' + S
      else
      if Bt.radioGroup <> 0 then
        S := '-' + S;
      if Bt.dropdown then
        S := '^' + S;
      if noTextLabels then
        //Result := Result + '''' + S + B + ''''
        {P}BCaps := ' ''' + S + B + ''' #0 ' + BCaps
      else
      if Bt.Faction <> nil then
        //Result := Result + '''' + S + '  '''
        {P}BCaps := ' ''' + S + '  '' #0 ' + BCaps
      else
      begin
        B := StringConstant( Bt.Name + '_btn', B );
        if (B <> '') and (B[ 1 ] = '''') then
          //Result := Result + '''' + S + Copy( B, 2, MaxInt )
          {P}BCaps := ' ''' + S + Copy( B, 2, MaxInt ) + ' #0 ' + BCaps
        else
        if S <> '' then
          //Result := Result + 'PChar( ''' + S + ''' + ' + B + ')'
          {P}BCaps := ' ''' + S + ''' ' + B + ' #0 ' + BCaps
        else
          //Result := Result + 'PChar( ' + B + ' )';
          {P}BCaps := B + ' #0 ' + BCaps;
      end;
    end;
    {if I < Items.Count-1 then
      Result := Result  + ', ';}
  end;
  //Result := Result + ' ], ';
  if Items.Count = 0 then
  begin
    //{P}Result := Result + ' LoadStack L(-1) R2C L(' + IntToStr( K ) + ')'
    {P}Result := Result + #13#10' L(2) R2CN LoadStack L(12) xyAdd xySwap L(-1) xySwap ' +
      #13#10' L(' + IntToStr( K-1 ) + ')';
    Inc( ValuesInStack );
  end
  else
  begin
    {P}Result := Result + #13#10' L(' + IntToStr( Items.Count ) + ')' +
      #13#10' LoadPCharArray ' + BCaps + ' L(' + IntToStr( Items.Count ) + ')' +
      #13#10' L(2) R2CN LoadStack L(12) xyAdd xySwap L(' + IntToStr( Items.Count-1 ) + ') xySwap L(' +
        IntToStr( K-1 ) + ')';
    Inc( ValuesInStack, Items.Count+2 );
  end;

  // 2. Options parameter
  Op := [];
  if (tboTextRight in Options) or
      FixFlatXP and {(Align in [caLeft, caRight]) and} (tboFlat in Options) then
    Op := [tboTextRight];
  if (tboTextBottom in Options) and (Op = []) then Op := Op + [tboTextBottom];
  if tboFlat in Options then Op := Op + [tboFlat];
  if tboTransparent in Options then Op := Op + [tboTransparent];
  if (tboWrapable in Options) and not( FixFlatXP and (Align in [caLeft, caRight]) and
     (tboFlat in Options) )
     {or
     ( (tboFlat in Options) and not (Align in [caLeft, caRight] ) and FixFlatXP )} then
    Op := Op + [tboWrapable];
  if tboNoDivider in Options then Op := Op + [tboNoDivider];
  if tbo3DBorder in Options then  Op := Op + [tbo3DBorder];
  //Result := AParent + ', ' + A + ', [' + S + '], ';
  {P}Result := Result + #13#10' L(' + IntToStr( PWord( @ Op )^ ) + ')';

  // 1. Align parameter
  {case Align of
    caLeft: A := 'caLeft';
    caRight:A := 'caRight';
    caClient: A := 'caClient';
    caTop: A := 'caTop';
    caBottom: A := 'caBottom';
    else A := 'caNone';
  end;}
  //Result := AParent + ', ' + A + ', [' + S + '], ';
  {P}Result := Result + #13#10' L(' + IntToStr( Integer( Align ) ) + ')';

  // 0.Parent parameter
  {P}Result := Result + #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.';
  {P}if Parent = Owner then Result := Result + 'Form'
                       else Result := Result + Parent.Name;
  nparams := 3;
end;

procedure TKOLToolbar.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var RsrcFile, RsrcName: String;
    S, B: String;
    I, J, K, W, H, N, I0, K1: Integer;
    Bmp: TBitmap;
    Bt, Bt1: TKOLToolbarButton;
    Btn1st, NEvents: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.P_SetupFirst', 0
  @@e_signature:
  end;
  RsrcName := '';
  H := MaxBtnImgHeight;
  W := MaxBtnImgWidth;
  if W * H > 0 then
  begin
    RsrcName := UpperCase( ParentKOLForm.FormName ) + '_TBBMP' +  IntToStr( FResBmpID );
    RsrcFile := ParentKOLForm.FormName + '_' + Name;
    SL.Add( '{$R ' + RsrcFile + '.res}' );
    Bmp := TBitmap.Create;
    TRY
      N := 0;
      FBmpTranColor := clNone;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
        begin
          if FBmpTranColor = clNone then
          begin
            Bmp.Assign( Bt.picture );
            FBmpTranColor := Bmp.Canvas.Pixels[ 0, Bmp.Height - 1 ];
          end;
          Inc( N );
        end;
      end;
      Bmp.Width := N * W;
      Bmp.Height := H;
      {$IFNDEF _D2}
      Bmp.PixelFormat := pf24bit;
      {$ENDIF}
      if FBmpTranColor <> clNone then
      begin
        Bmp.Canvas.Brush.Color := FBmpTranColor;
        Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
      end;
      N := 0;
      for I := 0 to Items.Count-1 do
      begin
        Bt := Items[ I ];
        if Bt.HasPicture then
        begin
          Bmp.Canvas.Draw( N * W, 0, Bt.picture.Graphic );
          Inc( N );
        end;
      end;
      GenerateBitmapResource( Bmp, RsrcName, RsrcFile, fUpdated, AllowBitmapCompression );
    FINALLY
      Bmp.Free;
    END;
  end;
  if HeightAuto then
  begin
    DefaultHeight := Height;
    DefaultWidth := Width;
  end
    else
  begin
    if Align in [ caTop, caBottom, caNone ] then
    begin
      DefaultHeight := 22;
      DefaultWidth := Width;
    end
      else
    if Align in [ caLeft, caRight ] then
    begin
      DefaultHeight := Height;
      DefaultWidth := 44;
    end
      else
    begin
      DefaultHeight := Height;
      DefaultWidth := Width;
    end;
  end;
  inherited;
  if ValuesInStack = 1 then
    SL.Add( ' xySwap DEL' )
    else
  if ValuesInStack > 0 then
    SL.Add( ' C2R L(' + IntToStr( ValuesInStack ) + ') DELN R2C' );;
  ValuesInStack := 0;
  if TBButtonsWidth > 0 then
    //SL.Add( '  ' + Prefix + AName + '.Perform( TB_SETBUTTONSIZE, ' +
    //  IntToStr( TBButtonsWidth ) + ', 0 );' );
    {P}SL.Add( ' L(0) L(' + IntToStr( TBButtonsWidth ) + ') L(' +
      IntToStr( TB_SETBUTTONSIZE ) + ') C3 TControl.Perform<0>' ); // stdcall!
  if Assigned( bitmap ) and (bitmap.Width * bitmap.Height > 0) then
  begin
    W := MaxBtnImgWidth;
    H := MaxBtnImgHeight;
    if (W <> H) or (StandardImagesUsed > 0) then
    begin
      //SL.Add( '  ' + Prefix + AName + '.TBBtnImgWidth := ' + IntToStr( W ) + ';' );
      {P}SL.Add( ' L(' + IntToStr( W ) +
        ') C1 AddWord_Store ##TControl_.fTBBtnImgWidth' );
      //S := '  ' + Prefix + AName + '.TBAddBitmap( ';
      if mapBitmapColors then
        //S := S + 'LoadMappedBitmapEx( ' + AName + ', hInstance, ''' + RsrcName + ''', [ ' +
        //          Color2Str( FBmpTranColor ) + ', Color2RGB( clBtnFace ) ] ) );'
        {P}SL.Add( ' L($' + IntToHex( clBtnFace, 6 ) + ') Color2RGB<1> RESULT' +
                   ' L($' + IntToHex( FBmpTranColor, 6 ) + ')' +
                   ' LoadStack L(1)' +
                   ' LoadStr ''' + RsrcName + ''' #0' +
                   ' LoadHInstance C6 LoadMappedBitmapEx<3> DEL DEL RESULT' )
      else
        //S := S + 'LoadBmp( hInstance, ''' + RsrcName + ''', ' +
        //         AName + ' ) );';
        {P}SL.Add( ' DUP LoadStr ''' + RsrcName + ''' #0 LoadHInstance' +
                   ' LoadBmp<3> RESULT');
      //SL.Add( S );
      {P}SL.Add( ' C1 TControl.TBAddBitmap<2>' );
    end;
  end;
  if ((StandardImagesUsed > 0) and (PicturedButtonsCount > 0)) or
     not IntIn(StandardImagesUsed, [ 1, 2, 4 ]) then
  begin
    if LongBool( StandardImagesUsed and 1 ) then
    begin
      if StandardImagesLarge then
        S := '-2'
      else
        S := '-1';
      //SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
      {P}SL.Add( ' L(' + S + ') C1 TControl.TBAddBitmap<2>' );
    end;
    if LongBool( StandardImagesUsed and 2 ) then
    begin
      if StandardImagesLarge then
        S := '-6'
      else
        S := '-5';
      //SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
      {P}SL.Add( ' L(' + S + ') C1 TControl.TBAddBitmap<2>' );
    end;
    if LongBool( StandardImagesUsed and 4 ) then
    begin
      if StandardImagesLarge then
        S := '-10'
      else
        S := '-9';
      //SL.Add( '  ' + Prefix + AName + '.TBAddBitmap( THandle( ' + S + ' ) );' );
      {P}SL.Add( ' L(' + S + ') C1 TControl.TBAddBitmap<2>' );
    end;
  end;

  if showTooltips or (tooltips.Count > 0) then
  begin
    S := '';
    J := 0;
    K1 := 0;
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      //if Bt.Faction <> nil then continue; // remove by YS 7-Aug-2004
      //if Bt.separator then continue;

      //---------{ Maxim Pushkar }----------------------------------------------
      //if (tooltips.Count > 0) and (J > tooltips.Count) then break;
      //----------------------------------------------------------------------//
      if (tooltips.Count > 0) and (J >= tooltips.Count) then break;          //
      //--------------------------------------------------------------------//

      if Bt.Tooltip <> '' then
        B := Bt.Tooltip
      else
      if (tooltips.Count > 0) and (tooltips[ J ] <> '') and not Bt.separator then
        B := tooltips[ J ]
      else
      if showTooltips then
        B := Bt.Caption
      else
        B := '';
      if Bt.Faction = nil then                     // {YS} äîáàâèòü
      begin                                        // {YS} äîáàâèòü
        if not Bt.separator then                   // {YS} äîáàâèòü
        begin
          //if S <> '' then
          //  S := S + ', ';
          //S := S + PCharStringConstant( Self, Bt.Name + '_tip', B );
          {P}S := //P_PCharStringConstant( Self, Bt.Name + '_tip', B ) + S;
                ' ' + P_String2Pascal( B ) + ' ' + S;
          inc( K1 );
        end
          else
        //+++++++ v1.94
        begin
          {if S <> '' then
            //S := S + ', '''''
          else
            //S := S + '''''';}
          {P}S := #13#10' #0 ' + S;
          inc( K1 );
        end;
        //------
      end                                          // {YS} äîáàâèòü
      else                                         // {YS} äîáàâèòü
       Inc( J );
    end;
    // change by Alexander Pravdin (to fix tooltips for case of first separator):
    //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    Btn1st := 0;
    {for i := 0 to ButtonCount - 1 do
      if not TKOLToolbarButton( FItems.Items[i] ).Fseparator then begin
        Btn1st := i;
        Break;
      end;}
    if S <> '' then
    begin
        //SL.Add( Prefix + '  ' + AName + '.TBSetTooltips( ' + AName +
        //  '.TBIndex2Item( ' + IntToStr( Btn1st ) + ' ), [ ' + S + ' ] );' );
        {P}SL.Add( ' L(' + IntToStr( K1 ) + ') LoadPCharArray ' + S +
                   #13#10' LoadStack L(' + IntToStr( K1-1 ) + ') xySwap' +
                   #13#10' L(' + IntToStr( Btn1st ) + ') LoadSELF AddWord_LoadRef ##T' +
                   ParentKOLForm.FormName + '.' + Name +
                   #13#10' TControl.TBIndex2Item<2> RESULT' +
                   #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName +
                   '.' + Name +
                   //#13#10' TControl.TBSetTooltips<3> ' +
                   #13#10' ToolbarSetTooltips<3> ' +
                   #13#10' L(' + IntToStr( Items.Count ) + ') DELN' );
    end;
    //--------------------------------------------------------------------------
    {if S <> '' then
      SL.Add( Prefix + '  ' + AName + '.TBSetTooltips( ' + AName +
              '.TBIndex2Item( 0 ), [ ' + S + ' ] );' );}
    ////////////////////////////////////////////////////////////////////////////
  end;

  // assign image list if used:
  if ImageListNormal <> nil then
  begin
    //SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETIMAGELIST, 0, Result.' +
    //        ImageListNormal.Name + '.Handle );' );
    {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
               '.' + ImageListNormal.Name +
               #13#10' TImageList_.GetHandle<1> RESULT' +
               #13#10' L(0) L(' + IntToStr( TB_SETIMAGELIST ) + ')' +
               #13#10' C3 TControl.Perform<0>' ); // stdcall!
  end;
  if ImageListDisabled <> nil then
  begin
    //SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETDISABLEDIMAGELIST, 0, Result.' +
    //        ImageListDisabled.Name + '.Handle );' );
    {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
               '.' + imageListDisabled.Name +
               #13#10' TImageList_.GetHandle<1> RESULT' +
               #13#10' L(0) L(' + IntToStr( TB_SETDISABLEDIMAGELIST ) + ')' +
               #13#10' C3 TControl.Perform<0>' ); // stdcall!
  end;
  if ImageListHot <> nil then
  begin
    //SL.Add( Prefix + ' ' + AName + '.Perform( TB_SETHOTIMAGELIST, 0, Result.' +
    //        ImageListHot.Name + '.Handle );' );
    {P}SL.Add( ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
               '.' + imageListHot.Name +
               #13#10' TImageList_.GetHandle<1> RESULT' +
               #13#10' L(0) L(' + IntToStr( TB_SETHOTIMAGELIST ) + ')' +
               #13#10' C3 TControl.Perform<0>' ); // stdcall!
  end;

  I0 := -1;
  NEvents := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    Inc( I0 );
    //if Bt.separator then Continue;
    if Bt.fOnClickMethodName <> '' then
    begin
      S := '';
      for J := I to Items.Count - 1 do
      begin
        Bt := Items[ J ];
        //if Bt.separator then Continue;
        if Bt.separator or (Bt.fOnClickMethodName = '') then
        begin
          N := 0;
          for K := J to Items.Count-1 do
          begin
            Bt1 := Items[ K ];
            if Bt1.separator then Continue;
            if Bt1.fOnClickMethodName <> '' then
            begin
              Inc( N );
              break;
            end;
          end;
          if N = 0 then break;
        end;
        //if S <> '' then S := S + ', ';
        if Bt.fOnClickMethodName <> '' then
          //S := S + 'Result.' + Bt.fOnClickMethodName
          {P}S := #13#10' LoadSELF Load4 ####T' + ParentKOLForm.FormName + '.' +
            Bt.fOnClickMethodName + S
        else
          //S := S + 'nil';
          {P}S := #13#10' L(0) L(0) ' + S;
        inc( NEvents );
      end;
      //SL.Add( '  ' + Prefix + AName + '.TBAssignEvents( ' + IntToStr( I0 ) +
      //        ', [ ' + S + ' ] );' );
      {P}SL.Add( S + #13#10' LoadStack L(' + IntToStr( NEvents-1 ) + ') xySwap' +
                 #13#10' L(' + IntToStr( I0 ) + ')' +
                 #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.formName + '.' +
                 Name + ' TControl.TBAssignEvents<3>' );
      {P}SL.Add( ' L(' + IntToStr( NEvents * 2 ) + ') DELN' );
      break;
    end;
  end;
  if TBButtonsMinWidth > 0 then
    //SL.Add( Prefix + AName + '.TBButtonsMinWidth := ' + IntToStr( TBButtonsMinWidth ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( TBButtonsMinWidth ) + ') L(0)' +
               #13#10' C2 TControl_.TBSetBtMinMaxWidth<3>' );
  if TBButtonsMaxWidth > 0 then
    //SL.Add( Prefix + AName + '.TBButtonsMaxWidth := ' + IntToStr( TBButtonsMaxWidth ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( TBButtonsMaxWidth ) + ') L(1)' +
               #13#10' C2 TControl_.TBSetBtMinMaxWidth<3>' );
  for I := Items.Count-1 downto 0 do
  begin
    Bt := Items[ I ];
    if not Bt.visible and (Bt.Faction = nil) then
      //SL.Add( Prefix + AName + '.TBButtonVisible[ ' + IntToStr( I ) + ' ] := FALSE;' );
      {P}SL.Add( ' L(0) L(' + IntToStr( I ) + ')' +
                 //#13#10' C2 TControl_.TBSetButtonVisible<3>' );
                 #13#10' C2 ShowHideToolbarButton<3>' );
    if not Bt.enabled and (Bt.Faction = nil) then
      //SL.Add( Prefix + AName + '.TBButtonEnabled[ ' + IntToStr( I ) + ' ] := FALSE;' );
      {P}SL.Add( ' L(0) L(' + IntToStr( TB_ENABLEBUTTON ) + ') L(' + IntToStr( I ) + ')' +
                 //#13#10' C3 TControl_.TBSetBtnStt<3>' );
                 #13#10' C3 EnableToolbarButton<3>' );
  end;

  if FixFlatXP then
  if (tboFlat in Options) and (Parent <> nil) and not(Parent is TForm) then
  begin
    if Align in [ caLeft, caRight ] then
    begin
      //SL.Add( Prefix + '  ' + AName + '.Style := ' + AName +
      //  '.Style or TBSTYLE_WRAPABLE;' );
      {P}SL.Add( ' DUP AddWord_LoadRef ##TControl_.fStyle' +
                 #13#10' L(' + IntToStr( TBSTYLE_WRAPABLE ) + ') |' +
                 #13#10' C1 TControl_.SetStyle<2>' );
    end
      else
    begin
      {SL.Add( Prefix + 'if WinVer >= wvXP then' );
      SL.Add( Prefix + 'begin' );
      SL.Add( Prefix + '  ' + AName + '.Style := ' + AName +
        '.Style or TBSTYLE_WRAPABLE;' );
      SL.Add( Prefix + '  ' + AName + '.Transparent := TRUE;' );
      SL.Add( Prefix + 'end;' );}
      {P}SL.Add( ' WinVer RESULTB' +
                 #13#10' L(' + IntToStr( Integer( wvXP ) ) + ')' +
                 #13#10' - x>=0? IF1' +
                 ' DUP AddWord_LoadRef ##TControl_.fStyle' +
                 ' L(' + IntToStr( TBSTYLE_WRAPABLE ) + ') |' +
                 ' C1 TControl_.SetStyle<2>' +
                 ' L(1) C1 TControl_.SetTransparent<2>' +
                 #13#10' ENDIF' );
    end;
  end;
end;

function TKOLToolbar.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLToolbar.DesembleTooltips;
var SL: TStrings;
    I, N: Integer;
    Bt: TKOLToolbarButton;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbar.AssembleTooltips', 0
  @@e_signature:
  end;
  N := 0;
  SL := tooltips;
  if SL <> nil then
  BEGIN
    for I := 0 to Items.Count-1 do
    begin
      Bt := Items[ I ];
      if Bt.separator then continue;
      if N >= SL.Count then
        Bt.FTooltip := ''
      else
        Bt.Ftooltip := SL[ N ];
      Inc( N );
    end;
    showTooltips := SL.Count > 0;
  END;
end;

procedure TKOLToolbar.SetOnTBCustomDraw(const Value: TOnTBCustomDraw);
begin
  FOnTBCustomDraw := Value;
  Change;
end;

procedure TKOLToolbar.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnTBCustomDraw' ],
                             [ @ OnTBCustomDraw ] );
end;

procedure TKOLToolbar.SetupConstruct_Compact;
var KF: TKOLForm;
    i, N: Integer;
    Bt, Bt1: TKOLToolbarButton;
    s, B: String;
    TheSameBefore, TheSameAfter: Boolean;
    StdImagesStart, ViewImagesStart, HistImagesStart: Integer;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewToolbar', TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( Align ) );
    KF.FormAddNumParameter( PInteger( @ Options )^ );
    if (Bitmap.Width > 0) and (Bitmap.Height > 0) and
       (FResBmpID >= 0) and (MaxBtnImgWidth = MaxBtnImgHeight) and
       (StandardImagesUsed=0) then
    begin
        KF.FormAddNumParameter( Integer( mapBitmapColors )+1 );
        if  mapBitmapColors then
            KF.FormAddNumParameter( (FBmpTranColor shl 1) or (FBmpTranColor shr 31) );
        KF.FormAddStrParameter( UpperCase( ParentKOLForm.FormName ) +
                                '_TBBMP' + IntToStr( FResBmpID ) );
    end
      else
    begin
        if (PicturedButtonsCount = 0) and (IntIn( StandardImagesUsed, [ 1, 2, 4 ] )) then
        begin
          if  StandardImagesUsed = 1 then
              if  StandardImagesLarge then
                  //Result := Result + 'THandle( -2 ), '
                  KF.FormAddNumParameter( -2 )
              else
                  //Result := Result + 'THandle( -1 ), '
                  KF.FormAddNumParameter( -1 )
          else
          if  StandardImagesUsed = 2 then
              if  StandardImagesLarge then
                  //Result := Result + 'THandle( -6 ), '
                  KF.FormAddNumParameter( -6 )
              else
                  //Result := Result + 'THandle( -5 ), '
                  KF.FormAddNumParameter( -5 )
          else
              if  StandardImagesLarge then
                  //Result := Result + 'THandle( -10 ), '
                  KF.FormAddNumParameter( -10 )
              else
                  //Result := Result + 'THandle( -9 ), ';
                  KF.FormAddNumParameter( -9 );
        end
          else
        begin
            if  not ((Bitmap.Width > 0) and (Bitmap.Height > 0)
            and (FResBmpID >= 0)) then
                FResBmpID := 0;
            KF.FormAddNumParameter( 0 );
        end;
    end;
    KF.FormAddNumParameter( Items.Count );
    for i := 0 to Items.Count-1 do
    begin
        Bt := Items[ I ];
        if  Bt.separator then
            s := '-'
        else
        begin
            if  noTextLabels or not KF.AssignTextToControls then
                B := ' '
            else
                B := Bt.Fcaption;
            s := '';
            if  Bt.radioGroup <> 0 then
            begin
                TheSameBefore := FALSE;
                TheSameAfter := FALSE;
                if  i> 0 then
                begin
                   Bt1 := Items[ i - 1 ];
                   if  not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
                       TheSameBefore := TRUE;
                end;
                if  i < Items.Count-1 then
                begin
                    Bt1 := Items[ I + 1 ];
                    if  not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
                        TheSameAfter := TRUE;
                end;
                if  TheSameBefore or TheSameAfter then
                    s := '!' + s;
            end;
            if  Bt.checked and (Bt.Faction = nil) then
                s := '+' + s
            else
            if  Bt.radioGroup <> 0 then
                s := '-' + s;
            if  Bt.dropdown then
                s := '^' + s;
            if  noTextLabels then
                s := s + B
            else
            if  Bt.Faction <> nil then
                //
            else
            begin
                B := Bt.Name;
                if  (B <> '') and (B[ 1 ] = '''') then
                    s := s + Copy( B, 2, MaxInt )
                else
                    s := s + B;
            end;
        end;
        KF.FormAddStrParameter( s );
    end;

    if  (StandardImagesUsed = 0) and (PicturedButtonsCount = 0) and not ImageListsUsed then
    begin
        KF.FormAddNumParameter( 1 );
        KF.FormAddNumParameter( -2 );
    end else
    if  (StandardImagesUsed = 0) and AllPicturedButtonsAreLeading and
        LastBtnHasPicture and not ImageListsUsed then
    begin
        KF.FormAddNumParameter( 1 );
        KF.FormAddNumParameter( 0 );
    end else
    begin
        N := PicturedButtonsCount;
        StdImagesStart := N;
        ViewImagesStart := N;
        HistImagesStart := N;
        if (StandardImagesUsed > 1) and LongBool(StandardImagesUsed and 1) then
        begin
            ViewImagesStart := N + 15;
            HistImagesStart := N + 15;
        end;
        if  LongBool(StandardImagesUsed and 2) then
            HistImagesStart := HistImagesStart + 12;
        N := 0;
        S := '';
        KF.FormAddNumParameter( Items.Count );
        for I := 0 to Items.Count-1 do
        begin
            Bt := Items[ I ];
            if  ImageListsUsed then
            begin
                if  Bt.imgIndex >= 0 then
                    KF.FormAddNumParameter( Bt.imgIndex )
                else
                    KF.FormAddNumParameter( -2 );
            end
            else
            if  Bt.HasPicture then
            begin
                KF.FormAddNumParameter( N );
                Inc( N );
            end
            else
            case Bt.sysimg of
            stiCustom:
                KF.FormAddNumParameter( -2 ); // I_IMAGENONE
            stdCUT..stdPRINT:
                KF.FormAddNumParameter( StdImagesStart + Ord( Bt.sysimg ) - Ord( stdCUT ) );
            viewLARGEICONS..viewVIEWMENU:
                KF.FormAddNumParameter( ViewImagesStart + Ord( Bt.sysimg ) - Ord( viewLARGEICONS ) );
            else
                KF.FormAddNumParameter( HistImagesStart + Ord( Bt.sysimg ) - Ord( histBACK ) );
            end;
        end;
    end;
end;

function TKOLToolbar.SupportsFormCompact: Boolean;
begin
    Result := TRUE; //CompactCode;
end;

procedure TKOLToolbar.SetCompactCode(const Value: Boolean);
begin
  if  FCompactCode = Value then Exit;
  FCompactCode := Value;
  Change;
end;

function TKOLToolbar.HasCompactConstructor: Boolean;
begin
    Result := CompactCode and (Items.Count < 256);
end;

function TKOLToolbar.ButtonCaptionsList( var Cnt: Integer ): String;
VAR S, B: String;
    I: Integer;
    Bt, Bt1: TKOLToolbarButton;
    TheSameBefore, TheSameAfter: Boolean;
    {$IFDEF _D2009orHigher}
    C2: String;
    C : String;
    Z: Integer;
    {$ENDIF}
begin
  Result := '';
  Cnt := 0;
  for I := 0 to Items.Count-1 do
  begin
    Bt := Items[ I ];
    if  Bt.separator then
    begin
        Result := Result + '''-''';
    end
    else
    begin
        if noTextLabels or
           (ParentKOLForm = nil) or not ParentKOLForm.AssignTextToControls then
           B := ' '
        else
        begin
           {$IFDEF _D2009orHigher}
            C2 := '';
            C := Bt.Fcaption;
            for Z := 1 to Length(C) do C2 := C2 + '#'+int2str(ord(C[Z]));
            B := C2;
           {$ELSE}
            B := Bt.Fcaption;
           {$ENDIF}
        end;
        S := '';
        if Bt.radioGroup <> 0 then
        begin
          TheSameBefore := FALSE;
          TheSameAfter := FALSE;
          if I > 0 then
          begin
            Bt1 := Items[ I - 1 ];
            if not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
              TheSameBefore := TRUE;
          end;
          if I < Items.Count-1 then
          begin
            Bt1 := Items[ I + 1 ];
            if not Bt1.separator and (Bt1.FradioGroup = Bt.FradioGroup) then
              TheSameAfter := TRUE;
          end;
          if TheSameBefore or TheSameAfter then
            S := '!' + S;
        end;
        if Bt.checked and (Bt.Faction = nil) then
          S := '+' + S
        else
        if Bt.radioGroup <> 0 then
          S := '-' + S;
        if Bt.dropdown then
          S := '^' + S;
        if noTextLabels then
          Result := Result + '''' + S + B + ''''
        else
        if  Bt.Faction <> nil then
            Result := Result + '''' + S + '  '''
        else
        begin
           {$IFDEF _D2009orHigher}
            if B = '' then B := '''''';
           {$ELSE}
            B := StringConstant( Bt.Name + '_btn', B );
           {$ENDIF}
            if (B <> '') and (B[ 1 ] = '''') then
              Result := Result + '''' + S + Copy( B, 2, MaxInt )
            else
            if S <> '' then
              Result := Result + 'PKOLChar( ''' + S + ''' + ' + B + ')'
            else
              Result := Result + 'PKOLChar( ' + B + ' )';
        end;
      end;
      if  I < Items.Count-1 then
          Result := Result  + ', ';
      inc( Cnt );
  end;
end;

function TKOLToolbar.ButtonImgIndexesList( var Cnt: Integer ): String;
VAR I, N: Integer;
    StdImagesStart, ViewImagesStart, HistImagesStart: Integer;
    S: String;
    Bt: TKOLToolbarButton;
begin
  Cnt := 0;
  if  (StandardImagesUsed = 0) and (PicturedButtonsCount = 0) and not ImageListsUsed then
  begin
      Result := Result + '-2';
      Cnt := 1;
  end else
  if  (StandardImagesUsed = 0) and AllPicturedButtonsAreLeading and
      LastBtnHasPicture and not ImageListsUsed then
  begin
      Result := Result + '0';
      Cnt := 1;
  end else
  begin
    N := PicturedButtonsCount;
    StdImagesStart := N;
    ViewImagesStart := N;
    HistImagesStart := N;
    if  (StandardImagesUsed > 1) and LongBool(StandardImagesUsed and 1) then
    begin
        ViewImagesStart := N + 15;
        HistImagesStart := N + 15;
    end;
    if  LongBool(StandardImagesUsed and 2) then
        HistImagesStart := HistImagesStart + 12;
    N := 0;
    S := '';
    for I := 0 to Items.Count-1 do
    begin
        Bt := Items[ I ];
        //Rpt( '%%%%%%%%%% Bt ' + Bt.Name + ' HasPicture := ' + IntToStr( Integer( Bt.HasPicture ) ) );
        if ImageListsUsed then
        begin
          if Bt.imgIndex >= 0 then
            S := IntToStr( Bt.imgIndex )
          else
            S := '-2';
        end
        else
        if Bt.HasPicture then
        begin
          S := IntToStr( N );
          Inc( N );
        end
          else
        case Bt.sysimg of
        stiCustom:
          S := '-2'; // I_IMAGENONE
        stdCUT..stdPRINT:
          S := IntToStr( StdImagesStart + Ord( Bt.sysimg ) - Ord( stdCUT ) );
        viewLARGEICONS..viewVIEWMENU:
          S := IntToStr( ViewImagesStart + Ord( Bt.sysimg ) - Ord( viewLARGEICONS ) );
        else
          S := IntToStr( HistImagesStart + Ord( Bt.sysimg ) - Ord( histBACK ) );
        end;
        Result := Result + S + ', ';
        inc( Cnt );
    end;
    if  Items.Count > 0 then
        Result := Copy( Result, 1, Length( Result ) - 2 );
  end;
end;

procedure TKOLToolbar.SetAutosizeButtons(const Value: Boolean);
begin
    if  FAutosizeButtons = Value then Exit;
    FAutosizeButtons := Value;
    Change;
end;

procedure TKOLToolbar.SetNoSpaceForImages(const Value: Boolean);
begin
    if  FNoSpaceForImages = Value then Exit;
    FNoSpaceForImages := Value;
    Change;
end;

procedure TKOLToolbar.SetAllowBitmapCompression(const Value: Boolean);
begin
  if  FAllowBitmapCompression = Value then Exit;
  FAllowBitmapCompression := Value;
  Change;
end;

{ TKOLToolbarButtonsEditor }

procedure TKOLToolbarButtonsEditor.Edit;
var Tb: TKOLToolbar;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonsEditor.Edit', 0
  @@e_signature:
  end;
  if GetComponent( 0 ) = nil then Exit;
  Tb := GetComponent( 0 ) as TKOLToolbar;
  if Tb.ActiveDesign = nil then
    Tb.ActiveDesign := TfmToolbarEditor.Create( Application );
  Tb.ActiveDesign.ToolbarControl := Tb;
  Tb.ActiveDesign.Visible := TRUE;
  SetForegroundWindow( Tb.ActiveDesign.Handle );
  Tb.ActiveDesign.MakeActive( TRUE );
  if Tb.ParentForm <> nil then
    Tb.ParentForm.Invalidate;
end;

function TKOLToolbarButtonsEditor.GetAttributes: TPropertyAttributes;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonsEditor.GetAttributes', 0
  @@e_signature:
  end;
  Result := [ paDialog, paReadOnly ];
end;

{ TKOLToolbarEditor }

procedure TKOLToolbarEditor.Edit;
var Tb: TKOLToolbar;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.Edit', 0
  @@e_signature:
  end;
  if Component = nil then Exit;
  Tb := Component as TKOLToolbar;
  if Tb.ActiveDesign = nil then
    Tb.ActiveDesign := TfmToolbarEditor.Create( Application );
  Tb.ActiveDesign.ToolbarControl := Tb;
  Tb.ActiveDesign.Visible := TRUE;
  SetForegroundWindow( Tb.ActiveDesign.Handle );
  Tb.ActiveDesign.MakeActive( TRUE );
  if Tb.ParentForm <> nil then
    Tb.ParentForm.Invalidate;
end;

procedure TKOLToolbarEditor.ExecuteVerb(Index: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.ExecuteVerb', 0
  @@e_signature:
  end;
  Edit;
end;

function TKOLToolbarEditor.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.GetVerb', 0
  @@e_signature:
  end;
  Result := '&Edit';
end;

function TKOLToolbarEditor.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarEditor.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 1;
end;

{ TKOLTabControlEditor }

procedure TKOLTabControlEditor.Edit;
var P: TPoint;
    C: TComponent;
    TabControl: TKOLTabControl;
    I: Integer;
    R: PRect;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.Edit', 0
  @@e_signature:
  end;
  GetCursorPos( P );
  C := Component;
  if C = nil then Exit;
  if not( C is TKOLTabControl ) then Exit;
  TabControl := C as TKOLTabControl;
  P := TabControl.ScreenToClient( P );
  for I := 0 to TabControl.Count-1 do
  begin
    R := TabControl.FTabs[ I ];
    if PtInRect( R^, P ) then
    begin
      TabControl.CurIndex := I;
      break;
    end;
  end;
end;

procedure TKOLTabControlEditor.ExecuteVerb(Index: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.ExecuteVerb', 0
  @@e_signature:
  end;
  Edit;
end;

function TKOLTabControlEditor.GetVerb(Index: Integer): string;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.GetVerb', 0
  @@e_signature:
  end;
  Result := '';
end;

function TKOLTabControlEditor.GetVerbCount: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLTabControlEditor.GetVerbCount', 0
  @@e_signature:
  end;
  Result := 0;
end;

{ TKOLImageShow }

constructor TKOLImageShow.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.Create', 0
  @@e_signature:
  end;
  inherited;
  FHasBorder := FALSE;
  FDefHasBorder := FALSE;
end;

destructor TKOLImageShow.Destroy;
begin
  if ImageListNormal <> nil then
    ImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  inherited;
end;

procedure TKOLImageShow.DoAutoSize;
var Delta: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.DoAutoSize', 0
  @@e_signature:
  end;
  if not fImgShwAutoSize then Exit;
  if FImageListNormal = nil then Exit;
  Delta := 0;
  if HasBorder then
  begin
    Inc( Delta, 6 );
  end;
  Width := FImageListNormal.ImgWidth + Delta;
  Height := FImageListNormal.ImgHeight + Delta;
  //FAutoSize := TRUE;
  fImgShwAutoSize := TRUE;
  Change;
end;

function TKOLImageShow.NoDrawFrame: Boolean;
begin
  Result := HasBorder;
end;

procedure TKOLImageShow.NotifyLinkedComponent(Sender: TObject;
  Operation: TNotifyOperation);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.NotifyLinkedComponent', 0
  @@e_signature:
  end;
  inherited;
  if Operation = noRemoved then
    ImageListNormal := nil;
end;

procedure TKOLImageShow.Paint;
var
  R:TRect;
  EdgeFlag:DWord;
  //Flag:DWord;
  Delta:DWord;
  TMP:TBitMap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.Paint', 0
  @@e_signature:
  end;

  R.Left:=0;
  R.Top:=0;
  R.Right:=Width;
  R.Bottom:=Height;

  if HasBorder then
  begin
    EdgeFlag:=EDGE_RAISED;
    Delta:=3;
  end
  else
  begin
    EdgeFlag:=0;
    Delta:=0;
  end;

  if Delta <> 0 then
  begin
    DrawEdge(Canvas.Handle,R,EdgeFlag,BF_RECT or BF_MIDDLE );
    R.Left:=Delta-1;
    R.Top:=Delta-1;
    R.Right:=Width-Integer( Delta )+1;
    R.Bottom:=Height-Integer( Delta )+1;
    Canvas.Brush.Color :=clInactiveBorder;
    Canvas.FrameRect(R);
    R.Left:=R.Left+1;
    R.Top:=R.Top+1;
    R.Right:=R.Right-1;
    R.Bottom:=R.Bottom-1;
    Canvas.Brush.Color := Color;
    Canvas.FillRect( R );
  end;

  if ImageListNormal<>nil then
  begin
    TMP:=TBitMap.Create;
    TMP.Width:=ImageListNormal.ImgWidth;
    TMP.Height:=ImageListNormal.ImgHeight;
    TMP.Canvas.CopyRect( Rect(0,0,ImageListNormal.ImgWidth,ImageListNormal.ImgHeight),
                         ImageListNormal.Bitmap.Canvas,
                         Rect( ImageListNormal.ImgWidth*(CurIndex),0,
                               ImageListNormal.ImgWidth*(CurIndex+1),
                               ImageListNormal.ImgHeight));
    {$IFNDEF _D2}
    TMP.Transparent:=True;
    TMP.TransparentColor:=ImageListNormal.TransparentColor;
    {$ENDIF}
    Canvas.Draw(Delta,Delta,TMP);
    TMP.Free;
  end;

  inherited;
end;

function TKOLImageShow.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

procedure TKOLImageShow.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if CurIndex <> 0 then
    //SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( CurIndex ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( CurIndex ) + ') C1 TControl_.SetCurIndex<2>' );
end;

function TKOLImageShow.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.P_SetupParams', 0
  @@e_signature:
  end;
  nparams := 3;
  {Result := AParent + ', ';
  if ImageListNormal <> nil then
  begin
    if ImageListNormal.ParentFORM.Name = ParentForm.Name then
      Result := Result + 'Result.' + ImageListNormal.Name
    else Result := Result + ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end
  else
    Result := Result + 'nil';
  Result := Result + ', ' + IntToStr( CurIndex );}
  {P}Result := ' L(' + IntToStr( CurIndex ) + ')';
  if ImageListNormal <> nil then
    if ImageListNormal.ParentForm.Name = ParentForm.Name then
      Result := Result + ' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
        '.' + ImageListNormal.Name
    else
      Result := Result + ' Load4 ####' + ImageListNormal.ParentForm.Name +
             #13#10' AddWord_LoadRef ##T' + ImageListNormal.ParentKOLForm.FormName +
             '.' + ImageListNormal.Name
  else Result := Result + #13#10' L(0)';
  {P}Result := Result + #13#10' C2';
end;

procedure TKOLImageShow.SetBounds(aLeft, aTop, aWidth, aHeight: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetBounds', 0
  @@e_signature:
  end;
  if (aWidth <> Width) or (aHeight <> Height) then
    AutoSize := FALSE;
  inherited;
  Change;
end;

procedure TKOLImageShow.SetCurIndex(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetCurIndex', 0
  @@e_signature:
  end;
  FCurIndex := Value;
  Change;
  Invalidate;
end;

procedure TKOLImageShow.SetHasBorder(const Value: Boolean);
var WasAuto: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetHasBorder', 0
  @@e_signature:
  end;
  WasAuto := AutoSize;
  inherited;
  AutoSize := WasAuto;
  if AutoSize then DoAutoSize;
  Change;
end;

procedure TKOLImageShow.SetImageListNormal(const Value: TKOLImageList);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetImageListNormal', 0
  @@e_signature:
  end;
  if FImageListNormal <> nil then
    FImageListNormal.NotifyLinkedComponent( Self, noRemoved );
  FImageListNormal := Value;
  if Value <> nil then
  begin
    Value.AddToNotifyList( Self );
    if Value.ImgWidth * Value.ImgHeight > 0 then
    begin
      if AutoSize then
        DoAutoSize;
    end;
  end;
  DoAutoSize;
  Change;
  Invalidate;
end;

procedure TKOLImageShow.SetImgShwAutoSize(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetImgShwAutoSize', 0
  @@e_signature:
  end;
  fImgShwAutoSize := Value;
  //Change;
  if Value then
    DoAutoSize;
end;

procedure TKOLImageShow.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewImageShow', TRUE, TRUE, '' );
    if  CurIndex <> 0 then
    begin
        KF.FormAddCtlCommand( Name, 'FormSetCurIdx', '' );
        KF.FormAddNumParameter( CurIndex );
    end;
end;

procedure TKOLImageShow.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  (KF <> nil) and KF.FormCompact then Exit; {>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>}
  if CurIndex <> 0 then
    SL.Add( Prefix + AName + '.CurIndex := ' + IntToStr( CurIndex ) + '; {SetupFirst}' );
end;

procedure TKOLImageShow.SetupLast(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  KF = nil then Exit;
  if  not KF.FormCompact then Exit;
  if  ImageListNormal <> nil then
      SL.Add( '    Result.' + Name + '.ImageListNormal := ' +
          'Result.' + ImageListNormal.Name + ';' );
end;

function TKOLImageShow.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLImageShow.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ';
  if  (ImageListNormal <> nil) and
      (ParentKOLForm <> nil) and not ParentKOLForm.FormCompact then
  begin
      if ImageListNormal.ParentKOLForm = ParentKOLForm then
        Result := Result + 'Result.' + ImageListNormal.Name
      else Result := Result + ImageListNormal.ParentFORM.Name +'.'+ ImageListNormal.Name;
  end
  else
    Result := Result + 'nil';
  Result := Result + ', ' + IntToStr( CurIndex );
end;

function TKOLImageShow.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLImageShow.WYSIWIGPaintImplemented: Boolean;
begin
  Result := TRUE;
end;

{ TKOLLabelEffect }

function TKOLLabelEffect.AdjustVerticalAlign(
  Value: TVerticalAlign): TVerticalAlign;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.AdjustVerticalAlign', 0
  @@e_signature:
  end;
  Result := Value;
end;

function TKOLLabelEffect.AutoHeight(Canvas: TCanvas): Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.AutoHeight', 0
  @@e_signature:
  end;
  Result := inherited AutoHeight(Canvas);
  if Font.FontOrientation = 0 then Exit;
  try
    Result := Trunc( Result * cos( Font.FontOrientation / 1800 * PI ) +
              inherited AutoWidth(Canvas) * sin( Font.FontOrientation / 1800 * PI ) );
  except
  end;
end;

function TKOLLabelEffect.AutoWidth(Canvas: TCanvas): Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.AutoWidth', 0
  @@e_signature:
  end;
  Result := inherited AutoWidth(Canvas);
  if Font.FontOrientation = 0 then Exit;
  try
    Result := Trunc( Result * cos( Font.FontOrientation / 1800 * PI ) +
              inherited AutoHeight(Canvas) * sin( Font.FontOrientation / 1800 * PI ) );
  except
  end;
end;

constructor TKOLLabelEffect.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.Create', 0
  @@e_signature:
  end;
  inherited;
  //Color := clWindowText;
  fColor2 := clNone;
  Ctl3D := FALSE;
end;

procedure TKOLLabelEffect.Paint;
var
  R:TRect;
  Flag:DWord;
begin

  PrepareCanvasFontForWYSIWIGPaint( Canvas );

  R.Left:=ShadowDeep;
  R.Top:=ShadowDeep;
  R.Right:=Width+ShadowDeep;
  R.Bottom:=Height+ShadowDeep;
  Flag:=0;
  case TextAlign of
    taRight: Flag:=Flag or DT_RIGHT;
    taLeft: Flag:=Flag or DT_LEFT;
    taCenter: Flag:=Flag or DT_CENTER;
  end;

  case VerticalAlign of
    vaTop: Flag:=Flag or DT_TOP or DT_SINGLELINE;
    vaBottom: Flag:=Flag or DT_BOTTOM or DT_SINGLELINE;
    vaCenter: Flag:=Flag or DT_VCENTER or DT_SINGLELINE;
  end;

  if (WordWrap) and (not AutoSize) then
      Flag:=Flag or DT_WORDBREAK and not DT_SINGLELINE;
  Canvas.Font.Color:=Color2;    
  DrawText(Canvas.Handle,PChar(Caption),Length(Caption),R,Flag);

  inherited;

end;

procedure TKOLLabelEffect.P_SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if Color2 <> clNone then
    //SL.Add( Prefix + AName + '.Color2 := ' + Color2Str( Color2 ) + ';' );
    {P}SL.Add( ' L($' + IntToHex( Integer( Color2 ), 6 ) +
       ') C1 TControl_.SetColor2<2>' );
  if Ctl3D then
    //SL.Add( Prefix + AName + '.Ctl3D := TRUE;' );
    {P}SL.Add( ' L(1) C1 TControl_.SetCtl3D<2>' );
end;

function TKOLLabelEffect.P_SetupParams(const AName,
  AParent: String; var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.P_SetupParams', 0
  @@e_signature:
  end;
  //Result := AParent + ', ' + StringConstant('Caption', Caption) + ', ' +
  //          IntToStr( ShadowDeep );
  {P}Result := P_StringConstant( 'Caption', Caption ) +
    #13#10' L(' + IntToStr( ShadowDeep ) + ') xySwap' +
    #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName + '.' +
      Remove_Result_dot( AParent );
  nparams := 3;
end;

procedure TKOLLabelEffect.P_SetupTextAlign(SL: TStrings;
  const AName: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.P_SetupTextAlign', 0
  @@e_signature:
  end;
  if TextAlign <> taCenter then
    //SL.Add( '    ' + AName + '.TextAlign := ' + TextAligns[ TextAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( Integer( TextAlign ) ) + ') ' +
      ' C1 TControl_.SetTextAlign<2>' );
  if VerticalAlign <> vaTop then
    //SL.Add( '    ' + AName + '.VerticalAlign := ' + VertAligns[ VerticalAlign ] + ';' );
    {P}SL.Add( ' L(' + IntToStr( VerticalAlignAsKOLVerticalAlign ) + ') ' +
      ' C1 TControl_.SetVerticalAlign<2>' );
end;

procedure TKOLLabelEffect.SetColor2(const Value: TColor);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetColor2', 0
  @@e_signature:
  end;
  FColor2 := Value;
  Change;
  Invalidate;
end;

procedure TKOLLabelEffect.SetShadowDeep(const Value: Integer);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetShadowDeep', 0
  @@e_signature:
  end;
  FShadowDeep := Value;
  Change;
  Invalidate;
end;

procedure TKOLLabelEffect.SetupConstruct_Compact;
var KF: TKOLForm;
    C: String;
begin
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddCtlParameter( Name );
    KF.FormCurrentCtlForTransparentCalls := Name;
    KF.FormAddAlphabet( 'FormNewLabelEffect', TRUE, TRUE, '' );
    C := Caption;
    if  not KF.AssignTextToControls then
        C := '';
    KF.FormAddStrParameter( C );
    KF.FormAddNumParameter( ShadowDeep );
end;

procedure TKOLLabelEffect.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
    C: DWORD;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  Color2 <> clNone then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetColor2', '' );
          C := Color2;
          if  C and $FF000000 = $FF000000 then
              C := C and $FFFFFF or $80000000;
          C := (C shl 1) or (C shr 31);
          RptDetailed( 'Prepare FormSetColor parameter, src color =$' +
              Int2Hex( Color2, 2 ) + ', coded color =$' +
              Int2Hex( C, 2 ), CYAN );
          KF.FormAddNumParameter( C );
      end else
      SL.Add( Prefix + AName + '.Color2 := TColor(' + Color2Str( Color2 ) + ');' );

  if  Ctl3D then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'TControl.SetCtl3D', '' );
          // param = 1
      end else
      SL.Add( Prefix + AName + '.Ctl3D := TRUE;' );
end;

function TKOLLabelEffect.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var
{$IFDEF _D2009orHigher}
  C, C2: WideString;
 i : integer;
{$ELSE}
  C: string;
{$ENDIF}
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetupParams', 0
  @@e_signature:
  end;
 if  (ParentKOLForm <> nil) and ParentKOLForm.AssignTextToControls then
     C := StringConstant('Caption', Caption )
 else
     C := '''''';
{$IFDEF _D2009orHigher}
 if C <> '''''' then
  begin
   C2 := '';
   for i := 2 to Length(C) - 1 do C2 := C2 + '#'+int2str(ord(C[i]));
   C := C2;
  end;
{$ENDIF}
 Result := AParent + ', ' + C + ', ' +  IntToStr( ShadowDeep );
end;

procedure TKOLLabelEffect.SetupTextAlign(SL: TStrings;
  const AName: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLLabelEffect.SetupTextAlign', 0
  @@e_signature:
  end;
  KF := ParentKOLForm;
  if  TextAlign <> taCenter then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTextAlign', '' );
          KF.FormAddNumParameter( Integer( TextAlign ) );
      end else
      SL.Add( '    ' + AName + '.TextAlign := KOL.' + TextAligns[ TextAlign ] + ';' );

  if  VerticalAlign <> vaTop then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetTextVAlign', '' );
          KF.FormAddNumParameter( Integer( VerticalAlign ) );
      end else
      SL.Add( '    ' + AName + '.VerticalAlign := KOL.' + VertAligns[ VerticalAlign ] + ';' );
end;

procedure TKOLLabelEffect.SetWindowed(const Value: Boolean);
begin
   inherited SetWindowed( TRUE );
end;

function TKOLLabelEffect.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

{ TKOLScrollBox }

constructor TKOLScrollBox.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.Create', 0
  @@e_signature:
  end;
  inherited;
  FEdgeStyle := esLowered;
  FScrollBars := ssBoth;
  ControlStyle := ControlStyle + [ csAcceptsControls ];
  FHasScrollbarsToOverride := TRUE;
end;

function TKOLScrollBox.IsControlContainer: Boolean;
var I: Integer;
    C: TComponent;
    K: TControl;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.IsControlContainer', 0
  @@e_signature:
  end;
  Result := ControlContainer;
  if Result then Exit;
  if Owner = nil then Exit;
  for I := 0 to Owner.ComponentCount - 1 do
  begin
    C := Owner.Components[ I ];
    if C is TControl then
    begin
      K := C as TControl;
      if K.Parent = Self then
      begin
        Result := TRUE;
        Exit;
      end;
    end;
  end;
end;

function TKOLScrollBox.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLScrollBox.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
//var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.P_SetupParams', 0
  @@e_signature:
  end;
  {Result := AParent + ', ' + EdgeStyles[ EdgeStyle ];
  if not IsControlContainer then
  begin
    S := '';
    case ScrollBars of
    ssHorz: S := 'sbHorizontal';
    ssVert: S := 'sbVertical';
    ssBoth: S := 'sbHorizontal, sbVertical';
    end;
    Result := Result + ', [ ' + S + ' ]';
  end;}
  nparams := 2;
  Result := ' DUP C2R';
  if not IsControlContainer then
  begin
    nparams := 3;
    {P}Result := Result + #13#10' L(' + IntToStr( PByte( @ ScrollBars )^ ) + ')';
  end;
  {P}Result := Result + #13#10' L(' + IntToStr( PByte( @ EdgeStyle )^ ) + ')' +
    ' R2C';
end;

procedure TKOLScrollBox.SetControlContainer(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetControlContainer', 0
  @@e_signature:
  end;
  FControlContainer := Value;
  Change;
end;

procedure TKOLScrollBox.SetEdgeStyle(const Value: TEdgeStyle);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetEdgeStyle', 0
  @@e_signature:
  end;
  FEdgeStyle := Value;
  ReAlign( FALSE );
  Change;
end;

procedure TKOLScrollBox.SetScrollBars(const Value: TScrollBars);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetScrollBars', 0
  @@e_signature:
  end;
  FScrollBars := Value;
  Change;
end;

procedure TKOLScrollBox.SetupConstruct_Compact;
var KF: TKOLForm;
    i: Integer;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNew' + TypeName, TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( EdgeStyle ) );
    if  TypeName = 'ScrollBox' then
    begin
        CASE ScrollBars OF
        ssNone:   i := 0;
        ssHorz:   i := 1;
        ssVert:   i := 2;
        else      i := 3;
        END;
        KF.FormAddNumParameter( i );
    end;
end;

function TKOLScrollBox.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
const EdgeStyles: array[ TEdgeStyle ] of String =
  ( 'esRaised', 'esLowered', 'esNone', 'esTransparent', 'esSolid' );
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + EdgeStyles[ EdgeStyle ];
  if not IsControlContainer then
  begin
    S := '';
    case ScrollBars of
    ssHorz: S := 'sbHorizontal';
    ssVert: S := 'sbVertical';
    ssBoth: S := 'sbHorizontal, sbVertical';
    end;
    Result := Result + ', [ ' + S + ' ]';
  end;
end;

function TKOLScrollBox.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLScrollBox.TypeName: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBox.TypeName', 0
  @@e_signature:
  end;
  Result := inherited TypeName;
  if  IsControlContainer then
      Result := 'ScrollBoxEx';
end;

{ TKOLMDIClient }

var MDIWarningLastTime: Integer;
procedure MDIClientMustBeAChildOfTheFormWarning;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'MDIClientMustBeAChildOfTheFormWarning', 0
  @@e_signature:
  end;
  if Abs( Integer( GetTickCount ) - MDIWarningLastTime ) > 60000 then
  begin
    MDIWarningLastTime := GetTickCount;
    ShowMessage( 'TKOLMDIClient control must be a child of the form itself!'#13 +
                 'Otherwise maximizing of MDI children will lead to access violation ' +
                 'at run-time execution.' );
  end;
end;

procedure MsgDuplicatedMDIClient;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'MsgDuplicatedMDIClient', 0
  @@e_signature:
  end;
  if Abs( Integer( GetTickCount ) - MDIWarningLastTime ) > 60000 then
  begin
    MDIWarningLastTime := GetTickCount;
    ShowMessage( 'TKOLMDIClient control must be a single on the form, ' +
                 'but another instance of MDI client object found there.' );
  end;
end;

constructor TKOLMDIClient.Create(AOwner: TComponent);
var I: Integer;
    C: TComponent;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.Create', 0
  @@e_signature:
  end;
  inherited;
  Align := caClient;
  if (AOwner <> nil) and (AOwner is TForm) then
  begin
    for I := 0 to (AOwner as TForm).ComponentCount-1 do
    begin
      C := (AOwner as TForm).Components[ I ];
      if C = Self then continue;
      if C is TKOLMDIClient then
      begin
        MsgDuplicatedMDIClient;
        break;
      end;
    end;
  end;
  FTimer := TTimer.Create( Self );
  FTimer.Interval := 200;
  FTimer.OnTimer := Tick;
  FTimer.Enabled := TRUE;
  FHasScrollbarsToOverride := TRUE;
end;

destructor TKOLMDIClient.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.Destroy', 0
  @@e_signature:
  end;
  inherited;
  MDIWarningLastTime := 0;
end;

function TKOLMDIClient.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLMDIClient.P_SetupParams(const AName, AParent: String; var nparams: Integer): String;

  function FindWindowMenu( MI: TKOLMenuItem ): Integer;
  var I: Integer;
      SMI: TKOLMenuItem;
  begin
    Result := 0;
    if MI.WindowMenu then
      Result := MI.itemindex
    else
    for I := 0 to MI.Count-1 do
    begin
      SMI := MI.SubItems[ I ];
      Result := FindWindowMenu( SMI );
      if Result > 0 then
        break;
    end;
  end;

var I, J, WM: Integer;
    C: TComponent;
    MM: TKOLMainMenu;
    MI: TKOLMenuItem;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.P_SetupParams', 0
  @@e_signature:
  end;
    //Result := AParent + ', ';
    S := ' L(0)';
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      C := (Owner as TForm).Components[ I ];
      if C is TKOLMainMenu then
      begin
        MM := C as TKOLMainMenu;
        for J := 0 to MM.Count-1 do
        begin
          MI := MM.Items[ J ];
          WM := FindWindowMenu( MI );
          if WM > 0 then
          begin
            //S := 'Result.' + MM.Name + '.ItemHandle[ ' + IntToStr( WM ) + ' ]';
            {P}S := ' L(' + IntToStr( WM ) +
              ') LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
              '.' + MM.Name + ' TMenu.GetMenuItemHandle<2> RESULT';
            break;
          end;
        end;
        break;
      end;
    end;
    //Result := Result + S;
    {P}Result := S +
      #13#10' LoadSELF AddWord_LoadRef ##T' + ParentKOLForm.FormName +
      '.' + Remove_Result_dot( AParent );
    nparams := 2;
end;

function TKOLMDIClient.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;

  function FindWindowMenu( MI: TKOLMenuItem ): Integer;
  var I: Integer;
      SMI: TKOLMenuItem;
  begin
    Result := 0;
    if MI.WindowMenu then
      Result := MI.itemindex
    else
    for I := 0 to MI.Count-1 do
    begin
      SMI := MI.SubItems[ I ];
      Result := FindWindowMenu( SMI );
      if Result > 0 then
        break;
    end;
  end;

var I, J, WM: Integer;
    C: TComponent;
    MM: TKOLMainMenu;
    MI: TKOLMenuItem;
    S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.SetupParams', 0
  @@e_signature:
  end;
    Result := AParent + ', ';
    S := '0';
    for I := 0 to (Owner as TForm).ComponentCount-1 do
    begin
      C := (Owner as TForm).Components[ I ];
      if C is TKOLMainMenu then
      begin
        MM := C as TKOLMainMenu;
        for J := 0 to MM.Count-1 do
        begin
          MI := MM.Items[ J ];
          WM := FindWindowMenu( MI );
          if WM > 0 then
          begin
            S := 'Result.' + MM.Name + '.ItemHandle[ ' +
                 IntToStr( WM ) + ' ]';
            break;
          end;
        end;
        break;
      end;
    end;
    Result := Result + S;
end;

procedure TKOLMDIClient.Tick(Sender: TObject);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLMDIClient.Tick', 0
  @@e_signature:
  end;
  if Parent <> nil then
  begin
    FTimer.Enabled := FALSE;
    if Parent <> Owner then
      MDIClientMustBeAChildOfTheFormWarning
    else
      ParentKOLForm.AlignChildren( nil, FALSE );
    FTimer.Free;
    FTimer := nil;
  end;
end;

{ TKOLToolbarButton }

procedure TKOLToolbarButton.Change;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Change', 0
  @@e_signature:
  end;
  if csLoading in ComponentState then Exit;
  if FToolbar <> nil then begin
    FToolbar.UpdateButtons;
    FToolbar.Change;
  end;
end;

constructor TKOLToolbarButton.Create(AOwner: TComponent);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Create', 0
  @@e_signature:
  end;
  inherited;
  if AOwner <> nil then
  if AOwner is TKOLToolbar then
  begin
    FToolbar := AOwner as TKOLToolbar;
    FToolbar.FItems.Add( Self );
  end;
  Fpicture := TPicture.Create;
  Fvisible := TRUE;
  Fenabled := TRUE;
  FimgIndex := -1;
end;

procedure TKOLToolbarButton.DefProps(const Prefix: String; Filer: Tfiler);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.DefProps', 0
  @@e_signature:
  end;
  Filer.DefineProperty( Prefix + 'Name', LoadName, SaveName, TRUE );
  Filer.DefineProperty( Prefix + 'caption', LoadCaption, SaveCaption, TRUE );
  Filer.DefineProperty( Prefix + 'checked', LoadChecked, SaveChecked, TRUE );
  Filer.DefineProperty( Prefix + 'dropdown', LoadDropDown, SaveDropDown, TRUE );
  Filer.DefineProperty( Prefix + 'enabled', LoadEnabled, SaveEnabled, TRUE );
  Filer.DefineProperty( Prefix + 'separator', LoadSeparator, SaveSeparator, TRUE );
  Filer.DefineProperty( Prefix + 'tooltip', LoadTooltip, SaveTooltip, TRUE );
  Filer.DefineProperty( Prefix + 'visible', LoadVisible, SaveVisible, TRUE );
  Filer.DefineProperty( Prefix + 'onClick', LoadOnClick, SaveOnClick, TRUE );
  Filer.DefineProperty( Prefix + 'picture', LoadPicture, SavePicture, TRUE );
  Filer.DefineProperty( Prefix + 'sysimg', LoadSysImg, SaveSysImg, TRUE );
  Filer.DefineProperty( Prefix + 'radioGroup', LoadRadioGroup, SaveRadioGroup, radioGroup <> 0 );
  Filer.DefineProperty( Prefix + 'imgIndex', LoadImgIndex, SaveImgIndex, imgIndex >= 0 );
end;

destructor TKOLToolbarButton.Destroy;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Destroy', 0
  @@e_signature:
  end;
  if FToolbar <> nil then
    FToolbar.FItems.Remove( Self );
  Fpicture.Free;
  inherited;
end;

function TKOLToolbarButton.HasPicture: Boolean;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.HasPicture', 0
  @@e_signature:
  end;
  {if Assigned( picture ) then
    Rpt( '%%%%%%%% ' + Name + '.picture: Width=' + IntToStr( picture.Width ) +
         ' Height=' + IntToStr( picture.Height ) );}
  Result := Assigned( picture ) and (picture.Width * picture.Height > 0);
end;

procedure TKOLToolbarButton.LoadCaption(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadCaption', 0
  @@e_signature:
  end;
  Fcaption := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadChecked(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadChecked', 0
  @@e_signature:
  end;
  Fchecked := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadDropDown(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadDropDown', 0
  @@e_signature:
  end;
  Fdropdown := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadEnabled(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadEnabled', 0
  @@e_signature:
  end;
  Fenabled := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadImgIndex(Reader: TReader);
begin
  FimgIndex := Reader.ReadInteger;
end;

procedure TKOLToolbarButton.LoadName(Reader: TReader);
var S: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadName', 0
  @@e_signature:
  end;
  S := Reader.ReadString;
  if FToolbar = nil then Exit;
  if FToolbar.FindComponent( S ) <> nil then Exit;
  if (FToolbar.Owner <> nil) and (FToolbar.Owner is TForm) then
  begin
    if (FToolbar.Owner as TForm).FindComponent( S ) <> nil then Exit;
    Name := S;
  end;
end;

procedure TKOLToolbarButton.LoadOnClick(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadOnClick', 0
  @@e_signature:
  end;
  fOnClickMethodName := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadPicture(Reader: TReader);
var S: String;
    MS: TMemoryStream;
    Bmp: TBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadPicture', 0
  @@e_signature:
  end;
  S := Reader.ReadString;
  //ShowMessage( 'Read picture: <' + S + '>' );
  if Trim( S ) <> '' then
  begin
    MS := TMemoryStream.Create;
    TRY
      MS.Write( S[ 1 ], Length( S ) );
      MS.Position := 0;
      Bmp := TBitmap.Create;
      TRY
        Bmp.LoadFromStream( MS );
        Fpicture.Assign( Bmp );
      FINALLY
        Bmp.Free;
      END;
    FINALLY
      MS.Free;
    END;
  end;
  //ShowMessage( 'Read picture - end' );
end;

procedure TKOLToolbarButton.LoadProps(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadProps', 0
  @@e_signature:
  end;
  Fcaption := Reader.ReadString;
  Fchecked := Reader.ReadBoolean;
  Fdropdown := Reader.ReadBoolean;
  Fenabled := Reader.ReadBoolean;
  Fseparator := Reader.ReadBoolean;
  Ftooltip := Reader.ReadString;
  Fvisible := Reader.ReadBoolean;
  fOnClickMethodName := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadRadioGroup(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadRadioGroup', 0
  @@e_signature:
  end;
  FradioGroup := Reader.ReadInteger;
end;

procedure TKOLToolbarButton.LoadSeparator(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadSeparator', 0
  @@e_signature:
  end;
  Fseparator := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.LoadSysImg(Reader: TReader);
begin
  Fsysimg := TSystemToolbarImage( Reader.ReadInteger );
end;

procedure TKOLToolbarButton.LoadTooltip(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadTooltip', 0
  @@e_signature:
  end;
  Ftooltip := Reader.ReadString;
end;

procedure TKOLToolbarButton.LoadVisible(Reader: TReader);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.LoadVisible', 0
  @@e_signature:
  end;
  Fvisible := Reader.ReadBoolean;
end;

procedure TKOLToolbarButton.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited;
  if Operation = opRemove then
    if AComponent = Faction then begin
      Faction.UnLinkComponent(Self);
      Faction := nil;
    end;
end;

procedure TKOLToolbarButton.SaveCaption(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveCaption', 0
  @@e_signature:
  end;
  Writer.WriteString( Fcaption );
end;

procedure TKOLToolbarButton.SaveChecked(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveChecked', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fchecked );
end;

procedure TKOLToolbarButton.SaveDropDown(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveDropDown', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fdropdown );
end;

procedure TKOLToolbarButton.SaveEnabled(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveEnabled', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fenabled );
end;

procedure TKOLToolbarButton.SaveImgIndex(Writer: TWriter);
begin
  Writer.WriteInteger( FimgIndex );
end;

procedure TKOLToolbarButton.SaveName(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveName', 0
  @@e_signature:
  end;
  Writer.WriteString( Name );
end;

procedure TKOLToolbarButton.SaveOnClick(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveOnClick', 0
  @@e_signature:
  end;
  Writer.WriteString( fOnClickMethodName );
end;

procedure TKOLToolbarButton.SavePicture(Writer: TWriter);
var S: String;
    MS: TMemoryStream;
    Bmp: TBitmap;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SavePicture', 0
  @@e_signature:
  end;
  MS := TMemoryStream.Create;
  TRY
    S := '';
    if Assigned( picture ) and (picture.Width * picture.Height > 0) then
    begin
      Bmp := TBitmap.Create;
      TRY
        Bmp.Assign( picture.Graphic );
        Bmp.SaveToStream( MS );
      FINALLY
        Bmp.Free;
      END;
      SetLength( S, MS.Size );
      Move( MS.Memory^, S[ 1 ], MS.Size );
    end;
    Writer.WriteString( S );
  FINALLY
    MS.Free;
  END;
end;

procedure TKOLToolbarButton.SaveProps(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveProps', 0
  @@e_signature:
  end;
  Writer.WriteString( Fcaption );
  Writer.WriteBoolean( Fchecked );
  Writer.WriteBoolean( Fdropdown );
  Writer.WriteBoolean( Fenabled );
  Writer.WriteBoolean( Fseparator );
  Writer.WriteString( Ftooltip );
  Writer.WriteBoolean( Fvisible );
  Writer.WriteString( fOnClickMethodName );
end;

procedure TKOLToolbarButton.SaveRadioGroup(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveRadioGroup', 0
  @@e_signature:
  end;
  Writer.WriteInteger( FradioGroup );
end;

procedure TKOLToolbarButton.SaveSeparator(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveSeparator', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fseparator );
end;

procedure TKOLToolbarButton.SaveSysImg(Writer: TWriter);
begin
  Writer.WriteInteger( Integer( Fsysimg ) );
end;

procedure TKOLToolbarButton.SaveTooltip(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveTooltip', 0
  @@e_signature:
  end;
  Writer.WriteString( Ftooltip );
end;

procedure TKOLToolbarButton.SaveVisible(Writer: TWriter);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SaveVisible', 0
  @@e_signature:
  end;
  Writer.WriteBoolean( Fvisible );
end;

procedure TKOLToolbarButton.Setaction(const Value: TKOLAction);
begin
  if Faction = Value then exit;
  if Faction <> nil then
    Faction.UnLinkComponent(Self);
  Faction := Value;
  if Faction <> nil then
    Faction.LinkComponent(Self);
  Change;
end;

procedure TKOLToolbarButton.Setcaption(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setcaption', 0
  @@e_signature:
  end;
  if Fcaption = Value then Exit;
  if Faction = nil then
    Fcaption := Value
  else
    Fcaption:=Faction.Caption;
  if Fcaption <> '-' then
    Fseparator := FALSE;
  Change;
end;

procedure TKOLToolbarButton.SetCheckable(const Value: Boolean);
begin
    ShowMessage( 'Jus change property radioGroup!' )
end;

procedure TKOLToolbarButton.Setchecked(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setchecked', 0
  @@e_signature:
  end;
  if FChecked = Value then Exit;
  if Faction = nil then
    FChecked := Value
  else
    FChecked:=Faction.Checked;
  Change;
end;

procedure TKOLToolbarButton.Setdropdown(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setdropdown', 0
  @@e_signature:
  end;
  if Fdropdown = Value then Exit;
  Fdropdown := Value;
  Change;
end;

procedure TKOLToolbarButton.Setenabled(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setenabled', 0
  @@e_signature:
  end;
  if Fenabled = Value then Exit;
  if Faction = nil then
    Fenabled := Value
  else
    Fenabled:=Faction.Enabled;
  Change;
end;

procedure TKOLToolbarButton.SetimgIndex(const Value: Integer);
begin
  if Fseparator then
    FimgIndex := -1
  else
    FimgIndex := Value;
  Change;
end;

procedure TKOLToolbarButton.SetName(const NewName: TComponentName);
var OldName, NewMethodName: String;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SetName', 0
  @@e_signature:
  end;
  OldName := Name;
  //Rpt( 'Renaming ' + OldName + ' to ' + NewName );
  if (FToolbar <> nil) and (OldName <> '') and
     (FToolbar.FindComponent( NewName ) <> nil) then
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
  if fOnClickMethodName <> '' then
  if FToolbar <> nil then
  begin
    if LowerCase( FToolbar.Name + OldName + 'Click' ) = LowerCase( fOnClickMethodName ) then
    begin
      // rename event handler also here:
      F := FToolbar.ParentForm;
      NewMethodName := FToolbar.Name + NewName + 'Click';
      if F <> nil then
      begin
  {$IFDEF _D6orHigher}
        F.Designer.QueryInterface(IFormDesigner,D);
  {$ELSE}
        D := F.Designer;
  {$ENDIF}
        if D <> nil then
        if QueryFormDesigner( D, FD ) then
        begin
          if not FD.MethodExists( NewMethodName ) then
          begin
            FD.RenameMethod( fOnClickMethodName, NewMethodName );
            if FD.MethodExists( NewMethodName ) then
              fOnClickMethodName := NewMethodName;
          end;
        end;
      end;
    end;
  end;
  Change;
end;

procedure TKOLToolbarButton.SetonClick(const Value: TOnToolbarButtonClick);
var F: TForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.SetOnClick', 0
  @@e_signature:
  end;
  if @ fOnClick = @ Value then Exit;
  FonClick := Value;
  if TMethod( Value ).Code <> nil then
  begin
    if FToolbar <> nil then
    begin
      F := FToolbar.ParentForm;
      fOnClickMethodName := F.MethodName( TMethod( Value ).Code );
    end;
  end
    else
    FOnClickMethodName := '';
  Change;
end;

procedure TKOLToolbarButton.Setpicture(Value: TPicture);
var Bmp: TBitmap;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setpicture', 0
  @@e_signature:
  end;
  if Value <> nil then
    if Value.Width * Value.Height = 0 then
      Value := nil;
  if Value = nil then
  begin
    Fpicture.Free;
    Fpicture := TPicture.Create;
  end
    else
  begin
    if FToolbar.ImageListsUsed then
    begin
      I := MessageBox( Application.Handle, 'Image list(s) will be detached from the toolbar.'#13#10 +
        'Continue?', PChar( Application.Title + ' : ' + Name ), MB_OKCANCEL );
      if I <> ID_OK then Exit;
      FToolbar.imageListNormal := nil;
      FToolbar.imageListDisabled := nil;
      FToolbar.imageListHot := nil;
    end;
    Bmp := TBitmap.Create;
    TRY
      Bmp.Width := Value.Width;
      Bmp.Height := Value.Height;
      if Value.Graphic is TIcon then
      begin
        Bmp.Canvas.Brush.Color := clSilver;
        Bmp.Canvas.FillRect( Rect( 0, 0, Bmp.Width, Bmp.Height ) );
        Bmp.Canvas.Draw( 0, 0, Value.Graphic );
      end
        else
      Bmp.Assign( Value.Graphic );
      Fpicture.Assign( Bmp );
    FINALLY
      Bmp.Free;
    END;
    Fseparator := False;
  end;
  FToolbar.AssembleBitmap;
  if Assigned(FToolbar.FKOLCtrl) then
    FToolbar.RecreateWnd;
  Change;
end;

procedure TKOLToolbarButton.SetradioGroup(const Value: Integer);
var I, J: Integer;
    AlreadyPresent, TheSameBefore, TheSameAfter: Boolean;
    Bt: TKOLToolbarButton;
begin
  if Value = FradioGroup then Exit;
  I := FToolbar.Items.IndexOf( Self );
  if I < 0 then Exit;
  if Value <> 0 then
  begin
    AlreadyPresent := FALSE;
    for J := 0 to FToolbar.Items.Count-1 do
    begin
      if I = J then continue;
      Bt := FToolbar.Items[ J ];
      if Bt.FradioGroup = Value then
      begin
        AlreadyPresent := TRUE;
        break;
      end;
    end;
    if AlreadyPresent then
    begin
      TheSameBefore := FALSE;
      TheSameAfter := FALSE;
      if (I > 0) then
      begin
        Bt := FToolbar.Items[ I - 1 ];
        if not Bt.separator and (Bt.FradioGroup = Value) then
          TheSameBefore := TRUE;
      end;
      if (I < FToolbar.Items.Count-1) then
      begin
        Bt := FToolbar.Items[ I + 1 ];
        if not Bt.separator and (Bt.FradioGroup = Value) then
          TheSameAfter := TRUE;
      end;
      if not (TheSameBefore or TheSameAfter) then Exit;
    end;
  end;
  FradioGroup := Value;
  Change;
end;

procedure TKOLToolbarButton.Setseparator(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setseparator', 0
  @@e_signature:
  end;
  if Fseparator = Value then Exit;
  Fseparator := Value;
  if Value then
  begin
    Fcaption := '-';
    FimgIndex := -1;
  end;
  Change;
end;

procedure TKOLToolbarButton.Setsysimg(const Value: TSystemToolbarImage);
var I: Integer;
begin
  if Value <> stiCustom then
  begin
    if (FToolbar.ImageListNormal <> nil) or
       (FToolbar.ImageListDisabled <> nil) or
       (FToolbar.ImageListHot <> nil) then
    begin
      I := MessageBox( Application.Handle, 'Image list(s) will be detached from ' +
        'the toolbar. Continue?', PChar( Application.Title + ' : ' + Name ),
        MB_OKCANCEL );
      if I <> ID_OK then Exit;
      FToolbar.ImageListNormal := nil;
      FToolbar.ImageListDisabled := nil;
      FToolbar.ImageListHot := nil;
    end;
    picture := nil;
  end;
  Fsysimg := Value;
  if Assigned(FToolbar.FKOLCtrl) then
    FToolbar.RecreateWnd;
  Change;
end;

procedure TKOLToolbarButton.Settooltip(const Value: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Settooltip', 0
  @@e_signature:
  end;
  if Ftooltip = Value then Exit;
  if Faction = nil then
    Ftooltip := Value
  else
    Ftooltip:=Faction.Hint;
  if FToolbar <> nil then
    FToolbar.AssembleTooltips;
  Change;
end;

procedure TKOLToolbarButton.Setvisible(const Value: Boolean);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButton.Setvisible', 0
  @@e_signature:
  end;
  if Fvisible = Value then Exit;
  if Faction = nil then
    Fvisible := Value
  else
    Fvisible:=Faction.Visible;
  Change;
end;

{ TKOLToolButtonOnClickPropEditor }

function TKOLToolButtonOnClickPropEditor.GetValue: string;
var Comp: TPersistent;
    F: TForm;
    D: IDesigner;
    FD: IFormDesigner;
    Orig: String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonOnClickPropEditor.GetValue', 0
  @@e_signature:
  end;
  if FResetting then
  begin
    Result := '';
    Exit;
  end;
  Result := inherited GetValue;
  Orig := Result;
  //**Windows.Beep( 100, 100 );
  if Result = '' then
  begin
    Comp := GetComponent( 0 );
    if Comp <> nil then
    if Comp is TKOLToolbarButton then
    begin
      Result := (Comp as TKOLToolbarButton).FOnClickMethodName;
    end;
  end;
  //**Windows.Beep( 200, 100 );
  TRY

  Comp := GetComponent( 0 );
  if (Comp <> nil) and
     (Comp is TKOLToolbarButton) and
     ((Comp as TKOLToolbarButton).FToolbar <> nil) then
  begin
    F := (Comp as TKOLToolbarButton).FToolbar.ParentForm;
    if (F = nil) or (F.Designer = nil) then
    begin
      Result := ''; Exit;
    end;
  {$IFDEF _D6orHigher}
        F.Designer.QueryInterface(IFormDesigner,D);
  {$ELSE}
        D := F.Designer;
  {$ENDIF}
    if (D <> nil) and QueryFormDesigner( D, FD ) then
    begin
      if not FD.MethodExists( Result ) then Result := '';
    end
      else Result := '';
  end
    else Result := '';
  //**Windows.Beep( 200, 100 );
  if (Result = '') and (Orig <> '') then
  begin
    FResetting := TRUE;
    TRY
      //Windows.Beep( 100, 200 );
      SetValue( '' );
    FINALLY
      FResetting := FALSE;
    END;
  end;

  EXCEPT
    Rpt( 'Exception while retrieving property onClick for TKOLToolbarButton', RED );
  END;
end;

procedure TKOLToolButtonOnClickPropEditor.SetValue(const AValue: string);
var Comp: TPersistent;
    I: Integer;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLToolbarButtonOnClickPropEditor.SetValue', 0
  @@e_signature:
  end;
  inherited;
  for I := 0 to PropCount - 1 do
  begin
    Comp := GetComponent( I );
    if Comp <> nil then
    if Comp is TKOLToolbarButton then
    begin
      (Comp as TKOLToolbarButton).FOnClickMethodName := AValue;
      (Comp as TKOLToolbarButton).Change;
    end;
  end;
end;

{ TKOLListViewColumn }

procedure TKOLListViewColumn.Change;
begin
  if Assigned( FListView ) then begin
    FListView.UpdateColumns; {YS}
    FListView.Change;
  end;
end;

constructor TKOLListViewColumn.Create(AOwner: TComponent);
begin
  inherited;
  FLVColOrder := -1;
  FLVColImage := -1;
  if AOwner <> nil then
  if AOwner is TKOLListView then
  begin
    FListView := AOwner as TKOLListView;
    FListView.Cols.Add( Self );
    {ShowMessage( 'Parent FListView=' + Int2Hex( DWORD( FListView ), 8 ) + ', ' +
                 FListView.Name );}
  end;
  FWidth := 50;
end;

procedure TKOLListViewColumn.DefProps(const Prefix: String; Filer: TFiler);
begin
  Filer.DefineProperty( Prefix + 'Name', LoadName, SaveName, True );
  Filer.DefineProperty( Prefix + 'Caption', LoadCaption, SaveCaption, True );
  Filer.DefineProperty( Prefix + 'TextAlign', LoadTextAlign, SaveTextAlign, True );
  Filer.DefineProperty( Prefix + 'Width', LoadWidth, SaveWidth, True );
  Filer.DefineProperty( Prefix + 'WidthType', LoadWidthType, SaveWidthType, True );
  Filer.DefineProperty( Prefix + 'LVColImage', LoadLVColImage, SaveLVColImage, True );
  Filer.DefineProperty( Prefix + 'LVColOrder', LoadLVColOrder, SaveLVColOrder, LVColOrder >= 0 );
  Filer.DefineProperty( Prefix + 'LVColRightImg', LoadLVColRightImg, SaveLVColRightImg, LVColRightImg );
end;

destructor TKOLListViewColumn.Destroy;
begin
  if FListView <> nil then
  begin
    FListView.FCols.Remove( Self );
    FListView.UpdateColumns;
    FListView.Change;
  end;
  inherited;
end;

procedure TKOLListViewColumn.LoadCaption(Reader: TReader);
begin
  fCaption := Reader.ReadString;
end;

procedure TKOLListViewColumn.LoadLVColImage(Reader: TReader);
begin
  FLVColImage := Reader.ReadInteger;
end;

procedure TKOLListViewColumn.LoadLVColOrder(Reader: TReader);
begin
  LVColOrder := Reader.ReadInteger;
end;

procedure TKOLListViewColumn.LoadLVColRightImg(Reader: TReader);
begin
  FLVColRightImg := Reader.ReadBoolean;
end;

procedure TKOLListViewColumn.LoadName(Reader: TReader);
begin
  Name := Reader.ReadString;
end;

procedure TKOLListViewColumn.LoadTextAlign(Reader: TReader);
begin
  FTextAlign := TTextAlign( Reader.ReadInteger );
end;

procedure TKOLListViewColumn.LoadWidth(Reader: TReader);
begin
  FWidth := Reader.ReadInteger;
end;

procedure TKOLListViewColumn.LoadWidthType(Reader: TReader);
begin
  FWidthType := TKOLListViewColWidthType( Reader.ReadInteger );
end;

procedure TKOLListViewColumn.SaveCaption(Writer: TWriter);
begin
  Writer.WriteString( fCaption );
end;

procedure TKOLListViewColumn.SaveLVColImage(Writer: TWriter);
begin
  Writer.WriteInteger( FLVColImage );
end;

procedure TKOLListViewColumn.SaveLVColOrder(Writer: TWriter);
begin
  Writer.WriteInteger( FLVColOrder );
end;

procedure TKOLListViewColumn.SaveLVColRightImg(Writer: TWriter);
begin
  Writer.WriteBoolean( FLVColRightImg );
end;

procedure TKOLListViewColumn.SaveName(Writer: TWriter);
begin
  Writer.WriteString( Name );
end;

procedure TKOLListViewColumn.SaveTextAlign(Writer: TWriter);
begin
  Writer.WriteInteger( Integer( FTextAlign ) );
end;

procedure TKOLListViewColumn.SaveWidth(Writer: TWriter);
begin
  Writer.WriteInteger( FWidth );
end;

procedure TKOLListViewColumn.SaveWidthType(Writer: TWriter);
begin
  Writer.WriteInteger( Integer( FWidthType ) );
end;

procedure TKOLListViewColumn.SetCaption(const Value: String);
begin
  FCaption := Value;
  Change;
end;

procedure TKOLListViewColumn.SetLVColImage(const Value: Integer);
begin
  FLVColImage := Value;
  Change;
end;

procedure TKOLListViewColumn.SetLVColOrder(const Value: Integer);
var I: Integer;
    Col: TKOLListViewColumn;
begin
  if FListView <> nil then
  begin
    for I := 0 to FListView.Cols.Count-1 do
    begin
      Col := FListView.Cols[ I ];
      if Col = Self then continue;
      if Col.FLVColOrder > FLVColOrder then
        Dec( Col.FLVColOrder );
    end;
    if Value >= 0 then
    for I := 0 to FListView.Cols.Count-1 do
    begin
      Col := FListView.Cols[ I ];
      if Col = Self then continue;
      if Col.FLVColOrder >= Value then
        Inc( Col.FLVColOrder );
    end;
  end;
  FLVColOrder := Value;
  Change;
end;

procedure TKOLListViewColumn.SetLVColRightImg(const Value: Boolean);
begin
  FLVColRightImg := Value;
  Change;
end;

procedure TKOLListViewColumn.SetName(const AName: TComponentName);
begin
  inherited;
  Change;
end;

procedure TKOLListViewColumn.SetTextAlign(const Value: TTextAlign);
begin
  FTextAlign := Value;
  Change;
end;

procedure TKOLListViewColumn.SetWidth(const Value: Integer);
begin
  FWidth := Value;
  Change;
end;

procedure TKOLListViewColumn.SetWidthType(
  const Value: TKOLListViewColWidthType);
begin
  FWidthType := Value;
  Change;
end;

{ TKOLLVColumnsPropEditor }

procedure TKOLLVColumnsPropEditor.Edit;
var LV: TKOLListView;
begin
  if GetComponent( 0 ) = nil then Exit;
  LV := GetComponent( 0 ) as TKOLListView;
  if LV.ActiveDesign = nil then
    LV.ActiveDesign := TfmLVColumnsEditor.Create( Application );
  LV.ActiveDesign.ListView := LV;
  LV.ActiveDesign.Visible := TRUE;
  SetForegroundWindow( LV.ActiveDesign.Handle );
  LV.ActiveDesign.MakeActive( TRUE );
  if LV.ParentForm <> nil then
    LV.ParentForm.Invalidate;
end;

function TKOLLVColumnsPropEditor.GetAttributes: TPropertyAttributes;
begin
  Result := [ paDialog, paReadOnly ];
end;

{ TKOLLVColumnsEditor }

procedure TKOLLVColumnsEditor.Edit;
var LV: TKOLListView;
begin
  if Component = nil then Exit;
  if not(Component is TKOLListView) then Exit;
  LV := Component as TKOLListView;
  if LV.ActiveDesign = nil then
    LV.ActiveDesign := TfmLVColumnsEditor.Create( Application );
  LV.ActiveDesign.ListView := LV;
  LV.ActiveDesign.Visible := True;
  SetForegroundWindow( LV.ActiveDesign.Handle );
  LV.ActiveDesign.MakeActive( TRUE );
  if LV.ParentForm <> nil then
    LV.ParentForm.Invalidate;
end;

procedure TKOLLVColumnsEditor.ExecuteVerb(Index: Integer);
begin
  Edit;
end;

function TKOLLVColumnsEditor.GetVerb(Index: Integer): string;
begin
  Result := '&Edit columns';
end;

function TKOLLVColumnsEditor.GetVerbCount: Integer;
begin
  Result := 1;
end;

{ TKOLDateTimePicker }

procedure TKOLDateTimePicker.AssignEvents(SL: TStringList;
  const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnDTPUserString' ], [ @ OnDTPUserString ] );
end;

constructor TKOLDateTimePicker.Create(AOwner: TComponent);
begin
  inherited;
  Width := 110; DefaultWidth := Width;
  Height := 24; DefaultHeight := Height;
  Color := clWindow;
  fTabStop := TRUE;
  MonthBkColor := clNone;
  MonthTxtColor := clNone;
end;

function TKOLDateTimePicker.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLDateTimePicker.P_AssignEvents(SL: TStringList;
  const AName: String; CheckOnly: Boolean): Boolean;
begin
  Result := inherited P_AssignEvents( SL, AName, CheckOnly );
  if Result and CheckOnly then Exit;
  Result := Result or
  P_DoAssignEvents( SL, AName, [ 'OnDTPUserString' ], [ @ OnDTPUserString ],
    [ FALSE ], CheckOnly );
end;

procedure TKOLDateTimePicker.P_SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
begin
  inherited;
  if Format <> '' then
    //SL.Add( Prefix + AName + '.DateTimeFormat := ' + StringConstant( 'Format', Format ) + ';' );
    {P}SL.Add( ' DUP C2R ' + P_StringConstant( 'Format', Format ) +
               ' R2C TControl_.SetDateTimeFormat<2> DelAnsiStr' );
  if not ParentColor then
    //SL.Add( Prefix + AName + '.DateTimePickerColors[ dtpcBackground ] := ' +
    //  Color2Str( Color ) + ';' );
    {P}SL.Add( ' L($' + IntToHex( Color, 6 ) + ') L(' + IntToStr( Integer( dtpcBackground ) ) +
      ') C2 TControl_.SetDateTimePickerColor<3>' );
end;

function TKOLDateTimePicker.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
//var S: String;
begin
  {S := '';
  if dtpoTime       in Options then S := S + ',dtpoTime';
  if dtpoDateLong   in Options then S := S + ',dtpoDateLong';
  if dtpoUpDown     in Options then S := S + ',dtpoUpDown';
  if dtpoRightAlign in Options then S := S + ',dtpoRightAlign';
  if dtpoShowNone   in Options then S := S + ',dtpoShowNone';
  if dtpoParseInput in Options then S := S + ',dtpoParseInput';
  Delete( S, 1, 1 );
  Result := AParent + ', [' + S + ']';}
  {P}Result := ' L(' + IntToStr( PByte( @ Options )^ ) + ')' +
               #13#10' C1';
  nparams := 2;
end;

procedure TKOLDateTimePicker.SetFormat(const Value: String);
begin
  FFormat := Value;
  Change;
end;

procedure TKOLDateTimePicker.SetMonthBkColor(const Value: TColor);
begin
    if  FMonthBkColor = Value then Exit;
    FMonthBkColor := Value;
    Change;
end;

procedure TKOLDateTimePicker.SetMonthTxtColor(const Value: TColor);
begin
    if  FMonthTxtColor = Value then Exit;
    FMonthTxtColor := Value;
    Change;
end;

procedure TKOLDateTimePicker.SetOnDTPUserString(const Value: KOL.TDTParseInputEvent);
begin
  FOnDTPUserString := Value;
  Change;
end;

procedure TKOLDateTimePicker.SetOptions(
  const Value: TDateTimePickerOptions);
begin
  if ( dtpoTime in Value ) and not( dtpoTime in FOptions ) then
    FOptions := Value + [ dtpoUpDown ]
  else
    FOptions := Value;
  Change;
end;

procedure TKOLDateTimePicker.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewDateTimePicker', TRUE, TRUE, '' );
    KF.FormAddNumParameter( PByte( @ Options )^ );
end;

procedure TKOLDateTimePicker.SetupFirst(SL: TStringList; const AName,
  AParent, Prefix: String);
var KF: TKOLForm;
begin
  inherited;
  KF := ParentKOLForm;
  if  Format <> '' then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetDateTimeFormat', '' );
          KF.FormAddStrParameter( Format );
      end else
      SL.Add( Prefix + AName + '.DateTimeFormat := ' +
              StringConstant( 'Format', Format ) + ';' );

  if  MonthBkColor <> clNone then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetDateTimeColor', '' );
          KF.FormAddNumParameter( (MonthBkColor shl 1) or (MonthBkColor shr 31) );
          KF.FormAddNumParameter( Integer( dtpcBackground ) );
      end else
      SL.Add( Prefix + AName + '.DateTimePickerColors[ dtpcBackground ] := TColor(' +
              Color2Str( MonthBkColor ) + ');' );

  if  MonthTxtColor <> clNone then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetDateTimeColor', '' );
          KF.FormAddNumParameter( (MonthTxtColor shl 1) or (MonthTxtColor shr 31) );
          KF.FormAddNumParameter( Integer( dtpcText ) );
      end else
      SL.Add( Prefix + AName + '.DateTimePickerColors[ dtpcMonthBk ] := TColor(' +
              Color2Str( MonthTxtColor ) + ');' );

end;

function TKOLDateTimePicker.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
var S: String;
begin
  S := '';
  if dtpoTime       in Options then S := S + ',dtpoTime';
  if dtpoDateLong   in Options then S := S + ',dtpoDateLong';
  if dtpoUpDown     in Options then S := S + ',dtpoUpDown';
  if dtpoRightAlign in Options then S := S + ',dtpoRightAlign';
  if dtpoShowNone   in Options then S := S + ',dtpoShowNone';
  if dtpoParseInput in Options then S := S + ',dtpoParseInput';
  Delete( S, 1, 1 );
  Result := AParent + ', [' + S + ']';
end;

function TKOLDateTimePicker.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

function TKOLDateTimePicker.TabStopByDefault: Boolean;
begin
  Result := TRUE;
end;

{ TKOLScrollBar }

procedure TKOLScrollBar.AssignEvents(SL: TStringList; const AName: String);
begin
  inherited;
  DoAssignEvents( SL, AName, [ 'OnSBBeforeScroll', 'OnSBScroll' ],
                  [ @OnSBBeforeScroll, @OnSBScroll ] );
end;

constructor TKOLScrollBar.Create(AOwner: TComponent);
begin
  inherited;
  FSBMax := 100;
  DefaultWidth := GetSystemMetrics( SM_CXVSCROLL );
  DefaultHeight := GetSystemMetrics( SM_CYHSCROLL );
  FSBBar := KOL.sbVertical;
  Width := DefaultWidth;
end;

function TKOLScrollBar.Pcode_Generate: Boolean;
begin
  Result := TRUE;
end;

function TKOLScrollBar.P_AssignEvents(SL: TStringList; const AName: String;
  CheckOnly: Boolean): Boolean;
begin
  Result := inherited P_AssignEvents( SL, AName, CheckOnly );
  if Result and CheckOnly then Exit;
  Result := Result or
  P_DoAssignEvents( SL, AName, [ 'OnSBBeforeScroll', 'OnSBScroll' ],
                               [ @OnSBBeforeScroll, @OnSBScroll ],
                               [ FALSE,             FALSE ], CheckOnly );
end;

procedure TKOLScrollBar.P_SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBar.P_SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  if SBMin <> 0 then
    //SL.Add( Prefix + AName + '.SBMin := ' + IntToStr( SBMin ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( SBMin ) + ')' +
               ' C1 TControl_.SetSBMin<2>' );
  //if SBMax <> 100 then
    //SL.Add( Prefix + AName + '.SBMax := ' + IntToStr( SBMax ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( SBMax ) + ')' +
               ' C1 TControl_.SetSBMax<2>' );
  if SBPosition <> SBMin then
    //SL.Add( Prefix + AName + '.SBPosition := ' + IntToStr( SBPosition ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( SBPosition ) + ')' +
               ' C1 TControl_.SetSBPosition<2>' );
  if SBPageSize <> 0 then
    //SL.Add( Prefix + AName + '.SBPageSize := ' + IntToStr( SBPageSize ) + ';' );
    {P}SL.Add( ' L(' + IntToStr( SBPageSize ) + ')' +
               ' C1 TControl_.SetSBPageSize<2>' );
end;

function TKOLScrollBar.P_SetupParams(const AName, AParent: String;
  var nparams: Integer): String;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBar.P_SetupParams', 0
  @@e_signature:
  end;
  //Result := AParent + ', ' + ScrollerbarNames[ SBBar ];
  {P}Result := ' L(' + IntToStr( Integer( SBBar ) ) + ') C1';
  nparams := 2;
end;

procedure TKOLScrollBar.SetOnSBBeforeScroll(
  const Value: TOnSBBeforeScroll);
begin
  FOnSBBeforeScroll := Value;
  Change;
end;

procedure TKOLScrollBar.SetOnSBScroll(const Value: TOnSBScroll);
begin
  FOnSBScroll := Value;
  Change;
end;

procedure TKOLScrollBar.SetSBbar(const Value: TScrollerBar);
var WasBar: TScrollerBar;
    WasWidth, WasHeight: Integer;
begin
  WasBar := FSBbar;
  WasWidth := Width;
  WasHeight := Height;
  if WasBar = Value then Exit;
  FSBbar := Value;
  if (Align in [ caLeft, caRight ]) and (WasBar = KOL.sbVertical) then
  begin
    CASE Align OF
    caLeft: Align := caTop;
    else    Align := caBottom;
    END;
    Height := WasWidth;
  end
  else
  if (Align in [ caTop, caBottom ]) and (WasBar = KOL.sbHorizontal) then
  begin
    CASE Align OF
    caTop:  Align := caLeft;
    else    Align := caRight;
    END;
    Width := WasHeight;
  end;
  Change;
end;

procedure TKOLScrollBar.SetSBMax(const Value: Integer);
begin
  FSBMax := Value;
  if FSBMin > FSBMax then
    FSBMin := Value;
  if FSBPageSize > FSBMax - FSBMin then
    FSBPageSize := FSBMax - FSBMin;
  if FSBPosition > FSBMax then
    FSBPosition := FSBMax;
  if FSBPosition < FSBMin then
    FSBPosition := FSBMin;
  Change;
end;

procedure TKOLScrollBar.SetSBMin(const Value: Integer);
begin
  FSBMin := Value;
  if FSBMin > FSBMax then
    FSBMax := Value;
  if FSBPageSize > FSBMax - FSBMin then
    FSBPageSize := FSBMax - FSBMin;
  if FSBPosition > FSBMax then
    FSBPosition := FSBMax;
  if FSBPosition < FSBMin then
    FSBPosition := FSBMin;
  Change;
end;

procedure TKOLScrollBar.SetSBPageSize(const Value: Integer);
begin
  FSBPageSize := Value;
  if FSBPageSize > FSBMax - FSBMin then
    FSBPageSize := FSBMax - FSBMin;
  if FSBPosition > FSBMax then
    FSBPosition := FSBMax;
  if FSBPosition < FSBMin then
    FSBPosition := FSBMin;
  Change;
end;

procedure TKOLScrollBar.SetSBPosition(const Value: Integer);
begin
  FSBPosition := Value;
  if FSBPosition > FSBMax then
    FSBPosition := FSBMax;
  if FSBPosition < FSBMin then
    FSBPosition := FSBMin;
  Change;
end;

procedure TKOLScrollBar.SetupConstruct_Compact;
var KF: TKOLForm;
begin
    inherited;
    KF := ParentKOLForm;
    if  KF = nil then Exit;
    KF.FormAddAlphabet( 'FormNewScrollBar', TRUE, TRUE, '' );
    KF.FormAddNumParameter( Integer( SBBar ) );
end;

procedure TKOLScrollBar.SetupFirst(SL: TStringList; const AName, AParent,
  Prefix: String);
var KF: TKOLForm;
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBar.SetupFirst', 0
  @@e_signature:
  end;
  inherited;
  KF := ParentKOLForm;
  if  SBMin <> 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetSBMin', '' );
          KF.FormAddNumParameter( SBMin );
      end else
      SL.Add( Prefix + AName + '.SBMin := ' + IntToStr( SBMin ) + ';' );

  if  (KF <> nil) and KF.FormCompact then
  begin
      KF.FormAddCtlCommand( Name, 'FormSetSBMax', '' );
      KF.FormAddNumParameter( SBMax );
  end else
  SL.Add( Prefix + AName + '.SBMax := ' + IntToStr( SBMax ) + ';' );

  if  SBPosition <> SBMin then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetSBPosition', '' );
          KF.FormAddNumParameter( SBPosition );
      end else
      SL.Add( Prefix + AName + '.SBPosition := ' + IntToStr( SBPosition ) + ';' );

  if  SBPageSize <> 0 then
      if  (KF <> nil) and KF.FormCompact then
      begin
          KF.FormAddCtlCommand( Name, 'FormSetSBPageSize', '' );
          KF.FormAddNumParameter( SBPageSize );
      end else
      SL.Add( Prefix + AName + '.SBPageSize := ' + IntToStr( SBPageSize ) + ';' );
end;

function TKOLScrollBar.SetupParams( const AName, AParent: TDelphiString ): TDelphiString;
const ScrollerBarNames: array[ TScrollerBar ] of String = (
        'sbHorizontal', 'sbVertical' );
begin
  asm
    jmp @@e_signature
    DB '#$signature$#', 0
    DB 'TKOLScrollBar.SetupParams', 0
  @@e_signature:
  end;
  Result := AParent + ', ' + ScrollerbarNames[ SBBar ];
end;

function TKOLScrollBar.SupportsFormCompact: Boolean;
begin
    Result := TRUE;
end;

{ TKOLTabPage }

function TKOLTabPage.TypeName: String;
begin
    Result := 'Panel';
end;

end.



