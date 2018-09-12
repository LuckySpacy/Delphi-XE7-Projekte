unit o_SeiteDokumentLink;

interface

uses
  SysUtils, Classes, o_SeiteDokumentLink_BaseStruk, o_Seite, o_dokument;

type
  TSeiteDokumentLink = class(TSeiteDokumentLink_BaseStruk)
  private
    FSeite: TSeite;
    FDokument: TDokument;
    function getDokument: TDokument;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function DokumentExist(aSE_ID, aDokumentId: Integer): Boolean;
    property Dokument: TDokument read getDokument write FDokument;
    function BereitsMitSeiteVerlinkt(aQuellSeite, aLinkSeite: Integer): Boolean;
    procedure Read(aSeiteId, aDokumentId: Integer); reintroduce; overload;
    procedure Read(aSeiteId, aLinkSeite, aDokumentId: Integer); reintroduce; overload;
  end;

implementation

{ TSeiteDokumentLink }

uses
  c_DBTypes;


constructor TSeiteDokumentLink.Create(AOwner: TComponent);
begin
  inherited;
  FSeite := nil;
  FDokument := nil;
end;

destructor TSeiteDokumentLink.Destroy;
begin
  if FSeite <> nil then
    FreeAndNil(FSeite);
  if FDokument <> nil then
    FreeAndNil(FDokument);
  inherited;
end;

function TSeiteDokumentLink.DokumentExist(aSE_ID, aDokumentId: Integer): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select count(*) from  ' + getTableName +
                     ' where SK_DELETE != ' + QuotedStr('T') +
                     ' and SK_SE_ID = ' + IntToStr(aSE_ID) +
                     ' and SK_DO_ID = ' + IntToStr(aDokumentId);
  OpenTrans;
  FQuery.Open;
  Result := FQuery.Fields[0].AsInteger > 0;
  RollbackTrans;
end;

function TSeiteDokumentLink.getDokument: TDokument;
begin
  if (FDokument <> nil) and (FDokument.Id = Feld(SK_DO_ID).AsInteger) then
  begin
    Result := FDokument;
    exit;
  end;
  if (FDokument <> nil) then
    FreeAndNil(FDokument);
  FDokument := TDokument.Create(Self);
  FDokument.Read(Feld(SK_DO_ID).AsInteger);
  if not FDokument.Found then
    FreeAndNil(FDokument);
  Result := FDokument;
end;


procedure TSeiteDokumentLink.Init;
begin
  inherited;

end;

procedure TSeiteDokumentLink.Read(aSeiteId, aLinkSeite, aDokumentId: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where SK_SE_ID = ' + IntToStr(aSeiteId) +
                     ' and   SK_SE_ID_LINK = ' + IntToStr(aLinkSeite) +
                     ' and   SK_DO_ID = ' + IntToStr(aDokumentId) +
                     ' and   SK_DELETE != ' + QuotedStr('T');
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;

procedure TSeiteDokumentLink.Read(aSeiteId, aDokumentId: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where SK_SE_ID = ' + IntToStr(aSeiteId) +
                     ' and   SK_DO_ID = ' + IntToStr(aDokumentId) +
                     ' and   SK_DELETE != ' + QuotedStr('T');
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;

function TSeiteDokumentLink.BereitsMitSeiteVerlinkt(aQuellSeite,
  aLinkSeite: Integer): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select count(*) from  ' + getTableName +
                     ' where SK_DELETE != ' + QuotedStr('T') +
                     ' and SK_SE_ID = ' + IntToStr(aQuellSeite) +
                     ' and SK_SE_ID_LINK = ' + IntToStr(aLinkSeite);
  OpenTrans;
  FQuery.Open;
  Result := FQuery.Fields[0].AsInteger > 0;
  RollbackTrans;
end;




end.
