unit Objekt.Smartwatch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Verschluesseln, Objekt.Logger,
  Objekt.IniEinstellung, Objekt.Ini;

type
  TSmartwatch = class
  private
    fVerschluesseln: TVerschluesseln;
    fLogger: TLogger;
    fIniEinstellung: TIniEinstellung;
    fIni: TIni;
  public
    constructor Create;
    destructor Destroy; override;
    property Verschluesseln: TVerschluesseln read fVerschluesseln write fVerschluesseln;
    property Logger: TLogger read fLogger write fLogger;
    property IniEinstellung: TIniEinstellung read fIniEinstellung write fIniEinstellung;
    function ProgrammPfad: string;
    function GridIni: string;
    function FormIni: string;
    function Ini: TIni;
  end;

var
  Smartwatch: TSmartwatch;

implementation

{ TSmartwatch }

constructor TSmartwatch.Create;
begin
  fVerschluesseln := TVerschluesseln.Create;
  fLogger := TLogger.Create;
  fIniEinstellung := TIniEinstellung.Create;
  fIni := TIni.Create;
end;

destructor TSmartwatch.Destroy;
begin
  FreeAndNil(fVerschluesseln);
  FreeAndNil(fLogger);
  FreeAndNil(fIniEinstellung);
  FreeAndNil(fIni);
  inherited;
end;

function TSmartwatch.FormIni: string;
begin
  Result := fIniEinstellung.FormIni;
end;

function TSmartwatch.GridIni: string;
begin
  Result :=fIniEinstellung.GridIni;
end;

function TSmartwatch.Ini: TIni;
begin
  Result := fIni;
end;

function TSmartwatch.ProgrammPfad: string;
begin

end;

end.
