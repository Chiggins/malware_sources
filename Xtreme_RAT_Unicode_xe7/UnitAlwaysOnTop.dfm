object FormAlwaysOnTop: TFormAlwaysOnTop
  Left = 0
  Top = 0
  Caption = 'AlwaysOnTop'
  ClientHeight = 405
  ClientWidth = 302
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
  object SpeedButton1: TSpeedButton
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 296
    Height = 22
    Align = alTop
    Caption = 'Apply'
    Flat = True
    OnClick = SpeedButton1Click
    ExplicitLeft = 96
    ExplicitTop = 184
    ExplicitWidth = 23
  end
  object ListView1: TListView
    Left = 0
    Top = 28
    Width = 302
    Height = 377
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        Caption = 'Handle'
        Width = 80
      end
      item
        Caption = 'T'#237'tulo'
        Width = 200
      end>
    ReadOnly = True
    RowSelect = True
    PopupMenu = PopupMenu1
    TabOrder = 0
    ViewStyle = vsReport
    OnColumnClick = ListView1ColumnClick
    OnDblClick = ListView1DblClick
    OnKeyPress = ListView1KeyPress
    ExplicitTop = 0
    ExplicitHeight = 365
  end
  object PopupMenu1: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu1Popup
    Left = 96
    Top = 112
    object Check1: TMenuItem
      Caption = 'Check'
      ImageIndex = 7
      OnClick = Check1Click
    end
    object UnCheck1: TMenuItem
      Caption = 'UnCheck'
      ImageIndex = 40
      OnClick = UnCheck1Click
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Apply1: TMenuItem
      Caption = 'Apply'
      ImageIndex = 18
      OnClick = Apply1Click
    end
  end
  object sSkinProvider1: TsSkinProvider
    AddedTitle.Font.Charset = DEFAULT_CHARSET
    AddedTitle.Font.Color = clNone
    AddedTitle.Font.Height = -11
    AddedTitle.Font.Name = 'Tahoma'
    AddedTitle.Font.Style = []
    DrawNonClientArea = False
    SkinData.SkinSection = 'FORM'
    TitleButtons = <>
    Left = 112
    Top = 16
  end
end
