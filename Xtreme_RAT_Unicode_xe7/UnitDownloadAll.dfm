object FormDownloadAll: TFormDownloadAll
  Left = 0
  Top = 0
  ClientHeight = 403
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 475
    Height = 57
    Align = alTop
    TabOrder = 0
    DesignSize = (
      475
      57)
    object Label1: TLabel
      Left = 144
      Top = 6
      Width = 54
      Height = 13
      Caption = 'Extens'#245'es:'
    end
    object RadioGroup1: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 125
      Height = 49
      Align = alLeft
      Caption = 'Filtro: '
      ItemIndex = 1
      Items.Strings = (
        'N'#227'o baixar'
        'Baixar somente')
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 144
      Top = 25
      Width = 289
      Height = 24
      Anchors = [akLeft, akTop, akRight]
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = '*.doc;*.docx;*.xls;*.xlsx;*.txt;*.rft;'
    end
    object Button1: TButton
      Left = 432
      Top = 25
      Width = 36
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'OK'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object ListView2: TListView
    Left = 0
    Top = 57
    Width = 475
    Height = 327
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Nome'
        Width = 100
      end
      item
        Caption = 'Tamanho'
        Width = 70
      end
      item
        Caption = 'Atributo'
        Width = 70
      end
      item
        Caption = 'Tipo'
        Width = 70
      end
      item
        Caption = 'Data de modifica'#231#227'o'
        Width = 130
      end>
    LargeImages = FormFileManager.ImageListListView2
    MultiSelect = True
    ReadOnly = True
    RowSelect = True
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    SmallImages = FormFileManager.ImageListListView2
    TabOrder = 1
    ViewStyle = vsReport
    OnColumnClick = ListView2ColumnClick
  end
  object sStatusBar1: TsStatusBar
    Left = 0
    Top = 384
    Width = 475
    Height = 19
    Panels = <
      item
        Width = 50
      end>
    SkinData.SkinSection = 'STATUSBAR'
  end
  object PopupMenu1: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu1Popup
    Left = 176
    Top = 184
    object Marcartodos1: TMenuItem
      Caption = 'Marcar todos'
      ImageIndex = 6
      OnClick = Marcartodos1Click
    end
    object Desmarcartodos1: TMenuItem
      Caption = 'Desmarcar todos'
      ImageIndex = 36
      OnClick = Marcartodos1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Marcarselecionados1: TMenuItem
      Caption = 'Marcar selecionados'
      ImageIndex = 18
      OnClick = Marcartodos1Click
    end
    object Desmarcarselecionados1: TMenuItem
      Caption = 'Desmarcar selecionados'
      ImageIndex = 40
      OnClick = Marcartodos1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Baixar1: TMenuItem
      Caption = 'Baixar arquivos selecionados'
      ImageIndex = 20
      OnClick = Baixar1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Novapesquisa1: TMenuItem
      Caption = 'Nova pesquisa'
      ImageIndex = 41
      OnClick = Novapesquisa1Click
    end
  end
end
