unit MySql.Base;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP, Feld.FeldList,
  Data.DB, Objekt.DateTime, Feld.Feld;

type
  TMySqlBase = class(TComponent)
  private
    function ClearUpdate: Boolean;
  protected
    fHttp: TIdHTTP;
    fFeldList: TFeldList;
    fDateTime: TTbDateTime;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadMySql(aValue: string; aStrings: TStrings);
    procedure ItemList(aValue: string; aItemList: TStrings);
    procedure Init; virtual;
    procedure FillFields(aStrings: TStrings);
    function FieldByName(aFieldName: string): TFeld;
  end;


implementation

{ TMySqlBase }

constructor TMySqlBase.Create(AOwner: TComponent);
begin
  fHttp := TIdHTTP.Create(nil);
  fFeldList := TFeldList.Create(nil);
  fDateTime := TTbDateTime.Create(nil);
  Init;
end;

destructor TMySqlBase.Destroy;
begin
  FreeAndNil(fHttp);
  FreeAndNil(fFeldList);
  FreeAndNil(fDateTime);
  inherited;
end;


procedure TMySqlBase.ReadMySql(aValue: string; aStrings: TStrings);
var
  s: string;
  s1: string;
  iPos: Integer;
  List: TStringList;
begin
  aStrings.Clear;
  s := fHttp.Get(aValue);
  List := TStringList.Create;
  try
    while Length(s) > 0 do
    begin
      iPos := Pos(' #', s);
      if iPos = 0 then
      begin
        List.Add(s);
        break;
      end;
      s1 := copy(s, 1, iPos-1);
      List.Add(s1);
      s := copy(s, iPos+2, Length(s));
    end;
    aStrings.AddStrings(List);
  finally
    FreeAndNil(List);
  end;

end;

procedure TMySqlBase.Init;
var
  i1: Integer;
begin
  if fFeldList = nil then
    exit;
  ClearUpdate;
  for i1 := 0 to fFeldList.Count -1 do
  begin
    if fFeldList.Feld[i1].DataType = ftString then
      fFeldList.Feld[i1].AsString := '';
    if (fFeldList.Feld[i1].DataType = ftInteger)
    or (fFeldList.Feld[i1].DataType = ftFloat) then
      fFeldList.Feld[i1].AsInteger := 0;
    if fFeldList.Feld[i1].DataType = ftDateTime then
      fFeldList.Feld[i1].AsDateTime := now;
    if fFeldList.Feld[i1].DataType = ftBoolean then
      fFeldList.Feld[i1].AsBoolean := false;
  end;

end;

function TMySqlBase.ClearUpdate: Boolean;
var
  i1: Integer;
begin
  Result := false;
  if fFeldList = nil then
    exit;
  for i1 := 0 to fFeldList.Count -1 do
    fFeldList.Feld[i1].Changed := false;
end;


function TMySqlBase.FieldByName(aFieldName: string): TFeld;
begin
  Result := fFeldList.FieldByName(aFieldName);
end;

procedure TMySqlBase.FillFields(aStrings: TStrings);
var
  i1: Integer;
  iZahl: Integer;
  rZahl: Extended;
  sZahl: string;
begin
  if aStrings.Count > fFeldList.Count then
    exit;
  ClearUpdate;
  for i1 := 0 to fFeldList.Count -1 do
  begin
    if fFeldList.Feld[i1].DataType = ftString then
      fFeldList.Feld[i1].AsString := aStrings[i1];

    if (fFeldList.Feld[i1].DataType = ftInteger) then
    begin
      if not TryStrToInt(aStrings[i1], iZahl) then
        iZahl := 0;
      fFeldList.Feld[i1].AsInteger := iZahl;
    end;
    if (fFeldList.Feld[i1].DataType = ftFloat) then
    begin
      sZahl := StringReplace(aStrings[i1], '.', ',', [rfReplaceAll]);
      if not TryStrToFloat(sZahl, rZahl) then
        rZahl := 0;
      fFeldList.Feld[i1].AsFloat := rZahl;
    end;
    if fFeldList.Feld[i1].DataType = ftTimeStampOffset then // MySqlDateTime
    begin
      if aStrings[i1] = '0000-00-00' then
        fFeldList.Feld[i1].AsDateTime := 0
      else
      begin
        fDateTime.SetMySqlDateTimeStr(aStrings[i1]);
        fFeldList.Feld[i1].AsDateTime := fDateTime.Datum;
      end;
    end;
    if fFeldList.Feld[i1].DataType = ftBoolean then
      fFeldList.Feld[i1].AsBoolean := aStrings[i1] = 'T';
  end;
end;


procedure TMySqlBase.ItemList(aValue: string; aItemList: TStrings);
var
  s1: string;
  iPos: Integer;
begin
  aItemList.Clear;
  while Length(aValue) > 0 do
  begin
    iPos := Pos(' ;', aValue);
    if iPos = 0 then
    begin
      aItemList.Add(aValue);
      exit;
    end;
    s1 := copy(aValue, 1, iPos-1);
    aItemList.Add(s1);
    aValue := copy(aValue, iPos+2, Length(aValue));
  end;
end;


end.
