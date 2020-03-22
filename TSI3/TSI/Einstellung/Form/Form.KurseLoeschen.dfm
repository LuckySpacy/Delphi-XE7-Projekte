object frm_KurseLoeschen: Tfrm_KurseLoeschen
  Left = 0
  Top = 0
  Caption = 'Kurse L'#246'schen'
  ClientHeight = 616
  ClientWidth = 365
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 365
    Height = 41
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object pnl_Boersenindex: TLabel
      Left = 32
      Top = 14
      Width = 59
      Height = 13
      Caption = 'B'#246'rsenindex'
    end
    object cbo_Boersenindex: TComboBox
      Left = 112
      Top = 11
      Width = 241
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbo_BoersenindexChange
    end
  end
  object lsb: TListBox
    Left = 0
    Top = 41
    Width = 365
    Height = 534
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 1
  end
  object Panel1: TPanel
    Left = 0
    Top = 575
    Width = 365
    Height = 41
    Align = alBottom
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    object btn_KurseLoeschen: TButton
      AlignWithMargins = True
      Left = 191
      Top = 4
      Width = 82
      Height = 33
      Align = alRight
      Caption = 'Kurs l'#246'schen'
      TabOrder = 0
      OnClick = btn_KurseLoeschenClick
    end
    object btn_Ok: TButton
      AlignWithMargins = True
      Left = 279
      Top = 4
      Width = 82
      Height = 33
      Align = alRight
      Caption = 'Schlie'#223'en'
      TabOrder = 1
      OnClick = btn_OkClick
    end
    object btn_AlleKurseLoeschen: TButton
      AlignWithMargins = True
      Left = 80
      Top = 4
      Width = 105
      Height = 33
      Align = alRight
      Caption = 'Alle Kurse l'#246'schen'
      TabOrder = 2
      OnClick = btn_AlleKurseLoeschenClick
    end
  end
end
