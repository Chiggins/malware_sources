unit sConst;
{$I sDefs.inc}
{.$DEFINE LOGGED}

interface

uses Messages, Graphics, Windows, comctrls, ExtCtrls, controls, classes, Buttons, Forms,
  StdCtrls, Consts, Dialogs;

{$R SRES.RES}

{$IFNDEF NOTFORHELP}
const
  CompatibleSkinVersion = 7.00;     // Version of supported skins in current version of the package
  MaxCompSkinVersion = 8.99;
  ExceptTag = -98;                  // Mask for the tag value in 3rd-party controls which will not be skinned automatically

  // Data chars for skins
  TexChar   = '~';
  ZeroChar  = '0';
  CharQuest = '?';
  CharDiez  = '#';
  CharExt   = '!'; // External image separator
  CharGlyph = '@'; // Glyph data separator
  CharMask  = '^';

  // States of control
  ACS_FAST          = 1;    // Cache is not used (when control is not alphablended and when childs do not must have image of this control)
  ACS_BGUNDEF       = 2;    // Cache state is undefined still
  ACS_PRINTING      = 512;  // WM_PRINT in process
  ACS_MNUPDATING    = 1024; // Menu updating required
  ACS_LOCKED        = 2048; // Drawing of control is blocked
  ACS_FOCUSCHANGING = 4096;

  // Background types
  BGT_NONE          = 0;
  BGT_GRADIENTHORZ  = 1;
  BGT_GRADIENTVERT  = 2;
  BGT_TEXTURE       = 4;
  BGT_TEXTURELEFT   = $10;
  BGT_TEXTURETOP    = $20;
  BGT_TEXTURERIGHT  = $40;
  BGT_TEXTUREBOTTOM = $80;
  BTG_TOPLEFT       = $100;
  BGT_TOPRIGHT      = $200;
  BGT_BOTTOMLEFT    = $400;
  BGT_BOTTOMRIGHT   = $800;

  // Predefined internal tags for ListWnd objects
  ACT_RELCAPT = -1;  // Release capture after MouseUp

type

{$IFDEF UNICODE}
  ACString = String;
  ACChar   = Char;
  PACChar  = PChar;
{$ELSE} // UNICODE
{$IFDEF TNTUNICODE}
  ACString = WideString;
  ACChar   = WideChar;
  PACChar  = PWideChar;
{$ELSE}
  ACString = AnsiString;
  ACChar   = AnsiChar;
  PACChar  = PAnsiChar;
{$ENDIF}
{$ENDIF} // UNICODE

{$IFDEF DELPHI_XE2}
  ACLongInt    = NativeInt;
{$ELSE}
  ACLongInt    = LongInt;
{$ENDIF}

{$IFDEF DELPHI_XE2}
  ACUInt    = NativeUInt;
{$ELSE}
  ACUInt    = Cardinal;
{$ENDIF}

{$IFNDEF D2007}
  LONG_PTR = Longint;
{$IFDEF BCB}
  {$NODEFINE LONG_PTR}
{$ENDIF}
{$ENDIF}

  OldChar = AnsiChar;
  POldChar = PAnsiChar;
  OldString = AnsiString;
  POldString = PAnsiString;

  PACString = ^ACString;

  TAOR = array of Windows.TRect;
  TPaintEvent = procedure (Sender: TObject; Canvas: TCanvas) of object;
  TBmpPaintEvent = procedure (Sender: TObject; Bmp: Graphics.TBitmap) of object;

  TsSkinName = string;
  TsDirectory = string;
  TsSkinSection = string;
  TacRoot = type string;
  TacStrValue = String;

  TFadeDirection = (fdNone, fdUp, fdDown);
  TacAnimType = (atFading, atAero);

  TacBtnEvent = (beMouseEnter, beMouseLeave, beMouseDown, beMouseUp);
  TacBtnEvents = set of TacBtnEvent;

  TacCtrlType = (actGraphic);

  TacAnimatEvent = (aeMouseEnter, aeMouseLeave, aeMouseDown, aeMouseUp, aeGlobalDef);
  TacAnimatEvents = set of TacAnimatEvent;
  TacImgType = (itisaBorder, itisaTexture, itisaGlyph, itisaGlow, itisaPngGlyph);
  TacFillMode = (fmTiled, fmStretched, fmTiledHorz, fmTiledVert, fmStretchHorz, fmStretchVert,
    fmTileHorBtm, fmTileVertRight, fmStretchHorBtm, fmStretchVertRight, fmDisTiled, fmDiscHorTop,
    fmDiscVertLeft, fmDiscHorBottom, fmDiscVertRight
  );

  TvaAlign = (vaTop, vaMiddle, vaBottom);

  TsHackedControl = class(TControl)
  public
    property AutoSize;
    property ParentColor;
    property Color;
    property ParentFont;
    property PopupMenu;
    property Font;
    property WindowText;
  end;

