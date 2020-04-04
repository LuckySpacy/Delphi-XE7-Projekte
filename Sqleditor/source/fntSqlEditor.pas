unit fntSqlEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.ActnList, Vcl.Buttons, Datamodul, fntSqlEdit, fntGrid, Vcl.dbGrids, Vcl.Grids,
  c_types, System.Actions;

type
  TfrmSqlEditor = class(TForm)
    pnl_Top: TPanel;
    cmd_Connect: TSpeedButton;
    cmd_Execute: TSpeedButton;
    cmd_Export: TSpeedButton;
    ActionList: TActionList;
    act_ExecSql: TAction;
    act_Export: TAction;
    SaveDialog: TSaveDialog;
    FileSaveDialog: TFileSaveDialog;
    pnl_Memo: TPanel;
    Splitter1: TSplitter;
    pnl_Grid: TPanel;
    StatusBar: TStatusBar;
    act_DatabaseInfo: TAction;
    cmd_FieldsInfo: TSpeedButton;
    cmd_DatabaseInfo: TSpeedButton;
    act_FieldsInfo: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmd_ConnectClick(Sender: TObject);
    procedure act_ExecSqlExecute(Sender: TObject);
    procedure act_ExportExecute(Sender: TObject);
    procedure act_DatabaseInfoExecute(Sender: TObject);
    procedure act_FieldsInfoExecute(Sender: TObject);
  private
    FPath: string;
    FIniFile: string;
    //FEditor: TfrmSqlMemo;
    FEditor: TfrmSqlEdit;
    FGrid  : TfrmGrid;
    FNetDir    : string;
    FPrivateDir: string;
    FDataDir   : string;
    FLastSql     : string;
    FSortAsc     : Boolean;
    FFormLoading : Boolean;
    FSelectedTableName: string;
    procedure LoadIni;
    function DoConnectIB: Boolean;
    function DoConnectAdo: Boolean;
    function DoConnectMySql: Boolean;
    procedure OnConnectIB(Sender: TObject);
    procedure OnConnectAdo(Sender: TObject; aDatenbankname, aSectionname: string);
    procedure OnConnectMySql(Sender: TObject; aDatenbankname, aSectionname: string);
    //function GetSqlFileName(aDatabaseName: string): string;
    function GetFieldsSqlText(aTabelle: string): string;
    function GetFieldKey(aTablename, aFieldname: string; var aLength: Integer): Integer;
    function GetTablesSqlText: string;
    procedure setTablesforHighlighter;
    procedure EditorF1(Sender: TObject; aTableName: string);
    procedure EditorF2(Sender: TObject);
    procedure GridHeaderClick(Column: TColumn);
    procedure GridCellDblClick(Sender: TObject; aFieldname, aValue: string);
    procedure SplittSqlStatement(aSqlText: string; var aSelect, aRest: string);
    function GetNewSqlText: string;
    procedure LoadFieldList(aSelectStatement: string; aFieldList: TStrings);
    procedure SqlExecute(aSqlText: string);
    function ShowDataChange(aTablename, aFieldname, aKeyFieldName, aValue: string; aDataType, aKeyValue, aFieldLength: Integer): Boolean;
    procedure TableNameSelected(Sender: TObject; aTableName: string);
    procedure TableNameNotSelected(Sender: TObject);
    procedure BevorConnect(Sender: TObject);
    procedure NewSqlTextLoaded(Sender: TObject);
  public
  end;

var
  frmSqlEditor: TfrmSqlEditor;

implementation

{$R *.dfm}

uses
  nf_System, nf_RegIni, fntConnectIB, Dateutils, fntDataChange,
  o_dbini, o_dbiniobj, System.UITypes;


procedure TfrmSqlEditor.FormCreate(Sender: TObject);
begin
  FNetDir      := '';
  FPrivateDir  := '';
  FDataDir     := '';
  FLastSql := '';
  FFormLoading := true;
  FSortAsc := false;
  cmd_Execute.Caption := '';
  cmd_Export.Caption := '';
  cmd_DatabaseInfo.Caption := '';
  cmd_FieldsInfo.Caption := '';
  cmd_FieldsInfo.Enabled := false;
  FPath    := IncludeTrailingBackslash(nf_GetShellFolder(26)) + 'SqlEditor\';
  FIniFile := FPath + 'SqlEditor.ini';
  if not DirectoryExists(FPath) then
    ForceDirectories(FPath);

  FEditor := TfrmSqlEdit.Create(Self);
  FEditor.Parent := pnl_Memo;
  FEditor.Align  := alClient;
  FEditor.Show;
  FEditor.OnF1 := EditorF1;
  FEditor.OnF2 := EditorF2;
  FEditor.OnTableNameSelected := TableNameSelected;
  FEditor.OnTableNameNotSelected := TableNameNotSelected;
  FEditor.OnNewSqlTextLoaded := NewSqlTextLoaded;

  FGrid := TfrmGrid.Create(Self);
  FGrid.Parent := pnl_Grid;
  FGrid.Align  := alClient;
  FGrid.OnHeaderClick := GridHeaderClick;
  FGrid.OnDblClickCell := GridCellDblClick;
  FGrid.Show;


  //FGrid.dbGrid.DataSource := DM.ds_PD;
  DM.DBIni.Load;
  DM.OnConnectIB := OnConnectIB;
  DM.OnConnectAdo := OnConnectAdo;
  DM.OnConnectMySql := OnConnectMySql;
  DM.OnBevorConnect := BevorConnect;
