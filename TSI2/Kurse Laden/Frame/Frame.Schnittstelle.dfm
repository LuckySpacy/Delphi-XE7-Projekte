object fra_Schnittstelle: Tfra_Schnittstelle
  Left = 0
  Top = 0
  Width = 536
  Height = 240
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 536
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 24
    ExplicitTop = 56
    ExplicitWidth = 185
    object Label1: TLabel
      Left = 8
      Top = 14
      Width = 58
      Height = 13
      Caption = 'Schnittstelle'
    end
    object cbo_Schnittstelle: TComboBox
      Left = 80
      Top = 11
      Width = 201
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      OnChange = cbo_SchnittstelleChange
    end
    object btn_BINeu: TButton
      Left = 302
      Top = 9
      Width = 35
      Height = 25
      Caption = 'Neu'
      TabOrder = 1
      OnClick = btn_BINeuClick
    end
    object btn_BIAendern: TButton
      Left = 343
      Top = 9
      Width = 47
      Height = 25
      Caption = #196'ndern'
      TabOrder = 2
      OnClick = btn_BIAendernClick
    end
    object btn_BiLoeschen: TButton
      Left = 396
      Top = 9
      Width = 45
      Height = 25
      Caption = 'L'#246'schen'
      TabOrder = 3
      OnClick = btn_BiLoeschenClick
    end
  end
  object mem_Link: TMemo
    Left = 0
    Top = 41
    Width = 536
    Height = 199
    Align = alClient
    Lines.Strings = (
      'mem_Link')
    TabOrder = 1
    OnExit = mem_LinkExit
    ExplicitLeft = 184
    ExplicitTop = 80
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