{$IFDEF D2010}
  TAccessCanvas = class(TCustomCanvas)
{$ELSE}
  TAccessCanvas = class(TPersistent)
{$ENDIF}
  public
    FHandle: HDC;
  end;

  PacBGInfo = ^TacBGInfo;
  TacBGType = (btUnknown, btFill, btCache, btNotReady); // Returned by control type of BG
  TacBGInfo = record
    Bmp       : Graphics.TBitmap;
    Color     : TColor;      // Color returned if btFill is used
    Offset    : TPoint;      // Offset of bg, used with Cache
    R         : TRect;       // Rectangle used if PlsDraw is True
    FillRect  : TRect;       // Rect of part without borders
    BgType    : TacBGType;   // btUnknown, btFill, btCache
    PleaseDraw: boolean;     // Parent must fill rectangle(R)
    DrawDC    : hdc;         // Device context for drawing, if PleaseDraw is True
  end;

  TCacheInfo = record
    Bmp : Graphics.TBitmap;
    X : integer;
    Y : integer;
    FillColor : TColor; 
    FillRect  : TRect;       // Rect of part without borders
    Ready : boolean;
  end;
  { Pointer to @link(TPoints)}
  PPoints = ^TPoints;
  { Array of TPoint}
  TPoints = array of TPoint;

  { Set of 1..100}
  TPercent = 0..100;
  { Set of controls codes (1..255)}
  TsCodes = set of 1..255;
  { Styles of hints - (hsSimply, hsExtended, hsEllipse, hsStandard, hsNone)}
  TsHintStyle = (hsSimply, hsComics, hsEllipse, hsBalloon, hsStandard, hsNone);
  TsHintsPredefinitions = (shSimply, shGradient, shTransparent, shEllipse, shBalloon, shComicsGradient, shComicsTransparent, shStandard, shNone, shCustom);
  { Types of the gradients painting - (gtTopBottom, gtLeftRight, gtAsBorder)}
  TGradientTypes = (gtTopBottom, gtLeftRight, gtAsBorder);
  { Shapes of the shadows (ssRectangle, ssEllipse).}
  TsShadowingShape = (ssRectangle, ssEllipse);
  { Set of window_show types}
  TsWindowShowMode = (soHide, soNormal, soShowMinimized, soMaximize, soShowNoActivate, soShow, soMinimize, soShowMinNoActive, soShowNA, soRestore, soDefault);

  TsRGB = packed record
    B: Byte;
    G: Byte;
    R: Byte;
  end;

  TsRGBA = packed record
    B: Byte;
    G: Byte;
    R: Byte;
    A: Byte;
  end;

  TsColor = record
    case integer of
      0  : (C : TColor);
      1  : (R, G, B, A : Byte);
      2  : (I : integer);
      3  : (sBGRA : TsRGBA);
      4  : (RGB : TsRGB; MASK : Byte);
    end;

  TsColor_ = record // Bytes inverted (for fast calcs)
    case integer of
      0  : (C : TColor);
      1  : (B, G, R, A : Byte);
      2  : (I : integer);
      3  : (sBGRA : TsRGBA);
      4  : (BGR : TsRGB; MASK : Byte);
    end;

  PRGBAArray = ^TRGBAArray;
  TRGBAArray = array[0..100000] of TsColor_;

  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..100000] of TsRGB;

  TsDisabledGlyphKind = set of (dgBlended, dgGrayed);
  TsDisabledKind = set of (dkBlended, dkGrayed);
  PsDisabledKind = ^TsDisabledKind;

  TsGradPie = record
    Color1 : TColor;
    Color2 : TColor;
    Percent : TPercent;
    Mode1 : integer;
    Mode2 : integer;
  end;

  TsGradArray = array of TsGradPie;

