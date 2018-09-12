unit m_Base;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, tbButton, ExtCtrls, Spin, Mask, o_Base, o_Basen,
  o_Einheit, Buttons, fnt_EntfernungLaufzeit;

type
  Tfra_Base = class(TFrame)
    pnl_Basename: TPanel;
    cbo_Base: TComboBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edt_Dauer_Scout: TMaskEdit;
    edt_Anz_Scout: TSpinEdit;
    GroupBox2: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    edt_Dauer_Ranger: TMaskEdit;
    edt_Anz_Ranger: TSpinEdit;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    Label6: TLabel;
    edt_Dauer_Gunner: TMaskEdit;
    edt_Anz_Gunner: TSpinEdit;
    GroupBox4: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    edt_Dauer_Knocker: TMaskEdit;
    edt_Anz_Knocker: TSpinEdit;
    GroupBox5: TGroupBox;
    Label9: TLabel;
    Label10: TLabel;
    edt_Dauer_Mortar: TMaskEdit;
    edt_Anz_Mortar: TSpinEdit;
    GroupBox6: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    edt_Dauer_Molotov: TMaskEdit;
    edt_Anz_Molotov: TSpinEdit;
    GroupBox7: TGroupBox;
    Label13: TLabel;
    Label14: TLabel;
    edt_Dauer_Biker: TMaskEdit;
    edt_Anz_Biker: TSpinEdit;
    GroupBox8: TGroupBox;
    Label15: TLabel;
    Label16: TLabel;
    edt_Dauer_Trike: TMaskEdit;
    edt_Anz_Trike: TSpinEdit;
    GroupBox9: TGroupBox;
    Label17: TLabel;
    Label18: TLabel;
    edt_Dauer_Buggy: TMaskEdit;
    edt_Anz_Buggy: TSpinEdit;
    GroupBox10: TGroupBox;
    Label19: TLabel;
    Label20: TLabel;
    edt_Dauer_Pickup: TMaskEdit;
    edt_Anz_Pickup: TSpinEdit;
    GroupBox11: TGroupBox;
    Label21: TLabel;
    Label22: TLabel;
    edt_Dauer_Carrack: TMaskEdit;
    edt_Anz_Carrack: TSpinEdit;
    GroupBox12: TGroupBox;
    Label23: TLabel;
    edt_Entfernung: TSpinEdit;
    GroupBox13: TGroupBox;
    cbx_Rauchsignal: TCheckBox;
    cbx_Sprechfunk: TCheckBox;
    GroupBox14: TGroupBox;
    Label24: TLabel;
    edt_Punkte: TSpinEdit;
    btn_Entfernung_Bestaetigen: TTBButton;
    btn_Laufzeitberechnen: TTBButton;
    btn_Next: TTBButton;
    btn_Prior: TTBButton;
    cbx_Scout: TCheckBox;
    cbx_Ranger: TCheckBox;
    cbx_Gunner: TCheckBox;
    cbx_Knocker: TCheckBox;
    cbx_Mortar: TCheckBox;
    cbx_Molotov: TCheckBox;
    cbx_Biker: TCheckBox;
    cbx_Trike: TCheckBox;
    cbx_Buggy: TCheckBox;
    cbx_Pickup: TCheckBox;
    cbx_Carrack: TCheckBox;
    procedure cbo_BaseChange(Sender: TObject);
    procedure edt_AnzahlExit(Sender: TObject);
    procedure cbx_RauchsignalClick(Sender: TObject);
    procedure cbx_SprechfunkClick(Sender: TObject);
    procedure edt_PunkteExit(Sender: TObject);
    procedure btn_NextClick(Sender: TObject);
    procedure btn_PriorClick(Sender: TObject);
    procedure btn_Entfernung_BestaetigenClick(Sender: TObject);
    procedure edt_KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure cbx_AngriffClick(Sender: TObject);
    procedure btn_LaufzeitberechnenClick(Sender: TObject);
  private
    FAnzahlList: TList;
    FDauerList: TList;
    FCheckboxList: TList;
    FBase: TBase;
    FBasen: TBasen;
    FAngriff: Boolean;
    procedure Init;
    procedure setBasen(const Value: TBasen);
    procedure setAnzahl(aSpinEdit: TSpinEdit);
    procedure setPunkte;
    procedure setBase(const Value: TBase);
    procedure setAngriff(const Value: Boolean);
    procedure ShowEntfernungLaufzeit;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Base: TBase read FBase write setBase;
    property Basen: TBasen read FBasen write setBasen;
    property Angriff: Boolean read FAngriff write setAngriff;
    procedure NextBase;
    procedure LoadCombobox;
  end;

implementation

{$R *.dfm}

{ Tfra_Base }



