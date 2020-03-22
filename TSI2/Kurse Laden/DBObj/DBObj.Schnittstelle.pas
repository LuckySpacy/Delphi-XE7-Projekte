unit DBObj.Schnittstelle;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db;

type
  TSchnittstelle = class(TBasisDBOj)
  private
    fSS_ID: Integer;
    fBezeichnung: string;
    fLink: string;
    procedure FuelleDBFelder;
    procedure setSS_ID(const Value: Integer);
    procedure setBezeichnung(const Value: string);
    procedure setLink(const Value: string);
  protected
    _Sql: string;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property SS_ID: Integer read fSS_ID write setSS_ID;
    property Bezeichnung: string read fBezeichnung write setBezeichnung;
    property Link: string read fLink write setLink;
  end;


implementation

{ TSchnittstelle }

constructor TSchnittstelle.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('SS_ID', ftInteger);
  fFeldList.Add('SS_NAME', ftString);
  fFeldList.Add('SS_LINK', ftString);
end;

destructor TSchnittstelle.Destroy;
begin

  inherited;
end;

function TSchnittstelle.getGeneratorName: string;
begin
  Result := 'SS_ID';
end;

function TSchnittstelle.getTableName: string;
begin
  Result := 'Schnittstelle';
end;

function TSchnittstelle.getTablePrefix: string;
begin
  Result := 'SS';
end;

procedure TSchnittstelle.Init;
begin
  inherited;
  fBezeichnung := '';
  fLink := '';
end;

procedure TSchnittstelle.FuelleDBFelder;
begin
  fFeldList.FieldByName('SS_ID').AsInteger   := fID;
  fFeldList.FieldByName('SS_NAME').AsString := fBezeichnung;
  fFeldList.FieldByName('SS_LINK').AsString := fLink;
end;


procedure TSchnittstelle.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId           := aQuery.FieldByName('ss_id').AsInteger;
  fBezeichnung  := aQuery.FieldByName('ss_name').AsString;
  fLink         := aQuery.FieldByName('ss_link').AsString;
  FuelleDBFelder;
end;

procedure TSchnittstelle.setBezeichnung(const Value: string);
begin
  UpdateV(fBezeichnung, Value);
  fFeldList.FieldByName('SS_NAME').AsString := fBezeichnung;
end;

procedure TSchnittstelle.setLink(const Value: string);
begin
  UpdateV(fLink, Value);
  fFeldList.FieldByName('SS_LINK').AsString := fLink;
end;

procedure TSchnittstelle.setSS_ID(const Value: Integer);
begin
  UpdateV(fSS_Id, Value);
  fFeldList.FieldByName('SS_ID').AsInteger := fSS_Id;
end;

end.
