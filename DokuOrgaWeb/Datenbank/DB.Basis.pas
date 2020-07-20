unit DB.Basis;

interface

uses
  SysUtils, Classes, Objekt.DBFeldList, Data.db, vcl.Dialogs, DB.SqlStatement,
  DB.IBZugriff, TBQuery, TBTrans;

type
  TDBBasis = class(TComponent)
  private
    fSql: TDBSqlStatement;
    fOnAfterExecSql: TNotifyEvent;
    fOnNewTransaction: TNotifyEvent;
    procedure FuelleHistorieDBFelder;
    procedure setTrans(const Value: TTBTrans);
    procedure setUseInterbase(const Value: Boolean);
    procedure setUseWWW(const Value: Boolean);
  protected
    fUseInterbase: Boolean;
    fUseWWW: Boolean;
    fIBZugriff: TIBZugriff;
    fTrans: TTBTrans;
    fTBQuery: TTBQuery;
    fId: Integer;
    fUpdate: string;
    fDelete: string;
    fDoUpdate: Boolean;
    fFeldList: TDBFeldList;
    fFeldListHis: TDBFeldList;
    fGefunden: Boolean;
    fNeu: Boolean;
    fGeloescht: Boolean;
    fWasOpen: Boolean;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    procedure UpdateV(var aOldValue: string; aNewValue: string); overload;
    procedure UpdateV(var aOldValue: Integer; aNewValue: Integer); overload;
    procedure UpdateV(var aOldValue: Boolean; aNewValue: Boolean); overload;
    procedure UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime); overload;
    procedure UpdateV(var aOldValue: extended; aNewValue: extended); overload;
    procedure LegeHistorieFelderAn;
    procedure FuelleDBFelder; virtual;
    property OnAfterExecSql: TNotifyEvent read fOnAfterExecSql write fOnAfterExecSql;
    property OnNewTransaction: TNotifyEvent read fOnNewTransaction write fOnNewTransaction;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; virtual;
    procedure LoadByQuery(aQuery: TTBQuery); virtual;
    property Id: Integer read fId;
    property Trans: TTBTrans read fTrans write setTrans;
    property FeldList: TDBFeldList read fFeldList write fFeldList;
    property Gefunden: Boolean read fGefunden;
    procedure Read(aId: Integer); virtual;
    function Delete: Boolean; virtual;
    procedure SaveToDB; virtual;
    function GenerateId: Integer;
    property UseInterbase: Boolean read fUseInterbase write setUseInterbase;
    property UseWWW: Boolean read fUseWWW write setUseWWW;
  end;

implementation

{ TDBBasis }

uses
  System.UITypes, Objekt.DokuOrga;


constructor TDBBasis.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fIBZugriff := TIBZugriff.Create;
  fSql := TDBSqlStatement.Create;
  fTBQuery := TTBQuery.Create(nil);
  fFeldList := TDBFeldList.Create(nil);
  fFeldList.Tablename := getTableName;
  fFeldList.PrimaryKey := getGeneratorName;
  fFeldList.TablePrefix := getTablePrefix;
  fFeldList.Add(getGeneratorName, ftInteger);
  // fFeldList.Add(getTablePrefix+'_UPDATE', ftString);
  fFeldList.Add(getTablePrefix+'_DELETE', ftString);

  fFeldListHis := TDBFeldList.Create(nil);
  fWasOpen := false;

  fUseInterbase := DokuOrga.IBDatenbank.UseInterbase;

end;

destructor TDBBasis.Destroy;
begin
  FreeAndNil(fSql);
  FreeAndNil(fIBZugriff);
  FreeAndNil(fTBQuery);
  FreeAndNil(fFeldList);
  FreeAndNil(fFeldListHis);
  inherited;
end;


function TDBBasis.GenerateId: Integer;
begin
  Result := 0;
  if UseInterbase then
    Result := fIBZugriff.GenerateId(fSql.Generate(getGeneratorName));
end;


procedure TDBBasis.Init;
begin
  fId := 0;
  fGeloescht := false;
  fGefunden := false;
  fDoUpdate := false;
  fUpdate := 'T';
  fDelete := 'F';
end;

procedure TDBBasis.LegeHistorieFelderAn;
var
  i1: Integer;
