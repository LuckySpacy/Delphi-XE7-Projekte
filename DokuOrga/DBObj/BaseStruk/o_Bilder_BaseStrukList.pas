unit o_Bilder_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Bilder;


type
  TBilderBaseStrukList = class(TDBObjList)
  private
    function GetBilder(Index: Integer): TBilder;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function getNotifyIndex: Integer; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TBilder read GetBilder;
  end;


implementation

{ TBilderBaseStrukList }


constructor TBilderBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  init;
end;

destructor TBilderBaseStrukList.Destroy;
begin

  inherited;
end;

function TBilderBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Bilder: TBilder;
begin
  Bilder := TBilder.Create(nil);
  Bilder.LoadByQuery(aQuery);
  Result := TDBObj(Bilder);
end;


function TBilderBaseStrukList.GetBilder(Index: Integer): TBilder;
begin
  Result := TBilder(getItem(Index));
end;

function TBilderBaseStrukList.getGeneratorName: string;
begin
  Result := 'BI_ID';
end;

function TBilderBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBilderBaseStrukList.getTableName: string;
begin
  Result := 'Bilder';
end;

function TBilderBaseStrukList.getTablePrefix: string;
begin
  Result := 'BI';
end;

procedure TBilderBaseStrukList.Init;
begin
  inherited;

end;

end.
