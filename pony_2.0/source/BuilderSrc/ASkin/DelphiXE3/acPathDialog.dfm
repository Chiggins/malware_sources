object PathDialogForm: TPathDialogForm
  Left = 434
  Top = 310
  Width = 350
  Height = 420
  Caption = 'Select directory'
  Constraints.MinHeight = 250
  Constraints.MinWidth = 275
  Position = poScreenCenter
  Scaled = False
  object sLabel1: TsLabel
    Left = 8
    Top = 3
    Width = 3
    Height = 13
  end
  object sBitBtn1: TsBitBtn
    Left = 173
    Top = 344
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = sBitBtn1Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sBitBtn2: TsBitBtn
    Left = 250
    Top = 344
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    OnClick = sBitBtn2Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sBitBtn3: TsBitBtn
    Left = 12
    Top = 344
    Width = 75
    Height = 25
    Caption = 'Create'
    Enabled = False
    TabOrder = 3
    OnClick = sBitBtn3Click
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sShellTreeView1: TsShellTreeView
    Left = 8
    Top = 20
    Width = 321
    Height = 319
    Indent = 19
    ShowRoot = False
    TabOrder = 0
    OnChange = sShellTreeView1Change
    BoundLabel.Active = True
    BoundLabel.Caption = ' '
    BoundLabel.Indent = 4
    BoundLabel.Layout = sclTopLeft
    BoundLabel.MaxWidth = 0
    SkinData.SkinSection = 'EDIT'
    ObjectTypes = [otFolders, otHidden]
    Root = 'rfDesktop'
    UseShellImages = True
    AutoRefresh = False
    ShowExt = seSystem
  end
  object sScrollBox1: TsScrollBox
    Left = 8
    Top = 20
    Width = 101
    Height = 318
    VertScrollBar.Tracking = True
    TabOrder = 4
    Visible = False
    SkinData.SkinSection = 'BAR'
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'DIALOG'
    GripMode = gmRightBottom
    ShowAppIcon = False
    TitleButtons = <>
    Left = 212
    Top = 168
  end
  object ImageList1: TsAlphaImageList
    ShareImages = True
    Left = 180
    Top = 168
  end
end
