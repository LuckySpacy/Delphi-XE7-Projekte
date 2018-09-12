unit o_Dokument_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Dokument;


type
  TDokumentBaseStrukList = class(TDBObjList)
  private
    function GetDokument(Index: Integer): TDokument;
  protected
    FCount: Integer;
    function getTableName: string; override;
    function getTablePrefix: string; override;
    function getGeneratorName: string; override;
    function Add(aQuery: TIBQuery): TDBObj; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property Item[Index: Integer]: TDokument read GetDokument;
  end;


implementation

{ TDokumentBaseStrukList }

constructor TDokumentBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TDokumentBaseStrukList.Destroy;
begin

  inherited;
end;


function TDokumentBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Dokument: TDokument;
begin
  Dokument := TDokument.Create(nil);
  Dokument.LoadByQuery(aQuery);
  Result := TDBObj(Dokument);
end;



function TDokumentBaseStrukList.GetDokument(Index: Integer): TDokument;
begin
  Result := TDokument(getItem(Index));
end;

function TDokumentBaseStrukList.getGeneratorName: string;
begin
  Result := 'DO_ID';
end;

function TDokumentBaseStrukList.getTableName: string;
begin
  Result := 'DOKUMENT';
end;

function TDokumentBaseStrukList.getTablePrefix: string;
begin
  Result := 'DO';
end;

procedure TDokumentBaseStrukList.Init;
begin
  inherited;

end;

end.
