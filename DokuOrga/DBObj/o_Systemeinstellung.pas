unit o_Systemeinstellung;

interface

uses
  SysUtils, Classes, o_Systemeinstellung_BaseStruk;

type
  TSystemeinstellung = class(TSystemeinstellung_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Read(aKey: Integer); override;
  end;


implementation

{ TSystemeinstellung }

constructor TSystemeinstellung.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TSystemeinstellung.Destroy;
begin

  inherited;
end;

procedure TSystemeinstellung.Init;
begin
  inherited;

end;

procedure TSystemeinstellung.Read(aKey: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where SY_KEY = ' + IntToStr(aKey);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;

end;


end.
