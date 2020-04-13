unit Form.WebClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Objekt.WebClient,
  System.UITypes;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btn_OptimaChangeLog: TButton;
    Memo: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_OptimaChangeLogClick(Sender: TObject);
  private
    fWebClient: TWebClient;
  public
    procedure WebserverConnectError(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  Memo.Clear;
  fWebClient := TWebClient.Create(nil);
  fWebClient.OnWebserverConnectError := WebserverConnectError;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fWebClient);
end;


procedure TForm1.WebserverConnectError(Sender: TObject);
begin
  MessageDlg('Webserver ist nicht erreichbar.', mtError, [mbOk], 0);
end;

procedure TForm1.btn_OptimaChangeLogClick(Sender: TObject);
var
  stream: TMemoryStream;
  List: TStringList;
  Param: string;
begin
  List := TStringList.Create;
  stream := TMemoryStream.Create;
  //Param := List.Text;
  Param := 'select * from kunde';
  fWebClient.get('http://localhost/', 'OptimaChangeLog', Param, Stream);
  if Stream.Size > 0 then
  begin
    List.Clear;
    List.LoadFromStream(Stream);
    Memo.Lines.Add(List.Text);
  end;

  FreeAndNil(Stream);
  FreeAndNil(List);
end;


end.
