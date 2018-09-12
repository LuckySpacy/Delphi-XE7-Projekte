object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 278
  Width = 392
  object DatabaseKurse: TIBDatabase
    DefaultTransaction = IBTKursex
    ServerType = 'IBServer'
    Left = 40
    Top = 16
  end
  object IBTKursex: TIBTransaction
    DefaultDatabase = DatabaseKurse
    Left = 112
    Top = 16
  end
  object DatabaseTSI: TIBDatabase
    DefaultTransaction = IBTKursex
    ServerType = 'IBServer'
    Left = 40
    Top = 88
  end
  object IBTTSI: TIBTransaction
    DefaultDatabase = DatabaseTSI
    Left = 120
    Top = 88
  end
  object DBMySqlTSI: TMySQLDatabase
    DatabaseName = 'tsi'
    UserName = 'thomas'
    UserPassword = 'thomas1'
    Host = 'localhost'
    ConnectOptions = [coCompress]
    Params.Strings = (
      'Port=3306'
      'TIMEOUT=30'
      'DatabaseName=tsi'
      'Host=localhost'
      'UID=thomas'
      'PWD=thomas1')
    OnConnectionFailure = DBMySqlTSIConnectionFailure
    DatasetOptions = []
    Left = 40
    Top = 160
  end
  object IBQuery1: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 264
    Top = 112
  end
end
