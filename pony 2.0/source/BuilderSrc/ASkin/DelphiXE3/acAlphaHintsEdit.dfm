object AlphaHintsEdit: TAlphaHintsEdit
  Left = 411
  Top = 122
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Hints templates editor'
  ClientHeight = 419
  ClientWidth = 722
  Color = clBtnFace
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object sSpeedButton3: TsSpeedButton
    Tag = 1
    Left = 556
    Top = 64
    Width = 145
    Height = 22
    Caption = 'Change font properties'
    Enabled = False
    OnClick = sSpeedButton3Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sBitBtn1: TsBitBtn
    Left = 554
    Top = 376
    Width = 72
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
    SkinData.SkinSection = 'BUTTON'
  end
  object sBitBtn2: TsBitBtn
    Left = 630
    Top = 376
    Width = 76
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 1
    SkinData.SkinSection = 'BUTTON'
  end
  object sPageControl1: TsPageControl
    Left = 12
    Top = 12
    Width = 521
    Height = 397
    ActivePage = sTabSheet1
    TabOrder = 2
    OnChange = sPageControl1Change
    SkinData.SkinSection = 'PAGECONTROL'
    object sTabSheet1: TsTabSheet
      Caption = ' Default image '
      SkinData.CustomColor = False
      SkinData.CustomFont = False
      inline FrameTL: TFrameHintPage
        Left = 2
        Top = 2
        Width = 505
        Height = 405
        TabOrder = 0
      end
    end
    object sTabSheet2: TsTabSheet
      Caption = ' Right-Top '
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
    end
    object sTabSheet3: TsTabSheet
      Caption = ' Left-Bottom '
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
    end
    object sTabSheet4: TsTabSheet
      Caption = ' Right-Bottom '
      TabVisible = False
      SkinData.CustomColor = False
      SkinData.CustomFont = False
    end
  end
  object sEdit1: TsEdit
    Tag = 1
    Left = 556
    Top = 32
    Width = 145
    Height = 21
    Enabled = False
    TabOrder = 3
    OnChange = sEdit1Change
    SkinData.SkinSection = 'EDIT'
    BoundLabel.Active = True
    BoundLabel.Caption = 'Current template name :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclTopLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
  end
  object sCheckBox1: TsCheckBox
    Tag = 1
    Left = 564
    Top = 97
    Width = 128
    Height = 19
    Caption = 'Use additional images'
    Enabled = False
    TabOrder = 4
    OnClick = sCheckBox1Click
    SkinData.SkinSection = 'CHECKBOX'
    ImgChecked = 0
    ImgUnchecked = 0
  end
  object sGroupBox1: TsGroupBox
    Left = 558
    Top = 136
    Width = 141
    Height = 221
    Caption = ' Templates list : '
    TabOrder = 5
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object sSpeedButton1: TsSpeedButton
      Left = 9
      Top = 20
      Width = 60
      Height = 22
      Caption = 'New'
      Flat = True
      OnClick = sSpeedButton1Click
      SkinData.SkinSection = 'SPEEDBUTTON'
    end
    object sSpeedButton2: TsSpeedButton
      Tag = 1
      Left = 73
      Top = 20
      Width = 60
      Height = 22
      Caption = 'Delete'
      Enabled = False
      Flat = True
      OnClick = sSpeedButton2Click
      SkinData.SkinSection = 'SPEEDBUTTON'
    end
    object sListBox1: TsListBox
      Left = 8
      Top = 50
      Width = 125
      Height = 163
      BoundLabel.Indent = 0
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
      ItemHeight = 13
      TabOrder = 0
      OnClick = sListBox1Click
    end
  end
  object Hints: TsAlphaHints
    Tag = -98
    Active = False
    Templates = <>
    SkinSection = 'HINT'
    Left = 58
    Top = 54
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    ShowAppIcon = False
    TitleButtons = <>
    Left = 86
    Top = 54
  end
  object FontDialog1: TFontDialog
    Left = 114
    Top = 54
  end
end
