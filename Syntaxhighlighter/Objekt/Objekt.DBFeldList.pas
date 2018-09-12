unit Objekt.DBFeldList;

interface

uses
  SysUtils, Classes, Objekt.BasisList, Objekt.DBFeld, Data.DB, System.Contnrs;

type
  TDBFeldList = class(TBaseList)
  private
    _Tablename: string;
    _PrimaryKey: string;
    function getFeld(aIndex: Integer): TDBFeld;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(aName: string; aDataType: TFieldType): TDBFeld;
    function FieldByName(aName: string): TDBFeld;
    property Feld[aIndex: Integer]: TDBFeld read getFeld;
    property Tablename: string read _Tablename write _Tablename;
    property PrimaryKey: string read _PrimaryKey write _PrimaryKey;
    function InsertStatement: string;
    function UpdateStatement: string;
    function DeleteStatement: string;
  end;




implementation

{ TDBFeldList }

constructor TDBFeldList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TDBFeldList.Destroy;
begin

  inherited;
end;



function TDBFeldList.Add(aName: string; aDataType: TFieldType): TDBFeld;
begin
  Result := TDBFeld.Create(nil);
  Result.Feldname := aName;
  Result.DataType := aDataType;
  _List.Add(Result);
end;


function TDBFeldList.FieldByName(aName: string): TDBFeld;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to _List.Count -1 do
  begin
    if SameText(Feld[i1].Feldname, aName) then
    begin
      Result := Feld[i1];
      exit;
    end;
  end;
end;

function TDBFeldList.getFeld(aIndex: Integer): TDBFeld;
begin
  Result := nil;
  if aIndex > _List.Count then
    exit;
  Result := TDBFeld(_List.Items[aIndex]);
end;

function TDBFeldList.InsertStatement: string;
var
  s: string;
  i1: Integer;
begin
  s := '';
  for i1 := 0 to _List.Count -1 do
  begin
    if SameText(_PrimaryKey, Feld[i1].Feldname) then
      continue;
    s := s + Feld[i1].Feldname + ', ';
  end;
  s := copy(s, 1, Length(s)-2);
  Result := 'Insert into ' + _Tablename + ' (' + _PrimaryKey + ', ' + s;
  Result := Result + ') values (' + FieldByName(_PrimaryKey).Asstring + ', ';
  s := '';
  for i1 := 0 to _List.Count -1 do
  begin
    if SameText(_PrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
      s := s + ', ';
    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) then
      s := s + QuotedStr(Feld[i1].AsString)
    else
    begin
      if Feld[i1].DataType = ftInteger then
      begin
        if Feld[i1].AsString = '' then
          s := s + '0'
        else
          s := s + Feld[i1].AsString;
      end
      else
        s := s + Feld[i1].AsString;
    end;
  end;
  Result := Result + s + ')';
end;

function TDBFeldList.UpdateStatement: string;
var
  s: string;
  i1: Integer;
begin
  Result := 'update ' + _Tablename + ' set ';
  s := '';
  for i1 := 0 to _List.Count -1 do
  begin
    if SameText(_PrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
    begin
      s := '';
      s := s + ', ';
    end;
    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) then
      s := s + Feld[i1].Feldname + '=' + QuotedStr(Feld[i1].AsString)
    else
      s := s + Feld[i1].Feldname + '=' + Feld[i1].AsString;
    Result := Result + s;
  end;
  Result := Result + ' where ' + _PrimaryKey + '=' + Fieldbyname(_PrimaryKey).AsString;
end;

function TDBFeldList.DeleteStatement: string;
begin
  Result := 'delete from ' + _Tablename;
  Result := Result + ' where ' + _PrimaryKey + '=' + Fieldbyname(_PrimaryKey).AsString;
end;


end.
