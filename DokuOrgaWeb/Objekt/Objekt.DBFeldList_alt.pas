unit Objekt.DBFeldList;

interface

uses
  SysUtils, Classes, Objekt.BasisList, Objekt.DBFeld, Data.DB, System.Contnrs,
  IBX.IBQuery;

type
  TDBFeldList = class(TBaseList)
  private
    fTablename: string;
    fPrimaryKey: string;
    fTablePrefix: string;
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
    property TablePrefix: string read fTablePrefix write fTablePrefix;
    function InsertStatement: string;
    function UpdateStatement: string;
    function DeleteStatement: string;
    procedure SetSqlValues(aQry: TIBQuery);
    procedure SetChangedToAll(aChanged: Boolean);
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


function TDBFeldList.DeleteStatement: string;
begin
  Result := 'delete from ' + fTablename;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
end;




function TDBFeldList.InsertStatement: string;
var
  s: string;
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
  Result := 'Insert into ' + fTablename + ' (' + fPrimaryKey + ', ' + s;
  Result := Result + ') values (' + FieldByName(fPrimaryKey).Asstring + ', ';

  s := '';
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
      s := s + ', ';
    s := s + ':' + Feld[i1].Feldname;
  end;
  Result := Result + s + ')';


  {
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
        if Feld[i1].DataType = ftDateTime then
          s := s + quotedStr(DateToStr(Feld[i1].AsDateTime))
        else
          s := s + Feld[i1].AsString;
    end;
  end;
  Result := Result + s + ')';
  }
end;

function TDBFeldList.UpdateStatement: string;
var
  s: string;
  i1: Integer;
begin
  Result := 'update ' + fTablename + ' set ';
  s := '';
  {
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
    begin
      s := '';
      s := s + ', ';
    end;
    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) then
      s := s + Feld[i1].Feldname + '=' + QuotedStr(Feld[i1].AsString)
    else
     if Feld[i1].DataType = ftDateTime then
        s := s + Feld[i1].Feldname + '=' + quotedStr(DateToStr(Feld[i1].AsDateTime))
      else
        s := s + Feld[i1].Feldname + '=' + Feld[i1].AsString;
    Result := Result + s;
  end;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
  }

  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if s > '' then
    begin
      s := '';
      s := s + ', ';
    end;
    s := s + Feld[i1].Feldname + '= :' + Feld[i1].Feldname;
    Result := Result + s;
  end;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;

end;


procedure TDBFeldList.SetSqlValues(aQry: TIBQuery);
var
  i1: Integer;
begin
  for i1 := 0 to fList.Count -1 do
  begin
    if SameText(fPrimaryKey, Feld[i1].Feldname) then
      continue;
    if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) then
      aQry.ParamByName(Feld[i1].Feldname).AsString := Feld[i1].AsString;
    if Feld[i1].DataType = ftInteger then
      aQry.ParamByName(Feld[i1].Feldname).AsInteger := Feld[i1].AsInteger;
    if Feld[i1].DataType = ftDateTime then
      aQry.ParamByName(Feld[i1].Feldname).AsDateTime := Feld[i1].AsDateTime;
  end;
end;

procedure TDBFeldList.SetChangedToAll(aChanged: Boolean);
var
  i1: Integer;
begin
  for i1 := 0 to fList.Count -1 do
    Feld[i1].Changed := aChanged;
end;



end.
