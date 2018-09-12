object fra_Grid: Tfra_Grid
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  TabOrder = 0
  object Grid: TStringGrid
    Left = 0
    Top = 0
    Width = 320
    Height = 240
    Align = alClient
    DefaultRowHeight = 18
    FixedCols = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    OnDblClick = GridDblClick
    OnDrawCell = GridDrawCell
  end
end
