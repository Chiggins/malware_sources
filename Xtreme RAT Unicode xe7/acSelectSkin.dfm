object FormSkinSelect: TFormSkinSelect
  Left = 555
  Top = 522
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Select skin'
  ClientHeight = 348
  ClientWidth = 507
  Color = clBtnFace
  Constraints.MinHeight = 360
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    507
    348)
  PixelsPerInch = 96
  TextHeight = 13
  object sStickyLabel1: TsStickyLabel
    Left = 163
    Top = 309
    Width = 68
    Height = 13
    Caption = '  Satura'#231#227'o: 0'
    AlignTo = altTop
    AttachTo = sTrackBar1
  end
  object sStickyLabel2: TsStickyLabel
    Left = 250
    Top = 309
    Width = 39
    Height = 13
    Caption = '  HUE: 0'
    AlignTo = altTop
    AttachTo = sTrackBar2
  end
  object sListBox1: TsListBox
    Left = 16
    Top = 53
    Width = 130
    Height = 281
    Anchors = [akLeft, akTop, akBottom]
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
    OnClick = sListBox1Click
    OnDblClick = sListBox1DblClick
    BoundLabel.Caption = 'Available skins :'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'Tahoma'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclTopLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
  end
  object sBitBtn1: TsBitBtn
    Left = 340
    Top = 313
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    DoubleBuffered = True
    Enabled = False
    ModalResult = 1
    ParentDoubleBuffered = False
    TabOrder = 1
    SkinData.SkinSection = 'BUTTON'
  end
  object sBitBtn2: TsBitBtn
    Left = 420
    Top = 313
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    DoubleBuffered = True
    ModalResult = 2
    ParentDoubleBuffered = False
    TabOrder = 2
    SkinData.SkinSection = 'BUTTON'
  end
  object sPanel1: TsPanel
    Left = 163
    Top = 53
    Width = 330
    Height = 251
    Anchors = [akLeft, akTop, akRight, akBottom]
    BevelOuter = bvNone
    Caption = 'Skin preview'
    Enabled = False
    TabOrder = 3
    SkinData.SkinSection = 'CHECKBOX'
  end
  object sDirectoryEdit1: TsDirectoryEdit
    Left = 128
    Top = 16
    Width = 365
    Height = 21
    AutoSize = False
    MaxLength = 255
    TabOrder = 4
    OnChange = sDirectoryEdit1Change
    BoundLabel.Active = True
    BoundLabel.Caption = 'Directory with skins :'
    BoundLabel.Indent = 0
    BoundLabel.Font.Charset = DEFAULT_CHARSET
    BoundLabel.Font.Color = clWindowText
    BoundLabel.Font.Height = -11
    BoundLabel.Font.Name = 'Tahoma'
    BoundLabel.Font.Style = []
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Blend = 0
    GlyphMode.Grayed = False
    Root = 'rfDesktop'
  end
  object sTrackBar1: TsTrackBar
    Left = 163
    Top = 324
    Width = 81
    Height = 16
    Max = 100
    Min = -100
    TabOrder = 5
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = sTrackBar1Change
    SkinData.SkinSection = 'TRACKBAR'
  end
  object sTrackBar2: TsTrackBar
    Left = 250
    Top = 324
    Width = 81
    Height = 16
    Max = 360
    Frequency = 18
    TabOrder = 6
    ThumbLength = 15
    TickStyle = tsNone
    OnChange = sTrackBar2Change
    SkinData.SkinSection = 'TRACKBAR'
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 448
    Top = 8
  end
end
