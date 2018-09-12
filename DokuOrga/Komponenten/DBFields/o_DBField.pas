unit o_DBField;

interface

uses
  SysUtils, Classes, variants, Graphics, db, pngimage, o_DBFieldBmp,
  o_DBFieldIco, o_DBFieldPng, ImgList, Controls, o_DBFieldjpg;

type
  TDBFeld = class(TComponent)
  private
    FValue: string;
    FChanged: Boolean;
    FAlwaysTrim: Boolean;
    FFeldName: string;
    FNewInit: Boolean;
    FisBoolean: Boolean;
    FDeleteField: Boolean;
    FBitmapField: Boolean;
    FBmp: TDBFeldBmp;
    FIco: TDBFeldIco;
    FPng: TDBFeldPng;
    FJpg: TDBFeldJpg;
    function getAsString: string;
    procedure setAsString(const Value: string);
    function getInteger: Integer;
    procedure setInteger(const Value: Integer);
    function getAsBoolean: Boolean;
    procedure setAsBoolean(const Value: Boolean);
    function getAsDateTime: TDateTime;
    procedure setAsDateTime(const Value: TDateTime);
    procedure setDeleteField(const Value: Boolean);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure InitValue;
    procedure LoadImageFromFile(aFilename: string);
    procedure SaveImageToFile(aFilename: string);
    function AsStream: TMemoryStream;
    procedure CopyBmpToIco;
    procedure CopyPngToIco;
    procedure CopyJpgToIco;
    procedure ConvertToIcon;
    property AsString: string read getAsString write setAsString;
    property AsInteger: Integer read getInteger write setInteger;
    property Changed: Boolean read FChanged write FChanged;
    property AlwaysTrim: Boolean read FAlwaysTrim write FAlwaysTrim;
    property Feldname: string read FFeldName write FFeldName;
    property isBoolean: Boolean read FisBoolean write FisBoolean;
    property AsBoolean: Boolean read getAsBoolean write setAsBoolean;
    property AsDateTime: TDateTime read getAsDateTime write setAsDateTime;
    property DeleteField: Boolean read FDeleteField write setDeleteField;
    property BitmapField: Boolean read FBitmapField write FBitmapField;
    property Bmp: TDBFeldBmp read FBmp write FBmp;
    property Ico: TDBFeldIco read FIco write FIco;
    property Png: TDBFeldPng read FPng write FPng;
  end;

implementation

{ TDBFeld }




constructor TDBFeld.Create(AOwner: TComponent);
begin
  inherited;
  FAlwaysTrim := false;
  FFeldName := '';
  FBitmapField := false;
  FDeleteField := false;
  FBmp := TDBFeldBmp.Create(Self);
  FIco := TDBFeldIco.Create(Self);
  FPng := TDBFeldPng.Create(Self);
  FJpg := TDBFeldJpg.Create(Self);
  InitValue;
end;

destructor TDBFeld.Destroy;
begin
  FreeAndNil(FBmp);
  FreeAndNil(FIco);
  FreeAndNil(FPng);
  FreeAndNil(FJpg);
  inherited;
end;


procedure TDBFeld.InitValue;
begin
  FChanged := false;
  FValue := '';
  FNewInit := true;
  FBmp.InitValue;
  FIco.InitValue;
  FPng.InitValue;
  FJpg.InitValue;
end;

procedure TDBFeld.LoadImageFromFile(aFilename: string);
var
  ext: String;
begin
  InitValue;
  if not FileExists(aFileName) then
    exit;
  ext := ExtractFileExt(aFileName);
  if SameText(ext, '.bmp') then
    FBmp.LoadFromFile(aFileName);
  if SameText(ext, '.ico') then
    FIco.LoadFromFile(aFileName);
  if SameText(ext, '.png') then
    FPng.LoadFromFile(aFileName);
  if SameText(ext, '.jpg') then
    FJpg.LoadFromFile(aFileName);
end;

procedure TDBFeld.SaveImageToFile(aFilename: string);
var
  ext: String;
begin
  ext := ExtractFileExt(aFileName);
  if SameText(ext, '.bmp') then
    FBmp.SaveToFile(aFileName);
  if SameText(ext, '.ico') then
    FIco.SaveToFile(aFileName);
  if SameText(ext, '.png') then
    FPng.SaveToFile(aFileName);
  if SameText(ext, '.jpg') then
    FJpg.SaveToFile(aFileName);
