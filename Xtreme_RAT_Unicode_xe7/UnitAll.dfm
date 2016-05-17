object FormAll: TFormAll
  Left = 0
  Top = 0
  ClientHeight = 450
  ClientWidth = 714
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sSplitter1: TsSplitter
    Left = 209
    Top = 0
    Width = 3
    Height = 450
    SkinData.SkinSection = 'SPLITTER'
    ExplicitLeft = 177
    ExplicitHeight = 391
  end
  object sFrameBar1: TsFrameBar
    Left = 0
    Top = 0
    Width = 209
    Height = 450
    HorzScrollBar.Range = 177
    HorzScrollBar.Visible = False
    VertScrollBar.Range = 98
    VertScrollBar.Tracking = True
    AutoScroll = False
    Constraints.MinWidth = 150
    TabOrder = 0
    SkinData.SkinSection = 'BAR'
    AllowAllClose = True
    AutoFrameSize = False
    Images = FormMain.ImageListDiversos
    Items = <
      item
        Caption = 'Functions'
        Cursor = crDefault
        ImageIndex = 69
        SkinSection = 'BARTITLE'
        OnCreateFrame = sFrameBar1Items0CreateFrame
      end
      item
        Caption = 'Op'#231#245'es do servidor'
        Cursor = crDefault
        ImageIndex = 24
        SkinSection = 'BARTITLE'
        OnCreateFrame = sFrameBar1Items1CreateFrame
      end
      item
        Caption = 'Extras'
        Cursor = crDefault
        ImageIndex = 47
        SkinSection = 'BARTITLE'
        OnCreateFrame = sFrameBar1Items2CreateFrame
      end>
    Spacing = 0
  end
  object MainPanel: TsPanel
    Left = 212
    Top = 0
    Width = 502
    Height = 450
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    SkinData.SkinSection = 'PANEL'
  end
end
