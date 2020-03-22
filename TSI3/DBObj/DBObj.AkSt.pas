unit DBObj.AkSt;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DBObj.Basis, Data.db;


type
  TAkSt = class(TBasisDBOj)
  private
    fAS_ID: Integer;
    fAK_ID: Integer;
    fSS_ID: Integer;
    fParam1: string;
    procedure FuelleDBFelder;
    procedure setAS_ID(const Value: Integer);
    procedure setAK_ID(const Value: Integer);
    procedure setSS_ID(const Value: Integer);
    procedure setParam1(const Value: string);
  protected
    _Sql: string;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    property AS_ID: Integer read fAS_ID write setAS_ID;
    property AK_ID: Integer read fAK_ID write setAK_ID;
    property SS_ID: Integer read fSS_ID write setSS_ID;
    property Param1: string read fParam1 write setParam1;
    procedure ReadSchnittstelleAktie(aSSId, aAkId: Integer);
  end;

implementation

{ TAktie }

constructor TAkSt.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('AS_ID', ftInteger);
  fFeldList.Add('AS_AK_ID', ftInteger);
  fFeldList.Add('AS_SS_ID', ftInteger);
  fFeldList.Add('AS_PARAM1', ftString);
end;

destructor TAkSt.Destroy;
begin

  inherited;
end;

procedure TAkSt.FuelleDBFelder;
begin
  fFeldList.FieldByName('AS_ID').AsInteger    := fID;
  fFeldList.FieldByName('AS_AK_ID').AsInteger := fAK_ID;
  fFeldList.FieldByName('AS_SS_ID').AsInteger := fSS_ID;
  fFeldList.FieldByName('AS_PARAM1').AsString := fParam1;
end;

function TAkSt.getGeneratorName: string;
begin
  Result := 'AS_ID';
end;

function TAkSt.getTableName: string;
begin
  Result := 'AKST';
end;

function TAkSt.getTablePrefix: string;
begin
  Result := 'AS';
end;

procedure TAkSt.Init;
begin
  inherited;

end;

procedure TAkSt.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId       := aQuery.FieldByName('AS_id').AsInteger;
  fAK_ID := aQuery.FieldByName('AS_AK_ID').AsInteger;
  fSS_ID := aQuery.FieldByName('AS_SS_ID').AsInteger;
  fParam1 := aQuery.FieldByName('AS_PARAM1').AsString;
  FuelleDBFelder;
end;


procedure TAkSt.setAK_ID(const Value: Integer);
begin
  UpdateV(fAK_ID, Value);
  fFeldList.FieldByName('AS_AK_ID').AsInteger := fAK_ID;
end;

procedure TAkSt.setAS_ID(const Value: Integer);
begin
  UpdateV(fAS_Id, Value);
  fFeldList.FieldByName('AS_ID').AsInteger := fAS_Id;
end;

procedure TAkSt.setParam1(const Value: string);
begin
  UpdateV(fParam1, Value);
  fFeldList.FieldByName('AS_PARAM1').AsString := fParam1;
end;

procedure TAkSt.setSS_ID(const Value: Integer);
begin
  UpdateV(fSS_ID, Value);
  fFeldList.FieldByName('AS_SS_ID').AsInteger := fSS_ID;
end;


procedure TAkSt.ReadSchnittstelleAktie(aSSId, aAkId: Integer);
begin
  Init;
  if not Assigned(fTrans) then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  fQuery.SQL.Text := 'select * from ' + getTableName +
                     ' where as_ak_id = ' + IntToStr(aAkId) +
                     ' and as_ss_id = ' + IntToStr(aSSId);
  OpenTrans;
  try
    fQuery.Open;
    LoadByQuery(fQuery);
  finally
    CommitTrans;
  end;
end;


end.
