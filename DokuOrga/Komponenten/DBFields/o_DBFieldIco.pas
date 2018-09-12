unit o_DBFieldIco;

interface

uses
  SysUtils, Classes, variants, Graphics, db;


type
  TDBFeldIco = class(TComponent)
  private
    function getIcon: TIcon;
  protected
    FIco: TIcon;
    FStream: TMemoryStream;
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

{ TDBFeldIco }

constructor TDBFeldIco.Create(AOwner: TComponent);
begin
  inherited;
  FStream := nil;
  FIco    := nil;
  InitValue;
end;

destructor TDBFeldIco.Destroy;
begin
  InitValue;
  inherited;
end;

procedure TDBFeldIco.InitValue;
begin
  if FIco <> nil then
    FreeAndNil(FIco);
  if FStream <> nil then
    FreeAndNil(FStream);
end;

function TDBFeldIco.AsStream: TMemoryStream;
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


function TDBFeldIco.getIcon: TIcon;
begin
  Result := FIco;
end;


procedure TDBFeldIco.Load(aBlobField: TBlobField);
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

procedure TDBFeldIco.LoadFromFile(aFilename: string);
begin
  InitValue;
  if not FileExists(aFilename) then
    exit;
  FIco := TIcon.Create;
  FIco.LoadFromFile(aFilename);
end;

procedure TDBFeldIco.Save(aIcon: TIcon);
begin
  InitValue;
  FIco := TIcon.Create;
  FIco.Assign(aIcon);
end;

procedure TDBFeldIco.SaveStream(aStream: TMemoryStream);
begin
  InitValue;
  aStream.Position := 0;
  if aStream.Size = 0 then
    exit;
  FIco := TIcon.Create;
  FIco.LoadFromStream(aStream);
end;

procedure TDBFeldIco.SaveToFile(aFilename: string);
begin
  if FIco = nil then
    exit;
  FIco.SaveToFile(aFilename);
end;

end.
