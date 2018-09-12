object frm_Entfernung_Lauftzeit: Tfrm_Entfernung_Lauftzeit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Entfernung anhand Laufzeit berechnen'
  ClientHeight = 263
  ClientWidth = 357
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    357
    263)
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 15
    Top = 11
    Width = 39
    Height = 16
    Caption = 'Scout'
  end
  object Label2: TLabel
    Left = 99
    Top = 11
    Width = 45
    Height = 16
    Caption = 'Ranger'
  end
  object Label3: TLabel
    Left = 183
    Top = 11
    Width = 46
    Height = 16
    Caption = 'Gunner'
  end
  object Label4: TLabel
    Left = 267
    Top = 11
    Width = 52
    Height = 16
    Caption = 'Knocker'
  end
  object Label5: TLabel
    Left = 15
    Top = 67
    Width = 43
    Height = 16
    Caption = 'Mortar'
  end
  object Label6: TLabel
    Left = 99
    Top = 67
    Width = 52
    Height = 16
    Caption = 'Molotov'
  end
  object Label7: TLabel
    Left = 183
    Top = 67
    Width = 31
    Height = 16
    Caption = 'Biker'
  end
  object Label8: TLabel
    Left = 267
    Top = 67
    Width = 31
    Height = 16
    Caption = 'Trike'
  end
  object Label9: TLabel
    Left = 15
    Top = 123
    Width = 42
    Height = 16
    Caption = 'Pickup'
  end
  object Label10: TLabel
    Left = 99
    Top = 123
    Width = 50
    Height = 16
    Caption = 'Carrack'
  end
  object Label11: TLabel
    Left = 195
    Top = 123
    Width = 120
    Height = 16
    Caption = 'Berechnete Felder'
  end
  object edt_Scout: TMaskEdit
    Left = 15
    Top = 30
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 0
    Text = '  :  :  '
  end
  object edt_Ranger: TMaskEdit
    Left = 99
    Top = 30
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 1
    Text = '  :  :  '
  end
  object edt_Gunner: TMaskEdit
    Left = 183
    Top = 30
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 2
    Text = '  :  :  '
  end
  object edt_Knocker: TMaskEdit
    Left = 267
    Top = 30
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 3
    Text = '  :  :  '
  end
  object edt_Mortar: TMaskEdit
    Left = 15
    Top = 86
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 4
    Text = '  :  :  '
  end
  object edt_Molotov: TMaskEdit
    Left = 99
    Top = 86
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 5
    Text = '  :  :  '
  end
  object edt_Biker: TMaskEdit
    Left = 183
    Top = 86
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 6
    Text = '  :  :  '
  end
  object edt_Trike: TMaskEdit
    Left = 267
    Top = 86
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 7
    Text = '  :  :  '
  end
  object edt_Pickup: TMaskEdit
    Left = 15
    Top = 142
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 8
    Text = '  :  :  '
  end
  object edt_Carrack: TMaskEdit
    Left = 99
    Top = 142
    Width = 78
    Height = 24
    EditMask = '99:99:99;1;0'
    MaxLength = 8
    TabOrder = 9
    Text = '  :  :  '
  end
  object edt_Felder: TEdit
    Left = 195
    Top = 142
    Width = 121
    Height = 24
    TabOrder = 10
  end
  object pnl_Bottom: TPanel
    Left = 0
    Top = 222
    Width = 357
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnl_Bottom'
    ShowCaption = False
    TabOrder = 11
    ExplicitLeft = -46
    ExplicitTop = 122
    ExplicitWidth = 403
    DesignSize = (
      357
      41)
    object btn_Ok: TTBButton
      Left = 232
      Top = 8
      Width = 115
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = #220'bernehmen'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = ANSI_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -13
      BtnLabel.Font.Name = 'Verdana'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = True
      BtnImage.AlignRight = False
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      ImageIndex = -1
      OnClick = btn_OkClick
      Anchors = [akTop, akRight]
    end
    object btn_Cancel: TTBButton
      Left = 8
      Top = 8
      Width = 113
      Height = 25
      Flat = True
      SelectColor = clSkyBlue
      DownColor = clSkyBlue
      BtnLabel.HAlign = tbHLeft
      BtnLabel.VAlign = tbVTop
      BtnLabel.HMargin = 3
      BtnLabel.VMargin = 0
      BtnLabel.Caption = 'Abbrechen'
      BtnLabel.HTextAlign = tbHTextCenter
      BtnLabel.VTextAlign = tbVTextCenter
      BtnLabel.Font.Charset = ANSI_CHARSET
      BtnLabel.Font.Color = clWindowText
      BtnLabel.Font.Height = -13
      BtnLabel.Font.Name = 'Verdana'
      BtnLabel.Font.Style = []
      BtnLabel.Wordwrap = True
      BtnImage.AlignLeft = True
      BtnImage.AlignRight = False
      BtnImage.Margin = 10
      BtnImage.Height = 16
      BtnImage.Width = 16
      ImageIndex = -1
      OnClick = btn_CancelClick
    end
  end
  object btn_Berechnen: TTBButton
    Left = 15
    Top = 179
    Width = 330
    Height = 25
    Flat = True
    SelectColor = clSkyBlue
    DownColor = clSkyBlue
    BtnLabel.HAlign = tbHLeft
    BtnLabel.VAlign = tbVTop
    BtnLabel.HMargin = 3
    BtnLabel.VMargin = 0
    BtnLabel.Caption = 'Berechnen'
    BtnLabel.HTextAlign = tbHTextCenter
    BtnLabel.VTextAlign = tbVTextCenter
    BtnLabel.Font.Charset = ANSI_CHARSET
    BtnLabel.Font.Color = clWindowText
    BtnLabel.Font.Height = -13
    BtnLabel.Font.Name = 'Verdana'
    BtnLabel.Font.Style = []
    BtnLabel.Wordwrap = True
    BtnImage.AlignLeft = True
    BtnImage.AlignRight = False
    BtnImage.Margin = 10
    BtnImage.Height = 16
    BtnImage.Width = 16
    ImageIndex = -1
    OnClick = btn_BerechnenClick
    Anchors = [akTop, akRight]
  end
end
