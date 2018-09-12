unit MySql.Aktie;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MySql.Base,
  Data.DB;
type
  TMySqlAktie = class(TMySqlBase)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TMySqlAktie }

constructor TMySqlAktie.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('WKN', ftString);
  fFeldList.Add('Aktie', ftString);
  fFeldList.Add('Depot', ftBoolean);
  fFeldList.Add('BI_ID', ftInteger);
  Init;
end;

destructor TMySqlAktie.Destroy;
begin

  inherited;
end;

procedure TMySqlAktie.Init;
begin
  inherited;

end;

end.
