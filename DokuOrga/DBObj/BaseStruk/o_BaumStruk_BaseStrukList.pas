unit o_BaumStruk_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_BaumStruk;


type
  TBaumStrukBaseStrukList = class(TDBObjList)
  private
    function GetBaumStruk(Index: Integer): TBaumStruk;
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
    property Item[Index: Integer]: TBaumStruk read GetBaumStruk;
  end;


implementation

{ TBaumStrukBaseStrukList }


constructor TBaumStrukBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBaumStrukBaseStrukList.Destroy;
begin

  inherited;
end;

procedure TBaumStrukBaseStrukList.Init;
begin
  inherited;

end;


function TBaumStrukBaseStrukList.GetBaumStruk(Index: Integer): TBaumStruk;
begin
  Result := TBaumStruk(getItem(Index));
end;

function TBaumStrukBaseStrukList.getGeneratorName: string;
begin
  Result := 'BS_ID';
end;

function TBaumStrukBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBaumStrukBaseStrukList.getTableName: string;
begin
  Result := 'BaumStruk';
end;

function TBaumStrukBaseStrukList.getTablePrefix: string;
begin
  Result := 'BS';
end;


function TBaumStrukBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  BaumStruk: TBaumStruk;
begin
  BaumStruk := TBaumStruk.Create(nil);
  BaumStruk.LoadByQuery(aQuery);
  Result := TDBObj(BaumStruk);
end;


end.
