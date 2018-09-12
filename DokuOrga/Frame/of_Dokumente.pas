unit of_Dokumente;

interface

{$WARN SYMBOL_PLATFORM OFF}

uses
  SysUtils, Classes, Forms, StdCtrls, Buttons, of_Base, c_Types,
  ExtCtrls, Dialogs, o_sysObj, Controls, obBusinessClasses, obServerClient,
  tbButton, Contnrs, IBDatabase, fr_Base, Menus, tbStringGrid, o_SeiteVerbinden,
  o_Dokument, o_SeiteDokument, o_SeiteDokumentList, Graphics, IdFTP, IdFTPList,
  fnt_Progress, IdComponent, o_seitedokumentlinklist, o_seitedokumentlink,
  System.UITypes, Vcl.ComCtrls, o_DragAndDropDataAdapter, DragDrop,
  DropTarget, DragDropFile, System.Types, DragDropGraphics, o_DokumentGridIconList,
  o_DokumentGridIcon;


type
  RCol = Record const
    Bild      : Integer = 0;
    Bez       : Integer = 1;
    Filename  : Integer = 2;
    Pfad      : Integer = 3;
    SpOrt     : Integer = 4;
  End;

type
  Tof_Dokumente = class(Tof_Base, IObServerClient)
  private
    FCol  : RCol;
    FTrans: TIBTransaction;
    FGrid: TtbStringGrid;
    FPop: TPopupMenu;
    FPopLink: TPopupMenu;
    FPopDokumentLink: TMenuItem;
    FPopBez: TMenuItem;
    FPopDelete: TMenuItem;
    FPopPerFTPUebertragen: TMenuItem;
    FPopAufFestplatteUebertragen: TMenuItem;
    FPopGDrive: TMenuItem;
    FSeiteverbinden: TSeiteverbinden;
    FDokument: TDokument;
    FSeiteDokument: TSeiteDokument;
    FSeiteDokumentList: TSeiteDokumentList;
    FSeiteDokumentLinkList: TSeiteDokumentLinkList;
    FSeiteDokumentLink: TSeiteDokumentLink;
    Fftp: TIdFTP;
    FAbgebrochen: Boolean;
    FProgress: Tfrm_Progress;
    FDoku_Save: Graphics.TIcon;
    FDoku_Inet: Graphics.TIcon;
    FDoku_Del: Graphics.TIcon;
    FDoku_SaveInet: Graphics.TIcon;
    FDoku_SIC: Graphics.TIcon;
    FDoku_Cloud: Graphics.TIcon;
    FDoku_SI: Graphics.TIcon;
    FDoku_SC: Graphics.TIcon;
    fPg: TProgressbar;
    fDropFileTarget: TDropFileTarget;
    fDragAndDropAdapter: TDragAndDropDataAdapter;
    fDataFormatAdapterTarget: TDataFormatAdapter;
    fDokumentGridIconList: TDokumentGridIconList;
    procedure ObServerNotification(AType: TNotificationType; Action, Data: Integer);
    procedure ShowFileDialog;
    procedure LadeDokumente(const aId: Integer = -1);
    procedure DeleteDokument;
    procedure DeleteDok(Sender: TObject);
    procedure PopBez(Sender: TObject);
    procedure PopPerFTPUebertragen(Sender: TObject);
    procedure PopAufFestplatteUebertragen(Sender: TObject);
    procedure PopDokumentVerbinden(Sender: TObject);
    procedure ShowDialogBezeichnung;
    procedure DoIcon(Sender: TObject; ACol, ARow: Longint; var aIcon: Graphics.TIcon);
    procedure GridDblClick(Sender: TObject);
    procedure KopiereDokumentAufFestplatte(Sender: TObject);
    procedure GridExit(Sender: TObject);
    procedure DokPerFTPUebertragen;
    function GDriveDokToFestplatte(aDokument: TDokument): Boolean;
    function KopiereGDriveToFestplatte(aDokument: TDokument; aZielverzeichnis: string): Boolean;
    procedure DokToGDrive(Sender: TObject);
    procedure Kopiere_Dok_Von_FP_Nach_GDrive(aDokument: TDokument);
    procedure ShowProgress;
    procedure FTPWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: Int64);
    procedure FTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode; AWorkCountMax: Int64);
    procedure FTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    function  FTPDokToFestplatte(aDok: TDokument): Boolean;
    function  FTPFileExist(aFilename: string): Boolean;
    procedure RegisterNotify;
    procedure UnregisterNotify;
    procedure CheckDokumente;
    procedure GDriveUploadProgress(Sender: TObject; FileName: string; Position, Total: Int64);
    procedure DokumenteRowChanged(Sender: TObject);
    procedure DropFileTargetDrop(Sender: TObject; ShiftState: TShiftState; APoint: TPoint; var Effect: Integer);
    procedure DoDeleteDokument(aDokument: TDokument; aFrageCloudLoeschen, aFrageFPLoeschen, aFrageFTPLoeschen, aFrageLinkLoeschen, aFrageEintragLoeschen: Integer);
    procedure BevorePopup(Sender: TObject);
  protected
  public
    constructor Create(AOwner: TComponent; AMode: TModus); override;
    destructor Destroy; override;
    procedure VisibleChanged(aValue: Boolean); override;
  end;


implementation


{ Tof_Dokumente }

uses
  Vcl.Grids, Winapi.Windows, c_DBTypes, fnt_DialogDokumentBez, o_fileicon,
  ShellApi, IdReplyRFC, idFTPCommon;