// Scrollbars HitTest results
const
{$IFNDEF DISABLEPREVIEWMODE}
  // <<< Used with ASKinEditor
  s_PreviewKey   = '/acpreview';
  s_EditorCapt   = 'AlphaSkins Editor';
  s_RegName      = 'AlphaSkins';
  s_IntSkinsPath = 'IntSkinsPath';
  ASE_CLOSE  = 1;
  ASE_UPDATE = 2;
  ASE_HELLO  = 3;
  ASE_ALIVE  = 4; // Must return 1

  ASE_MSG    = $A400;
  // >>>
{$ENDIF}

  MasterBmpName  = 'Master.bmp';
  OptionsDatName = 'Options.dat';
  acSkinExt      = 'asz';
  acPngExt       = 'png';
  acIcoExt       = 'ico';

  s_MinusOne     = '-1';
  s_TrueStr      = 'TRUE';
  s_FalseStr     = 'FALSE';
  s_NewFolder    = 'New folder';             // Name for new created forlder in the PathDialog
  s_SkinSelectItemName = 'SkinSelectItem';   // "Available skins" Menu item
  s_Slash = '\';
  s_Space = ' ';
  s_Comma = ',';

  // Borders draw modes
  BDM_STRETCH = 1;
  BDM_ACTIVEONLY = 2;
  BDM_FILL = 4;

  HTSB_LEFT_BUTTON = 100;
  HTSB_RIGHT_BUTTON = 101;
  HTSB_TOP_BUTTON = 102;
  HTSB_BOTTOM_BUTTON = 103;
  HTSB_H_SCROLL = 104;
  HTSB_HB_SCROLL = 105;
  HTSB_V_SCROLL = 106;
  HTSB_VB_SCROLL = 107;

  { WM_NCHITTEST and MOUSEHOOKSTRUCT Mouse Position Codes for MDI form}
  HTCHILDCLOSE       = 101;
  HTCHILDMAX         = 102;
  HTCHILDMIN         = 103;

  EmptyRgn = 0;
  acTimerInterval = 12;

  acImgTypes : array [0..4] of TacImgType = (itisaBorder, itisaTexture, itisaGlyph, itisaGlow, itisaPngGlyph);
  acFillModes : array [0..14] of TacFillMode = (fmTiled, fmStretched, fmTiledHorz, fmTiledVert, fmStretchHorz,
    fmStretchVert, fmTileHorBtm, fmTileVertRight, fmStretchHorBtm, fmStretchVertRight, fmDisTiled,
    fmDiscHorTop, fmDiscVertLeft, fmDiscHorBottom, fmDiscVertRight
  );
  aScrollCodes : array [0..8] of TScrollCode = (scLineUp, scLineDown, scPageUp, scPageDown, scPosition, scTrack, scTop, scBottom, scEndScroll);
  aHintStyles : array [0..5] of TsHintStyle = (hsSimply, hsComics, hsEllipse, hsBalloon, hsStandard, hsNone);
  acBtnEvents : array [TacAnimatEvent] of TacBtnEvent = (beMouseEnter, beMouseLeave, beMouseDown, beMouseUp, beMouseUp);

  COC_TsCustom              = 1;

  COC_TsSpinEdit            = 2;
  COC_TsEdit                = 3;
  COC_TsCustomMaskEdit      = 4;
  COC_TsMemo                = 7;
  COC_TsCustomListBox       = 8;
  COC_TsListBox             = 8;
  COC_TsColorBox            = 9;
  COC_TsListView            = 10;
  COC_TsCustomComboBox      = 11;
  COC_TsComboBox            = 13;
  COC_TsComboBoxEx          = 18;

  COC_TsFrameBar            = 19;
  COC_TsBarTitle            = 20;
  COC_TsCheckBox            = 32;
  COC_TsDBCheckBox          = 32;
  COC_TsRadioButton         = 33;

  COC_TsCurrencyEdit        = 41;

  COC_TsImage               = 50;
  COC_TsPanel               = 51;
  COC_TsPanelLow            = 52;
  COC_TsCoolBar             = 53;
  COC_TsToolBar             = 54;
  COC_TsDragBar             = 56;
  COC_TsTabSheet            = 57;
  COC_TsScrollBox           = 58;
  COC_TsMonthCalendar       = 59;
  COC_TsDBNavigator         = 60;
  COC_TsCustomPanel         = 68;
  COC_TsGrip                = 73;
  COC_TsGroupBox            = 74;
  COC_TsSplitter            = 75;
  // DB-aware controls
  COC_TsDBEdit              = 76;
  COC_TsDBMemo              = 78;
  COC_TsDBComboBox          = 81;
  COC_TsDBLookupComboBox    = 82;
  COC_TsDBListBox           = 83;
  COC_TsDBLookupListBox     = 84;
  COC_TsDBGrid              = 85;
  // -------------- >>
  COC_TsSpeedButton         = 92;
  COC_TsButton              = 93;
  COC_TsBitBtn              = 94;
  COC_TsColorSelect         = 95;
  COC_TsTreeView            = 96;

  COC_TsNavButton           = 98;
  COC_TsBevel               = 110;
  COC_TsCustomComboEdit     = 131;
  COC_TsFileDirEdit         = 132;
  COC_TsFilenameEdit        = 133;
  COC_TsDirectoryEdit       = 134;
  COC_TsCustomDateEdit      = 137;
  COC_TsComboEdit           = 138;
  COC_TsDateEdit            = 140;
  COC_TsPageControl         = 141;
  COC_TsScrollBar           = 142;
  COC_TsTabControl          = 143;
  COC_TsStatusBar           = 151;
  COC_TsHeaderControl       = 152;
  COC_TsGauge               = 161;
  COC_TsTrackBar            = 165;
  COC_TsHintManager         = 211;
  COC_TsSkinProvider        = 224;
  COC_TsMDIForm             = 225;
  COC_TsFrameAdapter        = 226;

  COC_TsAdapter             = 230;
  COC_TsAdapterEdit         = 231;

  COC_Unknown               = 250;

  // Codes of components, who don't catch mouse events
  sForbidMouse : TsCodes = [COC_TsFrameBar, COC_TsPanel..COC_TsGroupBox, COC_TsBevel, COC_TsPageControl..COC_TsGauge];

  // Contols that can have one state only
  sCanNotBeHot : TsCodes = [COC_TsPanel, COC_TsPanelLow, COC_TsToolBar, COC_TsDragBar, COC_TsTabSheet,
                            COC_TsScrollBox, COC_TsMonthCalendar, COC_TsDBNavigator, COC_TsCustomPanel,
                            COC_TsGrip, COC_TsGroupBox, COC_TsBevel, COC_TsPageControl, COC_TsTabControl,
                            COC_TsStatusBar, COC_TsGauge, COC_TsFrameAdapter];

  sEditCtrls : TsCodes = [COC_TsSpinEdit..COC_TsComboBoxEx, COC_TsCurrencyEdit, COC_TsDBEdit..COC_TsDBLookupListBox,
                          COC_TsTreeView, COC_TsCustomComboEdit..COC_TsDateEdit, COC_TsAdapterEdit];

  sBoolArray : array [False..True] of string = (s_FalseStr, s_TrueStr);

