unit o_EinstellungFTP;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, obServerClient, o_Msg, o_SyField,
  o_Systemeinstellung;


type
  TSyEinstellungFTP = class(TComponent)
  private
    FUsername: TSyFeld;
    FHost: TSyFeld;
    FPasswort: TSyFeld;
    FPfad: TSyFeld;
    FDokumenteUebertragen: TSyFeld;
    function getUsername: TSyFeld;
    function getHost: TSyFeld;
    function getPasswort: TSyFeld;
    function getPfad: TSyFeld;
    function getDokumenteUebertragen: TSyFeld;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Host: TSyFeld read getHost write FHost;
    property Username: TSyFeld read getUsername write FUsername;
    property Passwort: TSyFeld read getPasswort write FPasswort;
    property Pfad: TSyFeld read getPfad write FPfad;
    property DokumenteUebertragen: TSyFeld read getDokumenteUebertragen write FDokumenteUebertragen;
  end;

implementation

{ TSyEinstellungFTP }


constructor TSyEinstellungFTP.Create(AOwner: TComponent);
begin
  inherited;
  FUsername:= nil;
  FHost    := nil;
  FPasswort:= nil;
  FPfad    := nil;
end;

destructor TSyEinstellungFTP.Destroy;
begin
  if FUsername <> nil then
    FreeAndNil(FUsername);
  if FHost <> nil then
    FreeAndNil(FHost);
  if FPasswort <> nil then
    FreeAndNil(FPasswort);
  if FPfad <> nil then
    FreeAndNil(FPfad);
  inherited;
end;


function TSyEinstellungFTP.getHost: TSyFeld;
begin
  if FHost = nil then
    FHost := TSyFeld.Create(Self, 'FTPHost', 3, '');
  Result := FHost;
end;

function TSyEinstellungFTP.getPasswort: TSyFeld;
begin
  if FPasswort = nil then
  begin
    FPasswort := TSyFeld.Create(Self, 'FTPPasswort', 4, '');
    FPasswort.Verschluesselt := true;
  end;
  Result := FPasswort;
end;

function TSyEinstellungFTP.getPfad: TSyFeld;
begin
  if FPfad = nil then
    FPfad := TSyFeld.Create(Self, 'FTPPfad', 5, '');
  Result := FPfad;
end;

function TSyEinstellungFTP.getUsername: TSyFeld;
begin
  if FUsername = nil then
    FUsername := TSyFeld.Create(Self, 'FTPUsername', 6, '');
  Result := FUsername;
end;


function TSyEinstellungFTP.getDokumenteUebertragen: TSyFeld;
begin
  if FDokumenteUebertragen = nil then
    FDokumenteUebertragen := TSyFeld.Create(Self, 'FTPDokumenteUebertragen', 7, '');
  Result := FDokumenteUebertragen;
end;




end.
