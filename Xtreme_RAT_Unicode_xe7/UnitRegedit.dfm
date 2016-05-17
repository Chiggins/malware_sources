object FormRegedit: TFormRegedit
  Left = 338
  Top = 124
  Caption = 'FormRegedit'
  ClientHeight = 323
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
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
    Top = 304
    Width = 674
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 674
    Height = 304
    ActivePage = TabSheet2
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = 'Gerenciador de registros'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Splitter1: TSplitter
        Left = 225
        Top = 0
        Height = 276
        ExplicitHeight = 282
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 225
        Height = 276
        Align = alLeft
        TabOrder = 0
        object TreeView1: TTreeView
          Left = 1
          Top = 1
          Width = 223
          Height = 274
          Align = alClient
          Images = FormMain.ImageListDiversos
          Indent = 19
          PopupMenu = PopupMenu1
          ReadOnly = True
          TabOrder = 0
          OnDblClick = TreeView1DblClick
          OnGetSelectedIndex = TreeView1GetSelectedIndex
          Items.NodeData = {
            03010000003A0000002600000026000000FFFFFFFFFFFFFFFF00000000000000
            0005000000010E4D0065007500200063006F006D00700075007400610064006F
            007200400000000100000000000000FFFFFFFFFFFFFFFF000000000000000000
            000000011148004B00450059005F0043004C00410053005300450053005F0052
            004F004F005400400000000100000000000000FFFFFFFFFFFFFFFF0000000000
            00000000000000011148004B00450059005F00430055005200520045004E0054
            005F005500530045005200420000000100000000000000FFFFFFFFFFFFFFFF00
            0000000000000000000000011248004B00450059005F004C004F00430041004C
            005F004D0041004300480049004E004500320000000100000000000000FFFFFF
            FFFFFFFFFF000000000000000000000000010A48004B00450059005F00550053
            00450052005300440000000100000000000000FFFFFFFFFFFFFFFF0000000000
            00000000000000011348004B00450059005F00430055005200520045004E0054
            005F0043004F004E00460049004700}
        end
      end
      object Panel2: TPanel
        Left = 228
        Top = 0
        Width = 438
        Height = 276
        Align = alClient
        TabOrder = 1
        object AdvListView1: TListView
          Left = 1
          Top = 1
          Width = 436
          Height = 274
          Align = alClient
          Columns = <
            item
              Caption = 'Nome'
              Width = 100
            end
            item
              Caption = 'Tipo'
              Width = 100
            end
            item
              Caption = 'Dados'
              Width = 200
            end>
          LargeImages = FormMain.ImageListDiversos
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu1
          SmallImages = FormMain.ImageListDiversos
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Gerenciador de reinicializa'#231#227'o'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 666
        Height = 276
        Align = alClient
        TabOrder = 0
        object AdvListView2: TListView
          Left = 1
          Top = 1
          Width = 664
          Height = 274
          Align = alClient
          Columns = <
            item
              Caption = 'Items carregados na reinicializa'#231#227'o'
              Width = 200
            end
            item
              Caption = 'Comando'
              Width = 200
            end
            item
              Caption = 'Local'
              Width = 200
            end>
          LargeImages = FormMain.ImageListDiversos
          ReadOnly = True
          RowSelect = True
          PopupMenu = PopupMenu2
          SmallImages = FormMain.ImageListDiversos
          TabOrder = 0
          ViewStyle = vsReport
        end
      end
    end
  end
  object PopupMenu1: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu1Popup
    Left = 136
    Top = 152
    object Novo1: TMenuItem
      Caption = 'Novo'
      object Chave1: TMenuItem
        Caption = 'Chave'
        OnClick = Chave1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Valordasequncia1: TMenuItem
        Caption = 'Valor da sequ'#234'ncia'
        OnClick = Valordasequncia1Click
      end
      object Valorbinrio1: TMenuItem
        Caption = 'Valor bin'#225'rio'
        OnClick = Valordasequncia1Click
      end
      object ValorDWORD1: TMenuItem
        Caption = 'Valor DWORD'
        OnClick = Valordasequncia1Click
      end
      object Valordesequnciamltipla1: TMenuItem
        Caption = 'Valor de sequ'#234'ncia m'#250'ltipla'
        OnClick = Valordasequncia1Click
      end
      object Valordesequnciaespansvel1: TMenuItem
        Caption = 'Valor de sequ'#234'ncia expans'#237'vel'
        OnClick = Valordasequncia1Click
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Editar1: TMenuItem
      Caption = 'Editar'
      OnClick = Editar1Click
    end
    object Excluir1: TMenuItem
      Caption = 'Excluir'
      OnClick = Excluir1Click
    end
    object Renomear1: TMenuItem
      Caption = 'Renomear'
      OnClick = Renomear1Click
    end
  end
  object PopupMenu2: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu2Popup
    Left = 288
    Top = 152
    object Listarregistros1: TMenuItem
      Caption = 'Listar registros'
      ImageIndex = 78
      OnClick = Listarregistros1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Novo2: TMenuItem
      Caption = 'Novo'
      ImageIndex = 7
      OnClick = Novo2Click
    end
    object Excluir2: TMenuItem
      Caption = 'Excluir'
      ImageIndex = 40
      OnClick = Excluir2Click
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
