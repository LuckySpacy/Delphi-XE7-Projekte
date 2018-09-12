unit o_TimelineList;

interface

uses
  Classes, SysUtils, Contnrs, DateUtils, o_Timeline;

type
  TTimelineList = class(TObject)
  private
    FList: TObjectList;
    function GetTimeline(Index: Integer): TTimeline;
  public
    constructor Create;
    destructor Destroy; override;
    property Item[Index: Integer]: TTimeline read GetTimeline;
    function Count: Integer;
    function Add: TTimeLine;
    procedure Clear;
    procedure Sort;
  end;


implementation

{ TTimelineList }


function SortAnkunft(Item1, Item2: pointer): Integer;
begin
  Result := CompareText(TTimeline(Item1).Ankunftsort, TTimeline(Item2).Ankunftsort);
end;



constructor TTimelineList.Create;
begin
  inherited;
  FList := TObjectList.Create;
end;

destructor TTimelineList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;


function TTimelineList.Add: TTimeLine;
begin
  Result := TTimeline.Create;
  FList.Add(Result);
end;

procedure TTimelineList.Clear;
begin
  FList.Clear;
end;

function TTimelineList.Count: Integer;
begin
  Result := FList.Count;
end;


function TTimelineList.GetTimeline(Index: Integer): TTimeline;
begin
  Result := nil;
  if Index > FList.Count -1 then
    exit;
  Result := TTimeline(FList.Items[Index]);
end;

procedure TTimelineList.Sort;
begin
  FList.Sort(@SortAnkunft);
end;

end.
