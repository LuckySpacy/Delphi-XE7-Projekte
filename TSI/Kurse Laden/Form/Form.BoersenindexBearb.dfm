object frm_BoersenindexBearb: Tfrm_BoersenindexBearb
  Left = 0
  Top = 0
  Caption = 'B'#246'rsenindex'
  ClientHeight = 108
  ClientWidth = 385
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    385
    108)
  PixelsPerInch = 96
  TextHeight = 13
  object Börsenindex: TLabel
    Left = 24
    Top = 24
    Width = 59
    Height = 13
    Caption = 'B'#246'rsenindex'
  end
  object edt_Bezeichnung: TEdit
    Left = 96
    Top = 21
    Width = 281
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'edt_Bezeichnung'
    ExplicitWidth = 423
  end
  object Panel1: TPanel
    Left = 0
    Top = 74
    Width = 385
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    ExplicitTop = 208
    object btn_Ok: TButton
      AlignWithMargins = True
      Left = 300
      Top = 3
      Width = 75
      Height = 28
      Margins.Right = 10
      Align = alRight
      Caption = 'Speichern'
      TabOrder = 0
      OnClick = btn_OkClick
      ExplicitLeft = 158
      ExplicitTop = 16
      ExplicitHeight = 25
    end
    object btn_Cancel: TButton
      AlignWithMargins = True
      Left = 219
      Top = 3
      Width = 75
      Height = 28
      Align = alRight
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
      ExplicitLeft = 190
      ExplicitTop = 1
      ExplicitHeight = 25
    end
  end
end
