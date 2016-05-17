object FormServiceInstall: TFormServiceInstall
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'FormServiceInstall'
  ClientHeight = 307
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 12
    Width = 30
    Height = 13
    Caption = 'T'#236'tulo:'
  end
  object Label2: TLabel
    Left = 18
    Top = 60
    Width = 83
    Height = 13
    Caption = 'Nome do servi'#231'o:'
  end
  object Label3: TLabel
    Left = 18
    Top = 107
    Width = 94
    Height = 13
    Caption = 'Local da instala'#231#227'o:'
  end
  object Label4: TLabel
    Left = 18
    Top = 157
    Width = 50
    Height = 13
    Caption = 'Descri'#231#227'o:'
  end
  object Label5: TLabel
    Left = 18
    Top = 205
    Width = 72
    Height = 13
    Caption = 'Reinicializa'#231#227'o:'
  end
  object Edit1: TEdit
    Left = 16
    Top = 31
    Width = 289
    Height = 21
    TabOrder = 0
    Text = 'IP_Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object Edit2: TEdit
    Left = 16
    Top = 79
    Width = 289
    Height = 21
    TabOrder = 1
    Text = 'IP_Edit1'
    OnKeyPress = Edit2KeyPress
  end
  object Edit3: TEdit
    Left = 18
    Top = 126
    Width = 289
    Height = 21
    TabOrder = 2
    Text = 'IP_Edit1'
    OnKeyPress = Edit3KeyPress
  end
  object Edit4: TEdit
    Left = 18
    Top = 176
    Width = 289
    Height = 21
    TabOrder = 3
    Text = 'IP_Edit1'
    OnKeyPress = Edit4KeyPress
  end
  object ComboBox1: TComboBox
    Left = 18
    Top = 224
    Width = 287
    Height = 21
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 4
    Text = 'Autom'#225'tico'
    Items.Strings = (
      'Autom'#225'tico'
      'Manual'
      'Desabilitado')
  end
  object CheckBox1: TCheckBox
    Left = 18
    Top = 274
    Width = 118
    Height = 25
    Caption = 'Iniciar agora'
    Checked = True
    State = cbChecked
    TabOrder = 5
  end
  object BitBtn1: TBitBtn
    Left = 142
    Top = 274
    Width = 81
    Height = 21
    Caption = 'OK'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 6
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 231
    Top = 274
    Width = 76
    Height = 21
    Caption = 'Cancelar'
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 7
    OnClick = BitBtn2Click
  end
end
