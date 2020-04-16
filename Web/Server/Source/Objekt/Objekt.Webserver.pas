unit Objekt.Webserver;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdCustomHTTPServer,
  IdHTTPServer, System.Zip, IdContext;

type
  TDataStreamEvent = procedure(aSql: string; var aDataStream: TMemoryStream) of object;
  TWebServer = class(TComponent)
  private
    fServer: TIdHTTPServer;
    fZip   : TZipFile;
    fPasswortCheck: Boolean;
    fDataStream: TMemoryStream;
    fUsername: string;
    fPasswort: string;
    fZipStream: TMemoryStream;
    fOnOptimaChangeLog: TDataStreamEvent;
    procedure ServerCommandGet(AContext: TIdContext;
      ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
    procedure ErzeugeZipStream;
    function Hex2String(const Buffer: string): AnsiString;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property PasswortCheck: Boolean read fPasswortCheck write fPasswortCheck;
    property Username: string read fUsername write fUsername;
    property Passwort: string read fPasswort write fPasswort;
    property OnOptimaChangeLog: TDataStreamEvent read fOnOptimaChangeLog write fOnOptimaChangeLog;
    procedure Start;
    procedure Stop;
  end;

implementation

{ TWebServer }

constructor TWebServer.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fServer := TIdHTTPServer.Create(nil);
  fZip    := TZipFile.Create;
  fPasswortCheck := false;
  fDataStream := nil;
  fZipStream  := nil;
  fServer.OnCommandGet := ServerCommandGet;
end;

destructor TWebServer.Destroy;
begin
  FreeAndNil(fServer);
  FreeAndNil(fZip);
  if fDataStream <> nil then
    FreeAndNil(fDataStream);
  inherited;
end;


procedure TWebServer.ServerCommandGet(AContext: TIdContext;
  ARequestInfo: TIdHTTPRequestInfo; AResponseInfo: TIdHTTPResponseInfo);
var
  //DataString: String;
  Groesse: string;
  Param: String;
  List: TStringList;
begin
  Groesse := '';
  List := TStringList.Create;
  try
    if (fPasswortCheck)
    and ((ARequestInfo.AuthUsername <> fUsername)
    or (ARequestInfo.AuthPassword <> fPasswort)) then
    begin
      AResponseInfo.ContentText := 'Benutzername und Kennwort bitte...';
      AResponseInfo.AuthRealm := 'Sheff-Interface';
      exit;
    end;

    if ARequestInfo.Document = '/OptimaChangeLog' then
    begin
      if not Assigned(fOnOptimaChangeLog) then
        exit;
      if fDataStream <> nil then
        FreeAndNil(fDataStream);
      fDataStream := TMemoryStream.Create;
      Param := String(Hex2String(ARequestInfo.QueryParams));
      fOnOptimaChangeLog(Param, fDataStream);
      ErzeugeZipStream;
      AResponseInfo.ContentType := 'text/html';
      AResponseInfo.ContentStream := fZipStream;
      SetLength(Groesse, fZipStream.Size);
      fZipStream.Read(Groesse[1], fZipStream.Size);
    end;
  finally
    FreeAndNil(List);
  end;
end;


procedure TWebServer.Start;
begin
  fServer.Active := true;
end;

procedure TWebServer.Stop;
begin
  fServer.Active := false;
end;

procedure TWebServer.ErzeugeZipStream;
begin
  //if fZipStream <> nil then
  //  FreeAndNil(fZipStream);
  fZipStream := TMemoryStream.Create;
  fZip.Open(fZipStream, zmWrite);
  fDataStream.Position := 0;
  fZip.Add(fDataStream, 'Data.txt');
  fZip.Close;
  //fZipStream.Position := 0;
  //fZipStream.SaveToFile('c:\Bachmann\Delphi\Delphi XE7\Projekte\Web\Server\Source\Zip.Zip');
  //fZipStream.Position := 0;
end;


function TWebServer.Hex2String(const Buffer: string): AnsiString;
begin
  SetLength(Result, Length(Buffer) div 2);
  HexToBin(PChar(Buffer), PAnsiChar(Result), Length(Result));
end;

end.
