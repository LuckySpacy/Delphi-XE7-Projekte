unit Frame.Ordnervergleich;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Frame.AdvGridBase, Vcl.Grids, AdvObj,
  BaseGrid, AdvGrid;

type
  Tfra_Ordnervergleich = class(Tfra_AdvGridBase)
  private
    function getSelectedPfad: string;
    function getSelectedTitel: string;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property SelectedPfad: string read getSelectedPfad;
    property SelectedTitel: string read getSelectedTitel;
    procedure DeleteSelectedRow;
  end;

var
  fra_Ordnervergleich: Tfra_Ordnervergleich;

implementation

{$R *.dfm}

{ Tfra_Ordnervergleich }

constructor Tfra_Ordnervergleich.Create(AOwner: TComponent);
begin //
  inherited;

end;

procedure Tfra_Ordnervergleich.DeleteSelectedRow;
begin
  if grd.Row = 0 then
    exit;
  grd.RemoveNormalRow(grd.Row);
end;

destructor Tfra_Ordnervergleich.Destroy;
begin //

  inherited;
end;

function Tfra_Ordnervergleich.getSelectedPfad: string;
begin
  Result := '';
  if grd.Row = 0 then
    exit;
  Result := grd.Cells[fcol.Pfad, grd.Row];
end;

function Tfra_Ordnervergleich.getSelectedTitel: string;
begin
  Result := '';
  if grd.Row = 0 then
    exit;
  Result := grd.Cells[fcol.Titel, grd.Row];
end;

end.
