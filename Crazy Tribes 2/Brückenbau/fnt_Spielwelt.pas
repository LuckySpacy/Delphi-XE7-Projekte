unit fnt_Spielwelt;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, tbButton, Vcl.ExtCtrls;

type
  Tfrm_Spielwelt = class(TForm)
    lb_Spielwelt: TListBox;
    Panel1: TPanel;
    btn_Neu: TTBButton;
    btn_Loeschen: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_NeuClick(Sender: TObject);
    procedure btn_LoeschenClick(Sender: TObject);
    procedure lb_SpielweltDblClick(Sender: TObject);
  private
    FPath: string;
    FSpielweltList: TStringList;
    procedure ShowSpielweltAnlegen;
    procedure LadeSpielwelten;
  public
    function Spielewelt: string;
  end;

var
  frm_Spielwelt: Tfrm_Spielwelt;

implementation

{$R *.dfm}

uses
  u_System, c_AllgTypes, fnt_SpielweltNeu, u_regini;


procedure Tfrm_Spielwelt.FormCreate(Sender: TObject);
begin //
  FSpielweltList := TStringList.Create;
  FSpielweltList.Sorted := true;
  FSpielweltList.Duplicates := dupIgnore;


  FPath := '';
  if FileExists(IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\ct.ini') then
    FPath := ReadIni(IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\ct.ini', 'Einstellung', 'Pfad', '');

  if (FPath = '') or (not DirectoryExists(FPath)) then
    FPath := IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\';

  FPath := FPath + 'Spielwelt\';

  //FPath := IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\Spielwelt\';
  if not DirectoryExists(FPath) then
    ForceDirectories(FPath);
end;

procedure Tfrm_Spielwelt.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSpielweltList);
end;

procedure Tfrm_Spielwelt.FormShow(Sender: TObject);
begin
  LadeSpielwelten;
end;

procedure Tfrm_Spielwelt.LadeSpielwelten;
var
  FList: TStringList;
  i1: Integer;
  Pfad: string;
  iPos: Integer;
begin
  FSpielweltList.Clear;
  FList := TStringList.Create;
  try
    GetAllFiles(FPath, FList, true, true);
    for i1 := 0 to FList.Count -1 do
    begin
      Pfad := ExtractFilePath(FList.Strings[i1]);
      if Pfad[Length(Pfad)] = '\'  then
        Pfad := copy(Pfad, 1, Length(Pfad)-1);
      iPos := LastDelimiter('\', Pfad);
      Pfad := copy(Pfad, iPos+1, Length(Pfad));
      if SameText('Entfernungen', Pfad) then
        continue;
      FSpielweltList.Add(UpperCase(Pfad));
    end;
  finally
    FreeAndNil(FList);
  end;
  lb_Spielwelt.Clear;
  lb_Spielwelt.Items.AddStrings(FSpielweltList);
  if lb_Spielwelt.Items.Count > 0 then
  begin
    lb_Spielwelt.SetFocus;
    lb_Spielwelt.ItemIndex := 0;
  end;
end;


procedure Tfrm_Spielwelt.lb_SpielweltDblClick(Sender: TObject);
begin
  close;
end;

function Tfrm_Spielwelt.Spielewelt: string;
begin
  Result := '';
  if lb_Spielwelt.Items.Count = 0 then
    exit;
  if lb_Spielwelt.ItemIndex < 0 then
    exit;
  Result := lb_Spielwelt.Items[lb_Spielwelt.ItemIndex];
  if Result = '' then
    exit;
  Result := FPath + Result;
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;


procedure Tfrm_Spielwelt.btn_LoeschenClick(Sender: TObject);
var
  Pfad: String;
begin
  if lb_Spielwelt.Count = 0 then
    exit;
  if lb_Spielwelt.ItemIndex < 0 then
    exit;
  if MessageDlg('Alle Einstellungen, die diese Spielwelt betrifft, werden gelöscht.' + sLineBreak +
                'Möchtest du wirklich diese Spielwelt löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  Pfad := FPath + Trim(lb_Spielwelt.Items[lb_Spielwelt.ItemIndex]);
  ForceDelDirectory(Pfad);
  LadeSpielwelten;
end;

procedure Tfrm_Spielwelt.btn_NeuClick(Sender: TObject);
begin
  ShowSpielweltAnlegen;
end;


procedure Tfrm_Spielwelt.ShowSpielweltAnlegen;
var
  Form: Tfrm_SpielweltNeu;
  NeuerPfad: string;
  FFile: TStringList;
begin
  Form := Tfrm_SpielweltNeu.Create(Self);
  try
    Form.ShowModal;
    if Trim(Form.edt_Name.Text) = '' then
      exit;
    NeuerPfad := FPath + Trim(Form.edt_Name.Text);
    if not DirectoryExists(NeuerPfad) then
    begin
      ForceDirectories(NeuerPfad);
      FFile := TStringList.Create;
      FFile.SaveToFile(IncludeTrailingPathDelimiter(NeuerPfad) + 'Basen.txt');
      LadeSpielwelten;
    end;
  finally
    FreeAndNil(Form);
  end;
end;


end.
