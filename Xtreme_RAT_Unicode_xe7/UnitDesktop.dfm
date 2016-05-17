object FormDesktop: TFormDesktop
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  ClientHeight = 465
  ClientWidth = 534
  Color = clBtnFace
  DoubleBuffered = True
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
    534
    465)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 224
    Top = 399
    Width = 105
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Intervalo (segundos):'
  end
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 534
    Height = 388
    Anchors = [akLeft, akTop, akRight, akBottom]
    Center = True
    Proportional = True
    OnClick = Image1Click
    OnMouseDown = Image1MouseDown
    OnMouseMove = Image1MouseMove
    OnMouseUp = Image1MouseUp
    ExplicitHeight = 337
  end
  object SpeedButton3: TSpeedButton
    Left = 184
    Top = 397
    Width = 25
    Height = 21
    Anchors = [akLeft, akBottom]
    Flat = True
    OnClick = SpeedButton3Click
  end
  object bsSkinStdLabel1: TLabel
    Left = 91
    Top = 422
    Width = 78
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Qualidade: 50%'
  end
  object Edit2: TEdit
    Left = 530
    Top = 463
    Width = 1
    Height = 21
    Anchors = [akRight, akBottom]
    TabOrder = 0
    Text = 'Edit2'
    OnKeyDown = Edit2KeyDown
  end
  object SpeedButton1: TButton
    Left = 10
    Top = 397
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'SpeedButton1'
    TabOrder = 1
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TButton
    Left = 91
    Top = 397
    Width = 75
    Height = 21
    Anchors = [akLeft, akBottom]
    Caption = 'bsSkinButton1'
    TabOrder = 2
    OnClick = SpeedButton2Click
  end
  object AdvTrackBar1: TsTrackBar
    Left = 10
    Top = 422
    Width = 75
    Height = 12
    Anchors = [akLeft, akBottom]
    Max = 100
    Min = 1
    Position = 50
    ShowSelRange = False
    TabOrder = 3
    ThumbLength = 10
    OnChange = AdvTrackBar1Change
    SkinData.SkinSection = 'TRACKBAR'
    BarOffsetV = 0
    BarOffsetH = 0
  end
  object SRCheckBox1: TCheckBox
    Left = 221
    Top = 416
    Width = 137
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Salvar imagens'
    TabOrder = 4
  end
  object UpDown1: TsUpDown
    Left = 392
    Top = 397
    Width = 16
    Height = 21
    Anchors = [akLeft, akBottom]
    Associate = Edit1
    Max = 10
    TabOrder = 5
  end
  object Edit1: TEdit
    Left = 358
    Top = 397
    Width = 34
    Height = 21
    Anchors = [akLeft, akBottom]
    ReadOnly = True
    TabOrder = 6
    Text = '0'
  end
  object SRCheckBox2: TCheckBox
    Left = 434
    Top = 393
    Width = 87
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Mouse'
    TabOrder = 7
  end
  object SRCheckBox3: TCheckBox
    Left = 435
    Top = 416
    Width = 86
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Teclado'
    TabOrder = 8
    OnClick = SRCheckBox3Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 444
    Width = 534
    Height = 21
    Panels = <
      item
        Width = 50
      end>
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 500
    OnTimer = Timer1Timer
    Left = 24
    Top = 16
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    DrawNonClientArea = False
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 88
    Top = 16
  end
end
