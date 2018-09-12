unit o_Seite_BaseStruk;

interface

uses
  SysUtils, Classes, o_Seite_Base, IBDatabase, IBQuery;

type
  TSeite_BaseStruk = class(TSeite_Base)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    function Save: Boolean;
    procedure LoadByQuery(aQuery: TIBQuery); override;
  end;


implementation

{ TSeite_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TSeite_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(SE_HEADER, SE_HEADER);
  FDBList.Add(SE_BODY, SE_BODY);
  FDBList.Add(SE_PFAD, SE_PFAD);
  FDBList.Add(SE_PW, SE_PW);
  FDBList.Add(SE_PFADFTP, SE_PFADFTP);
  FDBList.Add(SE_HEADERHEIGHT, SE_HEADERHEIGHT);
  FDBList.Add(SE_HEADER_ANZEIGEN, SE_HEADER_ANZEIGEN);
  FDBList.Add(SE_FTPUEBERTRAGEN, SE_FTPUEBERTRAGEN);
  FDBList.Add(SE_HEADER_SEARCH, SE_HEADER_SEARCH);
  FDBList.Add(SE_BODY_SEARCH, SE_BODY_SEARCH);
  FDBList.Add(SE_PFADGDRIVE, SE_PFADGDRIVE);
  FDBList.Add(SE_GDRIVEUEBERTRAGEN, SE_GDRIVEUEBERTRAGEN);



  DBField := DBList.Add(SE_DELETE, SE_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'SE_ID';
  Init;
end;

destructor TSeite_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSeite_BaseStruk.Init;
begin
  inherited;
end;


procedure TSeite_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TSeite_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SE_ID, SE_HEADER, SE_BODY, SE_PFAD, SE_HEADERHEIGHT, SE_HEADER_ANZEIGEN, '+
          ' SE_DELETE, SE_PW, SE_PFADFTP, SE_FTPUEBERTRAGEN, SE_BODY_SEARCH, SE_HEADER_SEARCH, ' +
          ' SE_PFADGDRIVE, SE_GDRIVEUEBERTRAGEN)' +
          ' values' +
          ' (:SE_ID, :SE_HEADER, :SE_BODY, :SE_PFAD, :SE_HEADERHEIGHT, :SE_HEADER_ANZEIGEN, ' +
          '  :SE_DELETE, :SE_PW, :SE_PFADFTP, :SE_FTPUEBERTRAGEN, :SE_BODY_SEARCH, :SE_HEADER_SEARCH,' +
          '  :SE_PFADGDRIVE, :SE_GDRIVEUEBERTRAGEN)';
  uSql := ' update ' + getTablename +
          ' set SE_HEADER = :SE_HEADER,' +
          ' SE_BODY = :SE_BODY, ' +
          ' SE_HEADERHEIGHT = :SE_HEADERHEIGHT, ' +
          ' SE_HEADER_ANZEIGEN = :SE_HEADER_ANZEIGEN, ' +
          ' SE_PFAD = :SE_PFAD, ' +
          ' SE_PFADFTP = :SE_PFADFTP, ' +
          ' SE_PW = :SE_PW, ' +
          ' SE_FTPUEBERTRAGEN = :SE_FTPUEBERTRAGEN, ' +
          ' SE_BODY_SEARCH = :SE_BODY_SEARCH, ' +
          ' SE_HEADER_SEARCH = :SE_HEADER_SEARCH, ' +
          ' SE_PFADGDRIVE = :SE_PFADGDRIVE, ' +
          ' SE_GDRIVEUEBERTRAGEN = :SE_GDRIVEUEBERTRAGEN, ' +
          ' SE_DELETE = :SE_DELETE ' +
          ' where SE_ID = :SE_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
