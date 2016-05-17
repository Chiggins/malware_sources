object FormServices: TFormServices
  Left = 0
  Top = 0
  ClientHeight = 246
  ClientWidth = 633
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
    Top = 227
    Width = 633
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object AdvListView1: TListView
    Left = 0
    Top = 0
    Width = 633
    Height = 227
    Align = alClient
    Columns = <
      item
        Caption = 'T'#237'tulo'
        Width = 120
      end
      item
        Caption = 'Nome do servi'#231'o'
        Width = 120
      end
      item
        Caption = 'Estado atual'
        Width = 80
      end
      item
        Caption = 'Reinicializa'#231#227'o'
        Width = 90
      end
      item
        Caption = 'Local da instala'#231#227'o'
        Width = 110
      end
      item
        Caption = 'Descri'#231#227'o'
        Width = 80
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
    Left = 32
    Top = 40
    object Atualizar1: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 16
      OnClick = Atualizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Iniciar1: TMenuItem
      Caption = 'Iniciar'
      ImageIndex = 21
      OnClick = Iniciar1Click
    end
    object Parar1: TMenuItem
      Caption = 'Parar'
      ImageIndex = 22
      OnClick = Parar1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Instalar1: TMenuItem
      Caption = 'Instalar'
      ImageIndex = 7
      OnClick = Instalar1Click
    end
    object Desinstalar1: TMenuItem
      Caption = 'Desinstalar'
      ImageIndex = 40
      OnClick = Desinstalar1Click
    end
    object Editar1: TMenuItem
      Caption = 'Editar'
      ImageIndex = 51
      OnClick = Editar1Click
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
    Top = 72
  end
end
