object FormShell: TFormShell
  Left = 192
  Top = 124
  Caption = 'FormShell'
  ClientHeight = 291
  ClientWidth = 537
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 537
    Height = 291
    Align = alClient
    DoubleBuffered = True
    Lines.Strings = (
      'Memo1')
    ParentDoubleBuffered = False
    ScrollBars = ssBoth
    TabOrder = 0
    OnKeyPress = Memo1KeyPress
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 24
    Top = 72
  end
end
