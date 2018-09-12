inherited fra_Dokumente: Tfra_Dokumente
  Width = 573
  Height = 387
  ExplicitWidth = 573
  ExplicitHeight = 387
  object grd_Dokumente: TtbStringGrid
    Left = 0
    Top = 20
    Width = 573
    Height = 350
    Align = alClient
    DefaultRowHeight = 18
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goFixedRowClick]
    TabOrder = 0
    AutosizeCol = -1
    AutosizeColMinWidth = 3
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = [fsBold]
  end
  object pnl_DokumenteToolbar: TPanel
    Left = 0
    Top = 0
    Width = 573
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnl_DokumenteToolbar'
    ShowCaption = False
    TabOrder = 1
  end
  object pg: TProgressBar
    Left = 0
    Top = 370
    Width = 573
    Height = 17
    Align = alBottom
    TabOrder = 2
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 160
    Top = 72
  end
  object pop: TPopupMenu
    Left = 152
    Top = 136
    object pop_Bez: TMenuItem
      Caption = 'Bezeichnung '#228'ndern'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object pop_FTP: TMenuItem
      Caption = 'Per FTP-'#220'bertragen'
    end
    object pop_Auf_Festplatte: TMenuItem
      Caption = 'Von FTP auf Festplatte '#252'bertragen'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object mnu_GDrive: TMenuItem
      Caption = 'Nach Google-Drive kopieren'
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object mnu_CopyToFP: TMenuItem
      Caption = 'Auf Festplatte kopieren'
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object pop_Delete: TMenuItem
      Caption = 'Dokument l'#246'schen'
    end
  end
  object IdFTP1: TIdFTP
    IPVersion = Id_IPv4
    NATKeepAlive.UseKeepAlive = False
    NATKeepAlive.IdleTimeMS = 0
    NATKeepAlive.IntervalMS = 0
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    Left = 416
    Top = 184
  end
  object pop_link: TPopupMenu
    Left = 240
    Top = 136
    object pop_DokumentLink: TMenuItem
      Caption = 'Dokument verbinden'
    end
  end
  object DataFormatAdapterTarget: TDataFormatAdapter
    DragDropComponent = DropFileTarget
    DataFormatName = 'TVirtualFileStreamDataFormat'
    Enabled = False
    Left = 80
    Top = 280
  end
  object DropFileTarget: TDropFileTarget
    DragTypes = [dtCopy, dtLink]
    WinTarget = 0
    OptimizedMove = True
    Left = 224
    Top = 208
  end
end
