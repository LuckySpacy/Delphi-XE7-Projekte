unit o_DokumentGridIconList;

interface

uses
  SysUtils, Classes, Graphics, Contnrs, o_fileicon, Winapi.Windows, Vcl.ImgList, vcl.comCtrls,
  vcl.Controls, o_DokumentGridIcon;

type
  TDokumentGridIconList = class(TComponent)
  private
    fIconList: TObjectList;
    fIconFP: TIcon;
    fIconFTP: TIcon;
    fIconCloud: TIcon;
    fIconLink: TIcon;
    procedure CreateIcon(aIcon: TDokumentGridIcon);
    procedure AddToIcon(aIcon: TIcon; aDokIcon: TDokumentGridIcon);
    procedure Icon2Bitmap(aIcon: TIcon; aBitmap: Graphics.TBitmap); overload;
    procedure Bitmap2Icon(aBmp: Graphics.TBitmap; aIcon: TIcon);
    procedure Icon2Bitmap(aIcon1, aIcon2: TIcon; aAbstand: Integer; aBitmap: Graphics.TBitmap); overload;
    procedure AddToBitmap(aBitmap: Graphics.TBitmap; aIcon: TIcon);
  protected
  public
    destructor Destroy; override;
    constructor Create(aOwner: TComponent); override;
    function getIcon(aFP, aFTP, aCloud, aLink: Boolean): TIcon;
    function getDokumentGridIcon(aFP, aFTP, aCloud, aLink: Boolean): TDokumentGridIcon;
    function AddDokumentGridIcon(aFP, aFTP, aCloud, aLink: Boolean): TDokumentGridIcon;
  end;

implementation

{ TDokumentGridIconList }

uses
  o_sysObj;


constructor TDokumentGridIconList.Create(aOwner: TComponent);
begin
  inherited;
  fIconList := TObjectList.Create;

  fIconFP    := TIcon.Create;
  fIconFTP   := TIcon.Create;
  fIconCloud := TIcon.Create;
  fIconLink  := TIcon.Create;


  SysObj.LoadIconFromRes('RT_RCDATA', 'docs', fIconFP);
  SysObj.LoadIconFromRes('RT_RCDATA', 'doci', fIconFTP);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docc', fIconCloud);
  SysObj.LoadIconFromRes('RT_RCDATA', 'Link', fIconLink);

end;


destructor TDokumentGridIconList.Destroy;
begin
  FreeAndNil(fIconList);
  FreeAndNil(fIconFP);
  FreeAndNil(fIconFTP);
  FreeAndNil(fIconFTP);
  FreeAndNil(fIconLink);
  inherited;
end;

function TDokumentGridIconList.getDokumentGridIcon(aFP, aFTP, aCloud,
  aLink: Boolean): TDokumentGridIcon;
var
  i1: Integer;
  x: TDokumentGridIcon;
begin
  for i1 := 0 to fIconList.Count -1 do
  begin
    x := TDokumentGridIcon(fIconList.Items[i1]);
    if (x.FP = aFP) and (x.Cloud = aCloud) and (x.FTP = aFTP) and (x.Link = aLink) then
    begin
      Result := x;
      exit;
    end;
  end;
  Result := AddDokumentGridIcon(aFP, aFTP, aCloud, aLink);
end;

function TDokumentGridIconList.getIcon(aFP, aFTP, aCloud,
  aLink: Boolean): TIcon;
var
  x: TDokumentGridIcon;
  i1: Integer;
  fBitmap: Graphics.TBitmap;
begin
  Result := nil;
  x := getDokumentGridIcon(aFP, aFTP, aCloud, aLink);
  if x <> nil then
    Result := x.Icon;
  {
  x := TDokumentGridIcon.Create;
  fIconList.Add(X);
  x.FP := aFP;
  x.Cloud := aCloud;
  x.FTP := aFTP;
  x.Link := aLink;

  fBitmap := Graphics.TBitmap.create;
  try
    fBitmap.Height := 16;
    if x.FP then
      AddToBitmap(fBitmap, fIconFP);
    if x.FTP then
      AddToBitmap(fBitmap, fIconFTP);
    if x.Cloud then
      AddToBitmap(fBitmap, fIconCloud);
    if x.Link then
      AddToBitmap(fBitmap, fIconLink);
    Bitmap2Icon(fBitmap, x.Icon);
  finally
    FreeAndNil(fBitmap);
  end;

  Result := x.Icon;
  }
end;

