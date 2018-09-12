unit DBObj.Aktie;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db,
  DBObj.Boersenindex;

type
  TAktie = class(TBasisDBOj)
  private
    fAK_ID: Integer;
    fLink: string;
    fAktie: string;
    fWKN: string;
    fBI_ID: Integer;
    fSymbol: string;
    procedure FuelleDBFelder;
    procedure setAK_ID(const Value: Integer);
    procedure setAktie(const Value: string);
    procedure setLink(const Value: string);
    procedure setWKN(const Value: string);
    procedure setBI_ID(const Value: Integer);
    procedure setSymbol(const Value: string);
  protected
    fBoersenindex: TBoersenindex;
    _Sql: string;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property AK_ID: Integer read fAK_ID write setAK_ID;
    property BI_ID: Integer read fBI_ID write setBI_ID;
    property Aktie: string read fAktie write setAktie;
    property WKN: string read fWKN write setWKN;
    property Link: string read fLink write setLink;
    property Symbol: string read fSymbol write setSymbol;
    function WknExist(aWKN: String): Boolean;
    function Boersenindexname: string;
  end;

implementation

{ TAktie }


constructor TAktie.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('AK_ID', ftInteger);
  fFeldList.Add('AK_AKTIE', ftString);
  fFeldList.Add('AK_WKN', ftString);
  fFeldList.Add('AK_LINK', ftString);
  fFeldList.Add('AK_BI_ID', ftInteger);
  fFeldList.Add('AK_SYMBOL', ftString);
  fBoersenindex := TBoersenindex.Create(nil);
end;

destructor TAktie.Destroy;
begin
  Aktie := '';
  WKN   := '';
  Link  := '';
  BI_ID := -1;
  FreeAndNil(fBoersenindex);
  inherited;
end;

function TAktie.getGeneratorName: string;
begin
  Result := 'AK_ID';
end;

function TAktie.getTableName: string;
begin
  Result := 'Aktie';
end;

function TAktie.getTablePrefix: string;
begin
  Result := 'AK';
end;



procedure TAktie.FuelleDBFelder;
begin
  fFeldList.FieldByName('AK_ID').AsInteger    := fID;
  fFeldList.FieldByName('AK_AKTIE').AsString  := fAktie;
  fFeldList.FieldByName('AK_WKN').AsString    := fWKN;
  fFeldList.FieldByName('AK_LINK').AsString   := fLink;
  fFeldList.FieldByName('AK_BI_ID').AsInteger := fBI_ID;
  fFeldList.FieldByName('AK_SYMBOL').AsString := fSymbol;
end;


procedure TAktie.Init;
begin
  inherited;
  fAK_Id := 0;
  fAktie := '';
  fLink  := '';
  fWKN   := '';
end;

procedure TAktie.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId     := aQuery.FieldByName('ak_id').AsInteger;
  fAktie  := aQuery.FieldByName('ak_aktie').AsString;
  fWKN    := aQuery.FieldByName('ak_wkn').AsString;
  fLink   := aQuery.FieldByName('ak_link').AsString;
  fBI_ID  := aQuery.FieldByName('ak_bi_id').AsInteger;
  fSymbol := aQuery.FieldByName('ak_symbol').AsString;
  FuelleDBFelder;
end;

procedure TAktie.setAktie(const Value: string);
begin
  UpdateV(fAktie, Value);
  fFeldList.FieldByName('AK_AKTIE').AsString := Value;
end;

procedure TAktie.setAK_ID(const Value: Integer);
begin
  UpdateV(fAk_Id, Value);
  fFeldList.FieldByName('AK_ID').AsInteger := fAk_Id;
end;

procedure TAktie.setBI_ID(const Value: Integer);
begin
  UpdateV(fBI_Id, Value);
  fFeldList.FieldByName('AK_BI_ID').AsInteger := fBi_Id;
end;

procedure TAktie.setLink(const Value: string);
begin
  UpdateV(fLink, Value);
  fFeldList.FieldByName('AK_LINK').AsString := Value;
end;


procedure TAktie.setSymbol(const Value: string);
begin
  UpdateV(fSymbol, Value);
  fFeldList.FieldByName('AK_SYMBOL').AsString := Value;
end;

procedure TAktie.setWKN(const Value: string);
begin
  UpdateV(fWKN, Value);
  fFeldList.FieldByName('AK_WKN').AsString := Value;
end;

function TAktie.WknExist(aWKN: String): Boolean;
begin
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where ak_wkn = ' + QuotedStr(aWKN);
  OpenTrans;
  try
    fQuery.Open;
    Result := not fQuery.eof;
  finally
    RollbackTrans;
  end;
end;

function TAktie.Boersenindexname: string;
begin
  Result := '';
  fBoersenindex.Trans := Trans;
  fBoersenindex.Read(fBI_ID);
  if fBoersenindex.Gefunden then
    Result := fBoersenindex.Bezeichnung;
end;


end.
