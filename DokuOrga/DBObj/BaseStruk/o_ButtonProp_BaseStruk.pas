unit o_ButtonProp_BaseStruk;

interface

uses
  SysUtils, Classes, o_ButtonProp_Base, IBDatabase, IBQuery;

type
  TButtonProp_BaseStruk = class(TButtonProp_Base)
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

{ TButtonProp_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TButtonProp_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(BP_TEXT, BP_TEXT);
  FDBList.Add(BP_IT_ID, BP_IT_ID);
  FDBList.Add(BP_BI_ID, BP_BI_ID);
  FDBList.Add(BP_USEPW, BP_USEPW);
  DBField := DBList.Add(BP_DELETE, BP_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'BP_ID';
  Init;
end;

destructor TButtonProp_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TButtonProp_BaseStruk.Init;
begin
  inherited;

end;

procedure TButtonProp_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;


function TButtonProp_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (BP_ID, BP_TEXT, BP_IT_ID, BP_BI_ID, BP_DELETE, BP_USEPW)' +
          ' values' +
          ' (:BP_ID, :BP_TEXT, :BP_IT_ID, :BP_BI_ID, :BP_DELETE, :BP_USEPW)';
  uSql := ' update ' + getTablename +
          ' set BP_TEXT = :BP_TEXT,' +
          ' BP_IT_ID = :BP_IT_ID, ' +
          ' BP_BI_ID = :BP_BI_ID, ' +
          ' BP_USEPW = :BP_USEPW, ' +
          ' BP_DELETE = :BP_DELETE ' +
          ' where BP_ID = :BP_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
