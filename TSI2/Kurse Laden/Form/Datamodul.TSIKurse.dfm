object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 273
  Width = 413
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
end
