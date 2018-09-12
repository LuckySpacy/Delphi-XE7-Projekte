unit o_Einstellung;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, obServerClient, o_Msg, o_SyField,
  o_Systemeinstellung, o_EinstellungFTP, o_EinstellungGoogleDrive;


type
  TSyEinstellung = class(TComponent)
  private
    FDokumentPfad: TSyFeld;
    FKonfSeite: TSyFeld;
    FFTP: TSyEinstellungFTP;
    FGoogleDrive: TSyEinstellungGoogleDrive;
    fHighlighterXML: TSyFeld;
    //FFontFavoriten: TSyFeld;
    function getDokumentPfad: TSyFeld;
    function getKonfSeite: TSyFeld;
    function getHighlighterXML: TSyFeld;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property DokumentPfad: TSyFeld read getDokumentPfad write FDokumentPfad;
    property KonfSeite: TSyFeld read getKonfSeite write FKonfSeite;
    property FTP: TSyEinstellungFTP read FFTP write FFTP;
    property GoogleDrive: TSyEinstellungGoogleDrive read FGoogleDrive write FGoogleDrive;
    property HighlighterXML: TSyFeld read getHighlighterXML write fHighlighterXML;
  end;


implementation

{ TSysObj }

constructor TSyEinstellung.Create(AOwner: TComponent);
begin
  inherited;
  FDokumentPfad := nil;
  FKonfSeite := nil;
  fHighlighterXML := nil;
  FFTP := TSyEinstellungFTP.Create(nil);
  FGoogleDrive := TSyEinstellungGoogleDrive.Create(nil);
end;

destructor TSyEinstellung.Destroy;
begin
  if FDokumentPfad <> nil then
    FreeAndNil(FDokumentPfad);
  if FKonfSeite <> nil then
    FreeAndNil(FKonfSeite);
  FreeAndNil(FFTP);
  FreeAndNil(FGoogleDrive);
  inherited;
end;


function TSyEinstellung.getDokumentPfad: TSyFeld;
begin
  if FDokumentPfad = nil then
    FDokumentPfad := TSyFeld.Create(Self, 'Dokumentenpfad', 1, '');
  Result := FDokumentPfad;
end;




function TSyEinstellung.getKonfSeite: TSyFeld;
begin
  if FKonfSeite = nil then
    FKonfSeite := TSyFeld.Create(Self, 'KonfSeite', 2, '');
  Result := FKonfSeite;
end;

// Id 3 - 6 in FTPEinstellung
// Id 8 - 11 in GoogleDrive-Einstellung

function TSyEinstellung.getHighlighterXML: TSyFeld;
begin
  if fHighlighterXML = nil then
    fHighlighterXML := TSyFeld.Create(Self, 'SyntaxHighlighterXML', 12, '');
  Result := fHighlighterXML;
end;






end.
