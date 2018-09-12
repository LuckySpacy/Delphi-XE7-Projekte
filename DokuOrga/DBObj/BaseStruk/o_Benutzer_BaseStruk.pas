unit o_Benutzer_BaseStruk;

interface

uses
  SysUtils, Classes, o_Benutzer_Base, IBDatabase, IBQuery;

type
  TBenutzer_BaseStruk = class(TBenutzer_Base)
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

{ TDokument_BaseStruk }

uses
  c_DBTypes, o_DBField;

constructor TBenutzer_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(BE_VORNAME, BE_VORNAME);
  FDBList.Add(BE_NACHNAME, BE_NACHNAME);
  FDBList.Add(BE_LOGIN, BE_LOGIN);
  FDBList.Add(BE_PW, BE_PW);
  DBField := DBList.Add(BE_DELETE, BE_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'BE_ID';
  Init;
end;

destructor TBenutzer_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TBenutzer_BaseStruk.Init;
begin
  inherited;

end;

procedure TBenutzer_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TBenutzer_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (BE_ID, BE_VORNAME, BE_NACHNAME, BE_LOGIN, BE_PW, BE_DELETE)' +
          ' values' +
          ' (:BE_ID, :BE_VORNAME, :BE_NACHNAME, :BE_LOGIN, :BE_PW, :BE_DELETE)';
  uSql := ' update ' + getTablename +
          ' set BE_VORNAME = :BE_VORNAME,' +
          ' BE_NACHNAME = :BE_NACHNAME, ' +
          ' BE_LOGIN = :BE_LOGIN, ' +
          ' BE_PW = :BE_PW, ' +
          ' BE_DELETE = :BE_DELETE ' +
          ' where BE_ID = :BE_ID';

  Result := SaveDB(FQuery, iSql, uSql);
end;

end.
