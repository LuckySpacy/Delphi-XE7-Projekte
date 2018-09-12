unit o_Propertyform;

interface

uses
  SysUtils, Classes, o_Propertyform_BaseStruk;

type
  TPropertyform = class(TPropertyform_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Read(aName: string); reintroduce; overload;
  end;

implementation

{ TPropertyform }

uses
  u_system, o_sysobj;

constructor TPropertyform.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TPropertyform.Destroy;
begin

  inherited;
end;

procedure TPropertyform.Init;
begin
  inherited;

end;

procedure TPropertyform.Read(aName: string);
begin

  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where PF_DELETE != ' + QuotedStr('T') +
                     ' and PF_BE_ID = ' + IntToStr(SysObj.Benutzer.Id) +
                     ' and PF_PC = ' + QuotedStr(copy(GetComputerName, 1, 60)) +
                     ' and PF_NAME = ' + QuotedStr(aName);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;

end.
