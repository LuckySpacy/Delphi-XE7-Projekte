unit o_Basen;

interface

uses
  SysUtils, Classes, o_BaseList, o_CustomBasen, o_Base, o_Einheitdatei,
  u_system;

type
  TBasen = class(TCustomBasen)
  private
    FPfad: string;
    FBasendatei: string;
    FEinheitendatei: string;
    FEinheitdatei: TEinheitdatei;
    FEntfernungspfad: string;
    FEntfernungsdateienList: TStringlist;
    function GetBase(Index: Integer): TBase;
    procedure setPfad(const Value: string);
    procedure CheckEntfernungsdateiname(aBase: TBase);
  protected
  public
    constructor Create; override;
    destructor Destroy; override;
    procedure Load;
    procedure Save;
    function Add: TBase;
    function Count: Integer;
    procedure Sort;
    property Base[Index: Integer]: TBase read GetBase;
    procedure Delete(aBase: TBase);
    property Pfad: string read FPfad write setPfad;
  end;


implementation

{ TBasen }

uses
  o_EinheitdateiObj, o_Einheit, Dialogs;




constructor TBasen.Create;
begin
  inherited;
  FPfad := '';
  FEinheitdatei := TEinheitdatei.Create;
  FEntfernungsdateienList := TStringlist.Create;
end;


destructor TBasen.Destroy;
begin
  FreeAndNil(FEinheitdatei);
  FreeAndNil(FEntfernungsdateienList);
  inherited;
end;

function TBasen.GetBase(Index: Integer): TBase;
begin
  Result := FBaseList.Item[Index];
end;

procedure TBasen.Load;
var
  DateiList: TStringList;
  i1, i2: Integer;
  SplittList: TStringList;
  Base: TBase;
  Punkte: Integer;
  EinheitdateiObj: TEinheitdateiObj;
  Einheit: TEinheit;
begin
  FBaseList.Clear;
  if not FileExists(FBasendatei) then
    exit;
  FEinheitdatei.Load(FEinheitendatei);
  SplittList := TStringList.Create;
  DateiList := TStringList.Create;
  try
    SplittList.Delimiter := ';';
    SplittList.StrictDelimiter := true;
    DateiList.LoadFromFile(FBasendatei);
    for i1 := 0 to DateiList.Count - 1 do
    begin
      SplittList.DelimitedText := DateiList.Strings[i1];
      if SplittList.Count < 4 then
        continue;
      Base := FBaseList.Add;
      Base.Basename := SplittList.Strings[0];
      Base.Koordinate.AsString := SplittList.Strings[1];
      if not TryStrToInt(SplittList.Strings[2], Punkte) then
        Base.Punkte := 0
      else
        Base.Punkte := Punkte;
      Base.Rauchsignal := StrToBool(SplittList.Strings[3]);
      Base.Sprechfunk := StrToBool(SplittList.Strings[4]);
      EinheitdateiObj := FEinheitdatei.getEinheitdateiObj(Base.Koordinate.X, Base.Koordinate.Y);
      if EinheitdateiObj = nil then
        continue;
      for i2 := 0 to Base.EinheitCount -1 do
      begin
        Einheit := Base.Einheit[i2];
        Einheit.Anzahl := EinheitdateiObj.GetValue(i2);
      end;
      CheckEntfernungsdateiname(Base);
      Base.EntfernungPfad := FEntfernungspfad;
    end;
  finally
    FreeAndNil(SplittList);
    FreeAndNil(DateiList);
  end;
  FBaseList.Sort;
end;

procedure TBasen.CheckEntfernungsdateiname(aBase: TBase);
var
  i1: Integer;
  iPos: Integer;
  Koord: string;
  FullFilenameOld: string;
  FullFilenameNew: string;
  Basename: string;
begin
  for i1 := 0 to FEntfernungsdateienList.Count - 1 do
  begin
    iPos := Pos('-', FEntfernungsdateienList.Strings[i1]);
    if iPos <= 0 then
      continue;
    Koord := copy(FEntfernungsdateienList.Strings[i1], 1, iPos-1);
    Basename := copy(FEntfernungsdateienList.Strings[i1], iPos+1, Length(FEntfernungsdateienList.Strings[i1]));
    iPos := Pos('.', Basename);
    if iPos <= 0 then
      continue;
    Basename := copy(Basename, 1, iPos-1);
    FullfilenameOld := FEntfernungspfad + FEntfernungsdateienList.Strings[i1];
    if Koord = aBase.Koordinate.AsString then
    begin
      FullFilenameNew := Koord + '-' + aBase.Basename + '.txt';
      FullFilenameNew := FEntfernungspfad + FullFilenameNew;
      if not SameText(FullFilenameOld, FullFilenameNew) then
        RenameFile(FullFilenameOld, FullFilenameNew);
      exit;
    end;
  end;
end;



procedure TBasen.Save;
var
  EinheitList: TStringList;
  DateiList: TStringList;
  i1, i2: Integer;
  Zeile: string;
  Base: TBase;
  Einheit: TEinheit;
begin
  EinheitList := TStringList.Create;
  DateiList := TStringList.Create;
  try
    for i1 := 0 to FBaseList.Count - 1 do
    begin
      Base := FBaseList.Item[i1];
      Zeile := Base.Basename + ';' +
               Base.Koordinate.AsString + ';' +
               IntToStr(Base.Punkte)  + ';' +
               BoolToStr(Base.Rauchsignal) + ';' +
               BoolToStr(Base.Sprechfunk);
      DateiList.Add(Zeile);
      Zeile := Base.Koordinate.AsString + ';';
      for i2 := 0 to Base.EinheitCount - 1 do
      begin
        try
          Einheit := Base.Einheit[i2];
          Zeile   := Zeile + Einheit.Bezeichnung + '='+ IntToStr(Einheit.Anzahl) + ';';
        except
          ShowMessage('Fehler');
          raise;
        end;
      end;
      EinheitList.Add(Zeile);
    end;
    if DateiList.Count > 0 then
      DateiList.SaveToFile(FBasendatei);
    if EinheitList.Count > 0 then
      EinheitList.SaveToFile(FEinheitendatei);
  finally
    FreeAndNil(DateiList);
    FreeAndNil(EinheitList);
  end;
end;

procedure TBasen.setPfad(const Value: string);
var
  i1: Integer;
begin
  FPfad := IncludeTrailingPathDelimiter(Value);
  FBasendatei := FPfad + 'Basen.txt';
  FEinheitendatei := FPfad + 'Einheiten.txt';
  FEntfernungspfad := Pfad + 'Entfernungen\';
  FEntfernungsdateienList.Clear;
  if DirectoryExists(FEntfernungspfad) then
  begin
    GetAllFiles(FEntfernungspfad, FEntfernungsdateienList, false, false, '*.txt');
  end;
end;

procedure TBasen.Sort;
begin
  FBaseList.Sort;
end;

function TBasen.Add: TBase;
begin
  Result := FBaseList.Add;
end;

function TBasen.Count: Integer;
begin
  Result := FBaseList.Count;
end;

procedure TBasen.Delete(aBase: TBase);
var
  i1: Integer;
  Base: TBase;
begin
  for i1 := 0 to FBaseList.Count - 1 do
  begin
    Base := FBaseList.Item[i1];
    if  (Base.Koordinate.X = aBase.Koordinate.X)
    and (Base.Koordinate.Y = aBase.Koordinate.Y) then
    begin
      FBaseList.DeleteItem(i1);
      exit;
    end;
  end;
end;




end.
