unit Model.KommentarList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  Model.Kommentar, Objekt.BasisList,
  Model.BasisList, Vcl.StdCtrls;

type
  TKommentarList = class(TBasisListModel)
  private
    function getItem(Index: Integer): TKommentar;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll;
    property Item[Index:Integer]: TKommentar read getItem;
    procedure Delete;
  end;

implementation

{ TKommentarList }

uses
  System.Contnrs;

constructor TKommentarList.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TKommentarList.Destroy;
begin

  inherited;
end;


procedure TKommentarList.Delete;
var
  i1: Integer;
begin
  if _Trans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to _List.Count -1 do
      TKommentar(_List.Items[i1]).Delete;
  finally
    CommitTrans;
    _List.Clear;
  end;
end;


function TKommentarList.getItem(Index: Integer): TKommentar;
begin
  Result := nil;
  if Index > _List.Count -1 then
    exit;
  Result := TKommentar(_List.Items[Index]);
end;

procedure TKommentarList.ReadAll;
var
  x: TKommentar;
begin
  _List.Clear;
  if _Trans = nil then
    exit;
  _Query.Close;
  _Query.Transaction := _Trans;
  OpenTrans;
  try
    _Query.SQL.Text := 'select * from kommentar order by ko_sort';
    _query.Open;
    while not _Query.Eof do
    begin
      x := TKommentar.Create(nil);
      x.Trans := _Trans;
      x.LoadByQuery(_query);
      _List.Add(x);
      _Query.Next;
    end;
  finally
    RollbackTrans;
  end;
end;

end.
