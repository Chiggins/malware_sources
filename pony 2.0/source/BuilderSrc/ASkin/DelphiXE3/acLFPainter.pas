unit acLFPainter;
{$I sDefs.inc}

// WARNING! This unit is compatible with Devexpress version 2011
// for older versions the acLFPainter6 unit should be used

{$DEFINE VER12_2_3} // cxGrid version 12.2.3 and newer
{$DEFINE VER12_1_6}
{$DEFINE VER26}
{$DEFINE VER23}
{$DEFINE VER653}
{$DEFINE VER650}
{$DEFINE VER645}
{$DEFINE VER640}

{$IFDEF VER653}
  {$DEFINE VER650}
{$ENDIF}

{$IFDEF VER650}
  {$DEFINE VER645}
{$ENDIF}

{$IFDEF VER645}
  {$DEFINE VER640}
{$ENDIF}

{$IFNDEF VER645}
  {$UNDEF VER650}
{$ENDIF}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs{$IFNDEF DELPHI5}, Types{$ENDIF},
  sSkinManager, sStyleSimply, sMaskData, cxLookAndFeelPainters, cxGraphics, cxClasses, ImgList, dxCore
  {$IFDEF VER12_1_6}, cxPCPainters, cxPC, cxLookAndFeels, cxPCPaintersFactory {$ENDIF} ;

type

  TsDevExProvider = class(TComponent)
  end;

  TcxACLookAndFeelPainter = class(TcxStandardLookAndFeelPainter)
  public
    function LookAndFeelName: string; override;
    // colors
    function DefaultContentColor: TColor; override;
    function DefaultContentEvenColor: TColor; override;
    function DefaultContentOddColor: TColor; override;
    function DefaultContentTextColor: TColor; override;
    function DefaultEditorBackgroundColor(AIsDisabled: Boolean): TColor; override;
    function DefaultEditorBackgroundColorEx(AKind: TcxEditStateColorKind): TColor; override;
    function DefaultEditorTextColor(AIsDisabled: Boolean): TColor; override;
    function DefaultEditorTextColorEx(AKind: TcxEditStateColorKind): TColor; override;
    function DefaultFilterBoxColor: TColor; override;
    function DefaultFilterBoxTextColor: TColor; override;
    function DefaultFixedSeparatorColor: TColor; override;
    function DefaultFooterColor: TColor; override;
    function DefaultFooterTextColor: TColor; override;
    function DefaultGridDetailsSiteColor: TColor; override;
    function DefaultGridLineColor: TColor; override;
    function DefaultGroupByBoxColor: TColor; override;
    function DefaultGroupByBoxTextColor: TColor; override;
    function DefaultGroupColor: TColor; override;
    function DefaultGroupTextColor: TColor; override;
    function DefaultHeaderBackgroundColor: TColor; override;
    function DefaultHeaderBackgroundTextColor: TColor; override;
    function DefaultHeaderColor: TColor; override;
    function DefaultHeaderTextColor: TColor; override;
    function DefaultHyperlinkTextColor: TColor; override;
    function DefaultInactiveColor: TColor; override;
    function DefaultInactiveTextColor: TColor; override;
    function DefaultPreviewTextColor: TColor; override;
    function DefaultRecordSeparatorColor: TColor; override;
    function DefaultSizeGripAreaColor: TColor; override;

    function DefaultVGridCategoryColor: TColor; override;
    function DefaultVGridCategoryTextColor: TColor; override;
    function DefaultVGridLineColor: TColor; override;
    function DefaultVGridBandLineColor: TColor; override;

    function DefaultDateNavigatorHeaderColor: TColor; override;
    function DefaultDateNavigatorSelectionColor: TColor; override;
    function DefaultDateNavigatorSelectionTextColor: TColor; override;

    function DefaultSchedulerBackgroundColor: TColor; override;
    function DefaultSchedulerTextColor: TColor; override;
    function DefaultSchedulerBorderColor: TColor; override;
    function DefaultSchedulerControlColor: TColor; override;
    function DefaultSchedulerNavigatorColor: TColor; override;
    function DefaultSchedulerViewContentColor: TColor; override;
    function DefaultSchedulerViewSelectedTextColor: TColor; override;
    function DefaultSchedulerViewTextColor: TColor; override;
    function DefaultSelectionColor: TColor; override;
    function DefaultSelectionTextColor: TColor; override;
    function DefaultSeparatorColor: TColor; override;
    function DefaultTabColor: TColor; override;
    function DefaultTabTextColor: TColor; override;
    function DefaultTabsBackgroundColor: TColor; override;

    function DefaultTimeGridMajorScaleColor: TColor; override;
    function DefaultTimeGridMajorScaleTextColor: TColor; override;
    function DefaultTimeGridMinorScaleColor: TColor; override;
    function DefaultTimeGridMinorScaleTextColor: TColor; override;
    function DefaultTimeGridSelectionBarColor: TColor; override;

    function DefaultChartDiagramValueBorderColor: TColor; override;
    function DefaultChartDiagramValueCaptionTextColor: TColor; override;
    function DefaultChartHistogramAxisColor: TColor; override;
    function DefaultChartHistogramGridLineColor: TColor; override;
    function DefaultChartHistogramPlotColor: TColor; override;
    function DefaultChartPieDiagramSeriesSiteBorderColor: TColor; override;
    function DefaultChartPieDiagramSeriesSiteCaptionColor: TColor; override;
    function DefaultChartPieDiagramSeriesSiteCaptionTextColor: TColor; override;
    function DefaultChartToolBoxDataLevelInfoBorderColor: TColor; override;
    function DefaultChartToolBoxItemSeparatorColor: TColor; override;

    // arrow
//    procedure CalculateArrowPoints(R: TRect; var P: TcxArrowPoints; AArrowDirection: TcxArrowDirection; AProportional: Boolean; AArrowSize: Integer = 0);
    procedure DrawArrow(ACanvas: TcxCanvas; const R: TRect; AArrowDirection: TcxArrowDirection; AColor: TColor); overload; override;
    procedure DrawArrow(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection; ADrawBorder: Boolean = True); overload; override;
    procedure DrawArrowBorder(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState); override;
    procedure DrawScrollBarArrow(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection); override;
    // border
    function BorderSize: Integer; override;
    procedure DrawBorder(ACanvas: TcxCanvas; R: TRect); override;
    procedure DrawContainerBorder(ACanvas: TcxCanvas; const R: TRect; AStyle: TcxContainerBorderStyle;
      AWidth: Integer; AColor: TColor; ABorders: TcxBorders); override;
    // buttons
{$IFNDEF VER23}
    function AdjustGroupButtonDisplayRect(const R: TRect; AButtonCount, AButtonIndex: Integer): TRect; override;
    function ButtonGroupBorderSizes(AButtonCount, AButtonIndex: Integer): TRect; override;
    procedure DrawButtonInGroup(ACanvas: TcxCanvas; R: TRect;
      AState: TcxButtonState; AButtonCount, AButtonIndex: Integer;
      ABackgroundColor: TColor); override;
    procedure DrawButtonGroupBorder(ACanvas: TcxCanvas; R: TRect; AInplace, ASelected: Boolean); override;
{$ENDIF}
    function ButtonBorderSize(AState: TcxButtonState = cxbsNormal): Integer; override;
    function ButtonColor(AState: TcxButtonState): TColor; override;
    function ButtonFocusRect(ACanvas: TcxCanvas; R: TRect): TRect; override;
    function ButtonTextOffset: Integer; override;
    function ButtonTextShift: Integer; override;
    function ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor = clDefault): TColor; override;
    function ButtonSymbolState(AState: TcxButtonState): TcxButtonState; override;
    procedure DrawButton(ACanvas: TcxCanvas; R: TRect; const ACaption: string;
      AState: TcxButtonState; ADrawBorder: Boolean = True; AColor: TColor = clDefault;
      ATextColor: TColor = clDefault; AWordWrap: Boolean = False{$IFDEF VER645}; AIsToolButton: Boolean = False{$ENDIF}); override;
