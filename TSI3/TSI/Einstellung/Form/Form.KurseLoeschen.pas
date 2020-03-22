unit Form.KurseLoeschen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBObj.Boersenindex, DBObj.BoersenIndexList, DBObj.Aktie, DBObj.AktieList,
  IBX.IBDatabase, IBX.IBQuery, mySqlDBTables;

type
  Tfrm_KurseLoeschen = class(TForm)
    Panel2: TPanel;
    pnl_Boersenindex: TLabel;
    cbo_Boersenindex: TComboBox;
    lsb: TListBox;
    Panel1: TPanel;
    btn_KurseLoeschen: TButton;
    btn_Ok: TButton;
    btn_AlleKurseLoeschen: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbo_BoersenindexChange(Sender: TObject);
    procedure btn_KurseLoeschenClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure btn_AlleKurseLoeschenClick(Sender: TObject);
  private
    fBoersenindexList: TBoersenindexList;
    fBoersenindex: TBoersenindex;
    fAktieList: TAktieList;
    fAktie: TAktie;
    fQryMySqlD: TMySqlQuery;
    procedure LadeListBox;
    procedure Loeschen(aId: Integer);
  public
  end;

var
  frm_KurseLoeschen: Tfrm_KurseLoeschen;

implementation

{$R *.dfm}

uses
  Datamodul.TSI;


procedure Tfrm_KurseLoeschen.FormCreate(Sender: TObject);
begin
  fBoersenindexList := TBoersenindexList.Create(nil);
  fBoersenindexList.Trans := dm.IBT;
  fBoersenindex := TBoersenindex.Create(nil);
  fBoersenindex.Trans := dm.IBT;

  fAktieList := TAktieList.Create(nil);
  fAktieList.Trans := dm.IBT;

  fAktie := TAktie.Create(nil);
  fAktie.Trans := dm.IBT;

  fQryMySqlD := TMySqlQuery.Create(Self);



end;

procedure Tfrm_KurseLoeschen.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fBoersenindexList);
  FreeAndNil(fBoersenindex);
  FreeAndNil(fAktieList);
  FreeAndNil(fAktie);
  FreeAndNil(fQryMySqlD);
end;

procedure Tfrm_KurseLoeschen.FormShow(Sender: TObject);
begin
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  cbo_Boersenindex.ItemIndex := 0;

  LadeListBox;

  if not dm.ConnectMySql then
    ShowMessage('Connect zu MySql fehlgeschlagen')
  else
    fQryMySqlD.Database := dm.DBMySqlTSI;

end;

procedure Tfrm_KurseLoeschen.btn_AlleKurseLoeschenClick(Sender: TObject);
var
  s: string;
  i1: Integer;
  x: TAktie;
  Cur: TCursor;
begin
  s := 'Möchten Sie wirklich alle Kurse aller Aktien löschen?';

  if MessageDlg(s,  mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  Cur := Screen.Cursor;
  try
    Screen.Cursor := crHourglass;
    for i1 := 0 to lsb.Items.Count -1 do
    begin
      x := TAktie(lsb.Items.Objects[i1]);
      lsb.ItemIndex := i1;
      Application.ProcessMessages;
      Loeschen(x.Id);
    end;
  finally
    Screen.Cursor := Cur;
  end;


end;

procedure Tfrm_KurseLoeschen.btn_KurseLoeschenClick(Sender: TObject);
var
  s: string;
  x: TAktie;
begin
//  Loeschen;

  if lsb.ItemIndex < 0 then
    exit;
  x := TAktie(lsb.Items.Objects[lsb.ItemIndex]);
  s := 'Möchten Sie wirklich alle Kurse der Aktie ' + sLineBreak +
       '[' + x.WKN + '] ' + x.Aktie + sLineBreak +
       ' löschen?';

  if MessageDlg(s,  mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  Loeschen(x.Id);

end;

procedure Tfrm_KurseLoeschen.btn_OkClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_KurseLoeschen.cbo_BoersenindexChange(Sender: TObject);
begin
  LadeListBox;
end;


procedure Tfrm_KurseLoeschen.LadeListBox;
var
  i1: Integer;
  i2: Integer;
begin
  lsb.Clear;
  i2 := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);
  fAktieList.LeseAlleInBoersenindex(i2);

  for i1 := 0 to fAktieList.Count -1 do
  begin
    lsb.AddItem('[' + fAktieList.Item[i1].WKN + '] ' + fAktieList.Item[i1].Aktie, fAktieList.Item[i1]);
  end;


end;

procedure Tfrm_KurseLoeschen.Loeschen(aId: Integer);
var
  qry: TIBQuery;
begin
{
  if lsb.ItemIndex < 0 then
    exit;
  x := TAktie(lsb.Items.Objects[lsb.ItemIndex]);
  s := 'Möchten Sie wirklich alle Kurse der Aktie ' + sLineBreak +
       '[' + x.WKN + '] ' + x.Aktie + sLineBreak +
       ' löschen?';

  if MessageDlg(s,  mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;
 }
  fQryMySqlD.SQL.Text := 'delete from kurs where ku_ak_id = ' + IntToStr(aId);
  fQryMySqlD.ExecSQL;

  fQryMySqlD.SQL.Text := 'delete from tsi where ts_ak_id = ' + IntToStr(aId);
  fQryMySqlD.ExecSQL;

  fQryMySqlD.SQL.Text := 'delete from tsiansicht where ta_ak_id = ' + IntToStr(aId);
  fQryMySqlD.ExecSQL;


  qry := TIBQuery.Create(nil);
  try
    qry.Transaction := dm.IBT;
    if dm.IBT.InTransaction then
      dm.IBT.Commit;
    qry.SQL.Text := 'delete from kurs where ku_ak_id = ' + IntToStr(aId);
    qry.ExecSQL;
    qry.SQL.Text := 'delete from tsi where ts_ak_id = ' + IntToStr(aID);
    qry.ExecSQL;
    qry.SQL.Text := 'delete from tsilast where tl_ak_id = ' + IntToStr(aID);
    qry.ExecSQL;
  finally
    FreeAndNil(qry);
    if dm.IBT.InTransaction then
      dm.IBT.Commit;
  end;

end;

end.
