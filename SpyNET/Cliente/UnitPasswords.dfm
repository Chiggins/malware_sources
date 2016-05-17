object FormPasswords: TFormPasswords
  Left = 190
  Top = 119
  Width = 500
  Height = 301
  Caption = 'List of passwords'
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
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
    Width = 484
    Height = 232
    Align = alClient
    Columns = <
      item
        Caption = 'Kind of password'
        MinWidth = 100
        Width = 100
      end
      item
        Caption = 'Server name'
        MinWidth = 120
        Width = 120
      end
      item
        Caption = 'User'
        MinWidth = 100
        Width = 100
      end
      item
        Caption = 'Password'
        MinWidth = 100
        Width = 100
      end>
    LargeImages = FormPrincipal.ImageListIcons
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    SmallImages = FormPrincipal.ImageListIcons
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListView1ColumnClick
    OnCompare = ListView1Compare
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 244
    Width = 484
    Height = 19
    Panels = <
      item
        Text = 'Password recebido do servidor: XXXXXXX'
        Width = 50
      end>
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 232
    Width = 484
    Height = 12
    Align = alBottom
    TabOrder = 2
  end
  object PopupMenu1: TPopupMenu
    OnPopup = PopupMenu1Popup
    Left = 224
    Top = 120
    object Copiarnomedeusurio1: TMenuItem
      Caption = 'Copy user name'
      OnClick = Copiarnomedeusurio1Click
    end
    object Copiarsenha1: TMenuItem
      Caption = 'Copy password'
      OnClick = Copiarsenha1Click
    end
    object Abrirsite1: TMenuItem
      Caption = 'Open website'
      OnClick = Abrirsite1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Savepasstxt1: TMenuItem
      Caption = 'Save Passwords (*.txt)'
      OnClick = Savepasstxt1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 256
    Top = 120
  end
end
