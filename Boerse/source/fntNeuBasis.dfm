object frm_NeuBasis: Tfrm_NeuBasis
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frm_NeuBasis'
  ClientHeight = 270
  ClientWidth = 368
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnl_Button: TPanel
    Left = 0
    Top = 229
    Width = 368
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    ExplicitLeft = 176
    ExplicitTop = 160
    ExplicitWidth = 185
    DesignSize = (
      368
      41)
    object cmd_Ok: TButton
      Left = 279
      Top = 4
      Width = 86
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      TabOrder = 0
      ExplicitLeft = 309
    end
    object cmd_Cancel: TButton
      Left = 187
      Top = 4
      Width = 86
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = cmd_CancelClick
      ExplicitLeft = 217
    end
  end
end
