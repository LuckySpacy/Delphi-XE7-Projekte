unit DBObj.TSILASTList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  DBObj.TSILast, Objekt.BasisList,
  DBObj.BasisList, Vcl.StdCtrls;

type
  TTSILastList = class(TBasisListDBObj)
  private
    function getItem(Index: Integer): TTSILast;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Item[Index:Integer]: TTSILast read getItem;
    procedure DeleteAktie(aAk_Id: Integer);
    //procedure ReadAll(aAk_Id, aWochen: Integer; aStartDatum, aEndDatum: TDateTime);
  end;

implementation

{ TTSILastList }

uses
  System.Contnrs;

constructor TTSILastList.Create(AOwner: TComponent);
begin
  inherited;

end;



destructor TTSILastList.Destroy;
begin

  inherited;
end;

function TTSILastList.getItem(Index: Integer): TTSILast;
begin
  Result := nil;
  if Index > fList.Count -1 then
    exit;
  Result := TTSILast(fList.Items[Index]);
end;


{
procedure TTSILastList.ReadAll(aAk_Id, aWochen: Integer; aStartDatum, aEndDatum: TDateTime);
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
    fQuery.SQL.Text := ' select * from tsilast ' +
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
}

procedure TTSILastList.DeleteAktie(aAk_Id: Integer);
begin
  if fTrans = nil then
    exit;
  OpenTrans;
  fQuery.Close;
  fQuery.Transaction := fTrans;
  OpenTrans;
  try
    fQuery.SQL.Text := ' delete ' +
                       ' from tsilast' +
                       ' where tl_ak_id = ' + IntToStr(aAk_Id);
    fquery.ExecSQL;
  finally
    CommitTrans;
  end;
end;


end.
