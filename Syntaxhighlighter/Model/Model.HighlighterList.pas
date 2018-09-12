unit Model.HighlighterList;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery,  Model.Highlighter, Objekt.BasisList,
  Model.BasisList, Vcl.StdCtrls;

type
  THighlighterList = class(TBasisListModel)
  private
    function getItem(Index: Integer): THighlighter;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure ReadAll;
    property Item[Index:Integer]: THighlighter read getItem;
    procedure Delete;
  end;


implementation

{ THighlighterList }

uses
  System.Contnrs;

constructor THighlighterList.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure THighlighterList.Delete;
var
  i1: Integer;
begin
  if _Trans = nil then
    exit;
  OpenTrans;
  try
    for i1 := 0 to _List.Count -1 do
      THighlighter(_List.Items[i1]).Delete;
  finally
    CommitTrans;
    _List.Clear;
  end;
end;


destructor THighlighterList.Destroy;
begin

  inherited;
end;

function THighlighterList.getItem(Index: Integer): THighlighter;
begin
  Result := nil;
  if Index > _List.Count -1 then
    exit;
  Result := THighlighter(_List.Items[Index]);
end;


procedure THighlighterList.ReadAll;
var
  x: THighlighter;
begin
  _List.Clear;
  if _Trans = nil then
    exit;
  _Query.Close;
  _Query.Transaction := _Trans;
  OpenTrans;
  try
    _Query.SQL.Text := 'select * from highlighter order by hi_name';
    _query.Open;
    while not _Query.Eof do
    begin
      x := THighlighter.Create(nil);
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
