object StrEditDlg: TStrEditDlg
  Left = 403
  Top = 399
  Width = 450
  Height = 312
  BorderStyle = bsSizeToolWin
  Caption = 'String list editor'
  Color = clBtnFace
  Constraints.MinHeight = 305
  Constraints.MinWidth = 450
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TsPanel
    Left = 0
    Top = 0
    Width = 442
    Height = 237
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'CHECKBOX'
    object LineCount: TsLabel
      Left = 12
      Top = 5
      Width = 169
      Height = 17
      AutoSize = False
      Caption = '0 lines'
    end
    object Memo: TsMemo
      Left = 8
      Top = 21
      Width = 426
      Height = 209
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      OnChange = UpdateStatus
      OnKeyDown = MemoKeyDown
      BoundLabel.Indent = 0
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 237
    Width = 442
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    SkinData.SkinSection = 'CHECKBOX'
    object OKBtn: TsButton
      Left = 187
      Top = 9
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      ModalResult = 1
      TabOrder = 0
      SkinData.SkinSection = 'BUTTON'
    end
    object CancelBtn: TsButton
      Left = 267
      Top = 9
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
      SkinData.SkinSection = 'BUTTON'
    end
    object HelpBtn: TsButton
      Left = 347
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Help'
      TabOrder = 2
      OnClick = HelpBtnClick
      SkinData.SkinSection = 'BUTTON'
    end
    object LoadBtn: TsButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Load...'
      TabOrder = 3
      OnClick = FileOpen
      SkinData.SkinSection = 'BUTTON'
    end
    object SaveBtn: TsButton
      Left = 92
      Top = 9
      Width = 75
      Height = 25
      Caption = '&Save...'
      TabOrder = 4
      OnClick = FileSave
      SkinData.SkinSection = 'BUTTON'
    end
  end
  object OpenDialog: TOpenDialog
    DefaultExt = 'TXT'
    Filter = 
      'Text files (*.TXT)|*.TXT|Config files (*.SYS;*.INI)|*.SYS;*.INI|' +
      'Batch files (*.BAT)|*.BAT|All files (*.*)|*.*'
    Options = [ofHideReadOnly, ofShowHelp, ofPathMustExist, ofFileMustExist]
    Title = 'Load string list'
    Left = 364
  end
  object SaveDialog: TSaveDialog
    Filter = 
      'Text files (*.TXT)|*.TXT|Config files (*.SYS;*.INI)|*.SYS;*.INI|' +
      'Batch files (*.BAT)|*.BAT|All files (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofShowHelp, ofPathMustExist]
    Title = 'Save string list'
    Left = 392
  end
  object sSkinProvider1: TsSkinProvider
    SkinData.SkinSection = 'FORM'
    GripMode = gmRightBottom
    TitleButtons = <>
    Left = 236
  end
end
