object FormPortas: TFormPortas
  Left = 979
  Top = 122
  BorderStyle = bsDialog
  Caption = 'FormPortas'
  ClientHeight = 295
  ClientWidth = 254
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 149
    Top = 224
    Width = 94
    Height = 14
    Caption = 'Senha de conex'#227'o:'
  end
  object Label2: TLabel
    Left = 152
    Top = 164
    Width = 87
    Height = 14
    Caption = 'Limite de conex'#227'o'
  end
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 137
    Height = 295
    Align = alLeft
    Columns = <
      item
        Caption = 'Portas ativas'
        MinWidth = 80
        Width = 90
      end>
    Items.Data = {1F0000000100000005010000FFFFFFFFFFFFFFFF0000000000000000023831}
    LargeImages = FormPrincipal.ImageListIcons
    ReadOnly = True
    RowSelect = True
    SmallImages = FormPrincipal.ImageListIcons
    TabOrder = 0
    ViewStyle = vsReport
  end
  object Edit1: TEdit
    Left = 182
    Top = 24
    Width = 62
    Height = 22
    MaxLength = 5
    TabOrder = 1
    Text = 'Edit1'
    OnEnter = Edit1Enter
    OnExit = Edit1Exit
    OnKeyPress = Edit1KeyPress
  end
  object BitBtn1: TBitBtn
    Left = 149
    Top = 24
    Width = 33
    Height = 21
    TabOrder = 2
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 149
    Top = 56
    Width = 96
    Height = 21
    Caption = 'Deletar'
    TabOrder = 3
    OnClick = BitBtn2Click
  end
  object Edit2: TEdit
    Left = 149
    Top = 243
    Width = 97
    Height = 22
    PasswordChar = '*'
    TabOrder = 4
    Text = 'Edit2'
    OnEnter = Edit1Enter
    OnExit = Edit1Exit
    OnKeyPress = Edit2KeyPress
  end
  object BitBtn3: TBitBtn
    Left = 150
    Top = 267
    Width = 97
    Height = 21
    Caption = 'Salvar'
    TabOrder = 5
    OnClick = BitBtn3Click
  end
  object Edit3: TEdit
    Left = 152
    Top = 184
    Width = 81
    Height = 22
    ReadOnly = True
    TabOrder = 6
    Text = '1'
  end
  object UpDown1: TUpDown
    Left = 233
    Top = 184
    Width = 16
    Height = 22
    Associate = Edit3
    Min = 1
    Max = 10000
    Position = 1
    TabOrder = 7
    OnChanging = UpDown1Changing
    OnMouseDown = UpDown1MouseDown
    OnMouseUp = UpDown1MouseUp
  end
end
