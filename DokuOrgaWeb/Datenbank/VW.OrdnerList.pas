unit VW.OrdnerList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, VW.BaseList, TBQuery, IBX.IBQuery,
  VW.Ordner, System.Contnrs, dB;

type
  TVWOrdnerList = class(TVWBasisList)
  private
    function getOrdner(Index: Integer): TVWOrdner;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Add: TVWOrdner;
    property Item[Index: Integer]: TVWOrdner read getOrdner;
    procedure Read(aEbene: Integer);
    function getOrdnerByBP_ID(aBP_ID: Integer): TVWOrdner;
  end;


implementation

{ TVWOrdnerList }

uses
  Objekt.DokuOrga;


constructor TVWOrdnerList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TVWOrdnerList.Destroy;
begin

  inherited;
end;


function TVWOrdnerList.getOrdner(Index: Integer): TVWOrdner;
begin
  Result := nil;
  if Index > fList.Count then
    exit;
  Result := TVWOrdner(fList.Items[Index]);
end;


procedure TVWOrdnerList.Read(aEbene: Integer);
var
  sql: string;
  Ordner: TVWOrdner;
begin
  fList.Clear;
  sql := ' select * from BaumButton' +
         ' join buttonprop on bb_bp_id = bp_id' +
         ' left outer join bilder on bi_id = bp_bi_id' +
         ' where BB_DELETE != ' + QuotedStr('T') +
         ' and   BB_EBENE = ' + IntToStr(aEbene) +
         ' order by bp_text';
  fTBQuery.TBTrans := DokuOrga.IBDatenbank.Trans;
  fTBQuery.UseInterbase := DokuOrga.IBDatenbank.UseInterbase;
  fTBQuery.TBTrans.StartTrans;
  fTBQuery.Sql.Text := sql;
  fTBQuery.Open;
  while not fTBQuery.Eof do
  begin
    Ordner := Add;
    Ordner.BB_Id := fTBQuery.IBQuery.FieldByName('BB_ID').AsInteger;
    Ordner.BB_Ebene := fTBQuery.IBQuery.FieldByName('BB_ID').AsInteger;
    Ordner.BP_UsePw := fTBQuery.IBQuery.FieldByName('BP_USEPW').AsString = 'F';
    Ordner.BP_IT_Id := fTBQuery.IBQuery.FieldByName('BP_IT_Id').AsInteger;
    Ordner.BP_BI_Id := fTBQuery.IBQuery.FieldByName('BP_BI_Id').AsInteger;
    Ordner.BP_Id    := fTBQuery.IBQuery.FieldByName('BP_Id').AsInteger;
    Ordner.BI_Id    := fTBQuery.IBQuery.FieldByName('BI_Id').AsInteger;
    Ordner.bp_Text  := fTBQuery.IBQuery.FieldByName('BP_Text').AsString;
    if Ordner.BI_Id > 0 then
    begin
      if SameText(fTBQuery.IBQuery.FieldByName('BI_ERWEITERUNG').AsString, 'ico') then
        Ordner.Icon.Load(TBlobField(fTBQuery.IBQuery.FieldByName('BI_Bild')));
    end;
    fTBQuery.Next;
  end;
end;

function TVWOrdnerList.Add: TVWOrdner;
begin
  Result := TVWOrdner.Create;
  fList.Add(Result);
end;


function TVWOrdnerList.getOrdnerByBP_ID(aBP_ID: Integer): TVWOrdner;
var
  i1: Integer;
begin
  Result := nil;
  for i1 := 0 to fList.Count -1 do
  begin
    if Item[i1].BP_Id = aBP_Id then
    begin
      Result := Item[i1];
      exit;
    end;
  end;
end;



end.