end;

procedure TfrmSqlEditor.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FEditor);
  FreeAndNil(FGrid);
end;

procedure TfrmSqlEditor.FormShow(Sender: TObject);
begin
  pnl_Memo.Height := nf_ReadIniToInt(FIniFile, 'SqlMemo', 'Height', '244');
  Height := nf_ReadIniToInt(FIniFile, 'SqlEditor', 'Height', '445');
  Width  := nf_ReadIniToInt(FIniFile, 'SqlEditor', 'Width', '630');
  LoadIni;
  if dm.DBIni.CurDBIni = nil then
    exit;

  if dm.DBIni.CurDBIni.Datenbank = cFirebird then
    DoConnectIB;
  if dm.DBIni.CurDBIni.Datenbank = cMsSql then
    DoConnectAdo;
  if dm.DBIni.CurDBIni.Datenbank = cMySql then
    DoConnectMySql;
  FFormLoading := false;
end;


procedure TfrmSqlEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  nf_WriteIni(FIniFile, 'SqlMemo', 'Height', IntToStr(pnl_Memo.Height));
  nf_WriteIni(FIniFile, 'SqlEditor', 'Height', IntToStr(Height));
  nf_WriteIni(FIniFile, 'SqlEditor', 'Width', IntToStr(Width));
  if dm.DBIni.CurDBIni <> nil then
    FEditor.SaveSqlText(FPath + dm.DBIni.CurSectionName + '.Sql');
end;

procedure TfrmSqlEditor.LoadIni;
var
 // iLaufwerk: Integer;
  LastTableName: string;
  Sectionname: string;
//  Datenbank: string;
begin

  Sectionname := 'DatabaseIB';

  FPrivateDir := nf_ReadIni(FIniFile, 'Database', 'PrivateDir', '');
  FNetDir     := nf_ReadIni(FIniFile, 'Database', 'NetDir', '');
  FDataDir    := nf_ReadIni(FIniFile, 'Database', 'DatabasePath', '');

  {
  FIBServer    := nf_ReadIni(FIniFile, 'DatabaseIB', 'Server', '');
  iLaufwerk    := nf_ReadIniToInt(FIniFile, 'DatabaseIB', 'Laufwerk', '-1') + 65;
  FIBPath      := nf_ReadIni(FIniFile, 'DatabaseIB', 'Verzeichnis', '');
  FIBDatenbank := nf_ReadIni(FIniFile, 'DatabaseIB', 'Datenbankname', '');
  Datenbank    := '0';
  LastTableName := nf_ReadIni(FIniFile, 'LastConnection', 'Tablename', '');


  if LastTableName > '' then
  begin
    Sectionname := LastTableName;
    FIBServer    := nf_ReadIni(FIniFile, LastTableName, 'Server', '');
    iLaufwerk    := nf_ReadIniToInt(FIniFile, LastTableName, 'Laufwerk', '-1') + 65;
    FIBPath      := nf_ReadIni(FIniFile, LastTableName, 'Verzeichnis', '');
    FIBDatenbank := nf_ReadIni(FIniFile, LastTableName, 'Datenbankname', '');
    Datenbank    := nf_ReadIni(FIniFile, LastTableName, 'Datenbank', '0');
  end;
  }

  LastTableName := nf_ReadIni(FIniFile, 'LastConnection', 'Tablename', '');
  if LastTableName > '' then
    Sectionname := LastTableName;


  dm.DBIni.CurSectionName := Sectionname;

  setTablesforHighlighter;


  //if iLaufwerk >= 65 then
  //  FIBLaufwerk := chr(iLaufwerk) + ':';
end;


procedure TfrmSqlEditor.NewSqlTextLoaded(Sender: TObject);
begin
  setTablesforHighlighter;
