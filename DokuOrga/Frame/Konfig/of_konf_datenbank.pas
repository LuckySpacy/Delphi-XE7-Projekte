unit of_konf_datenbank;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, of_konf_base,
  contnrs, AdvEdit, AdvEdBtn, AdvFileNameEdit;

type
  Tof_Konf_Datenbank = class(Tof_konf_Base, IObServerClient)
  private
    Fedt_Datenbankfilename: TAdvFileNameEdit;
    Fedt_Server: TEdit;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure edt_DatenbankfilenameClickBtn(Sender: TObject);
  protected
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;


implementation

{ Tof_Konf_Datenbank }

constructor Tof_Konf_Datenbank.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fedt_Datenbankfilename := getAdvFileNameEdit('edt_Datenbankfilename');
  Fedt_Datenbankfilename.Text := SysObj.Datenbankfilename;
  Fedt_Datenbankfilename.OnClickBtn := edt_DatenbankfilenameClickBtn;
  Fedt_Server := getEdit('edt_Server');
  Fedt_Server.Text := SysObj.Datenbankserver;
end;

destructor Tof_Konf_Datenbank.Destroy;
begin
  save;
  inherited;
end;

procedure Tof_Konf_Datenbank.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
begin

end;

procedure Tof_Konf_Datenbank.edt_DatenbankfilenameClickBtn(Sender: TObject);
begin
  if DirectoryExists(ExtractFileDir(Fedt_Datenbankfilename.Text)) then
    Fedt_Datenbankfilename.InitialDir := ExtractFileDir(Fedt_Datenbankfilename.Text);
end;


procedure Tof_Konf_Datenbank.Save;
begin
//  inherited;
  if FileExists(Fedt_Datenbankfilename.Text) then
    SysObj.Datenbankfilename := Fedt_Datenbankfilename.Text;
  SysObj.Datenbankserver := Fedt_Server.Text;
end;

end.
