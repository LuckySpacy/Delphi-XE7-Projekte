unit o_DataTrans;

interface

uses
  SysUtils, Classes, ZipMstr, Windows;

type
  TDataTrans = class(TComponent)
  private
    FExportPath: string;
    FZipName: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ExportAll;
    procedure ImportAll;
    procedure ExportImport_SysSprache(aExport: Boolean);
    property ExportPath: string read FExportPath write FExportPath;
    property Zipname: string read FZipName write FZipName;
    procedure Zip;
    procedure Unzip;
    procedure Import_SysSprache;
  end;


implementation

{ TDataTrans }

uses
  e_SysSpracheList, u_RegIni, u_System;

constructor TDataTrans.Create(AOwner: TComponent);
begin
  inherited;
  FExportPath := '';
  FZipName := '';
end;

destructor TDataTrans.Destroy;
begin

  inherited;
end;


procedure TDataTrans.ExportAll;
begin
  ExportImport_SysSprache(true);
end;

procedure TDataTrans.ExportImport_SysSprache(aExport: Boolean);
var
  eSysSprachList: TeSysSpracheList;
begin
  eSysSprachList := TeSysSpracheList.Create(nil);
  try
    eSysSprachList.ExportPath := FExportPath;
    if aExport then
      eSysSprachList.doExport
    else
      eSysSprachList.doImport;
  finally
    FreeAndNil(eSysSprachList);
  end;
end;

procedure TDataTrans.ImportAll;
begin
  if FZipname = '' then
    exit;
  if FExportPath = '' then
    exit;
  Unzip;
  Import_SysSprache;
end;

procedure TDataTrans.Import_SysSprache;
var
  sl: TStringList;
  i1: Integer;
begin
  sl  := TStringList.Create;
  try
    GetAllFiles(FExportPath, sl, true, false, '*.exp');
    for i1 := 0 to sl.Count - 1 do
    begin
      if SameText(ExtractFileName(sl.Strings[i1]), 'syssprache.exp') then
        ExportImport_SysSprache(false);
    end;
  finally
    FreeAndNil(sl);
  end;
end;

procedure TDataTrans.Unzip;
var
  Zip: TZipMaster;
begin
  if FZipname = '' then
    exit;

  Zip := TZipMaster.Create(nil);
  try
    Zip.ZipFileName := IncludeTrailingPathDelimiter(FExportPath) + FZipName;
    Zip.ExtrBaseDir := FExportPath;
    Zip.ExtrOptions := Zip.ExtrOptions + [ExtrOverWrite];
    if FileExist(Zip.ZipFileName) < 0 then
      exit;
    Zip.Extract;
  finally
    FreeAndNil(Zip);
  end;
end;

procedure TDataTrans.Zip;
var
  Zip: TZipMaster;
  sl: TStringList;
  i1: Integer;
begin
  if FZipname = '' then
    exit;
  sl  := TStringList.Create;
  Zip := TZipMaster.Create(nil);
  try
    Zip.ZipFileName := IncludeTrailingPathDelimiter(FExportPath) + FZipName;
    SysUtils.DeleteFile(Zip.ZipFileName);
    GetAllFiles(FExportPath, sl, true, false, '*.exp');
    for i1 := 0 to sl.Count - 1 do
    begin
      Zip.FSpecArgs.Add(sl.Strings[i1]);
    end;
    Zip.Add;
    for i1 := 0 to sl.Count - 1 do
    begin
      SysUtils.DeleteFile(sl.Strings[i1]);
    end;
  finally
    FreeAndNil(sl);
    FreeAndNil(Zip);
  end;
end;

end.