end;

procedure TfrmSqlEditor.OnConnectAdo(Sender: TObject; aDatenbankname, aSectionname: string);
begin
  if not dm.ADOConnect.Connected then
    exit;

  if dm.DBIni.CurDBIni <> nil then
  begin
    FEditor.LoadSqlText(FPath + dm.DBIni.CurSectionName + '.Sql');
    Caption := 'SQL-Editor (Datenbank: MsSql / Datenbankname: ' + dm.DBIni.CurDBIni.Datenbankname + ')';
  end;

  FGrid.dbGrid.DataSource := DM.ds_Ado;
  cmd_DatabaseInfo.Enabled := false;
end;

procedure TfrmSqlEditor.OnConnectIB(Sender: TObject);
begin
  if dm.IBDatabase.Connected then
  begin
    if dm.DBIni.CurDBIni <> nil then
    begin
      FEditor.LoadSqlText(FPath + dm.DBIni.CurSectionName + '.Sql');
      Caption := 'SQL-Editor (Datenbank: Firebird / Datenbankname: ' + dm.DBIni.CurDBIni.Datenbankname + ')';
    end;
    setTablesforHighlighter;
    cmd_DatabaseInfo.Enabled := true;
    FGrid.dbGrid.DataSource := DM.ds_IB;
  end;
end;

procedure TfrmSqlEditor.OnConnectMySql(Sender: TObject; aDatenbankname,
  aSectionname: string);
begin
  if not dm.MySqlConnect.Connected then
    exit;
  cmd_DatabaseInfo.Enabled := false;

  if dm.DBIni.CurDBIni <> nil then
  begin
    FEditor.LoadSqlText(FPath + dm.DBIni.CurSectionName + '.Sql');
    Caption := 'SQL-Editor (Datenbank: MySql / Datenbankname: ' + dm.DBIni.CurDBIni.Datenbankname + ')';
  end;
  FGrid.dbGrid.DataSource := DM.ds_MySql;
end;

procedure TfrmSqlEditor.BevorConnect(Sender: TObject);
begin
  if FFormLoading then
    exit;
  if dm.DBIni.CurDBIni = nil then
    exit;
  FEditor.SaveSqlText(FPath + dm.DBIni.CurSectionName + '.sql');
end;


procedure TfrmSqlEditor.setTablesforHighlighter;
var
  TableList: TStringList;
begin

  if dm.Datenbank = cFirebird then
  begin
    if not dm.IBDatabase.Connected then
      exit;
    //if not dm.ConnectIB then
    //  exit;
  end;
  TableList := TStringList.Create;
  try
    if dm.Datenbank = cMsSql then
      FEditor.AddTableNamesToHighlighter(TableList);
    if dm.Datenbank = cMySql then
      FEditor.AddTableNamesToHighlighter(TableList);
    if dm.Datenbank = cFirebird then
    begin
      dm.IBQuery2.Close;
      dm.IBQuery2.SQL.Text := GetTablesSqlText;
      dm.IBQuery2.Open;
      FEditor.SynSQLSyn.TableNames.Clear;
      while not dm.IBQuery2.Eof do
      begin
        TableList.Add(Trim(dm.IBQuery2.Fields[0].asString));
        dm.IBQuery2.Next;
      end;
      FEditor.AddTableNamesToHighlighter(TableList);
    end;
  finally
    FreeAndNil(TableList);
  end;

end;


{
function TfrmSqlEditor.GetSqlFileName(aDatabaseName: string): string;
var
  iPos: Integer;
begin
  Result := aDatabaseName;
  iPos  := LastDelimiter('.', aDatabasename);
  if iPos > 0 then
    Result := copy(aDatabaseName, 1, iPos-1);
end;
}


procedure TfrmSqlEditor.cmd_ConnectClick(Sender: TObject);
var
  Datenbank: string;
begin
  Datenbank := '';
  if not fntConnectIB.TfrmConnectIB.ShowConnect(Self) then
  begin
    if dm.Datenbank = cFirebird then
    begin
      if not DM.IBDatabase.Connected then
        DM.IBDatabase.Connected := true;
    end;
    if dm.Datenbank = cMsSql then
    begin
      if not dm.ADOConnect.Connected then
        dm.ADOConnect.Connected := true;
    end;
    if dm.Datenbank = cMySql then
    begin
      if not dm.MySqlConnect.Connected then
        dm.MySqlConnect.Connected := true;
    end;
    exit;
  end;
  //LoadIni;
  if dm.DBIni.CurDBIni <> nil then
  begin
    if dm.DBIni.CurDBIni.Datenbank = cFirebird then
      Datenbank := 'Firebird';
    if dm.DBIni.CurDBIni.Datenbank = cMsSql then
      Datenbank := 'MS SQL';
    if dm.DBIni.CurDBIni.Datenbank = cMySql then
      Datenbank := 'MY SQL';

    Caption := 'SQL-Editor (Datenbank: ' + Datenbank + ' / Datenbankname: ' + dm.DBIni.CurDBIni.Datenbankname + ')';
    FEditor.LoadSqlText(FPath + dm.DBIni.CurSectionName + '.Sql');
  end;