var
  sPopupCalendar: TForm;

{$IFDEF LOGGED}
  acDebugCount : integer = 0;
{$ENDIF}

{$IFNDEF DISABLEPREVIEWMODE}
  acPreviewHandle : THandle = 0;
  acPreviewNeeded : boolean = False;
  acSkinPreviewUpdating : boolean = False;
{$ENDIF}

  acScrollBtnLength : integer = 16;
  AppShowHint : boolean;
  ShowHintStored : boolean = False;
  EmptyCI : TCacheInfo;
  FadingForbidden : boolean = False;
  acAnimCount : integer = 0;
  TempControl : pointer;
  x64woAero : boolean = False;

  LargeShellImages, SmallShellImages : TImageList;

  fGlobalFlag : boolean = False;
  acMagnForm : TWinControl;
  sFuchsia : TsColor;   // FF00FF; Const value of transparent color

procedure InitShellImageLists(Large, Small : boolean);
{$ENDIF} // NOTFORHELP

type
  { Layouts for controls captions - (sclLeft, sclTopLeft, sclTopCenter, sclTopRight)}
  TsCaptionLayout = (sclLeft, sclTopLeft, sclTopCenter, sclTopRight, sclLeftTop, sclBottomLeft, sclBottomCenter, sclBottomRight);
  { Set of days of week.}
  TDaysOfWeek = set of TCalDayOfWeek;
  { Order of date representation - (doMDY, doDMY, doYMD).}
  TDateOrder = (doMDY, doDMY, doYMD);
  { Set of popup window alignes - (pwaRight, pwaLeft).}
  TPopupWindowAlign = (pwaRight, pwaLeft);

