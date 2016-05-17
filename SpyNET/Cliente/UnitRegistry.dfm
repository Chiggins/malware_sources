object FormRegistry: TFormRegistry
  Left = 291
  Top = 149
  Width = 600
  Height = 406
  Caption = 'FormRegistry'
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Arial'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 14
  object Splitter1: TSplitter
    Left = 177
    Top = 0
    Height = 344
    MinSize = 3
    OnMoved = Splitter1Moved
  end
  object TreeViewRegedit: TTreeView
    Left = 0
    Top = 0
    Width = 177
    Height = 344
    Align = alLeft
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    Images = FormPrincipal.ImageListIcons
    Indent = 23
    ParentShowHint = False
    PopupMenu = PopupRegistro
    ReadOnly = True
    RightClickSelect = True
    RowSelect = True
    ShowHint = False
    StateImages = FormPrincipal.ImageListIcons
    TabOrder = 0
    OnChange = TreeViewRegeditChange
    OnContextPopup = TreeViewRegeditContextPopup
    OnDblClick = TreeViewRegeditDblClick
    Items.Data = {
      050000002A000000F4000000F3000000FFFFFFFFFFFFFFFF0000000000000000
      11484B45595F434C41535345535F524F4F542A000000F4000000F3000000FFFF
      FFFFFFFFFFFF000000000000000011484B45595F43555252454E545F55534552
      2B000000F4000000F3000000FFFFFFFFFFFFFFFF000000000000000012484B45
      595F4C4F43414C5F4D414348494E4523000000F4000000F3000000FFFFFFFFFF
      FFFFFF00000000000000000A484B45595F55534552532C000000F4000000F300
      0000FFFFFFFFFFFFFFFF000000000000000013484B45595F43555252454E545F
      434F4E464947}
  end
  object ListViewRegistro: TListView
    Left = 180
    Top = 0
    Width = 404
    Height = 344
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvRaised
    BevelKind = bkFlat
    BorderStyle = bsNone
    Columns = <
      item
        Caption = 'Name'
        MinWidth = 110
        Width = 110
      end
      item
        Caption = 'Kind'
        MinWidth = 85
        Width = 85
      end
      item
        Caption = 'Values'
        MinWidth = 170
        Width = 170
      end>
    LargeImages = FormPrincipal.ImageListIcons
    RowSelect = True
    PopupMenu = PopupRegistro
    SmallImages = FormPrincipal.ImageListIcons
    TabOrder = 1
    ViewStyle = vsReport
    OnContextPopup = ListViewRegistroContextPopup
    OnEdited = ListViewRegistroEdited
  end
  object Panel1: TPanel
    Left = 0
    Top = 344
    Width = 584
    Height = 24
    Align = alBottom
    AutoSize = True
    Caption = 'Panel1'
    TabOrder = 2
    object StatusBar1: TStatusBar
      Left = 1
      Top = 1
      Width = 582
      Height = 22
      Panels = <
        item
          Text = 'XXXXXXXXXXXX'
          Width = 400
        end
        item
          Width = 50
        end>
    end
  end
  object PopupRegistro: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    Left = 280
    Top = 204
    object Nuevo1: TMenuItem
      Caption = 'New'
      ImageIndex = 250
      object Clave1: TMenuItem
        Caption = 'Key'
        ImageIndex = 243
        OnClick = Clave1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Valoralfanumrico1: TMenuItem
        Caption = 'String value'
        ImageIndex = 246
        OnClick = Valoralfanumrico1Click
      end
      object Valorbinerio1: TMenuItem
        Caption = 'Bynary value'
        ImageIndex = 245
        OnClick = Valorbinerio1Click
      end
      object valorDWORD1: TMenuItem
        Caption = 'DWORD value'
        ImageIndex = 245
        OnClick = valorDWORD1Click
      end
      object Valordecadenamltiple1: TMenuItem
        Caption = 'Multi-string'
        ImageIndex = 246
        OnClick = Valordecadenamltiple1Click
      end
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N1: TMenuItem
      Caption = 'Change name'
      ImageIndex = 294
      OnClick = N1Click
    end
    object Eliminar1: TMenuItem
      Caption = 'Delete'
      ImageIndex = 283
      OnClick = Eliminar1Click
    end
  end
end
