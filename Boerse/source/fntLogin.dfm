object frm_Login: Tfrm_Login
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Anmelden'
  ClientHeight = 187
  ClientWidth = 284
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
  object Label1: TLabel
    Left = 16
    Top = 43
    Width = 69
    Height = 13
    Caption = 'Benutzername'
  end
  object Label2: TLabel
    Left = 16
    Top = 70
    Width = 44
    Height = 13
    Caption = 'Passwort'
  end
  object lbl_Passwort2: TLabel
    Left = 16
    Top = 97
    Width = 44
    Height = 13
    Caption = 'Passwort'
    Visible = False
  end
  object edt_Benutzer: TEdit
    Left = 120
    Top = 40
    Width = 121
    Height = 21
    TabOrder = 0
    Text = 'edt_Benutzer'
  end
  object edt_Passwort: TEdit
    Left = 120
    Top = 67
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    Text = 'Edit1'
    OnKeyUp = edt_PasswortKeyUp
  end
  object cmd_Login: TButton
    Left = 120
    Top = 121
    Width = 121
    Height = 41
    Caption = 'Login'
    TabOrder = 3
    OnClick = cmd_LoginClick
  end
  object edt_Passwort2: TEdit
    Left = 120
    Top = 94
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 2
    Text = 'edt_Passwort2'
    Visible = False
  end
end
