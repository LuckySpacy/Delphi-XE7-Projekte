unit MySql.Kurs;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MySql.Base,
  Data.DB;
type
  TMySqlKurs = class(TMySqlBase)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TMySqlKurs }

constructor TMySqlKurs.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('KU_ID', ftInteger);
  fFeldList.Add('AK_ID', ftString);
  fFeldList.Add('DATUM', ftTimeStampOffset);
  fFeldList.Add('KURS', ftFloat);
  Init;
end;

destructor TMySqlKurs.Destroy;
begin

  inherited;
end;

procedure TMySqlKurs.Init;
begin
  inherited;

end;

end.
