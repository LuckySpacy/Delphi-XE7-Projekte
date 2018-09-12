object frm_Boerse: Tfrm_Boerse
  Left = 0
  Top = 0
  Caption = 'B'
  ClientHeight = 366
  ClientWidth = 709
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Button: TPanel
    Left = 0
    Top = 0
    Width = 709
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object cmd_NewAktie: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 41
      Action = act_NeuAktie
      Caption = 'Anlegen'
      TabOrder = 0
    end
    object Button1: TButton
      Left = 72
      Top = 0
      Width = 75
      Height = 41
      Action = act_Transfer
      TabOrder = 1
    end
    object Button2: TButton
      Left = 144
      Top = 0
      Width = 75
      Height = 41
      Action = act_Bestand
      TabOrder = 2
    end
    object Button3: TButton
      Left = 216
      Top = 0
      Width = 75
      Height = 41
      Action = act_Transferlist
      TabOrder = 3
    end
    object Button4: TButton
      Left = 288
      Top = 0
      Width = 75
      Height = 41
      Action = act_GUVDetail
      TabOrder = 4
    end
    object Button5: TButton
      Left = 360
      Top = 0
      Width = 75
      Height = 41
      Action = act_Bilanz
      TabOrder = 5
    end
  end
  object pnl_Client: TPanel
    Left = 0
    Top = 41
    Width = 709
    Height = 325
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
  end
  object ActionList: TActionList
    Left = 352
    Top = 80
    object act_NeuAktie: TAction
      Caption = 'Neue Aktie anlegen'
      OnExecute = act_NeuAktieExecute
    end
    object act_Transfer: TAction
      Caption = 'Transfer'
      OnExecute = act_TransferExecute
    end
    object act_Bestand: TAction
      Caption = 'Bestand'
      OnExecute = act_BestandExecute
    end
    object act_Transferlist: TAction
      Caption = 'Translist'
      OnExecute = act_TransferlistExecute
    end
    object act_GUVDetail: TAction
      Caption = 'GUV Detail'
      OnExecute = act_GUVDetailExecute
    end
    object act_Bilanz: TAction
      Caption = 'Bilanz'
      OnExecute = act_BilanzExecute
    end
  end
end
