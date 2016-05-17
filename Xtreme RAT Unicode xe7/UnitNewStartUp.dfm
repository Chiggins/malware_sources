object FormNewStartUp: TFormNewStartUp
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 132
  ClientWidth = 264
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
    Left = 16
    Top = 40
    Width = 34
    Height = 13
    Caption = 'Nome: '
  end
  object Label2: TLabel
    Left = 16
    Top = 68
    Width = 31
    Height = 13
    Caption = 'Valor: '
  end
  object SpeedButton1: TSpeedButton
    Left = 16
    Top = 96
    Width = 233
    Height = 25
    Caption = 'OK'
    Flat = True
    OnClick = SpeedButton1Click
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 8
    Width = 233
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 0
    Text = 'HKEY_CURRENT_USER'
    Items.Strings = (
      'HKEY_CURRENT_USER'
      'HKEY_LOCAL_MACHINE')
  end
  object Edit1: TEdit
    Left = 80
    Top = 37
    Width = 169
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object Edit2: TEdit
    Left = 80
    Top = 65
    Width = 169
    Height = 21
    TabOrder = 2
    Text = 'Edit2'
  end
end
