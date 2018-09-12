unit o_DBFieldBmp;

interface

uses
  SysUtils, Classes, variants, Graphics, db;


type
  TDBFeldBmp = class(TComponent)
  private
    function getBitmap: TBitmap;
  protected
    FBmp: TBitmap;
    FStream: TMemoryStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(aBlobField: TBlobField);
    procedure Save(aBitmap: TBitmap);
    function AsStream: TMemoryStream;
    procedure InitValue;
    procedure LoadFromFile(aFilename: string);
    procedure SaveToFile(aFilename: string);
    property AsBitmap: TBitmap read getBitmap;
  end;


implementation

{ TDBFeldBmp }


constructor TDBFeldBmp.Create(AOwner: TComponent);
begin
  inherited;
  FStream := nil;
  FBmp    := nil;
  InitValue;
end;

destructor TDBFeldBmp.Destroy;
begin
  InitValue;
  inherited;
end;

procedure TDBFeldBmp.InitValue;
begin
  if FBmp <> nil then
    FreeAndNil(FBmp);
  if FStream <> nil then
    FreeAndNil(FStream);
end;


function TDBFeldBmp.AsStream: TMemoryStream;
begin
  Result := nil;
  if FStream <> nil then
    FreeAndNil(FStream);
  if FBmp = nil then
    exit;
  FStream := TMemoryStream.Create;
  FStream.Position := 0;
  FBmp.SaveToStream(FStream);
  FStream.Position := 0;
  Result := FStream;
end;


function TDBFeldBmp.getBitmap: TBitmap;
begin
  Result := FBmp;
end;


procedure TDBFeldBmp.Load(aBlobField: TBlobField);
var
  m: TMemoryStream;
begin
  InitValue;
  FBmp := TBitmap.Create;
  m := TMemoryStream.Create;
  try
    aBlobField.SaveToStream(m);
    m.Position := 0;
    FBmp.LoadFromStream(m);
  finally
    FreeAndNil(m);
  end;
end;

procedure TDBFeldBmp.LoadFromFile(aFilename: string);
begin
  InitValue;
  if not FileExists(aFilename) then
    exit;
  FBmp := TBitmap.Create;
  FBmp.LoadFromFile(aFilename);
end;


procedure TDBFeldBmp.Save(aBitmap: TBitmap);
begin
  InitValue;
  FBmp := TBitmap.Create;
  FBmp.Assign(aBitmap);
end;

procedure TDBFeldBmp.SaveToFile(aFilename: string);
begin
  if FBmp = nil then
    exit;
  FBmp.SaveToFile(aFilename);
end;

end.
