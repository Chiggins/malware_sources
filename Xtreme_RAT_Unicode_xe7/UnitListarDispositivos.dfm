object FormListarDispositivos: TFormListarDispositivos
  Left = 0
  Top = 0
  ClientHeight = 370
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
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 177
    Top = 0
    Height = 351
    ExplicitLeft = 208
    ExplicitTop = 216
    ExplicitHeight = 100
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 351
    Width = 515
    Height = 19
    Panels = <
      item
        Width = 220
      end
      item
        Width = 50
      end>
  end
  object tvDevices: TTreeView
    Left = 0
    Top = 0
    Width = 177
    Height = 351
    Align = alLeft
    DoubleBuffered = True
    Images = ilDevices
    Indent = 19
    ParentDoubleBuffered = False
    TabOrder = 1
    OnChange = tvDevicesChange
    OnCompare = tvDevicesCompare
  end
  object lvAdvancedInfo: TListView
    Left = 180
    Top = 0
    Width = 335
    Height = 351
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 120
      end
      item
        Caption = 'Data'
        Width = 180
      end>
    LargeImages = ilDevices
    ReadOnly = True
    RowSelect = True
    SmallImages = ilDevices
    TabOrder = 2
    ViewStyle = vsReport
    OnCompare = lvAdvancedInfoCompare
  end
  object ilDevices: TImageList
    ColorDepth = cd32Bit
    BkColor = clWhite
    DrawingStyle = dsTransparent
    Left = 32
    Top = 16
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 24
    Top = 72
  end
end
