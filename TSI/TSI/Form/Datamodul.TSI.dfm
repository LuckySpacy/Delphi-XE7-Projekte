object dm: Tdm
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
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
end
