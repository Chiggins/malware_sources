object FormBindFiles: TFormBindFiles
  Left = 192
  Top = 122
  BorderStyle = bsDialog
  Caption = 'FormBindFiles'
  ClientHeight = 279
  ClientWidth = 504
  Color = clBtnFace
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 504
    Height = 279
    Align = alClient
    TabOrder = 0
    object Label5: TLabel
      Left = 8
      Top = 176
      Width = 41
      Height = 14
      Caption = 'Arquivo:'
    end
    object Label6: TLabel
      Left = 8
      Top = 204
      Width = 39
      Height = 14
      Caption = 'Destino:'
    end
    object Label8: TLabel
      Left = 8
      Top = 233
      Width = 51
      Height = 14
      Caption = 'Execu'#231#227'o:'
    end
    object Label1: TLabel
      Left = 8
      Top = 256
      Width = 477
      Height = 14
      Caption = 
        '* Os itens que n'#227'o forem checados ser'#227'o executados somente na pr' +
        'imeira execu'#231#227'o do programa'
    end
    object Label2: TLabel
      Left = 288
      Top = 204
      Width = 52
      Height = 14
      Caption = 'Par'#226'metro:'
    end
    object ListView2: TListView
      Left = 8
      Top = 10
      Width = 481
      Height = 150
      Checkboxes = True
      Columns = <
        item
          Caption = 'Nome do arquivo'
          MinWidth = 100
          Width = 100
        end
        item
          Caption = 'Destino'
          Width = 70
        end
        item
          Caption = 'Tamanho'
          MinWidth = 70
          Width = 70
        end
        item
          Caption = 'Execu'#231#227'o'
          MinWidth = 80
          Width = 80
        end
        item
          Caption = 'Par'#226'metro'
          MinWidth = 80
          Width = 80
        end>
      GridLines = True
      LargeImages = ImageList1
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenu1
      SmallImages = ImageList1
      TabOrder = 0
      ViewStyle = vsReport
      OnEnter = Edit5Enter
      OnExit = Edit5Exit
    end
    object ComboBox4: TComboBox
      Left = 80
      Top = 225
      Width = 209
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 0
      TabOrder = 1
      Text = 'Shell Execute (Normal)'
      OnEnter = Edit5Enter
      OnExit = Edit5Exit
      Items.Strings = (
        'Shell Execute (Normal)'
        'Shell Execute (Hidden)'
        'Memory'
        'Extract only')
    end
    object ComboBox3: TComboBox
      Left = 80
      Top = 196
      Width = 145
      Height = 22
      Style = csDropDownList
      ItemHeight = 14
      ItemIndex = 4
      TabOrder = 2
      Text = 'Temp'
      OnEnter = Edit5Enter
      OnExit = Edit5Exit
      Items.Strings = (
        'Root'
        'Windows'
        'System'
        'Program Files'
        'Temp')
    end
    object Edit5: TEdit
      Left = 80
      Top = 168
      Width = 379
      Height = 22
      ReadOnly = True
      TabOrder = 3
      OnEnter = Edit5Enter
      OnExit = Edit5Exit
    end
    object Edit6: TEdit
      Left = 368
      Top = 196
      Width = 121
      Height = 22
      TabOrder = 4
      OnEnter = Edit5Enter
      OnExit = Edit5Exit
    end
    object BitBtn3: TBitBtn
      Left = 461
      Top = 168
      Width = 27
      Height = 20
      Caption = '...'
      TabOrder = 5
      OnClick = BitBtn3Click
    end
    object BitBtn4: TBitBtn
      Left = 368
      Top = 225
      Width = 121
      Height = 21
      Caption = 'Adicionar'
      TabOrder = 6
      OnClick = BitBtn4Click
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 336
    Top = 120
  end
  object PopupMenu1: TPopupMenu
    Images = FormPrincipal.ImageListIcons
    OnPopup = PopupMenu1Popup
    Left = 376
    Top = 120
    object Delete1: TMenuItem
      Caption = 'Delete'
      ImageIndex = 283
      OnClick = Delete1Click
    end
  end
  object ImageList1: TImageList
    Left = 296
    Top = 120
  end
end
