object acMagnForm: TacMagnForm
  Tag = -98
  Left = 340
  Top = 229
  BorderStyle = bsNone
  Caption = 'Mgn'
  ClientHeight = 250
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = True
  PopupMenu = PopupMenu1
  Position = poScreenCenter
  Scaled = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnDblClick = Image1DblClick
  OnKeyDown = FormKeyDown
  OnMouseDown = FormMouseDown
  OnMouseMove = Image1MouseMove
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PopupMenu1: TPopupMenu
    Left = 102
    Top = 54
    object N1x1: TMenuItem
      Tag = 2
      Caption = '2x'
      GroupIndex = 1
      RadioItem = True
      OnClick = Zoom1x1Click
    end
    object N2x1: TMenuItem
      Tag = 4
      Caption = '4x'
      GroupIndex = 1
      RadioItem = True
      OnClick = Zoom1x1Click
    end
    object N8x1: TMenuItem
      Tag = 8
      Caption = '8x'
      GroupIndex = 1
      RadioItem = True
      OnClick = Zoom1x1Click
    end
    object N16x1: TMenuItem
      Tag = 16
      Caption = '16x'
      GroupIndex = 1
      RadioItem = True
      OnClick = Zoom1x1Click
    end
    object N1: TMenuItem
      Caption = '-'
      GroupIndex = 1
    end
    object Close1: TMenuItem
      Caption = 'Close'
      Default = True
      GroupIndex = 1
      ShortCut = 27
      OnClick = Close1Click
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 20
    OnTimer = Timer1Timer
    Left = 144
    Top = 56
  end
end
