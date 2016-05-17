object FormActivePorts: TFormActivePorts
  Left = 0
  Top = 0
  ClientHeight = 278
  ClientWidth = 657
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
    Top = 259
    Width = 657
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object AdvListView1: TListView
    Left = 0
    Top = 0
    Width = 657
    Height = 259
    Align = alClient
    Columns = <
      item
        Caption = 'Protocolo'
        Width = 60
      end
      item
        Caption = 'Local IP'
        Width = 80
      end
      item
        Caption = 'Local Port'
        Width = 80
      end
      item
        Caption = 'Remote IP'
        Width = 80
      end
      item
        Caption = 'Remot Port'
        Width = 80
      end
      item
        Caption = 'Status'
        Width = 100
      end
      item
        Caption = 'PID'
      end
      item
        Caption = 'Process'
        Width = 100
      end>
    LargeImages = FormMain.ImageListDiversos
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    SmallImages = FormMain.ImageListDiversos
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = AdvListView1ColumnClick
    OnCustomDrawItem = AdvListView1CustomDrawItem
  end
  object PopupMenu1: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu1Popup
    Left = 24
    Top = 40
    object Atualizar1: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 16
      OnClick = Atualizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object DNSResolve1: TMenuItem
      Caption = 'DNS Resolve'
      OnClick = DNSResolve1Click
    end
    object Finalizarconexo1: TMenuItem
      Caption = 'Finalizar conex'#227'o'
      ImageIndex = 62
      OnClick = Finalizarconexo1Click
    end
    object Finalizarprocesso1: TMenuItem
      Caption = 'Finalizar processo'
      ImageIndex = 40
      OnClick = Finalizarprocesso1Click
    end
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
    Top = 120
  end
end
