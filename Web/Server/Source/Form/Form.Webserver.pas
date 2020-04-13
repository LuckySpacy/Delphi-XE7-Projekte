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
  private
    fServer: TWebServer;
    fWebserverXML: TWebserverXML;
    fVerschlusseln: TVerschluesseln;
    fPath: string;
    procedure OptimaChangeLog(aSql: string; var aDataStream: TMemoryStream);
  public
  end;

var
  frm_Webserver: Tfrm_Webserver;

implementation

{$R *.dfm}

uses
  Datenmodul.DM;



procedure Tfrm_Webserver.FormCreate(Sender: TObject);
begin
  fServer := TWebServer.Create(nil);
  fServer.OnOptimaChangeLog := OptimaChangeLog;
  Memo.Clear;
  Logger := TLogger.Create;
  fWebserverXML := nil;
  fPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  fVerschlusseln := TVerschluesseln.Create;

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
begin
  Memo.Lines.Add(aSql);
  List := TStringList.Create;

  dm.qry_OptimaChangeLog.Close;
  DM.qry_OptimaChangeLog.SQL.Text := aSql;
  dm.IBT_OptimaChangeLog.StartTransaction;
  dm.qry_OptimaChangeLog.Open;
  while not dm.qry_OptimaChangeLog.Eof do
  begin
    s := '';
    for i1 := 0 to dm.qry_OptimaChangeLog.FieldList.Count -1 do
      s := s + dm.qry_OptimaChangeLog.FieldList[i1].AsString + '#†#';
    List.Add(s);
    dm.qry_OptimaChangeLog.Next;
  end;
  dm.qry_OptimaChangeLog.Close;
  dm.IBT_OptimaChangeLog.Rollback;

  aDataStream.Position := 0;
  List.SaveToStream(aDataStream);
  FreeAndNil(List);

  {
  List.Add('Hallo Thomas. Wie gehts dir? ‰ˆ¸ƒ÷‹ﬂ');
  aDataStream.Position := 0;
  List.SaveToStream(aDataStream);
  FreeAndNil(List);
  }
end;


procedure Tfrm_Webserver.btn_StartClick(Sender: TObject);
var
  ModulAttribute: TModulAttribute;
begin
  fServer.Start;

  if not FileExists(fPath+ 'Webserver.XML') then
  begin
    Logger.Info('Einstellungsdatei "' + fPath + 'Webserver.XML" nicht gefunden.');
    exit;
  end;

  if fWebserverXML = nil then
    fWebserverXML := TWebserverXML.Create(Self, fPath+ 'Webserver.XML');

  ModulAttribute := fWebserverXML.ModulAttribute('OptimaChangeLog');

  if not dm.IBD_OptimaChangeLog.Connected then
  begin
    dm.IBD_OptimaChangeLog.Params.Clear;
    dm.IBD_OptimaChangeLog.Params.Add('user_name=' + ModulAttribute.Username);
    dm.IBD_OptimaChangeLog.Params.Add('password=' + fVerschlusseln.Entschluesseln(ModulAttribute.Passwort));
    dm.IBD_OptimaChangeLog.DatabaseName := IncludeTrailingPathDelimiter(ModulAttribute.Pfad) + ModulAttribute.Datenbankname;
    dm.IBD_OptimaChangeLog.Connected := true;
  end;

end;

procedure Tfrm_Webserver.btn_StopClick(Sender: TObject);
begin
  fServer.Stop;
  Caption := 'Gestoppt';
end;

end.
