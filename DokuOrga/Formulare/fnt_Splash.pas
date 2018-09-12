unit fnt_Splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, o_SysObj, StdCtrls, ComCtrls, AppEvnts, ExtCtrls, Gauges, o_DBReorg,
  o_DataTrans;

type
  Tfrm_Splash = class(TForm)
    Label1: TLabel;
    lblInfo: TLabel;
    Timer1: TTimer;
    gg: TGauge;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FReorg: TDBReorg;
    FDataTrans: TDataTrans;
  public
  end;

var
  frm_Splash: Tfrm_Splash;

implementation

{$R *.dfm}


procedure Tfrm_Splash.FormCreate(Sender: TObject);
begin
  gg.MaxValue := 4;
  FReorg := TDBReorg.Create(Self);
  FDataTrans := TDataTrans.Create(Self);
end;

procedure Tfrm_Splash.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDataTrans);
  FreeAndNil(FReorg);
end;


procedure Tfrm_Splash.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  lblInfo.Caption := 'Mit Datenbank verbinden';
  lblInfo.Update;
  gg.Progress := 1;
  Application.ProcessMessages;
  sleep(100);

  gg.Progress := 2;
  Application.ProcessMessages;
  sleep(100);
  SysObj.Connect;
  if not SysObj.Connected then
  begin
    Application.Terminate;
  end;
  gg.Progress := 3;
  Application.ProcessMessages;

  lblInfo.Caption := 'Datenbankstruktur überprüfen';
  lblInfo.Update;

  FReorg.Database := SysObj.Database;
  //FReorg.Filename := 'c:\Bachmann\DB\Export\dokuorga.dbu';
  FReorg.Filename := SysObj.getReorgFilename;
  FReorg.DoImport;

  gg.Progress := 4;
  Application.ProcessMessages;
  lblInfo.Caption := 'Sprachdatei einlesen';
  lblInfo.Update;

  FDataTrans.ExportPath := SysObj.RuntimePfad;
  FDataTrans.Zipname    := 'syssprache.zip';
  FDataTrans.Unzip;
  FDataTrans.Import_SysSprache;

  close;
end;




end.
