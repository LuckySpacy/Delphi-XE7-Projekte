unit fntConnectIB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvGlowButton, Vcl.StdCtrls, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.Samples.Spin;

type
  TfrmConnectIB = class(TForm)
    ImageList1: TImageList;
    GroupBox1: TGroupBox;
    Label5: TLabel;
    cbx_DBName: TComboBox;
    GroupBox2: TGroupBox;
    lbl_Laufwerksbuchstaben: TLabel;
    lbl_Server: TLabel;
    lbl_Verzeichnis: TLabel;
    lbl_Datenbankname: TLabel;
    cbb_Laufwerk: TComboBox;
    edt_Server: TEdit;
    edt_Verzeichnis: TEdit;
    edt_Datenbank: TEdit;
    GroupBox3: TGroupBox;
    cmd_Cancel: TButton;
    cmd_Ok: TButton;
    GroupBox4: TGroupBox;
    cmdNew: TButton;
    btn_Copy: TButton;
    btn_Delete: TButton;
    btn_DatabaseCheck: TButton;
    GroupBox5: TGroupBox;
    rb_Firebird: TRadioButton;
    rb_MSSql: TRadioButton;
    rb_MySql: TRadioButton;
    lbl_Benutzername: TLabel;
    lbl_Passwort: TLabel;
    edt_User: TEdit;
    edt_Passwort: TEdit;
    Label1: TLabel;
    edt_Port: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cbx_DBNameChange(Sender: TObject);
    procedure cmdNewClick(Sender: TObject);
    procedure cmd_CancelxClick(Sender: TObject);
    procedure cmd_OkxClick(Sender: TObject);
    procedure btn_CopyClick(Sender: TObject);
    procedure btn_DeleteClick(Sender: TObject);
    procedure btn_DatabaseCheckClick(Sender: TObject);
    procedure DatenbankClick(Sender: TObject);
  private
    FIniFile: String;
    FPath: string;
    FOk  : Boolean;
    FDBListName: string;
    FDBList: TStringList;
    procedure ShowNewConnectIB(aCopy: Boolean);
    procedure LoadINI;
    procedure SelectDatabasename(aName: string);
    procedure SetEditFelder;
    function Save: Boolean;
    function CopyEditFieldsToDBIniObj: Boolean;
  public
    class function ShowConnect(AOwner: TComponent): Boolean;
  end;

var
  frmConnectIB: TfrmConnectIB;

implementation

{$R *.dfm}

uses
  nf_System, nf_RegIni, DataModul, fntNewConnectIB, o_dbiniobj, c_types;

{ TfrmConnectIB }



procedure TfrmConnectIB.FormCreate(Sender: TObject);
begin
  edt_Server.Text      := '';
  edt_Verzeichnis.Text := '';
  edt_User.Text := '';
  edt_Passwort.Text := '';
  FOk      := false;
  FPath    := IncludeTrailingPathDelimiter(nf_GetShellFolder(26)) + 'SqlEditor\';
  FIniFile := FPath + 'SqlEditor.ini';
  FDBListName := FPath + 'DatabaseList.txt';
  FDBList  := TStringList.Create;
  FDBList.Duplicates := dupIgnore;
  FDBList.Sorted     := true;
  FDBList.LoadFromFile(FDBListName);
  //cbx_DBName.Items.AddStrings(FDBList);
  dm.DBIni.LoadDatabasenamelist(cbx_DBName.Items);
  if cbx_DBName.Items.Count > 0 then
    cbx_DBName.ItemIndex := 0;
end;

procedure TfrmConnectIB.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FDBList);
end;

procedure TfrmConnectIB.FormShow(Sender: TObject);
//var
 // DBIniObj: TDBIniObj;
 // i1: Integer;
