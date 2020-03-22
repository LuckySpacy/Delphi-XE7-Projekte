unit Form.TSIServer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, Vcl.ComCtrls, Vcl.ExtCtrls, DBOBJ.Schnittstelle,
  DBObj.AktieKurse, DBObj.AktieKurseList, Objekt.KursCSV, Objekt.KursCsvList,
  IdTCPConnection, IdTCPClient, IdHTTP, IdBaseComponent, IdComponent,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  DBObj.SchnittstelleList, dbObj.AkStList, dbObj.AkSt;

type
  Tfrm_TSIServer = class(TForm)
    pg: TPageControl;
    tbs_Einstellung: TTabSheet;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edt_Uhrzeit: TDateTimePicker;
    GroupBox2: TGroupBox;
    lbl_Downloadpfad: TLabel;
    lbl_Zielpfad: TLabel;
    edt_Downloadpfad: TAdvDirectoryEdit;
    edt_Zielpfad: TAdvDirectoryEdit;
    GroupBox3: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    edt_KurseFDB: TAdvDirectoryEdit;
    edt_TSIFDB: TAdvDirectoryEdit;
    Label4: TLabel;
    edt_Server: TEdit;
    tbs_Protokoll: TTabSheet;
    mem_Protokoll: TMemo;
    Panel1: TPanel;
    btn_Start: TButton;
    pnl_Progress: TPanel;
    lbl_pg: TLabel;
    pgBar: TProgressBar;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Http: TIdHTTP;
    Timer: TTimer;
    Label5: TLabel;
    cbo_Schnittstelle: TComboBox;
    btn_ClearProtokoll: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure EditExit(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure tbs_ProtokollShow(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cbo_SchnittstelleExit(Sender: TObject);
    procedure btn_ClearProtokollClick(Sender: TObject);
  private
    fSchnittstelle: TSchnittstelle;
    fSchnittstelleList: TSchnittstelleList;
    fAktieKurseList: TAktieKurseList;
    fAkStList: TAkStList;
    fAkSt: TAkSt;
    fKursCsvList: TKursCsvList;
    fLetzterLauf: TDateTime;
    function CheckPfade: Boolean;
    procedure KurseLaden;
    procedure Aktienimport;
    procedure KurseImport;
    procedure TSIWerteLaden;
    procedure LadeUndSaveCSVFile(aFilename: string);
    procedure DownloadFile(aUrl, aFilename: string);
    procedure SyncMySql;
    procedure SyncMySqlBoersenindex;
    procedure SyncMySqlAktie;
    procedure SyncMySqlKurs;
    procedure SyncMySqlTSI;
    procedure SyncMySqlTSIAnsicht;
    procedure Start;
  public
  end;

var
  frm_TSIServer: Tfrm_TSIServer;

implementation

{$R *.dfm}

uses
  Objekt.Ini, Objekt.Protokoll, Datamodul.TSIServer, Objekt.Aktienimport, Objekt.KursImport,
  Objekt.TSIWerteLaden, DateUtils, Allgemein.Funktionen, Objekt.MySqlBoersenindex,
  Objekt.MySqlAktie, Objekt.MySqlKurs, Objekt.MySqlTSI, Objekt.MySqlTSIAnsicht;



procedure Tfrm_TSIServer.FormCreate(Sender: TObject);
begin
  Ini := TIni.Create(nil);
  Protokoll := TProtokoll.Create(nil);
  edt_Downloadpfad.Text := Ini.Downloadpfad;
  edt_Zielpfad.Text     := Ini.Zielpfad;
  edt_Server.Text       := Ini.Server;
  edt_KurseFDB.Text     := Ini.KurseFDB;
  edt_TSIFDB.Text       := Ini.TSIFDB;
  edt_Uhrzeit.Time      := StrToTime(Ini.Uhrzeit);
  mem_Protokoll.Clear;
  fSchnittstelle  := TSchnittstelle.Create(nil);
  fAktieKurseList := TAktieKurseList.Create(nil);
  fKursCsvList    := TKursCsvList.Create(nil);
  fLetzterLauf := EncodeDateTime(YearOf(now), MonthOf(now), DayOf(now), 0, 1, 0, 0);
  fLetzterLauf := IncDay(fLetzterLauf, 1);
  fSchnittstelleList := TSchnittstelleList.Create(nil);

  fAkStList := TAkStList.Create(nil);
  fAkSt := TAkSt.Create(nil);


  //Timer.Interval := 1000;
end;

procedure Tfrm_TSIServer.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Ini);
  FreeAndNil(Protokoll);
  FreeAndNil(fSchnittstelle);
  FreeAndNil(fAktieKurseList);
  FreeAndNil(fKursCsvList);
  FreeAndNil(fSchnittstelleList);
  FreeAndNil(fAkStList);
  FreeAndNil(fAkSt);
end;


procedure Tfrm_TSIServer.FormShow(Sender: TObject);
var
  i1: Integer;
begin
  if not dm.ConnectTSI then
  begin
    ShowMessage('Fehler beim Connect auf die TSI-Datenbank');
    exit;
  end;
  fSchnittstelleList.Trans := dm.IBTTSI;
  fSchnittstelleList.LadeCombobox(cbo_Schnittstelle.Items);
  if Ini.Schnittstelle > -1 then
  begin
    for i1 := 0 to cbo_Schnittstelle.Items.Count -1 do
    begin
      if Ini.Schnittstelle = Integer(cbo_Schnittstelle.Items.Objects[i1]) then
      begin
        cbo_Schnittstelle.ItemIndex := i1;
        break;
      end;
    end;
  end;
  dm.DBMySqlTSI.Connect;
  if dm.DBMySqlTSIConnectError then
  begin
    Protokoll.write('SyncMySql', 'Fehler beim Connect ' + dm.DBMySqlTSIConnectErrorMsg);
    exit;
  end;
end;

procedure Tfrm_TSIServer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if cbo_Schnittstelle.ItemIndex > -1 then
  begin
    Ini.Schnittstelle := Integer(cbo_Schnittstelle.Items.Objects[cbo_Schnittstelle.ItemIndex]);
  end;
end;

procedure Tfrm_TSIServer.tbs_ProtokollShow(Sender: TObject);
begin
  mem_Protokoll.Clear;
  if FileExists(Protokoll.Filename) then
    mem_Protokoll.Lines.LoadFromFile(Protokoll.Filename);
end;

procedure Tfrm_TSIServer.TimerTimer(Sender: TObject);
var
  CheckUhrzeit: TDateTime;
  Uhrzeit: TDateTime;
begin
  Uhrzeit := StrToTime(Ini.Uhrzeit);
  CheckUhrzeit := EncodeDateTime(YearOf(now), MonthOf(now), DayOf(now), HourOf(Uhrzeit), MinuteOf(Uhrzeit), SecondOf(Uhrzeit), 0);
  if fLetzterLauf < CheckUhrzeit then
  begin
    Protokoll.write('TimerTimer', 'Start');
    fLetzterLauf := EncodeDateTime(YearOf(now), MonthOf(now), DayOf(now), 0, 1, 0, 0);
    fLetzterLauf := IncDay(fLetzterLauf, 1);
    Start;
  end;
end;

procedure Tfrm_TSIServer.TSIWerteLaden;
var
  TSIWerte: TTSIWerteLaden;
begin
  TSIWerte := TTSIWerteLaden.Create(nil);
  try
    TSIWerte.ProgressLabel := lbl_pg;
    TSIWerte.ProgressBar   := pgBar;
    TSIWerte.Trans := dm.IBTTSI;
    TSIWerte.StartDatum := StrToDate('01.01.2017');
    if not TSIWerte.Exec then
      Protokoll.write('TSIWerteLaden', 'Fehler beim TSI-Werte Laden');

  finally
    FreeAndNil(TSIWerte);
  end;
end;

procedure Tfrm_TSIServer.Aktienimport;
var
  Aktienimport: TAktienimport;
begin
  Aktienimport := TAktienimport.Create(nil);
  try
    Aktienimport.ProgressLabel := lbl_pg;
    Aktienimport.ProgressBar   := pgBar;
    Aktienimport.Trans := dm.IBTTSI;
    if not Aktienimport.Exec then
      Protokoll.write('Aktienimport', 'Aktienimport fehlgeschlagen');

  finally
    FreeAndNil(Aktienimport);
  end;
end;

procedure Tfrm_TSIServer.KurseImport;
var
  KursImport: TKursimport;
begin
  KursImport := TKursimport.Create(nil);
  try
    KursImport.ProgressLabel := lbl_pg;
    KursImport.ProgressBar   := pgBar;
    KursImport.Trans := dm.IBTTSI;
    if not KursImport.Exec then
      Protokoll.write('Aktienimport', 'Aktienimport fehlgeschlagen');
  finally
    FreeAndNil(KursImport);
  end;
end;


procedure Tfrm_TSIServer.btn_ClearProtokollClick(Sender: TObject);
begin
  mem_Protokoll.Clear;
  Protokoll.Clear;
end;

procedure Tfrm_TSIServer.btn_StartClick(Sender: TObject);
begin
  Start;
end;


procedure Tfrm_TSIServer.Start;
begin
  Timer.Enabled := false;
  try
    if not dm.ConnectKurse then
    begin
      ShowMessage('Fehler beim Connect auf die Kurse-Datenbank');
      exit;
    end;
    if not dm.ConnectTSI then
    begin
      ShowMessage('Fehler beim Connect auf die TSI-Datenbank');
      exit;
    end;
    if not CheckPfade then
    begin
      ShowMessage('Bitte Pfade kontrollieren');
      exit;
    end;
    pnl_Progress.Visible := true;

    KurseLaden; //muss wieder aktiviert werden.
    Aktienimport;
    KurseImport;
    TSIWerteLaden;

    SyncMySql;

  finally
    Timer.Enabled := true;
  end;
end;



function Tfrm_TSIServer.CheckPfade: Boolean;
begin
  Result := false;
  if not DirectoryExists(Ini.Downloadpfad) then
  begin
    Protokoll.write('CheckPfade', 'Der Downloadpfad "' + Ini.Downloadpfad + '" existiert nicht.');
    exit;
  end;
  if not DirectoryExists(Ini.Zielpfad) then
  begin
    Protokoll.write('CheckPfade', 'Der Zielpfad "' + Ini.Zielpfad + '" existiert nicht.');
    exit;
  end;

  //fSchnittstelle.Trans := dm.IBTKurse;
  fSchnittstelle.Trans := dm.IBTTSI;
  fSchnittstelle.Read(Ini.Schnittstelle);
  if not fSchnittstelle.Gefunden then
  begin
    ShowMessage('Schnittstelle nicht gefunden');
    exit;
  end;
  Result := true;
end;

procedure Tfrm_TSIServer.cbo_SchnittstelleExit(Sender: TObject);
begin
  Ini.Schnittstelle := fSchnittstelle.Id;
end;


procedure Tfrm_TSIServer.EditExit(Sender: TObject);
begin
  Ini.Downloadpfad := edt_Downloadpfad.Text;
  Ini.Zielpfad     := edt_Zielpfad.Text;
  Ini.Server       := edt_Server.Text;
  Ini.KurseFDB     := edt_KurseFDB.Text;
  Ini.TSIFDB       := edt_TSIFDB.Text;
  Ini.Uhrzeit      := TimeToStr(edt_Uhrzeit.Time);
end;



procedure Tfrm_TSIServer.KurseLaden;
var
  i1: Integer;
  Aktie: TAktieKurse;
  Url: string;
  Filename: string;
  s : string;
  CsvAktieList: TStringList;
begin
  //fAktieKurseList.Trans := dm.IBTKurse;
  fAkSt.Trans := dm.IBTTSI;
  fAkStList.Trans := dm.IBTTSI;
  fAktieKurseList.Trans := dm.IBTTSI;
  fAktieKurseList.ReadAll;
  pgBar.Position := 0;
  pgBar.Max := fAktieKurseList.Count;
  CsvAktieList := TStringList.Create;
  try
    for i1 := 0 to fAktieKurseList.Count -1 do
    begin
      Aktie := fAktieKurseList.Item[i1];

      fAkSt.ReadSchnittstelleAktie(fSchnittstelle.Id, Aktie.Id);
      if not fAkSt.Gefunden then
        continue;
      if Trim(fAkSt.Param1) = '' then
        continue;

      lbl_pg.Caption := 'Download: [' + Aktie.WKN + '] ' + Aktie.Aktie;
      pgBar.Position := i1 + 1;
      Url := fSchnittstelle.Link;
      //Url := StringReplace(Url, '@@SYMBOL@@', Aktie.Symbol, [rfReplaceAll]);
      Url := StringReplace(Url, '~Param1~', fAkSt.Param1, [rfReplaceAll]);
      Filename := IncludeTrailingPathDelimiter(Ini.Downloadpfad) + Aktie.WKN + '_' + Aktie.Aktie + '.csv';
      Application.ProcessMessages;
      //if Trim(Aktie.Symbol) = '' then
      //  continue;
      DownloadFile(Url, Filename);
      LadeUndSaveCSVFile(Filename);
      s := Aktie.WKN + ';' + Aktie.Aktie + ';' + Aktie.Symbol + ';' + Aktie.Boersenindexname;
      CsvAktieList.Add(s);
      //break;
    end;
    CsvAktieList.SaveToFile(IncludeTrailingPathDelimiter(Ini.Zielpfad)+'Aktien.csv');
  finally
    FreeAndNil(CsvAktieList);
  end;
end;



procedure Tfrm_TSIServer.DownloadFile(aUrl, aFilename: string);
var
  ms: TMemoryStream;
  List: TStringList;
begin
  List := TStringList.Create;
  ms := TMemoryStream.Create;
  try
    ms.Position := 0;
    try
      List.Text := http.Post(aurl, ms);
    except
      on E: Exception do
      begin
        Protokoll.write('DownloadFile', aUrl);
        Protokoll.write('DownloadFile', aFilename);
        Protokoll.write('DownloadFile', E.Message);
        Protokoll.write('DownloadFile', '-------------------------------------------------------------------');
        exit;
      end;
    end;
    ms.Position := 0;
    try
      List.SaveToFile(aFilename);
    except
      on E: Exception do
      begin
        Protokoll.write('DownloadFile', 'Fehler beim Speichern - ' + E.Message + ' - ' + aFilename);
      end;
    end;
    if List.Count < 10 then
    begin
      Protokoll.write('DownloadFile', 'Datei ist zu klein - ' + aUrl + ' - ' + aFilename);
    end;

  finally
    FreeAndNil(ms);
    FreeAndNil(List);
  end;
end;


procedure Tfrm_TSIServer.LadeUndSaveCSVFile(aFilename: string);
var
  List: TStringList;
  i1: Integer;
  Wkn: string;
  Aktie: string;
  KursCsv: TKursCsv;
  Filename : String;
begin
  if not FileExists(aFilename) then
    exit;
  Filename := ExtractFileName(aFilename);
  i1 := Pos('_', Filename);
  if i1 > 0 then
  begin
    Wkn   := copy(Filename, 1, i1-1);
    Aktie := copy(Filename, i1+1, Length(Filename));
    Aktie := copy(Aktie, 1, Length(Aktie)-4);
  end;
  List := TStringList.Create;
  try
    fKursCsvList.Clear;
    List.LoadFromFile(aFileName);
    for i1 := 0 to List.Count -1 do
    begin
      KursCsv := fKursCsvList.AddRow(List.Strings[i1]);
      if KursCsv <> nil then
      begin
        KursCsv.Aktie := Aktie;
        KursCsv.WKN   := Wkn;
      end;
    end;
    Filename := IncludeTrailingPathDelimiter(Ini.Zielpfad) + Wkn + '_' + Aktie + '.csv';
    try
      fKursCsvList.SaveToFile(Filename);
    except
      on E: Exception do
      begin
        Protokoll.write('LadeUndSaveCSVFile', 'Fehler beim Speichern - ' + E.Message + ' - ' + Filename);
      end;
    end;

  finally
    FreeAndNil(List);
  end;

end;



procedure Tfrm_TSIServer.SyncMySql;
begin
  if dm.DBMySqlTSIConnectError then
  begin
    Protokoll.write('SyncMySql', 'Fehler beim Connect ' + dm.DBMySqlTSIConnectErrorMsg);
    exit;
  end;

  SyncMySqlBoersenindex;
  SyncMySqlAktie;
  SyncMySqlKurs;
  SyncMySqlTSI;

  SyncMySqlTSIAnsicht;
end;

procedure Tfrm_TSIServer.SyncMySqlAktie;
var
  MySqlAktie: TMySqlAktie;
begin
  MySqlAktie := TMySqlAktie.Create(nil);
  try
    MySqlAktie.Trans := dm.IBTTSI;
    MySqlAktie.DBMYSqlTSI := dm.DBMySqlTSI;
    MySqlAktie.Exec;
  finally
    FreeAndNil(MySqlAktie);
  end;
end;

procedure Tfrm_TSIServer.SyncMySqlBoersenindex;
var
  MySqlBoersenindex: TMySqlBoersenindex;
begin
  MySqlBoersenindex := TMySqlBoersenindex.Create(nil);
  try
    MySqlBoersenindex.Trans := dm.IBTTSI;
    MySqlBoersenindex.DBMYSqlTSI := dm.DBMySqlTSI;
    MySqlBoersenindex.Exec;
  finally
    FreeAndNil(MySqlBoersenindex);
  end;

end;


procedure Tfrm_TSIServer.SyncMySqlKurs;
var
  MySqlKurs: TMySqlKurs;
begin
  MySqlKurs := TMySqlKurs.Create(nil);
  try
    MySqlKurs.ProgressLabel := lbl_pg;
    MySqlKurs.ProgressBar   := pgBar;
    MySqlKurs.Trans := dm.IBTTSI;
    MySqlKurs.DBMYSqlTSI := dm.DBMySqlTSI;
    MySqlKurs.Exec;
  finally
    FreeAndNil(MySqlKurs);
  end;
end;

procedure Tfrm_TSIServer.SyncMySqlTSI;
var
  MySqlTSI: TMySqlTSI;
begin
  MySqlTSI := TMySqlTSI.Create(nil);
  try
    MySqlTSI.ProgressLabel := lbl_pg;
    MySqlTSI.ProgressBar   := pgBar;
    MySqlTSI.Trans := dm.IBTTSI;
    MySqlTSI.DBMYSqlTSI := dm.DBMySqlTSI;
    MySqlTSI.Exec;
  finally
    FreeAndNil(MySqlTSI);
  end;
end;

procedure Tfrm_TSIServer.SyncMySqlTSIAnsicht;
var
  MySqlTSIAnsicht: TMySqlTSIAnsicht;
begin
  MySqlTSIAnsicht := TMySqlTSIAnsicht.Create(nil);
  try
    MySqlTSIAnsicht.Trans := dm.IBTTSI;
    MySqlTSIAnsicht.DBMYSqlTSI := dm.DBMySqlTSI;
    MySqlTSIAnsicht.ProgressBar := pgBar;
    MySqlTSIAnsicht.ProgressLabel := lbl_pg;
    MySqlTSIAnsicht.Exec;
  finally
    FreeAndNil(MySqlTSIAnsicht);
  end;
end;

end.
