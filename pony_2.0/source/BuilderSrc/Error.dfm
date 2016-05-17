object ErrorForm: TErrorForm
  Left = 545
  Top = 319
  Width = 421
  Height = 348
  Caption = #1055#1088#1086#1080#1079#1086#1096#1083#1072' '#1082#1088#1080#1090#1080#1095#1077#1089#1082#1072#1103' '#1086#1096#1080#1073#1082#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    405
    310)
  PixelsPerInch = 96
  TextHeight = 13
  object CloseButton: TButton
    Left = 323
    Top = 279
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1082#1088#1099#1090#1100
    TabOrder = 0
    OnClick = CloseButtonClick
  end
  object sGroupBox1: TsGroupBox
    Left = 0
    Top = 0
    Width = 401
    Height = 273
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1044#1072#1085#1085#1099#1077' '#1086#1073' '#1086#1096#1080#1073#1082#1077
    TabOrder = 1
    SkinData.SkinSection = 'GROUPBOX'
    DesignSize = (
      401
      273)
    object ErrorMemo: TsMemo
      Left = 8
      Top = 16
      Width = 385
      Height = 249
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 0
      BoundLabel.Indent = 0
      BoundLabel.Font.Charset = DEFAULT_CHARSET
      BoundLabel.Font.Color = clWindowText
      BoundLabel.Font.Height = -11
      BoundLabel.Font.Name = 'MS Sans Serif'
      BoundLabel.Font.Style = []
      BoundLabel.Layout = sclLeft
      BoundLabel.MaxWidth = 0
      BoundLabel.UseSkinColor = True
      SkinData.SkinSection = 'EDIT'
    end
  end
  object CopyButton: TsButton
    Left = 224
    Top = 280
    Width = 89
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1057#1082#1086#1087#1080#1088#1086#1074#1072#1090#1100
    TabOrder = 2
    OnClick = CopyButtonClick
    SkinData.SkinSection = 'BUTTON'
  end
end