begin
  DM.IBDatabase.Connected := false;
  SelectDatabasename(dm.DBIni.CurSectionName);
  {
  DBIniObj := dm.DBIni.getSection(dm.DBIni.CurSectionName);

  edt_Server.Text        := '';
  cbb_Laufwerk.ItemIndex := -1;
  edt_Verzeichnis.Text   := '';
  edt_Datenbank.Text     := '';

  if DBIniObj = nil then
    exit;

  SelectDatabaseName(dm.DBIni.CurSectionName);

  edt_Server.Text        := dbIniObj.Server;
  cbb_Laufwerk.ItemIndex := StrToInt(dbIniObj.Laufwerk);
  edt_Verzeichnis.Text   := dbIniObj.Verzeichnis;
  edt_Datenbank.Text     := dbIniObj.Datenbankname;
  }
  {
  edt_Server.Text        := nf_ReadIni(FIniFile, 'DatabaseIB', 'Server', '');
  cbb_Laufwerk.ItemIndex := nf_ReadIniToInt(FIniFile, 'DatabaseIB', 'Laufwerk', '-1');
  edt_Verzeichnis.Text   := nf_ReadIni(FIniFile, 'DatabaseIB', 'Verzeichnis', '');
  edt_Datenbank.Text     := nf_ReadIni(FIniFile, 'DatabaseIB', 'Datenbankname', '');
  }
end;

procedure TfrmConnectIB.btn_CopyClick(Sender: TObject);
begin
  ShowNewConnectIB(true);
end;

procedure TfrmConnectIB.btn_DatabaseCheckClick(Sender: TObject);
var
  Laufwerk: string;
  DBIniObj: TDBIniObj;
begin
  Laufwerk := cbb_Laufwerk.Items[cbb_Laufwerk.ItemIndex];
  if rb_Firebird.Checked then
  begin
    dm.ADOConnect.Connected := false;
    dm.IBDatabase.Connected := false;
    dm.MySqlConnect.Connected := false;
    DM.IBDatabase.DatabaseName := edt_Server.Text + ':' + Laufwerk + '\' + edt_Verzeichnis.Text + '\' + edt_Datenbank.Text;
    if DM.ConnectIB then
      ShowMessage('Verbindung konnte hergestellt werden.');
  end;
  if rb_MSSql.Checked then
  begin
    if not CopyEditFieldsToDBIniObj then
      exit;
    dm.IBDatabase.Connected := false;
    dm.ADOConnect.Connected := false;
    dm.MySqlConnect.Connected := false;
    dm.ADOConnect.ConnectionString := dm.getAdoconnectStr(cbx_DBName.Text);
    try
      dm.ADOConnect.Connected := true;
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    end;
    ShowMessage('Verbindung konnte hergestellt werden.');
  end;
  if rb_MySql.Checked then
  begin
    if not CopyEditFieldsToDBIniObj then
      exit;
    dm.IBDatabase.Connected := false;
    dm.ADOConnect.Connected := false;
    dm.MySqlConnect.Connected := false;
    try
      DBIniObj := dm.DBIni.getSection(cbx_DBName.Text);
      if DBIniObj <> nil then
      begin
        dm.MySqlConnect.Host := DBIniObj.Server;
        dm.MySqlConnect.DatabaseName := DBIniObj.Datenbankname;
        dm.MySqlConnect.UserName     := DBIniObj.Benutzer;
        dm.MySqlConnect.UserPassword := DBIniObj.Passwort;

        if dm.MySqlConnect.Port > -1 then
          dm.MySqlConnect.Port := DBIniObj.Port;
      end;
      dm.MySqlConnect.Connected := true;
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        exit;
      end;
    end;
    ShowMessage('Verbindung konnte hergestellt werden.');
  end;
end;

procedure TfrmConnectIB.btn_DeleteClick(Sender: TObject);
var
  DBIniObj: TDBIniObj;
  SectionName: string;
