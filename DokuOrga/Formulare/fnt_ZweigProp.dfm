inherited frm_ZweigProp: Tfrm_ZweigProp
  Caption = 'Zweig'
  ClientWidth = 396
  ExplicitWidth = 402
  ExplicitHeight = 281
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 16
    Width = 24
    Height = 13
    Caption = 'Text'
  end
  inherited pnl_Bottom: TPanel
    Width = 396
    ExplicitWidth = 400
    inherited btn_Ok: TTBButton
      Left = 307
      ExplicitLeft = 311
    end
    inherited btn_Cancel: TTBButton
      Left = 202
      ExplicitLeft = 206
    end
  end
  object edt_Text: TEdit
    Left = 46
    Top = 13
    Width = 336
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'edt_Text'
    ExplicitWidth = 340
  end
end
