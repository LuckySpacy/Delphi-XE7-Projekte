unit fntNewConnectIB;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin;

type
  TfrmNewConnectIB = class(TForm)
    GroupBox1: TGroupBox;
    cmd_Cancel: TButton;
    cmd_Save: TButton;
    GroupBox2: TGroupBox;
    lbl_Name: TLabel;
    edt_DBName: TEdit;
    GroupBox3: TGroupBox;
    lbl_Laufwerksbuchstaben: TLabel;
    cbb_Laufwerk: TComboBox;
    lbl_Server: TLabel;
    edt_Server: TEdit;
    lbl_Verzeichnis: TLabel;
    edt_Verzeichnis: TEdit;
    Label4: TLabel;
    edt_Datenbank: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    edt_User: TEdit;
    edt_Passwort: TEdit;
    GroupBox5: TGroupBox;
    rb_Firebird: TRadioButton;
    rb_MSSql: TRadioButton;
    rb_MySql: TRadioButton;
    Label1: TLabel;
    edt_Port: TSpinEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cmd_CancelClick(Sender: TObject);
    procedure cmd_SaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DatenbankClick(Sender: TObject);
  private
    FCancel: Boolean;
    //FPath: string;
    //FDBListName: string;
    //FDBList: TStringList;
    procedure SetEditFelder;
  public
    property Cancel: Boolean read FCancel;
  end;

var
  frmNewConnectIB: TfrmNewConnectIB;

implementation

{$R *.dfm}

uses
  nf_System, nf_RegIni, DataModul, o_dbiniobj, c_Types;



procedure TfrmNewConnectIB.FormCreate(Sender: TObject);
begin
  edt_Server.Text := '';
  cbb_Laufwerk.ItemIndex := 2;
  edt_Verzeichnis.Text := '';
  edt_Datenbank.Text   := '';
  edt_User.Text := '';
  edt_Passwort.Text := '';
  edt_Port.Value := -1;
  rb_Firebird.Checked := true;
  FCancel := true;
  //FPath       := IncludeTrailingPathDelimiter(nf_GetShellFolder(26)) + 'SqlEditor\';
  //FDBListName := FPath + 'DatabaseList.txt';
  //FDBList     := TStringList.Create;
  //FDBList.LoadFromFile(FDBListName);
end;

procedure TfrmNewConnectIB.FormDestroy(Sender: TObject);
begin
  //FreeAndNil(FDBList);
end;


procedure TfrmNewConnectIB.FormShow(Sender: TObject);
begin
  edt_DBName.SetFocus;
end;

procedure TfrmNewConnectIB.SetEditFelder;
begin
  edt_Server.Enabled      := true;
  edt_Verzeichnis.Enabled := true;
  edt_Datenbank.Enabled   := true;
  edt_User.Enabled        := true;
  edt_Passwort.Enabled    := true;
  cbb_Laufwerk.Enabled    := true;
  edt_Port.Enabled        := false;
  lbl_Server.Enabled := true;
  lbl_Laufwerksbuchstaben.Enabled := true;
  lbl_Verzeichnis.Enabled := true;
  Label4.Enabled := true;
  Label6.Enabled := true;
  Label7.Enabled := true;

  if rb_MSSql.Checked then
  begin
    lbl_Laufwerksbuchstaben.Enabled := false;
    lbl_Verzeichnis.Enabled := false;
    cbb_Laufwerk.Enabled := false;
    edt_Verzeichnis.Enabled := false;
  end;

  if rb_MySql.Checked then
  begin
    edt_Port.Enabled := true;
    lbl_Laufwerksbuchstaben.Enabled := false;
    cbb_Laufwerk.Enabled := false;
    lbl_Verzeichnis.Enabled := false;
    edt_Verzeichnis.Enabled := false;
  end;

end;

procedure TfrmNewConnectIB.cmd_CancelClick(Sender: TObject);
begin
  close;
end;


procedure TfrmNewConnectIB.cmd_SaveClick(Sender: TObject);
var
  DBIniObj: TDBIniObj;
begin
  //FDBList.Add(edt_DBName.Text);
  //FDBList.SaveToFile(FDBListName);
  dm.DBIni.AddNewDatabasename(edt_DBName.Text);
  DBIniObj := dm.DBIni.AddDBIniObj;
  DBIniObj.Section := edt_DBName.Text;
  DBIniObj.Server   := edt_Server.Text;
  DBIniObj.LaufwerkIndex := cbb_Laufwerk.ItemIndex;
  DBIniObj.Verzeichnis := edt_Verzeichnis.Text;
  DBIniObj.Datenbankname := edt_Datenbank.Text;
  DBIniObj.Benutzer      := edt_User.Text;
  DBIniObj.Passwort      := edt_Passwort.Text;
  DBIniObj.Port          := edt_Port.Value;

  if rb_Firebird.Checked then
    DBIniObj.Datenbank := cFirebird;
  if rb_MSSql.Checked then
    DBIniObj.Datenbank := cMsSql;
  if rb_MySql.Checked then
  begin
    DBIniObj.Datenbank := cMySql;
    if DBIniObj.Port < 0 then
      DBIniObj.Port := 3306;
  end;

  dm.DBIni.Save(DBIniObj);
  FCancel := false;
  close;
end;



procedure TfrmNewConnectIB.DatenbankClick(Sender: TObject);
begin
  SetEditFelder;
end;

end.
