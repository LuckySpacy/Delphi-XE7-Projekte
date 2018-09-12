unit o_Seite_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Seite;


type
  TSeiteBaseStrukList = class(TDBObjList)
  private
    function GetSeite(Index: Integer): TSeite;
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
    property Item[Index: Integer]: TSeite read GetSeite;
  end;


implementation


{ TSeiteBaseStrukList }


constructor TSeiteBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TSeiteBaseStrukList.Destroy;
begin

  inherited;
end;

function TSeiteBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Seite: TSeite;
begin
  Seite := TSeite.Create(nil);
  Seite.LoadByQuery(aQuery);
  Result := TDBObj(Seite);
end;


function TSeiteBaseStrukList.GetSeite(Index: Integer): TSeite;
begin
  Result := TSeite(getItem(Index));
end;

function TSeiteBaseStrukList.getGeneratorName: string;
begin
  Result := 'SE_ID';
end;

function TSeiteBaseStrukList.getTableName: string;
begin
  Result := 'Seite';
end;

function TSeiteBaseStrukList.getTablePrefix: string;
begin
  Result := 'SE';
end;

procedure TSeiteBaseStrukList.Init;
begin
  inherited;

end;

end.
