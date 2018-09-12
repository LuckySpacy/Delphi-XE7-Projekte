object frm_Aktiebearb: Tfrm_Aktiebearb
  Left = 0
  Top = 0
  Caption = 'Aktie bearbeiten'
  ClientHeight = 272
  ClientWidth = 527
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
  object WKN: TLabel
    Left = 16
    Top = 16
    Width = 23
    Height = 13
    Caption = 'WKN'
  end
  object Label2: TLabel
    Left = 16
    Top = 69
    Width = 24
    Height = 13
    Caption = 'Aktie'
  end
  object Label3: TLabel
    Left = 16
    Top = 96
    Width = 18
    Height = 13
    Caption = 'Link'
  end
  object Label1: TLabel
    Left = 212
    Top = 16
    Width = 59
    Height = 13
    Caption = 'B'#246'rsenindex'
  end
  object Label4: TLabel
    Left = 16
    Top = 43
    Width = 34
    Height = 13
    Caption = 'Symbol'
  end
  object edt_WKN: TEdit
    Left = 56
    Top = 13
    Width = 137
    Height = 21
    TabOrder = 0
    Text = 'edt_WKN'
  end
  object edt_Aktie: TEdit
    Left = 56
    Top = 66
    Width = 463
    Height = 21
    TabOrder = 1
    Text = 'edt_WKN'
  end
  object mem_Link: TMemo
    Left = 56
    Top = 93
    Width = 463
    Height = 132
    Lines.Strings = (
      'mem_Link')
    TabOrder = 2
  end
  object cbo_Boersenindex: TComboBox
    Left = 278
    Top = 13
    Width = 160
    Height = 21
    Style = csDropDownList
    TabOrder = 3
  end
  object Panel1: TPanel
    Left = 0
    Top = 243
    Width = 527
    Height = 29
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 4
    object btn_Ok: TButton
      AlignWithMargins = True
      Left = 442
      Top = 3
      Width = 75
      Height = 23
      Margins.Right = 10
      Align = alRight
      Caption = 'Speichern'
      TabOrder = 0
      OnClick = btn_OkClick
    end
    object btn_Cancel: TButton
      AlignWithMargins = True
      Left = 361
      Top = 3
      Width = 75
      Height = 23
      Align = alRight
      Caption = 'Abbrechen'
      TabOrder = 1
      OnClick = btn_CancelClick
    end
  end
  object edt_Symbol: TEdit
    Left = 57
    Top = 40
    Width = 137
    Height = 21
    TabOrder = 5
    Text = 'edt_WKN'
  end
end
