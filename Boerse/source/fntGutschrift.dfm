object frm_Gutschrift: Tfrm_Gutschrift
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'G'
  ClientHeight = 183
  ClientWidth = 229
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
  object Label4: TLabel
    Left = 24
    Top = 17
    Width = 24
    Height = 13
    Caption = 'Aktie'
  end
  object Label1: TLabel
    Left = 24
    Top = 48
    Width = 31
    Height = 13
    Caption = 'Datum'
  end
  object Label2: TLabel
    Left = 24
    Top = 77
    Width = 26
    Height = 13
    Caption = 'St'#252'ck'
  end
  object Label7: TLabel
    Left = 21
    Top = 102
    Width = 24
    Height = 13
    Caption = 'Wert'
  end
  object pnl_Button: TPanel
    Left = 0
    Top = 142
    Width = 229
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    ExplicitLeft = -7
    ExplicitTop = 219
    ExplicitWidth = 368
    DesignSize = (
      229
      41)
    object cmd_Ok: TButton
      Left = 140
      Top = 4
      Width = 86
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Ok'
      TabOrder = 0
      OnClick = cmd_OkClick
      ExplicitLeft = 279
    end
    object cmd_Cancel: TButton
      Left = 48
      Top = 4
      Width = 86
      Height = 33
      Anchors = [akTop, akRight]
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = cmd_CancelClick
      ExplicitLeft = 187
    end
  end
  object edt_Datum: TDateTimePicker
    Left = 66
    Top = 45
    Width = 97
    Height = 21
    Date = 41408.706545219910000000
    Time = 41408.706545219910000000
    TabOrder = 1
  end
  object edt_Stueck: TSpinEdit
    Left = 66
    Top = 72
    Width = 97
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object edt_Wert: TEdit
    Left = 66
    Top = 100
    Width = 121
    Height = 21
    TabOrder = 3
    Text = 'edt_Wert'
  end
  object edt_Aktie: TEdit
    Left = 66
    Top = 14
    Width = 155
    Height = 21
    TabStop = False
    ReadOnly = True
    TabOrder = 0
  end
end
