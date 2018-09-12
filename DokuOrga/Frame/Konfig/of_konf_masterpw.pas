unit of_konf_masterpw;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, of_konf_base,
  contnrs, AdvEdit, AdvEdBtn, AdvDirectoryEdit, of_basecustom, tbButton,
  System.UITypes;

type
  Tof_Konf_MasterPW = class(Tof_konf_Base, IObServerClient)
  private
    Fedt_AktPW: TEdit;
    FEdt_NeuPW: TEdit;
    FEdt_NeuPW2: TEdit;
    Fbtn_Save: TtbButton;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure SaveClick(TSender: TObject);
  protected
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;

implementation

{ Tof_Konf_MasterPW }

uses
  c_DBTypes;

constructor Tof_Konf_MasterPW.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fedt_AktPW  := TEdit(getCustomEdit('edt_AktPW'));
  FEdt_NeuPW  := TEdit(getCustomEdit('Edt_NeuPW'));
  FEdt_NeuPW2 := TEdit(getCustomEdit('Edt_NeuPW2'));
  Fbtn_Save   := gettbButton('btn_save');
  Fedt_AktPW.Text := '';
  FEdt_NeuPW.Text := '';
  FEdt_NeuPW2.Text := '';
  Fbtn_Save.OnClick := SaveClick;
end;

destructor Tof_Konf_MasterPW.Destroy;
begin
  inherited;
end;

procedure Tof_Konf_MasterPW.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
begin

end;

procedure Tof_Konf_MasterPW.Save;
begin
  inherited;

end;

procedure Tof_Konf_MasterPW.SaveClick(TSender: TObject);
begin
  if sysObj.Benutzer.Feld(BE_PW).AsString > '' then
  begin
    if Fedt_AktPW.Text = '' then
    begin
      MessageDlg('Sie haben das aktuelle Passwort noch nicht eingegeben!', mtError, [mbOk], 0);
      Fedt_AktPW.SetFocus;
      exit;
    end;
    if Fedt_AktPW.Text <> SysObj.Entschluesseln(sysObj.Benutzer.Feld(BE_PW).AsString, FEdt_AktPW.Text) then
    begin
      MessageDlg('Das aktuelle Passwort stimmt nicht!', mtError, [mbOk], 0);
      exit;
    end;
  end;
  if FEdt_NeuPW.Text <> FEdt_NeuPW2.Text then
  begin
    MessageDlg('Das Passwort stimmt nicht überein', mtError, [mbOk], 0);
    FEdt_NeuPW.SetFocus;
    exit;
  end;
  SysObj.Benutzer.Feld(BE_PW).AsString := SysObj.Verschluesseln(FEdt_NeuPW.Text, FEdt_NeuPW.Text);
  SysObj.Benutzer.Save;
  ShowMessage('Das aktuelle Passwort hat sich jetzt geändert');
end;

end.
