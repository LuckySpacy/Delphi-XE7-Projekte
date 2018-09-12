unit frame_Transferlist;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ExtCtrls, o_AktieList, Grids, DBGrids, DB, IBCustomDataSet,
  IBQuery, Menus, IBDatabase;

type
  Tfra_Transferlist = class(TFrame)
    pnl_Left: TPanel;
    pnl_Client: TPanel;
    Splitter1: TSplitter;
    ListBox1: TListBox;
    pnl_Top: TPanel;
    pnl_Bottom: TPanel;
    Splitter2: TSplitter;
    Grid_Kauf: TDBGrid;
    Grid_Verkauf: TDBGrid;
    qry_Kauf: TIBQuery;
    qry_Verkauf: TIBQuery;
    ds_Kauf: TDataSource;
    ds_Verkauf: TDataSource;
    Popup_Kauf: TPopupMenu;
    mnu_DeleteKauf: TMenuItem;
    ibt_Kauf: TIBTransaction;
    ibt_Verkauf: TIBTransaction;
    ibt_Delete: TIBTransaction;
    qry_delete: TIBQuery;
    PopupVekauf: TPopupMenu;
    mnu_DeleteVerkauf: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Popup_Aktie: TPopupMenu;
    mnu_calc: TMenuItem;
    mnu_Gutschrift: TMenuItem;
    mnu_Splitt: TMenuItem;
    KalkJahrMonatBilanz: TMenuItem;
    procedure ListBox1DblClick(Sender: TObject);
    procedure mnu_DeleteKaufClick(Sender: TObject);
    procedure mnu_DeleteVerkaufClick(Sender: TObject);
    procedure mnu_calcClick(Sender: TObject);
    procedure Grid_KaufDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure Grid_VerkaufDrawDataCell(Sender: TObject; const Rect: TRect;
      Field: TField; State: TGridDrawState);
    procedure mnu_GutschriftClick(Sender: TObject);
    procedure mnu_SplittClick(Sender: TObject);
    procedure KalkJahrMonatBilanzClick(Sender: TObject);
  private
    FAktieList: TAktieList;
    procedure RefreshList;
    procedure DeleteTransfer(aId: Integer);
    procedure ShowGutschrift;
    procedure ShowSplitt;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeListBox;
  end;

implementation

{$R *.dfm}

uses
  untDM, untCalc, fntGutschrift, o_transfer, fntSplitt;

{ Tfra_Transferlist }

constructor Tfra_Transferlist.Create(AOwner: TComponent);
begin
  inherited;
  FAktieList := TAktieList.Create(AOwner);
  LadeListBox;
end;


destructor Tfra_Transferlist.Destroy;
begin
  FreeAndNil(FAktieList);
  inherited;
end;

procedure Tfra_Transferlist.Grid_KaufDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
 // if Field.DataType = ftFloat then
 //   TFloatField(Field).DisplayFormat := '#,##0.00';
  if SameText(Field.FieldName, 'tr_kurs')  then
    TFloatField(Field).DisplayFormat := '#,##0.0000'
  else
   if Field.DataType = ftFloat then
     TFloatField(Field).DisplayFormat := '#,##0.00';
end;

procedure Tfra_Transferlist.Grid_VerkaufDrawDataCell(Sender: TObject;
  const Rect: TRect; Field: TField; State: TGridDrawState);
begin
  //if Field.DataType = ftFloat then
  //  TFloatField(Field).DisplayFormat := '#,##0.00';
  if SameText(Field.FieldName, 'tr_kurs')  then
    TFloatField(Field).DisplayFormat := '#,##0.0000'
  else
    if Field.DataType = ftFloat then
      TFloatField(Field).DisplayFormat := '#,##0.00';
end;

procedure Tfra_Transferlist.KalkJahrMonatBilanzClick(Sender: TObject);
begin
  Calc_BilanzJMDet;
end;

procedure Tfra_Transferlist.LadeListBox;
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

procedure Tfra_Transferlist.ListBox1DblClick(Sender: TObject);
begin
  RefreshList;
end;

procedure Tfra_Transferlist.mnu_calcClick(Sender: TObject);
begin
  CalcDB(Integer(ListBox1.Items.Objects[Listbox1.ItemIndex]));
end;

