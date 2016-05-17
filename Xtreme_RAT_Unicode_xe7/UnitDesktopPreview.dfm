object FormDesktopPreview: TFormDesktopPreview
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 120
  ClientWidth = 150
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 150
    Height = 120
    Align = alClient
    Stretch = True
    ExplicitLeft = 56
    ExplicitTop = 48
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 40
    Top = 32
  end
end
