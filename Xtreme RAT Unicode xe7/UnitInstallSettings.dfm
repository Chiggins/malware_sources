object FormInstallSettings: TFormInstallSettings
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  ClientHeight = 287
  ClientWidth = 573
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object MainPanel: TsPanel
    Left = 0
    Top = 0
    Width = 573
    Height = 287
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    SkinData.SkinSection = 'PANEL'
    object Label1: TLabel
      Left = 26
      Top = 36
      Width = 88
      Height = 13
      Caption = 'Nome do arquivo: '
    end
    object Label2: TLabel
      Left = 26
      Top = 65
      Width = 48
      Height = 13
      Caption = 'Diret'#243'rio: '
    end
    object Label3: TLabel
      Left = 26
      Top = 95
      Width = 79
      Height = 13
      Caption = 'Nome da pasta: '
    end
    object Label4: TLabel
      Left = 282
      Top = 9
      Width = 119
      Height = 13
      Caption = 'Infiltrar-se no processo: '
    end
    object Label5: TLabel
      Left = 282
      Top = 129
      Width = 37
      Height = 13
      Caption = 'Mutex: '
    end
    object Label6: TLabel
      Left = 282
      Top = 156
      Width = 34
      Height = 13
      Caption = 'Delay: '
    end
    object Label7: TLabel
      Left = 470
      Top = 156
      Width = 46
      Height = 13
      Caption = 'segundos'
    end
    object CheckBox1: TCheckBox
      Left = 8
      Top = 8
      Width = 249
      Height = 17
      Caption = 'Copiar servidor'
      Checked = True
      State = cbChecked
      TabOrder = 0
      OnClick = CheckBox1Click
    end
    object Edit1: TEdit
      Left = 120
      Top = 33
      Width = 137
      Height = 21
      TabOrder = 1
      Text = 'Edit1'
      OnKeyPress = Edit1KeyPress
    end
    object Edit2: TEdit
      Left = 120
      Top = 92
      Width = 137
      Height = 21
      TabOrder = 2
      Text = 'Edit2'
      OnKeyPress = Edit1KeyPress
    end
    object ComboBox1: TComboBox
      Left = 120
      Top = 62
      Width = 137
      Height = 21
      Style = csDropDownList
      ItemIndex = 3
      TabOrder = 3
      Text = 'Arquivos de programas'
      Items.Strings = (
        'Windows'
        'System'
        'Root'
        'Arquivos de programas'
        'Appdata'
        'Temp')
    end
    object CheckBox2: TCheckBox
      Left = 8
      Top = 128
      Width = 249
      Height = 17
      Caption = 'Excluir-se a'#243's a execu'#231#227'o'
      TabOrder = 4
    end
    object CheckBox3: TCheckBox
      Left = 8
      Top = 160
      Width = 249
      Height = 17
      Caption = 'Iniciar junto com o sistema'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = CheckBox3Click
    end
    object CheckBox4: TCheckBox
      Left = 26
      Top = 188
      Width = 88
      Height = 17
      Caption = 'HKLM\Run:'
      Checked = True
      State = cbChecked
      TabOrder = 6
      OnClick = CheckBox4Click
    end
    object CheckBox6: TCheckBox
      Left = 26
      Top = 240
      Width = 88
      Height = 17
      Caption = 'ActiveX:'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = CheckBox6Click
    end
    object CheckBox5: TCheckBox
      Left = 26
      Top = 214
      Width = 88
      Height = 17
      Caption = 'HKCU\Run:'
      Checked = True
      State = cbChecked
      TabOrder = 8
      OnClick = CheckBox5Click
    end
    object ComboBox2: TComboBox
      Left = 416
      Top = 8
      Width = 145
      Height = 21
      DoubleBuffered = True
      ItemIndex = 4
      ParentDoubleBuffered = False
      TabOrder = 9
      Text = '%DEFAULTBROWSER%'
      OnKeyPress = Edit1KeyPress
      Items.Strings = (
        'calc.exe'
        'notepad.exe'
        'explorer.exe'
        'svchost.exe'
        '%DEFAULTBROWSER%'
        '%NOINJECT%')
    end
    object CheckBox7: TCheckBox
      Left = 282
      Top = 33
      Width = 153
      Height = 17
      Caption = 'Persist'#234'ncia'
      TabOrder = 10
    end
    object CheckBox8: TCheckBox
      Left = 282
      Top = 62
      Width = 153
      Height = 17
      Caption = 'Ocultar servidor'
      TabOrder = 11
    end
    object CheckBox9: TCheckBox
      Left = 282
      Top = 92
      Width = 153
      Height = 17
      Caption = 'USB Spreader'
      TabOrder = 12
    end
    object Edit3: TEdit
      Left = 416
      Top = 126
      Width = 145
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 13
      Text = 'Edit3'
      OnDblClick = Edit3DblClick
      OnKeyPress = Edit1KeyPress
    end
    object Edit4: TEdit
      Left = 120
      Top = 186
      Width = 137
      Height = 21
      TabOrder = 14
      Text = 'Edit4'
      OnKeyPress = Edit1KeyPress
    end
    object Edit5: TEdit
      Left = 120
      Top = 238
      Width = 241
      Height = 21
      ParentShowHint = False
      ShowHint = True
      TabOrder = 15
      Text = '{5460C4DF-B266-909E-CB58-D26G798R2EB2}'
      OnDblClick = Edit5DblClick
    end
    object Edit6: TEdit
      Left = 120
      Top = 212
      Width = 137
      Height = 21
      TabOrder = 16
      Text = 'Edit6'
      OnKeyPress = Edit1KeyPress
    end
    object CheckBox10: TCheckBox
      Left = 26
      Top = 266
      Width = 88
      Height = 17
      Caption = 'Mais op'#231#245'es...'
      Checked = True
      State = cbChecked
      TabOrder = 17
      OnClick = CheckBox10Click
    end
    object Edit7: TEdit
      Left = 416
      Top = 153
      Width = 41
      Height = 21
      NumbersOnly = True
      TabOrder = 18
      Text = '0'
      OnChange = Edit7Change
      OnKeyPress = Edit1KeyPress
    end
  end
end
