object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 426
  Width = 577
  object IBDatabase: TIBDatabase
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    SQLDialect = 1
    Left = 88
    Top = 16
  end
  object ds_IB: TDataSource
    DataSet = IBQuery
    Left = 16
    Top = 8
  end
  object IBTransaction: TIBTransaction
    DefaultDatabase = IBDatabase
    Left = 32
    Top = 80
  end
  object IBQuery: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select * from kunden')
    Left = 88
    Top = 72
  end
  object IBQuery2: TIBQuery
    Database = IBDatabase
    Transaction = IBTransaction
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    SQL.Strings = (
      'select * from kunden')
    Left = 96
    Top = 120
  end
  object ADOConnect: TADOConnection
    LoginPrompt = False
    Left = 144
    Top = 32
  end
  object ds_Ado: TDataSource
    DataSet = ADOQuery
    Left = 192
    Top = 80
  end
  object ADOQuery: TADOQuery
    Connection = ADOConnect
    Parameters = <>
    Left = 192
    Top = 136
  end
  object MySqlConnect: TMySQLDatabase
    DatabaseName = 'krediterstattung'
    UserName = 'krediterstattung'
    UserPassword = 'kredit99erstattung'
    Host = 'tickets.new-frontiers.de'
    ConnectOptions = [coCompress]
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30'
      'Host=tickets.new-frontiers.de'
      'UID=krediterstattung'
      'PWD=kredit99erstattung'
      'DatabaseName=krediterstattung')
    DatasetOptions = []
    Left = 40
    Top = 192
  end
  object mySQLQuery: TMySQLQuery
    Database = MySqlConnect
    SQL.Strings = (
      'select * from kanzleien')
    Left = 136
    Top = 200
  end
  object ds_mysql: TDataSource
    DataSet = mySQLQuery
    Left = 184
    Top = 272
  end
end
