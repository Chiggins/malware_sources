object FormReg: TFormReg
  Left = 463
  Top = 56
  Width = 330
  Height = 200
  Caption = 'Adicionando valor e tipo'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 330
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    314
    164)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelNombre: TLabel
    Left = 8
    Top = 8
    Width = 59
    Height = 13
    Caption = 'Value name:'
  end
  object LabelInformacion: TLabel
    Left = 8
    Top = 56
    Width = 69
    Height = 13
    Caption = 'Value settings:'
  end
  object BtnAceptar: TSpeedButton
    Left = 139
    Top = 139
    Width = 81
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'OK'
    Flat = True
    OnClick = BtnAceptarClick
  end
  object BtnCancelar: TSpeedButton
    Left = 227
    Top = 139
    Width = 81
    Height = 22
    Anchors = [akRight, akBottom]
    Caption = 'Cancel'
    Flat = True
    OnClick = BtnCancelarClick
  end
  object EditNombreValor: TEdit
    Left = 8
    Top = 24
    Width = 299
    Height = 19
    Anchors = [akLeft, akTop, akRight]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object MemoInformacionValor: TMemo
    Left = 7
    Top = 72
    Width = 300
    Height = 60
    Anchors = [akLeft, akTop, akRight, akBottom]
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    WordWrap = False
    OnKeyPress = MemoInformacionValorKeyPress
  end
end
