unit fntSqlEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, SynEdit, SynEditHighlighter,
  SynHighlighterSQL, tbSqlHighlighter;


type
  TF1Event = procedure(Sender: TObject; aTableName: string) of object;

  TfrmSqlEdit = class(TForm)
    SynSQLSyn: TSynSQLSyn;
    SynEditx: TSynEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SynEditxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure SynEditxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure SynEditxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    FPath: string;
    FSqlFile: string;
    FOnF1: TF1Event;
    FOnF2: TNotifyEvent;
    FSqlHighlighter: TtbSqlHighlighter;
    FOnTableNameSelected: TF1Event;
    FOnTableNameNotSelected: TNotifyEvent;
    FOnNewSqlTextLoaded: TNotifyEvent;
    procedure DeleteComment(aSql: TStrings);
    function GetTablenameFromEditor: string;
    function getWordOnTextPos: string;
  public
    function GetSqlText: string;
    function GetTextPosEnd(aStartPoint: TPoint): TPoint;
    function GetTextPosStart(aStartPoint: TPoint): TPoint;
    procedure LoadSqlText(aFullFileName: string);
    procedure SaveSqlText(aFullFileName: string);
    property OnF1: TF1Event read FOnF1 write FOnF1;
    property OnF2: TNotifyEvent read FOnF2 write FOnF2;
    property OnTableNameSelected: TF1Event read FOnTableNameSelected write FOnTableNameSelected;
    property OnTableNameNotSelected: TNotifyEvent read FOnTableNameNotSelected write FOnTableNameNotSelected;
    procedure AddTableNamesToHighlighter(aTablenameList: TStrings);
    procedure LoadTableListFromSqlText(aTablenameList: TStrings);
    property OnNewSqlTextLoaded: TNotifyEvent read FOnNewSqlTextLoaded write FOnNewSqlTextLoaded;
  end;

var
  frmSqlEdit: TfrmSqlEdit;

implementation

{$R *.dfm}

uses
  nf_System;

procedure TfrmSqlEdit.FormCreate(Sender: TObject);
begin
  {
  SynSQLSyn.KeyAttri.Foreground := clGreen;
  SynSqlSyn.CommentAttri.Foreground := clNavy;
  SynSqlSyn.CommentAttri.Style := SynSqlSyn.CommentAttri.Style + [fsItalic];
  SynSqlSyn.NumberAttri.Foreground := clFuchsia;
  SynSqlSyn.StringAttri.Foreground := clBlue;
  SynSqlSyn.SymbolAttri.Foreground := $000080FF;
  SynSqlSyn.SymbolAttribute.Foreground := clMaroon;
  SynSqlSyn.TableNameAttri.Foreground := clRed;
  }

  FSqlHighlighter := TtbSqlHighlighter.Create(Self);
  FSqlHighlighter.KeyAttri.Foreground := clGreen;
  FSqlHighlighter.CommentAttri.Style := SynSqlSyn.CommentAttri.Style + [fsItalic];
  FSqlHighlighter.NumberAttri.Foreground := clFuchsia;
  FSqlHighlighter.StringAttri.Foreground := clBlue;
  FSqlHighlighter.SymbolAttri.Foreground := $000080FF;
  FSqlHighlighter.SymbolAttribute.Foreground := clMaroon;
  FSqlHighlighter.TableNameAttri.Foreground := clRed;

  SynEditx.Highlighter := FSqlHighlighter;

  FPath := IncludeTrailingPathDelimiter(nf_GetShellFolder(26)) + 'SqlEditor\';
  SynEditx.Clear;
end;

procedure TfrmSqlEdit.FormDestroy(Sender: TObject);
begin
  //SaveSqlText(FSqlFile);
end;


function TfrmSqlEdit.GetSqlText: string;
var
  EndPoint  : TPoint;
  StartPoint: TPoint;
  s : string;
  s1: string;
  i1: Integer;
  Sql: TStringList;
  iPos: Integer;
  iStartPos: Integer;
  iEndPos: Integer;
