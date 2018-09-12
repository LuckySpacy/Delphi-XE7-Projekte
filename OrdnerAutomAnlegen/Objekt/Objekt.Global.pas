unit Objekt.Global;

interface

uses
  SysUtils, Classes, Objekt.Ini, Allgemein.System;

type
  TGlobal = class
  private
  public
    Ini: TIniObjekt;
    System: TtbSystem;
    constructor Create;
    destructor Destroy; override;
  end;

var
  Global: TGlobal;


implementation

{ TGlobal }


constructor TGlobal.Create;
begin
  Ini := TIniObjekt.Create;
  Ini.ProgrammName := 'OrdnerAutomAnlegen';
  Ini.IniName := 'OrdnerAutomAnlegen.ini';
  System    := TtbSystem.Create;
end;

destructor TGlobal.Destroy;
begin
  FreeAndNil(Ini);
  FreeAndNil(System);
  inherited;
end;


end.