constructor Tfra_Base.Create(AOwner: TComponent);
begin
  inherited;
  FAnzahlList := TList.Create;
  FDauerList := TList.Create;
  FCheckboxList := TList.Create;
  FAnzahlList.Add(edt_Anz_Scout);
  FAnzahlList.Add(edt_Anz_Ranger);
  FAnzahlList.Add(edt_Anz_Gunner);
  FAnzahlList.Add(edt_Anz_Knocker);
  FAnzahlList.Add(edt_Anz_Mortar);
  FAnzahlList.Add(edt_Anz_Molotov);
  FAnzahlList.Add(edt_Anz_Biker);
  FAnzahlList.Add(edt_Anz_Trike);
  FAnzahlList.Add(edt_Anz_Buggy);
  FAnzahlList.Add(edt_Anz_Pickup);
  FAnzahlList.Add(edt_Anz_Carrack);
  FDauerList.Add(edt_Dauer_Scout);
  FDauerList.Add(edt_Dauer_Ranger);
  FDauerList.Add(edt_Dauer_Gunner);
  FDauerList.Add(edt_Dauer_Knocker);
  FDauerList.Add(edt_Dauer_Mortar);
  FDauerList.Add(edt_Dauer_Molotov);
  FDauerList.Add(edt_Dauer_Biker);
  FDauerList.Add(edt_Dauer_Trike);
  FDauerList.Add(edt_Dauer_Buggy);
  FDauerList.Add(edt_Dauer_Pickup);
  FDauerList.Add(edt_Dauer_Carrack);

  FCheckboxList.Add(cbx_Scout);
  FCheckboxList.Add(cbx_Ranger);
  FCheckboxList.Add(cbx_Gunner);
  FCheckboxList.Add(cbx_Knocker);
  FCheckboxList.Add(cbx_Mortar);
  FCheckboxList.Add(cbx_Molotov);
  FCheckboxList.Add(cbx_Biker);
  FCheckboxList.Add(cbx_Trike);
  FCheckboxList.Add(cbx_Buggy);
  FCheckboxList.Add(cbx_Pickup);
  FCheckboxList.Add(cbx_Carrack);
  setAngriff(false);

  Init;
end;

destructor Tfra_Base.Destroy;
begin
  FreeAndNil(FDauerList);
  FreeAndNil(FCheckboxList);
  FreeAndNil(FAnzahlList);
  inherited;
end;




procedure Tfra_Base.Init;
var
  i1: Integer;
begin
  for i1 := 0 to FAnzahlList.Count - 1 do
  begin
    TSpinEdit(FAnzahlList.Items[i1]).Value := 0;
    TMaskEdit(FDauerList.Items[i1]).Text := '00:00:00';
  end;
end;




procedure Tfra_Base.setBase(const Value: TBase);
var
  i1: Integer;
  Base: TBase;
begin
  FBase := Value;
  cbo_Base.ItemIndex := -1;
  for i1 := 0 to cbo_Base.Items.Count - 1 do
  begin
    Base := TBase(cbo_Base.Items.Objects[i1]);
    if (Base.Koordinate.X = FBase.Koordinate.X) and (Base.Koordinate.Y = FBase.Koordinate.Y) then
    begin
      cbo_Base.ItemIndex := i1;
      break;
    end;
  end;
  if cbo_Base.ItemIndex = -1 then
  begin
    cbo_Base.AddItem(FBase.Basename, FBase);
    cbo_Base.ItemIndex := cbo_Base.Items.Count -1;
  end;

  edt_Punkte.Value := FBase.Punkte;
  cbx_Rauchsignal.Checked := FBase.Rauchsignal;
  cbx_Sprechfunk.Checked  := FBase.Sprechfunk;

  for i1 := 0 to FAnzahlList.Count - 1 do
    TSpinEdit(FAnzahlList.Items[i1]).Value := FBase.Einheit[i1].Anzahl;

  edt_Entfernung.Value := FBase.Felder;
  if FBase.FelderOk then
    edt_Entfernung.Font.Color := clBlack
  else
    edt_Entfernung.Font.Color := clRed;

  edt_Dauer_Buggy.Text := FBase.Buggy.Laufzeit.TimeStr;

  for i1 := 0 to FDauerList.Count - 1 do
    TMaskEdit(FDauerList.Items[i1]).Text := FBase.Einheit[i1].Laufzeit.TimeStr;

  for i1 := 0 to FCheckboxList.Count - 1 do
    TCheckBox(FCheckboxList.Items[i1]).Checked := FBase.Einheit[i1].Angriffmode;

end;


procedure Tfra_Base.setBasen(const Value: TBasen);
begin
  FBasen := Value;
  LoadCombobox;
end;



procedure Tfra_Base.cbo_BaseChange(Sender: TObject);
var
  Base: TBase;
begin
  Base := TBase(cbo_Base.Items.Objects[cbo_Base.ItemIndex]);
  setBase(Base);
end;



procedure Tfra_Base.setAngriff(const Value: Boolean);
var
  i1: Integer;
