object fra_Aktie: Tfra_Aktie
  Left = 0
  Top = 0
  Width = 556
  Height = 282
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 556
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 515
    object Börsenindex: TLabel
      Left = 176
      Top = 14
      Width = 59
      Height = 13
      Caption = 'B'#246'rsenindex'
    end
    object btn_Neu: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Neu'
      TabOrder = 0
      OnClick = btn_NeuClick
    end
    object btn_Loeschen: TButton
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Caption = 'L'#246'schen'
      TabOrder = 1
      OnClick = btn_LoeschenClick
    end
    object cbo_Boersenindex: TComboBox
      Left = 241
      Top = 11
      Width = 160
      Height = 21
      Style = csDropDownList
      TabOrder = 2
      OnChange = cbo_BoersenindexChange
    end
    object btn_BINeu: TButton
      Left = 406
      Top = 9
      Width = 35
      Height = 25
      Caption = 'Neu'
      TabOrder = 3
      OnClick = btn_BINeuClick
    end
    object btn_BIAendern: TButton
      Left = 443
      Top = 9
      Width = 47
      Height = 25
      Caption = #196'ndern'
      TabOrder = 4
      OnClick = btn_BIAendernClick
    end
    object btn_BiLoeschen: TButton
      Left = 491
      Top = 9
      Width = 45
      Height = 25
      Caption = 'L'#246'schen'
      TabOrder = 5
      OnClick = btn_BiLoeschenClick
    end
  end
  object grd: TtbStringGrid
    Left = 0
    Top = 41
    Width = 556
    Height = 241
    Align = alClient
    ColCount = 4
    DefaultRowHeight = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowClick]
    TabOrder = 1
    AutosizeCol = -1
    AutosizeColMinWidth = 3
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
    OnCellDblClick = grdCellDblClick
    ExplicitWidth = 515
  end
end
