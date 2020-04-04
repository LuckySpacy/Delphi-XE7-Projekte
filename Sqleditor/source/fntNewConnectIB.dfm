object frmNewConnectIB: TfrmNewConnectIB
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Neue Verbindung'
  ClientHeight = 354
  ClientWidth = 358
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
  object GroupBox1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 301
    Width = 352
    Height = 50
    Align = alBottom
    TabOrder = 0
    ExplicitTop = 278
    object cmd_Cancel: TButton
      Left = 8
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Abbrechen'
      TabOrder = 0
      OnClick = cmd_CancelClick
    end
    object cmd_Save: TButton
      Left = 262
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Speichern'
      TabOrder = 1
      OnClick = cmd_SaveClick
    end
  end
  object GroupBox2: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 352
    Height = 38
    Margins.Bottom = 0
    Align = alTop
    TabOrder = 1
    object lbl_Name: TLabel
      Left = 13
      Top = 12
      Width = 27
      Height = 13
      Caption = 'Name'
    end
    object edt_DBName: TEdit
      Left = 130
      Top = 9
      Width = 207
      Height = 21
      TabOrder = 0
    end
  end
  object GroupBox3: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 95
    Width = 352
    Height = 202
    Align = alTop
    TabOrder = 2
    object lbl_Laufwerksbuchstaben: TLabel
      Left = 13
      Top = 15
      Width = 103
      Height = 13
      Caption = 'Laufwerksbuchstabe:'
    end
    object lbl_Server: TLabel
      Left = 13
      Top = 42
      Width = 36
      Height = 13
      Caption = 'Server:'
    end
    object lbl_Verzeichnis: TLabel
      Left = 13
      Top = 69
      Width = 57
      Height = 13
      Caption = 'Verzeichnis:'
    end
    object Label4: TLabel
      Left = 13
      Top = 96
      Width = 82
      Height = 13
      Caption = 'Datenbankname:'
    end
    object Label6: TLabel
      Left = 15
      Top = 148
      Width = 73
      Height = 13
      Caption = 'Benutzername:'
    end
    object Label7: TLabel
      Left = 15
      Top = 175
      Width = 48
      Height = 13
      Caption = 'Passwort:'
    end
    object Label1: TLabel
      Left = 14
      Top = 121
      Width = 24
      Height = 13
      Caption = 'Port:'
    end
    object cbb_Laufwerk: TComboBox
      Left = 130
      Top = 12
      Width = 52
      Height = 21
      Style = csDropDownList
      TabOrder = 0
      Items.Strings = (
        'A:'
        'B:'
        'C:'
        'D:'
        'E:'
        'F:'
        'G:'
        'H:'
        'I:'
        'J:'
        'K:'
        'L:'
        'M:'
        'N:'
        'O:'
        'P:'
        'Q:'
        'R:'
        'S:'
        'T:'
        'U:'
        'V:'
        'W:'
        'X:'
        'Y:'
        'Z:')
    end
    object edt_Server: TEdit
      Left = 130
      Top = 39
      Width = 207
      Height = 21
      TabOrder = 1
      Text = 'edt_Server'
    end
    object edt_Verzeichnis: TEdit
      Left = 130
      Top = 66
      Width = 207
      Height = 21
      TabOrder = 2
      Text = 'Edit1'
    end
    object edt_Datenbank: TEdit
      Left = 130
      Top = 93
      Width = 207
      Height = 21
      TabOrder = 3
      Text = 'edt_Datenbank'
    end
    object edt_User: TEdit
      Left = 130
      Top = 145
      Width = 207
      Height = 21
      TabOrder = 5
      Text = 'edt_User'
    end
    object edt_Passwort: TEdit
      Left = 130
      Top = 172
      Width = 207
      Height = 21
      TabOrder = 6
      Text = 'edt_User'
    end
    object edt_Port: TSpinEdit
      Left = 130
      Top = 118
      Width = 121
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 4
      Value = 0
    end
  end
  object GroupBox5: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 44
    Width = 352
    Height = 48
    Margins.Bottom = 0
    Align = alTop
    TabOrder = 3
    object rb_Firebird: TRadioButton
      Left = 14
      Top = 16
      Width = 62
      Height = 17
      Caption = 'Firebird'
      TabOrder = 0
      OnClick = DatenbankClick
    end
    object rb_MSSql: TRadioButton
      Left = 122
      Top = 16
      Width = 122
      Height = 17
      Caption = 'Microsoft SQL Server'
      TabOrder = 1
      OnClick = DatenbankClick
    end
    object rb_MySql: TRadioButton
      Left = 287
      Top = 16
      Width = 50
      Height = 17
      Caption = 'MySql'
      TabOrder = 2
      OnClick = DatenbankClick
    end
  end
end
