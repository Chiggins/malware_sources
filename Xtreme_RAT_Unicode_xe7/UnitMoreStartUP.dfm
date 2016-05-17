object FormMoreStartUP: TFormMoreStartUP
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 159
  ClientWidth = 352
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    352
    159)
  PixelsPerInch = 96
  TextHeight = 13
  object Label5: TLabel
    Left = 10
    Top = 11
    Width = 34
    Height = 13
    Caption = 'Nome: '
  end
  object Edit3: TEdit
    Left = 94
    Top = 8
    Width = 243
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    MaxLength = 10
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    Text = 'Edit3'
  end
  object CheckBox10: TCheckBox
    Left = 34
    Top = 35
    Width = 103
    Height = 17
    Caption = 'RunOnce'
    TabOrder = 1
  end
  object CheckBox1: TCheckBox
    Left = 34
    Top = 97
    Width = 103
    Height = 17
    Caption = 'WinLoad'
    TabOrder = 2
  end
  object CheckBox2: TCheckBox
    Left = 34
    Top = 66
    Width = 103
    Height = 17
    Caption = 'WinShell'
    Enabled = False
    TabOrder = 3
    Visible = False
  end
  object CheckBox3: TCheckBox
    Left = 34
    Top = 128
    Width = 103
    Height = 17
    Caption = 'Policies'
    TabOrder = 4
  end
  object BitBtn1: TBitBtn
    Left = 182
    Top = 126
    Width = 59
    Height = 23
    Caption = 'OK'
    TabOrder = 5
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 246
    Top = 126
    Width = 91
    Height = 23
    Caption = 'Cancelar'
    TabOrder = 6
    OnClick = BitBtn2Click
  end
end
