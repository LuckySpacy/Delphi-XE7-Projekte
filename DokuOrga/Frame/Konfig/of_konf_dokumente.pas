unit of_konf_dokumente;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  of_Base, c_Types, o_sysObj, obBusinessClasses, obServerClient, of_konf_base,
  contnrs, AdvEdit, AdvEdBtn, AdvDirectoryEdit;


type
  Tof_Konf_Dokumente = class(Tof_konf_Base, IObServerClient)
  private
    Fedt_Dir: TAdvDirectoryEdit;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
  protected
    procedure Save; override;
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
  end;


implementation

{ Tof_Konf_Dokumente }


constructor Tof_Konf_Dokumente.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  Fedt_Dir := getAdvDirectoryEdit('edt_Dir');
  Fedt_Dir.Text := SysObj.Einstellung.DokumentPfad.AsString;
end;

destructor Tof_Konf_Dokumente.Destroy;
begin
  Save;
  inherited;
end;


procedure Tof_Konf_Dokumente.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
begin

end;

procedure Tof_Konf_Dokumente.Save;
begin
  SysObj.Einstellung.DokumentPfad.AsString := Fedt_Dir.Text;
//  inherited;
end;

end.
