object frm_SchnittstelleBearb: Tfrm_SchnittstelleBearb
  Left = 0
  Top = 0
  Caption = 'Schnittstelle'
  ClientHeight = 111
  ClientWidth = 387
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
    387
    111)
  PixelsPerInch = 96
  TextHeight = 13
  object Börsenindex: TLabel
    Left = 24
    Top = 24
    Width = 58
    Height = 13
    Caption = 'Schnittstelle'
  end
  object edt_Bezeichnung: TEdit
    Left = 96
    Top = 21
    Width = 281
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'edt_Bezeichnung'
  end
  object Panel1: TPanel
    Left = 0
    Top = 77
    Width = 387
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 1
    object btn_Ok: TButton
      AlignWithMargins = True
      Left = 302
      Top = 3
      Width = 75
      Height = 28
      Margins.Right = 10
      Align = alRight
      Caption = 'Speichern'
      TabOrder = 0
      OnClick = btn_OkClick
    end
    object btn_Cancel: TButton
      AlignWithMargins = True
      Left = 221
      Top = 3
      Width = 75
      Height = 28
      Align = alRight
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
    end
  end
end
