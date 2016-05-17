object FormWebcam: TFormWebcam
  Left = 391
  Top = 144
  Width = 300
  Height = 240
  Caption = 'FormWebcam'
  Color = clBtnFace
  Constraints.MinHeight = 240
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 73
    Height = 172
    Align = alLeft
    TabOrder = 0
    object Label2: TLabel
      Left = 16
      Top = 59
      Width = 41
      Height = 14
      Caption = 'Intervalo'
    end
    object Label3: TLabel
      Left = 16
      Top = 111
      Width = 48
      Height = 14
      Caption = 'Qualidade'
    end
    object Label1: TLabel
      Left = 16
      Top = 180
      Width = 3
      Height = 14
    end
    object Edit1: TEdit
      Left = 16
      Top = 128
      Width = 49
      Height = 22
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      Text = '50'
    end
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 10
      Height = 170
      Align = alLeft
      Orientation = pbVertical
      Position = 50
      Smooth = True
      TabOrder = 1
    end
    object Button2: TButton
      Left = 16
      Top = 3
      Width = 49
      Height = 21
      Caption = 'Start'
      TabOrder = 2
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 16
      Top = 27
      Width = 49
      Height = 21
      Caption = 'Stop'
      TabOrder = 3
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 32
      Top = 77
      Width = 33
      Height = 22
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 4
      Text = '2'
    end
    object UpDown1: TUpDown
      Left = 16
      Top = 77
      Width = 16
      Height = 22
      AlignButton = udLeft
      Associate = Edit2
      Position = 2
      TabOrder = 5
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 172
    Width = 284
    Height = 30
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 1
    DesignSize = (
      280
      26)
    object CheckBox3: TCheckBox
      Left = 201
      Top = 6
      Width = 71
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'Salvar'
      TabOrder = 0
    end
    object TrackBar1: TTrackBar
      Left = 4
      Top = 8
      Width = 183
      Height = 10
      Anchors = [akLeft, akTop, akRight]
      Max = 100
      Min = 1
      Position = 50
      TabOrder = 1
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBar1Change
    end
  end
  object Panel1: TPanel
    Left = 73
    Top = 0
    Width = 211
    Height = 172
    Align = alClient
    TabOrder = 2
    object Image1: TImage32
      Left = 1
      Top = 1
      Width = 209
      Height = 170
      Align = alClient
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smStretch
      TabOrder = 0
    end
  end
end
