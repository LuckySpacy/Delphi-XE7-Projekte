unit DB.Historietext;

interface

uses
  SysUtils, Classes, TBQuery, DB.Basis, Data.db;

type
  TDBHistorietext = class(TDBBasis)
  private
    fBE_ID: Integer;
    fInfo: string;
    fDatum: TDateTime;
    fEvent_ID: Integer;
    fTimeStamp: string;
    procedure setDatum(const Value: TDateTime);
    procedure setEvent_ID(const Value: Integer);
    procedure setInfo(const Value: string);
    procedure setBE_ID(const Value: Integer);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    procedure FuelleDBFelder; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TTBQuery); override;
    procedure SaveToDB; override;
    property Datum: TDateTime read fDatum write setDatum;
    property TimeStamp: string read fTimeStamp;
    property BE_ID: Integer read fBE_ID write setBE_ID;
    property Event_ID: Integer read fEvent_ID write setEvent_ID;
    property Info: string read fInfo write setInfo;
  end;

implementation

{ TDBHistorietext }

constructor TDBHistorietext.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('HT_DATUM', ftDateTime);
  FFeldList.Add('HT_MA_ID', ftInteger);
  FFeldList.Add('HT_EVENT_ID', ftInteger);
  FFeldList.Add('HT_INFO', ftString);
  FFeldList.Add('HT_TIMESTAMP', ftString);
  Init;
end;

destructor TDBHistorietext.Destroy;
begin

  inherited;
end;

procedure TDBHistorietext.Init;
begin
  inherited;
  fBE_ID    := 0;
  fInfo     := '';
  fDatum    := 0;
  fEvent_ID := 0;
  fTimeStamp := '';
end;


procedure TDBHistorietext.FuelleDBFelder;
begin
  fFeldList.FieldByName('HT_ID').AsInteger        := fID;
  fFeldList.FieldByName('HT_DATUM').AsDateTime    := fDatum;
  fFeldList.FieldByName('HT_EVENT_ID').AsDateTime := fEvent_Id;
  fFeldList.FieldByName('HT_INFO').AsString       := fInfo;
  fFeldList.FieldByName('HT_BE_ID').AsInteger     := fBE_ID;
  fFeldList.FieldByName('HT_TIMESTAMP').AsString  := fTimeStamp;
  inherited;
end;

function TDBHistorietext.getGeneratorName: string;
begin
  Result := 'HT_ID';
end;

function TDBHistorietext.getTableName: string;
begin
  Result := 'HISTORIETEXT';
end;

function TDBHistorietext.getTablePrefix: string;
begin
  Result := 'HT';
end;


procedure TDBHistorietext.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if fUseInterbase then
  begin
    if aQuery.IBQuery.Eof then
      exit;
    fDatum     := aQuery.IBQuery.FieldByName('HT_DATUM').AsDateTime;
    fEvent_ID  := aQuery.IBQuery.FieldByName('HT_EVENT_ID').AsInteger;
    fInfo      := aQuery.IBQuery.FieldByName('HT_INFO').AsString;
    fBE_ID     := aQuery.IBQuery.FieldByName('HT_BE_ID').AsInteger;
    fTimeStamp := aQuery.IBQuery.FieldByName('HT_TIMESTAMP').AsString;
  end;
  FuelleDBFelder;
end;

procedure TDBHistorietext.SaveToDB;
begin
  setDatum(now);
  fTimeStamp := FormatDateTime('yyyymmddhhnnsszzz', fDatum);
  fFeldList.FieldByName('HT_TIMESTAMP').AsString := fTimeStamp;
  inherited;
end;

procedure TDBHistorietext.setBE_ID(const Value: Integer);
begin
  UpdateV(fBE_ID, Value);
  fFeldList.FieldByName('HT_BE_ID').AsInteger := fBE_ID;
end;
procedure TDBHistorietext.setDatum(const Value: TDateTime);
begin
  UpdateV(fDatum, Value);
  fFeldList.FieldByName('HT_DATUM').AsDateTime := fDatum;
end;


procedure TDBHistorietext.setEvent_ID(const Value: Integer);
begin
  UpdateV(fEvent_ID, Value);
  fFeldList.FieldByName('HT_EVENT_ID').AsInteger := fEvent_ID;
end;

procedure TDBHistorietext.setInfo(const Value: string);
begin
  UpdateV(fInfo, Value);
  fFeldList.FieldByName('HT_INFO').AsString := fInfo;
end;

end.
