unit Model.Kommentar;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Model.Basis, Data.db;

type
  TKommentar = class(TBasisModel)
  private
    fFont: string;
    fEndezeichen: string;
    fStartzeichen: string;
    fSort: Integer;
    procedure FuelleDBFelder;
    procedure setFont(const Value: string);
    procedure setEndezeichen(const Value: string);
    procedure setStartzeichen(const Value: string);
    procedure setSort(const Value: Integer);
  protected
    fWasOpen: Boolean;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property StartZeichen: string read fStartzeichen write setStartzeichen;
    property EndeZeichen: string read fEndezeichen write setEndezeichen;
    property Sort: Integer read fSort write setSort;
    property Font: string read fFont write setFont;
  end;

implementation

{ TKommentar }

constructor TKommentar.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('KO_STARTZEICHEN', ftString);
  fFeldList.Add('KO_ENDEZEICHEN', ftString);
  fFeldList.Add('KO_FONT', ftString);
  fFeldList.Add('KO_SORT', ftInteger);
end;

destructor TKommentar.Destroy;
begin

  inherited;
end;

procedure TKommentar.FuelleDBFelder;
begin
  fFeldList.FieldByName('KO_ID').AsInteger          := fID;
  fFeldList.FieldByName('KO_STARTZEICHEN').AsString := fStartzeichen;
  fFeldList.FieldByName('KO_ENDEZEICHEN').AsString  := fEndezeichen;
  fFeldList.FieldByName('KO_FONT').AsString         := fFont;
end;

function TKommentar.getGeneratorName: string;
begin
  Result := 'KO_ID';
end;

function TKommentar.getTableName: string;
begin
  Result := 'KOMMENTAR';
end;

function TKommentar.getTablePrefix: string;
begin
  Result := 'KO';
end;

procedure TKommentar.Init;
begin
  inherited;
  EndeZeichen  := '';
  StartZeichen := '';
  Font := '';
  Sort := 0;
end;

procedure TKommentar.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId           := aQuery.FieldByName('ko_id').AsInteger;
  fStartzeichen := aQuery.FieldByName('ko_startzeichen').AsString;
  fEndezeichen  := aQuery.FieldByName('ko_endezeichen').AsString;
  fFont         := aQuery.FieldByName('ko_font').AsString;
  fSort         := aQuery.FieldByName('ko_sort').AsInteger;
  FuelleDBFelder;
end;

procedure TKommentar.setEndezeichen(const Value: string);
begin
  UpdateV(fStartzeichen, Value);
  fFeldList.FieldByName('KO_ENDEZEICHEN').AsString := Value;
end;

procedure TKommentar.setFont(const Value: string);
begin
  UpdateV(fFont, Value);
  fFeldList.FieldByName('KO_FONT').AsString := Value;
end;

procedure TKommentar.setSort(const Value: Integer);
begin
  UpdateV(fSort, Value);
  fFeldList.FieldByName('KO_SORT').AsInteger := Value;
end;

procedure TKommentar.setStartzeichen(const Value: string);
begin
  UpdateV(fStartzeichen, Value);
  fFeldList.FieldByName('KO_STARTZEICHEN').AsString := Value;
end;


end.
