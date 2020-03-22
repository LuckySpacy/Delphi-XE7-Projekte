unit Objekt.Protokoll;

interface

uses
  SysUtils, Classes, variants;


type
  TProtokoll = class(TComponent)
  private
    fList: TStringList;
    fProtokollPfad: String;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function Protokollpfad: string;
    function Filename: string;
    procedure write(aFunction, aValue: string);
    procedure Clear;
    property List: TStringList read fList write fList;
  end;

var
  Protokoll: TProtokoll;

implementation

{ TProtokoll }

uses
  Objekt.Ini;


constructor TProtokoll.Create(AOwner: TComponent);
begin
  inherited;
  fList := TStringList.Create;
  fProtokollPfad := '';
end;

destructor TProtokoll.Destroy;
begin
  FreeAndNil(fList);
  inherited;
end;

function TProtokoll.Filename: string;
begin
  Result := Protokollpfad + 'Protokoll.txt';
end;

function TProtokoll.Protokollpfad: string;
begin
  if fProtokollPfad > '' then
  begin
    Result := fProtokollPfad;
    exit;
  end;
  Result := Ini.UserPfad + 'Protokoll\';

  if not DirectoryExists(Result) then
    ForceDirectories(Result);

end;

procedure TProtokoll.write(aFunction, aValue: string);
var
  s: string;
begin
  if (fList.Text = '') and (FileExists(Filename)) then
    fList.LoadFromFile(Filename);
  s := FormatDateTime('dd.mm.yyyy hh:nn:ss', now) + ' - ' + aFunction + ' - ' +aValue;
  fList.Add(s);
  fList.SaveToFile(Filename);
end;

procedure TProtokoll.Clear;
begin
  DeleteFile(Filename);
end;


end.
