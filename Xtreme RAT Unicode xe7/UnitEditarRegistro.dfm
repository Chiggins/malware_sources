object FormEditarRegistro: TFormEditarRegistro
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FormEditarRegistro'
  ClientHeight = 204
  ClientWidth = 383
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
    Left = 8
    Top = 11
    Width = 89
    Height = 13
    Caption = 'Nome do registro: '
  end
  object Label2: TLabel
    Left = 8
    Top = 67
    Width = 92
    Height = 13
    Caption = 'Dados do registro: '
  end
  object Edit1: TEdit
    Left = 8
    Top = 30
    Width = 209
    Height = 21
    TabOrder = 0
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object AdvOfficeRadioGroup1: TRadioGroup
    Left = 223
    Top = 11
    Width = 150
    Height = 143
    Caption = 'Tipo de registro'
    Enabled = False
    Items.Strings = (
      'REG_SZ'
      'REG_BINARY'
      'REG_DWORD'
      'REG_MULTI_SZ'
      'REG_EXPAND_SZ')
    TabOrder = 1
  end
  object Memo1: TMemo
    Left = 8
    Top = 86
    Width = 209
    Height = 100
    Lines.Strings = (
      'Memo1')
    TabOrder = 2
    OnKeyPress = Memo1KeyPress
  end
  object BitBtn1: TBitBtn
    Left = 223
    Top = 160
    Width = 150
    Height = 25
    Caption = 'OK'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 3
    OnClick = BitBtn1Click
  end
end
