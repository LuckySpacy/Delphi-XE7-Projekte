unit of_SeiteEinstellung;

interface

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, Contnrs, IBDatabase, fr_Base, Menus, tbStringGrid, AdvDirectoryEdit,
  o_Seiteverbinden, AdvEdBtn, o_BaumButton, o_Buttonprop;

type
  Tof_SeiteEinstellung = class(Tof_Base, IObServerClient)
  private
    FTrans: TIBTransaction;
    Fedt_Dir: TAdvDirectoryEdit;
    Fedt_FTPDir: TAdvDirectoryEdit;
    Fchb_PW: TCheckbox;
    Fchb_FTPUebertragen: TCheckbox;
    Fedt_GDriveDir: TAdvEditBtn;
    Fchb_GDriveUebertragen: TCheckbox;
    FSeiteverbinden: TSeiteverbinden;
    FVerzeichnisMerken: string;
    FDoExitbyChange: Boolean;
    FDoExitbyPWClick: Boolean;
    fBtn_FP_Vorschlagen: TTBButton;
    fBtn_GDrive_FPUebernehmen: TTBButton;
    fBaumButton: TBaumbutton;
    procedure edt_DirShowDirectoryDialog(Sender: TObject; var InitialPath: string);
    procedure edt_DirGDriveShowDirectoryDialog(Sender: TObject; var InitialPath: string);
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure edt_DirValueValidate(Sender: TObject; Value: string; var IsValid: Boolean);
    procedure edt_DirChange(Sender: TObject);
    procedure edt_DirEnter(Sender: TObject);
    procedure LadeSeite;
    procedure Chb_PWClick(Sender: TObject);
    procedure FtpdirExit(Sender: TObject);
    procedure Chb_FTPUebertragen(Sender: TObject);
    procedure Chb_GDriveUebertragen(Sender: TObject);
    procedure edt_DirGDriveClickBtn(Sender: TObject);
    procedure FP_VorschlagenClick(Sender: TObject);
    procedure GDrive_FPUebernehmenClick(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure VisibleChanged(aValue: Boolean); override;
    procedure RegisterNotify;
    procedure UnregisterNotify;
  end;

implementation

{ Tof_SeiteEinstellung }

uses
  c_DBTypes, System.UITypes, o_dokumentlist, o_seitedokumentlist, o_dokument,
  Winapi.Windows, fnt_passwort_festlegen, fnt_passwort, fnt_GDriveBaum;



constructor Tof_SeiteEinstellung.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FVerzeichnisMerken := '';
  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FTrans.Name := 'of_SeiteEinstellung';

  FSeiteverbinden := TSeiteverbinden.Create(Self);
  FSeiteverbinden.Trans := FTrans;

  FDoExitbyChange := true;
  FDoExitbyPWClick := false;
  Fedt_Dir := getAdvDirectoryEdit('edt_Dir');
  Fedt_Dir.AllowNewFolder := true;
  Fedt_Dir.EditorEnabled  := false;
  Fedt_Dir.OnShowDirectoryDialog := edt_DirShowDirectoryDialog;
  Fedt_Dir.OnValueValidate := edt_DirValueValidate;
  Fedt_Dir.OnChange := edt_DirChange;
  Fedt_Dir.OnEnter  := edt_DirEnter;
  Fchb_PW := getCheckbox('chb_pw');
  Fchb_PW.OnClick := Chb_PWClick;
  Fchb_FTPUebertragen := getCheckbox('cbx_FTPUebertragen');
  FChb_FTPUebertragen.OnClick := Chb_FTPUebertragen;

  Fedt_GDriveDir := getAdvEditBtn('edt_GoogleDrive');
  Fedt_GDriveDir.OnClickBtn := edt_DirGDriveClickBtn;
  Fchb_GDriveUebertragen := getCheckbox('cbx_GDriveUebertragen');
  Fchb_GDriveUebertragen.OnClick := Chb_GDriveUebertragen;

  fBtn_FP_Vorschlagen := gettbButton('btn_FP_Vorschlagen');
  fBtn_FP_Vorschlagen.OnClick := FP_VorschlagenClick;

  fBtn_GDrive_FPUebernehmen := gettbButton('btn_GDrive_FPUebernehmen');
  fBtn_GDrive_FPUebernehmen.OnClick := GDrive_FPUebernehmenClick;


  Fedt_FTPDir := getAdvDirectoryEdit('edt_ftpdir');
  Fedt_FTPDir.OnExit := FtpdirExit;

  fBaumButton := TBaumbutton.Create(nil);
  fBaumButton.Trans := fTrans;


  RegisterNotify;

end;

destructor Tof_SeiteEinstellung.Destroy;
begin
  FreeAndNil(FTrans);
  FreeAndNil(FSeiteverbinden);
  FreeAndNil(fBaumButton);
  UnregisterNotify;
  inherited;
end;

procedure Tof_SeiteEinstellung.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb]);
end;

