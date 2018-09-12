unit o_EinstellungGoogleDrive;

interface

uses
  SysUtils, Classes, IBDatabase, IBQuery, obServerClient, o_Msg, o_SyField,
  o_Systemeinstellung;


type
  TSyEinstellungGoogleDrive = class(TComponent)
  private
    FClientId: TSyFeld;
    FPfad: TSyFeld;
    FClientKey: TSyFeld;
    FGDriveVerwenden: TSyFeld;
    function getClientId: TSyFeld;
    function getClientKey: TSyFeld;
    function getPfad: TSyFeld;
    function getGDriveVerwenden: TSyFeld;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property ClientId: TSyFeld read getClientId write FClientId;
    property ClientKey: TSyFeld read getClientKey write FClientKey;
    property GDriveVerwenden: TSyFeld read getGDriveVerwenden write FGDriveVerwenden;
    property Pfad: TSyFeld read getPfad write FPfad;
  end;


implementation

{ TSyEinstellungGoogleDrive }

constructor TSyEinstellungGoogleDrive.Create(AOwner: TComponent);
begin
  inherited;
  FClientId := nil;
  FPfad     := nil;
  FClientKey:= nil;
end;

destructor TSyEinstellungGoogleDrive.Destroy;
begin
  if FClientId <> nil then
    FreeAndNil(FClientId);
  if FPfad <> nil then
    FreeAndNil(FPfad);
  if FClientKey <> nil then
    FreeAndNil(FClientKey);
  inherited;
end;

function TSyEinstellungGoogleDrive.getClientId: TSyFeld;
begin
  if FClientId = nil then
    FClientId := TSyFeld.Create(Self, 'GoogleDriveClientId', 8, '');
  Result := FClientId;
end;

function TSyEinstellungGoogleDrive.getClientKey: TSyFeld;
begin
  if FClientKey = nil then
    FClientKey := TSyFeld.Create(Self, 'GoogleDriveClientKey', 9, '');
  Result := FClientKey;
end;


function TSyEinstellungGoogleDrive.getPfad: TSyFeld;
begin
  if FPfad = nil then
    FPfad := TSyFeld.Create(Self, 'GoogleDrivePfad', 10, '');
  Result := FPfad;
end;

function TSyEinstellungGoogleDrive.getGDriveVerwenden: TSyFeld;
begin
  if FGDriveVerwenden = nil then
    FGDriveVerwenden := TSyFeld.Create(Self, 'Google-Drive verwenden', 11, '');
  Result := FGDriveVerwenden;
end;


end.