constructor Tof_Dokumente.Create(AOwner: TComponent; AMode: TModus);
begin
  inherited Create(AOwner, AMode);
  FProgress := nil;
  FSeiteverbinden := TSeiteverbinden.Create(Self);
  FDokument := TDokument.Create(Self);
  FSeiteDokumentList := TSeiteDokumentList.Create(Self);
  FSeiteDokument := TSeiteDokument.Create(Self);
  FSeiteDokumentLinkList := TSeiteDokumentLinkList.Create(nil);
  FSeiteDokumentLink     := TSeiteDokumentLink.Create(nil);

  FDoku_Save := Graphics.TIcon.Create;
  FDoku_Inet := Graphics.TIcon.Create;
  FDoku_Del := Graphics.TIcon.Create;
  FDoku_SaveInet := Graphics.TIcon.Create;
  FDoku_SIC := Graphics.TIcon.Create;
  FDoku_Cloud := Graphics.TIcon.Create;
  FDoku_SI := Graphics.TIcon.Create;
  FDoku_SC := Graphics.TIcon.Create;

  FDoku_Save.Width := 16;
  FDoku_Save.Height := 16;
  FDoku_Del.Height := 16;
  FDoku_Del.Width := 16;
  FDoku_SaveInet.Height := 16;
  FDoku_SaveInet.Width := 16;
  FDoku_Inet.Height := 16;
  FDoku_Inet.Width := 16;
  FDoku_SIC.Width := 48;
  FDoku_Sic.Height := 16;
  FDoku_Cloud.Height := 16;
  FDoku_Cloud.Width  := 16;
  FDoku_SC.Height := 16;
  FDoku_SC.Width  := 32;
  FDoku_SI.Height := 16;
  FDoku_SI.Width  := 32;


  fDokumentGridIconList := TDokumentGridIconList.Create(nil);


  SysObj.LoadIconFromRes('RT_RCDATA', 'docs', FDoku_Save);
  SysObj.LoadIconFromRes('RT_RCDATA', 'doci', FDoku_Inet);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docudel', FDoku_Del);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docsaveinet', FDoku_SaveInet);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docsic', FDoku_Sic);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docc', FDoku_Cloud);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docsi', FDoku_SI);
  SysObj.LoadIconFromRes('RT_RCDATA', 'docsc', FDoku_SC);


  FTrans := TIBTransaction.Create(Self);
  FTrans.DefaultDatabase := SysObj.Database;
  FTrans.Name := 'of_Dokumente';
  Fftp  := TIdFTP.Create(nil);
  fftp.Passive := true;
  fftp.TransferType := ftBinary;
  FGrid := gettbStringGrid('grd_Dokumente');
  FGrid.FixedCols := 0;
  FGrid.ColCount := 5;
  FGrid.Clear;
  FGrid.AddColList('Bild');
  FGrid.AddColList('Bez');
  FGrid.AddColList('Filename');
  FGrid.AddColList('Verzeichnis');
  FGrid.AddColList('Speicherort');
  FGrid.AddColList('SpOrt');
  FGrid.Cells[FCol.Bild, 0] := 'Icon';
  FGrid.Cells[FCol.Bez, 0] := 'Bezeichnung';
  FGrid.Cells[FCol.Filename, 0] := 'Dateiname';
  FGrid.Cells[FCol.Pfad, 0] := 'Verzeichnis';
  FGrid.Cells[FCol.SpOrt, 0] := '';
  FGrid.RowCount := 2;
  FGrid.Options := FGrid.Options + [goRowSelect];
  if not FileExists(SysObj.IniGridFilename) then
  begin
    FGrid.ColWidths[FCol.Bild] := 30;
    FGrid.ColWidths[FCol.Bez] := 200;
    FGrid.ColWidths[FCol.Filename] := 200;
    FGrid.ColWidths[FCol.Pfad] := 200;
    FGrid.ColWidths[FCol.SPOrt] := 30;
  end
  else
  begin
    FGrid.LoadGridSpaltenbreite(SysObj.IniGridFilename);
  end;
  FGrid.OnGetIcon := DoIcon;
  FGrid.OnDblClick := GridDblClick;
  FGrid.OnExit := GridExit;
  FGrid.OnRowChanged := DokumenteRowChanged;

  FPopLink := getPopupMenu('pop_link');
  FPopDokumentLink := FPopLink.Items[0];
  FPopDokumentLink.OnClick := PopDokumentVerbinden;

  FPop := getPopUpMenu('pop');
  FPop.OnPopup := BevorePopup;
  RegisterNotify;
  FGrid.PopupMenu := FPop;
  FPopBez := FPop.Items[0];
  FPopBez.OnClick := PopBez;
  FPopPerFTPUebertragen := FPop.Items[2];
  FPopPerFTPUebertragen.OnClick := PopPerFTPUebertragen;
  FPopDelete := FPop.Items[9];
  FPopDelete.OnClick := DeleteDok;

  FPopDelete := FPop.Items[7];
  FPopDelete.OnClick := KopiereDokumentAufFestplatte;


  FPopAufFestplatteUebertragen := FPop.Items[3];
  FPopAufFestplatteUebertragen.OnClick := PopAufFestplatteUebertragen;

  FPopGDrive := FPop.Items[5];
  FPopGDrive.OnClick := DokToGDrive;


  Fftp.Host     := SysObj.Einstellung.FTP.Host.AsString;
  Fftp.Username := SysObj.Einstellung.FTP.Username.AsString;
  Fftp.Password := SysObj.Einstellung.FTP.Passwort.AsString;
  Fftp.OnWork   := FTPWork;
  Fftp.OnWorkBegin := FTPWorkBegin;
  Fftp.OnWorkEnd   := FTPWorkEnd;

  if AMode = cNormal then
    FGrid.PopupMenu := FPop;

  if AMode = cLink then
    FGrid.PopupMenu := FPopLink;
  //     := SysObj.Einstellung.FTP.Pfad.AsString;

  fPg := getProgressbar('pg');

  fDragAndDropAdapter := TDragAndDropDataAdapter.Create;
  fDropFileTarget := getDropFileTarget('DropFileTarget');
  fDataFormatAdapterTarget := getDataFormatAdapter('DataFormatAdapterTarget');
  fDropFileTarget.Target := FGrid;
  fDropFileTarget.OnDrop := DropFileTargetDrop;
  fDragAndDropAdapter := TDragAndDropDataAdapter.Create;

  fDataFormatAdapterTarget.DragDropComponent := fDropFileTarget;
  //fDataFormatAdapterTarget.DataFormatName := TVirtualFileStreamDataFormat;


  fDataFormatAdapterTarget.Enabled := true;




end;


destructor Tof_Dokumente.Destroy;
begin
  FreeAndNil(Fftp);
  FreeAndNil(FDokument);
  FreeAndNil(FSeiteDokument);
  FreeAndNil(FSeiteDokumentList);
  FreeAndNil(FSeiteverbinden);
  FreeAndNil(FSeiteDokumentLinkList);
  FreeAndNil(FSeiteDokumentLink);
  FreeAndNil(FTrans);
  FreeAndNil(FDoku_Save);
  FreeAndNil(FDoku_Inet);
  FreeAndNil(FDoku_Del);
  FreeAndNil(FDoku_SaveInet);
  FreeAndNil(FDoku_SIC);
  FreeAndNil(FDoku_Cloud);
  FreeAndNil(FDoku_SC);
  FreeAndNil(FDoku_SI);
  FreeAndNil(fDragAndDropAdapter);
  FreeAndNil(fDokumentGridIconList);

  if FProgress <> nil then
    FreeAndNil(FProgress);
  UnregisterNotify;
  inherited;
end;


procedure Tof_Dokumente.RegisterNotify;
begin
  SysObj.ObServer.RegisterNotifications(Self, [ntobBearb, ntobCoreData]);
end;


procedure Tof_Dokumente.UnregisterNotify;
begin
  if sysObj <> nil then
    sysobj.ObServer.UnregisterNotifications(Self);
end;

procedure Tof_Dokumente.DoIcon(Sender: TObject; ACol, ARow: Integer;
  var aIcon: Graphics.TIcon);
var
  Ext: string;
  FileIcon: TtbFileIcon;
  Dokument: TDokument;
  Pfad: string;
  Filename: string;
  DokumentGridIcon: TDokumentGridIcon;
begin
  aIcon := nil;
  if (ARow > 0) and (ACol = FCol.Bild) then
  begin
    Ext := ExtractFileExt(FGrid.Cells[FCol.Filename, ARow]);
    FileIcon := SysObj.FileIconList.FileIcon(Ext);
    if FileIcon <> nil then
      aIcon := FileIcon.Icon;
  end;

  if (ARow > 0) and (ACol = FCol.SpOrt) then
  begin
    aIcon := FDoku_Del;
    Dokument := TDokument(FGrid.Obj['Bild', ARow]);
    if Dokument <> nil then
    begin
      DokumentGridIcon := TDokumentGridIcon(FGrid.Obj['SpOrt', ARow]);
      if DokumentGridIcon <> nil then
        aIcon := DokumentGridIcon.Icon;


      (*
      Pfad := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Dokument.Feld(DO_PFAD).AsString);
      Filename := Pfad + Dokument.Feld(DO_DATEINAME).AsString;
      if FileExists(Filename) then
      begin
        aIcon := fDokumentGridIconList.getIcon(true, Dokument.Feld(DO_SAVE_FTP).AsBoolean, Dokument.Feld(DO_SAVE_CLOUD).AsBoolean,
                                               false);
        {
        aIcon := FDoku_Save;
        if Dokument.Feld(DO_SAVE_FTP).AsBoolean then
          aIcon := FDoku_SI;
        if Dokument.Feld(DO_SAVE_CLOUD).AsBoolean then
          aIcon := FDoku_SC;
        if (Dokument.Feld(DO_SAVE_CLOUD).AsBoolean) and (Dokument.Feld(DO_SAVE_FTP).AsBoolean) then
          aIcon := FDoku_SIC;
          }
      end
      else
      begin
        if Dokument.Feld(DO_SAVE_FTP).AsBoolean then
          aIcon := FDoku_Inet;
        if (Dokument.Feld(DO_SAVE_CLOUD).AsBoolean) then
          aIcon := FDoku_Cloud;
        if (Dokument.Feld(DO_SAVE_CLOUD).AsBoolean) and (Dokument.Feld(DO_SAVE_FTP).AsBoolean) then
          aIcon := FDoku_Cloud;
      end;
      *)
    end;
  end;

end;

procedure Tof_Dokumente.GridExit(Sender: TObject);
begin
  FGrid.SaveGridSpaltenbreite(SysObj.IniGridFilename);
end;

