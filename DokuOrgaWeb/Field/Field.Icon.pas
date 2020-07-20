unit Field.Icon;

interface

uses
  SysUtils, Classes, variants, Graphics, db;


type
  TIco = class(TComponent)
  private
    function getIcon: TIcon;
  protected
    fIco: TIcon;
    fStream: TMemoryStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(aBlobField: TBlobField);
    procedure Save(aIcon: TIcon);
    procedure SaveStream(aStream: TMemoryStream);
    function AsStream: TMemoryStream;
    procedure InitValue;
    procedure LoadFromFile(aFilename: string);
    procedure SaveToFile(aFilename: string);
    property AsIcon: TIcon read getIcon;
  end;

implementation

{ TIco }

constructor TIco.Create(AOwner: TComponent);
begin
  inherited;
  fIco := nil;
  fStream := nil;
end;

destructor TIco.Destroy;
begin
  if fIco <> nil then
    FreeAndNil(fIco);
  if fStream <> nil then
    FreeAndNil(fStream);
  inherited;
end;


function TIco.AsStream: TMemoryStream;
begin
  Result := nil;
  if FStream <> nil then
    FreeAndNil(FStream);
  if FIco = nil then
    exit;
  FStream := TMemoryStream.Create;
  FStream.Position := 0;
  FIco.SaveToStream(FStream);
  FStream.Position := 0;
  Result := FStream;
end;


function TIco.getIcon: TIcon;
begin
  Result := FIco;
end;

procedure TIco.InitValue;
begin
  if fIco <> nil then
    FreeAndNil(fIco);
  if fStream <> nil then
    FreeAndNil(fStream);
end;

procedure TIco.Load(aBlobField: TBlobField);
var
  m: TMemoryStream;
begin
  InitValue;
  FIco := TIcon.Create;
  m := TMemoryStream.Create;
  try
    aBlobField.SaveToStream(m);
    m.Position := 0;
    FIco.LoadFromStream(m);
  finally
    FreeAndNil(m);
  end;
end;

procedure TIco.LoadFromFile(aFilename: string);
begin
  InitValue;
  if not FileExists(aFilename) then
    exit;
  FIco := TIcon.Create;
  FIco.LoadFromFile(aFilename);
end;

procedure TIco.Save(aIcon: TIcon);
begin
  InitValue;
  FIco := TIcon.Create;
  FIco.Assign(aIcon);
end;

procedure TIco.SaveStream(aStream: TMemoryStream);
begin
  InitValue;
  aStream.Position := 0;
  if aStream.Size = 0 then
    exit;
  FIco := TIcon.Create;
  FIco.LoadFromStream(aStream);
end;

procedure TIco.SaveToFile(aFilename: string);
begin
  if FIco = nil then
    exit;
  FIco.SaveToFile(aFilename);
end;

end.
