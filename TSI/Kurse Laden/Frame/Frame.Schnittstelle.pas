unit Frame.Schnittstelle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  DBObj.Schnittstelle, DBObj.SchnittstelleList, Form.SchnittstelleBearb;

type
  Tfra_Schnittstelle = class(TFrame)
    Panel1: TPanel;
    Label1: TLabel;
    cbo_Schnittstelle: TComboBox;
    btn_BINeu: TButton;
    btn_BIAendern: TButton;
    btn_BiLoeschen: TButton;
    mem_Link: TMemo;
    procedure btn_BINeuClick(Sender: TObject);
    procedure btn_BIAendernClick(Sender: TObject);
    procedure btn_BiLoeschenClick(Sender: TObject);
    procedure mem_LinkExit(Sender: TObject);
    procedure cbo_SchnittstelleChange(Sender: TObject);
  private
    fSchnittstelleList: TSchnittstelleList;
    fSchnittstelle: TSchnittstelle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeCombobox;
  end;

implementation

{$R *.dfm}

uses
  Datamodul.TSIKurse;

{ Tfra_Schnittstelle }


constructor Tfra_Schnittstelle.Create(AOwner: TComponent);
begin
  inherited;
  mem_Link.Clear;
  fSchnittstelleList := TSchnittstelleList.Create(nil);
  fSchnittstelleList.Trans := dm.IBT;
  fSchnittstelle := TSchnittstelle.Create(nil);
  fSchnittstelle.Trans := dm.IBT;
end;

destructor Tfra_Schnittstelle.Destroy;
begin
  FreeAndNil(fSchnittstelleList);
  FreeAndNil(fSchnittstelle);
  inherited;
end;

procedure Tfra_Schnittstelle.LadeCombobox;
var
  SSId: Integer;
  i1: Integer;
begin
  SSId := -1;
  if cbo_Schnittstelle.Items.Count > 0 then
    SSId := Integer(cbo_Schnittstelle.Items[cbo_Schnittstelle.ItemIndex]);
  fSchnittstelleList.LadeCombobox(cbo_Schnittstelle.Items);
  for i1 := 0 to cbo_Schnittstelle.Items.Count -1 do
  begin
    if SSId = Integer(cbo_Schnittstelle.Items[cbo_Schnittstelle.ItemIndex]) then
    begin
      cbo_Schnittstelle.ItemIndex := i1;
      break;
    end;
  end;
end;

procedure Tfra_Schnittstelle.mem_LinkExit(Sender: TObject);
var
  SSId: Integer;
  i1: Integer;
begin
  SSId := -1;
  if cbo_Schnittstelle.Items.Count <= -1 then
    exit;
  SSId := Integer(cbo_Schnittstelle.Items.Objects[cbo_Schnittstelle.ItemIndex]);
  fSchnittstelle.Read(SSId);
  if fSchnittstelle.Gefunden then
  begin
    fSchnittstelle.Link := mem_Link.Lines.Text;
    fSchnittstelle.SaveToDB;
  end;
end;

procedure Tfra_Schnittstelle.btn_BIAendernClick(Sender: TObject);
var
  SSId: Integer;
  Form : Tfrm_SchnittstelleBearb;
begin
  SSId := -1;
  if cbo_Schnittstelle.Items.Count > -1 then
    SSId := Integer(cbo_Schnittstelle.Items[cbo_Schnittstelle.ItemIndex]);
  Form := Tfrm_SchnittstelleBearb.Create(nil);
  try
    if SSId > -1 then
      Form.SS_ID := SSId;
    Form.ShowModal;
    LadeCombobox;
  finally
    FreeAndNil(Form);
  end;
  LadeCombobox;
end;

procedure Tfra_Schnittstelle.btn_BiLoeschenClick(Sender: TObject);
var
  SSId: Integer;
begin
  SSId := -1;
  if cbo_Schnittstelle.Items.Count > -1 then
  begin
    SSId := Integer(cbo_Schnittstelle.Items[cbo_Schnittstelle.ItemIndex]);
    fSchnittstelle.Read(SSId);
    if MessageDlg('Möchtest du wirklich die Schnittstelle "' + fSchnittstelle.Bezeichnung + '" löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;
    fSchnittstelle.Delete;
  end;
end;

procedure Tfra_Schnittstelle.btn_BINeuClick(Sender: TObject);
var
  Form : Tfrm_SchnittstelleBearb;
begin
  Form := Tfrm_SchnittstelleBearb.Create(nil);
  try
    Form.ShowModal;
    LadeCombobox;
  finally
    FreeAndNil(Form);
  end;
end;


procedure Tfra_Schnittstelle.cbo_SchnittstelleChange(Sender: TObject);
var
  SSId: Integer;
  i1: Integer;
begin
  SSId := -1;
  if cbo_Schnittstelle.Items.Count <= -1 then
    exit;
  SSId := Integer(cbo_Schnittstelle.Items.Objects[cbo_Schnittstelle.ItemIndex]);
  fSchnittstelle.Read(SSId);
  if fSchnittstelle.Gefunden then
  begin
    mem_Link.Lines.Text := fSchnittstelle.Link;
  end;
end;

end.
