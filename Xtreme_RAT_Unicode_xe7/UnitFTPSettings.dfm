object FormFTPSettings: TFormFTPSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'FTP'
  ClientHeight = 194
  ClientWidth = 355
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
  DesignSize = (
    355
    194)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TsLabel
    Left = 0
    Top = 139
    Width = 355
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Color = 887415
    ParentColor = False
    Transparent = False
    ExplicitTop = 150
  end
  object Label1: TLabel
    Left = 16
    Top = 18
    Width = 73
    Height = 13
    Caption = 'Endere'#231'o FTP: '
  end
  object Label3: TLabel
    Left = 16
    Top = 50
    Width = 48
    Height = 13
    Caption = 'Diret'#243'rio: '
  end
  object Label4: TLabel
    Left = 16
    Top = 80
    Width = 40
    Height = 13
    Caption = 'Usu'#225'rio:'
  end
  object Label5: TLabel
    Left = 16
    Top = 112
    Width = 34
    Height = 13
    Caption = 'Senha:'
  end
  object Button2: TButton
    Left = 265
    Top = 161
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 16
    Top = 161
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit4: TEdit
    Left = 137
    Top = 109
    Width = 203
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'Edit4'
    OnKeyPress = Edit3KeyPress
  end
  object Edit3: TEdit
    Left = 137
    Top = 77
    Width = 203
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'Edit3'
  end
  object Edit2: TEdit
    Left = 137
    Top = 47
    Width = 203
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 4
    Text = 'Edit2'
    OnKeyPress = Edit2KeyPress
  end
  object Edit1: TEdit
    Left = 137
    Top = 15
    Width = 203
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
end
