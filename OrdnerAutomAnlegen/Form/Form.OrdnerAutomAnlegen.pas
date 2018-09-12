unit Form.OrdnerAutomAnlegen;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, AdvEdit, AdvEdBtn,
  AdvDirectoryEdit, Vcl.ExtCtrls, Objekt.Global;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    edt_Pfad: TAdvDirectoryEdit;
    Label1: TLabel;
    Label2: TLabel;
    edt_Endung: TEdit;
    btn_Execute: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btn_ExecuteClick(Sender: TObject);
  private
    procedure Exec;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
  Global := TGlobal.Create;
  edt_Pfad.Text := Global.Ini.Pfad;
  edt_Endung.Text := Global.Ini.Endung;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Global);
end;

procedure TForm1.btn_ExecuteClick(Sender: TObject);
begin
  exec;
end;

procedure TForm1.Exec;
var
  i1: Integer;
  List: TStringList;
  Pfad: string;
  Filename: string;
  Ordner: string;
  Endung: string;
  iPos: Integer;
begin
  Screen.Cursor := crHourglass;
  List := TStringList.Create;
  try
    Endung := edt_Endung.Text;
    if Endung = '' then
      exit;
    if Endung[1] = '*' then
      Endung := copy(Endung, 2, Length(Endung));
    if Endung[1] = '.' then
      Endung := copy(Endung, 2, Length(Endung));
    Global.System.GetAllFiles(edt_Pfad.Text, List, true, true, '*.' + Endung);
    //Pfad := IncludeTrailingPathDelimiter(edt_Pfad.Text);
    for i1 := 0 to List.Count -1 do
    begin
      Pfad := IncludeTrailingPathDelimiter(ExtractFilePath(List.Strings[i1]));
      Filename := ExtractFileName(List.Strings[i1]);
      iPos := LastDelimiter('.', Filename);
      if iPos > 0 then
        Ordner := copy(Filename, 1, iPos-1);
      Ordner := Pfad + Ordner;
      ForceDirectories(Ordner);
      Filename := IncludeTrailingPathDelimiter(Ordner) + ExtractFileName(List.Strings[i1]);
      MoveFile(PWideChar(List.Strings[i1]), PWideChar(Filename));
    end;
  finally
    FreeAndNil(List);
  end;
  Screen.Cursor := crDefault;
  ShowMessage('Fertig');
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Global.Ini.Pfad := edt_Pfad.Text;
  Global.Ini.Endung := edt_Endung.Text;
end;


end.