procedure Tof_SeiteEinstellung.UnregisterNotify;
begin
  if SysObj <> nil then
    SysObj.ObServer.UnregisterNotifications(Self);
end;



procedure Tof_SeiteEinstellung.ObServerNotification(AType: TNotificationType;
  Action, Data: Integer);
begin
  if FMode <> sysobj.Akt.Modus then
    exit;
  if AType = ntobBearb then
  begin
    if (Action = NTA_BAUMEBENE_CHANGED) or (Action = NTA_BAUMZWEIG_CHANGED) then
    begin
      LadeSeite;
    end;
  end;
end;


procedure Tof_SeiteEinstellung.LadeSeite;
begin
  FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
  if (FSeiteverbinden.Id > 0) and (FSeiteverbinden.Seite.Id > 0)  then
  begin
    FDoExitbyChange := true;
    FDoExitbyPWClick := true;
    Fedt_Dir.Text := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
    Fedt_FTPDir.Text := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
    Fedt_GDriveDir.Text := SysObj.Einstellung.GoogleDrive.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADGDRIVE).AsString;
    Fchb_GDriveUebertragen.Checked := FSeiteverbinden.Seite.Feld(SE_GDRIVEUEBERTRAGEN).AsBoolean;
    FVerzeichnisMerken := Fedt_Dir.Text;
    Fchb_PW.Checked := FSeiteverbinden.Seite.Feld(SE_PW).AsString > '';
    Fchb_FTPUebertragen.Checked := FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean;
    FDoExitbyPWClick := false;
  end
  else
  begin
    Fedt_Dir.Text := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
    Fedt_FTPDir.Text := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
    FVerzeichnisMerken := Fedt_Dir.Text;
    Fchb_PW.Checked := FSeiteverbinden.Seite.Feld(SE_PW).AsString > '';
    Fchb_FTPUebertragen.Checked := SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean;
    sysobj.ObServer.Notify(ntobBearb, NTA_SEITE_SPEICHERN, Integer(FSeiteverbinden.Seite));
    FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
    Fedt_GDriveDir.Text := SysObj.Einstellung.GoogleDrive.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADGDRIVE).AsString;
    Fchb_GDriveUebertragen.Checked := SysObj.Einstellung.GoogleDrive.GDriveVerwenden.AsBoolean;
  end;

end;


procedure Tof_SeiteEinstellung.VisibleChanged(aValue: Boolean);
begin
  inherited;

end;


procedure Tof_SeiteEinstellung.edt_DirChange(Sender: TObject);
var
  s: string;
  Verz: string;
  SaveFile: string;
  SeiteDokumentList: TSeiteDokumentList;
  Dokument: TDokument;
  i1: Integer;
  SourceFilename: string;
  DestFilename: string;
  DokumentHauptPfad: string;
