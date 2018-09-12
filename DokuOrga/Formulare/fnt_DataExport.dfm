inherited frm_DataExport: Tfrm_DataExport
  Caption = 'frm_DataExport'
  OnDestroy = FormDestroy
  ExplicitWidth = 543
  ExplicitHeight = 281
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 15
    Top = 16
    Width = 106
    Height = 13
    Caption = 'Exportverzeichnis:'
  end
  object Label2: TLabel [1]
    Left = 15
    Top = 52
    Width = 43
    Height = 13
    Caption = 'Datum:'
  end
  object edt_ExportDir: TTBEditFile
    Left = 127
    Top = 13
    Width = 396
    Height = 21
    RightButton.DisabledImageIndex = 0
    RightButton.HotImageIndex = 0
    RightButton.ImageIndex = 0
    RightButton.PressedImageIndex = 0
    RightButton.Visible = True
    TabOrder = 1
    Text = 'edt_ExportDir'
    UseTextFile = False
    OpenDialog = edt_ExportDir.OpenDialog
    FolderText = 'Verzeichnis w'#228'hlen'
    FolderDefaultDir = 'c:\'
  end
  object edt_Datum: TDateTimePicker
    Left = 127
    Top = 48
    Width = 106
    Height = 21
    Date = 42421.622519768520000000
    Time = 42421.622519768520000000
    TabOrder = 2
  end
end
