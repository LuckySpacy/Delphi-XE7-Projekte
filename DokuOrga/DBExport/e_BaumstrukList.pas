unit e_BaumstrukList;

interface

uses
  SysUtils, Classes, o_Baumstruklist, o_DBGuid, Forms, Controls;

type
  TeBaumstrukList = class(TBaumstrukList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportBaumstrukList;
    procedure ImportBaumstrukList(aFileName: string);
  protected
    function getNotifyIndex: Integer; override;
  public
    constructor Create(AOwner: TComponent; aSpaltentrenner, aZeilentrenner, aTabname: string; aDatum: TDateTime); reintroduce; overload;
    destructor Destroy; override;
    procedure Init; override;
    procedure doExport;
    procedure doImport;
    property ExportPath: string read FExportPath write FExportPath;
    property ImportZipFile: string read FImportZipFile write FImportZipFile;
  end;

implementation

{ TeButtonpropList }


uses
  o_zweigprop, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj,
  o_baumbutton, o_baumstruk;

constructor TeBaumstrukList.Create(AOwner: TComponent; aSpaltentrenner,
  aZeilentrenner, aTabname: string; aDatum: TDateTime);
begin
  inherited Create(AOwner);
  FDatum := aDatum;
  FTabname := aTabname;
  FSpaltentrenner := aSpaltentrenner;
  FZeilentrenner  := aZeilentrenner;
  FExportPath := '';
  FGuidHelper := TDBGuid.Create(Self);
  Init;
end;

destructor TeBaumstrukList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeBaumstrukList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportBaumstrukList;
    ZipFileName := FExportPath + FTabname + '.zip';
    FileList := TStringList.Create;
    try
      GetAllFiles(FExportPath + FTabname + '\', FileList, true);
      SysObj.Zip(ZipFileName, FileList);
      ForceDelDirectory(FExportPath + FTabname + '\');
    finally
      FreeAndNil(FileList);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeBaumstrukList.doImport;
var
  Pfad: string;
  Filename: string;
  Cur: TCursor;
begin
  if FileExist(FImportZipFile) < 0 then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FImportZipFile)) + FTabname + '\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);

  SysObj.Unzip(FImportZipFile, Pfad);
  FileName := Pfad + FTabname + '.exp';
  if FileExist(FileName) < 0 then
    exit;

  Cur := Screen.Cursor;
  try
    ImportBaumstrukList(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeBaumstrukList.ExportBaumstruklist;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  Zweigprop: TZweigProp;
  BaumButton: TBaumButton;
  Baumstruk: TBaumstruk;
  Cur: TCursor;
  Pfad: string;
  Feldname: string;
begin
  Pfad := FExportPath + FTabname + '\';
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);
  FileName := Pfad + FTabname + '.exp';
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    AssignFile(myFile, Filename);
    ReWrite(myFile);
    ReadAllForExport(FDatum, 'asc');
    for i1 := 0 to FList.Count - 1 do
    begin
      s := '';
      Baumstruk := Item[i1];
      s := s + Baumstruk.GuidExportString;
      BaumButton := Baumstruk.Baumbutton;
      ZweigProp  := Baumstruk.ZweigProp;
      s := s + IntToStr(Baumstruk.Id) + FSpaltentrenner;
      for i2 := 0 to Baumstruk.DBList.Count -1 do
      begin
        Feldname := Baumstruk.DBList.Item[i2].Feldname;
        if SameText(Feldname, 'BS_Id') then
          continue;
        if  SameText(Feldname, 'BS_ZP_ID') then
        begin
          if (ZweigProp = nil) or (not ZweigProp.Found) then
            s := s + FSpaltentrenner
          else
            s := s + ZweigProp.Guid + FSpaltentrenner;
          continue;
        end;
        if  SameText(Feldname, 'BS_BB_ID') then
        begin
          if (BaumButton = nil) or (not BaumButton.Found) then
            s := s + FSpaltentrenner
          else
            s := s + BaumButton.Guid + FSpaltentrenner;
          continue;
        end;
        s := s + Baumstruk.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;

    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;


function TeBaumstrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

procedure TeBaumstrukList.ImportBaumstrukList(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  i1: Integer;
  sl: TTBStringList;
  ZweigProp: TZweigProp;
  Baumstruk: TBaumstruk;
  BaumButton: TBaumButton;
  DBGuid: TDBGuid;
  Pfad: string;
  Buffer: byte;
  Feldname: string;
begin
  if aFileName = '' then
    exit;
  Filename := aFileName;
  if not FileExists(Filename) then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
  ZweigProp  := TZweigProp.Create(nil);
  BaumButton := TBaumButton.Create(nil);
  Baumstruk  := TBaumstruk.Create(nil);
  sl := TTBStringList.Create;
  try
    //AssignFile(myFile, Filename);
    //Reset(myFile);
    myFile := TFileStream.Create(FileName, fmOpenRead);
    sl.Deli := FSpaltentrenner;
    //while not Eof(myFile) do
    while myFile.Position < myFile.Size do
    begin
      myFile.Read(Buffer, 1);
      s := s + chr(Buffer);
      if Pos(FZeilentrenner, s) > 0 then
      begin
        s := copy(s, 1, Length(s)-3);
        sl.Cut(s);
        s := '';
        FGuidHelper.LoadImportValues(sl);
        Baumstruk.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Baumstruk.Id > 0) and (Baumstruk.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to Baumstruk.DBList.Count -1 do
        begin
          Feldname := Baumstruk.DBList.Item[i1].Feldname;
          if SameText(Feldname, 'BS_Id') then
            continue;

          if  SameText(Feldname, 'BS_ZP_ID') then
          begin
            if sl.Strings[i1] > '' then
            begin
              ZweigProp.ReadByGuid(sl.Strings[i1]);
              if ZweigProp.Found then
                Baumstruk.Feld(Feldname).AsInteger := ZweigProp.Id;
            end;
            continue;
          end;

          if  SameText(Feldname, 'BS_BB_ID') then
          begin
            if sl.Strings[i1] > '' then
            begin
              BaumButton.ReadByGuid(sl.Strings[i1]);
              if BaumButton.Found then
                Baumstruk.Feld(Feldname).AsInteger := BaumButton.Id;
            end;
            continue;
          end;

          Baumstruk.Feld(Feldname).AsString := sl.Strings[i1];
        end;

        Baumstruk.Save;
        DBGuid := Baumstruk.DBGuid;
        DBGuid.ImportingData := true;
        DBGuid.Feld(GU_GUID).AsString := FGuidHelper.Feld(GU_GUID).AsString;
        DBGuid.Feld(GU_INSERT).AsString := FGuidHelper.Feld(GU_INSERT).AsString;
        DBGuid.Feld(GU_UPDATE).AsString := FGuidHelper.Feld(GU_UPDATE).AsString;
        DBGuid.Feld(GU_USERID_INSERT).AsString := FGuidHelper.Feld(GU_USERID_INSERT).AsString;
        DBGuid.Feld(GU_USERID_UPDATE).AsString := FGuidHelper.Feld(GU_USERID_UPDATE).AsString;
        DBGuid.Feld(GU_DELETE).AsString := FGuidHelper.Feld(GU_DELETE).AsString;
        DBGuid.Save;
      end;
    end;
  finally
    FreeAndNil(sl);
    FreeAndNil(Baumstruk);
    FreeAndNil(ZweigProp);
    FreeAndNil(BaumButton);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeBaumstrukList.Init;
begin
  inherited;

end;

end.
