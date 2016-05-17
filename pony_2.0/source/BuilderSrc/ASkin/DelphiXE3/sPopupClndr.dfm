object sPopupCalendar: TsPopupCalendar
  Tag = -98
  Left = 512
  Top = 268
  BorderStyle = bsNone
  Caption = 'Mgn'
  ClientHeight = 132
  ClientWidth = 189
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Scaled = False
  OnClose = FormClose
  OnDeactivate = FormDeactivate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sMonthCalendar1: TsMonthCalendar
    Left = 0
    Top = 0
    Width = 189
    Height = 132
    Align = alClient
    BevelWidth = 1
    BorderWidth = 3
    Caption = ' '
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
  end
  object PopupMenu1: TPopupMenu
    Left = 153
    Top = 24
    object N1: TMenuItem
      Caption = '&Copy'
      ShortCut = 16429
    end
    object N2: TMenuItem
      Caption = '&Paste'
      ShortCut = 8237
    end
    object OK1: TMenuItem
      Caption = 'OK'
      ShortCut = 13
      Visible = False
    end
    object Cancel1: TMenuItem
      Caption = 'Cancel'
      ShortCut = 27
      Visible = False
    end
  end
end
