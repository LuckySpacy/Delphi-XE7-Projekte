unit of_DataExport;

interface

uses
  SysUtils, Classes, Forms, of_Base, c_Types, obBusinessClasses, obServerClient,
  tbButton, IBDatabase, tbEditFile, e_BilderList, Windows, e_DokumentList,
  e_SeiteList, e_SeitedokumentList, e_itemlist, Vcl.ComCtrls, e_buttonproplist,
  e_Baumbuttonlist, e_ZweigPropList, e_Baumstruklist, e_Seiteverbindenlist, e_sprachlistlist,
  e_GuidList;

type
  Tof_DataExport = class(Tof_Base, IObServerClient)
  private
    FOwner: TForm;
    FEdt_ExportDir: TtbEditFile;
    FEdt_Datum: TDateTimePicker;
    FeBilderList: TeBilderList;
    FeDokumentList: TeDokumentList;
    FeSeiteList: TeSeiteList;
    FeSeitedokumentList: TeSeitedokumentList;
    FeButtonpropList: TeButtonpropList;
    FeBaumbuttonList: TeBaumbuttonList;
    FeZweigPropList: TeZweigPropList;
    FeBaumstrukList: TeBaumstrukList;
    FeItemList: TeItemList;
    FeSeiteverbindenList: TeSeiteverbindenList;
    FeSprachlistList: TeSprachlistList;
    FeGuidList: TeGuidList;
    FImportExport: TImportExport;
    FSpaltentrenner: string;
    FZeilentrenner: string;
    procedure OkClick(Sender: TObject);
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure setImportExport(const Value: TImportExport);
    procedure DoImport;
    procedure DoExport;
    procedure ExportDirRightButtonClick(Sender: TObject);
  protected
    procedure Load(aObjectId: Integer);
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    property ImportExport: TImportExport read FImportExport write setImportExport;
  end;


implementation

{ Tof_Bilder }

uses
  u_system, o_SysObj, u_RegIni;

constructor Tof_DataExport.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FOwner   := TForm(AOwner);
  FEdt_ExportDir := gettbEditFile('edt_ExportDir');
  FEdt_Datum     := getDateTimePicker('edt_Datum');
  FBtn_Ok.OnClick := OkClick;
  if FileExists(SysObj.IniFilename) then
    Fedt_ExportDir.Text := ReadIni(SysObj.IniFilename, 'Export', 'Exportverzeichnis', '');
  if FEdt_ExportDir.Text = '' then
    FEdt_ExportDir.Text := SysObj.RuntimePfad + 'Export';

  FSpaltentrenner := '# #';
  FZeilentrenner  := '~ ~';
  Fedt_Datum.DateTime := StrToDate('01.01.2000');
  if FileExists(SysObj.IniFilename) then
    Fedt_Datum.DateTime := StrToDate(ReadIni(SysObj.IniFilename, 'Export', 'Exportdatum', '01.01.2000'));
  FEdt_ExportDir.OnRightButtonClick := ExportDirRightButtonClick;

end;

destructor Tof_DataExport.Destroy;
begin

  inherited;
end;

procedure Tof_DataExport.DoExport;
var
  ExportPath: string;
  FileList: TStringList;
  ZipFileName: string;
  NewZipFile: string;
  ShortFileName: string;
