unit o_sysobj;

interface

uses
  o_sysakt, SysUtils, Classes, IBDatabase, IBQuery, obServerClient, o_Msg,
  o_Einstellung, o_fileicons, o_Benutzer, Graphics, o_GoogleDrive;


{$R DokuOrgares.res}


type
  TSysObj = class(TComponent)
  private
    FConnected: Boolean;
    FIniFilename: string;
    FIniGridFilename: string;
    FIniConnect: string;
    FRuntimePfad: string;
    FIniPfad: string;
    FDatabase: TIBDatabase;
    FAkt: TSysAkt;
    FObServer: TObServer;
    FMsg: TMsg;
    FFileIconList: TtbFileIcons;
    FBenutzer: TBenutzer;
    FTempPath: string;
    FGDrive: TGoogleDrive;
    function getConnected: Boolean;
    function getBenutzer: TBenutzer;
    function getTempPath: string;
    function getDatenbankfilename: string;
    procedure setDatenbankfilename(const Value: string);
    function getDatenbankserver: string;
    procedure setDatenbankserver(const Value: string);
    procedure setGDrive(const Value: TGoogleDrive);
    function getGDrive: TGoogleDrive;
    function getSyntaxHighlighterFilename: string;
  public
    Einstellung: TSyEinstellung;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Connect;
    function getReorgFilename: string;
    procedure DeleteTempPath;
    function Verschluesseln(aText, aPW: string): string;
    function Entschluesseln(aText, aPW: string): string;
    procedure Zip(aFullZipFileName: string; aZipFileList: TStrings; const DelZippedFiles: Boolean = true);
    function CreateTempPath: string;
    procedure Unzip(aFullZipFileName, aExportPath: string);
    property Connected: Boolean read getConnected;
    property IniFilename: string read FIniFilename;
    property IniGridFilename: string read FIniGridFilename;
    property IniConnect: string read FIniConnect;
    property RuntimePfad: string read FRuntimePfad;
    property Database: TIBDatabase read FDatabase write FDatabase;
    property Akt: TSysAkt read FAkt write FAkt;
    property ObServer: TObServer read FObServer write FObServer;
    property Msg: TMsg read FMsg write FMsg;
    property FileIconList: TtbFileIcons read FFileIconList write FFileIconList;
    property Benutzer: TBenutzer read getBenutzer write FBenutzer;
    property TempPath: string read getTempPath;
    procedure LoadBitmapFromRes(aResType, aResName: string; aBitmap: TBitmap);
    procedure LoadIconFromRes(aResType, aResName: string; aIcon: Graphics.TIcon);
    property Datenbankfilename: string read getDatenbankfilename write setDatenbankfilename;
    property Datenbankserver: string read getDatenbankserver write setDatenbankserver;
    property GDrive: TGoogleDrive read getGDrive write setGDrive;
    function FTPAktiv: Boolean;
    property SyntaxHighlighterFilename: string read getSyntaxHighlighterFilename;
    procedure SaveSyntaxHighlighterToFile;
  end;

var
  SysObj: TSysObj;

implementation

{ TSysObj }

uses
  u_RegIni, ZipMstr, u_system, c_AllgTypes;



constructor TSysObj.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FConnected := false;
  FRuntimePfad := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
  if FileExists(FRuntimePfad + 'rc_compile.bat') then
    FIniPfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'DokuOrga_Entw\'
  else
    FIniPfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'DokuOrga\';
   // FIniPfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'DokuOrga\';

  {$IFDEF ENTW} // Eingeschaltet unter Projekt|Optionen|Delphi-Compiler|Bedingungen
  // FIniPfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'DokuOrga_Entw\';
   //FIniPfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'DokuOrga\';
  {$ENDIF ENTW}
  if DirExist(FIniPfad) < 0 then
    ForceDirectories(FIniPfad);
  FIniFileName := FIniPfad + 'DokuOrga.ini';
  FIniGridFileName := FIniPfad + 'DokuOrgaGrid.ini';
  FIniConnect  := FIniPfad + 'DokuOrga_Connect.ini';
  FDatabase := TIBDatabase.Create(Self);
  FAkt := TSysAkt.Create(Self);
  FObServer := TObServer.Create;
  Einstellung := TSyEinstellung.Create(nil);
  FFileIconList := TtbFileIcons.Create(nil);
  FMsg := nil;
  FBenutzer := nil;
  FTempPath := '';
  FGDrive := nil;
end;

procedure TSysObj.DeleteTempPath;
begin
  ForceDelDirectory(TempPath);
end;

