unit Form.Schnittstelle;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, DBObj.SchnittstelleList,
  DBObj.Schnittstelle;

type
  Tfrm_Schnittstelle = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    lsb_Schnittstelle: TListBox;
    btn_Neu: TButton;
    btn_Loeschen: TButton;
    mem_Link: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btn_NeuClick(Sender: TObject);
    procedure lsb_SchnittstelleDblClick(Sender: TObject);
    procedure lsb_SchnittstelleClick(Sender: TObject);
    procedure btn_LoeschenClick(Sender: TObject);
    procedure mem_LinkExit(Sender: TObject);
  private
    fSchnittstelleList: TSchnittstelleList;
    fSchnittstelle: TSchnittstelle;
    procedure ShowSchnittstelleBearbeiten(aId: Integer);
    procedure AktualLink;
    procedure AktualSchnittstelle;
  public
    { Public-Deklarationen }
  end;

var
  frm_Schnittstelle: Tfrm_Schnittstelle;

implementation

{$R *.dfm}

uses
  Datamodul.TSI, Form.SchnittstelleBearb;




procedure Tfrm_Schnittstelle.FormCreate(Sender: TObject);
begin //
  fSchnittstelleList := TSchnittstelleList.Create(nil);
  fSchnittstelleList.Trans := dm.IBT;
  fSchnittstelle := TSchnittstelle.Create(nil);
  fSchnittstelle.Trans := dm.IBT;
end;

procedure Tfrm_Schnittstelle.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fSchnittstelleList);
  FreeAndNil(fSchnittstelle);
end;

procedure Tfrm_Schnittstelle.FormShow(Sender: TObject);
begin //
  AktualSchnittstelle;
end;

procedure Tfrm_Schnittstelle.lsb_SchnittstelleClick(Sender: TObject);
begin
  AktualLink;
end;

procedure Tfrm_Schnittstelle.lsb_SchnittstelleDblClick(Sender: TObject);
begin
  if lsb_Schnittstelle.ItemIndex < 0 then
    exit;
  ShowSchnittstelleBearbeiten(Integer(lsb_Schnittstelle.Items.Objects[lsb_Schnittstelle.ItemIndex]));
end;

procedure Tfrm_Schnittstelle.mem_LinkExit(Sender: TObject);
begin
  fSchnittstelle.Link := mem_Link.Text;
  fSchnittstelle.SaveToDB;
end;

procedure Tfrm_Schnittstelle.AktualLink;
var
  Id: Integer;
begin
  mem_Link.Clear;
  if lsb_Schnittstelle.ItemIndex < 0 then
    exit;
  Id := Integer(lsb_Schnittstelle.Items.Objects[lsb_Schnittstelle.ItemIndex]);
  fSchnittstelle.Read(Id);
  mem_Link.Text := fSchnittstelle.Link;
end;

procedure Tfrm_Schnittstelle.AktualSchnittstelle;
begin
  fSchnittstelleList.LadeCombobox(lsb_Schnittstelle.Items);
  AktualLink;
end;

procedure Tfrm_Schnittstelle.btn_LoeschenClick(Sender: TObject);
var
  Id: Integer;
begin
  if lsb_Schnittstelle.ItemIndex < 0 then
    exit;
  Id := Integer(lsb_Schnittstelle.Items.Objects[lsb_Schnittstelle.ItemIndex]);
  fSchnittstelle.Read(Id);
  if not MessageDlg('Möchten Sie wirklich die Schnittstelle "' + fSchnittstelle.Bezeichnung + '" löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  fSchnittstelle.Delete;
  AktualSchnittstelle;
end;

procedure Tfrm_Schnittstelle.btn_NeuClick(Sender: TObject);
begin
  ShowSchnittstelleBearbeiten(-1);

end;


procedure Tfrm_Schnittstelle.ShowSchnittstelleBearbeiten(aId: Integer);
var
  Form: Tfrm_SchnittstelleBearb;
begin
  Form := Tfrm_SchnittstelleBearb.Create(nil);
  try
    Form.SS_ID := aId;
    Form.ShowModal;
    {
    if Form.Cancel then
      exit;

    if aId < 0 then
      fSchnittstelle.Init
    else
      fSchnittstelle.Read(aId);

    fSchnittstelle.Bezeichnung := Form.edt_Bezeichnung.Text;
    fSchnittstelle.SaveToDB;
     }
  finally
    FreeAndNil(Form);
  end;
  AktualSchnittstelle;
end;

end.
