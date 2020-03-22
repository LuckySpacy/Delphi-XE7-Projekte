object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 202
  Width = 215
  object Database: TIBDatabase
    DefaultTransaction = IBT
    ServerType = 'IBServer'
    Left = 40
    Top = 16
  end
  object IBT: TIBTransaction
    Left = 112
    Top = 16
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
    DatasetOptions = []
    Left = 40
    Top = 118
  end
end
