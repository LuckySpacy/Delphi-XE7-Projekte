unit Objekt.WebClient;

interface

uses
  System.SysUtils, System.Variants, System.Classes,
   IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
   System.zip, vcl.dialogs;

type
  TWebClient = class(TComponent)
  private
    fZip: TZipFile;
    fHttp: TIdHTTP;
    fOnWebserverConnectError: TNotifyEvent;
    fPasswort: string;
    fUsername: string;
    fPort: Integer;
    fOnWebserverNotAutorisiert: TNotifyEvent;
    fUrl: string;
    function String2Hex(const Buffer: AnsiString): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure get(aUrl, aPath, aQueryParam: string; var aDataStream: TMemoryStream);
    property OnWebserverConnectError: TNotifyEvent read fOnWebserverConnectError write fOnWebserverConnectError;
    property OnWebserverNotAutorisiert: TNotifyEvent read fOnWebserverNotAutorisiert write fOnWebserverNotAutorisiert;
    property Username: string read fUsername write fUsername;
    property Passwort: string read fPasswort write fPasswort;
    property Port: Integer read fPort write fPort;
    property Url: string read fUrl write fUrl;
  end;

implementation

{ TWebClient }

uses
  IdException, IdStack;

constructor TWebClient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fZip  := TZipFile.Create;
  fHttp := TIdHTTP.Create(nil);
  fUsername := '';
  fPasswort := '';
  fPort     := 80;
end;

destructor TWebClient.Destroy;
begin
  FreeAndNil(fZip);
  FreeAndNil(fHttp);
  inherited;
end;

procedure TWebClient.get(aUrl, aPath, aQueryParam: string;
  var aDataStream: TMemoryStream);
var
  ZipStream: TMemoryStream;
  Stream: TStream;
  ZipHeader: TZipHeader;
  s: string;
begin
  if (aUrl[Length(aUrl)] = '/') or (aUrl[Length(aUrl)] = '\') then
    aUrl := copy(aUrl, 1, Length(aUrl)-1);

  s := aUrl + '/' + aPath + '?' + String2Hex(AnsiString(aQueryParam));
  if fPort <> 80 then
    s := aUrl + ':' + IntToStr(fPort) + '/' + aPath + '?' + String2Hex(AnsiString(aQueryParam));

  fHttp.Request.BasicAuthentication := false;

  if (fUsername > '') and (fPasswort > '') then
  begin
    fHttp.Request.BasicAuthentication := true;
    fHttp.Request.Username := fUsername;
    fHttp.Request.Password := fPasswort;
  end;

  ZipStream := TMemoryStream.Create;
  try
    try
      fhttp.get(s, ZipStream);
    except
      on E: EIdSocketError do
      begin
        //ShowMessage(e.Message);
        if Assigned(fOnWebserverConnectError) then
          fOnWebserverConnectError(Self);
        exit;
      end;
      on E: EIdHTTPProtocolException do
      begin
        //ShowMessage(IntToStr(E.ErrorCode));
        if E.ErrorCode = 401 then
        begin
          if Assigned(fOnWebserverNotAutorisiert) then
            fOnWebserverNotAutorisiert(Self);
        end;
        exit;
      end;
    end;
    ZipStream.Position := 0;
    fZip.Open(TStream(ZipStream), zmRead);
    fZip.Read('Data.txt', Stream, ZipHeader);
    Stream.Position := 0;
    aDataStream.LoadFromStream(Stream);
    aDataStream.Position := 0;
    fZip.Close;
  finally
    FreeAndNil(ZipStream);
  end;
end;

function TWebClient.String2Hex(const Buffer: AnsiString): string;
begin
  SetLength(Result, Length(Buffer) * 2);
  BinToHex(PAnsiChar(Buffer), PChar(Result), Length(Buffer));
end;


end.
