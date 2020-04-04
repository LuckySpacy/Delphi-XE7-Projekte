unit tbSqlHighlighter;

interface

uses
  SysUtils, Classes, tbSqlHighlighterBase, SynUnicode, SynEditHighlighter,
  SynEditStrConst, SynHighlighterHashEntries;

type
  TtbSqlHighlighter = class(TtbSqlHighlighterBase)
  private
    fTableNames: TUnicodeStrings;
    fKeywords: TSynHashEntryList;
    procedure SetTableNames(const Value: TUnicodeStrings);
    procedure TableNamesChanged(Sender: TObject);
    procedure PutTableNamesInKeywordList;
    procedure DoAddKeyword(AKeyword: UnicodeString; AKind: integer);
    procedure InitializeKeywordLists;
  protected
    function IdentKind(MayBe: PWideChar): TtkTokenKind; override;  // <-- func in der tbSqlHighlighterBase unter protected und virtual stellen
    function HashKey(Str: PWideChar): Cardinal; override; // <-- func in der Base unter protected und virtual stellen
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property TableNames: TUnicodeStrings read fTableNames write SetTableNames;
  end;


implementation

{ TtbSqlHighlighter }

constructor TtbSqlHighlighter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fTableNames := TUnicodeStringList.Create;
  TUnicodeStringList(fTableNames).OnChange := TableNamesChanged;
  fKeywords := TSynHashEntryList.Create;
end;

destructor TtbSqlHighlighter.Destroy;
begin
  fTableNames.Free;
  fKeywords.Free;
  inherited;
end;

procedure TtbSqlHighlighter.DoAddKeyword(AKeyword: UnicodeString; AKind: integer);
var
  HashValue: Integer;
begin
  AKeyword := SynWideLowerCase(AKeyword);
  HashValue := HashKey(PWideChar(AKeyword));
  fKeywords[HashValue] := TSynHashEntry.Create(AKeyword, AKind);
end;


function TtbSqlHighlighter.HashKey(Str: PWideChar): Cardinal;
begin
  Result := inherited;
end;


function TtbSqlHighlighter.IdentKind(MayBe: PWideChar): TtkTokenKind;
var
  Entry: TSynHashEntry;
begin
  fToIdent := MayBe;
  Entry := fKeywords[HashKey(MayBe)];
  while Assigned(Entry) do
  begin
    if Entry.KeywordLen > fStringLen then
      break
    else if Entry.KeywordLen = fStringLen then
      if IsCurrentToken(Entry.Keyword) then
      begin
        Result := TtkTokenKind(Entry.Kind);
        exit;
      end;
    Entry := Entry.Next;
  end;
  Result := Inherited;
end;

procedure TtbSqlHighlighter.SetTableNames(const Value: TUnicodeStrings);
begin
  fTableNames.Assign(Value);
end;




procedure TtbSqlHighlighter.InitializeKeywordLists;
var
  I: Integer;
begin
  fKeywords.Clear;

  //for I := 0 to Ord(High(TtkTokenKind)) - 1 do
  //  EnumerateKeywords(I, GetKeywords(I), IsIdentChar, DoAddKeyword);

  PutTableNamesInKeywordList;
  //PutFunctionNamesInKeywordList;
  DefHighlightChange(Self);
end;

procedure TtbSqlHighlighter.TableNamesChanged(Sender: TObject);
begin
  InitializeKeywordLists;
end;

procedure TtbSqlHighlighter.PutTableNamesInKeywordList;
var
  i: Integer;
  Entry: TSynHashEntry;
begin
  for i := 0 to fTableNames.Count - 1 do
  begin
    Entry := fKeywords[HashKey(PWideChar(fTableNames[i]))];
    while Assigned(Entry) do
    begin
      if SynWideLowerCase(Entry.Keyword) = SynWideLowerCase(fTableNames[i]) then
        Break;
      Entry := Entry.Next;
    end;
    if not Assigned(Entry) then
      DoAddKeyword(fTableNames[i], Ord(tkTableName));
  end;
end;


end.
