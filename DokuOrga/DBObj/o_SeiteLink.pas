unit o_SeiteLink;

interface

uses
  SysUtils, Classes, o_SeiteLink_BaseStruk, o_Seite, o_dokument, c_types;

type
  TSeiteLink = class(TSeiteLink_BaseStruk)
  private
    FSeite: TSeite;
    function getSeite: TSeite;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Read(aSeite, aSeiteLink: Integer; aTyp: TSeiteLinkTyp); reintroduce; overload;
    function HatDieseSeiteLinks(aSeiteId: Integer; aTyp: TSeiteLinkTyp): Boolean;
    property Seite: TSeite read getSeite write FSeite;
  end;

implementation

{ TSeiteLink }

uses
  c_DBTypes;

constructor TSeiteLink.Create(AOwner: TComponent);
begin
  inherited;
  FSeite := TSeite.Create(Self);
end;

destructor TSeiteLink.Destroy;
begin
  FreeAndNil(FSeite);
  inherited;
end;



procedure TSeiteLink.Init;
begin
  inherited;

end;



function TSeiteLink.HatDieseSeiteLinks(aSeiteId: Integer; aTyp: TSeiteLinkTyp): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select count(*) from  ' + getTableName +
                     ' where KS_DELETE != ' + QuotedStr('T') +
                     ' and KS_TYP = ' + IntToStr(ord(aTyp)) +
                     ' and KS_SE_ID_LINK = ' + IntToStr(aSeiteId);
  OpenTrans;
  FQuery.Open;
  Result := FQuery.Fields[0].AsInteger > 0;
  RollbackTrans;
end;


procedure TSeiteLink.Read(aSeite, aSeiteLink: Integer; aTyp: TSeiteLinkTyp);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where KS_DELETE != ' + QuotedStr('T') +
                     ' and KS_TYP = ' + IntToStr(ord(aTyp)) +
                     ' and KS_SE_ID = ' + IntToStr(aSeite) +
                     ' and KS_SE_ID_LINK = ' + IntToStr(aSeiteLink);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;





function TSeiteLink.getSeite: TSeite;
begin
  if FSeite.Id = Feld(KS_SE_ID_LINK).AsInteger then
  begin
    Result := FSeite;
    exit;
  end;
  FSeite.Read(Feld(KS_SE_ID_LINK).AsInteger);
  Result := FSeite;
end;


end.
