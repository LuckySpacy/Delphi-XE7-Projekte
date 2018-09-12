unit o_DBFieldJpg;

interface

uses
  SysUtils, Classes, variants, Graphics, db, jpeg;


type
  TDBFeldJpg = class(TComponent)
  private
    function getJpg: TjpegImage;
  protected
    FJpg: TjpegImage;
    FStream: TMemoryStream;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(aBlobField: TBlobField);
    procedure Save(aJpg: TjpegImage);
    function AsStream: TMemoryStream;
    procedure InitValue;
    procedure LoadFromFile(aFilename: string);
    procedure SaveToFile(aFilename: string);
    property AsJpg: TjpegImage read getJpg;
  end;


implementation

{ TDBFeldJpg }

constructor TDBFeldJpg.Create(AOwner: TComponent);
begin
  inherited;
  FStream := nil;
  FJpg    := nil;
  InitValue;
end;

destructor TDBFeldJpg.Destroy;
begin
  InitValue;
 inherited;
end;


procedure TDBFeldJpg.InitValue;
begin
  if FJpg <> nil then
    FreeAndNil(FJpg);
  if FStream <> nil then
    FreeAndNil(FStream);
end;



function TDBFeldJpg.AsStream: TMemoryStream;
begin
  Result := nil;
  if FStream <> nil then
    FreeAndNil(FStream);
  if FJpg = nil then
    exit;
  FStream := TMemoryStream.Create;
  FStream.Position := 0;
  FJpg.SaveToStream(FStream);
  FStream.Position := 0;
  Result := FStream;
end;


function TDBFeldJpg.getJpg: TjpegImage;
begin
  Result := FJpg;
end;


procedure TDBFeldJpg.Load(aBlobField: TBlobField);
var
  m: TMemoryStream;
begin
  InitValue;
  FJpg := TjpegImage.Create;
  FJpg.CompressionQuality := 100;
  m := TMemoryStream.Create;
  try
    aBlobField.SaveToStream(m);
    m.Position := 0;
    FJpg.LoadFromStream(m);
  finally
    FreeAndNil(m);
  end;
end;

procedure TDBFeldJpg.LoadFromFile(aFilename: string);
begin
  InitValue;
  if not FileExists(aFilename) then
    exit;
  FJpg := TjpegImage.Create;
  FJpg.CompressionQuality := 100;
  FJpg.LoadFromFile(aFilename);
end;

procedure TDBFeldJpg.Save(aJpg: TJPEGImage);
begin
  InitValue;
  FJpg := TJPEGImage.Create;
  FJpg.CompressionQuality := 100;
  FJpg.Assign(aJpg);
end;

procedure TDBFeldJpg.SaveToFile(aFilename: string);
begin
  if FJpg = nil then
    exit;
  FJpg.SaveToFile(aFilename);
end;

end.
