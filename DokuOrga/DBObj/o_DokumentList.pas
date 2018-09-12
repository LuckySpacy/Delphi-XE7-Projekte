unit o_DokumentList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Sprache,
  o_Dokument_BaseStrukList;


type
  TDokumentList = class(TDokumentBaseStrukList)
  private
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
  end;

implementation

{ TDokumentList }

constructor TDokumentList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TDokumentList.Destroy;
begin

  inherited;
end;

procedure TDokumentList.Init;
begin
  inherited;

end;

end.
