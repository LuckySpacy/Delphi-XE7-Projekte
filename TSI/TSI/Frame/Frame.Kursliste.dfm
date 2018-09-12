object fra_Kursliste: Tfra_Kursliste
  Left = 0
  Top = 0
  Width = 692
  Height = 393
  TabOrder = 0
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 692
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitLeft = 3
    ExplicitTop = 48
    ExplicitWidth = 185
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
  end
  object grd: TtbStringGrid
    Left = 0
    Top = 41
    Width = 692
    Height = 352
    Align = alClient
    ColCount = 4
    DefaultRowHeight = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowClick]
    TabOrder = 1
    AutosizeCol = -1
    AutosizeColMinWidth = 3
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
    ExplicitLeft = -153
    ExplicitWidth = 845
    ExplicitHeight = 199
  end
end
