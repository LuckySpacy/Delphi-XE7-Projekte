object DM: TDM
  OldCreateOrder = False
  Height = 185
  Width = 366
  object IBD_OptimaChangeLog: TIBDatabase
    DatabaseName = 'C:\Bachmann\Delphi\Delphi XE7\Projekte\Web\OPTIMACHANGELOG.FDB'
    Params.Strings = (
      'password=masterkey'
      'user_name=sysdba')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 48
    Top = 32
  end
  object IBT_OptimaChangeLog: TIBTransaction
    DefaultDatabase = IBD_OptimaChangeLog
    Left = 144
    Top = 32
  end
  object qry_OptimaChangeLog: TIBQuery
    Database = IBD_OptimaChangeLog
    Transaction = IBT_OptimaChangeLog
    BufferChunks = 1000
    CachedUpdates = False
    ParamCheck = True
    Left = 248
    Top = 60
  end
end
