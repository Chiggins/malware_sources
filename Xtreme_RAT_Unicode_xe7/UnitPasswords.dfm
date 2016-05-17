object FormPasswords: TFormPasswords
  Left = 0
  Top = 0
  Caption = 'FormPasswords'
  ClientHeight = 455
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object AdvProgressBar1: TAdvProgressBar
    Left = 0
    Top = 437
    Width = 546
    Height = 18
    Align = alBottom
    CompletionSmooth = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Verdana'
    Font.Style = []
    Level0ColorTo = 14811105
    Level1Color = clLime
    Level1ColorTo = 14811105
    Level2Color = clLime
    Level2ColorTo = 14811105
    Level3Color = clLime
    Level3ColorTo = 14811105
    Level1Perc = 70
    Level2Perc = 90
    Position = 50
    ShowBorder = True
    Version = '1.2.0.1'
    ExplicitLeft = -7
    ExplicitTop = 369
    ExplicitWidth = 553
  end
  object bsSkinPanel1: TPanel
    Left = 0
    Top = 0
    Width = 546
    Height = 437
    Align = alClient
    TabOrder = 0
    object AdvListView1: TListView
      Left = 1
      Top = 1
      Width = 544
      Height = 435
      Align = alClient
      Columns = <
        item
          Caption = 'Tipo de senha'
          Width = 120
        end
        item
          Caption = 'Nome do servidor'
          Width = 150
        end
        item
          Caption = 'Usu'#225'rio'
          Width = 100
        end
        item
          Caption = 'Senha'
          Width = 100
        end>
      Items.ItemData = {
        0330000000010000006B000000FFFFFFFFFFFFFFFF04000000FFFFFFFF000000
        00016100016100016100016100016100FFFFFFFFFFFFFFFF}
      LargeImages = FormMain.ImageListDiversos
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      SmallImages = FormMain.ImageListDiversos
      TabOrder = 0
      ViewStyle = vsReport
      OnColumnClick = AdvListView1ColumnClick
    end
  end
  object PopupMenu1: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu1Popup
    Left = 168
    Top = 232
    object Copyusername1: TMenuItem
      Caption = 'Copy user name'
      OnClick = Copyusername1Click
    end
    object Copypassword1: TMenuItem
      Caption = 'Copy password'
      OnClick = Copypassword1Click
    end
    object Openwebsite1: TMenuItem
      Caption = 'Open website'
      OnClick = Openwebsite1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Savepasswordstxt1: TMenuItem
      Caption = 'Save passwords (*.txt)'
      OnClick = Savepasswordstxt1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'All files|*.*'
    Title = 'Save file'
    Left = 264
    Top = 232
  end
end
