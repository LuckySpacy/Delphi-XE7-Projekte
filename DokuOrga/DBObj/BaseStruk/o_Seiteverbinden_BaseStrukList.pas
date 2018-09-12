unit o_Seiteverbinden_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Seiteverbinden;


type
  TSeiteverbindenBaseStrukList = class(TDBObjList)
  private
    function GetSeiteverbinden(Index: Integer): TSeiteverbinden;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TSeiteverbinden read GetSeiteverbinden;
  end;

implementation

{ TSeiteDokumentBaseStrukList }

constructor TSeiteverbindenBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteverbindenBaseStrukList.Destroy;
begin

  inherited;
end;


function TSeiteverbindenBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Seiteverbinden: TSeiteverbinden;
begin
  Seiteverbinden := TSeiteverbinden.Create(nil);
  Seiteverbinden.Trans := FTrans;
  Seiteverbinden.LoadByQuery(aQuery);
  Result := TDBObj(Seiteverbinden);
end;


function TSeiteverbindenBaseStrukList.GetSeiteverbinden(
  Index: Integer): TSeiteverbinden;
begin
  Result := TSeiteverbinden(getItem(Index));
end;

function TSeiteverbindenBaseStrukList.getGeneratorName: string;
begin
  Result := 'VS_ID';
end;

function TSeiteverbindenBaseStrukList.getTableName: string;
begin
  Result := 'SEITEVERBINDUNG';
end;

function TSeiteverbindenBaseStrukList.getTablePrefix: string;
begin
  Result := 'VS';
end;

procedure TSeiteverbindenBaseStrukList.Init;
begin
  inherited;

end;



end.
