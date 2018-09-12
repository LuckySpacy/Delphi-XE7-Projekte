object fra_Transfer: Tfra_Transfer
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object Label1: TLabel
    Left = 24
    Top = 72
    Width = 31
    Height = 13
    Caption = 'Datum'
  end
  object Label2: TLabel
    Left = 24
    Top = 101
    Width = 26
    Height = 13
    Caption = 'St'#252'ck'
  end
  object Label3: TLabel
    Left = 24
    Top = 153
    Width = 21
    Height = 13
    Caption = 'Kurs'
    Visible = False
  end
  object Label7: TLabel
    Left = 21
    Top = 126
    Width = 24
    Height = 13
    Caption = 'Wert'
  end
  object Label4: TLabel
    Left = 29
    Top = 45
    Width = 24
    Height = 13
    Caption = 'Aktie'
  end
  object Label5: TLabel
    Left = 29
    Top = 20
    Width = 30
    Height = 13
    Caption = 'Aktion'
  end
  object edt_Datum: TDateTimePicker
    Left = 66
    Top = 69
    Width = 97
    Height = 21
    Date = 41408.706545219910000000
    Time = 41408.706545219910000000
    TabOrder = 0
  end
  object edt_Stueck: TSpinEdit
    Left = 66
    Top = 96
    Width = 97
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object edt_Wert: TEdit
    Left = 66
    Top = 124
    Width = 121
    Height = 21
    TabOrder = 2
    Text = 'edt_Wert'
  end
  object edt_Kurs: TEdit
    Left = 66
    Top = 151
    Width = 121
    Height = 21
    ReadOnly = True
    TabOrder = 3
    Text = 'edt_Wert'
    Visible = False
  end
  object cbx_Aktie: TComboBox
    Left = 66
    Top = 42
    Width = 244
    Height = 21
    Style = csDropDownList
    TabOrder = 4
  end
  object cbx_Aktion: TComboBox
    Left = 66
    Top = 15
    Width = 244
    Height = 21
    Style = csDropDownList
    TabOrder = 5
    OnChange = cbx_AktionChange
  end
end
