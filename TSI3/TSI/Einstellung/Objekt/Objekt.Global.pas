unit Objekt.Global;

interface

uses
  SysUtils, Classes, variants, IBX.IBDatabase;

type
  TGlobal = class(TComponent)
  private
    fUserPfad: string;
    fTrans: TIBTransaction;
    function getUserPfad: string;
    function getIniFilename: string;
    function getDatenbankfilename: string;
    procedure setDatenbankfilename(const Value: string);
    function getDatenbankserver: string;
    procedure setDatenbankserver(const Value: string);
    function getCSVPfad: string;
    procedure setCSVPfad(const Value: string);
    function getLetztesKursDatumHeute: Boolean;
    procedure setLetztesKursDatumHeute(const Value: Boolean);
    function getWochen: Integer;
    procedure setWochen(const Value: Integer);
    function getStartKursListe: TDateTime;
    procedure setStartKursListe(const Value: TDateTime);
    function getEndeKursListe: TDateTime;
    procedure setEndeKursListe(const Value: TDateTime);
    function getEndeChartVariable: TDateTime;
    function getStartChartVariable: TDateTime;
    procedure setEndeChartVariable(const Value: TDateTime);
    procedure setStartChartVariable(const Value: TDateTime);
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Userpfad: string read getUserPfad;
    property IniFilename: string read getIniFilename;
    property DatenbankFilename: string read getDatenbankfilename write setDatenbankfilename;
    property DatenbankServer: string read getDatenbankserver write setDatenbankserver;
    property CSVPfad: string read getCSVPfad write setCSVPfad;
    property Trans: TIBTransaction read fTrans write fTrans;
    property LetztesKursDatumHeute: Boolean read getLetztesKursDatumHeute write setLetztesKursDatumHeute;
    property StartKursliste: TDateTime read getStartKursListe write setStartKursListe;
    property EndeKursliste: TDateTime read getEndeKursListe write setEndeKursListe;
    property StartChartVariable: TDateTime read getStartChartVariable write setStartChartVariable;
    property EndeChartVariable: TDateTime read getEndeChartVariable write setEndeChartVariable;
    property Wochen: Integer read getWochen write setWochen;
    function ProgrammPfad: string;
  end;

var
  Global: TGlobal;

implementation

{ TGlobal }

uses
  Allgemein.SysFolderlocation, Allgemein.Types, Allgemein.RegIni, shellapi,
  Winapi.Windows, Vcl.dialogs;


constructor TGlobal.Create(AOwner: TComponent);
begin
  inherited;
  fUserPfad := '';
end;

destructor TGlobal.Destroy;
begin

  inherited;
end;


function TGlobal.getDatenbankfilename: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'TSIFDB', '');
  if (Result = '') or (not FileExists(Result)) then
  begin
    if FileExists(ProgrammPfad + 'TSI.FDB') then
    begin
      WriteIni(IniFilename, 'Datenbank', 'Datenbankfilename', ProgrammPfad + 'TSI.FDB');
      Result := ProgrammPfad + 'TSI.FDB';
      exit;
    end;
    if FileExists(ProgrammPfad + 'Datenbank\TSI.FDB') then
    begin
      WriteIni(IniFilename, 'Datenbank', 'Datenbankfilename', ProgrammPfad + 'Datenbank\TSI.FDB');
      Result := ProgrammPfad + 'Datenbank\TSI.FDB';
      exit;
    end;
  end;
end;

function TGlobal.getDatenbankserver: string;
begin
  Result := ReadIni(IniFilename, 'Datenbank', 'Server', '');
end;


function TGlobal.getEndeChartVariable: TDateTime;
var
  s: string;
begin
  s := ReadIni(IniFilename, 'Frame.ChartVariable', 'EndeChartVariable', DateToStr(now));
  if not TryStrToDate(s, Result) then
    Result := trunc(now);
end;

function TGlobal.getEndeKursListe: TDateTime;
var
  s: string;
begin
  s := ReadIni(IniFilename, 'Frame.Kursliste', 'EndeKursListe', DateToStr(now));
  if not TryStrToDate(s, Result) then
    Result := trunc(now);
end;

function TGlobal.getIniFilename: string;
begin
  Result := getUserPfad + 'TSI.ini';
end;


function TGlobal.getLetztesKursDatumHeute: Boolean;
begin
  Result := ReadIni(IniFilename, 'Frame.Aktie', 'LetztesKursDatumHeute', 'T') = 'T';
end;

function TGlobal.getStartChartVariable: TDateTime;
var
  s: string;
begin
  s := ReadIni(IniFilename, 'Frame.ChartVariable', 'StartChartVariable', DateToStr(now));
  if not TryStrToDate(s, Result) then
    Result := trunc(now);
end;

function TGlobal.getStartKursListe: TDateTime;
var
  s: string;
begin
  s := ReadIni(IniFilename, 'Frame.Kursliste', 'StartKursListe', DateToStr(now));
  if not TryStrToDate(s, Result) then
    Result := trunc(now);
end;

function TGlobal.getUserPfad: string;
begin
  Result := fUserPfad;
  if Result = '' then
  begin
    Result := IncludeTrailingPathDelimiter(TSysFolderLocation.GetFolder(cCSIDL_APPDATA)) + 'TSI\';
    fUserPfad := Result;
    if not DirectoryExists(fUserPfad) then
      ForceDirectories(fUserPfad);
  end;
end;

function TGlobal.getWochen: Integer;
begin
  Result := StrToInt(ReadIni(IniFilename, 'Frame.Aktie', 'Wochen', '27'));
end;

function TGlobal.ProgrammPfad: string;
begin
  Result := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
end;


procedure TGlobal.setDatenbankfilename(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'Datenbankfilename', Value);
end;

procedure TGlobal.setDatenbankserver(const Value: string);
begin
  WriteIni(IniFilename, 'Datenbank', 'Server', Value);
end;

procedure TGlobal.setEndeChartVariable(const Value: TDateTime);
begin
  WriteIni(IniFilename, 'Frame.ChartVariable', 'EndeChartVariable', DateToStr(Value));
end;

procedure TGlobal.setEndeKursListe(const Value: TDateTime);
begin
  WriteIni(IniFilename, 'Frame.Kursliste', 'EndeKursListe', DateToStr(Value));
end;

procedure TGlobal.setLetztesKursDatumHeute(const Value: Boolean);
begin
  if Value then
    WriteIni(IniFilename, 'Frame.Aktie', 'LetztesKursDatumHeute', 'T')
  else
    WriteIni(IniFilename, 'Frame.Aktie', 'LetztesKursDatumHeute', 'F');
end;

procedure TGlobal.setStartChartVariable(const Value: TDateTime);
begin
  WriteIni(IniFilename, 'Frame.ChartVariable', 'StartChartVariable', DateToStr(Value));
end;

procedure TGlobal.setStartKursListe(const Value: TDateTime);
begin
  WriteIni(IniFilename, 'Frame.Kursliste', 'StartKursListe', DateToStr(Value));
end;

procedure TGlobal.setWochen(const Value: Integer);
begin
  WriteIni(IniFilename, 'Frame.Aktie', 'Wochen', IntToStr(Value));
end;

function TGlobal.getCSVPfad: string;
begin
  Result := ReadIni(IniFilename, 'CSV', 'CSVPfad', '');
end;

procedure TGlobal.setCSVPfad(const Value: string);
begin
  WriteIni(IniFilename, 'CSV', 'CSVPfad', Value);
end;



end.
