unit WebQuery;

interface

uses
  SysUtils, Classes, WebQuery.FeldList, WebQuery.Feld, Data.DB, System.Contnrs,
  WebQuery.DatenFelderList, WebQuery.DatenFelder, WebQuery.DatenList;

type
  TWebQuery = class(TComponent)
  private
    fFeldList: TWebQueryFeldList;
    fInhalt: TStringList;
    fTrenner: string;
    fIndex: Integer;
    fDatenList: TWebQueryDatenList;
    procedure ErzeugeFelder(aFeldInfo: string);
    function getItem(var aValue: string): string;
    function getFeldTyp(aValue: string): TFieldType;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Open(aValue: string);
    function Eof: Boolean;
    procedure Next;
    procedure Prior;
    property Trenner: string read fTrenner write fTrenner;
    function FieldByName(aValue: string): TWebQueryFeld;
  end;


implementation

{ TWebQuery }

constructor TWebQuery.Create(AOwner: TComponent);
begin
  inherited;
  fTrenner  := '# #';
  fFeldList := TWebQueryFeldList.Create(nil);
  fInhalt   := TStringList.Create;
  fIndex    := 0;
  fDatenList := TWebQueryDatenList.Create(nil);
end;

destructor TWebQuery.Destroy;
begin
  FreeAndNil(fFeldList);
  FreeAndNil(fInhalt);
  FreeAndNil(fDatenList);
  inherited;
end;


procedure TWebQuery.Open(aValue: string);
var
  i1: Integer;
  i2: Integer;
  s  : string;
 // WebQueryFeld: TWebQueryFeld;
  DatenFelderList: TWebQueryDatenFelderList;
  WebQueryFeld: TWebQueryFeld;
  wf: TWebQueryFeld;
  WebQueryDatenFelder: TWebQueryDatenFelder;
begin
  fFeldList.Clear;
  fInhalt.Text := aValue;
  fDatenList.Clear;
  if fInhalt.Count = 0 then
    exit;

  ErzeugeFelder(fInhalt.Strings[0]);

  for i1 := 1 to fInhalt.Count -1 do
  begin
    DatenFelderList := fDatenList.Add;
    WebQueryDatenFelder := DatenFelderList.Add;
    s := fInhalt.Strings[i1];
    for i2 := 0 to fFeldList.Count -1 do
    begin
      wf := fFeldList.Feld[i2];
      WebQueryFeld := WebQueryDatenFelder.Add;
      WebQueryFeld.Feldname := wf.Feldname;
      WebQueryFeld.FeldSize := wf.FeldSize;
      WebQueryFeld.DataType := wf.DataType;
      WebQueryFeld.AsString := getItem(s);
    end;
  end;
  fIndex := 0;
end;


function TWebQuery.Eof: Boolean;
begin
  Result := fIndex >= fDatenList.Count ;
end;

procedure TWebQuery.Next;
begin
  inc(fIndex);
end;

procedure TWebQuery.Prior;
begin
  Inc(fIndex, -1);
  if fIndex < 0 then
    fIndex := 0;
end;





procedure TWebQuery.ErzeugeFelder(aFeldInfo: string);
var
  FeldName: string;
  FeldTyp : string;
  FeldSize: string;
  Size: Integer;
  Feld: TWebQueryFeld;
begin
  while aFeldInfo > '' do
  begin
    FeldName := getItem(aFeldInfo);
    FeldTyp  := getItem(aFeldInfo);
    FeldSize := getItem(aFeldInfo);
    Feld := fFeldList.Add(Feldname, getFeldTyp(FeldTyp));
    if TryStrToInt(FeldSize, Size) then
      Feld.FeldSize := Size
    else
      Feld.FeldSize := 0;
  end;
end;



function TWebQuery.getFeldTyp(aValue: string): TFieldType;
var
  iFeldTyp: Integer;
begin
  Result := ftUnknown;
  if not TryStrToInt(aValue, iFeldTyp) then
    exit;

  case iFeldTyp of
    7: Result := ftSmallint;
    8: Result := ftInteger;
    16: Result := ftLargeint;
    //9: Result := 'quad'
    10: Result := ftFloat;
    //    when 11 then 'd_float'
    17: Result := ftBoolean;
    27: Result := ftFloat; // then 'double'
    12: Result := ftDateTime; // then 'date'
    13: Result := ftTime; // then 'time'
    35: Result := ftTimeStamp; // then 'timestamp'
    261: Result := ftBlob; // then 'blob'
    37: Result := ftString; // then 'varchar'
    14: Result := ftWord; // then 'char'
    //    when 40 then 'cstring'
    //    when 45 then 'blob_id'
  end;

end;

function TWebQuery.getItem(var aValue: string): string;
var
  iPos: Integer;
begin
  iPos := Pos(fTrenner, aValue);
  if iPos <= 0 then
  begin
    Result := aValue;
    aValue := '';
    exit;
  end;
  Result := copy(aValue, 1, iPos-1);
  aValue := copy(aValue, iPos+Length(fTrenner), Length(aValue));
end;


function TWebQuery.FieldByName(aValue: string): TWebQueryFeld;
var
  DatenFelderList: TWebQueryDatenFelderList;
  DatenFelder: TWebQueryDatenFelder;
  WebQueryFeld: TWebQueryFeld;
  i1, i2: Integer;
begin
  Result := nil;
  DatenFelderList := fDatenList.Item[fIndex];
  for i1 := 0 to DatenFelderList.Count -1 do
  begin
    DatenFelder := DatenFelderList.Item[i1];
    for i2 := 0 to DatenFelder.Count -1 do
    begin
      WebQueryFeld := DatenFelder.Item[i2];
      if SameText(aValue, WebQueryFeld.Feldname) then
      begin
        Result := WebQueryFeld;
        break;
      end;
    end;
  end;
end;

end.
