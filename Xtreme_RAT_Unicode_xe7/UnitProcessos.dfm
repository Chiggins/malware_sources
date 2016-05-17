object FormProcessos: TFormProcessos
  Left = 0
  Top = 0
  ClientHeight = 332
  ClientWidth = 427
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
    Top = 313
    Width = 427
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object AdvListView1: TListView
    Left = 0
    Top = 0
    Width = 427
    Height = 313
    Align = alClient
    Columns = <
      item
        Caption = 'Nome'
        Width = 120
      end
      item
        Caption = 'PID'
      end
      item
        Caption = 'Localiza'#231#227'o'
        Width = 100
      end
      item
        Caption = 'Usu'#225'rio'
        Width = 60
      end
      item
        Caption = 'Threads'
        Width = 60
      end
      item
        Caption = 'Mem'#243'ria'
        Width = 60
      end
      item
        Caption = 'Data de cria'#231#227'o'
        Width = 100
      end
      item
        Caption = 'CPU (%)'
        Width = 60
      end>
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = AdvListView1ColumnClick
    OnCustomDrawItem = AdvListView1CustomDrawItem
    OnKeyDown = AdvListView1KeyDown
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
    object Finalizar1: TMenuItem
      Caption = 'Finalizar'
      ImageIndex = 40
      OnClick = Finalizar1Click
    end
    object Pausar1: TMenuItem
      Caption = 'Pausar'
      ImageIndex = 22
      OnClick = Pausar1Click
    end
    object Continuar1: TMenuItem
      Caption = 'Continuar'
      ImageIndex = 21
      OnClick = Continuar1Click
    end
    object CPU1: TMenuItem
      Caption = 'CPU (%)'
      ImageIndex = 69
      OnClick = CPU1Click
    end
    object Abrirlocaldoarquivo1: TMenuItem
      Caption = 'Abrir local do arquivo'
      ImageIndex = 61
      OnClick = Abrirlocaldoarquivo1Click
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
    Left = 40
    Top = 128
  end
end
