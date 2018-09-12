object DM: TDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 209
  Width = 306
  object IBD: TIBDatabase
    DatabaseName = 'c:\Users\TomBa\OneDrive\AppData\B'#246'rse\\boerse30.fdb'
    Params.Strings = (
      'user_name=sysdba'
      'password=masterkey')
    LoginPrompt = False
    ServerType = 'IBServer'
    Left = 80
    Top = 40
  end
  object IBT: TIBTransaction
    DefaultDatabase = IBD
    Left = 208
    Top = 40
  end
end
