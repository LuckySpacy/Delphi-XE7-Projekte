unit Objekt.Kursimport;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase, DBOBj.Kurs, DBObj.Aktie,
  Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Dialogs;

type
  RCol = Record const
    Datum : Integer = 0;
    Kurs: Integer = 1;
  End;

type
  TNewRowEvent = procedure(Sender: TObject; aAktie: TAktie; aValue: string; aIndex, aMaxValue: Integer) of object;
  TStartEvent = procedure(Sender: TObject; aMaxValue: Integer) of object;

type
  TKursimport = class(TComponent)
  private
    fTrans: TIBTransaction;
    fList: TStringList;
    fSplittList: TStringList;
    fFileList: TStringList;
    fKurs: TKurs;
    fAktie: TAktie;
    fCol: RCol;
    fOnNewRow: TNewRowEvent;
    fOnStart: TStartEvent;
    fProgressBar: TProgressBar;
    fProgressLabel: TLabel;
    procedure ImportFile(aFilename: string);
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

{ TKursimport }

uses
  Objekt.Ini, Allgemein.System;

constructor TKursimport.Create(AOwner: TComponent);
begin
  inherited;
  fList := TStringList.Create;
  fSplittList := TStringList.Create;
  fSplittList.Delimiter := ';';
  fSplittList.StrictDelimiter := true;
  fKurs := TKurs.Create(nil);
  fAktie := TAktie.Create(nil);
  fFileList := TStringList.Create;
end;

destructor TKursimport.Destroy;
begin
  FreeAndNil(fList);
  FreeAndNil(fSplittList);
  FreeAndNil(fKurs);
  FreeAndNil(fAktie);
  FreeAndNil(fFileList);
  inherited;
end;

function TKursimport.Exec: Boolean;
var
  i1: Integer;
  i2: Integer;
  Boersenindexname: string;
  Filename: string;
  iPos: Integer;
begin
  Result := false;
  if fTrans = nil then
    exit;
  fTrans.StartTransaction;
  try
    fKurs.Trans := fTrans;
    fAktie.Trans := fTrans;
    fList.Clear;
    if not DirectoryExists(Ini.Zielpfad) then
      exit;

    GetAllFiles(Ini.Zielpfad, fFileList, true, false, '*.csv');
    for i1 := 0 to fFileList.Count -1 do
    begin
      Filename := ExtractFileName(fFileList.Strings[i1]);
      if SameText(Filename, 'Aktien.csv') then
        continue;
      iPos := Pos('_', Filename);
      if iPos <= 0 then
        continue;
      ImportFile(fFileList.Strings[i1]);
    end;

  finally
    if fTrans.InTransaction then
      fTrans.Commit;
  end;
  Result := true;
end;

procedure TKursimport.ImportFile(aFilename: string);
var
  Aktie: string;
  Wkn: string;
  iPos: Integer;
  i1: Integer;
  Kurs: Extended;
  Datum: TDateTime;
  LetztesDatum: TDateTime;
  Filename: string;
  List: TStringList;
  Pfad: string;
  Protokollname: string;
begin
  List := TStringList.Create;
  Pfad := IncludeTrailingBackslash(ExtractFilePath(ParamStr(0))) + 'Protokoll\';
  if not DirectoryExists(Pfad) then
    ForceDirectories(Pfad);

  fKurs.Trans := Trans;
  fAktie.Trans := Trans;
  Filename := ExtractFileName(aFilename);
  iPos := Pos('_', Filename);
  wkn := copy(Filename, 1, iPos-1);
  Aktie := copy(Filename, iPos+1, Length(Filename));
  Aktie := copy(Aktie, 1, Length(Aktie)-4);
  fAktie.ReadWKN(wkn);
  if not fAktie.Gefunden then
    exit;
  Protokollname := Pfad + fAktie.Aktie + '.txt';
  LetztesDatum := fKurs.getLastDatum(fAktie.Id);
  List.Add('LetztesDatum = ' + FormatDateTime('dd.mm.yyyy', LetztesDatum));
  fList.LoadFromFile(aFilename);
  fProgressBar.Position := 0;
  fProgressBar.Max := fList.Count;
  for i1 := 0 to fList.Count -1 do
  begin

    fSplittList.DelimitedText := fList.Strings[i1];
    if fSplittList.Count < 2 then
      continue;
    if not TryStrToDateTime(fSplittList.Strings[fCol.Datum], Datum) then
      continue;

    if Assigned(fOnNewRow) then
      fOnNewRow(Self, fAktie, fSplittList.Strings[fCol.Datum], i1+1, fList.Count);

    fProgressLabel.Caption := '[' + fAktie.WKN + '] ' + fAktie.Aktie + ' ' + fSplittList.Strings[fCol.Datum];
    fProgressBar.Position := i1 + 1;
    fProgressLabel.Invalidate;
    fProgressLabel.Refresh;

    List.Add(fSplittList.Strings[fCol.Kurs]);
    List.SaveToFile(Protokollname);

    if not TryStrToFloat(fSplittList.Strings[fCol.Kurs], Kurs) then
      continue;
    if trunc(LetztesDatum) >= trunc(Datum) then
      continue;
    fKurs.Init;
    fKurs.Datum := Datum;
    fKurs.AK_ID := fAktie.Id;
    fKurs.Kurs  := Kurs;

    List.Add(FloatToStr(Kurs));
    List.SaveToFile(Protokollname);

    fKurs.SaveToDB;
  end;
  List.SaveToFile(Protokollname);
  FreeAndNil(List);
end;

end.