//    procedure DrawButtonCross(ACanvas: TcxCanvas; const R: TRect; AColor: TColor;
//      AState: TcxButtonState);
    procedure DrawButtonBorder(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AColor: TColor = clDefault); override;
    function DrawExpandButtonFirst: Boolean; override;
    procedure DrawGroupExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AState: TcxButtonState); override;
    procedure DrawSmallExpandButton(ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean;
      ABorderColor: TColor; AColor: TColor = clDefault); override;
    function ExpandButtonSize: Integer; override;
    function GroupExpandButtonSize: Integer; override;
    function IsButtonHotTrack: Boolean; override;
    function IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean; override;
    function SmallExpandButtonSize: Integer; override;
    // checkbox
    function CheckBorderSize: Integer; override;
{$IFDEF VER12_2_3}    
    function CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor; virtual;
{$ELSE}    
    function CheckButtonColor(AState: TcxButtonState): TColor; override;
{$ENDIF}        
    function CheckButtonSize: TSize; override;
    procedure DrawCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState;
      AChecked: Boolean; AColor: TColor); override;
    procedure DrawCheckBorder(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      AChecked: Boolean); overload; override;
    procedure DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState;
      ACheckState: TcxCheckBoxState); overload; override;
    // RadioButton
    procedure DrawRadioButton(ACanvas: TcxCanvas; X, Y: Integer;
      AButtonState: TcxButtonState; AChecked, AFocused: Boolean;
      ABrushColor: TColor;  AIsDesigning: Boolean = False); override;
    function RadioButtonSize: TSize; override;
    // header
    procedure DrawHeader(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil; AIsLast: Boolean = False;
      AIsGroup: Boolean = False); override;
    procedure DrawHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawHeaderBorder(ACanvas: TcxCanvas; const R: TRect;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders); override;
    procedure DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect); override;
    procedure DrawHeaderControlSection(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
      ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
      AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor,
      ABkColor: TColor); override;
    procedure DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect;
      ABorders: TcxBorders; AState: TcxButtonState); override;
    procedure DrawHeaderControlSectionContent(ACanvas: TcxCanvas; const ABounds,
      ATextAreaBounds: TRect; AState: TcxButtonState; AAlignmentHorz: TAlignment;
      AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor); override;
    procedure DrawHeaderControlSectionText(ACanvas: TcxCanvas;
      const ATextAreaBounds: TRect; AState: TcxButtonState;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
      AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor: TColor); override;
    procedure DrawHeaderSeparator(ACanvas: TcxCanvas; const ABounds: TRect;
      AIndentSize: Integer; AColor: TColor; AViewParams: TcxViewParams); override;
    procedure DrawSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean); override;
    function HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders; override;
    function HeaderBorderSize: Integer; override;
    function HeaderBounds(const ABounds: TRect; ANeighbors: TcxNeighbors;
      ABorders: TcxBorders = cxBordersAll): TRect; override;
    function HeaderContentBounds(const ABounds: TRect; ABorders: TcxBorders): TRect; override;
    function HeaderDrawCellsFirst: Boolean; override;
    function HeaderHeight(AFontHeight: Integer): Integer; override;
    function HeaderControlSectionBorderSize(
      AState: TcxButtonState = cxbsNormal): Integer; override;
    function HeaderControlSectionTextAreaBounds(ABounds: TRect;
      AState: TcxButtonState): TRect; override;
    function HeaderControlSectionContentBounds(const ABounds: TRect;
      AState: TcxButtonState): TRect; override;
    function HeaderWidth(ACanvas: TcxCanvas; ABorders: TcxBorders;
      const AText: string; AFont: TFont): Integer; override;
    function IsHeaderHotTrack: Boolean; override;
    function SortingMarkAreaSize: TPoint; override;
    function SortingMarkSize: TPoint; override;
    // grid
    procedure DrawGroupByBox(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap); override;
    // footer
    function FooterBorders: TcxBorders; override;
    function FooterBorderSize: Integer; override;
    function FooterCellBorderSize: Integer; override;
    function FooterCellOffset: Integer; override;
    function FooterDrawCellsFirst: Boolean; override;
    function FooterSeparatorColor: TColor; override;
    function FooterSeparatorSize: Integer; override;
    procedure DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect;
      AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean;
      const AText: string; AFont: TFont; ATextColor, ABkColor: TColor;
      AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect); override;
    procedure DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect); override;
    procedure DrawFooterContent(ACanvas: TcxCanvas; const ARect: TRect;
      const AViewParams: TcxViewParams); override;
    procedure DrawFooterSeparator(ACanvas: TcxCanvas; const R: TRect); override;
    // filter
    procedure DrawFilterActivateButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean); override;
    procedure DrawFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean); override;
    procedure DrawFilterPanel(ACanvas: TcxCanvas; const ARect: TRect;
      ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap); override;
    function FilterActivateButtonSize: TPoint; override;
    function FilterCloseButtonSize: TPoint; override;
    function FilterDropDownButtonSize: TPoint; override;
    // popup
    procedure DrawWindowContent(ACanvas: TcxCanvas; const ARect: TRect); override;
    function PopupBorderStyle: TcxPopupBorderStyle; override;
    // tabs
    procedure DrawTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders;
      const AText: string; AState: TcxButtonState; AVertical: Boolean; AFont: TFont;
      ATextColor, ABkColor: TColor; AShowPrefix: Boolean = False); override;
    procedure DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean); override;
    procedure DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean); override;
    function IsDrawTabImplemented(AVertical: Boolean): Boolean; override;
    function IsTabHotTrack(AVertical: Boolean): Boolean; override;
    function TabBorderSize(AVertical: Boolean): Integer; override;
    // indicator
    procedure DrawIndicatorCustomizationMark(ACanvas: TcxCanvas;
      const R: TRect; AColor: TColor); override;
    procedure DrawIndicatorImage(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind); override;
    procedure DrawIndicatorItem(ACanvas: TcxCanvas; const R: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawIndicatorItemEx(ACanvas: TcxCanvas; const R: TRect;
      AKind: TcxIndicatorKind; AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    function IndicatorDrawItemsFirst: Boolean; override;
    // scrollbars
    function ScrollBarMinimalThumbSize(AVertical: Boolean): Integer; override;
    procedure DrawScrollBarPart(ACanvas: TcxCanvas; AHorizontal: Boolean;
      R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState); override;
    // size grip
    function SizeGripSize: TSize; override;
    procedure DrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor = clDefault{$IFDEF VER653}; ACorner: TdxCorner = coBottomRight{$ENDIF}); override;
    // ms outlook
    procedure CalculateSchedulerNavigationButtonRects(AIsNextButton: Boolean;
      ACollapsed: Boolean; APrevButtonTextSize: TSize; ANextButtonTextSize: TSize;
      var ABounds: TRect; out ATextRect: TRect; out AArrowRect: TRect); override;
    procedure DrawMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect;
      const AText: string; ANeighbors: TcxNeighbors; const AViewParams: TcxViewParams;
      AArrows: {$IFDEF VER23} TcxArrowDirections {$ELSE} TcxHeaderArrows {$ENDIF}; ASideWidth: Integer; AOnDrawBackground: TcxDrawBackgroundEvent = nil); override;
    procedure DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect); override;
    procedure DrawSchedulerEventProgress(ACanvas: TcxCanvas;
      const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean); override;
    procedure DrawSchedulerNavigationButton(ACanvas: TcxCanvas;
      const ARect: TRect; AIsNextButton: Boolean; AState: TcxButtonState;
      const AText: string; const ATextRect: TRect; const AArrowRect: TRect); override;
    procedure DrawSchedulerNavigationButtonArrow(ACanvas: TcxCanvas;
      const ARect: TRect; AIsNextButton: Boolean; AColor: TColor); override;
    procedure DrawSchedulerNavigatorButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState); override;
    procedure DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean); override;
    function SchedulerEventProgressOffsets: TRect; override;
    procedure SchedulerNavigationButtonSizes(AIsNextButton: Boolean;
      var ABorders: TRect; var AArrowSize: TSize{$IFDEF VER645}; var AHasTextArea: Boolean{$ENDIF}); override;
    // chart view
    function ChartToolBoxDataLevelInfoBorderSize: Integer; override;
    // editors
    procedure DrawClock(ACanvas: TcxCanvas; const ARect: TRect;
      ADateTime: TDateTime; ABackgroundColor: TColor); override;
    procedure DrawEditorButton(ACanvas: TcxCanvas; const ARect: TRect;
      AButtonKind: TcxEditBtnKind; AState: TcxButtonState{$IFDEF VER653}; APosition: TcxEditBtnPosition = cxbpRight{$ENDIF}); override;
    function EditButtonTextOffset: Integer; override;
    function EditButtonSize: TSize; override;
    function EditButtonTextColor: TColor; override;
    function GetContainerBorderColor(AIsHighlightBorder: Boolean): TColor; override;
    // navigator
{$IFNDEF VER23}
    procedure DrawNavigatorGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList;
      AImageIndex: TImageIndex; AButtonIndex: Integer; const AGlyphRect: TRect;
      AEnabled: Boolean; AUserGlyphs: Boolean); override;
    function NavigatorGlyphSize: TSize; override;
{$ENDIF}
    // ProgressBar
    procedure DrawProgressBarBorder(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean); override;
    procedure DrawProgressBarChunk(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean); override;
    function ProgressBarBorderSize(AVertical: Boolean): TRect; override;
    function ProgressBarTextColor: TColor; override;
    // GroupBox
    procedure DrawGroupBoxBackground(ACanvas: TcxCanvas; ABounds: TRect; ARect: TRect); override;
{$IFDEF VER26}
    procedure DrawGroupBoxCaption(ACanvas: TcxCanvas; const ACaptionRect, ATextRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition); override;
{$ELSE}
    procedure DrawGroupBoxCaption(ACanvas: TcxCanvas; ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition); override;
{$ENDIF}
    procedure DrawGroupBoxContent(ACanvas: TcxCanvas; ABorderRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition{$IFDEF VER640}; ABorders: TcxBorders = cxBordersAll{$ENDIF}); override;
    function GroupBoxBorderSize(ACaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TRect; override;
    function GroupBoxTextColor({$IFDEF VER645}AEnabled: Boolean;{$ENDIF} ACaptionPosition: TcxGroupBoxCaptionPosition): TColor; override;
    function IsGroupBoxTransparent(AIsCaption: Boolean;
      ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean; override;
    // Panel
    procedure DrawPanelBackground(ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect;
      AColorFrom: TColor = clDefault; AColorTo: TColor = clDefault); override;
    procedure DrawPanelBorders(ACanvas: TcxCanvas; const ABorderRect: TRect); override;
    procedure DrawPanelCaption(ACanvas: TcxCanvas; const ACaptionRect: TRect;
      ACaptionPosition: TcxGroupBoxCaptionPosition); override;
    procedure DrawPanelContent(ACanvas: TcxCanvas; const ABorderRect: TRect;
      ABorder: Boolean); override;
    function PanelBorderSize: TRect; override;
    function PanelTextColor: TColor; override;
    // TrackBar
{$IFDEF VER650}
    procedure CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign); override;
    procedure DrawTrackBarTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect; AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor); override;
    procedure DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect); override;
//    procedure DrawTrackBarThumb(ACanvas: TcxCanvas; const ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean;
//      ATicks: TcxTrackBarTicksAlign; AThumbColor: TColor); virtual;
    procedure DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas; const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPointArray); override;
    procedure DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect); override;
{$ELSE}
    procedure DrawTrackBar(ACanvas: TcxCanvas; const ARect: TRect;
      const ASelection: TRect; AShowSelection: Boolean; AEnabled: Boolean;
      AHorizontal: Boolean); override;
    procedure DrawTrackBarThumb(ACanvas: TcxCanvas; ARect: TRect; AState: TcxButtonState;
      AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign); override;
{$ENDIF}
    function TrackBarThumbSize(AHorizontal: Boolean): TSize; override;
    function TrackBarTicksColor(AText: Boolean): TColor; override;
    function TrackBarTrackSize: Integer; override;
    // Splitter
//    procedure DrawSplitter(ACanvas: TcxCanvas; const ARect: TRect;
//      AHighlighted: Boolean; AClicked: Boolean; AHorizontal: Boolean); override;
    function GetSplitterSize(AHorizontal: Boolean): TSize; override;
  end;

{$IFDEF VER12_1_6}
  TcxACPCPainter = class(TcxPCTabsPainter)
  protected
    function GetFreeSpaceColor: TColor; override;
    function AlwaysColoredTabs: Boolean; override;
    procedure InternalPaintTab(ACanvas: TcxCanvas; ATabVisibleIndex: Integer); override;
    function GetClientColor: TColor; override;
    function GetTabBodyColor(TabVisibleIndex: Integer): TColor; override;
    procedure PaintFrameBorder(ACanvas: TcxCanvas; R: TRect); override;
  public
    class function GetStyleID: TcxPCStyleID; override;
    class function GetStyleName: TCaption; override;
  end;
{$ENDIF}


{.$DEFINE ACDEBUG}

implementation

uses sGraphUtils, sSkinProps, acntUtils, sConst, sAlphaGraph, math, sVCLUtils, cxControls,
  sThirdParty, dxSkinInfo;

var
  DefManager : TsSkinManager = nil;
  OldDXSkin : string;

type
  TAcesscxControl = class(TcxControl);

const
  s_AlphaSkins = 'AlphaSkins';
  GetState : array [cxbsDefault..cxbsDisabled] of integer = (0, 0, 1, 2, 0);

procedure Register;
begin
  RegisterComponents('AlphaAdditional', [TsDevExProvider]);
end;

procedure Debugalert(const s : string);
begin
{$IFDEF ACDEBUG}
  Alert(s);
{$ENDIF}
end;

function Skinned : boolean;
begin
  DefManager := DefaultManager;
  if DefManager <> nil then Result := DefManager.SkinData.Active else Result := False
end;

{ TcxACLookAndFeelPainter }

{$IFNDEF VER23}
function TcxACLookAndFeelPainter.AdjustGroupButtonDisplayRect(const R: TRect; AButtonCount, AButtonIndex: Integer): TRect;
begin // +
  Result := inherited AdjustGroupButtonDisplayRect(R, AButtonCount, AButtonIndex);
end;

function TcxACLookAndFeelPainter.ButtonGroupBorderSizes(AButtonCount, AButtonIndex: Integer): TRect;
begin // +
  Result := inherited ButtonGroupBorderSizes(AButtonCount, AButtonIndex)
end;

procedure TcxACLookAndFeelPainter.DrawButtonGroupBorder(ACanvas: TcxCanvas; R: TRect; AInplace, ASelected: Boolean);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawButtonInGroup(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AButtonCount, AButtonIndex: Integer; ABackgroundColor: TColor);
var
  i : integer;
  TmpBmp : TBitmap;
  State : integer;
  CI : TCacheInfo;
begin
  if Skinned then begin
    i := DefaultManager.GetSkinIndex(s_ToolButton);
    if DefaultManager.IsValidSkinIndex(i) then begin
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      TmpBmp := CreateBmp32(WidthOf(R), HeightOf(R));
      CI.Bmp := nil;
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      PaintItem(i, s_ToolButton, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
      BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end else inherited
end;

procedure TcxACLookAndFeelPainter.DrawNavigatorGlyph(ACanvas: TcxCanvas; AImageList: TCustomImageList;
  AImageIndex: TImageIndex; AButtonIndex: Integer; const AGlyphRect: TRect; AEnabled, AUserGlyphs: Boolean);
begin
  inherited;
end;

function TcxACLookAndFeelPainter.NavigatorGlyphSize: TSize;
begin
  Result := Size(10, 12) // inherited NavigatorGlyphSize
end;

{$ENDIF}
function TcxACLookAndFeelPainter.BorderSize: Integer;
begin // +
  if Skinned then Result := 2 else Result := inherited BorderSize;
end;

function TcxACLookAndFeelPainter.ButtonBorderSize(AState: TcxButtonState): Integer;
begin // +
  if Skinned then Result := 4 else Result := inherited ButtonBorderSize(AState)
end;

function TcxACLookAndFeelPainter.ButtonColor(AState: TcxButtonState): TColor;
begin // +
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited ButtonColor(AState);
end;

function TcxACLookAndFeelPainter.ButtonFocusRect(ACanvas: TcxCanvas; R: TRect): TRect;
begin // +
  Result := inherited ButtonFocusRect(ACanvas, R);
end;

function TcxACLookAndFeelPainter.ButtonSymbolColor(AState: TcxButtonState; ADefaultColor: TColor): TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited ButtonSymbolColor(AState, ADefaultColor);
end;

function TcxACLookAndFeelPainter.ButtonSymbolState(AState: TcxButtonState): TcxButtonState;
begin // +
  Result := inherited ButtonSymbolState(AState);
end;

function TcxACLookAndFeelPainter.ButtonTextOffset: Integer;
begin // +
  Result := inherited ButtonTextOffset;
end;

function TcxACLookAndFeelPainter.ButtonTextShift: Integer;
begin // +
  Result := inherited ButtonTextShift
end;

procedure TcxACLookAndFeelPainter.CalculateSchedulerNavigationButtonRects(
  AIsNextButton, ACollapsed: Boolean; APrevButtonTextSize, ANextButtonTextSize: TSize; var ABounds: TRect; out ATextRect, AArrowRect: TRect);
begin // +
  inherited CalculateSchedulerNavigationButtonRects(AIsNextButton, ACollapsed, APrevButtonTextSize, ANextButtonTextSize, ABounds, ATextRect, AArrowRect);
end;

function TcxACLookAndFeelPainter.ChartToolBoxDataLevelInfoBorderSize: Integer;
begin // +
  Result := inherited ChartToolBoxDataLevelInfoBorderSize;
end;

function TcxACLookAndFeelPainter.CheckBorderSize: Integer;
begin // +
  if Skinned then Result := 0 else Result := inherited CheckBorderSize;
end;

{$IFDEF VER12_2_3}    
function TcxACLookAndFeelPainter.CheckButtonColor(AState: TcxButtonState; ACheckState: TcxCheckBoxState): TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited CheckButtonColor(AState, ACheckState);
end;
{$ELSE}
function TcxACLookAndFeelPainter.CheckButtonColor(AState: TcxButtonState): TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited CheckButtonColor(AState);
end;
{$ENDIF}

function TcxACLookAndFeelPainter.CheckButtonSize: TSize;
var
  Ndx : integer;
begin // +
  if Skinned then begin
    if DefaultManager.ConstData.SmallCheckBoxChecked > -1
      then Ndx := DefaultManager.ConstData.SmallCheckBoxChecked
      else Ndx := DefaultManager.ConstData.CheckBoxChecked;
    if Ndx > -1 then begin
      Result.cx := WidthOfImage(DefaultManager.ma[Ndx]);
      Result.cy := HeightOfImage(DefaultManager.ma[Ndx]);
    end
    else Result := inherited CheckButtonSize;
  end
  else Result := inherited CheckButtonSize;
end;

function TcxACLookAndFeelPainter.DefaultSizeGripAreaColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.GetActiveEditColor else Result := inherited DefaultSizeGripAreaColor
end;

function TcxACLookAndFeelPainter.DefaultVGridCategoryColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultVGridCategoryColor;
end;

function TcxACLookAndFeelPainter.DefaultVGridCategoryTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultVGridCategoryTextColor;
end;

function TcxACLookAndFeelPainter.DefaultVGridLineColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 0.3) else Result := inherited DefaultVGridLineColor;
end;

