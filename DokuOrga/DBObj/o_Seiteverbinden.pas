unit o_Seiteverbinden;

interface

uses
  SysUtils, Classes, o_Seiteverbinden_BaseStruk, o_Seite, o_Baumstruk, o_baumbutton;

type
  TSeiteverbinden = class(TSeiteverbinden_BaseStruk)
  private
    FSeite: TSeite;
    FBaumstruk: TBaumstruk;
    FBaumbutton: TBaumbutton;
    function getSeite: TSeite;
    function getBaumstruk: TBaumstruk;
    function getBaumbutton: TBaumbutton;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Read(aEbene, a_BS_Id: Integer); reintroduce; overload;
    property Seite: TSeite read getSeite write FSeite;
    property Baumstruk: TBaumstruk read getBaumstruk write FBaumstruk;
    property Baumbutton: TBaumbutton read getBaumbutton write FBaumbutton;
    function ExistsSeite(aSE_ID: Integer): Boolean;
    function ReadSeite(aSE_ID: Integer): Boolean;
  end;


implementation

{ TSeiteverbinden }

uses
  c_DBTypes;

constructor TSeiteverbinden.Create(AOwner: TComponent);
begin
  inherited;
  FSeite := TSeite.Create(Self);
  FSeite.Name := 'Seite_In_Seitenverbinden';
  FBaumstruk := TBaumstruk.Create(Self);
  FBaumbutton := TBaumbutton.Create(Self);
end;


destructor TSeiteverbinden.Destroy;
begin
  FreeAndNil(FSeite);
  FreeAndNil(FBaumstruk);
  FreeAndNil(FBaumbutton);
  inherited;
end;



procedure TSeiteverbinden.Init;
begin
  inherited;

end;


procedure TSeiteverbinden.Read(aEbene, a_BS_Id: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where VS_EBENE = ' + IntToStr(aEbene) +
                     ' and   VS_BS_ID = ' + IntToStr(a_BS_Id);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;

  FSeite.Trans := Trans;
  FSeite.Read(Feld(VS_SE_ID).AsInteger);

end;

function TSeiteverbinden.ExistsSeite(aSE_ID: Integer): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where VS_SE_ID = ' + IntToStr(aSE_ID) +
                     ' and   VS_DELETE != ' + QuotedStr('T');
  OpenTrans;
  FQuery.Open;
  Result := not FQuery.Eof;
  RollbackTrans;
end;

function TSeiteverbinden.ReadSeite(aSE_ID: Integer): Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where VS_SE_ID = ' + IntToStr(aSE_ID) +
                     ' and   VS_DELETE != ' + QuotedStr('T');
  OpenTrans;
  FQuery.Open;
  Result := not FQuery.Eof;
  LoadByQuery(FQuery);
  RollbackTrans;
end;




function TSeiteverbinden.getBaumbutton: TBaumbutton;
begin
  if FBaumbutton.Id = Feld(VS_EBENE).AsInteger then
  begin
    Result := FBaumbutton;
    exit;
  end;
  FBaumbutton.Trans := Trans;
  FBaumbutton.Read(Feld(VS_EBENE).AsInteger);
  Result := FBaumbutton;
end;

function TSeiteverbinden.getBaumstruk: TBaumstruk;
begin
  if FBaumstruk.Id = Feld(VS_BS_ID).AsInteger then
  begin
    Result := FBaumstruk;
    exit;
  end;
  FBaumstruk.Trans := Trans;
  FBaumstruk.Read(Feld(VS_BS_ID).AsInteger);
  Result := FBaumstruk;
end;

function TSeiteverbinden.getSeite: TSeite;
begin
  if FSeite.Id = Feld(VS_SE_ID).AsInteger then
  begin
    Result := FSeite;
    exit;
  end;
  FSeite.Trans := Trans;
  FSeite.Read(Feld(VS_SE_ID).AsInteger);
  Result := FSeite;
end;


end.
