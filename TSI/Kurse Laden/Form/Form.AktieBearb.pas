unit Form.AktieBearb;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DBObj.Aktie, DBObj.AktieList,
  DBObj.BoersenindexList, DBObj.Boersenindex, Vcl.ExtCtrls;

type
  Tfrm_Aktiebearb = class(TForm)
    WKN: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edt_WKN: TEdit;
    edt_Aktie: TEdit;
    mem_Link: TMemo;
    Label1: TLabel;
    cbo_Boersenindex: TComboBox;
    Panel1: TPanel;
    btn_Ok: TButton;
    btn_Cancel: TButton;
    Label4: TLabel;
    edt_Symbol: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btn_CancelClick(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    fCancel: Boolean;
    fAK_ID: Integer;
    fAktie: TAktie;
    fNeu: Boolean;
    fBoersenindexList: TBoersenindexList;
    fBI_ID: Integer;
    procedure setAK_ID(const Value: Integer);
    procedure setBI_ID(const Value: Integer);
  public
    property Cancel: Boolean read fCancel;
    property AK_ID: Integer read fAK_ID write setAK_ID;
    property BI_ID: Integer read fBI_ID write setBI_ID;
  end;

var
  frm_Aktiebearb: Tfrm_Aktiebearb;

implementation

{$R *.dfm}

uses
  Datamodul.TSIKurse;



procedure Tfrm_Aktiebearb.FormCreate(Sender: TObject);
begin
  fCancel := true;
  edt_WKN.Text   := '';
  edt_Aktie.Text := '';
  edt_Symbol.Text := '';
  fNeu := true;
  mem_Link.Clear;
  fAK_Id := 0;
  fAktie := TAktie.Create(nil);
  fAktie.Trans := dm.IBT;
  fBoersenindexList := TBoersenindexList.Create(nil);
  fBoersenindexList.Trans := dm.IBT;
end;


procedure Tfrm_Aktiebearb.FormDestroy(Sender: TObject);
begin
  FreeAndNil(fAktie);
  FreeAndNil(fBoersenindexList);
end;

procedure Tfrm_Aktiebearb.setAK_ID(const Value: Integer);
begin
  fNeu := false;
  fAK_ID := Value;
  fAktie.Read(fAK_Id);
  edt_Aktie.Text := fAktie.Aktie;
  edt_WKN.Text   := fAktie.WKN;
  mem_Link.Text  := fAktie.Link;
  edt_Symbol.Text := fAktie.Symbol;
  setBI_Id(fAktie.BI_ID);
end;

procedure Tfrm_Aktiebearb.setBI_ID(const Value: Integer);
var
  i1 : Integer;
begin
  fBI_ID := Value;
  fBoersenindexList.LadeCombobox(cbo_Boersenindex.Items);
  for i1 := 0 to cbo_Boersenindex.Items.Count -1 do
  begin
    if Integer(cbo_Boersenindex.Items.Objects[i1]) = fBI_Id then
    begin
      cbo_Boersenindex.ItemIndex := i1;
      exit;
    end;
  end;
end;

procedure Tfrm_Aktiebearb.btn_CancelClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Aktiebearb.btn_OkClick(Sender: TObject);
begin
  if cbo_Boersenindex.ItemIndex  < 0 then
  begin
    ShowMessage('Bitte vorher einen Börsenindex auswählen');
    exit;
  end;
  if (fNeu) and fAktie.WknExist(edt_WKN.Text) then
  begin
    ShowMessage('WKN "' + edt_WKN.Text + '" existiert bereits.');
    exit;
  end;
  fCancel := false;
  fAktie.Aktie := edt_Aktie.Text;
  fAktie.WKN   := edt_WKN.Text;
  fAktie.Link  := mem_Link.Text;
  fAktie.BI_ID := Integer(cbo_Boersenindex.Items.Objects[cbo_Boersenindex.ItemIndex]);
  fAktie.Symbol := edt_Symbol.Text;
  fAktie.SaveToDB;
  close;
end;



end.