begin
  StartPoint.X := SynEditx.CaretX;
  StartPoint.Y := SynEditx.CaretY-1;

  EndPoint   := GetTextPosEnd(StartPoint);
  StartPoint := GetTextPosStart(StartPoint);

  Sql := TStringList.Create;
  try
    s := '';
    for i1 := StartPoint.Y to EndPoint.Y do
    begin
      s1 := SynEditx.Lines[i1];
      if (i1 = StartPoint.Y) and (i1 <> EndPoint.Y) then
          s1 := copy(s1, StartPoint.X, Length(s1));
      if (i1 <> StartPoint.Y) and (i1 = EndPoint.Y) then
          s1 := copy(s1, 1, EndPoint.X);
      if (i1 = StartPoint.Y) and (i1 = EndPoint.Y) then
          s1 := copy(s1, StartPoint.X, EndPoint.X);
      Sql.Add(s1);
    end;
    DeleteComment(Sql);
    for i1 := 0 to Sql.Count - 1 do
    begin
      s := s + Sql.Strings[i1] + ' ';
    end;
    (*
    iPos := Pos('}', s);
    while iPos > 0 do
    begin
      Delete(s, 1, iPos);
      iPos := Pos('}', s);
    end;
     *)

    iPos := Pos('{', s);
    while iPos > 0 do
    begin
      iStartPos := iPos;
      iEndPos   := Pos('}', s);
      if iEndPos <= 0 then
      begin
        s := copy(s, 1, iPos-1);
        break;
      end;
      s := copy(s, 1, iStartPos-1) + copy(s, iEndPos+1, length(s));
      iPos := Pos('{', s);
    end;

    iPos := Pos('/*', s);
    while iPos > 0 do
    begin
      iStartPos := iPos;
      iEndPos   := Pos('*/', s);
      if iEndPos <= 0 then
      begin
        s := copy(s, 1, iPos-1);
        break;
      end;
      s := copy(s, 1, iStartPos-1) + copy(s, iEndPos+2, length(s));
      iPos := Pos('/*', s);
    end;

  finally
    FreeAndNil(Sql);
  end;

  s := Trim(StringReplace(s, ';', '', [rfReplaceAll]));

  Result := s;
end;


procedure TfrmSqlEdit.AddTableNamesToHighlighter(aTablenameList: TStrings);
begin
  FSqlHighlighter.TableNames.Clear;
  FSqlHighlighter.TableNames.AddStrings(aTablenameList);
end;


procedure TfrmSqlEdit.DeleteComment(aSql: TStrings);
var
  i1: Integer;
  iPos: Integer;
  s: string;
begin
  for i1 := 0 to aSql.Count - 1 do
  begin
    iPos := Pos('//', aSql.Strings[i1]);
    if iPos > 0 then
    begin
      s := aSql.Strings[i1];
      Delete(s, iPos, Length(s));
      aSql.Strings[i1] := s;
    end;
    iPos := Pos('--', aSql.Strings[i1]);
    if iPos > 0 then
    begin
      s := aSql.Strings[i1];
      Delete(s, iPos, Length(s));
      aSql.Strings[i1] := s;
    end;
  end;
end;


function TfrmSqlEdit.GetTextPosStart(aStartPoint: TPoint): TPoint;
var
  y    : Integer;
  iPos : Integer;
  i1   : Integer;
  s    : string;
begin
  iPos := 0;
  Result.X := 0;
  Result.Y := 0;
  y      := aStartPoint.Y;
  if Y > SynEditx.Lines.Count -1 then
    y := SynEditx.Lines.Count -1;
  for i1 := y downto 0 do
  begin
    s := SynEditx.Lines[i1];
    if i1 = y then
      Delete(s, aStartPoint.X, Length(SynEditx.Lines[i1]));
    iPos := LastDelimiter(';', s);
    if iPos > 0 then
      break;
  end;

  if i1 = -1 then
    i1 := 0;

  Result.Y := i1;
  Result.X := iPos;
end;



procedure TfrmSqlEdit.LoadSqlText(aFullFileName: string);
begin
  SynEditx.Clear;
  SynEditx.ClearAll;
  FSqlFile := aFullFileName;
  if FileExists(FSQlFile) then
    SynEditx.Lines.LoadFromFile(FSqlFile);
  {
  if Assigned(FOnNewSqlTextLoaded) then
    FOnNewSqlTextLoaded(Self);
  }
end;

procedure TfrmSqlEdit.LoadTableListFromSqlText(aTablenameList: TStrings);
var
  List: TStringList;
  i1, i2: Integer;
begin
  List := TStringList.Create;
  try
    aTablenameList.Clear;
    List.DelimitedText := GetSqlText;
    for i1 := 0 to List.Count -1 do
    begin
      for i2 := 0 to FSqlHighlighter.TableNames.Count -1 do
      begin
        if SameText(List.Strings[i1], FSqlHighlighter.TableNames.Strings[i2]) then
        begin
          aTablenameList.Add(Uppercase(List.Strings[i1]));
          break;
        end;
      end;
    end;
  finally
    FreeAndNil(List);
  end;
end;

procedure TfrmSqlEdit.SaveSqlText(aFullFileName: string);
var
  FileName: string;
  FileNameWithoutExt: string;
  iPos: Integer;
  BackupPath: string;
  BackUpFile: string;
