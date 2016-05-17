object FormFuncoesDiversas: TFormFuncoesDiversas
  Left = 258
  Top = 213
  Width = 700
  Height = 500
  Caption = 'FormFuncoesDiversas'
  Color = clBtnFace
  Constraints.MinHeight = 500
  Constraints.MinWidth = 700
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 684
    Height = 443
    ActivePage = TabSheet7
    Align = alClient
    Images = FormPrincipal.ImageListIcons
    TabOrder = 0
    OnChange = PageControl1Change
    object TabSheet6: TTabSheet
      Caption = 'Configura'#231#245'es'
      ImageIndex = 268
      DesignSize = (
        676
        414)
      object Memo1: TMemo
        Left = 16
        Top = 16
        Width = 643
        Height = 371
        Anchors = [akLeft, akTop, akRight, akBottom]
        Color = clBlack
        Font.Charset = ANSI_CHARSET
        Font.Color = clLime
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Button6: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button6'
        TabOrder = 1
        OnClick = Button6Click
      end
    end
    object TabSheet1: TTabSheet
      Caption = 'Processos'
      ImageIndex = 270
      DesignSize = (
        676
        414)
      object Button1: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button1'
        TabOrder = 0
        OnClick = Button1Click
      end
      object ListView1: TListView
        Left = 16
        Top = 16
        Width = 644
        Height = 369
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Processo'
            Width = 100
          end
          item
            Caption = 'PID'
            Width = 60
          end
          item
            Caption = 'Mem'#243'ria (Kb)'
            Width = 80
          end
          item
            Caption = 'Localiza'#231#227'o'
            Width = 270
          end>
        LargeImages = FormPrincipal.ImageListIcons
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenuProcessos
        SmallImages = FormPrincipal.ImageListIcons
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCompare = ListView1Compare
        OnCustomDrawItem = ListView1CustomDrawItem
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Servi'#231'os'
      ImageIndex = 301
      DesignSize = (
        676
        414)
      object Button2: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button2'
        TabOrder = 0
        OnClick = Button2Click
      end
      object ListView2: TListView
        Left = 16
        Top = 16
        Width = 644
        Height = 369
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Nome do servi'#231'o'
            Width = 150
          end
          item
            Caption = 'Descri'#231#227'o'
            Width = 200
          end
          item
            Caption = 'Status'
            Width = 80
          end>
        LargeImages = FormPrincipal.ImageListIcons
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenuServicos
        SmallImages = FormPrincipal.ImageListIcons
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCompare = ListView1Compare
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Janelas'
      ImageIndex = 271
      DesignSize = (
        676
        414)
      object Button3: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button3'
        TabOrder = 0
        OnClick = Button3Click
      end
      object ListView3: TListView
        Left = 16
        Top = 16
        Width = 644
        Height = 369
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Nome da janela'
            Width = 170
          end
          item
            Caption = 'Handle'
            Width = 70
          end
          item
            Caption = 'Nome do arquivo'
            Width = 200
          end
          item
            Caption = 'Vis'#237'vel'
            Width = 70
          end>
        LargeImages = FormPrincipal.ImageListIcons
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenuJanelas
        SmallImages = FormPrincipal.ImageListIcons
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCompare = ListView1Compare
        OnCustomDrawItem = ListView3CustomDrawItem
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Programas Instalados'
      ImageIndex = 320
      DesignSize = (
        676
        414)
      object Button4: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button4'
        TabOrder = 0
        OnClick = Button4Click
      end
      object ListView4: TListView
        Left = 16
        Top = 16
        Width = 644
        Height = 369
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Nome do programa'
            Width = 150
          end
          item
            Caption = 'Nome do arquivo'
            Width = 200
          end
          item
            Caption = 'Desinstala'#231#227'o'
            Width = 100
          end>
        LargeImages = FormPrincipal.ImageListIcons
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenuProgInstalados
        SmallImages = FormPrincipal.ImageListIcons
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCompare = ListView1Compare
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Portas ativas'
      ImageIndex = 344
      DesignSize = (
        676
        414)
      object Button5: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button5'
        TabOrder = 0
        OnClick = Button5Click
      end
      object ListView5: TListView
        Left = 16
        Top = 16
        Width = 644
        Height = 369
        Anchors = [akLeft, akTop, akRight, akBottom]
        Columns = <
          item
            Caption = 'Protocol'
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
            Caption = 'Remote Port'
            Width = 80
          end
          item
            Caption = 'Status'
            Width = 100
          end
          item
            Caption = 'PID'
            Width = 60
          end
          item
            Caption = 'Process'
            Width = 70
          end>
        LargeImages = FormPrincipal.ImageListIcons
        ReadOnly = True
        RowSelect = True
        PopupMenu = PopupMenuPortas
        SmallImages = FormPrincipal.ImageListIcons
        TabOrder = 1
        ViewStyle = vsReport
        OnColumnClick = ListView1ColumnClick
        OnCompare = ListView1Compare
        OnCustomDrawItem = ListView5CustomDrawItem
      end
    end
    object TabSheet7: TTabSheet
      Caption = 'Clipboard'
      ImageIndex = 248
      DesignSize = (
        676
        414)
      object Memo2: TMemo
        Left = 16
        Top = 16
        Width = 643
        Height = 371
        Anchors = [akLeft, akTop, akRight, akBottom]
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlack
        Font.Height = -11
        Font.Name = 'Arial'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Button7: TButton
        Left = 587
        Top = 391
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button7'
        TabOrder = 1
        OnClick = Button7Click
      end
      object Button8: TButton
        Left = 507
        Top = 392
        Width = 75
        Height = 21
        Anchors = [akRight, akBottom]
        Caption = 'Button8'
        TabOrder = 2
        OnClick = Button8Click
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 443
    Width = 684
    Height = 19
    Panels = <
      item
        Text = 'Comando executado com sucesso'
        Width = 50
      end>
  end
  object PopupMenuProcessos: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenuProcessosPopup
    Left = 36
    Top = 73
    object Atualizar1: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 321
      OnClick = Button1Click
    end
    object Finalizar1: TMenuItem
      Caption = 'Finalizar'
      ImageIndex = 283
      OnClick = Finalizar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Sair1: TMenuItem
      Caption = 'Sair'
      ImageIndex = 285
      OnClick = Sair1Click
    end
  end
  object PopupMenuServicos: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenuServicosPopup
    Left = 68
    Top = 73
    object Atualizar2: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 321
      OnClick = Button2Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Iniciar1: TMenuItem
      Caption = 'Iniciar'
      ImageIndex = 264
      OnClick = Iniciar1Click
    end
    object Parar1: TMenuItem
      Caption = 'Parar'
      ImageIndex = 265
      OnClick = Parar1Click
    end
    object Desinstalar1: TMenuItem
      Caption = 'Desinstalar'
      ImageIndex = 283
      OnClick = Desinstalar1Click
    end
    object Instalar1: TMenuItem
      Caption = 'Instalar'
      ImageIndex = 250
      OnClick = Instalar1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Sair2: TMenuItem
      Caption = 'Sair'
      ImageIndex = 285
      OnClick = Sair1Click
    end
  end
  object PopupMenuJanelas: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenuJanelasPopup
    Left = 100
    Top = 73
    object Atualizar3: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 321
      OnClick = Button3Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Fechar1: TMenuItem
      Caption = 'Fechar'
      ImageIndex = 283
      OnClick = Fechar1Click
    end
    object Maximizar1: TMenuItem
      Caption = 'Maximizar'
      ImageIndex = 256
      OnClick = Maximizar1Click
    end
    object Minimizar1: TMenuItem
      Caption = 'Minimizar'
      ImageIndex = 255
      OnClick = Minimizar1Click
    end
    object MostrarRestaurar1: TMenuItem
      Caption = 'Mostrar / Restaurar'
      ImageIndex = 275
      OnClick = MostrarRestaurar1Click
    end
    object Ocultar1: TMenuItem
      Caption = 'Ocultar'
      ImageIndex = 277
      OnClick = Ocultar1Click
    end
    object Minimizartodas1: TMenuItem
      Caption = 'Minimizar todas'
      ImageIndex = 276
      OnClick = Minimizartodas1Click
    end
    object Mudaronome1: TMenuItem
      Caption = 'Mudar o nome'
      ImageIndex = 294
      OnClick = Mudaronome1Click
    end
    object BloquearobotoX1: TMenuItem
      Caption = 'Bloquear o bot'#227'o "[X] Fechar"'
      ImageIndex = 309
      OnClick = BloquearobotoX1Click
    end
    object DesbloquearobotoXFechar1: TMenuItem
      Caption = 'Desbloquear o bot'#227'o "[X] Fechar"'
      ImageIndex = 308
      OnClick = DesbloquearobotoXFechar1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Sair3: TMenuItem
      Caption = 'Sair'
      ImageIndex = 285
      OnClick = Sair1Click
    end
  end
  object PopupMenuProgInstalados: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenuProgInstaladosPopup
    Left = 132
    Top = 73
    object Atualizar4: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 321
      OnClick = Button4Click
    end
    object Desinstalar2: TMenuItem
      Caption = 'Desinstalar'
      ImageIndex = 283
      OnClick = Desinstalar2Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Sair4: TMenuItem
      Caption = 'Sair'
      ImageIndex = 285
      OnClick = Sair1Click
    end
  end
  object PopupMenuPortas: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenuPortasPopup
    Left = 164
    Top = 73
    object Atualizar5: TMenuItem
      Caption = 'Atualizar'
      ImageIndex = 321
      OnClick = Button5Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object DNSResolve1: TMenuItem
      Caption = 'DNS Resolve'
      OnClick = DNSResolve1Click
    end
    object Finalizarconexo1: TMenuItem
      Caption = 'Finalizar conex'#227'o'
      ImageIndex = 305
      OnClick = Finalizarconexo1Click
    end
    object Finalizarprocesso1: TMenuItem
      Caption = 'Finalizar processo'
      ImageIndex = 283
      OnClick = Finalizarprocesso1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object Sair5: TMenuItem
      Caption = 'Sair'
      ImageIndex = 285
      OnClick = Sair1Click
    end
  end
end
