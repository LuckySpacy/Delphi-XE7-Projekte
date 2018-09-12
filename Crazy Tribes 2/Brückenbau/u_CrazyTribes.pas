unit u_CrazyTribes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, tbButton, m_Base, o_Basen, o_Base, fnt_Zielbaseladen,
  m_Grid, o_Timelinelist, o_Timeline, o_Koordinate;

type
  Tfrm_CrazyTribes = class(TForm)
    Panel1: TPanel;
    btn_BaseAnlegen: TTBButton;
    pnl_Base: TPanel;
    btn_Base_Delete: TTBButton;
    btn_Base_bearbeiten: TTBButton;
    btn_Zielbase: TTBButton;
    pnl_Grid: TPanel;
    Timer: TTimer;
    btn_Angriff: TTBButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_BaseAnlegenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_Base_DeleteClick(Sender: TObject);
    procedure btn_Base_bearbeitenClick(Sender: TObject);
    procedure btn_ZielbaseClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure btn_AngriffClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FFrameBase: Tfra_Base;
    FFrameGrid: Tfra_Grid;
    FPath: string;
    FDateiBase: string;
    FPfadEntfernungen: string;
    FBasen: TBasen;
    FZielbase: TBase;
    FTimelineList: TTimelineList;
    FAngriff: Boolean;
    FSpielWelt: string;
    procedure ShowBase(aBase: TBase);
    procedure ZielbaseLaden;
    procedure AktualTimeline;
    procedure AktualTimeline_Angriff;
    procedure TimelineDblClick(Sender: TObject; aKoordinate: TKoordinate);
    procedure ShowSpielwelt;
  public
  end;

var
  frm_CrazyTribes: Tfrm_CrazyTribes;

implementation

{$R *.dfm}

uses
  fnt_Base, o_Einheit, u_System, c_AllgTypes, fnt_Spielwelt, u_regini;



procedure Tfrm_CrazyTribes.FormCreate(Sender: TObject);
begin
  FFrameBase := Tfra_Base.Create(Self);
  FFrameBase.Parent := pnl_Base;
  FFrameBase.Align  := alClient;

  FFrameGrid := Tfra_Grid.Create(Self);
  FFrameGrid.Parent := pnl_Grid;
  FFrameGrid.Align  := alClient;
  FFrameGrid.OnTimelineDblClick := TimelineDblClick;

  FBasen := nil;
  {
  FPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));
  FDateiBase := FPath + 'Basen.txt';
  FBasen := TBasen.Create;
  FBasen.Pfad := FPath;
  FBasen.Load;
  FFrameBase.Basen := FBasen;

  FPfadEntfernungen := FPath + 'Entfernungen\';

  if not DirectoryExists(FPfadEntfernungen) then
    ForceDirectories(FPfadEntfernungen);

  }


  FZielbase := nil;
  FTimelineList := TTimelineList.Create;

  FAngriff := false;

end;

procedure Tfrm_CrazyTribes.FormDestroy(Sender: TObject);
begin
  if FZielbase <> nil then
    FreeAndNil(FZielbase);
  if FBasen <> nil then
    FreeAndNil(FBasen);
  FreeAndNil(FFrameBase);
  FreeAndNil(FFrameGrid);
  FreeAndNil(FTimelineList);
end;


