unit Objekt.DBFeldList;

interface

uses
  SysUtils, Classes, Objekt.BasisList, Objekt.DBFeld, Data.DB, System.Contnrs;

type
  TDBFeldList = class(TBaseList)
  private
    fTablename: string;
    fPrimaryKey: string;
    function getFeld(aIndex: Integer): TDBFeld;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(aName: string; aDataType: TFieldType): TDBFeld;
    function FieldByName(aName: string): TDBFeld;
    property Feld[aIndex: Integer]: TDBFeld read getFeld;
    property Tablename: string read fTablename write fTablename;
    property PrimaryKey: string read fPrimaryKey write fPrimaryKey;
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
  i1: Integer;
  sFloat: string;
begin
  s := '';
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    s := s + Feld[i1].Feldname + ', ';
  end;
  s := copy(s, 1, Length(s)-2);
  Result := 'Insert into ' + fTablename + ' (' + fPrimaryKey + ', ' + s;
  Result := Result + ') values (' + FieldByName(fPrimaryKey).Asstring + ', ';
  s := '';
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
      s := s + ', ';

    if (Feld[i1].DataType = ftFloat) then
    begin
      sFloat := Feld[i1].AsString;
      sFloat := StringReplace(sFloat, ',', '.', [rfReplaceAll]);
      s := s + sFloat;
      continue;
    end;

    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) or (Feld[i1].DataType = ftDateTime) then
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
  sFloat: string;
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

    if (Feld[i1].DataType = ftFloat) then
    begin
      sFloat := Feld[i1].AsString;
      sFloat := StringReplace(sFloat, ',', '.', [rfReplaceAll]);
      //s := s + sFloat;
      s := s + Feld[i1].Feldname + '=' + sFloat;
      Result := Result + s;
      continue;
    end;

    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean)
    or (Feld[i1].DataType = ftDateTime) then
      s := s + Feld[i1].Feldname + '=' + QuotedStr(Feld[i1].AsString)
    else
      s := s + Feld[i1].Feldname + '=' + Feld[i1].AsString;
    Result := Result + s;
  end;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
end;

function TDBFeldList.DeleteStatement: string;
begin
  Result := 'delete from ' + fTablename;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
end;


end.
