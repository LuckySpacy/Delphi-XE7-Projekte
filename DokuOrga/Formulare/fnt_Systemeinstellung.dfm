object frm_Systemeinstellung: Tfrm_Systemeinstellung
  Left = 0
  Top = 0
  Caption = 'Systemeinstellung'
  ClientHeight = 434
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lsb_Einstellung: TListBox
    Left = 0
    Top = 0
    Width = 145
    Height = 434
    Align = alLeft
    ItemHeight = 13
    TabOrder = 0
  end
  object pnl_Client: TPanel
    Left = 145
    Top = 0
    Width = 382
    Height = 434
    Align = alClient
    Caption = 'pnl_Client'
    ShowCaption = False
    TabOrder = 1
  end
end
