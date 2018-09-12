object frm_KurseLaden: Tfrm_KurseLaden
  Left = 0
  Top = 0
  Caption = 'Kurse Laden'
  ClientHeight = 465
  ClientWidth = 838
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 838
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btn_Aktie: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Aktien'
      TabOrder = 0
      OnClick = btn_AktieClick
    end
    object btn_Einstellung: TButton
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Einstellung'
      TabOrder = 1
      OnClick = btn_EinstellungClick
    end
    object btn_Schnittstelle: TButton
      Left = 170
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Schnittstelle'
      TabOrder = 2
      OnClick = btn_SchnittstelleClick
    end
    object btn_KurseLaden: TButton
      Left = 251
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Kurse laden'
      TabOrder = 3
      OnClick = btn_KurseLadenClick
    end
  end
end