begin
  ZipFileName := IncludeTrailingPathDelimiter(FEdt_ExportDir.Text) + 'DokuOrgaData.zip';
  ShortFileName := GetFileNameWithoutExt(ExtractFileName(ZipFileName));
  NewZipFile :=  IncludeTrailingPathDelimiter(FEdt_ExportDir.Text) + ShortFilename + '_' +
                 FormatDateTime('yy-mm-dd-hhnnss', now) + ExtractFileExt(ZipFileName);
  if FileExist(ZipFileName) >= 0 then
    RenameFile(ZipFileName, NewZipFile);

  WriteIni(SysObj.IniFilename, 'Export', 'Exportverzeichnis', FEdt_ExportDir.Text);
  WriteIni(SysObj.IniFilename, 'Export', 'Exportdatum', DateToStr(now));


  ExportPath := GetTempPath + 'DokuOrgaData\';
  ForceDelDirectory(ExportPath);
  ForceDirectories(ExportPath);
  FileList := TStringList.Create;
  try
    FeBilderList := TeBilderList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Bilder', FEdt_Datum.DateTime);
    try
      FeBilderList.ExportPath := ExportPath;
      FeBilderList.doExport;
    finally
      FreeAndNil(FeBilderList);
    end;
    FeDokumentList := TeDokumentList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Dokument', FEdt_Datum.DateTime);
    try
      FeDokumentList.ExportPath := ExportPath;
      FeDokumentList.doExport;
    finally
      FreeAndNil(FeDokumentList);
    end;

    FeSeiteList := TeSeiteList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Seite', FEdt_Datum.DateTime);
    try
      FeSeiteList.ExportPath := ExportPath;
      FeSeiteList.doExport;
    finally
      FreeAndNil(FeSeiteList);
    end;

    FeSeitedokumentList := TeSeitedokumentList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Seitedokument', FEdt_Datum.DateTime);
    try
      FeSeitedokumentList.ExportPath := ExportPath;
      FeSeitedokumentList.doExport;
    finally
      FreeAndNil(FeSeitedokumentList);
    end;

    FeSprachlistList := TeSprachlistList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Sprachlist', FEdt_Datum.DateTime);
    try
      FeSprachlistList.ExportPath := ExportPath;
      FeSprachlistList.doExport;
    finally
      FreeAndNil(FeSprachlistList);
    end;

    FeItemList := TeItemList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Itemlist', FEdt_Datum.DateTime);
    try
      FeItemList.ExportPath := ExportPath;
      FeItemList.doExport;
    finally
      FreeAndNil(FeItemList);
    end;

    FeButtonpropList := TeButtonpropList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Buttonprop', FEdt_Datum.DateTime);
    try
      FeButtonpropList.ExportPath := ExportPath;
      FeButtonpropList.doExport;
    finally
      FreeAndNil(FeButtonpropList);
    end;

    FeBaumbuttonList := TeBaumbuttonList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Baumbutton', FEdt_Datum.DateTime);
    try
      FeBaumbuttonList.ExportPath := ExportPath;
      FeBaumbuttonList.doExport;
    finally
      FreeAndNil(FeBaumbuttonList);
    end;

    FeZweigPropList := TeZweigPropList.Create(Self, FSpaltentrenner, FZeilentrenner, 'ZweigProp', FEdt_Datum.DateTime);
    try
      FeZweigPropList.ExportPath := ExportPath;
      FeZweigPropList.doExport;
    finally
      FreeAndNil(FeZweigPropList);
    end;

    FeBaumstrukList := TeBaumstrukList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Baumstruk', FEdt_Datum.DateTime);
    try
      FeBaumstrukList.ExportPath := ExportPath;
      FeBaumstrukList.doExport;
    finally
      FreeAndNil(FeBaumstrukList);
    end;

    FeSeiteverbindenList := TeSeiteverbindenList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Seiteverbindung', FEdt_Datum.DateTime);
    try
      FeSeiteverbindenList.ExportPath := ExportPath;
      FeSeiteverbindenList.doExport;
    finally
      FreeAndNil(FeSeiteverbindenList);
    end;

    FeGuidList := TeGuidList.Create(Self, FSpaltentrenner, FZeilentrenner, 'DeleteGuid', FEdt_Datum.DateTime);
    try
      FeGuidList.ExportPath := ExportPath;
      FeGuidList.doExport;
    finally
      FreeAndNil(FeGuidList);
    end;

    GetAllFiles(ExportPath, FileList, true);
    SysObj.Zip(ZipFileName, FileList);
    ForceDelDirectory(ExportPath);
  finally
    FreeAndNil(FileList);
  end;
end;

procedure Tof_DataExport.DoImport;
var
  ImportPath: string;
  ZipFileName: string;
