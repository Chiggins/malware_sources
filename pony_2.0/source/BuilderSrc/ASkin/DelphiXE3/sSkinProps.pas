unit sSkinProps;

interface

const

// Images
  s_BordersMask                           = 'BORDERSMASK';
  s_ExBorder                              = 'EXBORDER';
  s_LightRegion                           = 'LRGN';
  s_Glow                                  = 'GLOW';
  s_GlowMargin                            = 'GLOWMARGIN';
  s_GripImage                             = 'GRIPIMAGE';
  s_GripHorz                              = 'GRIPHORZ';
  s_GripVert                              = 'GRIPVERT';
  s_StatusPanelBordersMask                = 'STATUSPANELMASK';
  s_SliderChannelMask                     = 'SLIDERCHANNEL';

  s_Pattern                               = 'PATTERN';
  s_HotPattern                            = 'HOT' + s_Pattern;
  s_ImgTopLeft                            = 'IMGTOPLEFT';
  s_ImgTopRight                           = 'IMGTOPRIGHT';
  s_ImgBottomLeft                         = 'IMGBTMLEFT';
  s_ImgBottomRight                        = 'IMGBTMRIGHT';

  s_NormalTitleBar                        = 'TITLEBAR';

  s_BorderIconClose                       = 'BICONCLOSE';
  s_BorderIconCloseAlone                  = 'BICLOSEALONE';
  s_BorderIconMaximize                    = 'BICONMAX';
  s_BorderIconNormalize                   = 'BICONNORM';
  s_BorderIconMinimize                    = 'BICONMIN';
  s_BorderIconHelp                        = 'BICONHELP';
  s_TitleButtonMask                       = 'TITLEBUTTON';

  s_SmallIconNormalize                    = 'SICONNORM';
  s_SmallIconMinimize                     = 'SICONMIN';
  s_SmallIconMaximize                     = 'SICONMAX';
  s_SmallIconClose                        = 'SICONCLOSE';
  s_SmallIconHelp                         = 'SICONHELP';

  s_ItemGlyph                             = 'GLYPHMASK';
  s_SliderHorzMask                        = 'SLIDERMASK';
  s_SliderVertMask                        = 'SLIDERVMASK';
  s_TickVert                              = 'TICKVERT';
  s_TickHorz                              = 'TICKHORZ';

  // Common properties
  // Text and text contours colors
  s_FontColor                             = 'FONTCOLOR';
  s_TCLeft                                = 'TCLEFT';
  s_TCTop                                 = 'TCTOP';
  s_TCRight                               = 'TCRIGHT';
  s_TCBottom                              = 'TCBOTTOM';
  // Hot text and text contours colors
  s_HotFontColor                          = 'HOTFONTCOLOR';
  s_HotTCLeft                             = 'HOTTCLEFT';
  s_HotTCTop                              = 'HOTTCTOP';
  s_HotTCRight                            = 'HOTTCRIGHT';
  s_HotTCBottom                           = 'HOTTCBOTTOM';

  s_ReservedBoolean                       = 'RESERVEDBOOLEAN';
  s_GiveOwnFont                           = 'GIVEOWNFONT';

  s_ParentClass                           = 'PARENTCLASS';
  s_Color                                 = 'COLOR';
  s_Hint                                  = 'HINT';

  s_Transparency                          = 'TRANSPARENCY';
  s_GradientPercent                       = 'GRADIENTPERCENT';
  s_GradientData                          = 'GRADIENTDATA';
  s_ImagePercent                          = 'IMAGEPERCENT';
  s_ShowFocus                             = 'SHOWFOCUS';
  s_FadingEnabled                         = 'FADINGENABLED';
  s_FadingIterations                      = 'FADINGITERATIONS';
  s_HotColor                              = 'HOTCOLOR';
  s_HotTransparency                       = 'HOTTRANSPARENCY';
  s_HotGradientPercent                    = 'HOTGRADIENTPERCENT';
  s_HotGradientData                       = 'HOTGRADIENTDATA';
  s_HotImagePercent                       = 'HOTIMAGEPERCENT';
  s_BorderColor1                          = 'BORDERCOLOR1';
  s_BorderColor2                          = 'BORDERCOLOR2';
  s_BorderWidth                           = 'BORDERWIDTH';
  s_TitleHeight                           = 'TITLEHEIGHT';
  s_FormOffset                            = 'FORMOFFSET';         // Content offset
  s_ShadowOffset                          = 'ALIGNOFFSET';        // Additional offset for a shadow
  s_CenterOffset                          = 'CENTEROFFSET';
  s_MaxTitleHeight                        = 'MAXHEIGHT';
  s_BorderMode                            = 'BORDERMODE';

  // Global Colors
  s_BorderColor                           = 'BORDERCOLOR';

  s_EditTextOk                            = 'EDITTEXT_OK';
  s_EditTextWarning                       = 'EDITTEXT_WARN';
  s_EditTextAlert                         = 'EDITTEXT_ALERT';
  s_EditTextHighlight1                    = 'EDITTEXT_H1';
  s_EditTextHighlight2                    = 'EDITTEXT_H2';
  s_EditTextHighlight3                    = 'EDITTEXT_H3';

  s_EditText_Inverted                     = 'EDITTEXT_INV';
  s_EditBG_Inverted                       = 'EDITBG_INV';
  s_EditBG_OddRow                         = 'EDITBG_ODD';
  s_EditBG_EvenRow                        = 'EDITBG_EVEN';

  s_EditBGOk                              = 'EDITBG_OK';
  s_EditBGWarning                         = 'EDITBG_WARN';
  s_EditBGAlert                           = 'EDITBG_ALERT';

  // Standard SkinSections
  s_Caption                               = 'CAPTION';
  s_FormTitle                             = 'FORMTITLE';
  s_Form                                  = 'FORM';
  s_Dialog                                = 'DIALOG';
  s_DialogTitle                           = 'DIALOGTITLE';
  s_MDIArea                               = 'MDIAREA';
  s_MainMenu                              = 'MAINMENU';
  s_MenuLine                              = 'MENULINE';
  s_MenuItem                              = 'MENUITEM';
  s_Selection                             = 'SELECTION';
  s_MenuIcoLine                           = 'ICOLINE';
  s_MenuExtraLine                         = 'EXTRALINE';
  s_ScrollBar1H                           = 'SCROLLBAR1H';
  s_ScrollBar1V                           = 'SCROLLBAR1V';
  s_ScrollBar2H                           = 'SCROLLBAR2H';
  s_ScrollBar2V                           = 'SCROLLBAR2V';
  s_ScrollSliderV                         = 'SCROLLSLIDERV';
  s_ScrollSliderH                         = 'SCROLLSLIDERH';
  s_ScrollBtnLeft                         = 'SCROLLBTNLEFT';
  s_ScrollBtnTop                          = 'SCROLLBTNTOP';
  s_ScrollBtnRight                        = 'SCROLLBTNRIGHT';
  s_ScrollBtnBottom                       = 'SCROLLBTNBOTTOM';
  s_Divider                               = 'DIVIDER';
  s_DividerV                              = 'DIVIDERV';
  s_ColHeader                             = 'COLHEADER';
  s_ColHeaderL                            = 'COLHEADERL';
  s_ColHeaderR                            = 'COLHEADERR';
  s_ProgressH                             = 'PROGRESSH';
  s_ProgressV                             = 'PROGRESSV';
  s_AlphaEdit                             = 'ALPHAEDIT';
  s_TabTop                                = 'TABTOP';
  s_RibbonTab                             = 'RIBBONTAB';
  s_TabBottom                             = 'TABBOTTOM';
  s_TabLeft                               = 'TABLEFT';
  s_TabRight                              = 'TABRIGHT';
  s_Edit                                  = 'EDIT';
  s_ToolButton                            = 'TOOLBUTTON';
  s_MenuButton                            = 'MENUBTN';
  s_ComboBox                              = 'COMBOBOX';
  s_ComboBtn                              = 'COMBOBTN';
  s_AlphaComboBox                         = 'ALPHACOMBOBOX';
  s_UpDown                                = 'UPDOWNBTN';
  s_Button                                = 'BUTTON';
  s_ButtonBig                             = 'BUTTON_BIG';
  s_ButtonHuge                            = 'BUTTON_HUGE';
  s_SpeedButton                           = 'SPEEDBUTTON';
  s_SpeedButton_Small                     = 'SPEEDBUTTON_SMALL';
  s_Panel                                 = 'PANEL';
  s_PanelLow                              = 'PANEL_LOW';
  s_TabControl                            = 'TABCONTROL';
  s_PageControl                           = 'PAGECONTROL';
  s_RibbonPage                            = 'RIBBONPAGE';
  s_TabSheet                              = 'TABSHEET';
  s_StatusBar                             = 'STATUSBAR';
  s_ToolBar                               = 'TOOLBAR';
  s_MenuCaption                           = 'MENUCAPTION';
  s_Splitter                              = 'SPLITTER';
  s_GroupBox                              = 'GROUPBOX';
  s_Gauge                                 = 'GAUGE';
  s_TrackBar                              = 'TRACKBAR';
  s_CheckBox                              = 'CHECKBOX';
  s_RadioButton                           = 'CHECKBOX';
  s_DragBar                               = 'DRAGBAR';
  s_Bar                                   = 'BAR';
  s_BarTitle                              = 'BARTITLE';
  s_BarPanel                              = 'BARPANEL';
  s_WebBtn                                = 'WEBBUTTON';

  s_GripH                                 = 'GRIPH';
  s_GripV                                 = 'GRIPV';

  // Title bar items
  s_TBBTN                                 = 'TB_BTN';
