unit DB.Feldlist;

interface

uses
  SysUtils, Classes, Objekt.BaseList, DB.Feld, Data.DB, System.Contnrs;

type
  TDBDatenbankart=(c_Firebird, c_MySql);

type
  TDBFeldList = class(TBaseListObj)
  private
    fTablename: string;
    fPrimaryKey: string;
    fPrimaryKeyIsAutoInc: Boolean;
    fDatenbankart: TDBDatenbankart;
    function getFeld(aIndex: Integer): TDBFeld;
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    function Add(aName: string; aDataType: TFieldType): TDBFeld;
    function FieldByName(aName: string): TDBFeld;
    property Feld[aIndex: Integer]: TDBFeld read getFeld;
    property Tablename: string read fTablename write fTablename;
    property PrimaryKey: string read fPrimaryKey write fPrimaryKey;
    property PrimaryKeyIsAutoInc: Boolean read fPrimaryKeyIsAutoInc write fPrimaryKeyIsAutoInc;
    property Datenbankart: TDBDatenbankart read fDatenbankart write fDatenbankart;
    function InsertStatement: string;
    function UpdateStatement: string;
    function DeleteStatement: string;
  end;

implementation

{ TDBFeldList }


constructor TDBFeldList.Create;
begin
  inherited;
  fPrimaryKeyIsAutoInc := false;
  fDatenbankart := c_Firebird;
end;

function TDBFeldList.DeleteStatement: string;
begin
  Result := 'delete from ' + fTablename;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
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
  fList.Add(Result);
end;


function TDBFeldList.FieldByName(aName: string): TDBFeld;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
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
  if aIndex > fList.Count then
    exit;
  Result := TDBFeld(fList.Items[aIndex]);
end;

function TDBFeldList.InsertStatement: string;
var
  s: string;
  s1: string;
  i1: Integer;
begin
  s := '';
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    s := s + Feld[i1].Feldname + ', ';
  end;
  s := copy(s, 1, Length(s)-2);
  if not fPrimaryKeyIsAutoInc then
  begin
    Result := 'Insert into ' + fTablename + ' (' + fPrimaryKey + ', ' + s;
    Result := Result + ') values (' + FieldByName(fPrimaryKey).Asstring + ', ';
  end
  else
  begin
    Result := 'Insert into ' + fTablename + ' (' + s;
    Result := Result + ') values (';
end;

  s := '';
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
      s := s + ', ';
    s1 := '';

    if (Feld[i1].DataType = ftDatetime) then
    begin
      s1 := '"' + Feld[i1].AsString + '"';
      if fDatenbankart = c_MySql  then
        s1 := '"' + Feld[i1].AsMySqlDateTime + '"'
    end;
    if (Feld[i1].DataType = ftBoolean) then
      s1 := '"' + Feld[i1].AsString + '"';
    if Feld[i1].DataType = ftfloat then
      s1 := StringReplace(Feld[i1].AsString, ',', '.', [rfReplaceAll]);
    if Feld[i1].DataType = ftInteger then
    begin
      if Feld[i1].AsString = '' then
        s1 := '0'
      else
        s1 := Feld[i1].AsString;
    end;

    if s1 = '' then
    begin
      if fDatenbankart = c_MySql then
        s := s + '"' + StringReplace(Feld[i1].AsString, '"', '''', [rfReplaceAll]) + '"'
      else
        s := s + QuotedStr(Feld[i1].AsString);
    end;

    s := s + s1;

  end;

  Result := Result + s + ')';
end;

function TDBFeldList.UpdateStatement: string;
var
  s: string;
  i1: Integer;
begin
  Result := 'update ' + fTablename + ' set ';
  s := '';
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
    begin
      s := '';
      s := s + ', ';
    end;
    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) or (Feld[i1].DataType = ftDateTime) then
      s := s + Feld[i1].Feldname + '=' + QuotedStr(Feld[i1].AsString)
    else
      s := s + Feld[i1].Feldname + '=' + Feld[i1].AsString;
    Result := Result + s;
  end;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
end;


end.