function TcxACLookAndFeelPainter.DefaultVGridBandLineColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 0.3) else Result := inherited DefaultVGridBandLineColor;
end;

function TcxACLookAndFeelPainter.DefaultContentColor: TColor;
begin // +
  if Skinned
    then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, 0.5)
    else Result := inherited DefaultContentColor
end;

function TcxACLookAndFeelPainter.DefaultContentEvenColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.Palette[pcEditBG_EvenRow] else Result := inherited DefaultContentEvenColor;
end;

function TcxACLookAndFeelPainter.DefaultContentOddColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.Palette[pcEditBG_OddRow] else Result := inherited DefaultContentOddColor;
end;

function TcxACLookAndFeelPainter.DefaultContentTextColor: TColor;
var
  i : integer;
begin // +
  if Skinned then begin
    i := DefaultManager.GetSkinIndex(s_Edit);
    if DefaultManager.IsValidSkinIndex(i) then Result := DefaultManager.gd[i].FontColor[1] else Result := 0;
  end
  else Result := inherited DefaultContentTextColor
end;

function TcxACLookAndFeelPainter.DefaultDateNavigatorHeaderColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultDateNavigatorHeaderColor;
end;

function TcxACLookAndFeelPainter.DefaultDateNavigatorSelectionColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetHighLightColor else Result := inherited DefaultDateNavigatorSelectionColor;
end;

function TcxACLookAndFeelPainter.DefaultDateNavigatorSelectionTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetHighLightFontColor else Result := inherited DefaultDateNavigatorSelectionTextColor;
end;

function TcxACLookAndFeelPainter.DefaultEditorBackgroundColor(AIsDisabled: Boolean): TColor;
begin // +
  if Skinned then begin
    if AIsDisabled then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, 0.5) else Result := DefaultManager.GetActiveEditColor;
  end
  else Result := inherited DefaultEditorBackgroundColor(AIsDisabled);
end;

function TcxACLookAndFeelPainter.DefaultEditorBackgroundColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  if Skinned then begin
    Result := DefaultManager.GetActiveEditColor;
  end
  else Result := inherited DefaultEditorBackgroundColorEx(AKind);
end;

function TcxACLookAndFeelPainter.DefaultEditorTextColor(AIsDisabled: Boolean): TColor;
begin // +
  if Skinned then begin
    if AIsDisabled
      then Result := MixColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 0.5)
      else Result := DefaultManager.GetActiveEditFontColor;
  end
  else Result := inherited DefaultEditorTextColor(AIsDisabled);
end;

function TcxACLookAndFeelPainter.DefaultEditorTextColorEx(AKind: TcxEditStateColorKind): TColor;
begin
  Result := inherited DefaultEditorTextColorEx(AKind)
end;

function TcxACLookAndFeelPainter.DefaultSchedulerBackgroundColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultSchedulerBackgroundColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultSchedulerTextColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerBorderColor: TColor;
begin
  if Skinned then Result := DefaultManager.Palette[pcBorder] else Result := inherited DefaultSchedulerBorderColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerControlColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultSchedulerControlColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerNavigatorColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultSchedulerNavigatorColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerViewContentColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetGlobalColor, 0.5) else Result := inherited DefaultSchedulerViewContentColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerViewSelectedTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetHighLightFontColor else Result := inherited DefaultSchedulerViewSelectedTextColor;
end;

function TcxACLookAndFeelPainter.DefaultSchedulerViewTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetActiveEditFontColor else Result := inherited DefaultSchedulerViewTextColor;
end;

function TcxACLookAndFeelPainter.DefaultSelectionColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.GetHighLightColor else Result := inherited DefaultSelectionColor;
end;

function TcxACLookAndFeelPainter.DefaultSelectionTextColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.GetHighLightFontColor else Result := inherited DefaultSelectionTextColor;
end;

function TcxACLookAndFeelPainter.DefaultSeparatorColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultSeparatorColor;
end;

function TcxACLookAndFeelPainter.DefaultFilterBoxColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultFilterBoxColor
end;

function TcxACLookAndFeelPainter.DefaultFilterBoxTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultFilterBoxTextColor
end;

function TcxACLookAndFeelPainter.DefaultFixedSeparatorColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.Palette[pcBorder], DefaultManager.GetActiveEditColor, 0.5) else Result := inherited DefaultFixedSeparatorColor;
end;

function TcxACLookAndFeelPainter.DefaultFooterColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetActiveEditColor else Result := inherited DefaultFooterColor
end;

function TcxACLookAndFeelPainter.DefaultFooterTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetActiveEditFontColor else Result := inherited DefaultFooterTextColor
end;

function TcxACLookAndFeelPainter.DefaultGridDetailsSiteColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultGridDetailsSiteColor;
end;

function TcxACLookAndFeelPainter.DefaultGridLineColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 0.3) else Result := inherited DefaultGridLineColor;
end;

function TcxACLookAndFeelPainter.DefaultGroupByBoxColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultGroupByBoxColor
end;

function TcxACLookAndFeelPainter.DefaultHeaderTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetActiveEditFontColor else Result := inherited DefaultHeaderTextColor;
end;

function TcxACLookAndFeelPainter.DefaultHyperlinkTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.Palette[pcWebText] else Result := inherited DefaultHyperlinkTextColor;
end;

function TcxACLookAndFeelPainter.DefaultGroupByBoxTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultGroupByBoxTextColor
end;

function TcxACLookAndFeelPainter.DefaultGroupColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultGroupColor;
end;

function TcxACLookAndFeelPainter.DefaultGroupTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultGroupTextColor
end;

function TcxACLookAndFeelPainter.DefaultHeaderBackgroundColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultHeaderBackgroundColor
end;

function TcxACLookAndFeelPainter.DefaultHeaderBackgroundTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultHeaderBackgroundTextColor;
end;

function TcxACLookAndFeelPainter.DefaultHeaderColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultHeaderColor
end;

function TcxACLookAndFeelPainter.DefaultInactiveColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetHighLightColor(False) else Result := inherited DefaultInactiveColor
end;

function TcxACLookAndFeelPainter.DefaultInactiveTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetHighLightFontColor(False) else Result := inherited DefaultInactiveTextColor
end;

function TcxACLookAndFeelPainter.DefaultPreviewTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultPreviewTextColor;
end;

function TcxACLookAndFeelPainter.DefaultRecordSeparatorColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultRecordSeparatorColor;
end;

function TcxACLookAndFeelPainter.DefaultTabColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultTabColor
end;

function TcxACLookAndFeelPainter.DefaultTabTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultTabTextColor;
end;

function TcxACLookAndFeelPainter.DefaultTabsBackgroundColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultTabsBackgroundColor
end;

function TcxACLookAndFeelPainter.DefaultChartDiagramValueBorderColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 0.2) else Result := inherited DefaultChartDiagramValueBorderColor;
end;

function TcxACLookAndFeelPainter.DefaultChartDiagramValueCaptionTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetActiveEditFontColor else Result := inherited DefaultChartDiagramValueCaptionTextColor;
end;

function TcxACLookAndFeelPainter.DefaultChartHistogramAxisColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 0.3) else Result := inherited DefaultChartHistogramAxisColor;
end;

function TcxACLookAndFeelPainter.DefaultChartHistogramGridLineColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 0.8) else Result := inherited DefaultChartHistogramGridLineColor;
end;

function TcxACLookAndFeelPainter.DefaultChartHistogramPlotColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetActiveEditColor else Result := inherited DefaultChartHistogramPlotColor;
end;

function TcxACLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteBorderColor: TColor;
begin
  if Skinned then Result := clNavy else Result := inherited DefaultChartPieDiagramSeriesSiteBorderColor;
end;

function TcxACLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteCaptionColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited DefaultChartPieDiagramSeriesSiteCaptionColor;
end;

function TcxACLookAndFeelPainter.DefaultChartPieDiagramSeriesSiteCaptionTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultChartPieDiagramSeriesSiteCaptionTextColor;
end;

function TcxACLookAndFeelPainter.DefaultChartToolBoxDataLevelInfoBorderColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 0.5) else Result := inherited DefaultChartToolBoxDataLevelInfoBorderColor;
end;

function TcxACLookAndFeelPainter.DefaultChartToolBoxItemSeparatorColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetActiveEditColor, DefaultManager.GetActiveEditFontColor, 0.8) else Result := inherited DefaultChartToolBoxItemSeparatorColor;
end;

function TcxACLookAndFeelPainter.DefaultTimeGridMajorScaleColor: TColor;
begin // +
  if Skinned then Result := MixColors(DefaultManager.GetGlobalColor, DefaultManager.GetActiveEditColor, 0.5) else Result := inherited DefaultTimeGridMajorScaleColor
end;

function TcxACLookAndFeelPainter.DefaultTimeGridMajorScaleTextColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultTimeGridMajorScaleTextColor
end;

function TcxACLookAndFeelPainter.DefaultTimeGridMinorScaleColor: TColor;
begin // +
  if Skinned then Result := MixColors(DefaultManager.GetGlobalColor, DefaultManager.GetActiveEditColor, 0.9) else Result := inherited DefaultTimeGridMinorScaleColor
end;

function TcxACLookAndFeelPainter.DefaultTimeGridMinorScaleTextColor: TColor;
begin // +
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited DefaultTimeGridMinorScaleTextColor
end;

function TcxACLookAndFeelPainter.DefaultTimeGridSelectionBarColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetGlobalColor, DefaultManager.GetActiveEditColor, 0.5) else Result := inherited DefaultTimeGridSelectionBarColor
end;

