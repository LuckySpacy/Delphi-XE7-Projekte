unit Objekt.MySqlSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls,
  Allgemein.SysFolderlocation, Allgemein.Types, Allgemein.RegIni, shellapi,
  Objekt.Ini;

type
  TMySqlSettings = class
  private
    fIni: TIni;
    function getBoersenindexLink: string;
    function getTSIAnsichtLink: string;
    function getAktieLink: string;
    function getKursLink: string;
    function getTSIWochenLink: string;
  public
    constructor Create;
    destructor Destroy; override;
    property BoersenindexLink: string read getBoersenindexLink;
    property TSIAnsichtLink: string read getTSIAnsichtLink;
    property AktieLink: string read getAktieLink;
    property KursLink: string read getKursLink;
    property TSIWochenLink: string read getTSIWochenLink;
  end;

implementation

{ TMySqlSettings }

constructor TMySqlSettings.Create;
begin
  fIni := TIni.Create;

end;

destructor TMySqlSettings.Destroy;
begin
  FreeAndNil(fIni);
  inherited;
end;

function TMySqlSettings.getAktieLink: string;
begin
  Result := 'http://' + fIni.Host + 'TSI/aktie.php';
end;

function TMySqlSettings.getBoersenindexLink: string;
begin
  Result := 'http://' + fIni.Host + 'TSI/boersenindex.php';
end;

function TMySqlSettings.getKursLink: string;
begin
  Result := 'http://' + fIni.Host + 'TSI/kurs.php';
end;

function TMySqlSettings.getTSIAnsichtLink: string;
begin
  Result := 'http://' + fIni.Host + 'TSI/tsiansicht.php';
end;

function TMySqlSettings.getTSIWochenLink: string;
begin
  Result := 'http://' + fIni.Host + 'TSI/tsiwochen.php';
end;

end.
