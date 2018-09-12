unit o_DBFieldPng;

interface

uses
  SysUtils, Classes, variants, Graphics, db, pngimage;


type
  TDBFeldPng = class(TComponent)
  private
    function getPng: TPngImage;
  protected
    FPng: TPngImage;
    FStream: TMemoryStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(aBlobField: TBlobField);
    procedure Save(aPng: TPngImage);
    function AsStream: TMemoryStream;
    procedure InitValue;
    procedure LoadFromFile(aFilename: string);
    procedure SaveToFile(aFilename: string);
    property AsPng: TPngImage read getPng;
  end;


implementation

{ TDBFeldPng }


constructor TDBFeldPng.Create(AOwner: TComponent);
begin
  inherited;
  FStream := nil;
  FPng    := nil;
  InitValue;
end;

destructor TDBFeldPng.Destroy;
begin
  InitValue;
  inherited;
end;

procedure TDBFeldPng.InitValue;
begin
  if FPng <> nil then
    FreeAndNil(FPng);
  if FStream <> nil then
    FreeAndNil(FStream);
end;


function TDBFeldPng.AsStream: TMemoryStream;
begin
  Result := nil;
  if FStream <> nil then
    FreeAndNil(FStream);
  if FPng = nil then
    exit;
  FStream := TMemoryStream.Create;
  FStream.Position := 0;
  FPng.SaveToStream(FStream);
  FStream.Position := 0;
  Result := FStream;
end;

function TDBFeldPng.getPng: TPngImage;
begin
  Result := FPng;
end;


procedure TDBFeldPng.Load(aBlobField: TBlobField);
var
  m: TMemoryStream;
begin
  InitValue;
  FPng := TPngImage.Create;
  m := TMemoryStream.Create;
  try
    aBlobField.SaveToStream(m);
    m.Position := 0;
    FPng.LoadFromStream(m);
  finally
    FreeAndNil(m);
  end;
end;

procedure TDBFeldPng.LoadFromFile(aFilename: string);
begin
  InitValue;
  if not FileExists(aFilename) then
    exit;
  FPng := TPngImage.Create;
  FPng.LoadFromFile(aFilename);
end;

procedure TDBFeldPng.Save(aPng: TPngImage);
begin
  InitValue;
  FPng := TPngImage.Create;
  FPng.Assign(aPng);
end;

procedure TDBFeldPng.SaveToFile(aFilename: string);
begin
  if FPng = nil then
    exit;
  FPng.SaveToFile(aFileName);
end;

end.