procedure TcxACLookAndFeelPainter.DrawArrow(ACanvas: TcxCanvas; const R: TRect; AArrowDirection: TcxArrowDirection; AColor: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawArrow(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection; ADrawBorder: Boolean);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawArrowBorder(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawBorder(ACanvas: TcxCanvas; R: TRect);
var
  i, m : integer;
  Bmp : TBitmap;
begin
  if Skinned then begin
    i := DefaultManager.GetSkinIndex(s_Edit);
    m := DefaultManager.GetMaskIndex(i, s_Edit, s_BordersMask);
    if DefaultManager.IsValidImgIndex(m) then begin
      Bmp := CreateBmp32(WidthOf(R), HeightOf(R));
      PaintSection(Bmp, s_Edit, s_Edit, 0, DefaultManager, R.TopLeft, DefaultManager.GetGlobalColor);
      BitBltBorder(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom, Bmp.Canvas.Handle, 0, 0, 3);
      FreeAndNil(Bmp);
    end;
  end
  else inherited DrawBorder(ACanvas, R)
end;

procedure TcxACLookAndFeelPainter.DrawButton;
var
  i : integer;
  TmpBmp : TBitmap;
  State : integer;
  CI : TCacheInfo;
  rText : TRect;
begin
  if Skinned then begin
    i := DefaultManager.GetSkinIndex(s_Button);
    if DefaultManager.IsValidSkinIndex(i) then begin
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      TmpBmp := CreateBmp32(WidthOf(R), HeightOf(R));
      CI.Bmp := nil;
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      PaintItem(i, s_Button, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
      if State = 0 then ACanvas.Font.Color := DefaultManager.gd[i].FontColor[1] else ACanvas.Font.Color := DefaultManager.gd[i].HotFontColor[1];

      if ACaption <> '' then begin
        TmpBmp.Canvas.Font.Color := ACanvas.Font.Color;
        TmpBmp.Canvas.Brush.Style := bsClear;
        rText := Rect(0, 0, TmpBmp.Width, TmpBmp.Height);
        DrawText(TmpBmp.Canvas.Handle, PChar(ACaption), Length(ACaption), rText, DT_EXPANDTABS or DT_VCENTER or DT_CENTER or DT_SINGLELINE);
      end;
      BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else inherited DrawButton(ACanvas, R, ACaption, AState, ADrawBorder, AColor, ATextColor)
end;

procedure TcxACLookAndFeelPainter.DrawButtonBorder(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin // +
  if not Skinned then inherited;
end;

procedure TcxACLookAndFeelPainter.DrawCheck(ACanvas: TcxCanvas; const R: TRect; AState: TcxButtonState; AChecked: Boolean; AColor: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawCheckBorder(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; ACheckState: TcxCheckBoxState);
var
  State, i : integer;
  TmpBmp : TBitmap;
  Size : TSize;
begin
  if Skinned then begin
    i := -1;
    case ACheckState of
      cbsUnchecked : if DefaultManager.ConstData.SmallCheckBoxUnChecked > -1 then i := DefaultManager.ConstData.SmallCheckBoxUnChecked else i := DefaultManager.ConstData.CheckBoxUnChecked;
      cbsChecked : if DefaultManager.ConstData.SmallCheckBoxChecked > -1 then i := DefaultManager.ConstData.SmallCheckBoxChecked else i := DefaultManager.ConstData.CheckBoxChecked;
      cbsGrayed : if DefaultManager.ConstData.SmallCheckBoxGrayed > -1 then i := DefaultManager.ConstData.SmallCheckBoxGrayed else i := DefaultManager.ConstData.CheckBoxGrayed;
    end;
    if DefaultManager.IsValidImgIndex(i) then begin
      Size.cx := WidthOfImage(DefaultManager.ma[i]);
      Size.cy := HeightOfImage(DefaultManager.ma[i]);
      TmpBmp := CreateBmp32(Size.cx, Size.cy);
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Size.cx, Size.cy, ACanvas.Handle, R.Left, R.Top, SRCCOPY);
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;

      if State > DefaultManager.ma[i].ImageCount - 1 then State := DefaultManager.ma[i].ImageCount - 1;

      DrawSkinGlyph(TmpBmp, Point(0, 0), State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, R.Left, R.Top, Size.cx, Size.cy, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end else inherited DrawCheckButton(ACanvas, R, AState, ACheckState)
end;

procedure TcxACLookAndFeelPainter.DrawClock(ACanvas: TcxCanvas; const ARect: TRect; ADateTime: TDateTime; ABackgroundColor: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawContainerBorder(ACanvas: TcxCanvas;
  const R: TRect; AStyle: TcxContainerBorderStyle; AWidth: Integer; AColor: TColor; ABorders: TcxBorders);
var
  i, m : integer;
  Bmp : TBitmap;
begin
  if Skinned then begin
    case AStyle of
      cbs3D : begin
        i := DefaultManager.GetSkinIndex(s_Edit);
        m := DefaultManager.GetMaskIndex(i, s_Edit, s_BordersMask);
        if DefaultManager.IsValidImgIndex(m) then begin
          Bmp := CreateBmp32(WidthOf(R), HeightOf(R));
          PaintSection(Bmp, s_Edit, s_Edit, 0, DefaultManager, R.TopLeft, DefaultManager.GetGlobalColor);
          BitBltBorder(ACanvas.Handle, R.Left, R.Top, R.Right, R.Bottom, Bmp.Canvas.Handle, 0, 0, 3);
          FreeAndNil(Bmp);
        end;
      end
      else inherited;
    end;
  end
  else inherited
end;

procedure TcxACLookAndFeelPainter.DrawEditorButton(ACanvas: TcxCanvas; const ARect: TRect; AButtonKind: TcxEditBtnKind; AState: TcxButtonState{$IFDEF VER653}; APosition: TcxEditBtnPosition = cxbpRight{$ENDIF});
var
  i, glIndex : integer;
  TmpBmp : TBitmap;
  State : integer;
  CI : TCacheInfo;
  R : TRect;
  s, sSect : string;
begin
  if Skinned then begin
    case AButtonKind of
      cxbkComboBtn : begin
        i := DefaultManager.ConstData.ComboBtnIndex;
        sSect := s_ComboBtn;
      end
      else begin
        i := DefaultManager.GetSkinIndex(s_UpDown);
        if i < 0 then begin
          i := DefaultManager.GetSkinIndex(s_Button);
          sSect := s_Button;
        end
        else sSect := s_ComboBtn;
      end;
    end;
    R := ARect;
    TmpBmp := CreateBmp32(WidthOf(R), HeightOf(R));
    CI.Bmp := nil;
    CI.FillColor := DefaultManager.GetActiveEditColor;
    CI.Ready := False;
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
    if DefaultManager.IsValidSkinIndex(i)
      then PaintItem(i, sSect, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager)
      else FillDC(TmpBmp.Canvas.Handle, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), CI.FillColor);
    glIndex := -1;
    case AButtonKind of
      cxbkCloseBtn : s := 'X';
      cxbkEditorBtn : s := '';
      cxbkEllipsisBtn : s := '...';
      cxbkSpinUpBtn : glIndex := DefaultManager.ConstData.MaskArrowTop;
      cxbkSpinDownBtn : glIndex := DefaultManager.ConstData.MaskArrowBottom;
      cxbkSpinLeftBtn : glIndex := DefaultManager.ConstData.MaskArrowLeft;
      cxbkSpinRightBtn : glIndex := DefaultManager.ConstData.MaskArrowRight;
      cxbkComboBtn : glIndex := DefaultManager.ConstData.ComboGlyph;
    end;
    if glIndex > -1 then begin
      DrawSkinGlyph(TmpBmp, Point((WidthOf(R) - WidthOfImage(DefaultManager.ma[glIndex])) div 2,
        (HeightOf(R) - HeightOfImage(DefaultManager.ma[glIndex])) div 2), State, 1, DefaultManager.ma[glIndex], MakeCacheInfo(TmpBmp));
    end
    else case AButtonKind of
      cxbkCloseBtn, {cxbkEditorBtn, }cxbkEllipsisBtn : begin
        if State = 0 then TmpBmp.Canvas.Font.Color := DefaultManager.gd[i].FontColor[1] else TmpBmp.Canvas.Font.Color := DefaultManager.gd[i].HotFontColor[1];
        TmpBmp.Canvas.Font.Style := [fsBold];
        TmpBmp.Canvas.Brush.Style := bsClear;
        R := Rect(0, 0, TmpBmp.Width, TmpBmp.Height);
        DrawText(TmpBmp.Canvas.Handle, PChar(s), Length(s), R, {DT_EXPANDTABS + }DT_VCENTER + DT_CENTER + DT_SINGLELINE{v6.44});
      end;
    end;
    BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    FreeAndNil(TmpBmp);
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AColor: TColor);
var
  ARect: TRect;
begin
  if Skinned then begin
    ARect := R;
    DrawButton(ACanvas, ARect, '', cxbsNormal, True, AColor);
    InflateRect(ARect, -1, -1);
    DrawExpandButtonCross(ACanvas, ARect, AExpanded, DefaultManager.GetGlobalFontColor);
    ACanvas.ExcludeClipRect(R);
  end
  else inherited DrawExpandButton(ACanvas, R, AExpanded, AColor);
end;

function TcxACLookAndFeelPainter.DrawExpandButtonFirst: Boolean;
begin // +
  Result := inherited DrawExpandButtonFirst;
end;

procedure TcxACLookAndFeelPainter.DrawCheckButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean);
var
  State, i, NewLeft, NewTop : integer;
  TmpBmp : TBitmap;
  Size : TSize;
begin
  if Skinned then begin
    if AChecked then i := DefaultManager.ConstData.SmallCheckBoxChecked else i := DefaultManager.ConstData.SmallCheckBoxUnChecked;
    if DefaultManager.IsValidImgIndex(i) then begin
      Size.cx := WidthOfImage(DefaultManager.ma[i]);
      Size.cy := HeightOfImage(DefaultManager.ma[i]);
      TmpBmp := CreateBmp32(Size.cx, Size.cy);
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Size.cx, Size.cy, ACanvas.Handle, R.Left, R.Top, SRCCOPY);
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      if State > DefaultManager.ma[i].ImageCount - 1 then State := DefaultManager.ma[i].ImageCount - 1;
      NewLeft := (WidthOf(R) - Size.cx) div 2;
      Newtop := (HeightOf(R) - Size.cy) div 2;
      DrawSkinGlyph(TmpBmp, Point(NewLeft, NewTop), State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));

      BitBlt(ACanvas.Handle, R.Left, R.Top, Size.cx, Size.cy, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else inherited
end;

procedure TcxACLookAndFeelPainter.DrawRadioButton(ACanvas: TcxCanvas; X, Y: Integer; AButtonState: TcxButtonState; AChecked, AFocused: Boolean; ABrushColor: TColor;  AIsDesigning: Boolean = False);
var
  State, i : integer;
  TmpBmp : TBitmap;
  Size : TSize;
begin // +
  if Skinned then begin
    if AChecked then i := DefaultManager.ConstData.RadioButtonChecked else i := DefaultManager.ConstData.RadioButtonUnChecked;
    if DefaultManager.IsValidImgIndex(i) then begin
      Size.cx := WidthOfImage(DefaultManager.ma[i]);
      Size.cy := HeightOfImage(DefaultManager.ma[i]);
      TmpBmp := CreateBmp32(Size.cx, Size.cy);

      BitBlt(TmpBmp.Canvas.Handle, 0, 0, Size.cx, Size.cy, ACanvas.Handle, X, Y, SRCCOPY);
      case AButtonState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      if State > DefaultManager.ma[i].ImageCount - 1 then State := DefaultManager.ma[i].ImageCount - 1;
      DrawSkinGlyph(TmpBmp, Point(0, 0), State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, X, Y, Size.cx, Size.cy, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);

      FreeAndNil(TmpBmp);
    end;
  end
  else inherited DrawRadioButton(ACanvas, X, Y, AButtonState, AChecked, AFocused, ABrushColor, AIsDesigning)
end;

function TcxACLookAndFeelPainter.RadioButtonSize: TSize;
var
  i : integer;
begin // +
  if Skinned then begin
    i := DefaultManager.GetMaskIndex(DefaultManager.ConstData.IndexGLobalInfo, s_GLobalInfo, s_RadioButtonChecked);
    if DefaultManager.IsValidImgIndex(i) then begin
      Result.cx := WidthOfImage(DefaultManager.ma[i]);
      Result.cy := HeightOfImage(DefaultManager.ma[i]);
    end
    else inherited RadioButtonSize;
  end
  else Result := inherited RadioButtonSize;
end;

procedure TcxACLookAndFeelPainter.DrawFilterActivateButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AChecked: Boolean);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawFilterCloseButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
var
  i : integer;
  TmpBmp : TBitmap;
  State : integer;
  CI : TCacheInfo;
begin
  if Skinned then begin
    i := DefaultManager.GetMaskIndex(DefaultManager.ConstData.IndexGLobalInfo, s_GlobalInfo, s_SmallIconClose);
    if i < 0 then i := DefaultManager.GetMaskIndex(DefaultManager.ConstData.IndexGLobalInfo, s_GlobalInfo, s_BorderIconClose);
    if DefaultManager.IsValidImgIndex(i) then begin
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      TmpBmp := CreateBmp32(WidthOf(R), HeightOf(R));

      FillDC(TmpBmp.Canvas.Handle, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), DefaultManager.GetGlobalColor);

      CI := MakeCacheInfo(TmpBmp);

      DrawSkinGlyph(TmpBmp, Point(0, 0), State, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));

      BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else inherited DrawFilterCloseButton(ACanvas, R, AState)
end;

procedure TcxACLookAndFeelPainter.DrawFilterDropDownButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AIsFilterActive: Boolean);
var
  i : integer;
  TmpBmp : TBitmap;
  State : integer;
  CI : TCacheInfo;
  sSection : string;
  procedure DrawArrow(Bmp : TBitmap; Color : TColor);
  const
    aWidth = 6;
    aHeight = 3;
  var
    x, y, Left, Top, awd2, i : integer;
  begin
    Left := (Bmp.Width - aWidth) div 2;
    Top := (Bmp.Height - aHeight) div 2;
    awd2 := aWidth div 2;
    i := 0;
    for y := Top to Top + aHeight do begin
      for x := Left + i to Left + awd2 do begin
        Bmp.Canvas.Pixels[x, y] := Color;
        Bmp.Canvas.Pixels[Bmp.Width - x, y] := Color;
      end;
      inc(i);
    end;
  end;
