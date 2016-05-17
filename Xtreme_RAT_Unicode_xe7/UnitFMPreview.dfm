object FormFMPreview: TFormFMPreview
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 215
  ClientWidth = 270
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 270
    Height = 215
    Align = alClient
    ParentShowHint = False
    PopupMenu = PopupMenu1
    ShowHint = True
    Stretch = True
    ExplicitLeft = 208
    ExplicitTop = 104
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object PopupMenu1: TPopupMenu
    Images = FormMain.ImageListDiversos
    OnPopup = PopupMenu1Popup
    Left = 48
    Top = 80
    object Salvar1: TMenuItem
      Caption = 'Salvar'
      ImageIndex = 261
      OnClick = Salvar1Click
    end
  end
  object SaveDialog1: TSaveDialog
    FileName = 'Image.jpg'
    Filter = 'Jpeg mages (*.jpg)|*.jpg'
    Title = 'Save file'
    Left = 48
    Top = 136
  end
end
