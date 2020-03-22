unit DBObj.TSIList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.TSI, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TTSIList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TTSI;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TTSI read getItem;
    procedure ReadAll(aAk_Id, aWochen: Integer; aStartDatum, aEndDatum: TDateTime);
    procedure DeleteAktie(aAk_Id: Integer);
  end;

implementation

{ TTSIList }

uses
  System.Contnrs;

constructor TTSIList.Create(AOwner: TComponent);
begin
  inherited;

end;



destructor TTSIList.Destroy;
begin

  inherited;
end;

function TTSIList.getItem(Index: Integer): TTSI;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TTSI(fList.Items[Index]);
end;


procedure TTSIList.ReadAll(aAk_Id, aWochen: Integer; aStartDatum, aEndDatum: TDateTime);
var
  x: TTSI;
begin
  fList.Clear;
  if fTrans = nil then
    exit;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' select * from tsi ' +
                       ' where ts_ak_id = ' + IntToStr(aAk_Id) +
                       ' and   ts_wochen = ' + IntToStr(aWochen) +
                       ' and   ts_datum >= :Startdatum' +
                       ' and   ts_datum <= :Endedatum' +
                       ' order by ts_datum';
    fquery.ParamByName('Startdatum').AsDate := aStartDatum;
    fQuery.ParamByName('Endedatum').AsDate  := aEndDatum;
    fquery.Open;
    while not fQuery.Eof do
    begin
      x := TTSI.Create(nil);
      x.Trans := fTrans;
      x.LoadByQuery(fquery);
      fList.Add(x);
      fQuery.Next;
    end;
  finally
    RollbackTrans;
  end;
end;


procedure TTSIList.DeleteAktie(aAk_Id: Integer);
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' delete ' +
                       ' from tsi' +
                       ' where ts_ak_id = ' + IntToStr(aAk_Id);
    fquery.ExecSQL;
  finally
    CommitTrans;
  end;
end;

end.
