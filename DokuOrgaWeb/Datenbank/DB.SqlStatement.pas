unit DB.SqlStatement;

interface

uses
  SysUtils, Classes, vcl.Dialogs;

type
  TDBSqlStatement = class
  private
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Generate(aGeneratorname: string): string;
  end;

implementation

{ TIBSqlStatement }

constructor TDBSqlStatement.Create;
begin

end;

destructor TDBSqlStatement.Destroy;
begin

  inherited;
end;

function TDBSqlStatement.Generate(aGeneratorname: string): string;
begin
  Result := 'select GEN_ID(' + aGeneratorname + ', 1) FROM RDB$DATABASE';
end;

end.