var
  // Variables that can change a mode of the package work
  ac_UseSysCharSet       : boolean = True;   // Use system character set in form titles (if False then character set from Form.Font.Charset property will be used)
  ac_KeepOwnFont         : boolean = False;  // If true then fonts will not be changed in standard ot 3rd-party controls
  ac_NoExtBordersIfMax   : boolean = False;  // Do not use Extended borders when form is maximized
  ac_CheckEmptyAlpha     : boolean = False;   // Checking of an empty alpha-channel in glyphs is required

  MouseForbidden : boolean = False;         // If true then mouse hot events are forbidden
  DrawSkinnedMDIWall : boolean = True;      // Use skinning for MDI area
  DrawSkinnedMDIScrolls : boolean = True;   // Use skinning for MDI area scrolls
  acOldGlyphsOrder : boolean = False;       // Used when NumGlyphs more than 1 and defines that second image must be used for disabled state (this image used for Hot state in new mode)

{$IFNDEF NOTFORHELP}
  ac_DialogsLevel        : integer = 2;      // Deep of system dialogs skinning
  ac_ChangeThumbPreviews : boolean = False;  // Allow a changing of Aero preview window by AlphaControls (is not ready currently)
  ac_OptimizeMemory      : boolean = True;   // Cache is cleared always when control is invisible

  StdTransparency : boolean = False;        // Set this variable to True for a standard mechanism of GraphicControls repainting

const
  SC_DRAGMOVE = $F012;
{$IFDEF DELPHI5}
  WS_EX_LAYERED = $00080000;
  WS_EX_NOACTIVATE = $08000000;
  WS_EX_LAYOUTRTL = $00400000;

  ULW_ALPHA = $00000002;
  AC_SRC_ALPHA = $01;
  CS_DROPSHADOW = $20000;
{$ENDIF}

{$IFDEF RUNIDEONLY}
const
  sIsRunIDEOnlyMessage = 'Trial version of the AlphaControls package was used.'#13#10'For purchasing the fully functional version visit www.alphaskins.com, please.'#13#10'Thank you!';
{$ENDIF}

