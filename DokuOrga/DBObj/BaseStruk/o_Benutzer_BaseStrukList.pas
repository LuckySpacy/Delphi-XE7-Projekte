unit o_Benutzer_BaseStrukList;

interface

uses
  SysUtils, Classes, o_DBObj, IBDatabase, IBQuery, Contnrs, o_DBObjList, o_Benutzer;


type
  TBenutzerBaseStrukList = class(TDBObjList)
  private
    function GetBenutzer(Index: Integer): TBenutzer;
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
    property Item[Index: Integer]: TBenutzer read GetBenutzer;
    function getNotifyIndex: Integer; override;
  end;

implementation

{ TBenutzerBaseStrukList }

constructor TBenutzerBaseStrukList.Create(AOwner: TComponent);
begin
  inherited;
  Init;
end;

destructor TBenutzerBaseStrukList.Destroy;
begin

  inherited;
end;


function TBenutzerBaseStrukList.Add(aQuery: TIBQuery): TDBObj;
var
  Benutzer: TBenutzer;
begin
  Benutzer := TBenutzer.Create(nil);
  Benutzer.LoadByQuery(aQuery);
  Result := TDBObj(Benutzer);
end;

function TBenutzerBaseStrukList.GetBenutzer(Index: Integer): TBenutzer;
begin
  Result := TBenutzer(getItem(Index));
end;

function TBenutzerBaseStrukList.getGeneratorName: string;
begin
  Result := 'BE_ID';
end;

function TBenutzerBaseStrukList.getNotifyIndex: Integer;
begin
  Result := 0;
end;

function TBenutzerBaseStrukList.getTableName: string;
begin
  Result := 'BENUTZER';
end;

function TBenutzerBaseStrukList.getTablePrefix: string;
begin
  Result := 'BE';
end;

procedure TBenutzerBaseStrukList.Init;
begin
  inherited;

end;

end.
