unit Form.WebClient;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Objekt.WebClient,
  System.UITypes, WebQuery;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    btn_OptimaChangeLog: TButton;
    Memo: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_OptimaChangeLogClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    fWebClient: TWebClient;
    fWebQuery: TWebQuery;
    procedure ShowData(aValue: string);
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
  fWebQuery := TWebQuery.Create(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fWebClient);
  FreeAndNil(fWebQuery);
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
  Param := 'select * from kunde where ku_name = ' + QuotedStr('ÄÄ') + ' order by ku_name';
  fWebClient.get('http://localhost/', 'OptimaChangeLog', Param, Stream);
  if Stream.Size > 0 then
  begin
    List.Clear;
    List.LoadFromStream(Stream);
    //Memo.Lines.Add(List.Text);
    if List.Strings[0] = 'Dynamic SQL Error' then
      MessageDlg(List.Text, mtError, [mbOk], 0)
    else
      ShowData(List.Text);
  end;

  FreeAndNil(Stream);
  FreeAndNil(List);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  s: string;
  List: TStringList;
begin
  List := TStringList.Create;
  List.Add('KU_ID# #8# #4# #KU_NR# #8# #4# #KU_NAME# #37# #40# #KU_DELETE# #14# #1# #');
  List.Add('1# #0# #Alle# #F# #');
  List.Add('18# #1# #Niemand# #F# #');
  fWebQuery.Open(List.Text);
  while not fWebQuery.eof do
  begin
    Memo.Lines.Add(fWebQuery.FieldByName('KU_ID').AsString + ' / ' + fWebQuery.FieldByName('KU_NAME').AsString);
    fWebQuery.Next;
  end;
  FreeAndNil(List);
end;


procedure TForm1.ShowData(aValue: string);
begin
  fWebQuery.Open(aValue);
  while not fWebQuery.eof do
  begin
    Memo.Lines.Add(fWebQuery.FieldByName('KU_ID').AsString + ' / ' + fWebQuery.FieldByName('KU_NAME').AsString);
    fWebQuery.Next;
  end;
end;




end.
