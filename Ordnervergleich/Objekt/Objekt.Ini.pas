unit Objekt.Ini;

interface

uses
  SysUtils, Classes, Allgemein.Ini;

type
  TIniObjekt = class(TIni)
  private
    function getPfad1: string;
    procedure setPfad1(const Value: string);
    function getPfad2: string;
    procedure setPfad2(const Value: string);
    function getPfad3: string;
    procedure setPfad3(const Value: string);
    function getPfad4: string;
    procedure setPfad4(const Value: string);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Pfad1: string read getPfad1 write setPfad1;
    property Pfad2: string read getPfad2 write setPfad2;
    property Pfad3: string read getPfad3 write setPfad3;
    property Pfad4: string read getPfad4 write setPfad4;
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

function TIniObjekt.getPfad1: string;
begin
  if IniFileName > '' then
    Result := ReadIni(IniFileName, 'Pfad', 'Pfad1', '');
end;


function TIniObjekt.getPfad2: string;
begin
  if IniFileName > '' then
    Result := ReadIni(IniFileName, 'Pfad', 'Pfad2', '');
end;

function TIniObjekt.getPfad3: string;
begin
  if IniFileName > '' then
    Result := ReadIni(IniFileName, 'Pfad', 'Pfad3', '');
end;

function TIniObjekt.getPfad4: string;
begin
  if IniFileName > '' then
    Result := ReadIni(IniFileName, 'Pfad', 'Pfad4', '');
end;

procedure TIniObjekt.setPfad1(const Value: string);
begin
  if IniFilename > '' then
    WriteIni(IniFilename, 'Pfad', 'Pfad1', Value);
end;


procedure TIniObjekt.setPfad2(const Value: string);
begin
  if IniFilename > '' then
    WriteIni(IniFilename, 'Pfad', 'Pfad2', Value);
end;

procedure TIniObjekt.setPfad3(const Value: string);
begin
  if IniFilename > '' then
    WriteIni(IniFilename, 'Pfad', 'Pfad3', Value);
end;

procedure TIniObjekt.setPfad4(const Value: string);
begin
  if IniFilename > '' then
    WriteIni(IniFilename, 'Pfad', 'Pfad4', Value);
end;

end.
