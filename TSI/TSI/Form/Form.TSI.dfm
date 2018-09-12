object frm_TSI: Tfrm_TSI
  Left = 0
  Top = 0
  Caption = 'TSI'
  ClientHeight = 368
  ClientWidth = 764
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 764
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object btn_Aktie: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 75
      Height = 43
      Align = alLeft
      Caption = 'Aktie'
      TabOrder = 0
      OnClick = btn_AktieClick
    end
    object btn_Einstellung: TButton
      AlignWithMargins = True
      Left = 165
      Top = 3
      Width = 75
      Height = 43
      Align = alLeft
      Caption = 'Einstellung'
      TabOrder = 1
      OnClick = btn_EinstellungClick
    end
    object btn_KurseLaden: TButton
      AlignWithMargins = True
      Left = 84
      Top = 3
      Width = 75
      Height = 43
      Align = alLeft
      Caption = 'Kurse laden'
      TabOrder = 2
      OnClick = btn_KurseLadenClick
    end
    object btn_KurseAnzeigen: TButton
      AlignWithMargins = True
      Left = 246
      Top = 3
      Width = 83
      Height = 43
      Align = alLeft
      Caption = 'Kurse anzeigen'
      TabOrder = 3
      OnClick = btn_KurseAnzeigenClick
    end
  end
end