begin
  if aFullFileName = '' then
    exit;
  FileName := ExtractFileName(aFullFileName);
  iPos     := LastDelimiter('.', FileName);
  FileNameWithoutExt := copy(FileName, 1, ipos-1);
  BackUpPath := IncludeTrailingPathDelimiter(ExtractFilePath(aFullFileName)) + 'Backup';
  if not DirectoryExists(BackupPath) then
    ForceDirectories(BackUpPath);
  BackUpPath := IncludeTrailingPathDelimiter(BackUpPath);
  BackUpFile := BackUpPath + FileNameWithoutExt + '_' + FormatDateTime('yymmddhhnnss', now) + '.bak';
  CopyFile(PWideChar(aFullFileName), PWideChar(BackUpFile), false);
  SynEditx.Lines.SaveToFile(aFullFileName);
end;

procedure TfrmSqlEdit.SynEditxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Tablename: string;
begin
  Tablename := '';
  {
  if Assigned(FOnTableNameSelected)then
  begin
    Tablename := GetTablenameFromEditor;
    if TableName > '' then
      FOnTableNameSelected(Self, Tablename)
    else
    begin
      if Assigned(FOnTableNameNotSelected) then
        FOnTableNameNotSelected(Self);
    end;
  end;
  }
  if Key = VK_F1 then
  begin
    if Tablename = '' then
      Tablename := GetTablenameFromEditor;
    if (Tablename > '') and (Assigned(FOnF1)) then
    begin
      FOnF1(Self, Tablename);
    end;
  end;

  if Key = VK_F2 then
  begin
    if Assigned(FOnF2) then
      FOnF2(Self);
  end;


end;

procedure TfrmSqlEdit.SynEditxKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Tablename: string;
begin
  Tablename := '';
  if Assigned(FOnTableNameSelected)then
  begin
    Tablename := GetTablenameFromEditor;
    if TableName > '' then
      FOnTableNameSelected(Self, Tablename)
    else
    begin
      if Assigned(FOnTableNameNotSelected) then
        FOnTableNameNotSelected(Self);
    end;
  end;
end;

procedure TfrmSqlEdit.SynEditxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Tablename: string;
begin
  Tablename := '';
  if Assigned(FOnTableNameSelected)then
  begin
    Tablename := GetTablenameFromEditor;
    if TableName > '' then
      FOnTableNameSelected(Self, Tablename)
    else
    begin
      if Assigned(FOnTableNameNotSelected) then
        FOnTableNameNotSelected(Self);
    end;
  end;
end;

function TfrmSqlEdit.GetTablenameFromEditor: string;
var
  i1: Integer;
begin
  Result := getWordOnTextPos;
  Result := StringReplace(Result, ';' , '', [rfReplaceAll]);
  for i1 := 0 to FSqlHighlighter.TableNames.Count -1 do
  begin
    if SameText(Result, FSqlHighlighter.TableNames.Strings[i1]) then
      exit;
  end;
  Result := '';
end;

function TfrmSqlEdit.getWordOnTextPos: string;
var
  P: TPoint;
//  EndPoint  : TPoint;
//  StartPoint: TPoint;
  LeftPos: Integer;
  RightPos: Integer;
begin
  Result := '';
  P.X := SynEditx.CaretX;
  P.Y := SynEditx.CaretY-1;

  LeftPos := P.X;

  if SynEditx.Lines[P.Y] = '' then
    exit;
  if Length(SynEditx.Lines[P.Y]) < P.X then
    exit;


  while LeftPos > 0 do
  begin
    if SynEditx.Lines[P.Y][LeftPos] = ' ' then
      break;
    dec(LeftPos);
  end;

  RightPos := P.X;
  while RightPos > 0 do
  begin
    if (SynEditx.Lines[P.Y][RightPos] = ' ') or (SynEditx.Lines[P.Y][RightPos] = '') then
      break;
    inc(RightPos);
  end;

  Result := Trim(copy(SynEditx.Lines[P.Y], LeftPos, RightPos-LeftPos));


end;

function TfrmSqlEdit.GetTextPosEnd(aStartPoint: TPoint): TPoint;
var
  y    : Integer;
  iPos : Integer;
  i1   : Integer;
  s    : string;
begin
  iPos := 0;
  Result.X := 0;
  Result.Y := 0;
  y      := aStartPoint.Y;
  if Y > SynEditx.Lines.Count -1 then
    y := SynEditx.Lines.Count -1;

  for i1 := y to SynEditx.Lines.Count - 1 do
  begin
    s := SynEditx.Lines[i1];
    if i1 = y then
      Delete(s, 1, aStartPoint.X);
    iPos := Pos(';', s);
    if iPos > 0 then
    begin
      if i1 = y then
        iPos := iPos + aStartPoint.X;
      break;
    end;
  end;
  Result.Y := i1;
  if iPos > 0 then
    Result.X := iPos
  else
    Result.X := Length(SynEditx.Lines[SynEditx.Lines.Count - 1]);

end;


end.