procedure Tof_Dokumente.GridDblClick(Sender: TObject);
var
  Dokument: TDokument;
  //Cur: TCursor;
begin
  //Cur := Screen.Cursor;
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  if FileExists(Dokument.FullFilename) then
  begin
    ShellExecute(0, 'open', PChar(Dokument.FullFilename), '', '', SW_SHOWNORMAL);
    exit;
  end;
  if (Dokument.Feld(DO_SAVE_FTP).AsBoolean) and (not FTPDokToFestplatte(Dokument)) then
  begin
    ShowMessage('Datei existiert nicht.');
    exit;
  end;
  if (Dokument.Feld(DO_SAVE_CLOUD).AsBoolean) and (not GDriveDokToFestplatte(Dokument)) then
  begin
   if MessageDlg('Das Dokument scheint nicht mehr in der Cloud zu sein.' + sLineBreak +
                'Möchten Sie jetzt den Verweis auf die Cloud entfernen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     Dokument.Feld(DO_SAVE_CLOUD).AsBoolean := false;
    exit;
  end;

end;

procedure Tof_Dokumente.KopiereDokumentAufFestplatte(Sender: TObject);
var
  Dokument: TDokument;
  Pfad: string;
begin
//  Pfad := SysObj.Einstellung.DokumentPfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
  Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString);
  if FSeiteverbinden.Seite.Feld(SE_PFAD).AsString > '' then
    Pfad := Pfad + IncludeTrailingPathDelimiter(FSeiteverbinden.Seite.Feld(SE_PFAD).AsString);

  if not DirectoryExists(Pfad) then
  begin
    if MessageDlg('Das Verzeichnis'+ sLineBreak +
               '"' + Pfad + '"' + sLineBreak +
               'existiert nicht.' + sLineBreak+
               'Möchten Sie dieses Verzeichnis anlegen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      ForceDirectories(Pfad)
    else
      exit;
  end;


  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  FSeiteDokumentLink.Read(FSeiteverbinden.Seite.Id, Dokument.Id);
  if FSeiteDokumentLink.Found then
  begin
    Pfad := FSeiteDokumentLink.Dokument.Pfad;
  end;
  if (Dokument.Feld(DO_SAVE_FTP).AsBoolean) and (not FTPDokToFestplatte(Dokument)) then
  begin
    ShowMessage('Datei existiert nicht.');
    exit;
  end;
  if (Dokument.Feld(DO_SAVE_CLOUD).AsBoolean) and (not KopiereGDriveToFestplatte(Dokument, Pfad)) then
  begin
   if MessageDlg('Das Dokument scheint nicht mehr in der Cloud zu sein.' + sLineBreak +
                'Möchten Sie jetzt den Verweis auf die Cloud entfernen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
     Dokument.Feld(DO_SAVE_CLOUD).AsBoolean := false;
    exit;
  end;

end;


procedure Tof_Dokumente.LadeDokumente(const aId: Integer = -1);
var
  i1: Integer;
  Dokument: TDokument;
  Row: Integer;
  LinkZaehler: Integer;
  iRow: Integer;
  iRowCount: Integer;
  iZaehler: Integer;
  DokumentGridIcon: TDokumentGridIcon;
  Pfad: string;
  Filename: string;
begin
  Row := -1;
  FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
  FSeiteDokumentList.Init;
  FSeiteDokumentList.ReadAll(FSeiteverbinden.Seite.Id);
  FGrid.Clear;
  for i1 := 0 to FSeiteDokumentList.Count -1 do
  begin
    Dokument := FSeiteDokumentList.Item[i1].Dokument;
    if Dokument = nil then
      continue;
    Pfad := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Dokument.Feld(DO_PFAD).AsString);
    Filename := Pfad + Dokument.Feld(DO_DATEINAME).AsString;
    if FileExists(Filename) then
      DokumentGridIcon := fDokumentGridIconList.getDokumentGridIcon(true, Dokument.Feld(DO_SAVE_FTP).AsBoolean, Dokument.Feld(DO_SAVE_CLOUD).AsBoolean, false)
    else
      DokumentGridIcon := fDokumentGridIconList.getDokumentGridIcon(false, Dokument.Feld(DO_SAVE_FTP).AsBoolean, Dokument.Feld(DO_SAVE_CLOUD).AsBoolean, false);
    FGrid.Cells[FCol.Bez, i1+1] := Dokument.Feld(DO_BEZ).AsString;
    FGrid.Cells[FCol.Filename, i1+1] := Dokument.Feld(DO_DATEINAME).AsString;
    FGrid.Cells[FCol.Pfad, i1+1]     := Dokument.Pfad;
    FGrid.Obj['Bild', i1+1] := Dokument;
    FGrid.Obj['SpOrt', i1+1] := DokumentGridIcon;
    if aId = Dokument.Id then
      Row := i1+1;
  end;
  if FSeiteDokumentList.Count < 1 then
    iRowCount := 1
  else
    iRowCount := FSeiteDokumentList.Count + 1;

  LinkZaehler := 0;
  FSeiteDokumentLinkList.Init;
  FSeiteDokumentLinkList.ReadAll(FSeiteverbinden.Seite.Id);
  iZaehler := -1;
  for i1 := 0 to FSeiteDokumentLinkList.Count -1 do
  begin
    if not FSeiteDokumentLinkList.Item[i1].Feld(SK_VERLINKT).AsBoolean then
      continue;
    Dokument := FSeiteDokumentLinkList.Item[i1].Dokument;
    if Dokument = nil then
      continue;
    Pfad := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Dokument.Feld(DO_PFAD).AsString);
    Filename := Pfad + Dokument.Feld(DO_DATEINAME).AsString;
    if FileExists(Filename) then
      DokumentGridIcon := fDokumentGridIconList.getDokumentGridIcon(true, Dokument.Feld(DO_SAVE_FTP).AsBoolean, Dokument.Feld(DO_SAVE_CLOUD).AsBoolean, true)
    else
      DokumentGridIcon := fDokumentGridIconList.getDokumentGridIcon(false, Dokument.Feld(DO_SAVE_FTP).AsBoolean, Dokument.Feld(DO_SAVE_CLOUD).AsBoolean, true);
    Inc(iZaehler);
    iRow := iRowCount + iZaehler;
    FGrid.Cells[FCol.Bez, iRow] := Dokument.Feld(DO_BEZ).AsString;
    FGrid.Cells[FCol.Filename, iRow] := Dokument.Feld(DO_DATEINAME).AsString;
    FGrid.Cells[FCol.Pfad, iRow]     := Dokument.Pfad;
    FGrid.Obj['Bild', iRow] := Dokument;
    FGrid.Obj['SpOrt', iRow] := DokumentGridIcon;
    if aId = Dokument.Id then
      Row := iZaehler+1;
    inc(LinkZaehler);
  end;

  if FSeiteDokumentList.Count + LinkZaehler <= 1 then
    FGrid.RowCount := 2
  else
    FGrid.RowCount := FSeiteDokumentList.Count + 1 + LinkZaehler;

  if Row > -1 then
    FGrid.GotoRow(Row);

  if FGrid.Row = 0 then
    FGrid.GotoRow(1);

end;

procedure Tof_Dokumente.ObServerNotification(AType: TNotificationType; Action,
  Data: Integer);
var
  cur: TCursor;
//  Dokument : TDokument;
begin
  Cur := Screen.Cursor;
  try
    if FMode <> sysobj.Akt.Modus then
      exit;
    if AType = ntobBearb then
    begin
      if (Action = NTA_BAUMEBENE_CHANGED) or (Action = NTA_BAUMZWEIG_CHANGED) then
      begin
        FGrid.SaveGridSpaltenbreite(SysObj.IniGridFilename);
      end;
      if (Action = NTA_FILEOPENDIALOG) then
      begin
        ShowFileDialog;
      end;
      if (Action = NTA_DELETEPOS) then
      begin
        DeleteDokument;
      end;
      if (Action = NTA_DOKUMENTREFRESH) then
      begin
        //Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
        Screen.Cursor := crHourGlass;
        CheckDokumente;
        {
        if Dokument = nil then
          LadeDokumente
        else
          LadeDokumente(Dokument.Id);
          }
      end;
      if (Action = NTA_BAUMEBENE_CHANGED) or (Action = NTA_BAUMZWEIG_CHANGED) then
      begin
        LadeDokumente;
      end;
      if (Action = NTA_LINK_ADD_DOK_DO) then
      begin
        PopDokumentVerbinden(nil);
      end;
      if (Action = NTA_LINK_DEL_DOK_DO) then
      begin
        ShowMessage('Dokumentverbindung entfernen');
      end;
    end;
    if AType = ntobCoreData then
    begin
      if (Action = NTA_TABELLE_SEITE) then
        LadeDokumente;
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;


