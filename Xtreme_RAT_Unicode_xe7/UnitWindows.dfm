object FormWindows: TFormWindows
  Left = 0
  Top = 0
  ClientHeight = 241
  ClientWidth = 562
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
    Top = 222
    Width = 562
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object AdvListView1: TListView
    Left = 0
    Top = 0
    Width = 562
    Height = 222
    Align = alClient
    Columns = <
      item
        Caption = 'Handle'
      end
      item
        Caption = 'T'#237'tulo da janela'
        Width = 200
      end
      item
        Caption = 'Classe'
        Width = 80
      end
      item
        Caption = 'Atributo'
        Width = 80
      end
      item
        Caption = 'Processo'
        Width = 80
      end
      item
        Caption = 'PID'
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
    Left = 104
    Top = 32
    object Atualizar1: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 16
      OnClick = Atualizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Incluirjanelasocultas1: TMenuItem
      Caption = 'Incluir janelas ocultas'
      OnClick = Incluirjanelasocultas1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Fechar1: TMenuItem
      Caption = 'Fechar'
      ImageIndex = 31
      OnClick = Fechar1Click
    end
    object Desabilitar1: TMenuItem
      Caption = 'Desabilitar'
      ImageIndex = 66
      OnClick = Desabilitar1Click
    end
    object Habilitar1: TMenuItem
      Caption = 'Habilitar'
      ImageIndex = 65
      OnClick = Habilitar1Click
    end
    object Ocultar1: TMenuItem
      Caption = 'Ocultar'
      ImageIndex = 34
      OnClick = Ocultar1Click
    end
    object Mostrar1: TMenuItem
      Caption = 'Mostrar'
      ImageIndex = 27
      OnClick = Mostrar1Click
    end
    object Minimizar1: TMenuItem
      Caption = 'Minimizar'
      ImageIndex = 33
      OnClick = Minimizar1Click
    end
    object Maximizar1: TMenuItem
      Caption = 'Maximizar'
      ImageIndex = 32
      OnClick = Maximizar1Click
    end
    object Restaurar1: TMenuItem
      Caption = 'Restaurar'
      ImageIndex = 28
      OnClick = Restaurar1Click
    end
    object remerjanela1: TMenuItem
      Caption = 'Tremer janela'
      ImageIndex = 41
      OnClick = remerjanela1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Mudarttulodajanela1: TMenuItem
      Caption = 'Mudar t'#237'tulo da janela'
      ImageIndex = 51
      OnClick = Mudarttulodajanela1Click
    end
    object Enviarteclas1: TMenuItem
      Caption = 'Enviar teclas'
      ImageIndex = 59
      OnClick = Enviarteclas1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Obterimagem1: TMenuItem
      Caption = 'Obter imagem'
      ImageIndex = 57
      OnClick = Obterimagem1Click
    end
    object N5: TMenuItem
      Caption = '-'
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
    Left = 40
    Top = 72
  end
end
