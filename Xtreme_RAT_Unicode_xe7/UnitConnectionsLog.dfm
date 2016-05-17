object FormConnectionsLog: TFormConnectionsLog
  Left = 0
  Top = 0
  ClientHeight = 376
  ClientWidth = 647
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 193
    Height = 376
    Align = alLeft
    TabOrder = 0
    object SpeedButton1: TSpeedButton
      AlignWithMargins = True
      Left = 4
      Top = 223
      Width = 185
      Height = 34
      Align = alTop
      Caption = 'Mostrar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton1Click
    end
    object SpeedButton2: TSpeedButton
      AlignWithMargins = True
      Left = 4
      Top = 263
      Width = 185
      Height = 34
      Align = alTop
      Caption = 'Salvar'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      OnClick = SpeedButton2Click
      ExplicitLeft = 2
      ExplicitTop = 303
    end
    object Label1: TLabel
      Left = 1
      Top = 300
      Width = 191
      Height = 13
      Align = alTop
      Caption = 'Total de registros: '
      ExplicitWidth = 91
    end
    object sMonthCalendar1: TsMonthCalendar
      AlignWithMargins = True
      Left = 4
      Top = 70
      Width = 185
      Height = 147
      Align = alTop
      BevelWidth = 1
      BorderWidth = 3
      Caption = ' '
      DoubleBuffered = True
      ParentDoubleBuffered = False
      TabOrder = 0
      Visible = False
      SkinData.SkinSection = 'PANEL'
      ShowTodayBtn = True
    end
    object RadioGroup1: TRadioGroup
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 185
      Height = 60
      Align = alTop
      Caption = 'Visualizar logs...'
      ItemIndex = 1
      Items.Strings = (
        'Todos'
        'Selecionar data')
      TabOrder = 1
      OnClick = RadioGroup1Click
    end
  end
  object ListView1: TListView
    Left = 193
    Top = 0
    Width = 454
    Height = 376
    Align = alClient
    Columns = <
      item
        Caption = 'Servidor'
        Width = 120
      end
      item
        Caption = 'In'#237'cio da conex'#227'o'
        Width = 150
      end
      item
        Caption = 'Fim da conex'#227'o'
        Width = 150
      end>
    LargeImages = FormMain.Flags16
    ReadOnly = True
    RowSelect = True
    SmallImages = FormMain.Flags16
    TabOrder = 1
    ViewStyle = vsReport
    OnChange = ListView1Change
    OnColumnClick = ListView1ColumnClick
  end
  object SaveDialog1: TSaveDialog
    Left = 216
    Top = 32
  end
end
