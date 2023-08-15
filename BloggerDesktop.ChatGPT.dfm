object Frame1: TFrame1
  Left = 0
  Top = 0
  Width = 639
  Height = 717
  TabOrder = 0
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 639
    Height = 233
    Align = alTop
    Caption = 'Selected Text (to replace)'
    TabOrder = 0
    object Memo1: TMemo
      Left = 2
      Top = 17
      Width = 635
      Height = 214
      Align = alClient
      Lines.Strings = (
        'Memo1')
      TabOrder = 0
    end
  end
  object GroupBox2: TGroupBox
    Left = 0
    Top = 490
    Width = 639
    Height = 184
    Align = alBottom
    Caption = 'GroupBox2'
    TabOrder = 1
    object Memo2: TMemo
      Left = 2
      Top = 17
      Width = 635
      Height = 165
      Align = alClient
      Lines.Strings = (
        'Memo2')
      TabOrder = 0
    end
  end
  object GroupBox4: TGroupBox
    Left = 0
    Top = 233
    Width = 639
    Height = 257
    Align = alClient
    Caption = 'GroupBox3'
    TabOrder = 2
    object hChat2: ThChat
      Left = 2
      Top = 17
      Width = 635
      Height = 238
      Align = alClient
      Color = 2103055
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 674
    Width = 639
    Height = 43
    Align = alBottom
    Caption = 'Actions'
    TabOrder = 3
    DesignSize = (
      639
      43)
    object Button1: TButton
      Left = 16
      Top = 6
      Width = 75
      Height = 25
      Caption = '< Paste'
      TabOrder = 0
    end
    object Button2: TButton
      Left = 512
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'Query'
      TabOrder = 1
    end
  end
end
