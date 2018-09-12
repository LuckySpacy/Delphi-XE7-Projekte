unit Frame.Kommentar;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  IBX.IBDatabase, Vcl.Buttons, Model.Kommentarlist;

type
  Tfra_Kommentar = class(TFrame)
    pnl_fontstyle: TPanel;
    pnl_fontstyletop: TPanel;
    pnl_fontstylebutton: TPanel;
    btn_Neu_Fontstyle: TButton;
    btn_Edit_Fontstyle: TButton;
    btn_del_Fontstyle: TButton;
    lsb_Kommentar: TListBox;
    btn_Up: TSpeedButton;
    btn_Down: TSpeedButton;
    procedure btn_Neu_FontstyleClick(Sender: TObject);
  private
    fTrans: TIBTransaction;
    fKommentarList: TKommentarList;
    procedure ShowKommentarEdit(aId: Integer);
    procedure SaveSort;
  public
    procedure setTrans(aTrans: TIBTransaction);
    constructor Create(AOwner: TComponent); override;
    procedure LadeKommentare;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses
  Form.KommentarEdit;

{ Tfra_Kommentar }

constructor Tfra_Kommentar.Create(AOwner: TComponent);
begin
  inherited;
  fTrans := nil;
  fKommentarList := TKommentarList.Create(nil);
end;

destructor Tfra_Kommentar.Destroy;
begin
  FreeAndNil(fKommentarList);
  inherited;
end;

procedure Tfra_Kommentar.LadeKommentare;
var
  i1: Integer;
  s: string;
begin
  fKommentarList.ReadAll;
  lsb_Kommentar.Clear;
  for i1 := 0 to fKommentarList.Count -1 do
  begin
    s := fKommentarList.Item[i1].StartZeichen + ' ' + fKommentarList.Item[i1].EndeZeichen;
    lsb_Kommentar.Items.AddObject(s, TObject(fKommentarList.Item[i1].Id));
  end;
end;


procedure Tfra_Kommentar.setTrans(aTrans: TIBTransaction);
begin
  fTrans := aTrans;
  fKommentarList.Trans := fTrans;
end;

procedure Tfra_Kommentar.btn_Neu_FontstyleClick(Sender: TObject);
begin
  ShowKommentarEdit(0);
end;


procedure Tfra_Kommentar.ShowKommentarEdit(aId: Integer);
var
  Form: Tfrm_KommentarEdit;
  ItemIndex: Integer;
begin
  ItemIndex := lsb_Kommentar.ItemIndex;
  if ItemIndex < 0 then
    ItemIndex := 0;
  Form := Tfrm_KommentarEdit.Create(nil);
  try
    Form.setTrans(fTrans);
    if aId <= 0 then
      Form.setSortIndex((ItemIndex * 2) + 1);
    Form.ShowModal;
  finally
    FreeAndNil(Form);
  end;

end;

procedure Tfra_Kommentar.SaveSort;
var
  SortIndex: Integer;
  i1: Integer;
begin
  SortIndex := 0;
  fKommentarList.ReadAll;
  for i1 := 0 to fKommentarList.Count -1 do
  begin
    fKommentarList.Item[i1].Sort := SortIndex;
    Inc(SortIndex, 2);
  end;
end;


end.
