unit Form.Ordnervergleich;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, Vcl.ExtCtrls, Objekt.Global, Frame.Ordnervergleich, Objekt.Ordner, Objekt.OrdnerList,
  System.IOUtils, Vcl.ComCtrls, Frame.OrdnerIgnorieren;

type
  Tfrm_Ordnervergleich = class(TForm)
    pnl_Button: TPanel;
    pnl_Ordner: TPanel;
    ScrollBox1: TScrollBox;
    edt_Pfad1: TAdvDirectoryEdit;
    Label1: TLabel;
    edt_Pfad2: TAdvDirectoryEdit;
    Label2: TLabel;
    edt_Pfad3: TAdvDirectoryEdit;
    Label3: TLabel;
    edt_Pfad4: TAdvDirectoryEdit;
    Label4: TLabel;
    btn_Einlesen: TButton;
    btn_Delete: TButton;
    PageControl1: TPageControl;
    tbs_Liste: TTabSheet;
    tbs_OrdnerIgnorieren: TTabSheet;
    btn_UnterstrichWeg: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_EinlesenClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_UnterstrichWegClick(Sender: TObject);
  private
    fFrameOrdnervergleich: Tfra_Ordnervergleich;
    fFrameOrdnerIgnorieren: Tfra_OrdnerIgnorieren;
    fOrdnerList: TOrdnerList;
    fOrdnerList1: TOrdnerList;
    fOrdnerList2: TOrdnerList;
    fOrdnerList3: TOrdnerList;
    fOrdnerList4: TOrdnerList;
    procedure FuelleOrdnerList(aOrdnerList: TOrdnerList);
    procedure VonUnterstrichenBefreien;
  public
  end;

var
  frm_Ordnervergleich: Tfrm_Ordnervergleich;

implementation

{$R *.dfm}


procedure Tfrm_Ordnervergleich.FormCreate(Sender: TObject);
begin
  Global := TGlobal.Create;
  edt_Pfad1.Text := Global.Ini.Pfad1;
  edt_Pfad2.Text := Global.Ini.Pfad2;
  edt_Pfad3.Text := Global.Ini.Pfad3;
  edt_Pfad4.Text := Global.Ini.Pfad4;

  fFrameOrdnervergleich := Tfra_Ordnervergleich.Create(nil);
  fFrameOrdnervergleich.Parent := tbs_Liste;
  fFrameOrdnervergleich.Align  := alClient;

  fFrameOrdnerIgnorieren := Tfra_OrdnerIgnorieren.Create(nil);
  fFrameOrdnerIgnorieren.Parent := tbs_OrdnerIgnorieren;
  fFrameOrdnerIgnorieren.Align  := alClient;


  fOrdnerList  := TOrdnerList.Create;
  fOrdnerList1 := TOrdnerList.Create;
  fOrdnerList2 := TOrdnerList.Create;
  fOrdnerList3 := TOrdnerList.Create;
  fOrdnerList4 := TOrdnerList.Create;


end;

procedure Tfrm_Ordnervergleich.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Global);
  FreeAndNil(fFrameOrdnervergleich);
  FreeAndNil(fFrameOrdnerIgnorieren);
  FreeAndNil(fOrdnerList);
  FreeAndNil(fOrdnerList1);
  FreeAndNil(fOrdnerList2);
  FreeAndNil(fOrdnerList3);
  FreeAndNil(fOrdnerList4);
end;


procedure Tfrm_Ordnervergleich.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.Ini.Pfad1 := edt_Pfad1.Text;
  Global.Ini.Pfad2 := edt_Pfad2.Text;
  Global.Ini.Pfad3 := edt_Pfad3.Text;
  Global.Ini.Pfad4 := edt_Pfad4.Text;
end;


procedure Tfrm_Ordnervergleich.btn_DeleteClick(Sender: TObject);
var
  Pfad: string;
begin
  if (Trim(fFrameOrdnervergleich.SelectedPfad) = '') or ((Trim(fFrameOrdnervergleich.SelectedTitel) = '')) then
    exit;
  Pfad := IncludeTrailingPathDelimiter(fFrameOrdnervergleich.SelectedPfad) + fFrameOrdnervergleich.SelectedTitel;
  if not MessageDlg('Den Ordnerinhalt "' + Pfad + '"' + sLineBreak +
                    'wirklich löschen?', mtConfirmation, [mbYes, mbNo],0) = mrNo  then
    exit;

  TDirectory.Delete(Pfad, true);
  fFrameOrdnervergleich.DeleteSelectedRow;
end;

procedure Tfrm_Ordnervergleich.btn_EinlesenClick(Sender: TObject);
begin //
  fOrdnerList.Clear;
  fOrdnerList1.Clear;
  fOrdnerList2.Clear;
  fOrdnerList3.Clear;
  fOrdnerList4.Clear;
  if DirectoryExists(edt_Pfad1.Text) then
    fOrdnerList1.AlleOrdnerEinlesen(edt_Pfad1.Text);
  if DirectoryExists(edt_Pfad2.Text) then
    fOrdnerList2.AlleOrdnerEinlesen(edt_Pfad2.Text);
  if DirectoryExists(edt_Pfad3.Text) then
    fOrdnerList3.AlleOrdnerEinlesen(edt_Pfad3.Text);
  if DirectoryExists(edt_Pfad4.Text) then
    fOrdnerList4.AlleOrdnerEinlesen(edt_Pfad4.Text);

  FuelleOrdnerList(fOrdnerList1);
  FuelleOrdnerList(fOrdnerList2);
  FuelleOrdnerList(fOrdnerList3);
  FuelleOrdnerList(fOrdnerList4);
  fOrdnerList.SortiereNachTitel;
  fFrameOrdnervergleich.ShowGrid(fOrdnerList);
end;

procedure Tfrm_Ordnervergleich.btn_UnterstrichWegClick(Sender: TObject);
begin
  VonUnterstrichenBefreien;
end;

procedure Tfrm_Ordnervergleich.FuelleOrdnerList(aOrdnerList: TOrdnerList);
var
  i1: Integer;
  Ordner: TOrdner;
begin
  for i1 := 0 to aOrdnerList.Count -1 do
  begin
    if fFrameOrdnerIgnorieren.isInList(aOrdnerList.Item[i1].Titel) then
      continue;
    Ordner := fOrdnerList.Add;
    Ordner.Titel := aOrdnerList.Item[i1].Titel;
    Ordner.Pfad  := aOrdnerList.Item[i1].Pfad;
  end;
end;



procedure Tfrm_Ordnervergleich.VonUnterstrichenBefreien;
var
  i1: Integer;
  Titel: string;
  TitelNeu: string;
  iPos: Integer;
  FilenameOld: string;
  FilenameNew: string;
begin
  for i1 := 0 to fOrdnerList.Count -1 do
  begin
    Titel := fOrdnerList.Item[i1].Titel;
    iPos := Pos('_', Titel);
    if iPos <= 0 then
      continue;
    TitelNeu := copy(Titel, 1, iPos-1);
    if MessageDlg('Soll der Titel' + sLinebreak + Titel + sLineBreak + 'wirklich in' + sLinebreak + TitelNeu + sLinebreak +
                'umbenannt werden?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      continue;
     FilenameOld := IncludeTrailingPathDelimiter(fOrdnerList.Item[i1].Pfad) + Titel;
     FilenameNew := IncludeTrailingPathDelimiter(fOrdnerList.Item[i1].Pfad) + TitelNeu;
     RenameFile(FilenameOld, FilenameNew);
  end;
end;

end.
