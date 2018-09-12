unit Frame.OrdnerIgnorieren;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Objekt.Global;

type
  Tfra_OrdnerIgnorieren = class(TFrame)
    Panel1: TPanel;
    lsb: TListBox;
    btn_Neu: TButton;
    btn_Loeschen: TButton;
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_LoeschenClick(Sender: TObject);
  private
    fIgnoreList: TStringList;
    procedure LadeListe(aOrdnername: string);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function isInList(aOrdnername: string): Boolean;

  end;

implementation

{$R *.dfm}

{ Tfra_OrdnerIgnorieren }


constructor Tfra_OrdnerIgnorieren.Create(AOwner: TComponent);
begin
  inherited;
  LadeListe('');
end;

destructor Tfra_OrdnerIgnorieren.Destroy;
begin
  inherited;
end;


procedure Tfra_OrdnerIgnorieren.LadeListe(aOrdnername: string);
var
  List: TStringList;
  i1: Integer;
begin
  lsb.Clear;
  if FileExists(Global.OrdnerIgnoreFile) then
  begin
    List := TStringList.Create;
    List.Duplicates := dupIgnore;
    List.Sorted := true;
    List.LoadFromFile(Global.OrdnerIgnoreFile);
    lsb.Items.AddStrings(List);
    FreeAndNil(List);
  end;
  if Trim(aOrdnername) > ''  then
  begin
    for i1 := 0 to lsb.Count -1 do
    begin
      if SameText(aOrdnername, lsb.Items.Strings[i1]) then
      begin
        lsb.ItemIndex := i1;
        break;
      end;
    end;
  end;
end;

procedure Tfra_OrdnerIgnorieren.btn_LoeschenClick(Sender: TObject);
begin
  if not MessageDlg('Wiklich löschen?', mtConfirmation, [mbYes, mbNo],0) = mrNo then
    exit;
  lsb.Items.Delete(lsb.ItemIndex);
  lsb.Items.SaveToFile(Global.OrdnerIgnoreFile);
  LadeListe('');
end;

procedure Tfra_OrdnerIgnorieren.btn_NeuClick(Sender: TObject);
var
  Ordnername: string;
begin
  Ordnername := InputBox('Neuer Ordner', 'Ordnername', '');
  if Trim(Ordnername) = '' then
    exit;
  lsb.Items.Add(Ordnername);
  lsb.Items.SaveToFile(Global.OrdnerIgnoreFile);
  LadeListe(Ordnername);
end;

function Tfra_OrdnerIgnorieren.isInList(aOrdnername: string): Boolean;
var
  i1: Integer;
begin
  Result := false;
  for i1 := 0 to lsb.Items.Count -1 do
  begin
    if SameText(lsb.Items.Strings[i1], aOrdnername) then
    begin
      Result := true;
      exit;
    end;
  end;
end;



end.
