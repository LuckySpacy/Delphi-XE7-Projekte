unit DB.Historie;

interface

uses
  SysUtils, Classes, TBQuery, DB.Basis, Data.db,
  c.Historie;

type
  TDBHistorie = class(TDBBasis)
  private
    fHT_ID: Integer;
    fTabelleId: Integer;
    fFremd_ID: Integer;
    fHistorieTabelleID: THistorieTabelleID;
    fHistorieEvent: THistorieEvent;
    procedure setFremd_ID(const Value: Integer);
    procedure setHT_ID(const Value: Integer);
    procedure setTabelleId(const Value: Integer);
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
    property TabelleId: Integer read fTabelleId write setTabelleId;
    property HT_ID: Integer read fHT_ID write setHT_ID;
    property Fremd_ID: Integer read fFremd_ID write setFremd_ID;
    property HistorieTabelleId: THistorieTabelleID read fHistorieTabelleID;
    property HistorieEvent: THistorieEvent read fHistorieEvent;
  end;


implementation

{ TDBHistorie }

uses
  Vcl.Dialogs;

constructor TDBHistorie.Create(AOwner: TComponent);
begin
  inherited;
  FFeldList.Add('HI_TABELLEID', ftInteger);
  FFeldList.Add('HI_HT_ID', ftInteger);
  FFeldList.Add('HI_FREMD_ID', ftInteger);
  Init;
end;

destructor TDBHistorie.Destroy;
begin

  inherited;
end;

procedure TDBHistorie.Init;
begin
  inherited;
  fTabelleId := 0;
  fHT_ID     := 0;
  fFremd_Id  := 0;
end;


procedure TDBHistorie.FuelleDBFelder;
begin
  fFeldList.FieldByName('HI_ID').AsInteger        := fID;
  fFeldList.FieldByName('HI_TABELLEID').AsInteger := fTabelleId;
  fFeldList.FieldByName('HI_HT_ID').AsInteger     := fHT_ID;
  fFeldList.FieldByName('HI_FREMD_ID').AsInteger  := fFremd_ID;
  inherited;
end;

function TDBHistorie.getGeneratorName: string;
begin
  Result := 'HI_ID';
end;

function TDBHistorie.getTableName: string;
begin
  Result := 'HISTORIE';
end;

function TDBHistorie.getTablePrefix: string;
begin
  Result := 'HI';
end;


procedure TDBHistorie.LoadByQuery(aQuery: TTBQuery);
begin
  inherited;
  if fUseInterbase then
  begin
    if aQuery.IBQuery.Eof then
      exit;
    fID        := aQuery.IBQuery.FieldByName('hi_id').AsInteger;
    fTabelleId := aQuery.IBQuery.FieldByName('HI_TABELLEID').AsInteger;
    fHT_ID     := aQuery.IBQuery.FieldByName('HI_HT_ID').AsInteger;
    fFremd_ID  := aQuery.IBQuery.FieldByName('HI_FREMD_ID').AsInteger;
  end;
  FuelleDBFelder;
end;

procedure TDBHistorie.SaveToDB;
begin
  inherited;

end;

procedure TDBHistorie.setFremd_ID(const Value: Integer);
begin
  fFremd_ID := Value;
  fFeldList.FieldByName('HI_FREMD_ID').AsInteger := Value;
end;

procedure TDBHistorie.setHT_ID(const Value: Integer);
begin
  fHT_ID := Value;
  fFeldList.FieldByName('HI_HT_ID').AsInteger := Value;
end;

procedure TDBHistorie.setTabelleId(const Value: Integer);
begin
  fTabelleId := Value;
  fFeldList.FieldByName('HI_TABELLEID').AsInteger := Value;
end;

end.
