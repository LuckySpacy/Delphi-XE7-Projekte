object frm_DokuOrgaWeb: Tfrm_DokuOrgaWeb
  Left = 0
  Top = 0
  Caption = 'frm_DokuOrgaWeb'
  ClientHeight = 431
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 191
    Top = 0
    Height = 431
    ExplicitLeft = 185
    ExplicitTop = -271
    ExplicitHeight = 550
  end
  object pg_Ordner: TPageControl
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 185
    Height = 425
    ActivePage = tbs_Ordner
    Align = alLeft
    TabOrder = 0
    ExplicitLeft = 0
    ExplicitTop = 0
    ExplicitHeight = 431
    object tbs_Ordner: TTabSheet
      Caption = 'Ordner'
      ExplicitHeight = 403
    end
    object TabSheet2: TTabSheet
      Caption = 'Favoriten'
      ImageIndex = 1
      ExplicitHeight = 403
    end
  end
  object pg_Details: TPageControl
    AlignWithMargins = True
    Left = 197
    Top = 3
    Width = 435
    Height = 425
    ActivePage = tbs_Seite
    Align = alClient
    TabOrder = 1
    object tbs_Seite: TTabSheet
      Caption = 'Seite'
    end
    object tbs_Dokument: TTabSheet
      Caption = 'Dokument'
      ImageIndex = 1
    end
    object tbs_Einstellung: TTabSheet
      Caption = 'Einstellung'
      ImageIndex = 2
    end
  end
end
