unit e_GuidList;

interface

uses
  SysUtils, Classes, Forms, Controls;

type
  TeGuidList = class
  private
    FExportPath: string;
    FImportZipFile: string;
    FDatum: TDateTime;
    FTabname: string;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure ExportGuid;
    procedure ImportGuid(aFileName: string);
  protected
  public
    constructor Create(AOwner: TComponent; aSpaltentrenner, aZeilentrenner, aTabname: string; aDatum: TDateTime);
    destructor Destroy; override;
    procedure Init;
    procedure doExport;
    procedure doImport;
    property ExportPath: string read FExportPath write FExportPath;
    property ImportZipFile: string read FImportZipFile write FImportZipFile;
  end;

implementation

{ TeButtonpropList }

uses
  o_DBField, tbStringList, c_Types, c_DBTypes, u_system, o_sysObj, IBDatabase, IBQuery,
  o_baumbutton, o_baumstruk, o_benutzer, o_bilder, o_buttonprop, o_dokument, o_itemlist,
  o_seite, o_seitedokument, o_seiteverbinden, o_sprache, o_sprachlist, o_zweigprop;

constructor TeGuidList.Create(AOwner: TComponent; aSpaltentrenner,
  aZeilentrenner, aTabname: string; aDatum: TDateTime);
begin
  FDatum := aDatum;
  FTabname := aTabname;
  FSpaltentrenner := aSpaltentrenner;
  FZeilentrenner  := aZeilentrenner;
  FExportPath := '';
  Init;
end;

destructor TeGuidList.Destroy;
begin

  inherited;
end;

procedure TeGuidList.doExport;
var
  Cur: TCursor;
  ZipFileName: string;
  FileList: TStringList;
begin
  if FExportPath = '' then
    exit;
  Cur := Screen.Cursor;
  try
    ExportGuid;
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

procedure TeGuidList.doImport;
var
  Pfad: string;
  Filename: string;
  Cur: TCursor;
begin
  if FileExist(FImportZipFile) < 0 then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FImportZipFile)) + FTabname + '\';
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);

  SysObj.Unzip(FImportZipFile, Pfad);
  FileName := Pfad + FTabname + '.exp';
  if FileExist(FileName) < 0 then
    exit;

  Cur := Screen.Cursor;
  try
    ImportGuid(FileName);
    ForceDelDirectory(Pfad);
  finally
    Screen.Cursor := Cur;
  end;
end;

procedure TeGuidList.ExportGuid;
var
  Filename: string;
  myFile: TextFile;
  s: string;
  qry: TIBQuery;
  ibt: TIBTransaction;
  Cur: TCursor;
  Pfad: string;
  //Feldname: string;
begin
  Pfad := FExportPath + FTabname + '\';
  ForceDelDirectory(Pfad);
  ForceDirectories(Pfad);
  FileName := Pfad + FTabname + '.exp';
  Cur := Screen.Cursor;
  ibt := TIBTransaction.Create(nil);
  qry := TIBQuery.Create(nil);
  try
    ibt.DefaultDatabase := SysObj.Database;
    qry.Database := SysObj.Database;
    qry.Transaction := ibt;
    qry.SQL.Text := 'select * from guid where gu_delete = ' + QuotedStr('T') + ' and gu_update >= ' + QuotedStr(DateToStr(FDatum));
    Screen.Cursor := crHourGlass;
    AssignFile(myFile, Filename);
    ReWrite(myFile);
    qry.Open;
    while not qry.eof do
    begin
      s := qry.FieldByName('gu_guid').AsString + FSpaltentrenner;
      s := s + qry.FieldByName('gu_refkey').AsString + FSpaltentrenner;
      s := s + qry.FieldByName('gu_refid').AsString + FSpaltentrenner;
      s := s + qry.FieldByName('gu_update').AsString + FSpaltentrenner;
      s := s + qry.FieldByName('gu_delete').AsString + FSpaltentrenner;
      s := s + FZeilentrenner;
      Write(myFile, s);
      qry.Next;
    end;
    CloseFile(myFile);
  finally
    FreeAndNil(ibt);
    FreeAndNil(qry);
    Screen.Cursor := Cur;
  end;
end;


procedure TeGuidList.ImportGuid(aFileName: string);
var
  myFile: TFileStream;
  Filename: string;
  s: string;
  //i1: Integer;
  sl: TTBStringList;
  Pfad: string;
  Buffer: byte;
  //Feldname: string;
  Guid: string;
  RefKey: string;
  //RefId : Integer;
  Update: string;
  Delete: string;
  BaumButton: TBaumbutton;
  Baumstruk: TBaumstruk;
  Benutzer: TBenutzer;
  Bilder: TBilder;
  Buttonprop: TButtonprop;
  Dokument: TDokument;
  ItemList: TDBItemList;
  Seite: TSeite;
  Seitedokument: TSeitedokument;
  Seiteverbinden: TSeiteverbinden;
  Sprache: TSprache;
  Sprachlist: TSprachlist;
  Zweigprop: TZweigprop;
