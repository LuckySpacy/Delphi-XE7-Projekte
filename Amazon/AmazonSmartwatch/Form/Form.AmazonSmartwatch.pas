unit Form.AmazonSmartwatch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  IdIOHandler, IdIOHandlerStream, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL;

type
  Tfrm_AmazonSmartwatch = class(TForm)
    pnl_TopButton: TPanel;
    pnl_Link: TPanel;
    pnl_Client: TPanel;
    btn_Einlesen: TButton;
    edt_Link: TEdit;
    Memo1: TMemo;
    http: TIdHTTP;
    IdIOHandlerStream1: TIdIOHandlerStream;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_EinlesenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    fASIN_All: TStringList;
    fASIN_Offen: TStringList;
    fASIN_Erfasst: TStringList;
    procedure AlleSeitenEinlesen;
    //procedure ASIN_Einlesen(aFilename: string);
    procedure ASIN_FromString(aValue: string; aStrings: TStrings);
    procedure CheckOffen;
  public
  end;

var
  frm_AmazonSmartwatch: Tfrm_AmazonSmartwatch;

implementation

{$R *.dfm}

uses
  dm.Datenmodul;


procedure Tfrm_AmazonSmartwatch.FormCreate(Sender: TObject);
begin  //
  fASIN_All := TStringList.Create;
  fASIN_All.Duplicates := dupIgnore;
  fASIN_All.Sorted := true;
  fASIN_Offen := TStringList.Create;
  fASIN_Erfasst := TStringList.Create;
  dam := TDAM.Create(Self);
end;

procedure Tfrm_AmazonSmartwatch.FormDestroy(Sender: TObject);
begin //
  FreeAndNil(fASIN_All);
  FreeAndNil(fASIN_Offen);
  FreeAndNil(fASIN_Erfasst);
  FreeAndNil(dam);
end;



procedure Tfrm_AmazonSmartwatch.FormShow(Sender: TObject);
begin
  dam.Connect;
end;

procedure Tfrm_AmazonSmartwatch.btn_EinlesenClick(Sender: TObject);
begin
  //href="/IP68-Fitness-Tracker-Smart-Watch-Rose-Gold/dp/B07SC129MN?dchild=1
  //Die ASIN Nummer liegt zwischen /dp/ und ?
  Screen.Cursor := crHourGlass;
  AlleSeitenEinlesen;
  CheckOffen;
  Screen.Cursor := crDefault;
  //ASIN_Einlesen('c:\Bachmann\Delphi\Delphi XE7\Projekte\Amazon\AmazonSmartwatch\bin\x.html');
end;


procedure Tfrm_AmazonSmartwatch.CheckOffen;
var
  i1: Integer;
  Pfad: string;
begin
  Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  fASIN_Offen.Clear;
  dam.qry.SQL.Text := 'select fa_id from firmaartikel where fa_fi_id = 1 and fa_nr = :nr';
  for i1 := 0 to fASIN_All.Count -1 do
  begin
    dam.qry.Close;
    dam.qry.ParamByName('nr').AsString := fASIN_All.Strings[i1];
    dam.qry.Open;
    if dam.qry.Eof then
      fASIN_Offen.Add(fASIN_All.Strings[i1])
    else
      fASIN_Erfasst.Add(fASIN_All.Strings[i1]);
  end;
  fASIN_All.SaveToFile(Pfad + 'ASIN_ALL.txt');
  fASIN_Offen.SaveToFile(Pfad + 'ASIN_OFFEN.txt');
  fASIN_Erfasst.SaveToFile(Pfad + 'ASIN_ERFASST.txt');
end;

procedure Tfrm_AmazonSmartwatch.AlleSeitenEinlesen;
var
  i1, i2: Integer;
  Filename: string;
  Pfad: string;
  m: TMemoryStream;
  Link: string;
  LinkBasis: string;
  List: TStringList;
begin
  HTTP.HandleRedirects := True;
  Pfad := 'c:\Bachmann\Delphi\Delphi XE7\Projekte\Amazon\AmazonSmartwatch\bin\';
  linkBasis := 'https://www.amazon.de/smartwatch/s?k=smartwatch&amp;page=';
  List := TStringList.Create;

  for i1 := 1 to 2 do
  begin
    Link := LinkBasis + IntToStr(i1);
    Filename := Pfad + 'x' + IntToStr(i1) + '.html';
    m := TMemoryStream.Create;
    http.Get(Link, m);
    m.Position := 0;
    List.LoadFromStream(m);
    for i2 := 0 to List.Count -1 do
      ASIN_FromString(List.Strings[i2], fASIN_All);
    List.Clear;
    //m.SaveToFile(Filename);
    FreeAndNil(m);
  end;
  Memo1.Lines.Clear;
  Memo1.Lines.AddStrings(fASIN_All);

  FreeAndNil(List);

end;

{
procedure Tfrm_AmazonSmartwatch.ASIN_Einlesen(aFilename: string);
var
  List: TStringList;
  i1: Integer;
begin
  List := TStringList.Create;
  try
    List.LoadFromFile(aFilename);
    for i1 := 0 to List.Count -1 do
    begin
      ASIN_FromString(List.Strings[i1], fASIN_All);
    end;
  finally
    FreeAndNil(List);
  end;

  Memo1.Lines.Clear;
  Memo1.Lines.AddStrings(fASIN_All);

end;
 }

procedure Tfrm_AmazonSmartwatch.ASIN_FromString(aValue: string;
  aStrings: TStrings);
var
  s: string;
  iPos: Integer;
  Asin: string;
begin
  s := aValue;
  iPos := Pos('/dp/', aValue);
  while iPos > 0 do
  begin
    s := copy(s, iPos+4, Length(s));
    iPos := Pos('?', s);
    if iPos > 0 then
    begin
      Asin := copy(s, 1, ipos-1);
      s := copy(s, ipos+1, length(s));
      aStrings.Add(Asin);
    end;
    iPos := Pos('/dp/', s);
  end;
end;

end.
