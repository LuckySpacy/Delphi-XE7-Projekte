unit DB.Base;

interface

uses
  System.SysUtils, System.Classes, Data.DB, mySQLDbTables;

type
  TDBBase = class(TComponent)
  private
  protected
    fId: Integer;
    fGefunden: Boolean;
    fDoUpdate: Boolean;
    fQuery: TMySqlQuery;
    function getGeneratorName: string; virtual; abstract;
    function getTableName: string; virtual; abstract;
    function getTablePrefix: string; virtual; abstract;
    procedure UpdateV(var aOldValue: string; aNewValue: string); overload;
    procedure UpdateV(var aOldValue: Integer; aNewValue: Integer); overload;
    procedure UpdateV(var aOldValue: Boolean; aNewValue: Boolean); overload;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Id: Integer read fId;
    procedure LoadByQuery(aQuery: TMySQLQuery); virtual;
    procedure Init; virtual;
    procedure Read(aId: Integer); virtual;
  end;

implementation

{ TDBBase }

uses
  System.UITypes, dm.Datenmodul;

constructor TDBBase.Create(AOwner: TComponent);
begin
  inherited;
  fQuery := TMySqlQuery.Create(nil);
  fQuery.Database := dam.db;
  Init;
end;

destructor TDBBase.Destroy;
begin
  FreeAndNil(fQuery);
  inherited;
end;

procedure TDBBase.Init;
begin
  fId := 0;
  fGefunden := false;
  fDoUpdate := false;
end;

procedure TDBBase.LoadByQuery(aQuery: TMySQLQuery);
begin
  Init;
  fGefunden := not aQuery.Eof;
  if aQuery.Eof then
    exit;
  fId := aQuery.FieldByName(getGeneratorName).AsInteger;
end;

procedure TDBBase.Read(aId: Integer);
begin
  fQuery.Close;
  fQuery.SQL.Text := 'select * from ' + getTableName + ' where ' + getTablePrefix + '_Id = ' + IntToStr(aId);
  fQuery.Open;
end;

procedure TDBBase.UpdateV(var aOldValue: string; aNewValue: string);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TDBBase.UpdateV(var aOldValue: Integer; aNewValue: Integer);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

procedure TDBBase.UpdateV(var aOldValue: Boolean; aNewValue: Boolean);
begin
  if not fDoUpdate then
    fDoUpdate := aOldValue <> aNewValue;
  aOldValue := aNewValue;
end;

end.
