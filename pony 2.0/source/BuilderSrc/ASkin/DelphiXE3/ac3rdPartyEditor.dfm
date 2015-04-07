object Form3rdPartyEditor: TForm3rdPartyEditor
  Left = 251
  Top = 231
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = '3rd-party controls names'
  ClientHeight = 524
  ClientWidth = 730
  Color = clBtnFace
  Constraints.MinHeight = 140
  Constraints.MinWidth = 440
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sBitBtn2: TsSpeedButton
    Left = 26
    Top = 487
    Width = 53
    Height = 25
    Caption = 'New'
    Flat = True
    OnClick = sBitBtn2Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sBitBtn3: TsSpeedButton
    Left = 134
    Top = 487
    Width = 73
    Height = 25
    Caption = 'Delete'
    Flat = True
    OnClick = sBitBtn3Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton1: TsSpeedButton
    Left = 82
    Top = 487
    Width = 49
    Height = 25
    Caption = 'Edit'
    Enabled = False
    Flat = True
    OnClick = sSpeedButton1Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton2: TsSpeedButton
    Left = 364
    Top = 196
    Width = 35
    Height = 61
    Hint = 'Add package to the list'
    Caption = '<<'
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 21
    Font.Name = 'Small Fonts'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = sSpeedButton2Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton3: TsSpeedButton
    Left = 364
    Top = 292
    Width = 35
    Height = 57
    Hint = 'Remove package from list'
    Caption = '>>'
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = 21
    Font.Name = 'Small Fonts'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = sSpeedButton3Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sBitBtn4: TsSpeedButton
    Left = 298
    Top = 487
    Width = 99
    Height = 25
    Caption = 'Default settings'
    Visible = False
    OnClick = sBitBtn4Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton4: TsSpeedButton
    Left = 405
    Top = 487
    Width = 85
    Height = 25
    Caption = 'Save to file'
    Flat = True
    OnClick = sSpeedButton4Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton5: TsSpeedButton
    Left = 495
    Top = 487
    Width = 85
    Height = 25
    Caption = 'Load from file'
    Flat = True
    OnClick = sSpeedButton5Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sSpeedButton6: TsSpeedButton
    Left = 210
    Top = 487
    Width = 74
    Height = 25
    Hint = 'Remove all rows from list'
    Caption = 'Clear all'
    Flat = True
    OnClick = sSpeedButton6Click
    SkinData.SkinSection = 'SPEEDBUTTON'
  end
  object sListView1: TsListView
    Left = 24
    Top = 24
    Width = 333
    Height = 453
    BoundLabel.Active = True
    BoundLabel.Caption = 
      'List of controls which will be skinned automatically (register s' +
      'ensitive):'
    BoundLabel.Indent = 2
    BoundLabel.Layout = sclTopLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
    Columns = <
      item
        Caption = 'Control class name'
        Width = 160
      end
      item
        AutoSize = True
        Caption = 'Type of skin'
      end>
    HideSelection = False
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    PopupMenu = PopupMenu1
    SortType = stText
    TabOrder = 0
    ViewStyle = vsReport
    OnChange = sListView1Change
    OnColumnClick = sListView1ColumnClick
    OnDblClick = sListView1DblClick
  end
  object sBitBtn1: TsBitBtn
    Left = 648
    Top = 487
    Width = 59
    Height = 25
    Cancel = True
    Caption = 'Exit'
    TabOrder = 1
    OnClick = sBitBtn1Click
    SkinData.SkinSection = 'BUTTON'
  end
  object sPanel1: TsPanel
    Left = 404
    Top = 24
    Width = 305
    Height = 453
    TabOrder = 2
    SkinData.SkinSection = 'GROUPBOX'
    object sLabel1: TsLabel
      Left = 167
      Top = 424
      Width = 73
      Height = 13
      Caption = 'Change group :'
      ParentFont = False
    end
    object sListBox1: TsListBox
      Left = 16
      Top = 28
      Width = 129
      Height = 405
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      Items.Strings = (
        'Standard VCL'
        'Standard DB-aware'
        'TNT Controls'
        'Woll2Woll'
        'Virtual Controls'
        'EhLib'
        'Fast/Quick Report'
        'RXLib'
        'JVCL'
        'TMS edits'
        'SynEdits'
        'mxEdits'
        'RichViews'
        'Raize')
      TabOrder = 0
      OnClick = sListBox1Click
      BoundLabel.Active = True
      BoundLabel.Caption = 'Packages :'
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclTopLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
    object sListBox2: TsCheckListBox
      Left = 160
      Top = 28
      Width = 129
      Height = 387
      BorderStyle = bsSingle
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 1
      BoundLabel.Active = True
      BoundLabel.Caption = 'Supported controls :'
      BoundLabel.Indent = 0
      BoundLabel.Layout = sclTopLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
    object sCheckBox1: TsCheckBox
      Tag = 1
      Left = 246
      Top = 423
      Width = 21
      Height = 19
      Checked = True
      State = cbChecked
      TabOrder = 2
      OnClick = sCheckBox1Click
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
    object sCheckBox2: TsCheckBox
      Left = 268
      Top = 423
      Width = 21
      Height = 19
      TabOrder = 3
      OnClick = sCheckBox1Click
      SkinData.SkinSection = 'CHECKBOX'
      ImgChecked = 0
      ImgUnchecked = 0
    end
  end
  object sPanel2: TsPanel
    Left = 412
    Top = 12
    Width = 289
    Height = 21
    Caption = 'Predefined controls sets'
    TabOrder = 3
    SkinData.SkinSection = 'TOOLBAR'
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 368
    Top = 16
  end
  object PopupMenu1: TPopupMenu
    Left = 420
    Top = 4
    object Addnew1: TMenuItem
      Caption = 'Add new'
      ShortCut = 45
      OnClick = sBitBtn2Click
    end
    object Edit1: TMenuItem
      Caption = 'Edit'
      Enabled = False
      OnClick = Edit1Click
    end
    object Delete1: TMenuItem
      Caption = 'Delete'
      Enabled = False
      ShortCut = 46
      OnClick = sBitBtn3Click
    end
    object Defaultsettings1: TMenuItem
      Caption = 'Default settings'
      Visible = False
      OnClick = sBitBtn4Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      ShortCut = 27
      OnClick = sBitBtn1Click
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ini'
    Filter = 'Ini-files (*.ini)|*.ini|All files|*.*'
    Left = 420
    Top = 452
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'ini'
    Filter = 'Ini-files (*.ini)|*.ini|All files|*.*'
    Left = 448
    Top = 452
  end
end
