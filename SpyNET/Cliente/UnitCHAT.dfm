object FormCHAT: TFormCHAT
  Left = 192
  Top = 122
  Width = 737
  Height = 439
  Caption = 'FormCHAT'
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 496
    Height = 401
    Align = alLeft
    Anchors = [akLeft, akTop, akRight, akBottom]
    TabOrder = 0
    DesignSize = (
      496
      401)
    object Memo1: TMemo
      Left = 1
      Top = 1
      Width = 494
      Height = 379
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      Lines.Strings = (
        'Memo1')
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object Edit1: TEdit
      Left = 1
      Top = 379
      Width = 385
      Height = 23
      Anchors = [akLeft, akRight, akBottom]
      Color = clBlack
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clLime
      Font.Height = -12
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'Edit1'
      OnKeyPress = Edit1KeyPress
    end
    object Button1: TButton
      Left = 387
      Top = 381
      Width = 106
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = 'Button1'
      TabOrder = 2
      OnClick = Button1Click
    end
  end
  object Panel2: TPanel
    Left = 496
    Top = 0
    Width = 225
    Height = 401
    Align = alClient
    TabOrder = 1
    object ListView1: TListView
      Left = 1
      Top = 1
      Width = 223
      Height = 399
      Align = alClient
      Columns = <
        item
          Caption = 'Servers'
          MinWidth = 190
          Width = 190
        end>
      LargeImages = FormPrincipal.ImageListIcons
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      SmallImages = FormPrincipal.ImageListIcons
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object PopupMenu1: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenu1Popup
    Left = 576
    Top = 152
    object ExcluirdoCHAT1: TMenuItem
      Caption = 'Excluir do CHAT'
      ImageIndex = 283
      OnClick = ExcluirdoCHAT1Click
    end
  end
end
