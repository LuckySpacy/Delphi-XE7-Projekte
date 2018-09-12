object fra_Bestand: Tfra_Bestand
  Left = 0
  Top = 0
  Width = 498
  Height = 291
  TabOrder = 0
  object Grid: TDBGrid
    Left = 0
    Top = 0
    Width = 392
    Height = 291
    Align = alClient
    DataSource = ds_Bestand
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object pnl_Right: TPanel
    Left = 392
    Top = 0
    Width = 106
    Height = 291
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 398
    object Label1: TLabel
      Left = 6
      Top = 6
      Width = 58
      Height = 13
      Caption = 'Gesamtwert'
    end
    object edt_Summe: TEdit
      Left = 6
      Top = 25
      Width = 97
      Height = 21
      TabOrder = 0
      Text = 'edt_Summe'
    end
  end
  object ds_Bestand: TDataSource
    DataSet = qry_Bestand
    Left = 336
    Top = 40
  end
  object ibt_Bestand: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 288
    Top = 16
  end
  object qry_Bestand: TIBQuery
    Database = DM.IBD
    Transaction = ibt_Bestand
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 224
    Top = 64
  end
  object qry_Summe: TIBQuery
    Database = DM.IBD
    Transaction = ibt_summe
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 256
    Top = 152
  end
  object ibt_summe: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 312
    Top = 128
  end
end
