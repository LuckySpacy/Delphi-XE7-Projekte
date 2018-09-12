object fra_Kurse: Tfra_Kurse
  Left = 0
  Top = 0
  Width = 874
  Height = 519
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 874
    Height = 41
    Align = alTop
    BevelOuter = bvNone
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
    object cbo_Boersenindex: TComboBox
      Left = 81
      Top = 11
      Width = 160
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbo_BoersenindexChange
    end
  end
  object lsb_Aktie: TListBox
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 177
    Height = 472
    Align = alLeft
    ItemHeight = 13
    TabOrder = 1
    OnClick = lsb_AktieClick
    OnDblClick = lsb_AktieDblClick
  end
  object PageControl1: TPageControl
    Left = 183
    Top = 41
    Width = 691
    Height = 478
    ActivePage = tbs_Chart_Zeitraum
    Align = alClient
    TabOrder = 2
    object tbs_Kursliste: TTabSheet
      Caption = 'Kursliste'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbs_Chart_Zeitraum: TTabSheet
      Caption = 'Chart'
      ImageIndex = 1
    end
    object tbs_TSIChart: TTabSheet
      Caption = 'TSI-Chart'
      ImageIndex = 2
    end
  end
end
