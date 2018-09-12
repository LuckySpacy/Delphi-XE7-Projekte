unit o_EntfernungList;

interface

uses
  Classes, SysUtils, o_Entfernung, contnrs, o_Koordinate;

type
  TEntfernungList = class(TObject)
  private
    FList: TObjectList;
    function GetEntfernung(Index: Integer): TEntfernung;
  public
    constructor Create;
    destructor Destroy; override;
    property Item[Index: Integer]: TEntfernung read GetEntfernung;
    function Count: Integer;
    function Add(aKoordinate: TKoordinate): TEntfernung;
    procedure Clear;
    procedure Load(aFilename: string);
    procedure Save(aFilename: string);
    function GetEntfernungFromKoordinate(aKoordinate: TKoordinate): TEntfernung;
  end;




implementation

{ TEntfernungList }

constructor TEntfernungList.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TEntfernungList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;


function TEntfernungList.Add(aKoordinate: TKoordinate): TEntfernung;
begin
  Result := GetEntfernungFromKoordinate(aKoordinate);
  if Result <> nil then
    exit;
  Result := TEntfernung.Create;
  Result.Koordinate.X := aKoordinate.X;
  Result.Koordinate.Y := aKoordinate.Y;
  FList.Add(Result);
end;

procedure TEntfernungList.Clear;
begin
  FList.Clear;
end;

function TEntfernungList.Count: Integer;
begin
  Result := FList.Count;
end;


function TEntfernungList.GetEntfernung(Index: Integer): TEntfernung;
begin
  Result := nil;
  if Index > FList.Count -1 then
    exit;
  Result := TEntfernung(FList.Items[Index]);
end;


procedure TEntfernungList.Load(aFilename: string);
var
  FileList: TStringList;
  SplittList: TStringList;
  i1: Integer;
  Entfernung: TEntfernung;
  iFelder: Integer;
  Koordinate: TKoordinate;
begin
  FList.Clear;
  if not FileExists(aFilename) then
    exit;
  Koordinate := TKoordinate.Create;
  SplittList := TStringList.Create;
  FileList := TStringList.Create;
  try
    SplittList.Delimiter := ';';
    SplittList.StrictDelimiter := true;
    FileList.LoadFromFile(aFilename);
    for i1 := 0 to FileList.Count - 1 do
    begin
      SplittList.DelimitedText := FileList.Strings[i1];
      if Splittlist.Count < 3 then
        continue;
      Koordinate.AsString := SplittList.Strings[0];
      Entfernung := Add(Koordinate);
      Entfernung.Basename := SplittList.Strings[1];
      if not TryStrToInt(SplittList.Strings[2], iFelder) then
        Entfernung.Felder  := 0
      else
        Entfernung.Felder := iFelder;
    end;
  finally
    FreeAndNil(Koordinate);
    FreeAndNil(FileList);
    FreeAndNil(SplittList);
  end;

end;

procedure TEntfernungList.Save(aFilename: string);
var
  FileList: TStringList;
  i1: Integer;
  Entfernung: TEntfernung;
  s: string;
  Pfad: string;
begin
  if aFilename = '' then
    exit;
  Pfad := ExtractFilePath(aFilename);
  if not DirectoryExists(Pfad) then
    exit;
  FileList := TStringList.Create;
  try
    for i1 := 0 to FList.Count - 1 do
    begin
      Entfernung := TEntfernung(FList.Items[i1]);
      s := Entfernung.Koordinate.AsString + ';' +
           Entfernung.Basename + ';' +
           IntToStr(Entfernung.Felder);
      FileList.Add(s);
    end;
    if FileList.Count > 0 then
      FileList.SaveToFile(aFilename);
  finally
    FreeAndNil(FileList);
  end;
end;


function TEntfernungList.GetEntfernungFromKoordinate(
  aKoordinate: TKoordinate): TEntfernung;
var
  i1: Integer;
  Entfernung: TEntfernung;
begin
  Result := nil;
  for i1 := 0 to FList.Count - 1 do
  begin
    Entfernung := Item[i1];
    if (Entfernung.Koordinate.X = aKoordinate.X) and (Entfernung.Koordinate.Y = aKoordinate.Y) then
    begin
      Result := Entfernung;
      exit;
    end;
  end;
end;


end.