var
  // These global string variables will be initialized by values from resource
  // and may be replaced for program localization at any time

  acs_MsgDlgOK             : acString; // "OK"
  acs_MsgDlgCancel         : acString; // "Cancel"
  acs_MsgDlgHelp           : acString; // "Help"

  acs_RestoreStr           : acString; // "Restore"
  acs_MoveStr              : acString; // "Move"
  acs_SizeStr              : acString; // "Size"
  acs_MinimizeStr          : acString; // "Minimize"
  acs_MaximizeStr          : acString; // "Maximize"
  acs_CloseStr             : acString; // "Close"
  
  acs_Calculator           : acString; // "Calculator"

  acs_FileOpen             : acString; // "File open"

  acs_AvailSkins           : acString; // "Available skins"
  acs_InternalSkin         : acString; // "(internal)"

  acs_ErrorSettingCount    : acString; // "Error setting %s.Count"
  acs_ListBoxMustBeVirtual : acString; // "Listbox (%s) style must be virtual in order to set Count"
  acs_InvalidDate          : acString; // "Invalid date"

  acs_ColorDlgAdd          : acString; // "Add to custom colors set"
  acs_ColorDlgDefine       : acString; // "Define colors"
  acs_ColorDlgMainPal      : acString; // "Main palette :"
  acs_ColorDlgAddPal       : acString; // "Additional colors :"
  acs_ColorDlgTitle        : acString; // "Color"
  acs_ColorDlgRed          : acString; // "Red :"
  acs_ColorDlgGreen        : acString; // "Green :"
  acs_ColorDlgBlue         : acString; // "Blue :"
  acs_ColorDlgDecimal      : acString; // "Decimal - "
  acs_ColorDlgHex          : acString; // "Hex - "

  // Frame adapter
  acs_FrameAdapterError1   : acString; // "TsFrameAdapter adapter must be placed on the handled frame";

  // Hint designer
  acs_HintDsgnTitle        : acString; // "Hint Designer Form"
  acs_HintDsgnPreserved    : acString; // "Preserved settings :"
  acs_HintDsgnStyle        : acString; // "Style :"
  acs_HintDsgnBevelWidth   : acString; // "Bevel width"
  acs_Blur                 : acString; // "Blur"
  acs_HintDsgnArrowLength  : acString; // "Arrow length"
  acs_HintDsgnHorizMargin  : acString; // "Horiz. margin"
  acs_HintDsgnVertMargin   : acString; // "Vert. margin"
  acs_HintDsgnRadius       : acString; // "Corners radius"
  acs_HintDsgnMaxWidth     : acString; // "Max width"
  acs_HintDsgnPauseHide    : acString; // "Pause hide (ms)"
  acs_Percent              : acString; // "Percent"
  acs_HintDsgnOffset       : acString; // "Offset"
  acs_HintDsgnTransparency : acString; // "Transparency"
  acs_HintDsgnNoPicture    : acString; // "No picture available"
  acs_Font                 : acString; // "Font"
  acs_Texture              : acString; // "Texture"
  acs_HintDsgnLoad         : acString; // "Load from file"
  acs_HintDsgnSave         : acString; // "Save to file as..."
  acs_HintDsgnColor        : acString; // "Color"
  acs_HintDsgnBorderTop    : acString; // "Top border"
  acs_HintDsgnBorderBottom : acString; // "Bottom border"
  acs_Shadow               : acString; // "Shadow"
  acs_Background           : acString; // "Background"
  acs_Gradient             : acString; // "Gradient"
  acs_PreviewHint          : acString; // "Preview of the future hint window"

  // File dialogs
  acs_Root                 : acString; // "Root :"
  acs_SelectDir            : acString; // "Select directory"
  acs_Create               : acString; // "Create"

  // Select skin dialog
  acs_DirWithSkins         : acString; // "Directory with skins :"
  acs_SelectSkinTitle      : acString; // "Select skin"
  acs_SkinPreview          : acString; // "Skin preview"
{$ENDIF}

implementation

uses SysUtils, ShellAPI, sStrings;

procedure InitShellImageLists(Large, Small : boolean);
var
  sfi: TSHFileInfo;
begin
  if not Assigned(LargeShellImages) then begin
    LargeShellimages := TImageList.Create(nil);
    LargeShellImages.Handle := SHGetFileInfo('', 0, sfi, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_LARGEICON or SHGFI_SHELLICONSIZE);
    LargeShellImages.ShareImages := TRUE;
    LargeShellImages.Name := 'sShellLargeImages';
  end;
  if not Assigned(SmallShellImages) then begin
    SmallShellImages := TImageList.Create(nil);
    SmallShellImages.Handle := SHGetFileInfo('', 0, sfi, SizeOf(TSHFileInfo), SHGFI_SYSICONINDEX or SHGFI_SMALLICON);
    SmallShellImages.ShareImages := TRUE;
    SmallShellImages.Name := 'sShellSmallImages';
  end;
end;

