inherited fra_Seite: Tfra_Seite
  Width = 526
  Height = 422
  ExplicitWidth = 526
  ExplicitHeight = 422
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 526
    Height = 422
    ActivePage = tbs_Seite
    Align = alClient
    TabOrder = 0
    object tbs_Seite: TTabSheet
      Caption = 'Seite'
    end
    object tbs_Dokument: TTabSheet
      Caption = 'Dokumente'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object tbs_Einstellung: TTabSheet
      Caption = 'Einstellung'
      ImageIndex = 2
    end
  end
end
