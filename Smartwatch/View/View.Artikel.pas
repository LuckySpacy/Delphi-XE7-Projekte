unit View.Artikel;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TViewArtikel = class(TDBBase)
  private
    fWebseite: String;
    fAr_Id: Integer;
    fImageUrl: string;
    fFi_Id: Integer;
    fMatch: string;
    fNr: String;
    fArId: Integer;
    fFaId: Integer;
    fqry: TMySqlQuery;
    fFiNr: String;
    fSaId: Integer;
    procedure setAr_Id(const Value: Integer);
    procedure setFi_Id(const Value: Integer);
    procedure setImageUrl(const Value: string);
    procedure setMatch(const Value: string);
    procedure setNr(const Value: String);
    procedure setWebseite(const Value: String);
    procedure setFiNr(const Value: String);
    procedure setSaId(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Fi_Id: Integer read fFi_Id write setFi_Id;
    property Ar_Id: Integer read fAr_Id write setAr_Id;
    property Webseite: String read fWebseite write setWebseite;
    property ImageUrl: string read fImageUrl write setImageUrl;
    property Match: string read fMatch write setMatch;
    property Nr: String read fNr write setNr;
    property FiNr: String read fFiNr write setFiNr;
    property Fa_Id: Integer read fFaId;
    property Sa_Id: Integer read fSaId write setSaId;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TMySQLQuery); override;
    procedure Save;
    procedure Delete;
  end;

implementation

{ TViewArtikel }

uses
  DB.Artikel, DB.FirmaArtikel;

constructor TViewArtikel.Create(AOwner: TComponent);
begin
  inherited;
  fqry := TMySqlQuery.Create(nil);
  fqry.Database := fQuery.Database;
end;


destructor TViewArtikel.Destroy;
begin
  FreeAndNil(fqry);
  inherited;
end;

function TViewArtikel.getGeneratorName: string;
begin
  Result := 'ar_id';
end;

function TViewArtikel.getTableName: string;
begin
  Result := '';
end;

function TViewArtikel.getTablePrefix: string;
begin
  Result := '';
end;

procedure TViewArtikel.Init;
begin
  inherited;
  fWebseite := '';
  fAr_Id    := 0;
  fImageUrl := '';
  fFi_Id    := 0;
  fMatch    := '';
  fNr       := '';
  fArId     := 0;
  fFaId     := 0;
  fSaId     := 0;
end;

procedure TViewArtikel.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fFi_Id    := aQuery.FieldByName('fa_fi_id').AsInteger;
  fAr_Id    := aQuery.FieldByName('fa_ar_id').AsInteger;
  fImageUrl := aQuery.FieldByName('fa_imageurl').AsString;
  fWebseite := aQuery.FieldByName('fa_webseite').AsString;
  fFiNr     := aQuery.FieldByName('fa_nr').AsString;
  fMatch := aQuery.FieldByName('ar_match').AsString;
  fNr    := aQuery.FieldByName('ar_nr').AsString;
  fArId    := aQuery.FieldByName('ar_id').AsInteger;
  fFaId    := aQuery.FieldByName('fa_id').AsInteger;
  fSaId    := aQuery.FieldByName('ar_sa_id').AsInteger;
end;

procedure TViewArtikel.Save;
var
  Artikel: TDBArtikel;
  FirmaArtikel: TDBFirmaArtikel;
begin
  Artikel := TDBArtikel.Create(nil);
  FirmaArtikel := TDBFirmaArtikel.Create(nil);
  fqry.Close;
  fqry.SQL.Text := 'select * from artikel where ar_id = ' + IntToStr(fArId);
  fqry.Open;
  if not fqry.Eof then
    Artikel.Read(fArId);
  Artikel.Match := fMatch;
  Artikel.Nr    := fNr;
  Artikel.SaId  := fSaId;
  Artikel.Save;

  fqry.Close;
  fqry.SQL.Text := 'select * from firmaartikel where fa_id = ' + IntToStr(fFaId);
  fqry.Open;
  if not fqry.Eof then
    FirmaArtikel.Read(fFaId);
  FirmaArtikel.Fi_Id := fFi_Id;
  FirmaArtikel.Ar_Id := Artikel.Id;
  FirmaArtikel.Webseite := fWebseite;
  FirmaArtikel.ImageUrl := fImageUrl;
  FirmaArtikel.Nr       := ffiNr;
  FirmaArtikel.Save;
  fqry.Close;
  FreeAndNil(Artikel);
  FreeAndNil(FirmaArtikel);
end;

procedure TViewArtikel.setAr_Id(const Value: Integer);
begin
  fAr_Id := Value;
end;

procedure TViewArtikel.setFiNr(const Value: String);
begin
  fFiNr := Value;
end;

procedure TViewArtikel.setFi_Id(const Value: Integer);
begin
  fFi_Id := Value;
end;

procedure TViewArtikel.setImageUrl(const Value: string);
begin
  fImageUrl := Value;
end;

procedure TViewArtikel.setMatch(const Value: string);
begin
  fMatch := Value;
end;

procedure TViewArtikel.setNr(const Value: String);
begin
  fNr := Value;
end;

procedure TViewArtikel.setSaId(const Value: Integer);
begin
  fSaId := Value;
end;

procedure TViewArtikel.setWebseite(const Value: String);
begin
  fWebseite := Value;
end;

procedure TViewArtikel.Delete;
var
  Artikel: TDBArtikel;
begin
  Artikel := TDBArtikel.Create(nil);
  try
    Artikel.Read(farid);
    Artikel.Delete;
  finally
    FreeAndNil(Artikel);
  end;
end;


end.