procedure Tof_Dokumente.PopAufFestplatteUebertragen(Sender: TObject);
begin
  ShowMessage('Auf Festplatte');
end;

procedure Tof_Dokumente.PopBez(Sender: TObject);
begin
  ShowDialogBezeichnung;
end;


procedure Tof_Dokumente.PopDokumentVerbinden(Sender: TObject);
var
  Dokument : TDokument;
begin
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  SysObj.ObServer.Notify(ntobBearb, NTA_LINK_ADD_DOK, Dokument.Id);
end;

procedure Tof_Dokumente.PopPerFTPUebertragen(Sender: TObject);
begin
  DokPerFTPUebertragen;
end;



function Tof_Dokumente.FTPDokToFestplatte(aDok: TDokument): Boolean;
var
  FTPPfad: string;
  QuellFilename: string;
  ZielFilename: string;
  CurrentDir: string;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Result := false;
    Screen.Cursor := crHourGlass;
    if not SysObj.FTPAktiv then
      exit;

    FTPPfad := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
    if FTPPfad[1] <> '/' then
      FTPPfad := '/' + FTPPfad;
    QuellFilename := FTPPfad + aDok.Feld(DO_DATEINAME).AsString;
    ZielFilename := SysObj.TempPath + aDok.Feld(DO_DATEINAME).AsString;
    if FileExists(ZielFilename) then
    begin
      ShellExecute(0, 'open', PChar(ZielFilename), '', '', SW_SHOWNORMAL);
      Result := true;
      exit;
    end;
    if not fftp.Connected then
      fftp.Connect;
    if not fftp.Connected then
    begin
      MessageDlg('FTP-Verbindung konnte nicht hergestellt werden.', mtError, [mbOk], 0);
      Result := true;
      exit;
    end;
    try
      CurrentDir := fftp.RetrieveCurrentDir;
      if not (SameText(CurrentDir, FTPPfad)) then
        fftp.ChangeDir(FTPPfad);
      if not FTPFileExist(aDok.Feld(DO_DATEINAME).AsString) then
      begin
        exit;
      end;
    except
      on e: EIdReplyRFCError do
      begin
        if (e.ErrorCode = 550) then
        begin
          Result := true;
          MessageDlg('Pfad "' + FTPPfad + '" exisitiert nicht.', mtInformation, [mbOk], 0);
          fftp.Disconnect;
          exit;
        end
        else
        begin
          //Result := true;
          fftp.Disconnect;
          raise;
          exit;
        end;
      end;
    end;
    ShowProgress;
    try
      fftp.Get(QuellFilename, ZielFilename);
      fftp.Disconnect;
      if FileExists(ZielFilename) then
      begin
        ShellExecute(0, 'open', PChar(ZielFilename), '', '', SW_SHOWNORMAL);
        Result := true;
        exit;
      end;
    finally
      FreeAndNil(FProgress);
    end;
  finally
    Screen.Cursor := Cur;
  end;
end;

function Tof_Dokumente.FTPFileExist(aFilename: string): Boolean;
var
  List: TStringList;
  List2: TStringList;
  FileList: TStringList;
  i1: Integer;
begin
  Result := false;
  List := TStringList.Create;
  List2 := TStringList.Create;
  FileLIst := TStringList.Create;
  try
    List2.Delimiter := ';';
    List2.StrictDelimiter := true;
    FFtp.List(List, '', false);
    for i1 := 0 to List.Count -1 do
    begin
      FileList.Add(Trim(List.Strings[i1]));
    end;
    {
    for i1 := 0 to Fftp.DirectoryListing.Count -1 do
    begin
      FileList.Add(Trim(Fftp.DirectoryListing.Items[i1].FileName));
    end;
    }
    for i1 := 0 to FileList.Count -1 do
    begin
      if SameText(aFilename, FileList.Strings[i1]) then
      begin
        Result := true;
        exit;
      end;
    end;
    {
    Fftp.ExtListDir(List);
    for i1 := 0 to List.Count -1 do
    begin
      List2.DelimitedText := List.Strings[i1];
      FileList.Add(Trim(List2.Strings[List2.Count-1]));
    end;
    for i1 := 0 to FileList.Count -1 do
    begin
      if SameText(aFilename, FileList.Strings[i1]) then
      begin
        Result := true;
        exit;
      end;
    end;
    }
  finally
    FreeAndNil(List);
    FreeAndNil(List2);
    FreeAndNil(FileList);
  end;
end;

procedure Tof_Dokumente.DokPerFTPUebertragen;
var
  FTPPfad: string;
  Dokument: TDokument;
  QuellPfad: string;
  QuellFilename: string;
  ZielFilename: string;
  CurrentDir: string;
begin
  if Trim(SysObj.Einstellung.FTP.Pfad.AsString) = '' then
  begin
    ShowMessage('Es wurde kein FTP-Hauptverzeichnis angelegt' + sLineBreak +
                'Bitte legen Sie zuerst in den Einstellungen ein Verzeichnis an' + sLineBreak +
                'und überprüfen Sie die FTP-Verbindung');
    exit;
  end;
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  FTPPfad := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
  if FTPPfad[1] <> '/' then
    FTPPfad := '/' + FTPPfad;
  QuellPfad := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Dokument.Feld(DO_PFAD).AsString);
  QuellFilename := QuellPfad + Dokument.Feld(DO_DATEINAME).AsString;
  ZielFilename := FTPPfad + Dokument.Feld(DO_DATEINAME).AsString;
  //fftp.Passive := true;
  if not fftp.Connected then
    fftp.Connect;
  if not fftp.Connected then
  begin
    MessageDlg('FTP-Verbindung konnte nicht hergestellt werden.', mtError, [mbOk], 0);
    exit;
  end;
  try
    CurrentDir := fftp.RetrieveCurrentDir;
    if not (SameText(CurrentDir, FTPPfad)) then
      fftp.ChangeDir(FTPPfad);
  except
    on e: EIdReplyRFCError do
    begin
      if (e.ErrorCode = 550) then
      begin
        if MessageDlg('Pfad "' + FTPPfad + '" exisitiert nicht.' + sLineBreak +
                   'Möchten Sie den Pfad jezt anlegen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          exit;
        fftp.MakeDir(FTPPfad);
      end
      else
      begin
        fftp.Disconnect;
        raise;
        exit;
      end;
    end;
  end;
  ShowProgress;
  try
    fftp.Put(QuellFilename, ZielFilename);
    //fftp.Put(QuellFilename, Dokument.Feld(DO_DATEINAME).AsString);
    fftp.Disconnect;
    Dokument.Feld(DO_SAVE_FTP).AsBoolean := true;
    Dokument.Save;
  finally
    FreeAndNil(FProgress);
  end;
end;


function Tof_Dokumente.GDriveDokToFestplatte(aDokument: TDokument): Boolean;
var
  Pfad: string;
  GDriveFullFilename: string;
  ZielFilename: string;
  Cur: TCursor;
begin
  Result := false;
  Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString);
  if aDokument.Feld(DO_PFADGDRIVE).AsString > '' then
    Pfad := Pfad + IncludeTrailingPathDelimiter(aDokument.Feld(DO_PFADGDRIVE).AsString);
  GDriveFullFilename := Pfad + aDokument.Feld(DO_DATEINAME).AsString;
  ZielFilename := SysObj.TempPath + aDokument.Feld(DO_DATEINAME).AsString;
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    SysObj.GDrive.Progressbar := fPg;
    SysObj.GDrive.DownloadFile(GDriveFullFilename, ZielFilename);
    fPg.Position := 0;
  finally
     Screen.Cursor := Cur;
  end;
  if FileExists(ZielFilename) then
  begin
    Result := true;
    ShellExecute(0, 'open', PChar(ZielFilename), '', '', SW_SHOWNORMAL);
  end;
