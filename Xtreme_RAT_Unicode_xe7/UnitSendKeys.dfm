object FormSendKeys: TFormSendKeys
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enviar teclas'
  ClientHeight = 74
  ClientWidth = 419
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
    Top = 12
    Width = 65
    Height = 13
    Caption = 'Enviar teclas:'
  end
  object Edit1: TEdit
    Left = 16
    Top = 27
    Width = 289
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object Button1: TButton
    Left = 305
    Top = 26
    Width = 72
    Height = 31
    Caption = 'Enviar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 376
    Top = 26
    Width = 28
    Height = 31
    Caption = '?'
    TabOrder = 2
    OnClick = Button2Click
  end
end
