program DeleteExe;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils, System.Classes;

procedure LoescheDateien;
var
  List: TStringList;
  Path: string;
  Filename: string;
  i1: Integer;
  s: string;
begin
  List := TStringList.Create;
  try
    Path := ExtractFilePath(ParamStr(0));
    Filename := Path + 'DeleteList.txt';
    if not FileExists(Filename) then
      exit;
    List.LoadFromFile(Filename);
    for i1 := 0 to List.Count -1 do
    begin
      s := List.Strings[i1];
      DeleteFile(s);
    end;
  finally
    FreeAndNil(List);
  end;
end;

begin
  try
    LoescheDateien;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;



end.
