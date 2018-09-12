unit Objekt.Ini;

interface

uses
  SysUtils, Classes, Allgemein.Ini;

type
  TIniObjekt = class(TIni)
  private
    function getPfad: string;
    procedure setPfad(const Value: string);
    function getEndung: string;
    procedure setEndung(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Pfad: string read getPfad write setPfad;
    property Endung: string read getEndung write setEndung;
  end;

implementation

{ TIniObjekt }

constructor TIniObjekt.Create;
begin
  inherited;

end;

destructor TIniObjekt.Destroy;
begin

  inherited;
end;

function TIniObjekt.getEndung: string;
begin
  if IniFileName > '' then
    Result := ReadIni(IniFileName, 'Endung', 'Endung', '');
end;

function TIniObjekt.getPfad: string;
begin
  if IniFileName > '' then
    Result := ReadIni(IniFileName, 'Pfad', 'Pfad', '');
end;

procedure TIniObjekt.setEndung(const Value: string);
begin
  if IniFilename > '' then
    WriteIni(IniFilename, 'Endung', 'Endung', Value);
end;

procedure TIniObjekt.setPfad(const Value: string);
begin
  if IniFilename > '' then
    WriteIni(IniFilename, 'Pfad', 'Pfad', Value);
end;


end.