end;

function TfrmSqlEditor.DoConnectAdo: Boolean;
begin
  Result := false;
  //LoadIni;
  if  (dm.Datenbank = cMsSql) then
  begin
    if dm.IBDatabase.Connected then
      dm.IBDatabase.Connected := false;
    if dm.ADOConnect.Connected then
      dm.ADOConnect.Connected := false;
    if dm.MySqlConnect.Connected then
      dm.MySqlConnect.Connected := false;
    Result := dm.ConnectAdo;
  end;
end;

function TfrmSqlEditor.DoConnectMySql: Boolean;
begin
  Result := false;
  LoadIni;
  if  (dm.Datenbank = cMySql) then
  begin
    if dm.IBDatabase.Connected then
      dm.IBDatabase.Connected := false;
    if dm.ADOConnect.Connected then
      dm.ADOConnect.Connected := false;
    if dm.MySqlConnect.Connected then
      dm.MySqlConnect.Connected := false;
    Result := dm.ConnectMySql;
  end;
end;


function TfrmSqlEditor.DoConnectIB: Boolean;
var
  DBIniObj: TDBIniObj;
begin
  Result := false;
  //LoadIni;
  if dm.DBIni.CurDBIni = nil then
    exit;

  DBIniObj := dm.DBIni.CurDBIni;

  if DBIniObj.Datenbank <> cFirebird then
    exit;

  if (Trim(DBIniObj.Server) = '')
  or (Trim(DBIniObj.Laufwerk) = '')
  or (Trim(DBIniObj.Verzeichnis) = '')
  or (Trim(DBIniObj.Datenbankname) = '') then
    exit;

  DM.IBDatabase.DatabaseName := DBIniObj.Server + ':' + DBIniObj.Laufwerk + '\' + DBIniObj.Verzeichnis + '\' + DBIniObj.Datenbankname;

  Result := dm.ConnectIB;

  {
  if  (FDatenbank = cFirebird)
  and (FIBServer > '')
  and (FIBLaufwerk > '')
  and (FIBPath > '')
  and (FIBDatenbank > '') then
  begin
    if dm.ADOConnect.Connected then
      dm.ADOConnect.Connected := false;
    if dm.IBDatabase.Connected then
      dm.IBDatabase.Connected := false;
    if dm.MySqlConnect.Connected then
      dm.MySqlConnect.Connected := false;

    DM.IBDatabase.DatabaseName := FIBServer + ':' + FIBLaufwerk + '\' + FIBPath + '\' + FIBDatenbank;

    Result := dm.ConnectIB;
  end;
  }

end;


procedure TfrmSqlEditor.EditorF1(Sender: TObject; aTableName: string);
var
  SqlText: string;
begin
  SqlText := GetFieldsSqlText(aTableName);
  if dm.Datenbank = cFirebird then
  begin
    dm.IBQuery.Transaction := dm.IBTransaction;
    dm.IBQuery.Close;
    dm.IBQuery.SQL.Text := SqlText;
    dm.IBQuery.Open;
    dm.IBQuery.FetchAll;
    FGrid.NewData := true;
  end;
end;


procedure TfrmSqlEditor.EditorF2(Sender: TObject);
var
  SqlText: string;
begin
  SqlText := GetTablesSqlText;
  if dm.Datenbank = cFirebird then
  begin
    dm.IBQuery.Transaction := dm.IBTransaction;
    dm.IBQuery.Close;
    dm.IBQuery.SQL.Text := SqlText;
    dm.IBQuery.Open;
    dm.IBQuery.FetchAll;
    FGrid.NewData := true;
  end;
end;

procedure TfrmSqlEditor.act_DatabaseInfoExecute(Sender: TObject);
begin
  SqlExecute('gettables');
end;

procedure TfrmSqlEditor.act_ExecSqlExecute(Sender: TObject);
begin
  SqlExecute(FEditor.GetSqlText);
end;


procedure TfrmSqlEditor.SqlExecute(aSqlText: string);
var
  StartTime: TTime;
  EndTime  : TTime;