begin
  fFeldListHis.Clear;
  for i1 := 0 to fFeldList.Count -1 do
    fFeldListHis.Add(fFeldList.Feld[i1].Feldname, ftString);
end;

procedure TDBBasis.FuelleDBFelder;
begin
  //fFeldList.FieldByName(getTablePrefix+'_UPDATE').AsString := fUpdate;
  fFeldList.FieldByName(getTablePrefix+'_DELETE').AsString := fDelete;
  fFeldList.FieldByName(getGeneratorName).AsInteger := fId;
  FuelleHistorieDBFelder;
end;


procedure TDBBasis.FuelleHistorieDBFelder;
var
  i1: Integer;
begin
  if fFeldListHis.Count <> fFeldList.Count then
    exit;
  for i1 := 0 to fFeldList.Count -1 do
    fFeldListHis.FieldByName(fFeldList.Feld[i1].Feldname).AsString := fFeldList.Feld[i1].AsString;
end;

procedure TDBBasis.LoadByQuery(aQuery: TTBQuery);
begin
  Init;
  if fUseInterbase then
  begin
    fGefunden := not aQuery.IBQuery.Eof;
    if aQuery.IBQuery.Eof then
      exit;
    fId := aQuery.IBQuery.FieldByName(getGeneratorName).AsInteger;
    //fUpdate := aQuery.IBQuery.FieldByName(getTablePrefix+'_UPDATE').AsString;
    fDelete := aQuery.IBQuery.FieldByName(getTablePrefix+'_DELETE').AsString;
  end;
end;



function TDBBasis.Delete: Boolean;
begin
  Result := false;
  if fUseInterbase then
  begin
    fIBZugriff.Trans := fTrans;
    Result := fIBZugriff.Delete(fFeldList.DeleteStatement);
  end;
  fGeloescht := Result;
end;

procedure TDBBasis.SaveToDB;
var
  Sql: string;
begin
  if not Assigned(fTrans) then
    exit;
  if (not fDoUpdate) and (fId > 0) then
    exit;
  fNeu := false;
  fDoUpdate := false;
  fGeloescht := false;
  if fId = 0 then
  begin
    fid := GenerateId;
    fFeldList.FieldByName(getGeneratorName).AsInteger := fId;
    //fFeldList.FieldByName(getTablePrefix+'_UPDATE').AsString := fUpdate;
    fFeldList.FieldByName(getTablePrefix+'_DELETE').AsString := fDelete;
    Sql := fFeldList.InsertStatement;
    fNeu:= true;
  end
  else
    Sql := fFeldList.UpdateStatement;

  if UseInterbase then
  begin
    if not fIBZugriff.SaveToDB(Sql) then
      exit;
  end;

  FuelleHistorieDBFelder;
  fFeldList.SetChangedToAll(false);

end;


procedure TDBBasis.setTrans(const Value: TTBTrans);
begin
  fTrans := Value;
  fIBZugriff.Trans := Value;
  if Assigned(fOnNewTransaction) then
    fOnNewTransaction(nil);
end;

procedure TDBBasis.setUseInterbase(const Value: Boolean);
begin
  fUseInterbase := Value;
  if Value then
    fUseWWW := false;
end;

procedure TDBBasis.setUseWWW(const Value: Boolean);
begin
  fUseWWW := Value;
  if Value then
    fUseInterbase := false;
end;

procedure TDBBasis.UpdateV(var aOldValue: Boolean; aNewValue: Boolean);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TDBBasis.UpdateV(var aOldValue: Integer; aNewValue: Integer);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TDBBasis.UpdateV(var aOldValue: string; aNewValue: string);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TDBBasis.UpdateV(var aOldValue: TDateTime; aNewValue: TDateTime);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TDBBasis.UpdateV(var aOldValue: extended; aNewValue: extended);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;


procedure TDBBasis.Read(aId: Integer);
begin
  Init;
  if fUseInterbase then
  begin
    if not Assigned(fTrans) then
      exit;
    fIBZugriff.OnLoadByQuery := LoadByQuery;
    fIBZugriff.Read('select * from ' + getTableName + ' where ' + getGeneratorName + '=' + IntToStr(aId));
  end;
end;

end.
