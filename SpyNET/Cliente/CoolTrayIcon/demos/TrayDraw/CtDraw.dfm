object DrawForm: TDrawForm
  Left = 330
  Top = 307
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'CoolTrayIcon Drawing Demo'
  ClientHeight = 206
  ClientWidth = 281
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Shape1: TShape
    Left = 11
    Top = 11
    Width = 162
    Height = 162
  end
  object PaintBox1: TPaintBox
    Left = 12
    Top = 12
    Width = 160
    Height = 160
    Color = clWhite
    ParentColor = False
    OnMouseDown = PaintBox1MouseDown
    OnMouseMove = PaintBox1MouseMove
    OnMouseUp = PaintBox1MouseUp
    OnPaint = PaintBox1Paint
  end
  object Button2: TButton
    Left = 192
    Top = 12
    Width = 75
    Height = 25
    Caption = '&Clear'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 192
    Top = 44
    Width = 75
    Height = 25
    Caption = '&Load...'
    TabOrder = 1
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 192
    Top = 146
    Width = 75
    Height = 25
    Caption = 'E&xit'
    TabOrder = 3
    OnClick = Button4Click
  end
  object CheckBox1: TCheckBox
    Left = 12
    Top = 180
    Width = 109
    Height = 17
    Caption = '&Transparent'
    TabOrder = 4
    OnClick = CheckBox1Click
  end
  object Button1: TButton
    Left = 192
    Top = 114
    Width = 75
    Height = 25
    Caption = '&?'
    TabOrder = 2
    TabStop = False
    OnClick = Button1Click
  end
  object CoolTrayIcon1: TCoolTrayIcon
    CycleInterval = 0
    ShowHint = False
    Icon.Data = {
      0000010001001010100000000000280100001600000028000000100000002000
      00000100040000000000C0000000000000000000000000000000000000000000
      0000000080000080000000808000800000008000800080800000C0C0C0008080
      80000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000FFFF
      0000FFFF0000DFF70000C7C70000EBAF0000EC6F0000F55F0000F39F0000EBAF
      00009BB3000000010000FD7F0000FD7F0000FEFF0000FEFF0000FFFF0000}
    IconVisible = True
    IconIndex = 0
    Left = 200
    Top = 78
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 'Bitmaps (*.bmp)|*.bmp|All files (*.*)|*.*'
    Left = 236
    Top = 78
  end
end
