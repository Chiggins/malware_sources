object FormExecParam: TFormExecParam
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 158
  ClientWidth = 279
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  DesignSize = (
    279
    158)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 15
    Top = 72
    Width = 57
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Par'#226'metro: '
    ExplicitTop = 91
  end
  object Label2: TsLabel
    Left = 0
    Top = 104
    Width = 277
    Height = 13
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Color = 887415
    ParentColor = False
    Transparent = False
    ExplicitTop = 123
  end
  object Button2: TButton
    Left = 196
    Top = 126
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Cancelar'
    TabOrder = 0
    OnClick = Button2Click
  end
  object Button1: TButton
    Left = 8
    Top = 126
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'OK'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 111
    Top = 69
    Width = 159
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 2
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object bsSkinRadioGroup1: TRadioGroup
    Left = 8
    Top = 8
    Width = 263
    Height = 44
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = 'Executar'
    Columns = 2
    ItemIndex = 0
    Items.Strings = (
      'Normal'
      'Oculto')
    TabOrder = 3
  end
end