initialization
  EmptyCI.Ready := False;
  EmptyCI.X := -99;
  EmptyCI.X := -99;
  EmptyCI.Bmp := nil;
  EmptyCI.FillColor := clFuchsia;
  
  sFuchsia.C := $FF00FF;
  acScrollBtnLength := GetSystemMetrics(SM_CXHSCROLL);

  acs_MsgDlgOK             := LoadStr(s_MsgDlgOK);
  acs_MsgDlgCancel         := LoadStr(s_MsgDlgCancel);
  acs_MsgDlgHelp           := LoadStr(s_MsgDlgHelp);

  acs_RestoreStr           := LoadStr(s_RestoreStr);
  acs_MoveStr              := LoadStr(s_MoveStr);
  acs_SizeStr              := LoadStr(s_SizeStr);
  acs_MinimizeStr          := LoadStr(s_MinimizeStr);
  acs_MaximizeStr          := LoadStr(s_MaximizeStr);
  acs_CloseStr             := LoadStr(s_CloseStr);

  acs_Calculator           := LoadStr(s_Calculator);

  acs_FileOpen             := LoadStr(s_FileOpen);

  acs_AvailSkins           := LoadStr(s_AvailSkins);
  acs_InternalSkin         := LoadStr(s_InternalSkin);

  acs_ErrorSettingCount    := LoadStr(s_ErrorSettingCount);
  acs_ListBoxMustBeVirtual := LoadStr(s_ListBoxMustBeVirtual);

  // Color dialog
  acs_ColorDlgAdd          := LoadStr(s_ColorDlgAdd);
  acs_ColorDlgDefine       := LoadStr(s_ColorDlgDefine);
  acs_ColorDlgMainPal      := LoadStr(s_ColorDlgMainPal);
  acs_ColorDlgAddPal       := LoadStr(s_ColorDlgAddPal);

  acs_ColorDlgTitle        := LoadStr(s_ColorDlgTitle);
  acs_ColorDlgRed          := LoadStr(s_ColorDlgRed);
  acs_ColorDlgGreen        := LoadStr(s_ColorDlgGreen);
  acs_ColorDlgBlue         := LoadStr(s_ColorDlgBlue);
  acs_ColorDlgDecimal      := LoadStr(s_ColorDlgDecimal);
  acs_ColorDlgHex          := LoadStr(s_ColorDlgHex);

  // Frame adapter
  acs_FrameAdapterError1   := LoadStr(s_FrameAdapterError1);

  // Hint designer
  acs_HintDsgnTitle        := LoadStr(s_HintDsgnTitle);
  acs_HintDsgnPreserved    := LoadStr(s_HintDsgnPreserved);
  acs_HintDsgnStyle        := LoadStr(s_HintDsgnStyle);
  acs_HintDsgnBevelWidth   := LoadStr(s_HintDsgnBevelWidth);
  acs_Blur                 := LoadStr(s_Blur);
  acs_HintDsgnArrowLength  := LoadStr(s_HintDsgnArrowLength);
  acs_HintDsgnHorizMargin  := LoadStr(s_HintDsgnHorizMargin);
  acs_HintDsgnVertMargin   := LoadStr(s_HintDsgnVertMargin);
  acs_HintDsgnRadius       := LoadStr(s_HintDsgnRadius);
  acs_HintDsgnMaxWidth     := LoadStr(s_HintDsgnMaxWidth);
  acs_HintDsgnPauseHide    := LoadStr(s_HintDsgnPauseHide);
  acs_Percent              := LoadStr(s_Percent);
  acs_HintDsgnOffset       := LoadStr(s_HintDsgnOffset);
  acs_HintDsgnTransparency := LoadStr(s_HintDsgnTransparency);
  acs_HintDsgnNoPicture    := LoadStr(s_HintDsgnNoPicture);
  acs_Font                 := LoadStr(s_Font);
  acs_Texture              := LoadStr(s_Texture);
  acs_HintDsgnLoad         := LoadStr(s_HintDsgnLoad);
  acs_HintDsgnSave         := LoadStr(s_HintDsgnSave);
  acs_HintDsgnColor        := LoadStr(s_HintDsgnColor);
  acs_HintDsgnBorderTop    := LoadStr(s_HintDsgnBorderTop);
  acs_HintDsgnBorderBottom := LoadStr(s_HintDsgnBorderBottom);
  acs_Shadow               := LoadStr(s_Shadow);
  acs_Background           := LoadStr(s_Background);
  acs_Gradient             := LoadStr(s_Gradient);
  acs_PreviewHint          := LoadStr(s_PreviewHint);

  acs_Root                 := s_Root;
  acs_SelectDir            := LoadStr(s_SelectDir);
  acs_Create               := LoadStr(s_Create);

  acs_InvalidDate          := LoadStr(s_InvalidDate);
  if acs_InvalidDate = '' then acs_InvalidDate := 'Invalid date';

  acs_DirWithSkins         := s_DirWithSkins;
  acs_SelectSkinTitle      := s_SelectSkinTitle;
  acs_SkinPreview          := s_SkinPreview;

finalization
  if Assigned(SmallShellImages) then FreeAndNil(SmallShellImages);
  if Assigned(LargeShellImages) then FreeAndNil(LargeShellImages);

end.




