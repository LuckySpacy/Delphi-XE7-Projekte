unit Form.WebserverDienst;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer, IdHTTPServer, IdContext;

type
  TService2 = class(TService)
    procedure ServiceCreate(Sender: TObject);
    procedure ServiceDestroy(Sender: TObject);
    procedure ServiceExecute(Sender: TService);
  private
    fServer: TIdHTTPServer;
    fStream: TFileStream;
    procedure ServerCommandGet(AContext: TIdContext; ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
  public
    function GetServiceController: TServiceController; override;
  end;

var
  Service2: TService2;

implementation

{$R *.dfm}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  Service2.Controller(CtrlCode);
end;

function TService2.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TService2.ServiceCreate(Sender: TObject);
begin //
  fServer := TIdHTTPServer.Create(nil);
  fStream := nil;
end;

procedure TService2.ServiceDestroy(Sender: TObject);
begin //
  FreeAndNil(fServer);
  if fStream <> nil then
    FreeandNil(fStream);
end;

procedure TService2.ServiceExecute(Sender: TService);
begin //
  fServer.DefaultPort := 80;
  fServer.Active := true;
  fServer.OnCommandGet := ServerCommandGet;
  while not Terminated do
  begin
    sleep(100);
    ServiceThread.ProcessRequests(false);
  end;
end;

procedure TService2.ServerCommandGet(AContext: TIdContext;
    ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  Groesse: string;
begin
  if ARequestInfo.Document = '/' then
  begin
    AResponseInfo.ContentType := 'text/html';
    if fStream <> nil then
      FreeAndNil(fStream);
    fStream := TFileStream.Create('c:\Entwicklung\Delphi\Rio\Test\Webserver\Test 2\index.html', fmOpenRead or fmShareDenyWrite);
    AResponseInfo.ContentStream := fStream;
    SetLength(Groesse, fStream.Size);
    fStream.Read(Groesse[1], fStream.Size);
    //Memo.Lines.Add(DateToStr(date) + ' - ' + TimeToStr(time) + ': Client ' + ARequestInfo.RemoteIP + ' hat die Datei index.html');
    //FreeAndNil(Stream);
  end;
end;

end.
