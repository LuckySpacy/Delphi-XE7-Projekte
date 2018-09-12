object fra_Konf: Tfra_Konf
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    ActivePage = tbs_Datenbank
    Align = alClient
    TabOrder = 0
    object tbs_Datenbank: TTabSheet
      Caption = 'Datenbank'
    end
    object tbs_CsvPfad: TTabSheet
      Caption = 'CSVPfad'
      ImageIndex = 1
    end
  end
end
