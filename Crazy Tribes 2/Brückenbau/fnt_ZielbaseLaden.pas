unit fnt_ZielbaseLaden;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Spin, StdCtrls, tbButton, ExtCtrls, o_Koordinate;

type
  Tfrm_ZielbaseLaden = class(TForm)
    Label1: TLabel;
    edt_Basename: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edt_Y: TSpinEdit;
    edt_X: TSpinEdit;
    pnl_Bottom: TPanel;
    btn_Ok: TTBButton;
    btn_Cancel: TTBButton;
    FileOpenDialog: TFileOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btn_OkClick(Sender: TObject);
  private
    FCancel: Boolean;
    FPath: string;
    FBaseList: TStringList;
    FKoordinate: TKoordinate;
    FEntfernungsdatei: string;
    procedure EntfernungenLaden;
    function EntfernungDatei(aX, aY: Integer): string;
    function DateiOeffnen: string;
  public
    property Path: string read FPath write FPath;
    property Entfernungsdatei: string read FEntfernungsdatei;
  end;

var
  frm_ZielbaseLaden: Tfrm_ZielbaseLaden;

implementation

{$R *.dfm}

uses
  u_System;


procedure Tfrm_ZielbaseLaden.FormCreate(Sender: TObject);
begin
  FCancel := true;
  edt_Basename.Text := '';;
  edt_X.Value       := 0;
  edt_Y.Value       := 0;
  FBaseList := TStringList.Create;
  FKoordinate := TKoordinate.Create;
  FEntfernungsdatei := '';
end;

procedure Tfrm_ZielbaseLaden.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FBaseList);
  FreeAndNil(FKoordinate);
end;


procedure Tfrm_ZielbaseLaden.btn_OkClick(Sender: TObject);
begin
  if (edt_X.Value > 0) and (edt_Y.Value > 0) then
  begin
    FEntfernungsdatei := EntfernungDatei(edt_X.Value, edt_Y.Value);
    if FEntfernungsdatei > '' then
    begin
      close;
      exit;
    end;
    FKoordinate.X := edt_X.Value;
    FKoordinate.Y := edt_Y.Value;
    FEntfernungsdatei := FPath + FKoordinate.AsString + '-' + edt_Basename.Text + '.txt';
    close;
    exit;
  end;
  FEntfernungsdatei := DateiOeffnen;
  close;
end;

function Tfrm_ZielbaseLaden.DateiOeffnen: string;
begin
  Result := '';
  FileOpenDialog.DefaultFolder := FPath;
  if FileOpenDialog.Execute then
  begin
    Result := FileOpenDialog.FileName;
  end;
end;

function Tfrm_ZielbaseLaden.EntfernungDatei(aX, aY: Integer): string;
var
  i1: Integer;
  Koord: string;
  iPos: Integer;
begin
  Result := '';
  FKoordinate.X := aX;
  FKoordinate.Y := aY;
  EntfernungenLaden;
  for i1 := 0 to FBaseList.Count - 1 do
  begin
    Koord := FBaseList.Strings[i1];
    iPos := Pos('-', Koord);
    if iPos <= 0 then
      continue;
    Koord := copy(Koord, i1, iPos-1);
    if Koord = FKoordinate.AsString then
    begin
      Result := FPath + FBaseList.Strings[i1];
      exit;
    end;
  end;
end;

procedure Tfrm_ZielbaseLaden.EntfernungenLaden;
begin
  FBaseList.Clear;
  GetAllFiles(FPath, FBaseList, false, false, '*.txt');
end;



end.