end;


function Tof_Dokumente.KopiereGDriveToFestplatte(aDokument: TDokument; aZielverzeichnis: string): Boolean;
var
  Pfad: string;
  GDriveFullFilename: string;
  ZielFilename: string;
  Cur: TCursor;
begin
  Result := false;
  if not DirectoryExists(aZielverzeichnis) then
  begin
    ShowMessage('Das Zielverzeichnis "' + aZielverzeichnis + '" exisitiert nicht.');
    if MessageDlg('Soll das Zielverzeichnis angelegt werden?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
      exit;
    ForceDirectories(aZielverzeichnis);
  end;
  Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString);
  if aDokument.Feld(DO_PFADGDRIVE).AsString > '' then
    Pfad := Pfad + IncludeTrailingPathDelimiter(aDokument.Feld(DO_PFADGDRIVE).AsString);
  GDriveFullFilename := Pfad + aDokument.Feld(DO_DATEINAME).AsString;
  ZielFilename := aZielverzeichnis + aDokument.Feld(DO_DATEINAME).AsString;
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    SysObj.GDrive.Progressbar := fPg;
    SysObj.GDrive.DownloadFile(GDriveFullFilename, ZielFilename);
    fPg.Position := 0;
  finally
     Screen.Cursor := Cur;
  end;
  if FileExists(ZielFilename) then
  begin
    Pfad := copy(aZielverzeichnis, Length(SysObj.Einstellung.DokumentPfad.AsString)+1, Length(aZielverzeichnis));
    if (Length(Pfad) = 1) and (Pfad[1] = '\') then
      Pfad := '';
    if (Pfad > '') and (Pfad[length(Pfad)] = '\') then
      Pfad := copy(Pfad, 1, Length(Pfad)-1);

    aDokument.Feld(DO_PFAD).AsString := Pfad;
    aDokument.Save;
    FGrid.Refresh;
    Result := true;
  end;
end;


procedure Tof_Dokumente.DokToGDrive(Sender: TObject);
var
  Dokument: TDokument;
  QuellPfad: string;
  ZielPfad: string;
  QuellFilename: string;
  ZielFilename: string;
  Cur: TCursor;
begin  //
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  Kopiere_Dok_Von_FP_Nach_GDrive(Dokument);
end;

procedure Tof_Dokumente.Kopiere_Dok_Von_FP_Nach_GDrive(aDokument: TDokument);
var
  QuellPfad: string;
  ZielPfad: string;
  QuellFilename: string;
  ZielFilename: string;
  Cur: TCursor;
begin
  if aDokument = nil then
    exit;
  QuellPfad := IncludeTrailingPathDelimiter(IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + aDokument.Feld(DO_PFAD).AsString);
  QuellFilename := QuellPfad + aDokument.Feld(DO_DATEINAME).AsString;

  if not FileExists(QuellFileName) then
  begin
    MessageDlg('Quelldatei "' + QuellFileName + '" existiert nicht.', mtError, [mbOk],0);
    exit;
  end;

  ZielPfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString) +
              IncludeTrailingPathDelimiter(FSeiteverbinden.Seite.Feld(SE_PFADGDRIVE).AsString);
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    SysObj.GDrive.Progressbar := fPg;
    SysObj.GDrive.UploadFile(QuellFilename, ZielPfad);
    aDokument.Feld(DO_SAVE_CLOUD).AsBoolean := true;
    aDokument.Feld(DO_PFADGDRIVE).AsString := IncludeTrailingPathDelimiter(FSeiteverbinden.Seite.Feld(SE_PFADGDRIVE).AsString);
    aDokument.Save;
    fpg.Position := 0;
  finally
    Screen.Cursor := Cur;
  end;
end;


procedure Tof_Dokumente.DokumenteRowChanged(Sender: TObject);
var
  Dokument: TDokument;
begin //
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  SysObj.ObServer.Notify(ntobCoreData, NTA_DOKU_ROW_CHANGED, Integer(Dokument));
end;

procedure Tof_Dokumente.ShowDialogBezeichnung;
var
  Form: Tfrm_DialogDokumentBez;
  Dokument: TDokument;
  Dateiname: string;
  FullFilename: string;
begin
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  Form := Tfrm_DialogDokumentBez.Create(Self);
  try
    Form.edt_Bez.Text := Dokument.Feld(DO_BEZ).AsString;
    Form.edt_Dateiname.Text := Dokument.Feld(DO_DATEINAME).AsString;
    Dateiname := Dokument.Feld(DO_DATEINAME).AsString;
    FullFileName := Dokument.FullFilename;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    Dokument.Feld(DO_BEZ).AsString := Form.edt_Bez.Text;
    Dokument.Save;

    if not SameText(Dateiname, Form.edt_Dateiname.Text) then
    begin
      Dokument.Feld(DO_DATEINAME).AsString := Form.edt_Dateiname.Text;
      Dokument.Save;
      if FileExists(FullFilename) then
        RenameFile(FullFilename, Dokument.FullFilename);
    end;


    LadeDokumente(Dokument.Id);
  finally
    FreeAndNil(Form);
  end;
end;

procedure Tof_Dokumente.ShowFileDialog;
var
  Dialog: TFileOpenDialog;
  Zielverzeichnis: string;
  FullFilename: string;
  Dateiname: string;
  OriDateiname: string;
  Pfad: string;
  Bez: string;
  Ext: string;
  SeitePfad: string;
  Hauptpfad: string;
begin
  Dialog := TFileOpenDialog.Create(Self);
  try
    if not Dialog.Execute then
      exit;
    FSeiteverbinden.Read(SysObj.Akt.BaumButtonEbene, SysObj.Akt.BaumZweigId);
    SeitePfad := FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
    if (Length(SeitePfad) > 0) and (SeitePfad[1] = '\') then
      SeitePfad := copy(SeitePfad, 2, Length(SeitePfad));
    Hauptpfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString);
    Zielverzeichnis := IncludeTrailingPathDelimiter(Hauptpfad + SeitePfad);
    FullFilename := IncludeTrailingPathDelimiter(Zielverzeichnis) + ExtractFileName(Dialog.FileName);

    if not DirectoryExists(Zielverzeichnis) then
    begin
      if MessageDlg('Das Verzeichnis'+ sLineBreak +
                 '"' + Zielverzeichnis + '"' + sLineBreak +
                 'existiert nicht.' + sLineBreak+
                 'Möchten Sie dieses Verzeichnis anlegen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        ForceDirectories(Zielverzeichnis)
      else
        exit;
    end;


    if not DirectoryExists(Zielverzeichnis) then
    begin
      ShowMessage('Das Zielverzeichnis "' + Zielverzeichnis + '" existiert nicht');
      exit;
    end;

    if not SameText(ExtractFilePath(FullFilename), Zielverzeichnis) then
      if FileExists(FullFilename) then
        DeleteFile(PWideChar(FullFilename));

    ShowProgress;
    FProgress.CopyFileWithProgressBar(Dialog.FileName, FullFilename);
    if FProgress.Cancel then
    begin
      if FileExists(FullFilename) then
        DeleteFile(PWideChar(FullFilename));
      FreeAndNil(FProgress);
      exit;
    end;
    FreeAndNil(FProgress);


    if FileExists(FullFilename) then
    begin
      Pfad := FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
      Dateiname := lowercase(ExtractFileName(FullFilename));
      OriDateiname := ExtractFileName(FullFilename);
      FDokument.Read(Dateiname, Pfad);
      if not FDokument.Found then
      begin
        Ext := ExtractFileExt(Dateiname);
        Bez := OriDateiname;
        if Ext > '' then
        begin
          Bez := copy(OriDateiname, 1, Length(OriDateiname)-Length(Ext));
          Ext := copy(Ext, 2, Length(Ext));
        end;
        FDokument.Init;
        FDokument.Feld(DO_BEZ).AsString := Bez;
        FDokument.Feld(DO_DATEINAME).AsString := OriDateiname;
        FDokument.Feld(DO_EXT).AsString := Ext;
        FDokument.Feld(DO_PFAD).AsString := Pfad;
        FDokument.Feld(DO_SAVE_FP).AsBoolean := false;
        if FileExists(FullFilename) then
          FDokument.Feld(DO_SAVE_FP).AsBoolean := true;
        FDokument.Save;
      end;
      FSeiteDokument.Read(FSeiteverbinden.Seite.Id, FDokument.Id);
      if not FSeiteDokument.Found then
      begin
        FSeiteDokument.Init;
        FSeiteDokument.Feld(SD_SE_ID).AsInteger := FSeiteverbinden.Seite.Id;
        FSeiteDokument.Feld(SD_DO_ID).AsInteger := FDokument.Id;
        FSeiteDokument.Save;
        LadeDokumente(FDokument.Id);
      end;

      if FSeiteverbinden.Seite.Feld(SE_GDRIVEUEBERTRAGEN).AsBoolean then
        DokToGDrive(nil);

      if FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean then
        DokPerFTPUebertragen;

    end;


  finally
    FreeAndNil(Dialog);
    if FProgress <> nil then
      FreeAndNil(FProgress);
  end;
end;

procedure Tof_Dokumente.ShowProgress;
begin
  if FProgress = nil then
    FProgress := Tfrm_Progress.Create(Self);
  FProgress.pb.Position := 0;
  FProgress.Show;
end;


procedure Tof_Dokumente.VisibleChanged(aValue: Boolean);
begin
  inherited;
  if not aValue then
  begin
    FGrid.SaveGridSpaltenbreite(SysObj.IniGridFilename);
  end;
end;

procedure Tof_Dokumente.DeleteDok(Sender: TObject);
var
  i1: Integer;
  DelList: TStringList;
  GridDokument: TDokument;
  FrageCloudLoeschen: Integer;
  FrageFPLoeschen: Integer;
  FrageFTPLoeschen: Integer;
  FrageLinkLoeschen: Integer;
  FrageEintragLoeschen: Integer;
  Pfad: string;
  Datei: string;
  Filename: string;
  FTPPfad: string;
  CurrentDir: string;
  Dokument: TDokument;
  Cur: TCursor;
begin
  DelList := TStringList.Create;
  DelList.Duplicates := dupIgnore;
  DelList.Sorted := true;
  FrageCloudLoeschen := -1;
  FrageFPLoeschen := -1;
  FrageFTPLoeschen := -1;
  FrageLinkLoeschen := -1;
  Dokument := TDokument.Create(nil);
  Cur := Screen.Cursor;
  try
    Dokument.Trans := fTrans;
    GridDokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
    if GridDokument <> nil then
      DelList.Add(IntToStr(GridDokument.Id));

    for i1 := FGrid.Selection.Top to FGrid.Selection.Bottom do
    begin
      GridDokument := TDokument(FGrid.Obj['Bild', i1]);
      if GridDokument <> nil then
        DelList.Add(IntToStr(GridDokument.Id));
    end;

    if DelList.Count > 1 then
    begin
      if MessageDlg('Möchten Sie wirklich die Einträge löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        FrageEintragLoeschen := 1
      else
        FrageEintragLoeschen := 0;
      FTPPfad := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
      if (Trim(FTPPfad) > '') and (FTPPfad[1] <> '/') then
        FTPPfad := '/' + FTPPfad;
      Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Dokument.Feld(DO_PFAD).AsString;
      for i1 := 0 to DelList.Count -1 do
      begin
        Dokument.Read(StrToInt(DelList.Strings[i1]));
        if not Dokument.Found then
          continue;
        Filename := Dokument.Feld(DO_DATEINAME).AsString;
        if (FrageCloudLoeschen = -1) and (Dokument.Feld(DO_SAVE_CLOUD).AsBoolean) then
        begin
          if MessageDlg('Möchten Sie Dokumente aus der Cloud löschen?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
            FrageCloudLoeschen := 1
          else
            FrageCloudLoeschen := 0;
        end;
        Datei := IncludeTrailingPathDelimiter(Pfad) + IncludeTrailingPathDelimiter(Dokument.Feld(DO_PFAD).AsString) +  Filename;

        if (FileExists(Datei)) and (FrageFPLoeschen = -1) then
        begin
          if MessageDlg('Möchten Sie die Dateien' + sLineBreak +
                        'von der Festplatte löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrNo then
            FrageFPLoeschen := 1
          else
            FrageFPLoeschen := 0;
        end;

        if (Trim(SysObj.Einstellung.FTP.Host.AsString) > '') and (Trim(SysObj.Einstellung.FTP.Pfad.AsString) > '')
        and (SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean) and (FrageFTPLoeschen = -1)
        and (FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean) then
        begin
          if not fftp.Connected then
            fftp.Connect;
          if not fftp.Connected then
          begin
            MessageDlg('FTP-Verbindung konnte nicht hergestellt werden.', mtError, [mbOk], 0);
            FrageFTPLoeschen := 0;
          end;
          if FrageFTPLoeschen = -1 then
          begin
            try
              CurrentDir := fftp.RetrieveCurrentDir;
              if not (SameText(CurrentDir, FTPPfad)) then
                fftp.ChangeDir(FTPPfad);
              if FTPFileExist(Filename) then
              begin
                if MessageDlg('Möchten Sie die Datei' + sLineBreak +
                              '"' + Filename + '"' + sLineBreak +
                              'aus dem FTP-Verzeichnis löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
                  FrageFTPLoeschen := 0
                else
                  FrageFTPLoeschen := 1;
              end;
            except
              fftp.Disconnect;
              exit;
            end;
          end;
        end;

      end;
      Screen.Cursor := crHourGlass;
      for i1 := 0 to DelList.Count -1 do
      begin
        Dokument.Read(StrToInt(DelList.Strings[i1]));
        if not Dokument.Found then
          continue;
        DoDeleteDokument(Dokument, FrageCloudLoeschen, FrageFPLoeschen, FrageFTPLoeschen, FrageLinkLoeschen, FrageEintragLoeschen);
      end;
      LadeDokumente;
    end
    else
      DeleteDokument;
  finally
    FreeAndNil(DelList);
    FreeAndNil(Dokument);
    Screen.Cursor := Cur;
  end;
end;

procedure Tof_Dokumente.DeleteDokument;
var
  Dokument: TDokument;
  {
  Pfad : string;
  Datei: string;
  FTPPfad: string;
  CurrentDir: string;
  Filename: string;
  }
begin //
  Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
  if Dokument = nil then
    exit;
  DoDeleteDokument(Dokument, -1, -1, -1, -1, -1);
  LadeDokumente;

    {
  try
    Filename := Dokument.Feld(DO_DATEINAME).AsString;

    FSeiteDokumentLink.Read(FSeiteverbinden.Seite.Id, Dokument.Id);
    FSeiteDokument.Read(FSeiteverbinden.Seite.Id, Dokument.id);
    if (not FSeiteDokument.Found) and (not FSeiteDokumentLink.Found) then
      exit;

    if (FSeiteDokumentLink.Found) and (not FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean) then
      exit;

    if FSeiteDokumentLink.Found then
    begin
      if MessageDlg('Möchten Sie wirklich den Dokumentenlink' + sLineBreak +
                    '"' + Dokument.Feld(DO_BEZ).AsString + '"' + sLineBreak +
                   'entfernen?', mtConfirmation, [mbYes, mbNO], 0) <> mrYes then exit;
      FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean := false;
      FSeiteDokumentLink.Save;
      exit;
    end;

    FTPPfad := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
    if (Trim(FTPPfad) > '') and (FTPPfad[1] <> '/') then
      FTPPfad := '/' + FTPPfad;


    if Dokument.Feld(DO_SAVE_CLOUD).AsBoolean then
    begin
      if MessageDlg('Möchten Sie das Dokument aus der Cloud löschen?', mtConfirmation, [mbYes, mbNo],0) = mrYes then
      begin
        Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString) + IncludeTrailingPathDelimiter(Dokument.Feld(DO_PFADGDRIVE).AsString);
        SysObj.GDrive.DeleteFile(Pfad + Dokument.Feld(DO_DATEINAME).AsString);
        Dokument.Feld(DO_SAVE_CLOUD).AsBoolean := false;
        Dokument.Save;
      end;
    end;


    if MessageDlg('Möchten Sie wirklich den Eintrag' + sLineBreak +
                  '"' + Dokument.Feld(DO_BEZ).AsString + '"' + sLineBreak +
                 'löschen?', mtConfirmation, [mbYes, mbNO], 0) <> mrYes then exit;

    FSeiteDokument.Delete;

    if not FSeiteDokument.DokumentExist(Dokument.Id) then
    begin
      Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Dokument.Feld(DO_PFAD).AsString;
      Datei := IncludeTrailingPathDelimiter(Pfad) + Filename;
      if FileExists(Datei) then
      begin
        if MessageDlg('Möchten Sie die Datei' + sLineBreak +
                      '"' + Datei + '"' + sLineBreak +
                      'von der Festplatte löschen?', mtConfirmation, [mbYes, mbNo], 0) <> mrNo then
        begin
          //Dokument.Delete;
          DeleteFile(PChar(Datei));
        end;
      end;
    end;

    if (Trim(SysObj.Einstellung.FTP.Host.AsString) > '') and (Trim(SysObj.Einstellung.FTP.Pfad.AsString) > '')
    and (SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean)
    and (FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean) then
    begin
      if not fftp.Connected then
        fftp.Connect;
      if not fftp.Connected then
      begin
        MessageDlg('FTP-Verbindung konnte nicht hergestellt werden.', mtError, [mbOk], 0);
        exit;
      end;
      try
        CurrentDir := fftp.RetrieveCurrentDir;
        if not (SameText(CurrentDir, FTPPfad)) then
          fftp.ChangeDir(FTPPfad);
        if FTPFileExist(Filename) then
        begin
          if MessageDlg('Möchten Sie die Datei' + sLineBreak +
                        '"' + Filename + '"' + sLineBreak +
                        'aus dem FTP-Verzeichnis löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
          begin
            exit;
          end;
        end;
      except
        fftp.Disconnect;
        exit;
      end;
      Fftp.Delete(Filename);
      Fftp.Disconnect;
    end;
  finally
    if not Dokument.ExistSeite then
      Dokument.Delete;
    LadeDokumente;
  end;
  }
end;

procedure Tof_Dokumente.DoDeleteDokument(aDokument: TDokument; aFrageCloudLoeschen,
  aFrageFPLoeschen, aFrageFTPLoeschen, aFrageLinkLoeschen, aFrageEintragLoeschen: Integer);
var
  Filename: string;
  FTPPfad: string;
  DelCloud: Boolean;
  DelFP: Boolean;
  DelFTP: Boolean;
  DelEintrag: Boolean;
  Pfad: string;
  Datei: string;
  CurrentDir: string;
begin
  try
    Filename := aDokument.Feld(DO_DATEINAME).AsString;

    FSeiteDokumentLink.Read(FSeiteverbinden.Seite.Id, aDokument.Id);
    FSeiteDokument.Read(FSeiteverbinden.Seite.Id, aDokument.id);
    if (not FSeiteDokument.Found) and (not FSeiteDokumentLink.Found) then
      exit;

    if (FSeiteDokumentLink.Found) and (not FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean) then
      exit;

    if (FSeiteDokumentLink.Found) then
    begin
      if (aFrageLinkLoeschen = -1) then
      begin
        if MessageDlg('Möchten Sie wirklich den Dokumentenlink' + sLineBreak +
                      '"' + aDokument.Feld(DO_BEZ).AsString + '"' + sLineBreak +
                     'entfernen?', mtConfirmation, [mbYes, mbNO], 0) <> mrYes then exit;
      end;
      FSeiteDokumentLink.Feld(SK_VERLINKT).AsBoolean := false;
      FSeiteDokumentLink.Save;
      exit;
    end;

    FTPPfad := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
    if (Trim(FTPPfad) > '') and (FTPPfad[1] <> '/') then
      FTPPfad := '/' + FTPPfad;


    if (aDokument.Feld(DO_SAVE_CLOUD).AsBoolean) then
    begin
      DelCloud := aFrageCloudLoeschen = 1;
      if aFrageCloudLoeschen = -1 then
        DelCloud := MessageDlg('Möchten Sie das Dokument aus der Cloud löschen?', mtConfirmation, [mbYes, mbNo],0) = mrYes;

      if DelCloud then
      begin
        Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString) + IncludeTrailingPathDelimiter(aDokument.Feld(DO_PFADGDRIVE).AsString);
        SysObj.GDrive.DeleteFile(Pfad + aDokument.Feld(DO_DATEINAME).AsString);
        aDokument.Feld(DO_SAVE_CLOUD).AsBoolean := false;
        aDokument.Save;
      end;
    end;


    DelEintrag := aFrageEintragLoeschen = 1;

    if aFrageEintragLoeschen = -1 then
      DelEintrag := MessageDlg('Möchten Sie wirklich den Eintrag' + sLineBreak +
                    '"' + aDokument.Feld(DO_BEZ).AsString + '"' + sLineBreak +
                   'löschen?', mtConfirmation, [mbYes, mbNO], 0) = mrYes;

    if not DelEintrag then
      exit;

    FSeiteDokument.Delete;

    if not FSeiteDokument.DokumentExist(aDokument.Id) then
    begin
      Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + aDokument.Feld(DO_PFAD).AsString;
      Datei := IncludeTrailingPathDelimiter(Pfad) + Filename;
      DelFP := aFrageFPLoeschen = 1;
      if (FileExists(Datei)) and (aFrageFPLoeschen = -1) then
      begin
        DelFP := MessageDlg('Möchten Sie die Datei' + sLineBreak +
                      '"' + Datei + '"' + sLineBreak +
                      'von der Festplatte löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
      end;
      if (FileExists(Datei)) and (DelFP) then
      begin
        DeleteFile(PChar(Datei));
      end;
    end;

    if (Trim(SysObj.Einstellung.FTP.Host.AsString) > '') and (Trim(SysObj.Einstellung.FTP.Pfad.AsString) > '')
    and (SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean)
    and (FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean) then
    begin
      if not fftp.Connected then
        fftp.Connect;
      if not fftp.Connected then
      begin
        MessageDlg('FTP-Verbindung konnte nicht hergestellt werden.', mtError, [mbOk], 0);
        exit;
      end;
      try
        CurrentDir := fftp.RetrieveCurrentDir;
        if not (SameText(CurrentDir, FTPPfad)) then
          fftp.ChangeDir(FTPPfad);
        DelFTP := aFrageFTPLoeschen = 1;
        if FTPFileExist(Filename) then
        begin
          if aFrageFTPLoeschen = -1 then
            DelFTP := MessageDlg('Möchten Sie die Datei' + sLineBreak +
                        '"' + Filename + '"' + sLineBreak +
                        'aus dem FTP-Verzeichnis löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
          if not DelFTP then
          begin
            exit;
          end;
        end;
      except
        fftp.Disconnect;
        exit;
      end;
      Fftp.Delete(Filename);
      Fftp.Disconnect;
    end;
  finally
    if not aDokument.ExistSeite then
      aDokument.Delete;
  end;
end;




procedure Tof_Dokumente.FTPWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Int64);
begin
  inherited;
  if FProgress <> nil then
  begin
    FProgress.pb.Position := AWorkCount;
    if (FProgress.Cancel) and not (FAbgebrochen) then
    begin
      FAbgebrochen := true;
      Fftp.Abort;
    end;
    Application.ProcessMessages;
  end;

end;

procedure Tof_Dokumente.FTPWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Int64);
begin
  inherited;
  FAbgebrochen := false;
  if FProgress <> nil then
  begin
    FProgress.Label1.Caption := 'Datei per FTP übertragen';
    FProgress.pb.Max := AWorkCountMax;
  end;
end;

procedure Tof_Dokumente.FTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  inherited;
  if FProgress <> nil then
    FreeAndNil(FProgress);
end;



procedure Tof_Dokumente.BevorePopup(Sender: TObject);
begin
  FPopPerFTPUebertragen.Visible := SysObj.FTPAktiv;
  FPopAufFestplatteUebertragen.Visible := SysObj.FTPAktiv;
end;

procedure Tof_Dokumente.CheckDokumente;
var
  i1: Integer;
  Dokument: TDokument;
  CurrentDir: string;
  FTPPfad: string;
  Filename: string;
  Id: Integer;
  connectOk: Boolean;
  GPfad: String;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourGlass;
    connectOk := true;
    FTPPfad := SysObj.Einstellung.FTP.Pfad.AsString + FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsString;
    if (Trim(FTPPfad) > '') and (FTPPfad[1] <> '/') then
      FTPPfad := '/' + FTPPfad;
    Dokument := TDokument(FGrid.Obj['Bild', FGrid.Row]);
    id := -1;
    if Dokument <> nil then
      Id := Dokument.Id;
    fPg.Max := FGrid.RowCount;
    fPg.Position := 0;
    for i1 := 1 to FGrid.RowCount -1 do
    begin
      fPG.Position := fPg.Position + 1;
      fPG.Invalidate;
      Application.ProcessMessages;
      Dokument := TDokument(FGrid.Obj['Bild', i1]);
      if Dokument = nil then
        continue;

      if SysObj.Einstellung.GoogleDrive.GDriveVerwenden.AsBoolean then
      begin
        GPfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.GoogleDrive.Pfad.AsString) + IncludeTrailingPathDelimiter(Dokument.Feld(DO_PFADGDRIVE).AsString);
        Filename := Dokument.Feld(DO_DATEINAME).AsString;
        if SysObj.GDrive.GetFileItem(GPfad + Filename) <> nil then
          Dokument.Feld(DO_SAVE_CLOUD).AsBoolean := true
        else
          Dokument.Feld(DO_SAVE_CLOUD).AsBoolean := false;
      end;


      if FileExists(Dokument.FullFilename) then
        Dokument.Feld(DO_SAVE_FP).AsBoolean := true
      else
        Dokument.Feld(DO_SAVE_FP).AsBoolean := false;

      Dokument.Save;

      Filename := Dokument.Feld(DO_DATEINAME).AsString;

      if not connectOk then
        continue;

      try
        if (Trim(SysObj.Einstellung.FTP.Host.AsString) > '') and (Trim(SysObj.Einstellung.FTP.Pfad.AsString) > '')
        and (SysObj.Einstellung.FTP.DokumenteUebertragen.AsBoolean)
        and (Dokument.Feld(DO_SAVE_FTP).AsBoolean) then
        //and (FSeiteverbinden.Seite.Feld(SE_PFADFTP).AsBoolean) then
        begin
          if not fftp.Connected then
            fftp.Connect;
          if not fftp.Connected then
          begin
            connectOk := false;
            continue;
          end;
          try
            CurrentDir := fftp.RetrieveCurrentDir;
            if not (SameText(CurrentDir, FTPPfad)) then
              fftp.ChangeDir(FTPPfad);
            if FTPFileExist(Filename) then
              Dokument.Feld(DO_SAVE_FTP).AsBoolean := true
            else
              Dokument.Feld(DO_SAVE_FTP).AsBoolean := false;
            Dokument.Save;
          except
            fftp.Disconnect;
            continue;
          end;
          //Fftp.Delete(Filename);
          Fftp.Disconnect;
        end;
      finally
      end;

      {
      FGrid.Cells[FCol.Filename, i1+1] := Dokument.Feld(DO_DATEINAME).AsString;
      FGrid.Cells[FCol.Pfad, i1+1]     := Dokument.Pfad;
      }
    end;
    LadeDokumente(Id);
  finally
    fPg.Position := 0;
    Screen.Cursor := Cur;
  end;
end;


procedure Tof_Dokumente.GDriveUploadProgress(Sender: TObject; FileName: string;
  Position, Total: Int64);
begin
  fPg.Position := Position;
  fPg.Max := Total;
  //if IsDownloading then
  //  Progresslabel.Caption := InttoStr(Position) +' of ' + InttoStr(Total) +' downloaded';
end;


procedure Tof_Dokumente.DropFileTargetDrop(Sender: TObject; ShiftState: TShiftState;
  APoint: TPoint; var Effect: Integer);
var
  BitmapData: TBitmapDataFormat;
  Pfad: String;
  CopyList: TStringList;
  i1: Integer;
  Cur: TCursor;
  FullFilename: string;
  Dateiname: string;
  OriDateiname: string;
  ext: string;
  Bez: string;
  Id: Integer;
begin //
  Id := -1;
  Cur := Screen.Cursor;
  CopyList := TStringList.Create;
  try
    Screen.Cursor := crHourGlass;
    Pfad := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString);
    if FSeiteverbinden.Seite.Feld(SE_PFAD).AsString > '' then
      Pfad := Pfad + IncludeTrailingPathDelimiter(FSeiteverbinden.Seite.Feld(SE_PFAD).AsString);

    if not DirectoryExists(Pfad) then
    begin
      if MessageDlg('Das Verzeichnis'+ sLineBreak +
                 '"' + Pfad + '"' + sLineBreak +
                 'existiert nicht.' + sLineBreak+
                 'Möchten Sie dieses Verzeichnis anlegen?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
        ForceDirectories(Pfad)
      else
        exit;
    end;

    if (TVirtualFileStreamDataFormat(fDataFormatAdapterTarget.DataFormat).FileNames.Count > 0) then
    begin
      fDragAndDropAdapter.SaveVirtualFileStream(TVirtualFileStreamDataFormat(fDataFormatAdapterTarget.DataFormat), Pfad, CopyList);
    end;

    for i1 := 0 to copyList.Count -1 do
    begin
      FullFilename := copyList.Strings[i1];
      if FileExists(FullFilename) then
      begin
        Pfad := FSeiteverbinden.Seite.Feld(SE_PFAD).AsString;
        Dateiname := lowercase(ExtractFileName(FullFilename));
        OriDateiname := ExtractFileName(FullFilename);
        FDokument.Read(Dateiname, Pfad);
        if not FDokument.Found then
        begin
          Ext := ExtractFileExt(Dateiname);
          Bez := OriDateiname;
          if Ext > '' then
          begin
            Bez := copy(OriDateiname, 1, Length(OriDateiname)-Length(Ext));
            Ext := copy(Ext, 2, Length(Ext));
          end;
          FDokument.Init;
          FDokument.Feld(DO_BEZ).AsString := Bez;
          FDokument.Feld(DO_DATEINAME).AsString := OriDateiname;
          FDokument.Feld(DO_EXT).AsString := Ext;
          FDokument.Feld(DO_PFAD).AsString := Pfad;
          FDokument.Feld(DO_SAVE_FP).AsBoolean := false;
          if FileExists(FullFilename) then
            FDokument.Feld(DO_SAVE_FP).AsBoolean := true;
          FDokument.Save;
        end;
        FSeiteDokument.Read(FSeiteverbinden.Seite.Id, FDokument.Id);
        if not FSeiteDokument.Found then
        begin
          FSeiteDokument.Init;
          FSeiteDokument.Feld(SD_SE_ID).AsInteger := FSeiteverbinden.Seite.Id;
          FSeiteDokument.Feld(SD_DO_ID).AsInteger := FDokument.Id;
          FSeiteDokument.Save;
        end;
      end;

      if FSeiteverbinden.Seite.Feld(SE_GDRIVEUEBERTRAGEN).AsBoolean then
        Kopiere_Dok_Von_FP_Nach_GDrive(FDokument);

      if FDokument.id <> Id then
      begin
        Id := FDokument.Id;
        LadeDokumente(Id);
      end;

        //if FSeiteverbinden.Seite.Feld(SE_FTPUEBERTRAGEN).AsBoolean then
        //  DokPerFTPUebertragen;

    end;

    LadeDokumente(Id);

  finally
    FreeAndNil(CopyList);
    Screen.Cursor := Cur;
  end;
end;


end.
