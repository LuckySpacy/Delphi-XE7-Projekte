object fra_Bilanz: Tfra_Bilanz
  Left = 0
  Top = 0
  Width = 701
  Height = 452
  TabOrder = 0
  object pnl_top: TPanel
    Left = 0
    Top = 0
    Width = 701
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitWidth = 513
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 42
      Height = 13
      Caption = 'Von Jahr'
    end
    object Label2: TLabel
      Left = 158
      Top = 14
      Width = 37
      Height = 13
      Caption = 'Bis Jahr'
    end
    object edt_VonJahr: TSpinEdit
      Left = 72
      Top = 13
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 0
      Value = 0
    end
    object edt_BisJahr: TSpinEdit
      Left = 201
      Top = 13
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 1
      Value = 0
    end
    object cmd_Actual: TButton
      Left = 279
      Top = 11
      Width = 75
      Height = 25
      Caption = 'Aktualisieren'
      TabOrder = 2
      OnClick = cmd_ActualClick
    end
    object chb_Zusammen: TCheckBox
      Left = 360
      Top = 17
      Width = 113
      Height = 17
      Caption = 'Zusammengefa'#223't'
      TabOrder = 3
    end
  end
  object pnl_Client: TPanel
    Left = 0
    Top = 41
    Width = 563
    Height = 411
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 375
    ExplicitHeight = 387
    object Grid: TDBGrid
      Left = 0
      Top = 0
      Width = 563
      Height = 411
      Align = alClient
      DataSource = ds_Bilanz
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawDataCell = GridDrawDataCell
      OnTitleClick = GridTitleClick
    end
  end
  object pnl_Right: TPanel
    Left = 563
    Top = 41
    Width = 138
    Height = 411
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 375
    ExplicitHeight = 387
    object Label3: TLabel
      Left = 6
      Top = 99
      Width = 36
      Height = 13
      Caption = 'Gesamt'
    end
    object Label4: TLabel
      Left = 6
      Top = 0
      Width = 72
      Height = 13
      Caption = 'Summe Gewinn'
    end
    object Label5: TLabel
      Left = 6
      Top = 51
      Width = 70
      Height = 13
      Caption = 'Summe Verlust'
    end
    object Label6: TLabel
      Left = 6
      Top = 147
      Width = 76
      Height = 13
      Caption = 'Gesamt Prozent'
    end
    object Label7: TLabel
      Left = 6
      Top = 240
      Width = 99
      Height = 13
      Caption = 'Summe Einkaufswert'
    end
    object Label8: TLabel
      Left = 6
      Top = 296
      Width = 101
      Height = 13
      Caption = 'Summe Verkaufswert'
    end
    object edt_Gesamt: TEdit
      Left = 6
      Top = 116
      Width = 121
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
      Text = 'edt_Gesamt'
    end
    object edt_Gewinnsumme: TEdit
      Left = 6
      Top = 19
      Width = 97
      Height = 21
      TabOrder = 1
      Text = 'edt_Summe'
    end
    object edt_Verlustsumme: TEdit
      Left = 6
      Top = 69
      Width = 97
      Height = 21
      TabOrder = 2
      Text = 'edt_Summe'
    end
    object edt_GesamtProzent: TEdit
      Left = 6
      Top = 165
      Width = 121
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 3
      Text = 'edt_Gesamt'
    end
    object edt_SummeEK: TEdit
      Left = 6
      Top = 259
      Width = 97
      Height = 21
      TabOrder = 4
      Text = 'edt_Summe'
    end
    object edt_SummeVK: TEdit
      Left = 6
      Top = 315
      Width = 97
      Height = 21
      TabOrder = 5
      Text = 'edt_Summe'
    end
  end
  object qry_Bilanz: TIBQuery
    Database = DM.IBD
    Transaction = ibt_Bilanz
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 240
    Top = 160
  end
  object ibt_Bilanz: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 304
    Top = 112
  end
  object ds_Bilanz: TDataSource
    DataSet = qry_Bilanz
    Left = 144
    Top = 224
  end
  object qry_BilanzSumme: TIBQuery
    Database = DM.IBD
    Transaction = ibt_Bilanzsumme
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 272
    Top = 248
  end
  object ibt_Bilanzsumme: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 320
    Top = 192
  end
end