destructor TSysObj.Destroy;
begin
  FDatabase.Connected := false;
  FreeAndNil(FDatabase);
  FreeAndNil(FAkt);
  FreeAndNil(FObServer);
  FreeAndNil(FMsg);
  FreeAndNil(Einstellung);
  FreeAndNil(FFileIconList);
  FreeAndNil(FGDrive);
  inherited;
end;

function TSysObj.getBenutzer: TBenutzer;
begin
  if FBenutzer = nil then
  begin
    FBenutzer := TBenutzer.Create(Self);
    FBenutzer.Read(1);
  end;
  Result := FBenutzer;
end;

function TSysObj.getConnected: Boolean;
begin
  Result := FDatabase.Connected;
end;

function TSysObj.getDatenbankfilename: string;
begin
  Result := ReadIni(FIniConnect, 'DokuOrga', 'Datei', '');
end;

function TSysObj.getDatenbankserver: string;
begin
  Result := ReadIni(FIniConnect, 'DokuOrga', 'Server', '');
end;

function TSysObj.getGDrive: TGoogleDrive;
begin
  if FGDrive <> nil then
  begin
    Result := FGDrive;
    exit;
  end;
  FGDrive := TGoogleDrive.Create(nil);
  FGDrive.ClientId  := Einstellung.GoogleDrive.ClientId.AsString;
  FGDrive.ClientKey := Einstellung.GoogleDrive.ClientKey.AsString;
  FGDrive.TokenIni  := FIniPfad + 'Token.ini';
  Result := FGDrive;
end;

function TSysObj.getSyntaxHighlighterFilename: string;
var
  Pfad: string;
begin
  Pfad := IncludeTrailingPathDelimiter(GetShellFolder(cCSIDL_APPDATA)) + 'SyntaxHighlighter\';
  if not DirectoryExists(Pfad) then
    ForceDirectories(Pfad);
  Result := Pfad + 'syntaxhighlighter.xml';
end;

function TSysObj.getTempPath: string;
begin
  if FTempPath <> '' then
  begin
    Result := FTempPath;
    exit;
  end;
  Result := CreateTempPath;
  FTempPath := Result;
end;

procedure TSysObj.LoadBitmapFromRes(aResType, aResName: string;
  aBitmap: TBitmap);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aBitmap.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;

procedure TSysObj.LoadIconFromRes(aResType, aResName: string;
  aIcon: Graphics.TIcon);
var
  Res: TResourceStream;
begin
  Res := TResourceStream.Create(Hinstance, aResname, PChar(aResType));
  try
    aIcon.LoadFromStream(Res);
  finally
    FreeAndNil(Res);
  end;
end;

procedure TSysObj.SaveSyntaxHighlighterToFile;
var
  List: TStringList;
begin
  List := TStringList.Create;
  try
    List.Text := Einstellung.HighlighterXML.AsBlob;
    List.SaveToFile(SyntaxHighlighterFilename);
  finally
    FreeAndNil(List);
  end;
end;

procedure TSysObj.setDatenbankfilename(const Value: string);
begin
  WriteIni(FIniConnect, 'DokuOrga', 'Datei', Value);
end;

procedure TSysObj.setDatenbankserver(const Value: string);
begin
  WriteIni(FIniConnect, 'DokuOrga', 'Server', Value);
end;

procedure TSysObj.setGDrive(const Value: TGoogleDrive);
begin
  FGDrive := Value;
end;

function TSysObj.CreateTempPath: string;
begin
  Result := IncludeTrailingPathDelimiter(u_system.getTempPath) + 'Dokuorga\';
  if DirExist(Result) < 0 then
    ForceDirectories(Result);
  FTempPath := Result;
end;


procedure TSysObj.Connect;
var
  Username: string;
  Password: string;
  Server: string;
  LogFile: TStringList;
//  DBSection: string;
begin
  LogFile := TStringList.Create;
  try
//FRuntimePfad
    LogFile.Add('IniFilename = ' + FIniFileName);
    if not FileExists(FIniFilename) then
      exit;
    //  DBSection := ReadIni(FIniFilename, 'DBConnect', 'Aktiv', '');
    //  if DBSection = '' then
    //    exit;
    Username := ReadIni(FIniConnect, 'DokuOrga', 'Username', '');
    Password := ReadIni(FIniConnect, 'DokuOrga', 'Passwort', '');
    Server   := ReadIni(FIniConnect, 'DokuOrga', 'Server', '');
    FDatabase.Connected    := false;
    FDatabase.LoginPrompt  := false;
    if Server = '' then
      FDatabase.DatabaseName := ReadIni(FIniConnect, 'DokuOrga', 'Datei', '')
    else
      FDatabase.DatabaseName := Server + ':' + ReadIni(FIniConnect, 'DokuOrga', 'Datei', '');
    LogFile.Add('Username=' + Username);
    LogFile.Add('Passwort=' + Password);
    LogFile.Add('Server=' + Server);
    LogFile.Add('Databasename=' + FDatabase.DatabaseName);
    FDatabase.Params.Clear;
    //FDatabase.Params.Add('user_name=' + Username);
    //FDatabase.Params.Add('password=' + Password);
    FDatabase.Params.Add('user_name=sysdba');
    FDatabase.Params.Add('password=masterkey');
    LogFile.SaveToFile(FRuntimePfad + 'Log.txt');
    FDatabase.Connected := true;
    if FMsg = nil then
      FMsg := TMsg.Create;
  finally
    LogFile.SaveToFile(FRuntimePfad + 'Log.txt');
    FreeAndNil(LogFile);
  end;
