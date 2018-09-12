unit o_BaumButton;

interface

uses
  SysUtils, Classes, o_BaumButton_BaseStruk;

type
  TBaumButton = class(TBaumButton_BaseStruk)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure ReadFromButtonProp(aId: Integer);
    procedure GetBaumStrukIdList(aValue: TStrings; aId: Integer);
  end;


implementation

{ TBaumButton }

uses
  c_DBTypes;

constructor TBaumButton.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;


destructor TBaumButton.Destroy;
begin
  inherited;
end;




procedure TBaumButton.Init;
begin
  inherited;
  if FDBList.Count <= 1 then
    exit;
end;

procedure TBaumButton.ReadFromButtonProp(aId: Integer);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where BB_BP_ID = ' + IntToStr(aId);
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;


procedure TBaumButton.GetBaumStrukIdList(aValue: TStrings; aId: Integer);
begin
  aValue.Clear;
  ReadFromButtonProp(aId);
  if not Found then
    exit;
  aValue.Add(IntToStr(Id));

  while Feld(BB_EBENE).AsInteger <> 0 do
  begin
    ReadFromButtonProp(Feld(BB_EBENE).AsInteger);
    if not Found then
      exit;
    aValue.Add(IntToStr(Id));
  end;
end;


end.
