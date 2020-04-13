unit Form.WebClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdServerIOHandler, IdSSL, IdSSLOpenSSL, System.zip;

type
  TForm2 = class(TForm)
    Http: TIdHTTP;
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fZip: TZipFile;
  public
    { Public-Deklarationen }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormCreate(Sender: TObject);
begin
  fZip := TZipFile.Create;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fZip);
end;


procedure TForm2.Button1Click(Sender: TObject);
var
  s: string;
  Resp: TMemoryStream;
begin
  Memo1.Clear;
  Resp := TMemoryStream.Create;
  try
    //s := http.get('http://localhost');
    //Memo1.Lines.Add(s);
    http.Request.Clear;
    {
    http.Request.BasicAuthentication := true;
    http.Request.Username := 'test';
    http.Request.Password := 'test';
    }
    http.get('http://localhost/OptimaChangeLog?select * from vorgang', Resp);
    Resp.Position := 0;
    Memo1.Lines.LoadFromStream(Resp);
  finally
    FreeAndNil(Resp);
  end;
end;

procedure TForm2.Button2Click(Sender: TObject);
var
  ZipStream: TStream;
  Stream: TStream;
  ZipHeader: TZipHeader;
  TextList: TStringList;
begin
  ZipStream := TMemoryStream.Create;
  http.get('http://localhost/OptimaChangeLogZip?select * from vorgang', ZipStream);
  ZipStream.Position := 0;
  fZip.Open(ZipStream, zmRead);
  fZip.Read('Data.txt', Stream, ZipHeader);
  TextList := TStringList.Create;
  Stream.Position := 0;
  TextList.LoadFromStream(Stream);
  Memo1.Lines.Add(TextList.Text);
  FreeAndNil(TextList);
  FreeAndNil(ZipStream);
end;


end.
