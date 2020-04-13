object frm_Modulname: Tfrm_Modulname
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Modulname'
  ClientHeight = 129
  ClientWidth = 270
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    270
    129)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 32
    Width = 54
    Height = 13
    Caption = 'Modulname'
  end
  object Panel1: TPanel
    Left = 0
    Top = 98
    Width = 270
    Height = 31
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitTop = 278
    ExplicitWidth = 645
    object btn_Speichern: TButton
      AlignWithMargins = True
      Left = 192
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Speichern'
      TabOrder = 0
      OnClick = btn_SpeichernClick
      ExplicitLeft = 512
      ExplicitTop = 16
    end
    object btn_Abbrechen: TButton
      AlignWithMargins = True
      Left = 111
      Top = 3
      Width = 75
      Height = 25
      Align = alRight
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_AbbrechenClick
      ExplicitLeft = 400
      ExplicitTop = 16
    end
  end
  object edt_Modulname: TEdit
    Left = 76
    Top = 29
    Width = 186
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'edt_Modulname'
    ExplicitWidth = 561
  end
end
