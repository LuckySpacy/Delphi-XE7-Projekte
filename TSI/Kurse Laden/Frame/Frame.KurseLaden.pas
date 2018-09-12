unit Frame.KurseLaden;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  DBObj.SchnittstelleList, DBObj.Schnittstelle, AdvEdit, AdvEdBtn, AdvDirectoryEdit,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  DBObj.AktieList, DBObj.Aktie, Vcl.ComCtrls, Objekt.KursCsvList;

type
  Tfra_KurseLaden = class(TFrame)
    Http: TIdHTTP;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    pg: TProgressBar;
    lbl_Pg: TLabel;
    PageControl1: TPageControl;
    tbs_Download: TTabSheet;
    tbs_Protokoll: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label1: TLabel;
    edt_Pfad: TAdvDirectoryEdit;
    edt_Zielpfad: TAdvDirectoryEdit;
    cbo_Schnittstelle: TComboBox;
    btn_Start: TButton;
    mem: TMemo;
    procedure btn_StartClick(Sender: TObject);
    procedure edt_PfadExit(Sender: TObject);
    procedure edt_ZielpfadExit(Sender: TObject);
  private
    fSchnittstelleList: TSchnittstelleList;
    fSchnittstelle: TSchnittstelle;
    fAktieList: TAktieList;
    fKursCsvList: TKursCsvList;
    procedure DownloadFile(aUrl, aFilename: string);
    procedure LadeUndSaveCSVFile(aFilename: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeCombobox;
  end;

implementation

{$R *.dfm}
uses
  Datamodul.TSIKurse, Objekt.Global, Allgemein.RegIni, Objekt.KursCSV;

{ Tfra_KurseLaden }


constructor Tfra_KurseLaden.Create(AOwner: TComponent);
begin
  inherited;
  mem.Clear;
  fSchnittstelleList := TSchnittstelleList.Create(nil);
  fSchnittstelleList.Trans := dm.IBT;
  fSchnittstelle := TSchnittstelle.Create(nil);
  fSchnittstelle.Trans := dm.IBT;
  edt_Pfad.Text := ReadIni(Global.IniFilename, 'KursLaden', 'Downloadpfad', '');
  edt_ZielPfad.Text := ReadIni(Global.IniFilename, 'KursLaden', 'Zielpfad', '');
  fAktieList := TAktieList.Create(nil);
  fAktieList.Trans := dm.IBT;
  fKursCsvList := TKursCsvList.Create(nil);
end;

destructor Tfra_KurseLaden.Destroy;
begin
  freeAndNil(fSchnittstelleList);
  freeAndNil(fSchnittstelle);
  freeAndNil(fAktieList);
  freeAndNil(fKursCsvList);
  inherited;
end;


procedure Tfra_KurseLaden.edt_PfadExit(Sender: TObject);
begin
  WriteIni(Global.IniFilename, 'KursLaden', 'Downloadpfad', edt_Pfad.Text);
end;

procedure Tfra_KurseLaden.edt_ZielpfadExit(Sender: TObject);
begin
  WriteIni(Global.IniFilename, 'KursLaden', 'Zielpfad', edt_ZielPfad.Text);
end;

procedure Tfra_KurseLaden.LadeCombobox;
var
  SSId: Integer;
  i1: Integer;
begin
  SSId := -1;
  if cbo_Schnittstelle.Items.Count > 0 then
    SSId := Integer(cbo_Schnittstelle.Items[cbo_Schnittstelle.ItemIndex])
  else
    SSId := ReadIniToInt(Global.IniFilename, 'KurseLaden', 'Schnittstelle', '-1');
  fSchnittstelleList.LadeCombobox(cbo_Schnittstelle.Items);
  for i1 := 0 to cbo_Schnittstelle.Items.Count -1 do
  begin
    if SSId = Integer(cbo_Schnittstelle.Items.Objects[i1]) then
    begin
      cbo_Schnittstelle.ItemIndex := i1;
      break;
    end;
  end;
end;


procedure Tfra_KurseLaden.btn_StartClick(Sender: TObject);
var
  i1: Integer;
  Aktie: TAktie;
  Url: string;
  Filename: string;
  CsvAktieList: TStringList;
  s: string;
begin
  Mem.Clear;
  if cbo_Schnittstelle.Items.Count < 0 then
    exit;
  if not DirectoryExists(edt_Pfad.Text) then
  begin
    ShowMessage('Der Pfad existiert nicht.');
    edt_Pfad.SetFocus;
    exit;
  end;
  if not DirectoryExists(edt_ZielPfad.Text) then
  begin
    ShowMessage('Der Zielpfad existiert nicht.');
    edt_ZielPfad.SetFocus;
    exit;
  end;

  WriteIni(Global.IniFilename, 'KurseLaden', 'Schnittstelle', IntToStr(cbo_Schnittstelle.ItemIndex));
  fSchnittstelle.Read(Integer(cbo_Schnittstelle.Items.Objects[cbo_Schnittstelle.ItemIndex]));
  if not fSchnittstelle.Gefunden then
  begin
    ShowMessage('Schnittstelle nicht gefunden');
    exit;
  end;
  fAktieList.ReadAll;
  lbl_pg.Visible := true;
  pg.Visible := true;
  pg.Position := 0;
  pg.Max := fAktieList.Count;
  CsvAktieList := TStringList.Create;
  try
    for i1 := 0 to fAktieList.Count -1 do
    begin
      Aktie := fAktieList.Item[i1];
      Url := fSchnittstelle.Link;
      Url := StringReplace(Url, '@@SYMBOL@@', Aktie.Symbol, [rfReplaceAll]);
      Filename := IncludeTrailingPathDelimiter(edt_Pfad.Text) + Aktie.WKN + '_' + Aktie.Aktie + '.csv';
      lbl_pg.Caption := Aktie.WKN + '  ' + Aktie.Aktie;
      pg.Position := i1 + 1;
      Application.ProcessMessages;
      DownloadFile(Url, Filename);
      LadeUndSaveCSVFile(Filename);
      s := Aktie.WKN + ';' + Aktie.Aktie + ';' + Aktie.Symbol + ';' + Aktie.Boersenindexname;
      CsvAktieList.Add(s);
    end;
    CsvAktieList.SaveToFile(IncludeTrailingBackslash(edt_Zielpfad.Text)+'Aktien.csv');
  finally
    FreeAndNil(CsvAktieList);
  end;
  lbl_pg.Visible := false;
  pg.Visible := false;
end;

procedure Tfra_KurseLaden.DownloadFile(aUrl, aFilename: string);
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
        Mem.Lines.Add(aUrl);
        Mem.Lines.Add(aFilename);
        Mem.Lines.Add(E.Message);
        Mem.Lines.Add('-------------------------------------------------------------------');
        exit;
      end;
    end;
    ms.Position := 0;
    List.SaveToFile(aFilename);
  finally
    FreeAndNil(ms);
    FreeAndNil(List);
  end;
end;

procedure Tfra_KurseLaden.LadeUndSaveCSVFile(aFilename: string);
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
    Filename := IncludeTrailingPathDelimiter(edt_ZielPfad.Text) + Wkn + '_' + Aktie + '.csv';
    fKursCsvList.SaveToFile(Filename);
  finally
    FreeAndNil(List);
  end;

end;



end.
