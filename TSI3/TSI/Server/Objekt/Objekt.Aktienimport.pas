unit Objekt.Aktienimport;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, DBOBj.Aktie, DBObj.Aktielist,
  DBObj.Boersenindex, Objekt.Ini, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs;

type
  RCol = Record const
    WKN : Integer = 0;
    Aktie: Integer = 1;
    Symbol: Integer = 2;
    Boersenindex: Integer = 3;
  End;

type
  TNewRowEvent = procedure(Sender: TObject; aAktie: TAktie; aValue: string; aIndex, aMaxValue: Integer) of object;
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;


type
  TAktienimport = class(TComponent)
  private
    fTrans: TIBTransaction;
    fList: TStringList;
    fSplittList: TStringList;
    fBoersenIndex: TBoersenindex;
    fCol: RCol;
    fAktie: TAktie;
    fOnNewRow: TNewRowEvent;
    fOnStart: TStartEvent;
    fProgressLabel: TLabel;
    fProgressBar: TProgressbar;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Trans: TIBTransaction read fTrans write fTrans;
    function Exec: Boolean;
    property OnNewRow: TNewRowEvent read fOnNewRow write fOnNewRow;
    property OnStart: TStartEvent read fOnStart write fOnStart;
    property ProgressLabel: TLabel read fProgressLabel write fProgressLabel;
    property ProgressBar: TProgressBar read fProgressBar write fProgressBar;
  end;

implementation

{ TAktienimport }

constructor TAktienimport.Create(AOwner: TComponent);
begin
  inherited;
  fList := TStringList.Create;
  fSplittList := TStringList.Create;
  fSplittList.Delimiter := ';';
  fSplittList.StrictDelimiter := true;
  fBoersenIndex := TBoersenindex.Create(nil);
  fAktie := TAktie.Create(nil);
end;

destructor TAktienimport.Destroy;
begin
  FreeAndNil(fList);
  FreeAndNil(fSplittList);
  FreeAndNil(fBoersenIndex);
  FreeAndNil(fAktie);
  inherited;
end;

function TAktienimport.Exec: Boolean;
var
  i1: Integer;
  i2: Integer;
  Boersenindexname: string;
  Filename: string;
  Aktie: string;
begin
  Result := false;
  if fTrans = nil then
    exit;
  fTrans.StartTransaction;
  try
    fBoersenIndex.Trans := fTrans;
    fAktie.Trans := fTrans;
    fList.Clear;
    if not DirectoryExists(Ini.Zielpfad) then
      exit;
    Filename := IncludeTrailingPathDelimiter(Ini.Zielpfad) + 'Aktien.csv';
    if not FileExists(Filename) then
      exit;
    fList.LoadFromFile(Filename);
    if Assigned(fOnStart) then
      fOnStart(Self, fList.Count);
    fProgressBar.Max := fList.Count;
    fProgressBar.Position := 0;
    for i1 := 0 to fList.Count -1 do
    begin
      fSplittList.DelimitedText := fList.Strings[i1];
      if fSplittList.Count < 4 then
        continue;
      Aktie := fSplittList.Strings[fCol.WKN] + ' ' + fSplittList.Strings[fCol.Aktie];
      Boersenindexname := fSplittList.Strings[fCol.Boersenindex];
      fBoersenIndex.ReadFromBoersenindexname(Boersenindexname);
      if not fBoersenIndex.Gefunden then
      begin
        fBoersenIndex.Init;
        fBoersenIndex.Bezeichnung := Boersenindexname;
        fBoersenIndex.SaveToDB;
      end;
      //if fSplittList.Strings[fCol.WKN] = '861114' then
      //  ShowMessage('Stop');
      fAktie.ReadWKN(fSplittList.Strings[fCol.WKN]);
      if not fAktie.Gefunden then
      begin
        fAktie.Init;
        fAktie.Aktie  := fSplittList.Strings[fCol.Aktie];
        fAktie.WKN    := fSplittList.Strings[fCol.WKN];
        fAktie.Symbol := fSplittList.Strings[fCol.Symbol];
      end;
      if Assigned(fOnNewRow) then
        fOnNewRow(Self, fAktie, '', i1+1, fList.Count);
      fProgressBar.Position := i1 + 1;
      fProgressLabel.Caption := '[' + fAktie.WKN + '] ' + fAktie.Aktie;
      fProgressLabel.Invalidate;
      fProgressLabel.Refresh;
      fAktie.BI_ID := fBoersenIndex.Id;
      fAktie.SaveToDB;
    end;
  finally
    if fTrans.InTransaction then
      fTrans.Commit;
  end;
  Result := true;
end;

end.
