unit Objekt.Verschluesseln;

interface

uses
  SysUtils, Classes, uTPLb_CryptographicLibrary, uTPLb_Codec;


type
  TVerschluesseln = class
  private
    fKey: string;
    fLibrary : TCryptographicLibrary;
    fCodec   : TCodec;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Verschluesseln(aValue: string): string;
    function Entschluesseln(aValue: string): string;
    property Key: string read fKey write fKey;
  end;

implementation

{ TVerschluesseln }

constructor TVerschluesseln.Create;
begin
  fKey := 'Au!7p‹e‰%"o9)$cC÷6543?=Qq@Gc';
  fLibrary := TCryptographicLibrary.Create(nil);
  fCodec := TCodec.Create(nil);
  fCodec.CryptoLibrary := FLibrary;
  fCodec.StreamCipherId := 'native.StreamToBlock';
  fCodec.BlockCipherId := 'native.AES-256';
  fCodec.ChainModeId := 'native.ECB';
  fCodec.Password := fKey;
end;

destructor TVerschluesseln.Destroy;
begin
  FreeAndNil(fLibrary);
  FreeAndNil(fCodec);
  inherited;
end;

function TVerschluesseln.Entschluesseln(aValue: string): string;
begin
  fCodec.DecryptString(Result, aValue, TEncoding.ANSI);
end;


function TVerschluesseln.Verschluesseln(aValue: string): string;
begin
  fCodec.EncryptString(aValue, Result, TEncoding.ANSI);
end;


end.
