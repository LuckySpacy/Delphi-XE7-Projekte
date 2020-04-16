unit WebQuery.FeldList;

interface

uses
  SysUtils, Classes, WebQuery.BaseList, WebQuery.Feld, Data.DB, System.Contnrs;

type
  TWebQueryFeldList = class(TWebQueryBaseList)
  private
    fTablename: string;
    fPrimaryKey: string;
    fTablePrefix: string;
    function getFeld(aIndex: Integer): TWebQueryFeld;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add(aName: string; aDataType: TFieldType): TWebQueryFeld;
    function FieldByName(aName: string): TWebQueryFeld;
    property Feld[aIndex: Integer]: TWebQueryFeld read getFeld;
    property Tablename: string read fTablename write fTablename;
    property PrimaryKey: string read fPrimaryKey write fPrimaryKey;
    property TablePrefix: string read fTablePrefix write fTablePrefix;
    function InsertStatement: string;
    function UpdateStatement: string;
    function DeleteStatement: string;
    procedure SetChangedToAll(aChanged: Boolean);
  end;




implementation

{ TDBFeldList }

constructor TWebQueryFeldList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TWebQueryFeldList.Destroy;
begin

  inherited;
end;



function TWebQueryFeldList.Add(aName: string; aDataType: TFieldType): TWebQueryFeld;
begin
  Result := TWebQueryFeld.Create(nil);
  Result.Feldname := aName;
  Result.DataType := aDataType;
  fList.Add(Result);
end;


function TWebQueryFeldList.FieldByName(aName: string): TWebQueryFeld;
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

function TWebQueryFeldList.getFeld(aIndex: Integer): TWebQueryFeld;
begin
  Result := nil;
  if aIndex > fList.Count then
    exit;
  Result := TWebQueryFeld(fList.Items[aIndex]);
end;

function TWebQueryFeldList.InsertStatement: string;
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
    if (Feld[i1].DataType = ftDateTime) then
      s := s + QuotedStr(Feld[i1].AsFirebirdDateTimeStr)
    else
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


function TWebQueryFeldList.UpdateStatement: string;
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
    if (Feld[i1].DataType = ftDateTime) then
      s := s + Feld[i1].Feldname + '=' + QuotedStr(Feld[i1].AsFirebirdDateTimeStr)
    else
      if (Feld[i1].DataType = ftString) or (Feld[i1].DataType = ftBoolean) then
        s := s + Feld[i1].Feldname + '=' + QuotedStr(Feld[i1].AsString)
      else
        s := s + Feld[i1].Feldname + '=' + Feld[i1].AsString;
    Result := Result + s;
  end;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
end;

function TWebQueryFeldList.DeleteStatement: string;
begin
  Result := 'update ' + fTablename + ' set ' + TablePrefix + '_DELETE = "T"';
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
{
  Result := 'delete from ' + fTablename;
  Result := Result + ' where ' + fPrimaryKey + '=' + Fieldbyname(fPrimaryKey).AsString;
  }
end;


procedure TWebQueryFeldList.SetChangedToAll(aChanged: Boolean);
var
  i1: Integer;
begin
  for i1 := 0 to fList.Count -1 do
    Feld[i1].Changed := aChanged;
end;

end.