begin
  FAngriff := Value;
  for i1 := 0 to FCheckboxList.Count - 1 do
  begin
    TCheckBox(FCheckboxList.Items[i1]).Visible := FAngriff;
  end;
end;

procedure Tfra_Base.setAnzahl(aSpinEdit: TSpinEdit);
var
  Einheit: TEinheit;
begin
  if (FBase = nil) or (aSpinEdit = nil) or (FAnzahlList = nil) then
    exit;

  if aSpinEdit.Tag > FAnzahlList.Count - 1 then
    exit;

  Einheit := FBase.Einheit[aSpinEdit.Tag];
  if Einheit <> nil then
    Einheit.Anzahl := aSpinEdit.Value;
end;


procedure Tfra_Base.edt_AnzahlExit(Sender: TObject);
begin
  if Sender = nil then
    exit;
  if Sender is TSpinEdit then
    setAnzahl(TSpinEdit(Sender));
end;


procedure Tfra_Base.edt_KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    SelectNext(TWinControl(Sender), true, true);
  if Key = 33 then
    btn_NextClick(nil);
  if Key = 34 then
    btn_PriorClick(nil);
end;


procedure Tfra_Base.cbx_RauchsignalClick(Sender: TObject);
begin
  if FBase = nil then
    exit;
  FBase.Rauchsignal := cbx_Rauchsignal.Checked;
  setBase(FBase);
end;


procedure Tfra_Base.cbx_AngriffClick(Sender: TObject);
var
  Einheit: TEinheit;
  cbx: TCheckbox;
begin
  cbx := TCheckbox(Sender);
  if (FBase = nil) or (FCheckboxList = nil) then
    exit;

  if cbx.Tag > FCheckboxList.Count - 1 then
    exit;

  Einheit := FBase.Einheit[cbx.Tag];
  if Einheit <> nil then
    Einheit.Angriffmode := cbx.Checked;
end;

procedure Tfra_Base.cbx_SprechfunkClick(Sender: TObject);
begin
  if FBase = nil then
    exit;
  FBase.Sprechfunk := cbx_Sprechfunk.Checked;
  setBase(FBase);
end;

procedure Tfra_Base.edt_PunkteExit(Sender: TObject);
begin
  setPunkte;
end;

procedure Tfra_Base.setPunkte;
begin
  if FBase = nil then
    exit;
  FBase.Punkte := edt_Punkte.Value;
end;



procedure Tfra_Base.btn_Entfernung_BestaetigenClick(Sender: TObject);
begin
  if FBase = nil then
    exit;
  FBase.Felder := edt_Entfernung.Value;
  FBase.SaveEntfernung;
  if FBase.Zielbase <> nil then
    FBase.Zielbase.SaveEntfernung;
  edt_Entfernung.Font.Color := clBlack;
  setBase(FBase);
end;

procedure Tfra_Base.btn_LaufzeitberechnenClick(Sender: TObject);
begin
  ShowEntfernungLaufzeit;
end;

procedure Tfra_Base.btn_NextClick(Sender: TObject);
var
  Index: Integer;
  Base: TBase;
begin
  Index := cbo_Base.ItemIndex + 1;
  if Index > cbo_Base.Items.Count -1 then
    Index := 0;
  Base := TBase(cbo_Base.Items.Objects[Index]);
  setBase(Base);
end;

procedure Tfra_Base.btn_PriorClick(Sender: TObject);
var
  Index: Integer;
  Base: TBase;
begin
  Index := cbo_Base.ItemIndex - 1;
  if Index < 0 then
    Index := cbo_Base.Items.Count -1;
  Base := TBase(cbo_Base.Items.Objects[Index]);
  setBase(Base);
end;


procedure Tfra_Base.NextBase;
begin
  btn_NextClick(nil);
end;

procedure Tfra_Base.LoadCombobox;
var
  i1: Integer;
  Base: TBase;
begin
  cbo_Base.Clear;
  for i1 := 0 to FBasen.Count - 1 do
  begin
    Base := FBasen.Base[i1];
    cbo_Base.AddItem(Base.Basename, Base);
  end;
  if FBasen.Count > 0 then
    setBase(FBasen.Base[0]);
end;


procedure Tfra_Base.ShowEntfernungLaufzeit;
var
  Form: Tfrm_Entfernung_Lauftzeit;
begin
  Form := Tfrm_Entfernung_Lauftzeit.Create(Self);
  try
    Form.Base := FBase;
    Form.ShowModal;
    if not Form.Cancel then
    begin
      if Form.Felder > -1 then
      begin
        edt_Entfernung.Value := Form.Felder;
        FBase.Felder := Form.Felder;
        FBase.FelderOk := true;
        btn_Entfernung_BestaetigenClick(nil);
      end;
    end;
  finally
    FreeAndNil(Form);
  end;
end;




end.
