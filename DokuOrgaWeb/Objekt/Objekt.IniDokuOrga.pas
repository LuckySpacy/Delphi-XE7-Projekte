unit Objekt.IniDokuOrga;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Objekt.Ini, Objekt.Folderlocation;

type
  TIniDokuOrga = class
  private
    fIni: TIni;
    fRuntimePfad: string;
    FIniPfad: string;
    FIniFileName: string;
    function getUsername: string;
    procedure setUsername(const Value: string);
  public
    constructor Create;
    destructor Destroy; override;
    property Username: string read getUsername write setUsername;
  end;

implementation

{ TIniDokuOrga }

uses
  c.Folder;

constructor TIniDokuOrga.Create;
var
  Folderlocation : TFolderLocation;
begin
  fIni := TIni.Create;
  Folderlocation := TFolderLocation.Create(cCSIDL_APPDATA);
  try
    fRuntimePfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
    FIniPfad := IncludeTrailingPathDelimiter(Folderlocation.GetShellFolder) + 'DokuOrgaWeb\';
    FIniFileName     := FIniPfad + 'DokuOrga.ini';
  finally
    FreeAndNil(Folderlocation);
  end;
end;

destructor TIniDokuOrga.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;

function TIniDokuOrga.getUsername: string;
begin
  Result := fIni.ReadIni(FIniFileName, 'LastLogin', 'Username', 'Admin');
end;

procedure TIniDokuOrga.setUsername(const Value: string);
begin
  fIni.WriteIni(FIniFileName, 'LastLogin', 'Username', Value);
end;

end.
