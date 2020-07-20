unit VW.ZweigList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, VW.BaseList, TBQuery, IBX.IBQuery,
  VW.Zweig, System.Contnrs, dB;

type
  TVWZweigList = class(TVWBasisList)
  private
    function getZweig(Index: Integer): TVWZweig;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TVWZweig;
    property Item[Index: Integer]: TVWZweig read getZweig;
    procedure Read(aBB_ID, aEbene: Integer);
  end;

implementation

{ TVWZweigList }

uses
  Objekt.DokuOrga;

constructor TVWZweigList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TVWZweigList.Destroy;
begin

  inherited;
end;


function TVWZweigList.Add: TVWZweig;
begin
  Result := TVWZweig.Create;
  fList.Add(Result);
end;


function TVWZweigList.getZweig(Index: Integer): TVWZweig;
begin
  Result := nil;
  if Index > fList.Count then
    exit;
  Result := TVWZweig(fList.Items[Index]);
end;

procedure TVWZweigList.Read(aBB_ID, aEbene: Integer);
var
  sql: string;
  Zweig: TVWZweig;
begin
  fList.Clear;
  Sql := ' select * from baumstruk' +
         ' join zweigprop on bs_zp_id = zp_id' +
         ' where bs_delete != ' + QuotedStr('T') +
         ' and   bs_bb_Id = ' + IntToStr(aBB_ID) +
         ' and   bs_ebene = ' + IntToStr(aEbene) +
         ' order by zp_text';

  fTBQuery.TBTrans := DokuOrga.IBDatenbank.Trans;
  fTBQuery.UseInterbase := DokuOrga.IBDatenbank.UseInterbase;
  fTBQuery.TBTrans.StartTrans;
  fTBQuery.Sql.Text := sql;
  fTBQuery.Open;
  while not fTBQuery.Eof do
  begin
    Zweig := Add;
    Zweig.BS_ID    := fTBQuery.IBQuery.FieldByName('BS_ID').AsInteger;
    Zweig.BS_Ebene := fTBQuery.IBQuery.FieldByName('BS_EBENE').AsInteger;
    Zweig.BS_ZP_ID := fTBQuery.IBQuery.FieldByName('BS_ZP_ID').AsInteger;
    Zweig.BS_BB_ID := fTBQuery.IBQuery.FieldByName('BS_BB_ID').AsInteger;
    Zweig.ZP_ID    := fTBQuery.IBQuery.FieldByName('ZP_ID').AsInteger;
    Zweig.ZP_TEXT  := fTBQuery.IBQuery.FieldByName('ZP_TEXT').AsString;
    Zweig.ZP_BI_ID := fTBQuery.IBQuery.FieldByName('ZP_BI_ID').AsInteger;
    fTBQuery.Next;
  end;


end;

end.
