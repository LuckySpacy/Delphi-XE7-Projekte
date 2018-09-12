object fra_Aktie: Tfra_Aktie
  Left = 0
  Top = 0
  Width = 1065
  Height = 240
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1065
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Börsenindex: TLabel
      Left = 16
      Top = 14
      Width = 59
      Height = 13
      Caption = 'B'#246'rsenindex'
    end
    object Label1: TLabel
      Left = 256
      Top = 14
      Width = 43
      Height = 13
      Caption = 'Wochen:'
    end
    object Label2: TLabel
      Left = 355
      Top = 14
      Width = 89
      Height = 13
      Caption = 'Letztes Kursdatum'
    end
    object cbo_Boersenindex: TComboBox
      Left = 81
      Top = 11
      Width = 160
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbo_BoersenindexChange
    end
    object edt_Wochen: TSpinEdit
      Left = 305
      Top = 11
      Width = 40
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object edt_LetztesKursdatum: TDateTimePicker
      Left = 452
      Top = 11
      Width = 82
      Height = 21
      Date = 43047.838043460650000000
      Time = 43047.838043460650000000
      Enabled = False
      TabOrder = 2
    end
    object cbx_LetztesKursdatum: TCheckBox
      Left = 540
      Top = 13
      Width = 149
      Height = 17
      Caption = 'Letztes Kursdatum '#228'ndern'
      TabOrder = 3
      OnClick = cbx_LetztesKursdatumClick
    end
    object btn_Aktualisieren: TButton
      Left = 688
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Aktualisieren'
      TabOrder = 4
    end
    object btn_AktuellTSI: TButton
      Left = 769
      Top = 10
      Width = 136
      Height = 25
      Caption = 'Aktuelle TSI-Werte laden'
      TabOrder = 5
      OnClick = btn_AktuellTSIClick
    end
    object btn_AlleTSI: TButton
      Left = 911
      Top = 10
      Width = 136
      Height = 25
      Caption = 'Alle TSI-Werte laden'
      TabOrder = 6
      OnClick = btn_AlleTSIClick
    end
  end
  object grd: TtbStringGrid
    Left = 0
    Top = 41
    Width = 1065
    Height = 199
    Align = alClient
    ColCount = 4
    DefaultRowHeight = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowClick]
    PopupMenu = pop
    TabOrder = 1
    OnDrawCell = grdDrawCell
    AutosizeCol = -1
    AutosizeColMinWidth = 3
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
  end
  object pop: TPopupMenu
    OnPopup = popPopup
    Left = 528
    Top = 104
    object mnu_Depot: TMenuItem
      Caption = 'Depot'
      OnClick = mnu_DepotClick
    end
  end
end
