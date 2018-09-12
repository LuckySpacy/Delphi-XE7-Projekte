program CrazyTribes;

uses
  Forms,
  u_CrazyTribes in 'u_CrazyTribes.pas' {frm_CrazyTribes},
  m_Base in 'm_Base.pas' {fra_Base: TFrame},
  c_Geschwindigkeit in '..\Allgemein\c_Geschwindigkeit.pas',
  o_Biker in '..\Allgemein\o_Biker.pas',
  o_Gunner in '..\Allgemein\o_Gunner.pas',
  o_Knocker in '..\Allgemein\o_Knocker.pas',
  o_Molotov in '..\Allgemein\o_Molotov.pas',
  o_Mortar in '..\Allgemein\o_Mortar.pas',
  o_Pickup in '..\Allgemein\o_Pickup.pas',
  o_Ranger in '..\Allgemein\o_Ranger.pas',
  o_Scout in '..\Allgemein\o_Scout.pas',
  o_Buggy in '..\Allgemein\o_Buggy.pas',
  o_Carrack in '..\Allgemein\o_Carrack.pas',
  o_Einheit in '..\Allgemein\o_Einheit.pas',
  o_Koordinate in '..\Allgemein\o_Koordinate.pas',
  o_CustomBase in '..\Allgemein\o_CustomBase.pas',
  o_Trike in '..\Allgemein\o_Trike.pas',
  o_Base in '..\Allgemein\o_Base.pas',
  o_BaseList in '..\Allgemein\o_BaseList.pas',
  o_CustomBasen in '..\Allgemein\o_CustomBasen.pas',
  o_Basen in '..\Allgemein\o_Basen.pas',
  fnt_Base in 'fnt_Base.pas' {frm_Base},
  o_Einheitdatei in '..\Allgemein\o_Einheitdatei.pas',
  o_EinheitdateiObj in '..\Allgemein\o_EinheitdateiObj.pas',
  fnt_ZielbaseLaden in 'fnt_ZielbaseLaden.pas' {frm_ZielbaseLaden},
  u_System in '..\..\Allgemein\Units\u_System.pas',
  o_sysfolderlocation in '..\..\Allgemein\Units\o_sysfolderlocation.pas',
  o_Entfernung in '..\Allgemein\o_Entfernung.pas',
  o_EntfernungList in '..\Allgemein\o_EntfernungList.pas',
  o_TimeObj in '..\Allgemein\o_TimeObj.pas',
  m_Grid in 'm_Grid.pas' {fra_Grid: TFrame},
  o_Timeline in '..\Allgemein\o_Timeline.pas',
  o_TimelineList in '..\Allgemein\o_TimelineList.pas',
  fnt_EntfernungLaufzeit in 'fnt_EntfernungLaufzeit.pas' {frm_Entfernung_Lauftzeit},
  c_AllgTypes in '..\..\Allgemein\Units\c_AllgTypes.pas',
  fnt_Spielwelt in 'fnt_Spielwelt.pas' {frm_Spielwelt},
  fnt_SpielweltNeu in 'fnt_SpielweltNeu.pas' {frm_SpielweltNeu},
  o_HexFeld in '..\Allgemein\o_HexFeld.pas',
  o_Pathfinder in '..\Allgemein\o_Pathfinder.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrm_CrazyTribes, frm_CrazyTribes);
  Application.Run;
end.
