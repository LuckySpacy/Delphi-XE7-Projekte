unit Form.KurseLaden;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls,
  DBObj.Aktie;

type
  Tfrm_KurseLaden = class(TForm)
    Panel1: TPanel;
    pg: TProgressBar;
    lbl_Progress: TLabel;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
  private
    fdoAktienImport: Boolean;
    fdoKurseImport: Boolean;
  public
    procedure AktienImportieren;
    procedure KurseImportieren;
    procedure NewRow(Sender: TObject; aAktie: TAktie; aValue: string; aIndex, aMaxValue: Integer);
    procedure Start(Sender: TObject; aMaxValue: Integer);
    property doAktienImport: Boolean read fdoAktienImport write fdoAktienImport;
    property doKurseImport: Boolean read fdoKurseImport write fDoKurseImport;
  end;

var
  frm_KurseLaden: Tfrm_KurseLaden;

implementation

{$R *.dfm}

uses
  Datamodul.TSI, Objekt.Aktienimport, Objekt.Kursimport;


procedure Tfrm_KurseLaden.FormCreate(Sender: TObject);
begin
  fdoAktienImport := false;
  lbl_Progress.Caption := '';
end;

procedure Tfrm_KurseLaden.FormDestroy(Sender: TObject);
begin //

end;



procedure Tfrm_KurseLaden.NewRow(Sender: TObject; aAktie: TAktie;
  aValue: string; aIndex, aMaxValue: Integer);
begin
  pg.Max := aMaxValue;
  if aValue > '' then
    lbl_Progress.Caption := '[' + aAktie.WKN + '] ' + aAktie.Aktie + ' /  ' + aValue
  else
    lbl_Progress.Caption := '[' + aAktie.WKN + '] ' + aAktie.Aktie;
  pg.Position := aIndex;
  Application.ProcessMessages;
end;

procedure Tfrm_KurseLaden.Start(Sender: TObject; aMaxValue: Integer);
begin
  pg.Max := aMaxValue;
end;

procedure Tfrm_KurseLaden.TimerTimer(Sender: TObject);
begin
  Timer.Enabled := false;
  if doAktienImport then
    AktienImportieren;
  if doKurseImport then
    KurseImportieren;
end;

procedure Tfrm_KurseLaden.AktienImportieren;
var
  Import: TAktienimport;
begin
  pg.Position := 0;
  Import := TAktienimport.Create(nil);
  try
    Import.OnNewRow := NewRow;
    Import.OnStart  := Start;
    Import.Trans := dm.IBT;
    if not Import.Exec then
      ShowMessage('Übertragung ist fehlgeschlagen')
    else
      ShowMessage('Fertig!');
    close;
  finally
    FreeAndNil(Import);
  end;
end;

procedure Tfrm_KurseLaden.KurseImportieren;
var
  Import: TKursimport;
begin
  pg.Position := 0;
  Import := TKursimport.Create(nil);
  try
    Import.OnNewRow := NewRow;
    Import.OnStart  := Start;
    Import.Trans := dm.IBT;
    if not Import.Exec then
      ShowMessage('Übertragung ist fehlgeschlagen')
    else
      ShowMessage('Fertig!');
    close;
  finally
    FreeAndNil(Import);
  end;
end;



end.
