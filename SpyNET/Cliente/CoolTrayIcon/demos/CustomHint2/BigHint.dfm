object Form1: TForm1
  Left = 292
  Top = 215
  BorderStyle = bsDialog
  Caption = 'Big Hint Demo'
  ClientHeight = 108
  ClientWidth = 213
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 12
    Top = 12
    Width = 175
    Height = 13
    Caption = 'Position the cursor over the tray icon.'
    ShowAccelChar = False
  end
  object Label2: TLabel
    Left = 12
    Top = 34
    Width = 191
    Height = 26
    Caption = 'Use the popu menu to change between different hint windows.'
    ShowAccelChar = False
    WordWrap = True
  end
  object Button1: TButton
    Left = 128
    Top = 74
    Width = 75
    Height = 25
    Caption = 'E&xit'
    TabOrder = 0
    OnClick = Button1Click
  end
  object TextTrayIcon1: TTextTrayIcon
    CycleInterval = 0
    Hint = '- FIRST LINE -'
    ShowHint = False
    Icon.Data = {
      0000010001001010040000000000280100001600000028000000100000002000
      0000010004000000000080000000000000000000000010000000000000000000
      0000000080000080000000808000800000008000800080800000C0C0C0008080
      80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      000000000000074447FFFF7444700FF848FFFF848FF00FFF447FF744FFF00FFF
      747FF747FFF00FFF748FF847FFF00FFFF44FF44FFFF00FFFF44FF44FFFF00FFF
      F44FF44FFFF00FFFF44FF44FFFF00FFF748FF847FFF00FFF747FF747FFF00FFF
      447FF744FFF00FF848FFFF848FF0078447FFFF74487000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000}
    IconVisible = True
    IconIndex = 0
    PopupMenu = PopupMenu1
    WantEnterExitEvents = True
    OnMouseMove = TextTrayIcon1MouseMove
    OnMouseEnter = TextTrayIcon1MouseEnter
    OnMouseExit = TextTrayIcon1MouseExit
    Text = 'OO'
    Font.Charset = EASTEUROPE_CHARSET
    Font.Color = clNavy
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    Color = clWhite
    Border = True
    Options.OffsetX = 0
    Options.OffsetY = 0
    Options.LineDistance = 0
    Left = 12
    Top = 70
  end
  object PopupMenu1: TPopupMenu
    Left = 52
    Top = 70
    object Regular1: TMenuItem
      Caption = '&Regular THintWindow'
      Checked = True
      GroupIndex = 1
      RadioItem = True
      OnClick = Regular1Click
    end
    object Custom1: TMenuItem
      Caption = '&Tiled THintWindow'
      GroupIndex = 1
      RadioItem = True
      OnClick = Custom1Click
    end
    object N1: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object Exit1: TMenuItem
      Caption = 'E&xit'
      GroupIndex = 1
      OnClick = Exit1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 64
    Top = 70
  end
  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 76
    Top = 70
  end
end
