object FormChatSettings: TFormChatSettings
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'CHAT'
  ClientHeight = 168
  ClientWidth = 301
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
    301
    168)
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TsLabel
    Left = 0
    Top = 110
    Width = 301
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Color = 887415
    ParentColor = False
    Transparent = False
  end
  object Label4: TLabel
    Left = 16
    Top = 80
    Width = 77
    Height = 13
    Caption = 'T'#237'tulo da janela:'
  end
  object Label3: TLabel
    Left = 16
    Top = 50
    Width = 83
    Height = 13
    Caption = 'Nome do cliente: '
  end
  object Label1: TLabel
    Left = 16
    Top = 18
    Width = 91
    Height = 13
    Caption = 'Nome do servidor: '
  end
  object Button2: TButton
    Left = 215
    Top = 132
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Edit3: TEdit
    Left = 137
    Top = 77
    Width = 153
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'Edit3'
    OnKeyPress = Edit3KeyPress
  end
  object Edit2: TEdit
    Left = 137
    Top = 47
    Width = 153
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    Text = 'Edit2'
    OnKeyPress = Edit2KeyPress
  end
  object Edit1: TEdit
    Left = 137
    Top = 15
    Width = 153
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 8
    Top = 132
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 4
    OnClick = Button1Click
  end
end