procedure Tfra_Transferlist.mnu_DeleteKaufClick(Sender: TObject);
begin
  if not MessageDlg('Wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  DeleteTransfer(qry_Kauf.FieldByName('tr_id').AsInteger);
end;

procedure Tfra_Transferlist.mnu_DeleteVerkaufClick(Sender: TObject);
begin
  if not MessageDlg('Wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
   DeleteTransfer(qry_Verkauf.FieldByName('tr_id').AsInteger);
end;

procedure Tfra_Transferlist.mnu_GutschriftClick(Sender: TObject);
begin
  ShowGutschrift;
end;

procedure Tfra_Transferlist.mnu_SplittClick(Sender: TObject);
begin
  ShowSplitt;
end;

procedure Tfra_Transferlist.DeleteTransfer(aId: Integer);
begin
  if ibt_Delete.InTransaction then
    ibt_Delete.Rollback;
  ibt_Delete.StartTransaction;
  try
    qry_delete.SQL.Text := 'delete from transfer where tr_id = ' + IntToStr(aId);
    qry_delete.ExecSQL;
  finally
    ibt_Delete.Commit;
  end;
  RefreshList;
end;


procedure Tfra_Transferlist.RefreshList;
begin
  Screen.Cursor := crHourGlass;
  try
    if ibt_Kauf.InTransaction then
      ibt_Kauf.Rollback;

    qry_Kauf.Close;
    qry_Kauf.SQL.Text := ' select tr_id, tr_datum, tr_stueck, tr_wert, tr_kurs, tr_korrektur from transfer' +
                         ' where tr_aktion = ' + QuotedStr('K') +
                         ' and   tr_ak_id = ' + IntToStr(Integer(ListBox1.Items.Objects[Listbox1.ItemIndex])) +
                         ' order by tr_datum desc, tr_id desc';
    ibt_Kauf.StartTransaction;
    qry_Kauf.Open;


    if ibt_Verkauf.InTransaction then
      ibt_Verkauf.Rollback;
    qry_Verkauf.Close;
    qry_Verkauf.SQL.Text := ' select tr_id, tr_datum, tr_stueck, tr_wert, tr_kurs from transfer' +
                         ' where tr_aktion = ' + QuotedStr('V') +
                         ' and   tr_ak_id = ' + IntToStr(Integer(ListBox1.Items.Objects[Listbox1.ItemIndex])) +
                         ' order by tr_datum desc, tr_id desc';
    ibt_Verkauf.StartTransaction;
    qry_Verkauf.Open;

    Grid_Kauf.Columns[0].Title.Caption := 'ID';
    Grid_Kauf.Columns[1].Title.Caption := 'Datum';
    Grid_Kauf.Columns[2].Title.Caption := 'Stück';
    Grid_Kauf.Columns[3].Title.Caption := 'Einkaufssumme';
    Grid_Kauf.Columns[4].Title.Caption := 'Kurs';
    Grid_Kauf.Columns[5].Title.Caption := 'Korrektur';

    Grid_Verkauf.Columns[0].Title.Caption := 'ID';
    Grid_Verkauf.Columns[1].Title.Caption := 'Datum';
    Grid_Verkauf.Columns[2].Title.Caption := 'Stück';
    Grid_Verkauf.Columns[3].Title.Caption := 'Verkaufssumme';
    Grid_Verkauf.Columns[4].Title.Caption := 'Kurs';


  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Tfra_Transferlist.ShowGutschrift;
var
  Form: Tfrm_Gutschrift;
  Transfer: TTransfer;
  AktieId : Int64;
begin
  Transfer := TTransfer.Create(Self, dm.IBT);
  Form := Tfrm_Gutschrift.Create(Self);
  try
    Transfer.ReadId(qry_Kauf.FieldByName('tr_id').AsInteger);
    Form.edt_Aktie.Text   := Transfer.Aktie.Name.AsString;
    Form.edt_Stueck.Value := qry_Kauf.FieldByName('tr_stueck').AsInteger;
    Form.edt_Wert.Text    := qry_Kauf.FieldByName('tr_wert').AsString;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    Transfer.Korrektur.AsString := 'Gutschrift';
    AktieId := Transfer.Aktie.ID;
    Transfer.Save;
    Transfer.Commit;
    Transfer.Init;
    Transfer.AK_ID.AsInteger    := AktieId;
    Transfer.Aktion.AsString    := 'K';
    Transfer.Datum.AsDateTime   := Form.edt_Datum.DateTime;
    Transfer.Stueck.AsInteger   := Form.edt_Stueck.Value;
    Transfer.Wert.AsCurrency    := StrToCurr(Form.edt_Wert.Text);
    Transfer.Kurs.AsCurrency    := Transfer.Wert.AsCurrency / Transfer.Stueck.AsInteger;
    Transfer.Korrektur.AsString := '';
    Transfer.Save;
    Transfer.Commit;
    CalcDB(AktieId);
  finally
    FreeAndNil(Transfer);
    FreeAndNil(Form);
  end;
end;

procedure Tfra_Transferlist.ShowSplitt;
var
  Form: Tfrm_Splitt;
  Transfer: TTransfer;
  AktieId : Int64;
begin
  Transfer := TTransfer.Create(Self, dm.IBT);
  Form := Tfrm_Splitt.Create(Self);
  try
    Transfer.ReadId(qry_Kauf.FieldByName('tr_id').AsInteger);
    Form.edt_Aktie.Text   := Transfer.Aktie.Name.AsString;
    Form.edt_Stueck.Value := qry_Kauf.FieldByName('tr_stueck').AsInteger;
    Form.edt_Wert.Text    := qry_Kauf.FieldByName('tr_wert').AsString;
    Form.ShowModal;
    if Form.Cancel then
      exit;
    Transfer.Korrektur.AsString := 'Splitt';
    AktieId := Transfer.Aktie.ID;
    Transfer.Save;
    Transfer.Commit;
    Transfer.Init;
    Transfer.AK_ID.AsInteger    := AktieId;
    Transfer.Aktion.AsString    := 'K';
    Transfer.Datum.AsDateTime   := Form.edt_Datum.DateTime;
    Transfer.Stueck.AsInteger   := Form.edt_Stueck.Value;
    Transfer.Wert.AsCurrency    := StrToCurr(Form.edt_Wert.Text);
    Transfer.Kurs.AsCurrency    := Transfer.Wert.AsCurrency / Transfer.Stueck.AsInteger;
    Transfer.Korrektur.AsString := '';
    Transfer.Save;
    Transfer.Commit;
    CalcDB(AktieId);
  finally
    FreeAndNil(Transfer);
    FreeAndNil(Form);
  end;
end;

end.