procedure Tfrm_CrazyTribes.FormShow(Sender: TObject);
begin
  FPath := '';
  if FileExists(IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\ct.ini') then
    FPath := ReadIni(IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\ct.ini', 'Einstellung', 'Pfad', '')
  else
  begin
    WriteIni(IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\ct.ini', 'Einstellung', 'Pfad', IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\');
  end;

  if (FPath = '') or (not DirectoryExists(FPath)) then
    FPath := IncludeTrailingBackslash(GetShellFolder(cCSIDL_APPDATA)) + 'CrazyTribes\';
  ShowSpielwelt;
  if FSpielWelt = '' then
    close;
  FPath := IncludeTrailingPathDelimiter(FSpielWelt);

  FDateiBase := FPath + 'Basen.txt';
  FBasen := TBasen.Create;
  FBasen.Pfad := FPath;
  FBasen.Load;
  FFrameBase.Basen := FBasen;

  FPfadEntfernungen := FPath + 'Entfernungen\';

  if not DirectoryExists(FPfadEntfernungen) then
    ForceDirectories(FPfadEntfernungen);

end;

procedure Tfrm_CrazyTribes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FBasen.Save;
end;



procedure Tfrm_CrazyTribes.btn_AngriffClick(Sender: TObject);
begin
  FAngriff := not FAngriff;
  if FAngriff then
    btn_Angriff.Color := clRed
  else
    btn_Angriff.Color := clBtnFace;
  FFrameBase.Angriff := FAngriff;
end;

procedure Tfrm_CrazyTribes.btn_BaseAnlegenClick(Sender: TObject);
begin
  ShowBase(nil);
end;


procedure Tfrm_CrazyTribes.ShowBase(aBase: TBase);
var
  Form: Tfrm_Base;
  Base: TBase;
begin
  Base := aBase;
  Form := Tfrm_Base.Create(Self);
  try
    Form.Base := Base;
    Form.ShowModal;
    if (not Form.Cancel) and (Form.Base = nil) then
    begin
      Base := FBasen.Add;
    end;
    if not Form.Cancel then
    begin
      Base.Basename := Form.edt_Basename.Text;
      Base.Koordinate.X := Form.edt_X.Value;
      Base.Koordinate.Y := Form.edt_Y.Value;
      Base.Punkte       := Form.edt_Punkte.Value;
      Base.Rauchsignal  := Form.cbx_Rauchsignal.Checked;
      Base.Sprechfunk   := Form.cbx_Sprechfunk.Checked;
      FBasen.Sort;
      FFrameBase.LoadCombobox;
      FFrameBase.Base := Base;
    end;
  finally
    FreeAndNil(Form);
  end;
end;


procedure Tfrm_CrazyTribes.ShowSpielwelt;
var
  Form: Tfrm_Spielwelt;
begin
  Form := Tfrm_Spielwelt.Create(Self);
  try
    Form.ShowModal;
    FSpielWelt := Form.Spielewelt;
  finally
    FreeAndNil(Form);
  end;

end;

procedure Tfrm_CrazyTribes.ZielbaseLaden;
var
  Form: Tfrm_ZielbaseLaden;
  Koord: string;
  Filename: string;
  iPos: Integer;
  Basename: string;
  i1: Integer;
  Base: TBase;
begin
  if FZielbase <> nil then
    FreeAndNil(FZielbase);
  Form := Tfrm_ZielbaseLaden.Create(Self);
  try
    Form.Path := FPfadEntfernungen;
    Form.ShowModal;
    if Form.Entfernungsdatei > '' then
    begin
      Filename := ExtractFileName(Form.Entfernungsdatei);
      iPos := Pos('-', Filename);
      if iPos <= 0 then
        exit;
      Koord := copy(Filename, 1, iPos-1);
      Delete(Filename, 1, iPos);
      iPos := Pos('.', FileName);
      if iPos <= 0 then
        exit;
      Basename := copy(Filename, 1, iPos-1);
      FZielbase := TBase.Create;
      FZielbase.Koordinate.AsString := Koord;
      FZielbase.Basename := Basename;
      FZielbase.EntfernungPfad := FPfadEntfernungen;
      for i1 := 0 to FBasen.Count - 1 do
      begin
        Base := FBasen.Base[i1];
        Base.Zielbase := FZielbase;
      end;
      Caption := 'Brückenbau für ' + FZielbase.Basename;
      FFrameBase.Base := FFrameBase.Base;
      Timer.Enabled := true;
      AktualTimeline;
    end;
  finally
    FreeAndNil(Form);
  end;

end;

procedure Tfrm_CrazyTribes.btn_Base_bearbeitenClick(Sender: TObject);
begin
  ShowBase(FFrameBase.Base);
end;

procedure Tfrm_CrazyTribes.btn_Base_DeleteClick(Sender: TObject);
var
  DeleteBase: TBase;
  NextBase: TBase;
begin
  if MessageDlg('Möchtest du die Base wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  DeleteBase := FFrameBase.Base;
  FFrameBase.NextBase;
  NextBase := FFrameBase.Base;
  FBasen.Delete(DeleteBase);
  FFrameBase.LoadCombobox;
  FFrameBase.Base := NextBase;
end;


procedure Tfrm_CrazyTribes.btn_ZielbaseClick(Sender: TObject);
begin
  ZielbaseLaden;
end;


procedure Tfrm_CrazyTribes.TimerTimer(Sender: TObject);
begin
  AktualTimeline;
end;


procedure Tfrm_CrazyTribes.AktualTimeline;
var
  i1: Integer;
  Base: TBase;
  Timeline: TTimeline;
begin
  if FAngriff then
  begin
    AktualTimeline_Angriff;
    exit;
  end;
  FTimelineList.Clear;
  if FZielbase = nil then
    exit;
  for i1 := 0 to FBasen.Count - 1 do
  begin
    Base := FBasen.Base[i1];
    if Base.Felder > Base.Punkte then
      continue;
    if (Base.Koordinate.X = FZielbase.Koordinate.X) and (Base.Koordinate.Y = FZielbase.Koordinate.Y) then
      continue;

    if Base.Carrack.Anzahl > 0 then
    begin
      Timeline := FTimelineList.Add;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Carrack  := Base.Carrack.Anzahl;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Ankunftsort := Base.Carrack.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Carrack.Laufzeit.Ankunft;
      Timeline.Knocker := Base.Knocker.Anzahl;
      Timeline.Mortar := Base.Mortar.Anzahl;
      Timeline.Molotov := Base.Molotov.Anzahl;
      Timeline.Gunner := Base.Gunner.Anzahl;
      Timeline.Pickup := Base.Pickup.Anzahl;
      Timeline.Ranger := Base.Ranger.Anzahl;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if Base.Knocker.Anzahl > 0 then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Knocker.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Knocker.Laufzeit.Ankunft;
      Timeline.Knocker := Base.Knocker.Anzahl;
      Timeline.Mortar := Base.Mortar.Anzahl;
      Timeline.Molotov := Base.Molotov.Anzahl;
      Timeline.Gunner := Base.Gunner.Anzahl;
      Timeline.Pickup := Base.Pickup.Anzahl;
      Timeline.Ranger := Base.Ranger.Anzahl;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if Base.Mortar.Anzahl > 0 then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Mortar.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Mortar.Laufzeit.Ankunft;
      Timeline.Mortar := Base.Mortar.Anzahl;
      Timeline.Molotov := Base.Molotov.Anzahl;
      Timeline.Gunner := Base.Gunner.Anzahl;
      Timeline.Pickup := Base.Pickup.Anzahl;
      Timeline.Ranger := Base.Ranger.Anzahl;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if Base.Molotov.Anzahl > 0 then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Molotov.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Molotov.Laufzeit.Ankunft;
      Timeline.Molotov := Base.Molotov.Anzahl;
      Timeline.Gunner := Base.Gunner.Anzahl;
      Timeline.Pickup := Base.Pickup.Anzahl;
      Timeline.Ranger := Base.Ranger.Anzahl;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if Base.Gunner.Anzahl > 0 then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Gunner.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Gunner.Laufzeit.Ankunft;
      Timeline.Gunner := Base.Gunner.Anzahl;
      Timeline.Pickup := Base.Pickup.Anzahl;
      Timeline.Ranger := Base.Ranger.Anzahl;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if (Base.Pickup.Anzahl > 0) or (Base.Ranger.Anzahl > 0) then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Pickup.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Pickup.Laufzeit.Ankunft;
      Timeline.Pickup := Base.Pickup.Anzahl;
      Timeline.Ranger := Base.Ranger.Anzahl;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if (Base.Scout.Anzahl > 0) then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Scout.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Scout.Laufzeit.Ankunft;
      Timeline.Scout := Base.Scout.Anzahl;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if (Base.Buggy.Anzahl > 0) then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Buggy.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Buggy.Laufzeit.Ankunft;
      Timeline.Buggy := Base.Buggy.Anzahl;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if (Base.Trike.Anzahl > 0) then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Trike.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Trike.Laufzeit.Ankunft;
      Timeline.Trike := Base.Trike.Anzahl;
      Timeline.Biker := Base.Biker.Anzahl;
    end;

    if (Base.Biker.Anzahl > 0) then
    begin
      Timeline := FTimelineList.Add;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Biker.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Biker.Laufzeit.Ankunft;
      Timeline.Biker := Base.Biker.Anzahl;
    end;
  end;
  FTimelineList.Sort;
  FFrameGrid.TimelineList := FTimelineList;
end;


procedure Tfrm_CrazyTribes.AktualTimeline_Angriff;
  function getAnzahl(aEinheit: TEinheit): Integer;
  begin
    Result := 0;
    if aEinheit.Angriffmode then
      Result := aEinheit.Anzahl;
  end;
var
  i1, i2: Integer;
  Base: TBase;
  Timeline: TTimeline;
  InAngriffMode: Boolean;
begin
  FTimelineList.Clear;
  if FZielbase = nil then
    exit;
  for i1 := 0 to FBasen.Count - 1 do
  begin
    Base := FBasen.Base[i1];
    if Base.Felder > Base.Punkte then
      continue;
    if (Base.Koordinate.X = FZielbase.Koordinate.X) and (Base.Koordinate.Y = FZielbase.Koordinate.Y) then
      continue;

    InAngriffMode := false;
    for i2 := 0 to Base.EinheitCount - 1 do
    begin
      if (Base.Einheit[i2].Angriffmode) and (Base.Einheit[i2].Anzahl > 0) then
      begin
        InAngriffMode := true;
        break;
      end;
    end;

    if not InAngriffmode then
      continue;

    Timeline :=  FTimelineList.Add;
    Timeline.Carrack := getAnzahl(TEinheit(Base.Carrack));
    Timeline.Knocker := getAnzahl(TEinheit(Base.Knocker));
    Timeline.Mortar := getAnzahl(TEinheit(Base.Mortar));
    Timeline.Molotov := getAnzahl(TEinheit(Base.Molotov));
    Timeline.Gunner := getAnzahl(TEinheit(Base.Gunner));
    Timeline.Pickup := getAnzahl(TEinheit(Base.Pickup));
    Timeline.Ranger := getAnzahl(TEinheit(Base.Ranger));
    Timeline.Scout := getAnzahl(TEinheit(Base.Scout));
    Timeline.Buggy := getAnzahl(TEinheit(Base.Buggy));
    Timeline.Trike := getAnzahl(TEinheit(Base.Trike));
    Timeline.Biker := getAnzahl(TEinheit(Base.Biker));

    if (Base.Carrack.Anzahl > 0) and (Base.Carrack.Angriffmode) then
    begin
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Ankunftsort := Base.Carrack.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Carrack.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Knocker.Anzahl > 0) and (Base.Knocker.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Knocker.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Knocker.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Mortar.Anzahl > 0) and (Base.Mortar.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Mortar.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Mortar.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Molotov.Anzahl > 0) and (Base.Molotov.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Molotov.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Molotov.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Gunner.Anzahl > 0) and (Base.Gunner.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Gunner.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Gunner.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Pickup.Anzahl > 0) or (Base.Ranger.Anzahl > 0) then
    begin
      if (Base.Pickup.Angriffmode) or (Base.Ranger.Angriffmode) then
      begin
        Timeline.FelderOk := Base.FelderOk;
        Timeline.Basename := Base.Basename;
        Timeline.Koordinate.AsString := Base.Koordinate.AsString;
        Timeline.Ankunftsort := Base.Pickup.Laufzeit.Ankunftsort;
        Timeline.Ankunft     := Base.Pickup.Laufzeit.Ankunft;
        continue;
      end;
    end;

    if (Base.Scout.Anzahl > 0) and (Base.Scout.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Scout.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Scout.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Buggy.Anzahl > 0) and (Base.Buggy.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Buggy.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Buggy.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Trike.Anzahl > 0) and (Base.Trike.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Trike.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Trike.Laufzeit.Ankunft;
      continue;
    end;

    if (Base.Biker.Anzahl > 0) and (Base.Biker.Angriffmode) then
    begin
      Timeline.FelderOk := Base.FelderOk;
      Timeline.Basename := Base.Basename;
      Timeline.Koordinate.AsString := Base.Koordinate.AsString;
      Timeline.Ankunftsort := Base.Biker.Laufzeit.Ankunftsort;
      Timeline.Ankunft     := Base.Biker.Laufzeit.Ankunft;
      continue;
    end;
  end;
  FTimelineList.Sort;
  FFrameGrid.TimelineList := FTimelineList;
end;



procedure Tfrm_CrazyTribes.TimelineDblClick(Sender: TObject;
  aKoordinate: TKoordinate);
var
  i1: Integer;
  Base: TBase;
begin
  for i1 := 0 to FBasen.Count - 1 do
  begin
    Base := FBasen.Base[i1];
    if (Base.Koordinate.X = aKoordinate.X) and (Base.Koordinate.Y = aKoordinate.Y) then
    begin
      FFrameBase.Base := Base;
      exit;
    end;
  end;
end;






end.
