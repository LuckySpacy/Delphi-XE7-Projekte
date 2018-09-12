unit Frame.Aktie;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.BoersenIndex,
  Vcl.ExtCtrls, Vcl.StdCtrls, MySql.Aktie, MySql.AktieList;

type
  TLoadKursEvent=procedure(Sender: TObject; aAK_ID: Integer; aWKN, aAktie: string) of object;

type
  Tfra_Aktie = class(TFrame)
    pnl_BI: TPanel;
    lsb: TListBox;
    procedure lsbDblClick(Sender: TObject);
  private
    fBoersenIndex: Tfra_BoersenIndex;
    fMySqlAktieList: TMySqlAktieList;
    fBI_Id: Integer;
    fLoadKursEvent: TLoadKursEvent;
    procedure ChangedBoersenIndex(Sender: TObject; aBI_ID: Integer);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeDaten;
    procedure Aktual;
    property OnLoadKurs: TLoadKursEvent read fLoadKursEvent write fLoadKursEvent;
  end;

implementation

{$R *.dfm}

{ Tfra_Aktie }


constructor Tfra_Aktie.Create(AOwner: TComponent);
begin
  inherited;
  fBoersenIndex := Tfra_BoersenIndex.Create(Self);
  fBoersenIndex.Parent := pnl_BI;
  fBoersenIndex.Align := alClient;
  fBoersenIndex.OnChangedBoersenindex := ChangedBoersenIndex;

  fMySqlAktieList := TMySqlAktieList.Create(nil);


  fBI_Id := 0;
end;

destructor Tfra_Aktie.Destroy;
begin
  FreeAndNil(fMySqlAktieList);
  inherited;
end;

procedure Tfra_Aktie.LadeDaten;
begin
  fMySqlAktieList.ReadAll;
  Aktual;
end;

procedure Tfra_Aktie.lsbDblClick(Sender: TObject);
var
  Aktie: TMySqlAktie;
begin
  if lsb.ItemIndex < 0 then
    exit;
  Aktie := TMySqlAktie(lsb.Items.Objects[lsb.ItemIndex]);
  if Assigned(fLoadKursEvent) then
    fLoadKursEvent(Self, Aktie.FieldByName('AK_ID').AsInteger,
                   Aktie.FieldByName('wkn').AsString,
                   Aktie.FieldByName('aktie').AsString);
end;

procedure Tfra_Aktie.Aktual;
var
  i1: Integer;
  s: string;
begin
  lsb.Clear;
  for i1 := 0 to fMySqlAktieList.Count -1 do
  begin
    if (fBi_Id > 0) and (fBi_Id <> fMySqlAktieList.Item[i1].FieldByName('bi_id').AsInteger) then
      continue;
    s := fMySqlAktieList.Item[i1].FieldByName('Aktie').AsString +
         ' [' + fMySqlAktieList.Item[i1].FieldByName('wkn').AsString + ']';
    lsb.Items.AddObject(s, fMySqlAktieList.Item[i1]);
  end;
end;

procedure Tfra_Aktie.ChangedBoersenIndex(Sender: TObject; aBI_ID: Integer);
begin
  fBi_Id := aBI_ID;
  Aktual;
end;


end.
