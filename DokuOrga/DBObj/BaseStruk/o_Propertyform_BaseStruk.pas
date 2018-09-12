unit o_Propertyform_BaseStruk;

interface

uses
  SysUtils, Classes, o_Propertyform_Base, IBDatabase, IBQuery;

type
  TPropertyform_BaseStruk = class(TPropertyform_Base)
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

{ TPropertyform_BaseStruk }

uses
  c_DBTypes, o_DBField;


constructor TPropertyform_BaseStruk.Create(AOwner: TComponent);
var
  DBField: TDBFeld;
begin
  inherited;
  FDBList.Add(PF_NAME, PF_NAME);
  FDBList.Add(PF_PC, PF_PC);
  FDBList.Add(PF_BE_ID, PF_BE_ID);
  FDBList.Add(PF_HEIGHT, PF_HEIGHT);
  FDBList.Add(PF_WIDTH, PF_WIDTH);
  FDBList.Add(PF_LEFT, PF_LEFT);
  FDBList.Add(PF_TOP, PF_TOP);
  FDBList.Add(PF_WINDOWSTATE, PF_WINDOWSTATE);
  DBField := DBList.Add(PF_DELETE, PF_DELETE, true);
  DBField.DeleteField := true;
  FDBList.Names('Id').Feldname := 'PF_ID';
  Init;
end;

destructor TPropertyform_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TPropertyform_BaseStruk.Init;
begin
  inherited;

end;

procedure TPropertyform_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;

end;

function TPropertyform_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (PF_ID, PF_NAME, PF_HEIGHT, PF_WIDTH, PF_LEFT, PF_TOP, PF_WINDOWSTATE, PF_PC, PF_BE_ID, PF_DELETE)' +
          ' values' +
          ' (:PF_ID, :PF_NAME, :PF_HEIGHT, :PF_WIDTH, :PF_LEFT, :PF_TOP, :PF_WINDOWSTATE, :PF_PC, :PF_BE_ID, :PF_DELETE)';
  uSql := ' update ' + getTablename +
          ' set PF_NAME = :PF_NAME,' +
          ' PF_PC = :PF_PC, ' +
          ' PF_BE_ID = :PF_BE_ID, ' +
          ' PF_HEIGHT = :PF_HEIGHT, ' +
          ' PF_WIDTH = :PF_WIDTH, ' +
          ' PF_LEFT = :PF_LEFT, ' +
          ' PF_TOP = :PF_TOP, ' +
          ' PF_WINDOWSTATE = :PF_WINDOWSTATE, ' +
          ' PF_DELETE = :PF_DELETE ' +
          ' where PF_ID = :PF_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;

end.
