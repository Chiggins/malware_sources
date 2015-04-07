object acRootPathEditDlg: TacRootPathEditDlg
  Left = 361
  Top = 321
  Width = 340
  Height = 240
  BorderStyle = bsSizeToolWin
  Caption = 'Select Root Path'
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 340
  ParentFont = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Button1: TsBitBtn
    Left = 150
    Top = 176
    Width = 77
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 0
    OnClick = Button1Click
    Kind = bkOK
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object Button2: TsBitBtn
    Left = 229
    Top = 176
    Width = 77
    Height = 25
    Anchors = [akTop, akRight]
    TabOrder = 1
    OnClick = Button2Click
    Kind = bkCancel
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object GroupBox1: TsGroupBox
    Left = 10
    Top = 7
    Width = 319
    Height = 80
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    SkinData.SkinSection = 'GROUPBOX'
    object cbFolderType: TsComboBox
      Left = 20
      Top = 34
      Width = 279
      Height = 24
      Alignment = taLeftJustify
      BoundLabel.Indent = 0
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'COMBOBOX'
      Anchors = [akLeft, akTop, akRight]
      ItemHeight = 16
      ItemIndex = -1
      TabOrder = 0
    end
  end
  object rbUseFolder: TsRadioButton
    Left = 20
    Top = 6
    Width = 123
    Height = 20
    Caption = 'Use Standard &Folder'
    TabOrder = 2
    OnClick = rbUseFolderClick
    SkinData.SkinSection = 'CHECKBOX'
  end
  object GroupBox2: TsGroupBox
    Left = 10
    Top = 95
    Width = 319
    Height = 70
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    SkinData.SkinSection = 'GROUPBOX'
    object ePath: TsDirectoryEdit
      Left = 20
      Top = 30
      Width = 277
      Height = 21
      AutoSize = False
      MaxLength = 255
      TabOrder = 0
      BoundLabel.Indent = 0
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
      GlyphMode.Blend = 0
      GlyphMode.Grayed = False
      Root = 'rfDesktop'
    end
  end
  object rbUsePath: TsRadioButton
    Left = 20
    Top = 95
    Width = 70
    Height = 20
    Caption = 'Use &Path'
    TabOrder = 5
    OnClick = rbUsePathClick
    SkinData.SkinSection = 'CHECKBOX'
  end
  object OpenDialog1: TsOpenDialog
    Left = 8
    Top = 160
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    ShowAppIcon = False
    TitleButtons = <>
    Left = 220
    Top = 3
  end
end
