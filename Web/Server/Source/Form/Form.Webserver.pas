unit Form.Webserver;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Objekt.Webserver, Objekt.Logger, Objekt.WebserverXML, Objekt.Verschluesseln;

type
  Tfrm_Webserver = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    btn_Start: TButton;
    btn_Stop: TButton;
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_StartClick(Sender: TObject);
    procedure btn_StopClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fServer: TWebServer;
    fWebserverXML: TWebserverXML;
    fVerschlusseln: TVerschluesseln;
    fPath: string;
    fTrenner: string;
    procedure OptimaChangeLog(aSql: string; var aDataStream: TMemoryStream);
    procedure DokuOrga(aSql: string; var aDataStream: TMemoryStream);
    procedure AddText(aValue: string);
  public
  end;

var
  frm_Webserver: Tfrm_Webserver;

implementation

{$R *.dfm}

uses
  Datenmodul.DM, Objekt.Tabellenfeld;



procedure Tfrm_Webserver.FormCreate(Sender: TObject);
begin
  fServer := TWebServer.Create(nil);
  fServer.OnOptimaChangeLog := OptimaChangeLog;
  fServer.OnDokuOrga        := DokuOrga;
  Memo.Clear;
  Logger := TLogger.Create;
  fWebserverXML := nil;
  fPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  fVerschlusseln := TVerschluesseln.Create;
  fTrenner := '# #';
end;

procedure Tfrm_Webserver.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fServer);
  FreeAndNil(Logger);
  if fWebserverXML <> nil then
    FreeAndNil(fWebserverXML);
  FreeAndNil(fVerschlusseln);
end;

procedure Tfrm_Webserver.OptimaChangeLog(aSql: string;
  var aDataStream: TMemoryStream);
var
  List: TStringList;
  s: string;
  i1: Integer;
  Tabellenfeld: TTabellenfeld;
begin
  Memo.Lines.Add(aSql);
  List := TStringList.Create;

  dm.qry_OptimaChangeLog.Close;
  DM.qry_OptimaChangeLog.SQL.Text := aSql;
//  DM.qry_OptimaChangeLog.SQL.Text := 'select * from kunde where ku_name = "AA" order by ku_name';
//  DM.qry_OptimaChangeLog.SQL.Text := 'select * from kunde where ku_name = ' + QuotedStr('AA') + ' order by ku_name';
  //DM.qry_OptimaChangeLog.SQL.Text := 'select * from kunde where ku_name = :kuname order by ku_name';
  //dm.qry_OptimaChangeLog.ParamByName('kuname').AsString := 'ÄÄ';

  if dm.IBT_OptimaChangeLog.InTransaction then
    dm.IBT_OptimaChangeLog.Rollback;


  dm.IBT_OptimaChangeLog.StartTransaction;
  try
    try
      dm.qry_OptimaChangeLog.Open;
      //if not dm.qry_OptimaChangeLog.Eof then
      //begin

        s := '';
        for i1 := 0 to dm.qry_OptimaChangeLog.FieldList.Count -1 do
        begin
          s := s + UpperCase(dm.qry_OptimaChangeLog.Fields[i1].FieldName) + fTrenner;
          Tabellenfeld := DM.OptimaChangeLogTabelleInfo(UpperCase(dm.qry_OptimaChangeLog.Fields[i1].FieldName));
          s := s + Tabellenfeld.Feldtyp + fTrenner;
          s := s + Tabellenfeld.Feldsize + fTrenner;
        end;
        List.Add(s);

      //end;

      while not dm.qry_OptimaChangeLog.Eof do
      begin
        s := '';
        for i1 := 0 to dm.qry_OptimaChangeLog.FieldList.Count -1 do
          s := s + dm.qry_OptimaChangeLog.FieldList[i1].AsString + fTrenner;
        List.Add(s);
        dm.qry_OptimaChangeLog.Next;
      end;
    except
      on E: Exception do
      begin
        List.Text := E.Message;
      end;
    end;
    dm.qry_OptimaChangeLog.Close;
  finally
    dm.IBT_OptimaChangeLog.Rollback;
    aDataStream.Position := 0;
    List.SaveToStream(aDataStream);
    FreeAndNil(List);
  end;


  {
  List.Add('Hallo Thomas. Wie gehts dir? äöüÄÖÜß');
  aDataStream.Position := 0;
  List.SaveToStream(aDataStream);
  FreeAndNil(List);
  }
end;



procedure Tfrm_Webserver.btn_StartClick(Sender: TObject);
var
  ModulAttribute: TModulAttribute;
