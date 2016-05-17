object FormDesktop: TFormDesktop
  Left = 192
  Top = 122
  Width = 350
  Height = 300
  Caption = 'FormDesktop'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 350
  Font.Charset = ANSI_CHARSET
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
  object Panel1: TPanel
    Left = 0
    Top = 232
    Width = 334
    Height = 30
    Align = alBottom
    BorderStyle = bsSingle
    TabOrder = 0
    DesignSize = (
      330
      26)
    object CheckBox1: TCheckBox
      Left = 91
      Top = 6
      Width = 71
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'Mouse'
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 171
      Top = 6
      Width = 71
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'keyboard'
      TabOrder = 1
    end
    object CheckBox3: TCheckBox
      Left = 251
      Top = 6
      Width = 71
      Height = 17
      Anchors = [akRight, akBottom]
      Caption = 'Salvar'
      TabOrder = 2
    end
    object TrackBar1: TTrackBar
      Left = 4
      Top = 8
      Width = 82
      Height = 10
      Anchors = [akLeft, akTop, akRight]
      Max = 100
      Min = 1
      Position = 50
      TabOrder = 3
      ThumbLength = 10
      TickStyle = tsNone
      OnChange = TrackBar1Change
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 73
    Height = 232
    Align = alLeft
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 83
      Width = 41
      Height = 14
      Caption = 'Intervalo'
    end
    object Label3: TLabel
      Left = 16
      Top = 135
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
      Top = 152
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
      Height = 230
      Align = alLeft
      Orientation = pbVertical
      Position = 50
      Smooth = True
      TabOrder = 1
    end
    object Button1: TButton
      Left = 16
      Top = 3
      Width = 49
      Height = 21
      Caption = 'Preview'
      TabOrder = 2
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 16
      Top = 27
      Width = 49
      Height = 21
      Caption = 'Start'
      TabOrder = 3
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 16
      Top = 51
      Width = 49
      Height = 21
      Caption = 'Stop'
      TabOrder = 4
      OnClick = Button3Click
    end
    object Edit2: TEdit
      Left = 32
      Top = 101
      Width = 33
      Height = 22
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 5
      Text = '2'
    end
    object UpDown1: TUpDown
      Left = 16
      Top = 101
      Width = 17
      Height = 22
      AlignButton = udLeft
      Associate = Edit2
      Position = 2
      TabOrder = 6
    end
  end
  object Panel3: TPanel
    Left = 73
    Top = 0
    Width = 261
    Height = 232
    Align = alClient
    TabOrder = 2
    object Image1: TImage32
      Left = 1
      Top = 1
      Width = 259
      Height = 230
      Align = alClient
      Bitmap.ResamplerClassName = 'TNearestResampler'
      BitmapAlign = baTopLeft
      Scale = 1.000000000000000000
      ScaleMode = smNormal
      TabOrder = 0
      OnKeyDown = Image1KeyDown
      OnMouseDown = Image1MouseDown
      OnMouseUp = Image1MouseUp
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 298
    Top = 9
  end
end