//  s_TBBUTTON_L                            = 'TB_BUTTONLEFT';
//  s_TBBUTTON_R                            = 'TB_BUTTONRIGHT';
  s_TBMENUBTN                             = 'TB_MENUBTN';
  s_TBTAB                                 = 'TB_TAB';

  s_GlobalInfo                            = 'GLOBALINFO';
  s_Unknown                               = 'UNKNOWN';

  s_MasterBitmap                        = 'MASTERBITMAP';
  s_CheckGlyph                          = 'CHECK';
  s_CheckBoxChecked                     = 'BOXCHECKED';
  s_CheckBoxUnChecked                   = 'BOXUNCHECKED';
  s_CheckBoxGrayed                      = 'BOXGRAYED';
  s_RadioButtonChecked                  = 'RADIOCHECKED';
  s_RadioButtonUnChecked                = 'RADIOUNCHECKED';
  s_RadioButtonGrayed                   = 'RADIOGRAYED';
  s_SmallBoxChecked                     = 'SMALLCHECKED';
  s_SmallBoxUnChecked                   = 'SMALLUNCHECKED';
  s_SmallBoxGrayed                      = 'SMALLGRAYED';

  s_Version                             = 'VERSION';
  s_Author                              = 'AUTHOR';
  s_Description                         = 'DESCRIPTION';

  s_Shadow1Color                        = 'SHADOW1COLOR';
  s_Shadow1Offset                       = 'SHADOW1OFFSET';
  s_Shadow1Blur                         = 'SHADOW1BLUR';
  s_Shadow1Transparency                 = 'SHADOW1TRANSPARENCY';

  s_BISpacing                           = 'BISPACE';
  s_BIVAlign                            = 'BIVALIGN';
  s_BIRightMargin                       = 'BIRIGHT';
  s_BILeftMargin                        = 'BILEFT';
  s_BITopMargin                         = 'BITOP';
  s_BIKeepHUE                           = 'BIKEEPHUE';

  s_HOTGLOWCOLOR                        = 'HGCOL';
  s_GLOWCOLOR                           = 'GCOL';
  s_HOTGLOWSIZE                         = 'HGSIZE';
  s_GLOWSIZE                            = 'GSIZE';

  s_States                              = 'STATES';

  s_UseAeroBluring                      = 'AEROBLUR';
//  s_ExtShadowColor                      = 'EXTSHADOW';

implementation

end.
