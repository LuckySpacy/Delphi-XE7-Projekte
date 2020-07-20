unit DB.BenutzerList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, DB.IBBasisList, TBQuery, IBX.IBQuery,
  DB.Benutzer, System.Contnrs;

type
  TDBBenutzerList = class(TDBIBBasisList)
  private
    function getBenutzer(Index: Integer): TDBBenutzer;
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TDBBenutzer;
    property Item[Index: Integer]: TDBBenutzer read getBenutzer;
    procedure Read(aOrder: string); override;
  end;

implementation

{ TDBBenutzerList }

uses
  Objekt.DokuOrga;


constructor TDBBenutzerList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TDBBenutzerList.Destroy;
begin

  inherited;
end;

function TDBBenutzerList.getBenutzer(Index: Integer): TDBBenutzer;
begin
  Result := nil;
  if Index > fList.Count then
    exit;
  Result := TDBBenutzer(fList.Items[Index]);
end;

function TDBBenutzerList.getGeneratorName: string;
begin
  Result := 'BE_ID';
end;

function TDBBenutzerList.getTableName: string;
begin
  Result := 'BENUTZER';
end;

function TDBBenutzerList.getTablePrefix: string;
begin
  Result := 'BE';
end;

procedure TDBBenutzerList.Read(aOrder: string);
var
  x: TDBBenutzer;
begin
  inherited;
  while not fTBQuery.Eof do
  begin
    x := Add;
    x.LoadByQuery(fTBQuery);
    fTBQuery.Next;
  end;
  fTBQuery.Close;
  fTBQuery.TBTrans.RollbackTrans;
end;

function TDBBenutzerList.Add: TDBBenutzer;
begin
  Result := TDBBenutzer.Create(nil);
  fList.Add(Result);
end;


end.
