object frm_TSIWerteLaden: Tfrm_TSIWerteLaden
  Left = 0
  Top = 0
  Caption = 'TSI-Werte Laden'
  ClientHeight = 117
  ClientWidth = 314
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
  object Label1: TLabel
    Left = 32
    Top = 32
    Width = 28
    Height = 13
    Caption = 'Aktie:'
  end
  object Label2: TLabel
    Left = 32
    Top = 52
    Width = 35
    Height = 13
    Caption = 'Datum:'
  end
  object lbl_Aktie: TLabel
    Left = 88
    Top = 32
    Width = 28
    Height = 13
    Caption = 'Aktie:'
  end
  object lbl_Datum: TLabel
    Left = 88
    Top = 52
    Width = 28
    Height = 13
    Caption = 'Aktie:'
  end
  object Label3: TLabel
    Left = 32
    Top = 72
    Width = 43
    Height = 13
    Caption = 'Wochen:'
  end
  object lbl_Wochen: TLabel
    Left = 88
    Top = 72
    Width = 28
    Height = 13
    Caption = 'Aktie:'
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 192
    Top = 16
  end
end
