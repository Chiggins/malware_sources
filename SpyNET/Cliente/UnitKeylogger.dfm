object FormKeylogger: TFormKeylogger
  Left = 405
  Top = 131
  Width = 450
  Height = 400
  Caption = 'FormKeylogger'
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 450
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
    Width = 434
    Height = 362
    Align = alClient
    TabOrder = 0
    DesignSize = (
      434
      362)
    object ProgressBar1: TProgressBar
      Left = 1
      Top = 1
      Width = 12
      Height = 341
      Align = alLeft
      Orientation = pbVertical
      Position = 50
      Smooth = True
      TabOrder = 0
    end
    object Memo1: TMemo
      Left = 13
      Top = 1
      Width = 346
      Height = 341
      Align = alLeft
      Anchors = [akLeft, akTop, akRight, akBottom]
      ScrollBars = ssBoth
      TabOrder = 1
    end
    object Button1: TButton
      Left = 367
      Top = 8
      Width = 57
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Download'
      TabOrder = 2
      OnClick = Button1Click
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 342
      Width = 432
      Height = 19
      Panels = <
        item
          Text = 'Receber respostas'
          Width = 50
        end>
    end
    object Button2: TButton
      Left = 367
      Top = 32
      Width = 57
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Delete'
      TabOrder = 4
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 367
      Top = 56
      Width = 57
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Save'
      TabOrder = 5
      OnClick = Button3Click
    end
    object Button4: TButton
      Left = 367
      Top = 80
      Width = 57
      Height = 21
      Anchors = [akTop, akRight]
      Caption = 'Wait'
      TabOrder = 6
      OnClick = Button4Click
    end
  end
  object SaveDialog1: TSaveDialog
    Left = 24
    Top = 8
  end
end
