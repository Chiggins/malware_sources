object FormSearchFiles: TFormSearchFiles
  Left = 484
  Top = 146
  Width = 400
  Height = 200
  Caption = 'Search file'
  Color = clBtnFace
  Constraints.MinHeight = 200
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object ListView1: TListView
    Left = 0
    Top = 0
    Width = 384
    Height = 164
    Align = alClient
    Columns = <
      item
        Caption = 'Servers'
        MinWidth = 150
        Width = 150
      end
      item
        Caption = 'Files'
        Width = 200
      end>
    LargeImages = FormPrincipal.ImageListIcons
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    SmallImages = FormPrincipal.ImageListIcons
    TabOrder = 0
    ViewStyle = vsReport
  end
  object PopupMenu1: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenu1Popup
    Left = 80
    Top = 64
    object Serachfile: TMenuItem
      Caption = 'Search file'
      ImageIndex = 302
      OnClick = SerachfileClick
    end
  end
end
