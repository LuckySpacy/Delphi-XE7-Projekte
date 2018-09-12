unit e_SeiteverbindenList;

interface
uses
  SysUtils, Classes, o_SeiteverbindenList, o_DBGuid, Forms, Controls;

type
  TeSeiteverbindenList = class(TSeiteverbindenList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportZweigProp;
    procedure ImportZweigProp(aFileName: string);
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
  o_seiteverbinden, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj,
  o_Baumstruk, o_seite, o_Baumbutton;


constructor TeSeiteverbindenList.Create(AOwner: TComponent; aSpaltentrenner,
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

destructor TeSeiteverbindenList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeSeiteverbindenList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportZweigProp;
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

procedure TeSeiteverbindenList.doImport;
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
    ImportZweigProp(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeSeiteverbindenList.ExportZweigProp;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  Seiteverbinden: TSeiteverbinden;
  Seite: TSeite;
  Baumstruk: TBaumstruk;
  Baumbutton: TBaumbutton;
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
      Seiteverbinden := Item[i1];
      s := s + Seiteverbinden.GuidExportString;
      Seite     := Seiteverbinden.Seite;
      Baumstruk := Seiteverbinden.Baumstruk;
      Baumbutton := Seiteverbinden.BaumButton;
      s := s + IntToStr(Seiteverbinden.Id) + FSpaltentrenner;
      for i2 := 0 to Seiteverbinden.DBList.Count -1 do
      begin
        Feldname := Seiteverbinden.DBList.Item[i2].Feldname;
        if SameText(Feldname, 'VS_Id') then
          continue;
        if  SameText(Feldname, 'VS_SE_ID') then
        begin
          if (Seite = nil) or (not Seite.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Seite.Guid + FSpaltentrenner;
          continue;
        end;

        if  SameText(Feldname, 'VS_BS_ID') then
        begin
          if (Baumstruk = nil) or (not Baumstruk.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Baumstruk.Guid + FSpaltentrenner;
          continue;
        end;

        if  SameText(Feldname, 'VS_EBENE') then
        begin
          if (Baumbutton = nil) or (not Baumbutton.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Baumbutton.Guid + FSpaltentrenner;
          continue;
        end;


        s := s + Seiteverbinden.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;

    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;


function TeSeiteverbindenList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

procedure TeSeiteverbindenList.ImportZweigProp(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  i1: Integer;
  sl: TTBStringList;
  Seiteverbinden: TSeiteverbinden;
  Seite: TSeite;
  Baumstruk: TBaumstruk;
  Baumbutton: TBaumbutton;
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
  Baumstruk := TBaumstruk.Create(nil);
  Baumbutton := TBaumbutton.Create(nil);
  Seite     := TSeite.Create(nil);
  Seiteverbinden := TSeiteverbinden.Create(nil);
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
        Seiteverbinden.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Seiteverbinden.Id > 0) and (Seiteverbinden.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to Seiteverbinden.DBList.Count -1 do
        begin
          Feldname := Seiteverbinden.DBList.Item[i1].Feldname;
          if SameText(Feldname, 'VS_Id') then
            continue;

          if  SameText(Feldname, 'VS_BS_ID') then
          begin
            Seiteverbinden.Feld(Feldname).AsInteger := 0;
            if sl.Strings[i1] > '' then
            begin
              Baumstruk.ReadByGuid(sl.Strings[i1]);
              if Baumstruk.Found then
                Seiteverbinden.Feld(Feldname).AsInteger := Baumstruk.Id;
            end;
            continue;
          end;

          if  SameText(Feldname, 'VS_SE_ID') then
          begin
            if sl.Strings[i1] > '' then
            begin
              Seite.ReadByGuid(sl.Strings[i1]);
              if Seite.Found then
                Seiteverbinden.Feld(Feldname).AsInteger := Seite.Id;
            end;
            continue;
          end;

          if  SameText(Feldname, 'VS_EBENE') then
          begin
            Seiteverbinden.Feld(Feldname).AsInteger := 0;
            if sl.Strings[i1] > '' then
            begin
              Baumbutton.ReadByGuid(sl.Strings[i1]);
              if Baumbutton.Found then
                Seiteverbinden.Feld(Feldname).AsInteger := Baumbutton.Id;
            end;
            continue;
          end;


          Seiteverbinden.Feld(Feldname).AsString := sl.Strings[i1];
        end;

        Seiteverbinden.Save;
        DBGuid := Seiteverbinden.DBGuid;
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
    FreeAndNil(Seiteverbinden);
    FreeAndNil(Baumstruk);
    FreeAndNil(Baumbutton);
    FreeAndNil(Seite);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeSeiteverbindenList.Init;
begin
  inherited;

end;

end.
