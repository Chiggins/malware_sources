object FormChat: TFormChat
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  ClientHeight = 381
  ClientWidth = 463
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    463
    381)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 278
    Width = 128
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Digite sua mensagem aqui:'
  end
  object Label2: TsLabel
    Left = 0
    Top = 327
    Width = 463
    Height = 11
    Anchors = [akLeft, akRight, akBottom]
    AutoSize = False
    Color = 2853987
    ParentColor = False
    Transparent = False
  end
  object Label3: TLabel
    Left = 8
    Top = 7
    Width = 104
    Height = 13
    Caption = 'Hist'#243'ria do Bate-Papo'
  end
  object bsSkinPanel1: TPanel
    Left = 8
    Top = 26
    Width = 447
    Height = 246
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 445
      Height = 244
      Align = alClient
      Lines.Strings = (
        'Memo1')
      ReadOnly = True
      TabOrder = 0
    end
  end
  object Button1: TButton
    Left = 296
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Enviar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 380
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Fechar'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 8
    Top = 348
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Salvar'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Edit1: TEdit
    Left = 8
    Top = 296
    Width = 447
    Height = 21
    Anchors = [akLeft, akRight, akBottom]
    TabOrder = 4
    Text = 'Edit1'
    OnKeyPress = Edit1KeyPress
  end
  object SaveDialog1: TSaveDialog
    Filter = 'All files|*.*'
    Title = 'Save file'
    Left = 184
    Top = 40
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 32
    Top = 56
  end
end
