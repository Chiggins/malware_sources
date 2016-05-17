object FormServerSettings: TFormServerSettings
  Left = 0
  Top = 0
  ClientHeight = 316
  ClientWidth = 610
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
  object StatusBar1: TStatusBar
    Left = 0
    Top = 297
    Width = 610
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object bsSkinPanel1: TPanel
    Left = 0
    Top = 0
    Width = 610
    Height = 297
    Align = alClient
    TabOrder = 1
    object AdvListView1: TListView
      Left = 1
      Top = 1
      Width = 608
      Height = 295
      Align = alClient
      Columns = <
        item
          Caption = 'Op'#231#245'es'
          Width = 180
        end
        item
          Caption = 'Valores'
          Width = 400
        end>
      Items.ItemData = {
        03210000000100000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000
        00016100016100FFFF}
      LargeImages = FormMain.ImageListDiversos
      ReadOnly = True
      RowSelect = True
      SmallImages = FormMain.ImageListDiversos
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
end
