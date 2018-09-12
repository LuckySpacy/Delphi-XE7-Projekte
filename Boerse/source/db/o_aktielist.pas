unit o_aktielist;

interface

uses
  Classes, IBDatabase, IBQuery, Dialogs, ContNrs, SysUtils, o_db, o_Field, o_aktie, o_dblist;

type TAktieList = class(TDBList)
  private
    function GetAktie(Index: Integer): TAktie;
  protected
  published
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LoadAll;
    property Aktie[Index: Integer]: TAktie read GetAktie;
  end;


implementation

{ TAktieList }

uses
  untDM;

constructor TAktieList.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

destructor TAktieList.Destroy;
begin
  inherited;
end;

function TAktieList.GetAktie(Index: Integer): TAktie;
begin
  Result := nil;
  if Index > FList.Count -1 then
    exit;
  Result := TAktie(FList.Items[Index]);
end;

procedure TAktieList.LoadAll;
var
  Aktie: TAktie;
begin
  if FIBT.InTransaction then
    FIBT.Rollback;
  FList.Clear;
  FQuery.Close;
  FQuery.SQL.Text := ' select * from aktie order by ak_name';
  FIBT.StartTransaction;
  try
    FQuery.Open;
    while not FQuery.Eof do
    begin
      Aktie := TAktie.Create(Self, nil);
      Aktie.WKN.AsString  := FQuery.FieldByName('ak_wkn').AsString;
      Aktie.Name.AsString := FQuery.FieldByName('ak_name').AsString;
      Aktie.ID            := FQuery.FieldByName('ak_id').AsInteger;
      Aktie.Transaction   := FIBT;
      FList.Add(Aktie);
      FQuery.Next;
    end;
  finally
    FIBT.Rollback;
  end;
end;

end.
