object frm_TsiAnsicht: Tfrm_TsiAnsicht
  Left = 0
  Top = 0
  Caption = 'TSI'
  ClientHeight = 473
  ClientWidth = 1205
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 1205
    Height = 473
    ActivePage = tbs_TSI
    Align = alClient
    TabOrder = 0
    object tbs_TSI: TTabSheet
      Caption = 'TSI'
    end
    object tbs_Kurs: TTabSheet
      Caption = 'Kurs'
      ImageIndex = 1
    end
  end
end