begin
  FLastSql := aSqlText;

  StartTime := now;
  Screen.Cursor := crHourGlass;
  try
    FGrid.dbGrid.DataSource.DataSet.DisableControls;
    if dm.Datenbank = cFirebird then
    begin
      if dm.IBDatabase.Connected then
      begin
        if dm.IBTransaction.InTransaction then
          dm.IBTransaction.Commit;
        if Pos('getfields', lowercase(aSqlText)) > 0 then
        begin
          aSqlText := Trim(StringReplace(aSqlText, 'getfields', '', [rfReplaceAll, rfIgnoreCase]));
          aSqlText := GetFieldsSqlText(aSqlText);
          dm.IBQuery.Transaction := dm.IBTransaction;
          dm.IBQuery.Close;
          dm.IBQuery.SQL.Text := aSqlText;
          dm.IBQuery.Open;
          dm.IBQuery.FetchAll;
          FGrid.NewData := true;
          exit;
        end;
        if Pos('gettables', lowercase(aSqlText)) > 0 then
        begin
          aSqlText := GetTablesSqlText;
          dm.IBQuery.Transaction := dm.IBTransaction;
          dm.IBQuery.Close;
          dm.IBQuery.SQL.Text := aSqlText;
          dm.IBQuery.Open;
          dm.IBQuery.FetchAll;
          FGrid.NewData := true;
          exit;
        end;
        if Pos('select', lowercase(aSqlText)) > 0 then
        begin
          dm.IBQuery.Transaction := dm.IBTransaction;
          dm.IBQuery.Close;
          dm.IBQuery.SQL.Text := GetNewSqlText;
          dm.IBQuery.Open;
          dm.IBQuery.FetchAll;
          EndTime := now - StartTime;
          StatusBar.Panels[0].Text := 'Anzahl der Datensätze: ' + IntToStr(dm.IBQuery.RecordCount) + ' / Zeit: ' +  FormatDateTime('hh:nn:ss:zzzz', EndTime);
          FGrid.NewData := true;
        end
        else
        begin
          dm.IBQuery.Transaction := dm.IBTransaction;
          dm.IBQuery.Close;
          dm.IBQuery.SQL.Text := aSqlText;
          dm.IBQuery.ExecSQL;
          dm.IBTransaction.Commit;
          //StatusBar.Panels[0].Text := 'Anzahl der Datensätze: ' + IntToStr(dm.IBQuery.RecordCount);
        end;
      end;
    end;

    if dm.Datenbank = cMsSql then
    begin
      if not dm.ADOConnect.Connected then
        exit;
      if Pos('getfields', lowercase(aSqlText)) > 0 then
        exit;
      if Pos('gettables', lowercase(aSqlText)) > 0 then
        exit;

      if Pos('select', lowercase(aSqlText)) > 0 then
      begin
        dm.ADOQuery.Close;
        dm.ADOQuery.SQL.Text := GetNewSqlText;
        dm.ADOQuery.Open;
        //dm.IBQuery.FetchAll;
       // EndTime := now - StartTime;
        //StatusBar.Panels[0].Text := 'Anzahl der Datensätze: ' + IntToStr(dm.IBQuery.RecordCount) + ' / Zeit: ' +  FormatDateTime('hh:nn:ss:zzzz', EndTime);
        FGrid.NewData := true;
      end
      else
      begin
      end;
    end;


    if dm.Datenbank = cMySql then
    begin
      if not dm.MySqlConnect.Connected then
        exit;
      if Pos('getfields', lowercase(aSqlText)) > 0 then
        exit;
      if Pos('gettables', lowercase(aSqlText)) > 0 then
        exit;
      if Pos('select', lowercase(aSqlText)) > 0 then
      begin
        dm.mySQLQuery.Close;
        dm.mySQLQuery.SQL.Text := GetNewSqlText;
        dm.mySQLQuery.Open;
        //dm.IBQuery.FetchAll;
        //EndTime := now - StartTime;
        //StatusBar.Panels[0].Text := 'Anzahl der Datensätze: ' + IntToStr(dm.IBQuery.RecordCount) + ' / Zeit: ' +  FormatDateTime('hh:nn:ss:zzzz', EndTime);
        FGrid.NewData := true;
      end
      else
      begin
        dm.mySQLQuery.Close;
        dm.mySQLQuery.SQL.Text := GetNewSqlText;
        dm.mySQLQuery.ExecSql;
      end;
    end;


  finally
    FGrid.dbGrid.DataSource.DataSet.EnableControls;
    Screen.Cursor := crDefault;
  end;
end;



