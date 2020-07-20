unit DB.FirmaArtikel;

interface

uses
  SysUtils, Classes, DB.Base, Data.DB, mySQLDbTables;

type
  TDBFirmaArtikel = class(TDBBase)
  private
    fWebseite: String;
    fImageUrl: string;
    fFi_Id: Integer;
    fAr_Id: Integer;
    fNr: string;
    procedure setFi_Id(const Value: Integer);
    procedure setImageUrl(const Value: string);
    procedure setWebseite(const Value: String);
    procedure setAr_Id(const Value: Integer);
    procedure setNr(const Value: string);
  protected
    function getGeneratorName: string; override;
    function getTableName: string; override;
    function getTablePrefix: string; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Fi_Id: Integer read fFi_Id write setFi_Id;
    property Ar_Id: Integer read fAr_Id write setAr_Id;
    property Nr: string read fNr write setNr;
    property Webseite: String read fWebseite write setWebseite;
    property ImageUrl: string read fImageUrl write setImageUrl;
    procedure Init; override;
    procedure LoadByQuery(aQuery: TMySQLQuery); override;
    procedure Save;
    procedure Delete;
    procedure DeleteArtikel(aAr_id: Integer);
    procedure Read(aId: Integer); override;
    function CheckFirmenNr(aId: Integer; aNr: string): Boolean;
 end;

implementation

{ TDBFirmaArtikel }

uses
  Dialogs;


constructor TDBFirmaArtikel.Create(AOwner: TComponent);
begin
  inherited;

end;


destructor TDBFirmaArtikel.Destroy;
begin

  inherited;
end;

function TDBFirmaArtikel.getGeneratorName: string;
begin
  Result := 'FA_ID';
end;

function TDBFirmaArtikel.getTableName: string;
begin
  Result := 'FirmaArtikel';
end;

function TDBFirmaArtikel.getTablePrefix: string;
begin
  Result := 'FA';
end;

procedure TDBFirmaArtikel.Init;
begin
  inherited;
  fFi_Id := 0;
  fAr_Id := 0;
  fImageUrl := '';
  fWebseite := '';
  fNr := '';
end;

procedure TDBFirmaArtikel.LoadByQuery(aQuery: TMySQLQuery);
begin
  inherited;
  if aQuery.Eof then
    exit;
  fFi_Id    := aQuery.FieldByName('fa_fi_id').AsInteger;
  fAr_Id    := aQuery.FieldByName('fa_ar_id').AsInteger;
  fImageUrl := aQuery.FieldByName('fa_imageurl').AsString;
  fWebseite := aQuery.FieldByName('fa_webseite').AsString;
  fNr       := aQuery.FieldByName('fa_nr').AsString;
end;

procedure TDBFirmaArtikel.Read(aId: Integer);
begin
  inherited Read(aId);
  LoadByQuery(fQuery);
  fQuery.Close;
end;

procedure TDBFirmaArtikel.Save;
var
  Sql: string;
begin
  if fId = 0 then
    Sql := ' insert into firmaartikel (fa_fi_id, fa_ar_id, fa_imageurl, fa_webseite, fa_nr)' +
           ' values (:fiid, :arid, :imageurl, :webseite, :nr)'
  else
    Sql := ' update firmaartikel set fa_fi_id = :fiid, fa_ar_id = :arid, fa_imageurl = :imageurl, fa_webseite = :webseite, fa_nr = :nr'  +
           ' where fa_id = ' + IntToStr(fId);

 fQuery.SQL.Text := Sql;
 fQuery.ParamByName('fiid').AsInteger := ffi_id;
 fQuery.ParamByName('arid').AsInteger := far_id;
 fQuery.ParamByName('imageurl').AsString := fImageUrl;
 fQuery.ParamByName('webseite').AsString := fWebseite;
 fQuery.ParamByName('nr').AsString       := Trim(fNr);
 fQuery.ExecSQL;
end;

function TDBFirmaArtikel.CheckFirmenNr(aId: Integer; aNr: string): Boolean;
begin
  Result := false;
  if Trim(aNr) > '' then
  begin
    if aId = 0 then
      fQuery.SQL.Text := 'select fa_id from firmaartikel where fa_nr = :nr'
    else
      fQuery.SQL.Text := 'select fa_id from firmaartikel where fa_nr = :nr and fa_id <> ' + IntToStr(aId);
    fQuery.ParamByName('nr').AsString := Trim(aNr);
    fQuery.Open;
    Result := not fQuery.Eof;
    fQuery.Close;
  end;
end;


procedure TDBFirmaArtikel.setAr_Id(const Value: Integer);
begin
  fAr_Id := Value;
  UpdateV(fAr_Id, Value);
end;

procedure TDBFirmaArtikel.setFi_Id(const Value: Integer);
begin
  UpdateV(fFi_Id, Value);
end;

procedure TDBFirmaArtikel.setImageUrl(const Value: string);
begin
  UpdateV(fImageUrl, Value);
end;

procedure TDBFirmaArtikel.setNr(const Value: string);
begin
  UpdateV(fNr, Value);
end;

procedure TDBFirmaArtikel.setWebseite(const Value: String);
begin
  UpdateV(fWebseite, Value);
end;

procedure TDBFirmaArtikel.Delete;
var
  Sql: string;
begin
  Sql := 'delete from ' + getTableName + ' where ' + getGeneratorName + ' = ' + IntToStr(fId);
  fQuery.SQL.Text := Sql;
  fQuery.ExecSQL;
end;


procedure TDBFirmaArtikel.DeleteArtikel(aAr_id: Integer);
var
  Sql: string;
begin
  Sql := 'delete from ' + getTableName + ' where fa_ar_id = ' + IntToStr(aAr_Id);
  fQuery.SQL.Text := Sql;
  fQuery.ExecSQL;
end;

end.