begin
  ZipFileName := FEdt_ExportDir.Text;
  if FileExist(ZipFileName) < 0 then
    exit;
  ImportPath := GetTempPath + 'DokuOrgaData\';

  WriteIni(SysObj.IniFilename, 'Import', 'Importverzeichnis', FEdt_ExportDir.Text);
  WriteIni(SysObj.IniFilename, 'Import', 'Importdatum', DateToStr(FEdt_Datum.DateTime));

  //if not ForceDelDirectory(ImportPath) then
  //  exit;
  ForceDelDirectory(ImportPath);
  ForceDirectories(ImportPath);
  SysObj.Unzip(ZipFileName, ImportPath);
  if FileExist(ImportPath + 'Bilder.zip') >= 0 then
  begin
    FeBilderList := TeBilderList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Bilder', FEdt_Datum.DateTime);
    try
      FeBilderList.ImportZipFile := ImportPath + 'Bilder.zip';
      FeBilderList.doImport;
    finally
      FreeAndNil(FeBilderList);
    end;
  end;

  if FileExist(ImportPath + 'Dokument.zip') >= 0 then
  begin
    FeDokumentList := TeDokumentList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Dokument', FEdt_Datum.DateTime);
    try
      FeDokumentList.ImportZipFile := ImportPath + 'Dokument.zip';
      FeDokumentList.doImport;
    finally
      FreeAndNil(FeDokumentList);
    end;
  end;

  if FileExist(ImportPath + 'Seite.zip') >= 0 then
  begin
    FeSeiteList := TeSeiteList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Seite', FEdt_Datum.DateTime);
    try
      FeSeiteList.ImportZipFile := ImportPath + 'Seite.zip';
      FeSeiteList.doImport;
    finally
      FreeAndNil(FeSeiteList);
    end;
  end;

  if FileExist(ImportPath + 'Seitedokument.zip') >= 0 then
  begin
    FeSeitedokumentList := TeSeitedokumentList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Seitedokument', FEdt_Datum.DateTime);
    try
      FeSeitedokumentList.ImportZipFile := ImportPath + 'Seitedokument.zip';
      FeSeitedokumentList.doImport;
    finally
      FreeAndNil(FeSeiteList);
    end;
  end;


  if FileExist(ImportPath + 'Sprachlist.zip') >= 0 then
  begin
    FeSprachlistList := TeSprachlistList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Sprachlist', FEdt_Datum.DateTime);
    try
      FeSprachlistList.ImportZipFile := ImportPath + 'Sprachlist.zip';
      FeSprachlistList.doImport;
    finally
      FreeAndNil(FeSprachlistList);
    end;
  end;


  if FileExist(ImportPath + 'Itemlist.zip') >= 0 then
  begin
    FeItemList := TeItemList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Itemlist', FEdt_Datum.DateTime);
    try
      FeItemList.ImportZipFile := ImportPath + 'Itemlist.zip';
      FeItemList.doImport;
    finally
      FreeAndNil(FeItemList);
    end;
  end;


  if FileExist(ImportPath + 'Buttonprop.zip') >= 0 then
  begin
    FeButtonpropList := TeButtonpropList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Buttonprop', FEdt_Datum.DateTime);
    try
      FeButtonpropList.ImportZipFile := ImportPath + 'Buttonprop.zip';
      FeButtonpropList.doImport;
    finally
      FreeAndNil(FeButtonpropList);
    end;
  end;

  if FileExist(ImportPath + 'BaumButton.zip') >= 0 then
  begin
    FeBaumButtonList := TeBaumButtonList.Create(Self, FSpaltentrenner, FZeilentrenner, 'BaumButton', FEdt_Datum.DateTime);
    try
      FeBaumButtonList.ImportZipFile := ImportPath + 'BaumButton.zip';
      FeBaumButtonList.doImport;
    finally
      FreeAndNil(FeBaumButtonList);
    end;
  end;

  if FileExist(ImportPath + 'ZweigProp.zip') >= 0 then
  begin
    FeZweigPropList := TeZweigPropList.Create(Self, FSpaltentrenner, FZeilentrenner, 'ZweigProp', FEdt_Datum.DateTime);
    try
      FeZweigPropList.ImportZipFile := ImportPath + 'ZweigProp.zip';
      FeZweigPropList.doImport;
    finally
      FreeAndNil(FeZweigPropList);
    end;
  end;

  if FileExist(ImportPath + 'Baumstruk.zip') >= 0 then
  begin
    FeBaumstrukList := TeBaumstrukList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Baumstruk', FEdt_Datum.DateTime);
    try
      FeBaumstrukList.ImportZipFile := ImportPath + 'Baumstruk.zip';
      FeBaumstrukList.doImport;
    finally
      FreeAndNil(FeBaumstrukList);
    end;
  end;

  if FileExist(ImportPath + 'Seiteverbindung.zip') >= 0 then
  begin
    FeSeiteverbindenList := TeSeiteverbindenList.Create(Self, FSpaltentrenner, FZeilentrenner, 'Seiteverbindung', FEdt_Datum.DateTime);
    try
      FeSeiteverbindenList.ImportZipFile := ImportPath + 'Seiteverbindung.zip';
      FeSeiteverbindenList.doImport;
    finally
      FreeAndNil(FeSeiteverbindenList);
    end;
  end;


  if FileExist(ImportPath + 'DeleteGuid.zip') >= 0 then
  begin
    FeGuidList := TeGuidList.Create(Self, FSpaltentrenner, FZeilentrenner, 'DeleteGuid', FEdt_Datum.DateTime);
    try
      FeGuidList.ImportZipFile := ImportPath + 'DeleteGuid.zip';
      FeGuidList.doImport;
    finally
      FreeAndNil(FeGuidList);
    end;
  end;