begin
  if aFileName = '' then
    exit;
  Filename := aFileName;
  if not FileExists(Filename) then
    exit;
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(FileName));
  Baumstruk      := TBaumstruk.Create(nil);
  Baumbutton     := TBaumButton.Create(nil);
  Benutzer       := TBenutzer.Create(nil);
  Bilder         := TBilder.Create(nil);
  Buttonprop     := TButtonprop.Create(nil);
  Dokument       := TDokument.Create(nil);
  ItemList       := TDBItemList.Create(nil);
  Seite          := TSeite.Create(nil);
  Seitedokument  := TSeitedokument.Create(nil);
  Seiteverbinden := TSeiteverbinden.Create(nil);
  Sprache        := TSprache.Create(nil);
  Sprachlist     := TSprachlist.Create(nil);
  Zweigprop      := TZweigprop.Create(nil);
  sl := TTBStringList.Create;
  try
    myFile := TFileStream.Create(FileName, fmOpenRead);
    sl.Deli := FSpaltentrenner;
    while myFile.Position < myFile.Size do
    begin
      myFile.Read(Buffer, 1);
      s := s + chr(Buffer);
      if Pos(FZeilentrenner, s) > 0 then
      begin
        s := copy(s, 1, Length(s)-3);
        sl.Cut(s);
        s := '';

        Guid := sl.Strings[0];
        RefKey := sl.Strings[1];
        //RefId  := StrToInt(sl.Strings[2]);
        Update := sl.Strings[3];
        Delete := sl.Strings[4];

        if RefKey = 'BB' then
        begin
          Baumbutton.ReadByGuid(Guid);
          if Baumbutton.Id > 0 then
            Baumbutton.Delete;
        end;

        if RefKey = 'BS' then
        begin
          Baumstruk.ReadByGuid(Guid);
          if Baumstruk.Id > 0 then
            Baumstruk.Delete;
        end;

        if RefKey = 'BE' then
        begin
          Benutzer.ReadByGuid(Guid);
          if Benutzer.Id > 0 then
            Benutzer.Delete;
        end;

        if RefKey = 'BI' then
        begin
          Bilder.ReadByGuid(Guid);
          if Bilder.Id > 0 then
            Bilder.Delete;
        end;

        if RefKey = 'BP' then
        begin
          Buttonprop.ReadByGuid(Guid);
          if Buttonprop.Id > 0 then
            Buttonprop.Delete;
        end;

        if RefKey = 'DO' then
        begin
          Dokument.ReadByGuid(Guid);
          if Dokument.Id > 0 then
            Dokument.Delete;
        end;

        if RefKey = 'IT' then
        begin
          Itemlist.ReadByGuid(Guid);
          if Itemlist.Id > 0 then
            ItemList.Delete;
        end;

        if RefKey = 'SE' then
        begin
          Seite.ReadByGuid(Guid);
          if Seite.Id > 0 then
            Seite.Delete;
        end;

        if RefKey = 'SD' then
        begin
          Seitedokument.ReadByGuid(Guid);
          if Seitedokument.Id > 0 then
            Seitedokument.Delete;
        end;

        if RefKey = 'VS' then
        begin
          Seiteverbinden.ReadByGuid(Guid);
          if Seiteverbinden.Id > 0 then
            Seiteverbinden.Delete;
        end;

        if RefKey = 'SP' then
        begin
          Sprache.ReadByGuid(Guid);
          if Sprache.Id > 0 then
            Sprache.Delete;
        end;

        if RefKey = 'SL' then
        begin
          SprachList.ReadByGuid(Guid);
          if SprachList.Id > 0 then
            SprachList.Delete;
        end;

        if RefKey = 'ZP' then
        begin
          ZweigProp.ReadByGuid(Guid);
          if ZweigProp.Id > 0 then
            ZweigProp.Delete;
        end;
      end;
    end;
  finally
    FreeAndNil(sl);
    FreeAndNil(Baumbutton);
    FreeAndNil(Baumstruk);
    FreeAndNil(Benutzer);
    FreeAndNil(Bilder);
    FreeAndNil(Buttonprop);
    FreeAndNil(Dokument);
    FreeAndNil(ItemList);
    FreeAndNil(Seite);
    FreeAndNil(Seitedokument);
    FreeAndNil(Seiteverbinden);
    FreeAndNil(Sprache);
    FreeAndNil(Sprachlist);
    FreeAndNil(Zweigprop);
    try
      FreeAndNil(myFile);
    except
    end;
  end;
end;

procedure TeGuidList.Init;
begin
  inherited;

end;

end.
