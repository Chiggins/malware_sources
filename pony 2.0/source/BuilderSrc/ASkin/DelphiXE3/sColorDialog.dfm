object sColorDialogForm: TsColorDialogForm
  Left = 349
  Top = 356
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Color'
  ClientHeight = 385
  ClientWidth = 532
  Color = clBtnFace
  Constraints.MaxHeight = 416
  Constraints.MaxWidth = 541
  Constraints.MinHeight = 416
  Constraints.MinWidth = 235
  ParentFont = True
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnDestroy = FormDestroy
  OnCreate = FormCreate
  OnMouseDown = FormMouseDown
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLabel1: TsLabel
    Left = 8
    Top = 8
    Width = 64
    Height = 13
    Caption = 'Main palette :'
  end
  object sLabel2: TsLabel
    Left = 8
    Top = 192
    Width = 83
    Height = 13
    Caption = 'Additional colors :'
  end
  object sLabel4: TsLabel
    Left = 430
    Top = 276
    Width = 6
    Height = 14
    Caption = 'o'
  end
  object sLabel5: TsLabel
    Left = 429
    Top = 304
    Width = 8
    Height = 13
    Caption = '%'
  end
  object sLabel6: TsLabel
    Left = 429
    Top = 328
    Width = 8
    Height = 13
    Caption = '%'
  end
  object sSpeedButton1: TsSpeedButton
    Left = 20
    Top = 308
    Width = 37
    Height = 33
    Flat = True
    Glyph.Data = {
      06030000424D06030000000000003600000028000000100000000F0000000100
      180000000000D002000000000000000000000000000000000000FF00FFBFBF00
      BFBF00BFBF00BFBF00BFBF00BFBF00BFBF00FF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFBFBF00BFBF00000000000000000000BFBF00BFBF00BF
      BF00BFBF00BFBF00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFBFBF00
      000000BFBF00BFBF00000000BFBF00BFBF00BFBF00FF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFBFBF00000000FF
      00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FF000000FFFFFFFFFFFFBFBF00000000FF00FFFF00FFFF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFFBF
      BF00000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FF000000FFFFFFFFFFFF808080000000FF00FFFF00FFFF00
      FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF
      FFFFFFFFFF808080000000FF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FF000000FFFFFFFFFFFF8080800000000000
      00FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF000000FFFFFF000000000000000000000000FF00FFFF00FFFF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000000000
      00000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FF000000000000000000000000000000000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000000000000000
      00000000000000000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
      00FFFF00FFFF00FFFF00FF000000C0C0C0000000000000000000FF00FFFF00FF
      FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0000
      00000000000000FF00FF}
    OnClick = sSpeedButton1Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sBitBtn1: TsBitBtn
    Left = 7
    Top = 352
    Width = 69
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 8
    OnClick = sBitBtn1Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sBitBtn2: TsBitBtn
    Left = 77
    Top = 352
    Width = 69
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 9
    OnClick = sBitBtn2Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object ColorPanel: TsPanel
    Left = 234
    Top = 8
    Width = 260
    Height = 260
    BevelOuter = bvNone
    Caption = ' '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 15
    TabStop = True
    OnMouseDown = ColorPanelMouseDown
    OnMouseMove = ColorPanelMouseMove
    OnMouseUp = ColorPanelMouseUp
    SkinData.SkinSection = 'CHECKBOX'
    OnPaint = ColorPanelPaint
  end
  object GradPanel: TsPanel
    Left = 502
    Top = 8
    Width = 20
    Height = 260
    BevelOuter = bvNone
    Caption = ' '
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 16
    TabStop = True
    OnMouseDown = GradPanelMouseDown
    OnMouseMove = GradPanelMouseMove
    OnMouseUp = GradPanelMouseUp
    SkinData.SkinSection = 'CHECKBOX'
    OnPaint = GradPanelPaint
  end
  object SelectedPanel: TShape
    Left = 234
    Top = 276
    Width = 131
    Height = 69
    Brush.Color = clGreen
    Pen.Style = psInsideFrame
  end
  object sREdit: TsCurrencyEdit
    Left = 494
    Top = 276
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 5
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Red :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sGEdit: TsCurrencyEdit
    Left = 494
    Top = 300
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 6
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Green :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sBEdit: TsCurrencyEdit
    Left = 494
    Top = 324
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 7
    OnChange = sREditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Blue :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sBitBtn3: TsBitBtn
    Left = 236
    Top = 352
    Width = 291
    Height = 25
    Caption = 'Add to custom colors set'
    TabOrder = 11
    OnClick = sBitBtn3Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sBitBtn4: TsBitBtn
    Left = 8
    Top = 268
    Width = 209
    Height = 25
    Caption = 'Define colors'
    Enabled = False
    TabOrder = 12
    OnClick = sBitBtn4Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sHEdit: TsCurrencyEdit
    Left = 394
    Top = 276
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 2
    OnChange = sHEditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'H :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sSEdit: TsCurrencyEdit
    Left = 394
    Top = 300
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 3
    OnChange = sHEditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'S :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sVEdit: TsCurrencyEdit
    Left = 394
    Top = 324
    Width = 33
    Height = 19
    AutoSize = False
    TabOrder = 4
    OnChange = sHEditChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'B :'
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object MainPal: TsColorsPanel
    Left = 1
    Top = 21
    Width = 223
    Height = 167
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 13
    TabStop = True
    OnDblClick = MainPalDblClick
    SkinData.SkinSection = 'CHECKBOX'
    ColCount = 8
    Colors.Strings = (
      '8080FF'
      '80FFFF'
      '80FF80'
      '80FF00'
      'FFFF80'
      'FF8000'
      'C080FF'
      'FF80FF'
      '0000FF'
      '00FFFF'
      '00FF80'
      '40FF00'
      'FFFF00'
      'C08000'
      'C08080'
      'FF00FF'
      '404080'
      '4080FF'
      '00FF00'
      '808000'
      '804000'
      'FF8080'
      '400080'
      '8000FF'
      '000080'
      '0080FF'
      '008000'
      '408000'
      'FF0000'
      'A00000'
      '800080'
      'FF0080'
      '000040'
      '004080'
      '004000'
      '004040'
      '800000'
      '400000'
      '400040'
      '800040'
      '000000'
      '008080'
      '408080'
      '808080'
      '808040'
      'C0C0C0'
      '400040'
      'FFFFFF')
    RowCount = 6
    OnChange = MainPalChange
  end
  object AddPal: TsColorsPanel
    Left = 1
    Top = 205
    Width = 223
    Height = 59
    BevelOuter = bvNone
    Caption = ' '
    TabOrder = 14
    TabStop = True
    OnDblClick = AddPalDblClick
    SkinData.SkinSection = 'CHECKBOX'
    ColCount = 8
    Colors.Strings = (
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF'
      'FFFFFF')
    OnChange = MainPalChange
  end
  object sEditDecimal: TsCurrencyEdit
    Left = 142
    Top = 323
    Width = 70
    Height = 19
    AutoSize = False
    TabOrder = 1
    OnChange = sEditDecimalChange
    BoundLabel.Active = True
    BoundLabel.Caption = 'Decimal - '
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    GlyphMode.Grayed = False
    Alignment = taLeftJustify
    DecimalPlaces = 0
    DisplayFormat = '0'
  end
  object sEditHex: TsMaskEdit
    Left = 142
    Top = 302
    Width = 70
    Height = 21
    CharCase = ecUpperCase
    EditMask = 'AAAAAA;1; '
    MaxLength = 6
    TabOrder = 0
    Text = '      '
    OnChange = sEditHexChange
    OnKeyPress = sEditHexKeyPress
    BoundLabel.Active = True
    BoundLabel.Caption = 'Hex - '
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
  end
  object sBitBtn5: TsBitBtn
    Left = 147
    Top = 352
    Width = 69
    Height = 25
    Caption = 'Help'
    TabOrder = 10
    OnClick = sBitBtn5Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'DIALOG'
    ScreenSnap = True
    ShowAppIcon = False
    TitleButtons = <>
    Left = 320
    Top = 20
  end
end
