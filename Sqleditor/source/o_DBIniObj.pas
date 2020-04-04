unit o_DBIniObj;

interface

uses
  SysUtils, Classes, Contnrs, c_types;

type
  TDBIniObj = class
  private
    FVerzeichnis: string;
    FSection: string;
    FLaufwerk: string;
    FDatenbankname: string;
    FServer: string;
    FDatenbank: TcDatenbank;
    FPasswort: string;
    FBenutzer: string;
    FLaufwerkIndex: Integer;
    FPort: Integer;
    function getLaufwerk: string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Init;
    property Section: string read FSection write FSection;
    property Server: string read FServer write FServer;
    property Laufwerk: string read getLaufwerk;
    property LaufwerkIndex: Integer read FLaufwerkIndex write FLaufwerkIndex;
    property Verzeichnis: string read FVerzeichnis write FVerzeichnis;
    property Datenbankname: string read FDatenbankname write FDatenbankname;
    property Datenbank: TcDatenbank read FDatenbank write FDatenbank;
    property Benutzer: string read FBenutzer write FBenutzer;
    property Passwort: string read FPasswort write FPasswort;
    property Port: Integer read FPort write FPort;
    procedure CopyFrom(aSource: TDBIniObj);
  end;

type
  TDBIniObjList = class
  private
    function GetCount: Integer;
    function GetDBIniObj(Index: Integer): TDBIniObj;
  protected
    FList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    property Count: Integer read GetCount;
    function Add: TDBIniObj;
    property Item[Index: Integer]: TDBIniObj read GetDBIniObj;
    function getSection(aSectionname: string): TDBIniObj;
    procedure Clear;
  end;


implementation

{ TDBIniObj }


constructor TDBIniObj.Create;
begin
  Init;
end;

destructor TDBIniObj.Destroy;
begin

  inherited;
end;



procedure TDBIniObj.Init;
begin
  FVerzeichnis   := '';
  FSection       := '';
  FDatenbankname := '';
  FServer        := '';
  FBenutzer      := '';
  FPasswort      := '';
  FDatenbank     := cFirebird;
  FLaufwerkIndex := -1;
  FPort := -1;
end;


procedure TDBIniObj.CopyFrom(aSource: TDBIniObj);
begin
  FSection       := aSource.Section;
  FServer        := aSource.Server;
  FDatenbankname := aSource.Datenbankname;
  FVerzeichnis   := aSource.Verzeichnis;
  FDatenbank     := aSource.Datenbank;
  FBenutzer      := aSource.Benutzer;
  FPasswort      := aSource.Passwort;
  FLaufwerkIndex := aSource.LaufwerkIndex;
  FPort          := aSource.Port;
end;



{ TDBIniObjList }



constructor TDBIniObjList.Create;
begin
  FList := TObjectList.Create;
end;

destructor TDBIniObjList.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

procedure TDBIniObjList.Clear;
begin
  FreeAndNil(FList);
  FList := TObjectList.Create;
end;


function TDBIniObjList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TDBIniObjList.Add: TDBIniObj;
begin
  Result := TDBIniObj.Create;
  FList.Add(Result);
end;


{
function TDBIniObj.getiLaufwerk: Integer;
begin
  Result := -1;
  if Length(Laufwerk) >= 1 then
    Result := ord(Laufwerk[1]) - 65;
end;
}


function TDBIniObj.getLaufwerk: string;
begin
  Result := '';
  if FLaufwerkIndex > -1 then
  begin
    Result := chr(FLaufwerkIndex + 65);
    Result := Result + ':';
  end;

end;



function TDBIniObjList.GetDBIniObj(Index: Integer): TDBIniObj;
begin
  Result := nil;
  if Index > FList.Count -1 then
    exit;
  Result := TDBIniObj(FList[Index]);
end;

function TDBIniObjList.getSection(aSectionname: string): TDBIniObj;
var
  i1: Integer;
  x: TDBIniObj;
begin
  Result := nil;
  for i1 := 0 to FList.Count -1 do
  begin
    x := Item[i1];
    if SameText(x.Section, aSectionname) then
    begin
      Result := x;
      exit;
    end;
  end;
end;

end.
