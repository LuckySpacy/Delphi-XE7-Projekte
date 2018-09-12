unit o_BenutzerList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Benutzer_BaseStrukList;


type
  TBenutzerList = class(TBenutzerBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TBenutzerList }

constructor TBenutzerList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBenutzerList.Destroy;
begin

  inherited;
end;

procedure TBenutzerList.Init;
begin
  inherited;

end;

end.
