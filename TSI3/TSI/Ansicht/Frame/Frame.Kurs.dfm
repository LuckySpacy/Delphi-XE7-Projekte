object fra_Kurs: Tfra_Kurs
  Left = 0
  Top = 0
  Width = 609
  Height = 530
  TabOrder = 0
  object pnl_Aktie: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 530
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_Aktie'
    ShowCaption = False
    TabOrder = 0
  end
  object pnl_Client: TPanel
    Left = 185
    Top = 0
    Width = 424
    Height = 530
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl_Aktie'
    ShowCaption = False
    TabOrder = 1
    ExplicitLeft = 191
    object Splitter1: TSplitter
      Left = 0
      Top = 391
      Width = 424
      Height = 3
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 136
      ExplicitWidth = 258
    end
    object pnl_TSI: TPanel
      Left = 0
      Top = 394
      Width = 424
      Height = 136
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'pnl_Aktie'
      ShowCaption = False
      TabOrder = 0
    end
    object pnl_Kurs: TPanel
      Left = 0
      Top = 0
      Width = 424
      Height = 391
      Align = alClient
      BevelOuter = bvNone
      Caption = 'pnl_Aktie'
      ShowCaption = False
      TabOrder = 1
    end
  end
end
