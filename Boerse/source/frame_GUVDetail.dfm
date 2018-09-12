object fra_GUVDetail: Tfra_GUVDetail
  Left = 0
  Top = 0
  Width = 623
  Height = 410
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 185
    Top = 0
    Height = 410
    ExplicitLeft = 224
    ExplicitTop = 56
    ExplicitHeight = 100
  end
  object pnl_Left: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 410
    Align = alLeft
    BevelOuter = bvNone
    Caption = 'pnl_Left'
    TabOrder = 0
    object ListBox1: TListBox
      Left = 0
      Top = 0
      Width = 185
      Height = 410
      Align = alClient
      ItemHeight = 13
      TabOrder = 0
      OnDblClick = ListBox1DblClick
    end
  end
  object pnl_Client: TPanel
    Left = 188
    Top = 0
    Width = 435
    Height = 410
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Grid: TDBGrid
      Left = 0
      Top = 41
      Width = 328
      Height = 369
      Align = alClient
      DataSource = ds_GUVDetail
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnDrawDataCell = GridDrawDataCell
    end
    object Panel1: TPanel
      Left = 328
      Top = 41
      Width = 107
      Height = 369
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object Label1: TLabel
        Left = 6
        Top = 0
        Width = 36
        Height = 13
        Caption = 'Gesamt'
      end
      object edt_Gesamt: TEdit
        Left = 6
        Top = 16
        Width = 97
        Height = 21
        TabStop = False
        ReadOnly = True
        TabOrder = 0
        Text = 'edt_Gesamt'
      end
    end
    object Panel2: TPanel
      Left = 0
      Top = 0
      Width = 435
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 2
      object Label2: TLabel
        Left = 16
        Top = 16
        Width = 18
        Height = 13
        Caption = 'Von'
      end
      object Label3: TLabel
        Left = 176
        Top = 14
        Width = 13
        Height = 13
        Caption = 'Bis'
      end
      object edt_Von: TDateTimePicker
        Left = 41
        Top = 12
        Width = 97
        Height = 21
        Date = 41411.349898935190000000
        Time = 41411.349898935190000000
        TabOrder = 0
      end
      object edt_Bis: TDateTimePicker
        Left = 195
        Top = 12
        Width = 97
        Height = 21
        Date = 41411.349898935190000000
        Time = 41411.349898935190000000
        TabOrder = 1
      end
    end
  end
  object qry_GUVDetail: TIBQuery
    Database = DM.IBD
    Transaction = ibt_GUVDetail
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 288
    Top = 184
  end
  object ibt_GUVDetail: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 320
    Top = 88
  end
  object ds_GUVDetail: TDataSource
    DataSet = qry_GUVDetail
    Left = 424
    Top = 248
  end
  object qry_GUVDetailGesamt: TIBQuery
    Database = DM.IBD
    Transaction = ibt_GUVGesamt
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 312
    Top = 280
  end
  object ibt_GUVGesamt: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 432
    Top = 88
  end
end