end;

procedure Tof_DataExport.ExportDirRightButtonClick(Sender: TObject);
begin
  FEdt_ExportDir.OpenDialog.InitialDir := FEdt_ExportDir.Text;
  if FEdt_ExportDir.OpenDialog.Execute then
    FEdt_ExportDir.Text := FEdt_ExportDir.OpenDialog.FileName;
end;

procedure Tof_DataExport.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
begin

end;


procedure Tof_DataExport.OkClick(Sender: TObject);
begin
  if (FImportExport = cExport) then
    if not DirectoryExists(Fedt_ExportDir.Text) then
      ForceDirectories(FEdt_ExportDir.Text);

  if (FImportExport = cExport)
  and (not DirectoryExists(Fedt_ExportDir.Text)) then
    exit;
  if (FImportExport = cImport)
  and (not FileExists(Fedt_ExportDir.Text)) then
    exit;
  if FImportExport = cExport then
    DoExport
  else
    DoImport;
  FOwner.close;
end;

procedure Tof_DataExport.setImportExport(const Value: TImportExport);
begin
  FOwner.Caption := 'Daten exportieren';
  FImportExport := Value;
  if FImportExport = cImport then
  begin
    FEdt_ExportDir.UseTextFile := true;
    FOwner.Caption := 'Daten importieren';
    //Fedt_ExportDir.Text := 'c:\bachmann\export\DokuOrgaData.zip';

    if FileExists(SysObj.IniFilename) then
      Fedt_ExportDir.Text := ReadIni(SysObj.IniFilename, 'Import', 'Importverzeichnis', '');
    if FEdt_ExportDir.Text = '' then
      FEdt_ExportDir.Text := SysObj.RuntimePfad + 'Import';
    Fedt_Datum.DateTime := StrToDate('01.01.2000');
    if FileExists(SysObj.IniFilename) then
      Fedt_Datum.DateTime := StrToDate(ReadIni(SysObj.IniFilename, 'Import', 'Importdatum', '01.01.2000'));
  end;


  if FImportExport = cExport then
  begin
    if FileExists(SysObj.IniFilename) then
      Fedt_ExportDir.Text := ReadIni(SysObj.IniFilename, 'Export', 'Exportverzeichnis', '');
    if FEdt_ExportDir.Text = '' then
      FEdt_ExportDir.Text := SysObj.RuntimePfad + 'Export';
    Fedt_Datum.DateTime := StrToDate('01.01.2000');
    if FileExists(SysObj.IniFilename) then
      Fedt_Datum.DateTime := StrToDate(ReadIni(SysObj.IniFilename, 'Export', 'Exportdatum', '01.01.2000'));
  end;


end;

procedure Tof_DataExport.Load(aObjectId: Integer);
begin

end;


end.
