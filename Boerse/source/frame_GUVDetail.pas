unit frame_GUVDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, ExtCtrls, StdCtrls, Grids, DBGrids, o_AktieList, IBDatabase, DB,
  IBCustomDataSet, IBQuery, ComCtrls;

type
  Tfra_GUVDetail = class(TFrame)
    pnl_Left: TPanel;
    pnl_Client: TPanel;
    Splitter1: TSplitter;
    ListBox1: TListBox;
    Grid: TDBGrid;
    qry_GUVDetail: TIBQuery;
    ibt_GUVDetail: TIBTransaction;
    ds_GUVDetail: TDataSource;
    Panel1: TPanel;
    Label1: TLabel;
    edt_Gesamt: TEdit;
    qry_GUVDetailGesamt: TIBQuery;
    ibt_GUVGesamt: TIBTransaction;
    Panel2: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    edt_Von: TDateTimePicker;
    edt_Bis: TDateTimePicker;
    procedure ListBox1DblClick(Sender: TObject);
    procedure GridDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
  private
    FAktieList: TAktieList;
    procedure RefreshList;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeListBox;
  end;

implementation

{$R *.dfm}

uses
  untDM, o_nf;

{ TFrame1 }

constructor Tfra_GUVDetail.Create(AOwner: TComponent);
begin
  inherited;
  edt_Gesamt.Text := '0';
  FAktieList := TAktieList.Create(AOwner);
  edt_Von.DateTime := StrToDate(Tnf.GetInstance.RegIni.ReadIni(dm.IniSettings, 'GUVDetail', 'von', DateToStr(now)));
  edt_Bis.DateTime := StrToDate(Tnf.GetInstance.RegIni.ReadIni(dm.IniSettings, 'GUVDetail', 'bis', DateToStr(now)));
  LadeListBox;
end;

destructor Tfra_GUVDetail.Destroy;
begin
  try
    Tnf.GetInstance.RegIni.WriteIni(dm.IniSettings, 'GUVDetail', 'von', DateToStr(edt_Von.DateTime));
    Tnf.GetInstance.RegIni.WriteIni(dm.IniSettings, 'GUVDetail', 'bis', DateToStr(edt_Bis.DateTime));
  except
  end;
  FreeAndNil(FAktieList);
  inherited;
end;

procedure Tfra_GUVDetail.GridDrawDataCell(Sender: TObject; const Rect: TRect;
  Field: TField; State: TGridDrawState);
begin
  if SameText(Field.FieldName, 'gd_guvprz') then
    TFloatField(Field).DisplayFormat := '##0.0000'
  else
    if Field.DataType = ftFloat then
      TFloatField(Field).DisplayFormat := '#,##0.00';
end;

procedure Tfra_GUVDetail.LadeListBox;
var
  i1: Integer;
  sName: string;
begin
  ListBox1.Clear;
  FAktieList.LoadAll;
  for i1 := 0 to FAktieList.Count - 1 do
  begin
    sName := FAktieList.Aktie[i1].Name.AsString + ' ' + FAktieList.Aktie[i1].WKN.AsString;
    ListBox1.AddItem(sName, TObject(FAktieList.Aktie[i1].ID));
  end;
end;

procedure Tfra_GUVDetail.ListBox1DblClick(Sender: TObject);
begin
  RefreshList;
end;

procedure Tfra_GUVDetail.RefreshList;
begin
  Screen.Cursor := crHourGlass;
  try
    if ibt_GUVDetail.InTransaction then
      ibt_GUVDetail.Rollback;
    if ibt_GUVGesamt.InTransaction then
      ibt_GUVGesamt.Rollback;

    qry_GUVDetail.Close;
    qry_GUVDetail.SQL.Text := ' select gd_edatum as Einkaufsdatum, gd_stueck as Anzahl, gd_ewert as Kaufwert, gd_ekurs as kaufkurs, ' +
                              ' gd_vdatum as Verkaufsdatum, gd_vwert as Verkaufswert, gd_vkurs as Verkaufskurs, gd_guv as GuV, gd_guvprz ' +
                              ' from guvdetail' +
                              ' where gd_ak_id = ' + IntToStr(Integer(ListBox1.Items.Objects[Listbox1.ItemIndex])) +
                              ' and (gd_vdatum >= ' + QuotedStr(DateToStr(edt_von.DateTime)) +
                              ' and  gd_vdatum <= ' + QuotedStr(DateToStr(edt_bis.DateTime)) + ')' +
                              ' order by gd_vdatum desc';
    ibt_GUVDetail.StartTransaction;
    qry_GUVDetail.Open;

    qry_GUVDetailGesamt.Close;
    qry_GUVDetailGesamt.Sql.Text := ' select sum(gd_guv) from guvdetail' +
                                    ' where gd_ak_id = ' + IntToStr(Integer(ListBox1.Items.Objects[Listbox1.ItemIndex])) +
                                    ' and (gd_vdatum >= ' + QuotedStr(DateToStr(edt_von.DateTime)) +
                                    ' and  gd_vdatum <= ' + QuotedStr(DateToStr(edt_bis.DateTime)) + ')';
    qry_GUVDetailGesamt.Open;

    edt_Gesamt.Text := CurrToStr(qry_GUVDetailGesamt.Fields[0].AsCurrency);

    Grid.Columns[0].Title.Caption := 'Einkaufsdatum';
    Grid.Columns[1].Title.Caption := 'Stück';
    Grid.Columns[2].Title.Caption := 'Einkaufssumme';
    Grid.Columns[3].Title.Caption := 'Kaufkurs';
    Grid.Columns[4].Title.Caption := 'Verkaufsdatum';
    Grid.Columns[5].Title.Caption := 'Verkaufswert';
    Grid.Columns[6].Title.Caption := 'Verkaufskurs';
    Grid.Columns[7].Title.Caption := 'GuV';
    Grid.Columns[8].Title.Caption := 'GuV Prozent';

  finally
    Screen.Cursor := crDefault;
  end;
end;


end.
