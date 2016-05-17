object SkinInfoForm: TSkinInfoForm
  Left = 447
  Top = 369
  BorderStyle = bsDialog
  Caption = 'Current skin information'
  ClientHeight = 193
  ClientWidth = 286
  Color = clBtnFace
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 150
    Width = 212
    Height = 40
    Alignment = taCenter
    AutoSize = False
    Caption = 
      'NOTE : Current skin requires modernization! Please link with AC ' +
      'team for additional information.'
    Visible = False
    WordWrap = True
  end
  object sBitBtn1: TsBitBtn
    Left = 218
    Top = 157
    Width = 60
    Height = 25
    Cancel = True
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    SkinData.SkinSection = 'BUTTON'
    ShowFocus = False
  end
  object sMemo1: TsMemo
    Left = 8
    Top = 9
    Width = 270
    Height = 136
    TabOrder = 1
    BoundLabel.Indent = 0
    BoundLabel.Layout = sclLeft
    BoundLabel.MaxWidth = 0
    BoundLabel.UseSkinColor = True
    SkinData.SkinSection = 'EDIT'
  end
  object sSkinProvider1: TsSkinProvider
    CaptionAlignment = taCenter
    SkinData.SkinSection = 'DIALOG'
    TitleButtons = <>
    Left = 248
    Top = 16
  end
end
