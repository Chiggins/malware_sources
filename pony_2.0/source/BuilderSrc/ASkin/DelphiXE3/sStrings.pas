unit sStrings;

interface

const
  MaxAlphaStrID = 59000;

  s_MsgDlgOK              = MaxAlphaStrID - 8;
  s_MsgDlgCancel          = MaxAlphaStrID - 9;
  s_MsgDlgHelp            = MaxAlphaStrID - 10;

  s_RestoreStr            = MaxAlphaStrID - 19;
  s_MoveStr               = MaxAlphaStrID - 20;
  s_SizeStr               = MaxAlphaStrID - 21;
  s_MinimizeStr           = MaxAlphaStrID - 22;
  s_MaximizeStr           = MaxAlphaStrID - 23;
  s_CloseStr              = MaxAlphaStrID - 24;
  s_Calculator            = MaxAlphaStrID - 25;

  s_FileOpen              = MaxAlphaStrID - 30;

  s_AvailSkins            = MaxAlphaStrID - 36;
  s_InternalSkin          = MaxAlphaStrID - 37;  

  s_ErrorSettingCount     = MaxAlphaStrID - 38;
  s_ListBoxMustBeVirtual  = MaxAlphaStrID - 39;

  // Color dialog
  s_ColorDlgAdd           = MaxAlphaStrID - 40;
  s_ColorDlgDefine        = MaxAlphaStrID - 41;
  s_ColorDlgMainPal       = MaxAlphaStrID - 42;
  s_ColorDlgAddPal        = MaxAlphaStrID - 43;

  s_ColorDlgTitle         = MaxAlphaStrID - 44;
  s_ColorDlgRed           = MaxAlphaStrID - 45;
  s_ColorDlgGreen         = MaxAlphaStrID - 46;
  s_ColorDlgBlue          = MaxAlphaStrID - 47;
  s_ColorDlgDecimal       = MaxAlphaStrID - 48;
  s_ColorDlgHex           = MaxAlphaStrID - 49;

  // Frame adapter
  s_FrameAdapterError1    = MaxAlphaStrID - 50;

  // Hint designer
  s_HintDsgnTitle         = MaxAlphaStrID - 51;
  s_HintDsgnPreserved     = MaxAlphaStrID - 52;
  s_HintDsgnStyle         = MaxAlphaStrID - 53;
  s_HintDsgnBevelWidth    = MaxAlphaStrID - 54;
  s_Blur                  = MaxAlphaStrID - 55;
  s_HintDsgnArrowLength   = MaxAlphaStrID - 56;
  s_HintDsgnHorizMargin   = MaxAlphaStrID - 57;
  s_HintDsgnVertMargin    = MaxAlphaStrID - 58;
  s_HintDsgnRadius        = MaxAlphaStrID - 59;
  s_HintDsgnMaxWidth      = MaxAlphaStrID - 60;
  s_HintDsgnPauseHide     = MaxAlphaStrID - 61;
  s_Percent               = MaxAlphaStrID - 62;
  s_HintDsgnOffset        = MaxAlphaStrID - 63;
  s_HintDsgnTransparency  = MaxAlphaStrID - 64;
  s_HintDsgnNoPicture     = MaxAlphaStrID - 65;
  s_Font                  = MaxAlphaStrID - 66;
  s_Texture               = MaxAlphaStrID - 67;
  s_HintDsgnLoad          = MaxAlphaStrID - 68;
  s_HintDsgnSave          = MaxAlphaStrID - 69;
  s_HintDsgnColor         = MaxAlphaStrID - 70;
  s_HintDsgnBorderTop     = MaxAlphaStrID - 71;
  s_HintDsgnBorderBottom  = MaxAlphaStrID - 72;
  s_Shadow                = MaxAlphaStrID - 73;
  s_Background            = MaxAlphaStrID - 74;
  s_Gradient              = MaxAlphaStrID - 75;
  s_PreviewHint           = MaxAlphaStrID - 76;

  s_InvalidDate           = MaxAlphaStrID - 77;

  // File dialogs
  s_SelectDir             = MaxAlphaStrID - 89;
  s_Create                = MaxAlphaStrID - 90;
 
resourcestring // Comment resourcestrings if compiling of res-file is needed
  s_Root                 = 'Root :';
  
  s_DirWithSkins         = 'Directory with skins :';
  s_SelectSkinTitle      = 'Select skin';
  s_SkinPreview          = 'Skin preview';
  
//  s_InvalidDate          = 'Invalid date';

implementation

{$R sStrings.res}

end.
