unit e_BaumbuttonList;

interface

uses
  SysUtils, Classes, o_BaumbuttonList, o_DBGuid, Forms, Controls;

type
  TeBaumbuttonList = class(TBaumbuttonList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportBaumbutton;
    procedure ImportBaumbutton(aFileName: string);
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

{ TeBaumbuttonList }

uses
  o_baumbutton, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj,
  o_buttonprop;

constructor TeBaumbuttonList.Create(AOwner: TComponent; aSpaltentrenner,
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

destructor TeBaumbuttonList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeBaumbuttonList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportBaumbutton;
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

procedure TeBaumbuttonList.doImport;
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
    ImportBaumbutton(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeBaumbuttonList.ExportBaumbutton;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  Buttonprop: TButtonProp;
  BaumButton: TBaumbutton;
  Cur: TCursor;
  Pfad: string;
  Feldname: string;
begin
{
  Pfad := FExportPath + FTabname + '\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
  Buttonprop := TButtonProp.Create(Self);
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
      Baumbutton := Item[i1];
      s := s + Baumbutton.GuidExportString;
      Buttonprop.Read(Baumbutton.Feld(BB_BP_ID).AsInteger);
      if (not Buttonprop.Found) then
        continue;
      s := s + IntToStr(Baumbutton.Id) + FSpaltentrenner;
      s := s + Buttonprop.Guid + FSpaltentrenner;
      s := s + Baumbutton.Feld(BB_EBENE).AsString + FSpaltentrenner;
      s := s + Baumbutton.Feld(BB_DELETE).AsString + FSpaltentrenner;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;
    CloseFile(myFile);
  finally
    FreeAndNil(Buttonprop);
    Screen.Cursor := Cur;
  end;
  }

  Buttonprop := TButtonProp.Create(Self);
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
      BaumButton := Item[i1];
      s := s + BaumButton.GuidExportString;
      s := s + IntToStr(BaumButton.Id) + FSpaltentrenner;
      for i2 := 0 to BaumButton.DBList.Count -1 do
      begin
        Feldname := BaumButton.DBList.Item[i2].Feldname;
        if SameText(Feldname, 'BB_Id') then
          continue;
        if  SameText(Feldname, 'BB_BP_ID') then
        begin
          Buttonprop.Read(Baumbutton.Feld(BB_BP_ID).AsInteger);
          if (not Buttonprop.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Buttonprop.Guid + FSpaltentrenner;
          continue;
        end;
        if  SameText(Feldname, 'BB_EBENE') then
        begin
          Buttonprop.Read(Baumbutton.Feld(BB_EBENE).AsInteger);
          if (not Buttonprop.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Buttonprop.Guid + FSpaltentrenner;
          continue;
        end;
        s := s + BaumButton.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;

    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
    FreeAndNil(Buttonprop);
  end;

end;

function TeBaumbuttonList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

procedure TeBaumbuttonList.ImportBaumbutton(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  i1: Integer;
  //i2: Integer;
  s: string;
  sl: TTBStringList;
  Buttonprop: TButtonprop;
  Baumbutton: TBaumbutton;
  DBGuid: TDBGuid;
  Pfad: string;
  Buffer: byte;
  Feldname: string;
begin
{
  if aFileName = '' then
    exit;
  Filename := aFileName;
  if not FileExists(Filename) then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
  Baumbutton := TBaumbutton.Create(nil);
  Buttonprop := TButtonprop.Create(nil);
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
        Baumbutton.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Baumbutton.Id > 0) and (Baumbutton.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        Buttonprop.ReadByGuid(sl.Strings[1]);
        if not Buttonprop.Found then
          continue;

        Baumbutton.Feld(BB_BP_ID).AsInteger := Buttonprop.Id;
        Baumbutton.Feld(BB_EBENE).AsString := sl.Strings[2];
        Baumbutton.Feld(BB_DELETE).AsString := sl.Strings[3];

        Baumbutton.Save;
        DBGuid := Baumbutton.DBGuid;
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
    FreeAndNil(Baumbutton);
    FreeAndNil(Buttonprop);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
  }

  if aFileName = '' then
    exit;
  Filename := aFileName;
  if not FileExists(Filename) then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
  Buttonprop  := TButtonprop.Create(nil);
  BaumButton := TBaumButton.Create(nil);
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
        BaumButton.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (BaumButton.Id > 0) and (BaumButton.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to BaumButton.DBList.Count -1 do
        begin
          Feldname := BaumButton.DBList.Item[i1].Feldname;
          if SameText(Feldname, 'BB_Id') then
            continue;

          if (SameText(Feldname, 'BB_BP_ID')) or (SameText(Feldname, 'BB_EBENE')) then
          begin
            BaumButton.Feld(Feldname).AsInteger := 0;
            if sl.Strings[i1] > '' then
            begin
              Buttonprop.ReadByGuid(sl.Strings[i1]);
              if Buttonprop.Found then
                BaumButton.Feld(Feldname).AsInteger := Buttonprop.Id;
            end;
            continue;
          end;

          BaumButton.Feld(Feldname).AsString := sl.Strings[i1];
        end;

        BaumButton.Save;
        DBGuid := BaumButton.DBGuid;
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
    FreeAndNil(BaumButton);
    FreeAndNil(Buttonprop);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeBaumbuttonList.Init;
begin
  inherited;

end;

end.
