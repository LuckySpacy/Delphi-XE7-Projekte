unit Objekt.Global;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Objekt.Ini,
  Objekt.MySqlSettings;

type
  TGlobal = class
  private
    fIni: TIni;
    fMySql: TMySqlSettings;
  public
    constructor Create;
    destructor Destroy; override;
    property Ini: TIni read fIni write fIni;
    property MySql: TMySqlSettings read fMySql write fMySql;
  end;

var
  Global: TGlobal;

implementation

{ TGlobal }

constructor TGlobal.Create;
begin
  fIni := TIni.Create;
  fMySql := TMySqlSettings.Create;
end;

destructor TGlobal.Destroy;
begin
  FreeAndNil(fIni);
  FreeAndNil(fMySql);
  inherited;
end;

end.
