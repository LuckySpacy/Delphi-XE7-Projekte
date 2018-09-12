unit o_Dokument;

interface

uses
  SysUtils, Classes, o_Dokument_BaseStruk, o_sysobj;

type
  TDokument = class(TDokument_BaseStruk)
  private
    function getFullFilename: string;
    function getPfad: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    procedure Read(aDateiname, aPfad: string); reintroduce; overload;
    property FullFilename: string read getFullFilename;
    property Pfad: string read getPfad;
    function ExistSeite: Boolean;
  end;

implementation

{ TDokument }

uses
  c_DBTypes;

constructor TDokument.Create(AOwner: TComponent);
begin
  inherited;

end;


destructor TDokument.Destroy;
begin

  inherited;
end;




function TDokument.getFullFilename: string;
begin
  Result := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString + Feld(DO_PFAD).AsString) + Feld(DO_DATEINAME).AsString;
end;

function TDokument.getPfad: string;
begin
  Result := IncludeTrailingPathDelimiter(SysObj.Einstellung.DokumentPfad.AsString) + Feld(DO_PFAD).AsString;
  Result := Result + IncludeTrailingPathDelimiter(Result);
end;

procedure TDokument.Init;
begin
  inherited;

end;

procedure TDokument.Read(aDateiname, aPfad: string);
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from  ' + getTableName +
                     ' where lower(DO_DATEINAME) = ' + QuotedStr(LowerCase(aDateiname)) +
                     ' and lower(DO_PFAD) = ' + QuotedStr(LowerCase(aPfad)) +
                     ' and DO_DELETE != ' + QuotedStr('T');
  OpenTrans;
  FQuery.Open;
  LoadByQuery(FQuery);
  RollbackTrans;
end;


function TDokument.ExistSeite: Boolean;
begin
  FQuery.Close;
  FQuery.Transaction := getTrans;
  FQuery.SQL.Text := ' select * from seitedokument ' +
                     ' where sd_do_id = ' + IntToStr(Id) +
                     ' and sd_DELETE != ' + QuotedStr('T');
  OpenTrans;
  FQuery.Open;
  Result := not FQuery.eof;
  RollbackTrans;
end;


end.
