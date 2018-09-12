unit frameTransfer;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, Spin, ComCtrls, o_aktie, o_aktielist, o_Transfer,
  o_guvdetail;

type
  Tfra_Transfer = class(TFrame)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label7: TLabel;
    edt_Datum: TDateTimePicker;
    edt_Stueck: TSpinEdit;
    edt_Wert: TEdit;
    edt_Kurs: TEdit;
    Label4: TLabel;
    cbx_Aktie: TComboBox;
    Label5: TLabel;
    cbx_Aktion: TComboBox;
    procedure cbx_AktionChange(Sender: TObject);
  private
    FAktieList: TAktieList;
    procedure LoadCombobox;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Save;
  end;

implementation

{$R *.dfm}

uses
  untDM, untCalc, o_Bestand;

{ Tfra_Transfer }


constructor Tfra_Transfer.Create(AOwner: TComponent);
begin
  inherited;
  edt_Datum.DateTime := 0;
  edt_Stueck.Value := 0;
  edt_Kurs.Text := '';
  edt_Wert.Text := '';
  cbx_Aktie.Clear;
  cbx_Aktion.Clear;
  FAktieList := TAktieList.Create(AOwner);
  FAktieList.LoadAll;
  LoadCombobox;

  cbx_Aktion.Items.Add('Kauf');
  cbx_Aktion.Items.Add('Verkauf');

end;

destructor Tfra_Transfer.Destroy;
begin
  FreeAndNil(FAktieList);
  inherited;
end;

procedure Tfra_Transfer.LoadCombobox;
var
  i1: Integer;
  sName: string;
begin
  cbx_Aktie.Clear;
  for i1 := 0 to FAktieList.Count - 1 do
  begin
    sName := FAktieList.Aktie[i1].Name.AsString + ' ' + FAktieList.Aktie[i1].WKN.AsString;
    cbx_Aktie.AddItem(sName, TObject(FAktieList.Aktie[i1].ID));
  end;
end;

procedure Tfra_Transfer.Save;
var
  c: Currency;
  Transfer: TTransfer;
  //GUVDetail: TGUVDetail;
begin
  if cbx_Aktie.ItemIndex = -1 then
  begin
    ShowMessage('Aktie wurde nicht ausgewählt');
    cbx_Aktie.SetFocus;
    exit;
  end;

  if edt_Datum.DateTime = 0 then
  begin
    ShowMessage('Es wurde kein Datum ausgewählt');
    exit;
  end;

  if edt_Stueck.Value = 0 then
  begin
    ShowMessage('Anzahl darf nicht 0 sein.');
    edt_Stueck.SetFocus;
    exit;
  end;

  if not TryStrToCurr(edt_Wert.Text, c) then
  begin
    ShowMessage('Wert muss numerisch sein.');
    edt_Wert.SetFocus;
    exit;
  end;

  if cbx_Aktion.ItemIndex = -1 then
  begin
    ShowMessage('Es wurde keine Aktion ausgewählt');
    cbx_Aktion.SetFocus;
    exit;
  end;


  if dm.IBT.InTransaction then
    dm.IBT.Rollback;

  Transfer := TTransfer.Create(Self, dm.IBT);
  Transfer.AK_ID.AsInteger    := Integer(cbx_Aktie.Items.Objects[cbx_Aktie.ItemIndex]);
  Transfer.DATUM.AsDateTime   := edt_Datum.Date;
  Transfer.STUECK.AsInteger   := edt_Stueck.Value;
  Transfer.WERT.AsCurrency    := c;
  Transfer.KURS.AsCurrency    := Transfer.WERT.AsCurrency / Transfer.STUECK.AsInteger;
  Transfer.Korrektur.AsString := '';

  if cbx_Aktion.ItemIndex = 0 then
    Transfer.AKTION.AsString := 'K';

  if cbx_Aktion.ItemIndex = 1 then
    Transfer.AKTION.AsString := 'V';

  Transfer.Save;
  Transfer.Commit;
  FreeAndNil(Transfer);

  if dm.IBT.InTransaction then
    dm.IBT.Rollback;

  CalcDB(Integer(cbx_Aktie.Items.Objects[cbx_Aktie.ItemIndex]));

    {
  GUVDetail := TGUVDetail.Create(Self, dm.IBT);
  try
    GUVDetail.Reload(Integer(cbx_Aktie.Items.Objects[cbx_Aktie.ItemIndex]));
  finally
    FreeAndNil(GUVDetail);
  end;
    }


end;

procedure Tfra_Transfer.cbx_AktionChange(Sender: TObject);
var
  i1: Integer;
  Bestand: TBestand;
  Cur: TCursor;
begin
  Cur := Screen.Cursor;
  Bestand := TBestand.Create(Self, dm.IBT);
  try
    Screen.Cursor := crHourglass;
    LoadCombobox;
    if cbx_Aktion.Text = 'Verkauf' then
    begin
      for i1 := cbx_Aktie.Items.Count - 1 downto 0 do
      begin
        Bestand.ReadA(Integer(cbx_Aktie.Items.Objects[i1]));
        if not Bestand.Found then
          cbx_Aktie.Items.Delete(i1);
        if (Bestand.Found) and (Bestand.STUECK.AsCurrency <= 0) then
          cbx_Aktie.Items.Delete(i1);
      end;
    end;
  finally
    FreeAndNil(Bestand);
    Screen.Cursor := Cur;
  end;
end;


end.
