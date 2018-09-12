unit frame_bilanz;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Spin, Grids, DBGrids, DB, IBDatabase,
  IBCustomDataSet, IBQuery;

type
  Tfra_Bilanz = class(TFrame)
    pnl_top: TPanel;
    pnl_Client: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    edt_VonJahr: TSpinEdit;
    edt_BisJahr: TSpinEdit;
    Grid: TDBGrid;
    pnl_Right: TPanel;
    Label3: TLabel;
    edt_Gesamt: TEdit;
    qry_Bilanz: TIBQuery;
    ibt_Bilanz: TIBTransaction;
    ds_Bilanz: TDataSource;
    qry_BilanzSumme: TIBQuery;
    ibt_Bilanzsumme: TIBTransaction;
    cmd_Actual: TButton;
    Label4: TLabel;
    edt_Gewinnsumme: TEdit;
    Label5: TLabel;
    edt_Verlustsumme: TEdit;
    Label6: TLabel;
    edt_GesamtProzent: TEdit;
    Label7: TLabel;
    edt_SummeEK: TEdit;
    Label8: TLabel;
    edt_SummeVK: TEdit;
    chb_Zusammen: TCheckBox;
    procedure cmd_ActualClick(Sender: TObject);
    procedure GridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure GridTitleClick(Column: TColumn);
  private
    FOrderBy: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeGrid;
  end;

implementation

uses
  untDM, DateUtils, o_nf;

{$R *.dfm}

{ TFrame1 }


constructor Tfra_Bilanz.Create(AOwner: TComponent);
begin
  inherited;
  FOrderBy := '';
  edt_Gesamt.Text := '0';
  edt_VonJahr.Value := StrToInt(Tnf.GetInstance.RegIni.ReadIni(dm.IniSettings, 'Bilanz', 'von', IntToStr(YearOf(now))));
  edt_BisJahr.Value := StrToInt(Tnf.GetInstance.RegIni.ReadIni(dm.IniSettings, 'Bilanz', 'bis', IntToStr(YearOf(now))));
  LadeGrid;
end;

destructor Tfra_Bilanz.Destroy;
begin
  try
    Tnf.GetInstance.RegIni.WriteIni(dm.IniSettings, 'Bilanz', 'von', IntToStr(edt_VonJahr.Value));
    Tnf.GetInstance.RegIni.WriteIni(dm.IniSettings, 'Bilanz', 'bis', IntToStr(edt_BisJahr.Value));
  except
  end;
  inherited;
end;

procedure Tfra_Bilanz.GridDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
  if Field.DataType = ftFloat then
    TFloatField(Field).DisplayFormat := '#,##0.00';
end;

procedure Tfra_Bilanz.GridTitleClick(Column: TColumn);
begin
  FOrderBy := Column.FieldName + ' desc';
  LadeGrid;
end;

procedure Tfra_Bilanz.cmd_ActualClick(Sender: TObject);
begin
  LadeGrid;
end;


procedure Tfra_Bilanz.LadeGrid;
var
  Gewinn: Currency;
