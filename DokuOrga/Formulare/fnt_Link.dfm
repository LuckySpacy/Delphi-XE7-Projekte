object frm_Link: Tfrm_Link
  Left = 0
  Top = 0
  Caption = 'Seite oder Dateien verlinken'
  ClientHeight = 526
  ClientWidth = 660
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Left: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 526
    Align = alLeft
    Caption = 'pnl_Left'
    ShowCaption = False
    TabOrder = 0
  end
  object pnl_client: TPanel
    Left = 185
    Top = 0
    Width = 475
    Height = 526
    Align = alClient
    Caption = 'pnl_Left'
    ShowCaption = False
    TabOrder = 1
  end
end
