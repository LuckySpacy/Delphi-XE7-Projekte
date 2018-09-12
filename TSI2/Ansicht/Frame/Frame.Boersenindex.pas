unit Frame.Boersenindex;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, MySql.Boersenindexlist,
  MySql.Boersenindex;

type
  TChangedBoersenindex=procedure(Sender: TObject; aBI_ID: Integer) of object;

type
  Tfra_Boersenindex = class(TFrame)
    cbo_BI: TComboBox;
    procedure cbo_BIChange(Sender: TObject);
  private
    fBoersenindexList: TMySqlBoersenindexList;
    fChangedBoersenindex: TChangedBoersenindex;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure LadeComboBox;
    property OnChangedBoersenindex: TChangedBoersenindex read fChangedBoersenindex write fChangedBoersenindex;
  end;

implementation

{$R *.dfm}

{ Tfra_Boersenindex }


constructor Tfra_Boersenindex.Create(AOwner: TComponent);
begin
  inherited;
  fBoersenindexList := TMySqlBoersenindexList.Create(nil);
  LadeComboBox;
end;

destructor Tfra_Boersenindex.Destroy;
begin
  FreeAndNil(fBoersenindexList);
  inherited;
end;

procedure Tfra_Boersenindex.LadeComboBox;
var
  i1: Integer;
begin
  cbo_BI.Clear;
  fBoersenindexList.ReadAll;
  for i1 := 0 to fBoersenindexList.Count -1 do
    cbo_bi.AddItem(fBoersenindexList.Item[i1].Boersenname, TObject(fBoersenindexList.Item[i1]));
  cbo_BI.ItemIndex := 0;
end;

procedure Tfra_Boersenindex.cbo_BIChange(Sender: TObject);
begin
  if Assigned(fChangedBoersenindex) then
    fChangedBoersenindex(Self, TMySqlBoersenindex(cbo_BI.Items.Objects[cbo_BI.ItemIndex]).BI_ID);

end;


end.
