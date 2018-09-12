unit o_styleobj;

interface

uses
  sysutils, Classes, vcl.Graphics, Contnrs;

type
  TStyleObj = class
  private
    FKommandoList: TStringList;
    FWortList: TStringList;
    FFontStr: string;
    FWortEndeList: TStringList;
    FKommandostart: string;
    FKommandoende: string;
    FWortanfangList: TStringList;
    FAnfangEndeEgal: Boolean;
  public
    constructor Create;
    destructor Destroy; override;
    property FontStr: string read FFontStr write FFontStr;
    property WortList: TStringList read FWortList write FWortList;
    property WortendeList: TStringList read FWortEndeList write FWortEndeList;
    property WortanfangList: TStringList read FWortanfangList write FWortanfangList;
    property Kommandostart: string read FKommandostart write FKommandostart;
    property Kommandoende: string read FKommandoende write FKommandoende;
    property AnfangEndeEgal: Boolean read FAnfangEndeEgal write FAnfangEndeEgal;
  end;

type
  TStyleObjList = class
  private
    FFontStr: string;
    function GetCount: Integer;
    function GetStyleObj(Index: Integer): TStyleObj;
  protected
    _List: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    property FontStr: string read FFontStr write FFontStr;
    function Add: TStyleObj;
    property Item[Index: Integer]: TStyleObj read GetStyleObj;
  end;

implementation

{ TStyleObj }

constructor TStyleObj.Create;
begin
  FWortList := TStringList.Create;
  FWortEndeList := TStringList.Create;
  FWortanfangList := TStringList.Create;
  FKommandoList := TStringList.Create;
  FFontStr := '';
  FKommandostart := '';
  FKommandoende := '';
  FAnfangEndeEgal := false;
end;

destructor TStyleObj.Destroy;
begin
  FreeAndNil(FWortList);
  FreeAndNil(FWortEndeList);
  FreeAndNil(FWortanfangList);
  FreeAndNil(FKommandoList);
  inherited;
end;

{ TStyleObjList }


constructor TStyleObjList.Create;
begin
  _List := TObjectList.Create;
  FFontStr := '';
end;

destructor TStyleObjList.Destroy;
begin
  FreeAndNil(_List);
  inherited;
end;

function TStyleObjList.GetCount: Integer;
begin
  Result := _List.Count;
end;

function TStyleObjList.GetStyleObj(Index: Integer): TStyleObj;
begin
  Result := nil;
  if Index > _List.Count -1 then
    exit;
  Result := TStyleObj(_List[Index]);
end;

function TStyleObjList.Add: TStyleObj;
begin
  Result := TStyleObj.Create;
  _List.Add(Result);
end;


end.
