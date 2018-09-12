unit Form.TestMySqlConnect;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Data.DB,
  mySQLDbTables, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    DBMySqlTSI: TMySQLDatabase;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    MySQLQuery1: TMySQLQuery;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure DBMySqlTSIConnectionFailure(Connection: TMySQLDatabase;
      Error: string);
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  DBMySqlTSI.Connect;
  MySQLQuery1.SQL.Text := 'select * from aktie';
  MySQLQuery1.Open;
end;

procedure TForm1.DBMySqlTSIConnectionFailure(Connection: TMySQLDatabase;
  Error: string);
begin
  Memo1.Clear;
  Memo1.Lines.Add(Error);
end;

end.
