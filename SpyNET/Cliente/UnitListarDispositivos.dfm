object FormListarDispositivos: TFormListarDispositivos
  Left = 192
  Top = 122
  Width = 673
  Height = 480
  Caption = 'FormListarDispositivos'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 233
    Top = 0
    Height = 423
  end
  object tvDevices: TTreeView
    Left = 0
    Top = 0
    Width = 233
    Height = 423
    Align = alLeft
    Images = ilDevices
    Indent = 19
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 0
    OnChange = tvDevicesChange
    OnCompare = tvDevicesCompare
  end
  object lvAdvancedInfo: TListView
    Left = 236
    Top = 0
    Width = 421
    Height = 423
    Align = alClient
    Columns = <
      item
        Caption = 'Name'
        Width = 150
      end
      item
        Caption = 'Data'
        Width = 300
      end>
    ReadOnly = True
    RowSelect = True
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    OnCompare = lvAdvancedInfoCompare
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 423
    Width = 657
    Height = 19
    Panels = <
      item
        Width = 320
      end
      item
        Width = 170
      end>
  end
  object ilDevices: TImageList
    Left = 8
    Top = 8
  end
end