begin
  if Skinned then begin
    case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;

    i := DefManager.GetSkinIndex(s_UpDown);
    if not DefManager.IsValidSkinIndex(i) then begin
      i := DefManager.GetSkinIndex(s_Button);
      sSection := s_Button;
    end
    else sSection := s_UpDown;

    if DefManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(WidthOf(R, True), HeightOf(R, True));
      BitBlt(TmpBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, R.Left, R.Top, SRCCOPY);

      CI := MakeCacheInfo(TmpBmp);
      PaintItem(i, sSection, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefManager);
      if State = 0
        then DrawArrow(TmpBmp, DefManager.gd[i].FontColor[1])
        else DrawArrow(TmpBmp, DefManager.gd[i].HotFontColor[1]);

      BitBlt(aCanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end
  else inherited DrawFilterCloseButton(ACanvas, R, AState)
end;

procedure TcxACLookAndFeelPainter.DrawFilterPanel(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap);
begin // +
  ABackgroundColor := DefaultManager.GetGlobalColor;
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawFooterBorder(ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned
    then ACanvas.FrameRect(R, DefaultManager.GetActiveEditColor, 1)
    else inherited DrawFooterBorder(ACanvas, R)
end;

procedure TcxACLookAndFeelPainter.DrawFooterCell(ACanvas: TcxCanvas; const ABounds: TRect; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawFooterCellBorder(ACanvas: TcxCanvas; const R: TRect);
begin
  if Skinned
    then ACanvas.FrameRect(R, DefaultManager.GetGlobalColor, 1)
    else inherited DrawFooterBorder(ACanvas, R)
end;

procedure TcxACLookAndFeelPainter.DrawFooterContent(ACanvas: TcxCanvas; const ARect: TRect; const AViewParams: TcxViewParams);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawFooterSeparator(ACanvas: TcxCanvas; const R: TRect);
begin // +
  if Skinned then begin
    ACanvas.FillRect(R, DefaultManager.GetGlobalColor);
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawGroupBoxBackground(ACanvas: TcxCanvas; ABounds, ARect: TRect);
begin
  inherited;
end;

{$IFDEF VER26}
procedure TcxACLookAndFeelPainter.DrawGroupBoxCaption(ACanvas: TcxCanvas; const ACaptionRect, ATextRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
{$ELSE}
procedure TcxACLookAndFeelPainter.DrawGroupBoxCaption(ACanvas: TcxCanvas; ACaptionRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition);
{$ENDIF}
var
  aBord : TcxBorders;
begin
  if Skinned then begin
    aBord := cxBordersAll;
    case ACaptionPosition of
      cxgpTop, cxgpCenter : aBord := aBord - [bBottom];
      cxgpBottom : aBord := aBord - [bTop];
      cxgpLeft : aBord := aBord - [bRight];
      cxgpRight : aBord := aBord - [bLeft];
    end;
    ACanvas.FillRect(ACaptionRect, MixColors(DefaultManager.GetGlobalColor, DefaultManager.Palette[pcBorder], 0.7));
    ACanvas.FrameRect(ACaptionRect, DefaultManager.Palette[pcBorder], 1, aBord);
    ACanvas.FrameRect(ACaptionRect, MixColors(DefaultManager.GetGlobalColor, DefaultManager.Palette[pcBorder], 0.4), 1, cxBordersAll - aBord);
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawGroupBoxContent(ACanvas: TcxCanvas; ABorderRect: TRect; ACaptionPosition: TcxGroupBoxCaptionPosition{$IFDEF VER640}; ABorders: TcxBorders = cxBordersAll{$ENDIF});
var
  aBord : TcxBorders;
begin
  if Skinned then begin
    aBord := cxBordersAll;
    case ACaptionPosition of
      cxgpTop, cxgpCenter : aBord := aBord - [bTop];
      cxgpBottom : aBord := aBord - [bBottom];
      cxgpLeft : aBord := aBord - [bLeft];
      cxgpRight : aBord := aBord - [bRight];
    end;
    ACanvas.FillRect(ABorderRect, DefaultManager.GetGlobalColor);
    ACanvas.FrameRect(ABorderRect, DefaultManager.Palette[pcBorder], 1, aBord);
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawGroupByBox(ACanvas: TcxCanvas; const ARect: TRect; ATransparent: Boolean; ABackgroundColor: TColor; const ABackgroundBitmap: TBitmap);
begin // +
  ABackgroundColor := DefaultManager.GetGlobalColor;
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawGroupExpandButton(ACanvas: TcxCanvas; const R: TRect; AExpanded: Boolean; AState: TcxButtonState);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawHeader;
const
  AlignmentsHorz: array[TAlignment] of Integer = (cxAlignLeft, cxAlignRight, cxAlignHCenter);
  AlignmentsVert: array[TcxAlignmentVert] of Integer = (cxAlignTop, cxAlignBottom, cxAlignVCenter);
  MultiLines: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
  ShowEndEllipsises: array[Boolean] of Integer = (0, cxShowEndEllipsis);
var
  State : integer;
  Section : string;
  R : TRect;
  TmpBmp : TBitmap;
  i : integer;
begin
  if Skinned then begin
    if AState in [cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed] then begin
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      Section := s_ColHeader;
      AOnDrawBackground := nil;

      TmpBmp := CreateBmp32(WidthOf(ABounds), HeightOf(ABounds));
      i := PaintSection(TmpBmp, s_ColHeader, s_Button, State, DefaultManager, ABounds.TopLeft, DefaultManager.GetGlobalColor);
      BitBlt(ACanvas.Handle, ABounds.Left, ABounds.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndnil(TmpBmp);

      if AFont <> nil then ACanvas.Font.Assign(AFont);
      if i <> -1 then begin
        if State = 0 then ACanvas.Font.Color := DefaultManager.gd[i].FontColor[1] else ACanvas.Font.Color := DefaultManager.gd[i].HotFontColor[1]
      end;
      ACanvas.Brush.Style := bsClear;
      R := ATextAreaBounds;
      ACanvas.DrawText(AText, ATextAreaBounds, AlignmentsHorz[AAlignmentHorz] or
          AlignmentsVert[AAlignmentVert] or MultiLines[AMultiLine] or ShowEndEllipsises[AShowEndEllipsis]);

    end;
  end else inherited
end;

procedure TcxACLookAndFeelPainter.DrawHeaderBorder(ACanvas: TcxCanvas; const R: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders);
begin
  if not Skinned then inherited;
end;

procedure TcxACLookAndFeelPainter.DrawHeaderControlSection(
  ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  ANeighbors: TcxNeighbors; ABorders: TcxBorders; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
  AShowEndEllipsis: Boolean; const AText: string; AFont: TFont; ATextColor,
  ABkColor: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawHeaderControlSectionBorder(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AState: TcxButtonState);
var
  State : integer;
  Section : string;
  aBmp : TBitmap;
  w, h : integer;
begin
  if Skinned then begin
    if AState in [cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed] then begin
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      Section := s_ColHeader;

      w := WidthOf(R, True);
      h := HeightOf(R, True);
      if (w > 0) and (h > 0) then begin

        aBmp := CreateBmp32(WidthOf(R, True), HeightOf(R, True));
        PaintSection(aBmp, s_ColHeader, s_Button, State, DefaultManager, R.TopLeft, DefaultManager.GetGlobalColor);
        BitBlt(ACanvas.Handle, R.Left, R.Top, aBmp.Width, aBmp.Height, aBmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndnil(aBmp);
      end;
    end;
  end else
  inherited DrawHeaderControlSectionBorder(ACanvas, R, ABorders, AState)
end;

procedure TcxACLookAndFeelPainter.DrawHeaderControlSectionContent(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect;
  AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor);
const
  AlignmentsHorz: array[TAlignment] of Integer = (cxAlignLeft, cxAlignRight, cxAlignHCenter);
  AlignmentsVert: array[TcxAlignmentVert] of Integer = (cxAlignTop, cxAlignBottom, cxAlignVCenter);
  MultiLines: array[Boolean] of Integer = (cxSingleLine, cxWordBreak);
  ShowEndEllipsises: array[Boolean] of Integer = (0, cxShowEndEllipsis);
var
  State : integer;
  Section : string;
  i : integer;
begin
  if Skinned then begin
    if AState in [cxbsDefault, cxbsNormal, cxbsHot, cxbsPressed] then begin
      case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
      Section := s_ColHeader;

      if AFont <> nil then ACanvas.Font.Assign(AFont);
      i := DefaultManager.GetSkinIndex(Section);
      if i <> -1 then begin
        if State = 0 then ACanvas.Font.Color := DefaultManager.gd[i].FontColor[1] else ACanvas.Font.Color := DefaultManager.gd[i].HotFontColor[1]
      end;
      ACanvas.Brush.Style := bsClear;
      ACanvas.DrawText(AText, ATextAreaBounds, AlignmentsHorz[AAlignmentHorz] or
            AlignmentsVert[AAlignmentVert] or MultiLines[AMultiLine] or ShowEndEllipsises[AShowEndEllipsis]);
    end;
  end else inherited
end;

procedure TcxACLookAndFeelPainter.DrawHeaderControlSectionText(
  ACanvas: TcxCanvas; const ATextAreaBounds: TRect; AState: TcxButtonState;
  AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine,
  AShowEndEllipsis: Boolean; const AText: string; AFont: TFont;
  ATextColor: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawHeaderEx(ACanvas: TcxCanvas; const ABounds, ATextAreaBounds: TRect; ANeighbors: TcxNeighbors;
  ABorders: TcxBorders; AState: TcxButtonState; AAlignmentHorz: TAlignment; AAlignmentVert: TcxAlignmentVert; AMultiLine, AShowEndEllipsis: Boolean;
  const AText: string; AFont: TFont; ATextColor, ABkColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
begin
  if Skinned then DrawHeader(ACanvas, ABounds, ATextAreaBounds, ANeighbors, ABorders, AState,
    AAlignmentHorz, AAlignmentVert, AMultiLine, AShowEndEllipsis, AText, AFont, ATextColor, ABkColor,
    AOnDrawBackground, False)
  else inherited
end;

procedure TcxACLookAndFeelPainter.DrawHeaderPressed(ACanvas: TcxCanvas; const ABounds: TRect);
begin // +
  if not Skinned then inherited;
end;

procedure TcxACLookAndFeelPainter.DrawHeaderSeparator(ACanvas: TcxCanvas; const ABounds: TRect; AIndentSize: Integer; AColor: TColor; AViewParams: TcxViewParams);
begin // +
  if Skinned then AColor := {MixColors(DefaultManager.GetGlobalColor,} DefaultManager.Palette[pcBorder]{, 0.5)};
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawIndicatorCustomizationMark(ACanvas: TcxCanvas; const R: TRect; AColor: TColor);
begin // +
  if Skinned then AColor := DefaultManager.GetGlobalFontColor;
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawIndicatorImage(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawIndicatorItem(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind;
  AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawIndicatorItemEx(ACanvas: TcxCanvas; const R: TRect; AKind: TcxIndicatorKind;
  AColor: TColor; AOnDrawBackground: TcxDrawBackgroundEvent);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawMonthHeader(ACanvas: TcxCanvas; const ABounds: TRect; const AText: string; ANeighbors: TcxNeighbors;
  const AViewParams: TcxViewParams;
  AArrows: {$IFDEF VER23} TcxArrowDirections {$ELSE} TcxHeaderArrows {$ENDIF}; ASideWidth: Integer; AOnDrawBackground: TcxDrawBackgroundEvent = nil);
var
  rText : TRect;
  i : integer;
begin // +
  if Skinned then begin
    rText := HeaderContentBounds(ABounds, []);
    DrawHeader(ACanvas, ABounds, rText, ANeighbors, [], cxbsNormal, taCenter, vaCenter, False, False, AText, ACanvas.Font, clNone, clNone);
    i := DefaultManager.GetSkinIndex(s_ColHeader);
    if i = -1 then DefaultManager.GetSkinIndex(s_Button);
    if i <> -1
      then DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, DefaultManager.gd[i].FontColor[1])
      else DrawMonthHeaderArrows(ACanvas, ABounds, AArrows, ASideWidth, clWindowText);
  end
  else
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawPanelBackground(
  ACanvas: TcxCanvas; AControl: TWinControl; ABounds: TRect; AColorFrom,
  AColorTo: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawPanelBorders(ACanvas: TcxCanvas; const ABorderRect: TRect);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawPanelCaption(ACanvas: TcxCanvas; const ACaptionRect: TRect;
  ACaptionPosition: TcxGroupBoxCaptionPosition);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawPanelContent(ACanvas: TcxCanvas; const ABorderRect: TRect; ABorder: Boolean);
var
  Bmp : TBitmap;
begin
  if Skinned then begin
    if ABorder then begin
      Bmp := CreateBmp32(WidthOf(ABorderRect), HeightOf(ABorderRect));
      PaintSection(Bmp, s_Panel, '', 0, DefaultManager, ABorderRect.TopLeft, DefaultManager.GetGlobalColor);
      BitBlt(ACanvas.Handle, ABorderRect.Left, ABorderRect.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(Bmp);
    end
    else ACanvas.FillRect(ABorderRect, DefaultManager.GetGlobalColor);
  end
  else
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawProgressBarBorder(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean);
var
  i : integer;
  TmpBmp : TBitmap;
  CI : TCacheInfo;
begin
  if Skinned then begin
    i := DefaultManager.GetSkinIndex(s_Gauge);
    if DefaultManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(WidthOf(ARect), HeightOf(ARect));
      CI.Bmp := nil;
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      PaintItem(i, s_Button, CI, True, 0, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
      BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
    end;
  end else inherited
end;

procedure TcxACLookAndFeelPainter.DrawProgressBarChunk(ACanvas: TcxCanvas; ARect: TRect; AVertical: Boolean);
var
  i : integer;
  TmpBmp, BGBmp : TBitmap;
begin
  if Skinned then begin
    if AVertical then i := DefaultManager.GetSkinIndex(s_ProgressV) else i := DefaultManager.GetSkinIndex(s_ProgressH);
    if DefaultManager.IsValidSkinIndex(i) then begin
      TmpBmp := CreateBmp32(WidthOf(ARect), HeightOf(ARect));
      BGBmp := CreateBmp32(WidthOf(ARect), HeightOf(ARect));
      BitBlt(BgBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, ARect.Left, ARect.Top, SRCCOPY);
      PaintItem(i, s_Button, MakeCacheInfo(BgBmp), True, 0, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
      BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp);
      FreeAndNil(BgBmp);
    end;
  end else inherited

//  Old Flat style //
//  if Skinned then ACanvas.FillRect(ARect, MixColors(DefaultManager.GetActiveEditFontColor, DefaultManager.GetActiveEditColor, 0.5)) else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSchedulerBorder(ACanvas: TcxCanvas; R: TRect);
begin // +
  if Skinned then ACanvas.FillRect(R, DefaultManager.GetGlobalColor) else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSchedulerEventProgress(ACanvas: TcxCanvas; const ABounds, AProgress: TRect; AViewParams: TcxViewParams; ATransparent: Boolean);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSchedulerNavigationButton(ACanvas: TcxCanvas; const ARect: TRect; AIsNextButton: Boolean;
  AState: TcxButtonState; const AText: string; const ATextRect, AArrowRect: TRect);
var
  TmpBmp : TcxBitmap;
  cBmp : TBitmap;
  R : TRect;
  Ndx : integer;
  function RotateTextRect(const ATextRect: TRect): TRect;
  begin
    Result.Left := ARect.Bottom - ATextRect.Bottom;
    Result.Top := ATextRect.Left - ARect.Left;
    Result.Right := Result.Left + ATextRect.Bottom - ATextRect.Top;
    Result.Bottom := Result.Top + ATextRect.Right - ATextRect.Left;
  end;
begin
  if Skinned then begin
    TmpBmp := TcxBitmap.CreateSize(WidthOf(ARect), HeightOf(ARect));
    TmpBmp.PixelFormat := pf32bit;
    cBmp := CreateBmp32(TmpBmp.Width, TmpBmp.Height);
    BitBlt(cBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, ARect.Left, ARect.Top, SRCCOPY);

    if AIsNextButton then begin
      Ndx := DefaultManager.GetSkinIndex(s_TabLeft);
      if Ndx < 0 then DefaultManager.GetSkinIndex(s_Button);
      if Ndx >= 0 then PaintItem(Ndx, s_TabLeft, MakeCacheInfo(cBmp), True, GetState[AState], Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager) // Transparency is not needed
    end
    else begin
      Ndx := DefaultManager.GetSkinIndex(s_TabRight);
      if Ndx < 0 then DefaultManager.GetSkinIndex(s_Button);
      if Ndx >= 0 then PaintItem(Ndx, s_TabRight, MakeCacheInfo(cBmp), True, GetState[AState], Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager) // Transparency is not needed
    end;
    cBmp.Free;

    TmpBmp.Rotate(raMinus90);
    with TmpBmp.Canvas do begin
      Brush.Style := bsClear;
      Font.Assign(ACanvas.Font);
      Font.Color := ButtonSymbolColor(AState, Font.Color);
      R := RotateTextRect(ATextRect);
      cxDrawText(Handle, AText, R, DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end;
    TmpBmp.Rotate(raPlus90);

    BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
    DrawSchedulerNavigationButtonArrow(ACanvas, AArrowRect, AIsNextButton, ButtonSymbolColor(AState));

    FreeAndNil(TmpBmp);
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSchedulerNavigationButtonArrow(ACanvas: TcxCanvas; const ARect: TRect; AIsNextButton: Boolean; AColor: TColor);
begin // +
  if Skinned then AColor := DefaultManager.GetGlobalFontColor;
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSchedulerNavigatorButton(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSchedulerSplitterBorder(ACanvas: TcxCanvas; R: TRect; const AViewParams: TcxViewParams; AIsHorizontal: Boolean);
begin
//  if Skinned then ACanvas.FillRect(R, DefaultManager.GetGlobalColor) else
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawScrollBarArrow(ACanvas: TcxCanvas; R: TRect; AState: TcxButtonState; AArrowDirection: TcxArrowDirection);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawScrollBarPart(ACanvas: TcxCanvas; AHorizontal: Boolean; R: TRect; APart: TcxScrollBarPart; AState: TcxButtonState);
var
  State : integer;
  TmpBmp, BGBmp : TBitmap;
  CI : TCacheInfo;
  BtnSize : integer;
  procedure PaintGlyph(MaskIndex : integer);
  var
    p : TPoint;
  begin
    if DefaultManager.IsValidImgIndex(MaskIndex) then with DefaultManager do begin
      if ma[MaskIndex].Bmp = nil then begin
        p.x := (WidthOf(R) - WidthOfImage(ma[MaskIndex])) div 2;
        p.y := (HeightOf(R) - HeightOfImage(ma[MaskIndex])) div 2;
      end
      else if (ma[MaskIndex].Bmp.Height div 2 < HeightOf(R)) then begin
        p.x := (WidthOf(R) - ma[MaskIndex].Bmp.Width div 3) div 2;
        p.y := (HeightOf(R) - ma[MaskIndex].Bmp.Height div 2) div 2;
      end;
      if (p.x < 0) or (p.y < 0) then Exit;
      DrawSkinGlyph(TmpBmp, p, State, 1, ma[MaskIndex], MakeCacheInfo(TmpBmp));
    end;
  end;
  procedure PaintPage(APart: TcxScrollBarPart; w, h : integer; NewBmp : TBitmap = nil; IsBtn : boolean = False);
  var
    Bmp : TBitmap;
    CI : TCacheInfo;
  begin
    if NewBmp = nil then NewBmp := TmpBmp;
    if IsBtn then BtnSize := 0 else BtnSize := GetSystemMetrics(SM_CYVSCROLL);
    Bmp := CreateBmp32(w, h);
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetGlobalColor;
    with DefaultManager.ConstData do begin
      if AHorizontal then begin
        Bmp.Width := w + BtnSize;
        if APart = sbpPageUp then begin
          PaintItemFast(IndexScrollBar1H, MaskScrollBar1H, BGScrollBar1H, BGHotScrollBar1H, '', CI, True,
                        State, Rect(0, 0, Bmp.Width, h), Point(0, 0), Bmp, DefaultManager);
          BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, BtnSize, 0, SRCCOPY);
        end
        else begin
          PaintItemFast(IndexScrollBar2H, MaskScrollBar2H, BGScrollBar2H, BGHotScrollBar2H, '', CI, True,
                        State, Rect(0, 0, Bmp.Width, NewBmp.Height), Point(0, 0), Bmp, DefaultManager);
          BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        end;
      end
      else begin
        Bmp.Height := h + BtnSize;
        if APart = sbpPageUp then begin
          PaintItemFast(IndexScrollBar1V, MaskScrollBar1V, BGScrollBar1V, BGHotScrollBar1V, '', CI, True,
                        State, Rect(0, 0, w, Bmp.Height), Point(0, 0), Bmp, DefaultManager);
          BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, 0, BtnSize, SRCCOPY);
        end
        else begin
          PaintItemFast(IndexScrollBar2V, MaskScrollBar2V, BGScrollBar2V, BGHotScrollBar2V, '', CI, True,
                        State, Rect(0, 0, w, Bmp.Height), Point(0, 0), Bmp, DefaultManager);
          BitBlt(NewBmp.Canvas.Handle, 0, 0, w, h, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        end;
      end;
    end;
    FreeAndNil(Bmp);
  end;
begin
  if IsRectEmpty(R) or ((APart = sbpThumbnail) and (AState = cxbsDisabled)) then Exit;
  if not Skinned then begin inherited DrawScrollBarPart(ACanvas, AHorizontal, R, APart, AState); Exit; end;
  case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;

  TmpBmp := CreateBmp32(WidthOf(R), HeightOf(R));

  with DefaultManager.ConstData do begin
    if AHorizontal then begin
      case APart of
        sbpThumbnail : begin
          BGBmp := CreateBmp32(WidthOf(R) + 60, HeightOf(R));
          PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp);
          CI := MakeCacheInfo(BGBmp);
          CI.X := 30;
          PaintItemFast(IndexSliderHorz, MaskSliderHorz, ScrollSliderBGHorz, ScrollSliderBGHotHorz,
            s_ScrollSliderH, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
          FreeAndNil(BGBmp);
          PaintGlyph(DefaultManager.ConstData.MaskSliderGlyphHorz);
        end;
        sbpLineUp: begin
          BGBmp := CreateBmp32(WidthOf(R), HeightOf(R));
          PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp, True);
          CI := MakeCacheInfo(BGBmp);

          if DefaultManager.gd[IndexScrollLeft].ReservedBoolean and (DefaultManager.ConstData.MaskScrollLeft > -1) then begin
            if DefaultManager.ma[MaskScrollLeft].ImageCount = 0 then DefaultManager.ma[MaskScrollLeft].ImageCount := 3;            
            if DefaultManager.ma[MaskScrollLeft].Bmp = nil
              then TmpBmp.Width := math.max(GetSystemMetrics(SM_CXHSCROLL), WidthOfImage(DefaultManager.ma[MaskScrollLeft]))
              else TmpBmp.Width := math.max(GetSystemMetrics(SM_CXHSCROLL), DefaultManager.ma[DefaultManager.ConstData.MaskScrollLeft].Bmp.Width div 3);
          end;

          PaintItemFast(IndexScrollLeft, MaskScrollLeft, IndexBGScrollLeft, IndexBGHotScrollLeft,
            s_ScrollBtnLeft, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
          FreeAndNil(BGBmp);
          PaintGlyph(DefaultManager.ConstData.MaskArrowLeft);
        end;
        sbpLineDown: begin
          BGBmp := CreateBmp32(WidthOf(R), HeightOf(R));
          PaintPage(sbpPageDown, BGBmp.Width, BGBmp.Height, BGBmp, True);
          CI := MakeCacheInfo(BGBmp);

          if DefaultManager.gd[IndexScrollRight].ReservedBoolean and (DefaultManager.ConstData.MaskScrollRight > -1)  then begin
            if DefaultManager.ma[MaskScrollRight].ImageCount = 0 then DefaultManager.ma[MaskScrollRight].ImageCount := 3;
            if DefaultManager.ma[MaskScrollRight].Bmp = nil
              then TmpBmp.Width := math.max(GetSystemMetrics(SM_CXHSCROLL), WidthOfImage(DefaultManager.ma[MaskScrollRight]))
              else TmpBmp.Width := math.max(GetSystemMetrics(SM_CXHSCROLL), DefaultManager.ma[MaskScrollRight].Bmp.Width div 3);
          end;

          PaintItemFast(IndexScrollRight, MaskScrollRight, IndexBGScrollRight, IndexBGHotScrollRight,
            s_ScrollBtnRight, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
          FreeAndNil(BGBmp);
          BitBlt(TmpBmp.Canvas.Handle, 0, 0, WidthOf(R), HeightOf(R), TmpBmp.Canvas.Handle, TmpBmp.Width - WidthOf(R), 0, SRCCOPY);
          TmpBmp.Width := WidthOf(R);
          PaintGlyph(DefaultManager.ConstData.MaskArrowRight);
        end;
        sbpPageUp, sbpPageDown: begin
          PaintPage(APart, TmpBmp.Width, TmpBmp.Height);
        end;
      end;
    end
    else begin
      case APart of
        sbpThumbnail : begin
          BGBmp := CreateBmp32(WidthOf(R), HeightOf(R) + 60);
          PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp);
          CI := MakeCacheInfo(BGBmp);
          CI.Y := 30;
          PaintItemFast(IndexSliderVert, MaskSliderVert, ScrollSliderBGVert, ScrollSliderBGHotVert,
            s_ScrollSliderV, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
          FreeAndNil(BGBmp);
          PaintGlyph(DefaultManager.ConstData.MaskSliderGlyphVert);
        end;
        sbpLineUp: begin
          BGBmp := CreateBmp32(WidthOf(R), HeightOf(R));
          PaintPage(sbpPageUp, BGBmp.Width, BGBmp.Height, BGBmp, True);
          CI := MakeCacheInfo(BGBmp);

          if DefaultManager.gd[IndexScrollTop].ReservedBoolean and (DefaultManager.ConstData.MaskScrollTop > -1)  then begin
            if DefaultManager.ma[DefaultManager.ConstData.MaskScrollTop].Bmp = nil
              then TmpBmp.Height := math.max(GetSystemMetrics(SM_CYVSCROLL), HeightOf(DefaultManager.ma[MaskScrollTop].R) div (1 + DefaultManager.ma[MaskScrollTop].MaskType))
              else TmpBmp.Height := math.max(GetSystemMetrics(SM_CYVSCROLL), DefaultManager.ma[MaskScrollTop].Bmp.Height div 2);
          end;

          PaintItemFast(DefaultManager.ConstData.IndexScrollTop, DefaultManager.ConstData.MaskScrollTop, DefaultManager.ConstData.IndexBGScrollTop, IndexBGHotScrollTop,
            s_ScrollBtnTop, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
          FreeAndNil(BGBmp);
          PaintGlyph(DefaultManager.ConstData.MaskArrowTop);
        end;
        sbpLineDown: begin
          BGBmp := CreateBmp32(WidthOf(R), HeightOf(R));
          PaintPage(sbpPageDown, BGBmp.Width, BGBmp.Height, BGBmp, True);
          CI := MakeCacheInfo(BGBmp);

          if DefaultManager.gd[IndexScrollBottom].ReservedBoolean and (DefaultManager.ConstData.MaskScrollBottom > -1)  then begin
            if DefaultManager.ma[DefaultManager.ConstData.MaskScrollBottom].Bmp = nil
              then TmpBmp.Height := math.max(GetSystemMetrics(SM_CYVSCROLL), HeightOf(DefaultManager.ma[MaskScrollBottom].R) div (1 + DefaultManager.ma[MaskScrollBottom].MaskType))
              else TmpBmp.Height := math.max(GetSystemMetrics(SM_CYVSCROLL), DefaultManager.ma[MaskScrollBottom].Bmp.Height div 2);
          end;

          PaintItemFast(IndexScrollBottom, MaskScrollBottom, IndexBGScrollBottom, IndexBGHotScrollBottom,
            s_ScrollBtnBottom, CI, True, State, Rect(0, 0, TmpBmp.Width, TmpBmp.Height), Point(0, 0), TmpBmp, DefaultManager);
          FreeAndNil(BGBmp);
          BitBlt(TmpBmp.Canvas.Handle, 0, 0, WidthOf(R), HeightOf(R), TmpBmp.Canvas.Handle, 0, TmpBmp.Height - HeightOf(R), SRCCOPY);
          TmpBmp.Height := HeightOf(R);
          PaintGlyph(DefaultManager.ConstData.MaskArrowBottom);
        end;
        sbpPageUp, sbpPageDown: begin
          PaintPage(APart, TmpBmp.Width, TmpBmp.Height);
        end;
      end;
    end;
  end;
  BitBlt(ACanvas.Handle, R.Left, R.Top, WidthOf(R), HeightOf(R), TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
  FreeAndNil(TmpBmp);
end;

procedure TcxACLookAndFeelPainter.DrawSizeGrip(ACanvas: TcxCanvas; const ARect: TRect; ABackgroundColor: TColor = clDefault{$IFDEF VER653}; ACorner: TdxCorner = coBottomRight{$ENDIF});
var
  i : integer;
  TmpBmp : TBitmap;
  p : TPoint;
begin
  if Skinned then begin
    i := DefaultManager.ConstData.GripRightBottom;
    if DefaultManager.IsValidImgIndex(i) then begin
      TmpBmp := CreateBmp32(WidthOf(ARect), HeightOf(ARect));

      p.x := (WidthOf(ARect) - WidthOfImage(DefaultManager.ma[i]));
      p.y := (HeightOf(ARect) - HeightOfImage(DefaultManager.ma[i]));

      FillDC(TmpBmp.Canvas.Handle, ARect, DefaultManager.GetGlobalColor);
      DrawSkinGlyph(TmpBmp, p, 0, 1, DefaultManager.ma[i], MakeCacheInfo(TmpBmp));
      BitBlt(ACanvas.Handle, ARect.Left, ARect.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(TmpBmp)
    end
//  FillDC(ACanvas.Handle, ARect, DefaultManager.GetGlobalColor)
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSmallExpandButton(ACanvas: TcxCanvas; R: TRect; AExpanded: Boolean; ABorderColor, AColor: TColor);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawSortingMark(ACanvas: TcxCanvas; const R: TRect; AAscendingSorting: Boolean);
var
  State : integer;
  TmpBmp : TBitmap;
  procedure PaintGlyph(MaskIndex : integer);
  var
    p : TPoint;
  begin
    if DefaultManager.IsValidImgIndex(MaskIndex) then with DefaultManager do begin
      if ma[MaskIndex].Bmp = nil then begin
        p.x := (WidthOf(R) - WidthOfImage(ma[MaskIndex])) div 2;
        p.y := (HeightOf(R) - HeightOfImage(ma[MaskIndex])) div 2;
      end
      else if (ma[MaskIndex].Bmp.Height div 2 < HeightOf(R)) then begin
        p.x := (WidthOf(R) - ma[MaskIndex].Bmp.Width div 3) div 2;
        p.y := (HeightOf(R) - ma[MaskIndex].Bmp.Height div 2) div 2;
      end;
      if (p.x < 0) or (p.y < 0) then Exit;
      DrawSkinGlyph(TmpBmp, p, State, 1, ma[MaskIndex], MakeCacheInfo(TmpBmp));
    end;
  end;
begin
  if not Skinned then begin inherited; Exit end;
  TmpBmp := CreateBmp32(WidthOf(R), HeightOf(R));
  BitBlt(TmpBmp.Canvas.Handle, 0, 0, TmpBmp.Width, TmpBmp.Height, ACanvas.Handle, R.Left, R.Top, SRCCOPY);
  if not AAscendingSorting
    then PaintGlyph(DefaultManager.ConstData.MaskArrowBottom)
    else PaintGlyph(DefaultManager.ConstData.MaskArrowtop);
  BitBlt(ACanvas.Handle, R.Left, R.Top, TmpBmp.Width, TmpBmp.Height, TmpBmp.Canvas.Handle, 0, 0, SRCCOPY);
  FreeAndNil(TmpBmp)
end;

procedure TcxACLookAndFeelPainter.DrawTab(ACanvas: TcxCanvas; R: TRect; ABorders: TcxBorders; const AText: string;
  AState: TcxButtonState; AVertical: Boolean; AFont: TFont; ATextColor, ABkColor: TColor; AShowPrefix: Boolean);
var
  i : integer;
  State : integer;
  s : string;
  Bmp : TBitmap;
  CI : TCacheInfo; 
begin
  if Skinned then begin
    case AState of cxbsHot : State := 1; cxbsPressed : State := 2; else State := 0 end;
    if AVertical then s := s_TabLeft else s := s_TabTop;

    i := DefaultManager.GetSkinIndex(s);
    if DefaultManager.IsValidSkinIndex(i) then begin
      Bmp := CreateBmp32(WidthOf(R), HeightOf(R));
      CI.FillColor := DefaultManager.GetGlobalColor;
      CI.Ready := False;
      if State <> 2 then dec(R.Bottom);
      PaintItem(i, s, CI, True, State, R, Point(0, 0), ACanvas.Handle, DefaultManager);
      FreeAndNil(Bmp);
    end;
    ACanvas.Font.Assign(AFont);
    if State = 0
      then ACanvas.Font.Color := DefaultManager.gd[i].FontColor[1]
      else ACanvas.Font.Color := DefaultManager.gd[i].HotFontColor[1];
    ACanvas.Brush.Style := bsClear;
    DrawText(ACanvas.Handle, PChar(AText), Length(AText), R, DT_EXPANDTABS + DT_VCENTER + DT_CENTER + DT_SINGLELINE);
  end
  else inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTabBorder(ACanvas: TcxCanvas; R: TRect; ABorder: TcxBorder; ABorders: TcxBorders; AVertical: Boolean);
begin // +
  if not Skinned then inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTabsRoot(ACanvas: TcxCanvas; const R: TRect; ABorders: TcxBorders; AVertical: Boolean);
var
  i : integer;
  s : string;
  Bmp : TBitmap;
  CI : TCacheInfo;
begin
  if Skinned then begin
    s := s_PageControl;
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetGlobalColor;
    if not AVertical then begin
      i := DefaultManager.GetSkinIndex(s);
      if DefaultManager.IsValidSkinIndex(i) then begin
        Bmp := CreateBmp32(WidthOf(R), 15);
        PaintItem(i, s, CI, False, 0, Rect(0, 0, Bmp.Width, Bmp.Height), Point(0, 0), Bmp, DefaultManager);
        BitBlt(ACanvas.Handle, R.Left, R.Top, Bmp.Width, 2, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
        FreeAndNil(Bmp);
      end
      else FillDC(ACanvas.Handle, R, DefaultManager.GetGlobalColor);
    end
    else begin
      s := s + 'LEFT';
      i := DefaultManager.GetSkinIndex(s);
      if DefaultManager.IsValidSkinIndex(i) then begin
        PaintItem(i, s, CI, False, 0, R, Point(0, 0), ACanvas.Handle, DefaultManager);
      end
      else FillDC(ACanvas.Handle, R, DefaultManager.GetGlobalColor);
    end;
  end
  else inherited DrawTabsRoot(ACanvas, R, ABorders, AVertical);
end;

{$IFDEF VER650}
procedure TcxACLookAndFeelPainter.CorrectThumbRect(ACanvas: TcxCanvas; var ARect: TRect; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTrackBarTrack(ACanvas: TcxCanvas; const ARect, ASelection: TRect; AShowSelection, AEnabled, AHorizontal: Boolean; ATrackColor: TColor);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTrackBarTrackBounds(ACanvas: TcxCanvas; const ARect: TRect);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTrackBarThumbBorderUpDown(ACanvas: TcxCanvas; const ALightPolyLine, AShadowPolyLine, ADarkPolyLine: TPointArray);
begin
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTrackBarThumbBorderBoth(ACanvas: TcxCanvas; const ARect: TRect);
begin
  inherited;
end;

{$ELSE}
procedure TcxACLookAndFeelPainter.DrawTrackBar(ACanvas: TcxCanvas; const ARect, ASelection: TRect; AShowSelection, AEnabled, AHorizontal: Boolean);
begin // +
  inherited;
end;

procedure TcxACLookAndFeelPainter.DrawTrackBarThumb(ACanvas: TcxCanvas; ARect: TRect; AState: TcxButtonState; AHorizontal: Boolean; ATicks: TcxTrackBarTicksAlign);
begin
  inherited;
end;
{$ENDIF}

procedure TcxACLookAndFeelPainter.DrawWindowContent(ACanvas: TcxCanvas; const ARect: TRect);
begin // +
  if Skinned then begin
    FillDC(ACanvas.Handle, Rect(ARect.Left + 1, ARect.Top + 1, ARect.Right - 1, ARect.Bottom - 1), DefaultManager.GetGlobalColor);
    FillDCBorder(ACanvas.Handle, ARect, 1, 1, 1, 1, DefaultManager.Palette[pcBorder]);
  end
  else inherited;
end;

function TcxACLookAndFeelPainter.EditButtonSize: TSize;
begin
  if Skinned then Result := Size(12, 12) else Result := inherited EditButtonSize;
end;

function TcxACLookAndFeelPainter.EditButtonTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited EditButtonTextColor
end;

function TcxACLookAndFeelPainter.EditButtonTextOffset: Integer;
begin
  Result := inherited EditButtonTextOffset
end;

function TcxACLookAndFeelPainter.ExpandButtonSize: Integer;
begin
  Result := inherited ExpandButtonSize;
  if Skinned then Inc(Result, 2);
end;

function TcxACLookAndFeelPainter.FilterActivateButtonSize: TPoint;
var
  i : integer;
begin
  if Skinned then begin
    i := DefaultManager.GetSkinIndex(s_GlobalInfo);
    i := DefaultManager.GetMaskIndex(i, s_GlobalInfo, s_SmallBoxChecked);
    if i < 0 then i := DefaultManager.GetMaskIndex(i, s_GlobalInfo, s_CheckBoxChecked);
    if DefaultManager.IsValidImgIndex(i) then begin
      Result.x := WidthOfImage(DefaultManager.ma[i]);
      Result.y := HeightOfImage(DefaultManager.ma[i]);
    end
    else Result := inherited FilterCloseButtonSize;
  end
  else Result := inherited FilterCloseButtonSize;
end;

function TcxACLookAndFeelPainter.FilterCloseButtonSize: TPoint;
var
  i : integer;
begin
  if Skinned then begin
    i := DefaultManager.GetMaskIndex(DefaultManager.ConstData.IndexGLobalInfo, s_GlobalInfo, s_SmallIconClose);
    if i < 0 then i := DefaultManager.GetMaskIndex(DefaultManager.ConstData.IndexGLobalInfo, s_GlobalInfo, s_BorderIconClose);
    if DefaultManager.IsValidImgIndex(i) then begin
      Result.x := WidthOfImage(DefaultManager.ma[i]);
      Result.y := HeightOfImage(DefaultManager.ma[i]);
    end
    else Result := inherited FilterCloseButtonSize;
  end
  else Result := inherited FilterCloseButtonSize;
end;

function TcxACLookAndFeelPainter.FilterDropDownButtonSize: TPoint;
begin
  Result := inherited FilterDropDownButtonSize;
end;

function TcxACLookAndFeelPainter.FooterBorders: TcxBorders;
begin
  Result := inherited FooterBorders;
end;

function TcxACLookAndFeelPainter.FooterBorderSize: Integer;
begin
  if Skinned then Result := 0 else Result := inherited FooterBorderSize
end;

function TcxACLookAndFeelPainter.FooterCellBorderSize: Integer;
begin
  Result := inherited FooterCellBorderSize
end;

function TcxACLookAndFeelPainter.FooterCellOffset: Integer;
begin
  Result := inherited FooterCellOffset
end;

function TcxACLookAndFeelPainter.FooterDrawCellsFirst: Boolean;
begin
  Result := inherited FooterDrawCellsFirst
end;

function TcxACLookAndFeelPainter.FooterSeparatorColor: TColor;
begin
  if Skinned then Result := MixColors(DefaultManager.GetGlobalFontColor, DefaultManager.GetGlobalColor, 0.5) else Result := inherited FooterSeparatorColor
end;

function TcxACLookAndFeelPainter.FooterSeparatorSize: Integer;
begin
  Result := inherited FooterSeparatorSize
end;

function TcxACLookAndFeelPainter.GetContainerBorderColor(AIsHighlightBorder: Boolean): TColor;
begin
  if Skinned then Result := DefaultManager.Palette[pcBorder] else Result := inherited GetContainerBorderColor(AIsHighlightBorder)
end;

function TcxACLookAndFeelPainter.GetSplitterSize(AHorizontal: Boolean): TSize;
begin
  Result := Size(8, 8); // inherited GetSplitterSize(AHorizontal)
end;

function TcxACLookAndFeelPainter.GroupBoxBorderSize(ACaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): TRect;
begin
  if Skinned
    then Result := {Rect(1, 1, 1, 1)//}Rect(1, integer(ACaption) + 1, 1, 1)
    else Result := inherited GroupBoxBorderSize(ACaption, ACaptionPosition)
end;

function TcxACLookAndFeelPainter.GroupBoxTextColor({$IFDEF VER645}AEnabled: Boolean;{$ENDIF} ACaptionPosition: TcxGroupBoxCaptionPosition): TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited GroupBoxTextColor({$IFDEF VER645}AEnabled, {$ENDIF}ACaptionPosition)
end;

function TcxACLookAndFeelPainter.GroupExpandButtonSize: Integer;
begin
  Result := inherited GroupExpandButtonSize
end;

function TcxACLookAndFeelPainter.HeaderBorders(ANeighbors: TcxNeighbors): TcxBorders;
begin
  Result := cxBordersAll;
end;

function TcxACLookAndFeelPainter.HeaderBorderSize: Integer;
begin
  if Skinned then Result := 2 else Result := inherited HeaderBorderSize
end;

function TcxACLookAndFeelPainter.HeaderBounds(const ABounds: TRect; ANeighbors: TcxNeighbors; ABorders: TcxBorders): TRect;
begin
  Result := inherited HeaderBounds(ABounds, ANeighbors, ABorders)
end;

function TcxACLookAndFeelPainter.HeaderContentBounds(const ABounds: TRect; ABorders: TcxBorders): TRect;
begin
  Result := inherited HeaderContentBounds(ABounds, ABorders)
end;

function TcxACLookAndFeelPainter.HeaderControlSectionBorderSize(AState: TcxButtonState): Integer;
begin
  Result := inherited HeaderControlSectionBorderSize(AState)
end;

function TcxACLookAndFeelPainter.HeaderControlSectionContentBounds(const ABounds: TRect; AState: TcxButtonState): TRect;
begin
  Result := inherited HeaderControlSectionContentBounds(ABounds, AState)
end;

function TcxACLookAndFeelPainter.HeaderControlSectionTextAreaBounds(ABounds: TRect; AState: TcxButtonState): TRect;
begin
  Result := inherited HeaderControlSectionTextAreaBounds(ABounds, AState)
end;

function TcxACLookAndFeelPainter.HeaderDrawCellsFirst: Boolean;
begin
  Result := inherited HeaderDrawCellsFirst
end;

function TcxACLookAndFeelPainter.HeaderHeight(AFontHeight: Integer): Integer;
begin
  Result := inherited HeaderHeight(AFontHeight)
end;

function TcxACLookAndFeelPainter.HeaderWidth(ACanvas: TcxCanvas; ABorders: TcxBorders; const AText: string; AFont: TFont): Integer;
begin
  Result := inherited HeaderWidth(ACanvas, ABorders, AText, AFont)
end;

function TcxACLookAndFeelPainter.IndicatorDrawItemsFirst: Boolean;
begin
  Result := inherited IndicatorDrawItemsFirst
end;

function TcxACLookAndFeelPainter.IsButtonHotTrack: Boolean;
begin
  if Skinned then Result := True else Result := inherited IsButtonHotTrack
end;

function TcxACLookAndFeelPainter.IsDrawTabImplemented(AVertical: Boolean): Boolean;
begin
  if Skinned
    then Result := True
    else Result := inherited IsDrawTabImplemented(AVertical)
end;

function TcxACLookAndFeelPainter.IsGroupBoxTransparent(AIsCaption: Boolean; ACaptionPosition: TcxGroupBoxCaptionPosition): Boolean;
begin
  if Skinned then Result := False else Result := inherited IsGroupBoxTransparent(AIsCaption, ACaptionPosition)
end;

function TcxACLookAndFeelPainter.IsHeaderHotTrack: Boolean;
begin
  if Skinned then Result := False{True} else Result := inherited IsHeaderHotTrack
end;

function TcxACLookAndFeelPainter.IsPointOverGroupExpandButton(const R: TRect; const P: TPoint): Boolean;
begin
  Result := inherited IsPointOverGroupExpandButton(R, P)
end;

function TcxACLookAndFeelPainter.IsTabHotTrack(AVertical: Boolean): Boolean;
begin
  if Skinned then Result := True else Result := inherited IsTabHotTrack(AVertical)
end;

function TcxACLookAndFeelPainter.LookAndFeelName: string;
begin
  Result := s_AlphaSkins;
end;

function TcxACLookAndFeelPainter.PanelBorderSize: TRect;
begin
  Result := inherited PanelBorderSize
end;

function TcxACLookAndFeelPainter.PanelTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited PanelTextColor
end;

function TcxACLookAndFeelPainter.PopupBorderStyle: TcxPopupBorderStyle;
begin
  if Skinned then Result := pbsFlat else Result := inherited PopupBorderStyle
end;

function TcxACLookAndFeelPainter.ProgressBarBorderSize(AVertical: Boolean): TRect;
begin
  Result := inherited ProgressBarBorderSize(AVertical)
end;

function TcxACLookAndFeelPainter.ProgressBarTextColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited ProgressBarTextColor
end;

function TcxACLookAndFeelPainter.SchedulerEventProgressOffsets: TRect;
begin
  Result := inherited SchedulerEventProgressOffsets
end;

procedure TcxACLookAndFeelPainter.SchedulerNavigationButtonSizes(AIsNextButton: Boolean; var ABorders: TRect; var AArrowSize: TSize{$IFDEF VER645}; var AHasTextArea: Boolean{$ENDIF});
begin // +
  inherited;
end;

function TcxACLookAndFeelPainter.ScrollBarMinimalThumbSize(AVertical: Boolean): Integer;
begin
  Result := inherited ScrollBarMinimalThumbSize(AVertical)
end;

function TcxACLookAndFeelPainter.SizeGripSize: TSize;
var
  i : integer;
begin
  if Skinned then begin
    i := DefaultManager.ConstData.GripRightBottom;
    if DefaultManager.IsValidImgIndex(i) then begin
      Result.cx := WidthOfImage(DefaultManager.ma[i]);
      Result.cy := HeightOfImage(DefaultManager.ma[i]);
    end
    else Result := Size(GetSystemMetrics(SM_CXVSCROLL), GetSystemMetrics(SM_CYHSCROLL));
  end
  else Result := Size(GetSystemMetrics(SM_CXVSCROLL), GetSystemMetrics(SM_CYHSCROLL));
end;

function TcxACLookAndFeelPainter.SmallExpandButtonSize: Integer;
begin
  Result := inherited SmallExpandButtonSize
end;

function TcxACLookAndFeelPainter.SortingMarkAreaSize: TPoint;
begin
  Result := inherited SortingMarkAreaSize
end;

function TcxACLookAndFeelPainter.SortingMarkSize: TPoint;
begin
  Result := inherited SortingMarkSize
end;

function TcxACLookAndFeelPainter.TabBorderSize(AVertical: Boolean): Integer;
begin
  Result := inherited TabBorderSize(AVertical);
  if Skinned then inc(Result)
end;

function TcxACLookAndFeelPainter.TrackBarThumbSize(AHorizontal: Boolean): TSize;
begin
  Result := inherited TrackBarThumbSize(AHorizontal)
end;

function TcxACLookAndFeelPainter.TrackBarTicksColor(AText: Boolean): TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalFontColor else Result := inherited TrackBarTicksColor(AText)
end;

function TcxACLookAndFeelPainter.TrackBarTrackSize: Integer;
begin
  Result := inherited TrackBarTrackSize
end;

procedure _RefreshDevEx;
begin
  RootLookAndFeel.Refresh;
end;

procedure _InitDevEx(const Active : boolean);
var
 vPainter: TcxCustomLookAndFeelPainter;
begin
{$IFNDEF VER12_1_6}
  if GetExtendedStylePainters <> nil then begin
{$ENDIF}  
    vPainter := nil;
    if Active then begin
      if not cxLookAndFeelPaintersManager.GetPainter(s_AlphaSkins, vPainter) then begin
        cxLookAndFeelPaintersManager.Register(TcxACLookAndFeelPainter.Create);
{$IFDEF VER12_1_6}
        RegisterPCPainterClass(TcxACPCPainter);
{$ENDIF}
        RootLookAndFeel.Kind := lfStandard;
        RootLookAndFeel.SkinName := s_AlphaSkins;
      end;
    end
    else
      if (cxLookAndFeelPaintersManager <> nil) then // Added by Witcher 28.12.2012 10:41:58
        if cxLookAndFeelPaintersManager.GetPainter(s_AlphaSkins, vPainter) then begin
{$IFDEF VER12_1_6}
          UnregisterPCPainterClass(TcxPCTabsPainter);
{$ENDIF}
          RootLookAndFeel.SkinName := '';
          cxLookAndFeelPaintersManager.Unregister(s_AlphaSkins);
        end;
{$IFNDEF VER12_1_6}
  end;
{$ENDIF}
end;

function _CheckDevEx(const Control : TControl) : boolean;
begin
  if (RootLookAndFeel.SkinName = s_AlphaSkins) then begin
    if Control.ClassName = 'TcxGrid' then begin
      TAcesscxControl(Control).Loaded;
      Result := True;
    end
    else if (Control.ClassName = 'TcxPivotGrid') or (Control.ClassName = 'TcxDBPivotGrid') then begin
      TAcesscxControl(Control).FontChanged;
      Result := True;
    end
    else if Control.ClassName = 'TcxScheduler' then begin
      TAcesscxControl(Control).Loaded;
      Result := True;
    end
{
    else if (Control.ClassName = 'TcxVerticalGrid') or (Control.ClassName = 'TcxVirtualVerticalGrid') or (Control.ClassName = 'TcxDBVerticalGrid') then begin
      TAcesscxControl(Control).Loaded;
      Result := True;
    end
}
    else if Control is TcxControl then begin
      TAcesscxControl(Control).Invalidate;
      Result := True;
    end
    else Result := False;
  end
  else Result := False;
end;

{$IFDEF VER12_1_6}

{ TcxACPCPainter }

function TcxACPCPainter.AlwaysColoredTabs: Boolean;
begin
  Result := True;
end;

function TcxACPCPainter.GetClientColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited GetClientColor;
end;

function TcxACPCPainter.GetFreeSpaceColor: TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited GetFreeSpaceColor;
end;

class function TcxACPCPainter.GetStyleID: TcxPCStyleID;
begin
  Result := 12;
end;

class function TcxACPCPainter.GetStyleName: TCaption;
begin
  Result := s_AlphaSkins;
end;

function TcxACPCPainter.GetTabBodyColor(TabVisibleIndex: Integer): TColor;
begin
  if Skinned then Result := DefaultManager.GetGlobalColor else Result := inherited GetClientColor;
end;

type
  TAccessTabControlProperties = class(TcxCustomTabControlProperties);

procedure TcxACPCPainter.InternalPaintTab(ACanvas: TcxCanvas; ATabVisibleIndex: Integer);
var
  ABitmap: TcxBitmap;
  ATabRect: TRect;
  ATabViewInfo: TcxTabViewInfo;
  ATabOrigin: TPoint;

  i : integer;
  s : string;
  State : integer;
  CI : TCacheInfo;
begin
  if Skinned then begin
    ATabViewInfo := TabViewInfo[ATabVisibleIndex];
    ATabRect := ATabViewInfo.FullRect;
    if ATabViewInfo.IsMainTab then ATabRect := GetExtendedRect(ATabRect, Rect(0, 0, 0, -1), ATabViewInfo.PaintingPosition);
    ABitmap := TcxBitmap.CreateSize(0, 0, pf32bit);
    ABitmap.Canvas.Lock;
    try
      ABitmap.SetSize(ATabRect);
      ATabOrigin := ATabRect.TopLeft;
      if ATabViewInfo.IsActive then State := 2 else if ATabViewInfo.IsHighlighted then State := 1 else State := 0;

      if TAccessTabControlProperties(ATabViewInfo.Properties).TabPosition in [tpTop, tpBottom] then s := s_TabTop else s := s_TabLeft;

      i := DefaultManager.GetSkinIndex(s);
      if DefaultManager.IsValidSkinIndex(i) then begin
        CI.FillColor := DefaultManager.GetGlobalColor;
        CI.Ready := False;
        PaintItem(i, s, CI, True, State, Rect(0, 0, ABitmap.Width, ABitmap.Height), Point(0, 0), ABitmap, DefaultManager);
      end;
      ABitmap.cxCanvas.WindowOrg := ATabOrigin;
      DrawTabImageAndText(ABitmap.cxCanvas, ATabVisibleIndex);
      DrawFocusRect(ABitmap.cxCanvas, ATabVisibleIndex);
      cxBitBlt(ACanvas.Handle, ABitmap.Canvas.Handle, ATabRect, ATabRect.TopLeft, SRCCOPY);
    finally
      ABitmap.Canvas.Unlock;
      FreeAndNil(ABitmap);
    end;
  end
  else inherited;
end;

procedure TcxACPCPainter.PaintFrameBorder(ACanvas: TcxCanvas; R: TRect);
var
  i : integer;
  s : string;
  Bmp : TBitmap;
  CI : TCacheInfo;
begin
  if Skinned then begin
    s := s_PageControl;
    CI.Ready := False;
    CI.FillColor := DefaultManager.GetGlobalColor;
    i := DefaultManager.GetSkinIndex(s);
    if DefaultManager.IsValidSkinIndex(i) then begin
      Bmp := CreateBmp32(WidthOf(R), HeightOf(R));
      PaintItem(i, s, CI, False, 0, Rect(0, 0, Bmp.Width, Bmp.Height), Point(0, 0), Bmp, DefaultManager);
      BitBlt(ACanvas.Handle, R.Left, R.Top, Bmp.Width, Bmp.Height, Bmp.Canvas.Handle, 0, 0, SRCCOPY);
      FreeAndNil(Bmp);
    end
    else FillDC(ACanvas.Handle, R, DefaultManager.GetGlobalColor);
  end
  else inherited;
end;

{$ENDIF}

initialization
  InitDevEx := _InitDevEx;
  CheckDevEx := _CheckDevEx;
  RefreshDevEx := _RefreshDevEx;
//  ThirdPartySkipForms.Add('TcxGridFilterPopup');
//  ThirdPartySkipForms.Add('TcxShellComboBoxPopupWindow');
//  ThirdPartySkipForms.Add('TdxfmColorPalette');
//  ThirdPartySkipForms.Add('TcxPopupCalendar');

end.
