unit o_SysSprache_BaseStruk;

interface

uses
  SysUtils, Classes, o_SysSprache_Base, IBDatabase, IBQuery, o_DBFieldList, o_DBField,
  o_DBGuid;


type
  TSysSprache_BaseStruk = class(TSysSprache_Base)
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

{ TSysSprache_BaseStruk }

uses
  c_DBTypes;



constructor TSysSprache_BaseStruk.Create(AOwner: TComponent);
begin
  inherited;
  FDBList.Add(SysSp_SP_Id, 'syssp_sp_id');
  FDBList.Add(SysSP_MsgF, 'syssp_msgf');
  FDBList.Add(SysSP_MSG, 'syssp_msg');
  FDBList.Names('Id').Feldname := 'SYSSP_ID';
  Init;
end;

destructor TSysSprache_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSysSprache_BaseStruk.Init;
begin
  inherited;
end;

procedure TSysSprache_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
end;

function TSysSprache_BaseStruk.Save: Boolean;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SYSSP_ID, SYSSP_MSGF, SYSSP_MSG, SYSSP_SP_ID)' +
          ' values' +
          ' (:SYSSP_ID, :SYSSP_MSGF, :SYSSP_MSG, :SYSSP_SP_ID)';
  uSql := ' update ' + getTablename +
          ' set SYSSP_MSGF = :SYSSP_MSGF,' +
          ' SYSSP_MSG = :SYSSP_MSG,' +
          ' SYSSP_SP_ID = :SYSSP_SP_ID' +
          ' where SYSSP_ID = :SYSSP_ID';

  Result := SaveDB(FQuery, iSql, uSql);

end;



end.
