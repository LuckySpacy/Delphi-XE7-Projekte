unit DB.BasisHistorie;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, DB.Basis, Data.db,
  c.Historie, DB.Historie, DB.Historietext;

type
  TGetHistorieTextEvent = procedure (aFieldname: string; var aHistorieText: string; var aEventId: Integer) of object;
  TDBBasisHistorie = class(TDBBasis)
  private
    fOnGetHistorieText: TGetHistorieTextEvent;
    fOnGetAfterHistorieText: TGetHistorieTextEvent;
  protected
    fHistorie    : TDBHistorie;
    fHistorietext : TDBHistorietext;
    procedure AfterSqlExec(Sender: TObject);
    property OnGetHistorieText: TGetHistorieTextEvent read fOnGetHistorieText write fOnGetHistorieText;
    property OnGetAfterHistorieText: TGetHistorieTextEvent read fOnGetAfterHistorieText write fOnGetAfterHistorieText;
    function getTableId: Integer; virtual; abstract;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TDBBasisHistorie }

constructor TDBBasisHistorie.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fHistorie      := TDBHistorie.Create(nil);
  fHistorietext  := TDBHistorietext.Create(nil);
  OnAfterExecSql := AfterSqlExec;
end;

destructor TDBBasisHistorie.Destroy;
begin
  FreeAndNil(fHistorie);
  FreeAndNil(fHistorietext);
  inherited;
end;

procedure TDBBasisHistorie.Init;
begin
  inherited;

end;



procedure TDBBasisHistorie.AfterSqlExec(Sender: TObject);
var
  HistorieText: string;
  EventId: Integer;
  i1: Integer;
begin
  if not Assigned(fOnGetHistorieText) then
    exit;

  fHistorie.Trans    := Trans;
  fHistorietext.Trans := Trans;
  fHistorie.Init;
  fHistorietext.Init;

  if (fNeu) or (fGeloescht) then
  begin

    if fNeu then
      EventId := fHistorie.HistorieEvent.Angelegt
    else
      EventId := fHistorie.HistorieEvent.Geloescht;

    fOnGetHistorieText('', HistorieText, EventId);
    //fHistorietext.MA_ID    := LoginMA.getId;
    fHistorietext.BE_ID    := 0;
    fHistorietext.Event_ID := EventId;
    fHistorietext.Info     := Historietext;
    fHistorietext.SaveToDB;
    fHistorie.HT_ID := fHistorietext.Id;
    fHistorie.Fremd_ID := fId;
    fHistorie.TabelleId := getTableId;
    fHistorie.SaveToDB;
    if Assigned(fOnGetAfterHistorieText) then
      fOnGetAfterHistorieText('', HistorieText, EventId);
    //exit;
  end;


  for i1 := 0 to fFeldList.Count -1 do
  begin
    if  ((fFeldList.Feld[i1].Changed)
    and (fFeldList.Feld[i1].AsString <> fFeldListHis.FieldByName(fFeldList.Feld[i1].Feldname).AsString))
    or  ((fNeu) and (Trim(fFeldList.Feld[i1].AsString) > '')) then
    begin
      HistorieText := '';
      EventId      := -1;
      fOnGetHistorieText(fFeldList.Feld[i1].Feldname, HistorieText, EventId);
      if (HistorieText = '') and (EventId = -1) then
        continue;
       fHistorie.Init;
      fHistorietext.Init;
      //fHistorietext.BE_ID    := LoginMA.getId;
      fHistorietext.BE_ID    := 0;
      fHistorietext.Event_ID := EventId;
      fHistorietext.Info     := Historietext;
      fHistorietext.SaveToDB;
      fHistorie.HT_ID := fHistorietext.Id;
      fHistorie.Fremd_ID := Id;
      fHistorie.TabelleId := getTableId;
      fHistorie.SaveToDB;
      if Assigned(fOnGetAfterHistorieText) then
        fOnGetAfterHistorieText(fFeldList.Feld[i1].Feldname, HistorieText, EventId);
    end;
  end;
end;



end.
