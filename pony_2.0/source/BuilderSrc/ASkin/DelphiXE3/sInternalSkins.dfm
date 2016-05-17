object FormInternalSkins: TFormInternalSkins
  Left = 532
  Top = 182
  Width = 430
  Height = 282
  BorderIcons = []
  BorderWidth = 8
  Caption = 'Internal skins'
  Color = clBtnFace
  Constraints.MaxWidth = 430
  Constraints.MinHeight = 282
  Constraints.MinWidth = 430
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sPanel2: TsPanel
    Left = 0
    Top = 15
    Width = 273
    Height = 213
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'CHECKBOX'
    object ListBox1: TsListBox
      Left = 0
      Top = 0
      Width = 273
      Height = 213
      Align = alClient
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      Sorted = True
      TabOrder = 0
      OnClick = ListBox1Click
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
    end
  end
  object sPanel3: TsPanel
    Left = 0
    Top = 0
    Width = 398
    Height = 15
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    SkinData.SkinSection = 'CHECKBOX'
    object sLabel1: TsLabel
      Left = 90
      Top = 0
      Width = 36
      Height = 13
      Caption = 'sLabel1'
    end
    object sLabel2: TsLabel
      Left = 0
      Top = 0
      Width = 84
      Height = 13
      Caption = 'External location:'
    end
  end
  object sPanel1: TsPanel
    Left = 273
    Top = 15
    Width = 125
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    SkinData.SkinSection = 'CHECKBOX'
    object sPanel4: TsPanel
      Left = 8
      Top = 0
      Width = 117
      Height = 180
      BevelOuter = bvLowered
      Caption = ' '
      TabOrder = 0
      SkinData.SkinSection = 'PANEL_LOW'
      object sButton2: TsButton
        Left = 13
        Top = 12
        Width = 90
        Height = 25
        Action = ActionAddNew
        TabOrder = 0
        SkinData.SkinSection = 'BUTTON'
      end
      object sButton3: TsButton
        Left = 13
        Top = 39
        Width = 90
        Height = 25
        Action = ActionRename
        TabOrder = 1
        SkinData.SkinSection = 'BUTTON'
      end
      object sButton4: TsButton
        Left = 13
        Top = 66
        Width = 90
        Height = 25
        Action = ActionExtract
        TabOrder = 2
        SkinData.SkinSection = 'BUTTON'
      end
      object sButton1: TsButton
        Left = 13
        Top = 93
        Width = 90
        Height = 25
        Action = ActionDelete
        TabOrder = 3
        SkinData.SkinSection = 'BUTTON'
      end
      object sButton5: TsButton
        Left = 13
        Top = 120
        Width = 90
        Height = 25
        Action = ActionClear
        TabOrder = 4
        SkinData.SkinSection = 'BUTTON'
      end
      object sButton6: TsButton
        Left = 13
        Top = 147
        Width = 90
        Height = 25
        Action = ActionUpdateAll
        TabOrder = 5
        SkinData.SkinSection = 'BUTTON'
      end
    end
    object sPanel5: TsPanel
      Left = 0
      Top = 187
      Width = 125
      Height = 26
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 1
      SkinData.SkinSection = 'CHECKBOX'
      object sBitBtn1: TsButton
        Left = 19
        Top = 1
        Width = 90
        Height = 25
        Action = ActionClose
        Anchors = [akLeft, akBottom]
        Cancel = True
        Default = True
        TabOrder = 0
        SkinData.SkinSection = 'BUTTON'
      end
    end
  end
  object ActionList1: TActionList
    Left = 76
    Top = 95
    object ActionAddNew: TAction
      Caption = 'Add new'
      OnExecute = ActionAddNewExecute
    end
    object ActionDelete: TAction
      Caption = 'Delete'
      Enabled = False
      OnExecute = ActionDeleteExecute
    end
    object ActionRename: TAction
      Caption = 'Rename'
      Enabled = False
      OnExecute = ActionRenameExecute
    end
    object ActionClose: TAction
      Caption = 'Close'
      ShortCut = 27
      OnExecute = ActionCloseExecute
    end
    object ActionClear: TAction
      Caption = 'Clear'
      OnExecute = ActionClearExecute
    end
    object ActionExtract: TAction
      Caption = 'Extract'
      Enabled = False
      OnExecute = ActionExtractExecute
    end
    object ActionUpdateAll: TAction
      Caption = 'Update all'
      OnExecute = ActionUpdateAllExecute
    end
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    ShowAppIcon = False
    TitleButtons = <>
    TitleIcon.Visible = False
    Left = 104
    Top = 95
  end
end
