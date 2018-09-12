object frm_Schnittstelle: Tfrm_Schnittstelle
  Left = 0
  Top = 0
  Caption = 'Schnittstelle'
  ClientHeight = 299
  ClientWidth = 635
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
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 299
    Align = alLeft
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 183
      Height = 40
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Panel2'
      ShowCaption = False
      TabOrder = 0
      object btn_Neu: TButton
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 54
        Height = 34
        Align = alLeft
        Caption = 'Neu'
        TabOrder = 0
        OnClick = btn_NeuClick
      end
      object btn_Loeschen: TButton
        AlignWithMargins = True
        Left = 63
        Top = 3
        Width = 54
        Height = 34
        Align = alLeft
        Caption = 'L'#246'schen'
        TabOrder = 1
        OnClick = btn_LoeschenClick
      end
    end
    object lsb_Schnittstelle: TListBox
      AlignWithMargins = True
      Left = 4
      Top = 44
      Width = 177
      Height = 251
      Align = alClient
      ItemHeight = 13
      TabOrder = 1
      OnClick = lsb_SchnittstelleClick
      OnDblClick = lsb_SchnittstelleDblClick
    end
  end
  object mem_Link: TMemo
    Left = 185
    Top = 0
    Width = 450
    Height = 299
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'mem_Link')
    ParentFont = False
    TabOrder = 1
    OnExit = mem_LinkExit
  end
end
