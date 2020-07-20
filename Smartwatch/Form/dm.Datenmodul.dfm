object dam: Tdam
  OldCreateOrder = False
  Height = 150
  Width = 215
  object db: TMySQLDatabase
    ConnectOptions = [coCompress]
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30')
    DatasetOptions = []
    Left = 40
    Top = 24
  end
  object qry: TMySQLQuery
    Database = db
    Left = 96
    Top = 32
  end
  object ds: TDataSource
    DataSet = qry
    Left = 72
    Top = 80
  end
end
