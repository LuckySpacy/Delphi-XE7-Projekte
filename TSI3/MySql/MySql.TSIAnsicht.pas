unit MySql.TSIAnsicht;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, MySql.Base,
  Data.DB;
type
  TMySqlTSIAnsicht = class(TMySqlBase)
  private
    {
    fTSI12: real;
    fTSI27: real;
    fTA_ID: Integer;
    fBI_ID: Integer;
    fAK_ID: Integer;
    fLetzterKurs: string;
    fDepot: Boolean;
    fAktie: string;
    fWKN: string;
    }
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {
    property TA_ID: Integer read fTA_ID write fTA_ID;
    property AK_ID: Integer read fAK_ID write fAK_ID;
    property WKN: string read fWKN write fWKN;
    property Aktie: string read fAktie write fAktie;
    property Depot: Boolean read fDepot write fDepot;
    property LetzterKurs: string read fLetzterKurs write fLetzterKurs;
    property TSI27: real read fTSI27 write fTSI27;
    property TSI12: real read fTSI12 write fTSI12;
    property BI_ID: Integer read fBI_ID write fBI_ID;
    }
    procedure Init; override;
  end;

implementation

{ TMySqlTSIAnsicht }

constructor TMySqlTSIAnsicht.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('TA_ID', ftInteger);
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('WKN', ftString);
  fFeldList.Add('Aktie', ftString);
  fFeldList.Add('Depot', ftBoolean);
  fFeldList.Add('LetzterKurs', ftTimeStampOffset);
  fFeldList.Add('Kurs', ftfloat);
  fFeldList.Add('Kursdatum', ftTimeStampOffset);
  fFeldList.Add('JHochkurs', ftFloat);
  fFeldList.Add('JHochdatum', ftTimeStampOffset);
  fFeldList.Add('HJTiefkurs', ftFloat);
  fFeldList.Add('HJTiefdatum', ftTimeStampOffset);
  fFeldList.Add('TSI27', ftfloat);
  fFeldList.Add('TSI12', ftfloat);
  fFeldList.Add('BI_ID', ftInteger);
  fFeldList.Add('PJHOCH', ftFloat);
  fFeldList.Add('PHJTIEF', ftFloat);
  fFeldList.Add('PSPANNE', ftFloat);
  Init;
end;

destructor TMySqlTSIAnsicht.Destroy;
begin

  inherited;
end;

procedure TMySqlTSIAnsicht.Init;
begin
  inherited;
end;

end.
