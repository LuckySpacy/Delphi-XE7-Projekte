unit VW.Ordner;

interface

uses
  SysUtils, Classes, Graphics, Field.Icon;

type
  TVWOrdner = class
  private
    fBP_BI_Id: Integer;
    fBP_Id: Integer;
    fBP_UsePw: Boolean;
    fBB_Id: Integer;
    fBP_IT_Id: Integer;
    fBB_Ebene: Integer;
    fBP_Text: string;
    fBI_Bild: TMemoryStream;
    fIcon: TIco;
    fBI_Id: Integer;
    function getIcon: TIco;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property BB_Id: Integer read fBB_Id write fBB_Id;
    property BB_Ebene: Integer read fBB_Ebene write fBB_Ebene;
    property BP_Id: Integer read fBP_Id write fBP_Id;
    property BP_UsePw: Boolean read fBP_UsePw write fBP_UsePw;
    property BP_IT_Id: Integer read fBP_IT_Id write fBP_IT_Id;
    property BP_BI_Id: Integer read fBP_BI_Id write fBP_BI_Id;
    property BP_Text: string read fBP_Text write fBP_Text;
    property BI_Id: Integer read fBI_Id write fBI_Id;
    property Icon: TIco read getIcon;
  end;

implementation

{ TVWOrdner }

constructor TVWOrdner.Create;
begin
  inherited;
  Init;
  fIcon := TIco.Create(nil);
end;

destructor TVWOrdner.Destroy;
begin
  FreeAndNil(fIcon);
  inherited;
end;

function TVWOrdner.getIcon: TIco;
begin
  Result := fIcon;
end;

procedure TVWOrdner.Init;
begin
  fBP_BI_Id := 0;
  fBP_Id    := 0;
  fBP_UsePw := false;
  fBB_Id    := 0;
  fBP_IT_Id := 0;
  fBB_Ebene := 0;
  fBP_Text  := '';
  fBI_Id := 0;
end;


end.
