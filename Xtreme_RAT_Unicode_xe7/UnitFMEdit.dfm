object FormFMEdit: TFormFMEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FormFMEdit'
  ClientHeight = 66
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 11
    Top = 37
    Width = 34
    Height = 13
    Caption = 'Nome: '
  end
  object bsSkinStdLabel2: TLabel
    Left = 297
    Top = 37
    Width = 14
    Height = 13
    Cursor = crHandPoint
    Caption = 'OK'
    OnClick = bsSkinStdLabel2Click
  end
  object Edit1: TEdit
    Left = 67
    Top = 34
    Width = 224
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 8
    Width = 73
    Height = 17
    Caption = 'Oculto'
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 103
    Top = 8
    Width = 73
    Height = 17
    Caption = 'Sistema'
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    Left = 199
    Top = 8
    Width = 112
    Height = 17
    Caption = 'Somente leitura'
    TabOrder = 3
  end
end
