unit VW.Zweig;

interface

uses
  SysUtils, Classes, Graphics;

type
  TVWZweig = class
  private
    fBS_ID: Integer;
    fBS_BB_ID: Integer;
    fBS_Ebene: Integer;
    fZP_BI_ID: Integer;
    fZP_ID: Integer;
    fZP_Text: string;
    fBS_ZP_ID: Integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property BS_ID: Integer read fBS_ID write fBS_ID;
    property BS_Ebene: Integer read fBS_Ebene write fBS_Ebene;
    property BS_ZP_ID: Integer read fBS_ZP_ID write FBS_ZP_ID;
    property BS_BB_ID: Integer read fBS_BB_ID write fBS_BB_Id;
    property ZP_ID: Integer read fZP_ID write FZP_Id;
    property ZP_Text: string read fZP_Text write fZP_Text;
    property ZP_BI_ID: Integer read fZP_BI_ID write fZP_BI_ID;
  end;

implementation

{ TVWZweig }

constructor TVWZweig.Create;
begin

end;

destructor TVWZweig.Destroy;
begin

  inherited;
end;

procedure TVWZweig.Init;
begin
  fBS_ID    := 0;
  fBS_BB_ID := 0;
  fBS_Ebene := 0;
  fZP_BI_ID := 0;
  fZP_ID    := 0;
  fZP_Text  := '';
  fBS_ZP_ID := 0;
end;

end.
