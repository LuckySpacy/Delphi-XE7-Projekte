unit o_Sprache_BaseStruk;

interface

uses
  SysUtils, Classes, o_Sprache_Base, IBDatabase, IBQuery;


type
  TSprache_BaseStruk = class(TSprache_Base)
  private
    //FText_DE: string;
    //FText_Ori: string;
    //procedure setText_DE(const Value: string);
    //procedure setText_Ori(const Value: string);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Save;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    //property Text_DE: string read FText_DE write setText_DE;
    //property Text_Ori: string read FText_Ori write setText_Ori;
  end;




implementation

{ TSprache_BaseStruk }

uses
  c_DBTypes;

constructor TSprache_BaseStruk.Create(AOwner: TComponent);
begin
  inherited;
  FDBList.Add(SP_TEXT_DE, 'sp_text_de');
  FDBList.Add(SP_TEXT_Ori, 'sp_text_ori');
  FDBList.Names('Id').Feldname := 'SP_ID';
  Init;
end;


destructor TSprache_BaseStruk.Destroy;
begin

  inherited;
end;

procedure TSprache_BaseStruk.Init;
begin
  inherited;
end;

procedure TSprache_BaseStruk.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  {
  Init;
  if aQuery.Eof then
    exit;
  FId       := aQuery.FieldByName('sp_id').AsInteger;
  FText_DE  := aQuery.FieldByName('sp_text_de').AsString;
  FText_Ori := aQuery.FieldByName('sp_text_ori').AsString;
  }
end;

procedure TSprache_BaseStruk.Save;
var
  iSql: string;
  uSql: string;
begin
  iSql := ' insert into ' + getTableName +
          ' (SP_ID, SP_TEXT_DE, SP_TEXT_ORI)' +
          ' values' +
          ' (:ID, :TEXT_DE, :TEXT_ORI)';
  uSql := ' update ' + getTablename +
          ' set SP_TEXT_DE = :TEXT_DE,' +
          ' SP_TEXT_ORI = :TEXT_ORI ' +
          ' where SP_ID = :Id';

  SaveDB(FQuery, iSql, uSql);

end;

{
procedure TSprache_BaseStruk.setText_DE(const Value: string);
begin
  UpdateV(FText_DE, Value);
end;

procedure TSprache_BaseStruk.setText_Ori(const Value: string);
begin
  UpdateV(FText_Ori, Value);
end;
 }
end.
