object FormAudio: TFormAudio
  Left = 508
  Top = 120
  BorderStyle = bsDialog
  Caption = 'FormAudio'
  ClientHeight = 129
  ClientWidth = 202
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 202
    Height = 129
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 113
      Top = 69
      Width = 3
      Height = 14
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -11
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object RadioGroup1: TRadioGroup
      Left = 8
      Top = 8
      Width = 97
      Height = 105
      Caption = 'Sample Rate: '
      ItemIndex = 0
      Items.Strings = (
        '48000'
        '44100'
        '22100'
        '11050'
        '8000')
      TabOrder = 0
    end
    object RadioGroup2: TRadioGroup
      Left = 112
      Top = 8
      Width = 81
      Height = 57
      Caption = 'Channels: '
      ItemIndex = 0
      Items.Strings = (
        'Stereo'
        'Mono')
      TabOrder = 1
    end
    object BitBtn1: TBitBtn
      Left = 112
      Top = 88
      Width = 33
      Height = 25
      TabOrder = 2
      OnClick = BitBtn1Click
    end
    object BitBtn2: TBitBtn
      Left = 158
      Top = 88
      Width = 35
      Height = 25
      Enabled = False
      TabOrder = 3
      OnClick = BitBtn2Click
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 119
      Width = 200
      Height = 9
      Align = alBottom
      Smooth = True
      TabOrder = 4
    end
  end
end
