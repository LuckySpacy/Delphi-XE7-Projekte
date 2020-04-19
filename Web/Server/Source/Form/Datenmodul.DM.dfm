object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 398
  Width = 615
  object IBD_OptimaChangeLog: TIBDatabase
    DatabaseName = 'C:\Bachmann\Delphi\Delphi XE7\Projekte\Web\OPTIMACHANGELOG.FDB'
    Params.Strings = (
      'password=masterkey'
      'user_name=sysdba')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 48
    Top = 16
  end
  object IBT_OptimaChangeLog: TIBTransaction
    DefaultDatabase = IBD_OptimaChangeLog
    Left = 176
    Top = 16
  end
  object qry_OptimaChangeLog: TIBQuery
    Database = IBD_OptimaChangeLog
    Transaction = IBT_OptimaChangeLog
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 472
    Top = 100
  end
  object qry_Tabellenfeld: TIBQuery
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 328
    Top = 24
  end
  object IBT_Tabellenfeld: TIBTransaction
    DefaultDatabase = IBD_OptimaChangeLog
    Left = 448
    Top = 24
  end
  object IBD_DokuOrga: TIBDatabase
    DatabaseName = 'C:\Bachmann\Delphi\Delphi XE7\Projekte\Web\OPTIMACHANGELOG.FDB'
    Params.Strings = (
      'password=masterkey'
      'user_name=sysdba')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 40
    Top = 224
  end
  object IBT_DokuOrga: TIBTransaction
    DefaultDatabase = IBD_DokuOrga
    Left = 136
    Top = 224
  end
  object qry_DokuOrga: TIBQuery
    Database = IBD_DokuOrga
    Transaction = IBT_DokuOrga
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 216
    Top = 228
  end
end