function TDokumentGridIconList.AddDokumentGridIcon(aFP, aFTP, aCloud,
  aLink: Boolean): TDokumentGridIcon;
var
  x: TDokumentGridIcon;
  i1: Integer;
  fBitmap: Graphics.TBitmap;
begin
  x := TDokumentGridIcon.Create;
  fIconList.Add(X);
  x.FP := aFP;
  x.Cloud := aCloud;
  x.FTP := aFTP;
  x.Link := aLink;

  fBitmap := Graphics.TBitmap.create;
  try
    fBitmap.Height := 16;
    if x.FP then
      AddToBitmap(fBitmap, fIconFP);
    if x.FTP then
      AddToBitmap(fBitmap, fIconFTP);
    if x.Cloud then
      AddToBitmap(fBitmap, fIconCloud);
    if x.Link then
      AddToBitmap(fBitmap, fIconLink);
    Bitmap2Icon(fBitmap, x.Icon);
  finally
    FreeAndNil(fBitmap);
  end;

  Result := x;

end;



procedure TDokumentGridIconList.AddToBitmap(aBitmap: Graphics.TBitmap;
  aIcon: TIcon);
var
  Bitmap: Graphics.TBitmap;
  r: TRect;
begin
  Bitmap := Graphics.TBitmap.Create;
  try
    Icon2Bitmap(aIcon, Bitmap);
    r.Top  := 0;
    r.Left := aBitmap.Width;
    r.Right := aBitmap.Width + Bitmap.Width;
    r.Bottom := 16;
    aBitmap.Width := aBitmap.Width + Bitmap.Width;
    aBitmap.PixelFormat := pf24bit;
    aBitmap.Canvas.Brush.Color := clFuchsia;
    aBitmap.Canvas.FillRect(r);
    aBitmap.canvas.Draw(r.Left, r.Top, Bitmap);
  finally
    FreeAndNil(Bitmap);
  end;
end;


procedure TDokumentGridIconList.AddToIcon(aIcon: TIcon;
  aDokIcon: TDokumentGridIcon);
var
  fBitmap: Graphics.TBitmap;
begin
  fBitmap := Graphics.TBitmap.create;
  try
    if aDokIcon.Icon = nil then
    begin
      aDokIcon.Icon := TIcon.Create;
      Icon2Bitmap(aIcon, fBitmap)
    end
    else
      Icon2Bitmap(aDokIcon.Icon, aIcon, 0, fBitmap);
    Bitmap2Icon(fBitmap, aDokIcon.Icon);
  finally
    FreeAndNil(fBitmap);
  end;
end;

procedure TDokumentGridIconList.Icon2Bitmap(aIcon: TIcon; aBitmap: Graphics.TBitmap);
begin
  aBitmap.Width  := aIcon.Width;
  aBitmap.Height := aIcon.Height;
  aBitmap.PixelFormat := pf24bit;
  aBitmap.Canvas.Brush.Color := clBtnFace;
  aBitmap.Canvas.FillRect(aBitmap.Canvas.ClipRect);
  aBitmap.Canvas.Draw(0,0, aIcon);
end;

procedure TDokumentGridIconList.Icon2Bitmap(aIcon1, aIcon2: TIcon; aAbstand: Integer; aBitmap: Graphics.TBitmap);
begin
  aBitmap.Width  := aIcon1.Width + aAbstand + aIcon2.Width;
  aBitmap.Height := aIcon1.Height;
  aBitmap.PixelFormat := pf24bit;
  aBitmap.Canvas.Brush.Color := clBtnFace;
  aBitmap.Canvas.FillRect(aBitmap.Canvas.ClipRect);
  aBitmap.Canvas.Draw(0,0, aIcon1);
  aBitmap.Canvas.Draw(aIcon1.Width + aAbstand,0, aIcon2);
end;

procedure TDokumentGridIconList.Bitmap2Icon(aBmp: Graphics.TBitmap; aIcon: TIcon);
var
  ImageList: TImageList;
begin
  ImageList := TImageList.CreateSize(aBmp.Width, aBmp.Height);
  try
    ImageList.Height := aBmp.Height;
    ImageList.Width  := aBmp.Width;
    ImageList.AddMasked(aBmp, aBmp.TransparentColor);
    ImageList.GetIcon(0, aIcon);
  finally
    ImageList.Free;
  end;
end;


procedure TDokumentGridIconList.CreateIcon(aIcon: TDokumentGridIcon);
begin

end;


end.
