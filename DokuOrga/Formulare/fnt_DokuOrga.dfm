object frm_DokuOrga: Tfrm_DokuOrga
  Left = 0
  Top = 0
  Caption = 'Dokumente organisieren'
  ClientHeight = 550
  ClientWidth = 1060
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 185
    Top = 0
    Height = 550
    ExplicitLeft = 336
    ExplicitTop = 32
    ExplicitHeight = 100
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 185
    Height = 550
    ActivePage = TabSheet1
    Align = alLeft
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Ordner'
    end
    object TabSheet2: TTabSheet
      Caption = 'Favoriten'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object MainMenu: TMainMenu
    Left = 448
    Top = 88
    object Datei1: TMenuItem
      Caption = 'Ordner'
      object Neu1: TMenuItem
        Action = act_New
      end
      object Speichern1: TMenuItem
        Action = act_Save
      end
    end
  end
  object act: TActionList
    Left = 408
    Top = 144
    object act_Save: TAction
      Caption = 'Speichern'
      OnExecute = act_SaveExecute
    end
    object act_New: TAction
      Caption = 'Neu'
      OnExecute = act_NewExecute
    end
  end
  object ImageList1: TImageList
    Left = 360
    Top = 264
  end
end
