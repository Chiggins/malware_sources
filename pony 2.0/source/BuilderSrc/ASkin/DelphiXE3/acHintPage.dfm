object FrameHintPage: TFrameHintPage
  Left = 0
  Top = 0
  Width = 505
  Height = 365
  TabOrder = 0
  object sScrollBox1: TsScrollBox
    Left = 8
    Top = 8
    Width = 308
    Height = 245
    TabOrder = 0
    SkinData.SkinSection = 'EDIT'
    object PaintBox1: TPaintBox
      Left = 0
      Top = 0
      Width = 304
      Height = 241
      Align = alClient
      OnPaint = PaintBox1Paint
    end
  end
  object sGroupBox1: TsGroupBox
    Left = 8
    Top = 258
    Width = 103
    Height = 99
    Caption = ' Image : '
    TabOrder = 1
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object sSpeedButton3: TsSpeedButton
      Tag = 1
      Left = 10
      Top = 18
      Width = 82
      Height = 37
      Caption = 'Load'
      Enabled = False
      Flat = True
      Glyph.Data = {
        F6060000424DF606000000000000360000002800000018000000180000000100
        180000000000C0060000120B0000120B00000000000000000000FF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FF0082C10082C10082C10082C1FF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF0588C472C7E950C6F62DAFE7169CD70082C100
        82C10082C10082C1FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0284C25BB8DD93E2FE52CC
        FF5AD0FF5CD1FF5CD0FF48C4F71C9FDA0083C20082C10082C10082C10082C1FF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF0082C1
        1F9ACEAAE2F653CCFF54CCFE55CCFE55CCFE56CCFF59D0FF5FD4FF5ED3FF58CE
        FF41BDF21197D30082C10082C10082C1FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FF0082C10F93CA76C6E57FDCFF54CEFE56CEFE56CEFE56CEFE56CEFE
        56CEFE56CEFE58CFFE5BD1FF60D5FF5FD4FF5DD1FF5CD1FF0082C1FF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FF0082C11C9DD130A4D4ABE9FA56D3FE5CD4FE5C
        D4FE5CD4FE5CD4FE5CD4FE5CD4FE5CD4FE5BD4FE5BD4FE5BD4FE5DD5FF62D8FF
        4AC5F60082C1FF00FFFF00FFFF00FFFF00FFFF00FF0082C138B1E00E91C998D9
        EF76E1FF62D9FE62DAFE62DAFE62DAFE62DAFE62DAFE62DAFE62DAFE62DAFE62
        DAFE63DCFE63DAFE43C4EF0082C1FF00FFFF00FFFF00FFFF00FFFF00FF0082C1
        45BBEA0F92CC43B0D9A9F0FE63E0FE68E1FE67E1FE67E1FE67E1FE67E1FE67E1
        FE67E1FE67E1FE67E1FE68E1FE6AE2FE43C6ED74E9FF0082C1FF00FFFF00FFFF
        00FFFF00FF0082C14AC1F227A4DD1697CCADE9F674EAFF6BE7FF6BE7FF6BE7FF
        6BE7FF6CE7FF6CE7FF6CE7FF6CE7FF6CE7FF6DE7FF6FE9FF4ACEEF7EF2FF0082
        C1FF00FFFF00FFFF00FFFF00FF0082C14EC4F63BB4EF0F91CB58BCE0B5FBFF7A
        F4FF7AF4FF79F3FF74F0FF6FEFFF6FEEFF72EEFF72EEFF72EEFF72EEFF75EFFF
        4FD4EF7DF6FF80F8FF0082C1FF00FFFF00FFFF00FF0082C15CC9FB41B8FA27A5
        E21091C9A3DEEFC2F0F8C4F2F8C5F3F8C9F7FBA6FAFE83F6FF76F3FF78F3FF79
        F3FF7AF4FF50C2A4046B0B72E3D78EFFFF2BB0D90082C1FF00FFFF00FF0082C1
        72D0FF44BFFF49BFFE189ADA0588C60689C60689C60689C60A8CC675CBE6D9FC
        FEB2F8FF8FF6FF8CF6FF6AD3C1046B0B22A13D046B0B96EFE5A1FBFC0082C1FF
        00FFFF00FF0082C181D9FF4CC6FF52C7FE51C7FE4EC4FE49C0FA46BFF741BAF2
        2FACE50A8CC932A5D3D5F4FAE1FBFF9DE0D3046B0B31C05846E57D29B049046B
        0BCAF3EB98E2F20082C1FF00FF0082C188E2FF55D1FF5BD3FE5BD3FE5BD3FE5A
        D1FE59D1FE58D1FE58D0FE46C0F30D92CE0D8FC973C0CB046B0B2AB54B41DE73
        3FD86F42E07627AB45046B0BD0EDEA0082C1FF00FF0082C191EAFF5BDDFF62DD
        FF62DDFF62DDFF62DDFF63DDFF63DDFF63DDFF63DAFF57D3FA28A5C5046B0B19
        982E31C75736CE603BD4693FD86E40DA721E9A37046B0B007FB2FF00FF0082C1
        96F3FF64E7FF6BE6FF6BE6FF6BE6FF6BE6FF6AE6FF66E6FF62E6FF63E6FF64E6
        FF046B0B046B0B046B0B046B0B28B74835CF5F3BD569046B0B046B0B046B0B04
        6B0BFF00FF0082C1B7FFFF68F2FF76F2FF76F2FF76F2FF75F2FF74F0FF89FCFF
        A4FFFF9AFFFF99FFFF90F7F08FFAF68CFBF8339C5C1DA4352FCA5531C657046B
        0BFF00FFFF00FFFF00FFFF00FF0082C18ED7EB89FCFF70FBFF77FBFF77FBFF77
        FBFF81FCFF6CE1F20082C10082C10082C10082C10082C10082C1016C49189F2E
        29C44B20AA3A046B0BFF00FFFF00FFFF00FFFF00FFFF00FF0082C1E6FFFFAAFF
        FFAAFFFFAAFFFFAFFFFF86F2FA0082C1FF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FF046B0B18A42D22BA3E046B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FF0082C10082C10082C10082C10082C10082C1FF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FF046B0B16A929149D27046B0BFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
        FF00FFFF00FFFF00FFFF00FFFF00FF046B0B098E130D991C046B0BFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF
        00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B047E0A05810C046B0B
        FF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00
        FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF046B0B046B0B046B0B046B0B04
        6B0BFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF}
      OnClick = sSpeedButton3Click
      SkinData.SkinSection = 'TOOLBUTTON'
    end
    object sLabel21: TsLabel
      Tag = 2
      Left = 24
      Top = 61
      Width = 34
      Height = 13
      Caption = 'Width :'
      Enabled = False
    end
    object sLabel22: TsLabel
      Tag = 2
      Left = 21
      Top = 77
      Width = 37
      Height = 13
      Caption = 'Height :'
      Enabled = False
    end
    object sLabel23: TsLabel
      Tag = 2
      Left = 64
      Top = 61
      Width = 3
      Height = 13
      Caption = '-'
      Enabled = False
    end
    object sLabel24: TsLabel
      Tag = 2
      Left = 64
      Top = 77
      Width = 3
      Height = 13
      Caption = '-'
      Enabled = False
    end
  end
  object sGroupBox2: TsGroupBox
    Tag = 2
    Left = 326
    Top = 4
    Width = 175
    Height = 121
    Caption = ' Borders widths : '
    Enabled = False
    TabOrder = 2
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object sLabel14: TsLabel
      Tag = 2
      Left = 147
      Top = 72
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel19: TsLabel
      Tag = 2
      Left = 147
      Top = 96
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel2: TsLabel
      Tag = 2
      Left = 147
      Top = 24
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel9: TsLabel
      Tag = 2
      Left = 147
      Top = 48
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel26: TsLabel
      Tag = 2
      Left = 12
      Top = 24
      Width = 6
      Height = 13
      Caption = 'L'
      Enabled = False
    end
    object sLabel27: TsLabel
      Tag = 2
      Left = 12
      Top = 48
      Width = 7
      Height = 13
      Caption = 'T'
      Enabled = False
    end
    object sLabel28: TsLabel
      Tag = 2
      Left = 12
      Top = 72
      Width = 8
      Height = 13
      Caption = 'R'
      Enabled = False
    end
    object sLabel29: TsLabel
      Tag = 2
      Left = 12
      Top = 96
      Width = 7
      Height = 13
      Caption = 'B'
      Enabled = False
    end
    object sTrackBar1: TsTrackBar
      Tag = 2
      Left = 20
      Top = 17
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 0
      OnChange = sTrackBar1Change
      SkinData.SkinSection = 'TRACKBAR'
    end
    object sTrackBar4: TsTrackBar
      Tag = 2
      Left = 20
      Top = 41
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 1
      OnChange = sTrackBar4Change
      SkinData.SkinSection = 'TRACKBAR'
    end
    object sTrackBar6: TsTrackBar
      Tag = 2
      Left = 20
      Top = 65
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 2
      OnChange = sTrackBar6Change
      SkinData.SkinSection = 'TRACKBAR'
    end
    object sTrackBar8: TsTrackBar
      Tag = 2
      Left = 20
      Top = 89
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 3
      OnChange = sTrackBar8Change
      SkinData.SkinSection = 'TRACKBAR'
    end
  end
  object sGroupBox3: TsGroupBox
    Tag = 2
    Left = 326
    Top = 131
    Width = 175
    Height = 121
    Caption = ' Content margins : '
    Enabled = False
    TabOrder = 3
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object sLabel4: TsLabel
      Tag = 2
      Left = 147
      Top = 26
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel10: TsLabel
      Tag = 2
      Left = 147
      Top = 50
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel15: TsLabel
      Tag = 2
      Left = 147
      Top = 74
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel20: TsLabel
      Tag = 2
      Left = 147
      Top = 98
      Width = 6
      Height = 13
      Caption = '0'
      Enabled = False
    end
    object sLabel30: TsLabel
      Tag = 2
      Left = 12
      Top = 26
      Width = 6
      Height = 13
      Caption = 'L'
      Enabled = False
    end
    object sLabel31: TsLabel
      Tag = 2
      Left = 12
      Top = 50
      Width = 7
      Height = 13
      Caption = 'T'
      Enabled = False
    end
    object sLabel32: TsLabel
      Tag = 2
      Left = 12
      Top = 74
      Width = 8
      Height = 13
      Caption = 'R'
      Enabled = False
    end
    object sLabel33: TsLabel
      Tag = 2
      Left = 12
      Top = 98
      Width = 7
      Height = 13
      Caption = 'B'
      Enabled = False
    end
    object sTrackBar2: TsTrackBar
      Tag = 2
      Left = 20
      Top = 17
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 0
      OnChange = sTrackBar2Change
      SkinData.SkinSection = 'TRACKBAR'
    end
    object sTrackBar3: TsTrackBar
      Tag = 2
      Left = 20
      Top = 41
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 1
      OnChange = sTrackBar3Change
      SkinData.SkinSection = 'TRACKBAR'
    end
    object sTrackBar5: TsTrackBar
      Tag = 2
      Left = 20
      Top = 65
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 2
      OnChange = sTrackBar5Change
      SkinData.SkinSection = 'TRACKBAR'
    end
    object sTrackBar7: TsTrackBar
      Tag = 2
      Left = 20
      Top = 89
      Width = 126
      Height = 24
      Enabled = False
      TabOrder = 3
      OnChange = sTrackBar7Change
      SkinData.SkinSection = 'TRACKBAR'
    end
  end
  object sGroupBox4: TsGroupBox
    Tag = 2
    Left = 122
    Top = 258
    Width = 379
    Height = 99
    Caption = ' Draw mode : '
    Enabled = False
    TabOrder = 4
    CaptionLayout = clTopCenter
    SkinData.SkinSection = 'GROUPBOX'
    object sLabel34: TsLabel
      Tag = 2
      Left = 28
      Top = 20
      Width = 24
      Height = 13
      Caption = 'Left :'
      Enabled = False
    end
    object sLabel35: TsLabel
      Tag = 2
      Left = 99
      Top = 20
      Width = 25
      Height = 13
      Caption = 'Top :'
      Enabled = False
    end
    object sLabel36: TsLabel
      Tag = 2
      Left = 170
      Top = 20
      Width = 31
      Height = 13
      Caption = 'Right :'
      Enabled = False
    end
    object sLabel37: TsLabel
      Tag = 2
      Left = 241
      Top = 20
      Width = 39
      Height = 13
      Caption = 'Bottom :'
      Enabled = False
    end
    object sLabel38: TsLabel
      Tag = 2
      Left = 312
      Top = 20
      Width = 40
      Height = 13
      Caption = 'Center : '
      Enabled = False
    end
    object sGroupBox5: TsPanel
      Left = 7
      Top = 39
      Width = 72
      Height = 52
      BevelOuter = bvNone
      TabOrder = 0
      SkinData.SkinSection = 'CHECKBOX'
      object sRadioButton1: TsRadioButton
        Tag = 2
        Left = 4
        Top = 2
        Width = 55
        Height = 20
        Caption = 'Repeat'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton1Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object sRadioButton2: TsRadioButton
        Tag = 2
        Left = 4
        Top = 26
        Width = 54
        Height = 20
        Caption = 'Stretch'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton2Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
    object sGroupBox6: TsPanel
      Left = 79
      Top = 39
      Width = 72
      Height = 52
      BevelOuter = bvNone
      TabOrder = 1
      SkinData.SkinSection = 'CHECKBOX'
      object sRadioButton3: TsRadioButton
        Tag = 2
        Left = 4
        Top = 2
        Width = 55
        Height = 20
        Caption = 'Repeat'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton3Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object sRadioButton4: TsRadioButton
        Tag = 2
        Left = 4
        Top = 26
        Width = 54
        Height = 20
        Caption = 'Stretch'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton4Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
    object sPanel1: TsPanel
      Left = 151
      Top = 39
      Width = 72
      Height = 52
      BevelOuter = bvNone
      TabOrder = 2
      SkinData.SkinSection = 'CHECKBOX'
      object sRadioButton5: TsRadioButton
        Tag = 2
        Left = 4
        Top = 2
        Width = 55
        Height = 20
        Caption = 'Repeat'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton5Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object sRadioButton6: TsRadioButton
        Tag = 2
        Left = 4
        Top = 26
        Width = 54
        Height = 20
        Caption = 'Stretch'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton6Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
    object sPanel2: TsPanel
      Left = 223
      Top = 39
      Width = 72
      Height = 52
      BevelOuter = bvNone
      TabOrder = 3
      SkinData.SkinSection = 'CHECKBOX'
      object sRadioButton7: TsRadioButton
        Tag = 2
        Left = 4
        Top = 2
        Width = 55
        Height = 20
        Caption = 'Repeat'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton7Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object sRadioButton8: TsRadioButton
        Tag = 2
        Left = 4
        Top = 26
        Width = 54
        Height = 20
        Caption = 'Stretch'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton8Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
    object sPanel3: TsPanel
      Left = 295
      Top = 39
      Width = 72
      Height = 52
      BevelOuter = bvNone
      TabOrder = 4
      SkinData.SkinSection = 'CHECKBOX'
      object sRadioButton9: TsRadioButton
        Tag = 2
        Left = 4
        Top = 2
        Width = 55
        Height = 20
        Caption = 'Repeat'
        Checked = True
        Enabled = False
        TabOrder = 0
        TabStop = True
        OnClick = sRadioButton9Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
      object sRadioButton10: TsRadioButton
        Tag = 2
        Left = 4
        Top = 26
        Width = 54
        Height = 20
        Caption = 'Stretch'
        Enabled = False
        TabOrder = 1
        OnClick = sRadioButton10Click
        SkinData.SkinSection = 'RADIOBUTTON'
      end
    end
  end
  object sFrameAdapter1: TsFrameAdapter
    SkinData.SkinSection = 'CHECKBOX'
    Left = 12
    Top = 16
  end
  object OpenPictureDialog1: TOpenPictureDialog
    DefaultExt = '*.png'
    Filter = 'Portable network graphic (AlphaControls) (*.png)|*.png'
    Left = 12
    Top = 44
  end
end
