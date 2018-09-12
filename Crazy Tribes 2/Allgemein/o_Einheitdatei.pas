unit o_Einheitdatei;

interface

uses
  SysUtils, Classes, o_EinheitdateiObj, contnrs;


type
  TEinheitdatei = class(TObject)
  private
    FList: TStringList;
    FEinheitList: TObjectList;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Load(aFilename: string);
    function getEinheitdateiObj(x, y: Integer): TEinheitdateiObj;
  end;


implementation

{ TEinheit }

constructor TEinheitdatei.Create;
begin
  inherited;
  FList := TStringList.Create;
  FEinheitList := TObjectList.Create;
end;

destructor TEinheitdatei.Destroy;
begin
  FreeAndNil(FList);
  FreeAndNil(FEinheitList);
  inherited;
end;

function TEinheitdatei.getEinheitdateiObj(x, y: Integer): TEinheitdateiObj;
var
  i1: Integer;
  EinheitObj: TEinheitdateiObj;
begin
  Result := nil;
  for i1 := 0 to FEinheitList.Count - 1 do
  begin
    EinheitObj := TEinheitdateiObj(FEinheitList.Items[i1]);
    if (EinheitObj.Koordinate.X = x) and (EinheitObj.Koordinate.Y = y) then
    begin
      Result := EinheitObj;
      exit;
    end;
  end;
end;

procedure TEinheitdatei.Load(aFilename: string);
var
  i1: Integer;
  Einheit: TEinheitdateiObj;
begin
  FList.Clear;
  if not FileExists(aFilename) then
    exit;
  FList.LoadFromFile(aFilename);
  for i1 := 0 to FList.Count - 1 do
  begin
    Einheit := TEinheitdateiObj.Create;
    FEinheitList.Add(Einheit);
    Einheit.setValue(FList.Strings[i1]);
  end;
end;

end.