begin
  if FDoExitbyChange then
  begin
    FDoExitbyChange := false;
    exit;
  end;
  SaveFile := '';
  s := IncludeTrailingPathDelimiter(Fedt_Dir.Text);
  DokumentHauptpfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString);
  Verz := copy(s, 1, Length(DokumentHauptpfad));
  if SameText(DokumentHauptpfad, Verz) then
    SaveFile := copy(s, Length(DokumentHauptpfad), length(s))
  else
  begin
    if Pos(':', s) > 0 then
    begin
      MessageDlg('Dies ist kein gültiger Pfad' + sLineBreak +
                 'Bitte beachten Sie das es nicht erlaubt ist einen Pfad außerhalb des Dokumentenpfades zu wählen', mtInformation, [mbOk], 0);
      exit;
    end;
    SaveFile := s;
  end;


  if not DirectoryExists(Fedt_Dir.Text) then
  begin
    if MessageDlg('Das Verzeichnis'+ sLineBreak +
               '"' + Fedt_Dir.Text + '"' + sLineBreak +
               'existiert nicht.' + sLineBreak+
               'Möchten Sie dieses Verzeichnis anlegen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ForceDirectories(Fedt_Dir.Text)
    else
      exit;
  end;


  if SameText(IncludeTrailingPathDelimiter(Fedt_Dir.Text), IncludeTrailingPathDelimiter(FVerzeichnisMerken)) then
    exit;

  if (Trim(SaveFile) > '') and (SaveFile[Length(SaveFile)] = '\') then
    SaveFile := copy(SaveFile, 1, Length(SaveFile)-1);
  if (Trim(SaveFile) > '') and (SaveFile[1] = '\') then
    SaveFile := copy(SaveFile, 2, Length(SaveFile));


  SeiteDokumentList := TSeiteDokumentList.Create(nil);
  try
    FSeiteverbinden.Seite.Feld(SE_PFAD).AsString := SaveFile;
    FTrans.StartTransaction;
    try
      SeiteDokumentList.Trans := FTrans;
      SeiteDokumentList.ReadAll(FSeiteverbinden.Seite.Id);
      if SeiteDokumentList.Count > 0 then
      begin
        if MessageDlg('Sie möchten das Verzeichnis verändern.' + sLineBreak +
                   'Möchten Sie auch alle Dokumente in das neue Verzeichnis verschieben?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        begin
          for i1 := 0 to SeiteDokumentList.Count -1 do
          begin
            Dokument := SeiteDokumentList.Item[i1].Dokument;
            SourceFilename := Dokument.FullFilename;
            Dokument.Feld(DO_PFAD).AsString := SaveFile;
            Dokument.Save;
            DestFilename := Dokument.FullFilename;
            if FileExists(DestFilename) then
            begin
              if MessageDlg('Die Datei "' + ExtractFileName(DestFilename) + '"' +
                            'existiert schon im Zielverzeichnis.' + sLineBreak +
                            'Möchten Sie die Datei überschreiben?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
              begin
                DeleteFile(PChar(SourceFilename));
                continue;
              end
              else
                DeleteFile(PWideChar(DestFilename));
            end;
            if FileExists(SourceFilename) then
            begin
              CopyFile(PChar(SourceFilename), PChar(DestFilename), false);
              if FileExists(DestFilename) then
                DeleteFile(PChar(SourceFilename));
            end;
          end;
        end;
      end;
      FSeiteverbinden.Seite.Save;
    finally
      if FTrans.InTransaction then
        FTrans.Commit;
    end;
  finally
    FreeAndNil(SeiteDokumentList);
  end;

  SysObj.ObServer.Notify(ntobCoreData, NTA_TABELLE_SEITE, FSeiteverbinden.Seite.Id);


  //ShowMessage(SaveFile);
end;


procedure Tof_SeiteEinstellung.edt_DirEnter(Sender: TObject);
begin
  FVerzeichnisMerken := Fedt_Dir.Text;
end;

procedure Tof_SeiteEinstellung.edt_DirShowDirectoryDialog(Sender: TObject;
  var InitialPath: string);
begin
  FVerzeichnisMerken := Fedt_Dir.Text;
  if sysObj.Einstellung.DokumentPfad.AsString > '' then
    InitialPath := sysObj.Einstellung.DokumentPfad.AsString;
  if (Fedt_Dir.Text > '') and (DirectoryExists(Fedt_Dir.Text)) then
    InitialPath := Fedt_Dir.Text;
  FDoExitbyChange := false;
end;

procedure Tof_SeiteEinstellung.edt_DirGDriveShowDirectoryDialog(Sender: TObject;
  var InitialPath: string);
begin
  ShowMessage('Button wurde gedrückt');
  exit;
  FVerzeichnisMerken := Fedt_Dir.Text;
  if sysObj.Einstellung.DokumentPfad.AsString > '' then
    InitialPath := sysObj.Einstellung.DokumentPfad.AsString;
  if (Fedt_Dir.Text > '') and (DirectoryExists(Fedt_Dir.Text)) then
    InitialPath := Fedt_Dir.Text;
  FDoExitbyChange := false;
end;



procedure Tof_SeiteEinstellung.edt_DirValueValidate(Sender: TObject;
  Value: string; var IsValid: Boolean);
begin
  ShowMessage(Value);
end;

procedure Tof_SeiteEinstellung.FP_VorschlagenClick(Sender: TObject);
var
  IdList: TStringList;
  s: string;
  i1: Integer;
  Id: Integer;
  ButtonProp: TButtonProp;
  mDir: string;
begin //
  ButtonProp := TButtonProp.Create(nil);
  IdList := TStringList.Create;
  try
    ButtonProp.Trans := fTrans;
    fBaumButton.GetBaumStrukIdList(IdList, SysObj.Akt.BaumButtonEbene);
    s := '';
    for i1 := IdList.Count -1 downto 0 do
    begin
      id := StrToInt(IdList.Strings[i1]);
      if id = 0 then
        break;
      ButtonProp.Read(Id);
      if not ButtonProp.Found then
        continue;
      s := s + ButtonProp.Feld(BP_TEXT).AsString + '\';
    end;
    mDir := Fedt_Dir.Text;
    FDoExitbyChange := true;
    Fedt_Dir.Text := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + s;
    FDoExitbyChange := false;
    edt_DirChange(nil);
    if not DirectoryExists(Fedt_Dir.Text) then
      Fedt_Dir.Text := mDir;
  finally
    FreeAndNil(IdList);
    FreeAndNil(ButtonProp);
  end;
  //ShowMessage(IntToStr(FSeiteverbinden.Seite.Id));
end;

procedure Tof_SeiteEinstellung.FtpdirExit(Sender: TObject);
var
  s: string;
  Vgl1, Vgl2: string;
begin
  if FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString = Fedt_FTPDir.Text then
    exit;
  s := Fedt_FTPDir.Text;
  s := StringReplace(s, '\', '/', [rfReplaceAll]);

  if s = '' then
  begin
    FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString := '';
    FSeiteverbinden.Seite.Save;
    exit;
  end;
  if s[1] = '/' then
    s := copy(s, 2, Length(s));
  if s[Length(s)] <> '/' then
    s := s + '/';
  Vgl1 := SysObj.Einstellung.FTP.Pfad.AsString;
  Vgl2 := copy(s, 1, Length(Vgl1));
  if SameText(Vgl1, Vgl2) then
    s := copy(s,Length(Vgl1)+1, Length(s));
  FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString := s;
  Fedt_FTPDir.Text := SysObj.Einstellung.FTP.Pfad.AsString + s;
  FSeiteverbinden.Seite.Save;
end;

procedure Tof_SeiteEinstellung.GDrive_FPUebernehmenClick(Sender: TObject);
var
  FPPfad: string;
  s: string;
begin
  FPPfad := FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
  s := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString)+ FPPfad;
  if not sysObj.GDrive.FolderExist(s) then
  begin
    if MessageDlg('Das Verzeichnis'+ sLineBreak +
                  '"' + s + '"' + sLineBreak +
                  'existiert nicht.' + sLineBreak+
                  'Möchten Sie dieses Verzeichnis anlegen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then

      exit;
    sysObj.GDrive.ForceDirectories(s);
  end;
  Fedt_GDriveDir.Text := s;
  s := IncludeTrailingPathDelimiter(Fedt_GDriveDir.Text);
  s := copy(s, Length(IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString))+1, Length(s));
  FSeiteverbinden.Seite.Feld(SE_PFADGDRIVE).AsString := s;
  FSeiteverbinden.Seite.Save;


end;

procedure Tof_SeiteEinstellung.Chb_FTPUebertragen(Sender: TObject);
begin
  if FDoExitbyPWClick then
  begin
    FDoExitbyPWClick := false;
    exit;
  end;
  FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean := Fchb_FTPUebertragen.Checked;
  FSeiteverbinden.Seite.Save;
  sysobj.ObServer.Notify(ntobBearb, NTA_SEITE_SPEICHERN, Integer(FSeiteverbinden.Seite));
end;


procedure Tof_SeiteEinstellung.Chb_GDriveUebertragen(Sender: TObject);
begin
  if FDoExitbyPWClick then
  begin
    FDoExitbyPWClick := false;
    exit;
  end;
  FSeiteverbinden.Seite.Feld(SE_GDRIVEUEBERTRAGEN).AsBoolean := Fchb_GDriveUebertragen.Checked;
  FSeiteverbinden.Seite.Save;
  sysobj.ObServer.Notify(ntobBearb, NTA_SEITE_SPEICHERN, Integer(FSeiteverbinden.Seite));
end;


procedure Tof_SeiteEinstellung.Chb_PWClick(Sender: TObject);
var
  Form: Tfrm_Passwort_festlegen;
  FormPW: Tfrm_Passwort;
begin
  if FDoExitbyPWClick then
  begin
    FDoExitbyPWClick := false;
    exit;
  end;
  if Fchb_PW.Checked then
  begin
    Form := Tfrm_Passwort_festlegen.Create(Self);
    try
      Form.ShowModal;
      if Form.Passwort.PasswortOk then
      begin
        FSeiteverbinden.Seite.PW := Form.edt_PW.Text;
        FSeiteverbinden.Seite.Feld(SE_PW).AsString := SysObj.Verschluesseln(Form.edt_PW.Text, Form.edt_PW.Text);
        FSeiteverbinden.Seite.Save;
        sysobj.ObServer.Notify(ntobBearb, NTA_SEITE_SPEICHERN, Integer(FSeiteverbinden.Seite));
      end;
    finally
      FreeAndNil(Form);
    end;
  end
  else
  begin
    FormPW := Tfrm_Passwort.Create(Self);
    try
      FormPW.Passwort.CheckPasswort := FSeiteverbinden.Seite.Feld(SE_PW).AsString;
      FormPW.ShowModal;
      if FormPW.Passwort.PasswortOk then
      begin
        FSeiteverbinden.Seite.PW := FormPW.edt_PW.Text;
        FSeiteverbinden.Seite.Feld(SE_PW).AsString := '';
        FSeiteverbinden.Seite.Save;
        sysobj.ObServer.Notify(ntobBearb, NTA_SEITE_SPEICHERN, Integer(FSeiteverbinden.Seite));
      end
      else
      begin
        FDoExitbyPWClick := true;
        Fchb_PW.Checked := true;
      end;
    finally
      FreeAndNil(Form);
    end;
  end;
end;


procedure Tof_SeiteEinstellung.edt_DirGDriveClickBtn(Sender: TObject);
var
  Form: Tfrm_GDriveBaum;
  s: string;
begin
  Form := Tfrm_GDriveBaum.Create(nil);
  try
    Form.StartPfad := SysObj.Einstellung.GoogleDrive.Pfad.AsString;
    Form.ShowModal;
    if not Form.Cancel then
    begin
      Fedt_GDriveDir.Text := Form.AktFolder;
      s := IncludeTrailingPathDelimiter(Fedt_GDriveDir.Text);
      s := copy(s, Length(IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString))+1, Length(s));
      FSeiteverbinden.Seite.Feld(SE_PFADGDRIVE).AsString := s;
      FSeiteverbinden.Seite.Save;
    end;
  finally
    FreeAndNil(Form);
  end;
end;



end.
