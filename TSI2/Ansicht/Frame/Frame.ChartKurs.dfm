object fra_ChartKurs: Tfra_ChartKurs
  Left = 0
  Top = 0
  Width = 528
  Height = 240
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 528
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      Left = 32
      Top = 14
      Width = 56
      Height = 13
      Caption = 'Datum von:'
    end
    object Label2: TLabel
      Left = 225
      Top = 14
      Width = 51
      Height = 13
      Caption = 'Datum bis:'
    end
    object edt_Datumvon: TDateTimePicker
      Left = 95
      Top = 11
      Width = 99
      Height = 21
      Date = 43058.597218819440000000
      Time = 43058.597218819440000000
      TabOrder = 0
      OnExit = edt_DatumvonExit
    end
    object edt_Datumbis: TDateTimePicker
      Left = 282
      Top = 11
      Width = 99
      Height = 21
      Date = 43058.597218819440000000
      Time = 43058.597218819440000000
      TabOrder = 1
      OnExit = edt_DatumbisExit
    end
    object btn_Aktual: TButton
      Left = 395
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Aktualisieren'
      TabOrder = 2
      OnClick = btn_AktualClick
    end
  end
  object Chart: TChart
    Left = 0
    Top = 41
    Width = 528
    Height = 199
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alClient
    TabOrder = 1
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
  end
end
