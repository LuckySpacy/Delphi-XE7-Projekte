object frmSqlEdit: TfrmSqlEdit
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmSqlEdit'
  ClientHeight = 338
  ClientWidth = 651
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object SynEditx: TSynEdit
    Left = 0
    Top = 0
    Width = 651
    Height = 338
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    TabOrder = 0
    OnKeyDown = SynEditxKeyDown
    OnKeyUp = SynEditxKeyUp
    OnMouseUp = SynEditxMouseUp
    Gutter.Font.Charset = DEFAULT_CHARSET
    Gutter.Font.Color = clWindowText
    Gutter.Font.Height = -11
    Gutter.Font.Name = 'Courier New'
    Gutter.Font.Style = []
    Highlighter = SynSQLSyn
    RightEdge = 0
    FontSmoothing = fsmNone
  end
  object SynSQLSyn: TSynSQLSyn
    Options.AutoDetectEnabled = False
    Options.AutoDetectLineLimit = 0
    Options.Visible = False
    Left = 432
    Top = 128
  end
end
