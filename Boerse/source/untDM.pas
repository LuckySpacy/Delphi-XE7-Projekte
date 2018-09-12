unit untDM;

interface

{$WARN SYMBOL_PLATFORM OFF}
{$WARN UNIT_PLATFORM OFF}

uses
  SysUtils, Classes, IBDatabase, DB;

type
  TDM = class(TDataModule)
    IBD: TIBDatabase;
    IBT: TIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
  private
    FIniPfad: string;
    FIniSettings: string;
  public
    property IniPfad: string read FIniPfad;
    property IniSettings: string read FIniSettings;
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

uses
  o_nf;


procedure TDM.DataModuleCreate(Sender: TObject);
var
  DBName: string;
begin
  FIniPfad := IncludeTrailingBackslash(TNF.GetInstance.System.GetShellFolder(cCSIDL_APPDATA)) + 'tbBoerse\';
  if not DirectoryExists(FIniPfad) then
    ForceDirectories(FIniPfad);
  FIniSettings := FIniPfad + 'Einstellung.ini';
  DBName := Tnf.GetInstance.RegIni.ReadIni(fIniSettings, 'Database', 'Databasename', '');

  if DBName = '' then
    Tnf.GetInstance.RegIni.WriteIni(FIniSettings, 'Database', 'Databasename', IBD.DatabaseName);

  IBD.DatabaseName := DBName;

  IBD.Connected := true;


end;

end.
