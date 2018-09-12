unit Model.Highlighter;

interface

uses
  SysUtils, Classes, IBX.IBDatabase, IBX.IBQuery, Model.Basis, Data.db;

type
  THighlighter = class(TBasisModel)
  private
    //fTrans: TIBTransaction;
    fStyleName: string;
    fFont: string;
    procedure FuelleDBFelder;
    procedure setStyleName(const Value: string);
    procedure setFont(const Value: string);
  protected
    fWasOpen: Boolean;
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TIBQuery); override;
    //property Trans: TIBTransaction read fTrans write fTrans;
    property StyleName: string read fStyleName write setStyleName;
    property Font: string read fFont write setFont;
  end;


implementation

{ THighlighter }

constructor THighlighter.Create(AOwner: TComponent);
begin
  inherited;
  fFeldList.Add('HI_NAME', ftString);
  fFeldList.Add('HI_FONT', ftString);
end;

destructor THighlighter.Destroy;
begin

  inherited;
end;

procedure THighlighter.Init;
begin
  inherited;
  StyleName := '';
  Font := '';
end;


procedure THighlighter.FuelleDBFelder;
begin
  fFeldList.FieldByName('HI_ID').AsInteger   := fID;
  fFeldList.FieldByName('HI_NAME').AsString  := fStylename;
  fFeldList.FieldByName('HI_FONT').AsString  := fFont;
end;

function THighlighter.getGeneratorName: string;
begin
  Result := 'HI_ID';
end;

function THighlighter.getTableName: string;
begin
  Result := 'Highlighter';
end;

function THighlighter.getTablePrefix: string;
begin
  Result := 'HI';
end;


procedure THighlighter.LoadByQuery(aQuery: TIBQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fId        := aQuery.FieldByName('hi_id').AsInteger;
  fStylename := aQuery.FieldByName('hi_name').AsString;
  fFont      := aQuery.FieldByName('hi_font').AsString;
  FuelleDBFelder;
end;

procedure THighlighter.setFont(const Value: string);
begin
  UpdateV(fFont, Value);
  fFeldList.FieldByName('HI_FONT').AsString := Value;
end;

procedure THighlighter.setStyleName(const Value: string);
begin
  UpdateV(fStyleName, Value);
  fFeldList.FieldByName('HI_NAME').AsString := fStyleName;
end;

end.