begin
  SectionName := '';
  if cbx_DBName.Items.Count > 0 then
    SectionName := cbx_DBName.Items[0];
  DBIniObj := dm.DBIni.getSection(cbx_DBName.Text);
  if DBIniObj = nil then
    exit;
  if MessageDlg('Möchten Sie wirklich löschen?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    exit;
  dm.DBIni.Delete(DBIniObj);
  dm.DBIni.LoadDatabasenamelist(cbx_DBName.Items);
  SelectDatabasename(Sectionname);
end;

procedure TfrmConnectIB.cbx_DBNameChange(Sender: TObject);
begin
  LoadIni;
end;

procedure TfrmConnectIB.cmdNewClick(Sender: TObject);
begin
  ShowNewConnectIB(false);
end;

procedure TfrmConnectIB.cmd_CancelxClick(Sender: TObject);
begin
  close;
end;

procedure TfrmConnectIB.cmd_OkxClick(Sender: TObject);
begin
  if not Save then
    exit;
  close;
end;

function TfrmConnectIB.CopyEditFieldsToDBIniObj: Boolean;
var
  Laufwerk: string;
  DBIniObj: TDBIniObj;
begin
  Result := false;
  if rb_Firebird.Checked then
  begin
    if cbb_Laufwerk.ItemIndex = -1 then
    begin
      ShowMessage('Bitte den Laufwerksbuchstaben auswählen');
      exit;
    end;
  end;
  Laufwerk := cbb_Laufwerk.Items[cbb_Laufwerk.ItemIndex];
  if cbx_DBName.ItemIndex < 0 then
    exit;
  DBIniObj := dm.DBIni.getSection(cbx_DBName.Text);
  if DBIniObj = nil then
    exit;
  DBIniObj.Server := edt_Server.Text;
  DBIniObj.LaufwerkIndex := cbb_Laufwerk.ItemIndex;
  DBIniObj.Verzeichnis := edt_Verzeichnis.Text;
  DBIniObj.Datenbankname := edt_Datenbank.Text;
  DBIniObj.Port := edt_Port.Value;
  if rb_Firebird.Checked then
    DBIniObj.Datenbank := cFirebird;
  if rb_MSSql.Checked then
    DBIniObj.Datenbank := cMsSql;
  if rb_MySql.Checked then
    DBIniObj.Datenbank := cMySql;
  DBIniObj.Benutzer := edt_User.Text;
  DBIniObj.Passwort := edt_Passwort.Text;
  Result := true;
end;

function TfrmConnectIB.Save: Boolean;
var
  Laufwerk: string;
  DBIniObj: TDBIniObj;
begin
  Result := false;
  if not CopyEditFieldsToDBIniObj then
    exit;
  Laufwerk := cbb_Laufwerk.Items[cbb_Laufwerk.ItemIndex];
  if rb_Firebird.Checked then
  begin
    dm.IBDatabase.Connected := false;
    dm.ADOConnect.Connected := false;
    dm.MySqlConnect.Connected := false;
    DM.IBDatabase.DatabaseName := edt_Server.Text + ':' + Laufwerk + '\' + edt_Verzeichnis.Text + '\' + edt_Datenbank.Text;
    if not DM.ConnectIB(cbx_DBName.Text) then
      exit;
  end;
  FOk := true;
  if cbx_DBName.ItemIndex < 0 then
    exit;

  DBIniObj := dm.DBIni.getSection(cbx_DBName.Text);
  if DBIniObj = nil then
    exit;

  if rb_MSSql.Checked then
  begin
    dm.MySqlConnect.Connected := false;
    dm.IBDatabase.Connected   := false;
    dm.ADOConnect.Connected   := false;
    try
      dm.ConnectAdo(cbx_DBName.Text);
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        Result := false;
        exit;
      end;
    end;
  end;

  if rb_MYSql.Checked then
  begin
    dm.MySqlConnect.Connected := false;
    dm.IBDatabase.Connected   := false;
    dm.ADOConnect.Connected   := false;
    try
      dm.ConnectMySql(cbx_DBName.Text);
    except
      on E:Exception do
      begin
        ShowMessage(E.Message);
        Result := false;
        exit;
      end;
    end;
  end;

  dm.DBIni.Save(DBIniObj);
  dm.DBIni.CurSectionName := DBIniObj.Section;
  Result := true;
end;


procedure TfrmConnectIB.DatenbankClick(Sender: TObject);
begin
  SetEditFelder;
end;

procedure TfrmConnectIB.LoadINI;
var
  IniObj: TDBIniObj;
begin
  edt_Server.Text        := '';
  cbb_Laufwerk.ItemIndex := -1;
  edt_Verzeichnis.Text   := '';
  edt_Datenbank.Text     := '';
  edt_Port.Value := -1;
  if cbx_DBName.ItemIndex < 0 then
    exit;
  IniObj := dm.DBIni.getSection(cbx_DBName.Text);
  if IniObj = nil then
    exit;
  edt_Server.Text        := IniObj.Server;
  cbb_Laufwerk.ItemIndex := IniObj.LaufwerkIndex;
  edt_Verzeichnis.Text   := IniObj.Verzeichnis;
  edt_Datenbank.Text     := IniObj.Datenbankname;
  edt_Port.Value         := IniObj.Port;

  if IniObj.Datenbank = cFirebird then
    rb_Firebird.Checked := true;
  if IniObj.Datenbank = cMsSql then
    rb_MsSql.Checked := true;
  if IniObj.Datenbank = cMySql then
    rb_MySql.Checked := true;

  edt_User.Text := IniObj.Benutzer;
  edt_Passwort.Text := IniObj.Passwort;

  SetEditFelder;

  {
  edt_Server.Text        := nf_ReadIni(FIniFile, cbx_DBName.Text, 'Server', '');
  cbb_Laufwerk.ItemIndex := nf_ReadIniToInt(FIniFile, cbx_DBName.Text, 'Laufwerk', '-1');
  edt_Verzeichnis.Text   := nf_ReadIni(FIniFile, cbx_DBName.Text, 'Verzeichnis', '');
  edt_Datenbank.Text     := nf_ReadIni(FIniFile, cbx_DBName.Text, 'Datenbankname', '');
  }
end;




procedure TfrmConnectIB.SelectDatabasename(aName: string);
var
  i1: Integer;
begin
  for i1 := 0 to cbx_DBName.Items.Count -1 do
  begin
    if SameText(cbx_DBName.Items[i1], aName) then
    begin
      cbx_DBName.ItemIndex := i1;
      LoadINI;
      exit;
    end;
  end;
end;

procedure TfrmConnectIB.SetEditFelder;
begin
  edt_Server.Enabled      := true;
  edt_Verzeichnis.Enabled := true;
  edt_Datenbank.Enabled   := true;
  edt_User.Enabled        := true;
  edt_Passwort.Enabled    := true;
  cbb_Laufwerk.Enabled    := true;
  edt_Port.Enabled        := true;


  lbl_Server.Enabled := true;
  lbl_Laufwerksbuchstaben.Enabled := true;
  lbl_Verzeichnis.Enabled := true;
  lbl_Datenbankname.Enabled := true;
  lbl_Benutzername.Enabled := true;
  lbl_Passwort.Enabled := true;

  if rb_Firebird.Checked then
  begin
    lbl_Benutzername.Enabled := false;
    edt_User.Enabled         := false;
    lbl_Passwort.Enabled     := false;
    edt_Passwort.Enabled     := false;
    edt_Port.Enabled := false;
  end;


  if rb_MSSql.Checked then
  begin
    lbl_Laufwerksbuchstaben.Enabled := false;
    lbl_Verzeichnis.Enabled := false;
    cbb_Laufwerk.Enabled := false;
    edt_Verzeichnis.Enabled := false;
    edt_Port.Enabled := false;
  end;

  if rb_MySql.Checked then
  begin
    lbl_Laufwerksbuchstaben.Enabled := false;
    lbl_Verzeichnis.Enabled := false;
    cbb_Laufwerk.Enabled := false;
    edt_Verzeichnis.Enabled := false;
    edt_Port.Enabled := true;
  end;


end;

class function TfrmConnectIB.ShowConnect(AOwner: TComponent): Boolean;
var
  Form: TfrmConnectIB;
begin
  Form := TfrmConnectIB.Create(AOwner);
  try
    Form.ShowModal;
    Result := Form.FOk;
  finally
    FreeAndNil(Form);
  end;
end;

procedure TfrmConnectIB.ShowNewConnectIB(aCopy: Boolean);
var
  Form: TfrmNewConnectIB;
  MerkeIndex: Integer;
begin
  Form := TfrmNewConnectIB.Create(Self);
  try
    if aCopy then
    begin
      Form.edt_Server.Text := edt_Server.Text;
      Form.edt_Verzeichnis.Text := edt_Verzeichnis.Text;
      Form.edt_Datenbank.Text   := edt_Datenbank.Text;
      Form.cbb_Laufwerk.ItemIndex := cbb_Laufwerk.ItemIndex;
      Form.edt_Port.Value := edt_Port.Value;
    end;
    Form.ShowModal;
    MerkeIndex := cbx_dbname.ItemIndex;
    FDBList.LoadFromFile(FDBListName);
    cbx_DBName.Clear;
    cbx_DBName.Items.AddStrings(FDBList);
    if (MerkeIndex < cbx_DBName.Items.Count) then
    begin
      cbx_DBName.ItemIndex := MerkeIndex;
      LoadINI;
    end;
    if not Form.Cancel then
      SelectDatabasename(Form.edt_DBName.Text);
  finally
    FreeAndNil(Form);
  end;
  edt_Server.SetFocus;
end;

end.
