unit Allgemein.Ini;

interface

uses
  SysUtils, Classes, IniFiles;

type
  TtbRootKey = (HKEY_CLASSES_ROOT_, HKEY_CURRENT_USER_, HKEY_LOCAL_MACHINE_,
                HKEY_USERS_, HKEY_PERFORMANCE_DATA_, HKEY_CURRENT_CONFIG_,
                HKEY_DYN_DATA_);


type
  TIni = class
  private
    fIniName: string;
    fProgrammName: string;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    function IniPfad: string;
    function IniFileName: string;
    property ProgrammName: string read fProgrammName write fProgrammName;
    property IniName: string read fIniName write fIniName;
    function ReadIni(const aFullFileName, aSection, aKey: String; aDefault: String): String;
    procedure WriteIni(const aFullFileName, aSection, aKey: String; aValue: String);
  end;

implementation

uses
  Allgemein.Folderlocation, Allgemein.Types;

{ TIni }

constructor TIni.Create;
begin
  fIniName := '';
  fProgrammName := '';
end;

destructor TIni.Destroy;
begin
  inherited;
end;

function TIni.IniFileName: string;
begin
  Result := '';
  if fIniName > '' then
    Result := IniPfad + fIniName;
  if (IniPfad > '') and (not DirectoryExists(IniPfad)) then
    ForceDirectories(IniPfad);
end;

function TIni.IniPfad: string;
begin
  Result := IncludeTrailingPathDelimiter(TSysFolderLocation.GetFolder(cCSIDL_APPDATA));
  if fProgrammName > '' then
    Result := Result + fProgrammName + '\';
end;

function TIni.ReadIni(const aFullFileName, aSection, aKey: String;
  aDefault: String): String;
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    Result := INI.ReadString(aSection, aKey, aDefault);
  finally
    FreeAndNil(INI);
  end;
end;

procedure TIni.WriteIni(const aFullFileName, aSection, aKey: String;
  aValue: String);
var
  INI: TIniFile;
begin
  INI := TIniFile.Create(aFullFileName);
  try
    INI.WriteString(aSection, aKey, aValue);
  finally
    FreeAndNil(INI);
  end;
end;


end.
