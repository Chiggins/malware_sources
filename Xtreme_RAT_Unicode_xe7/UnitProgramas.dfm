object FormProgramas: TFormProgramas
  Left = 0
  Top = 0
  ClientHeight = 243
  ClientWidth = 565
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
    Top = 224
    Width = 565
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object AdvListView1: TListView
    Left = 0
    Top = 0
    Width = 565
    Height = 224
    Align = alClient
    Columns = <
      item
        Caption = 'Nome do programa'
        Width = 110
      end
      item
        Caption = 'Vers'#227'o'
        Width = 70
      end
      item
        Caption = 'Empresa'
        Width = 100
      end
      item
        Caption = 'Desinstalar'
        Width = 100
      end
      item
        Caption = 'Desinstalar modo silencioso'
        Width = 150
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
    object Desinstalar1: TMenuItem
      Caption = 'Desinstalar'
      ImageIndex = 40
      OnClick = Desinstalar1Click
    end
    object Desinstalarmodosilencioso1: TMenuItem
      Caption = 'Desinstalar modo silencioso'
      ImageIndex = 36
      OnClick = Desinstalarmodosilencioso1Click
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
