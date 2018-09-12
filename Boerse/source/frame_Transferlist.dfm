object fra_Transferlist: Tfra_Transferlist
  Left = 0
  Top = 0
  Width = 759
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
    TabOrder = 0
    ExplicitHeight = 240
    object ListBox1: TListBox
      Left = 0
      Top = 0
      Width = 185
      Height = 410
      Align = alClient
      ItemHeight = 13
      PopupMenu = Popup_Aktie
      TabOrder = 0
      OnDblClick = ListBox1DblClick
      ExplicitHeight = 240
    end
  end
  object pnl_Client: TPanel
    Left = 188
    Top = 0
    Width = 571
    Height = 410
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitWidth = 394
    ExplicitHeight = 240
    object Splitter2: TSplitter
      Left = 0
      Top = 177
      Width = 571
      Height = 3
      Cursor = crVSplit
      Align = alTop
      ExplicitTop = 41
      ExplicitWidth = 199
    end
    object pnl_Top: TPanel
      Left = 0
      Top = 0
      Width = 571
      Height = 177
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_Top'
      TabOrder = 0
      ExplicitWidth = 394
      object Grid_Kauf: TDBGrid
        Left = 0
        Top = 17
        Width = 571
        Height = 160
        Align = alClient
        DataSource = ds_Kauf
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        PopupMenu = Popup_Kauf
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawDataCell = Grid_KaufDrawDataCell
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 571
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Kauf'
        TabOrder = 1
        ExplicitWidth = 394
      end
    end
    object pnl_Bottom: TPanel
      Left = 0
      Top = 180
      Width = 571
      Height = 230
      Align = alClient
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      ExplicitWidth = 394
      ExplicitHeight = 60
      object Grid_Verkauf: TDBGrid
        Left = 0
        Top = 17
        Width = 571
        Height = 213
        Align = alClient
        DataSource = ds_Verkauf
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        PopupMenu = PopupVekauf
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawDataCell = Grid_VerkaufDrawDataCell
      end
      object Panel2: TPanel
        Left = 0
        Top = 0
        Width = 571
        Height = 17
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Verkauf'
        TabOrder = 1
        ExplicitWidth = 394
      end
    end
  end
  object qry_Kauf: TIBQuery
    Database = DM.IBD
    Transaction = ibt_Kauf
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 224
    Top = 64
  end
  object qry_Verkauf: TIBQuery
    Database = DM.IBD
    Transaction = ibt_Verkauf
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'V'#39)
    Left = 368
    Top = 96
  end
  object ds_Kauf: TDataSource
    DataSet = qry_Kauf
    Left = 336
    Top = 40
  end
  object ds_Verkauf: TDataSource
    DataSet = qry_Verkauf
    Left = 440
    Top = 64
  end
  object Popup_Kauf: TPopupMenu
    Left = 288
    Top = 184
    object mnu_Gutschrift: TMenuItem
      Caption = 'Gutschrift'
      OnClick = mnu_GutschriftClick
    end
    object mnu_Splitt: TMenuItem
      Caption = 'Splitt'
      OnClick = mnu_SplittClick
    end
    object mnu_DeleteKauf: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = mnu_DeleteKaufClick
    end
  end
  object ibt_Kauf: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 288
    Top = 16
  end
  object ibt_Verkauf: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 432
    Top = 8
  end
  object ibt_Delete: TIBTransaction
    DefaultDatabase = DM.IBD
    Left = 304
    Top = 56
  end
  object qry_delete: TIBQuery
    Database = DM.IBD
    Transaction = ibt_Delete
    SQL.Strings = (
      'select * from transfer'
      'where tr_aktion = '#39'K'#39)
    Left = 256
    Top = 96
  end
  object PopupVekauf: TPopupMenu
    Left = 408
    Top = 176
    object mnu_DeleteVerkauf: TMenuItem
      Caption = 'L'#246'schen'
      OnClick = mnu_DeleteVerkaufClick
    end
  end
  object Popup_Aktie: TPopupMenu
    Left = 312
    Top = 136
    object mnu_calc: TMenuItem
      Caption = 'Neu kalkulieren'
      OnClick = mnu_calcClick
    end
    object KalkJahrMonatBilanz: TMenuItem
      Caption = 'Kalk Jahr Monat Bilanz'
      OnClick = KalkJahrMonatBilanzClick
    end
  end
end