begin
  qry_Bilanz.Close;
  qry_BilanzSumme.Close;
  if ibt_Bilanz.InTransaction then
    ibt_Bilanz.Rollback;
  if ibt_BilanzSumme.InTransaction then
    ibt_BilanzSumme.Rollback;

  if not chb_Zusammen.Checked then
  begin
    qry_Bilanz.SQL.Text := ' select ak_wkn as wkn, ak_name as name, ' +
                           ' bi_jahr, bi_guv, bi_guvprz, bi_ewert, bi_vwert' +
                           ' from aktie, bilanz' +
                           ' where bi_ak_id = ak_id' +
                           ' and bi_ewert > 0' +
                           ' and (bi_jahr >= ' + IntToStr(edt_VonJahr.Value) +
                           ' and bi_jahr <= ' + IntToStr(edt_BisJahr.Value) + ')';
    if FOrderBy = '' then
      qry_Bilanz.SQL.Text := qry_Bilanz.SQL.Text + ' order by bi_jahr desc, ak_name'
    else
      qry_Bilanz.SQL.Text := qry_Bilanz.SQL.Text + ' order by bi_jahr desc, ' + FOrderBy + ', ak_name';
  end
  else
  begin
    qry_Bilanz.SQL.Text := ' select ak_wkn as wkn, ak_name as name, ' +
                           ' sum(bi_guv), sum(bi_guv), sum(bi_guv) * 100 / sum(bi_vwert), sum(bi_vwert)' +
                           ' from aktie, bilanz' +
                           ' where bi_ak_id = ak_id' +
                           ' and bi_ewert > 0' +
                           ' and (bi_jahr >= ' + IntToStr(edt_VonJahr.Value) +
                           ' and bi_jahr <= ' + IntToStr(edt_BisJahr.Value) + ')';
    if FOrderBy = '' then
      qry_Bilanz.SQL.Text := qry_Bilanz.SQL.Text + ' group by ak_name, ak_wkn'
    else
      qry_Bilanz.SQL.Text := qry_Bilanz.SQL.Text + ' group by ' + FOrderBy + ', ak_name, ak_wkn';
  end;

  qry_BilanzSumme.SQL.Text := ' select sum(bi_guv) from bilanz' +
                              ' where (bi_jahr >= ' + IntToStr(edt_VonJahr.Value) +
                              ' and bi_jahr <= ' + IntToStr(edt_BisJahr.Value) + ')';

  qry_Bilanz.Open;
  qry_BilanzSumme.Open;

  if not chb_Zusammen.Checked then
  begin
    Grid.Columns[0].Title.Caption := 'WKN';
    Grid.Columns[1].Title.Caption := 'Name';
    Grid.Columns[2].Title.Caption := 'Jahr';
    Grid.Columns[3].Title.Caption := 'GuV';
    Grid.Columns[4].Title.Caption := 'GuV Prozent';
    Grid.Columns[5].Title.Caption := 'Einkaufswert';
    Grid.Columns[6].Title.Caption := 'Verkaufswert';
  end
  else
  begin
    Grid.Columns[0].Title.Caption := 'WKN';
    Grid.Columns[1].Title.Caption := 'Name';
    Grid.Columns[2].Title.Caption := 'GuV';
    Grid.Columns[3].Title.Caption := 'GuV Prozent';
    Grid.Columns[4].Title.Caption := 'Einkaufswert';
    Grid.Columns[5].Title.Caption := 'Verkaufswert';
  end;


  edt_Gesamt.Text := CurrToStr(qry_BilanzSumme.Fields[0].AsCurrency);
  Gewinn := qry_BilanzSumme.Fields[0].AsCurrency;

  if ibt_Bilanzsumme.InTransaction then
    ibt_Bilanzsumme.Rollback;

  qry_BilanzSumme.close;
  qry_BilanzSumme.SQL.Text := ' select sum(bi_guv), sum(bi_ewert), sum(bi_vwert) from bilanz' +
                              ' where (bi_jahr >= ' + IntToStr(edt_VonJahr.Value) +
                              ' and bi_jahr <= ' + IntToStr(edt_BisJahr.Value) + ')' +
                              ' and bi_guv > 0';
  qry_BilanzSumme.Open;
  edt_Gewinnsumme.Text   := CurrToStr(qry_BilanzSumme.Fields[0].AsCurrency);

  qry_BilanzSumme.close;
  qry_BilanzSumme.SQL.Text := ' select sum(bi_guv), sum(bi_ewert), sum(bi_vwert) from bilanz' +
                              ' where (bi_jahr >= ' + IntToStr(edt_VonJahr.Value) +
                              ' and bi_jahr <= ' + IntToStr(edt_BisJahr.Value) + ')';
  qry_BilanzSumme.Open;

  edt_GesamtProzent.Text := FloatToStr((Gewinn * 100) / qry_BilanzSumme.Fields[1].AsCurrency);
  edt_SummeEK.Text       := CurrToStr(qry_BilanzSumme.Fields[1].AsCurrency);
  edt_SummeVK.Text       := CurrToStr(qry_BilanzSumme.Fields[2].AsCurrency);


  if ibt_Bilanzsumme.InTransaction then
    ibt_Bilanzsumme.Rollback;

  qry_BilanzSumme.close;
  qry_BilanzSumme.SQL.Text := ' select sum(bi_guv) from bilanz' +
                              ' where (bi_jahr >= ' + IntToStr(edt_VonJahr.Value) +
                              ' and bi_jahr <= ' + IntToStr(edt_BisJahr.Value) + ')' +
                              ' and bi_guv < 0';
  qry_BilanzSumme.Open;
  edt_Verlustsumme.Text := CurrToStr(qry_BilanzSumme.Fields[0].AsCurrency);


  if ibt_Bilanzsumme.InTransaction then
    ibt_Bilanzsumme.Rollback;


end;

end.
