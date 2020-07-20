unit DB.Benutzer;

interface

uses
  SysUtils, Classes, DB.Basis, Data.db, DB.BasisHistorie, TBQuery;

type
  TDBBenutzer = class(TDBBasisHistorie)
  private
    fPasswort: string;
    fNachname: string;
    fVorname: string;
    fLogin: string;
    procedure HistorieText(aFieldname: string; var aHistorieText: string; var aEventId: Integer);
    procedure setLogin(const Value: string);
    procedure setNachname(const Value: string);
    procedure setPasswort(const Value: string);
    procedure setVorname(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getTableId: Integer; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TTBQuery); override;
    property Vorname: string read fVorname write setVorname;
    property Nachname: string read fNachname write setNachname;
    property Login: string read fLogin write setLogin;
    property Passwort: string read fPasswort write setPasswort;
    function Delete: Boolean; override;
  end;


implementation

{ TDBBenutzer }

constructor TDBBenutzer.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('BE_VORNAME', ftString);
  FFeldList.Add('BE_NACHNAME', ftString);
  FFeldList.Add('BE_LOGIN', ftString);
  FFeldList.Add('BE_PW', ftString);
  OnGetHistorieText := HistorieText;
  //OnNewTransaction  := NewTransaction;
  LegeHistorieFelderAn;
  Init;
end;

destructor TDBBenutzer.Destroy;
begin

  inherited;
end;


procedure TDBBenutzer.Init;
begin
  inherited;
  fPasswort := '';
  fNachname := '';
  fVorname  := '';
  fLogin    := '';
  FuelleDBFelder;
end;

function TDBBenutzer.getTableId: Integer;
begin
  Result := fHistorie.HistorieTabelleId.Benutzer;
end;

function TDBBenutzer.getTableName: string;
begin
  Result := 'BENUTZER';
end;

function TDBBenutzer.getGeneratorName: string;
begin
  Result := 'BE_ID';
end;

function TDBBenutzer.getTablePrefix: string;
begin
  Result := 'BE';
end;

procedure TDBBenutzer.FuelleDBFelder;
begin
  fFeldList.FieldByName('BE_VORNAME').AsString  := fVorname;
  fFeldList.FieldByName('BE_NACHNAME').AsString := fNachname;
  fFeldList.FieldByName('BE_LOGIN').AsString    := fLogin;
  fFeldList.FieldByName('BE_PW').AsString       := fPasswort;
  inherited;
end;

procedure TDBBenutzer.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if fUseInterbase then
  begin
    if aQuery.IBQuery.Eof then
      exit;
    fVorname  := aQuery.IBQuery.FieldByName('BE_VORNAME').AsString;
    fNachname := aQuery.IBQuery.FieldByName('BE_NACHNAME').AsString;
    fLogin    := aQuery.IBQuery.FieldByName('BE_LOGIN').AsString;
    fPasswort := aQuery.IBQuery.FieldByName('BE_PW').AsString;
  end;
  FuelleDBFelder;
end;



function TDBBenutzer.Delete: Boolean;
begin
  Result := inherited;
end;


procedure TDBBenutzer.HistorieText(aFieldname: string;
  var aHistorieText: string; var aEventId: Integer);
begin
  if fHistorie.HistorieEvent.Angelegt = aEventId then
  begin
    aHistorieText := 'Lizenztyp wurde angelegt.';
    exit;
  end;

  if fHistorie.HistorieEvent.Geloescht = aEventId then
  begin
    aHistorieText := 'Lizenztyp wurde gelöscht.';
    exit;
  end;
end;



procedure TDBBenutzer.setLogin(const Value: string);
begin
  UpdateV(fLogin, Value);
  fFeldList.FieldByName('BE_LOGIN').AsString := Value;
end;

procedure TDBBenutzer.setNachname(const Value: string);
begin
  UpdateV(fNachname, Value);
  fFeldList.FieldByName('BE_NACHNAME').AsString := Value;
end;

procedure TDBBenutzer.setPasswort(const Value: string);
begin
  UpdateV(fPasswort, Value);
  fFeldList.FieldByName('BE_PW').AsString := Value;
end;

procedure TDBBenutzer.setVorname(const Value: string);
begin
  fVorname := Value;
  UpdateV(fVorname, Value);
  fFeldList.FieldByName('BE_VORNAME').AsString := Value;
end;

end.
