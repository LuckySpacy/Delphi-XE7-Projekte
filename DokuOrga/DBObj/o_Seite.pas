unit o_Seite;

interface

uses
  SysUtils, Classes, o_Seite_BaseStruk;

type
  TSeite = class(TSeite_BaseStruk)
  private
    FPW: string;
  protected
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Init; override;
    property PW: string read FPW write FPW;
    function HeaderPlainText: string;
  end;


implementation

{ TSeite }

uses
  c_DBTypes, o_sysobj, tbRichviewEdit;

constructor TSeite.Create(AOwner: TComponent);
begin
  inherited;

end;

destructor TSeite.Destroy;
begin

  inherited;
end;

function TSeite.HeaderPlainText: string;
var
  RTFText: string;
begin
  if (Feld(SE_PW).AsString > '') then
    RTFText := sysobj.Entschluesseln(Feld(SE_HEADER).AsString, Feld(SE_PW).AsString)
  else
    RTFText := Feld(SE_HEADER).AsString;
  Result := TtbRichviewEdit.PlainText(RTFText);
end;

procedure TSeite.Init;
begin
  inherited;

end;

end.
