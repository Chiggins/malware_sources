object FormKeySearch: TFormKeySearch
  Left = 0
  Top = 0
  Caption = 'FormKeySearch'
  ClientHeight = 361
  ClientWidth = 391
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AdvProgressBar1: TAdvProgressBar
    Left = 0
    Top = 343
    Width = 391
    Height = 18
    Align = alBottom
    CompletionSmooth = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    Level0ColorTo = 14811105
    Level1Color = clLime
    Level1ColorTo = 14811105
    Level2Color = clLime
    Level2ColorTo = 14811105
    Level3Color = clLime
    Level3ColorTo = 14811105
    Level1Perc = 70
    Level2Perc = 90
    Position = 50
    ShowBorder = True
    Version = '1.2.0.1'
    ExplicitLeft = -47
    ExplicitTop = 373
    ExplicitWidth = 546
  end
  object bsSkinPanel1: TPanel
    Left = 0
    Top = 0
    Width = 391
    Height = 343
    Align = alClient
    TabOrder = 0
    object AdvListView1: TListView
      Left = 1
      Top = 1
      Width = 389
      Height = 341
      Align = alClient
      Columns = <
        item
          Caption = 'Nome do servidor'
          Width = 200
        end
        item
          Caption = 'Pa'#237's'
          Width = 150
        end>
      Items.ItemData = {
        03210000000100000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000
        00016100016100FFFF}
      LargeImages = FormMain.Flags16
      ReadOnly = True
      RowSelect = True
      SmallImages = FormMain.Flags16
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = AdvListView1DblClick
      OnKeyDown = AdvListView1KeyDown
    end
  end
end
