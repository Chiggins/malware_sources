object FormWebcam: TFormWebcam
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'FormWebcam'
  ClientHeight = 414
  ClientWidth = 515
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
    515
    414)
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 68
    Top = 1
    Width = 446
    Height = 366
    Anchors = [akLeft, akTop, akRight, akBottom]
    Stretch = True
  end
  object Label1: TLabel
    Left = 12
    Top = 325
    Width = 44
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = 'Intervalo'
  end
  object bsSkinStdLabel1: TLabel
    Left = 24
    Top = 308
    Width = 17
    Height = 13
    Anchors = [akLeft, akBottom]
    Caption = '0%'
  end
  object bsSkinStdLabel2: TLabel
    Left = 19
    Top = 73
    Width = 29
    Height = 13
    Caption = '100%'
  end
  object SpeedButton1: TButton
    Left = 10
    Top = 13
    Width = 47
    Height = 22
    Caption = 'Start'
    TabOrder = 1
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TButton
    Left = 10
    Top = 39
    Width = 47
    Height = 22
    Caption = 'Stop'
    TabOrder = 3
    OnClick = SpeedButton2Click
  end
  object ComboBox1: TComboBox
    Left = 68
    Top = 367
    Width = 446
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akRight, akBottom]
    DoubleBuffered = True
    ParentDoubleBuffered = False
    TabOrder = 0
  end
  object AdvTrackBar1: TsTrackBar
    Left = 22
    Top = 88
    Width = 18
    Height = 219
    Anchors = [akLeft, akTop, akBottom]
    Max = 100
    Min = 1
    Orientation = trVertical
    Position = 50
    TabOrder = 4
    ThumbLength = 15
    SkinData.SkinSection = 'TRACKBAR'
    BarOffsetV = 0
    BarOffsetH = 0
  end
  object CheckBox1: TCheckBox
    Left = 9
    Top = 372
    Width = 54
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Salvar'
    TabOrder = 2
  end
  object Edit1: TEdit
    Left = 12
    Top = 341
    Width = 34
    Height = 21
    Anchors = [akLeft, akBottom]
    ReadOnly = True
    TabOrder = 5
    Text = '0'
  end
  object UpDown1: TsUpDown
    Left = 46
    Top = 341
    Width = 16
    Height = 21
    Anchors = [akLeft, akBottom]
    Associate = Edit1
    Max = 10
    TabOrder = 6
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 393
    Width = 515
    Height = 21
    Panels = <
      item
        Width = 50
      end>
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
    Left = 80
    Top = 8
  end
end