procedure TfrmSqlEditor.TableNameNotSelected(Sender: TObject);
begin
  cmd_FieldsInfo.Enabled := false;
  FSelectedTablename := '';
end;

procedure TfrmSqlEditor.TableNameSelected(Sender: TObject; aTableName: string);
begin
  cmd_FieldsInfo.Enabled := true;
  FSelectedTableName := aTablename;
end;

procedure TfrmSqlEditor.SplittSqlStatement(aSqlText: string; var aSelect, aRest: string);
var
  iPos: Integer;
begin
  aSelect := '';
  aRest   := '';
  iPos := Pos('from', aSqlText);
  if iPos > 0 then
  begin
    aSelect := copy(aSqlText, 1, iPos-1);
    aRest   := copy(aSqlText, iPos, Length(aSqlText));
  end;
end;

procedure TfrmSqlEditor.act_ExportExecute(Sender: TObject);
var
  FileName: string;
  Liste: TStringList;
  iCol: Integer;
  s: string;
begin
  if not FileSaveDialog.Execute then
    exit;
  Filename := FileSaveDialog.FileName;
  if Pos('.', Filename) <= 0 then
    Filename := Filename + FileSaveDialog.FileTypes.Items[FileSaveDialog.FileTypeIndex-1].FileMask;
  if FileExists(Filename) then
  begin
    if not MessageDlg('Möchten Sie wirklich die Datei überschreiben?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
      exit;
  end;
  FGrid.dbGrid.DataSource.DataSet.First;
  Liste := TStringList.Create;
  try
    s := '';
    for iCol := 0 to FGrid.dbGrid.FieldCount -1 do
    begin
      s := s + FGrid.dbGrid.Fields[iCol].FieldName + ';';
    end;
    Liste.Add(s);

    while not FGrid.dbGrid.DataSource.DataSet.Eof do
    begin
      s := '';
      for iCol := 0 to FGrid.dbGrid.FieldCount -1 do
      begin
        s := s + FGrid.dbGrid.Fields[iCol].AsString + ';';
      end;
      Liste.Add(s);
      FGrid.dbGrid.DataSource.DataSet.Next;
    end;
    Liste.SaveToFile(Filename);
  finally
    FreeAndNil(Liste);
  end;

end;

procedure TfrmSqlEditor.act_FieldsInfoExecute(Sender: TObject);
begin //
  EditorF1(Sender, FSelectedTableName);
end;


function TfrmSqlEditor.GetFieldsSqlText(aTabelle: string): string;
begin
  Result :=
'select t1.RDB$RELATION_NAME Tabelle, t2.rdb$field_name Feldname, ' +
    ' case t3.rdb$field_type' +
    '   when 7 then "smallint"' +
    '   when 8 then "integer"' +
    '   when 16 then "int64"' +
    '   when 9 then "quad"' +
    '   when 10 then "float"' +
    '   when 11 then "d_float"' +
    '   when 17 then "boolean"' +
    '   when 27 then "double"' +
    '   when 12 then "date"' +
    '   when 13 then "time"' +
    '   when 35 then "timestamp"' +
    '   when 261 then "blob"' +
    '   when 37 then "varchar"' +
    '   when 14 then "char"' +
    '   when 40 then "cstring"' +
    '   when 45 then "blob_id"' +
    ' end Typ, t3.rdb$field_length Laenge' +
    {
    ', case t3.rdb$field_type' +
    '    when 7 then' +
    '    case t3.rdb$field_sub_type' +
    '        when 1 then "numeric"' +
    '        when 2 then "decimal"' +
    '    end' +
    '    when 8 then' +
    '    case t3.rdb$field_sub_type' +
    '        when 1 then "numeric"' +
    '        when 2 then "decimal"' +
    '    end' +
    '    when 16 then' +
    '    case t3.rdb$field_sub_type' +
    '        when 1 then "numeric"' +
    '        when 2 then "decimal"' +
    '        else "bigint"' +
    '    end' +
    '    when 14 then' +
    '    case t3.rdb$field_sub_type' +
    '        when 0 then "unspecified"' +
    '        when 1 then "binary"' +
    '        when 3 then "acl"' +
    '        else' +
    '        case' +
    '            when t3.rdb$field_sub_type is null then "unspecified"' +
    '        end' +
    '    end' +
    '    when 37 then' +
    '    case t3.rdb$field_sub_type' +
    '        when 0 then "unspecified"' +
    '        when 1 then "text"' +
    '        when 3 then "acl"' +
    '        else' +
    '        case' +
    '            when t3.rdb$field_sub_type is null then "unspecified"' +
    '        end' +
    '    end' +
    '    when 261 then' +
    '    case t3.rdb$field_sub_type' +
    '        when 0 then "unspecified"' +
    '        when 1 then "text"' +
    '        when 2 then "blr"' +
    '        when 3 then "acl"' +
    '        when 4 then "reserved"' +
    '        when 5 then "encoded-meta-data"' +
    '        when 6 then "irregular-finished-multi-db-tx"' +
    '        when 7 then "transactional_description"' +
    '        when 8 then "external_file_description"' +
    '    end' +
    ' end Subtype,' +
    ' t3.rdb$character_set_id, t3.rdb$collation_id, t3.rdb$field_name, t3.rdb$field_type,' +
    ' t3.rdb$field_sub_type' +
     }
' from RDB$RELATIONS t1, rdb$relation_fields t2, rdb$fields t3' +
' where RDB$SYSTEM_FLAG=0' +
' and   t1.RDB$RELATION_NAME = t2.RDB$RELATION_NAME' +
' and   t2.RDB$FIELD_SOURCE = t3.RDB$FIELD_NAME' +
' and   t1.RDB$RELATION_NAME = "' + uppercase(aTabelle) + '"' +
' order by t1.RDB$RELATION_NAME, t2.rdb$field_name;';

end;

function TfrmSqlEditor.GetFieldKey(aTablename, aFieldname: string; var aLength: Integer): Integer;
begin
  Result := dm.getFieldKey(aTablename, aFieldname, aLength);
end;

function TfrmSqlEditor.GetTablesSqlText: string;
begin
  Result := 'select RDB$RELATION_NAME Tabelle from RDB$RELATIONS order by RDB$RELATION_NAME';
end;



procedure TfrmSqlEditor.LoadFieldList(aSelectStatement: string; aFieldList: TStrings);
var
  List: TStringList;
  i1: Integer;
  iPos: Integer;
begin
  List := TStringList.Create;
  try
    iPos := Pos('select', aSelectStatement);
    if iPos > 0 then
      Delete(aSelectStatement, iPos, iPos + 6);
    aFieldList.Clear;
    List.StrictDelimiter := true;
    List.Delimiter := ',';
    List.DelimitedText := aSelectStatement;
    for i1 := 0 to List.Count -1 do
      aFieldList.Add(Trim(List.Strings[i1]));
  finally
    FreeAndNil(List);
  end;

end;

function TfrmSqlEditor.GetNewSqlText: string;
var
  Select: string;
  Rest: string;
  TablenameList: TStringList;
  FieldList: TStringList;
  i1, i2: Integer;
  PrimaryKey: string;
  SqlFields: string;
  SqlOhneLeerzeichen: string;
  Fieldfound: Boolean;
begin
  Result := FEditor.GetSqlText;
  SqlOhneLeerzeichen := StringReplace(Result, ' ', '', [rfReplaceAll]);
  if Pos('groupby', SqlOhneLeerzeichen) > 0  then
    exit;
  SplittSqlStatement(FEditor.GetSqlText, Select, Rest);
  if Pos('select*', SqlOhneLeerzeichen) > 0  then
    exit;
  if Pos('sum(', SqlOhneLeerzeichen) > 0  then
    exit;
  if Pos('distinct', Select) > 0  then
    exit;
  SqlFields := '';
  FieldList := TStringList.Create;
  TablenameList := TStringList.Create;
  try
    LoadFieldList(Select, FieldList);
    FEditor.LoadTableListFromSqlText(TableNameList);
    if TablenameList.Count = 0 then
      exit;
    for i1 := 0 to TablenameList.Count -1 do
    begin
      PrimaryKey := dm.getPrimaryKeyFromTable(TablenameList.Strings[i1]);
      if PrimaryKey = '' then
        PrimaryKey := dm.getUniqueKeyFromTable(TablenameList.Strings[i1]);
      if PrimaryKey = '' then
        continue;
      Fieldfound := false;
      for i2 := 0 to FieldList.Count -1 do
      begin
        if SameText(FieldList.Strings[i2], PrimaryKey) then
        begin
          Fieldfound := true;
          break;
        end;
      end;
      if not Fieldfound then
        SqlFields := SqlFields + ', ' + PrimaryKey;
    end;
    Result := Select + SqlFields + ' ' + Rest;
  finally
    FreeAndNil(TablenameList);
    FreeAndNil(FieldList);
  end;
end;


procedure TfrmSqlEditor.GridCellDblClick(Sender: TObject; aFieldname, aValue: string);
var
  TableName: string;
  PrimaryKey: string;
  TablenameList: TStringList;
  DataType: Integer;
  FieldLength: Integer;
  KeyValue: Integer;
  FieldCol: Integer;
  i1: Integer;
begin
  if dm.DBIni.CurDBIni <> nil then
  begin
    if (dm.DBIni.CurDBIni.Datenbank = cMsSql)
    or (dm.DBIni.CurDBIni.Datenbank = cMySql) then
      exit;
  end;
  if Pos('select', lowercase(FLastSql)) <= 0 then
  begin
    ShowMessage('Nicht Editierbar');
    exit;
  end;
  FieldCol := 1;
  for i1 := 0 to FGrid.dbGrid.Columns.Count -1 do
  begin
    if SameText(aFieldname, FGrid.dbGrid.Columns[i1].Field.FieldName) then
    begin
      FieldCol := i1 + 1;
      break;
    end;
  end;
  TablenameList := TStringList.Create;
  try
    TableName := dm.getTableNameFromField(aFieldname);
    if Tablename = '' then
    begin
      ShowMessage('Nicht Editierbar');
      exit;
    end;
    PrimaryKey := dm.getPrimaryKeyFromTable(TableName);
    if PrimaryKey = '' then
      PrimaryKey := dm.getUniqueKeyFromTable(TableName);
    if PrimaryKey = '' then
    begin
      ShowMessage('Nicht Editierbar');
      exit;
    end;

    if FGrid.dbGrid.DataSource.DataSet.FieldByName(PrimaryKey) = nil then
    begin
      ShowMessage('Nicht Editierbar');
      exit;
    end;

    if SameText(PrimaryKey, aFieldname) then
    begin
      ShowMessage('Nicht Editierbar');
      exit;
    end;


    KeyValue := FGrid.dbGrid.DataSource.DataSet.FieldByName(PrimaryKey).AsInteger;

    //ShowMessage(PrimaryKey + '=' + IntToStr(KeyValue) + ' / ' + aValue);
    FEditor.LoadTableListFromSqlText(TableNameList);
    //ShowMessage(TableNameList.Text);

    DataType := getFieldKey(Tablename, aFieldname, FieldLength);
    //if DataType = 8 then
    //  ShowMessage('Integer / Länge = ' + IntToStr(FieldLength));


    if ShowDataChange(Tablename, aFieldname, PrimaryKey, aValue, DataType, KeyValue, FieldLength) then
    begin
      SqlExecute(FLastSql);
      FGrid.dbGrid.DataSource.DataSet.Locate(PrimaryKey, KeyValue, []);
      TStringGrid(FGrid.dbGrid).Col := FieldCol;
    end;

  finally
    FreeAndNil(TablenameList);
  end;
end;

procedure TfrmSqlEditor.GridHeaderClick(Column: TColumn);
var
  StartTime: TTime;
  EndTime  : TTime;
  Sql: string;
  iPos: Integer;
begin
  iPos := Pos('order by', FLastSql);
  if iPos > 0 then
    Sql := copy(FLastSql, 1, iPos -1)
  else
    Sql := FLastSql;
  Sql := Sql + ' order by ' + Column.Field.FieldName;

  FSortAsc := not FSortAsc;

  if not FSortAsc then
    Sql := Sql + ' desc';


  Screen.Cursor := crHourGlass;
  try
    StartTime := now;
    if Pos('select', lowercase(FLastSql)) > 0 then
    begin
      if dm.Datenbank = cFirebird then
      begin
        dm.IBQuery.Transaction := dm.IBTransaction;
        dm.IBQuery.Close;
        dm.IBQuery.SQL.Text := Sql;
        dm.IBQuery.Open;
        dm.IBQuery.FetchAll;
        EndTime := now - StartTime;
        StatusBar.Panels[0].Text := 'Anzahl der Datensätze: ' + IntToStr(dm.IBQuery.RecordCount) + ' / Zeit: ' +  FormatDateTime('hh:nn:ss:zzzz', EndTime);
        FGrid.NewData := true;
      end;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;



function TfrmSqlEditor.ShowDataChange(aTablename, aFieldname, aKeyFieldName,
  aValue: string; aDataType, aKeyValue, aFieldLength: Integer): Boolean;
var
  Form: Tfrm_DataChange;
begin
  Form := Tfrm_DataChange.Create(nil);
  try
    Form.Tablename := aTablename;
    Form.Fieldname := aFieldname;
    Form.KeyFieldname := aKeyFieldName;
    Form.Value := aValue;
    Form.DataType := aDataType;
    Form.FieldLength := aFieldLength;
    Form.KeyValue    := aKeyValue;
    Form.ShowModal;
    Result := not Form.Cancel;
  finally
    FreeAndNil(Form);
  end;

end;


end.
