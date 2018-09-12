unit o_SeiteDokument;

interface

uses
  SysUtils, Classes, o_SeiteDokument_BaseStruk, o_Seite, o_dokument, o_seitelink,
  o_seitedokumentlink;

type
  TSeiteDokument = class(TSeiteDokument_BaseStruk)
  private
    FSeite: TSeite;
    FDokument: TDokument;
    FSeiteLink: TSeiteLink;
    FSeitedokumentLink: TSeiteDokumentLink;
    function getSeite: TSeite;
    function getDokument: TDokument;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure Delete; override;
    function DokumentExist(aDokumentId: Integer): Boolean;
    procedure Read(aSeiteId, aDokumentId: Integer); reintroduce; overload;
    property Seite: TSeite read getSeite write FSeite;
    property Dokument: TDokument read getDokument write FDokument;
  end;

implementation

{ TSeiteDokument }

uses
  c_DBTypes, c_types, o_seitedokumentlist, o_seitelinklist, o_seitedokumentlinklist;

constructor TSeiteDokument.Create(AOwner: TComponent);
begin
  inherited;
  FSeite := nil;
  FDokument := nil;
  FSeiteLink := TSeiteLink.Create(Self);
  FSeitedokumentLink := TSeiteDokumentLink.Create(Self);
end;


destructor TSeiteDokument.Destroy;
begin
  if FSeite <> nil then
    FreeAndNil(FSeite);
  if FDokument <> nil then
    FreeAndNil(FDokument);
  FreeAndNil(FSeiteLink);
  FreeAndNil(FSeitedokumentLink);
  inherited;
end;

function TSeiteDokument.DokumentExist(aDokumentId: Integer): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select count(*) from  ' + getTableName +
                     ' where SD_DELETE != ' + QuotedStr('T') +
                     ' and SD_DO_ID = ' + IntToStr(aDokumentId);
  OpenTrans;
  FQuery.Open;
  Result := FQuery.Fields[0].AsInteger > 0;
  RollbackTrans;
end;

function TSeiteDokument.getDokument: TDokument;
begin
  if (FDokument <> nil) and (FDokument.Id = Feld(SD_DO_ID).AsInteger) then
  begin
    Result := FDokument;
    exit;
  end;
  if (FDokument <> nil) then
    FreeAndNil(FDokument);
  FDokument := TDokument.Create(Self);
  FDokument.Read(Feld(SD_DO_ID).AsInteger);
  if not FDokument.Found then
    FreeAndNil(FDokument);
  Result := FDokument;
end;

function TSeiteDokument.getSeite: TSeite;
begin
  if (FSeite <> nil) and (FSeite.Id = Feld(SD_SE_ID).AsInteger) then
  begin
    Result := FSeite;
    exit;
  end;
  if (FSeite <> nil) then
    FreeAndNil(FSeite);
  FSeite := TSeite.Create(Self);
  FSeite.Read(Feld(SD_SE_ID).AsInteger);
  if not FSeite.Found then
    FreeAndNil(FSeite);
  Result := FSeite;
end;

procedure TSeiteDokument.Init;
begin
  inherited;

end;

procedure TSeiteDokument.Read(aSeiteId, aDokumentId: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where SD_DELETE != ' + QuotedStr('T') +
                     ' and SD_DO_ID = ' + IntToStr(aDokumentId) +
                     ' and SD_SE_ID = ' + IntToStr(aSeiteId);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;

function TSeiteDokument.Save: Boolean;
var
  SeiteDokumentList: TSeiteDokumentList;
  SeiteLinkList: TSeiteLinkList;
  SeiteDokumentLinkList: TSeiteDokumentLinkList;
  i1: Integer;
  i2: Integer;
  i3: Integer;
  Found: Boolean;
begin
  Result := inherited;
  if not FSeiteLink.HatDieseSeiteLinks(FDBList.Names(SD_SE_ID).AsInteger, csl_Dokument) then
    exit;
  SeiteLinkList     := TSeiteLinkList.Create(nil);
  SeiteDokumentList := TSeiteDokumentList.Create(nil);
  SeiteDokumentLinkList := TSeiteDokumentLinkList.Create(nil);
  try
    SeiteDokumentList.ReadAll(FDBList.Names(SD_SE_ID).AsInteger);
    SeiteLinkList.ReadAll(FDBList.Names(SD_SE_ID).AsInteger);
    for i1 := 0 to SeiteLinkList.Count -1 do
    begin
      SeiteDokumentLinkList.ReadAllLinks(FDBList.Names(SD_SE_ID).AsInteger);
      for i2 := 0 to SeiteDokumentList.Count -1 do
      begin
        Found := false;
        for i3 := 0 to SeiteDokumentLinkList.Count -1 do
        begin
          if (SeiteDokumentLinkList.Item[i3].Dokument.Id = SeiteDokumentList.Item[i2].Dokument.id)
          and (SeiteDokumentLinkList.Item[i3].Feld(SK_SE_ID).AsInteger = SeiteLinkList.Item[i1].Feld(KS_SE_ID).AsInteger) then
          begin
            Found := true;
            break;
          end;
        end;
        if Found then
          continue;
        FSeitedokumentLink.Init;
        FSeitedokumentLink.Feld(SK_SE_ID).AsInteger := SeiteLinkList.Item[i1].Feld(KS_SE_ID).AsInteger;
        FSeitedokumentLink.Feld(SK_SE_ID_LINK).AsInteger := FDBList.Names(SD_SE_ID).AsInteger;
        FSeitedokumentLink.Feld(SK_DO_ID).AsInteger := FDBList.Names(SD_DO_ID).AsInteger;
        FSeitedokumentLink.Feld(SK_VERLINKT).AsBoolean := true;
        FSeitedokumentlink.Save;
      end;
    end;
  finally
    FreeAndNil(SeiteDokumentList);
    FreeAndNil(SeiteLinkList);
    FreeAndNil(SeiteDokumentLinkList);
  end;
end;


procedure TSeiteDokument.Delete;
var
  SeiteDokumentLinkList: TSeiteDokumentLinkList;
  i1: Integer;
begin
  inherited;
  SeiteDokumentLinkList := TSeiteDokumentLinkList.Create(Self);
  try
    SeiteDokumentLinkList.ReadAllLinks(FDBList.Names(SD_SE_ID).AsInteger, FDBList.Names(SD_DO_ID).AsInteger);
    for i1 := 0 to SeitedokumentlinkList.Count -1 do
      Seitedokumentlinklist.Item[i1].Delete;
  finally
    FreeAndNil(SeiteDokumentLinkList);
  end;

end;


end.
