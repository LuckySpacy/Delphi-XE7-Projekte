object frm_SyntaxHighlighterEdit: Tfrm_SyntaxHighlighterEdit
  Left = 0
  Top = 0
  Caption = 'frm_SyntaxHighlighterEdit'
  ClientHeight = 418
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 25
    Width = 37
    Height = 13
    Caption = 'Label1'
  end
  object edt: TEdit
    Left = 24
    Top = 44
    Width = 345
    Height = 21
    TabOrder = 0
    Text = 'edt'
  end
  object grb_Font: TGroupBox
    Left = 24
    Top = 88
    Width = 345
    Height = 145
    Caption = 'Font'
    TabOrder = 1
    object Label2: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Name:'
    end
    object Label3: TLabel
      Left = 16
      Top = 49
      Width = 40
      Height = 13
      Caption = 'Gr'#246#223'e:'
    end
    object Label4: TLabel
      Left = 16
      Top = 113
      Width = 36
      Height = 13
      Caption = 'Farbe:'
    end
    object cbx_Bold: TCheckBox
      Left = 16
      Top = 79
      Width = 40
      Height = 17
      Caption = 'Fett'
      TabOrder = 0
    end
    object cbx_Italic: TCheckBox
      Left = 62
      Top = 79
      Width = 51
      Height = 17
      Caption = 'Kursiv'
      TabOrder = 1
    end
    object cbx_Underline: TCheckBox
      Left = 119
      Top = 79
      Width = 98
      Height = 17
      Caption = 'Unterstrichen'
      TabOrder = 2
    end
    object cbx_StrikeOut: TCheckBox
      Left = 223
      Top = 79
      Width = 119
      Height = 17
      Caption = 'Durchgestrichen'
      TabOrder = 3
    end
    object edt_Size: TSpinEdit
      Left = 62
      Top = 46
      Width = 51
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
    object cbo_Font: TComboBox
      Left = 60
      Top = 21
      Width = 269
      Height = 21
      Style = csDropDownList
      TabOrder = 5
    end
    object cbo_Farbe: TColorBox
      Left = 62
      Top = 108
      Width = 129
      Height = 22
      Style = [cbStandardColors, cbExtendedColors, cbSystemColors, cbPrettyNames]
      TabOrder = 6
    end
  end
  object grb_Ausrichtung: TGroupBox
    Left = 24
    Top = 255
    Width = 342
    Height = 66
    Caption = 'Ausrichtung'
    TabOrder = 2
    object rb_Links: TRadioButton
      Left = 16
      Top = 25
      Width = 49
      Height = 17
      Caption = 'Links'
      TabOrder = 0
    end
    object rb_Zentriert: TRadioButton
      Left = 71
      Top = 25
      Width = 74
      Height = 17
      Caption = 'Zentriert'
      TabOrder = 1
    end
    object rb_Rechts: TRadioButton
      Left = 151
      Top = 25
      Width = 74
      Height = 17
      Caption = 'Rechts'
      TabOrder = 2
    end
  end
  object cbx_OhneWortende: TCheckBox
    Left = 40
    Top = 336
    Width = 175
    Height = 17
    Caption = 'Wortende nicht beachten'
    TabOrder = 3
  end
  object btn_Abbruch: TButton
    Left = 210
    Top = 373
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    TabOrder = 4
    OnClick = btn_AbbruchClick
  end
  object btn_Ok: TButton
    Left = 291
    Top = 373
    Width = 75
    Height = 25
    Caption = 'Ok'
    TabOrder = 5
    OnClick = btn_OkClick
  end
end
