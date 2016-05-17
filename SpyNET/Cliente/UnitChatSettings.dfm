object FormChatSettings: TFormChatSettings
  Left = 196
  Top = 153
  BorderStyle = bsDialog
  Caption = 'FormChatSettings'
  ClientHeight = 237
  ClientWidth = 402
  Color = clBtnFace
  Constraints.MaxHeight = 273
  Constraints.MaxWidth = 418
  Constraints.MinHeight = 273
  Constraints.MinWidth = 418
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 241
    Height = 237
    Align = alLeft
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 70
      Height = 14
      Caption = 'Spy-Net CHAT'
    end
    object Memo1: TMemo
      Left = 8
      Top = 24
      Width = 225
      Height = 185
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'XXXXX')
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 8
      Top = 211
      Width = 169
      Height = 22
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'YYYYY'
    end
    object Button1: TButton
      Left = 176
      Top = 212
      Width = 58
      Height = 21
      Caption = 'Button1'
      TabOrder = 2
    end
  end
  object Panel2: TPanel
    Left = 241
    Top = 0
    Width = 161
    Height = 237
    Align = alClient
    TabOrder = 1
    object Label2: TLabel
      Left = 7
      Top = 9
      Width = 32
      Height = 14
      Caption = 'Label2'
    end
    object Label3: TLabel
      Left = 7
      Top = 136
      Width = 35
      Height = 14
      Cursor = crHandPoint
      Caption = 'XXXXX'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label3Click
    end
    object Label4: TLabel
      Left = 7
      Top = 160
      Width = 40
      Height = 14
      Cursor = crHandPoint
      Caption = 'YYYYY'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = [fsUnderline]
      ParentFont = False
      OnClick = Label4Click
    end
    object Label5: TLabel
      Left = 7
      Top = 49
      Width = 66
      Height = 14
      Caption = 'Server Name:'
    end
    object Label6: TLabel
      Left = 7
      Top = 89
      Width = 59
      Height = 14
      Caption = 'Client Name:'
    end
    object Edit2: TEdit
      Left = 7
      Top = 24
      Width = 145
      Height = 22
      MaxLength = 50
      TabOrder = 0
      Text = 'Spy-Net CHAT'
      OnChange = Edit2Change
      OnEnter = Edit2Enter
      OnExit = Edit2Exit
    end
    object Button2: TButton
      Left = 80
      Top = 211
      Width = 75
      Height = 21
      Caption = 'OK'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Edit3: TEdit
      Left = 7
      Top = 64
      Width = 145
      Height = 22
      MaxLength = 50
      TabOrder = 2
      Text = 'Server'
      OnEnter = Edit2Enter
      OnExit = Edit2Exit
    end
    object Edit4: TEdit
      Left = 7
      Top = 104
      Width = 145
      Height = 22
      MaxLength = 50
      TabOrder = 3
      Text = 'Client'
      OnEnter = Edit2Enter
      OnExit = Edit2Exit
    end
    object ColorBtn1: TColorBtn
      Left = 8
      Top = 184
      Width = 22
      Height = 22
      Cursor = crHandPoint
      TabOrder = 4
      OnClick = ColorBtn1Click
      ButtonColor = clBlack
    end
    object ColorBtn2: TColorBtn
      Left = 8
      Top = 210
      Width = 22
      Height = 22
      Cursor = crHandPoint
      TabOrder = 5
      OnClick = ColorBtn2Click
      ButtonColor = clBlack
    end
  end
  object ColorDialog1: TColorDialog
    Left = 88
    Top = 88
  end
end
