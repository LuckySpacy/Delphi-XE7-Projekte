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
    function String2Hex(const Buffer: AnsiString): string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure get(aUrl, aPath, aQueryParam: string; var aDataStream: TMemoryStream);
    property OnWebserverConnectError: TNotifyEvent read fOnWebserverConnectError write fOnWebserverConnectError;
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
  s := aUrl + aPath + '?' + String2Hex(AnsiString(aQueryParam));
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
