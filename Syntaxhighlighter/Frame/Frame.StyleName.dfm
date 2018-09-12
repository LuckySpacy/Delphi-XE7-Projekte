object fra_StyleName: Tfra_StyleName
  Left = 0
  Top = 0
  Width = 191
  Height = 363
  TabOrder = 0
  object pnl_fontstyle: TPanel
    Left = 0
    Top = 0
    Width = 191
    Height = 363
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnl_fontstyle'
    ShowCaption = False
    TabOrder = 0
    object pnl_fontstyletop: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 185
      Height = 16
      Align = alTop
      BevelOuter = bvNone
      Caption = 'Fontstyle'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object pnl_fontstylebutton: TPanel
      AlignWithMargins = True
      Left = 3
      Top = 22
      Width = 185
      Height = 24
      Margins.Top = 0
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Caption = 'pnl_fontstyletop'
      ShowCaption = False
      TabOrder = 1
      object btn_Neu_Fontstyle: TButton
        Left = 0
        Top = 0
        Width = 40
        Height = 24
        Align = alLeft
        Caption = 'Neu'
        TabOrder = 0
        OnClick = btn_Neu_FontstyleClick
      end
      object btn_Edit_Fontstyle: TButton
        Left = 40
        Top = 0
        Width = 64
        Height = 24
        Align = alLeft
        Caption = 'Bearbeiten'
        TabOrder = 1
        OnClick = btn_Edit_FontstyleClick
      end
      object btn_del_Fontstyle: TButton
        Left = 104
        Top = 0
        Width = 56
        Height = 24
        Align = alLeft
        Caption = 'L'#246'schen'
        TabOrder = 2
      end
    end
    object lsb_Fontstyles: TListBox
      AlignWithMargins = True
      Left = 3
      Top = 49
      Width = 185
      Height = 311
      Align = alClient
      ItemHeight = 13
      TabOrder = 2
    end
  end
end
