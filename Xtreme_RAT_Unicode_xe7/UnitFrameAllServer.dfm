object FrameAllServer: TFrameAllServer
  Left = 0
  Top = 0
  Width = 184
  Height = 259
  TabOrder = 0
  DesignSize = (
    184
    259)
  object sWebLabel1: TsWebLabel
    Left = 27
    Top = 11
    Width = 53
    Height = 13
    Caption = 'Desinstalar'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel2: TsWebLabel
    Tag = 1
    Left = 27
    Top = 33
    Width = 55
    Height = 13
    Caption = 'Reconectar'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel3: TsWebLabel
    Tag = 2
    Left = 27
    Top = 55
    Width = 76
    Height = 13
    Caption = 'Mudar de grupo'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel4: TsWebLabel
    Tag = 3
    Left = 27
    Top = 77
    Width = 49
    Height = 13
    Caption = 'Renomear'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel5: TsWebLabel
    Tag = 4
    Left = 27
    Top = 99
    Width = 40
    Height = 13
    Caption = 'Reiniciar'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel6: TsWebLabel
    Tag = 5
    Left = 27
    Top = 121
    Width = 46
    Height = 13
    Caption = 'Desativar'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sWebLabel7: TsWebLabel
    Tag = 6
    Left = 27
    Top = 143
    Width = 84
    Height = 13
    Caption = 'Atualizar servidor'
    ParentFont = False
    OnClick = sWebLabel1Click
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    UseSkinColor = False
    HoverFont.Charset = DEFAULT_CHARSET
    HoverFont.Color = clRed
    HoverFont.Height = -11
    HoverFont.Name = 'Tahoma'
    HoverFont.Style = []
  end
  object sSpeedButton1: TSpeedButton
    Left = 3
    Top = 9
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object sSpeedButton2: TSpeedButton
    Tag = 1
    Left = 3
    Top = 31
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object sSpeedButton3: TSpeedButton
    Tag = 2
    Left = 3
    Top = 53
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object sSpeedButton4: TSpeedButton
    Tag = 3
    Left = 3
    Top = 75
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object sSpeedButton5: TSpeedButton
    Tag = 4
    Left = 3
    Top = 97
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object sSpeedButton6: TSpeedButton
    Tag = 5
    Left = 3
    Top = 119
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object sSpeedButton7: TSpeedButton
    Tag = 6
    Left = 3
    Top = 141
    Width = 18
    Height = 18
    Flat = True
    OnClick = sWebLabel1Click
  end
  object RadioGroup1: TsRadioGroup
    Left = 9
    Top = 160
    Width = 162
    Height = 80
    Anchors = [akLeft, akTop, akRight]
    Caption = 'M'#233'todo: '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clTeal
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    SkinData.SkinSection = 'GROUPBOX'
    ItemIndex = 0
    Items.Strings = (
      'Arquivo local'
      'Link http://'
      'Modificar configura'#231#245'es')
  end
  object sFrameAdapter1: TsFrameAdapter
    SkinData.SkinSection = 'BARPANEL'
    Left = 128
    Top = 8
  end
  object OpenDialog1: TOpenDialog
    Left = 128
    Top = 64
  end
end
