unit Datamodul.TSI;

interface

uses
  System.SysUtils, System.Classes, IBX.IBDatabase, Data.DB;

type
  Tdm = class(TDataModule)
    Database: TIBDatabase;
    IBT: TIBTransaction;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
  public
    function Connect: Boolean;
  end;

var
  dm: Tdm;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  System.UITypes, Objekt.Global, Vcl.Dialogs;



procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  if Global = nil then
  begin
    Global := TGlobal.Create(nil);
    Global.Trans := IBT;
  end;
  if Global.DatenbankServer > '' then
    Database.DatabaseName := Global.DatenbankServer + ':' +  Global.DatenbankFilename
  else
    Database.DatabaseName := Global.DatenbankFilename;
  //Database.DatabaseName := 'c:\temp\Datenbank\Passwortbrief.FDB';
  Database.Params.Clear;
  Database.Params.Add('user_name=sysdba');
  Database.Params.Add('password=masterkey');
  Database.LoginPrompt := false;
end;

procedure Tdm.DataModuleDestroy(Sender: TObject);
begin //

end;

function Tdm.Connect: Boolean;
var
  lst: TStringList;
  Filename: string;
begin
  try
    Database.Connected := true;
  except
    on E: Exception do
    begin
      lst := TStringList.Create;
      try
        lst.Add('Databasename = ' + Database.DatabaseName);
        lst.Add(E.Message);
        Filename := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'Error.txt';
        lst.SaveToFile(Filename);
      finally
        FreeAndNil(lst);
      end;
      MessageDlg(E.Message, mtError, [mbOk], 0);
      Result := false;
      exit;
    end;
  end;
  Result := true;
end;


end.
