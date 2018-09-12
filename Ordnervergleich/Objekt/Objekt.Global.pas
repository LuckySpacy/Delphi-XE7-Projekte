unit Objekt.Global;

interface

uses
  SysUtils, Classes, Objekt.Ini, Allgemein.System;

type
  TGlobal = class
  private
    fOrdnerIgnoreFile: string;
  public
    Ini: TIniObjekt;
    System: TtbSystem;
    constructor Create;
    destructor Destroy; override;
    property OrdnerIgnoreFile: string read fOrdnerIgnoreFile write fOrdnerIgnoreFile;
  end;

var
  Global: TGlobal;


implementation

{ TGlobal }


constructor TGlobal.Create;
begin
  Ini := TIniObjekt.Create;
  Ini.ProgrammName := 'Ordnervergleich';
  Ini.IniName := 'Ordnervergleich.ini';
  System    := TtbSystem.Create;
  fOrdnerIgnoreFile := IncludeTrailingPathDelimiter(Ini.IniPfad) + 'OrdnerIgnoreList.txt';
end;

destructor TGlobal.Destroy;
begin
  FreeAndNil(Ini);
  FreeAndNil(System);
  inherited;
end;


end.
