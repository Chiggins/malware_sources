object Form1: TForm1
  Left = 397
  Top = 312
  BorderStyle = bsDialog
  Caption = 'Custom tooltip'
  ClientHeight = 129
  ClientWidth = 254
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
    Left = 8
    Top = 8
    Width = 223
    Height = 26
    Caption = 
      'This simple app. demonstrates how to get the common tooltip wind' +
      'ow shared by all tray icons.'
    WordWrap = True
  end
  object Label2: TLabel
    Left = 8
    Top = 44
    Width = 235
    Height = 39
    Caption = 
      'The MouseEnter event changes the font and colors, while the Mous' +
      'eExit event resets them, so the tooltip will look normal for oth' +
      'er tray icons.'
    WordWrap = True
  end
  object Button1: TButton
    Left = 88
    Top = 94
    Width = 75
    Height = 25
    Caption = 'E&xit'
    TabOrder = 0
    OnClick = Button1Click
  end
  object CoolTrayIcon1: TCoolTrayIcon
    CycleInterval = 500
    Hint = 'This is a custom hint'
    Icon.Data = {
      0000010001001010040000000000280100001600000028000000100000002000
      0000010004000000000080000000000000000000000010000000000000000000
      0000000080000080000000808000800000008000800080800000C0C0C0008080
      80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      000000000000000000000000000000000000000000000000000000000000000F
      F00000FF000000FF00000FF0000000FF00000FF0000000FF00000FF0000000FF
      FF000FFFF000000FF00000FF0000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000FFFF0000E7CF0000C38700008103000081030000810300008103
      0000C3870000E7CF0000FFFF0000C3870000FFFF0000FFFF0000FFFF0000}
    IconVisible = True
    IconIndex = 0
    PopupMenu = PopupMenu1
    WantEnterExitEvents = True
    OnMouseEnter = CoolTrayIcon1MouseEnter
    OnMouseExit = CoolTrayIcon1MouseExit
    Left = 208
    Top = 92
  end
  object PopupMenu1: TPopupMenu
    Left = 176
    Top = 92
    object Exit1: TMenuItem
      Caption = '&Exit'
      OnClick = Exit1Click
    end
  end
end