end;

function TDBFeld.AsStream: TMemoryStream;
begin
  Result := nil;
  if FBmp.AsBitmap <> nil then
    Result := FBmp.AsStream;
  if FIco.AsIcon <> nil then
    Result := FIco.AsStream;
  if FPng.AsPng <> nil then
    Result := FPng.AsStream;
  if FJpg.AsJpg <> nil then
    Result := FJpg.AsStream;
end;



function TDBFeld.getAsBoolean: Boolean;
begin
  Result := FValue = 'T';
end;

function TDBFeld.getAsDateTime: TDateTime;
begin
  if not TryStrToDateTime(FValue, Result) then
    Result := 0;
end;

function TDBFeld.getAsString: string;
begin
  Result := FValue;
  if FAlwaysTrim then
    Result := Trim(FValue);
  if isBoolean then
  begin
    if Result = '' then
      Result := 'F';
  end;
end;



function TDBFeld.getInteger: Integer;
begin
  if not TryStrToInt(FValue, Result) then
    Result := 0;
end;

procedure TDBFeld.setAsBoolean(const Value: Boolean);
begin
  if Value then
    setAsString('T')
  else
    setAsString('F');
end;

procedure TDBFeld.setAsDateTime(const Value: TDateTime);
begin
  setAsString(DateTimeToStr(Value));
end;

procedure TDBFeld.setAsString(const Value: string);
begin
  if (not FNewInit) and (Value <> FValue) then
    FChanged := true;

  FValue := Value;
  if FAlwaysTrim then
    FValue := Trim(Value);
  FNewInit := false;

  if isBoolean then
  begin
    if Trim(FValue) = '' then
      FValue := 'F';
  end;

end;

procedure TDBFeld.setDeleteField(const Value: Boolean);
begin
  FDeleteField := Value;
end;

procedure TDBFeld.setInteger(const Value: Integer);
begin
  setAsString(IntToStr(Value));
end;

procedure TDBFeld.ConvertToIcon;
begin
  if FBmp.AsBitmap <> nil then
  begin
    CopyBmpToIco;
    exit;
  end;
  if FPng.AsPng <> nil then
  begin
    CopyPngToIco;
    exit;
  end;
  if FJpg.AsJpg <> nil then
  begin
    CopyJpgToIco;
    exit;
  end;
end;

procedure TDBFeld.CopyBmpToIco;
var
  ImageList: TImageList;
  Icon: TIcon;
  m: TMemoryStream;
begin
  FIco.InitValue;
  if FBmp.AsBitmap = nil then
    exit;
  m := TMemoryStream.Create;
  Icon := TIcon.Create;
  ImageList := TImageList.CreateSize(FBmp.AsBitmap.Width, FBmp.AsBitmap.Height);
  try
    ImageList.AddMasked(FBmp.AsBitmap, FBmp.AsBitmap.TransparentColor);
    ImageList.GetIcon(0, Icon);
    Icon.SaveToStream(m);
    FIco.SaveStream(m);
    FBmp.InitValue;
  finally
    FreeAndNil(ImageList);
    FreeAndNil(Icon);
    FreeAndNil(m);
  end;
end;

procedure TDBFeld.CopyPngToIco;
var
  Bmp: TBitmap;
begin
  FIco.InitValue;
  FBmp.InitValue;
  if FPng.AsPng = nil then
    exit;
  Bmp := TBitmap.Create;
  try
    bmp.Width  := FPng.AsPng.Width;
    bmp.Height := FPng.AsPng.Height;
    Fpng.AsPng.Draw(bmp.Canvas, bmp.Canvas.ClipRect);
    FBmp.Save(bmp);
    CopyBmpToIco;
    FPng.InitValue;
  finally
    FreeAndNil(Bmp);
  end;
end;

procedure TDBFeld.CopyJpgToIco;
var
  Bmp: TBitmap;
begin
  FIco.InitValue;
  FBmp.InitValue;
  if FJpg.AsJpg = nil then
    exit;
  Bmp := TBitmap.Create;
  try
    bmp.Width  := FJpg.AsJpg.Width;
    bmp.Height := FJpg.AsJpg.Height;
    FJpg.AsJpg.Transparent := true;
    bmp.Assign(FJpg.AsJpg);
    FBmp.Save(bmp);
    CopyBmpToIco;
    FJpg.InitValue;
  finally
    FreeAndNil(Bmp);
  end;
end;




end.
