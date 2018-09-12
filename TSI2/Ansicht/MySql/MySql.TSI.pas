unit MySql.TSI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MySql.Base,
  Data.DB;
type
  TMySqlTSI = class(TMySqlBase)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TMySqlTSI }

constructor TMySqlTSI.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('TS_ID', ftInteger);
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('DATUM', ftTimeStampOffset);
  fFeldList.Add('WOCHEN', ftInteger);
  fFeldList.Add('WERT', ftFloat);
  Init;
end;

destructor TMySqlTSI.Destroy;
begin

  inherited;
end;

procedure TMySqlTSI.Init;
begin
  inherited;

end;

end.
