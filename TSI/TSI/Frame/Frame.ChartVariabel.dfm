object fra_ChartVariable: Tfra_ChartVariable
  Left = 0
  Top = 0
  Width = 555
  Height = 545
  TabOrder = 0
  object Splitter1: TSplitter
    Left = 0
    Top = 405
    Width = 555
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 41
    ExplicitWidth = 335
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 555
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
  object Chart1: TChart
    Left = 0
    Top = 41
    Width = 555
    Height = 364
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitHeight = 320
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      -73
      15
      -73)
    ColorPaletteIndex = 13
    object Series2: TFastLineSeries
      SeriesColor = clBlack
      Stairs = True
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object Series1: TLineSeries
      Active = False
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
  object Chart_TSI: TChart
    Left = 0
    Top = 408
    Width = 555
    Height = 137
    Title.Text.Strings = (
      'TChart')
    View3D = False
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    PrintMargins = (
      15
      -73
      15
      -73)
    ColorPaletteIndex = 13
    object Series3: TLineSeries
      Brush.BackColor = clDefault
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
  end
end
