object FormFTPsettings: TFormFTPsettings
  Left = 231
  Top = 128
  BorderStyle = bsDialog
  Caption = 'FormFTPsettings'
  ClientHeight = 124
  ClientWidth = 313
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 313
    Height = 124
    Align = alClient
    TabOrder = 0
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 23
      Height = 13
      Caption = 'FTP:'
    end
    object Label2: TLabel
      Left = 8
      Top = 48
      Width = 25
      Height = 13
      Caption = 'User:'
    end
    object Label3: TLabel
      Left = 128
      Top = 48
      Width = 26
      Height = 13
      Caption = 'Pass:'
    end
    object Label4: TLabel
      Left = 248
      Top = 48
      Width = 22
      Height = 13
      Caption = 'Port:'
    end
    object Edit1: TEdit
      Left = 8
      Top = 24
      Width = 297
      Height = 21
      TabOrder = 0
      Text = 'ftp.client.com'
      OnEnter = Edit1Enter
      OnExit = Edit1Exit
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 8
      Top = 64
      Width = 105
      Height = 21
      TabOrder = 1
      Text = 'ftpuser'
      OnEnter = Edit1Enter
      OnExit = Edit1Exit
      OnKeyPress = Edit1KeyPress
    end
    object Edit3: TEdit
      Left = 128
      Top = 64
      Width = 105
      Height = 21
      TabOrder = 2
      Text = 'pass1234'
      OnEnter = Edit1Enter
      OnExit = Edit1Exit
      OnKeyPress = Edit1KeyPress
    end
    object Edit4: TEdit
      Left = 248
      Top = 64
      Width = 57
      Height = 21
      MaxLength = 5
      TabOrder = 3
      Text = '21'
      OnEnter = Edit1Enter
      OnExit = Edit1Exit
      OnKeyPress = Edit4KeyPress
    end
    object Button1: TButton
      Left = 176
      Top = 97
      Width = 59
      Height = 21
      Caption = 'OK'
      TabOrder = 4
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 248
      Top = 96
      Width = 59
      Height = 21
      Caption = 'Cancel'
      TabOrder = 5
      OnClick = Button2Click
    end
  end
end
