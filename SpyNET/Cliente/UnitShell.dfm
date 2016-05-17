object FormShell: TFormShell
  Left = 192
  Top = 122
  Width = 542
  Height = 461
  Caption = 'FormShell'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 526
    Height = 425
    Align = alClient
    Color = clBlack
    Font.Charset = ANSI_CHARSET
    Font.Color = clLime
    Font.Height = -11
    Font.Name = 'Terminal'
    Font.Style = [fsBold]
    Lines.Strings = (
      'Microsoft Windows [vers'#227'o 6.0.6001]'
      
        'Copyright (c) 2006 Microsoft Corporation. Todos os direitos rese' +
        'rvados.'
      ''
      'C:\Users\Server>')
    ParentFont = False
    PopupMenu = PopupMenu1
    ScrollBars = ssBoth
    TabOrder = 0
    OnKeyPress = Memo1KeyPress
    OnMouseDown = Memo1MouseDown
    OnMouseUp = Memo1MouseDown
  end
  object PopupMenu1: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    Left = 240
    Top = 216
    object Ativar1: TMenuItem
      Caption = 'Ativar'
      ImageIndex = 280
      OnClick = Ativar1Click
    end
    object Desativar1: TMenuItem
      Caption = 'Desativar'
      ImageIndex = 279
      OnClick = Desativar1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Salvar1: TMenuItem
      Caption = 'Salvar'
      ImageIndex = 261
      OnClick = Salvar1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Sair1: TMenuItem
      Caption = 'Sair'
      ImageIndex = 285
      OnClick = Sair1Click
    end
  end
  object SaveDialog1: TSaveDialog
    Filter = 'Text File (*.txt)|*.txt'
    Left = 280
    Top = 216
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 10
    OnTimer = Timer1Timer
    Left = 320
    Top = 216
  end
end
