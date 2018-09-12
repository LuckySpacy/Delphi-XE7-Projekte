unit Form.KurseLoeschen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBObj.Boersenindex, DBObj.BoersenIndexList, DBObj.Aktie, DBObj.AktieList,
  IBX.IBDatabase, IBX.IBQuery;

type
  Tfrm_KurseLoeschen = class(TForm)
    Panel2: TPanel;
    pnl_Boersenindex: TLabel;
    cbo_Boersenindex: TComboBox;
    lsb: TListBox;
    Panel1: TPanel;
    btn_KurseLoeschen: TButton;
    btn_Ok: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbo_BoersenindexChange(Sender: TObject);
    procedure btn_KurseLoeschenClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    fBoersenindexList: TBoersenindexList;
    fBoersenindex: TBoersenindex;
    fAktieList: TAktieList;
    fAktie: TAktie;
    procedure LadeListBox;
    procedure Loeschen;
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


end;

procedure Tfrm_KurseLoeschen.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fBoersenindexList);
  FreeAndNil(fBoersenindex);
  FreeAndNil(fAktieList);
  FreeAndNil(fAktie);
end;

procedure Tfrm_KurseLoeschen.FormShow(Sender: TObject);
begin
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  cbo_Boersenindex.ItemIndex := 0;

  LadeListBox;
end;

procedure Tfrm_KurseLoeschen.btn_KurseLoeschenClick(Sender: TObject);
begin
  Loeschen;
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

procedure Tfrm_KurseLoeschen.Loeschen;
var
  s: string;
  x: TAktie;
  qry: TIBQuery;
begin
  if lsb.ItemIndex < 0 then
    exit;
  x := TAktie(lsb.Items.Objects[lsb.ItemIndex]);
  s := 'Möchten Sie wirklich alle Kurse der Aktie ' + sLineBreak +
       '[' + x.WKN + '] ' + x.Aktie + sLineBreak +
       ' löschen?';

  if MessageDlg(s,  mtConfirmation, [mbYes, mbNo], 0) <> mrYes then
    exit;

  qry := TIBQuery.Create(nil);
  try
    qry.Transaction := dm.IBT;
    if dm.IBT.InTransaction then
      dm.IBT.Commit;
    qry.SQL.Text := 'delete from kurs where ku_ak_id = ' + IntToStr(x.Id);
    qry.ExecSQL;
    qry.SQL.Text := 'delete from tsi where ts_ak_id = ' + IntToStr(x.ID);
    qry.ExecSQL;
    qry.SQL.Text := 'delete from tsilast where tl_ak_id = ' + IntToStr(x.ID);
    qry.ExecSQL;
  finally
    FreeAndNil(qry);
    if dm.IBT.InTransaction then
      dm.IBT.Commit;
  end;

end;

end.