begin

  if not FileExists(fPath+ 'Webserver.XML') then
  begin
    Logger.Info('Einstellungsdatei "' + fPath + 'Webserver.XML" nicht gefunden.');
    exit;
  end;

  if fWebserverXML = nil then
    fWebserverXML := TWebserverXML.Create(Self, fPath+ 'Webserver.XML');

  ModulAttribute := fWebserverXML.ModulAttribute('OptimaChangeLog');

  if (ModulAttribute.Datenbankname > '') and (not dm.IBD_OptimaChangeLog.Connected) then
  begin
    dm.IBD_OptimaChangeLog.Params.Clear;
    dm.IBD_OptimaChangeLog.Params.Add('user_name=' + ModulAttribute.Username);
    dm.IBD_OptimaChangeLog.Params.Add('password=' + fVerschlusseln.Entschluesseln(ModulAttribute.Passwort));
    dm.IBD_OptimaChangeLog.DatabaseName := IncludeTrailingPathDelimiter(ModulAttribute.Pfad) + ModulAttribute.Datenbankname;
    dm.IBD_OptimaChangeLog.Connected := true;
    AddText('Mit Datenbank: "' + dm.IBD_OptimaChangeLog.DatabaseName + '" verbunden.');
  end;

  ModulAttribute := fWebserverXML.ModulAttribute('DokuOrga');

  if (not dm.IBD_DokuOrga.Connected) and (ModulAttribute.Datenbankname > '') then
  begin
    dm.IBD_DokuOrga.Params.Clear;
    dm.IBD_DokuOrga.Params.Add('user_name=' + ModulAttribute.Username);
    dm.IBD_DokuOrga.Params.Add('password=' + fVerschlusseln.Entschluesseln(ModulAttribute.Passwort));
    dm.IBD_DokuOrga.DatabaseName := IncludeTrailingPathDelimiter(ModulAttribute.Pfad) + ModulAttribute.Datenbankname;
    dm.IBD_DokuOrga.Connected := true;
    AddText('Mit Datenbank: "' + dm.IBD_DokuOrga.DatabaseName + '" verbunden.');
  end;



  fServer.Username := fWebserverXML.WebserverUsername;
  fServer.Passwort := fWebserverXML.WebserverPasswort;
  if fServer.Passwort > '' then
    fServer.PasswortCheck := true
  else
    fServer.PasswortCheck := false;
  fServer.Port := StrToInt(fWebserverXML.WebserverPort);
  fServer.Start;

  AddText('Webserver gestartet');
  AddText('Port: ' + IntToStr(fServer.Port));

end;

procedure Tfrm_Webserver.btn_StopClick(Sender: TObject);
begin
  fServer.Stop;
  AddText('Webserver gestoppt');
end;

procedure Tfrm_Webserver.Button1Click(Sender: TObject);
begin
  dm.OptimaChangeLogTabelleInfo('KU_ID');
end;


procedure Tfrm_Webserver.DokuOrga(aSql: string; var aDataStream: TMemoryStream);
var
  List: TStringList;
  s: string;
  i1: Integer;
  Tabellenfeld: TTabellenfeld;
begin
  Memo.Lines.Add(aSql);
  List := TStringList.Create;

  dm.qry_DokuOrga.Close;
  DM.qry_DokuOrga.SQL.Text := aSql;

  if dm.IBT_DokuOrga.InTransaction then
    dm.IBT_DokuOrga.Rollback;


  dm.IBT_DokuOrga.StartTransaction;
  try
    try
      dm.qry_DokuOrga.Open;
      //if not dm.qry_OptimaChangeLog.Eof then
      //begin

        s := '';
        for i1 := 0 to dm.qry_DokuOrga.FieldList.Count -1 do
        begin
          s := s + UpperCase(dm.qry_DokuOrga.Fields[i1].FieldName) + fTrenner;
          Tabellenfeld := DM.DokuOrgaTabelleInfo(UpperCase(dm.qry_DokuOrga.Fields[i1].FieldName));
          s := s + Tabellenfeld.Feldtyp + fTrenner;
          s := s + Tabellenfeld.Feldsize + fTrenner;
        end;
        List.Add(s);

      //end;

      while not dm.qry_DokuOrga.Eof do
      begin
        s := '';
        for i1 := 0 to dm.qry_DokuOrga.FieldList.Count -1 do
          s := s + dm.qry_DokuOrga.FieldList[i1].AsString + fTrenner;
        List.Add(s);
        dm.qry_DokuOrga.Next;
      end;
    except
      on E: Exception do
      begin
        List.Text := E.Message;
      end;
    end;
    dm.qry_DokuOrga.Close;
  finally
    dm.IBT_DokuOrga.Rollback;
    aDataStream.Position := 0;
    List.SaveToStream(aDataStream);
    FreeAndNil(List);
  end;
end;

procedure Tfrm_Webserver.AddText(aValue: string);
begin
  Memo.Lines.Add(FormatDateTime('dd.mm.yyyy', now) + ' - '+ aValue);
  Logger.Info(aValue);
end;

end.
