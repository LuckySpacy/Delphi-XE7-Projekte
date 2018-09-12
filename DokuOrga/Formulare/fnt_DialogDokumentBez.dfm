inherited frm_DialogDokumentBez: Tfrm_DialogDokumentBez
  Caption = 'Dokumentbezeichnung'
  ExplicitWidth = 407
  ExplicitHeight = 213
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel1: TPanel
    ExplicitLeft = 8
    ExplicitTop = 33
    ExplicitWidth = 401
    ExplicitHeight = 143
    object Label1: TLabel
      Left = 8
      Top = 71
      Width = 62
      Height = 13
      Caption = 'Dateiname'
    end
    object Label2: TLabel
      Left = 8
      Top = 19
      Width = 72
      Height = 13
      Caption = 'Bezeichnung'
    end
    object edt_Bez: TEdit
      Left = 8
      Top = 38
      Width = 386
      Height = 21
      TabOrder = 0
      Text = 'edt_Bez'
    end
    object edt_Dateiname: TEdit
      Left = 8
      Top = 87
      Width = 386
      Height = 21
      TabOrder = 1
      Text = 'edt_Bez'
    end
  end
  inherited Panel2: TPanel
    ExplicitTop = 143
  end
end
