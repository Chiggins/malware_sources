object FormMSN: TFormMSN
  Left = 0
  Top = 0
  Caption = 'MSN'
  ClientHeight = 482
  ClientWidth = 427
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 410
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
  DesignSize = (
    427
    482)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 19
    Width = 126
    Height = 13
    Caption = 'O estado atual do MSN '#233': '
  end
  object Label2: TLabel
    Left = 16
    Top = 59
    Width = 126
    Height = 13
    Caption = 'Informa'#231#245'es da conex'#227'o: '
  end
  object Label3: TLabel
    Left = 16
    Top = 215
    Width = 51
    Height = 13
    Caption = 'Contatos: '
  end
  object ComboBoxEx1: TComboBoxEx
    Left = 167
    Top = 16
    Width = 245
    Height = 22
    ItemsEx = <
      item
        Caption = 'Conectado'
        ImageIndex = 83
        SelectedImageIndex = 83
      end
      item
        Caption = 'Ausente'
        ImageIndex = 84
        SelectedImageIndex = 84
      end
      item
        Caption = 'Ocupado'
        ImageIndex = 85
        SelectedImageIndex = 85
      end
      item
        Caption = 'Invis'#237'vel'
        ImageIndex = 86
        SelectedImageIndex = 86
      end
      item
        Caption = 'Desconectado'
        ImageIndex = 87
        SelectedImageIndex = 87
      end>
    Style = csExDropDownList
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    OnSelect = ComboBoxEx1Select
    Images = FormMain.ImageListDiversos
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 463
    Width = 427
    Height = 19
    Panels = <
      item
        Width = 50
      end>
  end
  object bsSkinPanel1: TPanel
    Left = 16
    Top = 78
    Width = 396
    Height = 131
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    object AdvListView1: TListView
      Left = 1
      Top = 1
      Width = 394
      Height = 129
      Align = alClient
      Columns = <
        item
          Caption = 'Nome'
          Width = 150
        end
        item
          Caption = 'Valor'
          Width = 220
        end>
      Items.ItemData = {
        05250000000100000000000000FFFFFFFFFFFFFFFF01000000FFFFFFFF000000
        0001610001610000000000FFFF}
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object bsSkinPanel2: TPanel
    Left = 17
    Top = 234
    Width = 394
    Height = 215
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 3
    object AdvListView2: TListView
      Left = 1
      Top = 1
      Width = 392
      Height = 213
      Align = alClient
      Columns = <
        item
          Caption = 'Email'
          Width = 150
        end
        item
          Caption = 'Nome do contato'
          Width = 150
        end
        item
          Caption = 'Bloqueado'
          Width = 70
        end>
      Items.ItemData = {
        05490000000100000000000000FFFFFFFFFFFFFFFF05000000FFFFFFFF000000
        0001610001610000000000016100000000000161000000000001610000000000
        01610000000000FFFFFFFFFFFFFFFFFFFF}
      LargeImages = FormMain.ImageListDiversos
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      SmallImages = FormMain.ImageListDiversos
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 192
    Top = 304
    object Atualizar1: TMenuItem
      Caption = 'Atualizar'
      OnClick = Atualizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Excluir1: TMenuItem
      Caption = 'Excluir'
      OnClick = Excluir1Click
    end
    object Adicionar1: TMenuItem
      Caption = 'Adicionar'
      OnClick = Adicionar1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Bloquear1: TMenuItem
      Caption = 'Bloquear'
      OnClick = Bloquear1Click
    end
    object Desbloquear1: TMenuItem
      Caption = 'Desbloquear'
      OnClick = Desbloquear1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Salvar1: TMenuItem
      Caption = 'Salvar (*.txt)'
      OnClick = Salvar1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'All files|*.*'
    Title = 'Save file'
    Left = 264
    Top = 304
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
