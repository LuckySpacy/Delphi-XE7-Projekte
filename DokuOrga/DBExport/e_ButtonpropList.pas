unit e_ButtonpropList;

interface

uses
  SysUtils, Classes, o_ButtonpropList, o_DBGuid, Forms, Controls;

type
  TeButtonpropList = class(TButtonpropList)
  private
    FExportPath: string;
    FGuidHelper: TDBGuid;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportButtonprop;
    procedure ImportButtonprop(aFileName: string);
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
  o_buttonprop, o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj,
  o_itemlist, o_bilder;

constructor TeButtonpropList.Create(AOwner: TComponent; aSpaltentrenner,
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

destructor TeButtonpropList.Destroy;
begin
  FreeAndNil(FGuidHelper);
  inherited;
end;

procedure TeButtonpropList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportButtonprop;
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

procedure TeButtonpropList.doImport;
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
    ImportButtonprop(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeButtonpropList.ExportButtonprop;
var
  Filename: string;
  myFile: TextFile;
  i1, i2: Integer;
  s: string;
  Buttonprop: TButtonProp;
  Bilder: TBilder;
  Itemlist: TDBItemList;
  Cur: TCursor;
  Pfad: string;
  Feldname: string;
begin
  Pfad := FExportPath + FTabname + '\';
  //if not ForceDelDirectory(Pfad) then
  //  exit;
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
      Buttonprop := Item[i1];
      s := s + Buttonprop.GuidExportString;
      Bilder   := Buttonprop.Bilder;
      Itemlist := Buttonprop.Itemlist;
      s := s + IntToStr(Buttonprop.Id) + FSpaltentrenner;
      for i2 := 0 to Buttonprop.DBList.Count -1 do
      begin
        Feldname := Buttonprop.DBList.Item[i2].Feldname;
        if SameText(Feldname, 'BP_Id') then
          continue;
        if  SameText(Feldname, 'BP_BI_ID') then
        begin
          if (Bilder = nil) or (not Bilder.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Bilder.Guid + FSpaltentrenner;
          continue;
        end;
        if  SameText(Feldname, 'BP_IT_ID') then
        begin
          if (Itemlist = nil) or (not Itemlist.Found) then
            s := s + FSpaltentrenner
          else
            s := s + Itemlist.Guid + FSpaltentrenner;
          continue;
        end;
        s := s + Buttonprop.Feld(Feldname).AsString + FSpaltentrenner;
      end;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;

   // Beispiel für export und impoert

    {
    for i1 := 0 to FList.Count - 1 do
    begin
      s := '';
      Buttonprop := Item[i1];
      s := s + Buttonprop.GuidExportString;
      Bilder := Buttonprop.Bilder;
      if (Bilder = nil) or (not Bilder.Found) then
        s := s + FSpaltentrenner
      else
        s := s + IntToStr(Buttonprop.Id) + FSpaltentrenner;
      s := s + Bilder.Guid + FSpaltentrenner;
      Itemlist := Buttonprop.Itemlist;
      if (Itemlist = nil) or (not Itemlist.Found) then
        continue;
      s := s + Itemlist.Guid + FSpaltentrenner;
      s := s + Buttonprop.Feld(BP_TEXT).AsString + FSpaltentrenner;
      s := s + Buttonprop.Feld(BP_USEPW).AsString + FSpaltentrenner;
      s := s + Buttonprop.Feld(BP_DELETE).AsString + FSpaltentrenner;
      s := s + FZeilentrenner;
      Write(myFile, s);
    end;
    }
    CloseFile(myFile);
  finally
    Screen.Cursor := Cur;
  end;
end;


function TeButtonpropList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

procedure TeButtonpropList.ImportButtonprop(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
//  Letter: Char;
  s: string;
  i1: Integer;
  sl: TTBStringList;
  Buttonprop: TButtonprop;
  Bilder: TBilder;
  Itemlist: TDBItemlist;
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
  Bilder := TBilder.Create(nil);
  Itemlist := TDBItemlist.Create(nil);
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
        Buttonprop.ReadByGuid(FGuidHelper.Feld(GU_GUID).AsString);
        if (Buttonprop.Id > 0) and (Buttonprop.UpdateAsDateTime >= FGuidHelper.Feld('GU_Update').AsDateTime) then
          continue;

        for i1 := 1 to Buttonprop.DBList.Count -1 do
        begin
          Feldname := Buttonprop.DBList.Item[i1].Feldname;
          if SameText(Feldname, 'BP_Id') then
            continue;

          if  SameText(Feldname, 'BP_BI_ID') then
          begin
            if sl.Strings[i1] > '' then
            begin
              Bilder.ReadByGuid(sl.Strings[i1]);
              if Bilder.Found then
                Buttonprop.Feld(Feldname).AsInteger := Bilder.Id;
            end;
            continue;
          end;
          if  SameText(Feldname, 'BP_IT_ID') then
          begin
            if sl.Strings[i1] > '' then
            begin
              Itemlist.ReadByGuid(sl.Strings[i1]);
              if Itemlist.Found then
                Buttonprop.Feld(Feldname).AsInteger := ItemList.Id;
            end;
            continue;
          end;
          Buttonprop.Feld(Feldname).AsString := sl.Strings[i1];
        end;

        {
        Bilder.ReadByGuid(sl.Strings[1]);
        if not Bilder.Found then
          continue;
        Itemlist.ReadByGuid(sl.Strings[2]);
        if not Itemlist.Found then
          continue;

        Buttonprop.Feld(BP_BI_ID).AsInteger := Bilder.Id;
        Buttonprop.Feld(BP_IT_ID).AsInteger := ItemList.Id;
        Buttonprop.Feld(BP_TEXT).AsString := sl.Strings[3];
        Buttonprop.Feld(BP_USEPW).AsString := sl.Strings[4];
        Buttonprop.Feld(BP_DELETE).AsString := sl.Strings[5];
         }

        Buttonprop.Save;
        DBGuid := Buttonprop.DBGuid;
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
    FreeAndNil(Itemlist);
    FreeAndNil(Bilder);
    FreeAndNil(Buttonprop);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeButtonpropList.Init;
begin
  inherited;

end;

end.
