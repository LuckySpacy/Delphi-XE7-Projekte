unit frame_NeueAktie;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, o_aktie;

type
  Tfra_NeueAktie = class(TFrame)
    Label2: TLabel;
    Label3: TLabel;
    edt_WKN: TEdit;
    edt_Name: TEdit;
  private
    FAktie: TAktie;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Save;
  end;

implementation

{$R *.dfm}

uses
  untDM;

{ Tfra_NeueAktie }

constructor Tfra_NeueAktie.Create(AOwner: TComponent);
begin
  inherited;
  edt_WKN.Text  := '';
  edt_Name.Text := '';
  if dm.IBT.InTransaction then
    dm.IBT.Rollback;
  FAktie := TAktie.Create(Self, dm.IBT);
end;

destructor Tfra_NeueAktie.Destroy;
begin
  FreeAndNil(FAktie);
  inherited;
end;

procedure Tfra_NeueAktie.Save;
begin
  FAktie.ReadWKN(edt_WKN.Text);
  if FAktie.Found then
  begin
    ShowMessage('WKN wird nicht gespeichert, da schon vorhanden.');
    exit;
  end;

  FAktie.WKN.AsString  := edt_WKN.Text;
  FAktie.Name.AsString := edt_Name.Text;
  FAktie.Save;
  FAktie.Commit;
end;

end.