end;

function TSysObj.getReorgFilename: string;
var
  LogFile: TStringList;
begin
  LogFile := TStringList.Create;
  try
    LogFile.LoadFromFile(FRuntimePfad + 'Log.txt');
    if not FileExists(FIniFilename) then
      exit;
    Result := ReadIni(FIniConnect, 'DokuOrga', 'ReorgFilename', '');
    if Result = '' then
    begin
      Result := 'c:\Bachmann\DB\Export\dokuorga.dbu';
      WriteIni(FIniConnect, 'DokuOrga', 'ReorgFilename', 'c:\Bachmann\DB\Export\dokuorga.dbu');
    end;
    LogFile.Add('ReorgFilename=' + Result);
  finally
    LogFile.SaveToFile(FRuntimePfad + 'Log.txt');
    FreeAndNil(LogFile);
  end;

end;


procedure TSysObj.Zip(aFullZipFileName: string; aZipFileList: TStrings; const DelZippedFiles: Boolean = true);
var
  Zip: TZipMaster;
  i1: Integer;
begin
  if aFullZipFileName = '' then
    exit;
  Zip := TZipMaster.Create(nil);
  try
    Zip.ZipFileName := aFullZipFileName;
    SysUtils.DeleteFile(Zip.ZipFileName);
    for i1 := 0 to aZipFileList.Count - 1 do
    begin
      Zip.FSpecArgs.Add(aZipFileList.Strings[i1]);
    end;
    Zip.Add;
    if DelZippedFiles then
    begin
      for i1 := 0 to aZipFileList.Count - 1 do
      begin
        SysUtils.DeleteFile(aZipFileList.Strings[i1]);
      end;
    end;
  finally
    FreeAndNil(Zip);
  end;
end;


procedure TSysObj.Unzip(aFullZipFileName, aExportPath: string);
var
  Zip: TZipMaster;
begin
  if aFullZipFileName = '' then
    exit;

  Zip := TZipMaster.Create(nil);
  try
    Zip.ZipFileName := aFullZipFileName;
    Zip.ExtrBaseDir := aExportPath;
    Zip.ExtrOptions := Zip.ExtrOptions + [ExtrOverWrite];
    if FileExist(Zip.ZipFileName) < 0 then
      exit;
    Zip.Extract;
  finally
    FreeAndNil(Zip);
  end;
end;

function TSysObj.Entschluesseln(aText, aPW: string): string;
var
  //i1: Integer;
  i2: Integer;
  iPW: Integer;
  sHex: string;
  sText: string;
begin
  Result := '';
  if aPW = '' then
  begin
    Result := 'Leider wurde kein Passwort übergeben';
    exit;
  end;
  i2 := 1;
  while Length(aText) > 0 do
  begin
    sText := copy(aText, 1, 4);
    Delete(aText, 1, 4);
    inc(i2);
    if i2 > Length(aPW) then
      i2 := 1;
    sHex := '$' + sText;
    iPW  := StrToInt(sHex) - ord(aPW[i2]);
    Result := Result + chr(iPW);
  end;
end;

function TSysObj.FTPAktiv: Boolean;
begin
  Result := false;
  if Trim(SysObj.Einstellung.FTP.Host.AsString) = '' then
    exit;
  if Trim(SysObj.Einstellung.FTP.Pfad.AsString) = '' then
    exit;
  if not (SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean) then
    exit;
  Result := true;
end;

function TSysObj.Verschluesseln(aText, aPW: string): string;
var
  i1, i2: Integer;
  iPW: Integer;
  sHex: string;
begin
  Result := '';
  if aPW = '' then
    exit;
  i2 := 1;
  for i1 := 1 to Length(aText) do
  begin
    inc(i2);
    if i2 > Length(aPW) then
      i2 := 1;
    iPW := Ord(aText[i1]) + ord(aPW[i2]);
    sHex := IntToHex(iPW, 4);
    Result := Result + sHex;
  end;
end;




end.
